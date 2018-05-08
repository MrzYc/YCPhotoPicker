//
//  YCPhotoCollectionViewCell.m
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/4/28.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import "YCPhotoCollectionViewCell.h"
#import "UIView+Layout.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "YCPhotoPickerController.h"


@implementation YCPhotoCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setSubviews];
    }
    return self;
}


- (void)setSubviews {
    _imageView = [[UIImageView alloc] init];
    _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageView];
    self.clipsToBounds = YES;
    
    _videoImageView = [[UIImageView alloc] init];
    _videoImageView.image = [UIImage imageNamedFromMyBundle:@"MMVideoPreviewPlay"];
    _videoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, -10);
    _deleteBtn.alpha = 0.6;
    [self.contentView addSubview:_deleteBtn];

    _gifLable = [[UILabel alloc] init];
    _gifLable.text = @"GIF";
    _gifLable.textColor = [UIColor whiteColor];
    _gifLable.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
    _gifLable.textAlignment = NSTextAlignmentCenter;
    _gifLable.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:_gifLable];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    _gifLable.frame = CGRectMake(self.yc_width - 25, self.yc_height - 14, 25, 14);
    _deleteBtn.frame = CGRectMake(self.yc_width - 36, 0, 36, 36);
    CGFloat width = self.yc_width / 3.0;
    _videoImageView.frame = CGRectMake(width, width, width, width);
}

- (void)setAsset:(id)asset {
    _asset = asset;
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        _videoImageView.hidden = phAsset.mediaType != PHAssetMediaTypeVideo;
        _gifLable.hidden = ![[phAsset valueForKey:@"filename"] yc_containsString:@"GIF"];        
    }else if ([asset isKindOfClass:[ALAsset class]]) {
        ALAsset *alAsset = asset;
        _videoImageView.hidden = ![[alAsset valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypeVideo];
        _gifLable.hidden = YES;
    }
}

- (void)setRow:(NSInteger)row {
    _row = row;
    _deleteBtn.tag = row;
}

- (UIView *)snapshotView {
    UIView *snapshotView = [[UIView alloc] init];
    UIView *cellSnapshotView = nil;
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]) {
        cellSnapshotView = [self snapshotViewAfterScreenUpdates:NO];
    }else {
        CGSize size = CGSizeMake(self.bounds.size.width + 20, self.bounds.size.height + 20);
        UIGraphicsBeginImageContextWithOptions(size, self.opaque, 0);
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage * cellSnapshotImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cellSnapshotView = [[UIImageView alloc]initWithImage:cellSnapshotImage];
    }
    
    snapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);
    cellSnapshotView.frame = CGRectMake(0, 0, cellSnapshotView.frame.size.width, cellSnapshotView.frame.size.height);

    [snapshotView addSubview:cellSnapshotView];
    return snapshotView;
}






@end
