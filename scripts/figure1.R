#!/usr/bin/env Rscript

library(dplyr)
library(ggplot2)
library(ggplot2bdc)

source('formatting.R')
source('figsummary.R')

fig1data <- read.csv('../data/lsweep.csv.bz2') %>%
    filter(GenomeLength %in% c(0, 8))

fig1data$Replicate <- as.factor(fig1data$Replicate)
fig1data$Structured <- factor(fig1data$Structured, levels=c(FALSE, TRUE),
                              labels=c("Unstructured Population",
                                       "Structured Population"))
fig1data$GenomeLength <- factor(fig1data$GenomeLength, levels=c(0, 8),
                                labels=c("Without Stress Adaptation",
                                         "With Stress Adaptation"))

facet_labels <- data.frame(Time=0, CooperatorProportion=1,
                           GenomeLength=c("Without Stress Adaptation",
                                          "Without Stress Adaptation",
                                          "With Stress Adaptation",
                                          "With Stress Adaptation"),
                           Structured=c("Unstructured Population",
                                        "Structured Population",
                                        "Unstructured Population",
                                        "Structured Population"),
                           Label=c('A','C','B','D'))

fig1 <- ggplot(fig1data, aes(x=Time, y=CooperatorProportion)) +
    facet_grid(Structured ~ GenomeLength) +
    #geom_hline(yintercept=0.5, linetype='dotted', size=0.5, color='grey70',
    #           size=0.1) +
    draw_50line() +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) + 
    stat_summary(fun.y='mean', geom='line') +
    geom_text(data=facet_labels, aes(label=Label), vjust=1, hjust=0) +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=label_time, y=label_producer_proportion)
fig1 <- rescale_square(plot=fig1)
ggsave(plot=fig1, '../figures/Figure1.png', width=6, height=6, dpi=figure_dpi)
#system("convert -trim ../figures/Figure1.png ../figures/Figure1.png")
