//
//  NewTableViewCell.h
//  TaiJiApp
//
//  Created by Casper on 15/3/17.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartnerTableViewCell : UITableViewCell

@property (copy, nonatomic) UIImage *image;
@property (copy, nonatomic) NSString *title;


@property (strong, nonatomic) IBOutlet UIImageView *news_img;
@property (strong, nonatomic) IBOutlet UILabel *news_title;



@end
