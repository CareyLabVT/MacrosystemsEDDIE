#Modeling Climate Change Effects on Lakes Using Distributed Computing Module
#This module was initially developed by Carey, C.C., S. Aditya, K. Subratie, and
#	R. Figueiredo. 1 May 2016.

#Project EDDIE: Modeling Climate Change Effects on Lakes Using Distributed Computing.
#	Project EDDIE Module 4, Version 1.
#	http://cemast.illinoisstate.edu/data-for-students/modules/lake-modeling.shtml.
#	Module development was supported by NSF DEB 1245707 and ACI 1234983.


#R code for students to work through the module activities A, B, and C.
#This module consists of 6 objectives. Activity A consists of Objectives 1-4,
#	Activity B consists of Objective 5, and Activity C consists of Objective 6.
#This script was modified last by CCC on 1 May 2016

########################################################################################

#ACTIVITY A - OBJECTIVE 1: Download the GLM files and R packages successfully onto your computer.
#The example code below is for a Mac operating system, but should also work on a PC- if you are a
#	PC user and having trouble, check the direction of your \ / marks- sometimes this may be
#	different between operating systems.

install.packages('sp') #NOTE: you'll get output that says "There is a binary version available
#	but the source version is later... Do you want to install from sources the package which
#	needs compilation? y/n" Type 'y' (without the quotes) and hit enter. You may now be prompted
#	to download the ‘command line developer tools’. Click Install and then re-run the
#	install.packages(‘sp’) once the install of the tools is finished. This should now
#	successfully load- when it's done, it should say 'DONE(sp)' if it worked successfully.

install.packages('glmtools', repos=c('http://cran.rstudio.com', 'http://owi.usgs.gov/R')) #you
#	need to be connected to the internet for this step- this step enables you to access the USGS
#	website and download the R packages that allow you to work with GLM in R. Note: if you are on
#	a slow internet connection, this may take a few minutes.

library(glmtools) #load the two packages that you need to run GLM and manipulate its output
#	note: you may get lots of output messages at this step- if this worked successfully, you
#	should read: "This information is preliminary or provisional and is subject to revision. It
#	is being provided to meet the need for timely best science. The information has not received
#	final approval by the U.S. Geological Survey (USGS) and is provided on the condition that
#	neither the USGS nor the U.S. Government shall be held liable for any damages resulting from
#	the authorized or unauthorized use of the information. Although this software program has
#	been used by the USGS, no warranty, expressed or implied, is made by the USGS or the U.S.
#	Government as to the accuracy and functioning of the program and related program material nor
#	shall the fact of distribution constitute any such warranty, and no responsibility is assumed
#	by the USGS in connection therewith".

library(GLMr) #if this worked, you should be able to successfully get GLMr to load without any
#	error messages. Hurray!

glm_version() #see what version of GLM you are running- should be at least v.2.x.x

#CONGRATS! You've now succesfully loaded GLM onto your computer!

#######################################################################################

#ACTIVITY A - OBJECTIVE 2: Now, we need to migrate the example files that come with your
#	downloaded GLM files onto a new directory on your computer.

#NOTE! Throughout the rest of the module, you may need to modify some of the lines of code
#	written below to run on your computer. If you do need to modify a line of code, I marked that
#	particular line with ##!! symbols at the beginning of that line's annotation.  If you do not
#	see those symbols, then you do not need to edit that line of code (you can merely run it as
#	normal).

nml_template_path() #this should give you a path that tells you where the example GLM nml file
#	is. On my computer, it is "/Library/Frameworks/R.framework/Versions/3.1/Resources/library/
#	GLMr/extdata/glm2.nml" but on yours, it may be slightly different.

#Now, actually go to the folder where that nml file is (for Mac users, you can use Finder's 'Go
#	to folder' feature and paste in the path). Within that folder, there should be two files, a
#	"met_hourly.csv" file and a "glm2.nml" file.  DO NOT OPEN THESE YET!

