HEADLESS = T
EXTRA_SLEEP = 350
CREDENTIAL_LABEL = "suncor_lgorokhov"
DOWNLOAD_PATH = "C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/files dump"
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

# To get pid of the server
pid <- rD$server$process$get_pid()