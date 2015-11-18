//
//  TestKeyboardVC.m
//  SideMenu
//
//  Created by AEF-RD-1 on 15/11/9.
//  Copyright © 2015年 hyIm. All rights reserved.
//  测试是否实现 键盘弹出，textField自动改变位置；是否实现点击前一项、后一项功能。

#import "TestKeyboardVC.h"

@interface TestKeyboardVC ()
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *ageField;
@property (strong, nonatomic) IBOutlet UITextField *addressField;

@end

@implementation TestKeyboardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.nameField becomeFirstResponder];

}

#pragma mark - UIKeyboardDelegate

- (BOOL)alttextViewEditing:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger lenth = 17;
    if(textField == _nameField)
    {
        lenth = 10;
    }
    else if (textField == _ageField || textField == _addressField)
    {
        lenth = 11;
    }
    NSString *new = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger res = lenth - new.length;
    if(res >= 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}


- (void)tResignFirstResponder{
    [self.nameField resignFirstResponder];
    [self.ageField resignFirstResponder];
    [self.addressField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
