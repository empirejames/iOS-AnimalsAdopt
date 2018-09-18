//
//  NewViewController.h
//  TaiJiApp
//
//  Created by Casper on 15/3/17.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface NewViewController : UIViewController<NSXMLParserDelegate,UITableViewDataSource, UITableViewDelegate,UIWebViewDelegate>{
}


@property (weak, nonatomic) IBOutlet UIWebView *myWeb;

@property (weak, nonatomic) IBOutlet UIButton *goBack;

- (IBAction)goBack:(UIButton *)sender;

@end
