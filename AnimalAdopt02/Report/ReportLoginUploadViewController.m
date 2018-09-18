//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "ReportLoginUploadViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "MemberCenterViewController.h"
#import "ReportMainViewController.h"
#import "UserPreferences.h"
#import "Utility.h"
#import "ASIFormDataRequest.h"
#import <CoreLocation/CoreLocation.h>
#import "EditEntity.h"
#import "RadioButton.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Word_AES.h"

@interface ReportLoginUploadViewController (){
    NSMutableData *receivedData;
    NSURLConnection *connection;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    IBOutlet UIScrollView *list_scrollView;
    IBOutlet UIScrollView *photo_scrollView;
    
    
    
   /* string r_type { get; set; }//報案分類
    string a_type { get; set; }//動物分類
    string b_type { get; set; }//品種分類
    string p_type { get; set; }//行政區
    string h_type { get; set; }//毛色
    string s_type { get; set; }//動物性別*/
    
     IBOutlet UITextField *codeTxt;
     IBOutlet UITextField *chipNoTxt;
    IBOutlet UITextField *dogNoTxt;
    
    
    IBOutlet UITextField *storyTxt;
    IBOutlet UITextField *remarkTxt;

    IBOutlet UITextField *healthTxt;
    IBOutlet UITextField *youtubeTxt;
    IBOutlet UITextField *locationTxt;
    IBOutlet UITextField *gpsTxt;
    IBOutlet UITextField *dateTxt;
    
    IBOutlet UITextField *typeTxt;
    IBOutlet UITextField *breedTxt;
    IBOutlet UITextField *sexTxt;
    IBOutlet UITextField *hairTxt;
    IBOutlet UITextField *reportTxt;
    IBOutlet UITextField *areaTxt;
    IBOutlet UITextField *featureTxt;
    IBOutlet UITextField *sizeTxt;
    
    IBOutlet UITextField *x_nameTxt;
    IBOutlet UITextField *x_idnoTxt;
    IBOutlet UITextField *x_phoneTxt;
    IBOutlet UITextField *x_emailTxt;
    IBOutlet UITextField *x_mainnameTxt;
    IBOutlet UITextField *x_addrTxt;
    IBOutlet UITextField *x_name_oTxt;
    IBOutlet UITextField *x_idno_oTxt;
    
    IBOutlet UILabel *plurkLabel;
    IBOutlet UILabel *title_label;
    IBOutlet UILabel *location_label;
    IBOutlet UILabel *date_label;
    IBOutlet UILabel *drsc_label;
    NSArray *sellist,*msglist;
   
    NSMutableArray *imgPhotoAry;
    IBOutlet UIImageView *photo1;
     IBOutlet UIImageView *photo2;
     IBOutlet UIImageView *photo3;
     IBOutlet UIImageView *photo4;
     IBOutlet UIImageView *photo5;
    
     NSMutableArray *imgPhotoViewAry;
    IBOutlet UIView *photoView1;
    IBOutlet UIView *photoView2;
    IBOutlet UIView *photoView3;
    IBOutlet UIView *photoView4;
    IBOutlet UIView *photoView5;
   
    
    IBOutlet UIView *is_peopleView;
    IBOutlet UIView *no_peopleView;
    IBOutlet UIView *bottomView;

    BOOL isButtonOn;
    IBOutlet RadioButton* radioButton;
    
    UIPickerView *selPicker;
    UIDatePicker *datePicker;
    NSMutableArray *images;
    NSMutableArray *imageNames;
    NSInteger photoCount;
    
     NSArray *SelAry[6];
    int selItem;
    NSMutableArray *reportNameAry;
    NSMutableArray *reportIdAry;
    
    
    
    NSString *str_pic,*str_report_msg,*str_type,*str_breed,*str_area,*str_hair,*str_sex,
        *str_x_name,*str_x_idno,*str_x_phone,*str_x_email
    ,*str_x_addr,*str_x_name_o,*str_x_idno_o,
    