#Make a new folder elsewhere on your computer (e.g., your Desktop or My Documents or somewhere
#	else). On my computer, I made a new folder called "GLM" on my desktop. Copy all of the files
#	from the folder GLM path folder into this new folder. This should include "met_hourly.csv"
#	and "glm2.nml".  DO NOT OPEN these files, just copy and paste them into this new folder (and,
#	be sure to keep the original versions in the extdata folder). Once they are copied and pasted
#	safely into this new folder, we'll now need to tell R where these files are. We do that by...

sim_folder<-'/Users/renato/glm' ##!! Edit this line of code to redefine your sim_folder
#	path. This should be replaced with the path to your brand new folder that you just created on
#	your computer.  For me, it is a path to a new folder on my Desktop called "GLM"- for everyone
#	else's computer, this will be slightly different.

setwd(sim_folder) ##!! Edit this line of code to reset your working directory
#	to the sim_folder. The point of this step is to make sure that any new files you create
#	(e.g., figures of output) end up in this directory, vs. elsewhere in your computer.

nml_file<-paste0(sim_folder,"/glm2.nml") #this step sets the nml_file for your simulation to be
#	in the new sim_folder location.

nml<-read_nml(nml_file)  #read in your nml file from your new directory

print(nml) #this shows you what is in your nml file.  This is the 'master script' of the GLM
#	simulation- the nml file tells the GLM model all of the initial conditions about your lake,
#	how you are defining parameters, and more - this is a really important file! There should be
#	multiple sections, including glm_setup, morphometry, etc.

get_nml_value(nml, 'lake_name') ##!! this command is really useful because it tells you each of
#	the parameters that you are running within your nml file. Here, you are asking what the lake
#	name is in the nml file, but you could also use this to learn what the 'latitude',
#	'lake_depth', 'num_inflows', etc. is as well. Modify this command to learn where your model
#	lake is located by its latitude and longitude coordinates, the lake's maximum depth, and the
#	number of inflow streams into this lake.

plot_meteo(nml_file) #this command plots the meterological input data for the simulation- short
#	wave & long wave radiation, air temp, etc. for the duration of the simulation run. Do these
#	plots look reasonable for the latitude and longitude of your model lake?

######################################################################################

#ACTIVITY A - OBJECTIVE 3: Now, the fun part- we get to run the model and look at output!

run_glm(sim_folder, verbose=TRUE) #so simple and elegant... if this works, you should see output
#	that says "Simulation begins.." and then shows all the time steps. At the end of the model
#	run, it should say "Run complete" if everything worked ok.

#Now, go to the sim_folder on your computer- if everything happened correctly, you should see the
#	addition of new files that were created during the simulation with a recent date and time
#	stamp, including 'output.nc', 'lake.csv', and 'overflow.csv'. The most important these is the
#	'output.nc' file, which contains all of the output data from your simulation in netCDF
#	format.

nc_file <- file.path(sim_folder, 'output.nc') #this defines the output.nc file as being within
#	the sim_folder.  We need to know where the output.nc file is so that the glmtools package can
#	plot and analyze the model output.

plot_temp(file=nc_file, fig_path=FALSE) #this plots your simulated water temperatures in a heat
#	map, where time is displayed on the x-axis, depth is displayed on the y-axis, and the
#	different colors represent different temperatures.

#if you are a Mac user and want to save this figure as a pdf file while it is still open, use the
#	command: quartz.save("TempFileNameWhatever", type = "pdf", device = dev.cur(),
#	canvas="white").  Note: the file will be saved in your working directory.

########################################################################################

#ACTIVITY A - OBJECTIVE 4: Examine how your modeled GLM data compares to the observed field data
#	for your lake.

#Let's compare the model data to the observed data. Upload the 'field_data.csv' file and place it
	#into your sim_folder. Then run:

field_file <- file.path(sim_folder, 'field_data.csv') #define the observed field data

