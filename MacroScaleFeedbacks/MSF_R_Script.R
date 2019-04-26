# Macro-Scale Feedbacks Module ####
 # This module was developed by Carey, C.C. and K.J. Farrell. 1 April 2019.
 # Macrosystems EDDIE: Macro-Scale Feedbacks. Macrosystems EDDIE Module 4, Version 1. 
 # module4.macrosystemseddie.org
 # Module development was supported by NSF EF 1702506.

# R code for students to work through the module activities A, B, and C.
 # This module consists of 6 objectives. Activity A consists of Objectives 1-2,
 # Activity B consists of Objectives 3-4, & Activity C consists of Objectives 5-6.

########## ACTIVITY A - OBJECTIVE 1 ############################################
# Download R packages and GLM files onto your computer.

install.packages('sp') 
# NOTE: depending on your computer, you may get output  that says, "There is a 
  #  binary version available. Do you want to install from sources that need 
  #  compilation? y/n" If this pops up, type 'y' (without the quotes) and hit enter. 
  #  You may now be prompted to download the command line developer tools in a 
  #  pop-up window. Command line developer tools is a program used to run modeling 
  #  software. Click Install and then re-run install.packages(sp). This should 
  #  now successfully load- when it's done, it should say 'DONE(sp)' if it worked.

install.packages('devtools') 
# This is another R package used to run modeling software. If you get an error 
  #  message that says, "package ‘devtools’ is not available (for R version x.x.x)", 
  #  be sure to check that you are running the latest version of R

# Load the packages you just downloaded
library(sp) 
library(devtools)

# Download the GLMr package. This may take a few minutes. 
devtools::install_github("CareyLabVT/GLMr") 
# If successful you should  see "DONE (GLMr)" at the end of the output.

# This step downloads the R packages that allow you to work with GLM in R. 
devtools::install_github("CareyLabVT/glmtools") 

# Load the two packages that you need to analyze GLM output
library(glmtools) 
  #  NOTE: you may get lots of output messages in red at this step- if it worked 
  #  successfully, you should read a lot of text that starts with: "This 
  #  information is preliminary or provisional..." 

library(GLMr) 
# If this worked, GLMr should load without error messages. Hooray!

glm_version() 
# See what version of GLM you are running- should be v.2.x.x. Note, for some 
#   some computers, you may not get a message. As long as you don't get an error,
#   you should be ok!

# CONGRATS! You've now succesfully loaded GLM onto your computer! 
  # Now, we will explore the files that come with your downloaded GLM files 

# NOTE! Throughout the rest of the module, you will need to modify some of the 
  #  lines of code to run on your computer. If you need to modify a line, I put 
  #  the symbols ##!! at the beginning of that line's annotation.  If you do not 
  #  see those symbols, you do not need to edit that line of code and can run it 
  #  as written.

# When working in R, we set the sim_folder to tell R where your files, scripts, 
  #  and model output are stored.  
# To find your folder path, navigate to the 'macroscale_feedbacks' folder on 
  # your Desktop. Right click on the folder that matches your model lake 
  #  (Mendota, Sunapee, or FallingCreek), then select Properties (Windows) or 
  #  Get Info (Mac). 
  #  Look under Location (Windows) or Where (Mac) to find your folder path 
  #  (examples below):
  #  Windows: C:/Users/KJF/Desktop/macroscale_feedbacks/LakeName
  #  Mac: Users -> careylab -> Desktop -> macroscale_feedbacks -> LakeName

##!! Edit this line to define the sim_folder location for your model lake. 
sim_folder <- '/Users/cayelan/Desktop/macroscale_feedbacks/LakeName' 
  #  You will need to change the part after Users/ to give the name of your 
  #  computer (e.g., my computer name is cayelan, but yours will be different!) 
  #  AND change the word LakeName to be the name of your model lake (Mendota, Sunapee,
  #  Toolik, or FallingCreek). Note that these computer file paths are case-sensitive.

# This line of code is sets your sim_folder as the working directory 
setwd(sim_folder) 
# The point of this step is to make sure that any new files you create (e.g., 
# figures of output) end up together in this folder.

# This step tells R that the nml_file for your simulation is inside the sim_folder
nml_file <- paste0(sim_folder,"/glm2.nml") 

# Read in your nml file from your working directory
nml <- read_nml(nml_file) 

