import numpy as np
NB_OF_WORDS = 8
NB_OF_BITS = 8
#SHAPE FEATURES (b.shape, y.shape, x.shape, c.shape)
#SHAPE WEIGHTS (fy.shape, fx.shape, k.shape, c.shape)
#SHAPE OUTPUT LAYER (b.shape, y.shape, x.shape, k.shape)

###TEST 1: Simple test with one word to encode
b1 = 1
k1 = 1
c1 = 1
y1 = NB_OF_WORDS
x1 = NB_OF_WORDS
fy1 = 3
fx1 = 3
features1 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(b1,c1,y1,x1))
weights1 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(fy1, fx1, k1, c1))

###TEST 2: Test with overflow in c parameter

b2 = 1
k2 = 1
c2 = 1
fy2 = 3
fx2 = 3
y2 = NB_OF_WORDS
x2 = NB_OF_WORDS
features2 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(b2,c2,y2,x2))
weights2 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(fy2, fx2, k2, c2))

###TEST 3: Test with overflow in k parameter, so 2 words to encode/decode

b3 = 1
k3 = 1
c3 = 1
fy3 = 3
fx3 = 3
x3 = NB_OF_WORDS+3
y3 = NB_OF_WORDS+3
features3 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(b3,c3,y3,x3))
weights3 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(fy3, fx3, k3, c3))

# ###TEST 4: Test with multiple x elements

b4 = 1
k4 = 1
c4 = 2
fy4 = 3
fx4 = 3
y4 = NB_OF_WORDS
x4 = NB_OF_WORDS
features4 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(b4,c4,y4,x4))
weights4 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(fy4, fx4, k4, c4))

# ###TEST 5: Testing with more complex test vectors

b5 = 3
k5 = 10
c5 = 5
fy5 = 3
fx5 = 3
y5 = NB_OF_WORDS*2
x5 = NB_OF_WORDS*2
features5 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(b5,c5,y5,x5))
weights5 = np.random.randint(-2**(NB_OF_BITS-1), 2**(NB_OF_BITS-1), size=(fy5, fx5, k5, c5))