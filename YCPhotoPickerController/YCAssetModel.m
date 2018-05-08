//
//  YCAssetModel.m
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/5/3.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import "YCAssetModel.h"
#import "YCImageManager.h"

@implementation YCAssetModel

+ (instancetype)modelWithAsset:(id)asset type:(YCAssetModelMediaType)type {
    YCAssetModel *model = [[YCAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}

+ (instancetype)modelWithAsset:(id)asset type:(YCAssetModelMediaType)type timeLength:(NSString *)timeLength {
    YCAssetModel *model = [self modelWithAsset:asset type:type];
    model.timeLength = timeLength;
    return model;
}

@end



@implementation YCAlbumModel

- (void)setResult:(id)result needFetchAssets:(BOOL)needFetchAssets {
    _result = result;
    if (needFetchAssets) {
        [[YCImageManager manager] getAssetsFromFetchResult:result completion:^(NSArray<YCAssetModel *> *models) {
            self->_models = models;
            if (self->_selectedModels) {
                [self checkSelectedModels];
            }
        }];
    }
}


- (void)setSelectedModels:(NSArray *)selectedModels {
    _selectedModels = selectedModels;
    if (!_models) {
        [self checkSelectedModels];
    }
}

- (void)checkSelectedModels {
    self.selectedCount = 0;
    NSMutableArray *selectedAssets = [NSMutableArray array];
    for (YCAssetModel *model in _selectedModels) {
        [selectedAssets addObject:model.asset];
    }
    
    for (YCAssetModel *model in _models) {
        if ([[YCImageManager manager] isAssetsArray:selectedAssets containAsset:model.asset]) {
            self.selectedCount ++;
        }
    }
}

- (NSString *)name {
    if (!_name) {
        return _name;
    }
    return @"";
}

@end
