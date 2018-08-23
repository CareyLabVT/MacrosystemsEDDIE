pacman::p_load(glmtools, readxl, tidyverse)

# Set up lake ####
ComputerName <- 'KJF' ##!! Change to match your computer name
LakeName <- 'Prairie Pothole' ##!! Change to match the lake you and your partner selected

sim_folder <- paste('C:/Users/',ComputerName,'/Desktop/R/MacrosystemsEDDIE/Teleconnections/Lakes/',LakeName, sep='') #KF dev placeholder
setwd(sim_folder) 

##### SCENARIO 1: BASELINE ####
nml_file <- paste0(sim_folder,"/glm2.nml")
nml <- read_nml(nml_file) 

run_glm(sim_folder, verbose=TRUE) 
baseline <- file.path(sim_folder, 'output.nc')

lake_level1 <- get_surface_height(baseline)

plot(surface_height ~ DateTime, data = lake_level1, type="l", col="black", 
     ylab = "Lake depth (m)", xlab = "Date", ylim=c((nml$init_profiles$lake_depth-(nml$init_profiles$lake_depth*.4)), (nml$init_profiles$lake_depth+(nml$init_profiles$lake_depth*.4))))

plot_temp(baseline)

temp_output <- get_temp(file=baseline, reference='surface', z_out=c(1)) 
colnames(temp_output)[2] <- "Baseline_Surface_Temp"

depth_output <- lake_level1
colnames(depth_output)[2] <- "Baseline_Lake_Depth"

##### SCENARIO 2: "BASED ON AVERAGING" ####
annual_temp <- read_excel(paste('C:/Users/',ComputerName,'/Desktop/R/MacrosystemsEDDIE/Teleconnections/Lake_Characteristics.xlsx', sep=''), 
                          sheet = LakeName) %>% filter(Year >= 1970)

ElNino_years <- subset(annual_temp, Type == "ElNino") # Define El Nino years
Neutral_years <- subset(annual_temp, Type == "Neutral") # Define Neutral years

plot(`Air Temp Mean (°C)` ~ Year, data = annual_temp, pch = 16, col = 'gray70')
points(`Air Temp Mean (°C)` ~ Year, data = ElNino_years, pch = 16, col = 'red')
points(`Air Temp Mean (°C)` ~ Year, data = Neutral_years, pch = 16, col = 'black')

mod_ElNino <- lm(`Air Temp Mean (°C)` ~ Year, data = ElNino_years) 
slope_ElNino = summary(mod_ElNino)$coeff[2]
int_ElNino = summary(mod_ElNino)$coeff[1]

# We plug in the slope and intercept to estimate the air temperature if 
#  2013 (the year of our model) was an El Nino year 
ElNino_2013 <- (slope_ElNino * 2013) + int_ElNino

# Next, we estimate the slope and intercept of a line fit through the Neutral
#  data points, using a simple linear model
mod_Neutral <- lm(`Air Temp Mean (°C)` ~ Year, data = Neutral_years) 
slope_Neutral = summary(mod_Neutral)$coeff[2]
int_Neutral = summary(mod_Neutral)$coeff[1]

# As before, we plug in the slope and intercept to estimate the air temperature if 
#  2017 (the last year of our model) was a neutral year 
Neutral_2013 <- (slope_Neutral * 2013) + int_Neutral

abline(a = int_ElNino, b = slope_ElNino, col= 'red', lty=2)
abline(a = int_Neutral, b = slope_Neutral, col = 'black', lty=2)

# Next, we calculate the estimated El Nino offset as the difference between 
#  air temperatures in El Nino years vs. other years
offset <- ElNino_2013 - Neutral_2013 # Save the offset as the "offset" object
offset # Run this line to have R print out what your temperature offset is


#### SCENARIO 3: OFFSET BASED ON STRONGEST LOCAL OFFSET ####
maxOffsets <- ElNino_years %>% select(`Lake ID`, Type, Year, `Air Temp Mean (°C)`) %>%
  mutate(Neutral_Est = (slope_Neutral * .$Year) + int_Neutral,
         Offset = `Air Temp Mean (°C)` - Neutral_Est)
  

maxOffset_year <- maxOffsets$Year[which.max(maxOffsets$Offset)]
maxOffset_degrees <- max(maxOffsets$Offset)  ##!! change year here in var name



#### PLOT ALL SCENARIOS ####
attach(temp_output)
plot(DateTime, Baseline_Surface_Temp, type="l", col="black", xlab="Date",
     ylab="Surface water temperature (C)", ylim=c(0, 20))  
lines(DateTime, ElNino_Surface_Temp, col="red")
legend("topleft",c("Baseline", "El Nino"), lty=c(1,1), col=c("black","red")) 
# this adds a legend

attach(depth_output)
plot(DateTime, Baseline_Lake_Depth, type="l", col="black", xlab="Date",
     ylab="Lake depth (m)", ylim=c(15,18))  
lines(DateTime, ElNino_Lake_Depth, col="red") 
legend("topleft",c("Baseline", "El Nino"), lty=c(1,1), col=c("black","red"))



#### SET UP MET FILES FOR SCENARIO 2 #####
baseline_met <- paste0(sim_folder,"/met_hourly.csv")
met_data <- read_csv(baseline_met)

offset_multiplier <- 1

ElNino_met <- mutate(met_data, AirTemp = AirTemp + (offset * offset_multiplier))
write.csv(ElNino_met, paste0(sim_folder, "/met_hourly_averageelnino.csv"), 
          row.names=FALSE, quote=FALSE)

nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE) # Run your GLM model for your El Nino scenario. 
ElNino <- file.path(sim_folder, 'output.nc')

`*tmp*` <- get_temp(file= ElNino, reference= 'surface', z_out= c(1))
temp_output["AverageElNino_Surface_Temp"] <- `*tmp*`[2] 

`*tmp*` <- get_surface_height(ElNino) # Extract the daily water depth 
depth_output["AverageElNino_Lake_Depth"] <- `*tmp*`[2] 


