%% 函数 env_uniform：生成均匀背景高斯白噪声的信号
% 输入参数:
%   - variance：噪声的方差，用于生成正态分布噪声。
%   - shape   ：生成的噪声信号的大小。
%   - power_db：功率，以dB为单位，用于控制噪声的幅度。
%   - show_out：可选参数，默认为0。若为1，则会绘制噪声信号的幅度对数图。
%
% 输出参数:
%   - xc      : 生成的噪声信号。

function [ xc ] = env_uniform(variance, shape, power_db, show_out)
    % 检查输入参数的个数，如果只有三个输入参数，设置show_out为0
    if (nargin == 3)
        show_out = 0;
    end

    % 将功率转换为幅度（线性），使用公式 c = 10^(power_db / 10)
    c = 10^(power_db / 10);  % 将dB功率转换为线性幅度
    % 生成一个正态分布的噪声序列，均值为0，方差为variance，长度为shape
    xc = c + random('Normal', 0, variance, 1, shape); 
    
    % 如果show_out为1，则绘制噪声信号的幅度对数图
    if show_out == 1
        plot(10 .* log(abs(xc)) ./ log(10));  % 绘制幅度的对数图，单位为dB
    end
end