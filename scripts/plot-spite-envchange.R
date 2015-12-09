#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/spite-envchange.csv.bz2')
d$Replicate <- as.factor(d$Replicate)


# Plot cooperator proportion for a single replicate ----------------------------

data_rep <- d %>% filter(Replicate == 8)
changepoints <- expand.grid(EnvChangeFrequency=1000,
                            ChangeTime=seq(from=min(data_rep$Time),
                                           to=max(data_rep$Time), by=1000))

prep <- ggplot(data=data_rep, aes(x=Time, y=CooperatorProportion)) +
    draw_50line() +
    geom_vline(data=changepoints, aes(xintercept=ChangeTime), color='grey70',  
               size=0.1, linetype='solid') + 
    geom_line(size=0.8) +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=figlabels['time'], y=figlabels['spite_proportion']) +
    theme_hankshaw(base_size = textbase_3wide)
prep <- rescale_golden(plot = prep)

save_figure(filename='../figures/spite-envchange-sample.png', plot=prep,
            label='C', trim=TRUE)

