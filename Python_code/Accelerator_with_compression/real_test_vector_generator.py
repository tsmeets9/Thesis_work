# NOTE: information on hooks : https://web.stanford.edu/~nanbhas/blog/forward-hooks-pytorch/
import torch
from torchvision.models.quantization import resnet50, ResNet50_QuantizedWeights
import torch.nn as nn
from torchvision.io import read_image
import os 
import numpy as np
import matplotlib.pyplot as plt
import itertools
from make_test_vectors_Verilog import make_kernels_file, make_kernels_file_decimal_and_grouped
from accelerator_functions import encoder_full_FM
class model_play():
    def __init__(self):
        self.relu = nn.ReLU(inplace=False)
        self.weights = ResNet50_QuantizedWeights.DEFAULT
        self.features_out = None
        self.features_in = None
        self.layer_name = None
        self.layer = None
    def hook(self, model, input, output):
        self.features_out = output
        self.features_in = input
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
            if (type(m) == nn.intrinsic.quantized.modules.conv_relu.ConvReLU2d and name == 'layer1.0.conv2'):
                self.layer_name = name
                self.layer = m
                m.register_forward_hook(self.hook)
        y = model(batch)
        return y 

a = model_play()
y = a.GetModelFeature()

def reference_PE_real(features, weights, input_scale, weights_scales, output_scale, biases): 
    b_size = features.shape[0]
    y_size = features.shape[1]
    c_size = features.shape[2]
    x_size = features.shape[3]
    fy_size = weights.shape[1]
    fx_size = weights.shape[2]
    k_size = weights.shape[3]

    output_32b = np.zeros((b_size, y_size, k_size, x_size))
    output_8b = np.zeros((b_size, y_size, k_size, x_size))
    for b,y,x,k in itertools.product(range(b_size), range(y_size), range(x_size), range(k_size)):
        interm_out = 0
        for c,fy,fx in itertools.product(range(c_size), range(fy_size), range(fx_size)):
            if ((x+fx-fx_size//2) >= 0 and (x+fx-fx_size//2) < x_size and (y+fy-fy_size//2) >= 0 and (y+fy-fy_size//2) < y_size):
                interm_out += (features[b][y+fy-fy_size//2][c][x+fx-fx_size//2] * weights[c][fy][fx][k])
        output_32b[b][y][k][x] = interm_out
        scale_factor = input_scale * weights_scales[k].item()/output_scale
        bias = biases[k]/output_scale
        interm_out = scale_factor*interm_out + bias
        if interm_out < 0:
            interm_out = 0
        output_8b[b][y][k][x] = round(interm_out)
    return output_32b, output_8b

def calc_hit_rate(array1, array2):
    good = (array1 == array2).astype(np.int32).sum()
    all = array1.size
    return good / all


# NOTE: we know that the zero points are all zero for this model, so we don't look into this!!
if __name__ == "__main__":
    a = model_play()
    y = a.GetModelFeature()
    
    inputs = a.features_in[0].int_repr().numpy().transpose((0, 2, 1, 3))
    weights = a.layer.weight().int_repr().numpy().transpose((1, 2, 3, 0))
    outputs_pytorch = a.features_out.int_repr().numpy().transpose((0, 2, 1, 3)).astype(np.int32)

    input_scale = a.features_in[0].q_scale()
    weights_scales = a.layer.weight().q_per_channel_scales()
    output_scale = a.features_out.q_scale()
    biases = a.layer.bias().detach().numpy()
    
    scale_factor = input_scale * weights_scales.numpy()/output_scale
    np.set_printoptions(precision=32)
    np.set_printoptions(suppress=True)
    make_kernels_file(weights, 'weights.txt')
    make_kernels_file_decimal_and_grouped(weights, 'weights_decimal_and_grouped.txt')
    encoder_full_FM(inputs, 'activations_mask.txt', 'activations_encoded.txt')
    outputs_PE, outputs_reference = reference_PE_real(inputs, weights, input_scale, weights_scales, output_scale, biases) 
    print(outputs_PE)
    print(outputs_reference)
    print("reference output")
    print(outputs_reference) 
    print("output Pytorch model")
    print(outputs_pytorch) 
    encoder_full_FM(outputs_reference.astype(np.int32) , 'outputs_mask.txt', 'outputs_encoded.txt')
    print(f'hit rate= {calc_hit_rate(outputs_pytorch, outputs_reference)}') #hit_rate=1.0
    print("Finished")

