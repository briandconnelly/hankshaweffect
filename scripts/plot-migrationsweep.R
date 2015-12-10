#!/usr/bin/env Rscript

source('hankshaw.R')

# How often data were logged
data_interval <- 1

d <- read.csv('../data/migrationsweep.csv.bz2')
d$Replicate <- as.factor(d$Replicate)

presence <- d %>%
    group_by(MigrationRate, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

migration_labels_log <- c(expression(paste(5, 'x', 10^{-7})),
                          expression(paste(5, 'x', 10^{-6})),
                          expression(paste(5, 'x', 10^{-5})),
                          expression(paste(5, 'x', 10^{-4})),
                          expression(paste(5, 'x', 10^{-3})),
                          expression(bold(paste('5', 'x', '10'^{'-2'}))),
                          expression(paste(5, 'x', 10^{-1})))

pint <- ggplot(data=presence, aes(x=MigrationRate, y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_log10(breaks=unique(presence$MigrationRate),
                  labels=migration_labels_log) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=figlabels['migration_rate'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size=textbase_2wide)
pint <- rescale_golden(plot=pint)

save_figure(filename='../figures/migrationsweep-integral.png', plot=pint,
            label='E', trim=TRUE)
