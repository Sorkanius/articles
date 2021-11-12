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

counts.data.frame <- data.frame(robots.down=counts, robots.down=counts/30, index=as.numeric(as.character(factor(row.names(data)))))
data <- cbind(data, counts.data.frame)



# patch
data <- read.table("data.txt")
colnames(data) <- c("1", "weapon", "distance", "robots.down", "robots.down.prop", "index")



data$weapon <- factor(data$weapon, levels =  c('Sheriff', 'Phantom', 'Vandal'))

ggplot(data) +
  geom_boxplot(aes(x=weapon, y=robots.down, color=distance))

ggplot(data) +
  aes(x = weapon, y = robots.down, color = distance) +
  geom_line(aes(group = weapon)) +
  geom_point()

plot(row.names(data), data$kills)
abline(lm(data$kills ~ row.names(data)), col = 4, lwd = 3)

fit <- lm(kills ~  index + weapons * distances, data=data, contrasts=list(index="contr.poly"))
summary(fit)

fit.anova <- aov(kills ~  weapons * distances, data=data)
summary(fit.anova)

fit.anova.reduced <- aov(kills  ~  weapons + distances, data=data)
summary(fit.anova.reduced)

anova(fit.anova, fit.anova.reduced)


TukeyHSD(fit.anova.reduced)
plot(TukeyHSD(fit.anova.reduced))
     