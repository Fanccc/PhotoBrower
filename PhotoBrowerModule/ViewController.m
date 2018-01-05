//
//  ViewController.m
//  PhotoBrowerModule
//
//  Created by fanchuan on 2018/1/3.
//  Copyright © 2018年 fanchuan. All rights reserved.
//

#import "ViewController.h"
#import "FCPhotoBrowerViewController.h"
#import <UIImageView+WebCache.h>
#import "UIView+Sizes.h"

@interface ViewController () <FCPhotoBrowerViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *imageViewArr;
@property (nonatomic, strong) NSArray *array;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    https://qiniu.9h-sports.com/FuO6S3wsWWH_iJanPoyM_SKN46Jc
    _imageViewArr = [NSMutableArray array];
    
    _array = @[
                        @"https://qiniu.9h-sports.com/FnIHP85PFWfE-ST1gZ2KkbjJhkcj",
                        @"https://qiniu.9h-sports.com/FrUehwAnvF5HVIppPUYa2PF7efM6",
                        @"https://qiniu.9h-sports.com/FuO6S3wsWWH_iJanPoyM_SKN46Jc",
                        @"https://qiniu.9h-sports.com/FsvUApUwY8vwPoufOitvYfUeZ6X0",
                        @"https://qiniu.9h-sports.com/FjZ_B9qACCKnlSBBHxDZ7jwFKfd5",
                        @"https://qiniu.9h-sports.com/FnU_VeUHUOf-nG_izun3rplBe6X_",
                        @"https://qiniu.9h-sports.com/FnBxDS5-sVPfEAGVMnVMJb6D1DDI",
                        @"https://qiniu.9h-sports.com/FqoyZf4A4Y8No-buslQiQFwbqPdo",
                        @"https://qiniu.9h-sports.com/Fn-gR0WOjLPxHE_UX7N17XFBG62u",
                       ];
    
    
//    _array = @[
//               @"image_0",
//               @"image_1",
//               @"image_2"
//               ];
    
    for (int i = 0; i < _array.count; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20 + (10 + 80) * i, 80, 80)];
        
        if(i >= 6){
            imageView.frame = CGRectMake(20 + 80 + 20, 20 + (10 + 80) * (i - 6), 80, 80);
        }
        
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:imageView];
        imageView.backgroundColor = [UIColor grayColor];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[self thumbUrlWithUrl:_array[i] width:160 height:160]]];
       // imageView.image = [UIImage imageNamed:_array[i]];
        [_imageViewArr addObject:imageView];
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
//    FCPhotoBrowerViewController *browerVC = [[FCPhotoBrowerViewController alloc] initWithImageLinkArray:nil thumbnailArray:_imageViewArr index:tap.view.tag];
    FCPhotoBrowerViewController *browerVC = [[FCPhotoBrowerViewController alloc] initWithImageLinkArray:_array thumbnailArray:_imageViewArr index:tap.view.tag];
    browerVC.delegate = self;
    [browerVC showBrowerFromVC:self];
}

- (NSString *)thumbUrlWithUrl:(NSString *)url width:(NSInteger)width height:(NSInteger)height{
    return [NSString stringWithFormat:@"%@?imageView2/3/w/%lu/h/%lu",url,width,height];
}


#pragma mark - delegate
- (void)fc_browerViewWillShow{
    //NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)fc_browerViewShowSuccess{
    //NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)fc_browerViewWillDismiss{
    //NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)fc_browerViewDismissSuccess{
    //NSLog(@"%@",NSStringFromSelector(_cmd));
}
- (void)fc_browerViewLongPressedIndex:(NSInteger)index{
    //NSLog(@"%@",NSStringFromSelector(_cmd));
}


@end
