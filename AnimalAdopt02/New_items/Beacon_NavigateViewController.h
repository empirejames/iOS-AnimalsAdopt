//
//  Beacon_NavigateViewController.h
//  AnimalAdopt02
//
//  Created by Enrf_macmini on 2016/10/21.
//  Copyright (c) 2016年 tcapo. All rights reserved.
//

#ifndef AnimalAdopt02_Beacon_NavigateViewController_h
#define AnimalAdopt02_Beacon_NavigateViewController_h


#endif


#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

//Fetch USBeacon Data On usbeacon.com.tw
#import "USBCManager.h"
#import "USBeaconDevice.h"
#import "USBeaconInfo.h"

//Help you quick setup iBeacon Detect
#import "BeaconDetect.h"

@interface Beacon_NavigateViewController : UIViewController <UIWebViewDelegate,USBCManagerDelegate,BeaconDetectDelegate>


@property (weak, nonatomic) IBOutlet UIWebView *myWeb;
@property (weak, nonatomic) IBOutlet UIButton *goBack;

- (IBAction)goBack:(UIButton *)sender;

@end
