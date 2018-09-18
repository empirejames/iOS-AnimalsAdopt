//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "MemberUploadViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "MemberCenterViewController.h"
#import "UserPreferences.h"
#import "Utility.h"
#import "ASIFormDataRequest.h"
#import <CoreLocation/CoreLocation.h>
#import "EditEntity.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Word_AES.h"

@interface MemberUploadViewController (){
    
    NSMutableData *receivedData;
    
    NSURLConnection *connection;
    
    CLLocationManager *locationManager;
    
    CLGeocoder *geocoder;
    
    IBOutlet UIScrollView *list_scrollView;
    
    IBOutlet UIScrollView *photo_scrollView;
    
    IBOutlet UITextField *codeTxt;
    IBOutlet UITextField *chipNoTxt;
    IBOutlet UITextField *dogNoTxt;
    IBOutlet UITextField *youtubeTxt;
    IBOutlet UITextField *locationTxt;
    IBOutlet UITextField *gpsTxt;
    IBOutlet UITextField *dateTxt;
    
    IBOutlet UITextField *typeTxt;
    IBOutlet UITextField *sexTxt;
    IBOutlet UITextField *hairTxt;
    IBOutlet UITextField *ageTxt;
    IBOutlet UITextField *sizeTxt;
    IBOutlet UITextField *areaTxt;
    IBOutlet UITextField *msgTxt;
    IBOutlet UITextField *breedTxt;
   
    IBOutlet UILabel *plurkLabel;
    IBOutlet UILabel *title_label;
    IBOutlet UILabel *location_label;
    IBOutlet UILabel *date_label;
    IBOutlet UILabel *drsc_label;
    NSArray *sellist,*msglist;
  
    
    
    IBOutlet UIView *msgView;
    IBOutlet UIView *featureView;
    IBOutlet UITextField *featureTxt;
    
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
    
    UIPickerView *selPicker;
    UIDatePicker *datePicker;
    NSMutableArray *images;
    NSMutableArray *imageNames;
    NSInteger photoCount;
    
    NSArray *SelAry[6];
    
    int selItem;
    
    NSMutableArray *selnameAry;
    
    NSMutableArray *selIdAry;
    
    NSString *str_pic,*str_type,*str_sex,*str_area,*str_age,*str_size,*str_hair,*str_breed,*str_tel,*str_email,*str_drsc,*str_quot,*str_location,*str_click,*str_date,*str_chipNo,*str_dogNo,*str_youtube,*str_gps,*str_member,*str_name,*str_editId;
    
    NSDate *nowDate ;
    
    NSArray  *url_type,*photourl_type,*title_type,*dateTxt_type,*locationTxt_type,*drscTxt_type;
}

@end

