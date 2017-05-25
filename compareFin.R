library(jsonlite)
library(httr)
getLLS <- function(x) {
  postcode = x
  postcode = gsub(" ", "", postcode)
  debug=TRUE
  llsVal = ''
  #uri <- paste("http://mybbc-locator-locservices-gss.api.bbci.co.uk/?limit=1&postcode=", postcode,  sep='')
  uri <- paste("https://mybbc-locator-locservices-gss.api.bbci.co.uk/?op=intersect&limit=1&postcode=", postcode,  sep='')
  resp <- GET(uri)
  if(debug) print("call done to LLS")
  if(debug) print(uri)
  if(http_status(resp) != "Success"){
    if(debug) print(http_status(resp))
    # stop("API did not return valid status")
    llsVal="error"
  }else{
    data <- fromJSON(content(resp, "text"))
    if(debug) print(data$response$details$externalId)
    llsVal = data$response$details$externalId
  }
  #Sys.sleep(0.2)
  
  x = llsVal
}

getForge <- function(x) {
  postcode = x
  postcode = gsub(" ", "", postcode)
  
  debug=TRUE
  forgeVal = ''
  uri <- paste("http://open.stage.bbc.co.uk/locator/locations/", postcode, sep='')
  uri <- paste(uri, "/details/gss-seat?op=intersect", sep='')  
  
  resp <- GET(uri)
  
  if(debug) print("call done to Forge")
  if(debug) print(uri)
  if(http_status(resp) != "Success"){
    if(debug) print(http_status(resp))
    # stop("API did not return valid status")
    forgeVal="error"
  }else{
    data <- fromJSON(content(resp, "text"))
    if(debug) print(data$response$details$externalId)
    forgeVal = data$response$details$externalId
  }
  Sys.sleep(0.2)
  
  x = forgeVal
}

