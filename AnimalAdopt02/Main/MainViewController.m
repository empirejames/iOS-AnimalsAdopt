//
//  MainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+JDSideMenu.h"
#import "JDMenuViewController.h"
#import "JDMenuTableViewCell.h"
#import "FindMainViewController.h"
#import "MemberMainViewController.h"
#import "MemberCenterViewController.h"
#import "NewViewController.h"
#import "AdoptMainViewController.h"
#import "VideoMainViewController.h"
#import "AboutMainViewController.h"
#import "ReportMainViewController.h"
#import "UserPreferences.h"
#import "PartnerViewController.h"

//By Richard 2016.11.10
#import "Shelter_RescueViewController.h"
#import "Surrender_AnnouncViewController.h"
#import "Happy_transfer_stationViewController.h"
#import "Beacon_NavigateViewController.h"
#import "Pet_registration_inventoryViewController.h"
#import "Animal_VideoViewController.h"
#import "Pet_HealthViewController.h"

@interface MainViewController (){
    
    NSMutableData *receivedData;
    
    NSURLConnection *type_connection[9];
    
    NSArray *typeArray;
    
    NSInteger typeCount;
    
    NSMutableArray *selnameAry;
    
    NSMutableArray *selIdAry;
    
    NSMutableArray *reportNameAry;
    
    NSMutableArray *reportIdAry;
    
    NSArray *stageNameAry;
    
    IBOutlet UILabel *stageName;
    
}

@end

@implementation MainViewController
@synthesize hFlowView;
@synthesize vFlowView;
@synthesize hPageControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    typeArray = [[NSArray alloc] initWithObjects:@"type",@"sex",@"hair",@"age",@"size",@"area",@"breed",@"quot",nil];
    
    /* By Richard 2016.11.10
    stageNameAry = [[NSArray alloc] initWithObjects:
                    @"動物認養",
                    @"動物影音",
                    @"失蹤協尋",
                    @"動保報案",
                    @"最新消息",
                    @"會員中心",
                    @"意見回饋",
                    @"關於我們",
                    @"合作夥伴",nil];
    
    imageArray = [[NSArray alloc] initWithObjects:
                  @"list_icon5.png",
                  @"list_icon4.png",
                  @"list_icon1.png",
                  @"list_icon8.png",
                  @"list_icon2.png",
                  @"list_icon3.png",
                  @"list_icon7.png",
                  @"list_icon6.png",
                  @"list_icon9.png",nil];*/
    
    
    /* By Richard 2018.6.26
    stageNameAry = [[NSArray alloc] initWithObjects:
                    @"動物認養",
                    @"動物影音",
                    @"失蹤協尋",
                    @"動保報案",
                    @"動物急救",
                    @"收容救援",
                    @"不擬續養公告",
                    @"幸福轉運站",
                    @"動物之家導覽",
                    @"最新消息",
                    @"會員中心",
                    @"意見回饋",
                    @"關於我們",
                    @"合作夥伴",
                    @"臺北市寵物登記管理與清查系統",nil];
     
     imageArray = [[NSArray alloc] initWithObjects:
     @"list_icon5.png",
     @"list_icon4.png",
     @"list_icon1.png",
     @"list_icon8.png",
     @"a_icon6.png",
     @"a_icon.png",
     @"a_icon2.png",
     @"a_icon3.png",
     @"a_icon5.png",
     @"list_icon2.png",
     @"list_icon3.png",
     @"list_icon7.png",
     @"list_icon6.png",
     @"list_icon9.png",
     @"a_icon4.png",nil] ;
     
     */
    
    
    stageNameAry = [[NSArray alloc] initWithObjects:
                    @"動物認養",
                    @"動物影音",
                    @"失蹤協尋",
                    @"動保報案",
                    @"動物急救",
                    @"收容救援",
                    @"動物之家導覽",
                    @"最新消息",
                    @"會員中心",
                    @"意見回饋",
                    @"關於我們",
                    @"合作夥伴",
                    @"臺北市寵物登記管理與清查系統",nil];
    
    imageArray = [[NSArray alloc] initWithObjects:
                  @"list_icon5.png",
                  @"list_icon4.png",
                  @"list_icon1.png",
                  @"list_icon8.png",
                  @"a_icon6.png",
                  @"a_icon.png",
                  @"a_icon5.png",
                  @"list_icon2.png",
                  @"list_icon3.png",
                  @"list_icon7.png",
                  @"list_icon6.png",
                  @"list_icon9.png",
                  @"a_icon4.png",nil] ;

    
    hFlowView.delegate = self;
    
    hFlowView.dataSource = self;
    
    hFlowView.pageControl = hPageControl;
    
    hFlowView.minimumPageAlpha = 0.2;
    
    hFlowView.minimumPageScale = 0.2;
    
    typeCount = 0;
    
    selnameAry  = [[NSMutableArray alloc] init];
    
    selIdAry  = [[NSMutableArray alloc] init];
    
    reportNameAry = [[NSMutableArray alloc] init];
    
    reportIdAry = [[NSMutableArray alloc] init];
    
    [self connectHttp];
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(PagedFlowView *)flowView;
{
    
    [hFlowView scrollToPage:2];
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        return CGSizeMake(120, 160);
    }
    else
    {
        return CGSizeMake(220, 280);
    }
}

