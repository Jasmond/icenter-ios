//
//  CouponPopoverViewController.m
//  iCenter
//
//  Created by Jasmond Luk on 3/3/2023.
//  Copyright © 2023 DreamHigh Company Limited. All rights reserved.
//

#import "CouponPopoverViewController.h"
#import "MyClass.h"
#import "MyTableViewCell.h"

@interface CouponPopoverViewController ()

@end

@implementation CouponPopoverViewController
@synthesize CouponRecordObject,CouponTableMode,studentkeys,multiplestudents;

enum {
    CouponTableModeView        = 0,
    CouponTableModeAdd         = 1,
    CouponTableModeEdit        = 2,
};


#define maxPopupHeight self.view.frame.size.height
#define kbPopupHeight 380
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]
#define popoverwidth 320
#define couponwidth 320
#define datewidth 375
#define studenttablewidth 320

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    
    [self InitializeField];
    [self refreshlanguage];
    
    newcouponsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [self createNewCouponTableToolBar];
    [self createDateTableToolBar];
    [self createStudentTableToolBar];
    
    StudentTable.sectionHeaderHeight=0;
    
    
    [self.view layoutIfNeeded];
    
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
    
    [editButton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
     [deleteButton setTitle:[MyClass returntitlewithtitle:@"Delete"] forState:UIControlStateNormal];
      [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) refreshlanguage
{
    title_coupon.text=[[MyClass returntitlewithtitle:@"Coupon"] uppercaseString];
    newcouponsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
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
    keyboardheight = [MyClass keyboardOverlapInView:self.view notification:notification];
    //[self storeTmpField];
    [self adjusttablesize];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    keyboardheight = [MyClass keyboardOverlapInView:self.view notification:notification];
    //[self storeTmpField];
    [self adjusttablesize];
    
}

-(void) createViewBarButton{
//    UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,editButton,nil];
//    [CouponToolBar setItems:buttons animated:NO];
    
    deleteButton.hidden=YES;
    doneButton.hidden=YES;
    editButton.hidden=NO;
    editButton.enabled=[workingCouponRecord.dateused isEqualToString:@""];
    
}

-(void) createEditBarButton{
//    UIBarButtonItem *deleteButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:deleteButton,flexibleSpaceBarButton,doneButton,nil];
//    [CouponToolBar setItems:buttons animated:NO];
    
    deleteButton.hidden=NO;
    doneButton.hidden=NO;
    editButton.hidden=YES;
    
}

-(void) createAddBarButton{
    
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,doneButton,nil];
//    [CouponToolBar setItems:buttons animated:NO];
    
    deleteButton.hidden=YES;
    doneButton.hidden=NO;
    editButton.hidden=YES;
    
}

