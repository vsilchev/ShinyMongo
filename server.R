library(shiny)
library(twitteR)
library(wordcloud)
library(memoise)
library(RColorBrewer)
library(tm)

consumer_key <- 'mb9dd507QabhpxtJBmRQxeteJ'
consumer_secret <- 'qxC4e4Gm44fggsfLNqkBH5wxzHDaUGhlwcGwNqrZktneyMN4N8'
access_token <- '31374068-NNsqMgoiWCqcVvk59gm8ZGCUoTxOHcStoWBaEhsci'
access_secret <- 'Q2uKV4EHPjAP3FY8jsC5lagwHe365hZncZZDk57T82lau'
setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

getTermMatrix <- memoise(function(q, numberOfTweets = 1500) {
  res <- searchTwitter(q, n = numberOfTweets)
  resText <- sapply(res, function(x) x$getText())
  resCorpus <- Corpus(VectorSource(resText)) #create corpus
  #clean up
  resCorpus <- tm_map(resCorpus,
                      content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')),
                      mc.cores=1)
  resCorpus <- tm_map(resCorpus, content_transformer(tolower), mc.cores=1)
  # remove  URLs
  removeURL <- function(x) gsub("http[^[:space:]]*", "", x)
  resCorpus <- tm_map(resCorpus, content_transformer(removeURL), mc.cores=1)
  resCorpus <- tm_map(resCorpus, removePunctuation, mc.cores=1)
  #add twitter-cpecific stop-words "via", "available"
  myStopWords <- c(stopwords('english'), "available", "via")
  resCorpus <- tm_map(resCorpus, removeWords, myStopWords, mc.cores=1)
  myDTM = TermDocumentMatrix(resCorpus, control = list(minWordLength = 1))
  
  m = as.matrix(myDTM)
  
  sort(rowSums(m), decreasing = TRUE)
})

shinyServer(function(input, output) {
  
  # builds a reactive expression that only invalidates 
  # when the value of input$goButton becomes out of date 
  # (i.e., when the button is pressed)
  terms <- eventReactive(input$go, {
    isolate({
      withProgress({
        setProgress(message = "Searching tweets...")
        getTermMatrix(input$searchQuery, 1500)
      })
    })
  })
  
  output$plot <- renderPlot({
    v <- terms()
    wordcloud(word = names(v), freq = v, scale=c(4,0.5),
                  min.freq = input$freq, max.words=input$max,
                  colors=brewer.pal(8, "Dark2"))
  })
})