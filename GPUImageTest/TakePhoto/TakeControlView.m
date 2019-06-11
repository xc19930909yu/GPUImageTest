//
//  TakeControlView.m
//  BangMall
//
//  Created by 徐超 on 2019/5/20.
//  Copyright © 2019年 ygj. All rights reserved.
//

#import "TakeControlView.h"
#import "Masonry.h"

#define TopSafeAreaHeight ([UIScreen mainScreen ].bounds.size.height >= 812.0 ? 44 : 20)
#define BottomSafeAreaHeight ([UIScreen mainScreen ].bounds.size.height >= 812.0 ? (83 - 49) : 0)

@interface TakeControlView()

/// 返回按钮
@property(nonatomic, strong)UIButton *closeBtn;

/// 闪光灯按钮
@property(nonatomic, strong)UIButton *splashBtn;

/// 相机翻转按钮
@property(nonatomic, strong)UIButton *changeCameraBtn;

/// 拍照按钮
@property(nonatomic, strong)UIButton *takeBtn;

@end

@implementation TakeControlView

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[UIImage imageNamed:@"bm_paymoney_back_img"] forState:UIControlStateNormal];
        _closeBtn.backgroundColor = [UIColor clearColor];
        [_closeBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

- (UIButton *)splashBtn{
    if (!_splashBtn) {
        _splashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_splashBtn setImage:[UIImage imageNamed:@"闪光灯"] forState:UIControlStateNormal];
        _splashBtn.backgroundColor = [UIColor clearColor];
        [_splashBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _splashBtn;
}

- (UIButton *)changeCameraBtn{
    if (!_changeCameraBtn) {
        _changeCameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_changeCameraBtn setImage:[UIImage imageNamed:@"相机翻转"] forState:UIControlStateNormal];
        _changeCameraBtn.backgroundColor = [UIColor clearColor];
        [_changeCameraBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _changeCameraBtn;
}

- (UIButton *)takeBtn{
    if (!_takeBtn) {
        _takeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_takeBtn setImage:[UIImage imageNamed:@"拍摄"] forState:UIControlStateNormal];
        _takeBtn.backgroundColor = [UIColor clearColor];
        [_takeBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _takeBtn;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self contentView];
    }
    return self;
}


- (void)contentView{
    [self addSubview:self.closeBtn];
    [self addSubview:self.splashBtn];
    [self addSubview:self.changeCameraBtn];
    [self addSubview:self.takeBtn];
    [self snapView];
}


- (void)snapView{
   
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(20);
        make.top.mas_equalTo(self.mas_top).offset(TopSafeAreaHeight + 10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.splashBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.closeBtn.mas_right).offset(15);
        //make.top.mas_equalTo(self.mas_top).offset(StatuBar_Height);
        make.centerY.equalTo(self.closeBtn);
        make.size.mas_equalTo(CGSizeMake(45, 45));
    }];
    
    [self.changeCameraBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-20);
        //make.top.mas_equalTo(self.mas_top).offset(StatuBar_Height);
        make.centerY.equalTo(self.closeBtn);
        make.size.equalTo(self.closeBtn);
    }];
    
    [self.takeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-BottomSafeAreaHeight  - 15);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    
}

/// 按钮点击
- (void)nextBtnClick:(UIButton*)btn{
    if ([btn isEqual:self.splashBtn]) {
        btn.selected = !btn.selected;
        if (self.delegate && [self.delegate respondsToSelector:@selector(turnLightBtnClickWithStatus:)]) {
            [self.delegate turnLightBtnClickWithStatus:btn.selected];
        }
    }else if ([btn isEqual:self.changeCameraBtn]){
        btn.selected = !btn.selected;
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeCameraBtnClickWithSatus:)]) {
            [self.delegate changeCameraBtnClickWithSatus:btn.selected];
        }
    }else if ([btn isEqual:self.takeBtn]){
        
        btn.selected = !btn.selected;
        if (self.delegate && [self.delegate respondsToSelector:@selector(startBtnClickWithStatus:)]) {
            [self.delegate startBtnClickWithStatus:btn.selected];
        }
    }else if ([btn isEqual:self.closeBtn]){
        btn.selected = !btn.selected;
        if (self.delegate && [self.delegate respondsToSelector:@selector(popBtnClick:)]) {
            [self.delegate popBtnClick:btn.selected];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
