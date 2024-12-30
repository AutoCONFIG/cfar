%% 函数 env_edge：生成带有边缘背景高斯白噪声的信号
% 输入参数:
%   - variance：噪声的方差，用于生成正态分布噪声。
%   - shape   ：一个向量，指定生成的噪声矩阵的形状。
%   - power_db：功率，以dB为单位，用于控制噪声的幅度。
%   - show_out：可选参数，默认为0。若为1，则会绘制噪声信号的幅度对数图。
%
% 输出参数:
%   - xc      : 生成的噪声信号。

function [ xc ] = env_edge(variance, shape, power_db, show_out)
    % 检查输入参数的个数，如果只有三个输入参数，设置show_out为0
    if (nargin == 3)
        show_out = 0;
    end

    % 将功率转换为幅度（线性），使用公式 c = 10^(power_db / 10)
    c = 10.^(power_db ./ 10);  % 将dB功率转换为幅度
    % 生成一个正态分布的噪声序列，均值为0，方差为variance，长度为shape(1,end)
    xc = random('Normal', 0, variance, 1, shape(1, end)); 
    % 将第一个部分的噪声幅度加上功率的幅度c(1,1)
    xc(1, 1:end) = xc(1, 1:end) + c(1, 1);  % 对第一个目标应用功率

    index = 1;  % 初始化索引
    % 循环处理后续部分的噪声，按各部分的形状调整噪声幅度
    for i = 1:length(power_db)
        % 对第i部分的噪声进行缩放，使得它们的幅度与目标功率成比例
        xc(1, index:shape(1, i)) = xc(1, index:shape(1, i)) * c(1, i) / c(1, 1); 
        % 更新索引，指向下一个部分
        index = shape(1, i) + 1;
    end

    % 如果show_out为1，则绘制噪声信号的幅度对数图
    if show_out == 1
        plot(20 .* log(abs(xc)) ./ log(10));  % 绘制幅度的对数图，单位为dB
    end
end