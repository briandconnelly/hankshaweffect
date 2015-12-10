#!/usr/bin/env Rscript

source('hankshaw.R')

# How often data were logged
data_interval <- 1

d <- read.csv('../data/mutationsweep.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

presence <- d %>%
    group_by(MutationRate, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

mutation_labels_log <- c(expression(10^{-7}),
                         expression(10^{-6}),
                         expression(bold('10'^{'-5'})),
                         expression(10^{-4}),
                         expression(10^{-3}),
                         expression(10^{-2}),
                         expression(10^{-1}))

pint <- ggplot(data=presence, aes(x=as.factor(MutationRate), y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_discrete(breaks=sort(unique(presence$MutationRate)),
                     labels=mutation_labels_log) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=figlabels['mu'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size = textbase_2wide)
pint <- rescale_golden(plot=pint)

save_figure(filename='../figures/mutationsweep-integral.png', plot=pint,
            label='F', trim=TRUE)

