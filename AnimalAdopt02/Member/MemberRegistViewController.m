//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "MemberRegistViewController.h"
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

@interface MemberRegistViewController (){
    NSMutableData *receivedData;
    NSURLConnection *connection;
     IBOutlet UITextField *codeTxt;
     IBOutlet UITextField *pwdTxt;
    IBOutlet UITextField *checkpwdTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *nameTxt;
    IBOutlet UITextField *telTxt;
    
    NSString *codeStr;
    NSString *pwdStr;
    NSString *checkpwdStr;
    NSString *emailStr;
    NSString *nameStr;
    NSString *telStr;
}

@end

@implementation MemberRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}



- (IBAction)btnSend:(id)sender
{
    codeStr = codeTxt.text;
    pwdStr = pwdTxt.text;
    checkpwdStr = checkpwdTxt.text;
    emailStr = emailTxt.text;
    nameStr = nameTxt.text;
    telStr = telTxt.text;
    //[Utility alertWithTitle:@"訊息" message:emailStr];
    if ([pwdStr isEqualToString:checkpwdStr]) {
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
    
    
    NSURL *aUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@Query/MemberRegister.ashx",NSLocalizedString(@"api_ip", @"")]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    //By Richard 2018.02.08
    //NSString *httpBodyString=[NSString stringWithFormat:@"pdata={'code':'%@','name':'%@','email':'%@','phone':'%@','pwd':'%@'}",codeStr, nameStr,emailStr,telStr,pwdStr];
    
    
    codeStr = [Word_AES encryptAESData:codeStr];
    
    nameStr = [Word_AES encryptAESData:nameStr];
    
    emailStr = [Word_AES encryptAESData:emailStr];
    
    telStr = [Word_AES encryptAESData:telStr];
    
    pwdStr = [Word_AES encryptAESData:pwdStr];
    
    
    
    NSString *httpBodyString=[NSString stringWithFormat:@"pdata={'code':'%@','name':'%@','email':'%@','phone':'%@','pwd':'%@'}",codeStr, nameStr,emailStr,telStr,pwdStr];
    
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
   /* for (id key in res) {
        NSLog(@"key: %@, value: %@ \n", key, [res objectForKey:key]);
    }*/
    
   
    
 
    
    if([isSuccessNumber boolValue] == YES)
    {
        [UserPreferences setString:strMessage forKey:PREF_TOKEN];
        strMessage=@"註冊成功";
    
    MemberVerificationViewController *verificatVC = [[MemberVerificationViewController alloc] initWithNibName:@"MemberVerificationViewController" bundle:nil];
        
    UINavigationController *verificatVCNavigationController = [[UINavigationController alloc] initWithRootViewController:verificatVC];
    
    
    
    [verificatVCNavigationController.navigationBar setHidden:TRUE];
    
    [self presentViewController:verificatVCNavigationController animated:NO completion:nil];
    
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
