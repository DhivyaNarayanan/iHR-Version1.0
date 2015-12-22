//
//  Name of the file: AuthViewController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File creates a login page to enter with user name and password and to create new user and also to retrieve forgot password

//  Created by Dhivya Narayanan on 12/2/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import "AuthViewController.h"
#import "PreviewController.h"
#import "EditProfileController.h"

@interface AuthViewController ()

@property(nonatomic)NSString * enteredUsername;
@property(nonatomic)NSString* enteredpassword;
@property(nonatomic)NSString* fname;
@property(nonatomic)NSString* lname;
@property(nonatomic)NSString* secque;
@property(nonatomic)NSString* secans;
@property(nonatomic)NSString* retrievedUsername;
@property(nonatomic)NSString* retrievedPwd;

@end

@implementation AuthViewController
@synthesize AuthUserName,AuthPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    self.backgroundImg.alpha = 0.4;
    self.AuthPassword.secureTextEntry = YES;     //secure the text in password field
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//file path to db "myhrrecords.db"
-(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"myihrrecords.db"];
}

//open the db
-(void)openDB{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    
}


//Retrieve Authentication Details from the DB Table "AuthDetailsTable"
-(void)retrieveAuthDetails{
    
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        //Query to retrieve all the value from AuthDetailsTable
        NSString  * query = @"SELECT * from AuthDetailsTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retrievedUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                self.retrievedPwd = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.secque =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                self.secans =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                self.fname =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                self.lname =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
                
                //Stores only the current users details into the array
                if([self.retrievedUsername isEqualToString:self.enteredUsername]){
                    NSMutableArray *tarray = [NSMutableArray arrayWithObjects:self.retrievedUsername,self.retrievedPwd, nil];
                    [tmpArray addObject:tarray];
                    break;
                }
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        sqlite3_close(db);
    }
    
}

- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}

