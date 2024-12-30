%% 程序初始化
clc; clear all; close all;

%% 均匀背景噪声（单目标&多目标）
variance = 120; % 方差，以便得到白噪声
show_out = 0;   % 是否显示图形（0表示不显示）

choice = 0;     % 用户选择的噪声类型：0代表边缘背景噪声，1代表均匀背景噪声
if choice == 0     % 边缘背景高斯白噪声
    shape    = [100,200];   % 噪声矩阵的形状，两个目标分别为100和200长度
    noise_db = [20, 30];    % 噪声功率的dB值，对应两个目标
    noise_p  = 10.^(noise_db./10);  % 将功率dB转换为线性幅度，便于调用噪声函数生成噪声
    [ xc ]   = env_edge(variance, shape, noise_db, show_out);    % 调用env_edge函数生成噪声
elseif choice == 1 % 均匀背景高斯白噪声
    shape    = 200;                 % 生成一个长度为200的噪声序列
    noise_db = 20;                  % 功率dB为20
    noise_p  = 10.^(noise_db./10);  % 将功率dB转换为线性幅度，便于调用噪声函数生成噪声
    [ xc ]   = env_uniform(variance,  shape, noise_db,show_out); % 调用env_uniform函数生成噪声
else
    disp('输入有误，请输入 0 或者  进行正确选择。');
end

%% 多目标设置
% 通过预设置的信噪比和噪声功率，计算对应的信号功率
SNR1 = 15;  signal1_p = 10.^(SNR1./10).*noise_p(1,end);
SNR2 = 12;  signal2_p = 10.^(SNR2./10).*noise_p(1,end);
SNR3 = 8;   signal3_p = 10.^(SNR3./10).*noise_p(1,end);
SNR4 = 5;   signal4_p = 10.^(SNR4./10).*noise_p(1,end);

% 设置目标位置，index轴方向允许随机的小偏移
loc1 = randi([43,44],1,1);
xc(1,loc1) = signal1_p;
loc2 = randi([46,48],1,1);
xc(1,loc2) = signal3_p;
loc3 = randi([50,53],1,1);
xc(1,loc3) = signal2_p;
loc4 = randi([55,58],1,1);
xc(1,loc4) = signal1_p;
loc5 = randi([90,93],1,1);  % 这个位置接近边缘处，但是依然在前一个杂波区
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

%% 参数设置
N     = 36;         % 背景噪声窗口大小，控制背景噪声估计时参考的单元数
pro_N = 10;         % 背景噪声窗口的边界单元数，指定窗口两侧需要去掉的单元数
PAD   = 10^(-4);    % 虚警概率（PFA，Probability of False Alarm），用于调整背景噪声估计的阈值
k     = 2.*N./4;    % 在有序统计量中，选择背景噪声窗口中第 `k` 小的元素作为估计背景噪声，
                    % 选择 k = N / 2 是为了平衡在背景噪声估计时忽略极端的高值，而又不过于严格地限制了选择的范围

u     = 0.001;      % 加权系数，用于控制当前信号和历史信号的融合比例
xc_tp = zeros(1, shape(end));           % `xc_tp` 是上一时刻的信号数据，用于时序数据的平滑。
                                        % 这里是初始化，全部设置为0。此时 shape(end) 为 200

xc_tp = xc_tp .* (1 - u) + xc .* u;     % 加权平滑：`u` 控制当前时刻和前一时刻信号的融合程度

% 调用对应的CFAR算法，得出CFAR检测阈值结果
[index_ac, XT_ac] = cfar_ac(xc, N, pro_N, PAD);
[index_cm, XT_cm] = cfar_cm(xc, N, pro_N, PAD);
[index_df, XT_df] = cfar_df(xc, N, pro_N, PAD);
[index_go, XT_go] = cfar_go(xc, N, pro_N, PAD);
[index_lg, XT_lg] = cfar_lg(xc, N, pro_N, PAD);
[index_os, XT_os] = cfar_os(abs(xc), N, k, pro_N, PAD);
[index_sc, XT_sc] = cfar_sc(xc, N, pro_N, PAD);
[index_so, XT_so] = cfar_so(xc, N, pro_N, PAD);
[index_tc, XT_tc] = cfar_tc(xc, xc_tp, N, pro_N, PAD);

%% 算法名称列表、CFAR阈值列表，CFAR阈值对应索引列表
% 以便于统一绘图
algorithm_names = {'CFAR AC', 'CFAR CM', 'CFAR DF', 'CFAR GO', 'CFAR LOG', 'CFAR OS', 'CFAR SC', 'CFAR SO', 'CFAR TC'};
XT_list = {XT_ac, XT_cm, XT_df, XT_go, XT_lg, XT_os, XT_sc, XT_so, XT_tc};
index_list = {index_ac, index_cm, index_df, index_go, index_lg, index_os, index_sc, index_so, index_tc};

adjacent_window_size = 1;  % 设置相邻检测的窗口大小，防止检测虚警时多重标记

% 预分配存储空间以提升下面for遍历性能
num_algorithms = length(algorithm_names);   % 获取算法种类的长度，以便于预分配内存大小
TDR_list = zeros(1, num_algorithms);        % 预分配TDR_list大小
FAR_list = zeros(1, num_algorithms);        % 预分配FAR_list大小
true_detections_list = zeros(1, num_algorithms);  % 预分配true_detections_list大小
false_alarms_list = zeros(1, num_algorithms);  % 预分配false_alarms_list大小
false_alarm_positions_list = cell(1, num_algorithms);  % 预分配cell数组

for i = 1:num_algorithms  % 遍历所有算法
    disp(['评估算法：', algorithm_names{i}]);
    
    % 调用perf_cfar函数评估性能
    [TDR, FAR, true_detections, false_alarms, false_alarm_positions] = ...
        perf_cfar(xc, XT_list{i}, index_list{i}, cell2mat(targets(:, 1)), adjacent_window_size);
    
    % 存储评估结果，使用索引直接填充结果
    TDR_list(i) = TDR;  % 真检测率
    FAR_list(i) = FAR;  % 虚警率
    true_detections_list(i) = true_detections;  % 真检测目标数
    false_alarms_list(i) = false_alarms;        % 虚警目标数
    false_alarm_positions_list{i} = false_alarm_positions;  % 存储虚警位置，以便在图像中标明虚警点
    
    disp('-----------------------------------------');
    disp(['真检测率 (TDR): ', num2str(TDR)]);
    disp(['虚警率 (FAR): ', num2str(FAR)]);
    disp(['真检测目标数: ', num2str(true_detections)]);
    disp(['虚警目标数: ', num2str(false_alarms)]);
    disp('-----------------------------------------');
end

%% 绘制包含性能评估信息的CFAR结果图
plot_cfar_subplots(xc, XT_list, index_list, targets, N, algorithm_names, TDR_list, FAR_list, true_detections_list, false_alarms_list, false_alarm_positions_list);
