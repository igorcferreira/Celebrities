//
//  CBAsyncOperationTest.h
//  Celebrities
//
//  Created by Igor Ferreira on 11/8/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#ifndef Celebrities_CBAsyncOperationTest_h
#define Celebrities_CBAsyncOperationTest_h

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

@interface CBAsyncOperationTest : XCTestCase
@property NSError* operationError;
@property BOOL backgrounOperation;

-(void)waitForBackgroundOperation;
@end

#endif