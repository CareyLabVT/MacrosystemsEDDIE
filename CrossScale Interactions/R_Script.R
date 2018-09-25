# Cross-Scale Interactions Module ####
 # This module was initially developed by Carey, C.C. and K.J. Farrell. 13 Aug. 2017.
 # Macrosystems EDDIE: Cross-Scale Interactions. Macrosystems EDDIE Module 2, Version 1. 
 # www.MacrosystemsEDDIE.org/module2
 # Module development was supported by NSF EF 1702506.

# R code for students to work through the module activities A, B, and C.
 # This module consists of 6 objectives. Activity A consists of Objectives 1-2,
 # Activity B consists of Objectives 3-4, & Activity C consists of Objectives 5-6.

########## ACTIVITY A - OBJECTIVE 1 ############################################
# Download R packages and GLM files onto your computer.

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

library(devtools) # load the devtools package

devtools::install_github("CareyLabVT/GLMr", force = TRUE) # Download the GLMr 
#  software. This may take a few minutes. If downloaded successfully, you should 
#  see "DONE (GLMr)" at the end of the output.

devtools::install_github("CareyLabVT/glmtools", force = TRUE) # This step 
# downloads the R packages that allow you to work with GLM in R. 

library(glmtools) # Load the two packages that you need to analyze GLM output
#  NOTE: you may get lots of output messages in red at this step- if this worked 
#  successfully, you should read a lot of text that starts with: "This 
#  information is preliminary or provisional..." 

library(GLMr) # If this worked, GLMr should load without error messages. Hurray!

glm_version() # See what version of GLM you are running- should be v.2.x.x

# CONGRATS! You've now succesfully loaded GLM onto your computer! 

# Now, we will explore the files that come with your downloaded GLM files 

# NOTE! Throughout the rest of the module, you may need to modify some of the 
#  lines of code written below to run on your computer. If you do need to modify 
#  a line of code, I marked that line with ##!! symbols at the beginning of that 
#  line's annotation.  If you do not see those symbols, then you do not need to 
#  edit that line of code (you can merely run it as normal).

# When you downloaded this script, you unzipped the module folder to your Desktop. 
#  We now need to tell R where these files are. We do that by setting...
ComputerName <- 'KJF' ##!! Change to match your computer name
LakeName <- 'Mendota' ##!! Change to match the lake you and your partner selected

sim_folder <- paste('/Users/',ComputerName,'/Desktop/cross_scale_interactions/',LakeName, sep='')
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
#  file is in the sim_folder.  

plot_temp(file=baseline, fig_path=FALSE) # This plots your simulated water 
#  temperatures in a heat map, where time is displayed on the x-axis, lake depth 
#  is displayed on the y-axis, and the different colors represent different 
#  temperatures. 

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

# We are particularly interested in the amount of total chlorophyll-a (chl-a), 
#  because that is related to phytoplankton blooms. The variable name for chl-a 
#  is "PHY_TCHLA", and it is reported in units of micrograms per liter of water 
#  (ug/L). Search through the list of variables to find PHY_TCHLA.

# Use the code below to create a heatmap of chl-a in the lake over time. 
plot_var(file = baseline, "PHY_TCHLA") # What do you notice about seasonal 
#  patterns in chl-a? 

# We also want to save the model output of the daily chlorophyll-a concentrations 
#  in the lake during our baseline simulation, because we'll be comparing it to 
#  our climate and land use scenarios later.  To do this, we use the following 
#  commands:

# Save the chl-a from the surface only:
chla_output <- get_var(file=baseline, "PHY_TCHLA", reference='surface', z_out=c(1)) 
colnames(chla_output)[2] <- "Baseline_Chla" # Here we rename the chl-a column so we 
#  remember it is from the Baseline scenario

########## ACTIVITY B - OBJECTIVE 3 ############################################
# For Activity B, you will work with your partner to model your lake, plus another 
#  team that is modeling another lake. With your partner and another team, select
#  one of the pre-made climate scenarios. Remember that both teams should run the 
#  SAME climate scenario on their separate lakes and compare the output.

# Once you have selected your climate scenario, you need to edit the glm2.nml file 
#  to change the name of the input met file so that it reads in the met data for 
#  your climate scenario, not the default 'met_hourly.csv'.  

