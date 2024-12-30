%% 自定义删选均值恒虚警算法（Censored Mean CFAR）
% 功能：该函数实现了删选均值恒虚警（Censored Mean CFAR）算法，用于目标检测。
% 该算法通过对背景噪声参考单元的删选处理，估计干扰噪声功率，从而计算目标检测的阈值。
%
% 输入参数：
%   - xc          : 输入的回波信号（1xM的向量），包含待检测的信号。
%   - N           : 参考单元总数，包括测试单元两侧的邻域单元数目。
%   - pro_N       : 参考单元的偏移量，控制参考单元的范围，确保与测试单元不重叠。
%   - PFA         : 期望的虚警概率（Probability of False Alarm），控制检测阈值，影响虚警的容忍度。
%
% 输出参数：
%   - index       : 目标检测的有效索引范围，指示哪些位置需要计算目标检测阈值。
%   - XT          : 计算出的目标检测阈值，基于参考单元估计的背景噪声功率来计算。
%
% 公式说明：
%   - alpha是阈值乘数，它根据参考单元数量N和期望的虚警概率PFA进行计算：
%     \[
%     \alpha = N \cdot \left( PFA^{\left(-\frac{1}{N}\right)} - 1 \right)
%     \]
%     alpha控制了背景噪声的阈值调整因子。
%   - 在背景噪声的估计过程中，通过选择剩余参考单元的均值来估计干扰功率，去除其中的极端值（如功率最高的 M 个单元）。
%     - 计算参考单元的绝对值并排序，剔除功率最大的M个参考单元。
%     - 剩余参考单元的平均值作为噪声功率估计（\(\hat{\sigma_w^2}\)）。
%   - 目标检测的阈值（threshold）为噪声功率估计与alpha的乘积：
%     \[
%     \text{threshold} = \hat{\sigma_w^2} \cdot \alpha
%     \]

function [index, XT] = cfar_cm(xc, N, pro_N, PFA)
    % 计算阈值乘数 alpha，基于虚警概率和参考单元数量
    alpha = N * ((PFA)^(-1 / N) - 1);

    % 预定义有效索引范围，从 N/2 + pro_N/2 到信号的末尾，避免越界
    index = 1 + N/2 + pro_N/2 : length(xc) - N/2 - pro_N/2;
    % 初始化阈值数组
    XT = zeros(1, length(index));

    % 确定要删选的最大 M 个参考单元数量，通常选取 N/4 的参考单元数量
    M = round(N / 4);

    % 对每个有效索引位置 i 进行CFAR检测
    for i = index
        % 获取左侧和右侧的参考单元（去除测试单元）
        cell_left = xc(1, i - N/2 - pro_N/2 : i - pro_N/2 - 1);
        cell_right = xc(1, i + pro_N/2 + 1 : i + N/2 + pro_N/2);

        % 合并左侧和右侧的参考单元
        ref_cells = [cell_left, cell_right];
        % 对参考单元取绝对值，假设信号可能包含负值
        ref_cells_abs = abs(ref_cells);
        % 排序参考单元，剔除功率最高的 M 个单元
        % 返回排序后的参考单元（sorted_ref），这里我们不使用排序的索引（sorted_indices），故改成~
        [sorted_ref, ~] = sort(ref_cells_abs, 'descend');
        censored_ref = sorted_ref(M + 1 : end);

        % 计算剩余参考单元的平均功率作为背景噪声功率估计
        sigma_w2_hat = mean(censored_ref);
        % 计算目标检测的阈值
        threshold = sigma_w2_hat * alpha;
        % 将计算得到的阈值赋值给 XT 数组
        XT(1, i - N/2 - pro_N/2) = threshold;
    end
end
