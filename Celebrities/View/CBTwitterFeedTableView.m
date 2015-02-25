//
//  CBIndexTableView.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/8/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBTwitterFeedTableView.h"
#import "CBTwitterHelper.h"
#import <TwitterKit/TwitterKit.h>

static NSString * const TweetTableReuseIdentifier = @"TwitterCell";

@interface CBTwitterFeedTableView()

@property (nonatomic, strong) NSArray* content;
@property (nonatomic, assign) BOOL initiated;
@property (nonatomic, strong) NSString* lastQuery;
// Just for height calculation purposes, never rendered on screen
@property (nonatomic, strong) TWTRTweetTableViewCell *prototypeCell;

@end

@implementation CBTwitterFeedTableView

-(void)loadTableWithQuery:(NSString*)query
{
    if(self.lastQuery == nil || ![query isEqualToString:self.lastQuery]) {
        query = [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self setAlpha:0.0f];
        [[CBTwitterHelper sharedInstance] fetchTweetsForQuery:query complete:^(NSArray *tweets) {
            self.content = tweets;
            [self configView];
            [self reloadData];
            [self setAlpha:1.0f];
            self.lastQuery = query;
        } error:^(NSError *error) {
            if(self.content)
            {
                self.content = nil;
                [self reloadData];
            }
        }];
    }
}

-(void)configView
{
    if(!self.initiated) {
        self.estimatedRowHeight = 150;
        self.rowHeight = UITableViewAutomaticDimension;
        self.allowsSelection = NO;
        self.dataSource = self;
        self.delegate = self;
        [self registerClass:[TWTRTweetTableViewCell class] forCellReuseIdentifier:TweetTableReuseIdentifier];
    }
    
}

#pragma mark -
#pragma mark Content displayer
#pragma mark -

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    TWTRTweet *tweet = self.content[indexPath.row];
//    [self.prototypeCell configureWithTweet:tweet];
//    return [self.prototypeCell calculatedHeightForWidth: CGRectGetWidth(self.bounds)];
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.content)
        return self.content.count;
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TWTRTweet *tweet = self.content[indexPath.row];
    TWTRTweetTableViewCell* cell = (TWTRTweetTableViewCell *) [self dequeueReusableCellWithIdentifier:TweetTableReuseIdentifier forIndexPath:indexPath];
    [cell configureWithTweet:tweet];
    return cell;
}

@end
