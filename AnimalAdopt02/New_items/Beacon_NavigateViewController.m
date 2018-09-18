//
//  Beacon_NavigateViewController.m
//  AnimalAdopt02
//
//  Created by Enrf_macmini on 2016/10/21.
//  Copyright (c) 2016年 tcapo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Beacon_NavigateViewController.h"
#import "MemberMainViewController.h"
#import "MemberUploadViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "AdoptMainViewController.h"
#import "UserPreferences.h"

#define TEST_POWER_UUID @"00112233-4455-6677-8899-AABBCCDDEEFF"

@interface Beacon_NavigateViewController ()
{
    
    NSString *getUrl;
    
    NSURL *url , *Nobeacon_url;
    
    NSURLRequest *request;
    
    NSTimer *timer;
    
    
    NSMutableData *receivedData;
    
    NSURLConnection *connection;
    
    BOOL is_BeaconCountZero;
    
}

@property (strong,nonatomic) USBCManager * manager;
@property (retain,nonatomic) BeaconDetect * detect;


-(void)showWebView:(NSString*)showUrl;


@end

@implementation Beacon_NavigateViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    getUrl = @"" ;
    
    self.myWeb.delegate = self;
    
    self.myWeb.scalesPageToFit = YES;
    
    
    //USBC Data Fetch.  ( To keep it simple, we just fetch data from usbeacom.com.tw every time the App start.)
    
    _manager = [USBCManager defaultManager];
    
    _manager.delegate = self;
    
    /********** REPLACE the Data Query UUID with yours *********/
    //It's a Data Query UUID of test@thlight.com
    
    [_manager updateDevicesWithDataQueryUUID:@"0BB80447-712C-4D89-BD0D-5E2954BCE2E6"];
    
    
    //[_manager updateDevicesWithDataQueryUUID:@"59E6829F-C5D9-4CE6-B2B8-ECC5ABDD737D"];


    
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showWebView:) userInfo:nil repeats:NO];
    
    
}

-(void)showWebView:(NSString *)showUrl
{
    NSLog(@"getUrl in showWebView : %@",getUrl);
    
    
    if ([getUrl isEqualToString:@""]) {
        
        NSString *NoBeacon_Str =[[NSBundle mainBundle] pathForResource:@"nobeacon.html" ofType:nil];
        
        //呼叫方法載入資料
        NSData *NoBeacon_Data =[NSData dataWithContentsOfFile:NoBeacon_Str];
        
        NSString * NoBeacon_html =[[NSString alloc] initWithData:NoBeacon_Data encoding:NSUTF8StringEncoding];
        
        NSURL *NoBeacon_Url = [NSURL fileURLWithPath:NoBeacon_Str];
        
        [self.myWeb loadHTMLString:NoBeacon_html baseURL:NoBeacon_Url];
        
    } else {
        
        url = [NSURL URLWithString:getUrl];
        
        request = [NSURLRequest requestWithURL:url];
        
        [self.myWeb loadRequest:request];
    }

    
    [self connectHttp];
    
    
}


-(void)connectHttp
{
    
    if(receivedData == nil)
    {
        receivedData = [[NSMutableData alloc] init];
    }
    
    [receivedData setLength:0];
    
    
    NSString *img_url =[NSString stringWithFormat:@"%@/Query/AppPartnerItem.ashx?id=%@",NSLocalizedString(@"api_ip", @""),@"1"];
    
    NSLog(@"%@",img_url);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:img_url]];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection)
    {
        receivedData = nil;
    }
    
}

- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

//Tea update
- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error
{
    NSLog(@"connection: didFailWithError");
    
    connection = nil;
    receivedData = nil;
    
    //No WIFI 連結失敗!! 請開啟WIFI!!
    
    NSString * str=[[NSBundle mainBundle] pathForResource:@"nowifi.html" ofType:nil];
    
    NSData * data=[NSData dataWithContentsOfFile:str];
    
    NSString * htmlStr=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSURL * baseurl=[NSURL fileURLWithPath:str];
    
    [self.myWeb loadHTMLString:htmlStr baseURL:baseurl];
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
    
    // convert to JSON
    
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

#pragma mark UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    //NSLog(@"shouldStartLoadWithRequest");
    
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [hud setLabelText:@"Loading..."];
    

}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
}




-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    
    //[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    NSLog(@"NoWIFI in webView didFailLoadWithError");
   
}


- (IBAction)goBack:(UIButton *)sender
{
    if ([self.myWeb canGoBack]) {
        
        [self.myWeb goBack];
        
    }
    else {
        
        return;
    }
    
}


#pragma mark USBCManagerDelegate

-(void)USBCManagerUpdateComplete
{
    
    NSLog(@"In %s Beacon Data Fetched from Server has been saved in your iPhone/iPad", __func__);
    
    //Print All Fetched Data
    
    NSLog(@"List all USBeacon device information");
    
    NSArray * array = [_manager allDevices];
    
    for (int i = 0; i < array.count; i++) {
        
        USBeaconDevice * device = (USBeaconDevice *)array[i];
        
        [device logDevice];
    }
    
    //Let our iPhone search nearby iBeacons.
      
    NSArray * uuids = @[@"60E00097-83AD-4758-B8EE-C9C89D9C3227"];
    
    //NSArray * uuids = @[@"36888567-6ACE-4171-834D-9F5D577D4B5C"];
    
    _detect = [BeaconDetect detectBeaconWithUUIDs:uuids];
    
    _detect.delegate = self;
    
    //set the detect power voltage special UUID with yours
    [_detect setUUIDForDetectPowerVoltage:TEST_POWER_UUID];
    
    [_detect startSearching];
}

-(void)USBCManagerUpdateError:(NSError *)error
{
    //NSLog(@"%@",error);
    
}


#pragma mark BeaconDetectDelegate
-(void)beaconListChangeTo:(NSArray*)beacons
{
    //Update Beacon List Here(including all UUID you targeted);
}

-(void)nearestBeaconChangeTo:(CLBeacon*)beacon
{
    
    USBeaconDevice * deviceData = [_manager deviceWithMajor:beacon.major.intValue Minor:beacon.minor.intValue];
    
    /*
    _beaconDataTextView.text = [NSString stringWithFormat:@"名稱: %@\n描述: %@\n電話: %@\n備註: %@\n網址: %@\n自定Key: %@",
                                deviceData.name,
                                deviceData.info.describe,
                                deviceData.info.tel,
                                deviceData.info.note,
                                deviceData.info.url,
                                deviceData.info.extend
                                ];*/
    
    getUrl = deviceData.info.url;
    
    NSLog(@"getUrl in nearestBeaconChangeTo : %@",getUrl);
    
    //By Richard 2016.12.06
    //Show NearestBeacon Content 
    url = [NSURL URLWithString:getUrl];
    
    request = [NSURLRequest requestWithURL:url];
    
    [self.myWeb loadRequest:request];
    
   
}

//when BeaconDetect detected a beacon power data, it will call this method to notify delegate
-(void)didReceivedPowerVoltage:(float)voltage fromBeacon:(NSString *)mac
{
    //update UI component
    //self.BeaconPowerLabel.text = [NSString stringWithFormat:@"Voltage: %1.1f   From_Mac:%@", voltage, mac];
    //do anything you want, upload data to backend server...
}

@end