plot_temp_compare(nc_file, field_file) #plot your GLM simulated data vs. the observed data from
#	the field_data.csv file. How do the water temperatures and thermocline depths in the two
#	plots compare? The black circles in the observed data represent temperature observations at
#	different depths and times. Because our observed data were collected with high-frequency
#	thermistors on a buoy, there are lots of  black circles in the figure collected at the same
#	depths over time.

#Now, let's compare different physical lake characteristics between the simulated lake and the
#	observed lake.  To see what metrics we can compare between the observed and simulated data,
#	first check out this command from the glmtools package:
sim_metrics(with_nml = FALSE) #the option includes "thermo.depth" or the depth of the
#	thermocline, "buoyancy.freq" or buoyancy frequency, an index of thermal stratification,
#	"water.density" and "water.temperature".

compare_to_field(nc_file, field_file, metric="thermo.depth", as_value=TRUE, na.rm=TRUE) ##!! this
#	command gives the thermocline depth of the observed and modeled data for comparison.
#	Try this for the other metrics as well!

#to make a simple plot of the observed vs. simulated thermocline depths, use this script:
therm_depths <- compare_to_field(nc_file, field_file, metric="thermo.depth", as_value=TRUE, na.rm=TRUE)
plot(therm_depths$DateTime, therm_depths$obs, type="l", col="blue", ylim=c(0,32), ylab="Thermocline depth in meters")  #this plots DateTime vs. Observed data in blue, with a
#	y-axis set to 0-32 m, and a y-axis label.
lines(therm_depths$DateTime, therm_depths$mod, col="red") #this adds a red line of the modeled
#	thermocline depths
legend("topright",c("Observed", "Modeled"),lty=c(1,1), col=c("blue", "red")) #this adds a legend
#	to the figure.

#There are lots of other fun glmtools that you can play with, such as:
get_ice(nc_file)
get_evaporation(nc_file) #These two commands allow you to explore ice cover and evaporation in
#	your model output.

#########################################################################################

#ACTIVITY B - OBJECTIVE 5: Using your knowledge of potential climate change, work with a partner
#	to develop a climate change scenario for your model lake, modify the input data accordingly,
#	run the simulation, and analyze the output to determine how this scenario alters lake thermal
#	structure. After you have analyzed the model output, create some figures to present your
#	model simulation and output to the rest of the class.

#To breakdown this objective into a few steps, work with your partner to:

# 1) Develop a climate scenario (it can be for any region!)
# 2) Create a corresponding meteorological input file. Think through all of the components of the
	 # proposed scenario. For example, which of the meteorological variables (air temperature,
	 # precipitation, wind, etc.) will be modified and how? Will they be short-term or long-term
	 # modifications?
# 3) Run the file and examine how it alters the physical structure of the lake.  How does your
	# climate scenario change the thermal structure of the lake? What does the temperature profile
	# look like?  How does the depth of the thermocline change? How does the timing of
	# stratification and magnitude of evaporation change?
# 4) Compare the modeled output to the observed. What are the implications of your climate
	# scenario for future water quality and quantity?
# 5) Create a few figures to highlight the results of your climate scenario and present them to the
	# rest of the class. It would be helpful to present both the meteorological input file as well
	# as the lake thermal plots so that we can see how the lake responded to your climate forcing.

#To complete this activity, you will need to modify the input meterological data and then run the
#	model to examine the effects of your scenario on the thermal structure of the lake.

#1- ##!! Practice modifying the glm2.nml file. For example, open the nml file in a text editor (on
#	Macs, TextEdit or TextWrangler are good options), and change the time of the simulation so that
#	the model run starts on '2000-03-01 00:00:00' and ends on '2000-12-31 00:00:00' (or choose some
#	other date and time!). Plot the altered temperature. Note that GLM (as of the v.2.0 version)
#	does not handle ice well, so starting in the spring and running through the late fall may be
#	the best option for ice-covered lakes.

