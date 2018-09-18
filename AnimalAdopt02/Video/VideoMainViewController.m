//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "VideoMainViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"

@interface VideoMainViewController (){
 UIScrollView *scrollView;
    // UITableView *adoptTableView;
   IBOutlet UIWebView *youTubeWebView;
    
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImage *image;
@end

@implementation VideoMainViewController
@synthesize youtube_id;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
     youTubeWebView.delegate = self;
    
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
        background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <iframe width=\"%0.0f\" height=\"%0.0f\" src=\"%@?rel=0\" frameborder=\"0\" allowfullscreen></iframe> \
    </body></html>";
    
    NSString *str_youtube =[NSString stringWithFormat:@"http://www.youtube.com/embed/%@", youtube_id];
    CGSize mSize = [[UIScreen mainScreen] bounds].size;
    NSString* html = [NSString stringWithFormat:embedHTML, mSize.width, (mSize.height-70)/2, str_youtube];
    
   // [youTubeWebView setFrame:CGRectMake(youTubeWebView.frame.size.width, youTubeWebView.frame.origin.y, mSize.width, mSize.height-340)];
    
    [youTubeWebView loadHTMLString:html baseURL:nil];
   
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == (UIDeviceOrientationLandscapeLeft) );
}


- (IBAction)btnBack:(id)sender;
{
   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
