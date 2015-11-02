//
//  UserInfoEdit.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/16.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#define kTAG_ACTION_SEX     15101610
#define KTAG_ACTION_ICON    15101611

#import "UserInfoEdit.h"

@interface UserInfoEdit ()<UITextFieldDelegate,UIActionSheetDelegate>
{
    UIAlertController *alertCtrol;
    UIDatePicker *datePicker;
}
@property (strong, nonatomic) IBOutlet UIButton *userIcon;
- (IBAction)userIconClick:(UIButton *)sender;

@property (strong, nonatomic) IBOutlet UILabel *accountLabel;
@property (strong, nonatomic) IBOutlet UITextField *nikeNameField;
@property (strong, nonatomic) IBOutlet UILabel *sexLabel;
@property (strong, nonatomic) IBOutlet UILabel *birthdayLabel;
@property (strong, nonatomic) IBOutlet UITextField *signField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveInfoBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveInfoAction;

@end

@implementation UserInfoEdit

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.nikeNameField.delegate = self;
    self.signField.delegate = self;
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kDEVICE_WIDTH, 30)];;
    timeLabel.text = @"1";//[NSString stringWithFormat:@"%@ min",];
    return timeLabel;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"ind.sec %ld, ind.row %ld",(long)indexPath.section,(long)indexPath.row);
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        return CGRectGetHeight(self.userIcon.frame) + 40;
    }
    
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 ) {
        if (indexPath.row == 3) {//选择性别
            //
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
            action.tag = kTAG_ACTION_SEX;
            [action showInView:self.view];
        }
        
        if (indexPath.row == 4) {//选择生日(时间选择器)
            
            alertCtrol = [UIAlertController alertControllerWithTitle:nil message:@"\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                //点击确定按钮的事件处理
                
                NSLog(@"date:%@",[GlobalTool stringForDate:datePicker.date formate:@"yyyy-M-d"]);
                
            }];
            
            datePicker = [[UIDatePicker alloc] init];//初始化一个UIDatePicker
            datePicker.maximumDate = [NSDate date];//设置最大日期为当前日期
            datePicker.datePickerMode = UIDatePickerModeDate;//显示年、月、日
            [datePicker addTarget:self action:@selector(dateWasChanged:) forControlEvents:UIControlEventValueChanged];
            [alertCtrol.view addSubview:datePicker];//将datePicker添加到UIAlertController实例中
            [alertCtrol addAction:cancel];//将确定按钮添加到UIAlertController实例中
            
            [self presentViewController:alertCtrol animated:YES completion:^{}];//通过模态视图模式显示UIAlertController，相当于UIACtionSheet的show方法
        }
        
    }
}

- (void)dateWasChanged:(UIDatePicker *)picker{
    NSDate *date = picker.date;
    self.birthdayLabel.text = [GlobalTool stringForDate:date formate:@"yyyy-M-d"];
}

#pragma mark - UITextFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    return YES;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
#pragma mark - 保存
- (IBAction)userIconClick:(UIButton *)sender {
    
    
    
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从相册选择", nil];
    action.tag = KTAG_ACTION_ICON;
    [action showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == kTAG_ACTION_SEX) {
        if (buttonIndex == 1) {
            self.sexLabel.text = @"女";
        }

    }
    if (actionSheet.tag == KTAG_ACTION_ICON) {
        if (buttonIndex == 0) {//拍照
            
        }
        
        if (buttonIndex == 1) {//从相册选择
            //
        }
        
        
    }

    
}
@end
