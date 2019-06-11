# GPUImageTest
利用GPUImage进行滤镜拍照
控制的视图为

 ![image](https://github.com/xc19930909yu/GPUImageTest/blob/master/xaioguopaizhao.PNG) 
初始化
/// 录制相机
@property(nonatomic, strong)GPUImageStillCamera *camera;
/// 过滤的视图
@property(nonatomic, strong)GPUImageView *preView;
[self.view insertSubview:self.preView atIndex:0];
///设置camera的方向
self.camera.outputImageOrientation =  UIInterfaceOrientationPortrait;
self.camera.horizontallyMirrorFrontFacingCamera = YES;
///防止允许声音通过的情况下，避免录制第一帧黑屏闪屏  拍摄视频时开启 拍照时不用开启
/// [self.camera addAudioInputsAndOutputs];

// 用到的过滤器,组合成一个过滤器组进行使用 
/// 美白过滤器
@property(nonatomic, strong)GPUImageBrightnessFilter *brightFilter;

/// 饱和
@property(nonatomic, strong)GPUImageSaturationFilter *saturateFilter;

// 磨皮
@property(nonatomic, strong)GPUImageBilateralFilter *bilaFilter;

// 曝光
@property(nonatomic, strong)GPUImageExposureFilter *exposeFilter;

//  生成组合过滤器的代码
/// 获取默认的滤镜组
- (GPUImageFilterGroup*)getCurrentFillterGroup{
    GPUImageFilterGroup *filterGroup = [[GPUImageFilterGroup alloc] init];
    //创建滤镜(设置滤镜的引来关系)
    [self.bilaFilter addTarget:self.brightFilter];
    [self.brightFilter addTarget:self.exposeFilter];
    [self.exposeFilter addTarget:self.saturateFilter];
    /// 默认值
    self.bilaFilter.distanceNormalizationFactor = 8; // //5.5  磨皮 0到10
    self.exposeFilter.exposure = 0;  // 曝光
    self.brightFilter.brightness = 0.1; // 美白亮度 -1 到 1
    self.saturateFilter.saturation = 0.8;  // 饱和度 0到2
    
    filterGroup.initialFilters = @[self.bilaFilter];
    filterGroup.terminalFilter = self.saturateFilter;
    return filterGroup;  
}

/// 最后给相机添加上过滤器， 并开始采集数据
 GPUImageFilterGroup *beautiFilter = [self
                                         getCurrentFillterGroup];
     //设置GPUImage的响应链
    [self.camera addTarget:beautiFilter];
    [beautiFilter addTarget:self.preView];
    ///开启采集
    [self.camera startCameraCapture];

