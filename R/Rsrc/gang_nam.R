library(RSelenium)
library(httr)
library(rvest)
library(XML)
library(stringr)
library(dplyr)

remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

#
####강남도서관 - lib과 able을 분리해줘야함

remDr$navigate("https://library.gangnam.go.kr/")
searchbar<- remDr$findElement(using = "css", "[name= 'q']")
searchbar$sendKeysToElement(list(search))

searchbutton<-remDr$findElements(using='css','#searchForm > a.btSch')
sapply(searchbutton,function(x){x$clickElement()})


page <- remDr$findElements(using = "css", '#divPaging > div > a')
pt<-sapply(page, function (x) {x$getElementText()})
pt
page<-unlist(pt)
end_page<-as.numeric(max(page))
end_page

read <- remDr$findElements(using = "css", 'div.brief > dl > dd.searchTitle > a')
temp_title<-sapply(read, function (x) {x$getElementText()})


read <- remDr$findElements(using = "css", 'div.brief > dl > dd.bookline.locCursor > span')
temp_lib<-sapply(read, function (x) {x$getElementText()})

read <- remDr$findElements(using = "css", 'div.brief > dl > dd.bookline.locCursor > span')
temp_ab<-sapply(read, function (x) {x$getElementText()})




result_gangnam<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_gangnam

if(end_page>=2){
  for(i in 2:end_page){
    
    page_numb<-paste("#divPaging > div > a:nth-child(",i,")",sep="")
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    read <- remDr$findElements(using = "css", 'div.brief > dl > dd.searchTitle > a')
    temp_title<-sapply(read, function (x) {x$getElementText()})
    
    
    read <- remDr$findElements(using = "css", 'div.brief > dl > dd.bookline.locCursor > span')
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    
    read <- remDr$findElements(using = "css", 'div.brief > dl > dd.bookline.locCursor > span')
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    
    result_gangnam<-rbind(result_gangnam, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
  }#
}

colnames(result_gangnam)<- c("책이름", "도서관","대출가능여부")
result_gangnam <- subset(result_gangnam, str_sub(result_gangnam[, 3], start = -4, end = -1) == "대출가능") #대출가능한것만 추출
result_gangnam$도서관 <- str_sub(result_gangnam[, 2], start = 1, end = -6)  #도서관뒤의 대출상태를 떼어내서 저장
#result_gangnam <- result_gangnam[,-3] #대출가능한것만 추출했으니 대출가능여부는 제외하고 책이름, 도서관 두 가지만 표시
result_gangnam$도서관 <- str_replace_all(result_gangnam$도서관," ","")  #도서관 이름 열의 내,외부의 모든 공백제거
result_gangnam

