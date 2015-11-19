#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(gtable)
library(scales)

source('formatting.R')
source('figsummary.R')

data_s4a <- read.csv('../data/thinnothin.csv.bz2') %>%
    filter(GenomeLength == 8)

data_s4a$Replicate <- as.factor(data_s4a$Replicate)

figs4a <- ggplot(data_s4a, aes(x=Time, y=CooperatorProportion,
                               color=InitialThinning,
                               fill=InitialThinning,
                               linetype=InitialThinning)) +
    geom_hline(yintercept=0.5, linetype='dotted', size=0.5, color='grey70') +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) + 
    stat_summary(fun.y='mean', geom='line') +
    scale_y_continuous(limits=c(0,1)) +
    scale_linetype_manual(values=c('FALSE'='solid', 'TRUE'='dashed'),
                          labels=c('FALSE'=label_without_stress,
                                   'TRUE'=label_with_stress),
                          name='') +
    scale_color_manual(values=c('FALSE'='grey70', 'TRUE'='grey20'),
                       labels=c('FALSE'=label_without_stress,
                                'TRUE'=label_with_stress),
                       name='') +
    scale_fill_manual(values=c('FALSE'='grey70', 'TRUE'='grey20'),
                      labels=c('FALSE'=label_without_stress,
                               'TRUE'=label_with_stress),
                      name='', guide=FALSE) +
    labs(x=label_time, y=label_producer_proportion) +
    theme(legend.position=c(.5, 1.035), legend.justification=c(0.5, 0.5)) +
    theme_hankshaw(base_size=17) +
    theme(legend.text = element_text(size=rel(0.5), colour="grey40"))
figs4a <- rescale_golden(plot=figs4a)

g <- ggplotGrob(figs4a)
g <- gtable_add_grob(g, textGrob(expression(bold("A")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/FigureS4a.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()

