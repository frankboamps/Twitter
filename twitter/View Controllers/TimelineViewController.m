//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "Tweet.h"
#import "TweetCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "InfiniteScrollActivityView.h"
#import "ProfileViewController.h"
#import "DateTools.h"
#import "TTTAttributedLabel.h"
#import "TweetDetailsViewController.h"


@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, UIScrollViewDelegate, TTTAttributedLabelDelegate, ProfileViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;
@property(strong, nonatomic) UIRefreshControl *tweetRefreshControl;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation TimelineViewController

bool isMoreDataLoading = NO;
InfiniteScrollActivityView* loadingMoreView;


#pragma mark - viewcontrollwer lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tweetTableView.dataSource = self;
    self.tweetTableView.delegate = self;
    self.tweetRefreshControl = [[UIRefreshControl alloc] init];
    [self.tweetRefreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tweetTableView insertSubview:self.tweetRefreshControl atIndex:0];
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets;
            [self.tweetTableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.tweetRefreshControl endRefreshing];
    }];
    CGRect frame = CGRectMake(0, self.tweetTableView.contentSize.height, self.tweetTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
    loadingMoreView = [[InfiniteScrollActivityView alloc] initWithFrame:frame];
    loadingMoreView.hidden = true;
    [self.tweetTableView addSubview:loadingMoreView];
    UIEdgeInsets insets = self.tweetTableView.contentInset;
    insets.bottom += InfiniteScrollActivityView.defaultHeight;
    self.tweetTableView.contentInset = insets;
}

#pragma mark - refresh control
- (void)beginRefresh:(UIRefreshControl *)refreshControl
{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets;
            [self.tweetTableView reloadData];
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.tweetRefreshControl endRefreshing];
    }];
}

#pragma mark - memory call
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
    Tweet *tweet = self.tweets[indexPath.row];
    cell.delegate = self;
    cell.tweet = tweet;
    cell.tweetUserScreenName.text = tweet.user.name;
    TTTAttributedLabel *attributedLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:tweet.text
                                                                    attributes:@{
                                                                                 (id)kCTForegroundColorAttributeName : (id)[UIColor blackColor].CGColor,
                                                                                 NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-light" size:16.0f],
                                                                                 NSKernAttributeName : [NSNull null],
                                                                                 (id)kTTTBackgroundFillColorAttributeName : (id)[UIColor whiteColor].CGColor
                                                                                 }];
    cell.tweetText.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    cell.tweetText.delegate = self;
    cell.tweetText.text = attString;
    cell.tweetUserName.text = tweet.user.screenName;
    cell.tweetCreatedAt.text = tweet.createdAtString;
    NSString *pastTime;
    NSDate *now = [NSDate date];
    NSDate *tweetDate = tweet.createdAtTime;
    long monthDiff = [now monthsFrom:tweetDate];
    long dayDiff = [now daysFrom:tweetDate];
    long hourDiff = [now hoursFrom:tweetDate];
    long minuteDiff = [now minutesFrom:tweetDate];
    long secondDiff = [now secondsFrom:tweetDate];
    if (monthDiff == 0){
        if (dayDiff != 0){
            pastTime = [[NSString stringWithFormat:@"%lu", dayDiff] stringByAppendingString:@"d"];
        }
        else if (hourDiff != 0){
            pastTime = [[NSString stringWithFormat:@"%lu", hourDiff] stringByAppendingString:@"h"];
        }
        else if (minuteDiff != 0){
            pastTime = [[NSString stringWithFormat:@"%lu", minuteDiff] stringByAppendingString:@"m"];
        }
        else if (secondDiff != 0){
            pastTime = [[NSString stringWithFormat:@"%lu", secondDiff] stringByAppendingString:@"s"];
        }
        cell.tweetCreatedAt.text = pastTime;
    }
    cell.tweetRetweetCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.tweetFavoriteCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    NSString *profileImageddress = tweet.user.profileImageUrl;
    NSURL *profileImageUrl = [NSURL URLWithString:profileImageddress];
    cell.tweetImage.image = nil;
    [cell.tweetImage setImageWithURL:profileImageUrl];
    return cell;
}

#pragma mark tableView number of rows
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"NavigationToTweet"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    else if ([[segue identifier] isEqualToString:@"ProfileViewController"]){
        UINavigationController *navigationController = [segue destinationViewController];
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tweetTableView indexPathForCell:tappedCell];
        Tweet *tweet = self.tweets[indexPath.row];
        User *user = tweet.user;
        ProfileViewController *profileController = (ProfileViewController *)navigationController;
        profileController.delegate = self;
        profileController.user = user;
    }
    else if ([[segue identifier] isEqualToString:@"detailView"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tweetTableView indexPathForCell:tappedCell];
    
        Tweet *tweet = self.tweets[indexPath.row];
        TweetDetailsViewController *tweetDetailViewController = [segue destinationViewController];
        tweetDetailViewController.tweet = tweet;
    }
}

# pragma mark - reloading data
- (void)didTweet:(nonnull Tweet *)tweet
{
    [self.tweets insertObject:tweet atIndex: 0];
    [self.tweetTableView reloadData];
}

#pragma mark - LogoutButton
- (IBAction)didTapLogoutButton:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

#pragma  mark - TweetCellDelegate
- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user
{
    [self performSegueWithIdentifier:@"ProfileViewController" sender:user];
}

#pragma mark - Load more data
-(void) loadMoreData
{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    Tweet *tweetId = [self.tweets  lastObject];
    NSNumber *myIdNumber = [f numberFromString: tweetId.idStr];
    long long myIdInt = [myIdNumber longLongValue] -1 ;
    NSNumber *myMaxId = @(myIdInt);
    NSDictionary *parameters = @{@"max_id": myMaxId};
    [[APIManager shared]loadmoregetHomeTimelineWithparam:parameters completion:^(NSArray *tweets, NSError *error){
        if (tweets) {
            [self.tweets addObjectsFromArray:tweets];
            [self.tweetTableView reloadData];
        }
        else {
            self.isMoreDataLoading = false;
            [loadingMoreView stopAnimating];
            [self.tweetTableView reloadData];
        }
        [self.tweetRefreshControl endRefreshing];
    }];
}

#pragma  mark - Infinite Scroll implementation
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!self.isMoreDataLoading){
        int scrollViewContentHeight = self.tweetTableView.contentSize.height;
        int scrollOffsetThreshold = scrollViewContentHeight - self.tweetTableView.bounds.size.height;
        if(scrollView.contentOffset.y > scrollOffsetThreshold && self.tweetTableView.isDragging) {
            self.isMoreDataLoading = true;
            CGRect frame = CGRectMake(0, self.tweetTableView.contentSize.height, self.tweetTableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight);
            loadingMoreView.frame = frame;
            [loadingMoreView startAnimating];
            [self loadMoreData];
        }
    }
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

@end
