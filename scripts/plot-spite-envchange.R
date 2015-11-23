#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(scales)

source('figsummary.R')
source('formatting.R')

d <- read.csv('../data/spite-envchange.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

# Trajectory for single replicate ----------------------------------------------

data_rep <- d %>% filter(EnvChangeFrequency == 500) %>% filter(Replicate == 13)
changepoints <- expand.grid(EnvChangeFrequency=500, ChangeTime=seq(from=min(d$Time), to=max(d$Time), by=500))

prep <- ggplot(data=data_rep, aes(x=Time, y=CooperatorProportion)) +
    draw_50line() +
    geom_vline(data=changepoints, aes(xintercept=ChangeTime), color='grey70',  
               size=0.1, linetype='solid') + 
    geom_line(size=0.8) +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=label_time, y=label_spite_proportion) +
    theme_hankshaw(base_size=17)
prep <- rescale_golden(plot = prep)
ggsave_golden(filename = '../figures/spite-envchange-sample.png', plot = prep)


# All trajectories -------------------------------------------------------------
pall <- ggplot(data=d, aes(x=Time, y=CooperatorProportion)) +
    facet_grid(Replicate ~ .) +
    draw_50line() +
    geom_line() +
    scale_y_continuous(breaks=c(0, 0.5, 1)) +
    labs(x=label_time, y=label_spite_proportion) +
    theme_hankshaw()
ggsave_golden(filename = '../figures/spite-envchange-all.png', plot = pall)

