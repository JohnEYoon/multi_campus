library(RSelenium)
library(httr)
library(rvest)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

remDr$navigate("http://lib.guro.go.kr/#/")

#검색창에 입력하고 넘어가기
popupbutton<-remDr$findElements(using='css', "body > div.k-widget.k-window > div.k-intro-popup.k-window-content.k-content > div.window-footer > a")
sapply(popupbutton,function(x){x$clickElement()})

searchbar<- remDr$findElement(using = "css", "#keyword")
searchbar$sendKeysToElement(list(search))

searchbutton<-remDr$findElements(using='css', "body > div.ikc-pyxis-wrap > div.ikc-container-wrap > div.ikc-header-wrap > div.ikc-imagezone-wrap > div > form > button")
sapply(searchbutton,function(x){x$clickElement()})

#전체 페이지 찾기
searchbutton<-remDr$findElements(using='css', "a[ng-click='pagination.lastPage()'")
pt<-sapply(searchbutton,function(x){x$clickElement()})
last<- remDr$findElements(using = 'css',"body > div.ikc-pyxis-wrap > div.ikc-container-wrap > div.ikc-container > div > div.ikc-main > div.ikc-search-layout > div.ikc-search-result > div > div:nth-child(3) > div:nth-child(5) > div > a.active")
lastpage <-sapply(last, function(x){x$getElementText()})
#lastpage
lastpage<-unlist(lastpage)
page<- as.numeric(lastpage)
#page

first<- remDr$findElements(using = 'css',"body > div.ikc-pyxis-wrap > div.ikc-container-wrap > div.ikc-container > div > div.ikc-main > div.ikc-search-layout > div.ikc-search-result > div > div:nth-child(3) > div:nth-child(5) > div > a:nth-child(1)")
firstpage <- sapply(first, function(x){x$clickElement()})

#temp_title
read <- remDr$findElements(using = "css", 'body > div.ikc-pyxis-wrap > div.ikc-container-wrap > div.ikc-container > div > div.ikc-main > div.ikc-search-layout > div.ikc-search-result > div > div:nth-child(3) > div.ikc-search-result > div > div.ikc-item-info > ul > li:nth-child(1) > a.ikc-item-title > span')
temp_title<-sapply(read, function (x) {x$getElementText()})

#temp_lib     

read <- remDr$findElements(using = "css", 'body > div.ikc-pyxis-wrap > div.ikc-container-wrap > div.ikc-container > div > div.ikc-main > div.ikc-search-layout > div.ikc-search-result > div > div:nth-child(3) > div.ikc-search-result > div > div.ikc-item-info > ul > li.ikc-item-branchvolumes > ul > li:nth-child(1) > span.ikc-item-branch')
temp_lib<-sapply(read, function (x) {x$getElementText()})

#temp_ab

read <- remDr$findElements(using = "css", 'body > div.ikc-pyxis-wrap > div.ikc-container-wrap > div.ikc-container > div > div.ikc-main > div.ikc-search-layout > div.ikc-search-result > div > div:nth-child(3) > div.ikc-search-result > div > div.ikc-item-info > ul > li.ikc-item-branchvolumes > ul > li:nth-child(1) > div > a.hidden-xs > span.ikc-item-status')
temp_ab<-sapply(read, function (x) {x$getElementText()})

result_guro<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_guro

#오류발생
temp<-3+page
if(lastpage>=2){
  for(i in 5: temp){
    page_numb<-paste("body > div.ikc-pyxis-wrap > div.ikc-container-wrap > div.ikc-container > div > div.ikc-main > div.ikc-search-layout > div.ikc-search-result > div > div:nth-child(3) > div:nth-child(5) > div > a:nth-child(",i,")",sep="")
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    
    read <- remDr$findElements(using = "css", 'body > div.ikc-pyxis-wrap > div.ikc-container-wrap > div.ikc-container > div > div.ikc-main > div.ikc-search-layout > div.ikc-search-result > div > div:nth-child(3) > div.ikc-search-result > div > div.ikc-item-info > ul > li:nth-child(1) > a.ikc-item-title > span')
    temp_title<-sapply(read, function (x) {x$getElementText()})
    temp_title
    
    read <- remDr$findElements(using = "css", 'body > div.ikc-pyxis-wrap > div.ikc-container-wrap > div.ikc-container > div > div.ikc-main > div.ikc-search-layout > div.ikc-search-result > div > div:nth-child(3) > div.ikc-search-result > div:nth-child(1) > div.ikc-item-info > ul > li.ikc-item-branchvolumes > ul > li:nth-child(1) > span.ikc-item-branch')
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    temp_lib
    
    read <- remDr$findElements(using = "css", 'body > div.ikc-pyxis-wrap > div.ikc-container-wrap > div.ikc-container > div > div.ikc-main > div.ikc-search-layout > div.ikc-search-result > div > div:nth-child(3) > div.ikc-search-result > div > div.ikc-item-info > ul > li.ikc-item-branchvolumes > ul > li:nth-child(1) > div > a.hidden-xs > span.ikc-item-status')
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    #temp_ab
    result_guro_2<- data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
    #result_guro_2
    result_guro<-rbind(result_guro, result_guro_2)
    
  }
}
result_guro