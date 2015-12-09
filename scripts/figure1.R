#!/usr/bin/env Rscript

source('hankshaw.R')

fig1data <- read.csv('../data/lsweep.csv.bz2') %>%
    filter(GenomeLength %in% c(0, 8))

fig1data$Replicate <- as.factor(fig1data$Replicate)
fig1data$Structured <- factor(fig1data$Structured, levels=c(FALSE, TRUE),
                              labels=c(figlabels['pop_unstruct'],
                                       figlabels['pop_struct']))
fig1data$GenomeLength <- factor(fig1data$GenomeLength, levels=c(0, 8),
                                labels=c(figlabels['without_adapt'],
                                         figlabels['with_adapt']))

facet_labels <- data.frame(Time=0, CooperatorProportion=1,
                           GenomeLength=c(figlabels['without_adapt'],
                                          figlabels['without_adapt'],
                                          figlabels['with_adapt'],
                                          figlabels['with_adapt']),
                           Structured=c(figlabels['pop_unstruct'],
                                        figlabels['pop_struct'],
                                        figlabels['pop_unstruct'],
                                        figlabels['pop_struct']),
                           Label=c('A','C','B','D'))

fig1 <- ggplot(data=fig1data, aes(x=Time, y=CooperatorProportion)) +
    facet_grid(Structured ~ GenomeLength) +
    draw_50line() +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) + 
    stat_summary(fun.y='mean', geom='line') +
    geom_text(data=facet_labels, aes(label=Label), fontface='bold', vjust=1, hjust=0) +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=figlabels['time'], y=figlabels['producer_proportion']) + 
    theme_hankshaw(base_size=textbase_1wide)
fig1 <- rescale_square(plot=fig1)

save_figure(filename='../figures/Figure1.png', plot=fig1, trim=TRUE)

