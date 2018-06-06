library(tidyverse)

data <- read_csv('./Teleconnections/dataPrep/AllLakes_annualTemp.csv')

fits <- data %>%
  group_by(Lake, Type) %>%
  do(mod = lm(MeanTemp ~ Year, data=.)) %>%
  mutate (slope = summary(mod)$coeff[2], int = summary(mod)$coeff[1],
          R2 = summary(mod)$r.squared)

View(fits)

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
