//
//  Pet_registration_inventoryViewController.m
//  AnimalAdopt02
//
//  Created by Enrf_macmini on 2016/10/21.
//  Copyright (c) 2016年 tcapo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Pet_registration_inventoryViewController.h"
#import "MemberMainViewController.h"
#import "MemberUploadViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "AdoptMainViewController.h"
#import "UserPreferences.h"

@interface Pet_registration_inventoryViewController ()
{
    NSURL *url;
    
    NSURLRequest *request;
}

@end

@implementation Pet_registration_inventoryViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.myWeb.delegate = self;
    
    self.myWeb.scalesPageToFit = YES;
    
    url = [NSURL URLWithString:@"http://www.pet.gov.taipei/AppPublic/Default.aspx"];
    
    request = [NSURLRequest requestWithURL:url];
    
    [self.myWeb loadRequest:request];
    
}

- (IBAction)btnHome:(UIButton *)sender
{
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    
    UINavigationController *mainVCNavigationCoontroller = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    [mainVCNavigationCoontroller.navigationBar setHidden:TRUE];
    
    [self presentViewController:mainVCNavigationCoontroller animated:NO completion:nil];
}

- (IBAction)btnNav:(UIButton *)sender
{
    if (![self.jdsideMenuController isMenuVisible]) {
        
        [self.jdsideMenuController showMenuAnimated:YES];
        
    } else {
        
        [self.jdsideMenuController showMenuAnimated:YES];
        
    }
}



-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //NSLog(@"shouldStartLoadWithRequest");
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    //[actIndcatView startAnimating];
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [hud setLabelText:@"Loading..."];
    
    //[hud setLabelText:@"讀取中..."];
    
    //NSLog(@"Loading...");
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    //[actIndcatView stopAnimating];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    //NSLog(@"Finish");
    
}




-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    /*
    NSString *html = @"<html><head><style>body {font-size:88px; color:black ; background-color:FFFFFF}</style></head><body>頁面下載錯誤,請檢查網路是否開啟及連線狀況,謝謝。</body></html>";
    
    [self.myWeb loadHTMLString:html baseURL:nil];*/
    
    //By Richard 2016.11.17
    NSString * str=[[NSBundle mainBundle] pathForResource:@"nowifi.html" ofType:nil];
    
    NSData * data=[NSData dataWithContentsOfFile:str];
    
    NSString * htmlStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSURL * baseurl=[NSURL fileURLWithPath:str];
    
    [self.myWeb loadHTMLString:htmlStr baseURL:baseurl];

}


- (IBAction)goBack:(UIButton *)sender
{
    if ([self.myWeb canGoBack]) {
        
        [self.myWeb goBack];
        
        //NSLog(@"goBack");
    }
    else {
        
        return;
    }
    
}
@end
