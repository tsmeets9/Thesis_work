import numpy as np
import array as arr
from test_vectors import *
#SHAPE FEATURES (b.shape, c.shape, y.shape, x.shape)
#SHAPE WEIGHTS (fy.shape, fx.shape, k.shape, c.shape)
#SHAPE OUTPUT LAYER (b.shape, k.shape, y.shape, x.shape)
def ReLU(array):
    return np.maximum(array, 0)

#SHAPE OUTPUT LAYER (b.shape, k.shape, y.shape, x.shape)

def group_by_NB_OF_WORDS(array):
    b_size = array.shape[0]
    k_size = array.shape[1]
    y_size = array.shape[2]
    x_size = array.shape[3]

    new_x_size = int(np.ceil(x_size/NB_OF_WORDS))
    new_array = np.zeros((b_size, k_size, y_size, new_x_size, NB_OF_WORDS))
    for b,k,y,x,i in np.ndindex(b_size, k_size, y_size, new_x_size, NB_OF_WORDS):
        if (x*NB_OF_WORDS+i<x_size):
            new_array[b][k][y][x][i] = array[b][k][y][x*NB_OF_WORDS+i]
    #new_array = array.reshape(((b_size, k_size, y_size, new_x_size, NB_OF_WORDS)))
    return new_array.astype(int)

#Input shape: (b.shape, k.shape, y.shape, x.shape)
#Note: is copy of the group_by_NB_OF_WORDS function
def group_by_NB_OF_WORDS_x_dimension(array):
    b_size = array.shape[0]
    k_size = array.shape[1]
    y_size = array.shape[2]
    x_size = array.shape[3]

    new_x_size = int(np.ceil(x_size/NB_OF_WORDS))
    new_array_2 = np.zeros((b_size, k_size, y_size, new_x_size, NB_OF_WORDS))
    for b,k,y,x,i in np.ndindex(b_size, k_size, y_size, new_x_size, NB_OF_WORDS):
        if (x*NB_OF_WORDS+i<x_size):
            new_array_2[b][k][y][x][i] = array[b][k][y][x*NB_OF_WORDS+i]
    #new_array_2 = array.reshape(((b_size, k_size, y_size, new_x_size, NB_OF_WORDS)))
    return new_array_2.astype(int)

#Input shape: (b.shape, k.shape, y.shape, x.shape)
def group_by_NB_OF_WORDS_k_dimension(array):
    b_size = array.shape[0]
    k_size = array.shape[1]
    y_size = array.shape[2]
    x_size = array.shape[3]

    new_array_1 = array.transpose((0, 2, 3, 1))

    new_k_size = int(np.ceil(k_size/NB_OF_WORDS))
    new_array_2 = np.zeros((b_size, y_size, x_size, new_k_size, NB_OF_WORDS))
    for b,y,x,k,i in np.ndindex(b_size, y_size, x_size, new_k_size, NB_OF_WORDS):
        if (k*NB_OF_WORDS+i<k_size):
            new_array_2[b][y][x][k][i] = new_array_1[b][y][x][k*NB_OF_WORDS+i]
    #new_array_2 = array.reshape(((b_size, k_size, y_size, new_x_size, NB_OF_WORDS)))
    return new_array_2.astype(int)
def degroup_by_NB_OF_WORDS(array, x_size):
    b_size, k_size, y_size, new_x_size, _ = array.shape

    new_array = np.zeros((b_size, k_size, y_size, x_size))
    
    for b,k,y,x,i in np.ndindex(b_size, k_size, y_size, new_x_size, NB_OF_WORDS):
        if (x*NB_OF_WORDS+i<x_size):
            new_array[b][k][y][x*NB_OF_WORDS+i] = array[b][k][y][x][i] 
    return new_array.astype(int)

def int_to_bit(array):
    new_array = np.zeros(shape=(NB_OF_WORDS, NB_OF_BITS))
    for j in range(NB_OF_BITS):
        new_array[:, NB_OF_BITS-1-j] = (array >> j) & 1
    return new_array

def encoding(array): 
    mask = np.any(array != 0, axis=0).astype(int)
    encoded = array[:, mask == 1].transpose().flatten().astype(int)
    return mask, encoded

def encoding_to_memory(mask, encoded, file_mask, file_encoded, memory_counter_mask, memory_counter_encoded):
    #concatenated_arr = np.concatenate((mask, encoded))
    mask_str = ''.join(str(int(x)) for x in mask)
    encoded_str = ''.join(str(int(x)) for x in encoded)
    file_mask.seek(memory_counter_mask)
    file_mask.write(mask_str)
    file_encoded.seek(memory_counter_encoded)
    file_encoded.write(encoded_str)
    memory_increment_mask = mask.shape[0]
    memory_increment_encoded = encoded.shape[0]
    return memory_increment_mask, memory_increment_encoded

