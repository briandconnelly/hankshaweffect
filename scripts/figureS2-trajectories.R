#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(scales)

source('figsummary.R')
source('formatting.R')

data_figs2 <- read.csv('../data/figureS2.csv') %>%
    filter(MutationRateTolerance == 1)
data_figs2$Replicate <- as.factor(data_figs2$Replicate)



data_figs2[data_figs2$EnvChangeFreq==0, 'EnvChangeFreq'] <- max(data_figs2$Time)
change_points <- data.frame()

for(p in sort(unique(data_figs2$EnvChangeFreq)))
{
    times <- seq(from=p, to=max(data_figs2$Time), by=p)
    newdata <- data.frame(EnvChangeFreq=rep(p, length(times)), TimeStep=times)
    change_points <- rbind(change_points, newdata)
}

change_points <- filter(change_points, EnvChangeFreq != max(data_figs2$Time))

S2b_facets <- function(variable, value)
{
    res <- as.character(value)
    res[res==max(data_figs2$Time)] <- 'No Change'
    return(res)
}

ggplot(data_figs2, aes(x=Time, y=ProducerProportion, group=Replicate, color=EnvChangeFreq==max(data_figs2$Time))) +
    geom_vline(data=change_points, aes(xintercept=TimeStep), alpha=0.1, size=0.1) +
    geom_hline(yintercept=0.5, linetype='dotted', size=0.5, color='grey70', size=0.1) +
    geom_line(alpha=0.1) +
    facet_grid(EnvChangeFreq ~ ., labeller = S2b_facets) +
    scale_color_manual(values=c('TRUE'='#F35E5A', 'FALSE'='#3B51A0'), guide=FALSE) +
    scale_y_continuous(limits=c(0,1), breaks=c(0, 0.5, 1)) +
    labs(x='Time', y='Producer Proportion') +
    theme_bdc_paneled(grid.y=FALSE) +
    theme(axis.text.y=element_text(size=8)) +
    theme(strip.text = element_text(size = rel(0.6))) +
    theme(strip.text.y = element_text(angle=0, hjust=0.1))
ggsave('../figures/FigureS2-trajectories.png', dpi=figure_dpi)
