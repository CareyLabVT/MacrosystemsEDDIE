# Teleconnections Module ####
# This module was developed by Farrell, K.J. and C.C. Carey. 18 May 2018.
 # Macrosystems EDDIE: Teleconnections. 
 # Macrosystems EDDIE Module 3, Version 1. 
 # https://serc.carleton.edu/eddie/macrosystems/module3
 # Module development was supported by NSF EF 1702506.

# R code for students to work through the module activities A, B, and C.

########## ACTIVITY A - OBJECTIVE 1 ############################################
# Download R packages and GLM files successfully onto your computer.

install.packages('sp') # NOTE: You may get output that says, "There is a binary 
  #  version available. Do you want to install from sources that need compilation? y/n" 
  #  If this pops up, type 'y' (without the quotes) and hit enter. You may now be 
  #  prompted to download the command line developer tools in a pop-up window. 
  #  Command line developer tools is a program used to run modeling software. Click 
  #  Install and then re-run the install.packages('sp') once the install of the tools 
  #  is finished. This should now successfully load- when it's done, it should say 'DONE(sp)'.

install.packages('devtools') # This is another R package used to run modeling 
  #  software. If you get an error message that says, "package ‘devtools’ is not 
  #  available (for R version x.x.x)", be sure to check that your R software is up 
  #  to date to the most recent version.

library(sp) # load the packages you just downloaded
library(devtools) 

devtools::install_github("CareyLabVT/GLMr", force = TRUE) # Download the GLMr 
  #  software. This may take a few minutes. If downloaded successfully, you should 
  #  see "DONE (GLMr)" at the end of the output.

install.packages('glmtools', repos=c('http://cran.rstudio.com', 'http://owi.usgs.gov/R')) # This step 
# downloads the R packages that allow you to work with GLM in R through the USGS 
# website. Note: if you are on	a slow internet connection, this may take a few minutes.

library(glmtools) # Load the two packages that you need to analyze GLM output
#  NOTE: you may get lots of output messages in red at this step- if this worked 
  #  successfully, you should read a lot of text that starts with: "This 
  #  information is preliminary or provisional..." 

glm_version() # See what version of GLM you are running- should be v.2.x.x

# CONGRATS! You've now succesfully loaded GLM onto your computer! 
  # Now, we will explore the files that come with your downloaded GLM files 

# NOTE! Throughout the rest of the module, you will need to modify some of the 
  #  lines of code to run on your computer. If you need to modify a line, I put the 
  #  symbols ##!! at the beginning of that line's annotation.  If you do not see those 
  #  symbols, you do not need to edit that line of code and can run it as written.

LakeName <- 'Name' ##!! Change 'Name' to match the lake you and your partner selected
# The lake name options are: 'Barco', 'Crampton', 'Falling Creek', 'Mendota',
  # 'Prairie Pothole', 'Suggs', 'Sunapee', and 'Toolik'

  # Be careful to check that you use the exact same capitalization & spacing as 
  # in your lake's folder name!!

# When working in R, we set the sim_folder to tell R where your files, scripts, 
  #  and model output are stored.  
# To find your folder path, navigate to the 'teleconnections' folder on your Desktop,
  # then open the Lakes folder. Right click on the folder that matches your model lake, 
  # then select Properties (Windows) or Get Info (Mac). Look under Location (Windows) 
  # or Where (Mac) to find your folder path (examples below):
  # Windows: C:/Users/KJF/Desktop/cross_scale_interactions
  # Mac: Macintosh HDD -> Users -> careylab -> Desktop

# KJF testing placeholder
sim_folder <- paste('C:/Users/KJF/Desktop/R/MacrosystemsEDDIE/Teleconnections/Lakes/',LakeName, sep='') #KF dev placeholder

#sim_folder <- '/Users/cayelan/Desktop/teleconnections/Lakes/LakeName' ##!! Edit this line 
  #  to define the sim_folder location for your model lake. You will need to change 
  #  the part after Users/ to give the name of your computer (e.g., my computer name 
  #  is cayelan, but yours will be different!) AND change the LakeName part to be 
  #  the name of your model lake.

