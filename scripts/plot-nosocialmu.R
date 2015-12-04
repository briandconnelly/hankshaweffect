#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/nosocialmu.csv.bz2')

d$Replicate <- as.factor(d$Replicate)
d$Structured <- factor(d$Structured, levels=c(FALSE, TRUE),
                       labels=c("Unstructured Population",
                                "Structured Population"))
d$GenomeLength <- factor(d$GenomeLength, levels=c(0, 8),
                         labels=c("Without Stress Adaptation",
                                  "With Stress Adaptation"))

facet_labels <- data.frame(Time=0, CooperatorProportion=1,
                           GenomeLength=c("Without Stress Adaptation",
                                          "Without Stress Adaptation",
                                          "With Stress Adaptation",
                                          "With Stress Adaptation"),
                           Structured=c("Unstructured Population",
                                        "Structured Population",
                                        "Unstructured Population",
                                        "Structured Population"),
                           Label=c('A','C','B','D'))

figX <- ggplot(d, aes(x=Time, y=CooperatorProportion)) +
    facet_grid(Structured ~ GenomeLength) +
    draw_50line() +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) + 
    stat_summary(fun.y='mean', geom='line') +
    geom_text(data=facet_labels, aes(label=Label), vjust=1, hjust=0) +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=label_time, y=label_producer_proportion)
figX <- rescale_square(plot=figX)
ggsave(plot=figX, '../figures/nosocialmu.png', width=6, height=6, dpi=figure_dpi)
trim_file("../figures/nosocialmu.png")


# Plot trajectories of replicate populations in structured, L=8 ----------------
tdata <- d %>% filter(Structured == 'Structured Population' & GenomeLength == 'With Stress Adaptation')
figY <- ggplot(data=tdata, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    draw_50line() +
    geom_line() +
    scale_color_grey(guide=FALSE) +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=label_time, y=label_producer_proportion)
figY <- rescale_golden(plot=figY)
ggsave_golden(plot=figY, '../figures/nosocialmu-trajectories.png', dpi=figure_dpi)
trim_file("../figures/nosocialmu-trajectories.png")

