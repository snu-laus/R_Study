##진행 전 다음 패키지들을 설치, 경우에 따라 라이브러리 설정해주세요##
##R 세미나 전체 기간 동안 쓰이는 패키지들입니다##
##해당되는 코드를 드래그한 후(한줄씩 진행하는 것을 권장합니다), ctrl+enter(윈도우 기준) 혹은 우측 상단의 Run 을 눌러 실행해주세요##


## (1)RTools 패키지(windows 만 해당) : https://cran.r-project.org/bin/windows/Rtools/에 들어가 운영체제 맞춰서 설치
## (2)공간분석 및 시각화 관련 패키지 설치(a~d 순서대로 진행)
#a. 공간분석 기본 패키지
install.packages(c("sp","rgdal","rgeos"))
install.packages("rgeos")
install.packages("rgdal")
#상단의 코드처럼 rgdal, rgeos 패키지가 교재 내에서 기본 패키지로 지정되어 있으나, 설치 안될수도 있음(23년 10월 이후로 CRAN에서 지원이 되지 않고 있습니다)
#CRAN 에서는 sf 패키지, terra 패키지를 대안으로 제시(참고 : https://cran.r-project.org/web/packages/rgdal/index.html, https://cran.r-project.org/web/packages/rgeos/index.html)

# install packages (sf패키지)
install.packages("remotes")
remotes::install_github("r-spatial/sf")
#install packages(terra패키지->raster 패키지 또한 대체)
install.packages("terra", type = "source")

#b. 시각화 패키지
install.packages(c("ggmap","tmap"))
remotes::install_github('r-tmap/tmap') #tmap 최신버전 다운로드 필요하다고 오류창 뜰 경우 사용해주세요
#c. 공간통계 패키지
install.packages(c("spatstat","spdep"))
install.packages('spDataLarge', repos='https://nowosad.github.io/drat/', type='source') #spdep 확장 패키지 설치
#d. 래스터 및 공간보간 패키지
install.packages(c("raster","gstat","spgwr"))


# (3)a~d 과정에서 진행한 게 잘 설치되었는지 체크+분석 시 필요한 라이브러리로 설정해주기(하단의 모든 라이브러리를 항상 설정하지 않아도 됩니다. 오히려 무거워져요!)
# 경우에 따라 필요한 라이브러리가 상이하므로, 매 분석마다 라이브러리 설정이 필요합니다. 
# 추가로 잘 쓰는 패키지들의 경우 별도로 라이브러리로 따로 묶어 설치도 가능합니다.(해당 과정은 생략)
library(sp)
library(sf)
library(terra)
library(ggmap)
library(tmap)
library(spatstat)
library(spdep)
library(raster)
library(gstat)
library(spgwr)




##3장 R의 공간정보 데이터 구조##

#3.1. 점데이터 구조 : 대학교별 위치 지도 그리기#

#데이터프레임에 x좌표와 y좌표를 담고 있는 필드 구성
x<-c(126.9552, 127.0526, 126.9385, 127.0277)
y<-c(37.6026, 37.5954, 37.5659, 37.5911)
name<-c("상명대학교","경희대학교","연세대학교","고려대학교")
univ<-data.frame(Longtitude=x, Latitude=y, Name = name)

#CRS 함수를 이용한 좌표체계 정보 저장
cs <- CRS("+proj=longlat +datum=WGS84")

# 좌표를 지정하여 SpatialPoints 객체 생성
coordinates(univ) <- ~Longtitude + Latitude

#좌표값을 가진 데이터프레임에 좌표체계 정보를 추가하여 SpatialPoints 객체 생성
sp<- SpatialPoints(univ, proj4string=cs)

#SpatialPoints 객체에 속성 데이터를 결합하여 위치정보와 속성정보가 결합된 공간정보 구성
spdf <- SpatialPointsDataFrame(univ, data.frame(Name = name))

#지금까지 과정을 통해 생성된 공간 객체와 공간 데이터프레임 객체를 지도로 출력
plot(spdf, axes=T, pch=10)
text(spdf,name)


#3.2.선데이터 구조 : 서울시 지하철 1호선과 2호선 일부 구간을 선 객체로 생성하기#