setwd(sim_folder) ## This line of code is used to reset your working directory
  #  to the sim_folder. The point of this step is to make sure that any new files 
  #  you create (e.g., figures of output) end up together in this folder.

nml_file <- paste0(sim_folder,"/glm2.nml") # This step sets the nml_file for your 
  #  simulation to be in the new sim_folder location.

nml <- read_nml(nml_file) # Read in your nml file from your new directory

print(nml) # This shows you what is in your nml file.  This is the 'master script' 
  #  of the GLM simulation; the nml file tells the GLM model all of the initial 
  #  conditions about your lake, how you are defining parameters, and more - this 
  #  is a really important file! There should be multiple sections, including 
  #  glm_setup, morphometry, meteorology, etc.

plot_meteo(nml_file) # This command plots the meterological input data for the 
  #  simulation: short wave & long wave radiation, air temp, relative humidity, 
  #  etc. for the duration of the simulation. 
 
########## ACTIVITY A - OBJECTIVE 2 ############################################
# Now, the fun part- we get to run the model and look at output!

run_glm(sim_folder, verbose=TRUE) # So simple and elegant... if this works, you 
  #  should see output that says "Simulation begins.." and then shows all the 
  #  time steps.  At the end, it should say "Run complete" if everything worked 
  #  ok. This may take a few minutes.

# We need to know where the output data from your simulation (the output.nc file) 
  #  is so that the glmtools package can plot and analyze the model output. We tell 
  #  R where to find the output file using the line below:

baseline <- file.path(sim_folder, 'output.nc') # This says that the output.nc 
  #  file is in the sim_folder  

plot_temp(file=baseline, fig_path=FALSE) # This plots your 
  #  simulated lake temperatures in a heat map, where time is displayed on the 
  #  x-axis, lake depth is displayed on the y-axis, and the different colors 
  #  represent different water temperatures. 

# To copy your plot (e.g., onto a PowerPoint slide), click "Export" within the 
  #  Plots tab. Then click "Copy to Clipboard", and click "Copy plot" in the preview 
  #  window. You can then paste your plot into Word, PowerPoint, etc. 

# If you want to save your plot as an image file or pdf file instead of copying 
  #  it, click "Export" within the Plots tab, then choose "Save as Image" or "Save 
  #  as PDF". In the preview window, give your plot a descriptive file name (e.g., 
  #  "TemperatureHeatMap.pdf"), then press "Save". Your plot image and/or PDF file 
  #  will be saved in the sim_folder on your Desktop.

# Note that if you want to save plots, you should copy and paste them as you go!

# This pair of commands can be used to list the variables that were output as part 
  #  of your GLM run.
var_names <- sim_vars(baseline)
print(var_names) # This will print a list of variables that the model simulates.

# We are particularly interested in the water level (depth), as teleconnections could change
  #  the water level over time through increased or decreased evaporation from the
  #  water surface. We use the following command to pull the daily "surface height" 
  #  out of the model output and plot it as a function of time. The unit of 
  #  measurement for water level is meters (m).
water_level1 <- get_surface_height(baseline)

# Calculate the maximum and minimum water level of your lake
max(water_level1$surface_height) # Maximum
min(water_level1$surface_height) # Minimum

# Use the code below to create a plot of water level in the lake over time. 
plot(surface_height ~ DateTime, data = water_level1, type="l", col="black", 
     ylab = "Water level (m)", xlab = "Date", ylim=c(0,4))
##!! Note that the command ylim=c(min,max) tells R the minimum and maximum y-axis 
  #  values to plot. You will need to adjust the minimum and maximum values 
  #  to make sure all your data are shown. A range slightly higher than what you
  #  just calculated for the max. and min. above would probably work well!

# We also want to save the model output of the lake temperature and water level 
  #  during our baseline simulation, because we'll be comparing it to our teleconnection 
  #  scenario later. To do this, we use the following  commands:

