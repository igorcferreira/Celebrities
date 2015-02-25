//
//  BingSearchQueueItem.h
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBBingSearchQueueItem : NSObject

@property (nonatomic, readonly) void (^successBlock)(NSArray* response);
@property (nonatomic, readonly) void (^errorBlock)(NSError* error);
@property (nonatomic, readonly, strong) NSURLRequest* request;

+(instancetype)queueItemWithRequest:(NSURLRequest*)request successBlock:(void(^)(NSArray*))success andErrorBlock:(void(^)(NSError*))error;

@end
