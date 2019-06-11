//
//  BMTakephotoController.m
//  BangMall
//
//  Created by 徐超 on 2019/5/20.
//  Copyright © 2019年 ygj. All rights reserved.
//

#import "BMTakephotoController.h"
#import "TakeControlView.h"
#import "GPUImage.h"
#import "RSKImageCropper.h"

@interface BMTakephotoController ()<TakeControlDelegate,RSKImageCropViewControllerDelegate>

/// 录制相机
@property(nonatomic, strong)GPUImageStillCamera *camera;

/// 过滤的视图
@property(nonatomic, strong)GPUImageView *preView;

/// 美白过滤器
@property(nonatomic, strong)GPUImageBrightnessFilter *brightFilter;

/// 饱和
@property(nonatomic, strong)GPUImageSaturationFilter *saturateFilter;

// 磨皮
@property(nonatomic, strong)GPUImageBilateralFilter *bilaFilter;

// 曝光
@property(nonatomic, strong)GPUImageExposureFilter *exposeFilter;

// 表层的控制器
@property(nonatomic, strong)TakeControlView *controlView;

@end

@implementation BMTakephotoController

- (TakeControlView *)controlView{
    if (!_controlView) {
        _controlView = [[TakeControlView alloc] initWithFrame:self.view.bounds];
        _controlView.delegate = self;
    }
    return _controlView;
}

- (GPUImageVideoCamera *)camera{
    if (!_camera) {
        _camera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPresetHigh cameraPosition:AVCaptureDevicePositionBack];
    }
    return _camera;
}


- (GPUImageView *)preView{
    if (!_preView ) {
        _preView = [[GPUImageView alloc]  initWithFrame:self.view.bounds];
    }
    return _preView;
}

- (GPUImageBrightnessFilter *)brightFilter{
    if (!_brightFilter) {
        _brightFilter = [[GPUImageBrightnessFilter alloc]  init];
    }
    return _brightFilter;
}

- (GPUImageBilateralFilter *)bilaFilter{
    if (!_bilaFilter) {
        _bilaFilter = [[GPUImageBilateralFilter alloc]  init];
    }
    return _bilaFilter;
}

- (GPUImageSaturationFilter *)saturateFilter{
    if (!_saturateFilter) {
        _saturateFilter = [[GPUImageSaturationFilter alloc]  init];
    }
    return _saturateFilter;
}

- (GPUImageExposureFilter *)exposeFilter{
    if (!_exposeFilter) {
        _exposeFilter = [[GPUImageExposureFilter alloc]  init];
    }
    return _exposeFilter;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.camera stopCameraCapture];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self  configureCamera];
    [self.view addSubview:self.controlView];
    // Do any additional setup after loading the view.
}


- (void)configureCamera{
    /// 创建预览的view
    [self.view insertSubview:self.preView atIndex:0];
    ///设置camera的方向
    self.camera.outputImageOrientation =  UIInterfaceOrientationPortrait;
    self.camera.horizontallyMirrorFrontFacingCamera = YES;
    
    ///防止允许声音通过的情况下，避免录制第一帧黑屏闪屏
    // [self.camera addAudioInputsAndOutputs];
    
    GPUImageFilterGroup *beautiFilter = [self
                                         getCurrentFillterGroup];
     //设置GPUImage的响应链
    [self.camera addTarget:beautiFilter];
    [beautiFilter addTarget:self.preView];
    ///开启采集
    [self.camera startCameraCapture];
    
}

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

- (UIStatusBarStyle)preferredStatusBarStyle{
 
    return UIStatusBarStyleLightContent;
}


#pragma mark - TakeControlDelegate
- (void)changeCameraBtnClickWithSatus:(BOOL)status{
    
    [self.camera rotateCamera];
}

/// 闪光灯
- (void)turnLightBtnClickWithStatus:(BOOL)status{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    @try {
        [device lockForConfiguration:nil];
        //Code that can potentially throw an exception
    } @catch (NSException *exception) {
        //Handle an exception thrown in the @try block
    } @finally {
        if ([device hasFlash] && [device hasTorch]) {
            if (status) {
                device.flashMode =  AVCaptureFlashModeOn;
                //device.torchMode = AVCaptureTorchModeOn;
            }else{
                device.flashMode =  AVCaptureFlashModeOff;
                //device.torchMode = AVCaptureTorchModeOff;
            }
        }
        [device unlockForConfiguration];
        // Code that gets executed whether or not an exception is thrown
    }
}

/// 拍摄
- (void)startBtnClickWithStatus:(BOOL)status{
    
    [self.camera capturePhotoAsImageProcessedUpToFilter:[self getCurrentFillterGroup] withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        if (error) {
            
            return ;
        }
        /// 进入剪切页面
        RSKImageCropViewController *imageCropVc = [[RSKImageCropViewController alloc] initWithImage:processedImage cropMode:RSKImageCropModeSquare];
        imageCropVc.avoidEmptySpaceAroundImage  = YES;
        imageCropVc.delegate = self;
        //[self.navigationController pushViewController:imageCropVc animated:YES];
        
        [self presentViewController:imageCropVc animated:YES completion:nil];
    }];
}

/// 返回
- (void)popBtnClick:(BOOL)status{
   // [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


/// 图片剪切的代理方法
#pragma mark - RSKImageCropViewControllerDelegate
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller{
    //[self dismissViewControllerAnimated:YES completion:nil]; [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect rotationAngle:(CGFloat)rotationAngle{
    if (self.delegate) {
        if ([self.delegate respondsToSelector:@selector(takePhoto:)]) {
            [self.delegate takePhoto:croppedImage];
            [self dismissViewControllerAnimated:YES completion:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
//           [self dismissViewControllerAnimated:YES completion:nil]; [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
