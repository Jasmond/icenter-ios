//
//  StaffPopoverViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 11/11/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import "StaffPopoverViewController.h"
#import "MyClass.h"
#import "MyTableViewCell.h"
#import "NMRangeSlider.h"

@interface StaffPopoverViewController ()

@end

@implementation StaffPopoverViewController
@synthesize StaffObject,StaffTableMode;
@synthesize RoleArray,PrivilegeArray,GroupArray,readonly;

#define maxPopupHeight self.view.frame.size.height
#define kbPopupHeight 380
#define privilegetablewidth 320
#define competencytablewidth 320
#define grouptablewidth 320
#define staffschedulewidth 375
#define popoverwidth 380
#define datewidth 375
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]


/*
//file path to db
-(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"isdb.sql"];
}

//open the db
-(void) openDB{
    if (sqlite3_open([[self filePath] UTF8String], &isdb)!=SQLITE_OK){
        sqlite3_close(isdb);
        NSAssert(0,@"Database failed to open");
    }else{
        NSLog(@"Database opened");
    }
}*/

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    //self.preferredContentSize=CGSizeMake(320, popupHeight);
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    workingStaff=[[Staff alloc]init];
    //initialize field
    [self InitializeField];
    //[self retrieveRoleGroupPrivilege];
    
    
    
    keyboardshow=FALSE;
    
    //masterView=[[UIScrollView alloc]init];
//    StaffPopoverTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    StaffPopoverTable.dataSource=self;
//    StaffPopoverTable.delegate=self;
    StaffToolBar.clipsToBounds=YES;
    
    [StaffPopoverTable reloadData];
    
    [self adjusttablesize];
    
    
    //[masterView setContentSize:ClassPopoverTable.contentSize];
    [self.view addSubview:StaffPopoverTable];
    
    [self.view layoutIfNeeded];
    [self createtables];
    
    [selectButton setTitle:[MyClass returntitlewithtitle:@"Select"] forState:UIControlStateNormal];
    [cancelButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    [editButton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
    [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    timestep=30;
    
    repeatArray=[[NSArray alloc]initWithObjects:@"Never",@"Every Day",@"Every Week", nil];
    pickerTable.sectionHeaderHeight=0;
    
    datecalendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 44, DateMasterView.frame.size.width, DateMasterView.frame.size.height+100) Theme:3 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
    datecalendarview.delegate=self;
    [DateMasterView addSubview:datecalendarview];
    [self createDateTableToolBar];
    
    [dateBackButton setTitle:[MyClass returntitlewithtitle:@"Back"] forState:UIControlStateNormal];
    
    [main_doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    [main_cancelButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    [main_editButton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
    
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
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [DateMasterView addSubview:button];
}

-(void) closesidetable
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [StaffPopoverTable deselectRowAtIndexPath:[StaffPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void) updateAvailabilityTableRowArray
{
    availabilityRowDataArray=[[NSMutableArray alloc]init];
    
    [availabilityRowDataArray addObject:@"image"];

    if (![StaffTableMode isEqualToString:@"View"] && !calendarview.multipleselection) {
        [availabilityRowDataArray addObject:@"repeat"];
        if (repeatinterval>0) {
            [availabilityRowDataArray addObject:@"endrepeat"];
        }
    }

    for (int i=0; i<workingAvRecords.count; i++) {
        [availabilityRowDataArray addObject:@"record"];
    }
    
    if(![StaffTableMode isEqualToString:@"View"]){
        [availabilityRowDataArray addObject:@"add"];
    }
    

}

- (void)keyboardDidHide: (NSNotification *) notification
{
    // Do something here
    keyboardheight=0;
    [self adjusttablesize];
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    [self adjusttablesize];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    [self adjusttablesize];
}

-(void) createtables
{
    UILabel *label;
    UIView *headerView;
    UILabel *separator;
    
    //privilege table
    PrivilegeTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, privilegetablewidth, self.view.frame.size.height)];
    [self.view addSubview:PrivilegeTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, PrivilegeTableMasterView.frame.size.width,44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [PrivilegeTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Privilege"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    PrivilegeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+44+20, privilegetablewidth, self.view.frame.size.height-44-44-20) style:UITableViewStyleGrouped];
    PrivilegeTable.dataSource=self;
    PrivilegeTable.delegate=self;
    PrivilegeTable.sectionHeaderHeight=0;
    
    //[PrivilegeTableToolBar reloadData];
    [PrivilegeTableMasterView addSubview:PrivilegeTable];
    
    separator=[[UILabel alloc]initWithFrame:CGRectMake(0, 44+44+20, privilegetablewidth, 0.5)];
    separator.layer.opacity=0.6;
    separator.backgroundColor=[UIColor lightGrayColor];
    [PrivilegeTableMasterView addSubview:separator];
    
    PrivilegeTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, privilegetablewidth, 44)];
    PrivilegeTableToolBar.clipsToBounds = YES;
    [PrivilegeTableMasterView addSubview:PrivilegeTableToolBar];
    [self createPrivilegeTableToolBar];
    
    
    //group table
    GroupTable.sectionHeaderHeight=0;
    GroupTableToolBar.clipsToBounds = YES;
    [self createGroupTableToolBar];
    
    //competency table
    CompetencyTable.sectionHeaderHeight=0;
    CompetencyTableToolBar.clipsToBounds = YES;
    [self createCompetencyTableToolBar];

    //color color table
    ColorCodeTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, grouptablewidth, self.view.frame.size.height)];
    [self.view addSubview:ColorCodeTableMasterView];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, ColorCodeTableMasterView.frame.size.width,44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [ColorCodeTableMasterView addSubview:headerView];
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Staff Color"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    ColorCodeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+44+20, grouptablewidth, self.view.frame.size.height-44-44-20) style:UITableViewStyleGrouped];
    ColorCodeTable.dataSource=self;
    ColorCodeTable.delegate=self;
    ColorCodeTable.sectionHeaderHeight=0;
    [ColorCodeTableMasterView addSubview:ColorCodeTable];
    
    ColorCodeTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, grouptablewidth, 44)];
    ColorCodeTableToolBar.clipsToBounds = YES;
    [ColorCodeTableMasterView addSubview:ColorCodeTableToolBar];
    [self createColorCodeTableToolBar];

    
    //add separator
    separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth, 20, 1, self.view.bounds.size.height-20)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
    
    //staff schedule
    availabilityTable.sectionHeaderHeight=0;
    StaffScheduleTitleLabel.text=[[MyClass returntitlewithtitle:@"Staff Schedule"] uppercaseString];
    StaffScheduleTitleLabel.textColor=[UIColor grayColor];
    [self reloadMenuItems:cancelButton];
    
    calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, calendarMasterView.frame.size.width, calendarMasterView.frame.size.height) Theme:4 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:instructoravailabilitydict dataType:@"" disablecalendar:FALSE];
    calendarview.delegate=self;
    [calendarMasterView addSubview:calendarview];

    endrepeatcalendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, endrepeatview.frame.size.width, endrepeatview.frame.size.height) Theme:0 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
    endrepeatcalendarview.delegate=self;
    [endrepeatview addSubview:endrepeatcalendarview];

}


-(void) createViewBarButton{
    if (!readonly) {
        if (StaffObject.staffapp || StaffObject.centerapp) {
            if (![((PrivilegeRecord *)[MyClass returnprivilegerecordwithprivilegekey:((UserPrivilege *)[MyClass returnuserprivilegewithcenterkey:globalvariables.centerrecord.centerkey]).privilegekey]).usertype isEqualToString:@"Super"] && [((PrivilegeRecord *)[MyClass returnprivilegerecordwithprivilegekey:workingStaff.privilege]).usertype isEqualToString:@"Super"]) {
//                [StaffToolBar setItems:nil animated:NO];
                
                main_editButton.hidden=YES;
                main_doneButton.hidden=YES;
                main_cancelButton.hidden=YES;
                
            }else{
//                UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//                UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//                NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,editButton,nil];
//                [StaffToolBar setItems:buttons animated:NO];
                
                main_editButton.hidden=NO;
                main_doneButton.hidden=YES;
                main_cancelButton.hidden=YES;
                
                editButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editstaff;
            }
        }else{
            if (![((PrivilegeRecord *)[MyClass returnprivilegerecordwithprivilegekey:((UserPrivilege *)[MyClass returnuserprivilegewithcenterkey:globalvariables.centerrecord.centerkey]).privilegekey]).usertype isEqualToString:@"Super"] && [((PrivilegeRecord *)[MyClass returnprivilegerecordwithprivilegekey:StaffObject.privilege]).usertype isEqualToString:@"Super"]) {
//                [StaffToolBar setItems:nil animated:NO];
                
                main_editButton.hidden=YES;
                main_doneButton.hidden=YES;
                main_cancelButton.hidden=YES;
                
            }else{
//                UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//                UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//                NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,editButton,nil];
//                [StaffToolBar setItems:buttons animated:NO];
                main_editButton.hidden=NO;
                main_doneButton.hidden=YES;
                main_cancelButton.hidden=YES;
                editButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editstaff;
            }
        }
    }else{
        [StaffToolBar setItems:nil];
    }
}

-(void) createEditBarButton{
//    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:cancelButton,flexibleSpaceBarButton,doneButton,nil];
//    [StaffToolBar setItems:buttons animated:NO];
    
    main_editButton.hidden=YES;
    main_doneButton.hidden=NO;
    main_cancelButton.hidden=NO;
    
}

-(void) createAddBarButton{
    
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,doneButton,nil];
//    [StaffToolBar setItems:buttons animated:NO];
    
    main_editButton.hidden=YES;
    main_doneButton.hidden=NO;
    main_cancelButton.hidden=YES;
    
}

-(void) createPrivilegeTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [PrivilegeTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [PrivilegeTableMasterView addSubview:button];
}

-(void) createGroupTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [GroupTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 13, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [GroupTableMasterView addSubview:button];
}

-(void) createCompetencyTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [CompetencyTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 13, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [CompetenceTableMasterView addSubview:button];
}

-(void) createColorCodeTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [ColorCodeTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [ColorCodeTableMasterView addSubview:button];
}

