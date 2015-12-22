//
//  Name of the file:DoctorListController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File displays all the doctor's contact stored in the database for that user in the tableview
//  Created by Dhivya Narayanan on 12/3/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface DoctorListController : UIViewController{
    sqlite3 * db;
}

//IBOutlets and IBActions to tableview and button
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)newContact:(id)sender;

@property(strong, nonatomic)NSMutableArray *doctorsList;


//Store retrieved doctor's list from the database
@property(strong,nonatomic)NSString* retDrName;
@property(strong,nonatomic)NSString* retDrContactno;
@property(strong,nonatomic)NSString* retDrEmail;
@property(strong,nonatomic)NSString* retDrSpecizalition;
@property(strong,nonatomic)NSString* retDrAddr;
@property(strong,nonatomic)NSString *retHospital;
@property(strong,nonatomic)NSString* retUserName;
@property(strong,nonatomic)NSString* itemUserName;


-(NSString *) filePath;  //database get stored at this path
-(void)openDB;
-(void)retrieveDetails;  //Method to retrieve detail

@end




