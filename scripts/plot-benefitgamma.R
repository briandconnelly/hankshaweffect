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
    scale_color_hue(name=label_gamma) +                                   
    scale_y_continuous(limits=c(0,S), breaks=c(0,s,S),                       
                       labels=c('0',expression(S['min']),expression(S['max']))) +
    labs(x=label_producer_proportion, y=label_carrying_capacity) +       
    theme_hankshaw(base_size = fig2_base_size) +
    theme(legend.position=c(.5, 1.035), legend.justification=c(0.5, 0.5))   
p_gamma <- rescale_golden(plot=p_gamma)
#ggsave_golden(filename='../figures/benefitgamma-gamma.png', plot=p_gamma)

g <- ggplotGrob(p_gamma)
g <- gtable_add_grob(g, textGrob(expression(bold("A")),
                                 gp=gpar(col='black', fontsize=20), x=0,
                                 hjust=0, vjust=0.5), t=1, l=2)
png('../figures/benefitgamma-gamma.png', width=6, height=6, units='in', res=figure_dpi)
grid.draw(g)
dev.off()
trim_file("../figures/benefitgamma-gamma.png")

# Individual Trajectories -------------------------------------------------

ptraj <- ggplot(data=d, aes(x=Time, y=CooperatorProportion, color=Replicate)) +
    draw_50line() +
    facet_grid(Gamma ~ .) +
    geom_line() +
    scale_y_continuous(limits=c(0,1), breaks=c(0, 0.5, 1)) +
    scale_color_grey(guide=FALSE) +
    labs(x=label_time, y=label_producer_proportion) +
    theme_hankshaw(base_size = fig2_base_size)
#ggsave_golden(filename = '../figures/benefitgamma-all.png', plot = ptraj)

g <- ggplotGrob(ptraj)
g <- gtable_add_grob(g, textGrob(expression(bold("B")),
                                 gp=gpar(col='black', fontsize=20), x=0,
                                 hjust=0, vjust=0.5), t=1, l=2)
png('../figures/benefitgamma-all.png', width=6, height=6, units='in', res=figure_dpi)
grid.draw(g)
dev.off()
trim_file("../figures/benefitgamma-all.png")

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
    labs(x=label_gamma, y=label_producer_presence) +
    theme_hankshaw(base_size = fig2_base_size)
pint <- rescale_golden(plot=pint)
#ggsave_golden(filename = '../figures/benefitgamma-integral.png', plot = pint)

g <- ggplotGrob(pint)
g <- gtable_add_grob(g, textGrob(expression(bold("B")),
                                 gp=gpar(col='black', fontsize=20), x=0,
                                 hjust=0, vjust=0.5), t=1, l=2)
png('../figures/benefitgamma-integral.png', width=6, height=6, units='in', res=figure_dpi)
grid.draw(g)
dev.off()
trim_file("../figures/benefitgamma-integral.png")

