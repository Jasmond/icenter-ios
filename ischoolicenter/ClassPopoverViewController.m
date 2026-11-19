//
//  ClassPopoverViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 5/1/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "ClassPopoverViewController.h"
#import "MyClass.h"
#import "MyTableViewCell.h"
//#import "AFNetworking.h"

@interface ClassPopoverViewController ()

@end

@implementation ClassPopoverViewController
@synthesize ClassToolBar;
@synthesize PopoverClass,ClassRecordArray;
@synthesize ClassTableMode,JSONArray;
@synthesize pickerViewmenu,hourPickerViewMenu,minutePickerViewMenu,myPickerView,myPopoverController;
@synthesize FreeScheduleClassArray;
@synthesize levelmainPickerViewMenu,levelctmPickerViewMenu;

#define maxPopupHeight self.view.frame.size.height
//#define kbPopupHeight 380
#define popoverwidth 320
#define instructortablewidth 300
#define classroomtablewidth 300
#define naturetablewidth 300
#define lessonnumbertablewidth 300

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    globalvariables=[GlobalVariables singleObj];
    //self.preferredContentSize=CGSizeMake(320, popupHeight);
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];

    //initialize field
    //[self retrievesubjectinformation];
    [self InitializeField];
    
    //keyboardshow=FALSE;
    
    ///masterView=[[UIScrollView alloc]init];

//    [MyClass getLatestDataSetv2withParameters:@"staff,classroom,subject,calendar" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];

    AllInstructorArray=[MyClass retrieveInstructorListwithvalid:@"All" flushcachedata:NO];
    ActiveInstructorArray=[MyClass filterInstructorArrayWithInstructorArray:AllInstructorArray Valid:@"Yes"];
    filteredActiveInstructorArray=[[NSMutableArray alloc]initWithArray:ActiveInstructorArray];
    AvailableClassroomArray=[MyClass retrieveClassroomListwithstatus:@"In Service"  withTBD:YES flushcachedata:NO];
    FilteredClassroomArray=[[NSMutableArray alloc]initWithArray:AvailableClassroomArray];
    leaveNatureArray=[MyClass retrieveLeaveNatureArrayWithFlushCacheData:NO];
    
    //classhasextendedclass=[MyClass classhasextendedclasswithclasskey:PopoverClass.classkey]?@"Yes":@"No";
    
    [self createtables];
    
    [ClassPopoverTable reloadData];
    
    [self createViewBarButton];

    [self adjusttablesize];
    
    [self.view addSubview:ClassPopoverTable];
    [self loadcalendar];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //add buttonarray
    regularattendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnregularattendancebuttonarray]];
    makeupattendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnmakeupattendancebuttonarray]];

    
    UIPanGestureRecognizer *panGesture;
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.delegate = self;
    [ClassPopoverTable addGestureRecognizer:panGesture];
    
    [self startAudioSession];
    audioPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(audioPanGestureDetected:)];
    audioPanGesture.maximumNumberOfTouches = 1;
    audioPanGesture.minimumNumberOfTouches = 1;
    audioPanGesture.delegate = self;

    // Choose between heavy, medium, and light for style
    impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
        
    // Primes feedback generator for upcoming events and reduces latency
    [impactFeedbackGenerator prepare];
    
    [editButton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
     [cancelButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
      [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeDefault options:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetoothHFP | AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];

}

-(void) viewDidDisappear:(BOOL)animated
{
    if (audioPlayer.playing) {
        [audioPlayer stop];
        audioPlayer=nil;
        [sliderTimer invalidate];
        
    }
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    if (attendanceringview) {
        
        UIView *windowview = self.view;
        while (windowview.superview != Nil) {
            windowview = windowview.superview;
        }
        
        if (recognizer.state!=UIGestureRecognizerStateEnded) {
            CGPoint point= [recognizer locationInView:windowview];
            point.x=point.x-attendanceringview.frame.origin.x;
            point.y=point.y-attendanceringview.frame.origin.y;
            lasttouchedsector= [MyClass updateattendanceringwithtouchpoint:point attendanceringview:attendanceringview attendancebuttonarray:attendancebuttonarray lasttouchedsector:lasttouchedsector size:@"small"];
        }else{
            CGPoint point= [recognizer locationInView:windowview];
            point.x=point.x-attendanceringview.frame.origin.x;
            point.y=point.y-attendanceringview.frame.origin.y;
            
            [self attendanceringreleasedwithtouchpoint:point];
            
            [UIView animateWithDuration:0.4 animations:^{self->attendanceringview.alpha = 0.0;} completion:^(BOOL finished){ [self->attendanceringview removeFromSuperview]; }];
            attendanceringview=nil;
            ClassPopoverTable.scrollEnabled=TRUE;
            [ClassPopoverTable deselectRowAtIndexPath:[ClassPopoverTable indexPathForSelectedRow] animated: YES];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}


-(void) attendanceringreleasedwithtouchpoint:(CGPoint)touchpoint
{
    //check if inside ring
    if ([MyClass returntouchpointwithinattendanceringwithtouchpoint:touchpoint size:@"small"]) {
        NSIndexPath *selectedIndexPath = [ClassPopoverTable indexPathForSelectedRow];
        [self updateattendancewithindexpath:selectedIndexPath value:((AttendanceButtonObject *)[attendancebuttonarray objectAtIndex:lasttouchedsector]).buttonname];
    }
}

-(void)updateattendancewithindexpath:(NSIndexPath *)indexpath value:(NSString *)value
{
    if (![value isEqualToString:(indexpath.section==4)?workingClass.attendance:workingClass.makeupattendance]) {
        [self showsidewindowwithwindow:@"none"];
        if (indexpath.section==4) {
            workingClass.attendance=value;
            //leaveNatureArray=[MyClass retrieveLeaveNatureArrayWithFlushCacheData:NO];
            //if([value isEqualToString:@"Makeup"]){
                workingClass.leavenaturelistkey=[MyClass returnDefaultLeaveNatureListKeyWithAttendance:value];
            //}
            [self updatefreescheduleclassarrayafterattendanceupdate];
        }else if (indexpath.section==5){
            workingClass.makeupattendance=value;
        }
        [ClassPopoverTable reloadData];
    }
}

-(void) createtables
{
    //ClassPopoverTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, 320, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    //ClassPopoverTable.dataSource=self;
    //ClassPopoverTable.delegate=self;
    ClassToolBar.clipsToBounds = YES;

    
    //instructor table
    InstructorTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, instructortablewidth, self.view.bounds.size.height)];
    [self.view addSubview:InstructorTableMasterView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, InstructorTableMasterView.frame.size.width,88+3)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [InstructorTableMasterView addSubview:headerView];
    
    instructortablelabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    instructortablelabel.text=[[MyClass returntitlewithtitle:@"Instructor"] uppercaseString];
    instructortablelabel.font=[UIFont systemFontOfSize:13];
    instructortablelabel.textColor=[UIColor grayColor];
    [headerView addSubview:instructortablelabel];
    
    instructorsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, InstructorTableMasterView.frame.size.width, 42)];
    instructorsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    instructorsearchbar.delegate=self;
    instructorsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:instructorsearchbar];
    
    InstructorTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+88+20+3, instructortablewidth, self.view.bounds.size.height-44-88-20-3) style:UITableViewStyleGrouped];
    InstructorTable.dataSource=self;
    InstructorTable.delegate=self;
    InstructorTable.sectionHeaderHeight=0;
    [InstructorTable reloadData];
    [InstructorTableMasterView addSubview:InstructorTable];
    
    InstructorTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, instructortablewidth, 44)];
    InstructorTableToolBar.clipsToBounds = YES;
    [InstructorTableMasterView addSubview:InstructorTableToolBar];
    
    UIButton *instructorimage=[[UIButton alloc]initWithFrame:CGRectMake(InstructorTableMasterView.frame.size.width-44, 4, 40, 40)];
    [instructorimage setImage:[UIImage imageNamed:@"instructoricon.png"] forState:UIControlStateNormal];
    [instructorimage setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [instructorimage addTarget: self action:@selector(InstructorButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
    //[headerView addSubview:instructorimage];
    
    [self createInstructorTableToolBar];
    
    
    //classroom table
    ClassroomTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, classroomtablewidth, self.view.bounds.size.height)];
    [self.view addSubview:ClassroomTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, ClassroomTableMasterView.frame.size.width,88+3)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [ClassroomTableMasterView addSubview:headerView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Classroom"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    classroomsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, ClassroomTableMasterView.frame.size.width, 42)];
    classroomsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    classroomsearchbar.delegate=self;
    classroomsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:classroomsearchbar];
    
    ClassroomTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+88+20+3, instructortablewidth, self.view.bounds.size.height-44-88-20-3) style:UITableViewStyleGrouped];
    ClassroomTable.dataSource=self;
    ClassroomTable.delegate=self;
    ClassroomTable.sectionHeaderHeight=CGFLOAT_MIN;
    
    [ClassroomTable reloadData];
    [ClassroomTableMasterView addSubview:ClassroomTable];
    
    ClassroomTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, instructortablewidth, 44)];
    ClassroomTableToolBar.clipsToBounds = YES;
    [ClassroomTableMasterView addSubview:ClassroomTableToolBar];
    
    
    [self createClassroomTableToolBar];
    
    
    //nature
    NatureTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, naturetablewidth, self.view.frame.size.height)];
    [self.view addSubview:NatureTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, NatureTableMasterView.frame.size.width,44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [NatureTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Nature"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    NatureTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+44+20, naturetablewidth, self.view.frame.size.height-44-44-20) style:UITableViewStyleGrouped];
    NatureTable.dataSource=self;
    NatureTable.delegate=self;
    
    [NatureTable reloadData];
    [NatureTableMasterView addSubview:NatureTable];
    
    UILabel *separator=[[UILabel alloc]initWithFrame:CGRectMake(0, 44+44+20, naturetablewidth, 0.5)];
    separator.layer.opacity=0.6;
    separator.backgroundColor=[UIColor lightGrayColor];
    [NatureTableMasterView addSubview:separator];
    
    NatureTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, naturetablewidth, 44)];
    NatureTableToolBar.clipsToBounds = YES;
    [NatureTableMasterView addSubview:NatureTableToolBar];
    [self createNatureTableToolBar];
    
    LessonNumberTable.sectionHeaderHeight=0;
    [self createLessonNumberTableToolBar];
    
    //[self.view bringSubviewToFront:LessonNumberTableMasterView];
    
    

    //add separator
    separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth, 20, 1, self.view.frame.size.height-20)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
    
}

-(void) createInstructorTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closeinstructortable) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [InstructorTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeinstructortable) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [InstructorTableMasterView addSubview:button];
}

-(void) createLessonNumberTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closelessonnumbertable) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
//    UIBarButtonItem *clearButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Clear"] style:UIBarButtonItemStylePlain target:self action:@selector(clearLessonNumber)];
    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,clearButton, nil];
//    [LessonNumberTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closelessonnumbertable) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [LessonNumberTableMasterView addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 100, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"Clear"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clearLessonNumber) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(lessonnumbertablewidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
    [LessonNumberTableMasterView addSubview:button];
    
    
}

-(void) createClassroomTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closeclassroomtable) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [ClassroomTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeclassroomtable) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [ClassroomTableMasterView addSubview:button];
}

-(void) createNatureTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closenaturetable) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [NatureTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closenaturetable) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [NatureTableMasterView addSubview:button];
}