-(void) createNewCouponTableToolBar
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
//    [newcoupontoolbar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 13, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidetable) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [NewCouponMasterView addSubview:button];
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
    button.frame = CGRectMake(20, 13, 20, 20);
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
    button.frame = CGRectMake(20, 13, 20, 20);
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
    [CouponPopoverTable deselectRowAtIndexPath:[CouponPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) InitializeField
{
    if (!globalvariables) {
        globalvariables=[GlobalVariables singleObj];
    }
    
    //initialize field
    workingCouponRecord=[[CouponRecord alloc]init];
    if (CouponTableMode==CouponTableModeAdd) {
        workingCouponRecord.couponkey=@"";
        workingCouponRecord.issuedate=@"";
        workingCouponRecord.effectivefrom=@"";
        workingCouponRecord.effectiveto=@"";
        workingCouponRecord.dateused=@"";
        workingCouponRecord.marketingkey=@"";
        workingCouponRecord.remarks=@"";
        workingCouponRecord.creditable=NO;
        couponquantity=@"1";
        workingCouponRecord.cannotuseconjunctionwithothercoupons=NO;
        
        [self createAddBarButton];
    }else if (CouponTableMode==CouponTableModeView){
        
        workingCouponRecord.couponkey=CouponRecordObject.couponkey;
        workingCouponRecord.issuedate=CouponRecordObject.issuedate;
        workingCouponRecord.effectivefrom=CouponRecordObject.effectivefrom;
        workingCouponRecord.effectiveto=CouponRecordObject.effectiveto;
        workingCouponRecord.dateused=CouponRecordObject.dateused;
        workingCouponRecord.marketingkey=CouponRecordObject.marketingkey;
        workingCouponRecord.remarks=CouponRecordObject.remarks;
        workingCouponRecord.cannotuseconjunctionwithothercoupons=CouponRecordObject.cannotuseconjunctionwithothercoupons;
        workingCouponRecord.creditable=CouponRecordObject.creditable;
        [self createViewBarButton];
    }else if (CouponTableMode==CouponTableModeEdit){
        workingCouponRecord.couponkey=CouponRecordObject.couponkey;
        workingCouponRecord.issuedate=CouponRecordObject.issuedate;
        workingCouponRecord.effectivefrom=CouponRecordObject.effectivefrom;
        workingCouponRecord.effectiveto=CouponRecordObject.effectiveto;
        workingCouponRecord.dateused=CouponRecordObject.dateused;
        workingCouponRecord.marketingkey=CouponRecordObject.marketingkey;
        workingCouponRecord.remarks=CouponRecordObject.remarks;
        workingCouponRecord.cannotuseconjunctionwithothercoupons=CouponRecordObject.cannotuseconjunctionwithothercoupons;
        workingCouponRecord.creditable=CouponRecordObject.creditable;
        [self createEditBarButton];
    }
}

-(IBAction) editButtonPressed:(id)sender{
    
    CouponTableMode=CouponTableModeEdit;
    [self InitializeField];

    [CouponPopoverTable reloadData];
    
    [self adjusttablesize];
    
}

-(IBAction) cancelButtonPressed:(id)sender{
    
    CouponTableMode=CouponTableModeView;
    [self InitializeField];
    [self showsidewindowwithwindow:@""];
    [CouponPopoverTable reloadData];
    
    [self adjusttablesize];
    
}

-(IBAction) deleteButtonPressed:(id)sender{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Coupon"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the coupon?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self deleteCoupon];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"No"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:OKAction];
    [alert addAction:CancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void) deleteCoupon
{
    NSString *strURL;
    __block BOOL result=FALSE;
    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletecoupon&couponkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,workingCouponRecord.couponkey];
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if (result) {
        [self.delegate dismissCouponPopoverWithReloadStudentList:NO];
        [self.delegate updatecouponrecord];
    }
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}

-(void) updatecoupon
{
    //update to sql
    
    __block BOOL result=FALSE;
    
    NSDictionary *dictionary = @{@"postaction" : @"updatecoupon",
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"action" : CouponTableMode==CouponTableModeAdd?@"Add":@"Edit",
                                 @"studentkeys" : [studentkeys componentsJoinedByString:@","],
                                 @"couponkey" : workingCouponRecord.couponkey,
                                 @"effectivefrom" : workingCouponRecord.effectivefrom,
                                 @"effectiveto" : workingCouponRecord.effectiveto,
                                 @"remarks" : workingCouponRecord.remarks,
                                 @"marketingkey" : workingCouponRecord.marketingkey,
                                 @"updatedby" : globalvariables.username,
                                 @"quantity" : CouponTableMode==CouponTableModeAdd?couponquantity:@"",
                                 @"cannotuseconjunctionwithothercoupons" : workingCouponRecord.cannotuseconjunctionwithothercoupons?@"Yes":@"No",
                                 @"creditable" : workingCouponRecord.creditable?@"Yes":@"No"
    };
    
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if (result) {
        [self.delegate dismissCouponPopoverWithReloadStudentList:multiplestudents];
        [self.delegate updatecouponrecord];
    }else{
        [MyClass showconnectionlostdialogbox];
    }
//    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}

-(IBAction) doneButtonPressed:(id)sender{
    
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        if ([workingCouponRecord.marketingkey isEqualToString:@""]) {
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Coupon"] message:[MyClass returntitlewithtitle:@"Please select coupon"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
        }else{
            [self updatecoupon];
        }
        
//
    });
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==CouponPopoverTable) {
        return 5;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==CouponPopoverTable) {
        if (section==0) {
            return CouponTableMode==CouponTableModeAdd?7:7;
        }else if(section==1){
            if(CouponTableMode!=CouponTableModeAdd){
                return 0;
            }
        }else if (section==2){
            return 4;
        }else if (section==3){
            return 2;
        }
    }else if (tableView==NewCouponTable){
        return filteredNewCouponArray.count;
    }else if (tableView==StudentTable){
        return filteredStudentArray.count;
    }
    return 1;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==CouponPopoverTable) {
        if (section==0){
            return [MyClass returntitlewithtitle:@"General"];
        }else if (section==3){
            return [MyClass returntitlewithtitle:@"Application"];
        }else if (section==4){
            return [MyClass returntitlewithtitle:@"Remarks"];
        }
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSString *headerTitle = [self tableView:tableView titleForHeaderInSection:section];
    
    if (headerTitle) {
        UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        header.backgroundColor=[UIColor systemGroupedBackgroundColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
        label.text=[[MyClass returntitlewithtitle:headerTitle] uppercaseString];;
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor grayColor];
        [header addSubview:label];
        return header;
    }

    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==CouponPopoverTable){
        if(CouponTableMode==CouponTableModeAdd){
            if(indexPath.section==0){
                if(indexPath.row==0){
                    if(!multiplestudents){
                        return CGFLOAT_MIN;
                    }
                }else if(indexPath.row==1){
                    return CGFLOAT_MIN;
                }
            }else if(indexPath.section==2){
                if(indexPath.row==0 || indexPath.row==3){
                    return CGFLOAT_MIN;
                }
            }else if (indexPath.section==3){
                MarketingRecord *mkt=[MyClass returnMarketingRecordWithMarketingKey:workingCouponRecord.marketingkey index:3];
                if(indexPath.row==0){
                    if ([mkt.subcategory isEqualToString:@"Sales"]) {
                        return CGFLOAT_MIN;
                    }
                }else if (indexPath.row==1){
                    if ([mkt.subcategory isEqualToString:@"Class"]) {
                        return CGFLOAT_MIN;
                    }
                }
            }
        }else{
            if(indexPath.section==0){
                if(indexPath.row==0){
                    return CGFLOAT_MIN;
                }
            }else if(indexPath.section==1){
                return CGFLOAT_MIN;
            }
        }
    }
    return UITableViewAutomaticDimension;
}

