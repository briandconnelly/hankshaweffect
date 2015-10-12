# -*- coding: utf-8 -*-

from hankshaw.OutputWriter import OutputWriter


class FitnessOutput(OutputWriter):

    def __init__(self, metapopulation, filename='max_fitness.csv',
                 delimiter=',', compress=False):
        super(FitnessOutput, self).__init__(metapopulation=metapopulation,
                                            filename=filename,
                                            delimiter=delimiter,
                                            compress=compress)

        self.writer.writerow(['Time', 'Producers', 'Nonproducers'])

    def update(self, time):
        maxfit = self.metapopulation.max_fitnesses()
        self.writer.writerow([time, max(maxfit[0]), max(maxfit[1])])
