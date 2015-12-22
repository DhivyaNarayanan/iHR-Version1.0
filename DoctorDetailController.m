//
//  Name of the file:DoctorDetailController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File displays the detail of particular doctor and allow you to make a call to that doctor from the app
//  Created by Dhivya Narayanan on 12/3/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"DoctorDetailController.h"
#import"AuthViewController.h"

@interface DoctorDetailController()
@property (nonatomic)NSString* doctorNo;
@end
@implementation DoctorDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

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


//Initialize view with retrived doctor details

- (void)viewWillAppear:(BOOL)animated{
    
    
    self.fullNameLabel.text = self.itemDrName;
    self.specialistLabel.text = self.itemSpl;
    self.hospitalLabel.text = self.itemHospital;
    self.contactNoLabel.text = self.itemDrContactno;
    self.emailLabel.text = self.itemDrEmail;
    self.addrLabel.text = self.itemDrAddr;
    self.doctorNo = self.itemDrContactno;
    [self.navigationController setToolbarHidden:YES animated:NO];
    
}


- (void)viewDidLoad {
    
    NSLog(@"Entered DetailController");
    
    NSLog(@"%@",self.itemDrName);
    NSLog(@"%@",self.itemDrAddr);
    NSLog(@"%@",self.itemDrContactno);
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logout:)];
    UIBarButtonItem *callButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"Call"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(makeCall:)];
    //[self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:btnShare,btnRefresh, nil]];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:logoutButton, callButton,nil];
    [self.navigationController setToolbarHidden:YES animated:YES];
   // self.navigationItem.rightBarButtonItem = logoutButton;
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//Method to logout of the app from this controller
-(IBAction)logout:(id)sender{
    //AuthView
    AuthViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthView"];
    //[self presentViewController:avc animated:YES completion:nil];
    [self.navigationController pushViewController:avc animated:YES];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated{
    self.fullNameLabel.text = @"";
    self.specialistLabel.text = @"";
    self.hospitalLabel.text = @"";
    self.contactNoLabel.text = @"";
    self.emailLabel.text =@"";
    self.addrLabel.text = @"";
}


//MEthod to make call to selected doctor contact
- (IBAction)makeCall:(id)sender {
    
    //[[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"tel:12345"]];
    
    NSString *URLString = [@"tel://" stringByAppendingString:self.doctorNo];
    
    NSURL *URL = [NSURL URLWithString:URLString];
    
    [[UIApplication sharedApplication] openURL:URL];
    
    
}
@end
