#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)

source('figsummary.R')
source('formatting.R')

dcoop <- read.csv('../data/envchange-exponential-strength-cooppct.csv.bz2')
dcoop$Replicate <- as.factor(dcoop$Replicate)


# All Trajectories --------------------------------------------------------

pall <- ggplot(data=dcoop, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    facet_grid(EnvChangeStrength ~ .) +
    draw_50line() +
    geom_line() +
    scale_y_continuous(limits=c(0,1), breaks=c(0,0.5,1)) +
    scale_color_grey(guide = FALSE) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw()
ggsave_golden(filename='../figures/envchange-exponential-strength-all.png', plot=pall)


# Cooperator Presence -----------------------------------------------------

data_interval <- 1                                                        
presence <- dcoop %>%                                                     
    group_by(EnvChangeStrength, Replicate) %>%                                    
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

pint <- ggplot(data=presence, aes(x=EnvChangeStrength, y=Integral)) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_continuous(breaks=seq(1, 8)) +
    labs(x=label_stress_strength, y=label_producer_presence) +
    theme_hankshaw(base_size=17)
pint <- rescale_golden(plot=pint)
ggsave_golden(filename='../figures/envchange-exponential-strength-integral.png',
              plot=pint)

