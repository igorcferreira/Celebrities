//
//  CBBingSearch.h
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CBBingSearchImage.h"

@interface CBBingSearchEngine : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

+(instancetype)bingSearchEngineWithKey:(NSString*)key;
-(void)searchImageWithQuery:(NSString*)query withSuccess:(void(^)(NSArray*))success andError:(void(^)(NSError*))error;
-(void)cancelAll;
@end
