//
//  YCPhotoPickerController.h
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/5/2.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YCAssetModel.h"
#import "NSBundle+YCPhotoPicker.h"
#import "YCImageManager.h"


#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)
#define iOS11Later ([UIDevice currentDevice].systemVersion.floatValue >= 11.0f)


@protocol YCPhotoPickerControllerDelegate;
@interface YCPhotoPickerController : UINavigationController

#pragma mark - 初始化方法
/// Use this init method / 用这个初始化方法
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<YCPhotoPickerControllerDelegate>)delegate;
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<YCPhotoPickerControllerDelegate>)delegate;
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount columnNumber:(NSInteger)columnNumber delegate:(id<YCPhotoPickerControllerDelegate>)delegate pushPhotoPickerVc:(BOOL)pushPhotoPickerVc;
/// This init method just for previewing photos / 用这个初始化方法以预览图片
- (instancetype)initWithSelectedAssets:(NSMutableArray *)selectedAssets selectedPhotos:(NSMutableArray *)selectedPhotos index:(NSInteger)index;
/// This init method for crop photo / 用这个初始化方法以裁剪图片
- (instancetype)initCropTypeWithAsset:(id)asset photo:(UIImage *)photo completion:(void (^)(UIImage *cropImage,id asset))completion;

#pragma mark - 相关属性

/// Default is 9 / 默认最大可选9张图片
@property (nonatomic, assign) NSInteger maxImagesCount;

/// The minimum count photos user must pick, Default is 0
/// 最小照片必选张数,默认是0
@property (nonatomic, assign) NSInteger minImagesCount;

/// Always enale the done button, not require minimum 1 photo be picked
/// 让完成按钮一直可以点击，无须最少选择一张图片
@property (nonatomic, assign) BOOL alwaysEnableDoneBtn;

/// Sort photos ascending by modificationDate，Default is YES
/// 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
@property (nonatomic, assign) BOOL sortAscendingByModificationDate;

/// The pixel width of output image, Default is 828px / 导出图片的宽度，默认828像素宽
@property (nonatomic, assign) CGFloat photoWidth;

/// Default is 600px / 默认600像素宽
@property (nonatomic, assign) CGFloat photoPreviewMaxWidth;

/// Default is 15, While fetching photo, HUD will dismiss automatic if timeout;
/// 超时时间，默认为15秒，当取图片时间超过15秒还没有取成功时，会自动dismiss HUD；
@property (nonatomic, assign) NSInteger timeout;

/// Default is YES, if set NO, the original photo button will hide. user can't picking original photo.
/// 默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;

/// Default is YES, if set NO, user can't picking video.
/// 默认为YES，如果设置为NO,用户将不能选择视频
@property (nonatomic, assign) BOOL allowPickingVideo;
/// Default is NO / 默认为NO，为YES时可以多选视频/gif图片，和照片共享最大可选张数maxImagesCount的限制
@property (nonatomic, assign) BOOL allowPickingMultipleVideo;

/// Default is NO, if set YES, user can picking gif image.
/// 默认为NO，如果设置为YES,用户可以选择gif图片
@property (nonatomic, assign) BOOL allowPickingGif;

/// Default is YES, if set NO, user can't picking image.
/// 默认为YES，如果设置为NO,用户将不能选择发送图片
@property(nonatomic, assign) BOOL allowPickingImage;

/// Default is YES, if set NO, user can't take picture.
/// 默认为YES，如果设置为NO, 用户将不能拍摄照片
@property(nonatomic, assign) BOOL allowTakePicture;

/// Default is YES, if set NO, user can't take video.
/// 默认为YES，如果设置为NO, 用户将不能拍摄视频
@property(nonatomic, assign) BOOL allowTakeVideo;
/// Default value is 10 minutes / 视频最大拍摄时间，默认是10分钟，单位是秒
@property (assign, nonatomic) NSTimeInterval videoMaximumDuration;

/// 首选语言，如果设置了就用该语言，不设则取当前系统语言。
/// 由于目前只支持中文、繁体中文、英文、越南语。故该属性只支持zh-Hans、zh-Hant、en、vi四种值，其余值无效。
@property (copy, nonatomic) NSString *preferredLanguage;

/// 语言bundle，preferredLanguage变化时languageBundle会变化
/// 可通过手动设置bundle，让选择器支持新的的语言（需要在设置preferredLanguage后设置languageBundle）。欢迎提交PR把语言文件提交上来~
@property (strong, nonatomic) NSBundle *languageBundle;

