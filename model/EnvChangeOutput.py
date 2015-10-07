# -*- coding: utf-8 -*-

import bz2
import csv

from OutputWriter import OutputWriter


class EnvChangeOutput(OutputWriter):

    def __init__(self, metapopulation, filename='environmental_change.csv.bz2', delimiter=','):
        super(EnvChangeOutput, self).__init__(metapopulation=metapopulation,
                                              filename=filename,
                                              delimiter=delimiter)

        self.writer.writerow(['Time', 'EnvironmentChanged'])

    def update(self, time):
        self.writer.writerow([time, self.metapopulation.environment_changed])

