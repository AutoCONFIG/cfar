%% 程序初始化
clc;
clear all;
close all;

% shape 初始化，确保它是一个合法的数组
shape = [100, 200];   % 例如，表示信号的尺寸

variance = 200;
noise_db = [20, 30];
noise_p = 10.^(noise_db ./ 10);
show_out = 0;

%% 初始化 xtp 等变量
xtp = zeros(1, shape(end));   % 此时 shape(end) 为 200
d0 = 0;
d1 = [0];

%% 迭代算法实现（杂波图）
N = 36;
u = 0.001;
PAD = 10^(-4);
alpha = N .* (PAD .^ (-1 ./ N) - 1);
pro_N = 10;


% 多目标设置
SNR1 = 15;  signal1_p = 10.^(SNR1./10).*noise_p(1,end);
SNR2 = 12;  signal2_p = 10.^(SNR2./10).*noise_p(1,end);
SNR3 = 8;   signal3_p = 10.^(SNR3./10).*noise_p(1,end);
SNR4 = 5;   signal4_p = 10.^(SNR4./10).*noise_p(1,end);

for i = 1:1:4000
    % 生成信号
    [xc] = env_edge(variance, shape, noise_db, show_out);

    % 添加目标信号
    loc1 = randi([43, 44], 1, 1);
    xc(1, loc1) = signal1_p;
    loc2 = randi([46, 48], 1, 1);
    xc(1, loc2) = signal3_p;
    loc3 = randi([50, 53], 1, 1);
    xc(1, loc3) = signal2_p;
    loc4 = randi([55, 58], 1, 1);
    xc(1, loc4) = signal1_p;

    loc6 = randi([102, 108], 1, 1);
    xc(1, loc6) = signal3_p;

    % 更新 xtp 和噪声序列
    xtp = xtp .* (1 - u) + xc .* u;
    d0 = d0 .* (1 - u) + u;
    d1 = cat(2, d1, d0);

    % 调用 cfar_tc 函数进行目标检测
    [index, XT, xc_tpn] = cfar_tc(xc, xtp, N, pro_N, PAD);

    % 可选：图谱显示
    if mod(i, 100) == 0
        figure;
        plot(10 .* log(abs(xc)) ./ log(10)), hold on;
        plot(10 .* log(abs(xc_tpn)) ./ log(10)), hold on;
    end
end
