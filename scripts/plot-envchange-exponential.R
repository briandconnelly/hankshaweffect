#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(scales)
library(gtable)

source('figsummary.R')
source('formatting.R')

d <- read.csv('../data/envchange-exponential-cooppct.csv.bz2')
d$Replicate <- as.factor(d$Replicate)


# Unchanging Environment? ------------------------------------------------------



# Sample trajectory ------------------------------------------------------------

data_sample <- d %>% filter(EnvChangeFrequency == 500 & Replicate == 36)
p_sample <- ggplot(data=data_sample, aes(x=Time, y=CooperatorProportion)) +
    draw_50line() +
    geom_line() +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size=17)
p_sample <- rescale_golden(plot = p_sample)
#ggsave_golden(filename = '../figures/envchange-exponential-sample.png',
#              plot = p_sample)

g <- ggplotGrob(p_sample)
g <- gtable_add_grob(g, textGrob(expression(bold("B")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/envchange-exponential-sample.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()
trim_file('../figures/envchange-exponential-sample.png')

# All trajectories -------------------------------------------------------------

pall <- ggplot(data=filter(d, EnvChangeFrequency > 100),
               aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    facet_grid(EnvChangeFrequency ~ .) +
    draw_50line() +
    geom_line(size = 0.2) +
    scale_y_continuous(breaks=c(0, 0.5, 1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size = 17) +
    theme(strip.text = element_text(size=rel(0.66), vjust=0.2, face='bold')) +
    theme(axis.text.y = element_text(size=rel(0.66), hjust=1))
#ggsave_golden(filename = '../figures/envchange-exponential-all.png',
#              plot = pall)

g <- ggplotGrob(pall)
g <- gtable_add_grob(g, textGrob(expression(bold("C")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/envchange-exponential-all.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()
trim_file('../figures/envchange-exponential-all.png')
