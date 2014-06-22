//
//  AppDelegate.h
//  ChiTweet
//
//  Created by Chirag Davé on 6/18/14.
//  Copyright (c) 2014 Chirag Davé. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TweetsViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, TweetsViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
