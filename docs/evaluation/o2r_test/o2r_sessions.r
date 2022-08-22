library(httr)
library(stringr)


#### Who am I ?
#Function to verify authentication status. 

whoami<-function(){
  cookie<-Sys.getenv("COOKIE")
  endpoint<-Sys.getenv("ENDPOINT")
  print(cookie)
  response<-GET(url=paste0(endpoint,"auth/whoami"),
                accept_json(),
                set_cookies(connect.sid=cookie),
                enconde="multipart"
  )
  return(response)
}

#########################################

# ERC/workspace Upload functions 

# The test differentiates between two types of uploads (either workspace or a complete ERC) and 3 origins (Direct, Zenodo and Sciebo). The following 3 functions (one for each origin) upload the workspaces and the complete ERC for either a `localtest` or a `remotetest`. The function *requires a previous Service authentication* to define `ENDPOINT` and `COOKIE`.

#########################################

# local_upload 
### Parameters
# compendium -> The archive file
# content_type -> Form of the archive ('compendium' or 'workspace')

local_upload<-function(compendium,content_type){
  file<-upload_file(toString(compendium))
  endpoint<-Sys.getenv("ENDPOINT")
  cookie<-Sys.getenv("COOKIE")
  response<-POST(url=paste0(endpoint,"compendium"),
                 body=list(
                   compendium=file,
                   content_type=content_type),
                 accept_json(),
                 set_cookies(connect.sid=cookie),
                 enconde="multipart"
  )
  return(response)
}  

# public_share_sciebo
### Parameters
# share_url -> The Sciebo link to the public share
# path -> Path to a subdirectory or a zip file in the public share
# content_type -> Form of archive ('compendium' or 'workspace')

public_share_sciebo<-function(share_url,path,content_type){
  
  endpoint<-Sys.getenv("ENDPOINT")
  cookie<-Sys.getenv("COOKIE")
  
  response<-POST(url=paste0(endpoint,"compendium"),
                 body=list(
                   share_url=share_url,
                   content_type=content_type,
                   path=path),
                 accept_json(),
                 set_cookies(connect.sid=cookie),
                 enconde="multipart"
  )
  return(response)
}

# public_share_zenodo
### Parameters
# zenodo_record_id -> The Zenodo record id
# content_type -> Form of archive ('compendium' or 'workspace')

public_share_zenodo<-function(zenodo_record_id,content_type){
  
  endpoint<-Sys.getenv("ENDPOINT")
  cookie<-Sys.getenv("COOKIE")
  
  response<-POST(url=paste0(endpoint,"compendium"),
                 body=list(
                   content_type=content_type,
                   zenodo_record_id=zenodo_record_id),
                 accept_json(),
                 set_cookies(connect.sid=cookie),
                 enconde="multipart"
  )
  return(response)
}

#########################################

# Metadata modification / Publish compendium

# After uploading an ERC/workspace is required to make it publicly available by modifying the metadata. The following code reproduce the metadata extracting and metadata update required to publish the compendium.

#########################################


# publish_compendium
### Parameters
# id -> compendium id

publish_compendium <- function(id){
  
  endpoint<-Sys.getenv("ENDPOINT")
  cookie<-Sys.getenv("COOKIE")
  
  url_metadata<-paste0(endpoint,"compendium/",id,"/metadata")
  print(url_metadata)
  print("Extracting metadata...")
  
  # Extract metadata
  response_metadata <- GET(url=url_metadata,
                           accept_json(),
                           set_cookies(connect.sid = cookie))
  
  print("Printing metadata")
  print(response_metadata)
  
  metadata <-  content(response_metadata, as = "text")
  metadata <- str_sub(string = metadata,start = str_locate(string = metadata, pattern = "\\{\"o2r\"")[[1]],end = str_length(metadata) - 1)
  
  print("printing... metadata")
  print(metadata)
  
  # Update metadata "Candidate process"
  response_update <- PUT(url=url_metadata,
                         body = metadata,
                         content_type_json(),
                         accept_json(),
                         set_cookies(connect.sid = cookie))
  
  candidate_process<-list(response_metadata,response_update)
  
  return(candidate_process)
}

