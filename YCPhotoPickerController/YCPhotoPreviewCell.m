//
//  YCPhotoPreviewCell.m
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/5/3.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import "YCPhotoPreviewCell.h"
#import "YCAssetModel.h"
#import "UIView+Layout.h"
#import "YCImageManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "YCPhotoPickerController.h"
#import "YCProgressView.h"
#import "YCImageCropManager.h"

@implementation YCAssetPreviewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self configSubviews];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoPreviewCollectionViewDidScroll) name:@"photoPreviewCollectionViewDidScroll" object:nil];
    }
    return self;
}

- (void)configSubviews {
    
}

#pragma mark - Notification
- (void)photoPreviewCollectionViewDidScroll {
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@implementation YCPhotoPreviewCell

- (void)configSubviews {
    self.previewView = [[YCPhotoPreviewView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    [self.previewView setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.singleTapGestureBlock) {
            strongSelf.singleTapGestureBlock();
        }
    }];
    
    [self.previewView setImageProgressUpdateBlock:^(double progress) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.imageProgressUpdateBlock) {
            strongSelf.imageProgressUpdateBlock(progress);
        }
    }];
    [self addSubview:self.previewView];
}

- (void)setModel:(YCAssetModel *)model {
    [super setModel:model];
    _previewView.asset = model.asset;
}

- (void)recoverSubviews {
    [_previewView recoverSubviews];
}

- (void)setAllowCrop:(BOOL)allowCrop {
    _allowCrop = allowCrop;
    _previewView.allowCrop = allowCrop;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.previewView.frame = self.bounds;
}

@end


@interface YCPhotoPreviewView()<UIScrollViewDelegate>

@end

@implementation YCPhotoPreviewView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        if (iOS11Later) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [self addSubview:_scrollView];
        
        _imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        _imageContainerView.contentMode = UIViewContentModeScaleAspectFill;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        
        [self configProgressView];
    }
    return self;
}

- (void)configProgressView {
    _progressView = [[YCProgressView alloc] init];
    _progressView.hidden = YES;
    [self addSubview:_progressView];
}

- (void)setModel:(YCAssetModel *)model {
    _model = model;
    [_scrollView setZoomScale:1.0 animated:NO];
    if (model.type == YCAssetModelMediaTypePhotoGif) {
        // 先显示缩略图
        [[YCImageManager manager] getPhotoWithAsset:model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
            self.imageView.image = photo;
            [self resizeSubviews];
            // 再显示gif动图
            [[YCImageManager manager] getOriginalPhotoDataWithAsset:model.asset completion:^(NSData *data, NSDictionary *info, BOOL isDegraded) {
                if (!isDegraded) {
                    self.imageView.image = [UIImage sd_yc_animatedGIFWithData:data];
                    [self resizeSubviews];
                }
            }];
        } progressHandler:nil networkAccessAllowed:NO];
    } else {
        self.asset = model.asset;
    }
}

- (void)setAsset:(id)asset {
    if (_asset && self.imageRequestID) {
        [[PHImageManager defaultManager] cancelImageRequest:self.imageRequestID];
    }
    
    _asset = asset;
    self.imageRequestID = [[YCImageManager manager] getPhotoWithAsset:asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (![asset isEqual:self->_asset]) return;
        self.imageView.image = photo;
        [self resizeSubviews];
        self->_progressView.hidden = YES;
        if (self.imageProgressUpdateBlock) {
            self.imageProgressUpdateBlock(1);
        }
        if (!isDegraded) {
            self.imageRequestID = 0;
        }
    } progressHandler:^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
        if (![asset isEqual:self->_asset]) return;
        self->_progressView.hidden = NO;
        [self bringSubviewToFront:self->_progressView];
        progress = progress > 0.02 ? progress : 0.02;
        self->_progressView.progress = progress;
        if (self.imageProgressUpdateBlock && progress < 1) {
            self.imageProgressUpdateBlock(progress);
        }
        
        if (progress >= 1) {
            self->_progressView.hidden = YES;
            self.imageRequestID = 0;
        }
    } networkAccessAllowed:YES];
}

- (void)recoverSubviews {
    [_scrollView setZoomScale:1.0 animated:NO];
    [self resizeSubviews];
}

