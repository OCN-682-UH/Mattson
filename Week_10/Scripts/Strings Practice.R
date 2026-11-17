#Load Libraries
library(here)
library(tidytext)
library(tidyverse)
library(wordcloud)
library(janeaustenr)

vals <- c("a.b", "b.c", "c.d")
vals
str_replace(vals,"\\."," ")

newvals <- c("a.b.c","b.c.d","c.d.e")
newvals
str_replace_all(newvals,"\\."," ")

strings <- c("550-153-7578",
             "banana",
             "435.114.7586",
             "home: 672-442-6739")

str_replace_all(strings,"\\.","-")
strings

strings <- strings|>
  str_trim(strings,side = "both")

original_books <- austen_books()
head(original_books)

sent_word_count <- original_books|>
  inner_join(get_sentiments())|>
  count(word,sentiment,sort = TRUE)

head(sent_word_count)
