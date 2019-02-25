library(rvest)
library(RSelenium)
library(httr)
library(XML)
library(dplyr)
library(stringr)

remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

#_searchListChk > div > dl > dd > div > a

#================송파 도서관 =======================
remDr$navigate("http://www.splib.or.kr/")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#schMain > form > div > div > div.whiteBox > input")
searchbar$sendKeysToElement(list(search))


searchbutton<-remDr$findElements(using='css', "#schMain > form > div > div > div.btnBox > a > img")
sapply(searchbutton,function(x){x$clickElement()})

#전체 페이지 찾기
webElem<-remDr$findElements(using="css", "iframe")
remDr$switchToFrame(webElem[[1]])
page <- remDr$findElements(using = "css", "#wrap > div > p > a");
page
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

read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dd.site > span:nth-child(1)')
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
    
    read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dd.site > span:nth-child(1)')
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    #temp_lib
    
    read <- remDr$findElements(using = "css", '#searchForm > ul > li > div > p > b')
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    #temp_ab
    
    result_songpa<-rbind(result_songpa, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
    
  }
}

colnames(result_songpa)<- c("책이름", "도서관","대출가능여부")
result_songpa <- subset(result_songpa, subset = result_songpa$대출가능여부=="대출가능")
result_songpa$도서관 <- str_sub(result_songpa[, 2], start = 6, end = -1)  #도서관뒤의 대출상태를 떼어내서 저장
#result_songpa <- result_songpa[,-3] #대출가능한것만 추출했으니 대출가능여부는 제외하고 책이름, 도서관 두 가지만 표시
result_songpa <- data.frame(lapply(result_songpa, trimws), stringsAsFactors = FALSE)
result_songpa$도서관 <- str_replace_all(result_songpa$도서관," ","")  #도서관 이름 열의 내,외부의 모든 공백제거
result_songpa
