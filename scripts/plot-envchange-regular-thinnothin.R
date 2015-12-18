#!/usr/bin/env Rscript

source('hankshaw.R')

envchangereg <- read.csv('../data/envchange-regular-thinnothin.csv.bz2')
envchangereg$Replicate <- as.factor(envchangereg$Replicate)
envchangereg$GenomeLength <- factor(envchangereg$GenomeLength, levels=c(8,0),
                                    labels=c(figlabels[['with_adapt']],
                                             figlabels[['without_adapt']]))
envchangereg$StressThinning <- factor(envchangereg$StressThinning,
                                      levels=c(TRUE, FALSE),
                                      labels=c(figlabels[['with_stress']],
                                               figlabels[['without_stress']]))

facet_labels <- data.frame(EnvChangeFrequency=c(5, 5, 5, 5),
                           Integral=c(0.93, 0.93, 1, 1),
                           StressThinning=c(figlabels[['with_stress']],
                                            figlabels[['with_stress']],
                                            figlabels[['without_stress']],
                                            figlabels[['without_stress']]),
                           GenomeLength=c(figlabels[['with_adapt']],
                                          figlabels[['without_adapt']],
                                          figlabels[['with_adapt']],
                                          figlabels[['without_adapt']]),
                           Label=c('A', 'B', 'C', 'D'))

data_interval <- 1                                                              

presence <- envchangereg %>%                                                               
    group_by(StressThinning, EnvChangeFrequency, GenomeLength,  Replicate) %>%                                              
    summarise(Integral=data_interval*sum(CooperatorProportion)/(max(Time)-min(Time)))


pX <- ggplot(data=presence, aes(x=EnvChangeFrequency, y=Integral)) +
    facet_grid(StressThinning ~ GenomeLength) +
    stat_summary(fun.data='figsummary') +
    stat_summary(fun.y='mean', geom='line') +
    geom_text(data=facet_labels, aes(label=Label), fontface='bold', vjust=1,
              hjust=0) +
    scale_y_continuous(limits=c(0, 1)) +
    scale_x_log10() +
    labs(x=figlabels[['envchange_period']],
         y=figlabels[['producer_presence']]) +
    theme_hankshaw(base_size=textbase_1wide)
pX <- rescale_square(plot = pX)

save_figure(filename='../figures/envchange-thinnothin.png', plot=pX, trim=TRUE) 