#########################################

# JOB Execution

# Run the analysis (Execution job) in a published compendium.

#########################################

# execute_compendium
### Parameters
# id -> compendium id

execute_compendium<-function(id){
  
  endpoint<-Sys.getenv("ENDPOINT")
  cookie<-Sys.getenv("COOKIE")
  
  response <- POST(url = paste0(endpoint, "job"),
                   body = list(compendium_id = id[[1]]),
                   accept_json(),
                   set_cookies(connect.sid = cookie))
  return(response)
  
}

# job_status
### Parameters
# job_id -> Job id

job_status <- function(job_id) {
  endpoint<-Sys.getenv("ENDPOINT")
  cookie<-Sys.getenv("COOKIE")
  print(paste0(endpoint, "job/", job_id))
  response <- GET(url = paste0(endpoint, "job/", job_id,"?steps=all"),
                  accept_json(),
                  # authenticate even if not needed to not destroy cookie caching
                  set_cookies(connect.sid = cookie))
  return(response)
}

#########################################

# Session report

# Creates a report of the creation or examination session

#########################################

#get_report
### Parameters
#session_result -> session result

get_report<-function(session_result,session_type=type){
  
  if(session_type=="Creation"){
    general_steps_names<-c("start_pause","login_pause","upload_pause","upload_request","metaedit_pause","publish_compendium_request","execution_pause","job_execution")
    api_request_names<-c("upload","candidate_metarequest","candidate_metaupload","execution","job_status")
  }
  else if(session_type=="Examination"){
    general_steps_names<-c("start_pause","login_pause","execution_pause","job_execution")
    api_request_names<-c("execution","job_status")
  }
  
  # General steps 
  prueba<-session_result
  num_gen_steps<-length(general_steps_names)
  
  general_start<-unname(as.numeric(prueba$times[1:num_gen_steps]))
  general_end<-unname(as.numeric(prueba$times[2:(num_gen_steps+1)]))
  
  df_general <- data.frame(compendium_id=rep(prueba$info[1], num_gen_steps),
                           job_id=rep(prueba$info[2], num_gen_steps),
                           step=general_steps_names,
                           step_type=rep("general_step", num_gen_steps),
                           start=general_start,
                           end=general_end,
                           status=rep("OK", num_gen_steps))
  # API responses 
  
  record_times_api<-length(api_request_names)
  api_request_start<-vector(mode = "double", length = record_times_api)
  api_request_end<-vector(mode = "double", length = record_times_api)
  api_request_status<-vector(mode = "character", length = record_times_api)
  
  for (i in 1:record_times_api) {
    api_request_start[i]<-prueba[i][[1]]$date-prueba[i][[1]]$times[[6]]
    api_request_end[i]<-prueba[i][[1]]$date
    api_request_status[i]<-prueba[i][[1]]$status
  }
  
  df_api <- data.frame(compendium_id=rep(prueba$info[1],record_times_api),
                       job_id=rep(prueba$info[2],record_times_api),
                       step=api_request_names,
                       step_type=rep("api_request",record_times_api),
                       start=api_request_start,
                       end=api_request_end,
                       status=api_request_status)
  
  job_status<-content(prueba$job_status)$steps
  job_status_names<-names(job_status)
  job_steps_time_names<-paste0("job_",job_status_names)
  job_steps_status_names<-paste0("job_",job_status_names)
  unlist_job_status<-unlist(job_status)
  job_steps_start<-unlist_job_status[paste0(job_status_names,".start")]
  names(job_steps_start)<-paste0(job_status_names,".start")
  job_steps_start<-job_steps_start%>%sapply(function(x) as.POSIXct(x,format="%Y-%m-%dT%H:%M:%OS","GMT"))
  job_steps_end<-unlist_job_status[paste0(job_status_names,".end")]
  names(job_steps_end)<-paste0(job_status_names,".end")
  job_steps_end<-job_steps_end%>%sapply(function(x) as.POSIXct(x,format="%Y-%m-%dT%H:%M:%OS","GMT"))
  job_steps_time<-(job_steps_end-job_steps_start)*1000
  names(job_steps_time)<-job_steps_time_names
  job_steps_status<-unlist_job_status[paste0(job_status_names,".status")]%>%as.character()
  names(job_steps_status)<-job_steps_status_names
  job_steps_start<-unname(job_steps_start)
  job_steps_end<-unname(job_steps_end)
  job_steps_status<-unname(job_steps_status)
  
  df_job<-data.frame(compendium_id=rep(prueba$info[1],10),
                     job_id=rep(prueba$info[2],10),
                     step=job_steps_status_names,
                     step_type=rep("job_execution",10),
                     start=job_steps_start,
                     end=job_steps_end,
                     status=job_steps_status)
  
  df<-rbind(df_general,df_api,df_job)
  return(df)
}



