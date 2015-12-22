//
//  EditProfileController.h
//  MyiHR
//
//  Created by Dhivya Narayanan on 12/16/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface EditProfileController: UIViewController<UITextViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>{
    sqlite3 *db;
}
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
- (IBAction)done:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *clear;
- (IBAction)clearAction:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *firstNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *dobTxt;
@property (weak, nonatomic) IBOutlet UITextField *ageTxt;
@property (weak, nonatomic) IBOutlet UITextField *genderTxt;
@property (weak, nonatomic) IBOutlet UITextField *extTxt;
@property (weak, nonatomic) IBOutlet UITextField *contactTxt;
@property (weak, nonatomic) IBOutlet UITextField *bloodGroupTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *addressTxt;
@property (weak, nonatomic) IBOutlet UITextField *cityTxt;
@property (weak, nonatomic) IBOutlet UITextField *stateTxt;
@property (weak, nonatomic) IBOutlet UITextField *countryTxt;
@property (weak, nonatomic) IBOutlet UITextField *zipcodeTxt;
@property (weak, nonatomic) IBOutlet UIImageView *profilepic;


@property(nonatomic)NSString* itemFirstName;
@property(nonatomic)NSString* itemLastName;
@property(nonatomic)NSString* itemDob;
@property(nonatomic)NSString* itemAge;
@property(nonatomic)NSString* itemGender;
@property(nonatomic)NSString* itemExt;
@property(nonatomic)NSString* itemContactNo;
@property(nonatomic)NSString* itemBloodGrp;
@property(nonatomic)NSString* itemEmail;
@property(nonatomic)NSString* itemAddress;
@property(nonatomic)NSString* itemCity;
@property(nonatomic)NSString* itemState;
@property(nonatomic)NSString* itemCountry;
@property(nonatomic)NSString* itemZipCode;
@property(nonatomic)NSString* itemUsername;
@property(nonatomic)NSString* imgName;

@property(nonatomic)NSString* fname;
@property(nonatomic)NSString* lname;
@property(nonatomic)NSString* dob;
@property(nonatomic)NSString* age;
@property(nonatomic)NSString* gender;
@property(nonatomic)NSString* ext;
@property(nonatomic)NSString* contact;
@property(nonatomic)NSString* bloodgrp;
@property(nonatomic)NSString* email;
@property(nonatomic)NSString* addr;
@property(nonatomic)NSString* city;
@property(nonatomic)NSString* state;
@property(nonatomic)NSString* country;
@property(nonatomic)NSString* zip;



-(NSString *) filePath;  //database get stored at this path
-(void)openDB;
-(void)retrieveOldProfileValues;
-(void)deleteOldValue;
-(void)insertnewValue;

@end