//
//  Name of the file:ConditionsController.m
//  Name of the App: iHR
//  CourseName: CSE651 - MobileApplicationProgramming
//  Team Members: Dhivya Narayanan, Ankita Kashyap, Sridhar Ganapathy
//  Description: This File  displays conditions history of the user in the tableview and allows the option to restrict their view to 1 months history and 6 months history


#import <Foundation/Foundation.h>

#import "ConditionsController.h"
#import "AuthViewController.h"
#import "NewConditions.h"
#import "BloodPressureController.h"

@interface ConditionsController()

@property(nonatomic)NSMutableArray *conditions;
@property(nonatomic)NSMutableArray *condDisplay;
@property(nonatomic)NSInteger curdate;
@property(nonatomic)NSInteger curmonth;
@property(nonatomic)NSInteger curyear;

@end

@implementation ConditionsController
@synthesize segment, labelText;

-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.conditions = [[NSMutableArray alloc]init];
    self.condDisplay = [[NSMutableArray alloc]init];
    self.labelText.numberOfLines = self.conditions.count;
    self.navigationItem.title = self.option;
    if([self.option isEqualToString:@"Conditions"])
      [self retrieveCondDetails];
    if([self.option isEqualToString:@"Allergies"])
        [self retrieveAllergyDetails];
    if([self.option isEqualToString:@"Procedures"])
        [self retrieveProcedureDetails];
    if([self.option isEqualToString:@"Devices"])
        [self retrieveDeviceDetails];
    if([self.option isEqualToString:@"Blood Sugar"])
        [self retrieveSugarDetails];
    if([self.option isEqualToString:@"Blood Pressure"]){
        [self retrievePressureDetails];
    }
    if([self.option isEqualToString:@"Weight"])
        [self retrieveWeight];
    if([self.option isEqualToString:@"Height"])
        [self retrieveHeight];
    if([self.option isEqualToString:@"BMI"])
        [self retrieveBMI];


    //Height
    UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc]
                                     initWithTitle:@"LogOut"
                                     style:UIBarButtonItemStylePlain
                                     target:self
                                     action:@selector(logout:)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Add"
                                  style:UIBarButtonItemStylePlain
                                  target:self
                                  action:@selector(newvalue:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:logoutButton,addButton, nil];

    // self.navigationItem.rightBarButtonItem = logoutButton;
   // self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:logoutButton,nil];
    if([self.option isEqualToString:@"Blood Pressure"]){
       
        [self.tableViewTxt reloadData];
        for(int i=0; i< self.conditions.count;i++){
             NSString* str = @"";
            NSLog(@"conditions[i][1] : %@",self.conditions[i][1]);
            str =  [str stringByAppendingString:self.conditions[i][1]];
            str = [str stringByAppendingString:@"/"];
            str = [str stringByAppendingString:self.conditions[i][2]];
            str = [str stringByAppendingString:@"\n"];
            [self.condDisplay addObject:str];
        }

    }
    else{
    NSString* str = @"";
    [self.tableViewTxt reloadData];
    for(int i=0; i< self.conditions.count;i++){
        [self.condDisplay addObject:self.conditions[i][1]];
        NSLog(@"conditions[i][1] : %@",self.conditions[i][1]);
        str =  [str stringByAppendingString:self.conditions[i][1]];
        str = [str stringByAppendingString:@"\n"];
    }
    }
    [self.tableViewTxt reloadData];
    
    
}

