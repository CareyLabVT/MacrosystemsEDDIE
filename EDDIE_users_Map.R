#### Plot MacroEDDIE users by site ####
# install.packages('pacman')
pacman::p_load(maps, tidyverse)

sites <- read_csv('./UsersLatLong.csv')

#### Sites including pre/post tests (student data) only ####
## USA
test_sites <- sites %>% filter(Country=="USA", Assessed=="Yes")
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('state', col = 'grey90', fill = T,border = 'black',lwd=1)
maps::map('state', regions= test_sites$State,add=T, col = 'dodgerblue', fill=T)
points(test_sites$Longitude, test_sites$Latitude,col='black', pch=18, cex=2,lwd=1)

## Europe
Europe <- sites %>% filter(Country %in% c('Ireland','Switzerland','Spain'), Assessed=="Yes")
euro <- c('Albania','Andorra','Armenia','Austria','Azerbaijan','Belarus','Belgium',
          'Bosnia','Bulgaria','Croatia','Cyprus','Czech Republic','Denmark','Estonia',
          'Finland','France','Georgia','Germany','Greece','Hungary','Iceland','Ireland',
          'Italy','Kazakhstan','Kosovo','Latvia','Liechtenstein','Lithuania','Luxembourg',
          'Macedonia','Malta','Moldova','Monaco','Montenegro','Netherlands','Norway',
          'Poland','Portugal','Romania','Russia','San Marino','Serbia','Slovakia',
          'Slovenia','Spain','Sweden','Switzerland','Turkey','Ukraine','UK')

par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('world',ylim=c(30,70), xlim=c(-10.75,27), col='transparent') #blank to avoid partial borders
maps::map('world', regions=euro, col='grey90', fill=T,border='grey50',lwd=1, 
          xlim=c(-12,27)+c(-1,1), ylim=c(30,68)+c(-2,2))
maps::map('world', regions = Europe$Country, col= 'dodgerblue', fill= T, add=T)
points(Europe$Longitude, Europe$Latitude,col='black', pch=18, cex=2,lwd=1)

#### Include informal (non-assessment) testers ####
## USA
US_sites <- sites %>% filter(Country=="USA")
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('state', col = 'grey90', fill = T,border = 'black',lwd=1)
maps::map('state', regions= sites$State,add=T, col = 'dodgerblue', fill=T)
points(US_sites$Longitude, US_sites$Latitude,col='black', pch=18, cex=2,lwd=1)

## Europe
Europe <- sites %>% filter(Country %in% c('Ireland','Switzerland','Spain'))
euro <- c('Albania','Andorra','Armenia','Austria','Azerbaijan','Belarus','Belgium',
          'Bosnia','Bulgaria','Croatia','Cyprus','Czech Republic','Denmark','Estonia',
          'Finland','France','Georgia','Germany','Greece','Hungary','Iceland','Ireland',
          'Italy','Kazakhstan','Kosovo','Latvia','Liechtenstein','Lithuania','Luxembourg',
          'Macedonia','Malta','Moldova','Monaco','Montenegro','Netherlands','Norway',
          'Poland','Portugal','Romania','Russia','San Marino','Serbia','Slovakia',
          'Slovenia','Spain','Sweden','Switzerland','Turkey','Ukraine','UK')

par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('world',ylim=c(30,70), xlim=c(-10.75,27), col='transparent') #blank to avoid partial borders
maps::map('world', regions=euro, col='grey90', fill=T,border='grey50',lwd=1, 
          xlim=c(-12,27)+c(-1,1), ylim=c(30,68)+c(-2,2))
maps::map('world', regions = Europe$Country, col= 'dodgerblue', fill= T, add=T)
points(Europe$Longitude, Europe$Latitude,col='black', pch=18, cex=2,lwd=1)

#### World slice to include USA + European sites ####
nonUS <- sites %>% filter(Country != 'USA')

ylim = c(25,75)
xlim = c(-140,50)

par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('world',ylim=ylim, xlim=xlim, col='transparent') #blank to avoid partial borders
maps::map('world', border='grey50', col='grey90', fill=T,
          xlim=xlim+c(-2,2), ylim=ylim+c(-2,2))
maps::map('world', regions= nonUS$Country, add=T, fill=T, col='dodgerblue')
maps::map('state', add=T, fill=T, lwd=0.3, border='grey50', col='grey90')
maps::map('state', regions=sites$State, add=T, col='dodgerblue', fill=T)
#points(sites$Longitude, sites$Latitude,col='black', pch=18, cex=1.25,lwd=1)

#### World slice to include USA + European + Asia + Australia sites ####
nonUS <- sites %>% filter(Country != 'USA')

ylim = c(-50,75)
xlim = c(-140,1200)

par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('world',ylim=ylim, xlim=xlim, col='transparent') #blank to avoid partial borders
maps::map('world', border='grey50', col='grey90', fill=T,
          xlim=xlim+c(-2,2), ylim=ylim+c(-2,2))
maps::map('world', regions= nonUS$Country, add=T, fill=T, col='dodgerblue')
maps::map('state', add=T, fill=T, lwd=0.3, border='grey50', col='grey90')
maps::map('state', regions=sites$State, add=T, col='dodgerblue', fill=T)
points(sites$Longitude, sites$Latitude,col='black', pch=18, cex=1.25,lwd=1)
