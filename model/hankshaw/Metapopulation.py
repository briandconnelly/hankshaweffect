# -*- coding: utf-8 -*-

import os

import networkx as nx
import numpy as np
from numpy import zeros as zeros
from numpy.random import binomial, choice as nchoice, exponential, random_integers

from hankshaw import genome
from hankshaw.Population import Population
import hankshaw.topology as topology
from hankshaw.PopulationOutput import PopulationOutput
from hankshaw.MetapopulationOutput import MetapopulationOutput
from hankshaw.GenotypesOutput import GenotypesOutput
from hankshaw.FitnessOutput import FitnessOutput
from hankshaw.EnvChangeOutput import EnvChangeOutput


class Metapopulation(object):

    def __init__(self, config):
        """Initialize a Metapopulation object"""
        self.config = config
        self.time = 0
        self.num_births = 0

        self.migration_rate = self.config['Metapopulation']['migration_rate']
        self.migration_dest = self.config['Metapopulation']['migration_dest']
        self.migration_p_far = self.config['Metapopulation']['migration_p_far']
        topology_type = self.config['Metapopulation']['topology']

        if topology_type.lower() == 'moore':
            width = self.config['MooreTopology']['width']
            height = self.config['MooreTopology']['height']
            periodic = self.config['MooreTopology']['periodic']
            radius = self.config['MooreTopology']['radius']

            self.topology = topology.moore_lattice(rows=height, columns=width,
                                                   radius=radius,
                                                   periodic=periodic)

        elif topology_type.lower() == 'vonneumann':
            width = self.config['VonNeumannTopology']['width']
            height = self.config['VonNeumannTopology']['height']
            periodic = self.config['VonNeumannTopology']['periodic']

            self.topology = topology.vonneumann_lattice(rows=height,
                                                        columns=width,
                                                        periodic=periodic)

        elif topology_type.lower() == 'smallworld':
            size = self.config['SmallWorldTopology']['size']
            neighbors = self.config['SmallWorldTopology']['neighbors']
            edgeprob = self.config['SmallWorldTopology']['edgeprob']

            if self.config['SmallWorldTopology']['seed'] == 0:
                self.config['SmallWorldTopology']['seed'] = self.config['Simulation']['seed']

            seed = self.config['SmallWorldTopology']['seed']

            self.topology = topology.smallworld(size=size, neighbors=neighbors,
                                                edgeprob=edgeprob, seed=seed)


        elif topology_type.lower() == 'complete':
            self.topology = nx.complete_graph(n=self.config['CompleteTopology']['size'])


        elif topology_type.lower() == 'regular':
            size = self.config['RegularTopology']['size']
            degree = self.config['RegularTopology']['degree']

            if self.config['RegularTopology']['seed'] == 0:
                self.config['RegularTopology']['seed'] = self.config['Simulation']['seed']

            seed = self.config['RegularTopology']['seed']

            self.topology = topology.regular(size=size, degree=degree,
                                             seed=seed)


        # Export the structure of the topology, allowing the topology to be
        # re-created. This is especially useful for randomly-generated
        # topologies.
        if self.config['Metapopulation']['export_topology']:
            nx.write_gml(self.topology, os.path.join(self.config['Simulation']['data_dir'], 'topology.gml'))


        # Store the probabilities of mutations between all pairs of genotypes
        self.mutation_probs = self.get_mutation_probabilities()

        # Create the fitness landscape
        self.fitness_landscape = self.build_fitness_landscape()

        initial_state = self.config['Metapopulation']['initial_state']
        genome_length = self.config['Population']['genome_length']
        max_cap = self.config['Population']['capacity_max']
        min_cap = self.config['Population']['capacity_min']
        initial_producer_proportion = self.config['Population']['initial_producer_proportion']


        # Create each of the populations
        for n, d in self.topology.nodes_iter(data=True):
            d['population'] = Population(metapopulation=self, config=config)

            if initial_state == 'corners':
                # Place all producers in one corner and all non-producers in
                # the other
                if n == 0:
                    d['population'].abundances[2**genome_length] = max_cap
                    d['population'].dilute()
                elif n == len(self.topology)-1:
                    d['population'].abundances[0] = min_cap
                    d['population'].dilute()

            elif initial_state == 'stress':
                cap = int(min_cap + ( (max_cap - min_cap) * initial_producer_proportion))
                num_producers = int(cap * initial_producer_proportion)
                num_nonproducers = cap - num_producers

                d['population'].abundances[0] = num_nonproducers
                d['population'].abundances[2**genome_length] = num_producers
                d['population'].bottleneck(survival_rate=self.config['Population']['stress_survival_rate'])


        # How frequently should the metapopulation be mixed?
        self.metapopulation_mixing = self.config['MetapopulationMixing']['enabled']
        self.mix_frequency = self.config['MetapopulationMixing']['frequency']


        # Does the environment change? If so, how...
        self.environment_changes = self.config['EnvironmentalChange']['enabled']
        self.env_change_frequency = self.config['EnvironmentalChange']['frequency']
        self.environment_changed = False

        if self.environment_changes:
            self.set_next_environment_change()


        data_dir = self.config['Simulation']['data_dir']

        # log_objects is a list of any logging objects used by this simulation
        self.log_objects = []

        if self.config['MetapopulationLog']['enabled']:
            fname = self.config['MetapopulationLog']['filename']
            freq = self.config['MetapopulationLog']['frequency']
            compress = self.config['MetapopulationLog']['compress']
            self.log_objects.append((freq, MetapopulationOutput(metapopulation=self,
                                                                filename=os.path.join(data_dir, fname),
                                                                header=True,
                                                                include_uuid=self.config['MetapopulationLog']['include_uuid'],
                                                                compress=compress)))

        if self.config['PopulationLog']['enabled']:
            fname = self.config['PopulationLog']['filename']
            freq = self.config['PopulationLog']['frequency']
            compress = self.config['PopulationLog']['compress']
            self.log_objects.append((freq, PopulationOutput(metapopulation=self,
                                                            filename=os.path.join(data_dir, fname),
                                                            header=True,
                                                            include_uuid=self.config['PopulationLog']['include_uuid'],
                                                            compress=compress)))

        if self.config['GenotypeLog']['enabled']:
            fname = self.config['GenotypeLog']['filename']
            freq = self.config['GenotypeLog']['frequency']
            compress = self.config['GenotypeLog']['compress']
            self.log_objects.append((freq, GenotypesOutput(metapopulation=self,
                                                           filename=os.path.join(data_dir, fname),
                                                           header=True,
                                                           include_uuid=self.config['GenotypeLog']['include_uuid'],
                                                           compress=compress)))

        if self.config['FitnessLog']['enabled'] :
            fname = self.config['FitnessLog']['filename']
            freq = self.config['FitnessLog']['frequency']
            compress = self.config['FitnessLog']['compress']
            self.log_objects.append((freq, FitnessOutput(metapopulation=self,
                                                         filename=os.path.join(data_dir, fname),
                                                         header=True,
                                                         include_uuid=self.config['FitnessLog']['include_uuid'],
                                                         compress=compress)))

        if self.config['EnvChangeLog']['enabled']:
            fname = self.config['EnvChangeLog']['filename']
            freq = self.config['EnvChangeLog']['frequency']
            compress = self.config['EnvChangeLog']['compress']
            self.log_objects.append((freq, EnvChangeOutput(metapopulation=self,
                                                           filename=os.path.join(data_dir, fname),
                                                           header=True,
                                                           include_uuid=self.config['EnvChangeLog']['include_uuid'],
                                                           compress=compress)))


    def __repr__(self):
        """Return a string representation of the Metapopulation object"""
        prop_producers = self.prop_producers()

        if prop_producers == 'NA':
            res = "Metapopulation: Size {s}, NA% producers".format(s=self.size())
        else:
            maxfit = self.max_fitnesses()
            maxfit_p = max(maxfit[0]) / max(self.fitness_landscape)
            maxfit_np = max(maxfit[1]) / max(self.fitness_landscape)
            #res = "Metapopulation: Size {s}, {p:.1%} producers".format(s=self.size(),
            #                                                        p=self.prop_producers())

            if maxfit_p > maxfit_np:
                symbol = '>'
            elif maxfit_p < maxfit_np:
                symbol = '<'
            else:
                symbol = '='

            res = "Metapopulation: Size {s}, {p:.1%} producers. w(P): {mp:.2} "\
                  "{sym} w(Np): {mnp:.2}.".format(s=self.size(), p=self.prop_producers(),
                                                 mp=maxfit_p, mnp=maxfit_np, sym=symbol)

        return res


    def build_fitness_landscape(self):
        """Build a fitness landscape

        """

        genome_length = self.config['Population']['genome_length']
        base_fitness = self.config['Population']['base_fitness']
        production_cost = self.config['Population']['production_cost']
        benefit_nonzero = self.config['Population']['benefit_nonzero']
        fitness_shape = self.config['Population']['fitness_shape']

        landscape = zeros(2**(genome_length))

        for i in range(2**(genome_length)):
            num_ones = sum(genome.base10_as_bitarray(i))
            landscape[i] = base_fitness + (benefit_nonzero * (num_ones**fitness_shape))

        return np.append(landscape, landscape - production_cost)


    def get_mutation_probabilities(self):
        """Get a table of probabilities among all pairs of genotypes
        
        This works by first generating the Hamming distances between all of the
        possible genotypes. These distances are then used to calculate the
        probabilities of mutating by:

            (1-mu)^(#matching bits) * mu^(#different bits)

        Where #matching bits is the genome length - Hamming distance and
        #different bits is the Hamming distance.
        
        """

        genome_length = self.config['Population']['genome_length']
        mutation_rate_social = self.config['Population']['mutation_rate_social']
        mutation_rate_adaptation = self.config['Population']['mutation_rate_adaptation']

        S = np.vstack((np.array([[0]*2**genome_length + [1]*2**genome_length]).repeat(repeats=2**genome_length, axis=0),
                       np.array([[1]*2**genome_length + [0]*2**genome_length]).repeat(repeats=2**genome_length, axis=0)))


        # TODO: to handle things like P->NP but not NP->P (or vice versa), just
        # manipulate the mr vector.

        # Get the pairwise Hamming distance for all genotypes
        hamming_v = np.vectorize(genome.hamming_distance)
        genotypes = np.arange(start=0, stop=2**(genome_length+1))
        xx, yy = np.meshgrid(genotypes, genotypes)
        hamming_distances = hamming_v(xx, yy)

        # nonsocial_hd is a matrix containing the pairwise Hamming distances
        # between all genomes considering only the non-social loci
        nonsocial_hd = hamming_distances - S

        # mr is a matrix where each element contains the probability of mutating
        # from one genome to the other.
        # mr = npower(1-m1, L-NS) * npower(m1, NS) * npower(1-m2, S2) * npower(m2, S)

        npower = np.power
        mr = npower(1-mutation_rate_adaptation, genome_length-nonsocial_hd) *\
                npower(mutation_rate_adaptation, nonsocial_hd) *\
                npower(1-mutation_rate_social, S==0) *\
                npower(mutation_rate_social, S)

        return mr


    def dilute(self):
        """Dilute the metapopulation

        Dilute the metapopulation by diluting each population by the dilution
        factor specified with the dilution_factor option in the Population
        section of the configuration file.

        """
        for n, d in self.topology.nodes_iter(data=True):
            d['population'].dilute()


    def mix(self):
        """Mix the population

        Mix the population. The abundances at all populations are combined and
        re-distributed.
        """

        abundances = zeros(self.fitness_landscape.size, dtype=np.int)

        for n, d in self.topology.nodes_iter(data=True):
            abundances += d['population'].abundances

        for n, d in self.topology.nodes_iter(data=True):
            d['population'].abundances = binomial(abundances, 1.0/len(self.topology))


    def grow(self):
        """Grow the metapopulation ...."""
        for n, d in self.topology.nodes_iter(data=True):
            d['population'].grow()


    def mutate(self):
        """Mutate the metapopulation ...."""
        for n, d in self.topology.nodes_iter(data=True):
            d['population'].mutate()


    def migrate(self, single_dest=True):
        """Migrate individuals among the populations
        
        * single_dest: if True (default), all migrants will go to a single
            neighbor population. Otherwise, migrants will be distributed among
            all neighbors. 
        
        """
        if self.migration_rate == 0 or self.topology.number_of_nodes() < 2:
            return

        for n, d in self.topology.nodes_iter(data=True):
            pop = d['population']

            if self.topology.degree(n) == 0:
                return

            # Migrate everything to one neighboring population
            if self.migration_dest.lower() == 'single':
                migrants = pop.select_migrants(migration_rate=self.migration_rate)

                if binomial(n=1, p=self.migration_p_far, size=None) == 1:
                    neighbor_index = random_integers(low=0,high=self.topology.number_of_nodes()-1)
                else:
                    neighbor_index = nchoice(self.topology.neighbors(n))

                neighbor = self.topology.node[neighbor_index]['population']
                neighbor.add_immigrants(migrants)
                pop.remove_emigrants(migrants)

            # Distribute the migrants among the neighboring populations
            elif self.migration_dest.lower() == 'neighbors':
                num_neighbors = self.topology.degree(n)
                for neighbor_node in self.topology.neighbors_iter(n):
                    if binomial(n=1, p=self.migration_p_far, size=None) == 1: 
                        neighbor_node = random_integers(low=0,high=self.topology.number_of_nodes()-1)
                    migrants = pop.select_migrants(migration_rate=self.migration_rate/num_neighbors)
                    neighbor = self.topology.node[neighbor_node]['population']
                    neighbor.add_immigrants(migrants)
                    pop.remove_emigrants(migrants)


    def census(self):
        """Update each population's abundance to account for migration"""
        for n, d in self.topology.nodes_iter(data=True):
            d['population'].census()


    def cycle(self):
        """Cycle the metapopulation

        In each cycle, the metapopulation cycles its state by diluting each
        population, allowing each population to grow to capacity, mutate each
        population, and then migrating among populations.

        """
        self.write_logfiles()

        self.grow()
        self.mutate()
        self.migrate()
        self.census()

        if self.metapopulation_mixing and self.time > 0 and \
                (self.time % self.mix_frequency == 0):
            self.mix()

        if self.environment_changes and self.time == self.next_env_change_cycle:
            self.change_environment()
            self.environment_changed = True
            self.set_next_environment_change()
        else:
            self.dilute()
            self.environment_changed = False

        self.time += 1


    def change_environment(self):
        """Change the environment

        The change_environment function changes the environment for the
        metapopulation. This re-generates the fitness landscape and zeros out
        all fitness-encoding loci. This is meant to represent the metapopulation
        being subjected to different selective pressures. The number of
        individuals of each genotype that survive this event are proportional to
        the abundance of that genotype times the mutation rate (representing
        individuals that acquired the mutation that allows them to persist).
        """

        self.fitness_landscape = self.build_fitness_landscape()

        for n, d in self.topology.nodes_iter(data=True):
            d['population'].bottleneck(survival_rate=self.config['Population']['stress_survival_rate'])
            d['population'].reset_loci(num_loci=self.config['EnvironmentalChange']['affected_loci'])


    def set_next_environment_change(self):
        """Set the cycle at which the next environmental change will occur
        """
        if self.config['EnvironmentalChange']['type'] == 'regular':
            self.next_env_change_cycle = self.time + self.env_change_frequency
        elif self.config['EnvironmentalChange']['type'] == 'exponential':
            self.next_env_change_cycle = self.time + np.round(exponential(scale=self.env_change_frequency, size=1)[0]).astype(int)


    def size(self):
        """Return the size of the metapopulation

        The size of the metapopulation is the sum of the sizes of the
        subpopulations
        """
        return sum(len(d['population']) for n, d in self.topology.nodes_iter(data=True))


    def __len__(self):
        """Return the length of a Metapopulation

        We'll define the length of a metapopulation as its size, so len(metapop)
        returns the number of individuals in all populations of Metapopulation
        metapop
        """
        return self.size()


    def num_producers(self):
        """Return the number of producers in the metapopulation"""
        return sum(d['population'].num_producers() for n, d in self.topology.nodes_iter(data=True))


    def prop_producers(self):
        """Get the proportion of producers in the metapopulation"""
        metapopsize = self.size()

        if metapopsize == 0:
            return 'NA'
        else:
            return 1.0 * self.num_producers() / self.size()


    def max_fitnesses(self):
        """Get the maximum fitness among producers and non-producers"""

        prod_max = [d['population'].max_fitnesses()[0] for n, d in self.topology.nodes_iter(data=True)]
        nonprod_max = [d['population'].max_fitnesses()[1] for n, d in self.topology.nodes_iter(data=True)]

        return (prod_max, nonprod_max)


    def write_logfiles(self):
        """Write any log files"""

        for (freq, l) in self.log_objects:
            if self.time % freq == 0:
                l.update(time=self.time)


    def cleanup(self):
        for (freq, l) in self.log_objects:
            l.close()

