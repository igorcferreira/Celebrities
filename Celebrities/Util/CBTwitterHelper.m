//
//  CBTwitterHelper.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBTwitterHelper.h"
#import "CBConstants.h"
#import <STTwitterAPI.h>
#import <TwitterKit/TwitterKit.h>

@interface CBTwitterHelper()

@property (nonatomic, assign) BOOL loginSuccessful;
@property (nonatomic, strong) STTwitterAPI* twitterAPI;

@end

@implementation CBTwitterHelper

+(instancetype)sharedInstance
{
    static CBTwitterHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[CBTwitterHelper alloc] init];
    });
    
    if(helper)
        [helper performLoginWithComplete:^{
            helper.loginSuccessful = YES;
        } andError:^(NSError *error) {
            helper.loginSuccessful = NO;
        }];
    
    return helper;
}

-(void)performLoginWithComplete:(void(^)())completeBlock andError:(void(^)(NSError* error))errorBlock
{
    [[Twitter sharedInstance] logInGuestWithCompletion:^(TWTRGuestSession *guestSession, NSError *error) {
        if(error && errorBlock)
                errorBlock(error);
        else if(error == nil) {
            if(self.twitterAPI == nil)
                self.twitterAPI = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:TWITTER_APP_KEY consumerSecret:TWITTER_APP_SECRET];
            
            [self.twitterAPI verifyCredentialsWithSuccessBlock:^(NSString *username) {
                if(completeBlock)
                    completeBlock();
            } errorBlock:^(NSError *error) {
                if(errorBlock)
                    errorBlock(error);
            }];
        }
    }];
}

-(void)fetchTweetsForQuery:(NSString*)query complete:(void(^)(NSArray* tweets))completeBlock error:(void(^)(NSError* error))errorBlock
{
    if(self.loginSuccessful) {
        [self performFetchTweetsForQuery:query complete:completeBlock error:errorBlock];
    } else {
        [self performLoginWithComplete:^{
            [self performFetchTweetsForQuery:query complete:completeBlock error:errorBlock];
        } andError:^(NSError *error) {
            if(errorBlock)
                errorBlock(error);
        }];
    }
}

-(void)performFetchTweetsForQuery:(NSString*)query complete:(void(^)(NSArray* tweets))completeBlock error:(void(^)(NSError* error))errorBlock
{
    [self.twitterAPI getSearchTweetsWithQuery:query
                                      geocode:nil
                                        lang:[[NSLocale preferredLanguages] objectAtIndex:0]
                                      locale:nil
                                  resultType:nil
                                       count:nil
                                       until:nil
                                     sinceID:nil
                                       maxID:nil
                             includeEntities:@(YES)
                                    callback:nil
                                successBlock:^(NSDictionary *searchMetadata, NSArray *statuses) {
                                    
                                    NSMutableArray* ids = [[NSMutableArray alloc] initWithCapacity:statuses.count];
                                    
                                    for(NSDictionary* status in statuses)
                                        [ids addObject:[NSString stringWithFormat:@"%@",[status objectForKey:@"id"]]];
                                    
                                    [[[Twitter sharedInstance] APIClient] loadTweetsWithIDs:ids completion:^(NSArray *tweets, NSError *error) {
                                        if(error == nil && completeBlock)
                                            completeBlock(tweets);
                                        else if (errorBlock)
                                            errorBlock(error);
                                    }];
                                } errorBlock:^(NSError *error) {
                                    if(errorBlock)
                                        errorBlock(error);
                                }];
}

@end
