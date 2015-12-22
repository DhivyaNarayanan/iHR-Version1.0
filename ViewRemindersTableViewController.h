//
//  Name of the file:ViewRemindersTableViewController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File  display all remainders in the table view
////
//  Created by Ankita Kashyap on 12/10/15.
//  Copyright © 2015 Ankita Kashyap. All rights reserved.
//


#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>


@interface ViewRemindersTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@end
