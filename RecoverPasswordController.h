//
//  Name of the file: RecoverPasswordController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File recovers the password by entering the username and proper security question and answer
//  Created by Dhivya Narayanan on 12/2/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "AuthViewController.h"

@interface RecoverPasswordController : UIViewController<UIAlertViewDelegate>
{
    sqlite3 * db;
}
-(NSString *) filePath;  //database get stored at this path
-(void)openDB;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;

@property (weak, nonatomic) IBOutlet UITextField *enterAnswerTxt;
- (IBAction)recoverPwd:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *secQueBtOutlet;
- (IBAction)btAction:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableviewQue;


@property(strong, nonatomic)NSArray *queData;
@property (strong,nonatomic) NSString *itemUsername;
@property (strong,nonatomic) NSString *itemPwd;
@property (strong,nonatomic) NSString *itemSecQue;
@property (strong,nonatomic) NSString *itemAns;
@property(strong,nonatomic)NSString* enteredSecQue;
@property(strong,nonatomic)NSString* enteredAnswer;

@end




