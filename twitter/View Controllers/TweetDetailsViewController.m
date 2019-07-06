//
//  TweetDetailsViewController.m
//  twitter
//
//  Created by frankboamps on 7/4/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "APIManager.h"
#import "TTTAttributedLabel.h"

@interface TweetDetailsViewController () <TTTAttributedLabelDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *screenName;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet TTTAttributedLabel *tweetText;
@property (weak, nonatomic) IBOutlet UILabel *datePosted;
@property (weak, nonatomic) IBOutlet UILabel *retweetCount;
@property (weak, nonatomic) IBOutlet UILabel *favoritesCount;
@property (weak, nonatomic) IBOutlet UIButton *replyButton;
@property (weak, nonatomic) IBOutlet UIButton *retweetButton;
@property (weak, nonatomic) IBOutlet UIButton *favoriteButton;

@end

@implementation TweetDetailsViewController

#pragma mark - view controller life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.name.text = self.tweet.user.name;
    self.screenName.text = self.tweet.user.screenName;
    NSString *formattedDate = self.tweet.createdAtString;
    self.datePosted.text = formattedDate;
    self.tweetText.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    self.tweetText.delegate = self;
    self.tweetText.text = self.tweet.text;
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.favoritesCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    NSString *profileImageAddress = self.tweet.user.profileImageUrl;
    NSURL *profileImageUrl = [NSURL URLWithString:profileImageAddress];
    self.profileImage.image = nil;
    [self.profileImage setImageWithURL:profileImageUrl];
}

#pragma mark - attributing links
- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url {
    UIApplication *application = [UIApplication sharedApplication];
    [application openURL:url options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}

#pragma mark - setting retweet button
- (IBAction)didTapRetweet:(id)sender {
    if (self.tweet.retweeted == NO){
        [self retweet];
    }
    
    else{
        [self unRetweet];
    }
}

#pragma mark - stting favorite button
- (IBAction)didTapFavorite:(id)sender
{
    if (self.tweet.favorited == NO){
        [self favoriteTweet];
    }
    
    else{
        [self unFavoriteTweet];
    }
}

#pragma mark - favoriting tweet method
-(void)favoriteTweet
{
    self.tweet.favorited = YES;
    self.tweet.favoriteCount += 1;
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon-red.png"] forState:UIControlStateNormal];
    self.favoritesCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
    }];
}

#pragma mark - unfavoriting tweet method
-(void)unFavoriteTweet
{
    self.tweet.favorited = NO;
    self.tweet.favoriteCount -= 1;
    [self.favoriteButton setImage:[UIImage imageNamed:@"favor-icon.png"] forState:UIControlStateNormal];
    self.favoritesCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
        }
    }];
}

#pragma mark - retweeting method
- (void)retweet
{
    self.tweet.retweeted = YES;
    self.tweet.retweetCount += 1;
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green.png"] forState:UIControlStateNormal];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
        }
    }];
}

#pragma mark - unretweeting method
- (void)unRetweet
{
    self.tweet.retweeted = NO;
    self.tweet.retweetCount -= 1;
    [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon.png"] forState:UIControlStateNormal];
    self.retweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
            NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
        }
    }];
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

