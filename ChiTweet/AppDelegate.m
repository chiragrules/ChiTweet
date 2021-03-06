//
//  AppDelegate.m
//  ChiTweet
//
//  Created by Chirag Davé on 6/18/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "NSDictionary+BDBOAuth1Manager.h"
#import "TwitterClient.h"
#import "User.h"
#import "MenuViewController.h"



@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    if ([User currentUser] == nil) {
        [self loadLoggedOutView];
    } else {
        [self loadLoggedInView];
    }
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)loadLoggedOutView {
    LoginViewController *loginScreen = [[LoginViewController alloc] init];
    self.window.rootViewController = loginScreen;
}

- (void)loadLoggedInView {
    MenuViewController *mvc = [[MenuViewController alloc] init];
//    TweetsViewController *tweetsVC = [[TweetsViewController alloc] init];
//    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tweetsVC];

    self.window.rootViewController = mvc;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([url.scheme isEqualToString:@"chitweet"]) {
        if ([url.host isEqualToString:@"oauth"]) {
            NSDictionary *parameters = [NSDictionary dictionaryFromQueryString:url.query];
            
            if (parameters[@"oauth_token"] && parameters[@"oauth_verifier"]) {
                TwitterClient *client = [TwitterClient instance];
                [client fetchAccessTokenWithPath:@"oauth/access_token" method:@"POST" requestToken:[BDBOAuthToken tokenWithQueryString:url.query] success:^(BDBOAuthToken *accessToken) {
                    [client.requestSerializer saveAccessToken:accessToken];

                    [client verifyCredentialsWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

                        User *currentUser = [User currentUser];
                        if (currentUser == nil) {
                            currentUser = [[User alloc] initWithDictionary:responseObject];
                            [User setCurrentUser:currentUser];
                        }
                        
                        [self loadLoggedInView];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        NSLog(@"Something went wrong...");
                    }];
                    
                    
                } failure:^(NSError *error) {
                    NSLog(@"no access token");
                }];
            }
        }
        return YES;
    }
    
    return NO;
    
}

#pragma mark - TweetsViewControllerDelegate Methods
- (void)dismissView {
    [self loadLoggedOutView];
}

@end
