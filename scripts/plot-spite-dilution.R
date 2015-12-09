#!/usr/bin/env Rscript

source('hankshaw.R')

sdata <- read.csv('../data/spite-dilution.csv.bz2')


# Plot Presence of Spiteful Individuals -----------------------------------

data_interval <- 1                                                              

presence <- sdata %>%
    group_by(MinProbDilution, Replicate) %>%
    summarise(Integral=data_interval*sum(CooperatorProportion)/(max(Time)-min(Time)))

figX <- ggplot(data=presence, aes(x=MinProbDilution, y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_log10(breaks=c(0.001, 0.01, 0.1, 1)) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=figlabels['dilute_min'], y=figlabels['spite_presence']) +
    theme_hankshaw(base_size = textbase_3wide)
figX <- rescale_golden(plot=figX)

save_figure(filename='../figures/spite-dilution.png', plot=figX, label='B',
            trim=TRUE)


# Plot Proportion of Spiteful Individuals (Base) --------------------------

basedata <- filter(sdata, MinProbDilution == 0.1)
figbase <- ggplot(basedata, aes(x=Time, y=CooperatorProportion)) +
    draw_50line() +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) + 
    stat_summary(fun.y='mean', geom='line') +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=figlabels['time'], y=figlabels['spite_proportion']) +
    theme_hankshaw(base_size = textbase_3wide)
figbase <- rescale_golden(plot=figbase)

save_figure(filename='../figures/spite-avg-proportion.png', plot=figbase,
            label='A', trim=TRUE)

