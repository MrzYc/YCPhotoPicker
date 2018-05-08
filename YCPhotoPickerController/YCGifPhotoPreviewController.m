//
//  YCGifPhotoPreviewController.m
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/5/7.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import "YCGifPhotoPreviewController.h"
#import "YCPhotoPickerController.h"
#import "YCAssetModel.h"
#import "UIView+Layout.h"
#import "YCPhotoPreviewCell.h"
#import "YCImageManager.h"


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface YCGifPhotoPreviewController ()
{
    UIView *_toolBar;
    UIButton *_doneButton;
    UIProgressView *_progress;
    
    YCPhotoPreviewView *_previewView;
    
    UIStatusBarStyle _originStatusBarStyle;
}
    
@end

@implementation YCGifPhotoPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    YCPhotoPickerController *tzImagePickerVc = (YCPhotoPickerController *)self.navigationController;
    if (tzImagePickerVc) {
        self.navigationItem.title = [NSString stringWithFormat:@"GIF %@",tzImagePickerVc.previewBtnTitleStr];
    }
    [self configPreviewView];
    [self configBottomToolBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _originStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;
    [UIApplication sharedApplication].statusBarStyle = iOS7Later ? UIStatusBarStyleLightContent : UIStatusBarStyleBlackOpaque;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = _originStatusBarStyle;
}

- (void)configPreviewView {
    _previewView = [[YCPhotoPreviewView alloc] initWithFrame:CGRectZero];
    _previewView.model = self.model;
    __weak typeof(self) weakSelf = self;
    [_previewView setSingleTapGestureBlock:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf signleTapAction];
    }];
    [self.view addSubview:_previewView];
}

- (void)configBottomToolBar {
    _toolBar = [[UIView alloc] initWithFrame:CGRectZero];
    CGFloat rgb = 34 / 255.0;
    _toolBar.backgroundColor = [UIColor colorWithRed:rgb green:rgb blue:rgb alpha:0.7];

    _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _doneButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_doneButton addTarget:self action:@selector(doneButtonClick) forControlEvents:UIControlEventTouchUpInside];
    YCPhotoPickerController *tzImagePickerVc = (YCPhotoPickerController *)self.navigationController;
    if (tzImagePickerVc) {
        [_doneButton setTitle:tzImagePickerVc.doneBtnTitleStr forState:UIControlStateNormal];
        [_doneButton setTitleColor:tzImagePickerVc.oKButtonTitleColorNormal forState:UIControlStateNormal];
    }else {
        [_doneButton setTitle:[NSBundle localizedStringForKey:@"Done"] forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor colorWithRed:(83/255.0) green:(179/255.0) blue:(17/255.0) alpha:1.0] forState:UIControlStateNormal];
    }
    [_toolBar addSubview:_doneButton];

    UILabel *byteLabel = [[UILabel alloc] init];
    byteLabel.textColor = [UIColor whiteColor];
    byteLabel.font = [UIFont systemFontOfSize:13];
    byteLabel.frame = CGRectMake(10, 0, 100, 44);
    [[YCImageManager manager] getPhotosBytesWithArray:@[_model] completion:^(NSString *totalBytes) {
        byteLabel.text = totalBytes;
    }];
    [_toolBar addSubview:byteLabel];
    [self.view addSubview:_toolBar];
}

#pragma mark - Layout
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    _previewView.frame = self.view.bounds;
    _previewView.scrollView.frame = self.view.bounds;
    CGFloat toolBarHeight = [YCCommonTools yc_isIPhoneX] ? 44 + (83 - 49) : 44;
    _toolBar.frame = CGRectMake(0, self.view.yc_height - toolBarHeight, self.view.yc_width, toolBarHeight);
    _doneButton.frame = CGRectMake(self.view.yc_width - 44 - 12, 0, 44, 44);
}

#pragma mark -- Click Event
- (void)signleTapAction {
    _toolBar.hidden = !_toolBar.isHidden;
    [self.navigationController setNavigationBarHidden:_toolBar.isHidden];
    YCPhotoPickerController *tzImagePickerVc = (YCPhotoPickerController *)self.navigationController;
    if (iOS7Later) {
        if (_toolBar.isHidden) {
            [UIApplication sharedApplication].statusBarHidden = YES;
        } else if (tzImagePickerVc.needShowStatusBar) {
            [UIApplication sharedApplication].statusBarHidden = NO;
        }
    }
}

- (void)doneButtonClick {
    if (self.navigationController) {
        YCPhotoPickerController *imagePickerVc = (YCPhotoPickerController *)self.navigationController;
        if (imagePickerVc.autoDismiss) {
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                [self callDelegateMethod];
            }];
        } else {
            [self callDelegateMethod];
        }
    } else {
        [self dismissViewControllerAnimated:YES completion:^{
            [self callDelegateMethod];
        }];
    }
}

- (void)callDelegateMethod {
    YCPhotoPickerController *imagePickerVc = (YCPhotoPickerController *)self.navigationController;
    UIImage *animatedImage = _previewView.imageView.image;
    if ([imagePickerVc.pickerDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingGifImage:sourceAssets:)]) {
        [imagePickerVc.pickerDelegate imagePickerController:imagePickerVc didFinishPickingGifImage:animatedImage sourceAssets:_model.asset];
    }
    if (imagePickerVc.didFinishPickingGifImageHandle) {
        imagePickerVc.didFinishPickingGifImageHandle(animatedImage,_model.asset);
    }
}

#pragma clang diagnostic pop

@end
