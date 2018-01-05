//
//  FCPhotoBrowerCell.m
//  PhotoBrowerModule
//
//  Created by fanchuan on 2018/1/4.
//  Copyright © 2018年 fanchuan. All rights reserved.
//

#import "FCPhotoBrowerCell.h"
#import <UIImageView+WebCache.h>
#import "UIView+Sizes.h"

const CGFloat kDefaultImageHeight = 100.0f;
static const CGFloat minScale = 0.6f;
static const CGFloat maximumOffset = 200.0f;

@interface FCPhotoBrowerCell() <UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *imageContainerView;

@property (nonatomic, strong) UIImageView *moveImage;
@property (nonatomic, assign) CGPoint oldPoint;
@property (nonatomic, assign) CGPoint oldCenter;
@property (nonatomic, assign) CGFloat oldWidth;
@property (nonatomic, assign) CGFloat oldHeight;
@property (nonatomic, assign) CGFloat panWidth;
@property (nonatomic, assign) CGFloat panHeight;
@property (nonatomic, assign) CGFloat currentScale;

@end

@implementation FCPhotoBrowerCell

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, self.width, self.height);
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self addSubview:_scrollView];
        
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        [self addGestureRecognizer:longPress];
        
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panEvent:)];
        pan.delegate = self;
        [self addGestureRecognizer:pan];
        
    }
    return self;
}

- (void)panEvent:(UIPanGestureRecognizer *)pan{
    if(pan.state == UIGestureRecognizerStateBegan){
        if(!_moveImage){
            _moveImage = [[UIImageView alloc] initWithImage:self.imageView.image];
            [self.contentView addSubview:_moveImage];
            _moveImage.backgroundColor = self.imageView.backgroundColor;
        }
        _moveImage.hidden = NO;
        _moveImage.frame = [self.imageContainerView convertRect:self.imageView.bounds toView:self.contentView];
        self.imageContainerView.hidden = YES;
        
        //用来平移
        self.oldPoint = [pan locationInView:pan.view];
        //用来还原位置
        self.oldCenter = _moveImage.center;
        self.oldWidth = _moveImage.width;
        self.oldHeight = _moveImage.height;
        //用来控制缩放位置
        self.panWidth = self.oldWidth;
        self.panHeight = self.oldHeight;
        //比例
        self.currentScale = 1;
        
    }else if (pan.state == UIGestureRecognizerStateChanged){
        
        //当前点
        CGPoint point = [pan locationInView:pan.view];
        CGFloat x = point.x;
        CGFloat y =  point.y;
        
        //偏移量
        CGFloat offset = _moveImage.centerY - self.oldCenter.y;
        
        CGFloat scale = (1 - offset/maximumOffset <= minScale)?minScale:1 - offset/maximumOffset;
        if(scale > 1){
            scale = 1;
        }
        self.currentScale = scale;
        
        if(self.panGestureChangeBlock){
            self.panGestureChangeBlock(scale);
        }
        
        self.moveImage.width = self.oldWidth *scale;
        self.moveImage.height = self.oldHeight *scale;
        
        //修复中心点位置使用
        CGFloat pan_x = (self.panWidth - self.moveImage.width)/2;
        CGFloat pan_y = (self.panHeight - self.moveImage.height)/2;
        
        self.panWidth = self.moveImage.width;
        self.panHeight = self.moveImage.height;
        
        _moveImage.center =CGPointMake(_moveImage.centerX + (x - self.oldPoint.x) + pan_x, _moveImage.centerY + (y - self.oldPoint.y) + pan_y);
        
        //更新最新点
        self.oldPoint = point;
    }else{
        if(self.currentScale > minScale){
            [UIView animateWithDuration:0.3f animations:^{
                _moveImage.width = self.oldWidth;
                _moveImage.height = self.oldHeight;
                _moveImage.center = self.oldCenter ;
            } completion:^(BOOL finished) {
                _moveImage.hidden = YES;
                self.imageContainerView.hidden = NO;
            }];
            
            if(self.panGestureEndFixBlock){
                self.panGestureEndFixBlock(1);
            }
        }else{
            if(self.panGestureEndGoDismissBlock){
            self.panGestureEndGoDismissBlock(self.moveImage);
                self.moveImage.hidden = YES;
            }
        }
    }
}

- (void)configCellthumbnail:(UIImage *)thumbnail imageLink:(NSString *)imagelink{
    [_scrollView setZoomScale:1.0 animated:NO];
    if(imagelink){
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imagelink] placeholderImage:thumbnail completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            [self resizeSubviews];
        }];
    }else{
        self.imageView.image = thumbnail;
    }
    self.imageView.backgroundColor = [UIColor grayColor];
    [self resizeSubviews];
}

- (void)resizeSubviews {
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = self.width;
    
    UIImage *image = _imageView.image;
    if(image){
        if (image.size.height / image.size.width > self.height / self.width) {
            _imageContainerView.height = floor(image.size.height / (image.size.width / self.width));
        } else {
            CGFloat height = image.size.height / image.size.width * self.width;
            if (height < 1 || isnan(height)) height = self.height;
            height = floor(height);
            _imageContainerView.height = height;
            _imageContainerView.centerY = self.height / 2;
        }
        if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
            _imageContainerView.height = self.height;
        }
    }else{
        _imageContainerView.height = kDefaultImageHeight;
        _imageContainerView.centerY = self.height / 2;
    }
    _scrollView.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _imageView.frame = _imageContainerView.bounds;
}


#pragma mark - UITapGestureRecognizer Event
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if(self.longPressGestureBlock){
            self.longPressGestureBlock();
        }
    }
}

- (UIImageView *)currentImageView{
    return self.imageView;
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width) ? (scrollView.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height) ? (scrollView.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        UIPanGestureRecognizer *pan =(UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [pan translationInView:pan.view];;
        
        CGFloat absX = fabs(translation.x);
        CGFloat absY = fabs(translation.y);
        
        // 设置滑动有效距离
        if (MAX(absX, absY) < 1){
            return NO;
        }
        
        if (absX > absY ) {
            if (translation.x<0) {
                //向左滑动
                return NO;
            }else{
                //向右滑动
                return NO;
            }
        } else if (absY > absX) {
            if (translation.y<0) {
                //向上滑动
                return NO;
            }else{
                //向下滑动
                return YES;
            }
        }
        return YES;
    }
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return self.imageView.image.size.height > self.imageView.image.size.width;
}

@end
