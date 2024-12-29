function plot_cfar_subplots(xc, XT_list, index_list, targets, N, algorithm_names)
    % xc: 原始信号数据
    % XT_list: 存储所有算法的检测结果（每个算法的 XT）
    % index_list: 存储所有算法的检测位置索引（每个算法的 index）
    % targets: 包含目标位置和颜色的数组
    % N: 滤波器窗口大小
    % algorithm_names: 存储算法名称的单元格数组
    
    % 子图的数量
    num_algorithms = length(algorithm_names);
    
    % 创建一个新的图窗口
    figure;
    
    % 使用 tiledlayout 来调整子图的布局
    t = tiledlayout(3, 3, 'TileSpacing', 'Compact', 'Padding', 'Compact'); % 设置3x3网格布局

    for i = 1:num_algorithms
        % 每个算法的检测结果
        XT = XT_list{i};
        index = index_list{i};
        algorithm_name = algorithm_names{i};
        
        % 创建每个子图
        nexttile;
        
        % 绘制原始信号
        plot(10.*log(abs(xc))./log(10), 'b-', 'DisplayName', 'Original Signal'); hold on;
        
        % 绘制CFAR检测结果
        plot(index, 10.*log(abs(XT))./log(10), 'r-', 'DisplayName', [algorithm_name ' Detection']);
        
        % 绘制每个目标点
        for j = 1:size(targets, 1)
            loc = targets{j, 1};  % 目标位置
            target_color = targets{j, 2};  % 目标颜色
            plot(loc, 10*log(abs(xc(loc)))/log(10), 'o', 'MarkerFaceColor', target_color, ...
                'DisplayName', ['Target ' num2str(j)]);
        end
        
        % 设置图例
        lgd = legend('show');
        lgd.Location = 'best';
        lgd.NumColumns = 2;
        set(lgd, 'Box', 'on');
        
        set(gca, 'FontName', '思源黑体');
        set(gcf, 'DefaultTextFontName', '思源黑体');
        
        % 设置标题和坐标轴标签
        title([algorithm_name ' 算法检测 (滤波器窗口大小 = ' num2str(N) ')']);
        xlabel('目标位置');
        ylabel('信号强度 (dB)');
        grid on;
    end
end
