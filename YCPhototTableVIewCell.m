//
//  YCPhototTableVIewCell.m
//  YCPhotoPicker
//
//  Created by 亭乐 on 2018/4/28.
//  Copyright © 2018年 赵永闯. All rights reserved.
//

#import "YCPhototTableVIewCell.h"



@implementation YCPhototTableVIewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 200, 20)];
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        titleLabel.textColor  = [UIColor blackColor];
        [self.contentView addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 100, 5, 100, 10)];
        [switchView addTarget:self action:@selector(switchViewAction:) forControlEvents:UIControlEventValueChanged];
        [self.contentView addSubview:switchView];
        self.switchView = switchView;
        
        UITextField *tfView = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) + 100, 5, 50, 30)];
        [self.contentView addSubview:tfView];
        tfView.textColor = [UIColor blackColor];
        tfView.textAlignment = NSTextAlignmentCenter;
        tfView.keyboardType = UIKeyboardTypeNumberPad;
        tfView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        tfView.layer.borderWidth = 1;
        tfView.hidden = YES;
        self.tfView = tfView;
    }
    return self;
}

- (void)switchViewAction:(UISwitch *)swith {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchViewAction:withTitle:)]) {
        [self.delegate switchViewAction:swith.isOn withTitle:self.titleLabel.text];
    }
}

@end
