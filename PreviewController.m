//
//  Name of the file:PreviewController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File displays users current health condition along with his/her profile details.
//  Created by Dhivya Narayanan on 12/6/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PreviewController.h"
#import "AuthViewController.h"


@interface PreviewController()

@end

@implementation PreviewController

-(void) viewDidLoad{
    self.backgroundImg.alpha = 0.4;
    [super viewDidLoad];
    //Get values from previous tab bar controller and assign it to local variable
   // NSArray *viewControllers = [self.tabBarController viewControllers];
    /*ProfileViewController *pvc = [viewControllers objectAtIndex:0];
    self.username = pvc.itemUsername;
    self.ht = pvc.itemCurHeight;
    self.wt = pvc.itemCurWeight;
    self.bmi =pvc.itemCurBMI;
    self.sugar =pvc.itemCurBloodSugar;
    self.bpsystolic = pvc.itemCurSystolic;
    self.bpdiastolic = pvc.itemCurDiastolic;
    self.condArr = [[NSMutableArray alloc]init];
    [self.condArr addObjectsFromArray:pvc.curCondArr];
    self.allergyArr = [[NSMutableArray alloc]init];
    [self.allergyArr addObjectsFromArray:pvc.curAllergyArr];
    self.medArr = [[NSMutableArray alloc]init];
    [self.medArr addObjectsFromArray:pvc.curMedArr];
    self.proc= pvc.itemCurProcedures;
    self.devArr = [[NSMutableArray alloc]init];
    [self.devArr addObjectsFromArray:pvc.curDevicesArr];*/
    
    //Set UIBarButton for logout the app
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logout:)];
    self.navigationItem.rightBarButtonItem = logoutButton;
    
    //retrieve all the details of the user and display in the view
    [self retrieveProfValues];
    [self retrieveProfilePic];
    [self setData];
    
}


//Action for logout button - Bring in the Login page
-(IBAction)logout:(id)sender{
    //AuthView
    AuthViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthView"];
    [self.navigationController pushViewController:avc animated:YES];
    //[self presentViewController:avc animated:YES completion:nil];
    
}

//Get the filepath of the database
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


-(void)retrieveProfValues{
    
    //Open the database
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        //retrieve all the values from MyProfileTable - which return the profile details of the user
        NSString  * query = @"SELECT * from MyProfileTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                //Get all the values from SQLite statement and assign to local class variable
                self.fName =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                self.lName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.dob =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                self.age =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                self.gender =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                self.email =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
                self.phone =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
                self.bloodgrp =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
                self.addr =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];
                self.zipcode =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 10)];
                NSString* tempUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 11)];
                if([tempUsername isEqualToString:self.username]){
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
        sqlite3_close(db);
    }
    
}

//Retrieve profile pic
-(void)retrieveProfilePic{
    
    //open the database
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        //Retrieve profilepic of the user from the database
        NSString  * query = @"SELECT * from ProfilePicTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                NSString* user = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                self.imgname = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                if([user isEqualToString:self.username]){
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
        sqlite3_close(db);
    }
    
}

//display all the retrieve data to the view
-(void)setData{
    
    self.firstNameLabel.text= self.fName;
    self.lastNameLabel.text = self.lName;
    NSString *ageGender = [self.age stringByAppendingString:@" yrs "];
    ageGender = [ageGender stringByAppendingString:self.gender];
    self.ageGenderLabel.text = ageGender;
    self.dobLabel.text = self.dob;
    //Load the  image of profile picture
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:self.imgname ];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:path]) {
        UIImage * image1 = [UIImage imageWithContentsOfFile:path];
        [self.profileImg setImage:image1];
    }
    self.conditionsLabel.numberOfLines = [self.condArr count];
    self.medicationsLabel.numberOfLines = [self.medArr count];
    
    NSString* height =[self.ht stringByAppendingString:@"cm"];
    self.htLabel.text = height;   //set height value to the label
    
    NSString* weight = [self.wt stringByAppendingString:@"kg"];
    self.wtLabel.text = weight;   //set weight value to the label
    
    self.bmiLabel.text = self.bmi;  //Set BMI value to the label
    
    NSString* bloodsugar = [self.sugar stringByAppendingString:@"mg/dL"];
    self.sugarLabel.text = bloodsugar;    //set sugar value to the label
    
    NSString* bp = [self.bpsystolic stringByAppendingString:@"/"];
    bp = [bp stringByAppendingString:self.bpdiastolic];
    self.bpLabel.text = bp;                //set bloodpressure value to the label
    
    NSString *condstr = @"";
    for(int i=0; i< self.condArr.count ; i++){
        condstr = [condstr stringByAppendingString:self.condArr[i]];
        condstr = [condstr  stringByAppendingString:@"\n"];
    }
    self.conditionsLabel.text = condstr;    //set conditions value to the label
    
    
    NSString *medstr = @"";
    for(int i=0; i< self.medArr.count ; i++){
        medstr = [medstr stringByAppendingString:self.medArr[i]];
        medstr = [medstr  stringByAppendingString:@"\n"];
    }
    self.medicationsLabel.text = medstr;    //set medications value to the label
    
    
    NSString *bloodgroup = @"";
    bloodgroup = [bloodgroup stringByAppendingString:self.bloodgrp];
    self.bloodGrpLabel.text = bloodgroup;    //set bloodgroup value to the label
    
}

- (IBAction)editProfile:(id)sender {
    
    /*
     NewViewController *nvc = [self.storyboard instantiateViewControllerWithIdentifier:@"newview"];
     
     [UIView  beginAnimations:nil context:NULL];
     [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
     [UIView setAnimationDuration:0.75];
     [self.navigationController pushViewController:nvc animated:NO];
     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
     [UIView commitAnimations];
     
*/
}
@end