# Open the .nml file by clicking 'glm2.nml' in the Files tab of RStudio, then scroll 
#  down to the meteorology section, and change the 'meteo_fl' entry to the new 
#  met file name (e.g., from 'met_hourly.csv' to 'met_hourly_plus2.csv'). 
#  SAVE your modified glm2.nml file.

# Once you have edited the nml file name, read in the updated file with the command:
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'meteo_fl') # The printout here should list your NEW meteorological 
  # file for your climate scenario. If it doesn't, make sure you pressed the Save 
  # icon (the floppy disk) after you changed your glm2.nml file.

# You can now run the model for your climate change scenario using the new edited 
  # nml file using the commands below. Exciting!

run_glm(sim_folder, verbose=TRUE) # Run your GLM model for your lake climate scenario. 

# Again, we need to tell R where the output.nc file is so that the glmtools package 
#  can plot and analyze the model output. We tell R where to find the output file 
#  using the line below:
climate <- file.path(sim_folder, 'output.nc') # This defines the output.nc file 
#  as being within the sim_folder. Note that we've called this output "climate" 
#  since it is the output from our climate change simulation.

# As before, we want to save the model output of the daily chlorophyll-a 
#  concentrations in the lake during our climate change simulation, to compare to 
#  our baseline and land use scenarios later. 
#  Extract surface chl-a:
climate_chla <- get_var(file=climate, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["Climate_Chla"] <- climate_chla[2] # Here we attach the chl-a data from your 
#  climate simulation to the same file that contains your baseline scenario chl-a 
#  concentrations. You can now compare your climate scenario to your baseline- 
#  well done!

########## ACTIVITY B - OBJECTIVE 4 ############################################
# Plot the output using the commands you learned above. 
plot_temp(file=climate, fig_path=FALSE) # Create a heatmap of the water temperature
# How does this compare to your baseline?

plot_var(file=climate, "PHY_TCHLA") # Create a heatmap of chlorophyll-a. How 
#  does this compare to your baseline?

# Do these plots from the climate scenario and the baseline support or contradict 
# your hypotheses about climate change effects on chlorophyll-a? 

########## ACTIVITY C - OBJECTIVE 5 ############################################
# Now, with your partner and another team, select one of the pre-made land use 
#  scenarios based on changes in phosphorus concentrations in the inflow file. 
#  Remember that both teams should run the SAME land use scenario on their separate 
#  lakes and compare the output.

# Once you have selected your land use scenario, you need to edit the glm2.nml 
#  file to change the name of the inflow file so that it reads in the inflow file 
#  for your land use scenario, not the default "inflow.csv".  

# Open the glm2.nml file, scroll down to the inflows section, and change the 
#  inflow_fl entry to the new file name (e.g., from 'inflow.csv' to 'inflow_fourP.csv'). 

# IMPORTANT: Be sure to ALSO change your met file name in the glm2.nml BACK to 
  #  the original (baseline) met file (e.g., in the meteorology section, make sure 
  # your 'meteo_fl' entry is 'met_hourly.csv'. This is because we want 
  # to examine the effects of your land use scenario SEPARATE from the climate
  # scenario you developed earlier. Save your modified glm2.nml file that has 
  # baseline meteorology and altered land use.

# Once you have edited the nml file name, read in the updated file with the command:
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'inflow_fl') # If you have done this correctly, you should get 
  # an output that lists the name of your ALTERED inflow file.
get_nml_value(nml, 'meteo_fl') # If you have done this correctly, you should get 
  # an output that lists the name of your BASELINE meteorological file ('met_hourly.csv').

# You can now run the model for your land use scenario using the new edited 
#  nml file using the commands below. Exciting!

run_glm(sim_folder, verbose=TRUE) # Run your GLM model for your lake land use scenario. 
# At the end of the model run, it should say "Run complete" if everything worked.

# Again, we need to tell R where the output.nc file is so that the glmtools package 
#  can plot and analyze the model output. We tell R where to find the output file 
#  using the line below:
landuse <- file.path(sim_folder, 'output.nc') # This defines the output.nc file 
#  as being within the sim_folder. Note that we've called this output "landuse" 
#  since it is the output from our land use change simulation.

