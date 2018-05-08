//
//  YCImageCropManager.h
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/5/3.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YCImageCropManager : NSObject

/// 裁剪框背景的处理
+ (void)overlayClippingWithView:(UIView *)view cropRect:(CGRect)cropRect containerView:(UIView *)containerView needCircleCrop:(BOOL)needCircleCrop;

/// 获得裁剪后的图片
+ (UIImage *)cropImageView:(UIImageView *)imageView toRect:(CGRect)rect zoomScale:(double)zoomScale containerView:(UIView *)containerView;

/// 获取圆形图片
+ (UIImage *)circularClipImage:(UIImage *)image;

@end

@interface UIImage (YCGif)

+ (UIImage *)sd_yc_animatedGIFWithData:(NSData *)data;

@end

