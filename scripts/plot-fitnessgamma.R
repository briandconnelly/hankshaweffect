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
    scale_color_hue(name=label_gamma) +
    scale_linetype_manual(name=label_gamma, values=c('TRUE'='dashed', 'FALSE'='solid'), guide=FALSE) +
    #scale_y_log10() +
    labs(x=label_numones, y=label_fitness) +
    theme_hankshaw(base_size = fig2_base_size) +
    theme(legend.position=c(.5, 1.035), legend.justification=c(0.5, 0.5))

g <- ggplotGrob(pshape)
g <- gtable_add_grob(g, textGrob(expression(bold("A")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)
png('../figures/fitnessgamma-gamma.png', width=6, height=3.708204, units='in', res=figure_dpi)
grid.draw(g)
dev.off()
trim_file("../figures/fitnessgamma-gamma.png")


# Individual Trajectories -------------------------------------------------

ptraj <- ggplot(data=d, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    draw_50line() +
    facet_grid(Shape ~ .) +
    geom_line() +
    scale_y_continuous(limits=c(0,1), breaks=c(0, 0.5, 1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size=17)
ggsave_golden(filename = '../figures/fitnessgamma-all.png', plot = ptraj)


# Cooperator Presence -----------------------------------------------------

data_interval <- 1

presence <- d %>%
    group_by(Shape, Replicate) %>%
    summarise(Integral=data_interval*sum(CooperatorProportion)/(max(Time)-min(Time)))

pint <- ggplot(data=presence, aes(x=Shape, y=Integral)) +
    stat_summary(fun.data='figsummary', size=point_size) +
    scale_y_continuous(limits=c(0, 1)) +
    labs(x=label_gamma, y=label_producer_presence) +
    theme_hankshaw(base_size = fig2_base_size)
pint <- rescale_golden(plot=pint)

g <- ggplotGrob(pint)
g <- gtable_add_grob(g, textGrob(expression(bold("B")),
                                 gp=gpar(col='black', fontsize=20),
                                 x=0, hjust=0, vjust=0.5), t=1, l=2)
png('../figures/fitnessgamma-integral.png', width=6, height=6, units='in', res=figure_dpi)
grid.draw(g)
dev.off()
trim_file("../figures/fitnessgamma-integral.png")