# As before, we want to save the model output of the daily chlorophyll-a 
#  concentrations in the lake during our land use change simulation, to compare 
#  to our baseline and climate scenarios later. 
# Extract surface chl-a:
landuse_chla <- get_var(file=landuse, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["LandUse_Chla"] <- landuse_chla[2] # Here we attach the chl-a data from your land 
#  use simulation to the same file that contains your baseline scenario and climate 
#  change scenario chl-a concentrations.

# Plot the output of your land use scenario using the commands you learned above. 
plot_var(file=landuse, "PHY_TCHLA") # Heatmap of chla. How does your phytoplankton 
#  heatmap look in comparison to the baseline? Be sure to check the scale of the 
#  color gradient representing chl-a when comparing plots!

# Finally, we want to see what happens when land use and climate interact! 
#  Luckily, testing the combined effects of your land use and climate change 
#  scenarios will be pretty easy! Since we already have modified met data 
#  (climate scenario) and inflow data (land use scenario), we just have GLM read 
#  them both at once. We can do this by changing the glm2.nml file to include our 
#  modified files.

# In the glm2.nml file, make the following TWO changes:

# 1) In the meteorology section, change the 'meteo_fl' entry to the met file that 
  # represents your climate change scenario (e.g., 'met_hourly_plus2.csv')

# 2) In the inflow section, check that the 'inflow_fl' file represents your land 
  # use change scenario (e.g., 'inflow_fourP.csv')

# Save your glm2.nml file, then run the following commands to check that the 
#  changes were made correctly.
nml <- read_nml(nml_file)  # Read in your nml file from your new directory
get_nml_value(nml, 'inflow_fl') # If you have done this correctly, you should get 
  # an output that lists the name of your ALTERED inflow file.
get_nml_value(nml, 'meteo_fl') # If you have done this correctly, you should get 
  # an output that lists the name of your ALTERED meteorological file.

# Run GLM one more time!
run_glm(sim_folder, verbose=TRUE) # Run your GLM model for your lake climate + land use 
#  scenario 

# As above, we need to tell R where the output.nc file is:
climate_landuse <- file.path(sim_folder, 'output.nc') # This defines the output.nc 
#  file as being within the sim_folder. Note that we've called this output 
#  "climate_landuse" since it is the output from our simultaneous climate AND 
#  land use change simulations.

# As before, we want to save the model output of the daily chlorophyll-a 
#  concentrations in the lake, to compare to our baseline, climate, and land use 
#  scenarios. 
# Extract surface chl-a:
combined_chla <- get_var(file=climate_landuse, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["Climate_LandUse_Chla"] <- combined_chla[2] # Here we attach the chl-a data from 
#  your combined simulation to the same file that contains your baseline, climate 
#  change, and land use scenario chl-a concentrations

# Plot the output of your land use scenario using the commands you learned above. 
plot_var(file=climate_landuse, "PHY_TCHLA") # Heatmap of chlorophyll-a

# Now that you've run four different scenarios (baseline, climate only, land use 
#  only, and climate + land use), let's plot how the chl-a in the lakes responded 
#  to the different scenarios. We can do this by:
attach(chla_output)

# The command below plots DateTime vs. Observed data in black: 
plot(DateTime, Baseline_Chla, type="l", col="black", ylim=c(0, 100),
     ylab="Chlorophyll-a (ug/L)", xlab="Date")  
lines(DateTime, Climate_Chla, col="red") # add a red line of the climate change scenario
lines(DateTime, LandUse_Chla, col="blue") # add a blue line of the land use scenario
lines(DateTime, Climate_LandUse_Chla, col="green") # add a green line of the climate + land use scenario
legend("topleft",c("Baseline", "Climate Only", "Land Use Only", "Combined C + LU"), 
       lty=c(1,1,1,1), col=c("black","red","blue", "green")) # add a legend

# !! Note that the command ylim=c(0, 100) tells R what you want the minimum and 
#  maximum values on the y-axis to be (here, we're plotting from 0 to 100 ug/L). 
#  You may need to adjust this range to make sure all your data are shown in the 
#  plot.

########## ACTIVITY C - OBJECTIVE 6 ############################################
# Using the line plot you just created, and the other team's line plot from their 
#  lake, put together a brief presentation of your model simulation and output to 
#  share with the rest of the class. 

# Make sure your presentation answers the questions listed in your handout.

# Bravo, you are done!! 

# We welcome feedback on this module and encourage you to provide comments, 
#  questions, and suggestions. Please visit our website (http://MacrosystemsEDDIE.org) 
#  to submit feedback to the module developers.