/// Default is YES, if set NO, user can't preview photo.
/// 默认为YES，如果设置为NO,预览按钮将隐藏,用户将不能去预览照片
@property (nonatomic, assign) BOOL allowPreview;

/// Default is YES, if set NO, the picker don't dismiss itself.
/// 默认为YES，如果设置为NO, 选择器将不会自己dismiss
@property(nonatomic, assign) BOOL autoDismiss;

/// Default is YES, if set NO, in the delegate method the photos and infos will be nil, only assets hava value.
/// 默认为NO，如果设置为YES，代理方法里photos和infos会是nil，只返回assets
@property (assign, nonatomic) BOOL onlyReturnAsset;

/// The photos user have selected
/// 用户选中过的图片数组
@property (nonatomic, strong) NSMutableArray *selectedAssets;
@property (nonatomic, strong) NSMutableArray<YCAssetModel *> *selectedModels;

/// Minimum selectable photo width, Default is 0
/// 最小可选中的图片宽度，默认是0，小于这个宽度的图片不可选中
@property (nonatomic, assign) NSInteger minPhotoWidthSelectable;
@property (nonatomic, assign) NSInteger minPhotoHeightSelectable;
/// Hide the photo what can not be selected, Default is NO
/// 隐藏不可以选中的图片，默认是NO，不推荐将其设置为YES
@property (nonatomic, assign) BOOL hideWhenCanNotSelect;
/// Deprecated, Use statusBarStyle (顶部statusBar 是否为系统默认的黑色，默认为NO)
@property (nonatomic, assign) BOOL isStatusBarDefault __attribute__((deprecated("Use -statusBarStyle.")));
/// statusBar的样式，默认为UIStatusBarStyleLightContent
@property (assign, nonatomic) UIStatusBarStyle statusBarStyle;

#pragma mark --- 图片剪裁相关属性
/// Single selection mode, valid when maxImagesCount = 1
/// 单选模式,maxImagesCount为1时才生效
@property (nonatomic, assign) BOOL showSelectBtn;        ///< 在单选模式下，照片列表页中，显示选择按钮,默认为NO
@property (nonatomic, assign) BOOL allowCrop;            ///< 允许裁剪,默认为YES，showSelectBtn为NO才生效
@property (nonatomic, assign) CGRect cropRect;           ///< 裁剪框的尺寸
@property (nonatomic, assign) CGRect cropRectPortrait;   ///< 裁剪框的尺寸(竖屏)
@property (nonatomic, assign) CGRect cropRectLandscape;  ///< 裁剪框的尺寸(横屏)
@property (nonatomic, assign) BOOL needCircleCrop;       ///< 需要圆形裁剪框
@property (nonatomic, assign) NSInteger circleCropRadius;  ///< 圆形裁剪框半径大小
@property (nonatomic, copy) void (^cropViewSettingBlock)(UIView *cropView);     ///< 自定义裁剪框的其他属性

@property (nonatomic, copy) void (^navLeftBarButtonSettingBlock)(UIButton *leftButton);     ///< 自定义返回按钮样式及其属性

#pragma mark - 提示样式
- (id)showAlertWithTitle:(NSString *)title;
- (void)hideAlertView:(id)alertView;
- (void)showProgressHUD;
- (void)hideProgressHUD;
@property (nonatomic, assign) BOOL isSelectOriginalPhoto;
@property (assign, nonatomic) BOOL needShowStatusBar;

#pragma mark - 照片名字
@property (nonatomic, copy) NSString *takePictureImageName;
@property (nonatomic, copy) NSString *photoSelImageName;
@property (nonatomic, copy) NSString *photoDefImageName;
@property (nonatomic, copy) NSString *photoOriginSelImageName;
@property (nonatomic, copy) NSString *photoOriginDefImageName;
@property (nonatomic, copy) NSString *photoPreviewOriginDefImageName;
@property (nonatomic, copy) NSString *photoNumberIconImageName;

#pragma mark -- 外观样式相关属性
/// Appearance / 外观颜色 + 按钮文字
@property (nonatomic, strong) UIColor *oKButtonTitleColorNormal;
@property (nonatomic, strong) UIColor *oKButtonTitleColorDisabled;
@property (nonatomic, strong) UIColor *naviBgColor;
@property (nonatomic, strong) UIColor *naviTitleColor;
@property (nonatomic, strong) UIFont *naviTitleFont;
@property (nonatomic, strong) UIColor *barItemTextColor;
@property (nonatomic, strong) UIFont *barItemTextFont;

