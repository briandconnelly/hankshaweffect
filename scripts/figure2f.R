#!/usr/bin/env Rscript

source('hankshaw.R')

# How often data were logged
data_interval <- 1

data_fig2f <- read.csv('../data/mutationsweep.csv.bz2')
data_fig2f$Replicate <- as.factor(data_fig2f$Replicate)

data_fig2f_integral <- data_fig2f %>%
    group_by(MutationRate, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

mutation_labels_log <- c(expression(10^{-7}),
                         expression(10^{-6}),
                         expression(bold('10'^{'-5'})),
                         expression(10^{-4}),
                         expression(10^{-3}),
                         expression(10^{-2}),
                         expression(10^{-1}))

fig2f <- ggplot(data_fig2f_integral, aes(x=as.factor(MutationRate),
                                         y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_discrete(breaks=sort(unique(data_fig2f_integral$MutationRate)),
                     labels=mutation_labels_log) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_mu, y=label_producer_presence) +
    theme_hankshaw(base_size=fig2_base_size)
fig2f <- rescale_golden(plot=fig2f)

g <- ggplotGrob(fig2f)
g <- gtable_add_grob(g, textGrob(expression(bold('F')),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)

png('../figures/Figure2f.png', width=6, height=3.708204, units='in',
    res=figure_dpi)
grid.draw(g)
dev.off()
trim_file("../figures/Figure2f.png")
