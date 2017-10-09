# Cross-Scale Emergence Module ####
# This module was initially developed by Carey, C.C. and K.J. Farrell. 10 July 2017.
  # Macrosystems EDDIE: Cross-Scale Emergence. 
  # Macrosystems EDDIE Module 2, Version 1. 
  # https://serc.carleton.edu/enviro_data/macrosystems/module2.html
  # Module development was supported by NSF EF 1702506.

# R code for students to work through the module activities A, B, and C.
  # This module consists of 6 objectives. Activity A consists of Objectives 1-2,
  # Activity B consists of Objectives 3-4, and Activity C consists of Objectives 5-6.

# This script was modified last by KJF on 19 Sept 2017.

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
  #  by the USGS in connection therewith" (or some modified version of this statement!)

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

sim_folder <- 'C:/Users/KFarrell/Desktop/cross_scale_emergence/LAKE' ##!! Edit this line of code to redefine your sim_folder path. 
  # This should be replaced with the path to the Desktop folder where you extracted 
  # your zipped files. Most likely, you will need to change the part after Users/ to give
  # the name of your computer (e.g., my computer name is KFarrell, but yours will be different!).
  # Also modify LAKE to the name of lake you are modeling (e.g., Mendota OR Sunapee)

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
  # that you are running within your nml file. 
  # Here, you are asking what the lake name is in the nml file (it should be Mendota or Sunapee!)
  # but you could also use this to learn the 'latitude', 'lake_depth', 'num_inflows', etc. 

# Modify this command to learn where your model lake is located by its latitude & longitude 
  # coordinates, and the lake's maximum depth.

# Use a web mapping program (e.g., Google Maps or similar) to locate your lake based on the lat/long
  # from your nml file.

plot_meteo(nml_file) # This command plots the meterological input data for the simulation- 
  # short wave & long wave radiation, air temp, relative humidity, etc. for the duration of the simulation. 
  # Do these plots look reasonable for the latitude and longitude of your model lake?
 
########## ACTIVITY A - OBJECTIVE 2 ############################################
# Now, the fun part- we get to run the model and look at output!

run_glm(sim_folder, verbose=TRUE) # So simple and elegant... if this works, you should see output
  # that says "Simulation begins.." and then shows all the time steps. 
  # At the end of the model run, it should say "Run complete" if everything worked ok. This may take
  # a few minutes, depending on your computer.

# Now, go to the sim_folder on your computer (in RStudio, you can find this by clicking on the 'Files' 
  # tab- if everything happened correctly, you should see the addition of new files 
  # that were created during the simulation with a recent date and time stamp, 
  # including 'output.nc', 'lake.csv', and 'overflow.csv'. The most important these is the
  # 'output.nc' file, which contains all of the output data from your simulation in netCDF
  # format.

# We need to know where the output.nc file is so that the glmtools package can
  # plot and analyze the model output. We tell R where to find the output file using the line below:

baseline <- file.path(sim_folder, 'output.nc') # This defines the output.nc file as being within
  # the sim_folder.  

plot_temp(file=baseline, fig_path=FALSE) # This plots your simulated water temperatures in a heat
  # map, where time is displayed on the x-axis, lake depth is displayed on the y-axis, and the
  # different colors represent different temperatures. Again, this figure should be visible in the Plots window
  # in the bottom righthand corner of RStudio's interface.

# To copy your plot (e.g., onto a PowerPoint slide), click "Export" within the Plots tab.
  # Then click "Copy to Clipboard", and click "Copy plot" in the preview window. You can then 
  # paste your plot into Word, PowerPoint, etc. 

# If you want to save your plot as an image file or pdf file instead of copying it, click
  # "Export" within the Plots tab, then choose "Save as Image" or "Save as PDF". In the preview window,
  # give your plot a descriptive file name (e.g., "TemperatureHeatMap.pdf"), then press "Save". 
  # Your plot image and/or PDF file will be saved in the lake_climate_change folder on your Desktop.

# This pair of commands can be used to list the variables that were output as part of your GLM run.
var_names <- sim_vars(baseline)
print(var_names) # This will print a list of 91 variables that the model simulates.

# We are particularly interested in the amount of total chlorophyll-a (chl-a), because that is 
  # related to phytoplankton blooms. The variable name for chl-a is "PHY_TCHLA", 
  # and it is reported in units of micrograms per liter of water (ug/L). 
  # search through the list of variables to find PHY_TCHLA.

