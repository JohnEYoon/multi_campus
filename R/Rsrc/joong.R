library(RSelenium)
library(httr)
library(rvest)
library(XML)
library(stringr)


remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

remDr$navigate("https://www.e-junggulib.or.kr/SJGL/")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#SrchKey")
searchbar$sendKeysToElement(list(search))

searchbutton<-remDr$findElements(using='css', "#search > form > fieldset > input")
sapply(searchbutton,function(x){x$clickElement()})

#전체 페이지 찾기
page <- remDr$findElements(using = "css", '#btn_count > a > font')#첫장
pt<-sapply(page, function (x) {x$getElementText()})
page<-unlist(pt)
end_page<-max(as.numeric(page))
#end_page


read <- remDr$findElements(using = "css", '#book_titletd > ul > li:nth-child(1) > span > a')#책 제목
temp_title<-sapply(read, function (x) {x$getElementText()})
#temp_title

read <- remDr$findElements(using = "css", '#book_titletd > ul > li:nth-child(3) > strong')#자료소유 도서관명
temp_lib<-sapply(read, function (x) {x$getElementText()})
#temp_lib

read <- remDr$findElements(using = "css", '#book_titletd > div > span > strong')#대출가능 여부
temp_ab<-sapply(read, function (x) {x$getElementText()})
#temp_ab

result_joong<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab),stringsAsFactors = FALSE)
result_joong


if(end_page>=2){
  for(i in 2:end_page){
    page_numb<-paste("#btn_count > a:nth-child(",i+2,") > font",sep="")#반복문으로 전체 장
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    read <- remDr$findElements(using = "css", '#book_titletd > ul > li:nth-child(1) > span > a')#책 제목
    temp_title<-sapply(read, function (x) {x$getElementText()})
    #temp_title
    
    read <- remDr$findElements(using = "css", '#book_titletd > ul > li:nth-child(3) > strong')#자료소유 도서관명
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    #temp_lib
    
    read <- remDr$findElements(using = "css", '#book_titletd > div > span > strong')#대출가능 여부
    temp_ab<-sapply(read, function (x) {x$getElementText()})
    #temp_ab
    
    result_joong<-rbind(result_joong, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab),stringsAsFactors = FALSE))
    
    if(i%%13 == 0){
      nextbtn <- remDr$findElements(using='css', "#btn_count > a:nth-child(13) > img")  #다음 버트
      sapply(nextbtn, function(x){x$clickElement()})
    }
    
  }
}
colnames(result_joong)<- c("책이름", "도서관","대출가능여부")
result_joong <- subset(result_joong, subset = result_joong$대출가능여부=="대출가능")
result_joong$도서관 <- str_sub(result_joong[, 2], start = 8, end = -1)  #도서관뒤의 대출상태를 떼어내서 저장
#result_joong <- result_joong[,-3] #대출가능한것만 추출했으니 대출가능여부는 제외하고 책이름, 도서관 두 가지만 표시
result_joong$도서관 <- str_replace_all(result_joong$도서관," ","")  #도서관 이름 열의 내,외부의 모든 공백제거
result_joong
