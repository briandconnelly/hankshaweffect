#!/usr/bin/env Rscript

source('hankshaw.R')

fig1data <- read.csv('../data/lsweep.csv.bz2') %>%
    filter(GenomeLength == 8 & Structured == TRUE)
fig1data$Replicate <- as.factor(fig1data$Replicate)
fig1data$Pooling <- FALSE

pdata <- read.csv('../data/poolingsweep.csv.bz2') %>%
    filter(MixingFrequency == 1)
pdata$Replicate <- as.factor(pdata$Replicate)
pdata$Pooling <- TRUE

d <- bind_rows(fig1data, pdata)
d$Pooling <- factor(d$Pooling, levels=c(FALSE,TRUE),
                    labels=c(figlabels[['without_pool']],
                             figlabels[['with_pool']]))

# Coooperator proportions for pooling vs not -----------------------------------

p <- ggplot(data=d, aes(x=Time, y=CooperatorProportion)) +
    facet_grid(. ~ Pooling) +
    draw_50line() +
    stat_summary(fun.data='figsummary', geom='ribbon', color=NA, alpha=0.2) + 
    stat_summary(fun.y='mean', geom='line') +
    scale_y_continuous(limits=c(0,1)) +
    labs(x=figlabels['time'], y=figlabels['producer_proportion']) + 
    theme_hankshaw(base_size=textbase_2wide)
p <- rescale_square(plot = p)

save_figure(filename='../figures/poolingnopooling.png', plot=p, trim=TRUE)

