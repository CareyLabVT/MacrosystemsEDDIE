library(glmtools)
sim_folder <- 'C:/Users/KFarrell/Desktop/R/ProjectEDDIE/CrossScale Emergence/KF_module_test_files/Mendota' 
setwd(sim_folder)

########## BASELINE #############
nml_file <- paste0(sim_folder,"/glm2.nml") 
nml <- read_nml(nml_file)

run_glm(sim_folder, verbose=TRUE)
baseline <- file.path(sim_folder, 'output.nc')
plot_temp(file=baseline, fig_path=FALSE)
plot_var(file = baseline, "PHY_TCHLA")

chla_output <- get_var(file=baseline, "PHY_TCHLA", reference='surface', z_out=c(1)) 
colnames(chla_output)[2] <- "Baseline_Chla"

########## CLIMATE #############
nml <- read_nml(nml_file)
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE)
climate <- file.path(sim_folder, 'output.nc') 

`*tmp*` <- get_var(file=climate, "PHY_TCHLA", reference='surface', z_out=c(1))
chla_output["Climate_Chla"] <- `*tmp*`[2]

plot_temp(file=climate, fig_path=FALSE) 
plot_var(file=climate, "PHY_TCHLA") 

########## LAND USE #############
nml <- read_nml(nml_file) 
get_nml_value(nml, 'inflow_fl')
get_nml_value(nml, 'meteo_fl')

run_glm(sim_folder, verbose=TRUE) 
landuse <- file.path(sim_folder, 'output.nc') 

`*tmp*` <- get_var(file=landuse, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["LandUse_Chla"] <- `*tmp*`[2]

plot_temp(file=landuse, fig_path=FALSE) 
plot_var(file=landuse, "PHY_TCHLA")

########## SYNERGY #############
nml <- read_nml(nml_file) 
get_nml_value(nml, 'inflow_fl')
get_nml_value(nml, 'meteo_fl') 

run_glm(sim_folder, verbose=TRUE) 
climate_landuse <- file.path(sim_folder, 'output.nc') 

`*tmp*` <- get_var(file=climate_landuse, "PHY_TCHLA", reference='surface', z_out=c(1)) 
chla_output["Climate_LandUse_Chla"] <- `*tmp*`[2]

plot_temp(file=climate_landuse, fig_path=FALSE)
plot_var(file=climate_landuse, "PHY_TCHLA") 

########## LINE PLOTS #############
attach(chla_output)

plot(DateTime, Baseline_Chla, type="l", col="black", ylim=c(0, 500), ylab="Chlorophyll-a (ug/L)", xlab="Date")  
lines(DateTime, Climate_Chla, col="red") 
lines(DateTime, LandUse_Chla, col="blue") 
lines(DateTime, Climate_LandUse_Chla, col="green") 
legend("topleft",c("Baseline", "Climate Only", "Land Use Only", "Combined C + LU"), lty=c(1,1,1,1),col=c("black","red","blue", "green")) 

#### GGPLOTS FOR ASSESSMENT ####
library(reshape2)
library(ggplot2)
mytheme <- theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), panel.background = element_blank(), 
                 axis.line.x = element_line(colour = "black"), axis.line.y = element_line(colour = "black"), 
                 axis.text.x=element_text(size=15, colour='black'), axis.text.y=element_text(size=15, colour='black'), 
                 axis.title.x=element_text(size=18), axis.title.y=element_text(size=18), 
                 plot.title = element_text(size=22, hjust=.5, face='bold'),
                 legend.text=element_text(size=14))

chla <- melt(chla_output, id.vars=c("DateTime"))
chla$variable <- factor(chla$variable, levels=c('Baseline_Chla','Climate_Chla','LandUse_Chla','Climate_LandUse_Chla'), labels=c('Baseline','Climate','Land Use','Climate & Land Use'))

ggplot(chla, aes(y = value, x = DateTime, colour=variable))+ mytheme+ 
  geom_line(lwd=1) +
  scale_y_continuous(limits=c(0,100), breaks=seq(0,100,10)) +
  scale_x_datetime(date_breaks = '6 months',  date_labels = "%b-%Y") +
  labs(y= expression(Chlorophyll-a~~(ug~~L^-1)), x= "Date")+
  theme(legend.position=c(0,1), legend.justification = c(-.1,1), legend.key=element_blank(), legend.title=element_blank())

#### Example plots for PPT ####
# Synergy, additive, antagonistic
effects <- read.csv('./effects_example.csv')

eff <- melt(effects, id.vars=c("Type","DateTime"))
eff$variable <- factor(eff$variable, levels=c('Baseline_Chla','Climate_Chla','LandUse_Chla','Climate_LandUse_Chla'), 
                       labels=c('Baseline','Climate','Land Use','Climate & Land Use'))
eff$DateTime <- as.Date(eff$DateTime, format='%Y-%m-%d')
eff$DateTime <- as.POSIXct(eff$DateTime)

ggplot(subset(eff, Type=="additive"), aes(y = value, x = DateTime, colour=variable))+ mytheme+ 
  geom_line(lwd=1) +  ggtitle("Additive effects of \n climate and land use change") + 
  scale_x_datetime(date_breaks = '6 months',  date_labels = "%b-%Y") +
  labs(y= expression(Chlorophyll-a~~(ug~~L^-1)), x= "Date")+
  theme(legend.position=c(1,1), legend.justification = c(1,1), legend.key=element_blank(), legend.title=element_blank())

ggplot(subset(eff, Type=="antagon"), aes(y = value, x = DateTime, colour=variable))+ mytheme+ 
  geom_line(lwd=1) + ggtitle("Antagonistic effects of \n climate and land use change") + 
  scale_x_datetime(date_breaks = '6 months',  date_labels = "%b-%Y") +
  labs(y= expression(Chlorophyll-a~~(ug~~L^-1)), x= "Date")+
  theme(legend.position=c(1,1), legend.justification = c(1,1), legend.key=element_blank(), legend.title=element_blank())

ggplot(subset(eff, Type=="synergy"), aes(y = value, x = DateTime, colour=variable))+ mytheme+ 
  geom_line(lwd=1) + ggtitle("Synergistic effects of \n climate and land use change") + 
  scale_x_datetime(date_breaks = '6 months',  date_labels = "%b-%Y") +
  labs(y= expression(Chlorophyll-a~~(ug~~L^-1)), x= "Date")+
  theme(legend.position=c(1,1), legend.justification = c(1,1), legend.key=element_blank(), legend.title=element_blank())