    *str_chipNo,*str_feature,*str_size,*str_health,
    
    
   *str_story,*str_remark,*str_youtube,*str_date,*str_location,*str_drsc,*str_video,*str_gps;
    
    
    NSDate *nowDate ;
 
}

@end

@implementation ReportLoginUploadViewController
//@synthesize page_type;
//@synthesize dataAry;

@synthesize str_r_name;
@synthesize str_r_idno;
@synthesize str_r_phone;
@synthesize str_r_sex;
@synthesize str_r_email;
@synthesize str_r_addr;

@synthesize str_r_name_o;
@synthesize str_r_idno_o;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self startStandardUpdates];
  
str_pic=@"";str_report_msg=@"";str_type=@"";
    str_breed=@"";str_area=@"";str_hair=@"";str_sex=@"",str_size=@"";
str_x_name=@"";str_x_idno=@"";str_x_phone=@"";str_x_email=@"";str_x_addr=@"";str_x_name_o=@"";str_x_idno_o=@"";
    
str_chipNo=@"";str_feature=@"";
str_story=@"";str_remark=@"";str_youtube=@"";str_date=@"";str_location=@"";str_drsc=@"";str_video=@"";str_gps=@"";
   
    isButtonOn = YES;
    
    CLLocation *currentLocation = locationManager.location ;
    if (currentLocation != nil)
    {//取得經緯度資訊，並組合成字串
        NSString * gps_str = [[NSString alloc] initWithFormat:@"%f,%f"
                          , currentLocation.coordinate.latitude
                          , currentLocation.coordinate.longitude];
        [gpsTxt setText:gps_str];
    }
    
    reportNameAry = [UserPreferences getArrayForKey:@"ReportNameSet"];
    reportIdAry = [UserPreferences getArrayForKey:@"ReportIdSet"];
    
    selItem = 0;
    
   
    

    nowDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:@"yyyy/MM/dd"];
    NSString *nowDateString = [dateFormater stringFromDate:nowDate];
    [dateTxt setText:nowDateString];
  

    
    
    [reportTxt setTag:0];
    [typeTxt setTag:1];
    [breedTxt setTag:2];
    [hairTxt setTag:3];
    [areaTxt setTag:4];
    [sexTxt setTag:5];
    [sizeTxt setTag:6];
  
    photoCount = 0;
    images = [[NSMutableArray alloc] init];
    imageNames = [[NSMutableArray alloc] init];
    imgPhotoAry = [[NSMutableArray alloc]initWithObjects:photo1,photo2,photo3,photo4,photo5,nil];
    imgPhotoViewAry = [[NSMutableArray alloc]initWithObjects:photoView1,photoView2,photoView3,photoView4,photoView5,nil];
    
    
    

    CGSize mSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenWidth = mSize.width;
    CGFloat screenHeight = mSize.height;
    
   // list_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 70, screenWidth,screenHeight-120)];
    
    [photo_scrollView setContentSize:CGSizeMake(600,130)];
    
    [photo_scrollView setPagingEnabled:YES];
    [photo_scrollView setBounces:NO];
    //[scrollView setBackgroundColor:[UIColor blackColor]];
    
    [photo_scrollView setShowsVerticalScrollIndicator:NO];
    [photo_scrollView setShowsHorizontalScrollIndicator:NO];
    
    [photo_scrollView setDelegate:self];
    
    [list_scrollView setContentSize:CGSizeMake(screenWidth,1200)];
    
    
    [list_scrollView setPagingEnabled:NO];
    [list_scrollView setBounces:NO];
    //[scrollView setBackgroundColor:[UIColor blackColor]];
    
    [list_scrollView setShowsVerticalScrollIndicator:NO];
    [list_scrollView setShowsHorizontalScrollIndicator:NO];
    
    [list_scrollView setDelegate:self];
    
    
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didRecognizeTapGesture:)];
    [youtubeTxt.superview addGestureRecognizer:tapGesture];

}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
     NSTimeInterval animationDuration=0.30f;
     [UIView beginAnimations:@"ResizeForKeyboard"context:nil];
     [UIView setAnimationDuration:animationDuration];
     float width = self.view.frame.size.width;
     float height = self.view.frame.size.height;
     //上移n个单位，按实际情况设置
     CGRect rect=CGRectMake(0.0f,-130,width,height);
     self.view.frame=rect;
     [UIView commitAnimations];

}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard"context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
     CGRect rect=CGRectMake(0.0f,0.0,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return;
}

