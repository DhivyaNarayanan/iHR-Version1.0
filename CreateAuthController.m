//
//  Name of the file: CreateAuthController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File gets the authentication details from the user. All the fields should be enetered. Once they click submit, new user will be created and all the values will be stored into database//  Created by Dhivya Narayanan on 12/2/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreateAuthController.h"
#import "PreviewController.h"
#import "EditProfileController.h"

@interface CreateAuthController()

@end

@implementation CreateAuthController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//file path to db
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


- (void)viewDidLoad {
    
    self.backgroundImg.alpha = 0.4;
    self.navigationItem.title = @"New User SignUp";
    
    self.itemDob =@"";
    self.itemAge =@"";
    self.itemGender = @"";
    self.itemBloodGroup = @"";
    self.itemContactno=@"";
    self.itemEmail=@"";
    self.itemAddr = @"";
    self.itemCity=@"";
    self.itemState=@"";
    self.itemCountry=@"";
    self.itemZipcode=@"";
    
    [super viewDidLoad];
    self.queData = [[NSArray alloc]initWithObjects:@"Mother's Maiden Name",@"Name of your Favorite Car",@"Name of your first school", nil];
    self.tableviewQue.delegate = self;
    self.tableviewQue.dataSource = self;
    self.assignPasswordTxt.secureTextEntry = YES;
    self.confirmPasswordTxt.secureTextEntry = YES;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [self createTableAuthDetails];   //Create table for Auth details
    [self createTableProfilePic];    //Create table for profile picture
    [self createTableMyProfile];     //Create table for profile details
    [self createTableDoctorList];    //Create table to store doctor's list
    [self createTablePresList];      //Create table to store all prescriptions
    [self createTableAllergy];       //Create table to store allergies
    [self createTableConditions];    //Create table for conditions
    [self createTableDevices];       //Create table for devices
    [self createTableProcedures];    //Create table for Procedures
    [self createTableSugar];         //Create table for sugar values
    [self createTableBMI];           //Create table for BMI values
    [self createTableBP];            //Create table for BP values
    [self createTableWeight];        //Create table for Weight Values
    [self createTableHeight];        //Create table for Height values
    [self createTableMedications];   //Create table for medications
    
}

//pragma for Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.queData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; // reuse identifier
    
    // check if we can reuse a cell from row that just went off screen
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    // create new cell, if needed
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // set text attibute of cell
    cell.textLabel.text = [self.queData objectAtIndex:indexPath.row];
    
    // set accessory type to standard detail disclosure indicator
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}

//select security question from tableview cells
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableviewQue cellForRowAtIndexPath:indexPath];
    [self.secQueBtOutlet setTitle:cell.textLabel.text forState:UIControlStateNormal];
    self.tableviewQue.hidden= YES;
    self.itemSecQue = self.secQueBtOutlet.titleLabel.text;
    
}

//Action for select security question which will hide and show the tableview viceversa
- (IBAction)btAction:(id)sender {
    if(self.tableviewQue.hidden == YES)
        self.tableviewQue.hidden= NO;
    else
        self.tableviewQue.hidden = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

//Create Table 'MyProfileTable' to store profile values of all the users
-(void)createTableMyProfile{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS MyProfileTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, FirstName  TEXT, LastName TEXT, DateOfBirth TEXT, Age TEXT, Gender TEXT, Email TEXT, ContactNo TEXT, BloodGroup TEXT, Address TEXT, Zipcode TEXT, UserName TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
        
    }
    
}

//Create Table 'AuthDetailsTable' to store Authentication values of all the users
-(void)createTableAuthDetails{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS AuthDetailsTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, Password TEXT, SecurityQuestion TEXT, Answer TEXT, FirstName TEXT, LastName TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
    
}


//Create Table 'ProfilePic' to store profile picture of all the users

-(void)createTableProfilePic{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS ProfilePicTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, ImagePath TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
    
}


//Create Table 'DoctorListTable' to store doctor's contacts
-(void)createTableDoctorList{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS DoctorListTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, DoctorName TEXT, ContactNo TEXT, Email TEXT, Specialization TEXT, HospitalName TEXT, Address TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
    
}

