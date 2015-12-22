//
//  Name of the file:NewPrescriptionController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File allows you to add new prescriptions into the table

//  Created by Dhivya Narayanan on 12/4/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "NewPrescriptionController.h"
#import "PrescriptionListController.h"
#import "CKCalendarView.h"

@interface NewPrescriptionController () <CKCalendarDelegate>
@property(nonatomic)UIImage* myImage;
@property(strong, nonatomic)NSString* imageFilePath;
@property(nonatomic)NSString* imgName;
@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;


@end

@implementation NewPrescriptionController

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

//Attach file from the gallery

- (IBAction)attachFile:(id)sender{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

//Capture the image and display it in imageview and stored into table
- (IBAction)takePicture:(id)sender{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (IBAction)calendarBt:(id)sender {
    
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"20/09/2012"];
    
    self.disabledDates = @[
                           [self.dateFormatter dateFromString:@"05/01/2013"],
                           [self.dateFormatter dateFromString:@"06/01/2013"],
                           [self.dateFormatter dateFromString:@"07/01/2013"]
                           ];
    
    calendar.onlyShowCurrentMonth = NO;
    calendar.adaptHeightToNumberOfWeeksInMonth = YES;
    
    calendar.frame = CGRectMake(75, 75, 300, 320);
    [self.view addSubview:calendar];
    
    //self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(calendar.frame) + 4, self.view.bounds.size.width, 24)];
    //[self.view addSubview:self.dateLabel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(localeDidChange) name:NSCurrentLocaleDidChangeNotification object:nil];

}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    
    // Dismiss the image selection, hide the picker and
    
    //show the image view with the picked image
    
    [picker dismissModalViewControllerAnimated:YES];
    self.myImage = image;
    [self.prescriptionImage setImage:self.myImage];
    
    
}

- (void)viewDidLoad
{
    self.navigationItem.title = @"New Prescription";
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
    self.backgroundImg.alpha =0.4;
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Clear all the entries in the textfields

- (IBAction)refresh:(id)sender {
    self.nameField.text=@"";
    self.prescribedByTxt.text =@"";
    self.prescribedOnTxt.text=@"";
    self.commentsTxt.text=@"";
    
}

//add entered values into the database table

- (IBAction)addtoList:(id)sender {
    
    self.enteredPreName= self.nameField.text;
    if([self.nameField text]&& self.nameField.text.length > 0){
        self.enteredPreDrName = self.prescribedByTxt.text;
        self.enteredDate = self.prescribedOnTxt.text;
        self.enteredComments = self.commentsTxt.text;
        if (self.myImage != nil)
        {
            self. imgName = @"preOf";
            self.imgName = [self.imgName stringByAppendingString:self.enteredPreName];
            self.imgName = [self.imgName stringByAppendingString:@".png"];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                 NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            NSString* path = [documentsDirectory stringByAppendingPathComponent:self.imgName ];
            NSData* data = UIImagePNGRepresentation(self.myImage);
            [data writeToFile:path atomically:NO];
            NSLog(@"PrescriptionImageFile saved..");
        }
        
        //open the database
        int rc=0;
        rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog(@"Failed to open db connection");
        }
        else
        {
            //Insert values into the table
            NSString * query  = [NSString
                                 stringWithFormat:@"INSERT INTO PrescriptionListTable (UserName,PrescriptionName,PrescribedBy,Date,Prescription,Comments) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,_enteredPreName,_enteredPreDrName,_enteredDate,_imgName,_enteredComments];
            char * errMsg;
            rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }
        
        PrescriptionListController* newView = [self.storyboard instantiateViewControllerWithIdentifier:@"prescriptionlistview"];
        
        newView.itemUserName = self.itemUsername;
        UINavigationController *navController = self.navigationController;
        
        //Get all view controllers in navigation controller currently
        NSMutableArray *controllers=[[NSMutableArray alloc] initWithArray:navController.viewControllers] ;
        
        //Remove the last view controller
        
                        //set the new set of view controllers
        /*
       */
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
        //[self.navigationController popViewControllerAnimated:NO];
        [navController pushViewController:newView animated:NO];
        [UIView commitAnimations];
        

    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Empty Prescription Name!"
                                                        message:@"Please Enter value to presecription name"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        
    }
}

//Discard the values entered and return back to previous list view controller
- (IBAction)cancel:(id)sender {
    PrescriptionListController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"prescriptionlistview"];
    newView.itemUserName = self.itemUsername;
    /*UINavigationController *navController = self.navigationController;
    
    //Get all view controllers in navigation controller currently
    NSMutableArray *controllers=[[NSMutableArray alloc] initWithArray:navController.viewControllers] ;
    
    //Remove the last view controller
    [controllers removeLastObject];
   
    
    //set the new set of view controllers
    [navController setViewControllers:controllers];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.navigationController pushViewController:newView animated:YES];*/
   
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];


}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (void)localeDidChange {
    [self.calendar setLocale:[NSLocale currentLocale]];
}

- (BOOL)dateIsDisabled:(NSDate *)date {
    for (NSDate *disabledDate in self.disabledDates) {
        if ([disabledDate isEqualToDate:date]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark - CKCalendarDelegate

- (void)calendar:(CKCalendarView *)calendar configureDateItem:(CKDateItem *)dateItem forDate:(NSDate *)date {
    // TODO: play with the coloring if we want to...
    if ([self dateIsDisabled:date]) {
        dateItem.backgroundColor = [UIColor redColor];
        dateItem.textColor = [UIColor whiteColor];
    }
}

- (BOOL)calendar:(CKCalendarView *)calendar willSelectDate:(NSDate *)date {
    return ![self dateIsDisabled:date];
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date {
   // self.dateLabel.text = [self.dateFormatter stringFromDate:date];
    self.prescribedOnTxt.text = [self.dateFormatter stringFromDate:date];
    [self.calendar removeFromSuperview];
    
}

- (BOOL)calendar:(CKCalendarView *)calendar willChangeToMonth:(NSDate *)date {
    if ([date laterDate:self.minimumDate] == date) {
        self.calendar.backgroundColor = [UIColor blueColor];
        return YES;
    } else {
        self.calendar.backgroundColor = [UIColor redColor];
        return NO;
    }
}

- (void)calendar:(CKCalendarView *)calendar didLayoutInRect:(CGRect)frame {
    NSLog(@"calendar layout: %@", NSStringFromCGRect(frame));
}


@end

