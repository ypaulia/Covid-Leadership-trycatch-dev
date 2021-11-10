#  function for cority scraping
cority_scraper <- function(
  CREDENTIAL_LABEL = "suncor_lgorokhov", 
  DOWNLOAD_PATH = "C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Selenium Downloads", 
  CORITY_REPORT_URLS, 
  EXTRA_SLEEP = 0, 
  KILL_SERVER = T, 
  HEADLESS = T
) {
  
  if (!require("pacman")) install.packages("pacman")
  pacman::p_load(tidyverse, stringr, RSelenium, keyringr)
  
  # credentials
  credential_label <- CREDENTIAL_LABEL
  credential_path <- paste(Sys.getenv("USERPROFILE"), '\\DPAPI\\passwords\\', Sys.info()["nodename"], '\\', credential_label, '.txt', sep="")
  
  # rselenium download path
  downloadPath <- DOWNLOAD_PATH %>%
    stringr::str_replace_all("/", "\\\\\\\\")
  
  # create temp firefox profile
  fprof <- makeFirefoxProfile(
    list(
      browser.download.dir = downloadPath,
      browser.download.folderList = 2L,
      browser.download.manager.showWhenStarting = FALSE,
      browser.helperApps.deleteTempFileOnExit = TRUE,
      browser.helperApps.neverAsk.openFile = "text/csv;application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      browser.helperApps.neverAsk.saveToDisk = "text/csv;application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
    )
  )
  
  # add extra capabilities: i.e. headless + temp profile
  if (HEADLESS == T) {
    exCap <- list(
      firefox_profile = fprof$firefox_profile, 
      "moz:firefoxOptions" = list(args = list('--headless'))
    )
  } else {
    exCap <- list(
      firefox_profile = fprof$firefox_profile
    )
  }
  
  # record the port for the server
  port <- netstat::free_port()
  
  # start server
  rD <- rsDriver(
    browser = "firefox",
    port = port,
    extraCapabilities = exCap
  )
  
  remDr <- rD[["client"]]
  
  # set implicit timeout
  remDr$setTimeout(type = "implicit", milliseconds = EXTRA_SLEEP * 1000)
  
  # set page load timeout
  remDr$setTimeout(type = "page load", milliseconds = EXTRA_SLEEP * 1000)
  
  # set timeout for script to run
  remDr$setTimeout(type = "script", milliseconds = EXTRA_SLEEP * 1000 + 30000)
  
  
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
  
}