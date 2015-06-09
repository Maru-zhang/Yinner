//
//  YKBrowseViewCell.m
//  Yinner
//
//  Created by Maru on 15/6/9.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKBrowseViewCell.h"

@interface YKBrowseViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *browseImage;
@property (weak, nonatomic) IBOutlet UILabel *browseTitle;
@property (weak, nonatomic) IBOutlet UILabel *browseFavourite;
@property (weak, nonatomic) IBOutlet UILabel *browseComment;
@property (weak, nonatomic) IBOutlet UILabel *browseTime;
@end

@implementation YKBrowseViewCell


#pragma mark - life cycle
- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}


@end
