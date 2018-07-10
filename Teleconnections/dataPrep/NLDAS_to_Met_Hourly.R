### Format NLDAS output into GLM-friendly format
pacman::p_load(tidyverse, lubridate)
options(scipen=999)

LakeName = 'Prairie Lake'
source <- paste('C:/Users/KJF/Desktop/R/MacrosystemsEDDIE/Teleconnections/dataPrep/NLDAS/',LakeName, '/',sep='')
glm_dir <- paste('./Teleconnections/Lakes/',LakeName, '/', sep='')

# Pull files and select/rename columns for met_hourly ####
shortwave <- read_csv(paste(source,LakeName,"_DSWRFsfc_110_SFC.csv", sep="")) %>% #DSWRF = shortwave radiation flux downwards (surface) [W/m2]
  select(dateTime, DSWRFsfc_110_SFC) %>% rename(ShortWave = DSWRFsfc_110_SFC)

longwave <- read_csv(paste(source,LakeName,"_DLWRFsfc_110_SFC.csv", sep="")) %>% #DLWRF = longwave radiation flux downwards (surface) [W/m2] 
  select(dateTime, DLWRFsfc_110_SFC) %>% rename(LongWave = DLWRFsfc_110_SFC)

AirTemp <- read_csv(paste(source,LakeName,"_TMP2m_110_HTGL.csv", sep="")) %>% #TMP = 2 m aboveground temperature [K]
  mutate(temp.dC = TMP2m_110_HTGL-273.15) %>% # Calculate in degrees C
  select(dateTime, temp.dC) %>% rename(AirTemp = temp.dC)

RelHum <- (read_csv(paste(source,LakeName,"_PRESsfc_110_SFC.csv", sep="")) %>% #PRES = surface Pressure [Pa]
             mutate(pressure.mb = PRESsfc_110_SFC/100) %>%
             select(dateTime, pressure.mb)) %>%
  left_join(read_csv(paste(source,LakeName,"_SPFH2m_110_HTGL.csv", sep="")) %>% #SPFH = 2 m aboveground Specific humidity [kg/kg]
              select(dateTime, SPFH2m_110_HTGL) %>% rename(specific.humidity = SPFH2m_110_HTGL)) %>%
  left_join(AirTemp) %>%
  mutate (RelHum = (specific.humidity * pressure.mb / (0.378 * specific.humidity + 0.622)) / 
            (6.112 * exp((17.67 * AirTemp)/(AirTemp + 243.5)))) %>%
  mutate(RelHum = ifelse(RelHum > 1, 1, 
                         ifelse(RelHum < 0, 0, RelHum))) %>%
  select(dateTime, RelHum)

windSpeed <- read_csv(paste(source,LakeName,"_UGRD10m_110_HTGL.csv", sep="")) %>% #UGRD = 10 m aboveground Zonal wind speed [m/s]
  select(dateTime, UGRD10m_110_HTGL) %>% 
  left_join(read_csv(paste(source,LakeName,"_VGRD10m_110_HTGL.csv", sep="")) %>% #VGRD = 10 m aboveground Meridional wind speed [m/s]
              select(dateTime, VGRD10m_110_HTGL)) %>%
  mutate(WindSpeed = sqrt(UGRD10m_110_HTGL^2 + VGRD10m_110_HTGL^2)) %>% # wind speed (m/s)
  select(dateTime, WindSpeed)

precip <- read_csv(paste(source,LakeName,"_APCPsfc_110_SFC_acc1h.csv", sep="")) %>% #APCP = precipitation hourly total [kg/m2]
  mutate(precip.m.day=APCPsfc_110_SFC_acc1h/1000*24) %>%
  select(dateTime, precip.m.day) %>% rename(Rain = precip.m.day)

## Other Files: 
#LakeName_PEVAPsfc_110_SFC_acc1h #PEVAP = potential evaporation hourly total [kg/m2]
#LakeName_CAPE180_0mb_110_SPDY #CAPE = 180-0 mb above ground Convective Available Potential Energy [J/kg]
#LakeName_CONVfracsfc_110_SFC_acc1h #CONVfrac = fraction of total precipitation that is convective [unitless]

# Build GLM-style dataframe of met variables ####
met <- shortwave %>% 
  left_join(longwave) %>% 
  left_join(AirTemp) %>% 
  left_join(RelHum) %>%
  left_join(windSpeed) %>%
  left_join(precip) %>%
  rename(time = dateTime) %>%
  mutate(Snow = 0, time = lubridate::ymd_hms(time)) %>%
  write.csv(file.path(glm_dir, "met_hourly.csv"), row.names = F)
