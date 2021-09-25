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

# to lowercase and replace invalid character with "_"
s = s %>%
  rename_all(tolower) %>%
  rename_all({function (t) str_replace_all(t,"[^\\w]","_")})

glimpse(s)

# writing to postgres
st_write(obj = s, dsn = conn, Id(table = table.name))




