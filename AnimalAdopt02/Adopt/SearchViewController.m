//
//  FindMainViewController.m
//  TcapoIOSApp
//
//  Created by Casper on 15/4/19.
//  Copyright (c) 2015年 haoyu. All rights reserved.
//

#import "SearchViewController.h"
#import "JDSideMenu.h"
#import "JDMenuViewController.h"
#import "UIViewController+JDSideMenu.h"
#import "MainViewController.h"
#import "MemberCenterViewController.h"
#import "UserPreferences.h"
#import "Utility.h"
#import "ASIFormDataRequest.h"
#import <CoreLocation/CoreLocation.h>
#import "SearchEntity.h"

@interface SearchViewController (){
    NSMutableData *receivedData;
    NSURLConnection *connection;
    
    IBOutlet UIScrollView *list_scrollView;
  
    IBOutlet UIPickerView *selPicker;
    IBOutlet UILabel *plurkLabel;
    IBOutlet UILabel *title_label;

    NSArray *sellist,*msglist;
  
    
    IBOutlet UIButton *typeBtnView;
    IBOutlet UIButton *sexBtnView;
    IBOutlet UIButton *hairBtnView;
    IBOutlet UIButton *ageBtnView;
    IBOutlet UIButton *sizeBtnView;
    IBOutlet UIButton *areaBtnView;
    
    IBOutlet UIView *selView;


    IBOutlet UITextField *Pet_Name;
    
    IBOutlet UITextField *AcceptNum;
    
    int selItem;
    NSMutableArray *selnameAry;
    NSMutableArray *selIdAry;
    NSString *str_type,*str_sex,*str_area,*str_age,*str_size,*str_hair,*str_name,
             *str_AcceptNum;
}

@end

@implementation SearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    selnameAry = [UserPreferences getArrayForKey:@"SelNameSet"];
    
    selIdAry = [UserPreferences getArrayForKey:@"SelIdSet"];
    
    selItem = 0;
  
    str_type=@"";str_sex=@"";
    str_area=@"";str_age=@"";str_size=@"";
    str_hair=@"";
    
    //By Richard 2017.01.11
    str_name=@"";
    
   
    //By Richard 2017.02.14
    str_AcceptNum=@"";
   

}


- (IBAction)btnType:(id)sender
{
    [selView setHidden:NO];
    sellist = [selnameAry objectAtIndex:0];
    selItem = 0;
    [selPicker reloadAllComponents];
}
- (IBAction)btnSex:(id)sender
{
    [selView setHidden:NO];
    sellist = [selnameAry objectAtIndex:1];
    selItem = 1;
    [selPicker reloadAllComponents];
}
- (IBAction)btnHair:(id)sender
{
    [selView setHidden:NO];
    sellist = [selnameAry objectAtIndex:2];
    selItem = 2;
    [selPicker reloadAllComponents];
}
- (IBAction)btnAge:(id)sender
{
    [selView setHidden:NO];
    sellist = [selnameAry objectAtIndex:3];
    selItem = 3;
    [selPicker reloadAllComponents];
}
- (IBAction)btnSize:(id)sender
{
    [selView setHidden:NO];
    sellist = [selnameAry objectAtIndex:4];
    selItem = 4;
    [selPicker reloadAllComponents];
}
- (IBAction)btnArea:(id)sender
{
    [selView setHidden:NO];
    sellist = [selnameAry objectAtIndex:5];
    selItem = 5;
    [selPicker reloadAllComponents];
}


- (IBAction)btnDone:(id)sender
{
    
    [selView setHidden:YES];
    
    NSInteger row =[selPicker selectedRowInComponent:0];
    
    NSString *selected_name = [sellist objectAtIndex:row];
    
    
    NSMutableDictionary *dictId =[selIdAry objectAtIndex:selItem];
   
    NSString * selected_id = [dictId objectForKey:selected_name];
    
    switch (selItem) {
        case 0:
            str_type = selected_id;
            [typeBtnView setTitle:selected_name forState:UIControlStateNormal];
            break;
        case 1:
            str_sex = selected_id;
             [sexBtnView setTitle:selected_name forState:UIControlStateNormal];
            break;
        case 2:
            str_hair = selected_id;
             [hairBtnView setTitle:selected_name forState:UIControlStateNormal];
            break;
        case 3:
            str_age = selected_id;
             [ageBtnView setTitle:selected_name forState:UIControlStateNormal];
            break;
        case 4:
            str_size = selected_id;
            [sizeBtnView setTitle:selected_name forState:UIControlStateNormal];
            break;
        case 5:
            str_area = selected_id;
            [areaBtnView setTitle:selected_name forState:UIControlStateNormal];
            break;
            
        default:
            
            break;
        }
   
    
    [selView setHidden:YES];
}




- (IBAction)btnSend:(id)sender
{
    SearchEntity *searchEntity = [[SearchEntity alloc] init];
    searchEntity.search_type = str_type;
    searchEntity.search_sex = str_sex;
    searchEntity.search_hair = str_hair;
    searchEntity.search_age = str_age;
    searchEntity.search_size = str_size;
    searchEntity.search_area = str_area;
    
    //By Richard 2017.01.11
    searchEntity.search_name = str_name;
    
    //By Richard 2017.02.14
    searchEntity.search_acceptnum = str_AcceptNum;
    
    NSLog( @"str_AcceptNum : %@",str_AcceptNum);
    
    //通过委托协议传值
    [self.delegate passValue:searchEntity];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
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
}
//內建函式印出字串在Picker上以免出現"?"
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    return [sellist objectAtIndex:row];

   }
//選擇UIPickView中的項目時會出發的內建函式
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    plurkLabel.text = [NSString stringWithFormat:@"%@ :", [sellist objectAtIndex:row]];
}


//縮鍵盤
- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    str_name = Pet_Name.text;
    
    NSLog( @"str_name : %@",str_name);
    
    str_AcceptNum = AcceptNum.text;
    
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
