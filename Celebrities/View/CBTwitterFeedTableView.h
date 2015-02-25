//
//  CBIndexTableView.h
//  Celebrities
//
//  Created by Igor Ferreira on 11/8/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBTwitterFeedTableView : UITableView <UITableViewDataSource, UITableViewDelegate>

-(void)loadTableWithQuery:(NSString*)query;

@end