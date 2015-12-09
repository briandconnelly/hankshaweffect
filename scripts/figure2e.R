#!/usr/bin/env Rscript

source('hankshaw.R')

# How often data were logged
data_interval <- 1

data_fig2e <- read.csv('../data/migrationsweep.csv.bz2')
data_fig2e$Replicate <- as.factor(data_fig2e$Replicate)

data_fig2e_integral <- data_fig2e %>%
    group_by(MigrationRate, Replicate) %>%
    summarise(Integral=data_interval * sum(CooperatorProportion)/(max(Time)-min(Time)))

migration_labels_log <- c(expression(paste(5, 'x', 10^{-7})),
                          expression(paste(5, 'x', 10^{-6})),
                          expression(paste(5, 'x', 10^{-5})),
                          expression(paste(5, 'x', 10^{-4})),
                          expression(paste(5, 'x', 10^{-3})),
                          expression(bold(paste('5', 'x', '10'^{'-2'}))),
                          expression(paste(5, 'x', 10^{-1})))

fig2e <- ggplot(data_fig2e_integral, aes(x=MigrationRate, y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_x_log10(breaks=unique(data_fig2e_integral$MigrationRate),
                  labels=migration_labels_log) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=figlabels['migration_rate'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size=textbase_2wide)
fig2e <- rescale_golden(plot=fig2e)

save_figure(filename='../figures/Figure2e.png', plot=fig2e, label='E',
            trim=TRUE)
