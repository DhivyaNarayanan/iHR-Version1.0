#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CKCalendarView.h"
#import "BloodPressureController.h"
#import "ConditionsController.h"

@interface BloodPressureController() <CKCalendarDelegate>

@property(nonatomic, weak) CKCalendarView *calendar;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;


@end

@implementation BloodPressureController


-(void)viewDidLoad{
    self.navigationItem.title = @"New Record";
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
    //self.titleLabel.text = self.valuefor;
    self.backgroundImg.alpha =0.4;
    [super viewDidLoad];
    [self.navigationController setToolbarHidden:YES animated:YES];
}


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

-(IBAction)addtoList:(id)sender{
    
    [self insertPressureValue];
    ConditionsController* newView = [self.storyboard instantiateViewControllerWithIdentifier:@"conditionsview"];
    
    newView.itemUserName = self.itemUsername;
    newView.option = self.valuefor;
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
-(IBAction)cancel:(id)sender{
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


- (IBAction)calendarBt:(id)sender {
    
    CKCalendarView *calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    self.calendar = calendar;
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MM/dd/yyyy"];
    self.minimumDate = [self.dateFormatter dateFromString:@"09/20/2012"];
    
    self.disabledDates = @[
                           [self.dateFormatter dateFromString:@"01/05/2013"],
                           [self.dateFormatter dateFromString:@"01/06/2013"],
                           [self.dateFormatter dateFromString:@"01/07/2013"]
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
    self.enteredDate = date;
    self.dateField.text = [self.dateFormatter stringFromDate:date];
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


-(IBAction)refresh:(id)sender{
    
 self.dateField.text =@"";
    self.systolicField.text =@"";
    self.diastolicField.text =@"";
    self.commentsField.text =@"";
}

-(void)insertPressureValue{
    
    if ((self.systolicField.text && self.systolicField.text.length > 0) && (self.diastolicField.text && self.diastolicField.text.length > 0))
    {
        self.itemCurSystolic = self.systolicField.text;
        self.itemCurDiastolic = self.diastolicField.text;
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [formatter setDateFormat:@"yyyy-MM-dd"];
       // NSDate *theDate = [NSDate date];
        NSString *comments= self.commentsField.text;
       // NSString * datestr = [dateFormat stringFromDate:theDate];
         NSString * datestr = [dateFormat stringFromDate:self.enteredDate];
        int rc=0;
        rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
        if (SQLITE_OK != rc)
        {
            sqlite3_close(db);
            NSLog(@"Failed to open db connection");
        }
        else
        {
            NSString * query  = [NSString
                                 stringWithFormat:@"INSERT INTO BPListTable (UserName,DateTime,Systolic,Diastolic,Comments) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",_itemUsername,datestr,_itemCurSystolic,_itemCurDiastolic,comments];
            char * errMsg;
            rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
            if(SQLITE_OK != rc)
            {
                NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
            }
            sqlite3_close(db);
        }
        
    }
    

}

@end