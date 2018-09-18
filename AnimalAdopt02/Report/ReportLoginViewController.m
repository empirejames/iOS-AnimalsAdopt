//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "ReportLoginViewController.h"
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
#import "ReportLoginUploadViewController.h"
#import "RadioButton.h"
#import <CommonCrypto/CommonCryptor.h>
#import "Word_AES.h"

@interface ReportLoginViewController (){
    NSMutableData *receivedData;
    NSURLConnection *connection;
   
    UIPickerView *selPicker;
    
    IBOutlet UIView *is_peopleView;
    IBOutlet UIView *no_peopleView;
 
    IBOutlet UIScrollView *list_scrollView;
    
    IBOutlet UITextField *typeTxt;
  
    IBOutlet UILabel *title_label;
   
    NSMutableArray *reportNameAry;
    NSMutableArray *reportIdAry;
  
   IBOutlet UITextField *r_nameTxt;//報案人
    IBOutlet UITextField *r_idnoTxt;
    IBOutlet UITextField *r_phoneTxt;
    IBOutlet UITextField *r_emailTxt;
    IBOutlet UITextField *r_addrTxt;
    IBOutlet UITextField *r_sexTxt;
    
    IBOutlet UITextField *r_name_oTxt; //報案人(非自然人)
    IBOutlet UITextField *r_idno_oTxt;
    IBOutlet UITextField *r_phone_oTxt;
    IBOutlet UITextField *r_email_oTxt;
    IBOutlet UITextField *r_addr_oTxt;
    IBOutlet UITextField *r_mainname_oTxt;
    

     NSArray *sellist;
    
    NSString *str_r_sex,*str_r_name,*str_r_idno,*str_r_phone,
    *str_r_email,*str_r_addr,*str_r_name_o,*str_r_idno_o;
    
    BOOL isButtonOn;
    
    
     IBOutlet RadioButton* radioButton;
    
    }

@end

@implementation ReportLoginViewController
@synthesize page_type;
@synthesize dataAry;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    sellist = [[NSArray alloc] initWithObjects:@"男性", @"女性", nil];
    
    
    //By Richard 2018.02.09
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"若相關資料(照片、影像、車號、門牌及違法情節) 經查證為不實或偽造之違法行為，檢舉人將負民事或刑事責任" message:@"" delegate:self cancelButtonTitle:@"瞭解" otherButtonTitles:nil, nil];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"1.若相關資料(照片、影像、車號、門牌及違法情節) 經查證為不實或偽造之違法行為，檢舉人將負民事或刑事責任\n2.您同意將個人以及其他相關資料，傳送給台北市動物保護處嗎?" message:@"" delegate:self cancelButtonTitle:@"不同意" otherButtonTitles:@"同意", nil];
    
    [alert show];
    
    isButtonOn = YES;
    
    str_r_sex=@"";str_r_name=@"";str_r_idno=@"";str_r_phone=@"";
    
    str_r_email=@"";str_r_addr=@"";str_r_name_o=@"";str_r_idno_o=@"";
    

    
    reportNameAry = [UserPreferences getArrayForKey:@"ReportNameSet"];
    
    reportIdAry = [UserPreferences getArrayForKey:@"ReportIdSet"];
    
    
    selPicker = [[UIPickerView alloc]init];
    selPicker.delegate =self;
    selPicker.dataSource=self;
    
    // 建立 UIToolbar
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    // 選取日期完成鈕 並給他一個 selector
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(selDoneClick:)];
    
    UIBarButtonItem *spaceBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    // 把按鈕加進 UIToolbar
    //toolBar.items = [NSArray arrayWithObject:doneBtn1];
    toolBar.items = @[spaceBtn,doneBtn];
    
    [selPicker reloadAllComponents];
    sellist= [reportNameAry objectAtIndex:7];
    
    r_sexTxt.inputView = selPicker;
    r_sexTxt.inputAccessoryView = toolBar;
    

}


