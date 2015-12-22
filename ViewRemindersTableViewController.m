//
//  Name of the file:ViewRemindersTableViewController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File  display all remainders in the table view
//

//  Created by Ankita Kashyap on 12/10/15.
//  Copyright © 2015 Ankita Kashyap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewRemindersTableViewController.h"


@interface ViewRemindersTableViewController()

@end
@implementation ViewRemindersTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CALayer *background = [CALayer layer];
    background.zPosition = -1;
    background.frame = self.view.frame;
    background.contents = (__bridge id)([[UIImage imageNamed:@"bg.jpg"] CGImage]);
    [self.tableView.layer addSublayer:background];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[UIApplication sharedApplication]scheduledLocalNotifications]count];
}
//Display notifications in the tableview

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ViewReminderCell"; // reuse identifier
    
    
    // check if we can reuse a cell from row that just went off screen
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSArray *notify=[[UIApplication sharedApplication]scheduledLocalNotifications];
    
    UILocalNotification *notification=[notify objectAtIndex:indexPath.row];
    
    NSDateFormatter *Dateformat =[[NSDateFormatter alloc]init];
    
    [Dateformat setDateStyle:(NSDateFormatterMediumStyle)];
    
    NSDateFormatter *timeform=[[NSDateFormatter alloc]init];
    
    [timeform setDateFormat:@"h:mm a"];
    
    NSString * fdate=[Dateformat stringFromDate:notification.fireDate];
    NSString * ftime=[timeform stringFromDate:notification.fireDate];
    
    NSString *date_time=[NSString stringWithFormat:@"%@ - %@",fdate,ftime];
    
    [cell.detailTextLabel setText:date_time];
    
    
    [cell.textLabel setText:notification.alertBody];
    
    // [cell.detailTextLabel setText:[notification.fireDate description]];
    
    return cell;
}


//override for editing the table view
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(editingStyle==UITableViewCellEditingStyleDelete){
        //delete row
        
        NSArray* reminder_array=[[UIApplication sharedApplication]scheduledLocalNotifications];
        [[UIApplication sharedApplication]cancelLocalNotification:[reminder_array objectAtIndex:indexPath.row]];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.tableView reloadData];
        
        
    }
    
    
    
}




@end