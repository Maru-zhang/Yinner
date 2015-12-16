
//
//  YKSubtitleView.m
//  Yinner
//
//  Created by Maru on 15/12/16.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import "YKSubtitleView.h"


#define kHighLight_C [UIColor whiteColor]
#define kNormal_C [UIColor lightGrayColor]

@interface YKSubtitleView ()
@property (nonatomic,assign) NSInteger currentLine;
@end

@implementation YKSubtitleView



#pragma mark - 重写
- (void)scrollToRowAtIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)scrollPosition animated:(BOOL)animated {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UITableViewCell *pre_cell = [self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentLine inSection:0]];
        pre_cell.textLabel.textColor = kNormal_C;
        
        UITableViewCell *cur_cell =  [self cellForRowAtIndexPath:indexPath];
        cur_cell.textLabel.textColor = kHighLight_C;
        
        self.currentLine = indexPath.row;
    });
    
    [super scrollToRowAtIndexPath:indexPath atScrollPosition:scrollPosition animated:animated];
}

#pragma mark - Property
- (NSInteger)currentLine {
    if (!_currentLine) {
        _currentLine = 0;
    }
    return _currentLine;
}

@end
