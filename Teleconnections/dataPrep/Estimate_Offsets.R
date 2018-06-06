pacman::p_load(tidyverse, lubridate, segmented)

# Visualize offsets for EDDIE lakes ####
data <- read_csv('./Teleconnections/dataPrep/AllLakes_annualTemp.csv', 
                 col_types = cols(.default = "c")) %>%
  mutate(MeanTemp = as.double(MeanTemp), Year = as.Date(Year, "%Y")) %>%
  mutate(Year = year(Year))

ggplot(subset(data, Type !='All'), aes(x = Year, y = MeanTemp, col = Type)) +
  geom_point() + 
  geom_smooth(method="lm", se=F) +
  facet_wrap(~Lake, ncol=2, scales="free")

ggplot(subset(data, Type != 'Neutral'), aes(x = Year, y = MeanTemp, col = Type)) +
  geom_point(data=subset(data, Type=='All'), col='black') + 
  geom_point(data=subset(data, Type=='ElNino'), col='red') +
  geom_point(data=subset(data, Type=='LaNina'), col='blue') +
  scale_color_manual(values=c('black','red','blue')) +
  geom_smooth(method="lm", se=F) +
  facet_wrap(~Lake, ncol=5, scales="free")

fits <- data %>%
  group_by(Lake, Type) %>%
  do(mod = lm(MeanTemp ~ Year, data=.)) %>%
  mutate (slope = summary(mod)$coeff[2], int = summary(mod)$coeff[1],
          R2 = summary(mod)$r.squared)

# Look at "since 1970" trends ####
recent <- data %>% 
  filter(Year >= 1970)

ggplot(subset(recent, Type =='Neutral' | Type =="ElNino"), aes(x = Year, y = MeanTemp, col = Type)) +
 # geom_point(data=subset(recent, Type=='All'), col='black') + 
  geom_point(data=subset(recent, Type=='ElNino'), col='red') +
  geom_point(data=subset(recent, Type=='Neutral'), col='black') +
  scale_color_manual(values=c('red','black')) +
  geom_smooth(method="lm", se=F)+
  facet_wrap(~Lake, ncol=5, scales="free_y") 

ggplot(subset(recent, Type =='Neutral' | Type =="ElNino"), aes(x = Year, y = MeanTemp, col = Type)) +
  # geom_point(data=subset(recent, Type=='All'), col='black') + 
  geom_point(data=subset(recent, Type=='ElNino'), col='red') +
  geom_point(data=subset(recent, Type=='Neutral'), col='black') +
  scale_color_manual(values=c('red','black')) +
  geom_smooth(method="lm", se=F)+
  facet_wrap(~Lake, ncol=5) 

ggplot(subset(recent, Type != "Neutral"), aes(x = Year, y = MeanTemp, col = Type)) +
  geom_point(data=subset(recent, Type=='All'), col='black') + 
  geom_point(data=subset(recent, Type=='ElNino'), col='red') +
  geom_point(data=subset(recent, Type=='LaNina'), col='blue') +
  scale_color_manual(values=c('black','red', 'blue')) +
  geom_smooth(method="lm", se=F)+
  facet_wrap(~Lake, ncol=5)

# Global offset data, from Guardian paper ####
global <- read_csv('./Teleconnections/dataPrep/global.csv')

ggplot(global, aes(x = Year, y = Temp, col=Type)) +
  geom_point(pch=16, cex=2) +
  scale_color_manual(values=c('red','blue','black','orange')) +
  geom_smooth(data=subset(global, Type!='Volcanic'),method='lm', se=F) +
  labs(y = "Global surface temperature change (C)")
