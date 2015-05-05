#!/usr/bin/env Rscript

library(dplyr)
library(ggplot2)
library(ggplot2bdc)

source('formatting.R')
source('figsummary.R')

figs6data <- read.csv('../data/figureS6.csv') %>%
    filter(Time <= max_time)
figs6data$Replicate <- as.factor(figs6data$Replicate)

figs6_integral <- figs6data %>%
    group_by(MinProbDilution, Replicate) %>%
    summarise(Integral=1*sum(MeanProducerProportion)/(max(Time)-min(Time)))

figS6 <- ggplot(figs6_integral, aes(x=MinProbDilution, y=Integral)) +
    #geom_point(shape=1, alpha=0.05) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0, 1)) +
    scale_x_log10(limits=c(1e-3,1), breaks=c(1e-3, 1e-2, 1e-1, 1)) +
    labs(x=label_dilute_min, y=label_spite_presence) +
    theme_hankshaw(base_size=17)
figS6 <- rescale_golden(plot=figS6)

png('../figures/FigureS6.png', width=6, height=3.708204, units='in', res=figure_dpi)
figS6
dev.off()

