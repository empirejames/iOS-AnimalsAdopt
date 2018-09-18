//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "ReportInfoViewController.h"
#import "ReportInquireViewController.h"
#import "ReportQueryViewController.h"

#import "MemberUploadViewController.h"
#import "ReportMainViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "AdoptMainViewController.h"
#import "ReportLoginViewController.h"
#import "UserPreferences.h"

@interface ReportMainViewController ()

@end

@implementation ReportMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)addInfo:(id)sender
{
    ReportInfoViewController *infoVC = [[ReportInfoViewController alloc] initWithNibName:@"ReportInfoViewController" bundle:nil];
    UINavigationController *infoNC = [[UINavigationController alloc] initWithRootViewController:infoVC];
    
    
    
    [infoNC.navigationBar setHidden:TRUE];
    
    [self presentViewController:infoNC animated:NO completion:nil];

    
}
- (IBAction)addLogin:(id)sender
{
    ReportLoginViewController *bulletinVC = [[ReportLoginViewController alloc] initWithNibName:@"ReportLoginViewController" bundle:nil];
    UINavigationController *bulletinNC = [[UINavigationController alloc] initWithRootViewController:bulletinVC];
    
    [bulletinNC.navigationBar setHidden:TRUE];
    
    [self presentViewController:bulletinNC animated:NO completion:nil];
}
- (IBAction)addQuery:(id)sender
{
    
    
        ReportQueryViewController *queryVC = [[ReportQueryViewController alloc] initWithNibName:@"ReportQueryViewController" bundle:nil];
        UINavigationController *queryNC = [[UINavigationController alloc] initWithRootViewController:queryVC];
        [queryNC.navigationBar setHidden:TRUE];
        
        [self presentViewController:queryNC animated:NO completion:nil];
   }
- (IBAction)addInquire:(id)sender
{
   
    ReportInquireViewController *inquireVC = [[ReportInquireViewController alloc] initWithNibName:@"ReportInquireViewController" bundle:nil];
        UINavigationController *inquireNC = [[UINavigationController alloc] initWithRootViewController:inquireVC];
        [inquireNC.navigationBar setHidden:TRUE];
        
        [self presentViewController:inquireNC animated:NO completion:nil];
    
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