-(void) closesidewindow
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@""];
    [StaffPopoverTable deselectRowAtIndexPath:[StaffPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(IBAction) editButtonPressed:(id)sender{
    
    
    
    StaffTableMode=@"Edit";
    [self createEditBarButton];
    showDeleteButton=YES;
    
    if(showStaffSchedule){
        [self reloadMenuItems:cancelButton];
        [calendarview reloadWithInstructorAvailability:instructoravailabilitydict ClassRecords:classrecordsdict];
        instructoravailabilityview.hidden=YES;
    }
    
    //[ClassPopoverTable setFrame:CGRectMake(0, 0, 320, editTableHeight)];
    [StaffPopoverTable reloadData];
    
    [self adjusttablesize];
    
    //StaffPopoverTable.contentOffset=CGPointMake(0, StaffPopoverTable.contentSize.height-StaffPopoverTable.frame.size.height);
    //StaffPopoverTable.contentOffset=CGPointMake(0, 0);
}

-(IBAction) cancelButtonPressed:(id)sender{
    
    StaffTableMode=@"View";
    [self showsidewindowwithwindow:@""];
    [StaffPopoverTable reloadData];
    [self createViewBarButton];
    [self InitializeField];
    showDeleteButton=NO;
    
    [StaffPopoverTable reloadData];
    
    [self adjusttablesize];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==StaffPopoverTable) {
        if ([StaffTableMode isEqualToString:@"View"]) {
            return 8;
        }else if ([StaffTableMode isEqualToString:@"Edit"]) {
            return 9;
        }else{
            return 8;
        }
    }else{
        return ([StaffTableMode isEqualToString:@"View"] && ScheduledClassRecordArray.count>0)?2:1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView==StaffPopoverTable) {
        if ([StaffTableMode isEqualToString:@"View"]) {
            if (section==0) {
                return 2;
            }else if (section==1){
                return 1;
            }else if (section==2){
                return 2;
            }else if (section==3){
                return [workingStaff.role isEqualToString:@"Instructor"]?4:3;
            }else if (section==4){//apps
                return 3;
            }else if (section==5){//instructor options
                return ![self showStaffSchedule]?0:4;
            }else if (section==6){//resignation
                return 1;
            }else{
                return 1;
            }
        }else if ([StaffTableMode isEqualToString:@"Edit"]) {
            if (section==0) {
                return 2;
            }else if (section==1){
                return 1;
            }else if (section==2){
                return 2;
            }else if (section==3){
                return [workingStaff.role isEqualToString:@"Instructor"]?4:3;
            }else if (section==4){//apps
                return 3;
            }else if (section==5){//instructor options
                return ![self showStaffSchedule]?0:4;
            }else if (section==6){//resignation
                return 1;
            }else if (section==7){//remarks
                return 1;
            }else{
                return 1;
            }
        }else{
            if (section==0) {
                return 2;
            }else if (section==1){
                return 1;
            }else if (section==2){
                return 2;
            }else if (section==3){
                return [workingStaff.role isEqualToString:@"Instructor"]?4:3;
            }else if (section==4){
                return 3;
            }else if (section==5){
                return ![self showStaffSchedule]?0:4;
            }else if (section==6){
                return 1;
            }else{
                return 0;
            }
        }
    }else if (tableView==GroupTable){
        return GroupArray.count;
    }else if (tableView==CompetencyTable){
        if ([globalvariables.centerrecord.staffcompetencyvalues isEqualToString:@""]) {
            return 0;
        }else{
            return [[globalvariables.centerrecord.staffcompetencyvalues componentsSeparatedByString:@"/"] count];
        }
        return GroupArray.count;
    }else if (tableView==ColorCodeTable){
        return globalvariables.colorcodearray.count;
    }else if (tableView==PrivilegeTable){
        return PrivilegeArray.count;
    }else if (tableView==availabilityTable){
        if (section==0) {
            return availabilityRowDataArray.count;
        }else{
            return ScheduledClassRecordArray.count;
        }
    }else if (tableView==pickerTable){
        return repeatArray.count;
    }
    return 0;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==StaffPopoverTable) {
        if ([StaffTableMode isEqualToString:@"View"]) {
            if (section==0) {
                return [MyClass returntitlewithtitle:@"Name"];
            }else if (section==1){
                return [MyClass returntitlewithtitle:@"Status"];
            }else if (section==2){
                return [MyClass returntitlewithtitle:@"Contact"];
            }else if (section==3){
                return [MyClass returntitlewithtitle:@"User Type"];
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Apps"];
            }else if (section==5){
                if ([workingStaff.role isEqualToString:@"Instructor"]) {
                    return [MyClass returntitlewithtitle:@"Instructor Options"];
                }
            }else if (section==6){
                return [MyClass returntitlewithtitle:@"Resignation"];
            }else{
                return [MyClass returntitlewithtitle:@"Remarks"];
            }
        }else{
            if (section==0) {
                return [MyClass returntitlewithtitle:@"Name"];
            }else if (section==1){
                return [MyClass returntitlewithtitle:@"Status"];
            }else if (section==2){
                return [MyClass returntitlewithtitle:@"Contact"];
            }else if (section==3){
                return [MyClass returntitlewithtitle:@"User Type"];
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Apps"];
            }else if (section==5){
                if ([workingStaff.role isEqualToString:@"Instructor"]) {
                    return [MyClass returntitlewithtitle:@"Instructor"];
                }
            }else if (section==6){
                return [MyClass returntitlewithtitle:@"Resignation"];
            }else if (section==7){
                return [MyClass returntitlewithtitle:@"Remarks"];
            }
        }
    }else if (tableView==GroupTable){
//        if (section==1){
            return [MyClass returntitlewithtitle:@"Group"];
//        }
    }else if (tableView==CompetencyTable){
        //        if (section==1){
                    return [MyClass returntitlewithtitle:@"Competency"];
        //        }
            }else if (tableView==availabilityTable){
        if (section==1){
            return [MyClass returntitlewithtitle:@"Scheduled Class"];
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
    
    if (tableView==StaffPopoverTable) {
        if ([StaffTableMode isEqualToString:@"View"]) {
            if (indexPath.section==5) {
                if (indexPath.row==1){
                    return [self showConfirmMakeupRequest]?UITableViewAutomaticDimension:CGFLOAT_MIN;
                }else if (indexPath.row==2){
                    return [self showSalaryRate]?UITableViewAutomaticDimension:CGFLOAT_MIN;
                }else if (indexPath.row==3){
                    return [self showCompetence]?UITableViewAutomaticDimension:CGFLOAT_MIN;
                }
            }/*else if (indexPath.section==6){
                return 150;
            }*/
            return UITableViewAutomaticDimension;
        }else{// if ([EnrollmentTableMode isEqualToString:@"Edit"]){
            if (indexPath.section==5){
                if (indexPath.row==1){
                    return [self showConfirmMakeupRequest]?UITableViewAutomaticDimension:CGFLOAT_MIN;
                }else if (indexPath.row==2){
                    return [self showSalaryRate]?UITableViewAutomaticDimension:CGFLOAT_MIN;
                }
            }
            return UITableViewAutomaticDimension;
            
        }
    }else if (tableView==availabilityTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==pickerTable){
        return 35;
    }else if (tableView==GroupTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==CompetencyTable){
        return UITableViewAutomaticDimension;
    }else{
        return 35;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (tableView==StaffPopoverTable) {
        MyTableViewCell *myCell;
        if ([StaffTableMode isEqualToString:@"View"]) {
            //if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
            
            if (indexPath.section==0 ) {
                if (indexPath.row==1) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"First name"];
                    myCell.label2.text=workingStaff.firstname;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;
                    
                }else if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Last name"];
                    myCell.label2.text=workingStaff.lastname;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;
                }
                
            }else if (indexPath.section==1){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Status"];
                    myCell.label2.text=[workingStaff.status isEqualToString:@"Yes"]?[MyClass returntitlewithtitle:@"Active"]:[MyClass returntitlewithtitle:@"Inactive"];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;
                    
                }
            }else if (indexPath.section==2){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Email"];
                    myCell.label2.text=workingStaff.username;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;

                    
                }else if (indexPath.row==1) {
                    static NSString *CellIdentifier = @"viewphonecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Phone"];
                    
                    
//                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
//                    GeneralLabel.font=[UIFont systemFontOfSize:17];
//                    GeneralLabel.textColor=[UIColor blackColor];
//                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Phone"];
//                    GeneralLabel.tag=301;
//                    [cell.contentView addSubview:GeneralLabel];
//
//                    PhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 7, popoverwidth-90-35, 21)];
//                    PhoneLabel.font=[UIFont systemFontOfSize:15];
//                    PhoneLabel.textColor=[UIColor darkGrayColor];
//                    PhoneLabel.textAlignment=NSTextAlignmentRight;
                    
                    if (![[MyClass returnLocalNumberWithContact:workingStaff.phone ISOCode:workingStaff.iso_code] isEqualToString:@""]) {
                        myCell.label3.text=[MyClass returnLocalNumberWithContact:workingStaff.phone ISOCode:workingStaff.iso_code];
//                        [PhoneLabel sizeToFit];
//                        PhoneLabel.frame=CGRectMake(popoverwidth-35-PhoneLabel.frame.size.width, 5, PhoneLabel.frame.size.width, 21);
//                        [cell.contentView addSubview:PhoneLabel];
                        
                        
//                        UILabel *countrycode=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
//                        countrycode.font=[UIFont systemFontOfSize:15];
//                        countrycode.textColor=[UIColor darkGrayColor];
                        myCell.label2.text=[NSString stringWithFormat:@"+%@",[MyClass returnCountryCodeWithISOCode:workingStaff.iso_code]];
//                        [countrycode sizeToFit];
//                        countrycode.frame=CGRectMake(PhoneLabel.frame.origin.x-countrycode.frame.size.width-2, 5, countrycode.frame.size.width, 21);
//                        [cell.contentView addSubview:countrycode];
                        
//                        UIImageView *ccimage=[[UIImageView alloc]initWithFrame:CGRectMake(countrycode.frame.origin.x-2-27, (32-18)/2, 27, 18)];
                        [MyClass downloadImageWithImageview:myCell.imageview1 gender:nil type:@"flag" typekey:workingStaff.iso_code image:@"Yes" async:YES];
//                        ccimage.contentMode=UIViewContentModeScaleAspectFill;
//                        ccimage.layer.cornerRadius=3;
//                        ccimage.layer.masksToBounds=YES;
//                        [cell.contentView addSubview:ccimage];
                    }
                    

                    
                    
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;
                }
            }else if (indexPath.section==3){
                
                if (indexPath.row==0) {

                    static NSString *CellIdentifier = @"labelimagecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Teaching"];
                    [myCell.imageview1 setImage:[UIImage imageNamed:[workingStaff.role isEqualToString:@"Instructor"]?@"checked_icon2.png":@"absent_icon2.png"]];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;
                    
                }else if (indexPath.row==2) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Group"];
                    myCell.label2.attributedText=[MyClass returngrouparraylabel:workingStaff.grouparray grouparray:GroupArray option:@"groupmember"];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;

                }else if (indexPath.row==1) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Privilege"];
                    myCell.label2.text=((PrivilegeRecord *)[MyClass returnprivilegerecordwithprivilegekey:workingStaff.privilege]).usertype;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;
                    
                }else if (indexPath.row==3){
                    static NSString *CellIdentifier = @"colorcodecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Staff Color"];
                    myCell.label2.backgroundColor=[globalvariables.colorcodearray objectAtIndex:workingStaff.colorcode];
