//
//  DTAddEditViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 5/11/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "DTAddEditViewController.h"
#import "StudentInformationViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MainMenuViewController.h"
#import "ClassTimeTableViewController.h"
#import "MyClass.h"

@interface DTAddEditViewController ()//<myClassTimeTableViewControllerDelegate>

@end

@implementation DTAddEditViewController
@synthesize DTAddEditToolbar;
@synthesize DTAddEditViewAction,DTAddEditViewDTkey;
@synthesize JSONArray;
@synthesize classtimetableviewcontroller,classscheduleviewcontroller;
@synthesize masterView,DTPopoverTable,DTTableMode,InstructorArray,pickerViewmenu,hourPickerViewMenu,minutePickerViewMenu,myPickerView;
@synthesize PopoverMode,levelctmPickerViewMenu,levelmainPickerViewMenu,subjectArray,CallingSource,CallingKey;
@synthesize ViewATObject;

#define maxPopupHeight self.view.frame.size.height
#define popoverwidth 360
#define instructortablewidth 300
#define classroomtablewidth 300
#define subjecttablewidth 470
#define gradetablewidth 300
#define leveltablewidth 300
#define durationtablewidth 300
#define languagetablewidth 300
#define mediatablewidth 300
#define sourcetablewidth 300
#define schooltablewidth 400
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
    // Do any additional setup after loading the view.
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    workingATObject=[[AssessmentTrialRecord alloc]init];
    keyboardshow=FALSE;
    
    df =[[NSDateFormatter alloc]init];

    [MyClass getLatestDataSetv2withParameters:@"subject,classroom,marketing,staff" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    
    if (!subjectArray) {
        subjectArray=[MyClass retrievesubjectinformationwithstatus:@"Active" category:@"All" flushcachedata:NO];
        if (!subjectArray) {
            dismisspopoverduetoconnectionerror=YES;
            return;
        }else{
            dismisspopoverduetoconnectionerror=NO;
        }
    }
    
    if (!SchoolArray) {
        SchoolArray=[MyClass retrieveschoollist];
    }
    
    
    if (!ClassroomArray) {
        ClassroomArray=[MyClass retrieveClassroomListwithstatus:@"In Service" withTBD:YES flushcachedata:NO];
        if (!ClassroomArray) {
            dismisspopoverduetoconnectionerror=YES;
            return;
        }else{
            dismisspopoverduetoconnectionerror=NO;
        }
    }
    
    if (!MediaArray || !SourceArray) {
        NSMutableArray *marketingarray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveMarketingRecordWithStatus:@"Valid" enrollmentdate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] flushcachedata:NO subjectkey:nil productkey:nil]];
        MediaArray=[[NSMutableArray alloc]initWithArray:[marketingarray objectAtIndex:0]];
        SourceArray=[[NSMutableArray alloc]initWithArray:[marketingarray objectAtIndex:1]];
        
        
        [MediaArray insertObject:[[MarketingRecord alloc]initMarketingRecordWithcenterkey:@"" marketingkey:@"" category:@"" description:@"" description_chinese:@"" startdate:@"" enddate:@"" remarks:@"" promotionfixeddiscount:@"" promotionpercentagediscount:@"" usedcount:@"" promotionquota:@"" code:@"" recursive:nil effectivefrom:nil effectiveto:nil subcategory:nil redeemable:NO redeempoint:nil perstudentquota:nil cannotuseconjunctionwithothercoupons:NO subjectarray:nil productarray:nil couponallowcredit:nil perclassorquantity:NO earlybirdlastdate:nil buymorepayless:NO estartdate:nil eenddate:nil enablebuymorepayless:NO minnoofclass:0 bmsmacrossothersubjects:NO bmsmminsubjectno:0 bmsmminnoofclasspersubject:0 bmsmsamebillmonth:NO manualapply:YES] atIndex:0];
        [SourceArray insertObject:[[MarketingRecord alloc]initMarketingRecordWithcenterkey:@"" marketingkey:@"" category:@"" description:@"" description_chinese:@"" startdate:@"" enddate:@"" remarks:@"" promotionfixeddiscount:@"" promotionpercentagediscount:@"" usedcount:@"" promotionquota:@"" code:@"" recursive:nil effectivefrom:nil effectiveto:nil subcategory:nil redeemable:NO redeempoint:nil perstudentquota:nil cannotuseconjunctionwithothercoupons:NO subjectarray:nil productarray:nil couponallowcredit:nil perclassorquantity:NO earlybirdlastdate:nil buymorepayless:NO estartdate:nil eenddate:nil enablebuymorepayless:NO minnoofclass:0 bmsmacrossothersubjects:NO bmsmminsubjectno:0 bmsmminnoofclasspersubject:0 bmsmsamebillmonth:NO manualapply:YES] atIndex:0];
        
        if (!MediaArray || !SourceArray) {
            dismisspopoverduetoconnectionerror=YES;
            return;
        }else{
            dismisspopoverduetoconnectionerror=NO;
        }
    }

    if (DTAddEditViewDTkey) {
        if(![self retrieveDTRecordWithDTkey:DTAddEditViewDTkey]){
            dismisspopoverduetoconnectionerror=YES;
            return;
        }else{
            dismisspopoverduetoconnectionerror=NO;
        }
    }

    InstructorArray= [MyClass retrieveInstructorListwithvalid:@"All" flushcachedata:NO];
    if(!InstructorArray){
        dismisspopoverduetoconnectionerror=YES;
        return;
    }else{
        dismisspopoverduetoconnectionerror=NO;
    }
    
    [self InitializeField];
    [self createsidetables];

    
    DTPopoverTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    DTPopoverTable.dataSource=self;
    DTPopoverTable.delegate=self;
    DTAddEditToolbar.clipsToBounds=YES;
    DTPopoverTable.sectionHeaderHeight=CGFLOAT_MIN;
    
    [DTPopoverTable reloadData];
    
    if ([DTTableMode isEqualToString:@"View"] ) {
        [self createViewViewBarButton];
    }else if([DTTableMode isEqualToString:@"Add"]){
        [self createAddViewBarButton];
    }
    
    [self adjusttablesize];
    [self.view addSubview:DTPopoverTable];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //add buttonarray
    makeupdtattendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnmakeupattendancebuttonarray]];
    
    
    UIPanGestureRecognizer *panGesture;
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.delegate = self;
    [DTPopoverTable addGestureRecognizer:panGesture];

    [editButton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
     [enrollButton setTitle:[MyClass returntitlewithtitle:@"Enroll"] forState:UIControlStateNormal];
      [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
       [addanotherButton setTitle:[MyClass returntitlewithtitle:@"Add Another"] forState:UIControlStateNormal];
        [addanotherdoneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
         [editdoneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
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
            
            [UIView animateWithDuration:0.4 animations:^{self->attendanceringview.alpha = 0.0;} completion:^(BOOL finished){ [attendanceringview removeFromSuperview]; }];
            attendanceringview=nil;
            DTPopoverTable.scrollEnabled=TRUE;
            [DTPopoverTable deselectRowAtIndexPath:[DTPopoverTable indexPathForSelectedRow] animated: YES];
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

-(void) createsidetables
{
    gradeArray=[[NSMutableArray alloc]initWithArray:[((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).grade componentsSeparatedByString:@","]];
    [gradeArray insertObject:@"" atIndex:0];
    
    subjectArray=[MyClass retrievesubjectinformationwithstatus:@"Active" category:@"All" flushcachedata:NO];
    filteredSubjectArray=[[NSMutableArray alloc]initWithArray:subjectArray];
    [self sortFilteredSubjectArray];
    //[SubjectTable reloadData];
    
    InstructorArray=[MyClass retrieveInstructorListwithvalid:@"Yes" flushcachedata:NO];
    filteredInstructorArray=[[NSMutableArray alloc]initWithArray:InstructorArray];
    
    ClassroomArray=[MyClass retrieveClassroomListwithstatus:@"In Service" withTBD:YES flushcachedata:NO];
    durationArray=[[NSMutableArray alloc]init];
    for (int i=1; i<=5*60/[globalvariables.centerrecord.classtimeinterval intValue]; i++) {
        [durationArray addObject:[NSString stringWithFormat:@"%d",[globalvariables.centerrecord.classtimeinterval intValue]*i]];
    }

    languageArray=[[NSMutableArray alloc]initWithObjects:@"Cantonese",@"English",@"Mandarin",nil];
    
    
    
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
    instructorsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    instructorsearchbar.delegate=self;
    [headerView addSubview:instructorsearchbar];
    
    InstructorTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84+20+3, instructortablewidth, self.view.frame.size.height-44-84-20-3) style:UITableViewStyleGrouped];
    InstructorTable.dataSource=self;
    InstructorTable.delegate=self;
    InstructorTable.sectionHeaderHeight=CGFLOAT_MIN;
    //[InstructorTable reloadData];
    [InstructorTableMasterView addSubview:InstructorTable];
    
    InstructorTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, instructortablewidth, 44)];
    InstructorTableToolBar.clipsToBounds=YES;
    [InstructorTableMasterView addSubview:InstructorTableToolBar];
    
    
    [self createInstructorTableToolBar];
    
    //grade
    GradeTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, gradetablewidth, self.view.frame.size.height)];
    [self.view addSubview:GradeTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, GradeTableMasterView.frame.size.width,44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [GradeTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Grade"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    GradeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+44+20, gradetablewidth, self.view.frame.size.height-44-44-20) style:UITableViewStyleGrouped];
    GradeTable.dataSource=self;
    GradeTable.delegate=self;
    //[GradeTable reloadData];
    GradeTable.sectionHeaderHeight=CGFLOAT_MIN;
    [GradeTableMasterView addSubview:GradeTable];
    GradeTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, gradetablewidth, 44)];
    GradeTableToolBar.clipsToBounds=YES;
    [GradeTableMasterView addSubview:GradeTableToolBar];
    [self createGradeTableToolBar];
    
    //subject table
    SubjectTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, subjecttablewidth, self.view.frame.size.height)];
    [self.view addSubview:SubjectTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, SubjectTableMasterView.frame.size.width,84+3)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [SubjectTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Subject"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    subjectsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 40, SubjectTableMasterView.frame.size.width, 42)];
    subjectsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    subjectsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    subjectsearchbar.delegate=self;
    [headerView addSubview:subjectsearchbar];
    
    SubjectTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84+20+3, subjecttablewidth, self.view.frame.size.height-44-84-20-3) style:UITableViewStyleGrouped];
    SubjectTable.dataSource=self;
    SubjectTable.delegate=self;
    SubjectTable.sectionHeaderHeight=CGFLOAT_MIN;
    //[SubjectTable reloadData];
    [SubjectTableMasterView addSubview:SubjectTable];
    
    SubjectTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, subjecttablewidth, 44)];
    SubjectTableToolBar.clipsToBounds=YES;
    [SubjectTableMasterView addSubview:SubjectTableToolBar];
    [self createSubjectTableToolBar];
    
    //classroom
    ClassroomTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, classroomtablewidth, self.view.frame.size.height)];
    [self.view addSubview:ClassroomTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, ClassroomTableMasterView.frame.size.width,44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [ClassroomTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Classroom"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    ClassroomTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+44+20, classroomtablewidth, self.view.frame.size.height-44-44-20) style:UITableViewStyleGrouped];
    ClassroomTable.dataSource=self;
    ClassroomTable.delegate=self;
    ClassroomTable.sectionHeaderHeight=CGFLOAT_MIN;
    //[ClassroomTable reloadData];
    [ClassroomTableMasterView addSubview:ClassroomTable];
    
    UILabel *separator=[[UILabel alloc]initWithFrame:CGRectMake(0, 44+44+20, classroomtablewidth, 0.5)];
    separator.layer.opacity=0.6;
    separator.backgroundColor=[UIColor lightGrayColor];
    [ClassroomTableMasterView addSubview:separator];
    
    ClassroomTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, classroomtablewidth, 44)];
    ClassroomTableToolBar.clipsToBounds = YES;
    [ClassroomTableMasterView addSubview:ClassroomTableToolBar];
    [self createClassroomTableToolBar];
    
    //level
    LevelTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, leveltablewidth, self.view.frame.size.height)];
    [self.view addSubview:LevelTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, ClassroomTableMasterView.frame.size.width,44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [LevelTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Level"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    LevelTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+44+20, leveltablewidth, self.view.frame.size.height-44-44-20) style:UITableViewStyleGrouped];
    LevelTable.dataSource=self;
    LevelTable.delegate=self;
    LevelTable.sectionHeaderHeight=CGFLOAT_MIN;
    //[LevelTable reloadData];
    [LevelTableMasterView addSubview:LevelTable];
    
    separator=[[UILabel alloc]initWithFrame:CGRectMake(0, 44+44+20, leveltablewidth, 0.5)];
    separator.layer.opacity=0.6;
    separator.backgroundColor=[UIColor lightGrayColor];
    [LevelTableMasterView addSubview:separator];
    
    LevelTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, leveltablewidth, 44)];
    LevelTableToolBar.clipsToBounds = YES;
    [LevelTableMasterView addSubview:LevelTableToolBar];
    [self createLevelTableToolBar];

    //duration
    DurationTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, durationtablewidth, self.view.frame.size.height)];
    [self.view addSubview:DurationTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, DurationTableMasterView.frame.size.width,44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [DurationTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Duration"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    DurationTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+44+20, durationtablewidth, self.view.frame.size.height-44-44-20) style:UITableViewStyleGrouped];
    DurationTable.dataSource=self;
    DurationTable.delegate=self;
    DurationTable.sectionHeaderHeight=CGFLOAT_MIN;
    //[DurationTable reloadData];
    [DurationTableMasterView addSubview:DurationTable];
    
    separator=[[UILabel alloc]initWithFrame:CGRectMake(0, 44+44+20, durationtablewidth, 0.5)];
    separator.layer.opacity=0.6;
    separator.backgroundColor=[UIColor lightGrayColor];
    [DurationTableMasterView addSubview:separator];
    
    DurationTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, durationtablewidth, 44)];
    DurationTableToolBar.clipsToBounds = YES;
    [DurationTableMasterView addSubview:DurationTableToolBar];
    [self createDurationTableToolBar];
    
    //language
    LanguageTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, languagetablewidth, self.view.frame.size.height)];
    [self.view addSubview:LanguageTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, LanguageTableMasterView.frame.size.width,44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [LanguageTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Preferred Language"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    LanguageTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+44+20, languagetablewidth, self.view.frame.size.height-44-44-20) style:UITableViewStyleGrouped];
    LanguageTable.dataSource=self;
    LanguageTable.delegate=self;
    LanguageTable.sectionHeaderHeight=CGFLOAT_MIN;
    //[LanguageTable reloadData];
    [LanguageTableMasterView addSubview:LanguageTable];
    
    separator=[[UILabel alloc]initWithFrame:CGRectMake(0, 44+44+20, languagetablewidth, 0.5)];
    separator.layer.opacity=0.6;
    separator.backgroundColor=[UIColor lightGrayColor];
    [LanguageTableMasterView addSubview:separator];
    
    LanguageTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, languagetablewidth, 44)];
    LanguageTableToolBar.clipsToBounds = YES;
    [LanguageTableMasterView addSubview:LanguageTableToolBar];
    [self createLanguageTableToolBar];
    
    //media
    MediaTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, mediatablewidth, self.view.frame.size.height)];
    [self.view addSubview:MediaTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, MediaTableMasterView.frame.size.width,44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [MediaTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Media"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    MediaTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+44+20, mediatablewidth, self.view.frame.size.height-44-44-20) style:UITableViewStyleGrouped];
    MediaTable.dataSource=self;
    MediaTable.delegate=self;
    MediaTable.sectionHeaderHeight=CGFLOAT_MIN;
    //[MediaTable reloadData];
    [MediaTableMasterView addSubview:MediaTable];
    
    separator=[[UILabel alloc]initWithFrame:CGRectMake(0, 44+44+20, mediatablewidth, 0.5)];
    separator.layer.opacity=0.6;
    separator.backgroundColor=[UIColor lightGrayColor];
    [MediaTableMasterView addSubview:separator];
    
    MediaTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, mediatablewidth, 44)];
    MediaTableToolBar.clipsToBounds = YES;
    [MediaTableMasterView addSubview:MediaTableToolBar];
    [self createMediaTableToolBar];
    
    //source
    SourceTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, sourcetablewidth, self.view.frame.size.height)];
    [self.view addSubview:SourceTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, SourceTableMasterView.frame.size.width,44)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [SourceTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Source"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    SourceTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+44+20, sourcetablewidth, self.view.frame.size.height-44-44-20) style:UITableViewStyleGrouped];
    SourceTable.dataSource=self;
    SourceTable.delegate=self;
    SourceTable.sectionHeaderHeight=CGFLOAT_MIN;
    //[SourceTable reloadData];
    [SourceTableMasterView addSubview:SourceTable];
    
    separator=[[UILabel alloc]initWithFrame:CGRectMake(0, 44+44+20, sourcetablewidth, 0.5)];
    separator.layer.opacity=0.6;
    separator.backgroundColor=[UIColor lightGrayColor];
    [SourceTableMasterView addSubview:separator];
    
    SourceTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, sourcetablewidth, 44)];
    SourceTableToolBar.clipsToBounds = YES;
    [SourceTableMasterView addSubview:SourceTableToolBar];
    [self createSourceTableToolBar];
    
    
    //school table
    SchoolTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, schooltablewidth, self.view.frame.size.height)];
    [self.view addSubview:SchoolTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, SchoolTableMasterView.frame.size.width,84+3)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [SchoolTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"School"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    schoolsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 40, SchoolTableMasterView.frame.size.width, 42)];
    schoolsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    schoolsearchbar.delegate=self;
    schoolsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:schoolsearchbar];
    
    SchoolTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84+20+3, schooltablewidth, self.view.frame.size.height-44-84-20-3) style:UITableViewStyleGrouped];
    SchoolTable.dataSource=self;
    SchoolTable.delegate=self;
    SchoolTable.sectionHeaderHeight=CGFLOAT_MIN;
    //[SubjectTable reloadData];
    [SchoolTableMasterView addSubview:SchoolTable];
    
    SchoolTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, subjecttablewidth, 44)];
    SchoolTableToolBar.clipsToBounds=YES;
    [SchoolTableMasterView addSubview:SchoolTableToolBar];
    [self createSchoolTableToolBar];
    
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
//    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [InstructorTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [InstructorTableMasterView addSubview:button];
}

