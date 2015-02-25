//
//  DetailViewController.m
//  Celebrities
//
//  Created by Igor Ferreira on 11/7/14.
//  Copyright (c) 2014 POGAmadores. All rights reserved.
//

#import "CBDetailViewController.h"
#import "CBPeople.h"
#import "AsyncImageView.h"
#import "CBTwitterFeedTableView.h"
#import "CBDataSource.h"
#import "CBImageSelectionViewController.h"

@interface CBDetailViewController ()
@property (weak, nonatomic) IBOutlet AsyncImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;
@property (weak, nonatomic) IBOutlet CBTwitterFeedTableView *feedTableView;
@property (weak, nonatomic) IBOutlet UIButton *setImageButton;

@property (strong, nonatomic) CBPeople* detailItem;
@property (strong, nonatomic) CBDataSource* dataSource;

@end

@implementation CBDetailViewController

#pragma mark - Managing the detail item

-(void)setIndexPath:(NSIndexPath *)indexPath {
    if(indexPath != nil)
    {
        _indexPath = indexPath;
        if(self.dataSource == nil) {
            self.dataSource = [CBDataSource dataSourceWithProfile:CBDataSourceProfilePlist];
            [self.dataSource registerObserver:self forUpdatedItem:@selector(updated:)];
        }
        self.detailItem = [self.dataSource objectAtIndexPath:indexPath];
        [self configureView];
    }
}

-(void)updated:(NSNotification*)notification
{
    id info = notification.object;
    if(info && [info isKindOfClass:[NSIndexPath class]])
    {
        NSIndexPath* indexPath = (NSIndexPath*)info;
        if(_indexPath.row == indexPath.row && _indexPath.section == indexPath.section)
            [self setIndexPath:indexPath];
    }
}

- (void)configureView
{
    [self.feedTableView loadTableWithQuery:[self.detailItem name]];
    [self.nameTextField setText:[self.detailItem name]];
    
    if(self.detailItem.age)
        [self.ageTextField setText:[NSString stringWithFormat:@"%ld",(long)[[self.detailItem age] integerValue]]];
    else
        [self.ageTextField setText:@""];
    
    if(self.detailItem.imageUrl) {
        [self.profileImage setImageURL:self.detailItem.imageUrl];
        [self.profileImage setHidden:NO];
        [self.setImageButton setHidden:YES];
    } else {
        [self.profileImage setHidden:YES];
        [self.setImageButton setHidden:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if(self.indexPath)
        self.detailItem = [self.dataSource objectAtIndexPath:self.indexPath];
    [self.profileImage setUserInteractionEnabled:YES];
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTouched:)];
    [tap setNumberOfTapsRequired:1];
    [tap setNumberOfTouchesRequired:1];
    [self.profileImage addGestureRecognizer:tap];
    
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)imageTouched:(UIGestureRecognizer*)sender
{
    [self performSegueWithIdentifier:@"selectImage" sender:self];
}

- (IBAction)saveContent:(id)sender
{
    if(self.nameTextField.text && ![self.nameTextField.text isEqualToString:@""])
        [self.detailItem setName:self.nameTextField.text];
    if(self.ageTextField.text && ![self.ageTextField.text isEqualToString:@""] && [[NSScanner scannerWithString:self.ageTextField.text] scanInteger:nil])
        [self.detailItem setAge:[NSNumber numberWithInteger:[self.ageTextField.text integerValue]]];
    [self.dataSource updateObject:self.detailItem atIndexPath:self.indexPath];
}

- (IBAction)setImage:(id)sender {
    [self imageTouched:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if(sender == self && [segue.identifier isEqualToString:@"selectImage"])
    {
        CBImageSelectionViewController *controller = (CBImageSelectionViewController *)segue.destinationViewController;
        [controller setIndexPath:self.indexPath];
    }
}

@end