//Create Table 'PrescriptionListTable' to store all the prescriptions
-(void)createTablePresList{
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS PrescriptionListTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, PrescriptionName TEXT, PrescribedBy TEXT, Date TEXT, Prescription TEXT, Comments TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
    
}

//Create Table 'ConditionsTable' to store conditions of all the users
-(void)createTableConditions{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS ConditionsTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, DateTime TEXT, Conditions TEXT, Comments TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
    
}

//Create Table 'AllergyTable' to store allergy values
-(void)createTableAllergy{
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS AllergyTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, DateTime TEXT, Allergy TEXT, Comments TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
    
}

//Create Table 'DevicesTable' to store all the devices
-(void)createTableDevices{
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS DevicesTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, DateTime TEXT, Devices TEXT, Comments TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
    
}

//Create Table 'ProceduresTable' to store procedures values of all the users
-(void)createTableProcedures{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS ProceduresTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, DateTime TEXT, Procedures TEXT, Comments TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
    
}

//Create Table 'WeightListTable' to store weight values
-(void)createTableWeight{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS WeightListTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, DateTime TEXT, Weight TEXT, Comments TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
}

//Create Table 'HeightListTable' to store height values
-(void)createTableHeight{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS HeightListTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, DateTime TEXT, Height TEXT, Comments TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
}

//Create Table 'BMIListTable' to store BMI values
-(void)createTableBMI{
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS BMIListTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, DateTime TEXT, Bmi TEXT, Comments TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
    
}

//Create Table 'SugarListTable' to store Blood sugar values
-(void)createTableSugar{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS SugarListTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, DateTime TEXT, Sugar TEXT, Comments TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
    
}

//Create Table 'BPListTable' to store Blood pressure values
-(void)createTableBP{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS BPListTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, DateTime TEXT, Systolic TEXT, Diastolic TEXT, Comments TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
    
}

//Create Table 'MedicationsTable' to store medications values
-(void)createTableMedications{
    
    int rc=0;
    
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE | SQLITE_OPEN_CREATE, NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        char *err;
        int rc=0;
        char * query ="CREATE TABLE IF NOT EXISTS MedicationsTable ( id INTEGER PRIMARY KEY AUTOINCREMENT, UserName  TEXT, DateTime TEXT, Medications TEXT, Comments TEXT)";
        rc = sqlite3_exec(db, query,NULL,NULL,&err);
        
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to create table rc:%d, msg=%s",rc,err);
        }
        
        sqlite3_close(db);
    }
    
}


//Insert profile values into the table 'MyProfileTable'
-(void)insertprofile{
    self.itemUsername = self.enterUserNameTxt.text;
    
    NSString* fulladdr=@"";
    if(self.itemAddr){
        fulladdr = self.itemAddr;
        if(self.itemCity){
            fulladdr = [self.itemAddr stringByAppendingString:@", "];
            fulladdr = [fulladdr stringByAppendingString:_itemCity];
            if(self.itemState){
                fulladdr = [fulladdr stringByAppendingString:@", "];
                fulladdr = [fulladdr stringByAppendingString:_itemState];
                if(self.itemCountry){
                    fulladdr = [fulladdr stringByAppendingString:@", "];
                    fulladdr = [fulladdr stringByAppendingString:_itemCountry];
                }
            }
        }
    }
    
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"INSERT INTO MyProfileTable (FirstName,LastName,DateOfBirth,Age,Gender,Email,ContactNo,BloodGroup,Address,Zipcode,UserName) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",_itemFirstName,_itemLastName,_itemDob,_itemAge,_itemGender,_itemEmail,_itemContactno,_itemBloodGroup,fulladdr,_itemZipcode,_itemUsername];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
}


