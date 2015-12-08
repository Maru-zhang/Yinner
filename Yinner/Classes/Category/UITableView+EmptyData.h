//
//  UITableView+EmptyData.h
//  SalaryQuery
//
//  Created by apple on 15/11/2.
//  Copyright © 2015年 MS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (EmptyData)

- (void)tableViewDisplayWithEmptyMsg:(NSString *)message ifNecessaryForDataCount:(NSUInteger)count;

@end
