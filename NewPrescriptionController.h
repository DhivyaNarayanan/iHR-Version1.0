//
//  Name of the file:NewPrescriptionController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File allows you to add new prescriptions into the table

//  Created by Dhivya Narayanan on 12/4/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface NewPrescriptionController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>{
    sqlite3 *db;
}



@property (strong, nonatomic) NSString* itemUsername;
-(NSString *) filePath;  //database get stored at this path
-(void)openDB;

//IBOutlets and IBActions for textfields in the view
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *prescribedByTxt;
@property (weak, nonatomic) IBOutlet UITextField *prescribedOnTxt;
@property (weak, nonatomic) IBOutlet UITextField *commentsTxt;

@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet UIImageView *prescriptionImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;

//Class variables to store entered values
@property(nonatomic)NSString* enteredPreName;
@property(nonatomic)NSString* enteredPreDrName;
@property(nonatomic)NSString* enteredDate;
@property(nonatomic)NSString* enteredComments;
@property(nonatomic)NSString* enteredFile;

//Actions to toolbar items
- (IBAction)refresh:(id)sender;
- (IBAction)addtoList:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)attachFile:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)calendarBt:(id)sender;

@end

