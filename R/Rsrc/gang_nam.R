library(RSelenium)
library(httr)
library(rvest)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

# 

remDr$navigate("http://lib.sdm.or.kr/main/main.asp")

searchbar<- remDr$findElement(using = "css", "[name= 'searchWord']")
searchbar$sendKeysToElement(list(search))

searchbutton<-remDr$findElements(using='css','#search > ul > li.btn > input')
sapply(searchbutton,function(x){x$clickElement()})

read <- remDr$findElements(using = "css", '#_searchListChk > div:nth-child(1) > dl > dt > a ')
sapply(read, function (x) {x$clickElement()})
#getElementText()})

####강남도서관 - lib과 able을 분리해줘야함

remDr$navigate("https://library.gangnam.go.kr/")

searchbar<- remDr$findElement(using = "css", "[name= 'q']")
searchbar$sendKeysToElement(list("정의란 무엇인가"))

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




result_gangnam<-data.frame((temp_title), unlist(temp_lib), unlist(temp_ab))
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
result_gangnam
