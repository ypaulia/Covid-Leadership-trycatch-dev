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