-(void) adjusttablesize
{
    tablebottomconstraint.constant=0;
    studenttablebottomconstraint.constant=0;
    [MyClass applyKeyboardContentInset:keyboardheight toView:CouponPopoverTable];
    [MyClass applyKeyboardContentInset:keyboardheight toView:StudentMasterView];
    
    float tableheight;
    float tablewidth=320;
    
    tableheight=maxPopupHeight-keyboardheight;
    
    if (showNewCouponTable){
        tablewidth=popoverwidth+couponwidth;
    }else if (showDateTable){
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
    
    if (showNewCouponTable){
        NewCouponMasterView.hidden=NO;
        DateMasterView.hidden=YES;
        StudentMasterView.hidden=YES;
    }else if (showDateTable){
        NewCouponMasterView.hidden=YES;
        DateMasterView.hidden=NO;
        StudentMasterView.hidden=YES;
    }else if (showStudentTable){
        NewCouponMasterView.hidden=YES;
        DateMasterView.hidden=YES;
        StudentMasterView.hidden=NO;
    }else{
        NewCouponMasterView.hidden=YES;
        DateMasterView.hidden=YES;
        StudentMasterView.hidden=YES;
    }
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    if ([windowname isEqualToString:@"showNewCouponTable"]) {
        showNewCouponTable=YES;
        showDateTable=NO;
        showStudentTable=NO;
        [NewCouponTable reloadData];
    }else if ([windowname isEqualToString:@"showDateTable"]) {
        showNewCouponTable=NO;
        showDateTable=YES;
        showStudentTable=NO;
    }else if ([windowname isEqualToString:@"showStudentTable"]) {
        showNewCouponTable=NO;
        showDateTable=NO;
        showStudentTable=YES;
    }else{
        showNewCouponTable=NO;
        showDateTable=NO;
        showStudentTable=NO;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(tableView==NewCouponTable){
        return CGFLOAT_MIN;
    }else if(tableView==StudentTable){
        return CGFLOAT_MIN;
    }else if (tableView==CouponPopoverTable){
        if(CouponTableMode!=CouponTableModeAdd){
            if(section==1){
                return CGFLOAT_MIN;
            }
        }
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
    if (tableView==CouponPopoverTable) {
        if(CouponTableMode==CouponTableModeView){
            MarketingRecord *mkt=[MyClass returnMarketingRecordWithMarketingKey:workingCouponRecord.marketingkey index:3];
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
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Coupon ID"];
                    myCell.label2.text=workingCouponRecord.couponkey;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    if(CouponTableMode==CouponTableModeAdd){
                        myCell.hidden=YES;
                    }
                }else if(indexPath.row==2){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Coupon"];
                    myCell.label2.text=[globalvariables.language isEqualToString:@"English"]? mkt.description:mkt.description_chinese;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==3){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Discount"];
                    if (![mkt.promotionfixeddiscount isEqualToString:@""]) {
                        myCell.label2.text=[NSString stringWithFormat:@"$%@",mkt.promotionfixeddiscount];
                    }else{
                        myCell.label2.text=[NSString stringWithFormat:@"%@%@",mkt.promotionpercentagediscount,@"%"];
                    }
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==4){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Category"];
                    myCell.label2.text=mkt?[MyClass returntitlewithtitle:mkt.subcategory]:@"";
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==5){
                    static NSString *CellIdentifier = @"labelimagecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Cannot be used conjunction with others"];
                    [myCell.imageview1 setImage:[UIImage imageNamed:workingCouponRecord.cannotuseconjunctionwithothercoupons?@"checked_icon2.png":@"absent_icon2.png"]];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==6){
                    static NSString *CellIdentifier = @"labelimagecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Creditable"];
                    [myCell.imageview1 setImage:[UIImage imageNamed:workingCouponRecord.creditable?@"checked_icon2.png":@"absent_icon2.png"]];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==1){
                static NSString *CellIdentifier = @"labeltextcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                myCell.hidden=YES;
                
            }else if (indexPath.section==2){
                if(indexPath.row==0){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Issue Date"];
                    myCell.label2.text=[MyClass convertDateFormatWithDate:workingCouponRecord.issuedate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==1){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Valid From"];
                    myCell.label2.text=[MyClass convertDateFormatWithDate:workingCouponRecord.effectivefrom FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==2){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Valid To"];
                    myCell.label2.text=[workingCouponRecord.effectiveto isEqualToString:@""]?[MyClass returntitlewithtitle:@"Never expire"]:[MyClass convertDateFormatWithDate:workingCouponRecord.effectiveto FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==3){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Date Used"];
                    myCell.label2.text=[MyClass convertDateFormatWithDate:workingCouponRecord.dateused FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==3){
                if(indexPath.row==0){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Subject"];
                    myCell.label2.text=[MyClass returnsubjectnamewithsubjectkeys:mkt.subjectarray];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    myCell.hidden=[mkt.subcategory isEqualToString:@"Sales"];

                }else if(indexPath.row==1){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Product"];
                    myCell.label2.text=[MyClass returnproductnamewithproductkeys:mkt.productarray];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    myCell.hidden=[mkt.subcategory isEqualToString:@"Class"];
                }
            }else{
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"labelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=workingCouponRecord.remarks;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
            }
        }else if (CouponTableMode==CouponTableModeAdd || CouponTableMode==CouponTableModeEdit){
            MarketingRecord *mkt=[MyClass returnMarketingRecordWithMarketingKey:workingCouponRecord.marketingkey index:3];
            if(indexPath.section==0){
                if(indexPath.row==0){
                    if(CouponTableMode==CouponTableModeEdit){
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
                }else if(indexPath.row==2){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Coupon"];
                    myCell.label2.text=mkt?([globalvariables.language isEqualToString:@"English"]? mkt.description:mkt.description_chinese):[MyClass returntitlewithtitle:@"Select"];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if(indexPath.row==3){
                    static NSString *CellIdentifier = @"rolabellabelcell2";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Discount"];
                    if(mkt){
                        if (![mkt.promotionfixeddiscount isEqualToString:@""]) {
                            myCell.label2.text=[NSString stringWithFormat:@"$%@",mkt.promotionfixeddiscount];
                        }else{
                            myCell.label2.text=[NSString stringWithFormat:@"%@%@",mkt.promotionpercentagediscount,@"%"];
                        }
                    }else{
                        myCell.label2.text=@"";
                    }
                    
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==4){
                    static NSString *CellIdentifier = @"rolabellabelcell2";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Category"];
                    myCell.label2.text=mkt?[MyClass returntitlewithtitle:mkt.subcategory]:@"";
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==5){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Cannot be used conjunction with others"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(updatecannotuseconjunctionwithothercoupons:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.on=workingCouponRecord.cannotuseconjunctionwithothercoupons;
                    myCell.switch1.enabled=(mkt?YES:NO) && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editmarketing;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==6){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Creditable"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(updatecreditable:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.on=workingCouponRecord.creditable;
                    myCell.switch1.enabled=(mkt?YES:NO) && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editmarketing;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==1){
                    static NSString *CellIdentifier = @"rolabellabelcell2";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Coupon ID"];
                    myCell.label2.text=workingCouponRecord.couponkey;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    if(CouponTableMode==CouponTableModeAdd){
                        myCell.hidden=YES;
                    }
                }
            }else if (indexPath.section==1){
                
                static NSString *CellIdentifier = @"labeltextcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                myCell.hidden=NO;
                myCell.label1.text=[MyClass returntitlewithtitle:@"Quantity"];
                
                myCell.selectionStyle = UITableViewCellSelectionStyleNone;

                myCell.textfield1.text=couponquantity;
                myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Quantity"];
                [myCell.textfield1 addTarget:self action:@selector(updatequantityfield:) forControlEvents:UIControlEventEditingChanged];
                
                myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==2){
                if(indexPath.row==0){
                    if(CouponTableMode==CouponTableModeAdd){
                        static NSString *CellIdentifier = @"blankcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                    }else{
                        if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editmarketing) {
                            static NSString *CellIdentifier = @"rolabellabelcell2";
                            myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                            if (myCell == nil) {
                                myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                            }
                        }else{
                            static NSString *CellIdentifier = @"labellabelcell";
                            myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                            if (myCell == nil) {
                                myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                            }
                            myCell.accessoryType=UITableViewCellAccessoryNone;
                        }
                    }

                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Issue Date"];
                    myCell.label2.text=[MyClass convertDateFormatWithDate:workingCouponRecord.issuedate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.hidden=CouponTableMode==CouponTableModeAdd;
                }else if(indexPath.row==1){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Valid From"];
                    myCell.label2.text=[MyClass convertDateFormatWithDate:workingCouponRecord.effectivefrom FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.accessoryType=(mkt?YES:NO) && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editmarketing?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
                }else if(indexPath.row==2){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Valid To"];
                    myCell.label2.text=mkt?([workingCouponRecord.effectiveto isEqualToString:@""]?[MyClass returntitlewithtitle:@"Never expire"]:[MyClass convertDateFormatWithDate:workingCouponRecord.effectiveto FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES]):@"";
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.accessoryType=(mkt?YES:NO) && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editmarketing?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
                }else if(indexPath.row==3){
                    if(CouponTableMode==CouponTableModeAdd){
                        static NSString *CellIdentifier = @"blankcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                    }else{
                        static NSString *CellIdentifier = @"rolabellabelcell2";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Date Used"];
                    myCell.label2.text=[MyClass convertDateFormatWithDate:workingCouponRecord.dateused FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.hidden=CouponTableMode==CouponTableModeAdd;
                }
            }else if (indexPath.section==3){
                if(indexPath.row==0){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Subject"];
                    myCell.label2.text=[MyClass returnsubjectnamewithsubjectkeys:mkt.subjectarray];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.hidden=[mkt.subcategory isEqualToString:@"Sales"];
                }else if(indexPath.row==1){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Product"];
                    myCell.label2.text=[MyClass returnproductnamewithproductkeys:mkt.productarray];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.hidden=[mkt.subcategory isEqualToString:@"Class"];
                }
            }else{
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"remarkscell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.textview1.tag=0;
                    myCell.textview1.text=workingCouponRecord.remarks;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }
    }else if (tableView==NewCouponTable){
        CouponRecord *coupon=[filteredNewCouponArray objectAtIndex:indexPath.row];
        MarketingRecord * marketingobject = [MyClass returnMarketingRecordWithMarketingKey:coupon.marketingkey index:3];
        
        static NSString *CellIdentifier = @"couponcell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        myCell.label1.text=[globalvariables.language isEqualToString:@"English"]?marketingobject.description:marketingobject.description_chinese;
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            myCell.label4.text=[NSString stringWithFormat:@"$%@",marketingobject.promotionfixeddiscount];
        }else{
            myCell.label4.text=[NSString stringWithFormat:@"%@%@",marketingobject.promotionpercentagediscount,@"%"];
        }
        
        if([marketingobject.effectivefrom rangeOfString:@"-"].location==NSNotFound){
            marketingobject.effectivefrom=[MyClass convertToNSStringWithNSDate:[MyClass addDaysWithDate:[NSDate date] days:[marketingobject.effectivefrom integerValue]] DateFormat:@"yyyy-MM-dd"];
        }
        
        if([marketingobject.effectiveto rangeOfString:@"-"].location==NSNotFound && ![marketingobject.effectiveto isEqualToString:@""]){
            marketingobject.effectiveto=[MyClass convertToNSStringWithNSDate:[MyClass addDaysWithDate:[MyClass convertToNSDateWithDate:marketingobject.effectivefrom DateFormat:@"yyyy-MM-dd"] days:[marketingobject.effectiveto integerValue]] DateFormat:@"yyyy-MM-dd"];
        }
        
        myCell.label3.text=[marketingobject.effectiveto isEqualToString:@""]?[MyClass returntitlewithtitle:@"Never expire"]:
        [MyClass returnreplacedtitlewithtitle:@"Expires on %@1" replacementarray:@[[MyClass returndateformatwithdate:marketingobject.effectiveto dateformat:@"dd-MMM-yyyy"]]];
        
        myCell.label2.text=[MyClass returnreplacedtitlewithtitle:@"Valid from %@1" replacementarray:@[[MyClass returndateformatwithdate:marketingobject.effectivefrom dateformat:@"dd-MMM-yyyy"]]];
        
        myCell.label6.text=[NSString stringWithFormat:@"%@/%@",marketingobject.usedcount,[marketingobject.promotionquota isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:marketingobject.promotionquota];
        if (![marketingobject.code isEqualToString:@""]) {
            myCell.label6.text=[NSString stringWithFormat:@"%@ (%@)",myCell.label6.text,marketingobject.code];
        }
        
        myCell.label5.text=[MyClass returntitlewithtitle:marketingobject.subcategory];
        
        if(marketingobject.cannotuseconjunctionwithothercoupons){
            myCell.label7.hidden=NO;
            myCell.label7.text=[MyClass returntitlewithtitle:@"Cannot be used conjunction with other coupons"];
        }else{
            myCell.label7.hidden=YES;
        }
        
        myCell.label8.text=[MyClass returnMarketingApplicationDescription:marketingobject];
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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

-(void) updatecannotuseconjunctionwithothercoupons:(UISwitch *)sender
{
    workingCouponRecord.cannotuseconjunctionwithothercoupons=sender.on;
}

-(void) updatecreditable:(UISwitch *)sender
{
    workingCouponRecord.creditable=sender.on;
}

-(void) updatequantityfield:(UITextField *)sender
{
    if ([MyClass checkValidInput:sender.text Type:@"EmptyInteger"]) {
        couponquantity=sender.text;
    }else{
        sender.text=couponquantity;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==CouponPopoverTable) {
        if (CouponTableMode!=CouponTableModeView) {
            if (indexPath.section==0 && indexPath.row==0) {
                [self showsidewindowwithwindow:@"showStudentTable"];
                [self returnFilteredStudentArray];
                [CouponPopoverTable reloadData];
                [self adjusttablesize];
            }else if (indexPath.section==0 && indexPath.row==2) {
                [self showsidewindowwithwindow:@"showNewCouponTable"];
                [self retrieveNewCouponArray];
                [NewCouponTable reloadData];
                [CouponPopoverTable reloadData];
                [self adjusttablesize];
            }else if (indexPath.section==2 && indexPath.row==1 && ![workingCouponRecord.marketingkey isEqualToString:@""] && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editmarketing) {
                datetitle.text=[MyClass returntitlewithtitle:@"Valid From"];
                noneButton.hidden=YES;
                [self showsidewindowwithwindow:@"showDateTable"];
                [datecalendarview scrollToSelectedDateWithSelectedDateArray:[workingCouponRecord.effectivefrom isEqualToString:@""]?[[NSMutableArray alloc]init]:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:workingCouponRecord.effectivefrom FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO], nil] ScrollToDate:[workingCouponRecord.effectivefrom isEqualToString:@""]?[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"]:nil  instructorselected:@"All"];
                [CouponPopoverTable reloadData];
                [self adjusttablesize];
            }else if (indexPath.section==2 && indexPath.row==2 && ![workingCouponRecord.marketingkey isEqualToString:@""] && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editmarketing) {
                datetitle.text=[MyClass returntitlewithtitle:@"Valid To"];
                noneButton.hidden=NO;
                [self showsidewindowwithwindow:@"showDateTable"];
                [datecalendarview scrollToSelectedDateWithSelectedDateArray:[workingCouponRecord.effectiveto isEqualToString:@""]?[[NSMutableArray alloc]init]:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:workingCouponRecord.effectiveto FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO], nil] ScrollToDate:[workingCouponRecord.effectiveto isEqualToString:@""]?[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"]:nil  instructorselected:@"All"];
                [CouponPopoverTable reloadData];
                [self adjusttablesize];
            }
        }
    }else if (tableView==NewCouponTable){
        MarketingRecord *obj=[filteredNewCouponArray objectAtIndex:indexPath.row];
        workingCouponRecord.effectivefrom=obj.effectivefrom;
        workingCouponRecord.effectiveto=obj.effectiveto;
        workingCouponRecord.marketingkey=obj.marketingkey;
        workingCouponRecord.cannotuseconjunctionwithothercoupons=obj.cannotuseconjunctionwithothercoupons;
        [CouponPopoverTable reloadData];
    }else if (tableView==StudentTable){
        Student *obj=[filteredStudentArray objectAtIndex:indexPath.row];
        if([studentkeys containsObject:obj.studentkey]){
            [studentkeys removeObject:obj.studentkey];
        }else{
            [studentkeys addObject:obj.studentkey];
        }
        [StudentTable reloadData];
        [CouponPopoverTable reloadData];
    }
}

-(void) retrieveNewCouponArray
{
    NSMutableArray *marketingarray=[MyClass retrieveMarketingRecordWithStatus:@"Valid" enrollmentdate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] flushcachedata:NO subjectkey:nil productkey:nil];
    newCouponArray=marketingarray[3];
    [self returnFilteredNewCouponArray];
}



-(void) returnFilteredNewCouponArray
{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (![newcouponsearchbar.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithFormat:@"SELF.code contains[c] %@ or SELF.description contains[c] %@ or self.description_chinese contains[c] %@ or self.remarks contains[c] %@ or self.promotionfixeddiscount contains[c] %@ or self.promotionpercentagediscount contains[c] %@",newcouponsearchbar.text,newcouponsearchbar.text,newcouponsearchbar.text,newcouponsearchbar.text,newcouponsearchbar.text,newcouponsearchbar.text];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredNewCouponArray= [[NSMutableArray alloc]initWithArray:[newCouponArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredNewCouponArray= [[NSMutableArray alloc]initWithArray:newCouponArray];
    }
    
    NSSortDescriptor *sortby = [NSSortDescriptor sortDescriptorWithKey:@"effectivefrom" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[sortby];
    filteredNewCouponArray = [NSMutableArray arrayWithArray:[filteredNewCouponArray sortedArrayUsingDescriptors:sortDescriptors]];
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
    
//    NSSortDescriptor *sortby = [NSSortDescriptor sortDescriptorWithKey:@"effectivefrom" ascending:YES selector:@selector(localizedStandardCompare:)];
//    NSArray *sortDescriptors = @[sortby];
//    filteredNewCouponArray = [NSMutableArray arrayWithArray:[filteredNewCouponArray sortedArrayUsingDescriptors:sortDescriptors]];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if(searchBar==newcouponsearchbar){
        [self returnFilteredNewCouponArray];
        [NewCouponTable reloadData];
        [NewCouponTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==studentsearchbar){
        [self returnFilteredStudentArray];
        [StudentTable reloadData];
        [StudentTable setContentOffset:CGPointZero animated:YES];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.tag==0) {
        workingCouponRecord.remarks=textView.text;
        CGPoint rootViewPoint = [textView.superview convertPoint:CGPointZero toView:CouponPopoverTable];
        NSIndexPath *indexPath = [CouponPopoverTable indexPathForRowAtPoint:rootViewPoint];
        
        MyTableViewCell *newcell=[CouponPopoverTable cellForRowAtIndexPath:indexPath];
        
        CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
        if (size.height>100) {
            newcell.layoutconstraint1.constant=100;
            textView.scrollEnabled=YES;
        }else{
            newcell.layoutconstraint1.constant=size.height;
            textView.scrollEnabled=NO;
        }
        

        [CouponPopoverTable beginUpdates];
        [CouponPopoverTable endUpdates];
    }
}

-(void) returnCalendarYear:(NSString *)year
{
    [backButton setTitle:year forState:UIControlStateNormal];
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    if([datetitle.text isEqualToString:[MyClass returntitlewithtitle:@"Valid From"]]){
        NSString *selecteddatestring=[MyClass convertDateFormatWithDate:[selecteddatearray firstObject] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        if([[MyClass convertToNSDateWithDate:selecteddatestring DateFormat:@"yyyy-MM-dd"] compare:[MyClass convertToNSDateWithDate:workingCouponRecord.effectiveto DateFormat:@"yyyy-MM-dd"]]==NSOrderedDescending){
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Coupon"] message:[MyClass returntitlewithtitle:@"Date cannot be later than Valid To"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
        }else{
            if (![workingCouponRecord.effectivefrom isEqualToString:selecteddatestring]) {
                workingCouponRecord.effectivefrom=selecteddatestring;
                
                MarketingRecord *mkt=[MyClass returnMarketingRecordWithMarketingKey:workingCouponRecord.marketingkey index:3];
                if([mkt.effectiveto rangeOfString:@"-"].location==NSNotFound && ![mkt.effectiveto isEqualToString:@""]){
                    workingCouponRecord.effectiveto=[MyClass convertToNSStringWithNSDate:[MyClass addDaysWithDate:[MyClass convertToNSDateWithDate:workingCouponRecord.effectivefrom DateFormat:@"yyyy-MM-dd"] days:[mkt.effectiveto integerValue]] DateFormat:@"yyyy-MM-dd"];
                }
                
                [CouponPopoverTable reloadData];
            }
        }
    }else{
        NSString *selecteddatestring=[MyClass convertDateFormatWithDate:[selecteddatearray firstObject] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        if([[MyClass convertToNSDateWithDate:selecteddatestring DateFormat:@"yyyy-MM-dd"] compare:[MyClass convertToNSDateWithDate:workingCouponRecord.effectivefrom DateFormat:@"yyyy-MM-dd"]]==NSOrderedAscending){
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Coupon"] message:[MyClass returntitlewithtitle:@"Date cannot be earlier than Valid From"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
        }else{
            if (![workingCouponRecord.effectiveto isEqualToString:selecteddatestring]) {
                workingCouponRecord.effectiveto=selecteddatestring;
            }
            [CouponPopoverTable reloadData];
        }
    }
    [self showsidewindowwithwindow:@""];
    [self adjusttablesize];
}




- (IBAction)nonebuttonpressed:(id)sender {
    workingCouponRecord.effectiveto=@"";
    [CouponPopoverTable reloadData];
    [self showsidewindowwithwindow:@""];
    [self adjusttablesize];
}

- (IBAction)backbuttonpressed:(id)sender {
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@""];
    [CouponPopoverTable deselectRowAtIndexPath:[CouponPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}
@end
