import math
def return_feature_map_size_conv(F_size, K_size, Dilation, Padding, Stride):
    Extented_kernel_size = Dilation * (K_size-1) + 1
    return int((F_size - Extented_kernel_size + 2*Padding)/Stride) + 1

def return_feature_map_size_pooling(F_size, K_size, Padding, Stride):
    #return math.ceil((F_size - K_size + 2*Padding)/Stride)
    return int((F_size - K_size + 2*Padding)/Stride) + 1

if __name__ == '__main__':
    # ALEXNET
    # layer1 = return_feature_map_size_conv(224,11,1,0,4)
    # print(layer1)
    # layer1_pool = return_feature_map_size_pooling(layer1,3,0,2)
    # print(layer1_pool)
    #
    # layer2 = return_feature_map_size_conv(layer1_pool,5,1,2,1)
    # print(layer2)
    # layer2_pool = return_feature_map_size_pooling(layer2,3,0,2)
    # print(layer2_pool)
    #
    # layer3 = return_feature_map_size_conv(layer2_pool, 3, 1, 1, 1)
    # print(layer3)
    # layer3_pool = return_feature_map_size_pooling(layer3, 1, 0, 1)
    # print(layer3_pool)
    #
    # layer4 = return_feature_map_size_conv(layer3_pool, 3, 1, 1, 1)
    # print(layer4)
    # layer4_pool = return_feature_map_size_pooling(layer4, 1, 0, 1)
    # print(layer4_pool)
    #
    # layer5 = return_feature_map_size_conv(layer4_pool, 3, 1, 1, 1)
    # print(layer5)
    # layer5_pool = return_feature_map_size_pooling(layer5, 1, 0, 1)
    # print(layer5_pool)

    # layer1 = return_feature_map_size_conv(224, 3, 1, 1, 1)
    # print(layer1)
    # layer1_pool = return_feature_map_size_pooling(layer1, 1, 0, 1)
    # print("POOL 1 " + str(layer1_pool))

    # layer2 = return_feature_map_size_conv(layer1_pool, 3, 1, 1, 1)
    # print(layer2)
    # layer2_pool = return_feature_map_size_pooling(layer2, 2, 0, 2)
    # print("POOL 2 " + str(layer2_pool))

    # layer3 = return_feature_map_size_conv(layer2_pool, 3, 1, 1, 1)
    # print(layer3)
    # layer3_pool = return_feature_map_size_pooling(layer3, 1, 0, 1)
    # print("POOL 3 " + str(layer3_pool))

    # layer4 = return_feature_map_size_conv(layer3_pool, 3, 1, 1, 1)
    # print(layer4)
    # layer4_pool = return_feature_map_size_pooling(layer4, 2, 0, 2)
    # print("POOL 4 " + str(layer4_pool))

    # layer5 = return_feature_map_size_conv(layer4_pool, 3, 1, 1, 1)
    # print(layer5)
    # layer5_pool = return_feature_map_size_pooling(layer5, 1, 0, 1)
    # print("POOL 5 " + str(layer5_pool))

    # layer6 = return_feature_map_size_conv(layer5_pool, 3, 1, 1, 1)
    # print(layer6)
    # layer6_pool = return_feature_map_size_pooling(layer6, 1, 0, 1)
    # print("POOL 6 " + str(layer6_pool))

    # layer7 = return_feature_map_size_conv(layer6_pool, 3, 1, 1, 1)
    # print(layer7)
    # layer7_pool = return_feature_map_size_pooling(layer7, 2, 0, 2)
    # print("POOL 7 " + str(layer7_pool))

    # layer8 = return_feature_map_size_conv(layer7_pool, 3, 1, 1, 1)
    # print(layer8)
    # layer8_pool = return_feature_map_size_pooling(layer8, 1, 0, 1)
    # print("POOL 8 " + str(layer8_pool))

    # layer9 = return_feature_map_size_conv(layer8_pool, 3, 1, 1, 1)
    # print(layer9)
    # layer9_pool = return_feature_map_size_pooling(layer9, 1, 0, 1)
    # print("POOL 9 " + str(layer9_pool))

    # layer10 = return_feature_map_size_conv(layer9_pool, 3, 1, 1, 1)
    # print(layer10)
    # layer10_pool = return_feature_map_size_pooling(layer10, 2, 0, 2)
    # print("POOL 10 " + str(layer10_pool))

    # layer11 = return_feature_map_size_conv(layer10_pool, 3, 1, 1, 1)
    # print(layer11)
    # layer11_pool = return_feature_map_size_pooling(layer11, 1, 0, 1)
    # print("POOL 11 " + str(layer11_pool))

    # layer12 = return_feature_map_size_conv(layer11_pool, 3, 1, 1, 1)
    # print(layer12)
    # layer12_pool = return_feature_map_size_pooling(layer12, 1, 0, 1)
    # print("POOL 12 " + str(layer12_pool))

    # layer13 = return_feature_map_size_conv(layer12_pool, 3, 1, 1, 1)
    # print(layer13)
    # layer13_pool = return_feature_map_size_pooling(layer13, 2, 0, 2)
    # print("POOL 13 " + str(layer13_pool))

    # VGG-16

    layer1 = return_feature_map_size_conv(224,3,1,1,1)
    print(layer1)
    
    layer2 = return_feature_map_size_conv(layer1,3,1,1,1)
    print(layer2)
    layer2_pool = return_feature_map_size_pooling(layer2,2,0,2)
    print("POOL 2 " + str(layer2_pool))
    
    layer3 = return_feature_map_size_conv(layer2_pool, 3, 1, 1, 1)
    print(layer3)
    
    layer4 = return_feature_map_size_conv(layer3, 3, 1, 1, 1)
    print(layer4)
    layer4_pool = return_feature_map_size_pooling(layer4, 2, 0, 2)
    print("POOL 4 " + str(layer4_pool))
    
    layer5 = return_feature_map_size_conv(layer4_pool, 3, 1, 1, 1)
    print(layer5)

    layer6 = return_feature_map_size_conv(layer5, 3, 1, 1, 1)
    print(layer6)

    layer7 = return_feature_map_size_conv(layer6, 3, 1, 1, 1)
    print(layer7)
    layer7_pool = return_feature_map_size_pooling(layer7, 2, 0, 2)
    print("POOL 7 " + str(layer7_pool))

    layer8 = return_feature_map_size_conv(layer7_pool, 3, 1, 1, 1)
    print(layer8)

    layer9 = return_feature_map_size_conv(layer8, 3, 1, 1, 1)
    print(layer9)

    layer10 = return_feature_map_size_conv(layer9, 3, 1, 1, 1)
    print(layer10)
    layer10_pool = return_feature_map_size_pooling(layer10, 2, 0, 2)
    print("POOL 10 " + str(layer10_pool))

    layer11 = return_feature_map_size_conv(layer10_pool, 3, 1, 1, 1)
    print(layer11)

    layer12 = return_feature_map_size_conv(layer11, 3, 1, 1, 1)
    print(layer12)

    layer13 = return_feature_map_size_conv(layer12, 3, 1, 1, 1)
    print(layer13)
    layer13_pool = return_feature_map_size_pooling(layer13, 2, 0, 2)
    print("POOL 13 " + str(layer13_pool))



