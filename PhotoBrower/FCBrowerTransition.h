//
//  FCBrowerTransition.h
//  PhotoBrowerModule
//
//  Created by fanchuan on 2018/1/4.
//  Copyright © 2018年 fanchuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FCBrowerTransition : NSObject<UIViewControllerAnimatedTransitioning>

//当前点击的imageView
- (instancetype)initWithImageView:(UIImageView *)imageView;

- (instancetype)initDismissWithImageView:(UIImageView *)imageView startImageView:(UIImageView *)startImageView;;

@end
