#!/usr/bin/env Rscript

source('hankshaw.R')

# How often data were logged
data_interval <- 1

d <- read.csv('../data/mutationsweep-adaptive.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

presence <- d %>%
    group_by(MutationRateAdaptation, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

mutation_labels_log <- c(expression(10^{-7}),
                         expression(10^{-6}),
                         expression(bold('10'^{'-5'})),
                         expression(10^{-4}),
                         expression(10^{-3}),
                         expression(10^{-2}),
                         expression(10^{-1}))

pint <- ggplot(data=presence, aes(x=MutationRateAdaptation, y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_log10(breaks=unique(presence$MutationRateAdaptation),
                  labels=mutation_labels_log) +
    labs(x=figlabels['stressmu'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size = textbase_3wide)
pint <- rescale_golden(plot = pint)

save_figure(filename = "../figures/mutationsweep-adaptive.png", plot = pint,
            label='A', trim=TRUE)

