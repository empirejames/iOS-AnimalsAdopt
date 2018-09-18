//
//  FacebookAgent.m
//  HelpMee
//
//  Created by John on 2014/3/15.
//
//

#import "FacebookAgent.h"

@interface FacebookAgent () {
    UIWebView *webView;
}

@end

@implementation FacebookAgent

static FacebookAgent *agent = nil;

+ (FacebookAgent *)sharedAgent
{
    if(agent==nil)
    {
        agent = [[FacebookAgent alloc] init];
    }
    
    return agent;
}


- (void)postToFacebook
{
    CLLocationManager *locationManager;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    float latitude = locationManager.location.coordinate.latitude;
    float longitude = locationManager.location.coordinate.longitude;
    
    NSMutableDictionary *params =
    [[NSMutableDictionary alloc] init];
    [params setObject:[NSString stringWithFormat:@"[%@]: https://maps.google.com.tw/maps?q=%9.6f%%2C%9.6f", @"我的位置",  latitude, longitude] forKey:@"description"];
    [params setObject:@"http://www.chylyng.com/" forKey:@"link"];
    [params setObject:@"1423705587846429" forKey:@"app_id"];
    [params setObject:@"touch" forKey:@"display"];
    [params setObject:@"HelpMee" forKey:@"name"];
    [params setObject:[NSString stringWithFormat:@"[%@]: https://maps.google.com.tw/maps?q=%9.6f%%2C%9.6f", @"我的位置", latitude, longitude] forKey:@"message"];
    [params setObject:@"http://chylyng.servehttp.com:8080/helpmee.png" forKey:@"picture"];
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil parameters:params handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) { }];
}

- (void)webViewDidFinishLoad:(UIWebView *)_webView
{
}

@end
