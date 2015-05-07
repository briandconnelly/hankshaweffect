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

data_figs2b <- read.csv('../data/figureS2bc.csv') %>%
    filter(Time <= max_time)
data_figs2b$Replicate <- as.factor(data_figs2b$Replicate)

data_figs2b_integral <- data_figs2b %>%
    group_by(MutationRateSocial, Replicate) %>%
    summarise(Integral=data_interval * sum(ProducerProportion)/(max(Time)-min(Time)))

mutation_labels_log <- c(expression(10^{-7}),
                         expression(10^{-6}),
                         expression(bold('10'^{'-5'})),
                         expression(10^{-4}),
                         expression(10^{-3}),
                         expression(10^{-2}),
                         expression(10^{-1}))

figS2B <- ggplot(data_figs2b_integral, aes(x=MutationRateSocial, y=Integral)) +
    #geom_point(shape=1, alpha=replicate_alpha) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_log10(breaks=unique(data_figs2b_integral$MutationRateSocial),
                  labels=mutation_labels_log) +
    labs(x=label_socialmu, y=label_producer_presence) +
    theme_hankshaw(base_size=17)
figS2B <- rescale_golden(plot=figS2B)

g <- ggplotGrob(figS2B)
g <- gtable_add_grob(g, textGrob(expression(bold("B")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/FigureS2b.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()

