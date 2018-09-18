//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "DetailViewController.h"
#import "MainViewController.h"
#import "MemberUploadViewController.h"
#import "VideoMainViewController.h"
#import "Utility.h"
#import <Social/Social.h>
#import <GooglePlus/GooglePlus.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <MessageUI/MessageUI.h>
#import "UserPreferences.h"

@interface DetailViewController()<GPPSignInDelegate,MFMailComposeViewControllerDelegate>{
    
    IBOutlet UIScrollView *data_scrollView;
    IBOutlet UIScrollView *img_scrollView;
    IBOutlet UIScrollView *detail_scrollView;
    
    // UITableView *adoptTableView;
    NSMutableData *receivedData;
    NSURLConnection *connection;
    NSMutableArray *entries;
    NSMutableArray *dataAry;
    int dataCount;
    
    
    NSArray  *url_type,*photourl_type,*title_type;
    
    IBOutlet UILabel *contentTxt;
    IBOutlet UILabel *title_label;
    IBOutlet UIButton *rightBtnView;
    IBOutlet UIButton *mapBtnView;
    IBOutlet UIButton *telBtnView;
    IBOutlet UIButton *youtubeBtnView;
    
    NSTimer *_timer;
    BOOL isAdd;
    int page_point ;
    int imgflag;
    NSMutableArray *advsList;
    
    CGFloat screenWidth,screenHeight;
    UIAlertView *myAlertView;
    NSString *str_tel,*str_youtube,*str_location,*str_name,*str_email,*str_gps;
    NSString *pic_one,*send_text;
    UIImageView *imgvDefault;
    
    SLComposeViewController *sl_controller;
    
    int connectFlag;
    
}
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIImage *image;
@end

@implementation DetailViewController

@synthesize page_type;
@synthesize detail_tid;
@synthesize detail_id;
@synthesize imgDefault;

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
    imgvDefault = [[UIImageView alloc] initWithImage: imgDefault];
    [imgvDefault setContentMode: UIViewContentModeScaleAspectFit];
    [imgvDefault setFrame: img_scrollView.bounds];
    [img_scrollView addSubview: imgvDefault];
     */
    
    // Do any additional setup after loading the view from its nib.
    
    self.loggedInUser = nil;
    CGSize mSize = [[UIScreen mainScreen] bounds].size;
    screenWidth = mSize.width;
    screenHeight = mSize.height;
    page_point = 0;
    str_gps=@"";
    
    myAlertView =  [[UIAlertView alloc] initWithTitle:@"Loading..." message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil ];
    UIActivityIndicatorView *aiView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125.0, 30.0, 30.0, 30.0)];
    aiView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    //check if os version is 7 or above. ios7.0及以上UIAlertView弃用了addSubview方法
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending) {
        [myAlertView setValue:aiView forKey:@"accessoryView"];
    }else{
        [myAlertView addSubview:aiView];
    }
    [myAlertView show];
    [aiView startAnimating];
    
    url_type = [[NSArray alloc] initWithObjects:
                [NSString stringWithFormat:@"%@Query/MissingItem.ashx",NSLocalizedString(@"api_ip", @"")],
                [NSString stringWithFormat:@"%@Query/BulletinItem.ashx",NSLocalizedString(@"api_ip", @"")],
                [NSString stringWithFormat:@"%@Query/AcceptItem.ashx",NSLocalizedString(@"api_ip", @"")],
                 [NSString stringWithFormat:@"%@Query/AcceptItem.ashx",NSLocalizedString(@"api_ip", @"")],
                [NSString stringWithFormat:@"%@Query/MissingItem.ashx",NSLocalizedString(@"api_ip", @"")],
                 [NSString stringWithFormat:@"%@Query/BulletinItem.ashx",NSLocalizedString(@"api_ip", @"")],nil];
    photourl_type = [[NSArray alloc] initWithObjects:
                     [NSString stringWithFormat:@"%@Upload/Pic",NSLocalizedString(@"api_ip", @"")],
                     [NSString stringWithFormat:@"%@Upload/Pic",NSLocalizedString(@"api_ip", @"")],
                     @"http://163.29.39.183/amlnew/upload/pic",
                     @"http://163.29.39.183/amlnew/upload/pic/",
                     [NSString stringWithFormat:@"%@Upload/Pic",NSLocalizedString(@"api_ip", @"")],
                     [NSString stringWithFormat:@"%@Upload/Pic",NSLocalizedString(@"api_ip", @"")],nil];
    
    
    
    title_type = [[NSArray alloc] initWithObjects:
                  @"寵物失蹤協尋",
                  @"線上通報明細",
                  @"動物認養",
                  @"動物影音",
                  @"寵物失蹤協尋",
                  @"寵物通報明細",nil];
    
    if(page_type==0){
        
        //By Richard 2018.6.27
        [rightBtnView setBackgroundImage:[UIImage imageNamed:@"detail_bulletin_icon.jpg"] forState:UIControlStateNormal];
        
        
    }else  if(page_type==1){
        
        //By Richard 2018.6.27
        [rightBtnView setHidden:YES];
        
        
        [mapBtnView setFrame:CGRectMake(mapBtnView.frame.size.width/2, mapBtnView.frame.origin.y, mapBtnView.frame.size.width, mapBtnView.frame.size.height)];
        
        
    }else if(page_type==4||page_type==5){
        
        //By Richard 2018.6.27
        
        [rightBtnView setBackgroundImage:[UIImage imageNamed:@"detail_editdata_icon.jpg"] forState:UIControlStateNormal];
        
    }
    
    if(page_type==4){
        
        //By Richard 2018.6.27
        [mapBtnView setBackgroundImage:[UIImage imageNamed:@"detail_find_icon.jpg"] forState:UIControlStateNormal];
    }
    
    
    [title_label setText:[title_type objectAtIndex:page_type]];
    
    dataAry = [[NSMutableArray alloc] init];
    [detail_scrollView setPagingEnabled:YES];
    [detail_scrollView setBounces:NO];
    //[scrollView setBackgroundColor:[UIColor blackColor]];
    
    [detail_scrollView setShowsVerticalScrollIndicator:NO];
    [detail_scrollView setShowsHorizontalScrollIndicator:NO];
    
    [detail_scrollView setDelegate:self];
    
    connectFlag = 0;
    [self connectHttp];
    
}

