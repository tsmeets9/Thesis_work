import numpy as np
import itertools
from accelerator_functions import reference_PE, ReLU, encoder_full_FM, decoder_full_FM, grouping_weights
NB_OF_BITS = 8
K_GROUP_SIZE = 16
def make_kernels_file(weights, file_name):
    c_size, fy_size, fx_size, k_size = weights.shape
    with open(file_name, mode='a') as file:
        for fy,fx,c,k in itertools.product(range(fy_size), range(fx_size), range(c_size), range(k_size)):
            to_write = np.binary_repr(weights[c][fy][fx][k], width=8)
            file.write(to_write+ '\n')
            #print("Im writing")
def make_kernels_file_decimal_and_grouped(weights, file_name):
    grouped_weights = grouping_weights(weights)
    new_k_size, c_size, fy_size, fx_size, _ = grouped_weights.shape
    with open(file_name, mode='a') as file:
        for k, c, fy, fx in itertools.product(range(new_k_size), range(c_size), range(fy_size), range(fx_size)):
            to_write = str(grouped_weights[k][c][fy][fx])
            file.write("k: " + str(k) + ", c: " + str(c)+ ", fy: " + str(fy) + ", fx: " + str(fx) + " : " + to_write+ '\n')
            #print("Im writing")
if __name__ == "__main__":
    SMALL_TEST = 0
    if (SMALL_TEST):
        b_size_1 = 1
        fx_size_1 = 3
        fy_size_1 = 3
        c_size_1 = 16
        k_size_1 = 16
        y_size_1 = 32
        x_size_1 = 32
    else: 
        b_size_1 = 1
        fx_size_1 = 3
        fy_size_1 = 3
        c_size_1 = 64
        k_size_1 = 64
        y_size_1 = 56
        x_size_1 = 56
    weights = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(c_size_1,fy_size_1,fx_size_1,k_size_1))
    activations = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(b_size_1,y_size_1,c_size_1, x_size_1))
    activations_after_ReLU = ReLU(activations)
    make_kernels_file(weights, 'weights.txt')
    make_kernels_file_decimal_and_grouped(weights, 'weights_decimal_and_grouped.txt')
    encoder_full_FM(activations_after_ReLU, 'activations_mask.txt', 'activations_encoded.txt')
    outputs = reference_PE(activations_after_ReLU, weights)
    encoder_full_FM(outputs, 'outputs_mask.txt', 'outputs_encoded.txt')
    print("Finished")