import os
os.environ["KMP_DUPLICATE_LIB_OK"]="TRUE"
# load vgg model
from keras.applications.vgg16 import VGG16
from keras.applications.vgg16 import preprocess_input
from keras.utils import load_img, img_to_array
from keras.models import Model
import numpy as np
from numpy import expand_dims
# load the model
model = VGG16()
# summarize the model
model.summary()
from matplotlib import pyplot as plt

for i in range(len(model.layers)):
    layer = model.layers[i]
    if 'conv' in layer.name:
        print(i, layer.name, layer.output.shape)

ixs = [2, 5, 9, 13, 17]
outputs = [model.layers[i].output for i in ixs]
model = Model(inputs = model.inputs, outputs = outputs)
model.summary()

script_dir = os.path.dirname(__file__) #<-- absolute dir the script is in
rel_path = "images/elephant.jpg"
img_path = os.path.join(script_dir, rel_path)
img = load_img(img_path, target_size=(224, 224))

img = img_to_array(img)
img = expand_dims(img, axis=0)

img = preprocess_input(img)

feature_maps = model.predict(img)

for fmap in feature_maps: 
    print(fmap.shape)
    print(type(fmap))

    to_plot = np.ndarray(0)
    array_size = 0
    nb_zeros_array = 0
    for i in range(fmap.shape[3]):
        array_size += fmap[0, :, :, i].size
        nb_zeros_array += np.count_nonzero(fmap[0, :, :, i] == 0)
    sparsity = nb_zeros_array/array_size
    print(sparsity)

    plt.spy(fmap[0, :, :, 5])
    plt.xticks(fontsize=14)
    plt.yticks(fontsize=14)

    plt.show()