//                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 121, 21)];
//                    GeneralLabel.font=[UIFont systemFontOfSize:17];
//                    GeneralLabel.textColor=[UIColor blackColor];
//                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Staff Color"];
//                    GeneralLabel.tag=301;
//                    [cell.contentView addSubview:GeneralLabel];
//
//                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-24-33, 11, 24, 16)];
//                    GeneralLabel.font=[UIFont systemFontOfSize:15];
//                    GeneralLabel.layer.masksToBounds=YES;
//                    GeneralLabel.layer.cornerRadius=4;
//                    GeneralLabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:workingStaff.colorcode];
//                    [cell.contentView addSubview:GeneralLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;
                }
            }else if (indexPath.section==4){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"labelimagecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"iStaff"];
                    [myCell.imageview1 setImage:[UIImage imageNamed:workingStaff.staffapp?@"checked_icon2.png":@"absent_icon2.png"]];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;
//                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
//                    GeneralLabel.font=[UIFont systemFontOfSize:17];
//                    GeneralLabel.textColor=[UIColor blackColor];
//                    GeneralLabel.text=@"iStaff";
//                    GeneralLabel.tag=301;
//                    [cell.contentView addSubview:GeneralLabel];
//
//                    iStaffappLabel = [[UIImageView alloc]initWithFrame:CGRectMake(popoverwidth-25-30, 5, 25, 25)];
//                    [iStaffappLabel setImage:[UIImage imageNamed:workingStaff.staffapp?@"passed_icon.png":@"failed_icon.png"]];
//                    iStaffappLabel.tag=302;
//                    [cell.contentView addSubview:iStaffappLabel];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==1) {
                    static NSString *CellIdentifier = @"labelimagecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"iCenter"];
                    [myCell.imageview1 setImage:[UIImage imageNamed:workingStaff.centerapp?@"checked_icon2.png":@"absent_icon2.png"]];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;
                    
//                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
//                    GeneralLabel.font=[UIFont systemFontOfSize:17];
//                    GeneralLabel.textColor=[UIColor blackColor];
//                    GeneralLabel.text=@"iCenter";
//                    GeneralLabel.tag=301;
//                    [cell.contentView addSubview:GeneralLabel];
//
//                    iCenterappLabel = [[UIImageView alloc]initWithFrame:CGRectMake(popoverwidth-25-30, 5, 25, 25)];
//                    [iCenterappLabel setImage:[UIImage imageNamed:workingStaff.centerapp?@"passed_icon.png":@"failed_icon.png"]];
//                    iCenterappLabel.tag=302;
//                    [cell.contentView addSubview:iCenterappLabel];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==2) {
                    static NSString *CellIdentifier = @"labelimagecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"BI Report"];
                    [myCell.imageview1 setImage:[UIImage imageNamed:workingStaff.biapp?@"checked_icon2.png":@"absent_icon2.png"]];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;
//                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
//                    GeneralLabel.font=[UIFont systemFontOfSize:17];
//                    GeneralLabel.textColor=[UIColor blackColor];
//                    GeneralLabel.text=[MyClass returntitlewithtitle:@"BI Report"];
//                    GeneralLabel.tag=301;
//                    [cell.contentView addSubview:GeneralLabel];
//
//                    BIappLabel = [[UIImageView alloc]initWithFrame:CGRectMake(popoverwidth-25-30, 5, 25, 25)];
//                    [BIappLabel setImage:[UIImage imageNamed:workingStaff.biapp?@"passed_icon.png":@"failed_icon.png"]];
//                    BIappLabel.tag=302;
//                    [cell.contentView addSubview:BIappLabel];
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
            }else if (indexPath.section==5){
                
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"labelimagecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    if ([self showStaffSchedule]) {

                        
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Staff Schedule"];
                        [myCell.imageview1 setImage:[UIImage imageNamed:workingStaff.staffschedule?@"checked_icon2.png":@"absent_icon2.png"]];

                        
                        
//                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
//                        GeneralLabel.font=[UIFont systemFontOfSize:17];
//                        GeneralLabel.textColor=[UIColor blackColor];
//                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Staff Schedule"];
//                        GeneralLabel.tag=301;
//                        [cell.contentView addSubview:GeneralLabel];
//
//                        MonLabel = [[UIImageView alloc]init];
//                        [MonLabel setImage:[UIImage imageNamed:workingStaff.staffschedule?@"passed_icon.png":@"failed_icon.png"]];
//                        MonLabel.tag=302;
//                        [cell.contentView addSubview:MonLabel];

                        if (workingStaff.staffschedule) {
//                            MonLabel.frame = CGRectMake(popoverwidth-25-30, 5, 25, 25);
                            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        }else{
//                            MonLabel.frame = CGRectMake(popoverwidth-25-30, 5, 25, 25);
                            myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        
                    }else{
                        myCell.hidden=YES;
                    }
                    return myCell;
                    
                }else if (indexPath.row==1) {
                    static NSString *CellIdentifier = @"labelimagecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    if ([self showConfirmMakeupRequest]) {
                        

                        
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Confirm Makeup Request"];
                        [myCell.imageview1 setImage:[UIImage imageNamed:workingStaff.confirmmakeuprequest?@"checked_icon2.png":@"absent_icon2.png"]];
                        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return myCell;
//                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
//                        GeneralLabel.font=[UIFont systemFontOfSize:17];
//                        GeneralLabel.textColor=[UIColor blackColor];
//                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Confirm Makeup Request"];
//                        GeneralLabel.tag=301;
//                        [cell.contentView addSubview:GeneralLabel];
//
//                        MonLabel = [[UIImageView alloc]init];
//                        [MonLabel setImage:[UIImage imageNamed:workingStaff.confirmmakeuprequest?@"passed_icon.png":@"failed_icon.png"]];
//                        MonLabel.tag=302;
//                        [cell.contentView addSubview:MonLabel];
                        

//                            MonLabel.frame = CGRectMake(popoverwidth-25-30, 5, 25, 25);
                            
                        
                        
                        
                    }else{
                        myCell.hidden=YES;
                    }
                    return myCell;
                }else if (indexPath.row==2) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    if ([self showSalaryRate]) {

                        
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Salary Rate"];
                        myCell.label2.text=((PrivilegeRecord *)[MyClass returnprivilegerecordwithprivilegekey:workingStaff.privilege]).usertype;
                        if ([workingStaff.salaryrate isEqualToString:@""]) {
                            myCell.label2.text=[NSString stringWithFormat:@"%@%@",@"0",@"%"];
                        }else{
                            myCell.label2.text=[NSString stringWithFormat:@"%@%@",workingStaff.salaryrate,@"%"];
                        }
                        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                    }else{
                        myCell.hidden=YES;
                    }
                    return myCell;
                }else if (indexPath.row==3) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    if ([self showCompetence]) {

                        
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Competence"];
                        myCell.label2.text=((PrivilegeRecord *)[MyClass returnprivilegerecordwithprivilegekey:workingStaff.privilege]).usertype;
                        if (workingStaff.competencyarray.count==0) {
                            myCell.label2.text=[MyClass returntitlewithtitle:@"None"];
                        }else{
                            myCell.label2.text=[workingStaff.competencyarray componentsJoinedByString:@" / "];
                        }
                        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                    }else{
                        myCell.hidden=YES;
                    }
                    return myCell;
                }
            }else if (indexPath.section==6){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Effective Date"];
                    myCell.label2.text=[workingStaff.effectiveresignationdate isEqualToString:@""]?[MyClass returntitlewithtitle:@"None"]:[MyClass convertDateFormatWithDate:workingStaff.effectiveresignationdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;
                    
                }
            }else if (indexPath.section==7){
                static NSString *CellIdentifier = @"viewremarkscell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                myCell.textview1.text=workingStaff.remarks;
                myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return myCell;
            }
            
        }else if([StaffTableMode isEqualToString:@"Edit"] || [StaffTableMode isEqualToString:@"Add"]){
            
            //if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
            if (indexPath.section==0 ) {
                if (indexPath.row==1) {
                    
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"First name"];
                    myCell.textfield1.text=workingStaff.firstname;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"First name (required)"];
                    [myCell.textfield1 addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.tag=1;
                    return myCell;
                    
                }else if (indexPath.row==0){
                    
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Last name"];
                    myCell.textfield1.text=workingStaff.lastname;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Last name"];
                    [myCell.textfield1 addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.tag=0;
                    return myCell;
                }
            }else if (indexPath.section==1){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"segmentcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Status"];
                    [myCell.segmentedcontrol1 removeAllSegments];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Active"] atIndex:0 animated:NO];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Inactive"] atIndex:1 animated:NO];
                    
                    myCell.segmentedcontrol1.selectedSegmentIndex=[workingStaff.status isEqualToString:@"Yes"] ? 0:1;
                    [myCell.segmentedcontrol1 addTarget:self action:@selector(selectStatus:) forControlEvents: UIControlEventValueChanged];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return myCell;
                }
            }else if (indexPath.section==2){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Email"];
                    myCell.textfield1.text=workingStaff.username;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Email (Username)"];
                    [myCell.textfield1 addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.tag=2;
                    return myCell;
                }else if (indexPath.row==1){
                    static NSString *CellIdentifier = @"editphonecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Phone"];
                    myCell.textfield1.keyboardType = UIKeyboardTypeNumberPad;
                    
                    myCell.textfield1.text=[MyClass returnLocalNumberWithContact:workingStaff.phone ISOCode:workingStaff.iso_code];
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Phone"];
                    [myCell.textfield1 addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.tag=3;
                    [MyClass downloadImageWithImageview:myCell.imageview1 gender:nil type:@"flag" typekey:workingStaff.iso_code image:@"Yes" async:YES];
                    [myCell.button1 addTarget:self action:@selector(ccbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                    myCell.label2.text=[NSString stringWithFormat:@"+%@",[MyClass returnCountryCodeWithISOCode:workingStaff.iso_code]];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return myCell;
                }
            }else if (indexPath.section==3){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Teaching"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(activateteaching:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.on=[workingStaff.role isEqualToString:@"Instructor"];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return myCell;

                    
                }else if (indexPath.row==2) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Group"];
                    myCell.label2.attributedText=[MyClass returngrouparraylabel:workingStaff.grouparray grouparray:GroupArray option:@"groupmember"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    return myCell;
                    
                }else if (indexPath.row==1) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Privilege"];
                    myCell.label2.text=((PrivilegeRecord *)[MyClass returnprivilegerecordwithprivilegekey:workingStaff.privilege]).usertype;
                    
                    if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editstaffprivilege || [StaffTableMode isEqualToString:@"Add"]) {
                        myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }
                    
                    return myCell;
                }else if (indexPath.row==3){
                    static NSString *CellIdentifier = @"colorcodecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Staff Color"];
                    myCell.label2.backgroundColor=[globalvariables.colorcodearray objectAtIndex:workingStaff.colorcode];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    return myCell;
                }
            }else if (indexPath.section==4){
                if (indexPath.row==0){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"iStaff"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(activatestaffapp:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.enabled=[workingStaff.status isEqualToString:@"Yes"];
                    myCell.switch1.on=workingStaff.staffapp;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return myCell;
                }else if (indexPath.row==1){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"iCenter"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(activatecenterapp:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.enabled=[workingStaff.status isEqualToString:@"Yes"];
                    myCell.switch1.on=workingStaff.centerapp;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return myCell;
                }else if (indexPath.row==2){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"BI Report"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(activatebiapp:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.enabled=[workingStaff.status isEqualToString:@"Yes"] && (workingStaff.centerapp||workingStaff.staffapp);
                    myCell.switch1.on=workingStaff.biapp;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    return myCell;
                }
                
            }else if (indexPath.section==5){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    

                    if ([self showStaffSchedule]) {
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Staff Schedule"];
                        [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                        [myCell.switch1 addTarget:self action:@selector(enableStaffSchedule:) forControlEvents:UIControlEventValueChanged];
                        myCell.switch1.on=workingStaff.staffschedule;
                        if (workingStaff.staffschedule) {
                            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        }else{
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                        
                        
                    }else{
                        myCell.hidden=YES;
                    }
                    return myCell;
                
                }else if (indexPath.row==1) {
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    if ([self showConfirmMakeupRequest]) {
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Confirm Makeup Request"];
                        [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                        [myCell.switch1 addTarget:self action:@selector(enableConfirmMakeupRequest:) forControlEvents:UIControlEventValueChanged];
                        myCell.switch1.on=workingStaff.confirmmakeuprequest;
                        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                    }else{
                        myCell.hidden=YES;
                    }
                    return myCell;
                }else if (indexPath.row==2){
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    if ([self showSalaryRate]) {
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Salary Rate"];
                        myCell.textfield1.text=workingStaff.salaryrate;
                        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Percentage"];
                        [myCell.textfield1 addTarget:self action:@selector(validateinput:) forControlEvents:UIControlEventEditingChanged];
                        myCell.textfield1.keyboardType = UIKeyboardTypeDecimalPad;
                        myCell.textfield1.tag=4;
                    }else{
                        myCell.hidden=YES;
                    }
                    return myCell;
                }else if (indexPath.row==3){
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    if ([self showCompetence]) {
                        static NSString *CellIdentifier = @"rolabellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Competency"];
                        if (workingStaff.competencyarray.count==0) {
                            myCell.label2.text=[MyClass returntitlewithtitle:@"None"];
                        }else{
                            myCell.label2.text=[workingStaff.competencyarray componentsJoinedByString:@" / "];
                        }
                        myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        myCell.hidden=YES;
                    }
                    return myCell;
                }
            }else if (indexPath.section==6){
                if(indexPath.row==0){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Effective Date"];
                    myCell.label2.text=[workingStaff.effectiveresignationdate isEqualToString:@""]?[MyClass returntitlewithtitle:@"None"]:[MyClass convertDateFormatWithDate:workingStaff.effectiveresignationdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    return myCell;
                }
            }else if (indexPath.section==7){
                static NSString *CellIdentifier = @"remarkscell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                myCell.textview1.tag=0;
                myCell.textview1.text=workingStaff.remarks;
                myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                return myCell;
            }else if (indexPath.section==8){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"buttoncell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    if (showDeleteButton) {
                        [myCell.button1 setTitle:[MyClass returntitlewithtitle:@"Delete Staff"] forState:UIControlStateNormal];
                        [myCell.button1 addTarget: self action:@selector(deleteStaff:) forControlEvents: UIControlEventTouchUpInside];

                    }else{
                        myCell.hidden=YES;
                    }
                    return myCell;
                }
            }
        }
    }else if (tableView==PrivilegeTable){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        UILabel *titlelabel;
        UIImageView *titleselected;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, privilegetablewidth-30, 35)];
            titlelabel.font=[UIFont systemFontOfSize:15];
            titlelabel.textColor=[UIColor darkGrayColor];
            titlelabel.tag=1301;
            [cell.contentView addSubview:titlelabel];
            
            titleselected = [[UIImageView alloc]initWithFrame:CGRectMake(privilegetablewidth-45, 7, 24, 24)];
            [titleselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            titleselected.tag=1302;
            [cell.contentView addSubview:titleselected];
        }else{
            titlelabel=(UILabel *)[cell.contentView viewWithTag:1301];
            titleselected=(UIImageView *)[cell.contentView viewWithTag:1302];
        }
        
        titlelabel.text=((PrivilegeRecord *)[PrivilegeArray objectAtIndex:indexPath.row]).usertype;
        titleselected.hidden=[workingStaff.privilege isEqualToString:((PrivilegeRecord *)[PrivilegeArray objectAtIndex:indexPath.row]).privilegekey]?NO:YES;
    }else if (tableView==GroupTable){
        static NSString *CellIdentifier = @"groupcell";
        MyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.label1.text=((GroupRecord *)[GroupArray objectAtIndex:indexPath.row]).groupname;
        GroupMemberRecord *member=[self returnMemberWithMemberArray:workingStaff.grouparray GroupRecord:[GroupArray objectAtIndex:indexPath.row]];
        [cell.button1 setTitle:[MyClass returntitlewithtitle:@"Group Leader"] forState:UIControlStateNormal];
        if(member){
            cell.imageview1.hidden=NO;
            cell.button1.enabled=YES;
            cell.imageview2.layer.opacity=member.leader?1.0:0.3;
            [cell.button1 addTarget:self action:@selector(changegroupleader:) forControlEvents:UIControlEventTouchUpInside];
            cell.button1.tag=[((GroupRecord *)[GroupArray objectAtIndex:indexPath.row]).groupkey integerValue];
        }else{
            cell.imageview1.hidden=YES;
            cell.button1.enabled=NO;
            cell.imageview2.layer.opacity=0.3;
        }
        
        
        return cell;
    }else if (tableView==CompetencyTable){
        static NSString *CellIdentifier = @"competencycell";
        MyTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.label1.text=[[globalvariables.centerrecord.staffcompetencyvalues componentsSeparatedByString:@"/"] objectAtIndex:indexPath.row];
        
        if([workingStaff.competencyarray containsObject:[[globalvariables.centerrecord.staffcompetencyvalues componentsSeparatedByString:@"/"] objectAtIndex:indexPath.row]]){
            cell.imageview1.layer.opacity=1.0;
        }else{
            cell.imageview1.layer.opacity=0;
        }
        
        return cell;
    }else if (tableView==ColorCodeTable){
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        UILabel *titlelabel;
        UIImageView *titleselected;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 24, 16)];
            titlelabel.layer.masksToBounds=YES;
            titlelabel.layer.cornerRadius=4;
            titlelabel.tag=1301;
            [cell.contentView addSubview:titlelabel];
            
            titleselected = [[UIImageView alloc]initWithFrame:CGRectMake(grouptablewidth-45, 7, 24, 24)];
            [titleselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            titleselected.tag=1302;
            [cell.contentView addSubview:titleselected];
        }else{
            titlelabel=(UILabel *)[cell.contentView viewWithTag:1301];
            titleselected=(UIImageView *)[cell.contentView viewWithTag:1302];
        }
        
        titlelabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:indexPath.row];
        titleselected.hidden=(workingStaff.colorcode!=indexPath.row);
        
    }else if (tableView==availabilityTable){
        MyTableViewCell *cell;
        
        if(indexPath.section==0){
            if ([[availabilityRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"image"]) {
                static NSString *CellIdentifier = @"imagecell";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                [MyClass drawAvailabilityChartWithView:cell.imageview1 AvailabilityRecords:workingAvRecords ClassRecords:classRecords Small:NO];
                [self returnTotalAvailabilityHourWithHourLabel:cell.label1 MinuteLabel:cell.label2];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if ([[availabilityRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"add"]){
                static NSString *CellIdentifier = @"addcell";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                [cell.button1 setTitle:[MyClass returntitlewithtitle:@"Add New Timeslot"] forState:UIControlStateNormal];
                [cell.button1 addTarget:self action:@selector(addnewscheduleslot) forControlEvents:UIControlEventTouchUpInside];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if ([[availabilityRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"record"]){
                
                static NSString *CellIdentifier = @"recordcell";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                
                
                
                UIImage * image=nil;
                image =[UIImage imageNamed:@"lightgray_background"];
                image=[MyClass imageWithImage:image andWidth:50 andHeight:10];
                image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
                cell.rangeslider1.trackBackgroundImage=image;
                AvailabilityRecord *record;
                if ([StaffTableMode isEqualToString:@"View"]) {
                    record= [workingAvRecords objectAtIndex:indexPath.row-1];
                    
                    cell.button1.tag=indexPath.row-1;
                    
                    cell.rangeslider1.enabled=NO;
                    image =[UIImage imageNamed:@"gray_background"];
                    image=[MyClass imageWithImage:image andWidth:50 andHeight:10];
                    cell.leadingcontraint1.constant=15;
                    cell.button1.hidden=YES;
                    cell.rangeslider1.tag=indexPath.row-1;
                }else{
                    NSInteger avRow=workingAvRecords.count-(([tableView numberOfRowsInSection:indexPath.section]-1)-indexPath.row);
                    record= [workingAvRecords objectAtIndex:avRow];
                    cell.button1.tag=avRow;
                    
                    cell.rangeslider1.enabled=YES;
                    image =[UIImage imageNamed:@"orange_background"];
                    image=[MyClass imageWithImage:image andWidth:50 andHeight:10];
                    cell.leadingcontraint1.constant=49;
                    cell.button1.hidden=NO;
                    cell.rangeslider1.tag=avRow;
                }
                
                cell.label1.text=[NSString stringWithFormat:@"%@ - %@",record.starttime,record.endtime];
                [cell.button1 addTarget:self action:@selector(deleteavailabilityrecord:) forControlEvents:UIControlEventTouchUpInside];
                
                image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 7.0, 0.0, 7.0)];
                cell.rangeslider1.trackImage=image;
                
                cell.rangeslider1.minimumValue=0;
                cell.rangeslider1.maximumValue=24*(60/timestep);
                cell.rangeslider1.continuous=NO;
                cell.rangeslider1.stepValue=1;
                
                cell.rangeslider1.upperValue=[self returnslidevaluewithtime:record.endtime];
                cell.rangeslider1.lowerValue=[self returnslidevaluewithtime:record.starttime];
                [cell.rangeslider1 addTarget:self action:@selector(slidevaluechanged:) forControlEvents:UIControlEventAllTouchEvents];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if ([[availabilityRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"repeat"]){
                static NSString *CellIdentifier = @"endrepeat";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cell.label1.text=[MyClass returntitlewithtitle:@"Repeat"];
                cell.label2.text=[MyClass returntitlewithtitle:[self returnRepeatIntervalText]];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor=[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
            }else if ([[availabilityRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"endrepeat"]){
                static NSString *CellIdentifier = @"endrepeat";
                cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cell.label1.text=[MyClass returntitlewithtitle:@"End Repeat"];
                cell.label2.text=[MyClass convertDateFormatWithDate:endrepeatdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.backgroundColor=[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0];
            }
            
        }else{
            static NSString *CellIdentifier = @"classcell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            ClassRecord2 *ClassRecordObject=[ScheduledClassRecordArray objectAtIndex:indexPath.row];
            
            cell.label5.text=[MyClass returnsubjectnamewithsubject_shortname:ClassRecordObject.subject centerkey:globalvariables.centerrecord.centerkey];
            cell.label6.text= [MyClass returnclassremarkswithclassrecord:ClassRecordObject];
            cell.stackview3.hidden=[cell.label6.text isEqualToString:@""];
            
            if ([ClassRecordObject.type isEqualToString:@"student"]) {
                cell.label1.text=[MyClass returnStudentnameWithStudentkey:ClassRecordObject.typekey option:@"full"];
            }else{
                cell.label1.text=[MyClass returnLeadnameWithLeadkey:ClassRecordObject.typekey option:@"full"];
            }
            cell.label3.text=[MyClass returntitlewithtitle:ClassRecordObject.classtype];
            
            if ([ClassRecordObject.attendance isEqualToString:@"Makeup"]) {
                if ([ClassRecordObject.makeupdate isEqualToString:@""]) {
                    cell.label4.text=[MyClass returntitlewithtitle:@"TBD"];
                }else{
                    if ([ClassRecordObject.makeuptime isEqualToString:@""] || [ClassRecordObject.makeuptime isEqualToString:@"TBD"]) {
                        cell.label4.text=[MyClass returntitlewithtitle:@"TBD"];
                    }else{
                        cell.label4.text=ClassRecordObject.makeuptime;
                    }
                    
                }
                cell.label3.textColor=[UIColor orangeColor];
                cell.imageview1.hidden=[ClassRecordObject.makeupattendance isEqualToString:@""];
                [cell.imageview1 setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithattendance:ClassRecordObject.makeupattendance]]];
                
                cell.label11.text=([ClassRecordObject.makeupclassroom isEqualToString:@"TBD"] || [ClassRecordObject.makeupclassroom isEqualToString:@""])?[MyClass returntitlewithtitle:@"TBD"]: ClassRecordObject.makeupclassroom;
            }else{
                if ([ClassRecordObject.classtime isEqualToString:@"TBD"]) {
                    cell.label4.text=[MyClass returntitlewithtitle:@"TBD"];
                }else{
                    cell.label4.text=ClassRecordObject.classtime;
                }
                
                cell.label3.textColor=[UIColor blackColor];
                
                cell.label11.text=([ClassRecordObject.classroom isEqualToString:@"TBD"] || [ClassRecordObject.classroom isEqualToString:@""])?[MyClass returntitlewithtitle:@"TBD"]:ClassRecordObject.classroom;
                
                cell.imageview1.hidden=[ClassRecordObject.attendance isEqualToString:@""];
                [cell.imageview1 setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithattendance:ClassRecordObject.attendance]]];
            }
            
            
            
            if([ClassRecordObject.request_status isEqualToString:@"Pending Instructor"] || [ClassRecordObject.request_status isEqualToString:@"Pending Center"]){
                cell.stackview2.hidden=NO;
                if([ClassRecordObject.request_for_value isEqualToString:@""] || [ClassRecordObject.request_for_value isEqualToString:@"Present"]){
                    if([ClassRecordObject.attendance isEqualToString:@"Absent"]){
                        cell.label10.text=[MyClass returntitlewithtitle:@"Cancel absent requested"];
                    }else if ([ClassRecordObject.attendance isEqualToString:@"Makeup"]){
                        cell.label10.text=[MyClass returntitlewithtitle:@"Cancel makeup requested"];
                    }
                }else{
                    if([ClassRecordObject.request_for_date isEqualToString:@""]){
                        cell.label10.text=[MyClass returnreplacedtitlewithtitle:@"Makeup requested to %@1" replacementarray:@[[MyClass returntitlewithtitle:@"TBD"]]];
                    }else{
                        cell.label10.text=[MyClass returnreplacedtitlewithtitle:@"Makeup requested to %@1" replacementarray:@[[MyClass returndateformatDDMMMYYYYHHMMwithdate:[NSString stringWithFormat:@"%@ %@",ClassRecordObject.request_for_date,ClassRecordObject.request_for_time]]]];
                    }
                }
            }else{
                cell.stackview2.hidden=YES;
            }
            
            if ([ClassRecordObject.extendedminute intValue]==0) {
                cell.label9.text=[NSString stringWithFormat:@"%@%@", ClassRecordObject.duration,[MyClass returntitlewithtitle:@"mins"]];
                cell.label9.textColor=[UIColor grayColor];
            }else{
                cell.label9.text=[NSString stringWithFormat:@"%@+%@%@", ClassRecordObject.duration,ClassRecordObject.extendedminute,[MyClass returntitlewithtitle:@"mins"]];
                cell.label9.textColor=[UIColor redColor];
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            
        }
        
        
        
        return cell;
        
    }else if (tableView==pickerTable){
        MyTableViewCell *cell;
            static NSString *CellIdentifier = @"pickercell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
        
        cell.label1.text=[MyClass returntitlewithtitle:[repeatArray objectAtIndex:indexPath.row]];
        cell.imageview1.hidden=![[self returnRepeatIntervalText] isEqualToString:[repeatArray objectAtIndex:indexPath.row]];
        return cell;
    }
    return cell;
}

-(NSInteger) returnRepeatIntervalValue:(NSString *)value
{
    if ([value isEqualToString:@"Never"]) {
        return 0;
    }else if ([value isEqualToString:@"Every Day"]) {
        return 1;
    }else{
        return 7;
    }
}

-(void) changegroupleader:(UIButton *)sender
{
    for (int i=0; i<workingStaff.grouparray.count; i++) {
        GroupMemberRecord *member=[workingStaff.grouparray objectAtIndex:i];
        if ([member.groupkey integerValue]==sender.tag) {
            member.leader=!member.leader;
            break;
        }
    }

    [GroupTable reloadData];
    [StaffPopoverTable reloadData];
}

/*
-(void) updaterepeat:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex==0) {
        repeatinterval=0;
    }else if (sender.selectedSegmentIndex==1){
        repeatinterval=1;
    }else{
        repeatinterval=7;
    }
    [self updateAvailabilityTableRowArray];
    [availabilityTable reloadData];
}*/
                              
-(void) deleteavailabilityrecord:(UIButton *)sender
{
    //NSMutableArray *availabilityarray=[instructoravailabilitydict valueForKey:selecteddate];
    [workingAvRecords removeObjectAtIndex:sender.tag];
    /*if(workingAvRecords.count==0){
     [instructoravailabilitydict removeObjectForKey:selecteddate];
     }*/
    [self updateAvailabilityTableRowArray];
    [availabilityTable reloadData];
    //[self updateAvailability];
}

-(void) slidevaluechanged:(NMRangeSlider *)sender
{
    AvailabilityRecord *record= [workingAvRecords objectAtIndex:sender.tag];
    record.starttime=[self returntimewithslidevalue:(int)sender.lowerValue];
    record.endtime=[self returntimewithslidevalue:(int)sender.upperValue];

    MyTableViewCell *cell = [availabilityTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag+[availabilityRowDataArray indexOfObject:@"record"] inSection:0]];
    cell.label1.text=[NSString stringWithFormat:@"%@ - %@",record.starttime,record.endtime];
    
    if ([availabilityTable.indexPathsForVisibleRows containsObject:[NSIndexPath indexPathForRow:0 inSection:0]]) {
        MyTableViewCell *imagecell = [availabilityTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [MyClass drawAvailabilityChartWithView:imagecell.imageview1 AvailabilityRecords:workingAvRecords ClassRecords:classRecords Small:NO];
        [self returnTotalAvailabilityHourWithHourLabel:imagecell.label1 MinuteLabel:imagecell.label2];
    }
    
    
}

-(NSString *) returntimewithslidevalue:(int)value
{
    int noofstep=60/timestep;
    int hour=value/noofstep;
    int minute=(value % noofstep)*timestep;
    return [NSString stringWithFormat:@"%02d:%02d",hour,minute];
}

-(float) returnslidevaluewithtime:(NSString *)time
{
    int hour=[[time substringToIndex:2] intValue];
    int minute=[[time substringFromIndex:3] intValue];
    return hour*(60/timestep)+(minute/timestep);
}

-(NSMutableArray *) getGroupKeysWithMemberArray:(NSMutableArray *)memberarray
{
    NSMutableArray *groupkeyarray=[[NSMutableArray alloc]init];
    for (int i=0; i<memberarray.count; i++) {
        GroupMemberRecord *member=[memberarray objectAtIndex:i];
        [groupkeyarray addObject:member.groupkey];
    }
    return groupkeyarray;
}

-(GroupMemberRecord *) returnMemberWithMemberArray:(NSMutableArray *)selectedItems GroupRecord:(GroupRecord *)grouprecord
{
    for (int i=0; i<selectedItems.count; i++) {
        GroupMemberRecord *member=[selectedItems objectAtIndex:i];
        if([member.groupkey isEqualToString:grouprecord.groupkey]){
            return member;
        }
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //int popActualHeight;
    
    if (tableView==StaffPopoverTable) {
        if (![StaffTableMode isEqualToString:@"View"]) {
            if (indexPath.section==3 && indexPath.row==2) {
                //pickerview for date/time
                
                selectedItem=@"Group";
                
                
                if (showGroupTable==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [StaffPopoverTable reloadData];
                }else{
                    //showRolePicker=NO;
                    [self showsidewindowwithwindow:@"showGroup"];
                    [self adjusttablesize];
                    [StaffPopoverTable reloadData];
                    [StaffPopoverTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                
                [GroupTable reloadData];
                
                
            }else if (indexPath.section==5 && indexPath.row==3) {
                //pickerview for date/time
                
                selectedItem=@"Competency";
                
                
                if (showCompetencyTable==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [StaffPopoverTable reloadData];
                }else{
                    //showRolePicker=NO;
                    [self showsidewindowwithwindow:@"showCompetency"];
                    [self adjusttablesize];
                    [StaffPopoverTable reloadData];
                    [StaffPopoverTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                
                [GroupTable reloadData];
                
                
            }else if (indexPath.section==3 && indexPath.row==1 && (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editstaffprivilege || [StaffTableMode isEqualToString:@"Add"])) {
                //pickerview for instructor
                
                selectedItem=@"Privilege";
                
                
                if (showPrivilegeTable==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [StaffPopoverTable reloadData];
                }else{
                    //showRolePicker=NO;
                    [self showsidewindowwithwindow:@"showPrivilege"];
                    [self adjusttablesize];
                    [StaffPopoverTable reloadData];
                    [StaffPopoverTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                
                if ([workingStaff.privilege isEqualToString:@""]) {
                    workingStaff.privilege=((PrivilegeRecord *)[PrivilegeArray objectAtIndex:0]).privilegekey;
                }
                
                [PrivilegeTable reloadData];
                
            }else if (indexPath.section==3 && indexPath.row==3) {
                //pickerview for date/time
                
                selectedItem=@"ColorCode";
                
                
                if (showColorCodeTable==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [StaffPopoverTable reloadData];
                }else{
                    //showRolePicker=NO;
                    [self showsidewindowwithwindow:@"showColorCode"];
                    [self adjusttablesize];
                    [StaffPopoverTable reloadData];
                    [StaffPopoverTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                
                [ColorCodeTable reloadData];
                
                
            }else if (indexPath.section==5 && indexPath.row==0){
                if (workingStaff.staffschedule) {
                    [self getinstructoravailability];
                    [self showsidewindowwithwindow:@"showStaffSchedule"];
                    [self reloadMenuItems:cancelButton];
                    [self adjusttablesize];
                }
            }else if (indexPath.section==6 && indexPath.row==0){
                selectedItem=@"EffectiveResignationDate";
//                if ([workingStaff.effectiveresignationdate isEqualToString:@""]) {
//                    [df setDateFormat:@"dd-MMM-yyyy"];
//                    workingMarketing.startdate=[df stringFromDate:[NSDate date]];
//                }
                
                datetitle.text=[MyClass returntitlewithtitle:@"Availablity From"];
                [noneButton setTitle:@"Clear" forState:UIControlStateNormal];
                [self showsidewindowwithwindow:@"showEffectiveResignationDate"];
                [datecalendarview scrollToSelectedDateWithSelectedDateArray:[workingStaff.effectiveresignationdate isEqualToString:@""]?[[NSMutableArray alloc]init]:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:workingStaff.effectiveresignationdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy"] , nil] ScrollToDate:[workingStaff.effectiveresignationdate isEqualToString:@""]?[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"]:[MyClass convertDateFormatWithDate:workingStaff.effectiveresignationdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy"]  instructorselected:@"All"];

                [StaffPopoverTable reloadData];
                
                [self adjusttablesize];
            }
        }else{
            if (indexPath.section==5 && indexPath.row==0){
                if (workingStaff.staffschedule) {
                    
                    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self getinstructoravailability];
                        [self showsidewindowwithwindow:@"showStaffSchedule"];
                        [self reloadMenuItems:cancelButton];
                        [self adjusttablesize];
                        
                        [MyClass loadingindicatorwithoption:@"stop" color:nil];
                    });

                }
            }
        }
    }else if (tableView==GroupTable){
        NSString *selectedItem=((GroupRecord *)[GroupArray objectAtIndex:indexPath.row]).groupkey;
        if ([[self getGroupKeysWithMemberArray:workingStaff.grouparray] containsObject:selectedItem]) {
            [workingStaff.grouparray removeObject:selectedItem];
            for (int i=0; i<workingStaff.grouparray.count; i++) {
                GroupMemberRecord *member=[workingStaff.grouparray objectAtIndex:i];
                if ([member.groupkey isEqualToString:selectedItem]) {
                    [workingStaff.grouparray removeObjectAtIndex:i];
                    break;
                }
            }
        }else{
            [workingStaff.grouparray addObject:[[GroupMemberRecord alloc]initGroupMemberRecordwithgroupkey:selectedItem leader:NO]];
        }
        
        [GroupTable reloadData];
        [StaffPopoverTable reloadData];
    }else if(tableView==PrivilegeTable){
        if (![workingStaff.privilege isEqualToString:((PrivilegeRecord *)[PrivilegeArray objectAtIndex:indexPath.row]).privilegekey]) {
            workingStaff.privilege=((PrivilegeRecord *)[PrivilegeArray objectAtIndex:indexPath.row]).privilegekey;
            [PrivilegeTable reloadData];
            [StaffPopoverTable reloadData];
            [self adjusttablesize];
        }
    }else if(tableView==CompetencyTable){
        NSString *object=[[globalvariables.centerrecord.staffcompetencyvalues componentsSeparatedByString:@"/"] objectAtIndex:indexPath.row];
        if ([workingStaff.competencyarray containsObject:object]) {
            [workingStaff.competencyarray removeObject:object];
        }else{
            [workingStaff.competencyarray addObject:object];
        }
        [CompetencyTable reloadData];
        [StaffPopoverTable reloadData];
        [self adjusttablesize];
        
    }else if(tableView==ColorCodeTable){
        if (workingStaff.colorcode !=indexPath.row) {
            workingStaff.colorcode=indexPath.row;
            [ColorCodeTable reloadData];
            [StaffPopoverTable reloadData];
            [self adjusttablesize];
        }
    }else if (tableView==availabilityTable){
        if(![StaffTableMode isEqualToString:@"View"]){
            if (indexPath.row==1){
                [UIView transitionWithView:pickerview duration:0.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    pickerview.hidden = NO;
                    [pickerTable reloadData];
                    [self reloadMenuItems:nil];
                    [availabilityTable deselectRowAtIndexPath:indexPath animated:NO];
                    
                }completion:NULL];
            }else if(indexPath.row==2 && repeatinterval>0){
                [UIView transitionWithView:endrepeatview duration:0.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    endrepeatview.hidden = NO;
                    [self reloadMenuItems:nil];
                    [availabilityTable deselectRowAtIndexPath:indexPath animated:NO];
                    
                    ScheduleRecord *schedule;
                    if(repeatinterval==7){
                        schedule=[[ScheduleRecord alloc]initScheduleRecordwithScheduleKey:nil Name:nil AutoRenew:nil DayTimeArray:[[NSMutableArray alloc]initWithObjects:[[ScheduleDetailsRecord alloc]initScheduleDetailsRecordwithdayofweek:[MyClass convertDateFormatWithDate:[selectedDates firstObject] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"EEE" Translate:NO] classtime:nil instructor:nil classroom:nil sinstructor:nil], nil] Action:nil StartDate:[MyClass convertDateFormatWithDate:[selectedDates firstObject] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO] EndDate:@"" makeupschedule:NO active:YES type:@"Recursive" showintimetableifnoenrollment:NO onlinetrialschedule:NO levelarray:nil];
                    }
                    
                    endrepeatcalendarview.schedulerecord=schedule;
                    [endrepeatcalendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:endrepeatdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO], nil] ScrollToDate:nil  instructorselected:@"All"];
                }completion:NULL];
            }
        }
    }else if (tableView==pickerTable){
        if (repeatinterval !=[self returnRepeatIntervalValue:[repeatArray objectAtIndex:indexPath.row]]) {
            repeatinterval=[self returnRepeatIntervalValue:[repeatArray objectAtIndex:indexPath.row]];
            endrepeatdate=[MyClass convertDateFormatWithDate:[selectedDates firstObject] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
            [self updateAvailabilityTableRowArray];
            [availabilityTable reloadData];
            
        }
        [self cancelbuttonpressed:nil];
    }
}

-(void) addnewscheduleslot
{
    [workingAvRecords addObject:[[AvailabilityRecord alloc]initAvailabilityRecordWithDate:nil StartTime:@"00:00" EndTime:@"00:00"]];
    [self updateAvailabilityTableRowArray];
    [availabilityTable reloadData];
}


-(void) updatetextfield:(UITextField *)sender
{
    if (sender.tag==1) {
        workingStaff.firstname=sender.text;
    }else if (sender.tag==0) {
        workingStaff.lastname=sender.text;
    }else if (sender.tag==2) {
        workingStaff.username=sender.text;
    }else if (sender.tag==3) {
        sender.text=[MyClass allspacestrimmed:sender.text];
        if (![MyClass checkValidInput:sender.text Type:@"EmptyInteger"]){
            sender.text=[MyClass returnLocalNumberWithContact:workingStaff.phone ISOCode:workingStaff.iso_code];
        }else{
            workingStaff.phone=[NSString stringWithFormat:@"%@%@", [MyClass returnCountryCodeWithISOCode:workingStaff.iso_code], sender.text];
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    CGPoint rootViewPoint = [textView.superview convertPoint:CGPointZero toView:StaffPopoverTable];
    NSIndexPath *indexPath = [StaffPopoverTable indexPathForRowAtPoint:rootViewPoint];
    
    MyTableViewCell *newcell=[StaffPopoverTable cellForRowAtIndexPath:indexPath];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    if (size.height>100) {
        newcell.layoutconstraint1.constant=100;
        textView.scrollEnabled=YES;
    }else{
        newcell.layoutconstraint1.constant=size.height;
        textView.scrollEnabled=NO;
    }
    
    if (textView.tag==0) {
        workingStaff.remarks=textView.text;
    }
    [StaffPopoverTable beginUpdates];
    [StaffPopoverTable endUpdates];
}



-(BOOL) showSalaryRate
{
    return ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).vieweditsalaryrate && globalvariables.centerrecord.enablestaffsalaryrate && [workingStaff.role isEqualToString:@"Instructor"];
}

-(BOOL) showCompetence
{
    return globalvariables.centerrecord.enablestaffcompetency;
}

-(BOOL) showStaffSchedule
{
    return [workingStaff.role isEqualToString:@"Instructor"];
}


-(BOOL) showConfirmMakeupRequest
{
    return [globalvariables.centerrecord.iparentleavemode isEqualToString:@"Request"] && [workingStaff.role isEqualToString:@"Instructor"];
}

-(NSMutableArray *) copyGroupMemberArrayWithArray:(NSMutableArray *)memberarray
{
    NSMutableArray *newarray=[[NSMutableArray alloc]init];
    for (int i=0; i<memberarray.count; i++) {
        GroupMemberRecord *obj=[memberarray objectAtIndex:i];
        [newarray addObject:[[GroupMemberRecord alloc]initGroupMemberRecordwithgroupkey:obj.groupkey leader:obj.leader]];
    }
    return newarray;
}

-(void) InitializeField
{
    workingStaff.grouparray=[[NSMutableArray alloc]init];
    
    [self showsidewindowwithwindow:@""];
    
    if ([StaffTableMode isEqualToString:@"View"]){
        //showRolePicker=NO;
        //showGroupPicker=NO;
        //showPrivilegePicker=NO;
        showDeleteButton=NO;

        workingStaff.staffkey=StaffObject.staffkey;
        workingStaff.firstname=StaffObject.firstname;
        workingStaff.lastname=StaffObject.lastname;
        workingStaff.status=StaffObject.status;
        workingStaff.username=StaffObject.username;
        workingStaff.phone=StaffObject.phone;
        workingStaff.role=StaffObject.role;
        workingStaff.grouparray=[self copyGroupMemberArrayWithArray:StaffObject.grouparray];
        workingStaff.privilege=StaffObject.privilege;
        workingStaff.centerapp=StaffObject.centerapp;
        workingStaff.staffapp=StaffObject.staffapp;
        workingStaff.biapp=StaffObject.biapp;
        workingStaff.staffschedule=StaffObject.staffschedule;
        workingStaff.salaryrate=StaffObject.salaryrate;
        workingStaff.remarks=StaffObject.remarks;
        workingStaff.confirmmakeuprequest=StaffObject.confirmmakeuprequest;
        workingStaff.iso_code=StaffObject.iso_code;
        workingStaff.colorcode=StaffObject.colorcode;
        workingStaff.effectiveresignationdate=StaffObject.effectiveresignationdate;
        workingStaff.competencyarray=[[NSMutableArray alloc]initWithArray:StaffObject.competencyarray];
        
        [self createViewBarButton];
        
    }else if ([StaffTableMode isEqualToString:@"Edit"]) {
        //showRolePicker=NO;
        //showGroupPicker=NO;
        //showPrivilegePicker=NO;
        showDeleteButton=YES;

        workingStaff.staffkey=StaffObject.staffkey;
        workingStaff.firstname=StaffObject.firstname;
        workingStaff.lastname=StaffObject.lastname;
        workingStaff.status=StaffObject.status;
        workingStaff.username=StaffObject.username;
        workingStaff.phone=StaffObject.phone;
        workingStaff.role=StaffObject.role;
        workingStaff.grouparray=[self copyGroupMemberArrayWithArray:StaffObject.grouparray];
        workingStaff.privilege=StaffObject.privilege;
        workingStaff.centerapp=StaffObject.centerapp;
        workingStaff.staffapp=StaffObject.staffapp;
        workingStaff.biapp=StaffObject.biapp;
        workingStaff.staffschedule=StaffObject.staffschedule;
        workingStaff.salaryrate=StaffObject.salaryrate;
        workingStaff.remarks=StaffObject.remarks;
        workingStaff.confirmmakeuprequest=StaffObject.confirmmakeuprequest;
        workingStaff.iso_code=StaffObject.iso_code;
        workingStaff.colorcode=StaffObject.colorcode;
        workingStaff.effectiveresignationdate=StaffObject.effectiveresignationdate;
        workingStaff.competencyarray=[[NSMutableArray alloc]initWithArray:StaffObject.competencyarray];
        /*swSat.on=[tmpSat isEqualToString:@"Yes"] ? TRUE:FALSE;
        swSat.on=[tmpSun isEqualToString:@"Yes"] ? TRUE:FALSE;*/
        [self createEditBarButton];
        
    }else if ([StaffTableMode isEqualToString:@"Add"]){
        //showRolePicker=NO;
        //showGroupPicker=NO;
        //showPrivilegePicker=NO;
        showDeleteButton=NO;
        
        workingStaff.firstname=@"";
        workingStaff.lastname=@"";
        workingStaff.status=@"Yes";
        workingStaff.username=@"";
        
        CountryCodeRecord *local=[MyClass returnCountryCodeRecordWithLocalCountry];
        workingStaff.iso_code=local.iso_code;
        workingStaff.phone=local.country_code;

        workingStaff.role=@"";
        workingStaff.grouparray=[[NSMutableArray alloc]init];
        workingStaff.privilege=@"";
        workingStaff.centerapp=FALSE;
        workingStaff.staffapp=FALSE;
        workingStaff.biapp=FALSE;
        workingStaff.staffschedule=NO;
        workingStaff.salaryrate=@"";
        workingStaff.remarks=@"";
        workingStaff.confirmmakeuprequest=NO;
        workingStaff.colorcode=[MyClass returnFreeColorCodewithType:@"staff"];
        workingStaff.effectiveresignationdate=@"";
        workingStaff.competencyarray=[[NSMutableArray alloc]init];
        [self createAddBarButton];
    }
}

-(void) adjusttablesize
{
    float tableheight;
    float tablewidth;
    
    tableheight=maxPopupHeight-keyboardheight;
    
    if (showPrivilegeTable) {
        tablewidth=popoverwidth+privilegetablewidth;
    }else if (showGroupTable){
        tablewidth=popoverwidth+grouptablewidth;
    }else if (showStaffSchedule){
        tablewidth=popoverwidth+staffschedulewidth;
    }else if (showColorCodeTable){
        tablewidth=popoverwidth+grouptablewidth;
    }else if (showDateTable){
        tablewidth=popoverwidth+datewidth;
    }else if (showCompetencyTable){
        tablewidth=popoverwidth+competencytablewidth;
    }else{
        tablewidth=popoverwidth;
    }
    stafftablebottomconstraint.constant=keyboardheight;
    competencytablebottomconstraint.constant=keyboardheight;
    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    
    self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
    
    if (showPrivilegeTable) {
        [PrivilegeTable setFrame:CGRectMake(0, 44+44+20, privilegetablewidth, tableheight-44-20)];
        PrivilegeTableMasterView.hidden=NO;
        GroupTableMasterView.hidden=YES;
        StaffScheduleMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=YES;
        DateMasterView.hidden=YES;
        CompetenceTableMasterView.hidden=YES;
    }else if (showGroupTable){
        PrivilegeTableMasterView.hidden=YES;
        GroupTableMasterView.hidden=NO;
        StaffScheduleMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=YES;
        DateMasterView.hidden=YES;
        CompetenceTableMasterView.hidden=YES;
    }else if (showStaffSchedule){
        PrivilegeTableMasterView.hidden=YES;
        GroupTableMasterView.hidden=YES;
        StaffScheduleMasterView.hidden=NO;
        ColorCodeTableMasterView.hidden=YES;
        [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]init] ScrollToDate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"]  instructorselected:@"All"];
        [calendarview reloadWithInstructorAvailability:instructoravailabilitydict ClassRecords:classrecordsdict];
        DateMasterView.hidden=YES;
        CompetenceTableMasterView.hidden=YES;
    }else if (showColorCodeTable){
        [ColorCodeTable setFrame:CGRectMake(0, 44+44+20, grouptablewidth, tableheight-44-20)];
        PrivilegeTableMasterView.hidden=YES;
        GroupTableMasterView.hidden=YES;
        StaffScheduleMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=NO;
        DateMasterView.hidden=YES;
        CompetenceTableMasterView.hidden=YES;
    }else if (showDateTable){
        PrivilegeTableMasterView.hidden=YES;
        GroupTableMasterView.hidden=YES;
        StaffScheduleMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=YES;
        DateMasterView.hidden=NO;
        CompetenceTableMasterView.hidden=YES;
    }else if (showCompetencyTable) {
        PrivilegeTableMasterView.hidden=YES;
        GroupTableMasterView.hidden=YES;
        StaffScheduleMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=YES;
        DateMasterView.hidden=YES;
        CompetenceTableMasterView.hidden=NO;
    }
    
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    showPrivilegeTable=[windowname isEqualToString:@"showPrivilege"];
    showGroupTable=[windowname isEqualToString:@"showGroup"];
    showStaffSchedule=[windowname isEqualToString:@"showStaffSchedule"];
    showColorCodeTable=[windowname isEqualToString:@"showColorCode"];
    showDateTable=[windowname isEqualToString:@"showEffectiveResignationDate"];
    showCompetencyTable=[windowname isEqualToString:@"showCompetency"];
    instructoravailabilityview.hidden=YES;
}

-(void) deleteStaff:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Staff"] message:[NSString stringWithFormat:@"%@ %@?",[MyClass returntitlewithtitle:@"Are you sure to delete"],[StaffObject.lastname isEqualToString:@""] ? StaffObject.firstname:[NSString stringWithFormat:@"%@ %@",StaffObject.firstname,StaffObject.lastname]] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([self retrieveStaffCountWithUsername:workingStaff.username]) {
            if (staffCanBeDeleted) {
                //delete staff record
                [self deleteStaffwithStaffkey:StaffObject.staffkey];
            }else{
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff cannot be deleted"] message:[workingStaff.role isEqualToString:@"Instructor"]? [MyClass returntitlewithtitle:@"There are class or task records associated to this staff" ]:[MyClass returntitlewithtitle:@"There are task records associated to this staff"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
            }
        }
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"No"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:OKAction];
    [alert addAction:CancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)deleteStaffwithStaffkey:(NSString *)staffkey
{
    //delete staff record in center db
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletestaff&staffkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,staffkey];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            result=TRUE;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        [self.delegate dismissStaffPopoverWithLogoutOption:[workingStaff.username caseInsensitiveCompare:globalvariables.username]==NSOrderedSame?YES:NO];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/

}

-(IBAction) doneButtonPressed:(id)sender
{
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }
    //[self storeTmpField];
    
    
    workingStaff.firstname=[MyClass leadingtrailingspacestrimmed:workingStaff.firstname];
    workingStaff.username=[MyClass leadingtrailingspacestrimmed:workingStaff.username];
    workingStaff.phone=[MyClass leadingtrailingspacestrimmed:workingStaff.phone];
    
    [StaffPopoverTable reloadData];
    
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        

    

    NSString *tmpfirstname=[MyClass leadingtrailingspacestrimmed:workingStaff.firstname];
    //NSString *tmplastname=[MyClass leadingtrailingspacestrimmed:workingStaff.lastname];
    
    
    if ([tmpfirstname isEqualToString:@""]) {

        UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:[NSString stringWithFormat:@"%@ %@",StaffTableMode,@"Staff Information"]] message:[MyClass returntitlewithtitle:@"Please input staff's first name"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missingalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missingalert addAction:OKAction];
        //[self presentViewController:missingalert animated:YES completion:nil];
                    [MyClass presentViewController:missingalert View:self];

    }else if ([workingStaff.username isEqualToString:@""]){

        
        UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:[NSString stringWithFormat:@"%@ %@",StaffTableMode,@"Staff Information"]] message:[MyClass returntitlewithtitle:@"Please input staff's username/email"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missingalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missingalert addAction:OKAction];
        //[self presentViewController:missingalert animated:YES completion:nil];
                    [MyClass presentViewController:missingalert View:self];

        
    }else if (![self NSStringIsValidEmail:workingStaff.username]){
        UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:[NSString stringWithFormat:@"%@ %@",StaffTableMode,@"Staff Information"]] message:[MyClass returntitlewithtitle:@"Username should be an valid email address"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missingalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missingalert addAction:OKAction];
        //[self presentViewController:missingalert animated:YES completion:nil];
                    [MyClass presentViewController:missingalert View:self];
        
        
    }else if (((NSRange)[workingStaff.username rangeOfString:@":" options:NSBackwardsSearch]).location!=NSNotFound){

        
        UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:[NSString stringWithFormat:@"%@ %@",StaffTableMode,@"Staff Information"]] message:[MyClass returntitlewithtitle:@"Cannot use : in username/email"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missingalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missingalert addAction:OKAction];
        //[self presentViewController:missingalert animated:YES completion:nil];
                    [MyClass presentViewController:missingalert View:self];

    }else if ([workingStaff.privilege isEqualToString:@""]){

        
        UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:[NSString stringWithFormat:@"%@ %@",StaffTableMode,@"Staff Information"]] message:[MyClass returntitlewithtitle:@"Please select staff's privilege"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missingalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missingalert addAction:OKAction];
        //[self presentViewController:missingalert animated:YES completion:nil];
                    [MyClass presentViewController:missingalert View:self];

    }else if ([[MyClass returnLocalNumberWithContact:workingStaff.phone ISOCode:workingStaff.iso_code] isEqualToString:@""] && (workingStaff.centerapp || workingStaff.staffapp)){

        
        UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:[NSString stringWithFormat:@"%@ %@",StaffTableMode,@"Staff Information"]] message:[MyClass returntitlewithtitle:@"Please input staff's mobile number"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missingalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missingalert addAction:OKAction];
        //[self presentViewController:missingalert animated:YES completion:nil];
                    [MyClass presentViewController:missingalert View:self];

    }else if ([[MyClass returnLocalNumberWithContact:workingStaff.phone ISOCode:workingStaff.iso_code] isEqualToString:@""]){
        UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:[NSString stringWithFormat:@"%@ %@",StaffTableMode,@"Staff Information"]] message:[MyClass returntitlewithtitle:@"Please input staff's mobile number"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missingalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missingalert addAction:OKAction];
        //[self presentViewController:missingalert animated:YES completion:nil];
                    [MyClass presentViewController:missingalert View:self];
        
    }else if (![workingStaff.phone isEqualToString:@""] && ![MyClass checkvalidmobilenumber:PhoneText.text]){

        
        UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:[NSString stringWithFormat:@"%@ %@",StaffTableMode,@"Staff Information"]] message:[MyClass returntitlewithtitle:@"Please input valid staff's mobile number"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missingalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missingalert addAction:OKAction];
        //[self presentViewController:missingalert animated:YES completion:nil];
                    [MyClass presentViewController:missingalert View:self];

    }else{
        NSString *usernameavailable=[self checkusernameavailablityok:workingStaff.username];
        if (usernameavailable) {
            if ([usernameavailable isEqualToString:@"NOK"]) {
                
                UIAlertController *missingalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Username is not available"] message:[MyClass returntitlewithtitle:@"Please select another one"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [missingalert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [missingalert addAction:OKAction];
                //[self presentViewController:missingalert animated:YES completion:nil];
                    [MyClass presentViewController:missingalert View:self];

            }else{
                //NSString *strURL;
                //Staff *tmpstaff;
                
                if ([StaffTableMode isEqualToString:@"Edit"]) {
                    
                    //check license
                    
                    if (![self hasEnoughStaffLicenseWithNewStaffapp:workingStaff.staffapp OldStaffapp:StaffObject.staffapp]) {
                        [MyClass loadingindicatorwithoption:@"stop" color:nil];
                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Information"] message:[MyClass returnreplacedtitlewithtitle:@"All %@1 licenses are used up. Please go to subscription page under center setup to add more license" replacementarray:@[@"iStaff"]] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [erroralert addAction:OKAction];
                        //[self presentViewController:erroralert animated:YES completion:nil];
                    [MyClass presentViewController:erroralert View:self];
                        return;
                    }
                    
                    if (![self hasEnoughCenterLicenseWithNewCenterapp:workingStaff.centerapp OldCenterapp:StaffObject.centerapp]) {
                        [MyClass loadingindicatorwithoption:@"stop" color:nil];
                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Information"] message:[MyClass returnreplacedtitlewithtitle:@"All %@1 licenses are used up. Please go to subscription page under center setup to add more license" replacementarray:@[@"iCenter"]] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [erroralert addAction:OKAction];
                        //[self presentViewController:erroralert animated:YES completion:nil];
                    [MyClass presentViewController:erroralert View:self];
                        return;
                    }


                    
                    if (![self hasEnoughBILicenseWithNewBIapp:workingStaff.biapp OldBIapp:StaffObject.biapp]) {
                        [MyClass loadingindicatorwithoption:@"stop" color:nil];
                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Information"] message:[MyClass returnreplacedtitlewithtitle:@"All %@1 licenses are used up. Please go to subscription page under center setup to add more license" replacementarray:@[@"BI"]] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                            
                        }];
                        
                        [erroralert addAction:OKAction];
                        //[self presentViewController:erroralert animated:YES completion:nil];
                    [MyClass presentViewController:erroralert View:self];
                        return;
                    }
                    
                    workingStaff.centerkey=globalvariables.centerrecord.centerkey;

                    
                    if([self updateStaffWithStaff:workingStaff Action:@"Edit"]){
                        //edit self
                        if ([StaffObject.username isEqualToString:globalvariables.username]) {
                            ((UserPrivilege *)[MyClass returnuserprivilegewithcenterkey:globalvariables.centerrecord.centerkey]).privilegekey=workingStaff.privilege;
                            ((UserPrivilege *)[MyClass returnuserprivilegewithcenterkey:globalvariables.centerrecord.centerkey]).role=workingStaff.role;
                            
                            if (![globalvariables.username isEqualToString:[workingStaff.username lowercaseString]]) {
                                globalvariables.username=[workingStaff.username lowercaseString];
                                
                                //update new username to local table
                                [MyClass updatelocaldbwithparameter:@"username" value:UsernameText.text];
                                
                            }
                        }
                        
                        [self.delegate dismissStaffPopoverWithLogoutOption:NO];
                        
                        UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Edit Staff"] message:[MyClass returntitlewithtitle:@"Staff information is successfully updated"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [successalert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [successalert addAction:OKAction];
                        //[self presentViewController:successalert animated:YES completion:nil];
                    [MyClass presentViewController:successalert View:self];
                    }else{
                        [MyClass showconnectionlostdialogbox];
                    }

                }else{
                    
                    //check license
                    if (![self hasEnoughStaffLicenseWithNewStaffapp:workingStaff.staffapp OldStaffapp:FALSE]) {
                        
                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Information"] message:[MyClass returnreplacedtitlewithtitle:@"All %@1 licenses are used up. Please go to subscription page under center setup to add more license" replacementarray:@[@"iStaff"]] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [erroralert addAction:OKAction];
                        //[self presentViewController:erroralert animated:YES completion:nil];
                    [MyClass presentViewController:erroralert View:self];
                        return;
                    }
                    
                    
                    if (![self hasEnoughCenterLicenseWithNewCenterapp:workingStaff.centerapp OldCenterapp:FALSE]) {
                        
                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Information"] message:[MyClass returnreplacedtitlewithtitle:@"All %@1 licenses are used up. Please go to subscription page under center setup to add more license" replacementarray:@[@"iCenter"]] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [erroralert addAction:OKAction];
                        //[self presentViewController:erroralert animated:YES completion:nil];
                    [MyClass presentViewController:erroralert View:self];
                        return;
                    }
                    

                    
                    if (![self hasEnoughBILicenseWithNewBIapp:workingStaff.biapp OldBIapp:FALSE]) {
                        
                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Information"] message:[MyClass returnreplacedtitlewithtitle:@"All %@1 licenses are used up. Please go to subscription page under center setup to add more license" replacementarray:@[@"BI"]] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [erroralert addAction:OKAction];
                        //[self presentViewController:erroralert animated:YES completion:nil];
                    [MyClass presentViewController:erroralert View:self];
                        return;
                    }
                    

                        //add new staff to db

                    //tmpstaff=workingStaff;
                    workingStaff.centerkey=globalvariables.centerrecord.centerkey;

                    
                    
                    if([self updateStaffWithStaff:workingStaff Action:@"Add"]){
                        [self.delegate dismissStaffPopoverWithLogoutOption:NO];
                        
                        UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Add New Staff"] message:[MyClass returntitlewithtitle:@"New Staff is successfully added"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [successalert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [successalert addAction:OKAction];
                        //[self presentViewController:successalert animated:YES completion:nil];
                    [MyClass presentViewController:successalert View:self];

                    }else{
                        [MyClass showconnectionlostdialogbox];
                    }
                }
            }
        }
    }
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}