lakeTemp_output <- get_temp(file=baseline, reference='surface', 
                        z_out=c(0, min(water_level1$surface_height))) # This command 
  #  extracts the water temperature at the surface and 2 meters above the lake bottom
  #  for each day and saves the temperatures as "lakeTemp_output"

colnames(lakeTemp_output)[2:3] <- c("Baseline_Surface_Temp", "Baseline_Bottom_Temp") # This command
  #  renames the two temperature columns so we remember they are from the Baseline scenario

waterLevel_output <- water_level1 # This command extracts the daily water level and saves it as "waterLevel_output"
colnames(waterLevel_output)[2] <- "Baseline_Water_Level" # This command renames the water level column

# Finally, we'll extract and save model output for ice cover on the lake during our 
  # baseline scenario. We do this by running the following lines of code: 
ice <- get_var(baseline, "hice") # Extract ice cover data
colnames(ice)[2] <- "Baseline" # Rename column so we know it's from the Baseline scenario

########## ACTIVITY B - OBJECTIVE 3 ############################################
# For Activity B, you will work with your partner to model your lake under two 
  #  teleconnections scenarios of simulated El Nino conditions. To do this, we will use 
  #  observed, historical climate data to estimate how much warmer or cooler your 
  #  lake's local air temperature would likely be during an El Nino year. 

install.packages('readxl') # Install this package to read Excel (.xlsx) files 
  #  directly into R

install.packages('dplyr') # Install these packages to make manipulating data easy
install.packages('tidyr')

library(readxl) # Now load the packages you just installed
library(dplyr)
library(tidyr)

# First, read in the observational data for your lake using the command below:
annual_temp <- read_excel(paste(sim_folder,'/Lake_Characteristics.xlsx', sep=''), 
                          sheet = LakeName) %>% filter(Year >= 1970)

# Use the command below to take a look at the file:
View(annual_temp)

# The data we'll be using to estimate El Nino temperature offsets is "Air Temp Mean (°C)",
  #  or the annual average air temperature for your lake.

# Let's look at how annual air temperature differs between El Nino years and 
  #  non-El Nino years for your lake. First, we'll subset the data into El Nino years
  #  and neutral (neither El Nino nor La Nina) years. 
Neutral_years <- subset(annual_temp, Type == "Neutral") # Define Neutral years
ElNino_years <- subset(annual_temp, Type == "ElNino") # Define El Nino years

# Visualize your lake's patterns in air temperature over time using the commands below:
plot(AirTemp_Mean_C ~ Year, data = annual_temp, pch = 16, col = 'gray70')
points(AirTemp_Mean_C ~ Year, data = ElNino_years, pch = 16, col = 'red')
points(AirTemp_Mean_C ~ Year, data = Neutral_years, pch = 16, col = 'black')
legend("topleft",c("All Years", "El Nino", "Neutral"), pch=16, col=c("gray70", "red", "black")) 
# Now, we need to estimate how much warmer or colder a typical El Nino year is 
  #  compared to a neutral year. 

# We'll do that by calculating the slope of the line between temperature and year
  # separately for both neutral years and El Nino years

# First, we estimate the slope and intercept of a line fit through the Neutral
  #  data points, using a simple linear model
mod_Neutral <- lm(AirTemp_Mean_C ~ Year, data = Neutral_years) 
slope_Neutral = summary(mod_Neutral)$coeff[2] # Save the model slope
int_Neutral = summary(mod_Neutral)$coeff[1] # Save the model intercept

# As before, we plug in the slope and intercept to estimate the air temperature in 
  #  2013 (the year of our model), which was a neutral year 
Neutral_2013 <- (slope_Neutral * 2013) + int_Neutral
print(Neutral_2013) # Run this line to have R print out the value you just calculated

# Next, we estimate the slope and intercept of a line fit through the El Nino
  #  data points, using a simple linear model
mod_ElNino <- lm(AirTemp_Mean_C ~ Year, data = ElNino_years) 
slope_ElNino = summary(mod_ElNino)$coeff[2] # Save the model slope
int_ElNino = summary(mod_ElNino)$coeff[1] # Save the model intercept

