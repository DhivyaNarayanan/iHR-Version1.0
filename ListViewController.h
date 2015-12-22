//
//  Name of the file:ListViewController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File displays categories like Doctor's list, manage prescriptions and summary records in tableview.
//  Created by Dhivya Narayanan on 12/3/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface ListViewController : UITableViewController

@property (strong, nonatomic) NSArray *contents;
@property(strong, nonatomic)NSString* itemUsername;


@end



