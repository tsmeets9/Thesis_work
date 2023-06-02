import numpy as np
MEMORY_GRANULARITY = 128
GROUPED_WORDS = 16
K_GROUP_SIZE = 16
NB_OF_BITS = 8
#SHAPE FEATURES (b.shape, y.shape, c.shape, x.shape)
#SHAPE WEIGHTS (c.shape, fy.shape, fx.shape, k.shape)
#SHAPE OUTPUT LAYER (b.shape, y.shape, k.shape, x.shape)

###TEST 1: Simple test
b1 = 1
k1 = 16
c1 = 16
y1 = 32
x1 = 32
fy1 = 3
fx1 = 3
features1 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(b1,y1,c1,x1))
weights1 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(c1,fy1,fx1,k1))
###TEST 2: Simple test
b2 = 1
k2 = 64
c2 = 64
y2 = 112
x2 = 112
fy2 = 3
fx2 = 3
features2 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(b2,y2,c2,x2))
weights2 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(c2,fy2,fx2,k2))
