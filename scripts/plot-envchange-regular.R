#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(scales)

source('figsummary.R')
source('formatting.R')

d <- read.csv('../data/envchange-regular.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

# Trajectory for single replicate ----------------------------------------------

data_rep <- d %>% filter(EnvChangeFrequency == 750) %>% filter(Replicate == 17)
changepoints <- expand.grid(EnvChangeFrequency=750, ChangeTime=seq(from=min(d$Time), to=max(d$Time), by=750))

prep <- ggplot(data=data_rep, aes(x=Time, y=CooperatorProportion)) +
    draw_50line() +
    geom_vline(data=changepoints, aes(xintercept=ChangeTime), color='grey70',  
               size=0.1, linetype='solid') + 
    geom_line() +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size=17)
prep <- rescale_golden(plot = prep)
ggsave_golden(filename = '../figures/envchange-regular-rep.png', plot = prep)

# Integral for different env change rates --------------------------------------

data_interval <- 1

presence <- d %>%
    filter(EnvChangeFrequency >= 100) %>%
    group_by(EnvChangeFrequency, Replicate) %>%
    summarise(Integral=data_interval*sum(CooperatorProportion)/(max(Time)-min(Time)))

breakpoints <- c(100,5000,1000,500, 250, 2000)
breaks <- 1/sort(breakpoints, decreasing = TRUE)
label_breaks <- sprintf('1/%d', sort(breakpoints, decreasing = TRUE))

figX <- ggplot(presence, aes(x=1/EnvChangeFrequency, y=Integral)) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_log10(breaks=breaks, labels=label_breaks) +
#     scale_x_continuous(trans=log10_trans(),
#                        breaks=breaks,
#                        labels=label_breaks) +
    labs(x=label_envchange_freq, y=label_producer_presence) +
    theme_hankshaw(base_size=17)
figX <- rescale_golden(plot=figX)
ggsave_golden(filename = '../figures/envchange-regular-integral.png', plot = figX)


# All trajectories -------------------------------------------------------------
pall <- ggplot(data=d, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    facet_grid(EnvChangeFrequency ~ .) +
    draw_50line() +
    geom_line() +
    scale_y_continuous(breaks=c(0, 0.5, 1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw()
ggsave_golden(filename = '../figures/envchange-regular-all.png', plot = pall)

