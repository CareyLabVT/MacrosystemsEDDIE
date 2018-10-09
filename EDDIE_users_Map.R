# install.packages('pacman')
pacman::p_load(maps, ggmap, mapproj, tidyverse)

tester_names <- c('Arrupe', 'Colby', 'Dundalk', 'Fairfield', 
                  'Georgetown', 'Longwood', 'Michigan State', 'SUNY-New Paltz',
                  'Miami OH', 'VT', 'WSU')
tester_states <- c('Illinois','Maine','Connecticut','Virginia','Michigan','New York',
                   'Ohio','Washington', 'Washington DC')

sites <- read_csv('./UsersLatLong.csv')

# Ugly world slice to include Ireland ####
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('world', xlim=c(-180,90), ylim=c(10,90), col = 'grey90', fill = T,
          interior=F, border = 'grey50',lwd=0.3)
maps::map('state', col = 'grey90', fill = T,border = 'grey50',lwd=0.3, add=T)
maps::map('world', regions=c('Ireland'), add=T, col = 'dodgerblue', fill=T)
maps::map('state', regions=c('virginia','ohio', 'new york','illinois', 'washington', 'maine'), add=T, col = 'dodgerblue', fill=T)
maps::map('state', regions=c('virginia','connecticut', 'washington dc'), 
          add=T, col = 'tomato', fill=T) # Module 2

# US only
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('state', col = 'grey90', fill = T,border = 'grey50',lwd=0.3)
maps::map('state', regions=c('virginia','ohio', 'new york','illinois', 'washington', 'maine'), 
          add=T, col = 'dodgerblue', fill=T) # Module 1
maps::map('state', regions=c('virginia','connecticut', 'washington dc'), 
          add=T, col = 'tomato', fill=T) # Module 2

# All testers to date for ESA ####
US_sites <- sites %>% filter(School != "Dundalk")
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('state', col = 'grey90', fill = T,border = 'grey50',lwd=0.3)
maps::map('state', regions= tester_states, 
          add=T, col = 'dodgerblue', fill=T)
points(US_sites$Longitude, US_sites$Latitude,col='black', pch=18, cex=2,lwd=1)

Ireland <- sites %>% filter(School == 'Dundalk')
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('world', regions=c('Ireland', 'UK'), col = 'grey90', fill = T,
          border = 'grey50',lwd=0.3)
maps::map('world', regions = c('Ireland'), col= 'dodgerblue', fill= T, add=T)
points(Ireland$Longitude, Ireland$Latitude,col='black', pch=18, cex=2,lwd=1)