# We plug in the slope and intercept to estimate what the air temperature 
  # would likely be if 2013 (the year of our model) was a typical El Nino year
  # (i.e., "typical" being based on the overall linear regression)
ElNino_2013 <- (slope_ElNino * 2013) + int_ElNino
print(ElNino_2013) # Run this line to have R print out the value you just calculated

# Now that we have calculated the means for each category, we can add a line 
  #  representing each to our plot: 
abline(a = int_Neutral, b = slope_Neutral, col = 'black', lty=2)
abline(a = int_ElNino, b = slope_ElNino, col= 'red', lty=2)

# Next, we calculate the estimated El Nino offset as the difference between 
  #  air temperatures in typical El Nino years vs. other years
typicalOffset_degrees <- ElNino_2013 - Neutral_2013 # Save the offset as the "offset" object
print(typicalOffset_degrees) # Run this line to have R print out what your temperature offset is

# Now, we need to create a new meteorological driver file for GLM that has air
  #  temperatures adjusted to reflect our lake's estimated temperature difference
  #  for a typical El Nino year.

# We can do that all in R (no Excel needed!!) 
  # First, we read in the original meteorological driver data for GLM using the 
  #  following commands: 
baseline_met <- paste0(sim_folder,"/met_hourly.csv")
met_data <- read.csv(baseline_met)

# Use this command to look at the structure of your meterological driver data
View(met_data)

# Next, We create a new meteorological driver data file that has the modified 
  #  AirTemp that reflects our typical El Nino scenario. This step is complicated in Excel, 
  #  but one simple line of code in R!! 
Typical_ElNino_met <- mutate(met_data, AirTemp = AirTemp + (typicalOffset_degrees))

# Finally, we'll write our new file to a .csv that we can use to drive GLM:
write.csv(Typical_ElNino_met, paste0(sim_folder, "/met_hourly_scenario2.csv"), 
          row.names=FALSE, quote=FALSE)

##!!!!!! You now need to edit the glm2.nml file to change the name of the input 
  # meteorological file so that it reads in the new, edited file for your 
  # teleconnections scenario, not the default "met_hourly.csv".  

##!!!!!! Open the nml file by clicking 'glm2.nml' in the Files tab of RStudio, 
  # then scroll down to the meteorology section, and change the 'meteo_fl' entry 
  # to the new met file name ('met_hourly_scenario2.csv'). 

##!!!!!! Save your modified glm2.nml file.

# Once you have edited the nml file name, you can always check to make sure that 
  #  it is correct with the command:
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'meteo_fl') 
##!! The printout here should list your NEW meteorological file for your El Nino 
  #  scenario. If it doesn't, make sure you pressed the Save icon (the floppy disk) 
  #  after you changed your glm2.nml file.

# You can now run the model for your first teleconnections scenario using the 
  # new edited nml file using the commands below. Exciting!

run_glm(sim_folder, verbose=TRUE) # Run your GLM model for your El Nino scenario. 

# Again, we need to tell R where the output.nc file is so that the glmtools package 
  # can plot and analyze the model output. We tell R where to find the output file 
  # using the line below:
Typical_ElNino <- file.path(sim_folder, 'output.nc') # This defines the output.nc file 
  #  as being within the sim_folder. Note that we've called this output "ElNino" 
  #  since it is the output from our El Nino teleconnections simulation.

# As before, we want to save the model output of the daily surface lake temperature 
  # and water level during our El Nino teleconnections simulation, to compare to 
  # our baseline scenario. 

#  Use this command to extract surface and bottom water temperatures:
scenario2_temp <- get_temp(file= Typical_ElNino, reference= 'surface', z_out= c(0, min(water_level1$surface_height)))

# The next two commands attach the water temperatures from the "typical" El Nino 
  #  simulation to the same file that contains your baseline scenario temperatures. 
lakeTemp_output["Typical_ElNino_Surface_Temp"] <- scenario2_temp[2]
lakeTemp_output["Typical_ElNino_Bottom_Temp"]  <- scenario2_temp[3] 

