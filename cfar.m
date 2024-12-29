function varargout = cfar(varargin)
%   CFAR 用于 cfar.fig 的 MATLAB 代码文件
%
%   CFAR（函数）单独调用时，会创建一个新的 CFAR（相关界面、对象或实例等，具体依其应用场景而定），
%   或者唤起已存在的单例（singleton，即唯一实例）。
%
%   “H = CFAR” 这种调用方式会返回一个新的 CFAR（相关界面、对象等，需结合具体应用场景来明确）的
%   句柄，或者返回已存在的单例（singleton，唯一实例）的句柄。
%
%   “CFAR('属性','值',...)”这种调用形式会使用给定的属性-值对来创建一个新的CFAR（相关对象等）。
%   未被识别的属性会通过可变输入参数 `varargin` 传递给 `cfar_OpeningFcn` 函数。当存在已有的
%   单例（singleton，唯一实例）时，这种调用语法会产生一个警告。 
%
%   “CFAR('回调函数名')”以及“CFAR('回调函数名',hObject,...)”这两种调用方式会调用在CFAR.M文
%   件中名为“回调函数名”的本地函数，并传入给定的输入参数。
%
%   *查看GUIDE（图形用户界面开发环境）工具菜单中的“GUI选项”。选择“只允许运行一个实例（单例）”选项。
%
%   另请参阅：GUIDE（图形用户界面开发环境）、GUIDATA（用于处理图形用户界面数据相关操作的函数）、
%   GUIHANDLES（用于获取图形用户界面对象句柄相关操作的函数）。
%
%   编辑上述文本以修改针对“cfar”的帮助响应内容。
%
%   Last Modified by GUIDE v2.5 12-May-2020 18:48:44
%
%   开始初始化代码 - 请不要修改
    % 设置为1，GUI 应用采用单例模式，即只能运行一个界面
    gui_Singleton = 1; 

    % 初始化gui_State结构体，该结构体包含：
    % gui_Name, 设置GUI应用的名称。 值：mfilename，用于获取当前文件名称（cfar.m）
    % gui_Singleton，设置单例模式。 值：gui_Singleton = 1，表示以单例模式运行
    % gui_OpeningFcn，
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @cfar_OpeningFcn, ...
                       'gui_OutputFcn',  @cfar_OutputFcn, ...
                       'gui_LayoutFcn',  [], ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
%   结束初始化代码 - 请不要修改


% --- 在 cfar 界面显示之前执行的操作
function cfar_OpeningFcn(hObject, eventdata, handles, varargin)
%   该函数没有输出参数，参见 OutputFcn。
%   hObject    指向界面的句柄
%   eventdata  保留字段，未来版本的 MATLAB 中定义
%   handles    包含句柄和用户数据的结构体（参见 GUIDATA）
%   varargin   未识别的命令行属性名/属性值对（参见 VARARGIN）

    % 选择 cfar 的默认命令行输出
    handles.output = hObject;

    % 更新 handles 结构体
    guidata(hObject, handles);

%   UIWAIT 使 cfar 等待用户响应（参见 UIRESUME）
%   uiwait(handles.figure1);


% --- 此函数的输出返回到命令行
function varargout = cfar_OutputFcn(hObject, eventdata, handles)
%   varargout  返回输出参数的元胞数组（参见 VARARGOUT）
%   hObject    界面句柄
%   eventdata  保留字段，未来版本 MATLAB 中定义
%   handles    包含句柄和用户数据的结构体（参见 GUIDATA）

    % 从 handles 结构体获取默认的命令行输出
    varargout{1} = handles.output;


