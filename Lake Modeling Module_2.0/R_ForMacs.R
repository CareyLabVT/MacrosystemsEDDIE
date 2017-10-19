#  Macrosystems EDDIE: Climate Change Effects on Lake Temperatures.		####
#  Macrosystems EDDIE Module 1, Version 1.		 
#  https://serc.carleton.edu/eddie/macrosystems/module1.html. 		
#  Some parts of this module were developed by Carey, C.C., S. Aditya, K. Subratie, 		
#  and R. Figueiredo as part of the Project EDDIE module, "Modeling Climate 
#  Change Effects on Lakes Using Distributed Computing Module" and were 
#  subsequently revised by Carey, C.C. and K.J. Farrell on 21 July 2017 as part 
#  of the Macrosystems EDDIE project. 

#  Please cite this module as: "Carey, C.C., S. Aditya, K. Subratie, R. Figueiredo, 
#  and K.J. Farrell. 21 July 2017. Macrosystems EDDIE: Climate Change Effects on 
#  Lake Temperatures. Macrosystems EDDIE Module 1, Version 1. 
#  https://serc.carleton.edu/eddie/macrosystems/module1.html. Module development 
#  was supported by NSF DEB 1245707, ACI 1234983, and EF 1702506."		

#  R code for students to work through the module activities A, B, and C.		  
#  This module consists of 8 objectives. Activity A consists of Objectives 1-4,		  
#  Activity B consists of Objective 5-6, and Activity C consists of Objective 7-8.		 

# This script was last modified by KJF on 13 October 2017.

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

install.packages('glmtools', repos=c('http://cran.rstudio.com', 
                                     'http://owi.usgs.gov/R')) # This step 
# downloads the R packages that allow you to work with GLM in R. 

library(glmtools) # Load the two packages that you need to analyze GLM output
# NOTE: you may get lots of output messages in red at this step- if this worked 
# successfully, you should read a lot of text that starts with: "This 
# information is preliminary or provisional..." 

library(GLMr) # If this worked, GLMr should load without error messages. Hurray!

glm_version() # See what version of GLM you are running- should be at least v.2.x.x

# CONGRATS! You've now loaded GLM onto your computer! Proceed to Objective 2! 

########## ACTIVITY A - OBJECTIVE 2 ############################################
# Now, we will explore the examples that come with your downloaded GLM files 

# NOTE! Throughout the rest of the module, you may need to modify some of the 
#  lines of code written below to run on your computer. If you do need to modify 
#  a line of code, I marked that particular line with ##!! symbols at the 
#  beginning of that line's annotation.  If you do not see those symbols, then 
#  you do not need to edit that line of code (you can run it as normal).

# When you downloaded this script, you unzipped the lake_climate_change folder 
#  to your Desktop. We now need to tell R where these files are. We do that by...

sim_folder <- '/Users/cayelan/Desktop/lake_climate_change' ##!! Edit this line 
#  of code to redefine your sim_folder path. This should be replaced with the 
#  path to the Desktop folder where you extracted your zipped files. Most likely, 
#  you will need to change the part after Users/ to give the name of your computer 
#  (e.g., my computer name is cayelan, but yours will be different!) Look in the 
#  Files tab on RStudio to see your file path. 

setwd(sim_folder) ## This line of code is used to reset your working directory
#  to the sim_folder. The point of this step is to make sure that any new files 
#  you create (e.g., figures of output) end up together in this directory, vs. 
#  elsewhere in your computer. Look in the Files tab on RStudio to see your file 
#  path. 

nml_file <- paste0(sim_folder,"/glm2.nml") # This step sets the nml_file for your 
#  simulation to be in the new sim_folder location.

nml <- read_nml(nml_file) # Read in your nml file from your new directory

print(nml) # This shows you what is in your nml file.  This is the 'master script' 
#  of the GLM simulation; the nml file tells the GLM model all of the initial 
#  conditions about your lake, how you are defining parameters, and more - this 
#  is a really important file! There should be multiple sections, including 
#  glm_setup, morphometry, meteorology, etc.

get_nml_value(nml, 'lake_name') ##!! Use this command to find out the values of 
#  different parameters that you are running within your nml file. Here, you are 
#  first asking what the lake name is in the nml file. Then try using this command 
#  to learn the 'lake_depth', 'num_inflows', 'latitude', 'longitude', etc. 

