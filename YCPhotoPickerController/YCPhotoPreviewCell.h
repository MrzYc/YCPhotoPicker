//
//  YCPhotoPreviewCell.h
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/5/3.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCAssetModel;
@interface YCAssetPreviewCell : UICollectionViewCell

@property (nonatomic, strong) YCAssetModel *model;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
- (void)configSubviews;
- (void)photoPreviewCollectionViewDidScroll;
@end


@class YCAssetModel,YCProgressView,YCPhotoPreviewView;
@interface YCPhotoPreviewCell : YCAssetPreviewCell

@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);
@property (nonatomic, strong) YCPhotoPreviewView *previewView;

@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;

- (void)recoverSubviews;

@end

@interface YCPhotoPreviewView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) YCProgressView *progressView;

@property (nonatomic, assign) BOOL allowCrop;
@property (nonatomic, assign) CGRect cropRect;

@property (nonatomic, strong) YCAssetModel *model;
@property (nonatomic, strong) id asset;
@property (nonatomic, copy) void (^singleTapGestureBlock)(void);
@property (nonatomic, copy) void (^imageProgressUpdateBlock)(double progress);

@property (nonatomic, assign) int32_t imageRequestID;

- (void)recoverSubviews;

@end

@class AVPlayer, AVPlayerLayer;
@interface YCVideoPreviewCell : YCAssetPreviewCell
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) UIButton *playButton;
@property (strong, nonatomic) UIImage *cover;
- (void)pausePlayerAndShowNaviBar;
@end


@interface YCGifPreviewCell : YCAssetPreviewCell
@property (strong, nonatomic) YCPhotoPreviewView *previewView;
@end




