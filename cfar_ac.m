%% 单元平均恒虚警算法（Cell-Averaging CFAR）
% 功能：该函数实现了单元平均恒虚警（Cell-Averaging CFAR）算法，用于目标检测。
% 该算法假设回波信号服从高斯分布，并通过邻域平均背景噪声来计算目标检测阈值。
%
% 输入参数：
%   - xc          : 输入的回波信号（1xM的向量），包含待检测的信号。
%   - N           : 用于计算背景噪声的邻域窗口大小，决定了用于估计背景噪声的采样点数量。
%   - pro_N       : 扩展邻域的大小，决定了与目标相关的邻域大小。
%   - PAD         : 虚警概率，控制背景噪声的估计误差，并影响阈值的动态调整。较小的PAD值会提高阈值。
%
% 输出参数：
%   - index       : 目标检测的有效索引范围。返回用于计算目标阈值的索引。
%   - XT          : 计算出的目标检测阈值，作为与实际信号的比较依据。XT是与目标信号比较的门限值。
%
% 公式说明：
%   - 在本算法中，背景噪声的估计使用的是背景单元（左侧和右侧邻域）平均值的方式。
%   - 背景噪声的估计采用了计算邻域窗口内所有值的和，然后进行归一化：
%       Z = (sum(cell_left) + sum(cell_right)) / N
%   - 然后，目标检测的阈值 XT 通过对噪声估计值 Z 进行调整：
%       XT = Z * alpha
%     其中，alpha 是一个动态调整因子，由虚警概率 PAD 和邻域大小 N 决定。
%   - alpha 计算公式：
%       alpha = N * (PAD^(-1/N) - 1)
%     这个公式根据背景噪声和虚警概率调整检测阈值。

function [index, XT] = cfar_ac(xc, N, pro_N, PAD)
    % 计算动态调整因子 alpha
    % alpha 根据虚警概率 PAD 和邻域窗口大小 N 计算，用于调整阈值
    alpha = N * (PAD.^(-1/N) - 1);

    % 定义目标检测的有效索引范围
    % 从第 N/2 + pro_N/2 到信号的末尾，确保不会越界
    index = 1 + N/2 + pro_N/2 : length(xc) - N/2 - pro_N/2;
    % 初始化阈值数组
    XT = zeros(1, length(index));

    % 对每个有效索引位置 i 进行CFAR检测
    for i = index
        % 获取左侧邻域信号
        cell_left = xc(1, i - N/2 - pro_N/2 : i - pro_N/2 - 1);
        % 获取右侧邻域信号
        cell_right = xc(1, i + pro_N/2 + 1 : i + N/2 + pro_N/2);
        
        % 计算左右邻域的平均背景噪声（单元平均）
        Z = (sum(cell_left) + sum(cell_right)) / N;
        
        % 计算目标检测的阈值，并存储在XT数组中
        XT(1, i - N/2 - pro_N/2) = Z * alpha;
    end
end