-(void) createClassroomTableToolBar
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
//    [ClassroomTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [ClassroomTableMasterView addSubview:button];
}

-(void) createSubjectTableToolBar
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
//    [SubjectTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [SubjectTableMasterView addSubview:button];
}

-(void) createSchoolTableToolBar
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
//    [SchoolTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [SchoolTableMasterView addSubview:button];
}

-(void) createGradeTableToolBar
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
//    [GradeTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [GradeTableMasterView addSubview:button];
}

-(void) createLevelTableToolBar
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
//    [LevelTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [LevelTableMasterView addSubview:button];
}

-(void) createDurationTableToolBar
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
//    [DurationTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [DurationTableMasterView addSubview:button];
}

-(void) createLanguageTableToolBar
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
//    [LanguageTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [LanguageTableMasterView addSubview:button];
}

-(void) createMediaTableToolBar
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
//    [MediaTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [MediaTableMasterView addSubview:button];
}

-(void) createSourceTableToolBar
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
//    [SourceTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [SourceTableMasterView addSubview:button];
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    
    if ([windowname isEqualToString:@"showSubjectTable"]) {
        showSubjectTable=YES;
        showInstructorTable=NO;
        showClassroomTable=NO;
        showGradeTable=NO;
        showLevelTable=NO;
        showDurationTable=NO;
        showLanguageTable=NO;
        showMediaTable=NO;
        showSourceTable=NO;
        showSchoolTable=NO;
    }else if ([windowname isEqualToString:@"showInstructorTable"]) {
        showSubjectTable=NO;
        showInstructorTable=YES;
        showClassroomTable=NO;
        showGradeTable=NO;
        showLevelTable=NO;
        showDurationTable=NO;
        showLanguageTable=NO;
        showMediaTable=NO;
        showSourceTable=NO;
        showSchoolTable=NO;
    }else if ([windowname isEqualToString:@"showClassroomTable"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassroomTable=YES;
        showGradeTable=NO;
        showLevelTable=NO;
        showDurationTable=NO;
        showLanguageTable=NO;
        showMediaTable=NO;
        showSourceTable=NO;
        showSchoolTable=NO;
    }else if ([windowname isEqualToString:@"showGradeTable"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassroomTable=NO;
        showGradeTable=YES;
        showLevelTable=NO;
        showDurationTable=NO;
        showLanguageTable=NO;
        showMediaTable=NO;
        showSourceTable=NO;
        showSchoolTable=NO;
    }else if ([windowname isEqualToString:@"showLevelTable"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassroomTable=NO;
        showGradeTable=NO;
        showLevelTable=YES;
        showDurationTable=NO;
        showLanguageTable=NO;
        showMediaTable=NO;
        showSourceTable=NO;
        showSchoolTable=NO;
    }else if ([windowname isEqualToString:@"showDurationTable"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassroomTable=NO;
        showGradeTable=NO;
        showLevelTable=NO;
        showDurationTable=YES;
        showLanguageTable=NO;
        showMediaTable=NO;
        showSourceTable=NO;
        showSchoolTable=NO;
    }else if ([windowname isEqualToString:@"showLanguageTable"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassroomTable=NO;
        showGradeTable=NO;
        showLevelTable=NO;
        showDurationTable=NO;
        showLanguageTable=YES;
        showMediaTable=NO;
        showSourceTable=NO;
        showSchoolTable=NO;
    }else if ([windowname isEqualToString:@"showMediaTable"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassroomTable=NO;
        showGradeTable=NO;
        showLevelTable=NO;
        showDurationTable=NO;
        showLanguageTable=NO;
        showMediaTable=YES;
        showSourceTable=NO;
        showSchoolTable=NO;
    }else if ([windowname isEqualToString:@"showSourceTable"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassroomTable=NO;
        showGradeTable=NO;
        showLevelTable=NO;
        showDurationTable=NO;
        showLanguageTable=NO;
        showMediaTable=NO;
        showSourceTable=YES;
        showSchoolTable=NO;
    }else if ([windowname isEqualToString:@"showSchoolTable"]) {
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassroomTable=NO;
        showGradeTable=NO;
        showLevelTable=NO;
        showDurationTable=NO;
        showLanguageTable=NO;
        showMediaTable=NO;
        showSourceTable=NO;
        showSchoolTable=YES;
    }else{
        showSubjectTable=NO;
        showInstructorTable=NO;
        showClassroomTable=NO;
        showGradeTable=NO;
        showLevelTable=NO;
        showDurationTable=NO;
        showLanguageTable=NO;
        showMediaTable=NO;
        showSourceTable=NO;
        showSchoolTable=NO;
    }
}

-(void) closeallpicker
{
    if (showDatePicker) {
        showDatePicker=NO;
        [DTPopoverTable reloadData];
    }
}



-(void) closesidewindow
{
    [self showsidewindowwithwindow:@"none"];
    [DTPopoverTable deselectRowAtIndexPath:[DTPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) attendanceringreleasedwithtouchpoint:(CGPoint)touchpoint
{
    //check if inside ring
    if ([MyClass returntouchpointwithinattendanceringwithtouchpoint:touchpoint size:@"small"]) {
        NSIndexPath *selectedIndexPath = [DTPopoverTable indexPathForSelectedRow];
        [self updateattendancewithindexpath:selectedIndexPath value:((AttendanceButtonObject *)[attendancebuttonarray objectAtIndex:lasttouchedsector]).buttonname];
    }
}

-(void)updateattendancewithindexpath:(NSIndexPath *)indexpath value:(NSString *)value
{
    if (![value isEqualToString:workingATObject.attendance]) {
        workingATObject.attendance=value;
        [DTPopoverTable reloadData];
    }
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (dismisspopoverduetoconnectionerror) {
        [self.delegate dismissDTAddEditpopoverduetoconnectionerror];
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadcalendar];
    });
    
    
}


-(void) loadcalendar
{
    [MyClass getLatestDataSetv2withParameters:@"calendar" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    //[MyClass LoadSchoolCalendarArray];
    //datePickerViewMenu=[[NSMutableArray alloc] initWithArray:globalvariables.centerandreserveddayarray];

    hourPickerViewMenu=[[NSMutableArray alloc]init];
    minutePickerViewMenu=[[NSMutableArray alloc]init];

    [MyClass loadHourPickerViewMenu:hourPickerViewMenu];
    
    for (int i=0; i<60; i+=[globalvariables.centerrecord.classtimeinterval intValue]) {
        [minutePickerViewMenu addObject:[NSString stringWithFormat:@"%02i",i]];
    }
}

- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here
    keyboardshow=TRUE;
    [self adjusttablesize];
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

-(void) createAddViewBarButton{
    enrollButton.hidden=YES;
    editButton.hidden=YES;
    doneButton.hidden=NO;
    addanotherButton.hidden=YES;
    addanotherdoneButton.hidden=YES;
    editdoneButton.hidden=YES;
    
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(adddoneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,doneButton,nil];
//    [DTAddEditToolbar setItems:buttons animated:NO];
    
}

-(void) createViewViewBarButton{
    enrollButton.hidden=NO;
    editButton.hidden=NO;
    doneButton.hidden=YES;
    addanotherdoneButton.hidden=YES;
    editdoneButton.hidden=YES;
    
//    UIBarButtonItem *enrollButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Enroll"] style:UIBarButtonItemStylePlain target:self action:@selector(enrollButtonPressed:)];
//    UIBarButtonItem *addanotherButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Add Another"] style:UIBarButtonItemStylePlain target:self action:@selector(addanotherButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//    NSArray *buttons;
    
    editButton.enabled=![MyClass classLocked:workingATObject.locked];
    
    if ([PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
        addanotherButton.hidden=NO;
    }
//    [DTAddEditToolbar setItems:buttons animated:NO];
}

-(void) createEditViewBarButton{
    enrollButton.hidden=YES;
    editButton.hidden=YES;
    doneButton.hidden=YES;
    addanotherButton.hidden=YES;
    addanotherdoneButton.hidden=YES;
    editdoneButton.hidden=NO;
    
    
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(editdoneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,doneButton,nil];
//    [DTAddEditToolbar setItems:buttons animated:NO];
    
}

-(void) createAddAnotherViewBarButton{
    enrollButton.hidden=YES;
    editButton.hidden=YES;
    doneButton.hidden=YES;
    addanotherButton.hidden=YES;
    addanotherdoneButton.hidden=NO;
    editdoneButton.hidden=YES;
    
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(addanotherdoneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,doneButton,nil];
//    [DTAddEditToolbar setItems:buttons animated:NO];
    
}

-(IBAction)adddoneButtonPressed:(id)sender
{
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        BOOL skipchecking=([PopoverMode isEqualToString:@"PopoverDTFromStudentView"] || [PopoverMode isEqualToString:@"PopoverDTFromLeadView"])?YES:NO;
        
        if ([workingATObject.firstname isEqualToString:@""] && !skipchecking) {
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Appointment"] message:[MyClass returntitlewithtitle:@"Please input student's first name"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
        }else if ([workingATObject.DTdate isEqualToString:@""]) {
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Appointment"] message:[MyClass returntitlewithtitle:@"Please select class date/time"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
        }else{
            classvalidatemessage=[MyClass validateClassWithFreeScheduleArray:[self returnfreescheduleclassarray] studentkey:CallingKey enrollmentkey:nil];
            classvalidatestatus=[[ClassValidateStatus alloc]initClassValidateStatuswithoverenrollmentstatus:@"" sameinstructormulticlassstatus:@"" alreadyenrolledstatus:@"" sameclassroommulticlassstatus:@"" hasextendedchildclassstatus:@"" classroomexceedcapacitystatus:@"" makeupquotaexceedstatus:@""];
            [self checkvalidatemessage];
        }
    });
}

-(NSMutableArray *) returnfreescheduleclassarray
{

    FreeScheduleClass *freescheduleclass_object=[[FreeScheduleClass alloc]init];
    
    freescheduleclass_object.classkey=[DTTableMode isEqualToString:@"Edit"]?ViewATObject.DTkey:@"";
    freescheduleclass_object.subject=workingATObject.subject;
    freescheduleclass_object.attendance=@"";
    
    
    
    freescheduleclass_object.classdate=workingATObject.DTdate;
    freescheduleclass_object.classtime=workingATObject.DTtime;
    freescheduleclass_object.instructor=workingATObject.instructor;
    freescheduleclass_object.classroom=workingATObject.classroom;
    freescheduleclass_object.attendance=workingATObject.attendance;
    freescheduleclass_object.classtype=workingATObject.classtype;
    freescheduleclass_object.leavenaturelistkey=@"0";
    
    
    if (![workingATObject.attendance isEqualToString:@"Absent"]) {
        if (![workingATObject.DTdate isEqualToString:@""]) {
            freescheduleclass_object.action=DTTableMode;
        }
    }
    
    
    return [[NSMutableArray alloc]initWithObjects:freescheduleclass_object, nil];
}

-(void) checkvalidatemessage
{
    [MyClass checkValidateMessageWithClassValidateMessage:classvalidatemessage ClassValidateStatus:classvalidatestatus View:self];

}

-(void) validationPassed:(BOOL)pass
{
    if(pass){
        if ([DTTableMode isEqualToString:@"Add"]) {
            [self addDT];
        }else if ([DTTableMode isEqualToString:@"AddAnother"]){
            [self addanotherDT];
        }else{
            [self updateDT];
        }
    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }

}

-(void) addDT
{
    if ([tmpLevel isEqualToString:@""] || !tmpLevel) {
        workingATObject.levelmain=@"";
        workingATObject.levelctm=@"";
        
    }else if ([tmpLevel isEqualToString:@"TBD"] || [tmpLevel isEqualToString:@"DT"]) {
        workingATObject.levelmain=tmpLevel;
        workingATObject.levelctm=tmpLevel;
    }else{
        if ([MyClass isEyeLevelMathWithSubject:workingATObject.subject]) {
                NSRange range=[tmpLevel rangeOfString:@"/"];
                if (range.location==NSNotFound) {
                    workingATObject.levelmain=[tmpLevel substringFromIndex:3];
                    workingATObject.levelctm=@"";
                }else{
                    workingATObject.levelmain=[tmpLevel substringWithRange:NSMakeRange(3, range.location-3)];
                    workingATObject.levelctm=[tmpLevel substringFromIndex:range.location+4];
                }
        }else{
            workingATObject.levelmain=[workingATObject.classtype isEqualToString:@"Assessment"]?@"":tmpLevel;
            workingATObject.levelctm=@"";
        }
    }
    
    if ([workingATObject.instructor isEqualToString:@""]) {
        workingATObject.instructor=@"TBD";
    }
    
    if ([workingATObject.classroom isEqualToString:@""]) {
        workingATObject.classroom=@"TBD";
    }

    //combine arrays
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:ViewATObject.DTkey forKey:@"dtkey"];
    [dictionary setValue:[MyClass convertDateFormatWithDate:workingATObject.DTdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"] forKey:@"dtdate"];
    [dictionary setValue:workingATObject.DTtime forKey:@"dttime"];
    [dictionary setValue:workingATObject.subject forKey:@"subject"];
    [dictionary setValue:workingATObject.levelmain forKey:@"levelmain"];
    [dictionary setValue:workingATObject.levelctm forKey:@"levelctm"];
    [dictionary setValue:workingATObject.instructor forKey:@"instructor"];
    [dictionary setValue:workingATObject.classroom forKey:@"classroom"];
    [dictionary setValue:workingATObject.remarks forKey:@"remarks"];
    [dictionary setValue:@"Open" forKey:@"status"];
    [dictionary setValue:workingATObject.classduration forKey:@"classduration"];
    [dictionary setValue:workingATObject.classtype forKey:@"classtype"];
    [dictionary setValue:workingATObject.attendance forKey:@"attendance"];
    
    
    if ([PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
        [dictionary setValue:@"insertdtandlead" forKey:@"postaction"];
        [dictionary setValue:@"lead" forKey:@"type"];
        
        [dictionary setValue:workingATObject.gender forKey:@"gender"];
        [dictionary setValue:workingATObject.firstname forKey:@"firstname"];
        [dictionary setValue:workingATObject.lastname forKey:@"lastname"];
        [dictionary setValue:workingATObject.othername forKey:@"othername"];
        [dictionary setValue:workingATObject.school forKey:@"school"];
        [dictionary setValue:workingATObject.grade forKey:@"grade"];
        [dictionary setValue:workingATObject.parentname forKey:@"parentname"];
        
        if (![[MyClass returnLocalNumberWithContact:workingATObject.parentcontact ISOCode:workingATObject.iso_code] isEqualToString:@""]) {
            [dictionary setValue:workingATObject.parentcontact forKey:@"parentcontact"];
            [dictionary setValue:workingATObject.iso_code forKey:@"iso_code"];
        }else{
            [dictionary setValue:@"" forKey:@"parentcontact"];
            [dictionary setValue:@"" forKey:@"iso_code"];
        }
        
        
        [dictionary setValue:workingATObject.parentemail forKey:@"parentemail"];
        [dictionary setValue:workingATObject.preferredlanguage forKey:@"preferredlanguage"];
        [dictionary setValue:workingATObject.media forKey:@"media"];
        [dictionary setValue:workingATObject.source forKey:@"source"];

    }else{
        [dictionary setValue:@"insertdt" forKey:@"postaction"];
        [dictionary setValue:CallingKey forKey:@"typekey"];
        [dictionary setValue:CallingSource forKey:@"type"];

    }
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];

    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if(result){
        [self.delegate dismissDTAddEditpopoverwithrefresh:YES];
    }
}

-(IBAction)enrollButtonPressed:(id)sender
{
    [self.delegate enrollATLeadStudent:ViewATObject];
}

-(IBAction) editButtonPressed:(id)sender{
    
    DTTableMode=@"Edit";
    [self createEditViewBarButton];
    [self InitializeField];
    [DTPopoverTable reloadData];

    [self adjusttablesize];
}

-(IBAction) addanotherButtonPressed:(id)sender{
    
    DTTableMode=@"AddAnother";
    [self createAddAnotherViewBarButton];
    [self InitializeField];
    [DTPopoverTable reloadData];
    
    [self adjusttablesize];
}


-(IBAction)editdoneButtonPressed:(id)sender
{
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }

    if ([workingATObject.firstname isEqualToString:@""]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Appointment"] message:[MyClass returntitlewithtitle:@"Please input student's first name"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else{
        classvalidatemessage=[MyClass validateClassWithFreeScheduleArray:[self returnfreescheduleclassarray] studentkey:[ViewATObject.type isEqualToString:@"student"]?ViewATObject.studentkey:ViewATObject.leadkey enrollmentkey:nil];
        classvalidatestatus=[[ClassValidateStatus alloc]initClassValidateStatuswithoverenrollmentstatus:@"" sameinstructormulticlassstatus:@"" alreadyenrolledstatus:@"" sameclassroommulticlassstatus:@"" hasextendedchildclassstatus:@"" classroomexceedcapacitystatus:@"" makeupquotaexceedstatus:@""];
        [self checkvalidatemessage];
    }
}

-(void) updateDT
{

    if ([tmpLevel isEqualToString:@""] || !tmpLevel) {
        workingATObject.levelmain=@"";
        workingATObject.levelctm=@"";
        
    }else if ([tmpLevel isEqualToString:@"TBD"] || [tmpLevel isEqualToString:@"DT"]) {
        workingATObject.levelmain=[workingATObject.classtype isEqualToString:@"Assessment"]?@"":tmpLevel;
        workingATObject.levelctm=[workingATObject.classtype isEqualToString:@"Assessment"]?@"":tmpLevel;
    }else{
        
        if ([MyClass isEyeLevelMathWithSubject:workingATObject.subject]) {
                NSRange range=[tmpLevel rangeOfString:@"/"];
                if (range.location==NSNotFound) {
                    workingATObject.levelmain=[tmpLevel substringFromIndex:3];
                    workingATObject.levelctm=@"";
                }else{
                    workingATObject.levelmain=[tmpLevel substringWithRange:NSMakeRange(3, range.location-3)];
                    workingATObject.levelctm=[tmpLevel substringFromIndex:range.location+4];
                }
        }else{
            workingATObject.levelmain=tmpLevel;
            workingATObject.levelctm=@"";
        }
    }
    
    if ([workingATObject.instructor isEqualToString:@""]) {
        workingATObject.instructor=@"TBD";
    }
    
    if ([workingATObject.classroom isEqualToString:@""]) {
        workingATObject.classroom=@"TBD";
    }

    //combine arrays
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    [dictionary setValue:globalvariables.centerrecord.entitykey forKey:@"entitykey"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:ViewATObject.DTkey forKey:@"dtkey"];
    [dictionary setValue:[MyClass convertDateFormatWithDate:workingATObject.DTdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"] forKey:@"dtdate"];
    [dictionary setValue:workingATObject.DTtime forKey:@"dttime"];
    [dictionary setValue:workingATObject.subject forKey:@"subject"];
    [dictionary setValue:workingATObject.levelmain forKey:@"levelmain"];
    [dictionary setValue:workingATObject.levelctm forKey:@"levelctm"];
    [dictionary setValue:workingATObject.instructor forKey:@"instructor"];
    [dictionary setValue:workingATObject.classroom forKey:@"classroom"];
    [dictionary setValue:workingATObject.remarks forKey:@"remarks"];
    [dictionary setValue:workingATObject.classduration forKey:@"classduration"];
    [dictionary setValue:workingATObject.classtype forKey:@"classtype"];
    [dictionary setValue:workingATObject.attendance forKey:@"attendance"];
    
    if ([PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
        [dictionary setValue:@"updatedtandleadorstudent" forKey:@"postaction"];
        
        [dictionary setValue:workingATObject.gender forKey:@"gender"];
        [dictionary setValue:workingATObject.firstname forKey:@"firstname"];
        [dictionary setValue:workingATObject.lastname forKey:@"lastname"];
        [dictionary setValue:workingATObject.othername forKey:@"othername"];
        [dictionary setValue:workingATObject.school forKey:@"school"];
        [dictionary setValue:workingATObject.grade forKey:@"grade"];
        [dictionary setValue:workingATObject.parentname forKey:@"parentname"];
        if ([[MyClass returnLocalNumberWithContact:workingATObject.parentcontact ISOCode:workingATObject.iso_code] isEqualToString:@""]) {
            [dictionary setValue:@"" forKey:@"parentcontact"];
            [dictionary setValue:@"" forKey:@"iso_code"];
        }else{
            [dictionary setValue:workingATObject.parentcontact forKey:@"parentcontact"];
            [dictionary setValue:workingATObject.iso_code forKey:@"iso_code"];
        }
        [dictionary setValue:workingATObject.parentemail forKey:@"parentemail"];
        [dictionary setValue:workingATObject.preferredlanguage forKey:@"preferredlanguage"];
        
        [dictionary setValue:[ViewATObject.type isEqualToString:@"student"]?ViewATObject.studentkey:ViewATObject.leadkey forKey:@"typekey"];
        [dictionary setValue:ViewATObject.type forKey:@"type"];
        [dictionary setValue:globalvariables.centerrecord.entitykey forKey:@"entitykey"];
        [dictionary setValue:workingATObject.media forKey:@"media"];
        [dictionary setValue:workingATObject.source forKey:@"source"];
        
        [dictionary setValue:globalvariables.username forKey:@"updatedby"];

    }else{
        [dictionary setValue:@"updatedt" forKey:@"postaction"];
    }
    
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
            result=TRUE;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if(result){
        if ([PopoverMode isEqualToString:@"PopoverDTFromTimeTable"]) {
            [[classtimetableviewcontroller.myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            [classtimetableviewcontroller closesidewindow];
            
            df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];[df setDateFormat:@"dd MMM yyyy"];
            NSDate *date=[df dateFromString:classtimetableviewcontroller.globalselecteddate];
            [df setDateFormat:@"dd-MMM-yyyy"];
            
            classtimetableviewcontroller.ClassScheduleTableShown=FALSE;
            [classtimetableviewcontroller generateTimeTablewithViewOption:classtimetableviewcontroller.TimeTableMode pastMonday:[df stringFromDate:date] classtype:classtimetableviewcontroller.classtypeselected redrawscoller:NO];
        }else if([PopoverMode isEqualToString:@"PopoverDTFromClassSchedule"]){
            [self.delegate dismissDTAddEditpopoverwithrefresh:YES];
            
        }else{
            
            [self.delegate dismissDTAddEditpopoverwithrefresh:YES];
        }
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
}
-(IBAction)addanotherdoneButtonPressed:(id)sender
{
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }

    if ([workingATObject.firstname isEqualToString:@""]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Appointment"] message:[MyClass returntitlewithtitle:@"Please input student's first name"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else{
        classvalidatemessage=[MyClass validateClassWithFreeScheduleArray:[self returnfreescheduleclassarray] studentkey:[ViewATObject.type isEqualToString:@"student"]?ViewATObject.studentkey:ViewATObject.leadkey enrollmentkey:nil];
        classvalidatestatus=[[ClassValidateStatus alloc]initClassValidateStatuswithoverenrollmentstatus:@"" sameinstructormulticlassstatus:@"" alreadyenrolledstatus:@"" sameclassroommulticlassstatus:@"" hasextendedchildclassstatus:@"" classroomexceedcapacitystatus:@"" makeupquotaexceedstatus:@""];
        [self checkvalidatemessage];
    }
}

-(void) addanotherDT
{
    if ([tmpLevel isEqualToString:@""] || !tmpLevel) {
        workingATObject.levelmain=@"";
        workingATObject.levelctm=@"";
    }else if ([tmpLevel isEqualToString:@"TBD"] || [tmpLevel isEqualToString:@"DT"]) {
        workingATObject.levelmain=tmpLevel;
        workingATObject.levelctm=tmpLevel;
    }else{
        if ([MyClass isEyeLevelMathWithSubject:workingATObject.subject]) {
                NSRange range=[tmpLevel rangeOfString:@"/"];
                if (range.location==NSNotFound) {
                    workingATObject.levelmain=[tmpLevel substringFromIndex:3];
                    workingATObject.levelctm=@"";
                }else{
                    workingATObject.levelmain=[tmpLevel substringWithRange:NSMakeRange(3, range.location-3)];
                    workingATObject.levelctm=[tmpLevel substringFromIndex:range.location+4];
                }
        }else{
            workingATObject.levelmain=[workingATObject.classtype isEqualToString:@"Assessment"]?@"":tmpLevel;
            workingATObject.levelctm=@"";
        }
    }
    
    if ([workingATObject.instructor isEqualToString:@""]) {
        workingATObject.instructor=@"TBD";
    }
    
    if ([workingATObject.classroom isEqualToString:@""]) {
        workingATObject.classroom=@"TBD";
    }

    //combine arrays
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:@"updateleadorstudentandadddt" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    //[dictionary setValue:ViewATObject.DTkey forKey:@"dtkey"];
    [dictionary setValue:[MyClass convertDateFormatWithDate:workingATObject.DTdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"] forKey:@"dtdate"];
    [dictionary setValue:workingATObject.DTtime forKey:@"dttime"];
    [dictionary setValue:workingATObject.subject forKey:@"subject"];
    [dictionary setValue:workingATObject.levelmain forKey:@"levelmain"];
    [dictionary setValue:workingATObject.levelctm forKey:@"levelctm"];
    [dictionary setValue:workingATObject.instructor forKey:@"instructor"];
    [dictionary setValue:workingATObject.classroom forKey:@"classroom"];
    [dictionary setValue:workingATObject.remarks forKey:@"remarks"];
    [dictionary setValue:@"Open" forKey:@"status"];
    [dictionary setValue:workingATObject.classduration forKey:@"classduration"];
    [dictionary setValue:scClassType.selectedSegmentIndex==0?@"Assessment":@"Trial" forKey:@"classtype"];
    
    
    [dictionary setValue:workingATObject.gender forKey:@"gender"];
    [dictionary setValue:workingATObject.firstname forKey:@"firstname"];
    [dictionary setValue:workingATObject.lastname forKey:@"lastname"];
    [dictionary setValue:workingATObject.othername forKey:@"othername"];
    [dictionary setValue:workingATObject.school forKey:@"school"];
    [dictionary setValue:workingATObject.grade forKey:@"grade"];
    [dictionary setValue:workingATObject.parentname forKey:@"parentname"];
    if ([[MyClass returnLocalNumberWithContact:workingATObject.parentcontact ISOCode:workingATObject.iso_code] isEqualToString:@""]) {
        [dictionary setValue:@"" forKey:@"parentcontact"];
        [dictionary setValue:@"" forKey:@"iso_code"];
    }else{
        [dictionary setValue:workingATObject.parentcontact forKey:@"parentcontact"];
        [dictionary setValue:workingATObject.iso_code forKey:@"iso_code"];
    }
    
    [dictionary setValue:workingATObject.parentemail forKey:@"parentemail"];
    [dictionary setValue:workingATObject.preferredlanguage forKey:@"preferredlanguage"];
    
    [dictionary setValue:[ViewATObject.type isEqualToString:@"student"]?ViewATObject.studentkey:ViewATObject.leadkey forKey:@"typekey"];
    [dictionary setValue:ViewATObject.type forKey:@"type"];
    [dictionary setValue:globalvariables.centerrecord.entitykey forKey:@"entitykey"];
    [dictionary setValue:workingATObject.media forKey:@"media"];
    [dictionary setValue:workingATObject.source forKey:@"source"];
    [dictionary setValue:workingATObject.attendance forKey:@"attendance"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    

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
            result=TRUE;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if(result){
        if ([PopoverMode isEqualToString:@"PopoverDTFromTimeTable"]) {
            //[classtimetableviewcontroller.myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            [classtimetableviewcontroller closesidewindow];
            
            df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];[df setDateFormat:@"dd MMM yyyy"];
            NSDate *date=[df dateFromString:classtimetableviewcontroller.globalselecteddate];
            [df setDateFormat:@"dd-MMM-yyyy"];
            
            classtimetableviewcontroller.ClassScheduleTableShown=FALSE;
            [classtimetableviewcontroller generateTimeTablewithViewOption:classtimetableviewcontroller.TimeTableMode pastMonday:[df stringFromDate:date] classtype:classtimetableviewcontroller.classtypeselected redrawscoller:NO];
        }else if([PopoverMode isEqualToString:@"PopoverDTFromClassSchedule"]){
            [[classscheduleviewcontroller.myDTPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
            [classscheduleviewcontroller retrieveClassScheduleWithclassdate:classscheduleviewcontroller.selecteddate];
            //[classscheduleviewcontroller.ClassScheduleTable reloadData];
            
        }else{
            
            [self.delegate dismissDTAddEditpopoverwithrefresh:YES];
        }
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
}



-(void) deleteDTRecord:(id)sender{
    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Class"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the class?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self confirmdeleteDTRecord];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [erroralert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [erroralert addAction:OKAction];
    [erroralert addAction:CancelAction];
    [self presentViewController:erroralert animated:YES completion:nil];
    
}
-(void) confirmdeleteDTRecord
{
    //delete DT record
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletedt&dtkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,ViewATObject.DTkey];

    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];

    if (result) {
        if ([PopoverMode isEqualToString:@"PopoverDTFromTimeTable"]) {
            [[classtimetableviewcontroller.myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            [classtimetableviewcontroller closesidewindow];
            
            df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];[df setDateFormat:@"dd MMM yyyy"];
            NSDate *date=[df dateFromString:classtimetableviewcontroller.globalselecteddate];
            [df setDateFormat:@"dd-MMM-yyyy"];
            
            [classtimetableviewcontroller generateTimeTablewithViewOption:classtimetableviewcontroller.TimeTableMode pastMonday:[df stringFromDate:date] classtype:classtimetableviewcontroller.classtypeselected redrawscoller:NO];
        }else if([PopoverMode isEqualToString:@"PopoverDTFromClassSchedule"]){
            [[classscheduleviewcontroller.myDTPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
            [classscheduleviewcontroller retrieveClassScheduleWithclassdate:classscheduleviewcontroller.selecteddate];
            //[classscheduleviewcontroller.ClassScheduleTable reloadData];
            
        }else{
            [self.delegate dismissDTAddEditpopoverwithrefresh:YES];
        }
    }
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    

}


-(BOOL) retrieveDTRecordWithDTkey:(NSString *)dtkey
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectassessmenttrialclass&dtkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,dtkey];

    
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];

    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            NSString * sdtkey=[[JSONArray objectAtIndex:0] objectForKey:@"dtkey"];
            NSString * stype=[[JSONArray objectAtIndex:0] objectForKey:@"type"];
            NSString * sleadkey=[[JSONArray objectAtIndex:0] objectForKey:@"leadkey"];
            NSString * sstudentkey=[[JSONArray objectAtIndex:0] objectForKey:@"studentkey"];
            NSString * sfirstname=[[JSONArray objectAtIndex:0] objectForKey:@"firstname"];
            NSString * slastname=[[JSONArray objectAtIndex:0] objectForKey:@"lastname"];
            NSString * sothername=[[JSONArray objectAtIndex:0] objectForKey:@"othername"];
            
            NSString * sstudenfullname;
            if ([stype isEqualToString:@"student"]) {
                sstudenfullname=[MyClass returnStudentnameWithStudentkey:sstudentkey option:@"full"];
            }else{
                sstudenfullname=[MyClass returnLeadnameWithLeadkey:sleadkey option:@"full"];
            }
            
            NSString * sgrade=[[JSONArray objectAtIndex:0] objectForKey:@"grade"];
            NSString * sgender=[[JSONArray objectAtIndex:0] objectForKey:@"gender"];
            
            NSString *sdateofbirth;
            if (![[[JSONArray objectAtIndex:0] objectForKey:@"dateofbirth"] isEqualToString:@""]) {
                [df setDateFormat:@"yyyy-MM-dd"];
                NSDate *date=[df dateFromString:[[JSONArray objectAtIndex:0] objectForKey:@"dateofbirth"]];
                [df setDateFormat:@"dd-MMM-yyyy"];
                sdateofbirth = [df stringFromDate:date];
            }else{
                sdateofbirth=@"";
            }
            
            NSString * sage=[[JSONArray objectAtIndex:0] objectForKey:@"age"];
            NSString * sschool=[[JSONArray objectAtIndex:0] objectForKey:@"school"];
            NSString * sprofileremarks=[[JSONArray objectAtIndex:0] objectForKey:@"profileremarks"];
            NSString * sparentname=[[JSONArray objectAtIndex:0] objectForKey:@"parentname"];
            NSString * sparentcontact=[[JSONArray objectAtIndex:0] objectForKey:@"parentcontact"];
            NSString * sparentemail=[[JSONArray objectAtIndex:0] objectForKey:@"parentemail"];
            NSString * sparentaddress=[[JSONArray objectAtIndex:0] objectForKey:@"parentaddress"];
            NSString * spreferredlanguage=[[JSONArray objectAtIndex:0] objectForKey:@"preferredlanguage"];
            NSString * simage=[[JSONArray objectAtIndex:0] objectForKey:@"image"];
            NSString * sclasstype=[[JSONArray objectAtIndex:0] objectForKey:@"classtype"];
            
            
            NSString * sdtstatus=[[JSONArray objectAtIndex:0] objectForKey:@"dtstatus"];
            
            NSString *sdtdate=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:0] objectForKey:@"dtdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy"];
            
            NSString * sdttime=[[JSONArray objectAtIndex:0] objectForKey:@"dttime"];
            NSString * sclassduration=[[JSONArray objectAtIndex:0] objectForKey:@"classduration"];
            NSString * ssubject=[[JSONArray objectAtIndex:0] objectForKey:@"subject"];
            NSString * slevelmain=[[JSONArray objectAtIndex:0] objectForKey:@"levelmain"];
            NSString * slevelctm=[[JSONArray objectAtIndex:0] objectForKey:@"levelctm"];
            NSString * sinstructor=[[JSONArray objectAtIndex:0] objectForKey:@"instructor"];
            NSString * sremarks=[[JSONArray objectAtIndex:0] objectForKey:@"remarks"];
            NSString * smedia=[[JSONArray objectAtIndex:0] objectForKey:@"media"];
            NSString * ssource=[[JSONArray objectAtIndex:0] objectForKey:@"source"];
            NSString * sclassroom=[[JSONArray objectAtIndex:0] objectForKey:@"classroom"];
            NSString * sattendance=[[JSONArray objectAtIndex:0] objectForKey:@"attendance"];
            NSString * sisocode=[[JSONArray objectAtIndex:0] objectForKey:@"iso_code"];
            BOOL clocked=[[[JSONArray objectAtIndex:0] objectForKey:@"locked"] isEqualToString:@"Yes"];
            
            ViewATObject=[[AssessmentTrialRecord alloc]initAssessmentTrialRecordWithDTkey:sdtkey type:stype leadkey:sleadkey studentkey:sstudentkey firstname:sfirstname lastname:slastname othername:sothername grade:sgrade gender:sgender dateofbirth:sdateofbirth age:sage school:sschool parentname:sparentname parentcontact:sparentcontact parentemail:sparentemail parentaddress:sparentaddress preferredlanguage:spreferredlanguage profileremarks:sprofileremarks image:simage classtype:sclasstype dtstatus:sdtstatus dtdate:sdtdate dttime:sdttime classduration:sclassduration subject:ssubject levelmain:slevelmain levelctm:slevelctm instructor:sinstructor remarks:sremarks media:smedia source:ssource classroom:sclassroom attendance:sattendance studentfullname:sstudenfullname instructorfullname:nil subjectfullname:nil iso_code:sisocode locked:clocked];
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    
    if (!error) {
        result=TRUE;
        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
        JSONArray = jsonreturned[@"content"];
        
        NSString * sdtkey=[[JSONArray objectAtIndex:0] objectForKey:@"dtkey"];
        NSString * stype=[[JSONArray objectAtIndex:0] objectForKey:@"type"];
        NSString * sleadkey=[[JSONArray objectAtIndex:0] objectForKey:@"leadkey"];
        NSString * sstudentkey=[[JSONArray objectAtIndex:0] objectForKey:@"studentkey"];
        NSString * sfirstname=[[JSONArray objectAtIndex:0] objectForKey:@"firstname"];
        NSString * slastname=[[JSONArray objectAtIndex:0] objectForKey:@"lastname"];
        NSString * sothername=[[JSONArray objectAtIndex:0] objectForKey:@"othername"];
        
        NSString * sstudenfullname;
        if ([stype isEqualToString:@"student"]) {
            sstudenfullname=[MyClass returnStudentnameWithStudentkey:sstudentkey option:@"full"];
        }else{
            sstudenfullname=[MyClass returnLeadnameWithLeadkey:sleadkey option:@"full"];
        }
        
        NSString * sgrade=[[JSONArray objectAtIndex:0] objectForKey:@"grade"];
        NSString * sgender=[[JSONArray objectAtIndex:0] objectForKey:@"gender"];
        
        NSString *sdateofbirth;
        if (![[[JSONArray objectAtIndex:0] objectForKey:@"dateofbirth"] isEqualToString:@""]) {
            [df setDateFormat:@"yyyy-MM-dd"];
            NSDate *date=[df dateFromString:[[JSONArray objectAtIndex:0] objectForKey:@"dateofbirth"]];
            [df setDateFormat:@"dd-MMM-yyyy"];
            sdateofbirth = [df stringFromDate:date];
        }else{
            sdateofbirth=@"";
        }
        
        NSString * sage=[[JSONArray objectAtIndex:0] objectForKey:@"age"];
        NSString * sschool=[[JSONArray objectAtIndex:0] objectForKey:@"school"];
        NSString * sprofileremarks=[[JSONArray objectAtIndex:0] objectForKey:@"profileremarks"];
        NSString * sparentname=[[JSONArray objectAtIndex:0] objectForKey:@"parentname"];
        NSString * sparentcontact=[[JSONArray objectAtIndex:0] objectForKey:@"parentcontact"];
        NSString * sparentemail=[[JSONArray objectAtIndex:0] objectForKey:@"parentemail"];
        NSString * sparentaddress=[[JSONArray objectAtIndex:0] objectForKey:@"parentaddress"];
        NSString * spreferredlanguage=[[JSONArray objectAtIndex:0] objectForKey:@"preferredlanguage"];
        NSString * simage=[[JSONArray objectAtIndex:0] objectForKey:@"image"];
        NSString * sclasstype=[[JSONArray objectAtIndex:0] objectForKey:@"classtype"];
        
        
        NSString * sdtstatus=[[JSONArray objectAtIndex:0] objectForKey:@"dtstatus"];
        
        NSString *sdtdate=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:0] objectForKey:@"dtdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy"];
        
        NSString * sdttime=[[JSONArray objectAtIndex:0] objectForKey:@"dttime"];
        NSString * sclassduration=[[JSONArray objectAtIndex:0] objectForKey:@"classduration"];
        NSString * ssubject=[[JSONArray objectAtIndex:0] objectForKey:@"subject"];
        NSString * slevelmain=[[JSONArray objectAtIndex:0] objectForKey:@"levelmain"];
        NSString * slevelctm=[[JSONArray objectAtIndex:0] objectForKey:@"levelctm"];
        NSString * sinstructor=[[JSONArray objectAtIndex:0] objectForKey:@"instructor"];
        NSString * sremarks=[[JSONArray objectAtIndex:0] objectForKey:@"remarks"];
        NSString * smedia=[[JSONArray objectAtIndex:0] objectForKey:@"media"];
        NSString * ssource=[[JSONArray objectAtIndex:0] objectForKey:@"source"];
        NSString * sclassroom=[[JSONArray objectAtIndex:0] objectForKey:@"classroom"];
        NSString * sattendance=[[JSONArray objectAtIndex:0] objectForKey:@"attendance"];
        NSString * sisocode=[[JSONArray objectAtIndex:0] objectForKey:@"iso_code"];

        ViewATObject=[[AssessmentTrialRecord alloc]initAssessmentTrialRecordWithDTkey:sdtkey type:stype leadkey:sleadkey studentkey:sstudentkey firstname:sfirstname lastname:slastname othername:sothername grade:sgrade gender:sgender dateofbirth:sdateofbirth age:sage school:sschool parentname:sparentname parentcontact:sparentcontact parentemail:sparentemail parentaddress:sparentaddress preferredlanguage:spreferredlanguage profileremarks:sprofileremarks image:simage classtype:sclasstype dtstatus:sdtstatus dtdate:sdtdate dttime:sdttime classduration:sclassduration subject:ssubject levelmain:slevelmain levelctm:slevelctm instructor:sinstructor remarks:sremarks media:smedia source:ssource classroom:sclassroom attendance:sattendance studentfullname:sstudenfullname instructorfullname:nil subjectfullname:nil iso_code:sisocode];

        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
    if (!result) {
        [MyClass showconnectionlostdialogbox];
    }*/
    return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==DTPopoverTable) {
        // Return the number of sections.
        if ([DTTableMode isEqualToString:@"View"]) {
            return 5;
        }else if ([DTTableMode isEqualToString:@"Edit"]){
            return 6;
        }else{ //add view
            return 5;
        }
    }else{
        return 1;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==DTPopoverTable) {
        if ([DTTableMode isEqualToString:@"View"] ) {
            if (section==0) {
                return 4;
            }else if (section==1) {
                return 8;
            }else if (section==2){
                return 4;
            }else if (section==3){
                return 2;
            }else{
                return 1;
            }
            
        }else{// if ([DTTableMode isEqualToString:@"Edit"] || [DTTableMode isEqualToString:@"Add"]){
            if (section==0) {
                return 6;
            }else if (section==1) {
                return 9;
            }else if (section==2){
                return 4;
            }else if (section==3){
                return 2;
            }else{
                return 1;
            }
        }
    }else if (tableView==SubjectTable){
        return filteredSubjectArray.count;
    }else if (tableView==InstructorTable){
        return filteredInstructorArray.count;
    }else if (tableView==ClassroomTable){
        return ClassroomArray.count;
    }else if (tableView==GradeTable){
        return gradeArray.count;
    }else if (tableView==LevelTable){
        return levelArray.count;
    }else if(tableView==DurationTable){
        return durationArray.count;
    }else if(tableView==LanguageTable){
        return languageArray.count;
    }else if(tableView==MediaTable){
        return MediaArray.count;
    }else if(tableView==SourceTable){
        return SourceArray.count;
    }else if (tableView==SchoolTable){
        return filteredSchoolArray.count;
    }
    return 0;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==DTPopoverTable) {
        if ([DTTableMode isEqualToString:@"View"]) {
            if (indexPath.section==0) {
                if (![PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
                    return 0;
                }else{
                    return 35;
                }
            }else if (indexPath.section==1) {
                if ( indexPath.row==0) {
                    return 35;
                }else if (indexPath.row==6){
                    if ([workingATObject.classtype isEqualToString:@"Assessment"]) {
                        return 0;
                    }else{
                        return 32;
                    }
                }else if (indexPath.row==7){
                    return 35;
                }else{
                    return 32;
                }
            }else if (indexPath.section==2){
                if (![PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
                    return 0;
                }else{
                    return 32;
                }
            }else if (indexPath.section==3){
                if (![PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
                    return 0;
                }else{
                    return 32;
                }
            }else{
                return 106;
            }
        }else{// if ([DTTableMode isEqualToString:@"Edit"] || [DTTableMode isEqualToString:@"Add"]){
            if (indexPath.section==0) {
                if (![PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
                    return 0;
                }else{
                    if (indexPath.row==0){
                        return 35;
                    }else if(indexPath.row==1) {
                        return 35;
                    }else if(indexPath.row==2) {
                        return 35;
                    }else if(indexPath.row==3) {
                        return 35;
                    }else{// if(indexPath.row==4) {
                        return 35;
                    }
                }
            }else if (indexPath.section==1) {
                if (indexPath.row==0){
                    return 35;
                }else if(indexPath.row==1) {
                    return 32;
                }else if (indexPath.row==2){
                    return 32;
                }else if (indexPath.row==3){
                    if (showDatePicker==YES) {
                        return 362;
                    }else{
                        return 0;
                    }
                }else if (indexPath.row==4){
                    return 32;
                }else if (indexPath.row==5){
                    return 32;
                }else if (indexPath.row==6){
                    return 32;
                    
                }else if (indexPath.row==7){
                    if (scClassType.selectedSegmentIndex==0) {
                        return 0;
                    }else{
                        return 32;
                    }
                }else{
                    return 35;
                }
            }else if (indexPath.section==2) {
                if (![PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
                    return 0;
                }else{
                    if (indexPath.row==0){
                        return 32;
                    }else if(indexPath.row==1) {
                        return 32;
                    }else if (indexPath.row==2){
                        return 32;
                    }else{// if (indexPath.row==3){
                        return 32;
                    }
                }
            }else if (indexPath.section==3) {
                if (![PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
                    return 0;
                }else{
                    if (indexPath.row==0){
                        return 32;
                    }else{// if(indexPath.row==2) {
                        return 32;
                    }
                }
            }else if (indexPath.section==4){
                return 106;
            }else{
                return 35;
            }
        }

    }else{
        return 38;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView==DTPopoverTable) {
        if (section==0 || section==2 || section==3) {
            if ([PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
                return 44;
            }
        }else{
            return 44;
        }
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ([tableView numberOfSections]-1==section) {
        return 30;
    }else{
        return CGFLOAT_MIN;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==DTPopoverTable) {
        if ([DTTableMode isEqualToString:@"View"]) {
            if (section==0) {
                return [PopoverMode isEqualToString:@"PopoverDTFromDTView"]?[MyClass returntitlewithtitle:[NSString stringWithFormat:@"%@ Information",[ViewATObject.type capitalizedString]]]:nil;
            }else if (section==1) {
                return [MyClass returntitlewithtitle:@"Class Information"];
            }else if (section==2) {
                return [PopoverMode isEqualToString:@"PopoverDTFromDTView"]?[MyClass returntitlewithtitle:@"Parent Information"]:nil;
            }else if (section==3) {
                return [PopoverMode isEqualToString:@"PopoverDTFromDTView"]?[MyClass returntitlewithtitle:@"Media and Source"]:nil;
            }else{// if (indexPath.section==2){
                return [MyClass returntitlewithtitle:@"Remarks"];
            }
        }else if ([DTTableMode isEqualToString:@"Edit"]){
            if (section==0) {
                return [PopoverMode isEqualToString:@"PopoverDTFromDTView"]?[MyClass returntitlewithtitle:[NSString stringWithFormat:@"%@ Information",[ViewATObject.type capitalizedString]]]:nil;
            }else if (section==1) {
                return [MyClass returntitlewithtitle:@"Class Information"];
            }else if (section==2) {
                return [PopoverMode isEqualToString:@"PopoverDTFromDTView"]?[MyClass returntitlewithtitle:@"Parent Information"]:nil;
            }else if (section==3) {
                return [PopoverMode isEqualToString:@"PopoverDTFromDTView"]?[MyClass returntitlewithtitle:@"Media and Source"]:nil;
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Remarks"];
            }else{
                return @" ";
            }
        }else{ //add view
            if (section==0) {
                return [PopoverMode isEqualToString:@"PopoverDTFromDTView"]?[MyClass returntitlewithtitle:[NSString stringWithFormat:@"Lead Information"]]:nil;
            }else if (section==1) {
                return [MyClass returntitlewithtitle:@"Class Information"];
            }else if (section==2) {
                return [PopoverMode isEqualToString:@"PopoverDTFromDTView"]?[MyClass returntitlewithtitle:@"Parent Information"]:nil;
            }else if (section==3) {
                return [PopoverMode isEqualToString:@"PopoverDTFromDTView"]?[MyClass returntitlewithtitle:@"Media and Source"]:nil;
            }else{// if (indexPath.section==2){
                return [MyClass returntitlewithtitle:@"Remarks"];
            }
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //NSDateFormatter *df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    if (tableView==DTPopoverTable) {
        if ([DTTableMode isEqualToString:@"View"]) {
            //if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (indexPath.section==0) {
                if (![PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
                    cell.hidden=YES;
                }else{
                    if (indexPath.row==0){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 157, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Gender"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 7, 172, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:15];
                        GeneralLabel.textColor=[UIColor darkGrayColor];
                        GeneralLabel.textAlignment=NSTextAlignmentRight;
                        GeneralLabel.text=[MyClass returntitlewithtitle:workingATObject.gender];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }else if (indexPath.row==1){
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Name"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        StudentNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 7, 222, 21)];
                        StudentNameLabel.font=[UIFont systemFontOfSize:15];
                        StudentNameLabel.textColor=[UIColor darkGrayColor];
                        StudentNameLabel.textAlignment=NSTextAlignmentRight;
                        
                        if ([ViewATObject.type isEqualToString:@"student"]) {
                            StudentNameLabel.text=[MyClass returnStudentnameWithStudentkey:ViewATObject.studentkey option:@"full"];
                        }else{
                            StudentNameLabel.text=[MyClass returnLeadnameWithLeadkey:ViewATObject.leadkey option:@"full"];
                        }
                        
                        StudentNameLabel.minimumScaleFactor=0.7;
                        StudentNameLabel.adjustsFontSizeToFitWidth=YES;
                        StudentNameLabel.tag=301;
                        [cell.contentView addSubview:StudentNameLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                    }else if (indexPath.row==2){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 80, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"School"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 7, 172, 21)];
                        GradeLabel.font=[UIFont systemFontOfSize:15];
                        GradeLabel.textColor=[UIColor darkGrayColor];
                        GradeLabel.textAlignment=NSTextAlignmentRight;
                        GradeLabel.text=workingATObject.school;
                        GradeLabel.tag=301;
                        [cell.contentView addSubview:GradeLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else if (indexPath.row==3){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 80, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Grade"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 7, 172, 21)];
                        GradeLabel.font=[UIFont systemFontOfSize:15];
                        GradeLabel.textColor=[UIColor darkGrayColor];
                        GradeLabel.textAlignment=NSTextAlignmentRight;
                        GradeLabel.text=workingATObject.grade;
                        GradeLabel.tag=301;
                        [cell.contentView addSubview:GradeLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                }
            }else if (indexPath.section==1) {
                if (indexPath.row==0){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 157, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Class Type"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 7, 172, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:15];
                    GeneralLabel.textColor=[UIColor darkGrayColor];
                    GeneralLabel.textAlignment=NSTextAlignmentRight;
                    GeneralLabel.text=[MyClass returntitlewithtitle:workingATObject.classtype];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 32)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Subject"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 5, 257, 21)];
                    ClassLabel.font=[UIFont systemFontOfSize:15];
                    ClassLabel.textColor=[UIColor darkGrayColor];
                    ClassLabel.textAlignment=NSTextAlignmentRight;
                    ClassLabel.adjustsFontSizeToFitWidth=YES;
                    ClassLabel.minimumScaleFactor=0.7;
                    
                    
                    ClassLabel.text=[MyClass returnsubjectnamewithsubject_shortname:workingATObject.subject centerkey:globalvariables.centerrecord.centerkey];
                    
                    /*
                    if ([globalvariables.language isEqualToString:@"English"]) {
                        ClassLabel.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingATObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_englishname;
                    }else{
                        ClassLabel.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingATObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_chinesename;
                    }*/
                    
                    ClassLabel.tag=301;
                    [cell.contentView addSubview:ClassLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==2){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Date/Time"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StartDateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(91, 5, 236, 21)];
                    StartDateTimeLabel.font=[UIFont systemFontOfSize:15];
                    StartDateTimeLabel.textColor=[UIColor darkGrayColor];
                    StartDateTimeLabel.textAlignment=NSTextAlignmentRight;

                    //StartDateTimeLabel.text=[MyClass convertDateFormatWithDate:[NSString stringWithFormat:@"%@ %@",workingATObject.DTdate,workingATObject.DTtime] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES]
                    StartDateTimeLabel.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:[NSString stringWithFormat:@"%@ %@",workingATObject.DTdate,workingATObject.DTtime]];
                    
                    
                    StartDateTimeLabel.tag=1000;
                    [cell.contentView addSubview:StartDateTimeLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==3){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Duration (mins)"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(171, 5, 154, 21)];
                    ClassDurationLabel.font=[UIFont systemFontOfSize:15];
                    ClassDurationLabel.textColor=[UIColor darkGrayColor];
                    ClassDurationLabel.textAlignment=NSTextAlignmentRight;
                    ClassDurationLabel.text=workingATObject.classduration;
                    ClassDurationLabel.tag=301;
                    [cell.contentView addSubview:ClassDurationLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==4){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Instructor"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    InstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 237, 21)];
                    InstructorLabel.font=[UIFont systemFontOfSize:15];
                    InstructorLabel.textColor=[UIColor darkGrayColor];
                    InstructorLabel.textAlignment=NSTextAlignmentRight;
                    InstructorLabel.text=[workingATObject.instructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:workingATObject.instructor firstorfullname:@"full"];
                    InstructorLabel.tag=301;
                    [cell.contentView addSubview:InstructorLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==5){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Classroom"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 237, 21)];
                    ClassroomLabel.font=[UIFont systemFontOfSize:15];
                    ClassroomLabel.textColor=[UIColor darkGrayColor];
                    ClassroomLabel.textAlignment=NSTextAlignmentRight;
                    ClassroomLabel.text=[workingATObject.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:workingATObject.classroom;
                    ClassroomLabel.tag=301;
                    [cell.contentView addSubview:ClassroomLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==6){
                    if ([workingATObject.classtype isEqualToString:@"Trial"]) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Level"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        LevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 237, 21)];
                        LevelLabel.font=[UIFont systemFontOfSize:15];
                        LevelLabel.textColor=[UIColor darkGrayColor];
                        LevelLabel.textAlignment=NSTextAlignmentRight;
                        LevelLabel.text=tmpLevel;
                        LevelLabel.tag=301;
                        [cell.contentView addSubview:LevelLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==7) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Attendance"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    AttendanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(212, 5, 115, 21)];
                    AttendanceLabel.font=[UIFont systemFontOfSize:15];
                    AttendanceLabel.textColor=[UIColor darkGrayColor];
                    AttendanceLabel.textAlignment=NSTextAlignmentRight;
                    AttendanceLabel.text=[MyClass returntitlewithtitle:[NSString stringWithFormat:@"attendance_%@",workingATObject.attendance]];
                    AttendanceLabel.tag=310;
                    [cell.contentView addSubview:AttendanceLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
            }else if (indexPath.section==2){
                if (![PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
                    cell.hidden=YES;
                }else{
                    if (indexPath.row==0) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 76, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Name"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        ParentNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 5, 172, 21)];
                        ParentNameLabel.font=[UIFont systemFontOfSize:15];
                        ParentNameLabel.textColor=[UIColor darkGrayColor];
                        ParentNameLabel.textAlignment=NSTextAlignmentRight;
                        ParentNameLabel.text=workingATObject.parentname;
                        ParentNameLabel.tag=301;
                        [cell.contentView addSubview:ParentNameLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }else if (indexPath.row==1){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 120, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Contact"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        ParentContactLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 5, 172, 21)];
                        ParentContactLabel.font=[UIFont systemFontOfSize:15];
                        ParentContactLabel.textColor=[UIColor darkGrayColor];
                        ParentContactLabel.textAlignment=NSTextAlignmentRight;
                        ParentContactLabel.text=[MyClass returnLocalNumberWithContact:workingATObject.parentcontact ISOCode:workingATObject.iso_code];
                        [ParentContactLabel sizeToFit];
                        ParentContactLabel.frame=CGRectMake(327-ParentContactLabel.frame.size.width, 5, ParentContactLabel.frame.size.width, 21);
                        [cell.contentView addSubview:ParentContactLabel];
                        
                        UILabel *countrycode=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 21)];
                        countrycode.font=[UIFont systemFontOfSize:15];
                        countrycode.textColor=[UIColor darkGrayColor];
                        countrycode.text=[NSString stringWithFormat:@"+%@",[MyClass returnCountryCodeWithISOCode:workingATObject.iso_code]];
                        [countrycode sizeToFit];
                        countrycode.hidden=[workingATObject.parentcontact isEqualToString:@""];
                        countrycode.frame=CGRectMake(ParentContactLabel.frame.origin.x-countrycode.frame.size.width-2, 5, countrycode.frame.size.width, 21);
                        [cell.contentView addSubview:countrycode];
                        
                        UIImageView *ccimage=[[UIImageView alloc]initWithFrame:CGRectMake(countrycode.frame.origin.x-2-27, (32-18)/2, 27, 18)];
                        [MyClass downloadImageWithImageview:ccimage gender:nil type:@"flag" typekey:workingATObject.iso_code image:@"Yes" async:YES];
                        ccimage.contentMode=UIViewContentModeScaleAspectFill;
                        ccimage.layer.cornerRadius=3;
                        ccimage.layer.masksToBounds=YES;
                        [cell.contentView addSubview:ccimage];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else if (indexPath.row==2){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 76, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Email"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        ParentEmailLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 247, 21)];
                        ParentEmailLabel.font=[UIFont systemFontOfSize:15];
                        ParentEmailLabel.textColor=[UIColor darkGrayColor];
                        ParentEmailLabel.textAlignment=NSTextAlignmentRight;
                        ParentEmailLabel.text=workingATObject.parentemail;
                        ParentEmailLabel.tag=301;
                        [cell.contentView addSubview:ParentEmailLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else if (indexPath.row==3){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 250, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Preferred Language"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        PreferredLanguageLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 5, 177, 21)];
                        PreferredLanguageLabel.font=[UIFont systemFontOfSize:15];
                        PreferredLanguageLabel.textColor=[UIColor darkGrayColor];
                        PreferredLanguageLabel.textAlignment=NSTextAlignmentRight;
                        PreferredLanguageLabel.text=[MyClass returntitlewithtitle:workingATObject.preferredlanguage];
                        PreferredLanguageLabel.tag=301;
                        [cell.contentView addSubview:PreferredLanguageLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }

                }
            }else if (indexPath.section==3){
                if (![PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
                    cell.hidden=YES;
                }else{
                    if (indexPath.row==0) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 76, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Media"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        MediaLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, 242, 21)];
                        MediaLabel.font=[UIFont systemFontOfSize:15];
                        MediaLabel.textColor=[UIColor darkGrayColor];
                        MediaLabel.textAlignment=NSTextAlignmentRight;
                        MediaLabel.text=workingATObject.media;
                        MediaLabel.tag=301;
                        MediaLabel.minimumScaleFactor=0.7;
                        MediaLabel.adjustsFontSizeToFitWidth=YES;
                        [cell.contentView addSubview:MediaLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }else if (indexPath.row==1){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 76, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Source"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        SourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, 242, 21)];
                        SourceLabel.font=[UIFont systemFontOfSize:15];
                        SourceLabel.textColor=[UIColor darkGrayColor];
                        SourceLabel.textAlignment=NSTextAlignmentRight;
                        SourceLabel.text=workingATObject.source;
                        SourceLabel.minimumScaleFactor=0.7;
                        SourceLabel.adjustsFontSizeToFitWidth=YES;
                        SourceLabel.tag=301;
                        [cell.contentView addSubview:SourceLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }
                    
                }
            }else if (indexPath.section==4){
                if (indexPath.row==0) {

                    
                    RemarksLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 310, 95)];
                    RemarksLabel.font=[UIFont systemFontOfSize:15];
                    RemarksLabel.textColor=[UIColor darkGrayColor];
                    RemarksLabel.textAlignment=NSTextAlignmentLeft;
                    RemarksLabel.text=workingATObject.remarks;
                    RemarksLabel.tag=301;
                    [cell.contentView addSubview:RemarksLabel];
                    RemarksLabel.numberOfLines=0;
                    RemarksLabel.adjustsFontSizeToFitWidth = YES;
                    RemarksLabel.lineBreakMode=NSLineBreakByWordWrapping| NSLineBreakByTruncatingTail;
                    RemarksLabel.minimumScaleFactor = 0.8;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    

                }
            }

            
        }else{// if([DTTableMode isEqualToString:@"Edit"]){
            //if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (indexPath.section==0) {
                if (![PopoverMode isEqualToString:@"PopoverDTFromDTView"] ) {
                    cell.hidden=YES;
                }else{
                    if (indexPath.row==0) {
                        
                        scGender = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Male"],[MyClass returntitlewithtitle:@"Female"],nil]];
                        [scGender addTarget:self action:@selector(selectgender:) forControlEvents:UIControlEventValueChanged];
                        scGender.frame=CGRectMake(10, 3, 340, 29);
                        if ([workingATObject.gender isEqualToString:@"Male"]) {
                            scGender.selectedSegmentIndex=0;
                        }else{
                            scGender.selectedSegmentIndex=1;
                        }
                        
                        scGender.tag=301;
                        [cell.contentView addSubview:scGender];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        
                    }else if (indexPath.row==1){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"First name"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        FirstNameText = [[UITextField alloc]initWithFrame:CGRectMake(121, 7, 206, 21)];
                        FirstNameText.font=[UIFont systemFontOfSize:15];
                        FirstNameText.textColor=[UIColor darkGrayColor];
                        FirstNameText.textAlignment=NSTextAlignmentRight;
                        FirstNameText.text=workingATObject.firstname;
                        FirstNameText.borderStyle = UITextBorderStyleRoundedRect;
                        FirstNameText.placeholder=[MyClass returntitlewithtitle:@"student_First name_placeholder"];
                        FirstNameText.tag=301;
                        [FirstNameText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                        [cell.contentView addSubview:FirstNameText];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }else if (indexPath.row==2){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Last name"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        LastNameText = [[UITextField alloc]initWithFrame:CGRectMake(121, 7, 206, 21)];
                        LastNameText.font=[UIFont systemFontOfSize:15];
                        LastNameText.textColor=[UIColor darkGrayColor];
                        LastNameText.textAlignment=NSTextAlignmentRight;
                        LastNameText.borderStyle = UITextBorderStyleRoundedRect;
                        LastNameText.placeholder=[MyClass returntitlewithtitle:@"student_Last name_placeholder"];
                        LastNameText.text=workingATObject.lastname;
                        [LastNameText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                        LastNameText.tag=301;
                        [cell.contentView addSubview:LastNameText];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }else if (indexPath.row==3){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Other name"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        OtherNameText = [[UITextField alloc]initWithFrame:CGRectMake(121, 7, 206, 21)];
                        OtherNameText.font=[UIFont systemFontOfSize:15];
                        OtherNameText.textColor=[UIColor darkGrayColor];
                        OtherNameText.textAlignment=NSTextAlignmentRight;
                        OtherNameText.borderStyle = UITextBorderStyleRoundedRect;
                        OtherNameText.placeholder=[MyClass returntitlewithtitle:@"student_Other name_placeholder"];
                        OtherNameText.text=workingATObject.othername;
                        [OtherNameText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                        OtherNameText.tag=301;
                        [cell.contentView addSubview:OtherNameText];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }else if (indexPath.row==4){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 80, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"School"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        SchoolText = [[UITextField alloc]initWithFrame:CGRectMake(121, 7, 206, 21)];
                        SchoolText.font=[UIFont systemFontOfSize:15];
                        SchoolText.textColor=[UIColor darkGrayColor];
                        SchoolText.textAlignment=NSTextAlignmentRight;
                        SchoolText.borderStyle = UITextBorderStyleRoundedRect;
                        SchoolText.placeholder=[MyClass returntitlewithtitle:@"School"];
                        SchoolText.text=workingATObject.school;
                        [SchoolText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                        SchoolText.tag=301;
                        [cell.contentView addSubview:SchoolText];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        
                    }else if (indexPath.row==5){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 80, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Grade"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        GradeLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 7, 172, 21)];
                        GradeLabel.font=[UIFont systemFontOfSize:15];
                        GradeLabel.textColor=[UIColor darkGrayColor];
                        GradeLabel.textAlignment=NSTextAlignmentRight;
                        GradeLabel.text=workingATObject.grade;
                        GradeLabel.tag=301;
                        [cell.contentView addSubview:GradeLabel];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        
                    }
                }
            }else if (indexPath.section==1) {
                if (indexPath.row==0){
                    
                    scClassType = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Assessment"],[MyClass returntitlewithtitle:@"Trial"],nil]];
                    scClassType.frame=CGRectMake(10, 3, 340, 29);

                    scClassType.selectedSegmentIndex=[workingATObject.classtype isEqualToString:@"Assessment"] ? 0:1;
                    [scClassType addTarget:self action:@selector(selectclasstype:) forControlEvents:UIControlEventValueChanged];
                    
                    scClassType.tag=301;
                    [cell.contentView addSubview:scClassType];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 80, 32)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Subject"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    

                    ClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 257, 32)];
                    ClassLabel.font=[UIFont systemFontOfSize:15];
                    ClassLabel.textColor=[UIColor darkGrayColor];
                    ClassLabel.minimumScaleFactor=0.7;
                    ClassLabel.adjustsFontSizeToFitWidth=YES;
                    ClassLabel.textAlignment=NSTextAlignmentRight;
                    
                    ClassLabel.text=[MyClass returnsubjectnamewithsubject_shortname:workingATObject.subject centerkey:globalvariables.centerrecord.centerkey];
                    /*
                    if ([globalvariables.language isEqualToString:@"English"]) {
                        ClassLabel.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingATObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_englishname;
                    }else{
                        ClassLabel.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingATObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_chinesename;
                    }*/
                    
                    ClassLabel.tag=302;
                    [cell.contentView addSubview:ClassLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    

                }/*else if (indexPath.row==2){
                    if (showClassPicker==YES) {
                        
                        
                        self.pickerViewmenu =[[NSMutableArray alloc]initWithArray:[MyClass filterSubjectArrayWithSubjectArray:subjectArray Status:@"Active"]];
                        
                        presetRow=[MyClass returnsubjectindexwithsubjectarray:self.pickerViewmenu subject_shortname:workingATObject.subject];
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        self.myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                    }else{
                        cell.hidden=YES;
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                }*/else if (indexPath.row==2){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Date/Time"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    StartDateTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(91, 5, 236, 21)];
                    StartDateTimeLabel.font=[UIFont systemFontOfSize:15];
                    StartDateTimeLabel.textColor=[UIColor darkGrayColor];
                    StartDateTimeLabel.textAlignment=NSTextAlignmentRight;

                    StartDateTimeLabel.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:[NSString stringWithFormat:@"%@ %@",workingATObject.DTdate,workingATObject.DTtime]];

                    
                    StartDateTimeLabel.tag=1000;
                    [cell.contentView addSubview:StartDateTimeLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                    
                    
                }else if (indexPath.row==3){
                    if (showDatePicker==YES) {
                        
                        
                        CalendarView *calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, popoverwidth, 200) Theme:0 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
                        [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:workingATObject.DTdate,nil] ScrollToDate:nil instructorselected:nil];
                        calendarview.delegate=self;

                        [cell.contentView addSubview:calendarview];
                        
                        hourPresetRow=(int)[hourPickerViewMenu indexOfObject:[workingATObject.DTtime substringToIndex:2]];
                        minutePresetRow=(int)[minutePickerViewMenu indexOfObject:[workingATObject.DTtime substringFromIndex:3]];
                        
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, popoverwidth, 162)];
                        myPicker.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.03];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=801;
                        

                        [myPicker selectRow:hourPresetRow inComponent:0 animated:NO];
                        [myPicker selectRow:minutePresetRow inComponent:1 animated:NO];
                        
                        self.myPickerView=myPicker;
                        [cell.contentView addSubview:myPicker];
                    }else{
                        cell.hidden=YES;
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==4){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 250, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Duration (mins)"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 5, 172, 21)];
                    ClassDurationLabel.font=[UIFont systemFontOfSize:15];
                    ClassDurationLabel.textColor=[UIColor darkGrayColor];
                    ClassDurationLabel.textAlignment=NSTextAlignmentRight;
                    ClassDurationLabel.text=workingATObject.classduration;
                    ClassDurationLabel.tag=301;
                    [cell.contentView addSubview:ClassDurationLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }/*else if (indexPath.row==5){
                    if (showClassDurationPicker==YES) {

                        pickerViewmenu=[[NSMutableArray alloc]init];
                        for (int i=1; i<=5*60/[globalvariables.centerrecord.classtimeinterval intValue]; i++) {
                            [pickerViewmenu addObject:[NSString stringWithFormat:@"%d",[globalvariables.centerrecord.classtimeinterval intValue]*i]];
                        }
                        presetRow=(int)[pickerViewmenu indexOfObject:ClassDurationLabel.text];

                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetRow inComponent:0 animated:NO];
                        self.myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                    }else{
                        cell.hidden=YES;
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }*/else if (indexPath.row==5){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Instructor"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    InstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 237, 21)];
                    InstructorLabel.font=[UIFont systemFontOfSize:15];
                    InstructorLabel.textColor=[UIColor darkGrayColor];
                    InstructorLabel.textAlignment=NSTextAlignmentRight;
                    InstructorLabel.text=[workingATObject.instructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:workingATObject.instructor firstorfullname:@"full"];
                    InstructorLabel.tag=301;
                    [cell.contentView addSubview:InstructorLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else if (indexPath.row==6){
                    
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Classroom"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    ClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 237, 21)];
                    ClassroomLabel.font=[UIFont systemFontOfSize:15];
                    ClassroomLabel.textColor=[UIColor darkGrayColor];
                    ClassroomLabel.textAlignment=NSTextAlignmentRight;
                    ClassroomLabel.text=[workingATObject.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:workingATObject.classroom;
                    ClassroomLabel.tag=301;
                    [cell.contentView addSubview:ClassroomLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else if (indexPath.row==7){
                    if ([workingATObject.classtype isEqualToString:@"Trial"]) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Level"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        LevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 237, 21)];
                        LevelLabel.font=[UIFont systemFontOfSize:15];
                        LevelLabel.textColor=[UIColor darkGrayColor];
                        LevelLabel.textAlignment=NSTextAlignmentRight;
                        LevelLabel.text=tmpLevel;
                        LevelLabel.tag=301;
                        [cell.contentView addSubview:LevelLabel];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.hidden=YES;
                    }
                

                    
                }else if (indexPath.row==8) {
                    GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    GeneralLabel.font=[UIFont systemFontOfSize:17];
                    GeneralLabel.textColor=[UIColor blackColor];
                    GeneralLabel.text=[MyClass returntitlewithtitle:@"Attendance"];
                    GeneralLabel.tag=301;
                    [cell.contentView addSubview:GeneralLabel];
                    
                    UIButton *AttendanceButton=[[UIButton alloc]initWithFrame:CGRectMake(289, 1.5, 32, 32)];
                    [AttendanceButton addTarget: self action:@selector(attendancebuttontouchupinside:) forControlEvents: UIControlEventTouchUpInside];
                    [AttendanceButton addTarget: self action:@selector(attendancebuttontouchdown:) forControlEvents: UIControlEventTouchDown];
                    AttendanceButton.tag=-121;
                    [cell.contentView addSubview:AttendanceButton];
                    

                    [AttendanceButton setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:@"Class" attendance:workingATObject.attendance makeupattendance:nil]] forState:UIControlStateNormal];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
            
            }else if (indexPath.section==2){
                if (![PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
                    cell.hidden=YES;
                }else{
                    if (indexPath.row==0) {
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 76, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Name"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        ParentNameText = [[UITextField alloc]initWithFrame:CGRectMake(121, 7, 206, 21)];
                        ParentNameText.font=[UIFont systemFontOfSize:15];
                        ParentNameText.textColor=[UIColor darkGrayColor];
                        ParentNameText.textAlignment=NSTextAlignmentRight;
                        ParentNameText.text=workingATObject.parentname;
                        ParentNameText.placeholder=[MyClass returntitlewithtitle:@"Parent Name"];
                        ParentNameText.borderStyle = UITextBorderStyleRoundedRect;
                        ParentNameText.tag=301;
                        [ParentNameText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                        [cell.contentView addSubview:ParentNameText];
                        [ParentNameText addTarget:self action:@selector(offsetTextField:)forControlEvents:UIControlEventEditingDidBegin];
                        
                        [cell.contentView addSubview:ParentNameText];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }else if (indexPath.row==1){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 120, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Contact"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        ParentContactText = [[UITextField alloc]initWithFrame:CGRectMake(121, 7, 206, 21)];
                        ParentContactText.font=[UIFont systemFontOfSize:15];
                        ParentContactText.textColor=[UIColor darkGrayColor];
                        ParentContactText.textAlignment=NSTextAlignmentRight;
                        ParentContactText.text=[MyClass returnLocalNumberWithContact:workingATObject.parentcontact ISOCode:workingATObject.iso_code];
                        ParentContactText.borderStyle = UITextBorderStyleRoundedRect;
                        [ParentContactText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                        ParentContactText.placeholder=[MyClass returntitlewithtitle:@"Parent Contact"];
                        ParentContactText.tag=301;
                        [ParentContactText addTarget:self action:@selector(offsetTextField:)forControlEvents:UIControlEventEditingDidBegin];
                        ParentContactText.layer.sublayerTransform = CATransform3DMakeTranslation(0, 1, 0);
                        [ParentContactText setLeftViewMode:UITextFieldViewModeAlways];
                        
                        UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 74, ParentContactText.frame.size.height)];
                        
                        UIImageView *ccimage=[[UIImageView alloc]initWithFrame:CGRectMake(5, (ParentContactText.frame.size.height-18)/2, 27, 18)];
                        [MyClass downloadImageWithImageview:ccimage gender:nil type:@"flag" typekey:workingATObject.iso_code image:@"Yes" async:YES];
                        ccimage.contentMode=UIViewContentModeScaleAspectFill;
                        ccimage.layer.cornerRadius=3;
                        ccimage.layer.masksToBounds=YES;
                        [spacerView addSubview:ccimage];
                        
                        UIButton *ccbutton=[[UIButton alloc]initWithFrame:ccimage.frame];
                        [ccbutton addTarget:self action:@selector(ccbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                        [spacerView addSubview:ccbutton];
                        
                        
                        UILabel *cclabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 150, 21)];
                        cclabel.font=[UIFont systemFontOfSize:15];
                        cclabel.textColor=[UIColor darkGrayColor];
                        cclabel.text=[NSString stringWithFormat:@"+%@",[MyClass returnCountryCodeWithISOCode:workingATObject.iso_code]];
                        [cclabel sizeToFit];
                        cclabel.frame=CGRectMake(5+3+27, 0, cclabel.frame.size.width, 21);
                        
                        [spacerView addSubview:cclabel];
                        
                        spacerView.frame=CGRectMake(0, 0, 5+27+3+cclabel.frame.size.width, ParentContactText.frame.size.height);
                        [ParentContactText setLeftView:spacerView];
                        
                        [cell.contentView addSubview:ParentContactText];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else if (indexPath.row==2){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 76, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Email"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        ParentEmailText = [[UITextField alloc]initWithFrame:CGRectMake(121, 7, 206, 21)];
                        ParentEmailText.font=[UIFont systemFontOfSize:15];
                        ParentEmailText.textColor=[UIColor darkGrayColor];
                        ParentEmailText.textAlignment=NSTextAlignmentRight;
                        ParentEmailText.text=workingATObject.parentemail;
                        ParentEmailText.borderStyle = UITextBorderStyleRoundedRect;
                        ParentEmailText.placeholder=[MyClass returntitlewithtitle:@"Email"];
                        ParentEmailText.tag=301;
                        [ParentEmailText addTarget:self action:@selector(offsetTextField:)forControlEvents:UIControlEventEditingDidBegin];
                        [cell.contentView addSubview:ParentEmailText];
                        [ParentEmailText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else if (indexPath.row==3){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 250, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Preferred Language"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        PreferredLanguageLabel = [[UILabel alloc]initWithFrame:CGRectMake(155, 5, 172, 21)];
                        PreferredLanguageLabel.font=[UIFont systemFontOfSize:15];
                        PreferredLanguageLabel.textColor=[UIColor darkGrayColor];
                        PreferredLanguageLabel.textAlignment=NSTextAlignmentRight;
                        PreferredLanguageLabel.text=[MyClass returntitlewithtitle:workingATObject.preferredlanguage];
                        
                        PreferredLanguageLabel.tag=1000;
                        [cell.contentView addSubview:PreferredLanguageLabel];
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        
                    }/*else if (indexPath.row==4){
                        if (showPreferedLanguagePicker==YES) {
                            pickerViewmenu=[NSMutableArray arrayWithObjects:@"Cantonese",@"English",@"Mandarin",nil];
                            
                            presetRow=(int)[pickerViewmenu indexOfObject:workingATObject.preferredlanguage];
                            
                            UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                            UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                            [myPicker setDataSource:self];
                            [myPicker setDelegate:self];
                            myPicker.tag=802;
                            
                            [myPicker selectRow:presetRow inComponent:0 animated:NO];
                            self.myPickerView=myPicker;
                            [datepickerview addSubview:myPicker];
                            
                            
                            [cell.contentView addSubview:datepickerview];
                        }else{
                            cell.hidden=YES;
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }*/

                }
                
                
            }else if (indexPath.section==3){
                if (![PopoverMode isEqualToString:@"PopoverDTFromDTView"]) {
                    cell.hidden=YES;
                }else{
                    if (indexPath.row==0){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 250, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Media"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        MediaLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, 242, 21)];
                        MediaLabel.font=[UIFont systemFontOfSize:15];
                        MediaLabel.textColor=[UIColor darkGrayColor];
                        MediaLabel.textAlignment=NSTextAlignmentRight;
                        MediaLabel.minimumScaleFactor=0.7;
                        MediaLabel.adjustsFontSizeToFitWidth=YES;
                        MediaLabel.text=workingATObject.media;
                        
                        MediaLabel.tag=1000;
                        [cell.contentView addSubview:MediaLabel];
                        
                        if (MediaArray.count>1) {
                            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        }else{
                            cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        }
                        
                        
                        
                    }/*else if (indexPath.row==1){
                        if (showMediaPicker==YES) {
                            //pickerViewmenu=[NSMutableArray arrayWithObjects:@"Cantonese",@"English",@"Mandarin",nil];
                            pickerViewmenu =[[NSMutableArray alloc]initWithArray:MediaArray];
                            
                            presetRow=[self returnmediasourceindexwitharray:pickerViewmenu description:workingATObject.media];
                            
                            UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                            UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                            [myPicker setDataSource:self];
                            [myPicker setDelegate:self];
                            myPicker.tag=802;
                            
                            [myPicker selectRow:presetRow inComponent:0 animated:NO];
                            self.myPickerView=myPicker;
                            [datepickerview addSubview:myPicker];
                            
                            
                            [cell.contentView addSubview:datepickerview];
                        }else{
                            cell.hidden=YES;
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }*/else if (indexPath.row==1){
                        
                        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 250, 21)];
                        GeneralLabel.font=[UIFont systemFontOfSize:17];
                        GeneralLabel.textColor=[UIColor blackColor];
                        GeneralLabel.text=[MyClass returntitlewithtitle:@"Source"];
                        GeneralLabel.tag=301;
                        [cell.contentView addSubview:GeneralLabel];
                        
                        SourceLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, 242, 21)];
                        SourceLabel.font=[UIFont systemFontOfSize:15];
                        SourceLabel.textColor=[UIColor darkGrayColor];
                        SourceLabel.minimumScaleFactor=0.7;
                        SourceLabel.adjustsFontSizeToFitWidth=YES;
                        SourceLabel.textAlignment=NSTextAlignmentRight;
                        SourceLabel.text=workingATObject.source;
                        
                        SourceLabel.tag=1000;
                        [cell.contentView addSubview:SourceLabel];
                        if (SourceArray.count>1) {
                            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        }else{
                            cell.selectionStyle=UITableViewCellSelectionStyleNone;
                        }
                        
                    }/*else if (indexPath.row==3){
                        if (showSourcePicker==YES) {
                            //pickerViewmenu=[NSMutableArray arrayWithObjects:@"Cantonese",@"English",@"Mandarin",nil];
                            pickerViewmenu =[[NSMutableArray alloc]initWithArray:SourceArray];
                            
                            presetRow=[self returnmediasourceindexwitharray:pickerViewmenu description:workingATObject.source];
                            
                            UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                            UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                            [myPicker setDataSource:self];
                            [myPicker setDelegate:self];
                            myPicker.tag=802;
                            
                            [myPicker selectRow:presetRow inComponent:0 animated:NO];
                            self.myPickerView=myPicker;
                            [datepickerview addSubview:myPicker];
                            
                            
                            [cell.contentView addSubview:datepickerview];
                        }else{
                            cell.hidden=YES;
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }*/
                    
                }
                
                
            }else if (indexPath.section==4){
                if (indexPath.row==0) {

                    
                    RemarksText = [[UITextView alloc]initWithFrame:CGRectMake(20, 5, 310, 90)];
                    RemarksText.font=[UIFont systemFontOfSize:15];
                    RemarksText.textColor=[UIColor darkGrayColor];
                    RemarksText.textAlignment=NSTextAlignmentLeft;
                    RemarksText.text=workingATObject.remarks;
                    RemarksText.delegate=self;
                    RemarksText.tag=301;
                    [cell.contentView addSubview:RemarksText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                }
            }else if(indexPath.section==5){
                if (indexPath.row==0) {
                    
                    DeleteRecordBtn=[[UIButton alloc]init];
                    DeleteRecordBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    DeleteRecordBtn.frame=CGRectMake(0, 0, popoverwidth, 35);
                    DeleteRecordBtn.titleLabel.font=[UIFont systemFontOfSize:15];
                    [DeleteRecordBtn setTitle:[MyClass returntitlewithtitle:@"Delete Record"] forState:UIControlStateNormal];
                    [DeleteRecordBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    DeleteRecordBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    [DeleteRecordBtn addTarget: self action:@selector(deleteDTRecord:) forControlEvents: UIControlEventTouchUpInside];
                    DeleteRecordBtn.tag=930;
                    DeleteRecordBtn.hidden=NO;
                    [cell.contentView addSubview:DeleteRecordBtn];
                    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }
        
    }else if (tableView==SubjectTable){
        UITableViewCell *cell;
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            STSubjectcode = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 65, 38)];
            STSubjectcode.font=[UIFont systemFontOfSize:15];
            STSubjectcode.textColor=[UIColor darkGrayColor];
            STSubjectcode.tag=1200;
            [cell.contentView addSubview:STSubjectcode];
            
            STSubjectname = [[UILabel alloc]initWithFrame:CGRectMake(85, 0, subjecttablewidth-100-30, 38)];
            STSubjectname.font=[UIFont systemFontOfSize:15];
            STSubjectname.textColor=[UIColor darkGrayColor];
            STSubjectname.tag=1201;
            STSubjectname.minimumScaleFactor=0.7;
            STSubjectname.numberOfLines=0;
            STSubjectname.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:STSubjectname];
            
            STSubjectselected = [[UIImageView alloc]initWithFrame:CGRectMake(subjecttablewidth-45, 7, 24, 24)];
            [STSubjectselected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            STSubjectselected.tag=1202;
            [cell.contentView addSubview:STSubjectselected];
        }else{
            STSubjectcode=(UILabel *)[cell.contentView viewWithTag:1200];
            STSubjectname=(UILabel *)[cell.contentView viewWithTag:1201];
            STSubjectselected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        STSubjectcode.text=((SubjectRecord *)[filteredSubjectArray objectAtIndex:indexPath.row]).subject_shortname;
        STSubjectname.text=[MyClass returnsubjectnamewithsubject_shortname:STSubjectcode.text centerkey:globalvariables.centerrecord.centerkey];
        STSubjectselected.hidden=[STSubjectcode.text isEqualToString:workingATObject.subject]?NO:YES;
        
        return cell;
    }else if (tableView==InstructorTable){
        UITableViewCell *cell;
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
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
        ITInstructorname.text=[MyClass returninstructornamewithusername:((Instructor *)[filteredInstructorArray objectAtIndex:indexPath.row]).username firstorfullname:@"full"];
        ITInstructorselected.hidden=[((Instructor *)[filteredInstructorArray objectAtIndex:indexPath.row]).username isEqualToString:workingATObject.instructor]?NO:YES;
        
        return cell;
    }else if (tableView==ClassroomTable){
        UITableViewCell *cell;
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
        
        classroomlabel.text=[((ClassroomRecord *)[ClassroomArray objectAtIndex:indexPath.row]).classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:((ClassroomRecord *)[ClassroomArray objectAtIndex:indexPath.row]).classroom;
        classroomselected.hidden=[workingATObject.classroom isEqualToString:((ClassroomRecord *)[ClassroomArray objectAtIndex:indexPath.row]).classroom]?NO:YES;
        return cell;
    }else if (tableView==GradeTable) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, gradetablewidth-60, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(gradetablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        name.text=indexPath.row==0?[MyClass returntitlewithtitle:@"None"]:[gradeArray objectAtIndex:indexPath.row];
        selected.hidden=[workingATObject.grade isEqualToString:[gradeArray objectAtIndex:indexPath.row]]?NO:YES;
        
        
        return cell;
    }else if (tableView==LevelTable) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, leveltablewidth-60, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(leveltablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        name.text=[levelArray objectAtIndex:indexPath.row];
        selected.hidden=[tmpLevel isEqualToString:[levelArray objectAtIndex:indexPath.row]]?NO:YES;
        
        return cell;
    }else if (tableView==SchoolTable) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, schooltablewidth-60, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(schooltablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        name.text=[filteredSchoolArray objectAtIndex:indexPath.row];
        selected.hidden=![workingATObject.school isEqualToString:[filteredSchoolArray objectAtIndex:indexPath.row]];
        
        
        return cell;
    }else if (tableView==DurationTable) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, durationtablewidth-60, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(durationtablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        name.text=[durationArray objectAtIndex:indexPath.row];
        selected.hidden=[workingATObject.classduration isEqualToString:[durationArray objectAtIndex:indexPath.row]]?NO:YES;
        
        return cell;
    }else if (tableView==LanguageTable) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, languagetablewidth-60, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(languagetablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        name.text=[languageArray objectAtIndex:indexPath.row];
        selected.hidden=[workingATObject.preferredlanguage isEqualToString:[languageArray objectAtIndex:indexPath.row]]?NO:YES;
        
        return cell;
    }else if (tableView==MediaTable) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, mediatablewidth-60, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(mediatablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        if (indexPath.row==0) {
            name.text=[MyClass returntitlewithtitle:@"None"];
        }else{
            name.text=[globalvariables.language isEqualToString:@"English"]?((MarketingRecord *)[MediaArray objectAtIndex:indexPath.row]).description:((MarketingRecord *)[MediaArray objectAtIndex:indexPath.row]).description_chinese;
        }
        
        
        selected.hidden=[workingATObject.media isEqualToString:((MarketingRecord *)[MediaArray objectAtIndex:indexPath.row]).description]?NO:YES;
        
        return cell;
    }else if (tableView==SourceTable) {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, sourcetablewidth-60, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(sourcetablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        
        if (indexPath.row==0) {
            name.text=[MyClass returntitlewithtitle:@"None"];
        }else{
            name.text=[globalvariables.language isEqualToString:@"English"]?((MarketingRecord *)[SourceArray objectAtIndex:indexPath.row]).description:((MarketingRecord *)[SourceArray objectAtIndex:indexPath.row]).description_chinese;
        }
        
        //name.text=((MarketingRecord *)[SourceArray objectAtIndex:indexPath.row]).description;
        selected.hidden=[workingATObject.source isEqualToString:((MarketingRecord *)[SourceArray objectAtIndex:indexPath.row]).description]?NO:YES;
        
        return cell;
    }
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==DTPopoverTable) {
        if (![DTTableMode isEqualToString:@"View"]) {
            if (indexPath.section==0 && indexPath.row==4) {
                //pickerview for grade
                selectedItem=@"School";
                
                schoolsearchbar.text=@"";
                filteredSchoolArray=[[NSMutableArray alloc]initWithArray:SchoolArray];
                [self sortFilteredSchoolArray];
                
                [self showsidewindowwithwindow:@"showSchoolTable"];
                [self closeallpicker];
                
                [SchoolTable reloadData];
                [DTPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==0 && indexPath.row==5) {
                //pickerview for grade
                selectedItem=@"Grade";
                
                [self showsidewindowwithwindow:@"showGradeTable"];
                [self closeallpicker];
                
                [GradeTable reloadData];
                [DTPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==1 && indexPath.row==7) {
                //pickerview for level
                
                selectedItem=@"Level";
                

                
//                levelArray = [[NSMutableArray alloc]initWithArray:((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingATObject.subject centerkey:globalvariables.centerrecord.centerkey]).levelArray];
                levelArray=[MyClass returnLevelOnlyArrayWithSubject:workingATObject.subject];
                
                if ([tmpLevel isEqualToString:@""]) {
                    tmpLevel=[levelArray objectAtIndex:0];
                }
                
                
                [self showsidewindowwithwindow:@"showLevelTable"];
                [self closeallpicker];

                [LevelTable reloadData];
                [DTPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==1 && indexPath.row==2) {
                //pickerview for date/time
                
                selectedItem=@"DateTime";
                
                if (showDatePicker==YES) {
                    showDatePicker=NO;
                }else{
                    [self closeallpicker];
                    showDatePicker=YES;
                }
                
                if ([workingATObject.DTdate isEqualToString:@""]) {
                    //set to next working day
                    NSDate *today=[NSDate date];
                    //df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];[df setDateFormat:@"dd-MMM-yyyy"];
                    datePresetRow=[MyClass returnDateOffsetWithDate:today];
                    hourPresetRow=0;
                    minutePresetRow=0;
                    
                    workingATObject.DTdate=[MyClass returnDateFromBaseDateWithOffset:datePresetRow];
                    workingATObject.DTtime=[NSString stringWithFormat:@"%@:%@",[globalvariables.centerrecord.classstarttime substringToIndex:2],[globalvariables.centerrecord.classstarttime substringFromIndex:2]];
                    
                    //tmpStartDateTime=[NSString stringWithFormat:@"%@ %@:%@",[MyClass returnDateFromBaseDateWithOffset:datePresetRow],[globalvariables.centerrecord.classstarttime substringToIndex:2],[globalvariables.centerrecord.classstarttime substringFromIndex:2]];

                    //StartDateTimeLabel.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:tmpStartDateTime];
                    
                    
                }
                
                
                [DTPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==1 && indexPath.row==5) {
                //pickerview for instructor
                
                selectedItem=@"Instructor";
                
                instructorsearchbar.text=@"";
                filteredInstructorArray=[[NSMutableArray alloc]initWithArray:InstructorArray];
                
                [self showsidewindowwithwindow:@"showInstructorTable"];
                [self closeallpicker];
                
                //self.pickerViewmenu =InstructorNameArray;
                
                
                if ([InstructorLabel.text isEqualToString:@""]) {
                    //[self retrieveInstructorListwithstatus:@"Yes" classday:@"All"];
                    long instructorindex=[self returnfirstavailableinstructor:InstructorArray];
                    //InstructorLabel.text=[MyClass returnfullnamewithfirstname:((Instructor *)[InstructorArray objectAtIndex:instructorindex]).firstname lastname:((Instructor *)[InstructorArray objectAtIndex:instructorindex]).lastname];
                    workingATObject.instructor=((Instructor *)[InstructorArray objectAtIndex:instructorindex]).username;
                }
                
                [InstructorTable reloadData];
                [DTPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==1 && indexPath.row==6) {
                //pickerview for instructor
                
                selectedItem=@"Classroom";
                
                [self showsidewindowwithwindow:@"showClassroomTable"];
                [self closeallpicker];
                
                //self.pickerViewmenu =InstructorNameArray;
                
                
                if ([workingATObject.classroom isEqualToString:@""]) {
                    //[self retrieveInstructorListwithstatus:@"Yes" classday:@"All"];
                    workingATObject.classroom=((ClassroomRecord *)[ClassroomArray objectAtIndex:0]).classroom;
                }
                
                [ClassroomTable reloadData];
                [DTPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==1 && indexPath.row==4) {
                //pickerview for grade
                selectedItem=@"ClassDuration";
                
                [self showsidewindowwithwindow:@"showDurationTable"];
                [self closeallpicker];
                
                //self.pickerViewmenu =InstructorNameArray;
                
                
                if ([workingATObject.classduration isEqualToString:@""]) {
                    //[self retrieveInstructorListwithstatus:@"Yes" classday:@"All"];
                    workingATObject.classduration=[durationArray objectAtIndex:0];
                }
                
                [DurationTable reloadData];
                [DTPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==1 && indexPath.row==1) {
                selectedItem=@"Subject";
                
                subjectsearchbar.text=@"";
                filteredSubjectArray=[[NSMutableArray alloc]initWithArray:subjectArray];
                [self sortFilteredSubjectArray];
                
                [self showsidewindowwithwindow:@"showSubjectTable"];
                [self closeallpicker];
                
                if ([workingATObject.subject isEqualToString:@""]) {
                    workingATObject.subject=((SubjectRecord *)[subjectArray objectAtIndex:0]).subject_shortname;
                }
                
                [SubjectTable reloadData];
                [DTPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==2 && indexPath.row==3) {
                selectedItem=@"PreferredLanguage";
                
                [self showsidewindowwithwindow:@"showLanguageTable"];
                [self closeallpicker];
                
                if ([workingATObject.preferredlanguage isEqualToString:@""]) {
                    workingATObject.preferredlanguage=[languageArray objectAtIndex:0];
                }

                [LanguageTable reloadData];
                [DTPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==3 && indexPath.row==0) {
                if (MediaArray.count>1) {
                    selectedItem=@"Media";
                    
                    [self showsidewindowwithwindow:@"showMediaTable"];
                    [self closeallpicker];
                    
                    if ([workingATObject.media isEqualToString:@""]) {
                        workingATObject.media=((MarketingRecord *)[MediaArray objectAtIndex:0]).description;
                    }

                    [MediaTable reloadData];
                    [DTPopoverTable reloadData];
                    [self adjusttablesize];
                }
            }else if (indexPath.section==3 && indexPath.row==1) {
                if (SourceArray.count>1) {
                    selectedItem=@"Source";
                    
                    [self showsidewindowwithwindow:@"showSourceTable"];
                    [self closeallpicker];
                    
                    if ([workingATObject.source isEqualToString:@""]) {
                        workingATObject.source=((MarketingRecord *)[SourceArray objectAtIndex:0]).description;
                    }

                    [SourceTable reloadData];
                    [DTPopoverTable reloadData];
                    [self adjusttablesize];
                }
            }
        }
    }else if (tableView==SubjectTable){
        if (![workingATObject.subject isEqualToString:((SubjectRecord *)[filteredSubjectArray objectAtIndex:indexPath.row]).subject_shortname]) {
            
            workingATObject.subject=((SubjectRecord *)[filteredSubjectArray objectAtIndex:indexPath.row]).subject_shortname;
            tmpLevel=@"";
            if (scClassType.selectedSegmentIndex==0) {
                workingATObject.classduration=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingATObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration_assessment;
            }else{
                workingATObject.classduration=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingATObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration_trial;
            }
            
            //check if selected time is within operating hour
            if (![workingATObject.DTtime isEqualToString:@""]) {
                NSString *selectedtime=[NSString stringWithFormat:@"%@%@",[workingATObject.DTtime substringToIndex:2],[workingATObject.DTtime substringFromIndex:3]];
                int classduration=[ClassDurationLabel.text intValue];
                //classduration=(int)(classduration/60)*100+classduration%60;
                if ([MyClass classendtimebeyondcenterendtimewithclassstarttime:selectedtime duration:classduration]){
                    UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Appointment"] message:[NSString stringWithFormat:@"%@. %@",[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"],[MyClass returntitlewithtitle:@"Please select another one"]] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [wrongTimeAlert addAction:OKAction];
                    //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                    [MyClass presentViewController:wrongTimeAlert View:self];
                    
                    
                    workingATObject.DTdate=@"";
                    workingATObject.DTtime=@"";
                    
                    StartDateTimeLabel.text=@"";
                    
                }
            }
            
            [SubjectTable reloadData];
            [DTPopoverTable reloadData];
            [self adjusttablesize];
        }
    }else if (tableView==InstructorTable){
        workingATObject.instructor=((Instructor *)[filteredInstructorArray objectAtIndex:indexPath.row]).username;
        [InstructorTable reloadData];
        [DTPopoverTable reloadData];
        [self adjusttablesize];
    }else if (tableView==ClassroomTable){
        workingATObject.classroom=((ClassroomRecord *)[ClassroomArray objectAtIndex:indexPath.row]).classroom;
        [ClassroomTable reloadData];
        [DTPopoverTable reloadData];
        [self adjusttablesize];
    }else if (tableView==GradeTable){
        workingATObject.grade=[gradeArray objectAtIndex:indexPath.row];
        [GradeTable reloadData];
        [DTPopoverTable reloadData];
        [self adjusttablesize];
    }else if (tableView==SchoolTable){
        workingATObject.school=[filteredSchoolArray objectAtIndex:indexPath.row];
        [SchoolTable reloadData];
        [DTPopoverTable reloadData];
        [self adjusttablesize];
    }else if (tableView==LevelTable){
        tmpLevel=[levelArray objectAtIndex:indexPath.row];
        [LevelTable reloadData];
        [DTPopoverTable reloadData];
        [self adjusttablesize];
    }else if (tableView==DurationTable){
        //workingATObject.classduration=[durationArray objectAtIndex:indexPath.row];
        
        
        if (![workingATObject.DTtime isEqualToString:@""]) {
            NSString *selectedtime=[NSString stringWithFormat:@"%@%@",[workingATObject.DTtime substringToIndex:2],[workingATObject.DTtime substringFromIndex:3]];
            int classduration=[[durationArray objectAtIndex:indexPath.row] intValue];
            //classduration=(int)(classduration/60)*100+classduration%60;
            if ([MyClass classendtimebeyondcenterendtimewithclassstarttime:selectedtime duration:classduration]){
                UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Appointment"] message:[NSString stringWithFormat:@"%@. %@",[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"],[MyClass returntitlewithtitle:@"Please select another one"]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [wrongTimeAlert addAction:OKAction];
                //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                    [MyClass presentViewController:wrongTimeAlert View:self];
                
                workingATObject.DTdate=@"";
                workingATObject.DTtime=@"";
                //tmpStartDateTime=@"";
                
            }else{
                workingATObject.classduration=[durationArray objectAtIndex:indexPath.row];
            }
        }else{
            workingATObject.classduration=[durationArray objectAtIndex:indexPath.row];
        }
        
        
        
        [DurationTable reloadData];
        [DTPopoverTable reloadData];
        [self adjusttablesize];
    }else if (tableView==LanguageTable){
        workingATObject.preferredlanguage=[languageArray objectAtIndex:indexPath.row];
        [LanguageTable reloadData];
        [DTPopoverTable reloadData];
        [self adjusttablesize];
    }else if (tableView==MediaTable){
        workingATObject.media=((MarketingRecord *)[MediaArray objectAtIndex:indexPath.row]).description;
        [MediaTable reloadData];
        [DTPopoverTable reloadData];
        [self adjusttablesize];
    }else if (tableView==SourceTable){
        workingATObject.source=((MarketingRecord *)[SourceArray objectAtIndex:indexPath.row]).description;
        [SourceTable reloadData];
        [DTPopoverTable reloadData];
        [self adjusttablesize];
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if([selectedItem isEqualToString:@"DateTime"]){
        if (component==0){
            return [self.hourPickerViewMenu count];
        }else{
            return [self.minutePickerViewMenu count];
        }
        
    }else{
        return [self.pickerViewmenu count];
    }
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if([selectedItem isEqualToString:@"DateTime"]){
        if (component==0){
            return 30;
        }else{
            return 30;
        }
    }else{
        return 260;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.view endEditing:YES];
    if([selectedItem isEqualToString:@"DateTime"]){
        //check if selected time is within operating hour
        
            NSString *selectedtime=[NSString stringWithFormat:@"%@%@",[self.hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
            int classduration=[workingATObject.classduration intValue];
            if ([selectedtime intValue]<[globalvariables.centerrecord.classstarttime intValue]) {
                
                UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Appointment"] message:[MyClass returntitlewithtitle:@"Class start time is outside center's opening hour"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [wrongTimeAlert addAction:OKAction];
                //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                    [MyClass presentViewController:wrongTimeAlert View:self];
                
                
                [DTPopoverTable reloadData];
            }else if ([MyClass classendtimebeyondcenterendtimewithclassstarttime:selectedtime duration:classduration]){
                UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Appointment"] message:[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [wrongTimeAlert addAction:OKAction];
                //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                    [MyClass presentViewController:wrongTimeAlert View:self];
                
                [DTPopoverTable reloadData];
                
            }else{
                workingATObject.DTtime=[NSString stringWithFormat:@"%@:%@",[self.hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
                //tmpStartDateTime=[NSString stringWithFormat:@"%@ %@:%@",[tmpStartDateTime substringToIndex:11],[self.hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[self.minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
                StartDateTimeLabel.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:[NSString stringWithFormat:@"%@ %@",workingATObject.DTdate,workingATObject.DTtime]];
                workingATObject.attendance=globalvariables.centerrecord.defaultattendancestatus;
                
                
                
                [DTPopoverTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                [self adjusttablesize];
            }

        
    }

}

-(void) selectclasstype:(UISegmentedControl *)sender
{
    tmpLevel=@"";
    [self.view endEditing:YES];
    showDatePicker=NO;
    if (sender.selectedSegmentIndex==0) {
        ClassDurationLabel.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingATObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration_assessment;
        
    }else{
        ClassDurationLabel.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingATObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration_trial;
        
    }
    
    //check if selected time is within operating hour
    if (![workingATObject.DTtime isEqualToString:@""]) {
        NSString *selectedtime=[NSString stringWithFormat:@"%@%@",[workingATObject.DTtime substringToIndex:2],[workingATObject.DTtime substringFromIndex:3]];
        int classduration=[ClassDurationLabel.text intValue];
        //classduration=(int)(classduration/60)*100+classduration%60;
        if ([MyClass classendtimebeyondcenterendtimewithclassstarttime:selectedtime duration:classduration]){
            UIAlertController *wrongTimeAlert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Appointment"] message:[NSString stringWithFormat:@"%@. %@",[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"],[MyClass returntitlewithtitle:@"Please select another one"]] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [wrongTimeAlert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [wrongTimeAlert addAction:OKAction];
            //[self presentViewController:wrongTimeAlert animated:YES completion:nil];
                    [MyClass presentViewController:wrongTimeAlert View:self];
            
            
            workingATObject.DTdate=@"";
            workingATObject.DTtime=@"";
            
            //StartDateTimeLabel.text=tmpStartDateTime;
            
        }
    }
    
    workingATObject.classtype=sender.selectedSegmentIndex==0?@"Assessment":@"Trial";
    
    [self showsidewindowwithwindow:@""];
    [self closeallpicker];
    
    [DTPopoverTable reloadData];
    [self adjusttablesize];
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if (keyboardheight>0) {
        CGPoint point = [textView.superview convertPoint:CGPointZero toView:DTPopoverTable];
        NSIndexPath *indexpath =[DTPopoverTable indexPathForRowAtPoint:point];
        
        CGRect rectInTableView = [DTPopoverTable rectForRowAtIndexPath:indexpath];
        
        [DTPopoverTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-DTPopoverTable.frame.size.height) animated:YES];
    }

}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==RemarksText) {
        workingATObject.remarks=textView.text;
    }
}

-(void)offsetBookletField:(id)sender
{
    [DTPopoverTable setContentOffset:CGPointMake(0, 180)];
}

-(void)offsetTextField:(UITextField *)sender
{
    if (keyboardheight>0) {
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:DTPopoverTable];
        NSIndexPath *indexpath =[DTPopoverTable indexPathForRowAtPoint:point];
        
        CGRect rectInTableView = [DTPopoverTable rectForRowAtIndexPath:indexpath];
        
        [DTPopoverTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-DTPopoverTable.frame.size.height) animated:YES];
    }
}



- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    if([selectedItem isEqualToString:@"DateTime"]){
        return 2;
    }else{
        return 1;
    }
}

/*
-(void)passTimeTableInformationwithstartdate:(NSString *)startdate classtime:(NSString *)classtime instructor:(NSString *)instructor classroom:(NSString *)classroom
{
    
    tmpStartDateTime=[NSString stringWithFormat:@"%@ %@",startdate,classtime];
    if (![instructor isEqualToString:@""]) {
        //InstructorLabel.text=[MyClass returninstructornamewithusername:instructor firstorfullname:@"full"];
        workingATObject.instructor=instructor;
    }
    workingATObject.classroom=classroom;


    [self dismissViewControllerAnimated:YES completion:nil];
    
    showDatePicker=NO;
    
    [DTPopoverTable reloadData];
    [self adjusttablesize];
    
}*/

-(void) cancelselection
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) selectgender:(UISegmentedControl *)sender
{
    workingATObject.gender=sender.selectedSegmentIndex==0?@"Male":@"Female";
}


-(void) InitializeField
{
    //workingATObject.firstname=[[NSString alloc]init];
    //if ([PopoverMode isEqualToString:@"PopoverDTFromDTView"]||[PopoverMode isEqualToString:@"PopoverDTFromClassSchedule"] || [PopoverMode isEqualToString:@"PopoverDTFromDetailsView"]) {
        if ([DTTableMode isEqualToString:@"View"] || [DTTableMode isEqualToString:@"Edit"]) {
            [self closeallpicker];
            [self showsidewindowwithwindow:@""];
            
            //initialize field
            workingATObject.type=ViewATObject.type;
            workingATObject.DTkey=ViewATObject.DTkey;
            workingATObject.studentkey=ViewATObject.studentkey;
            workingATObject.leadkey=ViewATObject.leadkey;
            workingATObject.gender=ViewATObject.gender;
            workingATObject.firstname=ViewATObject.firstname;
            workingATObject.lastname=ViewATObject.lastname;
            workingATObject.othername=ViewATObject.othername;
            workingATObject.grade=ViewATObject.grade;
            workingATObject.school=ViewATObject.school;
            workingATObject.classtype=ViewATObject.classtype;
            workingATObject.subject=ViewATObject.subject;
            workingATObject.classduration=ViewATObject.classduration;
            workingATObject.attendance=ViewATObject.attendance;
            workingATObject.DTdate=[MyClass convertDateFormatWithDate:ViewATObject.DTdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy"];
            workingATObject.DTtime=ViewATObject.DTtime;
            workingATObject.instructor=ViewATObject.instructor;
            workingATObject.levelmain=ViewATObject.levelmain;
            workingATObject.levelctm=ViewATObject.levelctm;
            workingATObject.locked=ViewATObject.locked;
            
            if ([workingATObject.classtype isEqualToString:@"Assessment"]) {
                tmpLevel=@"";
            }else{
                if ([MyClass isEyeLevelMathWithSubject:workingATObject.subject]) {
                        if ([ViewATObject.levelmain isEqualToString:@"DT"] || [ViewATObject.levelmain isEqualToString:@"TBD"]) {
                            tmpLevel=ViewATObject.levelmain;
                        }else{
                            if (![ViewATObject.levelctm isEqualToString:@""]) {
                                tmpLevel=[NSString stringWithFormat:@"BTM%@/CTM%@",ViewATObject.levelmain,ViewATObject.levelctm];
                            }else{
                                tmpLevel=[NSString stringWithFormat:@"BTM%@",ViewATObject.levelmain];
                            }
                        }
                }else{
                    tmpLevel=ViewATObject.levelmain;
                }
            }

            workingATObject.parentname=ViewATObject.parentname;
            workingATObject.parentcontact=ViewATObject.parentcontact;
            workingATObject.parentemail=ViewATObject.parentemail;
            workingATObject.preferredlanguage=ViewATObject.preferredlanguage;
            
            workingATObject.remarks=ViewATObject.remarks;
            workingATObject.classroom=ViewATObject.classroom;
            workingATObject.media=ViewATObject.media;
            workingATObject.source=ViewATObject.source;
            
            if ([DTTableMode isEqualToString:@"Edit"] && [workingATObject.parentcontact isEqualToString:@""]) {
                CountryCodeRecord *local=[MyClass returnCountryCodeRecordWithLocalCountry];
                workingATObject.iso_code=local.iso_code;
                workingATObject.parentcontact=local.country_code;
            }else{
                workingATObject.iso_code=ViewATObject.iso_code;
            }
            
        }else if ([DTTableMode isEqualToString:@"Add"]){

            [self closeallpicker];
            [self showsidewindowwithwindow:@""];
            
            //initialize field
            workingATObject.firstname=@"";
            workingATObject.lastname=@"";
            workingATObject.othername=@"";
            workingATObject.gender=@"Male";
            workingATObject.grade=@"";
            workingATObject.school=@"";
            workingATObject.locked=NO;
            
            workingATObject.subject=((SubjectRecord *)[subjectArray objectAtIndex:0]).subject_shortname;
            
            workingATObject.classtype=@"Assessment";
            workingATObject.DTdate=@"";
            workingATObject.DTtime=@"";
            workingATObject.instructor=@"";
            tmpLevel=@"";
            workingATObject.classduration=((SubjectRecord *)[subjectArray objectAtIndex:0]).classduration_assessment;
            workingATObject.attendance=globalvariables.centerrecord.defaultattendancestatus;
            
            workingATObject.parentname=@"";
            workingATObject.parentemail=@"";
            workingATObject.preferredlanguage=@"";
            workingATObject.remarks=@"";
            workingATObject.classroom=@"";
            workingATObject.media=@"";
            workingATObject.source=@"";
            CountryCodeRecord *local=[MyClass returnCountryCodeRecordWithLocalCountry];
            workingATObject.iso_code=local.iso_code;
            workingATObject.parentcontact=local.country_code;
        }else if ([DTTableMode isEqualToString:@"AddAnother"]) {
            [self closeallpicker];
            [self showsidewindowwithwindow:@""];
            
            //initialize field
            workingATObject.gender=ViewATObject.gender;
            workingATObject.firstname=ViewATObject.firstname;
            workingATObject.lastname=ViewATObject.lastname;
            workingATObject.othername=ViewATObject.othername;
            workingATObject.grade=ViewATObject.grade;
            workingATObject.school=ViewATObject.school;
            workingATObject.subject=((SubjectRecord *)[subjectArray objectAtIndex:0]).subject_shortname;
            workingATObject.classduration=((SubjectRecord *)[subjectArray objectAtIndex:0]).classduration_assessment;
            workingATObject.DTdate=@"";
            workingATObject.DTtime=@"";
            workingATObject.classtype=@"Assessment";
            workingATObject.instructor=@"";
            tmpLevel=@"";
            workingATObject.attendance=globalvariables.centerrecord.defaultattendancestatus;
            
            workingATObject.parentname=ViewATObject.parentname;
            workingATObject.parentcontact=ViewATObject.parentcontact;
            workingATObject.iso_code=ViewATObject.iso_code;
            workingATObject.parentemail=ViewATObject.parentemail;
            workingATObject.preferredlanguage=ViewATObject.preferredlanguage;
            
            workingATObject.remarks=@"";
            workingATObject.classroom=@"";
            workingATObject.media=ViewATObject.media;
            workingATObject.source=ViewATObject.source;
            workingATObject.locked=NO;
        }

}
/*
-(void) passFreeSscheduleInformationwithArray:(NSMutableArray *)freescheduleclassarray
{
    //not required
}*/

-(void) adjusttablesize
{
    float tableheight;
    float tablewidth;
    tableheight=maxPopupHeight-keyboardheight;

    if (showSubjectTable){
        tablewidth=popoverwidth+subjecttablewidth;
    }else if (showInstructorTable){
        tablewidth=popoverwidth+instructortablewidth;
    }else if (showClassroomTable){
        tablewidth=popoverwidth+classroomtablewidth;
    }else if (showLevelTable){
        tablewidth=popoverwidth+leveltablewidth;
    }else if (showGradeTable){
        tablewidth=popoverwidth+gradetablewidth;
    }else if (showDurationTable){
        tablewidth=popoverwidth+durationtablewidth;
    }else if (showLanguageTable){
        tablewidth=popoverwidth+languagetablewidth;
    }else if (showMediaTable){
        tablewidth=popoverwidth+mediatablewidth;
    }else if (showSourceTable){
        tablewidth=popoverwidth+sourcetablewidth;
    }else if (showSchoolTable){
        tablewidth=popoverwidth+schooltablewidth;
    }else{
          tablewidth=popoverwidth;
      }
    
    
    [DTPopoverTable setFrame:CGRectMake(0, 44+20, popoverwidth, tableheight-44-20)];

    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    
    self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
    
    if (showSubjectTable){
        [SubjectTable setFrame:CGRectMake(0, 44+84+20+3, subjecttablewidth, tableheight-44-84-20-3)];
        SubjectTableMasterView.hidden=NO;
        InstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LevelTableMasterView.hidden=YES;
        DurationTableMasterView.hidden=YES;
        LanguageTableMasterView.hidden=YES;
        MediaTableMasterView.hidden=YES;
        SourceTableMasterView.hidden=YES;
        SchoolTableMasterView.hidden=YES;
        
        if(filteredSubjectArray.count>0){
            presetRow=[MyClass returnsubjectindexwithsubjectarray:filteredSubjectArray subject_shortname:workingATObject.subject];
            if (presetRow>=0) {
                [SubjectTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
        }
        
    }else if (showInstructorTable){
        [InstructorTable setFrame:CGRectMake(0, 44+84+20+3, instructortablewidth, tableheight-44-84-20-3)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=NO;
        ClassroomTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LevelTableMasterView.hidden=YES;
        DurationTableMasterView.hidden=YES;
        LanguageTableMasterView.hidden=YES;
        MediaTableMasterView.hidden=YES;
        SourceTableMasterView.hidden=YES;
        SchoolTableMasterView.hidden=YES;
        
        if(filteredInstructorArray.count>0){
            presetRow=[MyClass returnInstructorIndexWithInstructorArray:filteredInstructorArray username:workingATObject.instructor activeinstructor:YES defaultzeroifnotfound:YES];
            if (presetRow>=0) {
                [InstructorTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
            
        }
        
        
        
    }else if (showClassroomTable){
        [ClassroomTable setFrame:CGRectMake(0, 44+44+20, classroomtablewidth, tableheight-44-44-20)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=NO;
        GradeTableMasterView.hidden=YES;
        LevelTableMasterView.hidden=YES;
        DurationTableMasterView.hidden=YES;
        LanguageTableMasterView.hidden=YES;
        MediaTableMasterView.hidden=YES;
        SourceTableMasterView.hidden=YES;
        SchoolTableMasterView.hidden=YES;
        
        if (ClassroomArray.count>0) {
            presetRow=[MyClass returnClassroomIndexWithClassroomArray:ClassroomArray classroom:workingATObject.classroom defaultzeroifnotfound:YES];
            if (presetRow>=0) {
                [ClassroomTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
            
        }
        
        
    }else if (showGradeTable){
        [GradeTable setFrame:CGRectMake(0, 44+44+20, gradetablewidth, tableheight-44-44-20)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=NO;
        LevelTableMasterView.hidden=YES;
        DurationTableMasterView.hidden=YES;
        LanguageTableMasterView.hidden=YES;
        MediaTableMasterView.hidden=YES;
        SourceTableMasterView.hidden=YES;
        SchoolTableMasterView.hidden=YES;
        
        presetRow=[gradeArray indexOfObject:workingATObject.grade];
        if (presetRow>=0) {
            [GradeTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        
        
    }else if (showLevelTable){
        [LevelTable setFrame:CGRectMake(0, 44+44+20, leveltablewidth, tableheight-44-44-20)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LevelTableMasterView.hidden=NO;
        DurationTableMasterView.hidden=YES;
        LanguageTableMasterView.hidden=YES;
        MediaTableMasterView.hidden=YES;
        SourceTableMasterView.hidden=YES;
        SchoolTableMasterView.hidden=YES;
        
        if(levelArray.count>0){
            presetRow=[levelArray indexOfObject:tmpLevel];
            if (presetRow>=0) {
                [LevelTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
            
        }
        
        
    }else if (showDurationTable){
        [DurationTable setFrame:CGRectMake(0, 44+44+20, durationtablewidth, tableheight-44-44-20)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LevelTableMasterView.hidden=YES;
        DurationTableMasterView.hidden=NO;
        LanguageTableMasterView.hidden=YES;
        MediaTableMasterView.hidden=YES;
        SourceTableMasterView.hidden=YES;
        SchoolTableMasterView.hidden=YES;
        
        presetRow=[durationArray indexOfObject:workingATObject.classduration];
        if (presetRow>=0) {
            [DurationTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        
        
    }else if (showLanguageTable){
        [LanguageTable setFrame:CGRectMake(0, 44+44+20, languagetablewidth, tableheight-44-44-20)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LevelTableMasterView.hidden=YES;
        DurationTableMasterView.hidden=YES;
        LanguageTableMasterView.hidden=NO;
        MediaTableMasterView.hidden=YES;
        SourceTableMasterView.hidden=YES;
        SchoolTableMasterView.hidden=YES;
        
        presetRow=[languageArray indexOfObject:workingATObject.preferredlanguage];
        if (presetRow>=0) {
            [LanguageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        
        
    }else if (showMediaTable){
        [MediaTable setFrame:CGRectMake(0, 44+44+20, mediatablewidth, tableheight-44-44-20)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LevelTableMasterView.hidden=YES;
        DurationTableMasterView.hidden=YES;
        LanguageTableMasterView.hidden=YES;
        MediaTableMasterView.hidden=NO;
        SourceTableMasterView.hidden=YES;
        SchoolTableMasterView.hidden=YES;
        
        if(MediaArray.count>0){
            presetRow=[MyClass returnMarketingIndexWithMarketingArray:MediaArray marketingname:workingATObject.media defaultzeroifnotfound:YES];
            if (presetRow>=0) {
                [MediaTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
            
        }
        
        
    }else if (showSourceTable){
        [SourceTable setFrame:CGRectMake(0, 44+44+20, sourcetablewidth, tableheight-44-44-20)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LevelTableMasterView.hidden=YES;
        DurationTableMasterView.hidden=YES;
        LanguageTableMasterView.hidden=YES;
        MediaTableMasterView.hidden=YES;
        SourceTableMasterView.hidden=NO;
        SchoolTableMasterView.hidden=YES;
        
        if (SourceArray.count>0) {
            presetRow=[MyClass returnMarketingIndexWithMarketingArray:SourceArray marketingname:workingATObject.source defaultzeroifnotfound:YES];
            if (presetRow>=0) {
                [SourceTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
            
        }
        
        
    }else if (showSchoolTable){
        [SchoolTable setFrame:CGRectMake(0, 44+84+20+3, schooltablewidth, tableheight-44-84-20-3)];
        SubjectTableMasterView.hidden=YES;
        InstructorTableMasterView.hidden=YES;
        ClassroomTableMasterView.hidden=YES;
        GradeTableMasterView.hidden=YES;
        LevelTableMasterView.hidden=YES;
        DurationTableMasterView.hidden=YES;
        LanguageTableMasterView.hidden=YES;
        MediaTableMasterView.hidden=YES;
        SourceTableMasterView.hidden=YES;
        SchoolTableMasterView.hidden=NO;
        
        if (SchoolArray.count>0) {
            presetRow=[filteredSchoolArray indexOfObject:workingATObject.school];
            if (presetRow>=0) {
                [SchoolTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            }
            
        }
        
        
    }
}

-(void) selectsubject:(id)sender
{
    [self.view endEditing:YES];
    
    tmpLevel=@"";
    
    if (scClassType.selectedSegmentIndex==0) {
        workingATObject.classduration=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingATObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration;
    }else{
        workingATObject.classduration=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:workingATObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration_trial;
    }
    
    
    [DTPopoverTable reloadData];
    [self adjusttablesize];
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
        tView.numberOfLines=3;
    }
    // Fill the label text here
    
    
    if([selectedItem isEqualToString:@"DateTime"]){
        [tView setFont:[UIFont systemFontOfSize:16]];
        if (component==0){
            tView.text= [self.hourPickerViewMenu objectAtIndex:row];
        }else{
            tView.text= [self.minutePickerViewMenu objectAtIndex:row];
        }
    }else if ([selectedItem isEqualToString:@"Media"]){
        tView.text= ((MarketingRecord *)[pickerViewmenu objectAtIndex:row]).description;
    }else if ([selectedItem isEqualToString:@"Source"]){
        tView.text= ((MarketingRecord *)[pickerViewmenu objectAtIndex:row]).description;
    }else if ([selectedItem isEqualToString:@"PreferredLanguage"]){
        tView.text= [MyClass returntitlewithtitle:[self.pickerViewmenu objectAtIndex:row]];
    }else{
        tView.text= [self.pickerViewmenu objectAtIndex:row];
    }
    return tView;
}

-(void) updatetextfield:(UITextField *)sender
{
    if (sender==FirstNameText) {
        workingATObject.firstname=sender.text;
    }else if (sender==LastNameText) {
        workingATObject.lastname=sender.text;
    }else if (sender==OtherNameText) {
        workingATObject.othername=sender.text;
    }else if (sender==ParentNameText) {
        workingATObject.parentname=sender.text;
    }else if (sender==ParentContactText) {
        //tmpParentContact=sender.text;
        
        sender.text=[MyClass allspacestrimmed:sender.text];
        if (![MyClass checkValidInput:sender.text Type:@"EmptyInteger"]){
            sender.text=[MyClass returnLocalNumberWithContact:workingATObject.parentcontact ISOCode:workingATObject.iso_code];
        }else{
            workingATObject.parentcontact=[NSString stringWithFormat:@"%@%@", [MyClass returnCountryCodeWithISOCode:workingATObject.iso_code], sender.text];
        }
        
        
    }else if (sender==ParentEmailText) {
        workingATObject.parentemail=sender.text;
    }else if (sender==SchoolText) {
        workingATObject.school=sender.text;
    }

}

-(int) returnmediasourceindexwitharray:(NSMutableArray *)mediasourcearray description:(NSString *)description
{
    for (int i=0; i<mediasourcearray.count; i++) {
        if ([((MarketingRecord *)[mediasourcearray objectAtIndex:i]).description isEqualToString:description]) {
            return i;
        }
    }
    return 0;
}

-(long) returnfirstavailableinstructor:(NSMutableArray *)instructorarray
{
    for (int i=0; i<instructorarray.count; i++) {
        if ([((Instructor *)[instructorarray objectAtIndex:i]).valid isEqualToString:@"Yes"]) {
            return i;
        }
    }
    return 0;
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

/*
-(void) passinstructorinformation:(NSString *)username
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    workingATObject.instructor=username;
    
    
    showInstructorPicker=NO;
    [DTPopoverTable reloadData];
    [self adjusttablesize];
}*/

-(void) passinstructorfromgrid:(NSString *)username
{
    [instructorimagepopover dismissViewControllerAnimated:YES completion:nil];
    workingATObject.instructor=username;
    
    
    //showInstructorPicker=NO;
    [InstructorTable reloadData];
    [DTPopoverTable reloadData];
    [self adjusttablesize];
}

-(void) attendancebuttontouchupinside:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{attendanceringview.alpha = 0.0;} completion:^(BOOL finished){ [attendanceringview removeFromSuperview]; }];
    attendanceringview=nil;
    DTPopoverTable.scrollEnabled=TRUE;
    [DTPopoverTable deselectRowAtIndexPath:[DTPopoverTable indexPathForSelectedRow] animated: YES];
}

-(void) attendancebuttontouchdown:(UIButton *)sender
{
    DTPopoverTable.scrollEnabled=FALSE;
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:DTPopoverTable];
    NSIndexPath *indexpath =[DTPopoverTable indexPathForRowAtPoint:point];
    [DTPopoverTable selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    UIView *windowview = self.view;
    while (windowview.superview != Nil) {
        windowview = windowview.superview;
    }
    

    attendancebuttonarray=[[NSMutableArray alloc]initWithArray:makeupdtattendancebuttonarray];
    attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:workingATObject.attendance highlightbutton:workingATObject.attendance attendancebuttonarray:attendancebuttonarray inview:windowview size:@"small"];

    
    UIWindow *win0 = self.view.window ?: [MyClass activeWindow];
    
    [win0 addSubview:attendanceringview];
    [win0 bringSubviewToFront:attendanceringview];
    
    lasttouchedsector=0;
}

-(void) passinstructorlistfromgrid:(NSString *)instructorlist
{
    //delegate not used
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==subjectsearchbar) {
        if ([searchText isEqualToString:@""]) {
            filteredSubjectArray=[[NSMutableArray alloc]initWithArray:subjectArray];
            [self sortFilteredSubjectArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.subject_shortname contains[c] %@ or self.subject_englishname contains[c] %@ or self.subject_chinesename contains[c] %@",searchText,searchText,searchText];
            filteredSubjectArray=[[NSMutableArray alloc]initWithArray:[subjectArray filteredArrayUsingPredicate:predicate]];
            [self sortFilteredSubjectArray];
        }
        [SubjectTable reloadData];
        [SubjectTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==instructorsearchbar){
        if ([searchText isEqualToString:@""]) {
            filteredInstructorArray=[[NSMutableArray alloc]initWithArray:InstructorArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or self.username contains[c] %@",searchText,searchText,searchText];
            filteredInstructorArray=[[NSMutableArray alloc]initWithArray:[InstructorArray filteredArrayUsingPredicate:predicate]];
        }
        [InstructorTable reloadData];
        [InstructorTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==schoolsearchbar) {
        if ([searchText isEqualToString:@""]) {
            filteredSchoolArray=[[NSMutableArray alloc]initWithArray:SchoolArray];
            [self sortFilteredSchoolArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
            filteredSchoolArray=[[NSMutableArray alloc]initWithArray:[SchoolArray filteredArrayUsingPredicate:predicate]];
            [self sortFilteredSchoolArray];
        }
        [SchoolTable reloadData];
        [SchoolTable setContentOffset:CGPointZero animated:YES];
    }
}

-(void) sortFilteredSubjectArray
{
    NSSortDescriptor *sortBySubjectName;
    if ([globalvariables.language isEqualToString:@"English"]) {
        sortBySubjectName = [NSSortDescriptor sortDescriptorWithKey:@"subject_englishname" ascending:YES selector:@selector(localizedStandardCompare:)];
    }else{
        sortBySubjectName = [NSSortDescriptor sortDescriptorWithKey:@"subject_chinesename" ascending:YES selector:@selector(localizedStandardCompare:)];
    }
    
    NSArray *sortDescriptors = @[sortBySubjectName];
    filteredSubjectArray = [NSMutableArray arrayWithArray:[filteredSubjectArray sortedArrayUsingDescriptors:sortDescriptors]];
}

-(void) sortFilteredSchoolArray
{
    filteredSchoolArray=[[NSMutableArray alloc]initWithArray:[filteredSchoolArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
}


-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    NSString *selecteddatestring=[selecteddatearray firstObject];
    
    if([selectedItem isEqualToString:@"DateTime"]){
        if (![workingATObject.DTdate isEqualToString:selecteddatestring]) {
            workingATObject.DTdate=selecteddatestring;
            workingATObject.attendance=globalvariables.centerrecord.defaultattendancestatus;
            
            [DTPopoverTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self adjusttablesize];
            
        }
    }
}

-(void) ccbuttonpressed:(UIButton *)sender
{
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:workingATObject.iso_code, nil] DataType:@"countrycode" DataIndex:0 ShowSearchBar:YES BottomMode:nil PreferredContentSize:CGSizeMake(220, 200) View:self Button:sender ItemsArray:nil Title:nil];
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"countrycode"]) {
        NSString *localnumber=[MyClass returnLocalNumberWithContact:workingATObject.parentcontact ISOCode:workingATObject.iso_code];
        workingATObject.iso_code=[selecteditems firstObject];
        workingATObject.parentcontact=[NSString stringWithFormat:@"%@%@",[MyClass returnCountryCodeWithISOCode:[selecteditems firstObject]],localnumber];
        
        [DTPopoverTable reloadData];
    }
}

@end
