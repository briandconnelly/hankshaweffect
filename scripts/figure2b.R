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

data_fig2b <- read.csv('../data/figure2b.csv') %>% filter(Time <= max_time)

data_fig2b_integral <- data_fig2b %>%
    group_by(GenomeLength, Source, Replicate) %>%
    summarise(Integral=data_interval * sum(MeanProducerProportion)/(max(Time)-min(Time)))

data_fig2b_integral$GenomeLength <- as.factor(data_fig2b_integral$GenomeLength)

fig2b <- ggplot(data_fig2b_integral, aes(x=GenomeLength, y=Integral,
                                         color=GenomeLength)) +
    #geom_point(shape=1, alpha=replicate_alpha, color='black') +
    stat_summary(fun.data='figsummary', size=point_size, color='black') +
    stat_summary(fun.y='mean', geom='point', size=3.3) +
    scale_color_manual(values=c('0'=color_L00, '1'='black', '2'='black',
                                '3'='black', '4'='black', '5'='black',
                                '6'='black', '7'='black', '8'=color_L08,
                                '9'='black', '10'='black'), guide=FALSE) +
    scale_x_discrete(breaks=unique(data_fig2b_integral$GenomeLength),
                     labels=label_genomelengths) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_genome_length, y=label_producer_presence) +
    theme_hankshaw(base_size=17)
fig2b <- rescale_golden(plot=fig2b)

g <- ggplotGrob(fig2b)
g <- gtable_add_grob(g, textGrob(expression(bold("B")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/Figure2b.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.newpage()
grid.draw(g)
dev.off()

