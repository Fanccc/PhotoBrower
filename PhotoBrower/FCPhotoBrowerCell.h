//
//  FCPhotoBrowerCell.h
//  PhotoBrowerModule
//
//  Created by fanchuan on 2018/1/4.
//  Copyright © 2018年 fanchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FCPhotoBrowerCell : UICollectionViewCell

@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
@property (nonatomic, copy) void (^longPressGestureBlock)(void);

//用来控制显示和消失的block
@property (nonatomic, copy) void (^panGestureChangeBlock)(CGFloat);
@property (nonatomic, copy) void (^panGestureEndGoDismissBlock)(UIImageView *moveImageView);


- (void)configCellthumbnail:(UIImage *)thumbnail imageLink:(NSString *)imagelink;

- (UIImageView *)currentImageView;

@end