# Extract lake level:
scenario2_level <- get_surface_height(Typical_ElNino) # Extract the daily water level 
waterLevel_output["Typical_ElNino_Water_Level"] <- scenario2_level[2] # Rename the water level column

# Extract ice: 
scenario2_ice <- get_var(baseline, "hice") # Extract ice cover data
ice["Typical"] <- scenario2_ice[2]  # Rename the ice column 

# You can now compare your El Nino scenario to your baseline for both lake 
  # temperatures and water level- well done!! 

# Plot the water temperature heatmap for the El Nino scenario using the commands 
# you learned above. 

plot_temp(file=Typical_ElNino, fig_path=FALSE) # Create a heatmap of water temperature. 
  # How does this compare to your baseline?

# Use the code below to create a plot of water level in the lake over time. 
plot(surface_height ~ DateTime, data = scenario2_level, type="l", col="black", 
     ylab = "Water Level (m)", xlab = "Date", ylim=c(0,4))
# !! Remember that the command ylim=c(min,max) tells R the minimum and maximum y-axis 
#  values to plot. Adjust this range to make sure all your data are shown.

# Note that it might be difficult to see subtle changes between scenarios using these
  # figures. In Activity C, we will make different plots that make it easier to see 
  # differences between scenarios.

##!! To check that your El Nino scenario ran correctly, run the command below, and
  # compare the water temperatures between your baseline and typical El Nino scenario.
  # They'll likely be similar, but if they're exactly the same, something might have 
  # gone wrong in setting up your El Nino scneario (likely with changing the glm2.nml file!)

########## ACTIVITY B - OBJECTIVE 4 ############################################
# We just simulated a typical El Nino, but now we want to see how the lake 
# responds to a larger perturbation

# We'll do this by creating our El Nino offset based on the largest offset our 
# lake has experienced during an El Nino year since 1970

# First, let's re-plot our observed annual temperature data
plot(AirTemp_Mean_C ~ Year, data = annual_temp, pch = 16, col = 'gray70')
points(AirTemp_Mean_C ~ Year, data = ElNino_years, pch = 16, col = 'red')
points(AirTemp_Mean_C ~ Year, data = Neutral_years, pch = 16, col = 'black')
legend("topleft",c("All Years", "El Nino", "Neutral"), pch=16, col=c("gray70", "red", "black")) 
abline(a = int_ElNino, b = slope_ElNino, col= 'red', lty=2)
abline(a = int_Neutral, b = slope_Neutral, col = 'black', lty=2)

##!! Based on this plot, which El Nino year had the highest temperature offset,
  # compared to the neutral years' regression line?

# Run the following line of code to create a new data table that contains the 
  # observed mean annual air temperature for your lake for each El Nino year 
offsets <- ElNino_years %>% select(`Lake ID`, Type, Year, AirTemp_Mean_C) 

View(offsets) # Take a look at the data sheet by running this line

# Run the following lines to calculate an estimate of what the air temperature 
  # would have likely been in each of those El Nino years IF it had been a 
  # neutral year. The final command calculates each years' offset temperature, 
  # as the difference between the El Nino observed temperature and the estimated 
  # neutral temperature
offsets <- offsets %>%
  mutate(Neutral_Est = (slope_Neutral * .$Year) + int_Neutral,
         Offset = AirTemp_Mean_C - Neutral_Est)

View(offsets)

# Here, we can use R to tell us which year had the maximum offset
maxOffset_year <- offsets$Year[which.max(offsets$Offset)]
maxOffset_year

# The command below selects the maximum offset, and saves it for us
maxOffset_degrees <- max(offsets$Offset)  
maxOffset_degrees

# Now that we know the offset for our final scenario, we need to modify the meteorological
  # driver file once more. We'll repeat the same steps we used when creating our first 
  # El Nino scenario.

# Read in the baseline met_hourly data once more:
baseline_met <- paste0(sim_folder,"/met_hourly.csv")
met_data <- read.csv(baseline_met)

