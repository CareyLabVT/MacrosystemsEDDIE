# Pull lake gas data from NEON ####
pacman::p_load(neonUtilities, neonDissGas, tidyverse)

setwd('./NEON_Data')

# NEON Lakes are: Barco (BARC)
#                 Crampton (CRAM)
#                 Little Rock Lake (LIRO)
#                 Prairie Lake (PRLA)
#                 Prairie Pothole (PRPO) 
#                 Suggs (SUGG)
#                 Toolik (TOOK)

lakes <- c("BARC", "CRAM", "LIRO", "PRLA", "PRPO", "SUGG", "TOOK")

# Dissolved gases in surface water (DP1.20097.001) ####
filepath <- "C:/Users/KJF/Desktop/R/MacrosystemsEDDIE/NEON_Data/lake_gas"
dataFromAPI <- zipsByProduct(dpID="DP1.20097.001", 
                             site= "TOOK",
                             startdate="2014-10", 
                             enddate="2019-03",
                             package="expanded",
                             check.size=F,
                             savepath = filepath)

stackByTable(filepath=paste(filepath,"filesToStack20097",sep = "/"), folder = T)

sdgFormatted <- def.format.sdg(dataDir = paste0(filepath,"/filesToStack20097"))

sdgDataPlusConc <- def.calc.sdg.conc(inputFile = sdgFormatted)

Toolik_gas <- sdgDataPlusConc %>% 
  select(waterSampleID, collectDate, stationID, dissolvedCO2, dissolvedCH4) %>% 
  mutate(collectDate = as.POSIXct(collectDate)) %>% 
  separate(stationID, into = c('lake','AOS','site', 'depth')) %>% 
  mutate(Date = as.Date(collectDate),
         CO2_mmolm3 = round(dissolvedCO2*1000000,2), 
         CH4_mmolm3 = round(dissolvedCH4*1000000,4)) %>% 
  select(lake, Date, site, depth, CO2_mmolm3, CH4_mmolm3) %>% 
  write_csv('./Toolik_gas_mmolm3.csv')

gas_long <- Toolik_gas %>% 
  gather(var, value, CO2_mmolm3:CH4_mmolm3) %>% 
  mutate(Date = as.POSIXct(Date))

# CH4 and CO2 plot
ggplot(subset(gas_long, site =='buoy'), 
       aes(x = Date, y = value, col=var)) +
  geom_point(size=3) + geom_line() +
  scale_x_datetime(date_breaks = '6 months', date_labels = "%b-%Y")+
  labs(y = expression(Concentration~(mmol~m^-3))) +
  facet_wrap(var~depth, scales='free_y')+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
