import numpy as np
from test_vectors import *
import os
import itertools

### NOTE: In this file are sometimes things more hardcoded and are the dimensions not so flexible as with the HW unaware files
#SHAPE FEATURES (b.shape, y.shape, c.shape, x.shape)
#SHAPE WEIGHTS (c.shape, fy.shape, fx.shape, k.shape)
#SHAPE OUTPUT LAYER (b.shape, y.shape, k.shape, x.shape)
MEMORY_GRANULARITY = 128
GROUPED_WORDS = 16
NB_OF_WORDS = int(GROUPED_WORDS/2)
K_GROUP_SIZE = 16

### OFFLINE FUNCTIONS FOR ENCODING THE DATA AND PUTTING IT INTO MEMORY
# Transform the feature map array (b.shape, y.shape, k.shape, x.shape) to an array that 
# corresponds to the memory layout (b.shape, y.shape, new_x.shape, new_k.shape, K_GROUP_SIZE, 2, GROUPED_WORDS(in x dimension))
def ReLU(array):
    return np.maximum(array, 0)

def grouping_activations(array):
    b_size, y_size, k_size, x_size = array.shape
    
    new_x_size = int(np.ceil(x_size/GROUPED_WORDS))
    new_k_size = int(np.ceil(k_size/K_GROUP_SIZE))

    # Grouping the x elements
    new_array_1 = np.zeros((b_size, y_size, k_size, new_x_size, GROUPED_WORDS))
    for b,y,k,x,i in np.ndindex(b_size, y_size, k_size, new_x_size, GROUPED_WORDS):
        if (x*GROUPED_WORDS+i<x_size):
            new_array_1[b][y][k][x][i] = array[b][y][k][x*GROUPED_WORDS+i]
    
    # Split the GROUPED_WORDS in two
    new_array_2 = np.reshape(new_array_1, (b_size, y_size, k_size, new_x_size, 2, int(GROUPED_WORDS/2)))
    # Transpose the array 
    new_array_3 = new_array_2.transpose((0, 1, 3, 2, 4, 5))

    # Grouping the k elements
    new_array_4 = np.zeros((b_size, y_size, new_x_size, new_k_size, K_GROUP_SIZE, 2, int(GROUPED_WORDS/2)))
    for b, y, x, k, i in np.ndindex(b_size, y_size, new_x_size, new_k_size, K_GROUP_SIZE):
        if (k*K_GROUP_SIZE+i<k_size):
            new_array_4[b][y][x][k][i] = new_array_3[b][y][x][k*K_GROUP_SIZE+i]
    return new_array_4.astype(int)

def degrouping_activations(array, x_size, k_size):
    b_size, y_size, new_x_size, new_k_size, _, _, _ = array.shape

    new_array_1 = np.zeros((b_size, y_size, new_x_size, k_size, 2, int(GROUPED_WORDS/2)))
    for b,y,x,k,i in np.ndindex(b_size, y_size, new_x_size, new_k_size, K_GROUP_SIZE):
        if (k*K_GROUP_SIZE+i<k_size):
            new_array_1[b][y][x][k*K_GROUP_SIZE+i] = array[b][y][x][k][i]
    
    new_array_2 = new_array_1.transpose((0,1,3,2,4,5))

    new_array_3 = np.reshape(new_array_2, (b_size, y_size, k_size, new_x_size, GROUPED_WORDS))

    new_array_4 = np.zeros((b_size, y_size, k_size, x_size))
    for b,y,k,x,i in np.ndindex(b_size, y_size, k_size, new_x_size, GROUPED_WORDS):
        if (x*GROUPED_WORDS+i<x_size):
            new_array_4[b][y][k][x*GROUPED_WORDS+i] = new_array_3[b][y][k][x][i]

    return new_array_4.astype(int)

# Transform the weights array (c.shape, fy.shape, fx.shape, k.shape) to an array that 
# corresponds to the memory layout (new_k.shape, c.shape, fy.shape, fx.shape, K_GROUP_SIZE(in k dimension))
def grouping_weights(array):
    c_size, fy_size, fx_size, k_size = array.shape

    new_k_size = int(np.ceil(k_size/K_GROUP_SIZE))

    new_array_1 = np.zeros((c_size, fy_size, fx_size, new_k_size, K_GROUP_SIZE))
    for c,fy,fx,k,i in np.ndindex(c_size, fy_size, fx_size, new_k_size, K_GROUP_SIZE):
        if (k*K_GROUP_SIZE+i<k_size):
            new_array_1[c][fy][fx][k][i] = array[c][fy][fx][k*K_GROUP_SIZE+i]

    new_array_2 = new_array_1.transpose((3,0,1,2,4))
    return new_array_2.astype(int)

