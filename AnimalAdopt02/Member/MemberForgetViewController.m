//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "MemberForgetViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "MemberCenterViewController.h"
#import "UserPreferences.h"
#import "Utility.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Word_AES.h"

@interface MemberForgetViewController (){
    NSMutableData *receivedData;
    NSURLConnection *connection;
     IBOutlet UITextField *codeTxt;
     IBOutlet UITextField *emailTxt;
}

@end

@implementation MemberForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (IBAction)btnSend:(id)sender
{
       [self connectHttp:codeTxt.text Email:emailTxt.text];
}
- (IBAction)btnBack:(id)sender;
{
   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

//http連線接收

-(void)connectHttp:(NSString *)accout Email:(NSString *)emailstr{
    
    if(receivedData==nil)
    {
        receivedData = [[NSMutableData alloc] init];
    }
    
    [receivedData setLength:0];
    
      
    NSURL *aUrl = [NSURL URLWithString: [NSString stringWithFormat:@"%@Query/MemberModify.ashx?type=6",NSLocalizedString(@"api_ip", @"")]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    
    //NSString *httpBodyString=[NSString stringWithFormat:@"pdata={'code':'%@','email':'%@'}",accout, emailstr];
    
    //By Richard 2018.01.31
    
    NSString *Encrypt_accout = [Word_AES encryptAESData:accout];
    
    NSLog(@"Encrypt_accout :  %@" , Encrypt_accout);
    
    NSString *Encrypt_email = [Word_AES encryptAESData:emailstr];
    
    //NSLog(@"Encrypt_password :  %@" , Encrypt_password);
    
    NSString *httpBodyString=[NSString stringWithFormat:@"pdata={'code':'%@','email':'%@'}",Encrypt_accout, Encrypt_email];

    
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
    
    
    [Utility alertWithTitle:@"訊息" message:@"連結失敗!! 請重新登入!!"];
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
        strMessage=@"已寄送信箱";
    
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
