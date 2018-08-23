# Cross-Scale Interactions Module Testing Files #####
library(tidyverse)
library(glmtools) 
glm_version() 

ComputerName <- 'KJF' 
LakeName <- 'Mendota' 

sim_folder <- paste('C:/Users/',ComputerName,'/Desktop/R/MacrosystemsEDDIE/CrossScale Interactions/',LakeName, sep='')
setwd(sim_folder) 

#### BASELINE ####
nml_file <- paste0(sim_folder,"/glm2.nml")
nml <- read_nml(nml_file)
run_glm(sim_folder, verbose=TRUE) 

baseline <- file.path(sim_folder, 'output.nc') 
#plot_temp(file=baseline, fig_path=FALSE) 
#plot_var(file = baseline, "PHY_TCHLA") 

chla_output <- get_var(file=baseline, "PHY_TCHLA", reference='surface', z_out=c(1)) 
colnames(chla_output)[2] <- "Baseline_Chla" 

#### CLIMATE WARMING ####
# Plus 2 Year-Round
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'meteo_fl')
run_glm(sim_folder, verbose=TRUE) 
climate_plus2 <- file.path(sim_folder, 'output.nc') 

`*tmp*` <- get_var(file=climate_plus2, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["Climate_Plus2_Chla"] <- `*tmp*`[2] 

# Plus 4, Summer
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'meteo_fl')
run_glm(sim_folder, verbose=TRUE) 
climate_plus4 <- file.path(sim_folder, 'output.nc') 

`*tmp*` <- get_var(file=climate_plus4, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["Climate_Plus4_Chla"] <- `*tmp*`[2] 

#### LAND USE ####
# Double P
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'inflow_fl') 
get_nml_value(nml, 'meteo_fl')

run_glm(sim_folder, verbose=TRUE) 
landuse_2 <- file.path(sim_folder, 'output.nc') 
`*tmp*` <- get_var(file=landuse_2, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["LandUse_DoubleP_Chla"] <- `*tmp*`[2] 

# Four X P
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'inflow_fl') 
get_nml_value(nml, 'meteo_fl')

run_glm(sim_folder, verbose=TRUE) 
landuse_4 <- file.path(sim_folder, 'output.nc') 
`*tmp*` <- get_var(file=landuse_4, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["LandUse_4xP_Chla"] <- `*tmp*`[2] 

# Four X Summer P
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'inflow_fl') 
get_nml_value(nml, 'meteo_fl')

run_glm(sim_folder, verbose=TRUE) 
landuse_4S <- file.path(sim_folder, 'output.nc') 
`*tmp*` <- get_var(file=landuse_4S, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["LandUse_4xPSummer_Chla"] <- `*tmp*`[2] 

#### COMBINED LAND USE CLIMATE ####
# Plus 2, Double P
nml <- read_nml(nml_file)  
get_nml_value(nml, 'inflow_fl') 
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE) 
climate_landuse <- file.path(sim_folder, 'output.nc') 
`*tmp*` <- get_var(file=climate_landuse, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["Climate2_LandUse2_Chla"] <- `*tmp*`[2] 

# Plus 2, 4xP
nml <- read_nml(nml_file)  
get_nml_value(nml, 'inflow_fl') 
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE) 
climate_landuse <- file.path(sim_folder, 'output.nc') 
`*tmp*` <- get_var(file=climate_landuse, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["Climate2_LandUse4_Chla"] <- `*tmp*`[2] 

# Plus 2, 4x Summer
nml <- read_nml(nml_file)  
get_nml_value(nml, 'inflow_fl') 
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE) 
climate_landuse <- file.path(sim_folder, 'output.nc') 
`*tmp*` <- get_var(file=climate_landuse, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["Climate2_LandUse4S_Chla"] <- `*tmp*`[2] 

# Plus 4, Double P
nml <- read_nml(nml_file)  
get_nml_value(nml, 'inflow_fl') 
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE) 
climate_landuse <- file.path(sim_folder, 'output.nc') 
`*tmp*` <- get_var(file=climate_landuse, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["Climate4_LandUse2_Chla"] <- `*tmp*`[2] 

# Plus 4, 4xP
nml <- read_nml(nml_file)  
get_nml_value(nml, 'inflow_fl') 
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE) 
climate_landuse <- file.path(sim_folder, 'output.nc') 
`*tmp*` <- get_var(file=climate_landuse, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["Climate4_LandUse4_Chla"] <- `*tmp*`[2] 

# Plus 4, 4x Summer
nml <- read_nml(nml_file)  
get_nml_value(nml, 'inflow_fl') 
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE) 
climate_landuse <- file.path(sim_folder, 'output.nc') 
`*tmp*` <- get_var(file=climate_landuse, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["Climate4_LandUse4S_Chla"] <- `*tmp*`[2] 

write_csv(chla_output, 'C:/Users/KJF/Desktop/R/MacrosystemsEDDIE/CrossScale Interactions/Module_test_files/allMendota.csv')

#### PLOTS ####
attach(chla_output)
plot(DateTime, Baseline_Chla, type="l", col="black", ylim=c(0, 100),
     ylab="Chlorophyll-a (ug/L)", xlab="Date")  
lines(DateTime, Climate_Chla, col="red") 
lines(DateTime, LandUse_Chla, col="blue") 
lines(DateTime, Climate_LandUse_Chla, col="green")
legend("topleft",c("Baseline", "Climate Only", "Land Use Only", "Combined C + LU"), 
       lty=c(1,1,1,1), col=c("black","red","blue", "green")) 