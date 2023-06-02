import numpy as np
from test_vectors import *
import os
import itertools

#SHAPE FEATURES (b.shape, y.shape, c.shape, x.shape)
#SHAPE WEIGHTS (c.shape, fy.shape, fx.shape, k.shape)
#SHAPE OUTPUT LAYER (b.shape, y.shape, k.shape, x.shape)
MEMORY_GRANULARITY = 128
GROUPED_WORDS = 16
K_GROUP_SIZE = 16

### OFFLINE FUNCTIONS FOR ENCODING THE DATA AND PUTTING IT INTO MEMORY
# Transform the feature map array (b.shape, y.shape, k.shape, x.shape) to an array that 
# corresponds to the memory layout (b.shape, y.shape, new_x.shape, new_k.shape, K_GROUP_SIZE, GROUPED_WORDS(in x dimension))
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
    
    # Transpose the array 
    new_array_2 = new_array_1.transpose((0, 1, 3, 2, 4))

    # Grouping the k elements
    new_array_3 = np.zeros((b_size, y_size, new_x_size, new_k_size, K_GROUP_SIZE, GROUPED_WORDS))
    for b, y, x, k, i in np.ndindex(b_size, y_size, new_x_size, new_k_size, K_GROUP_SIZE):
        if (k*K_GROUP_SIZE+i<k_size):
            new_array_3[b][y][x][k][i] = new_array_2[b][y][x][k*K_GROUP_SIZE+i]
    return new_array_3.astype(int)

def degrouping_activations(array, x_size, k_size):
    b_size, y_size, new_x_size, new_k_size, _, _ = array.shape

    new_array_1 = np.zeros((b_size, y_size, new_x_size, k_size, GROUPED_WORDS))
    for b,y,x,k,i in np.ndindex(b_size, y_size, new_x_size, new_k_size, K_GROUP_SIZE):
        if (k*K_GROUP_SIZE+i<k_size):
            new_array_1[b][y][x][k*K_GROUP_SIZE+i] = array[b][y][x][k][i]
    new_array_2 = new_array_1.transpose((0,1,3,2,4))

    new_array_3 = np.zeros((b_size, y_size, k_size, x_size))
    for b,y,k,x,i in np.ndindex(b_size, y_size, k_size, new_x_size, GROUPED_WORDS):
        if (x*GROUPED_WORDS+i<x_size):
            new_array_3[b][y][k][x*GROUPED_WORDS+i] = new_array_2[b][y][k][x][i]

    return new_array_3.astype(int)

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
    output_after_ReLU = ReLU(output.astype(np.int8))
    return output_after_ReLU

if __name__ == "__main__":
    output = reference_PE(features1, weights1)
    print(output)
