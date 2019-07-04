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

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.tweetRetweet setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateSelected];
    [self.tweetRetweet setImage:[UIImage imageNamed:@"retweet-icon"] forState:UIControlStateNormal];
    [self.tweetFavorite setImage:[UIImage imageNamed:@"favor-icon-red"] forState:UIControlStateSelected];
    [self.tweetFavorite setImage:[UIImage imageNamed:@"favor-icon"] forState:UIControlStateNormal];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}


- (IBAction)tweetFavorited:(id)sender
{
    // already favcorited
    if (self.tweet.favorited){
        // set button view to grey
        self.tweetFavorite.selected = NO;
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        
        [[APIManager shared] unFavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
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


- (IBAction)tweetRetweeted:(id)sender
{
//    [self.tweetRetweet setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:UIControlStateNormal];
    
    if (self.tweet.retweeted) {
        
        self.tweetRetweet.selected = NO;
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error rewtweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
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


- (void) refreshData{
    // self.tweetText.text = self.tweet.text;
    //self
    
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