- (IBAction)btnFbShare:(id)sender
{
    
    NSMutableDictionary *params =
    [[NSMutableDictionary alloc] init];
    // [params setObject:send_text forKey:@"caption"];
    
    if (page_type==2||page_type==3) {
        
        [params setObject:[NSString stringWithFormat:@"大家好,我叫%@,請給我一個溫暖的家！！", str_name] forKey:@"description"];
    }else{
        [params setObject:[NSString stringWithFormat:@"大家好,我叫%@,請幫我尋找我的主人！！", str_name] forKey:@"description"];
    }
    
    [params setObject:@"http://www.tcapo.gov.taipei/" forKey:@"link"];
    [params setObject:pic_one forKey:@"picture"];
    // [params setObject:@"https://itunes.apple.com/tw/app/tai-bei-shi-dong-wu-fu-li/id1001883180?l=zh&mt=8" forKey:@"link"];
    [params setObject:@"1633953366834404" forKey:@"app_id"];
    [params setObject:@"touch" forKey:@"display"];
    [params setObject:@"臺北市動物福利" forKey:@"name"];
    
    //http://www.tcapo.gov.taipei/
    [FBWebDialogs presentFeedDialogModallyWithSession:nil  parameters:params  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) { }];
    
    // [FBWebDialogs presentRequestsDialogModallyWithSession:nil message:@"111" title:@"臺北市動物福利" parameters:params  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) { }];
    
    
    
}
- (IBAction)btnTwitterShare:(id)sender
{
    
    SLComposeViewController * twitterOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    
    
    [twitterOBJ setInitialText: [NSString stringWithFormat:@"台北動物保護處\n%@", send_text]];
    
    [twitterOBJ addURL:[NSURL URLWithString:@"http://www.weblineindia.com"]];
    // [twitterOBJ addImage:[UIImage imageNamed:@"default_icon.jpg"]];
    
    [self presentViewController:twitterOBJ animated:YES completion:Nil];
}
- (IBAction)btnLineShare:(id)sender
{
    
    
    NSString *shareText = [send_text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"Encoded text: %@", shareText);
    
    shareText =[NSString stringWithFormat:@"line://msg/text/%@", shareText];
    
    NSURL *appURL = [NSURL URLWithString:shareText];
    if ([[UIApplication sharedApplication] canOpenURL: appURL]) {
        [[UIApplication sharedApplication] openURL: appURL];
    }
    else { //如果使用者沒有安裝，連結到App Store
        NSURL *itunesURL = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id443904275"];
        [[UIApplication sharedApplication] openURL:itunesURL];
    }
    
}
- (IBAction)btnGoogleShare:(id)sender
{
    if ([[UIApplication sharedApplication] canOpenURL:
         [NSURL URLWithString:@"gplus://"]]) {
        
        
        if ([[GPPSignIn sharedInstance] authentication]) {
            // [GPPShare sharedInstance].delegate = self;
            
            id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
            
            [shareBuilder setPrefillText:[NSString stringWithFormat:@"台北動物保護處\n%@", send_text]];
            // [(id<GPPNativeShareBuilder>)shareBuilder attachImage:[UIImage imageNamed:@"default_icon.jpg"]];
            [shareBuilder open];
        }else{
            GPPSignIn *signIn = [GPPSignIn sharedInstance];
            signIn.shouldFetchGooglePlusUser = YES;
            
            signIn.clientID = @"93895218503-e89f82nf0fkkun2k2mbamf46g2l5mncn.apps.googleusercontent.com";
            signIn.scopes = @[ kGTLAuthScopePlusLogin ];
            signIn.delegate = self;
            
            [signIn authenticate];
            [signIn trySilentAuthentication];
        }
        
    } else {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/tw/app/google+/id447119634?l=zh&mt=8"]];
        
    }
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {
    
    
    NSLog(@"Received error %@ and auth object %@",error, auth);
    
    id<GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    [shareBuilder setPrefillText:[NSString stringWithFormat:@"台北動物保護處\n%@", send_text]];
    // [(id<GPPNativeShareBuilder>)shareBuilder attachImage:[UIImage imageNamed:@"default_icon.jpg"]];
    [shareBuilder open];
    
}

- (IBAction)btnHome:(id)sender
{
    MainViewController *mainVC = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    UINavigationController *mainVCNavigationController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    
    [mainVCNavigationController.navigationBar setHidden:TRUE];
    
    [self presentViewController:mainVCNavigationController animated:NO completion:nil];
}
- (IBAction)btnBack:(id)sender;
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)btnYoutube:(id)sender;
{
    VideoMainViewController *playVC = [[VideoMainViewController alloc] initWithNibName:@"VideoMainViewController" bundle:nil];
    UINavigationController *playNC= [[UINavigationController alloc] initWithRootViewController:playVC];
    
    [playVC setYoutube_id:str_youtube];
    [playNC.navigationBar setHidden:TRUE];
    
    [self presentViewController:playNC animated:NO completion:nil];
    
}

