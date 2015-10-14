# -*- coding: utf-8 -*-

import numpy as np

from hankshaw.OutputWriter import OutputWriter
import hankshaw.genome as genome


class GenotypesOutput(OutputWriter):

    def __init__(self, metapopulation, filename='genotypes.csv', header=True,
                 include_uuid=False, compress=False):

        fieldnames = ['Time', 'Genotype', 'AvgAbundance', 'IsProducer']
        super(GenotypesOutput, self).__init__(metapopulation=metapopulation,
                                              filename=filename,
                                              fieldnames=fieldnames,
                                              header=header,
                                              include_uuid=include_uuid,
                                              compress=compress)

        self.genome_length = self.metapopulation.config['Population']['genome_length']


    def update(self, time):
        abundances = []
        abundances = np.array([d['population'].abundances for n, d in self.metapopulation.topology.nodes_iter(data=True)])
        av = np.average(abundances, 0)
        
        for i in range(2**(self.genome_length+1)):
            isprod = genome.is_producer(i, self.genome_length)
            genotype = i & 2**(self.genome_length)-1
            record = {'Time': time,
                      'Genotype': genotype,
                      'AvgAbundance': av[i],
                      'IsProducer': isprod}
            self.writerow(record)

