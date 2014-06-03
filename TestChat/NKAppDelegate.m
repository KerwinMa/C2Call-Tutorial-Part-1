//
//  NKAppDelegate.m
//  TestChat
//
//  Created by Nikita Kolmogorov on 02/06/14.
//  Copyright (c) 2014 Nikita Kolmogorov. All rights reserved.
//

#import "NKAppDelegate.h"
#import "NKChat.h"

@implementation NKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.affiliateid = @"6B9DF5671444320162B";
    self.secret = @"2fd9cd18aa4d957a4030c0455101646d";
    
    [NKChat sharedManager];
    
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
