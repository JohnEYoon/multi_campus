library(RSelenium)
library(httr)
library(rvest)
library(XML)
library(stringr)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

#_searchListChk > div > dl > dd > div > a

#================서대문 구립 도서관 =======================
remDr$navigate("http://lib.sdm.or.kr/main/main.asp")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#searchWord")
searchbar$sendKeysToElement(list(search))


searchbutton<-remDr$findElements(using='css', "#search > ul > li.btn > input")
sapply(searchbutton,function(x){x$clickElement()})
#paging > div.paging > a:nth-child(4)

#전체 페이지 찾기
webElem<-remDr$findElements(using="css", "iframe")
remDr$switchToFrame(webElem[[1]])

end_page <- remDr$findElements(using = "css", "#paging > div.total > strong:nth-child(2)");page
end_page<-sapply(end_page, function (x) {x$getElementText()})
end_page<-as.numeric(end_page)


#end_page



read <- remDr$findElements(using = "css", '#_searchListChk > div > dl > dd > div.ico.ico-bk > a')
temp_title<-sapply(read, function (x) {x$getElementText()})
temp_title

read <- remDr$findElements(using = "css", '#_searchListChk > div > dl > dd > ul > li.so > span.fb.blue')
temp_lib<-sapply(read, function (x) {x$getElementText()})
temp_lib

read <- remDr$findElements(using = "css", '#_searchListChk > div > dl > dd > ol > li:nth-child(1) > strong')
temp_ab<-sapply(read, function (x) {x$getElementText()})
temp_ab

result_seomoon<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_seomoon


if(end_page>=2){
  for(i in 2:end_page){
    
    page_numb<-paste("#paging > div.paging > a:nth-child(",i,")",sep="")
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    read <- remDr$findElements(using = "css", '#_searchListChk > div > dl > dd > div.ico.ico-bk > a')
    temp_title<-sapply(read, function (x) {x$getElementText()})
    #temp_title
    
    read <- remDr$findElements(using = "css", '#_searchListChk > div > dl > dd > ul > li.so > span.fb.blue')
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    #temp_lib
    
    read <- remDr$findElements(using = "css", '#_searchListChk > div > dl > dd > ol > li:nth-child(1) > strong')
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    #temp_ab
    
    result_seomoon<-rbind(result_seomoon, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
    
  }
}
colnames(result_seomoon)<- c("책이름", "도서관","대출가능여부")
result_seomoon <- subset(result_seomoon, subset = result_seomoon$대출가능여부=="대출가능")
#result_seomoon <- result_seomoon[-3]
result_seomoon$도서관 <- str_replace_all(result_seomoon$도서관," ","")  #도서관 이름 열의 내,외부의 모든 공백제거
result_seomoon