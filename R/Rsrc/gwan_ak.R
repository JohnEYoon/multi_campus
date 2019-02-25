library(RSelenium)
library(httr)
library(rvest)
library(XML)
library(stringr)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

remDr$navigate("http://lib.gwanak.go.kr/")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#mainsearch")
searchbar$sendKeysToElement(list(search))

searchbutton<-remDr$findElements(using='css', "#search > form:nth-child(3) > fieldset > input.inbtn")
sapply(searchbutton,function(x){x$clickElement()})

#전체 페이지 찾기
webElem<-remDr$findElements(using="css", "iframe")
remDr$switchToFrame(webElem[[1]])
page <- remDr$findElements(using = "css", '#im > table:nth-child(18) > tbody > tr > td:nth-child(2) > a')
pt<-sapply(page, function (x) {x$getElementText()})
pt
page<-unlist(pt)
end_page<-as.numeric(max(page))
end_page


read <- remDr$findElements(using = "css", '#im > table.stable_list > tbody > tr> td:nth-child(2) > a')
temp_title<-sapply(read, function (x) {x$getElementText()})


read <- remDr$findElements(using = "css", ' #im > table.stable_list > tbody > tr > td:nth-child(6)')
temp_lib<-sapply(read, function (x) {x$getElementText()})


read <- remDr$findElements(using = "css", '#im > table.stable_list > tbody > tr > td:nth-child(7)')
temp_ab<-sapply(read, function (x) {x$getElementText()})


result_gwanak<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))


if(end_page>=2){
  for(i in 2:end_page){
    
    page_numb<-paste("#im > table:nth-child(18) > tbody > tr > td:nth-child(2) > a:nth-child(",i,")",sep="")
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    read <- remDr$findElements(using = "css", '#im > table.stable_list > tbody > tr> td:nth-child(2) > a')
    temp_title<-sapply(read, function (x) {x$getElementText()})
  
    read <- remDr$findElements(using = "css", ' #im > table.stable_list > tbody > tr > td:nth-child(6)')
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    
    read <- remDr$findElements(using = "css", '#im > table.stable_list > tbody > tr > td:nth-child(7)')
    temp_ab<-sapply(read, function (x) {x$getElementText()})

    result_gwanak<-rbind(result_gwanak, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
      
  }
}
colnames(result_gwanak)<- c("책이름", "도서관","대출가능여부")
result_gwanak <- subset(result_gwanak, subset = result_gwanak$대출가능여부=="대출가능")
#여긴 스플릿

#result_gwanak <- result_gwanak[,-3] #대출가능한것만 추출했으니 대출가능여부는 제외하고 책이름, 도서관 두 가지만 표시
result_gwanak$도서관 <- data.frame(do.call('rbind', strsplit(as.character(result_gwanak$도서관), split='\n', fixed=T)))[,1]
result_gwanak$도서관 <- str_replace_all(result_gwanak$도서관," ","")  #도서관 이름 열의 내,외부의 모든 공백제거
result_gwanak
