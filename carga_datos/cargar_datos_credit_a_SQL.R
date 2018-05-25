library(odbc)
con = dbConnect(odbc(),.connection_string = "DRIVER=SQL Server;SERVER=192.168.56.101;PORT=1433;DATABASE=sqlsat;UID=dfischer;PWD=daniel;TDS_Version=8.0;")


# Credit
#Este es e tablon grane que pesa 400 mb, debe ser descargado desde https://www.kaggle.com/c/loan-default-prediction/data
credit = read.csv("carga_datos/train_v2.csv")
dbSendQuery(con,"truncate table credit")
dbWriteTable(con,"credit",credit,row.names=F,append = T)