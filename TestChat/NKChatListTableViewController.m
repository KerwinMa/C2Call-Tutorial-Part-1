//
//  NKChatListTableViewController.m
//  TestChat
//
//  Created by Nikita Kolmogorov on 02/06/14.
//  Copyright (c) 2014 Nikita Kolmogorov. All rights reserved.
//

#import "NKChatListTableViewController.h"

@interface NKChatListTableViewController ()

@end

@implementation NKChatListTableViewController

#pragma mark - UITableViewDataSource -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = (indexPath.row) ? @"nikita@borodutch.com" : @"luke@borodutch.com";
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender
{
    UIViewController *dest = segue.destinationViewController;
    dest.title = sender.textLabel.text;
}

@end