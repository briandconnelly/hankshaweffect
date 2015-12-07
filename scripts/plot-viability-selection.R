#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/viability-selection.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

p <- ggplot(data=d, aes(x=Time, y=CooperatorProportion)) +
    draw_50line() +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) + 
    stat_summary(fun.y='mean', geom='line') +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size = fig2_base_size)
p <- rescale_golden(plot = p)
#ggsave_golden('../figures/viability-selection.png')

g <- ggplotGrob(p)
png('../figures/viability-selection.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()
trim_file("../figures/viability-selection.png")