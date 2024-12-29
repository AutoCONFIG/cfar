%%  对数恒虚警 (Log-CFAR) 算法
function [ index, XT ] = cfar_lg(xc, N, pro_N, PAD)
    % xc: 输入的回波信号（1xM的向量）
    % N: 用于计算背景噪声的邻域窗口大小
    % pro_N: 扩展邻域的大小
    % PAD: 虚警概率，影响动态阈值因子alpha

    % 计算动态调整因子 alpha
    alpha = N * (PAD.^(-1./N) - 1);

    % 定义目标检测的有效索引范围
    index = 1 + N/2 + pro_N/2 : length(xc) - N/2 - pro_N/2;
    XT = zeros(1, length(index));

    % 对每个位置进行CFAR检测
    for i = index
        % 获取左边邻域和右边邻域的信号
        cell_left = xc(1, i - N/2 - pro_N/2 : i - pro_N/2 - 1);
        cell_right = xc(1, i + pro_N/2 + 1 : i + N/2 + pro_N/2);
        
        % 将信号取对数
        log_cell_left = log10(cell_left + eps);  % 加上小的常数eps避免对数零的情况
        log_cell_right = log10(cell_right + eps);
        
        % 计算对数信号的均值
        log_mean_left = mean(log_cell_left);
        log_mean_right = mean(log_cell_right);
        
        % 计算背景噪声的对数均值
        Z_log = (log_mean_left + log_mean_right) / 2;
        
        % 计算目标检测阈值
        XT(1, i - N/2 - pro_N/2) = real(10^(Z_log) * alpha); % 转换回原来的尺度
    end
end
