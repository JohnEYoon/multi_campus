library(RSelenium)
library(httr)
library(rvest)
library(stringr)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

remDr$navigate("http://lib.dongjak.go.kr/dj/index.do")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#search_text_1")  #검색창
searchbar$sendKeysToElement(list(search))

searchbutton<-remDr$findElements(using='css', "#main-search-btn") #검색버트
sapply(searchbutton,function(x){x$clickElement()})

#전체 페이지 찾기

page <- remDr$findElements(using = "css", '#cms_paging > span > a') #페이지 전체
lp <- sapply(page, function (x) {x$getElementAttribute("keyvalue")})  #현재 페이지에 보이는 페이지(~10)+마지막페이지 값들
lp <- gsub('.*-([0-9]+).*','\\1',lp)  #위 값 중 숫자만을 나열
end_page <- max(as.numeric(lp)) #마지막 페이지값

read <- remDr$findElements(using = "css", '#search-results > div > div.box > div > div.bif > a')  #책 제목
temp_title<-sapply(read, function (x) {x$getElementText()})
#temp_title

read <- remDr$findElements(using = "css", '#search-results > div > div.box > div > div.bif > p:nth-child(5)') #자료소유 도서관명
temp_lib<-sapply(read, function (x) {x$getElementText()})
#temp_lib

read <- remDr$findElements(using = "css", '#search-results > div > table > tbody > tr > td.first.td1') #대출가능 여부
temp_ab<-sapply(read, function (x) {x$getElementText()})
#temp_ab

result_dongjak<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_dongjak



if(end_page>=2){
  for(i in 2:end_page){
    page_numb<-paste("#cms_paging > span > a:nth-child(",i,")",sep="")#반복문으로 전체 장
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
      
    read <- remDr$findElements(using = "css", '#search-results > div > div.box > div > div.bif > a')#책 제목
    temp_title<-sapply(read, function (x) {x$getElementText()})
    #temp_title
      
    read <- remDr$findElements(using = "css", ' #search-results > div > div.box > div > div.bif > p:nth-child(5)')#자료소유 도서관명
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    #temp_lib
      
    read <- remDr$findElements(using = "css", '#search-results > div > table > tbody > tr > td.first.td1') #대출가능 여부
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    #temp_ab
    
    result_dongjak<-rbind(result_dongjak, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
    
    if(i%%10 == 0){
      nextbtn <- remDr$findElements(using='css', "#cms_paging > span > a:nth-child(11)")  #다음 버ㅌ
      sapply(nextbtn, function(x){x$clickElement()})
    }
      
  }#
}

colnames(result_dongjak)<- c("책이름", "도서관","대출가능여부")
result_dongjak
result_dongjak <- subset(result_dongjak, subset = result_dongjak$대출가능여부=="대출가능\n(비치중)")
result_dongjak$도서관 <- str_sub(result_dongjak[, 2], start = 9, end = -1)  #도서관뒤의 대출상태를 떼어내서 저장
#result_dongjak <- result_dongjak[,-3] #대출가능한것만 추출했으니 대출가능여부는 제외하고 책이름, 도서관 두 가지만 표시
result_dongjak$도서관 <- str_replace_all(result_dongjak$도서관," ","")  #도서관 이름 열의 내,외부의 모든 공백제거
result_dongjak

