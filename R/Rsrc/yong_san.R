library(RSelenium)
library(httr)
library(rvest)
library(XML)
remDr<-remoteDriver(remoteServerAddr="localhost", port=4445, browserName="chrome")
remDr$open()

remDr$navigate("https://www.yslibrary.or.kr/intro/index.do")

#검색창에 입력하고 넘어가기
searchbar<- remDr$findElement(using = "css", "#topSearchKeyword")
searchbar$sendKeysToElement(list(search))

searchbutton<-remDr$findElements(using='css', "#topSearchBtn > img")
sapply(searchbutton,function(x){x$clickElement()})

wholeLib<-remDr$findElements(using='css', "#searchLibrary")
sapply(wholeLib,function(x){x$clickElement()})

wholeLib_apply<-remDr$findElements(using='css', "#reSearchLibraryBtn")
sapply(wholeLib_apply,function(x){x$clickElement()})



#전체 페이지 찾기
page <- remDr$findElements(using = "css", '#searchForm > p > span')#첫장
pt <- sapply(page, function (x) {x$getElementText()})
pt <- gsub('.*-([0-9]+).*','\\1',pt)  #위 값 중 숫자만을 나열
pt <- strsplit(pt,split = " ")
pt <- as.numeric(pt[[1]][2])

end_page <- pt%/%10 + 1 #마지막 페이지값 == 자료의 수%/%10+1
end_page


read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dt > a')#책 제목
temp_title<-sapply(read, function (x) {x$getElementText()})
#temp_title

read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dd.site > span:nth-child(1)')#자료소유 도서관명
temp_lib<-sapply(read, function (x) {x$getElementText()})
#temp_lib

read <- remDr$findElements(using = "css", '#searchForm > ul > li > div.bookStateBar.clearfix > p > b')#대출가능 여부
temp_ab<-sapply(read, function (x) {x$getElementText()})
#temp_ab

result_yongsan<-data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab))
result_yongsan

if(end_page>=2){
  i<-2
    while(i <= end_page){
      
      present_page <- remDr$findElements(using = "css", '#searchForm > div.pagingWrap > p > span')#첫장
      present <- sapply(present_page, function (x) {x$getElementText()})
      present <- gsub('.*-([0-9]+).*','\\1',present)  #위 값 중 숫자만을 나열
      present <- as.numeric(present)
      if(present == end_page){
        break
      }else{
        
        if(i%%13==0){
          i<-2
          print(i)
          page_numb<-paste("#searchForm > div.pagingWrap > p > a:nth-child(",i,")",sep="")#반복문으로 전체 장
          searchbutton<-remDr$findElements(using='css',page_numb)
          sapply(searchbutton,function(x){x$clickElement()})
          
          read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dt > a')#책 제목
          temp_title<-sapply(read, function (x) {x$getElementText()})
          #temp_title
          
          read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dd.site > span:nth-child(1)')#자료소유 도서관명
          temp_lib<-sapply(read, function (x) {x$getElementText()})
          #temp_lib
          
          read <- remDr$findElements(using = "css", '#searchForm > ul > li:nth-child(2) > div.bookStateBar.clearfix > p > b')#대출가능 여부
          temp_ab<-sapply(read, function (x) {x$getElementText()})
          #temp_ab
          
          result_yongsan<-rbind(result_yongsan, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
          i = i + 1
          
        }
        print(i)
        page_numb<-paste("#searchForm > div.pagingWrap > p > a:nth-child(",i,")",sep="")#반복문으로 전체 장
        searchbutton<-remDr$findElements(using='css',page_numb)
        sapply(searchbutton,function(x){x$clickElement()})
        
        read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dt > a')#책 제목
        temp_title<-sapply(read, function (x) {x$getElementText()})
        #temp_title
        
        read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dd.site > span:nth-child(1)')#자료소유 도서관명
        temp_lib<-sapply(read, function (x) {x$getElementText()})
        #temp_lib
        
        read <- remDr$findElements(using = "css", '#searchForm > ul > li > div.bookStateBar.clearfix > p > b')#대출가능 여부
        temp_ab<-sapply(read, function (x) {x$getElementText()})
        #temp_ab
        
        result_yongsan<-rbind(result_yongsan, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
        i = i + 1
        
        if(i%%12 == 0){
          nextbtn <- remDr$findElements(using='css', "#searchForm > div.pagingWrap > p > a.btn-paging.next")  #다음 버트
          sapply(nextbtn, function(x){x$clickElement()})
          
          read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dt > a')#책 제목
          temp_title<-sapply(read, function (x) {x$getElementText()})
          #temp_title
          
          read <- remDr$findElements(using = "css", '#searchForm > ul > li > dl > dd.site > span:nth-child(1)')#자료소유 도서관명
          temp_lib<-sapply(read, function (x) {x$getElementText()})
          #temp_lib
          
          read <- remDr$findElements(using = "css", '#searchForm > ul > li > div.bookStateBar.clearfix > p > b')#대출가능 여부
          temp_ab<-sapply(read, function (x) {x$getElementText()})
          #temp_ab
          
          result_yongsan<-rbind(result_yongsan, data.frame(unlist(temp_title), unlist(temp_lib), unlist(temp_ab)))
          i = i + 1
      }
      
    }
  
  }
}

colnames(result_yongsan)<- c("책이름", "도서관","대출가능여부")
result_yongsan <- subset(result_yongsan, subset = result_yongsan$대출가능여부=="대출가능")
result_yongsan
