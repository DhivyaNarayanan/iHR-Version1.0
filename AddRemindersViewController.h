//
//  Name of the file:AddRemindersViewController.h
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File  add remainders to the app and sends notification to the user during due date and time
////  Created by Ankita Kashyap on 12/9/15.
//  Copyright © 2015 Ankita Kashyap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRemindersViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *enter_text;

@property (weak, nonatomic) IBOutlet UIDatePicker *picker;

- (IBAction)save:(UIBarButtonItem*)sender;

- (IBAction)cancel:(UIBarButtonItem*)sender;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;


@end

