//
//  Name of the file: CreateAuthController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File gets the authentication details from the user. All the fields should be enetered. Once they click submit, new user will be created and all the values will be stored into database
//  Created by Dhivya Narayanan on 12/2/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "sqlite3.h"
//#import "ProfileViewController.h"

@interface CreateAuthController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate, UITextViewDelegate>{
    sqlite3 * db;
}
-(NSString *) filePath;  //database get stored at this path
-(void)openDB;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTxt;

@property (weak, nonatomic) IBOutlet UITextField *lastNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *enterUserNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *assignPasswordTxt;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTxt;
@property (weak, nonatomic) IBOutlet UITextField *enterAnswerTxt;
- (IBAction)submitAuthDetails:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *secQueBtOutlet;
@property (weak, nonatomic) IBOutlet UITableView *tableviewQue;
- (IBAction)btAction:(id)sender;

//IBOutlet and IBAction for Textfields, buttons and Tableview

@property(strong, nonatomic) NSArray* queData;

//Variables to store retrieved profile data
@property (strong,nonatomic) NSString *itemFirstName;
@property (strong,nonatomic) NSString *itemLastName;
@property (strong,nonatomic) NSString *itemDob;
@property (strong,nonatomic) NSString *itemAge;
@property (strong,nonatomic) NSString *itemGender;
@property (strong,nonatomic) NSString *itemBloodGroup;
@property (strong,nonatomic) NSString *itemContactno;
@property (strong,nonatomic) NSString *itemEmail;
@property (strong,nonatomic) NSString *itemAddr;
@property (strong,nonatomic) NSString *itemCity;
@property (strong,nonatomic) NSString *itemState;
@property (strong,nonatomic) NSString *itemCountry;
@property (strong,nonatomic) NSString *itemZipcode;

@property (strong,nonatomic) NSString *itemUsername;
@property (strong,nonatomic) NSString *itemPwd;
@property (strong,nonatomic) NSString *itemSecQue;
@property (strong,nonatomic) NSString *itemAns;

@property(strong,nonatomic)NSString* imagePath;
@property(strong,nonatomic)UIImage* imagePic;
@property(strong,nonatomic)NSString* imgName;

//Methods to create Table
-(void)createTableMyProfile;
-(void)createTableAuthDetails;
-(void)createTableProfilePic;
-(void)createTableDoctorList;
-(void)createTablePresList;
-(void)createTableConditions;
-(void)createTableAllergy;
-(void)createTableDevices;
-(void)createTableProcedures;
-(void)createTableWeight;
-(void)createTableHeight;
-(void)createTableBMI;
-(void)createTableSugar;
-(void)createTableBP;
-(void)createTableMedications;

//Methods to insert values into tables
-(void)insertprofile;
-(void)insertauthdetails;
-(void)insertprofilepic;
-(BOOL)isEmpty;

@end



