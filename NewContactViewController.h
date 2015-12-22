//
//  Name of the file:NewContactViewController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File allows you to add new doctors contact into the table
//  Created by Dhivya Narayanan on 12/3/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface NewContactViewController : UIViewController{
    sqlite3 *db;
}


@property (strong, nonatomic) NSString* itemUsername;
-(NSString *) filePath;  //database get stored at this path
-(void)openDB;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;

//IBOutlet and IBActions to textfields
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *hospitalField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNoTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *specializationTxt;
@property (weak, nonatomic) IBOutlet UITextField *addrTxt;
@property (weak, nonatomic) IBOutlet UITextField *extTxt;

- (IBAction)refresh:(id)sender;
- (IBAction)addtoList:(id)sender;
- (IBAction)cancel:(id)sender;

//Class variables to store entered texts in the textfields
@property(nonatomic)NSString* enteredName;
@property(nonatomic)NSString* enteredHospital;
@property(nonatomic)NSString* enteredPhone;
@property(nonatomic)NSString* enteredEmail;
@property(nonatomic)NSString* enteredSpl;
@property(nonatomic)NSString* enteredAddr;

//Methods for validations
-(BOOL)validatePhoneno:(NSString *) candidate;
-(BOOL)isEmpty;
@end