#  Modify this command to learn the lake's maximum depth, and the number of 
#  inflow streams into this lake.

#  Awesome Lake is based on a real lake on the globe-- now modify the code above 
#  to find out the latitude and longitude, then use an online map (e.g., 
#  http://www.latlong.net/Show-Latitude-Longitude.html) to determine the location 
#  of the lake! 

plot_meteo(nml_file) # This command plots the meterological input data for the 
#  simulation- short wave & long wave radiation, air temp, etc. for the duration 
#  of the simulation run. Look at the figure in the "Plots" window in the bottom 
#  right corner of RStudio. This window can be expanded by clicking the Zoom tab 
#  at the top of the figure panel. Do these plots look reasonable for the latitude 
#  and longitude of your model lake?
 
########## ACTIVITY A - OBJECTIVE 3 ############################################
# Now, the fun part- we get to run the model and look at output!

run_glm(sim_folder, verbose=TRUE) # So simple and elegant... if this works, you 
#  should see output that says "Simulation begins.." and then shows all the time 
#  steps. At the end of the model run, it should say "Run complete" if everything 
#  worked ok.

#  Now, go to the sim_folder on your computer (in RStudio, you can find this by 
#  clicking on the 'Files' tab)- if everything happened correctly, you should see 
#  the addition of new files that were created during the simulation with a 
#  recent date and time stamp, including 'output.nc', 'lake.csv', and 'overflow.csv'. 
#  The most important of these is the 'output.nc' file, which contains all of the 
#  output data from your simulation in netCDF format.

# We need to know where the output.nc file is so that the glmtools package can
#  plot and analyze the model output. We tell R where to find the output file 
#  using the line below:

nc_file <- file.path(sim_folder, 'output.nc') # This defines the output.nc file 
#  as being within the sim_folder.  

plot_temp(file=nc_file, fig_path=FALSE) # This plots your simulated water 
#  temperatures in a heat map, where time is displayed on the x-axis, lake depth 
#  is displayed on the y-axis, and the different colors represent different 
#  temperatures. Again, this figure should be visible in the Plots window in the 
#  bottom righthand corner of RStudio's interface.

# To copy your plot (e.g., onto a PowerPoint slide), click "Export" within the 
#  Plots tab. Then click "Copy to Clipboard", and click "Copy plot" in the 
#  preview window. You can then paste your plot into Word, PowerPoint, etc. 

# If you want to save your plot as an image file or pdf file instead of copying 
#  it, click "Export" within the Plots tab, then choose "Save as Image" or "Save 
#  as PDF". In the preview window, give your plot a descriptive file name (e.g., 
#  "TemperatureHeatMap.pdf"), then press "Save". Your plot image and/or PDF file 
#  will be saved in the lake_climate_change folder on your Desktop.

########## ACTIVITY A - OBJECTIVE 4 ############################################
# Examine how the modeled GLM data compares to the observed field data for your lake.

# Let's compare the model data (nc_file) to the observed data (field_data.csv). 

field_file <- file.path(sim_folder, 'field_data.csv') # Define the observed field data

plot_temp_compare(nc_file, field_file) # Plot your GLM simulated data vs. the 
#  observed data  How do the water temperatures and thermocline depths in the two 
#  plots compare? The black circles in the observed data represent temperature 
#  observations at different depths and times. Because our observed data were 
#  collected with high-frequency thermistors on a buoy, there are lots of  black 
#  circles in the figure collected at the same depths over time.

# Now, let's compare different physical lake characteristics between the simulated 
#  and the observed lake.  To see what metrics we can compare between the observed 
#  and simulated data, first check out this command from the glmtools package to 
#  see what variables are available to plot:
sim_metrics(with_nml = FALSE) # The options include "thermo.depth" (depth of the 
#  thermocline), "buoyancy.freq" (buoyancy frequency, an index of thermal 
#  stratification), as well as "water.density" and "water.temperature".

compare_to_field(nc_file, field_file, metric="thermo.depth", as_value=TRUE, 
                 na.rm=TRUE) ##!! This command lists the thermocline depth of the 
#  observed and modeled data for comparison.
# Try changing this command to compare the other metrics as well!