# Next, We create a new meteorological driver data file that has the modified 
#  AirTemp that reflects our maximum El Nino scenario:
Strong_ElNino_met <- mutate(met_data, AirTemp = AirTemp + (maxOffset_degrees))

# Then, we write our new file to a .csv that we can use to drive GLM:
write.csv(Strong_ElNino_met, paste0(sim_folder, "/met_hourly_scenario3.csv"), 
          row.names=FALSE, quote=FALSE)

##!! Once again, you need to edit the glm2.nml file to change the name of the input 
# meteorological file so that it reads in the new, edited file for your 
# teleconnections scenario, not the default "met_hourly.csv" or the file from our
# typical El Nino scenario "met_hourly_scenario2.csv".  

##!! Open the nml file by clicking 'glm2.nml' in the Files tab of RStudio, then scroll 
# down to the meteorology section, and change the 'meteo_fl' entry to the new 
# met file name ('met_hourly_scenario3.csv'). Save your modified glm2.nml file.

# Once you have edited the nml file name, check to make sure that it is correct 
# with the commands:
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'meteo_fl') # The printout here should list your NEW meteorological 
#  file for your El Nino scenario. If it doesn't, make sure you pressed the Save 
#  icon (the floppy disk) after you changed your glm2.nml file.

# You can now run the model for your next teleconnections scenario using the 
# new edited nml file using the commands below. Exciting!

run_glm(sim_folder, verbose=TRUE) # Run your GLM model for your El Nino scenario. 

# Once more, we need to tell R where the output.nc file is. 
# We tell R where to find the output file using the line below:
Strong_ElNino <- file.path(sim_folder, 'output.nc') # This defines the output.nc file 
#  as being within the sim_folder.

# As before, we want to save the model output of the daily surface lake temperature 
# and water level during our "strong" El Nino teleconnections simulation, to compare to 
# our baseline scenario and "typical" El Nino scenario. 

#  Extract surface water temperature:
scenario3_temp <- get_temp(file= Strong_ElNino, reference= 'surface', z_out= c(0, min(water_level1$surface_height)))
lakeTemp_output["Strong_ElNino_Surface_Temp"] <- scenario3_temp[2] 
lakeTemp_output["Strong_ElNino_Bottom_Temp"]  <- scenario2_temp[3] # Here we attach the water 
# temperatures from the strong El Nino simulation to you water temperature file 

scenario3_level <- get_surface_height(Strong_ElNino) # Extract the daily water water level
waterLevel_output["Strong_ElNino_Water_Level"] <- scenario3_level[2] # Rename the water level column

# Extract ice: 
scenario3_ice <- get_var(baseline, "hice") # Extract ice cover data
ice["Strong"] <- scenario3_ice[2]  # Rename the ice column 

# Plot the heatmap of water temperatures for your maximum El Nino scenario. 
# How does it compare to the baseline? To your typical El Nino?
plot_temp(file=Strong_ElNino, fig_path=FALSE)

# Plot the water level in the lake during the maximum El Nino scenario. 
plot(surface_height ~ DateTime, data = scenario3_level, type="l", col="black", 
     ylab = "Water Level (m)", xlab = "Date", ylim=c(0,4))
# !! Don't forget to adjust your ylim values so all your data are shown.

########## ACTIVITY C - OBJECTIVE 5 ############################################
# You've run three different scenarios for your lake. That's awesome! 

# Now, we want to compare our baseline scenario to our two El Nino scenarios 
  # (typical, and highest offset)

# Let's compare the water surface temperatures from the baseline and El Nino 
  # teleconnection scenarios with a line plot.
  # The command below plots DateTime vs. Observed data from the baseline model in black: 
attach(lakeTemp_output)
plot(DateTime, Baseline_Surface_Temp, type="l", col="black", xlab="Date",
     ylab="Surface water temperature (C)", lwd=2, ylim=c(0,40))  ##!! Change ylim() values 
  # to show your data clearly!
