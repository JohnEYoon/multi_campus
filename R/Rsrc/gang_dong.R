library(RSelenium)
library(httr)
library(rvest)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

remDr$navigate("http://www.gdlibrary.or.kr")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#searchKeyword")
searchbar$sendKeysToElement(list(search))

searchbutton<-remDr$findElements(using='css', "#searchBox > div > div.btnRight > input[type='image']")
sapply(searchbutton,function(x){x$clickElement()})

#전체 페이지 찾기
page <- remDr$findElements(using = "css", '#contents > div.pgeAbs2.mt30 > p > span> a')
pt<-sapply(page, function (x) {x$getElementText()})
page<-unlist(pt)
end_page<-as.numeric(max(page))
#end_page


read <- remDr$findElements(using = "css", '#contents > ul > li > dl > dt > a')
temp_title<-sapply(read, function (x) {x$getElementText()})
#temp_title

read <- remDr$findElements(using = "css", ' #contents > ul > li > dl > dd:nth-child(9) > span')
temp_lib<-sapply(read, function (x) {x$getElementText()})
#temp_lib

read <- remDr$findElements(using = "css", '#contents > ul > li > dl > dd.bookState > span > strong')
temp_ab<-sapply(read, function (x) {x$getElementText()})
#temp_ab

result_gangdong<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_gangdong

if(end_page>=2){
  for(i in 2:end_page){
    page_numb<-paste("#contents > div.pgeAbs2.mt30 > p > span:nth-child(",i,") > a",sep="")
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    read <- remDr$findElements(using = "css", '#contents > ul > li > dl > dt > a')
    temp_title<-sapply(read, function (x) {x$getElementText()})
    #temp_title
    
    read <- remDr$findElements(using = "css", ' #contents > ul > li > dl > dd:nth-child(9) > span')
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    #temp_lib
    
    read <- remDr$findElements(using = "css", '#contents > ul > li > dl > dd.bookState > span > strong')
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    #temp_ab
    
    result_gangdong<-rbind(result_gangdong, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
    
  }#
}
colnames(result_gangdong)<- c("책이름", "도서관","대출가능여부")
result_gangdong <- subset(result_gangdong, subset = result_gangdong$대출가능여부=="대출가능")
result_gangdong
