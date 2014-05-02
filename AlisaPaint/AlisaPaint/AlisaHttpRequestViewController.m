//
//  AlisaHttpRequestViewController.m
//  AlisaPaint
//
//  Created by Влад Агиевич on 01.05.14.
//  Copyright (c) 2014 uubo. All rights reserved.
//

#import "AlisaHttpRequestViewController.h"

@interface AlisaHttpRequestViewController () <NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *friendLoginField;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSString *currentGoal;
@end

@implementation AlisaHttpRequestViewController

NSString *server = @"http://localhost:8080/web_war_exploded/alisa";

static NSString *goalParameter = @"goal";
static NSString *registrationGoal = @"reg";
static NSString *authorizationGoal = @"auth";
static NSString *findUserGoal = @"find";
static NSString *addFriendGoal = @"add";
static NSString *getFriendsGoal = @"getf";

static NSString *loginParameter = @"login";
static NSString *passwordParameter = @"pass";
static NSString *userLoginParameter = @"user_login";
static NSString *friendLoginParameter = @"friend_login";

- (IBAction)registration
{
    self.currentGoal = registrationGoal;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@",
                                       server,
                                       goalParameter, self.currentGoal,
                                       loginParameter, self.loginField.text,
                                       passwordParameter, self.passwordField.text]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (IBAction)authorization
{
    self.currentGoal = authorizationGoal;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@",
                                       server,
                                       goalParameter, self.currentGoal,
                                       loginParameter, self.loginField.text,
                                       passwordParameter, self.passwordField.text]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (IBAction)findUser
{
    self.currentGoal = findUserGoal;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@=%@&%@=%@",
                                       server,
                                       goalParameter, self.currentGoal,
                                       loginParameter, self.loginField.text]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (IBAction)addFriend
{
    self.currentGoal = addFriendGoal;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@=%@&%@=%@&%@=%@",
                                       server,
                                       goalParameter, self.currentGoal,
                                       userLoginParameter, self.loginField.text,
                                       friendLoginParameter, self.friendLoginField.text]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (IBAction)getFriends
{
    self.currentGoal = getFriendsGoal;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@=%@&%@=%@",
                                       server,
                                       goalParameter, self.currentGoal,
                                       loginParameter, self.loginField.text]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if ([response isMemberOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        
        int status = [httpResponse statusCode];
        if ([self.currentGoal isEqualToString:registrationGoal]) {
            switch (status) {
                case 0:
                    self.resultLabel.text = @"Error occured";
                    break;
                case 1:
                    self.resultLabel.text = @"Registration successfully completed";
                    break;
                default:
                    self.resultLabel.text = @"Unknown error occured";
                    break;
            }
        } else if ([self.currentGoal isEqualToString:authorizationGoal]) {
            switch (status) {
                case 0:
                    self.resultLabel.text = @"Error occured";
                    break;
                case 1:
                    self.resultLabel.text = @"Authorization successfully completed";
                    break;
                case 2:
                    self.resultLabel.text = @"Authorization not completed";
                    break;
                default:
                    self.resultLabel.text = @"Unknown error occured";
                    break;
            }
        } else if ([self.currentGoal isEqualToString:findUserGoal]) {
            switch (status) {
                case 0:
                    self.resultLabel.text = @"Error occured";
                    break;
                case 1:
                    self.resultLabel.text = @"User has been found";
                    break;
                case 2:
                    self.resultLabel.text = @"User hasn't been found";
                    break;
                default:
                    self.resultLabel.text = @"Unknown error occured";
                    break;
            }
        } else if ([self.currentGoal isEqualToString:addFriendGoal]) {
            switch (status) {
                case 0:
                    self.resultLabel.text = @"Error occured";
                    break;
                case 1:
                    self.resultLabel.text = @"Friend has been added";
                    break;
                case 2:
                    self.resultLabel.text = @"Friend hasn't been added";
                    break;
                default:
                    self.resultLabel.text = @"Unknown error occured";
                    break;
            }
        } else if ([self.currentGoal isEqualToString:getFriendsGoal]) {
            switch (status) {
                case 0:
                    self.resultLabel.text = @"Error occured";
                    break;
                case 1:
                    self.resultLabel.text = @"Friends have been sent";
                    break;
                case 2:
                    self.resultLabel.text = @"Friends haven't been sent";
                    break;
                default:
                    self.resultLabel.text = @"Unknown error occured";
                    break;
            }
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *friendList = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    self.textView.text = friendList;
}

- (IBAction)hideKeybord:(UITextField *)sender
{
    [sender resignFirstResponder];
}

@end
