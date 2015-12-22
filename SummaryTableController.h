//
//  Name of the file:SummaryTableController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File  displays categories like Conditions, weight, Blood pressure and etc. in tableview.

//  Created by Dhivya Narayanan on 12/5/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface SummaryTableController : UIViewController{
    sqlite3 *db;
}

//IBoutlet to tableview
@property (weak, nonatomic) IBOutlet UITableView *summaryview;
@property (strong,nonatomic) NSString *itemUsername;

@end


