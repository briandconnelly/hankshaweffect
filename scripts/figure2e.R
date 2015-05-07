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

data_fig2e <- read.csv('../data/figure2e.csv') %>%
    filter(Time <= max_time)
data_fig2e$Replicate <- as.factor(data_fig2e$Replicate)

data_fig2e_integral <- data_fig2e %>%
    group_by(MigrationRate, Source, Replicate) %>%
    summarise(Integral=data_interval * sum(MeanProducerProportion)/(max(Time)-min(Time)))


migration_labels_log <- c(expression(paste(5, 'x', 10^{-7})),
                          expression(paste(5, 'x', 10^{-6})),
                          expression(paste(5, 'x', 10^{-5})),
                          expression(paste(5, 'x', 10^{-4})),
                          expression(paste(5, 'x', 10^{-3})),
                          expression(bold(paste('5', 'x', '10'^{'-2'}))),
                          expression(paste(5, 'x', 10^{-1})))

fig2e <- ggplot(data_fig2e_integral, aes(x=MigrationRate, y=Integral)) +
    #geom_point(shape=1, alpha=replicate_alpha) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_log10(breaks=unique(data_fig2e_integral$MigrationRate),
                  labels=migration_labels_log) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_migration_rate, y=label_producer_presence) +
    theme_hankshaw(base_size=17)
fig2e <- rescale_golden(plot=fig2e)

g <- ggplotGrob(fig2e)
g <- gtable_add_grob(g, textGrob(expression(bold('E')),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/Figure2e.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()

