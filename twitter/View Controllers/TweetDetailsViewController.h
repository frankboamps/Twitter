//
//  TweetDetailsViewController.h
//  twitter
//
//  Created by frankboamps on 7/4/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tweet.h"

NS_ASSUME_NONNULL_BEGIN

@interface TweetDetailsViewController : UIViewController
@property(strong, nonatomic) Tweet *tweet;

@end

NS_ASSUME_NONNULL_END