% --- 按下 pushbutton1 时执行的操作
function pushbutton1_Callback(hObject, eventdata, handles)
%   hObject    指向 pushbutton1 的句柄（参见 GCBO）
%   eventdata  保留字段，未来版本 MATLAB 中定义
%   handles    包含句柄和用户数据的结构体（参见 GUIDATA）

    global noise_p;
    global xc;

    % 在 axes5 中绘制图像
    axes(handles.axes5);

    % 如果选择了 radiobutton4
    if get(handles.radiobutton4, 'value')
        % 获取形状参数
        shape1 = get(handles.edit9, 'string');     
        shape1 = str2double(shape1);
        shape2 = get(handles.edit10, 'string');     
        shape2 = str2double(shape2);

        % 获取噪声 dB 值
        db1 = get(handles.edit1, 'string');     
        db1 = str2double(db1);
        db2 = get(handles.edit8, 'string');     
        db2 = str2double(db2);

        % 形成形状参数数组
        shape = [shape1, shape2];

        % 获取方差
        variance = get(handles.edit2, 'string');
        variance = str2double(variance);

        % 将噪声 dB 转为噪声功率
        noise_db = [db1, db2];
        noise_p = 10.^(noise_db ./ 10);

        % 显示输出
        show_out = 1;
        [xc] = env_edge(variance, shape, noise_db, show_out);
    end

    % 如果选择了 radiobutton3
    if get(handles.radiobutton3, 'value')
        % 获取形状参数
        shape1 = get(handles.edit10, 'string');     
        shape1 = str2double(shape1);

        % 获取方差
        variance = get(handles.edit2, 'string');
        variance = str2double(variance);

        % 获取噪声 dB 值
        db1 = get(handles.edit1, 'string');     
        db1 = str2double(db1);

        % 将噪声 dB 转为噪声功率
        noise_p = 10.^(db1 ./ 10);

        % 显示输出
        show_out = 1;
        [xc] = env_uniform(variance, shape1, db1, show_out);
    end


