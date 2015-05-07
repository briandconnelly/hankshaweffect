#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(scales)
library(gtable)

source('formatting.R')
source('figsummary.R')

data_s4b <- read.csv('../data/figureS4.csv') %>%
    filter(Time <= max_time)
data_s4b$Replicate <- as.factor(data_s4b$Replicate)
data_s4b$MutationRateTolerance <- as.factor(data_s4b$MutationRateTolerance)

# How often data were logged
data_interval <- 10

presence <- data_s4b %>%
    group_by(GenomeLength, MutationRateTolerance, Replicate) %>%
    summarise(Integral=data_interval*sum(ProducerProportion)/(max(Time)-min(Time)))

figS4b <- ggplot(presence, aes(x=GenomeLength, y=Integral,
                              shape=MutationRateTolerance,
                              color=MutationRateTolerance)) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_continuous(breaks=unique(presence$GenomeLength),
                       labels=label_genomelengths) +
    scale_color_manual(values=c('1'='grey70', '1e-05'='black'),
                     labels=c('1'=label_without_stress,
                              '1e-05'=label_with_stress),
                     name='') +
    scale_shape_manual(values=c('1'=15, '1e-05'=16),
                       labels=c('1'=label_without_stress,
                                '1e-05'=label_with_stress),
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