#선 데이터 x,y좌표를 각각 벡터로 구성하고 cbind 함수로 x,y좌표를 합쳐 선 데이터 좌표값을 메트릭스로 생성
x1<-c(126.9720783,126.9724216, 126.9763698, 126.9773139, 126.9771953)
y1<-c(37.5552612, 37.5570503, 37.5610647, 37.5657592, 37.5702657)
l1<-cbind(x1,y1)
x2<-c(126.9644515, 126.9671981, 126.9774978, 126.9793002, 126.9931189)
y2<-c(37.5595652, 37.5616064, 37.5643959, 37.5660287, 37.5663008)
l2<-cbind(x2,y2)

#Line 함수를 이용하여 각각의 좌표값으로 이루어진 변수를 선 객체로 작성
ln1<-Line(l1)
ln2<-Line(l2)

#Lines 함수를 이용하여 Line 객체를 list함수로 묶어 Lines 객체 생성
#해당 사례의 경우 멀티 파트를 구성하지 않으므로, list 함수에서 하나의 객체만 설정
lns1<-Lines(list(ln1), ID=1)
lns2<-Lines(list(ln2), ID=2)

#CRS 함수를 이용하여 좌표체계 정보 정의, SpatialLines 함수를 이용하여 Lines 객체를 SpatialLines 객체로 작성
cs <- CRS("+proj=longlat +datum=WGS84")
slns<-SpatialLines(list(lns1,lns2), proj4string=cs)

#SpatialLines 객체에 속성 데이터를 결합하여 위치정보와 속성정보가 결합된 공간정보를 구성
subno<-data.frame(ID=c(1,2), name=c("1호선","2호선"))
slnsdf<-SpatialLinesDataFrame(slns, data=subno)

#결과를 지도로 출력
plot(slnsdf,axes=T,col=1:2)

#3.3.면데이터 구조 : 서울시 경복궁과 덕수궁 모양을 면 객체로 표현하기#

#x,y좌표 벡터로 구성, 다각형 꼭지점 좌표값을 매트릭스로 작성
x1=c(126.9744937, 126.9737212,126.9740645,126.9768111,126.979386,126.9801585,126.979386,126.9794719,126.9778411)
y1=c(37.5756889, 37.5799063, 37.5831712, 37.5837834, 37.5831712, 37.5818789, 37.578886, 37.5763691, 37.5758929)
p1=cbind(x1,y1)

x2=c(126.9769001,126.9769538,126.9750011,126.9742823, 126.973939, 126.9732845, 126.9735527, 126.9736064, 126.9741106, 126.9759989)
y2=c(37.5648948, 37.5665361, 37.5665956, 37.5668933, 37.5675056, 37.5674545, 37.5664851, 37.5652264, 37.5647757, 37.5649458)
p2<-cbind(x2,y2)

#polygon 함수를 이용하여 각각의 좌표값으로 이루어진 변수를 면 객체로 작성
pl1<-Polygon(p1) #p1 변수 좌표값 면 객체 설정
pl2<-Polygon(p2) #p2 변수 좌표값 면 객체 설정

#Polygons 함수를 이용하여 Polygon 객체를 list 함수로 묶어 생성
polys1<-Polygons(list(pl1),ID=1)
polys2<-Polygons(list(pl2),ID=2)

#CRS 함수를 이용하여 좌표체계 정보 정의, SpatialPolygons 함수를 이용하여 Polygons 객체를 SpatialPolygons 객체로 작성
cs <- CRS("+proj=longlat +datum=WGS84")
spolys <- SpatialPolygons(list(polys1,polys2), proj4string=cs)

#SpatialPolygons 객체에 속성 데이터 결합, 위치정보와 속성정보가 결합된 공간정보 구성
palace<-data.frame(ID=c(1,2), name=c("경복궁","덕수궁"))
spolysdf <- SpatialPolygonsDataFrame(spolys, data=palace)

#지도로 출력
plot(spolysdf, axes=T, col=1:2)

#3.4. 래스터 데이터 구조 : RasterLayer, RasterBrick 비교#
#RasterLayer 객체(r) 생성
r<-raster(ncol=10, nrow=10, xmn=126.5, xmx=127, ymn=37, ymx=37.5)

