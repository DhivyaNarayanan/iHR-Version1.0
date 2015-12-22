//
//  Name of the file:PreviewController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File displays users current health condition along with his/her profile details.
//  Created by Dhivya Narayanan on 12/6/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface PreviewController : UIViewController{
    sqlite3 *db;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;

- (IBAction)editProfile:(id)sender;

//IBOutlets for UILabels
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ageGenderLabel;
@property (weak, nonatomic) IBOutlet UILabel *dobLabel;
@property (weak, nonatomic) IBOutlet UILabel *htLabel;
@property (weak, nonatomic) IBOutlet UILabel *wtLabel;
@property (weak, nonatomic) IBOutlet UILabel *bmiLabel;

@property (weak, nonatomic) IBOutlet UILabel *bpLabel;
@property (weak, nonatomic) IBOutlet UILabel *sugarLabel;
@property (weak, nonatomic) IBOutlet UILabel *bloodGrpLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionsLabel;

@property (weak, nonatomic) IBOutlet UILabel *medicationsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImg;

//Variables to store the all retrieve values from the database
@property(strong, nonatomic)NSString* fName;
@property(strong, nonatomic)NSString* lName;
@property(strong, nonatomic)NSString* age;
@property(strong, nonatomic)NSString* gender;
@property(strong, nonatomic)NSString* dob;
@property(strong, nonatomic)NSString* ht;
@property(strong, nonatomic)NSString* wt;
@property(strong, nonatomic)NSString* bmi;
@property(strong, nonatomic)NSString* sugar;
@property(strong, nonatomic)NSString* bpsystolic;
@property(strong, nonatomic)NSString* bpdiastolic;
@property(strong, nonatomic)NSString* bloodgrp;
@property(strong,nonatomic)NSMutableArray* condArr;
@property(strong, nonatomic)NSString* conditions;
@property(strong,nonatomic)NSMutableArray* medArr;
@property(strong, nonatomic)NSString* medications;
@property(strong,nonatomic)NSString* email;
@property(strong,nonatomic)NSString* phone;
@property(strong,nonatomic)NSString* addr;
@property(strong,nonatomic)NSString* zipcode;
@property(nonatomic)NSString* username;
@property(strong,nonatomic)NSString* imgname;

//Method to retrieve values database
-(void)retrieveProfValues;
-(void)retrieveProfilePic;
//Method to setData to the fields in the UIView
-(void)setData;
-(NSString *) filePath;  //database get stored at this path
-(void)openDB;

@end

