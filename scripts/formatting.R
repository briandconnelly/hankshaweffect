source('theme_hankshaw.R')
ggplot2::theme_set(theme_hankshaw())
draw_50line <- function() ggplot2::geom_hline(yintercept=0.5, linetype='dotted', size=0.5, color='grey70', size=0.1)

figure_dpi <- 600
point_size <- 0.8
max_time <- 2000

fig2_base_size <- 14

label_time <- 'Time'
label_producer_proportion <- 'Cooperator Proportion'
label_producer_presence <- 'Cooperator Presence'
label_spite_proportion <- 'Proportion of\nSpiteful Individuals'
label_spite_presence <- 'Presence of\nSpiteful Individuals'
label_genome_length <- 'Number of Adaptive Loci'
label_migration_rate <- 'Migration Rate'
label_mu <- 'Mutation Rate'
label_socialmu <- 'Mutation Rate at Cooperation Locus'
label_stressmu <- 'Mutation Rate at Adaptive Loci'
label_benefit <- 'Benefit of Cooperation'
label_cost <- 'Cost of Cooperation'
label_envchange_freq <- 'Environmental Change Frequency'
label_longdistance <- 'Prob. Random Migration'
label_topology <- 'Migration Topology'
label_dilute_min <- 'Minimum Probability of Dilution'
label_with_stress <- 'With Stress Induced Thinning'
label_without_stress <- 'Without Stress Induced Thinning'

label_genomelengths <- c('0', '1', '2', '3', '4', '5', '6', '7', expression(bold('8')), '9', '10')
label_genomelengths08 <- c('0', expression(bold('8')) )
label_structure <- c('lattice, 25x25'=expression(bold('Structured')), 'well-mixed, 625'='Unstructured')

label_producer_proportion_sd <- expression(bold(paste(sigma, '(Proportion of Cooperators Surviving)')))


##label_benefits <- c('0', '200', '400', '600', '800', '1000', expression(bold('1200')), '1400', '1600', '1800', '2000')
label_benefits <- c('0', '150', '300', '450', '600', '750', '900', '1050',  expression(bold('1200')), '1350', '1500', '1650')

cost_labels <- c('0.0'='0.0', '0.1'=expression(bold('0.1')), '0.2'='0.2',
                 '0.3'='0.3', '0.4'='0.4', '0.5'='0.5')

mutation_labels <- c('1e-07'='0.0000001', '1e-06'='0.000001',
                     '1e-05'=expression(bold('0.00001')), '1e-04'='0.0001',
                     '1e-03'='0.001', '1e-02'='0.01', '1e-01'='0.1')

mutation_labels2 <- c('1e-05'=expression(bold('0.00001')), '1e-04'='0.0001',
                     '1e-03'='0.001', '1e-02'='0.01', '1e-01'='0.1', '1e+00'=1)

replicate_alpha <- 0.1

color_L00 <- '#777777'
color_L08 <- '#BBBBBB'

trim_file <- function(f) system(sprintf("convert -trim '%s' '%s'", f, f))
trim_pdf <- function(f) system(sprintf("pdfcrop '%s' '%s'", f, f))

