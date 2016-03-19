//
//  YKBrowseViewCell.m
//  Yinner
//
//  Created by Maru on 15/6/9.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKBrowseViewCell.h"

@interface YKBrowseViewCell ()

@end

@implementation YKBrowseViewCell


#pragma mark - life cycle
- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

- (void)configWithModel:(YKBrowseItem *)model {
    self.browseTitle.text = model.title;
    self.browseComment.text = [NSString stringWithFormat:@"%ld",(long)model.comment_count];
    self.browseFavourite.text = [NSString stringWithFormat:@"%ld",(long)model.good_count];
    [self.browseImage sd_setImageWithURL:[NSURL URLWithString:model.image]];
}
@end