-(IBAction)newvalue:(id)sender{
    
    if([self.option isEqualToString:@"Blood Pressure"]){
        BloodPressureController *npc = [self.storyboard instantiateViewControllerWithIdentifier:@"newbpvalues"];
        npc.itemUsername = self.itemUserName;
        npc.valuefor = self.option;
        //[self.navigationController pushViewController:npc animated:YES];
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
        [self.navigationController pushViewController:npc animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
        

    }
    else{
    NewConditions *npc = [self.storyboard instantiateViewControllerWithIdentifier:@"newvalues"];
    npc.itemUsername = self.itemUserName;
    npc.valuefor = self.option;
    //[self.navigationController pushViewController:npc animated:YES];
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:npc animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
///file path to db
- (IBAction)commentsAction:(id)sender {
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




-(IBAction)logout:(id)sender{
    //AuthView
    AuthViewController *avc = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthView"];
    // [self presentViewController:avc animated:YES completion:nil];
    
    
    [self.navigationController pushViewController:avc animated:YES];
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.condDisplay.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; // reuse identifier
    
    
    // check if we can reuse a cell from row that just went off screen
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // create new cell, if needed
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // set text attibute of cell
    cell.textLabel.text = [self.condDisplay objectAtIndex:indexPath.row];
    
    // set accessory type to standard detail disclosure indicator
    cell.accessoryType = UITableViewCellAccessoryNone;;
    
    return cell;
}

//retrieve conditions of the user from the table

-(void)retrieveCondDetails{
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT * from ConditionsTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString* tdate =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.retConditions =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                NSString* tcomments =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                
                
                if([self.retUsername isEqualToString:self.itemUserName]){
                    NSMutableArray *dateCond = [NSMutableArray arrayWithObjects:tdate,self.retConditions,tcomments, nil];
                    [self.conditions addObject:dateCond];
                }
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
}

-(void)retrieveAllergyDetails{
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT * from AllergyTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString* tdate =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.retConditions =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                NSString* tcomments =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                
                
                if([self.retUsername isEqualToString:self.itemUserName]){
                    NSMutableArray *dateCond = [NSMutableArray arrayWithObjects:tdate,self.retConditions,tcomments, nil];
                    [self.conditions addObject:dateCond];
                }
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }

    
}
-(void)retrieveProcedureDetails{
    
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        //retrieve values from ProceduresTable
        NSString  * query = @"SELECT * from ProceduresTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString* tdate =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.retConditions =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                NSString* tcomments =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                
                
                if([self.retUsername isEqualToString:self.itemUserName]){
                    NSMutableArray *dateCond = [NSMutableArray arrayWithObjects:tdate,self.retConditions,tcomments, nil];
                    [self.conditions addObject:dateCond];
                }
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }

    
}
-(void)retrieveDeviceDetails{
    
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT * from DevicesTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString* tdate =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.retConditions =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                NSString* tcomments =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                
                
                if([self.retUsername isEqualToString:self.itemUserName]){
                    NSMutableArray *dateCond = [NSMutableArray arrayWithObjects:tdate,self.retConditions,tcomments, nil];
                    [self.conditions addObject:dateCond];
                }
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    

}
-(void)retrieveSugarDetails{
    
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT * from SugarListTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString* tdate =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.retConditions =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                
                
                if([self.retUsername isEqualToString:self.itemUserName]){
                    NSMutableArray *dateCond = [NSMutableArray arrayWithObjects:tdate,self.retConditions, nil];
                    [self.conditions addObject:dateCond];
                }
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    

    
}
-(void)retrievePressureDetails{
    
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT * from BPListTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString* tdate =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.retSystolic =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                self.retDiastolic =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                self.retComments =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                
                if([self.retUsername isEqualToString:self.itemUserName]){
                    NSMutableArray *dateCond = [NSMutableArray arrayWithObjects:tdate,self.retSystolic,self.retDiastolic, nil];
                    [self.conditions addObject:dateCond];
                }
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    
}

-(void)retrieveHeight{
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT * from HeightListTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString* tdate =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.retConditions =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                
                if([self.retUsername isEqualToString:self.itemUserName]){
                    NSMutableArray *dateCond = [NSMutableArray arrayWithObjects:tdate,self.retConditions, nil];
                    [self.conditions addObject:dateCond];
                }
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }

}
-(void)retrieveWeight{
    
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT * from WeightListTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString* tdate =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.retConditions =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                // NSString* tcomments =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                
                
                if([self.retUsername isEqualToString:self.itemUserName]){
                    NSMutableArray *dateCond = [NSMutableArray arrayWithObjects:tdate,self.retConditions, nil];
                    [self.conditions addObject:dateCond];
                }
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    

    
}
-(void)retrieveBMI{
    sqlite3_stmt* stmt =NULL;
    int rc=0;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString  * query = @"SELECT * from BMIListTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                
                self.retUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                NSString* tdate =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.retConditions =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                // NSString* tcomments =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                
                
                if([self.retUsername isEqualToString:self.itemUserName]){
                    NSMutableArray *dateCond = [NSMutableArray arrayWithObjects:tdate,self.retConditions, nil];
                    [self.conditions addObject:dateCond];
                }
                
            }
            NSLog(@"Done");
            sqlite3_finalize(stmt);
        }
        else
        {
            NSLog(@"Failed to prepare statement with rc:%d",rc);
        }
        sqlite3_close(db);
    }
    

}



