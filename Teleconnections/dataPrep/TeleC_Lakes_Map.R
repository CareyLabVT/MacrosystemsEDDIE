# Map of lakes included in Teleconnections Module

# install.packages('pacman')
pacman::p_load(maps, readxl, dplyr)

data <- read_excel('./Teleconnections/Lake_Characteristics.xlsx') %>%
  mutate(Offset = c(1.27, 2.81, 1.09, 1.91, 1.55, 3.79, 1.27, 6.33)) 

# NEON + other lake sites on US map ####
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map("world", c("USA", "alaska"), xlim=c(-180,-65), ylim=c(19,72), col='grey90',
          fill=T, border='grey50', wrap=T,lwd=0.3) # background USA map
maps::map('state', region=c('florida', 'new hampshire','wisconsin','north dakota'), 
    add = T, border='grey50',col='lightblue', fill=T, lwd=0.5) # States from conterminous US
maps::map("world", c("USA:Alaska"), add = T, border='grey50',col='lightblue', fill=T, lwd=0.5) # Alaska
maps::map("world", c("USA:Hawaii"), add = T, border='white',col='white', fill=T, lwd=0.5) # Hide Hawaii
points(data$Longitude,data$Latitude,col='black', pch=16, cex=1,lwd=1)
text(data$Longitude, data$Latitude, data$`Lake Name`,cex=1, font=2, pos=c(3,3, 1,1,1,1,1,1,1))


# Just Conterminous sites.
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('usa', col='grey90',fill=T, border='grey50', wrap=T,lwd=0.3) # background USA map
maps::map('state', region=c('florida', 'new hampshire','wisconsin','north dakota', 'virginia'), 
          add = T, border='grey50',col='lightblue', fill=T, lwd=0.5) # States from conterminous US
points(data$Longitude,data$Latitude,col='black', pch=16, cex=1,lwd=1)
#text(data$Longitude, data$Latitude, data$Offset)
text(data$Longitude, data$Latitude, data$`Lake Name`, cex=1, font=2,
     pos=c(4,1,1,1,1,3,3,4,1))
# pos values 1 = below, 2 = left, 3 = above, 4 = right

# State-specific maps ####
# Wisconsin
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('state', region=c('wisconsin'), lwd=2)
points(data$Longitude,data$Latitude, cex=1.5,lwd=1, pch=16, col='black')
text(c(-88.52, -89.1, -89), c(42.9, 45.9, 46.3), c("Mendota", "Little Rock", "Crampton"))

# Florida
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('state', region=c('florida'), lwd=2)
points(data$Longitude,data$Latitude, cex=1.5,lwd=1, pch=16, col='black')
# Add text for site names

# North Dakota
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('state', region=c('north dakota'), lwd=2)
points(data$Longitude,data$Latitude, cex=1.5,lwd=1, pch=16, col='black')
# Add text for site names

# New Hampshire
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('state', region=c('new hampshire'), lwd=2)
points(data$Longitude,data$Latitude, cex=1.5,lwd=1, pch=16, col='black')
# Add text for site names

# Alaska
par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map("world", c("USA:Alaska"), lwd=2)
points(data$Longitude,data$Latitude, cex=1.5,lwd=1, pch=16, col='black')
# Add text for site names