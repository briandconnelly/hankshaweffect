#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(gtable)

source('formatting.R')
source('figsummary.R')

# How often data were logged
data_interval <- 1

data_figs2a <- read.csv('../data/figureS2a.csv.bz2')
data_figs2a$Replicate <- as.factor(data_figs2a$Replicate)

data_figs2a_integral <- data_figs2a %>%
    group_by(MutationRateAdaptation, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

mutation_labels_log <- c(expression(10^{-7}),
                         expression(10^{-6}),
                         expression(bold('10'^{'-5'})),
                         expression(10^{-4}),
                         expression(10^{-3}),
                         expression(10^{-2}),
                         expression(10^{-1}))

figS2A <- ggplot(data_figs2a_integral, aes(x=MutationRateAdaptation,
                                           y=Integral)) +
    #geom_point(shape=1, alpha=replicate_alpha) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_log10(breaks=unique(data_figs2a_integral$MutationRateAdaptation),
                  labels=mutation_labels_log) +
    labs(x=label_stressmu, y=label_producer_presence) +
    theme_hankshaw(base_size=17)
figS2A <- rescale_golden(plot=figS2A)

g <- ggplotGrob(figS2A)
g <- gtable_add_grob(g, textGrob(expression(bold("A")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/FigureS2a.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()

