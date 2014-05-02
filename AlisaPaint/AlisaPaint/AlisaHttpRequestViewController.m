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
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@property (strong, nonatomic) NSString *currentGoal;
@end

@implementation AlisaHttpRequestViewController

NSString *server = @"http://localhost:8080/web_war_exploded/alisa";

NSString *goalParameter = @"goal";
NSString *registrationGoal = @"reg";
NSString *authorizationGoal = @"auth";
NSString *loginParameter = @"login";
NSString *passwordParameter = @"pass";

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
        }
    }
}

- (IBAction)hideKeybord:(UITextField *)sender
{
    [sender resignFirstResponder];
}

@end