#2- SOMETHING THAT IS REALLY REALLY IMPORTANT! Opening up the met_hourly.csv file in Microsoft
#	Excel will unexplicably alter the date/time formatting of the file so that GLM cannot read it.
#	You will get an error something like this: "Day 2451545 (2000-01-01) not found".  To get around
#	this error, you need to follow the FIVE steps listed below.

#FIRST, copy and paste an extra version of the met_hourly.csv file in your sim folder so that you
#	have a backup in case of any mistakes. Rename this file something like
#	"met_hourly_UNALTERED.csv" and be sure not to open it.

#SECOND, open the met_hourly.csv file in Excel.  Manipulate the different input meteorological
#	variables to create your climate/weather scenario of your choice (be creative!). Note: the order
#	of the columns in the met file does not matter- but you can only have one of each variable and
#	they must keep the same header name (i.e., it must always be 'AirTemp', not 'AirTemp+3oC'). When
#	you are done editing the meteorological file, highlight all of the 'time' column in Excel, then
#	click on 'Format Cells', "Number", and then "Custom". In the "Type" or "Formatting" box, change
#	the default to "YYYY-MM-DD hh:mm:ss" exactly. This is the only time/date format that GLM
#	currently is able to read in. When you click ok, this should change the format of the 'time'
#	column so that it reads: "1999-12-31 00:00:00" with exactly that spacing and punctuation. Save
#	this new file under a different name, following how you have created your scenario, e.g.,
#	"met_hourly_SIMULATEDSUMMERSTORMS.csv" or whatever. Close the csv file, saving your changes.

#THIRD, you have now edited the time/date formatting file in Excel, but that Excel formatting has
#	still altered the underlying structure of the 'time' column, which needs to be fixed in R before
#	GLM can properly read the file to run the simulation. You need to run this code:

metdata <- read.csv("met_hourly_SIMULATEDSUMMERSTORMS.csv", header=TRUE) ##!! Edit the name of the
#	CSV file so that it matches your new met file name.
metdata$time <-as.POSIXct(strptime(metdata$time, "%Y-%m-%d %H:%M:%S", tz="EST")) #this command
#	converts the time column into the proper time/date structure that GLM uses.
write.csv(metdata, "met_hourly_SIMULATEDSUMMERSTORMS.csv", row.names=FALSE, quote=FALSE) ##!! Edit
#	this command to export a CSV file with the proper name- this CSV file will now have the proper
#	date/time formatting- yay!  Now, do NOT open the file in Excel again- otherwise, you will need to
#	repeat this process before reading the altered met file into GLM.

#IMPORTANT note: any time you alter the meteorological input file, you will have to repeat this step
#	to be able to read it into R and run the model in GLM.

#FOURTH.  Finally, you need to edit the glm2.nml file to change the name of the input meteorological
#	file so that it reads in the new, edited meteorological file for your climate scenario, vs. the
#	default "met_hourly.csv".  In the nml file, scroll down to the meteorology section, and change
#	the 'meteo_fl' entry to the new met file name (e.g., 'met_hourly_SIMULATEDSUMMERSTORMS.csv').
#	Note to Mac users- check to make sure that your quotes ' and ' around the file name are upright,
#	and not slanted- sometimes the nml default alters the quotes so that the file cannot be read in
#	properly (super tricky!).

#Once you havve edited the nml file name, you can always check to make sure that it is
#	correct with the command:
nml<-read_nml(nml_file)  #read in your nml file from your new directory
get_nml_value(nml, 'meteo_fl') #if you have done this correctly, you should get an output that lists
#	the name of your new meteorological file altered for your weather/climate scenario.

#FIFTH, you can now run the model with the new edited nml file, following the instructions as
#	described above for Objective 3.  Exciting!

