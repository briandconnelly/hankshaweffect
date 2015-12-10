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
    labs(x=figlabels['mu'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size = textbase_2wide)
fig2f <- rescale_golden(plot=fig2f)

save_figure(filename='../figures/mutationsweep-integral.png', plot=fig2f,
            label='F', trim=TRUE)

