//
//  CBPlistDataSource.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/8/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBPlistDataSource.h"
#import "CBPeople.h"

#define PLIST_FILE_NAME @"people"

@interface CBPlistDataSource()

@property (nonatomic, strong) NSMutableArray* objects;

@end

@implementation CBPlistDataSource

@synthesize sections = _sections;
@synthesize profile = _profile;

+(instancetype)sharedInstace
{
    static CBPlistDataSource* dataSource;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        dataSource = [[CBPlistDataSource alloc] init];
    });
    return dataSource;
}

-(instancetype)init
{
    self = [super init];
    if(self)
        _profile = CBDataSourceProfilePlist;
    return self;
}

-(void)load
{
    if(self.objects == nil) {
        self.objects = [[NSMutableArray alloc] init];
        _sections = 1;
        BOOL locaFileExist = [self localFileExists];
        NSString* filePath;
        if(locaFileExist)
            filePath = [self localFilePath];
        else
            filePath = [[NSBundle mainBundle] pathForResource:PLIST_FILE_NAME ofType:@"plist"];
        NSArray* elements = [NSArray arrayWithContentsOfFile:filePath];
        for(NSDictionary* element in elements)
            [self.objects addObject:[[CBPeople alloc] initWithContent:element]];
        if(!locaFileExist)
            [self saveContent];
        locaFileExist = [self localFileExists];
        NSLog(@"%@",[self localFilePath]);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:[self loadedNotificationKey] object:self];
}

-(NSString*)localFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",PLIST_FILE_NAME]];
}

-(BOOL)localFileExists
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self localFilePath]];
}

-(void)saveContent
{
    [[NSArray arrayWithArray:self.objects] writeToFile:[self localFilePath] atomically:YES];
}

-(NSInteger)rowsInSection:(NSInteger)section
{
    return self.objects.count;
}

-(id)objectAtIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.row < self.objects.count)
        return [self.objects objectAtIndex:indexPath.row];
    else
        return nil;
}

-(void)addNewObjectWithIdentifier:(NSString *)identifier
{
    [self.objects insertObject:[[CBPeople alloc] initWithName:identifier] atIndex:0];
    [self saveContent];
    [[NSNotificationCenter defaultCenter] postNotificationName:[self newItemNotificationKey] object:[NSIndexPath indexPathForRow:0 inSection:0]];
}

-(void)removeObjectAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.objects.count) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [self saveContent];
        [[NSNotificationCenter defaultCenter] postNotificationName:[self deletedNotificationKey] object:indexPath];
    } else
        [[NSNotificationCenter defaultCenter] postNotificationName:[self selectedItemNotificationKey] object:[NSError errorWithDomain:@"Invalid index path" code:0 userInfo:nil]];
}

-(void)selectItemAtIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.row < self.objects.count) {
        [[NSNotificationCenter defaultCenter] postNotificationName:[self selectedItemNotificationKey] object:[self.objects objectAtIndex:indexPath.row]];
    } else
        [[NSNotificationCenter defaultCenter] postNotificationName:[self selectedItemNotificationKey] object:[NSError errorWithDomain:@"Invalid index path" code:0 userInfo:nil]];
}
-(void)updateObject:(id)object atIndexPath:(NSIndexPath*)indexPath
{
    if(indexPath.row < self.objects.count && [object isKindOfClass:[CBPeople class]]) {
        [self.objects replaceObjectAtIndex:indexPath.row withObject:object];
        [[NSNotificationCenter defaultCenter] postNotificationName:[self updatedNotificationKey] object:indexPath];
    } else
        [[NSNotificationCenter defaultCenter] postNotificationName:[self selectedItemNotificationKey] object:[NSError errorWithDomain:@"Invalid index path" code:0 userInfo:nil]];
}

@end
