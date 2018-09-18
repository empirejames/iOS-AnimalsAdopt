//
//  FindMainViewController.h
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PassValueDelegate.h"

@interface ReportLoginViewController : UIViewController<CLLocationManagerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>

@property NSInteger *page_type;
@property NSMutableArray *dataAry;

@end
