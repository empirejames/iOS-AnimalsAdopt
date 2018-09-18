//
//  Utility.m
//  HelpMee
//
//  Created by John on 2014/4/4.
//
//

#import "Utility.h"
#import <UIKit/UIKit.h>

@implementation Utility

+ (void)alertWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [alert show];
    
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}

+ (void)alertWithDialog:(NSString *)title message:(NSString *)message
{
    UIAlertView *alert_dialog = [[UIAlertView alloc]
                              initWithTitle:title
                              message:message
                              delegate:self
                              cancelButtonTitle: @"關閉"
                                 otherButtonTitles:nil, nil];
 
    [alert_dialog show];
    
    //[alert_dialog release];
}




@end
