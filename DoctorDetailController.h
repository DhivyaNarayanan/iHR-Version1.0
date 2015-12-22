//
//  Name of the file:DoctorDetailController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File displays the detail of particular doctor and allow you to make a call to that doctor from the app
//  Created by Dhivya Narayanan on 12/3/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface DoctorDetailController : UIViewController{
    sqlite3 *db;
}

//class variables to store retrieved doctor detail
@property (strong,nonatomic) NSString *itemDrName;
@property (strong,nonatomic) NSString *itemDrContactno;
@property (strong,nonatomic) NSString *itemDrEmail;
@property (strong,nonatomic) NSString *itemDrAddr;
@property (strong,nonatomic) NSString *itemHospital;
@property (strong,nonatomic) NSString *itemSpl;


@property(strong,nonatomic) NSMutableArray *listDoctors;
@property(nonatomic)NSInteger index;

//IBOutlets for the labels in the view
@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *specialistLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrLabel;

-(NSString *) filePath;  //database get stored at this path
-(void)openDB;

//Method to make a call to selected doctor
- (IBAction)makeCall:(id)sender;

@end



