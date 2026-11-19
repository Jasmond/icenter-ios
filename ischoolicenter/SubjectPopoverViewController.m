//
//  SubjectPopoverViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 24/11/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import "SubjectPopoverViewController.h"
#import "MyClass.h"
#import "MyTableViewCell.h"
#import "MessagePhotoCollectionViewCell.h"
#import "SDWebImage.h"

@import Photos;
@import BSImagePicker;

@interface SubjectPopoverViewController ()

@end

@implementation SubjectPopoverViewController
@synthesize subjectobject,SubjectTableMode,SubjectRecordArray;

#define maxPopupHeight self.view.frame.size.height
#define kbPopupHeight 380
#define popoverwidth 320
#define courseschedulewidth 370
#define leveltuitiontablewidth 430
#define leveltuitiontablelongwidth 530
#define gradetuitiontablewidth 430
#define lessonnumbertablewidth 420
#define subjectcategorytablewidth 400
#define validitywidth 320
#define instructortablewidth 300
#define classroomtablewidth 300
#define classdatetablewidth 300
#define makeupwidth 320
#define chatbotsettingswidth 320
#define subjectphotowidth 400
#define messagephotowidth 400
#define chatbotcategorytablewidth 400
#define scheduleleveltablewidth 250
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]
#define autolevelupgradeoptiontablewidth 320
#define autolevelupgradevaluestablewdith 320

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    tmpgradearray=[NSMutableArray arrayWithArray:[((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).grade componentsSeparatedByString:@","]];
    
    
    [self InitializeField];
    allSubjectCategoryArray=[MyClass retrievesubjectcategorywithflushcachedata:NO];
    filteredSubjectCategoryArray=[[NSMutableArray alloc]initWithArray:allSubjectCategoryArray];
    
    
    [self createtables];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    tuitionobject=[[TuitionRecord alloc]init];
    

    
    standardnoofclassormontharray=[[NSMutableArray alloc]init];
    for (int i=1; i<=104; i++) {
        [standardnoofclassormontharray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    [MyClass getLatestDataSetv2withParameters:@"staff,classroom" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    
    InstructorArray=[MyClass filterInstructorArrayWithInstructorArray:[MyClass retrieveInstructorListwithvalid:@"All" flushcachedata:NO] Valid:@"Yes"];
    filteredcsInstructorArray=[[NSMutableArray alloc]initWithArray:InstructorArray];
    ClassroomArray=[MyClass retrieveClassroomListwithstatus:@"In Service" withTBD:YES flushcachedata:NO];
    filteredcsClassroomArray=[[NSMutableArray alloc]initWithArray:ClassroomArray];
    
    hourPickerViewMenu=[[NSMutableArray alloc]init];
    minutePickerViewMenu=[[NSMutableArray alloc]init];

    [MyClass loadHourPickerViewMenu:hourPickerViewMenu];
    for (int i=0; i<60; i+=[globalvariables.centerrecord.classtimeinterval intValue]) {
        [minutePickerViewMenu addObject:[NSString stringWithFormat:@"%02i",i]];
    }
    
    
    dayPickerViewMenu=[[NSMutableArray alloc]initWithObjects:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun", nil];

    // year array
    validityTypePickerViewMenu=[[NSMutableArray alloc]initWithObjects:@"Days",@"Weeks",@"Months",@"Years", nil];

    //month array
    validtyValuePickerViewMenu=[[NSMutableArray alloc]init];
    for (int i=1; i<366; i++) {
        [validtyValuePickerViewMenu addObject:[NSString stringWithFormat:@"%i",i]];
    }
    
    workingScheduleDetails=[[ScheduleDetailsRecord alloc]init];
    
    [editButton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
    [cloneButton setTitle:[MyClass returntitlewithtitle:@"Clone"] forState:UIControlStateNormal];
     [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
      [cancelButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    
//    [self createDateTableToolBar];
}

//-(void) createDateTableToolBar
//{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closelevelEffectiveDateTable) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [datetoolbar setItems:barItems];
//}

//-(void) closelevelEffectiveDateTable
//{
//    [self.view endEditing:YES];
//    [self showsidewindowwithwindow:@"none"];
////    [EnrollmentPopoverTable deselectRowAtIndexPath:[EnrollmentPopoverTable indexPathForSelectedRow] animated:YES];
//    [self adjusttablesize];
//}

-(void) createtables
{
    //Message Photo
    MessagePhotoMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth+chatbotsettingswidth, 0, subjectphotowidth, self.view.frame.size.height)];
    [self.view addSubview:MessagePhotoMasterView];

    
    fullscreen_scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 44+20, MessagePhotoMasterView.bounds.size.width, MessagePhotoMasterView.bounds.size.height-44-20)];
    fullscreen_scrollview.backgroundColor=[UIColor blackColor];
    fullscreen_scrollview.maximumZoomScale=7.0;
    fullscreen_scrollview.minimumZoomScale=1;
    fullscreen_scrollview.delegate=self;
    
    [MessagePhotoMasterView addSubview:fullscreen_scrollview];
    fullscreen_messageimageview=[[UIImageView alloc]init];
    fullscreen_messageimageview.backgroundColor=[UIColor whiteColor];
    fullscreen_messageimageview.contentMode=UIViewContentModeScaleAspectFit;
    [fullscreen_scrollview addSubview:fullscreen_messageimageview];
    fullscreen_scrollview.contentSize = fullscreen_messageimageview.frame.size;
    
    MessagePhotoToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, subjectphotowidth, 44)];
    [MessagePhotoMasterView addSubview:MessagePhotoToolBar];
    [self createMessagePhotoToolBar];
    
    
    photocloseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    photocloseButton.frame = CGRectMake(20, 33, 20, 20);
    [photocloseButton setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [photocloseButton addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [photocloseButton.heightAnchor constraintEqualToConstant:20].active = true;
    [photocloseButton.widthAnchor constraintEqualToConstant:20].active = true;
    
    [MessagePhotoMasterView addSubview:photocloseButton];
    
    photorotateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    photorotateButton.frame = CGRectMake(messagephotowidth-40, 33, 20, 20);
    [photorotateButton setImage:[UIImage imageNamed:@"rotatebutton_blue.png"] forState:UIControlStateNormal];
    [photorotateButton addTarget:self action:@selector(rotateimage) forControlEvents:UIControlEventTouchUpInside];
    [photorotateButton.heightAnchor constraintEqualToConstant:20].active = true;
    [photorotateButton.widthAnchor constraintEqualToConstant:20].active = true;
    
    [MessagePhotoMasterView addSubview:photorotateButton];
    
    photoshareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    photoshareButton.frame = CGRectMake(messagephotowidth-40, 33, 20, 20);
    [photoshareButton setImage:[UIImage imageNamed:@"photosharebutton_blue.png"] forState:UIControlStateNormal];
    [photoshareButton addTarget:self action:@selector(shareimage:) forControlEvents:UIControlEventTouchUpInside];
    [photoshareButton.heightAnchor constraintEqualToConstant:20].active = true;
    [photoshareButton.widthAnchor constraintEqualToConstant:20].active = true;
    
    [MessagePhotoMasterView addSubview:photoshareButton];
    
    
    
    SubjectPopoverTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    SubjectPopoverTable.dataSource=self;
    SubjectPopoverTable.delegate=self;
    SubjectToolBar.clipsToBounds=YES;
    SubjectPopoverTable.sectionHeaderHeight=0;
    SubjectPopoverTable.sectionFooterHeight=0;
    
    //[SubjectPopoverTable reloadData];
    [self adjusttablesize];
    [self.view addSubview:SubjectPopoverTable];
    
    
    //course schedule table
    CourseScheduleMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, courseschedulewidth+400, self.view.frame.size.height)];
    [self.view addSubview:CourseScheduleMasterView];
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20+44, courseschedulewidth,88)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [CourseScheduleMasterView addSubview:headerView];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Course Schedule Records"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    CourseScheduleTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+88+20, courseschedulewidth, self.view.frame.size.height-88-20-44) style:UITableViewStyleGrouped];
    CourseScheduleTable.sectionHeaderHeight=0;
    CourseScheduleTable.dataSource=self;
    CourseScheduleTable.delegate=self;
    
    //[CourseScheduleTable reloadData];
    [CourseScheduleMasterView addSubview:CourseScheduleTable];
    
    CourseScheduleToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, courseschedulewidth, 44)];
    CourseScheduleToolBar.clipsToBounds=YES;
    [CourseScheduleMasterView addSubview:CourseScheduleToolBar];
    
    coursescheduletablesearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, courseschedulewidth, 42)];
    coursescheduletablesearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    coursescheduletablesearchbar.searchBarStyle=UISearchBarStyleMinimal;
    coursescheduletablesearchbar.delegate=self;
    [headerView addSubview:coursescheduletablesearchbar];
    
    //leveltuition table
    LevelTuitionTable.sectionHeaderHeight=CGFLOAT_MIN;
    LevelTuitionTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, globalvariables.centerrecord.jumptonextlevelduringrenewal?leveltuitiontablelongwidth:leveltuitiontablewidth, 44)];
    LevelTuitionTableToolBar.clipsToBounds=YES;
    [LevelTuitionMasterView addSubview:LevelTuitionTableToolBar];
    
    //gradetuition table
    GradeTuitionTable.sectionHeaderHeight=CGFLOAT_MIN;
    GradeTuitionTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, gradetuitiontablewidth, 44)];
    GradeTuitionTableToolBar.clipsToBounds=YES;
    [GradeTuitionMasterView addSubview:GradeTuitionTableToolBar];
    
    //Validity table
    ValidityTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, validitywidth, self.view.frame.size.height)];
    [self.view addSubview:ValidityTableMasterView];
    
    ValidityTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, validitywidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    ValidityTable.dataSource=self;
    ValidityTable.delegate=self;
    ValidityTable.scrollEnabled=NO;
    
    [ValidityTableMasterView addSubview:ValidityTable];
    
    ValidityTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, validitywidth, 44)];
    ValidityTableToolBar.clipsToBounds=YES;
    [ValidityTableMasterView addSubview:ValidityTableToolBar];
    [self createValidityTableToolBar];
    
    //Makeup table
    MakeupTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, makeupwidth, self.view.frame.size.height)];
    [self.view addSubview:MakeupTableMasterView];
    MakeupTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, makeupwidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    MakeupTable.dataSource=self;
    MakeupTable.delegate=self;
    MakeupTable.scrollEnabled=NO;
    [MakeupTableMasterView addSubview:MakeupTable];
    MakeupTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, makeupwidth, 44)];
    MakeupTableToolBar.clipsToBounds=YES;
    [MakeupTableMasterView addSubview:MakeupTableToolBar];
    [self createMakeupTableToolBar];
    
    
    //Color Code table
    ColorCodeTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, makeupwidth, self.view.frame.size.height)];
    [self.view addSubview:ColorCodeTableMasterView];
    ColorCodeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, makeupwidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    ColorCodeTable.dataSource=self;
    ColorCodeTable.delegate=self;
    [ColorCodeTableMasterView addSubview:ColorCodeTable];
    ColorCodeTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, makeupwidth, 44)];
    ColorCodeTableToolBar.clipsToBounds=YES;
    [ColorCodeTableMasterView addSubview:ColorCodeTableToolBar];
    [self createColorCodeTableToolBar];
    
    UILabel *separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth, 0, 1, self.view.frame.size.height)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
    
    noschedulerecordlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-15, courseschedulewidth, 30)];
    noschedulerecordlabel.text=[MyClass returntitlewithtitle:@"No Schedule Record"];
    noschedulerecordlabel.textColor=[UIColor grayColor];
    noschedulerecordlabel.font=[UIFont systemFontOfSize:17];
    noschedulerecordlabel.textAlignment=NSTextAlignmentCenter;
    noschedulerecordlabel.hidden=YES;
    [CourseScheduleMasterView addSubview:noschedulerecordlabel];
    
    addschedulerecordlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-15, courseschedulewidth, 30)];
    addschedulerecordlabel.text=[MyClass returntitlewithtitle:@"Tap above to add record"];
    addschedulerecordlabel.textColor=[UIColor grayColor];
    addschedulerecordlabel.font=[UIFont systemFontOfSize:17];
    addschedulerecordlabel.textAlignment=NSTextAlignmentCenter;
    addschedulerecordlabel.hidden=YES;
    [CourseScheduleMasterView addSubview:addschedulerecordlabel];
    
    addleveltuitionrecordlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height/2-15, leveltuitiontablewidth, 30)];
    addleveltuitionrecordlabel.text=[MyClass returntitlewithtitle:@"Tap above to add record"];
    addleveltuitionrecordlabel.textColor=[UIColor grayColor];
    addleveltuitionrecordlabel.font=[UIFont systemFontOfSize:17];
    addleveltuitionrecordlabel.textAlignment=NSTextAlignmentCenter;
    addleveltuitionrecordlabel.hidden=YES;
    [LevelTuitionMasterView addSubview:addleveltuitionrecordlabel];
    
    
    //CS Instructor table
    csInstructorTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth+courseschedulewidth, 20+44, instructortablewidth, self.view.frame.size.height-20-44)];
    [self.view addSubview:csInstructorTableMasterView];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, instructortablewidth,88)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [csInstructorTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Instructor"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    csSelectInstructorButton=[[UIButton alloc]initWithFrame:CGRectMake(instructortablewidth-35, 12, 30, 30)];
    [csSelectInstructorButton setImage:[UIImage imageNamed:@"instructoricon.png"] forState:UIControlStateNormal];
    [csSelectInstructorButton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    [csSelectInstructorButton addTarget: self action:@selector(InstructorButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
    //[headerView addSubview:csSelectInstructorButton];
    
    
    csinstructortablesearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, instructortablewidth, 42)];
    csinstructortablesearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    csinstructortablesearchbar.searchBarStyle=UISearchBarStyleMinimal;
    csinstructortablesearchbar.delegate=self;
    [headerView addSubview:csinstructortablesearchbar];
    
    csInstructorTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 88, instructortablewidth, self.view.frame.size.height-44-88-20) style:UITableViewStyleGrouped];
    csInstructorTable.delegate=self;
    csInstructorTable.dataSource=self;
    csInstructorTable.sectionHeaderHeight=0;
    [csInstructorTableMasterView addSubview:csInstructorTable];
    

    
    //CS Classroom table
    csClassroomTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth+courseschedulewidth, 20+44, classroomtablewidth, self.view.frame.size.height-20-44)];
    [self.view addSubview:csClassroomTableMasterView];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, classroomtablewidth,88)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [csClassroomTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Classroom"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    csclassroomtablesearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, instructortablewidth, 42)];
    csclassroomtablesearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    csclassroomtablesearchbar.searchBarStyle=UISearchBarStyleMinimal;
    csclassroomtablesearchbar.delegate=self;
    [headerView addSubview:csclassroomtablesearchbar];
    
    csClassroomTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 88, classroomtablewidth, self.view.frame.size.height-44-88-20) style:UITableViewStyleGrouped];
    csClassroomTable.delegate=self;
    csClassroomTable.dataSource=self;
    csClassroomTable.sectionHeaderHeight=0;
    [csClassroomTableMasterView addSubview:csClassroomTable];

    
    //class date
    csClassDateTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth+courseschedulewidth, 20+44, classdatetablewidth, self.view.frame.size.height-20-44)];
    [self.view addSubview:csClassDateTableMasterView];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, classdatetablewidth,44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [csClassDateTableMasterView addSubview:headerView];
    csClassDateHeaderLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    csClassDateHeaderLabel.font=[UIFont systemFontOfSize:13];
    csClassDateHeaderLabel.textColor=[UIColor grayColor];
    [headerView addSubview:csClassDateHeaderLabel];
    
    
    UIButton *csResetClassDateButton=[[UIButton alloc]initWithFrame:CGRectMake(instructortablewidth-40, 12, 30, 30)];
    [csResetClassDateButton setImage:[UIImage imageNamed:@"closescreen_blue"] forState:UIControlStateNormal];
    [csResetClassDateButton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [csResetClassDateButton addTarget: self action:@selector(ResetClassDateButtonPressed) forControlEvents: UIControlEventTouchUpInside];
    [headerView addSubview:csResetClassDateButton];
    
    
    csClassDateTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, classdatetablewidth, self.view.frame.size.height-44-44-20) style:UITableViewStyleGrouped];
    csClassDateTable.dataSource=self;
    csClassDateTable.delegate=self;
    csClassDateTable.scrollEnabled=false;
    csClassDateTable.sectionHeaderHeight=0;
    [csClassDateTable reloadData];
    
    [csClassDateTableMasterView addSubview:csClassDateTable];
    
    //Day Date Time
    csDayDateTimeTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth+courseschedulewidth, 20+44, classdatetablewidth, self.view.frame.size.height-20-44)];
    [self.view addSubview:csDayDateTimeTableMasterView];
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, classdatetablewidth,44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [csDayDateTimeTableMasterView addSubview:headerView];
    csDayDateTimeHeaderLabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    csDayDateTimeHeaderLabel.font=[UIFont systemFontOfSize:13];
    csDayDateTimeHeaderLabel.textColor=[UIColor grayColor];
    [headerView addSubview:csDayDateTimeHeaderLabel];
    
    csDayDateTimeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, classdatetablewidth, self.view.frame.size.height-44-44-20) style:UITableViewStyleGrouped];
    csDayDateTimeTable.dataSource=self;
    csDayDateTimeTable.delegate=self;
    csDayDateTimeTable.scrollEnabled=false;
    csDayDateTimeTable.sectionHeaderHeight=0;
    [csDayDateTimeTable reloadData];
    
    [csDayDateTimeTableMasterView addSubview:csDayDateTimeTable];
    
    //add separator
    separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth+courseschedulewidth, 20+44, 1, self.view.bounds.size.height-20-44)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
    
    //category table
    SubjectCategoryMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, subjectcategorytablewidth, self.view.frame.size.height)];
    [self.view addSubview:SubjectCategoryMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, subjectcategorytablewidth,44+44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [SubjectCategoryMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Category"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    subjectcategorysearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, subjectcategorytablewidth, 42)];
    subjectcategorysearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    subjectcategorysearchbar.delegate=self;
    subjectcategorysearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:subjectcategorysearchbar];
    
    SubjectCategoryTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84+20+4, subjectcategorytablewidth, self.view.frame.size.height-44-84-20-4) style:UITableViewStyleGrouped];
    SubjectCategoryTable.dataSource=self;
    SubjectCategoryTable.delegate=self;
    SubjectCategoryTable.sectionHeaderHeight=0;
    [SubjectCategoryTable reloadData];
    [SubjectCategoryMasterView addSubview:SubjectCategoryTable];
    
    SubjectCategoryTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, subjectcategorytablewidth, 44)];
    SubjectCategoryTableToolBar.clipsToBounds=YES;
    [SubjectCategoryMasterView addSubview:SubjectCategoryTableToolBar];
    [self createSubjectCategoryTableToolBar];
    
    separator=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 1, SubjectCategoryMasterView.frame.size.height-20)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [SubjectCategoryMasterView addSubview:separator];
    
//    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, scheduleleveltablewidth,88)];
//    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
//    [ScheduleLevelMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Makeup Level"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [scheduleLevelHeaderView addSubview:label];
    
    [schedulelevelallbutton setTitle:[MyClass returntitlewithtitle:@"All"] forState:UIControlStateNormal];
    [schedulelevelnonebutton setTitle:[MyClass returntitlewithtitle:@"None"] forState:UIControlStateNormal];
    
    
    schedulelevelsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, scheduleleveltablewidth, 42)];
    schedulelevelsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    schedulelevelsearchbar.delegate=self;
    schedulelevelsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [scheduleLevelHeaderView addSubview:schedulelevelsearchbar];
    ScheduleLevelTable.sectionHeaderHeight=0;
    
    
    
    [self.view bringSubviewToFront:lessonNumberTableMasterView];
    lessonNumberTable.sectionHeaderHeight=CGFLOAT_MIN;
    [self createLessonNumberToolBar];
    
    [self.view bringSubviewToFront:MessagePhotoMasterView];
    
    [self.view bringSubviewToFront:chatBotSettingsMasterView];
    chatBotSettingsTable.sectionHeaderHeight=CGFLOAT_MIN;
    [self createChatBotSettingsToolBar];
    
    [self.view bringSubviewToFront:LevelTuitionMasterView];
    [self.view bringSubviewToFront:GradeTuitionMasterView];
    
    [self.view bringSubviewToFront:ScheduleLevelMasterView];
    
    [self.view bringSubviewToFront:AutoLevelUpgradeMasterView];
    
//    [self.view bringSubviewToFront:CourseScheduleToolBar];
    
    levelEffectiveDateTable.scrollEnabled=false;
    levelEffectiveDateTable.sectionHeaderHeight=0;
    
    gradeEffectiveDateTable.scrollEnabled=false;
    gradeEffectiveDateTable.sectionHeaderHeight=0;
    
    separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth, 0, 1, self.view.frame.size.height)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
}

-(void) createMessagePhotoToolBar
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
////    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//
//    
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 25, 25);
//    [button setImage:[UIImage imageNamed:@"rotatebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(rotateimage) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:25].active = true;
//    [button.widthAnchor constraintEqualToConstant:25].active = true;
//    UIBarButtonItem *rotateButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 25, 25);
//    [button setImage:[UIImage imageNamed:@"photosharebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(shareimage:) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:25].active = true;
//    [button.widthAnchor constraintEqualToConstant:25].active = true;
//    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    photoshareButton.hidden=YES;
    photorotateButton.hidden=YES;
    
    if ([SubjectTableMode isEqualToString:@"View"]) {
//        barItems = [[NSMutableArray alloc]initWithObjects:flexSpace,shareButton, nil];
        photoshareButton.hidden=NO;
    }else{
//        barItems = [[NSMutableArray alloc]initWithObjects:flexSpace,rotateButton, nil];
        photorotateButton.hidden=NO;
    }
//    [MessagePhotoToolBar setItems:barItems];
}

-(void) ResetClassDateButtonPressed{
    if ([selectedItem isEqualToString:@"CSStartDate"]){
        workingSchedule.startdate=@"";
    }else{
        workingSchedule.enddate=@"";
    }
    showcsClassDateTable=NO;
    [CourseScheduleTable reloadData];
    [self adjusttablesize];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)keyboardDidHide: (NSNotification *) notification
{
    // Do something here
    keyboardheight=0;
    ////[self storeTmpField];
    [self adjusttablesize];
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    ////[self storeTmpField];
    [self adjusttablesize];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    ////[self storeTmpField];
    [self adjusttablesize];
    
}


-(void) createViewBarButton{

//    UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//    UIBarButtonItem *cloneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Clone"] style:UIBarButtonItemStylePlain target:self action:@selector(cloneButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    NSArray *buttons =[NSArray arrayWithObjects:cloneButton,flexibleSpaceBarButton,editButton,nil];
//    [SubjectToolBar setItems:buttons animated:NO];
    
    editButton.hidden=NO;
    cloneButton.hidden=NO;
    cloneButton.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).addsubject;
    cancelButton.hidden=YES;
    doneButton.hidden=YES;
    
    
    editButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject || ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).edituserschedule || ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editmakeupsettings;

}

-(void) createEditBarButton{
//    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:cancelButton,flexibleSpaceBarButton,doneButton,nil];
//    [SubjectToolBar setItems:buttons animated:NO];
    
    editButton.hidden=YES;
    cloneButton.hidden=YES;
    cancelButton.hidden=NO;
    doneButton.hidden=NO;
    
}

-(void) createAddBarButton{
    
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,doneButton,nil];
//    [SubjectToolBar setItems:buttons animated:NO];
    
    editButton.hidden=YES;
    cloneButton.hidden=YES;
    cancelButton.hidden=YES;
    doneButton.hidden=NO;
    
}


-(void) createCourseScheduleToolBarwithMode:(NSString *)mode
{
    [self removeButtonsWithView:CourseScheduleMasterView];
    
    
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if ([mode isEqualToString:@"View"]){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, 33, 20, 20);
        button.tag=3027;
        [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
        [button.heightAnchor constraintEqualToConstant:20].active = true;
        [button.widthAnchor constraintEqualToConstant:20].active = true;
        [CourseScheduleMasterView addSubview:button];
        
        if ([SubjectTableMode isEqualToString:@"Add"] || ([SubjectTableMode isEqualToString:@"Edit"] && (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).edituserschedule))) {
            
            button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(20, 33, 100, 20);
            button.tag=3027;
            [button setTitle:[MyClass returntitlewithtitle:@"Add Course Schedule"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(addschedulerecord) forControlEvents:UIControlEventTouchUpInside];
            [button sizeToFit];
            button.frame = CGRectMake(courseschedulewidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
            [CourseScheduleMasterView addSubview:button];
            
            
            
        }
    }else if([mode isEqualToString:@"Add"]){

        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, 33, 100, 20);
        button.tag=3027;
        [button setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(canceladdschedule) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.frame = CGRectMake(20, 33, button.frame.size.width, 20);
        [CourseScheduleMasterView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, 33, 100, 20);
        button.tag=3027;
        [button setTitle:[MyClass returntitlewithtitle:@"Save"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(doneaddschedule) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.frame = CGRectMake(courseschedulewidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
        [CourseScheduleMasterView addSubview:button];
        
        
    }else if ([mode isEqualToString:@"Edit"]){
//        UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(canceleditschedule)];
//        UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Save"] style:UIBarButtonItemStylePlain target:self action:@selector(doneeditschedule)];
//        barItems = [[NSMutableArray alloc]initWithObjects:cancelButton,flexSpace,doneButton, nil];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, 33, 100, 20);
        button.tag=3027;
        [button setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(canceleditschedule) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.frame = CGRectMake(20, 33, button.frame.size.width, 20);
        [CourseScheduleMasterView addSubview:button];
        
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, 33, 100, 20);
        button.tag=3027;
        [button setTitle:[MyClass returntitlewithtitle:@"Save"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(doneeditschedule) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.frame = CGRectMake(courseschedulewidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
        [CourseScheduleMasterView addSubview:button];
        
    }
    
//    [CourseScheduleToolBar setItems:barItems];
}

-(void) createLevelTuitionToolBar
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
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"addbuttonblue_icon.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(addleveltuition) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self removeButtonsWithView:LevelTuitionTableToolBar];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 13, 20, 20);
    button.tag=3027;
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [LevelTuitionMasterView addSubview:button];
    

    
    

    if ([SubjectTableMode isEqualToString:@"View"] || ([SubjectTableMode isEqualToString:@"Edit"] && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject)) {
    }else{
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(leveltuitiontablewidth-20-20, 13, 20, 20);
        button.tag=3027;
        [button setImage:[UIImage imageNamed:@"addbuttonblue_icon.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addleveltuition) forControlEvents:UIControlEventTouchUpInside];
        [button.heightAnchor constraintEqualToConstant:20].active = true;
        [button.widthAnchor constraintEqualToConstant:20].active = true;
        
        [LevelTuitionMasterView addSubview:button];
        
    }
    
//    [LevelTuitionTableToolBar setItems:barItems];
    
    [LevelTuitionTable setEditing:[SubjectTableMode isEqualToString:@"View"]?NO:YES animated:YES];
}

-(void) createLessonNumberToolBar
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
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"addbuttonblue_icon.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(addLessonNumberButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    [self removeButtonsWithView:lessonNumberTableMasterView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 13, 20, 20);
    button.tag=3027;
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [lessonNumberTableMasterView addSubview:button];
    
    

    if ([SubjectTableMode isEqualToString:@"View"] || ([SubjectTableMode isEqualToString:@"Edit"] && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject)) {
//        barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
    }else{
//        barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,addButton, nil];
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(leveltuitiontablewidth-20-20, 13, 20, 20);
        button.tag=3027;
        [button setImage:[UIImage imageNamed:@"addbuttonblue_icon.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addLessonNumberButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [button.heightAnchor constraintEqualToConstant:20].active = true;
        [button.widthAnchor constraintEqualToConstant:20].active = true;
        
        [lessonNumberTableMasterView addSubview:button];
        
    }
    
//    [lessonNumberTableToolBar setItems:barItems];
    
    [lessonNumberTable setEditing:[SubjectTableMode isEqualToString:@"View"]?NO:YES animated:YES];
}

-(void) createChatBotSettingsToolBar
{
    [self removeButtonsWithView:chatBotSettingsMasterView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 13, 20, 20);
    button.tag=3027;
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [chatBotSettingsMasterView addSubview:button];
    
    
}

-(void) createAutoLevelUpgradeViewToolBar
{
    [self removeButtonsWithView:AutoLevelUpgradeMasterView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 13, 20, 20);
    button.tag=3027;
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [AutoLevelUpgradeMasterView addSubview:button];
    
    
}

-(void) createGradeTuitionToolBar
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
//    [GradeTuitionTableToolBar setItems:barItems];
    
    [self removeButtonsWithView:GradeTuitionMasterView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 13, 20, 20);
    button.tag=3027;
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [GradeTuitionMasterView addSubview:button];
}

-(void) createValidityTableToolBar
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
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 25, 25);
//    [button setImage:[UIImage imageNamed:@"infinity_icon.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(setValidityToForever) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:25].active = true;
//    [button.widthAnchor constraintEqualToConstant:25].active = true;
//    UIBarButtonItem *foreverButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,foreverButton, nil];
//    [ValidityTableToolBar setItems:barItems];
    
    
    [self removeButtonsWithView:ValidityTableMasterView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    button.tag=3027;
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [ValidityTableMasterView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(validitywidth-20-20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"infinity_icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(setValidityToForever) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [ValidityTableMasterView addSubview:button];
}

-(void) createMakeupTableToolBar
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
//    [MakeupTableToolBar setItems:barItems];
    
    [self removeButtonsWithView:MakeupTableMasterView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    button.tag=3027;
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [MakeupTableMasterView addSubview:button];
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
    
    [self removeButtonsWithView:ColorCodeTableMasterView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    button.tag=3027;
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [ColorCodeTableMasterView addSubview:button];
}


-(void) createSubjectCategoryTableToolBar
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
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"addbuttonblue_icon.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(addsubjectcategory) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    [self removeButtonsWithView:SubjectCategoryMasterView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(subjectcategorytablewidth-20- 20, 33, 20, 20);
    button.tag=3027;
    [button setImage:[UIImage imageNamed:@"addbuttonblue_icon.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addsubjectcategory) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [SubjectCategoryMasterView addSubview:button];
    
    if(showChatBotCategoryTable){
//        barItems = [[NSMutableArray alloc]initWithObjects:flexSpace,addButton, nil];
    }else{
        
        button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, 33, 20, 20);
        button.tag=3027;
        [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
        [button.heightAnchor constraintEqualToConstant:20].active = true;
        [button.widthAnchor constraintEqualToConstant:20].active = true;
        
        [SubjectCategoryMasterView addSubview:button];
        
//        barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,addButton, nil];
    }
//    [SubjectCategoryTableToolBar setItems:barItems];
}

-(void) setValidityToForever
{
    workingSubject.validity=@"";
    ValidityLabel.text=[MyClass returnvaliditylabelwithvaliditystring:workingSubject.validity];
    [self showsidewindowwithwindow:@""];
    [self adjusttablesize];
}

-(void) addsubjectcategory
{
    UIView *addsubjectcategoryview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 500, 300)];
    addsubjectcategoryview.backgroundColor=[UIColor whiteColor];
    
    workingCategory=[[SubjectCategoryRecord alloc]init];
    workingCategory.colorcode=0;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, addsubjectcategoryview.frame.size.width-40, 60)];
    label.font=[UIFont boldSystemFontOfSize:18];
    label.textColor=[UIColor blackColor];
    label.text=[MyClass returntitlewithtitle:@"Add New Course Category"];
    [addsubjectcategoryview addSubview:label];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(20, 50, addsubjectcategoryview.frame.size.width-40, 45)];
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor grayColor];
    label.text=[MyClass returntitlewithtitle:@"Please enter category name in English and Chinese"];
    [addsubjectcategoryview addSubview:label];
    
    UIButton *addbutton =[[UIButton alloc]initWithFrame:CGRectMake(addsubjectcategoryview.frame.size.width-100-20,addsubjectcategoryview.frame.size.height-35-15,100,35)];
    [addbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [addbutton setTitle:[MyClass returntitlewithtitle:@"Add"] forState:UIControlStateNormal];
    addbutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    addbutton.backgroundColor=[UIColor whiteColor];
    addbutton.layer.borderWidth=1;
    addbutton.layer.cornerRadius=4;
    addbutton.layer.masksToBounds=YES;
    addbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    addbutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [addbutton addTarget: self action:@selector(addsubjectcategoryaddbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [addbutton addTarget: self action:@selector(addsubjectcategorybuttonhighlightcolor:) forControlEvents: UIControlEventTouchDown];
    [addbutton addTarget: self action:@selector(addsubjectcategorybuttonresetcolor:) forControlEvents: UIControlEventTouchCancel];
    [addbutton addTarget: self action:@selector(addsubjectcategorybuttonresetcolor:) forControlEvents: UIControlEventTouchUpOutside];
    
    UIButton *cancelbutton =[[UIButton alloc]initWithFrame:CGRectMake(addsubjectcategoryview.frame.size.width-100-20-100-10,addsubjectcategoryview.frame.size.height-35-15,100,35)];
    [cancelbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelbutton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    cancelbutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    cancelbutton.backgroundColor=[UIColor whiteColor];
    cancelbutton.layer.borderWidth=1;
    cancelbutton.layer.cornerRadius=4;
    cancelbutton.layer.masksToBounds=YES;
    cancelbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    cancelbutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [cancelbutton addTarget: self action:@selector(addsubjectcategorycancelbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [cancelbutton addTarget: self action:@selector(addsubjectcategorybuttonhighlightcolor:) forControlEvents: UIControlEventTouchDown];
    [cancelbutton addTarget: self action:@selector(addsubjectcategorybuttonresetcolor:) forControlEvents: UIControlEventTouchCancel];
    [cancelbutton addTarget: self action:@selector(addsubjectcategorybuttonresetcolor:) forControlEvents: UIControlEventTouchUpOutside];
    
    subjectcategoryenglishnametext=[[UITextField alloc]initWithFrame:CGRectMake(20, 100, addsubjectcategoryview.frame.size.width-40, 35)];
    subjectcategoryenglishnametext.font=[UIFont systemFontOfSize:15];
    subjectcategoryenglishnametext.textColor=[UIColor darkGrayColor];
    subjectcategoryenglishnametext.backgroundColor=[UIColor whiteColor];
    subjectcategoryenglishnametext.layer.cornerRadius=4;
    subjectcategoryenglishnametext.layer.masksToBounds=YES;
    subjectcategoryenglishnametext.adjustsFontSizeToFitWidth=YES;
    subjectcategoryenglishnametext.minimumFontSize=0.7;
    subjectcategoryenglishnametext.layer.borderColor=[UIColor lightGrayColor].CGColor;
    subjectcategoryenglishnametext.layer.borderWidth=0.6;
    subjectcategoryenglishnametext.placeholder=[MyClass returntitlewithtitle:@"Category name in English"];
    subjectcategoryenglishnametext.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
    [subjectcategoryenglishnametext setLeftViewMode:UITextFieldViewModeAlways];
    [subjectcategoryenglishnametext setLeftView:spacerView];

    subjectcategorychinesenametext=[[UITextField alloc]initWithFrame:CGRectMake(20, 150, addsubjectcategoryview.frame.size.width-40, 35)];
    subjectcategorychinesenametext.font=[UIFont systemFontOfSize:15];
    subjectcategorychinesenametext.textColor=[UIColor darkGrayColor];
    subjectcategorychinesenametext.backgroundColor=[UIColor whiteColor];
    subjectcategorychinesenametext.layer.cornerRadius=4;
    subjectcategorychinesenametext.layer.masksToBounds=YES;
    subjectcategorychinesenametext.adjustsFontSizeToFitWidth=YES;
    subjectcategorychinesenametext.minimumFontSize=0.7;
    subjectcategorychinesenametext.layer.borderColor=[UIColor lightGrayColor].CGColor;
    subjectcategorychinesenametext.layer.borderWidth=0.6;
    subjectcategorychinesenametext.placeholder=[MyClass returntitlewithtitle:@"Category name in Chinese"];
    subjectcategorychinesenametext.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
    [subjectcategorychinesenametext setLeftViewMode:UITextFieldViewModeAlways];
    [subjectcategorychinesenametext setLeftView:spacerView];
    
    colorcodelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 198, 28, 21)];
    colorcodelabel.layer.cornerRadius=5;
    colorcodelabel.layer.masksToBounds=true;
    colorcodelabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:workingCategory.colorcode];
    
    UIButton *colorcodebutton=[[UIButton alloc]initWithFrame:colorcodelabel.frame];
    [colorcodebutton addTarget:self action:@selector(subjectcategorycolorcodebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(0, addbutton.frame.origin.y-15, addsubjectcategoryview.frame.size.width, 65)];
    separator.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [addsubjectcategoryview addSubview:separator];
    
    [addsubjectcategoryview addSubview:subjectcategoryenglishnametext];
    [addsubjectcategoryview addSubview:subjectcategorychinesenametext];
    [addsubjectcategoryview addSubview:colorcodelabel];
    [addsubjectcategoryview addSubview:colorcodebutton];
    [addsubjectcategoryview addSubview:addbutton];
    [addsubjectcategoryview addSubview:cancelbutton];
    
    bundleforapppaymentbutton = [[UISwitch alloc] init];
    bundleforapppaymentbutton.onTintColor=themecolor;
    CGSize switchSize = [bundleforapppaymentbutton sizeThatFits:CGSizeZero];
    bundleforapppaymentbutton.frame = CGRectMake(20+subjectcategorychinesenametext.frame.size.width-switchSize.width, colorcodebutton.frame.origin.y+colorcodebutton.frame.size.height/2-switchSize.height/2,switchSize.width,switchSize.height);
    bundleforapppaymentbutton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    bundleforapppaymentbutton.tag = 501;
    bundleforapppaymentbutton.on=subjectcategoryobject.bundleforapppayment;
//    [bundleforapppaymentbutton addTarget:self action:@selector(switchbundleforapppayment:) forControlEvents:UIControlEventValueChanged];
    [addsubjectcategoryview addSubview:bundleforapppaymentbutton];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(20, 50, addsubjectcategoryview.frame.size.width-40, 45)];
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor grayColor];
    label.text=[MyClass returntitlewithtitle:@"Bundle for app payment"];
    [label sizeToFit];
    label.frame=CGRectMake(subjectcategorychinesenametext.frame.size.width-label.frame.size.width+20-switchSize.width-10, colorcodebutton.frame.origin.y+colorcodebutton.frame.size.height/2-label.frame.size.height/2, label.frame.size.width, label.frame.size.height);
    [addsubjectcategoryview addSubview:label];
    
    
    addsubjectcategoryviewcontroller=[[UIViewController alloc]init];
    addsubjectcategoryviewcontroller.preferredContentSize=CGSizeMake(500, 300);
    addsubjectcategoryviewcontroller.view=addsubjectcategoryview;
    
    addsubjectcategoryviewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
    addsubjectcategoryviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[self presentViewController:addsubjectcategoryviewcontroller animated:YES completion: nil];
    [MyClass presentViewController:addsubjectcategoryviewcontroller View:self];
}

-(void) addsubjectcategorycancelbuttonpressed:(UIButton *)sender
{
    [self.view endEditing:YES];
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [addsubjectcategoryviewcontroller dismissViewControllerAnimated:YES completion:nil];
}

-(void) updatesubjectcategorycancelbuttonpressed:(UIButton *)sender
{
    [self.view endEditing:YES];
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [addsubjectcategoryviewcontroller dismissViewControllerAnimated:YES completion:nil];
}

-(void) addsubjectcategoryaddbuttonpressed:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view endEditing:YES];
    if ([subjectcategoryenglishnametext.text isEqualToString:@""] && [subjectcategorychinesenametext.text isEqualToString:@""]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Subject Category"] message:[MyClass returntitlewithtitle:@"Category name is missing"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [addsubjectcategoryviewcontroller presentViewController:erroralert animated:YES completion:nil];
    }else if ([self isCategoryNameDuplicatedWithSelfSCategorykey:nil]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Subject Category"] message:[MyClass returntitlewithtitle:@"Category name already exists"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [addsubjectcategoryviewcontroller presentViewController:erroralert animated:YES completion:nil];
    }else{

        
        //combine arrays
        NSDictionary *dictionary = @{@"englishname" : [subjectcategoryenglishnametext.text isEqualToString:@""]?subjectcategorychinesenametext.text:subjectcategoryenglishnametext.text,
                                     @"chinesename" : [subjectcategorychinesenametext.text isEqualToString:@""]?subjectcategoryenglishnametext.text:subjectcategorychinesenametext.text,
                                     @"centerdb" : globalvariables.centerrecord.centerdb,
                                     @"centerkey" : globalvariables.centerrecord.centerkey,
                                     @"colorcode" : [@(workingCategory.colorcode) stringValue],
                                     @"bundleforapppayment" : bundleforapppaymentbutton.isOn?@"Yes":@"No",
                                     @"postaction" : @"insertsubjectcategory"
                                     };
        
        __block BOOL result=FALSE;
        __block NSString *newcategorykey;
        [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                NSMutableArray * JSONArray = jsonreturned[@"content"];
                
                newcategorykey= [[JSONArray objectAtIndex:0] objectForKey:@"scategorykey"];
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
        __block NSString *newcategorykey;
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            //NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (!error) {
                result=TRUE;
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                NSMutableArray * JSONArray = jsonreturned[@"content"];
                
                newcategorykey= [[JSONArray objectAtIndex:0] objectForKey:@"scategorykey"];
            }
            dispatch_semaphore_signal(semaphore);
        }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
        
        if(result){
            workingSubject.subject_category= newcategorykey;
            allSubjectCategoryArray=[MyClass retrievesubjectcategorywithflushcachedata:YES];
            filteredSubjectCategoryArray=[[NSMutableArray alloc]initWithArray:allSubjectCategoryArray];
            subjectcategorysearchbar.text=@"";
            [SubjectPopoverTable reloadData];
            [SubjectCategoryTable reloadData];
            [addsubjectcategoryviewcontroller dismissViewControllerAnimated:YES completion:nil];
        }else{
            [MyClass showconnectionlostdialogbox];
        }
    }
}


-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyClass returntitlewithtitle:@"Delete"];
}

-(BOOL) isCategoryNameDuplicatedWithSelfSCategorykey:(NSString *)scategorykey
{
    NSString *english_name_input;
    NSString *chinese_name_input;
    
    if ([subjectcategoryenglishnametext.text isEqualToString:@""]) {
        chinese_name_input=subjectcategorychinesenametext.text;
        english_name_input=chinese_name_input;
    }else if ([subjectcategorychinesenametext.text isEqualToString:@""]){
        english_name_input=subjectcategoryenglishnametext.text;
        chinese_name_input=english_name_input;
    }
    
    for (int i=0; i<allSubjectCategoryArray.count; i++) {
        if ([((SubjectCategoryRecord *)[allSubjectCategoryArray objectAtIndex:i]).englishname isEqualToString:english_name_input] || [((SubjectCategoryRecord *)[allSubjectCategoryArray objectAtIndex:i]).chinesename isEqualToString:chinese_name_input]) {
            if (![((SubjectCategoryRecord *)[allSubjectCategoryArray objectAtIndex:i]).scategorykey isEqualToString:scategorykey]) {
                return TRUE;
            }
        }
    }
    
    return FALSE;
}


-(void) addleveltuition
{
//    [workingSubject.levelArray addObject:@""];
    [workingSubject.levelArray addObject:[[LevelRecord alloc]initLevelRecordwithLevel:@"" earlieststartdate:@""]];
    if ([workingSubject.tuition_method isEqualToString:@"Level"]) {
        [workingSubject.tuitionArray addObject:[[TuitionRecord alloc]initTuitionRecordwithSubject_Shortname:workingSubject.subject_shortname Method:workingSubject.tuition_method Scale:@"" TuitionFee:@"" newtuitionfee:@"" effectivedate:@""]];
    }
    [LevelTuitionTable reloadData];
    //workingSubject.tuition_method=[NSString stringWithFormat:@"%d",[tmpNoOfLevel intValue]+1];
    [SubjectPopoverTable reloadData];
    
    addleveltuitionrecordlabel.hidden=YES;
    if (LevelTuitionTable.contentSize.height>LevelTuitionTable.frame.size.height) {
        [LevelTuitionTable setContentOffset:CGPointMake(0, LevelTuitionTable.contentSize.height-LevelTuitionTable.frame.size.height)];
    }
    
    
}
/*
-(void)closescheduleview
{
    
    selectedItem=@"CourseSchedule";
    CourseTableMode=@"View";
    
    //[self storeTmpField];
    showCourseSchedule=NO;
    showcsInstructorPicker=NO;
    showcsClassroomPicker=NO;
    showcsClasstimePicker=NO;
    [self adjusttablesize];
    [SubjectPopoverTable reloadData];
    //[CourseScheduleTable reloadData];
    

    
    
    
}*/

-(void) closesidewindow
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [SubjectPopoverTable deselectRowAtIndexPath:[SubjectPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) addschedulerecord
{
    CourseTableMode=@"Add";
    [self InitializeCSField];
    [self createCourseScheduleToolBarwithMode:CourseTableMode];
    [CourseScheduleTable reloadData];
    addschedulerecordlabel.hidden=YES;
    [self adjusttablesize];
    
}



-(void) cloneschedulebuttonpressed:(UIButton *)sender
{
    cseditindex=sender.tag;
    CourseTableMode=@"Clone";
    [self InitializeCSField];
    [self createCourseScheduleToolBarwithMode:CourseTableMode];
    [CourseScheduleTable reloadData];
    [self adjusttablesize];
    addschedulerecordlabel.hidden=YES;
}

-(void) doneaddschedule
{
    showcsInstructorTable=NO;
    showcsClassroomTable=NO;
    showcsClassDateTable=NO;
    showcsDayDateTimeTable=NO;
    showScheduleLevelTable=NO;
    tmptestcstimearray=[[NSMutableArray alloc]initWithArray:[self filtercstimearray:workingSchedule.daytimearray]];
    if ([self checkscheduleinput]) {
        [workingSubject.scheduleArray addObject:[[ScheduleRecord alloc]initScheduleRecordwithScheduleKey:@"" Name:workingSchedule.name AutoRenew:workingSchedule.autorenew DayTimeArray:tmptestcstimearray Action:@"Add" StartDate:workingSchedule.startdate EndDate:workingSchedule.enddate makeupschedule:workingSchedule.makeupschedule active:workingSchedule.active type:workingSchedule.type showintimetableifnoenrollment:workingSchedule.showintimetableifnoenrollment onlinetrialschedule:workingSchedule.onlinetrialschedule levelarray:workingSchedule.levelarray]];
        [self sortWorkingScheduleArray];
        CourseTableMode=@"View";
        [self createCourseScheduleToolBarwithMode:CourseTableMode];
        [self returnFilteredScheduleArray];
        [CourseScheduleTable reloadData];
        
        //tmpCourseSchedule=[self returndetailschedulearraycount];
        [SubjectPopoverTable reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection: 2];
        [SubjectPopoverTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    [self adjusttablesize];
}

-(void) sortWorkingScheduleArray
{
    NSSortDescriptor *sortbyname = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[sortbyname];
    workingSubject.scheduleArray = [NSMutableArray arrayWithArray:[workingSubject.scheduleArray sortedArrayUsingDescriptors:sortDescriptors]];
}

- (BOOL) checkscheduleinput
{
    if ([ScheduleNameText.text isEqualToString:@""]) {
        UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Add Course Schedule"] message:[MyClass returntitlewithtitle:@"Please input Schedule's name"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missinginput dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missinginput addAction:OKAction];
        //[self presentViewController:missinginput animated:YES completion:nil];
        [MyClass presentViewController:missinginput View:self];
        return NO;
        
    }else if (tmptestcstimearray.count==0){
        UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Add Course Schedule"] message:[MyClass returntitlewithtitle:@"Please select at least one class time"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missinginput dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missinginput addAction:OKAction];
        //[self presentViewController:missinginput animated:YES completion:nil];
        [MyClass presentViewController:missinginput View:self];
        return NO;
    }
    return YES;
}

-(void) doneeditschedule
{
    showcsInstructorTable=NO;
    showcsClassroomTable=NO;
    showcsClassDateTable=NO;
    tmptestcstimearray=[[NSMutableArray alloc]initWithArray:[self filtercstimearray:workingSchedule.daytimearray]];
    if ([self checkscheduleinput]) {
        ((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).name=workingSchedule.name;
        ((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).daytimearray=tmptestcstimearray;
        ((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).autorenew=workingSchedule.autorenew;
        //((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).instructor=[workingSchedule.instructor isEqualToString:@""]?@"TBD":workingSchedule.instructor;
        //((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).classroom=[workingSchedule.classroom isEqualToString:@""]?@"TBD":workingSchedule.classroom;
        ((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).startdate=workingSchedule.startdate;
        ((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).enddate=workingSchedule.enddate;
        ((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).makeupschedule=workingSchedule.makeupschedule;
        ((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).active=workingSchedule.active;
        ((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).type=workingSchedule.type;
        ((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).showintimetableifnoenrollment=workingSchedule.showintimetableifnoenrollment;
        ((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).onlinetrialschedule=workingSchedule.onlinetrialschedule;
        ((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).levelarray=workingSchedule.levelarray?[[NSMutableArray alloc]initWithArray:workingSchedule.levelarray]:nil;
        
        if ([((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).action isEqualToString:@""]) {
            ((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).action=@"Edit";
        }
        
        CourseTableMode=@"View";
        [self sortWorkingScheduleArray];
        [self InitializeCSField];
        [self createCourseScheduleToolBarwithMode:CourseTableMode];
        [self returnFilteredScheduleArray];
        [CourseScheduleTable reloadData];
    }
    [self adjusttablesize];
    
    //workingSchedule.daytimearray=[self filtercstimearray:workingSchedule.daytimearray];
}

-(void) deleteScheduleRecord
{
    if ([self isScheduleBeingUsed:((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).schedulekey]) {
        UIAlertController *deletealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Schedule Record"] message:[MyClass returntitlewithtitle:@"This schedule has been used and can only be disabled"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        [deletealert addAction:OKAction];
        //[deletealert addAction:CancelAction];
        
        //[self presentViewController:deletealert animated:YES completion:nil];
        [MyClass presentViewController:deletealert View:self];
        
    }else{
        if ([((ScheduleRecord *)[self->filteredScheduleArray objectAtIndex:self->cseditindex]).action isEqualToString:@""]) {
            ((ScheduleRecord *)[self->filteredScheduleArray objectAtIndex:self->cseditindex]).action=@"Delete";
        }else if ([((ScheduleRecord *)[self->filteredScheduleArray objectAtIndex:self->cseditindex]).action isEqualToString:@"Add"]) {
            [self->filteredScheduleArray removeObjectAtIndex:self->cseditindex];
        }else if ([((ScheduleRecord *)[self->filteredScheduleArray objectAtIndex:self->cseditindex]).action isEqualToString:@"Edit"]) {
            ((ScheduleRecord *)[self->filteredScheduleArray objectAtIndex:self->cseditindex]).action=@"Delete";
        }
        
        self->CourseTableMode=@"View";
        [self InitializeCSField];
        [self createCourseScheduleToolBarwithMode:self->CourseTableMode];
        [self returnFilteredScheduleArray];
        [self->CourseScheduleTable reloadData];
        [self adjusttablesize];
        
        //tmpCourseSchedule=[self returndetailschedulearraycount];
        [self->SubjectPopoverTable reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection: 2];
        [self->SubjectPopoverTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    


}


-(NSMutableArray *) filtercstimearray:(NSMutableArray *)cstimearray
{
    NSArray *days = @[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun"];
    NSMutableArray *resultarray=[[NSMutableArray alloc]init];
    NSMutableArray *datetimecheckarray=[[NSMutableArray alloc]init];
    NSString *datetime;
    ScheduleDetailsRecord *object;
    for(int i=0;i<cstimearray.count;i++){
        object=[cstimearray objectAtIndex:i];
        if(![object.dayofweek isEqualToString:@""]){
            datetime=[NSString stringWithFormat:@"%@%@",object.dayofweek,object.classtime];
            if(![datetimecheckarray containsObject:datetime]){
                if ([workingSchedule.type isEqualToString:@"Recursive"]) {
                    object.dayofweek=[@([days indexOfObject:object.dayofweek]) stringValue];
                }
                [resultarray addObject:object];
                [datetimecheckarray addObject:datetime];
            }
        }
    }
    
    //sort
    if(resultarray.count>1){
        NSSortDescriptor *sortByDayOfWeek = [NSSortDescriptor sortDescriptorWithKey:@"dayofweek" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSSortDescriptor *sortByClassTime = [NSSortDescriptor sortDescriptorWithKey:@"classtime" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = @[sortByDayOfWeek, sortByClassTime];
        resultarray = [NSMutableArray arrayWithArray:[resultarray sortedArrayUsingDescriptors:sortDescriptors]];
    }
    
    for(int i=0;i<resultarray.count;i++){
        object=[resultarray objectAtIndex:i];
        if ([workingSchedule.type isEqualToString:@"Recursive"]) {
            object.dayofweek=[days objectAtIndex:[object.dayofweek integerValue]];
        }
    }
    
    
    return resultarray;
    
    /*
    NSMutableArray *monarray=[[NSMutableArray alloc]init];
    NSMutableArray *tuearray=[[NSMutableArray alloc]init];
    NSMutableArray *wedarray=[[NSMutableArray alloc]init];
    NSMutableArray *thuarray=[[NSMutableArray alloc]init];
    NSMutableArray *friarray=[[NSMutableArray alloc]init];
    NSMutableArray *satarray=[[NSMutableArray alloc]init];
    NSMutableArray *sunarray=[[NSMutableArray alloc]init];
    
    for (int i=0; i<cstimearray.count; i++) {
        if (![((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).mon isEqualToString:@""]) {
            if (![monarray containsObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).mon]) {
                [monarray addObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).mon];
            }
        }

        if (![((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).tue isEqualToString:@""]) {
            if (![tuearray containsObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).tue]) {
            [tuearray addObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).tue];
            }
        }
        
        if (![((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).wed isEqualToString:@""]) {
            if (![wedarray containsObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).wed]) {
            [wedarray addObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).wed];
            }
        }
        
        if (![((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).thu isEqualToString:@""]) {
            if (![thuarray containsObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).thu]) {
            [thuarray addObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).thu];
            }
        }
        
        if (![((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).fri isEqualToString:@""]) {
            if (![friarray containsObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).fri]) {
            [friarray addObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).fri];
            }
        }
        
        if (![((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).sat isEqualToString:@""]) {
            if (![satarray containsObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).sat]) {
            [satarray addObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).sat];
            }
        }
        
        if (![((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).sun isEqualToString:@""]) {
            if (![sunarray containsObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).sun]) {
            [sunarray addObject:((ScheduleDayRecord *)[cstimearray objectAtIndex:i]).sun];
            }
        }
    }
    
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES];
    monarray=[NSMutableArray arrayWithArray:[monarray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
    tuearray=[NSMutableArray arrayWithArray:[tuearray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
    wedarray=[NSMutableArray arrayWithArray:[wedarray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
    thuarray=[NSMutableArray arrayWithArray:[thuarray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
    friarray=[NSMutableArray arrayWithArray:[friarray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
    satarray=[NSMutableArray arrayWithArray:[satarray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
    sunarray=[NSMutableArray arrayWithArray:[sunarray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
    
    NSArray *numberarray=[[NSArray alloc]initWithObjects:[NSNumber numberWithLong:monarray.count],[NSNumber numberWithLong:tuearray.count],[NSNumber numberWithLong:wedarray.count],[NSNumber numberWithLong:thuarray.count],[NSNumber numberWithLong:friarray.count],[NSNumber numberWithLong:satarray.count],[NSNumber numberWithLong:sunarray.count], nil];
    int maxnumber=[[numberarray valueForKeyPath:@"@max.self"] intValue];
    
    NSMutableArray *resultarray=[[NSMutableArray alloc]init];
    
    for (int i=0; i<maxnumber; i++) {
        [resultarray addObject:[[ScheduleDayRecord alloc]initScheduleDayRecordwithmon:i>=monarray.count?@"":[monarray objectAtIndex:i] tue:i>=tuearray.count?@"":[tuearray objectAtIndex:i] wed:i>=wedarray.count?@"":[wedarray objectAtIndex:i] thu:i>=thuarray.count?@"":[thuarray objectAtIndex:i] fri:i>=friarray.count?@"":[friarray objectAtIndex:i] sat:i>=satarray.count?@"":[satarray objectAtIndex:i] sun:i>=sunarray.count?@"":[sunarray objectAtIndex:i]]];
    }
    return resultarray;*/
}



-(void) canceladdschedule
{
    CourseTableMode=@"View";
    [self InitializeCSField];
    [self createCourseScheduleToolBarwithMode:CourseTableMode];
    //[self showsidewindowwithwindow:@"showCourseSchedule"];
    [CourseScheduleTable reloadData];
    [self adjusttablesize];
}

-(void) canceleditschedule
{
    
    CourseTableMode=@"View";
    showcsClassDateTable=NO;
    showcsClassroomTable=NO;
    showcsInstructorTable=NO;
    showcsDayDateTimeTable=NO;
    showScheduleLevelTable=NO;
    [self InitializeCSField];
    [self createCourseScheduleToolBarwithMode:CourseTableMode];
    [CourseScheduleTable reloadData];
    [self adjusttablesize];
}


-(IBAction) editButtonPressed:(id)sender{
    SubjectTableMode=@"Edit";
    [self createEditBarButton];
    [self InitializeField];
    [self closeallpickers];
    [self closesidewindow];

    [SubjectPopoverTable reloadData];
    if (showCourseSchedule) {
        CourseTableMode=@"View";
        [self InitializeCSField];
        [self createCourseScheduleToolBarwithMode:CourseTableMode];
        [CourseScheduleTable reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection: 2];
        [SubjectPopoverTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else if (showLevelTuitionTable){
        [self createLevelTuitionToolBar];
        [LevelTuitionTable reloadData];
    }else if (showGradeTuitionTable){
        [self createGradeTuitionToolBar];
        [GradeTuitionTable reloadData];
    }else if (showMakeupTable){
        [MakeupTable reloadData];
    }else if (showLessonNumberTable){
        [self createLessonNumberToolBar];
        [lessonNumberTable reloadData];
    }else if (showChatBotSettingsTable){
        if(showSubjectPhoto){
            [self createMessagePhotoToolBar];
        }
        [chatBotSettingsTable reloadData];
    }
    
    [self adjusttablesize];
}

-(IBAction) cloneButtonPressed:(id)sender{
    
    SubjectTableMode=@"Clone";
    [self createAddBarButton];
    [self InitializeField];
    
    [SubjectPopoverTable reloadData];
    if (showCourseSchedule) {
        CourseTableMode=@"View";
        [self InitializeCSField];
        [self createCourseScheduleToolBarwithMode:CourseTableMode];
        [CourseScheduleTable reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection: 2];
        [SubjectPopoverTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else if (showLevelTuitionTable){
        [self createLevelTuitionToolBar];
        [LevelTuitionTable reloadData];
    }else if (showGradeTuitionTable){
        [self createGradeTuitionToolBar];
        [GradeTuitionTable reloadData];
    }else if (showGradeTuitionTable){
        [self createMakeupTableToolBar];
        [MakeupTable reloadData];
    }
    [self adjusttablesize];
}

-(IBAction) cancelButtonPressed:(id)sender{
    
    SubjectTableMode=@"View";
    [self createViewBarButton];
    [self InitializeField];
    showSubjectCategoryTable=FALSE;
    [SubjectPopoverTable reloadData];
    if (showCourseSchedule) {
        CourseTableMode=@"View";
        [self InitializeCSField];
        [self createCourseScheduleToolBarwithMode:CourseTableMode];
        [CourseScheduleTable reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection: 2];
        [SubjectPopoverTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else if(showLevelTuitionTable){
        [self createLevelTuitionToolBar];
        [LevelTuitionTable reloadData];
    }else if(showGradeTuitionTable){
        if ([workingSubject.tuition_method isEqualToString:@"Grade"]) {
            [self createGradeTuitionToolBar];
            [GradeTuitionTable reloadData];
        }else{
            [self showsidewindowwithwindow:@""];
        }
    }else if (showValidity){
        [self showsidewindowwithwindow:@""];
    }else if(showMakeupTable){
        [MakeupTable reloadData];
    }else if(showLessonNumberTable){
        [self createLessonNumberToolBar];
        [lessonNumberTable reloadData];
    }else if (showChatBotSettingsTable){
        [chatBotSettingsTable reloadData];
        if(showSubjectPhoto){
            [self createMessagePhotoToolBar];
        }
    }
    [self adjusttablesize];
}

-(void) closeallpickers
{
    showStudentCapacityPicker=NO;
    showClassDurationPicker=NO;
    showClassDurationTrialPicker=NO;
    showClassDurationAssessmentPicker=NO;
    showTuitionModePicker=NO;
    showTuitionMethodPicker=NO;
    showStandardPeriodPicker=NO;
//    showmakeup_quotaPicker=NO;
    showTrialCapacityPicker=NO;
    showPregenPeriodPicker=NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==lessonNumberTable) {
        return YES;
    }
    return NO;
}

//- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
//{
//    if( sourceIndexPath.section != proposedDestinationIndexPath.section )
//    {
//        return sourceIndexPath;
//    }
//    else
//    {
//        return proposedDestinationIndexPath;
//    }
//}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    //do whatever u want after row has been moved
    if (tableView==lessonNumberTable) {
        if (toIndexPath.section==0 && (fromIndexPath.row !=toIndexPath.row)) {
            
            NSMutableArray *lessonarray=workingSubject.lessonnumberDict[lessonnumbertype];
            
            NSString *description=[lessonarray objectAtIndex:fromIndexPath.row];
            [lessonarray removeObjectAtIndex:fromIndexPath.row];
            [lessonarray insertObject:description atIndex:toIndexPath.row];
            [lessonNumberTable reloadData];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==SubjectPopoverTable) {
        if ([SubjectTableMode isEqualToString:@"View"]) {
            return 10;
        }else if ([SubjectTableMode isEqualToString:@"Edit"]) {
            return 11;
        }else{
            return 10;
        }
    }else if (tableView==CourseScheduleTable) {//course schedule table
        if ([CourseTableMode isEqualToString:@"Edit"]){
            return 2;
        }
    }else if (tableView==MakeupTable){
        return 3;
    }else if (tableView==chatBotSettingsTable){
        return 5;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==SubjectPopoverTable) {
        if ([SubjectTableMode isEqualToString:@"View"]) {
            if (section==0) {
                return 5;
            }else if (section==1){
                return 10;
            }else if (section==2){
                return 2;
            }else if (section==3){
                return 1;
            }else if (section==4){
                return 1;
            }else if (section==5){
                return 1;
            }else if (section==6){
                return showGradeTuition?1:0;
            }else if (section==7){
                return globalvariables.centerrecord.lessonnumbermode==2?2:1;
            }else if (section==8){
                return globalvariables.centerrecord.enablechatbot?1:0;
            }else{
                return 1;
            }
        }else if ([SubjectTableMode isEqualToString:@"Edit"]) {
            if (section==0) {
                return 5;
            }else if (section==1){
                return 18;
            }else if (section==2){
                return 2;
            }else if (section==3){
                return 1;
            }else if (section==4){
                return 1;
            }else if (section==5){
                return 1;
            }else if (section==6){
                return showGradeTuition?1:0;
            }else if (section==7){
                return globalvariables.centerrecord.lessonnumbermode==2?2:1;
            }else if (section==8){
                return globalvariables.centerrecord.enablechatbot?1:0;
            }else{
                return 1;
            }
        }else{
            if (section==0) {
                return 5;
            }else if (section==1){
                return 18;
            }else if (section==2){
                return 2;
            }else if (section==3){
                return 1;
            }else if (section==4){
                return 1;
            }else if (section==5){
                return 1;
            }else if (section==6){
                return showGradeTuition?1:0;
            }else if (section==7){
                return globalvariables.centerrecord.lessonnumbermode==2?2:1;
            }else if (section==8){
                return globalvariables.centerrecord.enablechatbot?1:0;
            }else{
                return 1;
            }
        }
    }else if (tableView==LevelTuitionTable){
        return workingSubject.levelArray.count;
    }else if (tableView==GradeTuitionTable){
        return ![workingSubject.tuition_method isEqualToString:@"Grade"]?0:tmpgradearray.count;
    }else if (tableView==SubjectCategoryTable){
        return filteredSubjectCategoryArray.count;
    }else if (tableView==ValidityTable){
        return 1;
    }else if (tableView==csInstructorTable){
        return filteredcsInstructorArray.count;
    }else if (tableView==csClassroomTable){
        return filteredcsClassroomArray.count;
    }else if (tableView==csClassDateTable){
        return 1;
    }else if (tableView==levelEffectiveDateTable){
        return 1;
    }else if (tableView==gradeEffectiveDateTable){
        return 1;
    }else if (tableView==ColorCodeTable){
        return globalvariables.colorcodearray.count;
    }else if (tableView==MakeupTable){
        if([SubjectTableMode isEqualToString:@"View"]|| ([SubjectTableMode isEqualToString:@"Edit"] && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editmakeupsettings)){
            if(section==0){
                return 1;
            }else if (section==1){
                return 3;
            }else{
                return 8;
            }
        }else{
            if(section==0){
                return 2;
            }else if (section==1){
                return 3;
            }else{
                return 8;
            }
        }
    }else if (tableView==csDayDateTimeTable){
        return 1;
    }else if (tableView==CourseScheduleTable){
        if ([CourseTableMode isEqualToString:@"View"]) {
            return filteredScheduleArray.count;
        }else if ([CourseTableMode isEqualToString:@"Edit"]){
            if (section==0) {
                return 12;
            }else{
                return 1;
            }
        }else{
            return 12;
        }
    }else if (tableView==lessonNumberTable){
        NSMutableArray *notesetarray=workingSubject.lessonnumberDict[lessonnumbertype];
        if(notesetarray){
            return notesetarray.count;
        }
    }else if (tableView==chatBotSettingsTable){
        if(section==0){
            return 2;
        }else if (section==4){
            return 5;
        }
        return 1;
    }else if (tableView==ScheduleLevelTable){
        return filteredScheduleLevelArray.count;
    }else if (tableView==autoLevelUpgradeOptionTable){
        return 3;
    }else if (tableView==autoLevelUpgradeValuesTable){
        return 12;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView==LevelTuitionTable){
        UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        header.backgroundColor=[UIColor systemGroupedBackgroundColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
        label.text=[[MyClass returntitlewithtitle:@"Level and Tuition"] uppercaseString];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor grayColor];
        [header addSubview:label];
        
        if(!showGradeTuition){
            if (globalvariables.centerrecord.jumptonextlevelduringrenewal) {
                label=[[UILabel alloc]initWithFrame:CGRectMake(215, 14, 200, 32)];
                label.text=[[MyClass returntitlewithtitle:@"Scheduled Change"] uppercaseString];
                label.font=[UIFont systemFontOfSize:13];
                label.textColor=[UIColor grayColor];
                [header addSubview:label];
                
                label=[[UILabel alloc]initWithFrame:CGRectMake(408, 14, 200, 32)];
                label.text=[[MyClass returntitlewithtitle:@"Earliest Start"] uppercaseString];
                label.font=[UIFont systemFontOfSize:13];
                label.textColor=[UIColor grayColor];
                [header addSubview:label];
            }else{
                label=[[UILabel alloc]initWithFrame:CGRectMake(234, 14, 200, 32)];
                label.text=[[MyClass returntitlewithtitle:@"Scheduled Change"] uppercaseString];
                label.font=[UIFont systemFontOfSize:13];
                label.textColor=[UIColor grayColor];
                [header addSubview:label];
            }
        }else{
            if (globalvariables.centerrecord.jumptonextlevelduringrenewal) {
                label=[[UILabel alloc]initWithFrame:CGRectMake(408, 14, 200, 32)];
                label.text=[[MyClass returntitlewithtitle:@"Earliest Start"] uppercaseString];
                label.font=[UIFont systemFontOfSize:13];
                label.textColor=[UIColor grayColor];
                [header addSubview:label];
            }
        }
        
        return header;
    }else if(tableView==GradeTuitionTable){
        UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
        header.backgroundColor=[UIColor systemGroupedBackgroundColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
        label.text=[[MyClass returntitlewithtitle:@"Grade and Tuition"] uppercaseString];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor grayColor];
        [header addSubview:label];
        
        label=[[UILabel alloc]initWithFrame:CGRectMake(210, 14, 200, 32)];
        label.text=[[MyClass returntitlewithtitle:@"Scheduled Change"] uppercaseString];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor grayColor];
        [header addSubview:label];
        
        return header;
    }
    

        
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==SubjectPopoverTable) {
        if ([SubjectTableMode isEqualToString:@"View"]) {
            if (section==0) {
                return [MyClass returntitlewithtitle:@"Subject Name"];
            }else if (section==1){
                return [MyClass returntitlewithtitle:@"Details"];
            }else if (section==2){
                return [MyClass returntitlewithtitle:@"Enrollment"];
            }else if (section==3){
                return [MyClass returntitlewithtitle:@"Makeup"];
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Course Schedule"];
            }else if (section==5){
                if (showGradeTuition) {
                    return [MyClass returntitlewithtitle:@"Level"];
                }else{
                    return [MyClass returntitlewithtitle:@"Level and Tuition"];
                }
            }else if (section==6){
                if (showGradeTuition) {
                    return [MyClass returntitlewithtitle:@"Grade and Tuition"];
                }else{
                    return nil;
                }
            }else if (section==7){
                if (globalvariables.centerrecord.enablelessonnumber) {
                    return [MyClass returntitlewithtitle:@"Lesson Plan"];
                }
            }else if (section==8){
                if (globalvariables.centerrecord.enablechatbot) {
                    return [MyClass returntitlewithtitle:@"Chatbot"];
                }
            }else{
                return [MyClass returntitlewithtitle:@"Remarks"];
            }
        }else if ([SubjectTableMode isEqualToString:@"Edit"]) {
            if (section==0) {
                return [MyClass returntitlewithtitle:@"Subject Name"];
            }else if (section==1){
                return [MyClass returntitlewithtitle:@"Details"];
            }else if (section==2){
                return [MyClass returntitlewithtitle:@"Enrollment"];
            }else if (section==3){
                return [MyClass returntitlewithtitle:@"Makeup"];
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Course Schedule"];
            }else if (section==5){
                if (showGradeTuition) {
                    return [MyClass returntitlewithtitle:@"Level"];
                }else{
                    return [MyClass returntitlewithtitle:@"Level and Tuition"];
                }
            }else if (section==6){
                if (showGradeTuition) {
                    return [MyClass returntitlewithtitle:@"Grade and Tuition"];
                }else{
                    return nil;
                }
                
            }else if (section==7){
                if (globalvariables.centerrecord.enablelessonnumber) {
                    return [MyClass returntitlewithtitle:@"Lesson Plan"];
                }
            }else if (section==8){
                if (globalvariables.centerrecord.enablechatbot) {
                    return [MyClass returntitlewithtitle:@"Chatbot"];
                }
            }else if (section==9){
                return [MyClass returntitlewithtitle:@"Remarks"];
            }else{
                return @" ";
            }
        }else{
            if (section==0) {
                return [MyClass returntitlewithtitle:@"Subject Name"];
            }else if (section==1){
                return [MyClass returntitlewithtitle:@"Details"];
            }else if (section==2){
                return [MyClass returntitlewithtitle:@"Enrollment"];
            }else if (section==3){
                return [MyClass returntitlewithtitle:@"Makeup"];
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Course Schedule"];
            }else if (section==5){
                if (showGradeTuition) {
                    return [MyClass returntitlewithtitle:@"Level"];
                }else{
                    return [MyClass returntitlewithtitle:@"Level and Tuition"];
                }
            }else if (section==6){
                if (showGradeTuition) {
                    return [MyClass returntitlewithtitle:@"Grade and Tuition"];
                }
            }else if (section==7){
                if (globalvariables.centerrecord.enablelessonnumber) {
                    return [MyClass returntitlewithtitle:@"Lesson Plan"];
                }
            }else if (section==8){
                if (globalvariables.centerrecord.enablechatbot) {
                    return [MyClass returntitlewithtitle:@"Chatbot"];
                }
            }else{
                return [MyClass returntitlewithtitle:@"Remarks"];
            }
        }
    }else if (tableView==LevelTuitionTable){
        if (showGradeTuition) {
            return workingSubject.levelArray.count==0?nil:[MyClass returntitlewithtitle:@"Level"];
        }else{
            return workingSubject.levelArray.count==0?nil:[MyClass returntitlewithtitle:@"Level and Tuition"];
        }
    }else if (tableView==GradeTuitionTable){
        return [MyClass returntitlewithtitle:@"Grade and Tuition"];
    }else if (tableView==ValidityTable){
        return [MyClass returntitlewithtitle:@"Validity"];
    }else if (tableView==ColorCodeTable){
        return [MyClass returntitlewithtitle:@"Subject Color"];
    }else if (tableView==CourseScheduleTable){//course schedule table
        if ([CourseTableMode isEqualToString:@"View"]) {
            return nil;//[[self returndetailschedulearraycount] isEqualToString:@"0"]?nil:[MyClass returntitlewithtitle:@"Course Schedule Records"];
        }else if ([CourseTableMode isEqualToString:@"Edit"]){
            if (section==0) {
                return [MyClass returntitlewithtitle:@"Edit Course Schedule"];;
            }else{
                return [MyClass returntitlewithtitle:@"Delete Course Schedule"];;
            }
        }else{
            return [MyClass returntitlewithtitle:@"Add Course Schedule"];
        }
    }else if (tableView==MakeupTable){
        if (section==0){
            return [MyClass returntitlewithtitle:@"Makeup Quota"];
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"Makeup Timeslots"];
        }else{
            return @" ";
        }
    }else if (tableView==lessonNumberTable){
        if([lessonnumbertype isEqualToString:@"noteset1"]){
            return [MyClass returntitlewithtitle:@"Note Set 1"];
        }else{
            return [MyClass returntitlewithtitle:@"Note Set 2"];
        }
    }else if (tableView==chatBotSettingsTable){
        if (section==0){
            return [MyClass returntitlewithtitle:@"General"];
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"Photo"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"Full Description"];
        }else if (section==3){
            return [MyClass returntitlewithtitle:@"Tag1 (Separate by comma)"];
        }else if(section==4){
            return [MyClass returntitlewithtitle:@"Trial Schedule"];
        }else{
            return @" ";
        }
    }else if (tableView==levelEffectiveDateTable){
        return [MyClass returntitlewithtitle:@"Effective Date"];
    }else if (tableView==gradeEffectiveDateTable){
        return [MyClass returntitlewithtitle:@"Effective Date"];
    }
    else if (tableView==autoLevelUpgradeOptionTable){
        return [MyClass returntitlewithtitle:@"Auto Level Upgrade"];
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if(tableView==MakeupTable){
        if(section==1){
            return [MyClass returntitlewithtitle:@"System will search for matching timeslots"];
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==SubjectPopoverTable) {
        if ([SubjectTableMode isEqualToString:@"View"]) {
            if (indexPath.section==2) {
                if (indexPath.row==1) {
                    return globalvariables.centerrecord.enrollmentvalidity?35:0;
                }
            }else if (indexPath.section==6) {
                if (!showGradeTuition) {
                    return CGFLOAT_MIN;
                }
            }else if (indexPath.section==7) {
                if (!globalvariables.centerrecord.enablelessonnumber) {
                    return CGFLOAT_MIN;
                }
            }else if (indexPath.section==8) {
                if (!globalvariables.centerrecord.enablechatbot) {
                    return CGFLOAT_MIN;
                }
            }else if (indexPath.section==9){
                return 150;
            }
            return 35;
        }else{// if ([SubjectTableMode isEqualToString:@"Edit"]){
            if (indexPath.section==0) {
                return 35;
            }else if (indexPath.section==1){
                if (indexPath.row==2) {
                    if (showStudentCapacityPicker) {
                        return 150;
                    }else{
                        return 0;
                    }
                }else if (indexPath.row==14) {
                    if (showStandardPeriodPicker) {
                        return 150;
                    }else{
                        return 0;
                    }
                }else if (indexPath.row==4) {
                    if (showClassDurationPicker) {
                        return 150;
                    }else{
                        return 0;
                    }
                }else if (indexPath.row==6) {
                    if (showClassDurationAssessmentPicker) {
                        return 150;
                    }else{
                        return 0;
                    }
                }else if (indexPath.row==8) {
                    if (showClassDurationTrialPicker) {
                        return 150;
                    }else{
                        return 0;
                    }
                }else if (indexPath.row==10){
                    if (showTuitionMethodPicker) {
                        return 150;
                    }else{
                        return 0;
                    }
                }else if (indexPath.row==12){
                    if (showTuitionModePicker) {
                        return 150;
                    }else{
                        return 0;
                    }
                }else if (indexPath.row==16){
                    if (showPregenPeriodPicker) {
                        return 150;
                    }else{
                        return 0;
                    }
                }else{
                    return 35;
                }
            }else if (indexPath.section==2){
                if (indexPath.row==1){
                    return globalvariables.centerrecord.enrollmentvalidity?35:0;
                }else if (indexPath.row==2){
                    return globalvariables.centerrecord.enablemakeupquota?35:0;
                }
                return 35;
            }else if (indexPath.section==4){
                return 35;
            }else if (indexPath.section==5){
                return 35;
            }else if (indexPath.section==6){
                if (showGradeTuition) {
                    return 35;
                }else{
                    return 0;
                }
            }else if (indexPath.section==7) {
                if (!globalvariables.centerrecord.enablelessonnumber) {
                    return CGFLOAT_MIN;
                }else{
                    return 35;
                }
            }else if (indexPath.section==8) {
                if (!globalvariables.centerrecord.enablechatbot) {
                    return CGFLOAT_MIN;
                }else{
                    return 35;
                }
            }else if (indexPath.section==9){
                return 150;
            }else{
                return 35;
            }
        }
    }else if (tableView==CourseScheduleTable){
        if ([CourseTableMode isEqualToString:@"View"]) {
            ScheduleRecord *scheduleobj=[filteredScheduleArray objectAtIndex:indexPath.row];
            if ([scheduleobj.action isEqualToString:@"Delete"] || [scheduleobj.schedulekey intValue]<0) {
                return 0;
            }else{
                CGFloat levelheight=0;
                
                if (!scheduleobj.levelarray || scheduleobj.levelarray.count>0) {
                    UILabel *generallabel = [[UILabel alloc]initWithFrame:CGRectMake(48, 0, courseschedulewidth-48-34, 100)];
                    generallabel.font=[UIFont systemFontOfSize:13];
//                    generallabel.textColor=[UIColor darkGrayColor];
                    generallabel.numberOfLines=0;
                    generallabel.textAlignment=NSTextAlignmentLeft;
                    generallabel.text=[self returnlevelwithlevelarray:scheduleobj.levelarray];
                    [generallabel sizeToFit];
                    
                    levelheight=generallabel.frame.size.height+5;
                }

                return 40+35+12+scheduleobj.daytimearray.count*(globalvariables.centerrecord.secondaryinstructor?30:20)+40+((![scheduleobj.startdate isEqualToString:@""] || ![scheduleobj.enddate isEqualToString:@""])?25:0)+levelheight;
            }
        }else if ([CourseTableMode isEqualToString:@"Edit"]) {
            if (indexPath.section==0) {
                if (indexPath.row==3) {
//                    return 35+(workingSchedule.daytimearray.count-1)*30;
                    if(globalvariables.centerrecord.secondaryinstructor){
                        return workingSchedule.daytimearray.count*35;
                    }else{
                        return 35+(workingSchedule.daytimearray.count-1)*30;
                    }
                }else if(indexPath.row==7){
                    return globalvariables.centerrecord.enablechatbot?35:CGFLOAT_MIN;
                }else if (indexPath.row==11){
                    UILabel *generalLabel = [[UILabel alloc]initWithFrame:CGRectMake(courseschedulewidth-200-35, 7, 200, 100)];
                    generalLabel.font=[UIFont systemFontOfSize:15];
//                    generalLabel.textColor=[UIColor darkGrayColor];
                    generalLabel.textAlignment=NSTextAlignmentRight;
                    generalLabel.text=[self returnlevelwithlevelarray:workingSchedule.levelarray];
                    generalLabel.numberOfLines=0;
                    [generalLabel sizeToFit];
                    return generalLabel.frame.size.height<35?35:generalLabel.frame.size.height+14;
                }else{
                    return 35;
                }
            }else{
                return 35;
            }
        }else{// if ([CourseTableMode isEqualToString:@"Add"]) {
            if (indexPath.row==3) {
                if(globalvariables.centerrecord.secondaryinstructor){
                    return workingSchedule.daytimearray.count*35;
                }else{
                    return 35+(workingSchedule.daytimearray.count-1)*30;
                }
                
            }else if (indexPath.row==11){
                UILabel *generalLabel = [[UILabel alloc]initWithFrame:CGRectMake(courseschedulewidth-200-35, 7, 200, 100)];
                generalLabel.font=[UIFont systemFontOfSize:15];
//                    generalLabel.textColor=[UIColor darkGrayColor];
                generalLabel.textAlignment=NSTextAlignmentRight;
                generalLabel.text=[self returnlevelwithlevelarray:workingSchedule.levelarray];
                GeneralLabel.numberOfLines=0;
                [generalLabel sizeToFit];
                
                return generalLabel.frame.size.height<35?35:generalLabel.frame.size.height;
            }else{
                return 35;
            }
        }
    }else if (tableView==SubjectCategoryTable){
        return 38;
    }else if (tableView==ValidityTable){
        return 190;
    }else if (tableView==csClassDateTable){
        return 620;
    }else if (tableView==levelEffectiveDateTable){
        return self.view.frame.size.height;
    }else if (tableView==gradeEffectiveDateTable){
        return self.view.frame.size.height;
    }else if (tableView==MakeupTable){
        if (indexPath.section==0){
            if (indexPath.row==1){
                if ([workingSubject.makeup_quota_value isEqualToString:@"-1"]) {
                    return CGFLOAT_MIN;
                }
            }
        }else if (indexPath.section==2){
            if(indexPath.row==6 || indexPath.row==7){
                if ([globalvariables.language isEqualToString:@"English"]){
                    return 52;
                }
            }
        }
    }else if (tableView==csDayDateTimeTable){
        if (![workingSchedule.type isEqualToString:@"Fixed"]) {
            return 150;
        }else{
            return 620;
        }
    }else if (tableView==lessonNumberTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==LevelTuitionTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==chatBotSettingsTable){
        if ([SubjectTableMode isEqualToString:@"View"]) {
            if(indexPath.section==1){
                return 80;
            }else if(indexPath.section==4){
                if(indexPath.row==2){
                    return CGFLOAT_MIN;
                }
            }
        }else{
            if(indexPath.section==1){
                return 80;
            }else if(indexPath.section==4){
                if(indexPath.row==2){
                    if (showTrialCapacityPicker) {
                        return 150;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }
            }
        }
        return UITableViewAutomaticDimension;
    }else if (tableView==autoLevelUpgradeOptionTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==autoLevelUpgradeValuesTable){
        return UITableViewAutomaticDimension;
    }
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 38;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==SubjectPopoverTable) {
        if ([SubjectTableMode isEqualToString:@"View"]) {
            if (section==6){
                if (!showGradeTuition) {
                    return CGFLOAT_MIN;
                }
            }else if (section==7){
                if (!globalvariables.centerrecord.enablelessonnumber) {
                    return CGFLOAT_MIN;
                }
            }else if (section==8){
                if (!globalvariables.centerrecord.enablechatbot) {
                    return CGFLOAT_MIN;
                }
            }
            return 44;
        }else if ([SubjectTableMode isEqualToString:@"Edit"]) {
            if (section==6){
                if (!showGradeTuition) {
                    return CGFLOAT_MIN;
                }
            }else if (section==7){
                if (!globalvariables.centerrecord.enablelessonnumber) {
                    return CGFLOAT_MIN;
                }
            }else if (section==8){
                if (!globalvariables.centerrecord.enablechatbot) {
                    return CGFLOAT_MIN;
                }
            }
            return 44;
        }else{
            if (section==0) {
                return 44;
            }else if (section==1){
                return 44;
            }else if (section==2){
                return 44;
            }else if (section==3){
                return 44;
            }else if (section==4){
                return 44;
            }else if (section==5){
                return 44;
            }else if (section==6){
                if (showGradeTuition) {
                    return 44;
                }else{
                    return CGFLOAT_MIN;
                }
            }else if (section==7){
                if (!globalvariables.centerrecord.enablelessonnumber) {
                    return CGFLOAT_MIN;
                }else{
                    return 44;
                }
            }else if (section==8){
                if (!globalvariables.centerrecord.enablechatbot) {
                    return CGFLOAT_MIN;
                }else{
                    return 44;
                }
            }else{// if (section==4){
                return 30;
            }
        }
    }else if (tableView==CourseScheduleTable){
        if ([CourseTableMode isEqualToString:@"View"]) {
            if (filteredScheduleArray.count==0) {
                return CGFLOAT_MIN;
            }else{
                return CGFLOAT_MIN;//44;
            }
        }else if ([CourseTableMode isEqualToString:@"Edit"]){
            return 44;
        }else{
            return 44;
        }
    }else if (tableView==SubjectCategoryTable){
        return CGFLOAT_MIN;
    }else if (tableView==csInstructorTable){
        return CGFLOAT_MIN;
    }else if (tableView==csClassroomTable){
        return CGFLOAT_MIN;
    }else if (tableView==csClassDateTable){
        return CGFLOAT_MIN;
    }else if (tableView==csDayDateTimeTable){
        return CGFLOAT_MIN;
    }else if (tableView==ScheduleLevelTable){
        return CGFLOAT_MIN;
    }else{
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell;
    
    if(tableView==ScheduleLevelTable){
        MyTableViewCell *myCell;
        static NSString *CellIdentifier = @"levelcell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        myCell.label1.text=[filteredScheduleLevelArray objectAtIndex:indexPath.row];
        myCell.imageview2.hidden=!([workingSchedule.levelarray containsObject:[filteredScheduleLevelArray objectAtIndex:indexPath.row]] || (workingSchedule.levelarray && workingSchedule.levelarray.count==0));
        
        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return myCell;
    }else if (tableView==SubjectPopoverTable) {
        if ([SubjectTableMode isEqualToString:@"View"]) {
            //if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (indexPath.section==0 ) {
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=@"English";
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Subject_EnglishnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 2, 197, 31)];
                    Subject_EnglishnameLabel.font=[UIFont systemFontOfSize:15];
                    Subject_EnglishnameLabel.textColor=[UIColor darkGrayColor];
                    Subject_EnglishnameLabel.textAlignment=NSTextAlignmentRight;
                    Subject_EnglishnameLabel.text=workingSubject.subject_englishname;
                    Subject_EnglishnameLabel.adjustsFontSizeToFitWidth=YES;
                    Subject_EnglishnameLabel.minimumScaleFactor=0.7;
                    Subject_EnglishnameLabel.numberOfLines=0;
                    Subject_EnglishnameLabel.tag=302;
                    [cell.contentView addSubview:Subject_EnglishnameLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=@"中文";
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Subject_ChinesenameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 2, 197, 31)];
                    Subject_ChinesenameLabel.font=[UIFont systemFontOfSize:15];
                    Subject_ChinesenameLabel.textColor=[UIColor darkGrayColor];
                    Subject_ChinesenameLabel.textAlignment=NSTextAlignmentRight;
                    Subject_ChinesenameLabel.adjustsFontSizeToFitWidth=YES;
                    Subject_ChinesenameLabel.minimumScaleFactor=0.7;
                    Subject_ChinesenameLabel.numberOfLines=0;
                    Subject_ChinesenameLabel.text=workingSubject.subject_chinesename;
                    [cell.contentView addSubview:Subject_ChinesenameLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==2) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Code"];
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Subject_ShortnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    Subject_ShortnameLabel.font=[UIFont systemFontOfSize:15];
                    Subject_ShortnameLabel.textColor=[UIColor darkGrayColor];
                    Subject_ShortnameLabel.textAlignment=NSTextAlignmentRight;
                    Subject_ShortnameLabel.text=workingSubject.subject_shortname;
                    [cell.contentView addSubview:Subject_ShortnameLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==3) {
                    //if (globalvariables.centerrecord.enableattendanceextend) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Category"];
                        [cell.contentView addSubview:GeneralLabel];
                        
                        Subject_CategoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 7, 177, 21)];
                        Subject_CategoryLabel.font=[UIFont systemFontOfSize:15];
                        Subject_CategoryLabel.textColor=[UIColor darkGrayColor];
                        Subject_CategoryLabel.textAlignment=NSTextAlignmentRight;
                        Subject_CategoryLabel.minimumScaleFactor=0.7;
                        Subject_CategoryLabel.adjustsFontSizeToFitWidth=YES;
                        Subject_CategoryLabel.text=[MyClass returnsubjectcategorynamewithscategorykey:workingSubject.subject_category];
                        [cell.contentView addSubview:Subject_CategoryLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    /*}else{
                        cell.hidden=YES;
                    }*/

                }else if (indexPath.row==4){
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Subject Color"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-24-33, 11, 24, 16)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.layer.masksToBounds=YES;
                    GeneralLabel.layer.cornerRadius=4;
                    GeneralLabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:workingSubject.colorcode];
                    [cell.contentView addSubview:GeneralLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }

                
            }else if (indexPath.section==1){
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Status"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    StatusLabel.font=[UIFont systemFontOfSize:15];
                    StatusLabel.textColor=[UIColor darkGrayColor];
                    StatusLabel.textAlignment=NSTextAlignmentRight;
                    StatusLabel.text=[MyClass returntitlewithtitle:workingSubject.status];
                    StatusLabel.tag=302;
                    [cell.contentView addSubview:StatusLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 150, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Max. Class Size"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[workingSubject.studentcapacity isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:workingSubject.studentcapacity;
                    StudentCapacityLabel.tag=302;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==7) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Standard Period"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StandandPeriodLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    StandandPeriodLabel.font=[UIFont systemFontOfSize:15];
                    StandandPeriodLabel.textColor=[UIColor darkGrayColor];
                    StandandPeriodLabel.textAlignment=NSTextAlignmentRight;
                    if (![workingSubject.standardnoofclassormonth isEqualToString:@""] && ![workingSubject.enrollmentmode isEqualToString:@""]) {
                        if ([workingSubject.standardnoofclassormonth intValue]>1) {
                            StandandPeriodLabel.text=[NSString stringWithFormat:@"%@ %@",workingSubject.standardnoofclassormonth,[workingSubject.enrollmentmode isEqualToString:@"Class"]?[MyClass returntitlewithtitle:@"Classes"]:[MyClass returntitlewithtitle:@"Months"]];
                        }else{
                            StandandPeriodLabel.text=[NSString stringWithFormat:@"%@ %@",workingSubject.standardnoofclassormonth,[workingSubject.enrollmentmode isEqualToString:@"Class"]?[MyClass returntitlewithtitle:@"Class"]:[MyClass returntitlewithtitle:@"Month"]];
                        }
                    }else{
                        StandandPeriodLabel.text=@"";
                    }
                    //StandardNoOfClassLabel.text=[NSString stringWithFormat:@"] tmpStandardNoOfClass;
                    StandandPeriodLabel.tag=302;
                    [cell.contentView addSubview:StandandPeriodLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==2) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Duration (Standard) in mins"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    ClassDurationLabel.font=[UIFont systemFontOfSize:15];
                    ClassDurationLabel.textColor=[UIColor darkGrayColor];
                    ClassDurationLabel.textAlignment=NSTextAlignmentRight;
                    ClassDurationLabel.text=workingSubject.classduration;
                    ClassDurationLabel.tag=302;
                    [cell.contentView addSubview:ClassDurationLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==3) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Duration (Assess) in mins"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    ClassDurationLabel.font=[UIFont systemFontOfSize:15];
                    ClassDurationLabel.textColor=[UIColor darkGrayColor];
                    ClassDurationLabel.textAlignment=NSTextAlignmentRight;
                    ClassDurationLabel.text=workingSubject.classduration_assessment;
                    ClassDurationLabel.tag=302;
                    [cell.contentView addSubview:ClassDurationLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==4) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Duration (Trial) in mins"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    ClassDurationLabel.font=[UIFont systemFontOfSize:15];
                    ClassDurationLabel.textColor=[UIColor darkGrayColor];
                    ClassDurationLabel.textAlignment=NSTextAlignmentRight;
                    ClassDurationLabel.text=workingSubject.classduration_trial;
                    ClassDurationLabel.tag=302;
                    [cell.contentView addSubview:ClassDurationLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==5) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Tuition By"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Tuition_MethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    Tuition_MethodLabel.font=[UIFont systemFontOfSize:15];
                    Tuition_MethodLabel.textColor=[UIColor darkGrayColor];
                    Tuition_MethodLabel.textAlignment=NSTextAlignmentRight;
                    Tuition_MethodLabel.text=[MyClass returntitlewithtitle:workingSubject.tuition_method];
                    Tuition_MethodLabel.tag=302;
                    [cell.contentView addSubview:Tuition_MethodLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==6) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Tuition Mode"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Tuition_MethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    Tuition_MethodLabel.font=[UIFont systemFontOfSize:15];
                    Tuition_MethodLabel.textColor=[UIColor darkGrayColor];
                    Tuition_MethodLabel.textAlignment=NSTextAlignmentRight;
                    Tuition_MethodLabel.text=[MyClass returntitlewithtitle:workingSubject.tuition_mode];
                    Tuition_MethodLabel.tag=302;
                    [cell.contentView addSubview:Tuition_MethodLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==8){
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Pre-generate Period"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Tuition_MethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    Tuition_MethodLabel.font=[UIFont systemFontOfSize:15];
                    Tuition_MethodLabel.textColor=[UIColor darkGrayColor];
                    Tuition_MethodLabel.textAlignment=NSTextAlignmentRight;
                    Tuition_MethodLabel.text=[@(workingSubject.pregenperiodcount) stringValue];
                    Tuition_MethodLabel.tag=302;
                    [cell.contentView addSubview:Tuition_MethodLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==9){
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Auto Level Upgrade"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Tuition_MethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    Tuition_MethodLabel.font=[UIFont systemFontOfSize:15];
                    Tuition_MethodLabel.textColor=[UIColor darkGrayColor];
                    Tuition_MethodLabel.textAlignment=NSTextAlignmentRight;
                    Tuition_MethodLabel.text=[self returnautolevelupgradetitle:workingSubject.autolevelupgrade];
                    Tuition_MethodLabel.tag=302;
                    [cell.contentView addSubview:Tuition_MethodLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }

            }else if (indexPath.section==2){
                if (indexPath.row==0){
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Weekly Auto Renew Default"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    
                    WeeklyScheduleAutoRenewalLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    WeeklyScheduleAutoRenewalLabel.font=[UIFont systemFontOfSize:15];
                    WeeklyScheduleAutoRenewalLabel.textColor=[UIColor darkGrayColor];
                    WeeklyScheduleAutoRenewalLabel.textAlignment=NSTextAlignmentRight;
                    WeeklyScheduleAutoRenewalLabel.text=[MyClass returntitlewithtitle:workingSubject.weeklyautorenewdefault?@"Yes":@"No"];
                    WeeklyScheduleAutoRenewalLabel.tag=302;
                    [cell.contentView addSubview:WeeklyScheduleAutoRenewalLabel];
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==1) {
                    if (globalvariables.centerrecord.enrollmentvalidity){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Validity"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        ValidityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                        ValidityLabel.font=[UIFont systemFontOfSize:15];
                        ValidityLabel.textColor=[UIColor darkGrayColor];
                        ValidityLabel.textAlignment=NSTextAlignmentRight;
                        ValidityLabel.text=[MyClass returnvaliditylabelwithvaliditystring:workingSubject.validity];
                        ValidityLabel.tag=302;
                        [cell.contentView addSubview:ValidityLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }
            }else if (indexPath.section==3){
                if (indexPath.row==0){
                    //if(globalvariables.centerrecord.enablemakeupquota){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Makeup Settings"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                    
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
            }else if (indexPath.section==4){
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"User Defined Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    GeneralLabel.text=[self returndetailschedulearraycount];
                    GeneralLabel.tag=302;
                    [cell.contentView addSubview:GeneralLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
            }else if (indexPath.section==5){
                //if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"No. of Level"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    NoOfLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    NoOfLevelLabel.font=[UIFont systemFontOfSize:15];
                    NoOfLevelLabel.textColor=[UIColor darkGrayColor];
                    NoOfLevelLabel.textAlignment=NSTextAlignmentRight;
                    NoOfLevelLabel.text=[@(workingSubject.levelArray.count) stringValue];
                    NoOfLevelLabel.tag=302;
                    [cell.contentView addSubview:NoOfLevelLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
            }else if (indexPath.section==6){
                if (showGradeTuition) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"No. of Grade"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    GeneralLabel.text=[@(tmpgradearray.count) stringValue];
                    GeneralLabel.tag=302;
                    [cell.contentView addSubview:GeneralLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.hidden=YES;
                }
                
            }else if (indexPath.section==7){
                if (globalvariables.centerrecord.enablelessonnumber) {
                    if(indexPath.row==0){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Note Set 1"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:15];
                        GeneralLabel.textColor=[UIColor darkGrayColor];
                        GeneralLabel.textAlignment=NSTextAlignmentRight;
                        GeneralLabel.text=[@(((NSMutableArray *)workingSubject.lessonnumberDict[@"noteset1"]).count) stringValue];
                        GeneralLabel.tag=302;
                        [cell.contentView addSubview:GeneralLabel];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Note Set 2"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:15];
                        GeneralLabel.textColor=[UIColor darkGrayColor];
                        GeneralLabel.textAlignment=NSTextAlignmentRight;
                        GeneralLabel.text=[@(((NSMutableArray *)workingSubject.lessonnumberDict[@"noteset2"]).count) stringValue];
                        GeneralLabel.tag=302;
                        [cell.contentView addSubview:GeneralLabel];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                    
                }else{
                    cell.hidden=YES;
                }
                
            }else if (indexPath.section==8){
                if (globalvariables.centerrecord.enablechatbot) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Chatbot Settings"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.hidden=YES;
                }
                
            }else if (indexPath.section==9){
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 280, 150)];
                GeneralLabel.font=[UIFont systemFontOfSize:15];
                GeneralLabel.textColor=[UIColor darkGrayColor];
                GeneralLabel.textAlignment=NSTextAlignmentLeft;
                GeneralLabel.numberOfLines=0;
                GeneralLabel.text=subjectobject.remarks;
                GeneralLabel.tag=302;
                
                [GeneralLabel sizeToFit];
                CGRect myFrame=GeneralLabel.frame;
                
                if (myFrame.size.height>150) {
                    myFrame=CGRectMake(20, 0, 280, 150);
                }else{
                    myFrame=CGRectMake(20, 3, 280, myFrame.size.height);
                }
                GeneralLabel.frame=myFrame;
                
                
                [cell.contentView addSubview:GeneralLabel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
        }else if([SubjectTableMode isEqualToString:@"Add"]){
            
            //if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
            if (indexPath.section==0 ) {
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=@"English";
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Subject_EnglishnameText=[[UITextField alloc]initWithFrame:CGRectMake(90, 0, 197, 35)];
                    Subject_EnglishnameText.font=[UIFont systemFontOfSize:15];
                    Subject_EnglishnameText.textColor=[UIColor darkGrayColor];
                    Subject_EnglishnameText.textAlignment=NSTextAlignmentRight;
                    Subject_EnglishnameText.text=workingSubject.subject_englishname;
                    Subject_EnglishnameText.adjustsFontSizeToFitWidth=YES;
                    Subject_EnglishnameText.minimumFontSize=0.7;
                    Subject_EnglishnameText.placeholder=@"English name";
                    [Subject_EnglishnameText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    Subject_EnglishnameText.tag=408;
                    [cell.contentView addSubview:Subject_EnglishnameText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=@"中文";
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Subject_ChinesenameText=[[UITextField alloc]initWithFrame:CGRectMake(90, 0, 197, 35)];
                    Subject_ChinesenameText.font=[UIFont systemFontOfSize:15];
                    Subject_ChinesenameText.textColor=[UIColor darkGrayColor];
                    Subject_ChinesenameText.textAlignment=NSTextAlignmentRight;
                    Subject_ChinesenameText.text=workingSubject.subject_chinesename;
                    Subject_ChinesenameText.adjustsFontSizeToFitWidth=YES;
                    Subject_ChinesenameText.minimumFontSize=0.7;
                    Subject_ChinesenameText.placeholder=@"Chinese name";
                    [Subject_ChinesenameText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    Subject_ChinesenameText.tag=408;
                    [cell.contentView addSubview:Subject_ChinesenameText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==2){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Code"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 6, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:10];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"(max 8 characters)"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Subject_ShortnameText=[[UITextField alloc]initWithFrame:CGRectMake(222, 7, 65, 21)];
                    Subject_ShortnameText.font=[UIFont systemFontOfSize:15];
                    Subject_ShortnameText.textColor=[UIColor darkGrayColor];
                    Subject_ShortnameText.textAlignment=NSTextAlignmentRight;
                    Subject_ShortnameText.text=workingSubject.subject_shortname;
                    Subject_ShortnameText.placeholder=[MyClass returntitlewithtitle:@"Code"];
                    [Subject_ShortnameText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    Subject_ShortnameText.tag=408;
                    [cell.contentView addSubview:Subject_ShortnameText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==3){
                    //if (globalvariables.centerrecord.enableattendanceextend) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Category"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        Subject_CategoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 7, 177, 21)];
                        Subject_CategoryLabel.font=[UIFont systemFontOfSize:15];
                        Subject_CategoryLabel.minimumScaleFactor=0.7;
                        Subject_CategoryLabel.adjustsFontSizeToFitWidth=YES;
                        Subject_CategoryLabel.textColor=[UIColor darkGrayColor];
                        Subject_CategoryLabel.textAlignment=NSTextAlignmentRight;
                        Subject_CategoryLabel.text=[MyClass returnsubjectcategorynamewithscategorykey:workingSubject.subject_category];
                        Subject_CategoryLabel.tag=408;
                        [cell.contentView addSubview:Subject_CategoryLabel];
                        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                    }else{
//                        cell.hidden=YES;
//                    }

                }else if (indexPath.row==4){
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Subject Color"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-24-33, 11, 24, 16)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.layer.masksToBounds=YES;
                    GeneralLabel.layer.cornerRadius=4;
                    GeneralLabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:workingSubject.colorcode];
                    [cell.contentView addSubview:GeneralLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
            }else if (indexPath.section==1){
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Status"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    scStatus = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Active"],[MyClass returntitlewithtitle:@"Inactive"],nil]];
                    scStatus.frame = CGRectMake(90, 3, 215, 29);
                    [scStatus addTarget:self action:@selector(selectStatus:) forControlEvents: UIControlEventValueChanged];
                    scStatus.tintColor=themecolor;
                    
                    scStatus.selectedSegmentIndex=[workingSubject.status isEqualToString:@"Active"] ? 0:1;
                    [cell.contentView addSubview:scStatus];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 150, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Max. Class Size"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[workingSubject.studentcapacity isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:workingSubject.studentcapacity;
                    StudentCapacityLabel.tag=408;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else if (indexPath.row==2){
                    if (showStudentCapacityPicker) {
                        
                        pickerViewmenu =[[NSMutableArray alloc]initWithObjects:@"",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30", nil];
                        
                        if ([pickerViewmenu containsObject:workingSubject.studentcapacity]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.studentcapacity];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==13) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Standard Period"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StandandPeriodLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    StandandPeriodLabel.font=[UIFont systemFontOfSize:15];
                    StandandPeriodLabel.textColor=[UIColor darkGrayColor];
                    StandandPeriodLabel.textAlignment=NSTextAlignmentRight;
                    
                    if (![workingSubject.standardnoofclassormonth isEqualToString:@""] && ![workingSubject.enrollmentmode isEqualToString:@""]) {
                        if ([workingSubject.standardnoofclassormonth intValue]>1) {
                            StandandPeriodLabel.text=[NSString stringWithFormat:@"%@ %@",workingSubject.standardnoofclassormonth,[workingSubject.enrollmentmode isEqualToString:@"Class"]?[MyClass returntitlewithtitle:@"Classes"]:[MyClass returntitlewithtitle:@"Months"]];
                        }else{
                            StandandPeriodLabel.text=[NSString stringWithFormat:@"%@ %@",workingSubject.standardnoofclassormonth,[workingSubject.enrollmentmode isEqualToString:@"Class"]?[MyClass returntitlewithtitle:@"Class"]:[MyClass returntitlewithtitle:@"Month"]];
                        }
                    }else{
                        StandandPeriodLabel.text=@"";
                    }
                    
                    //StandandPeriodLabel.text=tmpStandardNoOfClass;
                    StandandPeriodLabel.tag=408;
                    [cell.contentView addSubview:StandandPeriodLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else if (indexPath.row==14){
                    if (showStandardPeriodPicker) {
                        
                        if ([workingSubject.tuition_mode isEqualToString:@"Month"]) {
                            enrollmentmodearray =[[NSArray alloc]initWithObjects:@"Month", nil];
                        }else{
                            enrollmentmodearray =[[NSArray alloc]initWithObjects:@"Class",@"Month", nil];
                        }
                        
                        if ([standardnoofclassormontharray containsObject:workingSubject.standardnoofclassormonth]) {
                            standardnoofclassormonthpresetrow=(int)[standardnoofclassormontharray indexOfObject:workingSubject.standardnoofclassormonth];
                        }else{
                            standardnoofclassormonthpresetrow=0;
                        }

                        if ([enrollmentmodearray containsObject:workingSubject.enrollmentmode]) {
                            enrollmentmodepresetrow=(int)[enrollmentmodearray indexOfObject:workingSubject.enrollmentmode];
                        }else{
                            enrollmentmodepresetrow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:standardnoofclassormonthpresetrow inComponent:0 animated:NO];
                        [myPicker selectRow:enrollmentmodepresetrow inComponent:1 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==3) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Duration (Standard) in mins"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    ClassDurationLabel.font=[UIFont systemFontOfSize:15];
                    ClassDurationLabel.textColor=[UIColor darkGrayColor];
                    ClassDurationLabel.textAlignment=NSTextAlignmentRight;
                    ClassDurationLabel.text=workingSubject.classduration;
                    ClassDurationLabel.tag=408;
                    [cell.contentView addSubview:ClassDurationLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else if (indexPath.row==4){
                    if (showClassDurationPicker) {
                        
                        pickerViewmenu=[[NSMutableArray alloc]init];
                        for (int i=1; i<=12*60/5; i++) {
                            [pickerViewmenu addObject:[NSString stringWithFormat:@"%d",5*i]];
                        }
                        
                        if ([pickerViewmenu containsObject:workingSubject.classduration]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.classduration];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==5) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Duration (Assess) in mins"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassDurationAssessmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    ClassDurationAssessmentLabel.font=[UIFont systemFontOfSize:15];
                    ClassDurationAssessmentLabel.textColor=[UIColor darkGrayColor];
                    ClassDurationAssessmentLabel.textAlignment=NSTextAlignmentRight;
                    ClassDurationAssessmentLabel.text=workingSubject.classduration_assessment;
                    ClassDurationAssessmentLabel.tag=408;
                    [cell.contentView addSubview:ClassDurationAssessmentLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else if (indexPath.row==6){
                    if (showClassDurationAssessmentPicker) {
                        
                        pickerViewmenu=[[NSMutableArray alloc]init];
                        for (int i=1; i<=5*60/[globalvariables.centerrecord.classtimeinterval intValue]; i++) {
                            [pickerViewmenu addObject:[NSString stringWithFormat:@"%d",[globalvariables.centerrecord.classtimeinterval intValue]*i]];
                        }
                        
                        if ([pickerViewmenu containsObject:workingSubject.classduration_assessment]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.classduration_assessment];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==7) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Duration (Trial) in mins"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassDurationTrialLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    ClassDurationTrialLabel.font=[UIFont systemFontOfSize:15];
                    ClassDurationTrialLabel.textColor=[UIColor darkGrayColor];
                    ClassDurationTrialLabel.textAlignment=NSTextAlignmentRight;
                    ClassDurationTrialLabel.text=workingSubject.classduration_trial;
                    ClassDurationTrialLabel.tag=408;
                    [cell.contentView addSubview:ClassDurationTrialLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else if (indexPath.row==8){
                    if (showClassDurationTrialPicker) {
                        
                        pickerViewmenu=[[NSMutableArray alloc]init];
                        for (int i=1; i<=5*60/[globalvariables.centerrecord.classtimeinterval intValue]; i++) {
                            [pickerViewmenu addObject:[NSString stringWithFormat:@"%d",[globalvariables.centerrecord.classtimeinterval intValue]*i]];
                        }
                        
                        if ([pickerViewmenu containsObject:workingSubject.classduration_trial]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.classduration_trial];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==9) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Tuition By"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Tuition_MethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    Tuition_MethodLabel.font=[UIFont systemFontOfSize:15];
                    Tuition_MethodLabel.textColor=[UIColor darkGrayColor];
                    Tuition_MethodLabel.textAlignment=NSTextAlignmentRight;
                    Tuition_MethodLabel.text=[MyClass returntitlewithtitle:workingSubject.tuition_method];
                    Tuition_MethodLabel.tag=408;
                    [cell.contentView addSubview:Tuition_MethodLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else if (indexPath.row==10){
                    if (showTuitionMethodPicker) {
                        
                        pickerViewmenu =[[NSMutableArray alloc]initWithObjects:@"Level",@"Grade", nil];
                        
                        if ([pickerViewmenu containsObject:workingSubject.tuition_method]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.tuition_method];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==11) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Tuition Mode"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Tuition_ModeLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    Tuition_ModeLabel.font=[UIFont systemFontOfSize:15];
                    Tuition_ModeLabel.textColor=[UIColor darkGrayColor];
                    Tuition_ModeLabel.textAlignment=NSTextAlignmentRight;
                    Tuition_ModeLabel.text=[MyClass returntitlewithtitle:workingSubject.tuition_mode];
                    Tuition_ModeLabel.tag=408;
                    [cell.contentView addSubview:Tuition_ModeLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else if (indexPath.row==12){
                    if (showTuitionModePicker) {
                        
                        pickerViewmenu =[[NSMutableArray alloc]initWithObjects:@"Class",@"Month", nil];
                        
                        if ([pickerViewmenu containsObject:workingSubject.tuition_mode]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.tuition_mode];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==15) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Pre-generate Period"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StandandPeriodLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    StandandPeriodLabel.font=[UIFont systemFontOfSize:15];
                    StandandPeriodLabel.textColor=[UIColor darkGrayColor];
                    StandandPeriodLabel.textAlignment=NSTextAlignmentRight;
                    StandandPeriodLabel.text=[@(workingSubject.pregenperiodcount) stringValue];
                    StandandPeriodLabel.tag=408;
                    [cell.contentView addSubview:StandandPeriodLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else if (indexPath.row==16){
                    if (showPregenPeriodPicker) {
                        
                        pickerViewmenu =[[NSMutableArray alloc]initWithObjects:@"",@"1",@"2",@"3",@"4",@"5", nil];
                        
                        if ([pickerViewmenu containsObject:[@(workingSubject.pregenperiodcount) stringValue]]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:[@(workingSubject.pregenperiodcount) stringValue]];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==17) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Auto Level Upgrade"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StandandPeriodLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    StandandPeriodLabel.font=[UIFont systemFontOfSize:15];
                    StandandPeriodLabel.textColor=[UIColor darkGrayColor];
                    StandandPeriodLabel.textAlignment=NSTextAlignmentRight;
                    StandandPeriodLabel.text=[self returnautolevelupgradetitle:workingSubject.autolevelupgrade];
                    StandandPeriodLabel.tag=408;
                    [cell.contentView addSubview:StandandPeriodLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }
            }else if (indexPath.section==2){
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Weekly Auto Renew Default"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    swWeeklyScheduleAutoRenewal = [[UISwitch alloc] init];
                    swWeeklyScheduleAutoRenewal.onTintColor=themecolor;
                    CGSize switchSize = [swWeeklyScheduleAutoRenewal sizeThatFits:CGSizeZero];
                    swWeeklyScheduleAutoRenewal.frame = CGRectMake(255.0f,2.0f,switchSize.width,switchSize.height);
                    swWeeklyScheduleAutoRenewal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swWeeklyScheduleAutoRenewal.tag = 501;
                    [swWeeklyScheduleAutoRenewal addTarget:self action:@selector(selectweeklyautorenewdefault:) forControlEvents:UIControlEventValueChanged];
                    
                    swWeeklyScheduleAutoRenewal.on=workingSubject.weeklyautorenewdefault;
                    [cell.contentView addSubview:swWeeklyScheduleAutoRenewal];
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }else if (indexPath.row==1) {
                    if (globalvariables.centerrecord.enrollmentvalidity){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Validity"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        ValidityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                        ValidityLabel.font=[UIFont systemFontOfSize:15];
                        ValidityLabel.textColor=[UIColor darkGrayColor];
                        ValidityLabel.textAlignment=NSTextAlignmentRight;
                        ValidityLabel.text=[MyClass returnvaliditylabelwithvaliditystring:workingSubject.validity];
                        ValidityLabel.tag=408;
                        [cell.contentView addSubview:ValidityLabel];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.hidden=YES;
                    }
                }
            }else if (indexPath.section==3){
                if (indexPath.row==0){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Makeup Settings"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                    
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
 
                }
            }else if (indexPath.section==4){
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"User Defined Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    GeneralLabel.text=[self returndetailschedulearraycount];
                    GeneralLabel.tag=408;
                    [cell.contentView addSubview:GeneralLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
            }else if (indexPath.section==5){
                //if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"No. of Level"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    NoOfLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    NoOfLevelLabel.font=[UIFont systemFontOfSize:15];
                    NoOfLevelLabel.textColor=[UIColor darkGrayColor];
                    NoOfLevelLabel.textAlignment=NSTextAlignmentRight;
                    NoOfLevelLabel.text=[@(workingSubject.levelArray.count) stringValue];
                    NoOfLevelLabel.tag=408;
                    [cell.contentView addSubview:NoOfLevelLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

            }else if (indexPath.section==6){
                if (showGradeTuition) {
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"No. of Grade"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    GeneralLabel.text=[@(tmpgradearray.count) stringValue];
                    GeneralLabel.tag=408;
                    [cell.contentView addSubview:GeneralLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else{
                    cell.hidden=YES;
                }
            }else if (indexPath.section==7){
                if (globalvariables.centerrecord.enablelessonnumber) {
                    if(indexPath.row==0){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Note Set 1"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:15];
                        GeneralLabel.textColor=[UIColor darkGrayColor];
                        GeneralLabel.textAlignment=NSTextAlignmentRight;
                        GeneralLabel.text=[@(((NSMutableArray *)workingSubject.lessonnumberDict[@"noteset1"]).count) stringValue];
                        GeneralLabel.tag=302;
                        [cell.contentView addSubview:GeneralLabel];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Note Set 2"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:15];
                        GeneralLabel.textColor=[UIColor darkGrayColor];
                        GeneralLabel.textAlignment=NSTextAlignmentRight;
                        GeneralLabel.text=[@(((NSMutableArray *)workingSubject.lessonnumberDict[@"noteset2"]).count) stringValue];
                        GeneralLabel.tag=302;
                        [cell.contentView addSubview:GeneralLabel];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                    
                }else{
                    cell.hidden=YES;
                }
                
            }else if (indexPath.section==8){
                if (globalvariables.centerrecord.enablechatbot){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Chatbot Settings"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                    
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
 
                }else{
                    cell.hidden=YES;
                }
            }else if (indexPath.section==9){
                
                RemarksText = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, 280, 150)];
                RemarksText.font=[UIFont systemFontOfSize:15];
                RemarksText.textColor=[UIColor blackColor];
                RemarksText.text=workingSubject.remarks;
                RemarksText.delegate=self;
                RemarksText.tag=403;
                [cell.contentView addSubview:RemarksText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==10){
                if (indexPath.row==0) {
                    if (showDeleteButton) {
                        deleteButton=[[UIButton alloc]init];
                        deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        deleteButton.frame=CGRectMake(73, 3, 175, 30);
                        deleteButton.titleLabel.font=[UIFont systemFontOfSize:15];
                        [deleteButton setTitle:[MyClass returntitlewithtitle:@"Delete Subject"] forState:UIControlStateNormal];
                        [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                        [deleteButton addTarget: self action:@selector(deleteSubject:) forControlEvents: UIControlEventTouchUpInside];
                        deleteButton.tag=701;
                        [cell.contentView addSubview:deleteButton];
                    }else{
                        cell.hidden=YES;
                    }
                    
                }
            }
        }else if([SubjectTableMode isEqualToString:@"Edit"]){
            
            //if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
            if (indexPath.section==0 ) {
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=@"English";
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        Subject_EnglishnameText=[[UITextField alloc]initWithFrame:CGRectMake(90, 0, 197, 35)];
                        Subject_EnglishnameText.font=[UIFont systemFontOfSize:15];
                        Subject_EnglishnameText.textColor=[UIColor darkGrayColor];
                        Subject_EnglishnameText.textAlignment=NSTextAlignmentRight;
                        Subject_EnglishnameText.text=workingSubject.subject_englishname;
                        Subject_EnglishnameText.adjustsFontSizeToFitWidth=YES;
                        Subject_EnglishnameText.minimumFontSize=0.7;
                        Subject_EnglishnameText.placeholder=@"English name";
                        [Subject_EnglishnameText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                        Subject_EnglishnameText.tag=408;
                        [cell.contentView addSubview:Subject_EnglishnameText];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        Subject_EnglishnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 2, 197, 31)];
                        Subject_EnglishnameLabel.font=[UIFont systemFontOfSize:15];
                        Subject_EnglishnameLabel.textColor=[UIColor darkGrayColor];
                        Subject_EnglishnameLabel.textAlignment=NSTextAlignmentRight;
                        Subject_EnglishnameLabel.text=workingSubject.subject_englishname;
                        Subject_EnglishnameLabel.adjustsFontSizeToFitWidth=YES;
                        Subject_EnglishnameLabel.minimumScaleFactor=0.7;
                        Subject_EnglishnameLabel.numberOfLines=0;
                        Subject_EnglishnameLabel.tag=302;
                        [cell.contentView addSubview:Subject_EnglishnameLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                    
                    
                }else if (indexPath.row==1){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=@"中文";
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        Subject_ChinesenameText=[[UITextField alloc]initWithFrame:CGRectMake(90, 0, 197, 35)];
                        Subject_ChinesenameText.font=[UIFont systemFontOfSize:15];
                        Subject_ChinesenameText.textColor=[UIColor darkGrayColor];
                        Subject_ChinesenameText.textAlignment=NSTextAlignmentRight;
                        Subject_ChinesenameText.text=workingSubject.subject_chinesename;
                        Subject_ChinesenameText.adjustsFontSizeToFitWidth=YES;
                        Subject_ChinesenameText.minimumFontSize=0.7;
                        Subject_ChinesenameText.placeholder=@"Chinese name";
                        [Subject_ChinesenameText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                        Subject_ChinesenameText.tag=408;
                        [cell.contentView addSubview:Subject_ChinesenameText];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        Subject_ChinesenameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 2, 197, 31)];
                        Subject_ChinesenameLabel.font=[UIFont systemFontOfSize:15];
                        Subject_ChinesenameLabel.textColor=[UIColor darkGrayColor];
                        Subject_ChinesenameLabel.textAlignment=NSTextAlignmentRight;
                        Subject_ChinesenameLabel.adjustsFontSizeToFitWidth=YES;
                        Subject_ChinesenameLabel.minimumScaleFactor=0.7;
                        Subject_ChinesenameLabel.numberOfLines=0;
                        Subject_ChinesenameLabel.text=workingSubject.subject_chinesename;
                        [cell.contentView addSubview:Subject_ChinesenameLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                }else if (indexPath.row==2){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Code"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 6, 200, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:10];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"(max 8 characters)"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        Subject_ShortnameText=[[UITextField alloc]initWithFrame:CGRectMake(222, 7, 65, 21)];
                        Subject_ShortnameText.font=[UIFont systemFontOfSize:15];
                        Subject_ShortnameText.textColor=[UIColor darkGrayColor];
                        Subject_ShortnameText.textAlignment=NSTextAlignmentRight;
                        Subject_ShortnameText.text=workingSubject.subject_shortname;
                        Subject_ShortnameText.placeholder=[MyClass returntitlewithtitle:@"Code"];
                        [Subject_ShortnameText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                        Subject_ShortnameText.tag=408;
                        [cell.contentView addSubview:Subject_ShortnameText];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        Subject_ShortnameLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                        Subject_ShortnameLabel.font=[UIFont systemFontOfSize:15];
                        Subject_ShortnameLabel.textColor=[UIColor darkGrayColor];
                        Subject_ShortnameLabel.textAlignment=NSTextAlignmentRight;
                        Subject_ShortnameLabel.text=workingSubject.subject_shortname;
                        [cell.contentView addSubview:Subject_ShortnameLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                }else if (indexPath.row==3){
                    //if (globalvariables.centerrecord.enableattendanceextend) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Category"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        Subject_CategoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 7, 177, 21)];
                        Subject_CategoryLabel.font=[UIFont systemFontOfSize:15];
                        Subject_CategoryLabel.minimumScaleFactor=0.7;
                        Subject_CategoryLabel.adjustsFontSizeToFitWidth=YES;
                        Subject_CategoryLabel.textColor=[UIColor darkGrayColor];
                        Subject_CategoryLabel.textAlignment=NSTextAlignmentRight;
                        Subject_CategoryLabel.text=[MyClass returnsubjectcategorynamewithscategorykey:workingSubject.subject_category];
                        Subject_CategoryLabel.tag=408;
                        [cell.contentView addSubview:Subject_CategoryLabel];
                        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }

                }else if (indexPath.row==4){
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Subject Color"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-24-33, 11, 24, 16)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.layer.masksToBounds=YES;
                    GeneralLabel.layer.cornerRadius=4;
                    GeneralLabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:workingSubject.colorcode];
                    [cell.contentView addSubview:GeneralLabel];

                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                }
            }else if (indexPath.section==1){
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Status"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        scStatus = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Active"],[MyClass returntitlewithtitle:@"Inactive"],nil]];
                        scStatus.frame = CGRectMake(90, 3, 215, 29);
                        [scStatus addTarget:self action:@selector(selectStatus:) forControlEvents: UIControlEventValueChanged];
                        scStatus.tintColor=themecolor;
                        
                        scStatus.selectedSegmentIndex=[workingSubject.status isEqualToString:@"Active"] ? 0:1;
                        [cell.contentView addSubview:scStatus];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        StatusLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                        StatusLabel.font=[UIFont systemFontOfSize:15];
                        StatusLabel.textColor=[UIColor darkGrayColor];
                        StatusLabel.textAlignment=NSTextAlignmentRight;
                        StatusLabel.text=[MyClass returntitlewithtitle:workingSubject.status];
                        StatusLabel.tag=302;
                        [cell.contentView addSubview:StatusLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                }else if (indexPath.row==1) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 150, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Max. Class Size"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[workingSubject.studentcapacity isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:workingSubject.studentcapacity;
                    StudentCapacityLabel.tag=408;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                }else if (indexPath.row==2){
                    if (showStudentCapacityPicker) {
                        
                        pickerViewmenu =[[NSMutableArray alloc]initWithObjects:@"",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30", nil];
                        
                        if ([pickerViewmenu containsObject:workingSubject.studentcapacity]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.studentcapacity];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==13) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Standard Period"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StandandPeriodLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    StandandPeriodLabel.font=[UIFont systemFontOfSize:15];
                    StandandPeriodLabel.textColor=[UIColor darkGrayColor];
                    StandandPeriodLabel.textAlignment=NSTextAlignmentRight;
                    
                    if (![workingSubject.standardnoofclassormonth isEqualToString:@""] && ![workingSubject.enrollmentmode isEqualToString:@""]) {
                        if ([workingSubject.standardnoofclassormonth intValue]>1) {
                            StandandPeriodLabel.text=[NSString stringWithFormat:@"%@ %@",workingSubject.standardnoofclassormonth,[workingSubject.enrollmentmode isEqualToString:@"Class"]?[MyClass returntitlewithtitle:@"Classes"]:[MyClass returntitlewithtitle:@"Months"]];
                        }else{
                            StandandPeriodLabel.text=[NSString stringWithFormat:@"%@ %@",workingSubject.standardnoofclassormonth,[workingSubject.enrollmentmode isEqualToString:@"Class"]?[MyClass returntitlewithtitle:@"Class"]:[MyClass returntitlewithtitle:@"Month"]];
                        }
                    }else{
                        StandandPeriodLabel.text=@"";
                    }
                    
                    //StandandPeriodLabel.text=tmpStandardNoOfClass;
                    StandandPeriodLabel.tag=408;
                    [cell.contentView addSubview:StandandPeriodLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                }else if (indexPath.row==14){
                    if (showStandardPeriodPicker) {
                        
                        if ([workingSubject.tuition_mode isEqualToString:@"Month"]) {
                            enrollmentmodearray =[[NSArray alloc]initWithObjects:@"Month", nil];
                        }else{
                            enrollmentmodearray =[[NSArray alloc]initWithObjects:@"Class",@"Month", nil];
                        }
                        
                        if ([standardnoofclassormontharray containsObject:workingSubject.standardnoofclassormonth]) {
                            standardnoofclassormonthpresetrow=(int)[standardnoofclassormontharray indexOfObject:workingSubject.standardnoofclassormonth];
                        }else{
                            standardnoofclassormonthpresetrow=0;
                        }

                        if ([enrollmentmodearray containsObject:workingSubject.enrollmentmode]) {
                            enrollmentmodepresetrow=(int)[enrollmentmodearray indexOfObject:workingSubject.enrollmentmode];
                        }else{
                            enrollmentmodepresetrow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:standardnoofclassormonthpresetrow inComponent:0 animated:NO];
                        [myPicker selectRow:enrollmentmodepresetrow inComponent:1 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==3) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Duration (Standard) in mins"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    ClassDurationLabel.font=[UIFont systemFontOfSize:15];
                    ClassDurationLabel.textColor=[UIColor darkGrayColor];
                    ClassDurationLabel.textAlignment=NSTextAlignmentRight;
                    ClassDurationLabel.text=workingSubject.classduration;
                    ClassDurationLabel.tag=408;
                    [cell.contentView addSubview:ClassDurationLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                }else if (indexPath.row==4){
                    if (showClassDurationPicker) {
                        
                        pickerViewmenu=[[NSMutableArray alloc]init];
                        for (int i=1; i<=12*60/5; i++) {
                            [pickerViewmenu addObject:[NSString stringWithFormat:@"%d",5*i]];
                        }
                        
                        if ([pickerViewmenu containsObject:workingSubject.classduration]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.classduration];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==5) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Duration (Assess) in mins"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassDurationAssessmentLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    ClassDurationAssessmentLabel.font=[UIFont systemFontOfSize:15];
                    ClassDurationAssessmentLabel.textColor=[UIColor darkGrayColor];
                    ClassDurationAssessmentLabel.textAlignment=NSTextAlignmentRight;
                    ClassDurationAssessmentLabel.text=workingSubject.classduration_assessment;
                    ClassDurationAssessmentLabel.tag=408;
                    [cell.contentView addSubview:ClassDurationAssessmentLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                }else if (indexPath.row==6){
                    if (showClassDurationAssessmentPicker) {
                        
                        pickerViewmenu=[[NSMutableArray alloc]init];
                        for (int i=1; i<=5*60/[globalvariables.centerrecord.classtimeinterval intValue]; i++) {
                            [pickerViewmenu addObject:[NSString stringWithFormat:@"%d",[globalvariables.centerrecord.classtimeinterval intValue]*i]];
                        }
                        
                        if ([pickerViewmenu containsObject:workingSubject.classduration_assessment]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.classduration_assessment];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==7) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Duration (Trial) in mins"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassDurationTrialLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    ClassDurationTrialLabel.font=[UIFont systemFontOfSize:15];
                    ClassDurationTrialLabel.textColor=[UIColor darkGrayColor];
                    ClassDurationTrialLabel.textAlignment=NSTextAlignmentRight;
                    ClassDurationTrialLabel.text=workingSubject.classduration_trial;
                    ClassDurationTrialLabel.tag=408;
                    [cell.contentView addSubview:ClassDurationTrialLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                }else if (indexPath.row==8){
                    if (showClassDurationTrialPicker) {
                        
                        pickerViewmenu=[[NSMutableArray alloc]init];
                        for (int i=1; i<=5*60/[globalvariables.centerrecord.classtimeinterval intValue]; i++) {
                            [pickerViewmenu addObject:[NSString stringWithFormat:@"%d",[globalvariables.centerrecord.classtimeinterval intValue]*i]];
                        }
                        
                        if ([pickerViewmenu containsObject:workingSubject.classduration_trial]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.classduration_trial];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==9) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Tuition By"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Tuition_MethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    Tuition_MethodLabel.font=[UIFont systemFontOfSize:15];
                    Tuition_MethodLabel.textColor=[UIColor darkGrayColor];
                    Tuition_MethodLabel.textAlignment=NSTextAlignmentRight;
                    Tuition_MethodLabel.text=[MyClass returntitlewithtitle:workingSubject.tuition_method];
                    Tuition_MethodLabel.tag=408;
                    [cell.contentView addSubview:Tuition_MethodLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                }else if (indexPath.row==10){
                    if (showTuitionMethodPicker) {
                        
                        pickerViewmenu =[[NSMutableArray alloc]initWithObjects:@"Level",@"Grade", nil];
                        
                        if ([pickerViewmenu containsObject:workingSubject.tuition_method]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.tuition_method];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==11) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Tuition Mode"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    Tuition_ModeLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    Tuition_ModeLabel.font=[UIFont systemFontOfSize:15];
                    Tuition_ModeLabel.textColor=[UIColor darkGrayColor];
                    Tuition_ModeLabel.textAlignment=NSTextAlignmentRight;
                    Tuition_ModeLabel.text=[MyClass returntitlewithtitle:workingSubject.tuition_mode];
                    Tuition_ModeLabel.tag=408;
                    [cell.contentView addSubview:Tuition_ModeLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                }else if (indexPath.row==12){
                    if (showTuitionModePicker) {
                        
                        pickerViewmenu =[[NSMutableArray alloc]initWithObjects:@"Class",@"Month", nil];
                        
                        if ([pickerViewmenu containsObject:workingSubject.tuition_mode]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.tuition_mode];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==15) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Pre-generate Period"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[@(workingSubject.pregenperiodcount) stringValue];
                    StudentCapacityLabel.tag=408;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                }else if (indexPath.row==16){
                    if (showPregenPeriodPicker) {
                        
                        pickerViewmenu =[[NSMutableArray alloc]initWithObjects:@"",@"1",@"2",@"3",@"4",@"5", nil];
                        
                        if ([pickerViewmenu containsObject:[@(workingSubject.pregenperiodcount) stringValue]]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:[@(workingSubject.pregenperiodcount) stringValue]];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==17) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Auto Level Upgrade"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[self returnautolevelupgradetitle:workingSubject.autolevelupgrade];
                    StudentCapacityLabel.tag=408;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                }
            }else if (indexPath.section==2){
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Weekly Auto Renew Default"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        swWeeklyScheduleAutoRenewal = [[UISwitch alloc] init];
                        swWeeklyScheduleAutoRenewal.onTintColor=themecolor;
                        CGSize switchSize = [swWeeklyScheduleAutoRenewal sizeThatFits:CGSizeZero];
                        swWeeklyScheduleAutoRenewal.frame = CGRectMake(255.0f,2.0f,switchSize.width,switchSize.height);
                        swWeeklyScheduleAutoRenewal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                        swWeeklyScheduleAutoRenewal.tag = 501;
                        [swWeeklyScheduleAutoRenewal addTarget:self action:@selector(selectweeklyautorenewdefault:) forControlEvents:UIControlEventValueChanged];
                        
                        swWeeklyScheduleAutoRenewal.on=workingSubject.weeklyautorenewdefault;
                        [cell.contentView addSubview:swWeeklyScheduleAutoRenewal];
                    }else{
                        WeeklyScheduleAutoRenewalLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                        WeeklyScheduleAutoRenewalLabel.font=[UIFont systemFontOfSize:15];
                        WeeklyScheduleAutoRenewalLabel.textColor=[UIColor darkGrayColor];
                        WeeklyScheduleAutoRenewalLabel.textAlignment=NSTextAlignmentRight;
                        WeeklyScheduleAutoRenewalLabel.text=[MyClass returntitlewithtitle:workingSubject.weeklyautorenewdefault?@"Yes":@"No"];
                        WeeklyScheduleAutoRenewalLabel.tag=302;
                        [cell.contentView addSubview:WeeklyScheduleAutoRenewalLabel];
                    }
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }else if (indexPath.row==1) {
                    if (globalvariables.centerrecord.enrollmentvalidity){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Validity"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        ValidityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                        ValidityLabel.font=[UIFont systemFontOfSize:15];
                        ValidityLabel.textColor=[UIColor darkGrayColor];
                        ValidityLabel.textAlignment=NSTextAlignmentRight;
                        ValidityLabel.text=[MyClass returnvaliditylabelwithvaliditystring:workingSubject.validity];
                        ValidityLabel.tag=408;
                        [cell.contentView addSubview:ValidityLabel];
                        if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        }else{
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                    }else{
                        cell.hidden=YES;
                    }
                }
            }else if (indexPath.section==3){
                if (indexPath.row==0){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Makeup Settings"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                    
//                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                    }else{
//                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    }
 
                }
            }else if (indexPath.section==4){
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"User Defined Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    GeneralLabel.text=[self returndetailschedulearraycount];
                    GeneralLabel.tag=408;
                    [cell.contentView addSubview:GeneralLabel];
//                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).edituserschedule){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                    }else{
//                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    }
                }
            }else if (indexPath.section==5){
                //if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"No. of Level"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    NoOfLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    NoOfLevelLabel.font=[UIFont systemFontOfSize:15];
                    NoOfLevelLabel.textColor=[UIColor darkGrayColor];
                    NoOfLevelLabel.textAlignment=NSTextAlignmentRight;
                    NoOfLevelLabel.text=[@(workingSubject.levelArray.count) stringValue];
                    NoOfLevelLabel.tag=408;
                    [cell.contentView addSubview:NoOfLevelLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                }else{
//                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                }

            }else if (indexPath.section==6){
                if (showGradeTuition) {
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"No. of Grade"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    GeneralLabel.text=[@(tmpgradearray.count) stringValue];
                    GeneralLabel.tag=408;
                    [cell.contentView addSubview:GeneralLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                    }else{
//                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    }
                    
                }else{
                    cell.hidden=YES;
                }
            }else if (indexPath.section==7){
                if (globalvariables.centerrecord.enablelessonnumber) {
                    if(indexPath.row==0){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Note Set 1"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:15];
                        GeneralLabel.textColor=[UIColor darkGrayColor];
                        GeneralLabel.textAlignment=NSTextAlignmentRight;
                        GeneralLabel.text=[@(((NSMutableArray *)workingSubject.lessonnumberDict[@"noteset1"]).count) stringValue];
                        GeneralLabel.tag=302;
                        [cell.contentView addSubview:GeneralLabel];
//                        if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                        }else{
//                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                        }
                    }else{
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Note Set 2"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:15];
                        GeneralLabel.textColor=[UIColor darkGrayColor];
                        GeneralLabel.textAlignment=NSTextAlignmentRight;
                        GeneralLabel.text=[@(((NSMutableArray *)workingSubject.lessonnumberDict[@"noteset2"]).count) stringValue];
                        GeneralLabel.tag=302;
                        [cell.contentView addSubview:GeneralLabel];
//                        if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                        }else{
//                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                        }
                    }
                    
                }else{
                    cell.hidden=YES;
                }
                
            }else if (indexPath.section==8){
                if (globalvariables.centerrecord.enablechatbot){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Chatbot Settings"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                    
//                    if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//                    }else{
//                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                    }
 
                }else{
                    cell.hidden=YES;
                }
            }else if (indexPath.section==9){
                if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject){
                    RemarksText = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, 280, 150)];
                    RemarksText.font=[UIFont systemFontOfSize:15];
                    RemarksText.textColor=[UIColor blackColor];
                    RemarksText.text=workingSubject.remarks;
                    RemarksText.delegate=self;
                    RemarksText.tag=403;
                    [cell.contentView addSubview:RemarksText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 280, 150)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentLeft;
                    GeneralLabel.numberOfLines=0;
                    GeneralLabel.text=subjectobject.remarks;
                    GeneralLabel.tag=302;
                    
                    [GeneralLabel sizeToFit];
                    CGRect myFrame=GeneralLabel.frame;
                    
                    if (myFrame.size.height>150) {
                        myFrame=CGRectMake(20, 0, 280, 150);
                    }else{
                        myFrame=CGRectMake(20, 3, 280, myFrame.size.height);
                    }
                    GeneralLabel.frame=myFrame;
                    
                    
                    [cell.contentView addSubview:GeneralLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
            }else if (indexPath.section==10){
                if (indexPath.row==0) {
                    if (showDeleteButton) {
                        deleteButton=[[UIButton alloc]init];
                        deleteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        deleteButton.frame=CGRectMake(73, 3, 175, 30);
                        deleteButton.titleLabel.font=[UIFont systemFontOfSize:15];
                        [deleteButton setTitle:[MyClass returntitlewithtitle:@"Delete Subject"] forState:UIControlStateNormal];
                        [deleteButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                        [deleteButton addTarget: self action:@selector(deleteSubject:) forControlEvents: UIControlEventTouchUpInside];
                        deleteButton.tag=701;
                        [cell.contentView addSubview:deleteButton];
                    }else{
                        cell.hidden=YES;
                    }
                    
                }
            }
        }
    }else if (tableView==CourseScheduleTable){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if ([CourseTableMode isEqualToString:@"Add"]) {
            if (indexPath.section==0 ) {
                if (indexPath.row==0) {
                    ScheduleNameText=[[UITextField alloc]initWithFrame:CGRectMake(20,7,courseschedulewidth-20-35, 21)];
                    ScheduleNameText.font=[UIFont systemFontOfSize:15];
                    ScheduleNameText.textColor=[UIColor darkGrayColor];
                    ScheduleNameText.textAlignment=NSTextAlignmentLeft;
                    ScheduleNameText.text=workingSchedule.name;
                    ScheduleNameText.minimumFontSize=0.5;
                    ScheduleNameText.adjustsFontSizeToFitWidth=YES;
                    ScheduleNameText.placeholder=[MyClass returntitlewithtitle:@"Schedule Name"];
                    [ScheduleNameText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    ScheduleNameText.tag=408;
                    [cell.contentView addSubview:ScheduleNameText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==1) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Type"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    scStatus = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Recursive Days"],[MyClass returntitlewithtitle:@"Fixed Dates"],nil]];
                    scStatus.frame = CGRectMake(90, 3, courseschedulewidth-90-20, 29);
                    [scStatus addTarget:self action:@selector(selectscheduletype:) forControlEvents: UIControlEventValueChanged];
                    scStatus.tag=601;
                    scStatus.tintColor=themecolor;
                    scStatus.selectedSegmentIndex=[workingSchedule.type isEqualToString:@"Recursive"] ? 0:1;
                    [cell.contentView addSubview:scStatus];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==2) {
                    if (![workingSchedule.type isEqualToString:@"Fixed"]) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 7, 45, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Day"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 45, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Time"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 7, 90, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Instructor"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 7, 100, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Room"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        // add add button
                        UIButton *addbutton=[[UIButton alloc]initWithFrame:CGRectMake(courseschedulewidth-25-7, 10-5, 25, 25)];
                        [addbutton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                        [addbutton setImage:[UIImage imageNamed:@"addphonebutton.png"] forState:UIControlStateNormal];
                        [addbutton addTarget: self action:@selector(addtimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                        [cell.contentView addSubview:addbutton];
                    }else{
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 7, 110, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Date/Time"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 7, 86, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Instructor"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(236, 7, 86, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Room"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        // add add button
                        UIButton *addbutton=[[UIButton alloc]initWithFrame:CGRectMake(courseschedulewidth-25-7, 10-5, 25, 25)];
                        [addbutton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                        [addbutton setImage:[UIImage imageNamed:@"addphonebutton.png"] forState:UIControlStateNormal];
                        [addbutton addTarget: self action:@selector(addtimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                        [cell.contentView addSubview:addbutton];
                    }

                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==3) {
                    if (![workingSchedule.type isEqualToString:@"Fixed"]) {
                        float rowheight=globalvariables.centerrecord.secondaryinstructor?35:30;
                        float topmargin=globalvariables.centerrecord.secondaryinstructor?0:6;
                        for (int i=0; i<workingSchedule.daytimearray.count; i++) {
                            ScheduleDetailsRecord *schedulerecord=[workingSchedule.daytimearray objectAtIndex:i];
                            UIButton *CSDayOfWeekButton=[[UIButton alloc]init];
                            CSDayOfWeekButton.tag=10000+i;
                            [CSDayOfWeekButton setFrame:CGRectMake(30, topmargin+i*rowheight, 45, 22)];
                            [CSDayOfWeekButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSDayOfWeekButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSDayOfWeekButton.layer.cornerRadius=5;
                            CSDayOfWeekButton.layer.masksToBounds=YES;
                            [CSDayOfWeekButton setTitle:[schedulerecord.dayofweek isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass returntitlewithtitle:schedulerecord.dayofweek] forState:UIControlStateNormal];
                            [CSDayOfWeekButton addTarget: self action:@selector(csdaytimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSDayOfWeekButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSDayOfWeekButton.tag==selecteddaytimebutton.tag) {
                                [CSDayOfWeekButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSDayOfWeekButton];
                            
                            UIButton *CSClassTimeButton=[[UIButton alloc]init];
                            CSClassTimeButton.tag=10000+i;
                            [CSClassTimeButton setFrame:CGRectMake(70, topmargin+i*rowheight, 50, 22)];
                            [CSClassTimeButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSClassTimeButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSClassTimeButton.layer.cornerRadius=5;
                            CSClassTimeButton.layer.masksToBounds=YES;
                            [CSClassTimeButton setTitle:[schedulerecord.classtime isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:schedulerecord.classtime forState:UIControlStateNormal];
                            [CSClassTimeButton addTarget: self action:@selector(csdaytimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSClassTimeButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSClassTimeButton.tag==selecteddaytimebutton.tag) {
                                [CSClassTimeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSClassTimeButton];
                            
                            UIButton *CSInstructorButton=[[UIButton alloc]init];
                            CSInstructorButton.tag=30000+i;
                            [CSInstructorButton setFrame:CGRectMake(115, topmargin+i*rowheight, 140, 22)];
                            [CSInstructorButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSInstructorButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSInstructorButton.layer.cornerRadius=5;
                            CSInstructorButton.layer.masksToBounds=YES;
                            [CSInstructorButton setTitle:[schedulerecord.instructor isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass returnstaffnamewithusername:schedulerecord.instructor firstorfullname:@"full"] forState:UIControlStateNormal];
                            
                            [CSInstructorButton addTarget: self action:@selector(csdaytimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSInstructorButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSInstructorButton.tag==selecteddaytimebutton.tag) {
                                //CSInstructorButton.backgroundColor=[UIColor systemGroupedBackgroundColor];
                                [CSInstructorButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSInstructorButton];
                            
                            if(globalvariables.centerrecord.secondaryinstructor){
                                UIButton *CSSInstructorButton=[[UIButton alloc]init];
                                CSSInstructorButton.tag=50000+i;
                                [CSSInstructorButton setFrame:CGRectMake(115, topmargin+i*rowheight+14, 140, 22)];
                                [CSSInstructorButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                                CSSInstructorButton.titleLabel.font=[UIFont systemFontOfSize:10.5];
                                CSSInstructorButton.layer.cornerRadius=5;
                                CSSInstructorButton.layer.masksToBounds=YES;
                                [CSSInstructorButton setTitle:[schedulerecord.sinstructor isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass returnstaffnamewithusername:schedulerecord.sinstructor firstorfullname:@"full"] forState:UIControlStateNormal];
                                
                                [CSSInstructorButton addTarget: self action:@selector(csdaytimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                                CSSInstructorButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                                if (CSSInstructorButton.tag==selecteddaytimebutton.tag) {
                                    //CSInstructorButton.backgroundColor=[UIColor systemGroupedBackgroundColor];
                                    [CSSInstructorButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                }
                                [cell.contentView addSubview:CSSInstructorButton];
                            }
                            
                            UIButton *CSClassroomButton=[[UIButton alloc]init];
                            CSClassroomButton.tag=40000+i;
                            [CSClassroomButton setFrame:CGRectMake(258, topmargin+i*rowheight, 70, 22)];
                            [CSClassroomButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSClassroomButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSClassroomButton.layer.cornerRadius=5;
                            CSClassroomButton.layer.masksToBounds=YES;
                            [CSClassroomButton setTitle:[schedulerecord.classroom isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:([schedulerecord.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:schedulerecord.classroom) forState:UIControlStateNormal];
                            [CSClassroomButton addTarget: self action:@selector(csdaytimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSClassroomButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSClassroomButton.tag==selecteddaytimebutton.tag) {
                                //CSClassroomButton.backgroundColor=[UIColor systemGroupedBackgroundColor];
                                [CSClassroomButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSClassroomButton];
                            
                            
                            // add delete button
                            if (workingSchedule.daytimearray.count>1) {
                                UIButton *deletebutton=[[UIButton alloc]initWithFrame:CGRectMake(courseschedulewidth-23-8, 10+i*rowheight-5, 23, 23)];
                                [deletebutton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                                [deletebutton setImage:[UIImage imageNamed:@"deletebutton.png"] forState:UIControlStateNormal];
                                [deletebutton addTarget: self action:@selector(deletetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                                deletebutton.tag=80000+i;
                                [cell.contentView addSubview:deletebutton];
                            }
                        }
                    }else{
                        float rowheight=globalvariables.centerrecord.secondaryinstructor?35:30;
                        float topmargin=globalvariables.centerrecord.secondaryinstructor?0:6;
                        for (int i=0; i<workingSchedule.daytimearray.count; i++) {
                            ScheduleDetailsRecord *schedulerecord=[workingSchedule.daytimearray objectAtIndex:i];
                            UIButton *CSDayOfWeekButton=[[UIButton alloc]init];
                            CSDayOfWeekButton.tag=10000+i;
                            [CSDayOfWeekButton setFrame:CGRectMake(30, topmargin+i*rowheight, 110, 22)];
                            [CSDayOfWeekButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSDayOfWeekButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSDayOfWeekButton.layer.cornerRadius=5;
                            CSDayOfWeekButton.layer.masksToBounds=YES;
                            [CSDayOfWeekButton setTitle:[schedulerecord.dayofweek isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass convertDateFormatWithDate:[NSString stringWithFormat:@"%@ %@",schedulerecord.dayofweek,schedulerecord.classtime] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd-MMM-yyyy HH:mm"] forState:UIControlStateNormal];
                            [CSDayOfWeekButton addTarget: self action:@selector(csdatetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSDayOfWeekButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSDayOfWeekButton.tag==selecteddaytimebutton.tag) {
                                [CSDayOfWeekButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSDayOfWeekButton];

                            UIButton *CSInstructorButton=[[UIButton alloc]init];
                            CSInstructorButton.tag=30000+i;
                            [CSInstructorButton setFrame:CGRectMake(145, topmargin+i*rowheight, 86, 22)];
                            [CSInstructorButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSInstructorButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSInstructorButton.layer.cornerRadius=5;
                            CSInstructorButton.layer.masksToBounds=YES;
                            [CSInstructorButton setTitle:[schedulerecord.instructor isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass returnstaffnamewithusername:schedulerecord.instructor firstorfullname:@"full"] forState:UIControlStateNormal];
                            
                            [CSInstructorButton addTarget: self action:@selector(csdatetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSInstructorButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSInstructorButton.tag==selecteddaytimebutton.tag) {
                                //CSInstructorButton.backgroundColor=[UIColor systemGroupedBackgroundColor];
                                [CSInstructorButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSInstructorButton];
                            
                            if(globalvariables.centerrecord.secondaryinstructor){
                                UIButton *CSSInstructorButton=[[UIButton alloc]init];
                                CSSInstructorButton.tag=50000+i;
                                [CSSInstructorButton setFrame:CGRectMake(145, topmargin+i*rowheight+14, 86, 22)];
                                [CSSInstructorButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                                CSSInstructorButton.titleLabel.font=[UIFont systemFontOfSize:10.5];
                                CSSInstructorButton.layer.cornerRadius=5;
                                CSSInstructorButton.layer.masksToBounds=YES;
                                [CSSInstructorButton setTitle:[schedulerecord.sinstructor isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass returnstaffnamewithusername:schedulerecord.sinstructor firstorfullname:@"full"] forState:UIControlStateNormal];
                                
                                [CSSInstructorButton addTarget: self action:@selector(csdatetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                                CSSInstructorButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                                if (CSSInstructorButton.tag==selecteddaytimebutton.tag) {
                                    //CSInstructorButton.backgroundColor=[UIColor systemGroupedBackgroundColor];
                                    [CSSInstructorButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                }
                                [cell.contentView addSubview:CSSInstructorButton];
                            }
                            
                            UIButton *CSClassroomButton=[[UIButton alloc]init];
                            CSClassroomButton.tag=40000+i;
                            [CSClassroomButton setFrame:CGRectMake(236, topmargin+i*rowheight, 86, 22)];
                            [CSClassroomButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSClassroomButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSClassroomButton.layer.cornerRadius=5;
                            CSClassroomButton.layer.masksToBounds=YES;
                            [CSClassroomButton setTitle:[schedulerecord.classroom isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:([schedulerecord.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:schedulerecord.classroom) forState:UIControlStateNormal];
                            [CSClassroomButton addTarget: self action:@selector(csdatetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSClassroomButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSClassroomButton.tag==selecteddaytimebutton.tag) {
                                //CSClassroomButton.backgroundColor=[UIColor systemGroupedBackgroundColor];
                                [CSClassroomButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSClassroomButton];
                            
                            
                            // add delete button
                            if (workingSchedule.daytimearray.count>1) {
                                UIButton *deletebutton=[[UIButton alloc]initWithFrame:CGRectMake(courseschedulewidth-23-8, 10+i*rowheight-5, 23, 23)];
                                [deletebutton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                                [deletebutton setImage:[UIImage imageNamed:@"deletebutton.png"] forState:UIControlStateNormal];
                                [deletebutton addTarget: self action:@selector(deletetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                                deletebutton.tag=80000+i;
                                [cell.contentView addSubview:deletebutton];
                            }
                        }
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==4) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Active"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    UISwitch *swautorenew = [[UISwitch alloc] init];
                    swautorenew.onTintColor=themecolor;
                    CGSize switchSize = [swautorenew sizeThatFits:CGSizeZero];
                    swautorenew.frame = CGRectMake(242.0f,1.8f,switchSize.width,switchSize.height);
                    swautorenew.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swautorenew.tag = 501;
                    [swautorenew addTarget:self action:@selector(switchactive:) forControlEvents:UIControlEventValueChanged];
                    
                    swautorenew.on=workingSchedule.active;
                    
                    [cell.contentView addSubview:swautorenew];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==5) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Auto Renew"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    UISwitch *swautorenew = [[UISwitch alloc] init];
                    swautorenew.onTintColor=themecolor;
                    CGSize switchSize = [swautorenew sizeThatFits:CGSizeZero];
                    swautorenew.frame = CGRectMake(242.0f,1.8f,switchSize.width,switchSize.height);
                    swautorenew.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swautorenew.tag = 501;
                    [swautorenew addTarget:self action:@selector(switchautorenew:) forControlEvents:UIControlEventValueChanged];
                    swautorenew.enabled=![workingSchedule.type isEqualToString:@"Fixed"];
                    if ([workingSchedule.autorenew isEqualToString:@"Yes"]) {
                        swautorenew.on=YES;
                    }else{
                        swautorenew.on=NO;
                    }
                    
                    [cell.contentView addSubview:swautorenew];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==6) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Makeup Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    UISwitch *swautorenew = [[UISwitch alloc] init];
                    swautorenew.onTintColor=themecolor;
                    CGSize switchSize = [swautorenew sizeThatFits:CGSizeZero];
                    swautorenew.frame = CGRectMake(242.0f,1.8f,switchSize.width,switchSize.height);
                    swautorenew.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swautorenew.tag = 501;
                    [swautorenew addTarget:self action:@selector(switchmakeupschedule:) forControlEvents:UIControlEventValueChanged];

                    swautorenew.on=workingSchedule.makeupschedule;
                    
                    [cell.contentView addSubview:swautorenew];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==7) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Online Trial Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    UISwitch *swautorenew = [[UISwitch alloc] init];
                    swautorenew.onTintColor=themecolor;
                    CGSize switchSize = [swautorenew sizeThatFits:CGSizeZero];
                    swautorenew.frame = CGRectMake(242.0f,1.8f,switchSize.width,switchSize.height);
                    swautorenew.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swautorenew.tag = 501;
                    [swautorenew addTarget:self action:@selector(switchonlinetrialschedule:) forControlEvents:UIControlEventValueChanged];

                    swautorenew.on=workingSchedule.onlinetrialschedule;
                    
                    [cell.contentView addSubview:swautorenew];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.hidden=!globalvariables.centerrecord.enablechatbot;
                    
                }else if (indexPath.row==8) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Show In Timetable If No Enrollment"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    UISwitch *swautorenew = [[UISwitch alloc] init];
                    swautorenew.onTintColor=themecolor;
                    CGSize switchSize = [swautorenew sizeThatFits:CGSizeZero];
                    swautorenew.frame = CGRectMake(242.0f,1.8f,switchSize.width,switchSize.height);
                    swautorenew.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swautorenew.tag = 501;
                    [swautorenew addTarget:self action:@selector(switchshowintimetableifnoenrollment:) forControlEvents:UIControlEventValueChanged];

                    swautorenew.on=workingSchedule.showintimetableifnoenrollment;
                    
                    [cell.contentView addSubview:swautorenew];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==9) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Start Date"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(courseschedulewidth-200-35, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    
                    
                    if ([workingSchedule.startdate isEqualToString:@""]) {
                        GeneralLabel.text=[workingSchedule.type isEqualToString:@"Fixed"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returntitlewithtitle:@"Optional"];
                    }else{
                        GeneralLabel.text=[MyClass returndateformatwithdate:workingSchedule.startdate];
                    }
                    
                    
                    GeneralLabel.adjustsFontSizeToFitWidth=YES;
                    GeneralLabel.minimumScaleFactor=0.7;
                    GeneralLabel.tag=302;
                    [cell.contentView addSubview:GeneralLabel];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;

                    if ([[self filtercstimearray:workingSchedule.daytimearray] count]==0 || [workingSchedule.type isEqualToString:@"Fixed"]) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                }else if (indexPath.row==10) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"End Date"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(courseschedulewidth-200-35, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    if ([workingSchedule.enddate isEqualToString:@""]) {
                        GeneralLabel.text=[workingSchedule.type isEqualToString:@"Fixed"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returntitlewithtitle:@"Optional"];
                    }else{
                        GeneralLabel.text=[MyClass returndateformatwithdate:workingSchedule.enddate];
                    }
                    GeneralLabel.adjustsFontSizeToFitWidth=YES;
                    GeneralLabel.minimumScaleFactor=0.7;
                    GeneralLabel.tag=302;
                    [cell.contentView addSubview:GeneralLabel];
                    if ([[self filtercstimearray:workingSchedule.daytimearray] count]==0 || [workingSchedule.type isEqualToString:@"Fixed"]) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                    
                }else if (indexPath.row==11) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Makeup Level"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(courseschedulewidth-200-35, 7, 200, 100)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    GeneralLabel.numberOfLines=0;
                    GeneralLabel.text=[self returnlevelwithlevelarray:workingSchedule.levelarray];
                    [GeneralLabel sizeToFit];
                    GeneralLabel.frame=CGRectMake(courseschedulewidth-200-35, 7, 200,GeneralLabel.frame.size.height);
//                    GeneralLabel.adjustsFontSizeToFitWidth=YES;
//                    GeneralLabel.minimumScaleFactor=0.7;
                    GeneralLabel.tag=302;
                    [cell.contentView addSubview:GeneralLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
            }
        }else if ([CourseTableMode isEqualToString:@"View"]){
            int daytitlepos=35+12;
            int dayvaluepos=32;
            float rowheight=globalvariables.centerrecord.secondaryinstructor?30:20;
            
            ScheduleRecord *scheduleobj=[filteredScheduleArray objectAtIndex:indexPath.row];
            
            GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, courseschedulewidth-100, 21)];
            GeneralLabel.font=[UIFont boldSystemFontOfSize:15];
            GeneralLabel.textColor=[UIColor blackColor];
            GeneralLabel.text=scheduleobj.active?scheduleobj.name:[NSString stringWithFormat:@"%@-%@",[MyClass returntitlewithtitle:@"Inactive"],scheduleobj.name];
            GeneralLabel.tag=301;
            [cell.contentView addSubview:GeneralLabel];
            
            GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 25, courseschedulewidth-100, 21)];
            GeneralLabel.font=[UIFont boldSystemFontOfSize:10];
            GeneralLabel.textColor=[UIColor darkGrayColor];
            
            if(![scheduleobj.schedulekey isEqualToString:@""]){
                GeneralLabel.text=[NSString stringWithFormat:@"%@ (%@:ID%@)",[scheduleobj.type isEqualToString:@"Fixed"]?[MyClass returntitlewithtitle:@"Fixed Dates"]:[MyClass returntitlewithtitle:@"Recursive Days"],[MyClass returntitlewithtitle:@"Schedule"],scheduleobj.schedulekey];
            }else{
                GeneralLabel.text=[scheduleobj.type isEqualToString:@"Fixed"]?[MyClass returntitlewithtitle:@"Fixed Dates"]:[MyClass returntitlewithtitle:@"Recursive Days"];
            }
            
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(courseschedulewidth-50, 29, 15, 15)];
            [imageview setImage:[UIImage imageNamed:@"classtimetable_rounded_icon.png"]];
            imageview.layer.opacity=scheduleobj.showintimetableifnoenrollment?1.0:0.2;
            [cell.contentView addSubview:imageview];
            
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(imageview.frame.origin.x-19, 29, 15, 15)];
            [imageview setImage:[UIImage imageNamed:@"chatbot_icon.png"]];
            imageview.layer.opacity=scheduleobj.onlinetrialschedule?1.0:0.2;
            [cell.contentView addSubview:imageview];
            
            
            GeneralLabel.tag=301;
            [cell.contentView addSubview:GeneralLabel];

            if([SubjectTableMode isEqualToString:@"Add"] || ([SubjectTableMode isEqualToString:@"Edit"] && (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).edituserschedule))){
                UIButton *cloneButton=[[UIButton alloc]init];
                cloneButton.tag=indexPath.row;
                [cloneButton setFrame:CGRectMake(courseschedulewidth-75, 7, 40, 21)];
                [cloneButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                cloneButton.titleLabel.font=[UIFont systemFontOfSize:13];
                [cloneButton setTitle:[MyClass returntitlewithtitle:@"Clone"] forState:UIControlStateNormal];
                [cloneButton addTarget: self action:@selector(cloneschedulebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                cloneButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
                [cell.contentView addSubview:cloneButton];
            }

            if (![scheduleobj.type isEqualToString:@"Fixed"]) {
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, daytitlepos, courseschedulewidth-60, 30)];
                GeneralLabel.backgroundColor=[UIColor systemGroupedBackgroundColor];
                [cell.contentView addSubview:GeneralLabel];
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, daytitlepos, courseschedulewidth-60, 1)];
                GeneralLabel.font=[UIFont systemFontOfSize:15];
                GeneralLabel.backgroundColor=[UIColor grayColor];
                [cell.contentView addSubview:GeneralLabel];
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, daytitlepos, 45, 30)];
                GeneralLabel.font=[UIFont systemFontOfSize:14];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Day"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, daytitlepos, 45, 30)];
                GeneralLabel.font=[UIFont systemFontOfSize:14];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Time"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, daytitlepos, 120, 30)];
                GeneralLabel.font=[UIFont systemFontOfSize:14];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Instructor"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, daytitlepos, 70, 30)];
                GeneralLabel.font=[UIFont systemFontOfSize:14];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Room"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                

                
                
                
                for (int i=0; i<scheduleobj.daytimearray.count; i++) {
                    ScheduleDetailsRecord *obj=[scheduleobj.daytimearray objectAtIndex:i];
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, daytitlepos+dayvaluepos+i*rowheight, 45, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:11.5];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:obj.dayofweek];
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, daytitlepos+dayvaluepos+i*rowheight, 45, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:11.5];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.text=obj.classtime;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, daytitlepos+dayvaluepos+i*rowheight, 135, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:11.5];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.text=[MyClass returnstaffnamewithusername:obj.instructor firstorfullname:@"full"];
                    [cell.contentView addSubview:GeneralLabel];
                    
                    if(globalvariables.centerrecord.secondaryinstructor){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, daytitlepos+dayvaluepos+i*rowheight+14, 135, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:10.5];
                        GeneralLabel.textColor=[UIColor darkGrayColor];
                        GeneralLabel.text=[MyClass returnstaffnamewithusername:obj.sinstructor firstorfullname:@"full"];
                        [cell.contentView addSubview:GeneralLabel];
                    }
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, daytitlepos+dayvaluepos+i*rowheight, 70, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:11.5];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.text=[obj.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:obj.classroom;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    
                }
            }else{
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, daytitlepos, courseschedulewidth-60, 30)];
                GeneralLabel.backgroundColor=[UIColor systemGroupedBackgroundColor];
                [cell.contentView addSubview:GeneralLabel];
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, daytitlepos, courseschedulewidth-60, 1)];
                GeneralLabel.font=[UIFont systemFontOfSize:15];
                GeneralLabel.backgroundColor=[UIColor grayColor];
                [cell.contentView addSubview:GeneralLabel];
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, daytitlepos, 110, 30)];
                GeneralLabel.font=[UIFont systemFontOfSize:14];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Date/Time"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, daytitlepos, 86, 30)];
                GeneralLabel.font=[UIFont systemFontOfSize:14];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Instructor"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(236, daytitlepos, 86, 30)];
                GeneralLabel.font=[UIFont systemFontOfSize:14];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Room"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                

                
                
                for (int i=0; i<scheduleobj.daytimearray.count; i++) {
                    ScheduleDetailsRecord *obj=[scheduleobj.daytimearray objectAtIndex:i];
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, daytitlepos+dayvaluepos+i*rowheight, 110, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:11.5];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.text=[MyClass convertDateFormatWithDate:[NSString stringWithFormat:@"%@ %@",obj.dayofweek,obj.classtime] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd-MM-yyyy HH:mm" Translate:YES];
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, daytitlepos+dayvaluepos+i*rowheight, 86, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:11.5];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.text=[MyClass returnstaffnamewithusername:obj.instructor firstorfullname:@"full"];
                    [cell.contentView addSubview:GeneralLabel];
                    
                    if(globalvariables.centerrecord.secondaryinstructor){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, daytitlepos+dayvaluepos+i*rowheight+14, 86, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:10.5];
                        GeneralLabel.textColor=[UIColor darkGrayColor];
                        GeneralLabel.text=[MyClass returnstaffnamewithusername:obj.sinstructor firstorfullname:@"full"];
                        [cell.contentView addSubview:GeneralLabel];
                    }
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(236, daytitlepos+dayvaluepos+i*rowheight, 86, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:11.5];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.text=[obj.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:obj.classroom;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    
                }
            }
            
            
            
            GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 5+daytitlepos+dayvaluepos+scheduleobj.daytimearray.count*rowheight, courseschedulewidth-60, 1)];
            
            GeneralLabel.font=[UIFont systemFontOfSize:15];
            GeneralLabel.backgroundColor=[UIColor grayColor];
            [cell.contentView addSubview:GeneralLabel];

            
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(25, 15+daytitlepos+dayvaluepos+scheduleobj.daytimearray.count*rowheight, 18, 18)];
            if ([scheduleobj.autorenew isEqualToString:@"Yes"]) {
//                [imageview setImage:[UIImage imageNamed:@"passed_icon.png"]];
                imageview.layer.opacity=1.0;
            }else{
                imageview.layer.opacity=0.3;
//                [imageview setImage:[UIImage imageNamed:@"failed_icon.png"]];
            }
            [imageview setImage:[UIImage imageNamed:@"classrenewal_icon.png"]];
            
            imageview.layer.cornerRadius=4;
            imageview.layer.masksToBounds=YES;
            [cell.contentView addSubview:imageview];
            
            GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(47, 15+daytitlepos+dayvaluepos+scheduleobj.daytimearray.count*rowheight, 300, 21)];
            GeneralLabel.font=[UIFont systemFontOfSize:13];
            GeneralLabel.textColor=[UIColor darkGrayColor];
            GeneralLabel.text=[MyClass returntitlewithtitle:@"Auto Renew"];
            GeneralLabel.tag=301;
            [cell.contentView addSubview:GeneralLabel];
            
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(203, 15+daytitlepos+dayvaluepos+scheduleobj.daytimearray.count*rowheight, 18, 18)];
            if (scheduleobj.makeupschedule) {
                imageview.layer.opacity=1.0;
            }else{
                imageview.layer.opacity=0.3;
            }
            [imageview setImage:[UIImage imageNamed:@"makeup_icon.png"]];
            imageview.layer.cornerRadius=imageview.frame.size.height/2;
            imageview.layer.masksToBounds=YES;
            [cell.contentView addSubview:imageview];
            
            GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(225, 15+daytitlepos+dayvaluepos+scheduleobj.daytimearray.count*rowheight, 300, 21)];
            GeneralLabel.font=[UIFont systemFontOfSize:13];
            GeneralLabel.textColor=[UIColor darkGrayColor];
            GeneralLabel.text=[MyClass returntitlewithtitle:@"Makeup Schedule"];
            GeneralLabel.tag=301;
            [cell.contentView addSubview:GeneralLabel];
            
//            CGFloat waterlevel=15+daytitlepos+dayvaluepos+scheduleobj.daytimearray.count*rowheight;
            if (![scheduleobj.startdate isEqualToString:@""] || ![scheduleobj.enddate isEqualToString:@""]) {
                imageview=[[UIImageView alloc]initWithFrame:CGRectMake(25, 42+daytitlepos+dayvaluepos+scheduleobj.daytimearray.count*rowheight, 18, 18)];
                [imageview setImage:[UIImage imageNamed:@"start_icon.png"]];
                imageview.layer.cornerRadius=imageview.frame.size.height/2;
                imageview.layer.masksToBounds=YES;
                [cell.contentView addSubview:imageview];
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 40+daytitlepos+dayvaluepos+scheduleobj.daytimearray.count*rowheight, courseschedulewidth-55-60, 21)];
                GeneralLabel.font=[UIFont systemFontOfSize:13];
                GeneralLabel.textColor=[UIColor darkGrayColor];
                GeneralLabel.text=[scheduleobj.startdate isEqualToString:@""]?@"-":[MyClass returndateformatwithdate:scheduleobj.startdate];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                imageview=[[UIImageView alloc]initWithFrame:CGRectMake(203, 42+daytitlepos+dayvaluepos+scheduleobj.daytimearray.count*rowheight, 18, 18)];
                [imageview setImage:[UIImage imageNamed:@"end_icon.png"]];
                imageview.layer.cornerRadius=imageview.frame.size.height/2;
                imageview.layer.masksToBounds=YES;
                [cell.contentView addSubview:imageview];
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(225, 40+daytitlepos+dayvaluepos+scheduleobj.daytimearray.count*rowheight, courseschedulewidth-55-60, 21)];
                GeneralLabel.font=[UIFont systemFontOfSize:13];
                GeneralLabel.textColor=[UIColor darkGrayColor];
                GeneralLabel.text=[scheduleobj.enddate isEqualToString:@""]?@"-":[MyClass returndateformatwithdate:scheduleobj.enddate];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
            }
            
            if(!scheduleobj.levelarray || scheduleobj.levelarray.count>0){
                imageview=[[UIImageView alloc]initWithFrame:CGRectMake(25, imageview.frame.origin.y+27, 18, 18)];
                [imageview setImage:[UIImage imageNamed:@"level_icon.png"]];
                imageview.layer.cornerRadius=imageview.frame.size.height/2;
                imageview.layer.masksToBounds=YES;
                [cell.contentView addSubview:imageview];
                
                UILabel *generallabel = [[UILabel alloc]initWithFrame:CGRectMake(48, imageview.frame.origin.y, courseschedulewidth-48-34, 100)];
                generallabel.font=[UIFont systemFontOfSize:13];
                generallabel.textColor=[UIColor darkGrayColor];
                generallabel.numberOfLines=0;
                generallabel.textAlignment=NSTextAlignmentLeft;
                generallabel.text=[self returnlevelwithlevelarray:scheduleobj.levelarray];
                [generallabel sizeToFit];
                generallabel.frame=CGRectMake(48, imageview.frame.origin.y, courseschedulewidth-48-34, generallabel.frame.size.height);
                generallabel.tag=301;
                [cell.contentView addSubview:generallabel];
                
            }
            
            if ([SubjectTableMode isEqualToString:@"Add"] || ([SubjectTableMode isEqualToString:@"Edit"] && (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).edituserschedule))) {
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }else{
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            if ([scheduleobj.action isEqualToString:@"Delete"] || [scheduleobj.schedulekey intValue]<0) {
                cell.hidden=YES;
            }


        }else if ([CourseTableMode isEqualToString:@"Edit"]){
            if (indexPath.section==0 ) {
                if (indexPath.row==0) {
                    /*GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Schedule Name"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];*/
                    
                    ScheduleNameText=[[UITextField alloc]initWithFrame:CGRectMake(20,7,courseschedulewidth-20-35,21)];
                    ScheduleNameText.font=[UIFont systemFontOfSize:14];
                    ScheduleNameText.textColor=[UIColor darkGrayColor];
                    ScheduleNameText.textAlignment=NSTextAlignmentLeft;
                    ScheduleNameText.text=workingSchedule.name;
                    ScheduleNameText.minimumFontSize=0.5;
                    ScheduleNameText.adjustsFontSizeToFitWidth=YES;
                    ScheduleNameText.placeholder=[MyClass returntitlewithtitle:@"Schedule Name"];
                    [ScheduleNameText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    ScheduleNameText.tag=408;
                    [cell.contentView addSubview:ScheduleNameText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Type"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    scStatus = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Recursive Days"],[MyClass returntitlewithtitle:@"Fixed Dates"],nil]];
                    scStatus.frame = CGRectMake(90, 3, courseschedulewidth-90-20, 29);
                    [scStatus addTarget:self action:@selector(selectscheduletype:) forControlEvents: UIControlEventValueChanged];
                    scStatus.tag=601;
                    scStatus.tintColor=themecolor;
                    scStatus.selectedSegmentIndex=[workingSchedule.type isEqualToString:@"Recursive"] ? 0:1;
                    [cell.contentView addSubview:scStatus];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==2) {
                    if (![workingSchedule.type isEqualToString:@"Fixed"]) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 7, 45, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Day"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 45, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Time"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 7, 90, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Instructor"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(260, 7, 100, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Room"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        // add add button
                        UIButton *addbutton=[[UIButton alloc]initWithFrame:CGRectMake(courseschedulewidth-25-7, 10-5, 25, 25)];
                        [addbutton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                        [addbutton setImage:[UIImage imageNamed:@"addphonebutton.png"] forState:UIControlStateNormal];
                        [addbutton addTarget: self action:@selector(addtimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                        [cell.contentView addSubview:addbutton];
                    }else{
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 7, 110, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Date/Time"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 7, 86, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Instructor"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(236, 7, 86, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:14];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Room"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        // add add button
                        UIButton *addbutton=[[UIButton alloc]initWithFrame:CGRectMake(courseschedulewidth-25-7, 10-5, 25, 25)];
                        [addbutton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                        [addbutton setImage:[UIImage imageNamed:@"addphonebutton.png"] forState:UIControlStateNormal];
                        [addbutton addTarget: self action:@selector(addtimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                        [cell.contentView addSubview:addbutton];
                    }

                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==3) {
                    float rowheight=globalvariables.centerrecord.secondaryinstructor?35:30;
                    float topmargin=globalvariables.centerrecord.secondaryinstructor?0:6;
                    if (![workingSchedule.type isEqualToString:@"Fixed"]) {
                        for (int i=0; i<workingSchedule.daytimearray.count; i++) {
                            ScheduleDetailsRecord *schedulerecord=[workingSchedule.daytimearray objectAtIndex:i];
                            UIButton *CSDayOfWeekButton=[[UIButton alloc]init];
                            CSDayOfWeekButton.tag=10000+i;
                            [CSDayOfWeekButton setFrame:CGRectMake(30, topmargin+i*rowheight, 45, 22)];
                            [CSDayOfWeekButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSDayOfWeekButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSDayOfWeekButton.layer.cornerRadius=5;
                            CSDayOfWeekButton.layer.masksToBounds=YES;
                            [CSDayOfWeekButton setTitle:[schedulerecord.dayofweek isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass returntitlewithtitle:schedulerecord.dayofweek] forState:UIControlStateNormal];
                            [CSDayOfWeekButton addTarget: self action:@selector(csdaytimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSDayOfWeekButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSDayOfWeekButton.tag==selecteddaytimebutton.tag) {
                                [CSDayOfWeekButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSDayOfWeekButton];
                            
                            UIButton *CSClassTimeButton=[[UIButton alloc]init];
                            CSClassTimeButton.tag=10000+i;
                            [CSClassTimeButton setFrame:CGRectMake(70, topmargin+i*rowheight, 50, 22)];
                            [CSClassTimeButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSClassTimeButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSClassTimeButton.layer.cornerRadius=5;
                            CSClassTimeButton.layer.masksToBounds=YES;
                            [CSClassTimeButton setTitle:[schedulerecord.classtime isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:schedulerecord.classtime forState:UIControlStateNormal];
                            [CSClassTimeButton addTarget: self action:@selector(csdaytimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSClassTimeButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSClassTimeButton.tag==selecteddaytimebutton.tag) {
                                [CSClassTimeButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSClassTimeButton];
                            
                            UIButton *CSInstructorButton=[[UIButton alloc]init];
                            CSInstructorButton.tag=30000+i;
                            [CSInstructorButton setFrame:CGRectMake(115, topmargin+i*rowheight, 140, 22)];
                            [CSInstructorButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSInstructorButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSInstructorButton.layer.cornerRadius=5;
                            CSInstructorButton.layer.masksToBounds=YES;
                            [CSInstructorButton setTitle:[schedulerecord.instructor isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass returnstaffnamewithusername:schedulerecord.instructor firstorfullname:@"full"] forState:UIControlStateNormal];
                            
                            [CSInstructorButton addTarget: self action:@selector(csdaytimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSInstructorButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSInstructorButton.tag==selecteddaytimebutton.tag) {
                                //CSInstructorButton.backgroundColor=[UIColor systemGroupedBackgroundColor];
                                [CSInstructorButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSInstructorButton];
                            
                            if(globalvariables.centerrecord.secondaryinstructor){
                                UIButton *CSSInstructorButton=[[UIButton alloc]init];
                                CSSInstructorButton.tag=50000+i;
                                [CSSInstructorButton setFrame:CGRectMake(115, topmargin+i*rowheight+14, 140, 22)];
                                [CSSInstructorButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                                CSSInstructorButton.titleLabel.font=[UIFont systemFontOfSize:10.5];
                                CSSInstructorButton.layer.cornerRadius=5;
                                CSSInstructorButton.layer.masksToBounds=YES;
                                [CSSInstructorButton setTitle:[schedulerecord.sinstructor isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass returnstaffnamewithusername:schedulerecord.sinstructor firstorfullname:@"full"] forState:UIControlStateNormal];
                                
                                [CSSInstructorButton addTarget: self action:@selector(csdaytimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                                CSSInstructorButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                                if (CSSInstructorButton.tag==selecteddaytimebutton.tag) {
                                    //CSInstructorButton.backgroundColor=[UIColor systemGroupedBackgroundColor];
                                    [CSSInstructorButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                }
                                [cell.contentView addSubview:CSSInstructorButton];
                            }
                            
                            UIButton *CSClassroomButton=[[UIButton alloc]init];
                            CSClassroomButton.tag=40000+i;
                            [CSClassroomButton setFrame:CGRectMake(258, topmargin+i*rowheight, 70, 22)];
                            [CSClassroomButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSClassroomButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSClassroomButton.layer.cornerRadius=5;
                            CSClassroomButton.layer.masksToBounds=YES;
                            [CSClassroomButton setTitle:[schedulerecord.classroom isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:([schedulerecord.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:schedulerecord.classroom) forState:UIControlStateNormal];
                            [CSClassroomButton addTarget: self action:@selector(csdaytimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSClassroomButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSClassroomButton.tag==selecteddaytimebutton.tag) {
                                //CSClassroomButton.backgroundColor=[UIColor systemGroupedBackgroundColor];
                                [CSClassroomButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSClassroomButton];
                            
                            
                            // add delete button
                            if (workingSchedule.daytimearray.count>1) {
                                UIButton *deletebutton=[[UIButton alloc]initWithFrame:CGRectMake(courseschedulewidth-23-8, 10+i*rowheight-5, 23, 23)];
                                [deletebutton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                                [deletebutton setImage:[UIImage imageNamed:@"deletebutton.png"] forState:UIControlStateNormal];
                                [deletebutton addTarget: self action:@selector(deletetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                                deletebutton.tag=80000+i;
                                [cell.contentView addSubview:deletebutton];
                            }
                        }
                    }else{
                        float rowheight=globalvariables.centerrecord.secondaryinstructor?35:30;
                        float topmargin=globalvariables.centerrecord.secondaryinstructor?0:6;
                        for (int i=0; i<workingSchedule.daytimearray.count; i++) {
                            ScheduleDetailsRecord *schedulerecord=[workingSchedule.daytimearray objectAtIndex:i];
                            UIButton *CSDayOfWeekButton=[[UIButton alloc]init];
                            CSDayOfWeekButton.tag=10000+i;
                            [CSDayOfWeekButton setFrame:CGRectMake(30, topmargin+i*rowheight, 110, 22)];
                            [CSDayOfWeekButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSDayOfWeekButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSDayOfWeekButton.layer.cornerRadius=5;
                            CSDayOfWeekButton.layer.masksToBounds=YES;
                            [CSDayOfWeekButton setTitle:[schedulerecord.dayofweek isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass convertDateFormatWithDate:[NSString stringWithFormat:@"%@ %@",schedulerecord.dayofweek,schedulerecord.classtime] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd-MMM-yyyy HH:mm"] forState:UIControlStateNormal];
                            [CSDayOfWeekButton addTarget: self action:@selector(csdatetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSDayOfWeekButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSDayOfWeekButton.tag==selecteddaytimebutton.tag) {
                                [CSDayOfWeekButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSDayOfWeekButton];

                            UIButton *CSInstructorButton=[[UIButton alloc]init];
                            CSInstructorButton.tag=30000+i;
                            [CSInstructorButton setFrame:CGRectMake(145, topmargin+i*rowheight, 86, 22)];
                            [CSInstructorButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSInstructorButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSInstructorButton.layer.cornerRadius=5;
                            CSInstructorButton.layer.masksToBounds=YES;
                            [CSInstructorButton setTitle:[schedulerecord.instructor isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass returnstaffnamewithusername:schedulerecord.instructor firstorfullname:@"full"] forState:UIControlStateNormal];
                            
                            [CSInstructorButton addTarget: self action:@selector(csdatetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSInstructorButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSInstructorButton.tag==selecteddaytimebutton.tag) {
                                //CSInstructorButton.backgroundColor=[UIColor systemGroupedBackgroundColor];
                                [CSInstructorButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSInstructorButton];
                            
                            if(globalvariables.centerrecord.secondaryinstructor){
                                UIButton *CSSInstructorButton=[[UIButton alloc]init];
                                CSSInstructorButton.tag=50000+i;
                                [CSSInstructorButton setFrame:CGRectMake(145, topmargin+i*rowheight+14, 86, 22)];
                                [CSSInstructorButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                                CSSInstructorButton.titleLabel.font=[UIFont systemFontOfSize:10.5];
                                CSSInstructorButton.layer.cornerRadius=5;
                                CSSInstructorButton.layer.masksToBounds=YES;
                                [CSSInstructorButton setTitle:[schedulerecord.sinstructor isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass returnstaffnamewithusername:schedulerecord.sinstructor firstorfullname:@"full"] forState:UIControlStateNormal];
                                
                                [CSSInstructorButton addTarget: self action:@selector(csdatetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                                CSSInstructorButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                                if (CSSInstructorButton.tag==selecteddaytimebutton.tag) {
                                    //CSInstructorButton.backgroundColor=[UIColor systemGroupedBackgroundColor];
                                    [CSSInstructorButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                }
                                [cell.contentView addSubview:CSSInstructorButton];
                            }
                            
                            UIButton *CSClassroomButton=[[UIButton alloc]init];
                            CSClassroomButton.tag=40000+i;
                            [CSClassroomButton setFrame:CGRectMake(236, topmargin+i*rowheight, 86, 22)];
                            [CSClassroomButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                            CSClassroomButton.titleLabel.font=[UIFont systemFontOfSize:11.5];
                            CSClassroomButton.layer.cornerRadius=5;
                            CSClassroomButton.layer.masksToBounds=YES;
                            [CSClassroomButton setTitle:[schedulerecord.classroom isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:([schedulerecord.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:schedulerecord.classroom) forState:UIControlStateNormal];
                            [CSClassroomButton addTarget: self action:@selector(csdatetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                            CSClassroomButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                            if (CSClassroomButton.tag==selecteddaytimebutton.tag) {
                                //CSClassroomButton.backgroundColor=[UIColor systemGroupedBackgroundColor];
                                [CSClassroomButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                            }
                            [cell.contentView addSubview:CSClassroomButton];
                            
                            
                            // add delete button
                            if (workingSchedule.daytimearray.count>1) {
                                UIButton *deletebutton=[[UIButton alloc]initWithFrame:CGRectMake(courseschedulewidth-23-8, 10+i*30-5, 23, 23)];
                                [deletebutton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
                                [deletebutton setImage:[UIImage imageNamed:@"deletebutton.png"] forState:UIControlStateNormal];
                                [deletebutton addTarget: self action:@selector(deletetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                                deletebutton.tag=80000+i;
                                [cell.contentView addSubview:deletebutton];
                            }
                        }
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }/*else if (indexPath.row==4){
                    if (![workingSchedule.type isEqualToString:@"Fixed"]) {
                        if (showcsClasstimePicker==YES) {
                            
                            
                            UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, courseschedulewidth, 150)];
                            UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake((courseschedulewidth-300)/2, 0, 300, 150)];
                            [myPicker setDataSource:self];
                            [myPicker setDelegate:self];
                            myPicker.tag=801;
                            

                            
                            hourPresetRow=(int)[hourPickerViewMenu indexOfObject:[[workingScheduleDetails.classtime substringFromIndex:[workingScheduleDetails.classtime length]-5] substringToIndex:2]];
                            minutePresetRow=(int)[minutePickerViewMenu indexOfObject:[workingScheduleDetails.classtime substringFromIndex:[workingScheduleDetails.classtime length]-2]];
                            dayPresentRow=[dayPickerViewMenu indexOfObject:workingScheduleDetails.dayofweek];
                            
                            [myPicker selectRow:dayPresentRow inComponent:0 animated:NO];
                            [myPicker selectRow:hourPresetRow inComponent:1 animated:NO];
                            [myPicker selectRow:minutePresetRow inComponent:2 animated:NO];
                            
                            [myPicker setShowsSelectionIndicator:YES];
                            myPickerView=myPicker;
                            [datepickerview addSubview:myPicker];
                            
                            [cell.contentView addSubview:datepickerview];

                        }else{
                            cell.hidden=YES;
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }else{
                        if (showDatePicker==YES) {
                            
                            selectedItem=@"DateTime";
                            CalendarView *calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, popoverwidth, 200) Theme:0 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@""];
                            [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:workingScheduleDetails.dayofweek,nil] ScrollToDate:nil instructorselected:nil];
                            calendarview.delegate=self;

                            [cell.contentView addSubview:calendarview];
                            
                            hourPresetRow=(int)[hourPickerViewMenu indexOfObject:[workingScheduleDetails.classtime substringToIndex:2]];
                            minutePresetRow=(int)[minutePickerViewMenu indexOfObject:[workingScheduleDetails.classtime substringFromIndex:3]];
                            
                            UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, popoverwidth, 162)];
                            myPicker.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.03];
                            [myPicker setDataSource:self];
                            [myPicker setDelegate:self];
                            myPicker.tag=801;
                            

                            [myPicker selectRow:hourPresetRow inComponent:0 animated:NO];
                            [myPicker selectRow:minutePresetRow inComponent:1 animated:NO];
                            
                            [myPicker setShowsSelectionIndicator:YES];
                            myPickerView=myPicker;
                            [cell.contentView addSubview:myPicker];
                        }else{
                            cell.hidden=YES;
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                }*/else if (indexPath.row==4) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Active"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    UISwitch *swautorenew = [[UISwitch alloc] init];
                    swautorenew.onTintColor=themecolor;
                    CGSize switchSize = [swautorenew sizeThatFits:CGSizeZero];
                    swautorenew.frame = CGRectMake(242.0f,1.8f,switchSize.width,switchSize.height);
                    swautorenew.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swautorenew.tag = 501;
                    [swautorenew addTarget:self action:@selector(switchactive:) forControlEvents:UIControlEventValueChanged];
                    

                    swautorenew.on=workingSchedule.active;

                    
                    [cell.contentView addSubview:swautorenew];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==5) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Auto Renew"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    UISwitch *swautorenew = [[UISwitch alloc] init];
                    swautorenew.onTintColor=themecolor;
                    CGSize switchSize = [swautorenew sizeThatFits:CGSizeZero];
                    swautorenew.frame = CGRectMake(242.0f,1.8f,switchSize.width,switchSize.height);
                    swautorenew.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swautorenew.tag = 501;
                    [swautorenew addTarget:self action:@selector(switchautorenew:) forControlEvents:UIControlEventValueChanged];
                    swautorenew.enabled=![workingSchedule.type isEqualToString:@"Fixed"];
                    
                    if ([workingSchedule.autorenew isEqualToString:@"Yes"]) {
                        swautorenew.on=YES;
                    }else{
                        swautorenew.on=NO;
                    }
                    
                    [cell.contentView addSubview:swautorenew];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==6) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Makeup Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    UISwitch *swautorenew = [[UISwitch alloc] init];
                    swautorenew.onTintColor=themecolor;
                    CGSize switchSize = [swautorenew sizeThatFits:CGSizeZero];
                    swautorenew.frame = CGRectMake(242.0f,1.8f,switchSize.width,switchSize.height);
                    swautorenew.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swautorenew.tag = 501;
                    [swautorenew addTarget:self action:@selector(switchmakeupschedule:) forControlEvents:UIControlEventValueChanged];
                    
                    swautorenew.on=workingSchedule.makeupschedule;
                    
                    [cell.contentView addSubview:swautorenew];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==7) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Online Trial Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    UISwitch *swautorenew = [[UISwitch alloc] init];
                    swautorenew.onTintColor=themecolor;
                    CGSize switchSize = [swautorenew sizeThatFits:CGSizeZero];
                    swautorenew.frame = CGRectMake(242.0f,1.8f,switchSize.width,switchSize.height);
                    swautorenew.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swautorenew.tag = 501;
                    [swautorenew addTarget:self action:@selector(switchonlinetrialschedule:) forControlEvents:UIControlEventValueChanged];
                    
                    swautorenew.on=workingSchedule.onlinetrialschedule;
                    
                    [cell.contentView addSubview:swautorenew];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.hidden=!globalvariables.centerrecord.enablechatbot;
                    
                }else if (indexPath.row==8) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 280, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Show In Timetable If No Enrollment"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    UISwitch *swautorenew = [[UISwitch alloc] init];
                    swautorenew.onTintColor=themecolor;
                    CGSize switchSize = [swautorenew sizeThatFits:CGSizeZero];
                    swautorenew.frame = CGRectMake(242.0f,1.8f,switchSize.width,switchSize.height);
                    swautorenew.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swautorenew.tag = 501;
                    [swautorenew addTarget:self action:@selector(switchshowintimetableifnoenrollment:) forControlEvents:UIControlEventValueChanged];
                    
                    swautorenew.on=workingSchedule.showintimetableifnoenrollment;
                    
                    [cell.contentView addSubview:swautorenew];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==9) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Start Date"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(courseschedulewidth-200-35, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    if ([workingSchedule.startdate isEqualToString:@""]) {
                        GeneralLabel.text=[workingSchedule.type isEqualToString:@"Fixed"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returntitlewithtitle:@"Optional"];
                    }else{
                        GeneralLabel.text=[MyClass returndateformatwithdate:workingSchedule.startdate];
                    }
                    GeneralLabel.adjustsFontSizeToFitWidth=YES;
                    GeneralLabel.minimumScaleFactor=0.7;
                    GeneralLabel.tag=302;
                    [cell.contentView addSubview:GeneralLabel];
                    if ([[self filtercstimearray:workingSchedule.daytimearray] count]==0 || [workingSchedule.type isEqualToString:@"Fixed"]) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                    
                }else if (indexPath.row==10) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"End Date"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(courseschedulewidth-200-35, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    if ([workingSchedule.enddate isEqualToString:@""]) {
                        GeneralLabel.text=[workingSchedule.type isEqualToString:@"Fixed"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returntitlewithtitle:@"Optional"];
                    }else{
                        GeneralLabel.text=[MyClass returndateformatwithdate:workingSchedule.enddate];
                    }
                    GeneralLabel.adjustsFontSizeToFitWidth=YES;
                    GeneralLabel.minimumScaleFactor=0.7;
                    GeneralLabel.tag=302;
                    [cell.contentView addSubview:GeneralLabel];
                    if ([[self filtercstimearray:workingSchedule.daytimearray] count]==0 || [workingSchedule.type isEqualToString:@"Fixed"]) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                    
                }else if (indexPath.row==11) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Makeup Level"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(courseschedulewidth-200-35, 7, 200, 100)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    GeneralLabel.text=[self returnlevelwithlevelarray:workingSchedule.levelarray];
                    GeneralLabel.numberOfLines=0;
                    [GeneralLabel sizeToFit];
                    GeneralLabel.frame=CGRectMake(courseschedulewidth-200-35, 7, 200,GeneralLabel.frame.size.height);
//                    GeneralLabel.adjustsFontSizeToFitWidth=YES;
//                    GeneralLabel.minimumScaleFactor=0.7;
                    
                    GeneralLabel.tag=302;
                    [cell.contentView addSubview:GeneralLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
            }else if (indexPath.section==1){
                UIButton *deleterecord=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, courseschedulewidth, 35)];
                //deleterecord = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                deleterecord.titleLabel.font=[UIFont systemFontOfSize:15];
                deleterecord.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                [deleterecord addTarget: self action:@selector(deleteScheduleRecord) forControlEvents: UIControlEventTouchUpInside];
                [deleterecord setTitle:[MyClass returntitlewithtitle:@"Delete Schedule Record"] forState:UIControlStateNormal];
                [deleterecord setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                
                [cell.contentView addSubview:deleterecord];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }else if (tableView==LevelTuitionTable){
        
        MyTableViewCell *myCell;
        //configure cell
        
        if ([SubjectTableMode isEqualToString:@"View"] || ([SubjectTableMode isEqualToString:@"Edit"] && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject)) {
            static NSString *CellIdentifier= @"viewCell";
            myCell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (myCell == nil) {
                myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            if ([workingSubject.tuition_method isEqualToString:@"Grade"]) {
                myCell.label1.text=((LevelRecord *)[workingSubject.levelArray objectAtIndex:indexPath.row]).level;
                myCell.label2.hidden=YES;
                myCell.label3.hidden=YES;
                myCell.label4.hidden=YES;
                myCell.view1.hidden=YES;
            }else{
                tuitionobject=[workingSubject.tuitionArray objectAtIndex:indexPath.row];
                myCell.label1.text=tuitionobject.scale;
                myCell.label2.hidden=NO;
                myCell.label3.hidden=NO;
                myCell.label4.hidden=NO;
                myCell.view1.hidden=NO;
                
                myCell.label2.text=[tuitionobject.tuitionfee isEqualToString:@""] ? @"":[NSString stringWithFormat:@"$%@",tuitionobject.tuitionfee];
                myCell.label3.text=[tuitionobject.newtuitionfee isEqualToString:@""] ? @"-":[NSString stringWithFormat:@"$%@",tuitionobject.newtuitionfee];
                myCell.label4.text=[tuitionobject.effectivedate isEqualToString:@""] ? @"-":[MyClass convertDateFormatWithDate:tuitionobject.effectivedate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
            }
            
            LevelRecord *levelobj=[workingSubject.levelArray objectAtIndex:indexPath.row];
            if (globalvariables.centerrecord.jumptonextlevelduringrenewal) {
                myCell.label5.hidden=NO;
                myCell.label5.text=[levelobj.earlieststartdate isEqualToString:@""] ? @"-":[MyClass convertDateFormatWithDate:levelobj.earlieststartdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
            }else{
                myCell.label5.hidden=YES;
            }
            
        }else{
            static NSString *CellIdentifier= @"editCell";
            myCell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (myCell == nil) {
                myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }

            myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Level"];
            [myCell.textfield1 addTarget:self action:@selector(updatelevel:) forControlEvents:UIControlEventEditingChanged];
            
            
            
            
            if ([workingSubject.tuition_method isEqualToString:@"Level"]) {
                tuitionobject=[workingSubject.tuitionArray objectAtIndex:indexPath.row];
                myCell.textfield1.text=tuitionobject.scale;
                myCell.textfield2.text=tuitionobject.tuitionfee;
                myCell.textfield3.text=tuitionobject.newtuitionfee;
                myCell.textfield2.hidden=NO;
                myCell.textfield3.hidden=NO;
                myCell.button1.hidden=NO;
                myCell.view1.hidden=NO;
                
                [myCell.textfield2 addTarget:self action:@selector(updateleveltuitionfee:)forControlEvents:UIControlEventEditingChanged];
                myCell.textfield2.placeholder=[MyClass returntitlewithtitle:@"Tuition"];
                
                [myCell.textfield3 addTarget:self action:@selector(updatelevelnewtuitionfee:)forControlEvents:UIControlEventEditingChanged];
                myCell.textfield3.placeholder=[MyClass returntitlewithtitle:@"New Tuition"];
                
                [myCell.button1 setTitle:[tuitionobject.effectivedate isEqualToString:@""]?[MyClass returntitlewithtitle:@"Effective Date"]:[MyClass convertDateFormatWithDate:tuitionobject.effectivedate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES] forState:UIControlStateNormal];
                
                myCell.button1.tag=indexPath.row;
                [myCell.button1 addTarget:self action:@selector(tuitionleveleffectivedatepressed:) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                myCell.textfield1.text=((LevelRecord *)[workingSubject.levelArray objectAtIndex:indexPath.row]).level;
                myCell.textfield2.hidden=YES;
                myCell.textfield3.hidden=YES;
                myCell.button1.hidden=YES;
                myCell.view1.hidden=YES;
            }
            
            LevelRecord *levelobj=[workingSubject.levelArray objectAtIndex:indexPath.row];
            if (globalvariables.centerrecord.jumptonextlevelduringrenewal) {
                myCell.button2.hidden=NO;
                [myCell.button2 setTitle:[levelobj.earlieststartdate isEqualToString:@""]?[MyClass returntitlewithtitle:@"Earliest Start"]:[MyClass convertDateFormatWithDate:levelobj.earlieststartdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES] forState:UIControlStateNormal];
                
                myCell.button2.tag=indexPath.row;
                [myCell.button2 addTarget:self action:@selector(tuitionlevelearliestdatepressed:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                myCell.button2.hidden=YES;
            }
            
        }
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return myCell;
        
    }else if (tableView==GradeTuitionTable){
        MyTableViewCell *myCell;
        
        if ([workingSubject.tuition_method isEqualToString:@"Grade"]) {
            if ([SubjectTableMode isEqualToString:@"View"] || ([SubjectTableMode isEqualToString:@"Edit"] && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject)) {
                
                static NSString *CellIdentifier= @"viewCell";
                myCell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                tuitionobject=[self findgradetuitionobjectwithgrade:[tmpgradearray objectAtIndex:indexPath.row] tuitionarray:workingSubject.tuitionArray];
                
                myCell.label1.text=[tmpgradearray objectAtIndex:indexPath.row];
                myCell.label2.text=[tuitionobject.tuitionfee isEqualToString:@""] ? @"":[NSString stringWithFormat:@"$%@",tuitionobject.tuitionfee];
                myCell.label3.text=[tuitionobject.newtuitionfee isEqualToString:@""] ? @"-":[NSString stringWithFormat:@"$%@",tuitionobject.newtuitionfee];
                myCell.label4.text=[tuitionobject.effectivedate isEqualToString:@""] ? @"-":[MyClass convertDateFormatWithDate:tuitionobject.effectivedate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                
//                GT_gradetuitionlabel.hidden=NO;
//                GT_gradetuitiontext.hidden=YES;
                
                
//                GT_gradetuitionlabel.text=[self findgradetuitionfeewithgrade:[tmpgradearray objectAtIndex:indexPath.row] tuitionarray:workingSubject.tuitionArray mode:SubjectTableMode];
            }else{
                
                static NSString *CellIdentifier= @"editCell";
                myCell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                tuitionobject=[self findgradetuitionobjectwithgrade:[tmpgradearray objectAtIndex:indexPath.row] tuitionarray:workingSubject.tuitionArray];
                
                myCell.textfield1.text=tuitionobject.scale;
                myCell.textfield2.text=tuitionobject.tuitionfee;
                myCell.textfield3.text=tuitionobject.newtuitionfee;
                
                [myCell.textfield2 addTarget:self action:@selector(updategradetuitionfee:)forControlEvents:UIControlEventEditingChanged];
                myCell.textfield2.placeholder=[MyClass returntitlewithtitle:@"Tuition"];
                
                [myCell.textfield3 addTarget:self action:@selector(updategradenewtuitionfee:)forControlEvents:UIControlEventEditingChanged];
                myCell.textfield3.placeholder=[MyClass returntitlewithtitle:@"New Tuition"];
                
                [myCell.button1 setTitle:[tuitionobject.effectivedate isEqualToString:@""]?[MyClass returntitlewithtitle:@"Effective Date"]:[MyClass convertDateFormatWithDate:tuitionobject.effectivedate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES] forState:UIControlStateNormal];
                
                myCell.button1.tag=indexPath.row;
                [myCell.button1 addTarget:self action:@selector(tuitiongradeeffectivedatepressed:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
        
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return myCell;
        
    }else if (tableView==SubjectCategoryTable){
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            SC_CategoryNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, subjectcategorytablewidth-65, 38)];
            SC_CategoryNameLabel.font=[UIFont systemFontOfSize:15];
            SC_CategoryNameLabel.textColor=[UIColor darkGrayColor];
            SC_CategoryNameLabel.tag=1200;
            [cell.contentView addSubview:SC_CategoryNameLabel];
            
            
            SC_CategorySelectedImageView = [[UIImageView alloc]initWithFrame:CGRectMake(subjectcategorytablewidth-65, 7, 24, 24)];
            [SC_CategorySelectedImageView setImage:[UIImage imageNamed:@"checked_icon.png"]];
            SC_CategorySelectedImageView.tag=1202;
            [cell.contentView addSubview:SC_CategorySelectedImageView];
            
            
            SC_MoreButton = [[UIButton alloc]initWithFrame:CGRectMake(subjectcategorytablewidth-30, 6.5, 25, 25)];
            [SC_MoreButton setImage:[UIImage imageNamed:@"classinformation_icon.png"] forState:UIControlStateNormal];
            SC_MoreButton.titleLabel.font=[UIFont systemFontOfSize:12];
            SC_MoreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [SC_MoreButton addTarget: self action:@selector(subjectcategorymorebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
            SC_MoreButton.tag=1203;
            [cell.contentView addSubview:SC_MoreButton];
            
        }else{
            SC_CategoryNameLabel=(UILabel *)[cell.contentView viewWithTag:1200];
            SC_CategorySelectedImageView=(UIImageView *)[cell.contentView viewWithTag:1202];
            SC_MoreButton=(UIButton *)[cell.contentView viewWithTag:1203];
        }
        
        if(showChatBotCategoryTable){
            SC_CategoryNameLabel.text=[MyClass returnsubjectcategorynamewithscategorykey:((SubjectCategoryRecord *)[filteredSubjectCategoryArray objectAtIndex:indexPath.row]).scategorykey];
            SC_CategorySelectedImageView.hidden=[((SubjectCategoryRecord *)[filteredSubjectCategoryArray objectAtIndex:indexPath.row]).scategorykey isEqualToString:workingSubject.chatbot_category]?NO:YES;
        }else{
            SC_CategoryNameLabel.text=[MyClass returnsubjectcategorynamewithscategorykey:((SubjectCategoryRecord *)[filteredSubjectCategoryArray objectAtIndex:indexPath.row]).scategorykey];
            SC_CategorySelectedImageView.hidden=[((SubjectCategoryRecord *)[filteredSubjectCategoryArray objectAtIndex:indexPath.row]).scategorykey isEqualToString:workingSubject.subject_category]?NO:YES;
        }
        
        
        if (indexPath.row==0) {
            SC_MoreButton.hidden=YES;
        }else{
            SC_MoreButton.hidden=NO;
        }
    }else if (tableView==ValidityTable){

        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        if (showValidity) {
            int typePresetRow=0;
            int valuePresetRow=0;
            
            if ([workingSubject.validity isEqualToString:@""]) {
                typePresetRow=0;
                valuePresetRow=0;
                workingSubject.validity=@"D1";
                ValidityLabel.text=[MyClass returnvaliditylabelwithvaliditystring:workingSubject.validity];
            }else{
                if ([[workingSubject.validity substringToIndex:1] isEqualToString:@"D"]) {
                    typePresetRow=0;
                }else if ([[workingSubject.validity substringToIndex:1] isEqualToString:@"W"]) {
                    typePresetRow=1;
                }else if ([[workingSubject.validity substringToIndex:1] isEqualToString:@"M"]) {
                    typePresetRow=2;
                }else if ([[workingSubject.validity substringToIndex:1] isEqualToString:@"Y"]) {
                    typePresetRow=3;
                }
                valuePresetRow=(int)[validtyValuePickerViewMenu indexOfObject:[workingSubject.validity substringFromIndex:1]];
            }
            
            UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];

            
            UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(15, 5, 290, 150)];
            [myPicker setDataSource:self];
            [myPicker setDelegate:self];
            myPicker.tag=802;
            
            [myPicker selectRow:valuePresetRow inComponent:0 animated:NO];
            [myPicker selectRow:typePresetRow inComponent:1 animated:NO];
            
            [myPicker setShowsSelectionIndicator:YES];
            myPickerView=myPicker;
            [datepickerview addSubview:myPicker];
            
            [cell.contentView addSubview:datepickerview];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }

    }else if (tableView==MakeupTable){
        if([SubjectTableMode isEqualToString:@"View"] || ([SubjectTableMode isEqualToString:@"Edit"]  && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editmakeupsettings )){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            if (indexPath.section==0){
                //if(globalvariables.centerrecord.enablemakeupquota){
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                GeneralLabel.font=[UIFont systemFontOfSize:17];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Makeup Quota"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                StudentCapacityLabel.text=globalvariables.centerrecord.enablemakeupquota?[MyClass returnQuotaSringWithUnit:workingSubject.makeup_quota_unit Value:workingSubject.makeup_quota_value]:[MyClass returntitlewithtitle:@"Disabled"];
                StudentCapacityLabel.tag=302;
                [cell.contentView addSubview:StudentCapacityLabel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                /*}else{
                 cell.hidden=YES;
                 }*/
            }else if (indexPath.section==1) {
                if(indexPath.row==0){
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"To Makeup Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[MyClass returntitlewithtitle:workingSubject.leaveday_by_makeupschedule?@"Yes":@"No"];
                    StudentCapacityLabel.tag=302;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"To Enrolled Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[MyClass returntitlewithtitle:workingSubject.leaveday_by_enrolledschedule?@"Yes":@"No"];
                    StudentCapacityLabel.tag=302;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                }else if (indexPath.row==2){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"To Existing Lesson"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[MyClass returntitlewithtitle:workingSubject.leaveday_by_classdate?@"Yes":@"No"];
                    StudentCapacityLabel.tag=302;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                }
            }else if (indexPath.section==2){
                if (indexPath.row==0){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Same Instructor's Lesson"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[MyClass returntitlewithtitle:workingSubject.leaveday_follow_teacher?@"Yes":@"No"];;
                    StudentCapacityLabel.tag=302;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                }else if (indexPath.row==1){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Same Level"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[MyClass returntitlewithtitle:workingSubject.leaveday_follow_level?@"Yes":@"No"];;
                    StudentCapacityLabel.tag=302;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                }else if (indexPath.row==2){
                    if (globalvariables.centerrecord.enablelessonnumber) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Same Lesson"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                        StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                        StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                        StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                        StudentCapacityLabel.text=[MyClass returntitlewithtitle:workingSubject.leaveday_follow_lesson?@"Yes":@"No"];;
                        StudentCapacityLabel.tag=302;
                        [cell.contentView addSubview:StudentCapacityLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.hidden=NO;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==3){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Apply Staff Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[MyClass returntitlewithtitle:workingSubject.leaveday_by_staffschedule?@"Yes":@"No"];;
                    StudentCapacityLabel.tag=302;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==4){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Include Same Category"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[MyClass returntitlewithtitle:workingSubject.leaveday_follow_category?@"Yes":@"No"];;
                    StudentCapacityLabel.tag=302;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==5){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Allow Same Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[MyClass returntitlewithtitle:workingSubject.allowsameschedule?@"Yes":@"No"];;
                    StudentCapacityLabel.tag=302;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==6){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:[globalvariables.language isEqualToString:@"English"]?CGRectMake(20, 0, 180, 50):CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.numberOfLines=0;
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Can Apply Makeup if No Timeslot Available"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[MyClass returntitlewithtitle:workingSubject.showmakeupbuttonifnotimeslot?@"Yes":@"No"];;
                    StudentCapacityLabel.tag=302;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==7){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:[globalvariables.language isEqualToString:@"English"]?CGRectMake(20, 0, 200, 50):CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.numberOfLines=0;
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Show Absent Button when Arranging Makeup"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                    StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                    StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                    StudentCapacityLabel.text=[MyClass returntitlewithtitle:workingSubject.showabsentbuttononarrangeleave?@"Yes":@"No"];;
                    StudentCapacityLabel.tag=302;
                    [cell.contentView addSubview:StudentCapacityLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }else{ //edit or add
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            if (indexPath.section==0){
                if (indexPath.row==0){
                    if (!globalvariables.centerrecord.enablemakeupquota){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Makeup Quota"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        StudentCapacityLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                        StudentCapacityLabel.font=[UIFont systemFontOfSize:15];
                        StudentCapacityLabel.textColor=[UIColor darkGrayColor];
                        StudentCapacityLabel.textAlignment=NSTextAlignmentRight;
                        StudentCapacityLabel.text=[MyClass returntitlewithtitle:@"Disabled"];
                        StudentCapacityLabel.tag=408;
                        [cell.contentView addSubview:StudentCapacityLabel];
                        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        if ([workingSubject.enrollmentmode isEqualToString:@"Month"]) {
                            //                            makeupQuotaUnitArray =[[NSArray alloc]initWithObjects:@"Unlimited",@"Percentage",@"Fixed", nil];
                            scStatus = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Unlimited"],[MyClass returntitlewithtitle:@"Percentage"],[MyClass returntitlewithtitle:@"Fixed"],nil]];
                            scStatus.selectedSegmentIndex=[workingSubject.makeup_quota_value isEqualToString:@"-1"] ? 0:[workingSubject.makeup_quota_unit isEqualToString:@"P"]?1:2;
                        }else{
                            //                            makeupQuotaUnitArray =[[NSArray alloc]initWithObjects:@"Unlimited",@"Percentage", nil];
                            scStatus = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Unlimited"],[MyClass returntitlewithtitle:@"Percentage"],nil]];
                            scStatus.selectedSegmentIndex=[workingSubject.makeup_quota_value isEqualToString:@"-1"] ? 0:1;
                        }
                        
                        scStatus.frame = CGRectMake(20, 3, 285, 29);
                        [scStatus addTarget:self action:@selector(selectMakeupQuotaType:) forControlEvents: UIControlEventValueChanged];
                        scStatus.tintColor=themecolor;
                        
                        
                        [cell.contentView addSubview:scStatus];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }
                    //                    if(globalvariables.centerrecord.enablemakeupquota){
                    //                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    //                    }else{
                    //                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    //                    }
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==1){
                    if (![workingSubject.makeup_quota_value isEqualToString:@"-1"]) {
                        
                        //                        if ([workingSubject.enrollmentmode isEqualToString:@"Month"]) {
                        //                            makeupQuotaUnitArray =[[NSArray alloc]initWithObjects:@"Unlimited",@"Percentage",@"Fixed", nil];
                        //                        }else{
                        //                            makeupQuotaUnitArray =[[NSArray alloc]initWithObjects:@"Unlimited",@"Percentage", nil];
                        //                        }
                        //
                        //                        pickerViewmenu =[[NSMutableArray alloc]init];
                        //                        if (![workingSubject.makeup_quota_unit isEqualToString:@""]) {
                        //                            for (int i=0; i<201; i++) {
                        //                                [pickerViewmenu addObject:[@(i) stringValue]];
                        //
                        //                            }
                        //                        }
                        //
                        //
                        //                        NSInteger unitpresent;
                        //                        if([workingSubject.makeup_quota_value isEqualToString:@"-1"]){
                        //                            unitpresent=0;
                        //                        }else{
                        //                            unitpresent=[workingSubject.makeup_quota_unit isEqualToString:@"P"]?1:2;
                        //                        }
                        //
                        //                        if ([pickerViewmenu containsObject:workingSubject.makeup_quota_value]) {
                        //                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.makeup_quota_value];
                        //                        }else{
                        //                            presetRow=0;
                        //                        }
                        //
                        //                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        //                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        //                        [myPicker setDataSource:self];
                        //                        [myPicker setDelegate:self];
                        //                        myPicker.tag=802;
                        //
                        //                        [myPicker selectRow:unitpresent inComponent:0 animated:NO];
                        //
                        //                        if(![workingSubject.makeup_quota_unit isEqualToString:@""]){
                        //                            [myPicker selectRow:presetRow inComponent:1 animated:NO];
                        //                        }
                        //
                        //
                        //
                        //
                        //
                        //                        [myPicker setShowsSelectionIndicator:YES];
                        //                        myPickerView=myPicker;
                        //                        [datepickerview addSubview:myPicker];
                        //
                        //
                        //                        [cell.contentView addSubview:datepickerview];
                        
                        
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 200, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Quota"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        Subject_MakeupQuotaValueText=[[UITextField alloc]initWithFrame:CGRectMake(222, 7, 65, 21)];
                        Subject_MakeupQuotaValueText.font=[UIFont systemFontOfSize:15];
                        Subject_MakeupQuotaValueText.textColor=[UIColor darkGrayColor];
                        Subject_MakeupQuotaValueText.textAlignment=NSTextAlignmentRight;
                        Subject_MakeupQuotaValueText.text=workingSubject.makeup_quota_value;
                        Subject_MakeupQuotaValueText.placeholder=[MyClass returntitlewithtitle:@"Quota"];
                        [Subject_MakeupQuotaValueText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                        Subject_MakeupQuotaValueText.tag=408;
                        Subject_MakeupQuotaValueText.keyboardType = UIKeyboardTypeDecimalPad;
                        [cell.contentView addSubview:Subject_MakeupQuotaValueText];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }
            }else if (indexPath.section==1) {
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"To Makeup Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    swWeeklyScheduleAutoRenewal = [[UISwitch alloc] init];
                    swWeeklyScheduleAutoRenewal.onTintColor=themecolor;
                    CGSize switchSize = [swWeeklyScheduleAutoRenewal sizeThatFits:CGSizeZero];
                    swWeeklyScheduleAutoRenewal.frame = CGRectMake(255.0f,2.0f,switchSize.width,switchSize.height);
                    swWeeklyScheduleAutoRenewal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swWeeklyScheduleAutoRenewal.tag = 501;
                    [swWeeklyScheduleAutoRenewal addTarget:self action:@selector(selectleaveday_by_makeupschedule:) forControlEvents:UIControlEventValueChanged];
                    
                    swWeeklyScheduleAutoRenewal.on=workingSubject.leaveday_by_makeupschedule;
                    [cell.contentView addSubview:swWeeklyScheduleAutoRenewal];
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }else if (indexPath.row==1) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"To Enrolled Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    swWeeklyScheduleAutoRenewal = [[UISwitch alloc] init];
                    swWeeklyScheduleAutoRenewal.onTintColor=themecolor;
                    CGSize switchSize = [swWeeklyScheduleAutoRenewal sizeThatFits:CGSizeZero];
                    swWeeklyScheduleAutoRenewal.frame = CGRectMake(255.0f,2.0f,switchSize.width,switchSize.height);
                    swWeeklyScheduleAutoRenewal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swWeeklyScheduleAutoRenewal.tag = 501;
                    [swWeeklyScheduleAutoRenewal addTarget:self action:@selector(selectleaveday_by_enrolledschedule:) forControlEvents:UIControlEventValueChanged];
                    
                    swWeeklyScheduleAutoRenewal.on=workingSubject.leaveday_by_enrolledschedule;
                    [cell.contentView addSubview:swWeeklyScheduleAutoRenewal];
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }else if (indexPath.row==2) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"To Existing Lesson"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    swWeeklyScheduleAutoRenewal = [[UISwitch alloc] init];
                    swWeeklyScheduleAutoRenewal.onTintColor=themecolor;
                    CGSize switchSize = [swWeeklyScheduleAutoRenewal sizeThatFits:CGSizeZero];
                    swWeeklyScheduleAutoRenewal.frame = CGRectMake(255.0f,2.0f,switchSize.width,switchSize.height);
                    swWeeklyScheduleAutoRenewal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swWeeklyScheduleAutoRenewal.tag = 501;
                    [swWeeklyScheduleAutoRenewal addTarget:self action:@selector(selectleaveday_by_classdate:) forControlEvents:UIControlEventValueChanged];
                    
                    swWeeklyScheduleAutoRenewal.on=workingSubject.leaveday_by_classdate;
                    [cell.contentView addSubview:swWeeklyScheduleAutoRenewal];
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }
            }else if (indexPath.section==2){
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Same Instructor's Lesson"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    swWeeklyScheduleAutoRenewal = [[UISwitch alloc] init];
                    swWeeklyScheduleAutoRenewal.onTintColor=themecolor;
                    CGSize switchSize = [swWeeklyScheduleAutoRenewal sizeThatFits:CGSizeZero];
                    swWeeklyScheduleAutoRenewal.frame = CGRectMake(255.0f,2.0f,switchSize.width,switchSize.height);
                    swWeeklyScheduleAutoRenewal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swWeeklyScheduleAutoRenewal.tag = 501;
                    [swWeeklyScheduleAutoRenewal addTarget:self action:@selector(selectleaveday_follow_teacher:) forControlEvents:UIControlEventValueChanged];
                    
                    swWeeklyScheduleAutoRenewal.enabled=!workingSubject.leaveday_by_staffschedule;
                    
                    swWeeklyScheduleAutoRenewal.on=workingSubject.leaveday_follow_teacher;
                    [cell.contentView addSubview:swWeeklyScheduleAutoRenewal];
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }else if (indexPath.row==1) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Same Level"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    swWeeklyScheduleAutoRenewal = [[UISwitch alloc] init];
                    swWeeklyScheduleAutoRenewal.onTintColor=themecolor;
                    CGSize switchSize = [swWeeklyScheduleAutoRenewal sizeThatFits:CGSizeZero];
                    swWeeklyScheduleAutoRenewal.frame = CGRectMake(255.0f,2.0f,switchSize.width,switchSize.height);
                    swWeeklyScheduleAutoRenewal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swWeeklyScheduleAutoRenewal.tag = 501;
                    [swWeeklyScheduleAutoRenewal addTarget:self action:@selector(selectleaveday_follow_level:) forControlEvents:UIControlEventValueChanged];
                    swWeeklyScheduleAutoRenewal.on=workingSubject.leaveday_follow_level;
                    [cell.contentView addSubview:swWeeklyScheduleAutoRenewal];
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }else if (indexPath.row==2) {
                    if(globalvariables.centerrecord.enablelessonnumber){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Same Lesson"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        swWeeklyScheduleAutoRenewal = [[UISwitch alloc] init];
                        swWeeklyScheduleAutoRenewal.onTintColor=themecolor;
                        CGSize switchSize = [swWeeklyScheduleAutoRenewal sizeThatFits:CGSizeZero];
                        swWeeklyScheduleAutoRenewal.frame = CGRectMake(255.0f,2.0f,switchSize.width,switchSize.height);
                        swWeeklyScheduleAutoRenewal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                        swWeeklyScheduleAutoRenewal.tag = 501;
                        [swWeeklyScheduleAutoRenewal addTarget:self action:@selector(selectleaveday_follow_lesson:) forControlEvents:UIControlEventValueChanged];
                        swWeeklyScheduleAutoRenewal.on=workingSubject.leaveday_follow_lesson;
                        [cell.contentView addSubview:swWeeklyScheduleAutoRenewal];
                        
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        cell.hidden=NO;
                    }else{
                        cell.hidden=YES;
                    }
                    
                }else if (indexPath.row==3) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Apply Staff Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    swWeeklyScheduleAutoRenewal = [[UISwitch alloc] init];
                    swWeeklyScheduleAutoRenewal.onTintColor=themecolor;
                    CGSize switchSize = [swWeeklyScheduleAutoRenewal sizeThatFits:CGSizeZero];
                    swWeeklyScheduleAutoRenewal.frame = CGRectMake(255.0f,2.0f,switchSize.width,switchSize.height);
                    swWeeklyScheduleAutoRenewal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swWeeklyScheduleAutoRenewal.tag = 501;
                    [swWeeklyScheduleAutoRenewal addTarget:self action:@selector(selectleaveday_by_staffschedule:) forControlEvents:UIControlEventValueChanged];
                    
                    swWeeklyScheduleAutoRenewal.on=workingSubject.leaveday_by_staffschedule;
                    [cell.contentView addSubview:swWeeklyScheduleAutoRenewal];
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }else if (indexPath.row==4) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Include Same Category"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    swWeeklyScheduleAutoRenewal = [[UISwitch alloc] init];
                    swWeeklyScheduleAutoRenewal.onTintColor=themecolor;
                    CGSize switchSize = [swWeeklyScheduleAutoRenewal sizeThatFits:CGSizeZero];
                    swWeeklyScheduleAutoRenewal.frame = CGRectMake(255.0f,2.0f,switchSize.width,switchSize.height);
                    swWeeklyScheduleAutoRenewal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swWeeklyScheduleAutoRenewal.tag = 501;
                    [swWeeklyScheduleAutoRenewal addTarget:self action:@selector(selectleaveday_follow_category:) forControlEvents:UIControlEventValueChanged];
                    
                    swWeeklyScheduleAutoRenewal.on=workingSubject.leaveday_follow_category;
                    [cell.contentView addSubview:swWeeklyScheduleAutoRenewal];
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }else if (indexPath.row==5) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Allow Same Schedule"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    swWeeklyScheduleAutoRenewal = [[UISwitch alloc] init];
                    swWeeklyScheduleAutoRenewal.onTintColor=themecolor;
                    CGSize switchSize = [swWeeklyScheduleAutoRenewal sizeThatFits:CGSizeZero];
                    swWeeklyScheduleAutoRenewal.frame = CGRectMake(255.0f,2.0f,switchSize.width,switchSize.height);
                    swWeeklyScheduleAutoRenewal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swWeeklyScheduleAutoRenewal.tag = 501;
                    [swWeeklyScheduleAutoRenewal addTarget:self action:@selector(selectallowsameschedule:) forControlEvents:UIControlEventValueChanged];
                    
                    swWeeklyScheduleAutoRenewal.on=workingSubject.allowsameschedule;
                    [cell.contentView addSubview:swWeeklyScheduleAutoRenewal];
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }else if (indexPath.row==6) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:[globalvariables.language isEqualToString:@"English"]?CGRectMake(20, 0, 180, 50):CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Can Apply Makeup if No Timeslot Available"];
                    GeneralLabel.numberOfLines=0;
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    swWeeklyScheduleAutoRenewal = [[UISwitch alloc] init];
                    swWeeklyScheduleAutoRenewal.onTintColor=themecolor;
                    CGSize switchSize = [swWeeklyScheduleAutoRenewal sizeThatFits:CGSizeZero];
                    swWeeklyScheduleAutoRenewal.frame = CGRectMake(255.0f,2.0f,switchSize.width,switchSize.height);
                    swWeeklyScheduleAutoRenewal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swWeeklyScheduleAutoRenewal.tag = 501;
                    [swWeeklyScheduleAutoRenewal addTarget:self action:@selector(selectshowmakeupbuttonifnotimeslot:) forControlEvents:UIControlEventValueChanged];
                    
                    swWeeklyScheduleAutoRenewal.on=workingSubject.showmakeupbuttonifnotimeslot;
                    [cell.contentView addSubview:swWeeklyScheduleAutoRenewal];
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }else if (indexPath.row==7) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:[globalvariables.language isEqualToString:@"English"]?CGRectMake(20, 0, 200, 50):CGRectMake(20, 7, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Show Absent Button when Arranging Makeup"];
                    GeneralLabel.numberOfLines=0;
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    swWeeklyScheduleAutoRenewal = [[UISwitch alloc] init];
                    swWeeklyScheduleAutoRenewal.onTintColor=themecolor;
                    CGSize switchSize = [swWeeklyScheduleAutoRenewal sizeThatFits:CGSizeZero];
                    swWeeklyScheduleAutoRenewal.frame = CGRectMake(255.0f,2.0f,switchSize.width,switchSize.height);
                    swWeeklyScheduleAutoRenewal.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    swWeeklyScheduleAutoRenewal.tag = 501;
                    [swWeeklyScheduleAutoRenewal addTarget:self action:@selector(selectshowabsentbuttononarrangeleave:) forControlEvents:UIControlEventValueChanged];
                    
                    swWeeklyScheduleAutoRenewal.on=workingSubject.showabsentbuttononarrangeleave;
                    [cell.contentView addSubview:swWeeklyScheduleAutoRenewal];
                    
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;;
                }
            }
        }
        
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else if (tableView==autoLevelUpgradeValuesTable){
        MyTableViewCell *myCell;
        static NSString *CellIdentifier = @"rolabellabelcell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        myCell.label1.text=[MyClass convertDateFormatWithDate:[NSString stringWithFormat:@"%02ld01",(long)(indexPath.row+1)] FromDateFormat:@"MMdd" ToDateFormat:@"dd-MMMM" Translate:YES];
        
        myCell.imageview1.hidden=![workingSubject.autolevelupgrade isEqualToString:[NSString stringWithFormat:@"Y%02ld01",(long)(indexPath.row+1)]];
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return myCell;
    }else if (tableView==autoLevelUpgradeOptionTable){
        MyTableViewCell *myCell;
        if (indexPath.row==0) {
            static NSString *CellIdentifier = @"rolabellabelcell";
            myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (myCell == nil) {
                myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            myCell.imageview1.hidden=![workingSubject.autolevelupgrade isEqualToString:@"Disabled"];
            myCell.label1.text=[MyClass returntitlewithtitle:@"Disabled"];
        }else if (indexPath.row==1){
            static NSString *CellIdentifier = @"rolabellabelcell";
            myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (myCell == nil) {
                myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
        
            myCell.label1.text=[MyClass returntitlewithtitle:@"Every Renewal"];
            myCell.imageview1.hidden=![workingSubject.autolevelupgrade isEqualToString:@"Every Renewal"];
        }else{
            static NSString *CellIdentifier = @"labellabelcell";
            myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (myCell == nil) {
                myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
        
            myCell.label1.text=[MyClass returntitlewithtitle:@"Every Year"];
            myCell.imageview1.hidden=[workingSubject.autolevelupgrade isEqualToString:@"Disabled"] || [workingSubject.autolevelupgrade isEqualToString:@"Every Renewal"];
        }

        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return myCell;
    }else if (tableView==chatBotSettingsTable){
        MyTableViewCell *myCell;
        if([SubjectTableMode isEqualToString:@"View"]||([SubjectTableMode isEqualToString:@"Edit"] && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject)){
            if(indexPath.section==0){
                if(indexPath.row==0){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Publish"];
                    myCell.switch1.on=workingSubject.publishinchatbot;
                    myCell.switch1.enabled=NO;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else{
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Category"];
                    myCell.label2.text=[MyClass returnsubjectcategorynamewithscategorykey:workingSubject.chatbot_category];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==1){
                static NSString *CellIdentifier = @"collectionviewcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.collectionview1.tag=100;
                myCell.collectionview1.backgroundColor=[UIColor clearColor];
                [myCell.collectionview1 registerClass:[MessagePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
                [myCell.collectionview1 reloadData];
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==2){
                static NSString *CellIdentifier = @"labelcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.label1.text=workingSubject.subject_fulldescription;
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==3){
                static NSString *CellIdentifier = @"labelcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.label1.text=workingSubject.chatbot_tag1;
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==4){
                if(indexPath.row==0){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Enable Trial Enrollment"];
                    myCell.switch1.on=workingSubject.chatbot_enabletrial;
                    myCell.switch1.enabled=NO;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==1) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Max. Trial Class Size"];
                    myCell.label2.text=[workingSubject.trialcapacity isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:workingSubject.trialcapacity;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                }else if(indexPath.row==2){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.hidden=YES;
                }else if(indexPath.row==3){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"To Existing Lesson"];
                    myCell.switch1.on=workingSubject.trial_by_existinglesson;
                    myCell.switch1.enabled=NO;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==4){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"To Defined Schedule"];
                    myCell.switch1.on=workingSubject.trial_by_definedschedule;
                    myCell.switch1.enabled=NO;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
            }
        }else{ //edit or add
            if(indexPath.section==0){
                if(indexPath.row==0){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.switch1.enabled=YES;
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Publish"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(activatepublish:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.on=workingSubject.publishinchatbot;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else{
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Category"];
                    myCell.label2.text=[MyClass returnsubjectcategorynamewithscategorykey:workingSubject.chatbot_category];
                    myCell.selectionStyle = UITableViewCellSelectionStyleDefault;
                }
            }else if (indexPath.section==1){
                static NSString *CellIdentifier = @"collectionviewcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.collectionview1.tag=100;
                myCell.collectionview1.backgroundColor=[UIColor clearColor];
                [myCell.collectionview1 registerClass:[MessagePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
                
                [myCell.collectionview1 reloadData];
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==2){
                static NSString *CellIdentifier = @"remarkscell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                myCell.textview1.tag=100;
                myCell.textview1.text=workingSubject.subject_fulldescription;
                myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==3){
                static NSString *CellIdentifier = @"remarkscell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                myCell.textview1.tag=100;
                myCell.textview1.text=workingSubject.chatbot_tag1;
                myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==4){
                if(indexPath.row==0){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.switch1.enabled=YES;
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Enable Trial Enrollment"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(activatechatbot_enabletrial:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.on=workingSubject.chatbot_enabletrial;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==1) {
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Max. Trial Class Size"];
                    myCell.label2.text=[workingSubject.trialcapacity isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:workingSubject.trialcapacity;
                    myCell.selectionStyle = UITableViewCellSelectionStyleDefault;
                    
                    
                    
                    
                }else if (indexPath.row==2){
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    if (showTrialCapacityPicker) {
                        
                        pickerViewmenu =[[NSMutableArray alloc]initWithObjects:@"",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30", nil];
                        
                        if ([pickerViewmenu containsObject:workingSubject.trialcapacity]) {
                            presetRow=(int)[pickerViewmenu indexOfObject:workingSubject.trialcapacity];
                        }else{
                            presetRow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        [myPicker setShowsSelectionIndicator:YES];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }

                    return cell;
                }else if(indexPath.row==3){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.switch1.enabled=YES;
                    myCell.label1.text=[MyClass returntitlewithtitle:@"To Existing Lesson"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(activatetrial_by_existinglesson:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.on=workingSubject.trial_by_existinglesson;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==4){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.switch1.enabled=YES;
                    myCell.label1.text=[MyClass returntitlewithtitle:@"To Defined Schedule"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(activatetrial_by_definedschedule:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.on=workingSubject.trial_by_definedschedule;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
            }
        }
        return myCell;
    }else if (tableView==csInstructorTable){

        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        UILabel *ITInstructorname;
        UIImageView *ITInstructorselected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            ITInstructorname = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, instructortablewidth-30, 38)];
            ITInstructorname.font=[UIFont systemFontOfSize:15];
            ITInstructorname.textColor=[UIColor darkGrayColor];
            ITInstructorname.tag=1301;
            [cell.contentView addSubview:ITInstructorname];
            
            ITInstructorselected = [[UIImageView alloc]initWithFrame:CGRectMake(instructortablewidth-45, 7, 24, 24)];
            [ITInstructorselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            ITInstructorselected.tag=1302;
            [cell.contentView addSubview:ITInstructorselected];
        }else{
            ITInstructorname=(UILabel *)[cell.contentView viewWithTag:1301];
            ITInstructorselected=(UIImageView *)[cell.contentView viewWithTag:1302];
        }
        ITInstructorname.text=[MyClass returninstructornamewithusername:((Instructor *)[filteredcsInstructorArray objectAtIndex:indexPath.row]).username firstorfullname:@"full"];
        ITInstructorselected.hidden=[((Instructor *)[filteredcsInstructorArray objectAtIndex:indexPath.row]).username isEqualToString:[selectedItem isEqualToString:@"CSInstructor"]?workingScheduleDetails.instructor:workingScheduleDetails.sinstructor]?NO:YES;

    }else if (tableView==csClassroomTable){

        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        UILabel *classroomlabel;
        UIImageView *classroomselected;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            //add textfield
            classroomlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, classroomtablewidth-30, 38)];
            classroomlabel.font=[UIFont systemFontOfSize:15];
            classroomlabel.textColor=[UIColor darkGrayColor];
            classroomlabel.tag=1301;
            [cell.contentView addSubview:classroomlabel];
            
            classroomselected = [[UIImageView alloc]initWithFrame:CGRectMake(classroomtablewidth-45, 7, 24, 24)];
            [classroomselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            classroomselected.tag=1302;
            [cell.contentView addSubview:classroomselected];
        }else{
            classroomlabel=(UILabel *)[cell.contentView viewWithTag:1301];
            classroomselected=(UIImageView *)[cell.contentView viewWithTag:1302];
        }
        
        classroomlabel.text=[((ClassroomRecord *)[filteredcsClassroomArray objectAtIndex:indexPath.row]).classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:((ClassroomRecord *)[filteredcsClassroomArray objectAtIndex:indexPath.row]).classroom;
        classroomselected.hidden=[workingScheduleDetails.classroom isEqualToString:((ClassroomRecord *)[filteredcsClassroomArray objectAtIndex:indexPath.row]).classroom]?NO:YES;

    }else if (tableView==csClassDateTable) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        CalendarView *calendarview;
        
        
        if ([selectedItem isEqualToString:@"CSStartDate"]) {
            
            tmptestcstimearray=[[NSMutableArray alloc]initWithArray:[self filtercstimearray:workingSchedule.daytimearray]];
            calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, classdatetablewidth, ((CGRect)[tableView rectForRowAtIndexPath:indexPath]).size.height) Theme:0 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:[[ScheduleRecord alloc]initScheduleRecordwithScheduleKey:@"1024" Name:nil AutoRenew:nil DayTimeArray:tmptestcstimearray Action:nil StartDate:workingSchedule.startdate EndDate:workingSchedule.enddate makeupschedule:NO active:NO type:workingSchedule.type showintimetableifnoenrollment:NO onlinetrialschedule:NO levelarray:nil] UpdateScheduleMode:@"start" availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
            
            
            if (![workingSchedule.startdate isEqualToString:@""]) {
                //calendarviewcontroller.selecteddatearray=[[NSMutableArray alloc]initWithObjects:workingSchedule.startdate, nil];
                [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:workingSchedule.startdate,nil] ScrollToDate:nil instructorselected:nil];
            }else{
                if (![workingSchedule.enddate isEqualToString:@""]) {
                    //calendarviewcontroller.scrolltodate=workingSchedule.enddate;
                    [calendarview scrollToSelectedDateWithSelectedDateArray:nil ScrollToDate:workingSchedule.enddate instructorselected:nil];
                }else{
                    //calendarviewcontroller.scrolltodate=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"];
                    [calendarview scrollToSelectedDateWithSelectedDateArray:nil ScrollToDate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] instructorselected:nil];
                }
            }
            
        }else if ([selectedItem isEqualToString:@"CSEndDate"]){
            tmptestcstimearray=[[NSMutableArray alloc]initWithArray:[self filtercstimearray:workingSchedule.daytimearray]];
            calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, classdatetablewidth, ((CGRect)[tableView rectForRowAtIndexPath:indexPath]).size.height) Theme:0 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:[[ScheduleRecord alloc]initScheduleRecordwithScheduleKey:@"1024" Name:nil AutoRenew:nil DayTimeArray:tmptestcstimearray Action:nil StartDate:workingSchedule.startdate EndDate:workingSchedule.enddate makeupschedule:NO active:NO type:workingSchedule.type showintimetableifnoenrollment:NO onlinetrialschedule:NO levelarray:nil] UpdateScheduleMode:@"end" availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
            
            if (![workingSchedule.enddate isEqualToString:@""]) {
                //calendarviewcontroller.selecteddatearray=[[NSMutableArray alloc]initWithObjects:workingSchedule.enddate, nil];
                [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:workingSchedule.enddate,nil] ScrollToDate:nil instructorselected:nil];
            }else{
                if (![workingSchedule.startdate isEqualToString:@""]) {
                    //calendarviewcontroller.scrolltodate=workingSchedule.startdate;
                    [calendarview scrollToSelectedDateWithSelectedDateArray:nil ScrollToDate:workingSchedule.startdate instructorselected:nil];
                }else{
                    //calendarviewcontroller.scrolltodate=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"];
                    [calendarview scrollToSelectedDateWithSelectedDateArray:nil ScrollToDate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] instructorselected:nil];
                }
            }
        }
        
        calendarview.delegate=self;
        [cell.contentView addSubview:calendarview];
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }else if (tableView==levelEffectiveDateTable) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        CalendarView *calendarview;
        
        
        if ([selectedItem isEqualToString:@"LevelEffectiveDate"]) {
            calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, classdatetablewidth, ((CGRect)[tableView rectForRowAtIndexPath:indexPath]).size.height) Theme:0 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"LevelEffectiveDate" disablecalendar:FALSE];
            
            
            if (![selectedtuitionobject.effectivedate isEqualToString:@""]) {
                [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:selectedtuitionobject.effectivedate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO],nil] ScrollToDate:nil instructorselected:nil];
            }else{
                [calendarview scrollToSelectedDateWithSelectedDateArray:nil ScrollToDate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] instructorselected:nil];
            }
        }else if ([selectedItem isEqualToString:@"LevelEarliestDate"]) {
            calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, classdatetablewidth, ((CGRect)[tableView rectForRowAtIndexPath:indexPath]).size.height) Theme:0 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"LevelEarliestDate" disablecalendar:FALSE];
            
            
            if (![selectedlevelobject.earlieststartdate isEqualToString:@""]) {
                [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:selectedlevelobject.earlieststartdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO],nil] ScrollToDate:nil instructorselected:nil];
            }else{
                [calendarview scrollToSelectedDateWithSelectedDateArray:nil ScrollToDate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] instructorselected:nil];
            }
        }
        
        calendarview.delegate=self;
        [cell.contentView addSubview:calendarview];
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }else if (tableView==gradeEffectiveDateTable) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        CalendarView *calendarview;
        
        
        if ([selectedItem isEqualToString:@"GradeEffectiveDate"]) {
            calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, classdatetablewidth, ((CGRect)[tableView rectForRowAtIndexPath:indexPath]).size.height) Theme:0 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"GradeEffectiveDate" disablecalendar:FALSE];
            
            
            if (![selectedtuitionobject.effectivedate isEqualToString:@""]) {
                [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:selectedtuitionobject.effectivedate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO],nil] ScrollToDate:nil instructorselected:nil];
            }else{
                [calendarview scrollToSelectedDateWithSelectedDateArray:nil ScrollToDate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] instructorselected:nil];
            }
        }
        
        calendarview.delegate=self;
        [cell.contentView addSubview:calendarview];
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
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
            
            titleselected = [[UIImageView alloc]initWithFrame:CGRectMake(makeupwidth-45, 7, 24, 24)];
            [titleselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            titleselected.tag=1302;
            [cell.contentView addSubview:titleselected];
        }else{
            titlelabel=(UILabel *)[cell.contentView viewWithTag:1301];
            titleselected=(UIImageView *)[cell.contentView viewWithTag:1302];
        }
        
        titlelabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:indexPath.row];
        titleselected.hidden=(workingSubject.colorcode!=indexPath.row);
        
    }else if (tableView==csDayDateTimeTable){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (showcsDayDateTimeTable) {
            if (![workingSchedule.type isEqualToString:@"Fixed"]) {
                UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, classdatetablewidth, 150)];
                UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake((classdatetablewidth-300)/2, 0, 300, 150)];
                [myPicker setDataSource:self];
                [myPicker setDelegate:self];
                myPicker.tag=801;
                

                
                hourPresetRow=(int)[hourPickerViewMenu indexOfObject:[[workingScheduleDetails.classtime substringFromIndex:[workingScheduleDetails.classtime length]-5] substringToIndex:2]];
                minutePresetRow=(int)[minutePickerViewMenu indexOfObject:[workingScheduleDetails.classtime substringFromIndex:[workingScheduleDetails.classtime length]-2]];
                dayPresentRow=[dayPickerViewMenu indexOfObject:workingScheduleDetails.dayofweek];
                
                [myPicker selectRow:dayPresentRow inComponent:0 animated:NO];
                [myPicker selectRow:hourPresetRow inComponent:1 animated:NO];
                [myPicker selectRow:minutePresetRow inComponent:2 animated:NO];
                
                [myPicker setShowsSelectionIndicator:YES];
                myPickerView=myPicker;
                [datepickerview addSubview:myPicker];
                
                [cell.contentView addSubview:datepickerview];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;

            }else{
                selectedItem=@"DateTime";
                CalendarView *calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, classdatetablewidth, 458) Theme:0 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
                [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:workingScheduleDetails.dayofweek FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy"] ,nil] ScrollToDate:nil instructorselected:nil];
                calendarview.delegate=self;

                [cell.contentView addSubview:calendarview];
                
                hourPresetRow=(int)[hourPickerViewMenu indexOfObject:[workingScheduleDetails.classtime substringToIndex:2]];
                minutePresetRow=(int)[minutePickerViewMenu indexOfObject:[workingScheduleDetails.classtime substringFromIndex:3]];
                
                UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 458, classdatetablewidth, 162)];
                myPicker.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.03];
                [myPicker setDataSource:self];
                [myPicker setDelegate:self];
                myPicker.tag=801;
                

                [myPicker selectRow:hourPresetRow inComponent:0 animated:NO];
                [myPicker selectRow:minutePresetRow inComponent:1 animated:NO];
                
                [myPicker setShowsSelectionIndicator:YES];
                myPickerView=myPicker;
                [cell.contentView addSubview:myPicker];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
            }
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }else if (tableView==lessonNumberTable){
        MyTableViewCell *cell;
        NSMutableArray *lessonarray=workingSubject.lessonnumberDict[lessonnumbertype];
        if ([SubjectTableMode isEqualToString:@"View"]) {
            static NSString *CellIdentifier= @"viewCell";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.label1.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
            cell.label2.text=[lessonarray objectAtIndex:indexPath.row];
            
        }else{
            static NSString *CellIdentifier= @"editCell";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cell.label1.text=[NSString stringWithFormat:@"%ld",(long)indexPath.row+1];
            cell.textview1.text=[lessonarray objectAtIndex:indexPath.row];
            cell.button1.tag=indexPath.row;
            [cell.button1 addTarget:self action:@selector(insertLessonNumberButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        
        
        return cell;
    }
    
    return cell;
    
}

- (void)addLessonNumberButtonPressed {
    NSMutableArray *lessonarray=workingSubject.lessonnumberDict[lessonnumbertype];
    if(!lessonarray){
        lessonarray=[[NSMutableArray alloc]init];
        [workingSubject.lessonnumberDict setValue:lessonarray forKey:lessonnumbertype];
    }
    [lessonarray addObject:@""];
    
    [lessonNumberTable reloadData];
    [SubjectPopoverTable reloadData];
}

-(void) insertLessonNumberButtonPressed:(UIButton *)sender
{
    NSMutableArray *lessonarray=workingSubject.lessonnumberDict[lessonnumbertype];
    if(!lessonarray){
        lessonarray=[[NSMutableArray alloc]init];
        [workingSubject.lessonnumberDict setValue:lessonarray forKey:lessonnumbertype];
    }
    [lessonarray insertObject:@"" atIndex:sender.tag];
    
    [lessonNumberTable reloadData];
    [SubjectPopoverTable reloadData];
}

-(NSString *) findgradetuitionfeewithgrade:(NSString *)grade tuitionarray:(NSMutableArray *)tuitionarray mode:(NSString *)mode
{
    for (int i=0; i<tuitionarray.count; i++) {
        tuitionobject=[tuitionarray objectAtIndex:i];
        if ([tuitionobject.scale isEqualToString:grade]) {
            if ([mode isEqualToString:@"View"]) {
                return [tuitionobject.tuitionfee isEqualToString:@""]?@"":[NSString stringWithFormat:@"$%@",tuitionobject.tuitionfee];
            }else{
                return tuitionobject.tuitionfee;
            }
        }
    }
    return @"";
}

-(TuitionRecord *) findgradetuitionobjectwithgrade:(NSString *)grade tuitionarray:(NSMutableArray *)tuitionarray
{
    for (int i=0; i<tuitionarray.count; i++) {
        tuitionobject=[tuitionarray objectAtIndex:i];
        if ([tuitionobject.scale isEqualToString:grade]) {
            return tuitionobject;
        }
    }
    return [[TuitionRecord alloc]init];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==subjectcategorysearchbar) {
        if ([searchText isEqualToString:@""]) {
            filteredSubjectCategoryArray=[[NSMutableArray alloc]initWithArray:allSubjectCategoryArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.englishname contains[c] %@ or self.chinesename contains[c] %@",searchText,searchText];
            filteredSubjectCategoryArray=[[NSMutableArray alloc]initWithArray:[allSubjectCategoryArray filteredArrayUsingPredicate:predicate]];
        }
        [SubjectCategoryTable reloadData];
        [SubjectCategoryTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==csinstructortablesearchbar){
        if ([searchText isEqualToString:@""]) {
            filteredcsInstructorArray=[[NSMutableArray alloc]initWithArray:InstructorArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or self.username contains[c] %@",searchText,searchText,searchText];
            filteredcsInstructorArray=[[NSMutableArray alloc]initWithArray:[InstructorArray filteredArrayUsingPredicate:predicate]];
        }
        [csInstructorTable reloadData];
        [csInstructorTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==csclassroomtablesearchbar){
        if ([searchText isEqualToString:@""]) {
            filteredcsClassroomArray=[[NSMutableArray alloc]initWithArray:ClassroomArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.classroom contains[c] %@",searchText];
            filteredcsClassroomArray=[[NSMutableArray alloc]initWithArray:[ClassroomArray filteredArrayUsingPredicate:predicate]];
        }
        [csClassroomTable reloadData];
        [csClassroomTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==coursescheduletablesearchbar){

        [self returnFilteredScheduleArray];
        [CourseScheduleTable reloadData];
    }else if (searchBar==schedulelevelsearchbar){
        [self returnFilteredScheduleLevelArray];
        [ScheduleLevelTable reloadData];
    }
}

-(void) returnFilteredScheduleLevelArray
{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (![schedulelevelsearchbar.text isEqualToString:@""]) {
        
        newCondition = [NSPredicate predicateWithBlock:^BOOL(NSString *level, NSDictionary *bindings) {
            return [level rangeOfString:schedulelevelsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound;
        }];
        
        [nsPredicatearray addObject:newCondition];
        
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredScheduleLevelArray= [[NSMutableArray alloc]initWithArray:[scheduleLevelArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredScheduleLevelArray= [[NSMutableArray alloc]initWithArray:scheduleLevelArray];
    }
    
    NSSortDescriptor *sortby = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[sortby];
    filteredScheduleLevelArray = [NSMutableArray arrayWithArray:[filteredScheduleLevelArray sortedArrayUsingDescriptors:sortDescriptors]];
}

-(void) returnFilteredScheduleArray
{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    newCondition = [NSPredicate predicateWithFormat:@"self.schedulekey !=%@ and self.schedulekey !=%@ and self.action !=%@",@"-1",@"-2",@"Delete"];
    [nsPredicatearray addObject:newCondition];
    
    if (coursescheduletablesearchbar.text && ![coursescheduletablesearchbar.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",coursescheduletablesearchbar.text];
        [nsPredicatearray addObject:newCondition];
    }
    
    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
    filteredScheduleArray= [[NSMutableArray alloc]initWithArray:[workingSubject.scheduleArray filteredArrayUsingPredicate:predicate]];
}

-(void) subjectcategorymorebuttonpressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:SubjectCategoryTable];
    NSIndexPath *indexPath =[SubjectCategoryTable indexPathForRowAtPoint:point];
    
    subjectcategoryobject=[filteredSubjectCategoryArray objectAtIndex:indexPath.row];
    workingCategory=[[SubjectCategoryRecord alloc]init];
    workingCategory.colorcode=subjectcategoryobject.colorcode;
    
    UIView *addsubjectcategoryview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 500, 300)];
    addsubjectcategoryview.backgroundColor=[UIColor whiteColor];
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 10, addsubjectcategoryview.frame.size.width-40, 60)];
    label.font=[UIFont boldSystemFontOfSize:18];
    label.textColor=[UIColor blackColor];
    label.text=[MyClass returntitlewithtitle:@"Update Course Category"];
    [addsubjectcategoryview addSubview:label];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(20, 50, addsubjectcategoryview.frame.size.width-40, 45)];
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor grayColor];
    label.text=[MyClass returntitlewithtitle:@"Please enter category name in English and Chinese"];
    [addsubjectcategoryview addSubview:label];
    
    UIButton *updatebutton =[[UIButton alloc]initWithFrame:CGRectMake(addsubjectcategoryview.frame.size.width-100-20,addsubjectcategoryview.frame.size.height-35-15,100,35)];
    [updatebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [updatebutton setTitle:[MyClass returntitlewithtitle:@"Update"] forState:UIControlStateNormal];
    updatebutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    updatebutton.backgroundColor=[UIColor whiteColor];
    updatebutton.layer.borderWidth=1;
    updatebutton.layer.cornerRadius=4;
    updatebutton.layer.masksToBounds=YES;
    updatebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    updatebutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [updatebutton addTarget: self action:@selector(updatesubjectcategoryupdatebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [updatebutton addTarget: self action:@selector(updatesubjectcategoryupdatebuttonhighlightcolor:) forControlEvents: UIControlEventTouchDown];
    [updatebutton addTarget: self action:@selector(updatesubjectcategoryupdatebuttonresetcolor:) forControlEvents: UIControlEventTouchCancel];
    [updatebutton addTarget: self action:@selector(updatesubjectcategoryupdatebuttonresetcolor:) forControlEvents: UIControlEventTouchUpOutside];

    UIButton *deletebutton =[[UIButton alloc]initWithFrame:CGRectMake(addsubjectcategoryview.frame.size.width-100-20-100-10,addsubjectcategoryview.frame.size.height-35-15,100,35)];
    [deletebutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [deletebutton setTitle:[MyClass returntitlewithtitle:@"Delete"] forState:UIControlStateNormal];
    deletebutton.layer.borderColor=[UIColor redColor].CGColor;
    deletebutton.backgroundColor=[UIColor whiteColor];
    deletebutton.layer.borderWidth=1;
    deletebutton.layer.cornerRadius=4;
    deletebutton.layer.masksToBounds=YES;
    deletebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    deletebutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [deletebutton addTarget: self action:@selector(updatesubjectcategorydeletebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [deletebutton addTarget: self action:@selector(updatesubjectcategorydeletebuttonhighlightcolor:) forControlEvents: UIControlEventTouchDown];
    [deletebutton addTarget: self action:@selector(updatesubjectcategorydeletebuttonresetcolor:) forControlEvents: UIControlEventTouchCancel];
    [deletebutton addTarget: self action:@selector(updatesubjectcategorydeletebuttonresetcolor:) forControlEvents: UIControlEventTouchUpOutside];
    
    UIButton *cancelbutton =[[UIButton alloc]initWithFrame:CGRectMake(addsubjectcategoryview.frame.size.width-100-20-100-10-100-10,addsubjectcategoryview.frame.size.height-35-15,100,35)];
    [cancelbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [cancelbutton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    cancelbutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    cancelbutton.backgroundColor=[UIColor whiteColor];
    cancelbutton.layer.borderWidth=1;
    cancelbutton.layer.cornerRadius=4;
    cancelbutton.layer.masksToBounds=YES;
    cancelbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    cancelbutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [cancelbutton addTarget: self action:@selector(updatesubjectcategorycancelbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [cancelbutton addTarget: self action:@selector(updatesubjectcategorycancelbuttonhighlightcolor:) forControlEvents: UIControlEventTouchDown];
    [cancelbutton addTarget: self action:@selector(updatesubjectcategorycancelbuttonresetcolor:) forControlEvents: UIControlEventTouchCancel];
    [cancelbutton addTarget: self action:@selector(updatesubjectcategorycancelbuttonresetcolor:) forControlEvents: UIControlEventTouchUpOutside];
    
    subjectcategoryenglishnametext=[[UITextField alloc]initWithFrame:CGRectMake(20, 100, addsubjectcategoryview.frame.size.width-40, 35)];
    subjectcategoryenglishnametext.font=[UIFont systemFontOfSize:15];
    subjectcategoryenglishnametext.textColor=[UIColor darkGrayColor];
    subjectcategoryenglishnametext.backgroundColor=[UIColor whiteColor];
    subjectcategoryenglishnametext.layer.cornerRadius=4;
    subjectcategoryenglishnametext.layer.masksToBounds=YES;
    subjectcategoryenglishnametext.adjustsFontSizeToFitWidth=YES;
    subjectcategoryenglishnametext.minimumFontSize=0.7;
    subjectcategoryenglishnametext.layer.borderColor=[UIColor lightGrayColor].CGColor;
    subjectcategoryenglishnametext.layer.borderWidth=0.6;
    subjectcategoryenglishnametext.placeholder=@"Category name in English";
    subjectcategoryenglishnametext.text=subjectcategoryobject.englishname;
    subjectcategoryenglishnametext.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
    [subjectcategoryenglishnametext setLeftViewMode:UITextFieldViewModeAlways];
    [subjectcategoryenglishnametext setLeftView:spacerView];
    
    subjectcategorychinesenametext=[[UITextField alloc]initWithFrame:CGRectMake(20, 150, addsubjectcategoryview.frame.size.width-40, 35)];
    subjectcategorychinesenametext.font=[UIFont systemFontOfSize:15];
    subjectcategorychinesenametext.textColor=[UIColor darkGrayColor];
    subjectcategorychinesenametext.backgroundColor=[UIColor whiteColor];
    subjectcategorychinesenametext.layer.cornerRadius=4;
    subjectcategorychinesenametext.layer.masksToBounds=YES;
    subjectcategorychinesenametext.adjustsFontSizeToFitWidth=YES;
    subjectcategorychinesenametext.minimumFontSize=0.7;
    subjectcategorychinesenametext.layer.borderColor=[UIColor lightGrayColor].CGColor;
    subjectcategorychinesenametext.layer.borderWidth=0.6;
    subjectcategorychinesenametext.placeholder=@"Category name in Chinese";
    subjectcategorychinesenametext.text=subjectcategoryobject.chinesename;
    subjectcategorychinesenametext.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
    [subjectcategorychinesenametext setLeftViewMode:UITextFieldViewModeAlways];
    [subjectcategorychinesenametext setLeftView:spacerView];
    
    colorcodelabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 200, 28, 21)];
    colorcodelabel.layer.cornerRadius=5;
    colorcodelabel.layer.masksToBounds=true;
    colorcodelabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:workingCategory.colorcode];
    
    UIButton *colorcodebutton=[[UIButton alloc]initWithFrame:colorcodelabel.frame];
    colorcodebutton.tag=indexPath.row;
    [colorcodebutton addTarget:self action:@selector(subjectcategorycolorcodebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(0, updatebutton.frame.origin.y-15, addsubjectcategoryview.frame.size.width, 65)];
    separator.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [addsubjectcategoryview addSubview:separator];
    
    
    [addsubjectcategoryview addSubview:subjectcategoryenglishnametext];
    [addsubjectcategoryview addSubview:subjectcategorychinesenametext];
    [addsubjectcategoryview addSubview:colorcodelabel];
    [addsubjectcategoryview addSubview:colorcodebutton];
    [addsubjectcategoryview addSubview:updatebutton];
    [addsubjectcategoryview addSubview:deletebutton];
    [addsubjectcategoryview addSubview:cancelbutton];
    
    bundleforapppaymentbutton = [[UISwitch alloc] init];
    bundleforapppaymentbutton.onTintColor=themecolor;
    CGSize switchSize = [bundleforapppaymentbutton sizeThatFits:CGSizeZero];
    bundleforapppaymentbutton.frame = CGRectMake(20+subjectcategorychinesenametext.frame.size.width-switchSize.width, colorcodebutton.frame.origin.y+colorcodebutton.frame.size.height/2-switchSize.height/2,switchSize.width,switchSize.height);
    bundleforapppaymentbutton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    bundleforapppaymentbutton.tag = 501;
    bundleforapppaymentbutton.on=subjectcategoryobject.bundleforapppayment;
//    [bundleforapppaymentbutton addTarget:self action:@selector(switchbundleforapppayment:) forControlEvents:UIControlEventValueChanged];
    [addsubjectcategoryview addSubview:bundleforapppaymentbutton];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(20, 50, addsubjectcategoryview.frame.size.width-40, 45)];
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor grayColor];
    label.text=[MyClass returntitlewithtitle:@"Bundle for app payment"];
    [label sizeToFit];
    label.frame=CGRectMake(subjectcategorychinesenametext.frame.size.width-label.frame.size.width+20-switchSize.width-10, colorcodebutton.frame.origin.y+colorcodebutton.frame.size.height/2-label.frame.size.height/2, label.frame.size.width, label.frame.size.height);
    [addsubjectcategoryview addSubview:label];
    
    
    
    
    addsubjectcategoryviewcontroller=[[UIViewController alloc]init];
    addsubjectcategoryviewcontroller.preferredContentSize=CGSizeMake(500, 300);
    addsubjectcategoryviewcontroller.view=addsubjectcategoryview;
    
    addsubjectcategoryviewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
    addsubjectcategoryviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //[self presentViewController:addsubjectcategoryviewcontroller animated:YES completion: nil];
    [MyClass presentViewController:addsubjectcategoryviewcontroller View:self];
}

-(void) subjectcategorycolorcodebuttonpressed:(UIButton *)sender
{
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:[@(workingCategory.colorcode) stringValue], nil] DataType:@"colorcode" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(100, 600) View:addsubjectcategoryviewcontroller delegateView:self Button:sender ItemsArray:nil Title:nil];
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"colorcode"]) {
        NSString *colorcode=[selecteditems firstObject];
        workingCategory.colorcode=[colorcode integerValue];
        colorcodelabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:workingCategory.colorcode];
    }else if ([datatype isEqualToString:@"attachment"]){
        NSString *result=[selecteditems firstObject];

        if ([result isEqualToString:@"Take Photo"]) {
            [self addclassphotofromsource:@"photocamera"];
        }else if ([result isEqualToString:@"Photo Library"]){
            [self addclassphotofromsource:@"photolibrary"];
        }
    }
}

-(void) updatelevel:(UITextField *)sender{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:LevelTuitionTable];
    NSIndexPath *indexpath =[LevelTuitionTable indexPathForRowAtPoint:point];
    
//    [workingSubject.levelArray replaceObjectAtIndex:indexpath.row withObject:sender.text];
    ((LevelRecord *)[workingSubject.levelArray objectAtIndex:indexpath.row]).level=sender.text;
    
    if ([workingSubject.tuition_method isEqualToString:@"Level"]) {
        tuitionobject=[workingSubject.tuitionArray objectAtIndex:indexpath.row];
        tuitionobject.scale=sender.text;
    }
}

-(void) updateleveltuitionfee:(UITextField *)sender{
    
    if (![self checkvalidfeeinput:sender.text]) {
        [LevelTuitionTable reloadData];
    }else{
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:LevelTuitionTable];
        NSIndexPath *indexpath =[LevelTuitionTable indexPathForRowAtPoint:point];
        
        tuitionobject=[workingSubject.tuitionArray objectAtIndex:indexpath.row];
        tuitionobject.tuitionfee=sender.text;
    }
}

-(void) updategradetuitionfee:(UITextField *)sender{
    
    if (![self checkvalidfeeinput:sender.text]) {
        [GradeTuitionTable reloadData];
    }else{
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:GradeTuitionTable];
        NSIndexPath *indexpath =[GradeTuitionTable indexPathForRowAtPoint:point];
        
        tuitionobject=[workingSubject.tuitionArray objectAtIndex:indexpath.row];
        tuitionobject.tuitionfee=sender.text;
    }
}

-(void) updatelevelnewtuitionfee:(UITextField *)sender{
    
    if (![self checkvalidfeeinput:sender.text]) {
        [LevelTuitionTable reloadData];
    }else{
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:LevelTuitionTable];
        NSIndexPath *indexpath =[LevelTuitionTable indexPathForRowAtPoint:point];
        
        tuitionobject=[workingSubject.tuitionArray objectAtIndex:indexpath.row];
        tuitionobject.newtuitionfee=sender.text;
    }
}

-(void) updategradenewtuitionfee:(UITextField *)sender{
    
    if (![self checkvalidfeeinput:sender.text]) {
        [GradeTuitionTable reloadData];
    }else{
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:GradeTuitionTable];
        NSIndexPath *indexpath =[GradeTuitionTable indexPathForRowAtPoint:point];
        
        tuitionobject=[workingSubject.tuitionArray objectAtIndex:indexpath.row];
        tuitionobject.newtuitionfee=sender.text;
    }
}


-(void) switchautorenew:(UISwitch *)sender
{
    workingSchedule.autorenew=sender.on?@"Yes":@"No";
}

-(void) switchmakeupschedule:(UISwitch *)sender
{
    workingSchedule.makeupschedule=sender.on;
}

-(void) switchshowintimetableifnoenrollment:(UISwitch *)sender
{
    workingSchedule.showintimetableifnoenrollment=sender.on;
}

-(void) switchonlinetrialschedule:(UISwitch *)sender
{
    workingSchedule.onlinetrialschedule=sender.on;
}

-(void) switchactive:(UISwitch *)sender
{
    workingSchedule.active=sender.on;
}

-(void) addtimebuttonpressed:(id)sender
{
    showcsInstructorTable=NO;
    showcsClassroomTable=NO;
    showcsClassDateTable=NO;
    
    [self addcstimewithrownumber];
    //[self storeCSTmpField];
    selecteddaytimebutton=nil;
    showcsClassroomTable=NO;
    showcsInstructorTable=NO;
    showcsDayDateTimeTable=NO;
    showScheduleLevelTable=NO;
    [CourseScheduleTable reloadData];
    [self adjusttablesize];
}

-(void) deletetimebuttonpressed:(UIButton *)sender
{
    showcsInstructorTable=NO;
    showcsClassroomTable=NO;
    showcsClassDateTable=NO;
    
    if(![((ScheduleDetailsRecord *)[workingSchedule.daytimearray objectAtIndex:sender.tag-80000]).dayofweek isEqualToString:@""]){
        workingSchedule.startdate=@"";
        workingSchedule.enddate=@"";
        
        if(showcsClassDateTable){
            [self showsidewindowwithwindow:@"showScheduleTable"];
        }
    }
    
    [workingSchedule.daytimearray removeObjectAtIndex:sender.tag-80000];
    [self updateStartEndDate];
    selecteddaytimebutton=nil;
    showcsClassroomTable=NO;
    showcsInstructorTable=NO;
    showcsDayDateTimeTable=NO;
    showScheduleLevelTable=NO;
    [CourseScheduleTable reloadData];
    [self adjusttablesize];
}

-(void) updateStartEndDate
{
    if ([workingSchedule.type isEqualToString:@"Fixed"]) {
        NSString *startdate=@"";
        NSString *enddate=@"";
        
        for (int i=0; i<workingSchedule.daytimearray.count; i++) {
            ScheduleDetailsRecord *obj=[workingSchedule.daytimearray objectAtIndex:i];
            if (![obj.dayofweek isEqualToString:@""]) {
                if ([startdate isEqualToString:@""] || [[MyClass convertToNSDateWithDate:startdate DateFormat:@"dd-MMM-yyyy"] compare:[MyClass convertToNSDateWithDate:obj.dayofweek DateFormat:@"yyyy-MM-dd"]]==NSOrderedDescending) {
                    startdate=[MyClass convertDateFormatWithDate:obj.dayofweek FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                }

                if ([enddate isEqualToString:@""] || [[MyClass convertToNSDateWithDate:enddate DateFormat:@"dd-MMM-yyyy"] compare:[MyClass convertToNSDateWithDate:obj.dayofweek DateFormat:@"yyyy-MM-dd"]]==NSOrderedAscending) {
                    enddate=[MyClass convertDateFormatWithDate:obj.dayofweek FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                }
            }
        }
        
        workingSchedule.startdate=startdate;
        workingSchedule.enddate=enddate;
    }
    
}

-(void) csdatetimebuttonpressed:(UIButton *)sender
{
    
    if ((int)(sender.tag/10000)==1) {
        selecteddaytimebutton=sender;
        workingScheduleDetails=[workingSchedule.daytimearray objectAtIndex:sender.tag-10000];
        
        
        if ([workingScheduleDetails.dayofweek isEqualToString:@""]) {
            workingScheduleDetails.dayofweek=[MyClass convertDateFormatWithDate:[MyClass findNextWorkDay2:[NSDate date] includereserveddate:YES] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
            workingScheduleDetails.classtime=[NSString stringWithFormat:@"%@:%@",[hourPickerViewMenu objectAtIndex:0],[minutePickerViewMenu objectAtIndex:0]];
            
            [self updateStartEndDate];
            

        }
        
        [self closeallpickers];
        [self showsidewindowwithwindow:@"showcsDayDateTime"];
        selectedItem=@"DateTime";
        //showcsClassroomTable=NO;
        //showcsInstructorTable=NO;
        //showcsDayDateTimeTable=YES;
        selecteddaytimebutton=sender;
        [csDayDateTimeTable reloadData];
        [CourseScheduleTable reloadData];
        [self adjusttablesize];
        
    }else if ((int)(sender.tag/10000)==3) {
        workingScheduleDetails=[workingSchedule.daytimearray objectAtIndex:sender.tag-30000];
        csinstructortablesearchbar.text=@"";
        filteredcsInstructorArray=[[NSMutableArray alloc]initWithArray:InstructorArray];
        
        [self closeallpickers];
        [self showsidewindowwithwindow:@"showcsInstructor"];
        
        
        if ([workingScheduleDetails.instructor isEqualToString:@""]) {
            if (filteredcsInstructorArray.count>0) {
                workingScheduleDetails.instructor=((Instructor *)[filteredcsInstructorArray objectAtIndex:0]).username;
            }else{
                workingScheduleDetails.instructor=@"TBD";
            }
        }
        
        //[self storeCSTmpField];
        selectedItem=@"CSInstructor";
        selecteddaytimebutton=sender;
        [csInstructorTable reloadData];
        [CourseScheduleTable reloadData];
        [self adjusttablesize];
    }else if ((int)(sender.tag/10000)==4){
        
        workingScheduleDetails=[workingSchedule.daytimearray objectAtIndex:sender.tag-40000];
        [self closeallpickers];

        
        [self showsidewindowwithwindow:@"showcsClassroom"];
        
        if ([workingScheduleDetails.classroom isEqualToString:@""]) {
            if (filteredcsClassroomArray.count>0) {
                workingScheduleDetails.classroom=((ClassroomRecord *)[filteredcsClassroomArray objectAtIndex:0]).classroom;
            }else{
                workingScheduleDetails.classroom=@"TBD";
            }
        }
        
        selecteddaytimebutton=sender;
        //[self storeCSTmpField];
        [csClassroomTable reloadData];
        [CourseScheduleTable reloadData];
        [self adjusttablesize];
    }else if ((int)(sender.tag/10000)==5) {
        workingScheduleDetails=[workingSchedule.daytimearray objectAtIndex:sender.tag-50000];
        csinstructortablesearchbar.text=@"";
        filteredcsInstructorArray=[[NSMutableArray alloc]initWithArray:InstructorArray];
        
        [self closeallpickers];
        [self showsidewindowwithwindow:@"showcsInstructor"];
        
        
        if ([workingScheduleDetails.sinstructor isEqualToString:@""]) {
            if (filteredcsInstructorArray.count>0) {
                workingScheduleDetails.sinstructor=((Instructor *)[filteredcsInstructorArray objectAtIndex:0]).username;
            }else{
                workingScheduleDetails.sinstructor=@"TBD";
            }
        }
        
        //[self storeCSTmpField];
        selectedItem=@"CSSInstructor";
        selecteddaytimebutton=sender;
        [csInstructorTable reloadData];
        [CourseScheduleTable reloadData];
        [self adjusttablesize];
    }
}

-(void) csdaytimebuttonpressed:(UIButton *)sender
{
    
    if ((int)(sender.tag/10000)==1 || (int)(sender.tag/10000)==2) {
        selecteddaytimebutton=sender;
        workingScheduleDetails=[workingSchedule.daytimearray objectAtIndex:(sender.tag/10000)==1?(sender.tag-10000):(sender.tag-20000)];
        
        
        if ([workingScheduleDetails.dayofweek isEqualToString:@""]) {
            workingScheduleDetails.dayofweek=[dayPickerViewMenu objectAtIndex:0];
            workingScheduleDetails.classtime=[NSString stringWithFormat:@"%@:%@",[hourPickerViewMenu objectAtIndex:0],[minutePickerViewMenu objectAtIndex:0]];
            
            workingSchedule.startdate=@"";
            workingSchedule.enddate=@"";
            
            /*if(showcsClassDateTable){
                showcsClassDateTable=NO;
                [self adjusttablesize];
            }*/
        }
        
        [self closeallpickers];
        [self showsidewindowwithwindow:@"showcsDayDateTime"];
        
        selectedItem=@"CSClassTime";
        //showcsClassroomTable=NO;
        //showcsInstructorTable=NO;
        //showcsDayDateTimeTable=NO;
        selecteddaytimebutton=sender;
        [csDayDateTimeTable reloadData];
        [CourseScheduleTable reloadData];
        [self adjusttablesize];
        
    }else if ((int)(sender.tag/10000)==3) {
        workingScheduleDetails=[workingSchedule.daytimearray objectAtIndex:sender.tag-30000];
        csinstructortablesearchbar.text=@"";
        filteredcsInstructorArray=[[NSMutableArray alloc]initWithArray:InstructorArray];
        
        [self closeallpickers];
        [self showsidewindowwithwindow:@"showcsInstructor"];
        
        
        if ([workingScheduleDetails.instructor isEqualToString:@""]) {
            if (filteredcsInstructorArray.count>0) {
                workingScheduleDetails.instructor=((Instructor *)[filteredcsInstructorArray objectAtIndex:0]).username;
            }else{
                workingScheduleDetails.instructor=@"TBD";
            }
        }
        
        //[self storeCSTmpField];
        selectedItem=@"CSInstructor";
        selecteddaytimebutton=sender;
        [csInstructorTable reloadData];
        [CourseScheduleTable reloadData];
        [self adjusttablesize];
    }else if ((int)(sender.tag/10000)==4){
        
        workingScheduleDetails=[workingSchedule.daytimearray objectAtIndex:sender.tag-40000];
        [self closeallpickers];

        
        [self showsidewindowwithwindow:@"showcsClassroom"];
        
        if ([workingScheduleDetails.classroom isEqualToString:@""]) {
            if (filteredcsClassroomArray.count>0) {
                workingScheduleDetails.classroom=((ClassroomRecord *)[filteredcsClassroomArray objectAtIndex:0]).classroom;
            }else{
                workingScheduleDetails.classroom=@"TBD";
            }
        }
        
        selecteddaytimebutton=sender;
        //[self storeCSTmpField];
        [csClassroomTable reloadData];
        [CourseScheduleTable reloadData];
        [self adjusttablesize];
    }else if ((int)(sender.tag/10000)==5) {
        workingScheduleDetails=[workingSchedule.daytimearray objectAtIndex:sender.tag-50000];
        csinstructortablesearchbar.text=@"";
        filteredcsInstructorArray=[[NSMutableArray alloc]initWithArray:InstructorArray];
        
        [self closeallpickers];
        [self showsidewindowwithwindow:@"showcsInstructor"];
        
        
        if ([workingScheduleDetails.instructor isEqualToString:@""]) {
            if (filteredcsInstructorArray.count>0) {
                workingScheduleDetails.sinstructor=((Instructor *)[filteredcsInstructorArray objectAtIndex:0]).username;
            }else{
                workingScheduleDetails.sinstructor=@"TBD";
            }
        }
        
        //[self storeCSTmpField];
        selectedItem=@"CSSInstructor";
        selecteddaytimebutton=sender;
        [csInstructorTable reloadData];
        [CourseScheduleTable reloadData];
        [self adjusttablesize];
    }
}

-(void) InstructorButtonPressed:(UIButton *)sender
{
    //popup make up information
    
    instructorimagepopover = (InstructorImageGridViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"InstructorImageGridViewController"];
    instructorimagepopover.delegate=self;
    instructorimagepopover.instructorArray=[MyClass filterInstructorArrayWithInstructorArray:InstructorArray Valid:@"Yes"];
    
    instructorimagepopover.modalPresentationStyle = UIModalPresentationFormSheet;
    //[self presentViewController:instructorimagepopover animated:YES completion: nil];
    [MyClass presentViewController:instructorimagepopover View:self];
}

-(void) dismissinstructorgridview
{
    [instructorimagepopover dismissViewControllerAnimated:YES completion:nil];
}

-(void) passinstructorfromgrid:(NSString *)username
{
    [instructorimagepopover dismissViewControllerAnimated:YES completion:nil];
    
    if (![workingScheduleDetails.instructor isEqualToString:username]) {
        //[self storeCSTmpField];
        workingScheduleDetails.instructor=username;
        
        showcsInstructorTable=NO;
        [CourseScheduleTable reloadData];
        [self adjusttablesize];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==ScheduleLevelTable){
        NSString *selecteditem=[filteredScheduleLevelArray objectAtIndex:indexPath.row];
        if (workingSchedule.levelarray && workingSchedule.levelarray.count==0) {
            for (int i=0; i<scheduleLevelArray.count; i++) {
                if (![selecteditem isEqualToString:[scheduleLevelArray objectAtIndex:i]]) {
                    [workingSchedule.levelarray addObject:[scheduleLevelArray objectAtIndex:i]];
                }
            }
        }else{
            if(!workingSchedule.levelarray){
                workingSchedule.levelarray=[[NSMutableArray alloc]init];
            }
            if ([workingSchedule.levelarray containsObject:selecteditem]) {
                [workingSchedule.levelarray removeObject:selecteditem];
                if(workingSchedule.levelarray.count==0){
                    workingSchedule.levelarray=nil;
                }
            }else{
                [workingSchedule.levelarray addObject:selecteditem];
                if(workingSchedule.levelarray.count==scheduleLevelArray.count){
                    workingSchedule.levelarray=[[NSMutableArray alloc]init];
                }
            }
        }
        
        [CourseScheduleTable reloadData];
        [ScheduleLevelTable reloadData];
    }else if (tableView==SubjectPopoverTable) {
        if (![SubjectTableMode isEqualToString:@"View"]) {
            if (indexPath.section==0 && indexPath.row==3 && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject) {
                
                selectedItem=@"SubjectCategory";
                //[self storeTmpField];
                
                if (showSubjectCategoryTable==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [SubjectPopoverTable reloadData];
                }else{
                    [self closeallpickers];
                    [self showsidewindowwithwindow:@"showSubjectCategory"];
                    [self adjusttablesize];
                    [SubjectPopoverTable reloadData];
                    [SubjectPopoverTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                
                [SubjectCategoryTable reloadData];
                
            }else if (indexPath.section==0 && indexPath.row==4 && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject) {
                selectedItem=@"ColorCode";
                
                //[self storeTmpField];
                
                if (showColorCode==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [SubjectPopoverTable reloadData];
                }else{
                    [self closeallpickers];
                    
                    [self showsidewindowwithwindow:@"showColorCode"];
                    [ColorCodeTable reloadData];
                    [SubjectPopoverTable reloadData];
                    [self adjusttablesize];
                }
                
                
            }else if (indexPath.section==1 && indexPath.row==1 && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject) {
                selectedItem=@"StudentCapacity";
                
                if (showStudentCapacityPicker==YES) {
                    showStudentCapacityPicker=NO;
                }else{
                    [self closeallpickers];
                    showStudentCapacityPicker=YES;
                    
                }
                
                [self showsidewindowwithwindow:@""];
                
                //[self storeTmpField];
                [SubjectPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==1 && indexPath.row==15 && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject) {
                selectedItem=@"PregenPeriod";
                
                if (showPregenPeriodPicker==YES) {
                    showPregenPeriodPicker=NO;
                }else{
                    [self closeallpickers];
                    showPregenPeriodPicker=YES;
                    
                }
                
                [self showsidewindowwithwindow:@""];
                
                //[self storeTmpField];
                [SubjectPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==1 && indexPath.row==13 && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject) {
                selectedItem=@"StandardPeriod";
                
                if (showStandardPeriodPicker==YES) {
                    showStandardPeriodPicker=NO;
                }else{
                    [self closeallpickers];
                    showStandardPeriodPicker=YES;
                }
                
                if ([StandandPeriodLabel.text isEqualToString:@""]) {
                    if ([workingSubject.tuition_mode isEqualToString:@"Month"]) {
                        workingSubject.standardnoofclassormonth=@"1";
                        workingSubject.enrollmentmode=@"Month";
                    }else if ([workingSubject.tuition_mode isEqualToString:@"Class"]) {
                        workingSubject.standardnoofclassormonth=@"4";
                        workingSubject.enrollmentmode=@"Class";
                    }else{
                        workingSubject.standardnoofclassormonth=@"4";
                        workingSubject.enrollmentmode=@"Class";
                        workingSubject.tuition_mode=@"Class";
                    }
                    StandandPeriodLabel.text=[NSString stringWithFormat:@"%@ %@",workingSubject.standardnoofclassormonth,[MyClass returntitlewithtitle:@"Classes"]];
                }
                [self showsidewindowwithwindow:@""];
                //[self storeTmpField];
                [SubjectPopoverTable reloadData];
                [self adjusttablesize];
                
                
            }else if (indexPath.section==2 && indexPath.row==1 && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject) {
                selectedItem=@"Validity";
                
                //[self storeTmpField];
                
                if (showValidity==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [SubjectPopoverTable reloadData];
                }else{
                    [self closeallpickers];
                    
                    [self showsidewindowwithwindow:@"showValidity"];
                    [ValidityTable reloadData];
                    [SubjectPopoverTable reloadData];
                    [self adjusttablesize];
                }
                
                
            }else if (indexPath.section==3 && indexPath.row==0 /*&& ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject*/) {
                //selectedItem=@"Validity";
                
                //[self storeTmpField];
                
                if (showMakeupTable==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [SubjectPopoverTable reloadData];
                }else{
                    [self closeallpickers];
                    
                    [self showsidewindowwithwindow:@"showMakeup"];
                    [MakeupTable reloadData];
                    [SubjectPopoverTable reloadData];
                    [self adjusttablesize];
                }
                
            }else if (indexPath.section==1 && indexPath.row==3 && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject) {
                
                selectedItem=@"ClassDuration";
                
                
                if (showClassDurationPicker==YES) {
                    showClassDurationPicker=NO;
                }else{
                    [self closeallpickers];
                    showClassDurationPicker=YES;
                }
                
                if ([workingSubject.classduration isEqualToString:@""]) {
                    if ([globalvariables.centerrecord.classtimeinterval intValue]>=60) {
                        workingSubject.classduration=globalvariables.centerrecord.classtimeinterval;
                    }else{
                        workingSubject.classduration=[NSString stringWithFormat:@"%i",(int)(60/[globalvariables.centerrecord.classtimeinterval intValue])*[globalvariables.centerrecord.classtimeinterval intValue]];
                    }
                }
                [self showsidewindowwithwindow:@""];
                //[self storeTmpField];
                [SubjectPopoverTable reloadData];
                [self adjusttablesize];
                
                
            }else if (indexPath.section==1 && indexPath.row==5 && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject) {
                selectedItem=@"ClassDurationAssessment";
                
                if (showClassDurationAssessmentPicker==YES) {
                    showClassDurationAssessmentPicker=NO;
                }else{
                    [self closeallpickers];
                    showClassDurationAssessmentPicker=YES;
                }
                
                if ([workingSubject.classduration_assessment isEqualToString:@""]) {
                    if ([globalvariables.centerrecord.classtimeinterval intValue]>=60) {
                        workingSubject.classduration_assessment=globalvariables.centerrecord.classtimeinterval;
                    }else{
                        workingSubject.classduration_assessment=[NSString stringWithFormat:@"%i",(int)(60/[globalvariables.centerrecord.classtimeinterval intValue])*[globalvariables.centerrecord.classtimeinterval intValue]];
                    }
                }
                
                //[self storeTmpField];
                [SubjectPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==1 && indexPath.row==7 && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject) {
                selectedItem=@"ClassDurationTrial";
                
                if (showClassDurationTrialPicker==YES) {
                    showClassDurationTrialPicker=NO;
                }else{
                    [self closeallpickers];
                    showClassDurationTrialPicker=YES;

                    //showCourseSchedule=NO;
                }
                
                if ([workingSubject.classduration_trial isEqualToString:@""]) {
                    if ([globalvariables.centerrecord.classtimeinterval intValue]>=60) {
                        workingSubject.classduration_trial=globalvariables.centerrecord.classtimeinterval;
                    }else{
                        workingSubject.classduration_trial=[NSString stringWithFormat:@"%i",(int)(60/[globalvariables.centerrecord.classtimeinterval intValue])*[globalvariables.centerrecord.classtimeinterval intValue]];
                    }
                }
                [self showsidewindowwithwindow:@""];
                //[self storeTmpField];
                [SubjectPopoverTable reloadData];
                [self adjusttablesize];
                
                
            }else if (indexPath.section==1 && indexPath.row==9 && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject) {
                
                selectedItem=@"TuitionMethod";
                
                workingSubject.tuitionArray=[[NSMutableArray alloc]init];
                
                if (showTuitionMethodPicker==YES) {
                    showTuitionMethodPicker=NO;
                }else{
                    [self closeallpickers];
                    showTuitionMethodPicker=YES;
                    //showCourseSchedule=NO;
                }
                
                
                if ([workingSubject.tuition_method isEqualToString:@""]) {
                    workingSubject.tuition_method=@"Level";
                }
                
                
                workingSubject.tuitionArray=[[NSMutableArray alloc]init];
                if ([workingSubject.tuition_method isEqualToString:@"Level"]) {
                    for (int i=0; i<workingSubject.levelArray.count; i++) {
                        [workingSubject.tuitionArray addObject:[[TuitionRecord alloc]initTuitionRecordwithSubject_Shortname:workingSubject.subject_shortname Method:@"Level" Scale:((LevelRecord *)[workingSubject.levelArray objectAtIndex:i]).level TuitionFee:@"0" newtuitionfee:@"" effectivedate:@""]];
                    }
                }else{
                    for (int i=0; i<tmpgradearray.count; i++) {
                        [workingSubject.tuitionArray addObject:[[TuitionRecord alloc]initTuitionRecordwithSubject_Shortname:workingSubject.subject_shortname Method:@"Grade" Scale:[tmpgradearray objectAtIndex:i] TuitionFee:@"0" newtuitionfee:@"" effectivedate:@""]];
                    }
                }
                

                addleveltuitionrecordlabel.hidden=workingSubject.levelArray.count==0?NO:YES;
                
                [self showsidewindowwithwindow:@""];
                //[self storeTmpField];
                [SubjectPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==1 && indexPath.row==11 && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject) {
                
                selectedItem=@"TuitionMode";
                
                if (showTuitionModePicker==YES) {
                    showTuitionModePicker=NO;
                }else{
                    [self closeallpickers];
                    showTuitionModePicker=YES;
                    //showCourseSchedule=NO;
                }
                
                if ([workingSubject.tuition_mode isEqualToString:@""]) {
                    if ([workingSubject.enrollmentmode isEqualToString:@"Month"]) {
                        workingSubject.tuition_mode=@"Month";
                    }else{
                        workingSubject.tuition_mode=@"Class";
                    }
                }
                [self showsidewindowwithwindow:@""];
                //[self storeTmpField];
                [SubjectPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==4 && indexPath.row==0/* && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).edituserschedule*/) {
                
                selectedItem=@"CourseSchedule";
                CourseTableMode=@"View";
                //[self storeTmpField];
                
                if (showCourseSchedule==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [SubjectPopoverTable reloadData];
                }else{
                    [self closeallpickers];
                    [self showsidewindowwithwindow:@"showCourseSchedule"];
                    [self InitializeCSField];
                    
                    [self createCourseScheduleToolBarwithMode:CourseTableMode];
                    [self adjusttablesize];
                    [SubjectPopoverTable reloadData];
                    [SubjectPopoverTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                }
                
                [CourseScheduleTable reloadData];
                
                
            }else if (indexPath.section==5 && indexPath.row==0/* && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject*/) {
                selectedItem=@"NoOfLevel";
                //[self storeTmpField];
                
                if (showLevelTuitionTable==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [SubjectPopoverTable reloadData];
                }else{
                    [self closeallpickers];
                    
                    noschedulerecordlabel.hidden=YES;
                    addschedulerecordlabel.hidden=YES;
                    addleveltuitionrecordlabel.hidden=workingSubject.levelArray.count==0?NO:YES;
                    [self showsidewindowwithwindow:@"showLevelTuition"];
                    [self createLevelTuitionToolBar];
                    [LevelTuitionTable reloadData];
                    [SubjectPopoverTable reloadData];
                    [self adjusttablesize];
                }
            }else if (indexPath.section==6 && indexPath.row==0/* && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject*/) {
                selectedItem=@"NoOfGrade";
                //[self storeTmpField];
                
                if (showGradeTuitionTable==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [SubjectPopoverTable reloadData];
                }else{
                    [self closeallpickers];
                    
                    noschedulerecordlabel.hidden=YES;
                    addschedulerecordlabel.hidden=YES;
                    addleveltuitionrecordlabel.hidden=YES;
                    [self showsidewindowwithwindow:@"showGradeTuition"];
                    [self createGradeTuitionToolBar];
                    [GradeTuitionTable reloadData];
                    
                    [SubjectPopoverTable reloadData];
                    [self adjusttablesize];
                }
            }else if (indexPath.section==7 /*&& ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject*/) {


                    [self closeallpickers];
                    
//                    noschedulerecordlabel.hidden=YES;
//                    addschedulerecordlabel.hidden=YES;
//                    addleveltuitionrecordlabel.hidden=YES;
                lessonnumbertype=indexPath.row==0?@"noteset1":@"noteset2";
                    [self showsidewindowwithwindow:@"showLessonNumberTable"];
                    [lessonNumberTable reloadData];
                [self createLessonNumberToolBar];
                    [SubjectPopoverTable reloadData];
                    [self adjusttablesize];
            }else if (indexPath.section==8 /*&& ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject*/){
                [self showsidewindowwithwindow:@"showChatBotSettingsTable"];
                [self closeallpickers];
                [self createChatBotSettingsToolBar];
                [chatBotSettingsTable reloadData];
                [SubjectPopoverTable reloadData];
                [self adjusttablesize];
            }else if (indexPath.section==1 && indexPath.row==17){
                if ([workingSubject.autolevelupgrade isEqualToString:@"Disabled"] || [workingSubject.autolevelupgrade isEqualToString:@"Every Renewal"]) {
                    [self showsidewindowwithwindow:@"showAutoLevelUpgradeOptionTable"];
                }else{
                    [self showsidewindowwithwindow:@"showAutoLevelUpgradeValuesTable"];
                    [autoLevelUpgradeValuesTable reloadData];
                }
                
                [self createAutoLevelUpgradeViewToolBar];
                [autoLevelUpgradeOptionTable reloadData];
                [SubjectPopoverTable reloadData];
                
                [self adjusttablesize];
            }
        }else{
            if (indexPath.section==3 && indexPath.row==0) {

                //[self storeTmpField];
                
                if (showMakeupTable==YES) {
                    [self showsidewindowwithwindow:@""];
                    [self adjusttablesize];
                    [SubjectPopoverTable reloadData];
                }else{
                    [self closeallpickers];
                    
                    [self showsidewindowwithwindow:@"showMakeup"];
                    [MakeupTable reloadData];
                    [SubjectPopoverTable reloadData];
                    [self adjusttablesize];
                }
                
            }else if (indexPath.section==4 && indexPath.row==0) {
                selectedItem=@"CourseSchedule";
                CourseTableMode=@"View";

                if (showCourseSchedule==YES) {
                    showCourseSchedule=NO;
                    showcsInstructorTable=NO;
                    showcsClassroomTable=NO;
                    showcsDayDateTimeTable=NO;
                    showScheduleLevelTable=NO;
                    [self adjusttablesize];
                    [SubjectPopoverTable deselectRowAtIndexPath:indexPath animated:YES];
                }else{
                    [self closeallpickers];
                    [self showsidewindowwithwindow:@"showCourseSchedule"];
                    [self InitializeCSField];
                    
                    [self createCourseScheduleToolBarwithMode:CourseTableMode];
                    [self adjusttablesize];
                    [SubjectPopoverTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
                }

                [CourseScheduleTable reloadData];
            }else if (indexPath.section==5 && indexPath.row==0){

                selectedItem=@"NoOfLevel";
                noschedulerecordlabel.hidden=YES;
                addschedulerecordlabel.hidden=YES;
                addleveltuitionrecordlabel.hidden=YES;
                [self showsidewindowwithwindow:@"showLevelTuition"];
                [self createLevelTuitionToolBar];
                [LevelTuitionTable reloadData];
                
                ////[self storeTmpField];
                [SubjectPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==6 && indexPath.row==0){
                
                selectedItem=@"NoOfGrade";
                noschedulerecordlabel.hidden=YES;
                addschedulerecordlabel.hidden=YES;
                addleveltuitionrecordlabel.hidden=YES;
                [self showsidewindowwithwindow:@"showGradeTuition"];
                [self createGradeTuitionToolBar];
                [GradeTuitionTable reloadData];
                
                ////[self storeTmpField];
                [SubjectPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==7){
                lessonnumbertype=indexPath.row==0?@"noteset1":@"noteset2";
                [self showsidewindowwithwindow:@"showLessonNumberTable"];
                [self createLessonNumberToolBar];
                [lessonNumberTable reloadData];
                
                [SubjectPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==8){
                [self showsidewindowwithwindow:@"showChatBotSettingsTable"];
                [self createChatBotSettingsToolBar];
                [chatBotSettingsTable reloadData];
                
                [SubjectPopoverTable reloadData];
                [self adjusttablesize];
                
            }
        }
    }else if (tableView==SubjectCategoryTable) {
        [self.view endEditing:YES];
        if(showChatBotCategoryTable){
            if (![workingSubject.chatbot_category isEqualToString:((SubjectCategoryRecord *)[filteredSubjectCategoryArray objectAtIndex:indexPath.row]).scategorykey]) {
                workingSubject.chatbot_category=((SubjectCategoryRecord *)[filteredSubjectCategoryArray objectAtIndex:indexPath.row]).scategorykey;
                //[self storeTmpField];
                [chatBotSettingsTable reloadData];
                [SubjectCategoryTable reloadData];
            }
        }else{
            if (![workingSubject.subject_category isEqualToString:((SubjectCategoryRecord *)[filteredSubjectCategoryArray objectAtIndex:indexPath.row]).scategorykey]) {
                workingSubject.subject_category=((SubjectCategoryRecord *)[filteredSubjectCategoryArray objectAtIndex:indexPath.row]).scategorykey;
                //[self storeTmpField];
                [SubjectPopoverTable reloadData];
                [SubjectCategoryTable reloadData];
            }
        }
        
    }else if (tableView==CourseScheduleTable){
        if ([CourseTableMode isEqualToString:@"Add"] || [CourseTableMode isEqualToString:@"Edit"]) {
            if (indexPath.section==0 && indexPath.row==9 && [[self filtercstimearray:workingSchedule.daytimearray] count]!=0) {
                if ([[self filtercstimearray:workingSchedule.daytimearray] count]>0  && ![workingSchedule.type isEqualToString:@"Fixed"]) {
                    selectedItem=@"CSStartDate";
                    csClassDateHeaderLabel.text=[[MyClass returntitlewithtitle:@"Start Date"] uppercaseString];
                    [self closeallpickers];
                    [self showsidewindowwithwindow:@"showcsClassDate"];
                    [csClassDateTable reloadData];
                    [CourseScheduleTable reloadData];
                    [self adjusttablesize];
                }
            }else if (indexPath.section==0 && indexPath.row==10 && [[self filtercstimearray:workingSchedule.daytimearray] count]!=0) {
                if ([[self filtercstimearray:workingSchedule.daytimearray] count]>0  && ![workingSchedule.type isEqualToString:@"Fixed"]) {
                    selectedItem=@"CSEndDate";
                    csClassDateHeaderLabel.text=[[MyClass returntitlewithtitle:@"End Date"] uppercaseString];
                    [self closeallpickers];
                    [self showsidewindowwithwindow:@"showcsClassDate"];
                    [csClassDateTable reloadData];
                    [CourseScheduleTable reloadData];
                    [self adjusttablesize];
                }
            }else if (indexPath.section==0 && indexPath.row==11) {
                scheduleLevelArray=[[NSMutableArray alloc]initWithArray:[MyClass returnLevelOnlyArrayWithSubject:workingSubject.subject_shortname]];
//                filteredScheduleLevelArray=[[NSMutableArray alloc]initWithArray:scheduleLevelArray];
                [self returnFilteredScheduleLevelArray];
                
                [self closeallpickers];
                [self showsidewindowwithwindow:@"showScheduleLevelTable"];
                [ScheduleLevelTable reloadData];
                [CourseScheduleTable reloadData];
                [self adjusttablesize];
            }
        }else if ([CourseTableMode isEqualToString:@"View"] && /*![SubjectTableMode isEqualToString:@"View"]*/([SubjectTableMode isEqualToString:@"Add"] || ([SubjectTableMode isEqualToString:@"Edit"] && (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).edituserschedule)))){
            CourseTableMode=@"Edit";
            cseditindex=indexPath.row;
            [self InitializeCSField];
            [self createCourseScheduleToolBarwithMode:CourseTableMode];
            [CourseScheduleTable reloadData];
            [self adjusttablesize];
        }
    }else if (tableView==csInstructorTable){
        if([selectedItem isEqualToString:@"CSInstructor"]){
            if (![workingScheduleDetails.instructor isEqualToString:((Instructor *)[filteredcsInstructorArray objectAtIndex:indexPath.row]).username]) {
                //[self storeCSTmpField];
                workingScheduleDetails.instructor=((Instructor *)[filteredcsInstructorArray objectAtIndex:indexPath.row]).username;
                
                [csInstructorTable reloadData];
                [CourseScheduleTable reloadData];
                //[self adjusttablesize];
            }
        }else{
            if (![workingScheduleDetails.sinstructor isEqualToString:((Instructor *)[filteredcsInstructorArray objectAtIndex:indexPath.row]).username]) {
                //[self storeCSTmpField];
                workingScheduleDetails.sinstructor=((Instructor *)[filteredcsInstructorArray objectAtIndex:indexPath.row]).username;
                
                [csInstructorTable reloadData];
                [CourseScheduleTable reloadData];
                //[self adjusttablesize];
            }
        }
        
    }else if (tableView==csClassroomTable){
        if (![workingScheduleDetails.classroom isEqualToString:((ClassroomRecord *)[filteredcsClassroomArray objectAtIndex:indexPath.row]).classroom]) {
            //[self storeCSTmpField];
            workingScheduleDetails.classroom=((ClassroomRecord *)[filteredcsClassroomArray objectAtIndex:indexPath.row]).classroom;
            
            [csClassroomTable reloadData];
            [CourseScheduleTable reloadData];
            //[self adjusttablesize];
        }
    }else if(tableView==ColorCodeTable){
        if (workingSubject.colorcode !=indexPath.row) {
            workingSubject.colorcode=indexPath.row;
            [ColorCodeTable reloadData];
            [SubjectPopoverTable reloadData];
            [self adjusttablesize];
        }
    }else if (tableView==chatBotSettingsTable){
        if (indexPath.section==0 && indexPath.row==1) {
            [self closeallpickers];
            [self showsidewindowwithwindow:@"showChatBotCategory"];
            [self adjusttablesize];
            [chatBotSettingsTable reloadData];
            [chatBotSettingsTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [SubjectCategoryTable reloadData];
        }else if (indexPath.section==4 && indexPath.row==1) {
            selectedItem=@"TrialCapacity";
            
            if (showTrialCapacityPicker==YES) {
                showTrialCapacityPicker=NO;
            }else{
                [self closeallpickers];
                showTrialCapacityPicker=YES;
                
            }
            
//            [self showsidewindowwithwindow:@""];
            
            //[self storeTmpField];
            [chatBotSettingsTable reloadData];
            [self adjusttablesize];
            
        }
    }else if (tableView==autoLevelUpgradeOptionTable){
        if(indexPath.row==0){
            workingSubject.autolevelupgrade=@"Disabled";
            [autoLevelUpgradeOptionTable reloadData];
            [SubjectPopoverTable reloadData];
            [self showsidewindowwithwindow:@"showAutoLevelUpgradeOptionTable"];
        }else if (indexPath.row==1){
            workingSubject.autolevelupgrade=@"Every Renewal";
            [autoLevelUpgradeOptionTable reloadData];
            [SubjectPopoverTable reloadData];
            [self showsidewindowwithwindow:@"showAutoLevelUpgradeOptionTable"];
        }else if (indexPath.row==2){
            if ([workingSubject.autolevelupgrade isEqualToString:@"Disabled"] || [workingSubject.autolevelupgrade isEqualToString:@"Every Renewal"]) {
                workingSubject.autolevelupgrade=@"Y0101";
            }
            [autoLevelUpgradeOptionTable reloadData];
            [autoLevelUpgradeValuesTable reloadData];
            [SubjectPopoverTable reloadData];
            [self showsidewindowwithwindow:@"showAutoLevelUpgradeValuesTable"];
        }
        [self adjusttablesize];
    }else if (tableView==autoLevelUpgradeValuesTable){
        workingSubject.autolevelupgrade = [NSString stringWithFormat:@"Y%02ld01", (long)(indexPath.row + 1)];
        [autoLevelUpgradeValuesTable reloadData];
        [SubjectPopoverTable reloadData];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    if ([selectedItem isEqualToString:@"StandardPeriod"]) {
        return 2;
    }else if ([selectedItem isEqualToString:@"CSClassTime"]) {
        return 3;
    }else if ([selectedItem isEqualToString:@"Validity"]) {
        return 2;
    }else if([selectedItem isEqualToString:@"DateTime"]){
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if ([selectedItem isEqualToString:@"StandardPeriod"]) {
        if (component==0){
            return [standardnoofclassormontharray count];
        }else{
            return [enrollmentmodearray count];
        }
    }else if([selectedItem isEqualToString:@"CSClassTime"]){
        if (component==0){
            return [dayPickerViewMenu count];
        }else if (component==1){
            return [hourPickerViewMenu count];
        }else{
            return [minutePickerViewMenu count];
        }
    }else if([selectedItem isEqualToString:@"Validity"]){
        if (component==0){
            return [validtyValuePickerViewMenu count];
        }else{// if (component==1){
            return [validityTypePickerViewMenu count];
        }
    }else if([selectedItem isEqualToString:@"DateTime"]){
        if (component==0){
            return [hourPickerViewMenu count];
        }else{
            return [minutePickerViewMenu count];
        }
        
    }else{
        return [pickerViewmenu count];
    }
}



- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* tView = (UILabel*)view;
    if (!tView)
    {
        tView = [[UILabel alloc] init];
        tView.textAlignment=NSTextAlignmentCenter;
        [tView setFont:[UIFont systemFontOfSize:18]];
        tView.adjustsFontSizeToFitWidth=YES;
        tView.minimumScaleFactor=0.7;
        //[tView setTextAlignment:UITextAlignmentLeft];
        tView.numberOfLines=3;
    }
    // Fill the label text here
    
    if([selectedItem isEqualToString:@"DateTime"]){
        [tView setFont:[UIFont systemFontOfSize:16]];
        if (component==0){
            tView.text= [hourPickerViewMenu objectAtIndex:row];
        }else{
            tView.text= [minutePickerViewMenu objectAtIndex:row];
        }
    }else if ([selectedItem isEqualToString:@"StandardPeriod"]) {
        if (component==0){
            tView.text= [standardnoofclassormontharray objectAtIndex:row];
        }else{
            tView.text= [MyClass returntitlewithtitle:[enrollmentmodearray objectAtIndex:row]];
        }
    }else if ([selectedItem isEqualToString:@"TuitionMethod"]) {
        tView.text= [MyClass returntitlewithtitle:[pickerViewmenu objectAtIndex:row]];
    }else if ([selectedItem isEqualToString:@"TuitionMode"]) {
        tView.text= [MyClass returntitlewithtitle:[pickerViewmenu objectAtIndex:row]];
    }else if ([selectedItem isEqualToString:@"CSInstructor"]){
        if ([((Instructor *)[pickerViewmenu objectAtIndex:row]).firstname isEqualToString:@"TBD"]) {
            tView.text=[MyClass returntitlewithtitle:@"TBD"];
        }else{
            tView.text=[MyClass returninstructornamewithusername:((Instructor *)[pickerViewmenu objectAtIndex:row]).username firstorfullname:@"full"];
        }
    }else if ([selectedItem isEqualToString:@"CSClassroom"]){
        if ([((ClassroomRecord *)[pickerViewmenu objectAtIndex:row]).classroom isEqualToString:@"TBD"]) {
            tView.text=[MyClass returntitlewithtitle:@"TBD"];
        }else{
            tView.text= ((ClassroomRecord *)[pickerViewmenu objectAtIndex:row]).classroom;
        }
    }else if([selectedItem isEqualToString:@"CSClassTime"]){
        if (component==0){
            tView.text= [MyClass returntitlewithtitle:[dayPickerViewMenu objectAtIndex:row]];
        }else if (component==1){
            tView.text= [hourPickerViewMenu objectAtIndex:row];
        }else{
            tView.text= [minutePickerViewMenu objectAtIndex:row];
        }
    }else if([selectedItem isEqualToString:@"Validity"]){
        if (component==0){
            tView.text= [validtyValuePickerViewMenu objectAtIndex:row];
        }else{// if (component==1){
            tView.text= [MyClass returntitlewithtitle:[validityTypePickerViewMenu objectAtIndex:row]];
        }
    }/*else if ([selectedItem isEqualToString:@"makeup_quota"]){
        if(component==0){
            tView.text= [MyClass returntitlewithtitle:[makeupQuotaUnitArray objectAtIndex:row]];
        }else{
            //if (![workingSubject.makeup_quota_unit isEqualToString:@""]) {
                tView.text= [pickerViewmenu objectAtIndex:row];
            //}
        }
        

    }*/else if ([selectedItem isEqualToString:@"StudentCapacity"]){
        if ([[pickerViewmenu objectAtIndex:row] isEqualToString:@""]) {
            tView.text=[MyClass returntitlewithtitle:@"Unlimited"];
        }else{
            tView.text= [pickerViewmenu objectAtIndex:row];
        }
    }else if ([selectedItem isEqualToString:@"TrialCapacity"]){
        if ([[pickerViewmenu objectAtIndex:row] isEqualToString:@""]) {
            tView.text=[MyClass returntitlewithtitle:@"Unlimited"];
        }else{
            tView.text= [pickerViewmenu objectAtIndex:row];
        }
    }else{
        tView.text= [pickerViewmenu objectAtIndex:row];
    }
    return tView;
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if([selectedItem isEqualToString:@"DateTime"]){
        if (component==0){
            return 30;
        }else{
            return 30;
        }
    }else if ([selectedItem isEqualToString:@"StandardPeriod"]) {
        return 60;
    }else if ([selectedItem isEqualToString:@"CSInstructor"]) {
        return 260;
    }else if ([selectedItem isEqualToString:@"CSClassrooom"]) {
        return 260;
    }else if ([selectedItem isEqualToString:@"CSClassTime"]) {
        return 60;
    }else if ([selectedItem isEqualToString:@"Validity"]) {
        return 60;
    }/*else if ([selectedItem isEqualToString:@"makeup_quota"]){
        if (component==0) {
            return 120;
        }else{
           return 60;
        }
    }*/else{
        return 260;
    }

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([selectedItem isEqualToString:@"StudentCapacity"]){
        if (![workingSubject.studentcapacity isEqualToString:[pickerViewmenu objectAtIndex:row]]) {
            workingSubject.studentcapacity=[pickerViewmenu objectAtIndex:row];
            
            showStudentCapacityPicker=NO;
            
            //[self storeTmpField];
            [SubjectPopoverTable reloadData];
            [self adjusttablesize];
            
        }
        
    }else if([selectedItem isEqualToString:@"TrialCapacity"]){
        if (![workingSubject.trialcapacity isEqualToString:[pickerViewmenu objectAtIndex:row]]) {
            workingSubject.trialcapacity=[pickerViewmenu objectAtIndex:row];
            
            showTrialCapacityPicker=NO;
            
            //[self storeTmpField];
            [chatBotSettingsTable reloadData];
            [self adjusttablesize];
            
        }
        
    }else if([selectedItem isEqualToString:@"StandardPeriod"]){

        if(component==0){
            workingSubject.standardnoofclassormonth=[standardnoofclassormontharray objectAtIndex:row];
        }else{
            workingSubject.enrollmentmode=[[enrollmentmodearray objectAtIndex:row] isEqualToString:@"Class"]?@"Class":@"Month";
            if ([workingSubject.enrollmentmode isEqualToString:@"Class"]) {
                if ([workingSubject.makeup_quota_unit isEqualToString:@"F"]) {
                    workingSubject.makeup_quota_unit=@"";
                    workingSubject.makeup_quota_value=@"-1";
                }
            }
        }
        
        
        //showStandardPeriodPicker=NO;
        
        //[self storeTmpField];
        [SubjectPopoverTable reloadData];
        [self adjusttablesize];
        
        
    }else if([selectedItem isEqualToString:@"ClassDuration"]){
        if (![workingSubject.classduration isEqualToString:[pickerViewmenu objectAtIndex:row]]) {
            workingSubject.classduration=[pickerViewmenu objectAtIndex:row];
            
            showClassDurationPicker=NO;
            
            //[self storeTmpField];
            [SubjectPopoverTable reloadData];
            [self adjusttablesize];
            
        }
        
    }else if([selectedItem isEqualToString:@"ClassDurationAssessment"]){
        if (![workingSubject.classduration_assessment isEqualToString:[pickerViewmenu objectAtIndex:row]]) {
            workingSubject.classduration_assessment=[pickerViewmenu objectAtIndex:row];
            
            showClassDurationPicker=NO;
            
            //[self storeTmpField];
            [SubjectPopoverTable reloadData];
            [self adjusttablesize];
            
        }
        
    }else if([selectedItem isEqualToString:@"ClassDurationTrial"]){
        if (![workingSubject.classduration_trial isEqualToString:[pickerViewmenu objectAtIndex:row]]) {
            workingSubject.classduration_trial=[pickerViewmenu objectAtIndex:row];
            
            showClassDurationPicker=NO;
            
            //[self storeTmpField];
            [SubjectPopoverTable reloadData];
            [self adjusttablesize];
            
        }
        
    }else if([selectedItem isEqualToString:@"TuitionMethod"]){
        if (![workingSubject.tuition_method isEqualToString:[pickerViewmenu objectAtIndex:row]]) {
            workingSubject.tuition_method=[pickerViewmenu objectAtIndex:row];
            //Tuition_MethodLabel.text=[MyClass returntitlewithtitle:workingSubject.tuition_method];
            
            showTuitionMethodPicker=NO;
            showGradeTuition=[workingSubject.tuition_method isEqualToString:@"Grade"] ? YES:NO;
            
            if ([workingSubject.tuition_method isEqualToString:@"Grade"]) {
                //remove leveltuitiontext
                workingSubject.tuitionArray=[[NSMutableArray alloc]init];
                for (int i=0; i<tmpgradearray.count; i++) {
                    //tuitionobject=[workingSubject.tuitionArray objectAtIndex:i];
                    [workingSubject.tuitionArray addObject:[[TuitionRecord alloc]initTuitionRecordwithSubject_Shortname:workingSubject.subject_shortname Method:@"Grade" Scale:[tmpgradearray objectAtIndex:i] TuitionFee:@"0" newtuitionfee:@"" effectivedate:@""]];
                    
                }
                addleveltuitionrecordlabel.hidden=YES;
                noschedulerecordlabel.hidden=YES;
                addschedulerecordlabel.hidden=YES;
                [self showsidewindowwithwindow:@"showGradeTuition"];
                [self createGradeTuitionToolBar];
                [GradeTuitionTable reloadData];
            }else{
                //remove gradetutiontext

                
                workingSubject.tuitionArray=[[NSMutableArray alloc]init];
                for (int i=0; i<workingSubject.levelArray.count; i++) {
                    //tuitionobject=[workingSubject.tuitionArray objectAtIndex:i];
                    [workingSubject.tuitionArray addObject:[[TuitionRecord alloc]initTuitionRecordwithSubject_Shortname:workingSubject.subject_shortname Method:@"Level" Scale:((LevelRecord *)[workingSubject.levelArray objectAtIndex:i]).level TuitionFee:@"0" newtuitionfee:@"" effectivedate:@""]];
                }
                addleveltuitionrecordlabel.hidden=workingSubject.levelArray.count==0?NO:YES;
                addschedulerecordlabel.hidden=YES;
                noschedulerecordlabel.hidden=YES;
                [self showsidewindowwithwindow:@"showLevelTuition"];
                [self createLevelTuitionToolBar];
                [LevelTuitionTable reloadData];
            }
            
            //[self storeTmpField];
            [SubjectPopoverTable reloadData];
            [self adjusttablesize];
            
        }
        
    }else if([selectedItem isEqualToString:@"TuitionMode"]){
        if (![Tuition_ModeLabel.text isEqualToString:[pickerViewmenu objectAtIndex:row]]) {
            workingSubject.tuition_mode=[pickerViewmenu objectAtIndex:row];
            
            if ([workingSubject.tuition_mode isEqualToString:@"Month"]) {
                if ([workingSubject.enrollmentmode isEqualToString:@"Class"]) {
                    workingSubject.enrollmentmode=@"";
                    workingSubject.standardnoofclassormonth=@"";
                    
                    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Subject"] message:[MyClass returntitlewithtitle:@"Please select Standard Period again which needs to be in Month for tuition mode equals to Month"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [erroralert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [erroralert addAction:OKAction];
                    //[self presentViewController:erroralert animated:YES completion:nil];
                    [MyClass presentViewController:erroralert View:self];
                }
            }
            
            showTuitionModePicker=NO;
            
            //[self storeTmpField];
            [SubjectPopoverTable reloadData];
            [self adjusttablesize];
            
        }
        
    }else if([selectedItem isEqualToString:@"CSClassTime"]){
        if(![workingScheduleDetails.dayofweek isEqualToString:[dayPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]]]){
            workingScheduleDetails.dayofweek=[dayPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]];
            
            [CourseScheduleTable reloadData];
            [self adjusttablesize];
        }
        
        if (![workingScheduleDetails.classtime isEqualToString:[NSString stringWithFormat:@"%@:%@",[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:2]]]]) {
            
            
            //check if selected time is within operating hour
            NSString *selectedtime=[NSString stringWithFormat:@"%@%@",[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:2]]];
            int classduration=[workingSubject.classduration intValue];
            //classduration=(int)(classduration/60)*100+classduration%60;
            if ([selectedtime intValue]<[globalvariables.centerrecord.classstarttime intValue]) {
                UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Course Schedule"] message:[MyClass returntitlewithtitle:@"Class start time is outside center's opening hour"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [wrongTimeAlert addAction:OKAction];
                //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                [MyClass presentViewController:wrongTimeAlert View:self];
                
                [CourseScheduleTable reloadData];
            }else if ([MyClass classendtimebeyondcenterendtimewithclassstarttime:selectedtime duration:classduration]){
                UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Course Schedule"] message:[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [wrongTimeAlert addAction:OKAction];
                //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                [MyClass presentViewController:wrongTimeAlert View:self];
                
                [CourseScheduleTable reloadData];
                
            }else{
                //[self storeCSTmpField];
                workingScheduleDetails.classtime=[NSString stringWithFormat:@"%@:%@",[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:2]]];
                
                [CourseScheduleTable reloadData];
                [self adjusttablesize];
            }
        }
    }else if([selectedItem isEqualToString:@"Validity"]){
        workingSubject.validity=[NSString stringWithFormat:@"%@%@",[[validityTypePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]] substringToIndex:1],[validtyValuePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]]];
        ValidityLabel.text=[MyClass returnvaliditylabelwithvaliditystring:workingSubject.validity];
    }/*else if([selectedItem isEqualToString:@"makeup_quota"]){
        if (component==0) {
            if (row==0) {
                workingSubject.makeup_quota_unit=@"";
                workingSubject.makeup_quota_value=@"-1";
                [pickerView reloadAllComponents];
            }else if (row==1){
                workingSubject.makeup_quota_unit=@"P";
                if ([workingSubject.makeup_quota_value isEqualToString:@"-1"]) {
                    workingSubject.makeup_quota_value=0;
                    [pickerView reloadAllComponents];
                }
            }else if (row==2){
                workingSubject.makeup_quota_unit=@"F";
                if ([workingSubject.makeup_quota_value isEqualToString:@"-1"]) {
                    workingSubject.makeup_quota_value=0;
                    [pickerView reloadAllComponents];
                }
            }
        }else if (component==1){
            workingSubject.makeup_quota_value=[pickerViewmenu objectAtIndex:row];
        }
        

        [MakeupTable reloadData];
    }*/else if([selectedItem isEqualToString:@"DateTime"]){
        //check if selected time is within operating hour
        
            NSString *selectedtime=[NSString stringWithFormat:@"%@%@",[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
            int classduration=[workingSubject.classduration intValue];
            if ([selectedtime intValue]<[globalvariables.centerrecord.classstarttime intValue]) {
                
                UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Appointment"] message:[MyClass returntitlewithtitle:@"Class start time is outside center's opening hour"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [wrongTimeAlert addAction:OKAction];
                //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                    [MyClass presentViewController:wrongTimeAlert View:self];
                
                
                [CourseScheduleTable reloadData];
            }else if ([MyClass classendtimebeyondcenterendtimewithclassstarttime:selectedtime duration:classduration]){
                UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Appointment"] message:[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [wrongTimeAlert addAction:OKAction];
                //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                    [MyClass presentViewController:wrongTimeAlert View:self];
                
                [CourseScheduleTable reloadData];
                
            }else{
                workingScheduleDetails.classtime=[NSString stringWithFormat:@"%@:%@",[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
                //StartDateTimeLabel.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:[NSString stringWithFormat:@"%@ %@",workingScheduleDetails.dayofweek,workingATObject.DTtime]];

                [CourseScheduleTable reloadData];
                [self adjusttablesize];
            }

        
    }else if([selectedItem isEqualToString:@"PregenPeriod"]){
        if (![[@(workingSubject.pregenperiodcount) stringValue] isEqualToString:[pickerViewmenu objectAtIndex:row]]) {
            workingSubject.pregenperiodcount=[[pickerViewmenu objectAtIndex:row] integerValue];
            
            showPregenPeriodPicker=NO;
            
            //[self storeTmpField];
            [SubjectPopoverTable reloadData];
            [self adjusttablesize];
            
        }
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    if (tableView==LevelTuitionTable) {
        if ([SubjectTableMode isEqualToString:@"Add"] || ([SubjectTableMode isEqualToString:@"Edit"] && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject)) {
            return YES;
        }
    }else if (tableView==lessonNumberTable) {
        if ([SubjectTableMode isEqualToString:@"Add"] || ([SubjectTableMode isEqualToString:@"Edit"] && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject)) {
            return YES;
        }
    }
    return NO;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==LevelTuitionTable) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //add code here for when you hit delete

            [workingSubject.levelArray removeObjectAtIndex:indexPath.row];
            //tmpNoOfLevel=[NSString stringWithFormat:@"%d",[tmpNoOfLevel intValue]-1];
            
            if ([workingSubject.tuition_method isEqualToString:@"Level"]) {
                [workingSubject.tuitionArray removeObjectAtIndex:indexPath.row];
            }
            
            if (workingSubject.levelArray.count==0) {
                addleveltuitionrecordlabel.hidden=NO;
            }
            
            [SubjectPopoverTable reloadData];
            [LevelTuitionTable reloadData];
        }
    }else if (tableView==lessonNumberTable){
        if(editingStyle==UITableViewCellEditingStyleDelete){
            NSMutableArray *lessonarray=workingSubject.lessonnumberDict[lessonnumbertype];
            [lessonarray removeObjectAtIndex:indexPath.row];
            if ((lessonarray.count==0)) {
                [workingSubject.lessonnumberDict removeObjectForKey:lessonnumbertype];
            }
            
            [lessonNumberTable reloadData];
            [SubjectPopoverTable reloadData];
        }
        
    }
}

-(void) updatesubjectcategoryupdatebuttonpressed:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self.view endEditing:YES];
    if ([subjectcategoryenglishnametext.text isEqualToString:@""] && [subjectcategorychinesenametext.text isEqualToString:@""]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Subject Category"] message:[MyClass returntitlewithtitle:@"Category name is missing"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [addsubjectcategoryviewcontroller presentViewController:erroralert animated:YES completion:nil];
    }else if ([self isCategoryNameDuplicatedWithSelfSCategorykey:subjectcategoryobject.scategorykey]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Subject Category"] message:[MyClass returntitlewithtitle:@"Category name already exists"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [addsubjectcategoryviewcontroller presentViewController:erroralert animated:YES completion:nil];
    }else{

        //combine arrays
        NSDictionary *dictionary = @{@"englishname" : [subjectcategoryenglishnametext.text isEqualToString:@""]?subjectcategorychinesenametext.text:subjectcategoryenglishnametext.text,
                                     @"chinesename" : [subjectcategorychinesenametext.text isEqualToString:@""]?subjectcategoryenglishnametext.text:subjectcategorychinesenametext.text,
                                     @"centerdb" : globalvariables.centerrecord.centerdb,
                                     @"centerkey" : globalvariables.centerrecord.centerkey,
                                     @"scategorykey" : subjectcategoryobject.scategorykey,
                                     @"colorcode" : [@(workingCategory.colorcode) stringValue],
                                     @"bundleforapppayment" : bundleforapppaymentbutton.isOn?@"Yes":@"No",
                                     @"postaction" : @"updatesubjectcategory"
                                     };
        
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
            //NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (!error) {
                result=TRUE;
            }
            dispatch_semaphore_signal(semaphore);
        }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
        
        if(result){
            allSubjectCategoryArray=[MyClass retrievesubjectcategorywithflushcachedata:YES];
            filteredSubjectCategoryArray=[[NSMutableArray alloc]initWithArray:allSubjectCategoryArray];
            subjectcategorysearchbar.text=@"";
            
            if ([workingSubject.subject_category isEqualToString:subjectcategoryobject.scategorykey]) {
                [SubjectPopoverTable reloadData];
            }
            
            
            [SubjectCategoryTable reloadData];
            [addsubjectcategoryviewcontroller dismissViewControllerAnimated:YES completion:nil];
        }/*else{
            [MyClass showconnectionlostdialogbox];
        }*/
    }
}

-(void)addsubjectcategorybuttonhighlightcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)addsubjectcategorybuttonresetcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
}

-(void)updatesubjectcategoryupdatebuttonhighlightcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)updatesubjectcategoryupdatebuttonresetcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
}

-(void)updatesubjectcategorycancelbuttonhighlightcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)updatesubjectcategorycancelbuttonresetcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
}

-(void)updatesubjectcategorydeletebuttonhighlightcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor redColor];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)updatesubjectcategorydeletebuttonresetcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

-(void)updatesubjectcategorydeletebuttonpressed:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self deletesubjectcategorywithscategorykey:subjectcategoryobject.scategorykey];
}

-(void) deletesubjectcategorywithscategorykey:(NSString *)scategorykey
{
    [self.view endEditing:YES];
    NSString *strURL;
    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletesubjectcategory&scategorykey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,scategorykey];
    
    
    __block BOOL result=FALSE;
    __block NSString *jsonresponse;

    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSArray *JSONArray = jsonreturned[@"content"];
            jsonresponse = [[JSONArray objectAtIndex:0] objectForKey:@"result"];
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
            NSArray *JSONArray = jsonreturned[@"content"];
            jsonresponse = [[JSONArray objectAtIndex:0] objectForKey:@"result"];
            
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        if ([jsonresponse isEqualToString:@"keybeingused"]) {

            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Not able to delete course category"] message:[MyClass returntitlewithtitle:@"Course category is being used in other subject"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                self->SubjectCategoryTable.editing=FALSE;
            }];
            
            [erroralert addAction:OKAction];
            [addsubjectcategoryviewcontroller presentViewController:erroralert animated:YES completion:nil];
        }else{
            subjectcategorysearchbar.text=@"";
            allSubjectCategoryArray=[MyClass retrievesubjectcategorywithflushcachedata:YES];
            filteredSubjectCategoryArray=[[NSMutableArray alloc]initWithArray:allSubjectCategoryArray];
            
            if ([workingSubject.subject_category isEqualToString:scategorykey]) {
                workingSubject.subject_category=@"";
                //[self storeTmpField];
                [SubjectPopoverTable reloadData];
            }
            [SubjectCategoryTable reloadData];
            [addsubjectcategoryviewcontroller dismissViewControllerAnimated:YES completion:nil];
        }
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
}


-(void) InitializeCSField
{
    workingSchedule=[[ScheduleRecord alloc]init];
    
    if (showCourseSchedule) {
        selecteddaytimebutton=nil;
        [self closeallpickers];
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showScheduleLevelTable=NO;
        addleveltuitionrecordlabel.hidden=YES;
        
        if ([CourseTableMode isEqualToString:@"Add"]) {
            workingSchedule.name=@"";
            workingSchedule.autorenew=@"Yes";
            workingSchedule.makeupschedule=globalvariables.centerrecord.defaultcsmakeupschedule;
            workingSchedule.active=YES;
            workingSchedule.daytimearray=[[NSMutableArray alloc]init];
            noschedulerecordlabel.hidden=YES;
            [self addcstimewithrownumber];
            workingSchedule.startdate=@"";
            workingSchedule.enddate=@"";
            workingSchedule.type=@"Recursive";
            workingSchedule.showintimetableifnoenrollment=globalvariables.centerrecord.defaultcsshowintimetableifnoenrollment;
            workingSchedule.onlinetrialschedule=NO;
            workingSchedule.levelarray=[[NSMutableArray alloc]init];

        }else if ([CourseTableMode isEqualToString:@"Clone"]) {
            CourseTableMode=@"Add";
            workingSchedule.name=[NSString stringWithFormat:@"%@ (%@)",((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).name,[MyClass returntitlewithtitle:@"Clone"]];
            workingSchedule.startdate=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).startdate;
            workingSchedule.enddate=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).enddate;
            workingSchedule.autorenew=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).autorenew;
            workingSchedule.makeupschedule=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).makeupschedule;
            workingSchedule.active=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).active;
            workingSchedule.daytimearray=[self copyScheduleTimeArrayWithScheduleRecord:[filteredScheduleArray objectAtIndex:cseditindex]];
            workingSchedule.type=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).type;
            workingSchedule.showintimetableifnoenrollment=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).showintimetableifnoenrollment;
            workingSchedule.onlinetrialschedule=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).onlinetrialschedule;
            workingSchedule.levelarray=[self copyScheduleLevelArrayWithScheduleRecord:[filteredScheduleArray objectAtIndex:cseditindex]];
            noschedulerecordlabel.hidden=YES;
            
        }else if ([CourseTableMode isEqualToString:@"View"]){
            if ([SubjectTableMode isEqualToString:@"View"]) {
                noschedulerecordlabel.hidden=[[self returndetailschedulearraycount] isEqualToString:@"0"]?NO:YES;
                addschedulerecordlabel.hidden=YES;
            }else{
                addschedulerecordlabel.hidden=[[self returndetailschedulearraycount] isEqualToString:@"0"]?NO:YES;
                noschedulerecordlabel.hidden=YES;
            }

        }else if ([CourseTableMode isEqualToString:@"Edit"]){
            workingSchedule.name=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).name;
            workingSchedule.startdate=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).startdate;
            workingSchedule.enddate=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).enddate;
            workingSchedule.autorenew=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).autorenew;
            workingSchedule.makeupschedule=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).makeupschedule;
            workingSchedule.active=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).active;
            workingSchedule.daytimearray=[self copyScheduleTimeArrayWithScheduleRecord:[filteredScheduleArray objectAtIndex:cseditindex]];
            workingSchedule.type=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).type;
            workingSchedule.showintimetableifnoenrollment=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).showintimetableifnoenrollment;
            workingSchedule.onlinetrialschedule=((ScheduleRecord *)[filteredScheduleArray objectAtIndex:cseditindex]).onlinetrialschedule;
            workingSchedule.levelarray=[self copyScheduleLevelArrayWithScheduleRecord:[filteredScheduleArray objectAtIndex:cseditindex]];
            /*for (int i=0; i<workingSchedule.daytimearray.count; i++) {
                [self addcstimewithrownumber:i createtimearray:NO];
            }*/
        }
    }
}

-(NSMutableArray *)copyScheduleTimeArrayWithScheduleRecord:(ScheduleRecord *)scheduleobject
{
    NSMutableArray *result=[[NSMutableArray alloc]init];
    for (int i=0; i<scheduleobject.daytimearray.count; i++) {
        ScheduleDetailsRecord *dayrecord=[scheduleobject.daytimearray objectAtIndex:i];
        [result addObject:[[ScheduleDetailsRecord alloc]initScheduleDetailsRecordwithdayofweek:dayrecord.dayofweek classtime:dayrecord.classtime instructor:dayrecord.instructor classroom:dayrecord.classroom sinstructor:dayrecord.sinstructor]];
    }
    return result;
}

-(void) addcstimewithrownumber
{
    //if (createtimearray) {
        [workingSchedule.daytimearray addObject:[[ScheduleDetailsRecord alloc]initScheduleDetailsRecordwithdayofweek:@"" classtime:@"" instructor:@"TBD" classroom:@"TBD" sinstructor:@"TBD"]];
    //}
}

-(NSString *) returndetailschedulearraycount
{
    return [NSString stringWithFormat:@"%lu",(unsigned long)filteredScheduleArray.count];
    /*
    int count=0;
    for (int i=0; i<workingSubject.scheduleArray.count; i++) {
        if (![((ScheduleRecord *)[workingSubject.scheduleArray objectAtIndex:i]).action isEqualToString:@"Delete"]) {
            count+=1;
        }
    }
    if ([workingSubject.tuition_mode isEqualToString:@"Month"]) {
        if (count-1<0) {
            count=1;
        }
        return [NSString stringWithFormat:@"%d",count-1];
    }else{
        if (count-2<0) {
            count=2;
        }
        return [NSString stringWithFormat:@"%d",count-2];
    }*/
}

-(NSMutableArray *) copytuitionarraywithtuitionarray:(NSMutableArray *)tuitionarray
{
    NSMutableArray *_tmptuitionarray=[[NSMutableArray alloc]init];;
    TuitionRecord *_tmptuitionrecord;
    
    if([workingSubject.tuition_method isEqualToString:@"Level"]){
        for (int i=0; i<tuitionarray.count; i++) {
            _tmptuitionrecord=[tuitionarray objectAtIndex:i];
            [_tmptuitionarray addObject:[[TuitionRecord alloc]initTuitionRecordwithSubject_Shortname:_tmptuitionrecord.subject_shortname Method:_tmptuitionrecord.method Scale:_tmptuitionrecord.scale TuitionFee:_tmptuitionrecord.tuitionfee newtuitionfee:_tmptuitionrecord.newtuitionfee effectivedate:_tmptuitionrecord.effectivedate]];
        }
    }else{
        for(int i=0;i<tmpgradearray.count;i++){
            [_tmptuitionarray addObject:[[TuitionRecord alloc]init]];
        }
        
        for (int i=0; i<tuitionarray.count; i++) {
            _tmptuitionrecord=[tuitionarray objectAtIndex:i];
            NSInteger index=[tmpgradearray indexOfObject:_tmptuitionrecord.scale];
            [_tmptuitionarray replaceObjectAtIndex:index withObject:[[TuitionRecord alloc]initTuitionRecordwithSubject_Shortname:_tmptuitionrecord.subject_shortname Method:_tmptuitionrecord.method Scale:_tmptuitionrecord.scale TuitionFee:_tmptuitionrecord.tuitionfee newtuitionfee:_tmptuitionrecord.newtuitionfee effectivedate:_tmptuitionrecord.effectivedate]];
        }
    }
    
    return _tmptuitionarray;
}

-(void) InitializeField
{
    workingSubject=[[SubjectRecord alloc]init];
    
    showStudentCapacityPicker=NO;
    showTuitionMethodPicker=NO;
//    showmakeup_quotaPicker=NO;

    //showCourseSchedule=NO;
    
    //tmpNoOfGrade=[NSString stringWithFormat:@"%lu",(unsigned long)tmpgradearray.count];
    
    if ([SubjectTableMode isEqualToString:@"View"]){
        showStudentCapacityPicker=NO;
        showTuitionMethodPicker=NO;

        
        showGradeTuition=[subjectobject.tuition_method isEqualToString:@"Grade"] ? YES:NO;
        
        workingSubject.subjectkey=subjectobject.subjectkey;
        workingSubject.subject_englishname=subjectobject.subject_englishname;
        workingSubject.subject_chinesename=subjectobject.subject_chinesename;
        workingSubject.subject_shortname=subjectobject.subject_shortname;
        workingSubject.subject_category=subjectobject.subject_category;
        workingSubject.status=subjectobject.status;
        workingSubject.studentcapacity=subjectobject.studentcapacity;
        workingSubject.standardnoofclassormonth=subjectobject.standardnoofclassormonth;
        workingSubject.enrollmentmode=subjectobject.enrollmentmode;
        workingSubject.classduration=subjectobject.classduration;
        workingSubject.classduration_assessment=subjectobject.classduration_assessment;
        workingSubject.classduration_trial=subjectobject.classduration_trial;
        workingSubject.tuition_method=subjectobject.tuition_method;
        workingSubject.tuition_mode=subjectobject.tuition_mode;
        //tmpNoOfLevel=[NSString stringWithFormat:@"%lu",(unsigned long)subjectobject.levelArray.count];
        workingSubject.levelArray=[self copylevelarraywithlevelarray:subjectobject.levelArray];
        workingSubject.tuitionArray=[self copytuitionarraywithtuitionarray:subjectobject.tuitionArray];//[[NSMutableArray alloc]initWithArray:subjectobject.tuitionArray];
        workingSubject.remarks=subjectobject.remarks;
        workingSubject.weeklyautorenewdefault=subjectobject.weeklyautorenewdefault;
        workingSubject.scheduleArray=[self copyDetailsScheduleArray];
        //tmpCourseSchedule=[self returndetailschedulearraycount];
        workingSubject.validity=subjectobject.validity;
        workingSubject.makeup_quota_unit=subjectobject.makeup_quota_unit;
        workingSubject.makeup_quota_value=subjectobject.makeup_quota_value;
        workingSubject.leaveday_by_makeupschedule=subjectobject.leaveday_by_makeupschedule;
        workingSubject.leaveday_by_classdate=subjectobject.leaveday_by_classdate;
        workingSubject.leaveday_follow_teacher=subjectobject.leaveday_follow_teacher;
        workingSubject.leaveday_by_enrolledschedule=subjectobject.leaveday_by_enrolledschedule;
        workingSubject.leaveday_by_staffschedule=subjectobject.leaveday_by_staffschedule;
        workingSubject.leaveday_follow_level=subjectobject.leaveday_follow_level;
        workingSubject.leaveday_follow_lesson=subjectobject.leaveday_follow_lesson;
        workingSubject.leaveday_follow_category=subjectobject.leaveday_follow_category;
        workingSubject.allowsameschedule=subjectobject.allowsameschedule;
        workingSubject.showmakeupbuttonifnotimeslot=subjectobject.showmakeupbuttonifnotimeslot;
        workingSubject.showabsentbuttononarrangeleave=subjectobject.showabsentbuttononarrangeleave;
        workingSubject.colorcode=subjectobject.colorcode;
        workingSubject.lessonnumberDict=[self copylessonnumberdict:subjectobject.lessonnumberDict];
        photocornerobject=[self copyMessagePhotoRecordWithSubject:subjectobject];
        workingSubject.subject_fulldescription=subjectobject.subject_fulldescription;
        workingSubject.subject_image=subjectobject.subject_image;
        workingSubject.publishinchatbot=subjectobject.publishinchatbot;
        workingSubject.chatbot_category=subjectobject.chatbot_category;
        workingSubject.chatbot_tag1=subjectobject.chatbot_tag1;
        workingSubject.trial_by_existinglesson=subjectobject.trial_by_existinglesson;
        workingSubject.trial_by_definedschedule=subjectobject.trial_by_definedschedule;
        workingSubject.trialcapacity=subjectobject.trialcapacity;
        workingSubject.chatbot_enabletrial=subjectobject.chatbot_enabletrial;
        workingSubject.pregenperiodcount=subjectobject.pregenperiodcount;
        workingSubject.autolevelupgrade=subjectobject.autolevelupgrade;
        
        [self createViewBarButton];
        
    }else if ([SubjectTableMode isEqualToString:@"Edit"]) {
        showStudentCapacityPicker=NO;
        showTuitionMethodPicker=NO;

        showDeleteButton=YES;
        
        showGradeTuition=[subjectobject.tuition_method isEqualToString:@"Grade"] ? YES:NO;
        workingSubject.subjectkey=subjectobject.subjectkey;
        workingSubject.subject_englishname=subjectobject.subject_englishname;
        workingSubject.subject_chinesename=subjectobject.subject_chinesename;
        workingSubject.subject_shortname=subjectobject.subject_shortname;
        workingSubject.subject_category=subjectobject.subject_category;
        workingSubject.status=subjectobject.status;
        workingSubject.studentcapacity=subjectobject.studentcapacity;
        workingSubject.standardnoofclassormonth=subjectobject.standardnoofclassormonth;
        workingSubject.enrollmentmode=subjectobject.enrollmentmode;
        workingSubject.classduration=subjectobject.classduration;
        workingSubject.classduration_assessment=subjectobject.classduration_assessment;
        workingSubject.classduration_trial=subjectobject.classduration_trial;
        workingSubject.tuition_method=subjectobject.tuition_method;
        workingSubject.tuition_mode=subjectobject.tuition_mode;
        //tmpNoOfLevel=[NSString stringWithFormat:@"%lu",(unsigned long)subjectobject.levelArray.count];
        workingSubject.levelArray=[self copylevelarraywithlevelarray:subjectobject.levelArray];
        workingSubject.tuitionArray=[self copytuitionarraywithtuitionarray:subjectobject.tuitionArray];//[[NSMutableArray alloc]initWithArray:subjectobject.tuitionArray];
        workingSubject.remarks=subjectobject.remarks;
        workingSubject.weeklyautorenewdefault=subjectobject.weeklyautorenewdefault;
        workingSubject.validity=subjectobject.validity;
        workingSubject.makeup_quota_unit=subjectobject.makeup_quota_unit;
        workingSubject.makeup_quota_value=subjectobject.makeup_quota_value;
        workingSubject.leaveday_by_makeupschedule=subjectobject.leaveday_by_makeupschedule;
        workingSubject.leaveday_by_classdate=subjectobject.leaveday_by_classdate;
        workingSubject.leaveday_follow_teacher=subjectobject.leaveday_follow_teacher;
        workingSubject.leaveday_by_enrolledschedule=subjectobject.leaveday_by_enrolledschedule;
        workingSubject.leaveday_by_staffschedule=subjectobject.leaveday_by_staffschedule;
        workingSubject.leaveday_follow_level=subjectobject.leaveday_follow_level;
        workingSubject.leaveday_follow_lesson=subjectobject.leaveday_follow_lesson;
        workingSubject.leaveday_follow_category=subjectobject.leaveday_follow_category;
        workingSubject.allowsameschedule=subjectobject.allowsameschedule;
        workingSubject.showmakeupbuttonifnotimeslot=subjectobject.showmakeupbuttonifnotimeslot;
        workingSubject.showabsentbuttononarrangeleave=subjectobject.showabsentbuttononarrangeleave;
        workingSubject.scheduleArray=[self copyDetailsScheduleArray];
        //tmpCourseSchedule=[self returndetailschedulearraycount];
        workingSubject.colorcode=subjectobject.colorcode;
        workingSubject.lessonnumberDict=[self copylessonnumberdict:subjectobject.lessonnumberDict];
        photocornerobject=[self copyMessagePhotoRecordWithSubject:subjectobject];
        workingSubject.subject_fulldescription=subjectobject.subject_fulldescription;
        workingSubject.subject_image=subjectobject.subject_image;
        workingSubject.publishinchatbot=subjectobject.publishinchatbot;
        workingSubject.chatbot_category=subjectobject.chatbot_category;
        workingSubject.chatbot_tag1=subjectobject.chatbot_tag1;
        workingSubject.trial_by_existinglesson=subjectobject.trial_by_existinglesson;
        workingSubject.trial_by_definedschedule=subjectobject.trial_by_definedschedule;
        workingSubject.trialcapacity=subjectobject.trialcapacity;
        workingSubject.chatbot_enabletrial=subjectobject.chatbot_enabletrial;
        workingSubject.pregenperiodcount=subjectobject.pregenperiodcount;
        workingSubject.autolevelupgrade=subjectobject.autolevelupgrade;
        [self createEditBarButton];
        
    }else if ([SubjectTableMode isEqualToString:@"Clone"]) {
        
        SubjectTableMode=@"Add";
        showStudentCapacityPicker=NO;
        showTuitionMethodPicker=NO;
        
        showDeleteButton=YES;
        
        showGradeTuition=[subjectobject.tuition_method isEqualToString:@"Grade"] ? YES:NO;
        workingSubject.subjectkey=@"";
        workingSubject.subject_englishname=subjectobject.subject_englishname;
        workingSubject.subject_chinesename=subjectobject.subject_chinesename;
        workingSubject.subject_shortname=@"";
        workingSubject.subject_category=subjectobject.subject_category;
        workingSubject.status=@"Active";
        workingSubject.studentcapacity=subjectobject.studentcapacity;
        workingSubject.standardnoofclassormonth=subjectobject.standardnoofclassormonth;
        workingSubject.enrollmentmode=subjectobject.enrollmentmode;
        workingSubject.classduration=subjectobject.classduration;
        workingSubject.classduration_assessment=subjectobject.classduration_assessment;
        workingSubject.classduration_trial=subjectobject.classduration_trial;
        workingSubject.tuition_method=subjectobject.tuition_method;
        workingSubject.tuition_mode=subjectobject.tuition_mode;
        //tmpNoOfLevel=[NSString stringWithFormat:@"%lu",(unsigned long)subjectobject.levelArray.count];
        workingSubject.levelArray=[self copylevelarraywithlevelarray:subjectobject.levelArray];
        workingSubject.tuitionArray=[self copytuitionarraywithtuitionarray:subjectobject.tuitionArray];//[[NSMutableArray alloc]initWithArray:subjectobject.tuitionArray];
        workingSubject.remarks=subjectobject.remarks;
        workingSubject.weeklyautorenewdefault=subjectobject.weeklyautorenewdefault;
        workingSubject.validity=subjectobject.validity;
        workingSubject.makeup_quota_unit=subjectobject.makeup_quota_unit;
        workingSubject.makeup_quota_value=subjectobject.makeup_quota_value;
        workingSubject.leaveday_by_makeupschedule=subjectobject.leaveday_by_makeupschedule;
        workingSubject.leaveday_by_classdate=subjectobject.leaveday_by_classdate;
        workingSubject.leaveday_follow_teacher=subjectobject.leaveday_follow_teacher;
        workingSubject.leaveday_by_enrolledschedule=subjectobject.leaveday_by_enrolledschedule;
        workingSubject.leaveday_by_staffschedule=subjectobject.leaveday_by_staffschedule;
        workingSubject.leaveday_follow_level=subjectobject.leaveday_follow_level;
        workingSubject.leaveday_follow_lesson=subjectobject.leaveday_follow_lesson;
        workingSubject.leaveday_follow_category=subjectobject.leaveday_follow_category;
        workingSubject.allowsameschedule=subjectobject.allowsameschedule;
        workingSubject.showmakeupbuttonifnotimeslot=subjectobject.showmakeupbuttonifnotimeslot;
        workingSubject.showabsentbuttononarrangeleave=subjectobject.showabsentbuttononarrangeleave;
        workingSubject.scheduleArray=[self cloneDetailsScheduleArray];
        //tmpCourseSchedule=[self returndetailschedulearraycount];
        workingSubject.colorcode=[MyClass returnFreeColorCodewithType:@"subject"];
        workingSubject.lessonnumberDict=[self copylessonnumberdict:subjectobject.lessonnumberDict];
        photocornerobject=[self copyMessagePhotoRecordWithSubject:subjectobject];
        workingSubject.subject_fulldescription=subjectobject.subject_fulldescription;
        workingSubject.subject_image=subjectobject.subject_image;
        workingSubject.publishinchatbot=subjectobject.publishinchatbot;
        workingSubject.chatbot_category=subjectobject.chatbot_category;
        workingSubject.chatbot_tag1=subjectobject.chatbot_tag1;
        workingSubject.trial_by_existinglesson=subjectobject.trial_by_existinglesson;
        workingSubject.trial_by_definedschedule=subjectobject.trial_by_definedschedule;
        workingSubject.trialcapacity=subjectobject.trialcapacity;
        workingSubject.chatbot_enabletrial=subjectobject.chatbot_enabletrial;
        workingSubject.pregenperiodcount=subjectobject.pregenperiodcount;
        workingSubject.autolevelupgrade=subjectobject.autolevelupgrade;
        [self createAddBarButton];
        subjectobject=nil;
        
    }else if ([SubjectTableMode isEqualToString:@"Add"]){
        showStudentCapacityPicker=NO;
        showTuitionMethodPicker=NO;
        showDeleteButton=NO;
        
        showGradeTuition=NO;
        workingSubject.subjectkey=@"";
        workingSubject.subject_englishname=@"";
        workingSubject.subject_chinesename=@"";
        workingSubject.subject_shortname=@"";
        workingSubject.subject_category=@"";
        workingSubject.status= @"Active";
        workingSubject.studentcapacity=@"";
        workingSubject.standardnoofclassormonth=@"";
        workingSubject.enrollmentmode=@"";
        workingSubject.classduration=@"";
        workingSubject.classduration_assessment=@"";
        workingSubject.classduration_trial=@"";
        workingSubject.tuition_method=@"Level";
        workingSubject.tuition_mode=@"Class";
        //tmpNoOfLevel=@"";
        workingSubject.levelArray=[[NSMutableArray alloc]init];
        workingSubject.tuitionArray=[[NSMutableArray alloc]init];
        workingSubject.remarks=@"";
        workingSubject.weeklyautorenewdefault=YES;
        workingSubject.validity=@"";
        workingSubject.makeup_quota_unit=@"";
        workingSubject.makeup_quota_value=@"-1";
        workingSubject.leaveday_by_makeupschedule=YES;
        workingSubject.leaveday_by_classdate=YES;
        workingSubject.leaveday_follow_teacher=YES;
        workingSubject.leaveday_by_enrolledschedule=NO;
        workingSubject.leaveday_by_staffschedule=NO;
        workingSubject.leaveday_follow_level=NO;
        workingSubject.leaveday_follow_lesson=NO;
        workingSubject.leaveday_follow_category=NO;
        workingSubject.allowsameschedule=YES;
        workingSubject.showmakeupbuttonifnotimeslot=YES;
        workingSubject.showabsentbuttononarrangeleave=NO;
        workingSubject.scheduleArray=[[NSMutableArray alloc]init];
        //tmpCourseSchedule=@"";
        workingSubject.colorcode=[MyClass returnFreeColorCodewithType:@"subject"];
        workingSubject.lessonnumberDict=[[NSMutableDictionary alloc]init];
        photocornerobject=nil;
        workingSubject.subject_fulldescription=@"";
        workingSubject.subject_image=@"";
        workingSubject.publishinchatbot=NO;
        workingSubject.chatbot_category=@"";
        workingSubject.chatbot_tag1=@"";
        workingSubject.trial_by_existinglesson=YES;
        workingSubject.trial_by_definedschedule=YES;
        workingSubject.trialcapacity=@"1";
        workingSubject.chatbot_enabletrial=YES;
        workingSubject.pregenperiodcount=0;
        workingSubject.autolevelupgrade=@"Disabled";
        [self createAddBarButton];
        
    }
    [self returnFilteredScheduleArray];
}

-(NSMutableArray *) copyDetailsScheduleArray
{
    NSMutableArray *DetailsScheduleArray=[[NSMutableArray alloc]init];
    for (int i=0; i<subjectobject.scheduleArray.count; i++) {
        [DetailsScheduleArray addObject:[[ScheduleRecord alloc]initScheduleRecordwithScheduleKey:((ScheduleRecord *)[subjectobject.scheduleArray objectAtIndex:i]).schedulekey Name:((ScheduleRecord *)[subjectobject.scheduleArray objectAtIndex:i]).name AutoRenew:((ScheduleRecord *)[subjectobject.scheduleArray objectAtIndex:i]).autorenew DayTimeArray:[self copyScheduleTimeArrayWithScheduleRecord:[subjectobject.scheduleArray objectAtIndex:i]] Action:((ScheduleRecord *)[subjectobject.scheduleArray objectAtIndex:i]).action StartDate:((ScheduleRecord *)[subjectobject.scheduleArray objectAtIndex:i]).startdate EndDate:((ScheduleRecord *)[subjectobject.scheduleArray objectAtIndex:i]).enddate makeupschedule:((ScheduleRecord *)[subjectobject.scheduleArray objectAtIndex:i]).makeupschedule active:((ScheduleRecord *)[subjectobject.scheduleArray objectAtIndex:i]).active type:((ScheduleRecord *)[subjectobject.scheduleArray objectAtIndex:i]).type showintimetableifnoenrollment:((ScheduleRecord *)[subjectobject.scheduleArray objectAtIndex:i]).showintimetableifnoenrollment onlinetrialschedule:((ScheduleRecord *)[subjectobject.scheduleArray objectAtIndex:i]).onlinetrialschedule levelarray:[self copyScheduleLevelArrayWithScheduleRecord:[subjectobject.scheduleArray objectAtIndex:i]]]];
        
    }
    return DetailsScheduleArray;
}

-(NSMutableArray *) copylevelarraywithlevelarray:(NSMutableArray *)levelarray
{
    NSMutableArray *_tmplevelarray=[[NSMutableArray alloc]init];;
    LevelRecord *_tmplevelrecord;
    
    for (int i=0; i<levelarray.count; i++) {
        _tmplevelrecord=[levelarray objectAtIndex:i];
        [_tmplevelarray addObject:[[LevelRecord alloc]initLevelRecordwithLevel:_tmplevelrecord.level earlieststartdate:_tmplevelrecord.earlieststartdate]];
    }
    return _tmplevelarray;
}

-(NSMutableArray *) cloneDetailsScheduleArray
{
    ScheduleRecord *obj;
    NSMutableArray *DetailsScheduleArray=[[NSMutableArray alloc]init];
    for (int i=0; i<subjectobject.scheduleArray.count; i++) {
        obj=[subjectobject.scheduleArray objectAtIndex:i];
        if ([obj.schedulekey isEqualToString:@"-2"] && [obj.schedulekey isEqualToString:@"-1"]) {
            [DetailsScheduleArray addObject:[[ScheduleRecord alloc]initScheduleRecordwithScheduleKey:obj.schedulekey Name:obj.name AutoRenew:obj.autorenew DayTimeArray:[self copyScheduleTimeArrayWithScheduleRecord:obj] Action:@"Add" StartDate:obj.startdate EndDate:obj.enddate makeupschedule:obj.makeupschedule active:obj.active type:obj.type showintimetableifnoenrollment:obj.showintimetableifnoenrollment onlinetrialschedule:obj.onlinetrialschedule levelarray:[self copyScheduleLevelArrayWithScheduleRecord:obj]]];
        }
    }
    return DetailsScheduleArray;
}

-(NSMutableArray *)copyScheduleLevelArrayWithScheduleRecord:(ScheduleRecord *)scheduleobject
{
    if(!scheduleobject.levelarray){
        return nil;
    }
    
    NSMutableArray *result=[[NSMutableArray alloc]init];
    for (int i=0; i<scheduleobject.levelarray.count; i++) {
        [result addObject:scheduleobject.levelarray[i]];
    }
    return result;
}

-(NSMutableDictionary *) copylessonnumberdict:(NSMutableDictionary *)lessonnumberdict
{
    NSMutableDictionary *tmplessonnumberdict=[[NSMutableDictionary alloc]init];;

    for (id noteset in lessonnumberdict){
        NSMutableArray *notesetarray = lessonnumberdict[noteset];
        NSMutableArray *tmpnotesetarray=[[NSMutableArray alloc]init];
        for (int i=0; i<notesetarray.count; i++) {
            [tmpnotesetarray addObject:[notesetarray objectAtIndex:i]];
        }
        [tmplessonnumberdict setValue:tmpnotesetarray forKey:noteset];
    }

    return tmplessonnumberdict;
}

-(BOOL) lessonnumberdictdidchanged
{
    if (subjectobject.lessonnumberDict.count!=workingSubject.lessonnumberDict.count) {
        return TRUE;
    }else{
        for (id noteset in workingSubject.lessonnumberDict){
            NSMutableArray *originallessonarray=subjectobject.lessonnumberDict[noteset];
            NSMutableArray *newlessonarray=workingSubject.lessonnumberDict[noteset];
            if (!originallessonarray) {
                return TRUE;
            }else{
                if (originallessonarray.count!=newlessonarray.count) {
                    return TRUE;
                }else{
                    for (int i=0; i<originallessonarray.count; i++) {
                        if (originallessonarray[i]!=newlessonarray[i]) {
                            return TRUE;
                        }
                    }
                }
            }
        }
    }
    return FALSE;
}


-(void) adjusttablesize
{
    float tableheight;
    float tablewidth;
    
    tableheight=maxPopupHeight-keyboardheight;
    
    if (showCourseSchedule) {
        if (showcsInstructorTable) {
            tablewidth=popoverwidth+courseschedulewidth+instructortablewidth;
            CourseScheduleToolBar.frame=CGRectMake(0, 20, courseschedulewidth+instructortablewidth, 44);
        }else if (showcsClassroomTable){
            tablewidth=popoverwidth+courseschedulewidth+classroomtablewidth;
            CourseScheduleToolBar.frame=CGRectMake(0, 20, courseschedulewidth+classroomtablewidth, 44);
        }else if (showcsClassDateTable){
            tablewidth=popoverwidth+courseschedulewidth+classdatetablewidth;
            CourseScheduleToolBar.frame=CGRectMake(0, 20, courseschedulewidth+classdatetablewidth, 44);
        }else if (showcsDayDateTimeTable){
            tablewidth=popoverwidth+courseschedulewidth+classdatetablewidth;
            CourseScheduleToolBar.frame=CGRectMake(0, 20, courseschedulewidth+classdatetablewidth, 44);
        }else if (showScheduleLevelTable){
            tablewidth=popoverwidth+courseschedulewidth+scheduleleveltablewidth;
            CourseScheduleToolBar.frame=CGRectMake(0, 20, courseschedulewidth+scheduleleveltablewidth, 44);
        }else{
            tablewidth=popoverwidth+courseschedulewidth;
            CourseScheduleToolBar.frame=CGRectMake(0, 20, courseschedulewidth, 44);
        }
    }else if (showLevelTuitionTable){
        if(showLevelEffectiveTable){
            tablewidth=popoverwidth+(globalvariables.centerrecord.jumptonextlevelduringrenewal?leveltuitiontablelongwidth:leveltuitiontablewidth)+classdatetablewidth;
        }else{
            tablewidth=popoverwidth+(globalvariables.centerrecord.jumptonextlevelduringrenewal?leveltuitiontablelongwidth:leveltuitiontablewidth);
        }
        leveltablewidthconstraint.constant=globalvariables.centerrecord.jumptonextlevelduringrenewal?leveltuitiontablelongwidth:leveltuitiontablewidth;
    }else if (showGradeTuitionTable){
        if(showGradeEffectiveTable){
            tablewidth=popoverwidth+gradetuitiontablewidth+classdatetablewidth;
        }else{
            tablewidth=popoverwidth+gradetuitiontablewidth;
        }
    }else if (showSubjectCategoryTable){
        tablewidth=popoverwidth+subjectcategorytablewidth;
    }else if (showValidity){
        tablewidth=popoverwidth+validitywidth;
    }else if (showMakeupTable){
        tablewidth=popoverwidth+makeupwidth;
    }else if (showColorCode){
        tablewidth=popoverwidth+makeupwidth;
    }else if (showLessonNumberTable){
        tablewidth=popoverwidth+lessonnumbertablewidth;
    }else if (showChatBotSettingsTable){
        if(showSubjectPhoto){
            tablewidth=popoverwidth+chatbotsettingswidth+subjectphotowidth;
        }else if(showChatBotCategoryTable){
            tablewidth=popoverwidth+chatbotsettingswidth+chatbotcategorytablewidth;
        }else{
            tablewidth=popoverwidth+chatbotsettingswidth;
        }
    }else if (showAutoLevelUpgradeOption){
        tablewidth=popoverwidth+autolevelupgradeoptiontablewidth+(showAutoLevelUpgradeValues?autolevelupgradevaluestablewdith:0);
    }else{
        tablewidth=popoverwidth;
    }
    

    [SubjectPopoverTable setFrame:CGRectMake(0, 44+20, popoverwidth, tableheight-44-20)];
    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    
    self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
    chatBotSettingsTableBottomConstraint.constant=keyboardheight;
    
    leveltuitionmasterviewbottomcontrainst.constant=keyboardheight;
    gradetuitionmasterviewbottomcontrainst.constant=keyboardheight;
    schedulelevelmasterviewbottomconstraint.constant=keyboardheight;
    
    if (showCourseSchedule) {
        if ([CourseTableMode isEqualToString:@"View"]) {
            [CourseScheduleTable setFrame:CGRectMake(0, 44+20+88, courseschedulewidth, tableheight-44-20-88)];
        }else{
            [CourseScheduleTable setFrame:CGRectMake(0, 44+20, courseschedulewidth, tableheight-44-20)];
        }
        
        CourseScheduleMasterView.hidden=NO;
        LevelTuitionMasterView.hidden=YES;
        GradeTuitionMasterView.hidden=YES;
        SubjectCategoryMasterView.hidden=YES;
        ValidityTableMasterView.hidden=YES;
        MakeupTableMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=YES;
        lessonNumberTableMasterView.hidden=YES;
        chatBotSettingsMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        AutoLevelUpgradeMasterView.hidden=YES;
        
        
        csInstructorTableMasterView.hidden=!showcsInstructorTable;
        csClassroomTableMasterView.hidden=!showcsClassroomTable;
        csClassDateTableMasterView.hidden=!showcsClassDateTable;
        csDayDateTimeTableMasterView.hidden=!showcsDayDateTimeTable;
        ScheduleLevelMasterView.hidden=!showScheduleLevelTable;
        
        if (showcsInstructorTable && filteredcsInstructorArray.count>0) {
            presetRow=[MyClass returnInstructorIndexWithInstructorArray:filteredcsInstructorArray username:workingScheduleDetails.instructor activeinstructor:YES defaultzeroifnotfound:YES];
            [csInstructorTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }

    }else if (showLevelTuitionTable){
//        [LevelTuitionTable setFrame:CGRectMake(0, 44+20, leveltuitiontablewidth, tableheight-44-20)];
        CourseScheduleMasterView.hidden=YES;
        LevelTuitionMasterView.hidden=NO;
        GradeTuitionMasterView.hidden=YES;
        SubjectCategoryMasterView.hidden=YES;
        ValidityTableMasterView.hidden=YES;
        MakeupTableMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=YES;
        lessonNumberTableMasterView.hidden=YES;
        chatBotSettingsMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        ScheduleLevelMasterView.hidden=YES;
        AutoLevelUpgradeMasterView.hidden=YES;
    }else if (showGradeTuitionTable){
//        [GradeTuitionTable setFrame:CGRectMake(0, 44+20, gradetuitiontablewidth, tableheight-44-20)];
        CourseScheduleMasterView.hidden=YES;
        LevelTuitionMasterView.hidden=YES;
        GradeTuitionMasterView.hidden=NO;
        SubjectCategoryMasterView.hidden=YES;
        ValidityTableMasterView.hidden=YES;
        MakeupTableMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=YES;
        lessonNumberTableMasterView.hidden=YES;
        chatBotSettingsMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        ScheduleLevelMasterView.hidden=YES;
        AutoLevelUpgradeMasterView.hidden=YES;
    }else if (showSubjectCategoryTable){
        [SubjectCategoryMasterView setFrame:CGRectMake(popoverwidth, 0, chatbotcategorytablewidth, self.view.frame.size.height)];
        [SubjectCategoryTable setFrame:CGRectMake(0, 44+84+20, subjectcategorytablewidth, tableheight-44-84-20)];
        CourseScheduleMasterView.hidden=YES;
        LevelTuitionMasterView.hidden=YES;
        GradeTuitionMasterView.hidden=YES;
        SubjectCategoryMasterView.hidden=NO;
        ValidityTableMasterView.hidden=YES;
        MakeupTableMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=YES;
        lessonNumberTableMasterView.hidden=YES;
        chatBotSettingsMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        ScheduleLevelMasterView.hidden=YES;
        AutoLevelUpgradeMasterView.hidden=YES;
    }else if (showValidity){
        //[GradeTuitionTable setFrame:CGRectMake(0, 44, subjectcategorytablewidth, self.view.frame.size.height-44)];
        CourseScheduleMasterView.hidden=YES;
        LevelTuitionMasterView.hidden=YES;
        GradeTuitionMasterView.hidden=YES;
        SubjectCategoryMasterView.hidden=YES;
        ValidityTableMasterView.hidden=NO;
        MakeupTableMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=YES;
        lessonNumberTableMasterView.hidden=YES;
        chatBotSettingsMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        ScheduleLevelMasterView.hidden=YES;
        AutoLevelUpgradeMasterView.hidden=YES;
    }else if (showMakeupTable){
        //[GradeTuitionTable setFrame:CGRectMake(0, 44, subjectcategorytablewidth, self.view.frame.size.height-44)];
        CourseScheduleMasterView.hidden=YES;
        LevelTuitionMasterView.hidden=YES;
        GradeTuitionMasterView.hidden=YES;
        SubjectCategoryMasterView.hidden=YES;
        ValidityTableMasterView.hidden=YES;
        MakeupTableMasterView.hidden=NO;
        ColorCodeTableMasterView.hidden=YES;
        lessonNumberTableMasterView.hidden=YES;
        chatBotSettingsMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        ScheduleLevelMasterView.hidden=YES;
        AutoLevelUpgradeMasterView.hidden=YES;
    }else if (showColorCode){
        //[GradeTuitionTable setFrame:CGRectMake(0, 44, subjectcategorytablewidth, self.view.frame.size.height-44)];
        CourseScheduleMasterView.hidden=YES;
        LevelTuitionMasterView.hidden=YES;
        GradeTuitionMasterView.hidden=YES;
        SubjectCategoryMasterView.hidden=YES;
        ValidityTableMasterView.hidden=YES;
        MakeupTableMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=NO;
        lessonNumberTableMasterView.hidden=YES;
        chatBotSettingsMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        ScheduleLevelMasterView.hidden=YES;
        AutoLevelUpgradeMasterView.hidden=YES;
    }else if (showLessonNumberTable){
        lessonNumberTableBottomConstraint.constant=keyboardheight;
        CourseScheduleMasterView.hidden=YES;
        LevelTuitionMasterView.hidden=YES;
        GradeTuitionMasterView.hidden=YES;
        SubjectCategoryMasterView.hidden=YES;
        ValidityTableMasterView.hidden=YES;
        MakeupTableMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=YES;
        lessonNumberTableMasterView.hidden=NO;
        chatBotSettingsMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        ScheduleLevelMasterView.hidden=YES;
        AutoLevelUpgradeMasterView.hidden=YES;
    }else if (showChatBotSettingsTable){
        CourseScheduleMasterView.hidden=YES;
        LevelTuitionMasterView.hidden=YES;
        GradeTuitionMasterView.hidden=YES;
        SubjectCategoryMasterView.hidden=!showChatBotCategoryTable;
        ValidityTableMasterView.hidden=YES;
        MakeupTableMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=YES;
        lessonNumberTableMasterView.hidden=YES;
        chatBotSettingsMasterView.hidden=NO;
        MessagePhotoMasterView.hidden=!showSubjectPhoto;
        ScheduleLevelMasterView.hidden=YES;
        AutoLevelUpgradeMasterView.hidden=YES;
        if(showChatBotCategoryTable){
            [SubjectCategoryMasterView setFrame:CGRectMake(popoverwidth+chatbotsettingswidth, 0, chatbotcategorytablewidth, self.view.frame.size.height)];
            [SubjectCategoryTable setFrame:CGRectMake(0, 44+84+20, subjectcategorytablewidth, tableheight-44-84-20)];
        }
    }else if (showAutoLevelUpgradeOption){
        CourseScheduleMasterView.hidden=YES;
        LevelTuitionMasterView.hidden=YES;
        GradeTuitionMasterView.hidden=YES;
        SubjectCategoryMasterView.hidden=YES;
        ValidityTableMasterView.hidden=YES;
        MakeupTableMasterView.hidden=YES;
        ColorCodeTableMasterView.hidden=YES;
        lessonNumberTableMasterView.hidden=YES;
        chatBotSettingsMasterView.hidden=YES;
        MessagePhotoMasterView.hidden=YES;
        ScheduleLevelMasterView.hidden=YES;
        AutoLevelUpgradeMasterView.hidden=NO;
    }
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    if ([windowname isEqualToString:@"showCourseSchedule"]) {
        showCourseSchedule=YES;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
    }else if ([windowname isEqualToString:@"showLevelTuition"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=YES;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
    }else if ([windowname isEqualToString:@"showGradeTuition"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=YES;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
    }else if ([windowname isEqualToString:@"showSubjectCategory"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=YES;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
        [self createSubjectCategoryTableToolBar];
    }else if ([windowname isEqualToString:@"showValidity"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=YES;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
    }else if ([windowname isEqualToString:@"showMakeup"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=YES;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
    }else if ([windowname isEqualToString:@"showColorCode"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=YES;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
    }else if ([windowname isEqualToString:@"showcsInstructor"]) {
        showCourseSchedule=YES;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=YES;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        selecteddaytimebutton=nil;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
    }else if ([windowname isEqualToString:@"showcsClassroom"]) {
        showCourseSchedule=YES;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=YES;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        selecteddaytimebutton=nil;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
    }else if ([windowname isEqualToString:@"showcsClassDate"]) {
        showCourseSchedule=YES;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=YES;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        selecteddaytimebutton=nil;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
    }else if ([windowname isEqualToString:@"showcsDayDateTime"]) {
        showCourseSchedule=YES;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=YES;
        showMakeupTable=NO;
        showColorCode=NO;
        selecteddaytimebutton=nil;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
    }else if ([windowname isEqualToString:@"showLessonNumberTable"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=YES;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
    }else if ([windowname isEqualToString:@"showChatBotSettingsTable"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=YES;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
    }else if ([windowname isEqualToString:@"showSubjectPhoto"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=YES;
        showSubjectPhoto=YES;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
        [self createMessagePhotoToolBar];
    }else if ([windowname isEqualToString:@"showChatBotCategory"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=YES;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=YES;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
        [self createSubjectCategoryTableToolBar];
    }else if ([windowname isEqualToString:@"showAutoLevelUpgradeOptionTable"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=YES;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=YES;
        showAutoLevelUpgradeValues=NO;
    }else if ([windowname isEqualToString:@"showAutoLevelUpgradeValuesTable"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=YES;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=YES;
        showAutoLevelUpgradeValues=YES;
    }else if ([windowname isEqualToString:@"showLevelEffectiveTable"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=YES;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=YES;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
        [self createSubjectCategoryTableToolBar];
    }else if ([windowname isEqualToString:@"showGradeEffectiveTable"]) {
        showCourseSchedule=NO;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=YES;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=YES;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
        [self createSubjectCategoryTableToolBar];
    }else if ([windowname isEqualToString:@"showScheduleLevelTable"]) {
        showCourseSchedule=YES;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=YES;
//        [self createSubjectCategoryTableToolBar];
    }else{
        showCourseSchedule=NO;
        showLevelTuitionTable=NO;
        showGradeTuitionTable=NO;
        showSubjectCategoryTable=NO;
        showValidity=NO;
        showcsInstructorTable=NO;
        showcsClassroomTable=NO;
        showcsClassDateTable=NO;
        showcsDayDateTimeTable=NO;
        showMakeupTable=NO;
        showColorCode=NO;
        selecteddaytimebutton=nil;
        showLessonNumberTable=NO;
        showChatBotSettingsTable=NO;
        showSubjectPhoto=NO;
        showChatBotCategoryTable=NO;
        showLevelEffectiveTable=NO;
        showGradeEffectiveTable=NO;
        showScheduleLevelTable=NO;
        showAutoLevelUpgradeOption=NO;
        showAutoLevelUpgradeValues=NO;
    }
}


-(void) deleteSubject:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Subject"] message:[NSString stringWithFormat:@"%@ %@?",[MyClass returntitlewithtitle:@"Are you sure to delete"],subjectobject.subject_englishname] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if ([self retrieveEnrollmentCountWithSubjectShortname:workingSubject.subject_shortname]) {
            if (subjectCanBeDeleted) {
                [self deleteSubjectwithSubjectkey:subjectobject.subjectkey];
            }else{
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Subject cannot be deleted"] message:[MyClass returntitlewithtitle:@"There are enrollment records for this subject"] preferredStyle:UIAlertControllerStyleAlert];
                
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


-(void)deleteSubjectwithSubjectkey:(NSString *)subjectkey
{
    //delete staff record in center db
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletesubject&subjectkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,subjectkey];
    
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
        
        NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",strResult);
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    [self.delegate dismissSubjectPopover];
    
}

-(IBAction) doneButtonPressed:(id)sender
{
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }
    
    workingSubject.subject_shortname=[MyClass leadingtrailingspacestrimmed:workingSubject.subject_shortname];
    workingSubject.subject_englishname=[MyClass leadingtrailingspacestrimmed:workingSubject.subject_englishname];
    workingSubject.subject_chinesename=[MyClass leadingtrailingspacestrimmed:workingSubject.subject_chinesename];
    
    [SubjectPopoverTable reloadData];
    
    //[self storeTmpField];
    
    if ([workingSubject.subject_englishname isEqualToString:@""] && [workingSubject.subject_chinesename isEqualToString:@""]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",[MyClass returntitlewithtitle:@"Subject Information"]] message:[MyClass returntitlewithtitle:@"Please input subject's english or chinese name"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if (![self shortnamelengthok:workingSubject.subject_shortname]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",[MyClass returntitlewithtitle:@"Subject Information"]] message:[MyClass returntitlewithtitle:@"Subject code length too long. Please select another one"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([workingSubject.subject_shortname isEqualToString:@""]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",[MyClass returntitlewithtitle:@"Subject Information"]] message:[MyClass returntitlewithtitle:@"Please input subject code"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([self isCodeBeingUsed:workingSubject.subject_shortname]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",[MyClass returntitlewithtitle:@"Subject Information"]] message:[MyClass returntitlewithtitle:@"Subject code has been used. Please select another one"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([StandandPeriodLabel.text isEqualToString:@""]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",[MyClass returntitlewithtitle:@"Subject Information"]] message:[MyClass returntitlewithtitle:@"Please select standard period"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([workingSubject.classduration isEqualToString:@""]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",[MyClass returntitlewithtitle:@"Subject Information"]] message:[MyClass returntitlewithtitle:@"Please select regular class duration"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([workingSubject.tuition_mode isEqualToString:@""]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",[MyClass returntitlewithtitle:@"Subject Information"]] message:[MyClass returntitlewithtitle:@"Please select Tuition By"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if (workingSubject.levelArray.count==0){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",[MyClass returntitlewithtitle:@"Subject Information"]] message:[MyClass returntitlewithtitle:@"Please input subject level"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([self emptyLevelInformationWithLevelArray:workingSubject.levelArray]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",[MyClass returntitlewithtitle:@"Subject Information"]] message:[MyClass returntitlewithtitle:@"Please input at least one level's name"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if (workingSubject.tuitionArray.count==0){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",[MyClass returntitlewithtitle:@"Subject Information"]] message:[MyClass returntitlewithtitle:@"Please input subject tuition fee"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([self invalidtuitionfee]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@",[MyClass returntitlewithtitle:@"Subject Information"]] message:[MyClass returntitlewithtitle:@"Invalid subject tuition fee input"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    
    }else{
        if ([workingSubject.subject_englishname isEqualToString:@""]) {
            workingSubject.subject_englishname=workingSubject.subject_chinesename;
        }else if ([workingSubject.subject_chinesename isEqualToString:@""]){
            workingSubject.subject_chinesename=workingSubject.subject_englishname;
        }
        
        if ([workingSubject.classduration_assessment isEqualToString:@""]) {
            workingSubject.classduration_assessment=workingSubject.classduration;
        }

        if ([workingSubject.classduration_trial isEqualToString:@""]) {
            workingSubject.classduration_trial=workingSubject.classduration;
        }
        
        if ([SubjectTableMode isEqualToString:@"Edit"]) {
            
            
            if([self updateSubjectWithSubjectRecord:workingSubject Action:@"Edit"]){
                //change subject code in local table
                if (![workingSubject.subject_shortname isEqualToString:subjectobject.subject_shortname]) {
                    //[self openDB];
                    
                    NSString *sql;
                    
                    sql=[NSString stringWithFormat:@"UPDATE tabview SET subjectlist=replace(subjectlist,'%@','%@') where centerkey=%@",subjectobject.subject_shortname,workingSubject.subject_shortname,globalvariables.centerrecord.centerkey];
                    sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,NULL);
                }
                
                
                [self.delegate dismissSubjectPopover];
                
                UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Subject"] message:[MyClass returntitlewithtitle:@"Subject information is successfully updated"] preferredStyle:UIAlertControllerStyleAlert];
                
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
            
            if([self updateSubjectWithSubjectRecord:workingSubject Action:@"Add"]){
                
                [self.delegate dismissSubjectPopover];
                UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Subject"] message:[MyClass returntitlewithtitle:@"Subject is successfully added"] preferredStyle:UIAlertControllerStyleAlert];
                
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


-(void) validateinput:(UITextView *)sender
{
    if (![self checkvalidfeeinput:sender.text]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Tuition Fee"] message:[MyClass returntitlewithtitle:@"Invalid input. Please re-enter"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
        
        sender.text=@"0";
        sender.textColor=[UIColor redColor];
    }else{
        if ([sender.text intValue] !=[sender.text doubleValue]) {
            sender.text=[NSString stringWithFormat:@"%.8f",[sender.text doubleValue]];
            for (int i=0; i<[sender.text length]; i++) {
                if ([sender.text hasSuffix:@"0"]) {
                    sender.text=[sender.text substringToIndex:[sender.text length]-1];
                }else{
                    break;
                }
            }
        }
        sender.textColor=[UIColor darkGrayColor];
        if (sender.tag>=4000) {
            ((TuitionRecord *)[workingSubject.tuitionArray objectAtIndex:sender.tag-4000]).tuitionfee=sender.text;
        }else{
            ((TuitionRecord *)[workingSubject.tuitionArray objectAtIndex:sender.tag-2000]).tuitionfee=sender.text;
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

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (keyboardheight>0) {
        if(textView.tag==100){
            CGPoint point = [textView.superview convertPoint:CGPointZero toView:chatBotSettingsTable];
            NSIndexPath *indexpath =[chatBotSettingsTable indexPathForRowAtPoint:point];
            
            CGRect rectInTableView = [chatBotSettingsTable rectForRowAtIndexPath:indexpath];
            
            [chatBotSettingsTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-chatBotSettingsTable.frame.size.height) animated:YES];
        }else{
            CGPoint point = [textView.superview convertPoint:CGPointZero toView:SubjectPopoverTable];
            NSIndexPath *indexpath =[SubjectPopoverTable indexPathForRowAtPoint:point];
            
            CGRect rectInTableView = [SubjectPopoverTable rectForRowAtIndexPath:indexpath];
            
            [SubjectPopoverTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-SubjectPopoverTable.frame.size.height) animated:YES];
        }
    }
}

-(BOOL) invalidtuitionfee
{
    BOOL result;
    result=FALSE;
    
    for (int i=0; i<workingSubject.tuitionArray.count; i++) {
        tuitionobject=[workingSubject.tuitionArray objectAtIndex:i];
        if (![self checkvalidfeeinput:tuitionobject.tuitionfee]) {
            result=TRUE;
            break;
        }
    }
    return result;
}

-(BOOL) isCodeBeingUsed:(NSString *)newshortname
{
    SubjectRecord *subjectrecord=[[SubjectRecord alloc]init];
    for (int i=0; i<SubjectRecordArray.count; i++) {
        subjectrecord=[SubjectRecordArray objectAtIndex:i];
        if ([subjectrecord.subject_shortname caseInsensitiveCompare:newshortname]==NSOrderedSame && ![subjectrecord.subjectkey isEqualToString:subjectobject.subjectkey]) {
            return TRUE;
        }
    }
    return FALSE;
}

-(BOOL) shortnamelengthok:(NSString *)newshortname
{
    return [newshortname length]<=8 ? TRUE:FALSE;
}

-(void) updatetextfield:(UITextField *)textfield
{
    if (textfield==Subject_EnglishnameText) {
        workingSubject.subject_englishname=textfield.text;
    }else if (textfield==Subject_ChinesenameText) {
        workingSubject.subject_chinesename=textfield.text;
    }else if (textfield==Subject_ShortnameText) {
        workingSubject.subject_shortname=textfield.text;
    }else if(textfield==ScheduleNameText){
        workingSchedule.name=textfield.text;
    }else if(textfield==Subject_MakeupQuotaValueText){
        if ([workingSubject.makeup_quota_unit isEqualToString:@"P"]) {
            if(![MyClass checkValidInput:textfield.text Type:@"Float"]){
                textfield.text=workingSubject.makeup_quota_value;
            }else{
                workingSubject.makeup_quota_value=textfield.text;
            }
        }else{
            if(![MyClass checkValidInput:textfield.text Type:@"ZeroInteger"]){
                textfield.text=workingSubject.makeup_quota_value;
            }else{
                workingSubject.makeup_quota_value=textfield.text;
            }
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==RemarksText) {
        workingSubject.remarks=textView.text;
    }else if (textView.tag==100){
        CGPoint rootViewPoint = [textView.superview convertPoint:CGPointZero toView:chatBotSettingsTable];
        NSIndexPath *indexPath = [chatBotSettingsTable indexPathForRowAtPoint:rootViewPoint];
        
        MyTableViewCell *newcell=[chatBotSettingsTable cellForRowAtIndexPath:indexPath];
        
        CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
        if (size.height>200) {
            newcell.layoutconstraint1.constant=200;
            textView.scrollEnabled=YES;
        }else{
            newcell.layoutconstraint1.constant=size.height;
            textView.scrollEnabled=NO;
        }
        
        if(indexPath.section==2){
            workingSubject.subject_fulldescription=textView.text;
        }else{
            workingSubject.chatbot_tag1=textView.text;
        }
        
        [chatBotSettingsTable beginUpdates];
        [chatBotSettingsTable endUpdates];
    }else{
        CGPoint rootViewPoint = [textView.superview convertPoint:CGPointZero toView:lessonNumberTable];
        NSIndexPath *indexPath = [lessonNumberTable indexPathForRowAtPoint:rootViewPoint];
        
        MyTableViewCell *newcell=[lessonNumberTable cellForRowAtIndexPath:indexPath];
        
        CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
        if (size.height>200) {
            newcell.layoutconstraint1.constant=200;
            textView.scrollEnabled=YES;
        }else{
            newcell.layoutconstraint1.constant=size.height;
            textView.scrollEnabled=NO;
        }
        
        NSMutableArray *lessonarray= workingSubject.lessonnumberDict[lessonnumbertype];
        [lessonarray replaceObjectAtIndex:indexPath.row withObject:textView.text];
        
        [lessonNumberTable beginUpdates];
        [lessonNumberTable endUpdates];
    }
}


-(void) selectStatus:(UISegmentedControl *)sender
{
    workingSubject.status=sender.selectedSegmentIndex==0?@"Active":@"Inactive";
}

-(void) selectMakeupQuotaType:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex==0) {
        workingSubject.makeup_quota_unit=@"";
        workingSubject.makeup_quota_value=@"-1";
    }else if (sender.selectedSegmentIndex==1){
        workingSubject.makeup_quota_unit=@"P";
        if ([workingSubject.makeup_quota_value isEqualToString:@"-1"]) {
            workingSubject.makeup_quota_value=@"0";
        }
    }else{
        workingSubject.makeup_quota_unit=@"F";
        if ([workingSubject.makeup_quota_value isEqualToString:@"-1"]) {
            workingSubject.makeup_quota_value=@"0";
        }else{
            workingSubject.makeup_quota_value=[@([workingSubject.makeup_quota_value integerValue]) stringValue];
        }
    }
    [MakeupTable reloadData];
}


-(BOOL) updateSubjectWithSubjectRecord:(SubjectRecord *)subjectrecord Action:(NSString *)action
{
    TuitionRecord *tuitionObject=[[TuitionRecord alloc]init];
    
    //generate json subject array
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
//    NSArray *jsonsubjectarray=[[NSArray alloc]init];
    NSArray *jsonlevelarray=[[NSArray alloc]init];
    NSArray *jsontuitionarray=[[NSArray alloc]init];
    NSArray *jsonlessonnumberarray=[[NSArray alloc]init];
    NSMutableArray *jsonschedulearray=[[NSMutableArray alloc]init];
    ScheduleRecord *schedulerecordobject=[[ScheduleRecord alloc]init];

    NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
    
    [dictionary setValue:@"updatesubject" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"subject_englishname" NewValue:subjectrecord.subject_englishname OldValue:subjectobject.subject_englishname Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"subject_chinesename" NewValue:subjectrecord.subject_chinesename OldValue:subjectobject.subject_chinesename Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"subject_shortname" NewValue:subjectrecord.subject_shortname OldValue:subjectobject.subject_shortname Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"subject_category" NewValue:subjectrecord.subject_category OldValue:subjectobject.subject_category Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"tuition_method" NewValue:subjectrecord.tuition_method OldValue:subjectobject.tuition_method Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"tuition_mode" NewValue:subjectrecord.tuition_mode OldValue:subjectobject.tuition_mode Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"studentcapacity" NewValue:subjectrecord.studentcapacity OldValue:subjectobject.studentcapacity Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"enrollmentmode" NewValue:subjectrecord.enrollmentmode OldValue:subjectobject.enrollmentmode Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"standardnoofclassormonth" NewValue:subjectrecord.standardnoofclassormonth OldValue:subjectobject.standardnoofclassormonth Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"classduration" NewValue:subjectrecord.classduration OldValue:subjectobject.classduration Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"classduration_assessment" NewValue:subjectrecord.classduration_assessment OldValue:subjectobject.classduration_assessment Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"classduration_trial" NewValue:subjectrecord.classduration_trial OldValue:subjectobject.classduration_trial Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"remarks" NewValue:subjectrecord.remarks OldValue:subjectobject.remarks Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"status" NewValue:subjectrecord.status OldValue:subjectobject.status Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"weeklyautorenewdefault" NewValue:subjectrecord.weeklyautorenewdefault?@"Yes":@"No" OldValue:subjectobject.weeklyautorenewdefault?@"Yes":@"No" Action:action];

    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"validity" NewValue:subjectrecord.validity OldValue:subjectobject.validity Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"makeup_quota_unit" NewValue:subjectrecord.makeup_quota_unit OldValue:subjectobject.makeup_quota_unit Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"makeup_quota_value" NewValue:subjectrecord.makeup_quota_value OldValue:subjectobject.makeup_quota_value Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"leaveday_by_makeupschedule" NewValue:subjectrecord.leaveday_by_makeupschedule?@"Yes":@"No" OldValue:subjectobject.leaveday_by_makeupschedule?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"leaveday_by_classdate" NewValue:subjectrecord.leaveday_by_classdate?@"Yes":@"No" OldValue:subjectobject.leaveday_by_classdate?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"leaveday_follow_teacher" NewValue:subjectrecord.leaveday_follow_teacher?@"Yes":@"No" OldValue:subjectobject.leaveday_follow_teacher?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"leaveday_by_enrolledschedule" NewValue:subjectrecord.leaveday_by_enrolledschedule?@"Yes":@"No" OldValue:subjectobject.leaveday_by_enrolledschedule?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"leaveday_by_staffschedule" NewValue:subjectrecord.leaveday_by_staffschedule?@"Yes":@"No" OldValue:subjectobject.leaveday_by_staffschedule?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"leaveday_follow_level" NewValue:subjectrecord.leaveday_follow_level?@"Yes":@"No" OldValue:subjectobject.leaveday_follow_level?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"leaveday_follow_lesson" NewValue:subjectrecord.leaveday_follow_lesson?@"Yes":@"No" OldValue:subjectobject.leaveday_follow_lesson?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"colorcode" NewValue:[@(subjectrecord.colorcode) stringValue] OldValue:[@(subjectobject.colorcode) stringValue] Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"leaveday_follow_category" NewValue:subjectrecord.leaveday_follow_category?@"Yes":@"No" OldValue:subjectobject.leaveday_follow_category?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"allowsameschedule" NewValue:subjectrecord.allowsameschedule?@"Yes":@"No" OldValue:subjectobject.allowsameschedule?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"showmakeupbuttonifnotimeslot" NewValue:subjectrecord.showmakeupbuttonifnotimeslot?@"Yes":@"No" OldValue:subjectobject.showmakeupbuttonifnotimeslot?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"showabsentbuttononarrangeleave" NewValue:subjectrecord.showabsentbuttononarrangeleave?@"Yes":@"No" OldValue:subjectobject.showabsentbuttononarrangeleave?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"subject_fulldescription" NewValue:subjectrecord.subject_fulldescription OldValue:subjectobject.subject_fulldescription Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"publishinchatbot" NewValue:subjectrecord.publishinchatbot?@"Yes":@"No" OldValue:subjectobject.publishinchatbot?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"chatbot_category" NewValue:subjectrecord.chatbot_category OldValue:subjectobject.chatbot_category Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"chatbot_tag1" NewValue:subjectrecord.chatbot_tag1 OldValue:subjectobject.chatbot_tag1 Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"trial_by_existinglesson" NewValue:subjectrecord.trial_by_existinglesson?@"Yes":@"No" OldValue:subjectobject.publishinchatbot?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"trial_by_definedschedule" NewValue:subjectrecord.trial_by_definedschedule?@"Yes":@"No" OldValue:subjectobject.publishinchatbot?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"trialcapacity" NewValue:subjectrecord.trialcapacity OldValue:subjectobject.trialcapacity Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"chatbot_enabletrial" NewValue:subjectrecord.chatbot_enabletrial?@"Yes":@"No" OldValue:subjectobject.chatbot_enabletrial?@"Yes":@"No" Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"pregenperiodcount" NewValue:[@(subjectrecord.pregenperiodcount) stringValue] OldValue:[@(subjectobject.pregenperiodcount) stringValue] Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"autolevelupgrade" NewValue:subjectrecord.autolevelupgrade OldValue:subjectobject.autolevelupgrade Action:action];
    
    [dictionary setValue:photoimagechanged?@"Yes":@"No" forKey:@"deleteoldphoto"];
    [dictionary setValue:action forKey:@"action"];
    
    if ([SubjectTableMode isEqualToString:@"Edit"]){
        [dictionary setValue:subjectrecord.subjectkey forKey:@"subjectkey"];
        [dictionary setValue:subjectobject.subject_shortname forKey:@"oldsubject_shortname"];
        
    }
    
//    keys=[NSArray arrayWithObjects:@"action",@"centerdb",@"centerkey",@"subjectkey",@"subject_englishname",@"subject_chinesename",@"subject_shortname",@"subject_category",@"tuition_method",@"tuition_mode",@"studentcapacity",@"enrollmentmode",@"standardnoofclassormonth",@"classduration",@"classduration_assessment",@"classduration_trial",@"remarks",@"status",@"oldsubject_shortname",@"weeklyautorenewdefault",@"validity",@"makeup_quota_unit",@"makeup_quota_value",@"leaveday_by_makeupschedule",@"leaveday_by_classdate",@"leaveday_follow_teacher",@"leaveday_by_enrolledschedule",@"leaveday_by_staffschedule",@"leaveday_follow_level",@"leaveday_follow_lesson",@"colorcode",@"leaveday_follow_category",@"allowsameschedule",nil];
//
//    values=[NSArray arrayWithObjects:action,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,subjectrecord.subjectkey,subjectrecord.subject_englishname,subjectrecord.subject_chinesename,subjectrecord.subject_shortname,subjectrecord.subject_category,subjectrecord.tuition_method,subjectrecord.tuition_mode,subjectrecord.studentcapacity,subjectrecord.enrollmentmode,subjectrecord.standardnoofclassormonth,subjectrecord.classduration,subjectrecord.classduration_assessment,subjectrecord.classduration_trial,subjectrecord.remarks,subjectrecord.status,[action isEqualToString:@"Add"]?subjectrecord.subject_shortname:subjectobject.subject_shortname,subjectrecord.weeklyautorenewdefault?@"Yes":@"No",subjectrecord.validity,subjectrecord.makeup_quota_unit,[@(subjectrecord.makeup_quota_value) stringValue],subjectrecord.leaveday_by_makeupschedule?@"Yes":@"No",subjectrecord.leaveday_by_classdate?@"Yes":@"No",subjectrecord.leaveday_follow_teacher?@"Yes":@"No",subjectrecord.leaveday_by_enrolledschedule?@"Yes":@"No",subjectrecord.leaveday_by_staffschedule?@"Yes":@"No",subjectrecord.leaveday_follow_level?@"Yes":@"No",subjectrecord.leaveday_follow_lesson?@"Yes":@"No", [@(subjectrecord.colorcode) stringValue],subjectrecord.leaveday_follow_category?@"Yes":@"No" ,subjectrecord.allowsameschedule?@"Yes":@"No",nil];
//
//    dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
//    [arrayOfDicts addObject:dict];
//    jsonsubjectarray = [NSArray arrayWithArray:arrayOfDicts];
    
    NSMutableArray *tmp_levelarray=[[NSMutableArray alloc]init];
    
    //generate json level array
    if (subjectrecord.levelArray.count>0) {
        
        arrayOfDicts = [[NSMutableArray alloc] init];
        keys=[NSArray arrayWithObjects:@"level",@"earlieststartdate",nil];
        
        for (int i = 0; i<subjectrecord.levelArray.count; i++) {
            LevelRecord *obj=[subjectrecord.levelArray objectAtIndex:i];
            if (![obj.level isEqualToString:@""]) {
                if ([tmp_levelarray containsObject:obj.level]) {
                    if ([subjectrecord.tuition_method isEqualToString:@"Level"]) {
                        [subjectrecord.levelArray removeObjectAtIndex:i];
                        [subjectrecord.tuitionArray removeObjectAtIndex:i];
                    }
                    i-=1;
                }else{
                    [tmp_levelarray addObject:obj.level];
                    values=[NSArray arrayWithObjects:obj.level, obj.earlieststartdate,nil];
                    
                    dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                    [arrayOfDicts addObject:dict];
                }
            }
        }
        jsonlevelarray = [NSArray arrayWithArray:arrayOfDicts];
    }
    
    
    //generate json tuition array
    if (subjectrecord.tuitionArray.count>0) {
        arrayOfDicts = [[NSMutableArray alloc] init];
        keys=[NSArray arrayWithObjects:@"method",@"scale",@"tuitionfee",@"newtuitionfee",@"effectivedate",nil];
        
        for (int i = 0; i<subjectrecord.tuitionArray.count; i++) {
            tuitionObject=[subjectrecord.tuitionArray objectAtIndex:i];
            if (![tuitionObject.scale isEqualToString:@""]) {
                values=[NSArray arrayWithObjects:tuitionObject.method,tuitionObject.scale,[tuitionObject.tuitionfee isEqualToString:@""]?@"0":tuitionObject.tuitionfee,tuitionObject.newtuitionfee,tuitionObject.effectivedate, nil];
                
                dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                [arrayOfDicts addObject:dict];
            }
        }
        jsontuitionarray = [NSArray arrayWithArray:arrayOfDicts];
    }
    

    
    //generate json schedule array
    if (workingSubject.scheduleArray.count>0) {
        for (long i =0; i< workingSubject.scheduleArray.count; i++) {
            schedulerecordobject=[workingSubject.scheduleArray objectAtIndex:i];
            if (![schedulerecordobject.action isEqualToString:@""]) {
                NSMutableDictionary *scheduledictionary=[[NSMutableDictionary alloc]init];
                [scheduledictionary setValue:schedulerecordobject.schedulekey forKey:@"schedulekey"];
                [scheduledictionary setValue:schedulerecordobject.name forKey:@"schedulename"];
                [scheduledictionary setValue:schedulerecordobject.autorenew forKey:@"autorenew"];
                [scheduledictionary setValue:schedulerecordobject.action forKey:@"action"];
                [scheduledictionary setValue:schedulerecordobject.type forKey:@"type"];
                [scheduledictionary setValue:schedulerecordobject.showintimetableifnoenrollment?@"Yes":@"No" forKey:@"showintimetableifnoenrollment"];
                [scheduledictionary setValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:schedulerecordobject.startdate] forKey:@"startdate"];
                [scheduledictionary setValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:schedulerecordobject.enddate] forKey:@"enddate"];
                [scheduledictionary setValue:schedulerecordobject.makeupschedule?@"Yes":@"No" forKey:@"makeupschedule"];
                [scheduledictionary setValue:schedulerecordobject.active?@"Yes":@"No" forKey:@"active"];
                [scheduledictionary setValue:schedulerecordobject.onlinetrialschedule?@"Yes":@"No" forKey:@"onlinetrialschedule"];
                
                NSString *level;
                if(!schedulerecordobject.levelarray){
                    level=@"!!None!!";
                }else if(schedulerecordobject.levelarray.count==0){
                    level=@"";
                }else{
                    level=[schedulerecordobject.levelarray componentsJoinedByString:@"#|#"];
                }
                [scheduledictionary setValue:level forKey:@"level"];
                
                NSMutableArray *detailsarray=[[NSMutableArray alloc]init];
                for(int j=0;j<schedulerecordobject.daytimearray.count;j++){
                    ScheduleDetailsRecord *object=[schedulerecordobject.daytimearray objectAtIndex:j];
                    NSMutableDictionary *detailsdictionary=[[NSMutableDictionary alloc]init];
                    [detailsdictionary setValue:object.dayofweek forKey:@"dayofweek"];
                    [detailsdictionary setValue:object.classtime forKey:@"classtime"];
                    [detailsdictionary setValue:object.instructor forKey:@"instructor"];
                    [detailsdictionary setValue:object.sinstructor forKey:@"sinstructor"];
                    [detailsdictionary setValue:object.classroom forKey:@"classroom"];
                    [detailsarray addObject:detailsdictionary];
                    
                }
                
                
                [scheduledictionary setValue:detailsarray forKey:@"scheduledetails"];
                [jsonschedulearray addObject:scheduledictionary];
                
            }
        }
    }
    
    [dictionary setValue:jsonlevelarray forKey:@"levelarray"];
    [dictionary setValue:jsonschedulearray forKey:@"schedulearray"];
    [dictionary setValue:jsontuitionarray forKey:@"tuitionarray"];
    
//    //combine arrays
//    NSMutableDictionary *dictionary =[[NSMutableDictionary alloc]init];
//    [dictionary setValue:jsonsubjectarray forKey:@"subject"];
//    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
//    [dictionary setValue:jsonlevelarray forKey:@"levelarray"];
//    [dictionary setValue:jsonschedulearray forKey:@"schedulearray"];
//    [dictionary setValue:@"updatesubject" forKey:@"postaction"];
//    [dictionary setValue:jsontuitionarray forKey:@"tuitionarray"];
    
    if(globalvariables.centerrecord.enablelessonnumber && [self lessonnumberdictdidchanged]){
        arrayOfDicts = [[NSMutableArray alloc] init];
        keys=[NSArray arrayWithObjects:@"lessonnumber",@"type",@"description",nil];
        for (id noteset in workingSubject.lessonnumberDict){
            NSMutableArray *notesetarray=workingSubject.lessonnumberDict[noteset];
            for (int i=0; i<notesetarray.count; i++) {
                values=[NSArray arrayWithObjects:[NSString stringWithFormat:@"%d", i],noteset,notesetarray[i], nil];
                dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                [arrayOfDicts addObject:dict];
            }
        }
        jsonlessonnumberarray = [NSArray arrayWithArray:arrayOfDicts];
        [dictionary setValue:jsonlessonnumberarray forKey:@"lessonnumberarray"];
    }
    
    
    __block BOOL result=FALSE;
//    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
//        if (succeeded) {
//            result=TRUE;
//        }
//    }];
    
    [MyClass callMultipartPOSTwithDict:dictionary photoArray:photoimagechanged?(photocornerobject?[[NSMutableArray alloc]initWithObjects:photocornerobject, nil]:nil):nil completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            result=TRUE;
        }
    }];

    return result;
}

- (BOOL) emptyLevelInformationWithLevelArray:(NSMutableArray *)levelarray
{
    for (int i=0; i<levelarray.count; i++) {
        if (![((LevelRecord *)[levelarray objectAtIndex:i]).level isEqualToString:@""]){
            return NO;
            break;
        }
    }
    return YES;
}

- (BOOL) retrieveEnrollmentCountWithSubjectShortname:(NSString *)shortname
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrieveenrollmentcount&subject_shortname=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,shortname];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSString *strResult = jsonreturned[@"content"];
            if ([strResult intValue] > 0) {
                subjectCanBeDeleted=NO;
            }else{
                subjectCanBeDeleted=YES;
            }
        }
    }];
    
    return result;
}

- (BOOL) canDeleteCourseScheduleCountWithSchedulekey:(NSString *)schedulekey
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievecourseschedulecount&schedulekey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,schedulekey];
    
    __block BOOL result=FALSE;
    __block BOOL courseScheduleCanBeDeleted=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSString *strResult = jsonreturned[@"content"];
            if ([strResult intValue] > 0) {
                courseScheduleCanBeDeleted=NO;
            }else{
                courseScheduleCanBeDeleted=YES;
            }
        }
    }];
    
    return courseScheduleCanBeDeleted;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView numberOfSections]-1==section) {
        return 30;
    }else{
        return CGFLOAT_MIN;
    }
}

-(void) passinstructorlistfromgrid:(NSString *)instructorlist
{
    //delegate not used
}

-(void) selectweeklyautorenewdefault:(UISwitch *)sender
{
    workingSubject.weeklyautorenewdefault=sender.on;
}

-(void) activatepublish:(UISwitch *)sender
{
    workingSubject.publishinchatbot=sender.on;
}

-(void) activatetrial_by_existinglesson:(UISwitch *)sender
{
    workingSubject.trial_by_existinglesson=sender.on;
}

-(void) activatechatbot_enabletrial:(UISwitch *)sender
{
    workingSubject.chatbot_enabletrial=sender.on;
}

-(void) activatetrial_by_definedschedule:(UISwitch *)sender
{
    workingSubject.trial_by_definedschedule=sender.on;
}

-(void) selectleaveday_by_makeupschedule:(UISwitch *)sender
{
    workingSubject.leaveday_by_makeupschedule=sender.on;
}

-(void) selectleaveday_by_enrolledschedule:(UISwitch *)sender
{
    workingSubject.leaveday_by_enrolledschedule=sender.on;
}

-(void) selectleaveday_by_classdate:(UISwitch *)sender
{
    workingSubject.leaveday_by_classdate=sender.on;
}

-(void) selectleaveday_follow_teacher:(UISwitch *)sender
{
    workingSubject.leaveday_follow_teacher=sender.on;
}

-(void) selectleaveday_follow_level:(UISwitch *)sender
{
    workingSubject.leaveday_follow_level=sender.on;
}

-(void) selectleaveday_follow_lesson:(UISwitch *)sender
{
    workingSubject.leaveday_follow_lesson=sender.on;
}

-(void) selectleaveday_follow_category:(UISwitch *)sender
{
    workingSubject.leaveday_follow_category=sender.on;
}

-(void) selectallowsameschedule:(UISwitch *)sender
{
    workingSubject.allowsameschedule=sender.on;
}

-(void) selectshowmakeupbuttonifnotimeslot:(UISwitch *)sender
{
    workingSubject.showmakeupbuttonifnotimeslot=sender.on;
}

-(void) selectshowabsentbuttononarrangeleave:(UISwitch *)sender
{
    workingSubject.showabsentbuttononarrangeleave=sender.on;
}

-(void) selectleaveday_by_staffschedule:(UISwitch *)sender
{
    workingSubject.leaveday_by_staffschedule=sender.on;
    if(workingSubject.leaveday_by_staffschedule){
        workingSubject.leaveday_follow_teacher=YES;
    }
    [MakeupTable reloadData];
}


-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    
    
    if([selectedItem isEqualToString:@"CSStartDate"]){
        NSString *selecteddatestring=[selecteddatearray firstObject];
        if (![workingSchedule.startdate isEqualToString:selecteddatestring]) {
            workingSchedule.startdate=selecteddatestring;
            
            [CourseScheduleTable reloadData];
            //[csClassDateTable reloadData];
        }
    }else if([selectedItem isEqualToString:@"CSEndDate"]){
        NSString *selecteddatestring=[selecteddatearray firstObject];
        if (![workingSchedule.enddate isEqualToString:selecteddatestring]) {
            workingSchedule.enddate=selecteddatestring;
            
            [CourseScheduleTable reloadData];
            //[csClassDateTable reloadData];
        }
    }else if([selectedItem isEqualToString:@"DateTime"]){
        NSString *selecteddatestring=[selecteddatearray firstObject];
        if (![workingScheduleDetails.dayofweek isEqualToString:selecteddatestring]) {
            workingScheduleDetails.dayofweek=[MyClass convertDateFormatWithDate:selecteddatestring FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"];
            [self updateStartEndDate];
            [CourseScheduleTable reloadData];
            //[DTPopoverTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self adjusttablesize];
            
        }
    }else if([selectedItem isEqualToString:@"LevelEffectiveDate"]){
        NSString *selecteddatestring=[MyClass convertDateFormatWithDate:[selecteddatearray firstObject] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        
        if (![selectedtuitionobject.effectivedate isEqualToString:selecteddatestring]) {
            selectedtuitionobject.effectivedate=selecteddatestring;
            showLevelEffectiveTable=NO;
            [LevelTuitionTable reloadData];
            [self adjusttablesize];
            
        }
    }else if([selectedItem isEqualToString:@"GradeEffectiveDate"]){
        NSString *selecteddatestring=[MyClass convertDateFormatWithDate:[selecteddatearray firstObject] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        
        if (![selectedtuitionobject.effectivedate isEqualToString:selecteddatestring]) {
            selectedtuitionobject.effectivedate=selecteddatestring;
            showGradeEffectiveTable=NO;
            [GradeTuitionTable reloadData];
            [self adjusttablesize];
            
        }
    }else if([selectedItem isEqualToString:@"LevelEarliestDate"]){
        NSString *selecteddatestring=[MyClass convertDateFormatWithDate:[selecteddatearray firstObject] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        
        if (![selectedlevelobject.earlieststartdate isEqualToString:selecteddatestring]) {
            selectedlevelobject.earlieststartdate=selecteddatestring;
            showLevelEffectiveTable=NO;
            [LevelTuitionTable reloadData];
            [self adjusttablesize];
            
        }
    }
}

- (void)returnCalendarYear:(NSString *)year {
    
}


- (BOOL) isScheduleBeingUsed:(NSString *)schedulekey
{
    __block BOOL result=FALSE;
    
    if (![schedulekey isEqualToString:@""]) {
        //create string contains url address for php file
        NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=checkschedulebeingused&schedulekey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,schedulekey];
        
        __block BOOL result=FALSE;
        [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                NSString *strResult = jsonreturned[@"content"];
                if ([strResult isEqualToString:@"Yes"]) {
                    result=YES;
                }
            }
        }];
        /*
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if(!error){
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                NSString *strResult = jsonreturned[@"content"];
                if ([strResult isEqualToString:@"Yes"]) {
                    result=YES;
                }
            }
            dispatch_semaphore_signal(semaphore);
        }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    }
    
    return result;
}

-(void) selectscheduletype:(UISegmentedControl *)sender
{
    workingSchedule.type=sender.selectedSegmentIndex==0?@"Recursive":@"Fixed";
    [workingSchedule.daytimearray removeAllObjects];
    [self addcstimewithrownumber];
    if ([workingSchedule.type isEqualToString:@"Fixed"]) {
        workingSchedule.autorenew=@"No";
        workingSchedule.startdate=@"";
        workingSchedule.enddate=@"";
    }
    selecteddaytimebutton=nil;
    [CourseScheduleTable reloadData];
}

-(PhotoCornerFileRecord *) copyMessagePhotoRecordWithSubject:(SubjectRecord *)obj
{
    PhotoCornerFileRecord *msgphotoobject;
    if(![obj.subject_image isEqualToString:@""]){
        NSString *strURL=[NSString stringWithFormat:@"%@subjectimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,obj.subject_image];
        NSURL *url =[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        
        NSData *data=[[NSData alloc]initWithContentsOfURL:url];
        UIImageView *imageview=[[UIImageView alloc]init];
        imageview.image=[[UIImage alloc] initWithData:data];
        
        msgphotoobject=[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:globalvariables.centerrecord.centerkey PhotoCornerFileKey:nil FileURL:obj.subject_image ImageView:imageview Width:imageview.image.size.width Height:imageview.image.size.height FileType:@"image" InternalURL:nil FileName:@"" ThumbnailURL:@"" Action:@"View" DownloadFileType:@"subject" title:@""];
        
    }
    return msgphotoobject;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak MessagePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
    cell.layer.borderColor=[UIColor lightTextColor].CGColor;
    cell.layer.borderWidth=1;

    if ([SubjectTableMode isEqualToString:@"View"]|| ([SubjectTableMode isEqualToString:@"Edit"] && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editsubject)) {
        if(!photocornerobject){
            [cell.photoimageView setImage:[UIImage imageNamed:@"subject_gray_small.png"]];
        }else{
            PhotoCornerFileRecord *obj=photocornerobject;
            [cell.photoimageView setImage:obj.imageview.image];
        }
        
//        [cell.photoimageView setImage:obj.imageview.image];
        cell.addimagebutton.hidden=YES;
        cell.deleteimagebutton.hidden=YES;
        cell.videoplayicon.hidden=YES;
    }else{
        if (!photocornerobject) {
            [cell.photoimageView setImage:nil];
            cell.addimagebutton.hidden=NO;
            cell.deleteimagebutton.hidden=YES;
            cell.videoplayicon.hidden=YES;
            [cell.addimagebutton addTarget:self action:@selector(addMessagePhoto:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            PhotoCornerFileRecord *obj=photocornerobject;
            [cell.photoimageView setImage:obj.imageview.image];
            cell.addimagebutton.hidden=YES;
            cell.deleteimagebutton.hidden=NO;
            cell.deleteimagebutton.tag=indexPath.item;
            cell.videoplayicon.hidden=YES;
            [cell.deleteimagebutton addTarget:self action:@selector(deleteMessagePhoto:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80, 80);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (photocornerobject) {
        [self showsidewindowwithwindow:@"showSubjectPhoto"];
        [self showFullScreenMessagePhoto];
        [self adjusttablesize];
    }
}

-(void) addMessagePhoto:(UIButton *)sender
{
    [self addphotobuttonpressed:sender];
}

-(void) deleteMessagePhoto:(UIButton *)sender
{
    photoimagechanged=TRUE;
    photocornerobject=nil;
    if(showSubjectPhoto){
        [self showsidewindowwithwindow:@"showChatBotSettingsTable"];
        [self adjusttablesize];
    }
    [chatBotSettingsTable reloadData];
}

-(void) addphotobuttonpressed:(UIButton *)sender
{
    addphotobutton=sender;
    [self popupaddphotodialoguebox];
}

-(void) popupaddphotodialoguebox
{
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    NSMutableArray *ItemsArray=[[NSMutableArray alloc]init];
    if (hasCamera) {
            [ItemsArray addObject:@"Take Photo"];
            [ItemsArray addObject:@"Photo Library"];
    }else{
            [ItemsArray addObject:@"Photo Library"];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"attachment" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 80) View:self Button:addphotobutton ItemsArray:ItemsArray Title:nil];

}

-(void) takephotobuttonpressed
{
   [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addclassphotofromsource:@"camera"];
}

-(void) photolibrarybuttonpressed
{
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addclassphotofromsource:@"library"];
}

-(void) addclassphotofromsource:(NSString *)source
{
        imagepicker = [[UIImagePickerController alloc] init];
        imagepicker.delegate = self;
        imagepicker.allowsEditing=NO;
        
        if ([source isEqualToString:@"photocamera"]) {
            imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagepicker.modalPresentationStyle = UIModalPresentationFullScreen;
            imagepicker.view.tag=0;
            [MyClass presentViewController:imagepicker View:self];
        }else if ([source isEqualToString:@"photolibrary"]){
            //imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            if ([mypopovercontroller presentingViewController].isBeingPresented) {
                [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            }
            
            imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            imagepicker.modalPresentationStyle=UIModalPresentationPopover;
            mypopovercontroller=imagepicker.popoverPresentationController;
            mypopovercontroller.delegate=self;
            mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionLeft;
            mypopovercontroller.sourceView=addphotobutton;
            mypopovercontroller.sourceRect=addphotobutton.bounds;
            
            [self presentViewController:imagepicker animated:YES completion:nil];
        }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    photoimagechanged=TRUE;
    [self.delegate donotrunviewdidappear];
    //[imagepicker dismissViewControllerAnimated:YES completion:nil];

    UIImage *image=info[UIImagePickerControllerOriginalImage];
    NSData *imageData;
    if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
        imageData = UIImageJPEGRepresentation(image, 1.0);
    } else {
        if (@available(iOS 11.0, *)) {
            imageData = [NSData dataWithContentsOfURL:info[UIImagePickerControllerImageURL]];
        } else {
            imageData = UIImageJPEGRepresentation(image, 1.0);
        }
    }
    if (![MyClass isPDFSizeNotExceedLimitWithData:imageData]) {
        [picker dismissViewControllerAnimated:NO completion:^{
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Image"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
        }];
    }else{
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //UIImage *image=info[UIImagePickerControllerOriginalImage];
            //image=[MyClass resizeImageWithImage:image ForSize:image.size];
            NSURL *imageURL=[MyClass returnInternalURLforNSData:imageData Filename:@"image"];
            
            photocornerobject=[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:globalvariables.centerrecord.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.height Height:image.size.height FileType:@"image" InternalURL:imageURL FileName:@"" ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"subject" title:@""];
            
            [picker dismissViewControllerAnimated:YES completion:nil];
            NSRange range = NSMakeRange(1,1);
            NSIndexSet *sections = [NSIndexSet indexSetWithIndexesInRange:range];
            [chatBotSettingsTable reloadSections:sections withRowAnimation:UITableViewRowAnimationAutomatic];
            [MyClass loadingindicatorwithoption:@"stop" color:@""];
        });
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.delegate donotrunviewdidappear];
    [imagepicker dismissViewControllerAnimated:YES completion:nil];
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) showFullScreenMessagePhoto
{
    [fullscreen_messageimageview setImage:photocornerobject.imageview.image];
    
    float imageheight;
    float imagewidth;
    
    if (fullscreen_messageimageview.image.size.height/fullscreen_messageimageview.image.size.width*fullscreen_scrollview.frame.size.width>fullscreen_scrollview.frame.size.height) {
        imageheight=fullscreen_scrollview.frame.size.height;
        imagewidth=fullscreen_messageimageview.image.size.width*fullscreen_scrollview.frame.size.height/fullscreen_messageimageview.image.size.height;
        fullscreen_messageimageview.frame=CGRectMake((fullscreen_scrollview.frame.size.width-imagewidth)/2, 0, imagewidth, imageheight);
    }else{
        imageheight=fullscreen_messageimageview.image.size.height*fullscreen_scrollview.frame.size.width/fullscreen_messageimageview.image.size.width;
        imagewidth=fullscreen_scrollview.frame.size.width;;
        fullscreen_messageimageview.frame=CGRectMake(0, (fullscreen_scrollview.frame.size.height-imageheight)/2, imagewidth, imageheight);
    }
    fullscreen_scrollview.contentSize=CGSizeMake(fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    
}

-(void) closefullscreen
{
//    [avplayerviewcontroller.player pause];
    MessagePhotoMasterView.hidden=YES;
}


-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if ([SubjectTableMode isEqualToString:@"View"] || [SubjectTableMode isEqualToString:@"Add"] || [SubjectTableMode isEqualToString:@"Edit"]) {
        return fullscreen_messageimageview;
    }
    return nil;
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    
    if (fullscreen_messageimageview.frame.size.width<MessagePhotoMasterView.frame.size.width) {
        fullscreen_messageimageview.frame=CGRectMake((MessagePhotoMasterView.frame.size.width-fullscreen_messageimageview.frame.size.width)/2, fullscreen_messageimageview.frame.origin.y, fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    }else{
        fullscreen_messageimageview.frame=CGRectMake(0, fullscreen_messageimageview.frame.origin.y, fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    }
    
    if (fullscreen_messageimageview.frame.size.height<MessagePhotoMasterView.frame.size.height-44) {
        fullscreen_messageimageview.frame=CGRectMake(fullscreen_messageimageview.frame.origin.x, (MessagePhotoMasterView.frame.size.height-44-fullscreen_messageimageview.frame.size.height)/2, fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    }else{
        fullscreen_messageimageview.frame=CGRectMake(fullscreen_messageimageview.frame.origin.x, 0, fullscreen_messageimageview.frame.size.width, fullscreen_messageimageview.frame.size.height);
    }
    
    //fullscreen_messageimageview.transform = CGAffineTransformMakeRotation(messagephotoobject.imagerotation90angle*M_PI_2);

}

-(void) rotateimage
{
    photoimagechanged=TRUE;
    [photocornerobject.imageview setImage:[MyClass imageRotatedOnDegrees:90 Image:photocornerobject.imageview.image]];
    photocornerobject.internalurl=[MyClass returnInternalURLforNSData:UIImageJPEGRepresentation(photocornerobject.imageview.image, 0.7) Filename:@"image"];
    [self showFullScreenMessagePhoto];
    [chatBotSettingsTable reloadData];
}


-(void) shareimage:(UIButton *)sender
{
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *strURL=[NSString stringWithFormat:@"%@subjectimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,photocornerobject.fileurl];
            
        NSURL *url =[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        

            UIImage *imagetoshare = [[SDImageCache sharedImageCache] imageFromCacheForKey:[url absoluteString]];
            NSArray *activityItems = @[imagetoshare];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
            activityVC.modalPresentationStyle=UIModalPresentationPopover;
            mypopovercontroller=activityVC.popoverPresentationController;
            mypopovercontroller.delegate=self;
            mypopovercontroller.delegate=self;
            mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
            mypopovercontroller.sourceView=sender;
            mypopovercontroller.sourceRect=sender.bounds;
              
            [self presentViewController:activityVC animated:YES completion:nil];
        
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

-(void) tuitionleveleffectivedatepressed:(UIButton *)sender
{
    selectedItem=@"LevelEffectiveDate";
    selectedtuitionobject=[workingSubject.tuitionArray objectAtIndex:sender.tag];
    [self closeallpickers];
    [self showsidewindowwithwindow:@"showLevelEffectiveTable"];
    [levelEffectiveDateTable reloadData];
    [self adjusttablesize];
}

-(void) tuitionlevelearliestdatepressed:(UIButton *)sender
{
    selectedItem=@"LevelEarliestDate";
    selectedlevelobject=[workingSubject.levelArray objectAtIndex:sender.tag];
    [self closeallpickers];
    [self showsidewindowwithwindow:@"showLevelEffectiveTable"];
    [levelEffectiveDateTable reloadData];
    [self adjusttablesize];
}

-(void) tuitiongradeeffectivedatepressed:(UIButton *)sender
{
    selectedItem=@"GradeEffectiveDate";
    selectedtuitionobject=[workingSubject.tuitionArray objectAtIndex:sender.tag];
    [self closeallpickers];
    [self showsidewindowwithwindow:@"showGradeEffectiveTable"];
    [gradeEffectiveDateTable reloadData];
    [self adjusttablesize];
}


-(NSString *) returnlevelwithlevelarray:(NSMutableArray *)array
{
    if(!array){
        return [MyClass returntitlewithtitle:@"None"];
    }else if(array.count==0){
        return [MyClass returntitlewithtitle:@"All"];
    }
    return [array componentsJoinedByString:@" | "];
}


- (IBAction)schedulelevelnonebuttonpressed:(id)sender {
    [self.view endEditing:YES];
    workingSchedule.levelarray=nil;
    [ScheduleLevelTable reloadData];
    [CourseScheduleTable reloadData];
}

- (IBAction)schedulelevelallbuttonpressed:(id)sender {
    [self.view endEditing:YES];
    workingSchedule.levelarray=[[NSMutableArray alloc]init];
    [ScheduleLevelTable reloadData];
    [CourseScheduleTable reloadData];
}

- (IBAction)closeeffectivedatebuttonpressed:(id)sender {
    [self.view endEditing:YES];
    if([selectedItem isEqualToString:@"LevelEffectiveDate"]){
        selectedtuitionobject.effectivedate=@"";
    }else if ([selectedItem isEqualToString:@"LevelEarliestDate"]){
        selectedlevelobject.earlieststartdate=@"";
    }
    showLevelEffectiveTable=NO;
    [self adjusttablesize];
    [LevelTuitionTable reloadData];
}

-(void) removeButtonsWithView:(UIView *)view
{
    for (UIView *subview in view.subviews) {
        // Check if the subview is a UIButton and has tag 3027
        if ([subview isKindOfClass:[UIButton class]] && subview.tag == 3027) {
            // Remove the button from its superview
            [subview removeFromSuperview];
        }
    }
}

-(NSString *) returnautolevelupgradetitle:(NSString *)autolevelupgrade
{
    if ([[autolevelupgrade substringToIndex:1] isEqualToString:@"Y"]) {

    return [MyClass returnreplacedtitlewithtitle:@"%@1 / year" replacementarray:@[[MyClass convertDateFormatWithDate:[autolevelupgrade substringFromIndex:1] FromDateFormat:@"MMdd" ToDateFormat:@"dd-MMM" Translate:YES]]];
    }else{
        return [MyClass returntitlewithtitle:autolevelupgrade];
    }
    
}

@end
