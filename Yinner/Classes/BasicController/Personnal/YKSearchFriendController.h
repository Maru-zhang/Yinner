//
//  YKSearchFriendController.h
//  Yinner
//
//  Created by Maru on 15/8/11.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKSearchFriendController : UITableViewController <UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (IBAction)searchClick:(id)sender;

@end
