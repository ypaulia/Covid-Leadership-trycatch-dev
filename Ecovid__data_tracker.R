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