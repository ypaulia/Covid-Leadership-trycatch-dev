# libraries
library(tidyverse)
library(stringr)
library(rvest)
library(janitor)
library(xml2)
library(openxlsx)
library(emayili)
#for github commits
library(usethis)



tryCatch(
  expr = { #here goes all the "scheduled scripts" 

    # Selenium config - Firefox profile ---------------------------------------

    HEADLESS = T
    EXTRA_SLEEP = 350
    CREDENTIAL_LABEL = "suncor_lgorokhov"
    DOWNLOAD_PATH = "C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Internal files dump"
    KILL_SERVER = F
    
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
    
    # internal --------------------------------------------------------
    
    
    # gather report links of interest
    CORITY_REPORT_URLS <- c(
      # Cority_A&D_Cases_Daily
      "https://suncor.maspcl2.medgate.com/gx2/reportwriter/display.rails?Id=4982",
      # Final Vaccine Questionnaire Response No/PNTA
      "https://suncor.maspcl2.medgate.com/gx2/reportwriter/display.rails?Id=5191",
      # get cority covid 19 immunization
      "https://suncor.maspcl2.medgate.com/gx2/reportwriter/display.rails?Id=4932",
      # Cority_Absences_Daily
      "https://suncor.maspcl2.medgate.com/gx2/reportwriter/display.rails?Id=4981",
      # get cority suncor population
      "https://suncor.maspcl2.medgate.com/gx2/reportwriter/display.rails?Id=4929"
    )
    
    source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Cority Scraper.R", echo = F, local = T)
    
    # contractors
    source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Contractors.R", echo = F, local = T)
    
    #iframe
    source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/iframe.R", echo = F, local = T)
    
    #contractors_reporting
    source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/contractors_reporting.R", echo = F, local = T)
    
    # livelink data pull
    source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/livelink.R", echo = F, local = T)
    
    # rselenium <- cority_scraper(
    #   DOWNLOAD_PATH = downloadPath, 
    #   CORITY_REPORT_URLS = cority_reports, 
    #   EXTRA_SLEEP = 350,
    #   KILL_SERVER = F,
    #   HEADLESS = T
    # )
    # 
    # remDr <- rselenium$RemoteDriver
    # 
    # pid <- rselenium$PID
    
    # external ----------------------------------------------------------------
    
    # land on external website #1 - covid_data_tracker
    source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Ecovid__data_tracker.R", echo = F, local = T)
    
    
    # land on external site #2 - covid19tracker
    source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Ecovid19tracker.R", echo = F, local = T)
    
    # google drive
    source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Egoogle_drive.R", echo = F, local = T)
    
    # vaccine rollout
    source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Evaccine_rollout.R", echo = F, local = T)
    
    # # risk assessment ---------------------------------------------------------
    # remDr$navigate("https://covid.cdc.gov/covid-data-tracker/#trends_dailytrendscases")
    # # takes a while to load
    # 
    # Sys.sleep(7)
    # 
    # remDr$refresh()
    # 
    # Sys.sleep(7)
    # 
    # states <- c("Colorado", "Wyoming", "Texas")
    # 
    # sapply(
    #   X = states, 
    #   FUN = function(state) {
    #     
    #     remDr$findElement(
    #       using = 'xpath',
    #       value = '//input[@class = "search"]'
    #     )$sendKeysToElement(list(state, key = "enter"))
    #     
    #     enter_key <- remDr$findElement("css", "body")
    #     enter_key$sendKeysToElement(list(key = "enter"))
    #     
    #     download.button <- remDr$findElement(
    #       using = 'xpath',
    #       value = '//*[@id="btnUSTrendsTableExport"]'
    #     )
    #     
    #     remDr$findElement(
    #       using = 'xpath',
    #       value = '//*[@id="us-trends-table-toggle"]'
    #     )$clickElement()
    #     
    #     if (download.button$isElementDisplayed() == FALSE) {
    #       remDr$findElement(
    #         using = 'xpath',
    #         value = '//*[@id="us-trends-table-toggle"]'
    #       )$clickElement()
    #     }
    #     
    #     download.button$clickElement()
    #   }
    # )
    
    
    
    
    
    system(paste0("Taskkill /F /T /PID ", pid))
    message("Successfully executed the call.")
  },
  error = function(e){
    
    message('Caught an error!')
    
    smtp <- server(
      host = "smtp.gmail.com",
      port = 587,
      username = "scriptsscheduling@gmail.com",
      password = "Suncor!."
    )
    
    msg <- envelope() %>%
      to(c("ypaulia@suncor.com")) %>%
      from("scriptsscheduling@gmail.com") %>%
      subject("Error") %>%
      text(paste0("Error: ", e))
    
    smtp(msg, verbose = T)
    
    print(e)
    
    # kill selenium server
    system(paste0("Taskkill /F /T /PID ", pid))
    
  }
)