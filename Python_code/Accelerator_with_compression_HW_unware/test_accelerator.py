import unittest
from accelerator_functions import *
from test_vectors import *
import numpy as np
import os
class MyTestCase(unittest.TestCase):
    def test_encoder_decoder1(self):
        output = PE_array(features1, weights1)
        output_after_ReLU = ReLU(output)
        #output_grouped_by_NB_OF_WORDS = group_by_NB_OF_WORDS(output_after_ReLU)
        encoder(output_after_ReLU, 'TEST1_mask.txt', 'TEST1_encoded.txt')
        decoded_array = decoder(b1, k1, y1, x1, 'TEST1_mask.txt', 'TEST1_encoded.txt')
        self.assertTrue(np.array_equal(decoded_array, output_after_ReLU))
        os.remove("TEST1_mask.txt")
        os.remove('TEST1_encoded.txt')

    def test_encoder_decoder2(self):
        output = PE_array(features2, weights2)
        output_after_ReLU = ReLU(output)
        #output_grouped_by_NB_OF_WORDS = group_by_NB_OF_WORDS(output_after_ReLU)
        encoder(output_after_ReLU, 'TEST2_mask.txt', 'TEST2_encoded.txt')
        decoded_array = decoder(b2, k2, y2, x2, 'TEST2_mask.txt', 'TEST2_encoded.txt')
        self.assertTrue(np.array_equal(decoded_array, output_after_ReLU))
        os.remove("TEST2_mask.txt")
        os.remove('TEST2_encoded.txt')

    def test_encoder_decoder3(self):
        output = PE_array(features3, weights3)
        output_after_ReLU = ReLU(output)
        encoder(output_after_ReLU, 'TEST3_mask.txt', 'TEST3_encoded.txt')
        decoded_array = decoder(b3, k3, y3, x3, 'TEST3_mask.txt', 'TEST3_encoded.txt')
        self.assertTrue(np.array_equal(decoded_array, output_after_ReLU))
        os.remove("TEST3_mask.txt")
        os.remove('TEST3_encoded.txt')

    def test_encoder_decoder4(self):
        output = PE_array(features4, weights4)
        output_after_ReLU = ReLU(output)
        encoder(output_after_ReLU, 'TEST4_mask.txt', 'TEST4_encoded.txt')
        decoded_array = decoder(b4, k4, y4, x4, 'TEST4_mask.txt', 'TEST4_encoded.txt')
        self.assertTrue(np.array_equal(decoded_array, output_after_ReLU))
        os.remove("TEST4_mask.txt")
        os.remove('TEST4_encoded.txt')

    def test_encoder_decoder5(self):
        output = PE_array(features5, weights5)
        output_after_ReLU = ReLU(output)
        encoder(output_after_ReLU, 'TEST5_mask.txt', 'TEST5_encoded.txt')
        decoded_array = decoder(b5, k5, y5, x5, 'TEST5_mask.txt', 'TEST5_encoded.txt')
        self.assertTrue(np.array_equal(decoded_array, output_after_ReLU))
        os.remove("TEST5_mask.txt")
        os.remove('TEST5_encoded.txt')
if __name__ == '__main__':
    unittest.main()