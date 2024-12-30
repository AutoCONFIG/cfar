%% 有序统计恒虚警算法（Ordered Statistic CFAR）
% 功能：该函数实现了有序统计恒虚警（OS-CFAR）算法，用于目标检测。在该算法中，参考单元信号先按大小排序，然后选择一个特定位置的排序值作为背景噪声估计，再基于该估计计算目标检测阈值。
% 有序统计法通过选择排序后的第k个元素来估计背景噪声，这使得该算法比传统的CFAR算法具有更强的鲁棒性，特别是在噪声背景分布变化较大的情况下。

% 输入参数：
%   - xc          : 输入的回波信号（1xM的向量），待检测的信号。
%   - N           : 用于计算背景噪声的邻域窗口大小（即参考单元的总数，包括测试单元两侧的邻域单元数目）。
%   - k           : 排序后选择的第k个参考单元，作为背景噪声的估计。通常k为参考单元的前k个最小值。
%   - pro_N       : 扩展邻域的大小，决定参考单元的范围，用于防止测试单元与参考单元重叠。
%   - PAD         : 虚警概率，控制动态调整因子alpha，影响目标检测阈值的计算。

% 输出参数：
%   - index       : 目标检测的有效索引范围，指示哪些位置需要计算目标检测阈值。
%   - XT          : 计算得到的目标检测阈值，基于选择的排序值与动态调整因子alpha的乘积。

% 公式说明：
%   - alpha 是动态调整因子，通过参考单元数量 N 和虚警概率 PAD 进行计算：
%     \[
%     \alpha = N \cdot \left(PAD^{\left(-\frac{1}{N}\right)} - 1\right)
%     \]
%   - 对于每个索引位置 i，获取左侧和右侧的参考单元信号，并合并这些信号。
%   - 将合并后的信号排序，选择排序后的第k个元素作为背景噪声的估计。
%     \[
%     Z = \text{sorted\_cells}(k)
%     \]
%   - 目标检测的阈值是排序后的第k个元素与动态调整因子alpha的乘积：
%     \[
%     \text{threshold} = Z \cdot \alpha
%     \]

function [ index, XT ] = cfar_os(xc, N, k, pro_N, PAD)
    % 计算动态调整因子 alpha，基于虚警概率和参考单元数量
    alpha = N * (PAD.^(-1./N) - 1);

    % 定义有效索引范围，确保在信号的有效范围内进行计算
    index = 1 + N/2 + pro_N/2 : length(xc) - N/2 - pro_N/2;
    % 初始化目标检测阈值数组
    XT = zeros(1, length(index));

    % 对每个有效索引位置 i 进行 OS-CFAR 检测
    for i = index
        % 获取左边邻域和右边邻域的信号
        cell_left = xc(1, i - N/2 - pro_N/2 : i - pro_N/2 - 1);
        cell_right = xc(1, i + pro_N/2 + 1 : i + N/2 + pro_N/2);
        % 合并左侧和右侧的信号
        cell_all = cat(2, cell_left, cell_right);
        % 对合并后的信号进行排序
        cell_sort = sort(cell_all);
        
        % 选择排序后的第k个元素作为背景噪声估计
        Z = cell_sort(1, k);
        % 计算目标检测阈值，乘以 alpha 进行调整
        XT(1, i - N/2 - pro_N/2) = Z * alpha;
    end
end
