//
//  MakeupPopoverViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 5/7/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "MakeupPopoverViewController.h"
#import "ClassTimeTableViewController.h"
#import "MyClass.h"
#import "MyTableViewCell.h"

@interface MakeupPopoverViewController ()

@end

@implementation MakeupPopoverViewController
@synthesize MakeupToolBar;
@synthesize PopoverClassRecord,PopoverDetailsClassRecord,PopoverLessonAndClassRecord;
@synthesize PopoverOption,JSONArray;
@synthesize MasterView,pickerViewmenu,hourPickerViewMenu,minutePickerViewMenu,myPickerView;
@synthesize FreeScheduleClassArray,FreeScheduleClassObject;

#define popoverwidth 320
#define instructortablewidth 300
#define classroomtablewidth 300
#define naturetablewidth 300
#define lessonnumbertablewidth 300
#define updatefollowinglessonsfieldstablewidth 300
#define maxPopupHeight self.view.frame.size.height
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
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    self.view.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:0.3];
    [self InitializeField];
    
//    UIBarButtonItem *resetButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Reset"] style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonPressed:)];
//    UIBarButtonItem *postponeButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Postpone"] style:UIBarButtonItemStylePlain target:self action:@selector(postponeButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
    doneButton.enabled=[self enableDoneButton];
//    NSArray *buttons;
    if ([PopoverOption isEqualToString:@"DailyScheduleLesson"]){
//        buttons =[NSArray arrayWithObjects:resetButton, flexibleSpaceBarButton, doneButton,nil];
        doneButton.hidden=NO;
        resetButton.hidden=YES;
//        postponeButton.hidden=YES;
        postponeButton.hidden=NO;
        deleteButton.hidden=NO;
    }else{
        doneButton.hidden=NO;
        resetButton.hidden=NO;
        postponeButton.hidden=NO;
        deleteButton.hidden=YES;
//        buttons =[NSArray arrayWithObjects:resetButton, flexibleSpaceBarButton,postponeButton,flexibleSpaceBarButton, doneButton,nil];
    }
//    [MakeupToolBar setItems:buttons animated:NO];
    
    if ([workingClass.schedulekey isEqualToString:@"-2"] || [((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingClass.subject centerkey:globalvariables.centerrecord.centerkey]).tuition_mode isEqualToString:@"Month"]) {
        postponeButton.enabled=NO;
    }
    
    [self createtables];
    
    df =[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    //[MyClass getLatestDataSetv2withParameters:@"calendar" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];

    hourPickerViewMenu=[[NSMutableArray alloc]init];
    minutePickerViewMenu=[[NSMutableArray alloc]init];

    [MyClass loadHourPickerViewMenu:hourPickerViewMenu];
    
    for (int i=0; i<60; i+=[globalvariables.centerrecord.classtimeinterval intValue]) {
        [minutePickerViewMenu addObject:[NSString stringWithFormat:@"%02i",i]];
    }
    
    updatefollowinglessonsfieldsoptions=[[NSMutableArray alloc]init];
    if (![((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingClass.subject centerkey:globalvariables.centerrecord.centerkey]).tuition_mode isEqualToString:@"Month"]) {
        [updatefollowinglessonsfieldsoptions addObject:@"Class Time"];
    }
    [updatefollowinglessonsfieldsoptions addObject:@"Instructor"];
    if(globalvariables.centerrecord.secondaryinstructor){
        [updatefollowinglessonsfieldsoptions addObject:@"Sec. Instructor"];
    }
    [updatefollowinglessonsfieldsoptions addObject:@"Classroom"];
    if([MyClass showLessonParameterWithSubject:workingClass.subject]){
        [updatefollowinglessonsfieldsoptions addObject:@"Lesson"];
    }
    [updatefollowinglessonsfieldsoptions addObject:@"Remarks"];
    updatefollowinglessonsfieldsarray=[[NSMutableArray alloc]initWithArray:updatefollowinglessonsfieldsoptions];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //add buttonarray
    
    makeupdtattendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnmakeupattendancebuttonarray]];
    leaveNatureArray=[MyClass retrieveLeaveNatureArrayWithFlushCacheData:NO];
    
    UIPanGestureRecognizer *panGesture;
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.delegate = self;
    [MakeupTable addGestureRecognizer:panGesture];
    
    UIImageView *activityImageView=[[UIImageView alloc]init];
    activityImageView.animationImages=[MyClass returnLoadingIndicatorAnimatedImageWithBaseColor:@"lightgray"];
    activityImageView.alpha=1.0;
    activityImageView.animationDuration=1.5;
    activityImageView.frame=CGRectMake(0,0,45,45);
    [activityImageView startAnimating];
    
    ailoadindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    ailoadindicator.alpha = 1.0;
    ailoadindicator.color=[UIColor clearColor];
    ailoadindicator.transform=CGAffineTransformMakeScale(1, 1);
    ailoadindicator.center = CGPointMake(popoverwidth/2-12,self.view.frame.size.height/2-7.5);
    ailoadindicator.hidesWhenStopped = YES;
    [ailoadindicator addSubview:activityImageView];
    
    
    ailoadview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, popoverwidth, self.view.frame.size.height)];
    ailoadview.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5];
    ailoadview.hidden=YES;
    [self.view addSubview:ailoadview];
    [ailoadview addSubview:ailoadindicator];
    
    optionsLabel.text=[[MyClass returntitlewithtitle:@"Options"] uppercaseString];
    
    [resetButton setTitle:[MyClass returntitlewithtitle:@"Reset"] forState:UIControlStateNormal];
    [postponeButton setTitle:[MyClass returntitlewithtitle:@"Postpone"] forState:UIControlStateNormal];
    [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    [deleteButton setTitle:[MyClass returntitlewithtitle:@"Delete"] forState:UIControlStateNormal];
    
}

-(void) startloadingindicator:(BOOL)start
{
    if(start){
        ailoadview.hidden=NO;
        [ailoadindicator startAnimating];
    }else{
        ailoadview.hidden=YES;
        [ailoadindicator stopAnimating];
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
            MakeupTable.scrollEnabled=TRUE;
            [MakeupTable deselectRowAtIndexPath:[MakeupTable indexPathForSelectedRow] animated: YES];
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
        NSIndexPath *selectedIndexPath = [MakeupTable indexPathForSelectedRow];
        [self updateattendancewithindexpath:selectedIndexPath value:((AttendanceButtonObject *)[attendancebuttonarray objectAtIndex:lasttouchedsector]).buttonname];
    }
}

-(void)updateattendancewithindexpath:(NSIndexPath *)indexpath value:(NSString *)value
{
    if (![value isEqualToString:workingClass.makeupattendance]) {
        workingClass.makeupattendance=value;
        [MakeupTable reloadData];
    }
}

-(void) attendancebuttontouchupinside:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{self->attendanceringview.alpha = 0.0;} completion:^(BOOL finished){ [self->attendanceringview removeFromSuperview]; }];
    attendanceringview=nil;
    MakeupTable.scrollEnabled=TRUE;
    [MakeupTable deselectRowAtIndexPath:[MakeupTable indexPathForSelectedRow] animated: YES];
}

-(BOOL) editclassforpaidenrollment
{
    ClassScheduleRecord *obj;
    if ([PopoverOption isEqualToString:@"DailyScheduleLesson"]) {
        for (int i=0; i<PopoverLessonAndClassRecord.classScheduleRecordArray.count; i++) {
            obj=[PopoverLessonAndClassRecord.classScheduleRecordArray objectAtIndex:i];
            if (obj.enrollmentpaid && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editclassforpaidenrollment) {
                return FALSE;
            }
        }
    }
    return TRUE;
}

/*
-(void) resetattendancebuttontouchupinside:(UIButton *)sender
{
    resetattendance=YES;
    [MakeupTable reloadData];
}*/


-(void) attendancebuttontouchdown:(UIButton *)sender
{
    MakeupTable.scrollEnabled=FALSE;
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:MakeupTable];
    NSIndexPath *indexpath =[MakeupTable indexPathForRowAtPoint:point];
    [MakeupTable selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    UIView *windowview = self.view;
    while (windowview.superview != Nil) {
        windowview = windowview.superview;
    }
    
    
    attendancebuttonarray=[[NSMutableArray alloc]initWithArray:makeupdtattendancebuttonarray];
    attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:workingClass.makeupattendance highlightbutton:workingClass.makeupattendance attendancebuttonarray:attendancebuttonarray inview:windowview size:@"small"];
    
    
    UIWindow *win0 = self.view.window ?: [MyClass activeWindow];
    
    [win0 addSubview:attendanceringview];
    [win0 bringSubviewToFront:attendanceringview];
    
    lasttouchedsector=0;
}


