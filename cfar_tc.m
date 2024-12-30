%% 杂波图恒虚警算法（自适应背景噪声估计恒虚警）
% 功能：该函数实现了自适应背景噪声估计恒虚警（TC-CFAR）算法。TC-CFAR算法通过采用当前回波信号与其邻域回波信号的加权平均，计算自适应背景噪声估计。
% 该算法能够根据回波信号的局部变化，动态调整背景噪声估计，从而提高目标检测的灵活性和准确性。

% 输入参数：
%   - xc          : 输入的回波信号（1xM的向量），待检测的信号。
%   - xc_tp       : 输入的回波信号的前后时刻（或多个时刻）采样的信号。
%   - N           : 用于计算背景噪声的邻域窗口大小（即参考单元的总数）。
%   - pro_N       : 扩展邻域的大小，决定参考单元的范围。
%   - PAD         : 虚警概率，控制动态调整因子 alpha，影响目标检测阈值的计算。

% 输出参数：
%   - index       : 目标检测的有效索引范围，指示哪些位置需要计算目标检测阈值。
%   - XT          : 计算得到的目标检测阈值，基于加权背景噪声估计值与动态调整因子 alpha 的乘积。

% 公式说明：
%   - alpha 是动态调整因子，通过参考单元数量 N 和虚警概率 PAD 进行计算：
%     \[
%     \alpha = N \cdot \left(PAD^{\left(-\frac{1}{N}\right)} - 1\right)
%     \]
%   - 在该算法中，通过当前时刻信号 xc 和前后时刻信号 xc_tp 的加权平均来估计背景噪声：
%     \[
%     \text{xc\_tc}[i] = \frac{\text{xc\_tp}[i]}{3} + \frac{\text{xc}[i-1]}{3} + \frac{\text{xc}[i+1]}{3}
%     \]
%   - 计算背景噪声估计：
%     \[
%     Z = \frac{\sum_{i=1}^{N/2} \text{cell\_left}[i] + \sum_{i=1}^{N/2} \text{cell\_right}[i]}{N}
%     \]
%   - 目标检测的阈值是背景噪声估计值与动态调整因子 alpha 的乘积：
%     \[
%     \text{threshold} = Z \cdot \alpha
%     \]

function [ index, XT ] = cfar_tc(xc, xc_tp, N, pro_N, PAD)
    % 初始化 xc_tc 数组，用于存储加权平均后的背景噪声估计
    xc_tc = zeros(1, length(xc));

    % 计算动态调整因子 alpha，基于参考单元数量 N 和虚警概率 PAD
    alpha = N * (PAD.^(-1./N) - 1);

    % 对 xc_tc 的每个位置进行加权平均操作，计算背景噪声估计
    xc_tc(1, 2:end-1) = xc_tp(1, 2:end-1) / 3 + xc(1, 1:end-2) / 3 + xc(1, 3:end) / 3;
    
    % 对于信号的首尾位置，使用加权平均的简化版本
    xc_tpn = xc_tp(1, 1:end) / 2 + xc(1, 1:end) / 2;
    xc_tc(1, 1) = xc_tpn(1, 1);
    xc_tc(1, end) = xc_tpn(1, end);

    % 定义目标检测的有效索引范围
    index = 1 + N/2 + pro_N/2 : length(xc) - N/2 - pro_N/2;
    % 初始化目标检测阈值数组
    XT = zeros(1, length(index));

    % 对每个有效索引位置 i 进行 TC-CFAR 检测
    for i = index
        % 获取左侧邻域的参考单元信号
        cell_left = xc_tc(1, i - N/2 - pro_N/2 : i - pro_N/2 - 1);
        % 获取右侧邻域的参考单元信号
        cell_right = xc_tc(1, i + pro_N/2 + 1 : i + N/2 + pro_N/2);
        
        % 计算背景噪声估计为左侧和右侧邻域的信号之和的均值
        Z = (sum(cell_left) + sum(cell_right)) / N;
        
        % 计算目标检测阈值，乘以 alpha 进行调整
        XT(1, i - N/2 - pro_N/2) = Z * alpha;
    end
end
