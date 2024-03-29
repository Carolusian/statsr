library(pacman)

p_load(httr)
p_load(jsonlite)

kgl_credentials <- function(kgl_json_path="~/.kaggle/kaggle.json"){
  
  # returns user credentials from kaggle json
  user <- fromJSON("~/.kaggle/kaggle.json", flatten = TRUE)
  return(user)
  
}

kgl_dataset <- function(ref, file_name, type="dataset", kgl_json_path="~/.kaggle/kaggle.json"){
  
  # ref: depends on 'type':
  # - dataset: "sudalairajkumar/novel-corona-virus-2019-dataset"
  # - competition: competition ID, e.g. 8587 for "competitive-data-science-predict-future-sales"
  # file_name: specific dataset wanted, e.g. "covid_19_data.csv"
  
  .kaggle_base_url <- "https://www.kaggle.com/api/v1"
  user <- kgl_credentials(kgl_json_path)
  
  if(type=="dataset"){
    
    # dataset
    url <- paste0(.kaggle_base_url, "/datasets/download/", ref, "/", file_name)
    
    
  }else if(type=="competition"){
    
    # competition
    url <- paste0(.kaggle_base_url, "/competitions/data/download/", ref, "/", file_name)
    
  }
  
  print(url)
  
  # call
  rcall <- httr::GET(url, httr::authenticate(user$username, user$key, type="basic"))
  print(rcall)
  
  # content type
  content_type <- rcall[[3]]$`content-type`
  
  if( grepl("zip", content_type)){
    
    # download and unzup
    temp <- tempfile()
    download.file(rcall$url,temp)
    data <- read.csv(unz(temp, file_name))
    unlink(temp)
    
  }else{
    
    # else read as text -- note: code this better
    data <- content(rcall, type="text/csv", encoding = "ISO-8859-1")
  }
  
  return(data)
  
}
