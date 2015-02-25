//
//  CBPeople.h
//  Celebrities
//
//  Created by Igor Ferreira on 11/9/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBPeople : NSObject

@property (nonatomic, strong)   NSString*   firstName;
@property (nonatomic, strong)   NSString*   lastName;
@property (nonatomic, strong)   NSNumber*   age;
@property (nonatomic, strong)   NSURL*      imageUrl;
@property (nonatomic)           NSString*   name;

-(instancetype)initWithContent:(NSDictionary*)content;
-(instancetype)initWithName:(NSString*)name;

@end
