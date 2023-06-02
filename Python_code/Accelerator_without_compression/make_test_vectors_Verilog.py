import numpy as np
import itertools
from accelerator_functions import ReLU, reference_PE, grouping_activations, K_GROUP_SIZE, grouping_weights
NB_OF_BITS = 8
def make_kernels_file(weights, file_name, fy_size, fx_size, c_size, k_size):
    file_kernels =  open(file_name, mode='a')
    file_name_decimal = file_name.removesuffix('.txt') + "_decimal.txt"
    file_kernels_decimal = open(file_name_decimal, mode='a')
    for fy,fx,c,k in itertools.product(range(fy_size), range(fx_size), range(c_size), range(k_size)):
        to_write = np.binary_repr(weights[c][fy][fx][k], width=8)
        file_kernels.write(to_write+ '\n')
    
    grouped_weights = grouping_weights(weights)
    new_k_size = grouped_weights.shape[0]
    for new_k,c,fy,fx in itertools.product(range(new_k_size), range(c_size), range(fy_size), range(fx_size)):
        file_kernels_decimal.write("new_k: "+ str(new_k) + ", c: "+ str(c) + ", fy: " + str(fy) + ", fx: " + str(fx) + " : " + str(grouped_weights[new_k][c][fy][fx])+ '\n')

    file_kernels.close()
    file_kernels_decimal.close()

def make_activations_file(activations, file_name, b_size, y_size, x_size, c_size):
    file_activations =  open(file_name, mode='a')
    file_name_decimal = file_name.removesuffix('.txt') + "_decimal.txt"
    file_activations_decimal = open(file_name_decimal, mode='a')
    for b,y,x,k in itertools.product(range(b_size), range(y_size), range(x_size), range(c_size)):
        to_write = np.binary_repr(activations[b][y][k][x], width=8)
        file_activations.write(to_write+ '\n')
        #print("Im writing")

    grouped_activations = grouping_activations(activations)
    new_x_size = grouped_activations.shape[2]
    new_k_size = grouped_activations.shape[3]
    for b,y,new_x, new_k in itertools.product(range(b_size), range(y_size), range(new_x_size), range(new_k_size)):
        file_activations_decimal.write("b: " + str(b) + ", y: " +  str(y) +  ", new_x:" +  str(new_x) + ", new_k: " + str(new_k) + " : "+ '\n' + str(grouped_activations[b][y][new_x][new_k])+ '\n' + '\n')

    file_activations.close()
    file_activations_decimal.close()

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
    make_kernels_file(weights, "weights.txt", fy_size_1, fx_size_1, c_size_1, k_size_1)
    make_activations_file(activations_after_ReLU, "activations.txt", b_size_1, y_size_1, x_size_1, c_size_1)
    outputs = reference_PE(activations_after_ReLU, weights)
    make_activations_file(outputs, "outputs.txt", b_size_1, y_size_1, x_size_1, k_size_1)
    print("Finished")