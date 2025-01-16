#### week2: 데이터프레임 + 시각화 ####

####1. 패키지 로드 & 파일 경로 설정####
install.packages("dplyr")
install.packages("sf")
install.packages("tmap")
install.packages("ggmap")
install.packages("ggplot2")
install.packages("units")

#tmap 설치가 안될 시, 관리자권한으로 r프로그램 실행 후 아래 설치
install.packages("remotes")
remotes::install_github("r-tmap/tmap")


library(dplyr) #데이터연산 
library(sf) #공간자료 처리
library(tmap)  #공간자료 지도표현
library(ggmap) # 구글맵
library(ggplot2) #시각화 
library(units) #단위 처리


#경로 셋팅
getwd() # 현재 경로 확인
setwd("C:/Users/jungw/Dropbox/정우/lecture") # 경로 셋팅


####2. 데이터 프레임  #### 

# 2.1 csv 파일 활용한 데이터프레임 조작  

# 파일 불러오기
gu_pp <-read.csv("./gu_pp.csv")

#속성표 확인 #총 25개 행(row), 2개 열(column)
str(gu_pp)
head(gu_pp)

# 요약 통계
summary(gu_pp$pp)




# 2.2 조건으로 특정 열만 필터
# dplyr의 "%>%" 파이프 연산자 -> 다음으로 무엇을 할지 나타냄 #여러 함수를 이어줘서 가독성을 높힘

# 인구가 40만 이상인 구만 선택
gu_pp %>% filter(pp > 400000)

# 해당 데이터 행만 "large_gu"라는 데이터 프레임에 넣기
large_gu <- gu_pp %>% filter(pp > 400000)

large_gu  #11개행만 들어감





# 2.3 shp파일(공간파일) 불러오기
# sf 패키지의 st_read() 함수 사용
# 인코딩 설정 -> 이 파일은 "EUC-KR" 주로 UTF-8, EUC-KR, CP949 사용

seoul_gu_ <- st_read("C:/Users/user/Desktop/R_Study-main/lecture/week2/lecture/gu_seoul.shp", options ="ENCODING=EUC-KR")
seoul_gu <- st_read("./gu_seoul.shp", options ="ENCODING=EUC-KR")

#데이터 삭제 코드
rm(seoul_gu_)

#속성표 확인
#총 25개 행(row), 2개 열(column)
str(seoul_gu)
head(seoul_gu)

# 도형데이터로 면적 계산
st_area(seoul_gu)

# 도형데이터로 면적 계산 + 새로운 컬럼 "area" 생성
seoul_gu$area <- st_area(seoul_gu)

# 결과 확인
head(seoul_gu)
str(seoul_gu)

# 새로운 컬럼"area_km2" 생성: m2 -> km2 로 변환
seoul_gu$area_km2 <- as.numeric(seoul_gu$area/10^6)


#면적별 내림차순 정리
seoul_gu %>%
  arrange(desc(area_km2))

# 그냥 두면 올림차순
seoul_gu %>%
  arrange(area_km2)


str(seoul_gu)

#### 3. 시각화 ####

#1. 기본 plot 시각화  -> 안이쁨
plot(seoul_gu["geometry"], col="grey", border= "blue", lwd=2, axes =TRUE)



#2. ggplot2 지도 시각화 -> 통계 시각화에 더 유용함
ggplot(data = seoul_gu) +
  geom_sf(aes(fill = gu)) +
  labs(title = "서울특별시 자치구",
       fill = "자치구") +
  theme_minimal() +
  theme(legend.position = "right")  # 범례 위치 조정

#히스토그램 like this
ggplot(seoul_gu, aes(x = gu, y = area, fill= gu)) +
  geom_bar(stat = "identity",color = "black") +
  labs(title = "서울 자치구 면적",
       x = "구",
       y = "면적") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) # x축 라벨 기울이기



# 3 tmap 시각화
# 기본 지도 시각화 방법. tm_shape(data 이름) + 

#tm_polygons() -> 면
#tm_borders()  -> 경계선
#tm_dots() -> 점

