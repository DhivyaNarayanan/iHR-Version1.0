//
//  Name of the file:DoctorListController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File displays all the doctor's contact stored in the database for that user in the tableview
//  Created by Dhivya Narayanan on 12/3/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DoctorListController.h"
#import "NewContactViewController.h"
#import "DoctorDetailController.h"
#import "ListViewController.h"
#import "AuthViewController.h"

@interface DoctorListController ()

//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic) NSMutableArray *listOfDoctors;
@property(nonatomic) NSMutableArray *doctorDetail;
@property(nonatomic)NSInteger selectedIndex;
@property(nonatomic)NSArray *selectedRow;
@property(nonatomic)NSString* selectedDrName;
@end

@implementation DoctorListController


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


//Retrieve doctor's list from the database

-(void)retrieveDetails{
    
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
        //Retrieve all the values and store it into local variable
        NSString  * query = @"SELECT * from DoctorListTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retUserName =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                self.retDrName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.retDrContactno =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                self.retDrEmail =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                self.retDrSpecizalition =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                self.retHospital =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
                self.retDrAddr =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
                
                if([self.retUserName isEqualToString:self.itemUserName]){
                    NSMutableArray* detail = [NSMutableArray arrayWithObjects:self.retDrName,self.retDrContactno, self.retDrEmail,self.retDrSpecizalition,self.retHospital,self.retDrAddr, nil];
                    [self.listOfDoctors addObject:detail];
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

//Display retrieved doctor's list in table view
- (void)viewDidLoad
{
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logout:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Add"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(newContact:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:logoutButton,addButton, nil];
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.navigationItem.title =@"Doctor's List";
        
    self.listOfDoctors = [[NSMutableArray alloc]init];
    self.doctorDetail = [[NSMutableArray alloc]init];
    
    [self retrieveDetails];     //Retrieve details
     [self.tableView reloadData];
    self.doctorsList = [[NSMutableArray alloc]init];
    for(int i=0; i<self.listOfDoctors.count;i++){
        NSArray * drdetail = self.listOfDoctors[i];
        NSString *drname = drdetail[0];
        [self.doctorsList addObject:drname];
    }
    CALayer *background = [CALayer layer];
    background.zPosition = -1;
    background.frame = self.view.frame;
    background.contents = (__bridge id)([[UIImage imageNamed:@"bg.jpg"] CGImage]);
    [self.tableView.layer addSublayer:background];
    
    self.title = @"Doctor's Contact";
     [super viewDidLoad];
    
}


-(IBAction)logout:(id)sender{
    //AuthView
    AuthViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthView"];
    
    // [self presentViewController:avc animated:YES completion:nil];
    
    
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
    return self.doctorsList.count;
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
     //[dataSource insertObject:[self.doctorsList objectAtIndex:indexPath.row] atIndex:0]
    // set text attibute of cell
    //indexPath = 0;
    cell.textLabel.text = [self.doctorsList objectAtIndex:indexPath.row];
    
    // set accessory type to standard detail disclosure indicator
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    
    self.selectedIndex = indexPath.row;
    
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedDrName = selectedCell.textLabel.text;
    
    
    NSLog(@"%@",self.selectedDrName);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DoctorDetailController* newView = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailDoctorview"];
    
    newView.itemDrName = self.listOfDoctors[self.selectedIndex][0];
    newView.itemDrContactno = self.listOfDoctors[self.selectedIndex][1];
    newView.itemDrEmail = self.listOfDoctors[self.selectedIndex][2];
    newView.itemSpl = self.listOfDoctors[self.selectedIndex][3];
    newView.itemHospital = self.listOfDoctors[self.selectedIndex][4];
    newView.itemDrAddr= self.listOfDoctors[self.selectedIndex][5];
    [self.navigationController pushViewController:newView animated:YES];
    
    
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // note which segue chosen (need to know if more than one segue from current view controller)
    NSLog( @"Transition via segue: '%@'", segue.identifier);
    
    if([segue.identifier isEqualToString:@"newdoctorcontact"]){
        NewContactViewController *ncv = segue.destinationViewController;
        ncv.itemUsername = self.itemUserName;
    }
    
    [super prepareForSegue:segue sender:sender];
    
}
//Naviagate to controller which allows to add new controller

- (IBAction)newContact:(id)sender {
    
    NewContactViewController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"newcontactview"];
    nvc.itemUsername = self.itemUserName;
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:nvc animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    

    //[self.navigationController pushViewController:nvc animated:YES];
}
@end