# Plot the output using the commands you learned above: how does your scenario change the thermal
#	structure of the lake? What does the temperature profile over time look like? When and what is
#	the maximum and minimum water temperature? How does the depth of the thermocline change? How does
#	the timing of stratification change? Modify the code above to plot modeled vs. observed
#	thermocline depths, as well as other thermal characteristics. Ultimately, we want you to explore
#	the implications of your scenario for future water quality and quantity. If you have extra time,
#	create another scenario with your partner, and share your results with the rest of your
#	classmates.

###########################################################################################

#ACTIVITY C - OBJECTIVE 6: GRAPLEr!  The GRAPLEr is an R package that allows you to set up hundreds
#	of GLM simulations with varying input meteorological data and run those simulations efficiently
#	and quickly using distributed computing. The model "jobs" are submitted via a web service to run
#	on computers elsewhere, allowing you to rapidly set up and run hundreds of simulations, access
#	the output, and analyze the data.

# Install and configure GRAPLEr on your computer
install.packages("httr")
install.packages("RCurl")
install.packages("jsonlite")
install.packages("devtools")
library("devtools")
devtools::install_github("GRAPLE/GRAPLEr") #if this worked correctly, you should get output saying
#	"DONE (GrapleR)". Depending on your internet connection, this step may take a few minutes to
#	complete.

library(httr) #a package necessary for the GRAPLEr to work
library(RCurl) #if you have trouble loading this package with this step, consider updating R to the
#	most recent version- this seemed to help for me.
library(jsonlite) #a package necessary for the GRAPLEr to work
library(GRAPLEr) #if this loads successfully, you should get a return statement that says, "GRAPLEr
# has been developed with support from a supplement the the PRAGMA award (NSF OCI-1234983)."
# Woohooo!!!

#First, we need to setup folders for your GRAPLEr "Experiment". We call an "Experiment" a set
# of simulations that you submit to run on GRAPLEr. Each "Experiment" is configured in a folder
# (also known as directory) in your computer called an "Experiment Root Directory".
# You also need to create a "Results" folder to hold the output files when simulations are finished.

#Let's now set up two new folders to work from on your computer.
# One is called an "Experiment Root Directory" (ExpRootDir), which contains inputs (e.g. csv driver
#  files, GLM nml files) and a job description (more on this later) for your simulations
# The other is a "Results" directory, which specifies the location where model output will be
# downloaded to after the simulations are run.
# To get you going, the following lines will create these two directories for you, one called
# MyExpRoot and the other MyResults, within the sim_folder you setup in Activity A

MyExpRootDir <- paste(sim_folder,sep='/','MyExpRoot') # met/nml inputs will go here
dir.create(MyExpRootDir)  # create the MyExpRoot directory in your computer
MyResultsDir <- paste(sim_folder,sep='/','MyResults') # Outputs will go here
dir.create(MyResultsDir)  # create the MyResults directory in your computer

# !!!! IMPORTANT !!!!
# You now *must* copy the glm2.nml, met_hourly.csv (same as you used in Activity A), *and*
# the job_desc.json file (distributed with your the EDDIE module) into your MyExpRoot directory
# You can use Explorer (PC)/Finder (Mac) to do this.
# You *must* copy these three files to the MyExpRoot folder before continuing
# your directory/folder structure should then look something like this:
#
# (your sim_folder from activity A)  /MyExpRoot/met_hourly.csv
#                                              /glm2.nml
#                                              /job_desc.json
#                                    /MyResults                 (this is empty for now)
#
# !!!! IMPORTANT !!!!

list.files(MyExpRootDir) # double-checking that the file copy worked properly.
                         # !! you *must* see the glm2.nml, met_hourly.csv, and job_desc.json
                         # files listed here before continuing !!

#In Objective 5 above, you designed a climate scenario for one lake and modified the meteorological
#	input data and nml file manually. But what if you want to repeat this process for hundreds of
#	simulations that all have slightly different meteorological input data? It would not be very
#	efficient to do this manually by editing hundreds of Excel files one by one. Instead, we are
#	going to use the GRAPLEr R package, which will help you set up hundreds of different simulations
#	via an automated method, submit the jobs, and then receive the output back into your sim_folder,
#	saving you many hours of time!

