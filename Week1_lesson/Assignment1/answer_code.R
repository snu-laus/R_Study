#1. 데이터 확인하기#

# 필요한 패키지 로드
library(sf)

# 데이터 불러오기
public <- read.csv("C:/Users/USER/Desktop/Week1_lesson/Assignment1/public_corporation.csv") # 파일 불러오기

# 데이터 구조 확인
str(public)

# 컬럼명 영문으로 변경 
names(public) <- c("key", "class1", "class2", "class3", "name", "address", "si", "gu", "dong", "hompage", "Latitude", "Longitude")
print(names(public))  # 변경된 컬럼명 확인

#2. 좌표계 변환#
library(sp)
library(sf)

# 위도와 경도를 이용해 sf 객체 만들기
public_sf <- st_as_sf(public, coords = c("Longitude", "Latitude"), crs = "+proj=longlat +datum=WGS84")  # WGS84 좌표계로 설정
print(st_crs(public_sf))  # 확인

# 좌표계 변환 (WGS84 -> 중부원점 TM 좌표계)
public_tm <- st_transform(public_sf, crs = "+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=600000 +ellps=GRS80 +units=m")
print(st_crs(public_tm))  # 변환된 좌표계 확인


#3.  SHP 파일로 저장
st_write(public_tm, dsn = "C:/Users/USER/Desktop/Week1_lesson/Assignment1/public_corporation_tm.shp", driver = "ESRI Shapefile", layer_options = "ENCODING=UTF-8")


