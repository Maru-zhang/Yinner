//
//  YKBrowseViewCell.h
//  Yinner
//
//  Created by Maru on 15/6/9.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const browseCell = @"browseCell";

@interface YKBrowseViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *browseImage;
@property (weak, nonatomic) IBOutlet UILabel *browseTitle;
@property (weak, nonatomic) IBOutlet UILabel *browseFavourite;
@property (weak, nonatomic) IBOutlet UILabel *browseComment;
@property (weak, nonatomic) IBOutlet UILabel *browseTime;
@end
