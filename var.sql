--logaritmo de los valores
select fecha, 
		country, 
		log(value) log_value into #log_country
from country
order by country, fecha

-- retorno logartimico
select actual.fecha, 
		actual.country, 
		actual.log_value log_actual_value, 
		prev.log_value log_prev_value,
		actual.log_value - prev.log_value log_proffit into #log_proffit
from #log_country actual
left join (select dateadd(MM,1,fecha) fecha, country, log_value from #log_country) as prev
on prev.fecha = actual.fecha and prev.country = actual.country
where prev.log_value is not null

-- retorno promedio
select country, avg(log_proffit) mean_log_profit into #mean_log_proffit
from  #log_proffit group by country

-- matriz varianza covarianza
select country_a.country country_a,
		country_b.country country_b,
		sum((country_a.log_proffit - mean_log_proffit_a.mean_log_profit) * (country_b.log_proffit - mean_log_proffit_b.mean_log_profit))/(count(*)-1) cov into #cov
from #log_proffit country_a left join #log_proffit country_b
		on country_a.fecha = country_b.fecha
left join  #mean_log_proffit  as mean_log_proffit_a
	on mean_log_proffit_a.country = country_a.country
left join  #mean_log_proffit  as mean_log_proffit_b
	on mean_log_proffit_b.country = country_b.country
group by country_a.country, country_b.country
order by country_a.country, country_b.country

-- varianza portafolio
select sum( portafilo_b.peso*portafilo_a.peso*cov.cov) varianza
from #cov cov left join portafolio portafilo_a
on cov.country_a = portafilo_a.country
left join portafolio portafilo_b
on cov.country_b = portafilo_b.country
