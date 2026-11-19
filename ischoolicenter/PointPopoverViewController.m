//
//  PointPopoverViewController.m
//  ischoolicenter
//
//  Created by Jasmond Luk on 13/7/2023.
//  Copyright © 2023 DreamHigh Company Limited. All rights reserved.
//

#import "PointPopoverViewController.h"
#import "MyClass.h"
#import "MyTableViewCell.h"

@interface PointPopoverViewController ()

@end

@implementation PointPopoverViewController
@synthesize PointRecordObject,PointTableMode,studentkeys,multiplestudents;

enum {
    PointTableModeView        = 0,
    PointTableModeAdd         = 1,
    PointTableModeEdit        = 2,
};

#define maxPopupHeight self.view.frame.size.height
#define kbPopupHeight 380
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]
#define popoverwidth 320
#define datewidth 375
#define studenttablewidth 320

- (void)viewDidLoad {
    [super viewDidLoad];
    
    globalvariables=[GlobalVariables singleObj];
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    
    [self InitializeField];
    [self refreshlanguage];
    
    [self createDateTableToolBar];
    [self createStudentTableToolBar];
    
    StudentTable.sectionHeaderHeight=0;
    
    
//    [self.view layoutIfNeeded];
    
    datecalendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 44, DateMasterView.frame.size.width, DateMasterView.frame.size.height+100) Theme:3 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
    datecalendarview.delegate=self;
    [DateMasterView addSubview:datecalendarview];
    
    [noneButton setTitle:[MyClass returntitlewithtitle:@"Never"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    StudentArray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@",globalvariables.centerrecord.centerkey];
    StudentArray=[[NSMutableArray alloc]initWithArray:[StudentArray filteredArrayUsingPredicate:predicate]];
    StudentArray = [NSMutableArray arrayWithArray:[StudentArray sortedArrayUsingDescriptors:[MyClass returnstudentnamesortdescriptorarray]]];
    
//    PointToolBar.clipsToBounds=YES;
    
    [editButton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
    [deleteButton setTitle:[MyClass returntitlewithtitle:@"Delete"] forState:UIControlStateNormal];
    [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) refreshlanguage
{
    title_student.text=[[MyClass returntitlewithtitle:@"Student"] uppercaseString];
    studentsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
}

- (void)keyboardDidHide: (NSNotification *) notification
{
    // Do something here
    keyboardheight=0;
    //[self storeTmpField];
    [self adjusttablesize];
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    //[self storeTmpField];
    [self adjusttablesize];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    //[self storeTmpField];
    [self adjusttablesize];
    
}

-(void) createViewBarButton{
    
//    UIBarButtonItem *editButton=[[UIBarButtonItem alloc]initwith]
//    UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,editButton,nil];
//    [PointToolBar setItems:buttons animated:NO];
    
    editButton.hidden=NO;
    doneButton.hidden=YES;
    deleteButton.hidden=YES;
    
}

-(void) createEditBarButton{
//    UIBarButtonItem *deleteButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:deleteButton,flexibleSpaceBarButton,doneButton,nil];
//    [PointToolBar setItems:buttons animated:NO];
    
    editButton.hidden=YES;
    doneButton.hidden=NO;
    deleteButton.hidden=NO;
    
}

-(void) createAddBarButton{
    
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,doneButton,nil];
//    [PointToolBar setItems:buttons animated:NO];
    
    editButton.hidden=YES;
    doneButton.hidden=NO;
    deleteButton.hidden=YES;
    
}

-(void) createStudentTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidetable) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [studenttoolbar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidetable) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [StudentMasterView addSubview:button];
}

-(void) createDateTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidetable) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [datetoolbar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidetable) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [DateMasterView addSubview:button];
}

