//
//  NKChat.h
//  TestChat
//
//  Created by Nikita Kolmogorov on 02/06/14.
//  Copyright (c) 2014 Nikita Kolmogorov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NKChat : NSObject

@property (strong, nonatomic) NSArray *chatHistory;

+ (instancetype)sharedManager;

- (void)login:(NSString *)email password:(NSString *)password success:(void(^)())successBlock failure:(void(^)())failureBlock;
- (void)logout;

- (void)sendMessage:(NSString *)message toUser:(NSString *)userId;

@end