#values함수를 이용하여 레스터 데이터의 격자에 값을 부여(1~100까지 일련번호)
values(r)<-1:100

#단일 레이어의 레스터 파일을 이용하여 다중 레이어의 레스터 파일 작성
r2<-r*r
r3<-sqrt(r)
rs<-stack(r,r2,r3)

#brick 함수를 이용하여 RasterStack 객체(rs)로부터 RasterBrick 객체(rb) 생성
rb<-brick(rs)

#RasterLayer, RasterBrick 출력
plot(r)
plot(rb)

#3.5.좌표체계의 정의와 변환#
#CRS("+매개변수=값") 형태로 작성 : CRS함수는 앞에서 정의한 EPSG 코드에서 정의한 매개변수 값을 정의함으로써 수행됨
CRS("+proj=longlat +datum=WGS84") #WGS84 좌표계
CRS("+proj=utm +zone=51 +datum=WGS84") # UTM 좌표계 (우리나라는 51번, 52번 구역을 사용하며 해당 코드는 51번 구역)
CRS("+proj=tmerc +lat_0=38 +lon_0=127 +k=1 +x_0=200000 +y_0=600000 +ellps=GRS80 +units=m") #우리나라 중부원점의 TM좌표계
CRS("+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +units=m") #단일원점 좌표체계인 UTM-K의 좌표체계

cs = CRS("+proj=longlat +datum:WGS84")
sp<-SpatialPoints(univ, proj4string=cs) #univ 라는 데이터프레임에 sp 라는 공간객체를 정의하고자 CRS에서 정의한 좌표체계 cs를 공간객체의 좌표체계로 부여

cs = CRS("+proj=longlat +datum=WGS84")
proj4string(spdf) = cs #proj4string 으로 기존 공간 객체(spdf)에 새로이 좌표체계 정보(cs) 부여

cs2 = CRS("+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +units=m")
spdf2 = spTransform(spdf, cs2) #좌표체계 변환을 통한 공간객체 좌표값 변경(spTransform 함수 사용)

#3.6. R을 이용한 공간정보 생성 실습#
#3.6.1. 포인트 객체 만들기#

#4개 지점을 선택해 위도와 경도 설정
library(sp)
x <- c(126.9552,127.0526,126.9385,127.0277) #벡터x작성
y <- c(37.6026,37.5954,37.5659,37.5911) #벡터y작성
name <- c("상명대학교","경희대학교","연세대학교","고려대학교") #벡터 name 작성

#data.frame 함수를 이용해 벡터를 데이터프레임으로 변환하고 포인트 객체로 만들기
univ <- data.frame(Longitude=x, Latitude=y) #데이터프레임 작성
cs <- CRS("+proj=longlat +datum=WGS84")  #좌표계 정의
sp <- SpatialPoints(univ,proj4string=cs) #SpatialPoints 생성

#완성된 포인트 객체에 위치의 이름을 속성정보로 부여하여 포인트 객체 데이터프레임 작성, 출력
spdf <- SpatialPointsDataFrame(sp, data=data.frame(Name=name)) #속성정보 부여
plot(spdf, axes=T, pch=10) #그래프 출력
text(spdf,name)

#3.6.2. 선 객체 만들기#

#5개 꼭짓점으로 구성된 2개의 선으로부터 각각 위도, 경도 값을 작성(꼭짓점 좌표 취득)
library(sp)
x1<-c(126.9720783,126.9724216, 126.9763698, 126.9773139, 126.9771953)
y1<-c(37.5552612, 37.5570503, 37.5610647, 37.5657592, 37.5702657)
x2<-c(126.9644515, 126.9671981, 126.9774978, 126.9793002, 126.9931189)
y2<-c(37.5595652, 37.5616064, 37.5643959, 37.5660287, 37.5663008)

#x,y벡터를 하나의 벡터(Line 객체)로 합치기(l1, l2)
l1 <- cbind(x1,y1) #x1,y1좌표로 구성된 매트릭스 작성
ln1 <- Line(l1)
l2 <- cbind(x2,y2) #x2,y2 좌표로 구성된 매트릭스 작성
ln2 <- Line(l2) 

