#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(scales)

source('figsummary.R')
source('formatting.R')

data_figs2 <- read.csv('../data/figureS2.csv')
data_figs2$Replicate <- as.factor(data_figs2$Replicate)

# How often data were logged
data_interval <- 10

presence <- data_figs2 %>%
    filter(Time <= integral_maxtime) %>%
    filter(MutationRateTolerance == 1) %>%
    group_by(EnvChangeFreq, Replicate) %>%
    summarise(Integral=data_interval*sum(ProducerProportion)/(max(Time)-min(Time)))

presence_change <- presence %>% filter(EnvChangeFreq > 0)

breakpoints <- c(1, 5, 20, 78, 312, 1250, 5000)
breaks <- 1/sort(breakpoints, decreasing = TRUE)
label_breaks <- sprintf('1/%d', sort(breakpoints, decreasing = TRUE))

figS2 <- ggplot(presence_change, aes(x=1/EnvChangeFreq, y=Integral)) +
    stat_summary(fun.data='mean_cl_boot') +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_continuous(trans=log2_trans(),
                       breaks=breaks,
                       labels=label_breaks) +
    labs(x=label_envchange_freq, y=label_producer_presence)
figS2 <- rescale_golden(plot=figS2)
ggsave(plot=figS2, '../figures/FigureS2.png', width=6, height=3.708204, dpi=figure_dpi)
