#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(scales)
library(gtable)

source('formatting.R')
source('figsummary.R')

data_fig3b <- read.csv('../data/figure3.csv')

# How often data were logged
data_interval <- 10

data_fig3b_integral <- data_fig3b %>%                                                             
    group_by(EnvChangeFreq, Replicate) %>%                                      
    summarise(Integral=data_interval * sum(MeanProducerProportion)/(max(Time)-min(Time)))    

breaks <- 1/c(78, 156, 312, 625, 1250, 2500, 5000)
label_breaks <- c('1/78', '1/156', '1/312', '1/625', '1/1250', '1/2500',
                  '1/5000')

# Version that plots the frequency
fig3b <- ggplot(data_fig3b_integral, aes(x=1/EnvChangeFreq, y=Integral)) +
    #geom_point(shape=1, alpha=replicate_alpha) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_continuous(trans=log2_trans(),
                       breaks=breaks,
                       labels=label_breaks) +
    labs(x=figlabels['envchange_freq'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size=17)
fig3b <- rescale_golden(plot=fig3b)

g <- ggplotGrob(fig3b)
g <- gtable_add_grob(g, textGrob(expression(bold("B")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/Figure3b.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()