- (IBAction)btnMap:(id)sender;
{
    if(page_type==2||page_type==3){
        
        if([str_location rangeOfString:@"台灣動物協會"].location != NSNotFound){
            
            str_location =@"台灣動物協會";
            
        }else if([str_location rangeOfString:@"臺北市動物之家"].location != NSNotFound){
            
            str_location =@"臺北市動物之家";
        }
        
        
        NSString* urlString = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", str_location];
        
        NSString *escaped = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped]];
        
    }else if(page_type==4){
        
        connectFlag = 1;
        
        [self connectHttp];
        
    }else{
        
        if(![[NSString stringWithFormat:@"%@",str_gps]  isEqualToString:@""]&&![[NSString stringWithFormat:@"%@",str_gps]  isEqualToString:@","]){
            
            NSString* urlString1 = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@", str_gps];
            NSString *escaped1 = [urlString1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:escaped1]];
        }else{
            [Utility alertWithTitle:@"訊息" message:@"無所在地資料"];
        }
    }
}

- (IBAction)btnTel:(id)sender;
{
    NSString *strPh =@"";
    
    if(page_type==2||page_type==3){
        strPh = str_tel;
        
    }else{
        strPh = [@"0287913064" stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    }
    
    if (![strPh isEqualToString:@""]) {
        
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",strPh]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else{
            UIAlertView *calert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Call facility is not available!!!" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [calert show];
        }
    }else{
        [Utility alertWithTitle:@"訊息" message:@"無電話資料"];
    }
}
- (IBAction)btnBulletin:(id)sender;
{
    
    MemberUploadViewController *uploadVC = [[MemberUploadViewController alloc] initWithNibName:@"MemberUploadViewController" bundle:nil];
    
    UINavigationController *uploadNC = [[UINavigationController alloc] initWithRootViewController:uploadVC];
    
    if(page_type==2||page_type==3){
        
        
        NSString *subject =[NSString stringWithFormat:@"我想要認養(%@)",str_name];
        
        NSString *body = @"您的真實姓名:\n聯絡電話:\n常用email:\n我想認養:\n認養原因:\n居住城市:\n我的家庭成員:\n家中是否有其他寵物:\n請簡單自我介紹:";
        
        NSString *address = str_email;
        
        //NSString *cc = @"test2@akosma.com";       副本
        NSString *path = [NSString stringWithFormat:@"mailto:%@?&subject=%@&body=%@", address, subject, body];
        
        NSURL *url = [NSURL URLWithString:[path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [[UIApplication sharedApplication] openURL:url];
        
        /*
         // Email Subject
         NSString *emailTitle = [NSString stringWithFormat:@"我想要認養(%@)",str_name];
         // Email Content
         NSString *messageBody = @"您的真實姓名:\n聯絡電話:\n常用email:\n我想認養:\n認養原因:\n居住城市:\n我的家庭成員:\n家中是否有其他寵物:\n請簡單自我介紹:";
         // To address
         NSArray *toRecipents = [NSArray arrayWithObject: str_email];
         
         MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
         mc.mailComposeDelegate = self;
         [mc setSubject:emailTitle];
         [mc setMessageBody:messageBody isHTML:NO];
         [mc setToRecipients:toRecipents];
         
         // Present mail view controller on screen
         [self presentViewController:mc animated:YES completion:NULL];*/
        
    }else if(page_type==4){
        
        [uploadVC setPage_type:2];
        [uploadVC setDataAry:dataAry];
        
        [uploadNC.navigationBar setHidden:TRUE];
        
        [self presentViewController:uploadNC animated:NO completion:nil];
    }else if(page_type==5){
        
        [uploadVC setPage_type:3];
        [uploadVC setDataAry:dataAry];
        
        [uploadNC.navigationBar setHidden:TRUE];
        
        [self presentViewController:uploadNC animated:NO completion:nil];
    }else if(page_type==0){
        
        
        [uploadVC setPage_type:4];
        [uploadVC setDataAry:dataAry];
        
        [uploadNC.navigationBar setHidden:TRUE];
        
        [self presentViewController:uploadNC animated:NO completion:nil];
    }
    
}







//http連線接收

-(void)connectHttp{
    if(receivedData==nil)
    {
        receivedData = [[NSMutableData alloc] init];
    }
    
    [receivedData setLength:0];
    
    NSString *urlApi =@"";
    if (connectFlag==0) {
        if(page_type==2||page_type==3){
            urlApi =[NSString stringWithFormat:@"%@?tid=%@&id=%@",[url_type objectAtIndex:page_type], detail_tid,detail_id];
        }else{
            urlApi =[NSString stringWithFormat:@"%@?id=%@",[url_type objectAtIndex:page_type], detail_id];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlApi]];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }else{
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@Query/MissingFound.ashx",NSLocalizedString(@"api_ip", @"")]]
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:3.0];
        urlApi=[NSString stringWithFormat:@"pdata={'id':'%@','member':'%@'}",detail_id,[UserPreferences getStringForKey:PREF_TOKEN]];
        
        [request setHTTPBody:[urlApi dataUsingEncoding:NSUTF8StringEncoding]];
        
        [request setHTTPMethod:@"POST"];
        connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    }
    
    
    
    
    
    if(!connection)
    {
        receivedData = nil;
    }
    
}

