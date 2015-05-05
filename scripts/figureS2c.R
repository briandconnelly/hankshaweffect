#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(gtable)

source('formatting.R')
source('figsummary.R')

data_figs2bc <- read.csv('../data/figureS2bc.csv') %>%
    filter(Time <= max_time)
data_figs2bc$Replicate <- as.factor(data_figs2bc$Replicate)

data_figs2c <- data_figs2bc %>%
    filter(MutationRateSocial == max(data_figs2bc$MutationRateSocial))

figS2C <- ggplot(data_figs2c, aes(x=Time, y=ProducerProportion)) +
    geom_hline(yintercept=0.5, linetype='dotted', size=0.5, color='grey70', size=0.1) +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) +
    stat_summary(fun.y='mean', geom='line', color='black') +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=label_time, y=label_producer_proportion)
figS2C <- rescale_golden(plot=figS2C)

g <- ggplotGrob(figS2C)
g <- gtable_add_grob(g, textGrob(expression(bold("C")), gp=gpar(col='black', fontsize=20), x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/FigureS2c.png', width=6, height=3.708204, units='in', res=600)
grid.newpage()
grid.draw(g)
dev.off()
