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

data_figs1a <- read.csv('../data/figureS1a.csv') %>%
    filter(Time <= max_time)
data_figs1a$Replicate <- as.factor(data_figs1a$Replicate)

data_figs1a_integral <- data_figs1a %>%
    group_by(MutationRateAdaptation, Replicate) %>%
    summarise(Integral=data_interval * sum(ProducerProportion)/(max(Time)-min(Time)))

mutation_labels <- c('1e-07'='0.0000001', '1e-06'='0.000001',
                     '1e-05'=expression(bold('0.00001')), '1e-04'='0.0001',
                     '1e-03'='0.001', '1e-02'='0.01', '1e-01'='0.1')

figS1A <- ggplot(data_figs1a_integral, aes(x=MutationRateAdaptation, y=Integral)) +
    #geom_point(shape=1, alpha=replicate_alpha) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_log10(breaks=unique(data_figs1a_integral$MutationRateAdaptation),
                  labels=mutation_labels) +
    labs(x=label_stressmu, y=label_producer_presence)
figS1A <- rescale_golden(plot=figS1A)

g <- ggplotGrob(figS1A)
g <- gtable_add_grob(g, textGrob(expression(bold("A")), gp=gpar(col='black', fontsize=20), x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/FigureS1a.png', width=6, height=3.708204, units='in', res=figure_dpi)
grid.newpage()
grid.draw(g)
dev.off()
