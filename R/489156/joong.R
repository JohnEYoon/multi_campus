library(RSelenium)
library(httr)
library(rvest)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4444, browserName="chrome")
remDr$open()

remDr$navigate("https://www.e-junggulib.or.kr/SJGL/")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#SrchKey")
searchbar$sendKeysToElement(list("정의란 무엇인가"))

searchbutton<-remDr$findElements(using='css', "#search > form > fieldset > input")
sapply(searchbutton,function(x){x$clickElement()})

#전체 페이지 찾기
page <- remDr$findElements(using = "css", '#btn_count > a > font > strong')#첫장
pt<-sapply(page, function (x) {x$getElementText()})
page<-unlist(pt)
end_page<-as.numeric(max(page))
#end_page


read <- remDr$findElements(using = "css", '#book_titletd > ul > li:nth-child(1) > span > a')#책 제목
temp_title<-sapply(read, function (x) {x$getElementText()})
#temp_title

read <- remDr$findElements(using = "css", '#book_titletd > ul > li:nth-child(3) > strong > a > span')#자료소유 도서관명
temp_lib<-sapply(read, function (x) {x$getElementText()})
#temp_lib

read <- remDr$findElements(using = "css", '#book_titletd > div > span > strong')#대출가능 여부
temp_ab<-sapply(read, function (x) {x$getElementText()})
#temp_ab

result_joong<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_joong

if(end_page>=2){
  for(i in 2:end_page){
    page_numb<-paste("#btn_count > a:nth-child(",i+2,") > font",sep="")#반복문으로 전체 장
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    read <- remDr$findElements(using = "css", '#book_titletd > ul > li:nth-child(1) > span > a')#책 제목
    temp_title<-sapply(read, function (x) {x$getElementText()})
    #temp_title
    
    read <- remDr$findElements(using = "css", '#book_titletd > ul > li:nth-child(3) > strong > a > span')#자료소유 도서관명
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    #temp_lib
    
    read <- remDr$findElements(using = "css", '#book_titletd > div > span > strong')#대출가능 여부
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    #temp_ab
    
    result_joong<-rbind(result_joong, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
    
  }#
}

result_joong
#result_joong

