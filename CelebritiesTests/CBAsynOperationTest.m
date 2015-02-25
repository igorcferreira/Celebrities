//
//  CBAsynOperationTest.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/8/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBAsyncOperationTest.h"

@implementation CBAsyncOperationTest

-(void)setUp
{
    [super setUp];
}

-(void)tearDown
{
    [super tearDown];
}

-(void)waitForBackgroundOperation
{
    self.backgrounOperation = YES;
    self.operationError = nil;
    CGFloat passedTime = 0.1;
    while(self.backgrounOperation && passedTime < 20.0f) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        passedTime += 0.1f;
    };
}
@end
