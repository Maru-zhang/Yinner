//
//  YKContactModel.m
//  Yinner
//
//  Created by Maru on 15/8/13.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKContactModel.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"
static NSString *previousTime = nil;
@implementation YKContactModel

+ (YKContactModel *)configWithMessageArray:(NSArray<EMMessage *> *)array {
    
    NSString *myUserName = [[[EaseMob sharedInstance] chatManager] loginInfo][@"username"];

    YKContactModel *model = [[YKContactModel alloc] init];

    //配置Message
    [array enumerateObjectsUsingBlock:^(EMMessage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        UUMessage *message = [[UUMessage alloc] init];
        UUMessageFrame *messageFrame = [[UUMessageFrame alloc] init];
        
        // 内容
        msg[@"strContent"] = [[obj messageBodies][0] text];
        // 类型
        msg[@"type"] = @(UUMessageTypeText);
        // 时间
        msg[@"strTime"] = [[NSDate dateWithTimeIntervalInMilliSecondSince1970:obj.timestamp] description];
        // 头像
        msg[@"strIcon"] = @"http://img0.bdstatic.com/img/image/shouye/xinshouye/mingxing16.jpg";
        // ID
        msg[@"strId"] = obj.messageId;
        // 根据不同的情况
        if ([obj.from isEqualToString:myUserName]) {
            // 来源自己
            [msg setValue:@(UUMessageFromMe) forKey:@"from"];
            [msg setValue:myUserName forKey:@"strName"];
        }else {
            // 来源别人
            [msg setValue:@(UUMessageFromOther) forKey:@"from"];
            [msg setValue:obj.from forKey:@"strName"];
        }
        [message setWithDict:msg];
        [message minuteOffSetStart:previousTime end:msg[@"strTime"]];
        messageFrame.showTime = message.showDateLabel;
        [messageFrame setMessage:message];

        // 显示间隔时间矬
        if (message.showDateLabel) {
            previousTime = msg[@"strTime"];
        }
        
        [model.dataSource addObject:messageFrame];
        
    }];
    
    
    return model;
}

#pragma mark 根据消息模型添加
- (void)insertMessageModel:(EMMessage *)obj {
    NSMutableDictionary *msg = [NSMutableDictionary dictionary];
    UUMessage *message = [[UUMessage alloc] init];
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc] init];
    if ([obj.from isEqualToString:self.myUserName]) {
        msg[@"from"] = @(UUMessageFromMe);
    }else {
        msg[@"from"] = @(UUMessageFromOther);
    }
    msg[@"strContent"] = [[obj messageBodies][0] text];
    msg[@"type"] = @(UUMessageTypeText);
    msg[@"strTime"] = [[NSDate date] description];
    msg[@"strName"] = self.myUserName;
    msg[@"strIcon"] = @"http://img0.bdstatic.com/img/image/shouye/xinshouye/mingxing16.jpg";
    [message setWithDict:msg];
    [message minuteOffSetStart:previousTime end:msg[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    if (message.showDateLabel) {
        previousTime = msg[@"strTime"];
    }
    
    [self.dataSource addObject:messageFrame];
}

#pragma mark 添加自己的item
- (void)addSpecifiedItem:(NSDictionary *)dic
{
    UUMessageFrame *messageFrame = [[UUMessageFrame alloc]init];
    UUMessage *message = [[UUMessage alloc] init];
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    NSString *URLStr = @"http://img0.bdstatic.com/img/image/shouye/xinshouye/mingxing16.jpg";
    [dataDic setObject:@(UUMessageFromMe) forKey:@"from"];
    [dataDic setObject:[[NSDate date] description] forKey:@"strTime"];
    [dataDic setObject:@"Hello,Sister" forKey:@"strName"];
    [dataDic setObject:URLStr forKey:@"strIcon"];
    
    [message setWithDict:dataDic];
    [message minuteOffSetStart:previousTime end:dataDic[@"strTime"]];
    messageFrame.showTime = message.showDateLabel;
    [messageFrame setMessage:message];
    
    if (message.showDateLabel) {
        previousTime = dataDic[@"strTime"];
    }
    [self.dataSource addObject:messageFrame];
}


#pragma mark - Proerty
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSString *)myUserName {
    if (!_myUserName) {
        _myUserName = [[[EaseMob sharedInstance] chatManager] loginInfo][@"username"];
    }
    return _myUserName;
}

@end
