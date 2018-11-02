library(maps)
map('world', xlim=c(-180,90), ylim=c(10,90), col = 'grey90', fill = T,border = 'grey50',lwd=0.3)
map('state', col = 'grey90', fill = T,border = 'grey50',lwd=0.3, add=T)
map('world', regions=c('Ireland'), add=T, col = 'dodgerblue', fill=T)
map('state', regions=c('virginia','new york','connecticut','maine','illinois'), add=T, col = 'dodgerblue', fill=T)


latitude <- c(41.89715, 41.73846, 39.51052, 37.22896, 37.22896, 44.56391)
longitude <- c(-87.628088,-74.084908,-84.731445,-80.425219,-80.425219,-69.663505) 

par(mar = c(0,0,0,0),mgp=c(0,0,0))
maps::map('world', regions=c('Canada','USA'), xlim=c(-170,-40), ylim=c(28,85), 
          col = 'grey90', fill = T,
          border = 'grey50',lwd=1)
points(longitude, latitude,col='black', pch=18, cex=2)




# Web tutorial ####
pacman::p_load(ggplot2, mapdata, maptools)

latitude <- c(44.204599, 45.2347)
longitude <- c(-76.852, -72.835) 

sites <- as.data.frame(latitude)
sites$longitude <- longitude

ggplot() + 
  geom_polygon(data = map_data("usa"), aes(x=long, y = lat, group = group), 
                                 fill = "white", color="black") +
  geom_polygon(data = map_data("worldHires", "Canada"), aes(x=long, y = lat, group = group), 
               fill = "white", color="black") + 
  coord_fixed(xlim = c(-90, -65),  ylim = c(40, 50), ratio = 1.2) +
  geom_point(data=sites, aes(x=longitude, y=latitude), fill='red', color = "black", 
             shape=21, size=5.0) + 
  labs(x= "Longitude", y = "Latitude")
