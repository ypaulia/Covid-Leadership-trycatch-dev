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
  file = "C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Test Files Dump/vaccine_rollout.xlsx"
)