@implementation MemberUploadViewController
@synthesize page_type;
@synthesize dataAry;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self startStandardUpdates];
    
    //By Richard 2018.02.09
    UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"您同意將相關資料，傳送給台北市動物保護處嗎?" message:@"" delegate:self cancelButtonTitle:@"不同意" otherButtonTitles:@"同意", nil];
    
    alertV.tag = 0;
    
    [alertV show];

    
    str_pic=@"";str_type=@"";str_sex=@"";
    str_area=@"";str_age=@"";str_size=@"";
    str_hair=@"";str_breed=@"";str_tel=@"";
    str_email=@"";str_drsc=@"";str_quot=@"";str_location=@"";
    str_click=@"0";str_date=@"";str_chipNo=@"";
    str_dogNo=@"";str_youtube=@"";str_gps=@"";
    str_member=@"";str_name=@"";str_editId=@"";
    
  
    url_type = [[NSArray alloc] initWithObjects:
                  [NSString stringWithFormat:@"%@Query/MissingAdd.ashx",NSLocalizedString(@"api_ip", @"")],
                  [NSString stringWithFormat:@"%@Query/BulletinAdd.ashx",NSLocalizedString(@"api_ip", @"")],
                [NSString stringWithFormat:@"%@Query/MissingAdd.ashx?type=2",NSLocalizedString(@"api_ip", @"")],
                 [NSString stringWithFormat:@"%@Query/BulletinAdd.ashx?type=2",NSLocalizedString(@"api_ip", @"")],
                [NSString stringWithFormat:@"%@Query/BulletinAdd.ashx",NSLocalizedString(@"api_ip", @"")],nil];
    
    photourl_type = [[NSArray alloc] initWithObjects:
                     [NSString stringWithFormat:@"%@Query/MissingPic.ashx",NSLocalizedString(@"api_ip", @"")],
                    [NSString stringWithFormat:@"%@Query/BulletinPic.ashx",NSLocalizedString(@"api_ip", @"")],
                     [NSString stringWithFormat:@"%@Query/MissingPic.ashx",NSLocalizedString(@"api_ip", @"")],
                     [NSString stringWithFormat:@"%@Query/BulletinPic.ashx",NSLocalizedString(@"api_ip", @"")],
                     [NSString stringWithFormat:@"%@Query/BulletinPic.ashx",NSLocalizedString(@"api_ip", @"")],nil];
    
    title_type = [[NSArray alloc] initWithObjects:
                  @"新增協尋",
                  @"線上通報",
                  @"修改協尋",
                  @"修改線上通報",
                  @"線上通報",nil];
    
    dateTxt_type = [[NSArray alloc] initWithObjects:
                    @"失蹤日期：",
                    @"通報日期：",
                    @"失蹤日期：",
                    @"通報日期：",
                    @"通報日期：",nil];
    
    locationTxt_type = [[NSArray alloc] initWithObjects:
                    @"失蹤地點：",
                    @"通報地點：",
                    @"失蹤地點：",
                    @"通報地點：",
                    @"通報地點：",nil];
    
    drscTxt_type = [[NSArray alloc] initWithObjects:
                        @"寵物描述：",
                        @"寵物特徵：",
                        @"寵物描述：",
                        @"寵物特徵：",
                        @"寵物特徵：",nil];
    
     [title_label setText:[title_type objectAtIndex:page_type]];
     [date_label setText:[dateTxt_type objectAtIndex:page_type]];
     [location_label setText:[locationTxt_type objectAtIndex:page_type]];
     [drsc_label setText:[drscTxt_type objectAtIndex:page_type]];
    
    CLLocation *currentLocation = locationManager.location ;
    
    if (currentLocation != nil)
    {//取得經緯度資訊，並組合成字串
        NSString * gps_str = [[NSString alloc] initWithFormat:@"%f,%f"
                          , currentLocation.coordinate.latitude
                          , currentLocation.coordinate.longitude];
        [gpsTxt setText:gps_str];
    }
    
    selnameAry = [UserPreferences getArrayForKey:@"SelNameSet"];
    selIdAry = [UserPreferences getArrayForKey:@"SelIdSet"];
    
    selItem = 0;
    
    if (page_type==1||page_type==3||page_type==4) {
         [msgView setHidden:YES];
    }
    

    nowDate = [[NSDate alloc] init];
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:@"yyyy/MM/dd"];
    NSString *nowDateString = [dateFormater stringFromDate:nowDate];
    [dateTxt setText:nowDateString];
  

    [typeTxt setTag:0];
    [sexTxt setTag:1];
    [hairTxt setTag:2];
    [ageTxt setTag:3];
    [sizeTxt setTag:4];
    [areaTxt setTag:5];
    [breedTxt setTag:6];
    [msgTxt setTag:7];
    
    //[dateTxt setTag:7];
    
    photoCount = 0;
    
    images = [[NSMutableArray alloc] init];
    
    imageNames = [[NSMutableArray alloc] init];
    
    imgPhotoAry = [[NSMutableArray alloc]initWithObjects:photo1,photo2,photo3,photo4,photo5,nil];
    
    imgPhotoViewAry = [[NSMutableArray alloc]initWithObjects:photoView1,photoView2,photoView3,photoView4,photoView5,nil];
    
    
    if (page_type==2||page_type==3||page_type==4) {
        
       
    if ([dataAry objectAtIndex:1] != [NSNull null]) {
        
        [codeTxt setText:[dataAry objectAtIndex:1]];
        
       // [typeBtnView setTitle: [dataAry objectAtIndex:2] forState:UIControlStateNormal];
        [typeTxt setText:[dataAry objectAtIndex:2]];
        
        NSMutableDictionary *dictType =[selIdAry objectAtIndex:0];
        
        str_type = [dictType objectForKey:[dataAry objectAtIndex:2]];
       
        
        [breedTxt setText:[dataAry objectAtIndex:16]];
        
        NSMutableDictionary *dictBreed =[selIdAry objectAtIndex:6];
        
        str_breed = [dictBreed objectForKey:[dataAry objectAtIndex:16]];
        
        [sexTxt setText: [dataAry objectAtIndex:3]];
        
        NSMutableDictionary *dictSex =[selIdAry objectAtIndex:1];
        
        str_sex = [dictSex objectForKey:[dataAry objectAtIndex:3]];
        
        [hairTxt setText: [dataAry objectAtIndex:4]];
        
        NSMutableDictionary *dictHair =[selIdAry objectAtIndex:2];
        
        str_hair = [dictHair objectForKey:[dataAry objectAtIndex:4]];
        
        [ageTxt setText: [dataAry objectAtIndex:5]];
        
        NSMutableDictionary *dictAge =[selIdAry objectAtIndex:3];
        str_age = [dictAge objectForKey:[dataAry objectAtIndex:5]];
        [sizeTxt setText: [dataAry objectAtIndex:6]];
        NSMutableDictionary *dictSize =[selIdAry objectAtIndex:4];
        str_size = [dictSize objectForKey:[dataAry objectAtIndex:6]];
        [areaTxt setText: [dataAry objectAtIndex:7]];
        NSMutableDictionary *dictArea =[selIdAry objectAtIndex:5];
        str_area = [dictArea objectForKey:[dataAry objectAtIndex:7]];
        [chipNoTxt setText:[dataAry objectAtIndex:8]];
        [dogNoTxt setText:[dataAry objectAtIndex:9]];
      
        
        if (page_type!=4) {
            str_drsc =[dataAry objectAtIndex:10];
            [featureTxt setText:[dataAry objectAtIndex:10]];
            //語錄
            if(page_type==2){
            [msgTxt setText:[dataAry objectAtIndex:17]];
            NSMutableDictionary *dictMsg=[selIdAry objectAtIndex:7];
            str_quot = [dictMsg objectForKey:[dataAry objectAtIndex:17]];
            }
            
            //if (page_type==2) {
            //  [msgBtnView setTitle: [dataAry objectAtIndex:10] forState:UIControlStateNormal];
            [locationTxt setText:[dataAry objectAtIndex:11]];
            [youtubeTxt setText:[dataAry objectAtIndex:12]];
            [gpsTxt setText:[dataAry objectAtIndex:13]];
            [dateTxt setText:[dataAry objectAtIndex:14]];
            
            
            str_editId =[dataAry objectAtIndex:15];
            
            if ([dataAry objectAtIndex:0] != [NSNull null]) {
                NSArray *imgName = [dataAry objectAtIndex:0];
                images = [(NSArray*)imgName mutableCopy];
                imageNames = [(NSArray*)imgName mutableCopy];
                NSLog(@"%d",images.count);
                if(images.count!=0){
                    if (![[images objectAtIndex:0] isEqualToString:@""]) {
                        [self updataPhoto];
                    }
                }
            }

        }
        
        
    }
}
    

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
    
    [list_scrollView setContentSize:CGSizeMake(screenWidth,820)];
    
    [list_scrollView setPagingEnabled:NO];
    [list_scrollView setBounces:NO];
    //[scrollView setBackgroundColor:[UIColor blackColor]];
    
    [list_scrollView setShowsVerticalScrollIndicator:NO];
    [list_scrollView setShowsHorizontalScrollIndicator:NO];
    
    [list_scrollView setDelegate:self];
    
    
    
   

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
    
    switch (textField.tag) {
        case 0:
            sellist = [selnameAry objectAtIndex:0];
            selItem = 0;
            [selPicker reloadAllComponents];
            typeTxt.inputView = selPicker;
            typeTxt.inputAccessoryView = toolBar;
            break;
        case 1:
            sellist = [selnameAry objectAtIndex:1];
            selItem = 1;
            [selPicker reloadAllComponents];
            sexTxt.inputView = selPicker;
            sexTxt.inputAccessoryView = toolBar;
            break;
        case 2:
            sellist = [selnameAry objectAtIndex:2];
            selItem = 2;
            [selPicker reloadAllComponents];
            hairTxt.inputView = selPicker;
            hairTxt.inputAccessoryView = toolBar;
            break;
        case 3:
            sellist = [selnameAry objectAtIndex:3];
            selItem = 3;
            [selPicker reloadAllComponents];
            ageTxt.inputView = selPicker;
            ageTxt.inputAccessoryView = toolBar;
            break;
        case 4:
            sellist = [selnameAry objectAtIndex:4];
            selItem = 4;
            [selPicker reloadAllComponents];
            sizeTxt.inputView = selPicker;
            sizeTxt.inputAccessoryView = toolBar;
            break;
        case 5:
            sellist = [selnameAry objectAtIndex:5];
            selItem = 5;
            [selPicker reloadAllComponents];
            areaTxt.inputView = selPicker;
            areaTxt.inputAccessoryView = toolBar;
            break;
        case 6:
            sellist = [selnameAry objectAtIndex:6];
            selItem = 6;
            [selPicker reloadAllComponents];
            breedTxt.inputView = selPicker;
            breedTxt.inputAccessoryView = toolBar;
            break;
        case 7:
            sellist = [selnameAry objectAtIndex:7];
            selItem = 7;
            [selPicker reloadAllComponents];
            msgTxt.inputView = selPicker;
            msgTxt.inputAccessoryView = toolBar;
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
        NSMutableDictionary *dictId =[selIdAry objectAtIndex:selItem];
        
        NSString * selected_id = [dictId objectForKey:selected_name];
        
        switch (selItem) {
            case 0:
                str_type = selected_id;
                //[typeBtnView setTitle:selected_name forState:UIControlStateNormal];
                
                [typeTxt setText:selected_name];
                break;
            case 1:
                str_sex = selected_id;
                [sexTxt setText:selected_name];
                break;
            case 2:
                str_hair = selected_id;
                [hairTxt setText:selected_name];
                break;
            case 3:
                str_age = selected_id;
                [ageTxt setText:selected_name];
                break;
            case 4:
                str_size = selected_id;
                [sizeTxt setText:selected_name];
                break;
            case 5:
                str_area = selected_id;
                [areaTxt setText:selected_name];
                break;
            case 6:
                str_breed = selected_id;
                [breedTxt setText:selected_name];
                break;
            case 7:
                str_quot = selected_id;
                [msgTxt setText:selected_name];
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
    
    //By Richard 2018.02.09
    switch (alertView.tag) {
        case 0:
            switch (buttonIndex) {
                case 0:
                    
                    //NSLog(@"Cancel Button Pressed");
                    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                    break;
                case 1:
                    //[self.navigationController dismissViewControllerAnimated:NO completion:nil];
                    break;
                
            }
            break;
        case 1:
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
                
            }
            break;
            
        default:
            break;
    }
    
    //By Richard 2018.02.09
    /*
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
    }*/
    
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // 取得使用者拍攝的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
   
    // 存檔
    //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
   
    
    if (photoCount < 5) {
        
        [imgPhotoAry[photoCount] setImage:image];
        
        NSString *urlUploadPhoto = [photourl_type objectAtIndex:page_type];
        
        //NSString *urlUploadPhoto = @"http://tas.taipei/AmlApp/Query/BulletinPic.ashx";
        
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
        
        photoCount = images.count;
        
        if(i < images.count){
            
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
    
    str_name = codeTxt.text;
    
    str_chipNo = chipNoTxt.text;
    
    str_dogNo = dogNoTxt.text;
    
    str_youtube = youtubeTxt.text;
    
    str_location = locationTxt.text;
    
    str_gps = gpsTxt.text;
    
    str_date = dateTxt.text;
    
    str_drsc = featureTxt.text;
    
    str_member = [UserPreferences getStringForKey:PREF_TOKEN];
    
    if ([[NSString stringWithFormat:@"%@",str_type] isEqualToString:@""]) {
        
        [Utility alertWithTitle:@"訊息" message:@"種別未填入"];
        
    }else if([[NSString stringWithFormat:@"%@",str_sex]  isEqualToString:@""]){
        
        [Utility alertWithTitle:@"訊息" message:@"性別未填入"];
        
    }else if([[NSString stringWithFormat:@"%@",str_hair]   isEqualToString:@""]){
        
        [Utility alertWithTitle:@"訊息" message:@"毛色未填入"];
        
     }else if([[NSString stringWithFormat:@"%@",str_age]   isEqualToString:@""]){
         
        [Utility alertWithTitle:@"訊息" message:@"年齡未填入"];
         
     }else if([[NSString stringWithFormat:@"%@",str_size]   isEqualToString:@""]){
         
        [Utility alertWithTitle:@"訊息" message:@"體型未填入"];
         
     }else if([[NSString stringWithFormat:@"%@",str_area]   isEqualToString:@""]){
         
        [Utility alertWithTitle:@"訊息" message:@"行政區未填入"];
         
     }else if([[NSString stringWithFormat:@"%@",str_location]  isEqualToString:@""]){
         
        if(page_type==0||page_type==2){
            
            [Utility alertWithTitle:@"訊息" message:@"失蹤地點未填入"];
            
        }else{
            
            [Utility alertWithTitle:@"訊息" message:@"通報地點未填入"];
        }
    }else if([str_drsc isEqualToString:@""]){
        
          if(page_type==0||page_type==2){
              
               [Utility alertWithTitle:@"訊息" message:@"寵物描述未填入"];
              
                    }else{
                        
                 [Utility alertWithTitle:@"訊息" message:@"寵物特徵未填入"];
                        
                    }
        
    }else  if(page_type==0||page_type==2){
        
        if([str_name isEqualToString:@""]){
            
            [Utility alertWithTitle:@"訊息" message:@"姓名未填入"];
            
        }else if([[NSString stringWithFormat:@"%@",str_chipNo]   isEqualToString:@""]){
            
            [Utility alertWithTitle:@"訊息" message:@"晶片號碼未填入"];
            
        }else if([[NSString stringWithFormat:@"%@",str_dogNo]  isEqualToString:@""]){
            
            [Utility alertWithTitle:@"訊息" message:@"狂犬病牌證號碼未填入"];
            
        }else if([[NSString stringWithFormat:@"%@",str_quot] isEqualToString:@""]){
            
            [Utility alertWithTitle:@"訊息" message:@"協尋語錄未填入"];
            
        }else{
            
            [self connectHttp];
            
        }
    }else{
        
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

    /*switch (component) {
        case 0:
            return [plurk objectAtIndex:row];
            break;
        case 1:
            return [plurk objectAtIndex:row];
            break;
            
            //如果有一組以上的選項就在這裡以component的值來區分（以本程式碼為例default:永遠不可能被執行）
        default:
            return @"Error";
            break;
    }*/
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
    

    NSString *urlApi = [url_type objectAtIndex:page_type];
    
    
    NSURL *aUrl = [NSURL URLWithString:urlApi];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:aUrl
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
   
    NSString *httpBodyString=@"";
    
    if (page_type==0) {
        
        //httpBodyString=[NSString stringWithFormat:@"pdata={'pic':%@,'type':'%@','sex':'%@','area':'%@','age':'%@','size':'%@','hair':'%@','breed':'%@','quot':'%@','tel':'%@','email':'%@','drsc':'%@','location':'%@','click':'%@','date':'%@','chipNo':'%@','dogNo':'%@','youtube':'%@','gps':'%@','member':'%@','name':'%@'}",str_pic,str_type,str_sex,str_area,str_age,str_size,str_hair,str_breed,str_quot,str_tel,str_email,str_drsc,str_location,str_click,str_date,str_chipNo,str_dogNo,str_youtube,str_gps,str_member,str_name];
        
        //By Richard 2018.02.08
        
        str_tel = [Word_AES encryptAESData:str_tel];
        str_email = [Word_AES encryptAESData:str_email];
        str_drsc = [Word_AES encryptAESData:str_drsc];
        str_location = [Word_AES encryptAESData:str_location];
        str_date = [Word_AES encryptAESData:str_date];
        str_chipNo = [Word_AES encryptAESData:str_chipNo];
        str_dogNo = [Word_AES encryptAESData:str_dogNo];
        str_youtube = [Word_AES encryptAESData:str_youtube];
        str_gps = [Word_AES encryptAESData:str_gps];
        str_member = [Word_AES encryptAESData:str_member];
        str_name = [Word_AES encryptAESData:str_name];
        
        httpBodyString=[NSString stringWithFormat:@"pdata={'pic':%@,'type':'%@','sex':'%@','area':'%@','age':'%@','size':'%@','hair':'%@','breed':'%@','quot':'%@','tel':'%@','email':'%@','drsc':'%@','location':'%@','click':'%@','date':'%@','chipNo':'%@','dogNo':'%@','youtube':'%@','gps':'%@','member':'%@','name':'%@'}",str_pic,str_type,str_sex,str_area,str_age,str_size,str_hair,str_breed,str_quot,str_tel,str_email,str_drsc,str_location,str_click,str_date,str_chipNo,str_dogNo,str_youtube,str_gps,str_member,str_name];
        
        
    }else if (page_type==1) {
        
        //httpBodyString=[NSString stringWithFormat:@"pdata={'pic':%@,'type':'%@','sex':'%@','area':'%@','age':'%@','size':'%@','hair':'%@','breed':'%@','tel':'%@','email':'%@','drsc':'%@','location':'%@','click':'%@','date':'%@','chipNo':'%@','dogNo':'%@','youtube':'%@','gps':'%@','member':'%@','name':'%@'}",str_pic,str_type,str_sex,str_area,str_age,str_size,str_hair,str_breed,str_tel,str_email,str_drsc,str_location,str_click,str_date,str_chipNo,str_dogNo,str_youtube,str_gps,str_member,str_name];
        
        
        //By Richard 2018.02.08
        
        str_tel = [Word_AES encryptAESData:str_tel];
        str_email = [Word_AES encryptAESData:str_email];
        str_drsc = [Word_AES encryptAESData:str_drsc];
        str_location = [Word_AES encryptAESData:str_location];
        str_date = [Word_AES encryptAESData:str_date];
        str_chipNo = [Word_AES encryptAESData:str_chipNo];
        str_dogNo = [Word_AES encryptAESData:str_dogNo];
        str_youtube = [Word_AES encryptAESData:str_youtube];
        str_gps = [Word_AES encryptAESData:str_gps];
        str_member = [Word_AES encryptAESData:str_member];
        str_name = [Word_AES encryptAESData:str_name];
        
        httpBodyString=[NSString stringWithFormat:@"pdata={'pic':%@,'type':'%@','sex':'%@','area':'%@','age':'%@','size':'%@','hair':'%@','breed':'%@','tel':'%@','email':'%@','drsc':'%@','location':'%@','click':'%@','date':'%@','chipNo':'%@','dogNo':'%@','youtube':'%@','gps':'%@','member':'%@','name':'%@'}",str_pic,str_type,str_sex,str_area,str_age,str_size,str_hair,str_breed,str_tel,str_email,str_drsc,str_location,str_click,str_date,str_chipNo,str_dogNo,str_youtube,str_gps,str_member,str_name];
        
        
    }else if (page_type==2){
        
        //httpBodyString=[NSString stringWithFormat:@"pdata={'pic':%@,'type':'%@','sex':'%@','area':'%@','age':'%@','size':'%@','hair':'%@','breed':'%@','quot':'%@','tel':'%@','email':'%@','drsc':'%@','location':'%@','click':'%@','date':'%@','chipNo':'%@','dogNo':'%@','youtube':'%@','gps':'%@','member':'%@','name':'%@','id':'%@'}",str_pic,str_type,str_sex,str_area,str_age,str_size,str_hair,str_breed,str_quot,str_tel,str_email,str_drsc,str_location,str_click,str_date,str_chipNo,str_dogNo,str_youtube,str_gps,str_member,str_name,str_editId];
        
        
        //By Richard 2018.02.08
        
        str_tel = [Word_AES encryptAESData:str_tel];
        str_email = [Word_AES encryptAESData:str_email];
        str_drsc = [Word_AES encryptAESData:str_drsc];
        str_location = [Word_AES encryptAESData:str_location];
        str_date = [Word_AES encryptAESData:str_date];
        str_chipNo = [Word_AES encryptAESData:str_chipNo];
        str_dogNo = [Word_AES encryptAESData:str_dogNo];
        str_youtube = [Word_AES encryptAESData:str_youtube];
        str_gps = [Word_AES encryptAESData:str_gps];
        str_member = [Word_AES encryptAESData:str_member];
        str_name = [Word_AES encryptAESData:str_name];
        
        httpBodyString=[NSString stringWithFormat:@"pdata={'pic':%@,'type':'%@','sex':'%@','area':'%@','age':'%@','size':'%@','hair':'%@','breed':'%@','quot':'%@','tel':'%@','email':'%@','drsc':'%@','location':'%@','click':'%@','date':'%@','chipNo':'%@','dogNo':'%@','youtube':'%@','gps':'%@','member':'%@','name':'%@','id':'%@'}",str_pic,str_type,str_sex,str_area,str_age,str_size,str_hair,str_breed,str_quot,str_tel,str_email,str_drsc,str_location,str_click,str_date,str_chipNo,str_dogNo,str_youtube,str_gps,str_member,str_name,str_editId];
        
        
        
    }else if (page_type==3){
        
        //httpBodyString=[NSString stringWithFormat:@"pdata={'pic':%@,'type':'%@','sex':'%@','area':'%@','age':'%@','size':'%@','hair':'%@','breed':'%@','tel':'%@','email':'%@','drsc':'%@','location':'%@','click':'%@','date':'%@','chipNo':'%@','dogNo':'%@','youtube':'%@','gps':'%@','member':'%@','name':'%@','id':'%@'}",str_pic,str_type,str_sex,str_area,str_age,str_size,str_hair,str_breed,str_tel,str_email,str_drsc,str_location,str_click,str_date,str_chipNo,str_dogNo,str_youtube,str_gps,str_member,str_name,str_editId];
        
        
        //By Richard 2018.02.08
        
        str_tel = [Word_AES encryptAESData:str_tel];
        str_email = [Word_AES encryptAESData:str_email];
        str_drsc = [Word_AES encryptAESData:str_drsc];
        str_location = [Word_AES encryptAESData:str_location];
        str_date = [Word_AES encryptAESData:str_date];
        str_chipNo = [Word_AES encryptAESData:str_chipNo];
        str_dogNo = [Word_AES encryptAESData:str_dogNo];
        str_youtube = [Word_AES encryptAESData:str_youtube];
        str_gps = [Word_AES encryptAESData:str_gps];
        str_member = [Word_AES encryptAESData:str_member];
        str_name = [Word_AES encryptAESData:str_name];
        
        
        httpBodyString=[NSString stringWithFormat:@"pdata={'pic':%@,'type':'%@','sex':'%@','area':'%@','age':'%@','size':'%@','hair':'%@','breed':'%@','tel':'%@','email':'%@','drsc':'%@','location':'%@','click':'%@','date':'%@','chipNo':'%@','dogNo':'%@','youtube':'%@','gps':'%@','member':'%@','name':'%@','id':'%@'}",str_pic,str_type,str_sex,str_area,str_age,str_size,str_hair,str_breed,str_tel,str_email,str_drsc,str_location,str_click,str_date,str_chipNo,str_dogNo,str_youtube,str_gps,str_member,str_name,str_editId];
        
        
    }else{
        
        //httpBodyString=[NSString stringWithFormat:@"pdata={'pic':%@,'type':'%@','sex':'%@','area':'%@','age':'%@','size':'%@','hair':'%@','breed':'%@','tel':'%@','email':'%@','drsc':'%@','location':'%@','click':'%@','date':'%@','chipNo':'%@','dogNo':'%@','youtube':'%@','gps':'%@','member':'%@','name':'%@','mid':'%@'}",str_pic,str_type,str_sex,str_area,str_age,str_size,str_hair,str_breed,str_tel,str_email,str_drsc,str_location,str_click,str_date,str_chipNo,str_dogNo,str_youtube,str_gps,str_member,str_name,str_editId];
        
        
        //By Richard 2018.02.08
        
        str_tel = [Word_AES encryptAESData:str_tel];
        str_email = [Word_AES encryptAESData:str_email];
        str_drsc = [Word_AES encryptAESData:str_drsc];
        str_location = [Word_AES encryptAESData:str_location];
        str_date = [Word_AES encryptAESData:str_date];
        str_chipNo = [Word_AES encryptAESData:str_chipNo];
        str_dogNo = [Word_AES encryptAESData:str_dogNo];
        str_youtube = [Word_AES encryptAESData:str_youtube];
        str_gps = [Word_AES encryptAESData:str_gps];
        str_member = [Word_AES encryptAESData:str_member];
        str_name = [Word_AES encryptAESData:str_name];
        
        
        httpBodyString=[NSString stringWithFormat:@"pdata={'pic':%@,'type':'%@','sex':'%@','area':'%@','age':'%@','size':'%@','hair':'%@','breed':'%@','tel':'%@','email':'%@','drsc':'%@','location':'%@','click':'%@','date':'%@','chipNo':'%@','dogNo':'%@','youtube':'%@','gps':'%@','member':'%@','name':'%@','mid':'%@'}",str_pic,str_type,str_sex,str_area,str_age,str_size,str_hair,str_breed,str_tel,str_email,str_drsc,str_location,str_click,str_date,str_chipNo,str_dogNo,str_youtube,str_gps,str_member,str_name,str_editId];
        
    }


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
       
    strMessage=@"上傳成功";
    
    MemberCenterViewController *mainCenterVC = [[MemberCenterViewController alloc] initWithNibName:@"MemberCenterViewController" bundle:nil];
        
    UINavigationController *mainVCNavigationController = [[UINavigationController alloc] initWithRootViewController:mainCenterVC];
    
    [mainVCNavigationController.navigationBar setHidden:TRUE];
    
    [self presentViewController:mainVCNavigationController animated:NO completion:nil];
        
        // [self.navigationController pushViewController:sideMenuController animated:YES];
    }
    
    [Utility alertWithDialog:@"訊息" message:strMessage];

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
    
    //上移n个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,0.0,width,height);
    
    self.view.frame=rect;
    
    [UIView commitAnimations];
    
    return;
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
