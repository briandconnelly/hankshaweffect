# -*- coding: utf-8 -*-

from hankshaw.OutputWriter import OutputWriter


class PopulationOutput(OutputWriter):

    def __init__(self, metapopulation, filename='population.csv',
                 delimiter=',', compress=False):
        super(PopulationOutput, self).__init__(metapopulation=metapopulation,
                                               filename=filename,
                                               delimiter=delimiter,
                                               compress=compress)

        self.writer.writerow(['Time', 'Population', 'Size', 'Producers',
                              'PropProducers', 'NonProducers',
                              'PropNonProducers', 'AvgFitness'])

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

            self.writer.writerow([time, n, size, num_producers, prop_producers,
                                  num_nonproducers, prop_nonproducers,
                                  average_fitness])

