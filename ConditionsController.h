//
//  Name of the file:ConditionsController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File  displays conditions history of the user in the tableview and allows the option to restrict their view to 1 months history and 6 months history


//  Created by Dhivya Narayanan on 12/5/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "sqlite3.h"


@interface ConditionsController : UIViewController{
    sqlite3* db;
}

//IBOutlets and IBActions
@property (weak, nonatomic) IBOutlet UITableView *tableViewTxt;

@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;


- (IBAction)segmentchange:(id)sender;
@property (strong,nonatomic) NSString *itemUserName;
@property(strong,nonatomic)NSString *option;
@property (weak, nonatomic) IBOutlet UIButton *commentsBt;
- (IBAction)commentsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;

-(NSString *) filePath;  //database get stored at this path
-(void)openDB;
-(void)retrieveCondDetails;
-(void)retrieveAllergyDetails;
-(void)retrieveProcedureDetails;
-(void)retrieveDeviceDetails;
-(void)retrieveSugarDetails;
-(void)retrievePressureDetails;
-(void)retrieveHeight;
-(void)retrieveWeight;
-(void)retrieveBMI;

//class variables to retrieved values fron the table
@property(strong,nonatomic)NSString* retUsername;
@property(strong,nonatomic)NSDate* retDateTime;
@property(strong,nonatomic)NSString* retConditions;
@property(strong,nonatomic)NSString* retComments;
@property(strong,nonatomic)NSString* retSystolic;
@property(strong,nonatomic)NSString* retDiastolic;
@property(strong,nonatomic)NSDate* curDate;
@property(strong,nonatomic)NSDate* fromDate;


@end




