library(ggplot2)

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

counts.data.frame <- data.frame(bots.down=counts, robots.down=counts/30, index=as.numeric(as.character(factor(row.names(data)))))
data <- cbind(data, counts.data.frame)



# patch
data <- read.table("data.txt")
colnames(data) <- c("1", "weapon", "distance", "bots.down", "robots.down.prop", "index")



data$weapon <- factor(data$weapon, levels =  c('Sheriff', 'Phantom', 'Vandal'))

ggplot(data, aes(x=weapon, y=bots.down, color=distance)) +
  geom_boxplot() +
  geom_point(position=position_jitterdodge(jitter.width = 0, jitter.height = 0.2),aes(group=distance)) +
  ggtitle("Bots downed per weapon and distance") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Bots downed")

ggplot(data) +
  aes(x = distance, color = weapon, group = weapon, y = bots.down) +
  stat_summary(fun = mean, geom = "point") +
  stat_summary(fun = mean, geom = "line") +
  ggtitle("Average bots downed. Interaction between weapon and distance") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Bots downed")

ggplot(data, aes(x=index, y=bots.down)) +
  geom_point() +
  geom_line(linetype="dotted") +
  geom_smooth(method="lm", formula="y ~ x") +
  ylab("Bots downed") + xlab("Round") +
  ggtitle("Evolution of downed bots") +
  theme(plot.title = element_text(hjust = 0.5))


plot(row.names(data), data$bots.down)
abline(lm(data$bots ~ data$index), col = 4, lwd = 3)

fit <- lm(bots.down ~  index + weapon * distance, data=data)
summary(fit)

fit.anova <- aov(bots.down ~  weapon * distance + index, data=data)
summary(fit.anova)

fit.anova.reduced <- aov(bots.down  ~  weapon + distance, data=data)
summary(fit.anova.reduced)

anova(fit.anova, fit.anova.reduced)


TukeyHSD(fit.anova.reduced)
plot(TukeyHSD(fit.anova.reduced))
     