# Use the code below to create a heatmap of chl-a in the lake over time. 
plot_var(file = baseline, "PHY_TCHLA")
# What do you notice about seasonal patterns in chl-a? 
  # Look at the color gradient scale: when is there the highest concentration of chla-a during the year?
  # How does chl-a vary with depth, and why do you think you see the patterns you do?

# Try modifying the plot_var command to create a heatmap of a different variable 
  # from the output!

# We also want to save the model output of the daily chlorophyll-a concentrations in the lake 
  # during our baseline simulation, because we'll be comparing it to our climate and land use scenarios later. 
  # To do this, we use the following commands:
chla_output <- get_var(file=baseline, "PHY_TCHLA", reference='surface', z_out=c(1)) # Save the chl-a from the surface only
colnames(chla_output)[2] <- "Baseline_Chla" # Rename the chl-a column so we remember it is from the Baseline scenario

########## ACTIVITY B - OBJECTIVE 3 ############################################
# For Activity B and C, you will compare how your lake responds to climate and land use change to how another
  # lake responds. To do this, you will work with a partner on your lake, plus another team that is modeling
  # another lake. You will develop climate and land use change scenarios, run the same scenario for both lakes, 
  # and evaluate how the lakes respond. 

# Using your knowledge of potential climate change, work with your partner and another team to develop 
  # a climate change scenario for your model lakes based on changes in air temperature.
  # To complete this activity, you will need to modify the input meterological data (the met_hourly file) and  
  # rerun the model to examine the effects of your scenario on lake thermal structure and phytoplankton.
  # Remember that both teams should run the SAME climate change scenario on their individual lake.

# Here is an overview of the steps you will complete with your partner to accomplish this (detailed directions below):
# 1) Develop a climate scenario based on changing air temperatures for your focal lake (Sunapee or Mendota)

# 2) Create a corresponding meteorological input (met) file. Think through how air temperature will change in
  # your proposed scenario, in terms of when and how much air temperature will change. 

# 3) Run the GLM using your new met file and examine how it changes the physical structure of the lake.  
  # How does your climate scenario change the thermal structure of the lake? 
  # What does the temperature profile look like?  How do the phytoplankton (i.e., chl-a) respond? 
  # What are the implications of your climate scenario for future water quality and phytoplankton blooms?

# 4) Create and save a few figures to highlight the results of your climate scenario and present them to 
  # the rest of the class. It would be helpful to present the meteorological input plot as well as 
  # temperature and chlorophyll plots so that we can see how the lake responded to your climate forcing.

# Detailed directions for modifying your met file: 

## SOMETHING THAT IS REALLY IMPORTANT! ##
  # Opening up the met_hourly.csv file in Microsoft Excel will inexplicably alter the date/time 
  # formatting of the file so that GLM cannot read it.
  # You will get an error something like this: "Day 2451545 (2000-01-01) not found".  
  # To avoid this error, carefully follow the THREE steps listed below to modify your met file.

# 1) Copy and paste an extra version of the met_hourly.csv file in your sim folder so that you
  # have a backup in case of any mistakes. Rename this file something like
  # "met_hourly_baseline.csv" and be sure not to open it.

# 2) Open the met_hourly.csv file in Excel.  Change the values in the AirTemp column to represent your 
  # climate change scenario. 

  # NOTE ABOUT COLUMN NAMES: the order of the columns in the met file does not matter, but you can only 
  # have one of each variable and they must keep the EXACT same header name 
  # (i.e., it must always be 'AirTemp', not 'AirTemp+3oC') 

  # When you are done editing the meteorological file, highlight all of the 'time' column in Excel, 
  # by clicking the capital letter above the 'time' column. Right click, then select 'Format Cells', 
  # and then 'Custom'. In the "Type" or "Formatting" box, change the default to "YYYY-MM-DD hh:mm:ss" 
  # exactly (no quotes). This is the only time/date format that GLM is able to read. 
  # When you click ok, this should change the format of the 'time'  column so that it reads: 
  # "2011-09-01 00:00:00" with exactly that spacing and punctuation. 
  # Save this new file under a different name that tells what scenario it represents, e.g., "met_hourly_climate.csv". 
  # Close the csv file, saving your changes.
  # Now, do NOT open the file in Excel again- otherwise, you will need to
  # repeat this formatting process before reading the altered met file into GLM.

