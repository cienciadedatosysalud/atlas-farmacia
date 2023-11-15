

auxilary_database_path <- '../../inputs/data.duckdb'
outputs_path <- '../../outputs/'

leerPoblacionAño <- function(año,data){
  log_info('Connect to population database')
  ccaa_cd <- unique(data$ccaa_cd)
  
  con = dbConnect(duckdb::duckdb(), dbdir=auxilary_database_path, read_only=FALSE)
  
  
  population <- dbGetQuery(conn = con, paste0("SELECT año_cd,ccaa_cd,zbs_residencia_cd,grupo_edad_cd,sexo_cd,sum(n_poblacion) as n_poblacion 
                                              FROM zona_basica_tarjeta where sexo_cd IN (1,2) and ccaa_cd = '",ccaa_cd,"' and año_cd = ",año," 
                                              GROUP BY año_cd,ccaa_cd,zbs_residencia_cd,grupo_edad_cd,sexo_cd")) %>%
    rename(sexo = sexo_cd,
           gqe = grupo_edad_cd)

  comb_zbs <- population$zbs_residencia_cd %>% unique()
  comb_gqe <- seq(1,18)
  comb_sexo <- seq(1,2)
  comb_total <- expand.grid(comb_zbs,comb_gqe,comb_sexo) %>%
    rename(
      gqe = Var2,
      sexo = Var3,
      zbs = Var1
    )
  
  population <- population %>% select(zbs_residencia_cd,sexo,gqe,n_poblacion) %>% rename(zbs = zbs_residencia_cd)
  
  population <- merge(x=comb_total,y=population,all.x = TRUE)
  population$ccaa_cd <- ccaa_cd
  

  
  dbDisconnect(con, shutdown=TRUE)
  log_info('Disconnect to population database')
  return(population)
}

getPoblacionRef <- function(año){
  log_info('Calculate population ref')
  con = dbConnect(duckdb::duckdb(), dbdir=auxilary_database_path, read_only=FALSE)
  
  
  population <- dbGetQuery(conn = con, paste0("SELECT * FROM zona_basica_ine where sexo_cd IN (1,2) and año_cd = ",año)) %>%
    rename(sexo = sexo_cd,
           gqe = grupo_edad_cd)
  
  
  poblacion_ref <- population %>%
    group_by(sexo,gqe) %>%
    summarise(pop = sum(n_poblacion,na.rm = TRUE))
  poblacion_ref[poblacion_ref$pop==0,"pop"] <- 1 # !!! No puedo tener poblaciones 0
  
  dbDisconnect(con, shutdown=TRUE)
  return(poblacion_ref)
}

leerDataAño4 <- function(año){
  log_info(paste0('Connect to database  (',año,')'))
  con = dbConnect(duckdb::duckdb(), dbdir=auxilary_database_path, read_only=FALSE)
  indicador_ <- dbGetQuery(conn = con, paste0(
    "
with partial_df as (
select
	envase_id,
	year(fecha_dispensacion_dt) as año,
	paciente_id,
	CASE
		WHEN edad_nm >= 0
		and edad_nm <= 4 THEN 1
		WHEN edad_nm >= 5
		and edad_nm <= 9 THEN 2
		WHEN edad_nm >= 10
		and edad_nm <= 14 THEN 3
		WHEN edad_nm >= 15
		and edad_nm <= 19 THEN 4
		WHEN edad_nm >= 20
		and edad_nm <= 24 THEN 5
		WHEN edad_nm >= 25
		and edad_nm <= 29 THEN 6
		WHEN edad_nm >= 30
		and edad_nm <= 34 THEN 7
		WHEN edad_nm >= 35
		and edad_nm <= 39 THEN 8
		WHEN edad_nm >= 40
		and edad_nm <= 44 THEN 9
		WHEN edad_nm >= 45
		and edad_nm <= 49 THEN 10
		WHEN edad_nm >= 50
		and edad_nm <= 54 THEN 11
		WHEN edad_nm >= 55
		and edad_nm <= 59 THEN 12
		WHEN edad_nm >= 60
		and edad_nm <= 64 THEN 13
		WHEN edad_nm >= 65
		and edad_nm <= 69 THEN 14
		WHEN edad_nm >= 70
		and edad_nm <= 74 THEN 15
		WHEN edad_nm >= 75
		and edad_nm <= 79 THEN 16
		WHEN edad_nm >= 80
		and edad_nm <= 84 THEN 17
		WHEN edad_nm >= 85 THEN 18
		ELSE NULL
	END as grupo_edad_cd,
	sexo_cd,
	tsi_cd,
	zbs_residencia_cd,
	ccaa_cd,
	atc_farmaco_dispensado_cd[1:4] as atc_farmaco_dispensado_4,
	atc_farmaco_dispensado_cd[1:5] as atc_farmaco_dispensado_5, 
	atc_farmaco_dispensado_cd[1:7] as atc_farmaco_dispensado_7, 
	codigo_nacional_farmaco_cd,
	ddd_nomenclator_nm,
  ddd_por_envase,
	pvp_nomenclator_nm,
	precio_por_envase_nm
from
	main.envase_dispensado_view)
select a.* from (select atc_farmaco_dispensado_4 as atc_farmaco_dispensado ,ccaa_cd, zbs_residencia_cd ,sexo_cd, grupo_edad_cd, tsi_cd , 
sum(ddd_nomenclator_nm) as ddd_nomenclator_nm, 
sum(ddd_por_envase) as ddd_por_envase,
sum(pvp_nomenclator_nm) as pvp_nomenclator_nm,
sum(precio_por_envase_nm) as precio_por_envase_nm,
count(DISTINCT paciente_id) as pacientes_nm,
count(DISTINCT envase_id) as n_envases,
from partial_df where año = ",año," and sexo_cd in (1,2) group by atc_farmaco_dispensado_4 ,ccaa_cd, zbs_residencia_cd ,sexo_cd, grupo_edad_cd, tsi_cd) a 
"
  )) %>% 
    rename(sexo = sexo_cd,
           gqe = grupo_edad_cd,
           tsi = tsi_cd)
  
  
  indicador_ <- indicador_ %>% rename(
    zbs = zbs_residencia_cd) 
  
  # Sumar casos si hay fusion de areas
  
  indicador_ <- indicador_ %>%  
    filter(!is.na(sexo)) %>% 
    filter(!is.na(gqe))
  indicador_[is.na(indicador_)] <- 0
  dbDisconnect(con, shutdown=TRUE)
  log_info('Disconnect to database')
  return(indicador_)
}

leer_asignar_relaciones_zbs <- function(data){
  
  con = dbConnect(duckdb::duckdb(), dbdir=auxilary_database_path, read_only=FALSE)
  rel <- dbGetQuery(conn = con, paste0("SELECT * FROM zbs_residencia_codatzbs"))
  rel <- rel %>% filter(ccaa_cd %in% unique(data$ccaa_cd)) %>% 
    dplyr::rename(zbs = zbs_residencia_cd)
  data <- left_join(x=data, y=rel, by=c('zbs','ccaa_cd'))
  data <- data %>% filter(!is.na(codatzbs))
  dbDisconnect(con, shutdown=TRUE)
  return(data)  
  
}

getRatesByIndicator <- function(data,population_ref,population_aux){
  log_info(paste0('Calculate rates and statistical indicators (',variable_indicator,')'))
  
  data <- left_join(x=data,
                    y=population_ref[,c("gqe","sexo","pop")],
                    by=c("gqe","sexo"))
  
  data <- data %>% filter(gqe>=4)
  population_aux <- population_aux %>% filter(gqe>=4)
  population_ref <- population_ref %>% filter(gqe>=4)
  #####  
  if(variable_indicator_ == 'ddd'){
    
    p <- data %>% group_by(codatzbs,gqe,sexo) %>% summarise(casos = (sum(casos,na.rm=TRUE)))
    population_aux_ <- population_aux %>% group_by(codatzbs,gqe,sexo) %>% summarise(n_poblacion = (sum(n_poblacion,na.rm=TRUE)))
    population_ref_ <- population_ref %>% ungroup() %>% mutate(total = sum(pop))
    population_ref_ <- population_ref_ %>% mutate(st_pop = (pop/total))
    p <- left_join(x=p, y=population_aux_, by = c('codatzbs','gqe','sexo'))
    data_clean <- p %>% filter(n_poblacion >0) 
    data_clean <- left_join(x=data_clean, y = population_ref_[c("gqe","sexo","st_pop")])
    data_clean <- data_clean %>% mutate(rate = ((1000*casos)/(365*n_poblacion)))
    rate_dsr <- data_clean %>% group_by(codatzbs) %>% summarise(te = round(sum(st_pop * rate),4),
                                                                casos= sum(casos,na.rm=TRUE),
                                                                n_poblacion = sum(n_poblacion,na.rm=TRUE))
    
    
  }else{
    
    p <- data %>% group_by(codatzbs,gqe,sexo) %>% summarise(casos = (sum(casos,na.rm=TRUE)))
    population_aux_ <- population_aux %>% group_by(codatzbs,gqe,sexo) %>% summarise(n_poblacion = (sum(n_poblacion,na.rm=TRUE)))
    population_ref_ <- population_ref %>% ungroup() %>% mutate(total = sum(pop))
    population_ref_ <- population_ref_ %>% mutate(st_pop = (pop/total))
    p <- left_join(x=p, y=population_aux_, by = c('codatzbs','gqe','sexo'))
    data_clean <- p %>% filter(n_poblacion >0) 
    data_clean <- left_join(x=data_clean, y = population_ref_[c("gqe","sexo","st_pop")])
    data_clean <- data_clean %>% mutate(rate = ((casos)/(n_poblacion)))
    rate_dsr <- data_clean %>% group_by(codatzbs) %>% summarise(te = round(sum(st_pop * rate),4),
                                                                casos= sum(casos,na.rm=TRUE),
                                                                n_poblacion = sum(n_poblacion,na.rm=TRUE))
  }
  
  
  data_codatzbs <- data[!duplicated(data$codatzbs),] %>% dplyr::select(codatzbs,n_zbs)
  
  result_end <- left_join(x=rate_dsr, y = data_codatzbs, by = 'codatzbs') %>% 
    dplyr::rename(population = n_poblacion)
  
  return(result_end)
}

getRates <- function(indicator,data,patient_variables,population,population_ref,variable_indicator){
  data <- data %>% filter(atc_farmaco_dispensado == indicator)
  params <- c(patient_variables,variable_indicator)
  data <- data %>% dplyr::select(all_of(params)) %>% rename(casos = variable_indicator)
  population_aux <- population %>% 
    filter(zbs %in% data$zbs) %>% 
    select(zbs,sexo,gqe,n_poblacion,codatzbs,n_zbs)
  
  data<-merge(x=population_aux,y=data,all.x = TRUE)
  data[is.na(data)] <- 0
  rates <- getRatesByIndicator(data,population_ref,population_aux)
  rates$indicator <- indicator
  return(rates)
}


writeResults2 <- function(indicators_rates, indicators_list,variable_indicator){
  indicator_name <- indicators_list[1]
  values <- indicators_rates[indicators_rates$indicator == indicator_name,
                             c("codatzbs","population","casos","te","n_zbs")]
  
  
  objeto <- list(indicator_name = values)
  
  names(objeto) <- c(indicator_name)
  
  for(i in 1:length(indicators_list)){
    indicator_name <- indicators_list[i]
    values <- indicators_rates[indicators_rates$indicator == indicators_list[i],c("codatzbs","population","casos","te","n_zbs")]
    objeto[[i]] <- values
    
  }
  names(objeto) <- indicators_list
  
  estadisticosobs<-array(0,c(length(objeto),7))
  c.rr<-array(0,c(length(objeto),dim(objeto[[1]])[1]))
  c.rreb<-array(0,c(length(objeto),dim(objeto[[1]])[1]))
  for(i in 1:length(objeto)){
    
    attach(objeto[[i]])
    J<-length(te)
    
    # 1.- razon de variacion
    rv<-max(te)/min(te)
    rv95<-max(te[te>quantile(te, 0.05, na.rm = TRUE)& te<quantile(te, 0.95, na.rm = TRUE)])/min(te[te>quantile(te, 0.05, na.rm = TRUE)& te<quantile(te, 0.95, na.rm = TRUE)])
    rv75<-max(te[te>quantile(te, 0.25, na.rm = TRUE)& te<quantile(te, 0.75, na.rm = TRUE)])/min(te[te>quantile(te, 0.25, na.rm = TRUE)& te<quantile(te, 0.75, na.rm = TRUE)])
    
    #2.- coeficiente de variacion 
    
    cv<-sd(te)/mean(te)
    cv95<-sd(te[te>quantile(te, 0.05, na.rm = TRUE)& te<quantile(te, 0.95, na.rm = TRUE)])/mean(te[te>quantile(te, 0.05, na.rm = TRUE)& te<quantile(te, 0.95, na.rm = TRUE)]) 
    
    # coeficiente de variacion ponderado
    
    cvp<-sqrt(sum(((te-mean(te))^2)*population)/(sum(population)-1))/sum(te*population/sum(population))
    cvp95<-sqrt(sum(((te[te>quantile(te, 0.05, na.rm = TRUE)& te<quantile(te, 0.95, na.rm = TRUE)]-mean(te[te>quantile(te, 0.05, na.rm = TRUE)& te<quantile(te, 0.95, na.rm = TRUE)]))^2)*population[te>quantile(te, 0.05,na.rm = TRUE)& te<quantile(te, 0.95,na.rm = TRUE)])/(sum(population[te>quantile(te, 0.05, na.rm = TRUE)& te<quantile(te, 0.95,na.rm = TRUE)])-1))/sum(te[te>quantile(te, 0.05, na.rm = TRUE)& te<quantile(te, 0.95, na.rm = TRUE)]*population[te>quantile(te, 0.05, na.rm = TRUE)& te<quantile(te, 0.95, na.rm = TRUE)]/sum(population[te>quantile(te, 0.05, na.rm = TRUE)& te<quantile(te, 0.95, na.rm = TRUE)]))
    
    
    estadisticosobs[i,1:7]<-round(cbind(rv, rv95,rv75, cv, cv95, cvp, cvp95),3)
    detach(2)
  }
  
  
  estadisticosobs<-data.frame(estadisticosobs, row.names=names(objeto))

  names(estadisticosobs)<-c("rv", "rv95", "rv75", "cv", "cv95", "cvp", "cvp95")
  t(round(estadisticosobs,2))
  
  
  
  indicators_rates$año <- año
  indicators_rates <- indicators_rates %>% rename(total = casos)
  indicators_rates_total <<- rbind(indicators_rates_total,indicators_rates)
  estadisticosobs <- tibble::rownames_to_column(estadisticosobs, paste0("indicator"))
  estadisticosobs$año <- año
  estadisticosobs_total <<- rbind(estadisticosobs_total,estadisticosobs)
  
  
  
}
######################
#########################
#       PROGRAMA       #
#########################
for(variable_indicator in c('ddd_por_envase','pvp_nomenclator_nm')){
  lista_años <- seq(2013,2022,1)
  indicators_rates_total <- data.frame()
  estadisticosobs_total  <- data.frame()
  variable_indicator_ <- unlist(strsplit(variable_indicator,'_'))[1]
  for(año in lista_años){
    data <- leerDataAño4(año)
    if(nrow(data != 0)){
      pop <- leerPoblacionAño(año,data)
      data <- leer_asignar_relaciones_zbs(data)
      pop <- leer_asignar_relaciones_zbs(pop)
      pop$n_poblacion[is.na(pop$n_poblacion)] <- 0
      population_ref <- getPoblacionRef(año)
      patient_variables <- c("zbs","gqe","sexo","tsi","codatzbs","n_zbs")
      indicators_list <- c('N02A')
    
    
      indicators_rates <- lapply(indicators_list, getRates,
                               data=data,
                               patient_variables=patient_variables,
                               population=pop,
                               population_ref=population_ref,
                               variable_indicator=variable_indicator) %>% bind_rows()
    
      writeResults2(indicators_rates,indicators_list, variable_indicator_)

    }
  }
  write.csv(indicators_rates_total, file = paste0(outputs_path,"opioides4_indicators_rates_",as.character(variable_indicator_),".csv"), 
            row.names = FALSE)
  write.csv(estadisticosobs_total, file = paste0(outputs_path,"opioides4_estadisticosobs_",as.character(variable_indicator_),".csv"), 
            row.names = FALSE)
}




