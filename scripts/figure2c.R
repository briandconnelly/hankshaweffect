#!/usr/bin/env Rscript

library(magrittr)
library(dplyr)
library(ggplot2)
library(ggplot2bdc)
library(gtable)

source('formatting.R')
source('figsummary.R')

# How often data were logged
data_interval <- 1

data_fig2c <- read.csv('../data/bsweep.csv.bz2')
data_fig2c$Replicate <- as.factor(data_fig2c$Replicate)

data_fig2c_integral <- data_fig2c %>%
    group_by(CooperationBenefit, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

fig2c <- ggplot(data_fig2c_integral, aes(x=as.factor(CooperationBenefit), y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_discrete(breaks=unique(data_fig2c_integral$CooperationBenefit),
                     labels=label_benefits) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_benefit, y=label_producer_presence) +
    theme_hankshaw(base_size=fig2_base_size) +
    theme(axis.text.x = element_text(size=rel(0.9)))
fig2c <- rescale_golden(plot=fig2c)

g <- ggplotGrob(fig2c)
g <- gtable_add_grob(g, textGrob(expression(bold("C")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/Figure2c.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()
trim_file("../figures/Figure2c.png")
