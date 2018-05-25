# de https://www.kaggle.com/c/loan-default-prediction
library(odbc)
library(tidyverse)
library(lubridate)
con = dbConnect(odbc(),.connection_string = "DRIVER=SQL Server;SERVER=192.168.56.101;PORT=1433;DATABASE=sqlsat;UID=dfischer;PWD=daniel;TDS_Version=8.0;")

# Datos para VaR
index = readRDS("carga_datos/index.RDS")
dbSendQuery(con,"drop table country")
dbSendQuery(con,"CREATE TABLE [dbo].[country](
	[fecha] [date] NULL,
	[country] [varchar](255) NULL,
	[value] [float] NULL
)")
dbWriteTable(con,"country",index,row.names=F,append = T)

set.seed(123)
portafolio = data.frame(country = unique(index$country)) %>% 
  mutate(peso = runif(n()),
         peso = peso/sum(peso)
  )

dbSendQuery(con,"truncate table portafolio")
dbWriteTable(con,"portafolio",portafolio,row.names=F,append = T)
