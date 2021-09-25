# install.packages("RPostgres")
# needs to 'CREATE EXTENSION postgis;' first

library(sf)
library(tidyverse)
library(RPostgres)
# setwd("...")

# settings
db.name = "..."
table.name = "..."
host = "localhost"
port = "5432"
username = "postgres"
password = "..."
file.name = "./example.csv"

# publish connection
conn <- dbConnect(Postgres(), dbname = dbname, host = host, port = port, 
                  user = username, password = password)

# read file
if (file.name%>%endsWith(".csv")){
  s = read_csv(file.name)
}else{
  s = st_read(file.name)
}

# check if there are invalid characters
s = s%>%rename_all(tolower)
check.invalid = function(t){
  return(!str_match(t,"[^\\w]")[1,1] %>% is.na())
}
if (check.invalid(s%>%colnames())){
  stop("Invalid character found! Please check column names.")
}

glimpse(s)

# writing to postgres
st_write(obj = s, dsn = conn, Id(table = table.name))