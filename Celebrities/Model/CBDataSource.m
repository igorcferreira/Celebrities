//
//  CBDataSource.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/8/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBDataSource.h"
#import "CBPlistDataSource.h"

@interface CBDataSource()

+(instancetype)sharedInstace;

@end

@implementation CBDataSource

#pragma mark -
#pragma mark Data source factory
#pragma mark -

+(instancetype)dataSourceWithProfile:(enum CBDataSourceProfile)profile
{
    switch (profile) {
        case CBDataSourceProfilePlist:
            return [CBPlistDataSource sharedInstace];
            break;
        default:
            return [CBDataSource sharedInstace];
            break;
    }
}

#pragma mark -
#pragma mark Notification Center register control
#pragma mark -

-(void)registerObserver:(id)observer forLoadedDataSource:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:[self loadedNotificationKey] object:nil];
}
-(void)registerObserver:(id)observer forNewItem:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:[self newItemNotificationKey] object:nil];
}
-(void)registerObserver:(id)observer forDeletedItem:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:[self deletedNotificationKey] object:nil];
}
-(void)registerObserver:(id)observer forUpdatedItem:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:[self updatedNotificationKey] object:nil];
}
-(void)registerObserver:(id)observer forSelectedItem:(SEL)selector
{
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:[self selectedItemNotificationKey] object:nil];
}

-(void)removeObserver:(id)observer
{
    [[NSNotificationCenter defaultCenter] removeObserver:observer];
}

-(NSString*)loadedNotificationKey
{
    return [NSString stringWithFormat:@"datasource_%u_loaded",self.profile];
}

-(NSString*)newItemNotificationKey
{
    return [NSString stringWithFormat:@"datasource_%u_new_item",self.profile];
}

-(NSString*)deletedNotificationKey
{
    return [NSString stringWithFormat:@"datasource_%u_deleted_item",self.profile];
}

-(NSString*)updatedNotificationKey
{
    return [NSString stringWithFormat:@"datasource_%u_update_item",self.profile];
}

-(NSString*)selectedItemNotificationKey
{
    return [NSString stringWithFormat:@"datasource_%u_selected_item",self.profile];
}

#pragma mark -
#pragma mark Empty protocol implementation
#pragma mark -

+(instancetype)sharedInstace { return nil; };

-(void)load {}

-(NSInteger)rowsInSection:(NSInteger)section { return 0; }
-(id)objectAtIndexPath:(NSIndexPath*)indexPath { return nil; }

-(void)selectItemAtIndexPath:(NSIndexPath*)indexPath {}
-(void)removeObjectAtIndexPath:(NSIndexPath*)indexPath {}
-(void)addNewObjectWithIdentifier:(NSString*)identifier {}
-(void)updateObject:(id)object atIndexPath:(NSIndexPath*)indexPath {}

@end