# This shows you what is in your nml file.  
print(nml) 
#  This is the 'master script' of the GLM simulation; the nml file tells the GLM 
  #  model all of the initial conditions about your lake, how you are defining 
  #  parameters, and more - this is a really important file! There should be 
  #  multiple sections, including glm_setup, morphometry, meteorology, etc.

# This command plots the meterological input data for the simulation:
plot_meteo(nml_file)  
# It includes short wave & long wave radiation, air temp, relative humidity, 
  #  etc. for the duration of the simulation. 
 
########## ACTIVITY A - OBJECTIVE 2 ############################################
# Now, the fun part- we get to run the model and look at output!

run_glm(sim_folder, verbose=TRUE) 
# So simple and elegant... if this works, you will see output that says 
  #  "Simulation begins..". At the end, it should say "Run complete" if 
  #  everything worked ok. This may take a few minutes.

# We need to specify where the output data from your simulation (the output.nc file) 
  #  is so that the glmtools package can plot and analyze the model output. We tell 
  #  R where to find the output file using the line below:

# This says that the output.nc file is in the sim_folder.  
baseline <- file.path(sim_folder, 'output.nc') 

# This command plots your simulated water temperatures in a heat map, where time 
  #  is displayed on the x-axis, lake depth is displayed on the y-axis, and the 
  #  different colors represent different temperatures. 
plot_temp(file=baseline, fig_path=FALSE) 

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
print(var_names) 

# We are particularly interested in the flux of methane (CH4) and carbon 
  #  dioxide (CO2) across the water surface to the atmosphere. The variable name 
  #  for CH4 release is "CAR_atm_ch4_exch", and the variable name for CO2 release 
  #  is "CAR_atm_co2_exch".
  #  Both fluxes are reported in units of mmol/m2/day, or millimoles emitted
  #  per meter squared (of lake surface area) per day. 
  #  Important! These fluxes can be positive (meaning CH4 and CO2 released from
  #  the lake into the atmosphere) OR negative (meaning CH4 and CO2 taken up from
  #  the atmosphere into the lake). Always check the sign when you look at these
  #  fluxes in the model output.
  #  Search through the list of variables to find both CH4 and CO2 fluxes.

# First, we want to save the model output of the daily flux rates for both CH4 
  #  and CO2 in the lake during our baseline simulation, because we'll be comparing  
  #  them to our climate scenarios later. To do this, we use the following 
  #  commands:

# Save the CH4 flux at the surface first:
ch4_output <- get_var(file=baseline, "CAR_atm_ch4_exch") 
colnames(ch4_output)[2] <- "Baseline_CH4" 
# Here we renamed the CH4 column so we remember it is from the Baseline scenario

# Then save the CO2 flux at the surface second:
co2_output <- get_var(file=baseline, "CAR_atm_co2_exch") 
colnames(co2_output)[2] <- "Baseline_CO2" 
# Here we rename the CO2 column so we remember it is from the Baseline scenario

# We'll also use the commands below to save a copy of our output as .csv files:
write.csv(ch4_output, './ch4model_output.csv', quote=F, row.names = F)
write.csv(co2_output, './co2model_output.csv', quote=F, row.names = F)

# Now, use the code below to create a figure of CH4 fluxes in the lake over time. 
  #  You can click "Zoom" on the plot window to see a larger version of your plot
plot(Baseline_CH4 ~ DateTime, data= ch4_output, type='b', pch=20, lwd=2, col='gray20',
     ylab = "Methane flux, (mmol/m2/d)")
abline(h= 0, col= 'black', lty= 3, lwd= 3) 
# Add a black dashed line at 0 to show the cutoff between positive and negative

# Now, compare that CH4 figure with a figure of CO2 fluxes in the lake over time.
plot(Baseline_CO2 ~ DateTime, data= co2_output, type='b', pch=20, lwd=2, col='gray20',
     ylab = "Carbon dioxide flux, (mmol/m2/d)")
abline(h= 0, col= 'black', lty= 3, lwd= 3) 
# Add a black dashed line at 0 to show the cutoff between positive and negative

# What do you notice about seasonal patterns in CH4 and CO2 fluxes? When are the
  #   fluxes negative, and when are they positive? How might this be related to 
  #   seasonal trends in lake temperature, ice cover, and spring and fall mixing? 
  #   How do the patterns of CH4 and CO2 fluxes compare over time?