#fill -> 면색상 , col -> 선색상. lwd= 선두께， fill_alpha= 투명도


tmap_mode("plot")

# 경계 
tm_shape(seoul_gu) +
  tm_polygons(col = "black", lwd  = 3) 

# 면 채우기
tm_shape(seoul_gu) +
  tm_polygons(fill = "red", fill_alpha = 0.5, col = "black", lwd  = 3) 


# leaflet 시각화
leaflet(seoul_gu) %>%
  addTiles() %>%  # 기본 지도 타일 추가
  addPolygons(colors = "black", weight = 3, fill = FALSE) %>% 
  addLegend(position = "bottomright", title = "서울시 자치구 경계")

leaflet(seoul_gu) %>%
  addTiles() %>%
  addPolygons(fillColor = "red", fillOpacity = 0.5, color = "black", weight = 3,
              highlight = highlightOptions(weight = 5, color = "blue", fillOpacity = 0.7)) %>%
  addLegend(position = "bottomright", title = "서울시 자치구")


tmap_mode("view")

# 단계구분도     # "jenks" 라는 단계구분 방법으로 6단계로 구분
tm_shape(seoul_gu) +
  tm_polygons(fill = "area_km2", fill_alpha = 0.6, col = "black", lwd  = 3, 
              fill.scale = tm_scale_intervals("jenks", n = 6))

# 사전보기
?tm_polygons()


# 팔레트 보기
cols4all::c4a_palettes("seq") 

# values -> 팔레트 이름
# brewer.set3
# brewer.set2
# brewer.set1
# hcl.blues3 
# hcl.purples3

# 팔레트 종류 변경한 단계구분도
tm_shape(seoul_gu) +
  tm_polygons(fill = "area_km2", fill_alpha = 0.5, col = "black", lwd  = 3, 
              fill.scale = tm_scale_intervals("jenks", n = 6, values = "hcl.purples3"))


 


#### 4. 데이터프레임 + 시각화 ####

#전국 읍면동 426개 자치구 로드

dongs <- st_read("./dongs.shp", options ="ENCODING=EUC-KR")
str(dongs)
head(dongs)
# 컬럼: 날짜/ 읍면동/ 읍면동 고유코드/ 도형


#서울시 추출
#subset() -> 주어진 데이터에서 특정 조건을 만족하는 행만 필터링하는 함수. 자주 사용함
#filter() 는 공간파일과 같이 사용하기 어려움 
# %in% -> 포함

# 이름(문자열)로 특정 데이터 필터
daehak <- dongs %>% subset(ADM_NM == "대학동")
daehak2 <- dongs %>% subset(ADM_NM %in% c("대학동", "낙성대동"))

tm_shape(daehak) + 
  tm_polygons(fill="blue", col="black", lwd=3)

tm_shape(daehak2) +
  tm_borders(fill="blue", col="black", lwd=3)



# 숫자로 특정 데이터 필터
# 서울시 읍면동 추출 # 고유코드 :11010530: 중 "11"인 경우 서울특별시. "26"=부산

#구조확인
head(dongs)

#ADM_CD열 중 첫번째에서 두번째 글자가 ="11" 인 경우 추출
seoul_dong <- dongs %>% subset(substr(ADM_CD, 1, 2) == "11")

str(seoul_dong)


map1<- tm_shape(seoul_gu) +
  tm_polygons(col ="darkblue", lwd = 2, fill_alpha=0) 


map2 <-tm_shape(daehak2) +
  tm_polygons(fill="blue", col="black", lwd=3)


text<- tm_shape(seoul_gu) +
  tm_text(text = "gu", col = "black", size= 1)
 

map1 + map2 +  text +
  tm_title("서울시 행정경계") +
  tm_compass(type = "8star", position = c("left", "top")) +
  tm_scalebar()





#### 5. 실습을 해봅시다! ####

# 데이터프레임 직접 만들기

laus <- data.frame(
  이름 = "LAUS",
  상호명 = "건축도시공간연구실",
  주소 = "37.4648267, 126.9571988",
  유형 = "특별",
  Latitude = 37.4648267,
  Longitude = 126.9571988
)

