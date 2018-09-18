//
//  JDMenuViewController.m
//  JDSideMenu
//
//  Created by Markus Emrich on 11.11.13.
//  Copyright (c) 2013 Markus Emrich. All rights reserved.
//

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
#import "PartnerViewController.h"
#import "UserPreferences.h"

//By Richard 2016.11.10
#import "Shelter_RescueViewController.h"
#import "Surrender_AnnouncViewController.h"
#import "Happy_transfer_stationViewController.h"
#import "Beacon_NavigateViewController.h"
#import "Pet_registration_inventoryViewController.h"
#import "Animal_VideoViewController.h"
#import "Pet_HealthViewController.h"


@interface JDMenuViewController (){
    IBOutlet UITableView *tableView;
    NSMutableArray *title_Ary ;
    NSMutableArray *img_Ary;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)switchController:(id)sender;
@end

@implementation JDMenuViewController

- (void)viewDidLayoutSubviews;
{
    [super viewDidLayoutSubviews];
    self.scrollView.contentSize = CGRectInset(self.scrollView.bounds, 0, -1).size;
}
- (void)viewWillAppear:(BOOL)animated
{
    /* By Richard 2016.10.21
     title_Ary= [[NSMutableArray alloc]initWithObjects: @"動物認養",@"動物影音",@"失蹤協尋",@"動保報案",@"最新消息",@"會員中心",@"意見回饋", @"關於我們",@"合作夥伴",nil];*/
    
    /* By Richard 2018.6.26
    title_Ary= [[NSMutableArray alloc]initWithObjects:
                @"動物認養",@"動物影音",@"失蹤協尋",@"動保報案",@"動物急救",@"收容救援",@"不擬續養公告",@"幸福轉運站",@"動物之家導覽",@"最新消息",@"會員中心",@"意見回饋", @"關於我們",@"合作夥伴",@"臺北市寵物登記管理與清查系統",nil];*/
    
    title_Ary= [[NSMutableArray alloc]initWithObjects:
                @"動物認養",@"動物影音",@"失蹤協尋",@"動保報案",@"動物急救",@"收容救援",@"動物之家導覽",@"最新消息",@"會員中心",@"意見回饋", @"關於我們",@"合作夥伴",@"臺北市寵物登記管理與清查系統",nil];
    
    /* By Richard 2016.10.21
     img_Ary = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"list_icon5.png"],
     [UIImage imageNamed:@"list_icon4.png"],
     [UIImage imageNamed:@"list_icon1.png"],
     [UIImage imageNamed:@"list_icon8.png"],
     [UIImage imageNamed:@"list_icon2.png"],
     [UIImage imageNamed:@"list_icon3.png"],[UIImage imageNamed:@"list_icon7.png"],
     [UIImage imageNamed:@"list_icon6.png"],
     [UIImage imageNamed:@"list_icon9.png"],
     nil];*/
    
    
    /* By Richard 2018.6.26
    img_Ary = [[NSMutableArray alloc]initWithObjects:
               [UIImage imageNamed:@"list_icon5.png"],
               [UIImage imageNamed:@"list_icon4.png"],
               [UIImage imageNamed:@"list_icon1.png"],
               [UIImage imageNamed:@"list_icon8.png"],
               [UIImage imageNamed:@"a_icon6.png"],
               [UIImage imageNamed:@"a_icon.png"],
               [UIImage imageNamed:@"a_icon2.png"],
               [UIImage imageNamed:@"a_icon3.png"],
               [UIImage imageNamed:@"a_icon5.png"],
               [UIImage imageNamed:@"list_icon2.png"],
               [UIImage imageNamed:@"list_icon3.png"],
               [UIImage imageNamed:@"list_icon7.png"],
               [UIImage imageNamed:@"list_icon6.png"],
               [UIImage imageNamed:@"list_icon9.png"],
               [UIImage imageNamed:@"a_icon4.png"],
               nil];*/
    
    img_Ary = [[NSMutableArray alloc]initWithObjects:
               [UIImage imageNamed:@"list_icon5.png"],
               [UIImage imageNamed:@"list_icon4.png"],
               [UIImage imageNamed:@"list_icon1.png"],
               [UIImage imageNamed:@"list_icon8.png"],
               [UIImage imageNamed:@"a_icon6.png"],
               [UIImage imageNamed:@"a_icon.png"],
               [UIImage imageNamed:@"a_icon5.png"],
               [UIImage imageNamed:@"list_icon2.png"],
               [UIImage imageNamed:@"list_icon3.png"],
               [UIImage imageNamed:@"list_icon7.png"],
               [UIImage imageNamed:@"list_icon6.png"],
               [UIImage imageNamed:@"list_icon9.png"],
               [UIImage imageNamed:@"a_icon4.png"],
               nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    nibsRegistered = NO;
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
    return [title_Ary count];
}

static BOOL nibsRegistered = NO;
- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CustomCellIdentifier = @"CellIdentifier";
    
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"JDMenuTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CustomCellIdentifier];
        nibsRegistered = YES;
    }
    
    
    JDMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    
    cell.title = [title_Ary objectAtIndex:indexPath.row];
    
    
  
    cell.image = [img_Ary objectAtIndex:indexPath.row];
  
    
    //NSLog(@"description = %@",[cell description]);
    
    return cell;
}

