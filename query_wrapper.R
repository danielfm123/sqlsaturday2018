library(odbc)
library(tidyverse)
library(DBI)

get_query = function(query){
  con = dbConnect(odbc(),.connection_string = "DRIVER=SQL Server;SERVER=192.168.56.101;PORT=1433;DATABASE=sqlsat;UID=dfischer;PWD=daniel;TDS_Version=8.0;")
  rowset = dbGetQuery(con,query)
  dbDisconnect(con)
  return(rowset)
}

get_query("select * from portafolio")