//Insert auth detail values into the table 'AuthDetailTable'
-(void)insertauthdetails{
    
    
    NSString * pwd1 = self.assignPasswordTxt.text;
    NSString *pwd2 = self.confirmPasswordTxt.text;
    NSLog(@"itemUsername: %@",self.itemUsername);
    
    if([pwd1 isEqualToString:pwd2]){
        self.itemPwd = pwd1;
        self.itemAns = self.enterAnswerTxt.text;
        NSLog(@"itemPwd: %@",self.itemPwd);
        NSLog(@"itemsecque: %@",self.itemSecQue);
        NSLog(@"itemans: %@",self.itemAns);
        
        int rc=0;
        rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog(@"Failed to open db connection");
        }
        else
        {
            NSString * query  = [NSString
                                 stringWithFormat:@"INSERT INTO AuthDetailsTable (UserName,Password,SecurityQuestion,Answer,FirstName,LastName) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,_itemPwd,_itemSecQue,_itemAns,_itemFirstName,_itemLastName];
            char * errMsg;
            rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }
    }
    
    //pop up alert if the password doesn't match
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Mismatch!"
                                                        message:@"Check password."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        self.assignPasswordTxt.text=@"";
        self.confirmPasswordTxt.text=@"";
    }
    
}

-(void)insertprofilepic{
    
    
}

//Check for empty fields
-(BOOL)isEmpty{
    
    if(self.enterUserNameTxt.text && self.enterUserNameTxt.text.length >0){
        if(self.assignPasswordTxt.text && self.assignPasswordTxt.text.length > 0){
            if(self.confirmPasswordTxt.text && self.confirmPasswordTxt.text.length > 0){
                if(self.enterAnswerTxt.text && self.enterAnswerTxt.text.length>0){
                    return NO;
                }
            }
        }
    }
    return YES;
}

//Insert all the values into the table when submit button is clicked and pass the controller to Tabbar controller
- (IBAction)submitAuthDetails:(id)sender {
    self.itemFirstName = self.firstNameTxt.text;
    self.itemLastName = self.lastNameTxt.text;
    self.itemUsername = self.enterUserNameTxt.text;
    if(![self isEmpty]){
        
        [self insertprofile];   //insert into profileTable
        
        [self insertauthdetails];  //insert into AuthDetailTable
        
        //Store the image name and path and pass it to preview controller
        if (self.imagePic != nil)
        {
            self. imgName = @"imageOf";
            self.imgName = [self.imgName stringByAppendingString:self.itemUsername];
            self.imgName = [self.imgName stringByAppendingString:@".png"];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString* path = [documentsDirectory stringByAppendingPathComponent:self.imgName ];
            NSData* data = UIImagePNGRepresentation(self.imagePic);
            [data writeToFile:path atomically:NO];
            self.imagePath = path;
            NSLog(@"Image saved..");
        }
        
        //Navigate to UITabBarController
        UITabBarController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"tabbarview"];
        [self presentViewController:tabbar animated:YES completion:nil];
        
        UINavigationController *nav = [tabbar.viewControllers objectAtIndex:0];
        PreviewController *pvc = (PreviewController *)[nav topViewController];
        
        pvc.fName = self.itemFirstName;
        pvc.lName = self.itemLastName;
        pvc.dob = self.itemDob;
        pvc.age = self.itemAge;
        pvc.gender = self.itemGender;
        pvc.email = self.itemEmail;
        pvc.phone = self.itemContactno;
        pvc.bloodgrp= self.itemBloodGroup;
        pvc.addr = self.itemAddr;
        pvc.zipcode = self.itemZipcode;
        pvc.username = self.itemUsername;
        pvc.imgname = self.imgName;
        
        UINavigationController *nav1 = [tabbar.viewControllers objectAtIndex:1];
        EditProfileController *epc = (EditProfileController*)[nav1 topViewController];
        epc.itemFirstName = self.itemFirstName;
        epc.itemLastName = self.itemLastName;
        epc.itemUsername = self.itemUsername;
        [tabbar setSelectedIndex:0];       //set the first tab bar view visible
        
    }
    //pop up alert if there are empty fields
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Fields!"
                                                        message:@"Enter All the fields"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
    
}


@end
