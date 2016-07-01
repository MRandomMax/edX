rm(list=ls())
#setwd("/Users/Bianbian/Documents/Work/edX/DS101X-1T2016")
setwd("~/Desktop/EDX/data/ColumbiaX-DS101X-1T2016")
#########################
#List all .sql filenames 
#########################
#filenames<-list.files("/Users/Bianbian/Documents/Work/edX/DS101X-1T2016", pattern="*.sql")
filenames<-list.files("~/Desktop/EDX/data/ColumbiaX-DS101X-1T2016", pattern="*.sql")
fn<-gsub("-prod-analytics.sql","",gsub("ColumbiaX-DS101X-1T2016-","",filenames))

#######################################
# Read in these data 
#----
# Note: 
#1.Space delim
#2.Django gives blanks instead of nulls 



######################################
for (i in 1:length(filenames)){
  fni<-fn[i]
  df<-read.delim(filenames[i], sep="\t", skip =0, header = TRUE, 
                        comment.char = "",check.names = FALSE, quote="",
                        na.strings=c("NA","NaN", " "))
  df<-df[,!apply (is.na(df), 2, all)]
  assign(fni,df)
  rm(df)
}
# Rid of all NAs:
auth_user<-auth_user[,!apply (is.na(auth_user), 2, all)]

##SAVE

lead='~/Desktop/EDX/newdata/'

save(auth_userprofile,file=(paste0(lead,fn[2],".Rdata")))
save(certificates_generatedcertificate,file=(paste0(lead,fn[3],".Rdata")))
save(courseware_studentmodule,file=(paste0(lead,fn[4],".Rdata")))
save(student_anonymoususerid,file=(paste0(lead,fn[5],".Rdata")))
save(student_courseenrollment,file=(paste0(lead,fn[6],".Rdata")))
save(student_languageproficiency,file=(paste0(lead,fn[7],".Rdata")))
# save(teams,file=(paste0("/Users/Bianbian/Documents/Work/edX/R_file/",fn[8],".Rdata")))
# save(teams_membership,file=(paste0("/Users/Bianbian/Documents/Work/edX/R_file/",fn[9],".Rdata")))
# save(user_api_usercoursetag,file=(paste0("/Users/Bianbian/Documents/Work/edX/R_file/",fn[10],".Rdata")))
save(user_id_map,file=(paste0(lead,fn[11],".Rdata")))
# save(verify_student_verificationstatus,file=(paste0("/Users/Bianbian/Documents/Work/edX/R_file/",fn[12],".Rdata")))
# save(wiki_article,file=(paste0("/Users/Bianbian/Documents/Work/edX/R_file/",fn[13],".Rdata")))
<<<<<<< Updated upstream
# save(wiki_articlerevision,file=(paste0("/Users/Bianbian/Documents/Work/edX/R_file/",fn[14],".Rdata")))
=======
# save(wiki_articlerevision,file=(paste0("/Users/Bianbian/Documents/Work/edX/R_file/",fn[14],".Rdata")))

# b<- read.table(filenames[2], 
#                sep="\t", skip =0, header = TRUE, 
#                comment.char = "",check.names = FALSE, quote="",
#                na.strings=c("NA","NaN", " "))

courseware_studentmodule=ColumbiaX.DS101X.1T2016.courseware_studentmodule.prod.analytics <- read.delim2("~/Desktop/EDX/data/ColumbiaX-DS101X-1T2016/ColumbiaX-DS101X-1T2016-courseware_studentmodule-prod-analytics.sql", stringsAsFactors=FALSE)
save(courseware_studentmodule,file='courseware_studentmodule.Rdata')
>>>>>>> Stashed changes
