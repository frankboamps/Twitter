//
//  InfiniteScrollActivityView.m
//  twitter
//
//  Created by frankboamps on 7/4/19.
//  Copyright © 2019 Emerson Malca. All rights reserved.
//

#import "InfiniteScrollActivityView.h"

@implementation InfiniteScrollActivityView

UIActivityIndicatorView* activityIndicatorView;
static CGFloat _defaultHeight = 60.0;

+ (CGFloat)defaultHeight{
    return _defaultHeight;
}

#pragma mark - initiating coder
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self setupActivityIndicator];
    }
    return self;
}

#pragma mark - initiating frame
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setupActivityIndicator];
    }
    return self;
}

#pragma mark - setting layout subviews
- (void)layoutSubviews{
    [super layoutSubviews];
    activityIndicatorView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

#pragma mark - setting up activity
- (void)setupActivityIndicator{
    activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicatorView.hidesWhenStopped = true;
    [self addSubview:activityIndicatorView];
}

#pragma mark - stopping animation
-(void)stopAnimating{
    [activityIndicatorView stopAnimating];
    self.hidden = true;
}

#pragma mark - starting animation
-(void)startAnimating{
    self.hidden = false;
    [activityIndicatorView startAnimating];
}

@end