# To make a simple plot of the observed vs. simulated thermocline depths, use 
#  this script:
therm_depths <- compare_to_field(nc_file, field_file, metric="thermo.depth", 
                                 as_value=TRUE, na.rm=TRUE)
plot(therm_depths$DateTime, therm_depths$obs, type="l", col="blue", ylim=c(0,32), 
     ylab="Thermocline depth in meters", xlab="Date")  # This plots DateTime vs. 
#  Observed data in blue, with a y-axis set to 0-32 m, and a y-axis label.
lines(therm_depths$DateTime, therm_depths$mod, col="red") # this adds a red line 
#  of the modeled thermocline depths
legend("topright",c("Observed", "Modeled"),lty=c(1,1), col=c("blue", "red")) 
# this adds a legend to the figure.

# How does the modeled thermocline depth compare to the observed thermocline depth?

# The code below plots the observed vs. simulated water temperature.
# !! First, run the code. Then try changing the code to instead plot the observed 
#  vs. simulated water density!  Hint: for water density, you may need to put a 
#  # before ylim=c(15,35) to visualize all the data
water_temp <- compare_to_field(nc_file, field_file, metric="water.temperature", 
                               as_value=TRUE, na.rm=TRUE)
plot(water_temp$DateTime, water_temp$obs, type="p", col="blue", ylim=c(15,35), 
     ylab="Water temperature in degrees C", xlab="Date")  # This plots DateTime 
#  vs. Observed data in blue, 
points(water_temp$DateTime, water_temp$mod, col="red") # this adds a red line of 
#  the modeled
legend("topleft",c("Observed", "Modeled"),lty=c(1,1), col=c("blue", "red")) 
# this adds a legend

# For the temperature and density plots, there are multiple data points for each 
#  day. Why?What do these plots tell you about thermal stratification over the 
#  course of a year?

# There are lots of other fun glmtools that you can play with.
# These two commands allow you to explore ice cover and evaporation in your model 
#  output.
get_ice(nc_file) #Is there any ice on Awesome Lake? Does this make sense, given 
#  the air temperatures in your meteorological plot?
get_evaporation(nc_file) #in units of mm/day

########## ACTIVITY B - OBJECTIVE 5 ############################################
#  Using your knowledge of potential climate change, work with a partner to 
#  develop a climate change scenario for your model lake. 

#  To complete this activity, you will need to modify the input meterological 
#  data and then run the model to examine the effects of your scenario on the 
#  thermal structure of the lake.

# Here is an overview of the steps you will complete with your partner to 
#  accomplish this (detailed directions below):
# 1) Develop a climate scenario (it can be for any region!)

# 2) Create a corresponding meteorological input (met) file. Think through all of 
#  the components of the proposed scenario. For example, which of the meteorological 
#  variables (air temperature, precipitation, wind, etc.) will be modified and 
#  how? Will they be short-term or long-term modifications? After you develop your 
#  scenario, work with a partner to hypothesize how these changes will affect
#  Awesome Lake's thermal structure.

# 3) Test your hypotheses! Run the GLM using your new met file and examine how 
#  it alters the physical structure of the lake. How does your climate scenario 
#  change the thermal structure of the lake?What does the temperature profile 
#  look like?  How does the depth of the thermocline change? How does the timing 
#  of stratification and magnitude of evaporation change?

# 4) Compare the modeled output to the observed. What are the implications of 
#  your climate scenario for future water quality and quantity?

# 5) Create and save a few figures to highlight the results of your climate 
#  scenario and present them to the rest of the class. It would be helpful to 
#  present both the meteorological input file as well as the lake thermal plots 
#  so that we can see how the lake responded to your climate forcing.

# Detailed directions for modifying your met file: 

# 1- ##!! Practice modifying the glm2.nml file. 
#  For example, open the nml file in a text editor (e.g., TextEdit) and change 
#  the time of the simulation so that the model run starts on '2000-03-01 00:00:00' 
#  and ends on '2000-12-31 00:00:00' (or choose some other date and time!). Save 
#  the file, then plot the altered temperature. Note that GLM (as of the v.2.0 
#  version) does not handle ice well, so starting in the spring and running 
#  through the late fall may be the best option for ice-covered lakes.

