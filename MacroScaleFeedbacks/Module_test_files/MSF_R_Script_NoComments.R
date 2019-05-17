library(glmtools)
#glm_version() 

##!! Edit this line to define the sim_folder location for your model lake. 
# sim_folder <- '/Users/cayelan/Desktop/macroscale_feedbacks/LakeName' 
sim_folder <- "C:/Users/KJF/Desktop/R/MacrosystemsEDDIE/MacroScaleFeedbacks/Sunapee" # KF testing placeholder
setwd(sim_folder) 

nml_file <- paste0(sim_folder,"/glm2.nml") 
nml <- read_nml(nml_file) 

#plot_meteo(nml_file)  

run_glm(sim_folder, verbose=TRUE) 
baseline <- file.path(sim_folder, 'output.nc') 

#plot_temp(file=baseline, col_lim= c(0,30)) 

ch4_output <- get_var(file=baseline, "CAR_atm_ch4_exch") 
colnames(ch4_output)[2] <- "Baseline_CH4" 

co2_output <- get_var(file=baseline, "CAR_atm_co2_exch") 
colnames(co2_output)[2] <- "Baseline_CO2" 

plot(Baseline_CH4 ~ DateTime, data= ch4_output, type='b', pch=20, lwd=2, col='gray20',
     ylab = "Methane flux, (mmol/m2/d)")
abline(h= 0, col= 'black', lty= 3, lwd= 3) 

plot(Baseline_CO2 ~ DateTime, data= co2_output, type='b', pch=20, lwd=2, col='gray20',
     ylab = "Carbon dioxide flux, (mmol/m2/d)")
abline(h= 0, col= 'black', lty= 3, lwd= 3) 

########## ACTIVITY B - OBJECTIVE 3 ############################################
# Plus 2
nml <- read_nml(nml_file)   
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE) 
climate <- file.path(sim_folder, 'output.nc') 

climate_ch4 <- get_var(file=climate, "CAR_atm_ch4_exch") 
ch4_output["Plus2_CH4"] <- climate_ch4[2] 

climate_co2 <- get_var(file=climate, "CAR_atm_co2_exch") 
co2_output["Plus2_CO2"] <- climate_co2[2] 

# Plus 4
nml <- read_nml(nml_file)   
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE) 
climate <- file.path(sim_folder, 'output.nc') 

#plot_temp(climate, col_lim= c(0,32))


climate_ch4 <- get_var(file=climate, "CAR_atm_ch4_exch") 
ch4_output["Plus4_CH4"] <- climate_ch4[2] 

climate_co2 <- get_var(file=climate, "CAR_atm_co2_exch") 
co2_output["Plus4_CO2"] <- climate_co2[2] 

# Plus 6
nml <- read_nml(nml_file)   
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE) 
climate <- file.path(sim_folder, 'output.nc') 

climate_ch4 <- get_var(file=climate, "CAR_atm_ch4_exch") 
ch4_output["Plus6_CH4"] <- climate_ch4[2] 

climate_co2 <- get_var(file=climate, "CAR_atm_co2_exch") 
co2_output["Plus6_CO2"] <- climate_co2[2] 

write.csv(ch4_output, './ch4model_output_all.csv', quote=F, row.names = F)
write.csv(co2_output, './co2model_output_all.csv', quote=F, row.names = F)

########## ACTIVITY C - OBJECTIVE 5 ############################################
lakearea <- max(nml$morphometry$A)

BaselineCO2mass <- sum(co2_output$Baseline_CO2) * lakearea * 44.01 / 1000000
BaselineCH4mass <- sum(ch4_output$Baseline_CH4) * lakearea * 16.04 / 1000000
GWP_baseline <- (BaselineCO2mass * 1) + (BaselineCH4mass * 86)

Plus2CO2mass <- sum(co2_output$Plus2_CO2) * lakearea * 44.01 / 1000000
Plus2CH4mass <- sum(ch4_output$Plus2_CH4) * lakearea * 16.04 / 1000000
Plus2_climate <- (Plus2CO2mass * 1) + (Plus2CH4mass * 86)

Plus4CO2mass <- sum(co2_output$Plus4_CO2) * lakearea * 44.01 / 1000000
Plus4CH4mass <- sum(ch4_output$Plus4_CH4) * lakearea * 16.04 / 1000000
Plus4_climate <- (Plus4CO2mass * 1) + (Plus4CH4mass * 86)

Plus6CO2mass <- sum(co2_output$Plus6_CO2) * lakearea * 44.01 / 1000000
Plus6CH4mass <- sum(ch4_output$Plus6_CH4) * lakearea * 16.04 / 1000000
Plus6_climate <- (Plus6CO2mass * 1) + (Plus6CH4mass * 86)

########## ACTIVITY C - OBJECTIVE 6 ############################################
data <- matrix(ncol=3, nrow=4) 
data[1,] <- c(BaselineCO2mass, BaselineCH4mass, GWP_baseline)
data[2,] <- c(Plus2CO2mass, Plus2CH4mass, Plus2_climate)
data[3,] <- c(Plus4CO2mass, Plus4CH4mass, Plus4_climate)
data[4,] <- c(Plus6CO2mass, Plus6CH4mass, Plus6_climate)
row.names(data) <- c("Baseline", "Plus2", "Plus4","Plus6")
colnames(data) <- c("CO2 mass", "CH4 mass", "GWP")

barplot(data, col=c("gray20","red2", 'red3','red4'), 
        font.axis=2, beside=T, ylab="kg or GWP", 
        #main=paste0(nml$morphometry$lake_name,", ", nml$meteorology$meteo_fl),
        font.lab=2, ylim= c(-25000, 5))
abline(h = 0, col = 'black', lty = 1, lwd=1) 
legend("bottomleft", legend=rownames(data), pch = 19, col=c("gray20","red2", 'red3','red4'))
