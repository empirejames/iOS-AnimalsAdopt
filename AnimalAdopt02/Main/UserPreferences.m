//
//  UserPreferences.m
//  HelpMee
//
//  Created by John on 2013/12/27.
//
//

#import "UserPreferences.h"

@implementation UserPreferences

+ (void)setBool:(BOOL)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

+ (BOOL)getBoolForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}


+ (NSString *)getStringForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:key];
}

+ (void)setString:(NSString *)string forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:string forKey:key];
    [userDefaults synchronize];
}

+ (NSString *)getArrayForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

+ (void)setArray:(NSMutableArray *)array forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:array forKey:key];
    [userDefaults synchronize];
}

+ (int)getIntegerForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:key];
}

+ (void)setInteger:(int)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:key];
    [userDefaults synchronize];
}



+ (BOOL)getBoolForRecording
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"recording"];
    
    if(number!=nil)
    {
        BOOL trigger = [number boolValue];
        
        return trigger;
    }
    
    return FALSE;
    
}
+ (void)setBoolForRecording:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:value] forKey:@"recording"];
}


+ (BOOL)getBoolForEventProcedureRunning
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"eventProcedureRunning"];
    
    if(number!=nil)
    {
        BOOL trigger = [number boolValue];
        
        return trigger;
    }
    
    return FALSE;
   
}
+ (void)setBoolForEventProcedureRunning:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:value] forKey:@"eventProcedureRunning"];
}


+ (BOOL)getBoolForTrigger
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"trigger"];
    
    if(number!=nil)
    {
        BOOL trigger = [number boolValue];
        
        return trigger;
    }
    
    return FALSE;
}

+ (void)setBoolForTrigger:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:value] forKey:@"trigger"];
}



+ (BOOL)getBoolForGPS
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"triggergps"];
    
    if(number!=nil)
    {
        BOOL trigger = [number boolValue];
        
        return trigger;
    }
    
    return FALSE;
}

+ (void)setBoolForGPS:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:value] forKey:@"triggergps"];
    
 

}

+ (BOOL)getBoolForGPSEmail
{
    NSNumber *number = [[NSUserDefaults standardUserDefaults] objectForKey:@"triggergpsemail"];
    
    if(number!=nil)
    {
        BOOL trigger = [number boolValue];
        
        return trigger;
    }
    
    return FALSE;
}

+ (void)setBoolForGPSEmail:(BOOL)value
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:value] forKey:@"triggergpsemail"];
}

@end
