//
//  FCBrowerTransition.m
//  PhotoBrowerModule
//
//  Created by fanchuan on 2018/1/4.
//  Copyright © 2018年 fanchuan. All rights reserved.
//

#import "FCBrowerTransition.h"
#import "UIView+Sizes.h"
#import "FCPhotoBrowerCell.h"

@interface FCBrowerTransition()

@property (nonatomic, strong) UIImageView *clickImageView;
@property (nonatomic, strong) UIImageView *startImageView;

@end

@implementation FCBrowerTransition

- (instancetype)initWithImageView:(UIImageView *)imageView{
    if(self = [super init]){
        _clickImageView = imageView;
    }
    return self;
}

- (instancetype)initDismissWithImageView:(UIImageView *)imageView startImageView:(UIImageView *)startImageView{
    if(self = [super init]){
        _clickImageView = imageView;
        _startImageView = startImageView;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.3f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];

    if(toVC.isBeingPresented){
        [self presentAnimation:transitionContext];
    }
    if(fromVC.isBeingDismissed){
        [self dismissAnimation:transitionContext];
    }
}

#pragma mark - present
- (void)presentAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    toView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    
    UIView *containerView = transitionContext.containerView;
    [containerView addSubview:toView];
    
    CGRect rect = [self.clickImageView convertRect:self.clickImageView.bounds toView:toView];
    
    CGSize imageSize = CGSizeMake(toView.width, toView.width/(self.clickImageView.image.size.width/self.clickImageView.image.size.height));
    if(!self.clickImageView.image){
        extern CGFloat kDefaultImageHeight;
        imageSize = CGSizeMake(toView.width, kDefaultImageHeight);
    }
    CGSize contentSize = CGSizeMake(toView.width, MAX(imageSize.height, toView.height));
    
    __block UIView *conView = [[UIView alloc] init];
    conView.frame = CGRectMake(0, 0, contentSize.width, contentSize.height);
    conView.backgroundColor = [UIColor clearColor];
    [toView addSubview:conView];
    
    __block UIImageView *animationImageView = [[UIImageView alloc] initWithImage:self.clickImageView.image];
    animationImageView.frame = rect;
    animationImageView.backgroundColor = self.clickImageView.backgroundColor;
    [conView addSubview:animationImageView];
    animationImageView.clipsToBounds = YES;
    animationImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.clickImageView.hidden = YES;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        animationImageView.size = imageSize;
        animationImageView.center = conView.center;
        toView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:1];
        
    } completion:^(BOOL finished) {
        self.clickImageView.hidden = NO;

        [animationImageView removeFromSuperview];
        animationImageView = nil;
        [conView removeFromSuperview];
        conView = nil;
        [transitionContext completeTransition:YES];
    }];
}

- (void)dismissAnimation:(id<UIViewControllerContextTransitioning>)transitionContext{
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    
    CGRect toRect = [self.clickImageView convertRect:self.clickImageView.bounds toView:fromView];
    CGRect fromRect = [self.startImageView convertRect:self.startImageView.bounds toView:fromView];
    
    __block UIImageView *imageView = [[UIImageView alloc] initWithImage:self.startImageView.image];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.backgroundColor = self.startImageView.backgroundColor;
    [fromView addSubview:imageView];
    imageView.frame = fromRect;
    
    self.clickImageView.hidden = YES;
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        imageView.frame = toRect;
        
    } completion:^(BOOL finished) {
        self.clickImageView.hidden = NO;
        [imageView removeFromSuperview];
        imageView = nil;
        [transitionContext completeTransition:YES];
    }];
}

@end
