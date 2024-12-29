%%  删选均值恒虚警算法
function [index, XT] = cfar_cm(xc, N, pro_N, PFA)
    % xc: 输入信号
    % N: 参考单元总数（包括测试单元两侧）
    % pro_N: 参考单元的偏移量
    % PFA: 期望的虚警概率

    % 计算阈值乘数alpha
    alpha = N * ((PFA)^(-1 / N) - 1);

    % 预定义 index 和 XT
    index = 1 + N / 2 + pro_N / 2 : length(xc) - N / 2 - pro_N / 2;
    XT = zeros(1, length(index));

    % 确定要删选的最大 M 个参考单元数量，这里选择四分之一的参考单元数（可根据实际情况调整）
    M = round(N / 4); 

    for i = index
        % 获取参考单元（去除测试单元）
        cell_left = xc(1, i - N / 2 - pro_N / 2 : i - pro_N / 2 - 1);
        cell_right = xc(1, i + pro_N / 2 + 1 : i + N / 2 + pro_N / 2);

        % 合并参考单元
        ref_cells = [cell_left, cell_right];

        % 对参考单元取绝对值（假设信号可能包含负值，根据实际情况可调整）
        ref_cells_abs = abs(ref_cells);

        % 排序参考单元，去掉功率最高的 M 个单元
        [sorted_ref, sorted_indices] = sort(ref_cells_abs, 'descend');
        censored_ref = sorted_ref(M + 1 : end);

        % 计算剩余参考单元的平均功率作为干扰功率估计
        sigma_w2_hat = mean(censored_ref);

        % 计算阈值
        threshold = sigma_w2_hat * alpha;

        % 测试单元与阈值比较
        XT(1, i - N / 2 - pro_N / 2) = threshold;
    end
end