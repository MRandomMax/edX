### creted on July 25th
### decoding video
library(dplyr)
library(jsonlite)
library(stringr)

setwd('~/Desktop/EDX/newdata/')
load('courseware_studentmodule.Rdata')


video=filter(courseware_studentmodule,module_type=='video')
#314503 rows of data

video['posotion']=''
video['speed']=''

video$posotion=sapply(video$state,function(x) fromJSON(toString(x))$saved_video_position)
video$speed=sapply(video$state,function(x) fromJSON(toString(x))$speed)
video$posotion=as.character(video$posotion)
video$speed=as.character(video$speed)

write.csv(video,file='video.csv')
save(video,file='video.Rdata')