-(void)viewDidAppear:(BOOL)animated
{

    AllInstructorArray=[MyClass retrieveInstructorListwithvalid:@"All" flushcachedata:NO];
    ActiveInstructorArray=[MyClass filterInstructorArrayWithInstructorArray:AllInstructorArray Valid:@"Yes"];
    filteredActiveInstructorArray=[[NSMutableArray alloc]initWithArray:ActiveInstructorArray];
    if (!AllInstructorArray) {
        [MyClass showconnectionlostdialogbox];
        [self.delegate dismissmakeuppopoverduetoconnectionerror];
        return;
    }
        
    allClassroomArray=[MyClass retrieveClassroomListwithstatus:@"In Service" withTBD:YES flushcachedata:NO];
    filteredClassroomArray=[[NSMutableArray alloc]initWithArray:allClassroomArray];
    if (!allClassroomArray) {
        [MyClass showconnectionlostdialogbox];
        [self.delegate dismissmakeuppopoverduetoconnectionerror];
        return;
    }

    [MakeupTable reloadData];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) createtables
{
//    MakeupTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    //ScrollView=[[UIScrollView alloc]init];
//    MakeupTable.dataSource=self;
//    MakeupTable.delegate=self;
    MakeupToolBar.clipsToBounds=YES;
    
    [MakeupTable reloadData];
    
//    [MakeupTable setFrame:CGRectMake(0, 44+20, 320, self.view.bounds.size.height-44-20)];
//    [self.view addSubview:MakeupTable];
//    self.preferredContentSize=CGSizeMake(320, self.view.bounds.size.height-44-20);
    
    //instructor table
    InstructorTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, instructortablewidth, self.view.frame.size.height)];
    [self.view addSubview:InstructorTableMasterView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, InstructorTableMasterView.frame.size.width,84+3)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [InstructorTableMasterView addSubview:headerView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Instructor"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    instructorsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 40, InstructorTableMasterView.frame.size.width, 42)];
    instructorsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    instructorsearchbar.delegate=self;
    instructorsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:instructorsearchbar];
    
    InstructorTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84+20+3, instructortablewidth, self.view.frame.size.height-44-84-20-3) style:UITableViewStyleGrouped];
    InstructorTable.dataSource=self;
    InstructorTable.delegate=self;
    InstructorTable.sectionHeaderHeight=0;
    [InstructorTable reloadData];
    [InstructorTableMasterView addSubview:InstructorTable];
    
    InstructorTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, instructortablewidth, 44)];
    InstructorTableToolBar.clipsToBounds=YES;
    [InstructorTableMasterView addSubview:InstructorTableToolBar];
    
    UIButton *instructorimage=[[UIButton alloc]initWithFrame:CGRectMake(InstructorTableMasterView.frame.size.width-44, 4, 40, 40)];
    [instructorimage setImage:[UIImage imageNamed:@"instructoricon.png"] forState:UIControlStateNormal];
    [instructorimage applyImageInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [instructorimage addTarget: self action:@selector(InstructorButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
    //[headerView addSubview:instructorimage];
    
    [self createInstructorTableToolBar];
    
    //sec instructor table
    SInstructorTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, instructortablewidth, self.view.frame.size.height)];
    [self.view addSubview:SInstructorTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, SInstructorTableMasterView.frame.size.width,84+3)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [SInstructorTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Sec. Instructor"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    sinstructorsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 40, SInstructorTableMasterView.frame.size.width, 42)];
    sinstructorsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    sinstructorsearchbar.delegate=self;
    sinstructorsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:sinstructorsearchbar];
    
    SInstructorTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84+20+3, instructortablewidth, self.view.frame.size.height-44-84-20-3) style:UITableViewStyleGrouped];
    SInstructorTable.dataSource=self;
    SInstructorTable.delegate=self;
    SInstructorTable.sectionHeaderHeight=0;
    [SInstructorTable reloadData];
    [SInstructorTableMasterView addSubview:SInstructorTable];
    
    SInstructorTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, instructortablewidth, 44)];
    SInstructorTableToolBar.clipsToBounds=YES;
    [SInstructorTableMasterView addSubview:SInstructorTableToolBar];
    
    
    [self createSInstructorTableToolBar];
    
    
    //classroom
    ClassroomTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, classroomtablewidth, self.view.frame.size.height)];
    [self.view addSubview:ClassroomTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, ClassroomTableMasterView.frame.size.width,84+3)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [ClassroomTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Classroom"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    classroomsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 40, ClassroomTableMasterView.frame.size.width, 42)];
    classroomsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    classroomsearchbar.delegate=self;
    classroomsearchbar.tag=3;
    classroomsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:classroomsearchbar];
    
    ClassroomTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84+20+3, classroomtablewidth, self.view.frame.size.height-44-84-20-3) style:UITableViewStyleGrouped];
    ClassroomTable.dataSource=self;
    ClassroomTable.delegate=self;
    ClassroomTable.sectionHeaderHeight=0;
    [ClassroomTable reloadData];
    [ClassroomTableMasterView addSubview:ClassroomTable];
    
    UILabel *separator=[[UILabel alloc]initWithFrame:CGRectMake(0, 44+44+20, classroomtablewidth, 0.5)];
//    separator.layer.opacity=0.6;
//    separator.backgroundColor=[UIColor lightGrayColor];
//    [ClassroomTableMasterView addSubview:separator];
    
    ClassroomTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, classroomtablewidth, 44)];
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
    NatureTable.sectionHeaderHeight=0;
    
    [NatureTable reloadData];
    [NatureTableMasterView addSubview:NatureTable];
    
    separator=[[UILabel alloc]initWithFrame:CGRectMake(0, 44+44+20, naturetablewidth, 0.5)];
    separator.layer.opacity=0.6;
    separator.backgroundColor=[UIColor lightGrayColor];
    [NatureTableMasterView addSubview:separator];
    
    NatureTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, naturetablewidth, 44)];
    NatureTableToolBar.clipsToBounds = YES;
    [NatureTableMasterView addSubview:NatureTableToolBar];
    [self createNatureTableToolBar];
    
    LessonNumberTable.sectionHeaderHeight=0;
    [self createLessonNumberTableToolBar];
    
    UpdateFollowingLessonsFieldsTable.sectionHeaderHeight=0;
    [self createUpdateFollowingLessonsFieldsTableToolBar];
    
    //add separator
    separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth, 20, 1, maxPopupHeight-20)];
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

-(void) createSInstructorTableToolBar
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
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [SInstructorTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeinstructortable) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [SInstructorTableMasterView addSubview:button];
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
//    
//    UIBarButtonItem *clearButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Clear"] style:UIBarButtonItemStylePlain target:self action:@selector(clearLessonNumber)];
//    
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

-(void) createUpdateFollowingLessonsFieldsTableToolBar
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
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [UpdateFollowingLessonsFieldsTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 13, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidetable) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [UpdateFollowingLessonsFieldsTableMasterView addSubview:button];
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