@property (nonatomic, copy) NSString *doneBtnTitleStr;
@property (nonatomic, copy) NSString *cancelBtnTitleStr;
@property (nonatomic, copy) NSString *previewBtnTitleStr;
@property (nonatomic, copy) NSString *fullImageBtnTitleStr;
@property (nonatomic, copy) NSString *settingBtnTitleStr;
@property (nonatomic, copy) NSString *processHintStr;

#pragma  mark -- 相关事件响应方法
- (void)cancelButtonClick;

// The picker should dismiss itself; when it dismissed these handle will be called.
// You can also set autoDismiss to NO, then the picker don't dismiss itself.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的handle
// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它

@property (nonatomic, copy) void(^didFinishPickingPhotosHandle)(NSArray<UIImage *> *photos,NSArray *assets,BOOL isSelectOriginalPhoto);
@property (nonatomic, copy) void(^didFinishPickingPhotosWithInfosHandle)(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto, NSArray <NSDictionary *> *infos);
@property (nonatomic, copy) void (^imagePickerControllerDidCancelHandle)(void);

// If user picking a video, this handle will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
@property (nonatomic, copy) void (^didFinishPickingVideoHandle)(UIImage *coverImage,id asset);

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
@property (nonatomic, copy) void (^didFinishPickingGifImageHandle)(UIImage *animatedImage,id sourceAssets);

@property (nonatomic, weak) id<YCPhotoPickerControllerDelegate> pickerDelegate;

@end

@protocol YCPhotoPickerControllerDelegate <NSObject>
@optional

// The picker should dismiss itself; when it dismissed these handle will be called.
// You can also set autoDismiss to NO, then the picker don't dismiss itself.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[YCImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的handle
// 你也可以设置autoDismiss属性为NO，选择器就不会自己dismis了
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[YCImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它

- (void)imagePickerController:(YCPhotoPickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto;
- (void)imagePickerController:(YCPhotoPickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos;
//- (void)imagePickerControllerDidCancel:(TZImagePickerController *)picker __attribute__((deprecated("Use -tz_imagePickerControllerDidCancel:.")));
- (void)imagePickerControllerDidCancel:(YCPhotoPickerController *)picker;

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(YCPhotoPickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset;

// If user picking a gif image, this callback will be called.
// 如果用户选择了一个gif图片，下面的handle会被执行
- (void)imagePickerController:(YCPhotoPickerController *)picker didFinishPickingGifImage:(UIImage *)animatedImage sourceAssets:(id)asset;

// Decide album show or not't
// 决定相册显示与否 albumName:相册名字 result:相册原始数据
- (BOOL)isAlbumCanSelect:(NSString *)albumName result:(id)result;

// Decide asset show or not't
// 决定照片显示与否
- (BOOL)isAssetCanSelect:(id)asset;

@end

@interface YCAlbumPickerController : UIViewController

@property (nonatomic, assign) NSInteger columnNumber;
@property (assign, nonatomic) BOOL isFirstAppear;
- (void)configTableView;
@end

//读取bundle包中的内容
@interface UIImage(MyBundle)
+ (UIImage *)imageNamedFromMyBundle:(NSString *)name;
@end

@interface NSString (YCExtension)
- (BOOL)yc_containsString:(NSString *)string;
- (CGSize)yc_calculateSizeWithAttributes:(NSDictionary *)attributes maxSize:(CGSize)maxSize;
@end

@interface YCCommonTools : NSObject
+ (BOOL)yc_isIPhoneX;
+ (CGFloat)yc_statusBarHeight;
// 获得Info.plist数据字典
+ (NSDictionary *)yc_getInfoDictionary;
@end

@interface YCImagePickerConfig : NSObject
+ (instancetype)sharedInstance;
@property (copy, nonatomic) NSString *preferredLanguage;
@property(nonatomic, assign) BOOL allowPickingImage;
@property (nonatomic, assign) BOOL allowPickingVideo;
@property (strong, nonatomic) NSBundle *languageBundle;
/// 默认是200，如果一个GIF过大，里面图片个数可能超过1000，会导致内存飙升而崩溃
@property (assign, nonatomic) NSInteger gifPreviewMaxImagesCount;
@end


