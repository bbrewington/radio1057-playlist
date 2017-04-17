library(rvest); library(tibble); library(dplyr);
library(lubridate); library(readr)

if(!("radio1057" %in% ls())){
  radio1057 <- data_frame(title = character(), artist = character(),
                          song_url = character(), datetime_played = as.POSIXct(character()))
}

# Run this code chunk to grab the songs from the radio1057 iheart radio page, and
# add the new ones
page.html <- read_html("http://radio1057.iheart.com/music/recently-played/")
title <- page.html %>% html_nodes(".track-title") %>% html_text()
artist <- page.html %>% html_nodes(".track-artist") %>% html_text()
song_url <- page.html %>% html_nodes(".track-title") %>% html_attr("href")
time_played <- page.html %>% html_nodes(".playlist-track-time > span") %>% html_text()
datetime_played <- 
  paste0(today(), " ", time_played) %>%
  ymd_hm(tz = Sys.timezone())
scraped_song_info <- 
  data_frame(title, artist, song_url, datetime_played) %>%
  filter(!(datetime_played %in% radio1057$datetime_played))
print(paste0("Adding ", nrow(scraped_song_info), " song(s) to radio1057 data"))
radio1057 <- bind_rows(radio1057, scraped_song_info)

write_csv(radio1057, "radio1057.csv")
