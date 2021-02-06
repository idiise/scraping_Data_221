#  ctrl shift R ---créer une section
#  ctrl alt T  --- exécuter une section
# importation des packages ------------------------------------------------

library(tidyverse)
library(robotstxt)
library(xml2)
library(rvest)
library(rJava)
library(tabulizer)
library(writexl)

# debut du scraping -------------------------------------------------------
lien = "https://en.wikipedia.org/w/index.php?title=List_of_Game_of_Thrones_episodes&oldid=802553687"

# droite de scrapper le site
paths_allowed(lien)

# acceder au contenu du site
contenu_html <- read_html(lien)
tableau <- contenu_html %>% html_nodes("table") %>% html_table(fill = TRUE)

#  uniquement les tableaux qui m'interessent
tableau_interet <- contenu_html %>% html_nodes("table") %>% 
  .[2:8] %>% html_table(fill = TRUE)

# r?cup?ration des tableaux -----------------------------------------------

saison1 <- tableau_interet[[1]]
View(saison1)

saison2 <- tableau_interet[[2]]
# continuer jusqu'a la saison

# r?cup?ration de tableaux 2 ----------------------------------------------

names(tableau_interet)

nom_tableau <- c("saison1","saison2","saison3","saison4","saison5","saison6","saison7")
names(tableau_interet) <- nom_tableau
rm(saison1)
rm(saison2)


list2env(tableau_interet, .GlobalEnv)

tableau <- do.call("rbind",tableau_interet)
game_of_trone <- bind_rows(saison1,saison2,saison3,saison4,saison5,saison6,saison7)

getwd()

setwd("C:\\Users\\DELL\\Documents\\ENSAE DATA 221\\scraping")


# recuperation tableaux 3 niveau interm?diaire -------------------------------------------------
rm(nom_tableau)
rm(list=c("saison1","saison2","saison3","saison4","saison5","saison6","saison7"))
names(tableau_interet) <- NULL

nom_tableau <- list()
for (i in 1:7) {
  a <- paste("saison",i,sep = "")
  nom_tableau <- append(nom_tableau,a)
  rm(a)
}

names(tableau_interet) <- nom_tableau
rm(game_of_trone)

game_of_trone_2 <- map_df(tableau_interet, as.data.frame,.id = "Saison")


# Extratiion de tableau dans un PDF ---------------------------------------

tableau_pdf <- extract_tables("INHPC_decembre_2020.pdf",
                              method = "decide",
                              output = "data.frame")

tableau1 <- tableau_pdf[[1]]
tableau2 <- tableau_pdf[[2]]

tableau1 <- tableau1 %>% select(-5)
nomcolonne <- tableau1 %>% slice(1)


colnames(tableau1) <- nomcolonne
tableau1 <- tableau1[-1,]

# sauvegarde des donn?es --------------------------------------------------

write_xlsx(game_of_trone, "serie game of trone.xlsx")
write_xlsx(game_of_trone_2, "serie2 game of trone.xlsx")
