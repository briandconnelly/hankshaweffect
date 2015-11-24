#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(scales)

source('figsummary.R')
source('formatting.R')

d <- read.csv('../data/benefitgamma.csv.bz2')
d$Replicate <- as.factor(d$Replicate)


# Benefit Curves ----------------------------------------------------------

S <- 2000
s <- 800     

pdata <- expand.grid(Time=1:1000/1000, Gamma=unique(d$Gamma))
pdata$PSize <- s + ((pdata$Time^pdata$Gamma) * (S-s))  

p_gamma <- ggplot(pdata, aes(x=Time, y=PSize, color=as.factor(Gamma))) +        
    geom_hline(yintercept=s, linetype='dotted', size=0.5, color='grey70', size=0.1) +
    geom_hline(yintercept=S, linetype='dotted', size=0.5, color='grey70', size=0.1) +
    geom_line() +                                                               
    scale_color_hue(name=label_gamma) +                                   
    scale_y_continuous(limits=c(0,S), breaks=c(0,s,S),                       
                       labels=c('0',expression(S['min']),expression(S['max']))) +
    labs(x=label_producer_proportion, y=label_carrying_capacity) +       
    theme_hankshaw(base_size = 17) +
    theme(legend.position=c(.5, 1.035), legend.justification=c(0.5, 0.5))   
p_gamma <- rescale_golden(plot=p_gamma)
ggsave_golden(filename='../figures/benefitgamma-gamma.png', plot=p_gamma)


# Individual Trajectories -------------------------------------------------

ptraj <- ggplot(data=d, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    draw_50line() +
    facet_grid(Gamma ~ .) +
    geom_line() +
    scale_y_continuous(limits=c(0,1), breaks=c(0, 0.5, 1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size=17)
ggsave_golden(filename = '../figures/benefitgamma-all.png', plot = ptraj)

# Cooperator Presence -----------------------------------------------------

data_interval <- 1

presence <- d %>%
    group_by(Gamma, Replicate) %>%
    summarise(Integral=data_interval*sum(CooperatorProportion)/(max(Time)-min(Time)))

pint <- ggplot(data=presence, aes(x=Gamma, y=Integral)) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_gamma, y=label_producer_presence) +
    theme_hankshaw(base_size = 17)
pint <- rescale_golden(plot=pint)
ggsave_golden(filename = '../figures/benefitgamma-integral.png', plot = pint)
