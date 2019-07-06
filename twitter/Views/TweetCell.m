//
//  TweetCell.m
//  twitter
//
//  Created by frankboamps on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "Tweet.h"
#import "APIManager.h"
#import "UIImageView+AFNetworking.h"


@implementation TweetCell 

#pragma mark - awake from Nib
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.tweetRetweet setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateSelected];
    [self.tweetRetweet setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    [self.tweetFavorite setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateSelected];
    [self.tweetFavorite setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    UITapGestureRecognizer *profileTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTapUserProfile:)];
    [self.tweetImage addGestureRecognizer:profileTapGestureRecognizer];
    [self.tweetImage setUserInteractionEnabled:YES];
    [self.delegate tweetCell:self didTap:self.tweet.user];
}

#pragma mark - set selecting animation
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - implementing tweet favorite button
- (IBAction)tweetFavorited:(id)sender
{
    if (self.tweet.favorited){
        self.tweetFavorite.selected = NO;
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else{
        self.tweetFavorite.selected = YES;
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}

#pragma mark - implementing tap gesture
- (void) didTapUserProfile:(UITapGestureRecognizer *)sender {
   [self.delegate tweetCell:self didTap:self.tweet.user];
}

#pragma mark - implementing retweets
- (IBAction)tweetRetweeted:(id)sender
{
    if (self.tweet.retweeted) {
        self.tweetRetweet.selected = NO;
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [[APIManager shared] unRetweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error rewtweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    else{
        self.tweetRetweet.selected = YES;
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshData];
}

#pragma mark - implementing data refresh
- (void) refreshData
{
    self.tweet = self.tweet;
    self.tweetUserScreenName.text = self.tweet.user.name;
    self.tweetText.text = self.tweet.text;
    self.tweetUserName.text = self.tweet.user.screenName;
    self.tweetCreatedAt.text = self.tweet.createdAtString;
    self.tweetRetweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.tweetFavoriteCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    NSString *profileImageddress = self.tweet.user.profileImageUrl;
    NSURL *profileImageUrl = [NSURL URLWithString:profileImageddress];
    self.tweetImage.image = nil;
    [self.tweetImage setImageWithURL:profileImageUrl];
}


@end