- (void)activatestaffapp:(UISwitch *)sender {
    
    if (sender.on) {
        
        if ([workingStaff.phone isEqualToString:@""]) {
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Enable iStaff App"] message:[MyClass returntitlewithtitle:@"Please input staff's mobile number"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
            
            [sender setOn:NO animated:YES];
        }else if(![MyClass checkvalidmobilenumber:PhoneText.text]){
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Enable iStaff App"] message:[MyClass returntitlewithtitle:@"Invalid mobile number. Please input again"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
            
            [sender setOn:NO animated:YES];
        }
    }
    
    workingStaff.staffapp=sender.on;
    
    if (!workingStaff.centerapp&&!workingStaff.staffapp) {
        workingStaff.biapp=FALSE;
    }
    //[self storeTmpField];
    [StaffPopoverTable reloadData];
    
}

- (void)activatecenterapp:(UISwitch *)sender {
    
    if (sender.on) {
        
        if ([workingStaff.phone isEqualToString:@""]) {
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Enable iCenter App"] message:[MyClass returntitlewithtitle:@"Please input staff's mobile number"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
            [sender setOn:NO animated:YES];
        }else if(![MyClass checkvalidmobilenumber:PhoneText.text]){
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Enable iCenter App"] message:[MyClass returntitlewithtitle:@"Invalid mobile number. Please input again"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
            [sender setOn:NO animated:YES];
            
        }
        
    }
    workingStaff.centerapp=sender.on;
    
    if (!workingStaff.centerapp&&!workingStaff.staffapp) {
        workingStaff.biapp=FALSE;
    }
    
    //[self storeTmpField];
    [StaffPopoverTable reloadData];
    
}

