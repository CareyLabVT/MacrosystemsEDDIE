pacman::p_load(dplyr, ggplot2, GLMr, glmtools, reshape2)

sim_folder <- 'C:/Users/KFarrell/Desktop/R/ProjectEDDIE/CrossScale Emergence/Mendota' 
setwd(sim_folder)

nml <- read_nml(paste0(sim_folder,"/glm2.nml"))
run_glm(sim_folder, verbose=TRUE)
baseline <- file.path(sim_folder, 'output.nc') 

plot_temp(file=baseline, fig_path=FALSE) 
#plot_var(file = baseline, "PHY_TCHLA")

temp <- get_temp(baseline, reference="surface", z_out=c(0,1,5,10,23))
tempLong <- melt(temp, id.vars=c("DateTime"))
tempLong <- tempLong[complete.cases(tempLong),]

ggplot(tempLong, aes(y = value, x = DateTime, colour=variable))+ 
  geom_line(lwd=1.1) +
  scale_y_continuous("Water Temp", breaks=c(0,1,2,3,4,5,10,20,30), limits=c(0,30)) +
  geom_hline(yintercept=0, col='red', lty=2) +
  geom_hline(yintercept=4, col='blue',lty=2, lwd=1.1)


ice <- get_ice(file=baseline)
iceLong <- melt(ice, id.vars=c("DateTime"))
#tempLong <- tempLong[complete.cases(tempLong),]

ggplot(iceLong, aes(y = value, x = DateTime, colour=variable))+ 
  geom_line(lwd=1.1) 
