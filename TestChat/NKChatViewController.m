//
//  NKChatViewController.m
//  TestChat
//
//  Created by Nikita Kolmogorov on 02/06/14.
//  Copyright (c) 2014 Nikita Kolmogorov. All rights reserved.
//

#import "NKChatViewController.h"
#import <SocialCommunication/SocialCommunication.h>
#import "NKChat.h"

@interface NKChatViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;

- (IBAction)sendTouched:(UIButton *)sender;

@end

@implementation NKChatViewController
{
    NSArray *tableData;
}

#pragma mark - View Controller life cycle -

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1
    tableData = [self getTableData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Показываем клавиатуру, как только попадаем на контроллер
    [_messageTextField becomeFirstResponder];
    
    // 2
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedMessage) name:@"kC2CallPhoneReceivedMessage" object:nil];
}

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 3
    return tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 4
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = ([tableData[indexPath.row][@"eventType"] isEqualToString:@"MessageIn"]) ? self.title : @"Я";
    cell.detailTextLabel.text = tableData[indexPath.row][@"text"];
    return cell;
}

#pragma mark - Button methods -

- (IBAction)sendTouched:(UIButton *)sender
{
    // 5
    [[NKChat sharedManager] sendMessage:_messageTextField.text
                                 toUser:@"c45645f71465dcff18e"];
    [self addMessage:_messageTextField.text];
    _messageTextField.text = @"";
}

#pragma mark - General Methods -

- (void)addMessage:(NSString *)message
{
    // 6
    NSMutableArray *mTableData = [tableData mutableCopy];
    [mTableData addObject:@{@"text":message,
                            @"messageType":@"MessageOut"}];
    tableData = mTableData;
    [_tableView reloadData];
}

- (void)receivedMessage
{
    // 7
    tableData = [self getTableData];
    [_tableView reloadData];
}

- (NSArray *)getTableData
{
    // 8
    for (NSDictionary *chat in [NKChat sharedManager].chatHistory)
        if ([chat[@"contact"] isEqualToString:@"c45645f71465dcff18e"])
            return chat[@"messages"];
    return nil;
}

@end