########## ACTIVITY B - OBJECTIVE 3 ############################################
# For Activity B, you will work with your partner to examine how your lake's CH4 and
  #  CO2 fluxes will respond to climate change. First, work with your partner to select
  #  one of the pre-made climate scenarios. 

##!!!! Once you have selected your climate scenario, you need to edit the glm2.nml 
  #  file to change the name of the input met file so that it reads in the met 
  #  data for your climate scenario, *NOT* the default 'met_hourly.csv'.  

##!!!! Open the .nml file by clicking 'glm2.nml' in the Files tab of RStudio, 
  #  then scroll down to the meteorology section, and change the 'meteo_fl' entry 
  #  to the new met file name (e.g., from 'met_hourly.csv' to 'met_hourly_plus2.csv'). 

##!!!! SAVE your modified glm2.nml file.

# Once you have edited the nml file name, you should check to make sure that 
  #  it is correct with the following commandS:
nml <- read_nml(nml_file)   
get_nml_value(nml, 'meteo_fl') 
##!! The printout here should list your NEW meteorological file for your climate 
  # scenario. If it doesn't, make sure you pressed the Save icon (the floppy disk)
  # after you changed your glm2.nml file.

# You can now run the model for your climate change scenario using the new edited 
  # nml file using the commands below. Exciting!

# Run your GLM model for your lake climate scenario. 
run_glm(sim_folder, verbose=TRUE) 

# Again, we need to tell R where the output.nc file is so that we can plot 
  #  and analyze the model output. We tell R where to find the output file 
  #  using the line below:
climate <- file.path(sim_folder, 'output.nc') 
# This defines the output.nc file as being within the sim_folder. Note that we've 
  #  called this output "climate" since it is output from our climate change simulation.

# As before, we want to save the model output of the daily flux rates in the lake 
  #  during our climate change simulation, to compare to our baseline scenario. 

#  Extract daily CH4 flux rates:
climate_ch4 <- get_var(file=climate, "CAR_atm_ch4_exch") 
ch4_output["Climate_CH4"] <- climate_ch4[2] 
# Here we attach the CH4 flux data from your climate simulation to the same file 
  #  that contains your baseline scenario flux rates. 

#  Extract daily CO2 flux rates:
climate_co2 <- get_var(file=climate, "CAR_atm_co2_exch") 
co2_output["Climate_CO2"] <- climate_co2[2] 
# Here we attach the CO2 flux data from your climate simulation to the same file 
  #  that contains your baseline scenario flux rates. 

# Again, we'll use the command below to save a copy of our outputs as .csv files:
write.csv(ch4_output, './ch4model_output.csv', quote=F, row.names = F)
write.csv(co2_output, './co2model_output.csv', quote=F, row.names = F)

##!! To check that your climate change scenario ran correctly, run the command 
  #  below, and compare the CH4 and CO2 fluxes between baseline and climate scenarios. 
  #  They'll likely be similar, but if they're EXACTLY the same after the first 
  #  few rows, something likely went wrong in setting up your climate scenario 
  #  (likely with changing the met_hourly name in the glm2.nml file!)
View(ch4_output)
View(co2_output)

########## ACTIVITY B - OBJECTIVE 4 ############################################
# Plot the output using the commands you learned above. 
# Create a heatmap of the water temperature in your climate scenario:
plot_temp(file=climate, fig_path=FALSE) 
  # How does this output compare to your baseline water temperature heatmap?

# Note: If you want to control the maximum value of the color scale on your heatmaps, 
  # add the following (without quotes) after fig_path=FALSE: ', col_lim= c(0,35)'
  # This tells R that you want your minimum value to be 0, and your 
  # maximum value to be 35. You can change the minimum and maximum values to fit
  # your lake.

# Now let's plot CH4 and CO2 fluxes in your lake from the two different 
  #  scenarios (baseline and climate) on the same figure. We can do this by:

# First, the command below plots the timeseries of CH4 fluxes from the baseline 
  #  scenario in gray: 
plot(Baseline_CH4 ~ DateTime, data= ch4_output, type='b', pch=20, lwd=2, col='gray20',
     ylab = "Methane flux, (mmol/m2/d)", ylim = c(-1, 1))

# Second, we can superimpose the CH4 fluxes from our climate scenario as a 
  # set of red points and lines using the two lines of code below: 
lines(Climate_CH4 ~ DateTime, data= ch4_output, lwd=2, col='red3')
points(Climate_CH4 ~ DateTime, data= ch4_output, pch=20, col='red3')

