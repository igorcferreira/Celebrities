//
//  MasterViewController.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBMasterViewController.h"
#import "CBDetailViewController.h"
#import "CBConstants.h"
#import "CBDataSource.h"
#import "CBPeople.h"

@interface CBMasterViewController ()
@property CBDataSource* dataSource;
@end

@implementation CBMasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    self.detailViewController = (CBDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    self.dataSource = [CBDataSource dataSourceWithProfile:CBDataSourceProfilePlist];
    [self.dataSource registerObserver:self forDeletedItem:@selector(excludedItem:)];
    [self.dataSource registerObserver:self forNewItem:@selector(newItem:)];
    [self.dataSource registerObserver:self forUpdatedItem:@selector(updateIem:)];
    [self.dataSource load];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)insertNewObject:(id)sender {
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"New Item" message:@"Please provide the name of the new Celebrity" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"Ok", nil];
    [alertView setTag:1234];
    [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [alertView show];
}

#pragma mark - Observer

-(void)updateIem:(NSNotification*)notification
{
    id info = notification.object;
    if(info && [info isKindOfClass:[NSIndexPath class]]) {
        [self.tableView reloadRowsAtIndexPaths:@[(NSIndexPath*)info] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-(void)newItem:(NSNotification*)notification
{
    id info = notification.object;
    if(info && [info isKindOfClass:[NSIndexPath class]]) {
        NSIndexPath* indexPath = (NSIndexPath*)info;
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self updateDetalViewController];
    }
}

-(void)excludedItem:(NSNotification*)notification
{
    id info = notification.object;
    if(info && [info isKindOfClass:[NSIndexPath class]]) {
        [self.tableView deleteRowsAtIndexPaths:@[(NSIndexPath*)info] withRowAnimation:UITableViewRowAnimationFade];
        if([self.dataSource rowsInSection:0] > 0)
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
        [self updateDetalViewController];
    }
}

-(void)updateDetalViewController
{
    if(self.detailViewController)
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [self.detailViewController setIndexPath:indexPath];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        CBDetailViewController *controller = (CBDetailViewController *)[[segue destinationViewController] topViewController];
        [controller setIndexPath:indexPath];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataSource rowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    CBPeople *object = [self.dataSource objectAtIndexPath:indexPath];
    cell.textLabel.text = [object name];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete)
        [self.dataSource removeObjectAtIndexPath:indexPath];
}

#pragma mark - UIAlertView

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1234 && [[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Ok"])
    {
        UITextField* textField = [alertView textFieldAtIndex:0];
        if(textField && ![textField.text isEqualToString:@""])
            [self.dataSource addNewObjectWithIdentifier:textField.text];
    }
}

@end
