library(RSelenium)
library(httr)
library(rvest)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

#_searchListChk > div > dl > dd > div > a

#================송파 도서관 =======================
remDr$navigate("http://www.splib.or.kr/")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#schMain > form > div > div > div.whiteBox > input")
searchbar$sendKeysToElement(list("정의란 무엇인가"))


searchbutton<-remDr$findElements(using='css', "#schMain > form > div > div > div.btnBox > a > img")
sapply(searchbutton,function(x){x$clickElement()})

#전체 페이지 찾기
webElem<-remDr$findElements(using="css", "iframe")
remDr$switchToFrame(webElem[[1]])
page <- remDr$findElements(using = "css", "#wrap > div > p > a");page
pt<-sapply(page, function (x) {x$getElementText()})
pt


page<-unlist(pt)
page
end_page<-max(as.numeric(page))
end_page

#end_page


read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dt > a')
temp_title<-sapply(read, function (x) {x$getElementText()})
temp_title

read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dd.site > span:nth-child(2)')
temp_lib<-sapply(read, function (x) {x$getElementText()})
temp_lib

read <- remDr$findElements(using = "css", '#searchForm > ul > li > div > p > b')
temp_ab<-sapply(read, function (x) {x$getElementText()})
temp_ab

result_songpa<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_songpa


if(end_page>=2){
  for(i in 2:end_page){
    
    page_numb<-paste("#wrap > div > p > a:nth-child(",i,")",sep="")
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dt > a')
    temp_title<-sapply(read, function (x) {x$getElementText()})
    #temp_title
    
    read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dd.site > span:nth-child(2)')
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    #temp_lib
    
    read <- remDr$findElements(using = "css", '#searchForm > ul > li > div > p > b')
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    #temp_ab
    
    result_songpa<-rbind(result_songpa, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
    
  }
}
result_songpa