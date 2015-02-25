//
//  TwitterTests.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//
#import "CBTwitterHelper.h"
#import "CBAsyncOperationTest.h"

@interface TwitterTests : CBAsyncOperationTest

@end

@implementation TwitterTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

-(void)performSearch
{
    [[CBTwitterHelper sharedInstance] fetchTweetsForQuery:@"Apple" complete:^(NSArray *tweets) {
        if(tweets == nil || tweets.count == 0)
            self.operationError = [NSError errorWithDomain:@"Invalid response" code:404 userInfo:nil];
        self.backgrounOperation = NO;
    } error:^(NSError *error) {
        self.operationError = error;
        self.backgrounOperation = NO;
    }];
    [self waitForBackgroundOperation];
}

-(void)testSearch
{
    [self performSearch];
    XCTAssertFalse(self.backgrounOperation, @"Timeout policy");
    XCTAssertNil(self.operationError, @"Error on background operation:%@",self.operationError.debugDescription);
}

-(void)testSearchPerformance
{
    [self measureBlock:^{
        [self performSearch];
    }];
}

@end
