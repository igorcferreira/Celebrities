//
//  MasterViewController.h
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CBDetailViewController;

@interface CBMasterViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) CBDetailViewController* detailViewController;

@end

