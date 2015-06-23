library("twitteR")
library("wordcloud")
library("tm")

consumer_key <- 'mb9dd507QabhpxtJBmRQxeteJ'
consumer_secret <- 'qxC4e4Gm44fggsfLNqkBH5wxzHDaUGhlwcGwNqrZktneyMN4N8'
access_token <- '31374068-NNsqMgoiWCqcVvk59gm8ZGCUoTxOHcStoWBaEhsci'
access_secret <- 'Q2uKV4EHPjAP3FY8jsC5lagwHe365hZncZZDk57T82lau'


#the cainfo parameter is necessary only on Windows
res <- searchTwitter("#Europe", n=1500)
length(res)
#save text
resText <- sapply(res, function(x) x$getText())

#create corpus
resCorpus <- Corpus(VectorSource(resText))

#clean up
resCorpus <- tm_map(resCorpus,
                    content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')),
                    mc.cores=1)
resCorpus <- tm_map(resCorpus, content_transformer(tolower), mc.cores=1) 
resCorpus <- tm_map(resCorpus, removePunctuation, mc.cores=1)

#add twitter-cpecific stop-words "via", "available"
myStopWords <- c(stopwords('english'), "available", "via")
resCorpus <- tm_map(resCorpus, removeWords, myStopWords, mc.cores=1)
library(RColorBrewer)
palett<- brewer.pal(8,"Accent")
wordcloud(resCorpus,min.freq=5,max.words=20, random.order=T, colors=palett)
#if you get the below error
#In mclapply(content(x), FUN, ...) :
#  all scheduled cores encountered errors in user code
#add mc.cores=1 into each function

#run this step if you get the error:
#(please break it!)' in 'utf8towcs'
resCorpus <- tm_map(resCorpus,
                    content_transformer(function(x) iconv(x, to='UTF-8-MAC', sub='byte')),
                    mc.cores=1
)
resCorpus <- tm_map(resCorpus, content_transformer(tolower), mc.cores=1)
resCorpus <- tm_map(resCorpus, removePunctuation, mc.cores=1)
resCorpus <- tm_map(resCorpus, function(x)removeWords(x,stopwords()), mc.cores=1)
wordcloud(resCorpus)