- (void)flowView:(PagedFlowView *)flowView didScrollToPageAtIndex:(NSInteger)index
{
    NSLog(@"Scrolled to page # %d", index);
    
    if(index>=0){
        
    [stageName setText:[stageNameAry objectAtIndex:index]];
        
    }
}



- (void)flowView:(PagedFlowView *)flowView didTapPageAtIndex:(NSInteger)index
{
    NSLog(@"Tapped on page # %d", index);

    FindMainViewController *findVC = nil;
    
    NewViewController *newVC = nil;
    
    MemberMainViewController *memberMainVC = nil;
    
    MemberCenterViewController *memberCenterVC = nil;
    
    AdoptMainViewController *adoptVC = nil;
    
    AdoptMainViewController *videoVC = nil;
    
    AboutMainViewController *aboutVC = nil;
    
    ReportMainViewController *reportVC = nil;
    
    VideoMainViewController *plaVC = nil;
    
    PartnerViewController *partnerVC = nil;
    
    UINavigationController *contentNavigationController =nil;
    
    NSString *showtoken;
    
    // By Richard 2016.10.21
    
    Shelter_RescueViewController *Shelter_RescueVC = nil;
    
    // By Richard 2018.6.26
    //Surrender_AnnouncViewController *Surrender_AnnouncVC = nil;
    
    //Happy_transfer_stationViewController *Happy_transfer_stationVC = nil;
    
    Beacon_NavigateViewController *Beacon_NavigateVC = nil;
    
    Pet_registration_inventoryViewController *Pet_registration_inventoryVC = nil;
    
    Animal_VideoViewController *Animal_VideoVC = nil;
    
    Pet_HealthViewController *Pet_HealthVC = nil;
    
    
    switch(index) {
        case 0:
            
            adoptVC = [[AdoptMainViewController alloc] initWithNibName:@"AdoptMainViewController" bundle:nil];
            [adoptVC setPageType: 2];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:adoptVC];
            
            break;
        case 1: //SecondString
            
            Animal_VideoVC = [[Animal_VideoViewController alloc] initWithNibName:@"Animal_VideoViewController" bundle:nil];
            
            //[videoVC setPage_type:3];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:Animal_VideoVC];
           
            break;
        case 2: //SecondString
            
            findVC = [[FindMainViewController alloc] initWithNibName:@"FindMainViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:findVC];
            
           
            break;
        case 3: //
           
            reportVC = [[ReportMainViewController alloc] initWithNibName:@"ReportMainViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:reportVC];
            
            break;
            
        case 4: //
            
            Pet_HealthVC = [[Pet_HealthViewController alloc]
                                initWithNibName:@"Pet_HealthViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:Pet_HealthVC];
            
            break;
            
        case 5: //
            
            Shelter_RescueVC = [[Shelter_RescueViewController alloc]
                                initWithNibName:@"Shelter_RescueViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:Shelter_RescueVC];
            
            break;
            
        /* By Richard 2018.6.26
        case 6: //
            
            Surrender_AnnouncVC = [[Surrender_AnnouncViewController alloc]
                                initWithNibName:@"Surrender_AnnouncViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:Surrender_AnnouncVC];
            
            break;
            
        case 7: //
            
            Happy_transfer_stationVC = [[Happy_transfer_stationViewController alloc]
                                initWithNibName:@"Happy_transfer_stationViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:Happy_transfer_stationVC];
            
            break;*/
            
        case 6: //
            
            Beacon_NavigateVC = [[Beacon_NavigateViewController alloc]
                                initWithNibName:@"Beacon_NavigateViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:Beacon_NavigateVC];
            
            break;
            
        case 7: //
            newVC = [[NewViewController alloc] initWithNibName:@"NewViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:newVC];
            
            break;
            
        case 8: //SecondString
            showtoken = [UserPreferences getStringForKey:PREF_TOKEN];
            
            if(showtoken==nil || [showtoken isEqualToString:@""])
            {
                memberMainVC = [[MemberMainViewController alloc] initWithNibName:@"MemberMainViewController" bundle:nil];
                
                contentNavigationController = [[UINavigationController alloc] initWithRootViewController:memberMainVC];
                
            }else{
                
                memberCenterVC = [[MemberCenterViewController alloc] initWithNibName:@"MemberCenterViewController" bundle:nil];
                
                contentNavigationController = [[UINavigationController alloc] initWithRootViewController:memberCenterVC];
            }
            break;
        case 9: //SecondString
            
            //  if ([[UIApplication sharedApplication] canOpenURL:
            //   [NSURL URLWithString:@"gplus://"]]) {
            
            //  } else {
            
            //By Richard 2017.8.16
            /*
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/tw/app/tai-bei-shi-zheng-xin-xiang/id445385808?l=zh&mt=8"]];
             
             
             
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://hello.gov.taipei/Front/main"] options:@{} completionHandler:nil];
             
             */
            
            
            //By Richard 2017.08.16
            //Open Web Browser , nagative to hello.gov.taipei
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://hello.gov.taipei/Front/main"]];
            
            
            //   }
            break;
            
        case 10: //SecondString
            
            aboutVC = [[AboutMainViewController alloc] initWithNibName:@"AboutMainViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:aboutVC];
            
            break;
        case 11: //SecondString
           
            partnerVC = [[PartnerViewController alloc] initWithNibName:@"PartnerViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:partnerVC];
            
            break;
        case 12: //SecondString
            
            Pet_registration_inventoryVC = [[Pet_registration_inventoryViewController alloc] initWithNibName:@"Pet_registration_inventoryViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:Pet_registration_inventoryVC];
            
            break;
            
            
        default: //Not found
            break;
            
    }
    
    
    [contentNavigationController.navigationBar setHidden: YES];
    JDSideMenu *sideMenu = [[JDSideMenu alloc] initWithContentController: contentNavigationController menuController: [[JDMenuViewController alloc] init]];
    [self presentViewController: sideMenu animated: NO completion: nil];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(PagedFlowView *)flowView{
    
    return [imageArray count];
    
}

//返回给某列使用的View
- (UIView *)flowView:(PagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index
{
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    
    if (!imageView) {
        
        imageView = [[UIImageView alloc] init];
        
        imageView.layer.cornerRadius = 6;
        
        imageView.layer.masksToBounds = YES;
    }
    
    imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:index]];
    
    return imageView;
}



//http連線接收

-(void)connectHttp{
    
    if(receivedData==nil)
    {
        receivedData = [[NSMutableData alloc] init];
    }
    
    [receivedData setLength:0];
    
    
    NSString *urlApi = @"";
    
    if (typeCount<8) {
        
    urlApi =[NSString stringWithFormat:@"%@Query/QueryPara.ashx?q=%@",NSLocalizedString(@"api_ip", @""),[typeArray objectAtIndex:typeCount]];
        
    }else{
        
     urlApi = [NSString stringWithFormat:@"%@Query/QueryReportType.ashx",
               NSLocalizedString(@"api_ip", @"")];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlApi]];
    type_connection[typeCount] = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if(!type_connection[typeCount])
    {
        receivedData = nil;
    }
    
    
}

- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)data
{
    [receivedData appendData:data];
}

//Tea update
- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError");
    //   NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
   
        type_connection[typeCount] = nil;
    
    receivedData = nil;
    
    // [defaults setObject:@"0" forKey:@"first_login"];
    //[defaults synchronize];
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"網路訊息"
                              message:@"您的網路尚未開啟，請開啟您的網路!!"
                              delegate:self
                              cancelButtonTitle:@"確定"
                              otherButtonTitles:nil
                              ];
    
    [alertView show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connect
{
    
    // convert to JSON
    NSError *myError = nil;
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    
  
    
    if (connect == type_connection[typeCount]) {
        
    
        if (typeCount<8) {
            
            NSMutableArray *tmpNameAry = [[NSMutableArray alloc] init];
            
            //  NSMutableArray *tmpIdAry = [[NSMutableArray alloc] init];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            for (NSDictionary *p in res) {
                
                [tmpNameAry addObject:[p objectForKey:@"name"]];
                
                
                [dict setObject:[p objectForKey:@"id"] forKey:[p objectForKey:@"name"]];
                
                /* NSArray  *tmpAry = [[NSArray alloc] initWithObjects:
                 [p objectForKey:@"id"], [p objectForKey:@"name"],nil];*/
                //NSLog(@"count-->%@",[p objectForKey:@"name"]);
                
            }
            
            
            [selnameAry addObject:tmpNameAry];
            [selIdAry addObject:dict];
            
            typeCount++;
            [self connectHttp];
            
        }else{
            
          /*  r =>違法事實(json object Array)
         	a =>動物種類(json object Array)
            b =>動物品種(json object Array)
            h=>動物毛色(json object Array)
            p=>行政區(json object Array)
            s=>動物性別(json object Array)*/
            
            NSArray *reportlist[8];
            
            reportlist[0] = [res objectForKey:@"r"];
            reportlist[1] = [res objectForKey:@"a"];
            reportlist[2] = [res objectForKey:@"b"];
            reportlist[3] = [res objectForKey:@"h"];
            reportlist[4] = [res objectForKey:@"p"];
            reportlist[5] = [res objectForKey:@"s"];
            reportlist[6] = [res objectForKey:@"z"];
            reportlist[7] = [res objectForKey:@"ss"];
            
            
           
            for (int i=0; i<8; i++) {
                
                NSMutableArray *tmpNameAry = [[NSMutableArray alloc] init];
                
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
                
                for (NSDictionary *p in reportlist[i]) {
                
                    [tmpNameAry addObject:[p objectForKey:@"name"]];
                
                
                    [dict setObject:[p objectForKey:@"id"] forKey:[p objectForKey:@"name"]];

                }
                
                [reportNameAry addObject:tmpNameAry];
                
                [reportIdAry addObject:dict];
            }

            [UserPreferences setArray:selnameAry forKey:@"SelNameSet"];
            
            [UserPreferences setArray:selIdAry forKey:@"SelIdSet"];
            
            [UserPreferences setArray:reportNameAry forKey:@"ReportNameSet"];
            
            [UserPreferences setArray:reportIdAry forKey:@"ReportIdSet"];
            
        }
        
      
    }
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