#각각의 Line 객체를 Lines 객체로 변환한 후 공간객체로 변환
lns1 <- Lines(list(ln1), ID=1) 
lns2 <- Lines(list(ln2), ID=2) #Lines객체 작성
cs <- CRS("+proj=longlat +datum=WGS84") #좌표계 정의
slns <- SpatialLines(list(lns1,lns2), proj4string=cs) #SpatialLines 작성

#각 선의 이름을 속성정보로 부여, 선 객체 데이터프레임 작성 및 출력
subno <- data.frame(ID= c(1,2), name=c("1호선","2호선")) #데이터프레임 작성
slnsdf <- SpatialLinesDataFrame(slns, data=subno) #SpatialLinesDataFrame 작성
plot(slnsdf, axes=T, col=1:2) #그래프 출력

#3.6.3. 면 객체 만들기#
library(sp)
x1 = c(126.9744937,126.9737212,126.9740645,126.9768111,126.979386, 126.9801585,126.979386,126.9794719,126.9778411)
y1 = c(37.5756889, 37.5799063, 37.5831712, 37.5837834, 37.5831712, 37.5818789, 37.578886, 37.5763691, 37.5758929)
x2 = c(126.9769001, 126.9769538, 126.9750011, 126.9742823, 126.973939, 126.9732845, 126.9735527, 126.9736064, 126.9741106, 126.9759989)
y2 = c(37.5648948, 37.5665361, 37.5665956, 37.5668933, 37.5675056, 37.5674545, 37.5664851, 37.5652264, 37.5647757, 37.5649458)

p1<-cbind(x1,y1)
pl1<-Polygon(p1) #x1,y1좌표로 구성된 매트릭스 작성 
p2 <-cbind(x2,y2)
pl2<-Polygon(p2) #x2,y2 좌표로 구성된 매트릭스 작성

polysl <- Polygons(list(pl1), ID=1) 
polys2 <- Polygons(list(pl2), ID=2) # Polygons 객체 생성
cs <- CRS("+proj=longlat +datum=WGS84") #좌표계 정의
spolys <- SpatialPolygons(list(polys1,polys2),proj4string=cs) #SpatialPolygons 생성

palace <- data.frame(ID=c(1,2), name=c("경복궁","덕수궁"))
spolysdf <- SpatialPolygonsDataFrame(spolys, data=palace) #SpatialPolygonsDataFrame 작성
plot(spolysdf, axes=T, col=1:2) #그래프로 출력

#3.6.4. 레스터 객체 만들기#

#레스터 행렬 생성
library(raster)
r <- raster(ncol=10,nrow=10, xmn=126.5, xmx=127, ymn=37, ymx=37.5) #RasterLayer 생성(책에서는 ymxplo 로 나오는데, 해당 raster 함수에서는 y축의 최소,최댓값을 요구하므로 수정필요했음)

#Raster Layer 생성
values(r) <- 1:100 #레스터 레이어의 셀 값을 1부터 100까지의 숫자로 채우기(이 데이터가 하나의 Raster Layer 에 해당)
r2 <- r*r #각 셀의 값을 제곱한 데이터 생성
r3 <- sqrt(r) #각 셀의 값을 제곱근한 데이터 생성

#Raster Layer를 다중 레스터, Raster Brick 으로 생성
rs <- stack(r,r2,r3) # RasterStack 생성
rb <- brick(rs) #RasterBrick 생성
plot(r) #RasterLayer 출력
plot(rb) #RasterBrick 출력

#3.6.5. 공간 데이터 좌표 변환#
cs2 = CRS("+proj=tmerc +lat_0=38 +lon_0=127.5 +k=0.9996 +x_0=1000000 +y_0=2000000 +ellps=GRS80 +units=m") #UTM-K로 좌표체계 정의

spdf2 = spTransform(spdf, cs2)
slnsdf2=spTransform(slnsdf,cs2)
spolysdf2=spTransform(slnsdf,cs2) #spTransform함수로 점 객체(spdf),선 객체(slnsdf),폴리곤 객체(spolysdf) 를 UTM-K로 변환

