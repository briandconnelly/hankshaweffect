#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(gtable)

source('formatting.R')

change_freq <- 1000

data_figs6b <- read.csv('../data/figureS6b.csv') %>%
    filter(EnvChangeFreq == change_freq) %>%
    filter(Replicate==10)

figs6b <- ggplot(data_figs6b, aes(x=Time, y=MeanProducerProportion)) +
    geom_vline(aes(xintercept=seq(from=0, to=max(data_figs6b$Time),
                                  by=change_freq)), color='grey80', size=0.3) +
    geom_hline(yintercept=0.5, linetype='dotted', size=0.5, color='grey70',
               size=0.1) +
    geom_line(size=0.8) + 
    scale_y_continuous(limits=c(0,1)) +
    scale_x_continuous(breaks=c(0,2000,4000,6000,8000,10000)) +
    labs(x=label_time, y=label_spite_proportion) +
    theme_hankshaw(base_size=17)
figs6b <- rescale_golden(plot=figs6b)

g <- ggplotGrob(figs6b)
g <- gtable_add_grob(g, textGrob(expression(bold("B")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/FigureS6b.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()

