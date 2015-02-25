//
//  CBBingSerchImage.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBBingSearchImage.h"

@implementation CBBingSearchImage

@synthesize ID = _ID;
@synthesize title = _title;

+(NSArray*)parseResponse:(NSArray*)data
{
    if(data == nil || data.count == 0)
        return nil;
    NSMutableArray* response = nil;
    
    for(NSDictionary* item in data) {
        CBBingSearchImage* image = [[CBBingSearchImage alloc] initWithContent:item];
        if(image && image.ID && ![image.ID isEqualToString:@""]) {
            if(response == nil)
                response = [[NSMutableArray alloc] initWithCapacity:data.count];
            [response addObject:image];
        }
    }
    
    return response;
}

-(id)initWithContent:(NSDictionary*)content
{
    self = [super init];
    if(self) {
        _ID = [content objectForKey:@"ID"];
        _title = [content objectForKey:@"Title"];
        _imageUrl = [[NSURL alloc] initWithString:[content objectForKey:@"MediaUrl"]];
        _pageUrl = [[NSURL alloc] initWithString:[content objectForKey:@"SourceUrl"]];
        _width = [[content objectForKey:@"Width"] integerValue];
        _height = [[content objectForKey:@"Height"] integerValue];
        _fileSize = [[content objectForKey:@"FileSize"] integerValue];
    }
    return self;
}

@end