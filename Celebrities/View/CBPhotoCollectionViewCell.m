//
//  CBPhotoCollectionViewCell.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/9/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBPhotoCollectionViewCell.h"
#import "AsyncImageView.h"

@interface CBPhotoCollectionViewCell()
@property (weak, nonatomic) IBOutlet AsyncImageView *image;
@end

@implementation CBPhotoCollectionViewCell

-(void)loadImageUrl:(NSURL*)url
{
    [self.image setImage:nil];
    [self.image setImageURL:url];
}

@end