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

@interface ReportLoginUploadViewController : UIViewController<CLLocationManagerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>



@property NSString *str_r_name;
@property NSString *str_r_idno;
@property NSString *str_r_phone;
@property NSString *str_r_email;
@property NSString *str_r_addr;
@property NSString *str_r_sex;

@property NSString *str_r_name_o;
@property NSString *str_r_idno_o;



@end
