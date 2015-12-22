//
//  YKContactTableViewCell.m
//  Yinner
//
//  Created by Maru on 15/8/13.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKContactTableViewCell.h"

@implementation YKContactTableViewCell


#pragma mark - Life Cycyle

+ (YKContactTableViewCell *)contactTableviewCell
{
    YKContactTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"YKContactTableViewCell" owner:self options:nil] lastObject];
    
    return cell;
}

- (void)awakeFromNib {
    // 设置头像圆角
    [self.headImage.layer setCornerRadius:25.0];
    [self.headImage.layer setMasksToBounds:YES];
    [self.headImage setNeedsLayout];
    [self.headImage layoutIfNeeded];
    
    // 设置分割线宽度
    [self setSeparatorInset:UIEdgeInsetsMake(0, 50, 0, 0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 

@end
