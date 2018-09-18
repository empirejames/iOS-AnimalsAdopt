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

@interface SearchViewController : UIViewController <UITextFieldDelegate>

//这里用assign而不用retain是为了防止引起循环引用。
@property(nonatomic,assign) NSObject<PassValueDelegate> *delegate;


@end
