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



# tryCatch(
#   expr = { #here goes all the "scheduled scripts" 
# 
#     # Selenium config - Firefox profile ---------------------------------------
#     source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Selenium config.R", echo = F, local = T)
#         
#     
#     # internal --------------------------------------------------------
#     
#     source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Cority Scraper.R", echo = F, local = T)
#     
#     # contractors
#     source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Contractors.R", echo = F, local = T)
#     
#     #iframe
#     source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/iframe.R", echo = F, local = T)
#     
#     #contractors_reporting
#     source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/contractors_reporting.R", echo = F, local = T)
#     
#     # livelink data pull
#     source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/livelink.R", echo = F, local = T)
#     
#     # rselenium <- cority_scraper(
#     #   DOWNLOAD_PATH = downloadPath, 
#     #   CORITY_REPORT_URLS = cority_reports, 
#     #   EXTRA_SLEEP = 350,
#     #   KILL_SERVER = F,
#     #   HEADLESS = T
#     # )
#     # 
#     # remDr <- rselenium$RemoteDriver
#     # 
#     # pid <- rselenium$PID
#     
#     # external ----------------------------------------------------------------
#     
#     # land on external website #1 - covid_data_tracker
#     source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Ecovid__data_tracker.R", echo = F, local = T)
#     
#     
#     # land on external site #2 - covid19tracker
#     source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Ecovid19tracker.R", echo = F, local = T)
#     
#     # google drive
#     source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Egoogle_drive.R", echo = F, local = T)
#     
#     # vaccine rollout
#     source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Evaccine_rollout.R", echo = F, local = T)
#     
#     # # risk assessment ---------------------------------------------------------
#     # remDr$navigate("https://covid.cdc.gov/covid-data-tracker/#trends_dailytrendscases")
#     # # takes a while to load
#     # 
#     # Sys.sleep(7)
#     # 
#     # remDr$refresh()
#     # 
#     # Sys.sleep(7)
#     # 
#     # states <- c("Colorado", "Wyoming", "Texas")
#     # 
#     # sapply(
#     #   X = states, 
#     #   FUN = function(state) {
#     #     
#     #     remDr$findElement(
#     #       using = 'xpath',
#     #       value = '//input[@class = "search"]'
#     #     )$sendKeysToElement(list(state, key = "enter"))
#     #     
#     #     enter_key <- remDr$findElement("css", "body")
#     #     enter_key$sendKeysToElement(list(key = "enter"))
#     #     
#     #     download.button <- remDr$findElement(
#     #       using = 'xpath',
#     #       value = '//*[@id="btnUSTrendsTableExport"]'
#     #     )
#     #     
#     #     remDr$findElement(
#     #       using = 'xpath',
#     #       value = '//*[@id="us-trends-table-toggle"]'
#     #     )$clickElement()
#     #     
#     #     if (download.button$isElementDisplayed() == FALSE) {
#     #       remDr$findElement(
#     #         using = 'xpath',
#     #         value = '//*[@id="us-trends-table-toggle"]'
#     #       )$clickElement()
#     #     }
#     #     
#     #     download.button$clickElement()
#     #   }
#     # )
#     
#     
#     
#     
#     
#     system(paste0("Taskkill /F /T /PID ", pid))
#     message("Successfully executed the call.")
#   },
#   error = function(e){
#     
#     message('Caught an error!')
#     
#     smtp <- server(
#       host = "smtp.gmail.com",
#       port = 587,
#       username = "scriptsscheduling@gmail.com",
#       password = "Suncor!."
#     )
#     
#     msg <- envelope() %>%
#       to(c("ypaulia@suncor.com")) %>%
#       from("scriptsscheduling@gmail.com") %>%
#       subject("Error") %>%
#       text(paste0("Error: ", e))
#     
#     smtp(msg, verbose = T)
#     
#     print(e)
#     
#     # kill selenium server
#     system(paste0("Taskkill /F /T /PID ", pid))
#     
#   }
# )



run_piece_of_code <- function(piece_of_code, mes){
  
  tryCatch(
    
    expr = {
      
      piece_of_code
      
      message('success')
      
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
        text(paste0(mes, "R Error: ", e))
      
      smtp(msg, verbose = T)
      
      # kill selenium server
      system(paste0("Taskkill /F /T /PID ", pid))
      message(e)
      
    }
    
  )
}

# Selenium config - Firefox profile
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Selenium config.R", echo = F, local = T), 'Selenium Server Error')


# internal ----------------------------------------------------------------

#Cority
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Cority Scraper.R", echo = F, local = T), 'Internal error: Cority')

# contractors
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Contractors.R", echo = F, local = T), 'Internal error: Contarctors data')

#iframe
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/iframe.R", echo = F, local = T), 'Internal error: iframe')

#contractors_reporting
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/contractors_reporting.R", echo = F, local = T), 'Internal error: contractors_reporting data')

# livelink data pull
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/livelink.R", echo = F, local = T), 'Internal error: livelink data')





# External ----------------------------------------------------------------

# land on external website #1 - covid_data_tracker
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Ecovid__data_tracker.R", echo = F, local = T), 'External error: covid_data_tracker')

# land on external site #2 - covid19tracker
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Ecovid19tracker.R", echo = F, local = T), 'External error: covid19tracker')

# google drive
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Egoogle_drive.R", echo = F, local = T), 'External error: google drive')

# vaccine rollout
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Evaccine_rollout.R", echo = F, local = T), 'External error: vaccine_rollout')
