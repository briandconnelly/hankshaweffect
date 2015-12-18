#!/usr/bin/env Rscript

source('hankshaw.R')

d <- read.csv('../data/fitnessgamma.csv.bz2')
d$Replicate <- as.factor(d$Replicate)


# Fitness Curves ----------------------------------------------------------

base_fitness <- 1.0
benefit_nonzero <- 0.3
production_cost <- 0.1

fdata <- expand.grid(NumOnes=seq(0, 8), Coop=c(FALSE), Shape=unique(d$Shape))
fdata$Fitness <- base_fitness - (fdata$Coop * production_cost) + (benefit_nonzero * (fdata$NumOnes ^ fdata$Shape))

sup <- filter(fdata, Shape >= 1)
sup$Type = 'sup'
sub <- filter(fdata, Shape <= 1)
sub$Type = 'sub'
combined <- bind_rows(sup, sub)
combined$Type <- factor(combined$Type, levels=c('sup', 'sub'), labels=c('Accelerating', 'Decelerating'))


pshape <- ggplot(data=combined, aes(x=NumOnes, y=Fitness, color=as.factor(Shape), linetype=Shape==1)) +
    facet_grid(Type ~ ., scales='free_y', margins=FALSE) +
    geom_line() +
    scale_color_hue(name=figlabels['gamma']) +
    scale_linetype_manual(name=figlabels['gamma'], values=c('TRUE'='dashed', 'FALSE'='solid'), guide=FALSE) +
    #scale_y_log10() +
    labs(x=figlabels["numones"], y=figlabels['fitness']) +
    theme_hankshaw(base_size = textbase_2wide)

save_figure(filename='../figures/fitnessgamma-gamma.png', plot=pshape,
            label='A', trim=TRUE, height=3.708204)


# Individual Trajectories -------------------------------------------------

ptraj <- ggplot(data=d, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    draw_50line() +
    facet_grid(Shape ~ .) +
    geom_line() +
    scale_y_continuous(limits=c(0,1), breaks=c(0, 0.5, 1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=figlabels['time'], y=figlabels['producer_proportion']) +
    theme_hankshaw(base_size=textbase_2wide)
save_figure(filename='../figures/fitnessgamma-all', plot=ptraj,
            trim=TRUE)


# Cooperator Presence -----------------------------------------------------

data_interval <- 1

presence <- d %>%
    group_by(Shape, Replicate) %>%
    summarise(Integral=data_interval*sum(CooperatorProportion)/(max(Time)-min(Time)))

pint <- ggplot(data=presence, aes(x=Shape, y=Integral)) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=figlabels['gamma'], y=figlabels['producer_presence']) +
    theme_hankshaw(base_size = textbase_2wide)
pint <- rescale_golden(plot=pint)

save_figure(filename='../figures/fitnessgamma-integral.png', plot=pint,
            label='B', trim=TRUE)

