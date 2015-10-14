# -*- coding: utf-8 -*-

from hankshaw.OutputWriter import OutputWriter


class PopulationOutput(OutputWriter):

    def __init__(self, metapopulation, filename='population.csv',
                 header=True, include_uuid=False, compress=False):
        fieldnames = ['Time', 'Population', 'Size', 'Producers',
                      'PropProducers', 'NonProducers', 'PropNonProducers',
                      'AvgFitness']
        super(PopulationOutput, self).__init__(metapopulation=metapopulation,
                                               filename=filename,
                                               fieldnames=fieldnames,
                                               header=header,
                                               include_uuid=include_uuid,
                                               compress=compress)

    def update(self, time):
        for n, d in self.metapopulation.topology.nodes_iter(data=True):
            size = len(d['population'])

            if size == 0:
                num_producers = 0
                num_nonproducers = 0
                prop_producers = 'NA'
                prop_nonproducers = 'NA'
                average_fitness = 'NA'
            else:
                num_producers = d['population'].num_producers()
                num_nonproducers = size - num_producers
                prop_producers = 1.0*num_producers/size
                prop_nonproducers = 1.0*num_nonproducers/size
                average_fitness = d['population'].average_fitness()

            record = {'Time': time,
                      'Population': n,
                      'Size': size, 
                      'Producers': num_producers,
                      'PropProducers': prop_producers,
                      'NonProducers': num_nonproducers,
                      'PropNonProducers': prop_nonproducers,
                      'AvgFitness': average_fitness}
            self.writerow(record)

