//
//  NKChat.m
//  TestChat
//
//  Created by Nikita Kolmogorov on 02/06/14.
//  Copyright (c) 2014 Nikita Kolmogorov. All rights reserved.
//

#import "NKChat.h"
#import <SocialCommunication/SocialCommunication.h>

@implementation NKChat

#pragma mark - Singleton pattern -

// 1
+ (instancetype)sharedManager
{
    static NKChat *sharedChat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedChat = [self new];
    });
    return sharedChat;
}

#pragma mark - Accessors -

// 2
- (NSArray *)chatHistory
{
    return [self fetchChatHistory];
}

#pragma mark - General methods -

// 3
- (void)login:(NSString *)email password:(NSString *)password success:(void(^)())successBlock failure:(void(^)())failureBlock
{
    NSDictionary *dictionary = @{@"EMail":email,
                                 @"Password":password};
    
    [[C2CallPhone currentPhone] registerUser:dictionary
                       withCompletionHandler:^(BOOL success, NSString *result) {                           if (success) {
                               [[C2CallPhone currentPhone] startC2CallPhone];
                               successBlock();
                           } else {
                               failureBlock();
                           }
                       }];
}

// 4
- (void)logout
{
    [(C2CallAppDelegate *)[UIApplication sharedApplication].delegate logoutUser];
}

// 5
- (void)sendMessage:(NSString *)message toUser:(NSString *)userId
{
    [[C2CallPhone currentPhone] submitMessage:message toUser:userId];
}

// 6
- (NSArray *)fetchChatHistory
{
    // Получаем все Managed Object истории чата
    NSFetchRequest *request = [[SCDataManager instance] fetchRequestForChatHistory:YES];
    NSFetchedResultsController *controller = [[SCDataManager instance] fetchedResultsControllerWithFetchRequest:request sectionNameKeyPath:nil cacheName:nil];
    NSError *error;
    [controller performFetch:&error];
    
    // Собираем результирующий массив
    NSMutableArray *result = [NSMutableArray array];
    for (NSManagedObject *chat in controller.fetchedObjects) {
        // Получаем словарь чата
        NSArray *chatKeys = @[@"contact", @"lastTimestamp", @"missedEvents"];
        NSMutableDictionary *inChat = [[chat dictionaryWithValuesForKeys:chatKeys] mutableCopy];
        
        if ([inChat[@"contact"] rangeOfString:@"@"].location != NSNotFound)
            inChat[@"contact"] = [inChat[@"contact"] substringToIndex:[inChat[@"contact"] rangeOfString:@"@"].location];
        NSLog(@"%@",inChat[@"contact"]);
        
        // Проверяем на дубликаты
        NSMutableDictionary *dublicate = nil;
        for (NSMutableDictionary *dict in result) {
            if ([dict[@"contact"] isEqualToString:inChat[@"contact"]]) {
                dublicate = dict;
                break;
            }
        }
        
        // Получаем все сообщения
        NSMutableArray *messages = (dublicate) ? dublicate[@"messages"] : [NSMutableArray array];
        for (NSManagedObject *chatEvent in [chat valueForKey:@"chatHistory"]) {
            NSArray *chatEventKeys = [[[chatEvent entity] attributesByName] allKeys];
            NSMutableDictionary *inChatEvent = [[chatEvent dictionaryWithValuesForKeys:chatEventKeys] mutableCopy];
            //            NSLog(@"%@",inChatEvent);
            inChatEvent[@"ManagedObject"] = chatEvent;
            [messages addObject:inChatEvent];
        }
        [messages sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timevalue" ascending:YES]]];
        
        if (dublicate) {
            dublicate[@"messages"] = messages;
            [dublicate[@"ManagedObjects"] addObject:chat];
            dublicate[@"missedEvents"] = @([dublicate[@"missedEvents"] intValue] + [inChat[@"missedEvents"] intValue]);
            if (!dublicate[@"name"])
                dublicate[@"name"] = inChat[@"name"];
        } else {
            inChat[@"messages"] = messages;
            inChat[@"ManagedObjects"] = [NSMutableArray arrayWithObject:chat];
        }
        
        // Добавляем словарь в результат
        if (!dublicate)
            [result addObject:inChat];
    }
    
    // Сортируем результат
    [result sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"lastTimestamp" ascending:NO]]];
    
    NSLog(@"%@",result);
    
    // Возвращаем результирующий массив
    return [result copy];
}

@end
