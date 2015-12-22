//
//  EditProfileController.m
//  MyiHR
//
//  Created by Dhivya Narayanan on 12/16/15.
//  Copyright (c) 2015 Dhivya Narayanan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EditProfileController.h"
#import "PreviewController.h"

@interface EditProfileController()
@property(nonatomic)UIImage* myImage;
@property(strong, nonatomic)NSString* imageFilePath;
@property(nonatomic)NSString* oldfirstname;
@property(nonatomic)NSString*oldlastname;
@end

@implementation EditProfileController

-(void)viewDidLoad{
    self.backgroundImg.alpha = 0.4;
    self.navigationItem.title = @"Settings";
    self.navigationItem.hidesBackButton = YES;
    [self retrieveOldProfileValues];
    self.firstNameTxt.text = self.itemFirstName;
    self.lastNameTxt.text = self.itemLastName;
    self.dobTxt.text = self.itemDob;
    self.genderTxt.text = self.itemGender;
    self.emailTxt.text = self.itemEmail;
    self.ageTxt.text = self.itemAge;
    self.bloodGroupTxt.text = self.itemBloodGrp;
    
    //NSArray* foo = [@"10/04/2011" componentsSeparatedByString: @"/"];
    //NSString* firstBit = [foo objectAtIndex: 0];
    if(![self.itemContactNo  isEqual: @""]){
        NSArray *phone = [self.itemContactNo componentsSeparatedByString:@")"];
        NSArray *ext=[[phone objectAtIndex:0] componentsSeparatedByString:@"("];
        self.extTxt.text = [ext objectAtIndex:0];
        self.contactTxt.text = [phone objectAtIndex:1];
    }
    if(![self.itemAddress isEqual: @""]){
        NSArray * tmpAdd = [self.itemAddress componentsSeparatedByString:@","];
        self.addressTxt.text = [tmpAdd objectAtIndex:0];
        self.cityTxt.text = [tmpAdd objectAtIndex:1];
        self.stateTxt.text = [tmpAdd objectAtIndex:2];
        self.countryTxt.text = [tmpAdd objectAtIndex:3];
    }
    self.zipcodeTxt.text = self.itemZipCode;
    //Load the  image of profile picture
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:self.imgName];
    if ( [[NSFileManager defaultManager] fileExistsAtPath:path]) {
        UIImage * image1 = [UIImage imageWithContentsOfFile:path];
        [self.profilepic setImage:image1];
    }

    [super viewDidLoad];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandler:)];
    tapGR.numberOfTapsRequired = 1;
    self.profilepic.userInteractionEnabled = YES;
    [self.profilepic addGestureRecognizer:tapGR];
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

-(void) tapHandler: (UITapGestureRecognizer * )sender
{
    NSLog (@"in tapHandler");
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:imagePickerController animated:YES completion:nil];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    //pick a image from gallery and set it to imageview
    [picker dismissModalViewControllerAnimated:YES];
    self.myImage = image;
    
    [self.profilepic setImage:self.myImage];
    
}
//load image from the path
- (UIImage*)loadImage
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"savedmyImage.png"];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)isEmpty{
    
    if(self.firstNameTxt.text && self.firstNameTxt.text.length>0){
        if(self.lastNameTxt.text && self.lastNameTxt.text.length>0){
            return NO;
        }
    }
    return YES;
}

