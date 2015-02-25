//
//  CBTwitterHelper.h
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBTwitterHelper : NSObject

+(instancetype)sharedInstance;
-(void)fetchTweetsForQuery:(NSString*)query complete:(void(^)(NSArray* tweets))complete error:(void(^)(NSError* error))error;

@end