- (void)didRecognizeTapGesture:(UITapGestureRecognizer*)gesture
{
    CGPoint point = [gesture locationInView:gesture.view];
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        if (CGRectContainsPoint(youtubeTxt.frame, point))
        {
            
        }
    }
}

-(IBAction)onRadioBtn:(RadioButton*)sender
{
    
    CGSize mSize = [[UIScreen mainScreen] bounds].size;
    CGFloat screenHeight = mSize.height;
    NSLog(@"sel-->%@",sender.titleLabel.text);
    NSString *sel_txt = sender.titleLabel.text;
    if ([sel_txt isEqualToString:@"自然人"]) {
        [is_peopleView setHidden:NO];
        [no_peopleView setHidden:YES];
         [bottomView setFrame:CGRectMake(0, 750,screenHeight ,390)];
        isButtonOn=YES;
    }else {
        [is_peopleView setHidden:YES];
        [no_peopleView setHidden:NO];
        [bottomView setFrame:CGRectMake(0, 870,screenHeight ,390)];
        isButtonOn=NO;
    }
}

- (void)startStandardUpdates
{
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager startUpdatingLocation];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
   

    
    // 建立 UIDatePicker
    selPicker = [[UIPickerView alloc]init];
    selPicker.delegate =self;
    selPicker.dataSource=self;
 
    // 建立 UIDatePicker
    datePicker = [[UIDatePicker alloc]init];
    NSLocale *datelocale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    datePicker.locale = datelocale;
    datePicker.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    
    // 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    // 選取日期完成鈕 並給他一個 selector
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(selDoneClick:)];
    
    UIBarButtonItem *spaceBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    // 把按鈕加進 UIToolbar
    //toolBar.items = [NSArray arrayWithObject:doneBtn1];
    toolBar.items = @[spaceBtn,doneBtn];
    
    UIToolbar *dateBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    // 選取日期完成鈕 並給他一個 selector
    UIBarButtonItem *dateDone=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(btnDoneDate:)];
    dateBar.items= @[spaceBtn,dateDone];
    [datePicker setDate:nowDate animated:YES];
    dateTxt.inputView = datePicker;
    dateTxt.inputAccessoryView = dateBar;
     // if(textField.tag == typeTxt.tag)
    
    
    
  /*  	r =>違法事實(json object Array)
    	a =>動物種類(json object Array)
    	b =>動物品種(json object Array)
    	h=>動物毛色(json object Array)
    	p=>行政區(json object Array)
    	s=>動物性別(json object Array)*/
    
   
    switch (textField.tag) {
        case 0:
            sellist = [reportNameAry objectAtIndex:0];
            selItem = 0;
            [selPicker reloadAllComponents];
            reportTxt.inputView = selPicker;
            reportTxt.inputAccessoryView = toolBar;
            break;
        case 1:
            sellist = [reportNameAry objectAtIndex:1];
            selItem = 1;
            [selPicker reloadAllComponents];
            typeTxt.inputView = selPicker;
            typeTxt.inputAccessoryView = toolBar;
            break;
        case 2:
            sellist = [reportNameAry objectAtIndex:2];
            selItem = 2;
            [selPicker reloadAllComponents];
            breedTxt.inputView = selPicker;
            breedTxt.inputAccessoryView = toolBar;
            break;
        case 3:
            sellist = [reportNameAry objectAtIndex:3];
            selItem = 3;
            [selPicker reloadAllComponents];
            hairTxt.inputView = selPicker;
            hairTxt.inputAccessoryView = toolBar;
            break;
        case 4:
            sellist = [reportNameAry objectAtIndex:4];
            selItem = 4;
            [selPicker reloadAllComponents];
            areaTxt.inputView = selPicker;
            areaTxt.inputAccessoryView = toolBar;
            break;
        case 5:
            sellist = [reportNameAry objectAtIndex:5];
            selItem = 5;
            [selPicker reloadAllComponents];
            sexTxt.inputView = selPicker;
            sexTxt.inputAccessoryView = toolBar;
            break;
        case 6:
            sellist = [reportNameAry objectAtIndex:6];
            selItem = 6;
            [selPicker reloadAllComponents];
            sizeTxt.inputView = selPicker;
            sizeTxt.inputAccessoryView = toolBar;
            break;
       
            
        default:
            
            break;
    }
    
    return YES;
}