# 3) You now need to edit the glm2.nml file to change the name of the input meteorological
  # file so that it reads in the new, edited meteorological file for your climate scenario, not the
  # default "met_hourly.csv".  Open the nml file in a text editor (on Windows, try Notepad; on Mac, try TextEdit), 
  # scroll down to the meteorology section, and change the 'meteo_fl' entry to the new met file name 
  # (e.g., 'met_hourly_climate.csv'). Save your modified glm2.nml file.
  # Note: check to make sure that your quotes ' and ' around the file name are upright,
  # and not slanted- sometimes the nml default alters the quotes so that the file cannot be read in
  # properly (super tricky!).

# Once you have edited the nml file name, you can always check to make sure that it is correct with the command:
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'meteo_fl') # If you have done this correctly, you should get an output that lists
  # the name of your new meteorological file altered for your weather/climate scenario. If it doesn't,
  # repeat step 3 above.

# You can now run the model for your climate change scenario using the new edited nml file, following the instructions as
  # described above for Objective 2.  Exciting!

run_glm(sim_folder, verbose=TRUE) # Run your GLM model for your lake. 
#  At the end of the model run, it should say "Run complete" if everything worked ok.

# Again, we need to tell R where the output.nc file is so that the glmtools package can
  # plot and analyze the model output. We tell R where to find the output file using the line below:
climate <- file.path(sim_folder, 'output.nc') # This defines the output.nc file as being within
#  the sim_folder. Note that we've called this output "climate" since it is the output from our climate change simulation.

# As before, we want to save the model output of the daily chlorophyll-a concentrations in the lake 
  # during our climate change simulation, to compare to our baseline and land use scenarios later. 
`*tmp*` <- get_var(file=climate, "PHY_TCHLA", reference='surface', z_out=c(1)) # Extract surface chl-a
chla_output["Climate_Chla"] <- `*tmp*`[2] # Attach the chl-a data from your climate simulation to the same file
  # that contains your baseline scenario chl-a concentrations. You can now compare your climate scenario
  # to your baseline- well done!

########## ACTIVITY B - OBJECTIVE 4 ############################################
# Plot the output using the commands you learned above. 
plot_temp(file=climate, fig_path=FALSE) # Create a heatmap of temperature. How does this compare to your baseline?
plot_var(file=climate, "PHY_TCHLA") # Create a heatmap of chlorophyll-a. How does this compare to your baseline?

# Using these plots from your climate scenario, along with the the figures from your baseline scenario 
  # and the other team's plots from their lake (climate scenario and baseline plots), put together 
  # a brief presentation of your model simulation and output to share with the rest of the class. 

# Make sure your presentation answers the following questions: 
  # a) Does the model output support or contradict your original hypotheses of how the climate scenario will 
  #    affect the two lakes' temperatures and phytoplankton? 
  # b) How does the temperature and chlorophyll output from the two lakes compare (both baseline and 
  #    scenario conditions? 
  # c) Which lake’s water temperature and chlorophyll is more sensitive to the climate scenario?

########## ACTIVITY C - OBJECTIVE 5 ############################################
# Now, using your knowledge of potential land use effects on nutrients coming into a lake, 
  # work with your partner and the other team to develop a land use change scenario for your model lake 
  # based on changes in phosphorus concentrations in the inflow file. 

# To complete this activity, you will need to modify the input driver data (inflow.csv)
  # and then rerun the model to examine the effects of your scenario on lake phytoplankton.

# Here are the overview steps you will complete with your partner to accomplish this (detailed info below!):
  # 1) Develop a land use scenario based on changing the balance of agriculture, urbanization, and undisturbed
  # land cover in your model lake's watershed.

  # 2) Create a corresponding change in the stream inflow file. Think through how phosphorus 
    # concentrations will change in your proposed scenario, in terms of both the timing and intensity 
    # of nutrient inflows. 

  # 3) Run the GLM model using your new inflow file and the original met file (met_hourly.csv) and examine 
    # how it changes the lake in comparison to baseline conditions. Think through these questions:
    # How does your land use scenario change the chlorophyll-a profile of the lake? 
    # Does lake temperature change with the land use scenario? 
    # What are the implications of your land use scenario for future water quality and phytoplankton blooms?

  # 4) Create and save a few figures to highlight the results of your land use scenario. 
    # It would be helpful to present both the land use driver file as well as 
    # chlorophyll plots so that we can see how the lake responded to your land use change scenario.

# Detailed directions for modifying your inflow file: 

## SOMETHING THAT IS REALLY IMPORTANT! ##
# Opening up the inflow.csv file in Microsoft Excel will inexplicably alter the date/time 
  # formatting of the file so that GLM cannot read it.
  # You will get an error something like this: "Day 2451545 (2000-01-01) not found".  
  # To avoid this error, carefully follow the THREE steps listed below to modify your inflow file.

