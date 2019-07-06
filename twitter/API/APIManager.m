//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"KOoFnE3oXvWTJul7AsBDMXPtc";
static NSString * const consumerSecret = @"0skqVPI0l1M5OYMY3hSn0BCawSZt9dB6wLSdeiqzhDCWUpnpNQ";

@interface APIManager()

@end

@implementation APIManager

#pragma Mark API implementation
+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

#pragma mark - Setting init
- (instancetype)init
{
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
    }
    return self;
}

#pragma mark - Getting Home Timeline API
- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion
{
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       // Success
       NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
       completion(tweets, nil);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       // There was a problem
       completion(nil, error);
   }];
}

#pragma mark - getting post status API
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion
{
    NSString *urlString = @"1.1/statuses/update.json";
    NSDictionary *parameters = @{@"status": text};
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

#pragma mark - favoriting API
- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion
{
    NSString *urlString = @"1.1/favorites/create.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

#pragma mark - retweeting API
- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion
{
    NSString *urlString = [NSString stringWithFormat: @"1.1/statuses/retweet/%@.json", tweet.idStr] ;
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

#pragma mark - unretweeting API
-(void) unRetweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion
{
    NSString *urlString = [NSString stringWithFormat: @"1.1/statuses/unretweet/%@.json", tweet.idStr];
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}

#pragma mark - unfavoriting API
- (void)unFavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/favorites/destroy.json";
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
    
}

#pragma mark - loading more home timeline API
-(void) loadmoregetHomeTimelineWithparam:(NSDictionary *)parameters completion:(void (^)(NSArray *tweets, NSError *))completion{
    [self GET:@"1.1/statuses/home_timeline.json"
   parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
       NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
       completion(tweets, nil);
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       completion(nil, error);
   }];
}


@end
