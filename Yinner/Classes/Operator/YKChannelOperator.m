//
//  YKChannelOperator.m
//  Yinner
//
//  Created by apple on 16/2/29.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import "YKChannelOperator.h"
#import "YKBrowseVideoModel.h"


@interface YKChannelOperator ()
@end
@implementation YKChannelOperator

- (instancetype)initWithParmaters:(NSDictionary *)parmaters {
    
    if (self = [super init]) {
    }
    
    return self;
}

- (void)getResponseWithType:(YKChannerType)type SuccessHandler:(SuccessHander)successHandler andFailureHandler:(FailHander)failureHandler {
    
    switch (type) {
        case YKChannerTypeComedy:
            self.host = @"http://api.peiyinxiu.com/v2.0/GetHotFilmToChannel?appkey=3e8622117aee570a&v=4.1.17&sign=c1c6792ef88be26bec6231105f22c92c&uid=0&token=0&ccode=1&pg=1&acode=";
            break;
            
        case YKChannerTypeComment:
            self.host = @"http://api.peiyinxiu.com/v2.0/GetHotFilmToChannel?appkey=3e8622117aee570a&v=4.1.17&sign=ce934f0cf0476342a50aeeec4d204dc1&uid=0&token=0&ccode=9&pg=1&acode=";
            break;
        case YKChannerTypeCartoon:
            self.host = @"http://api.peiyinxiu.com/v2.0/GetHotFilmToChannel?appkey=3e8622117aee570a&v=4.1.17&sign=6483904aa3a8577fff753bed89497113&uid=0&token=0&ccode=7&pg=1&acode=";
            break;
        case YKChannerTypeLocalism:
            self.host = @"http://api.peiyinxiu.com/v2.0/GetHotFilmToChannel?appkey=3e8622117aee570a&v=4.1.17&sign=7031aa015c7725a3208a4ea91578caff&uid=0&token=0&ccode=0&pg=1&acode=110100";
            break;
        case YKChannerTypeTheatre:
            self.host = @"http://api.peiyinxiu.com/v2.0/GetHotFilmToChannel?appkey=3e8622117aee570a&v=4.1.17&sign=80450000126217837560b900721b8291&uid=0&token=0&ccode=8&pg=1&acode=";
            break;
        case YKChannerTypeTV:
            self.host = @"http://api.peiyinxiu.com/v2.0/GetHotFilmToChannel?appkey=3e8622117aee570a&v=4.1.17&sign=460caeb5d7feeb7789157735e00f2b6f&uid=0&token=0&ccode=4&pg=1&acode=";
            break;
            
        default:
            break;
    }
    
    debugLog(@"%@",self.parmaters);
    
    [self.manager GET:self.host parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        // 配置映射
        [YKBrowseItem mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
            return @{@"image": @"imageurl"};
        }];
        
        NSArray *result = [YKBrowseItem mj_objectArrayWithKeyValuesArray:dic];

        successHandler(result);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failureHandler(error);
    }];
}

@end