-(IBAction)onRadioBtn:(RadioButton*)sender
{
    NSLog(@"sel-->%@",sender.titleLabel.text);
    NSString *sel_txt = sender.titleLabel.text;
    if ([sel_txt isEqualToString:@"自然人"]) {
        [is_peopleView setHidden:NO];
        [no_peopleView setHidden:YES];
        isButtonOn=YES;
    }else {
        [is_peopleView setHidden:YES];
        [no_peopleView setHidden:NO];
        isButtonOn=NO;
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    switch (buttonIndex) {
        case 0:
            //By Richard 2018.02.09
            //NSLog(@"Cancel Button Pressed");
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            break;
        case 1:
            //[self.navigationController dismissViewControllerAnimated:NO completion:nil];
            break;
        default:
            break;
    }
    
    
}

- (void)selDoneClick:(id)sender
{
    [self.view endEditing:YES];
    NSInteger row =[selPicker selectedRowInComponent:0];
    NSString *selected_name = [sellist objectAtIndex:row];
    
    
    // if (selItem!=6) {
    NSMutableDictionary *dictId =[reportIdAry objectAtIndex:7];
    
    NSString * selected_id = [dictId objectForKey:selected_name];
    
    
    str_r_sex = selected_id;
   [r_sexTxt setText:selected_name];
    
     // r_sexTxt.text = [NSString stringWithFormat:@"%@", [sellist objectAtIndex:row]];
   
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
   
    return YES;

 
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
    r_sexTxt.text = [NSString stringWithFormat:@"%@", [sellist objectAtIndex:row]];
}





- (IBAction)btnSend:(id)sender
{
    
    
    
      
    if (isButtonOn) {
        NSLog(@"自然人");
        str_r_name = r_nameTxt.text;
        str_r_idno = r_idnoTxt.text;
        str_r_phone = r_phoneTxt.text;
        str_r_email = r_emailTxt.text;
        str_r_addr = r_addrTxt.text;
        str_r_name_o = @"";
        str_r_idno_o = @"";
    }else {
         NSLog(@"非自然人");
        str_r_name = r_mainname_oTxt.text;
        str_r_idno = r_idno_oTxt.text;
        str_r_phone = r_phone_oTxt.text;
        str_r_email = r_email_oTxt.text;
        str_r_addr = r_addr_oTxt.text;
        str_r_name_o = r_name_oTxt.text;
        str_r_idno_o = r_idno_oTxt.text;
    }
    
    
    if ([str_r_name isEqualToString:@""]&&isButtonOn==YES) {
        [Utility alertWithTitle:@"訊息" message:@"姓名未填入"];
    }else if([str_r_idno isEqualToString:@""]&&isButtonOn==YES){
        [Utility alertWithTitle:@"訊息" message:@"國名身分證字號未填入"];
    }else if ([str_r_name_o isEqualToString:@""]&&isButtonOn==NO) {
        [Utility alertWithTitle:@"訊息" message:@"名稱未填入"];
    }else if([str_r_idno_o isEqualToString:@""]&&isButtonOn==NO){
        [Utility alertWithTitle:@"訊息" message:@"統一編號未填入"];
    }else if([str_r_phone isEqualToString:@""]){

        [Utility alertWithTitle:@"訊息" message:@"聯絡電話未填入"];
        
    }else if([str_r_addr isEqualToString:@""]){
        
        [Utility alertWithTitle:@"訊息" message:@"地址未填入"];
        
    }else{
        
        ReportLoginUploadViewController *reporupVC = [[ReportLoginUploadViewController alloc] initWithNibName:@"ReportLoginUploadViewController" bundle:nil];
        
        UINavigationController *reporupNC = [[UINavigationController alloc] initWithRootViewController:reporupVC];
        
        [reporupVC setStr_r_name:str_r_name];
        [reporupVC setStr_r_idno:str_r_idno];
        [reporupVC setStr_r_phone:str_r_phone];
        [reporupVC setStr_r_email:str_r_email];
        [reporupVC setStr_r_addr:str_r_addr];
        [reporupVC setStr_r_name_o:str_r_name_o];
        [reporupVC setStr_r_idno_o:str_r_idno_o];
        [reporupVC setStr_r_sex:str_r_sex];
        
        
        [reporupNC.navigationBar setHidden:TRUE];
        
        [self presentViewController:reporupNC animated:NO completion:nil];

    }
    
    

}
- (IBAction)btnBack:(id)sender;
{
   [self.navigationController dismissViewControllerAnimated:NO completion:nil];
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
