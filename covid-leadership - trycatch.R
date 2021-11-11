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
        text(paste0(mes, "; R Error: ", e))
      
      smtp(msg, verbose = T)
      
      # kill selenium server
      system(paste0("Taskkill /F /T /PID ", pid))
      message(e)
      
    }
    
  )
}

# Selenium config - Firefox profile
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/functions/Selenium config.R", echo = F, local = T), 'Selenium Server Error')


# Internal ----------------------------------------------------------------

#Cority
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/functions/ICority Scraper.R", echo = F, local = T), 'Internal error: Cority')

# contractors
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/functions/IContractors.R", echo = F, local = T), 'Internal error: Contarctors data')

#iframe
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/functions/Iiframe.R", echo = F, local = T), 'Internal error: iframe')

#contractors_reporting
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/functions/Icontractors_reporting.R", echo = F, local = T), 'Internal error: contractors_reporting data')

# livelink data pull
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/functions/Ilivelink.R", echo = F, local = T), 'Internal error: livelink data')





# External ----------------------------------------------------------------

# land on external website #1 - covid_data_tracker
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/functions/Ecovid__data_tracker.R", echo = F, local = T), 'External error: covid_data_tracker')

# land on external site #2 - covid19tracker
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/functions/Ecovid19tracker.R", echo = F, local = T), 'External error: covid19tracker')

# google drive
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/functions/Egoogle_drive.R", echo = F, local = T), 'External error: google drive')

# vaccine rollout
run_piece_of_code(source("C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/functions/Evaccine_rollout.R", echo = F, local = T), 'External error: vaccine_rollout')
