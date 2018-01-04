//
//  ViewController.m
//  PhotoBrowerModule
//
//  Created by fanchuan on 2018/1/3.
//  Copyright © 2018年 fanchuan. All rights reserved.
//

#import "ViewController.h"
#import "FCPhotoBrowerViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray *imageViewArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _imageViewArr = [NSMutableArray array];
    
    NSArray *array = @[
                        @"image_0",
                        @"image_1",
                        @"image_2",
                       ];
    
    for (int i = 0; i < array.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (10 + 100) * i, 50, 100, 100)];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:imageView];
        imageView.image = [UIImage imageNamed:array[i]];
        [_imageViewArr addObject:imageView];
        imageView.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    FCPhotoBrowerViewController *browerVC = [[FCPhotoBrowerViewController alloc] initWithImageLinkArray:nil thumbnailArray:_imageViewArr index:tap.view.tag];
    [browerVC showBrowerFromVC:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