def degrouping_weights(array, k_size):
    new_k_size, c_size, fy_size, fx_size, _ = array.shape
    
    new_array_1 = array.transpose((1,2,3,0,4))

    new_array_2 = np.zeros((c_size, fy_size, fx_size, k_size))
    for c,fy,fx,k,i in np.ndindex(c_size, fy_size, fx_size, new_k_size, K_GROUP_SIZE):
        if (k*K_GROUP_SIZE+i<k_size):
            new_array_2[c][fy][fx][k*K_GROUP_SIZE+i] = new_array_1[c][fy][fx][k][i]
    return new_array_2

# Transform an array to a column, assuming that we have all positive values (is true after ReLU)
def int_to_bit(array):
    new_array = np.zeros(shape=(NB_OF_WORDS, NB_OF_BITS))
    for j in range(NB_OF_BITS):
        new_array[:, NB_OF_BITS-1-j] = (array >> j) & 1
    return new_array

def encoding(array): 
    mask = np.any(array != 0, axis=0).astype(int)
    encoded = array[:, mask == 1].transpose().flatten().astype(int)
    return mask, encoded

def extend_string_with_memory_granularity(string):
    current_length = len(string)
    extented_string = string
    if (current_length%MEMORY_GRANULARITY != 0):
        nb_of_to_add_zeros = MEMORY_GRANULARITY - current_length%MEMORY_GRANULARITY
        nb_of_to_add_zeros_grouped_by_8 = int(nb_of_to_add_zeros/8)
        for i in range(nb_of_to_add_zeros_grouped_by_8):
            extented_string += '00000000'
    return extented_string

def encoder_full_FM(array, memory_location_mask, memory_location_encoded):
    array = grouping_activations(array)
    b_size, y_size, new_x_size, new_k_size, _, _, _ = array.shape 
    memory_location_activations = memory_location_encoded.removesuffix('.txt') + "_unencoded.txt"
    file_activations =  open(memory_location_activations, mode='a')
 
    for b,y,x,k in np.ndindex(b_size, y_size, new_x_size, new_k_size):
        file_activations.write("y: " + str(y) + ", x: " + str(x)+ ", k: " + str(k) + " : " + str(array[b][y][x][k])+ '\n')
        mask_str_total = ''
        encoded_str_total = ''
        for k_group, i in np.ndindex(K_GROUP_SIZE, 2):
            bit_array = int_to_bit(array[b][y][x][k][k_group][i])
            mask, encoded = encoding(bit_array)
            mask_str = ''.join(str(int(x)) for x in mask)
            encoded_str = ''.join(str(int(x)) for x in encoded)
            mask_str_total += mask_str
            encoded_str_total += encoded_str
        
        # Write to memory 
        mask_array_to_write = [ mask_str_total[i:i+MEMORY_GRANULARITY] for i in range(0, len(mask_str_total), MEMORY_GRANULARITY) ]
        encoded_str_total = extend_string_with_memory_granularity(encoded_str_total)
        encoded_array_to_write = [ encoded_str_total[i:i+MEMORY_GRANULARITY] for i in range(0, len(encoded_str_total), MEMORY_GRANULARITY) ]
        
        with open(memory_location_mask, mode='a') as file:
            for mask_to_write in mask_array_to_write:
                mask_to_write += '\n'
                file.write(mask_to_write)
        with open(memory_location_encoded, mode='a') as file:
            for encoded_to_write in encoded_array_to_write:
                encoded_to_write += '\n'
                file.write(encoded_to_write)
    file_activations.close()
def decoding(mask, encoded):
    array = np.zeros((NB_OF_WORDS, NB_OF_BITS))
    counter = 0
    for i in range(NB_OF_BITS):
        if mask[i] == 1:
            for j in range(NB_OF_WORDS):
                array[j][i] = encoded[j+NB_OF_WORDS*counter]
            counter += 1
    return array

