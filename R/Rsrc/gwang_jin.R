library(RSelenium)
library(httr)
library(rvest)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

remDr$navigate("https://www.gwangjinlib.seoul.kr/intro.do")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#topSearchKeyword")
searchbar$sendKeysToElement(list(search))

searchbutton<-remDr$findElements(using='css', "#topSearchBtn")
sapply(searchbutton,function(x){x$clickElement()})

#전체 페이지 찾기
page <- remDr$findElements(using = "css", '#searchForm > div.pagingWrap > p > a')
pt<-sapply(page, function (x) {x$getElementText()})
page<-unlist(pt)
end_page<-as.numeric(max(page))
end_page


read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dt > a')
temp_title<-sapply(read, function (x) {x$getElementText()})
temp_title

read <- remDr$findElements(using = "css", ' #searchForm > ul > li > dl > dd.site > span:nth-child(1)')
temp_lib<-sapply(read, function (x) {x$getElementText()})
temp_lib

read <- remDr$findElements(using =  "css", "#searchForm > ul > li > div.bookStateBar.clearfix > p > b")
temp_ab<-sapply(read, function (x) {x$getElementText()})
temp_ab

result_gwangjin<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_gwangjin

if(end_page>=2){
  for(i in 2:end_page){
    page_numb<-paste("#searchForm > div.pagingWrap > p > a:nth-child(",i,") > a",sep="")
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dt > a')
    temp_title<-sapply(read, function (x) {x$getElementText()})
    temp_title
    
    read <- remDr$findElements(using = "css", ' #searchForm > ul > li > dl > dd.site > span:nth-child(1)')
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    temp_lib
    
    read <- remDr$findElements(using = "css", '#searchForm > ul > li > div.bookStateBar.clearfix > p > b')
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    temp_ab
    
    result_gwangjin<-rbind(result_gangdong, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
    
  }#
}
colnames(result_gwangjin)<- c("책이름", "도서관","대출가능여부")
result_gwangjin <- subset(result_gwangjin, subset = result_gwangjin$대출가능여부=="대출가능")
result_gwangjin
