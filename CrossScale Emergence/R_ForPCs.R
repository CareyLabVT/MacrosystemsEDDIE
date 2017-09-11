# Cross-Scale Emergence Module ####
# This module was initially developed by Carey, C.C. and K.J. Farrell. 10 July 2017.
#   Macrosystems EDDIE: Cross-Scale Emergence. 
#   Macrosystems EDDIE Module 2, Version 1. 
#   https://serc.carleton.edu/enviro_data/macrosystems/module2.html
#   Module development was supported by NSF EF 1702506.

# R code for students to work through the module activities A, B, and C.
#   This module consists of 6 objectives. Activity A consists of Objectives 1-4,
#   Activity B consists of Objective 5, and Activity C consists of Objective 6.

# This script was modified last by KJF on 11 Sept 2017.

########## ACTIVITY A - OBJECTIVE 1 ############################################
# Download R packages and GLM files successfully onto your computer.

install.packages('sp') # NOTE: you may get output that says "There is a binary version available
#  but the source version is later... Do you want to install from sources the package which
#  needs compilation? y/n" Type 'y' (without the quotes) and hit enter. You may now be prompted
#  to download the command line developer tools. Click Install and then re-run the
#  install.packages(sp) once the install of the tools is finished. This should now
#  successfully load- when it's done, it should say 'DONE(sp)' if it worked successfully.

install.packages('glmtools', repos=c('http://cran.rstudio.com', 'http://owi.usgs.gov/R')) 
# This step enables you to access the USGS	website and download the R packages 
#  that allow you to work with GLM in R. 
# Note: if you are on a slow internet connection, this may take a few minutes.

library(glmtools) # Load the two packages that you need to run GLM and manipulate its output
# NOTE: you may get lots of output messages at this step- if this worked successfully, you
#  should read: "This information is preliminary or provisional and is subject to revision. It
#  is being provided to meet the need for timely best science. The information has not received
#  final approval by the U.S. Geological Survey (USGS) and is provided on the condition that
#  neither the USGS nor the U.S. Government shall be held liable for any damages resulting from
#  the authorized or unauthorized use of the information. Although this software program has
#  been used by the USGS, no warranty, expressed or implied, is made by the USGS or the U.S.
#  Government as to the accuracy and functioning of the program and related program material nor
#  shall the fact of distribution constitute any such warranty, and no responsibility is assumed
#  by the USGS in connection therewith".

library(GLMr) # If this worked, GLMr should load without any error messages. Hurray!

glm_version() # See what version of GLM you are running- should be at least v.2.x.x

# CONGRATS! You've now succesfully loaded GLM onto your computer! 

# Now, we will explore the files that come with your downloaded GLM files 

# NOTE! Throughout the rest of the module, you may need to modify some of the lines of code
#  written below to run on your computer. If you do need to modify a line of code, I marked that
#  particular line with ##!! symbols at the beginning of that line's annotation.  If you do not
#  see those symbols, then you do not need to edit that line of code (you can merely run it as
#  normal).

# When you downloaded this script, you unzipped the lake folder to your Desktop. 
# We now need to tell R where these files are. We do that by...

sim_folder <- 'C:/Users/farrellk/Desktop/R/ProjectEDDIE/CrossScale Emergence/Sunapee'  # !! KF placeholder sim_folder
#sim_folder <- 'C:/Users/farrellk/Desktop/cross_scale_emergence' ##!! Edit this line of code to redefine your sim_folder path. 
# This should be replaced with the path to the Desktop folder where you extracted 
#  your zipped files. Most likely, you will need to change the part after Users/ to give
#  the name of your computer (e.g., my computer name is farrellk, but yours will be different!)
#  as well as modify LAKE to tell which lake you are modeling (e.g., Mendota or Sunapee)

setwd(sim_folder) ##!! This line of code is used to reset your working directory
#  to the sim_folder. The point of this step is to make sure that any new files you create
#  (e.g., figures of output) end up together in this directory, vs. elsewhere in your computer.

nml_file <- paste0(sim_folder,"/glm2.nml") # This step sets the nml_file for your simulation to be
#  in the new sim_folder location.

nml <- read_nml(nml_file) # Read in your nml file from your new directory

print(nml) # This shows you what is in your nml file.  This is the 'master script' of the GLM
#  simulation; the nml file tells the GLM model all of the initial conditions about your lake,
#  how you are defining parameters, and more - this is a really important file! There should be
#  multiple sections, including glm_setup, morphometry, meteorology, etc.

