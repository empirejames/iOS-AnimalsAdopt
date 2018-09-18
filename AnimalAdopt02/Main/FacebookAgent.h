//
//  FacebookAgent.h
//  HelpMee
//
//  Created by John on 2014/3/15.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
//#import <FBSDKShareKit/FBSDKShareKit.h>
@interface FacebookAgent : NSObject <UIWebViewDelegate>

@property (strong, nonatomic) FBSession *fbSession;
@property (strong, nonatomic) id<FBGraphUser> loggedInUser;

+ (FacebookAgent *)sharedAgent;

- (void)postToFacebook;

@end
