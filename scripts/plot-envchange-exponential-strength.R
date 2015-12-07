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
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw()
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
    labs(x=label_stress_strength, y=label_producer_presence) +
    theme_hankshaw(base_size = fig2_base_size)
pint <- rescale_golden(plot=pint)
#ggsave_golden(filename='../figures/envchange-exponential-strength-integral.png',
#              plot=pint)

g <- ggplotGrob(pint)
png('../figures/envchange-exponential-strength-integral.png',
    width=6, height=6, units='in', res=figure_dpi)
grid.draw(g)
dev.off()
trim_file("../figures/envchange-exponential-strength-integral.png")

