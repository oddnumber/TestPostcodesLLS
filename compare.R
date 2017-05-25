library(jsonlite)
library(httr)
library(pbapply)

callAPItmp <- function(postcode){
  postcode = paste("fish", postcode)
}

tiny$llsval <- sapply(tiny$pcd, getLLS)
simple$llsval <- sapply(simple$pcd, getLLS)

getLLS <- function(x) {
  postcode = x
  debug=TRUE
  llsVal = ''
  uri <- paste("http://mybbc-locator-locservices-gss.api.bbci.co.uk/?limit=1&postcode=", postcode,  sep='')
  resp <- GET(uri)
  if(debug) print("call done to LLS")
  if(http_status(resp) != "success"){
    if(debug) print(uri)
    if(debug) print(http_status(resp))
    # stop("API did not return valid status")
    llsVal="error"
  }else{
    data <- fromJSON(content(resp, "text"))
    if(debug) print(data$response$details$externalId)
    llsVal = data$response$details$externalId
  }
  Sys.sleep(0.5)
  
  x = llsVal
}



callAPIs <- function(x) {
    debug=FALSE
    postcode = x
    llsVal = ''
    forgeVal = ''
    uri <- paste("http://mybbc-locator-locservices-gss.api.bbci.co.uk/?limit=1&postcode=", postcode,  sep='')
    uriForge <- paste("http://open.live.bbc.co.uk/locator/locations/", postcode, sep='')
    uriForge <- paste(uriForge, "/details/gss-seat?op=intersect", sep='')
    
    if(debug) print("should be making an LLS call now")
    if(debug) print(uri)
    resp <- GET(uri)
    if(debug) print("call done to LLS")
    if(http_status(resp) != "success"){
      if(debug) print(uri)
      if(debug) print(http_status(resp))
      # stop("API did not return valid status")
    }else{
      data <- fromJSON(content(resp, "text"))
      if(debug) print(data$response$details$externalId)
      llsVal = data$response$details$externalId
    }

    if(debug) print("should be making a Forge call now")
    if(debug) print(uriForge)  
    respf <- GET(uriForge)
    if(http_status(respf) != "success"){
      if(debug) print(uriForge)    
      if(debug) print(http_status(respf))
      # stop("API did not return valid status")
    }else{
      dataf <- fromJSON(content(respf, "text"))
      if(debug) print(dataf$response$details$externalId)
      forgeVal = dataf$response$details$externalId
    }
    print(" ")
    print(paste(llsVal,forgeVal))
    if(llsVal != forgeVal){
      print("values different")
      print(postcode)
      stop("values different")
    }
    
    if(debug) print("sleeping now")    
    Sys.sleep(1)
    if(debug) print("stopped sleeping")
    
}




