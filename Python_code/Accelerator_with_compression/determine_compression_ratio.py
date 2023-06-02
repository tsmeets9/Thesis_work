import torch
from torchvision.models.quantization import resnet50, ResNet50_QuantizedWeights
import torch.nn as nn
from torchvision.io import read_image
import os 
import numpy as np
import matplotlib.pyplot as plt
from accelerator_functions import *
MULTIPLE_COMPRESSION_RATIO = 1
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
        rel_path = "../images/bird.jpg"
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
if not MULTIPLE_COMPRESSION_RATIO:
    ## Flow for if we only want to look to the compression ratio of one particular layer
    # Choose a feature map and transpose it
    fmap = processed[4]
    print(fmap.shape)

    # Determine compression ratio
    unencoded_nb_of_bits = fmap.shape[0]*(int((fmap.shape[1]-1)/16)+1)*16*fmap.shape[2]*(int((fmap.shape[3]-1)/16)+1)*16*8
    fmap = fmap.transpose((0,2,1,3))
    print("Unencoded number of bits: ", unencoded_nb_of_bits)
    encoder_full_FM(fmap, 'MASK_FILE.txt', 'ENCODED_FILE.txt')
    with open('MASK_FILE.txt', 'r') as file:
        content = file.read()
        mask_nb_of_bits = len(content) - content.count('\n')
        print("Encoded number of mask bits: ", mask_nb_of_bits)
    with open('ENCODED_FILE.txt', 'r') as file:
        content = file.read()
        encoded_nb_of_bits = len(content) - content.count('\n')
        print("Encoded number of encoded bits: ", encoded_nb_of_bits)
    total_encoded_bits = mask_nb_of_bits + encoded_nb_of_bits
    total_compression_ratio = unencoded_nb_of_bits/total_encoded_bits
    print("Compression ratio: ", total_compression_ratio)
    os.remove('MASK_FILE.txt')
    os.remove('ENCODED_FILE.txt')
else:
    ## Flow for if we want to look to the compression ratio of the Feature Maps after all ConvRelu2D layers.
    total_unencoded_nb_of_bits = 0
    total_encoded_nb_of_mask_bits = 0 
    total_encoded_nb_of_encoded_bits = 0 

    # Determine compression ratio
    for fmap_index in range(len(processed)):
        fmap = processed[fmap_index]
        unencoded_nb_of_bits = fmap.shape[0]*(int((fmap.shape[1]-1)/16)+1)*16*fmap.shape[2]*(int((fmap.shape[3]-1)/16)+1)*16*8
        fmap = fmap.transpose((0,2,1,3))
        total_unencoded_nb_of_bits += unencoded_nb_of_bits
        print("Unencoded number of bits of", a.features_names[fmap_index], ": ", unencoded_nb_of_bits)
        encoder_full_FM(fmap, 'MASK_FILE.txt', 'ENCODED_FILE.txt')
        with open('MASK_FILE.txt', 'r') as file:
            content = file.read()
            mask_nb_of_bits = len(content) - content.count('\n')
            print("Encoded number of mask bits of", a.features_names[fmap_index], ": ", mask_nb_of_bits)
        with open('ENCODED_FILE.txt', 'r') as file:
            content = file.read()
            print(content.count('\n'))
            encoded_nb_of_bits = len(content) - content.count('\n')
            print("Encoded number of encoded bits of", a.features_names[fmap_index], ": ", encoded_nb_of_bits)
        total_encoded_nb_of_mask_bits += mask_nb_of_bits
        total_encoded_nb_of_encoded_bits += encoded_nb_of_bits
        total_encoded_bits = mask_nb_of_bits + encoded_nb_of_bits
        compression_ratio = unencoded_nb_of_bits/total_encoded_bits
        print("Compression ratio of bits of", a.features_names[fmap_index], ": ", compression_ratio)
        os.remove('MASK_FILE.txt')
        os.remove('ENCODED_FILE.txt')
        os.remove('ENCODED_FILE_unencoded.txt')
    print("Total unencoded number of bits: ", total_unencoded_nb_of_bits)
    print("Total mask number of bits: ", total_encoded_nb_of_mask_bits)
    print("Total encoded number of bits: ", total_encoded_nb_of_encoded_bits)
    total_encoded_nb_of_bits = total_encoded_nb_of_mask_bits + total_encoded_nb_of_encoded_bits
    total_compression_ratio = total_unencoded_nb_of_bits/ total_encoded_nb_of_bits
    print("Total compression ratio: ", total_compression_ratio)
