//
//  Name of the file:SummaryTableController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File  displays categories like Conditions, weight, Blood pressure and etc. in tableview.


//  Created by Dhivya Narayanan on 12/5/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SummaryTableController.h"
#import "ConditionsController.h"
//#import "AllergiesController.h"
//#import "ProceduresController.h"
//#import "DevicesController.h"
//#import "MedicationsController.h"
#import "AuthViewController.h"
//#import "WeightController.h"

@interface SummaryTableController ()

@property(nonatomic)NSMutableArray *summarylist;
@property(nonatomic)NSInteger selectedIndex;
@property(nonatomic)NSArray *selectedRow;
@property(nonatomic)NSString* selectedRowName;

@end


@implementation SummaryTableController
@synthesize summaryview;

//Displays all kind of records in table view which allows to navigate to particular kind of category by selecting the tableviewcell
- (void)viewDidLoad {
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logout:)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
    _summarylist=[[NSMutableArray alloc]initWithObjects:@"Conditions",@"Allergies",@"Medications",@"Procedures",@"Devices",@"Weight",@"Height",@"BMI",@"Blood Sugar",@"Blood Pressure", nil];
    self.title = @"Records";
    
}

//Method to logout from the app
-(IBAction)logout:(id)sender{
    
    AuthViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthView"];
    
    [self.navigationController pushViewController:avc animated:YES];
    
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_summarylist count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; // reuse identifier
    
    
    // check if we can reuse a cell from row that just went off screen
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    
    // set text attibute of cell
    cell.textLabel.text = [_summarylist objectAtIndex:indexPath.row];
    
    
    return cell;
}

//Naviagate to corresponding viewcontroller when particular row is selected
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    self.selectedIndex = indexPath.row;
    
    UITableViewCell *selectedCell = [self.summaryview cellForRowAtIndexPath:indexPath];
    self.selectedRowName = selectedCell.textLabel.text;
    
    
    NSLog(@"%@",self.selectedRowName);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //if([self.selectedRowName isEqualToString:@"Conditions"]){
        ConditionsController *cview = [self.storyboard instantiateViewControllerWithIdentifier:@"conditionsview"];
        cview.itemUserName = self.itemUsername;
        cview.option = self.selectedRowName;
        [self.navigationController pushViewController:cview animated:YES];
    //}
    
    /*if([self.selectedRowName isEqualToString:@"Allergies"]){
        AllergiesController *aview = [self.storyboard instantiateViewControllerWithIdentifier:@"allergiesview"];
        aview.itemUserName = self.itemUsername;
        [self.navigationController pushViewController:aview animated:YES];
    }
    
    if([self.selectedRowName isEqualToString:@"Procedures"]){
        ProceduresController *pview = [self.storyboard instantiateViewControllerWithIdentifier:@"proceduresview"];
        pview.itemUserName = self.itemUsername;
        [self.navigationController pushViewController:pview animated:YES];
    }
    
    if([self.selectedRowName isEqualToString:@"Devices"]){
        DevicesController *pview = [self.storyboard instantiateViewControllerWithIdentifier:@"devicesview"];
        pview.itemUserName = self.itemUsername;
        [self.navigationController pushViewController:pview animated:YES];
    }
    
    if([self.selectedRowName isEqualToString:@"Medications"]){
        MedicationsController *pview = [self.storyboard instantiateViewControllerWithIdentifier:@"medicationsview"];
        pview.itemUserName = self.itemUsername;
        [self.navigationController pushViewController:pview animated:YES];
    }
    
    if([self.selectedRowName isEqualToString:@"Weight"]){
        WeightController *pview = [self.storyboard instantiateViewControllerWithIdentifier:@"weightview"];
        pview.itemUserName = self.itemUsername;
        [self.navigationController pushViewController:pview animated:YES];
    }
    
    if([self.selectedRowName isEqualToString:@"Height"]){
        WeightController *pview = [self.storyboard instantiateViewControllerWithIdentifier:@"heightview"];
        pview.itemUserName = self.itemUsername;
        [self.navigationController pushViewController:pview animated:YES];
    }
    
    if([self.selectedRowName isEqualToString:@"BMI"]){
        WeightController *pview = [self.storyboard instantiateViewControllerWithIdentifier:@"bmiview"];
        pview.itemUserName = self.itemUsername;
        [self.navigationController pushViewController:pview animated:YES];
    }
    
    if([self.selectedRowName isEqualToString:@"Blood Sugar"]){
        WeightController *pview = [self.storyboard instantiateViewControllerWithIdentifier:@"sugarview"];
        pview.itemUserName = self.itemUsername;
        [self.navigationController pushViewController:pview animated:YES];
    }
    if([self.selectedRowName isEqualToString:@"Blood Pressure"]){
        WeightController *pview = [self.storyboard instantiateViewControllerWithIdentifier:@"bpview"];
        pview.itemUserName = self.itemUsername;
        [self.navigationController pushViewController:pview animated:YES];
    }*/
}




@end
