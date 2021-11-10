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