- (void)connection:(NSURLConnection *)_connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}


- (void)connection:(NSURLConnection *)_connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    //   NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
    connection = nil;
    receivedData = nil;
    
    [Utility alertWithTitle:@"訊息" message:@"連結失敗!! 請重新登入!!"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
    
    // convert to JSON
    
    
    NSError *myError = nil;
    
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    
    
    if (connectFlag==0) {
        
        str_tel = [res objectForKey:@"tel"];
        
        if ([res objectForKey:@"youtube"] != [NSNull null]){
            
            if(![[res objectForKey:@"youtube"] isEqualToString:@""]){
                
                str_youtube = [res objectForKey:@"youtube"];
                
            }else{
                
                [youtubeBtnView setBackgroundImage:[UIImage imageNamed:@"share_youtube_icon_lock.png"] forState:UIControlStateNormal];
                
                [youtubeBtnView setEnabled:YES];
            }
            
        }else{
            
        }
        
        
        //By Richard 2017.3.14
        //Fixed 按下 會員中心\協尋公告\我的協尋列表中無資料的項目 後,會當機的問題
        @try {
            
            str_location = [res objectForKey:@"location"];
            
            if([str_location rangeOfString:@"台灣動物協會"].location != NSNotFound){
                
                str_location =@"台灣動物協會";
                
            }else if([str_location rangeOfString:@"臺北市動物之家"].location != NSNotFound){
                
                str_location =@"臺北市動物之家";
            }

            
        } @catch (NSException *exception) {
            
            
        } @finally {
            
        }
        
        
        
        str_name = [res objectForKey:@"name"];
        
        str_email = [res objectForKey:@"email"];
        
        send_text = @"";
        
        
        
        if (page_type == 2||page_type == 3) {
            
            send_text=[NSString stringWithFormat:@"點閱率:%@\n寵物名稱:%@\n收容編號:%@\n種別:%@\n品種:%@\n性別:%@\n毛色:%@\n年齡:%@\n體型:%@",[res objectForKey:@"click"], [res objectForKey:@"name"],[res objectForKey:@"acceptnum"],[res objectForKey:@"type"],[res objectForKey:@"breed"],[res objectForKey:@"sex"],[res objectForKey:@"hair"],[res objectForKey:@"age"],[res objectForKey:@"size"]];
            
            //"\n聯絡電話:"+listData.get(0).get("tel")+
            //"\n聯絡e-mail:"+listData.get(0).get("email")
            
            if ([res objectForKey:@"drsc"] != [NSNull null]){
                if(![[res objectForKey:@"drsc"] isEqualToString:@""]){
                    
                    send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n描述:%@",[res objectForKey:@"drsc"]]];
                }
            }
            
            
            
            if ([res objectForKey:@"child"] != [NSNull null]){
                
                if(![[res objectForKey:@"child"] isEqualToString:@""]){
                    
                    send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n可否與其他孩童相處:%@",[res objectForKey:@"child"]]];
                }
            }
            if ([res objectForKey:@"animal"] != [NSNull null]){
                
                if(![[res objectForKey:@"animal"] isEqualToString:@""]){
                    
                    send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n可否與其他動物相處:%@",[res objectForKey:@"animal"]]];
                }
            }
            send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n收容日期:%@",[res objectForKey:@"date"]]];
           send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n位置:%@",str_location]];
            send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n聯絡電話:%@",[res objectForKey:@"tel"]]];
            send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n聯絡Email:%@",[res objectForKey:@"email"]]];
         
        }else{
            [dataAry addObject:[res objectForKey:@"pic"]];
            [dataAry addObject:[res objectForKey:@"name"]];
            [dataAry addObject:[res objectForKey:@"type"]];
            [dataAry addObject:[res objectForKey:@"sex"]];
            [dataAry addObject:[res objectForKey:@"hair"]];
            [dataAry addObject:[res objectForKey:@"age"]];
            [dataAry addObject:[res objectForKey:@"size"]];
            [dataAry addObject:[res objectForKey:@"area"]];
            [dataAry addObject:[res objectForKey:@"chipNo"]];
            [dataAry addObject:[res objectForKey:@"dogNo"]];
            [dataAry addObject:[res objectForKey:@"drsc"]];
            [dataAry addObject:[res objectForKey:@"location"]];
            [dataAry addObject:[res objectForKey:@"youtube"]];
            [dataAry addObject:[res objectForKey:@"gps"]];
            [dataAry addObject: [res objectForKey:@"date"]];
            [dataAry addObject:[res objectForKey:@"id"]];
            [dataAry addObject:[res objectForKey:@"breed"]];
            
            
            if ([res objectForKey:@"gps"] != [NSNull null]){
                str_gps  = [res objectForKey:@"gps"];
            }
            send_text=[NSString stringWithFormat:@"點閱率:%@\n寵物名稱:%@",[res objectForKey:@"click"] , [res objectForKey:@"name"]];
            
            // NSLog(@"---%@",[res objectForKey:@"click"]);
            if ([res objectForKey:@"type"] != [NSNull null]){
                if(![[res objectForKey:@"type"] isEqualToString:@""]){
                    
                    send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n種別:%@",[res objectForKey:@"type"]]];
                }
            }
            if ([res objectForKey:@"breed"] != [NSNull null]){
                if(![[res objectForKey:@"breed"] isEqualToString:@""]){
                    
                    send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n品種:%@",[res objectForKey:@"breed"]]];
                }
            }
            if ([res objectForKey:@"sex"] != [NSNull null]){
                if(![[res objectForKey:@"sex"] isEqualToString:@""]){
                    
                    send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n性別:%@",[res objectForKey:@"sex"]]];
                }
            }
            
            if ([res objectForKey:@"hair"] != [NSNull null]){
                if(![[res objectForKey:@"hair"] isEqualToString:@""]){
                    
                    send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n顏色:%@",[res objectForKey:@"hair"]]];
                }
            }
            if ([res objectForKey:@"age"] != [NSNull null]){
                if(![[res objectForKey:@"age"] isEqualToString:@""]){
                    
                    send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n年齡:%@",[res objectForKey:@"age"]]];
                }
            }
            if ([res objectForKey:@"size"] != [NSNull null]){
                if(![[res objectForKey:@"size"] isEqualToString:@""]){
                    
                    send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n體型:%@",[res objectForKey:@"size"]]];
                }
            }
            if ([res objectForKey:@"area"] != [NSNull null]){
                if(![[res objectForKey:@"area"] isEqualToString:@""]){
                    
                    send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n行政區:%@",[res objectForKey:@"area"]]];
                }
            }
            if ([res objectForKey:@"chipNo"] != [NSNull null]){
                if(![[res objectForKey:@"chipNo"] isEqualToString:@""]){
                    
                    send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n晶片編號:%@",[res objectForKey:@"chipNo"]]];
                }
            }
            if ([res objectForKey:@"dogNo"]!= [NSNull null]){
                if(![[res objectForKey:@"dogNo"] isEqualToString:@""]){
                    
                    send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n狂犬病牌證號碼:%@",[res objectForKey:@"dogNo"]]];
                }
            }
            
            
            if (page_type==0||page_type==4) {
                
                [dataAry addObject:[res objectForKey:@"quot"]];
                
                NSNumber * isFound = (NSNumber *)[res objectForKey: @"isFound"];
                
                if([isFound boolValue] == YES&&page_type==4)
                {
                    
                    [mapBtnView setHidden:YES];
                    [rightBtnView setHidden:YES];
                    /* [rightBtnView setFrame:CGRectMake(rightBtnView.frame.size.width/2, rightBtnView.frame.origin.y, rightBtnView.frame.size.width, rightBtnView.frame.size.height)];*/
                    
                }
                
                if ([res objectForKey:@"quot"] != [NSNull null]){
                    if(![[res objectForKey:@"quot"] isEqualToString:@""]){
                        
                        send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n協尋語錄:%@",[res objectForKey:@"quot"]]];
                    }
                }
                if ([res objectForKey:@"drsc"] != [NSNull null]){
                    if(![[res objectForKey:@"drsc"] isEqualToString:@""]){
                        
                        send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n寵物描述:%@",[res objectForKey:@"drsc"]]];
                    }
                }
                if ([res objectForKey:@"location"] != [NSNull null]){
                    if(![[res objectForKey:@"location"] isEqualToString:@""]){
                        
                        send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n失蹤地點:%@",[res objectForKey:@"location"]]];
                    }
                }
                
                send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n失蹤日期:%@",[res objectForKey:@"date"]]];
                
                
            }else{
                if ([res objectForKey:@"drsc"] != [NSNull null]){
                    if(![[res objectForKey:@"drsc"] isEqualToString:@""]){
                        
                        send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n寵物特徵:%@",[res objectForKey:@"drsc"]]];
                    }
                }
                if ([res objectForKey:@"location"] != [NSNull null]){
                    if(![[res objectForKey:@"location"] isEqualToString:@""]){
                        
                        send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n通報地點:%@",[res objectForKey:@"location"]]];
                    }
                }
                
                send_text = [send_text stringByAppendingString:[[NSString alloc] initWithFormat:@"\n通報日期:%@",[res objectForKey:@"date"]]];
            }
            
            
        }
        
        
        
        CGSize size = [send_text sizeWithFont:contentTxt.font constrainedToSize:CGSizeMake(contentTxt.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        // 設定Label的內容跟尺寸
        [contentTxt setFrame:CGRectMake(contentTxt.frame.origin.x, contentTxt.frame.origin.y, contentTxt.frame.size.width, size.height)];
        
        [detail_scrollView setContentSize:CGSizeMake(screenWidth , size.height+50)];
        
        [contentTxt setText:send_text];
        
        
        
        if ([res objectForKey:@"pic"] != [NSNull null]) {
            [self addView:[res objectForKey:@"pic"]];
            [self showAdvs];
        }
        
        [myAlertView dismissWithClickedButtonIndex:0 animated:YES];
    }else{
        NSNumber * isSuccessNumber = (NSNumber *)[res objectForKey: @"Success"];
        
        if([isSuccessNumber boolValue] == YES)
        {
            [mapBtnView setHidden:YES];
            [rightBtnView setHidden:YES];
            
            /* [rightBtnView setFrame:CGRectMake(rightBtnView.frame.size.width/2, rightBtnView.frame.origin.y, rightBtnView.frame.size.width, rightBtnView.frame.size.height)];*/
            [Utility alertWithTitle:@"訊息" message:@"寵物已尋獲"];
        }else{
            [Utility alertWithTitle:@"訊息" message:@"讀取失敗!! 請重新點擊!!"];
        }
        
    }
    
}




#pragma mark -添加控件
- (void)addView:(NSArray*)picAry{
    
    advsList= [[NSMutableArray alloc]init];
    advsList = [(NSArray*)picAry mutableCopy];
    
    
    pic_one =[NSString stringWithFormat:@"%@/%@",[photourl_type objectAtIndex:page_type], [advsList objectAtIndex:0]];
    
    imgflag = 0;
    
    if(advsList.count==0||[[advsList objectAtIndex:0] isEqualToString:@""]){
        [advsList removeAllObjects];
        [advsList addObject:@"default_icon_big.jpg"];
        imgflag=1;
    }
    
    
    
    // advsList= [[NSMutableArray alloc]init];
    //添加图片
    /*for (int i = 1; i < 4; i++) {
     [advsList addObject:[NSString stringWithFormat:@"about_logo%d.jpg",i]];
     }*/
    
    
    //设置代理这个必须的
    img_scrollView.delegate = self;
    //设置总大小也就是里面容纳的大小
    img_scrollView.contentSize = CGSizeMake(self.view.frame.size.width * advsList.count,150);
    [img_scrollView setBackgroundColor:[UIColor whiteColor]];
    //里面的子视图跟随父视图改变大小
    [img_scrollView setAutoresizesSubviews:YES];
    //设置分页形式，这个必须设置
    [img_scrollView setPagingEnabled:YES];
    //隐藏横竖滑动块
    [img_scrollView setShowsVerticalScrollIndicator:NO];
    [img_scrollView setShowsHorizontalScrollIndicator:NO];
    
}



#pragma mark -展示广告位,初始化
- (void)showAdvs {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        isAdd = true;
        
        for (UIView *view in [img_scrollView subviews]) {
            [view removeFromSuperview];
        }
        
        for(int i = 0; i < [advsList count]; i ++) {
            UIButton *thumbView = [[UIButton alloc] init];
            [thumbView addTarget:self
                          action:@selector(myDidSelectAdvAtIndex:)
                forControlEvents:UIControlEventTouchUpInside];
            CGSize mSize = [[UIScreen mainScreen] bounds].size;
            thumbView.tag = i;
            UIImage *imgTemp;
            
            if (imgflag == 0) {
                NSString *img_url =[NSString stringWithFormat:@"%@/%@",[photourl_type objectAtIndex:page_type], [advsList objectAtIndex:i]];
                imgTemp = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]]];
                CGFloat imgWidth = imgTemp.size.width*(img_scrollView.frame.size.height/imgTemp.size.height)-(mSize.width/3);
                CGFloat imgHeight = img_scrollView.frame.size.height;
                CGFloat flagWidth = mSize.width -150;
                
                if (imgWidth < flagWidth) {
                    imgWidth = flagWidth;
                } else if ((imgWidth = NAN)) {
                    imgWidth = 56.71212121212119;
                }
                
                thumbView.bounds = CGRectMake(0, 0, imgWidth, imgHeight);
                thumbView.center = CGPointMake(mSize.width *( 0.5 + i) , imgHeight * 0.5);
            } else {
                imgTemp = [UIImage imageNamed:advsList[i]];
                CGFloat imgWidth = imgTemp.size.width*(img_scrollView.frame.size.height/imgTemp.size.height)-(mSize.width/3);
                
                if (imgWidth < 200) {
                    imgWidth = 200;
                }
                
                CGFloat imgHeight = img_scrollView.frame.size.height;
                CGFloat flagWidth = mSize.width -150;
                
                if (imgWidth < flagWidth) {
                    imgWidth = flagWidth;
                }
                
                thumbView.bounds = CGRectMake(0, 0, imgWidth, imgHeight);
                thumbView.center = CGPointMake(mSize.width *( 0.5 + i) , imgHeight * 0.5);
            }
            
            thumbView.adjustsImageWhenHighlighted = NO;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //[imgvDefault removeFromSuperview];
                [thumbView setBackgroundImage: imgTemp forState: UIControlStateNormal];
                [img_scrollView addSubview: thumbView];
                [self addNSTimer];
            });
        }
    });
}

