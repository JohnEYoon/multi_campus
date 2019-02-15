library(RSelenium)
library(httr)
library(rvest)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

remDr$navigate("https://lib.sen.go.kr/lib/index.do?getContextPath=")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#search_text_1")
searchbar$sendKeysToElement(list("정의란 무엇인가"))

searchbutton<-remDr$findElements(using='css', "#main-search-btn")
sapply(searchbutton,function(x){x$clickElement()})

#전체 페이지 찾기
page <- remDr$findElements(using = "css", '#board_paging > span > a')#마지막 페이지
pt<-sapply(page, function (x) {x$getElementText()})

last_page <- remDr$findElements(using = "css", '#board_paging > span > a:nth-child(12)')
lp<-sapply(last_page, function (x) {x$getElementAttribute("keyvalue")})

#lp


read <- remDr$findElements(using = "css", '#contentArea > div > div.smain > div > div:nth-child(3) > ul > li > dl > dt > a')#책 제목
temp_title<-sapply(read, function (x) {x$getElementText()})
#temp_title

read <- remDr$findElements(using = "css", '#contentArea > div > div.smain > div > div:nth-child(3) > ul > li > dl > dd.site > span:nth-child(1)')#자료소유 도서관명
temp_lib<-sapply(read, function (x) {x$getElementText()})
#temp_lib

read <- remDr$findElements(using = "css", '#contentArea > div > div.smain > div > div:nth-child(3) > ul > li > div.bookStateBar > p')#대출가능 여부
temp_ab<-sapply(read, function (x) {x$getElementText()})
#temp_ab

result_jongro<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_jongro

if(lp>=2){
  for(i in 2:lp){
    if(i == 10){
      nextbtn <- remDr$findElements(using='css', "#board_paging > span > a:nth-child(11)")
      sapply(nextbtn,function(x){x$clickElement()})
    }else{
      page_numb<-paste("#board_paging > span > a:nth-child(",i,")",sep="")#반복문으로 전체 장
      searchbutton<-remDr$findElements(using='css',page_numb)
      sapply(searchbutton,function(x){x$clickElement()})
      
      read <- remDr$findElements(using = "css", '#contentArea > div > div.smain > div > div:nth-child(3) > ul > li > dl > dt > a')#책 제목
      temp_title<-sapply(read, function (x) {x$getElementText()})
      #temp_title
      
      read <- remDr$findElements(using = "css", ' #contentArea > div > div.smain > div > div:nth-child(3) > ul > li > dl > dd.site > span:nth-child(1)')#자료소유 도서관명
      temp_lib<-sapply(read, function (x) {x$getElementText()})
      #temp_lib
      
      read <- remDr$findElements(using = "css", '#contentArea > div > div.smain > div > div:nth-child(3) > ul > li > div.bookStateBar > p')#대출가능 여부
      temp_ab<-sapply(read, function (x) {x$getElementText()})
      #temp_ab
      
      result_jongro<-rbind(result_jongro, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
      
    }
  }#
}
result_jongro

