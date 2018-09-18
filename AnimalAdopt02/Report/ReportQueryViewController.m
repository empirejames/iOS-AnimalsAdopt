//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "ReportQueryViewController.h"
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
#import "ReportQueryContentViewController.H"


@interface ReportQueryViewController (){
    NSMutableData *receivedData;
    NSURLConnection *connection;
    IBOutlet UITextField *txt_code1;
    IBOutlet UITextField *txt_code2;
    NSString *str_code1,*str_code2;
   NSString *str_r_no,*str_r_type,*str_place,*str_memo,*str_r_status,*str_r_status2;
    
    

}

@end

@implementation ReportQueryViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    str_code1 = @"";
    str_code2 = @"";
    
  
}



- (IBAction)btnSend:(id)sender
{
    
     str_code1 = txt_code1.text;
    str_code2 = txt_code2.text;
    
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
    
  
    
  NSString  *urlApi =[NSString stringWithFormat:@"%@Query/ReportQuery.ashx?no=%@&auth=%@",NSLocalizedString(@"api_ip", @""),str_code1,str_code2];
        
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlApi]];

        
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection)
    {
        receivedData = nil;
    }
    
}

- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}



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
    
    
        str_r_no = [res objectForKey:@"r_no"];
        str_r_type = [res objectForKey:@"r_type"];
        str_place = [res objectForKey:@"place"];
        str_memo = [res objectForKey:@"memo"];
        str_r_status = [res objectForKey:@"r_status"];
        str_r_status2 = [res objectForKey:@"r_status2"];
    
    //By Richard 2017.08.22
    ReportQueryContentViewController *queryVC = [[ReportQueryContentViewController alloc] initWithNibName:@"ReportQueryContentViewController2" bundle:nil];
    UINavigationController *queryNC = [[UINavigationController alloc] initWithRootViewController:queryVC];
    
    [queryVC setStr_r_no:str_r_no];
    [queryVC setStr_r_type:str_r_type];
    [queryVC setStr_place:str_place];
    [queryVC setStr_memo:str_memo];
    [queryVC setStr_r_status:str_r_status];
    [queryVC setStr_r_status2:str_r_status2];
    
    [queryNC.navigationBar setHidden:TRUE];
    
    [self presentViewController:queryNC animated:NO completion:nil];
    
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
