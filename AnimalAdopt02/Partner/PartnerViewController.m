//
//  NewViewController.m
//  TaiJiApp
//
//  Created by Casper on 15/3/17.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "PartnerViewController.h"
#import "PartnerTableViewCell.h"
#import "PartnerDetailViewController.h"

#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "Utility.h"
@interface PartnerViewController (){
    NSMutableData *receivedData;
    NSURLConnection *connection;
    NSMutableArray *dataAry;

    NSString *tagName;
     NSString * flagName;
    
     NSString * content;
    
    IBOutlet UITableView *tableView;
    IBOutlet UILabel *newsTitle;
    UIAlertView *myAlertView;
    
}

@end

@implementation PartnerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    //[newsTitle setText:NSLocalizedString(@"main_news", @"")];
    
    
    //By Richard 2016.11.25
    /*
    myAlertView =  [[UIAlertView alloc] initWithTitle:@"Loading..." message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil ];
    
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125.0, 70.0, 30.0, 30.0)];
    
    aiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    
    //check if os version is 7 or above. ios7.0及以上UIAlertView弃用了addSubview方法
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
        
        [myAlertView setValue:aiView forKey:@"accessoryView"];
        
    }else{
        
        [myAlertView addSubview:aiView];
    }
    
    [myAlertView show];
    
    [aiView startAnimating];*/
    
    dataAry = [[NSMutableArray alloc] init];
    
    [self connectHttp];
    

}


//http連線接收

-(void)connectHttp
 {
    if(receivedData==nil)
    {
        receivedData = [[NSMutableData alloc] init];
    }
    
    [receivedData setLength:0];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Query/AppPartnerList.ashx",NSLocalizedString(@"api_ip", @"")]]];
    
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!connection)
    {
        receivedData = nil;
    }
    
}

- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

//Tea update
- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    //   NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
    connection = nil;
    receivedData = nil;
    
    //By Richard 2016.11.27
    //[Utility alertWithTitle:@"訊息" message:@"連結失敗!! 請重新讀取!!"];
    [Utility alertWithDialog:@"訊息" message:@"連結失敗!! 請開啟網路連線!!"];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    
    for (NSDictionary *p in res) {
        
        NSArray  *tmpAry = [[NSArray alloc] initWithObjects:
                            [p objectForKey:@"id"], [p objectForKey:@"title"], [p objectForKey:@"pic"],nil];
        
        [dataAry addObject:tmpAry];
    }
    
    [tableView reloadData];
    
    [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [list count];    //983單字
    
    
    // NSLog(@"entries --> %d",entries.count);
    return [dataAry count];
}

static BOOL nibsRegistered = NO;
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CustomCellIdentifier = @"CellIdentifier";

    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"NewTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        nibsRegistered = YES;
    }
    
    
    PartnerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
   
    NSMutableArray *data_ary = [dataAry objectAtIndex:indexPath.row];
    
    cell.backgroundColor=[UIColor clearColor];
    cell.title = [data_ary objectAtIndex:1];
    //cell.date = [data_ary objectAtIndex:3];

   
    
    NSString *img_url =[NSString stringWithFormat:@"%@Upload/Pic/%@",NSLocalizedString(@"api_ip", @""), [data_ary objectAtIndex:2]];
   // cell.image = [UIImage imageNamed:@"partner1.png"];;
    
    dispatch_queue_t queue = dispatch_queue_create("testQueue", NULL);
    
    //針對剛才製造的 Queue 執行進行非同步 Block
    dispatch_async(queue, ^(void) {
        //睡 0.5 秒
        [NSThread sleepForTimeInterval:0.5f];
        //之後，執行下載圖片
        UIImage *urlimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]]];
    
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            //完成下載後要做的事 ...
           cell.image = urlimage;
        });
        
    });

    
    return cell;
}

//cell寬度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *data_ary = [dataAry objectAtIndex:indexPath.row];
     
    PartnerDetailViewController *newsVC = [[PartnerDetailViewController alloc]initWithNibName:@"PartnerDetailViewController" bundle:nil];
    
   
     [newsVC setIndexId:[data_ary objectAtIndex:0]];
    
    UINavigationController *newVCNavigationController = [[UINavigationController alloc] initWithRootViewController:newsVC];
    
    
    
    [newVCNavigationController.navigationBar setHidden:TRUE];
    
    [self presentViewController:newVCNavigationController animated:NO completion:nil];

}

- (IBAction)back:(id)sender
{
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController *mainVCNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    
    
    [mainVCNavigationController.navigationBar setHidden:TRUE];
    
    [self presentViewController:mainVCNavigationController animated:NO completion:nil];
  //  [self.navigationController dismissViewControllerAnimated:NO completion:nil];
 }

- (IBAction)open:(id)sender;
{
    if (![self.jdsideMenuController isMenuVisible]) {
        [self.jdsideMenuController showMenuAnimated:YES ];
    }else{
        [self.jdsideMenuController hideMenuAnimated:YES];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    
    nibsRegistered = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
