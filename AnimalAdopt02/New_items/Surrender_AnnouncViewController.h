//
//  Surrender_AnnouncViewController.h
//  AnimalAdopt02
//
//  Created by Enrf_macmini on 2016/10/21.
//  Copyright (c) 2016年 tcapo. All rights reserved.
//

#ifndef AnimalAdopt02_Surrender_AnnouncViewController_h
#define AnimalAdopt02_Surrender_AnnouncViewController_h


#endif




#import <UIKit/UIKit.h>

#import "MBProgressHUD.h"

@interface Surrender_AnnouncViewController : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *myWeb;



@property (weak, nonatomic) IBOutlet UIButton *goBack;



- (IBAction)goBack:(UIButton *)sender;

@end