-(void) closesidetable
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [PointPopoverTable deselectRowAtIndexPath:[PointPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) InitializeField
{
    if (!globalvariables) {
        globalvariables=[GlobalVariables singleObj];
    }
    
    //initialize field
    workingPointRecord=[[PointRecord alloc]init];
    if (PointTableMode==PointTableModeAdd) {
        workingPointRecord.pointkey=@"";
        workingPointRecord.issuedatetime=@"";
        workingPointRecord.type=@"";
        workingPointRecord.subtype=@"";
        workingPointRecord.point=@"";
        workingPointRecord.expirydate=[globalvariables.centerrecord.defaultpointexpirydays isEqualToString:@""]?@"":[MyClass convertToNSStringWithNSDate:[MyClass addDaysWithDate:[NSDate date] days:[globalvariables.centerrecord.defaultpointexpirydays integerValue]] DateFormat:@"yyyy-MM-dd"];
        workingPointRecord.remarks=@"";
        
        [self createAddBarButton];
    }else if (PointTableMode==PointTableModeView){
        
        workingPointRecord.pointkey=PointRecordObject.pointkey;
        workingPointRecord.issuedatetime=PointRecordObject.issuedatetime;
        workingPointRecord.type=PointRecordObject.type;
        workingPointRecord.subtype=PointRecordObject.subtype;
        workingPointRecord.point=PointRecordObject.point;
        workingPointRecord.expirydate=PointRecordObject.expirydate;
        workingPointRecord.remarks=PointRecordObject.remarks;
        
        [self createViewBarButton];
    }else if (PointTableMode==PointTableModeEdit){
        workingPointRecord.pointkey=PointRecordObject.pointkey;
        workingPointRecord.issuedatetime=PointRecordObject.issuedatetime;
        workingPointRecord.type=PointRecordObject.type;
        workingPointRecord.subtype=PointRecordObject.subtype;
        workingPointRecord.point=PointRecordObject.point;
        workingPointRecord.expirydate=PointRecordObject.expirydate;
        workingPointRecord.remarks=PointRecordObject.remarks;
        
        [self createEditBarButton];
    }
}

-(IBAction) editButtonPressed:(id)sender{
    
    PointTableMode=PointTableModeEdit;
    [self InitializeField];

    [PointPopoverTable reloadData];
    
    [self adjusttablesize];
    
}

-(IBAction) cancelButtonPressed:(id)sender{
    
    PointTableMode=PointTableModeView;
    [self InitializeField];
    [self showsidewindowwithwindow:@""];
    [PointPopoverTable reloadData];
    
    [self adjusttablesize];
    
}

-(IBAction) deleteButtonPressed:(id)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Point"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the point record?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self deletePoint];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"No"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:OKAction];
    [alert addAction:CancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) deletePoint
{
    NSString *strURL;
    __block BOOL result=FALSE;
    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletepoint&pointkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,workingPointRecord.pointkey];
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if (result) {
        [self.delegate dismissPointPopoverWithReloadStudent:YES];
        [self.delegate updatepointrecord];
    }
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}

-(void) updatepoint
{
    //update to sql
    
    __block BOOL result=FALSE;
    
    NSDictionary *dictionary = @{@"postaction" : @"updatemembershippoint",
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"action" : PointTableMode==PointTableModeAdd?@"Add":@"Edit",
                                 @"studentkeys" : PointTableMode==PointTableModeAdd?[studentkeys componentsJoinedByString:@","]:@"",
                                 @"pointkey" : workingPointRecord.pointkey,
                                 @"expirydate" : workingPointRecord.expirydate,
                                 @"remarks" : workingPointRecord.remarks,
                                 @"updatedby" : globalvariables.username,
                                 @"point" : workingPointRecord.point
    };
    
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if (result) {
        [self.delegate dismissPointPopoverWithReloadStudent:YES];
//        if(!multiplestudents){
            [self.delegate updatepointrecord];
//        }
    }else{
        [MyClass showconnectionlostdialogbox];
    }
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}

-(void) doneButtonPressed:(id)sender{
    
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        if ([workingPointRecord.point isEqualToString:@""]) {
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Point"] message:[MyClass returntitlewithtitle:@"Please input point"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
        }else{
            [self updatepoint];
        }
        
//
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==PointPopoverTable) {
        return 3;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==PointPopoverTable) {
        if (section==0) {
            return 2;
        }else if(section==1){
            return 1;
        }else if (section==2){
            return 1;
        }
    }else if (tableView==StudentTable){
        return filteredStudentArray.count;
    }
    return 1;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==PointPopoverTable) {
        if (section==0){
            return [MyClass returntitlewithtitle:@"General"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"Remarks"];
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==PointPopoverTable){
        if(PointTableMode==PointTableModeAdd){
            if(indexPath.section==0){
                if(indexPath.row==0){
                    if(!multiplestudents){
                        return CGFLOAT_MIN;
                    }
                }
            }
        }else{
            if(indexPath.section==0){
                if(indexPath.row==0){
                    return CGFLOAT_MIN;
                }
            }
        }
    }
    return UITableViewAutomaticDimension;
}

