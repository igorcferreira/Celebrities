//
//  CBDataSourceTest.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/8/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CBDataSource.h"

@interface CBDataSourceTest : XCTestCase

@property (nonatomic, strong) CBDataSource* dataSource;
@property (nonatomic, assign) BOOL loaded;

@end

@implementation CBDataSourceTest

-(void)setUp
{
    [super setUp];
    self.dataSource = [CBDataSource dataSourceWithProfile:CBDataSourceProfilePlist];
    [self.dataSource registerObserver:self forLoadedDataSource:@selector(loadedItem:)];
    self.loaded = NO;
}

-(void)tearDown
{
    [super tearDown];
    [self.dataSource removeObserver:self];
}

-(void)loadedItem:(NSNotification*)notification
{
    self.loaded = YES;
}

-(void)performLoad
{
    self.loaded = NO;
    [self.dataSource load];
}

-(void)waitForValidState:(NSUInteger)index
{
    CGFloat passedTime = 0.1;
    BOOL state = NO;
    while(!state && passedTime < 20.0f) {
        switch (index) {
            case 0:
                state = self.loaded;
                break;
            default:
                state = NO;
                break;
        }
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
        passedTime += 0.1f;
    };
}

-(void)testLoad
{
    XCTAssertNotNil(self.dataSource, @"Empty data source");
    [self performLoad];
    [self waitForValidState:0];
    XCTAssertTrue(self.loaded, @"Data source failed to load");
}

-(void)testLoadPerformance
{
    [self measureBlock:^{
        [self performLoad];
        [self waitForValidState:0];
    }];
}

@end