# 2- SOMETHING THAT IS REALLY REALLY IMPORTANT! 
#  Opening up the met_hourly.csv file in Microsoft Excel will inexplicably alter 
#  the date/time #  formatting of the file so that GLM cannot read it. You will 
#  get an error something like this: "Day 2451545 (2000-01-01) not found". To get 
#  around this error, you need to follow the FIVE steps listed below.

	# FIRST, copy and paste an extra version of the met_hourly.csv file in your 
    # sim folder so that you have a backup in case of any mistakes. Rename this 
    # file something like "met_hourly_UNALTERED.csv" and be sure *not* to open it.

  # SECOND, open the met_hourly.csv file in Excel.  Manipulate the different input 
    # meteorological variables to create your climate/weather scenario of your 
    # choice (be creative!). NOTE ABOUT UNITS: In the met_hourly file, the units 
    # for rain are in meters per day. You will likely think about the amount of 
    # rain your change in the met_hourly file by millimeters per day instead-- 
    # to convert from mm/d to m/d, simply multiply by 0.001. Other units are more 
    # intuitive-- open up the Variable_Name_Metadata.csv file from the module 
    # zipped folder for more details.

    # NOTE ABOUT COLUMN NAMES: the order of the columns in the met file does not 
    # matter- but you can only have one of each variable and they must keep the 
    # EXACT same header name (i.e., it must always be 'AirTemp', not 'AirTemp+3oC'). 
    # When you are done editing the meteorological file, highlight all of the 
    # 'time' column in Excel, then click on 'Format Cells', and then 'Custom'. 
    # In the "Type" or "Formatting" box, change the default to "YYYY-MM-DD hh:mm:ss" 
    # exactly (no quotes). This is the only time/date format that GLM is able to 
    # read. When you click ok, this should change the format of the 'time' column 
    # so that it reads: "1999-12-31 00:00:00" with exactly that spacing and 
    # punctuation. Save this new file under a different name, following how you 
    # have created your scenario, e.g., "met_hourly_SIMULATEDSUMMERSTORMS.csv". 
    # Close the csv file, saving your changes. Now, do NOT open the file in Excel 
    # again- otherwise, you will need to repeat this formatting process before 
    # reading the altered met file into GLM.

  # THIRD: Read in your altered met_hourly file using the command below:
metdata <- read.csv("met_hourly_SIMULATEDSUMMERSTORMS.csv", header=TRUE) ##!! Edit 
    # the name of the CSV file so that it matches your new met file name.

  # FOURTH, you need to edit the glm2.nml file to change the name of the input 
    # meteorological file so that it reads in the new, edited meteorological file 
    # for your climate scenario, not the default "met_hourly.csv".  In the nml 
    # file, scroll down to the meteorology section, and change the 'meteo_fl' 
    # entry to the new met file name (e.g., 'met_hourly_SIMULATEDSUMMERSTORMS.csv').
    # Note to Mac users- check to make sure that your quotes ' and ' around the 
    # file name are upright, and not slanted- sometimes the nml default alters 
    # the quotes so that the file cannot be read in properly (super tricky!).

    # Once you have edited the nml file name, you can always check to make sure 
    # that it is correct with the command:
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'meteo_fl') # If you have done this correctly, you should get 
    # an output that lists the name of your new meteorological file altered for 
    # your weather/climate scenario.

	# FIFTH, you can now run the model with the new edited nml file, following 
    # the instructions as described above for Objective 3.  Exciting!

########## ACTIVITY B - OBJECTIVE 6 ############################################
# Prepare figures to share with your classmates that demonstrate the effects of 
#  your climate change scenario on the thermal structure of your model lake. 

# Plot the output using the commands you learned above (in objectives 3 and 4). 

# Organize your plots into a short presentation to share with your classmates.

# Make sure your presentation includes the following elements: 
  # 1) An introduction of your climate scenario (what you changed and why)
  # 2) Your hypothesized changes in lake thermal structure
  # 3) Some figures of the model output
  # 4) Whether the model output supports or contradicts your hypotheses

# Ultimately, we want you to explore the implications of your scenario for future 
#  water quality and quantity. 

# If you have extra time, create another scenario with your partner, and share 
#  your results with the rest of your classmates.

