//
//  ViewController.m
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/4/27.
//  Copyright © 2018年 赵永闯. All rights reserved.
//  https://github.com/banchichen/TZImagePickerControlle

#import "ViewController.h"
#import "YCPhototTableVIewCell.h"
#import "UIView+Layout.h"
#import "YCPhotoPickerView.h"


#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "YCImageManager.h"
#import "YCVideoPlayerController.h"
#import "YCPhotoPreviewController.h"
#import "YCGifPhotoPreviewController.h"
#import "YCLocationManager.h"
#import "YCPhotoPickerController.h"


@interface ViewController () <UITableViewDataSource, UITableViewDelegate, YCPhototTableVIewCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    BOOL _isSelectOriginalPhoto;
    
    CGFloat _itemWH;
}

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;
@property (nonatomic, strong) UICollectionView *collectionView;
//@property (strong, nonatomic) LxGridViewFlowLayout *layout;
@property (strong, nonatomic) CLLocation *location;


@property (nonatomic, strong)  UITableView *tableView;

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, assign) NSInteger columnNumber;


// 设置开关
@property (assign, nonatomic) BOOL showTakePhoto;  ///< 在内部显示拍照按钮
@property (assign, nonatomic) BOOL  showTakeVideo;  ///< 在内部显示拍视频按钮
@property (assign, nonatomic) BOOL  sortAscending;     ///< 照片排列按修改时间升序
@property (assign, nonatomic) BOOL  allowPickingVideo; ///< 允许选择视频
@property (assign, nonatomic) BOOL  allowPickingImage; ///< 允许选择图片
@property (assign, nonatomic) BOOL  allowPickingGif;
@property (assign, nonatomic) BOOL   allowPickingOriginalPhoto; ///< 允许选择原图
@property (assign, nonatomic) BOOL   showSheet; ///< 显示一个sheet,把拍照按钮放在外面
@property (assign, nonatomic) BOOL   allowCrop;
@property (assign, nonatomic) BOOL   needCircleCrop;
@property (assign, nonatomic) BOOL   allowPickingMuitlpleVideo;


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    self.maxCount = 9;
    self.columnNumber = 3;
    
    //设置图片设置页面
    [self setsubTableView];
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

//设置图片选择器
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
    
        // set appearance / 改变相册选择页的导航栏外观
        if (iOS7Later) {
            _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        }
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[YCPhotoPreviewController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        }else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[YCPhotoPreviewController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

#pragma mark --- TZImagePickerController
- (void)pushYCImagePickerController {
    if (self.maxCount <= 0) {
        return;
    }
    
    YCPhotoPickerController *imagePickerVc = [[YCPhotoPickerController alloc] initWithMaxImagesCount:self.maxCount columnNumber:self.columnNumber delegate:self pushPhotoPickerVc:YES];
    
    imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    if (self.maxCount > 1) {
        // 1.设置目前已经选中的图片数组
        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    }
    imagePickerVc.allowTakePicture = self.showTakePhoto; // 在内部显示拍照按钮
    imagePickerVc.allowTakeVideo = self.showTakeVideo;   // 在内部显示拍视频按
    imagePickerVc.videoMaximumDuration = 10; // 视频最大拍摄时间
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = self.allowPickingVideo;
    imagePickerVc.allowPickingImage = self.allowPickingImage;
    imagePickerVc.allowPickingOriginalPhoto = self.allowPickingOriginalPhoto;
    imagePickerVc.allowPickingGif = self.allowPickingGif;
    imagePickerVc.allowPickingMultipleVideo = self.allowPickingMuitlpleVideo; // 是否可以多选视频
    // 4. 照片排列按修改时间升序
    imagePickerVc.sortAscendingByModificationDate = self.sortAscending;
    /// 5. 单选模式,maxImagesCount为1时才生效
    imagePickerVc.showSelectBtn = NO;
    imagePickerVc.allowCrop = self.allowCrop;
    imagePickerVc.needCircleCrop = self.needCircleCrop;
    // 设置竖屏下的裁剪尺寸
    NSInteger left = 30;
    NSInteger widthHeight = self.view.yc_width - 2 * left;
    NSInteger top = (self.view.yc_height - widthHeight) / 2;
    imagePickerVc.cropRect = CGRectMake(left, top, widthHeight, widthHeight);
    imagePickerVc.statusBarStyle = UIStatusBarStyleLightContent;
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}


#pragma mark - UIImagePickerController
- (void)takePhoto {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if ((authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) && iOS7Later) {
        // 无相机权限 做一个友好的提示
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法使用相机" message:@"请在iPhone的""设置-隐私-相机""中允许访问相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }else if (authStatus == AVAuthorizationStatusNotDetermined) {
        // fix issue 466, 防止用户首次拍照拒绝授权时相机页黑屏
        if (iOS7Later) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self takePhoto];
                    });
                }
            }];
        }else {
            [self takePhoto];
        }
    } else if ([YCImageManager authorizationStatus] == 2) {  // 已被拒绝，没有相册权限，将无法保存拍的照片
        if (iOS8Later) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"无法访问相册" message:@"请在iPhone的""设置-隐私-相册""中允许访问相册" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }else if ([YCImageManager authorizationStatus] == 0) {
        [[YCImageManager manager] requestAuthorizationWithCompletion:^{
            [self takePhoto];
        }];
    }else {
        [self pushImagePickerController];
    }
}


