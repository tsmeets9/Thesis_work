import unittest
from accelerator_functions import *
from test_vectors import *
import numpy as np
import os
class MyTestCase(unittest.TestCase):
    def test_grouping_degrouping1(self):
        grouped_activations = grouping_activations(features1)
        grouped_weights = grouping_weights(weights1)
        degrouped_activations = degrouping_activations(grouped_activations, x1, c1)
        degrouped_weights = degrouping_weights(grouped_weights, k1)
        print(weights1.shape)
        print(grouped_weights.shape)
        print(degrouped_weights.shape)
        self.assertTrue(np.array_equal(features1.shape, degrouped_activations.shape))
        self.assertTrue(np.array_equal(features1, degrouped_activations))
        self.assertTrue(np.array_equal(weights1.shape, degrouped_weights.shape))
        self.assertTrue(np.array_equal(weights1, degrouped_weights))
    def test_grouping_degrouping2(self):
        grouped_activations = grouping_activations(features2)
        grouped_weights = grouping_weights(weights2)
        degrouped_activations = degrouping_activations(grouped_activations, x2, c2)
        degrouped_weights = degrouping_weights(grouped_weights, k2)
        print(weights2.shape)
        print(grouped_weights.shape)
        print(degrouped_weights.shape)
        self.assertTrue(np.array_equal(features2.shape, degrouped_activations.shape))
        self.assertTrue(np.array_equal(features2, degrouped_activations))
        self.assertTrue(np.array_equal(weights2.shape, degrouped_weights.shape))
        self.assertTrue(np.array_equal(weights2, degrouped_weights))
    #NOTE: PE array is tested with the HW accelerator            
if __name__ == '__main__':
    unittest.main()