########## ACTIVITY C - OBJECTIVE 7 ############################################
# GRAPLEr!  The GRAPLEr is an R package that allows you to set up hundreds of GLM 
#  simulations with varying input meteorological data and run those simulations 
#  efficiently and quickly using distributed computing. The model "jobs" are 
#  submitted via a web service to run	on computers elsewhere, allowing you to 
#  rapidly set up and run hundreds of simulations, access the output, and analyze 
#  the data.		
		
# Install and configure GRAPLEr on your computer.		
# NOTE: If you already installed the packages prior to class, you can skip to the 
#  line that says library(httr) and	start running the code there. However, you 
#  can also rerun the install.packages commands, even if you've already	installed 
#  them before. 		
install.packages("httr")		
install.packages("RCurl")		
install.packages("jsonlite")		
devtools::install_github("GRAPLE/GRAPLEr") # If this worked correctly, you should 
#  get multiple lines of output in red that ends with "DONE (GrapleR)". Depending 
#  on your internet connection, this step may take a few minutes to complete.

library(httr) # A package necessary for the GRAPLEr to work		
library(RCurl) # If you have trouble loading this package with this step, consider 
#  updating R to the most recent version- this seemed to help for me.		
library(jsonlite) # A package necessary for the GRAPLEr to work		
library(GRAPLEr) # If this loads successfully, you should get a return statement 
#  that says, "GRAPLEr has been developed with support from a supplement to the 
#  PRAGMA award (NSF OCI-1234983)."	Woohooo!!!		
	
#  First, we will explore the folders needed for your GRAPLEr "Experiment". We 
#  call an "Experiment" a set of simulations that you submit to run on GRAPLEr. 		
#  Each "Experiment" is configured in a folder (also known as directory) in your 
#  computer called an "Experiment Root Directory". You also need a "Results" folder 
#  to hold the output files from your Experiment when all of the many simulations 
#  are finished.

#  When you unzipped your module files, the folder included two sub-folders for 
#  your GRAPLEr Experiment.	One is called an "Experiment Root Directory" 
#  (ExpRootDir), which contains inputs (e.g. csv driver files, GLM nml files) and 
#  a job description (more on this later) for your simulations. The other folder 
#  is a "Results" directory (MyResultsDir), which specifies the location where 
#  model output will be downloaded to after the simulations are run. The following 
#  lines will tell R where your Experimental Root Directory and Results folder 		
#  are found within the sim_folder you set up in Activity A		
		
MyExpRootDir <- paste(sim_folder,sep='/','MyExpRoot') # Met files and nml are here		
MyResultsDir <- paste(sim_folder,sep='/','MyResults') # Outputs will go here		
dir.create(MyResultsDir)  # Create the MyResults directory in your computer		
		
list.files(MyExpRootDir) # Double-check that the necessary files are in your 
#  Experimental Root Directory. You *must* see the glm2.nml, met_hourly.csv, and 
#  job_desc.json files listed here before continuing!! 		
		
# IMPORTANT!!		
# From the line of code above, your file structure within your sim_folder MUST 
#  include these files:	
#  (your sim_folder from activity A)  /MyExpRoot/met_hourly.csv		
#                                     /glm2.nml		
#                                     /job_desc.json		
#                                    /MyResults  (this folder is empty for now)		
		
# In Objective 5 above, you designed a climate scenario for one lake and modified 
#  the meteorological	input data and nml file manually. But what if you want to 
#  repeat this process for hundreds of simulations that all have slightly different 
#  meteorological input data? It would not be very efficient to do this manually 
#  by editing hundreds of Excel files one by one. Instead, we are	going to use the 
#  GRAPLEr R package, which will help you set up hundreds of different simulations		
#  via an automated method, submit the jobs, and then receive the output back into 
#  your sim_folder,	saving you MANY hours of time!		
		
# To start, let us first create a scenario in which we want to examine the effects 
#  of altered air	temperatures on lakes throughout the year. In Objective 5 above, '
#  you may have done this manually by setting a constant offset of +2 degrees C 
#  to all of the baseline air temperatures in a year. But what if you also want 
#  to know the effects of a constant offset of +1.96 degrees C, +1.92 degrees C, 
#  etc. all the way to -2 degrees C? How do those small changes in the temperature 
#  offset alter thermal structure in the lake over the year?Are there any 
#  thresholds in lake responses that happen when you compare the different offsets?		
		