plot(spdf2,axes=T,pch=10)
plot(slnsdf2,axes=T,col=1:2)
plot(spolysdf2,axes=T,col=1:2) #변환된 결과 출력




##4장 공간정보의 입출력##

#4.2. 공간정보 데이터 읽기 : 서울시 수해대피소의 수용인원#
#교재에서 사용한 데이터가 더 이상 제공되지 않아, 부득이하게 데이터 변경해 진행(서울시 대피소 방재시설 현황 : https://data.seoul.go.kr/dataList/OA-2189/S/1/datasetView.do)
#실습 내 사용 데이터(서울시 수해대피소 공간정보 : https://data.seoul.go.kr/dataList/OA-21181/F/1/datasetView.do)

#4.2.1. 테이블 데이터 불러오기#
#데이터 로드
fl = read.csv("C:/Users/USER/Desktop/Week1_lesson/Flood_shelter.csv")
#혹은 CSV 파일이 온라인에 있는 경우 아래와 같이 직접 불러올 수 있음
fl = read.csv('https://raw.githubusercontent.com/snu-laus/R_Study/refs/heads/main/lecture/week1/lecture/Week1_lesson/Flood_Shelter.csv',sep=',')


str(fl) #데이터 구조 확인

#데이터프레임 생성
pt = data.frame(longitude=fl$경도, latitude=fl$위도)

#중부원점 좌표계 정의 (UTM-K)
cs_utm_k = CRS("+proj=tmerc +lat_0=38 +lon_0=127.5 +k=1 +x_0=200000 +y_0=500000 +datum=WGS84 +units=m +no_defs")

#SpatialPoints 객체 생성
spt_utm_k = SpatialPoints(pt, proj4string=cs_utm_k)

#중부원점 좌표계를 WGS84로 변환
spt_wgs = spTransform(spt_utm_k, CRS("+proj=longlat +datum=WGS84"))

#SpatialPointsDataFrame 생성
shelt_wgs = SpatialPointsDataFrame(spt_wgs, data=fl)

#시각화
spplot(shelt_wgs, zcol="최대수용인원") 


#4.2.2. 쉐이프 파일 읽어오기#
library(sp)
library(sf)
library(tmap)

# 서울시 시군구 데이터를 읽고 면 사상 형태의 공간 객체(admin)에 저장
admin <- st_read("C:/Users/USER/Desktop/Week1_lesson/SGG_seoul.shp")

str(admin) #데이터 구조 확인

# 좌표계 설정 (WGS84)
admin <- st_transform(admin, crs = 4326)  # 데이터 재투영

# tmap으로 시각화
tm_shape(admin) +
  tm_borders() +  # 경계선
  tm_fill(col = "SHAPE_AREA", palette = "Blues", title = "Area Size")  # 면적을 색상으로 표시


#4.2.3. 래스터 화일 읽어오기#
#사용 데이터 : 서울시 국토환경성평가지도(https://data.neins.go.kr/detail/dts-BNbJ3vQkhk)

# 1. 레스터 파일 읽기
ecvam <- raster("C:/Users/USER/Desktop/Week1_lesson/국토환경성평가지도_2024_서울특별시_5186.tif")

# 2. 레스터 구조 확인
print(ecvam)

# 3. 레스터 데이터를 데이터프레임으로 변환
ecvam_df <- as.data.frame(ecvam, xy = TRUE)

# 4. 데이터프레임의 컬럼명을 확인하여 레스터 값의 컬럼을 찾음
head(ecvam_df)  # 컬럼명 확인

# 5. tmap을 이용한 시각화
tm_shape(ecvam) +
  tm_raster(palette = "viridis", style = "cont", title = "Ecological Value")  # 레스터 시각화


#4.3.공간정보 데이터 저장#
names(fl) #4.2.1.에서의 spdf 데이터프레임의 필드 현황 확인
names(fl) = c("R_SEQ_NO","CD_AREA","SD_NM","SGG_NM","USAGE","PLACE_NAME","ADDRESS","QTY_CPTY","XCORD","YCORD","XX","YY","CD_GUBUN") # 필드 이름을 영문명으로 변경하고 싶은 경우

