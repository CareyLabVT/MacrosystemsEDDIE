# Teleconnections Module ####
# This module was developed by Farrell, K.J. and C.C. Carey. 18 May 2018.
 # Macrosystems EDDIE: Teleconnections. 
 # Macrosystems EDDIE Module 3, Version 1. 
 # https://serc.carleton.edu/eddie/macrosystems/module3
 # Module development was supported by NSF EF 1702506.

# R code for students to work through the module activities A, B, and C.
 # This module consists of 6 objectives. Activity A consists of Objectives 1-2,
 # Activity B consists of Objectives 3-4, & Activity C consists of Objectives 5-6.

# This script was modified last by KJF on 23 Apr. 2018.

########## ACTIVITY A - OBJECTIVE 1 ############################################
# Download R packages and GLM files successfully onto your computer.

install.packages('sp') # NOTE: depending on your computer, you may get output 
#  that says, "There is a binary version available. Do you want to install from 
#  sources that need compilation? y/n" If this pops up, type 'y' (without the 
#  quotes) and hit enter. You may now be prompted to download the command line 
#  developer tools in a pop-up window. Command line developer tools is a program 
#  used to run modeling software. Click Install and then re-run the 
#  install.packages(sp) once the install of the tools is finished. This should 
#  now successfully load- when it's done, it should say 'DONE(sp)' if it worked.

install.packages('devtools') # this is another R package used to run modeling 
#  software. If you get an error message that says, "package ‘devtools’ is not 
#  available (for R version x.x.x)", be sure to check that your R software is up 
#  to date to the most recent version.

library(devtools) # load the package

devtools::install_github("CareyLabVT/GLMr", force = TRUE) #download the GLMr 
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

# NOTE! Throughout the rest of the module, you may need to modify some of the 
#  lines of code written below to run on your computer. If you do need to modify 
#  a line of code, I marked that particular line with ##!! symbols at the 
#  beginning of that line's annotation.  If you do not see those symbols, then 
#  you do not need to edit that line of code (you can merely run it as normal).

# When you downloaded this script, you unzipped the module folder to your Desktop. 
#  We now need to tell R where these files are. We do that by setting...
ComputerName <- 'KJF' ##!! Change to match your computer name
LakeName <- 'Sunapee' ##!! Change to match the lake you and your partner selected

sim_folder <- paste('./Teleconnections/Lakes/', LakeName, sep='') # GitHub dev version
#sim_folder <- paste('C:/Users/', ComputerName, '/Desktop/Teleconnections/Lakes', LakeName, sep='')
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

# Now, go to the sim_folder on your computer (in RStudio, you can find this by 
#  clicking on the 'Files' tab- you should see a new file ('output.nc') that was 
#  created during the simulation with a recent date and time stamp. The output.nc
#  file contains all of the output data from your simulation.

# We need to tell R where the output.nc file is so that the glmtools package can
#  plot and analyze the model output. We do that using the line below: 
baseline <- file.path(sim_folder, 'output.nc') # This says that the output.nc 
#  file is in the sim_folder  

plot_temp(file=baseline, fig_path=FALSE, col_lim = c(0,40)) # This plots your 
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

# This pair of commands can be used to list the variables that were output as part 
#  of your GLM run.
var_names <- sim_vars(baseline)
print(var_names) # This will print a list of variables that the model simulates.

# We are particularly interested in the lake depth, as teleconnections could change
#  the lake depth over time. We use the following command to pull the daily
#  "surface height" out of the model output and plot it as a function of time.
#  The unit of measurement for lake depth is meters (m).
lake_level1 <- get_surface_height(baseline)

# Use the code below to create a plot of water level in the lake over time. 
plot(surface_height ~ DateTime, data = lake_level1, type="l", col="black", 
     ylab = "Lake depth (m)", xlab = "Date", ylim=c(33,35))
# !! Note that the command ylim=c(24,26) tells R what you want the minimum and 
#  maximum values on the y-axis to be (here, we're plotting from 22 to 24 meters). 
#  Adjust this range to make sure all your data are shown in the plot.

# We also want to save the model output of the temperature and lake depth 
#  in the lake during our baseline simulation, because we'll be comparing it to 
#  our teleconnection scenario later.  To do this, we use the following 
#  commands:

