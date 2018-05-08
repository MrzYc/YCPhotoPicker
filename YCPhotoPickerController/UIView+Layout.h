//
//  UIView+Layout.h
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/5/3.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    YCOscillatoryAnimationToBigger,
    YCOscillatoryAnimationToSmaller,
} YCOscillatoryAnimationType;


@interface UIView (Layout)

@property (nonatomic) CGFloat yc_left;        ///< Shortcut for frame.origin.x.
@property (nonatomic) CGFloat yc_top;         ///< Shortcut for frame.origin.y
@property (nonatomic) CGFloat yc_right;       ///< Shortcut for frame.origin.x + frame.size.width
@property (nonatomic) CGFloat yc_bottom;      ///< Shortcut for frame.origin.y + frame.size.height
@property (nonatomic) CGFloat yc_width;       ///< Shortcut for frame.size.width.
@property (nonatomic) CGFloat yc_height;      ///< Shortcut for frame.size.height.
@property (nonatomic) CGFloat yc_centerX;     ///< Shortcut for center.x
@property (nonatomic) CGFloat yc_centerY;     ///< Shortcut for center.y
@property (nonatomic) CGPoint yc_origin;      ///< Shortcut for frame.origin.
@property (nonatomic) CGSize  yc_size;        ///< Shortcut for frame.size.

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer type:(YCOscillatoryAnimationType)type;

@end
