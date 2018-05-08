//
//  YCPhotoPickerView.m
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/4/28.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import "YCPhotoPickerView.h"
#import "YCPhotoCollectionViewCell.h"




@interface YCPhotoPickerView() <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation YCPhotoPickerView

+ (instancetype)PickViewInitWithFrame:(CGRect)frame {
    
    YCPhotoPickerView *photoView = [[YCPhotoPickerView alloc] initWithFrame:frame];
    [photoView setCollectionViewWithFrame:frame];
    return photoView;
}

- (void)setCollectionViewWithFrame:(CGRect)frame {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(60, 60);
    _collectionView.alwaysBounceVertical = YES;
    CGFloat rgb = 244 / 255.0;
    _collectionView.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:1.0];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    [collectionView registerClass:[YCPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.contentInset = UIEdgeInsetsMake(4, 4, 4, 4);
    collectionView.contentSize = CGSizeMake(0, 300);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:collectionView];
    
    

    
}



- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor lightGrayColor];
    return cell;
}







@end
