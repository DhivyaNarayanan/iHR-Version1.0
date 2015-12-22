
//  MyiHR
//  Name of the file: AuthViewController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File creates a login page to enter with user name and password and to create new user and also to retrieve forgot password
//  Created by Dhivya Narayanan on 12/2/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "RecoverPasswordController.h"
#import "CreateAuthController.h"
//#import "ProfileViewController.h"

@interface AuthViewController : UIViewController<UITextFieldDelegate, UITextViewDelegate>{
    sqlite3 * db;
}
-(NSString *) filePath;  //database get stored at this path
-(void)openDB;
-(void)retrieveAuthDetails;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;


//IBOutlets and IBActions for textfields and buttons
@property (weak, nonatomic) IBOutlet UITextField *AuthUserName;
@property (weak, nonatomic) IBOutlet UITextField *AuthPassword;
- (IBAction)loginUser:(id)sender;
- (IBAction)createUser:(id)sender;
- (IBAction)forgotPassword:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginBt;
@property (weak, nonatomic) IBOutlet UIButton *createuserBt;
@property (weak, nonatomic) IBOutlet UIButton *forgotPwdBt;

@property (strong,nonatomic) NSString *retFirstName;
@property (strong,nonatomic) NSString *retLastName;
@property (strong,nonatomic) NSString *retDob;
@property (strong,nonatomic) NSString *retAge;
@property (strong,nonatomic) NSString *retGender;
@property (strong,nonatomic) NSString *retBloodGroup;
@property (strong,nonatomic) NSString *retContactno;
@property (strong,nonatomic) NSString *retEmail;
@property (strong,nonatomic) NSString *retAddr;
@property (strong,nonatomic) NSString *retCity;
@property (strong,nonatomic) NSString *retState;
@property (strong,nonatomic) NSString *retCountry;
@property (strong,nonatomic) NSString *retZipcode;
@property (strong,nonatomic) NSString *retUsername;
@property (strong,nonatomic) NSString *retPwd;
@property (strong,nonatomic) NSString *retSecQue;
@property (strong,nonatomic) NSString *retAns;
@property(strong,nonatomic)NSString* imgPath;
@property(strong,nonatomic)NSString* imgName;

@end



