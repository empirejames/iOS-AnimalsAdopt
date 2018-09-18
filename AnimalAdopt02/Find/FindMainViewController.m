//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "MemberMainViewController.h"
#import "MemberUploadViewController.h"
#import "FindMainViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "AdoptMainViewController.h"
#import "UserPreferences.h"

@interface FindMainViewController ()

@end

@implementation FindMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)find:(id)sender
{
    AdoptMainViewController *findVC = [[AdoptMainViewController alloc] initWithNibName:@"AdoptMainViewController" bundle:nil];
    [findVC setPageType: 0];
    
    UINavigationController *findNC = [[UINavigationController alloc] initWithRootViewController:findVC];
    
    
    
    [findNC.navigationBar setHidden:TRUE];
    
    [self presentViewController:findNC animated:NO completion:nil];

    
}
- (IBAction)bulletin:(id)sender
{
    AdoptMainViewController *bulletinVC = [[AdoptMainViewController alloc] initWithNibName:@"AdoptMainViewController" bundle:nil];
    [bulletinVC setPageType: 1];
    
    UINavigationController *bulletinNC = [[UINavigationController alloc] initWithRootViewController:bulletinVC];
    
    
    
    [bulletinNC.navigationBar setHidden:TRUE];
    
    [self presentViewController:bulletinNC animated:NO completion:nil];
}

- (IBAction)addFind:(id)sender
{
    NSString *showtoken = [UserPreferences getStringForKey:PREF_TOKEN];
    
    if(showtoken==nil || [showtoken isEqualToString:@""])
    {
        MemberMainViewController *memberMainVC = [[MemberMainViewController alloc] initWithNibName:@"MemberMainViewController" bundle:nil];
        
        UINavigationController *memberMainNC = [[UINavigationController alloc] initWithRootViewController:memberMainVC];
        
        //By Richard 2016.11.27
        [memberMainNC.navigationBar setHidden:TRUE];
        
        [self presentViewController:memberMainNC animated:NO completion:nil];
        
    }else{
        
        MemberUploadViewController *uploadVC = [[MemberUploadViewController alloc] initWithNibName:@"MemberUploadViewController" bundle:nil];
        
        UINavigationController *uploadVCNavigationController = [[UINavigationController alloc] initWithRootViewController:uploadVC];
        
        [uploadVC setPage_type:0];
        
        [uploadVCNavigationController.navigationBar setHidden:TRUE];
        
        [self presentViewController:uploadVCNavigationController animated:NO completion:nil];
    }
}
- (IBAction)addBulletin:(id)sender
{
    NSString *showtoken = [UserPreferences getStringForKey:PREF_TOKEN];
    
    if(showtoken==nil || [showtoken isEqualToString:@""])
    {
        MemberMainViewController *memberMainVC = [[MemberMainViewController alloc] initWithNibName:@"MemberMainViewController" bundle:nil];
        
        UINavigationController *memberMainNC = [[UINavigationController alloc] initWithRootViewController:memberMainVC];
        
        [memberMainNC.navigationBar setHidden:TRUE];
        
        [self presentViewController:memberMainNC animated:NO completion:nil];
        
    }else{
        
        MemberUploadViewController *uploadVC = [[MemberUploadViewController alloc] initWithNibName:@"MemberUploadViewController" bundle:nil];
        
        UINavigationController *uploadVCNavigationController = [[UINavigationController alloc] initWithRootViewController:uploadVC];
        
        [uploadVC setPage_type:1];
        
        [uploadVCNavigationController.navigationBar setHidden:TRUE];
        
        [self presentViewController:uploadVCNavigationController animated:NO completion:nil];
    }

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