- (void)resizeSubviews {
    _imageContainerView.yc_origin = CGPointZero;
    _imageContainerView.yc_width = self.scrollView.yc_width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.yc_height / self.scrollView.yc_width) {
        _imageContainerView.yc_height = floor(image.size.height / (image.size.width / self.scrollView.yc_width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.scrollView.yc_width;
        if (height < 1 || isnan(height)) height = self.yc_height;
        height = floor(height);
        _imageContainerView.yc_height = height;
        _imageContainerView.yc_centerY = self.yc_height / 2;
    }
    
    if (_imageContainerView.yc_height > self.yc_height && _imageContainerView.yc_height - self.yc_height <= 1) {
        _imageContainerView.yc_height = self.yc_height;
    }
    
    CGFloat contentSizeH = MAX(_imageContainerView.yc_height, self.yc_height);
    _scrollView.contentSize = CGSizeMake(self.scrollView.yc_width, contentSizeH);
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.yc_height <= self.yc_height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;

    
    [self refreshScrollViewContentSize];
}

- (void)setAllowCrop:(BOOL)allowCrop {
    _allowCrop = allowCrop;
    _scrollView.maximumZoomScale = allowCrop ? 4.0 : 2.5;
    
    if ([self.asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)self.asset;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        // 优化超宽图片的显示
        if (aspectRatio > 1.5) {
            self.scrollView.maximumZoomScale *= aspectRatio / 1.5;
        }
    }
}

- (void)refreshScrollViewContentSize  {
    if (_allowCrop) {
        // 1.7.2 如果允许裁剪,需要让图片的任意部分都能在裁剪框内，于是对_scrollView做了如下处理：
        // 1.让contentSize增大(裁剪框右下角的图片部分)
        CGFloat contentWidthAdd = self.scrollView.yc_width - CGRectGetMaxX(_cropRect);
        CGFloat contentHeightAdd = (MIN(_imageContainerView.yc_height, self.yc_height) - self.cropRect.size.height) / 2;
        CGFloat newSizeW = self.scrollView.contentSize.width + contentWidthAdd;
        CGFloat newSizeH = MAX(self.scrollView.contentSize.height, self.yc_height) + contentHeightAdd;
        _scrollView.contentSize = CGSizeMake(newSizeW, newSizeH);
        _scrollView.alwaysBounceVertical = YES;
        // 2.让scrollView新增滑动区域（裁剪框左上角的图片部分）
        if (contentHeightAdd > 0 || contentWidthAdd > 0) {
            _scrollView.contentInset = UIEdgeInsetsMake(contentHeightAdd, _cropRect.origin.x, 0, 0);
        } else {
            _scrollView.contentInset = UIEdgeInsetsZero;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _scrollView.frame = CGRectMake(10, 0, self.yc_width - 20, self.yc_height);
    static CGFloat progressWH = 40;
    CGFloat progressX = (self.yc_width - progressWH) / 2;
    CGFloat progressY = (self.yc_height - progressWH) / 2;
    _progressView.frame = CGRectMake(progressX, progressY, progressWH, progressWH);
    
    [self recoverSubviews];
}


#pragma mark -- UITapGestureRecognizer Event
- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        _scrollView.contentInset = UIEdgeInsetsZero;
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

#pragma mark -- UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self refreshImageContainerViewCenter];
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [self refreshScrollViewContentSize];
}

#pragma mark - Private
- (void)refreshImageContainerViewCenter {
    CGFloat offsetX = (_scrollView.yc_width > _scrollView.contentSize.width) ? ((_scrollView.yc_width - _scrollView.contentSize.width) * 0.5) : 0.0;
    CGFloat offsetY = (_scrollView.yc_height > _scrollView.contentSize.height) ? ((_scrollView.yc_height - _scrollView.contentSize.height) * 0.5) : 0.0;
    self.imageContainerView.center = CGPointMake(_scrollView.contentSize.width * 0.5 + offsetX, _scrollView.contentSize.height * 0.5 + offsetY);
}

@end

@implementation YCVideoPreviewCell

- (void)configSubviews {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)configPlayButton {
    if (_playButton) {
        [_playButton removeFromSuperview];
    }
    [_playButton setImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
    [_playButton setImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlayHL"] forState:UIControlStateHighlighted];
    [_playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_playButton];
}

- (void)setModel:(YCAssetModel *)model {
    [super setModel:model];
    [self configMoviePlayer];
}


- (void)configMoviePlayer {
    if (_player) {
        [_playerLayer removeFromSuperlayer];
        _playerLayer = nil;
        [_player pause];
        _player = nil;
    }
    
    [[YCImageManager manager] getPhotoWithAsset:self.model.asset completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        self->_cover = photo;
    }];
    
    [[YCImageManager manager] getVideoWithAsset:self.model.asset completion:^(AVPlayerItem *playerItem, NSDictionary *info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self->_player = [AVPlayer playerWithPlayerItem:playerItem];
            self->_playerLayer = [AVPlayerLayer playerLayerWithPlayer:self->_player];
            self->_playerLayer.backgroundColor = [UIColor blackColor].CGColor;
            self->_playerLayer.frame = self.bounds;
            [self.layer addSublayer:self->_playerLayer];
            [self configPlayButton];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pausePlayerAndShowNaviBar) name:AVPlayerItemDidPlayToEndTimeNotification object:self->_player.currentItem];
        });
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _playerLayer.frame = self.bounds;
    _playButton.frame = CGRectMake(0, 64, self.yc_width, self.yc_height - 64 - 44);
}

- (void)photoPreviewCollectionViewDidScroll {
    [self pausePlayerAndShowNaviBar];
}

#pragma mark --- Click Event
- (void)playButtonClick {
    CMTime currentTime = _player.currentItem.currentTime;
    CMTime durationTime = _player.currentItem.duration;
    if (_player.rate == 0.0f) {
        if (currentTime.value == durationTime.value) [_player.currentItem seekToTime:CMTimeMake(0, 1)];
        [_player play];
        [_playButton setImage:nil forState:UIControlStateNormal];
        if (iOS7Later) [UIApplication sharedApplication].statusBarHidden = YES;
        if (self.singleTapGestureBlock) {
            self.singleTapGestureBlock();
        }
    }else {
        [self pausePlayerAndShowNaviBar];
    }
}

- (void)pausePlayerAndShowNaviBar {
    if (_player.rate != 0.0) {
        [_player pause];
        [_playButton setImage:[UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay"] forState:UIControlStateNormal];
        if (self.singleTapGestureBlock) {
            self.singleTapGestureBlock();
        }
    }
}

@end


@implementation YCGifPreviewCell

- (void)configSubviews {
    [self configPreviewView];
}

- (void)configPreviewView {
    _previewView = [[YCPhotoPreviewView alloc] initWithFrame:CGRectZero];
    __weak typeof(self) weakSelf = self;
    [_previewView setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf signleTapAction];
    }];
    [self addSubview:_previewView];
}

- (void)setModel:(YCAssetModel *)model {
    [super setModel:model];
    _previewView.model = self.model;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _previewView.frame = self.bounds;
}

#pragma mark - Click Event

- (void)signleTapAction {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}


@end
