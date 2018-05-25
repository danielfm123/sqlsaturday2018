# Configurar linux, windows no requiere configuracion.
# instalar driver como administrador según:
# https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server
# Configurar unixodbc, agregar las siguientes lineas a /etc/odbcinst.ini (se imita nombre de driver al de windows)
# [SQL Server]
# Description=Microsoft ODBC Driver 17 for SQL Server
# Driver=/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.1.so.0.1
# UsageCount=1

# instalar paquete RODBC, en linux puede tener dependencias con unixodbc-dev (ubuntu)
if(!require("odbc")){
  install.packages("odbc")
}
# Conección a servidor usando OSDB connection string
conODBC = dbConnect(odbc(),.connection_string = "DRIVER=SQL Server;SERVER=192.168.56.101;PORT=1433;DATABASE=sqlsat;UID=dfischer;PWD=daniel;TDS_Version=8.0;")

dbGetQuery(conODBC,"select Species, count(*) numero from iris group by Species")

# tidyverse funciona con odbc
library(tidyverse)
conODBC %>% tbl("iris") %>% group_by(Species) %>% summarise(numero = n()) %>%  collect()

# borrar registros
dbSendStatement(conODBC,"truncate table iris")

# guardar una tabla
conODBC %>% db_insert_into("iris",iris,temporary = F)

# no hay problema con querys grandes
tabla = conODBC %>% tbl("credit") %>%  collect()

#Desconectarse del servidor, se puede tener un numero limitado de conecciones abiertas.
dbDisconnect(conODBC)

#Graficos desde SQL Server
dbGetQuery(conODBC,"select [Sepal.Length],[Sepal.Width],Species from iris") %>% 
  ggplot(aes(Sepal.Length,Sepal.Width,color = Species)) + geom_point()

conODBC %>% tbl("iris") %>% select(Sepal.Length,Sepal.Width,Species) %>% collect() %>% 
  ggplot(aes(Sepal.Length,Sepal.Width,color = Species)) + geom_point()
