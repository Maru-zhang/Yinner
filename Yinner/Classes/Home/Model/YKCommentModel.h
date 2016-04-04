//
//  YKCommentModel.h
//  Yinner
//
//  Created by Maru on 16/4/4.
//  Copyright © 2016年 Alloc. All rights reserved.
//  评论模型

#import <Foundation/Foundation.h>

@class YKCommentItem;

@interface YKCommentModel : NSObject

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSArray<YKCommentItem *> *list;

@end


@interface YKCommentItem : NSObject

@property (nonatomic, copy) NSString *reply_content;

@property (nonatomic, assign) NSInteger commentid;

@property (nonatomic, assign) NSInteger reply_userid;

@property (nonatomic, copy) NSString *reply_username;

@property (nonatomic, assign) NSInteger userid;

@property (nonatomic, copy) NSString *userhead;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, assign) NSInteger reply_commentid;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, assign) NSInteger userlevel;

@property (nonatomic, assign) NSInteger darenunion;

@property (nonatomic, copy) NSString *content;

@end

