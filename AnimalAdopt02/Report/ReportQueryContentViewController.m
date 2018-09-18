//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "ReportQueryContentViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "MemberCenterViewController.h"
#import "UserPreferences.h"
#import "Utility.h"
#import "ASIFormDataRequest.h"
#import <CoreLocation/CoreLocation.h>
#import "EditEntity.h"
#import "ReportLoginUploadViewController.h"

@interface ReportQueryContentViewController (){
    NSMutableData *receivedData;
    NSURLConnection *connection;
   
    IBOutlet UILabel *txt_r_no;
   
    IBOutlet UILabel *txt_r_type;
    
    
    IBOutlet UILabel *txt_place;
    
    
    IBOutlet UILabel *txt_memo;
    
    
    
    IBOutlet UILabel *txt_r_status;
    
    
    IBOutlet UILabel *txt_r_status2;
    
 
}

@end

@implementation ReportQueryContentViewController

@synthesize str_r_no;
@synthesize str_r_type;
@synthesize str_place;
@synthesize str_memo;
@synthesize str_r_status;
@synthesize str_r_status2;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [txt_r_no setText:[NSString stringWithFormat:@"案件碼：%@",str_r_no]];
    [txt_r_type setText:[NSString stringWithFormat:@"案件內容：%@",str_r_type]];
    [txt_place setText:[NSString stringWithFormat:@"案件地點：%@",str_place]];
    [txt_memo setText:[NSString stringWithFormat:@"案件情節：%@",str_memo]];
    
    [txt_r_status setText:[NSString stringWithFormat:@"案件狀態：%@",str_r_status]];
    
    [txt_r_status2 setText:[NSString stringWithFormat:@"說明：%@",str_r_status2]];
    
}



- (IBAction)btnBack:(UIButton *)sender {
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}




//縮鍵盤
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
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

@end
