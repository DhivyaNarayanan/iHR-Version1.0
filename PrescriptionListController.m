//
//  Name of the file:PrescriptionListController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File displays all the prescriptions stored in the database for that user in the tableview
//  Created by Dhivya Narayanan on 12/4/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PrescriptionListController.h"
#import "NewPrescriptionController.h"
#import "PrescriptionDetailController.h"
#import "ListViewController.h"
#import "AuthViewController.h"

@interface PrescriptionListController ()

@property(strong,nonatomic) NSMutableArray *listOfPrescriptions;
@property(strong,nonatomic) NSMutableArray *prescriptionDetail;
@property(nonatomic)NSInteger selectedIndex;
@property(nonatomic)NSArray *selectedRow;
@property(nonatomic)NSString* selectedPreName;
@end

@implementation PrescriptionListController


//file path to db
-(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"myihrrecords.db"];
}

//open the db
-(void)openDB{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
}

//Retrieve all the prescription details of the user and display it in tableview

-(void)retrieveDetails{
    //open the database
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        //retrieve all the values from 'PrescriptionListTable'
        NSString  * query = @"SELECT * from PrescriptionListTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retUserName =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                self.retPreName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.retPreDrName =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                self.retPreDate =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                self.retFile =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                self.retComments =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
                
                
                if([self.retUserName isEqualToString:self.itemUserName]){
                    NSMutableArray* detail = [NSMutableArray arrayWithObjects:self.retPreName,self.retPreDrName, self.retPreDate,self.retFile,self.retComments, nil];
                    [self.listOfPrescriptions addObject:detail];
                }
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
}


- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.listOfPrescriptions = [[NSMutableArray alloc]init];
    self.prescriptionDetail = [[NSMutableArray alloc]init];
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logout:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Add"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(newPrescription:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:logoutButton,addButton, nil];
   // self.navigationItem.rightBarButtonItem = logoutButton;
    
    
    [self retrieveDetails];
    self.prescriptionList = [[NSMutableArray alloc]init];
    for(int i=0; i<self.listOfPrescriptions.count;i++){
        NSArray * predetail = self.listOfPrescriptions[i];
        NSString *prename = predetail[0];
        [self.prescriptionList addObject:prename];
    }
    self.title = @"Prescriptions";
    
}
//Method to logout the app

-(IBAction)logout:(id)sender{
    
    AuthViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthView"];
    
    [self.navigationController pushViewController:avc animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.prescriptionList.count;
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
    cell.textLabel.text = [self.prescriptionList objectAtIndex:indexPath.row];
    
    // set accessory type to standard detail disclosure indicator
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    self.selectedIndex = indexPath.row;
    
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedPreName = selectedCell.textLabel.text;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PrescriptionDetailController* newView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailPrescribeView"];
    
    newView.itemPreName = self.listOfPrescriptions[self.selectedIndex][0];
    newView.itemPreDrName = self.listOfPrescriptions[self.selectedIndex][1];
    newView.itemPreDate = self.listOfPrescriptions[self.selectedIndex][2];
    newView.itemPreFile = self.listOfPrescriptions[self.selectedIndex][3];
    newView.itemPreComments = self.listOfPrescriptions[self.selectedIndex][4];
    
    [self.navigationController pushViewController:newView animated:YES];
    
    
}

- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
}

//Navigates to add new prescription controller
- (IBAction)newPrescription:(id)sender {
    
    NewPrescriptionController *npc = [self.storyboard instantiateViewControllerWithIdentifier:@"newprescriptionview"];
    npc.itemUsername = self.itemUserName;
    //[self.navigationController pushViewController:npc animated:YES];
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:npc animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];

}
@end