#incrementar la capacidad de Java, en este caso a 2gb de ram.
options(java.parameters = "-Xmx2g")
# Si no está el paquete, debe ser instalado
if(!require("RSQLServer")){
  install.packages("RSQLServer")
}
# Conectarse al servidor
conRSQLServer = dbConnect(RSQLServer::SQLServer(), server="192.168.56.101", port=1433,
                          properties=list(useNTLMv2="false", user="dfischer",password="daniel"),database = "sqlsat")

# ejecutar una query
dbGetQuery(conRSQLServer,"select Species, count(*) numero from iris group by Species")

# ejecutar query con tidyverse
library(tidyverse)
conRSQLServer %>% tbl("iris") %>% group_by(Species) %>% summarise(numero = n()) %>%  collect()

#se cae con una query grande
tabla = conRSQLServer %>% tbl("credit") %>%  collect()

#Desconectarse del servidor, se puede tener un numero limitado de conecciones abiertas.
dbDisconnect(conRSQLServer)