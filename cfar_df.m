%%  无分布恒虚警算法
function [ index, XT ] = cfar_df(xc, N, pro_N, PAD)
    % xc: 输入的回波信号（1xM的向量）
    % N: 用于计算背景噪声的邻域窗口大小
    % pro_N: 扩展邻域的大小
    % PAD: 虚警概率，影响动态阈值因子alpha

    % 计算动态调整因子 alpha
    alpha = N * (PAD.^(-1./N) - 1);

    % 定义目标检测的有效索引范围
    index = 1 + N/2 + pro_N/2 : length(xc) - N/2 - pro_N/2;
    XT = zeros(1, length(index));

    % 对每个位置进行DF-CFAR检测
    for i = index
        % 获取左边邻域和右边邻域的信号
        cell_left = xc(1, i - N/2 - pro_N/2 : i - pro_N/2 - 1);
        cell_right = xc(1, i + pro_N/2 + 1 : i + N/2 + pro_N/2);

        % 将邻域信号合并
        cell_all = [cell_left, cell_right];

        % 对合并后的信号进行排序
        sorted_cells = sort(cell_all);

        % 选择排序后的中位数作为背景噪声估计
        Z = sorted_cells(floor(length(sorted_cells)/2));

        % 计算目标检测阈值
        XT(1, i - N/2 - pro_N/2) = Z * alpha;
    end
end
