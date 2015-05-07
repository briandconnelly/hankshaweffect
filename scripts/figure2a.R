#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(gtable)

source('formatting.R')

data_fig2a <- read.csv('../data/figure2a.csv') %>%
    filter(Time <= max_time)
data_fig2a$Replicate <- as.factor(data_fig2a$Replicate)


fig2afacets <- function(variable, value)
{
    return(sprintf('%d Adaptive Loci', value))
}

fig2a <- ggplot(data_fig2a, aes(x=Time, y=MeanProducerProportion,
                                color=as.factor(GenomeLength),
                                fill=as.factor(GenomeLength))) +
    geom_hline(yintercept=0.5, linetype='dotted', size=0.5, color='grey70',
               size=0.1) +
    stat_summary(fun.ymax='mean', geom='ribbon', ymin=0, alpha=1, color=NA) +
    stat_summary(fun.y='mean', geom='line', color='black') +
    facet_grid(GenomeLength ~ ., labeller=fig2afacets) +
    scale_color_manual(values=c('8'=color_L08, '0'=color_L00), guide=FALSE) +
    scale_fill_manual(values=c('8'=color_L08, '0'=color_L00), guide=FALSE) +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size=17)
fig2a <- rescale_plot(plot=fig2a, ratio=(1 + sqrt(5)))

g <- ggplotGrob(fig2a)
g <- gtable_add_grob(g, textGrob(expression(bold("A")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/Figure2a.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.newpage()
grid.draw(g)
dev.off()

