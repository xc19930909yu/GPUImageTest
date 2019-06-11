//
//  BMTakephotoController.h
//  BangMall
//
//  Created by 徐超 on 2019/5/20.
//  Copyright © 2019年 ygj. All rights reserved.
//  自定义拍照控制器

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TakePhotoDelegate <NSObject>

- (void)takePhoto:(UIImage*)image;

@end

@interface BMTakephotoController :UIViewController

@property(nonatomic, weak)id<TakePhotoDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
