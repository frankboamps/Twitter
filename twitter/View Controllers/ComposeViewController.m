//
//  ComposeViewController.m
//  twitter
//
//  Created by frankboamps on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetTextView;

@end

@implementation ComposeViewController

#pragma  mark - view controller lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tweetTextView.delegate = self;
}

#pragma mark - stting close button
- (IBAction)closeButton:(id)sender
{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - stting post tweet button
- (IBAction)postTweetButton:(id)sender
{
    [[APIManager shared]postStatusWithText:self.tweetTextView.text completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error composing Tweet: %@", error.localizedDescription);
        }
        else{
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
}

#pragma mark - setting text view
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    int characterLimit = 140;
    NSString *newText = [self.tweetTextView.text stringByReplacingCharactersInRange:range withString:text];
    self.labelToIndicateCharacterCount.text = [NSString stringWithFormat:@"%lu characters typed", (unsigned long)newText.length];
    return newText.length < characterLimit;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
