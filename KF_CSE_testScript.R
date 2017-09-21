library(glmtools)
sim_folder <- 'C:/Users/KFarrell/Desktop/R/ProjectEDDIE/CrossScale Emergence/Mendota' 
setwd(sim_folder)

nml <- read_nml(paste0(sim_folder,"/glm2.nml"))
run_glm(sim_folder, verbose=TRUE)
baseline <- file.path(sim_folder, 'output.nc') 

plot_temp(file=baseline, fig_path=FALSE) 
plot_var(file = baseline, "PHY_TCHLA")
