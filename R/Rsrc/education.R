library(RSelenium)
library(httr)
library(rvest)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

remDr$navigate("https://lib.sen.go.kr/lib/index.do?getContextPath=")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#search_text_1")  #검색창
searchbar$sendKeysToElement(list(search))

searchbutton<-remDr$findElements(using='css', "#main-search-btn") #검색버트
sapply(searchbutton,function(x){x$clickElement()})

#전체 페이지 찾기

page <- remDr$findElements(using = "css", '#board_paging > span > a') #페이지 전체
lp <- sapply(page, function (x) {x$getElementAttribute("keyvalue")})  #현재 페이지에 보이는 페이지(~10)+마지막페이지 값들
lp <- gsub('.*-([0-9]+).*','\\1',lp)  #위 값 중 숫자만을 나열
end_page <- max(as.numeric(lp)) #마지막 페이지값

read <- remDr$findElements(using = "css", '#contentArea > div > div.smain > div > div:nth-child(3) > ul > li > dl > dt > a')  #책 제목
temp_title<-sapply(read, function (x) {x$getElementText()})
#temp_title

read <- remDr$findElements(using = "css", '#contentArea > div > div.smain > div > div:nth-child(3) > ul > li > dl > dd.site > span:nth-child(1)') #자료소유 도서관명
temp_lib<-sapply(read, function (x) {x$getElementText()})
#temp_lib

read <- remDr$findElements(using = "css", '#contentArea > div > div.smain > div > div:nth-child(3) > ul > li > div.bookStateBar > p') #대출가능 여부
temp_ab<-sapply(read, function (x) {x$getElementText()})
#temp_ab

result_jongro<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_jongro



if(end_page>=2){
  for(i in 2:end_page){
    page_numb<-paste("#board_paging > span > a:nth-child(",i,")",sep="")#반복문으로 전체 장
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
      
    read <- remDr$findElements(using = "css", '#contentArea > div > div.smain > div > div:nth-child(3) > ul > li > dl > dt > a')#책 제목
    temp_title<-sapply(read, function (x) {x$getElementText()})
    #temp_title
      
    read <- remDr$findElements(using = "css", ' #contentArea > div > div.smain > div > div:nth-child(3) > ul > li > dl > dd.site > span:nth-child(1)')#자료소유 도서관명
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    #temp_lib
      
    read <- remDr$findElements(using = "css", '#contentArea > div > div.smain > div > div:nth-child(3) > ul > li > div.bookStateBar > p')#대출가능 여부
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    #temp_ab
      
    result_jongro<-rbind(result_jongro, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
    
    if(i%%10 == 0){
      nextbtn <- remDr$findElements(using='css', "#board_paging > span > a:nth-child(11)")  #다음 버트
      sapply(nextbtn, function(x){x$clickElement()})
    }

  }#
}
colnames(result_jongro)<- c("책이름", "도서관","대출가능여부")
result_jongro
result_jongro <- subset(result_jongro, subset = result_jongro$대출가능여부=="자료상태 : 대출가능")
result_jongro  
