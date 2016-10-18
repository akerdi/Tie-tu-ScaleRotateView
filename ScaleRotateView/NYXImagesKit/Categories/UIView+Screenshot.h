//
//  UIView+Screenshot.h
//  NYXImagesKit
//
//  Created by @Nyx0uf on 29/03/13.
//  Copyright 2013 Nyx0uf. All rights reserved.
//  www.cocoaintheshell.com
//


@interface UIView (NYX_Screenshot)

-(UIImage*)imageByRenderingView;


//全屏截图
+ (UIImage *)shotScreen;
//截取view生成一张图片
+ (UIImage *)shotWithView:(UIView *)view;
//截取view中某个区域生成一张图片
+ (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope;

@end