# 1) Copy and paste an extra version of the inflow.csv file in your sim folder so that you
  # have a backup in case of any mistakes. Rename this file something like
  # "inflow_baseline.csv" and be sure not to open it.

# 2) Open the inflow.csv file in Excel.  Change the values in the PHS_frp column to represent how your 
  # land use change scenario alters the amount of phosphorus flowing into your lake. PHS_frp is an 
  # abbreviation for the filterable reactive phosphorus fraction, or the fraction of phosphorus that is 
  # phytoplankton need the most for their growth and division.

  # NOTE ABOUT COLUMN NAMES: As with the met_hourly file, the order of the columns in the inflow file 
  # does not matter, but you can only have one of each variable and they must keep the EXACT same header name 
  # (i.e., it must always be 'PHS_frp') 

  # When you are done editing the inflow file, highlight all of the 'time' column in Excel, 
  # by clicking the capital letter above the 'time' column. Right click, then select 'Format Cells', 
  # and then 'Custom'. In the "Type" or "Formatting" box, change the default to "YYYY-MM-DD hh:mm:ss" 
  # exactly (no quotes). This is the only time/date format that GLM is able to read. 
  # When you click ok, this should change the format of the 'time'  column so that it reads: 
  # "2011-09-01 00:00:00" with exactly that spacing and punctuation. 
  # Save this new file under a different name that tells what scenario it represents, e.g., "inflow_landuse.csv". 
  # Close the csv file, saving your changes.
  # Now, do NOT open the file in Excel again- otherwise, you will need to
  # repeat this formatting process before reading the altered inflow file into GLM.

# 3) You now need to edit the glm2.nml file to change the name of the inflow file so that it reads in the new, 
  # edited inflow file for your land use scenario, not the default "inflow.csv".  
  # Open the glm2.nml file, scroll down to the inflows section, and change the 'inflow_fl' entry to the new file name 
  # (e.g., 'inflow_landuse.csv'). 

# IMPORTANT: Be sure to ALSO change your met file name in the glm2.nml BACK to the original (baseline) 
  # met file (e.g., in the meteorology section, make sure your 'meteo_fl' entry is 'met_hourly_baseline.csv'. 
  # This is because we want to examine the effects of your land use scenario separate from the climate
  # scenario you developed earlier. Save your modified glm2.nml file that has baseline meteorology and
  # altered land use.

# Once you have edited the nml file name, you can always check to make sure that it is correct with the commands:
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'inflow_fl') # If you have done this correctly, you should get an output that lists
  # the name of your altered inflow file.
get_nml_value(nml, 'meteo_fl') # If you have done this correctly, you should get an output that lists
  # the name of your baseline meteorological file.

# You can now run the model for your climate change scenario using the new edited nml file, following the instructions as
  # described above for Objective 2.  Exciting!

run_glm(sim_folder, verbose=TRUE) # Run your GLM model for your lake. 
# At the end of the model run, it should say "Run complete" if everything worked ok.

# Again, we need to tell R where the output.nc file is so that the glmtools package can
  # plot and analyze the model output. We tell R where to find the output file using the line below:
landuse <- file.path(sim_folder, 'output.nc') # This defines the output.nc file as being within
  # the sim_folder. Note that we've called this output "landuse" since it is the output from our land use change simulation.

# As before, we want to save the model output of the daily chlorophyll-a concentrations in the lake 
  # during our land use change simulation, to compare to our baseline and climate scenarios later. 
`*tmp*` <- get_var(file=landuse, "PHY_TCHLA", reference='surface', z_out=c(1)) # Extract surface chl-a
chla_output["LandUse_Chla"] <- `*tmp*`[2] # Attach the chl-a data from your land use simulation to the same file
  # that contains your baseline scenario and climate change scenario chl-a concentrations

# Plot the output of your land use scenario using the commands you learned above. 
plot_temp(file=landuse, fig_path=FALSE) # Heatmap of temperature
plot_var(file=landuse, "PHY_TCHLA") # Heatmap of chlorophyll-a
# How does your phytoplankton heatmap look in comparison to the baseline? Be sure to check the scale of
  # of the color gradient representing chl-a when comparing plots!

# Finally, we want to see what happens when land use and climate interact! 
  # Luckily, testing the simultaneous effects of your land use and climate change scenarios will be pretty easy!
  # Since we already have modified met data (climate scenario) and inflow data (land use scenario), we just have
  # GLM read them both at once. We can do this by changing the glm2.nml file to include our modified files.

