########## ACTIVITY A - OBJECTIVE 1 ############################################
pacman::p_load(glmtools, readxl, tidyverse)
glm_version() 

ComputerName <- 'KJF' ##!! Change to match your computer name
LakeName <- 'Toolik' 

sim_folder <- paste('C:/Users/',ComputerName,'/Desktop/R/MacrosystemsEDDIE/Teleconnections/Lakes/',LakeName, sep='') #KF dev placeholder
setwd(sim_folder)

##### SCENARIO 1: BASELINE ####
nml_file <- paste0(sim_folder,"/glm2.nml")
nml <- read_nml(nml_file) 

run_glm(sim_folder, verbose=TRUE) 
baseline <- file.path(sim_folder, 'output.nc') 

plot_temp(file=baseline, fig_path=FALSE) 

lake_level1 <- get_surface_height(baseline)
plot(surface_height ~ DateTime, data = lake_level1, type="l", col="black", 
     ylab = "Lake depth (m)", xlab = "Date", ylim=c((nml$init_profiles$lake_depth-(nml$init_profiles$lake_depth*.4)), 
                                                    (nml$init_profiles$lake_depth+(nml$init_profiles$lake_depth*.4))))

temp_output <- get_temp(file=baseline, reference='surface', z_out=c(1)) 
colnames(temp_output)[2] <- "Baseline_Surface_Temp" 
depth_output <- lake_level1
colnames(depth_output)[2] <- "Baseline_Lake_Depth" 

########## SCENARIO 2: AVERAGE EL NINO ############################################
annual_temp <- read_excel(paste('C:/Users/',ComputerName,'/Desktop/R/MacrosystemsEDDIE/Teleconnections/Lake_Characteristics.xlsx', sep=''), 
                          sheet = LakeName) %>% filter(Year >= 1970)

ElNino_years <- subset(annual_temp, Type == "ElNino") 
Neutral_years <- subset(annual_temp, Type == "Neutral") 

mod_ElNino <- lm(`Air Temp Mean (°C)` ~ Year, data = ElNino_years) 
slope_ElNino = summary(mod_ElNino)$coeff[2]
int_ElNino = summary(mod_ElNino)$coeff[1]

ElNino_2013 <- (slope_ElNino * 2013) + int_ElNino

mod_Neutral <- lm(`Air Temp Mean (°C)` ~ Year, data = Neutral_years) 
slope_Neutral = summary(mod_Neutral)$coeff[2]
int_Neutral = summary(mod_Neutral)$coeff[1]

Neutral_2013 <- (slope_Neutral * 2013) + int_Neutral

plot(`Air Temp Mean (°C)` ~ Year, data = annual_temp, pch = 16, col = 'gray70')
points(`Air Temp Mean (°C)` ~ Year, data = ElNino_years, pch = 16, col = 'red')
points(`Air Temp Mean (°C)` ~ Year, data = Neutral_years, pch = 16, col = 'black')
legend("topleft",c("All Years", "El Nino", "Neutral"), pch=16, col=c("gray70", "red", "black"))
abline(a = int_ElNino, b = slope_ElNino, col= 'red', lty=2)
abline(a = int_Neutral, b = slope_Neutral, col = 'black', lty=2)

offset <- ElNino_2013 - Neutral_2013 
offset 

baseline_met <- paste0(sim_folder,"/met_hourly.csv")
met_data <- read_csv(baseline_met)

Average_ElNino_met <- mutate(met_data, AirTemp = AirTemp + (offset))
write.csv(Average_ElNino_met, paste0(sim_folder, "/met_hourly_scenario2.csv"), 
          row.names=FALSE, quote=FALSE)

### EDIT NML FILE
nml <- read_nml(nml_file) 
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE) 
Average_ElNino <- file.path(sim_folder, 'output.nc') 

`*tmp*` <- get_temp(file= Average_ElNino, reference= 'surface', z_out= c(1))
temp_output["Average_ElNino_Surface_Temp"] <- `*tmp*`[2] 
`*tmp*` <- get_surface_height(Average_ElNino) 
depth_output["Average_ElNino_Lake_Depth"] <- `*tmp*`[2] 

#plot_temp(file=Average_ElNino, fig_path=FALSE) 

########## SCENARIO 3: MAXIMUM EL NINO ############################################
plot(`Air Temp Mean (°C)` ~ Year, data = annual_temp, pch = 16, col = 'gray70')
points(`Air Temp Mean (°C)` ~ Year, data = ElNino_years, pch = 16, col = 'red')
points(`Air Temp Mean (°C)` ~ Year, data = Neutral_years, pch = 16, col = 'black')
legend("topleft",c("All Years", "El Nino", "Neutral"), pch=16, col=c("gray70", "red", "black")) 
abline(a = int_ElNino, b = slope_ElNino, col= 'red', lty=2)
abline(a = int_Neutral, b = slope_Neutral, col = 'black', lty=2)

