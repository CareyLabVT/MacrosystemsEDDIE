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
  #  Install and then re-run the install.packages(sp) once the install of the tools 
  #  is finished. This should now successfully load- when it's done, it should say 'DONE(sp)'.

install.packages('devtools') # This is another R package used to run modeling 
  #  software. If you get an error message that says, "package ‘devtools’ is not 
  #  available (for R version x.x.x)", be sure to check that your R software is up 
  #  to date to the most recent version.

library(devtools) # load the package

devtools::install_github("CareyLabVT/GLMr", force = TRUE) # Download the GLMr 
  #  software. This may take a few minutes. If downloaded successfully, you should 
  #  see "DONE (GLMr)" at the end of the output.

devtools::install_github("CareyLabVT/glmtools", force = TRUE) # This step 
  # downloads the R packages that allow you to work with GLM in R. If downloaded 
  # successfully, you should see "DONE (glmtools)" at the end of the output.

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

# When you downloaded this script, you unzipped the module folder to your Desktop. 
  #  We now need to tell R where these files are. We do that by setting...
ComputerName <- 'KJF' ##!! Change to match your computer name
  # Right click on the 'teleconnections' folder on your Desktop and select
  # Properties (Windows) or Get Info (Mac), then look under Location (Windows) 
  # or Where (Mac) to find your computer name after Users (example below):
  # Windows: C:/Users/KJF/Desktop/cross_scale_interactions --> computer name is KJF
  # Mac: Macintosh HDD -> Users -> careylab -> Desktop --> computer name is careylab 

LakeName <- 'Barco' ##!! Change to match the lake you and your partner selected
# The lake name options are: 'Barco', 'Crampton', 'Falling Creek', 'Mendota',
  # 'Prairie Pothole', 'Suggs', 'Sunapee', and 'Toolik'

sim_folder <- paste('/Users/',ComputerName,'/Desktop/teleconnections/Lakes/',LakeName, sep='')
# This command defines your sim_folder path to the Desktop folder where you 
  # extracted your zipped files.

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
  #  simulated water temperatures in a heat map, where time is displayed on the 
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

# We are particularly interested in the lake depth, as teleconnections could change
  #  the lake depth over time through increased or decreased evaporation from the
  #  water surface. We use the following command to pull the daily "surface height" 
  #  out of the model output and plot it as a function of time. The unit of 
  #  measurement for lake depth is meters (m).
lake_level1 <- get_surface_height(baseline)

# Use the code below to create a plot of water level in the lake over time. 
plot(surface_height ~ DateTime, data = lake_level1, type="l", col="black", 
     ylab = "Lake depth (m)", xlab = "Date", ylim=c(0,4))
# !! Note that the command ylim=c(min,max) tells R the minimum and maximum y-axis 
    #  values to plot. You will need to adjust the minimum and maximum values 
    #  to make sure all your data are shown.

# We also want to save the model output of the water temperature and lake depth 
  #  during our baseline simulation, because we'll be comparing it to our teleconnection 
  #  scenario later. To do this, we use the following  commands:

temp_output <- get_temp(file=baseline, reference='surface', z_out=c(1)) # Extract
  #  the surface water temperature for each day and save it as "temp_output"
colnames(temp_output)[2] <- "Baseline_Surface_Temp" # Rename the temperature
  #  column so we remember it is from the Baseline scenario

depth_output <- lake_level1 # Extract daily water depth and save it as "depth_output"
colnames(depth_output)[2] <- "Baseline_Lake_Depth" # Rename the depth column

########## ACTIVITY B - OBJECTIVE 3 ############################################
# For Activity B, you will work with your partner to model your lake under two 
  #  teleconnections scenarios of simulated El Nino conditions. To do this, we will use 
  #  observed, historical climate data to estimate how much warmer or cooler your 
  #  lake's local air temperature would likely be during an El Nino year. 

install.packages('readxl') # Install this package to read Excel (.xlsx) files 
  #  directly into R

install.packages('tidyverse') # Install this package to make manipulating data easy

library(readxl) # Now load the packages you just installed
library(tidyverse)

