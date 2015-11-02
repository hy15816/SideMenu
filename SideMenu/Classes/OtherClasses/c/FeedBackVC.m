//
//  FeedBackVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/12.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#define kCurrentUser    @"currUser"
#define kFeedBackString @"feedBackString"
#define kStringCount        120     //最大长度

#import "FeedBackVC.h"

@interface FeedBackVC ()<UITextViewDelegate>
{
    BOOL isSendSuc; //是否发送成功
}
@property (strong, nonatomic) IBOutlet UITextView *fTextView;
@property (strong, nonatomic) IBOutlet UILabel *fLabel;
@property (strong, nonatomic) IBOutlet UIButton *fSendBtn;
- (IBAction)fSendBtnClick:(UIButton *)sender;

@end

@implementation FeedBackVC

- (void)viewDidLoad {
    [super viewDidLoad];

    isSendSuc = NO;
    
    NSString *string  = [[NSUserDefaults standardUserDefaults]  valueForKey:[NSString stringWithFormat:@"%@%@",kCurrentUser,kFeedBackString]];
    self.fTextView.text = string.length >0?string:@"";
    self.fTextView.textContainerInset = UIEdgeInsetsMake(5, 5, 0, 5);//设置文字左上开始，
    self.fTextView.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSInteger count = 120-(unsigned long)self.fTextView.text.length;
    self.fLabel.text = [NSString stringWithFormat:@"%lu/%d",(long)(count>=0?count:0),kStringCount];
    [self.fTextView becomeFirstResponder];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSInteger count = kStringCount - (unsigned long)self.fTextView.text.length-text.length;
    self.fLabel.text = [NSString stringWithFormat:@"%lu/%d",(long)(count>=0?count:0),kStringCount];
    
    if (self.fTextView.text.length > kStringCount) {
        self.fTextView.text = [self.fTextView.text substringToIndex:kStringCount-1];
        return NO;
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.fTextView resignFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //[self.fTextView resignFirstResponder];
    if (!isSendSuc) {
        [[NSUserDefaults standardUserDefaults] setValue:self.fTextView.text forKey:[NSString stringWithFormat:@"%@%@",kCurrentUser,kFeedBackString]];//保存当前用户的输入
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)fSendBtnClick:(UIButton *)sender {
    [self.fTextView resignFirstResponder];
    if (1) {//提交成功
        isSendSuc = YES;
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:[NSString stringWithFormat:@"%@%@",kCurrentUser,kFeedBackString]];//保存当前用户的输入为空
    }
}
@end
