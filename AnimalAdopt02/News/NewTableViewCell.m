//
//  NewTableViewCell.m
//  TaiJiApp
//
//  Created by Casper on 15/3/17.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "NewTableViewCell.h"

@implementation NewTableViewCell

@synthesize image;
@synthesize title;
@synthesize date;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setImage:(UIImage *)img {
    if (![img isEqual:image]) {
        image = [img copy];
        self.news_img.image = image;
    }
}

-(void)setTitle:(NSString *)n {
    if (![n isEqualToString:title]) {
        title = [n copy];
        self.news_title.lineBreakMode = UILineBreakModeWordWrap;
        self.news_title.numberOfLines = 0;
        self.news_title.text = title;
    }
}

-(void)setDate:(NSString *)n {
    if (![n isEqualToString:date]) {
        date = [n copy];
        self.news_date.text = date;
    }
}



@end
