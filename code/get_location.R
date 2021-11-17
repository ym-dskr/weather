library(tidyverse)
library(rvest)

# 気象官署の住所から座標を取得する
kansho <- read_csv("input/kansho.csv", locale = locale(encoding = "shift-jis"))
jusho <- kansho$所在地等 %>% str_remove_all("\\s")

url <- paste0("https://www.geocoding.jp/api/?v=1.1&q=", jusho)

lat <- c()
lng <- c()

for(i in 1:length(url)){
# for(i in 1:5){
  
  page <- read_html(url[i])
  Sys.sleep(3)
  
  lat_i <- page %>% html_nodes("lat") %>% html_text() 
  lng_i <- page %>% html_nodes("lng") %>% html_text() 
  
  lat <- c(lat, lat_i)
  lng <- c(lng, lng_i)
  
  Sys.sleep(1) #取得元に負担をかけないよう1データ取得ごとに5秒あける
  
  print(paste0("OK : ", i))
}

# geo_df <- data.frame(jusho, lat, lng)
# lat <- geo_df$lat 
# lng <- geo_df$lng

kansho$lat <- lat
kansho$lng <- lng

write.csv(kansho, "input/kansho_r.csv")

