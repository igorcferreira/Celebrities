//
//  CBImageSelectionViewController.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/9/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBImageSelectionViewController.h"
#import "CBPeople.h"
#import "CBDataSource.h"
#import "CBBingSearchEngine.h"
#import "CBConstants.h"
#import "CBPhotoCollectionViewCell.h"

static NSString * const ReuseIdentifier = @"CBBingImageCell";

@interface CBImageSelectionViewController ()

@property (strong, nonatomic) CBPeople* item;
@property (weak, nonatomic) CBDataSource* dataSource;
@property (strong, nonatomic) NSArray* images;
@property (strong, nonatomic) CBBingSearchEngine* engine;

@end

@implementation CBImageSelectionViewController

-(void)viewDidLoad
{
    self.dataSource = [CBDataSource dataSourceWithProfile:CBDataSourceProfilePlist];
    self.engine = [CBBingSearchEngine bingSearchEngineWithKey:BING_SEARCH_KEY];
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    if(self.dataSource == nil)
        self.dataSource = [CBDataSource dataSourceWithProfile:CBDataSourceProfilePlist];
    self.item = [self.dataSource objectAtIndexPath:self.indexPath];
    if(self.engine == nil)
        self.engine = [CBBingSearchEngine bingSearchEngineWithKey:BING_SEARCH_KEY];
    [self.engine searchImageWithQuery:[self.item name] withSuccess:^(NSArray* itens) {
        self.images = itens;
        [self.collectionView reloadData];
    } andError:^(NSError* error) {
        self.images = nil;
        [self.collectionView reloadData];
    }];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(self.images)
        return self.images.count;
    else
        return 0;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CBPhotoCollectionViewCell* cell = (CBPhotoCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:ReuseIdentifier forIndexPath:indexPath];
    CBBingSearchImage* image = [self.images objectAtIndex:indexPath.row];
    [cell loadImageUrl:image.imageUrl];
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(50, 20, 50, 20);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CBBingSearchImage* image = [self.images objectAtIndex:indexPath.row];
    return CGSizeMake(image.width, image.height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    CBBingSearchImage* image = [self.images objectAtIndex:indexPath.row];
    self.item.imageUrl = image.imageUrl;
    [self.dataSource updateObject:self.item atIndexPath:self.indexPath];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
