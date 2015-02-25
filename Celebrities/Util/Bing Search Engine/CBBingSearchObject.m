//
//  CBBingSearchObject.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBBingSearchObject.h"

@implementation CBBingSearchObject

@synthesize ID = _ID;
@synthesize title = _title;

+(NSArray*)parseResponse:(NSArray*)data
{
    if(data == nil || data.count == 0)
        return nil;
    NSMutableArray* response = nil;
    
    for(NSDictionary* item in data) {
        CBBingSearchObject* object = [[CBBingSearchObject alloc] initWithContent:item];
        if(object && object.ID && ![object.ID isEqualToString:@""]) {
            if(response == nil)
                response = [[NSMutableArray alloc] initWithCapacity:data.count];
            [response addObject:object];
        }
    }
    
    return response;
}

-(id)initWithContent:(NSDictionary*)content
{
    self = [super init];
    if(self) {
        id temp = [content objectForKey:@"ID"];
        if(temp && [temp isKindOfClass:[NSString class]]) {
            _ID = temp;
            _title = [content objectForKey:@"Title"];
        }
    }
    return self;
}

@end
