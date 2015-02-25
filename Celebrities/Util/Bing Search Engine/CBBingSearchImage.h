//
//  CBBingSerchImage.h
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CBBingSearchObject.h"

@interface CBBingSearchImage : CBBingSearchObject

@property (nonatomic, strong, readonly) NSURL* imageUrl;
@property (nonatomic, strong, readonly) NSURL* pageUrl;
@property (nonatomic, assign, readonly) NSInteger width;
@property (nonatomic, assign, readonly) NSInteger height;
@property (nonatomic, assign, readonly) NSInteger fileSize;

@end