get_nml_value(nml, 'lake_name') ##!! Use this command to find out the values of different parameters 
#  that you are running within your nml file. 
# Here, you are asking what the lake name is in the nml file (it should be Mendota or Sunapee!)
#   but you could also use this to learn the 'latitude', 'lake_depth', 'num_inflows', etc. 
# Modify this command to learn where your model lake is located by its latitude & longitude 
#  coordinates, and the lake's maximum depth.
# Use a web mapping program (e.g., Google Maps or similar) to locate your lake based on the lat/long
#  from your nml file.

plot_meteo(nml_file) # This command plots the meterological input data for the simulation- 
#   short wave & long wave radiation, air temp, etc. for the duration of the simulation run. 
#  Do these plots look reasonable for the latitude and longitude of your model lake?
 
########## ACTIVITY A - OBJECTIVE 2 ############################################
# Now, the fun part- we get to run the model and look at output!

run_glm(sim_folder, verbose=TRUE) # So simple and elegant... if this works, you should see output
#  that says "Simulation begins.." and then shows all the time steps. 
#  At the end of the model run, it should say "Run complete" if everything worked ok.

# Now, go to the sim_folder on your computer (in RStudio, you can find this by clicking on the 'Files' 
#  tab- if everything happened correctly, you should see the addition of new files 
#  that were created during the simulation with a recent date and time stamp, 
#  including 'output.nc', 'lake.csv', and 'overflow.csv'. The most important these is the
#  'output.nc' file, which contains all of the output data from your simulation in netCDF
#  format.

# We need to know where the output.nc file is so that the glmtools package can
#  plot and analyze the model output. We tell R where to find the output file using the line below:

baseline <- file.path(sim_folder, 'output.nc') # This defines the output.nc file as being within
#  the sim_folder.  

plot_temp(file=baseline, fig_path=FALSE) # This plots your simulated water temperatures in a heat
#  map, where time is displayed on the x-axis, lake depth is displayed on the y-axis, and the
#  different colors represent different temperatures. Again, this figure should be visible in the Plots window
#  in the bottom righthand corner of RStudio's interface.

# To copy your plot (e.g., onto a PowerPoint slide), click "Export" within the Plots tab.
# Then click "Copy to Clipboard", and click "Copy plot" in the preview window. You can then 
# paste your plot into Word, PowerPoint, etc. 

# If you want to save your plot as an image file or pdf file instead of copying it, click
# "Export" within the Plots tab, then choose "Save as Image" or "Save as PDF". In the preview window,
# give your plot a descriptive file name (e.g., "TemperatureHeatMap.pdf"), then press "Save". 
# Your plot image and/or PDF file will be saved in the lake_climate_change folder on your Desktop.

# This pair of commands can be used to list the variables that were output as part of your GLM run
var_names <- sim_vars(baseline)
print(var_names)

# We are particularly interested in the amount of chlorophyll-a (chl-a), because that is 
#  related to phytoplankton blooms. The variable name for chl-a is "PHY_TCHLA", 
#  and it is reported in units of micrograms per liter of water (ug/L)

# Use the code below to create a heatmap of chl-a in the lake over time. 
plot_var(file = baseline, "PHY_TCHLA")
# What do you notice about seasonal patterns in chl-a? 
# How does chl-a vary with depth, and why do you think you see the patterns you do?

# Try modifying the plot_var command to create a heatmap of a different variable 
#  from the output!

# We also want to save the model output of the daily chlorophyll-a concentrations in the lake 
  # during our baseline simulation, because we'll be comparing it to our climate and land use scenarios later. 
  # To do this, we use the following commands:
chla_output <- get_var(file=baseline, "PHY_TCHLA", reference='surface', z_out=c(1)) # Save surface chl-a
colnames(chla_output)[2] <- "Baseline" # Rename the chl-a column so we remember it is from the Baseline scenario

########## ACTIVITY B - OBJECTIVE 3 ############################################
# Using your knowledge of potential climate change, work with your partner and another team 
# of students to develop a climate change scenario for your model lake. 

# To complete this activity, you will need to modify the input meterological data and then run the
#  model to examine the effects of your scenario on the thermal structure of the lake.

# Here is an overview of the steps you will complete with your partner to accomplish this (detailed directions below):
# 1) Develop a climate scenario (it can be for any region!)

# 2) Create a corresponding meteorological input (met) file. Think through all of the components of the
	# proposed scenario. For example, which of the meteorological variables (air temperature,
	# precipitation, wind, etc.) will be modified and how? Will they be short-term or long-term
	# modifications? 

# 3) Run the GLM using your new met file and examine how it alters the physical structure of the lake.  
	# How does your climate scenario change the thermal structure of the lake? 
	# What does the temperature profile look like?  How does the depth of the thermocline change? 
	# How does the timing of stratification and magnitude of evaporation change?

# 4) Compare the modeled output to the observed. 
	# What are the implications of your climate scenario for future water quality and quantity?

