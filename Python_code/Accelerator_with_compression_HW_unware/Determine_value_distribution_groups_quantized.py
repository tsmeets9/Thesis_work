import torch
from torchvision.models.quantization import resnet50, ResNet50_QuantizedWeights
import torch.nn as nn
from torchvision.io import read_image
import os 
import numpy as np
import matplotlib.pyplot as plt
from accelerator_functions import group_by_NB_OF_WORDS_x_dimension, group_by_NB_OF_WORDS_k_dimension

# font = {'family' : 'normal',
#         'weight' : 'bold',
#         'size'   : 18}

# plt.rc('font', **font)
GROUP_BY_K = 1
WITHOUT_ZEROS = 1
class model_play():
    def __init__(self):
        self.relu = nn.ReLU(inplace=False)
        self.weights = ResNet50_QuantizedWeights.DEFAULT
        self.features_out = []
        self.features_in = []
        self.features_names = []
    def hook(self, model, input, output):
        self.features_out.append(output)
        self.features_in.append(input)
    def get_features_out(self):
        print(self.features_out)
    def get_features_in(self):
        print(self.features_in)

    def GetModelFeature(self):
        # PREPROCESSING 
        # img = torch.randn(1, 3, 224, 224)
        script_dir = os.path.dirname(__file__) #<-- absolute dir the script is in
        rel_path = "../images/cat.jpg"
        img_path = os.path.join(script_dir, rel_path)
        img = read_image(img_path)
        preprocess = self.weights.transforms()
        batch = preprocess(img).unsqueeze(0)
        #print(batch.shape)
        model = resnet50(weights=self.weights, quantize=True)
        #print(model)
        model.eval()
        for name, m in model.named_modules():
            #print(m)
            if (type(m) == nn.intrinsic.quantized.modules.conv_relu.ConvReLU2d):
                self.features_names.append(name)
                m.register_forward_hook(self.hook)
        y = model(batch)
        return y 

a = model_play()
y = a.GetModelFeature()
print(a.features_names)
processed = []
for feature_map in a.features_out:
    scale = feature_map.q_scale()
    zero_point = feature_map.q_zero_point()
    feature_map = feature_map.dequantize()*(1/scale) + zero_point
    feature_map = torch.round(feature_map).to(torch.int32)
    # feature_map = feature_map.squeeze(0)
    processed.append(feature_map.detach().numpy())
for fm in processed:
    print(fm.shape)

for fmap_index in range(len(processed)):
    fmap = processed[fmap_index]
    if (GROUP_BY_K):
        fmap = group_by_NB_OF_WORDS_k_dimension(fmap)
    else: 
        fmap = group_by_NB_OF_WORDS_x_dimension(fmap)
    
    q_size = fmap.shape[1]
    r_size = fmap.shape[2]
    s_size = fmap.shape[3]
    new_array = np.zeros((1,q_size,r_size,s_size))
    to_plot = np.ndarray(0)
    for q in range(q_size):
        for r in range(r_size):
            for s in range(s_size):
                max = fmap[0, q, r, s, :].max()
                # print(max)
                new_array[0][q][r][s] = max

    for i in range(s_size):
        to_plot = np.append(to_plot, new_array[0, :, :, i].flatten())
    if WITHOUT_ZEROS:
        to_plot = to_plot[to_plot != 0]
    #print(to_plot.shape)
    #plt.subplots_adjust(left=0.15, bottom=0.115, right=0.97, top=0.91, wspace=0.2, hspace=0.2)
    plt.rcParams['figure.figsize'] = [15.1, 12]

    plt.hist(to_plot , color = 'blue', edgecolor = 'black', bins = 10)
    title_plot = 'Value Distribution: ' + a.features_names[fmap_index]
    print(a.features_names[fmap_index])
    plt.title(title_plot, fontsize = 45)
    plt.xlabel('Values', fontsize = 38)
    plt.ylabel('Occurences', fontsize = 38)
    plt.xticks(fontsize=30)
    plt.yticks(fontsize=30)
    plt.subplots_adjust(left=0.15)
    plt.subplots_adjust(bottom=0.15)
    #plt.subplots_adjust(right=-0.1)
    plt.show()
