//
//  YKContactTableViewCell.h
//  Yinner
//
//  Created by Maru on 15/8/13.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YKContactModel.h"

@interface YKContactTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *lastMessage;
@property (weak, nonatomic) IBOutlet UILabel *lastTime;

- (void)loadContactModel:(YKContactModel *)model;

+ (YKContactTableViewCell *)contactTableviewCell;

@end
