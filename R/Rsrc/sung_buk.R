library(RSelenium)
install.packages("stringr")
library(stringr)

remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

#_searchListChk > div > dl > dd > div > a

#================성북 정보 도서관 =======================
remDr$navigate("https://www.sblib.seoul.kr/library/index.do")

#검색창에 입력하고 넘어가기
#searchbutton<-remDr$findElements(using='css', "#btnSearchTop > a > img")
#sapply(searchbutton,function(x){x$clickElement()})

search<-"정의란 무엇인가"
searchbar<- remDr$findElement(using = "css", "#topQuery")
searchbar$sendKeysToElement(list(search))


searchbutton<-remDr$findElements(using='css', "#searchBox > div.btnSearch > span > a")
sapply(searchbutton,function(x){x$clickElement()})

#전체 페이지 찾기
searchbutton<-remDr$findElements(using='css', '#contents > div > div.pagingWrap > p > a.btn-paging.last')
sapply(searchbutton,function(x){x$clickElement()})

page <- remDr$findElements(using = "css", '#contents > div > div.pagingWrap > p > a:nth-child(10)')
pt<-sapply(page, function (x) {x$getElementText()})
pt

page<-unlist(pt)
page
end_page<-as.numeric(page)
end_page

#end_page


read <- remDr$findElements(using = "css", '#basketForm > ul > li > dl > dt > a')
temp_title<-sapply(read, function (x) {x$getElementText()})
#temp_title

read <- remDr$findElements(using = "css", '#basketForm > ul > li > dl > dd.site > span:nth-child(1)')
temp_lib<-sapply(read, function (x) {x$getElementText()})
#temp_lib

read <- remDr$findElements(using = "css", '#basketForm > ul > li > div.bookStateBar.clearfix > p > b')
temp_ab<-sapply(read, function (x) {x$getElementText()})
#temp_ab

result_seongbuk<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_seongbuk


if(end_page>=2){
  for(i in 4:end_page){
    page_numb<-paste("#contents > div > div.pagingWrap > p > a:nth-child(",i,") > a",sep="")
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    read <- remDr$findElements(using = "css", '#basketForm > ul > li > dl > dt > a')
    temp_title<-sapply(read, function (x) {x$getElementText()})
    #temp_title
    
    read <- remDr$findElements(using = "css", '#basketForm > ul > li > dl > dd.site > span:nth-child(1)')
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    #temp_lib
    
    read <- remDr$findElements(using = "css", '#basketForm > ul > li > div.bookStateBar.clearfix > p > b')
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    #temp_ab
    
    result_seongbuk<-rbind(result_seongbuk, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
    
  }
}
colnames(result_seongbuk)<- c("책이름", "도서관","대출가능여부")
result_seongbuk <- subset(result_seongbuk, subset = result_seongbuk$대출가능여부=="대출가능")
result_seongbuk$도서관 <- str_sub(result_seongbuk[, 2], start = 6, end = -1)  #도서관뒤의 대출상태를 떼어내서 저장
result_seongbuk <- result_seongbuk[,-3] #대출가능한것만 추출했으니 대출가능여부는 제외하고 책이름, 도서관 두 가지만 표시
result_seongbuk$도서관 <- str_replace_all(result_seongbuk$도서관," ","")  #도서관 이름 열의 내,외부의 모든 공백제거
result_seongbuk  

#result_seongbuk