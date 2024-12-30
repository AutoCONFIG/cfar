%% 自定义对数恒虚警（Log-CFAR）算法
% 功能：该函数实现了对数恒虚警（Log-CFAR）算法，用于目标检测。
% Log-CFAR通过对参考单元信号取对数并计算对数均值，再乘以一个动态调整因子alpha来计算目标检测阈值。
% 该算法适用于处理背景噪声分布不对称或非高斯分布的情况。
%
% 输入参数：
%   - xc          : 输入的回波信号，待检测的信号（1xM的向量）。
%   - N           : 用于计算背景噪声的邻域窗口大小，即参考单元的总数（包括测试单元两侧的邻域单元数目）。
%   - pro_N       : 扩展邻域的大小，确定参考单元的范围，避免测试单元与参考单元重叠。
%   - PAD         : 虚警概率的影响因子，控制动态调整因子的计算，影响检测的灵敏度。
%
% 输出参数：
%   - index       : 目标检测的有效索引范围，指示哪些位置需要计算目标检测阈值。
%   - XT          : 计算得到的目标检测阈值，基于背景噪声的对数均值与动态调整因子alpha的乘积。
%
% 公式说明：
%   - alpha 是动态调整因子，基于参考单元数量 N 和虚警概率 PAD 进行计算：
%     \[
%     \alpha = N \cdot \left(PAD^{\left(-\frac{1}{N}\right)} - 1\right)
%     \]
%   - 对于每个索引位置 i，获取左侧和右侧的参考单元信号，并对信号取对数（避免取对数零时加上小常数eps）：
%     \[
%     \log_{10}(\text{cell\_left} + \epsilon), \log_{10}(\text{cell\_right} + \epsilon)
%     \]
%   - 计算对数信号的均值作为背景噪声的对数估计：
%     \[
%     Z_{\log} = \frac{1}{2} \left(\text{mean}(\log(\text{cell\_left})) + \text{mean}(\log(\text{cell\_right})) \right)
%     \]
%   - 目标检测的阈值是背景噪声对数均值的 10 的指数与动态调整因子 alpha 的乘积：
%     \[
%     \text{threshold} = 10^{Z_{\log}} \cdot \alpha
%     \]
%     其中， `real()` 确保返回实数值，避免计算中的虚部。

function [ index, XT ] = cfar_lg(xc, N, pro_N, PAD)
    % 计算动态调整因子 alpha，基于虚警概率和参考单元数量
    alpha = N * (PAD.^(-1./N) - 1);

    % 定义有效索引范围，确保在信号的有效范围内进行计算
    index = 1 + N / 2 + pro_N / 2 : length(xc) - N / 2 - pro_N / 2;
    % 初始化目标检测阈值数组
    XT = zeros(1, length(index));

    % 对每个有效索引位置 i 进行 Log-CFAR 检测
    for i = index
        % 获取左边邻域和右边邻域的信号
        cell_left = xc(1, i - N / 2 - pro_N / 2 : i - pro_N / 2 - 1);
        cell_right = xc(1, i + pro_N / 2 + 1 : i + N / 2 + pro_N / 2);
        
        % 对左侧和右侧邻域信号取对数，避免取对数零时加上小常数eps
        log_cell_left = log10(cell_left + eps);  % 加上 eps 避免对数零的情况
        log_cell_right = log10(cell_right + eps);
        % 计算左侧和右侧对数信号的均值
        log_mean_left = mean(log_cell_left);
        log_mean_right = mean(log_cell_right);
        
        % 计算背景噪声的对数均值
        Z_log = (log_mean_left + log_mean_right) / 2;
        
        % 计算目标检测阈值，转换回原来的尺度
        XT(1, i - N / 2 - pro_N / 2) = real(10^(Z_log) * alpha); % 转换回原始尺度并确保为实数
    end
end