#pragma mark -添加定时器
-(void)addNSTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    //添加到runloop中
    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}

#pragma mark -删除定时器
-(void)removeNSTimer
{
    [ _timer invalidate];
    _timer =nil;
}


#pragma mark -定时器下一页
- (void)nextPage{
    //int num = self.pagePoint.currentPage;
    int num = page_point;
    if(isAdd){
        num++;
        if(num == advsList.count -1){
            isAdd = false;
        }
    }else{
        num--;
        if(num == 0){
            isAdd = true;
        }
    }
    [self scrollToIndex:num];
}

#pragma mark -滑动的距离
- (void)scrollToIndex:(NSInteger)index
{
    
    CGRect frame = img_scrollView.frame;
    frame.origin.x = frame.size.width * index;
    frame.origin.y = 0;
    [img_scrollView scrollRectToVisible:frame animated:YES];
}

#pragma mark -滑动完成时计算滑动到第几页
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat pageWidth = scrollView.frame.size.width;
    //int page = floor((scrollView.contentOffset.x - pageWidth / 2) /pageWidth) +1;
    page_point  = floor((scrollView.contentOffset.x - pageWidth / 2) /pageWidth) +1;
    // [self.pagePoint setCurrentPage:page];
}

#pragma mark -当用户开始拖拽的时候就调用移除计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeNSTimer];
}
#pragma mark -当用户停止拖拽的时候调用添加定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addNSTimer];
}

#pragma mark -点击广告
- (void)myDidSelectAdvAtIndex:(id) index
{
    UIButton *thumbView = (UIButton *)index;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
