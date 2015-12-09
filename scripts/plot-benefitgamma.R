#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/benefitgamma.csv.bz2')
d$Replicate <- as.factor(d$Replicate)


# Benefit Curves ----------------------------------------------------------

S <- 2000
s <- 800     

pdata <- expand.grid(Time=1:100000/100000, Gamma=unique(d$Gamma))
pdata$PSize <- s + ((pdata$Time^pdata$Gamma) * (S-s))  

p_gamma <- ggplot(pdata, aes(x=Time, y=PSize, color=as.factor(Gamma))) +        
    geom_hline(yintercept=s, linetype='dotted', size=0.5, color='grey70', size=0.1) +
    geom_hline(yintercept=S, linetype='dotted', size=0.5, color='grey70', size=0.1) +
    geom_line() +                                                               
    scale_color_hue(name=figlabels['gamma']) +                                   
    scale_y_continuous(limits=c(0,S), breaks=c(0,s,S),                       
                       labels=c('0',expression(S['min']),expression(S['max']))) +
    labs(x=figlabels['producer_proportion'], y=figlabels['carrying_capacity']) +       
    theme_hankshaw(base_size = textbase_2wide) +
    theme(legend.position=c(.5, 1.035), legend.justification=c(0.5, 0.5))   
p_gamma <- rescale_golden(plot=p_gamma)

save_figure(filename='../figures/benefitgamma-gamma.png', plot=p_gamma,
            label='A', trim=TRUE)


# Individual Trajectories -------------------------------------------------

ptraj <- ggplot(data=d, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    draw_50line() +
    facet_grid(Gamma ~ .) +
    geom_line() +
    scale_y_continuous(limits=c(0,1), breaks=c(0, 0.5, 1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=figlabels['time'], y=figlabels['producer_proportion']) +
    theme_hankshaw(base_size = textbase_2wide)

save_figure(filename='../figures/benefitgamma-all.png', plot=ptraj,
            label='B', trim=TRUE, height=3.708204)


# Cooperator Presence -----------------------------------------------------

data_interval <- 1

presence <- d %>%
    group_by(Gamma, Replicate) %>%
    summarise(Integral=data_interval*sum(CooperatorProportion)/(max(Time)-min(Time)))

pint <- ggplot(data=presence, aes(x=Gamma, y=Integral)) +
    draw_replicates() +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0, 1)) +
    scale_x_continuous(limits=c(0, 4)) +
    labs(x=figlabels['gamma'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size = textbase_2wide)
pint <- rescale_golden(plot=pint)

save_figure(filename='../figures/benefitgamma-integral.png', plot=pint,
            label='B', trim=TRUE)

