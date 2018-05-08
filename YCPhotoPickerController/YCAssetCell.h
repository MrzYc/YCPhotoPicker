//
//  YCAssetCell.h
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/5/7.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

typedef enum : NSUInteger {
    YCAssetCellTypePhoto = 0,
    YCAssetCellTypeLivePhoto,
    YCAssetCellTypePhotoGif,
    YCAssetCellTypeVideo,
    YCAssetCellTypeAudio,
} YCAssetCellType;

@class YCAssetModel;

@interface YCAssetCell : UICollectionViewCell

@property (weak, nonatomic) UIButton *selectPhotoButton;
@property (nonatomic, strong) YCAssetModel *model;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);
@property (nonatomic, assign) YCAssetCellType type;
@property (nonatomic, assign) BOOL allowPickingGif;
@property (nonatomic, assign) BOOL allowPickingMultipleVideo;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;

@property (nonatomic, copy) NSString *photoSelImageName;
@property (nonatomic, copy) NSString *photoDefImageName;

@property (nonatomic, assign) BOOL showSelectBtn;
@property (assign, nonatomic) BOOL allowPreview;


@end

@class YCAlbumModel;
@interface YCAlbumCell : UITableViewCell

@property (nonatomic, strong) YCAlbumModel *model;
@property (weak, nonatomic) UIButton *selectedCountButton;

@end


@interface YCAssetCameraCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end




