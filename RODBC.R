# Configurar linux, windows no requiere configuracion.
# instalar driver como administrador según:
# https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server
# Configurar unixodbc, agregar las siguientes lineas a /etc/odbcinst.ini (se imita nombre de driver al de windows)
# [SQL Server]
# Description=Microsoft ODBC Driver 17 for SQL Server
# Driver=/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.1.so.0.1
# UsageCount=1

# instalar paquete RODBC, en linux puede tener dependencias con unixodbc-dev (ubuntu)
if(!require("RODBC")){
  install.packages("RODBC")
}

# Conección a servidor usando OSDB connection string
conRODBC = odbcDriverConnect("DRIVER=SQL Server;SERVER=192.168.56.101;PORT=1433;DATABASE=sqlsat;UID=dfischer;PWD=daniel;TDS_Version=8.0;")

#Ejecutar una query
sqlQuery(conRODBC,"select Species, count(*) numero from iris group by Species")

# tidyverse no funciona con RODBC
library(tidyverse)
conRODBC %>% tbl("iris") %>% group_by(Species) %>% summarise(numero = n()) %>%  collect()

# no hay problema con tablas grandes
tabla = sqlQuery(conRODBC,"select * from credit")

#Desconectarse, en este caso se pueden tener conecciones ilimitadas
odbcClose(conRODBC)
