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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 
- (void)loadContactModel:(YKContactModel *)model
{
    self.headImage.image = model.headImage;
    self.name.text = model.name;
    self.lastMessage.text = model.lastMessage;
    self.lastTime.text = model.lastTime;
}

@end
