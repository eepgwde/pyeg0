## weaves

## https://cran.r-project.org/web/packages/tidytext/vignettes/topic_modeling.html

## You need to use a later dplyr than Debian 9.0 

library(dplyr)
library(gutenbergr)

library(tidytext)

library(stringr)

library(tidyr)

library(topicmodels)

library(ggplot2)

## Get some samples.
## Split by chapter. Add markers title-chapter.

titles <- c("Twenty Thousand Leagues under the Sea", "The War of the Worlds",
            "Pride and Prejudice", "Great Expectations")
books <- gutenberg_works(title %in% titles) %>%
    gutenberg_download(meta_fields = "title")

books

by_chapter <- books %>%
  group_by(title) %>%
  mutate(chapter = cumsum(str_detect(text, regex("^chapter ", ignore_case = TRUE)))) %>%
  ungroup() %>%
  filter(chapter > 0)

by_chapter_word <- by_chapter %>%
  unite(title_chapter, title, chapter) %>%
  unnest_tokens(word, text)

## Use anti_join with stop_words
word_counts <- by_chapter_word %>%
  anti_join(stop_words) %>%
  count(title_chapter, word, sort = TRUE)

word_counts

## Form into DocumentTermMatrix from the tidytext package.

chapters_dtm <- word_counts %>%
  cast_dtm(title_chapter, word, n)

chapters_dtm

chapters_lda <- LDA(chapters_dtm, k = 4, control = list(seed = 1234))
chapters_lda

chapters_lda_td <- tidy(chapters_lda)
chapters_lda_td

top_terms <- chapters_lda_td %>%
  group_by(topic) %>%
  top_n(5, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

top_terms

theme_set(theme_bw())

top_terms %>%
  mutate(term = reorder(term, beta)) %>%
  ggplot(aes(term, beta)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ topic, scales = "free") +
    theme(axis.text.x = element_text(size = 15, angle = 90, hjust = 1))

chapters_lda_gamma <- tidy(chapters_lda, matrix = "gamma")
chapters_lda_gamma

chapters_lda_gamma <- chapters_lda_gamma %>%
  separate(document, c("title", "chapter"), sep = "_", convert = TRUE)
chapters_lda_gamma

ggplot(chapters_lda_gamma, aes(gamma, fill = factor(topic))) +
  geom_histogram() +
    facet_wrap(~ title, nrow = 2)

chapter_classifications <- chapters_lda_gamma %>%
  group_by(title, chapter) %>%
  top_n(1, gamma) %>%
  ungroup() %>%
  arrange(gamma)

chapter_classifications

book_topics <- chapter_classifications %>%
  count(title, topic) %>%
  group_by(topic) %>%
  top_n(1, n) %>%
  ungroup() %>%
  transmute(consensus = title, topic)

book_topics

chapter_classifications %>%
  inner_join(book_topics, by = "topic") %>%
    count(title, consensus)

assignments <- augment(chapters_lda, data = chapters_dtm)

assignments <- assignments %>%
  separate(document, c("title", "chapter"), sep = "_", convert = TRUE) %>%
  inner_join(book_topics, by = c(".topic" = "topic"))

assignments

assignments %>%
  count(title, consensus, wt = count) %>%
    spread(consensus, n, fill = 0)

wrong_words <- assignments %>%
  filter(title != consensus)

wrong_words

wrong_words %>%
  count(title, consensus, term, wt = count) %>%
    arrange(desc(n))

word_counts %>%
    filter(word == "flopson")

