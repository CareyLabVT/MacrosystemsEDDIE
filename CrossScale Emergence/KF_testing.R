library(glmtools)
library(GLMr)

LakeName <- 'Mendota'
sim_folder <- paste('C:/Users/KJF/Desktop/R/MacrosystemsEDDIE/CrossScale Emergence/',
                    LakeName, sep='')
setwd(sim_folder) 

nml_file <- paste0(sim_folder,"/glm2.nml") 
nml <- read_nml(nml_file) 

run_glm(sim_folder, verbose=TRUE) 
baseline <- file.path(sim_folder, 'output.nc') 

#plot_temp(file=baseline, fig_path=FALSE) 
plot_var(file = baseline, "PHY_TCHLA") 
