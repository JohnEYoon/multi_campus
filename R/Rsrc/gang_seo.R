library(RSelenium)
library(httr)
library(rvest)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

#####
# lib 와 ab 분리 하기(java)
####


remDr$navigate("https://lib.gangseo.seoul.kr/")


#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#divSearch > form > fieldset > p > input")
searchbar$sendKeysToElement(list(search))

searchbutton<-remDr$findElements(using='css', "#divSearch > form > fieldset > input.searchBtn")
sapply(searchbutton,function(x){x$clickElement()})

#전체 페이지 찾기 
page <- remDr$findElements(using = "css", '#divContent > div > div.briefContent > div.result > form > fieldset > div > span > a')
pt<-sapply(page, function (x) {x$getElementText()})
page<-unlist(pt)
end_page<-as.numeric(max(page))
end_page


read <- remDr$findElements(using = "css", 'dl > dd.title > a')
temp_title<-sapply(read, function (x) {x$getElementText()})
temp_title

read <- remDr$findElements(using = "css", 'dl > dd.holdingInfo > div > p > a')
temp_lib<-sapply(read, function (x) {x$getElementText()})
temp_lib

read <- remDr$findElements(using = "css", 'dl > dd.holdingInfo > div > p > a')
temp_ab<-sapply(read, function (x) {x$getElementText()})
temp_ab

result_gangseo<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_gangseo

if(end_page>=2){
  for(i in 2:end_page){
    page_numb<-paste("#divContent > div > div.briefContent > div.result > form > fieldset > div > span > a:nth-child(",i,")",sep="")
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    read <- remDr$findElements(using = "css", 'dl > dd.title > a')
    temp_title<-sapply(read, function (x) {x$getElementText()})
    temp_title
    
    read <- remDr$findElements(using = "css", 'dl > dd.holdingInfo > div > p > a')
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    temp_lib
    
    read <- remDr$findElements(using = "css", 'dl > dd.holdingInfo > div > p > a')
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    temp_ab
    
    result_gangseo<-rbind(result_gangseo, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
    
  }
}

colnames(result_gangseo)<- c("책이름", "도서관","대출가능여부")
result_gangseo <- subset(result_gangseo, str_sub(result_gangseo[, 3], start = -4, end = -1) == "대출가능") #대출가능한것만 추출
result_gangseo$도서관 <- str_sub(result_gangseo[, 2], start = 1, end = -5)  #도서관뒤의 대출상태를 떼어내서 저장
result_gangseo <- result_gangseo[,-3] #대출가능한것만 추출했으니 대출가능여부는 제외하고 책이름, 도서관 두 가지만 표시
result_gangseo
