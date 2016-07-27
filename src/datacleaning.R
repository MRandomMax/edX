#data cleaning
#


setwd('~/Desktop/EDX/newdata/')

# load library
library(dplyr)
library(tidyr)
library(ggplot2)
library(jsonlite)
library(stringr)
library(plotly)
library(lubridate)

load('auth_userprofile.Rdata')
load('certificates_generatedcertificate.Rdata')
load('courseware_studentmodule.Rdata')
load('student_anonymoususerid.Rdata')
load('student_courseenrollment.Rdata')
load('student_languageproficiency.Rdata')
load('auth_user.Rdata')


#start with auth_userprofile
student.data=auth_userprofile[,c(-4,-5,-6,-7,-13,-15)]
names(student.data)[11]='image'


# gender
student.data$gender[student.data$gender!='f'&student.data$gender!='m'&student.data$gender!='o']=''

#mailing address
student.data$mailing_address[student.data$mailing_address=='NULL']=''
student.data$mailing_address[student.data$mailing_address!='']='1'

#year of birth
student.data$year_of_birth[student.data$year_of_birth=='NULL']=''

#all the 'NULL'
student.data[student.data=='NULL']=''

#goals
student.data$goals[student.data$goals!='']='1'

#bio
student.data$bio[student.data$bio!='']='1'

#image
student.data$image[student.data$image!='']='1'

#certificates generate
names(certificates_generatedcertificate)[c(3,7,10,11,12)]=c('certi.grade','certi.status','certi.created_date',
                                             'certi.modified_date','certi.mode')

student.data=left_join(student.data,certificates_generatedcertificate[c(2,3,7,10,11,12)],by='user_id')

#student_courseenrollemt
names(student_courseenrollment)[c(4,6)]=c('enroll.created','enroll.mode')


student.data=left_join(student.data,student_courseenrollment[c(2,4,5,6)],by='user_id')

#language
student_languageproficiency=student_languageproficiency[,c(2,3)]
languagecode=read.csv('languagecode.csv')

names(student_languageproficiency)[1]='id'

student_languageproficiency=left_join(student_languageproficiency,languagecode,by='code')

#transfer traditional chinese to chinese
student_languageproficiency$language[student_languageproficiency$code=='zh_HANT'|
                                       student_languageproficiency$code=='zh_HANS']='Chinese'

#ignore the following rows because of duplicated user_id
# select only one language according to the country
ignore=c(920,1130,1539,1541,1612,6539,6540,6575)
student_languageproficiency=student_languageproficiency[-ignore,]


student.data=left_join(student.data,student_languageproficiency[,c(1,3)],by='id')


#auth_user
names(auth_user)[1]='user_id'


student.data=left_join(student.data,auth_user[,c(1:10)],by='user_id')

student.data$language=as.character(student.data$language)


#courseware
courseware_studentmodule$grade=as.numeric(as.character(courseware_studentmodule$grade))

provideo=courseware_studentmodule%>%
  group_by(student_id)%>%
  summarise(problem.count=sum(module_id=='problem'),
            video.count=sum(module_id=='video'),
            problem.grade=sum(grade,na.rm=T))


names(provideo)[1]='user_id'

student.data=left_join(student.data,provideo,by='user_id')


student.data[is.na(student.data)]=''


save(student.data,file='student.data.Rdata')
write.csv(student.data,file='student.data.csv')
