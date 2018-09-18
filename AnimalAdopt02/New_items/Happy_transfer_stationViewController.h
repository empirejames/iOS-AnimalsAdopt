//
//  Happy_transfer_stationViewController.h
//  AnimalAdopt02
//
//  Created by Enrf_macmini on 2016/10/21.
//  Copyright (c) 2016年 tcapo. All rights reserved.
//

#ifndef AnimalAdopt02_Happy_transfer_stationViewController_h
#define AnimalAdopt02_Happy_transfer_stationViewController_h


#endif




#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@interface Happy_transfer_stationViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWeb;


@property (weak, nonatomic) IBOutlet UIButton *goBack;

- (IBAction)goBack:(UIButton *)sender;

@end
