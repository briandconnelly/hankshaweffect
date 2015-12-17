#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/wellmixed-histress.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

figX <- ggplot(d, aes(x=Time, y=CooperatorProportion)) +
    draw_50line() +                                                             
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) +   
    stat_summary(fun.y='mean', geom='line') +                                   
    scale_y_continuous(limits=c(0,1)) +                                         
    labs(x=figlabels['time'], y=figlabels['producer_proportion']) +             
    theme_hankshaw(base_size=textbase_1wide)                                    
figX <- rescale_golden(plot=figX)                                               

save_figure(filename='../figures/wellmixed-histress.png', plot=figX, trim=TRUE)

