//
//  Tweet.h
//  twitter
//
//  Created by frankboamps on 7/1/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
# import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *idStr;
@property (strong, nonatomic) NSString *text;
@property (nonatomic) int favoriteCount;
@property (nonatomic) BOOL favorited;
@property (nonatomic) int retweetCount;
@property (nonatomic) BOOL retweeted;
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) NSString *createdAtString;
@property(strong, nonatomic) NSDate *createdAtTime;
@property (strong, nonatomic) User *retweetedByUser;

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;


@end

NS_ASSUME_NONNULL_END
