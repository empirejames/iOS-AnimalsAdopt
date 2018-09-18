//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "MemberCenterViewController.h"
#import "MemberLoginViewController.h"
#import "MemberUploadViewController.h"
#import "MemberChangePwdViewController.h"
#import "MemberEditDataViewController.h"
#import "MemberBulletinListViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "UserPreferences.h"
@interface MemberCenterViewController ()

@end

@implementation MemberCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)addFind:(id)sender
{
    
    MemberUploadViewController *uploadVC = [[MemberUploadViewController alloc] initWithNibName:@"MemberUploadViewController" bundle:nil];
    
    UINavigationController *uploadVCNavigationController = [[UINavigationController alloc] initWithRootViewController:uploadVC];
    
    [uploadVC setPage_type:0];
    
    [uploadVCNavigationController.navigationBar setHidden:TRUE];
    
    [self presentViewController:uploadVCNavigationController animated:NO completion:nil];
}
- (IBAction)addBulletin:(id)sender
{
    MemberUploadViewController *uploadVC = [[MemberUploadViewController alloc] initWithNibName:@"MemberUploadViewController" bundle:nil];
    
    UINavigationController *uploadVCNavigationController = [[UINavigationController alloc] initWithRootViewController:uploadVC];
    
    [uploadVC setPage_type:1];
    
    [uploadVCNavigationController.navigationBar setHidden:TRUE];
    
    [self presentViewController:uploadVCNavigationController animated:NO completion:nil];
}
- (IBAction)missBulletin:(id)sender
{
    MemberBulletinListViewController *bulletindVC = [[MemberBulletinListViewController alloc] initWithNibName:@"MemberBulletinListViewController" bundle:nil];
    UINavigationController *bulletindNC = [[UINavigationController alloc] initWithRootViewController:bulletindVC];
    
    [bulletindVC setPage_type:0];
    
    [bulletindNC.navigationBar setHidden:TRUE];
    
    [self presentViewController:bulletindNC animated:NO completion:nil];
}
- (IBAction)onlineBulletin:(id)sender
{
    MemberBulletinListViewController *bulletindVC = [[MemberBulletinListViewController alloc] initWithNibName:@"MemberBulletinListViewController" bundle:nil];
    UINavigationController *bulletindNC = [[UINavigationController alloc] initWithRootViewController:bulletindVC];
    
    [bulletindVC setPage_type:1];
    
    [bulletindNC.navigationBar setHidden:TRUE];
    
    [self presentViewController:bulletindNC animated:NO completion:nil];
}
- (IBAction)ChangeUserData:(id)sender
{
    
    MemberEditDataViewController *editDataVC = [[MemberEditDataViewController alloc] initWithNibName:@"MemberEditDataViewController" bundle:nil];
    UINavigationController *editDataNC = [[UINavigationController alloc] initWithRootViewController:editDataVC];
    
    
    
    [editDataNC.navigationBar setHidden:TRUE];
    
    [self presentViewController:editDataNC animated:NO completion:nil];

}
- (IBAction)ChangePwd:(id)sender
{
    
    MemberChangePwdViewController *changePwdVC = [[MemberChangePwdViewController alloc] initWithNibName:@"MemberChangePwdViewController" bundle:nil];
    UINavigationController *changePwdNC = [[UINavigationController alloc] initWithRootViewController:changePwdVC];
    
    
    
    [changePwdNC.navigationBar setHidden:TRUE];
    
    [self presentViewController:changePwdNC animated:NO completion:nil];
    
}

- (IBAction)logout:(id)sender
{
     [UserPreferences setString:@"" forKey:PREF_TOKEN];
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController *mainVCNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    
    
    [mainVCNavigationController.navigationBar setHidden:TRUE];
    
    [self presentViewController:mainVCNavigationController animated:NO completion:nil];
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
