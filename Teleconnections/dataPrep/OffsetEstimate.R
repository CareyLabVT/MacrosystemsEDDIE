pacman::p_load(readxl, tidyverse, lubridate)

el_nino <- c(1900, 1903, 1906, 1915, 1919, 1926, 1931, 1941, 1942, 1958, 
             1966, 1973, 1978, 1980, 1983, 1987, 1988, 1992, 1995, 1998, 
             2003, 2007, 2010, 2015)
la_nina <- c(1904, 1909, 1910, 1911, 1917, 1918, 1925, 1934, 1939, 1943,
             1950, 1951, 1955, 1956, 1962, 1971, 1974, 1976, 1989, 1999, 
             2000, 2008, 2011, 2012)

LakeName = 'Mendota'

historical <- read_excel('./Teleconnections/Lake_Characteristics.xlsx', sheet = LakeName) %>%
    mutate(Type = ifelse(Year %in% el_nino, "ElNino", 
                         ifelse(Year %in% la_nina, "LaNina", "Neutral")))

ggplot(historical, aes(x = Year, y = `Air Temp Mean (°C)`, group = type, col = type)) +
  geom_point() + geom_line() + #geom_smooth(method = 'lm', se= F) + 
  scale_y_continuous(limits = c(15,25))

ggplot(historical, aes(x = Year, y = `Rain (mm)`, group = type, col = type)) +
  geom_point() + #geom_smooth(method = 'lm', se= F)
  geom_line()


events <- read_excel('./Teleconnections/Lake_Characteristics.xlsx', sheet = "Events") %>%
  select(-Rank) %>%
  gather(Index, Year, DJF:NDJ) %>%
  distinct(Year)