- (void)activatebiapp:(UISwitch *)sender
{
    workingStaff.biapp=sender.on;
}

- (void)activateteaching:(UISwitch *)sender
{
    workingStaff.role=sender.on?@"Instructor":@"";
    [self showsidewindowwithwindow:@""];
    [StaffPopoverTable reloadData];
    
}




-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

-(void) selectStatus:(UISegmentedControl *)sender
{
    if (workingStaff.centerapp) {
        //[swiCenterapp setOn:NO animated:YES];
        workingStaff.centerapp=FALSE;
    }
    
    if (workingStaff.staffapp) {
        //[swiStaffapp setOn:NO animated:YES];
        workingStaff.staffapp=FALSE;
    }

    if (workingStaff.biapp) {
        //[swBIapp setOn:NO animated:YES];
        workingStaff.biapp=FALSE;
    }
    
    workingStaff.status=sender.selectedSegmentIndex==0?@"Yes":@"No";
    [StaffPopoverTable reloadData];
}


- (BOOL) retrieveStaffCountWithUsername:(NSString *)username
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievestaffcount&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,username];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSString *strResult = jsonreturned[@"content"];
            if ([strResult intValue] > 0) {
                staffCanBeDeleted=NO;
            }else{
                staffCanBeDeleted=YES;
            }
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSString *strResult = jsonreturned[@"content"];
            if ([strResult intValue] > 0) {
                staffCanBeDeleted=NO;
            }else{
                staffCanBeDeleted=YES;
            }
        }
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    return result;
}