def bit_to_int(array):
    new_array = np.ndarray((NB_OF_WORDS,))
    for i in range(NB_OF_WORDS):
        accumulator = 0
        for j in range(NB_OF_BITS):
            if array[i][j] == 1:
                accumulator += 2**(NB_OF_BITS-1-j)
        new_array[i] = accumulator
    return new_array

def decoder_full_FM(b_size, y_size, k_size, x_size, memory_location_mask, memory_location_encoded):
    new_x_size = int(np.ceil(x_size/GROUPED_WORDS))
    new_k_size = int(np.ceil(k_size/K_GROUP_SIZE))
    new_array = np.zeros((b_size, y_size, new_x_size, new_k_size, K_GROUP_SIZE, 2, NB_OF_WORDS))
    file_mask =  open(memory_location_mask, mode='r')
    file_encoded = open(memory_location_encoded, mode='r')
    for b,y,x,k in np.ndindex(b_size, y_size, new_x_size, new_k_size):
        mask_str_part_1 = file_mask.readline().removesuffix("\n")
        mask_str_part_2 = file_mask.readline().removesuffix("\n")
        mask_str_total = mask_str_part_1 + mask_str_part_2
        count_to_fetch_total_encoded = int(np.ceil(mask_str_total.count('1')/16))
        encoded_str_total = ""
        for i in range(count_to_fetch_total_encoded):
            encoded_str_total += file_encoded.readline().removesuffix("\n")
        mask_str_seperated = [mask_str_total[i:i+NB_OF_BITS] for i in range(0, len(mask_str_total), NB_OF_BITS) ]
        mask_str_index = 0 
        for k_group, i in np.ndindex(K_GROUP_SIZE, 2):
            mask_str = mask_str_seperated[mask_str_index]
            mask_str_index += 1
            count_to_select_encoded = mask_str.count('1')
            encoded_str = encoded_str_total[0:NB_OF_WORDS*count_to_select_encoded]
            encoded_str_total = encoded_str_total[NB_OF_WORDS*count_to_select_encoded:None]
            

            encoded_str_list = list(encoded_str)
            encoded = np.fromiter(encoded_str_list, dtype = np.uint)

            mask_str_list = list(mask_str)
            mask = np.fromiter(mask_str_list, dtype = np.uint)

            # print('b: ', b, 'y: ', y, 'x: ', x, 'k: ', k, 'k_group: ', k_group, 'i: ', i)
            decoded_array = decoding(mask, encoded)
            decoded_int_array = bit_to_int(decoded_array)
            new_array[b][y][x][k][k_group][i][:] = decoded_int_array
    file_mask.close()
    file_encoded.close()
    new_array = degrouping_activations(new_array, x_size, k_size)
    return new_array
def reference_PE(features, weights): 
    b_size = features.shape[0]
    y_size = features.shape[1]
    c_size = features.shape[2]
    x_size = features.shape[3]
    fy_size = weights.shape[1]
    fx_size = weights.shape[2]
    k_size = weights.shape[3]

    output = np.zeros((b_size, y_size, k_size, x_size))
    for b,y,x,k,c,fy,fx in itertools.product(range(b_size), range(y_size), range(x_size), range(k_size), range(c_size), range(fy_size), range(fx_size)):
        if ((x+fx-fx_size//2) >= 0 and (x+fx-fx_size//2) < x_size and (y+fy-fy_size//2) >= 0 and (y+fy-fy_size//2) < y_size):
            output[b][y][k][x] += (features[b][y+fy-fy_size//2][c][x+fx-fx_size//2] * weights[c][fy][fx][k])
            output[b][y][k][x] = output[b][y][k][x].astype(np.int32)
        else: 
            output[b][y][k][x] = output[b][y][k][x]
    output_after_ReLU = ReLU(output.astype(np.int8))
    return output_after_ReLU
if __name__ == "__main__":
    features1_after_ReLU = ReLU(features1)
    #print(features1_after_ReLU)
    encoder_full_FM(features1_after_ReLU, 'MASK_TEST.txt', 'ENCODED_test.txt')
    features1_after = decoder_full_FM(b1, y1, c1, x1, 'MASK_TEST.txt', 'ENCODED_test.txt')
    print(features1_after_ReLU)
    print(features1_after)