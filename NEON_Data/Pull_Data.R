# Attempt to pull lake data from NEON ####
pacman::p_load(neonUtilities, tidyverse)

setwd('./NEON_Data')

############### Download NEON data products for select sites ###############
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
                      site=       lakes,
                      startdate= "2014-10", 
                      enddate=   "2019-03")

chem_extLab <- as.data.frame(chem$swc_externalLabData) %>% 
  mutate(collectDate = as.POSIXct(collectDate), 
         NIT = waterNitrateAndNitriteN) %>% 
  rename(Lake = "siteID", Date = "collectDate", AMM = "waterAmmoniumN", 
         FRP = "waterOrthophosphateP", TN = "waterTotalNitrogen", 
         TDN = "totalDissolvedNitrogen", DIC = "dissolvedInorganicCarbon", 
         DOC = "dissolvedOrganicCarbon", TOC = "waterTotalOrganicCarbon", 
         TP = "waterTotalPhosphorus",  TDP = "totalDissolvedPhosphorus") %>% 
  select(Lake, namedLocation, Date, pH, DIC, DOC, TOC, TN, NIT, AMM, TDN, TP, FRP,
         TDP) %>% 
  write_csv(paste('./NEON_lake_chemistry_', format(Sys.Date(), "%Y%m%d"),
                  '.csv', sep=""), append=F)

chem_long <- chem_extLab %>% gather(var, value, pH:TDP)

# TN, TP time series plot
ggplot(subset(chem_long, var %in% c('TN', 'TP')), aes(x = Date, y = value, col=var)) +
  geom_line() + geom_point() +
  labs(y = expression(Concentration~(mg~L^-1))) +
  facet_wrap(.~Lake, scales='free_y')

# DOC/POC time series plot
ggplot(subset(chem_long, var %in% c('DOC', 'TOC')), aes(x = Date, y = value, col=var)) +
  geom_line() + geom_point() +
  labs(y = expression(Concentration~(mg~L^-1))) +
  facet_wrap(.~Lake, scales='free_y')

# Depth profile at specific depths (DP1.20254.001) ####
depths <- loadByProduct(dpID=     "DP1.20254.001", 
                      site=       lakes,
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
  write_csv(paste('./NEON_lake_profiles_', format(Sys.Date(), "%Y%m%d"),
                  '.csv', sep=""), append=F)

# Plot DO depth profiles
ggplot(depth_pro, aes(x = Date, y = Depth, col=DO)) +
  geom_point() +
  scale_y_reverse()+
  scale_colour_viridis_c(option = 'inferno') +
  facet_wrap(.~Lake, scales='free_y')

# Plot temp depth profiles
ggplot(depth_pro, aes(x = Date, y = Depth, col=Temp)) +
  geom_point() +
  scale_y_reverse()+
  scale_colour_viridis_c(option = 'inferno') +
  facet_wrap(.~Lake, scales='free_y')

# Dissolved gases in surface water (DP1.20097.001) ####
gas <- loadByProduct(dpID="DP1.20097.001", 
                      site= lakes,
                      startdate="2014-10", 
                      enddate="2019-03")

gas_extLab <- as.data.frame(gas$sdg_externalLabData) %>% 
  mutate(collectDate = as.POSIXct(collectDate)) %>% 
  separate(sampleID, into = c('lake','site','date','sample')) %>% 
  rename(Lake = "siteID", Date = "collectDate", CH4 = "concentrationCH4",
         CO2 = "concentrationCO2", N20 = "concentrationN2O") %>% 
  select(Lake, Date, sample, CH4, CO2, N20) %>% 
  write_csv(paste('./NEON_lake_gas_', format(Sys.Date(), "%Y%m%d"),
                  '.csv', sep=""), append=F)

gas_long <- gas_extLab %>% gather(var, ppm, CH4:N20)

# CH4 and CO2 plot
ggplot(subset(gas_long, var %in% c('CH4','CO2') & sample =='WAT'), 
       aes(x = Date, y = ppm, col=var)) +
  geom_point() +
  labs(y = expression(Concentration~(ppm))) +
  facet_wrap(var~Lake, scales='free_y')

# Gauge height (DP1.20267.001)

# Nitrate in surface water (DP1.20033.001)

# Secchi depth (DP1.20252.001)

# Temperature (PRT) in surface water (DP1.20053.001)

# Temperature at specific depth in surface water (DP1.20264.001)

# Water quality (DP1.20288.001)
wq <- loadByProduct(dpID="DP1.20288.001",
                    site= lakes,
                    startdate="2014-10", 
                    enddate="2019-03")