#sp, rgdal 패키지를 이용해 shp, tif 생성, 저장하고자 하는 경우(교재 버전)
writeOGR(fl,dsn=".",layer="fl2",driver = "ESRI Shapefile") #writeOGR : 변경된 공간 객체를 shp 파일로 저장
writeGDAL(ecvam, fname="ecvam2.tif") # writeGDAL : 레스터 데이터(tif) 저장

#sf, raster 패키지를 이용해 shp, Geotif 생성, 저장하고자 하는 경우(실습 버전)
st_write(fl, dsn = ".", layer = "fl2", driver = "ESRI Shapefile", append = FALSE) #st_write() : 변경된 공간 객체를 shp 파일로 저장
writeRaster(ecvam, filename = "ecvam2.tif", format = "GTiff", append = FALSE, overwrite = TRUE) # writeRaster() : 레스터 데이터(GeoTIFF) 저장
#중복된다고 에러창이 뜨는 경우 다음 코드를 추가해주세요 : append = FALSE, overwrite = TRUE

#4.4.R을 이용한 데이터 입출력 실습#
#4.4.1. 테이블 데이터 불러오기#
library(sp)
fl = read.csv("C:/Users/USER/Desktop/Week1_lesson/Flood_shelter.csv") #파일 불러오기
pt = data.frame(longitude=fl$경도, latitude=fl$위도) #경도, 위도 컬럼으로 데이터프레임 작성
cs = CRS("+proj=longlat +datum=WGS84") #좌표계 정의
spt = SpatialPoints(pt, proj4string = cs) #포인트객체 만들 때 좌표계 반영

fl = SpatialPointsDataFrame(spt, data=fl) #작성된 포인트 객체에 원래 테이블 데이터를 속성정보로 부여, 데이터프레임 작성
spplot(fl, zcol ="최대수용인원")

#4.4.2. 쉐이프파일 불러오기#
admin <- st_read("C:/Users/USER/Desktop/Week1_lesson/SGG_seoul.shp")
dule <- st_read("C:/Users/USER/Desktop/Week1_lesson/seoul_dulegil.shp")
road <- st_read("C:/Users/USER/Desktop/Week1_lesson/road_seoul.shp")

#대상 파일의 좌표체계는 동일(WGS84)하므로, 이를 고려해 파일 준비
cs = st_crs("+proj=longlat +datum=WGS84")

# 좌표계 설정
st_crs(admin) <- cs
st_crs(dule) <- cs
st_crs(road) <- cs

#4.4.3. 생성된 데이터 저장하기#
fl = read.csv("C:/Users/USER/Desktop/Week1_lesson/Flood_shelter.csv") #파일 불러오기

#점 객체 데이터프레임을 shp 파일로 저장 : 데이터프레임 필드명이 영문으로 작성되어 있어야 함
names(fl) = c("R_SEQ_NO","CD_AREA","SD_NM","SGG_NM","USAGE","PLACE_NAME","ADDRESS","QTY_CPTY","XCORD","YCORD","XX","YY","CD_GUBUN")
print(names(fl))

# 데이터프레임을 sf 객체로 변환
fl <- st_as_sf(fl, coords = c("XCORD", "YCORD"), crs = 5174)  # 중부원점 좌표계로 설정

# 좌표계가 제대로 설정되었는지 확인
print(st_crs(fl))

# Shapefile로 저장
st_write(fl, dsn = "C:/Users/USER/Desktop/Week1_lesson/fl_eng", layer = "fl_eng", driver = "ESRI Shapefile", layer_options = "ENCODING=UTF-8")




#참고1 : shp 파일의 좌표 변경이 필요한 경우
admin <- st_read("파일")
admin_transformed <- st_transform(admin, crs = 4326) #4326 대신 경우에 따라 적절한 좌표로 변경
st_write(admin_transformed, "파일")
#참고2 : 저장되는 위치가 보이지 않을 때 / 현재 작업 디렉토리를 확인하고자 할 때
getwd()
setwd("C:/path/to/your/folder") # 작업 디렉토리를 바꾸고 싶을 때
