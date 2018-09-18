//
//  UserPreferences.h
//  HelpMee
//
//  Created by John on 2013/12/27.
//
//

#import <Foundation/Foundation.h>


#define PREF_TOKEN @"pref_token"
#define PREF_ACCOUNT @"pref_account"
#define PREF_PASSWORD @"pref_password"

//#define PREF_SMS_NAME @"pref_sms_name"
//#define PREF_SMS_PHONE @"pref_sms_phone"
#define PREF_SMALLNAME @"pref_smallname"
#define PREF_SMS_MESSAGE @"pref_sms_message"

#define PREF_CALL_NAME @"pref_call_name"
#define PREF_CALL_PHONE @"pref_call_phone"

#define PREF_MAIL_EMAIL @"pref_mail_email"

#define PREF_REMINDER_WEEKDAY @"pref_reminder_weekday"
#define PREF_REMINDER_HOUR @"pref_reminder_hour"
#define PREF_REMINDER_MINUTE @"pref_reminder_minute"

#define PREF_ALARM_SOUND @"pref_alarm_sound"

#define PREF_TRIGGER_SENSITIVITY @"pref_trigger_sensitivity"

#define PREF_STARTUP_SHOW_TUTORIAL @"pref_startup_show_tutorial"

#define PREF_IMEI_SET @"pref_imei_set"

@interface UserPreferences : NSObject

+ (BOOL)getBoolForSwitch:(int)i;
+ (void)setBool:(BOOL)value ForSwitch:(int)i;

+ (NSString *)getStringForKey:(NSString *)key;
+ (void)setString:(NSString *)string forKey:(NSString *)key;
+ (NSString *)getArrayForKey:(NSString *)key;
+(void)setArray:(NSMutableArray *)array forKey:(NSString *)key;
+ (int)getIntegerForKey:(NSString *)key;
+ (void)setInteger:(int)value forKey:(NSString *)key;

+ (int)calculateSafetyScore;

+ (BOOL)getBoolForEventProcedureRunning;
+ (void)setBoolForEventProcedureRunning:(BOOL)value;
+ (BOOL)getBoolForRecording;
+ (void)setBoolForRecording:(BOOL)value;
+ (BOOL)getBoolForTrigger;
+ (void)setBoolForTrigger:(BOOL)value;
+ (BOOL)getBoolForGPS;
+ (void)setBoolForGPS:(BOOL)value;
+ (BOOL)getBoolForGPSEmail;
+ (void)setBoolForGPSEmail:(BOOL)value;


@end

