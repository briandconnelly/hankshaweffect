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

data_fig2f <- read.csv('../data/figure2f.csv') %>%
    filter(Time <= max_time)
data_fig2f$Replicate <- as.factor(data_fig2f$Replicate)

data_fig2f_integral <- data_fig2f %>%
    group_by(MutationRateSocial, MutationRateAdaptation, Source, Replicate) %>%
    summarise(Integral=data_interval * sum(MeanProducerProportion)/(max(Time)-min(Time)))

mutation_labels_log <- c(expression(10^{-7}),
                         expression(10^{-6}),
                         expression(bold('10'^{'-5'})),
                         expression(10^{-4}),
                         expression(10^{-3}),
                         expression(10^{-2}),
                         expression(10^{-1}))

fig2f <- ggplot(data_fig2f_integral, aes(x=as.factor(MutationRateAdaptation),
                                         y=Integral)) +
    #geom_point(shape=1, alpha=replicate_alpha) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_discrete(breaks=sort(unique(data_fig2f_integral$MutationRateAdaptation)),
                     labels=mutation_labels_log) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_mu, y=label_producer_presence) +
    theme_hankshaw(base_size=17)
fig2f <- rescale_golden(plot=fig2f)

g <- ggplotGrob(fig2f)
g <- gtable_add_grob(g, textGrob(expression(bold('F')),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/Figure2f.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.newpage()
grid.draw(g)
dev.off()