-(IBAction)addentry:(id)sender{
    
}

//Action for segment change
- (IBAction)segmentchange:(id)sender {
    //called when segment changes
    if (self.segment.selectedSegmentIndex==0) {
        [self.condDisplay removeAllObjects];
        
        NSLog(@"At segment 0: ");
        if([self.option isEqualToString:@"Blood Pressure"]){
           
            [self.tableViewTxt reloadData];
            for(int i=0; i< self.conditions.count;i++){
                 NSString* str = @"";
                NSLog(@"conditions[i][1] : %@",self.conditions[i][1]);
                str =  [str stringByAppendingString:self.conditions[i][1]];
                str = [str stringByAppendingString:@" / "];
                str = [str stringByAppendingString:self.conditions[i][2]];
                str = [str stringByAppendingString:@"\n"];
                [self.condDisplay addObject:str];
            }
            
        }
        else{
        NSString* str = @"";
        for(int i=0; i< self.conditions.count;i++){
            [self.condDisplay addObject:self.conditions[i][1]];
            
            str =  [str stringByAppendingString:self.conditions[i][1]];
            str = [str stringByAppendingString:@"\n"];
        }
        
        }
        [self.tableViewTxt reloadData];
        
    }
    else if(self.segment.selectedSegmentIndex==1) {
        
        NSLog(@"At segment 1: ");   //past 1 month
        [self.condDisplay removeAllObjects];
        
        self.curDate = [NSDate date];
        
        NSDateFormatter *monthFormatter=[[NSDateFormatter alloc] init];
        NSDateFormatter *dayFormatter=[[NSDateFormatter alloc] init];
        NSDateFormatter *yearFormatter=[[NSDateFormatter alloc] init];
        
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [monthFormatter setDateFormat:@"MM"];
        
        [dayFormatter setDateFormat:@"dd"];
        [yearFormatter setDateFormat:@"yyyy"];
        
        NSString* str=@"";
        NSDate* date = [NSDate date];
        
        NSDateComponents* comps = [[NSDateComponents alloc]init];
        comps.month = -1;
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        
        NSDate* prev_month = [calendar dateByAddingComponents:comps toDate:date options:0];
        
        for(int i=0; i< self.conditions.count;i++){
            
            NSDate *fdate = [dateFormat dateFromString:self.conditions[i][0]];
            // NSDate *fdate = self.conditions[i][0];
            NSComparisonResult result;
            //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
            
            result = [fdate compare:prev_month]; // comparing two dates
            
            if(result==NSOrderedAscending)
                NSLog(@"falls more than 1 month");
            else if(result==NSOrderedDescending){
               /* [self.condDisplay addObject:self.conditions[i][1]];
                str =  [str stringByAppendingString:self.conditions[i][1]];
                str = [str stringByAppendingString:@"\n"];
                NSLog(@"falls within 1month");*/
                if([self.option isEqualToString:@"Blood Pressure"]){
                    
                    [self.tableViewTxt reloadData];
                    for(int i=0; i< self.conditions.count;i++){
                         NSString* str = @"";
                        NSLog(@"conditions[i][1] : %@",self.conditions[i][1]);
                        str =  [str stringByAppendingString:self.conditions[i][1]];
                        str = [str stringByAppendingString:@" / "];
                        str = [str stringByAppendingString:self.conditions[i][2]];
                        str = [str stringByAppendingString:@"\n"];
                        [self.condDisplay addObject:str];
                    }
                    
                }
                else{
                   
                    for(int i=0; i< self.conditions.count;i++){
                        [self.condDisplay addObject:self.conditions[i][1]];
                        str =  [str stringByAppendingString:self.conditions[i][1]];
                        str = [str stringByAppendingString:@"\n"];
                    }
                    
                }
            }
            
            else{
                if([self.option isEqualToString:@"Blood Pressure"]){
                    
                    [self.tableViewTxt reloadData];
                    for(int i=0; i< self.conditions.count;i++){
                         NSString* str = @"";
                        NSLog(@"conditions[i][1] : %@",self.conditions[i][1]);
                        str =  [str stringByAppendingString:self.conditions[i][1]];
                        str = [str stringByAppendingString:@" / "];
                        str = [str stringByAppendingString:self.conditions[i][2]];
                        str = [str stringByAppendingString:@"\n"];
                        [self.condDisplay addObject:str];
                    }
                    
                }
                else{
                    
                    for(int i=0; i< self.conditions.count;i++){
                        [self.condDisplay addObject:self.conditions[i][1]];
                        str =  [str stringByAppendingString:self.conditions[i][1]];
                        str = [str stringByAppendingString:@"\n"];
                    }
                    
                }

                NSLog(@"same day");
            }
            
        }
        
        [self.tableViewTxt reloadData];
        
    }
    else {
        
        NSLog(@"At segment 2: ");  //past 6 months
        [self.condDisplay removeAllObjects];
        
        self.curDate = [NSDate date];
        
        NSDateFormatter *monthFormatter=[[NSDateFormatter alloc] init];
        NSDateFormatter *dayFormatter=[[NSDateFormatter alloc] init];
        NSDateFormatter *yearFormatter=[[NSDateFormatter alloc] init];
        
        
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        [monthFormatter setDateFormat:@"MM"];
        
        [dayFormatter setDateFormat:@"dd"];
        [yearFormatter setDateFormat:@"yyyy"];
        NSString* str=@"";
        NSDate* date = [NSDate date];
        
        NSDateComponents* comps = [[NSDateComponents alloc]init];
        comps.month = -6;
        
        NSCalendar* calendar = [NSCalendar currentCalendar];
        
        NSDate* six_month_back= [calendar dateByAddingComponents:comps toDate:date options:0];
        
        for(int i=0; i< self.conditions.count;i++){
            
            NSDate *fdate = [dateFormat dateFromString:self.conditions[i][0]];
            // NSDate *fdate = self.conditions[i][0];
            NSComparisonResult result;
            //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
            
            result = [fdate compare:six_month_back]; // comparing two dates
            
            if(result==NSOrderedAscending)
                NSLog(@"falls more than 6 month");
            else if(result==NSOrderedDescending){
                if([self.option isEqualToString:@"Blood Pressure"]){
                    
                    [self.tableViewTxt reloadData];
                    for(int i=0; i< self.conditions.count;i++){
                         NSString* str = @"";
                        NSLog(@"conditions[i][1] : %@",self.conditions[i][1]);
                        str =  [str stringByAppendingString:self.conditions[i][1]];
                        str = [str stringByAppendingString:@" / "];
                        str = [str stringByAppendingString:self.conditions[i][2]];
                        str = [str stringByAppendingString:@"\n"];
                        [self.condDisplay addObject:str];
                    }
                    
                }
                else{
                    
                    for(int i=0; i< self.conditions.count;i++){
                        [self.condDisplay addObject:self.conditions[i][1]];
                        str =  [str stringByAppendingString:self.conditions[i][1]];
                        str = [str stringByAppendingString:@"\n"];
                    }
                    
                }

                NSLog(@"falls within 6month");
            }
            
            else{
                if([self.option isEqualToString:@"Blood Pressure"]){
                    
                    [self.tableViewTxt reloadData];
                    for(int i=0; i< self.conditions.count;i++){
                         NSString* str = @"";
                        NSLog(@"conditions[i][1] : %@",self.conditions[i][1]);
                        str =  [str stringByAppendingString:self.conditions[i][1]];
                        str = [str stringByAppendingString:@" / "];
                        str = [str stringByAppendingString:self.conditions[i][2]];
                        str = [str stringByAppendingString:@"\n"];
                        [self.condDisplay addObject:str];
                    }
                    
                }
                else{
                    
                    for(int i=0; i< self.conditions.count;i++){
                        [self.condDisplay addObject:self.conditions[i][1]];
                        str =  [str stringByAppendingString:self.conditions[i][1]];
                        str = [str stringByAppendingString:@"\n"];
                    }
                    
                }

                NSLog(@"same day");
            }
            
            
        }
        
        [self.tableViewTxt reloadData];
        
    }
    
}


/*- (UIViewController *)backViewController
{
    NSInteger numberOfViewControllers = self.navigationController.viewControllers.count;
    
    if (numberOfViewControllers < 2)
        return nil;
    else
        return [self.navigationController.viewControllers objectAtIndex:numberOfViewControllers - 2];
}*/

@end