#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/envchange-exponential-cooppct.csv.bz2')
d$Replicate <- as.factor(d$Replicate)


# Sample trajectory ------------------------------------------------------------

data_sample <- d %>% filter(EnvChangeFrequency == 500 & Replicate == 36)

p_sample <- ggplot(data=data_sample, aes(x=Time, y=CooperatorProportion)) +
    draw_50line() +
    geom_line() +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=figlabels['time'], y=figlabels['producer_proportion']) +
    theme_hankshaw(base_size = textbase_3wide)
p_sample <- rescale_golden(plot = p_sample)

save_figure(filename='../figures/envchange-exponential-sample.png',
            plot=p_sample, label='B', trim=TRUE)


# All trajectories -------------------------------------------------------------

pall <- ggplot(data=filter(d, EnvChangeFrequency > 100),
               aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    facet_grid(EnvChangeFrequency ~ .) +
    draw_50line() +
    geom_line(size = 0.2) +
    scale_y_continuous(breaks=c(0, 0.5, 1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=figlabels['time'], y=figlabels['producer_proportion']) +
    theme_hankshaw(base_size = textbase_3wide) +
    theme(strip.text = element_text(size=rel(0.66), vjust=0.2, face='bold')) +
    theme(axis.text.y = element_text(size=rel(0.66), hjust=1))

save_figure(filename='../figures/envchange-exponential-all.png',
            plot=pall, label='C', trim=TRUE, height=3.708204)

