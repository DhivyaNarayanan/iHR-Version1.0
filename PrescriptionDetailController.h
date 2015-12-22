//
//  Name of the file:PrescriptionDetailController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File displays the detail of particular prescription and allow you to make a call to that doctor from the app
//  Created by Dhivya Narayanan on 12/4/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface PrescriptionDetailController : UIViewController{
    sqlite3 *db;
}

//class variables to prescription detail of the selected one
@property (strong,nonatomic) NSString *itemPreName;
@property (strong,nonatomic) NSString *itemPreDrName;
@property (strong,nonatomic) NSString *itemPreDate;
@property (strong,nonatomic) NSString *itemPreComments;
@property (strong,nonatomic) NSString *itemPreFile;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;

@property(strong,nonatomic) NSMutableArray *listDoctors;
@property(nonatomic)NSInteger index;

//IBoutlets for the label in the view
@property (weak, nonatomic) IBOutlet UILabel *prescriptionName;
@property (weak, nonatomic) IBOutlet UILabel *prescribedBy;
@property (weak, nonatomic) IBOutlet UILabel *prescribedOn;
@property (weak, nonatomic) IBOutlet UILabel *comments;
@property (weak, nonatomic) IBOutlet UIImageView *prescriptionImage;

-(NSString *) filePath;  //database get stored at this path
-(void)openDB;

//MEthod to share the prescription via any means like messaging, email, whatsapp, etc.
- (IBAction)share:(id)sender;

@end