temp_output <- get_temp(file=baseline, reference='surface', z_out=c(1)) # Extract
#  the surface water temperature for each day and save it as "temp_output"
colnames(temp_output)[2] <- "Baseline_Surface_Temp" # Rename the temperature
#  column so we remember it is from the Baseline scenario

depth_output <- lake_level1 # Extract daily water depth and save it as "depth_output"
colnames(depth_output)[2] <- "Baseline_Lake_Depth" # Rename the depth column

########## ACTIVITY B - OBJECTIVE 3 ############################################
# For Activity B, you will work with your partner to model your lake under a 
#  teleconnections scenario-- an El Nino year. Using the XXX file, navigate to 
#  your lake's tab, and use the data provided to estimate how much warmer or 
#  cooler your lake's regional air temperature would likely be during an El Nino
#  year. 

#  To complete this activity, you will need to modify the input meterological 
#  data (the met_hourly file) and rerun the model to examine the effects of your 
#  teleconnections scenario on lake water temperature and lake level.

### Detailed directions for modifying your met file: 

## SOMETHING THAT IS REALLY IMPORTANT! ##
  # Opening up the met_hourly.csv file in Microsoft Excel will inexplicably alter 
  # the date/time formatting of the file so that GLM cannot read it. You will get 
  # an error something like this: "Day 2451545 (2000-01-01) not found". To avoid 
  # this error, carefully follow the THREE steps listed below to modify your met 
  # file.

# 1) Copy and paste an extra version of the met_hourly.csv file in your sim folder 
  # so that you have a backup in case of any mistakes. Rename this file something 
  # like "met_hourly_baseline.csv" and be sure not to open it.

# 2) Open the met_hourly.csv file in Excel.  Change the values in the AirTemp 
  # column to represent your climate change scenario. 

  # NOTE ABOUT COLUMN NAMES: the order of the columns in the met file does not 
  # matter, but you can only have one of each variable and they must keep the 
  # EXACT same header name (i.e., it must always be 'AirTemp', not 'AirTemp+3oC') 

  # When you are done editing the meteorological file, highlight all of the 'time' 
  # column in Excel, by clicking the capital letter above the 'time' column. 
  # Right click, then select 'Format Cells', and then 'Custom'. In the "Type" or 
  # "Formatting" box, change the default to "YYYY-MM-DD hh:mm:ss" exactly (no 
  # quotes). This is the only time/date format that GLM is able to read. When you 
  # click ok, this should change the format of the 'time'  column so that it reads: 
  # "2011-09-01 00:00:00" with exactly that spacing and punctuation. Save this 
  # new file under a different name that tells what scenario it represents, e.g., 
  # "met_hourly_climate.csv". Close the csv file, saving your changes. 

## Run the following lines to ensure your time column is formatted for GLM. 
  # (This is especially important if you have an older version of Excel)
metdata <- read.csv(paste0(sim_folder,"/met_hourly_elnino.csv"), header=TRUE) 
##!! Edit the name of the CSV file so that it matches your new met file name for 
  # your El Nino teleconnections scenario. 
# Then run the following command to convert the time column into the time/date 
  # structure that GLM uses
metdata$time <-as.POSIXct(strptime(metdata$time, "%Y-%m-%d %H:%M:%S", tz="EST")) 
write.csv(metdata, paste0(sim_folder,"/met_hourly_elnino.csv"), 
          row.names=FALSE, quote=FALSE) ##!! Edit this command so the file name 
  # matches your teleconnections scenario met file name- this CSV file will now 
  # have the proper date/time formatting

  # IMPORTANT note: any time you alter the meteorological input file, you will have 
  # to repeat this step to be able to read it into R and run the model in GLM.

# 3) You now need to edit the glm2.nml file to change the name of the input 
  # meteorological file so that it reads in the new, edited file for your 
  # teleconnections scenario, not the default "met_hourly.csv".  Open the nml 
  # file by clicking 'glm2.nml' in the Files tab of RStudio, then scroll 
  # down to the meteorology section, and change the 'meteo_fl' entry to the new 
  # met file name (e.g., 'met_hourly_elnino.csv'). Save your modified glm2.nml 
  # file. Note: check to make sure that your quotes ' and ' around the file name 
  # are upright, and not slanted- sometimes the nml default alters the quotes so 
  # that the file cannot be read in properly (super tricky!).