# To answer this question, we first need to define a scenario in which we vary 
#  air temperatures between -2 degrees C and +2 degrees C from the baseline air 
#  temperature in the meteorological file for the entire simulation period.		
		
# These scenarios have been configured in a sample input file (job_desc.json) 
#  that is part of your	MyExpRoot directory. This file should *always* reside in 
#  the ExpRootDir of a GRAPLEr experiment, and must *always* be named job_desc.json.		
#  It specifies how to generate inputs for your GRAPLEr batch; we have provided 
#  a sample file for this EDDIE module to get you started quickly. If you have 
#  time, you can copy/modify it later to run your own scenarios, using a text editor.		
		
# Let's take a look at this file:		
job_desc <- paste(MyExpRootDir,sep='/','job_desc.json') # Locate the job_desc.json file		
cat( readLines( job_desc ) , sep = "\n" )               # Print its contents		
		
# You will see the following information in this file:		
#  "met_hourly.csv" - this tells the GRAPLEr the name of your meteorological file 
#  in	your MyExpRoot directory. 		
#  Note: If you are using a modified file from Objective 5, such as 
#  "met_hourly_SIMULATEDSUMMERSTORMS.csv", you will need to edit this line to 
#  code to ensure that you have the right file name here.		
		
# "AirTemp" - for this scenario, we are modifying air temperature. You need to 
#  make sure that you exactly match this formatting, which comes from the 
#  meteorological file column headers.Note: you could also modify "ShortWave", 
#  "LongWave", "RelHum", "WindSpeed", "Rain", or "Snow". However, you cannot have 
#  a negative offset for the light or precipitation data, because that would give 
#  you errors- many of the light or precipitation data entries are 0, and you 
#  cannot have negative light or precipitation! In this case, you would want to 
#  modify the file on an offset ranging from 0 to some other positive value.		
		
# "distribution": "linear" - this specifies what distribution GRAPLEr will use to 
#  generate your experiment; in this example, we will use a linear distribution, 
#  where we set "start" : -2 as the minimum offset added to the baseline air 
#  temperature (i.e., we are adding	-2 degree C to the baseline temperatures for 
#  the entire year). If you are working with light or precipitation or any 
#  meteorological variable that cannot have negative values, this should be set 
#  to zero.		
		
# "end" : 2 as the maximum offset to the baseline air temperature (i.e., we are 
#  adding +2 degrees C tothe baseline temperatures for the entire year).		
		
# "operation" : "add" such that all offsets are calculated additively, not 
#  multiplicatively. Other available options are "sub", "mul", "div" for 
#  subtraction, multiplication, and division, respectively		
		
# "steps" : 100 this is the total number of steps from begin to end that will be 
#  run in this 'batch'. For us to run 100 steps, that means that each of the 
#  simulations between -2 and +2 degrees C are separated by an increment of 0.04 
#  (calculated by the maximum offset - the minimum offset, divided by the number 
#  of simulations).  Here that = [2-(-2)]/100, or 0.04. That means that we are 
#  going to run 101 simulations with air temp. offsets of -2+0.00 degrees C, 
#  -2+0.04 degrees C, -2+0.08 degrees C, ..., -2+3.96 degrees C, -2+4.00 degrees C.		
		
# Now that we covered the job_desc file, let's get your GRAPLEr experiment 
#  configured and submit it! This will create an object called MyGraplerExp that 
#  will hold all the information associated with a GRAPLEr experiment. Here we 
#  specify the web service URL, your directories for MyExpRoot and MyResults, 
#  and a name for your experiment (EDDIE). You can create multiple objects to run 
#  multiple experiments! Just give them different names (e.g. MyExp2, MyExp3).		
		
graplerURL <- "https://graple.acis.ufl.edu"  # Specify web address for the GRAPLEr.		
		
MyExp <- new("Graple", GWSURL=graplerURL, ExpRootDir=MyExpRootDir, ResultsDir=MyResultsDir,		
          ExpName="EDDIE", TempDir = tempdir())	# Set up your GRAPLEr experiment	
		
# At this point, let us double-check that all of those packages were installed 
#  correctly and that everything is in order before we start sending GLM runs to 
#  the GRAPLEr.		
		
MyExp <- GrapleCheckService(MyExp)		
print(MyExp@StatusMsg)  # This will contact the GRAPLEr service - if all went well 
#  with	your installation, it will print a string that includes: "I am alive, 
#  and at your service."		
		