#To start, let us first create a scenario in which we want to examine the effects of altered air
#	temperatures on lakes throughout the year. In Objective 5 above, you may have done this manually
#	by setting a constant offset of +2 oC to all of the baseline air temperatures in a year.  But
#	what if you also want to know the effects of a constant offset of +1.96 oC, +1.92 oC, etc. all
#	the way to -2 oC? How do those small changes in the temperature offset alter thermal structure in
#	thelake over the year? Are there any thresholds in lake responses that happen when you compare
#	the different offsets?

#To do this, we first need to define a scenario in which we vary air temperatures between -2 oC and
#	+2 oC from the baseline air temperature in the meteorological file for the entire simulation
#	period.

#These scenarios have been configured in a sample input file (job_desc.json) that is part of your
# project EDDIE module (and which you should have copied to the MyExpRoot directory)
# This file should *always* reside in the ExpRootDir of a GRAPLEr experiment, and should
# *always" be named job_desc.json
# It specifies how to generate inputs for your GRAPLEr batch; we have provided a sample file
# for this EDDIE module to get you started quickly.
# You can copy/modify it later to run your own scenarios, using a text editor
# Let's take a look at this file:

job_desc <- paste(MyExpRootDir,sep='/','job_desc.json')   # locate the job_desc.json file
cat( readLines( job_desc ) , sep = "\n" )                  # print its contents

#You will see the following information in this file:
#"met_hourly.csv" - this tells the GRAPLEr the name of your meteorological file in
#	your MyExpRoot directory. Note: If you are using a modified file from Objective 5, such as
#	"met_hourly_SIMULATEDSUMMERSTORMS.csv", you will need to edit this line to code to ensure that
#	you have the right file name here.

#"AirTemp" - for this scenario, we are modifying air temperature. You need to make sure
#	that you exactly match this formatting, which comes from the meteorological file column headers.
#	Note: you could also modify "ShortWave", "LongWave", "RelHum", "WindSpeed", "Rain", or "Snow".
#	However, you cannot have a negative offset for the light or precipitation data, because that
#	would give you errors- many of the light or precipitation data entries are 0, and you cannot have
#	negative light or precipitation! In this case, you would want to modify the file on an offset
#	ranging from 0 to some other positive value.

#"distribution": "linear" - this specifies what distribution GRAPLEr will use to generate your
# experiment; in this example, we will use a linear distribution, where we set
# "start" : -2 as the minimum offset added to the baseline air temperature (i.e., we are adding
#	-2oC to the baseline temperatures for the entire year)
# If you are working with light or
#	precipitation or any meteorological variable that cannot have negative values, this should be set
#	to zero.
# "end" : 2 as the maximum offset to the baseline air temperature (i.e., we are adding +2oC to
#	the baseline temperatures for the entire year).
# "operation" : "add" such that all offsets are calculated additively, not
#	multiplicatively. Other available options are "sub", "mul", "div" for subtraction, multiplication,
# and division, respectively
# "steps" : 100 this is the total number of steps from begin to end that will be run in this 'batch'.
# For us to run 100 steps, that means that each of the simulations between -2 and +2 oC are
#	separated by an increment of 0.04 (calculated by the maximum offset - the minimum offset, divided
#	by the number of simulations).  Here that = [2-(-2)]/100, or 0.04. That means that we are going
#	to run 101 simulations with air temperature offsets of -2+0.00 oC, -2+0.04 oC, -2+0.08 oC, ...,
# -2+3.96 oC, -2+4.00 oC.


