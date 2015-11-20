//
//  YKChatViewCell.h
//  Yinner
//
//  Created by Maru on 15/8/13.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKChatViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *headImage;
@property (nonatomic,strong) UIImageView *bubbleView;
@property (nonatomic,strong) UILabel *content;

- (void)loadEMMessage:(EMMessage *)message;


@end
