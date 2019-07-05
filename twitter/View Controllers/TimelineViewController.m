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


@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate, UIScrollViewDelegate>
//@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;// view controller has tableview as a subview
@property(strong, nonatomic) UIRefreshControl *tweetRefreshControl;
@property (nonatomic, strong) NSMutableArray *tweets;
@property (assign, nonatomic) BOOL isMoreDataLoading;

@end

@implementation TimelineViewController


bool isMoreDataLoading = false;
InfiniteScrollActivityView* loadingMoreView;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.tweetTableView.dataSource = self; // view controller as data source
    self.tweetTableView.delegate = self; // view controller as delegate
    self.tweetRefreshControl = [[UIRefreshControl alloc] init];
    [self.tweetRefreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tweetTableView insertSubview:self.tweetRefreshControl atIndex:0];
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) { // API request // API calls calls completion handler
        if (tweets) {
            self.tweets = tweets; // view controller stores data
            [self.tweetTableView reloadData]; // reload table view
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{  // table view requests for cell for row at and use reuse identifier
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell" forIndexPath:indexPath];
   // TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.tweets[indexPath.row];
    cell.tweet = tweet;
    cell.tweetUserScreenName.text = tweet.user.name;
    cell.tweetText.text = tweet.text;
    cell.tweetUserName.text = tweet.user.screenName;
    cell.tweetCreatedAt.text = tweet.createdAtString;
    cell.tweetRetweetCount.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.tweetFavoriteCount.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    NSString *profileImageddress = tweet.user.profileImageUrl;
    NSURL *profileImageUrl = [NSURL URLWithString:profileImageddress];
    cell.tweetImage.image = nil;
    [cell.tweetImage setImageWithURL:profileImageUrl];
    //[cell.tweetImage setImage: [UIImage imageNamed:@"profile-icon"]];
    cell.delegate = self;
    return cell; // returns instance of custom cell
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;   //  table view asks for number of rows and returns number from API
}


 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
     UINavigationController *navigationController = [segue destinationViewController];
     ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
     composeController.delegate = self;
 }


- (void)didTweet:(nonnull Tweet *)tweet
{
    [self.tweets addObject:tweet];
    [self.tweetTableView reloadData];
}


- (IBAction)didTapLogoutButton:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}


-(NSString *)dateDiff:(NSString *)origDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setFormatterBehavior:NSDateFormatterBehavior10_4];
    [df setDateFormat:@"EEE, dd MMM yy HH:mm:ss VVVV"];
    NSDate *convertedDate = [df dateFromString:origDate];
    NSDate *todayDate = [NSDate date];
    double ti = [convertedDate timeIntervalSinceDate:todayDate];
    ti = ti * -1;
    if(ti < 1) {
        return @"never";
    } else  if (ti < 60) {
        return @"less than a minute ago";
    } else if (ti < 3600) {
        int diff = round(ti / 60);
        return [NSString stringWithFormat:@"%d minutes ago", diff];
    } else if (ti < 86400) {
        int diff = round(ti / 60 / 60);
        return[NSString stringWithFormat:@"%d hours ago", diff];
    } else if (ti < 2629743) {
        int diff = round(ti / 60 / 60 / 24);
        return[NSString stringWithFormat:@"%d days ago", diff];
    } else {
        return @"never";
    }
}


- (void)tweetCell:(TweetCell *)tweetCell didTap:(User *)user
{
    [self performSegueWithIdentifier:@"profileSegue" sender:user];
}


-(void) loadMoreData{
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets;
            [self.tweetTableView reloadData];
        }
        else {
            self.isMoreDataLoading = false;
            [loadingMoreView stopAnimating];
            [self.tweetTableView reloadData];
        }
        [self.tweetRefreshControl endRefreshing];
    }];
    //[task resume];
}

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

@end
