//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "MemberEditDataViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "MemberCenterViewController.h"
#import "MemberVerificationViewController.h"
#import "UserPreferences.h"
#import "Utility.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Word_AES.h"

@interface MemberEditDataViewController (){
    NSMutableData *receivedData;
    NSURLConnection *connection;
    IBOutlet UILabel *codeTxt;
    IBOutlet UITextField *emailTxt;
    IBOutlet UITextField *nameTxt;
    IBOutlet UITextField *telTxt;
    NSString *code_str,*email_str,*name_str,*tel_str;
    NSString *old_email;
    int connectFlag;
}

@end

@implementation MemberEditDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //By Richard 2018.02.09
    
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"您同意將個人相關資料，傳送給台北市動物保護處嗎?" message:@"" delegate:self cancelButtonTitle:@"不同意" otherButtonTitles:@"同意", nil];
    
    
    [alertV show];
    
    connectFlag = 0;
    [self connectHttp];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            //By Richard 2018.02.09
            //NSLog(@"Cancel Button Pressed");
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            break;
        case 1:
            //[self.navigationController dismissViewControllerAnimated:NO completion:nil];
            break;
        default:
            break;
    }
    
}

- (IBAction)btnSend:(id)sender
{
    
    email_str = emailTxt.text;
    name_str = nameTxt.text;
    tel_str = telTxt.text;
    connectFlag = 1;
    [self connectHttp];
    
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
    
    NSString *urlApi = @"";
    
    
    
    if (connectFlag==0) {
        urlApi = [NSString stringWithFormat:@"%@Query/MemberModify.ashx?type=9",NSLocalizedString(@"api_ip", @"")];
    }else if (connectFlag==1){
        urlApi = [NSString stringWithFormat:@"%@Query/MemberModify.ashx?type=2",NSLocalizedString(@"api_ip", @"")];
    }else{
        urlApi = [NSString stringWithFormat:@"%@Query/MemberModify.ashx?type=7",NSLocalizedString(@"api_ip", @"")];
    }
    
    NSURL *aUrl = [NSURL URLWithString:urlApi];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSString *httpBodyString=@"";
    
    if (connectFlag==0) {
        
        //By Richard 2018.02.08
        NSString *Encrypt_Key = [Word_AES encryptAESData:[UserPreferences getStringForKey:PREF_TOKEN]];
        
        //httpBodyString=[NSString stringWithFormat:@"pdata={'key':'%@'}",[UserPreferences getStringForKey:PREF_TOKEN]];
        
        httpBodyString=[NSString stringWithFormat:@"pdata={'key':'%@'}",Encrypt_Key];
        
    }else if (connectFlag==1){
        
        //By Richard 2018.02.08
        
        NSString *Encrypt_name = [Word_AES encryptAESData:name_str];
        
        NSString *Encrypt_tel_str = [Word_AES encryptAESData:tel_str];
        
        
        NSString *Encrypt_email = [Word_AES encryptAESData:email_str];
        
        NSString *Encrypt_Key = [Word_AES encryptAESData:[UserPreferences getStringForKey:PREF_TOKEN]];
        
        //httpBodyString=[NSString stringWithFormat:@"pdata={'key':'%@','name':'%@','email':'%@','phone':'%@'}",[UserPreferences getStringForKey:PREF_TOKEN], name_str,email_str,tel_str];
        
        
        httpBodyString=[NSString stringWithFormat:@"pdata={'key':'%@','name':'%@','email':'%@','phone':'%@'}",Encrypt_Key, Encrypt_name,Encrypt_email,Encrypt_tel_str];
    
    }else{
        
        //By Richard 2018.02.08
        
        NSString *Encrypt_accout = [Word_AES encryptAESData:codeTxt.text];
        
        NSString *Encrypt_email = [Word_AES encryptAESData:email_str];
        
        //httpBodyString=[NSString stringWithFormat:@"pdata={'code':'%@','email':'%@'}",codeTxt.text, email_str];
        
        httpBodyString=[NSString stringWithFormat:@"pdata={'code':'%@','email':'%@'}",Encrypt_accout, Encrypt_email];
    }
    
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
    
    NSString *strMessage = @"";
    
    if (connectFlag==0) {
        
        
        [codeTxt setText:[res objectForKey:@"code"]];
        [emailTxt setText:[res objectForKey:@"email"]];
        old_email =[res objectForKey:@"email"];
        [nameTxt setText:[res objectForKey:@"name"]];
        [telTxt setText:[res objectForKey:@"phone"]];
    }else if(connectFlag==1){
        strMessage = [res objectForKey:@"Message"];
        
        NSNumber * isSuccessNumber = (NSNumber *)[res objectForKey: @"Success"];
        
        
        
        if([isSuccessNumber boolValue] == YES)
        {
            
            
            if (![old_email isEqualToString:emailTxt.text]) {
                
                connectFlag = 2;
                [self connectHttp];
                
                
            }else{
                strMessage=@"修改成功";
                [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            }
            
            
        }else{
            strMessage  = @"連結失敗，請重新送出!!";
        }
        
        [Utility alertWithTitle:@"訊息" message:strMessage];
        
    }else{
        strMessage = [res objectForKey:@"Message"];
        
        NSNumber * isSuccessNumber = (NSNumber *)[res objectForKey: @"Success"];
        
        
        
        if([isSuccessNumber boolValue] == YES)
        {
            
            [UserPreferences setString:@"" forKey:PREF_TOKEN];
            
            MemberVerificationViewController *verificatVC = [[MemberVerificationViewController alloc] initWithNibName:@"MemberVerificationViewController" bundle:nil];
            UINavigationController *verificatVCNavigationController = [[UINavigationController alloc] initWithRootViewController:verificatVC];
            
            [verificatVCNavigationController.navigationBar setHidden:TRUE];
            
            [self presentViewController:verificatVCNavigationController animated:NO completion:nil];
            //  strMessage  = [strMessage stringByAppendingString:@"修改成功,請至信箱重新認證!!"];
            strMessage  = @"修改成功,請至信箱重新認證!!";
        }else{
            strMessage  = @"連結失敗，請重新點擊認證!!";
        }
        
        [Utility alertWithTitle:@"訊息" message:strMessage];
        
    }
    
    
    
    
    
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
