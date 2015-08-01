//
//  YKCommentTableViewCell.h
//  Yinner
//
//  Created by Maru on 15/7/31.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKCommentTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *commentTime;

@end
