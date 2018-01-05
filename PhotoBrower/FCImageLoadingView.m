//
//  FCImageLoadingView.m
//  PhotoBrowerModule
//
//  Created by fanchuan on 2018/1/5.
//  Copyright © 2018年 fanchuan. All rights reserved.
//

#import "FCImageLoadingView.h"

@interface FCImageLoadingView ()

@property (nonatomic, strong) CAShapeLayer *bottomLayer;
@property (nonatomic, strong) CAShapeLayer *rotateLayer;

@end

@implementation FCImageLoadingView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width/2];
        _bottomLayer = [[CAShapeLayer alloc] init];
        _bottomLayer.path = bezierPath.CGPath;
        _bottomLayer.lineWidth = 4;
        _bottomLayer.strokeColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
        _bottomLayer.fillColor = [UIColor clearColor].CGColor;
        
        [self.layer addSublayer:_bottomLayer];
        
        UIBezierPath *bezierPath_roate = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2) radius:self.bounds.size.width/2 startAngle:0 endAngle:M_PI*0.7 clockwise:YES];
        _rotateLayer = [[CAShapeLayer alloc] init];
        _rotateLayer.path = bezierPath_roate.CGPath;
        _rotateLayer.lineWidth = 4;
        _rotateLayer.strokeColor = [UIColor whiteColor].CGColor;
        _rotateLayer.fillColor = [UIColor clearColor].CGColor;
        _rotateLayer.lineCap = kCALineCapRound;
        [self.layer addSublayer:_rotateLayer];
    }
    return self;
}


- (void)startAnimation{
    self.hidden = NO;
    [self.layer removeAnimationForKey:@"CABasicAnimation_rotate"];
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1.0f;
    animation.repeatCount = CGFLOAT_MAX;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:2*M_PI];
    [self.layer addAnimation:animation forKey:@"CABasicAnimation_rotate"];
}

- (void)endAnimation{
    [self.layer removeAnimationForKey:@"CABasicAnimation_rotate"];
    self.hidden = YES;
}

@end
