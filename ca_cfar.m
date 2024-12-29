% 程序初始化
clc; clear all; close all;

% 均匀背景噪声（单目标&多目标）
shape    = [100,200];
variance = 200;
noise_db = [20,30];
noise_p  = 10.^(noise_db./10);
show_out = 0;
[ xc ]   = env_edge(variance, shape, noise_db, show_out);

% 多目标设置
SNR1 = 15;  signal1_p = 10.^(SNR1./10).*noise_p(1,end);
SNR2 = 12;  signal2_p = 10.^(SNR2./10).*noise_p(1,end);
SNR3 = 8;   signal3_p = 10.^(SNR3./10).*noise_p(1,end);
SNR4 = 5;   signal4_p = 10.^(SNR4./10).*noise_p(1,end);

loc1 = randi([43,44],1,1);
xc(1,loc1) = signal1_p;
loc2 = randi([46,48],1,1);
xc(1,loc2) = signal3_p;
loc3 = randi([50,53],1,1);
xc(1,loc3) = signal2_p;
loc4 = randi([55,58],1,1);
xc(1,loc4) = signal1_p;
loc5 = randi([90,93],1,1);  % 接近杂波区，但是依然在
xc(1,loc5) = signal2_p;
loc6 = randi([102,108],1,1);
xc(1,loc6) = signal3_p;

% 设置目标位置和颜色（每行包含目标位置和对应颜色）
targets = {
    loc1, 'g';
    loc2, 'r';
    loc3, 'b';
    loc4, 'm';
    loc5, 'c';
    loc6, 'y'
};

% 参数设置
N     = 36;
u     = 0.001;
pro_N = 10;
PAD   = 10^(-4);
k     = 2.*N./4;

% 定义 xc_tp（信号平滑处理）
smooth_window = 5;  % 例如使用5个点的平滑窗口

xc_tp = zeros(1, shape(end));   % 此时 shape(end) 为 200
xc_tp = xc_tp .* (1 - u) + xc .* u;

[index_ac, XT_ac] = cfar_ac(xc, N, pro_N, PAD);
[index_cm, XT_cm] = cfar_cm(xc, N, pro_N, PAD);
[index_df, XT_df] = cfar_df(xc, N, pro_N, PAD);
[index_go, XT_go] = cfar_go(xc, N, pro_N, PAD);
[index_log, XT_log] = cfar_log(xc, N, pro_N, PAD);
[index_os, XT_os] = cfar_os(abs(xc), N, k, pro_N, PAD);
[index_sc, XT_sc] = cfar_sc(xc, N, pro_N, PAD);
[index_so, XT_so] = cfar_so(xc, N, pro_N, PAD);
[index_tc, XT_tc] = cfar_tc(xc, xc_tp, N, pro_N, PAD);

algorithm_names = {'CFAR AC', 'CFAR CM', 'CFAR DF', 'CFAR GO', 'CFAR LOG', 'CFAR OS', 'CFAR SC', 'CFAR SO', 'CFAR TC'};
XT_list = {XT_ac, XT_cm, XT_df, XT_go, XT_log, XT_os, XT_sc, XT_so, XT_tc};
index_list = {index_ac, index_cm, index_df, index_go, index_log, index_os, index_sc, index_so, index_tc};

plot_cfar_subplots(xc, XT_list, index_list, targets, N, algorithm_names);
