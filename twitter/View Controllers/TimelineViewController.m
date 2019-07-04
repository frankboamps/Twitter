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

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
//@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tweetTableView;// vie controller has tableview as a subview
@property(strong, nonatomic) UIRefreshControl *tweetRefreshControl;
@property (nonatomic, strong) NSMutableArray *tweets;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tweetTableView.dataSource = self; // view controller as data source
    self.tweetTableView.delegate = self; // view controller as delegate

    self.tweetRefreshControl = [[UIRefreshControl alloc] init];
    
  //  [self fetchTweets];
    
    
    [self.tweetRefreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tweetTableView insertSubview:self.tweetRefreshControl atIndex:0];
    

//-(void) fetchTweets{
    // Get timeline
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) { // API request // API calls calls completion handler
        if (tweets) {
            self.tweets = tweets; // view controller stores data
            [self.tweetTableView reloadData]; // reload table view
            
//            NSLog(@"😎😎😎 Successfully loaded home timeline");
//            for (Tweet *tweet in tweets) {
//                NSString *text = tweet.text;
//                NSLog(@"%@", text);
//            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
        [self.tweetRefreshControl endRefreshing];
    }];
    
}


- (void)beginRefresh:(UIRefreshControl *)refreshControl
{
    // Create NSURL and NSURLRequest
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
        if (tweets) {
            self.tweets = tweets;
            [self.tweetTableView reloadData];
            //            NSLog(@"😎😎😎 Successfully loaded home timeline");
            //            for (Tweet *tweet in tweets) {
            //                NSString *text = tweet.text;
            //                NSLog(@"%@", text);
            //            }
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
    return cell; // returns instance of custom cell
}


- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;   //  table view asks for number of rows and returns number from API
}


 #pragma mark - Navigation
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     UINavigationController *navigationController = [segue destinationViewController];
     ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
     composeController.delegate = self;
 }

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.tweets addObject:tweet];
    [self.tweetTableView reloadData];
}


- (IBAction)didTapLogoutButton:(id)sender {
   // [UIApplication sharedApplication].delegate;
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

@end
