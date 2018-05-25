library(odbc)
library(tidyverse)
con = dbConnect(odbc(),.connection_string = "DRIVER=SQL Server;SERVER=192.168.56.101;PORT=1433;DATABASE=sqlsat;UID=dfischer;PWD=daniel;TDS_Version=8.0;")

paises = dbGetQuery(con,"select * from country")
mvc =  paises %>%  
  spread(country,value) %>% 
  select(-fecha) %>% 
  mutate_all(function(x) c(NA,diff(log(x)))) %>% 
  var(na.rm = T, use = "pairwise.complete.obs")

portafolio = dbGetQuery(con,"select * from portafolio order by country")

#VAR
var = portafolio$peso %*% mvc %*% portafolio$peso

dbSendStatement(con,"truncate table var")
con %>% dbWriteTable("var",data.frame(var = var),append = T)
