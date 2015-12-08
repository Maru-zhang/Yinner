//
//  UITableView+EmptyData.m
//  SalaryQuery
//
//  Created by apple on 15/11/2.
//  Copyright © 2015年 MS. All rights reserved.
//

#import "UITableView+EmptyData.h"

@implementation UITableView (EmptyData)

-(void)tableViewDisplayWithEmptyMsg:(NSString *)message ifNecessaryForDataCount:(NSUInteger)count {
    if (count == 0) {
        
        //没有数据时tableview显示的样式
        UILabel *messageLable = [UILabel new];
        
        messageLable.text = message;
        messageLable.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        messageLable.textColor = [UIColor lightGrayColor];
        messageLable.textAlignment = NSTextAlignmentCenter;
        
        [messageLable sizeToFit];
        self.backgroundView = messageLable;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
    }else {
        self.backgroundView = nil;
        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

@end
