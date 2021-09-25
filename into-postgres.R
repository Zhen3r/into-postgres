# install.packages("RPostgres")
# needs to 'CREATE EXTENSION postgis;' first

library(sf)
library(tidyverse)
library(RPostgres)
# setwd("...")

db.name = "..."
table.name = "..."
host = "localhost"
port = "5432"
username = "postgres"
password = "..."
file.name = "./example.csv"

conn <- dbConnect(Postgres(), dbname = dbname, host = host, port = port, 
                  user = username, password = password)

if (file.name%>%endsWith(".csv")){
  s = read_csv(file.name)
}else{
  s = st_read(file.name)
}

glimpse(s)
s = s%>%rename_all(tolower)
st_write(obj = s, dsn = conn, Id(table = table.name))