% --- 当按下 pushbutton2 按钮时执行的回调函数
function pushbutton2_Callback(hObject, eventdata, handles)
%   hObject    指向 pushbutton2 按钮的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

    global noise_p;
    global xc;

    % 判断 radiobutton3 和 radiobutton1 同时被选中的情况
    if get(handles.radiobutton3,'value') && get(handles.radiobutton1,'value')
        % 获取 edit4 控件中的字符串内容，并转换为双精度数值
        SNR1 = get(handles.edit4,'string');
        SNR1 = str2double(SNR1);

        % 根据公式计算 signal1_p 的值
        signal1_p = 10.^(SNR1./10).*noise_p;

        % 获取 edit15 控件中的字符串内容，并转换为双精度数值
        des1 = get(handles.edit15,'string');
        des1 = str2double(des1);

        % 给 xc 矩阵赋值
        xc(1, des1) = signal1_p;

        % 获取 edit13 控件中的字符串内容，并转换为双精度数值
        N = get(handles.edit13,'string');
        N = str2double(N);

        % 获取 edit7 控件中的字符串内容，并转换为双精度数值
        pro_N = get(handles.edit7,'string');
        pro_N = str2double(pro_N);

        % 获取 edit14 控件中的字符串内容，并转换为双精度数值
        PAD = get(handles.edit14,'string');
        PAD = str2double(PAD);
        
        % 计算 k 的值
        k = 2.*N./4;

        % 判断 radiobutton5 和 radiobutton1 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton5,'value') && get(handles.radiobutton1,'value')
            [ index, XT ] = cfar_ac( xc, N, pro_N, PAD);
        end
        
        % 判断 radiobutton6 和 radiobutton1 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton6,'value') && get(handles.radiobutton1,'value')
            [ index, XT ] = cfar_go( xc, N, pro_N, PAD);
        end
        
        % 判断 radiobutton7 和 radiobutton1 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton7,'value') && get(handles.radiobutton1,'value')
            [ index, XT ] = cfar_os( abs(xc), N, k, pro_N, PAD);
        end
        
        % 判断 radiobutton8 和 radiobutton1 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton8,'value') && get(handles.radiobutton1,'value')
            [ index, XT ] = cfar_so( xc, N, pro_N, PAD);
        end

    end

    % 判断 radiobutton4 和 radiobutton1 同时被选中的情况
    if get(handles.radiobutton4,'value') && get(handles.radiobutton1,'value')
        % 获取 edit4 控件中的字符串内容，并转换为双精度数值
        SNR1 = get(handles.edit4,'string');
        SNR1 = str2double(SNR1);

        % 根据公式计算 signal1_p 的值，此处使用 noise_p(1,end)
        signal1_p = 10.^(SNR1./10).*noise_p(1, end);

        % 获取 edit15 控件中的字符串内容，并转换为双精度数值
        des1 = get(handles.edit15,'string');
        des1 = str2double(des1);

        % 给 xc 矩阵赋值
        xc(1, des1) = signal1_p;

        % 获取 edit13 控件中的字符串内容，并转换为双精度数值
        N = get(handles.edit13,'string');
        N = str2double(N);

        % 获取 edit7 控件中的字符串内容，并转换为双精度数值
        pro_N = get(handles.edit7,'string');
        pro_N = str2double(pro_N);

        % 获取 edit14 控件中的字符串内容，并转换为双精度数值
        PAD = get(handles.edit14,'string');
        PAD = str2double(PAD);

        % 计算 k 的值
        k = 2.*N./4;

        % 判断 radiobutton5 和 radiobutton1 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton5,'value') && get(handles.radiobutton1,'value')
            [ index, XT ] = cfar_ac( xc, N, pro_N, PAD);
        end

        % 判断 radiobutton6 和 radiobutton1 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton6,'value') && get(handles.radiobutton1,'value')
            [ index, XT ] = cfar_go( xc, N, pro_N, PAD);
        end

        % 判断 radiobutton7 和 radiobutton1 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton7,'value') && get(handles.radiobutton1,'value')
            [ index, XT ] = cfar_os( abs(xc), N, k, pro_N, PAD);
        end

        % 判断 radiobutton8 和 radiobutton1 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton8,'value') && get(handles.radiobutton1,'value')
            [ index, XT ] = cfar_so( xc, N, pro_N, PAD);
        end
    end
    
    % 判断 radiobutton3 和 radiobutton2 同时被选中的情况
    if get(handles.radiobutton3,'value') && get(handles.radiobutton2,'value')
        % 获取多个编辑框控件中的字符串内容，并转换为双精度数值
        SNR1 = get(handles.edit4,'string');
        SNR1 = str2double(SNR1);
        SNR2 = get(handles.edit5,'string');
        SNR2 = str2double(SNR2);
        SNR3 = get(handles.edit11,'string');
        SNR3 = str2double(SNR3);
        SNR4 = get(handles.edit12,'string');
        SNR4 = str2double(SNR4);

        % 根据公式分别计算多个 signal_p 的值
        signal1_p = 10.^(SNR1./10).*noise_p;
        signal2_p = 10.^(SNR2./10).*noise_p;
        signal3_p = 10.^(SNR3./10).*noise_p;
        signal4_p = 10.^(SNR4./10).*noise_p;

        % 获取多个编辑框控件中的字符串内容，并转换为双精度数值
        des1 = get(handles.edit15,'string');
        des1 = str2double(des1);
        des2 = get(handles.edit16,'string');
        des2 = str2double(des2);
        des3 = get(handles.edit17,'string');
        des3 = str2double(des3);
        des4 = get(handles.edit18,'string');
        des4 = str2double(des4);

        % 给 xc 矩阵的不同位置赋值
        xc(1, des1) = signal1_p;
        xc(1, des2) = signal2_p;
        xc(1, des3) = signal3_p;
        xc(1, des4) = signal4_p;

        % 获取多个编辑框控件中的字符串内容，并转换为双精度数值
        N = get(handles.edit13,'string');
        N = str2double(N);
        pro_N = get(handles.edit7,'string');
        pro_N = str2double(pro_N);
        PAD = get(handles.edit14,'string');
        PAD = str2double(PAD);
        k = 2.*N./4;

        % 判断 radiobutton5 和 radiobutton2 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton5,'value') && get(handles.radiobutton2,'value')
            [ index, XT ] = cfar_ac( xc, N, pro_N, PAD);
        end

        % 判断 radiobutton6 和 radiobutton2 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton6,'value') && get(handles.radiobutton2,'value')
            [ index, XT ] = cfar_go( xc, N, pro_N, PAD);
        end

        % 判断 radiobutton7 和 radiobutton2 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton7,'value') && get(handles.radiobutton2,'value')
            [ index, XT ] = cfar_os( abs(xc), N, k, pro_N, PAD);
        end

        % 判断 radiobutton8 和 radiobutton2 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton8,'value') && get(handles.radiobutton2,'value')
            [ index, XT ] = cfar_so( xc, N, pro_N, PAD);
        end
    
    end

    % 判断 radiobutton4 和 radiobutton2 同时被选中的情况
    if get(handles.radiobutton4,'value') && get(handles.radiobutton2,'value')
        % 获取多个编辑框控件中的字符串内容，并转换为双精度数值
        SNR1 = get(handles.edit4,'string');
        SNR1 = str2double(SNR1);
        SNR2 = get(handles.edit5,'string');
        SNR2 = str2double(SNR2);
        SNR3 = get(handles.edit11,'string');
        SNR3 = str2double(SNR3);
        SNR4 = get(handles.edit12,'string');
        SNR4 = str2double(SNR4);
        SNR5 = get(handles.edit19,'string');
        SNR5 = str2double(SNR5);
        SNR6 = get(handles.edit20,'string');
        SNR6 = str2double(SNR6);

        % 根据公式分别计算多个 signal_p 的值，此处使用 noise_p(1,end)
        signal1_p = 10.^(SNR1./10).*noise_p(1, end);
        signal2_p = 10.^(SNR2./10).*noise_p(1, end);
        signal3_p = 10.^(SNR3./10).*noise_p(1, end);
        signal4_p = 10.^(SNR4./10).*noise_p(1, end);
        signal5_p = 10.^(SNR4./10).*noise_p(1, end);
        signal6_p = 10.^(SNR4./10).*noise_p(1, end);

        % 获取多个编辑框控件中的字符串内容，并转换为双精度数值
        des1 = get(handles.edit15,'string');
        des1 = str2double(des1);
        des2 = get(handles.edit16,'string');
        des2 = str2double(des2);
        des3 = get(handles.edit17,'string');
        des3 = str2double(des3);
        des4 = get(handles.edit18,'string');
        des4 = str2double(des4);
        des5 = get(handles.edit21,'string');
        des5 = str2double(des5);
        des6 = get(handles.edit22,'string');
        des6 = str2double(des6);

        % 给 xc 矩阵的不同位置赋值
        xc(1, des1) = signal1_p;
        xc(1, des2) = signal2_p;
        xc(1, des3) = signal3_p;
        xc(1, des4) = signal4_p;
        xc(1, des5) = signal5_p;
        xc(1, des6) = signal6_p;

        % 获取多个编辑框控件中的字符串内容，并转换为双精度数值
        N = get(handles.edit13,'string');
        N = str2double(N);
        pro_N = get(handles.edit7,'string');
        pro_N = str2double(pro_N);
        PAD = get(handles.edit14,'string');
        PAD = str2double(PAD);
        k = 2.*N./4;

        % 判断 radiobutton5 和 radiobutton2 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton5,'value') && get(handles.radiobutton2,'value')
            [ index, XT ] = cfar_ac( xc, N, pro_N, PAD);
        end

        % 判断 radiobutton6 和 radiobutton2 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton6,'value') && get(handles.radiobutton2,'value')
            [ index, XT ] = cfar_go( xc, N, pro_N, PAD);
        end

        % 判断 radiobutton7 和 radiobutton2 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton7,'value') && get(handles.radiobutton2,'value')
            [ index, XT ] = cfar_os( abs(xc), N, k, pro_N, PAD);
        end

        % 判断 radiobutton8 和 radiobutton2 同时被选中的情况，并执行相应函数
        if get(handles.radiobutton8,'value') && get(handles.radiobutton2,'value')
            [ index, XT ] = cfar_so( xc, N, pro_N, PAD);
        end
        
    end
    
    % 将当前坐标轴切换到 handles.axes2
    axes(handles.axes2);
    % 清除当前坐标轴并重置其属性
    cla reset

    % 判断 radiobutton1 被选中的情况
    if get(handles.radiobutton1,'value')
        % 绘制相关图形，先绘制以 10 为底的对数图形，保持图形状态
        plot(10.*log(abs(xc))./log(10)), hold on;
        % 绘制特定点的图形，以红色星号标记，设置线宽，并保持图形状态
        plot(des1, 10.*log(abs(xc(1, des1)))./log(10),'r*',  'LineWidth', 10), hold on;
        % 绘制另一个图形，以绿色显示
        plot(index, 10.*log(abs(XT))./log(10),'g');

        % 添加图例说明
        legend('回波','目标','检测门限')
    end

    % 判断 radiobutton2 和 radiobutton3 同时被选中的情况
    if get(handles.radiobutton2,'value') && get(handles.radiobutton3,'value')
        % 绘制相关图形，先绘制以 10 为底的对数图形，保持图形状态
        plot(10.*log(abs(xc))./log(10)), hold on;
        % 绘制多个特定点的图形，以红色星号标记，设置线宽，并保持图形状态
        plot(des1, 10.*log(abs(xc(1, des1)))./log(10),'r*',  'LineWidth', 10), hold on;
        plot(des2, 10.*log(abs(xc(1, des2)))./log(10),'r*',  'LineWidth', 10), hold on;
        plot(des3, 10.*log(abs(xc(1, des3)))./log(10),'r*',  'LineWidth', 10), hold on;
        plot(des4, 10.*log(abs(xc(1, des4)))./log(10),'r*',  'LineWidth', 10), hold on;
        % 绘制另一个图形，以绿色显示
        plot(index, 10.*log(abs(XT))./log(10),'g');

        % 添加图例说明
        legend('回波','目标','目标','目标','目标','检测门限')
    end

    % 判断 radiobutton2 和 radiobutton4 同时被选中的情况
    if get(handles.radiobutton2,'value') && get(handles.radiobutton4,'value')
        % 绘制相关图形，先绘制以 10 为底的对数图形，并保持图形状态
        plot(10.*log(abs(xc))./log(10)), hold on;
        % 绘制多个特定点的图形，以不同颜色星号标记，设置线宽，并保持图形状态
        plot(des1, 10.*log(abs(xc(1, des1)))./log(10),'r*',  'LineWidth', 10), hold on;
        plot(des2, 10.*log(abs(xc(1, des2)))./log(10),'r*',  'LineWidth', 10), hold on;
        plot(des3, 10.*log(abs(xc(1, des3)))./log(10),'r*',  'LineWidth', 10), hold on;
        plot(des4, 10.*log(abs(xc(1, des4)))./log(10),'r*',  'LineWidth', 10), hold on;
        plot(des5, 10.*log(abs(xc(1, des5)))./log(10),'y*',  'LineWidth', 10), hold on;
        plot(des6, 10.*log(abs(xc(1, des6)))./log(10),'b*',  'LineWidth', 10), hold on;
        % 绘制另一个图形，以绿色显示
        plot(index, 10.*log(abs(XT))./log(10),'g');

        % 添加图例说明，对各图形代表的含义进行标注
        legend('回波','目标','目标','目标','目标','杂波边缘目标','杂波内目标','检测门限')
    end


