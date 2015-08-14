//
//  YKChatViewCell.m
//  Yinner
//
//  Created by Maru on 15/8/13.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//
#import "ReuseFrame.h"

#define KheadMarginTop 10
#define KheadMarginLeft 10
#define KheadHeight 30
#define KheadWidth 30

#define KbubbleMarginTop 10
#define KbubbleMarginLeft 5
#define KbubbleHeight 30
#define KbubbleWidth 200

#define KcontentWidth 180
#define KcontentLeft 5
#define KcontentTop 5

#define ChatContentFont [UIFont systemFontOfSize:14] //内容字体

#import "YKChatViewCell.h"

@implementation YKChatViewCell

#pragma mark - Life Cycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        //创建子视图
        [self setupView];
        
    }
    
    
    return self;
}

#pragma mark - Public Method
- (void)loadEMMessage:(EMMessage *)message
{
    //判断是不是自己发送的 YES是自己发的,然后进行相关设置
    if ([message.to isEqualToString:message.conversationChatter]) {
        
        //设置头像frame
        self.headImage.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - KheadWidth - KheadMarginLeft, KheadMarginTop, KheadWidth, KheadWidth);
        
        //获取消息内容
        NSArray *contentArray = message.messageBodies;
        EMTextMessageBody *contentBody = [contentArray lastObject];
        NSString *contentStr = contentBody.text;
        
        //设置文本内容
        //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（译者注：字体大小+行间距=行高
        CGRect tempRect = [contentStr boundingRectWithSize:CGSizeMake(KcontentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:ChatContentFont forKey:NSFontAttributeName] context:nil];
        CGSize contentSize = tempRect.size;
        
        //设置气泡frame
        UIImage *bubble = [UIImage imageNamed:@"chatto_bg_normal"];
        _bubbleView.image = [bubble stretchableImageWithLeftCapWidth:0.5 topCapHeight:0.5];
        _bubbleView.frame = CGRectMake(KwinW - KheadMarginLeft - KheadWidth - KbubbleMarginLeft - (contentSize.width + 20), KbubbleMarginTop, contentSize.width + 20, KbubbleHeight);
        
        //设置lable的frame
        _content.center = _bubbleView.center;
        _content.bounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
        
        //赋值内容
        _content.text = contentStr;
    }
    else
    {
        //设置头像frmae
        self.headImage.frame = CGRectMake(KheadMarginLeft, KheadMarginTop, KheadWidth, KheadHeight);
        
        //获取消息内容
        NSArray *contentArray = message.messageBodies;
        EMTextMessageBody *contentBody = [contentArray lastObject];
        NSString *contentStr = contentBody.text;
        
        //设置文本内容
        //NSStringDrawingTruncatesLastVisibleLine如果文本内容超出指定的矩形限制，文本将被截去并在最后一个字符后加上省略号。 如果指定了NSStringDrawingUsesLineFragmentOrigin选项，则该选项被忽略 NSStringDrawingUsesFontLeading计算行高时使用行间距。（译者注：字体大小+行间距=行高
        CGRect tempRect = [contentStr boundingRectWithSize:CGSizeMake(KcontentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:ChatContentFont forKey:NSFontAttributeName] context:nil];
        CGSize contentSize = tempRect.size;
        
        //设置气泡frame
        UIImage *bubble = [UIImage imageNamed:@"chatfrom_bg_normal"];
        _bubbleView.image = [bubble stretchableImageWithLeftCapWidth:0.5 topCapHeight:0.5];
        _bubbleView.frame = CGRectMake(KheadMarginLeft + KheadWidth + KbubbleMarginLeft, KbubbleMarginTop, contentSize.width + 10, KbubbleHeight);
        
        //设置lable的frame
        _content.center = _bubbleView.center;
        _content.bounds = CGRectMake(0, 0, contentSize.width, contentSize.height);
        
        //赋值内容
        _content.text = contentStr;
        
    }
}


#pragma mark - Private Method
- (void)setupView
{
    
    //设置cell的背景颜色为透明
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    //设置组样式
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //创建头像
    if (!self.headImage) {
        
        self.headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"touxiang"]];
        self.headImage.userInteractionEnabled = YES;
        [self.headImage.layer setCornerRadius:15];
        self.headImage.layer.masksToBounds = YES;
        [self addSubview:self.headImage];
    }
    
    //创建聊天气泡
    if (!self.bubbleView) {
        
        _bubbleView = [[UIImageView alloc] init];
        self.headImage.userInteractionEnabled = YES;
        [self addSubview:_bubbleView];
    }
    
    //创建聊天内容的标签
    if (!self.content) {
        
        _content = [[UILabel alloc] init];
        _content.backgroundColor = [UIColor clearColor];
        UIFont *font = [UIFont systemFontOfSize:13];
        _content.font = font;
        [self addSubview:_content];
    }
}

@end
