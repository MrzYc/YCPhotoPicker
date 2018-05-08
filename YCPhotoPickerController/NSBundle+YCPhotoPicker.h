//
//  NSBundle+YCPhotoPicker.h
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/5/2.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (YCPhotoPicker)

//加载图片 bundle 资源
+ (NSBundle *)imagePickerBundle;
//加载文字国际化文件
+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value;
+ (NSString *)localizedStringForKey:(NSString *)key;

@end
