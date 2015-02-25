//
//  CBBingSearchEngineTests.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBConstants.h"
#import "CBBingSearchEngine.h"
#import "CBBingSearchImage.h"
#import "CBAsyncOperationTest.h"

@interface CBBingSearchEngineTests : CBAsyncOperationTest

@property (nonatomic, strong) CBBingSearchEngine* searchEngine;

@end

@implementation CBBingSearchEngineTests

- (void)setUp {
    [super setUp];
    self.searchEngine = [CBBingSearchEngine bingSearchEngineWithKey:BING_SEARCH_KEY];
}

- (void)tearDown {
    [super tearDown];
    [self.searchEngine cancelAll];
}

-(void)downloadImages {
    [self.searchEngine searchImageWithQuery:@"Apple" withSuccess:^(NSArray* results) {
        if(results == nil || results.count == 0) {
            self.operationError = [NSError errorWithDomain:@"Empty result" code:404 userInfo:nil];
        } else {
            id object = [results objectAtIndex:0];
            if(![object isKindOfClass:[CBBingSearchImage class]])
                self.operationError = [NSError errorWithDomain:@"Invalid result" code:404 userInfo:nil];
        }
        
        self.backgrounOperation = NO;
    } andError:^(NSError* error) {
        self.operationError = error;
        self.backgrounOperation = NO;
    }];
    [self waitForBackgroundOperation];
}

-(void)testDownloadImages {
    [self downloadImages];
    XCTAssertFalse(self.backgrounOperation, @"Timeout policy");
    XCTAssertNil(self.operationError, @"Error on background operation:%@",self.operationError.debugDescription);
}

- (void)testPerformanceDownloadImages {
    // This is an example of a performance test case.
    [self measureBlock:^{
        [self downloadImages];
    }];
}

@end
