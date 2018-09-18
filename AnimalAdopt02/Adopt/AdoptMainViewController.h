//
//  FindMainViewController.h
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PassValueDelegate.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "UITableGridViewCell.h"
#import "GridImageButton.h"
#import "Utility.h"
#import "DetailViewController.h"
#import "SearchEntity.h"
#import "SearchViewController.h"
#import "AdoptMainViewCell.h"
#import "AFNetworking.h"

@interface AdoptMainViewController: UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, NSURLConnectionDelegate, NSURLConnectionDataDelegate, PassValueDelegate> {
    IBOutlet UILabel *title_label;
    IBOutlet UIView *footerView;
    IBOutlet UIButton *HomeBtnView;
    IBOutlet UIButton *NavBtnView;
    NSMutableData *mtData;
    NSURLConnection *urlConnect;
    NSMutableArray *mtaDataInfo;
    UIAlertView *myAlertView;
    NSString *str_type, *str_sex, *str_area, *str_age, *str_size, *str_hair, *str_name, *str_acceptnum;
    NSArray *aryUrl, *aryPhoto, *aryTitle;
    NSUInteger currentIndex;
}

@property(assign, nonatomic) NSInteger pageType;
@property(strong, nonatomic) IBOutlet UICollectionView *cv;

- (IBAction)btnSearch:(UIButton *)sender;

@end