lines(DateTime, Typical_ElNino_Surface_Temp, lwd=2, col="orange2") # this adds an orange line 
  # of the output from the typical El Nino scenario
lines(DateTime, Strong_ElNino_Surface_Temp, lwd=2, col="red2") # this adds a red line of the 
  # output from the maximum El Nino scenario

# We also want to plot the bottom-water temperature from each scenario. We do that with:
lines(DateTime, Baseline_Bottom_Temp, lwd=2, lty=2, col="black")
lines(DateTime, Typical_ElNino_Bottom_Temp, lwd=2, lty=2, col="orange2")
lines(DateTime, Strong_ElNino_Bottom_Temp, lwd=2, lty=2, col="red2")

# Now add a legend!
legend("topleft",c("Baseline", "Typical El Nino", "Strong El Nino"), lty=c(1,1,1), 
       lwd=c(2,2,2), col=c("black","orange2", "red2")) 
legend("topright", c("Surface", "Bottom"), lty=c(1,2), lwd=c(2,2))

# !! Note that the command ylim=c(0, 40) tells R what you want the minimum and 
#  maximum values on the y-axis to be (here, we're plotting from 0 to 40 degrees C). 
#  Adjust this range and rerun the plotting commands to make sure your data are 
#  clearly visualized in the plot.

# We can make a similar plot for our water level data.
##!! Modify the ylim() command below to adjust the y-axis limits so your data are
  # clearly visualized and you can compare your three scenarios. You may need to
  # try plotting a few different minimum and maximum values to get a plot that 
  # makes it possible to visualize the differences. 
attach(waterLevel_output)
plot(DateTime, Baseline_Water_Level, type="l", col="black", xlab="Date",
     ylab="Water level (m)", lwd=2, ylim=c(0,4))
lines(DateTime, Typical_ElNino_Water_Level, lwd=2, col="orange1") # this adds an orange line 
# of the output from the typical El Nino teleconnections scenario
lines(DateTime, Strong_ElNino_Water_Level, lwd=2, col="red2") # this adds a red line of the 
# output from the maximum El Nino teleconnections scenario
legend("topleft",c("Baseline", "Typical El Nino", "Strong El Nino"), lty=c(1,1,1), 
       lwd=c(2,2,2), col=c("black","orange2", "red2")) 

# We can also look at how the duration of ice cover changed between the three scenarios.
  # To do this, we'll use the following string of commands to calculate the number of 
  # days with ice in each scenario, based on the ice data we saved already
iceDuration <- ice %>% gather(Scenario, Ice, Baseline:Strong) %>%
  mutate(IceStatus = ifelse(Ice > 0, "Y", "N")) %>%
  group_by(Scenario) %>%
  summarize(iceDays = length(IceStatus[IceStatus=="Y"]))

# Since we want to compare ice duration to temperature offset, we'll paste on our 
  # temperature offsets from each scenario using hte command below: 
iceDuration <- iceDuration %>% 
  mutate(Offset = c(0, maxOffset_degrees, typicalOffset_degrees)) %>%
  arrange(Offset)

# Now we can plot the number of days with any ice cover as a function of our lakes' 
  # temperature offset:
attach(iceDuration)
plot(Offset, iceDays, type="b", pch=16, col=c("black", "orange1", "red2"), cex=2,
     xlab= "Temperature offset (C)", ylab= "Days with surface ice",
     ylim=c(0,365))
##!! Note that you should adjust the ylim values to effectively show the trend
# for your lake! 

# And as before, add a legend to your plot using the command below:
legend("topleft",c("Baseline", "Typical El Nino", "Strong El Nino"), pch=16, 
       col=c("black","orange2", "red2")) 

# Using the line plots you just created, put together a brief presentation of 
  # your El Nino scenarios and model outputs to share with the rest of the class. 

# Also make sure you've answered the questions listed in your handout.

# Bravo, you are done!! 

# We welcome feedback on this module and encourage you to provide comments, 
#  questions, and suggestions. Please visit our website 
#  (www.MacrosystemsEDDIE.org) to submit feedback to the module developers.