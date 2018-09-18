//
//  MainViewController.h
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagedFlowView.h"

@interface MainViewController : UIViewController<PagedFlowViewDelegate,PagedFlowViewDataSource>{
    NSArray *imageArray;
}

@property (nonatomic, strong) IBOutlet PagedFlowView *hFlowView;
@property (nonatomic, strong) IBOutlet PagedFlowView *vFlowView;
@property (nonatomic, strong) IBOutlet UIPageControl *hPageControl;

- (IBAction)pageControlValueDidChange:(id)sender;

@end
