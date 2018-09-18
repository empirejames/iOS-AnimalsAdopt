//
//  Utility.h
//  HelpMee
//
//  Created by John on 2014/4/4.
//
//

#import <Foundation/Foundation.h>


@interface Utility : NSObject

+ (NSArray *)reportInfoFromAdministrativeArea:(NSString *)administrativeArea;
+ (void)localNotification:(NSString *)message;
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)alertWithDialog:(NSString *)title message:(NSString *)message;


@end
