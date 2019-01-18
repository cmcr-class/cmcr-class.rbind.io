On dplyr:
    https://en.wikipedia.org/wiki/Little_Bunny_Foo_Foo


On scraping:
    
    http://juliasilge.com/blog/Who-Came-To-Vote/ on purrr (and jsonlite)

what I gave Hu:
    #rmrbw_scrape.R
    
    library(XML)
# library(stringr)

# Load top page
corpus <- ""

url1 <- "http://rmrbw.info"  
pe1 <- readLines(url1, encoding = "gbk")          # read in html of home page

home.lines <- grep("href=\\\"thread.php\\?fid=", pe1, value=T, useBytes=T) #find lines with links to months
home.lines1 <- gsub("\\\" class.*", "", home.lines, useBytes=T) # strip out chars following the thread
month.links <- gsub(".*href=\\\"", "http://rmrbw.info/", home.lines1, useBytes=T) # replace chars preceding thread
month.names <- gsub(".*([0-9]{4})\xc4\xea([0-9]{2}).*", "\\1 \\2", home.lines)

for(month in 1:length(month.links)) {
    corpus <- c(corpus, month.names[month])
    cat("Processing", month.names[month], "\n")
    month.page <- readLines(month.links[month], encoding = "gbk") # read in html of first month page
    total.line <- grep("var totalpage", month.page, useBytes=T) # find the line with the total pages
    total.pages <- gsub("[^0-9]*([0-9]+).*", "\\1", month.page[total.line]) # get the number of total pages
    month.pages <- paste0(month.links[month], "&page=", 1:total.pages)
    
    for(page in 1:length(month.pages)) {
        threads.page <- readLines(month.pages[page])
        threads.lines <- grep("<h3>", threads.page, value=T, useBytes=T)
        threads.lines1 <- gsub("\\\" id=.*", "", threads.lines, useBytes=T) # strip out chars following the thread
        threads.links <- gsub(".*href=\\\"", "http://rmrbw.info/", threads.lines1, useBytes=T)
        
        for (thread in 1:length(threads.links)) {
            thread.page <- readLines(threads.links[thread])
            thread.text <- grep("^(\\\t)+[\x80-\xFF].*[^>]$", thread.page, value=T, useBytes=T)
            corpus <- c(corpus, thread.text)
        }        
    }
}



