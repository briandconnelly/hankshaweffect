#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(scales)
library(gtable)

source('formatting.R')
source('figsummary.R')

data_s4b <- read.csv('../data/thinnothin.csv.bz2')
data_s4b$Replicate <- as.factor(data_s4b$Replicate)

# How often data were logged
data_interval <- 1

presence <- data_s4b %>%
    group_by(GenomeLength, InitialThinning, Replicate) %>%
    summarise(Integral=data_interval*sum(CooperatorProportion)/(max(Time)-min(Time)))

figS4b <- ggplot(presence, aes(x=GenomeLength, y=Integral,
                              shape=InitialThinning,
                              color=InitialThinning)) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_continuous(breaks=unique(presence$GenomeLength),
                       labels=label_genomelengths) +
    scale_color_manual(values=c('FALSE'='grey70', 'TRUE'='black'),
                     labels=c('FALSE'=label_without_stress,
                              'TRUE'=label_with_stress),
                     name='') +
    scale_shape_manual(values=c('FALSE'=15, 'TRUE'=16),
                       labels=c('FALSE'=label_without_stress,
                                'TRUE'=label_with_stress),
                       name='') +
    labs(x=label_genome_length, y=label_producer_presence) +
    theme(legend.position=c(.5, 1.035), legend.justification=c(0.5, 0.5)) +
    theme_hankshaw(base_size=17) +
    theme(legend.text = element_text(size=rel(0.5), , colour="grey40"))
figS4b <- rescale_golden(plot=figS4b)

g <- ggplotGrob(figS4b)
g <- gtable_add_grob(g, textGrob(expression(bold("B")),
                                 gp=gpar(col='black', fontsize=20), x=0,
                                 hjust=0, vjust=0.5), t=1, l=2)

png('../figures/FigureS4b.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()

