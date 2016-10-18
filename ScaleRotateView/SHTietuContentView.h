//
//  SHTietuContentView.h
//  GUAPAIPJ
//
//  Created by MyCompany on 16/7/13.
//  Copyright © 2016年 Babyvilla. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LxDBAnything.h"

@interface SHTietuContentView : UIView

@property (nonatomic, assign) CGFloat rotate;

@property (nonatomic, assign) BOOL isHorizenFlip;

@property (nonatomic, strong) UIImageView *imageView;
//贴图展示的View
@property (nonatomic, copy) NSString *tietuImageName;
//白边的View
@property (nonatomic, strong) UIView *whiteBorderView;
//删除按钮
@property (nonatomic, strong) UIButton *deleButton;
//翻动mirror按钮
@property (nonatomic, strong) UIButton *upsideDownButton;
//放大旋转按钮
@property (nonatomic, strong) UIImageView *translateImgView;

-(void)updateViews;

-(void)setHiddenViews:(BOOL)hide;

@end
