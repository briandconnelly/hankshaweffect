# Theme for ggplot2

theme_hankshaw <- function (base_size=12, base_family="", grid.x=FALSE,
                            grid.y=FALSE, ticks.x=TRUE, ticks.y=TRUE)
{
    theme_bdc_grey(base_size=base_size) + theme(strip.background = element_rect(fill="grey90", colour=NA)) + theme(strip.text = element_text(color="black", face="plain")) + theme(axis.text = element_text(size = rel(0.8), color = "grey30"))
}

