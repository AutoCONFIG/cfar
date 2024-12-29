%%  删选均值恒虚警算法
function [index, XT] = cfar_cm(xc, N, pro_N, PAD)
    % xc: 输入信号
    % N: 参考单元总数（包括测试单元两侧）
    % pro_N: 参考单元的偏移量
    % PAD: 阈值计算的系数（与虚警概率相关）

    % 预定义 index 和 XT
    index = 1 + N/2 + pro_N/2 : length(xc) - N/2 - pro_N/2;
    XT = zeros(1, length(index));

    % 动态计算去除的最大 M 个参考单元数量
    M = round(N / 4); % 可以调整为 N 的比例或其他合适值

    for i = index
        % 获取参考单元（去除测试单元）
        cell_left = xc(1, i - N/2 - pro_N/2 : i - pro_N/2 - 1);
        cell_right = xc(1, i + pro_N/2 + 1 : i + N/2 + pro_N/2);
        
        % 合并参考单元
        ref_cells = [cell_left, cell_right];

        % 排序参考单元，去掉功率最高的 M 个单元
        sorted_ref = sort(ref_cells, 'descend');
        
        % 动态调整去除最大值的策略
        censored_ref = sorted_ref(M + 1 : end);  % 去掉最大 M 个单元

        % 计算剩余参考单元的平均功率作为干扰功率估计
        sigma_w2_hat = mean(censored_ref);
        
        % 可以添加加权平均来增强鲁棒性
        % 加权平均：权重可以根据信号特性自定义，这里简单使用相等权重
        weights = ones(1, length(censored_ref));  % 这里可以选择其他加权方法
        weighted_sigma_w2_hat = sum(censored_ref .* weights) / sum(weights);
        
        % 计算阈值
        threshold = weighted_sigma_w2_hat * PAD;

        % 测试单元与阈值比较
        XT(1, i - N/2 - pro_N/2) = threshold;
    end
end
