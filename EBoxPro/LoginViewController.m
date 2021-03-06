//
//  LoginViewController.m
//  EBoxPro
//
//  Created by yxj on 5/24/15.
//  Copyright (c) 2015 yxj. All rights reserved.
//

#import "LoginViewController.h"
#import <SVProgressHUD.h>
#import "EBoxNetwork.h"
#import "FileTabBarController.h"
#import "RegisterViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) UILabel *         mainTitleLabel;

@property (nonatomic, strong) UITextField *     userNameTextField;
@property (nonatomic, strong) UITextField *     passwordTextField;

@property (nonatomic, strong) UIButton *        loginButton;
@property (nonatomic, strong) UIButton *        registerButton;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SVProgressHUD setBackgroundColor:RGBA_COLOR(96,96,96,0.3)];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = RGBA_COLOR(0, 175, 145, 1);
    self.title = @"Log in";
    
    self.mainTitleLabel = [[UILabel alloc] init];
    self.mainTitleLabel.size = CGSizeMake(200, 50);
    self.mainTitleLabel.center = CGPointMake(self.view.center.x, 100);
    self.mainTitleLabel.text = @"Log in";
    self.mainTitleLabel.textColor = [UIColor whiteColor];
    self.mainTitleLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.mainTitleLabel];
    
    self.userNameTextField = [[UITextField alloc] init];
    self.userNameTextField.size = CGSizeMake(250, 30);
    self.userNameTextField.center = CGPointMake(self.view.center.x, 150);
    self.userNameTextField.placeholder = @"username";
    self.userNameTextField.backgroundColor = [UIColor whiteColor];
    self.userNameTextField.textColor = [UIColor blackColor];
    self.userNameTextField.layer.cornerRadius = 3;
    [self.view addSubview:self.userNameTextField];
    
    self.passwordTextField = [[UITextField alloc] init];
    self.passwordTextField.size = CGSizeMake(250, 30);
    self.passwordTextField.center = CGPointMake(self.view.center.x, 200);
    self.passwordTextField.placeholder = @"password";
    self.passwordTextField.backgroundColor = [UIColor whiteColor];
    self.passwordTextField.textColor = [UIColor blackColor];
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.layer.cornerRadius = 3;
    [self.view addSubview:self.passwordTextField];
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.loginButton.size = CGSizeMake(100, 50);
    self.loginButton.center = CGPointMake(self.view.center.x, 250);
    [self.loginButton setTitle:@"Log in now!" forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginButton];
    
    self.registerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.registerButton.size = CGSizeMake(100, 30);
    self.registerButton.center = CGPointMake(self.view.center.x, 300);
    self.registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.registerButton setTitle:@"Register" forState:UIControlStateNormal];
    [self.registerButton addTarget:self action:@selector(registerClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.registerButton];
    
#warning test
    self.userNameTextField.text = @"a@a.com";
    self.passwordTextField.text = @"a";
}

- (void)viewWillAppear:(BOOL)animated{
    if (self.navigationController.navigationBarHidden == NO) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    if ([[EBoxNetwork sharedInstance] isStayOnline]) {
        [self loginSuccessWithAnimated:NO];
    }
}

- (void)loginClicked:(UIButton *)sender{
    if ([[self.userNameTextField text] isEqualToString:@""] || [[self.passwordTextField text] isEqualToString:@""]) {
        alert(@"Please enter Email and password");
        return;
    }else{
        [self sendLoginRequest];
    }
}

- (void)sendLoginRequest{
    [SVProgressHUD showWithStatus:@"Loging"];
    __weak LoginViewController *weakSelf = self;
    [[EBoxNetwork sharedInstance] loginWithUserName:self.userNameTextField.text password:self.passwordTextField.text completeSuccessed:^(NSDictionary *responseJson){
        [weakSelf performSelectorOnMainThread:@selector(loginSuccess) withObject:nil waitUntilDone:NO];
    }completeFailed:^(NSString *failedStr){
        [weakSelf performSelectorOnMainThread:@selector(loginFailed:) withObject:failedStr waitUntilDone:NO];
    }];
}

- (void)loginSuccess{
    [self loginSuccessWithAnimated:YES];
}

- (void)loginFailed:(NSString *)failedStr{
    [SVProgressHUD showErrorWithStatus:failedStr];
}

- (void)registerClicked:(id)sender{
    RegisterViewController *regiVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:regiVC animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)loginSuccessWithAnimated:(BOOL)isAnimated{
    if (isAnimated) {
        [SVProgressHUD showSuccessWithStatus:@"Login Successed"];
    }
    FileTabBarController *fileVC = [[FileTabBarController alloc] init];
    fileVC.title = [[EBoxNetwork sharedInstance] loginUserName];
    [self.navigationController pushViewController:fileVC animated:isAnimated];
    [self.navigationController setNavigationBarHidden:NO animated:isAnimated];
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

@end
