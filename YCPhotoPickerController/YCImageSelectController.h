//
//  YCImageSelectController.h
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/5/3.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import <UIKit/UIKit.h>

@class YCAlbumModel;

@interface YCImageSelectController : UIViewController

@property (nonatomic, assign) BOOL isFirstAppear;
@property (nonatomic, assign) NSInteger columnNumber;
@property (nonatomic, strong) YCAlbumModel *model;

@end

@interface YCCollectionView : UICollectionView

@end
