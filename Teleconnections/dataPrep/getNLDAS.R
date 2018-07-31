### Downloading NLDAS2 data for meteorological hourly forcing ####
### https://ldas.gsfc.nasa.gov/nldas/NLDAS2forcing.php
### Initial author: Hilary Dugan hilarydugan@gmail.com; 2017-01-20 

# Initial Setup ####
pacman::p_load(httr, lubridate, ncdf4, raster, RCurl, rgdal, tidyverse)

LakeName = 'Falling Creek'

dir <- paste("./Teleconnections/dataPrep/NLDAS/",LakeName, sep="") # Lake subfolder
setwd(dir)

# Enter Earthdata login (https://urs.earthdata.nasa.gov/profile)
username = "farrellk"
password = "careyLab18" # ENTER PASSWORD

# Define lake extent (lat/long bounding box) ####
#extent = c(-82.024262,	29.672799,	-82.004177,	29.692858) # Barco & Suggs
#extent = c(-99.272051,	47.114457,	-99.229132,	47.142362) # Prairie Pothole
#extent = c(-99.125881,	47.150278,	-99.101331,	47.16469) # Prairie Lake
#extent = c(-89.479431,	46.205431, -89.468591,	46.212411) # Crampton
extent = c(-79.83906,  37.30272, -79.83601,  37.30934) # Falling Creek
#extent = c(-89.709131, 45.994028, -89.697382, 46.000829) # Little Rock, WI
#extent = c(-149.635382, 68.623171, -149.582511, 68.642684) # Toolik

# Set timeframe ####
out = seq.POSIXt(as.POSIXct('2012-11-27 01:00',tz = 'GMT'),as.POSIXct('2013-12-31 23:00',tz='GMT'),by = 'hour')
vars = c('PEVAPsfc_110_SFC_acc1h', 'DLWRFsfc_110_SFC', 'DSWRFsfc_110_SFC', 'CAPE180_0mb_110_SPDY',
         'CONVfracsfc_110_SFC_acc1h', 'APCPsfc_110_SFC_acc1h', 'SPFH2m_110_HTGL',
         'VGRD10m_110_HTGL', 'UGRD10m_110_HTGL', 'TMP2m_110_HTGL', 'PRESsfc_110_SFC')

# Create output list of tables
output = list()

### Need to know how many cells your lake falls within ####
### Can download one instance of data and see how many columns there are
cellNum =4 #How many output cells will there be? Need to check this beforehand
for (l in 1:11){
  colClasses = c("POSIXct", rep("numeric",cellNum))
  col.names = c('dateTime',rep(vars[l],cellNum))
  output[[l]] = read.table(text = "",colClasses = colClasses,col.names = col.names)
  attributes(output[[l]]$dateTime)$tzone = 'GMT'
}

### Run hourly loop ####
for (i in 1:length(out)) {
  print(out[i])
  yearOut = year(out[i])
  monthOut = format(out[i], "%m")
  dayOut = format(out[i], "%d")
  hourOut = format(out[i], "%H%M")
  doyOut = format(out[i],'%j')
  
  filename = format(out[i], "%Y%m%d%H%M")
  
  URL3 = paste('https://',username,':',password,'@hydro1.gesdisc.eosdis.nasa.gov/daac-bin/OTF/HTTP_services.cgi?',
               'FILENAME=%2Fdata%2FNLDAS%2FNLDAS_FORA0125_H.002%2F',yearOut,'%2F',doyOut,'%2FNLDAS_FORA0125_H.A',yearOut,monthOut,dayOut,'.',hourOut,'.002.grb&',
               'FORMAT=bmV0Q0RGLw&BBOX=',extent[2],'%2C',extent[1],'%2C',extent[4],'%2C',extent[3],'&',
               'LABEL=NLDAS_FORA0125_H.A',yearOut,monthOut,dayOut,'.',hourOut,'.002.2017013163409.pss.nc&',
               'SHORTNAME=NLDAS_FORA0125_H&SERVICE=SUBSET_GRIB&VERSION=1.02&DATASET_VERSION=002',sep='')
  
  library(httr)
  x = download.file(URL3,destfile = paste(filename,'.nc',sep=''),mode = 'wb',quiet = T)
  
  for (v in 1:11) {
    br = brick(paste(filename,'.nc',sep=''),varname = vars[v])
    output[[v]][i,1] = out[i]
    output[[v]][i,-1] = getValues(br[[1]])
  }
  rm(br)
  #Sys.sleep(2)
}

### Save all 11 variables from the output list ####
for (i in 1:length(out)) {
  print(out[i])
  filename = format(out[i], "%Y%m%d%H%M")
  for (v in 1:11) {
    br = brick(paste(filename,'.nc',sep=''),varname = vars[v])
    output[[v]][i,1] = out[i]
    output[[v]][i,-1] = getValues(br[[1]])
  }
  rm(br)
}

for (f in 1:11){
  write.csv(output[[f]],paste(LakeName,'_',vars[f],'.csv',sep=''),row.names=F)
}
