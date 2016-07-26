# decoding course structure for 3T2015
# created on July 25th

setwd('~/Desktop/EDX/newdata/')

course_map=read.csv('dic_map_df.csv')
course_structure=read.csv('course_structure.csv')

course_structure$chapter=as.character(course_structure$chapter)
course_map$parent=as.character(course_map$parent)


ch0='block-v1:ColumbiaX+DS101X+3T2015+type@chapter+block@07958a5e121d4b93a09f06b0b65c3eca'
ch1='block-v1:ColumbiaX+DS101X+3T2015+type@chapter+block@83b2b74597c44d858f1cd81edef2faf2'
ch2='block-v1:ColumbiaX+DS101X+3T2015+type@chapter+block@5c71f003d43e44b2b21a934df4dc6ca0'
ch3='block-v1:ColumbiaX+DS101X+3T2015+type@chapter+block@b84a36092df149b3ac988a9ae0371f38'
ch4='block-v1:ColumbiaX+DS101X+3T2015+type@chapter+block@b6eef8e797854299800464a9746eb309'
ch5='block-v1:ColumbiaX+DS101X+3T2015+type@chapter+block@e67a0123c18b42d1b0f7abedef7bca58'


course_structure['ch']='0'
course_structure$ch[course_structure$chapter==ch0]='0'
course_structure$ch[course_structure$chapter==ch1]='1'
course_structure$ch[course_structure$chapter==ch2]='2'
course_structure$ch[course_structure$chapter==ch3]='3'
course_structure$ch[course_structure$chapter==ch4]='4'
course_structure$ch[course_structure$chapter==ch5]='5'


course_structure=course_structure[order(course_structure$ch,course_structure$seq,course_structure$ver,decreasing = F),]


write.csv(course_structure,file='course_structure.csv')