# First, read in the observational data for your lake using the command below:
annual_temp <- read_excel(paste('C:/Users/',ComputerName,'/Desktop/teleconnections/Lake_Characteristics.xlsx', sep=''), 
                          sheet = LakeName) %>%
  filter(Year >= 1970)

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
plot(`Air Temp Mean (°C)` ~ Year, data = annual_temp, pch = 16, col = 'gray70')
points(`Air Temp Mean (°C)` ~ Year, data = ElNino_years, pch = 16, col = 'red')
points(`Air Temp Mean (°C)` ~ Year, data = Neutral_years, pch = 16, col = 'black')
legend("topleft",c("All Years", "El Nino", "Neutral"), pch=16, col=c("gray70", "red", "black")) 
# Now, we need to estimate how much warmer or colder a typical El Nino year is 
  #  compared to a neutral year. 

# We'll do that by calculating the slope of the line between temperature and year
  # separately for both neutral years and El Nino years

# First, we estimate the slope and intercept of a line fit through the Neutral
  #  data points, using a simple linear model
mod_Neutral <- lm(`Air Temp Mean (°C)` ~ Year, data = Neutral_years) 
slope_Neutral = summary(mod_Neutral)$coeff[2] # Save the model slope
int_Neutral = summary(mod_Neutral)$coeff[1] # Save the model intercept

# As before, we plug in the slope and intercept to estimate the air temperature in 
  #  2013 (the year of our model), which was a neutral year 
Neutral_2013 <- (slope_Neutral * 2013) + int_Neutral
print(Neutral_2013) # Run this line to have R print out the value you just calculated

# Next, we estimate the slope and intercept of a line fit through the El Nino
  #  data points, using a simple linear model
mod_ElNino <- lm(`Air Temp Mean (°C)` ~ Year, data = ElNino_years) 
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
offset <- ElNino_2013 - Neutral_2013 # Save the offset as the "offset" object
print(offset) # Run this line to have R print out what your temperature offset is

# Now, we need to create a new meteorological driver file for GLM that has air
  #  temperatures adjusted to reflect our lake's estimated temperature difference
  #  for a typical El Nino year.

# We can do that all in R (no Excel needed!!) 
  # First, we read in the original meteorological driver data for GLM using the 
  #  following commands: 
baseline_met <- paste0(sim_folder,"/met_hourly.csv")
met_data <- read_csv(baseline_met)

# Use this command to look at the structure of your meterological driver data
View(met_data)

# Next, We create a new meteorological driver data file that has the modified 
  #  AirTemp that reflects our typical El Nino scenario. This step is complicated in Excel, 
  #  but one simple line of code in R!! 
Typical_ElNino_met <- mutate(met_data, AirTemp = AirTemp + (offset))

# Finally, we'll write our new file to a .csv that we can use to drive GLM:
write.csv(Typical_ElNino_met, paste0(sim_folder, "/met_hourly_scenario2.csv"), 
          row.names=FALSE, quote=FALSE)

## !!!!!! You now need to edit the glm2.nml file to change the name of the input 
  # meteorological file so that it reads in the new, edited file for your 
  # teleconnections scenario, not the default "met_hourly.csv".  

## !!!!!! Open the nml file by clicking 'glm2.nml' in the Files tab of RStudio, 
  # then scroll down to the meteorology section, and change the 'meteo_fl' entry 
  # to the new met file name ('met_hourly_scenario2.csv'). 

## !!!!!! Save your modified glm2.nml file.

# Once you have edited the nml file name, you can always check to make sure that 
  #  it is correct with the command:
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'meteo_fl') # The printout here should list your NEW meteorological 
  #  file for your El Nino scenario. If it doesn't, make sure you pressed the Save 
  #  icon (the floppy disk) after you changed your glm2.nml file.

# You can now run the model for your first teleconnections scenario using the 
  # new edited nml file using the commands below. Exciting!

run_glm(sim_folder, verbose=TRUE) # Run your GLM model for your El Nino scenario. 

# Again, we need to tell R where the output.nc file is so that the glmtools package 
  # can plot and analyze the model output. We tell R where to find the output file 
  # using the line below:
Typical_ElNino <- file.path(sim_folder, 'output.nc') # This defines the output.nc file 
  #  as being within the sim_folder. Note that we've called this output "ElNino" 
  #  since it is the output from our El Nino teleconnections simulation.

# As before, we want to save the model output of the daily surface water temperature 
  # and lake depth during our El Nino teleconnections simulation, to compare to 
  # our baseline scenario. 

