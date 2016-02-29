//
//  YKBrowseLayout.m
//  Yinner
//
//  Created by apple on 16/2/28.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKBrowseLayout.h"

@implementation YKBrowseLayout

- (void)prepareLayout {
    if (IS_IPHONE_5) {
        self.itemSize = CGSizeMake(140, 140);
    }else {
        self.itemSize = CGSizeMake(170, 170);
    }
    
    CGFloat spacing = (KwinW - 2 * self.itemSize.width) / 3;
    self.sectionInset = UIEdgeInsetsMake(0, spacing, 44, spacing);
}


@end