laus
str(laus)


# sf 객체로 변환
laus_sf <- st_as_sf(laus, coords = c("Longitude", "Latitude"), crs = 4326)
str(laus_sf)


laus_dot <- tm_shape(laus_sf) +
  tm_dots(
    size = 1,
    fill = "red"
  ) +
  tm_text(
    text = "이름",            # 텍스트로 표시할 변수
    size = 1,              # 텍스트 크기
    col = "black"            # 텍스트 그림자 추가
  ) 

# 지도
laus_dot

# 겹쳐보기
map1+laus_dot



# data1 로드
food <- read.csv("C:./food.csv")
str(food)
head(food)


#data2 로드
price <- read.csv("C:./price.csv")
str(price)
head(price)



# left_join로 데이터 결합
food_price <- left_join(food, price, by = "이름")
head(food_price)



# food 데이터를 sf 객체로 변환 #tmap은 4326
food_price_sf <- st_as_sf(food_price, coords = c("Longitude", "Latitude"), crs = 4326)


# food_sf 데이터를 점으로 시각화
tm_shape(food_price_sf) +
  tm_dots() +
  tm_title("대상지")


map1 + text + laus_dot+
  tm_shape(food_price_sf) +
  tm_dots() +
  tm_title("대상지") 


head(food_price_sf)


# 유형별로 구분 # 색상을 price에 따라 변경해 봅시다!
map1 + laus_dot +
tm_shape(food_price_sf) +
  tm_dots(
    size = 1,                 # 점 크기 (고정 값)
    fill = "유형",               # 색상 기준 변수
    fill.scale = tm_scale(palette = "brewer.set2")
  ) +
  tm_text(
    text = "이름",            # 텍스트로 표시할 변수
    size = 1,              # 텍스트 크기
    col = "black"            # 텍스트 그림자 추가
  ) +
  tm_title("음식점 유형별 위치") +
  tm_scalebar(position = c("left", "bottom")) 



# 거리 계산 
st_geometry(food_price_sf)
st_geometry(laus_sf)

# crs 5179로 변경
food_price_sf <- st_transform(food_price_sf, crs = 5179)
laus_sf <- st_transform(laus_sf, crs = 5179)


#직선거리를 구해보자
dist_matrix <- st_distance(laus_sf, food_price_sf)
laus_sf

# 거리 값을 순서대로 food_sf$거리 컬럼에 입력
food_price_sf$거리 <- as.numeric(dist_matrix)

food_price_sf %>%
  arrange(거리)





map1 + laus_dot + 
tm_shape(food_price_sf) +
  tm_dots(
    size = 1,                 # 점 크기 (고정 값)
    fill = "거리",               # 색상 기준 변수
    fill.scale = tm_scale_intervals(values = "hcl.purples3")
  ) +
  tm_text(
    text = "이름",            # 텍스트로 표시할 변수
    size = 1,              # 텍스트 크기
    col = "black"            # 텍스트 색상
  ) +
  tm_layout(legend.show = FALSE) +
  tm_title("음식점 유형별 위치") +
  tm_scalebar(position = c("left", "bottom")) 

str(food_price_sf)


# 거리와 price 기준으로 결과 정렬

result <- food_price_sf %>%
  arrange(거리)%>%
  filter(price == min(price)) %>%
  slice(1)

# result$상호명 값 포함한 문자열 생성
message <- paste("다음 회식 장소는", result$상호명, "입니다.")

print(message)



####6. 구글맵에 시각화 ####
register_google("")


  
map <- get_map(
  location = "south korea",
  maptype = "roadmap", 
  source = "google", 
  color = "color"
)
ggmap::ggmap(map)


# get_map()
seoul <- get_map(location = "seoul, south korea", zoom =12, maptype = "roadmap")

# ggmap()
ggmap::ggmap(seoul)

# ggmap을 활용해 지도 시각화
g <- ggmap(seoul) +
  geom_point(data = food, aes(x = Longitude, y = Latitude), color = "blue", size = 3)

# ggmap()
print(g)