- (void)selDoneClick:(id)sender
{
    [self.view endEditing:YES];
    NSInteger row =[selPicker selectedRowInComponent:0];
    NSString *selected_name = [sellist objectAtIndex:row];
    
    
   // if (selItem!=6) {
        NSMutableDictionary *dictId =[reportIdAry objectAtIndex:selItem];
        
        NSString * selected_id = [dictId objectForKey:selected_name];
        
        switch (selItem) {
            case 0:
                str_report_msg = selected_id;
                //[typeBtnView setTitle:selected_name forState:UIControlStateNormal];
                
                [reportTxt setText:selected_name];
                break;
            case 1:
                str_type = selected_id;
                [typeTxt setText:selected_name];
                break;
            case 2:
                str_breed = selected_id;
                [breedTxt setText:selected_name];
                break;
            case 3:
                str_hair = selected_id;
                [hairTxt setText:selected_name];
                break;
            case 4:
                str_area = selected_id;
                [areaTxt setText:selected_name];
                break;
            case 5:
                str_sex = selected_id;
                [sexTxt setText:selected_name];
                break;
            case 6:
                str_size = selected_id;
                [sizeTxt setText:selected_name];
                break;
           
                
            default:
                
                break;
        }
   /* }else{
        str_quot = selected_name;
        [msgTxt setText:selected_name];
    }*/

}



- (IBAction)btnDoneDate:(id)sender
{
    
   // [dateView setHidden:YES];
    
    [self.view endEditing:YES];
    
    NSDate *selDate = datePicker.date;
    
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:@"yyyy/MM/dd"];
   
    NSString *selDateString = [dateFormater stringFromDate:selDate];
    
    if ([selDate compare:nowDate]==NSOrderedDescending) {
        // 打印结果
       [Utility alertWithTitle:@"訊息" message:@"選擇日期不可超過今天日期"];
        
    }else{
        [dateTxt setText:selDateString];
    }

}