% --- 当 edit1 控件被操作（例如内容改变等）时执行的回调函数
function edit1_Callback(hObject, eventdata, handles)
%   hObject    指向 edit1 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. get(hObject,'String') 函数可获取 edit1 控件中的内容，返回值为文本格式。
%   2. str2double(get(hObject,'String')) 函数可将 edit1 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成且设置好所有属性后执行的函数
function edit1_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit1 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始时为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常默认具有白色背景。
%   可通过 ISPC 和 COMPUTER 相关判断来进一步确认（此处 ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件，将 edit1 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit2 控件被操作（例如内容改变等）时执行的回调函数
function edit2_Callback(hObject, eventdata, handles)
%   hObject    指向 edit2 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. get(hObject,'String') 函数可获取 edit2 控件中的内容，返回值为文本格式。
%   2. str2double(get(hObject,'String')) 函数可将 edit2 控件中的内容转换为双精度数值格式。


% --- 在 edit2 对象创建完成，并设置好所有属性之后执行的函数
function edit2_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit2 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit2 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit4 控件被操作（例如内容改变等情况）时执行的回调函数
function edit4_Callback(hObject, eventdata, handles)
%   hObject    指向 edit4 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit4 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit4 控件中的内容转换为双精度数值格式。


% --- 在 edit4 对象创建完成，并设置好所有属性之后执行的函数
function edit4_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit4 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit4 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit5 控件被操作（例如内容改变等情况）时执行的回调函数
function edit5_Callback(hObject, eventdata, handles)
%   hObject    指向 edit5 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit5 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit5 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit5_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit5 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit5 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit7 控件被操作（例如内容改变等情况）时执行的回调函数
function edit7_Callback(hObject, eventdata, handles)
%   hObject    指向 edit7 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit7 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit7 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit7_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit7 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit7 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit8 控件被操作（例如内容改变等情况）时执行的回调函数
function edit8_Callback(hObject, eventdata, handles)
%   hObject    指向 edit8 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit8 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit8 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit8_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit8 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit8 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit9 控件被操作（例如内容改变等情况）时执行的回调函数
function edit9_Callback(hObject, eventdata, handles)
%   hObject    指向 edit9 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit9 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit9 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit9_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit9 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit9 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit10 控件被操作（例如内容改变等情况）时执行的回调函数
function edit10_Callback(hObject, eventdata, handles)
%   hObject    指向 edit10 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit10 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit10 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit10_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit10 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit10 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit11 控件被操作（例如内容改变等情况）时执行的回调函数
function edit11_Callback(hObject, eventdata, handles)
%   hObject    指向 edit11 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit11 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit11 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit11_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit11 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit11 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit12 控件被操作（例如内容改变等情况）时执行的回调函数
function edit12_Callback(hObject, eventdata, handles)
%   hObject    指向 edit12 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit12 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit12 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit12_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit12 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit12 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit13 控件被操作（例如内容改变等情况）时执行的回调函数
function edit13_Callback(hObject, eventdata, handles)
%   hObject    指向 edit13 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit13 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit13 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit13_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit13 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit13 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit14 控件被操作（例如内容改变等情况）时执行的回调函数
function edit14_Callback(hObject, eventdata, handles)
%   hObject    指向 edit14 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit14 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit14 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit14_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit14 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit14 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 radiobutton5 按钮被按下时执行的回调函数
function radiobutton5_Callback(hObject, eventdata, handles)
%   hObject    指向 radiobutton5 按钮的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：使用 get(hObject,'Value') 函数可获取 radiobutton5 按钮的切换状态（选中或未选中）


