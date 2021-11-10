  
  # land on cority website
  remDr$navigate("https://suncor.maspcl2.medgate.com/gx2/reportwriter/display.rails?Id=4546") # any arbitrary chosen report to trigger login page
  
  # web element login
  we_login <- remDr$findElement(
    using = "xpath", 
    value = "/html/body/div[2]/div/div[2]/form/div[1]/input[2]"
  )
  
  # type login
  we_login$sendKeysToElement(list(CREDENTIAL_LABEL))
  
  # web element password
  we_pw <- remDr$findElement(
    using = "xpath", 
    value = "/html/body/div[2]/div/div[2]/form/div[2]/input[3]"
  )
  
  # type password
  we_pw$sendKeysToElement(list(keyringr::decrypt_dpapi_pw(credential_path), key = "enter"))
  
  Sys.sleep(10)
  
  sapply(
    X = CORITY_REPORT_URLS, 
    
    FUN = function(link) {
      
      # navigate to display the report in question
      remDr$navigate(link)
      
      Sys.sleep(2)
      
      # actions dropdown
      actions <- remDr$findElement(
        using = "xpath",
        value = '//*[@id="MainAction"]'
      )
      
      actions$getElementText()
      
      actions$clickElement()
      
      Sys.sleep(2)
      
      # choose to export report to csv
      export_to_csv <- remDr$findElement(
        using = "xpath",
        value = '//*[@id="D_Action4"]'
      )
      
      export_to_csv$getElementText()
      
      export_to_csv$clickElement()
      
      Sys.sleep(2)
      
      # export report
      export <- remDr$findElement(
        using = "xpath",
        value = '//div[@class="button dynamicbutton"]'
      )
      
      export$getElementText()
      
      export$clickElement()
      
      Sys.sleep(5)
      
    }
    
  )
  
  Sys.sleep(EXTRA_SLEEP)
  
  # To get pid of the server
  pid <- rD$server$process$get_pid()
  
  ## give server port
  writeLines(paste("Selenium port: ", port,"\nProcess ID: ", pid, sep = ""))
  
  if (KILL_SERVER == T) {
    
    # kill server port
    system(paste0("Taskkill /F /T /PID ", pid))
    
  }
  
  return(list(PID = pid, RemoteDriver = remDr))
  
#}