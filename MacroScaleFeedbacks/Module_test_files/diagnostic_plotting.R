# Diagnostic plotting for MSF ####
pacman::p_load(tidyverse)

mytheme <- theme(panel.grid.major = element_blank(), 
                 panel.grid.minor = element_blank(), 
                 panel.background = element_rect(fill = 'white', colour = 'black'), 
                 legend.background = element_blank(),
                 legend.box.background = element_blank(),
                 legend.key=element_blank(),
                 axis.line.x = element_line(colour = "black"), 
                 axis.line.y = element_line(colour = "black"), 
                 axis.text.x = element_text(size=10, colour = "black"), 
                 axis.text.y = element_text(size=10, colour='black'), 
                 axis.title.x=element_text(size=10), 
                 axis.title.y=element_text(size=10),
                 legend.title.align=0.5, legend.text.align=1,
                 legend.title = element_text(size=14, colour='black'),
                 legend.text = element_text(size=12, colour='black'))


# Load data from baseline, plus 2/4/6 scenarios, both lakes ####
mendota <- full_join((read_csv('./MacroScaleFeedbacks/Mendota/ch4model_output_all.csv')),
                      (read_csv('./MacroScaleFeedbacks/Mendota/co2model_output_all.csv'))) %>% 
  mutate(Lake = "Mendota")

sunapee <- full_join((read_csv('./MacroScaleFeedbacks/Sunapee/ch4model_output_all.csv')),
                     (read_csv('./MacroScaleFeedbacks/Sunapee/co2model_output_all.csv'))) %>% 
  mutate(Lake = "Sunapee")

toolik <- full_join((read_csv('./MacroScaleFeedbacks/Toolik/ch4model_output_all.csv')),
                     (read_csv('./MacroScaleFeedbacks/Toolik/co2model_output_all.csv'))) %>% 
  mutate(Lake = "Toolik")

data <- bind_rows(mendota, sunapee) %>% 
  bind_rows(., toolik) %>% 
  group_by(Lake, DateTime) %>% 
  gather(sim, value, Baseline_CH4:Plus6_CO2) %>% 
  separate(sim, into = c('sim','var'), sep = "_") %>% 
  mutate(surfarea = ifelse(Lake == "Mendota", 39866000, 
                           ifelse(Lake == "Sunapee", 16934251.6,
                                  ifelse(Lake == "Toolik", 12602474.26, NA))))

# Annual sums of fluxes; kg/yr ####
annual <- data %>% 
  group_by(Lake, surfarea, sim, var) %>% 
  summarize(sum = sum(value)) %>% 
  mutate(kgm2 = ifelse(var == "CO2", (sum*44.01/1000000),(sum*16.04/1000000)),
         kgyr = kgm2 * surfarea)

# Calculate GWP for CH4, CO2 in CO2 equivalents ####
GWP <- annual %>% 
        mutate(GWP = ifelse(var == "CH4", kgyr*86, kgyr)) %>% 
  select(Lake:var, GWP) %>% 
  spread(var,GWP) %>% 
  mutate(GWP_sum = CH4 + CO2)

# Time series flux plots, all scenarios ####
ggplot(data, aes(x = DateTime, y = value, col=as.factor(sim), lty=var))+ 
  geom_line(lwd=.5) + mytheme +
  geom_hline(yintercept = 0, lty=2, lwd=1, col='black')+
  facet_grid(Lake~sim) + 
  labs(y = "Flux (mmol/m2/d)")

# Bar plots 
ggplot(annual, aes(x = sim, y = kgyr, fill=var)) +
  geom_bar(stat="identity") +
  facet_grid(.~Lake) +
  geom_hline(yintercept = 0, col='black', lty=2, lwd=1) +
  ggtitle("Annual emissions, kg")

# GWP bar plots across scenarios
ggplot(GWP, aes(x = sim, y = GWP_sum, fill=as.factor(sim), group=Lake)) +
  geom_bar(stat="identity") +
  facet_grid(.~Lake, scales='free_y') +
  geom_hline(yintercept = 0, col='black', lty=2, lwd=1) +
  ggtitle("Annual GWP, kg CO2 equivalents") 
