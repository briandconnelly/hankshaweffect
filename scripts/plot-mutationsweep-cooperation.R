#!/usr/bin/env Rscript

source('hankshaw.R')

# How often data were logged
data_interval <- 1

d <- read.csv('../data/mutationsweep-cooperation.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

presence <- d %>%
    group_by(MutationRateSocial, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

mutation_labels_log <- c(expression(10^{-7}),
                         expression(10^{-6}),
                         expression(bold('10'^{'-5'})),
                         expression(10^{-4}),
                         expression(10^{-3}),
                         expression(10^{-2}),
                         expression(10^{-1}))

pint <- ggplot(data=presence, aes(x=MutationRateSocial, y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0,1)) +
    scale_x_log10(breaks=unique(presence$MutationRateSocial),
                  labels=mutation_labels_log) +
    labs(x=figlabels['socialmu'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size = textbase_3wide)
pint <- rescale_golden(plot = pint)

save_figure(filename = "../figures/mutationsweep-cooperation.png", plot = pint,
            label='B', trim=TRUE)


# Plot the trajectory of cooperator proportion with frequent mutations ---------
dmax <- d %>% filter(MutationRateSocial == max(MutationRateSocial))

pmax <- ggplot(data=dmax, aes(x=Time, y=CooperatorProportion)) +
    draw_50line() +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) +
    stat_summary(fun.y='mean', geom='line', color='black', size=point_size) +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=figlabels['time'], y=figlabels['producer_proportion']) +
    theme_hankshaw(base_size = textbase_3wide)
pmax <- rescale_golden(plot=pmax)

save_figure(filename = "../figures/mutationsweep-cooperation-mumax.png",
            plot = pmax, label='C', trim=TRUE)

