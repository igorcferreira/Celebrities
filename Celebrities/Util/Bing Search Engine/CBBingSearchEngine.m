//
//  CBBingSearch.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBBingSearchEngine.h"
#import "CBBingSearchQueueItem.h"

#define SEARCH_URL          @"https://api.datamarket.azure.com"
#define IMAGE_SEARCH_PATH   @"/Bing/Search/v1/Image"
#define RESPONSE_TYPE @"application/json; charset=utf-8"

@interface CBBingSearchEngine()

@property (nonatomic, strong) NSString* key;
@property (nonatomic, strong) NSMutableArray* requestItens;
@property (nonatomic, strong) CBBingSearchQueueItem* currentItem;
@property (nonatomic, strong) NSURLConnection* currentConnection;
@property (nonatomic, strong) NSMutableData* buffer;

@end

@implementation CBBingSearchEngine

+(instancetype)bingSearchEngineWithKey:(NSString*)key
{
    CBBingSearchEngine* searchEngine = [[CBBingSearchEngine alloc] init];
    [searchEngine configEngineWithKey:key];
    return searchEngine;
}

-(void)configEngineWithKey:(NSString*)key
{
    self.key = key;
    self.requestItens = [[NSMutableArray alloc] init];
}

-(void)searchImageWithQuery:(NSString*)query withSuccess:(void(^)(NSArray* succes))success andError:(void(^)(NSError* error))error
{
    NSURLQueryItem* queryItem = [[NSURLQueryItem alloc] initWithName:@"Query" value:[NSString stringWithFormat:@"'%@'",query]];
    NSURLQueryItem* strictItem = [[NSURLQueryItem alloc] initWithName:@"Adult" value:@"'Strict'"];
//    NSURLQueryItem* filterItem = [[NSURLQueryItem alloc] initWithName:@"ImageFilters" value:@"'Style:Photo'"];
    NSURLComponents* components = [[NSURLComponents alloc] initWithString:SEARCH_URL];
    [components setPath:IMAGE_SEARCH_PATH];
    [components setQueryItems:@[queryItem, strictItem]];
    
    NSString* url = components.URL.absoluteString;
    url = [url stringByAppendingString:@"&ImageFilters=%27Style%3APhoto%2BSize%3ASmall%27"];
    
    NSMutableURLRequest* imageRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:1000];
    [imageRequest addValue:RESPONSE_TYPE forHTTPHeaderField:@"Accept"];
    [imageRequest addValue:[NSString stringWithFormat:@"Basic %@",self.key] forHTTPHeaderField:@"Authorization"];
    
    NSLog(@"%@",imageRequest.URL);
    
    [self performQueueItem:[CBBingSearchQueueItem queueItemWithRequest:imageRequest successBlock:success andErrorBlock:error]];
}

-(void)performQueueItem:(CBBingSearchQueueItem*)item
{
    [self.requestItens addObject:item];
    [self performQueue];
}

-(void)performQueue
{
    if(self.currentConnection == nil) {
        if([self.requestItens count] > 0) {
            self.currentItem = [self.requestItens objectAtIndex:0];
            [self.requestItens removeObjectAtIndex:0];
            self.currentConnection = [[NSURLConnection alloc] initWithRequest:self.currentItem.request delegate:self startImmediately:YES];
        }
    }
}

-(NSArray*)formatDataResponse:(NSData*)data error:(NSError**)error
{
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
    if(*error != nil)
        return nil;
    if(object && [object isKindOfClass:[NSDictionary class]]) {
        id root = [object objectForKey:@"d"];
        if(root && [root isKindOfClass:[NSDictionary class]]) {
            id response = [root objectForKey:@"results"];
            if(response && [response isKindOfClass:[NSArray class]])
                return response;
        }
    }
    
    *error = [NSError errorWithDomain:@"Parse error" code:0 userInfo:nil];
    
    return nil;
}

-(void)cleanUp
{
    if(self.currentConnection)
        [self.currentConnection cancel];
    if(self.buffer) {
        self.buffer.length = 0;
        self.buffer = nil;
    }
    self.currentConnection = nil;
    self.currentItem = nil;
}

-(void)cancelAll
{
    [self cleanUp];
    [self.requestItens removeAllObjects];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if(self.currentItem && self.currentItem.errorBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.currentItem.errorBlock(error);
        });
    }
    [self cleanUp];
    [self performQueue];

}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(self.currentItem && self.buffer) {
        NSError* error = nil;
        
        NSArray* response = [self formatDataResponse:self.buffer error:&error];
        if(error) {
            if(self.currentItem.errorBlock)
                self.currentItem.errorBlock(error);
        } else {
            if([self.currentItem.request.URL.path isEqualToString:IMAGE_SEARCH_PATH]) {
                response = [CBBingSearchImage parseResponse:response];
            } else {
                response = [CBBingSearchObject parseResponse:response];
            }
            
            if(self.currentItem.successBlock)
                self.currentItem.successBlock(response);
        }
        [self cleanUp];
        [self performQueue];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if(self.buffer == nil)
        self.buffer = [[NSMutableData alloc] initWithData:data];
    else
        [self.buffer appendData:data];
}


@end
