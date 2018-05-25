-- ejecutar una vez, muy inseguro
EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;
EXEC sp_configure 'xp_cmdshell', 1;   
RECONFIGURE;

--un ejemplo
xp_cmdshell 'dir'

--estructura de carpeta en C:\scripts
-- dar accesos

--crear SP
CREATE PROCEDURE [dbo].[sp_rscript]
	@proj varchar(100)
AS
BEGIN
	SET NOCOUNT ON;

	declare @command varchar(1000)
	set @command = 'C:\R\bin\x64\RScript.exe  C:\scripts\sql_wrapper.R ' + @proj 

	exec xp_cmdshell @command
END

--usar SP
select * from var
truncate table var

sp_rscript 'var'