- (IBAction)btndel1:(id)sender
{
	[images removeObjectAtIndex:0];
    [imageNames removeObjectAtIndex:0];
    [self updataPhoto];
}
- (IBAction)btndel2:(id)sender
{
    [images removeObjectAtIndex:1];
    [imageNames removeObjectAtIndex:1];
    [self updataPhoto];
}
- (IBAction)btndel3:(id)sender
{
    [images removeObjectAtIndex:2];
    [imageNames removeObjectAtIndex:2];
    [self updataPhoto];
}
- (IBAction)btndel4:(id)sender
{
    [images removeObjectAtIndex:3];
    [imageNames removeObjectAtIndex:3];
    [self updataPhoto];
}
- (IBAction)btndel5:(id)sender
{
    [images removeObjectAtIndex:4];
    [imageNames removeObjectAtIndex:4];
    [self updataPhoto];
}
- (IBAction)btnaddPhoto:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"選擇相片" message:@"" delegate:self cancelButtonTitle:@"關閉" otherButtonTitles:@"相冊取出", @"相機取出", nil];
    
    alert.tag = 1;
    [alert show];
 
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
     UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    ReportMainViewController *mainCenterVC = [[ReportMainViewController alloc] initWithNibName:@"ReportMainViewController" bundle:nil];
    UINavigationController *mainVCNavigationController = [[UINavigationController alloc] initWithRootViewController:mainCenterVC];
   
    switch (alertView.tag)
    {
            //使用者按的 alertView 是要用來連線的
            
        case 0:
        {
            
            switch (buttonIndex) {
                case 0:{
                    [mainVCNavigationController.navigationBar setHidden:TRUE];
                    [self presentViewController:mainVCNavigationController animated:NO completion:nil];
                    break;
                }
                    
                default:
                    break;
            }
            
            break;
            
        }

        case 1:
        {
            switch (buttonIndex) {
                case 0:
                    //NSLog(@"Cancel Button Pressed");
                    break;
                case 1:
                    
                    // 設定相片來源來自於手機內的相本
                    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    imagePicker.delegate = self;
                    // 開啓相片瀏覽界面
                    [self presentViewController:imagePicker animated:YES completion:nil];
                    
                    break;
                case 2:
                    // 先檢查裝置是否配備相機
                    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                        // 設定相片來源為裝置上的相機
                        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                        imagePicker.delegate = self;
                        // 開啓相片瀏覽界面
                        [self presentViewController:imagePicker animated:YES completion:nil];
                    }
                    break;
                default:
                    break;
            }
            
            
            break;
        }
      
            
        default:
            break;
    }
    
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 取得使用者拍攝的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    // 存檔
   // UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
   
    
    if (photoCount<5) {
        [imgPhotoAry[photoCount] setImage:image];
        
      //  NSString *urlUploadPhoto = [photourl_type objectAtIndex:page_type];
        
    
        
        NSString *urlUploadPhoto = [NSString stringWithFormat:@"%@Query/BulletinPic.ashx",NSLocalizedString(@"api_ip", @"")];
        
      //  NSString *urlUploadPhoto = @"http://mobile.ihaoyu.com.tw/AmlApp/Query/BulletinPic.ashx";
        
        
        //NSData *data = UIImagePNGRepresentation(image);
        
       /* [imgPhotoViewAry[photoCount] setHidden:NO];
        photoCount++;
        [images addObject:image];*/
        [self httpUpload:urlUploadPhoto Image:image];
    }else{
         [Utility alertWithTitle:@"訊息" message:@"上傳限制五張相片！！"];
    }
        // 關閉拍照程式
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // 當使用者按下取消按鈕後關閉拍照程式
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)httpUpload:(NSString *)urlString Image:(UIImage *)image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.2f);
   
    NSURL *url = [[NSURL alloc]initWithString:urlString];
    
    //以表格形式的请求对象
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc]initWithURL:url];
    
    request.delegate =self;
    
    request.requestMethod = @"POST";//设置请求方式
    //添加请求内容
   [request addData:imageData withFileName:@"image.jpg" andContentType:@"image/jpeg" forKey:@""];
    
    //开始异步请求
    //[request startAsynchronous];
    [request startSynchronous];
    
    
    NSError *error = [request error];
    
    
    if (!error)
    {
        NSString *response = [request responseString];
       // NSLog(@"upload response: %@", response);
        // Convert to JSON object:
        NSData *jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
        NSError *myError = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:&myError];
  
        for (NSDictionary *p in dict) {
           [imageNames addObject:[p objectForKey:@"name"]];
            //NSLog(@"upload response: %@", [p objectForKey:@"name"]);
        }
       
        [images addObject:image];
        [imgPhotoViewAry[photoCount] setHidden:NO];
         photoCount++;
    }
    else
    {
        NSLog(@"Error -- %@", error);
    }
}

