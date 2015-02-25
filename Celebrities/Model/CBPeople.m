//
//  CBPeople.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/9/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBPeople.h"

@implementation CBPeople

-(instancetype)initWithContent:(NSDictionary*)content
{
    self = [super init];
    if(self && content)
    {
        self.firstName = [content objectForKey:@"firstName"];
        self.lastName = [content objectForKey:@"lastName"];
        self.age = [content objectForKey:@"age"];
        id temp = [content objectForKey:@"image"];
        if(temp && [temp isKindOfClass:[NSString class]])
            self.imageUrl = [NSURL URLWithString:temp];
    }
    return self;
}

-(instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if(self && name)
        [self setName:name];
    return self;
}

-(void)setName:(NSString *)name
{
    NSArray* components = [[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@" "];
    if(components && components.count > 0) {
        self.firstName = [components firstObject];
        if(components.count > 1)
            self.lastName = [components lastObject];
        else
            self.lastName = nil;
    }
}

-(NSString*)name
{
    if(self.firstName && self.lastName)
        return [NSString stringWithFormat:@"%@ %@",self.firstName, self.lastName];
    else if(self.firstName)
        return self.firstName;
    else
        return nil;
}

@end