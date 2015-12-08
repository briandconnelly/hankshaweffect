#!/usr/bin/env Rscript

source('hankshaw.R')

echctrl <- read.csv('../data/envchange-control.csv.bz2')
echctrl$Replicate <- as.factor(echctrl$Replicate)

pX <- ggplot(data=echctrl, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    draw_50line() +
    geom_line(size=0.2) +
    scale_y_continuous(limits=c(0,1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size=17)
pX <- rescale_golden(plot = pX)
#ggsave_golden(filename = '../figures/envchange-control.png', plot = pX)

g <- ggplotGrob(pX)
g <- gtable_add_grob(g, textGrob(expression(bold("A")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/envchange-control.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()
trim_file('../figures/envchange-control.png')
