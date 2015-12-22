//
//  BloodPressureController.h
//  MyiHR
//
//  Created by Dhivya Narayanan on 12/17/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface BloodPressureController : UIViewController{
    sqlite3 *db;
}


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
- (IBAction)calendarBt:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *systolicField;
@property(weak,nonatomic) IBOutlet UITextField *diastolicField;
@property (weak, nonatomic) IBOutlet UITextField *commentsField;
- (IBAction)refresh:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSString* itemUsername;
@property(strong,nonatomic)NSString* valuefor;
-(NSString *) filePath;  //database get stored at this path
-(void)openDB;

@property(nonatomic)NSString* itemCurSystolic;
@property(nonatomic)NSString* itemCurDiastolic;

@property(nonatomic)NSDate * enteredDate;
-(void)insertPressureValue;
@end

