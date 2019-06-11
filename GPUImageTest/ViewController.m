//
//  ViewController.m
//  GPUImageTest
//
//  Created by 李朋朋 on 2019/6/11.
//  Copyright © 2019 李朋朋. All rights reserved.
//

#import "ViewController.h"
#import "BMTakephotoController.h"

@interface ViewController ()<TakePhotoDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;


//@property(nonatomic, strong)BMTakephotoController *takeVc;
@end

@implementation ViewController

//- (BMTakephotoController *)takeVc{
//  if(!_takeVc){
//      _takeVc = [[BMTakephotoController alloc]  init];
//      _takeVc.delegate = self;
//   }
//   return _takeVc;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}


/// 点击开始启用摄像头拍照
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    //[self presentViewController:self.takeVc animated:YES completion:nil];
    BMTakephotoController *takeVc = [[BMTakephotoController alloc]  init];
    takeVc.delegate = self;
    [self presentViewController:takeVc animated:YES completion:nil];
}



#pragma mark - TakePhotoDelegate
- (void)takePhoto:(UIImage*)image{
    self.selectImg.image = image;
}

@end