# In the glm2.nml file, make the following TWO changes:

# 1) In the meteorology section, change the 'meteo_fl' entry to the met file that represents 
  # your climate change scenario (e.g., 'met_hourly_climate.csv')

# 2) In the inflow section, change the 'inflow_fl' entry to the inflow file that represents
  # your land use change scenario (e.g., 'inflow_landuse.csv')

# Save your glm2.nml file, then run the following commands to check that the changes were made correctly.
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'inflow_fl') # If you have done this correctly, you should get an output that lists
  # the name of your altered inflow file.
get_nml_value(nml, 'meteo_fl') # If you have done this correctly, you should get an output that lists
  # the name of your altered meteorological file.

# Run GLM one more time!
run_glm(sim_folder, verbose=TRUE) # Run your GLM model for your lake. 
# At the end of the model run, it should say "Run complete" if everything worked ok.

# As above, we need to tell R where the output.nc file is so that the glmtools package can
  # plot and analyze the model output. We tell R where to find the output file using the line below:
climate_landuse <- file.path(sim_folder, 'output.nc') # This defines the output.nc file as being within
  # the sim_folder. Note that we've called this output "climate_landuse" since it is the output from our 
  # simultaneous climate AND land use change simulations.

# As before, we want to save the model output of the daily chlorophyll-a concentrations in the lake, 
  # to compare to our baseline, climate, and land use scenarios. 
`*tmp*` <- get_var(file=climate_landuse, "PHY_TCHLA", reference='surface', z_out=c(1)) # Extract surface chl-a
chla_output["Climate_LandUse_Chla"] <- `*tmp*`[2] # Attach the chl-a data from your combined simulation to the same file
  # that contains your baseline, climate change, and land use scenario chl-a concentrations

# Plot the output of your land use scenario using the commands you learned above. 
plot_temp(file=climate_landuse, fig_path=FALSE) # Heatmap of temperature
plot_var(file=climate_landuse, "PHY_TCHLA") # Heatmap of chlorophyll-a

# Add these new plots to the presentation you're making with your team. 
  # Think about how land use and climate change interacted to affect phytoplankton blooms in your lake. 
  # How do these newest plots compare to the figures you made from climate change or land use change scenarios alone?

# Now that you've run four different scenarios (baseline, climate only, land use only, and climate + land use), let's plot 
  # how the chl-a in the lakes responded to the different scenarios. We can do this by:
attach(chla_output)

plot(DateTime, Baseline_Chla, type="l", col="black", ylim=c(0, 100),
     ylab="Chlorophyll-a (ug/L)", xlab="Date")  # This plots DateTime vs. Observed data in black 
lines(DateTime, Climate_Chla, col="red") # this adds a red line of the climate change scenario
lines(DateTime, LandUse_Chla, col="blue") # this adds a blue line of the land use scenario
lines(DateTime, Climate_LandUse_Chla, col="green") # this adds a green line of simultaneous climate and land use scenario
legend("topleft",c("Baseline", "Climate Only", "Land Use Only", "Combined C + LU"), lty=c(1,1,1,1),
       col=c("black","red","blue", "green")) # this adds a legend
# !! Note that the command ylim=c(0, 30) tells R what you want the minimum and maximum values on the
  # y-axis to be (here, we're plotting from 0 to 30 ug/L). You may need to adjust this range to make
  # sure all your data are shown in the plot.

########## ACTIVITY C - OBJECTIVE 6 ############################################
# Using the line plot you just created, and the other team's line plot from their lake, put together a brief 
  # presentation of your model simulation and output to share with the rest of the class. 

# Make sure your presentation answers the following questions: 
  # a) Does the model output support or contradict your original hypotheses of how climate, land use,
  #    and their combined effects will interact to affect the two lakes' phytoplankton? 
  # b) How does the chlorophyll output from the four scenarios in the two lakes compare? (be sure to
  #    compare heatmap color scales among plots!)
  # c) Which lake’s chlorophyll is more sensitive to climate change? Land use? Their combined effects?
  # d) Observing similar phenomena (e.g., phytoplankton blooms) among ecosystems that experience different 
  #    combinations of drivers are part of cross-scale emergence: what do the two lakes' responses to 
  #    climate and land use tell you about how water quality might respond to human activities in the future?

# Bravo, you are done!! 

# We welcome feedback on this module and encourage you to provide comments, questions, and suggestions. 
  # Please visit the SERC website (https://serc.carleton.edu/eddie/macrosystems/module2.html) 
  # to submit feedback to the module developers.