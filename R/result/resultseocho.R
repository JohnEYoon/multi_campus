#===================서초구 공공 도서관=========================



library(RSelenium)
library(httr)
library(rvest)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

remDr$navigate("http://public.seocholib.or.kr/docpub/")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#search")
searchbar$sendKeysToElement(list("정의란 무엇인가"))


searchbutton<-remDr$findElements(using='css', "#content > div > div > fieldset > form > button")
sapply(searchbutton,function(x){x$clickElement()})

#paging > div.paging > a.nnext
#전체 페이지 찾기
webElem<-remDr$findElements(using="css", "iframe")
remDr$switchToFrame(webElem[[1]])

#paging > div.total > strong:nth-child(2)


page <- remDr$findElements(using = "css", "#paging > div.total > strong:nth-child(2)")
pt<-sapply(page, function (x) {x$getElementText()})
pt


page<-unlist(pt)
page
end_page<-max(as.numeric(page))
end_page

#

#end_page



read <- remDr$findElements(using = "css", '#_searchListChk > div > dl > dd > div > a')
temp_title<-sapply(read, function (x) {x$getElementText()})
temp_title

read <- remDr$findElements(using = "css", '#_searchListChk > div > dl > dd > ul > li.so > span.fb.blue')
temp_lib<-sapply(read, function (x) {x$getElementText()})
temp_lib

#read <- remDr$findElements(using = "css", '#_searchListChk > div > dl > dd > ol > li:nth-child(2) > strong')
#temp_ab<-sapply(read, function (x) {x$getElementText()})
#temp_ab

result_seocho<-data.frame(unlist(temp_title), unlist(temp_lib))
result_seocho



if(end_page>=2){
  for(i in 2:end_page){
    
    page_numb<-paste("#paging > div.paging > a:nth-child(",i,")",sep="")
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    read <- remDr$findElements(using = "css", '#_searchListChk > div > dl > dd > div > a')
    temp_title<-sapply(read, function (x) {x$getElementText()})
    #temp_title
    
    
    read <- remDr$findElements(using = "css", '#_searchListChk > div > dl > dd > ul > li.so > span.fb.blue')
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    #temp_lib
    
    #read <- remDr$findElements(using = "css", '#_searchListChk > div > dl > dd > ol > li:nth-child(2) > strong')
    #temp_ab<-sapply(read, function (x) {x$getElementText()})
    #temp_ab
    
    result_seocho<-rbind(result_seocho, data.frame(unlist(temp_title), unlist(temp_lib)))
    
  }
}
result_seocho
