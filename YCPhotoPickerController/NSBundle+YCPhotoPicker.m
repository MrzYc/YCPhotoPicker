//
//  NSBundle+YCPhotoPicker.m
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/5/2.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import "NSBundle+YCPhotoPicker.h"
#import "YCPhotoPickerController.h"


@implementation NSBundle (YCPhotoPicker)

+ (NSBundle *)imagePickerBundle {
    NSBundle *bundle = [NSBundle bundleForClass:[YCPhotoPickerController class]];
    NSURL *url = [bundle URLForResource:@"TZImagePickerController" withExtension:@"bundle"];
    bundle = [NSBundle bundleWithURL:url];
    return bundle;
}

+ (NSString *)localizedStringForKey:(NSString *)key {
    return  [self localizedStringForKey:key value:@""];
}

+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value {
    NSBundle *bundle = [YCImagePickerConfig sharedInstance].languageBundle;
    NSString *value1 = [bundle localizedStringForKey:key value:value table:nil];
    return value1;
}



@end
