#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/nosocialmu.csv.bz2')

d$Replicate <- as.factor(d$Replicate)
d$Structured <- factor(d$Structured, levels=c(FALSE, TRUE),
                       labels=c(figlabels['pop_unstruct'],
                                figlabels['pop_struct']))
d$GenomeLength <- factor(d$GenomeLength, levels=c(0, 8),
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

figX <- ggplot(d, aes(x=Time, y=CooperatorProportion)) +
    facet_grid(Structured ~ GenomeLength) +
    draw_50line() +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) + 
    stat_summary(fun.y='mean', geom='line') +
    geom_text(data=facet_labels, aes(label=Label), fontface='bold', vjust=1, hjust=0) +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=figlabels['time'], y=figlabels['producer_proportion']) +
    theme_hankshaw(base_size=textbase_1wide)
figX <- rescale_square(plot=figX)

save_figure(filename='../figures/nosocialmu.png', plot=figX, trim=TRUE)


# Plot trajectories of replicate populations in structured, L=8 ----------------
# CUT?
# tdata <- d %>% filter(Structured == 'Structured Population' & GenomeLength == 'With Stress Adaptation')
# figY <- ggplot(data=tdata, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
#     draw_50line() +
#     geom_line() +
#     scale_color_grey(guide=FALSE) +
#     scale_y_continuous(limits=c(0,1)) +
#     labs(x=figlabels['time'], y=figlabels['producer_proportion'])
# figY <- rescale_golden(plot=figY)
# ggsave_golden(plot=figY, '../figures/nosocialmu-trajectories.png', dpi=figure_dpi)
# trim_file("../figures/nosocialmu-trajectories.png")

