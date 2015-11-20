//
//  YKPersonInfoController.h
//  Yinner
//
//  Created by Maru on 15/8/3.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YKPersonInfoController : UITableViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *areaLable;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UITableViewCell *pickerCell;

- (IBAction)confirm:(id)sender;
- (IBAction)cancel:(id)sender;

@end