#  Extract surface water temperature:
scenario2_temp <- get_temp(file= Typical_ElNino, reference= 'surface', z_out= c(1))
temp_output["Typical_ElNino_Surface_Temp"] <- scenario2_temp[2] # Here we attach the water 
  # temperatures from the El Nino teleconnections simulation to the  same file 
  # that contains your baseline scenario temperatures. 

# Extract lake level:
scenario2_depth <- get_surface_height(Typical_ElNino) # Extract the daily water depth 
depth_output["Typical_ElNino_Lake_Depth"] <- scenario2_depth[2] # Rename the depth column

# You can now compare your El Nino scenario to your baseline for both water 
  # temperatures and lake depth- well done!! 

# Plot the water temperature heatmap for the El Nino scenario using the commands 
# you learned above. 

plot_temp(file=Typical_ElNino, fig_path=FALSE) # Create a heatmap 
  # of water temperature. How does this compare to your baseline?

# Use the code below to create a plot of water level in the lake over time. 
plot(surface_height ~ DateTime, data = scenario2_depth, type="l", col="black", 
     ylab = "Lake depth (m)", xlab = "Date", ylim=c(0,4))
# !! Remember that the command ylim=c(min,max) tells R the minimum and maximum y-axis 
#  values to plot. Adjust this range to make sure all your data are shown.

########## ACTIVITY B - OBJECTIVE 4 ############################################
# We just simulated a typical El Nino, but now we want to see how the lake 
# responds to a larger perturbation

# We'll do this by creating our El Nino offset based on the largest offset our 
# lake has experienced during an El Nino year since 1970

# First, let's re-plot our observed annual temperature data
plot(`Air Temp Mean (°C)` ~ Year, data = annual_temp, pch = 16, col = 'gray70')
points(`Air Temp Mean (°C)` ~ Year, data = ElNino_years, pch = 16, col = 'red')
points(`Air Temp Mean (°C)` ~ Year, data = Neutral_years, pch = 16, col = 'black')
legend("topleft",c("All Years", "El Nino", "Neutral"), pch=16, col=c("gray70", "red", "black")) 
abline(a = int_ElNino, b = slope_ElNino, col= 'red', lty=2)
abline(a = int_Neutral, b = slope_Neutral, col = 'black', lty=2)

## !! Based on this plot, which El Nino year had the highest temperature offset,
  # compared to the neutral years?

# Run the following line of code to create a new data table that contains the 
  # observed mean annual air temperature for your lake for each El Nino year 
maxOffsets <- ElNino_years %>% select(`Lake ID`, Type, Year, `Air Temp Mean (°C)`) 

View(maxOffsets) # Take a look at the data sheet by running this line

# Run the following lines to calculate an estimate of what the air temperature 
  # would have likely been in each of those El Nino years IF it had been a 
  # neutral year. The final command calculates each years' offset temperature, 
  # as the difference between the El Nino observed temperature and the estimated 
  # neutral temperature
maxOffsets <- maxOffsets %>%
  mutate(Neutral_Est = (slope_Neutral * .$Year) + int_Neutral,
         Offset = `Air Temp Mean (°C)` - Neutral_Est)

View(maxOffsets)

# Here, we can use R to tell us which year had the maximum offset
maxOffset_year <- maxOffsets$Year[which.max(maxOffsets$Offset)]
maxOffset_year

# The command below selects the maximum offset, and saves it for us
maxOffset_degrees <- max(maxOffsets$Offset)  
maxOffset_degrees

# Now that we know the offset for our final scenario, we need to modify the meteorological
  # driver file once more. We'll repeat the same steps we used when creating our first 
  # El Nino scenario.

# Read in the baseline met_hourly data once more:
baseline_met <- paste0(sim_folder,"/met_hourly.csv")
met_data <- read_csv(baseline_met)

# Next, We create a new meteorological driver data file that has the modified 
#  AirTemp that reflects our maximum El Nino scenario:
Max_ElNino_met <- mutate(met_data, AirTemp = AirTemp + (maxOffset_degrees))

# Then, we write our new file to a .csv that we can use to drive GLM:
write.csv(Max_ElNino_met, paste0(sim_folder, "/met_hourly_scenario3.csv"), 
          row.names=FALSE, quote=FALSE)

## !! Once again, you need to edit the glm2.nml file to change the name of the input 
# meteorological file so that it reads in the new, edited file for your 
# teleconnections scenario, not the default "met_hourly.csv" or the file from our
# typical El Nino scenario "met_hourly_scenario2.csv".  

