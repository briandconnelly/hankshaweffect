#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(gtable)

source('formatting.R')
source('figsummary.R')

# How often data were logged
data_interval <- 10

data_fig2c <- read.csv('../data/figure2c.csv')
data_fig2c$Replicate <- as.factor(data_fig2c$Replicate)
data_fig2c$Benefit <- data_fig2c$MaxCarryingCapacity - data_fig2c$MinCarryingCapacity

data_fig2c_integral <- data_fig2c %>%
    filter(Time <= integral_maxtime) %>%
    group_by(Benefit, Source, Replicate) %>%
    summarise(Integral=data_interval * sum(MeanProducerProportion)/(max(Time)-min(Time)))

fig2c <- ggplot(data_fig2c_integral, aes(x=as.factor(Benefit), y=Integral)) +
    #geom_point(shape=1, alpha=replicate_alpha) +
    stat_summary(fun.data='figsummary') +
    scale_x_discrete(breaks=unique(data_fig2c_integral$Benefit),
                     labels=label_benefits) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_benefit, y=label_producer_presence)
fig2c <- rescale_golden(plot=fig2c)

g <- ggplotGrob(fig2c)
g <- gtable_add_grob(g, textGrob(expression(bold("C")), gp=gpar(col='black', fontsize=20), x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/Figure2c.png', width=6, height=3.708204, units='in', res=figure_dpi)
grid.newpage()
grid.draw(g)
dev.off()

