//
//  CBDataSource.h
//  Celebrities
//
//  Created by Igor Ferreira on 11/8/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CBDataSourceOperations <NSObject>

-(void)load;

-(NSInteger)rowsInSection:(NSInteger)section;
-(id)objectAtIndexPath:(NSIndexPath*)indexPath;

-(void)selectItemAtIndexPath:(NSIndexPath*)indexPath;
-(void)removeObjectAtIndexPath:(NSIndexPath*)indexPath;
-(void)addNewObjectWithIdentifier:(NSString*)identifier;
-(void)updateObject:(id)object atIndexPath:(NSIndexPath*)indexPath;

@end

@interface CBDataSource : NSObject <CBDataSourceOperations>

enum CBDataSourceProfile : NSUInteger {
    CBDataSourceProfilePlist = 1,
    CBDataSourceProfileCoreData,
    CBDataSourceProfileHTTP,
};

@property (nonatomic, assign, readonly) enum CBDataSourceProfile profile;
@property (nonatomic, assign, readonly) NSInteger sections;

@property (nonatomic, readonly) NSString* loadedNotificationKey;
@property (nonatomic, readonly) NSString* newItemNotificationKey;
@property (nonatomic, readonly) NSString* deletedNotificationKey;
@property (nonatomic, readonly) NSString* updatedNotificationKey;
@property (nonatomic, readonly) NSString* selectedItemNotificationKey;

+(instancetype)dataSourceWithProfile:(enum CBDataSourceProfile)profile;

-(void)registerObserver:(id)observer forLoadedDataSource:(SEL)selector;
-(void)registerObserver:(id)observer forNewItem:(SEL)selector;
-(void)registerObserver:(id)observer forDeletedItem:(SEL)selector;
-(void)registerObserver:(id)observer forUpdatedItem:(SEL)selector;
-(void)registerObserver:(id)observer forSelectedItem:(SEL)selector;
-(void)removeObserver:(id)observer;

@end
