//
//  Name of the file: RecoverPasswordController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File recovers the password by entering the username and proper security question and answer
//  Created by Dhivya Narayanan on 12/2/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RecoverPasswordController.h"

@interface RecoverPasswordController()

@property(nonatomic)NSString* enteredSecurityQuestion;

@end

@implementation RecoverPasswordController

//file path to db
-(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"myihrrecords.sql"];
}

//open the db
-(void)openDB{
    
    if(sqlite3_open([[self filePath] UTF8String], &db) != SQLITE_OK){
        sqlite3_close(db);
        NSAssert(0,@"Database failed to open");
    }else{
        NSLog(@"Database opened");
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad {
    
    self.backgroundImg.alpha = 0.4;
    self.navigationItem.title = @"Password Recovery";
    NSLog(@"Entered new user view controller");
    self.queData = [[NSArray alloc]initWithObjects:@"Mother's Maiden Name",@"Name of your Favorite Car",@"Name of your first school", nil];
    [super viewDidLoad];
}

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.tableviewQue cellForRowAtIndexPath:indexPath];
    [self.secQueBtOutlet setTitle:cell.textLabel.text forState:UIControlStateNormal];
    self.tableviewQue.hidden= YES;
    self.enteredSecQue = self.secQueBtOutlet.titleLabel.text;
    
}

- (IBAction)btAction:(id)sender {
    if(self.tableviewQue.hidden == YES)
        self.tableviewQue.hidden= NO;
    else
        self.tableviewQue.hidden = YES;
}

//recover password if the entered username exists in the database

- (IBAction)recoverPwd:(id)sender {
    NSString * que = self.enteredSecQue;
    NSString * ans = [self.enterAnswerTxt.text lowercaseString];
    NSString *str1 = @"UserName :  ";
    str1 = [str1 stringByAppendingString:self.itemUsername];
    NSString *str2 = @"Password:   ";
    str2 = [str2 stringByAppendingString:self.itemPwd];
    
    NSString *str = [str1 stringByAppendingString:@"\n"];
    str = [str stringByAppendingString:str2];
    NSString *tmpans = [self.itemAns lowercaseString];
    if([que isEqualToString:self.itemSecQue] && [ans isEqualToString:tmpans]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Recovery"
                                                        message:str
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        [alert show];
        //[alert release];
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"MisMatch!"
                                                        message:@"wrong Answer / security question"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
    
}

//action for button click in alertview - which simply returns back to login page
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        //Code for cancel button
    }
    if (buttonIndex == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
       /* AuthViewController* newView = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthView"];
        [self presentViewController:newView animated:YES completion:nil];*/
    }
}


@end