% --- 当 radiobutton6 按钮被按下时执行的回调函数
function radiobutton6_Callback(hObject, eventdata, handles)
%   hObject    指向 radiobutton6 按钮的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：使用 get(hObject,'Value') 函数可获取 radiobutton6 按钮的切换状态（选中或未选中）


% --- 当 radiobutton7 按钮被按下时执行的回调函数
function radiobutton7_Callback(hObject, eventdata, handles)
%   hObject    指向 radiobutton7 按钮的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：使用 get(hObject,'Value') 函数可获取 radiobutton7 按钮的切换状态（选中或未选中）


% --- 当 radiobutton8 按钮被按下时执行的回调函数
function radiobutton8_Callback(hObject, eventdata, handles)
%   hObject    指向 radiobutton8 按钮的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：使用 get(hObject,'Value') 函数可获取 radiobutton8 按钮的切换状态（选中或未选中）


% --- 当 radiobutton9 按钮被按下时执行的回调函数
function radiobutton9_Callback(hObject, eventdata, handles)
%   hObject    指向 radiobutton9 按钮的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户 data 的结构体（详见 GUIDATA）

%   提示：使用 get(hObject,'Value') 函数可获取 radiobutton9 按钮的切换状态（选中或未选中）


% --- 当 radiobutton4 按钮被按下时执行的回调函数
function radiobutton4_Callback(hObject, eventdata, handles)
%   hObject    指向 radiobutton4 按钮的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：使用 get(hObject,'Value') 函数可获取 radiobutton4 按钮的切换状态（选中或未选中）
    if get(handles.radiobutton4,'value')
        % 如果 radiobutton4 按钮被选中，则将 edit1 控件设置为可用状态
        set(handles.edit1,'enable','on')
        % 如果 radiobutton4 按钮被选中，则将 edit9 控件设置为可用状态
        set(handles.edit9,'enable','on')
    end

