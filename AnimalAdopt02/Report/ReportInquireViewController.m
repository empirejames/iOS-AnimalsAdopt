//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "MemberMainViewController.h"
#import "MemberUploadViewController.h"
#import "ReportInquireViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "AdoptMainViewController.h"
#import "UserPreferences.h"

@interface ReportInquireViewController ()

@end

@implementation ReportInquireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)call:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"選擇撥號電話" message:@"" delegate:self cancelButtonTitle:@"關閉" otherButtonTitles:@"撥打(02)87913064", @"撥打(02)87913065", nil];
    
    [alert show];

    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    NSString *strPh =@"";
    
    switch (buttonIndex) {
        case 0:
            //NSLog(@"Cancel Button Pressed");
            break;
        case 1:
            strPh = [@"0287913064" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
           
            break;
        case 2:
            strPh = [@"0287913065" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
            
            break;
        default:
            break;
    }
    
    if(buttonIndex!=0){
    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",strPh]];
    
    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
        [[UIApplication sharedApplication] openURL:phoneUrl];
    } else{
        UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [calert show];
    }
    }
    
}


- (IBAction)send_email:(id)sender
{
    NSString *subject =@"我想要諮詢";
    
    NSString *body = @"";
    
    //By Richard 2017.08.16
    NSString *address = @"tcapo.animalwelfare@mail.gov.taipei";
    
    //NSString *cc = @"test2@akosma.com";       副本
    
    NSString *path = [NSString stringWithFormat:@"mailto:%@?&subject=%@&body=%@", address, subject, body];
    
    NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    [[UIApplication sharedApplication] openURL:url];
    

}

- (IBAction)btnBack:(id)sender;
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
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
