# Map of lakes included in Macroscale Feedbacks Module

# install.packages('pacman')
pacman::p_load(maps, readxl, dplyr)

data <- read_excel('./MacroScaleFeedbacks/Lake_Characteristics.xlsx') 

# NEON + other lake sites on US map ####
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map("world", c("USA", "alaska"), xlim=c(-180,-65), ylim=c(19,72), col='grey90',
          fill=T, border='grey50', wrap=T,lwd=0.3) # background USA map
maps::map('state', region=c('virginia', 'new hampshire','wisconsin'), 
    add = T, border='grey50',col='lightblue', fill=T, lwd=0.5) # States from conterminous US
maps::map("world", c("USA:Alaska"), add = T, border='grey50',col='lightblue', fill=T, lwd=0.5) # Alaska
maps::map("world", c("USA:Hawaii"), add = T, border='white',col='white', fill=T, lwd=0.5) # Hide Hawaii
points(data$Longitude,data$Latitude,col='black', pch=16, cex=1,lwd=1)
text(data$Longitude, data$Latitude, data$`Lake Name`,
     cex=1, font=2, pos=c(1,2,4,1))
# FCR, Mendota, Sunapee, Toolik

# Just Conterminous sites.
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('usa', col='grey90',fill=T, border='grey50', wrap=T,lwd=0.3) # background USA map
maps::map('state', region=c('virginia', 'new hampshire','wisconsin'), 
          add = T, border='grey50',col='lightblue', fill=T, lwd=0.5) # States from conterminous US
points(data$Longitude,data$Latitude,col='black', pch=16, cex=1,lwd=1)
text(data$Longitude, data$Latitude, data$`Lake Name`,
     cex=1, font=2, pos=c(1,1,1), offset=c(.8,.8,.8))
# pos: 1,2,3,4 for below, left, above, right

# Just Alaska
ak <- subset(data, State == 'Alaska')
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map("world", c("USA:Alaska"), xlim=c(-180,-65), ylim=c(19,72), col='lightblue',
          fill=T, border='grey50', wrap=T,lwd=0.3) # background USA map
points(ak$Longitude,ak$Latitude,col='black', pch=16, cex=1,lwd=1)
text(ak$Longitude, ak$Latitude, ak$`Lake Name`,
     cex=1, font=2, pos=c(1,1,1), offset=c(.8,.8,.8))