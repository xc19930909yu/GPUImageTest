//
//  TakeControlView.h
//  BangMall
//
//  Created by 徐超 on 2019/5/20.
//  Copyright © 2019年 ygj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TakeControlDelegate <NSObject>

/// 相机翻转
- (void)changeCameraBtnClickWithSatus:(BOOL)status;

/// 闪光灯
- (void)turnLightBtnClickWithStatus:(BOOL)status;

/// 拍摄
- (void)startBtnClickWithStatus:(BOOL)status;


/// 返回
- (void)popBtnClick:(BOOL)status;

@end

@interface TakeControlView : UIView

@property(nonatomic ,assign) id<TakeControlDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
