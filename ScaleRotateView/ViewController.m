//
//  ViewController.m
//  ScaleRotateView
//
//  Created by MyCompany on 16/10/17.
//  Copyright © 2016年 Babyvilla. All rights reserved.
//

#import "ViewController.h"
#import "SHTietuContentView.h"
#import "UIImage+Rotating.h"
#import "UIViewAdditions.h"
#import "UIImage+Resizing.h"

@interface ViewController ()

@property (nonatomic,retain)SHTietuContentView *tietuView;
@property CGPoint previousPoint;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIView *centerView = [[UIView alloc]initWithFrame:CGRectMake(50, 50, 300, 500)];
    centerView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:centerView];
//    这里的model储存了所有的信息
    [self addImageToCell:centerView withImageName:@"timg"];
    
}
-(void)addImageToCell:(UIView *)view withImageName:(NSString *)imageName {
    
    UIView *selectedView = view;
    SHTietuContentView *contentView = [[SHTietuContentView alloc]initWithFrame:CGRectMake(0, 0, 160,160)];
    contentView.imageView.image = [UIImage imageNamed:imageName];
    contentView.tietuImageName = imageName;
    [contentView.upsideDownButton addTarget:self action:@selector(upsideDownButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [[contentView.upsideDownButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
//        @strongify(contentView);
//        contentView.imageView.image = [contentView.imageView.image horizontalFlip];
//    }];
//    SingleHandGestureRecognizer *panG = [[SingleHandGestureRecognizer alloc]initWithTarget:self action:@selector(panGAction:) anchorView:contentView.imageView];
    UIPanGestureRecognizer *panToScaleOrRotateGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panToScaleOrRotateGesture:)];
    
    [contentView.deleButton addTarget:self action:@selector(deleButtonAction:) forControlEvents:UIControlEventTouchUpInside ];
    
    UIPanGestureRecognizer *contentViewPanG = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureToMoveContentView:)];
    
    UITapGestureRecognizer *contentViewTapG = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureToHideBorderLine:)];
    
    [contentView addGestureRecognizer:contentViewTapG];
    [contentView addGestureRecognizer:contentViewPanG];
    [contentView.translateImgView addGestureRecognizer:panToScaleOrRotateGesture];
    contentView.center = CGPointMake(selectedView.width/2, selectedView.height/2);
    [selectedView addSubview:contentView];
}

-(void)upsideDownButtonAction:(UIButton *)sender{
    SHTietuContentView *contentView = (SHTietuContentView *)sender.superview;
    contentView.imageView.image = [contentView.imageView.image horizontalFlip];
}
-(void)deleButtonAction:(UIButton *)sender{
    [sender.superview removeFromSuperview];
}
-(void)tapGestureToHideBorderLine:(UITapGestureRecognizer *)tapGesture{
    SHTietuContentView *contentView = (SHTietuContentView *)tapGesture.view;
    [contentView setHiddenViews:!contentView.deleButton.hidden];
}
-(void)panGestureToMoveContentView:(UIPanGestureRecognizer *)panGesture{
    SHTietuContentView *contentView = (SHTietuContentView *)panGesture.view;
//    这里相对于滑动时的View的位置，所以是superView
    UIView *translationView = contentView.superview;
    CGPoint panPoint = [panGesture translationInView:translationView];
    contentView.center = CGPointMake(contentView.center.x+panPoint.x, contentView.center.y+panPoint.y);
//    这个是归0，不然数字会跳动，归0之后，每次数字都是从（0，0）点取，而不是叠加
    [panGesture setTranslation:CGPointZero inView:translationView];
}
-(void)panToScaleOrRotateGesture:(UIPanGestureRecognizer *)panGuesture{
    SHTietuContentView *contentView = (SHTietuContentView *)panGuesture.view.superview;
    UIImageView *imageView = contentView.imageView;
    
    CGPoint imageViewCenter = imageView.center;
    CGPoint currentPoint = [panGuesture locationInView:contentView];
    CGPoint previousPoint = self.previousPoint;
    
    CGFloat currentRotation = atan2f((currentPoint.y-imageViewCenter.y), (currentPoint.x-imageViewCenter.x));
    CGFloat previousRotation = atan2f((previousPoint.y-imageViewCenter.y), (previousPoint.x-imageViewCenter.x));
    
    CGFloat currentRadius = [self distanceBetweenFirstPoint:currentPoint secondPoint:imageViewCenter];
    CGFloat previousRadius = [self distanceBetweenFirstPoint:previousPoint secondPoint:imageViewCenter];
    
    //            最终结果
    CGFloat finalScale = currentRadius/previousRadius;
    
    CGFloat finalRotation = currentRotation-previousRotation;
    
    panGuesture.view.superview.transform = CGAffineTransformScale(panGuesture.view.superview.transform,finalScale,finalScale);
    panGuesture.view.superview.transform = CGAffineTransformRotate(panGuesture.view.superview.transform, finalRotation);
    contentView.rotate = contentView.rotate+finalRotation;
    
    
    self.previousPoint = currentPoint;
    
    [panGuesture setTranslation:CGPointZero inView:panGuesture.view.superview];
    switch (panGuesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
        {
            
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)distanceBetweenFirstPoint:(CGPoint)first secondPoint:(CGPoint)second {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX * deltaX + deltaY * deltaY);
}


//这里是调用 filterImage为大图，contentView为之前的模型图，将两张图合并
+(UIImage *)stickImagesWithContentView:(UIView *)centerView addImage:(UIImage *)filterImage{
    TICK;
//    views为可能存在多张贴图contentView在centerView
    NSArray *views = centerView.subviews;
    NSMutableArray *imagesArray = [NSMutableArray arrayWithCapacity:views.count];
    [views enumerateObjectsUsingBlock:^(__kindof SHTietuContentView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *oldImage = [UIImage imageNamed:obj.tietuImageName];//obj.imageView.image;
        UIImage *newImage0 = obj.isHorizenFlip?[oldImage horizontalFlip]:oldImage;
        UIImage *newImage1 = [newImage0 rotateInRadians:2*M_PI-obj.rotate];
        UIImage *finalImage = [newImage1 scaleToCoverSize:obj.imageView.size];
        [imagesArray addObject:@{
                                 @"finalImage":finalImage,
                                 @"contentView":obj
                                 }];
    }];
    TOCK;
    if (imagesArray.count) {
        CGFloat scaleX = filterImage.size.width*1.0/centerView.size.width;
        CGFloat scaleY = filterImage.size.height*1.0/centerView.size.height;
        __block UIImage *finalImage = nil;
        @autoreleasepool {
            UIGraphicsBeginImageContextWithOptions(filterImage.size, YES,[UIScreen mainScreen].scale);
            [filterImage drawInRect:CGRectMake(0, 0, filterImage.size.width, filterImage.size.height)];
            [imagesArray enumerateObjectsUsingBlock:^(NSDictionary *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                SHTietuContentView *contentView = obj[@"contentView"];
                CGSize finalSize = CGSizeMake(contentView.size.width-40, contentView.size.height-40);
                CGFloat twoWidth = finalSize.width*scaleX;
                CGFloat twoHeight = finalSize.height*scaleY;
                [obj[@"finalImage"] drawInRect:CGRectMake((contentView.origin.x+20)*scaleX, (contentView.origin.y+20)*scaleY, twoWidth, twoHeight)];
            }];
            finalImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        TOCK;
        return finalImage;
    }
    TOCK;
    return filterImage;
}

@end
