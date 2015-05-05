#!/usr/bin/env Rscript

library(dplyr)
library(ggplot2)
library(ggplot2bdc)

source('formatting.R')
source('figsummary.R')

fig1data <- read.csv('../data/figure1.csv')
fig1data$Struct <- fig1data$PopulationStructure=='lattice, 25x25'
fig1data$Replicate <- as.factor(fig1data$Replicate)

fig1data <- filter(fig1data, Time <= max_time)

facet_labels <- data.frame(Time=0, MeanProducerProportion=1,
                           GenomeLength=c(0,0,8,8),
                           Struct=c(FALSE, TRUE, FALSE, TRUE),
                           Label=c('A','C','B','D'))

fig1facets <- function(variable, value)
{
    labels <- list('Struct'=list('TRUE'='Structured Population',
                                 'FALSE'='Unstructured Population'),
                   'GenomeLength'=list('0'='Without Stress Adaptation',
                                       '8'='With Stress Adaptation')) 
    return(labels[[variable]][as.character(value)])
}

fig1 <- ggplot(fig1data, aes(x=Time, y=MeanProducerProportion)) +
    geom_hline(yintercept=0.5, linetype='dotted', size=0.5, color='grey70', size=0.1) +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) + 
    stat_summary(fun.y='mean', geom='line') +
    geom_text(data=facet_labels, aes(label=Label), vjust=1, hjust=0) +
    scale_y_continuous(limits=c(0,1)) +
    facet_grid(Struct ~ GenomeLength, labeller=fig1facets) +
    labs(x=label_time, y=label_producer_proportion)
fig1 <- rescale_square(plot=fig1)
ggsave(plot=fig1, '../figures/Figure1.png', width=6, height=6, dpi=figure_dpi)
