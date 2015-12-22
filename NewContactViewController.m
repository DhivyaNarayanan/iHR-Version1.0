//
//  Name of the file:NewContactViewController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File allows you to add new doctors contact into the table//  Created by Dhivya Narayanan on 12/3/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NewContactViewController.h"
#import"DoctorListController.h"

@interface NewContactViewController ()

@end

@implementation NewContactViewController

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


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    self.backgroundImg.alpha = 0.4;
    self.navigationItem.title = @"New Contact";
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Save"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(addtoList:)];
    self.navigationItem.rightBarButtonItem = saveButton;
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Cancel"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                     action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setToolbarHidden:YES animated:NO];
    [super viewDidLoad];
    
}

//Clear all the entries in the textfields
- (IBAction)refresh:(id)sender {
    self.nameField.text =@"";
    self.phoneNoTxt.text=@"";
    self.hospitalField.text=@"";
    self.emailTxt.text=@"";
    self.specializationTxt.text=@"";
    self.addrTxt.text=@"";
    NSLog(@"values cleared");
}

//Add the entered values into the database table
- (IBAction)addtoList:(id)sender {
    
    self.enteredName= self.nameField.text;
    self.enteredHospital =self.hospitalField.text;
    if(![self isEmpty]){
        if([self.extTxt text] && [self validatePhoneno:[self.phoneNoTxt text]]){
            self.enteredPhone = [self.extTxt.text stringByAppendingString:self.phoneNoTxt.text];
            self.enteredEmail = self.emailTxt.text;
            self.enteredSpl = self.specializationTxt.text;
            self.enteredAddr = self.addrTxt.text;
            
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
                                     stringWithFormat:@"INSERT INTO DoctorListTable (UserName,DoctorName,ContactNo,Email,Specialization,HospitalName,Address) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,_enteredName,_enteredPhone,_enteredEmail,_enteredSpl,_enteredHospital,_enteredAddr];
                char * errMsg;
                rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
                if(SQLITE_OK != rc)
                {
                    NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
                }
                sqlite3_close(db);
            }
            
            DoctorListController* newView = [self.storyboard instantiateViewControllerWithIdentifier:@"doctorlistview"];
            newView.itemUserName = self.itemUsername;
           
           /* */

            UINavigationController *navController = self.navigationController;
            NSMutableArray *controllers=[[NSMutableArray alloc] initWithArray:navController.viewControllers] ;
            [UIView  beginAnimations:nil context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.75];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
            [UIView commitAnimations];
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDelay:0.375];
            [controllers removeLastObject];
            [controllers removeLastObject];
            [navController setViewControllers:controllers];
            
            
            [self.navigationController setToolbarHidden:YES animated:NO];
           
            [navController pushViewController:newView animated:NO];
            [UIView commitAnimations];
            
        
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Contact no!"
                                                            message:@"check phone no."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Some Fields are Empty!"
                                                        message:@"Doctor's Name, Contact No, Hospital Name and Specialization should not be Empty!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(BOOL)isEmpty{
    if(self.nameField.text && self.nameField.text.length >0){
        if(self.hospitalField.text && self.hospitalField.text.length > 0){
            if(self.phoneNoTxt.text && self.phoneNoTxt.text.length >0){
                if(self.specializationTxt.text && self.specializationTxt.text.length > 0){
                    return NO;
                }
            }
        }
        
    }
    return YES;
}

-(BOOL)validatePhoneno:(NSString *) candidate
{
    NSString *filter = @"[0-9]{7}([0-9]{3})?";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", filter];
    return [predicate evaluateWithObject:candidate];
    
}

- (IBAction)cancel:(id)sender {
    DoctorListController* newView = [self.storyboard instantiateViewControllerWithIdentifier:@"doctorlistview"];
    newView.itemUserName = self.itemUsername;
    
    
    
   // UINavigationController *navController = self.navigationController;
    
    //Get all view controllers in navigation controller currently
   // NSMutableArray *controllers=[[NSMutableArray alloc] initWithArray:navController.viewControllers] ;
    
    //Remove the last view controller
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
    //[self.navigationController popViewControllerAnimated:NO];
    //[self.navigationController pushViewController:newView animated:NO];
   
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
