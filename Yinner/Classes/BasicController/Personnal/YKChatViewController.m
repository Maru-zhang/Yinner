//
//  YKChatViewController.m
//  Yinner
//
//  Created by Maru on 15/8/6.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//
#import "YKChatViewController.h"
#import "YKChatViewCell.h"
#import "NSString+Size.h"
#import "ReuseFrame.h"
#import "UUInputFunctionView.h"
#import "MJRefresh.h"
#import "UUMessageCell.h"
#import "ChatModel.h"
#import "UUMessageFrame.h"
#import "UUMessage.h"
#import "YKContactModel.h"

/** 每次加载的消息数 */
static int loadOnceCount = 20;
/** 标识 */
static NSString *const cellIdentifier = @"MessageCellID";

@interface YKChatViewController ()<UIScrollViewDelegate,UUMessageCellDelegate,UUInputFunctionViewDelegate>
@property (nonatomic,strong) id<IChatManager> manager;
/** 消息模型 */
@property (nonatomic, strong) YKContactModel *chatModel;
/** 输入框 */
@property (nonatomic,strong) UUInputFunctionView *inputView;
/** 显示表格 */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;

@end

@implementation YKChatViewController


#pragma mark - Life Cycle
#pragma mark 静态方法
+ (YKChatViewController *)chatViewControllerWithChatter:(NSString *)chatter conversationType:(EMConversationType)type
{
    YKChatViewController *chatVC =  [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"chat"];
    
    chatVC.chatter = chatter;
    
    chatVC.conversationType = type;
    
    return chatVC;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupView];
    
    [self setupSetting];
    
    [self loadDataSourceWithSetup:YES];
}

- (void)dealloc
{
    //移除聊天控制代理
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - Private Method
- (void)setupView
{
    // 设置标题
    self.title = [NSString stringWithFormat:@"%@",self.chatter];
    // 添加输入框
    [self.view addSubview:self.inputView];
    // 添加代理
    self.inputView.delegate = self;
    self.tableView.delegate = self;
    // 设置分离器样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 设置背景颜色
    self.tableView.backgroundColor = [UIColor whiteColor];
    // 隐藏滚轮
    self.tableView.showsVerticalScrollIndicator = NO;
    // 设置下拉刷新
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 刷新数据
        [self loadDataSourceWithSetup:NO];
    }];
    // 开始的时候自动在最下方
    self.tableView.contentOffset = CGPointMake(0, INT16_MAX);
}

- (void)setupSetting
{
    //设置代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //消息注册
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
    
}


#pragma mark 初始化加载数据
- (void)loadDataSourceWithSetup:(BOOL)setup
{
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.chatter conversationType:self.conversationType];
    
    if (setup) {
        
        NSArray *messages = [conversation loadNumbersOfMessages:loadOnceCount withMessageId:nil];
        
        self.chatModel = [YKContactModel configWithMessageArray:messages];
        
    }else {
        
        UUMessageFrame *firstMessage = [self.chatModel.dataSource firstObject];
        
        NSArray *messages = [conversation loadNumbersOfMessages:loadOnceCount withMessageId:[firstMessage.message strId]];
        
        YKContactModel *tempModel = [YKContactModel configWithMessageArray:messages];
        
        [tempModel.dataSource addObjectsFromArray:self.chatModel.dataSource];
        
        self.chatModel.dataSource = tempModel.dataSource;
    }
    
    [self.tableView reloadData];

    [self.tableView.header endRefreshing];
}

#pragma mark 键盘拉上和拉下
-(void)keyboardChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    //adjust ChatTableView's height
    if (notification.name == UIKeyboardWillShowNotification) {
        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
    }else{
        self.bottomConstraint.constant = 40;
    }
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = self.inputView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    self.inputView.frame = newFrame;
    
    [UIView commitAnimations];
    
}

- (void)tableViewScrollToBottom
{
    if (self.chatModel.dataSource.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.chatModel.dataSource.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - 发送消息
#pragma mark 发送文字
- (void)sendMessageWithEMMessage:(EMMessage *)message {
    
    [self.chatModel insertMessageModel:message];
    
    [self.tableView reloadData];
    
    [self tableViewScrollToBottom];
}


#pragma mark - Table View DataSOurce
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatModel.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
    }
    [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;
}


#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark - InputFunctionViewDelegate
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message
{
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:[[EMChatText alloc] initWithText:message]];
    
    __block EMMessage *msg = [[EMMessage alloc] initWithReceiver:self.chatter bodies:[NSArray arrayWithObject:body]];
    
    __weak typeof(self) weakSelf = self;
    
    [self.manager asyncSendMessage:msg progress:nil prepare:nil onQueue:nil completion:^(EMMessage *message, EMError *error) {
        // 清空输入框
        funcView.TextViewInput.text = @"";
        // 回到相机按钮
        [funcView changeSendBtnWithPhoto:YES];
        // 发送消息的本地相关操作
        [weakSelf sendMessageWithEMMessage:msg];
    } onQueue:dispatch_get_main_queue()];

    
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image
{
    return;
//    NSDictionary *dic = @{@"picture": image,
//                          @"type": @(UUMessageTypePicture)};
//    [self dealTheFunctionData:dic];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second
{
    return;
//    NSDictionary *dic = @{@"voice": voice,
//                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
//                          @"type": @(UUMessageTypeVoice)};
//    [self dealTheFunctionData:dic];
}


#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.strName message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
    [alert show];
}


#pragma mark - EMCharManagerDelegate
- (void)didReceiveMessage:(EMMessage *)message
{
    [self.chatModel insertMessageModel:message];
    
    [self.tableView reloadData];

    [self tableViewScrollToBottom];
}

#pragma mark - 父类方法
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    debugLog(@"%@",NSStringFromCGPoint(self.tableView.contentOffset));
}




#pragma mark - Property
- (UUInputFunctionView *)inputView {
    if (!_inputView) {
        _inputView = [[UUInputFunctionView alloc] initWithSuperVC:self];
    }
    return _inputView;
}

- (id<IChatManager>)manager {
    if (!_manager) {
        _manager = [EaseMob sharedInstance].chatManager;
    }
    return _manager;
}



@end
