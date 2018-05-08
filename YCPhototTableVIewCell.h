//
//  YCPhototTableVIewCell.h
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/4/28.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YCPhototTableVIewCellDelegate <NSObject>

@optional;

- (void)switchViewAction:(BOOL)isON withTitle:(NSString *)title;

@end

@interface YCPhototTableVIewCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UISwitch *switchView;
@property (nonatomic, strong) UITextField *tfView;

@property (nonatomic, weak) id<YCPhototTableVIewCellDelegate> delegate;

@end