//Action for the 'login' button click
- (IBAction)loginUser:(id)sender {
    
    self.enteredUsername = self.AuthUserName.text; //get username from textfield
    NSLog(@"Entered UserName: %@",self.enteredUsername);
    self.enteredpassword = self.AuthPassword.text; //get pwd from textfield
    NSLog(@"Entered Password: %@",self.enteredpassword);
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    NSMutableArray *tmpArray = [[NSMutableArray alloc]init];
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT * from AuthDetailsTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retrievedUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                self.retrievedPwd = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.secque =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                self.secans =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                self.fname =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                self.lname =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
                
                if([self.retrievedUsername isEqualToString:self.enteredUsername]){
                    NSMutableArray *tarray = [NSMutableArray arrayWithObjects:self.retrievedUsername,self.retrievedPwd, nil];
                    [tmpArray addObject:tarray];
                    break;
                }
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        //If the entered username and password matches, then retrieve user profile from the DB Table
        if([tmpArray count] >0){
            for(int i=0; i<tmpArray.count; i++){
                if(([self.enteredUsername isEqualToString:tmpArray[i][0]]) && [self.enteredpassword isEqualToString:tmpArray[i][1]]){
                    
                    NSString  * query1 = @"SELECT * from MyProfileTable";
                    
                    rc =sqlite3_prepare_v2(db, [query1 UTF8String], -1, &stmt, NULL);
                    if(rc == SQLITE_OK)
                    {
                        while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
                        {
                            
                            self.retFirstName =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                            self.retLastName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                            self.retDob =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                            self.retAge =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                            self.retGender =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                            self.retEmail =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
                            self.retContactno =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
                            self.retBloodGroup= [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
                            self.retAddr = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];
                            self.retZipcode= [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 10)];
                            NSString* tuser = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 11)];
                            if([tuser isEqualToString:self.enteredUsername] ){
                                break;
                            }
                        }
                        NSLog(@"Done");
                        sqlite3_finalize(stmt);
                    }
                    else
                    {
                        NSLog(@"Failed to prepare statement with rc:%d",rc);
                    }
                    
                    //connects it to tabbar view where we enter medical details
                    UITabBarController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"tabbarview"];
                    [self presentViewController:tabbar animated:YES completion:nil];
                    UINavigationController *nav = [tabbar.viewControllers objectAtIndex:0];
                    PreviewController *pvc = (PreviewController *)[nav topViewController];
                    /*pvc.itemFirstName = self.retFirstName;
                     pvc.itemLastName = self.retLastName;
                     pvc.itemDob = self.retDob;
                     pvc.itemAge = self.retAge;
                     pvc.itemGender = self.retGender;
                     pvc.itemEmail = self.retEmail;
                     pvc.itemContactno = self.retContactno;
                     pvc.itemBloodGroup = self.retBloodGroup;
                     pvc.itemAddr = self.retAddr;
                     pvc.itemZipcode = self.retZipcode;
                     pvc.itemUsername = self.enteredUsername;
                     pvc.itemImagePath = self.imgPath;
                     pvc.itemImgName = self.imgName;*/
                    
                   /* pvc.fName = self.retFirstName;
                    pvc.lName = self.retLastName;
                    pvc.dob = self.retDob;
                    pvc.age = self.retAge;
                    pvc.gender = self.retGender;
                    pvc.email = self.retEmail;
                    pvc.phone = self.retContactno;
                    pvc.bloodgrp= self.retBloodGroup;
                    pvc.addr = self.retAddr;
                    pvc.zipcode = self.retZipcode;*/
                    pvc.username = self.enteredUsername;
                   // pvc.imgname = self.imgName;
                     UINavigationController *nav1 = [tabbar.viewControllers objectAtIndex:1];
                    EditProfileController *epc = (EditProfileController *)[nav1 topViewController];
                    epc.itemFirstName = self.retFirstName;
                    epc.itemLastName = self.retLastName;
                    epc.itemUsername = self.enteredUsername;
                    [tabbar setSelectedIndex:0];
                    
                }
                //Pop up alert if the username and password not matches
                else{
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Wrong Username or Password"
                                                                    message:@"Username and password mismatch"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    self.AuthUserName.text=@"";
                    self.AuthPassword.text=@"";
                    
                }
                
            }
            
        }
        //pop up alert if the username not exists in the database
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Username and Password"
                                                            message:@"Username not exists. Create New User!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
            self.AuthUserName.text=@"";
            self.AuthPassword.text=@"";
        }
        
        sqlite3_close(db);
    }
    
}

//send the control to the view to create new user profile
- (IBAction)createUser:(id)sender {
    
    CreateAuthController *cac = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateAuth"];
    [self.navigationController pushViewController:cac animated:YES];
   /* NewUserController *nuc = [self.storyboard instantiateViewControllerWithIdentifier:@"newuserview"];
    [self.navigationController pushViewController:nuc animated:YES];*/
    
}

//send the control to the view to retrieve password
- (IBAction)forgotPassword:(id)sender {
    
    self.enteredUsername = self.AuthUserName.text;
    //pop up alert of if the username is not entered in the textfield
    if([self.enteredUsername length] == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Username!"
                                                        message:@"If new user, click New user to sign up!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        AuthViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthView"];
        [self presentViewController:avc animated:NO completion:nil];
    }
    else{
        //navigate to RecoverPasswordController
        RecoverPasswordController * rvc = [self.storyboard instantiateViewControllerWithIdentifier:@"recoverpwd"];
        [self retrieveAuthDetails ];
        if([self.retrievedUsername isEqualToString:self.enteredUsername]){
            rvc.itemUsername = self.retrievedUsername;
            rvc.itemPwd = _retrievedPwd;
            rvc.itemSecQue = self.secque;
            rvc.itemAns = self.secans;
            
            [self.navigationController pushViewController:rvc animated:YES];
        }
        //pop up alert if the username not exists on the database
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username not exists!"
                                                            message:@"If new user, click New user to sign up!"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog( @"Transition via segue: '%@'", segue.identifier);
    [super prepareForSegue:segue sender:sender];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
