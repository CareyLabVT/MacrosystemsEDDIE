pacman::p_load(glmtools, readxl, dplyr, tidyr) 

LakeName <- 'Suggs' 
sim_folder <- paste('C:/Users/KJF/Desktop/R/MacrosystemsEDDIE/Teleconnections/proxyLakes/',LakeName, sep='') 
setwd(sim_folder) 

nml_file <- paste0(sim_folder,"/glm2.nml") 
nml <- read_nml(nml_file) 

run_glm(sim_folder, verbose=TRUE) 
baseline <- file.path(sim_folder, 'output.nc') 

lakeDepth <- get_surface_height(baseline)

lakeTemp_output <- get_temp(file=baseline, reference='surface', z_out=c(0, min(lakeDepth$surface_height)))
colnames(lakeTemp_output)[2:3] <- c("Baseline_Surface_Temp", "Baseline_Bottom_Temp") 

ice <- get_var(baseline, "hice") 
colnames(ice)[2] <- "Baseline"

#### SCENARIO 2 ####
annual_temp <- read_excel(paste(sim_folder,'/Lake_Characteristics.xlsx', sep=''), 
                          sheet = LakeName) %>% filter(Year >= 1970)
Neutral_years <- subset(annual_temp, Type == "Neutral") # Here we define Neutral years
ElNino_years <- subset(annual_temp, Type == "ElNino") # Here we define El Nino years
mod_Neutral <- lm(AirTemp_Mean_C ~ Year, data = Neutral_years) 
slope_Neutral = summary(mod_Neutral)$coeff[2] # Save the model slope
int_Neutral = summary(mod_Neutral)$coeff[1] # Save the model intercept
Neutral_2013 = (slope_Neutral * 2013) + int_Neutral # Notice this form is y = (m*x) + b
mod_ElNino <- lm(AirTemp_Mean_C ~ Year, data = ElNino_years) 
slope_ElNino = summary(mod_ElNino)$coeff[2] # Save the model slope
int_ElNino = summary(mod_ElNino)$coeff[1] # Save the model intercept
ElNino_2013 <- (slope_ElNino * 2013) + int_ElNino
typicalOffset_degrees <- ElNino_2013 - Neutral_2013 # This line estimates the typical El Nino offset

nml <- read_nml(nml_file) 
get_nml_value(nml, 'meteo_fl')
run_glm(sim_folder, verbose=TRUE)
Typical_ElNino <- file.path(sim_folder, 'output.nc')

scenario2_temp <- get_temp(file= Typical_ElNino, reference= 'surface', z_out= c(0, min(lakeDepth$surface_height)))
lakeTemp_output["Typical_ElNino_Surface_Temp"] <- scenario2_temp[2]
lakeTemp_output["Typical_ElNino_Bottom_Temp"]  <- scenario2_temp[3] 

scenario2_ice <- get_var(baseline, "hice") # Extract ice cover data
ice["Typical"] <- scenario2_ice[2]  # Rename the ice column 

#### SCENARIO 3 ####
offsets <- ElNino_years %>% select(`Lake ID`, Type, Year, AirTemp_Mean_C) 
offsets <- offsets %>%
  mutate(Neutral_Est = (slope_Neutral * .$Year) + int_Neutral,
         Offset = AirTemp_Mean_C - Neutral_Est)
maxOffset_year <- offsets$Year[which.max(offsets$Offset)]
maxOffset_degrees <- max(offsets$Offset)  


nml <- read_nml(nml_file)  
get_nml_value(nml, 'meteo_fl')
run_glm(sim_folder, verbose=TRUE) 
Strong_ElNino <- file.path(sim_folder, 'output.nc') 

scenario3_temp <- get_temp(file= Strong_ElNino, reference= 'surface', z_out= c(0, min(lakeDepth$surface_height)))
lakeTemp_output["Strong_ElNino_Surface_Temp"] <- scenario3_temp[2] 
lakeTemp_output["Strong_ElNino_Bottom_Temp"]  <- scenario2_temp[3] 

scenario3_ice <- get_var(baseline, "hice") 
ice["Strong"] <- scenario3_ice[2]

########## PLOTS ########
attach(lakeTemp_output)
plot(x = DateTime, y = Baseline_Surface_Temp, type="l", col="black", xlab="Date",
     ylab="Surface water temperature (C)", lwd=2, ylim=c(0,30)) 
lines(x = DateTime, y = Typical_ElNino_Surface_Temp, lwd=2, col="orange2") 
lines(x = DateTime, y = Strong_ElNino_Surface_Temp, lwd=2, col="red2")
lines(x = DateTime, y = Baseline_Bottom_Temp, lwd=2, lty=2, col="black")
lines(x = DateTime, y = Typical_ElNino_Bottom_Temp, lwd=2, lty=2, col="orange2")
lines(x = DateTime, y = Strong_ElNino_Bottom_Temp, lwd=2, lty=2, col="red2")
legend("topleft",c("Baseline", "Typical El Nino", "Strong El Nino"), lty=c(1,1,1), 
       lwd=c(2,2,2), col=c("black","orange2", "red2")) 
legend("topright", c("Surface", "Bottom"), lty=c(1,2), lwd=c(2,2))

iceDuration <- ice %>% gather(Scenario, Ice, Baseline:Strong) %>%
  mutate(IceStatus = ifelse(Ice > 0, "Y", "N")) %>%
  group_by(Scenario) %>%
  summarize(iceDays = length(IceStatus[IceStatus=="Y"])) %>%
  mutate(Offset = c(0, maxOffset_degrees, typicalOffset_degrees)) %>%
  arrange(Offset)

attach(iceDuration)
plot(x = Offset, y = iceDays, type="b", pch=16, col=c("black", "orange1", "red2"), cex=2,
     xlab= "Temperature offset (C)", ylab= "Days with surface ice",
     ylim=c(170,200))
legend("topleft",c("Baseline", "Typical El Nino", "Strong El Nino"), pch=16, 
       col=c("black","orange2", "red2"))