-(NSString *) checkusernameavailablityok:(NSString *)username
{
    if ([username caseInsensitiveCompare:StaffObject.username]==NSOrderedSame) {
        return @"OK";
    }else{
        //create string contains url address for php file
        NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=checkstaffusernameavailability&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,[username lowercaseString]];
        
        __block BOOL result=FALSE;
        __block NSMutableArray *JSONArray;

        [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                JSONArray = jsonreturned[@"content"];
            }
        }];
        
        /*
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            // handle response
            
            if (!error) {
                result=TRUE;
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                JSONArray = jsonreturned[@"content"];
            }
            
            dispatch_semaphore_signal(semaphore);
        }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
        if (result) {
            if (JSONArray.count>0) {
                return @"NOK";
            }else{
                return @"OK";
            }
        }/*else{
            [MyClass showconnectionlostdialogbox];
        }*/
        return nil;
    }
}

-(void) enableStaffSchedule:(UISwitch *)sender
{
    workingStaff.staffschedule=sender.on;
    [StaffPopoverTable reloadData];
}


-(void) enableConfirmMakeupRequest:(UISwitch *)sender
{
    workingStaff.confirmmakeuprequest=sender.on;
    [StaffPopoverTable reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView==StaffPopoverTable) {
        if (section==5) {
            if (![self showStaffSchedule]) {
                return CGFLOAT_MIN;
            }
        }
    }else if (tableView==PrivilegeTable){
        return CGFLOAT_MIN;
    }else if (tableView==ColorCodeTable){
        return CGFLOAT_MIN;
    }else if (tableView==availabilityTable){
        if(section==0){
            return CGFLOAT_MIN;
        }
    }else if (tableView==pickerTable){
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

- (void)validateinput:(UITextField *)sender {
    
    if (sender.tag==4) {
        if (![self checkvalidfeeinput:sender.text]) {
            sender.text=@"";
            
            UIAlertController *errorinputalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Information"] message:[MyClass returntitlewithtitle:@"Invalid input"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [errorinputalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [errorinputalert addAction:OKAction];
            //[self presentViewController:errorinputalert animated:YES completion:nil];
            [MyClass presentViewController:errorinputalert View:self];
        }else if ([sender.text intValue]>100){
            sender.text=@"";
            
            UIAlertController *errorinputalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Information"] message:[MyClass returntitlewithtitle:@"Invalid input"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [errorinputalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [errorinputalert addAction:OKAction];
            //[self presentViewController:errorinputalert animated:YES completion:nil];
            [MyClass presentViewController:errorinputalert View:self];
        }else{
            workingStaff.salaryrate=sender.text;
        }
    }
}

-(BOOL) checkvalidfeeinput:(NSString *)input
{
    NSString *decimalRegex = @"^(?:|-)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", decimalRegex];
    
    if ([regexPredicate evaluateWithObject: input]){
        //Matches
        return TRUE;
    }else{
        return FALSE;
    }
}

-(BOOL) hasEnoughStaffLicenseWithNewStaffapp:(BOOL)newstaffapp OldStaffapp:(BOOL)oldstaffapp
{
    int newstaffcount=newstaffapp?1:0;
    int oldstaffcount=oldstaffapp?1:0;

    
    if (newstaffcount>oldstaffcount) {
        if ([MyClass getremaininglicensewithtype:@"istaff"]>=newstaffcount-oldstaffcount) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
    
}

-(BOOL) hasEnoughCenterLicenseWithNewCenterapp:(BOOL)newcenterapp OldCenterapp:(BOOL)oldcenterapp
{
    int newcentercount=newcenterapp?1:0;
    int oldcentercount=oldcenterapp?1:0;
    
    
    if (newcentercount>oldcentercount) {
        if ([MyClass getremaininglicensewithtype:@"icenter"]>=newcentercount-oldcentercount) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
    
}

-(BOOL) hasEnoughBILicenseWithNewBIapp:(BOOL)newbiapp OldBIapp:(BOOL)oldbiapp
{
    int newbicount=newbiapp?1:0;
    int oldbicount=oldbiapp?1:0;
    
    
    if (newbicount>oldbicount) {
        if ([MyClass getremaininglicensewithtype:@"bi"]>=newbicount-oldbicount) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
    
}

-(BOOL) groupkeyupdated
{
    if (workingStaff.grouparray.count!=StaffObject.grouparray.count) {
        return TRUE;
    }
    
    for (int i=0; i<workingStaff.grouparray.count; i++) {
        GroupMemberRecord *workingmember=[workingStaff.grouparray objectAtIndex:i];
        GroupMemberRecord *origmember=[StaffObject.grouparray objectAtIndex:i];
        if (![workingmember.groupkey isEqualToString:origmember.groupkey] || workingmember.leader!=origmember.leader) {
            return TRUE;
        }
    }
    
    return FALSE;
}

-(BOOL) updateStaffWithStaff:(Staff *)staff Action:(NSString *)action
{
    


        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        [dictionary setValue:@"updatestaff" forKey:@"postaction"];
        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
        [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dictionary setValue:globalvariables.centerrecord.entitykey forKey:@"entitykey"];
        
        
        [dictionary setValue:action forKey:@"action"];
        [dictionary setValue:[MyClass leadingtrailingspacestrimmed:staff.firstname] forKey:@"firstname"];
        [dictionary setValue:[MyClass leadingtrailingspacestrimmed:staff.lastname] forKey:@"lastname"];
        [dictionary setValue:staff.status forKey:@"status"];
        [dictionary setValue:[MyClass allspacestrimmed:[staff.username lowercaseString]] forKey:@"username"];
        [dictionary setValue:staff.phone forKey:@"phone"];
        [dictionary setValue:staff.iso_code forKey:@"iso_code"];
        [dictionary setValue:staff.role forKey:@"role"];
        [dictionary setValue:staff.privilege forKey:@"privilege"];
        [dictionary setValue:staff.staffapp?@"Yes":@"No" forKey:@"staffapp"];
        [dictionary setValue:staff.centerapp?@"Yes":@"No" forKey:@"centerapp"];
        [dictionary setValue:staff.biapp?@"Yes":@"No" forKey:@"biapp"];
        [dictionary setValue:[staff.role isEqualToString:@"Instructor"]?(staff.staffschedule?@"Yes":@"No"):@"No" forKey:@"staffschedule"];
        [dictionary setValue:[staff.role isEqualToString:@"Instructor"]?(staff.confirmmakeuprequest?@"Yes":@"No"):@"No" forKey:@"confirmmakeuprequest"];
        [dictionary setValue:[staff.role isEqualToString:@"Instructor"]?staff.salaryrate:@"" forKey:@"salaryrate"];
        [dictionary setValue:staff.remarks forKey:@"remarks"];
        [dictionary setValue:staff.competencyarray.count==0?@"":[staff.competencyarray componentsJoinedByString:@"/"] forKey:@"competency"];
        [dictionary setValue:globalvariables.username forKey:@"updatedby"];
        [dictionary setValue:[@(staff.colorcode) stringValue] forKey:@"colorcode"];
        [dictionary setValue:staff.effectiveresignationdate forKey:@"effectiveresignationdate"];
    
        NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
        NSDictionary *dict;
        NSArray *keys=[NSArray arrayWithObjects:@"groupkey",@"leader",nil];
        NSArray *values;
        for (int i=0; i<workingStaff.grouparray.count; i++) {
            GroupMemberRecord *obj=[workingStaff.grouparray objectAtIndex:i];
            values=[NSArray arrayWithObjects:obj.groupkey,obj.leader?@"Yes":@"No", nil];
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
            
        }
        NSArray *jsongroupkeyarray = [NSArray arrayWithArray:arrayOfDicts];

        if ([action isEqualToString:@"Edit"]) {
            [dictionary setValue:staff.staffkey forKey:@"staffkey"];
            if ([self groupkeyupdated]) {
                [dictionary setValue:jsongroupkeyarray forKey:@"grouparray"];
            }
        }else{
            if (workingStaff.grouparray.count>0) {
                [dictionary setValue:jsongroupkeyarray forKey:@"grouparray"];
            }
        }

        __block BOOL result=FALSE;
        [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
            }
        }];



    return result;
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void) returnCalendarYear:(NSString *)year
{
    if([selectedItem isEqualToString:@"EffectiveResignationDate"]){
        [dateBackButton setTitle:year forState:UIControlStateNormal];
    }else{
        [backButton setTitle:year forState:UIControlStateNormal];
    }
}


-(void) getinstructoravailability
{
    instructoravailabilitydict=[[NSMutableDictionary alloc]init];
    classrecordsdict=[[NSMutableDictionary alloc]init];
    [MyClass getStaffAvailabilityWithUsername:workingStaff.username InstructorAvailabilityDict:instructoravailabilitydict ClassRecordsDict:classrecordsdict];
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    NSString *selecteddatestring=[selecteddatearray firstObject];
    
    if ([selectedItem isEqualToString:@"EffectiveResignationDate"]) {
        workingStaff.effectiveresignationdate=[MyClass convertDateFormatWithDate:selecteddatestring FromDateFormat:@"dd-MMMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        [StaffPopoverTable reloadData];
        [self adjusttablesize];
    }else{
        if(!endrepeatview.hidden){
            endrepeatdate=[MyClass convertDateFormatWithDate:[selecteddatearray firstObject] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
            [availabilityTable reloadData];
            [self cancelbuttonpressed:nil];
        }else if(!editButton.hidden){
            selectedDates=selecteddatearray;
            [self reloadMenuItems:selectButton];
        }else{
            selectedDates=selecteddatearray;
            [self reloadMenuItems:editButton];
            workingAvRecords=[self returnWorkingAvRecords:[selectedDates firstObject]];
            classRecords=[classrecordsdict valueForKey:[selectedDates firstObject]];
            [self retrieveStaffClassWithUsername:workingStaff.username ClassDate:[selectedDates firstObject]];
            [UIView transitionWithView:instructoravailabilityview duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                instructoravailabilityview.hidden = NO;
                repeatinterval=0;
                endrepeatdate=[selectedDates firstObject];
                [self updateAvailabilityTableRowArray];
                [availabilityTable reloadData];
            }completion:NULL];
        }
    }
}

-(void) reloadMenuItems:(UIButton *)button
{
    if (button==selectButton) {
        selectButton.hidden=YES;
        cancelButton.hidden=NO;
        editButton.hidden=NO;
        editButton.enabled=selectedDates.count>0?YES:NO;
        backButton.hidden=YES;
        backArrow.hidden=YES;
        doneButton.hidden=YES;
        menuTitle.hidden=NO;
        menuTitle.text=[self returnMenuTitle];
    }else if (button==cancelButton) {
        selectButton.hidden=[StaffTableMode isEqualToString:@"View"];
        cancelButton.hidden=YES;
        editButton.hidden=YES;
        backButton.hidden=NO;
        backArrow.hidden=NO;
        doneButton.hidden=YES;
        menuTitle.hidden=YES;
    }else if (button==editButton) {
        selectButton.hidden=YES;
        cancelButton.hidden=NO;
        editButton.hidden=YES;
        backButton.hidden=YES;
        backArrow.hidden=YES;
        doneButton.hidden=[StaffTableMode isEqualToString:@"View"];
        menuTitle.hidden=NO;
        menuTitle.text=[self returnMenuTitle];
    }else if (button==doneButton) {
        selectButton.hidden=NO;
        cancelButton.hidden=YES;
        editButton.hidden=YES;
        backButton.hidden=NO;
        backArrow.hidden=NO;
        doneButton.hidden=YES;
        menuTitle.hidden=YES;
    }else{// repeat and end repeat views
        selectButton.hidden=YES;
        cancelButton.hidden=NO;
        editButton.hidden=YES;
        backButton.hidden=YES;
        backArrow.hidden=YES;
        doneButton.hidden=YES;
        menuTitle.hidden=NO;
        menuTitle.text=[self returnMenuTitle];
    }
}

-(NSString *) returnMenuTitle
{
    if(!pickerview.hidden){
        return [MyClass returntitlewithtitle:@"Repeat"];
    }else if(!endrepeatview.hidden){
        return [MyClass returntitlewithtitle:@"End Repeat"];
    }else if(calendarview.multipleselection){
        if (selectedDates.count==0) {
            return [MyClass returntitlewithtitle:@"Select Dates"];
        }else if (selectedDates.count==1){
            return [MyClass returntitlewithtitle:@"1 Date Selected"];
        }else{
            return [MyClass returnreplacedtitlewithtitle:@"%@1 Dates Selected" replacementarray:@[[@(selectedDates.count) stringValue]]];
        }
    }else{
        return [MyClass convertDateFormatWithDate:[selectedDates firstObject] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"EEE dd-MMM-yyyy" Translate:YES];
    }
}

-(NSString *) returnRepeatIntervalText
{
    if (repeatinterval==0) {
        return @"Never";
    }else if (repeatinterval==1){
        return @"Every Day";
    }else{
        return @"Every Week";
    }
}

-(void) updateAvailability
{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    
    AvailabilityRecord *avrecordobject;
    
    //combine arrays
    
    [dictionary setValue:@"updatestaffavailability" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:workingStaff.username forKey:@"username"];
    [dictionary setValue:[selectedDates componentsJoinedByString:@","] forKey:@"dates"];
    [dictionary setValue:[self returnRepeatIntervalText] forKey:@"repeat"];
    if (repeatinterval!=0){
        [dictionary setValue:endrepeatdate forKey:@"endrepeat"];
    }
    
    keys=[NSArray arrayWithObjects:@"starttime",@"endtime",nil];
    
    //NSMutableArray *availabilityrecord=[instructoravailabilitydict valueForKey:selecteddate];
    
    for (int i=0; i<workingAvRecords.count; i++) {
        avrecordobject=[workingAvRecords objectAtIndex:i];
        values=[NSArray arrayWithObjects:avrecordobject.starttime,avrecordobject.endtime, nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    [dictionary setValue:arrayOfDicts forKey:@"availabilityrecords"];
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    __block BOOL result=FALSE;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",strResult);
            result=TRUE;
        }
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    if (!result) {
        [MyClass showconnectionlostdialogbox];
    }*/
}


-(NSMutableArray *) returnWorkingAvRecords:(NSString *)date
{
    AvailabilityRecord *avrecord;
    NSMutableArray *workingavrecords=[[NSMutableArray alloc]init];
    NSMutableArray *avrecords=[instructoravailabilitydict valueForKey:date];
    for (int i=0; i<avrecords.count; i++) {
        avrecord=[avrecords objectAtIndex:i];
        [workingavrecords addObject:[[AvailabilityRecord alloc]initAvailabilityRecordWithDate:avrecord.date StartTime:avrecord.starttime EndTime:avrecord.endtime]];
    }
    return workingavrecords;
}


-(void) returnTotalAvailabilityHourWithHourLabel:(UILabel *)hourlabel MinuteLabel:(UILabel *)minutelabel
{
    AvailabilityRecord *avrecord;
    NSMutableArray *summarizedrecords=[[NSMutableArray alloc]init];
    NSString *starttime;
    NSString *endtime;
    NSString *sstarttime;
    NSString *sendtime;
    BOOL add;
    
    
    for (int i=0; i<workingAvRecords.count; i++) {
        avrecord=[workingAvRecords objectAtIndex:i];
        starttime=avrecord.starttime;
        endtime=avrecord.endtime;
        add=TRUE;
        
        if (![starttime isEqualToString:endtime]) {
            for (int j=0; j<summarizedrecords.count; j++) {
                avrecord=[summarizedrecords objectAtIndex:j];
                sstarttime=avrecord.starttime;
                sendtime=avrecord.endtime;
                
                if([starttime floatValue] <=[sendtime floatValue] && [endtime floatValue] >=[sstarttime floatValue]){
                    if ([starttime floatValue]>=[sstarttime floatValue] && [endtime floatValue]<=[sendtime floatValue]){
                        //time already covered
                        add=FALSE;
                        break;
                    }else if([starttime floatValue]<=[sstarttime floatValue] && [endtime floatValue]>=[sendtime floatValue]){
                        //new cover full length
                        avrecord.date=@"skipped";
                    }else if ([starttime floatValue]<[sstarttime floatValue]){
                        //extend front
                        endtime= sendtime;
                        avrecord.date=@"skipped";
                    }else if ([endtime floatValue]>[sendtime floatValue]){
                        //extend end
                        starttime= sstarttime;
                        avrecord.date=@"skipped";
                    }
                }
            }
        }
        
        if(add){
            [summarizedrecords addObject:[[AvailabilityRecord alloc]initAvailabilityRecordWithDate:@"" StartTime:starttime EndTime:endtime]];
        }
        
    }
    
    
    
    NSInteger min=0;
    for (int i=0; i<summarizedrecords.count; i++) {
        avrecord=[summarizedrecords objectAtIndex:i];
        if (![avrecord.date isEqualToString:@"skipped"]) {
            min+=([[avrecord.endtime substringToIndex:2] integerValue]*60)+[[avrecord.endtime substringFromIndex:3] integerValue]-([[avrecord.starttime substringToIndex:2] integerValue]*60)-[[avrecord.starttime substringFromIndex:3] integerValue];
        }
    }
    
    
    hourlabel.text=[MyClass returnreplacedtitlewithtitle:@"%@1h" replacementarray:@[[@(min/60) stringValue]]];
    minutelabel.text=[MyClass returnreplacedtitlewithtitle:@"%@1m" replacementarray:@[[@(min%60) stringValue]]];
    minutelabel.hidden=(min%60==0);
}



- (IBAction)backbuttonpressed:(id)sender {
    [self closesidewindow];
}

- (IBAction)selectbuttonpressed:(id)sender {
    calendarview.multipleselection=YES;
    selectedDates=[[NSMutableArray alloc]init];
    [self reloadMenuItems:sender];
}

- (IBAction)cancelbuttonpressed:(id)sender {
    
    if (!pickerview.hidden) {
        [UIView transitionWithView:pickerview duration:0.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            pickerview.hidden = YES;
            [self reloadMenuItems:editButton];
        }completion:NULL];
    }else if (!endrepeatview.hidden) {
        [UIView transitionWithView:endrepeatview duration:0.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            endrepeatview.hidden = YES;
            [self reloadMenuItems:editButton];
        }completion:NULL];
    }else if (!instructoravailabilityview.hidden) {
        calendarview.multipleselection=NO;
        calendarview.selecteddatearray=[[NSMutableArray alloc]init];
        [calendarview reloadWithInstructorAvailability:instructoravailabilitydict ClassRecords:classrecordsdict];
        [self reloadMenuItems:sender];
        
        [UIView transitionWithView:instructoravailabilityview duration:0.15 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            instructoravailabilityview.hidden = YES;
            //[calendarview reload];
        }completion:NULL];
    }else{ //cancel select
        calendarview.multipleselection=NO;
        calendarview.selecteddatearray=[[NSMutableArray alloc]init];
        [calendarview reloadWithInstructorAvailability:instructoravailabilitydict ClassRecords:classrecordsdict];
        [self reloadMenuItems:sender];
    }
}

- (IBAction)donebuttonpressed:(id)sender {
    calendarview.multipleselection=NO;
    calendarview.selecteddatearray=[[NSMutableArray alloc]init];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateAvailability];
        [self getinstructoravailability];
        
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        
        [UIView transitionWithView:instructoravailabilityview duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            instructoravailabilityview.hidden = YES;
            [calendarview reloadWithInstructorAvailability:instructoravailabilitydict ClassRecords:classrecordsdict];
        } completion:NULL];
    });
    
    
    [self reloadMenuItems:sender];
}

