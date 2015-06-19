//
//  YKPersonnalView.h
//  Yinner
//
//  Created by Maru on 15/6/19.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKPersonnalView : UIView <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *fansNum;
@property (weak, nonatomic) IBOutlet UILabel *worksNum;
@property (weak, nonatomic) IBOutlet UITableView *personnalTable;
@end
