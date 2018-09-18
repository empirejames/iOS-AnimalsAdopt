//
//  NewViewController.m
//  TaiJiApp
//
//  Created by Casper on 15/3/17.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "MemberBulletinListViewController.h"
#import "MemberBulletinTableViewCell.h"
#import "DetailViewController.h"

#import "MainViewController.h"
#import "Utility.h"
#import "UserPreferences.h"


@interface MemberBulletinListViewController (){
    NSMutableData *receivedData;
    NSURLConnection *connection;
    NSMutableArray *dataAry;
    NSMutableArray *images;
        NSString * content;
    
    IBOutlet UITableView *tableView;
    IBOutlet UILabel *bulletinTitle;
    UIAlertView *myAlertView;
    NSArray  *url_type,*title_type;
}

@end

@implementation MemberBulletinListViewController
@synthesize page_type;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

}

- (void)viewWillAppear:(BOOL)animated
{
    
    
    
    //By Richard 2017.3.14
    //Fixed 按下 會員中心\協尋公告,通報公告 後會當機的問題
    url_type = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%@Query/MissingList.ashx",NSLocalizedString(@"api_ip", @"")],
                [NSString stringWithFormat:@"%@Query/BulletinList.ashx",NSLocalizedString(@"api_ip", @"")], nil];
    
    title_type = [[NSArray alloc] initWithObjects:
                  @"我的協尋列表",
                  @"通報公告", nil];
    
    
    [bulletinTitle setText:[title_type objectAtIndex:page_type]];
    
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
    
    [aiView startAnimating];
    
    dataAry = [[NSMutableArray alloc] init];
    
    images = [[NSMutableArray alloc] init];
    
    [self connectHttp];

}


//http連線接收

-(void)connectHttp{
    
    if(receivedData==nil)
    {
        receivedData = [[NSMutableData alloc] init];
    }
    
    [receivedData setLength:0];

    
     NSString *urlApi =[NSString stringWithFormat:@"%@?member=%@",[url_type objectAtIndex:page_type],[UserPreferences getStringForKey:PREF_TOKEN]];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlApi]];
    
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
    
    [Utility alertWithTitle:@"訊息" message:@"連結失敗!! 請重新讀取!!"];

}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    
    for (NSDictionary *p in res) {
      
          NSArray  *tmpAry = [[NSArray alloc] initWithObjects:
                      [p objectForKey:@"id"], [p objectForKey:@"name"], [p objectForKey:@"pic"],nil];
        
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
        UINib *nib = [UINib nibWithNibName:@"MemberBulletinTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        nibsRegistered = YES;
    }
    
    
   // MemberBulletinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    
    MemberBulletinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if(cell == nil)
    {
        // 创建自定义的FKBookTableCell对象
        cell = [[MemberBulletinTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CustomCellIdentifier];
    }
   
    
        NSMutableArray *data_ary = [dataAry objectAtIndex:indexPath.row];
        
        cell.backgroundColor=[UIColor clearColor];
        cell.title = [data_ary objectAtIndex:1];
    
    
        NSString *img_url =[NSString stringWithFormat:@"%@/Upload/Pic/%@",NSLocalizedString(@"api_ip", @""), [data_ary objectAtIndex:2]];
    dispatch_queue_t queue = dispatch_queue_create("testQueue", NULL);
    //針對剛才製造的 Queue 執行進行非同步 Block
    dispatch_async(queue, ^(void) {
        //睡 0.5 秒
        [NSThread sleepForTimeInterval:0.5f];
        //之後，執行下載圖片
        UIImage *urlimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]]];
        
        if (urlimage) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //完成下載後要做的事 ...
                cell.asy_img.imageURL = [NSString stringWithFormat:img_url];
            });
        }else{
             cell.asy_img.image = [UIImage imageNamed:@"default_icon.jpg"];
        }
        
    });

    
   
    
    
  /*      dispatch_queue_t queue = dispatch_queue_create("testQueue", NULL);
        
        //針對剛才製造的 Queue 執行進行非同步 Block
        dispatch_async(queue, ^(void) {
            //睡 0.5 秒
            [NSThread sleepForTimeInterval:0.5f];
            //之後，執行下載圖片
            UIImage *urlimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]]];
            //NSURL *urlString = [NSURL URLWithString:img_url];
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                //完成下載後要做的事 ...
                
                cell.image = urlimage;
                NSError *error = nil;
                NSData *data = [NSData dataWithContentsOfURL:urlString options:NSDataReadingUncached error:&error];
                if (!error) {
                    
                    cell.image = [UIImage imageWithData:data];
                } else {
                    cell.image = [UIImage imageNamed:@"default_icon.jpg"];
                    
                }
            });
            
        });*/
    
    
    return cell;
    
}

//cell寬度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 91;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      NSMutableArray *get_ary = [dataAry objectAtIndex:indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];

    if (page_type==0) {
        [detailVC setPage_type:4];
    }else{
        [detailVC setPage_type:5];
    }
    
    [detailVC setDetail_id:[get_ary objectAtIndex:0]];
    [detailVC setDetail_tid:@""];
    
    UINavigationController *detailNC = [[UINavigationController alloc] initWithRootViewController:detailVC];
    
    
    [detailNC.navigationBar setHidden:TRUE];
    
    [self presentViewController:detailNC animated:NO completion:nil];

}

- (IBAction)backbtn:(id)sender;
{
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
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
