//
//
//  Name of the file:PrescriptionListController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File displays all the prescriptions stored in the database for that user in the tableview
//  Created by Dhivya Narayanan on 12/4/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface PrescriptionListController : UIViewController{
    sqlite3 * db;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)newPrescription:(id)sender;

@property(strong, nonatomic)NSMutableArray *prescriptionList;

//class variables to store retrieved values of prescription list
@property(strong,nonatomic)NSString* retPreName;
@property(strong,nonatomic)NSString* retPreDrName;
@property(strong,nonatomic)NSString* retPreDate;
@property(strong,nonatomic)NSString* retComments;
@property(strong,nonatomic)NSString* retFile;
@property(strong,nonatomic)NSString* retUserName;
@property(strong,nonatomic)NSString* itemUserName;


-(NSString *) filePath;  //database get stored at this path
-(void)openDB;
-(void)retrieveDetails;

@end