% --- 当 radiobutton3 按钮被按下时执行的回调函数
function radiobutton3_Callback(hObject, eventdata, handles)
%   hObject    指向 radiobutton3 按钮的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：使用 get(hObject,'Value') 函数可获取 radiobutton3 按钮的切换状态（选中或未选中）
    if get(handles.radiobutton3,'value')
        % 如果 radiobutton3 按钮被选中，则将 edit1 控件设置为不可用状态
        set(handles.edit1,'enable','off')
        % 如果 radiobutton3 按钮被选中，则将 edit9 控件设置为不可用状态
        set(handles.edit9,'enable','off')
    end


% --- 当 radiobutton1 按钮被按下时执行的回调函数
function radiobutton1_Callback(hObject, eventdata, handles)
%   hObject    指向 radiobutton1 按钮的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：使用 get(hObject,'Value') 函数可获取 radiobutton1 按钮的切换状态（即是否被选中）
    if get(handles.radiobutton1,'value')
        % 如果 radiobutton1 按钮被选中，将 edit5 控件设置为不可用状态
        set(handles.edit5,'enable','off');
        % 如果 radiobutton1 按钮被选中，将 edit11 控件设置为不可用状态
        set(handles.edit11,'enable','off');
        % 如果 radiobutton1 按钮被选中，将 edit12 控件设置为不可用状态
        set(handles.edit12,'enable','off');
        % 如果 radiobutton1 按钮被选中，将 edit19 控件设置为不可用状态
        set(handles.edit19,'enable','off');
        % 如果 radiobutton1 按钮被选中，将 edit20 控件设置为不可用状态
        set(handles.edit20,'enable','off');
        % 如果 radiobutton1 按钮被选中，将 edit16 控件设置为不可用状态
        set(handles.edit16,'enable','off');
        % 如果 radiobutton1 按钮被选中，将 edit17 控件设置为不可用状态
        set(handles.edit17,'enable','off');
        % 如果 radiobutton1 按钮被选中，将 edit18 控件设置为不可用状态
        set(handles.edit18,'enable','off');
        % 如果 radiobutton1 按钮被选中，将 edit21 控件设置为不可用状态
        set(handles.edit21,'enable','off');
        % 如果 radiobutton1 按钮被选中，将 edit22 控件设置为不可用状态
        set(handles.edit22,'enable','off');
    end