-(void) adjusttablesize
{
    tablebottomconstraint.constant=keyboardheight;
    studenttablebottomconstraint.constant=keyboardheight;
    
    float tableheight;
    float tablewidth=320;
    
    tableheight=maxPopupHeight-keyboardheight;
    
    if (showDateTable){
        tablewidth=popoverwidth+datewidth;
    }else if (showStudentTable){
        tablewidth=popoverwidth+studenttablewidth;
    }else{
        tablewidth=popoverwidth;
    }
    
    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    
    self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
    
    if (showDateTable){
        DateMasterView.hidden=NO;
        StudentMasterView.hidden=YES;
    }else if (showStudentTable){
        DateMasterView.hidden=YES;
        StudentMasterView.hidden=NO;
    }else{
        DateMasterView.hidden=YES;
        StudentMasterView.hidden=YES;
    }
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    if ([windowname isEqualToString:@"showDateTable"]) {
        showDateTable=YES;
        showStudentTable=NO;
    }else if ([windowname isEqualToString:@"showStudentTable"]) {
        showDateTable=NO;
        showStudentTable=YES;
    }else{
        showDateTable=NO;
        showStudentTable=NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView==StudentTable){
        return CGFLOAT_MIN;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView numberOfSections]-1==section) {
        return 30;
    }else{
        return CGFLOAT_MIN;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *myCell;
    if (tableView==PointPopoverTable) {
        if(PointTableMode==PointTableModeView){
            if(indexPath.section==0){
                if(indexPath.row==0){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.hidden=YES;
                }else if(indexPath.row==1){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Point"];
                    myCell.label2.text=workingPointRecord.point;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==1){
                if(indexPath.row==0){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Expiry Date"];
                    myCell.label2.text=[workingPointRecord.expirydate isEqualToString:@""]?[MyClass returntitlewithtitle:@"Never expire"]:[MyClass convertDateFormatWithDate:workingPointRecord.expirydate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }else{
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"labelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=workingPointRecord.remarks;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
            }
        }else if (PointTableMode==PointTableModeAdd || PointTableMode==PointTableModeEdit){
            if(indexPath.section==0){
                if(indexPath.row==0){
                    if(PointTableMode==PointTableModeEdit || !multiplestudents){
                        static NSString *CellIdentifier = @"rolabellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.hidden=YES;
                    }else{
                        static NSString *CellIdentifier = @"labellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Student"];
                        
                        OutboxMessageRecord *workingMessage=[[OutboxMessageRecord alloc]init];
                        workingMessage.recipienttype=@"Student";
                        workingMessage.recipientgroup=[[RecipientGroupRecord alloc]init];
                        workingMessage.recipientgroup.individualarray=studentkeys;
                        
                        myCell.label2.text=[MyClass returnconditionnamewitharray:workingMessage condition:@"Individual"];
                        myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                }else if(indexPath.row==1){
                    if(PointTableMode == PointTableModeEdit){
                        static NSString *CellIdentifier = @"rolabellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Point"];
                        
                        myCell.selectionStyle = UITableViewCellSelectionStyleNone;

                        myCell.label2.text=workingPointRecord.point;
                    }else{
                        static NSString *CellIdentifier = @"labeltextcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        
                        myCell.hidden=NO;
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Point"];
                        
                        myCell.selectionStyle = UITableViewCellSelectionStyleNone;

                        myCell.textfield1.text=workingPointRecord.point;
                        myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Point"];
                        [myCell.textfield1 addTarget:self action:@selector(updatepointfield:) forControlEvents:UIControlEventEditingChanged];
                        
                        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                    
                }
            }else if (indexPath.section==1){
                if(indexPath.row==0){

                    if([workingPointRecord.point floatValue]>=0 && ![workingPointRecord.point isEqualToString:@"-"]){
                        static NSString *CellIdentifier = @"labellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }

                        
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Expiry Date"];
                        myCell.label2.text=[workingPointRecord.expirydate isEqualToString:@""]?[MyClass returntitlewithtitle:@"Never expire"]:[MyClass convertDateFormatWithDate:workingPointRecord.expirydate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        static NSString *CellIdentifier = @"rolabeldisablelabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Expiry Date"];
                        myCell.label2.text=[workingPointRecord.expirydate isEqualToString:@""]?[MyClass returntitlewithtitle:@"Never expire"]:[MyClass convertDateFormatWithDate:workingPointRecord.expirydate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
//                    myCell.hidden=PointTableMode==PointTableModeAdd;
                }
            }else{
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"remarkscell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.textview1.tag=0;
                    myCell.textview1.text=workingPointRecord.remarks;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }
    }else if (tableView==StudentTable){
        Student *studentobject=[filteredStudentArray objectAtIndex:indexPath.row];

        static NSString *CellIdentifier = @"studentcell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        myCell.label1.text=[MyClass returnStudentnameWithStudentkey:studentobject.studentkey option:@"full"];
        myCell.label2.text=studentobject.studentid;
        myCell.imageview2.hidden=![studentkeys containsObject:studentobject.studentkey];
        
        [MyClass downloadImageWithImageview:myCell.imageview1 gender:studentobject.gender type:@"student" typekey:studentobject.studentkey image:@"Yes" async:YES];
        
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    return myCell;
}

-(void) updatepointfield:(UITextField *)sender
{
    [self showsidewindowwithwindow:@""];
    if ([MyClass checkValidInput:sender.text Type:@"Integers"]) {
        workingPointRecord.point=sender.text;
        NSRange range = NSMakeRange(1,1);
        NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
        [PointPopoverTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }else{
        sender.text=workingPointRecord.point;
    }
    [self showsidewindowwithwindow:@""];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==PointPopoverTable) {
        if (PointTableMode!=PointTableModeView) {
            if (indexPath.section==0 && indexPath.row==0) {
                [self showsidewindowwithwindow:@"showStudentTable"];
                [self returnFilteredStudentArray];
                [PointPopoverTable reloadData];
                [self adjusttablesize];
            }else if (indexPath.section==1 && indexPath.row==0 && [workingPointRecord.point floatValue]>=0 && ![workingPointRecord.point isEqualToString:@"-"]) {
                datetitle.text=[MyClass returntitlewithtitle:@"Expiry Date"];
                noneButton.hidden=NO;
                [self showsidewindowwithwindow:@"showDateTable"];
                [datecalendarview scrollToSelectedDateWithSelectedDateArray:[workingPointRecord.expirydate isEqualToString:@""]?[[NSMutableArray alloc]init]:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:workingPointRecord.expirydate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO], nil] ScrollToDate:[workingPointRecord.expirydate isEqualToString:@""]?[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"]:nil  instructorselected:@"All"];
                [PointPopoverTable reloadData];
                [self adjusttablesize];
            }
        }
    }else if (tableView==StudentTable){
        Student *obj=[filteredStudentArray objectAtIndex:indexPath.row];
        if([studentkeys containsObject:obj.studentkey]){
            [studentkeys removeObject:obj.studentkey];
        }else{
            [studentkeys addObject:obj.studentkey];
        }
        [StudentTable reloadData];
        [PointPopoverTable reloadData];
    }
}

-(void) returnFilteredStudentArray
{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (![studentsearchbar.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.firstname contains[c] %@ or self.lastname contains[c] %@ or self.othername contains[c] %@ or self.studentid contains[c] %@",studentsearchbar.text,studentsearchbar.text,studentsearchbar.text,studentsearchbar.text];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredStudentArray= [[NSMutableArray alloc]initWithArray:[StudentArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredStudentArray= [[NSMutableArray alloc]initWithArray:StudentArray];
    }
    
    [StudentTable reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==studentsearchbar){
        [self returnFilteredStudentArray];
        [StudentTable reloadData];
        [StudentTable setContentOffset:CGPointZero animated:YES];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self showsidewindowwithwindow:@""];
    if (textView.tag==0) {
        workingPointRecord.remarks=textView.text;
        CGPoint rootViewPoint = [textView.superview convertPoint:CGPointZero toView:PointPopoverTable];
        NSIndexPath *indexPath = [PointPopoverTable indexPathForRowAtPoint:rootViewPoint];
        
        MyTableViewCell *newcell=[PointPopoverTable cellForRowAtIndexPath:indexPath];
        
        CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
        if (size.height>100) {
            newcell.layoutconstraint1.constant=100;
            textView.scrollEnabled=YES;
        }else{
            newcell.layoutconstraint1.constant=size.height;
            textView.scrollEnabled=NO;
        }
        

        [PointPopoverTable beginUpdates];
        [PointPopoverTable endUpdates];
    }
}

-(void) returnCalendarYear:(NSString *)year
{
    [backButton setTitle:year forState:UIControlStateNormal];
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    if([datetitle.text isEqualToString:[MyClass returntitlewithtitle:@"Expiry Date"]]){
        NSString *selecteddatestring=[MyClass convertDateFormatWithDate:[selecteddatearray firstObject] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        if (![workingPointRecord.expirydate isEqualToString:selecteddatestring]) {
            workingPointRecord.expirydate=selecteddatestring;
        }
        [PointPopoverTable reloadData];
    }
    [self showsidewindowwithwindow:@""];
    [self adjusttablesize];
}




- (IBAction)nonebuttonpressed:(id)sender {
    workingPointRecord.expirydate=@"";
    [PointPopoverTable reloadData];
    [self showsidewindowwithwindow:@""];
    [self adjusttablesize];
}

- (IBAction)backbuttonpressed:(id)sender {
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@""];
    [PointPopoverTable deselectRowAtIndexPath:[PointPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}


@end
