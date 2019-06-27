function [depthIJK, depthXYZ, colorIJK, colorXYZ] = positionCalc(depthPosition, depthIm)
  colorKmat = [607.92271, 0, 314.78337; 0, 607.88192, 236.42484; 0, 0, 1];
  depthKmat = [475.62768, 0, 336.41179; 0, 474.77709, 238.77962; 0, 0, 1];
  stereoOm = [0.00531 -0.01196 0.00301]; stereoT = [-24.0381 -0.4563 -1.2326];
  stereoR = rodrigues(stereoOm);
  depthIJK(1:2) = depthPosition;
  depthIJK(3) = 1;
  depthIJK = depthIJK'; depthXYZ = depthKmat \ depthIJK;
  depthXYZ = depthXYZ * depthIm(int16(depthIJK(2)),int16(depthIJK(1)));
  colorXYZ = stereoR \ (depthXYZ - stereoT); colorIJK = colorKmat * colorXYZ;
  colorIJK = colorIJK / colorIJK(3);
end