-(void) loadcalendar
{
    //[MyClass getLatestDataSetv2withParameters:@"calendar" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    //[MyClass LoadSchoolCalendarArray];
    //[MyClass LoadSchoolCalendarWithCheckingLastUpdate:YES];
    //datePickerViewMenu=[[NSMutableArray alloc]initWithArray:globalvariables.centerandreserveddayarray];
    hourPickerViewMenu=[[NSMutableArray alloc]init];
    minutePickerViewMenu=[[NSMutableArray alloc]init];

    [MyClass loadHourPickerViewMenu:hourPickerViewMenu];
    for (int i=0; i<60; i+=[globalvariables.centerrecord.classtimeinterval intValue]) {
        [minutePickerViewMenu addObject:[NSString stringWithFormat:@"%02i",i]];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(void) createViewBarButton{
    editButton.hidden=NO;
    doneButton.hidden=YES;
    cancelButton.hidden=YES;
    
//    UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,editButton,nil];
//    [ClassToolBar setItems:buttons animated:NO];
    editButton.enabled=![MyClass classLocked:workingClass.locked];
    
    if ([PopoverClass.status isEqualToString:@"Voided"]) {
        editButton.enabled=NO;
    }
}

-(void) createEditBarButton{
    editButton.hidden=YES;
    doneButton.hidden=NO;
    cancelButton.hidden=NO;
    
//    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
//    //UIBarButtonItem *resetButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset Makeup"] style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:cancelButton, flexibleSpaceBarButton,doneButton,nil];
//    [ClassToolBar setItems:buttons animated:NO];
}

-(void) resetButtonPressed:(id)sender
{
    workingClass.makeupinstructor=@"";
    workingClass.makeupdate=@"";
    workingClass.makeuptime=@"";
    workingClass.makeupclassroom=@"";
    workingClass.absentmakeupreason=@"";
    workingClass.makeupattendance=@"";
    workingClass.leavenaturelistkey=[MyClass returnDefaultLeaveNatureListKeyWithAttendance:@"Makeup"];
    [self showsidewindowwithwindow:@"none"];
    [self closeallpickers];
    
    [ClassPopoverTable reloadData];
    [self adjusttablesize];
    
}

-(void) closeallpickers
{
    showDatePicker=NO;
    showLevelPicker=NO;
    showMakeupDateTimePicker=NO;
}

-(IBAction) cancelButtonPressed:(id)sender
{
    ClassTableMode=@"View";
    [self createViewBarButton];
    [ClassPopoverTable reloadData];
    [self InitializeField];
    [ClassPopoverTable reloadData];
    [self adjusttablesize];

    [ClassPopoverTable setContentOffset:CGPointMake(0, 0)];
}

-(IBAction) editButtonPressed:(id)sender{
    
    ClassTableMode=@"Edit";
    [self createEditBarButton];
    
    if ([PopoverClass.attendance isEqualToString:@"Makeup"]) {
        //makeup class
        
        NSString *tmpclassdate;
        NSString *tmpclasstime;
        NSString *tmpinstructor;
        NSString *tmpsinstructor;
        NSString *tmpclassroom;
        
        if ([PopoverClass.makeupdate isEqualToString:@""]) {
            tmpclassdate=@"TBD";
        }else{
            tmpclassdate=PopoverClass.makeupdate;
        }
        
        if ([PopoverClass.makeuptime isEqualToString:@""]) {
            tmpclasstime=@"TBD";
        }else{
            tmpclasstime=PopoverClass.makeuptime;
        }
        
        if ([PopoverClass.makeupinstructor isEqualToString:@""]) {
            tmpinstructor=@"TBD";
        }else{
            tmpinstructor=PopoverClass.makeupinstructor;
        }
        
        if ([PopoverClass.makeupsinstructor isEqualToString:@""]) {
            tmpsinstructor=@"TBD";
        }else{
            tmpsinstructor=PopoverClass.makeupsinstructor;
        }

        if ([PopoverClass.makeupclassroom isEqualToString:@""]) {
            tmpclassroom=@"TBD";
        }else{
            tmpclassroom=PopoverClass.makeupclassroom;
        }
        
        FreeScheduleClassArray=[[NSMutableArray alloc]initWithObjects:[[FreeScheduleClass alloc]initFreeScheduleClassWithclasskey:PopoverClass.classkey subject:PopoverClass.subject classdate:tmpclassdate classtime:tmpclasstime instructor:tmpinstructor classroom:tmpclassroom attendance:FreeScheduleClassObject.attendance makeupdate:FreeScheduleClassObject.makeupdate makeuptime:FreeScheduleClassObject.makeuptime makeupinstructor:FreeScheduleClassObject.makeupinstructor makeupclassroom:FreeScheduleClassObject.makeupclassroom makeupattendance:FreeScheduleClassObject.makeupattendance classremarks:PopoverClass.remarks allclassremarks:PopoverClass.allclassremarks action:@"" classtype:@"Class" leavenaturelistkey:PopoverClass.leavenaturelistkey lesson:PopoverClass.lesson sinstructor:tmpsinstructor makeupsinstructor:FreeScheduleClassObject.makeupsinstructor locked:FreeScheduleClassObject.locked], nil];
    }else{
        //no makeup class
        FreeScheduleClassArray=[[NSMutableArray alloc]initWithObjects:[[FreeScheduleClass alloc]initFreeScheduleClassWithclasskey:PopoverClass.classkey subject:PopoverClass.subject classdate:PopoverClass.startdate classtime:PopoverClass.classtime instructor:PopoverClass.instructor classroom:PopoverClass.classroom attendance:FreeScheduleClassObject.attendance makeupdate:FreeScheduleClassObject.makeupdate makeuptime:FreeScheduleClassObject.makeuptime makeupinstructor:FreeScheduleClassObject.makeupinstructor makeupclassroom:FreeScheduleClassObject.makeupclassroom makeupattendance:FreeScheduleClassObject.makeupattendance classremarks:PopoverClass.remarks allclassremarks:PopoverClass.allclassremarks action:@"" classtype:@"Class" leavenaturelistkey:PopoverClass.leavenaturelistkey lesson:PopoverClass.lesson sinstructor:PopoverClass.sinstructor makeupsinstructor:FreeScheduleClassObject.makeupsinstructor locked:FreeScheduleClassObject.locked],nil];
        
    }
    
    
    //[ClassPopoverTable setFrame:CGRectMake(0, 0, 320, editTableHeight)];
    [ClassPopoverTable reloadData];
    
    [self adjusttablesize];
    
    ///[masterView setContentSize:ClassPopoverTable.bounds.size];
    
}

-(IBAction) doneButtonPressed:(id)sender
{
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }
    

    //classvalidatemessage=[MyClass validateClassWithFreeScheduleArray:FreeScheduleClassArray studentkey:PopoverClass.studentkey enrollmentkey:nil];
    classvalidatemessage=[MyClass validateClassWithFreeScheduleArray:[self returnfreescheduleclassarray] studentkey:PopoverClass.studentkey enrollmentkey:nil];
    
    classvalidatestatus=[[ClassValidateStatus alloc]initClassValidateStatuswithoverenrollmentstatus:@"" sameinstructormulticlassstatus:@"" alreadyenrolledstatus:@"" sameclassroommulticlassstatus:@"" hasextendedchildclassstatus:@"" classroomexceedcapacitystatus:@"" makeupquotaexceedstatus:@""];
    [self checkvalidatemessage];
    
}


-(void) updateClassWithLaterEnrollmentsLevelUpdate:(BOOL)updatelaterenrollmentslevel
{
    //[self createViewBarButton];
    
    //update to sql
    //create string contains url address for php file
    //NSDateFormatter *df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    //NSDate *date;
    NSString *tmpclasstime;
    NSString *tmpmakeupdate;
    NSString *tmpmakeuptime;
    NSString *tmpstartdate;
    NSString *tmpmakeupinstructor;
    NSString *tmpmakeupsinstructor;
    NSString *tmpmakeupclassroom;

    NSString *tmplevelmain;
    NSString *tmplevelctm;
    
    tmpclasstime=workingClass.classtime;
    if([workingClass.startdate isEqualToString:@"TBD"]){
        tmpstartdate=@"TBD";
    }else{
        tmpstartdate=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:workingClass.startdate];
    }
    
    if ([MyClass isEyeLevelMathWithSubject:workingClass.subject]) {
            if ([tmpLevel isEqualToString:@"TBD"] || [tmpLevel isEqualToString:@"DT"]) {
                tmplevelmain=tmpLevel;
                tmplevelctm=tmpLevel;
            }else{
                NSRange range=[tmpLevel rangeOfString:@"/"];
                if (range.location==NSNotFound) {
                    tmplevelmain=[tmpLevel substringFromIndex:3];
                    tmplevelctm=@"";
                }else{
                    tmplevelmain=[tmpLevel substringWithRange:NSMakeRange(3, range.location-3)];
                    tmplevelctm=[tmpLevel substringFromIndex:range.location+4];
                }
            }
    }else{
        if ([tmpLevel isEqualToString:@""]) {
            tmplevelmain=@"TBD";
        }else{
            tmplevelmain=tmpLevel;
        }
        tmplevelctm=@"";
    }
    
    if (![workingClass.makeupdate isEqualToString:@""]) {
        //[df setDateFormat:@"dd-MMM-yyyy"];
        //date = [df dateFromString:[tmpMakeupDateTime substringToIndex:11]];
        //[df setDateFormat:@"yyyy-MM-dd"];
        tmpmakeupdate = [MyClass convertDateFormatWithDate:workingClass.makeupdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"];
        tmpmakeuptime=workingClass.makeuptime;

        if ([workingClass.makeupinstructor isEqualToString:@""]) {
            tmpmakeupinstructor=@"TBD";
        }else{
            tmpmakeupinstructor=workingClass.makeupinstructor;
        }
        
        if ([workingClass.makeupsinstructor isEqualToString:@""]) {
            tmpmakeupsinstructor=@"TBD";
        }else{
            tmpmakeupsinstructor=workingClass.makeupsinstructor;
        }
        
        if ([workingClass.makeupclassroom isEqualToString:@""]) {
            tmpmakeupclassroom=@"TBD";
        }else{
            tmpmakeupclassroom=workingClass.makeupclassroom;
        }
    }else{
        tmpmakeupdate=@"";
        tmpmakeuptime=@"";
        tmpmakeupinstructor=workingClass.makeupinstructor;
        tmpmakeupclassroom=workingClass.makeupclassroom;
    }
    
    
    ClassRecord *tmpclassrecord=[[ClassRecord alloc]initClassWithstudentkey:PopoverClass.studentkey andenrollmentkey:PopoverClass.enrollmentkey andclasskey:PopoverClass.classkey andsubject:PopoverClass.subject andlevelmain:tmplevelmain andlevelctm:tmplevelctm andstartdate:tmpstartdate andclassday:workingClass.classday andclasstime:tmpclasstime andinstructor:workingClass.instructor andattendance:workingClass.attendance andmakeupattendance:workingClass.makeupattendance andmakeupdate:tmpmakeupdate andmakeuptime:tmpmakeuptime andremarks:workingClass.remarks andallclassremarks:workingClass.allclassremarks andmakeupinstructor:tmpmakeupinstructor andmakeupclassroom:tmpmakeupclassroom andabsentmakeupreason:workingClass.absentmakeupreason anddraft:PopoverClass.draft andclassroom:workingClass.classroom andschedulekey:nil andstatus:PopoverClass.status andextendedminute:PopoverClass.extendedminute andextensiontime:PopoverClass.extensiontime orderdatetime:PopoverClass.orderdatetime instructorfullname:nil makeupinstructorfullname:nil subjectfullname:nil parentnote:workingClass.parentnote assessmentformcount:0 leavenaturelistkey:workingClass.leavenaturelistkey makeupquotaavailable:NO voiceparentnotemessage:workingClass.voiceparentnotemessage lesson:workingClass.lesson sinstructor:workingClass.sinstructor makeupsinstructor:tmpmakeupsinstructor locked:workingClass.locked enrollmentpaid:NO expiredpromotion:NO hasextendedclass:NO];
    
    //EnrollmentRecord *tmpenrollmentrecord=[self updateEnrollmentRecord];
    
    if ([self updateClassWithClassRecord:tmpclassrecord Action:@"Edit" updatelaterenrollmentslevel:updatelaterenrollmentslevel]) {
        
        BOOL sendaudioparentnote=FALSE;
        if (workingClass.voiceparentnotemessage.photoarray.count>0) {
            if (((MessagePhotoRecord *)[workingClass.voiceparentnotemessage.photoarray firstObject]).internalurl) {
                sendaudioparentnote=TRUE;
            }
        }
        
        if (sendaudioparentnote) {
            [self sendaudioparentnotewithstudentkeys:@[@{@"classkey":workingClass.classkey,@"studentkey":PopoverClass.studentkey}]];
        }else{
            [self.delegate dismissClassPopoverVC];
            
            
            
            /*
            UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Information successfully updated"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [successalert dismissViewControllerAnimated:YES completion:nil];

            }];
            
            [successalert addAction:OKAction];
            //[self presentViewController:successalert animated:YES completion:nil];
            [MyClass presentViewController:successalert View:self];*/
        }
        
        

        

    }else{
        [MyClass showconnectionlostdialogbox];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView==ClassPopoverTable) {
        if ([ClassTableMode isEqualToString:@"View"]) {
            return 7;
        }else{ //ClassTableMode isEqualToString:@"Edit"
            return 6;
        }
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==ClassPopoverTable) {
        if ([ClassTableMode isEqualToString:@"View"]) {
            if (section==0) {
                return 8;
            }else if (section==4){
                return 3;
            }else if (section==5){
                return 5;
            }else{
                return 1;
            }
        }else{ //ClassTableMode isEqualToString:@"Edit"
            if (section==0) {
                return 10;
            }else if (section==4){
                return 3;
            }else if (section==5){
                return 6;
            }else{
                return 1;
            }
        }
    }else if (tableView==InstructorTable){
        return filteredActiveInstructorArray.count;
    }else if (tableView==NatureTable){
        return leaveNatureArray.count;
    }else if (tableView==ClassroomTable){
        return showClassroomTable?FilteredClassroomArray.count:0;
    }else if (tableView==LessonNumberTable){
        return globalvariables.centerrecord.lessonnumbermode==2?1:lessonArray.count;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==ClassPopoverTable) {
        if ([ClassTableMode isEqualToString:@"View"]) {
            if (section==0) {
                return [MyClass returntitlewithtitle:@"General"];
            }else if (section==1){
                return [MyClass returntitlewithtitle:@"Class Remarks"];
            }else if (section==2){
                return [MyClass returntitlewithtitle:@"All Class Remarks"];
            }else if (section==3){
                return [MyClass returntitlewithtitle:@"Teacher Note"];
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Attendance"];
            }else if (section==5){
                if (showMakeupSection) {
                    return [MyClass returntitlewithtitle:@"Makeup"];
                }else{
                    return nil;
                }
            }else{
                return nil;
            }
        }else{ //ClassTableMode isEqualToString:@"Edit"
            if (section==0) {
                return [MyClass returntitlewithtitle:@"General"];
            }else if (section==1){
                return [MyClass returntitlewithtitle:@"Class Remarks"];
            }else if (section==2){
                return [MyClass returntitlewithtitle:@"All Class Remarks"];
            }else if (section==3){
                return [MyClass returntitlewithtitle:@"Teacher Note"];
            }else if (section==4) {
                return [MyClass returntitlewithtitle:@"Attendance"];
            }else{
                if (showMakeupSection) {
                    return [MyClass returntitlewithtitle:@"Makeup"];
                }else{
                    return nil;
                }
            }
        }
    }else if (tableView==LessonNumberTable){
        return [MyClass returntitlewithtitle:@"Lesson"];
    }else{
        return nil;
    }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tableView==ClassPopoverTable) {
        if ([ClassTableMode isEqualToString:@"View"]) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (indexPath.section==0 ) {
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Subject"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 7, 207, 21)];
                    ClassLabel.font=[UIFont systemFontOfSize:15];
                    ClassLabel.textColor=[UIColor darkGrayColor];
                    ClassLabel.textAlignment=NSTextAlignmentRight;
                    ClassLabel.text=[MyClass returnsubjectnamewithsubject_shortname:workingClass.subject centerkey:globalvariables.centerrecord.centerkey];
                    ClassLabel.minimumScaleFactor=0.7;
                    ClassLabel.adjustsFontSizeToFitWidth=YES;
                    ClassLabel.tag=302;
                    [cell.contentView addSubview:ClassLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 157, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Level"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    LevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    LevelLabel.font=[UIFont systemFontOfSize:15];
                    LevelLabel.textColor=[UIColor darkGrayColor];
                    LevelLabel.textAlignment=NSTextAlignmentRight;

                    
                    LevelLabel.text=tmpLevel;
                    LevelLabel.tag=303;
                    [cell.contentView addSubview:LevelLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==2){
                    if(globalvariables.centerrecord.enablelessonnumber){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 157, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Lesson"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        LevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                        LevelLabel.font=[UIFont systemFontOfSize:15];
                        LevelLabel.textColor=[UIColor darkGrayColor];
                        LevelLabel.textAlignment=NSTextAlignmentRight;

                        if (![MyClass showLessonParameterWithSubject:workingClass.subject]) {
                            LevelLabel.text=[MyClass returntitlewithtitle:@"NA"];
                        }else{
                            LevelLabel.text=[workingClass.lesson isEqualToString:@""]?[MyClass returntitlewithtitle:@"None"]:[MyClass getLessonDescriptionWithLessonNumber:workingClass.lesson subject:workingClass.subject];
                        }
                        
                        LevelLabel.tag=303;
                        [cell.contentView addSubview:LevelLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.hidden=NO;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==3){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 100, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Date/Time"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StartDateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 7, 192, 21)];
                    StartDateTimeLabel.font=[UIFont systemFontOfSize:15];
                    StartDateTimeLabel.textColor=[UIColor darkGrayColor];
                    StartDateTimeLabel.textAlignment=NSTextAlignmentRight;
                    

                    StartDateTimeLabel.text=[self returndatestringwithdate:workingClass.startdate time:workingClass.classtime];
                    
                    StartDateTimeLabel.tag=304;
                    [cell.contentView addSubview:StartDateTimeLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==4){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Class Day"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                    ClassDayLabel.font=[UIFont systemFontOfSize:15];
                    ClassDayLabel.textColor=[UIColor darkGrayColor];
                    ClassDayLabel.textAlignment=NSTextAlignmentRight;
                    ClassDayLabel.text=[MyClass convertDateFormatWithDate:workingClass.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE" Translate:YES];
                    ClassDayLabel.tag=305;
                    [cell.contentView addSubview:ClassDayLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==5){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Instructor"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    InstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                    InstructorLabel.font=[UIFont systemFontOfSize:15];
                    InstructorLabel.textColor=[UIColor darkGrayColor];
                    InstructorLabel.textAlignment=NSTextAlignmentRight;
                    InstructorLabel.text=[workingClass.instructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:workingClass.instructor firstorfullname:@"full"];
                    InstructorLabel.tag=307;
                    [cell.contentView addSubview:InstructorLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==6){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Sec. Instructor"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    InstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                    InstructorLabel.font=[UIFont systemFontOfSize:15];
                    InstructorLabel.textColor=[UIColor darkGrayColor];
                    InstructorLabel.textAlignment=NSTextAlignmentRight;
                    InstructorLabel.text=[workingClass.sinstructor isEqualToString:@"TBD"] || [workingClass.sinstructor isEqualToString:@""]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:workingClass.sinstructor firstorfullname:@"full"];
                    InstructorLabel.tag=307;
                    [cell.contentView addSubview:InstructorLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.hidden=!globalvariables.centerrecord.secondaryinstructor;
                    
                }else if (indexPath.row==7){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Classroom"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                    ClassroomLabel.font=[UIFont systemFontOfSize:15];
                    ClassroomLabel.textColor=[UIColor darkGrayColor];
                    ClassroomLabel.textAlignment=NSTextAlignmentRight;
                    ClassroomLabel.text= [workingClass.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:workingClass.classroom;
                    ClassroomLabel.tag=307;
                    [cell.contentView addSubview:ClassroomLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
            }else if (indexPath.section==1){
                
                static NSString *CellIdentifier = @"viewremarkscell";
                MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cell.textview1.tag=indexPath.section;
                cell.textview1.text=workingClass.remarks;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                /*
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                GeneralLabel.font=[UIFont systemFontOfSize:17];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Class Remarks"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                ClassRemarksLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 28, 280, 68)];
                ClassRemarksLabel.font=[UIFont systemFontOfSize:15];
                ClassRemarksLabel.textColor=[UIColor darkGrayColor];
                ClassRemarksLabel.textAlignment=NSTextAlignmentLeft;
                ClassRemarksLabel.text=workingClass.remarks;
                ClassRemarksLabel.tag=308;
                ClassRemarksLabel.numberOfLines=0;
                [cell.contentView addSubview:ClassRemarksLabel];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;*/
            
            }else if (indexPath.section==2){
                static NSString *CellIdentifier = @"viewremarkscell";
                MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cell.textview1.tag=indexPath.section;
                cell.textview1.text=workingClass.allclassremarks;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;
                
            
            }else if (indexPath.section==3){
                
                if (workingClass.voiceparentnotemessage.photoarray.count>0) {
                    static NSString *CellIdentifier = @"parentnoteaudiocell";
                    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil) {
                        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    UIImage *image=[self imageWithImage:[UIImage imageNamed:@"slider_thumb.png"] scaledToSize:CGSizeMake(12, 12)];
                    [cell.slider1 setThumbImage:image forState:UIControlStateNormal];
                    cell.slider1.tag=indexPath.section;
                    [cell.slider1 addTarget:self action:@selector(audioSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.slider1.value=0;
                    cell.button4.tag=indexPath.section;
                    [cell.button4 addTarget:self action:@selector(playAudioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
                    
                    if (workingClass.voiceparentnotemessage.messagestarttime) {
                        cell.label3.text=[MyClass returnMessageTimeWithMessageStartTime:workingClass.voiceparentnotemessage.messagestarttime];
                        cell.label3.text=[NSString stringWithFormat:@"%@ / %@",cell.label3.text,[MyClass returnDurationWithSecond:((MessagePhotoRecord *)[workingClass.voiceparentnotemessage.photoarray firstObject]).height]];
                    }else{
                        cell.label3.text=[MyClass returnDurationWithSecond:((MessagePhotoRecord *)[workingClass.voiceparentnotemessage.photoarray firstObject]).height];
                    }
                    
                    cell.button1.hidden=YES;

                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }else{
                
                    static NSString *CellIdentifier = @"viewremarkscell";
                    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil) {
                        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    cell.textview1.tag=indexPath.section;
                    cell.textview1.text=workingClass.parentnote;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                
                }
            }else if (indexPath.section==4){
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Attendance"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    AbsentLabel = [[UILabel alloc]initWithFrame:CGRectMake(112, 5, 175, 21)];
                    AbsentLabel.font=[UIFont systemFontOfSize:15];
                    AbsentLabel.textColor=[UIColor darkGrayColor];
                    AbsentLabel.textAlignment=NSTextAlignmentRight;
                    AbsentLabel.text=[MyClass returntitlewithtitle:[NSString stringWithFormat:@"attendance_%@",workingClass.attendance]];
                    AbsentLabel.tag=310;
                    [cell.contentView addSubview:AbsentLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Nature"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                    ClassroomLabel.font=[UIFont systemFontOfSize:15];
                    ClassroomLabel.textColor=[UIColor darkGrayColor];
                    ClassroomLabel.textAlignment=NSTextAlignmentRight;
                    ClassroomLabel.text= [MyClass returnLeaveNatureNameWithLeaveNatureListKey:workingClass.leavenaturelistkey];
                    [cell.contentView addSubview:ClassroomLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    cell.hidden=YES;
                    
                }else if (indexPath.row==2){
                    if (showMakeupRemarks==YES) {
                        
                        static NSString *CellIdentifier = @"viewremarkscell";
                        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (cell == nil) {
                            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        
                        cell.textview1.tag=indexPath.section;
                        cell.textview1.text=workingClass.absentmakeupreason;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                        
                        /*
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Remarks"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        absentMakeupReasonLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 28, 280, 68)];
                        absentMakeupReasonLabel.font=[UIFont systemFontOfSize:15];
                        absentMakeupReasonLabel.textColor=[UIColor darkGrayColor];
                        absentMakeupReasonLabel.textAlignment=NSTextAlignmentLeft;
                        absentMakeupReasonLabel.numberOfLines=0;
                        absentMakeupReasonLabel.text=workingClass.absentmakeupreason;
                        absentMakeupReasonLabel.tag=314;
                        [cell.contentView addSubview:absentMakeupReasonLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;*/
                    }else{
                        cell.hidden=YES;
                    }
                }
            }else if (indexPath.section==5){
                if (indexPath.row==0){
                    if (showMakeupSection==YES) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Date/Time"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        MakeupDateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 7, 192, 21)];
                        MakeupDateTimeLabel.font=[UIFont systemFontOfSize:15];
                        MakeupDateTimeLabel.textColor=[UIColor darkGrayColor];
                        MakeupDateTimeLabel.textAlignment=NSTextAlignmentRight;
                        
                        //MakeupDateTimeLabel.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:tmpMakeupDateTime];
                        MakeupDateTimeLabel.text=[self returndatestringwithdate:workingClass.makeupdate time:workingClass.makeuptime];
                        MakeupDateTimeLabel.tag=312;
                        [cell.contentView addSubview:MakeupDateTimeLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }else{
                        cell.hidden=YES;
                    }
                    
                    
                }else if (indexPath.row==1){
                    if (showMakeupSection==YES) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Instructor"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        MakeupInstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 167, 21)];
                        MakeupInstructorLabel.font=[UIFont systemFontOfSize:15];
                        MakeupInstructorLabel.textColor=[UIColor darkGrayColor];
                        MakeupInstructorLabel.textAlignment=NSTextAlignmentRight;
                        MakeupInstructorLabel.text=([workingClass.makeupinstructor isEqualToString:@"TBD"] || [workingClass.makeupinstructor isEqualToString:@""])?[MyClass returntitlewithtitle:workingClass.makeupinstructor]:[MyClass returninstructornamewithusername:workingClass.makeupinstructor firstorfullname:@"full"];
                        MakeupInstructorLabel.tag=313;
                        [cell.contentView addSubview:MakeupInstructorLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==2){
                    if (showMakeupSection==YES && globalvariables.centerrecord.secondaryinstructor) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Sec. Instructor"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        MakeupInstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 167, 21)];
                        MakeupInstructorLabel.font=[UIFont systemFontOfSize:15];
                        MakeupInstructorLabel.textColor=[UIColor darkGrayColor];
                        MakeupInstructorLabel.textAlignment=NSTextAlignmentRight;
                        MakeupInstructorLabel.text=([workingClass.makeupsinstructor isEqualToString:@"TBD"] || [workingClass.makeupsinstructor isEqualToString:@""])?[MyClass returntitlewithtitle:workingClass.makeupsinstructor]:[MyClass returninstructornamewithusername:workingClass.makeupsinstructor firstorfullname:@"full"];
                        MakeupInstructorLabel.tag=313;
                        [cell.contentView addSubview:MakeupInstructorLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==3){
                    if (showMakeupSection==YES) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Classroom"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        MakeupClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                        MakeupClassroomLabel.font=[UIFont systemFontOfSize:15];
                        MakeupClassroomLabel.textColor=[UIColor darkGrayColor];
                        MakeupClassroomLabel.textAlignment=NSTextAlignmentRight;
                        MakeupClassroomLabel.text=([workingClass.makeupclassroom isEqualToString:@"TBD"] || [workingClass.makeupclassroom isEqualToString:@""])?[MyClass returntitlewithtitle:workingClass.makeupclassroom]:workingClass.makeupclassroom;
                        MakeupClassroomLabel.tag=313;
                        [cell.contentView addSubview:MakeupClassroomLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==4) {
                    if (showMakeupSection==YES) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Attendance"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        AbsentLabel = [[UILabel alloc]initWithFrame:CGRectMake(112, 5, 175, 21)];
                        AbsentLabel.font=[UIFont systemFontOfSize:15];
                        AbsentLabel.textColor=[UIColor darkGrayColor];
                        AbsentLabel.textAlignment=NSTextAlignmentRight;
                        if ([workingClass.makeupattendance isEqualToString:@"Absent"]) {
                            AbsentLabel.text=[MyClass returntitlewithtitle:[NSString stringWithFormat:@"attendance_%@",workingClass.makeupattendance]];
                        }else{
                            AbsentLabel.text=[workingClass.makeupdate isEqualToString:@""]?@"":[MyClass returntitlewithtitle:[NSString stringWithFormat:@"attendance_%@",workingClass.makeupattendance]];
                        }
                        
                        AbsentLabel.tag=310;
                        [cell.contentView addSubview:AbsentLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }
            }else if (indexPath.section==6){
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 280, 21)];
                GeneralLabel.font=[UIFont systemFontOfSize:12];
                GeneralLabel.textColor=[UIColor darkGrayColor];
                GeneralLabel.textAlignment=NSTextAlignmentCenter;
                GeneralLabel.text=[NSString stringWithFormat:@"CLASS ID: %@",PopoverClass.classkey];
                GeneralLabel.tag=301;
                cell.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:GeneralLabel];
            }

        }else if([ClassTableMode isEqualToString:@"Edit"]){
            
            //if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (indexPath.section==0 ) {
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Subject"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 7, 207, 21)];
                    ClassLabel.font=[UIFont systemFontOfSize:15];
                    ClassLabel.textColor=[UIColor darkGrayColor];
                    ClassLabel.textAlignment=NSTextAlignmentRight;
                    ClassLabel.text=[MyClass returnsubjectnamewithsubject_shortname:workingClass.subject centerkey:globalvariables.centerrecord.centerkey];
                    ClassLabel.tag=302;
                    ClassLabel.minimumScaleFactor=0.7;
                    ClassLabel.adjustsFontSizeToFitWidth=YES;
                    [cell.contentView addSubview:ClassLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 157, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Level"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    LevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    LevelLabel.font=[UIFont systemFontOfSize:15];
                    LevelLabel.textColor=[UIColor darkGrayColor];
                    LevelLabel.textAlignment=NSTextAlignmentRight;
                    LevelLabel.text=tmpLevel;
                    LevelLabel.tag=303;
                    [cell.contentView addSubview:LevelLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else if (indexPath.row==2){
                    if (showLevelPicker==YES) {
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        if ([MyClass isEyeLevelMathWithSubject:workingClass.subject]) {
                                if ([PopoverClass.levelmain isEqualToString:@"TBD"]) {
                                    self.levelmainPickerViewMenu = [NSMutableArray arrayWithObjects:@"DT",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",nil];
                                }else{
                                    self.levelmainPickerViewMenu = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",nil];
                                }
                                
                                if ([tmpLevel isEqualToString:@"TBD"] || [tmpLevel isEqualToString:@"DT"]) {
                                    if (![self.levelmainPickerViewMenu containsObject:tmpLevel]) {
                                        [self.levelmainPickerViewMenu insertObject:tmpLevel atIndex:0];
                                    }
                                    
                                }
                                
                                self.levelctmPickerViewMenu = [NSMutableArray arrayWithObjects:@"",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",nil];
                                
                                //extract levelmain and levelctm from tmpLevel
                                NSString *tmplevelmain;
                                NSString *tmplevelctm;
                                
                                if ([tmpLevel isEqualToString:@"TBD"] || [tmpLevel isEqualToString:@"DT"]) {
                                    tmplevelmain=tmpLevel;
                                    tmplevelctm=@"";
                                    [myPicker selectRow:(int)[self.levelmainPickerViewMenu indexOfObject:tmplevelmain] inComponent:0 animated:NO];
                                    //[myPicker selectRow:(int)[self.levelctmPickerViewMenu indexOfObject:tmplevelctm] inComponent:1 animated:NO];
                                    
                                }else{
                                    NSRange range=[tmpLevel rangeOfString:@"/"];
                                    if (range.location==NSNotFound) {
                                        tmplevelmain=[tmpLevel substringFromIndex:3];
                                        tmplevelctm=@"";
                                        [myPicker selectRow:(int)[self.levelmainPickerViewMenu indexOfObject:tmplevelmain] inComponent:0 animated:NO];
                                        
                                    }else{
                                        tmplevelmain=[tmpLevel substringWithRange:NSMakeRange(3, range.location-3)];
                                        tmplevelctm=[tmpLevel substringFromIndex:range.location+4];
                                        
                                        [myPicker selectRow:(int)[self.levelmainPickerViewMenu indexOfObject:tmplevelmain] inComponent:0 animated:NO];
                                        [myPicker selectRow:(int)[self.levelctmPickerViewMenu indexOfObject:tmplevelctm] inComponent:1 animated:NO];
                                    }
                                }
                        }else{
//                            self.pickerViewmenu = [NSMutableArray arrayWithArray:((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingClass.subject centerkey:globalvariables.centerrecord.centerkey]).levelArray];
                            
                            
                            self.pickerViewmenu=[MyClass returnLevelOnlyArrayWithSubject:workingClass.subject];
                            if (![self.pickerViewmenu containsObject:tmpLevel]) {
                                [self.pickerViewmenu insertObject:tmpLevel atIndex:0];
                            }
                            
                            presetRow=(int)[self.pickerViewmenu indexOfObject:tmpLevel];
                            [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        }
                        
                        [myPicker setShowsSelectionIndicator:YES];
                        self.myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        [cell.contentView addSubview:datepickerview];
                        
                    }else{
                        cell.hidden=YES;
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    

                    
                }else if (indexPath.row==3){
                    
                    if (globalvariables.centerrecord.enablelessonnumber) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 120, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Lesson"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        StartDateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 7, 212, 21)];
                        StartDateTimeLabel.font=[UIFont systemFontOfSize:15];
                        StartDateTimeLabel.textColor=[UIColor darkGrayColor];
                        StartDateTimeLabel.textAlignment=NSTextAlignmentRight;
                        
                        if (![MyClass showLessonParameterWithSubject:workingClass.subject]) {
                            StartDateTimeLabel.text=[MyClass returntitlewithtitle:@"NA"];
                            cell.accessoryType=UITableViewCellAccessoryNone;
                            cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        }else{
                            StartDateTimeLabel.text=[workingClass.lesson isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass getLessonDescriptionWithLessonNumber:workingClass.lesson subject:workingClass.subject];
                            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        }

                        StartDateTimeLabel.tag=304;
                        [cell.contentView addSubview:StartDateTimeLabel];
                        
                        
                    }else{
                        cell.hidden=YES;
                    }
                    
                }else if (indexPath.row==4){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 120, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Date/Time"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StartDateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, 7, 212, 21)];
                    StartDateTimeLabel.font=[UIFont systemFontOfSize:15];
                    StartDateTimeLabel.textColor=[UIColor darkGrayColor];
                    StartDateTimeLabel.textAlignment=NSTextAlignmentRight;
                    
                    StartDateTimeLabel.text=[self returndatestringwithdate:workingClass.startdate time:workingClass.classtime];

                    StartDateTimeLabel.tag=304;
                    [cell.contentView addSubview:StartDateTimeLabel];
                    
                    if (([((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingClass.subject centerkey:globalvariables.centerrecord.centerkey]).tuition_mode isEqualToString:@"Month"] || globalvariables.centerrecord.editmonthlycourseclassdate)) {
                        if (globalvariables.centerrecord.editmonthlycourseclassdate) {
                            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        }else{
                            cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        }
                    }else{
                            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                }else if (indexPath.row==5){
                    if (showDatePicker==YES) {
                        
                        
                        CalendarView *calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, 320, 200) Theme:0 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:![self editPaidEnrollment]];
                        [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:workingClass.startdate,nil] ScrollToDate:nil instructorselected:nil];
                        calendarview.delegate=self;

                        [cell.contentView addSubview:calendarview];
                        
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 162)];
                        myPicker.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.03];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=801;
                        
                        [myPicker setShowsSelectionIndicator:YES];
                        self.myPickerView=myPicker;
                        [cell.contentView addSubview:myPicker];
                        
                        if ([workingClass.startdate length]+[workingClass.classtime length]==16) {
                            hourPresetRow=(int)[hourPickerViewMenu indexOfObject:[workingClass.classtime substringToIndex:2]];
                            minutePresetRow=(int)[minutePickerViewMenu indexOfObject:[workingClass.classtime substringFromIndex:3]];
                            [myPicker selectRow:hourPresetRow inComponent:0 animated:NO];
                            [myPicker selectRow:minutePresetRow inComponent:1 animated:NO];
                        }

                        UIButton *setTBDbutton=[[UIButton alloc]init];
                        setTBDbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        setTBDbutton.frame=CGRectMake(218, ((CGRect)[tableView rectForRowAtIndexPath:indexPath]).size.height-32, 100, 30);
                        setTBDbutton.titleLabel.font=[UIFont systemFontOfSize:14];
                        [setTBDbutton setTitle:[MyClass returntitlewithtitle:@"Reset TBD"] forState:UIControlStateNormal];
                        [setTBDbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                        setTBDbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        [setTBDbutton addTarget: self action:@selector(setTBDDatebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                        setTBDbutton.tag=702;
                        [cell.contentView addSubview:setTBDbutton];
                    }else{
                        cell.hidden=YES;
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==6){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Class Day"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                    ClassDayLabel.font=[UIFont systemFontOfSize:15];
                    ClassDayLabel.textColor=[UIColor darkGrayColor];
                    ClassDayLabel.textAlignment=NSTextAlignmentRight;

                    ClassDayLabel.text=[MyClass convertDateFormatWithDate:workingClass.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE" Translate:YES];
                    
                    ClassDayLabel.tag=305;
                    [cell.contentView addSubview:ClassDayLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==7){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Instructor"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    InstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 167, 21)];
                    InstructorLabel.font=[UIFont systemFontOfSize:15];
                    InstructorLabel.textColor=[UIColor darkGrayColor];
                    InstructorLabel.textAlignment=NSTextAlignmentRight;

                    InstructorLabel.text=[workingClass.instructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:workingClass.instructor]:[MyClass returninstructornamewithusername:workingClass.instructor firstorfullname:@"full"];

                    InstructorLabel.tag=307;
                    [cell.contentView addSubview:InstructorLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else if (indexPath.row==8){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Sec. Instructor"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    InstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 5, 167, 21)];
                    InstructorLabel.font=[UIFont systemFontOfSize:15];
                    InstructorLabel.textColor=[UIColor darkGrayColor];
                    InstructorLabel.textAlignment=NSTextAlignmentRight;

                    InstructorLabel.text=([workingClass.sinstructor isEqualToString:@"TBD"]||[workingClass.sinstructor isEqualToString:@""])?[MyClass returntitlewithtitle:workingClass.sinstructor]:[MyClass returninstructornamewithusername:workingClass.sinstructor firstorfullname:@"full"];

                    InstructorLabel.tag=307;
                    [cell.contentView addSubview:InstructorLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                    cell.hidden=!globalvariables.centerrecord.secondaryinstructor;
                    
                }else if (indexPath.row==9){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Classroom"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                    ClassroomLabel.font=[UIFont systemFontOfSize:15];
                    ClassroomLabel.textColor=[UIColor darkGrayColor];
                    ClassroomLabel.textAlignment=NSTextAlignmentRight;
                    
                    ClassroomLabel.text=[workingClass.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:workingClass.classroom]:workingClass.classroom;
                    
                    ClassroomLabel.tag=307;
                    [cell.contentView addSubview:ClassroomLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }
            }else if (indexPath.section==1){
                
                static NSString *CellIdentifier = @"remarkscell";
                MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cell.textview1.tag=indexPath.section;
                cell.textview1.text=workingClass.remarks;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

            }else if (indexPath.section==2){
                
                static NSString *CellIdentifier = @"remarkscell";
                MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cell.textview1.tag=indexPath.section;
                cell.textview1.text=workingClass.allclassremarks;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return cell;

            }else if (indexPath.section==3){
                if (workingClass.voiceparentnotemessage.photoarray.count>0) {
                    static NSString *CellIdentifier = @"parentnoteaudiocell";
                    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil) {
                        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    UIImage *image=[self imageWithImage:[UIImage imageNamed:@"slider_thumb.png"] scaledToSize:CGSizeMake(12, 12)];
                    [cell.slider1 setThumbImage:image forState:UIControlStateNormal];
                    cell.slider1.tag=indexPath.section;
                    [cell.slider1 addTarget:self action:@selector(audioSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                    cell.slider1.value=0;
                    cell.button4.tag=indexPath.section;
                    [cell.button4 addTarget:self action:@selector(playAudioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                    [cell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
                    
                    if (workingClass.voiceparentnotemessage.messagestarttime) {
                        cell.label3.text=[MyClass returnMessageTimeWithMessageStartTime:workingClass.voiceparentnotemessage.messagestarttime];
                        cell.label3.text=[NSString stringWithFormat:@"%@ / %@",cell.label3.text,[MyClass returnDurationWithSecond:((MessagePhotoRecord *)[workingClass.voiceparentnotemessage.photoarray firstObject]).height]];
                    }else{
                        cell.label3.text=[MyClass returnDurationWithSecond:((MessagePhotoRecord *)[workingClass.voiceparentnotemessage.photoarray firstObject]).height];
                    }
                    
                    cell.button1.hidden=NO;
                    [cell.button1 addTarget:self action:@selector(deleteAudioParentNote:) forControlEvents:UIControlEventTouchUpInside];

                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }else{
                    static NSString *CellIdentifier = @"parentnotecell";
                    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (cell == nil) {
                        cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    cell.textview1.tag=indexPath.section;
                    textinputbox=cell.view1;
                    [textinputbox addGestureRecognizer:audioPanGesture];
                    recordingStatusView=cell.view2;
                    audioRecordingImage=cell.imageview1;
                    recordingDuration=cell.label1;
                    slideToCancelTitle=cell.label2;
                    slideToCancelTitle.text=[MyClass returntitlewithtitle:@"Release here to cancel"];
                    
                    cell.textview1.text=workingClass.parentnote;
                    
                    cell.button1.hidden=!globalvariables.centerrecord.enablevoicemessage  || !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendvoicemessage;
                    
                    [cell.button1 addTarget:self action:@selector(startAudioRecording:) forControlEvents:UIControlEventTouchDown];
                    [cell.button1 addTarget:self action:@selector(stopAudioRecording:) forControlEvents:UIControlEventTouchUpInside];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    return cell;
                }
            
            }else if (indexPath.section==4){
                if (indexPath.row==0) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Attendance"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    UIButton *AttendanceButton=[[UIButton alloc]initWithFrame:CGRectMake(249, 1.5, 32, 32)];
                    [AttendanceButton addTarget: self action:@selector(attendancebuttontouchupinside:) forControlEvents: UIControlEventTouchUpInside];
                    [AttendanceButton addTarget: self action:@selector(attendancebuttontouchdown:) forControlEvents: UIControlEventTouchDown];
                    AttendanceButton.tag=-121;
                    [cell.contentView addSubview:AttendanceButton];
                    
                    [AttendanceButton setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:@"Class" attendance:workingClass.attendance makeupattendance:nil]] forState:UIControlStateNormal];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Nature"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                    ClassroomLabel.font=[UIFont systemFontOfSize:15];
                    ClassroomLabel.textColor=[UIColor darkGrayColor];
                    ClassroomLabel.textAlignment=NSTextAlignmentRight;
                    ClassroomLabel.text= [MyClass returnLeaveNatureNameWithLeaveNatureListKey:workingClass.leavenaturelistkey];
                    [cell.contentView addSubview:ClassroomLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                    cell.hidden=YES;
                    
                }else if (indexPath.row==2){
                    if (showMakeupRemarks==YES) {
                        
                        static NSString *CellIdentifier = @"remarkscell";
                        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (cell == nil) {
                            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        
                        cell.textview1.tag=indexPath.section;
                        cell.textview1.text=workingClass.absentmakeupreason;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        return cell;
                    }else{
                        cell.hidden=YES;
                    }
                }
            }else if (indexPath.section==5){
                if (indexPath.row==0){
                    if (showMakeupSection) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Date/Time"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        MakeupDateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 7, 182, 21)];
                        MakeupDateTimeLabel.font=[UIFont systemFontOfSize:15];
                        MakeupDateTimeLabel.textColor=[UIColor darkGrayColor];
                        MakeupDateTimeLabel.textAlignment=NSTextAlignmentRight;
                        
                        //MakeupDateTimeLabel.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:tmpMakeupDateTime];
                        MakeupDateTimeLabel.text=[self returndatestringwithdate:workingClass.makeupdate time:workingClass.makeuptime];
                        MakeupDateTimeLabel.tag=312;
                        [cell.contentView addSubview:MakeupDateTimeLabel];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        
                    }else{
                        cell.hidden=YES;
                    }
                    
                }else if (indexPath.row==1){
                    if (showMakeupSection && showMakeupDateTimePicker) {
                        
                        CalendarView *calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, 320, 200) Theme:0 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
                        [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:workingClass.makeupdate,nil] ScrollToDate:nil instructorselected:nil];
                        calendarview.delegate=self;

                        [cell.contentView addSubview:calendarview];
                        
                        
                        
                        //UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 280, 200)];
                        //UIView *timetable=[[UIView alloc]initWithFrame:CGRectMake(0, 160,310, 30)];
                        //[datepickerview addSubview:timetable];
                        
                        /*
                        UIButton *timetablebutton=[[UIButton alloc]initWithFrame:CGRectMake(20, ((CGRect)[tableView rectForRowAtIndexPath:indexPath]).size.height-28, 24, 24)];
                        timetablebutton.layer.cornerRadius=5;
                        timetablebutton.layer.masksToBounds=YES;
                        timetablebutton.layer.borderColor=[UIColor grayColor].CGColor;
                        timetablebutton.layer.borderWidth=0.5;
                        [timetablebutton setImage:[UIImage imageNamed:@"classtimetable_icon.png"] forState:UIControlStateNormal];
                        [timetablebutton addTarget: self action:@selector(timetableButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
                        timetablebutton.tag=702;
                        [cell.contentView addSubview:timetablebutton];*/
                        
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 162)];
                        myPicker.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.03];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=801;
                        
                        [myPicker setShowsSelectionIndicator:YES];
                        self.myPickerView=myPicker;
                        [cell.contentView addSubview:myPicker];
                        
                        if ([workingClass.makeupdate length]+[workingClass.makeuptime length]==16) {
                            
                            //datePresetRow=(int)[datePickerViewMenu indexOfObject:[tmpStartDateTime substringToIndex:11]];
                            //datePresetRow=[MyClass returnDateOffsetWithDate:[MyClass convertToNSDateWithDate:[tmpStartDateTime substringToIndex:11] DateFormat:@"dd-MMM-yyyy"]];
                            hourPresetRow=(int)[hourPickerViewMenu indexOfObject:[workingClass.makeuptime substringToIndex:2]];
                            minutePresetRow=(int)[minutePickerViewMenu indexOfObject:[workingClass.makeuptime substringFromIndex:3]];
                            
                            //[myPicker selectRow:datePresetRow inComponent:0 animated:NO];
                            [myPicker selectRow:hourPresetRow inComponent:0 animated:NO];
                            [myPicker selectRow:minutePresetRow inComponent:1 animated:NO];
                        }
                        
                        
                        UIButton *setTBDbutton=[[UIButton alloc]init];
                        setTBDbutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                        setTBDbutton.frame=CGRectMake(218, ((CGRect)[tableView rectForRowAtIndexPath:indexPath]).size.height-32, 100, 30);
                        setTBDbutton.titleLabel.font=[UIFont systemFontOfSize:14];
                        [setTBDbutton setTitle:[MyClass returntitlewithtitle:@"Reset TBD"] forState:UIControlStateNormal];
                        [setTBDbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                        setTBDbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                        [setTBDbutton addTarget: self action:@selector(resetButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
                        setTBDbutton.tag=702;
                        [cell.contentView addSubview:setTBDbutton];
                        

                    }else{
                        cell.hidden=YES;
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==2){
                    if (showMakeupSection==YES) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Instructor"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        MakeupInstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                        MakeupInstructorLabel.font=[UIFont systemFontOfSize:15];
                        MakeupInstructorLabel.textColor=[UIColor darkGrayColor];
                        MakeupInstructorLabel.textAlignment=NSTextAlignmentRight;
                        
                        MakeupInstructorLabel.text=([workingClass.makeupinstructor isEqualToString:@"TBD"]||[workingClass.makeupinstructor isEqualToString:@""])?[MyClass returntitlewithtitle:workingClass.makeupinstructor]:[MyClass returninstructornamewithusername:workingClass.makeupinstructor firstorfullname:@"full"];
                        
                        MakeupInstructorLabel.tag=313;
                        [cell.contentView addSubview:MakeupInstructorLabel];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.hidden=YES;
                    }
                    
                    
                    
                    
                }else if (indexPath.row==3){
                    if (showMakeupSection==YES && globalvariables.centerrecord.secondaryinstructor) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Sec. Instructor"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        MakeupInstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                        MakeupInstructorLabel.font=[UIFont systemFontOfSize:15];
                        MakeupInstructorLabel.textColor=[UIColor darkGrayColor];
                        MakeupInstructorLabel.textAlignment=NSTextAlignmentRight;
                        
                        MakeupInstructorLabel.text=([workingClass.makeupsinstructor isEqualToString:@"TBD"]||[workingClass.makeupsinstructor isEqualToString:@""])?[MyClass returntitlewithtitle:workingClass.makeupsinstructor]:[MyClass returninstructornamewithusername:workingClass.makeupsinstructor firstorfullname:@"full"];
                        
                        MakeupInstructorLabel.tag=313;
                        [cell.contentView addSubview:MakeupInstructorLabel];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.hidden=YES;
                    }
                    
                    
                    
                    
                }else if (indexPath.row==4){
                    if (showMakeupSection==YES) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Classroom"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        MakeupClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                        MakeupClassroomLabel.font=[UIFont systemFontOfSize:15];
                        MakeupClassroomLabel.textColor=[UIColor darkGrayColor];
                        MakeupClassroomLabel.textAlignment=NSTextAlignmentRight;
                        
                        MakeupClassroomLabel.text=([workingClass.makeupclassroom isEqualToString:@"TBD"]||[workingClass.makeupclassroom isEqualToString:@""])?[MyClass returntitlewithtitle:workingClass.makeupclassroom]:workingClass.makeupclassroom;
                        
                        MakeupClassroomLabel.tag=313;
                        [cell.contentView addSubview:MakeupClassroomLabel];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.hidden=YES;
                    }
                    
                    
                    
                    
                }else if (indexPath.row==5) {
                    if (showMakeupSection) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Attendance"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        UIButton *AttendanceButton=[[UIButton alloc]initWithFrame:CGRectMake(249, 1.5, 32, 32)];
                        [AttendanceButton addTarget: self action:@selector(attendancebuttontouchupinside:) forControlEvents: UIControlEventTouchUpInside];
                        [AttendanceButton addTarget: self action:@selector(attendancebuttontouchdown:) forControlEvents: UIControlEventTouchDown];
                        AttendanceButton.tag=-121;
                        [cell.contentView addSubview:AttendanceButton];
                        
                        [AttendanceButton setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:@"Class" attendance:workingClass.makeupattendance makeupattendance:nil]] forState:UIControlStateNormal];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }
            }
        }
    }else if (tableView==InstructorTable){
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
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
        
        NSString *username;
        if ([selectedItem isEqualToString:@"Instructor"]) {
            username=workingClass.instructor;
        }else if ([selectedItem isEqualToString:@"SInstructor"]) {
            username=workingClass.sinstructor;
        }else if ([selectedItem isEqualToString:@"MakeupInstructor"]) {
            username=workingClass.makeupinstructor;
        }else if ([selectedItem isEqualToString:@"MakeupSInstructor"]) {
            username=workingClass.makeupsinstructor;
        }
        
        ITInstructorname.text=[MyClass returninstructornamewithusername:((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username firstorfullname:@"full"];
        ITInstructorselected.hidden=[((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username isEqualToString:username]?NO:YES;

    }else if (tableView==ClassroomTable){
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
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
        ITInstructorname.text=[((ClassroomRecord *)[FilteredClassroomArray objectAtIndex:indexPath.row]).classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:((ClassroomRecord *)[FilteredClassroomArray objectAtIndex:indexPath.row]).classroom;
        ITInstructorselected.hidden=[((ClassroomRecord *)[FilteredClassroomArray objectAtIndex:indexPath.row]).classroom isEqualToString:[selectedItem isEqualToString:@"Classroom"]?workingClass.classroom:workingClass.makeupclassroom]?NO:YES;
        
    }else if (tableView==NatureTable){
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            //add textfield
            ITInstructorname = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, naturetablewidth-30, 38)];
            ITInstructorname.font=[UIFont systemFontOfSize:15];
            ITInstructorname.textColor=[UIColor darkGrayColor];
            ITInstructorname.tag=1301;
            [cell.contentView addSubview:ITInstructorname];
            
            ITInstructorselected = [[UIImageView alloc]initWithFrame:CGRectMake(naturetablewidth-45, 7, 24, 24)];
            [ITInstructorselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            ITInstructorselected.tag=1302;
            [cell.contentView addSubview:ITInstructorselected];
        }else{
            ITInstructorname=(UILabel *)[cell.contentView viewWithTag:1301];
            ITInstructorselected=(UIImageView *)[cell.contentView viewWithTag:1302];
        }
        ITInstructorname.text=[MyClass returnLeaveNatureNameWithLeaveNatureListKey:((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:indexPath.row]).leavenaturelistkey];
        ITInstructorselected.hidden=[((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:indexPath.row]).leavenaturelistkey isEqualToString:workingClass.leavenaturelistkey]?NO:YES;
        
    }else if (tableView==LessonNumberTable){
        MyTableViewCell *cell;
        if (globalvariables.centerrecord.lessonnumbermode==2) {
            static NSString *CellIdentifier= @"pickerCell";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            if([selectedItem isEqualToString:@"LessonNumber"]){
                if([workingClass.lesson isEqualToString:@""]){
                    [cell.pickerview1 reloadAllComponents];
                    [cell.pickerview1 selectRow:0 inComponent:0 animated:NO];
                    [cell.pickerview1 selectRow:0 inComponent:1 animated:NO];
                    [cell.pickerview1 selectRow:0 inComponent:2 animated:NO];
                    [cell.pickerview1 selectRow:0 inComponent:3 animated:NO];
                }else{
                    [cell.pickerview1 reloadAllComponents];
                    NSArray *selectedNumber=[workingClass.lesson componentsSeparatedByString:@"/"];
                    NSMutableArray *ln0Array=lessonArray[0];
                    NSMutableArray *ln1Array=lessonArray[1];
                    NSMutableArray *ln2Array=lessonArray[2];
                    NSMutableArray *ln3Array=lessonArray[3];
                    
                    if ([ln0Array containsObject:selectedNumber[0]]) {
                        [cell.pickerview1 selectRow:[ln0Array indexOfObject:selectedNumber[0]] inComponent:0 animated:NO];
                    }

                    if ([ln1Array containsObject:selectedNumber[1]]) {
                        NSInteger index=[ln1Array indexOfObject:selectedNumber[1]];
                        [cell.pickerview1 selectRow:index inComponent:1 animated:NO];
                    }
                    
                    if ([selectedNumber[2] integerValue]<ln2Array.count+1) {
                        [cell.pickerview1 selectRow:[selectedNumber[2] integerValue]-1 inComponent:2 animated:NO];
                    }
                    
                    if ([selectedNumber[3] integerValue]<ln3Array.count+1) {
                        [cell.pickerview1 selectRow:[selectedNumber[3] integerValue]-1 inComponent:3 animated:NO];
                    }
                }
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }else{
            static NSString *CellIdentifier= @"labelCell";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.label1.text=[@(indexPath.row+1) stringValue];
            cell.label2.text=[lessonArray objectAtIndex:indexPath.row];
            cell.imageview1.hidden=![[@(indexPath.row+1) stringValue] isEqualToString:workingClass.lesson];
        }
        

        
        return cell;
    }
    return cell;
}

-(void) clearLessonNumber
{
    workingClass.lesson=@"";
    [ClassPopoverTable reloadData];
    [self closelessonnumbertable];
}

-(NSString *) returndatestringwithdate:(NSString *)date time:(NSString *)time
{
    if([date isEqualToString:@"TBD"] && [time isEqualToString:@"TBD"]){
        return [MyClass returntitlewithtitle:@"TBD"];
    }else if ([date isEqualToString:@"TBD"]){
        return [NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"TBD"],time];
    }else if ([time isEqualToString:@"TBD"]){
        return [NSString stringWithFormat:@"%@ %@",[MyClass returndateformatwithdate:date],[MyClass returntitlewithtitle:@"TBD"]];
    }else{
        return [MyClass returndateformatDDMMMYYYYHHMMwithdate:[NSString stringWithFormat:@"%@ %@",date,time]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //int popActualHeight;
    [self stopAudioPlaying];
    if (tableView==ClassPopoverTable) {
        if (![ClassTableMode isEqualToString:@"View"]) {
            if (indexPath.section==0 && indexPath.row==1) {
                //pickerview for level
                
                selectedItem=@"Level";
                
                if (showLevelPicker==YES) {
                    showLevelPicker=NO;
                }else{
                    showLevelPicker=YES;
                    showDatePicker=NO;
                    //showInstructorPicker=NO;
                    showMakeupDateTimePicker=NO;
                    //showMakeupInstructorPicker=NO;
                    //showMakeupClassroomPicker=NO;
                    //showClassroomPicker=NO;
                    //showInstructorTable=NO;
                }
                [self showsidewindowwithwindow:@"none"];
                //[self storeTmpField];
                [ClassPopoverTable reloadData];
                
                [self adjusttablesize];

            }else if (indexPath.section==0 && indexPath.row==4) {
                //pickerview for date/time
                
                if ((globalvariables.centerrecord.editmonthlycourseclassdate || ![((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingClass.subject centerkey:globalvariables.centerrecord.centerkey]).tuition_mode isEqualToString:@"Month"])) {
                    //if (globalvariables.centerrecord.editmonthlycourseclassdate) {
                        selectedItem=@"DateTime";
                        
                        
                        if (showDatePicker==YES) {
                            showDatePicker=NO;
                        }else{
                            showLevelPicker=NO;
                            showDatePicker=YES;
                            showMakeupDateTimePicker=NO;
                        }
                        
                        [self showsidewindowwithwindow:@"none"];
                        
                        if ([workingClass.startdate isEqualToString:@"TBD"] && [workingClass.classtime isEqualToString:@"TBD"]) {
                            //set to next working day
                            NSDate *today=[NSDate date];
                            NSDateFormatter *df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
                            [df setDateFormat:@"dd-MMM-yyyy"];
                            
                            workingClass.startdate=[MyClass findNextWorkDay2:today includereserveddate:NO];
                            workingClass.classtime=[NSString stringWithFormat:@"%@:%@",[globalvariables.centerrecord.classstarttime substringToIndex:2],[globalvariables.centerrecord.classstarttime substringFromIndex:2]];
                            workingClass.classday = [MyClass convertDateFormatWithDate:workingClass.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE"];
                            [ClassPopoverTable reloadData];
                            [self adjusttablesize];
                            
                        }else if ([workingClass.startdate isEqualToString:@"TBD"]){
                            //set to next working day
                            NSDate *today=[NSDate date];
                            NSDateFormatter *df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
                            [df setDateFormat:@"dd-MMM-yyyy"];
                            
                            workingClass.startdate=[MyClass findNextWorkDay2:today includereserveddate:NO];
                            workingClass.classday = [MyClass convertDateFormatWithDate:workingClass.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE"];
                            [ClassPopoverTable reloadData];
                            [self adjusttablesize];

                        }else if ([workingClass.classtime isEqualToString:@"TBD"]){
                            //set to center opening hours
                            workingClass.classtime=[NSString stringWithFormat:@"%@:%@",[globalvariables.centerrecord.classstarttime substringToIndex:2],[globalvariables.centerrecord.classstarttime substringFromIndex:2]];
                            //workingClass.classday = [MyClass convertDateFormatWithDate:workingClass.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE"];
                            [ClassPopoverTable reloadData];
                            
                            [self adjusttablesize];
                        }
                        [ClassPopoverTable reloadData];
                        [self adjusttablesize];
                }
                
            }else if (indexPath.section==0 && indexPath.row==3) {
                //pickerview for instructor
                if ([MyClass showLessonParameterWithSubject:workingClass.subject]) {
                    selectedItem=@"LessonNumber";

                    showLevelPicker=NO;
                    showDatePicker=NO;
                    showMakeupDateTimePicker=NO;
                    
                    //default if not select
                    if([workingClass.lesson isEqualToString:@""]){
                        NSMutableArray *defaultlesson=[[NSMutableArray alloc]init];
                        if(globalvariables.centerrecord.lessonnumbermode==2){
                            [defaultlesson addObject:lessonArray[0][0]];
                            
                            NSMutableArray *ln1Array=lessonArray[1];
                            NSString *studentgrade=((Student *)[MyClass returnstudentwithstudentkey:workingClass.studentkey]).grade;
                            if ([ln1Array containsObject:studentgrade]) {
                                [defaultlesson addObject:studentgrade];
                            }else{
                                [defaultlesson addObject:ln1Array[0]];
                            }
                            [defaultlesson addObject:@"1"];
                            [defaultlesson addObject:@"1"];
                            workingClass.lesson=[defaultlesson componentsJoinedByString:@"/"];
                        }else{
                            [defaultlesson addObject:lessonArray[0]];
                            workingClass.lesson=[defaultlesson componentsJoinedByString:@"/"];
                        }
                        
                    }

                    [self showsidewindowwithwindow:@"showLessonNumberTable"];
                    [ClassPopoverTable reloadData];
                    [LessonNumberTable reloadData];
                    [self adjusttablesize];
                }
                

            }else if (indexPath.section==0 && indexPath.row==7) {
                //pickerview for instructor
                
                selectedItem=@"Instructor";
                instructortablelabel.text=[[MyClass returntitlewithtitle:@"Instructor"] uppercaseString];

                showLevelPicker=NO;
                showDatePicker=NO;
                showMakeupDateTimePicker=NO;

                [self showsidewindowwithwindow:@"showInstructorTable"];
                instructorsearchbar.text=@"";
                filteredActiveInstructorArray=[[NSMutableArray alloc]initWithArray:ActiveInstructorArray];
                [ClassPopoverTable reloadData];
                [InstructorTable reloadData];
                [self adjusttablesize];
                
                
                
            }else if (indexPath.section==0 && indexPath.row==8) {
                //pickerview for instructor
                
                selectedItem=@"SInstructor";
                instructortablelabel.text=[[MyClass returntitlewithtitle:@"Sec. Instructor"] uppercaseString];
                showLevelPicker=NO;
                showDatePicker=NO;
                showMakeupDateTimePicker=NO;

                [self showsidewindowwithwindow:@"showInstructorTable"];
                instructorsearchbar.text=@"";
                filteredActiveInstructorArray=[[NSMutableArray alloc]initWithArray:ActiveInstructorArray];
                [ClassPopoverTable reloadData];
                [InstructorTable reloadData];
                [self adjusttablesize];
                
                
                
            }else if (indexPath.section==0 && indexPath.row==9) {
                //pickerview for instructor
                
                selectedItem=@"Classroom";
                showLevelPicker=NO;
                showDatePicker=NO;
                showMakeupDateTimePicker=NO;
                
                [self showsidewindowwithwindow:@"showClassroomTable"];
                if ([workingClass.classroom isEqualToString:@""]) {
                    workingClass.classroom= ((ClassroomRecord *)[FilteredClassroomArray objectAtIndex:0]).classroom;
                    
                }
                
                [ClassroomTable reloadData];
                [ClassPopoverTable reloadData];
                
                [self adjusttablesize];
            }else if (indexPath.section==5 && indexPath.row==1) {
                    showLevelPicker=NO;
                    showDatePicker=NO;
                    showMakeupDateTimePicker=NO;

                [self showsidewindowwithwindow:@"showNatureTable"];

                [NatureTable reloadData];
                [ClassPopoverTable reloadData];

                [self adjusttablesize];

            }else if (indexPath.section==5 && indexPath.row==0) {
                //pickerview for makeup date time
                
                selectedItem=@"MakeupDateTime";
                if (showMakeupDateTimePicker ==YES) {
                    showMakeupDateTimePicker=NO;
                }else{
                    showLevelPicker=NO;
                    showDatePicker=NO;
                    showMakeupDateTimePicker=YES;
                }
                
                [self showsidewindowwithwindow:@"none"];
                
                if ([workingClass.makeupdate isEqualToString:@""]) {
                    if (![PopoverClass.startdate isEqualToString:@"TBD"] && ![PopoverClass.classtime isEqualToString:@"TBD"]) {
                        workingClass.makeupdate=PopoverClass.startdate;
                        workingClass.makeuptime=PopoverClass.classtime;
                    }else{
                        workingClass.makeupdate=[MyClass findNextWorkDay2:[NSDate date] includereserveddate:NO];
                        workingClass.makeuptime=[globalvariables.centerrecord.classstarttime substringToIndex:2];
                    }
                    
                    NSString *tmpmakeupinstructor;
                    tmpmakeupinstructor=@"TBD";

                }
                
                [ClassPopoverTable reloadData];
                [self adjusttablesize];

            }else if (indexPath.section==5 && indexPath.row==2) {
                //pickerview for instructor
                
                selectedItem=@"MakeupInstructor";
                    showLevelPicker=NO;
                    showDatePicker=NO;
                    showMakeupDateTimePicker=NO;
                
                instructortablelabel.text=[[MyClass returntitlewithtitle:@"Makeup Instructor"] uppercaseString];
                
                [self showsidewindowwithwindow:@"showInstructorTable"];
                instructorsearchbar.text=@"";
                filteredActiveInstructorArray=[[NSMutableArray alloc]initWithArray:ActiveInstructorArray];
                
                if ([workingClass.makeupinstructor isEqualToString:@""]) {
                    workingClass.makeupinstructor=PopoverClass.instructor;
                }
                
                [InstructorTable reloadData];
                [ClassPopoverTable reloadData];
                [self adjusttablesize];
                //[masterView setContentSize:CGSizeMake(320, ClassPopoverTable.contentSize.height)];
            }else if (indexPath.section==5 && indexPath.row==3) {
                //pickerview for instructor
                
                selectedItem=@"MakeupSInstructor";
                    showLevelPicker=NO;
                    showDatePicker=NO;
                    showMakeupDateTimePicker=NO;
                
                instructortablelabel.text=[[MyClass returntitlewithtitle:@"Makeup Sec. Instructor"] uppercaseString];
                
                [self showsidewindowwithwindow:@"showInstructorTable"];
                instructorsearchbar.text=@"";
                filteredActiveInstructorArray=[[NSMutableArray alloc]initWithArray:ActiveInstructorArray];
                
                if ([workingClass.makeupsinstructor isEqualToString:@""]) {
                    workingClass.makeupsinstructor=PopoverClass.sinstructor;
                }
                
                [InstructorTable reloadData];
                [ClassPopoverTable reloadData];
                [self adjusttablesize];
                //[masterView setContentSize:CGSizeMake(320, ClassPopoverTable.contentSize.height)];
            }else if (indexPath.section==5 && indexPath.row==4) {
                //pickerview for instructor
                
                selectedItem=@"MakeupClassroom";

                    showLevelPicker=NO;
                    showDatePicker=NO;
                    showMakeupDateTimePicker=NO;

                [self showsidewindowwithwindow:@"showClassroomTable"];
                
                if ([workingClass.makeupclassroom isEqualToString:@""]) {
                    workingClass.makeupclassroom=PopoverClass.classroom;

                }

                [ClassroomTable reloadData];
                [ClassPopoverTable reloadData];

                [self adjusttablesize];
            }
        }
    }else if (tableView==InstructorTable){
        [self.view endEditing:YES];
        if ([selectedItem isEqualToString:@"Instructor"]) {
            if (![workingClass.instructor isEqualToString:((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username]) {
                //InstructorLabel.text=[self.pickerViewmenu objectAtIndex:row];
                
                workingClass.instructor=((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username;
                //showInstructorPicker=NO;
                
                //[self storeTmpField];
                [ClassPopoverTable reloadData];
                [InstructorTable reloadData];
                
                [self adjusttablesize];
                //[masterView setContentSize:CGSizeMake(320, ClassPopoverTable.contentSize.height)];
                
                //[self updatefreescheduleclassarraywithfield:@"Instructor" value:workingClass.instructor];
                
            }
        }else if ([selectedItem isEqualToString:@"SInstructor"]) {
            if (![workingClass.sinstructor isEqualToString:((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username]) {
                //InstructorLabel.text=[self.pickerViewmenu objectAtIndex:row];
                
                workingClass.sinstructor=((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username;
                //showInstructorPicker=NO;
                
                //[self storeTmpField];
                [ClassPopoverTable reloadData];
                [InstructorTable reloadData];
                
                [self adjusttablesize];
                //[masterView setContentSize:CGSizeMake(320, ClassPopoverTable.contentSize.height)];
                
                //[self updatefreescheduleclassarraywithfield:@"Instructor" value:workingClass.instructor];
                
            }
        }else if ([selectedItem isEqualToString:@"MakeupInstructor"]){
            if (![workingClass.makeupinstructor isEqualToString:((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username]) {
                //InstructorLabel.text=[self.pickerViewmenu objectAtIndex:row];
                
                workingClass.makeupinstructor=((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username;
                //showInstructorPicker=NO;
                
                //[self storeTmpField];
                [ClassPopoverTable reloadData];
                [InstructorTable reloadData];
                
                [self adjusttablesize];
                //[masterView setContentSize:CGSizeMake(320, ClassPopoverTable.contentSize.height)];
                
                //[self updatefreescheduleclassarraywithfield:@"MakeupInstructor" value:workingClass.makeupinstructor];
                
            }
        }else if ([selectedItem isEqualToString:@"MakeupSInstructor"]){
            if (![workingClass.makeupsinstructor isEqualToString:((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username]) {
                //InstructorLabel.text=[self.pickerViewmenu objectAtIndex:row];
                
                workingClass.makeupsinstructor=((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username;
                //showInstructorPicker=NO;
                
                //[self storeTmpField];
                [ClassPopoverTable reloadData];
                [InstructorTable reloadData];
                
                [self adjusttablesize];
                //[masterView setContentSize:CGSizeMake(320, ClassPopoverTable.contentSize.height)];
                
                //[self updatefreescheduleclassarraywithfield:@"MakeupInstructor" value:workingClass.makeupinstructor];
                
            }
        }
        

    }else if (tableView==ClassroomTable){
        [self.view endEditing:YES];
        if ([selectedItem isEqualToString:@"Classroom"]) {
            if (![workingClass.classroom isEqualToString:((ClassroomRecord *)[FilteredClassroomArray objectAtIndex:indexPath.row]).classroom]) {
                //InstructorLabel.text=[self.pickerViewmenu objectAtIndex:row];
                
                workingClass.classroom=((ClassroomRecord *)[FilteredClassroomArray objectAtIndex:indexPath.row]).classroom;
                //showInstructorPicker=NO;
                
                //[self storeTmpField];
                [ClassPopoverTable reloadData];
                [ClassroomTable reloadData];
                
                [self adjusttablesize];
                //[masterView setContentSize:CGSizeMake(320, ClassPopoverTable.contentSize.height)];
                
                //[self updatefreescheduleclassarraywithfield:@"Classroom" value:workingClass.classroom];
                
            }
        }else{
            if (![workingClass.makeupclassroom isEqualToString:((ClassroomRecord *)[FilteredClassroomArray objectAtIndex:indexPath.row]).classroom]) {
                //InstructorLabel.text=[self.pickerViewmenu objectAtIndex:row];
                
                workingClass.makeupclassroom=((ClassroomRecord *)[FilteredClassroomArray objectAtIndex:indexPath.row]).classroom;
                //showInstructorPicker=NO;
                
                //[self storeTmpField];
                [ClassPopoverTable reloadData];
                [ClassroomTable reloadData];
                
                [self adjusttablesize];
                //[masterView setContentSize:CGSizeMake(320, ClassPopoverTable.contentSize.height)];
                
                //[self updatefreescheduleclassarraywithfield:@"MakeupClassroom" value:workingClass.makeupclassroom];
                
            }
        }
        
        
    }else if (tableView==NatureTable){
        [self.view endEditing:YES];
        if (![workingClass.leavenaturelistkey isEqualToString:((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:indexPath.row]).leavenaturelistkey]) {
            
            workingClass.leavenaturelistkey=((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:indexPath.row]).leavenaturelistkey;
            //showMakeupInstructorPicker=NO;
            
            //[self storeTmpField];
            
            [ClassPopoverTable reloadData];
            [NatureTable reloadData];
            
            [self adjusttablesize];
            
            //[self updatefreescheduleclassarraywithfield:@"MakeupClassroom" value:workingClass.makeupclassroom];
        }
        
    }else if (tableView==LessonNumberTable){
        workingClass.lesson=[@(indexPath.row+1) stringValue];
        [LessonNumberTable reloadData];
        [ClassPopoverTable reloadData];
        [self closelessonnumbertable];
    }
}

-(BOOL) editPaidEnrollment
{
    if (!PopoverClass.enrollmentpaid) {
        return YES;
    }else{
        if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editclassforpaidenrollment) {
            return YES;
        }
    }
    return NO;
}

-(void) timetableButtonPressed:(UIButton *)sender
{
    sender.enabled=NO;
    NSString *tmpstartdate;
    NSString *tmpclasstime;
    NSString *tmpinstructor;
    NSString *tmpsinstructor;
    

    
    
    //popup class view record
    
    ClassTimeTableViewController *timetablepopover = (ClassTimeTableViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"ClassTimeTableViewController"];
    timetablepopover.TimeTableMode=@"PopoverWeekly";
    timetablepopover.Subjectselected=ClassLabel.text;
    timetablepopover.studentkey=PopoverClass.studentkey;
    
    if ([selectedItem isEqualToString:@"DateTime"]) {
        if ([workingClass.attendance isEqualToString:@"Makeup"]) {
            workingClass.attendance=globalvariables.centerrecord.defaultattendancestatus;
            showMakeupSection=NO;
            
            //delete latest class record
            for (int i=0; i<FreeScheduleClassArray.count; i++) {
                FreeScheduleClassObject=[FreeScheduleClassArray objectAtIndex:i];
                if ([FreeScheduleClassObject.action isEqualToString:@""] || [FreeScheduleClassObject.action isEqualToString:@"Edit"]) {
                    FreeScheduleClassObject.action=@"Delete";
                    break;
                }else if ([FreeScheduleClassObject.action isEqualToString:@"Add"]){
                    [FreeScheduleClassArray removeObjectAtIndex:i];
                    break;
                }
            }
            
            //add latest class
            if ([workingClass.startdate isEqualToString:@"TBD"] && [workingClass.classtime isEqualToString:@"TBD"]) {
                tmpstartdate=@"TBD";
                tmpclasstime=@"TBD";
            }else if ([workingClass.startdate isEqualToString:@"TBD"]){
                tmpstartdate=@"TBD";
                tmpclasstime=workingClass.classtime;
            }else if ([workingClass.classtime isEqualToString:@"TBD"]){
                tmpstartdate=workingClass.startdate;
                tmpclasstime=@"TBD";
            }else{
                tmpstartdate=workingClass.startdate;
                tmpclasstime=workingClass.classtime;
            }
            
            if ([workingClass.instructor isEqualToString:@""]) {
                tmpinstructor=@"TBD";
            }else{
                tmpinstructor= workingClass.instructor;// InstructorLabel.text;
            }
            
            if ([workingClass.sinstructor isEqualToString:@""]) {
                tmpsinstructor=@"TBD";
            }else{
                tmpsinstructor= workingClass.sinstructor;// InstructorLabel.text;
            }
            
            [FreeScheduleClassArray addObject:[[FreeScheduleClass alloc]initFreeScheduleClassWithclasskey:@"" subject:PopoverClass.subject classdate:tmpstartdate classtime:tmpclasstime instructor:tmpinstructor classroom:PopoverClass.classroom attendance:workingClass.attendance makeupdate:@"" makeuptime:@"" makeupinstructor:@"" makeupclassroom:@"" makeupattendance:@"" classremarks:ClassRemarksText.text allclassremarks:AllClassRemarksText.text action:@"Add" classtype:@"Class" leavenaturelistkey:@"0" lesson:@"" sinstructor:tmpsinstructor makeupsinstructor:@"" locked:NO]];
            
            //[self storeTmpField];
            
            [ClassPopoverTable reloadData];
            [self adjusttablesize];
            //[masterView setContentSize:CGSizeMake(320, ClassPopoverTable.contentSize.height)];// EnrollmentPopoverTable.bounds.size];
        }
        
        timetablepopover.preferredinstructor=workingClass.instructor;
        
        if ([PopoverClass.draft isEqualToString:@"Yes"]) {
            timetablepopover.draftclasskey=PopoverClass.classkey;
        }else{
            timetablepopover.draftclasskey=@"NA";
        }
        timetablepopover.FreeScheduleClassArray=FreeScheduleClassArray;
        
        if (![workingClass.startdate isEqualToString:@""] && ![workingClass.startdate isEqualToString:@"TBD"]) {
            
            //find past monday
            //NSDateFormatter *df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            //[df setDateFormat:@"dd-MMM-yyyy HH:mm"];
            NSDate *currentdate=[MyClass convertToNSDateWithDate:workingClass.startdate DateFormat:@"dd-MMM-yyyy"];
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:currentdate];
            
            NSUInteger weekdayToday = [components weekday];
            NSInteger daysToMonday=weekdayToday-[MyClass returndayofweeknumber:[globalvariables.centerdayofweekarray objectAtIndex:0]];
            NSDate *pastMon = [currentdate dateByAddingTimeInterval:60*60*24*(-daysToMonday)];
            
            timetablepopover.startupmonday=[MyClass convertToNSStringWithNSDate:pastMon DateFormat:@"dd-MMM-yyyy"];
        }
        
        
    }else if ([selectedItem isEqualToString:@"MakeupDateTime"]){
        timetablepopover.draftclasskey=@"NA";
        timetablepopover.FreeScheduleClassArray=FreeScheduleClassArray;
        
        if (![workingClass.makeupdate isEqualToString:@""] && ![workingClass.makeupdate isEqualToString:@"TBD"]) {
            
            //find past monday
            NSDate *currentdate=[MyClass convertToNSDateWithDate:workingClass.makeupdate DateFormat:@"dd-MMM-yyyy"];
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:currentdate];
            
            NSUInteger weekdayToday = [components weekday];
            NSInteger daysToMonday=weekdayToday-[MyClass returndayofweeknumber:[globalvariables.centerdayofweekarray objectAtIndex:0]];
            NSDate *pastMon = [currentdate dateByAddingTimeInterval:60*60*24*(-daysToMonday)];
            timetablepopover.startupmonday=[MyClass convertToNSStringWithNSDate:pastMon DateFormat:@"dd-MMM-yyyy"];
        }
        timetablepopover.preferredinstructor=workingClass.makeupinstructor;
        
    }
    
    
    timetablepopover.delegate=self;
    //[self presentViewController:timetablepopover animated:YES completion:nil];
    [MyClass presentViewController:timetablepopover View:self];
    
    showDatePicker=NO;
    [ClassPopoverTable reloadData];
}


-(void)passTimeTableInformationwithstartdate:(NSString *)startdate classtime:(NSString *)classtime instructor:(NSString *)instructor classroom:(NSString *)classroom
{
    if ([selectedItem isEqualToString:@"DateTime"]) {
        workingClass.startdate=startdate;
        workingClass.classtime=classtime;
        //tmpStartDateTime=[NSString stringWithFormat:@"%@ %@",startdate,classtime];
        if (![instructor isEqualToString:@""]) {
            //workingClass.instructor=[MyClass returninstructornamewithinstructorarray:AllInstructorArray username:instructor firstorfullname:@"full"];
            workingClass.instructor=instructor;
        }
        
        if(![classroom isEqualToString:@""]){
            workingClass.classroom=classroom;
        }

        /*NSDateFormatter *df =[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
        [df setDateFormat:@"dd-MMM-yyyy HH:mm"];
        NSDate *date = [df dateFromString:tmpStartDateTime];
        
        [df setDateFormat:@"EEE"];
        workingClass.classday = [df stringFromDate:date];*/
        workingClass.classday=[MyClass convertDateFormatWithDate:workingClass.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE"];
        
        showDatePicker=NO;
        

        [ClassPopoverTable reloadData];
        
        [self adjusttablesize];


    }else{
        //tmpMakeupDateTime=[NSString stringWithFormat:@"%@ %@",startdate,classtime];
        workingClass.makeupdate=startdate;
        workingClass.classtime=classtime;
        if ([instructor isEqualToString:@""]) {
            workingClass.makeupinstructor=@"TBD";
        }else{
            workingClass.makeupinstructor=instructor;
        }

        if ([classroom isEqualToString:@""]) {
            workingClass.makeupclassroom=@"TBD";
        }else{
            workingClass.makeupclassroom=classroom;
        }
        
        showMakeupDateTimePicker=NO;
        

        [ClassPopoverTable reloadData];
        
        [self adjusttablesize];

    }

    [self dismissViewControllerAnimated:YES completion:nil];
    
    showDatePicker=NO;

    [ClassPopoverTable reloadData];

    [self adjusttablesize];

}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    if([selectedItem isEqualToString:@"DateTime"]|| [selectedItem isEqualToString:@"MakeupDateTime"]){
        return 2;
    }else if([selectedItem isEqualToString:@"Level"]){
        if ([MyClass isEyeLevelMathWithSubject:PopoverClass.subject]) {
                if ([tmpLevel isEqualToString:@"TBD"] || [tmpLevel isEqualToString:@"DT"]) {
                    return 1;
                }else{
                    return 2;
                }
        }else{
            return 1;
        }
        
    }else if ([selectedItem isEqualToString:@"LessonNumber"]){
        return 4;
    } else{
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if([selectedItem isEqualToString:@"DateTime"] || [selectedItem isEqualToString:@"MakeupDateTime"]){
        if (component==0){
            return [self.hourPickerViewMenu count];
        }else{
            return [self.minutePickerViewMenu count];
        }
        
    }else if([selectedItem isEqualToString:@"Level"]){
        if ([MyClass isEyeLevelMathWithSubject:PopoverClass.subject]) {
                if ([tmpLevel isEqualToString:@"TBD"] || [tmpLevel isEqualToString:@"DT"]) {
                    return [self.levelmainPickerViewMenu count];
                }else{
                    if (component==0){
                        return [self.levelmainPickerViewMenu count];
                    }else{
                        return [self.levelctmPickerViewMenu count];
                    }
                }
        }else{
            return [self.pickerViewmenu count];
        }

    }else if ([selectedItem isEqualToString:@"LessonNumber"]){
        if (component==0) {
            return ((NSMutableArray *)lessonArray[0]).count;
        }else if (component==1) {
            return ((NSMutableArray *)lessonArray[1]).count;
        }else if (component==2) {
            return ((NSMutableArray *)lessonArray[2]).count;
        }else if (component==3) {
            return ((NSMutableArray *)lessonArray[3]).count;
        }
    }
    return [self.pickerViewmenu count];
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
    
    
    if([selectedItem isEqualToString:@"DateTime"] || [selectedItem isEqualToString:@"MakeupDateTime"]){
        [tView setFont:[UIFont systemFontOfSize:16]];
        if (component==0){
            tView.text= [self.hourPickerViewMenu objectAtIndex:row];
        }else{
            tView.text= [self.minutePickerViewMenu objectAtIndex:row];
            
            
        }
    }else if([selectedItem isEqualToString:@"Level"]){
        if ([MyClass isEyeLevelMathWithSubject:PopoverClass.subject]) {
                if ([tmpLevel isEqualToString:@"TBD"] || [tmpLevel isEqualToString:@"DT"]) {
                    tView.text= [self.levelmainPickerViewMenu objectAtIndex:row];
                }else{
                    if (component==0){
                        tView.text= [self.levelmainPickerViewMenu objectAtIndex:row];
                    }else{
                        tView.text= [self.levelctmPickerViewMenu objectAtIndex:row];
                    }
                }
        }else{
            tView.text= [self.pickerViewmenu objectAtIndex:row];
        }
        
    }else if ([selectedItem isEqualToString:@"LessonNumber"]){
        if (component==0) {
            tView.text= [((NSMutableArray *)lessonArray[0]) objectAtIndex:row];
        }else if (component==1) {
            tView.text= [((NSMutableArray *)lessonArray[1]) objectAtIndex:row];
        }else if (component==2) {
            tView.text= [@(row+1) stringValue];
        }else if (component==3) {
            tView.text= [@(row+1) stringValue];
        }
    } else{
        tView.text= [self.pickerViewmenu objectAtIndex:row];
    }

    return tView;
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if([selectedItem isEqualToString:@"DateTime"] || [selectedItem isEqualToString:@"MakeupDateTime"]){
        if (component==0){
            return 30;
        }else{
            return 30;
        }
    }else if ([selectedItem isEqualToString:@"Level"]){
        if ([MyClass isEyeLevelMathWithSubject:PopoverClass.subject]) {
                if ([tmpLevel isEqualToString:@"TBD"] || [tmpLevel isEqualToString:@"DT"]) {
                    return 260;
                }else{
                    return 80;
                }
        }else{
            return 260;
        }

    }else if([selectedItem isEqualToString:@"LessonNumber"]){
        return 75;
    }else{
        return 300;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    
    [self.view endEditing:YES];
    if([selectedItem isEqualToString:@"DateTime"]){
        if(![workingClass.classtime isEqualToString:[NSString stringWithFormat:@"%@:%@",[self.hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]]]){
        
        //if (![tmpStartDateTime isEqualToString:[NSString stringWithFormat:@"%@ %@:%@",[tmpStartDateTime substringToIndex:11],[self.hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]]]) {
            
            //if ([MyClass isWorkingDate:[MyClass convertToNSDateWithDate:[MyClass returnDateFromBaseDateWithOffset:[pickerView selectedRowInComponent:0]] DateFormat:@"dd-MMM-yyyy"] includereserveddate:YES]) {
                //check if selected time is within operating hour
                NSString *selectedtime=[NSString stringWithFormat:@"%@%@",[self.hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
                int classduration=[((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingClass.subject centerkey:globalvariables.centerrecord.centerkey]).classduration intValue];
                //classduration=(int)(classduration/60)*100+classduration%60;
                if ([selectedtime intValue]<[globalvariables.centerrecord.classstarttime intValue]) {
                    
                    UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Class start time is outside center's opening hour"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [wrongTimeAlert addAction:OKAction];
                    //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                    [MyClass presentViewController:wrongTimeAlert View:self];
                    
                    
                    [ClassPopoverTable reloadData];
                }else if ([MyClass classendtimebeyondcenterendtimewithclassstarttime:selectedtime duration:classduration]){
                    UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [wrongTimeAlert addAction:OKAction];
                    //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                    [MyClass presentViewController:wrongTimeAlert View:self];
                    [ClassPopoverTable reloadData];
                    
                }else{
                    workingClass.classtime=[NSString stringWithFormat:@"%@:%@",[self.hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
                    //tmpStartDateTime=[NSString stringWithFormat:@"%@ %@:%@",[tmpStartDateTime substringToIndex:11],[self.hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
                    
                    //NSDateFormatter *df =[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
                    //[df setDateFormat:@"dd-MMM-yyyy HH:mm"];
                    //NSDate *date = [df dateFromString:tmpStartDateTime];
                    //[df setDateFormat:@"EEE"];
                    //workingClass.classday = [MyClass convertDateFormatWithDate:workingClass.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE"];
                    //[self updatefreescheduleclassarraywithfield:@"DateTime" value:tmpStartDateTime];
                    
                    workingClass.attendance=globalvariables.centerrecord.defaultattendancestatus;
                    workingClass.makeupattendance=@"";
                    showMakeupSection=NO;
                    showMakeupRemarks=NO;
                    workingClass.makeupdate=@"";
                    workingClass.makeuptime=@"";
                    //tmpMakeupDateTime=@"";
                    workingClass.makeupclassroom=@"";
                    workingClass.makeupinstructor=@"";
                    workingClass.absentmakeupreason=@"";
                    
                    
                    [MyClass reloadTableWithTableview:ClassPopoverTable ExceptIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
                    
                    [self adjusttablesize];

                }
        }
    }else if([selectedItem isEqualToString:@"Level"]){
        
        if ([MyClass isEyeLevelMathWithSubject:PopoverClass.subject]) {
                if ([[self.levelmainPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]]isEqualToString:@"TBD"] || [[self.levelmainPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]]isEqualToString:@"DT"]) {
                    tmpLevel=[self.levelmainPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]] ;
                    
                    //[self storeTmpField];
                    [ClassPopoverTable reloadData];
                    
                }else{
                    if ([tmpLevel isEqualToString:@"TBD"] || [tmpLevel isEqualToString:@"DT"]) {
                        tmpLevel=[NSString stringWithFormat:@"BTM%@",[self.levelmainPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]]];
                        //[self storeTmpField];
                        [ClassPopoverTable reloadData];
                    }else{
                        if ([[self.levelctmPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]] isEqualToString:@""]) {
                            tmpLevel=[NSString stringWithFormat:@"BTM%@",[self.levelmainPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]]];
                            
                        }else{
                            if (![LevelLabel.text isEqualToString:[NSString stringWithFormat:@"BTM%@/CTM%@",[self.levelmainPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.levelctmPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]]]) {
                                tmpLevel=[NSString stringWithFormat:@"BTM%@/CTM%@",[self.levelmainPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.levelctmPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
                                
                            }
                        }
                        //[self storeTmpField];
                        [ClassPopoverTable reloadData];
                    }
                }
        }else{
            if (![tmpLevel isEqualToString:[self.pickerViewmenu objectAtIndex:row]]) {
                tmpLevel=[NSString stringWithFormat:@"%@",[self.pickerViewmenu objectAtIndex:[pickerView selectedRowInComponent:0]]];
                
                //[self storeTmpField];
                
                showLevelPicker=NO;
                [ClassPopoverTable reloadData];
                [self adjusttablesize];
            }
        }
        
    }/*else if([selectedItem isEqualToString:@"Instructor"]){
        if (![workingClass.instructor isEqualToString:((Instructor *)[pickerViewmenu objectAtIndex:row]).username]) {
            //InstructorLabel.text=[self.pickerViewmenu objectAtIndex:row];
            
            workingClass.instructor=((Instructor *)[pickerViewmenu objectAtIndex:row]).username;
            showInstructorPicker=NO;
            
            //[self storeTmpField];
            [ClassPopoverTable reloadData];
            
            [self adjusttablesize];
            //[masterView setContentSize:CGSizeMake(320, ClassPopoverTable.contentSize.height)];
            
            [self updatefreescheduleclassarraywithfield:@"Instructor" value:workingClass.instructor];

        }
        
        
    }else if([selectedItem isEqualToString:@"Classroom"]){
        if (![workingClass.classroom isEqualToString:((ClassroomRecord *)[pickerViewmenu objectAtIndex:row]).classroom]) {
            //InstructorLabel.text=[self.pickerViewmenu objectAtIndex:row];
            
            workingClass.classroom=((ClassroomRecord *)[pickerViewmenu objectAtIndex:row]).classroom;
            showClassroomPicker=NO;
            
            //[self storeTmpField];
            [ClassPopoverTable reloadData];
            
            [self adjusttablesize];
            //[masterView setContentSize:CGSizeMake(320, ClassPopoverTable.contentSize.height)];
            
            //[self updatefreescheduleclassarraywithfield:@"Instructor" value:workingClass.instructor];
            
        }
    }*/else if([selectedItem isEqualToString:@"MakeupDateTime"]){
        if (![workingClass.makeuptime isEqualToString:[NSString stringWithFormat:@"%@:%@",[self.hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]]]) {
            
            //if ([MyClass isWorkingDate:[MyClass convertToNSDateWithDate:[MyClass returnDateFromBaseDateWithOffset:[pickerView selectedRowInComponent:0]] DateFormat:@"dd-MMM-yyyy"] includereserveddate:YES]) {
                //check if selected time is within operating hour
                NSString *selectedtime=[NSString stringWithFormat:@"%@%@",[self.hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
                int classduration=[((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingClass.subject centerkey:globalvariables.centerrecord.centerkey]).classduration intValue];
                //classduration=(int)(classduration/60)*100+classduration%60;
                if ([selectedtime intValue]<[globalvariables.centerrecord.classstarttime intValue]) {
                    UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Class start time is outside center's opening hour"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [wrongTimeAlert addAction:OKAction];
                    //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                    [MyClass presentViewController:wrongTimeAlert View:self];
                    //[ClassPopoverTable reloadData];
                }else if ([MyClass classendtimebeyondcenterendtimewithclassstarttime:selectedtime duration:classduration]){
                    UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [wrongTimeAlert addAction:OKAction];
                    //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                    [MyClass presentViewController:wrongTimeAlert View:self];
                    //[ClassPopoverTable reloadData];
                    
                }else{
                    workingClass.makeuptime=[NSString stringWithFormat:@"%@:%@",[self.hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
                    
                    //reset makeup attendance
                    workingClass.makeupattendance=globalvariables.centerrecord.defaultattendancestatus;
                    
                    //[self storeTmpField];
                    //[ClassPopoverTable reloadData];
                    
                    //[self updatefreescheduleclassarraywithfield:@"MakeupDateTime" value:tmpMakeupDateTime];
                    
                }
                
            //}
            [MyClass reloadTableWithTableview:ClassPopoverTable ExceptIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
            

        }

    }else if ([selectedItem isEqualToString:@"LessonNumber"]){
        NSMutableArray *selectedNumber=[[NSMutableArray alloc]init];
        [selectedNumber addObject:[((NSMutableArray *)lessonArray[0]) objectAtIndex:[pickerView selectedRowInComponent:0]]];
        [selectedNumber addObject:[((NSMutableArray *)lessonArray[1]) objectAtIndex:[pickerView selectedRowInComponent:1]]];
        [selectedNumber addObject:[@([pickerView selectedRowInComponent:2]+1) stringValue]];
        [selectedNumber addObject:[@([pickerView selectedRowInComponent:3]+1) stringValue]];
        
        workingClass.lesson=[selectedNumber componentsJoinedByString:@"/"];
        [ClassPopoverTable reloadData];
    }
    
    
}



-(void) updatefreescheduleclassarrayafterattendanceupdate
{

    
    if ([workingClass.attendance isEqualToString:@"Makeup"]) {
        showMakeupSection=YES;
        showMakeupRemarks=YES;
        
    }else{
        if ([workingClass.attendance isEqualToString:@"Absent"] || [workingClass.attendance isEqualToString:@"Extend"]) {
            showMakeupRemarks=YES;
        }else{
            showMakeupRemarks=NO;
        }
        showMakeupSection=NO;
        showMakeupDateTimePicker=NO;
    }
    
    showDatePicker=NO;
    
    //[self storeTmpField];
    
    [ClassPopoverTable reloadData];
    [self adjusttablesize];
    
    
}

-(NSMutableArray *) returnfreescheduleclassarray
{
    NSString *tmpclassdate;
    NSString *tmpclasstime;
    
    NSString *tmpmakeupdate;
    NSString *tmpmakeuptime;

    
    if ([workingClass.startdate isEqualToString:@"TBD"] && [workingClass.classtime isEqualToString:@"TBD"]) {
        tmpclassdate=@"TBD";
        tmpclasstime=@"TBD";
    }else if ([workingClass.startdate isEqualToString:@"TBD"]){
        tmpclassdate=@"TBD";
        tmpclasstime=workingClass.classtime;
    }else if ([workingClass.classtime isEqualToString:@"TBD"]){
        tmpclassdate=workingClass.startdate;
        tmpclasstime=@"TBD";
    }else{
        tmpclassdate=workingClass.startdate;
        tmpclasstime=workingClass.classtime;
    }
    
    if ([workingClass.makeupdate isEqualToString:@""]) {
        tmpmakeupdate=@"";
        tmpmakeuptime=@"";
    }else{
        tmpmakeupdate=workingClass.makeupdate;
        tmpmakeuptime=workingClass.makeuptime;
    }
    
    
    FreeScheduleClass *freescheduleclass_object=[[FreeScheduleClass alloc]init];
    
    freescheduleclass_object.classkey=PopoverClass.classkey;
    freescheduleclass_object.subject=PopoverClass.subject;
    freescheduleclass_object.classdate=tmpclassdate;
    freescheduleclass_object.classtime=tmpclasstime;
    freescheduleclass_object.instructor=workingClass.instructor;
    freescheduleclass_object.classroom=workingClass.classroom;
    freescheduleclass_object.attendance=workingClass.attendance;

    freescheduleclass_object.makeupdate=tmpmakeupdate;
    freescheduleclass_object.makeuptime=tmpmakeuptime;
    freescheduleclass_object.makeupinstructor=workingClass.makeupinstructor;
    freescheduleclass_object.makeupclassroom=workingClass.makeupclassroom;
    freescheduleclass_object.makeupattendance=workingClass.makeupattendance;
    freescheduleclass_object.leavenaturelistkey=workingClass.leavenaturelistkey;
    
    freescheduleclass_object.action=@"Edit";
    
    /*
    if ([workingClass.attendance isEqualToString:@"Present"] || [workingClass.attendance isEqualToString:@""]) {
        if (![tmpclassdate isEqualToString:@"TBD"]) {
            freescheduleclass_object.action=@"Edit";
        }
    }else if ([workingClass.attendance isEqualToString:@"Makeup"]) {
        if (![workingClass.makeupattendance isEqualToString:@"Absent"]) {
            if (![tmpmakeupdate isEqualToString:@""]) {
                freescheduleclass_object.action=@"Edit";
            }
        }
    }*/
    
    return [[NSMutableArray alloc]initWithObjects:freescheduleclass_object, nil];
}

-(void) cancelselection
{
    [self dismissViewControllerAnimated:NO completion:nil];
    //[self storeTmpField];
    showDatePicker=NO;
    
    [ClassPopoverTable reloadData];
    [self adjusttablesize];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==ClassPopoverTable) {
        if ([ClassTableMode isEqualToString:@"View"]) {
            if (indexPath.section==0) {
                if (indexPath.row==2) {
                    if(!globalvariables.centerrecord.enablelessonnumber){
                        return CGFLOAT_MIN;
                    }
                }else if(indexPath.row==6){
                    if(!globalvariables.centerrecord.secondaryinstructor){
                        return CGFLOAT_MIN;
                    }
                }
                return 32;
            }else if(indexPath.section==4) {
                if (indexPath.row==0) {
                    return UITableViewAutomaticDimension;
                }else if (indexPath.row==1){
                    return CGFLOAT_MIN;//showMakeupRemarks?32:CGFLOAT_MIN;
                }else{
                    return showMakeupRemarks?UITableViewAutomaticDimension:CGFLOAT_MIN;
                }
            }else if(indexPath.section==5) {
                if (indexPath.row==0){
                    if (showMakeupSection) {
                        return 32;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }else if (indexPath.row==1){
                    if (showMakeupSection) {
                        return 32;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }else if (indexPath.row==2){
                    if (showMakeupSection && globalvariables.centerrecord.secondaryinstructor) {
                        return 32;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }else if (indexPath.row==3){
                    if (showMakeupSection) {
                        return 32;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }else{
                    if (showMakeupSection) {
                        return 35;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }
            }else if (indexPath.section==1 || indexPath.section==2  || indexPath.section==3) {
                return UITableViewAutomaticDimension;
            }else{
                return 32;
            }
        }else{ //ClassTableMode isEqualToString:@"Edit"
            if (indexPath.section==0) {
                if (indexPath.row==2){
                    if (showLevelPicker) {
                        return 150;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }else if (indexPath.row==3){
                    if (globalvariables.centerrecord.enablelessonnumber) {
                        return 32;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }else if (indexPath.row==8){
                    if (globalvariables.centerrecord.secondaryinstructor) {
                        return 32;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }else if (indexPath.row==5){
                    if (showDatePicker) {
                        return 400;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }
                return 32;
            }else if (indexPath.section==4){
                if (indexPath.row==0) {
                    return 35;
                }else if (indexPath.row==1){
                    return CGFLOAT_MIN;//showMakeupRemarks?32:CGFLOAT_MIN;
                }else{
                    return showMakeupRemarks?UITableViewAutomaticDimension:CGFLOAT_MIN;
                }
            }else if (indexPath.section==1 || indexPath.section==2  || indexPath.section==3) {
                return UITableViewAutomaticDimension;
            }else{// if (indexPath.section==2){
                if (indexPath.row==0){
                    if (showMakeupSection) {
                        return 32;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }else if (indexPath.row==1){
                    if (showMakeupSection && showMakeupDateTimePicker) {
                        return 400;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }else if (indexPath.row==2){
                    if (showMakeupSection) {
                        return 32;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }else if (indexPath.row==3){
                    if (showMakeupSection && globalvariables.centerrecord.secondaryinstructor) {
                        return 32;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }else if (indexPath.row==4){
                    if (showMakeupSection) {
                        return 32;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }else{
                    if (showMakeupSection) {
                        return 35;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }
            }
        }
    }else if (tableView==LessonNumberTable){
        return globalvariables.centerrecord.lessonnumbermode==2?300:UITableViewAutomaticDimension;
    } else{
        return 38;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self stopAudioPlaying];
    if (keyboardheight>0) {
        CGPoint point = [textView.superview convertPoint:CGPointZero toView:ClassPopoverTable];
        NSIndexPath *indexpath =[ClassPopoverTable indexPathForRowAtPoint:point];
        
        CGRect rectInTableView = [ClassPopoverTable rectForRowAtIndexPath:indexpath];
        float offset=rectInTableView.origin.y+rectInTableView.size.height-ClassPopoverTable.frame.size.height;
        if (offset>0) {
            [ClassPopoverTable setContentOffset:CGPointMake(0, offset) animated:YES];
        }
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag==1) {
        workingClass.remarks=textView.text;
    }else if (textView.tag==2){
        workingClass.allclassremarks=textView.text;
    }else if (textView.tag==4){
        workingClass.absentmakeupreason=textView.text;
    }else if (textView.tag==3){
        workingClass.parentnote=textView.text;
    }
}

//-(NSString *) getLessonDescriptionWithLessonNumber:(NSString *)lesson
//{
//    if(globalvariables.centerrecord.lessonnumbermode==2){
//        return lesson;
//    }else{
//        NSMutableDictionary *lessonnumberdict=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingClass.subject centerkey:globalvariables.centerrecord.centerkey]).lessonnumberDict;
//        NSMutableArray *itemsArray=lessonnumberdict[@"noteset1"];
//        NSString *lessondesc=itemsArray[[lesson integerValue]-1];
//        if ([lessondesc isEqualToString:@""]) {
//            return lesson;
//        }else{
//            return [NSString stringWithFormat:@"%@-%@",lesson,lessondesc];
//        }
//
//    }
//}

-(void)textViewDidChange:(UITextView *)textView
{
    CGPoint rootViewPoint = [textView.superview convertPoint:CGPointZero toView:ClassPopoverTable];
    NSIndexPath *indexPath = [ClassPopoverTable indexPathForRowAtPoint:rootViewPoint];
    
    MyTableViewCell *newcell=[ClassPopoverTable cellForRowAtIndexPath:indexPath];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    if (size.height>100) {
        newcell.layoutconstraint1.constant=100;
        textView.scrollEnabled=YES;
    }else{
        newcell.layoutconstraint1.constant=size.height;
        textView.scrollEnabled=NO;
    }
    
    if (textView.tag==1) {
        workingClass.remarks=textView.text;
    }else if (textView.tag==2){
        workingClass.allclassremarks=textView.text;
    }else if (textView.tag==4){
        workingClass.absentmakeupreason=textView.text;
    }else if (textView.tag==3){
        workingClass.parentnote=textView.text;
    }
    
    [ClassPopoverTable beginUpdates];
    [ClassPopoverTable endUpdates];
}

-(void) InitializeField
{
    showLevelPicker=NO;
    showDatePicker=NO;
    showMakeupDateTimePicker=NO;
    [self showsidewindowwithwindow:@"none"];
    
    workingClass=[[ClassRecord alloc]init];
    workingClass.classkey=PopoverClass.classkey;
    workingClass.subject=PopoverClass.subject;
    
    if ([MyClass isEyeLevelMathWithSubject:PopoverClass.subject]) {
            if ([PopoverClass.levelmain isEqualToString:@"DT"] || [PopoverClass.levelmain isEqualToString:@"TBD"]) {
                tmpLevel=PopoverClass.levelmain;
            }else{
                if (![PopoverClass.levelctm isEqualToString:@""]) {
                    tmpLevel=[NSString stringWithFormat:@"BTM%@/CTM%@",PopoverClass.levelmain,PopoverClass.levelctm];
                }else{
                    tmpLevel=[NSString stringWithFormat:@"BTM%@",PopoverClass.levelmain];
                }
            }
    }else{
        tmpLevel=PopoverClass.levelmain;
    }
    workingClass.locked=PopoverClass.locked;
    workingClass.studentkey=PopoverClass.studentkey;
    workingClass.startdate=PopoverClass.startdate;
    workingClass.classtime=PopoverClass.classtime;
    workingClass.classday=PopoverClass.classday;
    workingClass.instructor=PopoverClass.instructor;
    workingClass.sinstructor=PopoverClass.sinstructor;
    workingClass.remarks=PopoverClass.remarks;
    workingClass.allclassremarks=PopoverClass.allclassremarks;
    workingClass.attendance=PopoverClass.attendance;
    //leaveNatureArray=[MyClass retrieveLeaveNatureArrayWithFlushCacheData:NO];
    workingClass.makeupattendance=PopoverClass.makeupattendance;
    if (![PopoverClass.makeupdate isEqualToString:@""]) {
        workingClass.makeupdate=PopoverClass.makeupdate;
        workingClass.makeuptime=PopoverClass.makeuptime;
    }else{
        workingClass.makeupdate=@"";
        workingClass.makeuptime=@"";
    }
    workingClass.makeupinstructor=PopoverClass.makeupinstructor;
    workingClass.makeupsinstructor=PopoverClass.makeupsinstructor;
    workingClass.makeupclassroom=PopoverClass.makeupclassroom;
    
    workingClass.absentmakeupreason=PopoverClass.absentmakeupreason;
    workingClass.classroom=PopoverClass.classroom;
    workingClass.parentnote=PopoverClass.parentnote;
    workingClass.leavenaturelistkey=PopoverClass.leavenaturelistkey;
    workingClass.voiceparentnotemessage= [self copyOutBoxMessageRecord:PopoverClass.voiceparentnotemessage];
    workingClass.lesson=PopoverClass.lesson;
    
    if ([workingClass.attendance isEqualToString:@"Makeup"]) {
        showMakeupSection=YES;
        showMakeupRemarks=YES;
    }else{
        showMakeupSection=NO;
        if ([workingClass.attendance isEqualToString:@"Absent"] || [workingClass.attendance isEqualToString:@"Extend"]) {
            showMakeupRemarks=YES;
        }else{
            showMakeupRemarks=NO;
        }
    }
    
    if ([PopoverClass.attendance isEqualToString:@"Makeup"]) {
        showMakeupSection=YES;
    }
    
    lessonArray=[MyClass returnLessonNumberArrayWithSubject:workingClass.subject];
    
}

-(OutboxMessageRecord *) copyOutBoxMessageRecord:(OutboxMessageRecord *)outboxmessagerecord
{
    NSMutableArray *messagePhotoArray=[[NSMutableArray alloc]init];
    MessagePhotoRecord *copymessagephotorecord=[[MessagePhotoRecord alloc]init];
    if (outboxmessagerecord.photoarray.count>0) {
        MessagePhotoRecord *messagephotorecord=[outboxmessagerecord.photoarray firstObject];
        copymessagephotorecord.filename=messagephotorecord.filename;
        copymessagephotorecord.width=messagephotorecord.width;
        copymessagephotorecord.height=messagephotorecord.height;
        [messagePhotoArray addObject:copymessagephotorecord];
    }
    
    
    OutboxMessageRecord *copyoutboxmessagerecord=[[OutboxMessageRecord alloc]initOutboxMessageRecordwithOutboxMessagekey:nil Messagetype:nil MessageEnglish:nil MessageChinese:nil MessageCreateTime:nil MessageStartTime:outboxmessagerecord.messagestarttime AutoMessageFlag:nil Channel:nil ReciptientType:nil Status:nil RecipientGroup:nil Sender:nil photoarray:messagePhotoArray hotnews:NO hn_expiry_date:nil readstatus:nil composer:nil];
    
    return copyoutboxmessagerecord;
}

-(void) passFreeSscheduleInformationwithArray:(NSMutableArray *)freescheduleclassarray
{
    //not used
}

-(EnrollmentRecord *) updateEnrollmentRecord
{
    
    NSDateFormatter *df=[[NSDateFormatter alloc]init];
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    NSDate *date;
    NSString *tmpstartdate=@"";
    NSString *tmpenddate=@"";
    NSString *tmpclasstime=@"";

    
    if ([workingClass.startdate isEqualToString:@"TBD"] && [workingClass.classtime isEqualToString:@"TBD"]) {
        tmpstartdate=@"TBD";
        tmpclasstime=@"TBD";
    }else if ([workingClass.startdate isEqualToString:@"TBD"]){
        tmpstartdate=@"TBD";
        tmpclasstime=workingClass.classtime;
    }else if ([workingClass.classtime isEqualToString:@"TBD"]){
        tmpstartdate = [MyClass convertDateFormatWithDate:workingClass.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"];
        tmpclasstime=@"TBD";
    }else{
        tmpstartdate = [MyClass convertDateFormatWithDate:workingClass.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"];
        tmpclasstime=workingClass.classtime;
    }
    tmpenddate=tmpstartdate;
    

    NSDate *comparedate;
    
    
    NSString *tmplevelmain;//=LevelLabel.text;
    NSString *tmplevelctm;
    
    if ([MyClass isEyeLevelMathWithSubject:workingClass.subject]) {
            if ([LevelLabel.text isEqualToString:@"TBD"] || [LevelLabel.text isEqualToString:@"DT"]) {
                tmplevelmain=LevelLabel.text;
                tmplevelctm=LevelLabel.text;
            }else{
                NSRange range=[LevelLabel.text rangeOfString:@"/"];
                if (range.location==NSNotFound) {
                    tmplevelmain=[LevelLabel.text substringFromIndex:3];
                    tmplevelctm=@"";
                }else{
                    tmplevelmain=[LevelLabel.text substringWithRange:NSMakeRange(3, range.location-3)];
                    tmplevelctm=[LevelLabel.text substringFromIndex:range.location+4];
                }
            }
    }else{
        if ([LevelLabel.text isEqualToString:@""]) {
            tmplevelmain=@"TBD";
        }else{
            tmplevelmain=LevelLabel.text;
        }
        tmplevelctm=@"";
    }
    
    NSString *tmpclassday=workingClass.classday;
    NSString *tmpinstructor=workingClass.instructor;// InstructorLabel.text;
    NSString *tmpsinstructor=workingClass.sinstructor;
    NSString *tmpclassroom=workingClass.classroom;
    
    
    ClassRecord *classrecordobject=[[ClassRecord alloc]init];
    
    for (int i=0; i<ClassRecordArray.count; i++) {
        classrecordobject=[ClassRecordArray objectAtIndex:i];
        if (![classrecordobject.classkey isEqualToString:PopoverClass.classkey]) {
            if (![classrecordobject.startdate isEqualToString:@"TBD"]) {
                if ([tmpstartdate isEqualToString:@"TBD"]) {
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    date=[df dateFromString:classrecordobject.startdate];
                    [df setDateFormat:@"yyyy-MM-dd"];
                    tmpstartdate=[df stringFromDate:date];
                    //tmpclasstime=classrecordobject.classtime;
                }else{
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    comparedate=[df dateFromString:classrecordobject.startdate];
                    [df setDateFormat:@"yyyy-MM-dd"];
                    if ([comparedate compare:[df dateFromString:tmpstartdate]]==NSOrderedAscending) {
                        tmpstartdate=[df stringFromDate:comparedate];
                        //tmpclasstime=classrecordobject.classtime;
                    }
                    
                }
            }
            
            
            
            //determine enddatestring
            if ([classrecordobject.startdate isEqualToString:@"TBD"]) {
                if (![tmpenddate isEqualToString:@"TBD"] ) {
                    tmpenddate=@"TBF";
                }
            }else if (![classrecordobject.startdate isEqualToString:@"TBD"] ) {
                if ([tmpenddate isEqualToString:@"TBD"]){
                    tmpenddate=@"TBF";
                }else if (![tmpenddate isEqualToString:@"TBF"]) {
                    //find end date
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    comparedate=[df dateFromString:classrecordobject.startdate];
                    [df setDateFormat:@"yyyy-MM-dd"];
                    if ([[df dateFromString:tmpenddate] compare:comparedate]==NSOrderedAscending) {
                        tmpenddate=[df stringFromDate:comparedate];
                    }
                }
                
            }
            
            
            //determine classdaystring
            if (![tmpclassday isEqualToString:@"TBF"]) {
                if ([classrecordobject.classday isEqualToString:@"TBD"]) {
                    if (![tmpclassday isEqualToString:@"TBD"]) {
                        tmpclassday=@"TBF";
                    }
                }else{
                    if ([tmpclassday isEqualToString:@"TBD"]) {
                        tmpclassday=@"TBF";
                    }else {
                        if (![tmpclassday isEqualToString:classrecordobject.classday]) {
                            tmpclassday=@"Multi";
                        }
                    }
                }
            }
            
            if (![tmpinstructor isEqualToString:@"TBF"]) {
                if ([classrecordobject.instructor isEqualToString:@"TBD"]) {
                    if (![tmpinstructor isEqualToString:@"TBD"]) {
                        tmpinstructor=@"TBF";
                    }
                }else{
                    if ([tmpinstructor isEqualToString:@"TBD"]) {
                        tmpinstructor=@"TBF";
                    }else {
                        if (![tmpinstructor isEqualToString:classrecordobject.instructor]) {
                            tmpinstructor=@"Multi";
                        }
                    }
                }
            }
            
            if (![tmpsinstructor isEqualToString:@"TBF"]) {
                if ([classrecordobject.sinstructor isEqualToString:@"TBD"]) {
                    if (![tmpsinstructor isEqualToString:@"TBD"]) {
                        tmpsinstructor=@"TBF";
                    }
                }else{
                    if ([tmpsinstructor isEqualToString:@"TBD"]) {
                        tmpsinstructor=@"TBF";
                    }else {
                        if (![tmpsinstructor isEqualToString:classrecordobject.sinstructor]) {
                            tmpsinstructor=@"Multi";
                        }
                    }
                }
            }
            
            if (![tmpclassroom isEqualToString:@"TBF"]) {
                if ([classrecordobject.classroom isEqualToString:@"TBD"]) {
                    if (![tmpclassroom isEqualToString:@"TBD"]) {
                        tmpclassroom=@"TBF";
                    }
                }else{
                    if ([tmpclassroom isEqualToString:@"TBD"]) {
                        tmpclassroom=@"TBF";
                    }else {
                        if (![tmpclassroom isEqualToString:classrecordobject.classroom]) {
                            tmpclassroom=@"Multi";
                        }
                    }
                }
            }
            
            if (![tmpclasstime isEqualToString:@"TBF"]) {
                if ([classrecordobject.classtime isEqualToString:@"TBD"]) {
                    if (![tmpclasstime isEqualToString:@"TBD"]) {
                        tmpclasstime=@"TBF";
                    }
                }else{
                    if ([tmpclasstime isEqualToString:@"TBD"]) {
                        tmpclasstime=@"TBF";
                    }else {
                        if (![tmpclasstime isEqualToString:classrecordobject.classtime]) {
                            tmpclasstime=@"Multi";
                        }
                    }
                }
            }
        }
    }
    
    NSString *nsstartdatestring;
    NSString *nsenddatestring;
    
    if (![tmpstartdate isEqualToString:@"TBD"]){
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *date=[df dateFromString:tmpstartdate];
        date=[df dateFromString:tmpstartdate];
        [df setDateFormat:@"dd-MMM-yyyy"];
        nsstartdatestring=[df stringFromDate:date];
        
    }else{
        nsstartdatestring=tmpstartdate;
    }
    
    if (![tmpenddate isEqualToString:@"TBD"] && ![tmpenddate isEqualToString:@"TBF"]){
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *date=[df dateFromString:tmpenddate];
        date=[df dateFromString:tmpenddate];
        [df setDateFormat:@"dd-MMM-yyyy"];
        nsenddatestring=[df stringFromDate:date];
        
    }else{
        nsenddatestring=tmpenddate;
    }
    
    return [[EnrollmentRecord alloc]initEnrollmentWithstudentkey:PopoverClass.studentkey andenrollmentkey:PopoverClass.enrollmentkey andenrollmentdate:@"" andschedulekey:@"" andsubject:PopoverClass.subject andlevelmain:tmplevelmain andlevelctm:tmplevelctm andgrade:@"" andstartdate:tmpstartdate andnoofclass:@"" andenddate:tmpenddate andclassday:tmpclassday andclasstime:tmpclasstime andinstructor:tmpinstructor andenrollmentfee:@"" andtuitionfee:@"" andoneoffdiscount:@"" andrecursivediscount:@"" andoneoffpercentagediscount:@"" andlatefee:@"" andtotalfee:@"" andpaid:@"" anddropclassstatus:@"" anddropclassdate:@"" andremarks:@"" anddraft:@"" andinvoiceremarks:@"" andclassroom:tmpclassroom andautorenew:@"" andstatus:@"" andreverseadjustment:@"" instructorfullname:@"" subjectfullname:@"" validity:@"" makeup_quota:@"" makeup_quota_used:@"" paymentrecords:nil promotiondiscountrecords:nil classrecords:nil sinstructor:tmpsinstructor transferredfromenrollmentkey:@"" enrollmentmode:@"" standardnoofclassormonth:@"" couponrecords:nil invoicenumber:nil invoiceprefix:nil locked:NO billdate:nil resumeclassdate:@"" outstandingmakeupclasses:@""];
}



-(void) adjusttablesize
{
    [self stopAudioPlaying];
    float tableheight;
    float tablewidth;
    
    
    tableheight=maxPopupHeight-keyboardheight;
    
    if (showInstructorTable){
        tablewidth=popoverwidth+instructortablewidth;
    }else if (showClassroomTable){
        tablewidth=popoverwidth+classroomtablewidth;
    }else if (showNatureTable){
        tablewidth=popoverwidth+naturetablewidth;
    }else if (showLessonNumberTable){
        tablewidth=popoverwidth+lessonnumbertablewidth;
    }else{
        tablewidth=popoverwidth;
    }
    
    classtablebottomconstraint.constant=keyboardheight;
    //[ClassPopoverTable setFrame:CGRectMake(0, 44+20, popoverwidth, tableheight-44-20)];
    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    //self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
    
    if (showInstructorTable){
        [InstructorTable setFrame:CGRectMake(0, 44+88+20+3, instructortablewidth, tableheight-44-88-20-3)];
        InstructorTableMasterView.hidden=NO;
        ClassroomTableMasterView.hidden=YES;
        NatureTableMasterView.hidden=YES;
        LessonNumberTableMasterView.hidden=YES;
        
        if(filteredActiveInstructorArray.count>0){
            presetRow=[MyClass returnInstructorIndexWithInstructorArray:filteredActiveInstructorArray username:workingClass.makeupinstructor activeinstructor:YES defaultzeroifnotfound:YES];
            [InstructorTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        
    }else if (showClassroomTable){
        [ClassroomTable setFrame:CGRectMake(0, 44+88+20+3, classroomtablewidth, tableheight-44-88-20-3)];
        InstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=NO;
        NatureTableMasterView.hidden=YES;
        LessonNumberTableMasterView.hidden=YES;
        
        if(FilteredClassroomArray.count>0){
            presetRow=[MyClass returnClassroomIndexWithClassroomArray:FilteredClassroomArray classroom:workingClass.makeupclassroom defaultzeroifnotfound:YES];
            [ClassroomTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        
    }else if (showNatureTable){
        [NatureTable setFrame:CGRectMake(0, 44+44+20, naturetablewidth, tableheight-44-44-20)];
        InstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        NatureTableMasterView.hidden=NO;
        LessonNumberTableMasterView.hidden=YES;
    }else if (showLessonNumberTable){
        lessonnumbertablebottomconstraint.constant=keyboardheight;
//        [NatureTable setFrame:CGRectMake(0, 44+44+20, naturetablewidth, tableheight-44-44-20)];
        InstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        NatureTableMasterView.hidden=YES;
        LessonNumberTableMasterView.hidden=NO;
    }
    
    //[self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
}


-(void)setTBDDatebuttonpressed:(id)sender
{
    workingClass.startdate=@"TBD";
    workingClass.classtime=@"TBD";
    workingClass.classday=@"TBD";
    
    if ([classhasextendedclass isEqualToString:@"Yes"]) {
        UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"This class time has been used to extend other class"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missinginput dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missinginput addAction:OKAction];
        //[self presentViewController:missinginput animated:YES completion:nil];
        [MyClass presentViewController:missinginput View:self];
    }else{
        workingClass.attendance=globalvariables.centerrecord.defaultattendancestatus;
        
        //[self updatefreescheduleclassarraywithfield:@"DateTime" value:@"TBD TBD"];
        
        workingClass.makeupattendance=@"";
        showMakeupSection=NO;
        showMakeupRemarks=NO;
        workingClass.makeupdate=@"";
        workingClass.makeuptime=@"";
        workingClass.makeupinstructor=@"";
        workingClass.makeupclassroom=@"";
        workingClass.absentmakeupreason=@"";
        absentMakeupReasonLabel.text=@"";
        showDatePicker=NO;
        
        //[self storeTmpField];
        [ClassPopoverTable reloadData];
        //[ClassPopoverTable setFrame:CGRectMake(0, 0, 320, ClassPopoverTable.contentSize.height)];
        
        [self adjusttablesize];
        //[masterView setContentSize:CGSizeMake(320, ClassPopoverTable.contentSize.height)];// EnrollmentPopoverTable.bounds.size];
    }

}


-(BOOL) updateClassWithClassRecord:(ClassRecord *)classrecord Action:(NSString *)action updatelaterenrollmentslevel:(BOOL)updatelaterenrollmentslevel
{

    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:@"updateenrollmentclass" forKey:@"postaction"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:PopoverClass.subject forKey:@"subject"];
    [dictionary setValue:PopoverClass.studentkey forKey:@"studentkey"];
    [dictionary setValue:PopoverClass.enrollmentkey forKey:@"enrollmentkey"];
    [dictionary setValue:classrecord.classkey forKey:@"classkey"];
    
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"classtime" NewValue:classrecord.classtime OldValue:PopoverClass.classtime Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"startdate" NewValue:classrecord.startdate OldValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:PopoverClass.startdate] Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"instructor" NewValue:classrecord.instructor OldValue:PopoverClass.instructor Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"sinstructor" NewValue:classrecord.sinstructor OldValue:PopoverClass.instructor Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"classroom" NewValue:classrecord.classroom OldValue:PopoverClass.classroom Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"classday" NewValue:classrecord.classday OldValue:PopoverClass.classday Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"attendance" NewValue:classrecord.attendance OldValue:PopoverClass.attendance Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"makeupattendance" NewValue:classrecord.makeupattendance OldValue:PopoverClass.makeupattendance Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"makeupdate" NewValue:classrecord.makeupdate OldValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:PopoverClass.makeupdate] Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"makeuptime" NewValue:classrecord.makeuptime OldValue:PopoverClass.makeuptime Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"makeupinstructor" NewValue:classrecord.makeupinstructor OldValue:PopoverClass.makeupinstructor Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"makeupsinstructor" NewValue:classrecord.makeupsinstructor OldValue:PopoverClass.makeupinstructor Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"makeupclassroom" NewValue:classrecord.makeupclassroom OldValue:PopoverClass.makeupclassroom Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"absentmakeupreason" NewValue:classrecord.absentmakeupreason OldValue:PopoverClass.absentmakeupreason Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"remarks" NewValue:classrecord.remarks OldValue:PopoverClass.remarks Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"allclassremarks" NewValue:classrecord.allclassremarks OldValue:PopoverClass.allclassremarks Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"parentnote" NewValue:classrecord.parentnote OldValue:PopoverClass.parentnote Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"levelmain" NewValue:classrecord.levelmain OldValue:PopoverClass.levelmain Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"levelctm" NewValue:classrecord.levelctm OldValue:PopoverClass.levelctm Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"leavenaturelistkey" NewValue:classrecord.leavenaturelistkey OldValue:PopoverClass.leavenaturelistkey Action:@"Edit"];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"lesson" NewValue:classrecord.lesson OldValue:PopoverClass.lesson Action:@"Edit"];
    if (updatelaterenrollmentslevel) {
        [dictionary setValue:@"Yes" forKey:@"updatelaterenrollmentslevel"];
    }
    
    if ([dictionary objectForKey:@"levelmain"] || [dictionary objectForKey:@"levelctm"]) {
        if (![dictionary objectForKey:@"startdate"]) {
            [dictionary setValue:classrecord.startdate forKey:@"startdate"];
        }
        
        if (![dictionary objectForKey:@"classtime"]) {
            [dictionary setValue:classrecord.classtime forKey:@"classtime"];
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
                             
- (BOOL) noTBDclasswithclassroomarray:(NSMutableArray *)classroomarray
{
    for (int i=0; i<classroomarray.count; i++) {
        if ([((ClassroomRecord *)[classroomarray objectAtIndex:i]).classroom isEqualToString:@"TBD"]) {
            return NO;
        }
    }
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView==ClassPopoverTable) {
        if (section==5) {
            if (showMakeupSection) {
                return 44;
            }else{
                return CGFLOAT_MIN;
            }
        }else{
            return 44;
        }
    }else if (tableView==LessonNumberTable){
        return 44;
    }else{
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView numberOfSections]-1==section) {
        return 30;
    }else{
        return 1;
    }
}

//-(BOOL) showLessonParameter
//{
//    if(!globalvariables.centerrecord.enablelessonnumber){
//        return NO;
//    }
//
//    NSMutableDictionary *lessonnumberdict=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingClass.subject centerkey:globalvariables.centerrecord.centerkey]).lessonnumberDict;
//
//    if (lessonnumberdict.count==0) {
//        return NO;
//    }
//    return YES;
//}

-(void) InstructorButtonPressed:(UIButton *)sender
{
    //popup make up information
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    instructorimagepopover = (InstructorImageGridViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"InstructorImageGridViewController"];
    instructorimagepopover.delegate=self;
    instructorimagepopover.instructorArray=ActiveInstructorArray;
    
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
    
    if ([selectedItem isEqualToString:@"Instructor"]) {
        if (![workingClass.instructor isEqualToString:username]) {
            workingClass.instructor=username;
            //showInstructorPicker=NO;
            showInstructorTable=NO;
            [InstructorTable reloadData];
            
            //[self storeTmpField];
            [ClassPopoverTable reloadData];
            
            [self adjusttablesize];
            //[self updatefreescheduleclassarraywithfield:@"Instructor" value:workingClass.instructor];
            
        }
    }else if ([selectedItem isEqualToString:@"SInstructor"]) {
        if (![workingClass.sinstructor isEqualToString:username]) {
            workingClass.sinstructor=username;
            //showInstructorPicker=NO;
            showInstructorTable=NO;
            [InstructorTable reloadData];
            
            //[self storeTmpField];
            [ClassPopoverTable reloadData];
            
            [self adjusttablesize];
            //[self updatefreescheduleclassarraywithfield:@"Instructor" value:workingClass.instructor];
            
        }
    }else if ([selectedItem isEqualToString:@"MakeupInstructor"]){
        if (![workingClass.makeupinstructor isEqualToString:username]) {
            workingClass.makeupinstructor=username;
            //showMakeupInstructorPicker=NO;
            showInstructorTable=NO;
            [InstructorTable reloadData];
            
            //[self storeTmpField];
            [ClassPopoverTable reloadData];
            
            [self adjusttablesize];
            //[self updatefreescheduleclassarraywithfield:@"MakeupInstructor" value:workingClass.makeupinstructor];
        }
    }else if ([selectedItem isEqualToString:@"MakeupSInstructor"]){
        if (![workingClass.makeupsinstructor isEqualToString:username]) {
            workingClass.makeupsinstructor=username;
            //showMakeupInstructorPicker=NO;
            showInstructorTable=NO;
            [InstructorTable reloadData];
            
            //[self storeTmpField];
            [ClassPopoverTable reloadData];
            
            [self adjusttablesize];
            //[self updatefreescheduleclassarraywithfield:@"MakeupInstructor" value:workingClass.makeupinstructor];
        }
    }
}

-(void) attendancebuttontouchupinside:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{attendanceringview.alpha = 0.0;} completion:^(BOOL finished){ [attendanceringview removeFromSuperview]; }];
    attendanceringview=nil;
    ClassPopoverTable.scrollEnabled=TRUE;
    [ClassPopoverTable deselectRowAtIndexPath:[ClassPopoverTable indexPathForSelectedRow] animated: YES];
}

-(void) attendancebuttontouchdown:(UIButton *)sender
{
    if (attendanceringview) {
        [attendanceringview removeFromSuperview];
        attendanceringview=nil;
    }else{
        ClassPopoverTable.scrollEnabled=FALSE;
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:ClassPopoverTable];
        NSIndexPath *indexpath =[ClassPopoverTable indexPathForRowAtPoint:point];
        [ClassPopoverTable selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        UIView *windowview = self.view;
        while (windowview.superview != Nil) {
            windowview = windowview.superview;
        }
        
        
        if (indexpath.section==4) {
            attendancebuttonarray=[[NSMutableArray alloc]initWithArray:regularattendancebuttonarray];
            attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:workingClass.attendance highlightbutton:workingClass.attendance attendancebuttonarray:attendancebuttonarray inview:windowview size:@"small"];
            if ([workingClass.startdate isEqualToString:@"TBD"] || [workingClass.classtime isEqualToString:@"TBD"] || [workingClass.startdate isEqualToString:@""] || [workingClass.classtime isEqualToString:@""]) {
                
                attendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnabsentattendancebuttonarray]];
                attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:workingClass.attendance highlightbutton:workingClass.attendance attendancebuttonarray:attendancebuttonarray inview:windowview size:@"small"];
            }
            
        }else{
            attendancebuttonarray=[[NSMutableArray alloc]initWithArray:makeupattendancebuttonarray];
            attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:workingClass.makeupattendance highlightbutton:workingClass.makeupattendance attendancebuttonarray:attendancebuttonarray inview:windowview size:@"small"];
            
            if ([workingClass.makeuptime isEqualToString:@""]) {
                
                
                attendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnmakeupabsentattendancebuttonarray]];
                attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:workingClass.makeupattendance highlightbutton:workingClass.makeupattendance attendancebuttonarray:attendancebuttonarray inview:windowview size:@"small"];
            }
        }
        
        NSArray * windows = [[UIApplication sharedApplication] windows];
        UIWindow* win0 = [windows objectAtIndex:0];
        
        [win0 addSubview:attendanceringview];
        [win0 bringSubviewToFront:attendanceringview];
        
        lasttouchedsector=0;
    }
}

-(void) passinstructorlistfromgrid:(NSString *)instructorlist
{
    //delegate not used
}

-(void) closeinstructortable
{
    showInstructorTable=NO;
    [ClassPopoverTable deselectRowAtIndexPath:[ClassPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) closelessonnumbertable
{
    showLessonNumberTable=NO;
    [ClassPopoverTable deselectRowAtIndexPath:[ClassPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) closeclassroomtable
{
    showClassroomTable=NO;
    [ClassPopoverTable deselectRowAtIndexPath:[ClassPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) closenaturetable
{
    showNatureTable=NO;
    [ClassPopoverTable deselectRowAtIndexPath:[ClassPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    if (searchBar==classroomsearchbar){
        if ([searchText isEqualToString:@""]) {
            FilteredClassroomArray=[[NSMutableArray alloc]initWithArray:AvailableClassroomArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.classroom contains[c] %@",searchText];
            FilteredClassroomArray=[[NSMutableArray alloc]initWithArray:[AvailableClassroomArray filteredArrayUsingPredicate:predicate]];
        }
        [ClassroomTable reloadData];
        [ClassroomTable setContentOffset:CGPointZero animated:YES];
    }else{
        if ([searchText isEqualToString:@""]) {
            filteredActiveInstructorArray=[[NSMutableArray alloc]initWithArray:ActiveInstructorArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or self.username contains[c] %@",searchText,searchText,searchText];
            filteredActiveInstructorArray=[[NSMutableArray alloc]initWithArray:[ActiveInstructorArray filteredArrayUsingPredicate:predicate]];
        }
        [InstructorTable reloadData];
        [InstructorTable setContentOffset:CGPointZero animated:YES];
    }
}

-(void) checkvalidatemessage
{
    [MyClass checkValidateMessageWithClassValidateMessage:classvalidatemessage ClassValidateStatus:classvalidatestatus View:self];
}

-(void) validationPassed:(BOOL)pass
{
    if(pass){
        if ([self updateAllLaterEnrollmentsLevel]) {
            UIAlertController *disablealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Do you want to update the level for all later classes and update the tuition fee for those unpaid enrollments?"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [MyClass loadingindicatorwithoption:@"start" color:@"white"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self updateClassWithLaterEnrollmentsLevelUpdate:YES];
                });
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"No"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [MyClass loadingindicatorwithoption:@"start" color:@"white"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self updateClassWithLaterEnrollmentsLevelUpdate:NO];
                });
            }];
            
            [disablealert addAction:OKAction];
            [disablealert addAction:CancelAction];
            
            [MyClass presentViewController:disablealert View:self];
        }else{
            [MyClass loadingindicatorwithoption:@"start" color:@"white"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self updateClassWithLaterEnrollmentsLevelUpdate:NO];
            });
        }
    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }
}

-(BOOL) updateAllLaterEnrollmentsLevel
{
    NSString *tmplevelmain;
    NSString *tmplevelctm;
    
    if ([MyClass isEyeLevelMathWithSubject:workingClass.subject]) {
            if ([tmpLevel isEqualToString:@""]) {
                tmplevelmain=@"TBD";
                tmplevelctm=@"";
            }else if ([tmpLevel isEqualToString:@"TBD"] || [tmpLevel isEqualToString:@"DT"]) {
                tmplevelmain=tmpLevel;
                tmplevelctm=@"";
            }else{
                NSRange range=[tmpLevel rangeOfString:@"/"];
                if (range.location==NSNotFound) {
                    tmplevelmain=[tmpLevel substringFromIndex:3];
                    tmplevelctm=@"";
                }else{
                    tmplevelmain=[tmpLevel substringWithRange:NSMakeRange(3, range.location-3)];
                    tmplevelctm=[tmpLevel substringFromIndex:range.location+4];
                }
            }
    }else{
        if ([tmpLevel isEqualToString:@""]) {
            tmplevelmain=@"TBD";
        }else{
            tmplevelmain=tmpLevel;
        }
        tmplevelctm=@"";
    }
    
    if (![tmplevelctm isEqualToString:PopoverClass.levelctm] || ![tmplevelmain isEqualToString:PopoverClass.levelmain]) {
        if ([self.delegate isDifferentLevelWithLaterEnrollmentWithStartDate:[NSString stringWithFormat:@"%@ %@",workingClass.startdate,workingClass.classtime] classkey:PopoverClass.classkey subject:workingClass.subject levelmain:tmplevelmain levelctm:tmplevelctm]) {
            return TRUE;
        }
    }
    
    return FALSE;
}


-(void) showsidewindowwithwindow:(NSString *)windowname
{
    showInstructorTable=[windowname isEqualToString:@"showInstructorTable"];
    showClassroomTable=[windowname isEqualToString:@"showClassroomTable"];
    showNatureTable=[windowname isEqualToString:@"showNatureTable"];
    showLessonNumberTable=[windowname isEqualToString:@"showLessonNumberTable"];
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    NSString *selecteddatestring=[selecteddatearray firstObject];
    
    if([selectedItem isEqualToString:@"DateTime"]){
        if (![workingClass.startdate isEqualToString:selecteddatestring]) {

            workingClass.startdate=selecteddatestring;
            
            workingClass.classday = [MyClass convertDateFormatWithDate:workingClass.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE"];
            //[self updatefreescheduleclassarraywithfield:@"DateTime" value:tmpStartDateTime];
            
            workingClass.attendance=globalvariables.centerrecord.defaultattendancestatus;
            workingClass.makeupattendance=@"";
            showMakeupSection=NO;
            showMakeupRemarks=NO;
            workingClass.makeuptime=@"";
            workingClass.makeupdate=@"";
            workingClass.makeupclassroom=@"";
            workingClass.makeupinstructor=@"";
            workingClass.absentmakeupreason=@"";
            
            //[ClassPopoverTable reloadData];
            
            [MyClass reloadTableWithTableview:ClassPopoverTable ExceptIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
            
            
            [self adjusttablesize];
            
        }
    }else if([selectedItem isEqualToString:@"MakeupDateTime"]){
        if (![workingClass.makeupdate isEqualToString:selecteddatestring]) {
            
            workingClass.makeupdate=selecteddatestring;
            //tmpMakeupDateTime=[NSString stringWithFormat:@"%@ %@",selecteddatestring,[tmpMakeupDateTime substringFromIndex:12]];
            workingClass.makeupattendance=globalvariables.centerrecord.defaultattendancestatus;
            //[self updatefreescheduleclassarraywithfield:@"MakeupDateTime" value:tmpMakeupDateTime];
            //tmpStartDateTime=[NSString stringWithFormat:@"%@ %@",selecteddatestring,[tmpStartDateTime substringFromIndex:12]];
            
            [MyClass reloadTableWithTableview:ClassPopoverTable ExceptIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]];
            [self adjusttablesize];
        }
    }
}

- (void)returnCalendarYear:(NSString *)year {
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL) startAudioSession
{
    // Prepare the audio session
    NSError *error;
    AVAudioSession *session = [AVAudioSession sharedInstance];

    if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
    {
        NSLog(@"Error setting session category: %@", error.localizedFailureReason);
        return NO;
    }


    if (![session setActive:YES error:&error])
    {
        NSLog(@"Error activating audio session: %@", error.localizedFailureReason);
        return NO;
    }

    return session.isInputAvailable;
}




- (void)stopAudioRecording:(id)sender {
    if (audioRecorder.currentTime<1 || !audioRecorder.isRecording) {
        [self cancelAudioRecording];
    }else{
        [self stopAudioRecording];
    }
}

- (void)startAudioRecording:(id)sender {
    [MyClass playBeepSoundWithType:@"audiostart"];
    [impactFeedbackGenerator impactOccurred];
    //[self stopAudioPlaying];
    [self startAudioRecording];
}

- (void)audioPanGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    if (audioRecorder.recording) {
        CGPoint touchpoint= [recognizer locationInView:textinputbox];
        CGRect cancellationframe = [textinputbox convertRect:slideToCancelTitle.frame fromView:slideToCancelTitle.superview];
        //NSLog(@"Touchpoint: %f:%f Frame:%f:%f:%f:%f",touchpoint.x,touchpoint.y,cancellationframe.origin.x,cancellationframe.origin.y,cancellationframe.size.width,cancellationframe.size.height);
        if (recognizer.state!=UIGestureRecognizerStateEnded) {
            if (touchpoint.x<(cancellationframe.size.width+cancellationframe.origin.x) && touchpoint.x>cancellationframe.origin.x && touchpoint.y>cancellationframe.origin.y && touchpoint.y<(cancellationframe.origin.y+cancellationframe.size.height)) {
                //[self cancelAudioRecording];
                [audioRecordingImage setImage:[UIImage imageNamed:@"trashbin_red.png"]];
                slideToCancelTitle.font=[UIFont systemFontOfSize:16];
                slideToCancelTitle.textColor=[UIColor lightGrayColor];
            }else{
                [audioRecordingImage setImage:[UIImage imageNamed:@"audio_recording.png"]];
                slideToCancelTitle.font=[UIFont systemFontOfSize:17];
                slideToCancelTitle.textColor=[UIColor grayColor];
            }
        }else{
            if (touchpoint.x<(cancellationframe.size.width+cancellationframe.origin.x)) {
                [self cancelAudioRecording];
            }else{
                [self stopAudioRecording];
            }
        }
    }
}

- (BOOL) startAudioRecording
{
    if (audioRecorder.isRecording) {
        return YES;
    }
    
    NSError *error;

    // Recording settings
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];

    [settings setValue: [NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
    [settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    [settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [settings setValue:  [NSNumber numberWithInt: AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex: 0];
    NSString* filePath = [documentPath stringByAppendingPathComponent:@"tmpischool"];
    filePath = [filePath stringByAppendingPathComponent:[MyClass returnAudioRecordingFileName]];
    NSURL *audioURL = [NSURL fileURLWithPath:filePath];

    // Create recorder
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioURL settings:settings error:&error];
    if (!audioRecorder)
    {
        NSLog(@"Error establishing recorder: %@", error.localizedFailureReason);
        return NO;
    }

    // Initialize degate, metering, etc.
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
    //self.title = @"0:00";

    if (![audioRecorder prepareToRecord])
    {
        NSLog(@"Error: Prepare to record failed");
        return NO;
    }
    
    // Set a timer to monitor levels, current time
    audioRecorderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];

    workingClass.voiceparentnotemessage.photoarray=[[NSMutableArray alloc]initWithObjects:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:nil Width:0 Height:0 FileType:@"audio" InternalURL:audioURL FileName:@"" ThumbnailURL:@""],nil];
    recordingStatusView.hidden=NO;
    [audioRecordingImage setImage:[UIImage imageNamed:@"audio_recording.png"]];
    slideToCancelTitle.font=[UIFont systemFontOfSize:17];
    slideToCancelTitle.textColor=[UIColor grayColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![audioRecorder record])
        {
            NSLog(@"Error: Record failed");
            //return NO;
        }

        NSLog(@"Audio recording started");
        //return YES;
    });
    return YES;
}

-(void) updateMeters
{
    NSTimeInterval duration=audioRecorder.currentTime;
    NSInteger second=(NSInteger)duration%60;
    NSInteger minute=duration/60;
    
    recordingDuration.text=[NSString stringWithFormat:@"%ld:%02li",(long)minute,(long)second];
}

-(void) deleteAudioParentNote:(id)sender
{
    [self stopAudioPlaying];
    workingClass.voiceparentnotemessage.photoarray=[[NSMutableArray alloc]init];
    workingClass.parentnote=@"";
    [ClassPopoverTable reloadData];
}

- (void) cancelAudioRecording
{
    NSLog(@"Audio recording cancelled");
    [impactFeedbackGenerator impactOccurred];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [impactFeedbackGenerator impactOccurred];
    });
    [MyClass playBeepSoundWithType:@"audiocancel"];
    recordingStatusView.hidden=YES;
    [audioRecorder stop];
    audioRecorder=nil;
    [audioRecorderTimer invalidate];
    workingClass.voiceparentnotemessage.photoarray=[[NSMutableArray alloc]init];
    //[workingClass.voiceparentnotemessage.photoarray removeAllObjects];
    //sendinstantmessagebutton.enabled=[self enableSendButton];
}

- (void) stopAudioRecording
{
    if (audioRecorder.isRecording) {
        NSLog(@"Audio recording stopped");
        [impactFeedbackGenerator impactOccurred];
        recordingStatusView.hidden=YES;
        ((MessagePhotoRecord *)[workingClass.voiceparentnotemessage.photoarray firstObject]).height=audioRecorder.currentTime;
        //workingClass.parentnote=@"";
        [audioRecorder stop];
        audioRecorder=nil;
        [audioRecorderTimer invalidate];
        //informationupdated=TRUE;
        //recordAudioButton.enabled=NO;
        [MyClass playBeepSoundWithType:@"audiostop"];
        //[self sendmessagebuttonpressed];
        [ClassPopoverTable reloadData];
    }else{
        [self cancelAudioRecording];
    }
}

-(void) audioSliderValueChanged:(UISlider *)sender
{
    MyTableViewCell *cell=[ClassPopoverTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];
    if (audioPlayer) {
        [audioPlayer stop];
        CGFloat secondToPlay=sender.value;
        audioPlayer.currentTime=secondToPlay;
        [audioPlayer play];
        [cell.button4 setImage:[UIImage imageNamed:@"pauseicon.png"] forState:UIControlStateNormal];
    }else{
        [self playAudioButtonPressed:cell.button4];
    }
}

-(void) playAudioButtonPressed:(UIButton *)sender
{
    MyTableViewCell *newcell=[ClassPopoverTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sender.tag]];

    if ([newcell.slider1 isEqual:selectedUIslide]) {
        if (audioPlayer.playing) {
            [audioPlayer stop];
            //[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
            [sliderTimer invalidate];
            [newcell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
        }else{
            [newcell.button4 setImage:[UIImage imageNamed:@"pauseicon.png"] forState:UIControlStateNormal];
            [audioPlayer play];
            //[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
            sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
        }
    }else{
        //[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        MessagePhotoRecord *obj=[workingClass.voiceparentnotemessage.photoarray firstObject];

        NSURL *audioURL;
        if (obj.internalurl) {
            audioURL=obj.internalurl;
        }else{
            NSString *strURL=[NSString stringWithFormat:@"%@messageimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,obj.messagephotourl];
            audioURL = [NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        }
        
        NSData *data = [NSData dataWithContentsOfURL:audioURL];
        
        audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
        audioPlayer.delegate=self;
        audioPlayer.currentTime=newcell.slider1.value;

        
        selectedUIslide=newcell.slider1;
        
        [newcell.button4 setImage:[UIImage imageNamed:@"pauseicon.png"] forState:UIControlStateNormal];
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeDefault options:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetoothHFP | AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];
        [audioPlayer play];
        newcell.slider1.maximumValue = audioPlayer.duration;
        //[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    }
}

- (void)updateSlider {
    // Update the slider about the music time
    selectedUIslide.value = audioPlayer.currentTime;
    NSLog(@"sliderTimer Running");
}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [sliderTimer invalidate];
        MyTableViewCell *cell=[ClassPopoverTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedUIslide.tag]];
        [cell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
        cell.slider1.value=cell.slider1.minimumValue;
        audioPlayer=nil;
        selectedUIslide=nil;
        //[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
}

-(void) stopAudioPlaying
{
    if (audioPlayer) {
        if (audioPlayer.playing) {
            [audioPlayer stop];
            [sliderTimer invalidate];
            MyTableViewCell *previouscell=[ClassPopoverTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:selectedUIslide.tag]];
            [previouscell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
        }
        audioPlayer=nil;
        selectedUIslide=nil;
    }
    //[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

-(void) sendaudioparentnotewithstudentkeys:(NSArray *)studentclasskeys
{
    NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *recipientgroup=[[NSArray alloc]init];
    NSMutableArray *classkeydicts=[[NSMutableArray alloc]init];
    
    keys=[NSArray arrayWithObjects:@"group",@"recipient",nil];
    
    for (int i=0; i<studentclasskeys.count; i++) {
        NSString *studentkey=[[studentclasskeys objectAtIndex:i] objectForKey:@"studentkey"];
        NSString *classkey=[[studentclasskeys objectAtIndex:i] objectForKey:@"classkey"];
        
        values=[NSArray arrayWithObjects:@"student",studentkey, nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
        
        [classkeydicts addObject:@{@"classkey":classkey}];
    }

    recipientgroup = [NSArray arrayWithArray:arrayOfDicts];
    
    [dictionary setValue:@"updateoutboxmessage2" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:globalvariables.username forKey:@"composer"];
    [dictionary setValue:globalvariables.username forKey:@"sender"];
    [dictionary setValue:@"Student" forKey:@"recipienttype"];
    [dictionary setValue:@"Teacher Note" forKey:@"messagetype"];
    [dictionary setValue:@"" forKey:@"messageenglish"];
    [dictionary setValue:@"" forKey:@"messagechinese"];
    [dictionary setValue:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"] forKey:@"messagestarttime"];
    [dictionary setValue:@"" forKey:@"notificationqueuedflag"];
    [dictionary setValue:@"N" forKey:@"automessageflag"];
    [dictionary setValue:@"N" forKey:@"broadcastmessageflag"];
    [dictionary setValue:@"A" forKey:@"channel"];
    [dictionary setValue:@"" forKey:@"status"];
    [dictionary setValue:recipientgroup.count>0?recipientgroup:@"" forKey:@"recipientgroup"];
    [dictionary setValue:@"Yes" forKey:@"imagechanged"];
    [dictionary setValue:@"No" forKey:@"hotnews"];
    [dictionary setValue:@"" forKey:@"hn_expiry_date"];
    [dictionary setValue:@"Add" forKey:@"action"];
    [dictionary setValue:[NSArray arrayWithArray:classkeydicts] forKey:@"parentnoteclasskeys"];
    
    __block BOOL result=FALSE;
    __block NSData *returndata;
    
    [MyClass callMultipartPOSTwithDict:dictionary photoArray:workingClass.voiceparentnotemessage.photoarray completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            result=TRUE;
            returndata=responseObject;
        }
    }];
    
    if (result) {
        //NSString *resString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:returndata options:kNilOptions error:nil];
        [MyClass clearTmpDirectoryContent];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        
        workingClass.voiceparentnotemessage.photoarray=[[NSMutableArray alloc]init];

        [self.delegate dismissClassPopoverVC];
    }else{
         //NSLog(@"Error: %@", error);
         [MyClass loadingindicatorwithoption:@"stop" color:nil];
         [MyClass showconnectionlostdialogbox];
        
    }
    
    /*
    dictionary=[MyClass addchecksumparameterwithdictionary:dictionary];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:globalvariables.generalphpfullpath parameters:dictionary headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //add img data one by one
        if (workingClass.voiceparentnotemessage.photoarray.count>0) {
            for(int i=0; i<[workingClass.voiceparentnotemessage.photoarray count];i++)
            {
                MessagePhotoRecord *object=[workingClass.voiceparentnotemessage.photoarray objectAtIndex:i];
                
                NSData *audioData = [[NSData alloc]initWithContentsOfURL:object.internalurl];
                NSString *fileextension= [[object.internalurl lastPathComponent] substringFromIndex: [[object.internalurl lastPathComponent] length] - 3];
                [formData appendPartWithFileData:audioData name:[NSString stringWithFormat:@"audio%d",0] fileName:[NSString stringWithFormat:@"audio%d.%@",0,fileextension] mimeType:@"audio/mpeg"];
                
            }
        }
        
        
    } progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        //NSString *resString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [MyClass clearTmpDirectoryContent];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        
        workingClass.voiceparentnotemessage.photoarray=[[NSMutableArray alloc]init];

        [self.delegate dismissClassPopoverVC];
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        //NSLog(@"Error: %@", error);
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        [MyClass showconnectionlostdialogbox];
    }];*/
}

@end
