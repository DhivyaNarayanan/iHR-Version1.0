//
//  Name of the file:ListViewController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File displays categories like Doctor's list, manage prescriptions and summary records in tableview.
//  Created by Dhivya Narayanan on 12/3/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ListViewController.h"
#import "DoctorListController.h"
#import "PrescriptionListController.h"
#import "SummaryTableController.h"
#import "AuthViewController.h"
#import "PreviewController.h"


@interface ListViewController ()

@property(nonatomic)NSInteger selectedIndex;
@property(nonatomic)NSArray *selectedRow;
@property(nonatomic)NSString* selectedText;

@end

@implementation ListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSArray *viewControllers = [self.tabBarController viewControllers];
    UINavigationController *nav = [viewControllers objectAtIndex:0];
    PreviewController *pvc = (PreviewController *)[nav topViewController];
    self.itemUsername = pvc.username;
    [super viewDidLoad];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logout:)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    self.contents = [NSArray arrayWithObjects:@"Doctor's List",@"Manage Prescriptions",@"Summary(Records)", nil];
    CALayer *background = [CALayer layer];
    background.zPosition = -1;
    background.frame = self.view.frame;
    background.contents = (__bridge id)([[UIImage imageNamed:@"bg.jpg"] CGImage]);
    [self.tableView.layer addSublayer:background];
    
    self.title = @"Records";
}

-(IBAction)logout:(id)sender{
    
    AuthViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthView"];
    
    [self.navigationController pushViewController:avc animated:YES];
    
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; // reuse identifier
    
    // check if we can reuse a cell from row that just went off screen
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // create new cell, if needed
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // set text attibute of cell
    cell.textLabel.text = [self.contents objectAtIndex:indexPath.row];
    
    // set accessory type to standard detail disclosure indicator
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
        
    return cell;
}
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    
    self.selectedIndex = indexPath.row;
    
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedText = selectedCell.textLabel.text;
    
    
    NSLog(@"%@",self.selectedText);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.selectedText isEqualToString:@"Manage Prescriptions"] ){
        PrescriptionListController* newView = [self.storyboard instantiateViewControllerWithIdentifier:@"prescriptionlistview"];
        // [self presentViewController:newView animated:YES completion:nil];
        newView.itemUserName = self.itemUsername;
        
        [self.navigationController pushViewController:newView animated:YES];
        
    }
    
    if([self.selectedText isEqualToString:@"Doctor's List"] ){
        DoctorListController* newView = [self.storyboard instantiateViewControllerWithIdentifier:@"doctorlistview"];
        // [self presentViewController:newView animated:YES completion:nil];
        newView.itemUserName = self.itemUsername;
        
        [self.navigationController pushViewController:newView animated:YES];
        
    }
    
    
    if([self.selectedText isEqualToString:@"Summary(Records)"] ){
        SummaryTableController* newView = [self.storyboard instantiateViewControllerWithIdentifier:@"summaryview"];
        // [self presentViewController:newView animated:YES completion:nil];
        newView.itemUsername = self.itemUsername;
        
        [self.navigationController pushViewController:newView animated:YES];
        
    }
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // note which segue chosen (need to know if more than one segue from current view controller)
    NSLog( @"Transition via segue: '%@'", segue.identifier);
    
    [super prepareForSegue:segue sender:sender];
    if([segue.identifier isEqualToString:@"todoctorlist"]){
        DoctorListController *dvc = segue.destinationViewController;
        dvc.itemUserName = self.itemUsername;
    }
    
}

@end
