import torch
from torchvision.models.quantization import resnet50, ResNet50_QuantizedWeights
import torch.nn as nn
from torchvision.io import read_image
import os 
import numpy as np
import matplotlib.pyplot as plt
from accelerator_functions import *
GROUP_BY_K = 0
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
        script_dir = os.path.dirname(__file__) 
        rel_path = "../images/elephant.jpg"
        img_path = os.path.join(script_dir, rel_path)
        print(img_path)
        img = read_image(img_path)
        preprocess = self.weights.transforms()
        batch = preprocess(img).unsqueeze(0)
        model = resnet50(weights=self.weights, quantize=True)
        print(model)
        model.eval()
        for name, m in model.named_modules():
            if (type(m) == nn.intrinsic.quantized.modules.conv_relu.ConvReLU2d):
                self.features_names.append(name)
                m.register_forward_hook(self.hook)
        y = model(batch)
        return y 

a = model_play()
y = a.GetModelFeature()

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

## Flow for if we want to look to the compression ratio of the Feature Maps after all ConvRelu2D layers.
total_unencoded_nb_of_bits = 0
total_encoded_nb_of_mask_bits = 0 
total_encoded_nb_of_encoded_bits = 0 

# Determine compression ratio
for fmap_index in range(len(processed)):
    fmap = processed[fmap_index]
    unencoded_nb_of_bits = fmap.shape[0]*fmap.shape[1]*fmap.shape[2]*fmap.shape[3]*8
    total_unencoded_nb_of_bits += unencoded_nb_of_bits
    print("Unencoded number of bits of", a.features_names[fmap_index], ": ", unencoded_nb_of_bits)
    if (GROUP_BY_K):
        encoder_k_dimension(fmap, 'MASK_FILE.txt', 'ENCODED_FILE.txt')
    else: 
        encoder_x_dimension(fmap, 'MASK_FILE.txt', 'ENCODED_FILE.txt')
    with open('MASK_FILE.txt', 'r') as file:
        content = file.read()
        mask_nb_of_bits = len(content)
        print("Encoded number of mask bits of", a.features_names[fmap_index], ": ", mask_nb_of_bits)
    with open('ENCODED_FILE.txt', 'r') as file:
        content = file.read()
        encoded_nb_of_bits = len(content)
        print("Encoded number of encoded bits of", a.features_names[fmap_index], ": ", encoded_nb_of_bits)
    total_encoded_nb_of_mask_bits += mask_nb_of_bits
    total_encoded_nb_of_encoded_bits += encoded_nb_of_bits
    total_encoded_bits = mask_nb_of_bits + encoded_nb_of_bits
    compression_ratio = unencoded_nb_of_bits/total_encoded_bits
    print("Compression ratio of bits of", a.features_names[fmap_index], ": ", compression_ratio)
    os.remove('MASK_FILE.txt')
    os.remove('ENCODED_FILE.txt')
print("Total unencoded number of bits: ", total_unencoded_nb_of_bits)
print("Total mask number of bits: ", total_encoded_nb_of_mask_bits)
print("Total encoded number of bits: ", total_encoded_nb_of_encoded_bits)
total_encoded_nb_of_bits = total_encoded_nb_of_mask_bits + total_encoded_nb_of_encoded_bits
total_compression_ratio = total_unencoded_nb_of_bits/ total_encoded_nb_of_bits
print("Total compression ratio: ", total_compression_ratio)