//cell寬度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIViewController *menuController = [[JDMenuViewController alloc] init];
    FindMainViewController *findVC = nil;
    NewViewController *newVC = nil;
    MemberMainViewController *memberMainVC = nil;
    MemberCenterViewController *memberCenterVC = nil;
    AdoptMainViewController *adoptVC = nil;
    AdoptMainViewController *videoVC = nil;
    AboutMainViewController *aboutVC = nil;
    ReportMainViewController *reportVC = nil;
    VideoMainViewController*plaVC = nil;
    PartnerViewController *partnerVC = nil;
    UINavigationController *contentNavigationController =nil;
    NSString *showtoken;
    
    //By Richard 2016.10.21
    Shelter_RescueViewController *Shelter_RescueVC = nil;
    
    //By Richard 2018.6.26
    //Surrender_AnnouncViewController *Surrender_AnnouncVC = nil;
    //Happy_transfer_stationViewController *Happy_transfer_stationVC = nil;
    
    Beacon_NavigateViewController *Beacon_NavigateVC = nil;
    Pet_registration_inventoryViewController *Pet_registration_inventoryVC = nil;
    Animal_VideoViewController *Animal_VideoVC = nil;
    Pet_HealthViewController *Pet_HealthVC = nil;
    
    
    switch(indexPath.row) {
            
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
            
            Pet_HealthVC = [[Pet_HealthViewController alloc] initWithNibName:@"Pet_HealthViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:Pet_HealthVC];
            
            break;
            
        case 5: //
            
            Shelter_RescueVC = [[Shelter_RescueViewController alloc] initWithNibName:@"Shelter_RescueViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:Shelter_RescueVC];
           
            break;
        
        /* By Richard 2018.6.26
        case 6: //
            Surrender_AnnouncVC = [[Surrender_AnnouncViewController alloc] initWithNibName:@"Surrender_AnnouncViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:Surrender_AnnouncVC];
            
            break;
            
        case 7: //
            Happy_transfer_stationVC = [[Happy_transfer_stationViewController alloc] initWithNibName:@"Happy_transfer_stationViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:Happy_transfer_stationVC];
            
            break;*/
            
        case 6: //
            
            Beacon_NavigateVC = [[Beacon_NavigateViewController alloc] initWithNibName:@"Beacon_NavigateViewController" bundle:nil];
            
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
            
            /*
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/tw/app/dai-yong-tian-shi/id732805829?mt=8"]];
            */
            
            
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
            
        case 12: //
            
            Pet_registration_inventoryVC = [[Pet_registration_inventoryViewController alloc] initWithNibName:@"Pet_registration_inventoryViewController" bundle:nil];
            
            contentNavigationController = [[UINavigationController alloc] initWithRootViewController:Pet_registration_inventoryVC];
            
            break;
            
        default: //Not found
            break;
            
    }
    
    
    [contentNavigationController.navigationBar setHidden:TRUE];
    UIViewController *navController = contentNavigationController;
    JDSideMenu *sideMenu = [[JDSideMenu alloc] initWithContentController:navController
                                                          menuController:menuController];
    // sideMenu.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:sideMenu animated:NO completion:nil];
}




@end
