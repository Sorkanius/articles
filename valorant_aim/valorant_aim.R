library(ggplot2)
library(ggpubr)
library(car)
library(multcomp)
library(rstatix)
library(emmeans)
library(ggpubr)
library(dplyr)



n <- 10
weapons <- c('Vandal', 'Phantom', 'Sheriff')
close.distances <- rep('close', each=30)
long.distances <- rep('long', each=30)
perm.weapons <- rep(weapons, each=n)

length(perm.weapons)

close.distances.data <- data.frame(weapon=perm.weapons, distance=close.distances)
long.distances.data <- data.frame(weapon=perm.weapons, distance=long.distances)
data <- rbind(close.distances.data, long.distances.data)

set.seed(42)
rows <- sample(nrow(data))
data <- data[rows, ]
row.names(data) <- NULL
data

counts <- c(18, 19, 26, 16, 23, 20, 16, 18, 15, 19,
            25, 12, 20, 14, 15, 20, 25, 21, 17, 15,
            19, 17, 15, 23, 28, 17, 23, 15, 25, 16,
            20, 22, 17, 20, 23, 17, 22, 21, 19, 19,
            13, 17, 24, 19, 25, 15, 19, 23, 21, 13,
            17, 22, 20, 22, 23, 21, 20 ,24, 29, 24)

counts.data.frame <- data.frame(bots.down=counts, index=as.numeric(as.character(factor(row.names(data)))))
data <- cbind(data, counts.data.frame)

data$weapon <- factor(data$weapon, levels =  c('Sheriff', 'Phantom', 'Vandal'))

data %>% 
  group_by(weapon, distance) %>% 
  summarise(groups = mean(bots.down), bots_sem = (sd(bots.down)/sqrt(length(bots.down)))) -> data.sem

# Box Plot

ggplot(data, aes(x=weapon, y=bots.down, color=distance)) +
  geom_boxplot() +
  geom_point(position=position_jitterdodge(jitter.width = 0, jitter.height = 0.2),aes(group=distance)) +
  ggtitle("Bots downed per weapon and distance") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Bots downed")

# Interaction Plot

ggplot(data) +
  aes(x = distance, color = weapon, group = weapon, y = bots.down) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun = mean, geom = "line") +
  ggtitle("Average bots downed. Interaction between weapon and distance") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Bots downed") +
  ylim(12, 29)

# Evolution Plot

ggplot(data, aes(x=index, y=bots.down)) +
  geom_point() +
  geom_line(linetype="dotted") +
  geom_smooth(method="lm", formula="y ~ x") +
  ylab("Bots downed") + xlab("Round") +
  ggtitle("Evolution of downed bots") +
  theme(plot.title = element_text(hjust = 0.5))

# Linearity Assumption


ggscatter(
  data, x = "index", y = "bots.down",
  facet.by  = c("weapon", "distance"), 
  short.panel.labs = FALSE
) +
  stat_smooth(method = "loess", span = 0.9) +
  ylab("Bots downed") + xlab("Round")

# Homogeneity of regression slopes


data %>%
  anova_test(
    bots.down ~ index + weapon + distance + 
      weapon*distance + index*weapon +
      index*distance + index*weapon*distance
  )


# Model
fit <- lm(bots.down ~ index + weapon*distance, data=data)

# Normality of Residuals

shapiro.test(fit$residuals)

# Homogeneity of variances

fit.metrics <- augment(fit)
levene_test(.resid ~ weapon*distance, data = fit.metrics)

# Two Way ANCOVA
data %>%
  anova_test(
    bots.down ~ index + weapon*distance
  )

# Model Comparison, F test
fit.reduced <- lm(bots.down ~ weapon + distance, data=data)
anova(fit, fit.reduced)

# Pair to Pair Comparison
TukeyHSD(aov(bots.down ~ weapon + distance, data=data))




     