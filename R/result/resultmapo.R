
library(XML)

library(dplyr)
library(rvest)
library(xml2)

key<-URLencode(iconv(search,"euc-kr","UTF-8"))
url<- "https://mplib.mapo.go.kr/mcl/MENU1039/PGM3007/plusSearchResultList.do?searchType=SIMPLE&searchCategory=BOOK&searchKey=ALL&searchKey1=&searchKey2=&searchKey3=&searchKey4=&searchKey5=&searchKeyword="
url2<-"&searchKeyword1=&searchKeyword2=&searchKeyword3=&searchKeyword4=&searchKeyword5=&searchOperator1=&searchOperator2=&searchOperator3=&searchOperator4=&searchOperator5=&searchPublishStartYear=&searchPublishEndYear=&searchLibrary=&searchRoom=&searchKdc=&searchEbookCategory=&searchSort=SIMILAR&searchOrder=DESC&searchRecordCount=10&currentPageNo="
#url3<- paste(url, key,url2,2,"&viewStatus=IMAGE&preSearchKey=ALL&preSearchKeyword=",key,"&reSearchYn=N&recKey=&bookKey=&publishFormCode=")

book <- NULL

for(i in 1: 4) {
  site<- paste(url, key,url2,i,"&viewStatus=IMAGE&preSearchKey=ALL&preSearchKeyword=",key,"&reSearchYn=N&recKey=&bookKey=&publishFormCode=",sep="")
  
  title = html_nodes(read_html(site), '#searchForm > ul > li > dl > dt > a')
  title <- html_text(title)
  
  sta = html_nodes(read_html(site), '#searchForm > ul > li > div.bookStateBar.clearfix > p > b')
  sta <- html_text(sta)
  
  temp_lib =html_nodes(read_html(site), '#searchForm > ul > li > dl > dd.site > span:nth-child(1)')
  temp_lib <- html_text(temp_lib)
  
  page <- cbind(title, sta, temp_lib)
  book <- rbind(book, page)
  
}
book<-data.frame(book)
book
str(book)