% --- 当 radiobutton2 按钮被按下时执行的回调函数
function radiobutton2_Callback(hObject, eventdata, handles)
%   hObject    指向 radiobutton2 按钮的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：使用 get(hObject,'Value') 函数可获取 radiobutton2 按钮的切换状态（即是否被选中）
    if get(handles.radiobutton2,'value')
        % 如果 radiobutton2 按钮被选中，将 edit5 控件设置为可用状态
        set(handles.edit5,'enable','on');
        % 如果 radiobutton2 按钮被选中，将 edit11 控件设置为可用状态
        set(handles.edit11,'enable','on');
        % 如果 radiobutton2 按钮被选中，将 edit12 控件设置为可用状态
        set(handles.edit12,'enable','on');
        % 如果 radiobutton2 按钮被选中，将 edit19 控件设置为可用状态
        set(handles.edit19,'enable','on');
        % 如果 radiobutton2 按钮被选中，将 edit20 控件设置为可用状态
        set(handles.edit20,'enable','on');
        % 如果 radiobutton2 按钮被选中，将 edit16 控件设置为可用状态
        set(handles.edit16,'enable','on');
        % 如果 radiobutton2 按钮被选中，将 edit17 控件设置为可用状态
        set(handles.edit17,'enable','on');
        % 如果 radiobutton2 按钮被选中，将 edit18 控件设置为可用状态
        set(handles.edit18,'enable','on');
        % 如果 radiobutton2 按钮被选中，将 edit21 控件设置为可用状态
        set(handles.edit21,'enable','on');
        % 如果 radiobutton2 按钮被选中，将 edit22 控件设置为可用状态
        set(handles.edit22,'enable','on');
    end


% --- 当 pushbutton3 按钮被按下时执行的回调函数
function pushbutton3_Callback(hObject, eventdata, handles)
%   hObject    指向 pushbutton3 按钮的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

    % 新建一个不可见的图形窗口（figure）
    new_f_handle = figure('visible','off');           
    % 将 GUI 界面内 Tag 为 axes5 的坐标轴对象复制到新建的不可见图形窗口中，axes1 应该是原本在 GUI 界面内要保存图线所在的坐标轴
    new_axes = copyobj(handles.axes5, new_f_handle);   
    % 设置复制后的坐标轴在新图形窗口中的位置和大小等属性，进行图线缩放
    set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);    
    % 弹出文件保存对话框，让用户选择保存的文件名、路径以及文件格式（支持的格式如.png、.bmp、.jpg、.eps 等）
    [filename pathname fileindex] = uiputfile({'*.png';'*.bmp';'*.jpg';'*.eps';},'图片保存为');

    % 判断用户是否点击了“取消”按钮或者关闭了对话框，如果没有（即 filename 不为 0），则执行以下保存操作
    if  filename ~= 0         %   未点“取消”按钮或未关闭
        % 将路径和文件名拼接成完整的文件路径
        file = strcat(pathname, filename);
        % 根据用户选择的文件格式索引（fileindex）来决定以何种格式保存图像
        switch fileindex    %   根据不同的选择保存为不同的类型        
            case 1
                % 使用 print 函数将新图形窗口中的图像以.png 格式保存到指定文件中，两种写法效果一样（此处给出了两种示例写法）
                print(new_f_handle,'-dpng',file);% print(new_f_handle,'-dpng',filename);效果一样，将图像打印到指定文件中
                % 在命令行窗口输出提示信息，告知用户图像已保存的路径
                fprintf('>>已保存到：%s\n',file);
            case 2
                print(new_f_handle,'-dbmp',file);
                fprintf('>>已保存到：%s\n',file);
            case 3
                print(new_f_handle,'-djpeg',file);
                fprintf('>>已保存到：%s\n',file);
            case 4
                print(new_f_handle,'-depsc',file);
                fprintf('>>已保存到：%s\n',file);
        end 
        % 弹出消息框，提示用户图线已成功保存
        msgbox('          图线已成功保存！','完成！');
    end


