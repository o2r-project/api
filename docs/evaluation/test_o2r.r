source("o2r_test/o2r_sessions.r")
args<-commandArgs(TRUE)
session_type<-args[1]
file<-args[2]
number<-args[3]
compendium_id<-args[4]
if (session_type=="Creation"){
  print(file)
  print(number)
  Creation<-data.frame(read.csv(file,header=TRUE,sep=","))
  parameters<-Creation[number,]
  print(parameters)
  print(do.call(creation_session,parameters))
} else{
  print(file)
  print(number)
  Examination<-data.frame(read.csv(file,header=TRUE,sep=","))
  parameters<-Examination[number,]
  parameters[1]<-compendium_id
  print(parameters)
  print(do.call(examination_session,parameters))
}


