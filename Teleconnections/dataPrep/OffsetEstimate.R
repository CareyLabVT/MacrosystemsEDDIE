pacman::p_load(writexl, readxl, tidyverse, lubridate)

ElNino_Years <- c(1957,1965,1972,1982,1983,1987,1991,1992,1993,1997,1998,2002,2015,2016)

LaNina_Years <- c(1950,1954,1955,1956,1962,1964,1970,1971,1973,1974,1975,1988,1999,2010,2011)

Neutral_Years <- c(1951,1952,1953,1958,1959,1960,1961,1963,1966,1967,1968,1969,1976,
                   1977,1978,1979,1980,1981,1984,1985,1986,1989,1990,1994,1995,1996,
                   2000,2001,2003,2004,2005,2006,2007,2008,2009,2012,2013,2014,2017)

LakeName = 'Mendota'

historical <- read_excel('./Teleconnections/Lake_Characteristics.xlsx', sheet = LakeName) %>%
    mutate(Type = ifelse(Year %in% ElNino_Years, "ElNino", 
                         ifelse(Year %in% LaNina_Years, "LaNina", "Neutral"))) %>%
  write_xlsx('./Teleconnections/dataPrep/Lake_Mendota.xlsx', col_names=TRUE)