%% 自定义无分布恒虚警算法（DF-CFAR）
% 功能：该函数实现了无分布恒虚警（Distribution-Free CFAR, DF-CFAR）算法，用于目标检测。
% 与传统的CFAR算法不同，DF-CFAR算法不假设背景噪声的具体分布，通过排序选取中位数作为背景噪声的估计，从而计算目标检测的阈值。
%
% 输入参数：
%   - xc          : 输入回波信号，是待检测的信号（1xM的向量）。
%   - N           : 用于计算背景噪声的邻域窗口大小，即参考单元的总数。
%   - pro_N       : 扩展邻域的大小，确保参考单元的范围能够包含足够的背景信息。
%   - PAD         : 虚警概率的影响因子，控制动态调整因子的计算。
%
% 输出参数：
%   - index       : 目标检测的有效索引范围，指示哪些位置需要计算目标检测阈值。
%   - XT          : 计算出的目标检测阈值，基于背景噪声的中位数估计与动态调整因子alpha的乘积。
%
% 公式说明：
%   - alpha 是动态调整因子，基于参考单元数量 N 和虚警概率 PAD 进行计算：
%     \[
%     \alpha = N \cdot \left(PAD^{\left(-\frac{1}{N}\right)} - 1\right)
%     \]
%   - 背景噪声的估计通过对合并后的参考单元信号进行排序，选择排序后的中位数作为噪声功率估计：
%     \[
%     Z = \text{median}(sorted\_cells)
%     \]
%   - 目标检测的阈值为中位数与 alpha 的乘积：
%     \[
%     \text{threshold} = Z \cdot \alpha
%     \]

function [ index, XT ] = cfar_df(xc, N, pro_N, PAD)
    % 计算动态调整因子 alpha，基于虚警概率和参考单元数量
    alpha = N * (PAD.^(-1./N) - 1);

    % 定义有效索引范围，确保在信号的有效范围内进行计算
    index = 1 + N/2 + pro_N/2 : length(xc) - N/2 - pro_N/2;
    % 初始化目标检测阈值数组
    XT = zeros(1, length(index));

    % 对每个有效索引位置 i 进行 DF-CFAR 检测
    for i = index
        % 获取左边邻域和右边邻域的信号
        cell_left = xc(1, i - N/2 - pro_N/2 : i - pro_N/2 - 1);
        cell_right = xc(1, i + pro_N/2 + 1 : i + N/2 + pro_N/2);
        % 将左侧和右侧的参考单元信号合并
        cell_all = [cell_left, cell_right];
        % 对合并后的信号进行排序
        sorted_cells = sort(cell_all);

        % 选择排序后的中位数作为背景噪声估计
        Z = sorted_cells(floor(length(sorted_cells) / 2));

        % 计算目标检测的阈值
        XT(1, i - N/2 - pro_N/2) = Z * alpha;
    end
end
