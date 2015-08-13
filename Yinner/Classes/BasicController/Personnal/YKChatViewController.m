//
//  YKChatViewController.m
//  Yinner
//
//  Created by Maru on 15/8/6.
//  Copyright (c) 2015年 Alloc. All rights reserved.
//

#import "YKChatViewController.h"
#import "YKChatViewCell.h"

@interface YKChatViewController ()
{
    NSMutableArray *_dataSource;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *inputView;
@property (weak, nonatomic) IBOutlet UIButton *faceButton;
@property (weak, nonatomic) IBOutlet UIButton *recoderButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBotttomLayout;


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
    
    [self loadDataSource];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self scrollViewtoBottom];
}

- (void)dealloc
{
    //移除聊天控制代理
    [[EaseMob sharedInstance].chatManager removeDelegate:self];
}

#pragma mark - Private Method
- (void)setupView
{
    //设置标题
    self.title = [NSString stringWithFormat:@"与%@的聊天中...",self.chatter];
    
    //设置圆角
    [_inputView.layer setCornerRadius:10];
    
    //给faceButton设置高亮图片
    [self.faceButton setImage:[UIImage imageNamed:@"chatBar_more_faceSelected"] forState:UIControlStateHighlighted];
    
    [self.recoderButton setImage:[UIImage imageNamed:@"chatBar_recordSelected"] forState:UIControlStateHighlighted];
    
    //设置分离器样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //设置背景颜色
    self.tableView.backgroundColor = [UIColor blackColor];
    
}

- (void)loadDataSource
{
    EMConversation *conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:self.chatter conversationType:self.conversationType];
    
    NSArray *array = [conversation loadAllMessages];
    
    _dataSource = [NSMutableArray arrayWithArray:array];
    
    NSLog(@"此会话中得消息：%@",array);
}


- (void)setupSetting
{
    
    //设置代理
    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    
    //消息注册
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark 滑到最底部
- (void)scrollViewtoBottom
{
    if (_dataSource.count < 1) {
        return;
    }
    
    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:_dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark 键盘拉上和拉下
- (void)keyboardWillShow:(NSNotification *)noti
{
    
    NSDictionary *info = [noti userInfo];
    
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    _viewBotttomLayout.constant = keyboardSize.height;
    
    //必须用这种方法来实现自动布局的动画
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        [self.view layoutIfNeeded];
    }];
    
    //滚动到最下方
    [self scrollViewtoBottom];
}



- (void)keyboardWillDisappear:(NSNotification *)noti
{
 
    self.viewBotttomLayout.constant = 0;

}



#pragma mark - Table View DataSOurce
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"chatCell";
    
    YKChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YKChatViewCell" owner:self options:nil] lastObject];
    }
    
    EMMessage *message = _dataSource[indexPath.row];
    
    EMTextMessageBody *body = [message.messageBodies lastObject];
    
//    cell.textLabel.text = body.text;
//    
//    if ([message.from isEqualToString:self.chatter]) {
//        
//        cell.textLabel.textAlignment = NSTextAlignmentLeft;
//    }
//    else
//    {
//        cell.textLabel.textAlignment = NSTextAlignmentRight;
//    }
    
    cell.content.text = body.text;
    
    cell.bgImageWidth.constant = cell.content.frame.size.width + 50;
    
    NSLog(@"%lf",cell.content.frame.size.width);
    
    
    

    return cell;
}

#pragma mark - TableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}



#pragma mark - Text View Delegate 
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [_inputView becomeFirstResponder];

}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView.text containsString:@"\n"] && textView.text.length > 1) {
        
        EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithChatObject:[[EMChatText alloc] initWithText:[textView.text substringToIndex:textView.text.length - 1]]];
        
        NSArray *bodyArray = [NSArray arrayWithObject:body];
        
        EMError *error = nil;
        
        #warning 暂时不设置代理
        [[EaseMob sharedInstance].chatManager sendMessage:[[EMMessage alloc] initWithReceiver:self.chatter bodies:bodyArray] progress:nil error:&error];
        
        if (error) {
            NSLog(@"%@",error.description);
        }
        
        //结束输入，关闭键盘
        textView.text = @"";
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        
        //刷新列表
        [self loadDataSource];
        
        [self.tableView reloadData];
        
        [self scrollViewtoBottom];
    }
}


#pragma mark - EMCharManagerDelegate
- (void)didReceiveMessage:(EMMessage *)message
{
    [self loadDataSource];
    
    [self.tableView reloadData];
    
    [self scrollViewtoBottom];
}



@end
