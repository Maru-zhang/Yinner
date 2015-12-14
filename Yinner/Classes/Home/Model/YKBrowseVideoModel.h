//
//  YKBrowseVideoModel.h
//  Yinner
//
//  Created by Maru on 15/12/13.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YKBrowseItem;

@interface YKBrowseVideoModel : NSObject
/** 是否成功 */
@property (nonatomic, assign) BOOL success;
/** 数据内容 */
@property (nonatomic, strong) NSArray <YKBrowseItem *>*data;
/** 错误编码 */
@property (nonatomic, assign) NSInteger errorcode;

@end


@interface YKBrowseItem : NSObject
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment_count;
/** 视频ID */
@property (nonatomic, assign) NSInteger film_id;

@property (nonatomic, copy) NSString *user_head;

@property (nonatomic, assign) NSInteger verified;

@property (nonatomic, assign) NSInteger user_id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *user_name;

@property (nonatomic, assign) NSInteger forward_count;

@property (nonatomic, assign) NSInteger union_type;

@property (nonatomic, copy) NSString *film_time;

@property (nonatomic, assign) NSInteger good_count;

@end