# 5) Create and save a few figures to highlight the results of your climate scenario and 
	# present them to the rest of the class. It would be helpful to present both 
	# the meteorological input file as well as the lake thermal plots so that we 
	# can see how the lake responded to your climate forcing.

# Detailed directions for modifying your met file: 

# 1- ##!! Practice modifying the glm2.nml file. 
   #  For example, open the nml file in a text editor (on Windows, try Notepad) 
   #  and change the time of the simulation so that the model run starts on 
   #  '2000-03-01 00:00:00' and ends on '2000-12-31 00:00:00' (or choose some
   #  other date and time!). Save the file, then plot the altered temperature. 
   #  Note that GLM (as of the v.2.0 version) does not handle ice well, 
   #  so starting in the spring and running through the late fall may be
   #  the best option for ice-covered lakes.

# 2- SOMETHING THAT IS REALLY REALLY IMPORTANT! 
	# Opening up the met_hourly.csv file in Microsoft Excel will inexplicably alter the date/time 
	# formatting of the file so that GLM cannot read it.
	# You will get an error something like this: "Day 2451545 (2000-01-01) not found".  
	# To get around this error, you need to follow the FIVE steps listed below.

	# FIRST, copy and paste an extra version of the met_hourly.csv file in your sim folder so that you
		# have a backup in case of any mistakes. Rename this file something like
		# "met_hourly_UNALTERED.csv" and be sure not to open it.

	# SECOND, open the met_hourly.csv file in Excel.  Manipulate the different input meteorological
		#	variables to create your climate/weather scenario of your choice (be creative!). 
    # NOTE ABOUT UNITS: In the met_hourly file, the units for rain are in meters per day. You will likely
    # think about the amount of rain your change in the met_hourly file by millimeters per day instead-- 
    # to convert from mm/d to m/d, simply multiply by 0.001. Other units are more intuitive-- open up the 
    # Variable_Name_Metadata.csv file for more details.
    
		# NOTE ABOUT COLUMN NAMES: the order of the columns in the met file does not matter- but you can only have one 
		# of each variable and they must keep the EXACT same header name (i.e., it must always be 
		# 'AirTemp', not 'AirTemp+3oC'). When you are done editing the meteorological file, highlight 
		# all of the 'time' column in Excel, then click on 'Format Cells', and then 'Custom'. 
		# In the "Type" or "Formatting" box, change the default to "YYYY-MM-DD hh:mm:ss" exactly (no quotes). 
		# This is the only time/date format that GLM is able to read. 
		# When you click ok, this should change the format of the 'time'  column so that it reads: 
		# "1999-12-31 00:00:00" with exactly that spacing and punctuation. 
		# Save this new file under a different name, following how you have created your scenario, 
		# e.g., "met_hourly_SIMULATEDSUMMERSTORMS.csv". Close the csv file, saving your changes.
    # Now, do NOT open the file in Excel again- otherwise, you will need to
    # repeat this formatting process before reading the altered met file into GLM.

    # THIRD: Read in your altered met_hourly file using the command below:
metdata <- read.csv("met_hourly_SIMULATEDSUMMERSTORMS.csv", header=TRUE) ##!! Edit the name of the
# CSV file so that it matches your new met file name.

	# FOURTH, you need to edit the glm2.nml file to change the name of the input meteorological
		# file so that it reads in the new, edited meteorological file for your climate scenario, not the
		# default "met_hourly.csv".  In the nml file, scroll down to the meteorology section, and change
		# the 'meteo_fl' entry to the new met file name (e.g., 'met_hourly_SIMULATEDSUMMERSTORMS.csv').
		# Note to Mac users- check to make sure that your quotes ' and ' around the file name are upright,
		# and not slanted- sometimes the nml default alters the quotes so that the file cannot be read in
		# properly (super tricky!).

# Once you have edited the nml file name, you can always check to make sure that it is correct with the command:
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'meteo_fl') # If you have done this correctly, you should get an output that lists
# the name of your new meteorological file altered for your weather/climate scenario.

	# FIFTH, you can now run the model with the new edited nml file, following the instructions as
		# described above for Objective 3.  Exciting!

# Plot the output using the commands you learned above. Then answer the following questions: 
# How does your scenario change the thermal structure of the lake? 
# What does the temperature profile over time look like? 
# When and what is the maximum and minimum water temperature? 
# How does the depth of the thermocline change? 
# How does the timing of stratification change? 
# Modify the code above to plot modeled vs. observed thermocline depths, as well as other thermal characteristics. 
# Ultimately, we want you to explore the implications of your scenario for future water quality and quantity. 
# If you have extra time, create another scenario with your partner, and share your results with the rest of your
# classmates.

########## ACTIVITY C - OBJECTIVE 6 ############################################
