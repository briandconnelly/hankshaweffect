#!/usr/bin/env Rscript

source('hankshaw.R')

echctrl <- read.csv('../data/envchange-control.csv.bz2')
echctrl$Replicate <- as.factor(echctrl$Replicate)

pX <- ggplot(data=echctrl,
             aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    draw_50line() +
    geom_line(size=0.2) +
    scale_y_continuous(limits=c(0,1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=figlabels['time'], y=figlabels['producer_proportion']) +
    theme_hankshaw(base_size = textbase_3wide)
pX <- rescale_golden(plot = pX)

save_figure(filename='../figures/envchange-control.png', plot=pX, label='A',
            trim=TRUE)

