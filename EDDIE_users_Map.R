# install.packages('pacman')
pacman::p_load(maps, ggmap, mapproj)

# Ugly world slice to include Ireland
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



map <- get_map(location = 'Europe', zoom = 4)
ggmap(map)
