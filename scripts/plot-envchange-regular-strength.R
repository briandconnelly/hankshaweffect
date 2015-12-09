#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/envchange-regular-strength.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

data_interval <- 1                                                              
presence <- d %>%                                                     
    group_by(AllelesAffected, Replicate) %>%                                    
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

figX <- ggplot(presence, aes(x=AllelesAffected, y=Integral)) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_continuous(breaks=seq(1,8)) +
    labs(x=figlabels['stress_strength'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size=17)
figX <- rescale_golden(plot=figX)
ggsave_golden(filename = '../figures/envchange-regular-strength-integral.png', plot = figX)

