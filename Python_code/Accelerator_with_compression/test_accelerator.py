import unittest
from accelerator_functions import *
from test_vectors import *
import numpy as np
import os
class MyTestCase(unittest.TestCase):
    def test_grouping_degrouping1(self):
        grouped_activations = grouping_activations(features1)
        print(grouped_activations.shape)
        grouped_weights = grouping_weights(weights1)
        degrouped_activations = degrouping_activations(grouped_activations, x1, c1)
        degrouped_weights = degrouping_weights(grouped_weights, k1)
        self.assertTrue(np.array_equal(features1.shape, degrouped_activations.shape))
        self.assertTrue(np.array_equal(features1, degrouped_activations))
        self.assertTrue(np.array_equal(weights1.shape, degrouped_weights.shape))
        self.assertTrue(np.array_equal(weights1, degrouped_weights))

    def test_grouping_degrouping2(self):
        grouped_activations = grouping_activations(features2)
        print(grouped_activations.shape)
        grouped_weights = grouping_weights(weights2)
        degrouped_activations = degrouping_activations(grouped_activations, x2, c2)
        degrouped_weights = degrouping_weights(grouped_weights, k2)
        self.assertTrue(np.array_equal(features2.shape, degrouped_activations.shape))
        self.assertTrue(np.array_equal(features2, degrouped_activations))
        self.assertTrue(np.array_equal(weights2.shape, degrouped_weights.shape))
        self.assertTrue(np.array_equal(weights2, degrouped_weights))
    def test_encoder_decoder_1(self):
        features_after_ReLU = ReLU(features1)
        encoder_full_FM(features_after_ReLU, 'MASK_ACTIVATIONS_TEST_1.txt', 'ENCODED_ACTIVATIONS_TEST_1.txt')
        decoded_features = decoder_full_FM(b1, y1, c1, x1, 'MASK_ACTIVATIONS_TEST_1.txt', 'ENCODED_ACTIVATIONS_TEST_1.txt')
        self.assertTrue(np.array_equal(features_after_ReLU.shape, decoded_features.shape))
        self.assertTrue(np.array_equal(features_after_ReLU, decoded_features))

        outputs = reference_PE(features_after_ReLU, weights1)
        encoder_full_FM(outputs, 'MASK_OUTPUTS_TEST_1.txt', 'ENCODED_OUTPUTS_TEST_1.txt')
        decoded_outputs = decoder_full_FM(b1, y1, k1, x1, 'MASK_OUTPUTS_TEST_1.txt', 'ENCODED_OUTPUTS_TEST_1.txt')
        self.assertTrue(np.array_equal(outputs.shape, decoded_outputs.shape))
        self.assertTrue(np.array_equal(outputs, decoded_outputs))
        os.remove('MASK_ACTIVATIONS_TEST_1.txt')
        os.remove('ENCODED_ACTIVATIONS_TEST_1.txt')
        os.remove('MASK_OUTPUTS_TEST_1.txt')
        os.remove('ENCODED_OUTPUTS_TEST_1.txt')

    def test_encoder_decoder_2(self):
        features_after_ReLU = ReLU(features2)
        encoder_full_FM(features_after_ReLU, 'MASK_ACTIVATIONS_TEST_2.txt', 'ENCODED_ACTIVATIONS_TEST_2.txt')
        decoded_features = decoder_full_FM(b2, y2, c2, x2, 'MASK_ACTIVATIONS_TEST_2.txt', 'ENCODED_ACTIVATIONS_TEST_2.txt')
        self.assertTrue(np.array_equal(features_after_ReLU.shape, decoded_features.shape))
        self.assertTrue(np.array_equal(features_after_ReLU, decoded_features))

        outputs = reference_PE(features_after_ReLU, weights2)
        encoder_full_FM(outputs, 'MASK_OUTPUTS_TEST_2.txt', 'ENCODED_OUTPUTS_TEST_2.txt')
        decoded_outputs = decoder_full_FM(b2, y2, k2, x2, 'MASK_OUTPUTS_TEST_2.txt', 'ENCODED_OUTPUTS_TEST_2.txt')
        self.assertTrue(np.array_equal(outputs.shape, decoded_outputs.shape))
        self.assertTrue(np.array_equal(outputs, decoded_outputs))
        os.remove('MASK_ACTIVATIONS_TEST_2.txt')
        os.remove('ENCODED_ACTIVATIONS_TEST_2.txt')
        os.remove('MASK_OUTPUTS_TEST_2.txt')
        os.remove('ENCODED_OUTPUTS_TEST_2.txt')

if __name__ == '__main__':
    unittest.main()
