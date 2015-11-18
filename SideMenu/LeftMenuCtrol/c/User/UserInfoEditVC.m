//
//  UserInfoEdit.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/10/16.
//  Copyright (c) 2015年 hyIm. All rights reserved.
//

#define kTAG_ACTION_SEX     15101610
#define KTAG_ACTION_ICON    15101611

#import "UserInfoEditVC.h"
#import "HYPhotoPickerView.h"

@interface UserInfoEditVC ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
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

@implementation UserInfoEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.nikeNameField.delegate = self;
    self.signField.delegate = self;
    
    self.userIcon.layer.masksToBounds = YES;
    
    //获取本地保存的图片
    [self.userIcon setImage:[GlobalTool getMyIcon] forState:UIControlStateNormal];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:.2 animations:^{
        self.userIcon.layer.cornerRadius = CGRectGetHeight(self.userIcon.frame)/2.f;
    }];
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
            UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - 点击头像
- (IBAction)userIconClick:(UIButton *)sender {
    
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
    action.tag = KTAG_ACTION_ICON;
    [action showInView:self.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //选择性别
    if (actionSheet.tag == kTAG_ACTION_SEX) {
        if (buttonIndex == 1) {
            self.sexLabel.text = @"女";
        }
    }
    
    //选取图片方式
    if (actionSheet.tag == KTAG_ACTION_ICON) {
        [self selectAtIndex:buttonIndex];
    }

    
}

/**
 *  选取图片方式
 *
 *  @param index 拍照 或 相册选取
 */
- (void)selectAtIndex:(NSInteger)index{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [picker.navigationBar setTintColor:[UIColor blackColor]];
    
    switch (index) {
        case 0:
            //照相机
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;//图片源为相机
            [self presentViewController:picker animated:YES completion:^{}];
            break;
            
        case 1:
            //本地相册
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;//图片源为相册
            [self presentViewController:picker animated:YES completion:^{}];
            break;
            
        default:
            break;
    }
}

#pragma mark - UIImagePickerControllerDelegate
//选取照片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取选择的照片
    UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
    [GlobalTool saveMyIcon:img finish:^(NSError *err){
        if (err) {
            NSLog(@"err:%@",err.localizedDescription);
        }
    }];
    
    //发送一个通知，在LeftMenuViewController.m 接收
    [[NSNotificationCenter defaultCenter] postNotificationName:kMyIconDidChanged object:nil];

    [self.userIcon setImage:img forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

//点击取消时的操作
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