## !! Open the nml file by clicking 'glm2.nml' in the Files tab of RStudio, then scroll 
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
Max_ElNino <- file.path(sim_folder, 'output.nc') # This defines the output.nc file 
#  as being within the sim_folder.

# As before, we want to save the model output of the daily surface water temperature 
# and lake depth during our maximum El Nino teleconnections simulation, to compare to 
# our baseline scenario and typical El Nino scenario. 

#  Extract surface water temperature:
scenario3_temp <- get_temp(file= Max_ElNino, reference= 'surface', z_out= c(1))
temp_output["Max_ElNino_Surface_Temp"] <- scenario3_temp[2] # Here we attach the water 
# temperatures from the El Nino teleconnections simulation to the  same file 
# that contains your baseline scenario temperatures. 

scenario3_depth <- get_surface_height(Max_ElNino) # Extract the daily water depth 
depth_output["Max_ElNino_Lake_Depth"] <- scenario3_depth[2] # Rename the depth column

# Plot the heatmap of water temperatures for your maximum El Nino scenario. 
# How does it compare to the baseline? To your typical El Nino?
plot_temp(file=Max_ElNino, fig_path=FALSE)

# Plot the water level in the lake during the maximum El Nino scenario. 
plot(surface_height ~ DateTime, data = scenario2_depth, type="l", col="black", 
     ylab = "Lake depth (m)", xlab = "Date", ylim=c(0,4))
# !! Don't forget to adjust your ylim values so all your data are shown.

########## ACTIVITY C - OBJECTIVE 5 ############################################
# You've run three different scenarios for your lake. That's awesome! 

# Now, we want to compare our baseline scenario to our two El Nino scenarios 
  # (typical, and highest offset)

# Let's compare the water surface temperatures from the baseline and El Nino 
  # teleconnection scenarios with a line plot.
  # The command below plots DateTime vs. Observed data from the baseline model in black: 
attach(temp_output)
plot(DateTime, Baseline_Surface_Temp, type="l", col="black", xlab="Date",
     ylab="Surface water temperature (C)", lwd=2, ylim=c(0,40))  
lines(DateTime, Typical_ElNino_Surface_Temp, lwd=2, col="orange2") # this adds an orange line 
  # of the output from the typical El Nino scenario
lines(DateTime, Max_ElNino_Surface_Temp, lwd=2, col="red2") # this adds a red line of the 
  # output from the maximum El Nino scenario
# Now add a legend!
legend("topleft",c("Baseline", "Typical El Nino", "Max. El Nino"), lty=c(1,1,1), 
       lwd=c(2,2,2), col=c("black","orange2", "red2")) 

# !! Note that the command ylim=c(0, 40) tells R what you want the minimum and 
#  maximum values on the y-axis to be (here, we're plotting from 0 to 40 degrees C). 
#  Adjust this range and rerun the plotting commands to make sure your data are 
#  clearly visualized in the plot.

# We can make a similar plot for our lake level (depth) data.
##!! Modify the ylim() command below to adjust the y-axis limits so your data are
  # clearly visualized and you can compare your three scenarios. You may need to
  # try plotting a few different minimum and maximum values to get a plot that 
  # makes it possible to visualize the differences. 
attach(depth_output)
plot(DateTime, Baseline_Lake_Depth, type="l", col="black", xlab="Date",
     ylab="Lake depth (m)", lwd=2, ylim=c(0,4))  
lines(DateTime, Typical_ElNino_Lake_Depth, lwd=2, col="orange1") # this adds an orange line 
# of the output from the typical El Nino teleconnections scenario
lines(DateTime, Max_ElNino_Lake_Depth, lwd=2, col="red2") # this adds a red line of the 
# output from the maximum El Nino teleconnections scenario
legend("topleft",c("Baseline", "Typical El Nino", "Max. El Nino"), lty=c(1,1,1), 
       lwd=c(2,2,2), col=c("black","orange2", "red2")) 

# Using the line plots you just created, put together a brief presentation of 
  # your El Nino scenarios and model outputs to share with the rest of the class. 

# Make sure your presentation answers the questions listed in your handout.

# Bravo, you are done!! 

# We welcome feedback on this module and encourage you to provide comments, 
#  questions, and suggestions. Please visit our website 
#  (www.MacrosystemsEDDIE.org) to submit feedback to the module developers.