#########################################

# CREATION SESSION

# Simulates a creation session (paper submission) in the o2r service.

#########################################

# creation_session
### Parameters
# upload_origin -> Type of upload ("Local","Zenodo","Sciebo")
# content_type -> Form of archive ('compendium' or 'workspace')
# source -> For "Direct" upload path to zip file, for "Zenodo" zenodo_record_id OR for "Sciebo" The Sciebo link to the public share.
# source_path -> ONLY for Sciebo upload path to a subdirectory or a zip file in the public share otherwise empty.
# start_pause -> Time before starting the session (in seconds)
# login_pause -> Login-in time (in seconds)
# uploading_pause -> Time before uploading the files (in seconds)
# metaedit_pause -> Time required to check the metadata before publishing (in seconds)
# execution_pause -> Time before executing a job (in seconds)

creation_session<-function(upload_origin,
                           content_type,
                           source,
                           source_path,
                           start_pause=0,
                           login_pause=0,
                           upload_pause=0,
                           metaedit_pause=0,
                           execution_pause=0){
  
  test_start_time<-Sys.time()
  
  ### STARTING PAUSE
  
  print(paste0("I'm going to take ", start_pause," seconds before starting to upload this Compendium"))
  Sys.sleep(start_pause)
  
  ### LOGIN Simulation
  login_start_time<-Sys.time()
  print(paste0("Ok, I'm going to login ! This usually takes ", login_pause," seconds"))
  Sys.sleep(login_pause)
  print("Looks like I'm already in !")
  whoami()
  ### Upload pause
  upload_start_pause_time<-Sys.time()
  print("OK, time to upload an Compendium !")
  print(paste0("Let me check the files " , upload_pause, " seconds before uploading !"))
  Sys.sleep(upload_pause)
  ### Upload request
  
  upload_request_start_time<-Sys.time()
  if(upload_origin=="Local"){
    upload<-local_upload(compendium = source,content_type = toString(content_type))
    print("Uploading from my computer !")
  } else if (upload_origin=="Sciebo"){
    upload<-public_share_sciebo(share_url = toString(source),path=toString(source_path),content_type=toString(content_type))
    print("Uploading from Sciebo !")
  } else if (upload_origin=="Zenodo"){
    upload<-public_share_zenodo(zenodo_record_id = source,content_type = toString(content_type))
    print("Uploading from Zenodo !")
  } else {
    print("There is a problem with the source file ! It must be Local / Sciebo or Zenodo")
    return(NULL)
  }
  
  upload_request_end_time<-Sys.time()
  
  ### Candidate process
  
  print(paste0("Now I have to check the metadata before publishing, this would probably take me ", metaedit_pause ," seconds" ))
  Sys.sleep(metaedit_pause)
  
  publish_start_time<-Sys.time()
  
  id<-toString(content(upload))
  print(paste0("My compendium id is: ", id))
  publish<-publish_compendium(id)
  metadata_request<-publish[[1]]
  metadata_update<-publish[[2]]
  print(paste0("My compendium ", id, " is already public !"))
  publish_end_time<-Sys.time()
  
  ### Execution process
  
  Sys.sleep(execution_pause)
  print(paste0("Looks interesting ! Let's run an analysis of Compendium: ",id))
  
  execute_start_time<-Sys.time()
  
  job_execute<-execute_compendium(toString(id))
  response<-job_execute$status
  
  job_id<-content(job_execute)
  
  if (response==200){
    print(paste0("Looks like it is already executing the job: ",job_id))
  }
  job_finish <-FALSE
  while(job_finish==FALSE){
    Sys.sleep(20)
    job<-job_status(job_id)
    status<-content(job)$status
    if(status!="running"){
      job_finish<-TRUE
      execute_end_time<-Sys.time()
    }
  }
  
  times<-c(test_start_time=test_start_time,
           login_start_time=login_start_time,
           upload_start_pause_time=upload_start_pause_time,
           upload_request_start_time=upload_request_start_time,
           upload_request_end_time=upload_request_end_time,
           publish_start_time=publish_start_time,
           publish_end_time=publish_end_time,
           execute_start_time=execute_start_time,
           execute_end_time=execute_end_time)
  
  info_test<-c(compendium_id=as.character(id),job_id=as.character(job_id))
  print(info_test)
  result<-list(upload=upload,meta_request=metadata_request,meta_update=metadata_update,job_execute=job_execute,job_status=job,times=times,info=info_test)
  df_report<-get_report(result,"Creation")
  write.csv(data.frame(df_report[,c(1:4,7)], start = sprintf("%.25f",df_report$start),end=sprintf("%.25f",df_report$end)), "result.csv", row.names = F)
  return(df_report)
}

