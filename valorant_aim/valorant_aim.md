---
title: "Valorant Aim"
author: "Ignacio Peletier"
date: "November 13, 2021"
output: pdf_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
library(ggplot2)


data <- read.table("data.txt")
colnames(data) <- c("1", "weapon", "distance", "bots.down", "robots.down.prop", "index")



data$weapon <- factor(data$weapon, levels =  c('Sheriff', 'Phantom', 'Vandal'))
```

## Introduction


## Experiment


```{r plots, echo=FALSE}
ggplot(data) +
  geom_boxplot(aes(x=weapon, y=bots.down, color=distance))

ggplot(data) +
  aes(x = distance, color = weapon, group = weapon, y = bots.down) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun = mean, geom = "line")
```

