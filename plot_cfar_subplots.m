%% plot_cfar_subplots - 绘制多个算法的 CFAR 检测结果和性能指标
% 
% 输入参数：
%   - xc                     : 原始信号数据。
%   - XT_list                : 存储所有算法的检测结果，每个算法的 XT（阈值）。
%   - index_list             : 存储所有算法的检测位置索引，每个算法对应一个 index。
%   - targets                : 包含目标位置和颜色的数组，指示信号中的目标位置。
%   - N                      : 滤波器窗口大小，用于控制 CFAR 滑动窗口的大小。
%   - algorithm_names        : 存储各个算法名称的单元格数组。
%   - TDR_list               : 存储每个算法的真检测率（True Detection Rate）列表。
%   - FAR_list               : 存储每个算法的虚警率（False Alarm Rate）列表。
%   - true_detections_list   : 存储每个算法的真检测目标数列表。
%   - false_alarms_list      : 存储每个算法的虚警目标数列表。
%   - false_alarm_positions_list : 存储每个算法的虚警位置列表（每个算法一个虚警位置数组）。
% 
% 输出：
%   该函数将绘制一个包含多个子图的图形，展示每个算法的检测结果、性能指标以及虚警位置。

function plot_cfar_subplots(xc, XT_list, index_list, targets, N, algorithm_names, TDR_list, FAR_list, true_detections_list, false_alarms_list, false_alarm_positions_list)
    % 子图的数量
    num_algorithms = length(algorithm_names);
    
    % 创建一个新的图窗口
    figure;
    
    % 使用 tiledlayout 来调整子图的布局
    tiledlayout(3, 3, 'TileSpacing', 'Compact', 'Padding', 'Compact'); % 设置3x3网格布局

    for i = 1:num_algorithms
        % 每个算法的检测结果
        XT = XT_list{i};
        index = index_list{i};
        algorithm_name = algorithm_names{i};
        TDR = TDR_list(i);            % 真检测率
        FAR = FAR_list(i);            % 虚警率
        true_detections = true_detections_list(i);  % 真检测目标数
        false_alarms = false_alarms_list(i);        % 虚警目标数
        false_alarm_positions = false_alarm_positions_list{i}; % 当前算法的虚警位置
        
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
        
        % 绘制虚警位置（用黑色圆点表示）
        if ~isempty(false_alarm_positions)
            plot(false_alarm_positions, 10*log(abs(xc(false_alarm_positions)))/log(10), 'ko', 'MarkerFaceColor', 'k', ...
                'MarkerSize', 6, 'DisplayName', 'False Alarms');
        end
        
        % 设置图例
        lgd = legend('show');
        lgd.Location = 'southeast';
        lgd.NumColumns = 2;
        set(lgd, 'Box', 'on');
        
        set(gca, 'FontName', '思源黑体');
        set(gcf, 'DefaultTextFontName', '思源黑体');
        
        % 设置标题和坐标轴标签
        title([algorithm_name ' 算法检测 (参考单元的滑窗大小 = ' num2str(N) ')']);
        xlabel('目标位置');
        ylabel('信号强度 (dB)');
        grid on;
        
        % 创建一个透明的区域来显示性能信息，避免遮挡图像
        hold on;
        
        % 选择一个适合的位置来显示性能指标
        x_position = 0.01;  % x坐标，表示在图形的5%位置，靠近左侧
        y_position = 0.01;  % y坐标，表示从底部开始的5%位置
        
        % 性能指标文本
        performance_text = {
            ['真检测率(TDR):' num2str(TDR, '%.2f')], 
            ['虚警率(FAR):' num2str(FAR, '%.2f')], 
            ['真检测数:' num2str(true_detections)], 
            ['虚警数:' num2str(false_alarms)]
        };
        
        % 动态调整文本位置，避免遮挡
        for j = 1:length(performance_text)
            text(x_position, y_position + (j - 1) * 0.05, performance_text{j}, ...
                'Units', 'normalized', 'FontSize', 10, 'Color', 'black', 'VerticalAlignment', 'bottom');
        end
    end
end
