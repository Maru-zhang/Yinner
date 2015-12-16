//
//  YKRankListModel.h
//  Yinner
//
//  Created by Maru on 15/12/15.
//  Copyright © 2015年 Alloc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YKRankListModel : NSObject
/** 评论数 */
@property (nonatomic, assign) NSInteger comment_count;
/** 视频ID */
@property (nonatomic, assign) NSInteger film_id;
/** 头 */
@property (nonatomic, copy) NSString *user_head;
/**  */
@property (nonatomic, assign) NSInteger verified;
/** 用户ID */
@property (nonatomic, assign) NSInteger user_id;
/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 图片URL */
@property (nonatomic, copy) NSString *image;
/** 用户名 */
@property (nonatomic, copy) NSString *user_name;
/** 转载数 */
@property (nonatomic, assign) NSInteger forward_count;
/** 发布时间 */
@property (nonatomic, copy) NSString *film_time;
/** 点赞数 */
@property (nonatomic, assign) NSInteger good_count;
/** 用户类型 */
@property (nonatomic, assign) NSInteger user_type;

@end