maxOffsets <- ElNino_years %>% select(`Lake ID`, Type, Year, `Air Temp Mean (°C)`) 

maxOffsets <- maxOffsets %>%mutate(Neutral_Est = (slope_Neutral * .$Year) + int_Neutral,
         Offset = `Air Temp Mean (°C)` - Neutral_Est)

maxOffset_year <- maxOffsets$Year[which.max(maxOffsets$Offset)]
maxOffset_year

maxOffset_degrees <- max(maxOffsets$Offset)
maxOffset_degrees

baseline_met <- paste0(sim_folder,"/met_hourly.csv")
met_data <- read_csv(baseline_met)
Max_ElNino_met <- mutate(met_data, AirTemp = AirTemp + (maxOffset_degrees))
write.csv(Max_ElNino_met, paste0(sim_folder, "/met_hourly_scenario3.csv"), 
          row.names=FALSE, quote=FALSE)

### EDIT NML FILE
nml <- read_nml(nml_file) 
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE) 
Max_ElNino <- file.path(sim_folder, 'output.nc') 

`*tmp*` <- get_temp(file= Max_ElNino, reference= 'surface', z_out= c(1))
temp_output["Max_ElNino_Surface_Temp"] <- `*tmp*`[2] 
`*tmp*` <- get_surface_height(Max_ElNino)
depth_output["Max_ElNino_Lake_Depth"] <- `*tmp*`[2] 

#plot_temp(file=Max_ElNino, fig_path=FALSE)

########## ACTIVITY C - OBJECTIVE 5 ############################################
attach(temp_output)
plot(DateTime, Baseline_Surface_Temp, type="l", col="black", xlab="Date",
     ylab="Surface water temperature (C)", lwd=2, ylim=c(0,22))  
lines(DateTime, Average_ElNino_Surface_Temp, lwd=2, col="orange1") 
lines(DateTime, Max_ElNino_Surface_Temp, lwd=2, col="red") 
legend("topleft",c("Baseline", "Average El Nino", "Max. El Nino"), lty=c(1,1,1), 
       lwd=c(2,2,2), col=c("black","orange", "red")) 

attach(depth_output)
plot(DateTime, Baseline_Lake_Depth, type="l", col="black", xlab="Date",
     ylab="Lake depth (m)", lwd=1.5, ylim=c((nml$init_profiles$lake_depth-(nml$init_profiles$lake_depth*.1)), 
                                            (nml$init_profiles$lake_depth+(nml$init_profiles$lake_depth*.1))))  
lines(DateTime, Average_ElNino_Lake_Depth, lwd=1.5, col="orange1")
lines(DateTime, Max_ElNino_Lake_Depth, lwd=1.5, col="orange1") 
legend("topleft",c("Baseline", "Average El Nino", "Max. El Nino"), lty=c(1,1,1), 
       lwd=c(1.5,1.5,1.5), col=c("black","orange", "red")) 

##### PLOTS FOR ASSESSMENTS #####
mytheme <- theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(),
                 panel.background = element_blank(), axis.line.x = element_line(colour = "black"),
                 axis.line.y = element_line(colour = "black"), axis.text.x=element_text(size=16, colour='black'),
                 axis.text.y=element_text(size=16, colour='black'), axis.title.x=element_text(size=16),
                 axis.title.y=element_text(size=16), legend.title=element_text(size=16), 
                 legend.text=element_text(size=14))

temps <- temp_output %>% gather(Scenario, Temp, Baseline_Surface_Temp:Max_ElNino_Surface_Temp) %>%
  mutate(Scenario = factor(Scenario, 
                              levels=c('Baseline_Surface_Temp','Average_ElNino_Surface_Temp',
                                                 'Max_ElNino_Surface_Temp'), 
                              labels= c('Baseline','Average El Niño', 'Maximum El Niño')))

ggplot(temps, aes(x = DateTime, y = Temp, col = Scenario)) + mytheme + 
  geom_line(lwd=1.25) + 
  theme(legend.position=c(0.01,1), legend.justification = c(0,1),
        axis.text.x = element_text(angle = 30, hjust = 1)) +
  scale_color_manual("Scenario", values =c('black','dodgerblue','red')) +
  scale_x_datetime(date_breaks = '2 months', date_labels = "%b-%Y") +
  labs(y = expression(Surface~water~temperature~~(degree*C)), x = "Date")
