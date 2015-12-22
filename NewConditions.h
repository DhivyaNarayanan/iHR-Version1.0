//
//  NewConditions.h
//  MyiHR
//
//  Created by Dhivya Narayanan on 12/17/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface NewConditions : UIViewController{
    sqlite3 *db;
}


@property (weak, nonatomic) IBOutlet UIImageView *backgroundImg;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
- (IBAction)calendarBt:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *conditionsField;
@property (weak, nonatomic) IBOutlet UITextField *commentsField;
- (IBAction)refresh:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (strong, nonatomic) NSString* itemUsername;
@property(strong,nonatomic)NSString* valuefor;
-(NSString *) filePath;  //database get stored at this path
-(void)openDB;

@property(nonatomic)NSString* itemCurCondition;
@property(nonatomic)NSDate * enteredDate;
-(void)insertCondition;
-(void)insertAllergies;
-(void)insertProcedures;
-(void)insertDevices;
-(void)insertSugarValues;
-(void)insertHeight;
-(void)insertWeight;
-(void)insertBMI;



@end

