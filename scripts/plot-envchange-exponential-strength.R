#!/usr/bin/env Rscript

source('hankshaw.R')

dcoop <- read.csv('../data/envchange-exponential-strength-cooppct.csv.bz2')
dcoop$Replicate <- as.factor(dcoop$Replicate)


# All Trajectories --------------------------------------------------------

pall <- ggplot(data=dcoop, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    facet_grid(EnvChangeStrength ~ .) +
    draw_50line() +
    geom_line() +
    scale_y_continuous(limits=c(0,1), breaks=c(0,0.5,1)) +
    scale_color_grey(guide = FALSE) +
    labs(x=figlabels['time'], y=figlabels['producer_proportion']) +
    theme_hankshaw(base_size = textbase_1wide)
ggsave_golden(filename='../figures/envchange-exponential-strength-all.png', plot=pall)


# Cooperator Presence -----------------------------------------------------

data_interval <- 1                                                        
presence <- dcoop %>%                                                     
    group_by(EnvChangeStrength, Replicate) %>%                                    
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

pint <- ggplot(data=presence, aes(x=EnvChangeStrength, y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_continuous(breaks=seq(1, 8)) +
    labs(x=figlabels['stress_strength'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size = textbase_1wide)
pint <- rescale_golden(plot=pint)

save_figure(filename='../figures/envchange-exponential-strength-integral.png',
            plot=pint, trim=TRUE)

