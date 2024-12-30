%% perf_cfar - 评估 CFAR 检测算法的性能
% 输入参数：
%   - xc               : 原始信号。
%   - XT               : CFAR 检测结果，表示每个检测点的阈值。
%   - index            : 需要进行检测的信号位置（即索引位置）。
%   - target_positions : 真实目标的索引位置。
%   - adjacent_window_size : 控制相邻位置的范围，用于避免相邻目标的重复标记，控制相邻目标的检测窗口大小。
% 
% 输出参数：
%   - TDR              : 真检测率（True Detection Rate）。
%   - FAR              : 虚警率（False Alarm Rate）。
%   - true_detections  : 检测到的真实目标数。
%   - false_alarms     : 检测到的虚警数。
%   - false_alarm_positions : 虚警出现的位置索引。

function [TDR, FAR, true_detections, false_alarms, false_alarm_positions] = perf_cfar(xc, XT, index, target_positions, adjacent_window_size)

    % 计数真检测和虚警的数量
    true_detections = 0; 
    false_alarms = 0;
    
    % 获取总的真实目标数量
    total_targets = length(target_positions);
    % 用于记录已经检测过的目标位置
    detected_positions = false(size(xc));
    % 用于保存虚警的位置
    false_alarm_positions = [];
    
    % 遍历每个检测位置
    for i = 1:length(index)
        idx = index(i);

        % 判断 CFAR 输出的值是否有效（大于0且超过 CFAR 阈值）
        if abs(xc(idx)) > XT(i) && XT(i) > 0  % 确保 XT(i) 是有效的检测值
            % 如果当前位置未被检测过，且周围范围内的相邻位置没有其他目标
            if ~detected_positions(idx)
                % 检查前后 `adjacent_window_size` 个位置，避免相邻的值也被判定为目标
                start_idx = max(1, idx - adjacent_window_size); % 防止越界
                end_idx = min(length(xc), idx + adjacent_window_size); % 防止越界
                % 确保前后窗口范围内没有检测过的目标
                if all(~detected_positions(start_idx:end_idx))
                    % 如果是目标位置
                    if ismember(idx, target_positions)
                        true_detections = true_detections + 1;  % 真检测
                        disp(['检测到目标位置', num2str(idx), ', value: ', num2str(abs(xc(idx))), ', Threshold: ', num2str(XT(i))]);
                    else
                        false_alarms = false_alarms + 1;  % 虚警
                        false_alarm_positions = [false_alarm_positions, idx];  % 记录虚警位置
                        disp(['虚警目标位置', num2str(idx), ', value: ', num2str(abs(xc(idx))), ', Threshold: ', num2str(XT(i))]);
                    end
                    % 标记当前检测位置为已检测
                    detected_positions(idx) = true;
                end
            end
        end
    end
    
    % 计算真检测率（True Detection Rate, TDR）和虚警率（False Alarm Rate, FAR）
    TDR = true_detections / total_targets;  % 真检测率
    FAR = false_alarms / length(index);     % 虚警率

end