% --- 当 pushbutton4 按钮被按下时执行的回调函数
function pushbutton4_Callback(hObject, eventdata, handles)
%   hObject    指向 pushbutton4 按钮的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

    % 新建一个不可见的图形窗口（figure）
    new_f_handle = figure('visible','off'); 
    % 将 GUI 界面内 Tag 为 axes2 的坐标轴对象复制到新建的不可见图形窗口中，axes1 应该是原本在 GUI 界面内要保存图线所在的坐标轴
    new_axes = copyobj(handles.axes2, new_f_handle); 
    % 设置复制后的坐标轴在新图形窗口中的位置和大小等属性，进行图线缩放
    set(new_axes,'Units','normalized','Position',[0.1 0.1 0.8 0.8]);%将图线缩放
    % 弹出文件保存对话框，让用户选择保存的文件名、路径以及文件格式（支持的格式如.png、.bmp、.jpg、.eps 等）
    [filename pathname fileindex] = uiputfile({'*.png';'*.bmp';'*.jpg';'*.eps';},'图片保存为');

    % 判断用户是否点击了“取消”按钮或者关闭了对话框，如果没有（即 filename 不为 0），则执行以下保存操作
    if  filename ~= 0%未点“取消”按钮或未关闭
        % 将路径和文件名拼接成完整的文件路径
        file = strcat(pathname, filename);
        % 根据用户选择的文件格式索引（fileindex）来决定以何种格式保存图像
        switch fileindex
            case 1
                % 使用 print 函数将新图形窗口中的图像以.png 格式保存到指定文件中。print(new_f_handle,'-dpng',filename);写法效果一样，将图像打印到指定文件中
                print(new_f_handle,'-dpng',file);
                % 在命令行窗口输出提示信息，告知用户图像已保存的路径
                fprintf('>>已保存到：%s\n',file);
            case 2
                print(new_f_handle,'-dbmp',file);
                fprintf('>>已保存到：%s\n',file);
            case 3
                print(new_f_handle,'-djpeg',file);
                fprintf('>>已保存到：%s\n',file);
            case 4
                print(new_f_handle,'-depsc',file);
                fprintf('>>已保存到：%s\n',file);
        end 
        % 弹出消息框，提示用户图线已成功保存
        msgbox('          图线已成功保存！','完成！');
    end


% --- 当 edit15 控件被操作（例如内容改变等情况）时执行的回调函数
function edit15_Callback(hObject, eventdata, handles)
%   hObject    指向 edit15 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit15 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit15 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit15_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit15 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit15 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit16 控件被操作（例如内容改变等情况）时执行的回调函数
function edit16_Callback(hObject, eventdata, handles)
%   hObject    指向 edit16 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit16 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit16 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit16_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit16 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit16 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit17 控件被操作（例如内容改变等情况）时执行的回调函数
function edit17_Callback(hObject, eventdata, handles)
%   hObject    指向 edit17 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit17 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit17 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit17_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit17 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit17 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit18 控件被操作（例如内容改变等情况）时执行的回调函数
function edit18_Callback(hObject, eventdata, handles)
%   hObject    指向 edit18 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit18 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit18 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit18_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit18 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit18 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit19 控件被操作（例如内容改变等情况）时执行的回调函数
function edit19_Callback(hObject, eventdata, handles)
%   hObject    指向 edit19 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户数据的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit19 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit19 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit19_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit19 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit19 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit20 控件被操作（例如内容改变等情况）时执行的回调函数
function edit20_Callback(hObject, eventdata, handles)
%   hObject    指向 edit20 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户 data 的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit20 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit20 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit20_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit20 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit20 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit21 控件被操作（例如内容改变等情况）时执行的回调函数
function edit21_Callback(hObject, eventdata, handles)
%   hObject    指向 edit21 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户 data 的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit21 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit21 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit21_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit21 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit21 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end


% --- 当 edit22 控件被操作（例如内容改变等情况）时执行的回调函数
function edit22_Callback(hObject, eventdata, handles)
%   hObject    指向 edit22 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    包含句柄和用户 data 的结构体（详见 GUIDATA）

%   提示：
%   1. 使用 get(hObject,'String') 函数可获取 edit22 控件中的内容，返回值为文本格式。
%   2. 使用 str2double(get(hObject,'String')) 函数可将 edit22 控件中的内容转换为双精度数值格式。


% --- 在对象创建完成，并设置好所有属性之后执行的函数
function edit22_CreateFcn(hObject, eventdata, handles)
%   hObject    指向 edit22 控件的句柄（详见 GCBO）
%   eventdata  预留参数，将在 MATLAB 的未来版本中定义
%   handles    初始为空，在所有创建函数（CreateFcns）调用完成后才会创建句柄相关内容

%   提示：在 Windows 操作系统下，编辑控件（edit controls）通常具有白色背景。
%   可查看 ISPC 和 COMPUTER 相关内容来进一步确认（ISPC 用于判断是否为 Windows 系统，COMPUTER 用于获取系统相关信息）。
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        % 如果满足上述条件（是 Windows 系统且当前控件背景色与默认背景色一致），则将 edit22 控件的背景颜色设置为白色
        set(hObject,'BackgroundColor','white');
    end