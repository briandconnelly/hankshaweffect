#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(gtable)

source('formatting.R')
source('figsummary.R')

data_figs1bc <- read.csv('../data/figureS1bc.csv')
data_figs1bc$Replicate <- as.factor(data_figs1bc$Replicate)

data_figs1c <- data_figs1bc %>%
    filter(MutationRateSocial == max(data_figs1bc$MutationRateSocial))

figS1C <- ggplot(data_figs1c, aes(x=Time, y=ProducerProportion)) +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) + 
    stat_summary(fun.y='mean', geom='line', color='black') +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=label_time, y=label_producer_proportion)
figS1C <- rescale_golden(plot=figS1C)

g <- ggplotGrob(figS1C)
g <- gtable_add_grob(g, textGrob(expression(bold("C")), gp=gpar(col='black', fontsize=20), x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/FigureS1c.png', width=6, height=3.708204, units='in', res=600)
grid.newpage()
grid.draw(g)
dev.off()
