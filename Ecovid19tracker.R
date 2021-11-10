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
  file = "C:/Users/ypaulia/Documents/Covid-Leadership trycatch dev/Test Files Dump/ON_coverage.csv", 
  row.names = F
)