# Once you have edited the nml file name, you can always check to make sure that 
  #  it is correct with the command:
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'meteo_fl') # If you have done this correctly, you should get 
  #  an output that lists the name of your NEW meteorological file altered for your 
  #  teleconnections scenario. If it doesn't, repeat step 3 above.

# You can now run the model for your teleconnections scenario using the new edited 
  # nml file using the commands below. Exciting!

run_glm(sim_folder, verbose=TRUE) # Run your GLM model for your El Nino scenario. 

# Again, we need to tell R where the output.nc file is so that the glmtools package 
  # can plot and analyze the model output. We tell R where to find the output file 
  # using the line below:
ElNino <- file.path(sim_folder, 'output.nc') # This defines the output.nc file 
  #  as being within the sim_folder. Note that we've called this output "ElNino" 
  #  since it is the output from our El Nino teleconnections simulation.

# As before, we want to save the model output of the daily surface water temperature 
  # and lake depth during our El Nino teleconnections simulation, to compare to 
  # our baseline scenario. 

#  Extract surface water temperature:
`*tmp*` <- get_temp(file=ElNino, reference='surface', z_out=c(1))
temp_output["ElNino_Surface_Temp"] <- `*tmp*`[2] # Here we attach the water 
  # temperatures from the El Nino teleconnections simulation to the  same file 
  # that contains your baseline scenario temperatures. 

`*tmp*` <- get_surface_height(ElNino) # Extract the daily water depth 
depth_output["ElNino_Lake_Depth"] <- `*tmp*`[2] # Rename the depth column

# You can now compare your El Nino scenario to your baseline for both water 
  # temperatures and lake depth- well done!! 

########## ACTIVITY B - OBJECTIVE 4 ############################################
# Plot the water temperature heatmap for the El Nino scenario using the commands 
  # you learned above. 

plot_temp(file=ElNino, fig_path=FALSE, col_lim = c(0,40)) # Create a heatmap 
  # of water temperature. How does this compare to your baseline?

# Do these plots from the El Nino teleconnections scenario and the baseline 
  # support or contradict your hypotheses about teleconnection effects on 
  # water temperatures for your lake? 

# If we focus on the water surface only, we can directly compare the baselind 
  # and El Nino teleconnections scenario with a line plot.
  # The command below plots DateTime vs. Observed baseline data in black: 
attach(temp_output)
plot(DateTime, Baseline_Surface_Temp, type="l", col="black", xlab="Date",
     ylab="Surface water temperature (C)", ylim=c(0, 40))  
lines(DateTime, ElNino_Surface_Temp, col="red") # this adds a red line of the 
  # output from the El Nino teleconnections scenario
legend("topleft",c("Baseline", "El Nino"), lty=c(1,1), col=c("black","red")) 
# this adds a legend

# !! Note that the command ylim=c(0, 40) tells R what you want the minimum and 
#  maximum values on the y-axis to be (here, we're plotting from 0 to 40 degrees C). 
#  You may need to adjust this range to make sure all your data are shown in the 
#  plot.

# We can make similar plots for our lake depth data.
##!! Modify the ylim() command below to adjust the y-axis limits so your data is
  # clearly visualized and you can compare your two scenarios
attach(depth_output)
plot(DateTime, Baseline_Lake_Depth, type="l", col="black", xlab="Date",
     ylab="Lake depth (m)", ylim=c(0, 40))  
lines(DateTime, ElNino_Lake_Depth, col="red") # this adds a red line of the 
# output from the El Nino teleconnections scenario
legend("topleft",c("Baseline", "El Nino"), lty=c(1,1), col=c("black","red")) 
# this adds a legend

########## ACTIVITY C - OBJECTIVE 6 ############################################
# Using the line plot you just created, and the other team's line plot from their 
#  lake, put together a brief presentation of your model simulation and output to 
#  share with the rest of the class. 

# Make sure your presentation answers the questions listed in your handout.

# Bravo, you are done!! 

# We welcome feedback on this module and encourage you to provide comments, 
#  questions, and suggestions. Please visit our website 
#  (www.MacrosystemsEDDIE.org) to submit feedback to the module developers.