- (IBAction)datenonebuttonpressed:(id)sender {
    workingStaff.effectiveresignationdate=@"";
    [StaffPopoverTable reloadData];
    [self showsidewindowwithwindow:@""];
    [self adjusttablesize];
}

- (IBAction)editbuttonpressed:(id)sender {
    [self reloadMenuItems:editButton];
    workingAvRecords=[[NSMutableArray alloc]init];
    classRecords=[[NSMutableArray alloc]init];
    [UIView transitionWithView:instructoravailabilityview duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        instructoravailabilityview.hidden = NO;
        [self updateAvailabilityTableRowArray];
        [availabilityTable reloadData];
    }completion:NULL];
}


-(void) retrieveStaffClassWithUsername:(NSString *)username ClassDate:(NSString *)classdate
{
    ScheduledClassRecordArray=[[NSMutableArray alloc] init];
    NSString *strURL;
    
    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievestaffclass&classdate=%@&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,classdate,username];
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *JSONArray = jsonreturned[@"content"];
            //Set up our class array
            
            for (int i=0; i<JSONArray.count; i++) {
                NSString * cclasstype=[[JSONArray objectAtIndex:i] objectForKey:@"classtype"];
                NSString * ctype=[[JSONArray objectAtIndex:i] objectForKey:@"type"];
                NSString * ctypekey=[[JSONArray objectAtIndex:i] objectForKey:@"typekey"];
                NSString * cclasstypekey=[[JSONArray objectAtIndex:i] objectForKey:@"classtypekey"];
                NSString * csubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString * cattendance=[[JSONArray objectAtIndex:i] objectForKey:@"attendance"];
                NSString * cduration=[[JSONArray objectAtIndex:i] objectForKey:@"duration"];
                NSString * cextendedminute=[[JSONArray objectAtIndex:i] objectForKey:@"extendedminute"];
                NSString *cstartdate = [MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"startdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                NSString * cclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                NSString * cinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
                NSString * cclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
                NSString * cmakeupattendance=[[JSONArray objectAtIndex:i] objectForKey:@"makeupattendance"];
                NSString * cmakeupdate=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"makeupdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                NSString * cmakeuptime=[[JSONArray objectAtIndex:i] objectForKey:@"makeuptime"];
                NSString * cmakeupinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"makeupinstructor"];
                NSString * cmakeupclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"makeupclassroom"];
                NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                NSString * callclassremarks=[[JSONArray objectAtIndex:i] objectForKey:@"allclassremarks"];
                NSString * cabsentmakeupreason=[[JSONArray objectAtIndex:i] objectForKey:@"absentmakeupreason"];
                NSString * cparentnote=[[JSONArray objectAtIndex:i] objectForKey:@"parentnote"];
                NSString * crequest_status=[[JSONArray objectAtIndex:i] objectForKey:@"request_status"];
                NSString * crequest_for_value=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_value"];
                NSString * crequest_for_leavenaturelistkey=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_leavenaturelistkey"];
                NSString * crequest_for_value_reason=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_value_reason"];
                NSString * crequest_for_date=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"request_for_date"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                NSString * crequest_for_time=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_time"];
                NSString * cleavenaturelistkey=[[JSONArray objectAtIndex:i] objectForKey:@"leavenaturelistkey"];
                
                [ScheduledClassRecordArray addObject:[[ClassRecord2 alloc]initClassWithclasstype:cclasstype type:ctype typekey:ctypekey classtypekey:cclasstypekey subject:csubject attendance:cattendance duration:cduration extendedminute:cextendedminute startdate:cstartdate classtime:cclasstime instructor:cinstructor classroom:cclassroom makeupattendance:cmakeupattendance makeupdate:cmakeupdate makeuptime:cmakeuptime makeupinstructor:cmakeupinstructor makeupclassroom:cmakeupclassroom remarks:cremarks allclassremarks:callclassremarks absentmakeupreason:cabsentmakeupreason parentnote:cparentnote request_status:crequest_status request_for_value:crequest_for_value request_for_leavenaturelistkey:crequest_for_leavenaturelistkey request_for_value_reason:crequest_for_value_reason request_for_date:crequest_for_date request_for_time:crequest_for_time leavenaturelistkey:cleavenaturelistkey]];
            }
        }
    }];
}

-(void) ccbuttonpressed:(UIButton *)sender
{
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:workingStaff.iso_code, nil] DataType:@"countrycode" DataIndex:0 ShowSearchBar:YES BottomMode:nil PreferredContentSize:CGSizeMake(220, 200) View:self Button:sender ItemsArray:nil Title:nil];
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"countrycode"]) {
        NSString *localnumber=[MyClass returnLocalNumberWithContact:workingStaff.phone ISOCode:workingStaff.iso_code];
        workingStaff.iso_code=[selecteditems firstObject];
        workingStaff.phone=[NSString stringWithFormat:@"%@%@",[MyClass returnCountryCodeWithISOCode:[selecteditems firstObject]],localnumber];
        
        [StaffPopoverTable reloadData];
    }
}

@end
