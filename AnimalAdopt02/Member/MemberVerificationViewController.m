//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "MemberVerificationViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "MemberCenterViewController.h"
#import "UserPreferences.h"
#import "Utility.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Word_AES.h"

@interface MemberVerificationViewController (){
    NSMutableData *receivedData;
    NSURLConnection *connection;
    NSURLConnection *check_connection;
    NSURLConnection *resend_connection;
    IBOutlet UITextField *codeTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *pwdTxt;
}

@end

@implementation MemberVerificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (IBAction)btnSend:(id)sender
{
    [self connectHttp:codeTxt.text Email:emailTxt.text passWord:pwdTxt.text URLApi:[NSString stringWithFormat:@"%@Query/MemberModify.ashx?type=8",NSLocalizedString(@"api_ip", @"")]connectFlag:0];
    
    
    
}

- (IBAction)btnReSend:(id)sender
{
    
    if (![emailTxt.text isEqualToString:@""]) {
        [self connectHttp:codeTxt.text Email:emailTxt.text passWord:pwdTxt.text URLApi:[NSString stringWithFormat:@"%@Query/MemberModify.ashx?type=7",NSLocalizedString(@"api_ip", @"")] connectFlag:1 ];
    }else{
        [Utility alertWithTitle:@"" message:@"請輸入email" ];
    }
    
    
}
- (IBAction)btnBack:(id)sender;
{
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController *mainVCNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    
    
    [mainVCNavigationController.navigationBar setHidden:TRUE];
    
    [self presentViewController:mainVCNavigationController animated:NO completion:nil];
}

//http連線接收

-(void)connectHttp:(NSString *)accout Email:(NSString *)emailstr passWord:(NSString *)pwdstr URLApi:(NSString *)url connectFlag:(NSInteger *)flag {
    if(receivedData==nil)
    {
        receivedData = [[NSMutableData alloc] init];
    }
    
    [receivedData setLength:0];
    
    NSURL *aUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSString *httpBodyString=@"";
    
    if (flag==0) {
        
        NSString *Encrypt_accout = [Word_AES encryptAESData:accout];
        
        
        NSString *Encrypt_password = [Word_AES encryptAESData:pwdstr];
        
                
        NSString *Encrypt_email = [Word_AES encryptAESData:emailstr];
        
        httpBodyString=[NSString stringWithFormat:@"pdata={'code':'%@','email':'%@','pwd':'%@'}",Encrypt_accout, Encrypt_email ,Encrypt_password];
        
        [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
        
        check_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if(!check_connection)
        {
            receivedData = nil;
        }
        
        
    }else{
        
        NSString *Encrypt_accout = [Word_AES encryptAESData:accout];
        
        
        NSString *Encrypt_email = [Word_AES encryptAESData:emailstr];
        
        httpBodyString=[NSString stringWithFormat:@"pdata={'code':'%@','email':'%@'}",Encrypt_accout, Encrypt_email];
        
        [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
        
        resend_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if(!resend_connection)
        {
            receivedData = nil;
        }
        
    }
    
    
}

- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

//Tea update
- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    //   NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
    check_connection = nil;
    resend_connection = nil;
    receivedData = nil;
    
    
    [Utility alertWithTitle:@"訊息" message:@"連結失敗!! 請重新送出!!"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connect {
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    
    
    
    
    NSString *strMessage = [res objectForKey:@"Message"];
    
    NSNumber * isSuccessNumber = (NSNumber *)[res objectForKey: @"Success"];
    //顯示取得資料
    /*for (id key in res) {
     NSLog(@"key: %@, value: %@ \n", key, [res objectForKey:key]);
     }*/
    
    
    if([isSuccessNumber boolValue] == YES)
    {
        if (connect==check_connection) {
            [UserPreferences setString:strMessage forKey:PREF_TOKEN];
            strMessage=@"驗證成功";
            
            MemberCenterViewController *mainCenterVC = [[MemberCenterViewController alloc] initWithNibName:@"MemberCenterViewController" bundle:nil];
            UINavigationController *mainVCNavigationController = [[UINavigationController alloc] initWithRootViewController:mainCenterVC];
            
            
            
            [mainVCNavigationController.navigationBar setHidden:TRUE];
            
            [self presentViewController:mainVCNavigationController animated:NO completion:nil];
        }else{
            strMessage=@"重發成功";
        }
    }
    
    
    [Utility alertWithTitle:@"訊息" message:strMessage];
    
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