#pragma clang diagnostic pop

// 调用相机
- (void)pushImagePickerController {
    // 提前定位
    __weak typeof(self) weakSelf = self;
    [[YCLocationManager manager] startLocationWithSuccessBlock:^(NSArray<CLLocation *> *locations) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = [locations firstObject];
    } failureBlock:^(NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.location = nil;
    }];
    
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerVc.sourceType = sourceType;
        if(iOS8Later) {
            _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        }
        [self presentViewController:_imagePickerVc animated:YES completion:nil];
    } else {
        NSLog(@"模拟器中无法打开照相机,请在真机中使用");
    }
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        YCPhotoPickerController *tzImagePickerVc = [[YCPhotoPickerController alloc] initWithMaxImagesCount:1 delegate:self];
        tzImagePickerVc.sortAscendingByModificationDate = self.sortAscending;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[YCImageManager manager] savePhotoWithImage:image location:self.location completion:^(NSError *error) {
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            }else {
                [[YCImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES needFetchAssets:NO completion:^(YCAlbumModel *model) {
                    [[YCImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<YCAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        YCAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                        if (self.allowCrop) { // 允许裁剪,去裁剪
                            YCPhotoPickerController *imagePicker = [[YCPhotoPickerController alloc] initCropTypeWithAsset:assetModel.asset photo:image completion:^(UIImage *cropImage, id asset) {
                                [self refreshCollectionViewWithAddedAsset:asset image:cropImage];
                            }];
                            imagePicker.needCircleCrop = self.needCircleCrop;
                            imagePicker.circleCropRadius = 100;
                            [self presentViewController:imagePicker animated:YES completion:nil];
                        }else {
                            [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];
                        }
                    }];
                }];
            }
        }];
    }
}

- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    [_selectedAssets addObject:asset];
    [_selectedPhotos addObject:image];
    [_collectionView reloadData];
    if ([asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = asset;
        NSLog(@"location:%@",phAsset.location);
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushYCImagePickerController];
    }
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }
}

#pragma mark - TZImagePickerControllerDelegate
/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(YCPhotoPickerController *)picker {
    // NSLog(@"cancel");
}

