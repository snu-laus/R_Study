# 공간분석 학습 자료 저장소

## 소개
이 저장소는 LAUS 구성원들을 위한 R 기반 공간분석 학습 자료를 포함하고 있습니다.

## 목차

### I. 공간정보와 R
1. GIS와 공간정보 데이터
   - 공간정보와 GIS
   - 공간정보 데이터
   - 공간정보 좌표체계

2. R과 공간정보
   - R 소프트웨어의 소개와 설치
   - R 데이터 변수
   - 공간정보 처리 패키지

### II. 공간정보의 처리
3. R의 공간정보 데이터 구조
   - 점 데이터 구조
   - 선 데이터 구조
   - 면 데이터 구조
   - 래스터 데이터 구조
   - 좌표체계의 정의와 변환
   - R을 이용한 공간정보 생성 실습

4. 공간정보의 입출력
   - 공간정보의 수집
   - 공간정보 데이터 읽기
   - 공간정보 데이터 저장
   - R을 이용한 데이터 입출력 실습

5. 공간정보의 시각화
   - 기본적인 시각화 함수 plot
   - 속성정보를 이용한 시각화 함수 spplot
   - 속성정보를 이용한 단계구분도 작성
   - 구글 지도를 이용한 시각화
   - R을 이용한 공간정보 시각화 실습

6. 공간 연산
   - 기하학적 측정
   - 공간관계 연산
   - 거리 분석
   - 중첩 분석
   - 기타 공간 연산
   - R을 이용한 공간 연산 실습

### III. 공간통계 분석
7. 점 패턴 분석
   - 점 패턴 요약
   - 밀도기반 분석
   - 거리기반 분석
   - R을 이용한 점 패턴 실습

8. 공간적 자기상관
   - 공간적 자기상관 개념
   - 전역적 Moran's I
   - 국지적 Moran's I
   - R을 이용한 공간적 자기상관 실습

9. 공간 보간
   - 보간에 대한 결정론적 접근
   - 통계적 보간법
   - R을 이용한 보간 실습

10. 공간 회귀분석
    - 전차의 공간적 종속성과 이질성
    - 일반 선형 회귀모형(GLM)
    - 지리 가중 회귀모형(GWR)
    - R을 이용한 회귀분석 실습

## 사용 방법
1. 이 저장소를 로컬에 클론합니다:
```bash
git clone https://github.com/gbjun7333/LAUS_R.git
```

2. 교재에 필요한 R 패키지들을 설치합니다:
```bash
#(1) RTools 패키지 설치 (Windows 사용자만 해당)
https://cran.r-project.org/bin/windows/Rtools/ 에서 운영체제에 맞는 버전 설치

# (2) 공간분석 및 시각화 관련 패키지 설치
# a. 공간분석 기본 패키지
install.packages(c("sp", "rgdal", "rgeos"))

# 참고: rgdal, rgeos는 2023년 10월 이후 CRAN 지원 중단
# 대안 패키지 설치: sf, terra
install.packages("remotes")
remotes::install_github("r-spatial/sf")
install.packages("terra", type = "source")

# b. 시각화 패키지
install.packages(c("ggmap", "tmap"))
# tmap 최신버전 필요시:
remotes::install_github('r-tmap/tmap')

# c. 공간통계 패키지
install.packages(c("spatstat", "spdep"))
install.packages('spDataLarge', 
                repos='https://nowosad.github.io/drat/', 
                type='source')

# d. 래스터 및 공간보간 패키지
install.packages(c("raster", "gstat", "spgwr"))

# (3) 라이브러리 로드
# 필요한 패키지만 선택적으로 로드하여 사용
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
```

## 기여방법
- Pull Request는 언제나 환영합니다
- 새로운 예제나 분석 방법을 추가하실 때는 관련 문서화를 함께 해주세요

## 참여자
- 1회차 세션('24): 이선재, 김정우, 이수진, 심준형, 송영재, 박동준, 박소연, 윤소정

## 비고
- 관리자가 repository에 익숙해지면, branch로 동시 작업을 관리하고자 합니다. 그 전까지는 각자 다른 파일로 복사하여 작업 부탁드려요!
- 교재에 사용되는 샘플 데이터 셋 + 기타 참고 자료 등을 모두 아카이빙하고자 합니다. 누락되거나 추가해야할 자료들은 직접 push하시거나 관리자에게 말씀 부탁드려요!