# Now let's start your GRAPLEr run!		
		
MyExp <- GrapleRunSweepExperiment(MyExp) #	This command submits simulations to 
#  the GRAPLEr service, based on the .nml, .csv and job_desc files in your MyExpRoot 
#  directory. What you are doing now is sending those 101 simulations to run		
#  on other computers elsewhere, vs. running all 101 simulations on your computer.		
		
# Now let's check the status of your submission:		
print(MyExp@StatusMsg)		
	
# If this worked, it should have returned:		
#  "The simulation was submitted successfully, JobID: 8477FY8V963SL96LCVIE82PV5XP"		
#  Your JobID will have a different string; this means that everything is running 
#  ok. You may also see the message "WARNING: No API key provided". This is fine.		
		
# Now, we wait! You can check the status of your experiment by running the 
#  following lines:		
MyExp <- GrapleCheckExperimentCompletion(MyExp)		
print(MyExp@StatusMsg)		
		
# You should see an output with a percentage of completion (from 0.0% to 100.0%)		
#  You can run *both* these two lines of code every few seconds to check the status		
#  of your simulations, until it hits 100.0%. (You can continue to use R normally 
#  as you	wait, but be sure to save the MyGraplerExp object if you close R so that 
#  you can retrieve your results later. You need to have the information in this 
#  object to access your results)		
		
#  Ah, the anticipation! Patience.		
#  Once the status is "100.0% complete", you can move on to the next step - 
#  retrieve results!		
		
# Note that this step may take a while to prepare the outputs and download them 
#  to your computer in a compressed zip folder in your GRAPLEr working directory. 
#  Using all of the example files as described in the default simulation above, 
#  the compressed output will be about 50-100MB in size- it is dependent on how 
#  long your simulated period is, how many depths you simulated, etc.)		
# Note also that error messages for bzip2 may appear - you can ignore them		
		
MyExp <- GrapleGetExperimentResults(MyExp);		
print(MyExp@StatusMsg)		
		
# If this worked correctly, you should now find a new folder within your MyResults 
#  folder, with the experiment name (EDDIE); and within that folder, another one 
#  called "Sims". Within this Sims folder, you'll find separate folders for each 
#  of the individual sims- Sim1_1, Sim1_2, ... Sim20_5. Open up the folders to 
#  check that each of these subfolders has an output.nc file, which means that the 
#  simulation ran. You will also find a CSV file sim_summary.csv that summarizes 
#  what AirTemp offset is associated with each sim folder		
#		
# So now with all the outputs, your directory/folder structure will look like this:		
#		
# (your sim_folder)  /MyExpRoot/met_hourly.csv		
#                              /glm2.nml		
#                              /job_desc.json		
#                    /MyResults/EDDIE/Sims/Sim1_1/Results/output.nc		
#                                         /Sim1_2/Results/output.nc		
#                                                     ...		
#                                         /Sim21_1/Results/output.nc		
		
# Note: if there are any errors in your original GLM simulation, the GRAPLEr will 
#  not give any error messages (but will not run correctly!), so if you do not 
#  have any output in your sim folders, it is likely due to a problem with the 
#  baseline GLM model. We strongly recommend trying to run one GLM model to run 
#  on its own (as we did in ACtivity A), before trying to run hundreds of 
#  simulations with offsets.		
		
# Let's check a couple of simulation outputs now. Each simulation is in its own 
#  folder, under MyResults/EDDIE/Sims/SimX_Y/Results (where X is a number between 
#  1 and 21 and Y between 1 and 5 in our scenario; this is because GRAPLEr "packs" 
#  5 simulations into a job. You can always find the mapping between your offsets 
#  and simulation folder names in the file sim_summary.csv returned from GRAPLEr)		
		
# Let's check simulations 1 and 101 first. All of the simulations will be placed 
#  in a separate folder by their simulation number within the zip folder; this 
#  command sets the directory for that simulation by appending Sims/Sim1_1/Results 
#  to your sim_folder:		
sim_folder_1 <- paste(MyResultsDir,sep='/','EDDIE','Sims','Sim1_1','Results')		
sim_folder_101 <- paste(MyResultsDir,sep='/','EDDIE','Sims','Sim21_1','Results')		
		
