//
//  NKLoginViewController.m
//  TestChat
//
//  Created by Nikita Kolmogorov on 02/06/14.
//  Copyright (c) 2014 Nikita Kolmogorov. All rights reserved.
//

#import "NKLoginViewController.h"
#import <SocialCommunication/SocialCommunication.h>
#import "NKChat.h"

@interface NKLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)loginTouched:(UIButton *)sender;

@end

@implementation NKLoginViewController

#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Button methods -

- (IBAction)loginTouched:(UIButton *)sender
{
    sender.enabled = NO;
    [[NKChat sharedManager] login:_emailTextField.text
                         password:_passwordTextField.text
                          success:^{
                              [self performSegueWithIdentifier:@"SegueToChatList" sender:self];
                              sender.enabled = YES;
                          }
                          failure:^{
                              sender.enabled = YES;
                          }];
}

@end