- (void)updataPhoto {
    
    for(int i=0;i<5;i++){
        photoCount=images.count;
        if(i<images.count){
             [imgPhotoViewAry[i] setHidden:NO];
            if([[images objectAtIndex:i] isKindOfClass:[UIImage class]]){
                [imgPhotoAry[i] setImage:[images objectAtIndex:i]];
            }else{
            
            
            NSString *img_url = [NSString stringWithFormat:@"%@Upload/Pic/%@",NSLocalizedString(@"api_ip", @""),[imageNames objectAtIndex:i]];
            UIImage *urlimage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:img_url]]];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                  
                    dispatch_async(dispatch_get_main_queue(), ^{
                        // Update the UI
                        [imgPhotoAry[i] setImage:urlimage];
                    });
                });
             
                
            }
        }else{
            [imgPhotoViewAry[i] setHidden:YES];
        }
    }
}




- (IBAction)btnSend:(id)sender
{
    
    str_pic =@"[";
    
 for(int i=0;i<imageNames.count;i++){
    if(i==0){
                       
    str_pic = [str_pic stringByAppendingString:[[NSString alloc] initWithFormat:@"'%@'",[imageNames objectAtIndex:i]]];
    }else{
    str_pic = [str_pic stringByAppendingString:[[NSString alloc] initWithFormat:@",'%@'",[imageNames objectAtIndex:i]]];
    }
}
     str_pic = [str_pic stringByAppendingString:@"]"];
    
    
    

    
    str_feature = featureTxt.text;
    //str_size  = sizeTxt.text;
    str_health = healthTxt.text;
    str_chipNo = chipNoTxt.text;
 
    if ([str_x_name_o isEqualToString:@""]) {
        
        str_x_name = x_nameTxt.text;//被檢舉人姓名 (非自然人=>負責人姓名)
        str_x_idno = @"";//被檢舉人身分證 (非自然人=>負責人身分證)
        str_x_phone = @"";//被檢舉人電話 (非自然人=>連絡電話)
        str_x_email = @"";
        str_x_addr = x_idnoTxt.text;//被檢舉人地址 (非自然人=>營業地址)
        str_x_name_o = @"";//非自然人=>公司組織名稱 (空白=自然人)
        str_x_idno_o = @"";//非自然人=>公司組織統一編號
        
        
    }else{
        
        str_x_name = x_mainnameTxt.text;
        str_x_idno = @"";
        str_x_phone = x_phoneTxt.text;
        str_x_email = @"";
        str_x_addr = x_addrTxt.text;
        str_x_name_o = x_name_oTxt.text;
        str_x_idno_o = x_idno_oTxt.text;
        
    }
    
   
    str_youtube=youtubeTxt.text;
    str_location =locationTxt.text;
    str_gps =gpsTxt.text;
    str_date =dateTxt.text;
    
     str_story = storyTxt.text;
     str_remark = remarkTxt.text;
    
    
    if ([[NSString stringWithFormat:@"%@",str_type] isEqualToString:@""]) {
        [Utility alertWithTitle:@"訊息" message:@"動物種類未填入"];
    }else if([[NSString stringWithFormat:@"%@",str_breed] isEqualToString:@""]){
        [Utility alertWithTitle:@"訊息" message:@"品種未填入"];
    }else if([[NSString stringWithFormat:@"%@",str_hair] isEqualToString:@""]){
        [Utility alertWithTitle:@"訊息" message:@"毛色未填入"];
     }else if([[NSString stringWithFormat:@"%@",str_report_msg]  isEqualToString:@""]){
        [Utility alertWithTitle:@"訊息" message:@"違法事實未填入"];
     }else if([[NSString stringWithFormat:@"%@",str_date]  isEqualToString:@""]){
        [Utility alertWithTitle:@"訊息" message:@"時間未填入"];
     }else if([[NSString stringWithFormat:@"%@",str_area]  isEqualToString:@""]){
        [Utility alertWithTitle:@"訊息" message:@"行政區未填入"];
     }else if([[NSString stringWithFormat:@"%@",str_location]  isEqualToString:@""]){
         [Utility alertWithTitle:@"訊息" message:@"地點未填入"];
     }else if([[NSString stringWithFormat:@"%@",str_story]  isEqualToString:@""]){
         [Utility alertWithTitle:@"訊息" message:@"情節未填入"];
     }else if([[NSString stringWithFormat:@"%@",str_gps]  isEqualToString:@""]){
         [Utility alertWithTitle:@"訊息" message:@"定位資料未填入"];
     }else if([[NSString stringWithFormat:@"%@",str_youtube]   isEqualToString:@""]){
         [Utility alertWithTitle:@"訊息" message:@"影音未填入"];
     }else if([[NSString stringWithFormat:@"%@",str_pic]  isEqualToString:@""]){
         [Utility alertWithTitle:@"訊息" message:@"相片未填入"];
     }else {
                [self connectHttp];
       
    }
    
    
   
    
}
- (IBAction)btnBack:(id)sender;
{
   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}