# Third, we'll add a black dashed line at 0
abline(h = 0, col = 'black', lty = 3, lwd=3) 

# And finally, we'll add a legend:
legend("topleft", c("Baseline", "Climate"), lty=1, lwd=2, col=c("gray20","red3"))

## Note that the command ylim=c(0,1) in the first plot step tells R what you 
  #  want the minimum and maximum values on the y-axis to be (here, it's set up 
  #  to plot from -1 to 1 mmol/m2/day). 

##!!!! You should adjust this ylim range to make sure all your data from both 
  #  scenarios are shown in the plot without too much white space.

# Now we'll use the same series of plotting commands to visualize CO2 fluxes 
  #  from both the baseline and climate scenario:
plot(Baseline_CO2 ~ DateTime, data= co2_output, type='b', pch=20, lwd=2, col='gray20',
     ylab = "Carbon dioxide flux, (mmol/m2/d)", ylim = c(-0.5, 0.5))

# Add a line & points for the climate warming scenario data:
lines(Climate2_CO2 ~ DateTime, data= co2_output, lwd=2, col='red3')
points(Climate2_CO2 ~ DateTime, data= co2_output, pch=20, col='red3')

# Add a black dashed line at 0
abline(h = 0, col = 'black', lty = 3, lwd=3) 

# Add a legend:
legend("topleft", c("Baseline", "Climate"), lty=1, lwd=2, col=c("gray20","red3"))

##!!!! Again, adjust the y-axis range by editing the command ylim=c(-0.5,0.5) to 
  #  make sure all your data are shown in the plot without too much white space.

# Do these plots with the baseline and climate scenarios support or contradict 
  #  your hypotheses about climate change effects on CH4 and CO2 fluxes? How?

########## ACTIVITY C - OBJECTIVE 5 ############################################
# Now we are going to calculate global warming potentials (GWPs), which provide 
  #  a metric by which we can compare the relative effect of CH4 and CO2 fluxes 
  #  from different ecosystems on global warming. If your lake has a positive
  #  GWP, it means it is contributing heat-trapping gases to the atmosphere, and 
  #  amplifying global warming. Conversely, if your lake has a negative GWP, it 
  #  means it is a net sink of heat-trapping gases, and is offsetting global warming. 
  #  In Activity C, we are going to examine how your lake's GWPs change under 
  #  different climate change scenarios, resulting in macro-scale feedbacks.

# We need to calculate the masses of CO2 and CH4 emitted or taken up by the lake 
  #  over the one-year simulation period in the baseline simulation. 
  #  To do this, we do a number of mathematical manipulations:

# FIRST, we sum the daily fluxes of CO2 and CH4 (mmol/m2/d) across the simulation 
  # to estimate the yearly flux of CO2 and CH4 (in mmol/m2)

# SECOND, we multiply the yearly CO2 and CH4 flux (mmol/m2) by the lake 
  #  surface area (m2) to convert the rate into a yearly mass (mmol).

# Lake area is defined as part of the nml file when setting up the GLM model.
#  You can find your lake surface area using the command below:
lakearea <- max(nml$morphometry$A)
print(lakearea)

# THIRD, we convert mmol to kilograms by multiplying by molecular weight 
  #  (44.01 for CO2, 16.04 for CH4) and dividing by 1000000

# The net result of these steps is: 
BaselineCO2mass <- sum(co2_output$Baseline_CO2) * lakearea * 44.01 / 1000000

BaselineCO2mass 
# This value is the yearly CO2 flux for your lake (in kg). Is it negative or positive? 
  #  What does that mean?

# We use the same steps to calculate CH4, but using the CH4 molecular weight!
BaselineCH4mass <- sum(ch4_output$Baseline_CH4) * lakearea * 16.04 / 1000000

BaselineCH4mass 
# This value is the yearly CH4 flux for your lake (in kg). Is it negative or positive? 
#  What does that mean? 

# Now that the mass of both CO2 and CH4 fluxes are calculated, we need to calculate 
  #  the GWP of your lake in the baseline scenario. CO2 has a GWP of 1 but CH4 has 
  #  a GWP of 86 over a 20-year time horizon (IPCC 2013). That means that one 
  #  molecule of CH4 has 86 times the impact on atmospheric heating on a 20-year
  #  time horizon as one molecule of CO2. 

