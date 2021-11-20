#Advanced Visualization
getwd()
setwd("/Users/apple/Desktop/R")

movies <- read.csv("MR.csv", stringsAsFactors = T)
head(movies)
colnames(movies) <- c("Film", "Genre", "CriticRating", "AudienceRating", "BudgetMillions", "Year")
tail(movies)
str(movies)
new <- as.factor(movies$Genre)
new
str(movies)
head(movies)

summary(movies)

factor(movies$Year)
movies$Year <- factor(movies$Year)

#----------Aesthetics
library(ggplot2)

ggplot(data=movies, aes(x=CriticRating, y=AudienceRatings))

#add geometry
ggplot(data=movies, aes(x=CriticRating, y=AudienceRating)) + geom_point()
head(movies)

#add colour
ggplot(data=movies, aes(x=CriticRating, y=AudienceRating, colour=Genre)) + geom_point()
head(movies)

#add size
ggplot(data=movies, aes(x=CriticRating, y=AudienceRating, colour=Genre, size=BudgetMillions)) + geom_point()
head(movies)


#this is #1(we will improve it)

p <- ggplot(data=movies, aes(x=CriticRating, y=AudienceRating, colour=Genre, size=BudgetMillions)) 

#point
p + geom_point()

#lines
p + geom_line()

#multiple layers
p + geom_point() + geom_line()
p + geom_line() + geom_point()

#overriding aesthetics
q <- ggplot(data=movies, aes(x=CriticRating, y=AudienceRating, 
                             colour=Genre, size=BudgetMillions)) 
q
#add geom layer
q + geom_point()

#overriding aes
#ex1
 q + geom_point(aes(size=CriticRating))

#ex2
q + geom_point(aes(colour=BudgetMillions))

#ex3
q + geom_point(aes(x=BudgetMillions))
  + xlab("Budget Millions $$$")
 
#ex4
p + geom_line() + geom_point()

#reduce line size
q + geom_line(size=1) + geom_point()


#Mapping vs setting

r <- ggplot(data=movies, aes(x=CriticRating,
                                  y=AudienceRating)
r + geom_point()

#add colour
#1. Mapping
r + geom_point(aes(colour=Genre))
#2 Setting
r + geom_point(colour="DarkGreen")

#1. Mapping
r + geom_point(aes(size=BudgetMillions))

#2  Setting
r + geom_point(size=10)


#------------x-------------

head(movies)

m <- ggplot(data=movies, aes(x=CriticRating, y=AudienceRating))
m
m + geom_point(aes(colour = BudgetMillions))
m + geom_point(size=6, colour = "Red")


#------------Histograms and Density Charts

s <- ggplot(data=movies, aes(x=BudgetMillions))
s + geom_histogram(binwidth = 30, aes(fill=Genre))

#add border
s + geom_histogram(binwidth = 30, aes(fill=Genre), colour="Black")
#chart no 3>>>


#Density Charts 
s + geom_density(aes(fill=Genre))
s + geom_density(aes(fill=Genre), position = "stack")


#-------------layering tips

t <- ggplot(data=movies, aes(x=CriticRating))
t + geom_histogram(binwidth =10, fill = "White", colour="Blue")


#------------creating another visualization
head(movies)
m <- ggplot(data=movies, aes(x=BudgetMillions, y=CriticRating, colour="Blue"))
m + geom_point()




#----------geom_smooth()

u <- ggplot(data=movies, aes(x=CriticRating, y=AudienceRating, colour=Genre))
u + geom_point() + geom_smooth(fill=NA)

#---------boxplots

u <- ggplot(data=movies, aes(x=Genre, y=AudienceRating, colour=Genre))
u + geom_boxplot(size=1.2) + geom_point()

u + geom_boxplot(size=1.2) + geom_jitter()
u + geom_jitter() + geom_boxplot(size=1.2, alpha=0.5)

#CriticRating boxplots
u <- ggplot(data=movies, aes(x=Genre, y=CriticRating, colour=Genre))
u + geom_jitter() + geom_boxplot(size=1.2, alpha=0.5)

#---------Using Facets

v <- ggplot(data=movies, aes(x=BudgetMillions))
v + geom_histogram(binwidth=10, aes(fill=Genre), colour ="Black")

#facets:
v + geom_histogram(binwidth=10, aes(fill=Genre), colour ="Black") + facet_grid(Genre~.)

#scatterplots
w <- ggplot(data=movies, aes(x=CriticRating, y=AudienceRating, colour=Genre))

w + geom_point(size=3)

w + geom_point(size=3) + facet_grid(.~Year)

w + geom_point(aes(size=BudgetMillions)) + geom_smooth() + facet_grid(Genre~Year)

#Coordinates

m <-ggplot(data=movies, aes(x=CriticRating, y=AudienceRating, size=BudgetMillions, colour=Genre))

m + geom_point()

#cutting out movies with the highest rating

m + geom_point() + xlim(50,100) + ylim(50,100)

#improving #1
w + geom_point(aes(size=BudgetMillions)) + geom_smooth() + facet_grid(Genre~Year) + coord_cartesian(ylim =c (0,100))

#----------------------Theme
o <- ggplot(data=movies, aes(x=BudgetMillions))
h <- o + geom_histogram(binwidth=10, aes(fill=Genre), colour="Black")

#axes labels
h + 
  xlab("Money Axis") +
  ylab("Number of Movies")

#label formatting
h + 
  xlab("Money Axis") +
  ylab("Number of Movies") +
  theme(axis.title.x = element_text(colour="Dark Green", size=30), 
       axis.title.y = element_text(colour="Red", size = 30),
       axis.text.x = element_text(size=20),
       axis.text.y = element_text(size=20))
    
#legend formatting
h + 
  xlab("Money Axis") +
  ylab("Number of Movies") +
  ggtitle("Movie Budget Distribution")
  theme(axis.title.x = element_text(colour="Dark Green", size=30), 
        axis.title.y = element_text(colour="Red", size = 30),
        axis.text.x = element_text(size=20),
        axis.text.y = element_text(size=20),
        
        legend.title = element_text(size=30),
        legend.text = element_text(size=20),
        legend.position = c(1,1),
        legend.justification = c(1,1).
        plot.title = element_text(colour="Dark Blue",
                                  size = 40, family = "Courier")
  )












