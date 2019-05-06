# Pull lake data from NEON ####
pacman::p_load(neonUtilities, tidyverse)

setwd('./NEON_Data')

# Download NEON data products for select sites
# NEON Lakes are: Barco (BARC)
#                 Crampton (CRAM)
#                 Little Rock Lake (LIRO)
#                 Prairie Lake (PRLA)
#                 Prairie Pothole (PRPO) 
#                 Suggs (SUGG)
#                 Toolik (TOOK)

lakes <- c("BARC", "CRAM", "LIRO", "PRLA", "PRPO", "SUGG", "TOOK")

# Chemical properties of surface water (DP1.20093.001) ####
chem <- loadByProduct(dpID=      "DP1.20093.001", 
                      site=      "TOOK",
                      startdate= "2014-10", 
                      enddate=   "2019-03")

chem_extLab <- as.data.frame(chem$swc_externalLabData) %>% 
  mutate(Date = as.POSIXct(collectDate),
         NIT = waterNitrateAndNitriteN) %>% 
  rename(Lake = "siteID", AMM = "waterAmmoniumN", 
         FRP = "waterOrthophosphateP", TN = "waterTotalNitrogen", 
         TDN = "totalDissolvedNitrogen", DIC = "dissolvedInorganicCarbon", 
         DOC = "dissolvedOrganicCarbon", TOC = "waterTotalOrganicCarbon", 
         TP = "waterTotalPhosphorus",  TDP = "totalDissolvedPhosphorus") %>% 
  select(Lake, namedLocation, Date, pH, DIC, DOC, TOC, TN, NIT, AMM, TDN, TP, FRP,
         TDP) %>% 
  mutate(Date = as.Date(Date)) %>% 
  write_csv(paste('./NEON_lake_chemistry_', format(Sys.Date(), "%Y%m%d"),
                  '.csv', sep=""), append=F)

chem_long <- chem_extLab %>% gather(var, value, pH:TDP) %>% 
  mutate(Date = as.Date(Date))

# TN, TP time series plot
ggplot(subset(chem_long, var %in% c('TN', 'TP')), aes(x = Date, y = value, col=var)) +
  geom_line() + geom_point() +
  scale_x_date(date_breaks = '2 months', date_labels = "%b-%Y")+
  labs(y = expression(Concentration~(mg~L^-1))) +
  facet_wrap(.~Lake, scales='free_y') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# DOC/TOC time series plot
ggplot(subset(chem_long, var %in% c('DOC', 'TOC')), aes(x = Date, y = value, col=var)) +
  geom_line() + geom_point(size=2) +
  #scale_y_continuous(limits=c(0,15)) +
  scale_x_date(date_breaks = '2 months', date_labels = "%b-%Y")+
  labs(y = expression(Concentration~(mg~L^-1))) +
  facet_wrap(.~Lake, scales='free_y') +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Depth profile at specific depths (DP1.20254.001) ####
depths <- loadByProduct(dpID=    "DP1.20254.001", 
                      site=      "TOOK",
                      startdate= "2014-10", 
                      enddate=   "2019-03")

View(depths$variables)

depth_pro <- as.data.frame(depths$dep_profileData) %>% 
  mutate(date = as.POSIXct(date)) %>% 
  rename(Lake = "siteID", Date = "date", Depth = "sampleDepth", Temp = "waterTemp",
         spCond = "specificConductance", DO = "dissolvedOxygen", 
         DOsat = "dissolvedOxygenSaturation") %>% 
  filter(DO <= 15) %>% 
  select(Lake, namedLocation, Date, Depth:DOsat) %>% 
  mutate(Date = as.POSIXct(Date)) %>% 
  write_csv(paste('./NEON_lake_profiles_', format(Sys.Date(), "%Y%m%d"),
                  '.csv', sep=""), append=F)

depth_long <- depth_pro %>% 
  gather(var, value, Temp:DOsat) %>% 
  mutate(Date = as.POSIXct(Date))

# Plot depth profiles
ggplot(depth_long, aes(x = Date, y = value, col=Depth)) +
  geom_point() +
  scale_x_datetime(date_breaks = '2 months', date_labels = "%b-%Y")+
  scale_y_reverse()+
  facet_wrap(var~., scales='free_y')+
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
