//
//  Name of the file:AddRemindersViewController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File  add remainders to the app and sends notification to the user during due date and time
//
//  Created by Ankita Kashyap on 12/9/15.
//  Copyright © 2015 Ankita Kashyap. All rights reserved.
//
#import"AddRemindersViewController.h"

@interface AddRemindersViewController ()

@end

@implementation AddRemindersViewController

- (void)viewDidLoad {
    self.backgroundImg.alpha = 0.4;
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}




-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return NO;
    
}

//Save the reminders

- (IBAction)save:(id)sender {
    NSDate * d=[self.picker date];
    
    UILocalNotification *local=[[UILocalNotification alloc]init];
    
    local.alertBody=_enter_text.text;
    local.fireDate=d;
    local.timeZone=[NSTimeZone defaultTimeZone];
    
    //  local.soundName=[UILocalNotificationDefaultSoundName];
    
    //  local.soundName=[UILocalNotificationDefaultSoundName];
    local.soundName = UILocalNotificationDefaultSoundName;
    
    // [[UIApplication sharedApplication] applicationIconBadgeNumber];
    
    
    local.applicationIconBadgeNumber=1;
    
    
    // local.repeatInterval= NSCalendarUnitMinute;
    
    [[UIApplication sharedApplication]scheduleLocalNotification:local];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
@end