# Now that we covered the job_desc file, let's get your GRAPLEr experiment configured and submit it!
# This will create an object called MyGraplerExp that will hold all the information associated
# with a GRAPLEr experiment. Here we specify the web service URL, your directories for
# MyExpRoot and MyResults, and a name for your experiment (EDDIE)
# You can create multiple objects to run multiple experiments! Just give them different names
# (e.g. MyExp2, MyExp3)

graplerURL<-"https://graple.acis.ufl.edu"  # specify web service address for the GRAPLEr.

MyExp <- Graple(GWSURL=graplerURL, ExpRootDir=MyExpRootDir, ResultsDir=MyResultsDir,
                ExpName="EDDIE", TempDir = tempdir())

#At this point, let us double-check that all of those packages were installed correctly and that
#	everything is in order before we start sending GLM runs to the GRAPLEr.

MyExp <- GrapleCheckService(MyExp)
print(MyExp@StatusMsg)  #This will contact the GRAPLEr service - if all went well with
# your installation, it will print a string that includes “I am alive, and at your service.”

# Now let's start your GRAPLEr run!

MyExp <- GrapleRunSweepExperiment(MyExp) #	This command submits simulations to the
# GRAPLEr service, based on the .nml, .csv and job_desc files in your MyExpRoot directory.
# What you are doing now is sending those 101 simulations to run
#	on other computers elsewhere, vs. running all 101 simulations on your computer.

# Now let's check the status of your submission:
print(MyExp@StatusMsg)

# If this worked, it should have returned:
# "The simulation was submitted successfully, JobID: 8477FY8V963SL96LCVIJ2IJ6K2ECNXS1E82PV5XP"
#	Your JobID will have a different string; this means that everything is running ok.

# Now, we wait! You can check the status of your experiment by running the following lines:

MyExp <- GrapleCheckExperimentCompletion(MyExp)
print(MyExp@StatusMsg)

#You should see an output with a percentage of completion (from 0.0% to 100.0%)
# You can run *both* these two lines of code every few seconds to check the status
# of your simulations, until it hits 100.0%. (You can continue to use R normally as you
#	 wait, but be sure to save the MyGraplerExp object if you close R so that you can retrieve your
#  results later. You need to have the information in this object to access your results)

# Ah, the anticipation! Patience.
# Once the status is "100.0% complete", you can move on to the next step - retrieve results!

#Note that this step may take a while to prepare the outputs and download them to your computer in a
#	compressed zip folder in your GRAPLEr working directory. Using all of the example files as described
# in the default simulation above, the compressed output will be about 50-100MB in size- it is
#	dependent on how long your simulated period is, how many depths you simulated, etc.)
# Note also that error messages for bzip2 may appear - you can ignore them

MyExp <- GrapleGetExperimentJobResults(MyExp);
print(MyExp@StatusMsg)

# If this worked correctly, you should now find a new folder within your MyResults folder,
# with the experiment name (EDDIE); and within that folder, another one called "Sims"
# Within this Sims folder, you'll find separate
#	folders for each of the individual sims- Sim1, Sim2, ... Sim101. Open up the folders to check that
#	each of these subfolders has an output.nc file, which means that the simulation ran.
#
# So now with all the outputs, your directory/folder structure will look like this:
#
# (your sim_folder)  /MyExpRoot/met_hourly.csv
#                              /glm2.nml
#                              /job_desc.json
#                    /MyResults/EDDIE/Sims/Sim1/Results/output.nc
#                                         /Sim2/Results/output.nc
#                                                     ...
#                                         /Sim101/Results/output.nc


#Note: if there are any error in your original GLM simulation, the GRAPLEr will not give any error
#	messages, so if you do not have any output in your sim folders, it is likely due to a problem with
#	the baseline GLM model. I would recommend on seeing if you can get that model to run on its own,
#	before trying to run hundreds of simulations with offsets.

#Let's check a couple of simulation outputs now. Each simulation is in its own folder, under
#	MyResults/EDDIE/Sims/SimXX/Results (where XX is a number between 1 and 101 in our scenario)