# We need to define the output files and tell R where to look where they are to 
#  analyze the output. Unlike above, when we were working with just one output 
#  netCDF file, we now have to give the output file a number in its file name so 
#  that we can keep all of the different simulation outputs separate.		
nc_file_1 <- file.path(sim_folder_1, 'output.nc')		
nc_file_101 <- file.path(sim_folder_101, 'output.nc')		
# You can also copy this code and modify it for any sim. number between 1 and 101.		
		
# Let's plot the two different simulations, which represent the minimum and 
#  maximum offset scenarios:		
plot_temp(file=nc_file_1, fig_path=FALSE)		
plot_temp(file=nc_file_101, fig_path=FALSE)		
# How do these two figures compare, in water temperature, thermocline depth, etc.?		
		
# Now, let's look plot the temperature of all 101 simulations. To do this, run 
#  all of the code in the lines below. This is a for-loop, which means that R will 
#  go through each of the simulation folders, extract the temperature data, and 
#  create a plot. If you have your plotting R window open, then you can see how 
#  the lake gets sequentially warmer and thermal structure changes with each		
#  simulation offset. Note that the changes in the thermal plots with each offset 
#  are not linear- there are step changes that occur, with bigger changes 
#  occurring in the lake for some offsets more than	others.		
		
sim_summary_path <- paste(MyResultsDir,sep='/','EDDIE','sim_summary.csv')		
sim_summary <- read.csv(file=sim_summary_path,head=FALSE,sep=",")		
	
for (n in 1:101) {		
 sim_folder_n <- paste(MyResultsDir,sep='/','EDDIE','Sims',sim_summary$V1[n],'Results')		
 nc_file_n <- file.path(sim_folder_n, 'output.nc')		
 tempoffset <- sim_summary$V5[n]		
 simlabel <- paste(sim_summary$V1[n], "temperature offset:", tempoffset)		
 print(simlabel)		
 plot_temp(file=nc_file_n, fig_path=FALSE)		
}		
		
# Now that you and your partner have run through this demonstration, it is now 
#  time for you to design	your own GRAPLEr GLM "experiment" with your partner and 
#  use the GRAPLEr to examine the offsets of a meteorological variable and 
#  magnitude of your choice. Create some figures from your simulation and share 
#  them with the class!  Note that there are many different ways to analyze the 
#  output from each of the simulations- e.g., you could aggregate all of the days 
#  to calculate maximum Schimdt stability or thermocline depth and then plot how 
#  that value changes over the different simulation numbers. The glmtools package 
#  has many different options for analyzing and plotting GLM output that we invite 
#  you to explore.		
		
# Remember that you may should create a new directory for inputs and outputs of 
#  each new	 GRAPLEr experiment - e.g. MyExpRootDir2 and MyResultsDir2, then copy 
#  the nml, csv, and job_desc files to your new experiment root directory 
#  (MyExpRootDir2), and then edit the job_desc.json. Otherwise, you may 
#  accidentially submit previous results with your next jobs. Having these		
#  subdirectories will substantialy slow down your GRAPLEr jobs, so we strongly 
#  encourage you to start with an empty, new working directory for each GRAPLEr 
#  experiment.		
		
########## ACTIVITY C - OBJECTIVE 8 ############################################
# Prepare figures to share with your classmates that demonstrate the effects of 
#  your many GRAPLEr-enabled climate change scenarios on the thermal structure 
#  of your model lake. 

# Plot the output of your GRAPLEr experiment using the commands you learned above. 
# Organize some of your plots into a short presentation to share with your classmates.

# Make sure your presentation addresses the following questions: 
# 1) What did your scenario test? What was the range of conditions you ran over 
#  your GRAPLEr experiment? 
# 2) In which scenarios did you see the biggest change in lake thermal structure? 

# Thinking ahead: how could you use the GRAPLEr in your own research? You could 
#  use the GRAPLEr to examine hundreds of simulations for any GLM model (not just 
#  the default Awesome Lake, but your own research lake!) so think through what 
#  science questions you can ask using this R package.

# Bravo, you are done!! 

# We welcome feedback on this module and encourage you to provide comments, 
#  questions, and suggestions. Please visit the SERC website 
#  (https://serc.carleton.edu/eddie/macrosystems/module1.html) to submit feedback 
#  to the module developers. 