# ###
# INPUT: Dataframe; courseware_studentmodule 
# OUTPUT: Dataframe; video, with speed and saved_video_position
# ###
parse_video<-function(data){
  library(dplyr)
  library(jsonlite)
  video<-data %>% filter(module_type=="video")
  video$position<-sapply(video$state,function(x) fromJSON(toString(x))$saved_video_position)
  video$position[sapply(video$position, is.null)]<-NA
  video$position<-unlist(video$position)
  
  video$speed<-sapply(video$state,function(x) fromJSON(toString(x))$speed)
  video$speed[sapply(video$speed, is.null)]<-NA
  video$speed<-unlist(video$speed)
  return(video)
}