//內建的函式回傳UIPicker共有幾組選項
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
//內建的函式回傳UIPicker每組選項的項目數目
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [sellist count];
  
    /*//第一組選項由0開始
    switch (component) {
        case 0:
            return [plurk count];
            break;
        case 1:
            return [plurk count];
            break;
            
            //如果有一組以上的選項就在這裡以component的值來區分（以本程式碼為例default:永遠不可能被執行
        default:
            return 0;
            break;
    }*/
}
//內建函式印出字串在Picker上以免出現"?"
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [sellist objectAtIndex:row];

  
}
//選擇UIPickView中的項目時會出發的內建函式
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    plurkLabel.text = [NSString stringWithFormat:@"%@ :", [sellist objectAtIndex:row]];
}




//http連線接收

-(void)connectHttp{
    
    if(receivedData==nil)
    {
        receivedData = [[NSMutableData alloc] init];
    }
    
    [receivedData setLength:0];
    
    
    NSString *urlApi =  [NSString stringWithFormat:@"%@Query/ReportAdd.ashx",NSLocalizedString(@"api_ip", @"")];
    
    NSURL *aUrl = [NSURL URLWithString:urlApi];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
   
    NSString *httpBodyString=@"";
    
    
    //By Richard 2018.02.09
    //httpBodyString=[NSString stringWithFormat:@"pdata={'r_type':%@,'a_type':'%@','b_type':'%@','p_type':'%@','h_type':'%@','s_type':'%@','z_type':'%@','r_name':'%@','r_idno':'%@','r_phone':'%@','r_sex':'%@','r_email':'%@','r_addr':'%@','r_name_o':'%@','r_idno_o':'%@','x_name':'%@','x_idno':'%@','x_phone':'%@','x_email':'%@','x_addr':'%@','x_name_o':'%@','x_idno_o':'%@','place':'%@','memo':'%@','images':%@,'video':'%@','gps':'%@','chip':'%@','character':'%@','health':'%@'}",str_report_msg,str_type,str_breed,str_area,str_hair,str_sex,str_size,str_r_name,str_r_idno,str_r_phone,str_r_sex,str_r_email,str_r_addr,str_r_name_o,str_r_idno_o,str_x_name,str_x_idno,str_x_phone,str_x_email,str_x_addr,str_x_name_o,str_x_idno_o,str_location,str_story,str_pic,str_youtube,str_gps,str_chipNo,str_feature,str_health];
    
    str_r_name = [Word_AES encryptAESData:str_r_name];
    str_r_idno = [Word_AES encryptAESData:str_r_idno];
    str_r_phone = [Word_AES encryptAESData:str_r_phone];
    str_r_email = [Word_AES encryptAESData:str_r_email];
    str_r_addr = [Word_AES encryptAESData:str_r_addr];
    
    str_r_name_o = [Word_AES encryptAESData:str_r_name_o];
    str_r_idno_o = [Word_AES encryptAESData:str_r_idno_o];
    
    str_x_name = [Word_AES encryptAESData:str_x_name];
    str_x_idno = [Word_AES encryptAESData:str_x_idno];
    str_x_phone = [Word_AES encryptAESData:str_x_phone];
    str_x_email = [Word_AES encryptAESData:str_x_email];
    str_x_addr = [Word_AES encryptAESData:str_x_addr];
    
    str_x_name_o = [Word_AES encryptAESData:str_x_name_o];
    str_x_idno_o = [Word_AES encryptAESData:str_x_idno_o];
    
    str_location = [Word_AES encryptAESData:str_location];
    
    str_story = [Word_AES encryptAESData:str_story];
    
    str_youtube = [Word_AES encryptAESData:str_youtube];
    str_gps = [Word_AES encryptAESData:str_gps];
    str_chipNo = [Word_AES encryptAESData:str_chipNo];
    str_feature = [Word_AES encryptAESData:str_feature];
    str_health = [Word_AES encryptAESData:str_health];
    
    httpBodyString=[NSString stringWithFormat:@"pdata={'r_type':%@,'a_type':'%@','b_type':'%@','p_type':'%@','h_type':'%@','s_type':'%@','z_type':'%@','r_name':'%@','r_idno':'%@','r_phone':'%@','r_sex':'%@','r_email':'%@','r_addr':'%@','r_name_o':'%@','r_idno_o':'%@','x_name':'%@','x_idno':'%@','x_phone':'%@','x_email':'%@','x_addr':'%@','x_name_o':'%@','x_idno_o':'%@','place':'%@','memo':'%@','images':%@,'video':'%@','gps':'%@','chip':'%@','character':'%@','health':'%@'}",str_report_msg,str_type,str_breed,str_area,str_hair,str_sex,str_size,str_r_name,str_r_idno,str_r_phone,str_r_sex,str_r_email,str_r_addr,str_r_name_o,str_r_idno_o,str_x_name,str_x_idno,str_x_phone,str_x_email,str_x_addr,str_x_name_o,str_x_idno_o,str_location,str_story,str_pic,str_youtube,str_gps,str_chipNo,str_feature,str_health];
    
  
   [request setHTTPBody:[httpBodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
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
    
    
    [Utility alertWithDialog:@"訊息" message:@"連結失敗!! 請重新送出!!"];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)_connection {
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    
    
    NSString *strMessage = [res objectForKey:@"Message"];

    NSNumber * isSuccessNumber = (NSNumber *)[res objectForKey: @"Success"];
    //顯示取得資料
    /*for (id key in res) {
        NSLog(@"key: %@, value: %@ \n", key, [res objectForKey:key]);
    }*/
    
    
    if([isSuccessNumber boolValue] == YES)
    {
       
   // strMessage=@"上傳成功";
        
        NSArray *MessageAry = [strMessage componentsSeparatedByString:@","];
        
    
        strMessage = [NSString stringWithFormat:@"案件碼:%@\n驗證碼:%@\n\n請自行紀錄案件碼與驗證碼,方便查詢案件狀態",[MessageAry objectAtIndex:0],[MessageAry objectAtIndex:1]];
        
        
        UIAlertView *alert_dialog = [[UIAlertView alloc]  initWithTitle:@"訊息" message:strMessage delegate:self cancelButtonTitle: @"關閉"
            otherButtonTitles:nil, nil];
        
        
        alert_dialog.tag = 0;
        [alert_dialog show];
        
        
        
  
        
        // [self.navigationController pushViewController:sideMenuController animated:YES];
    }else{
    
    [Utility alertWithDialog:@"訊息" message:strMessage];
    
    }

}


-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

//縮鍵盤
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
