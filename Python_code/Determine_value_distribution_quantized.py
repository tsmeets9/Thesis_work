import torch
from torchvision.models.quantization import resnet50, ResNet50_QuantizedWeights
import torch.nn as nn
from torchvision.io import read_image
import os 
import numpy as np
import matplotlib.pyplot as plt


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
        rel_path = "images/cat.jpg"
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
    to_plot = np.ndarray(0)
    for i in range(fmap.shape[1]):
        to_plot = np.append(to_plot, fmap[0, i, :, :].flatten())
    if WITHOUT_ZEROS:
        to_plot = to_plot[to_plot != 0]
    print(to_plot.shape)
    plt.rcParams['figure.figsize'] = [12.5, 9.8]

    plt.hist(to_plot , color = 'blue', edgecolor = 'black', bins = 10)
    title_plot = 'Value Distribution: ' + a.features_names[fmap_index]
    print(a.features_names[fmap_index])
    plt.title(title_plot, fontsize = 40)
    plt.xlabel('Values', fontsize = 37)
    plt.ylabel('Occurences', fontsize = 37)
    plt.xticks(fontsize=18)
    plt.yticks(fontsize=18)
    plt.show()
