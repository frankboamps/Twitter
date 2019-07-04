//
//  TweetCell.h
//  twitter
//
//  Created by frankboamps on 7/2/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetCell : UITableViewCell

@property (strong, nonatomic) Tweet *tweet;
@property (weak, nonatomic) IBOutlet UIImageView *tweetImage;
@property (weak, nonatomic) IBOutlet UILabel *tweetUserName;
@property (weak, nonatomic) IBOutlet UILabel *tweetUserScreenName;
@property (weak, nonatomic) IBOutlet UILabel *tweetCreatedAt;
@property (weak, nonatomic) IBOutlet UILabel *tweetText;
@property (weak, nonatomic) IBOutlet UIButton *tweetRetweet;
@property (weak, nonatomic) IBOutlet UIButton *tweetFavorite;
@property (weak, nonatomic) IBOutlet UILabel *tweetRetweetCount;
@property (weak, nonatomic) IBOutlet UILabel *tweetFavoriteCount;


- (IBAction)tweetRetweeted:(id)sender;
- (IBAction)tweetFavorited:(id)sender;


@end

NS_ASSUME_NONNULL_END