- (void)imagePickerController:(YCPhotoPickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos {
    _selectedPhotos = [NSMutableArray arrayWithArray:photos];
    _selectedAssets = [NSMutableArray arrayWithArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    [_collectionView reloadData];
    // 1.打印图片名字
    [self printAssetsName:assets];
    // 2.图片位置信息
    if (iOS8Later) {
        for (PHAsset *phAsset in assets) {
            NSLog(@"location:%@",phAsset.location);
        }
    }
}

// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(YCPhotoPickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    [[YCImageManager manager] getVideoOutputPathWithAsset:asset presetName:AVAssetExportPreset640x480 success:^(NSString *outputPath) {
        NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
        // Export completed, send video here, send by outputPath or NSData
        // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    } failure:^(NSString *errorMessage, NSError *error) {
        NSLog(@"视频导出失败:%@,error:%@",errorMessage, error);
    }];
    [_collectionView reloadData];
}

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(YCPhotoPickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[animatedImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    [_collectionView reloadData];
}

// Decide album show or not't
// 决定相册显示与否
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result {
    /*
     if ([albumName isEqualToString:@"个人收藏"]) {
     return NO;
     }
     if ([albumName isEqualToString:@"视频"]) {
     return NO;
     }*/
    return YES;
}
// Decide asset show or not't
// 决定asset显示与否
- (BOOL)isAssetCanSelect:(id)asset {
    return YES;
}

#pragma mark - Click Event
- (void)deleteBtnClik:(UIButton *)sender {
    [_selectedPhotos removeObjectAtIndex:sender.tag];
    [_selectedAssets removeObjectAtIndex:sender.tag];
    
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
        [self->_collectionView deleteItemsAtIndexPaths:@[indexPath]];
    } completion:^(BOOL finished) {
        [self->_collectionView reloadData];
    }];
}



#pragma mark --- 设置tableView
- (void)setsubTableView {
    self.titleArr = @[@"照片最大可选张数",@"每行展示照片张数",@"显示内部拍照按钮",@"照片按修改时间升序排列",@"允许选择视频",@"允许选择照片",@"允许选择照片原图",@"允许选择Gif图片",@"把照片按钮放在外面",@"单选模式下允许剪裁",@"使用圆形剪裁框",@"允许多选视频/GIF图片",@"显示内部拍摄视频按钮"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.rowHeight = 40;
    [tableView registerClass:[YCPhototTableVIewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    
    YCPhotoPickerView *pickView = [YCPhotoPickerView  PickViewInitWithFrame:CGRectMake(0, 0, self.view.yc_width, 100)];
    tableView.tableFooterView = pickView;
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YCPhototTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.delegate = self;
    cell.titleLabel.text = self.titleArr[indexPath.row];
    if (indexPath.row == 0) {
        cell.switchView.hidden = YES;
        cell.tfView.hidden = NO;
        self.maxCount = cell.tfView.text.integerValue;
    }else if (indexPath.row == 1) {
        cell.switchView.hidden = YES;
        cell.tfView.hidden = NO;
        self.columnNumber = cell.tfView.text.integerValue;
    }
    return cell;
}

#pragma  mark -- YCPhototTableVIewCellDelegate
- (void)switchViewAction:(BOOL)isON withTitle:(NSString *)title {
    if ([title isEqualToString:@"显示内部拍照按钮"]) {
        if (isON) {
            self.showSheet = NO;
            self.allowPickingImage = YES;
        }
    }else if([title isEqualToString:@"照片按修改时间升序排列"]) {
        
    }else if([title isEqualToString:@"允许选择视频"]) {
        
    }else if([title isEqualToString:@"允许选择照片"]) {
        
    }else if([title isEqualToString:@"允许选择照片原图"]) {
        
    }else if([title isEqualToString:@"允许选择Gif图片"]) {
        
    }else if([title isEqualToString:@"把照片按钮放在外面"]) {
        
    }else if([title isEqualToString:@"单选模式下允许剪裁"]) {
        
    }else if([title isEqualToString:@"使用圆形剪裁框"]) {
        
    }else if([title isEqualToString:@"允许多选视频/GIF图片"]) {
        
    }else if([title isEqualToString:@"显示内部拍摄视频按钮"]) {
        if (isON) {
            self.showSheet = NO;
            self.allowPickingImage = YES;
        }
    }
    NSLog(@"%@", title);
    [self.view endEditing:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        // NSLog(@"图片名字:%@",fileName);
    }
}


@end
