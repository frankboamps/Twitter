//
//  ProfileViewController.h
//  twitter
//
//  Created by frankboamps on 7/4/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APIManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ProfileViewControllerDelegate
- (void)didTweet:(Tweet *)tweet;
@end

@interface ProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profileBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *profileUserName;
@property (weak, nonatomic) IBOutlet UILabel *profileActualUserName;
@property (weak, nonatomic) IBOutlet UILabel *profileUserBio;

@property (nonatomic, weak) id<ProfileViewControllerDelegate> delegate;
@property(nonatomic, strong)Tweet *tweet;
@property(nonatomic, strong)User *user;
@end

NS_ASSUME_NONNULL_END
