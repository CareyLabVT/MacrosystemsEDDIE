pacman::p_load(glmtools, ggplot2, reshape2)
sim_folder <- 'C:/Users/KFarrell/Desktop/R/ProjectEDDIE/CrossScale Emergence/Mendota' 
setwd(sim_folder)

########## BASELINE #############
nml_file <- paste0(sim_folder,"/glm2.nml") 
nml <- read_nml(nml_file)

run_glm(sim_folder, verbose=TRUE)
baseline <- file.path(sim_folder, 'output.nc')
plot_temp(file=baseline, fig_path=FALSE)

temp <- get_temp(baseline, reference="surface", z_out=seq(0:24))
tempLong <- melt(temp, id.vars=c("DateTime"))

ggplot(tempLong, aes(y = value, x = DateTime, colour=variable))+ 
  geom_line() +
  scale_y_continuous("Water Temp", limits=c(0,30)) +
  geom_hline(yintercept=0, col='red', lty=2) +
  geom_hline(yintercept=4, col='blue',lty=2)+
  scale_x_datetime(date_breaks='1 year', date_labels='%Y')