- (IBAction)done:(id)sender {
    
    if(![self isEmpty]){
        
        [self deleteOldValue];
        [self insertnewValue];
        NSLog(@"Table updated..");
        UITabBarController *tabbar = [self.storyboard instantiateViewControllerWithIdentifier:@"tabbarview"];
       [self presentViewController:tabbar animated:YES completion:nil];
        UINavigationController *nav = [tabbar.viewControllers objectAtIndex:0];
        PreviewController *pvc = (PreviewController *)[nav topViewController];
        
         pvc.fName = self.fname;
         pvc.lName = self.lname;
         pvc.dob = self.dob;
         pvc.age = self.age;
         pvc.gender = self.gender;
         pvc.email = self.email;
         //pvc.phone = self.retContactno;
         pvc.bloodgrp= self.bloodgrp;
        // pvc.addr = self.retAddr;
         //pvc.zipcode = self.retZipcode;*/
        pvc.username = self.itemUsername;
        pvc.imgname = self.imgName;
        // pvc.imgname = self.imgName;
        [tabbar setSelectedIndex:0];
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incomplete Fields!"
                                                        message:@"FirstName and LastName field should not be Empty!"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)retrieveOldProfileValues{
    
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
        //retrieve all the values from MyProfileTable - which return the profile details of the user
        NSString  * query = @"SELECT * from MyProfileTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                //Get all the values from SQLite statement and assign to local class variable
                self.itemFirstName =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                self.itemLastName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                self.itemDob =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 3)];
                self.itemAge =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 4)];
                self.itemGender =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 5)];
                self.itemEmail =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 6)];
                self.itemContactNo =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 7)];
                self.itemBloodGrp =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 8)];
                self.itemAddress =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 9)];
                self.itemZipCode =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 10)];
                NSString* tempUsername =[NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 11)];
                if([tempUsername isEqualToString:self.itemUsername]){
                    break;
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
    
    stmt =NULL;
    rc = sqlite3_open_v2([[self filePath] UTF8String], &db, SQLITE_OPEN_READONLY , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        //Retrieve profilepic of the user from the database
        NSString  * query = @"SELECT * from ProfilePicTable";
        
        rc =sqlite3_prepare_v2(db, [query UTF8String], -1, &stmt, NULL);
        if(rc == SQLITE_OK)
        {
            while (sqlite3_step(stmt) == SQLITE_ROW) //get each row in loop
            {
                NSString* user = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 1)];
                self.imgName = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(stmt, 2)];
                if([user isEqualToString:self.itemUsername]){
                    break;
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

-(void)deleteOldValue{
    
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
                             stringWithFormat:@"DELETE FROM MyProfileTable where UserName=\"%@\"",self.itemUsername];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }

    //open the database
    if(self.myImage != nil){
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"DELETE FROM ProfilePicTable where UserName=\"%@\"",self.itemUsername];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to delete record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    }

}
-(void)insertnewValue{
    
    self.fname = self.firstNameTxt.text;
    self.lname = self.lastNameTxt.text;
    self.dob = self.dobTxt.text;
    self.age = self.ageTxt.text;
    self.gender = self.genderTxt.text;
    self.bloodgrp = self.bloodGroupTxt.text;
    self.email = self.emailTxt.text;
    self.ext = self.extTxt.text;
    self.contact = self.contactTxt.text;
    
    NSString* phno = [@"(" stringByAppendingString:self.ext];
    phno = [phno stringByAppendingString:@")"];
    phno = [phno stringByAppendingString:self.contact];
    
    self. addr = self.addressTxt.text;
    self.city =  self.cityTxt.text;
    self.state = self.stateTxt.text;
    self.country = self.countryTxt.text;
    self. zip = self.zipcodeTxt.text;
    
    NSString* fulladdr=@"";
    if(self.addr){
        fulladdr = self.addr;
        if(self.city){
            fulladdr = [self.addr stringByAppendingString:@", "];
            fulladdr = [fulladdr stringByAppendingString:self.city];
            if(self.state){
                fulladdr = [fulladdr stringByAppendingString:@", "];
                fulladdr = [fulladdr stringByAppendingString:self.state];
                if(self.country){
                    fulladdr = [fulladdr stringByAppendingString:@", "];
                    fulladdr = [fulladdr stringByAppendingString:self.country];
                }
            }
        }
    }
    
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
                             stringWithFormat:@"INSERT INTO MyProfileTable (FirstName,LastName,DateOfBirth,Age,Gender,Email,ContactNo,BloodGroup,Address,Zipcode,UserName) VALUES (\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",_fname,_lname,_dob,_age,_gender,_email,phno,_bloodgrp,fulladdr,_zip,_itemUsername];
        char * errMsg;
        rc = sqlite3_exec(db, [query UTF8String] ,NULL,NULL,&errMsg);
        if(SQLITE_OK != rc)
        {
            NSLog(@"Failed to insert record  rc:%d, msg=%s",rc,errMsg);
        }
        sqlite3_close(db);
    }
    
    
    if(self.myImage != nil){
        self. imgName = @"imageOf";
        self.imgName = [self.imgName stringByAppendingString:self.itemUsername];
        self.imgName = [self.imgName stringByAppendingString:@".png"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:self.imgName ];
        NSData* data = UIImagePNGRepresentation(self.myImage);
        [data writeToFile:path atomically:NO];
        NSLog(@"Image saved..");
    rc = sqlite3_open_v2([[self filePath] cStringUsingEncoding:NSUTF8StringEncoding], &db, SQLITE_OPEN_READWRITE , NULL);
    if (SQLITE_OK != rc)
    {
        sqlite3_close(db);
        NSLog(@"Failed to open db connection");
    }
    else
    {
        NSString * query  = [NSString
                             stringWithFormat:@"INSERT INTO ProfilePicTable (UserName,ImagePath) VALUES (\"%@\",\"%@\")",_itemUsername,self.imgName];
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


- (IBAction)clearAction:(id)sender {
    
    self.firstNameTxt.text =@"";
    self.lastNameTxt.text=@"";
    self.dobTxt.text =@"";
    self.genderTxt.text = @"";
    self.emailTxt.text = @"";
    self.ageTxt.text =@"";
    self.bloodGroupTxt.text = @"";
    self.contactTxt.text =@"";
    self.addressTxt.text =@"";
    self.cityTxt.text =@"";
    self.stateTxt.text =@"";
    self.countryTxt.text =@"";
    self.zipcodeTxt.text =@"";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:@"user.gif"];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    [self.profilepic setImage:image];
    
    
}
@end