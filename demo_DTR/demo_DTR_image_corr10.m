%demo_trpca_tauS_sensitivity
clear; clc; close all;
addpath Functions
addpath(genpath(cd))
%% 1. 读入原始图像
pic_name = '03.jpg';
X = double(imread(pic_name));
X = X / 255;
[n1,n2,n3] = size(X);
%% 2. 生成固定的带噪图像
rng(2024);                     % 固定随机种子
Xn = X; 
Yn = reshape(Xn,[n1*n2,n3]);
rhos = 0.1;                    % 噪声比例
ind  = find(rand(n1*n2,1) < rhos);
Yn(ind,:) = rand(length(ind),n3);
Xn = reshape(Yn,[n1,n2,n3]);
%% 3. 公共参数设置
opts.mu        = 1e-2;
opts.tol       = 1e-5;
opts.rho       = 1.25;
opts.max_iter  = 500;
opts.DEBUG     = 0;
opts.tau_L     = 3;            
opts.tau_S    = 1e3;
opts.directions = [1,2];
[n1,n2,n3] = size(Xn);
lambda = 1 / sqrt(max(n1,n2)*n3);

%% Method 1: DTR
disp('......Run DTR......')
    tic;
    [Xhat_DTR, E3_DTR, ~, ~, ~] = DTR(Xn, lambda, opts);
 time_DTR=toc;

%% Method 2: GDTR
disp('......Run GDTR......')
tic;
[Xhat_GDTR,E_GDTR] = GDTR(Xn,opts);
time_GDTR=toc;

  [PSNR_DTR, SSIM_DTR, FSIM_DTR] = Img_QA(Xhat_DTR, X);
  [PSNR_GDTR, SSIM_GDTR, FSIM_GDTR] = Img_QA(Xhat_GDTR, X);


%% Display results
fprintf('\n===================  Results  ===================\n');
fprintf('%-10s %10s %10s %10s %12s\n', 'Method', 'PSNR', 'SSIM', 'FSIM', 'Time(s)');
fprintf('%-10s %10.4f %10.4f %10.4f %12.4f\n', 'DTR',  PSNR_DTR,  SSIM_DTR,  FSIM_DTR,  time_DTR);
fprintf('%-10s %10.4f %10.4f %10.4f %12.4f\n', 'GDTR', PSNR_GDTR, SSIM_GDTR, FSIM_GDTR, time_GDTR);
fprintf('===================================================\n');