-(void) closeinstructortable
{
    showInstructorTable=NO;
    [MakeupTable deselectRowAtIndexPath:[MakeupTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) closeclassroomtable
{
    showClassroomTable=NO;
    [MakeupTable deselectRowAtIndexPath:[MakeupTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) closesidetable
{
    showClassroomTable=NO;
    showLessonNumberTable=NO;
    showNatureTable=NO;
    showInstructorTable=NO;
    showSInstructorTable=NO;
    showUpdateFollowingLessonsFieldsTable=NO;

    [MakeupTable deselectRowAtIndexPath:[MakeupTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) closelessonnumbertable
{
    showLessonNumberTable=NO;
    [MakeupTable deselectRowAtIndexPath:[MakeupTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) closenaturetable
{
    showNatureTable=NO;
    [MakeupTable deselectRowAtIndexPath:[MakeupTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

- (IBAction)deleteButtonPressed:(id)sender {
    UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Are you sure to delete all the classes in the lesson?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate deleteClassesFromMakeupWindowWithClassrecords:PopoverLessonAndClassRecord.classScheduleRecordArray];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [changealert addAction:OKAction];
    [changealert addAction:CancelAction];
    
    [self presentViewController:changealert animated:YES completion:nil];
}

-(void) doneButtonPressed:(id)sender
{
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }
    //[self storeTmpField];
    
   
        if ([PopoverOption isEqualToString:@"DailyScheduleLesson"]) {
            
            [self.delegate passfreeclassscheduleforlessonmove:[[self returnfreescheduleclassarray] firstObject] updatefollowinglessons:updatefollowinglessons updatefollowinglessonsfields:updatefollowinglessonsfieldsarray];
        }else{
            classvalidatemessage=[MyClass validateClassWithFreeScheduleArray:[self returnfreescheduleclassarray] studentkey:[PopoverOption isEqualToString:@"FromClassSchedule"]?PopoverClassRecord.studentkey:PopoverDetailsClassRecord.studentkey enrollmentkey:nil];
            classvalidatestatus=[[ClassValidateStatus alloc]initClassValidateStatuswithoverenrollmentstatus:@"" sameinstructormulticlassstatus:@"" alreadyenrolledstatus:@"" sameclassroommulticlassstatus:@"" hasextendedchildclassstatus:@"" classroomexceedcapacitystatus:@"" makeupquotaexceedstatus:@""];
            [self checkvalidatemessage];
        }
    //}
}

-(void) validationPassed:(BOOL)pass
{
    if(pass){
        [self updateMakeup];
    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }
}

-(void) checkvalidatemessage
{
    [MyClass checkValidateMessageWithClassValidateMessage:classvalidatemessage ClassValidateStatus:classvalidatestatus View:self];

}


-(void) updateMakeup
{

    if (![workingClass.makeupdate isEqualToString:@""]) {
        workingClass.makeupinstructor=[workingClass.makeupinstructor isEqualToString:@""]?@"TBD":workingClass.makeupinstructor;
        workingClass.makeupsinstructor=[workingClass.makeupsinstructor isEqualToString:@""]?@"TBD":workingClass.makeupsinstructor;
        workingClass.makeupclassroom=[workingClass.makeupclassroom isEqualToString:@""]?@"TBD":workingClass.makeupclassroom;
    }else{
        workingClass.makeupinstructor=@"";
        workingClass.makeupsinstructor=@"";
        workingClass.makeupclassroom=@"";
    }
    
    NSMutableArray *updatefollowinglessonsfields=[[NSMutableArray alloc]initWithArray:updatefollowinglessonsfieldsarray];
    for (int i=0; i<updatefollowinglessonsfields.count; i++) {
        NSString *field=updatefollowinglessonsfields[i];
        if ([field isEqualToString:@"Class Time"]) {
            updatefollowinglessonsfields[i]=@"classtime";
        }else if ([field isEqualToString:@"Instructor"]) {
            updatefollowinglessonsfields[i]=@"instructor";
        }else if ([field isEqualToString:@"Sec. Instructor"]) {
            updatefollowinglessonsfields[i]=@"sinstructor";
        }else if ([field isEqualToString:@"Classroom"]) {
            updatefollowinglessonsfields[i]=@"classroom";
        }else if ([field isEqualToString:@"Lesson"]) {
            updatefollowinglessonsfields[i]=@"lesson";
        }else if ([field isEqualToString:@"Remarks"]) {
            updatefollowinglessonsfields[i]=@"remarks";
        }
    }
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:@"updateclassv2" forKey:@"postaction"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:workingClass.classkey forKey:@"classkey"];
    [dictionary setValue:@"makeupwindow" forKey:@"trigger"];
    [dictionary setValue:workingClass.leavenaturelistkey forKey:@"leavenaturelistkey"];
    
    if([PopoverOption isEqualToString:@"FromTaskView"] && [PopoverClassRecord.startdate isEqualToString:@"TBD"]){
        [dictionary setValue:[MyClass convertDateFormatWithDate:workingClass.makeupdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO]  forKey:@"startdate"];
        [dictionary setValue:workingClass.makeuptime forKey:@"classtime"];
        [dictionary setValue:workingClass.makeupinstructor forKey:@"instructor"];
        [dictionary setValue:workingClass.makeupsinstructor forKey:@"sinstructor"];
        [dictionary setValue:workingClass.makeupclassroom forKey:@"classroom"];
        [dictionary setValue:workingClass.absentmakeupreason forKey:@"remarks"];
        [dictionary setValue:workingClass.makeupattendance forKey:@"attendance"];
    }else{
        [dictionary setValue:[MyClass convertDateFormatWithDate:workingClass.makeupdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO]  forKey:@"makeupdate"];
        [dictionary setValue:workingClass.makeuptime forKey:@"makeuptime"];
        [dictionary setValue:workingClass.makeupinstructor forKey:@"makeupinstructor"];
        [dictionary setValue:workingClass.makeupsinstructor forKey:@"makeupsinstructor"];
        [dictionary setValue:workingClass.makeupclassroom forKey:@"makeupclassroom"];
        [dictionary setValue:workingClass.absentmakeupreason forKey:@"absentmakeupreason"];
        [dictionary setValue:workingClass.makeupattendance forKey:@"makeupattendance"];
        [dictionary setValue:updatefollowinglessons?@"Yes":@"No" forKey:@"updatefollowinglessons"];
        [dictionary setValue:[updatefollowinglessonsfields componentsJoinedByString:@","] forKey:@"updatefollowinglessonsfields"];
        
        
        if([PopoverOption isEqualToString:@"FromTaskView"]){
            if(![workingClass.attendance isEqualToString:@"Makeup"]){
                [dictionary setValue:@"Makeup" forKey:@"attendance"];
            }
        }
    }

    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];

    if(result){
        [self.delegate dismisspopover];
        UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Makeup"] message:[MyClass returntitlewithtitle:@"Information is updated"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        
        [successalert addAction:OKAction];
        //[self presentViewController:successalert animated:YES completion:nil];
        [MyClass presentViewController:successalert View:self];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/

    
}

-(void) timetableButtonPressed:(UIButton *)sender
{
    sender.enabled=NO;
    
    //popup class view record
    ClassTimeTableViewController *timetablepopover = (ClassTimeTableViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"ClassTimeTableViewController"];
    timetablepopover.TimeTableMode=@"PopoverWeekly";
    if ([PopoverOption isEqualToString:@"FromClassSchedule"]) {
        timetablepopover.Subjectselected=PopoverClassRecord.subject;
    }else{
        timetablepopover.Subjectselected=PopoverDetailsClassRecord.subject;
    }
    timetablepopover.FreeScheduleClassArray=[self returnfreescheduleclassarray];
    timetablepopover.preferredinstructor=workingClass.makeupinstructor;
    timetablepopover.studentkey=PopoverClassRecord.studentkey;
    
    //df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    if (![workingClass.makeupdate isEqualToString:@""]) {
        
        //find first date
        //[df setDateFormat:@"dd-MMM-yyyy"];
        NSDate *currentdate=[MyClass convertToNSDateWithDate:workingClass.makeupdate DateFormat:@"dd-MMM-yyyy"];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:currentdate];
        
        NSUInteger weekdayToday = [components weekday];
        
        NSInteger daysToMonday=weekdayToday-[MyClass returndayofweeknumber:[globalvariables.centerdayofweekarray objectAtIndex:0]];
        //NSInteger daysToMonday=weekdayToday-2;
        NSDate *pastMon = [currentdate dateByAddingTimeInterval:60*60*24*(-daysToMonday)];
        
        //[df setDateFormat:@"dd-MMM-yyyy"];
        timetablepopover.startupmonday=[MyClass convertToNSStringWithNSDate:pastMon DateFormat:@"dd-MMM-yyyy"];
    }

    timetablepopover.delegate=self;
    timetablepopover.modalPresentationStyle=UIModalPresentationFullScreen;
    //[self presentViewController:timetablepopover animated:YES completion:nil];
    [MyClass presentViewController:timetablepopover View:self];
    sender.enabled=YES;
}


-(void) cancelselection
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)passTimeTableInformationwithstartdate:(NSString *)startdate classtime:(NSString *)classtime instructor:(NSString *)instructor classroom:(NSString *)classroom
{

    workingClass.makeupdate=startdate;
    workingClass.makeuptime=classtime;
    //tmpMakeupDateTime=[NSString stringWithFormat:@"%@ %@",startdate,classtime];
    //MakeupInstructorLabel.text=[MyClass returninstructornamewithusername:instructor firstorfullname:@"full"];
    workingClass.makeupinstructor=instructor;
    workingClass.makeupclassroom=classroom;
    [self dismissViewControllerAnimated:YES completion:nil];
    
    showMakeupDatePicker=NO;
    //[self storeTmpField];
    [MakeupTable reloadData];
    
    [self adjusttablesize];
    
    //[MakeupTable setFrame:CGRectMake(0, 0, 320, MakeupTable.contentSize.height)];
    //[ScrollView setFrame:CGRectMake(0, 44, 320,  MakeupTable.contentSize.height)];
    //[ScrollView setContentSize:CGSizeMake(320, MakeupTable.contentSize.height)];
    //self.preferredContentSize=CGSizeMake(320, MakeupTable.contentSize.height+44);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==MakeupTable) {
        return 2+(([PopoverOption isEqualToString:@"DailyScheduleLesson"] || [PopoverOption isEqualToString:@"FromClassSchedule"] || [PopoverOption isEqualToString:@"FromClassDetails"])?1:0);
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==MakeupTable) {
        if (section==0) {
            return 7;
        }else if (section==1){
            return 2;
        }else{
            return updatefollowinglessons?2:1;
        }
    }else if (tableView==InstructorTable){
        return filteredActiveInstructorArray.count;
    }else if (tableView==SInstructorTable){
        return filteredActiveInstructorArray.count;
    }else if (tableView==NatureTable){
        return leaveNatureArray.count;
    }else if (tableView==LessonNumberTable){
        return globalvariables.centerrecord.lessonnumbermode==2?1:lessonArray.count;
    }else if (tableView==UpdateFollowingLessonsFieldsTable){
        return updatefollowinglessonsfieldsoptions.count;
    }else{
        return filteredClassroomArray.count;
    }
}

-(BOOL) showLessonParameter
{
    return [PopoverOption isEqualToString:@"DailyScheduleLesson"] && [MyClass showLessonParameterWithSubject:workingClass.subject];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==MakeupTable) {
        if (indexPath.section==0) {
            if(indexPath.row==1){
                return showMakeupDatePicker?235:CGFLOAT_MIN;
            }else if (indexPath.row==2){
                return showMakeupDatePicker?162:CGFLOAT_MIN;
            }else if (indexPath.row==4){
                return globalvariables.centerrecord.secondaryinstructor?32:CGFLOAT_MIN;
            }else if (indexPath.row==6){
                return [self showLessonParameter]?32:CGFLOAT_MIN;
            }
            return 32;
        }else if (indexPath.section==1){
            return indexPath.row==0?0:100;
        }else{
            if(indexPath.row==0){
                return 40;
            }else{
                return UITableViewAutomaticDimension;
            }
        }
    }else if (tableView==LessonNumberTable){
        return globalvariables.centerrecord.lessonnumbermode==2?300:UITableViewAutomaticDimension;
    }else{
        return 38;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==MakeupTable) {
        if (section==0) {
            if (![PopoverOption isEqualToString:@"DailyScheduleLesson"]) {
                return [MyClass returntitlewithtitle:@"Makeup Information"];
            }else{
                return [MyClass returntitlewithtitle:@"Class Information"];
            }
        }else if (section==1){
            return [PopoverOption isEqualToString:@"DailyScheduleLesson"]?[MyClass returntitlewithtitle:@"Remarks"]:[MyClass returntitlewithtitle:@"Reason"];
        }
    }else if (tableView==LessonNumberTable){
        return [MyClass returntitlewithtitle:@"Lesson"];
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

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (tableView==MakeupTable) {
        if (section==1) {
            if ([PopoverOption isEqualToString:@"DailyScheduleLesson"]) {
                return [MyClass returntitlewithtitle:@"You can enter \"Clear\" to clear existing remarks"];
            }
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    UISwitch *menuswitch;
    if (tableView==MakeupTable) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
        if (indexPath.section==0) {
            if (indexPath.row==0){
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                GeneralLabel.font=[UIFont systemFontOfSize:17];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Date/Time"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                MakeupDateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 5, 192, 21)];
                MakeupDateTimeLabel.font=[UIFont systemFontOfSize:15];
                MakeupDateTimeLabel.textColor=[UIColor darkGrayColor];
                MakeupDateTimeLabel.textAlignment=NSTextAlignmentRight;
                
                MakeupDateTimeLabel.text=[workingClass.makeupdate isEqualToString:@""]?@"":[MyClass returndateformatDDMMMYYYYHHMMwithdate:[NSString stringWithFormat:@"%@ %@",workingClass.makeupdate,workingClass.makeuptime]];
                //MakeupDateTimeLabel.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:tmpMakeupDateTime];
                MakeupDateTimeLabel.tag=312;
                [cell.contentView addSubview:MakeupDateTimeLabel];
                
                if ([((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingClass.subject centerkey:globalvariables.centerrecord.centerkey]).tuition_mode isEqualToString:@"Month"] && [PopoverOption isEqualToString:@"DailyScheduleLesson"] && !globalvariables.centerrecord.caneditmonthlycoursestartdate) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
                
                
            }else if (indexPath.row==1){
                if (showMakeupDatePicker==YES) {
                    
                    scCalendarType = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Manual Calendar"],[MyClass returntitlewithtitle:@"Auto Calendar"],nil]];
                    [scCalendarType addTarget:self action:@selector(selectcalendartype:) forControlEvents:UIControlEventValueChanged];
                    scCalendarType.frame=CGRectMake(10, 3, popoverwidth-20, 29);
                    scCalendarType.selectedSegmentIndex=selectedCalendarType;
                    [cell.contentView addSubview:scCalendarType];

                    CalendarView *calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 35, 320, 200) Theme:0 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:selectedCalendarType==1?availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:![self editclassforpaidenrollment]];
                    
                    if(selectedCalendarType==1 && [self returnTimeIndex]<0){
                        if([availablemakeuptimeslots valueForKey:[MyClass convertDateFormatWithDate:workingClass.makeupdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"]]){
                            makeuptimearray=[MyClass returnclasstimewithdate:workingClass.makeupdate availablemakeupslots:availablemakeuptimeslots];
                            if([self returnTimeIndex]<0){
                                makeuptimearray=[[NSArray alloc]init];
                                [calendarview scrollToSelectedDateWithSelectedDateArray:nil ScrollToDate:workingClass.makeupdate instructorselected:nil];
                            }else{
                                [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:workingClass.makeupdate,nil] ScrollToDate:nil instructorselected:nil];
                            }
                        }else{
                            makeuptimearray=[[NSArray alloc]init];
                            [calendarview scrollToSelectedDateWithSelectedDateArray:nil ScrollToDate:workingClass.makeupdate instructorselected:nil];
                        }
                    }else{
                        [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:workingClass.makeupdate,nil] ScrollToDate:nil instructorselected:nil];
                    }

                    calendarview.delegate=self;
                    
                    [cell.contentView addSubview:calendarview];
                    
                    
                }else{
                    cell.hidden=YES;
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==2){
                if (showMakeupDatePicker==YES) {
                    
                    
                    if(selectedCalendarType==0){
                        hourPresetRow=(int)[hourPickerViewMenu indexOfObject:[workingClass.makeuptime substringToIndex:2]];
                        minutePresetRow=(int)[minutePickerViewMenu indexOfObject:[workingClass.makeuptime substringFromIndex:3]];
                        
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 162)];
                        myPicker.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.03];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        
                        [myPicker selectRow:hourPresetRow inComponent:0 animated:NO];
                        [myPicker selectRow:minutePresetRow inComponent:1 animated:NO];
                        
                        self.myPickerView=myPicker;
                        [cell.contentView addSubview:myPicker];
                        
                        
                        UIButton *timetablebutton=[[UIButton alloc]initWithFrame:CGRectMake(15, 162-30, 40, 30)];
                        [timetablebutton setImage:[UIImage imageNamed:@"classtimetable_rounded_icon.png"] forState:UIControlStateNormal];
                        [timetablebutton applyImageInsets:UIEdgeInsetsMake(2, 2, 2, 12)];
                        [timetablebutton addTarget: self action:@selector(timetableButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
                        timetablebutton.tag=702;
                        [cell.contentView addSubview:timetablebutton];
                    }else{
                        if(makeuptimearray.count>0){
                            
                            UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 320, 162)];
                            myPicker.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.03];
                            [myPicker setDataSource:self];
                            [myPicker setDelegate:self];
                            
                            [myPicker selectRow:[self returnTimeIndex] inComponent:0 animated:NO];
                            
                            self.myPickerView=myPicker;
                            [cell.contentView addSubview:myPicker];
                        }else{
                            UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 162)];
                            view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.03];
                            [cell.contentView addSubview:view];
                            
                            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 280, 162)];
                            label.numberOfLines=0;
                            label.font=[UIFont systemFontOfSize:14];
                            label.text=[MyClass returntitlewithtitle:@"Available makeup timeslots will be shown based on subject settings. Please select class date"];
                            label.textColor=[UIColor grayColor];
                            label.textAlignment=NSTextAlignmentCenter;
                            [view addSubview:label];
                            
                        }
                    }
                }else{
                    cell.hidden=YES;
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==3){
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 100, 21)];
                GeneralLabel.font=[UIFont systemFontOfSize:17];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Instructor"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                MakeupInstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 177, 21)];
                MakeupInstructorLabel.font=[UIFont systemFontOfSize:15];
                MakeupInstructorLabel.textColor=[UIColor darkGrayColor];
                MakeupInstructorLabel.textAlignment=NSTextAlignmentRight;
                
                MakeupInstructorLabel.text=AllInstructorArray?[workingClass.makeupinstructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:workingClass.makeupinstructor]:[MyClass returninstructornamewithusername:workingClass.makeupinstructor firstorfullname:@"full"]:@"";
                
                MakeupInstructorLabel.tag=313;
                [cell.contentView addSubview:MakeupInstructorLabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==4){
                if(globalvariables.centerrecord.secondaryinstructor){
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 150, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Sec. Instructor"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    MakeupSInstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                    MakeupSInstructorLabel.font=[UIFont systemFontOfSize:15];
                    MakeupSInstructorLabel.textColor=[UIColor darkGrayColor];
                    MakeupSInstructorLabel.textAlignment=NSTextAlignmentRight;
                    
                    MakeupSInstructorLabel.text=AllInstructorArray?[workingClass.makeupsinstructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:workingClass.makeupsinstructor]:[MyClass returninstructornamewithusername:workingClass.makeupsinstructor firstorfullname:@"full"]:@"";
                    
                    MakeupSInstructorLabel.tag=313;
                    [cell.contentView addSubview:MakeupSInstructorLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.hidden=YES;
                }
                
            }else if (indexPath.row==5){
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
                
                MakeupClassroomLabel.text=[workingClass.makeupclassroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:workingClass.makeupclassroom]:workingClass.makeupclassroom;
                
                MakeupClassroomLabel.tag=313;
                [cell.contentView addSubview:MakeupClassroomLabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==6){
                if([self showLessonParameter]){
                    cell.hidden=NO;
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Lesson"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    MakeupClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                    MakeupClassroomLabel.font=[UIFont systemFontOfSize:15];
                    MakeupClassroomLabel.textColor=[UIColor darkGrayColor];
                    MakeupClassroomLabel.textAlignment=NSTextAlignmentRight;
                    
                    
                    if(workingClass.lesson){
                        MakeupClassroomLabel.text=[workingClass.lesson isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass getLessonDescriptionWithLessonNumber:workingClass.lesson subject:workingClass.subject];
                    }else{
                        NSString *lessondesc=[MyClass returnLessonDescriptionWithClassScheduleRecords:PopoverLessonAndClassRecord.classScheduleRecordArray];
                        MakeupClassroomLabel.text=lessondesc;
                    }
                    
                    MakeupClassroomLabel.tag=313;
                    [cell.contentView addSubview:MakeupClassroomLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    cell.hidden=YES;
                }
            }
        }else if (indexPath.section==1){
            if(indexPath.row==0){
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                GeneralLabel.font=[UIFont systemFontOfSize:17];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Nature"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                MakeupClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 5, 187, 21)];
                MakeupClassroomLabel.font=[UIFont systemFontOfSize:15];
                MakeupClassroomLabel.textColor=[UIColor darkGrayColor];
                MakeupClassroomLabel.textAlignment=NSTextAlignmentRight;
                
                MakeupClassroomLabel.text=[MyClass returnLeaveNatureNameWithLeaveNatureListKey:workingClass.leavenaturelistkey];
                
                MakeupClassroomLabel.tag=313;
                [cell.contentView addSubview:MakeupClassroomLabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
                cell.hidden=YES;
                
            }else{
                absentMakeupReasonText = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(20, 0, 280, 90)];
                absentMakeupReasonText.font=[UIFont systemFontOfSize:15];
                absentMakeupReasonText.textColor=[UIColor blackColor];
                absentMakeupReasonText.textAlignment=NSTextAlignmentLeft;
                absentMakeupReasonText.text=workingClass.absentmakeupreason?workingClass.absentmakeupreason:@"";
                absentMakeupReasonText.placeholder=[MyClass returntitlewithtitle:@"Remarks"];
                absentMakeupReasonText.tag=415;
                absentMakeupReasonText.delegate=self;
                [cell.contentView addSubview:absentMakeupReasonText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else{
            if(indexPath.row==0){
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 300, 38)];
                GeneralLabel.font=[UIFont systemFontOfSize:17];
                GeneralLabel.textColor=[UIColor blackColor];
                GeneralLabel.text=[MyClass returntitlewithtitle:@"Apply to all following lessons"];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(selectupdatefollowinglessons:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=updatefollowinglessons;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else{
                MyTableViewCell *myCell;
                static NSString *CellIdentifier = @"labellabelcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.label1.text=[MyClass returntitlewithtitle:@"Options"];
                myCell.label2.text=[self returnupdatefollowinglessonsfieldsvalue];
                myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
                return myCell;
            }
        }

    }else if (tableView==InstructorTable){
        UILabel *contactlabel;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            //add textfield
            ITInstructorname = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, instructortablewidth-30, 25)];
            ITInstructorname.font=[UIFont systemFontOfSize:15];
            ITInstructorname.textColor=[UIColor darkGrayColor];
            ITInstructorname.tag=1301;
            [cell.contentView addSubview:ITInstructorname];
            
            contactlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, instructortablewidth-30, 10)];
            contactlabel.font=[UIFont systemFontOfSize:11];
            contactlabel.textColor=[UIColor grayColor];
            contactlabel.tag=1303;
            [cell.contentView addSubview:contactlabel];
            
            ITInstructorselected = [[UIImageView alloc]initWithFrame:CGRectMake(instructortablewidth-45, 7, 24, 24)];
            [ITInstructorselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            ITInstructorselected.tag=1302;
            [cell.contentView addSubview:ITInstructorselected];
        }else{
            ITInstructorname=(UILabel *)[cell.contentView viewWithTag:1301];
            ITInstructorselected=(UIImageView *)[cell.contentView viewWithTag:1302];
            contactlabel=(UILabel *)[cell.contentView viewWithTag:1303];
        }
        ITInstructorname.text=[MyClass returninstructornamewithusername:((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username firstorfullname:@"full"];
        ITInstructorselected.hidden=[((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username isEqualToString:workingClass.makeupinstructor]?NO:YES;
        contactlabel.text=((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username;
        
    }else if (tableView==SInstructorTable){
        UILabel *contactlabel;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            //add textfield
            ITSInstructorname = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, instructortablewidth-30, 25)];
            ITSInstructorname.font=[UIFont systemFontOfSize:15];
            ITSInstructorname.textColor=[UIColor darkGrayColor];
            ITSInstructorname.tag=1301;
            [cell.contentView addSubview:ITSInstructorname];
            
            contactlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 25, instructortablewidth-30, 10)];
            contactlabel.font=[UIFont systemFontOfSize:11];
            contactlabel.textColor=[UIColor grayColor];
            contactlabel.tag=1303;
            [cell.contentView addSubview:contactlabel];
            
            ITSInstructorselected = [[UIImageView alloc]initWithFrame:CGRectMake(instructortablewidth-45, 7, 24, 24)];
            [ITSInstructorselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            ITSInstructorselected.tag=1302;
            [cell.contentView addSubview:ITSInstructorselected];
        }else{
            ITSInstructorname=(UILabel *)[cell.contentView viewWithTag:1301];
            ITSInstructorselected=(UIImageView *)[cell.contentView viewWithTag:1302];
            contactlabel=(UILabel *)[cell.contentView viewWithTag:1303];
        }
        ITSInstructorname.text=[MyClass returninstructornamewithusername:((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username firstorfullname:@"full"];
        ITSInstructorselected.hidden=[((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username isEqualToString:workingClass.makeupsinstructor]?NO:YES;
        contactlabel.text=((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username;
        
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
        ITInstructorname.text=[((ClassroomRecord *)[filteredClassroomArray objectAtIndex:indexPath.row]).classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:((ClassroomRecord *)[filteredClassroomArray objectAtIndex:indexPath.row]).classroom;
        ITInstructorselected.hidden=[((ClassroomRecord *)[filteredClassroomArray objectAtIndex:indexPath.row]).classroom isEqualToString:workingClass.makeupclassroom]?NO:YES;
        
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
    }else if(tableView==UpdateFollowingLessonsFieldsTable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"labelCell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.label1.text=[MyClass returntitlewithtitle:[updatefollowinglessonsfieldsoptions objectAtIndex:indexPath.row]];
        cell.imageview1.hidden=![updatefollowinglessonsfieldsarray containsObject:[updatefollowinglessonsfieldsoptions objectAtIndex:indexPath.row]];
        
        return cell;
    }
    return cell;
}

-(void) clearLessonNumber
{
    workingClass.lesson=@"";
    [MakeupTable reloadData];
    [self closelessonnumbertable];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==MakeupTable) {
        if (indexPath.section==0 && indexPath.row==0 && (![((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingClass.subject centerkey:globalvariables.centerrecord.centerkey]).tuition_mode isEqualToString:@"Month"] || globalvariables.centerrecord.caneditmonthlycoursestartdate || ![PopoverOption isEqualToString:@"DailyScheduleLesson"])) {
            //pickerview for makeup date time
            
            selectedItem=@"MakeupDateTime";
            if (showMakeupDatePicker ==YES) {
                showMakeupDatePicker=NO;
            }else{
                showMakeupDatePicker=YES;
                selectedCalendarType=0;
            }
            [self showsidewindowwithwindow:@"none"];
            
            if ([workingClass.makeupdate isEqualToString:@""]) {
                
                
                workingClass.makeupdate=[tmpDefaultMakeupDateTime substringToIndex:11];
                workingClass.makeuptime=[tmpDefaultMakeupDateTime substringFromIndex:12];
                
                if ([workingClass.makeupclassroom isEqualToString:@""]) {
                    workingClass.makeupclassroom=tmpDefaultMakeupClassroom;
                }
                if ([workingClass.makeupinstructor isEqualToString:@""]) {
                    workingClass.makeupinstructor=tmpDefaultMakeupInstructor;
                }
                if ([workingClass.makeupsinstructor isEqualToString:@""]) {
                    workingClass.makeupsinstructor=tmpDefaultMakeupSInstructor;
                }
                
                
                doneButton.enabled=[self enableDoneButton];

            }
            
            //[self storeTmpField];
            [MakeupTable reloadData];
            
            [self adjusttablesize];
            
            
        }else if (indexPath.section==0 && indexPath.row==3) {
            //pickerview for instructor
            
            selectedItem=@"MakeupInstructor";

            instructorsearchbar.text=@"";
            filteredActiveInstructorArray=[[NSMutableArray alloc]initWithArray:ActiveInstructorArray];

            showMakeupDatePicker=NO;
            
            [self showsidewindowwithwindow:@"showInstructorTable"];
            
            if ([workingClass.makeupinstructor isEqualToString:@""]) {
                workingClass.makeupinstructor=tmpDefaultMakeupInstructor;
                doneButton.enabled=[self enableDoneButton];
                
            }
            
            //[self storeTmpField];
            [MakeupTable reloadData];
            [InstructorTable reloadData];
            
            [self adjusttablesize];

            
        }else if (indexPath.section==0 && indexPath.row==4) {
            //pickerview for sinstructor
            
            selectedItem=@"MakeupSInstructor";

            sinstructorsearchbar.text=@"";
            filteredActiveInstructorArray=[[NSMutableArray alloc]initWithArray:ActiveInstructorArray];

            showMakeupDatePicker=NO;
            
            [self showsidewindowwithwindow:@"showSInstructorTable"];
            
            if ([workingClass.makeupsinstructor isEqualToString:@""]) {
                workingClass.makeupsinstructor=tmpDefaultMakeupSInstructor;
                doneButton.enabled=[self enableDoneButton];
                
            }
            
            //[self storeTmpField];
            [MakeupTable reloadData];
            [SInstructorTable reloadData];
            
            [self adjusttablesize];

            
        }else if (indexPath.section==0 && indexPath.row==5) {
            //pickerview for instructor
            
            selectedItem=@"MakeupClassroom";
            

                showMakeupDatePicker=NO;
            [self showsidewindowwithwindow:@"showClassroomTable"];
            
            if ([workingClass.makeupclassroom isEqualToString:@""]) {
                workingClass.makeupclassroom=tmpDefaultMakeupClassroom;
                doneButton.enabled=[self enableDoneButton];
            }
            
            //[self storeTmpField];
            [MakeupTable reloadData];
            [ClassroomTable reloadData];
            [self adjusttablesize];
            
        }else if (indexPath.section==0 && indexPath.row==6) {
            //pickerview for instructor
            
            selectedItem=@"LessonNumber";
            

            showMakeupDatePicker=NO;
            [self showsidewindowwithwindow:@"showLessonNumberTable"];
            
//            if ([workingClass.makeupclassroom isEqualToString:@""]) {
//                workingClass.makeupclassroom=tmpDefaultMakeupClassroom;
//                doneButton.enabled=[self enableDoneButton];
//            }
            
            //[self storeTmpField];
            [MakeupTable reloadData];
            [LessonNumberTable reloadData];
            [self adjusttablesize];
            
        }else if (indexPath.section==1 && indexPath.row==0) {
            //pickerview for instructor
            
            selectedItem=@"Nature";
            
            
            showMakeupDatePicker=NO;
            [self showsidewindowwithwindow:@"showNatureTable"];
            
            /*if ([workingClass.makeupclassroom isEqualToString:@""]) {
                workingClass.makeupclassroom=tmpDefaultMakeupClassroom;
                //[self updatefreescheduleclassarraywithfield:@"MakeupClassroom" value:workingClass.makeupclassroom];
            }*/
            
            //[self storeTmpField];
            [NatureTable reloadData];
            [NatureTable reloadData];
            [self adjusttablesize];
            
        }else if (indexPath.section==2 && indexPath.row==1){
            selectedItem=@"UpdateFollowingLessonsFields";
            

            showMakeupDatePicker=NO;
            [self showsidewindowwithwindow:@"showUpdateFollowingLessonsFieldsTable"];
            
            
            //[self storeTmpField];
            [MakeupTable reloadData];
            [UpdateFollowingLessonsFieldsTable reloadData];
            [self adjusttablesize];
        }

    }else if (tableView==InstructorTable){
        [self.view endEditing:YES];
        if (![workingClass.makeupinstructor isEqualToString:((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username]) {
            
            workingClass.makeupinstructor=((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username;
            //showMakeupInstructorPicker=NO;
            
            //[self storeTmpField];
            
            [MakeupTable reloadData];
            [InstructorTable reloadData];
            doneButton.enabled=[self enableDoneButton];
            
            [self adjusttablesize];

            //[self updatefreescheduleclassarraywithfield:@"MakeupInstructor" value:workingClass.makeupinstructor];
        }

    }else if (tableView==SInstructorTable){
        [self.view endEditing:YES];
        if (![workingClass.makeupsinstructor isEqualToString:((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username]) {
            
            workingClass.makeupsinstructor=((Instructor *)[filteredActiveInstructorArray objectAtIndex:indexPath.row]).username;
            //showMakeupInstructorPicker=NO;
            
            //[self storeTmpField];
            
            [MakeupTable reloadData];
            [SInstructorTable reloadData];
            doneButton.enabled=[self enableDoneButton];
            
            [self adjusttablesize];

            //[self updatefreescheduleclassarraywithfield:@"MakeupInstructor" value:workingClass.makeupinstructor];
        }

    }else if (tableView==ClassroomTable){
        [self.view endEditing:YES];
        if (![workingClass.makeupclassroom isEqualToString:((ClassroomRecord *)[filteredClassroomArray objectAtIndex:indexPath.row]).classroom]) {
            
            workingClass.makeupclassroom=((ClassroomRecord *)[filteredClassroomArray objectAtIndex:indexPath.row]).classroom;
            //showMakeupInstructorPicker=NO;
            
            //[self storeTmpField];
            
            [MakeupTable reloadData];
            [ClassroomTable reloadData];
            doneButton.enabled=[self enableDoneButton];
            
            [self adjusttablesize];
            
            //[self updatefreescheduleclassarraywithfield:@"MakeupClassroom" value:workingClass.makeupclassroom];
        }
        
    }else if (tableView==NatureTable){
        [self.view endEditing:YES];
        if (![workingClass.leavenaturelistkey isEqualToString:((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:indexPath.row]).leavenaturelistkey]) {
            
            workingClass.leavenaturelistkey=((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:indexPath.row]).leavenaturelistkey;
            //showMakeupInstructorPicker=NO;
            
            //[self storeTmpField];
            
            [MakeupTable reloadData];
            [NatureTable reloadData];
            
            [self adjusttablesize];
            
            //[self updatefreescheduleclassarraywithfield:@"MakeupClassroom" value:workingClass.makeupclassroom];
        }
        
    }else if (tableView==LessonNumberTable){
        workingClass.lesson=[@(indexPath.row+1) stringValue];
        [LessonNumberTable reloadData];
        [MakeupTable reloadData];
        doneButton.enabled=[self enableDoneButton];
        [self closelessonnumbertable];
    }else if(tableView==UpdateFollowingLessonsFieldsTable){
        NSString *selectedvalue=[updatefollowinglessonsfieldsoptions objectAtIndex:indexPath.row];
        if ([updatefollowinglessonsfieldsarray containsObject:selectedvalue]) {
            [updatefollowinglessonsfieldsarray removeObject:selectedvalue];
        }else{
            [updatefollowinglessonsfieldsarray addObject:selectedvalue];
        }
        [UpdateFollowingLessonsFieldsTable reloadData];
        [MakeupTable reloadData];
        doneButton.enabled=[self enableDoneButton];
    }
    
    
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    showInstructorTable=[windowname isEqualToString:@"showInstructorTable"];
    showSInstructorTable=[windowname isEqualToString:@"showSInstructorTable"];
    showClassroomTable=[windowname isEqualToString:@"showClassroomTable"];
    showNatureTable=[windowname isEqualToString:@"showNatureTable"];
    showLessonNumberTable=[windowname isEqualToString:@"showLessonNumberTable"];
    showUpdateFollowingLessonsFieldsTable=[windowname isEqualToString:@"showUpdateFollowingLessonsFieldsTable"];

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    if([selectedItem isEqualToString:@"MakeupDateTime"]){
        return selectedCalendarType==0?2:1;
    }else if ([selectedItem isEqualToString:@"LessonNumber"]){
        return 4;
    }else{
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if([selectedItem isEqualToString:@"MakeupDateTime"]){
        if(selectedCalendarType==0){
            if (component==0){
                return [self.hourPickerViewMenu count];
            }else{
                return [self.minutePickerViewMenu count];
            }
        }else{
            return makeuptimearray.count;
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
        [tView setFont:[UIFont systemFontOfSize:16]];
        tView.adjustsFontSizeToFitWidth=YES;
        tView.minimumScaleFactor=0.7;
        tView.numberOfLines=3;
    }
    // Fill the label text here
    
    
    if([selectedItem isEqualToString:@"MakeupDateTime"]){
        if(selectedCalendarType==0){
            if (component==0){
                tView.text= [self.hourPickerViewMenu objectAtIndex:row];
            }else{
                tView.text= [self.minutePickerViewMenu objectAtIndex:row];
            }
        }else{
            LessonRecord2 *object=[makeuptimearray objectAtIndex:row];
//            tView.text=[((LessonRecord2 *)[makeuptimearray objectAtIndex:row]).datetime substringFromIndex:11];
            tView.text=[NSString stringWithFormat:@"%@|%@|%@",[object.datetime substringFromIndex:11],object.classroom,[MyClass returninstructornamewithusername:object.instructor firstorfullname:@"full"]];
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
    }else{// if ([selectedItem isEqualToString:@"MakeupClassroom"]){
        tView.text= [((ClassroomRecord *)[pickerViewmenu objectAtIndex:row]).classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:((ClassroomRecord *)[pickerViewmenu objectAtIndex:row]).classroom;
    }

    return tView;
}




- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if([selectedItem isEqualToString:@"MakeupDateTime"] && selectedCalendarType==0){
        if (component==0){
            return 30;
        }else{
            return 260;
        }
    }else if([selectedItem isEqualToString:@"LessonNumber"]){
        return 75;
    }else{
        return 260;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.view endEditing:YES];
    if([selectedItem isEqualToString:@"MakeupDateTime"]){
        if(selectedCalendarType==0){
            if (![workingClass.makeuptime isEqualToString:[NSString stringWithFormat:@"%@:%@",[self.hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]]]) {

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
                }else if ([MyClass classendtimebeyondcenterendtimewithclassstarttime:selectedtime duration:classduration]){
                    UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [wrongTimeAlert addAction:OKAction];
                    //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                    [MyClass presentViewController:wrongTimeAlert View:self];
                }else{
                    workingClass.makeuptime=[NSString stringWithFormat:@"%@:%@",[self.hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
                    workingClass.makeupattendance=globalvariables.centerrecord.defaultattendancestatus;
                }
                [MakeupTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }else{
            LessonRecord2 *object=[makeuptimearray objectAtIndex:row];
            workingClass.makeuptime=[object.datetime substringFromIndex:11];
            workingClass.makeupinstructor=object.instructor;
            workingClass.makeupclassroom=object.classroom;
            workingClass.makeupsinstructor=object.sinstructor;
            [MakeupTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:3 inSection:0],[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        doneButton.enabled=[self enableDoneButton];
    }else if ([selectedItem isEqualToString:@"LessonNumber"]){
        NSMutableArray *selectedNumber=[[NSMutableArray alloc]init];
        [selectedNumber addObject:[((NSMutableArray *)lessonArray[0]) objectAtIndex:[pickerView selectedRowInComponent:0]]];
        [selectedNumber addObject:[((NSMutableArray *)lessonArray[1]) objectAtIndex:[pickerView selectedRowInComponent:1]]];
        [selectedNumber addObject:[@([pickerView selectedRowInComponent:2]+1) stringValue]];
        [selectedNumber addObject:[@([pickerView selectedRowInComponent:3]+1) stringValue]];
        
        workingClass.lesson=[selectedNumber componentsJoinedByString:@"/"];
        [MakeupTable reloadData];
    }
}


-(NSString *) returnupdatefollowinglessonsfieldsvalue
{
    NSMutableArray *tmparray=[[NSMutableArray alloc]init];
    if(updatefollowinglessonsfieldsarray.count==0){
        return [MyClass returntitlewithtitle:@"Select"];
    }else{
        for (int i=0; i<updatefollowinglessonsfieldsarray.count; i++) {
            [tmparray addObject:[MyClass returntitlewithtitle:updatefollowinglessonsfieldsarray[i]]];
        }
        return [tmparray componentsJoinedByString:@" | "];
    }
}


-(BOOL) enableDoneButton
{
    if ([PopoverOption isEqualToString:@"DailyScheduleLesson"]){
        
        if(updatefollowinglessons && updatefollowinglessonsfieldsarray.count==0){
            return NO;
        }
        
        if(workingClass.lesson){
            if(![workingClass.lesson isEqualToString:[MyClass returnLessonNumberWithClassScheduleRecords:PopoverLessonAndClassRecord.classScheduleRecordArray]]){
                return YES;
            }
        }
        
        if (updatefollowinglessons && updatefollowinglessonsfieldsarray.count>0){
            return YES;
        }
        
        if (![workingClass.absentmakeupreason isEqualToString:@""] && workingClass.absentmakeupreason){
            return YES;
        }else{
            if ([workingClass.makeupdate isEqualToString:@""]) {
                return NO;
            }
            
            
            NSString *workingmakeupstring=[NSString stringWithFormat:@"%@%@%@%@%@",workingClass.makeupdate,workingClass.makeuptime,workingClass.makeupinstructor,workingClass.makeupclassroom,workingClass.makeupsinstructor];
            NSString *lessonstring=[NSString stringWithFormat:@"%@%@%@%@%@",PopoverLessonRecord.classdate,PopoverLessonRecord.classtime,PopoverLessonRecord.instructor,PopoverLessonRecord.classroom,PopoverLessonRecord.sinstructor];
            
            if (![workingmakeupstring isEqualToString:lessonstring]) {
                return YES;
            }

        }
    }else if ([PopoverOption isEqualToString:@"FromClassSchedule"] || [PopoverOption isEqualToString:@"FromTaskView"]){
        if (![workingClass.absentmakeupreason isEqualToString:PopoverClassRecord.absentmakeupreason]){
            return YES;
        }else{
            if ([PopoverClassRecord.makeupdate isEqualToString:@""] && [workingClass.makeupdate isEqualToString:@""]) {
                return NO;
            }
            
            if (![PopoverOption isEqualToString:@"FromTaskView"] && updatefollowinglessons && updatefollowinglessonsfieldsarray.count>0){
                return YES;
            }
            
            NSString *workingmakeupstring=[NSString stringWithFormat:@"%@%@%@%@%@",workingClass.makeupdate,workingClass.makeuptime,workingClass.makeupinstructor,workingClass.makeupclassroom,workingClass.makeupsinstructor];
            NSString *origmakeupstring=[NSString stringWithFormat:@"%@%@%@%@%@",PopoverClassRecord.makeupdate,PopoverClassRecord.makeuptime,PopoverClassRecord.makeupinstructor,PopoverClassRecord.makeupclassroom,PopoverClassRecord.makeupsinstructor];
            NSString *classstring=[NSString stringWithFormat:@"%@%@%@%@%@",PopoverClassRecord.startdate,PopoverClassRecord.classtime,PopoverClassRecord.instructor,PopoverClassRecord.classroom,PopoverClassRecord.sinstructor];
            
            if (![workingmakeupstring isEqualToString:origmakeupstring] && ![workingmakeupstring isEqualToString:classstring]) {
                return YES;
            }

        }
    }else{ // from student details information page
        if (![workingClass.absentmakeupreason isEqualToString:PopoverDetailsClassRecord.absentmakeupreason]){
            return YES;
        }else{
            if ([PopoverClassRecord.makeupdate isEqualToString:@""] && [workingClass.makeupdate isEqualToString:@""]) {
                return NO;
            }
            
            if (updatefollowinglessons && updatefollowinglessonsfieldsarray.count>0){
                return YES;
            }
            
            NSString *workingmakeupstring=[NSString stringWithFormat:@"%@%@%@%@%@",workingClass.makeupdate,workingClass.makeuptime,workingClass.makeupinstructor,workingClass.makeupclassroom,workingClass.makeupsinstructor];
            NSString *origmakeupstring=[NSString stringWithFormat:@"%@%@%@%@%@",PopoverDetailsClassRecord.makeupdate,PopoverDetailsClassRecord.makeuptime,PopoverDetailsClassRecord.makeupinstructor,PopoverDetailsClassRecord.makeupclassroom,PopoverDetailsClassRecord.makeupsinstructor];
            NSString *classstring=[NSString stringWithFormat:@"%@%@%@%@%@",PopoverDetailsClassRecord.startdate,PopoverDetailsClassRecord.classtime,PopoverDetailsClassRecord.instructor,PopoverDetailsClassRecord.classroom,PopoverDetailsClassRecord.sinstructor];
            
            if (![workingmakeupstring isEqualToString:origmakeupstring] && ![workingmakeupstring isEqualToString:classstring]) {
                return YES;
            }
        }
    }
    return NO;
}



-(void) InitializeField
{
    showMakeupDatePicker=NO;
    showClassroomTable=NO;
    showInstructorTable=NO;
    showSInstructorTable=NO;
    NSString *tmpaction;
    
    workingClass=[[ClassScheduleRecord alloc]init];
    updatefollowinglessons=FALSE;
    if ([PopoverOption isEqualToString:@"DailyScheduleLesson"]){
        PopoverLessonRecord=PopoverLessonAndClassRecord.lesson;
        workingClass.subject=PopoverLessonRecord.subject;
        workingClass.startdate=PopoverLessonRecord.classdate;
        workingClass.classtime=PopoverLessonRecord.classtime;
        workingClass.absentmakeupreason=@"";
        workingClass.remarks=@"";
        workingClass.allclassremarks=@"";

        tmpDefaultMakeupDateTime=[NSString stringWithFormat:@"%@ %@",PopoverLessonRecord.classdate,PopoverLessonRecord.classtime];
        tmpDefaultMakeupInstructor=PopoverLessonRecord.instructor;
        tmpDefaultMakeupSInstructor=PopoverLessonRecord.sinstructor;
        tmpDefaultMakeupClassroom=PopoverLessonRecord.classroom;
        
        //set default
        workingClass.makeupdate=PopoverLessonRecord.classdate;
        workingClass.makeuptime=PopoverLessonRecord.classtime;
        workingClass.makeupinstructor=PopoverLessonRecord.instructor;
        workingClass.makeupsinstructor=PopoverLessonRecord.sinstructor;
        workingClass.makeupclassroom=PopoverLessonRecord.classroom;
        workingClass.makeupattendance=@"";
        workingClass.classkey=@"";
        tmpaction=@"Add";

        workingClass.schedulekey=@"";
        workingClass.leavenaturelistkey=[MyClass returnDefaultLeaveNatureListKeyWithAttendance:@"Makeup"];
        
        lessonArray=[MyClass returnLessonNumberArrayWithSubject:workingClass.subject];
        
    }else if ([PopoverOption isEqualToString:@"FromClassSchedule"]|| [PopoverOption isEqualToString:@"FromTaskView"]){
        if ([PopoverClassRecord.makeupdate isEqualToString:@""]) {
            //workingClass.makeupdate=@"";
            //workingClass.makeuptime=@"";
            tmpDefaultMakeupDateTime=[NSString stringWithFormat:@"%@ %@",PopoverClassRecord.startdate,PopoverClassRecord.classtime];
            tmpDefaultMakeupInstructor=PopoverClassRecord.instructor;
            tmpDefaultMakeupSInstructor=PopoverClassRecord.sinstructor;
            tmpDefaultMakeupClassroom=PopoverClassRecord.classroom;
            workingClass.makeupattendance=globalvariables.centerrecord.defaultattendancestatus;
            
            //set default
            workingClass.makeupdate=@"";//PopoverClassRecord.startdate;
            workingClass.makeuptime=@"";//PopoverClassRecord.classtime;
            workingClass.makeupinstructor=@"";//tmpDefaultMakeupInstructor;
            workingClass.makeupsinstructor=@"";
            workingClass.makeupclassroom=@"";//tmpDefaultMakeupClassroom;
            workingClass.leavenaturelistkey=[MyClass returnDefaultLeaveNatureListKeyWithAttendance:@"Makeup"];
            
        }else{
            
            tmpDefaultMakeupDateTime=[NSString stringWithFormat:@"%@ %@",PopoverClassRecord.makeupdate,PopoverClassRecord.makeuptime];
            tmpDefaultMakeupInstructor=PopoverClassRecord.makeupinstructor;
            tmpDefaultMakeupSInstructor=PopoverClassRecord.makeupsinstructor;
            tmpDefaultMakeupClassroom=PopoverClassRecord.makeupclassroom;
            workingClass.makeupattendance=PopoverClassRecord.makeupattendance;
            
            workingClass.makeupdate=PopoverClassRecord.makeupdate;
            workingClass.makeuptime=PopoverClassRecord.makeuptime;
            workingClass.makeupinstructor=tmpDefaultMakeupInstructor;
            workingClass.makeupsinstructor=tmpDefaultMakeupSInstructor;
            workingClass.makeupclassroom=tmpDefaultMakeupClassroom;
            workingClass.leavenaturelistkey=PopoverClassRecord.leavenaturelistkey;
        }
        
        workingClass.attendance=PopoverClassRecord.attendance;
        workingClass.absentmakeupreason=PopoverClassRecord.absentmakeupreason;
        workingClass.subject=PopoverClassRecord.subject;
        workingClass.remarks=PopoverClassRecord.remarks;
        workingClass.allclassremarks=PopoverClassRecord.allclassremarks;
        workingClass.classkey=PopoverClassRecord.classkey;
        workingClass.studentkey=PopoverClassRecord.studentkey;
        tmpaction=@"";
        workingClass.schedulekey=PopoverClassRecord.schedulekey;
        
    }else{ // from student details information page
        if ([PopoverDetailsClassRecord.makeupdate isEqualToString:@""]) {
            //workingClass.makeupdate=@"";
            //workingClass.makeuptime=@"";
            tmpDefaultMakeupDateTime=[NSString stringWithFormat:@"%@ %@",PopoverDetailsClassRecord.startdate,PopoverDetailsClassRecord.classtime];
            
            if ([PopoverDetailsClassRecord.makeupinstructor isEqualToString:@""]) {
                tmpDefaultMakeupInstructor=PopoverDetailsClassRecord.instructor;
            }else{
                tmpDefaultMakeupInstructor=PopoverDetailsClassRecord.makeupinstructor;
            }
            
            if ([PopoverDetailsClassRecord.makeupsinstructor isEqualToString:@""]) {
                tmpDefaultMakeupSInstructor=PopoverDetailsClassRecord.sinstructor;
            }else{
                tmpDefaultMakeupSInstructor=PopoverDetailsClassRecord.makeupsinstructor;
            }
            
            if ([PopoverDetailsClassRecord.makeupclassroom isEqualToString:@""]) {
                tmpDefaultMakeupClassroom=PopoverDetailsClassRecord.classroom;
            }else{
                tmpDefaultMakeupClassroom=PopoverDetailsClassRecord.makeupclassroom;
            }
            
            workingClass.makeupattendance=globalvariables.centerrecord.defaultattendancestatus;
            workingClass.leavenaturelistkey=[MyClass returnDefaultLeaveNatureListKeyWithAttendance:@"Makeup"];
            
            //set default
            workingClass.makeupdate=@"";//PopoverDetailsClassRecord.startdate;
            workingClass.makeuptime=@"";//PopoverDetailsClassRecord.classtime;
            workingClass.makeupinstructor=@"";//tmpDefaultMakeupInstructor;
            workingClass.makeupsinstructor=@"";
            workingClass.makeupclassroom=@"";//tmpDefaultMakeupClassroom;
            
        }else{
            workingClass.makeupdate=PopoverDetailsClassRecord.makeupdate;
            workingClass.makeuptime=PopoverDetailsClassRecord.makeuptime;
            workingClass.makeupattendance=PopoverDetailsClassRecord.makeupattendance;
            workingClass.makeupinstructor=PopoverDetailsClassRecord.makeupinstructor;
            workingClass.makeupsinstructor=PopoverDetailsClassRecord.makeupsinstructor;
            workingClass.makeupclassroom=PopoverDetailsClassRecord.makeupclassroom;
            tmpDefaultMakeupDateTime=[NSString stringWithFormat:@"%@ %@",PopoverDetailsClassRecord.startdate,PopoverDetailsClassRecord.classtime];
            tmpDefaultMakeupInstructor=PopoverDetailsClassRecord.instructor;
            tmpDefaultMakeupSInstructor=PopoverDetailsClassRecord.sinstructor;
            tmpDefaultMakeupClassroom=PopoverDetailsClassRecord.classroom;
            workingClass.leavenaturelistkey=PopoverDetailsClassRecord.leavenaturelistkey;
        }

        workingClass.attendance=PopoverDetailsClassRecord.attendance;
        workingClass.absentmakeupreason=PopoverDetailsClassRecord.absentmakeupreason;
        workingClass.subject=PopoverDetailsClassRecord.subject;
        workingClass.remarks=PopoverDetailsClassRecord.remarks;
        workingClass.allclassremarks=PopoverDetailsClassRecord.allclassremarks;
        workingClass.classkey=PopoverDetailsClassRecord.classkey;
        workingClass.studentkey=PopoverDetailsClassRecord.studentkey;
        tmpaction=@"";
        workingClass.schedulekey=PopoverDetailsClassRecord.schedulekey;
    }
    
    if (![workingClass.makeupdate isEqualToString:@""]) {
        NSString *tmpinstructor;
        NSString *tmpclassroom;
        NSString *tmpsinstructor;
        
        tmpinstructor=[workingClass.makeupinstructor isEqualToString:@""]?@"TBD":workingClass.makeupinstructor;
        tmpclassroom=[workingClass.makeupclassroom isEqualToString:@""]?@"TBD":workingClass.makeupclassroom;
        tmpsinstructor=[workingClass.makeupsinstructor isEqualToString:@""]?@"TBD":workingClass.makeupsinstructor;
        
        FreeScheduleClassArray=[[NSMutableArray alloc]initWithObjects:[[FreeScheduleClass alloc]initFreeScheduleClassWithclasskey:workingClass.classkey subject:workingClass.subject classdate:nil classtime:nil instructor:nil classroom:nil attendance:nil makeupdate:workingClass.makeupdate makeuptime:workingClass.makeuptime makeupinstructor:tmpinstructor makeupclassroom:tmpclassroom makeupattendance:globalvariables.centerrecord.defaultattendancestatus classremarks:workingClass.remarks allclassremarks:workingClass.allclassremarks action:tmpaction classtype:@"Class" leavenaturelistkey:workingClass.leavenaturelistkey lesson:@"" sinstructor:nil makeupsinstructor:tmpsinstructor locked:workingClass.locked], nil];
    }else{
        FreeScheduleClassArray=[[NSMutableArray alloc]init];
    }
    
}

-(void) passFreeSscheduleInformationwithArray:(NSMutableArray *)freescheduleclassarray
{
    //not required
}


-(NSMutableArray *) returnfreescheduleclassarray
{
    FreeScheduleClass *freescheduleclass_object=[[FreeScheduleClass alloc]init];
    
    freescheduleclass_object.classkey=workingClass.classkey;
    freescheduleclass_object.subject=workingClass.subject;
    freescheduleclass_object.attendance=@"Makeup";
    
    freescheduleclass_object.makeupdate=workingClass.makeupdate;
    freescheduleclass_object.makeuptime=workingClass.makeuptime;
    freescheduleclass_object.makeupinstructor=[workingClass.makeupinstructor isEqualToString:@""]?@"TBD":workingClass.makeupinstructor;
    freescheduleclass_object.makeupsinstructor=[workingClass.makeupsinstructor isEqualToString:@""]?@"TBD":workingClass.makeupsinstructor;
    freescheduleclass_object.makeupclassroom=[workingClass.makeupclassroom isEqualToString:@""]?@"TBD":workingClass.makeupclassroom;
    freescheduleclass_object.makeupattendance=workingClass.makeupattendance;
    freescheduleclass_object.classremarks=workingClass.absentmakeupreason;
    freescheduleclass_object.classtype=@"Class";
    freescheduleclass_object.leavenaturelistkey=workingClass.leavenaturelistkey;
    freescheduleclass_object.lesson=workingClass.lesson;
    

    freescheduleclass_object.leavenaturelistkey=workingClass.leavenaturelistkey;
    freescheduleclass_object.action=@"Edit";
        
    return [[NSMutableArray alloc]initWithObjects:freescheduleclass_object, nil];
}




-(void)resetButtonPressed:(id)sender
{
    //MakeupDateTimeLabel.text=@"";
    //MakeupInstructorLabel.text=@"";
    //MakeupClassroomLabel.text=@"";
    //absentMakeupReasonText.text=@"";
    workingClass.makeupdate=@"";
    workingClass.makeuptime=@"";
    workingClass.makeupinstructor=@"";
    workingClass.makeupclassroom=@"";
    workingClass.absentmakeupreason=@"";
    workingClass.leavenaturelistkey=[MyClass returnDefaultLeaveNatureListKeyWithAttendance:@"Makeup"];
    //resetattendance=NO;
    showMakeupDatePicker=NO;
    showInstructorTable=NO;
    showClassroomTable=NO;
    workingClass.makeupattendance=globalvariables.centerrecord.defaultattendancestatus;
    updatefollowinglessons=NO;
    
    [MakeupTable reloadData];
    [self adjusttablesize];
    doneButton.enabled=[self enableDoneButton];
    
}

-(void)postponeButtonPressed:(id)sender
{
    if ([PopoverOption isEqualToString:@"DailyScheduleLesson"]) {
        UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Are you sure to postpone all the classes in the lesson?"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate postponeClassesFromMakeupWindowWithClassrecords:PopoverLessonAndClassRecord.classScheduleRecordArray];
            });
        }];
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        
        [changealert addAction:OKAction];
        [changealert addAction:CancelAction];
        
        [self presentViewController:changealert animated:YES completion:nil];
    }else{
        NSString *classkey;
        NSString *classroom;
        NSString *instructor;
        
        if ([PopoverOption isEqualToString:@"FromClassSchedule"]|| [PopoverOption isEqualToString:@"FromTaskView"]) {
            classkey=PopoverClassRecord.classkey;
            classroom=PopoverClassRecord.classroom;
            instructor=PopoverClassRecord.instructor;
        }else{
            classkey=PopoverDetailsClassRecord.classkey;
            classroom=PopoverDetailsClassRecord.classroom;
            instructor=PopoverDetailsClassRecord.instructor;
        }
        
        NSString *postponedate=[MyClass getPostponeDateTimeWithClassKey:classkey];
        
        if(postponedate){
            workingClass.makeupdate=[MyClass convertDateFormatWithDate:postponedate FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd-MMM-yyyy"];
            workingClass.makeuptime=[postponedate substringFromIndex:11];
            if ([workingClass.makeupinstructor isEqualToString:@""]) {
                workingClass.makeupinstructor=instructor;
            }
            
            if ([workingClass.makeupclassroom isEqualToString:@""]) {
                workingClass.makeupclassroom=classroom;
            }
        }

        
        [MakeupTable reloadData];
        doneButton.enabled=[self enableDoneButton];
    }
    
    
    

 }


-(void) InstructorButtonPressed:(UIButton *)sender
{
    //popup make up information
    instructorimagepopover = (InstructorImageGridViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"InstructorImageGridViewController"];
    instructorimagepopover.delegate=self;
    instructorimagepopover.instructorArray=[MyClass filterInstructorArrayWithInstructorArray:AllInstructorArray Valid:@"Yes"];
    
    instructorimagepopover.modalPresentationStyle = UIModalPresentationFormSheet;
    //[self presentViewController:instructorimagepopover animated:YES completion:nil];
    [MyClass presentViewController:instructorimagepopover View:self];
    
}

-(void) dismissinstructorgridview
{
    [instructorimagepopover dismissViewControllerAnimated:YES completion:nil];
}

-(void) passinstructorfromgrid:(NSString *)username
{
    [instructorimagepopover dismissViewControllerAnimated:YES completion:nil];
    
    if (![workingClass.makeupinstructor isEqualToString:username]) {
        
        workingClass.makeupinstructor=username;
        showInstructorTable=NO;
        
        //[self storeTmpField];
        
        [InstructorTable reloadData];
        [MakeupTable reloadData];
        
        [self adjusttablesize];
        
        //[self updatefreescheduleclassarraywithfield:@"MakeupInstructor" value:workingClass.makeupinstructor];
    }
}


-(void) passinstructorlistfromgrid:(NSString *)instructorlist
{
    //delegate not used
}

-(void) adjusttablesize
{
    float tableheight;
    float tablewidth;
    
    
    tableheight=maxPopupHeight-keyboardheight;
    
    if (showInstructorTable){
        tablewidth=popoverwidth+instructortablewidth;
    }else if (showSInstructorTable){
        tablewidth=popoverwidth+instructortablewidth;
    }else if (showClassroomTable){
        tablewidth=popoverwidth+classroomtablewidth;
    }else if (showNatureTable){
        tablewidth=popoverwidth+naturetablewidth;
    }else if (showLessonNumberTable){
        tablewidth=popoverwidth+lessonnumbertablewidth;
    }else if (showUpdateFollowingLessonsFieldsTable){
        tablewidth=popoverwidth+updatefollowinglessonsfieldstablewidth;
    }else{
        tablewidth=popoverwidth;
    }
    
//    [MakeupTable setFrame:CGRectMake(0, 44+20, popoverwidth, tableheight-44-20)];
    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    
    self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
    
    
    if (showInstructorTable){
        [InstructorTable setFrame:CGRectMake(0, 44+84+20+3, instructortablewidth, tableheight-44-84-20-3)];
        //InstructorTableMasterView.frame=CGRectMake(popoverwidth, 0, instructortablewidth, self.view.frame.size.height);
        InstructorTableMasterView.hidden=NO;
        SInstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        NatureTableMasterView.hidden=YES;
        LessonNumberTableMasterView.hidden=YES;
        UpdateFollowingLessonsFieldsTableMasterView.hidden=YES;
        
        if(filteredActiveInstructorArray.count>0){
            presetRow=[MyClass returnInstructorIndexWithInstructorArray:filteredActiveInstructorArray username:workingClass.makeupinstructor activeinstructor:YES defaultzeroifnotfound:YES];
            [InstructorTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }

    }else if (showSInstructorTable){
        [SInstructorTable setFrame:CGRectMake(0, 44+84+20+3, instructortablewidth, tableheight-44-84-20-3)];
        //InstructorTableMasterView.frame=CGRectMake(popoverwidth, 0, instructortablewidth, self.view.frame.size.height);
        InstructorTableMasterView.hidden=YES;
        SInstructorTableMasterView.hidden=NO;
        ClassroomTableMasterView.hidden=YES;
        NatureTableMasterView.hidden=YES;
        LessonNumberTableMasterView.hidden=YES;
        UpdateFollowingLessonsFieldsTableMasterView.hidden=YES;
        
        if(filteredActiveInstructorArray.count>0){
            presetRow=[MyClass returnInstructorIndexWithInstructorArray:filteredActiveInstructorArray username:workingClass.makeupsinstructor activeinstructor:YES defaultzeroifnotfound:YES];
            [SInstructorTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }

    }else if (showClassroomTable){
        [ClassroomTable setFrame:CGRectMake(0, 44+84+20+3, classroomtablewidth, tableheight-44-84-20-3)];
        //ClassroomTableMasterView.frame=CGRectMake(popoverwidth, 0, classroomtablewidth, self.view.frame.size.height);
        InstructorTableMasterView.hidden=YES;
        SInstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=NO;
        NatureTableMasterView.hidden=YES;
        LessonNumberTableMasterView.hidden=YES;
        UpdateFollowingLessonsFieldsTableMasterView.hidden=YES;
        
        if(filteredClassroomArray.count>0){
            presetRow=[MyClass returnClassroomIndexWithClassroomArray:filteredClassroomArray classroom:workingClass.makeupclassroom defaultzeroifnotfound:YES];
            [ClassroomTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }

    }else if (showNatureTable){
        [NatureTable setFrame:CGRectMake(0, 44+44+20, naturetablewidth, tableheight-44-44-20)];
        //ClassroomTableMasterView.frame=CGRectMake(popoverwidth, 0, classroomtablewidth, self.view.frame.size.height);
        InstructorTableMasterView.hidden=YES;
        SInstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        NatureTableMasterView.hidden=NO;
        LessonNumberTableMasterView.hidden=YES;
        UpdateFollowingLessonsFieldsTableMasterView.hidden=YES;
        
        //presetRow=[MyClass returnClassroomIndexWithClassroomArray:classroomArray classroom:workingClass.makeupclassroom defaultzeroifnotfound:YES];
        //[NatureTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }else if (showLessonNumberTable){
        lessonnumbertablebottomconstraint.constant=keyboardheight;
        InstructorTableMasterView.hidden=YES;
        SInstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        NatureTableMasterView.hidden=YES;
        LessonNumberTableMasterView.hidden=NO;
        UpdateFollowingLessonsFieldsTableMasterView.hidden=YES;
    }else if (showUpdateFollowingLessonsFieldsTable){
        InstructorTableMasterView.hidden=YES;
        SInstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        NatureTableMasterView.hidden=YES;
        LessonNumberTableMasterView.hidden=YES;
        UpdateFollowingLessonsFieldsTableMasterView.hidden=NO;
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (keyboardheight>0) {
        CGPoint point = [textView.superview convertPoint:CGPointZero toView:MakeupTable];
        NSIndexPath *indexpath =[MakeupTable indexPathForRowAtPoint:point];
        
        CGRect rectInTableView = [MakeupTable rectForRowAtIndexPath:indexpath];
        CGFloat yoffset=rectInTableView.origin.y+rectInTableView.size.height-MakeupTable.frame.size.height;
        if(yoffset>0){
            [MakeupTable setContentOffset:CGPointMake(0, yoffset) animated:YES];
        }
    }
}

-(void) textViewDidChange:(UITextView *)textView
{
    if (textView==absentMakeupReasonText) {
        workingClass.absentmakeupreason=textView.text;
        if ([PopoverOption isEqualToString:@"DailyScheduleLesson"]){
            if([textView.text isEqualToString:@""]){
                workingClass.absentmakeupreason=nil;
            }
        }
        doneButton.enabled=[self enableDoneButton];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView==MakeupTable) {
        return 44;
    }else if (tableView==LessonNumberTable){
        return 44;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView==MakeupTable) {
        if(section==1){
            if ([PopoverOption isEqualToString:@"DailyScheduleLesson"]) {
                return 28;
            }
        }
    }
    return CGFLOAT_MIN;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if (searchBar.tag==3) {
        if ([searchText isEqualToString:@""]) {
            filteredClassroomArray=[[NSMutableArray alloc]initWithArray:allClassroomArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.classroom contains[c] %@ or self.remarks contains[c] %@",searchText,searchText];
            filteredClassroomArray=[[NSMutableArray alloc]initWithArray:[allClassroomArray filteredArrayUsingPredicate:predicate]];
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


-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)_makeuptimearray
{
    NSString *selecteddatestring=[selecteddatearray firstObject];
    
    if([selectedItem isEqualToString:@"MakeupDateTime"]){
        if(selectedCalendarType==0){
            if(![workingClass.makeupdate isEqualToString:selecteddatestring]){
                workingClass.makeupdate=selecteddatestring;
                workingClass.makeupattendance=globalvariables.centerrecord.defaultattendancestatus;
                [MakeupTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }else{
            if(![workingClass.makeupdate isEqualToString:selecteddatestring] || [self returnTimeIndex]<0){
                workingClass.makeupdate=selecteddatestring;
                workingClass.makeupattendance=globalvariables.centerrecord.defaultattendancestatus;
                makeuptimearray=_makeuptimearray;
                LessonRecord2 *object=[makeuptimearray firstObject];
                workingClass.makeuptime=[object.datetime substringFromIndex:11];
                workingClass.makeupinstructor=object.instructor;
                workingClass.makeupclassroom=object.classroom;
                [MakeupTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0],[NSIndexPath indexPathForRow:3 inSection:0],[NSIndexPath indexPathForRow:4 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            }

            
        }
        doneButton.enabled=[self enableDoneButton];
    }
}

-(void) selectcalendartype:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex==1){
        if(!availablemakeuptimeslots){
            [self startloadingindicator:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self getavailablemakeuptimeslots];
                selectedCalendarType=sender.selectedSegmentIndex;
                [MakeupTable reloadData];
                [self startloadingindicator:NO];
            });
        }else{
            selectedCalendarType=sender.selectedSegmentIndex;
            [MakeupTable reloadData];
        }
    }else{
        selectedCalendarType=sender.selectedSegmentIndex;
        [MakeupTable reloadData];
    }

}

-(void) getavailablemakeuptimeslots
{

    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    
    //update to sql
    
    [dictionary setValue:@"getavailablemakeuptimeslots" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:workingClass.classkey forKey:@"classkey"];
    
//    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray=jsonreturned[@"content"];
            availablemakeuptimeslots=[[NSMutableDictionary alloc]init];
            
            NSString *classdate;
            NSString *classtime;
            NSString *instructor;
            NSString *sinstructor;
            NSString *classroom;
            NSString *level;
            NSArray *timeslots;
            NSMutableArray *timeslotsarray;
            for(int i=0;i<JSONArray.count;i++){
                classdate=[[JSONArray objectAtIndex:i] objectForKey:@"classdate"];
                timeslots=[[JSONArray objectAtIndex:i] objectForKey:@"timeslots"];
                timeslotsarray=[[NSMutableArray alloc]init];
                for (int j=0;j<timeslots.count;j++){
                    classtime=[[timeslots objectAtIndex:j] objectForKey:@"classtime"];
                    instructor=[[timeslots objectAtIndex:j] objectForKey:@"instructor"];
                    sinstructor=[[timeslots objectAtIndex:j] objectForKey:@"sinstructor"];
                    classroom=[[timeslots objectAtIndex:j] objectForKey:@"classroom"];
                    level=[[timeslots objectAtIndex:j] objectForKey:@"level"];
                    [timeslotsarray addObject:[[LessonRecord2 alloc]initLessonRecord2withdatetime:[NSString stringWithFormat:@"%@ %@",classdate,classtime] instructor:instructor classroom:classroom level:level sinstructor:sinstructor]];
                }
                
                [availablemakeuptimeslots setObject:timeslotsarray forKey:classdate];
            }
        }
    }];
}

-(NSInteger) returnTimeIndex
{
    for(int i=0;i<makeuptimearray.count;i++){
        if([[((LessonRecord2 *)[makeuptimearray objectAtIndex:i]).datetime substringFromIndex:11] isEqualToString:workingClass.makeuptime]){
            return i;
        }
    }
    return -1;
}

- (void)selectupdatefollowinglessons:(UISwitch *)sender {
    [self.view endEditing:YES];
    updatefollowinglessons=sender.on;
    [MakeupTable reloadData];
//    [self adjusttablesize];
    doneButton.enabled=[self enableDoneButton];
}


@end