def encoder(array, memory_location_mask, memory_location_encoded):
    array = group_by_NB_OF_WORDS(array)
    b_size, k_size, y_size, x_size, _ = array.shape 
    memory_counter_mask = 0    
    memory_counter_encoded = 0 
    file_mask =  open(memory_location_mask, mode='a')
    file_encoded = open(memory_location_encoded, mode='a')
    for b,k,y,x in np.ndindex(b_size, k_size, y_size, x_size):
        bit_array = int_to_bit(array[b][k][y][x])
        mask, encoded = encoding(bit_array)
        memory_increment_mask, memory_increment_encoded = encoding_to_memory(mask, encoded, file_mask, file_encoded, memory_counter_mask, memory_counter_encoded)
        memory_counter_mask += memory_increment_mask
        memory_counter_encoded += memory_increment_encoded

def encoder_k_dimension(array, memory_location_mask, memory_location_encoded):
    array = group_by_NB_OF_WORDS_k_dimension(array)
    b_size, y_size, x_size, k_size, _ = array.shape 
    memory_counter_mask = 0    
    memory_counter_encoded = 0 
    file_mask =  open(memory_location_mask, mode='a')
    file_encoded = open(memory_location_encoded, mode='a')
    for b,y,x,k in np.ndindex(b_size, y_size, x_size, k_size):
        bit_array = int_to_bit(array[b][y][x][k])
        mask, encoded = encoding(bit_array)
        memory_increment_mask, memory_increment_encoded = encoding_to_memory(mask, encoded, file_mask, file_encoded, memory_counter_mask, memory_counter_encoded)
        memory_counter_mask += memory_increment_mask
        memory_counter_encoded += memory_increment_encoded

def encoder_x_dimension(array, memory_location_mask, memory_location_encoded):
    array = group_by_NB_OF_WORDS_x_dimension(array)
    b_size, k_size, y_size, x_size, _ = array.shape 
    memory_counter_mask = 0    
    memory_counter_encoded = 0 
    file_mask =  open(memory_location_mask, mode='a')
    file_encoded = open(memory_location_encoded, mode='a')
    for b,k,y,x in np.ndindex(b_size, k_size, y_size, x_size):
        bit_array = int_to_bit(array[b][k][y][x])
        mask, encoded = encoding(bit_array)
        memory_increment_mask, memory_increment_encoded = encoding_to_memory(mask, encoded, file_mask, file_encoded, memory_counter_mask, memory_counter_encoded)
        memory_counter_mask += memory_increment_mask
        memory_counter_encoded += memory_increment_encoded
def memory_to_decoding(memory_location_mask, memory_location_encoded, memory_counter_mask, memory_counter_encoded):
    with open(memory_location_mask, mode='r') as file:
        # Retrieve the mask
        file.seek(memory_counter_mask)
        mask_str = file.read(NB_OF_BITS)
        mask_str_list = list(mask_str)
        mask = np.fromiter(mask_str_list, dtype = np.uint)
        memory_increment_mask = NB_OF_BITS
    with open(memory_location_encoded, mode='r') as file:
        #Retrieve the encoded data
        file.seek(memory_counter_encoded)
        amount_of_encoded_data = np.count_nonzero(mask == 1) * NB_OF_WORDS
        encoded_str = file.read(amount_of_encoded_data)
        encoded_str_list = list(encoded_str)
        encoded = np.fromiter(encoded_str_list, dtype = np.uint)
        #Calculate the memory increment which has to be added with the memory counter
        memory_increment_encoded = amount_of_encoded_data
    return mask, encoded, memory_increment_mask, memory_increment_encoded

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

#SHAPE OUTPUT LAYER (b.shape, y.shape, x.shape, k.shape)
def decoder(b_size, k_size, y_size, x_size, memory_location_mask, memory_location_encoded):
    new_x_size = int(np.ceil(x_size/NB_OF_WORDS))
    new_array = np.zeros((b_size, k_size, y_size, new_x_size, NB_OF_WORDS))
    memory_counter_mask = 0
    memory_counter_encoded = 0 
    for b in range(b_size):
        for k in range(k_size):
            for y in range(y_size):
                for x in range(new_x_size):
                    mask, encoded, memory_increment_mask, memory_increment_encoded = memory_to_decoding(memory_location_mask, memory_location_encoded, memory_counter_mask, memory_counter_encoded)
                    memory_counter_mask += memory_increment_mask
                    memory_counter_encoded += memory_increment_encoded
                    decoded_array = decoding(mask, encoded)
                    decoded_int_array = bit_to_int(decoded_array)
                    new_array[b][k][y][x][:] = decoded_int_array
    new_array = degroup_by_NB_OF_WORDS(new_array, x_size)
    return new_array



