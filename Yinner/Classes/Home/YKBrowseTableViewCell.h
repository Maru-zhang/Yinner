//
//  YKBrowseTableViewCell.h
//  Yinner
//
//  Created by Maru on 15/6/10.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKBrowseTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *breviaryImage;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *startCount;
@property (weak, nonatomic) IBOutlet UILabel *commentCount;
@property (weak, nonatomic) IBOutlet UIImageView *bester;
@property (weak, nonatomic) IBOutlet UILabel *rankNum;

@end
