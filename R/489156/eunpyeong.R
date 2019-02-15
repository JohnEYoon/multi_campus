library(RSelenium)
library(httr)
library(rvest)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

remDr$navigate("http://www.eplib.or.kr/unified/search.asp?p=1&serviceName=SimpleSearch")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#txtValue1")
searchbar$sendKeysToElement(list("베르나르"))

searchbutton<-remDr$findElements(using='css', "#searchForm > strong > strong > div.total_srch.bg > div.total_box_wrapper > div.total_box > div > input.unified_search_btn")
sapply(searchbutton,function(x){x$clickElement()})



#전체 페이지 찾기
page <- remDr$findElements(using = "css", '#pagination > div > a > span')#첫장
pt<-sapply(page, function (x) {x$getElementText()})

pt <- gsub('.*-([0-9]+).*','\\1',pt)

end_page <- as.numeric(max(pt))
#end_page


read <- remDr$findElements(using = "css", '#content_list > li > dl > dt > a')#책 제목
temp_title<-sapply(read, function (x) {x$getElementText()})
#temp_title

read <- remDr$findElements(using = "css", '#booklib')#자료소유 도서관명
temp_lib<-sapply(read, function (x) {x$getElementText()})
#temp_lib

result_eunpyeong<-data.frame(unlist(temp_title), unlist(temp_lib))
result_eunpyeong

if(end_page>=2){
  for(i in 2:end_page){
    page_numb<-paste("#pagination > div > a:nth-child(",i+1,") > span",sep="")#반복문으로 전체 장
    searchbutton<-remDr$findElements(using='css',page_numb)
    sapply(searchbutton,function(x){x$clickElement()})
    
    read <- remDr$findElements(using = "css", '#content_list > li > dl > dt > a')#책 제목
    temp_title<-sapply(read, function (x) {x$getElementText()})
    #temp_title
    
    read <- remDr$findElements(using = "css", '#booklib')#자료소유 도서관명
    temp_lib<-sapply(read, function (x) {x$getElementText()})
    #temp_lib
    
    result_eunpyeong<-rbind(result_eunpyeong, data.frame(unlist(temp_title), unlist(temp_lib)))
    
  }#
}

result_eunpyeong
#result_eunpyeong

