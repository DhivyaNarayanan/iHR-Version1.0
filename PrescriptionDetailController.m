//
//  Name of the file:PrescriptionDetailController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File displays the detail of particular prescription and allow you to make a call to that doctor from the app

//  Created by Dhivya Narayanan on 12/4/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"PrescriptionDetailController.h"
#import "AuthViewController.h"

@interface PrescriptionDetailController()

@end
@implementation PrescriptionDetailController

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



- (void)viewWillAppear:(BOOL)animated{
    
    
    self.prescriptionName.text=self.itemPreName;
    self.prescribedBy.text = self.itemPreDrName;
    self.prescribedOn.text = self.itemPreDate;
    self.comments.text = self.itemPreComments;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:self.itemPreFile ];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:path]) {
        UIImage * image1 = [UIImage imageWithContentsOfFile:path];
        [self.prescriptionImage setImage:image1];
    }
    
}


- (void)viewDidLoad {
    
    NSLog(@"Entered DetailController");
    
    
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logout:)];
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Share"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(share:)];
    //[self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:btnShare,btnRefresh, nil]];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:logoutButton, shareButton,nil];
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

//Method to logout from the app

-(IBAction)logout:(id)sender{
    //AuthView
    AuthViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthView"];
    [self presentViewController:avc animated:YES completion:nil];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated{
    
    self.prescriptionName.text=@"";
    self.prescribedBy.text = @"";
    self.prescribedOn.text = @"";
    self.comments.text = @"";
    
}

//Method to share the prescription with others.
- (IBAction)share:(id)sender {
    
    NSString *prestr = self.itemPreName;
    prestr = [prestr stringByAppendingString:@"\nPrescribed By \""];
    prestr = [prestr stringByAppendingString:self.itemPreDrName];
    // NSString *text=@"Hi! I gotta share";
    NSArray *items= [[NSArray alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:self.itemPreFile ];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:path]) {
        UIImage * image1 = [UIImage imageWithContentsOfFile:path];
        //[self.profileImg setImage:image1];
        items=@[prestr, image1];
    }
    else{
        items=@[prestr];
    }
    
    UIActivityViewController *act=[[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
    
    //in case we want to exclude any sharing apps, we can include it here
    act.excludedActivityTypes=@[];
    
    // adds a bit of animation
    [self presentViewController:act  animated:YES completion:nil];
}
@end
