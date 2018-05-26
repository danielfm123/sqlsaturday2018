--activar sevicio
sp_configure 'external scripts enabled',1;
RECONFIGURE;

--ejemplo simple
EXEC sp_execute_external_script
  @language =N'R',
  @script=N'valores = data.frame(rnorm(numero$n))',
  @input_data_1 =N'select 10 as n',
  @input_data_1_name = N'numero',
  @output_data_1_name = N'valores'
  WITH RESULT SETS (([valor] real ));
GO

--ejemplo varias columnas
 EXEC sp_execute_external_script  
       @language = N'R', 
	   @script = N'iris_data = iris;',
	   @input_data_1 = N'',
       @output_data_1_name = N'iris_data'
     WITH RESULT SETS (("Sepal.Length" float not null,   
						"Sepal.Width" float not null,  
						"Petal.Length" float not null,   
						"Petal.Width" float not null, 
						"Species" varchar(100)));  

--guardar resultado

-- one time, crear linked server a si mismo
EXEC master..sp_addlinkedserver 
    @server = 'loopback',  
    @srvproduct = '',
    @provider = 'SQLNCLI',
    @datasrc = @@SERVERNAME;

EXEC master..sp_serveroption 
    @server = 'loopback', 
    @optname = 'DATA ACCESS',
    @optvalue = 'TRUE';
RECONFIGURE;

-- ejecutar con openquery
SELECT * INTO #tmp FROM OPENQUERY(loopback, '
EXEC sp_execute_external_script
  @language =N''R'',
  @script=N''valores = data.frame(rnorm(numero$n))'',
  @input_data_1 =N''select 10 as n'',
  @input_data_1_name = N''numero'',
  @output_data_1_name = N''valores''
  WITH RESULT SETS (([valor] real ));
');

select * from #tmp

-- instalar paquetes de R
-- ejecutar como administrador C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\R_SERVICES\bin\x64\Rgui.exe
-- instalar paquetes necesarios con insttall.package

--el caso del VaR
EXEC sp_execute_external_script
  @language =N'R',
  @script=N'library(odbc)
	library(tidyverse)
	con = dbConnect(odbc(),.connection_string = "DRIVER=SQL Server;SERVER=192.168.56.101;PORT=1433;DATABASE=sqlsat;UID=dfischer;PWD=daniel;TDS_Version=8.0;")

	paises = dbGetQuery(con,"select * from country")
	mvc =  paises %>%  
	  spread(country,value) %>% 
	  select(-fecha) %>% 
	  mutate_all(function(x) c(NA,diff(log(x)))) %>% 
	  var(na.rm = T, use = "pairwise.complete.obs")

	#VAR
	VaR = data.frame(valor = portafolio$peso %*% mvc %*% portafolio$peso)',
  @input_data_1 =N'select * from portafolio',
  @input_data_1_name = N'portafolio',
  @output_data_1_name = N'VaR'
  WITH RESULT SETS (([valor] real ));
GO