# We convert the kg of CH4 to CO2 equivalents (e.g., multiply by 86) so we can 
  #  calculate the GWP impact of both gases using the same units (CO2 equivalents):
GWP_baseline <- (BaselineCO2mass * 1) + (BaselineCH4mass * 86)

GWP_baseline
# This value is the baseline GWP for your lake. Is it positive or negative? If it
  #  is positive, the value corresponds to how many kg of CO2 are released to the 
  #  atmosphere each year. If it is negative, the value corresponds to how many 
  #  kg of CO2 are taken up by your lake from the atmosphere each year, thereby
  #  offsetting other greenhouse gas emissions.

# Let's do the same mass and GWP calculations for the climate change scenario to 
  #  see how this compares with your baseline GWP.

# Calculate the yearly CO2 flux for your lake under the climate change scenario:
ClimateCO2mass <- sum(co2_output$Climate_CO2) * lakearea * 44.01 / 1000000

ClimateCO2mass 
# This value is the yearly CO2 flux for your lake (in kg) under the climate change
  #  scenario. Is it negative or positive? What does that mean?

# Calculate the yearly CH4 flux for your lake under the climate change scenario:
ClimateCH4mass <- sum(ch4_output$Climate_CH4) * lakearea * 16.04 / 1000000

ClimateCH4mass 
# This value is the yearly CH4 flux for your lake (in kg) under the climate change
  #  scenario. Is it negative or positive? What does that mean?

# As above, we will estimate the GWP for our lake under the climate change scenario
  #  by converting our CH4 mass into CO2 equivalents, since CH4 has 86 times the 
  #  warming atmospheric warming impact on a 20-year time horizon as CO2. 
GWP_climate <- (ClimateCO2mass * 1) + (ClimateCH4mass * 86)

GWP_climate
# How does this climate GWP value compare to the baseline GWP value? Is it positive
  #  or negative? What does this mean?

########## ACTIVITY C - OBJECTIVE 6 ############################################
# Now let's create some figures to show your results! 

# To get all our calculated values together, we'll create an empty data matrix,
  #  then fill it in with our calculated numbers:
# Create the empty matrix, with 3 columns and 2 rows:
data <- matrix(ncol=3, nrow=2) 

# In the first row, we'll fill in the baseline CO2 mass, CH4 mass, and GWP:
data[1,] <- c(BaselineCO2mass, BaselineCH4mass, GWP_baseline)

# In the second row, we'll fill in the climate scenario CO2 mass, CH4 mass, and GWP:
data[2,] <- c(ClimateCO2mass, ClimateCH4mass, GWP_climate)

# The two commands below allow us to provide names for the rows and columns:
row.names(data) <- c("Baseline", "Climate")
colnames(data) <- c("CO2 mass", "CH4 mass", "GWP")

# Use this command to view your data matrix:
View(data)

# Now we'll create a barplot to compare the baseline vs. climate CO2 and CH4 masses, 
  #  and the GWPs between the two scenarios.
barplot(data, col=c("gray20","red3"), font.axis=2, beside=T, ylab="kg or GWP", 
        main=paste0(nml$morphometry$lake_name,", ", nml$meteorology$meteo_fl),
        font.lab=2, ylim= c(-20000, 20000))
abline(h = 0, col = 'black', lty = 1, lwd=1) 
legend("topleft", legend=rownames(data), pch = 19, col=c("gray20","red3"))
#  As in our earlier plots, the gray bars represent the baseline scenario and 
  #  the red bars represent the climate scenario.

##!!!! As before, adjust the ylim command to make sure your data are clearly 
  #  visualized! 

# Do these data support or contradict your hypotheses about the relative importance
  #  of CO2 and CH4 fluxes on global warming? What is the net effect of the lake 
  #  on the atmosphere in the baseline scenario? How might this change with 
  #  climate warming?

# What are the macro-scale feedbacks between your lake and its greenhouse gas fluxes?
  #  How will your lake's CO2 and CH4 fluxes feed back to either intensify or 
  #  counteract climate change?

# Using the figures you created as part of the module, put together a brief 
  #  presentation of your model simulation and output to share with the rest of 
  #  the class.

# Make sure your presentation answers the questions listed in your handout.

# Bravo, you are done!! 

# We welcome feedback on this module and encourage you to provide comments, 
  #  questions, and suggestions. Please visit our website (http://MacrosystemsEDDIE.org) 
  #  to submit feedback to the module developers.