#########################################

# EXAMINATION SESSION

# Simulates an examination session (reader) in the o2r service.

#########################################

# examination_session
### Parameters
# id -> compendium id
# start_pause -> Time before starting the session (in seconds)
# login_pause -> Login-in time (in seconds)
# execution_pause -> Time before executing a job (in seconds)

examination_session<-function(compendium_id,
                              start_pause=0,
                              login_pause=0,
                              execution_pause=0){
  
  ### Starting pause
  print(paste0("I'm going to take ", start_pause," seconds before starting to check this Compendium"))
  test_start_time<-Sys.time()
  Sys.sleep(start_pause)
  
  ### Login pause simulation
  login_start_time<-Sys.time()
  print(paste0("Ok, I'm going to login ! This usually takes ", login_pause," seconds"))
  Sys.sleep(login_pause)
  print("Looks like I'm already in !")
  whoami()
  
  ### Execution process
  execute_pause_start_time<-Sys.time()
  print(paste0("Let me check the paper ", execution_pause," seconds before running the analysis !"))
  Sys.sleep(execution_pause)
  
  print(paste0("Looks interesting ! Let's run an analysis of Compendium: ",compendium_id))
  execute_start_time<-Sys.time()
  job_execute<-execute_compendium(toString(compendium_id))
  
  response<-job_execute$status
  job_id<-content(job_execute)
  
  if (response==200){
    print(paste0("Looks like it is already executing the job: ",job_id))
  }
  
  job_finish <-FALSE
  while(job_finish==FALSE){
    Sys.sleep(10)
    job<-job_status(job_id)
    job_status<-content(job)$status
    if(job_status!="running"){
      job_finish<-TRUE
      execute_end_time<-Sys.time()
    }
  }
  
  times<-c(test_start_time=test_start_time,
           login_start_time=login_start_time,
           execute_pause_start_time=execute_pause_start_time,
           execute_start_time=execute_start_time,
           execute_end_time=execute_end_time)
  
  info_test<-c(compendium_id=as.character(compendium_id),job_id=as.character(job_id))
  result<-list(job_execute=job_execute,job_status=job,times=times,info=info_test)
  df_report<-get_report(result,"Examination")
  write.csv(data.frame(df_report[,c(1:4,7)], start = sprintf("%.25f",df_report$start),end=sprintf("%.25f",df_report$end)), "result.csv", row.names = F)
  return(df_report)
}



