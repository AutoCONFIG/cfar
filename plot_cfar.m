function plot_cfar(xc, XT, index, targets, N, algorithm_name)
    % xc: 原始信号数据
    % XT: CFAR检测结果
    % index: 检测到的目标位置
    % targets: 包含目标位置和颜色的数组
    % N: 滤波器窗口大小
    % algorithm_name: 用于设置图例标题的算法名称
    
    figure;
    
    % 绘制原始信号
    plot(10.*log(abs(xc))./log(10), 'b-', 'DisplayName', 'Original Signal'); hold on;
    
    % 绘制CFAR检测结果
    plot(index, 10.*log(abs(XT))./log(10), 'r-', 'DisplayName', 'CFAR Detection');
    
    % 绘制每个目标点
    for i = 1:size(targets, 1)
        loc = targets{i, 1};  % 目标位置
        target_color = targets{i, 2};  % 目标颜色
        plot(loc, 10*log(abs(xc(loc)))/log(10), 'o', 'MarkerFaceColor', target_color, ...
            'DisplayName', ['Target ' num2str(i)]);
    end
    
    % 自动调整图例位置，避免遮挡
    lgd = legend('show');  % 显示图例
    lgd.Location = 'best';  % 'best'位置会自动选择一个不遮挡图形的区域
    lgd.NumColumns = 2;  % 如果图例项过多，可以使用多列排列
    set(lgd, 'Box', 'on');  % 去除图例框

    set(gca, 'FontName', '思源黑体');
    set(gcf, 'DefaultTextFontName', '思源黑体');

    % 添加标题和坐标轴标签
    title([algorithm_name '算法检测 (滤波器窗口大小 = ' num2str(N) ')']);
    xlabel('目标位置');
    ylabel('信号强度 (dB)');
    grid on;
end
