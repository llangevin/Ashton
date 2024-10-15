#Reading 'https://ashtonrestaurants.ca/succursales' to get geolocalization of Ashton restos

#Sys.getlocale()
Sys.setlocale("LC_ALL", 'en_US.UTF-8')
#Sys.getenv()
Sys.setenv(LANG = "en")
#sessionInfo()

# clear workspace
rm(list = ls())

#Github repo
#https://github.com/llangevin/Ashton.git
#git remote add origin https://github.com/llangevin/Ashton.git
#git branch -M main
#git push -u origin main

#Set Working Directory to Project Directory
setwd("~/Projects/Ashton")
#getwd()

library(tidyverse)
library(rvest)

#read https://ashtonrestaurants.ca/succursales
#a_s_page: Ashton Succurcales Page
a_s_page <- read_html('https://ashtonrestaurants.ca/succursales')
#Local copy
#a_s_page <- read_html('view-source_https___ashtonrestaurants.ca_succursales.html')

#Nom Restaurant
#.h4-like
a_s_page %>% html_nodes(".h4-like") %>% html_text()
a_s_page %>% html_nodes(".h4-like") %>% html_text() %>% .[2]
Resto_Name <- a_s_page %>% html_nodes(".h4-like")

#ID resto
#.js-restaurants-map-restaurant
a_s_page %>% html_nodes(".js-restaurants-map-restaurant") %>% html_text()
a_s_page %>% html_nodes(".js-restaurants-map-restaurant") %>% html_text() %>% .[2]
a_s_page %>% html_nodes(".js-restaurants-map-restaurant") %>% html_attr("data-key")
a_s_page %>% html_nodes(".js-restaurants-map-restaurant") %>% html_attr("data-name")
a_s_page %>% html_nodes(".js-restaurants-map-restaurant") %>% html_attr("data-lat")
a_s_page %>% html_nodes(".js-restaurants-map-restaurant") %>% html_attr("data-lng")
resto_ID <- a_s_page %>% html_nodes(".js-restaurants-map-restaurant") %>% html_attr("data-key")
resto_name <- a_s_page %>% html_nodes(".js-restaurants-map-restaurant") %>% html_attr("data-name")
#resto_lat <- a_s_page %>% html_nodes(".js-restaurants-map-restaurant") %>% html_attr("data-lat")
#resto_lng <- a_s_page %>% html_nodes(".js-restaurants-map-restaurant") %>% html_attr("data-lng")
resto_lat <- a_s_page %>% html_nodes(".js-restaurants-map-restaurant") %>% html_attr("data-lat") %>% gsub(pattern=",", replacement=".") %>% as.numeric
resto_lng <- a_s_page %>% html_nodes(".js-restaurants-map-restaurant") %>% html_attr("data-lng") %>% gsub(pattern=",", replacement=".") %>% as.numeric
#as.numeric(gsub(",",".", resto_lat))

#Build dataset
resto_info<-data.frame()
resto_info <- data.frame(resto_ID, resto_name, resto_lat, resto_lng, stringsAsFactors = FALSE)

#Adresse telephone horaire
#.restaurant
a_s_page %>% html_nodes(".restaurant") %>% html_text()
a_s_page %>% html_nodes(".restaurant") %>% html_text() %>% .[1]

#Adresse telephone
#.rte--no-m
a_s_page %>% html_nodes(".rte--no-m") %>% html_text()
a_s_page %>% html_nodes(".rte--no-m") %>% html_text() %>% .[1]

#Mapping the resto
# some standard map packages.
#install.packages(c("maps", "mapdata"))
#install.packages(c("leaflet"))
library(leaflet)
leaflet() %>% 
  addTiles() %>% 
  addMarkers(data = resto_info,
             lng = ~resto_lng, lat = ~resto_lat,
             popup = paste(paste('<b>Resto:</b>',
                                 resto_info$resto_name)))