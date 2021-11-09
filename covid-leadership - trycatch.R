# libraries
library(tidyverse)
library(stringr)
library(rvest)
library(janitor)
library(xml2)
library(openxlsx)
library(emayili)



tryCatch(
  expr = { #here goes all the "scheduled script" 
    
    # cority rselenium --------------------------------------------------------
    downloadPath <- "C:/Automated_Projects/covid_leadership/Data/"
    
    # gather report links of interest
    cority_reports <- c(
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
    
    source("C:/Automated_Projects/functions/FUN_CORITY_SCRAPER.R", echo = F, local = T)
    
    rselenium <- cority_scraper(
      DOWNLOAD_PATH = downloadPath, 
      CORITY_REPORT_URLS = cority_reports, 
      EXTRA_SLEEP = 350,
      KILL_SERVER = F,
      HEADLESS = T
    )
    
    
    # external ----------------------------------------------------------------
    remDr <- rselenium$RemoteDriver
    
    pid <- rselenium$PID
    
    # land on external website
    remDr$navigate("https://covid.cdc.gov/covid-data-tracker/#vaccinations")
    
    Sys.sleep(2)
    
    table_toggler <- remDr$findElement(
      using = "xpath",
      value = '//h4[@id="vaccinations-table-title"]'
    )
    
    table_toggler$getElementText()
    
    table_note <- remDr$findElement(
      using = 'xpath',
      value = '//*[@id="table-note"]'
    )
    
    table_note$getElementText()
    
    table_toggler$clickElement()
    
    if (table_note$isElementDisplayed() == FALSE) {
      table_toggler$clickElement()
    }
    
    Sys.sleep(1)
    
    download.csv <- remDr$findElement(
      using = "xpath",
      value = '//button[@id="btnVaccinationsExport"]'
    )
    
    download.csv$getElementText()
    
    download.csv$clickElement()
    
    Sys.sleep(2)
    
    
    # land on external site #2
    remDr$navigate("https://covid19tracker.ca/provincevac.html?p=ON")
    
    Sys.sleep(5)
    
    webElement <- remDr$findElement(
      using = "xpath",
      value = '//table[@id="dataTable2"]'
    )
    
    text <- webElement$getElementText()
    
    df <- data.frame(
      rows = c(
        text %>% stringr::str_split(pattern = "\\n")%>% unlist()
      )
    ) %>% separate(
      col = rows,
      into = c('row', 'numbers'),
      sep = "(?<=[a-zA-Z])\\s*(?=[0-9])"
    )
    
    df$col1 <- do.call(rbind, strsplit(df$numbers, ' (?=[^ ]+$)', perl=TRUE))[,1]
    df$col2 <- do.call(rbind, strsplit(df$numbers, ' (?=[^ ]+$)', perl=TRUE))[,2]
    
    df$numbers <- NULL
    df <- df[-1,]
    rownames(df) <- NULL
    
    colnames(df) <- c("Region", "Total Doses Administered", "People Fully Vaccinated")
    
    df$`Total Doses Administered` <- gsub("\\s*\\([^\\)]+\\)","",df$`Total Doses Administered`)
    df$`People Fully Vaccinated` <- gsub("\\s*\\([^\\)]+\\)","",df$`People Fully Vaccinated`)
    
    df$`Total Doses Administered` <- gsub("[^0-9,-]", "", df$`Total Doses Administered`)
    df$`People Fully Vaccinated` <- gsub("[^0-9,-]", "", df$`People Fully Vaccinated`)
    
    df[df == ""] <- "No Data"
    
    # output ontario external data
    write.csv(
      x = df, 
      file = "C:/Automated_Projects/covid_leadership/Data/ON_coverage.csv", 
      row.names = F
    )
    
    # google drive ------------------------------------------------------------
    remDr$navigate('https://drive.google.com/file/d/1cjLn3Qkvs8hNJDGzCuqrDzbeNechUmkW/view')
    
    remDr$findElement(
      using = 'xpath',
      value = '//div[@class = "ndfHFb-c4YZDc-Bz112c ndfHFb-c4YZDc-C7uZwb-LgbsSe-Bz112c ndfHFb-c4YZDc-nupQLb-Bz112c"]'
    )$clickElement()
    
    # vaccine rollout ---------------------------------------------------------
    url <- "https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection/prevention-risks/covid-19-vaccine-treatment/vaccine-rollout.html"
    
    # extract html nodes
    scrape_html_data <- read_html(url)
    
    tabled_scrape_html_data <- html_nodes(
      scrape_html_data,
      css = "table"
    )
    
    dfList <- lapply(
      X = tabled_scrape_html_data,
      FUN = function (table) html_table(table, fill = T)
    )
    
    html_lines <- read_lines("https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection/prevention-risks/covid-19-vaccine-treatment/vaccine-rollout.html")
    
    scrape_nodes <- html_nodes(scrape_html_data, "caption")
    
    scrape_text <- html_text(scrape_nodes, trim = TRUE)
    
    scrape_text <- strsplit(scrape_text, "[\r\n]+")
    
    names_list <- c(unlist(scrape_text))
    
    # scrape_nodes <- html_nodes(scrape_html_data, "h3")
    # 
    # scrape_text <- html_text(scrape_nodes, trim = TRUE)
    # 
    # scrape_text <- strsplit(scrape_text, "[\r\n]+")
    # 
    # names_list <- janitor::make_clean_names(c(names_list, unlist(scrape_text)))
    
    dfList <- setNames(dfList, names_list)
    
    openxlsx::write.xlsx(
      x = dfList,
      file = "C:/Automated_Projects/covid_leadership/Data/vaccine_rollout.xlsx"
    )
    
    
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
    
    
    # contractors -------------------------------------------------------------
    remDr$navigate("https://suncor.service-now.com/nav_to.do?uri=%2Fx_suen2_ehsnow_contractor_vaccination_reporting_list.do%3Fsysparm_userpref_module%3Dc682ff33db40f8542d29294648961997%26sysparm_clear_stack%3Dtrue")
    
    # find login element
    login_webElement <- remDr$findElement(
      using = "xpath",
      value = '//*[@id="i0116"]'
    )$sendKeysToElement(list("lgorokhov@suncor.com", key = "enter"))
    
    Sys.sleep(2)
    
    # find password element
    password_webElement <- remDr$findElement(
      using = "xpath",
      value = '//*[@id="i0118"]'
    )
    
    credential_label <- "suncor_lgorokhov"
    credential_path <- paste(Sys.getenv("USERPROFILE"), '\\DPAPI\\passwords\\', Sys.info()["nodename"], '\\', credential_label, '.txt', sep="")
    
    password_webElement$sendKeysToElement(list(keyringr::decrypt_dpapi_pw(credential_path), key = "enter"))
    
    Sys.sleep(2)
    
    enter_key <- remDr$findElement("css", "body")
    enter_key$sendKeysToElement(list(key = "enter"))
    
    Sys.sleep(5)
    
    # iframe ------------------------------------------------------------------
    remDr$switchToFrame(remDr$findElement(using = 'xpath', value = '//*[@id="gsft_main"]'))
    
    Sys.sleep(5)
    
    remDr$findElement(
      using = 'xpath',
      value = '//*[@id="hdr_x_suen2_ehsnow_contractor_vaccination_reporting"]/th[@glide_label = "Number"]/span/i'
    )$clickElement()
    
    Sys.sleep(5)
    
    export_window <- remDr$findElement(
      using = 'xpath',
      value = '//*[@id="context_list_headerx_suen2_ehsnow_contractor_vaccination_reporting"]/div[contains(., "Export")]'
    )
    
    export_window$highlightElement()
    
    Sys.sleep(5)
    
    remDr$mouseMoveToLocation(
      webElement = export_window
    )
    
    Sys.sleep(5)
    
    remDr$findElement(
      using = 'xpath',
      value = '//*[@id="d1ad2f010a0a0b3e005c8b7fbd7c4e28_x_suen2_ehsnow_contractor_vaccination_reporting"]/div[contains(., "CSV")]'
    )$clickElement()
    
    Sys.sleep(5)
    
    remDr$findElement(
      using = 'xpath',
      value = '//*[@id="download_button"]'
    )$clickElement()
    
    Sys.sleep(5)
    
    
    # contractor reporting ----------------------------------------------------
    remDr$navigate("https://suncor.service-now.com/nav_to.do?uri=%2Fx_suen2_ehsnow_contractor_reporting_list.do%3Fsysparm_clear_stack%3Dtrue%26sysparm_userpref_module%3D059d1eecdbf8941008a4c3af299619a2")
    
    remDr$switchToFrame(remDr$findElement(using = 'xpath', value = '//*[@id="gsft_main"]'))
    
    Sys.sleep(5)
    
    remDr$findElement(
      using = 'xpath',
      value = '//*[@id="hdr_x_suen2_ehsnow_contractor_reporting"]/th[@glide_label = "Number"]/span/i'
    )$clickElement()
    
    Sys.sleep(5)
    
    export_window <- remDr$findElement(
      using = 'xpath',
      value = '//*[@id="context_list_headerx_suen2_ehsnow_contractor_reporting"]/div[contains(., "Export")]'
    )
    
    export_window$highlightElement()
    
    Sys.sleep(5)
    
    remDr$mouseMoveToLocation(
      webElement = export_window
    )
    
    Sys.sleep(5)
    
    remDr$findElement(
      using = 'xpath',
      value = '//*[@id="d1ad2f010a0a0b3e005c8b7fbd7c4e28_x_suen2_ehsnow_contractor_reporting"]/div[contains(., "CSV")]'
    )$clickElement()
    
    Sys.sleep(5)
    
    remDr$findElement(
      using = 'xpath',
      value = '//*[@id="download_button"]'
    )$clickElement()
    
    Sys.sleep(5)
    # livelink data pull ------------------------------------------------------
    download.file(
      url = "http://livelink/ecm/nodes/709040692/Essential%20Workers%20List.xlsx",
      destfile="C:/Automated_Projects/covid_leadership/Data/Essential Workers List.xlsx",
      mode="wb"
    )
    
    download.file(
      url = "http://livelink/ecm/nodes/709040692/Headcount%20for%20EW.xlsx",
      destfile="C:/Automated_Projects/covid_leadership/Data/Headcount for EW.xlsx",
      mode="wb"
    )
    
    download.file(
      url = "http://livelink/ecm/nodes/709040692/Work%20Addresses.xlsx",
      destfile="C:/Automated_Projects/covid_leadership/Data/Work Addresses.xlsx",
      mode="wb"
    )
    
    # AKT_IDM
    download.file(
      url = "http://livelink/ecm/nodes/709040692/AKT_IDM.xlsx",
      destfile="C:/Automated_Projects/covid_leadership/Data/AKT_IDM.xlsx",
      mode="wb"
    )
    
    
    
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
      to(c("lgorokhov@suncor.com", "ypaulia@suncor.com")) %>%
      from("scriptsscheduling@gmail.com") %>%
      subject("Error") %>%
      text(paste0("Error: ", e))
    
    smtp(msg, verbose = T)
    
    print(e)
    
    # kill selenium server
    system(paste0("Taskkill /F /T /PID ", pid))
    
  }
)