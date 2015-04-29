#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(gtable)

load(file='../data/producer_proportion.rda')
source('formatting.R')
source('figsummary.R')

# How often data were logged
data_interval <- 10

data_fig2b <- producer_proportion %>%
    filter(PopulationStructure=='lattice, 25x25') %>%
    filter(FitnessDistribution=='uniform') %>%
    filter(MigrationRate==0.05) %>%
    filter(MutationRateSocial==1e-5) %>%
    filter(MutationRateTolerance==1e-5) %>%
    filter(MutationRateAdaptation==1e-5) %>%
    filter(ProductionCost==0.1) %>%
    filter(MinCarryingCapacity==800) %>%
    filter(MaxCarryingCapacity==2000) %>%
    filter(is.na(EnvChangeFreq)) %>%
    filter(Source=='GenomeLength')

data_fig2b_integral <- data_fig2b %>%
    group_by(GenomeLength, Source, Replicate) %>%
    summarise(Integral=data_interval * sum(MeanProducerProportion)/(max(Time)-min(Time)))

data_fig2b_integral$GLColor = (data_fig2b_integral$GenomeLength == 8)
data_fig2b_integral$GenomeLength <- as.factor(data_fig2b_integral$GenomeLength)

fig2b <- ggplot(data_fig2b_integral, aes(x=GenomeLength, y=Integral, color=GenomeLength)) +
    #geom_point(shape=1, alpha=replicate_alpha, color='black') +
    stat_summary(fun.data='figsummary', geom='errorbar', color='black', width=0, size=0.8) +
    stat_summary(fun.y='mean', geom='point') +
    scale_color_manual(values=c('0'='#F35E5A', '1'='black', '2'='black',
                                '3'='black', '4'='black', '5'='black',
                                '6'='black', '7'='black', '8'='#5086FF',
                                '9'='black', '10'='black'), guide=FALSE) +
    scale_x_discrete(breaks=unique(data_fig2b_integral$GenomeLength),
                     labels=label_genomelengths) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_genome_length, y=label_producer_presence)
fig2b <- rescale_golden(plot=fig2b)

g <- ggplotGrob(fig2b)
g <- gtable_add_grob(g, textGrob(expression(bold("B")), gp=gpar(col='black', fontsize=20), x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/Figure2b.png', width=6, height=3.708204, units='in', res=figure_dpi)
grid.newpage()
grid.draw(g)
dev.off()

