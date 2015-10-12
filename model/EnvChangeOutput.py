# -*- coding: utf-8 -*-

from OutputWriter import OutputWriter


class EnvChangeOutput(OutputWriter):

    def __init__(self, metapopulation, filename='environmental_change.csv',
                 delimiter=',', compress=False):
        super(EnvChangeOutput, self).__init__(metapopulation=metapopulation,
                                              filename=filename,
                                              delimiter=delimiter,
                                              compress=compress)

        self.writer.writerow(['Time', 'EnvironmentChanged'])

    def update(self, time):
        self.writer.writerow([time, self.metapopulation.environment_changed])

