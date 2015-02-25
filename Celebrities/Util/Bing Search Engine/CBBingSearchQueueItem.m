//
//  BingSearchQueueItem.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBBingSearchQueueItem.h"

@implementation CBBingSearchQueueItem

+(instancetype)queueItemWithRequest:(NSURLRequest*)request successBlock:(void(^)(NSArray*))success andErrorBlock:(void(^)(NSError*))error
{
    CBBingSearchQueueItem* item = [[CBBingSearchQueueItem alloc] init];
    [item startWithRequest:request successBlock:success andErrorBlock:error];
    return item;
}

-(void)startWithRequest:(NSURLRequest*)request successBlock:(void(^)(NSArray*))success andErrorBlock:(void(^)(NSError*))error
{
    _request = request;
    _successBlock = success;
    _errorBlock = error;
}

@end
