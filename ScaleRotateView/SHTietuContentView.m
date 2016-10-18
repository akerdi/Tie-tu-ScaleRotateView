//
//  SHTietuContentView.m
//  GUAPAIPJ
//
//  Created by MyCompany on 16/7/13.
//  Copyright © 2016年 Babyvilla. All rights reserved.
//

#import "SHTietuContentView.h"
#import "UIViewAdditions.h"

#define Padding 20

@implementation SHTietuContentView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.imageView = ({
            UIImageView *imagev = [[UIImageView alloc]init];
            [self addSubview:imagev];
            imagev;
        });
        
        self.whiteBorderView = ({
            UIView *borderView = [UIView new];
            borderView.layer.borderColor = [UIColor whiteColor].CGColor;
            borderView.layer.borderWidth = 1.5f;
            [self addSubview:borderView];
            borderView;
        });
        
        self.deleButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, Padding*2, Padding*2);
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [button setImage:[UIImage imageNamed:@"words_tiezhi_close"] forState:UIControlStateNormal];
            [self addSubview:button];
            button;
        });
        self.upsideDownButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 0, Padding*2, Padding*2);
            [button setImage:[UIImage imageNamed:@"words_tiezhi_rotate"] forState:UIControlStateNormal];
            [button setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            [self addSubview:button];
            button;
        });
        
        self.translateImgView = ({
            UIImageView *imgView = [[UIImageView alloc]init];
            imgView.image = [UIImage imageNamed:@"words_tiezhi_change"];
            imgView.frame = CGRectMake(0, 0, Padding*2-10, Padding*2-10);
            imgView.userInteractionEnabled = YES;
            [self addSubview:imgView];
            imgView;
        });
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    LxDBAnyVar(_cmd);
    self.imageView.frame = CGRectMake(Padding, Padding, rect.size.width-2*Padding, rect.size.height-2*Padding);
    self.whiteBorderView.frame = self.imageView.frame;
    self.deleButton.origin = CGPointMake(0, 0);
    self.upsideDownButton.center = CGPointMake(rect.size.width-Padding, Padding);
    self.translateImgView.center = CGPointMake(rect.size.width-Padding, rect.size.height-Padding);
}

-(void)updateViews{
    self.imageView.frame = CGRectMake(Padding, Padding, self.bounds.size.width-2*Padding, self.bounds.size.height-2*Padding);
    self.whiteBorderView.frame = self.imageView.frame;
    self.deleButton.center = CGPointMake(20, 20);
    self.upsideDownButton.center = CGPointMake(self.bounds.size.width-Padding, Padding);
    self.translateImgView.center = CGPointMake(self.bounds.size.width-20, self.bounds.size.height-20);
}

-(void)setHiddenViews:(BOOL)hide{
    self.whiteBorderView.hidden = hide;
    self.deleButton.hidden = hide;
    self.upsideDownButton.hidden = hide;
    self.translateImgView.hidden = hide;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/

@end
