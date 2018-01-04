//
//  FCPhotoBrowerViewController.m
//  PhotoBrowerModule
//
//  Created by fanchuan on 2018/1/3.
//  Copyright © 2018年 fanchuan. All rights reserved.
//

#import "FCPhotoBrowerViewController.h"
#import "FCPhotoBrowerCell.h"
#import "UIView+Sizes.h"
#import "FCBrowerTransition.h"

@interface FCPhotoBrowerViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIViewControllerTransitioningDelegate>
//资源
@property (nonatomic, strong) NSArray *imageLinkArray;
@property (nonatomic, strong) NSArray *thumbnailArray;
@property (nonatomic, assign) NSInteger scrollIndex;
@property (nonatomic, strong) UIImageView *currentShowImageView;

//UI
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation FCPhotoBrowerViewController

- (void)dealloc{
    NSLog(@"FCPhotoBrowerViewController dealloc");
}

- (instancetype)initWithImageLinkArray:(NSArray<NSString *> *)imageLinkArray thumbnailArray:(NSArray<UIImageView *> *)thumbnailArray index:(NSUInteger)index{
    if(self = [super init]){
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self;
        if(imageLinkArray){
            _imageLinkArray = [imageLinkArray copy];
        }
        if(thumbnailArray){
            _thumbnailArray = [thumbnailArray copy];
        }
        if(index < self.thumbnailArray.count){
            _currentShowImageView = self.thumbnailArray[index];
            _scrollIndex = index;
        }else{
            _currentShowImageView = self.thumbnailArray.firstObject;
            _scrollIndex = index;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self configUI];
}

#pragma mark - pubilc method
- (void)showBrowerFromVC:(UIViewController *)sourceVC{
    self.collectionView.hidden = YES;
    [sourceVC presentViewController:self animated:YES completion:^{
        self.collectionView.hidden = NO;
        
    }];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.scrollIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
}

- (void)hideBrowerView{
    self.collectionView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - ui
- (void)configUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = self.view.frame.size;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor blackColor];
    [_collectionView registerClass:[FCPhotoBrowerCell class] forCellWithReuseIdentifier:[FCPhotoBrowerCell description]];
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
    _collectionView.hidden = YES;
}

#pragma mark - collection delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.thumbnailArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FCPhotoBrowerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[FCPhotoBrowerCell description] forIndexPath:indexPath];
    
    UIImageView *imageView = self.thumbnailArray[indexPath.row];
    [cell configCellthumbnail:imageView.image imageLink:(indexPath.row < self.imageLinkArray.count?self.imageLinkArray[indexPath.row]:nil)];
    __weak typeof(self) weakSelf = self;
    cell.singleTapGestureBlock = ^{
        [weakSelf hideBrowerView];
    };
    cell.longPressGestureBlock = ^{
        
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self hideBrowerView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _scrollIndex = (NSInteger)(scrollView.contentOffset.x/scrollView.width);
    _currentShowImageView = self.thumbnailArray[_scrollIndex];
}

#pragma mark - translation delegate
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [[FCBrowerTransition alloc] initWithImageView:self.currentShowImageView];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    FCPhotoBrowerCell *currentShowCell = (FCPhotoBrowerCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.scrollIndex inSection:0]];
    return [[FCBrowerTransition alloc] initDismissWithImageView:self.currentShowImageView startImageView:[currentShowCell currentImageView]];
}


@end
