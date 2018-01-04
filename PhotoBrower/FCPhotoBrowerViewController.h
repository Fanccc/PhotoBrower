//
//  FCPhotoBrowerViewController.h
//  PhotoBrowerModule
//
//  Created by fanchuan on 2018/1/3.
//  Copyright © 2018年 fanchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FCPhotoBrowerViewControllerDelegate<NSObject>

@optional
- (void)fc_browerViewWillShow;
- (void)fc_browerViewShowSuccess;
- (void)fc_browerViewWillDismiss;
- (void)fc_browerViewDismissSuccess;
- (void)fc_browerViewLongPressedIndex:(NSInteger)index;

@end

@interface FCPhotoBrowerViewController : UIViewController

@property (nonatomic, weak) id<FCPhotoBrowerViewControllerDelegate> delegate;

/**
 @param imageLinkArray 图片地址数组用于获取原图大图
 @param thumbnailArray 当前列表里面展示的小图
 */
- (instancetype)initWithImageLinkArray:(NSArray <NSString *>*)imageLinkArray thumbnailArray:(NSArray <UIImageView *>*)thumbnailArray index:(NSUInteger)index;

- (void)showBrowerFromVC:(UIViewController *)sourceVC;
- (void)hideBrowerView;

@end
