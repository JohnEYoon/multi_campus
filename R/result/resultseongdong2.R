#====================성동 구립 도서관=========================



library(RSelenium)
library(httr)
library(rvest)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

remDr$navigate("https://www.sdlib.or.kr/SD/")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#mbody1 > ul > li.m_search_1 > form > ol > li:nth-child(3) > input[type='text']")
searchbar$sendKeysToElement(list("정의란 무엇인가"))


searchbutton<-remDr$findElements(using='css', "#mbody1 > ul > li.m_search_1 > form > ol > li:nth-child(4) > input[type='image']")
sapply(searchbutton,function(x){x$clickElement()})


#전체 페이지 찾기
end_page<-10


#end_page



read <- remDr$findElements(using = "css", '#contents > ul > li.wmid3 > ol > li.booktitle.left > a > font')
temp_title<-sapply(read, function (x) {x$getElementText()})
temp_title

read <- remDr$findElements(using = "css", '#contents > ul > li.wmid3 > ol > li:nth-child(12)')
temp_lib<-sapply(read, function (x) {x$getElementText()})
temp_lib

read <- remDr$findElements(using = "css", '#contents > ul > li.wmid3 > ol > li:nth-child(8)')
temp_ab<-sapply(read, function (x) {x$getElementText()})
temp_ab

result_seong<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_seong



if(end_page>=2){
  for(i in 2:end_page){
    
    page_numb<-paste("#contents > ul:nth-child(20) > li > a:nth-child(",i,")",sep="")
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    read <- remDr$findElements(using = "css", '#contents > ul > li.wmid3 > ol > li.booktitle.left > a > font')
    temp_title<-sapply(read, function (x) {x$getElementText()})
    #temp_title
   
    
    read <- remDr$findElements(using = "css", '#contents > ul > li.wmid3 > ol > li:nth-child(12)')
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    #temp_lib
    
    read <- remDr$findElements(using = "css", '#contents > ul > li.wmid3 > ol > li:nth-child(8)')
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    #temp_ab
    
    result_seong<-rbind(result_seong, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
    
  }
}
result_seong