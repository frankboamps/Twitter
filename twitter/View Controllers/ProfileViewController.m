//
//  ProfileViewController.m
//  twitter
//
//  Created by frankboamps on 7/4/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "ProfileViewController.h"
#import "Tweet.h"
#import "UIImageView+AFNetworking.h"
#import "DateTools.h"
#import "APIManager.h"
#import "TTTAttributedLabel.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *profileScreenName;
@property (weak, nonatomic) IBOutlet UILabel *profileUser;
@property (weak, nonatomic) IBOutlet UILabel *profileBio;
@property (weak, nonatomic) IBOutlet UITableView *profileTableView;

@end

@implementation ProfileViewController

#pragma mark - View controller life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.profileUser.text = self.user.name;
    self.profileScreenName.text = self.user.screenName;
    NSString *profileImageAddress = self.user.profileImageUrl;
    NSURL *profileImageUrl = [NSURL URLWithString:profileImageAddress];
    self.profileImage.image = nil;
   [self.profileImage setImageWithURL:profileImageUrl];
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