#Let's check simulations 1 and 101 first. All of the simulations will be placed in a separate folder by
#	their simulation number within the zip folder; this command sets the directory for that simulation
#	by appending Sims/Sim1/Results to your sim_folder:
sim_folder_1<-paste(MyResultsDir,sep='/','EDDIE','Sims','Sim1','Results')
sim_folder_101<-paste(MyResultsDir,sep='/','EDDIE','Sims','Sim101','Results')

#We need to define the output files and tell R where to look where they are to analyze the output.
#	Unlike above, when we were working with just one output netCDF file, we now have to give the output
#	file a number in its file name so that we can keep all of the different separate.
nc_file_1 <- file.path(sim_folder_1, 'output.nc')
nc_file_101 <- file.path(sim_folder_101, 'output.nc')
#you can also copy this code and modify it for any simulation number between 1 and 101.

#Let's plot the two different simulations, which represent the minimum and maximum offset scenarios:
plot_temp(file=nc_file_1, fig_path=FALSE)
plot_temp(file=nc_file_101, fig_path=FALSE)
#How do these two figures compare, in terms of water temperature, thermocline depth, etc.?

#Now, let's look plot the temperature of all of the 101 simulations. To do this, run all of the code in
#	the lines below. This is a for-loop, which means that R will go through each of the simulation
#	folders, extract the temperature data, and create a plot. If you have your plotting R window open,
#	then you can see how the lake gets sequentially warmer and thermal structure changes with each
#	simulation offset. Note that the changes in the thermal plots with each offset are not linear- there
#	are step changes that occur, with bigger changes occurring in the lake for some offsets more than
#	others.

startValue = -2
endValue = 2
numberOfIncrements = 100
for (n in 1:numberOfIncrements) {
 simn <- paste("Sim",n,sep="")
 sim_folder_n <- paste(MyResultsDir,sep='/','EDDIE','Sims',simn,'Results')
 nc_file_n <- file.path(sim_folder_n, 'output.nc')
 tempoffset <- startValue + n*((endValue-startValue)/numberOfIncrements)
 simlabel <- paste(simn, "temperature offset:", tempoffset)
 print(simlabel)
 plot_temp(file=nc_file_n, fig_path=FALSE)
}

#Now that you and your partner have run through this demonstration, it is now time for you to design
#	your own GRAPLEr GLM "experiment" with your partner and use the GRAPLEr to examine the offsets of a
#	meteorological variable and magnitude of your choice. Create some figures from your simulation and
#	share them with the class!  Note that there are many different ways to analyze the output from each
#	of the simulations- e.g., you could aggregate all of the days to calculate maximum Schimdt stability
#	or thermocline depth and then plot how that value changes over the different simulation numbers. The
#	glmtools package has many different options for analyzing and plotting GLM output that we invite you
#	to explore.

#Remember that you may should create a new working directory for inputs and outputs of each new
# GRAPLEr experiment - e.g. MyExpRootDir2 and MyResultsDir2, copy the nml/csv files to
# your experiment root directory MyExpRootDir2, edit the job_desc.json
#	Otherwise, you may accidentially submit previous results with your next jobs. Having these
#	subdirectories will substantialy slow down your GRAPLEr jobs, so we strongly encourage you to start
#	with an empty, new working directory for each GRAPLEr experiment.

#Thinking ahead: how could you use the GRAPLEr in your own research? You could use the GRAPLEr to
#	examine hundreds of simulations for any GLM model (not just the default Awesome Lake, but your own
#	research lake!) so think through what science questions you can ask using this R package.

#Bravo, you are done!

#We welcome feedback on this module and encourage you to contact Cayelan Carey or Renato
	#Figueiredo if you have questions. Note that this script will likely need to be updated for future
	#versions of R, GLMr, glmtools, and GRAPLEr, so we highly recommend that you download the most
	#recent version from our website: github.com/GRAPLE/GRAPLEr/wiki
