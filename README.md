This stereo hand pose tracking dataset is described in the paper:
Jiawei Zhang, Jianbo Jiao, Mingliang Chen, Liangqiong Qu, Xiaobin Xu and Qingxiong Yang, "A hand pose tracking benchmark from stereo matching", icip 2017.

You can download the dataset from
Dropbox: https://www.dropbox.com/sh/ve1yoar9fwrusz0/AAAfu7Fo4NqUB7Dn9AiN8pCca?dl=0
BaiduPan: https://pan.baidu.com/s/1qXBpBg4#list/path=%2F

Our stereo hand pose benchmark contains sequences with 6 different backgrounds and every background has two sequences with counting and random poses. Every sequence has 1500 frames, so there are totally 18000 frames in our benchmark.
Stereo and depth images were captured from a Point Grey Bumblebee2 stereo camera and an Intel Real Sense F200 active depth camera simultaneously.

1. Camera parameters
(1) Point Grey Bumblebee2 stereo camera:
base line = 120.054
fx = 822.79041
fy = 822.79041
tx = 318.47345
ty = 250.31296
(2) Intel Real Sense F200 active depth camera:
fx color = 607.92271
fy color = 607.88192
tx color = 314.78337
ty color = 236.42484
fx depth = 475.62768
fy depth = 474.77709
tx depth = 336.41179
ty depth = 238.77962
rotation vector = [0.00531   -0.01196  0.00301] (use Rodrigues' rotation formula to transform it into rotation matrix)
translation vector = [-24.0381   -0.4563   -1.2326]
(rotation and translation vector can transform the coordinates relative to color camera to those relative to depth camera)

2. images
All the images are in folder '.\images\' which contains 12 subfolders. The left/right images for Point Grey Bumblebee2 stereo camera and color/depth images for Intel Real Sense F200 active depth camera have prefix BB_left_, BB_right_, SK_color_ and SK_depth_ respectively.
Since the value of depth is usually larger than 255, we use 3 channels to store depth images and depth = r channel + g channel*256.

3. labels
All the labels are in folder '.\labels\'. The labels for Point Grey Bumblebee2 stereo camera and color/depth images for Intel Real Sense F200 active depth camera have suffix _BB and _SK respectively. For each mat file in this folder, it contains an array named 'handPara' with size 3*21*1500 which stores the 3D positions (x,y,z) in Millimeter of palm center and finger joints (totally 21 joints) of all 1500 the images in this sequence.
The sequence of 21 joints are: palm center(not wrist or hand center), little_mcp, little_pip, little_dip, little_tip, ring_mcp, ring_pip, ring_dip, ring_tip, middle_mcp, middle_pip, middle_dip, middle_tip, index_mcp, index_pip, index_dip, index_tip, thumb_mcp, thumb_pip, thumb_dip, thumb_tip.

If you have any questions, please send email to zhjw1988@gmail.com


--------------------------------------------------------------
Someone asks about how to project the point cloud into color and depth images for Intel Real Sense F200 active depth camera. You can use the following script:

function [depthIJK, depthXYZ, colorIJK, colorXYZ] = positionCalc(depthPosition, depthIm)
    colorKmat = [607.92271, 0, 314.78337; 0, 607.88192, 236.42484; 0, 0, 1];
    depthKmat = [475.62768, 0, 336.41179; 0, 474.77709, 238.77962; 0, 0, 1];
    stereoOm = [0.00531   -0.01196  0.00301];
    stereoT = [-24.0381   -0.4563   -1.2326];
    stereoR = rodrigues(stereoOm);
    
    depthIJK(1:2) = depthPosition;
    depthIJK(3) = 1;
    depthIJK = depthIJK';
    depthXYZ = depthKmat \ depthIJK;
    depthXYZ = depthXYZ * depthIm(int16(depthIJK(2)),int16(depthIJK(1)));
    colorXYZ = stereoR \ (depthXYZ - stereoT);
    colorIJK = colorKmat * colorXYZ;
    colorIJK = colorIJK / colorIJK(3);    
end
