%% 最小选择恒虚警算法
% 功能：该函数实现了最小选择恒虚警（S-CFAR）算法，用于目标检测。该算法通过计算左侧和右侧邻域的均值，并选择最小的均值作为背景噪声估计，从而实现目标检测。
% 该算法适用于背景噪声较为均匀的情况，通过选择较小的均值保证背景噪声的估计较为保守，从而提高目标检测的可靠性。

% 输入参数：
%   - xc          : 输入的回波信号（1xM的向量），待检测的信号。
%   - N           : 用于计算背景噪声的邻域窗口大小（即参考单元的总数，包括测试单元两侧的邻域单元数目）。
%   - pro_N       : 扩展邻域的大小，决定参考单元的范围，用于防止测试单元与参考单元重叠。
%   - PAD         : 虚警概率，控制动态调整因子alpha，影响目标检测阈值的计算。

% 输出参数：
%   - index       : 目标检测的有效索引范围，指示哪些位置需要计算目标检测阈值。
%   - XT          : 计算得到的目标检测阈值，基于选择的最小均值和动态调整因子alpha的乘积。

% 公式说明：
%   - alpha 是动态调整因子，通过参考单元数量 N 和虚警概率 PAD 进行计算：
%     \[
%     \alpha = N \cdot \left(PAD^{\left(-\frac{1}{N}\right)} - 1\right)
%     \]
%   - 对于每个索引位置 i，获取左侧和右侧的参考单元信号，计算它们的均值：
%     \[
%     Z_{\text{left}} = \text{mean}(\text{cell\_left}), \quad Z_{\text{right}} = \text{mean}(\text{cell\_right})
%     \]
%   - 选择左侧和右侧的最小均值作为背景噪声估计：
%     \[
%     Z = \min(Z_{\text{left}}, Z_{\text{right}})
%     \]
%   - 目标检测的阈值是最小均值与动态调整因子alpha的乘积：
%     \[
%     \text{threshold} = Z \cdot \alpha
%     \]

function [ index, XT ] = cfar_so(xc, N, pro_N, PAD)
    % 计算动态调整因子 alpha，基于虚警概率和参考单元数量
    alpha = N * (PAD.^(-1./N) - 1);

    % 定义有效索引范围，确保在信号的有效范围内进行计算
    index = 1 + N / 2 + pro_N / 2 : length(xc) - N / 2 - pro_N / 2;
    % 初始化目标检测阈值数组
    XT = zeros(1, length(index));

    % 对每个有效索引位置 i 进行 S-CFAR 检测
    for i = index
        % 获取左侧邻域的参考单元信号
        cell_left = xc(1, i - N / 2 - pro_N / 2 : i - pro_N / 2 - 1);
        % 获取右侧邻域的参考单元信号
        cell_right = xc(1, i + pro_N / 2 + 1 : i + N / 2 + pro_N / 2);
        
        % 计算左侧和右侧邻域的均值
        Z_left = mean(cell_left);
        Z_right = mean(cell_right);
        
        % 选择左侧和右侧均值中的较小者作为背景噪声估计
        Z = min(Z_left, Z_right);
        
        % 计算目标检测阈值，乘以 alpha 进行调整
        XT(1, i - N / 2 - pro_N / 2) = Z * alpha;
    end
end
