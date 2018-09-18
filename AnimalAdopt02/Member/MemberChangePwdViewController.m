//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "MemberChangePwdViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "MemberCenterViewController.h"
#import "UserPreferences.h"
#import "Utility.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Word_AES.h"

@interface MemberChangePwdViewController (){
    NSMutableData *receivedData;
    NSURLConnection *connection;
     IBOutlet UITextField *oldPwdTxt;
     IBOutlet UITextField *newPwdTxt;
    IBOutlet UITextField *checkPwdTxt;
    NSString *oldPwd_str,*newPwd_str,*checkPwd_str;
}

@end

@implementation MemberChangePwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (IBAction)btnSend:(id)sender
{
    
    oldPwd_str = oldPwdTxt.text;
    newPwd_str = newPwdTxt.text;
    checkPwd_str = checkPwdTxt.text;
    if ([newPwd_str isEqualToString:checkPwd_str]) {
         [self connectHttp];
    }else{
        [Utility alertWithTitle:@"訊息" message:@"密碼與確認密碼不同"];
    }
   
}
- (IBAction)btnBack:(id)sender;
{
   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

//http連線接收

-(void)connectHttp{
    if(receivedData==nil)
    {
        receivedData = [[NSMutableData alloc] init];
    }
    
    [receivedData setLength:0];
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@Query/MemberModify.ashx?type=1",NSLocalizedString(@"api_ip", @"")]
                   ];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    oldPwd_str = oldPwdTxt.text;
    newPwd_str = newPwdTxt.text;
    checkPwd_str = checkPwdTxt.text;
    
    //By Richard 2018.01.31
    NSString *Encrypt_oldPwd = [Word_AES encryptAESData:oldPwd_str];
    
    
    NSString *Encrypt_newPwd = [Word_AES encryptAESData:newPwd_str];
    
    
    NSString *Encrypt_checkPwd = [Word_AES encryptAESData:checkPwd_str];
    
    NSString *Encrypt_Key = [Word_AES encryptAESData:[UserPreferences getStringForKey:PREF_TOKEN]];
    
    
    //NSString *httpBodyString=[NSString stringWithFormat:@"pdata={'key':'%@','pwd':'%@','pwd1':'%@','pwd2':'%@'}",[UserPreferences getStringForKey:PREF_TOKEN],oldPwd_str, newPwd_str,checkPwd_str];
    
    NSString *httpBodyString=[NSString stringWithFormat:@"pdata={'key':'%@','pwd':'%@','pwd1':'%@','pwd2':'%@'}",Encrypt_Key,Encrypt_oldPwd, Encrypt_newPwd,Encrypt_checkPwd];
    
    
    [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection)
    {
        receivedData = nil;
    }
    
}

- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

//Tea update
- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    //   NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
    connection = nil;
    receivedData = nil;
    
    
    [Utility alertWithTitle:@"訊息" message:@"連結失敗!! 請重新送出!!"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
    
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
        strMessage=@"修改成功";
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
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
