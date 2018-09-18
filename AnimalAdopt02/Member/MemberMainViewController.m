//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "MemberMainViewController.h"
#import "MemberLoginViewController.h"
#import "MemberRegistViewController.h"
#import "MemberForgetViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"

@interface MemberMainViewController ()

@end

@implementation MemberMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)Login:(id)sender
{
    
    MemberLoginViewController *loginVC = [[MemberLoginViewController alloc] initWithNibName:@"MemberLoginViewController" bundle:nil];
    
    UINavigationController *loginVCNavigationController = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    
    
    [loginVCNavigationController.navigationBar setHidden:TRUE];
    
    [self presentViewController:loginVCNavigationController animated:NO completion:nil];
}

- (IBAction)Regist:(id)sender
{
    MemberRegistViewController *registVC = [[MemberRegistViewController alloc] initWithNibName:@"MemberRegistViewController" bundle:nil];
    
    UINavigationController *registVCNavigationController = [[UINavigationController alloc] initWithRootViewController:registVC];
    
    
    
    [registVCNavigationController.navigationBar setHidden:TRUE];
    
    [self presentViewController:registVCNavigationController animated:NO completion:nil];
}

- (IBAction)Forget:(id)sender
{
    MemberForgetViewController *forgetVC = [[MemberForgetViewController alloc] initWithNibName:@"MemberForgetViewController" bundle:nil];
    
    UINavigationController *forgetVCNavigationController = [[UINavigationController alloc] initWithRootViewController:forgetVC];
    
    
    
    [forgetVCNavigationController.navigationBar setHidden:TRUE];
    
    [self presentViewController:forgetVCNavigationController animated:NO completion:nil];
}

- (IBAction)btnHome:(id)sender
{
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    UINavigationController *mainVCNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    
    
    [mainVCNavigationController.navigationBar setHidden:TRUE];
    
    [self presentViewController:mainVCNavigationController animated:NO completion:nil];
}
- (IBAction)btnNav:(id)sender;
{
   if (![self.jdsideMenuController isMenuVisible]) {
       
        [self.jdsideMenuController showMenuAnimated:YES ];
       
    }else{
        
        [self.jdsideMenuController hideMenuAnimated:YES];
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

@end
