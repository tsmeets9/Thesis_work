import os
os.environ["KMP_DUPLICATE_LIB_OK"]="TRUE"
# load vgg model
from keras.applications.vgg16 import VGG16
from keras.applications.vgg16 import preprocess_input
from keras.utils import load_img, img_to_array
from keras.models import Model
from numpy import expand_dims
import tensorflow as tf
import numpy as np 
# load the model
model = VGG16()
# summarize the model
model.summary()
import matplotlib
from matplotlib import pyplot
import matplotlib.pylab as plt
import scipy.sparse as sparse 
print(matplotlib.font_manager.get_font_names())

model = Model(inputs=model.inputs, outputs=model.layers[5].output)
model.summary()
script_dir = os.path.dirname(__file__) #<-- absolute dir the script is in
rel_path = "images/bird.jpg"
img_path = os.path.join(script_dir, rel_path)
img = load_img(img_path, target_size=(224, 224))

img = img_to_array(img)
img = expand_dims(img, axis=0)

img = preprocess_input(img)
feature_maps = model.predict(img)
for i in range(15):
    feature_map = feature_maps[0, :, :, i]
    plt.spy(feature_map)
    plt.xticks(fontsize=10.5)
    plt.yticks(fontsize=10.5)

    plt.show()
    array_size = feature_map.size
    nb_zeros_array = np.count_nonzero(feature_map==0)
    sparsity = nb_zeros_array/array_size
    print(sparsity)
