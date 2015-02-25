//
//  CBBingSearchObject.h
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBBingSearchObject : NSObject

@property (nonatomic, strong, readonly) NSString* ID;
@property (nonatomic, strong, readonly) NSString* title;

+(NSArray*)parseResponse:(NSArray*)data;
-(id)initWithContent:(NSDictionary*)content;

@end
