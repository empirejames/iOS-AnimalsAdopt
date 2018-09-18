//
//  AppDelegate.h
//  Foodspotting
//
//  Created by jetson  on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MessageUI/MessageUI.h>
#import "FacebookAgent.h"
#import "MotionAgent.h"
#import "RecorderManager.h"

@class SlidingController;
@class CenterViewController;
@class MainViewController;
@class LeveyTabBarController;

@interface AppDelegate : UIResponder<UIApplicationDelegate, CLLocationManagerDelegate, MotionDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, RecordingDelegate, AVAudioPlayerDelegate> {
     LeveyTabBarController *leveyTabBarController;
}

@property (nonatomic, retain) IBOutlet LeveyTabBarController *leveyTabBarController;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

+ (AppDelegate *)sharedAppDelegate;
+ (MainViewController *)sharedMain;

//- (void)setCenterViewController:(CenterViewController *)viewController;
- (void)setHomeViewController:(MainViewController *)viewController;
- (void)eventCheck;
- (void)stopTrigger;
- (void)stopPlaying;
- (void) startTimer;
- (void)setupReminder;
- (void)hideTabbar;
- (void)openTabbar;
@end

