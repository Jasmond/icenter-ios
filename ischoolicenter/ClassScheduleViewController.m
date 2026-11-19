//
//  ClassScheduleViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 3/7/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "ClassScheduleViewController.h"
#import "MakeupPopoverViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MainMenuViewController.h"
#import "StudentDetailsViewController.h"
#import "DTAddEditViewController.h"
#import "MyClass.h"
#import "LeadDetailsNavController.h"
#import "StudentDetailsNavController.h"
#import "LeadDetailsViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MainViewController.h"
#import "ZXingObjC.h"
#import "MyTableViewCell.h"
#import "SceneDelegate.h"


@interface ClassScheduleViewController ()<myDTAddEditViewControllerDelegate,myLeadDetailsViewController>


@end

#define confirmationwidth 110
#define lessonheaderheight 50
#define maxselectiontableheight 600
#define cellheight 42

#define headerheight 35
#define calendarcellheight 35
#define cellwidth 315/7
#define scanwindowheight 400
#define scanwindowwidth 600
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]

@implementation ClassScheduleViewController
@synthesize JSONArray,ClassScheduleObject,ClassScheduleRecordArray;
@synthesize InstructorObject,InstructorArray;
@synthesize mypopovercontroller,myDTPopoverController,selecteddate,subjectselected,instructorselected,classroomselected;
@synthesize portraitview,classtypeselected,myClassTypeSelectionPopoverController,myClassSelectionPopoverController,myClassroomSelectionPopoverController,myInstructorSelectionPopoverController,myWarningMessagePopoverController;


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

- (void) dismissDTAddEditpopoverwithrefresh:(BOOL)refresh
{
    [self closesidewindow];
    if (refresh) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveClassScheduleWithclassdate:selecteddate];
        });
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    if (attendanceringview) {
        [attendanceringview removeFromSuperview];
        attendanceringview=nil;
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    self.automaticallyAdjustsScrollViewInsets = NO;
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    //supermasterview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width+315, self.view.bounds.size.height)];
    //[self.view addSubview:supermasterview];

    if (attendanceringview) {
        [attendanceringview removeFromSuperview];
        attendanceringview=nil;
    }

    
    //masterView=[[UIView alloc]initWithFrame:CGRectMake(0, 142, self.view.frame.size.width, self.view.frame.size.height-142)];
    masterView.backgroundColor=[UIColor lightGrayColor];
    //classheaderview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 38)];
    //lessonheaderview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 38)];
    
    
    headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 68)];
    headerLabel.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];

    sharebutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-45, 30,30 , 30)];
    [sharebutton setImage:[UIImage imageNamed:@"sharebutton_white.png"] forState:UIControlStateNormal];
    [sharebutton addTarget: self action:@selector(printtopdf:) forControlEvents: UIControlEventTouchUpInside];

    scantotakeattendancebutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-145, 30, 30, 30)];
    [scantotakeattendancebutton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    [scantotakeattendancebutton setImage:[UIImage imageNamed:@"scan_icon.png"] forState:UIControlStateNormal];
    [scantotakeattendancebutton addTarget: self action:@selector(scantotakeattendancebuttonpressed) forControlEvents: UIControlEventTouchUpInside];
    
    
    
    editattendancebutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-90, 34,24 , 24)];
    [editattendancebutton addTarget: self action:@selector(editattendancebuttonpressed) forControlEvents: UIControlEventTouchUpInside];
    
    //editattendanceview=[[UIView alloc]initWithFrame:CGRectMake(0,masterView.frame.size.height, masterView.frame.size.width, cellheight)];
    editattendanceview.backgroundColor=[UIColor lightGrayColor];
    editattendanceviewopened=FALSE;
    editattendanceview.hidden=YES;
    selectededitattendanceclasskeyarray=[[NSMutableArray alloc]init];
    
    //changeattendancestatusbutton=[[UIButton alloc]initWithFrame:CGRectMake(10,8,200,cellheight-16)];
    /*[changeattendancestatusbutton setTitle:[MyClass returntitlewithtitle:@"Attendance"] forState:UIControlStateNormal];
    [changeattendancestatusbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [changeattendancestatusbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    //changeattendancestatusbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [changeattendancestatusbutton addTarget: self action:@selector(changeattendancestatusbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    //changeattendancestatusbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    changeattendancestatusbutton.enabled=NO;*/
    //[editattendanceview addSubview:changeattendancestatusbutton];
    
    selectallicon.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    selectallicon.layer.cornerRadius=6;
    selectallicon.layer.borderColor=[UIColor whiteColor].CGColor;
    selectallicon.layer.borderWidth=1;
    selectallicon.layer.opacity=1;

    deselectallicon.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    deselectallicon.layer.cornerRadius=6;
    deselectallicon.layer.borderColor=[UIColor whiteColor].CGColor;
    deselectallicon.layer.borderWidth=1;
    deselectallicon.layer.opacity=0.3;
    

    
    //UIButton *canceleditattendancebutton=[[UIButton alloc]initWithFrame:CGRectMake(editattendanceview.frame.size.width-140,0,120,cellheight)];
    [canceleditattendancebutton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    [canceleditattendancebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    //canceleditattendancebutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [canceleditattendancebutton addTarget: self action:@selector(canceleditattendancebuttonpressed) forControlEvents: UIControlEventTouchUpInside];
    //canceleditattendancebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //[editattendanceview addSubview:canceleditattendancebutton];
    
    
    reloadbutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-45, 34,28 , 28)];
    [reloadbutton setImage:[UIImage imageNamed:@"reload_white.png"] forState:UIControlStateNormal];
    [reloadbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reloadbutton addTarget: self action:@selector(viewDidAppear:) forControlEvents: UIControlEventTouchUpInside];
    reloadbutton.hidden=YES;
    
    
    menubutton=[[UIButton alloc]initWithFrame:CGRectMake(15, 35, 33, 22)];
    [menubutton setImage:[UIImage imageNamed:@"menu-button.png"] forState:UIControlStateNormal];
    [menubutton setContentMode:UIViewContentModeScaleToFill];
    [menubutton addTarget:self action:@selector(menubuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    
    ClassSelectionButton=[[UIButton alloc]initWithFrame:CGRectMake(2, 110, 250, 29)];
    [ClassSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Classes"] forState:UIControlStateNormal];
    [ClassSelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ClassSelectionButton.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];
    ClassSelectionButton.titleLabel.font=[UIFont systemFontOfSize:12];
    ClassSelectionButton.layer.cornerRadius=5;
    [ClassSelectionButton addTarget: self action:@selector(selectsubject:) forControlEvents: UIControlEventTouchUpInside];
    
    ClassTypeSelectionButton=[[UIButton alloc]initWithFrame:CGRectMake(640, 110, 160, 29)];
    [ClassTypeSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Class Types"] forState:UIControlStateNormal];
    [ClassTypeSelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ClassTypeSelectionButton.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];
    ClassTypeSelectionButton.titleLabel.font=[UIFont systemFontOfSize:12];
    ClassTypeSelectionButton.layer.cornerRadius=5;
    [ClassTypeSelectionButton addTarget: self action:@selector(selectclasstype:) forControlEvents: UIControlEventTouchUpInside];
    if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
        ClassTypeSelectionButton.hidden=YES;
    }

    
    InstructorSelectionButton=[[UIButton alloc]initWithFrame:CGRectMake(254, 110, 206, 29)];
    [InstructorSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Instructors"] forState:UIControlStateNormal];
    [InstructorSelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    InstructorSelectionButton.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];
    InstructorSelectionButton.titleLabel.font=[UIFont systemFontOfSize:12];
    InstructorSelectionButton.layer.cornerRadius=5;
    [InstructorSelectionButton addTarget: self action:@selector(selectinstructor:) forControlEvents: UIControlEventTouchUpInside];

    
    ClassroomSelectionButton=[[UIButton alloc]initWithFrame:CGRectMake(462, 110, 176, 29)];
    [ClassroomSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Classrooms"] forState:UIControlStateNormal];
    [ClassroomSelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ClassroomSelectionButton.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];
    ClassroomSelectionButton.titleLabel.font=[UIFont systemFontOfSize:12];
    ClassroomSelectionButton.layer.cornerRadius=5;
    [ClassroomSelectionButton addTarget: self action:@selector(selectclassroom:) forControlEvents: UIControlEventTouchUpInside];
    
    datebartable=[[UITableView alloc]initWithFrame:CGRectMake(0, headerLabel.frame.size.height, self.view.bounds.size.width-40, 40) style:UITableViewStylePlain];
    datebartable.delegate=self;
    datebartable.dataSource=self;
    datebartable.separatorStyle = UITableViewCellSeparatorStyleNone;
    datebartable.hidden=YES;
    
    [datebartable setShowsVerticalScrollIndicator:NO];
    [supermasterview addSubview:datebartable];
    
    
    CGPoint oldCenter=datebartable.center;
    datebartable.frame=CGRectMake(headerLabel.frame.size.height, 0, datebartable.bounds.size.height, datebartable.bounds.size.width);
    datebartable.transform=CGAffineTransformMakeRotation(-M_PI_2);
    datebartable.center=oldCenter;
    
    UITapGestureRecognizer *doubleTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureCaptured:)];
    doubleTap.delaysTouchesBegan=YES;
    doubleTap.numberOfTapsRequired=2;
    [datebartable addGestureRecognizer:doubleTap];

    
    //[self openDB];
    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    //just to show bar, will get reload again
    [self loaddatebarwithinitialload:YES];
    
    //[self createtableheader];
    
    /*
    ClassScheduleTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 38, self.view.frame.size.width, self.view.frame.size.height-180-2) style:UITableViewStylePlain];
    ClassScheduleTable.dataSource=self;
    ClassScheduleTable.delegate=self;*/
    
    ClassScheduleTable.rowHeight=UITableViewAutomaticDimension;
    ClassScheduleTable.estimatedRowHeight=80;
    
    clpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(classTableLongPress:)];
    clpgr.delegate = self;
    [ClassScheduleTable addGestureRecognizer:clpgr];
    
    LessonTable.rowHeight=UITableViewAutomaticDimension;
    LessonTable.estimatedRowHeight=80;

    
    //ClassScheduleTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    
    if ([ClassScheduleTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        ClassScheduleTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor grayColor];
    [tablerefresh addTarget:self action:@selector(refreshtable) forControlEvents:UIControlEventValueChanged];
    [ClassScheduleTable addSubview:tablerefresh];
    
    [self loadtableheader];
    
    
    
    if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]){
         search_text=[[UITextField alloc]initWithFrame:CGRectMake(802-162, 110, self.view.frame.size.width-866+162, 29)];
    }else{
        search_text=[[UITextField alloc]initWithFrame:CGRectMake(802, 110, self.view.frame.size.width-866, 29)];
    }
    
    
    search_text.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:0.8];//[UIColor lightGrayColor];
    search_text.font=[UIFont systemFontOfSize:12];
    search_text.textColor=[UIColor whiteColor];
    search_text.layer.cornerRadius=3;
    search_text.layer.masksToBounds=YES;
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[MyClass returntitlewithtitle:@"Search"] attributes:@{ NSForegroundColorAttributeName : [UIColor systemGroupedBackgroundColor] }];
    search_text.attributedPlaceholder = str;
    [search_text setTintColor:[UIColor whiteColor]];
    [search_text addTarget:self action:@selector(updatesearchtext)forControlEvents:UIControlEventEditingChanged];
    search_text.clearButtonMode = UITextFieldViewModeWhileEditing;
    search_text.layer.sublayerTransform = CATransform3DMakeTranslation(0, 1, 0);
    [search_text setLeftViewMode:UITextFieldViewModeAlways];
    
    
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 27, search_text.frame.size.height)];
    UIImageView *searchimage=[[UIImageView alloc]initWithFrame:CGRectMake(5,(search_text.frame.size.height-15)/2,15,15)];
    [searchimage setImage:[UIImage imageNamed:@"searchbutton.png"]];
    [spacerView addSubview:searchimage];
    [search_text setLeftView:spacerView];
    

    
    
    //[masterView addSubview:ClassScheduleTable];
    //[masterView addSubview:classheaderview];
    //[masterView addSubview:lessonheaderview];
    //[masterView addSubview:editattendanceview];
    //[supermasterview addSubview:masterView];
    [supermasterview addSubview:headerLabel];
    [supermasterview addSubview:sharebutton];
    [supermasterview addSubview:editattendancebutton];
    [supermasterview addSubview:reloadbutton];
    [supermasterview addSubview:menubutton];
    [supermasterview addSubview:ClassSelectionButton];
    [supermasterview addSubview:ClassTypeSelectionButton];
    [supermasterview addSubview:InstructorSelectionButton];
    [supermasterview addSubview:ClassroomSelectionButton];
    [supermasterview addSubview:search_text];
    
    headertitleview=[[UIView alloc]initWithFrame:CGRectMake(150, 0, self.view.bounds.size.width-300, 68)];
    headertitlename=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, headertitleview.frame.size.width, 20)];
    headertitlename.font=[UIFont boldSystemFontOfSize:17];
    headertitlename.textColor=[UIColor whiteColor];
    headertitlename.textAlignment=NSTextAlignmentCenter;
    [headertitleview addSubview:headertitlename];
    [supermasterview addSubview:headertitleview];
    
    headercentername=[[UILabel alloc]init];
    headercentername.font=[UIFont systemFontOfSize:12];
    headercentername.textAlignment=NSTextAlignmentCenter;
    headercentername.minimumScaleFactor=0.8;
    headercentername.adjustsFontSizeToFitWidth=YES;
    headercentername.textColor=[UIColor whiteColor];
    [headertitleview addSubview:headercentername];
    
    headercenternamearrow=[[UIImageView alloc]init];
    [headercenternamearrow setImage:[UIImage imageNamed:@"openbutton_white.png"]];
    headercenternamearrow.hidden=[MyClass isMultiCenterUser]?NO:YES;
    [headertitleview addSubview:headercenternamearrow];
    //[self updateheadercentertitle];
    
    switchcenterbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, headertitleview.frame.size.width,68)];
    switchcenterbutton.layer.cornerRadius=5;
    switchcenterbutton.layer.masksToBounds=YES;
    if ([MyClass isMultiCenterUser]) {
        [switchcenterbutton addTarget:self action:@selector(switchcenterbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    }
    [headertitleview addSubview:switchcenterbutton];
    
    [supermasterview addSubview:scantotakeattendancebutton];
    
    switchcenterviewcontroller = (SwitchCenterViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SwitchCenterViewController"];
    switchcenterviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    switchcenterviewcontroller.delegate=self;
    
    ailoadpdf = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    ailoadpdf.alpha = 1.0;
    ailoadpdf.center = CGPointMake(self.view.frame.size.width-30,52);
    ailoadpdf.transform=CGAffineTransformMakeScale(0.75, 0.75);
    ailoadpdf.hidesWhenStopped = YES;
    [supermasterview addSubview:ailoadpdf];

    ClassTypeArray=[[NSMutableArray alloc]initWithObjects:@"All Class Types",@"Attending",@"Class",@"Makeup",@"Absent",@"Assessment",@"Trial", nil];
    
    SelectViewButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-31, 110, 29, 29)];
    SelectViewButton.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];
    [SelectViewButton setImage:[UIImage imageNamed:@"viewbutton.png"] forState:UIControlStateNormal];
    [SelectViewButton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    SelectViewButton.layer.cornerRadius=5;
    [SelectViewButton addTarget: self action:@selector(selectviewbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [supermasterview addSubview:SelectViewButton];
    
    LessonExpandRowArray=[[NSMutableArray alloc]init];
    viewmode=[self retrieveviewmode];
    groupsubjectcategory=[[MyClass getlocaldbwithparameter:@"groupsubjectcategory"] isEqualToString:@"Yes"];
    swgroupsubjectcategory.onTintColor=themecolor;
    swgroupsubjectcategory.on=groupsubjectcategory;
    
    SortingButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-62, 110, 29, 29)];
    SortingButton.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];
    [SortingButton setImage:[UIImage imageNamed:@"sortingbutton.png"] forState:UIControlStateNormal];
    [SortingButton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    SortingButton.layer.cornerRadius=5;
    [SortingButton addTarget: self action:@selector(sortingbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [supermasterview addSubview:SortingButton];
    
    //sortingarray=[[NSMutableArray alloc]initWithArray:[self retrievesortingorder]];
    

    
    //add button
    calendarbutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-40, datebartable.frame.origin.y, 40, 40)];
    [calendarbutton addTarget:self action:@selector(opencalendar:) forControlEvents:UIControlEventTouchUpInside];
    calendarbutton.backgroundColor=themecolor;
    [calendarbutton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [calendarbutton setImage:[UIImage imageNamed:@"calendar_icon.png"] forState:UIControlStateNormal];
    [supermasterview addSubview:calendarbutton];
    
    
    
    supermasterviewbutton=[[UIButton alloc]initWithFrame:self.view.bounds];
    [supermasterviewbutton addTarget:self action:@selector(closecalendar) forControlEvents:UIControlEventTouchUpInside];
    [supermasterview addSubview:supermasterviewbutton];
    supermasterviewbutton.hidden=YES;
    
    
    calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 0, 320, self.view.bounds.size.height) Theme:1 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:YES showclassdot:YES schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
    calendarview.delegate=self;
    [supermasterview addSubview:calendarview];
    

    documentfolderbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [documentfolderbutton setImage:[UIImage imageNamed:@"documentfolder_icon.png"] forState:UIControlStateNormal];
    documentfolderbutton.showsTouchWhenHighlighted = YES;
    documentfolderbutton.frame = CGRectMake(60, 28, 30,30);
    [documentfolderbutton setImageEdgeInsets:UIEdgeInsetsMake(6,1,1,6)];
    documentfolderbutton.layer.cornerRadius=5;
    documentfolderbutton.layer.masksToBounds=YES;
    [documentfolderbutton addTarget:self action:@selector(documentfolderbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [supermasterview addSubview:documentfolderbutton];
    
    documentfoldercountlabel = [[UILabel alloc] initWithFrame: CGRectMake(18,7,10,10)];
    documentfoldercountlabel.backgroundColor = [UIColor redColor];
    documentfoldercountlabel.layer.cornerRadius=5;
    documentfoldercountlabel.layer.masksToBounds=YES;
    [documentfolderbutton addSubview:documentfoldercountlabel];
    
    
    //[supermasterview addSubview:searchbutton];
    
    dailyscheduleshowinstructorcolor=[[MyClass getlocaldbwithparameter:@"dailyscheduleshowinstructorcolor"] isEqualToString:@
    "Yes"];
    dailyscheduleshowsubjectcolor=[[MyClass getlocaldbwithparameter:@"dailyscheduleshowsubjectcolor"] isEqualToString:@"Yes"];

    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    

    UIPanGestureRecognizer *panGesture;
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.delegate = self;
    [ClassScheduleTable addGestureRecognizer:panGesture];
    
    [self refreshlanguage];
    [self refreshdocumentfoldercount];
    
    scannerconnected=FALSE;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checktoreloadapp) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    
    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    
//    mainWindow= [[[UIApplication sharedApplication] delegate] window];
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.anyObject.delegate;
    mainWindow = sceneDelegate.window;
    mainviewcontroller = (MainViewController*) [mainWindow rootViewController];
    
    sidewindowviewclosebutton=[[UIButton alloc]initWithFrame:mainWindow.bounds];
    sidewindowviewclosebutton.backgroundColor=[UIColor blackColor];
    sidewindowviewclosebutton.layer.opacity=0.3;
    sidewindowviewclosebutton.tag=-200;
    sidewindowviewclosebutton.hidden=YES;
    [sidewindowviewclosebutton addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [mainWindow addSubview:sidewindowviewclosebutton];
    
    sidewindowview=[[UIView alloc]initWithFrame:CGRectMake(mainWindow.bounds.size.width, 0, 320, mainWindow.bounds.size.height)];
    sidewindowview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    sidewindowview.tag=-200;
    [mainWindow addSubview:sidewindowview];
    
    UIImageView *activityImageView=[[UIImageView alloc]init];
    activityImageView.animationImages=[MyClass returnLoadingIndicatorAnimatedImageWithBaseColor:@"lightgray"];
    activityImageView.alpha=1.0;
    activityImageView.animationDuration=1.5;
    activityImageView.frame=CGRectMake(0,0,45,45);
    [activityImageView startAnimating];
    
    ailoadindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    ailoadindicator.alpha = 1.0;
    ailoadindicator.color=[UIColor clearColor];
    ailoadindicator.transform=CGAffineTransformMakeScale(1, 1);
    ailoadindicator.center = CGPointMake(152.5,mainWindow.frame.size.height/2-7.5);
    ailoadindicator.hidesWhenStopped = YES;
    [ailoadindicator addSubview:activityImageView];
    [sidewindowview addSubview:ailoadindicator];
    
    
}

- (void) keyboardWillShow:(NSNotification *)notification
{
    if (self.presentedViewController==scantotakeattendanceviewcontroller) {
        NSDictionary* userInfo = [notification userInfo];
        CGRect keyboardFrame = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGRect keyboard = [self.view convertRect:keyboardFrame fromView:self.view.window];
        //CGFloat height = self.view.frame.size.height;
        
        //if ((keyboard.origin.y + keyboard.size.height) >= height) {
        if (keyboard.size.height<100) {
            scannerconnected=TRUE;
            scantotakeattendanceview.action.hidden=NO;
            scantotakeattendanceview.actionimage.hidden=NO;
            scantotakeattendanceview.action.text=[MyClass returntitlewithtitle:@"Please scan student code"];
            [scantotakeattendanceview.actionimage setImage:[UIImage imageNamed:@"barcodescanner_iphone.png"]];
            scantotakeattendanceview.retryButton.hidden=YES;
            if (!showscanhistory) {
                [self scan_historybuttonpressed:scantotakeattendanceview.historyButton];
            }
            
        }else{
            if (scannerconnected) {
                if(showscanhistory){
                    [self scan_historybuttonpressed:scantotakeattendanceview.historyButton];
                }
                [scantotakeattendanceview.studentkeytext resignFirstResponder];
                [scantotakeattendanceviewcontroller dismissViewControllerAnimated:YES completion:nil];
                [self performSelector:@selector(refreshtable) withObject:nil afterDelay:0];
            }else{
                [scantotakeattendanceview.studentkeytext resignFirstResponder];

                
                if (!firstopenscanwindow) {
                    [scantotakeattendanceviewcontroller dismissViewControllerAnimated:NO completion:^{[self presentViewController:scantotakeattendanceviewcontroller animated:NO completion:nil];}];
                    [self performSelector:@selector(refreshtable) withObject:nil afterDelay:0];
                }else{
                    firstopenscanwindow=FALSE;
                }
                
                scantotakeattendanceview.action.text=[MyClass returntitlewithtitle:@"Please connect your bluetooth scanner. Tap Retry when it is available"];
                scantotakeattendanceview.action.hidden=NO;
                scantotakeattendanceview.actionimage.hidden=NO;
                [scantotakeattendanceview.actionimage setImage:[UIImage imageNamed:@"barcodescanner_ipad.png"]];
                scantotakeattendanceview.retryButton.hidden=NO;
            }
            scannerconnected=FALSE;
        }
    }
}

- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (supermasterview.frame.origin.x<0) {
        [self closecalendar];
    }
}

-(void) checktoreloadapp
{
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {
        
        //[[self.view subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
        //[[mainWindow subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
        
        if ([myClassSelectionPopoverController presentingViewController].isBeingPresented) {
            [[myClassSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([myClassTypeSelectionPopoverController presentingViewController].isBeingPresented){
            [[myClassTypeSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([myInstructorSelectionPopoverController presentingViewController].isBeingPresented){
            [[myInstructorSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([myClassroomSelectionPopoverController presentingViewController].isBeingPresented){
            [[myClassroomSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([myDTPopoverController presentingViewController].isBeingPresented){
            [[myDTPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([mypopovercontroller presentingViewController].isBeingPresented){
            [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([myWarningMessagePopoverController presentingViewController].isBeingPresented){
            [[myWarningMessagePopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==documentfolderpopover) {
            [documentfolderpopover dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==switchcenterviewcontroller) {
            [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==scantotakeattendanceviewcontroller) {
            [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.mainSlideMenu closeLeftMenu];
        }
        

        //[[mainWindow subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
        
        [self closesidewindow];
        [MyClass removeallsidewindowsexceptsidewindow:sidewindowview sidewindowbutton:sidewindowviewclosebutton];
        
        globalvariables.appbecomeactiveaction=@"";
        globalvariables.leftmenuindex=@"0";
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [MyClass reloadApp];
    }else if ([globalvariables.appbecomeactiveaction isEqualToString:@"refresh"]) {
        globalvariables.appbecomeactiveaction=@"";
        

                if ([myClassSelectionPopoverController presentingViewController].isBeingPresented) {
                    [[myClassSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if ([myClassTypeSelectionPopoverController presentingViewController].isBeingPresented){
                    [[myClassTypeSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if ([myInstructorSelectionPopoverController presentingViewController].isBeingPresented){
                    [[myInstructorSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if ([myClassroomSelectionPopoverController presentingViewController].isBeingPresented){
                    [[myClassroomSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if ([myDTPopoverController presentingViewController].isBeingPresented){
                    [[myDTPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if ([mypopovercontroller presentingViewController].isBeingPresented){
                    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if ([myWarningMessagePopoverController presentingViewController].isBeingPresented){
                    [[myWarningMessagePopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if (self.presentedViewController==documentfolderpopover) {
                    [documentfolderpopover dismissViewControllerAnimated:NO completion:nil];
                }else if (self.presentedViewController==switchcenterviewcontroller) {
                    [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
                }else if (self.presentedViewController==scantotakeattendanceviewcontroller) {
                    [scantotakeattendanceviewcontroller dismissViewControllerAnimated:NO completion:nil];
                }else{
                    [self.mainSlideMenu closeLeftMenu];
                }

                //[[mainWindow subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [self closesidewindow];
        [MyClass removeallsidewindowsexceptsidewindow:sidewindowview sidewindowbutton:sidewindowviewclosebutton];
        //[mainWindow addSubview:sidewindowview];
        
                [self reloadPageWithFirstLoad:NO];

    }
}


-(void) refreshlanguage
{
    headercentername.text=[MyClass returnWindowTitle];
    headertitlename.text=[MyClass returntitlewithtitle:@"Daily Class Schedule"];
    [self updateheadercentertitle];
    [self loadtableheader];
    [sendParentNoteButton setTitle:[MyClass returntitlewithtitle:@"Parent Note"] forState:UIControlStateNormal];
    [sendMessageButton setTitle:[MyClass returntitlewithtitle:@"Message"] forState:UIControlStateNormal];
    [selectallbutton setTitle:[MyClass returntitlewithtitle:@"Select all"] forState:UIControlStateNormal];
    [deselectallbutton setTitle:[MyClass returntitlewithtitle:@"Deselect all"] forState:UIControlStateNormal];
    [actionsButton setTitle:[MyClass returntitlewithtitle:@"Actions"] forState:UIControlStateNormal];
    title_groupsubjectcategory.text=[MyClass returntitlewithtitle:@"Group subject category"];
}

-(void) updateheadercentertitle
{
    
    [headercentername sizeToFit];
    CGRect myframe=headercentername.frame;
    if (myframe.size.width>headertitleview.frame.size.width) {
        headercentername.frame=CGRectMake([MyClass isMultiCenterUser]?-4:0, 43, headertitleview.frame.size.width, 22);
    }else{
        headercentername.frame=CGRectMake((headertitleview.frame.size.width-myframe.size.width)/2+([MyClass isMultiCenterUser]?-4:0), 43, myframe.size.width, 22);
    }
    headercenternamearrow.frame=CGRectMake(headercentername.frame.size.width+headercentername.frame.origin.x, 50.5, 8, 8);
}


- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    if (attendanceringview) {
        if (recognizer.state!=UIGestureRecognizerStateEnded) {
            CGPoint point= [recognizer locationInView:ClassScheduleTable];
            point.x=point.x-attendanceringview.frame.origin.x+ClassScheduleTable.frame.origin.x+masterView.frame.origin.x+classViewLeadingConstraint.constant;
            point.y=point.y-attendanceringview.frame.origin.y+ClassScheduleTable.frame.origin.y+masterView.frame.origin.y-ClassScheduleTable.contentOffset.y;
            lasttouchedsector= [MyClass updateattendanceringwithtouchpoint:point attendanceringview:attendanceringview attendancebuttonarray:attendancebuttonarray lasttouchedsector:lasttouchedsector size:@"large"];
        }else{
            CGPoint point= [recognizer locationInView:ClassScheduleTable];
            point.x=point.x-attendanceringview.frame.origin.x+ClassScheduleTable.frame.origin.x+masterView.frame.origin.x+classViewLeadingConstraint.constant;
            point.y=point.y-attendanceringview.frame.origin.y+ClassScheduleTable.frame.origin.y+masterView.frame.origin.y-ClassScheduleTable.contentOffset.y;
            
            [self attendanceringreleasedwithtouchpoint:point];
            
            [UIView animateWithDuration:0.4 animations:^{attendanceringview.alpha = 0.0;} completion:^(BOOL finished){
                
                [attendanceringview removeFromSuperview];
                attendanceringview=nil;
                [self.mainSlideMenu enableSlidePanGestureForLeftMenu];
                ClassScheduleTable.scrollEnabled=TRUE;
                [ClassScheduleTable deselectRowAtIndexPath:[ClassScheduleTable indexPathForSelectedRow] animated: YES];
            
            
            }];

        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


-(NSString *) retrieveviewmode
{
    NSString *result=[MyClass getlocaldbwithparameter:@"dailyclassscheduleviewmode"];

    /*
    if ([result isEqualToString:@"class"]) {
        classheaderview.hidden=NO;
        lessonheaderview.hidden=YES;
    }else{
        classheaderview.hidden=YES;
        lessonheaderview.hidden=NO;
    }*/
    
    return result;
}

-(void) saveviewmode:(NSString *)viewMode
{
    [MyClass updatelocaldbwithparameter:@"dailyclassscheduleviewmode" value:viewMode];

    /*
    if ([viewMode isEqualToString:@"class"]) {
        classheaderview.hidden=NO;
        lessonheaderview.hidden=YES;
    }else{
        classheaderview.hidden=YES;
        lessonheaderview.hidden=NO;
    }*/
}

-(void) selectviewbuttonpressed:(id)sender
{

    viewmode=[viewmode isEqualToString:@"lesson"]?@"class":@"lesson";
    
    [self saveviewmode:viewmode];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(editattendanceviewopened){
            [self canceleditattendancebuttonpressed];
        }
        [self returnfilterdailyclassschedulearray];
        //[ClassScheduleTable reloadData];
        [self loadtableheader];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}


-(void) loaddatebarwithinitialload:(BOOL)initialload
{
    //schoolDateArray=[[NSMutableArray alloc]initWithArray:globalvariables.centerandreserveddayarray];
    
    if (globalvariables.classdate) {
        selecteddate=globalvariables.classdate;
        
        if (!initialload) {
            globalvariables.classdate=nil;
        }
    }else if (![MyClass isWorkingDate:[MyClass convertToNSDateWithDate:selecteddate DateFormat:@"dd-MMM-yyyy"] includereserveddate:YES]) {
        NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
        [df setDateFormat:@"dd-MMM-yyyy"];
        selecteddate=[MyClass findNextWorkDay2:yesterday includereserveddate:YES];
        
    }
    [self showbarcodescanner];
    
    [datebartable reloadData];
    [df setDateFormat:@"dd-MMM-yyyy"];
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:[MyClass returnDateOffsetWithDate:[df dateFromString:selecteddate]] inSection:0];
    [datebartable selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    
    
    datebartable.hidden=NO;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.mainSlideMenu disableSlidePanGestureForRightMenu];
    globalvariables.lastviewcontroller=(NSString *)self;
    
        if (sidewindowview.frame.origin.x==mainWindow.bounds.size.width) {
                [self reloadPageWithFirstLoad:YES];
        }
    
    

    
}

-(void) loadviewdelay
{
    //[ailoadclass startAnimating];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    [self retrieveClassScheduleWithclassdate:selecteddate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
-(BOOL) retrieveClassScheduleWithclassdate:(NSString *)classdate instructor:(NSString *)instructor subject:(NSString *)subject classtype:(NSString *)classtype classroom:(NSString *)classroom
{
    return [self retrieveClassScheduleWithclassdate:classdate];
}*/

-(BOOL) retrieveClassScheduleWithclassdate:(NSString *)classdate
{
    
    [selectededitattendanceclasskeyarray removeAllObjects];
    
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetableclassrecord2&option=Daily&classdate=%@&instructor=%@&subject=%@&classtype=%@&classroom=%@&username=%@&apptype=icenter",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewdailyclassschedule"],[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:classdate],@"All",@"All",@"All",@"All",globalvariables.username];
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                JSONArray = jsonreturned[@"content"];
                
                //Set up our class array
                filteredClassScheduleRecordArray=[[NSMutableArray alloc] init];
                ClassScheduleRecordArray=[[NSMutableArray alloc] init];

                
                BOOL addTBDInstructor=FALSE;
                NSArray *ClassroomArrayUnsort=[[NSArray alloc]init];

                if (![selecteddate isEqualToString:classdate]) {
                    selectedLessonKey=nil;
                }
                
                SubjectSelectionArray=[[NSMutableArray alloc]initWithObjects:[MyClass returntitlewithtitle:@"All Classes"], nil];
                InstructorSelectionArray=[[NSMutableArray alloc]init];
                ClassroomSelectionArray=[[NSMutableArray alloc]init];
            
                
                //loop through our jsonArray
                for (int i=0; i<JSONArray.count; i++) {
                    
                    userprivilege=[MyClass returnuserprivilegewithcenterkey:globalvariables.centerrecord.centerkey];
                    
                    //Create our ClassRecord object
                    NSString * ctype=[[JSONArray objectAtIndex:i] objectForKey:@"type"];
                    NSString * cstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                    //NSString * cstudentid=[[JSONArray objectAtIndex:i] objectForKey:@"studentid"];
                    NSString * cclasskey=[[JSONArray objectAtIndex:i] objectForKey:@"classkey"];
                    NSString * cdtkey=[[JSONArray objectAtIndex:i] objectForKey:@"dtkey"];
                    NSString * cclasstype=[[JSONArray objectAtIndex:i] objectForKey:@"classtype"];
                    NSString * cenrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
                    
                    NSString * cfirstname;
                    NSString * clastname;
                    NSString * cothername;
                    NSString * cgender;
                    //NSString * cage;
                    //NSString * cdateofbirth;
                    NSString * cimage;
                    NSString * cstudentdisplayname;
                    NSString * cstudentid;
                    
                    if ([ctype isEqualToString:@"student"]) {
                        studentobject=[MyClass returnstudentwithstudentkey:cstudentkey];
                        
                        cfirstname=studentobject.firstname;
                        clastname=studentobject.lastname;
                        cothername=studentobject.othername;
                        cgender=studentobject.gender;
                        //cage=studentobject.age;
                        //cdateofbirth=studentobject.dateofbirth;
                        cimage=studentobject.image;
                        cstudentdisplayname=[MyClass returnStudentnameWithStudentkey:cstudentkey option:@"full"];
                        cstudentid=studentobject.studentid;
                    }else{
                        leadobject=[MyClass returnleadwithleadkey:cstudentkey];
                        cfirstname=leadobject.firstname;
                        clastname=leadobject.lastname;
                        cothername=leadobject.othername;
                        cgender=leadobject.gender;
                        //cage=leadobject.age;
                        //cdateofbirth=leadobject.dateofbirth;
                        cimage=leadobject.image;
                        cstudentdisplayname=[MyClass returnLeadnameWithLeadkey:cstudentkey option:@"full"];
                        cstudentid=leadobject.leadid;
                    }

                    NSString *cparentcontact;
                    if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithprivilegekey:userprivilege.privilegekey]).viewcontactindailyschedule) {
                        ContactRecord *record=[MyClass returnprimarycontactwithtype:ctype typekey:cstudentkey];
                        if (record.contact) {
                            cparentcontact=record.contact;
                        }else{
                            cparentcontact=@"";
                        }
                    }else{
                        cparentcontact=@"";
                    }
                    NSString * csubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                    NSString * clevelmain=[[JSONArray objectAtIndex:i] objectForKey:@"levelmain"];
                    NSString * clevelctm=[[JSONArray objectAtIndex:i] objectForKey:@"levelctm"];
                    NSString *cstartdate = [MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"startdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                    NSString *cmakeupdate = [MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"makeupdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                    
                    NSString * cclassday=[MyClass returndateformatEEEwithdate:[[JSONArray objectAtIndex:i] objectForKey:@"classday"]];
                    NSString * cclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                    NSString * cinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
                    NSString * csinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"sinstructor"];
                    NSString * cclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
                    
                    NSString * cattendance=[[JSONArray objectAtIndex:i] objectForKey:@"attendance"];
                    NSString * cmakeupattendance=[[JSONArray objectAtIndex:i] objectForKey:@"makeupattendance"];
                    //NSString * cmakeup=[[JSONArray objectAtIndex:i] objectForKey:@"makeup"];
                    NSString * cmakeuptime=[[JSONArray objectAtIndex:i] objectForKey:@"makeuptime"];
                    NSString * cmakeupinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"makeupinstructor"];
                    NSString * cmakeupsinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"makeupsinstructor"];
                    NSString * cmakeupclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"makeupclassroom"];
                    
                    NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                    NSString * callclassremarks=[[JSONArray objectAtIndex:i] objectForKey:@"allclassremarks"];
                    NSString * cabsentmakeupreason=[[JSONArray objectAtIndex:i] objectForKey:@"absentmakeupreason"];
                    NSString * cparentnote=[[JSONArray objectAtIndex:i] objectForKey:@"parentnote"];
                    NSString * cautorenew=[[JSONArray objectAtIndex:i] objectForKey:@"autorenew"];
                    NSString * cschedulekey=[[JSONArray objectAtIndex:i] objectForKey:@"schedulekey"];
                    NSString * coutstandingextendtime=[[JSONArray objectAtIndex:i] objectForKey:@"outstandingextendtime"];
                    NSString * cextendedminute=[[JSONArray objectAtIndex:i] objectForKey:@"extendedminute"];
                    int cassessmentformcount=[[[JSONArray objectAtIndex:i] objectForKey:@"assessmentformcount"] intValue];

                    
                    NSString *cfirstclass=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"firstclass"] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd-MMM HH:mm" Translate:NO];
                    NSString *cnextclassalldaytime=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"nextclassalldaytime"] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd-MMM HH:mm" Translate:NO];
                    NSString *clastscheduledclassalldaytime=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"lastscheduledclassalldaytime"] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd-MMM HH:mm" Translate:NO];
                    NSString * cremainingclassscheduledall=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassscheduledall"];
                    NSString * cremainingclassscheduled=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassscheduled"];
                    NSString * cremainingclassTBDclass=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassTBDclass"];
                    NSString * cremainingclassTBDmakeup=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassTBDmakeup"];
                    NSString * coutstandingpayment=[[JSONArray objectAtIndex:i] objectForKey:@"outstandingpayment"];
                    NSString * cclassduration=[[JSONArray objectAtIndex:i] objectForKey:@"classduration"];
                    
                    NSString * cextensiontime=[[JSONArray objectAtIndex:i] objectForKey:@"extensiontime"];
                    NSString * clesson=[[JSONArray objectAtIndex:i] objectForKey:@"lesson"];
                    NSString * csubjectfullname=[MyClass returnsubjectnamewithsubject_shortname:csubject centerkey:globalvariables.centerrecord.centerkey];
                    NSString * leavenaturelistkey=[[JSONArray objectAtIndex:i] objectForKey:@"leavenaturelistkey"];
                    BOOL makeupquotaavailable=[[[JSONArray objectAtIndex:i] objectForKey:@"makeupquotaavailable"] isEqualToString:@"Yes"];
                    BOOL clocked=[[[JSONArray objectAtIndex:i] objectForKey:@"locked"] isEqualToString:@"Yes"];
                    BOOL cenrollmentpaid=[[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentpaid"] isEqualToString:@"1"];
                    
                    //if ([instructor isEqualToString:@"All"]) {
                        //add instructor name to array
                        if ([cclasstype isEqualToString:@"Makeup"]) {
                            if (![cmakeupinstructor isEqualToString:@""]) {
                                if ([cmakeupinstructor isEqualToString:@"TBD"]) {
                                    addTBDInstructor=TRUE;
                                }else{
                                    if (![self checkifinstructorexistwithinstructorarray:InstructorSelectionArray username:cmakeupinstructor]) {
                                        Instructor *instructor=[MyClass returnInstructorWithUsername:cmakeupinstructor];
                                        if (instructor) {
                                            [InstructorSelectionArray addObject:instructor];
                                        }
                                    }
                                }
                            }else{
                                addTBDInstructor=TRUE;
                            }
                        }else{
                            if ([cinstructor isEqualToString:@"TBD"]) {
                                addTBDInstructor=TRUE;
                            }else{
                                if (![self checkifinstructorexistwithinstructorarray:InstructorSelectionArray username:cinstructor]) {
                                    Instructor *instructor=[MyClass returnInstructorWithUsername:cinstructor];
                                    if (instructor) {
                                        [InstructorSelectionArray addObject:instructor];
                                    }
                                }
                            }
                        }

                        if (![SubjectSelectionArray containsObject:csubject]) {
                            [SubjectSelectionArray addObject:csubject];
                        }

                    
                    NSString *realclasstime;
                    NSString *realclassroom;
                    NSString * cinstructorfullname;
                    NSString * csinstructorfullname;
                    if ([cclasstype isEqualToString:@"Makeup"]) {
                        cinstructorfullname=[MyClass returninstructornamewithusername:cmakeupinstructor firstorfullname:@"full"];
                        realclasstime=cmakeuptime;
                        realclassroom=cmakeupclassroom;
                        csinstructorfullname=[MyClass returninstructornamewithusername:cmakeupsinstructor firstorfullname:@"full"];
                    }else{
                        cinstructorfullname=[MyClass returninstructornamewithusername:cinstructor firstorfullname:@"full"];
                        realclasstime=cclasstime;
                        realclassroom=cclassroom;
                        csinstructorfullname=[MyClass returninstructornamewithusername:csinstructor firstorfullname:@"full"];
                    }
                    
                    if (![ClassroomSelectionArray containsObject:realclassroom]) {
                        [ClassroomSelectionArray addObject:realclassroom];
                    }
                    
                    ClassScheduleObject=[[ClassScheduleRecord alloc]initClassScheduleRecordWithstudentkey:cstudentkey andenrollmentkey:cenrollmentkey andclasskey:cclasskey anddtkey:cdtkey andclasstype:cclasstype andfirstname:cfirstname andlastname:clastname andothername:cothername andgender:cgender andparentcontact:cparentcontact andimage:cimage andsubject:csubject andlevelmain:clevelmain andlevelctm:clevelctm andstartdate:cstartdate andclassday:cclassday andclasstime:cclasstime andinstructor:cinstructor andclassroom:cclassroom andattendance:cattendance andmakeupattendance:cmakeupattendance andmakeupdate:cmakeupdate andmakeuptime:cmakeuptime andremarks:cremarks andallclassremarks:callclassremarks andmakeupinstructor:cmakeupinstructor andmakeupclassroom:cmakeupclassroom andabsentmakeupreason:cabsentmakeupreason andfirstclass:cfirstclass andnextclassalldaytime:cnextclassalldaytime andlastscheduledclassalldaytime:clastscheduledclassalldaytime andremainingclassscheduled:cremainingclassscheduled andremainingclassTBDclass:cremainingclassTBDclass andremainingclassTBDmakeup:cremainingclassTBDmakeup andremainingclassscheduledall:cremainingclassscheduledall andoutstandingpayment:coutstandingpayment andclassduration:cclassduration type:ctype instructorfullname:cinstructorfullname autorenew:cautorenew schedulekey:cschedulekey outstandingextendtime:coutstandingextendtime extendedminute:cextendedminute status:nil extensiontime:cextensiontime subjectfullname:csubjectfullname studentid:cstudentid parentnote:cparentnote studentdisplayname:cstudentdisplayname assessmentformcount:cassessmentformcount leavenaturelistkey:leavenaturelistkey makeupquotaavailable:makeupquotaavailable realclassroom:realclassroom realclasstime:realclasstime lesson:clesson sinstructor:csinstructor makeupsinstructor:cmakeupsinstructor sinstructorfullname:csinstructorfullname locked:clocked enrollmentpaid:cenrollmentpaid];
                    
                    [ClassScheduleRecordArray addObject:ClassScheduleObject];
                }
                
                //sort subject selection array
                [SubjectSelectionArray removeObjectAtIndex:0];
                SubjectSelectionArray=[MyClass returnsortedsubjectlistwithsubjectcodearray:SubjectSelectionArray];

                
                [SubjectSelectionArray insertObject:[MyClass returntitlewithtitle:@"All Classes"] atIndex:0];
                
                
                
                //[self returnfilterdailyclassschedulearray];
                
                //if ([instructor isEqualToString:@"All"]) {
                    
                    //sort instructor array
                    NSSortDescriptor *sortByfirstname = [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES selector:@selector(localizedStandardCompare:)];
                    NSSortDescriptor *sortBylastname = [NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES selector:@selector(localizedStandardCompare:)];
                    NSArray *sortDescriptors = @[sortByfirstname, sortBylastname];
                    InstructorSelectionArray = [NSMutableArray arrayWithArray:[InstructorSelectionArray sortedArrayUsingDescriptors:sortDescriptors]];
                    
                    [InstructorSelectionArray insertObject:[[Instructor alloc]initInstructortWithstaffkey:nil firstname:[MyClass returntitlewithtitle:@"All Instructors"] lastname:@"" username:nil phone:nil valid:nil photoalbumrecord:nil staffschedule:NO] atIndex:0];
                    
                    if (addTBDInstructor) {
                        [InstructorSelectionArray addObject:[[Instructor alloc]initInstructortWithstaffkey:nil firstname:@"TBD" lastname:@"" username:@"TBD" phone:nil valid:nil photoalbumrecord:nil staffschedule:NO]];
                    }

                //if ([classroom isEqualToString:@"All"]) {
                    
                    //sort classroom array
                    ClassroomArrayUnsort = [ClassroomSelectionArray sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
                    ClassroomSelectionArray=[[NSMutableArray alloc]initWithArray:ClassroomArrayUnsort];
                    if (![ClassroomSelectionArray containsObject:[MyClass returntitlewithtitle:@"All Classrooms"]]) {
                        [ClassroomSelectionArray insertObject:[MyClass returntitlewithtitle:@"All Classrooms"] atIndex:0];
                    }
        }
    }];
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    [self returnfilterdailyclassschedulearray];
    
        if (!reloadbutton.hidden) {
            reloadbutton.hidden=YES;
            sharebutton.hidden=NO;
        }
        
        //[self retrieveClassDay];
        return YES;


}

- (IBAction)actionsButtonPressed:(id)sender {
    NSMutableArray *actionarray=[[NSMutableArray alloc]init];
    if([self enableMakeupExtendButtonInAttendanceMenu]){
        [actionarray addObject:@"Send Parent Note"];
    }
    
    if([self enableMessageButtonInAttendanceMenu]){
        [actionarray addObject:@"Send Message"];
    }
    
    [actionarray addObject:@"Delete Classes"];
    [actionarray addObject:@"Postpone Classes"];
    
    if(validateclassarray.count>0 && [self isConflictClassesSelected]){
        [actionarray addObject:@"Override Conflicts"];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init]  DataType:@"ClassAction" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(200, actionarray.count*44) View:self Button:sender ItemsArray:actionarray Title:nil];
}

-(BOOL) isConflictClassesSelected
{
    ClassScheduleRecord *object;
    ClassValidateRecord *cvobj;
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        object=[selectededitattendanceclasskeyarray objectAtIndex:i];
        cvobj=[validateclassarray objectForKey:object.classkey];
        if (cvobj) {
            return TRUE;
        }
    }
    return FALSE;
}

- (IBAction)deselectallbuttonpressed:(id)sender {
    [selectededitattendanceclasskeyarray removeAllObjects];
    [ClassScheduleTable reloadData];
    [self updateEditAttendanceMenu];
}

- (IBAction)selectallbuttonpressed:(id)sender {
    [selectededitattendanceclasskeyarray removeAllObjects];
    for (int i=0; i<filteredClassScheduleRecordArray.count; i++) {
        [selectededitattendanceclasskeyarray addObject:[filteredClassScheduleRecordArray objectAtIndex:i]];
    }
    
    [ClassScheduleTable reloadData];
    [self updateEditAttendanceMenu];
}

-(void) showTable
{
    if ([viewmode isEqualToString:@"class"]) {
        classViewLeadingConstraint.constant=0;
    }else{
        classViewLeadingConstraint.constant=self.view.frame.size.width*0.32+1;
    }
}

-(void) returnfilterdailyclassschedulearray
{
    //NSMutableArray *result;
    
    [self showTable];
    
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];

    if (![classroomselected isEqualToString:@"All"]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.realclassroom = %@", classroomselected];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (![subjectselected isEqualToString:@"All"]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.subject = %@", subjectselected];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (![instructorselected isEqualToString:@"All"]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.instructorfullname = %@", [MyClass returnstaffnamewithusername:instructorselected firstorfullname:@"full"]];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (![classtypeselected isEqualToString:@"All"]) {
        if ([classtypeselected isEqualToString:@"Attending"]) {
            newCondition = [NSPredicate predicateWithFormat:@"(self.classtype !=%@ and self.attendance!=%@ and self.attendance!=%@ and self.attendance!=%@) or (self.classtype=%@ and self.makeupattendance !=%@)",@"Makeup",@"Absent",@"Makeup",@"Extend",@"Makeup",@"Absent"];
            [nsPredicatearray addObject:newCondition];
        }else if ([classtypeselected isEqualToString:@"Absent"]){
            newCondition = [NSPredicate predicateWithFormat:@"(self.classtype !=%@ and (self.attendance=%@ or self.attendance=%@ or self.attendance=%@)) or (self.classtype=%@ and self.makeupattendance =%@)",@"Makeup",@"Absent",@"Makeup",@"Extend",@"Makeup",@"Absent"];
            [nsPredicatearray addObject:newCondition];
        }else{
            newCondition = [NSPredicate predicateWithFormat:@"self.classtype contains[c] %@", classtypeselected];
            [nsPredicatearray addObject:newCondition];
        }
    }
    
    
    if (![search_text.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithFormat:@"SELF.studentdisplayname contains[c] %@ or self.parentcontact contains[c] %@ or self.subject contains[c] %@ or self.levelmain contains[c] %@ or self.realclasstime contains[c] %@ or self.instructorfullname contains[c] %@ or self.realclassroom contains[c] %@ or self.remarks contains[c] %@ or self.allclassremarks contains[c] %@ or self.subjectfullname contains[c] %@ or self.makeupclassroom contains[c] %@ or self.absentmakeupreason contains[c] %@ or self.studentid contains[c] %@",search_text.text,search_text.text,search_text.text,search_text.text,search_text.text,search_text.text,search_text.text,search_text.text,search_text.text,search_text.text,search_text.text,search_text.text,search_text.text];
        [nsPredicatearray addObject:newCondition];
        
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredClassScheduleRecordArray= [[NSMutableArray alloc]initWithArray:[ClassScheduleRecordArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredClassScheduleRecordArray= [[NSMutableArray alloc]initWithArray:ClassScheduleRecordArray];
    }
    
    [self sortdailyclassschedulelist];
}

-(void) updatesearchtext
{
    [self returnfilterdailyclassschedulearray];
    
    //[ClassScheduleTable reloadData];
    [ClassScheduleTable setContentOffset:CGPointZero animated:YES];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return 1;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==ClassSelectionTable){
        return SubjectSelectionArray.count;
    }else if (tableView==ClassTypeSelectionTable){
        return ClassTypeArray.count;
    }else if (tableView==InstructorSelectionTable){
        return InstructorSelectionArray.count;
    }else if (tableView==ClassroomSelectionTable){
        return ClassroomSelectionArray.count;
    }else if (tableView==ClassScheduleTable){
        return filteredClassScheduleRecordArray.count;
        //return ((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:section]).classScheduleRecordArray.count;
        //return ClassScheduleRecordArray.count;
    }else if (tableView==LessonTable){
        return LessonClassRecordArray.count;
    }else if (tableView==sortingtable) {
        return sortingarray.count;
    }else if (tableView==AttendanceTable){
        return attendancearray.count;
    }else if (tableView==scanhistorytable){
        return scanhistoryarray.count;
    }else{
        return 100000;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (tableView==sortingtable){
        return [MyClass returntitlewithtitle:@"Sorting Order"];
    }else if (tableView==scanhistorytable){
        return [MyClass returntitlewithtitle:@"Scan History"];
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==ClassScheduleTable || tableView==LessonTable) {
        return UITableViewAutomaticDimension;
    }else if (tableView==datebartable){
        return 100;
    }else if (tableView==sortingtable) {
        return 38;
    }else if (tableView==scanhistorytable) {
        return 60;
    }else{
        return 38;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (tableView==ClassScheduleTable) {
        return cellheight;
    }else if (tableView==datebartable){
            return 100;
    }else if (tableView==sortingtable) {
        return 38;
    }else if (tableView==scanhistorytable) {
        return 60;
    }else{
        return 38;
    }
}

-(NSString *) returnLessonKeyWithLessonRecord:(LessonRecord *)record
{
    return [NSString stringWithFormat:@"%@%@%@%@%@%@%@",record.classdate,record.classtime,record.subject,record.instructor,record.classroom,globalvariables.centerrecord.secondaryinstructor?record.sinstructor:@"",record.classduration];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==LessonTable) {
        //[validateclassarray removeAllObjects];
        filteredClassScheduleRecordArray=[[NSMutableArray alloc]initWithArray:((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:indexPath.row]).classScheduleRecordArray];
        NSString *newselectedLessonKey=[self returnLessonKeyWithLessonRecord:((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:indexPath.row]).lesson];
        if (![newselectedLessonKey isEqualToString:selectedLessonKey]) {
            //[MyClass showTableColumnWithTableView:ClassScheduleTable ColumnIdentifier:@"Warning" Show:NO];
        }
        selectedLessonKey=newselectedLessonKey;
        
        [LessonTable reloadData];
        [ClassScheduleTable reloadData];
    }else if (tableView==ClassScheduleTable) {
        if (!attendanceringview) {
            //ClassScheduleObject=[((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:indexPath.section]).classScheduleRecordArray objectAtIndex:indexPath.row];
            
            ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:indexPath.row];
            
            if (editattendanceviewopened) {
                if ([selectededitattendanceclasskeyarray containsObject:ClassScheduleObject]) {
                    [selectededitattendanceclasskeyarray removeObject:ClassScheduleObject];
                }else{
                    [selectededitattendanceclasskeyarray addObject:ClassScheduleObject];
                }

                [ClassScheduleTable reloadData];
                
                [self updateEditAttendanceMenu];
            }else{
                //Popup remarks
                if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
                    [self startsidewindowanimationwithwidth:320];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        DTAddEditViewController *dtpopover = (DTAddEditViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"DTAddEditViewController"];
                        dtpopover.DTAddEditViewDTkey=ClassScheduleObject.dtkey;
                        dtpopover.PopoverMode=@"PopoverDTFromClassSchedule";
                        dtpopover.DTTableMode=@"View";
                        dtpopover.delegate=self;
                        
                        dtpopover.subjectArray=[MyClass retrievesubjectinformationwithstatus:@"Active" category:@"All" flushcachedata:YES];
                        if (!dtpopover.subjectArray) {
                            return;
                        }
                        
                        dtpopover.view.frame=mainWindow.bounds;
                        [sidewindowview addSubview:dtpopover.view];
                        [self addChildViewController:dtpopover];
                        [dtpopover didMoveToParentViewController:self];
                        [ailoadindicator stopAnimating];
                        ailoadindicator.hidden=YES;
                    });
                    
                }else{
                    //popup make up information
                    [self startsidewindowanimationwithwidth:480];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        ClassRemarksPopoverViewController *remarksuppopover = (ClassRemarksPopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"ClassRemarksPopoverViewController"];
                        remarksuppopover.delegate=self;
                        remarksuppopover.presentingview=@"dailyclassschedule";
                        remarksuppopover.classScheduleObject=ClassScheduleObject;
                        remarksuppopover.preferredContentSize=CGSizeMake(480, self.view.frame.size.height);
                        
                        /*if(![remarksuppopover retrievenextclassremarks]){
                            [MyClass showconnectionlostdialogbox];
                            return;
                        }*/
                        
                        remarksuppopover.view.frame=mainWindow.bounds;
                        [sidewindowview addSubview:remarksuppopover.view];
                        [self addChildViewController:remarksuppopover];
                        [remarksuppopover didMoveToParentViewController:self];
                        [ailoadindicator stopAnimating];
                        ailoadindicator.hidden=YES;
                    });
                }
            }
        }
        

    }else if (tableView==ClassSelectionTable){
        [self drawsubjectpointerwithoption:@"closed"];
        subjectselected=indexPath.row==0?@"All":[SubjectSelectionArray objectAtIndex:indexPath.row];
        [ClassSelectionButton setTitle:[MyClass returnsubjectnamewithsubject_shortname:[SubjectSelectionArray objectAtIndex:indexPath.row] centerkey:globalvariables.centerrecord.centerkey] forState:UIControlStateNormal];
        
        
        [[myClassSelectionPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];

        
        [self returnfilterdailyclassschedulearray];
        
    }else if (tableView==InstructorSelectionTable){
        [self drawinstructorpointerwithoption:@"closed"];
        if(indexPath.row==0){
            instructorselected=@"All";
            [InstructorSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Instructors"] forState:UIControlStateNormal];
        }else{
            instructorselected=((Instructor *)[InstructorSelectionArray objectAtIndex:indexPath.row]).username;
            [InstructorSelectionButton setTitle:[((Instructor *)[InstructorSelectionArray objectAtIndex:indexPath.row]).firstname isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:((Instructor *)[InstructorSelectionArray objectAtIndex:indexPath.row]).username firstorfullname:@"full"] forState:UIControlStateNormal];
        }
        
        
        
        [self returnfilterdailyclassschedulearray];
        
        
        [[myInstructorSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];

    }else if (tableView==ClassroomSelectionTable){
        [self drawclassroompointerwithoption:@"closed"];
        classroomselected=indexPath.row==0?@"All":[ClassroomSelectionArray objectAtIndex:indexPath.row];
        
        [[myClassroomSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        [ClassroomSelectionButton setTitle:[[ClassroomSelectionArray objectAtIndex:indexPath.row] isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[ClassroomSelectionArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];

        
        [self returnfilterdailyclassschedulearray];

        
    }else if (tableView==ClassTypeSelectionTable){
        [self drawclasstypepointerwithoption:@"closed"];
        classtypeselected=indexPath.row==0?@"All":[ClassTypeArray objectAtIndex:indexPath.row];
        [ClassTypeSelectionButton setTitle:[MyClass returntitlewithtitle:[ClassTypeArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
        
        [[myClassTypeSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        
        [self returnfilterdailyclassschedulearray];

    }else if (tableView==datebartable){
        
        if ([MyClass isWorkingDate:[MyClass convertToNSDateWithDate:[MyClass returnDateFromBaseDateWithOffset:indexPath.row] DateFormat:@"dd-MMM-yyyy"] includereserveddate:YES]) {
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self retrieveClassScheduleWithclassdate:[MyClass returnDateFromBaseDateWithOffset:indexPath.row]]){
                    selecteddate=[MyClass returnDateFromBaseDateWithOffset:indexPath.row];
                    [self showbarcodescanner];
                    [datebartable reloadData];
                    
                }
            });
        }/*else{
            [datebartable selectRowAtIndexPath:[NSIndexPath indexPathForRow:[MyClass returnDateOffsetWithDate:[MyClass convertToNSDateWithDate:selecteddate DateFormat:@"dd-MMM-yyyy"]] inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }*/
    }else if (tableView==AttendanceTable){
        [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Attendance"] message:[MyClass returntitlewithtitle:@"Are you sure to change the attendance status for the selected items?"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self updatebulkattendancewithstatus:((AttendanceButtonObject *)[attendancearray objectAtIndex:indexPath.row]).buttonname validationCheck:YES];
                [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
            });
        }];
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }];
        
        [changealert addAction:OKAction];
        [changealert addAction:CancelAction];
        
        [[MyClass topMostController] presentViewController:changealert animated:YES completion:nil];
        
        

    }
}

-(void) loadMessageRecipient
{
    allstudentarray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];
    allleadarray=[[NSMutableArray alloc]initWithArray:[globalvariables.leadlistarray allValues]];
    allstaffarray=[[NSMutableArray alloc]initWithArray:[globalvariables.stafflistarray allValues]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@",globalvariables.centerrecord.centerkey];
    allstudentarray=[[NSMutableArray alloc]initWithArray:[allstudentarray filteredArrayUsingPredicate:predicate]];
    allleadarray=[[NSMutableArray alloc]initWithArray:[allleadarray filteredArrayUsingPredicate:predicate]];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@ and self.status contains[c] %@ and self.role!=%@",globalvariables.centerrecord.centerkey,@"Yes",@"System"];
    allstaffarray=[[NSMutableArray alloc]initWithArray:[allstaffarray filteredArrayUsingPredicate:predicate2]];
    
    allstudentarray = [NSMutableArray arrayWithArray:[allstudentarray sortedArrayUsingDescriptors:[MyClass returnstudentnamesortdescriptorarray]]];
    allleadarray = [NSMutableArray arrayWithArray:[allleadarray sortedArrayUsingDescriptors:[MyClass returnleadnamesortdescriptorarray]]];
    
    NSSortDescriptor *sortbyfirstname = [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortbylastname = [NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[sortbyfirstname,sortbylastname];
    allstaffarray = [NSMutableArray arrayWithArray:[allstaffarray sortedArrayUsingDescriptors:sortDescriptors]];
}

-(NSMutableArray *) getStudentOrLeadkeysForMessage
{
    NSMutableArray *studentkeys=[[NSMutableArray alloc]init];
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        ClassScheduleRecord *object=[selectededitattendanceclasskeyarray objectAtIndex:i];
        //if ([object.type isEqualToString:@"student"]) {
            [studentkeys addObject:object.studentkey];
        //}
    }
    return studentkeys;
}

-(NSMutableArray *) getClasskeysForParentNote
{
    NSMutableArray *classkeys=[[NSMutableArray alloc]init];
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        ClassScheduleRecord *object=[selectededitattendanceclasskeyarray objectAtIndex:i];
        if ([object.type isEqualToString:@"student"]) {
            NSMutableDictionary *studentclasskeydict=[[NSMutableDictionary alloc]init];
            [studentclasskeydict setValue:object.classkey forKey:@"classkey"];
            [studentclasskeydict setValue:object.studentkey forKey:@"studentkey"];
            [classkeys addObject:studentclasskeydict];
        }
    }
    return classkeys;
}

-(void) dismissMessagePopoverVC
{
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    [self closesidewindow];
    if (editattendanceviewopened) {
        [self canceleditattendancebuttonpressed];
    }
}

-(void) returnClassCountWithLessonAndClassRecord:(LessonAndClassRecord *)record attendinglabel:(UILabel *)attendinglabel nonattendinglabel:(UILabel *)nonattendinglabel
{
    long attendingcount=0;
    long nonattendingcount=0;
    ClassScheduleRecord *classobject;
    
    for (int i=0; i<record.classScheduleRecordArray.count; i++) {
        classobject=[record.classScheduleRecordArray objectAtIndex:i];
        if ([classobject.classtype isEqualToString:@"Makeup"]) {
            if([classobject.makeupattendance isEqualToString:@""] || [classobject.makeupattendance isEqualToString:@"Present"]){
                attendingcount+=1;
            }else{
                nonattendingcount+=1;
            }
        }else{
            if ([classobject.attendance isEqualToString:@""] || [classobject.attendance isEqualToString:@"Present"]) {
                attendingcount+=1;
            }else{
                nonattendingcount+=1;
            }
        }
    }
    
    attendinglabel.text=[NSString stringWithFormat:@"%ld",attendingcount];
    nonattendinglabel.text=[NSString stringWithFormat:@"%ld",nonattendingcount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==LessonTable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"lessoncell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        LessonAndClassRecord *lessonandclassobj=[LessonClassRecordArray objectAtIndex:indexPath.row];
        LessonRecord *object=lessonandclassobj.lesson;
        
        if([object.subjecttype isEqualToString:@"subject"]){
            cell.label1.text=[MyClass returnsubjectnamewithsubject_shortname:object.subject centerkey:globalvariables.centerrecord.centerkey];

        }else{
            cell.label1.text=[MyClass returnsubjectcategorynamewithscategorykey:object.subject];
        }
        cell.view3.backgroundColor=[MyClass returnSubjectColorWithSubject:object.subject];
        
        cell.label2.text=[NSString stringWithFormat:@"%@ (%@)",[MyClass returnClassPeriodWithStartTime:object.classtime duration:object.classduration] ,[NSString stringWithFormat:@"%@%@",object.classduration,[MyClass returntitlewithtitle:@"mins"]]];
        cell.label3.text=[object.instructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:object.instructor firstorfullname:@"first"];
        cell.view1.backgroundColor=[MyClass returnInstructorColorWithUsername:object.instructor];
        cell.label4.text=[object.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:object.classroom;
        
        if(globalvariables.centerrecord.secondaryinstructor){
            cell.label7.text=[MyClass returninstructornamewithusername:object.sinstructor firstorfullname:@"first"];
            cell.view2.backgroundColor=[MyClass returnInstructorColorWithUsername:object.sinstructor];
            cell.view2.hidden=[object.sinstructor isEqualToString:@""] || [object.sinstructor isEqualToString:@"TBD"];
        }else{
            cell.view2.hidden=YES;
        }
        [self returnClassCountWithLessonAndClassRecord:[LessonClassRecordArray objectAtIndex:indexPath.row] attendinglabel:cell.label5 nonattendinglabel:cell.label6];
        
        [cell.button1 addTarget:self action:@selector(editlessonbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.button1.tag=indexPath.row;
        cell.button1.enabled=![MyClass lockLessonWithClassScheduleRecord:ClassScheduleRecordArray];
        
        float minute=[[object.classtime substringFromIndex:3] floatValue];
        float hour=[[object.classtime substringToIndex:2] intValue] % 12;
        
        float hourangle=(hour/12+minute/60/12)*360*M_PI/180;
        float minuteangle=minute/60*360*M_PI/180;
        
        if([[object.classtime substringToIndex:2] intValue]<12){
            cell.imageview1.hidden=NO;
            cell.imageview2.hidden=NO;
            cell.imageview3.hidden=YES;
            cell.imageview4.hidden=YES;
            cell.imageview1.transform = CGAffineTransformMakeRotation(hourangle);
            cell.imageview2.transform = CGAffineTransformMakeRotation(minuteangle);
        }else{
            cell.imageview1.hidden=YES;
            cell.imageview2.hidden=YES;
            cell.imageview3.hidden=NO;
            cell.imageview4.hidden=NO;
            cell.imageview3.transform = CGAffineTransformMakeRotation(hourangle);
            cell.imageview4.transform = CGAffineTransformMakeRotation(minuteangle);
        }
        
        cell.label8
            .hidden=![MyClass showLessonParameterWithSubject:object.subject];
        if(!cell.label8.hidden){
            cell.label8.text=[MyClass returnLessonDescriptionWithClassScheduleRecords:lessonandclassobj.classScheduleRecordArray];
        }
        
        
        if (indexPath.row==[self returnLessonIndex]) {
            cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.22];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        return cell;
    
    }else if (tableView == ClassScheduleTable) {
        
        MyTableViewCell *cell;
        static NSString *CellIdentifier;
        if(editattendanceviewopened){
            CellIdentifier=@"classcell1";
        }else{
            CellIdentifier=@"classcell0";
        }

        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:indexPath.row];

        //duration
        cell.label2.text=[NSString stringWithFormat:@"%@%@",ClassScheduleObject.classduration,[MyClass returntitlewithtitle:@"mins"]];
        
        //class type
        cell.label3.text=[MyClass returntitlewithtitle:[ClassScheduleObject.classtype isEqualToString:@"Assessment"]?@"Assess":ClassScheduleObject.classtype];
        if ([ClassScheduleObject.classtype isEqualToString:@"Class"]) {
            cell.label3.textColor=[UIColor darkTextColor];
        }else if ([ClassScheduleObject.classtype isEqualToString:@"Makeup"]) {
            cell.label3.textColor=[UIColor orangeColor];
        }else if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
            cell.label3.textColor=[UIColor redColor];
        }
        

        cell.label4.hidden=NO;
        cell.label19.hidden=YES;
            
        
        //student name
        if ([ClassScheduleObject.type isEqualToString:@"student"]) {
            cell.label5.text=[MyClass returnStudentnameWithStudentkey:ClassScheduleObject.studentkey option:@"full"];
        }else{
            cell.label5.text=[MyClass returnLeadnameWithLeadkey:ClassScheduleObject.studentkey option:@"full"];
        }
        
        //student image and warning button
        if([self moveLessonFailedWithClasskey:ClassScheduleObject]){
            cell.imageview8.hidden=YES;
            cell.imageview12.hidden=YES;
            [cell.button4 addTarget:self action:@selector(warningbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.button4.tag=indexPath.row;
        }else{
            cell.imageview8.hidden=NO;
            cell.imageview12.hidden=NO;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
            singleTap.numberOfTapsRequired = 1;
            cell.imageview8.layer.cornerRadius=14.5f;
            cell.imageview8.layer.masksToBounds=YES;
            cell.imageview8.userInteractionEnabled = YES;
            [cell.imageview8 addGestureRecognizer:singleTap];
            cell.imageview8.tag=indexPath.row;
            [MyClass downloadImageWithImageview:cell.imageview8 gender:ClassScheduleObject.gender type:ClassScheduleObject.type typekey:ClassScheduleObject.studentkey image:ClassScheduleObject.image async:YES];
            
            if ([ClassScheduleObject.type isEqualToString:@"student"]) {
                Student *studentObject=[MyClass retrieveStudent:ClassScheduleObject.studentkey];
                if([studentObject.due isEqualToString:@"B"]){
                    [cell.imageview12 setImage:[UIImage imageNamed:@"redpurple.png"]];
                }else if([studentObject.due isEqualToString:@"C"]){
                    [cell.imageview12 setImage:[UIImage imageNamed:@"red_background.png"]];
                }else if([studentObject.due isEqualToString:@"S"]){
                    [cell.imageview12 setImage:[UIImage imageNamed:@"purple_background.png"]];
                }else{
                    [cell.imageview12 setImage:nil];
                }
            }else{
                [cell.imageview12 setImage:nil];
            }
        }
        
        //parent contact
        //cell.label9.text=ClassScheduleObject.parentcontact;
        
        if (![ClassScheduleObject.parentcontact isEqualToString:@""] && (((PrivilegeRecord *)[MyClass returnprivilegerecordwithprivilegekey:userprivilege.privilegekey]).viewcontactindailyschedule)) {
            ContactRecord *record=[MyClass returnprimarycontactwithtype:ClassScheduleObject.type typekey:ClassScheduleObject.studentkey];
            if (record) {
                cell.label9.text=[MyClass returnLocalNumberWithContact:record.contact ISOCode:record.iso_code];
                [MyClass downloadImageWithImageview:cell.imageview13 gender:nil type:@"flag" typekey:record.iso_code image:@"Yes" async:YES];
                cell.imageview13.hidden=NO;
            }else{
                cell.label9.text = ClassScheduleObject.parentcontact;
                cell.imageview13.hidden=YES;
            }
        }else{
            cell.label9.text=@"";
            cell.imageview13.hidden=YES;
        }
        
        //class left
        cell.imageview2.layer.cornerRadius=4;
        cell.imageview2.layer.masksToBounds=YES;
        cell.imageview3.layer.cornerRadius=4;
        cell.imageview3.layer.masksToBounds=YES;
        cell.imageview4.layer.cornerRadius=4;
        cell.imageview4.layer.masksToBounds=YES;
        
        cell.label13.layer.cornerRadius=4;
        cell.label13.layer.masksToBounds=YES;
        cell.label14.layer.cornerRadius=4;
        cell.label14.layer.masksToBounds=YES;
        cell.label15.layer.cornerRadius=4;
        cell.label15.layer.masksToBounds=YES;
        
        if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
            cell.label13.text=@"";
            cell.label14.text=@"";
            cell.label15.text=@"";
            
            cell.label13.layer.borderWidth=0;
            cell.label13.layer.borderColor=[UIColor clearColor].CGColor;
            
            [cell.imageview2 setImage:nil];
            [cell.imageview3 setImage:nil];
            [cell.imageview4 setImage:nil];
            
        }else{
            cell.label13.layer.borderWidth=0;
            cell.label13.layer.borderColor=[UIColor clearColor].CGColor;
            cell.label13.text=ClassScheduleObject.remainingclassscheduled;
            if ([ClassScheduleObject.remainingclassscheduled intValue]==0) {
                if ([ClassScheduleObject.remainingclassscheduledall intValue]==0) {
                    [cell.imageview2 setImage:[UIImage imageNamed:@"red_background.png"]];
                    cell.label13.layer.borderWidth=0;
                    cell.label13.layer.borderColor=[UIColor clearColor].CGColor;
                }else{
                    cell.label13.layer.borderWidth=1.5;
                    cell.label13.layer.borderColor=[UIColor redColor].CGColor;
                    [cell.imageview2 setImage:[UIImage imageNamed:@"gray_background.png"]];
                    
                }
            }else if ([ClassScheduleObject.remainingclassscheduled intValue]==1) {
                [cell.imageview2 setImage:[UIImage imageNamed:@"orange_background.png"]];
            }else{
                [cell.imageview2 setImage:[UIImage imageNamed:@"gray_background.png"]];
            }
            cell.label14.text=ClassScheduleObject.remainingclassTBDclass;
            cell.label15.text=ClassScheduleObject.remainingclassTBDmakeup;
            [cell.imageview3 setImage:[UIImage imageNamed:@"gray_background.png"]];
            [cell.imageview4 setImage:[UIImage imageNamed:@"gray_background.png"]];
        }
        
        
        //outstanding due
        if ([ClassScheduleObject.outstandingpayment intValue]==0) {
            cell.button1.hidden=YES;
        }else{
            cell.button1.layer.cornerRadius=4;
            cell.button1.layer.masksToBounds=YES;
            cell.button1.layer.opacity=0.8;
            [cell.button1 addTarget:self action:@selector(outstandingpaymentbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.button1.tag=indexPath.row;
            [cell.button1 setTitle:[NSString stringWithFormat:@"$%@",ClassScheduleObject.outstandingpayment] forState:UIControlStateNormal];
            cell.button1.hidden=NO;
        }
        
        //outstanding extension time
        if ([ClassScheduleObject.outstandingextendtime intValue]==0) {
            cell.label16.text=@"";
            cell.imageview7.hidden=YES;
        }else{
            cell.label16.text=ClassScheduleObject.outstandingextendtime;
            cell.imageview7.layer.cornerRadius=4;
            [cell.imageview7 setImage:[UIImage imageNamed:@"blue_background.png"]];
            cell.imageview7.layer.masksToBounds=YES;
            cell.imageview7.hidden=NO;
        }
        
        //parent note
        cell.imageview10.hidden=[ClassScheduleObject.parentnote isEqualToString:@""];
        
        //time, subject, instructor, room, remarks, extension time
        if ([ClassScheduleObject.classtype isEqualToString:@"Makeup"]) {
            cell.view1.hidden=YES;
            cell.stackview1.hidden=NO;
            
            NSString *schedulename=[MyClass returnschedulenamewithsubject_shortname:ClassScheduleObject.subject schedulekey:ClassScheduleObject.schedulekey centerkey:globalvariables.centerrecord.centerkey];
            cell.label6.text=ClassScheduleObject.subjectfullname;
            cell.constraint3.constant=dailyscheduleshowsubjectcolor?3:0;
            cell.view5.backgroundColor=dailyscheduleshowsubjectcolor?[MyClass returnSubjectColorWithSubject:ClassScheduleObject.subject]:[UIColor clearColor];
            cell.imageview14.hidden=YES;
            if (![schedulename isEqualToString:[MyClass returntitlewithtitle:@"Unknown"]]) {
                cell.label6.text=[NSString stringWithFormat:@"%@ (%@)",cell.label6.text,schedulename];
            }
            
            
            cell.label1.text=ClassScheduleObject.makeuptime;
            
            cell.label7.text= [ClassScheduleObject.makeupinstructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:ClassScheduleObject.makeupinstructor firstorfullname:@"first"];
            cell.constraint1.constant=dailyscheduleshowinstructorcolor?3:0;
            [cell.view3 setBackgroundColor:dailyscheduleshowinstructorcolor?[MyClass returnInstructorColorWithUsername:ClassScheduleObject.makeupinstructor]:[UIColor clearColor]];
            cell.label8.text=[ClassScheduleObject.makeupclassroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:ClassScheduleObject.makeupclassroom;
            
            if(globalvariables.centerrecord.secondaryinstructor){
                cell.label20.text= [ClassScheduleObject.makeupsinstructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:ClassScheduleObject.makeupsinstructor firstorfullname:@"first"];
                cell.constraint2.constant=dailyscheduleshowinstructorcolor?3:0;
                [cell.view4 setBackgroundColor:dailyscheduleshowinstructorcolor?[MyClass returnInstructorColorWithUsername:ClassScheduleObject.makeupsinstructor]:[UIColor clearColor]];
                cell.view4.hidden=[ClassScheduleObject.makeupsinstructor isEqualToString:@"TBD"] || [ClassScheduleObject.makeupsinstructor isEqualToString:@""];
            }else{
                cell.view4.hidden=YES;
            }
            
            NSMutableArray *tmpremarks=[[NSMutableArray alloc]init];
            
            if ([MyClass isDateFallsThisYear:[MyClass convertToNSDateWithDate:ClassScheduleObject.startdate DateFormat:@"dd-MMM-yyyy"]]) {
                [tmpremarks addObject:[MyClass returnreplacedtitlewithtitle:@"(Original class on %@1)" replacementarray:@[[NSString stringWithFormat:@"%@ %@ %@",[MyClass returndateformatDDMMMwithdate:[MyClass convertDDMMMYYYYtoDDMMMwithdate:ClassScheduleObject.startdate]],ClassScheduleObject.classtime,ClassScheduleObject.classday]]]];
            }else{
                [tmpremarks addObject:[MyClass returnreplacedtitlewithtitle:@"(Original class on %@1)" replacementarray:@[[NSString stringWithFormat:@"%@ %@ %@",[MyClass returndateformatwithdate:[MyClass convertDDMMMYYYYtoDDMMMYYYY2withdate:ClassScheduleObject.startdate]],ClassScheduleObject.classtime,ClassScheduleObject.classday]]]];
            }
            
            if (![ClassScheduleObject.parentnote isEqualToString:@""]) {
                [tmpremarks addObject:[NSString stringWithFormat:@"<%@>",ClassScheduleObject.parentnote]];
            }
            
            if (![ClassScheduleObject.remarks isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.remarks];
            }
            
            if (![ClassScheduleObject.allclassremarks isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.allclassremarks];
            }
            
            if (![ClassScheduleObject.absentmakeupreason isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.absentmakeupreason];
            }
            
            if (![ClassScheduleObject.makeupdate isEqualToString:@""]) {
                
                if ([ClassScheduleObject.lastscheduledclassalldaytime isEqualToString:[NSString stringWithFormat:@"%@ %@",[ClassScheduleObject.makeupdate substringToIndex:6], ClassScheduleObject.classtime]]){
                    
                    if ([ClassScheduleObject.remainingclassTBDclass intValue]+[ClassScheduleObject.remainingclassTBDmakeup intValue]>0) {
                        [tmpremarks insertObject:[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"Last scheduled class"]] atIndex:0];
                    }else{
                        [tmpremarks insertObject:[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"Last_class"]] atIndex:0];
                    }
                }
                
                if ([ClassScheduleObject.firstclass isEqualToString:[NSString stringWithFormat:@"%@ %@",[ClassScheduleObject.makeupdate substringToIndex:6],ClassScheduleObject.classtime]]) {
                    [tmpremarks insertObject:[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"First_class"]] atIndex:0];
                }
            }
            
            cell.label10.text=[tmpremarks componentsJoinedByString:@"; "];;
            
            ///switchMakeup.hidden=YES;
            cell.button2.hidden=YES;
            cell.label11.text=@"";
            cell.imageview11.hidden=YES;
            
        }else if ([ClassScheduleObject.classtype isEqualToString:@"Class"]){
            
            NSString *schedulename=[MyClass returnschedulenamewithsubject_shortname:ClassScheduleObject.subject schedulekey:ClassScheduleObject.schedulekey centerkey:globalvariables.centerrecord.centerkey];
            cell.label6.text=[MyClass returnsubjectnamewithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey];
            cell.constraint3.constant=dailyscheduleshowsubjectcolor?3:0;
            cell.view5.backgroundColor=dailyscheduleshowsubjectcolor?[MyClass returnSubjectColorWithSubject:ClassScheduleObject.subject]:[UIColor clearColor];
            cell.imageview14.hidden=YES;
            if (![schedulename isEqualToString:[MyClass returntitlewithtitle:@"Unknown"]]) {
                cell.label6.text=[NSString stringWithFormat:@"%@ (%@)",cell.label6.text,schedulename];
            }
            
            cell.label1.text = ClassScheduleObject.classtime;
            cell.label7.text = [MyClass returninstructornamewithusername:ClassScheduleObject.instructor firstorfullname:@"first"];
            cell.constraint1.constant=dailyscheduleshowinstructorcolor?3:0;
            [cell.view3 setBackgroundColor:dailyscheduleshowinstructorcolor?[MyClass returnInstructorColorWithUsername:ClassScheduleObject.instructor]:[UIColor clearColor]];
            cell.label8.text=[ClassScheduleObject.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:ClassScheduleObject.classroom;
            
            if(globalvariables.centerrecord.secondaryinstructor){
                cell.label20.text= [MyClass returninstructornamewithusername:ClassScheduleObject.sinstructor firstorfullname:@"first"];
                cell.constraint2.constant=dailyscheduleshowinstructorcolor?3:0;
                [cell.view4 setBackgroundColor:dailyscheduleshowinstructorcolor?[MyClass returnInstructorColorWithUsername:ClassScheduleObject.sinstructor]:[UIColor clearColor]];
                cell.view4.hidden=[ClassScheduleObject.sinstructor isEqualToString:@"TBD"] || [ClassScheduleObject.sinstructor isEqualToString:@""];
            }else{
                cell.view4.hidden=YES;
            }
            

            
            if ([ClassScheduleObject.attendance isEqualToString:@"Makeup"]) {
                cell.view1.hidden=YES;
                cell.stackview1.hidden=NO;
                cell.button2.hidden=NO;
                [cell.button2 addTarget: self action:@selector(makeupdatetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                cell.button2.tag=indexPath.row;
                cell.button2.enabled=![MyClass classLocked:ClassScheduleObject.locked];
                if (![ClassScheduleObject.makeupdate isEqualToString:@""] && ![ClassScheduleObject.makeupdate isEqualToString:@"TBD"]) {
                    [cell.button2 setTitle:[NSString stringWithFormat:@"%@ %@",[globalvariables.language isEqualToString:@"English"]?[ClassScheduleObject.makeupdate substringToIndex:6]:[[MyClass returndateformatwithdate:ClassScheduleObject.makeupdate] substringFromIndex:5],ClassScheduleObject.makeuptime] forState:UIControlStateNormal];
                    if ([ClassScheduleObject.makeupdate isEqualToString:@""] || [ClassScheduleObject.makeuptime isEqualToString:@""] || [ClassScheduleObject.makeupinstructor isEqualToString:@""]||[ClassScheduleObject.makeupinstructor isEqualToString:@"TBD"]) {
                        [cell.button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        [cell.button2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
                    }else{
                        [cell.button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                        [cell.button2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
                    }
                    
                    cell.label11.text=[ClassScheduleObject.makeupinstructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:ClassScheduleObject.makeupinstructor firstorfullname:@"first"];
                    cell.imageview11.hidden=NO;
                    [cell.imageview11 setImage:[UIImage imageNamed:[MyClass returnmakeupattendanceimagewithmakeupattendance:ClassScheduleObject.makeupattendance]]];
                    
                }else{
                    [cell.button2 setTitle:[MyClass returntitlewithtitle:@"Select time"] forState:UIControlStateNormal];
                    [cell.button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [cell.button2 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
                    cell.label11.text=@"";
                    cell.imageview11.hidden=YES;
                }
                

                
            }else if ([ClassScheduleObject.attendance isEqualToString:@"Extend"]){
                cell.view1.hidden=NO;
                cell.stackview1.hidden=YES;
                
                cell.view1.layer.cornerRadius=8;
                cell.view1.layer.masksToBounds=YES;
                [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_background.png"]]];
                cell.label18.text=ClassScheduleObject.extensiontime;
            }else{
                cell.view1.hidden=YES;
                cell.stackview1.hidden=NO;
                
                cell.button2.hidden=YES;
                //[MakeupDateTimeButton setTitle:@"" forState:UIControlStateNormal];
                cell.label11.text=@"";
                cell.label12.text=@"";
                cell.imageview11.hidden=YES;
            }
            NSMutableArray *tmpremarks=[[NSMutableArray alloc]init];
            
            if (![ClassScheduleObject.parentnote isEqualToString:@""]) {
                [tmpremarks addObject:[NSString stringWithFormat:@"<%@>",ClassScheduleObject.parentnote]];
            }
            
            if (![ClassScheduleObject.remarks isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.remarks];
            }
            
            if (![ClassScheduleObject.allclassremarks isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.allclassremarks];
            }
            
            if (![ClassScheduleObject.absentmakeupreason isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.absentmakeupreason];
            }
            
            
            if ([ClassScheduleObject.lastscheduledclassalldaytime isEqualToString:[NSString stringWithFormat:@"%@ %@",[ClassScheduleObject.startdate substringToIndex:6],ClassScheduleObject.classtime]]){
                
                if ([ClassScheduleObject.remainingclassTBDclass intValue]+[ClassScheduleObject.remainingclassTBDmakeup intValue]>0) {
                    [tmpremarks insertObject:[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"Last scheduled class"]] atIndex:0];
                }else{
                    [tmpremarks insertObject:[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"Last_class"]] atIndex:0];
                }
            }
            
            if ([ClassScheduleObject.firstclass isEqualToString:[NSString stringWithFormat:@"%@ %@",[ClassScheduleObject.startdate substringToIndex:6],ClassScheduleObject.classtime]]) {
                [tmpremarks insertObject:[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"First_class"]] atIndex:0];
            }
            
            
            cell.label10.text=[tmpremarks componentsJoinedByString:@"; "];
            
        }else if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]){
            cell.view1.hidden=YES;
            
            cell.label6.text=[MyClass returnsubjectnamewithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey];
            cell.constraint3.constant=dailyscheduleshowsubjectcolor?3:0;
            cell.view5.backgroundColor=dailyscheduleshowsubjectcolor?[MyClass returnSubjectColorWithSubject:ClassScheduleObject.subject]:[UIColor clearColor];
            cell.imageview14.hidden=YES;
            cell.label1.text = ClassScheduleObject.classtime;
            cell.label7.text = [MyClass returninstructornamewithusername:ClassScheduleObject.instructor firstorfullname:@"first"];
            [cell.view3 setBackgroundColor:dailyscheduleshowinstructorcolor?[MyClass returnInstructorColorWithUsername:ClassScheduleObject.instructor]:[UIColor clearColor]];
            cell.label8.text=[ClassScheduleObject.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:ClassScheduleObject.classroom;
            cell.button2.hidden=YES;
            cell.imageview11.hidden=YES;
            cell.view4.hidden=YES;
            
            cell.label11.text=@"";
            
            NSMutableArray *tmpremarks=[[NSMutableArray alloc]init];
            if (![ClassScheduleObject.remarks isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.remarks];
            }
            
            if (![ClassScheduleObject.absentmakeupreason isEqualToString:@""]) {
                [tmpremarks addObject:ClassScheduleObject.absentmakeupreason];
            }
            
            cell.label10.text=[tmpremarks componentsJoinedByString:@"; "];
        }
        
        
        //extended time
        if ([ClassScheduleObject.extendedminute intValue] !=0) {
            cell.label12.hidden=NO;
            cell.label12.text=[NSString stringWithFormat:@"+%@%@",ClassScheduleObject.extendedminute,[MyClass returntitlewithtitle:@"mins"]];
            if (!cell.button2.hidden) {
                cell.button2.titleLabel.font=[UIFont systemFontOfSize:10];
                //[MakeupDateTimeButton setTitleEdgeInsets:UIEdgeInsetsMake(1, 0, 0, 0)];
                //MakeupInstructorLabel.frame=CGRectMake(title_Class_MakeupDetails.frame.origin.x, 0, 117, cellheight);
                cell.label11.font=[UIFont systemFontOfSize:10];
                //ExtendedMinuteLabel.frame=CGRectMake(title_Class_MakeupDetails.frame.origin.x, cellheight/3*2, 117, cellheight/3);
                cell.label12.font=[UIFont systemFontOfSize:10];
            }else{
                //ExtendedMinuteLabel.frame=CGRectMake(title_Class_MakeupDetails.frame.origin.x, 0, 117, cellheight);
                cell.label12.font=[UIFont systemFontOfSize:13];
            }
        }else{
            if ([ClassScheduleObject.makeupdate isEqualToString:@""]) {
                cell.button2.titleLabel.font=[UIFont systemFontOfSize:12];
                //[MakeupDateTimeButton setTitleEdgeInsets:UIEdgeInsetsMake(13, 0, 0, 0)];
            }else{
                cell.button2.titleLabel.font=[UIFont systemFontOfSize:12];
                //[MakeupDateTimeButton setTitleEdgeInsets:UIEdgeInsetsMake(6, 0, 0, 0)];
            }
            //MakeupInstructorLabel.frame=CGRectMake(title_Class_MakeupDetails.frame.origin.x, 20, 117, cellheight/2);
            //ExtendedMinuteLabel.text=@"";
            cell.label12.hidden=YES;
        }
        
        //auto renew
        cell.imageview6.layer.cornerRadius=4;
        cell.imageview6.layer.masksToBounds=YES;
        cell.imageview6.hidden= ([ClassScheduleObject.autorenew isEqualToString:@"Yes"] && globalvariables.centerrecord.enableautobatchrenew)?NO:YES;
        
        //evaluation form
        if (!globalvariables.centerrecord.studentassessmentform || ClassScheduleObject.assessmentformcount==0 || ([ClassScheduleObject.classtype isEqualToString:@"Class"] && [ClassScheduleObject.attendance isEqualToString:@"Makeup"])) {
            cell.label17.hidden=YES;
            cell.imageview9.hidden=YES;
        }else{
            cell.label17.text=[NSString stringWithFormat:@"%i",ClassScheduleObject.assessmentformcount];
            cell.label17.hidden=NO;
            cell.imageview9.hidden=NO;
            cell.imageview9.layer.cornerRadius=4;
            cell.imageview9.layer.masksToBounds=YES;
        }
        
        //select icon

        
        if (editattendanceviewopened) {
            //cell.view2.hidden=NO;
            //cell.imageview5.hidden=NO;
            
            cell.imageview5.layer.cornerRadius=8;
            cell.imageview5.layer.borderColor=[UIColor whiteColor].CGColor;
            cell.imageview5.layer.borderWidth=1;
            
            if ([selectededitattendanceclasskeyarray containsObject:ClassScheduleObject]) {
                cell.imageview5.layer.opacity=1;
            }else{
                cell.imageview5.layer.opacity=0.3;
            }
        }
        
        //attendance button
        [cell.button3 setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
        [cell.button3 addTarget: self action:@selector(attendancebuttontouchupinside:) forControlEvents: UIControlEventTouchUpInside];
        [cell.button3 addTarget: self action:@selector(attendancebuttontouchdown:) forControlEvents: UIControlEventTouchDown];
        cell.button3.tag=indexPath.row;
        [cell.button3 setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:ClassScheduleObject.classtype attendance:ClassScheduleObject.attendance makeupattendance:ClassScheduleObject.makeupattendance]] forState:UIControlStateNormal];
        cell.button3.enabled=![MyClass classLocked:ClassScheduleObject.locked];
        
        if ([viewmode isEqualToString:@"lesson"]) {
            cell.label1.hidden=YES;
            cell.label2.hidden=YES;
            cell.label7.hidden=YES;
            cell.label8.hidden=YES;
            cell.view5.backgroundColor=[UIColor clearColor];
            cell.label6.text=[MyClass returnLevelGradeLessonwithClassScheduleRecord:ClassScheduleObject];
            cell.view6.hidden=YES;
            cell.label4.text=@"";
            if(indexPath.row%2==0){
                cell.backgroundColor=[UIColor whiteColor];
            }else{
                cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
            }
        }else{
            cell.label1.hidden=NO;
            cell.label2.hidden=NO;
            cell.label7.hidden=NO;
//            cell.stackview2.hidden=NO;
            cell.label8.hidden=NO;
            cell.label9.hidden=NO;
            cell.view6.hidden=NO;
            //cell.imageview13.hidden=NO;
            editattendancestatusimageview.frame=CGRectMake(15, (cellheight-16)/2, 16, 16);
            cell.label4.text=[MyClass returnLevelGradeLessonwithClassScheduleRecord:ClassScheduleObject];
            //alternative background color;
            if (cellcolorarray && cellcolorarray.count>0) {
                if ([[cellcolorarray objectAtIndex:indexPath.row] isEqualToString:@"0"]) {
                    cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
                }else{
                    cell.backgroundColor=[UIColor whiteColor];
                }
            }else{
                cell.backgroundColor=[UIColor whiteColor];
            }
            
        }
        
        
        
        cell.accessoryType=UITableViewCellAccessoryNone;
        
 
        return cell;
        
    }else if (tableView==ClassSelectionTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]init];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        
        if (indexPath.row==0) {
            GeneralLabel.text=[MyClass returntitlewithtitle:[SubjectSelectionArray objectAtIndex:indexPath.row]];
            GeneralLabel.frame=CGRectMake(0, 7, 260, 21);
            GeneralLabel.textAlignment=NSTextAlignmentCenter;
        }else{
            GeneralLabel.text=[SubjectSelectionArray objectAtIndex:indexPath.row];
            GeneralLabel.frame=CGRectMake(150, 7, 100, 21);
            GeneralLabel.textAlignment=NSTextAlignmentRight;
        }
        
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 170, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.adjustsFontSizeToFitWidth=YES;
        GeneralLabel.minimumScaleFactor=0.7;
        GeneralLabel.textColor=[UIColor darkGrayColor];
        if (indexPath.row>0) {
            if ([globalvariables.language isEqualToString:@"English"]) {
                GeneralLabel.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:[SubjectSelectionArray objectAtIndex:indexPath.row] centerkey:globalvariables.centerrecord.centerkey]).subject_englishname;
            }else{
                GeneralLabel.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:[SubjectSelectionArray objectAtIndex:indexPath.row] centerkey:globalvariables.centerrecord.centerkey]).subject_chinesename;
            }
            

        }else{
            GeneralLabel.text=@"";
        }
        
        //GeneralLabel.textAlignment=NSTextAlignmentRight;
        GeneralLabel.tag=302;
        [cell.contentView addSubview:GeneralLabel];
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 37, 260, 1)];
        GeneralLabel.backgroundColor=[UIColor lightGrayColor];
        GeneralLabel.alpha=0.3;
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;
    }else if (tableView==InstructorSelectionTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 260, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentCenter;
        if (indexPath.row==0) {
            GeneralLabel.text= ((Instructor *)[InstructorSelectionArray objectAtIndex:indexPath.row]).firstname;
        }else{
            GeneralLabel.text= [((Instructor *)[InstructorSelectionArray objectAtIndex:indexPath.row]).username isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:((Instructor *)[InstructorSelectionArray objectAtIndex:indexPath.row]).username firstorfullname:@"full"];
        }

        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 37, 260, 1)];
        GeneralLabel.backgroundColor=[UIColor lightGrayColor];
        GeneralLabel.alpha=0.3;
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;
    }else if (tableView==ClassroomSelectionTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 260, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentCenter;
        GeneralLabel.text=[[ClassroomSelectionArray objectAtIndex:indexPath.row] isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[ClassroomSelectionArray objectAtIndex:indexPath.row];
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 37, 260, 1)];
        GeneralLabel.backgroundColor=[UIColor lightGrayColor];
        GeneralLabel.alpha=0.3;
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;
    }else if (tableView==ClassTypeSelectionTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 200, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentCenter;
        GeneralLabel.text=[MyClass returntitlewithtitle:[ClassTypeArray objectAtIndex:indexPath.row]];
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 37, 200, 1)];
        GeneralLabel.backgroundColor=[UIColor lightGrayColor];
        GeneralLabel.alpha=0.3;
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;
    }else if (tableView==AttendanceTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            attendancetableimageview=[[UIImageView alloc]initWithFrame:CGRectMake(15,(38-26)/2, 26,26)];
            attendancetableimageview.tag=201;
            [cell.contentView addSubview:attendancetableimageview];
            
            attendancetablelabel = [[UILabel alloc]initWithFrame:CGRectMake(56, 0, 150, 38)];
            attendancetablelabel.font=[UIFont systemFontOfSize:13];
            attendancetablelabel.textColor=[UIColor darkGrayColor];
            attendancetablelabel.tag=202;
            [cell.contentView addSubview:attendancetablelabel];
            
            separatorline = [[UIView alloc]initWithFrame:CGRectMake(0, 37, 200, 1)];
            separatorline.backgroundColor=[UIColor lightGrayColor];
            separatorline.alpha=0.3;
            separatorline.tag=203;
            [cell.contentView addSubview:separatorline];
            
        }else{
            attendancetableimageview=(UIImageView *)[cell.contentView viewWithTag:201];
            attendancetablelabel=(UILabel *)[cell.contentView viewWithTag:202];
            separatorline=(UIView *)[cell.contentView viewWithTag:203];
        }
        
        AttendanceButtonObject *object=[attendancearray objectAtIndex:indexPath.row];
        attendancetablelabel.text=[MyClass returntitlewithtitle:[NSString stringWithFormat:@"attendance_%@",object.buttonname]];
        [attendancetableimageview setImage:[UIImage imageNamed:object.imagename]];
        
        
        return cell;
    }else if (tableView==sortingtable){
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            sortingnamelabel = [[UILabel alloc]initWithFrame:CGRectMake(-25, 0, 168, 38)];
            sortingnamelabel.font=[UIFont systemFontOfSize:13];
            sortingnamelabel.textColor=[UIColor darkGrayColor];
            sortingnamelabel.adjustsFontSizeToFitWidth=YES;
            sortingnamelabel.minimumScaleFactor=0.7;
            sortingnamelabel.tag=201;
            [cell.contentView addSubview:sortingnamelabel];
            
            sortingorderbutton=[[UIButton alloc]initWithFrame:CGRectMake(110, 6.5, 25, 25)];
            sortingorderbutton.tag=202;
            [sortingorderbutton addTarget:self action:@selector(changesortingorder:) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:sortingorderbutton];
            
        }else{
            sortingnamelabel=(UILabel *)[cell.contentView viewWithTag:201];
            sortingorderbutton=(UIButton *)[cell.contentView viewWithTag:202];
        }
        
        sortingnamelabel.text=[MyClass returntitlewithtitle:[self returnsortinglabelwithitem:((SortingRecord *)[sortingarray objectAtIndex:indexPath.row]).item]];
        if ([((SortingRecord *)[sortingarray objectAtIndex:indexPath.row]).order isEqualToString:@"a"]){
            [sortingorderbutton setImage:[UIImage imageNamed:@"acending_icon.png"] forState:UIControlStateNormal];
        }else{
            [sortingorderbutton setImage:[UIImage imageNamed:@"decending_icon.png"] forState:UIControlStateNormal];
        }
        
        return cell;
    }else if (tableView==scanhistorytable){
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        
        UILabel *studentnamelabel;
        UILabel *studentidlabel;
        UILabel *status;
        
        UIImageView *studentimageview;
        UIImageView *statusimageview;
        ScanHistoryRecord *scanhistoryobject;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            studentnamelabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 2, 190, 21)];
            studentnamelabel.font=[UIFont systemFontOfSize:12];
            studentnamelabel.textColor=[UIColor blackColor];
            studentnamelabel.tag=701;
            studentnamelabel.numberOfLines=0;
            studentnamelabel.minimumScaleFactor=0.7;
            studentnamelabel.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:studentnamelabel];
            
            studentidlabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 10, 150, 12)];
            studentidlabel.font=[UIFont systemFontOfSize:10];
            studentidlabel.adjustsFontSizeToFitWidth=YES;
            studentidlabel.textColor=[UIColor grayColor];
            studentidlabel.tag=702;
            [cell.contentView addSubview:studentidlabel];
            
            studentimageview=[[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 40, 40)];
            studentimageview.layer.cornerRadius=20;
            studentimageview.backgroundColor=[UIColor lightGrayColor];
            studentimageview.tag=703;
            studentimageview.contentMode=UIViewContentModeScaleAspectFill;
            studentimageview.layer.masksToBounds=YES;
            [cell.contentView addSubview:studentimageview];
            
            statusimageview=[[UIImageView alloc]initWithFrame:CGRectMake(scanhistorytable.frame.size.width-30-8, (60-28)/2, 28, 28)];
            statusimageview.layer.cornerRadius=statusimageview.frame.size.width/2;
            statusimageview.backgroundColor=[UIColor lightGrayColor];
            statusimageview.tag=705;
            statusimageview.contentMode=UIViewContentModeScaleAspectFill;
            statusimageview.layer.masksToBounds=YES;
            [cell.contentView addSubview:statusimageview];
            
            status = [[UILabel alloc]initWithFrame:CGRectMake(62, 40, 180, 12)];
            status.font=[UIFont systemFontOfSize:10];
            status.adjustsFontSizeToFitWidth=YES;
            status.textColor=[UIColor grayColor];
            status.tag=704;
            [cell.contentView addSubview:status];
        }else{
            studentnamelabel=(UILabel *)[cell.contentView viewWithTag:701];
            studentidlabel=(UILabel *)[cell.contentView viewWithTag:702];
            studentimageview=(UIImageView *)[cell.contentView viewWithTag:703];
            status=(UILabel *)[cell.contentView viewWithTag:704];
            statusimageview=(UIImageView *)[cell.contentView viewWithTag:705];
        }
        
        scanhistoryobject=[scanhistoryarray objectAtIndex:indexPath.row];
        status.text=scanhistoryobject.status;
        if (scanhistoryobject.success) {
            status.textColor=[UIColor colorWithRed:50.0/255.0 green:140.0/255.0 blue:57.0/255.0 alpha:1.0];
            [statusimageview setImage:[UIImage imageNamed:@"present_icon.png"]];
        }else{
            status.textColor=[UIColor redColor];
            [statusimageview setImage:[UIImage imageNamed:@"warning_icon.png"]];
        }
        
        studentnamelabel.text=scanhistoryobject.studentname;
        studentidlabel.text=scanhistoryobject.studentid;
        
        if ([scanhistoryobject.studentid isEqualToString:@""]) {
            studentnamelabel.frame=CGRectMake(62,0,150,44);
        }else{
            studentnamelabel.frame=CGRectMake(62, 3, 150, 40);
            [studentnamelabel sizeToFit];
            
            if (studentnamelabel.frame.size.height>38-12-2) {
                studentnamelabel.frame=CGRectMake(62, 3, studentnamelabel.frame.size.width, 38-12-2);
            }else{
                studentnamelabel.frame=CGRectMake(62, (42-studentnamelabel.frame.size.height-2-12)/2, studentnamelabel.frame.size.width, studentnamelabel.frame.size.height);
            }
            
            studentidlabel.frame=CGRectMake(62, studentnamelabel.frame.origin.y+studentnamelabel.frame.size.height+2, 150, 12);
        }
        
        [MyClass downloadImageWithImageview:studentimageview gender:scanhistoryobject.gender type:@"student" typekey:scanhistoryobject.studentkey image:scanhistoryobject.image async:YES];
        
        
        /*
        //if ([siblingobject.image isEqualToString:@"Yes"]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@studentimages/%@/student_%@_%@.jpg",globalvariables.serverpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, scanhistoryobject.studentkey]];
        
        if ([globalvariables.studentimagecache objectForKey:url]) {
            [studentimageview setImage:[globalvariables.studentimagecache objectForKey:url]];
        }else{
            if ([scanhistoryobject.gender isEqualToString:@"Male"]) {
                [studentimageview setImage:boyimage];
            }else if ([scanhistoryobject.gender isEqualToString:@"Female"]){
                [studentimageview setImage:girlimage];
            }else{
                [studentimageview setImage:girlimage];
            }
        }
        
        [self checkifimagechangedwithURL:url studentimage:studentimageview indexpath:indexPath completionBlock:^(BOOL imagechanged, NSURL *URL, UIImageView *stimage, NSIndexPath *stimageindexpath){
            if (imagechanged || ![globalvariables.studentimagecache objectForKey:URL]) {
                [self downloadImageWithURL:url studentimage:studentimageview indexpath:indexPath completionBlock:^(BOOL succeeded, NSData *data, UIImageView *simage, NSIndexPath *imageindexpath, NSURL *_url) {
                    
                    CGPoint point = [simage.superview convertPoint:CGPointZero toView:scanhistorytable];
                    NSIndexPath *indexpath =[scanhistorytable indexPathForRowAtPoint:point];
                    if ([tableView.indexPathsForVisibleRows indexOfObject:imageindexpath] != NSNotFound && indexpath.row==imageindexpath.row)
                    {
                        if (succeeded) {
                            if (imageindexpath) {
                                if ([[UIImage alloc] initWithData:data]) {
                                    simage.image = [[UIImage alloc] initWithData:data];
                                    [globalvariables.studentimagecache setObject:simage.image forKey:_url];
                                }
                            }
                        }
                    }
                }];
            }
        }];*/
        
        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
        
        
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            datebardatelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
            datebardatelabel.font=[UIFont boldSystemFontOfSize:[globalvariables.language isEqualToString:@"English"]?13:12];
            datebardatelabel.textColor=[UIColor whiteColor];
            datebardatelabel.adjustsFontSizeToFitWidth=YES;
            datebardatelabel.tag=301;
            datebardatelabel.transform = CGAffineTransformMakeRotation(M_PI_2);
            datebardatelabel.textAlignment=NSTextAlignmentCenter;
            datebardatelabel.center=CGPointMake(30, 50);
            [cell.contentView addSubview:datebardatelabel];
            
            datebardaylabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 100, 20)];
            datebardaylabel.font=[UIFont systemFontOfSize:12];
            datebardaylabel.textColor=[UIColor whiteColor];
            datebardaylabel.adjustsFontSizeToFitWidth=YES;
            datebardaylabel.tag=302;
            datebardaylabel.transform = CGAffineTransformMakeRotation(M_PI_2);
            datebardaylabel.textAlignment=NSTextAlignmentCenter;
            datebardaylabel.center=CGPointMake(10, 50);
            [cell.contentView addSubview:datebardaylabel];
            
        }else{
            datebardatelabel=(UILabel *)[cell.contentView viewWithTag:301];
            datebardaylabel=(UILabel *)[cell.contentView viewWithTag:302];
        }
        
        // Configure the cell...
        
        [df setDateFormat:@"dd-MMM-yyyy"];
        //if ([MyClass isWorkingDate:[df dateFromString:[MyClass returnDateFromBaseDateWithOffset:indexPath.row]] includereserveddate:YES]) {
            cell.hidden=NO;
            NSString *datestring=[MyClass returnDateFromBaseDateWithOffset:indexPath.row];
            [df setDateFormat:@"dd-MMM-yyyy"];
            NSDate *date=[df dateFromString:datestring];
            [df setDateFormat:@"EEE"];
            
            
            //this year
            if ([MyClass isDateFallsThisYear:date]) {
                datebardatelabel.font=[UIFont boldSystemFontOfSize:14];
                datebardatelabel.text=[MyClass returndateformatDDMMMwithdate:[MyClass convertDDMMMYYYYtoDDMMMwithdate:datestring]];
            }else{
                datebardatelabel.font=[UIFont boldSystemFontOfSize:12];
                datebardatelabel.text=[MyClass returndateformatwithdate:[MyClass convertDDMMMYYYYtoDDMMMYYYY2withdate:datestring]];
            }
            
            
            datebardaylabel.text=[MyClass returndateformatEEEwithdate:[df stringFromDate:date]];
            [df setDateFormat:@"dd-MMM-yyyy"];
            
            NSString *centerday=[globalvariables.centerdaydictionary objectForKey:[NSString stringWithFormat:@"%@#%@",[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:[MyClass returnDateFromBaseDateWithOffset:indexPath.row]],globalvariables.centerrecord.centerkey]];
            
            if (/*[[df stringFromDate:[NSDate date]] isEqualToString:selecteddate] && */[[df stringFromDate:date] isEqualToString:selecteddate]) {
                //today
                datebardatelabel.textColor=[UIColor yellowColor];
                datebardaylabel.textColor=[UIColor yellowColor];
                //datebardatelabel.highlightedTextColor=[UIColor yellowColor];
                //datebardaylabel.highlightedTextColor=[UIColor yellowColor];
                //cell.selectionStyle=UITableViewCellSelectionStyleDefault;
            }else if ([centerday isEqualToString:@"H"]){
                datebardatelabel.textColor=[UIColor redColor];
                datebardaylabel.textColor=[UIColor redColor];
                //datebardatelabel.highlightedTextColor=[UIColor colorWithRed:255.0/255.0 green:69.0/255.0 blue:0.0/255.0 alpha:1.0];
                //datebardaylabel.highlightedTextColor=[UIColor colorWithRed:255.0/255.0 green:69.0/255.0 blue:0.0/255.0 alpha:1.0];
                //cell.selectionStyle=UITableViewCellSelectionStyleNone;
            }else if ([centerday isEqualToString:@"R"]){
                datebardatelabel.textColor=[UIColor colorWithRed:255.0/255.0 green:69.0/255.0 blue:0.0/255.0 alpha:1.0];
                datebardaylabel.textColor=[UIColor colorWithRed:255.0/255.0 green:69.0/255.0 blue:0.0/255.0 alpha:1.0];
                //datebardatelabel.highlightedTextColor=[UIColor colorWithRed:255.0/255.0 green:69.0/255.0 blue:0.0/255.0 alpha:1.0];
                //datebardaylabel.highlightedTextColor=[UIColor colorWithRed:255.0/255.0 green:69.0/255.0 blue:0.0/255.0 alpha:1.0];
                //cell.selectionStyle=UITableViewCellSelectionStyleDefault;
            }else{
                datebardatelabel.textColor=[UIColor whiteColor];
                datebardaylabel.textColor=[UIColor whiteColor];
                //datebardatelabel.highlightedTextColor=[UIColor darkGrayColor];
                //datebardaylabel.highlightedTextColor=[UIColor darkGrayColor];
                //cell.selectionStyle=UITableViewCellSelectionStyleDefault;
            }
            
        cell.backgroundColor=themecolor;//[UIColor lightGrayColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        return cell;
    }
    
}

-(void) updateEditAttendanceMenu
{
    attendancecountlabel.text=[@(selectededitattendanceclasskeyarray.count) stringValue];
    if (selectededitattendanceclasskeyarray.count==0){
        attendanceUnknownButton.enabled=NO;
        attendancePresentButton.enabled=NO;
        attendanceAbsentButton.enabled=NO;
        attendanceMakeupButton.enabled=NO;
        attendanceExtendButton.enabled=NO;
        sendMessageButton.enabled=NO;
        sendParentNoteButton.enabled=NO;
        actionsButton.enabled=NO;
        [sendMessageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [sendParentNoteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }else{
        BOOL lockattendance=[MyClass lockLessonWithClassScheduleRecord:ClassScheduleRecordArray];
        attendanceUnknownButton.enabled=!lockattendance;
        attendancePresentButton.enabled=!lockattendance;
        attendanceAbsentButton.enabled=!lockattendance;
        attendanceMakeupButton.enabled=[self enableMakeupExtendButtonInAttendanceMenu] && !lockattendance;
        attendanceExtendButton.enabled=[self enableMakeupExtendButtonInAttendanceMenu] && !lockattendance;
        sendMessageButton.enabled=[self enableMessageButtonInAttendanceMenu];
        sendParentNoteButton.enabled=[self enableMakeupExtendButtonInAttendanceMenu];
        actionsButton.enabled=YES;
        if(sendMessageButton.isEnabled){
            [sendMessageButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        }else{
            [sendMessageButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        
        if(sendParentNoteButton.isEnabled){
            [sendParentNoteButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        }else{
            [sendParentNoteButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        }
        
    }
}

-(BOOL) enableMakeupExtendButtonInAttendanceMenu
{
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        ClassScheduleRecord * classobject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        if ([classobject.classtype isEqualToString:@"Class"]) {
            return TRUE;
        }
    }
    return FALSE;
}


-(BOOL) enableMessageButtonInAttendanceMenu
{
    BOOL Student=FALSE;
    BOOL Lead=FALSE;
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        ClassScheduleRecord * classobject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        if ([classobject.type isEqualToString:@"student"]) {
            Student= TRUE;
        }else{
            Lead=TRUE;
        }
    }
    if(Student && Lead){
        return FALSE;
    }
    return TRUE;
}

-(void)tapImageDetected:(UITapGestureRecognizer *)gr{
    
    if (!editattendanceviewopened) {
        UIImageView *theTappedImageView=(UIImageView *)gr.view;
        
        NSIndexPath *indexpath =[NSIndexPath indexPathForRow:theTappedImageView.tag inSection:0];
        
        //dirty fix for first row cannot obtain indexpath

        [ClassScheduleTable selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:indexpath.row];

        if ([ClassScheduleObject.type isEqualToString:@"student"]) {
            //popup student details view record
            if(![MyClass showMenuItemwithObject:@"Student Profile"]){
                return;
            }
            
            
            [MyClass insertViewHistoryWithType:@"student" Typekey:ClassScheduleObject.studentkey Name:@"" IDNumber:@"" Gender:@""];

            [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:ClassScheduleObject.studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];

                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=ClassScheduleObject.enrollmentkey;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedClasskey=ClassScheduleObject.classkey;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedDTkey=ClassScheduleObject.dtkey;
                
                /*if (![(StudentDetailsViewController *)[studentdetailsnavcontroller topViewController] retrieveStudent:ClassScheduleObject.studentkey]) {
                    return;
                }*/
                
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(self.view.frame.size.width-240, self.view.frame.size.height);
                
                
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).TypeSelectionButton.hidden=NO;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).typeselectionarrow.hidden=NO;
//                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501, 2, 129, 29);
//                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
//                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
                
                
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.hidden=NO;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.hidden=YES;
                
                [((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]) drawpointerwithoption:@"closed" imageview:((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).dayselectionarrow];
                
                studentdetailsnavcontroller.view.frame=CGRectMake(0, 0, self.view.frame.size.width-240, self.view.frame.size.height);
                [sidewindowview addSubview:studentdetailsnavcontroller.view];
                [self addChildViewController:studentdetailsnavcontroller];
                [studentdetailsnavcontroller didMoveToParentViewController:self];
                [ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
                

                
            });

        }else{
            if(![MyClass showMenuItemwithObject:@"Lead Profile"]){
                return;
            }

            [MyClass insertViewHistoryWithType:@"lead" Typekey:ClassScheduleObject.studentkey Name:@"" IDNumber:@"" Gender:@""];
            [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LeadDetailsNavController *leaddetailsnavcontroller = (LeadDetailsNavController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"LeadDetailsNavController"];
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).delegate=self;
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).leadAction=@"PopoverLead";
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).DetailsViewLead=[[Lead alloc]init];
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).DetailsViewLead.leadkey=ClassScheduleObject.studentkey;

                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).selectedDTkey=ClassScheduleObject.dtkey;
                
                
                if (![(LeadDetailsViewController *)[leaddetailsnavcontroller topViewController] retrieveLead:ClassScheduleObject.studentkey]) {
                    return;
                }
                
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(self.view.frame.size.width-240, self.view.frame.size.height);
                
                leaddetailsnavcontroller.view.frame=CGRectMake(0, 0, self.view.frame.size.width-240, self.view.frame.size.height);
                [sidewindowview addSubview:leaddetailsnavcontroller.view];
                [self addChildViewController:leaddetailsnavcontroller];
                [leaddetailsnavcontroller didMoveToParentViewController:self];
                [ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });

        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==sortingtable){
        return 40;
    }else if (tableView==scanhistorytable){
        return 40;
    }else{
        return CGFLOAT_MIN;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView==sortingtable || tableView==ClassScheduleTable){
        return 38;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==scanhistorytable){
        UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        header.backgroundColor=[UIColor systemGroupedBackgroundColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 8, 200, 32)];
        label.text=[[MyClass returntitlewithtitle:@"Records"] uppercaseString];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor grayColor];
        [header addSubview:label];
        
        UIButton *clearhistorybutton=[[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width-34,14, 20, 20)];
        [clearhistorybutton setImage:[UIImage imageNamed:@"closescreengray_icon.png"] forState:UIControlStateNormal];
        [clearhistorybutton addTarget:self action:@selector(deletehistorybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:clearhistorybutton];
        return header;
    }
    return nil;
}

-(void) deletehistorybuttonpressed
{
    [scanhistoryarray removeAllObjects];
    [scanhistorytable reloadData];
    scanhistorynorecordlabel.hidden=NO;
}




-(void) editlessonbuttonpressed:(UIButton *)sender
{
    selectedAttendanceStatus=nil;
    //CGPoint point = [sender.superview convertPoint:CGPointZero toView:LessonTable];
    //NSIndexPath *indexPath =[LessonTable indexPathForRowAtPoint:point];
    NSInteger index=sender.tag;
//    LessonAndClassRecord *obj=[LessonClassRecordArray objectAtIndex:index];
    
    NSString *newselectedLessonKey=[self returnLessonKeyWithLessonRecord:((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:index]).lesson];
    
    if(![newselectedLessonKey isEqualToString:selectedLessonKey]){
        filteredClassScheduleRecordArray=[[NSMutableArray alloc]initWithArray:((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:index]).classScheduleRecordArray];
        //[MyClass showTableColumnWithTableView:ClassScheduleTable ColumnIdentifier:@"Warning" Show:NO];
        selectedLessonKey=newselectedLessonKey;
        [LessonTable reloadData];
        [ClassScheduleTable reloadData];
    }
    
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [validateclassarray removeAllObjects];
        
        //popup make up information
        MakeupPopoverViewController *makeuppopover = (MakeupPopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"MakeupPopoverViewController"];
        makeuppopover.delegate=self;
//        makeuppopover.PopoverLessonRecord=obj.lesson;
        makeuppopover.PopoverLessonAndClassRecord=[LessonClassRecordArray objectAtIndex:index];
        makeuppopover.PopoverOption=@"DailyScheduleLesson";
        
        makeuppopover.view.frame=mainWindow.bounds;
        [sidewindowview addSubview:makeuppopover.view];
        [self addChildViewController:makeuppopover];
        [makeuppopover didMoveToParentViewController:self];
        [ailoadindicator stopAnimating];
        ailoadindicator.hidden=YES;
    });

}


-(void)updateattendancewithindexpath:(NSIndexPath *)indexpath value:(NSString *)value
{
    selectedAttendanceStatus=value;

    ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:indexpath.row];
    
    if (![value isEqualToString:ClassScheduleObject.attendance]) {
        
        [selectededitattendanceclasskeyarray removeAllObjects];
        [selectededitattendanceclasskeyarray addObject:ClassScheduleObject];
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updatebulkattendancewithstatus:value validationCheck:YES];
            //[MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
       
    }
}


-(NSMutableArray *) returnfreescheduleclassarray
{
    FreeScheduleClass *freescheduleclass_object=[[FreeScheduleClass alloc]init];
    
    freescheduleclass_object.classkey=ClassScheduleObject.classkey;
    freescheduleclass_object.subject=ClassScheduleObject.subject;
    freescheduleclass_object.attendance=selectedAttendanceStatus;
    
    freescheduleclass_object.classdate=ClassScheduleObject.startdate;
    freescheduleclass_object.classtime=ClassScheduleObject.classtime;
    freescheduleclass_object.instructor=ClassScheduleObject.instructor;
    freescheduleclass_object.classroom=ClassScheduleObject.classroom;
    
    freescheduleclass_object.makeupdate=ClassScheduleObject.makeupdate;
    freescheduleclass_object.makeuptime=ClassScheduleObject.makeuptime;
    freescheduleclass_object.makeupinstructor=ClassScheduleObject.makeupinstructor;
    freescheduleclass_object.makeupclassroom=ClassScheduleObject.makeupclassroom;
    freescheduleclass_object.makeupattendance=ClassScheduleObject.makeupattendance;
    freescheduleclass_object.classremarks=ClassScheduleObject.absentmakeupreason;
    freescheduleclass_object.classtype=ClassScheduleObject.classtype;
    freescheduleclass_object.leavenaturelistkey=[MyClass returnDefaultLeaveNatureListKeyWithAttendance:selectedAttendanceStatus];
    
    

    
    freescheduleclass_object.action=@"Edit";
    
    
    return [[NSMutableArray alloc]initWithObjects:freescheduleclass_object, nil];
}

-(void) checkvalidatemessage
{
    [MyClass checkValidateMessageWithClassValidateMessage:classvalidatemessage ClassValidateStatus:classvalidatestatus View:self];

}

- (IBAction)updategroupsubjectcategory:(UISwitch *)sender {
    groupsubjectcategory=sender.on;
    [MyClass updatelocaldbwithparameter:@"groupsubjectcategory" value:groupsubjectcategory?@"Yes":@"No"];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self returnfilterdailyclassschedulearray];
        //[ClassScheduleTable reloadData];
//        [self loadtableheader];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

-(void) validationPassed:(BOOL)pass
{
    warningbuttonselected.enabled=YES;
    if(pass){
        if(selectedAttendanceStatus){
            [selectededitattendanceclasskeyarray removeAllObjects];
            [selectededitattendanceclasskeyarray addObject:ClassScheduleObject];
            [self updatebulkattendancewithstatus:selectedAttendanceStatus validationCheck:NO];
        }else{
            [MyClass validateAndMoveLessonWithFreeScheduleArray:[[NSMutableArray alloc]initWithObjects:[self returnmovelessonfreescheduleclasswithclassschedule:ClassScheduleObject freescheduleclass:freescheduleclassobject], nil] studentkeyarray:[[NSMutableArray alloc]initWithObjects:ClassScheduleObject.studentkey, nil] validationcheck:NO updatefollowinglessons:NO updatefollowinglessonsfields:[[NSMutableArray alloc]init]];
            [validateclassarray removeObjectForKey:ClassScheduleObject.classkey];
            if ([self validateclassallpassed]) {
                
                NSString *subjectorcategory;
                NSString *subjectcategory=[MyClass returnsubjectcategorywithsubject:freescheduleclassobject.subject centerkey:globalvariables.centerrecord.centerkey];
                SubjectRecord *object=[MyClass returnsubjectinformationwithsubject_shortname:freescheduleclassobject.subject centerkey:globalvariables.centerrecord.centerkey];
                NSString *duration;
                if([freescheduleclassobject.classtype isEqualToString:@"assessment"]){
                    duration=object.classduration_assessment;
                }else if ([freescheduleclassobject.classtype isEqualToString:@"trial"]){
                    duration=object.classduration_trial;
                }else{
                    duration=object.classduration;
                }
                if (groupsubjectcategory && ![subjectcategory isEqualToString:@""]) {
                    subjectorcategory=subjectcategory;
                }else{
                    subjectorcategory=freescheduleclassobject.subject;
                }
                
                NSString *tmplessonkey=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",freescheduleclassobject.makeupdate,freescheduleclassobject.makeuptime,subjectorcategory,freescheduleclassobject.makeupinstructor,freescheduleclassobject.makeupclassroom,globalvariables.centerrecord.secondaryinstructor?freescheduleclassobject.makeupsinstructor:@"",duration];
                
                if ([freescheduleclassobject.makeupdate isEqualToString:selecteddate]) {
                    selectedLessonKey=tmplessonkey;
                }else{
                    selectedLessonKey=nil;
                }
            
            }
            [self retrieveClassScheduleWithclassdate:selecteddate];
            //[self moveIndividualLessonWithfreescheduleclass:freescheduleclassobject resetattendance:resetattendance];
        }
    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }
}




-(void) refreshtable
{
    //[MyClass getLatestDataSetv2withParameters:@"student" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    [self retrieveClassScheduleWithclassdate:selecteddate];
    
    if (tablerefresh) {
        [tablerefresh endRefreshing];
    }
    
}


-(void) makeupdatetimebuttonpressed:(UIButton *)sender
{
    if (!editattendanceviewopened) {
        ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:sender.tag];
        
        [ClassScheduleTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        
        [self startsidewindowanimationwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MakeupPopoverViewController *makeuppopover = (MakeupPopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"MakeupPopoverViewController"];
            makeuppopover.delegate=self;
            makeuppopover.PopoverClassRecord=ClassScheduleObject;
            makeuppopover.PopoverOption=@"FromClassSchedule";
            //classpopover.PopoverStudent=DetailsViewStudent;
            makeuppopover.preferredContentSize=CGSizeMake(320, self.view.frame.size.height);
            
            makeuppopover.view.frame=mainWindow.bounds;
            [sidewindowview addSubview:makeuppopover.view];
            [self addChildViewController:makeuppopover];
            [makeuppopover didMoveToParentViewController:self];
            [ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
        });
    }
}



- (void)doubleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    
    NSString *newselecteddate;
    
    NSDate *yesterday = [NSDate dateWithTimeIntervalSinceNow:-86400];
    newselecteddate=[MyClass findNextWorkDay2:yesterday includereserveddate:YES];

    //[ailoadclass startAnimating];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([self retrieveClassScheduleWithclassdate:newselecteddate]){
            [datebartable reloadData];
            [datebartable selectRowAtIndexPath:[NSIndexPath indexPathForRow:[MyClass returnDateOffsetWithDate:[MyClass convertToNSDateWithDate:newselecteddate DateFormat:@"dd-MMM-yyyy"]] inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            selecteddate=newselecteddate;
            [self showbarcodescanner];
            //[datebartable reloadData];
            
        }
    });
}


-(void) dismisssextendpopover
{
    //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil]
    [self closesidewindow];
    [self performSelector:@selector(refreshtable) withObject:nil afterDelay:0];
}



-(void) dismissclassremarkspopover
{
    //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil]
    [self closesidewindow];
    
    UIAlertController *updatedalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Information"] message:[MyClass returntitlewithtitle:@"Information is updated"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [updatedalert addAction:OKAction];
    [self presentViewController:updatedalert animated:YES completion:nil];
    
    [self retrieveClassScheduleWithclassdate:selecteddate];
    
    if (editattendanceviewopened) {
        [self canceleditattendancebuttonpressed];
    }
    
    
}


-(void) dismisspopover
{
    [self closesidewindow];
    //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil]
    [self retrieveClassScheduleWithclassdate:selecteddate];
    
}

-(void)dismissmakeuppopoverduetoconnectionerror
{
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}

- (void)enrollDTStudent:(DTRecord *)AddEditDTObject
{

    [self closesidewindow];

    
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    mainVC.leftMenu.prepareforsegue=TRUE;
    mainVC.leftMenu.sourceview=@"classschedule";
    mainVC.leftMenu.studentinformationaction=@"AddDTStudent";
    mainVC.leftMenu.studentinformationdtobject=AddEditDTObject;
    globalvariables.leftmenuindex=@"1";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
    
}

-(void) dismissDTAddEditpopoverwithdttype:(NSString *)type{
    //NSLog(@"testing");
}

-(void) dismissDTAddEditpopoverduetoconnectionerror
{
    [[myDTPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}

- (void)printtopdf:(UIButton *)sender {
    

    [ailoadpdf startAnimating];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSData *pdfData = [self generatePDF];
        
        // Create a filePath for the pdf.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"DailyClassSchedule.pdf"];
        [pdfData writeToFile:filePath atomically:YES];
        
        // Open the controller.
        documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
        documentInteractionController.delegate = self;
        documentInteractionController.UTI = @"com.adobe.pdf";
        [documentInteractionController setName:@"Daily Class Schedule"];
        [documentInteractionController presentOptionsMenuFromRect:[sharebutton frame] inView:self.view animated:YES];
        
        [ailoadpdf stopAnimating];
        //ailoadclass.center = CGPointMake(60,45);
        //ailoadclass.transform=CGAffineTransformMakeScale(1, 1);
    });
    
}


-(int) retrievedailyclassschedulemaxrow
{
    //retrieve remainingclass threshold
    NSString *sql;
    sqlite3_stmt *statement;
    
    char *field1;
    NSString *result;
    
    sql =[NSString stringWithFormat:@"SELECT parametervalue FROM settings where parametername='dailyclassschedulemaxrow'"];
    if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
        while (sqlite3_step(statement)==SQLITE_ROW) {
            
            field1 =(char *)sqlite3_column_text(statement, 0);
            result=[[NSString alloc]initWithUTF8String:field1];
        }
        
    }
    return [result intValue];
    
}



- (NSData *) generatePDF {
    
    //[self openDB];
    
    BOOL showcontact=globalvariables.centerrecord.showcontactindailyscheduleprintout;// [[MyClass getlocaldbwithparameter:@"showcontactindailyscheduleprintout"] isEqualToString:@"Yes"]?YES:NO;
    BOOL showduepayment=globalvariables.centerrecord.showduepaymentindailyscheduleprintout;//[[MyClass getlocaldbwithparameter:@"showduepaymentindailyscheduleprintout"] isEqualToString:@"Yes"]?YES:NO;
    
    NSMutableData * pdfData=[NSMutableData data];
    
    int maxrowperpage=[self retrievedailyclassschedulemaxrow];
    int printarea=1220;
    float rowheight;
    

    
    float tableheadery=91;
    float selectiony=60;
    
    int noOfPage;
    
    printViewArray=[[NSMutableArray alloc]init];
    
    if ([viewmode isEqualToString:@"class"]) {
        if (printarea/maxrowperpage>38){
            rowheight=38;
        }else{
            if (maxrowperpage>filteredClassScheduleRecordArray.count) {
                if (printarea/filteredClassScheduleRecordArray.count>38){
                    rowheight=38;
                }else{
                    rowheight=printarea/filteredClassScheduleRecordArray.count;
                }
                
            }else{
                rowheight=printarea/maxrowperpage;
            }
        }
        
        float fontsize=rowheight*12/35;
        
        noOfPage=(int)(filteredClassScheduleRecordArray.count/maxrowperpage)+1;

        for (int p=0;p<noOfPage;p++){
            
            //create uiview
            UIView *printmasterview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, printarea+40+60+31)];
            UIView *printView=[[UIView alloc]initWithFrame:CGRectMake(15, 15, 1014, printarea+40+60+31)];
            [printmasterview addSubview:printView];
            
            //header
            UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 60)];
            headerview.backgroundColor=[UIColor grayColor];
            UILabel *heading=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 1024, 60-20)];
            if (noOfPage>1){
                heading.text=[NSString stringWithFormat:@"%@ (%@ %@) - Page %i of %i",[MyClass returntitlewithtitle:@"Daily Class Schedule"],[MyClass returndateformatwithdate:selecteddate],[MyClass returndateformatEEEwithdate:[self findclassdaywithstartdate:selecteddate]], p+1,noOfPage];
            }else{
                heading.text=[NSString stringWithFormat:@"%@ (%@ %@)",[MyClass returntitlewithtitle:@"Daily Class Schedule"],[MyClass returndateformatwithdate:selecteddate],[MyClass returndateformatEEEwithdate:[self findclassdaywithstartdate:selecteddate]]];
            }
            
            heading.font=[UIFont boldSystemFontOfSize:20];
            heading.textColor=[UIColor whiteColor];
            heading.textAlignment=NSTextAlignmentCenter;
            [headerview addSubview:heading];
            [printView addSubview:headerview];
            
            //selectionview
            UIView *selection=[[UIView alloc]initWithFrame:CGRectMake(0, selectiony, 1024, 31)];
            //selection.backgroundColor=[UIColor darkGrayColor];
            
            UILabel *instructor_selected=[[UILabel alloc]init];
            instructor_selected.frame=CGRectMake(273, 1, 209, 29);
            instructor_selected.text=[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Instructor"],[MyClass returninstructornamewithusername:instructorselected firstorfullname:@"first"]];
            instructor_selected.font=[UIFont systemFontOfSize:14];
            instructor_selected.textColor=[UIColor darkGrayColor];
            instructor_selected.textAlignment=NSTextAlignmentCenter;
            instructor_selected.layer.borderColor = [UIColor grayColor].CGColor;
            instructor_selected.layer.borderWidth = 1.0;
            instructor_selected.backgroundColor=[UIColor whiteColor];
            [selection addSubview:instructor_selected];
            
            UILabel *classroom_selected=[[UILabel alloc]init];
            classroom_selected.frame=CGRectMake(483, 1, 198, 29);
            classroom_selected.text=[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Classroom"],classroomselected];
            classroom_selected.font=[UIFont systemFontOfSize:14];
            classroom_selected.textColor=[UIColor darkGrayColor];
            classroom_selected.textAlignment=NSTextAlignmentCenter;
            classroom_selected.layer.borderColor = [UIColor grayColor].CGColor;
            classroom_selected.layer.borderWidth = 1.0;
            classroom_selected.backgroundColor=[UIColor whiteColor];
            [selection addSubview:classroom_selected];
            
            
            UILabel *subject_selected=[[UILabel alloc]init];
            subject_selected.frame=CGRectMake(0, 1, 272, 29);
            subject_selected.text=[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Subject"],subjectselected];
            subject_selected.layer.borderColor = [UIColor grayColor].CGColor;
            subject_selected.textColor=[UIColor darkGrayColor];
            subject_selected.layer.borderWidth = 1.0;
            subject_selected.font=[UIFont systemFontOfSize:14];
            subject_selected.textAlignment=NSTextAlignmentCenter;
            subject_selected.backgroundColor=[UIColor whiteColor];
            [selection addSubview:subject_selected];
            
            UILabel *classtype_selected=[[UILabel alloc]init];
            classtype_selected.frame=CGRectMake(682, 1, 342, 29);
            classtype_selected.text=[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Type"],classtypeselected];
            classtype_selected.layer.borderColor = [UIColor grayColor].CGColor;
            classtype_selected.textColor=[UIColor darkGrayColor];
            classtype_selected.layer.borderWidth = 1.0;
            classtype_selected.font=[UIFont systemFontOfSize:14];
            classtype_selected.textAlignment=NSTextAlignmentCenter;
            classtype_selected.backgroundColor=[UIColor whiteColor];
            [selection addSubview:classtype_selected];
            
            
            [printView addSubview:selection];
            
            
            //tableheader
            UIView *tableheader=[[UIView alloc]initWithFrame:CGRectMake(0, tableheadery, 1024, rowheight)];
            tableheader.backgroundColor=[UIColor lightGrayColor];
            [printView addSubview:tableheader];
            
            //Class Time
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 43, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Time"];
            [tableheader addSubview:label];
            
            //Subject
            label = [[UILabel alloc]initWithFrame:CGRectMake(120, rowheight/2, 240, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Subject"];
            [tableheader addSubview:label];
            
            //Class Type
            label = [[UILabel alloc]initWithFrame:CGRectMake(59, 0, 70, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Type"];
            [tableheader addSubview:label];
            
            //Student name
            label = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 240, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Student"];
            [tableheader addSubview:label];
            
            //Contact
            label = [[UILabel alloc]initWithFrame:CGRectMake(1000, 0, 120, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Contact"];
            //[tableheader addSubview:label];
            
            //Instructor
            label = [[UILabel alloc]initWithFrame:CGRectMake(343, 0, 64, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Instructor"];
            [tableheader addSubview:label];
            
            
            //Classroom
            label = [[UILabel alloc]initWithFrame:CGRectMake(343, rowheight/2, 43, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Room"];
            [tableheader addSubview:label];
            
            //Level
            label = [[UILabel alloc]initWithFrame:CGRectMake(59,rowheight/2, 43, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Level/Grade"];
            [tableheader addSubview:label];
            
            //Remarks
            label = [[UILabel alloc]initWithFrame:CGRectMake(416, 0, 324, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Remarks"];
            
            [tableheader addSubview:label];
            
            //attendance
            label = [[UILabel alloc]initWithFrame:CGRectMake(690, 0, 80, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.textAlignment=NSTextAlignmentRight;
            label.text=[MyClass returntitlewithtitle:@"Attendance"];
            [tableheader addSubview:label];
            
            //Makeup
            /*label = [[UILabel alloc]initWithFrame:CGRectMake(725, 0, 100, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Makeup"];
            [tableheader addSubview:label];*/
            
            //Makeup Time
            label = [[UILabel alloc]initWithFrame:CGRectMake(780, 0, 117, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize*0.9];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Makeup Details"];
            [tableheader addSubview:label];
            if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
                label.hidden=YES;
            }
            
            //Makeup Instructor
            label = [[UILabel alloc]initWithFrame:CGRectMake(780, rowheight/2, 120, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize*0.9];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Extended Time"];
            [tableheader addSubview:label];
            if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]|| !globalvariables.centerrecord.enableattendanceextend) {
                label.hidden=YES;
            }
            
            //Class Left
            label = [[UILabel alloc]initWithFrame:CGRectMake(880, 0, 150, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize*0.8];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Sch./TBD.Cl/TBD.MU Left"];
            [tableheader addSubview:label];
            if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
                label.hidden=YES;
            }
            
            //Outstanding payment
            label = [[UILabel alloc]initWithFrame:CGRectMake(880, rowheight/2, 150, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize*0.8];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Outstanding for all Subjects"];
            [tableheader addSubview:label];
            if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
                label.hidden=YES;
            }
            
            long end=0;
            if ((p+1)*maxrowperpage>filteredClassScheduleRecordArray.count){
                end=filteredClassScheduleRecordArray.count;
            }else{
                end=(p+1)*maxrowperpage;
            }
            
            for (long i=p*maxrowperpage; i<end; i++){
                ClassScheduleObject = [filteredClassScheduleRecordArray objectAtIndex:i];
                
                //cellcontent
                UIView *cellcontentview=[[UIView alloc]initWithFrame:CGRectMake(0, (i-p*maxrowperpage)*rowheight+tableheadery+rowheight, 1024, rowheight)];
                [printView addSubview:cellcontentview];
                //alternative background color;
                
                if ([[cellcolorarray objectAtIndex:i] isEqualToString:@"0"]) {
                    cellcontentview.backgroundColor=[UIColor systemGroupedBackgroundColor];
                }else{
                    cellcontentview.backgroundColor=[UIColor whiteColor];
                }
                
                cellcontentview.layer.borderColor=[UIColor grayColor].CGColor;
                cellcontentview.layer.borderWidth=0.1;
                
                
                //Class Time
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(9, 0, 43, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize];
                label.textColor=[UIColor darkGrayColor];
                label.text=ClassScheduleObject.classtime;
                [cellcontentview addSubview:label];
                
                //Class duration
                label = [[UILabel alloc]initWithFrame:CGRectMake(10, rowheight/2, 43, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize*0.8];
                label.textColor=[UIColor darkGrayColor];
                label.text=[NSString stringWithFormat:@"%@%@",ClassScheduleObject.classduration,[MyClass returntitlewithtitle:@"mins"]];
                [cellcontentview addSubview:label];
                
                //Subject
                label = [[UILabel alloc]initWithFrame:CGRectMake(120, rowheight/2, 220, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize];
                label.textColor=[UIColor darkGrayColor];
                label.minimumScaleFactor=0.7;
                label.adjustsFontSizeToFitWidth=YES;
                if ([ClassScheduleObject.classtype isEqualToString:@"Class"] || [ClassScheduleObject.classtype isEqualToString:@"Makeup"]) {
                    
                    NSString *schedulename=[MyClass returnschedulenamewithsubject_shortname:ClassScheduleObject.subject schedulekey:ClassScheduleObject.schedulekey centerkey:globalvariables.centerrecord.centerkey];
                    
                    if ([globalvariables.language isEqualToString:@"English"]) {
                        if ([schedulename isEqualToString:[MyClass returntitlewithtitle:@"Unknown"]]) {
                            label.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_englishname;
                        }else{
                            label.text=[NSString stringWithFormat:@"%@ (%@)",((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_englishname,schedulename];
                        }
                    }else{
                        if ([schedulename isEqualToString:[MyClass returntitlewithtitle:@"Unknown"]]) {
                            label.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_chinesename;
                        }else{
                            label.text=[NSString stringWithFormat:@"%@ (%@)",((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_chinesename,schedulename];
                        }
                    }
                    
                    /*
                    if ([globalvariables.language isEqualToString:@"English"]) {
                        label.text=[NSString stringWithFormat:@"%@ (%@)",((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject]).subject_englishname,[MyClass returnschedulenamewithsubject_shortname:ClassScheduleObject.subject schedulekey:ClassScheduleObject.schedulekey]];
                    }else{
                        label.text=[NSString stringWithFormat:@"%@ (%@)",((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject]).subject_chinesename,[MyClass returnschedulenamewithsubject_shortname:ClassScheduleObject.subject schedulekey:ClassScheduleObject.schedulekey]];
                    }*/
                }else{
                    if ([globalvariables.language isEqualToString:@"English"]) {
                        label.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_englishname;
                    }else{
                        label.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_chinesename;
                    }
                }
                [cellcontentview addSubview:label];
                
                //Class Type
                label = [[UILabel alloc]initWithFrame:CGRectMake(59, 0, 70, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize];
                label.textColor=[UIColor darkGrayColor];
                label.text=[ClassScheduleObject.classtype isEqualToString:@"Assessment"] ? [MyClass returntitlewithtitle:@"Assess"]:[MyClass returntitlewithtitle:ClassScheduleObject.classtype];
                [cellcontentview addSubview:label];
                
                //Student name
                label = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, 220, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize];
                label.textColor=[UIColor darkGrayColor];
                label.minimumScaleFactor=0.7;
                label.adjustsFontSizeToFitWidth=YES;
                label.text=ClassScheduleObject.studentdisplayname; //[self returnstudentnamewithfirstname:ClassScheduleObject.firstname lastname:ClassScheduleObject.lastname];
                //label.text=[NSString stringWithFormat:@"%@ %@",ClassScheduleObject.firstname,ClassScheduleObject.lastname];
                [cellcontentview addSubview:label];
                
                //Contact
                if (showcontact) {
                    if (![ClassScheduleObject.parentcontact isEqualToString:@""]) {
                        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(948, 2, rowheight/2*0.8, rowheight/2*0.8)];
                        [image setImage:[UIImage imageNamed:@"phone_icon.png"]];
                        [cellcontentview addSubview:image];
                        
                        label = [[UILabel alloc]initWithFrame:CGRectMake(965, 0, 120, rowheight/2)];
                        label.font=[UIFont systemFontOfSize:fontsize*0.8];
                        label.textColor=[UIColor darkGrayColor];
                        label.text=ClassScheduleObject.parentcontact;
                        [cellcontentview addSubview:label];
                    }
                }
                
                if ([ClassScheduleObject.outstandingextendtime intValue]!=0) {
                    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(948, 2+rowheight/2, rowheight/2*0.8, rowheight/2*0.8)];
                    [image setImage:[UIImage imageNamed:@"extend_icon.png"]];
                    [cellcontentview addSubview:image];
                    
                    label = [[UILabel alloc]initWithFrame:CGRectMake(965, rowheight/2, 120, rowheight/2)];
                    label.font=[UIFont systemFontOfSize:fontsize*0.8];
                    label.textColor=[UIColor darkGrayColor];
                    label.text=[NSString stringWithFormat:@"%@%@",ClassScheduleObject.outstandingextendtime,[MyClass returntitlewithtitle:@"mins"]];
                    [cellcontentview addSubview:label];
                }
                
                //Instructor
                label = [[UILabel alloc]initWithFrame:CGRectMake(343, 0, 64, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize];
                label.textColor=[UIColor darkGrayColor];
                label.minimumScaleFactor=0.7;
                label.adjustsFontSizeToFitWidth=YES;
                label.text=[ClassScheduleObject.instructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:ClassScheduleObject.instructor firstorfullname:@"first"];
                [cellcontentview addSubview:label];
                
                //Classroom
                label = [[UILabel alloc]initWithFrame:CGRectMake(343, rowheight/2, 64, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize];
                label.textColor=[UIColor darkGrayColor];
                label.minimumScaleFactor=0.7;
                label.adjustsFontSizeToFitWidth=YES;
                label.text=[ClassScheduleObject.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:ClassScheduleObject.classroom;
                [cellcontentview addSubview:label];
                
                //Level
                label = [[UILabel alloc]initWithFrame:CGRectMake(59, rowheight/2, 43, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize*0.8];
                label.textColor=[UIColor darkGrayColor];
                
                label.text=[MyClass returnLevelWithSubject:ClassScheduleObject.subject Levelmain:ClassScheduleObject.levelmain Levelctm:ClassScheduleObject.levelctm];
                
                
                
                
                //label.text=ClassScheduleObject.levelmain;
                [cellcontentview addSubview:label];
                
                //Remarks
                label = [[UILabel alloc]initWithFrame:CGRectMake(416, 0, 275, rowheight)];
                label.font=[UIFont systemFontOfSize:fontsize];
                label.textColor=[UIColor darkGrayColor];
                label.minimumScaleFactor=0.7;
                label.numberOfLines=0;
                label.adjustsFontSizeToFitWidth=YES;
                
                NSString *tmpremarks;
                
                if ([ClassScheduleObject.classtype isEqualToString:@"Makeup"]){
                    
                    if ([ClassScheduleObject.allclassremarks isEqualToString:@""]) {
                        tmpremarks = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"(%@ %@ %@ %@)",[MyClass returntitlewithtitle:@"Orig class on"],[globalvariables.language isEqualToString:@"English"]?[ClassScheduleObject.startdate substringToIndex:6]:[[MyClass returndateformatwithdate:ClassScheduleObject.startdate] substringFromIndex:5],ClassScheduleObject.makeuptime,ClassScheduleObject.classday],ClassScheduleObject.remarks];
                    }else{
                        if ([ClassScheduleObject.remarks isEqualToString:@""]) {
                            tmpremarks = [NSString stringWithFormat:@"%@ %@",[NSString stringWithFormat:@"(%@ %@ %@ %@)",[MyClass returntitlewithtitle:@"Orig class on"],[globalvariables.language isEqualToString:@"English"]?[ClassScheduleObject.startdate substringToIndex:6]:[[MyClass returndateformatwithdate:ClassScheduleObject.startdate] substringFromIndex:5],ClassScheduleObject.makeuptime,ClassScheduleObject.classday],ClassScheduleObject.allclassremarks];
                        }else{
                            tmpremarks = [NSString stringWithFormat:@"%@ %@; %@",[NSString stringWithFormat:@"(%@ %@ %@ %@)",[MyClass returntitlewithtitle:@"Orig class on"],[globalvariables.language isEqualToString:@"English"]?[ClassScheduleObject.startdate substringToIndex:6]:[[MyClass returndateformatwithdate:ClassScheduleObject.startdate] substringFromIndex:5],ClassScheduleObject.makeuptime,ClassScheduleObject.classday],ClassScheduleObject.remarks,ClassScheduleObject.allclassremarks];
                        }
                    }
                    
                    
                    if (![ClassScheduleObject.absentmakeupreason isEqualToString:@""]) {
                        tmpremarks=[NSString stringWithFormat:@"%@; %@",tmpremarks,ClassScheduleObject.absentmakeupreason];
                    }
                    
                    if (![ClassScheduleObject.makeupdate isEqualToString:@""]) {
                        
                        if ([ClassScheduleObject.lastscheduledclassalldaytime isEqualToString:[NSString stringWithFormat:@"%@ %@",[ClassScheduleObject.makeupdate substringToIndex:6], ClassScheduleObject.classtime]]){
                            if ([ClassScheduleObject.remainingclassTBDclass intValue]+[ClassScheduleObject.remainingclassTBDmakeup intValue]>0) {
                                tmpremarks=[NSString stringWithFormat:@"(%@) %@",[MyClass returntitlewithtitle:@"Last scheduled class"],tmpremarks];
                            }else{
                                tmpremarks=[NSString stringWithFormat:@"(%@) %@",[MyClass returntitlewithtitle:@"Last_class"],tmpremarks];
                            }
                        }
                        
                        if ([ClassScheduleObject.firstclass isEqualToString:[NSString stringWithFormat:@"%@ %@",[ClassScheduleObject.makeupdate substringToIndex:6],ClassScheduleObject.classtime]]) {
                            tmpremarks=[NSString stringWithFormat:@"(%@) %@",[MyClass returntitlewithtitle:@"First_class"],tmpremarks];
                        }
                    }
                }else if ([ClassScheduleObject.classtype isEqualToString:@"Class"]){
                    
                    if ([ClassScheduleObject.allclassremarks isEqualToString:@""]) {
                        tmpremarks=ClassScheduleObject.remarks;
                    }else{
                        if ([ClassScheduleObject.remarks isEqualToString:@""]) {
                            tmpremarks=ClassScheduleObject.allclassremarks;
                        }else{
                            tmpremarks=[NSString stringWithFormat:@"%@, %@",ClassScheduleObject.remarks,ClassScheduleObject.allclassremarks];
                        }
                    }
                    
                    if ([ClassScheduleObject.lastscheduledclassalldaytime isEqualToString:[NSString stringWithFormat:@"%@ %@",[ClassScheduleObject.startdate substringToIndex:6],ClassScheduleObject.classtime]]){
                        if ([ClassScheduleObject.remainingclassTBDclass intValue]+[ClassScheduleObject.remainingclassTBDmakeup intValue]>0) {
                            tmpremarks=[NSString stringWithFormat:@"(%@) %@",[MyClass returntitlewithtitle:@"Last scheduled class"],tmpremarks];
                        }else{
                            tmpremarks=[NSString stringWithFormat:@"(%@) %@",[MyClass returntitlewithtitle:@"Last_class"],tmpremarks];
                        }
                    }
                    
                    if ([ClassScheduleObject.firstclass isEqualToString:[NSString stringWithFormat:@"%@ %@",[ClassScheduleObject.startdate substringToIndex:6],ClassScheduleObject.classtime]]) {
                        tmpremarks=[NSString stringWithFormat:@"(%@) %@",[MyClass returntitlewithtitle:@"First_class"],tmpremarks];
                    }
                    
                }else if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]){
                    tmpremarks=ClassScheduleObject.remarks;
                }
                
                if (![ClassScheduleObject.absentmakeupreason isEqualToString:@""] && [ClassScheduleObject.attendance isEqualToString:@"Makeup"]) {
                    if ([tmpremarks isEqualToString:@""]) {
                        tmpremarks=[NSString stringWithFormat:@"%@",ClassScheduleObject.absentmakeupreason];
                    }else{
                        tmpremarks=[NSString stringWithFormat:@"%@; %@",tmpremarks,ClassScheduleObject.absentmakeupreason];
                    }
                }
                
                
                label.text=tmpremarks;
                
                [label sizeToFit];
                CGRect myFrame=label.frame;
                
                if (myFrame.size.height>rowheight*.8) {
                    myFrame=CGRectMake(416, 0, 275, rowheight);
                }else{
                    myFrame=CGRectMake(416, 3*fontsize/15, 275, myFrame.size.height);
                }
                label.frame=myFrame;
                
                
                [cellcontentview addSubview:label];
                
                
                UIImageView *attendanceimage=[[UIImageView alloc]initWithFrame:CGRectMake(770-rowheight+10, 5, rowheight-10, rowheight-10)];
                [attendanceimage setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:ClassScheduleObject.classtype attendance:ClassScheduleObject.attendance makeupattendance:ClassScheduleObject.makeupattendance]]];
                [cellcontentview addSubview:attendanceimage];
                
                
                [cellcontentview addSubview:label];
                
                
                //extended time, makeup date, time
                if ([ClassScheduleObject.classtype isEqualToString:@"Makeup"]) {
                    if ([ClassScheduleObject.extendedminute intValue]!=0) {
                        //extended time
                        label = [[UILabel alloc]initWithFrame:CGRectMake(785, 0, 117, rowheight)];
                        label.font=[UIFont systemFontOfSize:fontsize];
                        label.textColor=[UIColor darkGrayColor];
                        label.text=[NSString stringWithFormat:@"+%@%@",ClassScheduleObject.extendedminute,[MyClass returntitlewithtitle:@"mins"]];
                        [cellcontentview addSubview:label];
                    }else{
                        //na
                        label = [[UILabel alloc]initWithFrame:CGRectMake(785, 0, 117, rowheight)];
                        label.font=[UIFont systemFontOfSize:fontsize];
                        label.textColor=[UIColor darkGrayColor];
                        label.text=@"-";
                        [cellcontentview addSubview:label];
                    }
                }else{
                    if (![ClassScheduleObject.makeupdate isEqualToString:@""] && ![ClassScheduleObject.makeupdate isEqualToString:@"TBD"]){
                        if ([ClassScheduleObject.extendedminute intValue]!=0) {
                            
                            //Makeup Time
                            label = [[UILabel alloc]initWithFrame:CGRectMake(785, 0, 117, rowheight/3)];
                            label.font=[UIFont systemFontOfSize:fontsize*0.8];
                            label.textColor=[UIColor darkGrayColor];
                            
                            label.text=[NSString stringWithFormat:@"%@ %@", [globalvariables.language isEqualToString:@"English"]?[ClassScheduleObject.makeupdate substringToIndex:6]:[[MyClass returndateformatwithdate:ClassScheduleObject.makeupdate] substringFromIndex:5],ClassScheduleObject.makeuptime];
                            [cellcontentview addSubview:label];
                            
                            //Makeup Instructor
                            label = [[UILabel alloc]initWithFrame:CGRectMake(785, rowheight/3, 60, rowheight/3)];
                            label.font=[UIFont systemFontOfSize:fontsize*0.8];
                            label.textColor=[UIColor darkGrayColor];
                            
                            
                            if ([ClassScheduleObject.classtype isEqualToString:@"Makeup"] || ![ClassScheduleObject.attendance isEqualToString:@"Makeup"]) {
                                label.text=@"";
                            }else{
                                label.text=[MyClass returninstructornamewithusername:ClassScheduleObject.makeupinstructor firstorfullname:@"first"];
                            }
                            [cellcontentview addSubview:label];
                            
                            //extended time
                            label = [[UILabel alloc]initWithFrame:CGRectMake(785, rowheight/3*2, 117, rowheight/3)];
                            label.font=[UIFont systemFontOfSize:fontsize*0.8];
                            label.textColor=[UIColor darkGrayColor];
                            label.text=[NSString stringWithFormat:@"+%@%@",ClassScheduleObject.extendedminute,[MyClass returntitlewithtitle:@"mins"]];
                            [cellcontentview addSubview:label];
                            
                        }else{
                            //Makeup Time
                            label = [[UILabel alloc]initWithFrame:CGRectMake(785, 0, 117, rowheight/2)];
                            label.font=[UIFont systemFontOfSize:fontsize];
                            label.textColor=[UIColor darkGrayColor];
                            
                            label.text=[NSString stringWithFormat:@"%@ %@", [globalvariables.language isEqualToString:@"English"]?[ClassScheduleObject.makeupdate substringToIndex:6]:[[MyClass returndateformatwithdate:ClassScheduleObject.makeupdate] substringFromIndex:5],ClassScheduleObject.makeuptime];
                            [cellcontentview addSubview:label];
                            
                            //Makeup Instructor
                            label = [[UILabel alloc]initWithFrame:CGRectMake(785, rowheight/2, 60, rowheight/2)];
                            label.font=[UIFont systemFontOfSize:fontsize];
                            label.textColor=[UIColor darkGrayColor];
                            
                            
                            if ([ClassScheduleObject.classtype isEqualToString:@"Makeup"] || ![ClassScheduleObject.attendance isEqualToString:@"Makeup"]) {
                                label.text=@"";
                            }else{
                                label.text=[MyClass returninstructornamewithusername:ClassScheduleObject.makeupinstructor firstorfullname:@"first"];
                            }
                            [cellcontentview addSubview:label];
                        }
                        
                    }else{
                        if ([ClassScheduleObject.attendance isEqualToString:@"Makeup"]) {
                            //makeup time
                            label = [[UILabel alloc]initWithFrame:CGRectMake(785, 0, 117, rowheight/2)];
                            label.font=[UIFont systemFontOfSize:fontsize];
                            label.textColor=[UIColor darkGrayColor];
                            label.text=[MyClass returntitlewithtitle:@"TBD"];
                            [cellcontentview addSubview:label];
                            
                            //makeup instructor
                            label = [[UILabel alloc]initWithFrame:CGRectMake(785, rowheight/2, 117, rowheight/2)];
                            label.font=[UIFont systemFontOfSize:fontsize];
                            label.textColor=[UIColor darkGrayColor];
                            label.text=[MyClass returntitlewithtitle:@"TBD"];
                            [cellcontentview addSubview:label];
                        }else{
                            //na
                            label = [[UILabel alloc]initWithFrame:CGRectMake(785, 0, 117, rowheight)];
                            label.font=[UIFont systemFontOfSize:fontsize];
                            label.textColor=[UIColor darkGrayColor];
                            label.text=[MyClass returntitlewithtitle:@"-"];
                            [cellcontentview addSubview:label];
                        }

                    }
                }
                
                
                //Scheduled Class Left
                label = [[UILabel alloc]initWithFrame:CGRectMake(880, rowheight/2*0.1, rowheight/2*0.8, rowheight/2*0.8)];
                
                if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
                }else{
                    label.layer.borderWidth=0.5;
                    label.layer.cornerRadius=3;
                    label.layer.masksToBounds=YES;
                    
                    
                    if ([ClassScheduleObject.remainingclassscheduled intValue]==0) {
                        label.layer.borderColor=[UIColor redColor].CGColor;
                    }else if ([ClassScheduleObject.remainingclassscheduled intValue]==1){
                        label.layer.borderColor=[UIColor orangeColor].CGColor;
                    }else{
                        label.layer.borderColor=[UIColor darkGrayColor].CGColor;
                    }
                }
                [cellcontentview addSubview:label];
                
                
                CGRect initialFrame = CGRectMake(880, rowheight/2*0.1, rowheight/2*0.8, rowheight/2*0.8);
                UIEdgeInsets contentInsets = UIEdgeInsetsMake(1, 1, 1, 1);
                CGRect paddedFrame = UIEdgeInsetsInsetRect(initialFrame, contentInsets);
                
                label = [[UILabel alloc]initWithFrame:paddedFrame];
                label.font=[UIFont systemFontOfSize:fontsize*0.9];
                label.minimumScaleFactor=0.7;
                label.adjustsFontSizeToFitWidth=YES;

                if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
                    label.text=@"-";
                }else{
                    label.textAlignment=NSTextAlignmentCenter;
                    
                    label.text=[NSString stringWithFormat:@"%@", ClassScheduleObject.remainingclassscheduled];
                    if ([ClassScheduleObject.remainingclassscheduled intValue]==0) {
                        label.textColor=[UIColor redColor];
                        //label.layer.borderColor=[UIColor redColor].CGColor;
                    }else if ([ClassScheduleObject.remainingclassscheduled intValue]==1){
                        label.textColor=[UIColor orangeColor];
                        //label.layer.borderColor=[UIColor orangeColor].CGColor;
                    }else{
                        label.textColor=[UIColor darkGrayColor];
                        //label.layer.borderColor=[UIColor darkGrayColor].CGColor;
                    }
                }
                [cellcontentview addSubview:label];


                
                
                //Unscheduled Class Left
                label = [[UILabel alloc]initWithFrame:CGRectMake(899, rowheight/2*0.1, rowheight/2*0.8, rowheight/2*0.8)];
                if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
                }else{
                    label.layer.borderWidth=0.5;
                    label.layer.cornerRadius=3;
                    label.layer.masksToBounds=YES;
                    label.layer.borderColor=[UIColor darkGrayColor].CGColor;
                }
                
                [cellcontentview addSubview:label];

                initialFrame = CGRectMake(899, rowheight/2*0.1, rowheight/2*0.8, rowheight/2*0.8);
                contentInsets = UIEdgeInsetsMake(1, 1, 1, 1);
                paddedFrame = UIEdgeInsetsInsetRect(initialFrame, contentInsets);
                
                label = [[UILabel alloc]initWithFrame:paddedFrame];
                label.font=[UIFont systemFontOfSize:fontsize*0.9];
                label.textColor=[UIColor darkGrayColor];
                label.minimumScaleFactor=0.7;
                label.adjustsFontSizeToFitWidth=YES;
                
                if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
                    label.text=@"";
                }else{
                    label.textAlignment=NSTextAlignmentCenter;
                    label.text=ClassScheduleObject.remainingclassTBDclass;
                }
                
                [cellcontentview addSubview:label];
                
                
                //Unscheduled Makeup Left
                label = [[UILabel alloc]initWithFrame:CGRectMake(918,rowheight/2*0.1, rowheight/2*0.8, rowheight/2*0.8)];
                
                if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
                }else{
                    label.layer.borderWidth=0.5;
                    label.layer.cornerRadius=3;
                    label.layer.masksToBounds=YES;
                    label.layer.borderColor=[UIColor darkGrayColor].CGColor;
                }
                
                [cellcontentview addSubview:label];

                initialFrame = CGRectMake(918, rowheight/2*0.1, rowheight/2*0.8, rowheight/2*0.8);
                contentInsets = UIEdgeInsetsMake(1, 1, 1, 1);
                paddedFrame = UIEdgeInsetsInsetRect(initialFrame, contentInsets);
                
                label = [[UILabel alloc]initWithFrame:paddedFrame];
                label.font=[UIFont systemFontOfSize:fontsize*0.9];
                label.textColor=[UIColor darkGrayColor];
                label.minimumScaleFactor=0.7;
                label.adjustsFontSizeToFitWidth=YES;
                
                if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
                    label.text=@"";
                }else{
                    label.textAlignment=NSTextAlignmentCenter;
                    label.text=ClassScheduleObject.remainingclassTBDmakeup;
                }
                
                [cellcontentview addSubview:label];

                
                //Outstanding payment
                if (showduepayment) {
                    label = [[UILabel alloc]initWithFrame:CGRectMake(880, rowheight/2, 100, rowheight/2)];
                    label.font=[UIFont systemFontOfSize:fontsize];
                    if ([ClassScheduleObject.outstandingpayment intValue]==0) {
                        label.text=@"-";
                        label.textColor=[UIColor darkGrayColor];
                    }else{
                        label.text=[NSString stringWithFormat:@"$%@",ClassScheduleObject.outstandingpayment];
                        label.textColor=[UIColor redColor];
                    }
                    [cellcontentview addSubview:label];
                }

            }
            [printViewArray addObject:printmasterview];
            
        }

    }else{
        //lesson view
        if (printarea/maxrowperpage>38){
            rowheight=38;
        }else{
            if (maxrowperpage>LessonClassRecordArray.count) {
                if (printarea/LessonClassRecordArray.count>38){
                    rowheight=38;
                }else{
                    rowheight=printarea/LessonClassRecordArray.count;
                }
                
            }else{
                rowheight=printarea/maxrowperpage;
            }
        }
        
        float fontsize=rowheight*12/35;
        
        noOfPage=(int)(LessonClassRecordArray.count/maxrowperpage)+1;
        
        for (int p=0;p<noOfPage;p++){
            
            //create uiview
            UIView *printmasterview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, printarea+40+60+31)];
            UIView *printView=[[UIView alloc]initWithFrame:CGRectMake(15, 15, 1014, printarea+40+60+31)];
            [printmasterview addSubview:printView];
            
            //header
            UIView *headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1024, 60)];
            headerview.backgroundColor=[UIColor grayColor];
            UILabel *heading=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, 1024, 60-20)];
            if (noOfPage>1){
                heading.text=[NSString stringWithFormat:@"%@ (%@ %@) - Page %i of %i",[MyClass returntitlewithtitle:@"Daily Class Schedule"],[MyClass returndateformatwithdate:selecteddate],[MyClass returndateformatEEEwithdate:[self findclassdaywithstartdate:selecteddate]], p+1,noOfPage];
            }else{
                heading.text=[NSString stringWithFormat:@"%@ (%@ %@)",[MyClass returntitlewithtitle:@"Daily Class Schedule"],[MyClass returndateformatwithdate:selecteddate],[MyClass returndateformatEEEwithdate:[self findclassdaywithstartdate:selecteddate]]];
            }
            
            heading.font=[UIFont boldSystemFontOfSize:20];
            heading.textColor=[UIColor whiteColor];
            heading.textAlignment=NSTextAlignmentCenter;
            [headerview addSubview:heading];
            [printView addSubview:headerview];
            
            //selectionview
            UIView *selection=[[UIView alloc]initWithFrame:CGRectMake(0, selectiony, 1024, 31)];
            //selection.backgroundColor=[UIColor darkGrayColor];
            
            UILabel *instructor_selected=[[UILabel alloc]init];
            instructor_selected.frame=CGRectMake(0, 1, 209, 29);
            instructor_selected.text=[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Instructor"],[MyClass returninstructornamewithusername:instructorselected firstorfullname:@"first"]];
            instructor_selected.font=[UIFont systemFontOfSize:14];
            instructor_selected.textColor=[UIColor darkGrayColor];
            instructor_selected.textAlignment=NSTextAlignmentCenter;
            instructor_selected.layer.borderColor = [UIColor grayColor].CGColor;
            instructor_selected.layer.borderWidth = 1.0;
            instructor_selected.backgroundColor=[UIColor whiteColor];
            [selection addSubview:instructor_selected];
            
            UILabel *classroom_selected=[[UILabel alloc]init];
            classroom_selected.frame=CGRectMake(210, 1, 198, 29);
            classroom_selected.text=[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Classroom"],classroomselected];
            classroom_selected.font=[UIFont systemFontOfSize:14];
            classroom_selected.textColor=[UIColor darkGrayColor];
            classroom_selected.textAlignment=NSTextAlignmentCenter;
            classroom_selected.layer.borderColor = [UIColor grayColor].CGColor;
            classroom_selected.layer.borderWidth = 1.0;
            classroom_selected.backgroundColor=[UIColor whiteColor];
            [selection addSubview:classroom_selected];
            
            
            UILabel *subject_selected=[[UILabel alloc]init];
            subject_selected.frame=CGRectMake(409, 1, 272, 29);
            subject_selected.text=[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Subject"],subjectselected];
            subject_selected.layer.borderColor = [UIColor grayColor].CGColor;
            subject_selected.textColor=[UIColor darkGrayColor];
            subject_selected.layer.borderWidth = 1.0;
            subject_selected.font=[UIFont systemFontOfSize:14];
            subject_selected.textAlignment=NSTextAlignmentCenter;
            subject_selected.backgroundColor=[UIColor whiteColor];
            [selection addSubview:subject_selected];
            
            UILabel *classtype_selected=[[UILabel alloc]init];
            classtype_selected.frame=CGRectMake(682, 1, 342, 29);
            classtype_selected.text=[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Type"],classtypeselected];
            classtype_selected.layer.borderColor = [UIColor grayColor].CGColor;
            classtype_selected.textColor=[UIColor darkGrayColor];
            classtype_selected.layer.borderWidth = 1.0;
            classtype_selected.font=[UIFont systemFontOfSize:14];
            classtype_selected.textAlignment=NSTextAlignmentCenter;
            classtype_selected.backgroundColor=[UIColor whiteColor];
            [selection addSubview:classtype_selected];
            
            
            [printView addSubview:selection];
            
            
            //tableheader
            UIView *tableheader=[[UIView alloc]initWithFrame:CGRectMake(0, tableheadery, 1024, rowheight)];
            tableheader.backgroundColor=[UIColor lightGrayColor];
            [printView addSubview:tableheader];
            
            //Class Time
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 43, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Time"];
            [tableheader addSubview:label];
            
            //Subject
            label = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 70, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Subject"];
            [tableheader addSubview:label];
            
            //Class Duration
            /*label = [[UILabel alloc]initWithFrame:CGRectMake(59, rowheight/2, 70, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Duration"];
            [tableheader addSubview:label];*/
            
            //Instructor
            label = [[UILabel alloc]initWithFrame:CGRectMake(409, 0, 64, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Instructor"];
            [tableheader addSubview:label];
            
            
            //Classroom
            label = [[UILabel alloc]initWithFrame:CGRectMake(409, rowheight/2, 43, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"Room"];
            [tableheader addSubview:label];
            
            //No. of Student
            label = [[UILabel alloc]initWithFrame:CGRectMake(682, 0, 100, rowheight/2)];
            label.font=[UIFont systemFontOfSize:fontsize];
            label.textColor=[UIColor darkGrayColor];
            label.text=[MyClass returntitlewithtitle:@"No. of Student"];
            [tableheader addSubview:label];
            
            
            
            long end=0;
            if ((p+1)*maxrowperpage>LessonClassRecordArray.count){
                end=LessonClassRecordArray.count;
            }else{
                end=(p+1)*maxrowperpage;
            }
            
            for (long i=p*maxrowperpage; i<end; i++){
                LessonObject = ((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:i]).lesson;
                
                //cellcontent
                UIView *cellcontentview=[[UIView alloc]initWithFrame:CGRectMake(0, (i-p*maxrowperpage)*rowheight+tableheadery+rowheight, 1024, rowheight)];
                [printView addSubview:cellcontentview];
                //alternative background color;
                
                if (i%2==0) {
                    cellcontentview.backgroundColor=[UIColor whiteColor];
                }else{
                    cellcontentview.backgroundColor=[UIColor systemGroupedBackgroundColor];
                }
                
                cellcontentview.layer.borderColor=[UIColor grayColor].CGColor;
                cellcontentview.layer.borderWidth=0.1;
                
                
                //Class Time
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(9, 0, 43, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize];
                label.textColor=[UIColor darkGrayColor];
                label.text=LessonObject.classtime;
                [cellcontentview addSubview:label];
                
                //Class duration
                label = [[UILabel alloc]initWithFrame:CGRectMake(10, rowheight/2, 43, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize*0.8];
                label.textColor=[UIColor darkGrayColor];
                label.text=[NSString stringWithFormat:@"%@%@",((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:LessonObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration,[MyClass returntitlewithtitle:@"mins"]];
                [cellcontentview addSubview:label];
                
                //Subject
                label = [[UILabel alloc]initWithFrame:CGRectMake(70, 0, 300, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize];
                label.textColor=[UIColor darkGrayColor];
                if ([globalvariables.language isEqualToString:@"English"]) {
                    label.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:LessonObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_englishname;
                }else{
                    label.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:LessonObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_chinesename;
                }
                [cellcontentview addSubview:label];
                
                
                //Instructor
                label = [[UILabel alloc]initWithFrame:CGRectMake(409, 0, 200, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize];
                label.textColor=[UIColor darkGrayColor];
                label.text=[MyClass returninstructornamewithusername:LessonObject.instructor firstorfullname:@"Full"];
                [cellcontentview addSubview:label];
                
                //Classroom
                label = [[UILabel alloc]initWithFrame:CGRectMake(409, rowheight/2, 200, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize];
                label.textColor=[UIColor darkGrayColor];
                label.text=[LessonObject.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:LessonObject.classroom;;
                [cellcontentview addSubview:label];
                
                //No.of students
                label = [[UILabel alloc]initWithFrame:CGRectMake(682, 0, 43, rowheight/2)];
                label.font=[UIFont systemFontOfSize:fontsize];
                label.textColor=[UIColor darkGrayColor];
                label.text=LessonObject.classcount;
                [cellcontentview addSubview:label];
                
            }
            [printViewArray addObject:printmasterview];
            
        }

    }
    
    
    //[[NSBundle mainBundle] loadNibNamed:@"ClassTimeTableViewController" owner:self options:nil];
    
    // by default, the UIKit will create a 612x792 page size (8.5 x 11 inches)
    // if you pass in CGRectZero for the size
    UIGraphicsBeginPDFContextToData(pdfData, CGRectZero,nil);
    CGContextRef pdfContext=UIGraphicsGetCurrentContext();
    
    for (int k=0;k<noOfPage;k++){
        
        // repeat the code between the lines for each pdf page you want to output
        // ======================================================================
        
        UIGraphicsBeginPDFPage();
        
        // add code to update the UI elements in the first page here
        CGContextSaveGState(pdfContext);
        CGContextConcatCTM(pdfContext,CGAffineTransformMakeScale(.58, .58));
        
        // use the currently being outputed view's layer here
        //UIView *outputview=[[UIView alloc]init];
        //outputview=[self.view copy];
        //outputview.transform=CGAffineTransformMakeRotation(M_PI_2);
        UIView *printViewObject=[printViewArray objectAtIndex:k];
        [printViewObject.layer renderInContext:pdfContext];
        
        // end repeat code
        // ======================================================================
        
    }
    // finally end the PDF context.
    UIGraphicsEndPDFContext();
    
    // and return the PDF data.
    return pdfData;
}



-(void) loadtableheader
{

    title_Class_Time.text=[MyClass returntitlewithtitle:@"Time"];
    title_Class_Type.text=[MyClass returntitlewithtitle:@"Type"];
    title_Class_Level.text=[MyClass returntitlewithtitle:@"Level/Grade"];
    title_Class_Student.text=[MyClass returntitlewithtitle:@"Student"];
    title_Class_Subject.text=[MyClass returntitlewithtitle:@"Subject"];
    title_Class_Instructor.text=[MyClass returntitlewithtitle:@"Instructor"];
    title_Class_Room.text=[MyClass returntitlewithtitle:@"Room"];
    title_Class_Contact.text=[MyClass returntitlewithtitle:@"Contact"];
    title_Class_Remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    title_Class_Attendance.text=[MyClass returntitlewithtitle:@"Attendance"];
    title_Class_OutstandingClass.text=[MyClass returntitlewithtitle:@"Sch/TBD.Cl/TBD.MU Left"];
    if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
        title_Class_OutstandingClass.hidden=YES;
    }else{
        title_Class_OutstandingClass.hidden=NO;
    }

    
    if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
        title_Class_OutstandingAmount.text=[MyClass returntitlewithtitle:@""];
    }else{
        title_Class_OutstandingAmount.text=[MyClass returntitlewithtitle:@"Outstanding (Courses)"];
    }
    
    title_Lesson.text=[MyClass returntitlewithtitle:@"Lesson"];
    
    if ([viewmode isEqualToString:@"lesson"]) {
        title_Class_Time.hidden=YES;
        title_Class_Duration.hidden=YES;
        title_Class_Instructor.hidden=YES;
        title_Class_Room.hidden=YES;
//        title_Class_Contact.hidden=YES;
        title_Class_Subject.text=[MyClass returntitlewithtitle:@"Level/Grade"];
        title_Class_Level.hidden=YES;
    }else{
        title_Class_Time.hidden=NO;
        title_Class_Duration.hidden=NO;
        title_Class_Instructor.hidden=NO;
        title_Class_Room.hidden=NO;
//        title_Class_Contact.hidden=NO;
        title_Class_Subject.text=[MyClass returntitlewithtitle:@"Subject"];
        title_Class_Level.hidden=NO;
    }
    

    title_Class_Select.hidden=!editattendanceviewopened;
//    title_Class_Select.hidden=NO;

}

-(NSString *) findclassdaywithstartdate:(NSString *)startdate
{
    if ([startdate isEqualToString:@""]){
        return @"";
    }else if ([startdate isEqualToString:@"TBD"]) {
        return @"TBD";
    }else{
        [df setDateFormat:@"dd-MMM-yyyy"];
        NSDate *date=[df dateFromString:startdate];
        [df setDateFormat:@"EEE"];
        return [df stringFromDate:date];
    }
}




- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

-(void) refreshstudentdetailviewpresentingviewcontent
{
    //[ailoadclass startAnimating];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self retrieveClassScheduleWithclassdate:selecteddate];
    });
    
}

-(void) refreshleaddetailviewpresentingviewcontent
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self retrieveClassScheduleWithclassdate:selecteddate];
    });
}

-(void) updateCategoryCount
{
    //not required
}

- (void) gobackStudentCategory
{
    //not required
}

-(void) enableAddStudentButton
{
    //not required
}

-(void) disableAddStudentButton
{
    //not used
}

-(void)menubuttonpressed:(id)sender
{
    [self.mainSlideMenu openLeftMenu];
}

/*
- (NSString *) returnstudentnamewithfirstname:(NSString *)firstname lastname:(NSString *)lastname
{
    if ([lastname isEqualToString:@""]) {
        return firstname;
    }else{
        return [NSString stringWithFormat:@"%@ %@",firstname,lastname];
    }
}*/

-(void) updatestudentinformationlist:(NSString *)studentkey reloadlist:(BOOL)reload
{
    [ClassScheduleTable reloadData];
}

-(void) updateleadinformationlist:(NSString *)leadkey
{
    [ClassScheduleTable reloadData];
}

-(void) selectsubject:(UIButton *)sender
{
    // add group selection tables
    ClassSelectionTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    ClassSelectionTable.separatorColor=[UIColor clearColor];
    ClassSelectionTable.delegate=self;
    ClassSelectionTable.dataSource=self;
    ClassSelectionTable.sectionHeaderHeight=0;
    ClassSelectionTable.sectionFooterHeight=0;
    [ClassSelectionTable reloadData];
    //NSLog(@"%f %@",ClassSelectionTable.contentSize.height,SubjectSelectionArray);
    
    //long h=[ClassSelectionTable indexPathsForVisibleRows].count*38;
    
    ClassSelectionTable.frame=CGRectMake(0, 0, 260, (ClassSelectionTable.contentSize.height-35)>maxselectiontableheight?maxselectiontableheight:ClassSelectionTable.contentSize.height-35);
    ClassSelectionTable.separatorColor=[UIColor clearColor];
    
    //UIView *classSelectionMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, ClassSelectionTable.frame.size.height)];
    //[classSelectionMasterView addSubview:ClassSelectionTable];
    
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=ClassSelectionTable;
    viewcontroller.preferredContentSize=ClassSelectionTable.frame.size;
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myClassSelectionPopoverController=viewcontroller.popoverPresentationController;
    myClassSelectionPopoverController.delegate=self;
    myClassSelectionPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myClassSelectionPopoverController.sourceView=sender;
    myClassSelectionPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    [self drawsubjectpointerwithoption:@"open"];
}

-(void) selectinstructor:(UIButton *)sender
{
    // add group selection tables
    //if (!instructoronlyview) {
        InstructorSelectionTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        InstructorSelectionTable.separatorColor=[UIColor clearColor];
        InstructorSelectionTable.delegate=self;
        InstructorSelectionTable.dataSource=self;
        InstructorSelectionTable.sectionHeaderHeight=0;
        InstructorSelectionTable.sectionFooterHeight=0;
        [InstructorSelectionTable reloadData];
        InstructorSelectionTable.frame=CGRectMake(0, 0, 260, InstructorSelectionTable.contentSize.height-35>maxselectiontableheight?maxselectiontableheight:InstructorSelectionTable.contentSize.height-35);
        InstructorSelectionTable.separatorColor=[UIColor clearColor];
        
        //UIView *classSelectionMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, InstructorSelectionTable.frame.size.height)];
        //[classSelectionMasterView addSubview:InstructorSelectionTable];
        
        
        UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
        viewcontroller.view=InstructorSelectionTable;
        viewcontroller.preferredContentSize=InstructorSelectionTable.frame.size;
        viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
        myInstructorSelectionPopoverController=viewcontroller.popoverPresentationController;
        myInstructorSelectionPopoverController.delegate=self;
        myInstructorSelectionPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
        myInstructorSelectionPopoverController.sourceView=sender;
        myInstructorSelectionPopoverController.sourceRect=sender.bounds;
        
        [self presentViewController:viewcontroller animated:YES completion:nil];
        
        [self drawinstructorpointerwithoption:@"open"];
    //}
}


-(void) attendancebuttontouchupinside:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{attendanceringview.alpha = 0.0;} completion:^(BOOL finished){
        [attendanceringview removeFromSuperview];
        attendanceringview=nil;
        [self.mainSlideMenu enableSlidePanGestureForLeftMenu];
        ClassScheduleTable.scrollEnabled=TRUE;
        [ClassScheduleTable deselectRowAtIndexPath:[ClassScheduleTable indexPathForSelectedRow] animated: YES];
        [ClassScheduleTable addGestureRecognizer:clpgr];
    }];
    

}

-(void) attendancebuttontouchdown:(UIButton *)sender
{
    //in case if there is any freeze ring remain previously
    if (attendanceringview) {
        [attendanceringview removeFromSuperview];
        attendanceringview=nil;
    }else{
        if (!editattendanceviewopened) {
            [ClassScheduleTable removeGestureRecognizer:clpgr];
            
            ClassScheduleTable.scrollEnabled=FALSE;
            //CGPoint point = [sender.superview convertPoint:CGPointZero toView:ClassScheduleTable];
        NSIndexPath *indexpath =[NSIndexPath indexPathForRow:sender.tag inSection:0];
            
            
            [ClassScheduleTable selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
            
            [self.mainSlideMenu disableSlidePanGestureForLeftMenu];
            
                ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:indexpath.row];

            
            if ([ClassScheduleObject.classtype isEqualToString:@"Makeup"]) {
                attendancebuttonarray=[[NSMutableArray alloc]initWithArray:makeupdtattendancebuttonarray];
                attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:ClassScheduleObject.makeupattendance highlightbutton:ClassScheduleObject.makeupattendance attendancebuttonarray:attendancebuttonarray inview:self.view size:@"large"];
            }else if ([ClassScheduleObject.classtype isEqualToString:@"Trial"] || [ClassScheduleObject.classtype isEqualToString:@"Assessment"]) {
                attendancebuttonarray=[[NSMutableArray alloc]initWithArray:makeupdtattendancebuttonarray];
                attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:ClassScheduleObject.attendance highlightbutton:ClassScheduleObject.attendance attendancebuttonarray:attendancebuttonarray inview:self.view size:@"large"];
            }else{
                attendancebuttonarray=[[NSMutableArray alloc]initWithArray:regularattendancebuttonarray];
                attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:ClassScheduleObject.attendance highlightbutton:ClassScheduleObject.attendance attendancebuttonarray:attendancebuttonarray inview:self.view size:@"large"];
            }
            
            [supermasterview addSubview:attendanceringview];
            lasttouchedsector=0;
        }
    }
}


-(void) selectclassroom:(UIButton *)sender
{
    ClassroomSelectionTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    ClassroomSelectionTable.separatorColor=[UIColor clearColor];
    ClassroomSelectionTable.delegate=self;
    ClassroomSelectionTable.dataSource=self;
    ClassroomSelectionTable.sectionHeaderHeight=0;
    ClassroomSelectionTable.sectionFooterHeight=0;
    [ClassroomSelectionTable reloadData];
    ClassroomSelectionTable.frame=CGRectMake(0, 0, 260, ClassroomSelectionTable.contentSize.height-35>maxselectiontableheight?maxselectiontableheight:ClassroomSelectionTable.contentSize.height-35);
    ClassroomSelectionTable.separatorColor=[UIColor clearColor];
    
    //UIView *classSelectionMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, ClassroomSelectionTable.frame.size.height)];
    //[classSelectionMasterView addSubview:ClassroomSelectionTable];
    
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=ClassroomSelectionTable;
    viewcontroller.preferredContentSize=ClassroomSelectionTable.frame.size;
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myClassroomSelectionPopoverController=viewcontroller.popoverPresentationController;
    myClassroomSelectionPopoverController.delegate=self;
    myClassroomSelectionPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myClassroomSelectionPopoverController.sourceView=sender;
    myClassroomSelectionPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    [self drawclassroompointerwithoption:@"open"];
    
}

-(void) selectclasstype:(UIButton *)sender
{
    
    
    // add group selection tables
    ClassTypeSelectionTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    ClassTypeSelectionTable.separatorColor=[UIColor clearColor];
    ClassTypeSelectionTable.sectionFooterHeight=0;
    ClassTypeSelectionTable.sectionHeaderHeight=0;
    ClassTypeSelectionTable.delegate=self;
    ClassTypeSelectionTable.dataSource=self;
    [ClassTypeSelectionTable reloadData];
    ClassTypeSelectionTable.frame=CGRectMake(0, 0, 200, ClassTypeSelectionTable.contentSize.height-35>maxselectiontableheight?maxselectiontableheight:ClassTypeSelectionTable.contentSize.height-35);
    ClassTypeSelectionTable.separatorColor=[UIColor clearColor];
    
    //UIView *classTypeSelectionMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, ClassTypeSelectionTable.contentSize.height)];
    //[classTypeSelectionMasterView addSubview:ClassTypeSelectionTable];
    
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=ClassTypeSelectionTable;
    viewcontroller.preferredContentSize=ClassTypeSelectionTable.frame.size;
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myClassTypeSelectionPopoverController=viewcontroller.popoverPresentationController;
    myClassTypeSelectionPopoverController.delegate=self;
    myClassTypeSelectionPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myClassTypeSelectionPopoverController.sourceView=sender;
    myClassTypeSelectionPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    [self drawclasstypepointerwithoption:@"open"];
}


-(void) drawsubjectpointerwithoption:(NSString *)option
{
    if (subjectpointer) {
        [subjectpointer removeFromSuperlayer];
    }
    
    CGFloat xposition;
    CGFloat yposition;
    
    CGFloat width;
    CGFloat height;
    
    CGFloat offset;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation==UIDeviceOrientationPortrait) {
        offset=23;
        width=12;
        height=4.8;
    }else{
        offset=30;
        width=15;
        height=6;
    }
    
    if ([option isEqualToString:@"closed"]) {
        yposition=12;
        xposition=ClassSelectionButton.frame.size.width-offset;
        
        subjectpointer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,NULL,xposition,yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
        CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
        CGPathAddLineToPoint(path, NULL, xposition, yposition);
        
        [subjectpointer setPath:path];
        subjectpointer.strokeColor = [UIColor whiteColor].CGColor;
        subjectpointer.lineWidth = 1.0f;
        [[ClassSelectionButton layer] addSublayer:subjectpointer];
        
        CGPathRelease(path);
    }else{
        yposition=12+height;
        xposition=ClassSelectionButton.frame.size.width-offset;
        
        subjectpointer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,NULL,xposition,yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
        CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
        CGPathAddLineToPoint(path, NULL, xposition, yposition);
        
        [subjectpointer setPath:path];
        subjectpointer.strokeColor = [UIColor whiteColor].CGColor;
        subjectpointer.lineWidth = 1.0f;
        [[ClassSelectionButton layer] addSublayer:subjectpointer];
        
        CGPathRelease(path);
    }
    
    
}

-(void) drawclassroompointerwithoption:(NSString *)option
{
    if (classroompointer) {
        [classroompointer removeFromSuperlayer];
    }
    
    CGFloat xposition;
    CGFloat yposition;
    
    CGFloat width;
    CGFloat height;
    
    CGFloat offset;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation==UIDeviceOrientationPortrait) {
        offset=23;
        width=12;
        height=4.8;
    }else{
        offset=30;
        width=15;
        height=6;
    }
    
    if ([option isEqualToString:@"closed"]) {
        yposition=12;
        xposition=ClassroomSelectionButton.frame.size.width-offset;
        
        classroompointer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,NULL,xposition,yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
        CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
        CGPathAddLineToPoint(path, NULL, xposition, yposition);
        
        [classroompointer setPath:path];
        classroompointer.strokeColor = [UIColor whiteColor].CGColor;
        classroompointer.lineWidth = 1.0f;
        [[ClassroomSelectionButton layer] addSublayer:classroompointer];
        
        CGPathRelease(path);
    }else{
        yposition=12+height;
        xposition=ClassroomSelectionButton.frame.size.width-offset;
        
        classroompointer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,NULL,xposition,yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
        CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
        CGPathAddLineToPoint(path, NULL, xposition, yposition);
        
        [classroompointer setPath:path];
        classroompointer.strokeColor = [UIColor whiteColor].CGColor;
        classroompointer.lineWidth = 1.0f;
        [[ClassroomSelectionButton layer] addSublayer:classroompointer];
        
        CGPathRelease(path);
    }
    
    
}

-(void) drawinstructorpointerwithoption:(NSString *)option
{
    if (instructorpointer) {
        [instructorpointer removeFromSuperlayer];
    }
    
    //if (!instructoronlyview) {
        CGFloat xposition;
        CGFloat yposition;
        
        CGFloat width;
        CGFloat height;
        
        CGFloat offset;
        
        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
        if (orientation==UIDeviceOrientationPortrait) {
            offset=23;
            width=12;
            height=4.8;
        }else{
            offset=30;
            width=15;
            height=6;
        }
        
        if ([option isEqualToString:@"closed"]) {
            yposition=12;
            xposition=InstructorSelectionButton.frame.size.width-offset;
            
            instructorpointer = [CAShapeLayer layer];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path,NULL,xposition,yposition);
            CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
            CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
            CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
            CGPathAddLineToPoint(path, NULL, xposition, yposition);
            
            [instructorpointer setPath:path];
            instructorpointer.strokeColor = [UIColor whiteColor].CGColor;
            instructorpointer.lineWidth = 1.0f;
            [[InstructorSelectionButton layer] addSublayer:instructorpointer];
            
            CGPathRelease(path);
        }else{
            yposition=12+height;
            xposition=InstructorSelectionButton.frame.size.width-offset;
            
            instructorpointer = [CAShapeLayer layer];
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path,NULL,xposition,yposition);
            CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
            CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
            CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
            CGPathAddLineToPoint(path, NULL, xposition, yposition);
            
            [instructorpointer setPath:path];
            instructorpointer.strokeColor = [UIColor whiteColor].CGColor;
            instructorpointer.lineWidth = 1.0f;
            [[InstructorSelectionButton layer] addSublayer:instructorpointer];
            
            CGPathRelease(path);
        }
    //}

    
    
}

-(void) drawclasstypepointerwithoption:(NSString *)option
{
    if (classtypepointer) {
        [classtypepointer removeFromSuperlayer];
    }
    
    CGFloat xposition;
    CGFloat yposition;
    
    CGFloat width;
    CGFloat height;
    
    CGFloat offset;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation==UIDeviceOrientationPortrait) {
        offset=23;
        width=12;
        height=4.8;
    }else{
        offset=30;
        width=15;
        height=6;
    }
    
    if ([option isEqualToString:@"closed"]) {
        
        yposition=12;
        xposition=ClassTypeSelectionButton.frame.size.width-offset;
        
        classtypepointer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,NULL,xposition,yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
        CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
        CGPathAddLineToPoint(path, NULL, xposition, yposition);
        
        [classtypepointer setPath:path];
        classtypepointer.strokeColor = [UIColor whiteColor].CGColor;
        classtypepointer.lineWidth = 1.0f;
        [[ClassTypeSelectionButton layer] addSublayer:classtypepointer];
        
        CGPathRelease(path);
    }else{
        yposition=12+height;
        xposition=ClassTypeSelectionButton.frame.size.width-offset;
        
        classtypepointer = [CAShapeLayer layer];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,NULL,xposition,yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
        CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
        CGPathAddLineToPoint(path, NULL, xposition, yposition);
        
        [classtypepointer setPath:path];
        classtypepointer.strokeColor = [UIColor whiteColor].CGColor;
        classtypepointer.lineWidth = 1.0f;
        [[ClassTypeSelectionButton layer] addSublayer:classtypepointer];
        
        CGPathRelease(path);
    }
    
    
}



- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverController {
    if (popoverController == myClassSelectionPopoverController) {
        [self drawsubjectpointerwithoption:@"closed"];
    }else if (popoverController==myClassTypeSelectionPopoverController){
        [self drawclasstypepointerwithoption:@"closed"];
    }else if (popoverController==myInstructorSelectionPopoverController){
        [self drawinstructorpointerwithoption:@"closed"];
    }else if (popoverController==myClassroomSelectionPopoverController){
        [self drawclassroompointerwithoption:@"closed"];
    }/*else if (popoverController==myStudentPopoverController){
        [self performSelector:@selector(refreshtable) withObject:nil afterDelay:0];
    }*/else if (popoverController==mypopovercontroller){
        if (!editattendanceviewopened) {
            [self performSelector:@selector(refreshtable) withObject:nil afterDelay:0];
        }
    }
}




- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *emailresult;
    switch (result) {
        case MFMailComposeResultSent:
            emailresult=[MyClass returntitlewithtitle:@"Email sent"];
            break;
        case MFMailComposeResultSaved:
            emailresult=[MyClass returntitlewithtitle:@"You saved a draft of this email"];
            break;
        case MFMailComposeResultCancelled:
            emailresult=[MyClass returntitlewithtitle:@"You cancelled sending this email"];
            break;
        case MFMailComposeResultFailed:
            emailresult=[MyClass returntitlewithtitle:@"Mail failed:  An error occurred when trying to compose this email"];
            break;
        default:
            emailresult=[MyClass returntitlewithtitle:@"An error occurred when trying to compose this email"];
            break;
    }
    
    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Payment Receipt"]  message:emailresult preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [erroralert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [erroralert addAction:OKAction];
    [self presentViewController:erroralert animated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(NSMutableArray *) returninstructorselectionarray:(NSMutableArray *)instructorusernameselectionarray
{
    NSMutableArray *instructorselectionarray=[[NSMutableArray alloc]init];
    for (int i=0; i<instructorusernameselectionarray.count; i++) {
        [instructorselectionarray addObject:[MyClass returninstructornamewithusername:[instructorusernameselectionarray objectAtIndex:i] firstorfullname:@"full"]];
    }
    return instructorselectionarray;
}

-(void) enrollATLeadStudent:(AssessmentTrialRecord *)ATRecord
{
    [self closesidewindow];
    
    /*
    if (self.myDTPopoverController && self.myDTPopoverController.popoverVisible){
        [self.myDTPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    }*/
    /*
    StudentInformationViewController *viewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformationViewController"];
    viewcontroller.StudentInformationAction=@"EnrollATLeadStudent";
    viewcontroller.StudentInformationATObject=ATRecord;//DTObject;
    [self presentViewController:viewcontroller animated:YES completion:nil];*/
    
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    mainVC.leftMenu.prepareforsegue=TRUE;
    mainVC.leftMenu.sourceview=@"classschedule";
    mainVC.leftMenu.studentinformationaction=@"EnrollATLeadStudent";
    mainVC.leftMenu.studentinformationatobject=ATRecord;
    globalvariables.leftmenuindex=@"1";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
}

-(BOOL) checkifinstructorexistwithinstructorarray:(NSMutableArray *)instructorarray username:(NSString *)username
{
    for (int i=0; i<instructorarray.count; i++) {
        if ([((Instructor *)[instructorarray objectAtIndex:i]).username isEqualToString:username]) {
            return TRUE;
        }
    }
    return FALSE;
}

-(void) addlessonclasswithclassschedulerecord:(ClassScheduleRecord *)classschedulerecord
{
    if ([viewmode isEqualToString:@"class"]) {
        if (LessonClassRecordArray.count==0) {
            [LessonClassRecordArray addObject:[[LessonAndClassRecord alloc]initLessonAndClassRecordwithLesson:nil ClassScheduleRecordArray:[[NSMutableArray alloc]initWithObjects:classschedulerecord, nil]]];
        }else{
            [((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:0]).classScheduleRecordArray addObject:classschedulerecord];
        }
    }else{
        NSString *tmplessonkeyfromclassschedule;
        NSString *tmplessonkeyfromlessonrecord;
        NSString *tmpclassduration;
        NSString *existingclassduration;
        NSString *subjectorcategory;
        NSString *subjecttype;
        NSString *subjectcategory=[MyClass returnsubjectcategorywithsubject:classschedulerecord.subject centerkey:globalvariables.centerrecord.centerkey];
        
        tmpclassduration=classschedulerecord.classduration;
        if (groupsubjectcategory && ![subjectcategory isEqualToString:@""]) {
            subjectorcategory=subjectcategory;
            subjecttype=@"category";
        }else{
            subjecttype=@"subject";
            subjectorcategory=classschedulerecord.subject;
        }
        
        if ([classschedulerecord.classtype isEqualToString:@"Makeup"]) {
            tmplessonkeyfromclassschedule=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",classschedulerecord.makeupdate,classschedulerecord.makeuptime,subjectorcategory,classschedulerecord.makeupinstructor,classschedulerecord.makeupclassroom,globalvariables.centerrecord.secondaryinstructor?classschedulerecord.makeupsinstructor:@"",tmpclassduration];
        }else{
            tmplessonkeyfromclassschedule=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",classschedulerecord.startdate,classschedulerecord.classtime,subjectorcategory,classschedulerecord.instructor,classschedulerecord.classroom,globalvariables.centerrecord.secondaryinstructor?classschedulerecord.sinstructor:@"",tmpclassduration];
        }
        
        for (long i=0; i<LessonClassRecordArray.count; i++) {
            LessonAndClassRecord *lacobj=[LessonClassRecordArray objectAtIndex:i];
            LessonRecord *lobj=lacobj.lesson;
            tmplessonkeyfromlessonrecord=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",lobj.classdate,lobj.classtime,lobj.subject,lobj.instructor,lobj.classroom,globalvariables.centerrecord.secondaryinstructor?lobj.sinstructor:@"",lobj.classduration];
            
            //add classschedule to existing lesson record
            if ([tmplessonkeyfromclassschedule isEqualToString:tmplessonkeyfromlessonrecord]) {
                [lacobj.classScheduleRecordArray addObject:classschedulerecord];
                lobj.classcount =[NSString stringWithFormat:@"%lli",[lobj.classcount longLongValue]+1];
                
                //update class duration
                existingclassduration=lobj.classduration;
                if ([tmpclassduration intValue]>[existingclassduration intValue]) {
                    lobj.classduration=tmpclassduration;
                }
                
                return;
            }
        }
        
        //create new lesson record
        if ([classschedulerecord.classtype isEqualToString:@"Makeup"]) {
            [LessonClassRecordArray addObject:[[LessonAndClassRecord alloc]initLessonAndClassRecordwithLesson:[[LessonRecord alloc]initLessonRecordwithlessonkey:nil classdate:classschedulerecord.makeupdate classtime:classschedulerecord.makeuptime subject:subjectorcategory instructor:classschedulerecord.makeupinstructor classroom:classschedulerecord.makeupclassroom classcount:@"1" subjecttype:subjecttype checkouttime:nil remarks:nil classduration:tmpclassduration sinstructor:classschedulerecord.makeupsinstructor] ClassScheduleRecordArray:[[NSMutableArray alloc]initWithObjects:classschedulerecord, nil]]];
        }else{
            [LessonClassRecordArray addObject:[[LessonAndClassRecord alloc]initLessonAndClassRecordwithLesson:[[LessonRecord alloc]initLessonRecordwithlessonkey:nil classdate:classschedulerecord.startdate classtime:classschedulerecord.classtime subject:subjectorcategory instructor:classschedulerecord.instructor classroom:classschedulerecord.classroom classcount:@"1" subjecttype:subjecttype checkouttime:nil remarks:nil classduration:tmpclassduration sinstructor:classschedulerecord.sinstructor] ClassScheduleRecordArray:[[NSMutableArray alloc]initWithObjects:classschedulerecord, nil]]];
        }
        
        

    }
}

-(UIView *) drawclasstimewithtime:(NSString *)classtime cgrect:(CGRect)cgrect
{
    UIView *classtimeicon=[[UIView alloc]initWithFrame:cgrect];
    
    CAShapeLayer *drawobject = [CAShapeLayer layer];
    
    drawobject = [CAShapeLayer layer];
    [drawobject setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, cgrect.size.width, cgrect.size.width)] CGPath]];
    [drawobject setStrokeColor:[[UIColor lightGrayColor] CGColor]];
    [drawobject setFillColor:[[UIColor whiteColor] CGColor]];
    [[classtimeicon layer] addSublayer:drawobject];
    
    float minute=[[classtime substringFromIndex:3] floatValue];
    float hour=[[classtime substringToIndex:2] intValue] % 12;
    float shortminutehandlength=cgrect.size.width/20;
    float longminutehandlength=cgrect.size.width/2.5;
    float shorthourhandlength=cgrect.size.width/20;
    float longhourhandlength=cgrect.size.width/4;
    float minuteangle=minute/60*360* M_PI/180;
    float hourangle=(hour/12+minute/60/12)*360*M_PI/180;

    CGFloat x0position;
    CGFloat y0position;
    CGFloat x1position;
    CGFloat y1position;
    
    x1position=longminutehandlength*sinf(minuteangle)+cgrect.size.width/2;
    y1position=-longminutehandlength*cosf(minuteangle)+cgrect.size.width/2;
    x0position=-shortminutehandlength*sinf(minuteangle)+cgrect.size.width/2;
    y0position=shortminutehandlength*cosf(minuteangle)+cgrect.size.width/2;
    
    drawobject = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,x0position,y0position);
    CGPathAddLineToPoint(path, NULL, x1position, y1position);
    //CGPathAddLineToPoint(path, NULL, x0position, y0position);
    
    [drawobject setPath:path];
    drawobject.strokeColor = [UIColor blackColor].CGColor;
    drawobject.lineWidth = 1.5f;
    [[classtimeicon layer] addSublayer:drawobject];
    CGPathRelease(path);
    
    x1position=longhourhandlength*sinf(hourangle)+cgrect.size.width/2;
    y1position=-longhourhandlength*cosf(hourangle)+cgrect.size.width/2;
    x0position=-shorthourhandlength*sinf(hourangle)+cgrect.size.width/2;
    y0position=shorthourhandlength*cosf(hourangle)+cgrect.size.width/2;
    
    drawobject = [CAShapeLayer layer];
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,x0position,y0position);
    CGPathAddLineToPoint(path, NULL, x1position, y1position);
    //CGPathAddLineToPoint(path, NULL, x0position, y0position);
    
    [drawobject setPath:path];
    drawobject.strokeColor = [UIColor blackColor].CGColor;
    drawobject.lineWidth = 2.0f;
    [[classtimeicon layer] addSublayer:drawobject];
    CGPathRelease(path);
    


    return classtimeicon;
    
}


-(void) attendanceringreleasedwithtouchpoint:(CGPoint)touchpoint
{
    //check if inside ring
    if ([MyClass returntouchpointwithinattendanceringwithtouchpoint:touchpoint size:@"large"]) {
        NSIndexPath *selectedIndexPath = [ClassScheduleTable indexPathForSelectedRow];
        [self updateattendancewithindexpath:selectedIndexPath value:((AttendanceButtonObject *)[attendancebuttonarray objectAtIndex:lasttouchedsector]).buttonname];
    }
    [ClassScheduleTable addGestureRecognizer:clpgr];
}

-(void) returnsortingarray
{
    sortingarray=[MyClass returnsortingarraywithtype:@"dailyclassschedulelistsortingorder"];
}


-(void) sortingbuttonpressed:(UIButton *)sender
{
    
    [self returnsortingarray];
    
    sortingtable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    sortingtable.delegate=self;
    sortingtable.dataSource=self;
    sortingtable.scrollEnabled=NO;
    sortingtable.editing=YES;
    [sortingtable reloadData];
    
    sortingtable.frame=CGRectMake(0, 0, 220, sortingtable.contentSize.height);
    UIView *sortingview=[[UIView alloc]initWithFrame:sortingtable.frame];
    [sortingview addSubview:sortingtable];
    
    UIViewController *sortingvc=[[UIViewController alloc]init];
    sortingvc.preferredContentSize=CGSizeMake(sortingview.frame.size.width, sortingview.frame.size.height);
    sortingvc.view=sortingview;
    
    sortingvc.modalPresentationStyle=UIModalPresentationPopover;
    mypopovercontroller=sortingvc.popoverPresentationController;
    mypopovercontroller.delegate=self;
    mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionUp;
    mypopovercontroller.sourceView=sender;
    mypopovercontroller.sourceRect=sender.bounds;
    
    [self presentViewController:sortingvc animated:YES completion:nil];
    

    
}

-(NSString *) returnsortinglabelwithitem:(NSString *)item
{
    if ([item isEqualToString:@"realclasstime"]) {
        return @"Time";
    }else if ([item isEqualToString:@"subjectfullname"]) {
        return @"Subject";
    }else if ([item isEqualToString:@"instructorfullname"]) {
        return @"Instructor";
    }else if ([item isEqualToString:@"realclassroom"]) {
        return @"Classroom";
    }else if ([item isEqualToString:@"studentdisplayname"]) {
        return @"Student Name";
    }
    return item;
}

-(BOOL) validateclassallpassed
{
    return validateclassarray.count==0;

}


-(void) passfreeclassscheduleforlessonmove:(FreeScheduleClass *)freescheduleclass updatefollowinglessons:(BOOL)updatefollowinglessons updatefollowinglessonsfields:(NSMutableArray *)updatefollowinglessonsfields
{
    [self closesidewindow];
    selectedAttendanceStatus=nil;
    freescheduleclassobject=freescheduleclass;
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    return_freescheduleclass=freescheduleclass;
    return_updatefollowinglessons=updatefollowinglessons;
    return_updatefollowinglessonsfields=updatefollowinglessonsfields;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if([self validateAndMoveLessonWithfreescheduleclass:freescheduleclass validationcheck:YES updatefollowinglessons:updatefollowinglessons updatefollowinglessonsfields:updatefollowinglessonsfields]){
            if ([self validateclassallpassed]) {
                
                NSString *subjectorcategory;
                NSString *subjectcategory=[MyClass returnsubjectcategorywithsubject:freescheduleclass.subject centerkey:globalvariables.centerrecord.centerkey];
                SubjectRecord *object=[MyClass returnsubjectinformationwithsubject_shortname:freescheduleclass.subject centerkey:globalvariables.centerrecord.centerkey];
                NSString *duration;
                if([freescheduleclass.classtype isEqualToString:@"assessment"]){
                    duration=object.classduration_assessment;
                }else if ([freescheduleclass.classtype isEqualToString:@"trial"]){
                    duration=object.classduration_trial;
                }else{
                    duration=object.classduration;
                }
                if (groupsubjectcategory && ![subjectcategory isEqualToString:@""]) {
                    subjectorcategory=subjectcategory;
                }else{
                    subjectorcategory=freescheduleclass.subject;
                }

                NSString *tmplessonkey=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",freescheduleclass.makeupdate,freescheduleclass.makeuptime,subjectorcategory,freescheduleclass.makeupinstructor,freescheduleclass.makeupclassroom,globalvariables.centerrecord.secondaryinstructor?freescheduleclassobject.makeupsinstructor:@"",duration];
                
                if ([freescheduleclass.makeupdate isEqualToString:selecteddate]) {
                    selectedLessonKey=tmplessonkey;
                }else{
                    selectedLessonKey=nil;
                }
                
                //success messsage
                UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"All Classes have been updated"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [successalert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [successalert addAction:OKAction];
                [self presentViewController:successalert animated:YES completion:nil];
            }else{
                //partial success message
                UIAlertController *notsuccessalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Some classes were not able to be updated. Please tap on the warning icon to see the details"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [notsuccessalert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [notsuccessalert addAction:OKAction];
                [self presentViewController:notsuccessalert animated:YES completion:nil];
            }
            
            [self retrieveClassScheduleWithclassdate:selecteddate];
        }else{
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        }
    });
}

-(FreeScheduleClass *) returnmovelessonfreescheduleclasswithclassschedule:(ClassScheduleRecord *)classscheduleobject freescheduleclass:(FreeScheduleClass *)freescheduleclass
{
    FreeScheduleClass *freescheduleclass_object=[[FreeScheduleClass alloc]init];
    
    freescheduleclass_object.subject=classscheduleobject.subject;
    freescheduleclass_object.classdate=freescheduleclass.classdate;
    freescheduleclass_object.classtime=freescheduleclass.classtime;
    freescheduleclass_object.instructor=freescheduleclass.instructor;
    freescheduleclass_object.classroom=freescheduleclass.classroom;
    freescheduleclass_object.attendance=classscheduleobject.attendance;
    freescheduleclass_object.makeupdate=freescheduleclass.makeupdate;
    freescheduleclass_object.makeuptime=freescheduleclass.makeuptime;
    freescheduleclass_object.makeupinstructor=freescheduleclass.makeupinstructor;
    freescheduleclass_object.makeupsinstructor=freescheduleclass.makeupsinstructor;
    freescheduleclass_object.makeupclassroom=freescheduleclass.makeupclassroom;
    freescheduleclass_object.makeupattendance=freescheduleclass.makeupattendance;
    freescheduleclass_object.classremarks=freescheduleclass.classremarks;
    freescheduleclass_object.allclassremarks=freescheduleclass.allclassremarks;
    freescheduleclass_object.action=freescheduleclass.action;
    freescheduleclass_object.classtype=classscheduleobject.classtype;
    freescheduleclass_object.leavenaturelistkey=freescheduleclass.leavenaturelistkey;
//    freescheduleclass_object.lesson=freescheduleclass.lesson;
    freescheduleclass_object.lesson=freescheduleclass.lesson?freescheduleclass.lesson:classscheduleobject.lesson;
    
    if ([freescheduleclass_object.classtype isEqualToString:@"Assessment"] ||[freescheduleclass_object.classtype isEqualToString:@"Trial"]  ) {
        freescheduleclass_object.classkey=classscheduleobject.dtkey;
    }else{
        freescheduleclass_object.classkey=classscheduleobject.classkey;
    }
    
    return freescheduleclass_object;
}

-(BOOL) validateAndMoveLessonWithfreescheduleclass:(FreeScheduleClass *)freescheduleclass validationcheck:(BOOL)validationcheck  updatefollowinglessons:(BOOL)updatefollowinglessons updatefollowinglessonsfields:(NSMutableArray *)updatefollowinglessonsfields
{
    NSMutableArray *FreeScheduleArray=[[NSMutableArray alloc]init];
    NSMutableArray *studentkeyarray=[[NSMutableArray alloc]init];

    FreeScheduleClass *freescheduleclass_object;

    long lessonclassrecordindex=[self returnLessonIndex];
    NSMutableArray *classschedulearray=((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:lessonclassrecordindex]).classScheduleRecordArray;
    LessonRecord *lessonrecord=((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:lessonclassrecordindex]).lesson;
    
    if ([self isMoveToOtherLessonWithFreeScheduleClass:freescheduleclass Lesson:lessonrecord]) {
        for (int i=0; i<[classschedulearray count]; i++) {

            ClassScheduleObject=[classschedulearray objectAtIndex:i];
            freescheduleclass_object=[self returnmovelessonfreescheduleclasswithclassschedule:ClassScheduleObject freescheduleclass:freescheduleclass];

                    
                    [FreeScheduleArray addObject:freescheduleclass_object];
                    [studentkeyarray addObject:ClassScheduleObject.studentkey];

        }
        
        validateclassarray=[MyClass validateAndMoveLessonWithFreeScheduleArray:FreeScheduleArray studentkeyarray:studentkeyarray validationcheck:validationcheck updatefollowinglessons:updatefollowinglessons updatefollowinglessonsfields:updatefollowinglessonsfields];
        return TRUE;
    }else{
        if (freescheduleclass.classremarks || freescheduleclass.lesson) {
            [self updateclasseswithclassschedulearray:classschedulearray remarks:freescheduleclass.classremarks lesson:freescheduleclass.lesson];
            return TRUE;
        }
    }
    return FALSE;
}

-(BOOL) isMoveToOtherLessonWithFreeScheduleClass:(FreeScheduleClass *)freescheduleclass Lesson:(LessonRecord *)lesson
{
    if (![lesson.classdate isEqualToString:freescheduleclass.makeupdate]) {
        return TRUE;
    }else if (![lesson.classtime isEqualToString:freescheduleclass.makeuptime]) {
        return TRUE;
    }else if (![lesson.instructor isEqualToString:freescheduleclass.makeupinstructor]) {
        return TRUE;
    }else if (![lesson.classroom isEqualToString:freescheduleclass.makeupclassroom]) {
        return TRUE;
    }else if (![[lesson.sinstructor isEqualToString:@""]?@"TBD":lesson.sinstructor isEqualToString:freescheduleclass.makeupsinstructor]) {
        return TRUE;
    }
    
    return FALSE;
}


-(void) moveIndividualLessonWithfreescheduleclass:(FreeScheduleClass *)freescheduleclass
{
    NSString *tmpremarks;
    //NSString *strURL;
    
    if ([freescheduleclass.classremarks isEqualToString:@""]) {
        tmpremarks=ClassScheduleObject.remarks;
    }else{
        if ([ClassScheduleObject.remarks isEqualToString:@""]) {
            tmpremarks=freescheduleclass.classremarks;
        }else{
            tmpremarks=[NSString stringWithFormat:@"%@, %@",freescheduleclass.classremarks,ClassScheduleObject.remarks];
        }
    }
    
    //reset attendance for all classes
    
    NSString *fs_classdate;
    NSString *fs_classtime;
    NSString *fs_instructor;
    NSString *fs_classroom;
    
    if ([freescheduleclass.attendance isEqualToString:@"Makeup"]) {
        fs_classdate=freescheduleclass.makeupdate;
        fs_classtime=freescheduleclass.makeuptime;
        fs_instructor=freescheduleclass.makeupinstructor;
        fs_classroom=freescheduleclass.makeupclassroom;
    }else{
        fs_classdate=freescheduleclass.classdate;
        fs_classtime=freescheduleclass.classtime;
        fs_instructor=freescheduleclass.instructor;
        fs_classroom=freescheduleclass.classroom;
    }
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    
    
        if ([ClassScheduleObject.classtype isEqualToString:@"Makeup"]){
            [dictionary setValue:@"updateclassv2" forKey:@"postaction"];
            [dictionary setValue:ClassScheduleObject.classkey forKey:@"classkey"];
            [dictionary setValue:[MyClass convertDateFormatWithDate:fs_classdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO] forKey:@"makeupdate"];
            [dictionary setValue:fs_classtime forKey:@"makeuptime"];
            [dictionary setValue:fs_instructor forKey:@"makeupinstructor"];
            [dictionary setValue:fs_classroom forKey:@"makeupclassroom"];
            [dictionary setValue:tmpremarks forKey:@"remarks"];
            [dictionary setValue:@"movelesson" forKey:@"trigger"];

        }else if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]){
            [dictionary setValue:@"updatedt" forKey:@"postaction"];
            [dictionary setValue:ClassScheduleObject.dtkey forKey:@"dtkey"];
            [dictionary setValue:[MyClass convertDateFormatWithDate:fs_classdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO] forKey:@"dtdate"];
            [dictionary setValue:fs_classtime forKey:@"dttime"];
            [dictionary setValue:fs_instructor forKey:@"instructor"];
            [dictionary setValue:fs_classroom forKey:@"classroom"];
            [dictionary setValue:tmpremarks forKey:@"remarks"];
            [dictionary setValue:@"movelesson" forKey:@"trigger"];

        }else if ([ClassScheduleObject.classtype isEqualToString:@"Class"]){
            [dictionary setValue:@"updateclassv2" forKey:@"postaction"];
            [dictionary setValue:ClassScheduleObject.classkey forKey:@"classkey"];
            [dictionary setValue:[MyClass convertDateFormatWithDate:fs_classdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO] forKey:@"startdate"];
            [dictionary setValue:fs_classtime forKey:@"classtime"];
            [dictionary setValue:fs_instructor forKey:@"instructor"];
            [dictionary setValue:fs_classroom forKey:@"classroom"];
            [dictionary setValue:tmpremarks forKey:@"remarks"];
            [dictionary setValue:@"movelesson" forKey:@"trigger"];
        }
    //}
    

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
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveClassScheduleWithclassdate:selecteddate];
        });
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
}

-(long) returnlessonclassrecordarrayindex:(NSString *)tmpLessonkey{
    for (int i=0; i<LessonClassRecordArray.count; i++) {
        NSString *tmplessonkey=[NSString stringWithFormat:@"%@%@%@%@%@%@%@",((LessonRecord *)((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:i]).lesson).classdate,((LessonRecord *)((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:i]).lesson).classtime,((LessonRecord *)((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:i]).lesson).subject,((LessonRecord *)((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:i]).lesson).instructor,((LessonRecord *)((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:i]).lesson).classroom,globalvariables.centerrecord.secondaryinstructor?((LessonRecord *)((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:i]).lesson).sinstructor:@"",((LessonRecord *)((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:i]).lesson).classduration];
        if ([tmplessonkey isEqualToString:tmpLessonkey]) {
            return i;
        }
    }
    return 0;
}

-(void) warningbuttonpressed:(UIButton *)sender
{
    sender.enabled=NO;
    warningbuttonselected=sender;
    ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:sender.tag];

    ClassValidateRecord *classvalidaterecord=[self returnClassValidateRecordWithClassScheduleObject:ClassScheduleObject];
    classvalidatemessage=classvalidaterecord.classvalidatemessage;
    classvalidatestatus=classvalidaterecord.classvalidatestatus;
    
    [self checkvalidatemessage];
}



-(void) switchcenterbuttonpressed
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyClass getLatestDataSetv2withParameters:@"" Centerkeys:@"" completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
            if (!nocenteravailable && !newupdateavailable) {
                dispatch_async(dispatch_get_main_queue(), ^{
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                switchcenterviewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
                switchcenterviewcontroller.singleselection=@"Yes";
                switchcenterviewcontroller.updatecenterkey=@"Yes";
                [self presentViewController:switchcenterviewcontroller animated:YES completion: nil];
                });
            }
        }];
    });
    
    
    

}

-(void) doneswitchcenterwithreload:(BOOL)reload centerkey:(NSString *)centerkey centerimage:(UIImage *)centerimage
{
    //[switchcenterviewcontroller dismissViewControllerAnimated:YES completion:nil];

    
    
    if (reload) {
        globalvariables.documentfolder.classreceiptarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salesreceiptarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.classinvoicearray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salesinvoicearray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.classpaymentarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salespaymentarray=[[NSMutableArray alloc]init];
        [MyClass retrievemenuimagewithasync:YES];
        [self reloadPageWithFirstLoad:NO];
        

    }
}

/*
-(void) refreshpage
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (editattendanceviewopened) {
            editattendanceviewopened=FALSE;
            [self openeditattendanceview:editattendanceviewopened];
        }
        [MyClass retrievemenuimagewithasync:YES];
        [MyClass retrievecenterimages];
        //[self loadcalendar];
        [MyClass updatecenterkey];
        [self viewDidAppear:YES];
        
        
    });
}*/

-(void) reloadPageWithFirstLoad:(BOOL)firstload
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        

            [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,staff,classroom,centersettings,userroleandprivilege,student,lead,leavenature,marketing,arcode" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
                dispatch_async(dispatch_get_main_queue(), ^{
                if (newupdateavailable) {
                    [MyClass loadingindicatorwithoption:@"stop" color:nil];
                    return;
                }else if (nocenteravailable){
                    [MyClass loadingindicatorwithoption:@"stop" color:nil];
                    return;
                }else if (viewingcentersdeleted) {
                    [MyClass loadingindicatorwithoption:@"stop" color:nil];
                    [self switchcenterbuttonpressed];
                }else{
                    //[MyClass showDuePaymentReminderWithViewController:self];
                    if (editattendanceviewopened) {
                        editattendanceviewopened=FALSE;
                        [self openeditattendanceview:editattendanceviewopened];
                    }
                    //[MyClass retrievemenuimagewithasync:YES];
                    //[MyClass retrievecenterimages];
                    //[self loadcalendar];
                    [MyClass updatecenterkey];
                    [self loaddatebarwithinitialload:firstload];

                    
                    //documentfolder.defaultcheckedsalespaymentsaleskeys=[[NSMutableArray alloc]init];
                    //documentfolder.defaultcheckedclasspaymentenrollmentkeys=[[NSMutableArray alloc]init];
                    //documentfolder.defaultcheckedclassinvoiceenrollmentkeys=[[NSMutableArray alloc]init];
                    //documentfolder.defaultcheckedsalesinvoicesaleskeys=[[NSMutableArray alloc]init];
                    //documentfolder.defaultcheckedclassreceiptpaymentkeys=[[NSMutableArray alloc]init];
                    //documentfolder.defaultcheckedsalesreceiptpaymentkeys=[[NSMutableArray alloc]init];
                    scanhistoryarray=[[NSMutableArray alloc]init];
                    
                    [self refreshdocumentfoldercount];
                    
                    
                    SubjectSelectionArray=[[NSMutableArray alloc]initWithObjects:[MyClass returntitlewithtitle:@"All Classes"], nil];
                    InstructorSelectionArray=[[NSMutableArray alloc]initWithObjects:[MyClass returntitlewithtitle:@"All Instructors"], nil];
                    ClassroomSelectionArray=[[NSMutableArray alloc]initWithObjects:[MyClass returntitlewithtitle:@"All Classrooms"], nil];
                    
                    
                    subjectselected=@"All";
                    classtypeselected=@"All";
                    
                    /*if ([((UserPrivilege *)[MyClass returnuserprivilegewithcenterkey:globalvariables.centerrecord.centerkey]).role isEqualToString:@"Instructor"]) {
                        instructoronlyview=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).viewallinstructorclass;
                        instructorselected=instructoronlyview?globalvariables.username:@"All";
                    }else{
                        instructoronlyview=NO;
                        instructorselected=@"All";
                    }*/
                    instructorselected=@"All";
                    //InstructorSelectionButton.enabled=YES;
                    
                    classroomselected=@"All";
                    
                    [self drawsubjectpointerwithoption:@"closed"];
                    [self drawclasstypepointerwithoption:@"closed"];
                    [self drawinstructorpointerwithoption:@"closed"];
                    [self drawclassroompointerwithoption:@"closed"];
                    
                    
                    //highlightedlessonkey=@"";
                    
                    //add buttonarray
                    regularattendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnregularattendancebuttonarray]];
                    makeupdtattendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnmakeupattendancebuttonarray]];
                    [editattendancebutton setImage:[MyClass drawattendanceringiconwithbuttonarray:regularattendancebuttonarray] forState:UIControlStateNormal];
                    
                    
                    //[MyClass LoadSchoolCalendarArray];
                    //[self retrieveCalendar];
                    [self refreshlanguage];
                    
                    NSArray *buttonarray=[MyClass returnregularattendancebuttonarray];
                    attendancePresentButton.hidden=YES;
                    attendanceUnknownButton.hidden=YES;
                    attendanceAbsentButton.hidden=YES;
                    attendanceMakeupButton.hidden=YES;
                    attendanceExtendButton.hidden=YES;
                    
                    
                    for (int i=0; i<buttonarray.count; i++) {
                        if ([((AttendanceButtonObject *)[buttonarray objectAtIndex:i]).buttonname isEqualToString:@"Present"]) {
                            attendancePresentButton.hidden=NO;
                        }else if ([((AttendanceButtonObject *)[buttonarray objectAtIndex:i]).buttonname isEqualToString:@""]) {
                            attendanceUnknownButton.hidden=NO;
                        }else if ([((AttendanceButtonObject *)[buttonarray objectAtIndex:i]).buttonname isEqualToString:@"Absent"]) {
                            attendanceAbsentButton.hidden=NO;
                        }else if ([((AttendanceButtonObject *)[buttonarray objectAtIndex:i]).buttonname isEqualToString:@"Makeup"]) {
                            attendanceMakeupButton.hidden=NO;
                        }else if ([((AttendanceButtonObject *)[buttonarray objectAtIndex:i]).buttonname isEqualToString:@"Extend"]) {
                            attendanceExtendButton.hidden=NO;
                        }
                    }
                    
                    
                    subjectArray=[MyClass retrievesubjectinformationwithstatus:@"All" category:@"All" flushcachedata:NO];
                    if (!subjectArray) {
                        reloadbutton.hidden=NO;
                        sharebutton.hidden=YES;
                        //[ailoadclass stopAnimating];
                        [MyClass loadingindicatorwithoption:@"stop" color:nil];
                        return;
                    }
                    
                    ClassroomArray=[MyClass retrieveClassroomListwithstatus:@"All" withTBD:YES flushcachedata:NO];
                    if (!ClassroomArray) {
                        reloadbutton.hidden=NO;
                        sharebutton.hidden=YES;
                        //[ailoadclass stopAnimating];
                        [MyClass loadingindicatorwithoption:@"stop" color:nil];
                        return;
                    }
                    
                    //[self loadcalendar];
                    InstructorArray=[MyClass retrieveInstructorListwithvalid:@"All" flushcachedata:NO];
                    [self retrieveClassScheduleWithclassdate:selecteddate];
                    
                    reloadbutton.hidden=YES;
                    sharebutton.hidden=NO;
                    
                    [self loadScanView];
                }
                    });
                
            }];
        //});
    });
}

-(void) loadScanView
{
    if(globalvariables.centerrecord.enablescantotakeattendance){
        scantotakeattendanceview=[[ScanAttendanceView alloc]initWithFrame:CGRectMake(0, 0, scanwindowwidth, scanwindowheight)];
        scantotakeattendanceview.delegate=self;
        scantotakeattendanceview.studentkeytext.delegate=self;
        [scantotakeattendanceview.studentkeytext setKeyboardType:UIKeyboardTypeAlphabet];
        
        scanmasterview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, scanwindowwidth+250, scanwindowheight)];
        
        UIView *scanhistoryview=[[UIView alloc]initWithFrame:CGRectMake(scanwindowwidth, 0, 250, scanwindowheight)];
        [scanmasterview addSubview:scantotakeattendanceview];
        [scanmasterview addSubview:scanhistoryview];
        
        
        scanhistorytable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, scanhistoryview.frame.size.width, scanhistoryview.frame.size.height) style:UITableViewStyleGrouped];
        scanhistorytable.delegate=self;
        scanhistorytable.dataSource=self;
        [scanhistoryview addSubview:scanhistorytable];
        
        scanhistorynorecordlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, scanhistoryview.frame.size.width, scanhistoryview.frame.size.height)];
        scanhistorynorecordlabel.text=[MyClass returntitlewithtitle:@"No scan record"];
        scanhistorynorecordlabel.font=[UIFont systemFontOfSize:13];
        scanhistorynorecordlabel.backgroundColor=[UIColor systemGroupedBackgroundColor];
        scanhistorynorecordlabel.textAlignment=NSTextAlignmentCenter;
        scanhistorynorecordlabel.textColor=[UIColor grayColor];
        [scanhistoryview addSubview:scanhistorynorecordlabel];
        
        scanhistorynorecordlabel.hidden=scanhistoryarray.count>0?YES:NO;
        
        UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(scanhistoryview.frame.origin.x, 0, 0.5, scanmasterview.frame.size.height)];
        separator.backgroundColor=[UIColor lightGrayColor];
        [scanmasterview addSubview: separator];
        
        scantotakeattendanceviewcontroller=[[UIViewController alloc]init];
        scantotakeattendanceviewcontroller.preferredContentSize=CGSizeMake(scanwindowwidth, scanwindowheight);
        scantotakeattendanceviewcontroller.view=scanmasterview;
        
        scantotakeattendanceviewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
        scantotakeattendanceviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
}

-(void) gotostudentprofile:(NSString *)studentkey
{
    //not used
}

-(void) gotoLeadProfilewithLeadkey:(NSString *)leadkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys
{
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==sortingtable) {
        return YES;
    }
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

-(void) updatesortingstring
{
    NSString *sortingstring=@"";
    
    for (int i=0; i<sortingarray.count; i++) {
        if (i==0) {
            sortingstring=[NSString stringWithFormat:@"%@#%@",((SortingRecord *)[sortingarray objectAtIndex:i]).order,((SortingRecord *)[sortingarray objectAtIndex:i]).item];
        }else{
            sortingstring=[NSString stringWithFormat:@"%@,%@#%@",sortingstring,((SortingRecord *)[sortingarray objectAtIndex:i]).order,((SortingRecord *)[sortingarray objectAtIndex:i]).item];
        }
    }

    [MyClass updatelocaldbwithparameter:@"dailyclassschedulelistsortingorder" value:sortingstring];
}


-(void) changesortingorder:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:sortingtable];
    NSIndexPath *indexpath =[sortingtable indexPathForRowAtPoint:point];
    
    if ([((SortingRecord *)[sortingarray objectAtIndex:indexpath.row]).order isEqualToString:@"a"]){
        ((SortingRecord *)[sortingarray objectAtIndex:indexpath.row]).order=@"d";
    }else{
        ((SortingRecord *)[sortingarray objectAtIndex:indexpath.row]).order=@"a";
    }
    [self updatesortingstring];
    

    [self returnfilterdailyclassschedulearray];
    
    [sortingtable reloadData];
    
    
}



- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if( sourceIndexPath.section != proposedDestinationIndexPath.section )
    {
        return sourceIndexPath;
    }
    else
    {
        return proposedDestinationIndexPath;
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    //do whatever u want after row has been moved
    if (toIndexPath.section==0 && (fromIndexPath.row !=toIndexPath.row)) {
        sortingobject=[sortingarray objectAtIndex:fromIndexPath.row];
        [sortingarray removeObjectAtIndex:fromIndexPath.row];
        [sortingarray insertObject:sortingobject atIndex:toIndexPath.row];
        
        [self updatesortingstring];
        [self returnfilterdailyclassschedulearray];
    }
}

-(void) sortdailyclassschedulelist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarray];
    
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO selector:@selector(localizedStandardCompare:)];
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    filteredClassScheduleRecordArray=[NSMutableArray arrayWithArray:[filteredClassScheduleRecordArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    
    LessonClassRecordArray=[[NSMutableArray alloc] init];
    cellcolorarray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<filteredClassScheduleRecordArray.count; i++) {
        [self addlessonclasswithclassschedulerecord:[filteredClassScheduleRecordArray objectAtIndex:i]];

        if ([viewmode isEqualToString:@"class"]) {

                if (i==0){
                    [cellcolorarray addObject:@"0"];
                }else{
                    ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:i];
                    if ([((SortingRecord *)[sortingarray objectAtIndex:0]).item isEqualToString:@"realclasstime"]) {
                        if(![ClassScheduleObject.realclasstime isEqualToString:((ClassScheduleRecord *)[filteredClassScheduleRecordArray objectAtIndex:i-1]).realclasstime]){
                            if ([[cellcolorarray objectAtIndex:i-1] isEqualToString:@"0"]){
                                [cellcolorarray addObject:@"1"];
                            }else{
                                [cellcolorarray addObject:@"0"];
                            }
                            
                        }else{
                            [cellcolorarray addObject:[cellcolorarray objectAtIndex:i-1]];
                        }
                    }else if ([((SortingRecord *)[sortingarray objectAtIndex:0]).item isEqualToString:@"subjectfullname"]) {
                        if(![ClassScheduleObject.subject isEqualToString:((ClassScheduleRecord *)[filteredClassScheduleRecordArray objectAtIndex:i-1]).subject]){
                            if ([[cellcolorarray objectAtIndex:i-1] isEqualToString:@"0"]){
                                [cellcolorarray addObject:@"1"];
                            }else{
                                [cellcolorarray addObject:@"0"];
                            }
                            
                        }else{
                            [cellcolorarray addObject:[cellcolorarray objectAtIndex:i-1]];
                        }
                    }else if ([((SortingRecord *)[sortingarray objectAtIndex:0]).item isEqualToString:@"instructorfullname"]) {
                        if(![ClassScheduleObject.instructor isEqualToString:((ClassScheduleRecord *)[filteredClassScheduleRecordArray objectAtIndex:i-1]).instructor]){
                            if ([[cellcolorarray objectAtIndex:i-1] isEqualToString:@"0"]){
                                [cellcolorarray addObject:@"1"];
                            }else{
                                [cellcolorarray addObject:@"0"];
                            }
                            
                        }else{
                            [cellcolorarray addObject:[cellcolorarray objectAtIndex:i-1]];
                        }
                    }else if ([((SortingRecord *)[sortingarray objectAtIndex:0]).item isEqualToString:@"realclassroom"]) {
                        if(![ClassScheduleObject.realclassroom isEqualToString:((ClassScheduleRecord *)[filteredClassScheduleRecordArray objectAtIndex:i-1]).realclassroom]){
                            if ([[cellcolorarray objectAtIndex:i-1] isEqualToString:@"0"]){
                                [cellcolorarray addObject:@"1"];
                            }else{
                                [cellcolorarray addObject:@"0"];
                            }
                            
                        }else{
                            [cellcolorarray addObject:[cellcolorarray objectAtIndex:i-1]];
                        }
                    }else if ([((SortingRecord *)[sortingarray objectAtIndex:0]).item isEqualToString:@"firstname"]) {
                        if(![ClassScheduleObject.firstname isEqualToString:((ClassScheduleRecord *)[filteredClassScheduleRecordArray objectAtIndex:i-1]).firstname]){
                            if ([[cellcolorarray objectAtIndex:i-1] isEqualToString:@"0"]){
                                [cellcolorarray addObject:@"1"];
                            }else{
                                [cellcolorarray addObject:@"0"];
                            }
                            
                        }else{
                            [cellcolorarray addObject:[cellcolorarray objectAtIndex:i-1]];
                        }
                    }else if ([((SortingRecord *)[sortingarray objectAtIndex:0]).item isEqualToString:@"lastname"]) {
                        if(![ClassScheduleObject.lastname isEqualToString:((ClassScheduleRecord *)[filteredClassScheduleRecordArray objectAtIndex:i-1]).lastname]){
                            if ([[cellcolorarray objectAtIndex:i-1] isEqualToString:@"0"]){
                                [cellcolorarray addObject:@"1"];
                            }else{
                                [cellcolorarray addObject:@"0"];
                            }
                            
                        }else{
                            [cellcolorarray addObject:[cellcolorarray objectAtIndex:i-1]];
                        }
                    }
                }
        }
    }
    
    if ([viewmode isEqualToString:@"lesson"]) {
        if (LessonClassRecordArray.count>0) {
            NSInteger index=[self returnLessonIndex];
            selectedLessonKey=[self returnLessonKeyWithLessonRecord:((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:index]).lesson];
            [self tableView:LessonTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
        }else{
            [filteredClassScheduleRecordArray removeAllObjects];
            
        }
        
        if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showdailyscheduletotalcount) {
            headertitlename.text=[NSString stringWithFormat:@"%@ (%lu)",[MyClass returntitlewithtitle:@"Daily Class Schedule"],(unsigned long)LessonClassRecordArray.count];
        }
        
        [LessonTable reloadData];
        [ClassScheduleTable reloadData];
        
    }else{
        selectedLessonKey=nil;
        [LessonTable reloadData];
        [ClassScheduleTable reloadData];
        if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showdailyscheduletotalcount) {
            headertitlename.text=[NSString stringWithFormat:@"%@ (%lu)",[MyClass returntitlewithtitle:@"Daily Class Schedule"],[self returnnumberofstudentclass]];
        }
        
    }

    
}

-(long) returnnumberofstudentclass
{
    //remove duplicated classkeys
    NSMutableArray *studentclasskeys=[[NSMutableArray alloc]init];
    for (int i=0; i<filteredClassScheduleRecordArray.count; i++) {
        ClassScheduleRecord *obj=[filteredClassScheduleRecordArray objectAtIndex:i];
        if (![studentclasskeys containsObject:obj.classkey]) {
            [studentclasskeys addObject:obj.classkey];
        }
    }
    return studentclasskeys.count;
}

-(NSInteger) returnLessonIndex
{
    if(selectedLessonKey){
        for (int j=0; j<LessonClassRecordArray.count; j++) {
            NSString *tmplessonkey=[self returnLessonKeyWithLessonRecord:((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:j]).lesson];
            if ([tmplessonkey isEqualToString:selectedLessonKey]) {
                return j;
            }
        }
    }
    return 0;
}

-(void) editattendancebuttonpressed
{
    editattendanceviewopened=!editattendanceviewopened;
    [self openeditattendanceview:editattendanceviewopened];
}

-(void) openeditattendanceview:(BOOL)open
{
    [UIView animateWithDuration:0.3 animations:^{
        if (open) {
            editattendanceview.hidden=NO;
            [self updateEditAttendanceMenu];
        }else{
            [selectededitattendanceclasskeyarray removeAllObjects];
            editattendanceview.hidden=YES;
        }
        [validateclassarray removeAllObjects];
        
    } completion:^(BOOL finished){
        [self loadtableheader];
        [ClassScheduleTable reloadData];
        [masterView layoutIfNeeded];
    }];
}

-(void) canceleditattendancebuttonpressed
{
    editattendanceviewopened=FALSE;
    [self openeditattendanceview:editattendanceviewopened];
}

-(void) closecalendar
{
    [self.mainSlideMenu enableSlidePanGestureForLeftMenu];
    [UIView animateWithDuration:0.3 animations:^{
        //supermasterview.frame=CGRectMake(0, 0, supermasterview.frame.size.width, supermasterview.frame.size.height);
        masterviewleadingconstraint.constant=0;
        masterviewtrailingconstraint.constant=-320;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){supermasterviewbutton.hidden=YES;}];
}


-(void) opencalendar:(id)sender
{

    [self.mainSlideMenu disableSlidePanGestureForLeftMenu];
    [calendarview refreshviewwithoption:@"start"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /*calendarviewcontroller.selecteddatearray=[[NSMutableArray alloc]initWithObjects:selecteddate, nil];
        calendarviewcontroller.scrolltodate=selecteddate;
        calendarviewcontroller.instructorselected=instructorselected;
        [calendarviewcontroller getclassddayrecord];
        [calendarviewcontroller.CalendarTable reloadData];
        [calendarviewcontroller scrollToSelectedDate];
        [calendarviewcontroller refreshviewwithoption:@"stop"];*/
        
        
        [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:selecteddate, nil] ScrollToDate:nil instructorselected:instructorselected];
        [calendarview refreshviewwithoption:@"stop"];
    });
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        //supermasterview.frame=CGRectMake(-320, 0, supermasterview.frame.size.width, supermasterview.frame.size.height);
        masterviewleadingconstraint.constant=-320;
        masterviewtrailingconstraint.constant=0;
        [self.view layoutIfNeeded];
        supermasterviewbutton.hidden=NO;
    } completion:nil];
}


-(void) showbarcodescanner
{
    [df setDateFormat:@"dd-MMM-yyyy"];
    if (globalvariables.centerrecord.enablescantotakeattendance && [selecteddate isEqualToString:[df stringFromDate:[NSDate date]]]) {
        scantotakeattendancebutton.enabled=YES;
    }else{
        scantotakeattendancebutton.enabled=NO;
    }
}





- (IBAction)attendanceUnknownButtonPressed:(id)sender {
    [self confirmBulkAttendanceChangeWithStatus:@""];
}

- (IBAction)attendancePresentButtonPressed:(id)sender {
    [self confirmBulkAttendanceChangeWithStatus:@"Present"];
}

- (IBAction)attendanceMakeupButtonPressed:(id)sender {
    [self confirmBulkAttendanceChangeWithStatus:@"Makeup"];
}

- (IBAction)attendanceAbsentButtonPressed:(id)sender {
    [self confirmBulkAttendanceChangeWithStatus:@"Absent"];
}

- (IBAction)attendanceExtendButtonPressed:(id)sender {
    [self confirmBulkAttendanceChangeWithStatus:@"Extend"];
}

- (IBAction)sendParentNoteButtonPressed:(id)sender {
    [self startsidewindowanimationwithwidth:480];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ClassRemarksPopoverViewController *remarksuppopover = (ClassRemarksPopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"ClassRemarksPopoverViewController"];
        remarksuppopover.delegate=self;
        remarksuppopover.presentingview=@"dailyclassscheduleparentnote";
        remarksuppopover.parentNoteStudentClassKeys=[self getClasskeysForParentNote];
        
        remarksuppopover.preferredContentSize=CGSizeMake(480, self.view.frame.size.height);

        
        remarksuppopover.view.frame=mainWindow.bounds;
        [sidewindowview addSubview:remarksuppopover.view];
        [self addChildViewController:remarksuppopover];
        [remarksuppopover didMoveToParentViewController:self];
        [ailoadindicator stopAnimating];
        ailoadindicator.hidden=YES;
    });
}

- (IBAction)sendMessageButtonPressed:(id)sender {
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self loadMessageRecipient];
        MessagePopoverViewController *messagepopover = (MessagePopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MessagePopoverViewController"];
        messagepopover.delegate=self;
        messagepopover.MessageTableMode=@"RemoteAdd";
        messagepopover.CallingSource=@"DailySchedule";
        messagepopover.allleadarray=allleadarray;
        messagepopover.allstudentarray=allstudentarray;
        messagepopover.allstaffarray=allstaffarray;
        
        OutboxMessageRecord *omessagerecordobject=[[OutboxMessageRecord alloc]init];
        
        omessagerecordobject.messagetype=@"General";
        omessagerecordobject.messagestarttime=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
        omessagerecordobject.messageenglish=@"";
        omessagerecordobject.messagechinese=@"";
        omessagerecordobject.recipienttype=[((ClassScheduleRecord *)[selectededitattendanceclasskeyarray firstObject]).type isEqualToString:@"student"]?@"Student":@"Lead";
        omessagerecordobject.recipientgroup=[[RecipientGroupRecord alloc]init];
        omessagerecordobject.recipientgroup.subjectarray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.instructorarray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.classdatearray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.gradearray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.individualarray=[self getStudentOrLeadkeysForMessage];
        omessagerecordobject.recipientgroup.leadstatusarray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.studentstatusarray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.staffgrouparray=[[NSMutableArray alloc]init];
        omessagerecordobject.recipientgroup.droparray=[[NSMutableArray alloc]init];
        omessagerecordobject.photoarray=[[NSMutableArray alloc]init];
        omessagerecordobject.channel=globalvariables.centerrecord.defaultstudentmessagechannel;// [MyClass returnChannelCodeWithRecipientType:omessagerecordobject.recipienttype Index:[MyClass getlocaldbwithparameter:@"defaultstudentmessagechannel"]];
        messagepopover.OMessageRecordObject=omessagerecordobject;
        
        if (![messagepopover InitializeField]) {
            return;
        }
        
        messagepopover.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:messagepopover.view];
        [self addChildViewController:messagepopover];
        [messagepopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
}

-(void) confirmBulkAttendanceChangeWithStatus:(NSString *)status
{
    UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:[NSString stringWithFormat:@"attendance_%@",status]] message:[MyClass returntitlewithtitle:@"Are you sure to change the attendance status for the selected items?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updatebulkattendancewithstatus:status validationCheck:YES];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [changealert addAction:OKAction];
    [changealert addAction:CancelAction];
    
    [self presentViewController:changealert animated:YES completion:nil];
}


-(BOOL) isOriginalClassExistsInSelectedEditAttendanceClasskeyArrayWithMakeupClasskey:(NSString *)makeupclasskey
{
    ClassScheduleRecord *classobject;
    
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        classobject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        if ([classobject.classtype isEqualToString:@"Class"] && [classobject.classkey isEqualToString:makeupclasskey]) {
            return TRUE;
        }
    }
    return FALSE;
}

-(void) updateclasseswithclassschedulearray:(NSMutableArray *)classschedulearray remarks:(NSString *)remarks lesson:(NSString *)lesson
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsonclasskeyarray=[[NSArray alloc]init];

    keys=[NSArray arrayWithObjects:@"classkey",@"classtype",@"attendance",nil];
    
    //BOOL addToJson=FALSE;
    
    for (int i=0; i<classschedulearray.count; i++) {
        ClassScheduleObject=[classschedulearray objectAtIndex:i];
        values=[NSArray arrayWithObjects:[ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]?ClassScheduleObject.dtkey: ClassScheduleObject.classkey,ClassScheduleObject.classtype,ClassScheduleObject.attendance,nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    jsonclasskeyarray = [NSArray arrayWithArray:arrayOfDicts];
    
    //combine arrays
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:jsonclasskeyarray forKey:@"classkeys"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:@"updatemultipleclasses" forKey:@"postaction"];
    
    if(remarks){
        [dictionary setValue:remarks forKey:@"remarks"];
    }

    if(lesson){
        [dictionary setValue:lesson forKey:@"lesson"];
    }
    
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if(result){
        [self performSelector:@selector(refreshtable) withObject:nil afterDelay:0];
        [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        editattendanceviewopened=FALSE;
        [self openeditattendanceview:editattendanceviewopened];
    }
}

/*-(void) updatebulkremarkswithclassschedulearray:(NSMutableArray *)classschedulearray remarks:(NSString *)remarks
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsonclasskeyarray=[[NSArray alloc]init];

    keys=[NSArray arrayWithObjects:@"classkey",@"classtype",@"attendance",nil];
    
    //BOOL addToJson=FALSE;
    
    for (int i=0; i<classschedulearray.count; i++) {
        ClassScheduleObject=[classschedulearray objectAtIndex:i];
        values=[NSArray arrayWithObjects:[ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]?ClassScheduleObject.dtkey: ClassScheduleObject.classkey,ClassScheduleObject.classtype,ClassScheduleObject.attendance,nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    
    jsonclasskeyarray = [NSArray arrayWithArray:arrayOfDicts];
    
    //combine arrays
    NSDictionary *dictionary = @{@"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"classkeys" : jsonclasskeyarray,
                                 @"remarks" : remarks,
                                 @"updatedby" : globalvariables.username,
                                 @"postaction" : @"updatebulkremarks"};
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if(result){
        [self performSelector:@selector(refreshtable) withObject:nil afterDelay:0];
        [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        editattendanceviewopened=FALSE;
        [self openeditattendanceview:editattendanceviewopened];
    }
}*/



-(void) updatebulkattendancewithstatus:(NSString *)status validationCheck:(BOOL)validationcheck
{
    if ([status isEqualToString:@"Absent"] || [status isEqualToString:@"Present"] || [status isEqualToString:@""]) {
        validationcheck=NO;
    }
    
    selectedAttendanceStatus=status;
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSArray *jsonclasskeyarray=[[NSArray alloc]init];
    __block NSMutableArray *JSONArray;
    
    NSString *classroomcapacity;
    ClassroomRecord *classroomobj;
    NSMutableDictionary *dict;

    BOOL addToJson=FALSE;
    
    NSString *leavenaturelistkey=[MyClass returnDefaultLeaveNatureListKeyWithAttendance:status];
    
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        addToJson=FALSE;
        ClassScheduleObject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        if (![ClassScheduleObject.classtype isEqualToString:@"Makeup"]) {
            //class
            if (![ClassScheduleObject.attendance isEqualToString:status]) {
                if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {
                    if (![status isEqualToString:@"Makeup"] && ![status isEqualToString:@"Extend"]) {
                        addToJson=TRUE;
                    }
                }else{
                    addToJson=TRUE;
                }
            }
        }else{
            //makeup class
            if (![ClassScheduleObject.makeupattendance isEqualToString:status]) {
                if (![status isEqualToString:@"Makeup"] && ![status isEqualToString:@"Extend"]) {
                    if (![self isOriginalClassExistsInSelectedEditAttendanceClasskeyArrayWithMakeupClasskey:ClassScheduleObject.classkey]) {
                        addToJson=TRUE;
                    }
                }
            }
        }
        
        if (addToJson) {
            dict= [[NSMutableDictionary alloc]init];
            [dict setValue:ClassScheduleObject.classtype forKey:@"classtype"];
            [dict setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
            [dict setValue:ClassScheduleObject.subject forKey:@"subject"];
            if ([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]) {

                classroomobj=[MyClass returnclassroominformationwithclassroom:ClassScheduleObject.classroom centerkey:globalvariables.centerrecord.centerkey];
                classroomcapacity=classroomobj?classroomobj.capacity:@"";
                
                [dict setValue:ClassScheduleObject.dtkey forKey:@"classkey"];
                [dict setValue:ClassScheduleObject.attendance forKey:@"currentattendance"];
                [dict setValue:[status isEqualToString:@"Extend"]?((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration:@"" forKey:@"extensiontime"];
                [dict setValue:[status isEqualToString:@"Makeup"]?globalvariables.centerrecord.defaultattendancestatus:@"" forKey:@"defaultattendance"];
                //[dict setValue:ClassScheduleObject.subject forKey:@"subject"];
                [dict setValue:[MyClass convertDateFormatWithDate:ClassScheduleObject.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"]  forKey:@"classdate"];
                [dict setValue:ClassScheduleObject.classtime forKey:@"classtime"];
                [dict setValue:ClassScheduleObject.instructor forKey:@"instructor"];
                [dict setValue:ClassScheduleObject.classroom forKey:@"classroom"];
                [dict setValue:((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).studentcapacity forKey:@"classcapacity"];
                [dict setValue:[((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]) valueForKey:[ClassScheduleObject.classtype isEqualToString:@"Assessment"]?@"classduration_assessment":@"classduration_trial"] forKey:@"classduration"];
                [dict setValue:classroomcapacity forKey:@"classroomcapacity"];
                [dict setValue:leavenaturelistkey forKey:@"leavenaturelistkey"];
                //[dict setValue:ClassScheduleObject.enrollmentkey forKey:@""];
                [dict setValue:ClassScheduleObject.studentkey forKey:@"studentkey"];
                [dict setValue:globalvariables.centerrecord.classtimeinterval forKey:@"classtimeinterval"];
                
            }else if ([ClassScheduleObject.classtype isEqualToString:@"Makeup"]) {
                //values=[NSArray arrayWithObjects:ClassScheduleObject.classkey,ClassScheduleObject.classtype,ClassScheduleObject.makeupattendance,@"",@"",nil];
                
                classroomobj=[MyClass returnclassroominformationwithclassroom:ClassScheduleObject.makeupclassroom centerkey:globalvariables.centerrecord.centerkey];
                classroomcapacity=classroomobj?classroomobj.capacity:@"";
                
                [dict setValue:ClassScheduleObject.classkey forKey:@"classkey"];
                [dict setValue:ClassScheduleObject.makeupattendance forKey:@"currentattendance"];
                [dict setValue:@"" forKey:@"extensiontime"];
                [dict setValue:@"" forKey:@"defaultattendance"];
                //[dict setValue:ClassScheduleObject.subject forKey:@"subject"];
                [dict setValue:[MyClass convertDateFormatWithDate:ClassScheduleObject.makeupdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"] forKey:@"classdate"];
                [dict setValue:ClassScheduleObject.makeuptime forKey:@"classtime"];
                [dict setValue:ClassScheduleObject.makeupinstructor forKey:@"instructor"];
                [dict setValue:ClassScheduleObject.makeupclassroom forKey:@"classroom"];
                [dict setValue:((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).studentcapacity forKey:@"classcapacity"];
                [dict setValue:((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration forKey:@"classduration"];
                [dict setValue:classroomcapacity forKey:@"classroomcapacity"];
                [dict setValue:leavenaturelistkey forKey:@"leavenaturelistkey"];
                //[dict setValue:ClassScheduleObject.enrollmentkey forKey:@"enrollmentkey"];
                [dict setValue:ClassScheduleObject.studentkey forKey:@"studentkey"];
                [dict setValue:globalvariables.centerrecord.classtimeinterval forKey:@"classtimeinterval"];
            }else{
                classroomobj=[MyClass returnclassroominformationwithclassroom:[status isEqualToString:@"Makeup"]?ClassScheduleObject.makeupclassroom:ClassScheduleObject.classroom centerkey:globalvariables.centerrecord.centerkey];
                classroomcapacity=classroomobj?classroomobj.capacity:@"";
                
                
                [dict setValue:ClassScheduleObject.classkey forKey:@"classkey"];
                [dict setValue:ClassScheduleObject.attendance forKey:@"currentattendance"];
                [dict setValue:[status isEqualToString:@"Extend"]?((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration:@"" forKey:@"extensiontime"];
                [dict setValue:[status isEqualToString:@"Makeup"]?globalvariables.centerrecord.defaultattendancestatus:@"" forKey:@"defaultattendance"];
                //[dict setValue:ClassScheduleObject.subject forKey:@"subject"];
                [dict setValue:[status isEqualToString:@"Makeup"]?[MyClass convertDateFormatWithDate:ClassScheduleObject.makeupdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"]:[MyClass convertDateFormatWithDate:ClassScheduleObject.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"] forKey:@"classdate"];
                [dict setValue:[status isEqualToString:@"Makeup"]?ClassScheduleObject.makeuptime:ClassScheduleObject.classtime forKey:@"classtime"];
                [dict setValue:[status isEqualToString:@"Makeup"]?ClassScheduleObject.makeupinstructor:ClassScheduleObject.instructor forKey:@"instructor"];
                [dict setValue:[status isEqualToString:@"Makeup"]?ClassScheduleObject.makeupclassroom:ClassScheduleObject.classroom forKey:@"classroom"];
                [dict setValue:((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).studentcapacity forKey:@"classcapacity"];
                [dict setValue:((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ClassScheduleObject.subject centerkey:globalvariables.centerrecord.centerkey]).classduration forKey:@"classduration"];
                [dict setValue:classroomcapacity forKey:@"classroomcapacity"];
                [dict setValue:leavenaturelistkey forKey:@"leavenaturelistkey"];
                //[dict setValue:ClassScheduleObject.enrollmentkey forKey:@"enrollmentkey"];
                [dict setValue:ClassScheduleObject.studentkey forKey:@"studentkey"];
                [dict setValue:globalvariables.centerrecord.classtimeinterval forKey:@"classtimeinterval"];
                
            }
            

            [arrayOfDicts addObject:dict];
        }
    }
    
    jsonclasskeyarray = [NSArray arrayWithArray:arrayOfDicts];
    
    //combine arrays
    NSDictionary *dictionary = @{@"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"classkeys" : jsonclasskeyarray,
                                 @"attendance" : status,
                                 @"validationcheck" : validationcheck?@"Yes":@"No",
                                 @"updatedby" : globalvariables.username,
                                 @"postaction" : @"updateattendancev2"};
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        }
    }];
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120.0];
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
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    //[MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        if(validationcheck){
            validateclassarray=[MyClass returnValidateClassArrayWithJSONArray:JSONArray Combined:NO];
            //if ([remarks isEqualToString:@""]) {
                if(validateclassarray.count==0){
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        NSString *classkey=nil;
                        if(selectededitattendanceclasskeyarray.count==1 && jsonclasskeyarray.count==1 && [selectedAttendanceStatus isEqualToString:@"Makeup"]){
                            classkey=((ClassScheduleRecord *)[selectededitattendanceclasskeyarray firstObject]).classkey;
                        }
                        [self refreshtable];
                        if(editattendanceviewopened){
                            [self canceleditattendancebuttonpressed];
                        }
                        
                        if(classkey){
                            [self popUpMakeWindowWithClassKey:classkey];
                        }

                        
                    });
                }else{
                    if (selectededitattendanceclasskeyarray.count==1) {
                        [MyClass loadingindicatorwithoption:@"stop" color:nil];
                        ClassValidateRecord *obj=[self returnClassValidateRecordWithClassScheduleObject:ClassScheduleObject];
                        classvalidatemessage=obj.classvalidatemessage;
                        classvalidatestatus=obj.classvalidatestatus;
                        [self checkvalidatemessage];
                    }else{
                        [selectededitattendanceclasskeyarray removeAllObjects];
                        [self updateEditAttendanceMenu];
                        [self performSelector:@selector(refreshtable) withObject:nil afterDelay:0];
                        //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil]
                        
                        
                        UIAlertController *notsuccessalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Attendance"] message:[MyClass returntitlewithtitle:@"Some classes were not able to be updated. Please tap on the warning icon to see the details"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [notsuccessalert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [notsuccessalert addAction:OKAction];
                        [self presentViewController:notsuccessalert animated:YES completion:nil];
                    }
                }
            //}
        }else{
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *classkey=nil;
                if(selectededitattendanceclasskeyarray.count==1 && jsonclasskeyarray.count==1 && [selectedAttendanceStatus isEqualToString:@"Makeup"]){
                    classkey=((ClassScheduleRecord *)[selectededitattendanceclasskeyarray firstObject]).classkey;
                }
                [validateclassarray removeObjectForKey:([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"])?ClassScheduleObject.dtkey:ClassScheduleObject.classkey];
                [selectededitattendanceclasskeyarray removeAllObjects];
                [self refreshtable];
                if(validateclassarray.count==0){
                    if(editattendanceviewopened){
                        [self canceleditattendancebuttonpressed];
                    }
                }
                if(classkey){
                    [self popUpMakeWindowWithClassKey:classkey];
                }
                
                
            });


        }
        
    }else{
        [MyClass showconnectionlostdialogbox];
    }

}

-(void) popUpMakeWindowWithClassKey:(NSString *)classkey
{
    //[ClassScheduleTable selectRowAtIndexPath:selectedindex animated:YES scrollPosition:UITableViewScrollPositionNone];
    NSInteger index=[self returnClassScheduleRecordIndexWithClassKey:classkey];
    ClassScheduleRecord *obj=[self returnClassScheduleRecordIndexWithClassKey2:classkey];
    if(index>=0){
        [ClassScheduleTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    
    
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MakeupPopoverViewController *makeuppopover = (MakeupPopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"MakeupPopoverViewController"];
        makeuppopover.delegate=self;
        makeuppopover.PopoverClassRecord=obj;
        makeuppopover.PopoverOption=@"FromClassSchedule";
        //classpopover.PopoverStudent=DetailsViewStudent;
        makeuppopover.preferredContentSize=CGSizeMake(320, self.view.frame.size.height);
        
        makeuppopover.view.frame=mainWindow.bounds;
        [sidewindowview addSubview:makeuppopover.view];
        [self addChildViewController:makeuppopover];
        [makeuppopover didMoveToParentViewController:self];
        [ailoadindicator stopAnimating];
        ailoadindicator.hidden=YES;
    });
}

-(NSInteger) returnClassScheduleRecordIndexWithClassKey:(NSString *)classkey
{
    ClassScheduleRecord *obj;
    for(int i=0;i<filteredClassScheduleRecordArray.count;i++){
        obj=[filteredClassScheduleRecordArray objectAtIndex:i];
        if([obj.classkey isEqualToString:classkey] && [obj.classtype isEqualToString:@"Class"]){
            return i;
        }
    }
    return -1;
}

-(ClassScheduleRecord *) returnClassScheduleRecordIndexWithClassKey2:(NSString *)classkey
{
    ClassScheduleRecord *obj;
    for(int i=0;i<ClassScheduleRecordArray.count;i++){
        obj=[ClassScheduleRecordArray objectAtIndex:i];
        if([obj.classkey isEqualToString:classkey] && [obj.classtype isEqualToString:@"Class"]){
            return obj;
        }
    }
    return nil;
}

-(void) outstandingpaymentbuttonpressed:(UIButton *)sender
{
    if (!editattendanceviewopened) {
        
        [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"quickpay" DataIndex:sender.tag ShowSearchBar:NO BottomMode:@"Add to Folder" PreferredContentSize:CGSizeMake(220, 448) View:self Button:sender ItemsArray:nil Title:nil];
    }
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"quickpay"]) {
        ClassScheduleRecord *obj=[filteredClassScheduleRecordArray objectAtIndex:dataindex];
        UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Payment"] message:[MyClass returntitlewithtitle:@"Are you sure to proceed with payment?"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self quickPayWithStudentKey:obj.studentkey paidMethod:[selecteditems firstObject] subject:obj.subject];
            });
        }];
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        
        [changealert addAction:OKAction];
        [changealert addAction:CancelAction];
        
        [self presentViewController:changealert animated:YES completion:nil];
    }else if([datatype isEqualToString:@"ClassAction"]){
        NSString *item=[selecteditems firstObject];
        if ([item isEqualToString:@"Delete Classes"]) {
            [self confirmDeleteClasses];
        }else if ([item isEqualToString:@"Send Parent Note"]) {
            [self sendParentNoteButtonPressed:nil];
        }else if ([item isEqualToString:@"Send Message"]){
            [self sendMessageButtonPressed:nil];
        }else if ([item isEqualToString:@"Postpone Classes"]) {
            [self confirmPostponeClasses];
        }else if([item isEqualToString:@"Override Conflicts"]){
            [self confirmOverrideConflicts];
        }
    }
}

-(void) confirmOverrideConflicts
{
    UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Are you sure to override the conflicting classes?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self proceedOverrideConflicts];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [changealert addAction:OKAction];
    [changealert addAction:CancelAction];
    
    [self presentViewController:changealert animated:YES completion:nil];

}

-(void) proceedOverrideConflicts
{
    NSMutableArray *FreeScheduleArray=[[NSMutableArray alloc]init];
    NSMutableArray *studentkeyarray=[[NSMutableArray alloc]init];
    FreeScheduleClass *freescheduleclass_object;
    ClassScheduleRecord *classobj;
    ClassValidateRecord *cvobj;
    
    for (int i=0; i<[selectededitattendanceclasskeyarray count]; i++) {
        //skipvalidateclasscheck=FALSE;
        classobj=[selectededitattendanceclasskeyarray objectAtIndex:i];
        cvobj=[validateclassarray objectForKey:classobj.classkey];
        if(cvobj){
            freescheduleclass_object=[self returnmovelessonfreescheduleclasswithclassschedule:classobj freescheduleclass:return_freescheduleclass];
            [FreeScheduleArray addObject:freescheduleclass_object];
            [studentkeyarray addObject:ClassScheduleObject.studentkey];
            [validateclassarray removeObjectForKey:classobj.classkey];
        }
    }
    
    validateclassarray=[MyClass validateAndMoveLessonWithFreeScheduleArray:FreeScheduleArray studentkeyarray:studentkeyarray validationcheck:NO updatefollowinglessons:return_updatefollowinglessons updatefollowinglessonsfields:return_updatefollowinglessonsfields];
    [self retrieveClassScheduleWithclassdate:selecteddate];
}

-(void) deleteClassesFromMakeupWindowWithClassrecords:(NSMutableArray *)classrecords
{
    [self closesidewindow];
    
    [selectededitattendanceclasskeyarray removeAllObjects];
    for (int i=0; i<classrecords.count; i++) {
        [selectededitattendanceclasskeyarray addObject:[classrecords objectAtIndex:i]];
    }
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self proceedDeleteClasses];
    });
}

-(void) confirmDeleteClasses
{
    UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the classes?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self proceedDeleteClasses];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [changealert addAction:OKAction];
    [changealert addAction:CancelAction];
    
    [self presentViewController:changealert animated:YES completion:nil];

}

-(void) proceedDeleteClasses
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict;
    
    ClassScheduleRecord *classobject;
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        classobject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        dict= [[NSMutableDictionary alloc]init];
        [dict setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dict setValue:classobject.classkey forKey:@"classkey"];
        
        [arrayOfDicts addObject:dict];
    }
    
    NSDictionary *dictionary = @{@"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"classkeys" : arrayOfDicts,
                                 @"updatedby" : globalvariables.username,
                                 @"postaction" : @"deletemultipleclasses"};
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        }
    }];
    
    if(result){
        [selectededitattendanceclasskeyarray removeAllObjects];
        [self canceleditattendancebuttonpressed];
        [self retrieveClassScheduleWithclassdate:selecteddate];
    }
}

-(void) postponeClassesFromMakeupWindowWithClassrecords:(NSMutableArray *)classrecords
{
    [self closesidewindow];
    
    [selectededitattendanceclasskeyarray removeAllObjects];
    for (int i=0; i<classrecords.count; i++) {
        [selectededitattendanceclasskeyarray addObject:[classrecords objectAtIndex:i]];
    }
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self proceedPostponeClasses];
    });
}

-(void) confirmPostponeClasses
{
    UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Are you sure to postpone the classes?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self proceedPostponeClasses];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [changealert addAction:OKAction];
    [changealert addAction:CancelAction];
    
    [self presentViewController:changealert animated:YES completion:nil];

}

-(void) proceedPostponeClasses
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict;
    
    ClassScheduleRecord *classobject;
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        classobject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        dict= [[NSMutableDictionary alloc]init];
        [dict setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dict setValue:classobject.classkey forKey:@"classkey"];
        
        [arrayOfDicts addObject:dict];
    }
    
    NSDictionary *dictionary = @{@"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"classkeys" : arrayOfDicts,
                                 @"updatedby" : globalvariables.username,
                                 @"postaction" : @"postponemultipleclasses"};
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        }
    }];
    
    if(result){
        [selectededitattendanceclasskeyarray removeAllObjects];
        [self canceleditattendancebuttonpressed];
        [self retrieveClassScheduleWithclassdate:selecteddate];
    }
}

-(void) pickerBottomButtonPressedWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex BottomMode:(NSString *)bottommode SelectedItems:(NSMutableArray *)selecteditems
{
    if ([datatype isEqualToString:@"quickpay"]) {
        if ([bottommode isEqualToString:@"Add to Folder"]) {
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:dataindex inSection:0];
            ClassScheduleRecord *obj=[filteredClassScheduleRecordArray objectAtIndex:indexPath.row];
            
            MyTableViewCell *cell = [ClassScheduleTable cellForRowAtIndexPath:indexPath];
            UIButton *sender=cell.button1;
            
            CGRect button_CGRect = [sender.superview convertRect:sender.frame toView:self.view];
            CGRect dest_CGRect = [documentfoldercountlabel.superview convertRect:documentfoldercountlabel.frame toView:self.view];
            
            if([self retrieveStudentOutstandingPaymentsWithStudentkey:obj.studentkey Enrollmentkey:obj.enrollmentkey documentFolder:globalvariables.documentfolder]){
                
                UIImageView *flyingview=[[UIImageView alloc]initWithFrame:button_CGRect];
                [flyingview setImage:[UIImage imageNamed:@"red_background.png"]];
                flyingview.layer.opacity=0.8;
                flyingview.layer.cornerRadius=5;
                flyingview.layer.masksToBounds=YES;
                [self.view addSubview:flyingview];
                
                [UIView animateWithDuration:0.6 animations:^{
                    flyingview.frame=dest_CGRect;
                } completion:^(BOOL finished){ [flyingview removeFromSuperview]; }];
            }
        }
    }
}

-(void) quickPayWithStudentKey:(NSString *)studentkey paidMethod:(NSString *)paymethod subject:(NSString *)subject
{
    //quick pay upload
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    [dictionary setValue:@"quickpay4" forKey:@"postaction"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:studentkey forKey:@"studentkey"];
    [dictionary setValue:paymethod forKey:@"paidmethod"];
    [dictionary setValue:subject forKey:@"subject"];
    [dictionary setValue:[MyClass returndefaultarckey] forKey:@"arckey"];
    
    __block BOOL result=FALSE;
    __block NSData *returndata;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            returndata=data;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSDictionary *jsondictionary = jsonreturned[@"content"];
            NSArray *jsonenrollmentkeysarray = jsondictionary[@"receiptenrollmentkeys"];
            NSArray *jsonsaleskeysarray = jsondictionary[@"receiptsaleskeys"];

            if (jsonenrollmentkeysarray.count+jsonsaleskeysarray.count>0) {
                globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys=[[NSMutableArray alloc]init];
                globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys=[[NSMutableArray alloc]init];
                globalvariables.documentfolder.classreceiptarray=[[NSMutableArray alloc]init];
                globalvariables.documentfolder.salesreceiptarray=[[NSMutableArray alloc]init];
                
                for (int i=0; i<jsonenrollmentkeysarray.count; i++) {
                    NSString *enrollmentkey=[NSString stringWithFormat:@"%@",[jsonenrollmentkeysarray objectAtIndex:i]];
                    if (![globalvariables.documentfolder.classreceiptarray containsObject:enrollmentkey]) {
                        [globalvariables.documentfolder.classreceiptarray addObject:enrollmentkey];
                    }
                    
                    if(![globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:enrollmentkey]){
                        [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys addObject:enrollmentkey];
                    }
                }
                
                for (int i=0; i<jsonsaleskeysarray.count; i++) {
                    NSString *saleskey=[NSString stringWithFormat:@"%@",[jsonsaleskeysarray objectAtIndex:i]];
                    [globalvariables.documentfolder.salesreceiptarray addObject:saleskey];
                    [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys addObject:saleskey];
                }
                result=YES;
            }else{
                result= NO;
            }
        }
    }];

    if (result) {
        [self retrieveClassScheduleWithclassdate:selecteddate];
        [self refreshdocumentfoldercount];
        /*if(globalvariables.centerrecord.autosendereceipt){
            NSDictionary *dict=[MyClass loaddocumentfolderarraywithpaymethod:paymethod returndata:returndata];
            [MyClass autoSendeReceiptWithClassReceiptArray:dict[@"documentfolderclassreceiptarray"] SalesReceiptArray:dict[@"documentfoldersalesreceiptarray"]];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        }*/
    }else{
        [MyClass showconnectionlostdialogbox];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }
    
}


-(void) dismissDocumentFolderPopover
{
    [self closesidewindow];
}

-(void) refreshDocumentFolderPresentingViewScreen{
    [self refreshtable];
}

-(void) refreshdocumentfoldercountnumber
{
    [self refreshdocumentfoldercount];
}

- (void) refreshdocumentfoldercount
{
    if ((int)globalvariables.documentfolder.classinvoicearray.count+(int)globalvariables.documentfolder.classreceiptarray.count+(int)globalvariables.documentfolder.salesinvoicearray.count+(int)globalvariables.documentfolder.salesreceiptarray.count+(int)globalvariables.documentfolder.salespaymentarray.count+(int)globalvariables.documentfolder.classpaymentarray.count>0) {
        documentfoldercountlabel.hidden=NO;
    }else{
        documentfoldercountlabel.hidden=YES;
    }
    documentfolderbutton.hidden=NO;
}

-(BOOL) retrieveStudentOutstandingPaymentsWithStudentkey:(NSString *)studentkey Enrollmentkey:(NSString *)enrollmentkey documentFolder:(DocumentFolder *)documentfolder
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievestudentoutstandingpayments&studentkey=%@&enrollmentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,studentkey,enrollmentkey];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSDictionary *jsondictionary = jsonreturned[@"content"];
            
            
            NSArray *classpaymentkeys = jsondictionary[@"classpaymentkeys"];
            NSArray *salespaymentkeys = jsondictionary[@"salespaymentkeys"];
            //NSArray *classreceiptkeys = jsondictionary[@"classreceiptkeys"];
            
            if (classpaymentkeys.count+salespaymentkeys.count>0) {
                
                for (int i=0; i<classpaymentkeys.count; i++) {
                    NSString *enrollmentkey=[[classpaymentkeys objectAtIndex:i] objectForKey:@"enrollmentkey"];
                    
                    if (![documentfolder.classinvoicearray containsObject:enrollmentkey]) {
                        [documentfolder.classinvoicearray addObject:enrollmentkey];
                    }
                    
                    if (![documentfolder.classpaymentarray containsObject:enrollmentkey]) {
                        [documentfolder.classpaymentarray addObject:enrollmentkey];
                    }

                    
                    if (![documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:enrollmentkey]) {
                        [documentfolder.defaultcheckedclassinvoiceenrollmentkeys addObject:enrollmentkey];
                    }
                    
                    if (![documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:enrollmentkey]) {
                        [documentfolder.defaultcheckedclasspaymentenrollmentkeys addObject:enrollmentkey];
                    }

                }

                for (int i=0; i<salespaymentkeys.count; i++) {
                    NSString *saleskey=[[salespaymentkeys objectAtIndex:i] objectForKey:@"saleskey"];
                    
                    if (![documentfolder.salesinvoicearray containsObject:saleskey]) {
                        [documentfolder.salesinvoicearray addObject:saleskey];
                    }
                    
                    if (![documentfolder.salespaymentarray containsObject:saleskey]) {
                        [documentfolder.salespaymentarray addObject:saleskey];
                    }

                    
                    if (![documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:saleskey]) {
                        [documentfolder.defaultcheckedsalesinvoicesaleskeys addObject:saleskey];
                    }
                    
                    if (![documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:saleskey]) {
                        [documentfolder.defaultcheckedsalespaymentsaleskeys addObject:saleskey];
                    }

                }

               
            
            }
        }
    }];
        
    if (result) {
        [self refreshdocumentfoldercount];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    return result;
}

-(void) classTableLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:ClassScheduleTable];
        NSIndexPath *indexPath = [ClassScheduleTable indexPathForRowAtPoint:point];
        
        for(int i=0;i<[ClassScheduleTable numberOfSections];i++) {
            CGRect headerViewRect = [ClassScheduleTable rectForHeaderInSection:i];
            BOOL isInside = CGRectContainsPoint (headerViewRect, point);
            if(isInside) {
                return;
            }
            
        }
        
        if (indexPath) {
            ClassScheduleObject=[filteredClassScheduleRecordArray objectAtIndex:indexPath.row];
            //ClassScheduleObject=[((LessonAndClassRecord *)[LessonClassRecordArray objectAtIndex:indexPath.section]).classScheduleRecordArray objectAtIndex:indexPath.row];
            if (![selectededitattendanceclasskeyarray containsObject:ClassScheduleObject]) {
                [selectededitattendanceclasskeyarray addObject:ClassScheduleObject];
            }
        }
        //[attendanceringview removeFromSuperview];
        
        editattendanceviewopened=TRUE;
        [self openeditattendanceview:editattendanceviewopened];
        [self updateEditAttendanceMenu];
    }
}


-(void) documentfolderbuttonpressed:(id)sender
{

    [self startsidewindowanimationwithwidth:750];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        documentfolderpopover = (DocumentFolderPopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"DocumentFolderPopoverViewController"];
        documentfolderpopover.delegate=self;
        /*documentfolderpopover.defaultcheckedclasspaymentenrollmentkeys=defaultcheckedclasspaymentenrollmentkeys;
        documentfolderpopover.defaultcheckedsalespaymentsaleskeys=defaultcheckedsalespaymentsaleskeys;
        documentfolderpopover.defaultcheckedclassinvoiceenrollmentkeys=defaultcheckedclassinvoiceenrollmentkeys;
        documentfolderpopover.defaultcheckedsalesinvoicesaleskeys=defaultcheckedsalesinvoicesaleskeys;
        documentfolderpopover.defaultcheckedclassreceiptpaymentkeys=defaultcheckedclassreceiptpaymentkeys;
        documentfolderpopover.defaultcheckedsalesreceiptpaymentkeys=defaultcheckedsalesreceiptpaymentkeys;*/
        documentfolderpopover.menubutton=2;
        
        documentfolderpopover.view.frame=mainWindow.bounds;
        [sidewindowview addSubview:documentfolderpopover.view];
        [self addChildViewController:documentfolderpopover];
        documentfolderpopover.view.clipsToBounds=YES;
        [documentfolderpopover didMoveToParentViewController:self];
        [ailoadindicator stopAnimating];
        ailoadindicator.hidden=YES;
    });
    
    
    
    
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==ClassScheduleTable) {
        [self.view endEditing:YES];
    }
}

-(void) scan_historybuttonpressed:(UIButton *)sender
{
    showscanhistory=!showscanhistory;
    if (showscanhistory) {
        [sender setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    }else{
        [sender setImage:[UIImage imageNamed:@"openbutton_blue.png"] forState:UIControlStateNormal];
    }
    [self showscanhistory:showscanhistory];
}

/*
-(void) scanhistorybuttonpressed
{
    showscanhistory=!showscanhistory;
    if (showscanhistory) {
        [scanhistorybutton setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    }else{
        [scanhistorybutton setImage:[UIImage imageNamed:@"openbutton_blue.png"] forState:UIControlStateNormal];
    }
    [self showscanhistory:showscanhistory];
}*/



-(void) scantotakeattendancebuttonpressed
{
    showscanhistory=FALSE;
    firstopenscanwindow=TRUE;

    

    
    openforscan=TRUE;
    
    scantotakeattendanceview.studentname.text=@"";
    scantotakeattendanceview.studentid.text=@"";
    scantotakeattendanceview.subject.text=@"";
    scantotakeattendanceview.classtime.text=@"";
    scantotakeattendanceview.warning.text=@"";
    scantotakeattendanceview.outstanding.text=@"";
    [scantotakeattendanceview showLoadingImage:NO];
    [scantotakeattendanceview.statusimage setImage:nil];
    [scantotakeattendanceview.studentimage setImage:nil];
    

    

    [self presentViewController:scantotakeattendanceviewcontroller animated:YES completion: nil];
    
    
    
    
    [scantotakeattendanceview.studentkeytext becomeFirstResponder];
    
}

-(CGImageRef) generatescancodewithscantype:(NSString *)scantype string:(NSString *)string
{
    float width;
    float height;
    ZXBarcodeFormat barcodeformat;
    
    if ([scantype isEqualToString:globalvariables.centerrecord.scantype]) {
        width=240;
        height=80;
        barcodeformat=kBarcodeFormatCode128;
    }else{// if ([globalvariables.centerrecord.scantype isEqualToString:@"qrcode"]){
        width=200;
        height=200;
        barcodeformat=kBarcodeFormatQRCode;
    }
    
    
    NSError *error = nil;
    ZXMultiFormatWriter *writer = [ZXMultiFormatWriter writer];
    ZXBitMatrix* result = [writer encode:string
                                  format:barcodeformat
                                   width:width
                                  height:height
                                   error:&error];
    
    return [[ZXImage imageWithMatrix:result] cgimage];
}

-(void) scan_closebuttonpressed:(UIButton *)sender
{
    
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    if (scannerconnected) {
        if (scantotakeattendanceview.cancelButton.hidden) {
            NSString *poweroffcode=globalvariables.centerrecord.scannerpoweroffcode;//[MyClass getlocaldbwithparameter:@"scannerpoweroffcode"];
            if (![poweroffcode isEqualToString:@""]) {
                scantotakeattendanceview.action.text=[MyClass returntitlewithtitle:@"You can scan below code to turn off your scanner right away"];
                [scantotakeattendanceview.actionimage setImage:[UIImage imageWithCGImage:[self generatescancodewithscantype:@"barcode" string:@"%%POWEROFF"]]];
                scantotakeattendanceview.action.hidden=NO;
                scantotakeattendanceview.actionimage.hidden=NO;
                scantotakeattendanceview.cancelButton.hidden=NO;
                
                [scantotakeattendanceview.statusimage setImage:nil];
                scantotakeattendanceview.studentname.text=@"";
                scantotakeattendanceview.subject.text=@"";
                scantotakeattendanceview.studentid.text=@"";
                scantotakeattendanceview.classtime.text=@"";
                scantotakeattendanceview.warning.text=@"";
                scantotakeattendanceview.outstanding.text=@"";
            }else{
                [scantotakeattendanceviewcontroller dismissViewControllerAnimated:YES completion:nil];
            }
        }else{
            [scantotakeattendanceviewcontroller dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        [scantotakeattendanceviewcontroller dismissViewControllerAnimated:YES completion:nil];
    }
    [self performSelector:@selector(refreshtable) withObject:nil afterDelay:0];
}

-(void) scan_cancelbuttonpressed:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    scantotakeattendanceview.cancelButton.hidden=YES;
    scantotakeattendanceview.action.text=[MyClass returntitlewithtitle:@"Please scan student code"];
    [scantotakeattendanceview.actionimage setImage:[UIImage imageNamed:@"barcodescanner_iphone.png"]];
    
}

-(void)scan_buttonhighlightcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)scan_buttonresetcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    
    NSString *studentkey=textField.text;
    textField.text=@"";
    
    if (textField == scantotakeattendanceview.studentkeytext) {
        
        if (openforscan) {
            [scantotakeattendanceview.statusimage setImage:nil];
            [scantotakeattendanceview.actionimage setImage:nil];
            [scantotakeattendanceview.studentimage setImage:nil];
            [scantotakeattendanceview showLoadingImage:YES];
            scantotakeattendanceview.studentname.text=@"";
            scantotakeattendanceview.subject.text=@"";
            scantotakeattendanceview.studentid.text=@"";
            scantotakeattendanceview.classtime.text=@"";
            scantotakeattendanceview.warning.text=@"";
            scantotakeattendanceview.outstanding.text=@"";
            openforscan=FALSE;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //[self scantotakeattendancewithstudentkey:studentkey];
                [self studentcheckinwithstudentkey:studentkey];
                
            });
        }
    }
    
    return YES;
}

-(NSString *) classwithinscanperiodwithclasstime:(NSString *)classtime classdate:(NSString *)classdate classduration:(NSString *)classduration
{
    if ([classtime isEqualToString:@"TBD"] || [classdate isEqualToString:@"TBD"]) {
        return @"tbdclass";
    }else{
        NSString *classtimestring=[NSString stringWithFormat:@"%@ %@:00",classdate,classtime];
        [df setDateFormat:@"dd-MMM-yyyy HH:mm:ss"];
        NSDate *classdatetime=[df dateFromString:classtimestring];
        NSDate *beforethreshold = [classdatetime dateByAddingTimeInterval:globalvariables.centerrecord.scantotakeattendancebeforethreshold*60*-1];
        NSDate *afterthreshold = [classdatetime dateByAddingTimeInterval:globalvariables.centerrecord.scantotakeattendanceafterthreshold*60+[classduration intValue]*60];
        NSDate *now=[NSDate date];

        if ([now compare:beforethreshold]==NSOrderedDescending && [now compare:afterthreshold]==NSOrderedAscending) {
            return @"withinperiod";
        }else if ([now compare:afterthreshold]!=NSOrderedAscending) {
            return @"beforeperiod";
        }else{
            return @"afterperiod";
        }
    }
}

-(void) addclasstoafterperiodarraywithclassscheduleobject:(ClassScheduleRecord *)classscheduleobject afterperiodarray:(NSMutableArray *)afterperiodarray
{
    if (afterperiodarray.count==0) {
        [afterperiodarray addObject:classscheduleobject];
    }else{
        [df setDateFormat:@"dd-MMM-yyyy HH:mm"];
        NSDate *classdate=[df dateFromString:[NSString stringWithFormat:@"%@ %@",classscheduleobject.startdate,classscheduleobject.classtime]];
        if (classdate) {
            if ([[df dateFromString:[NSString stringWithFormat:@"%@ %@",((ClassScheduleRecord *)[afterperiodarray firstObject]).startdate,((ClassScheduleRecord *)[afterperiodarray firstObject]).classtime]] compare:classdate]==NSOrderedDescending) {
                [afterperiodarray removeAllObjects];
                [afterperiodarray addObject:classscheduleobject];
            }
        }
    }
}


-(void) studentcheckinwithstudentkey:(NSString *)studentkey
{
    if (!scanhistorynorecordlabel.hidden) {
        scanhistorynorecordlabel.hidden=YES;
    }
    
    scantotakeattendanceview.action.hidden=YES;
    scantotakeattendanceview.actionimage.hidden=YES;
    scantotakeattendanceview.cancelButton.hidden=YES;

        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
        
        [dictionary setValue:@"studentcheckin" forKey:@"postaction"];
        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
        [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dictionary setValue:globalvariables.username forKey:@"updatedby"];
        [dictionary setValue:studentkey forKey:@"studentkey"];
        
    __block BOOL result=FALSE;
    __block NSDictionary *jsondictionary;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            jsondictionary = jsonreturned[@"content"];
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
    __block NSDictionary *jsondictionary;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            jsondictionary = jsonreturned[@"content"];
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    
    if(result){
        [self studentCheckInActionWithJSON:jsondictionary studentkey:studentkey];
    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }
}

-(Student *) checkNewStudentKey:(NSString *)studentkey
{
    Student *student=[MyClass returnstudentwithstudentkey:studentkey];
    if ([student.firstname isEqualToString:@""]) {
        [MyClass getLatestDataSetv2withParameters:@"student" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
        return [MyClass returnstudentwithstudentkey:studentkey];
    }else{
        return student;
    }
}

-(void) studentCheckInActionWithJSON:(NSDictionary *)jsondictionary studentkey:(NSString *)studentkey
{
    NSString *returncode = jsondictionary[@"returncode"];
    //NSString *reason = jsondictionary[@"reason"];
    NSString *duepayment = jsondictionary[@"duepayment"];
    NSArray *currentClassRecords = jsondictionary[@"currentclassrecords"];
    NSArray *nextClassRecords = jsondictionary[@"nextclassrecords"];
    
    [scantotakeattendanceview showLoadingImage:NO];
    if ([returncode isEqualToString:@"102"]) {
        //no class today
        Student *student=[self checkNewStudentKey:studentkey];
        scantotakeattendanceview.studentname.text=[MyClass returnStudentnameWithStudentkey:studentkey option:@"fullbutid"];
        [MyClass downloadImageWithImageview:scantotakeattendanceview.studentimage gender:student.gender type:@"student" typekey:student.studentkey image:student.image async:YES];
        scantotakeattendanceview.subject.text=@"";
        scantotakeattendanceview.studentid.text=student.studentid;
        scantotakeattendanceview.classtime.text=@"";
        scantotakeattendanceview.outstanding.text=[duepayment isEqualToString:@"0"]?@"":[NSString stringWithFormat:@"%@ $%@",[MyClass returntitlewithtitle:@"Outstanding Payment"],duepayment];
        
        [scantotakeattendanceview.statusimage setImage:[UIImage imageNamed:@"warning_icon.png"]];
        scantotakeattendanceview.warning.text=[MyClass returntitlewithtitle:@"No class for this student today"];
        scantotakeattendanceview.warning.textColor=[UIColor redColor];
        
        [scanhistoryarray insertObject:[[ScanHistoryRecord alloc]initScanHistoryRecordwithStudentkey:studentkey StudentName:scantotakeattendanceview.studentname.text StudentID:student.studentid Image:student.image Gender:student.gender Status:[MyClass returntitlewithtitle:@"No class today"] Success:NO] atIndex:0];
        
        [MyClass playBeepSoundWithType:@"failed"];
        
    }else if ([returncode isEqualToString:@"103"]) {
        //no more class today
        Student *student=[self checkNewStudentKey:studentkey];
        
        [MyClass downloadImageWithImageview:scantotakeattendanceview.studentimage gender:student.gender type:@"student" typekey:student.studentkey image:student.image async:YES];
        scantotakeattendanceview.studentname.text=[MyClass returnStudentnameWithStudentkey:studentkey option:@"fullbutid"];
        scantotakeattendanceview.subject.text=@"";
        scantotakeattendanceview.studentid.text=student.studentid;
        scantotakeattendanceview.classtime.text=@"";
        scantotakeattendanceview.outstanding.text=[duepayment isEqualToString:@"0"]?@"":[NSString stringWithFormat:@"%@ $%@",[MyClass returntitlewithtitle:@"Outstanding Payment"],duepayment];
        [scantotakeattendanceview.statusimage setImage:[UIImage imageNamed:@"warning_icon.png"]];
        scantotakeattendanceview.warning.text=[MyClass returntitlewithtitle:@"No more class for this student today"];
        scantotakeattendanceview.warning.textColor=[UIColor redColor];
        
        [scanhistoryarray insertObject:[[ScanHistoryRecord alloc]initScanHistoryRecordwithStudentkey:studentkey StudentName:scantotakeattendanceview.studentname.text StudentID:student.studentid Image:student.image Gender:student.gender Status:[MyClass returntitlewithtitle:@"No more class today"] Success:NO] atIndex:0];
        [MyClass playBeepSoundWithType:@"failed"];
        
    }else if ([returncode isEqualToString:@"104"]) {
        //not yet time
        Student *student=[self checkNewStudentKey:studentkey];
        NSString * subject=[[nextClassRecords firstObject] objectForKey:@"subject"];
        NSString * datetime=[[nextClassRecords firstObject] objectForKey:@"datetime"];
        NSString * classroom=[[nextClassRecords firstObject] objectForKey:@"classroom"];
        
        [MyClass downloadImageWithImageview:scantotakeattendanceview.studentimage gender:student.gender type:@"student" typekey:student.studentkey image:student.image async:YES];
        scantotakeattendanceview.studentname.text=[MyClass returnStudentnameWithStudentkey:studentkey option:@"fullbutid"];
        scantotakeattendanceview.subject.text=[MyClass returnsubjectnamewithsubject_shortname:subject centerkey:globalvariables.centerrecord.centerkey];;
        scantotakeattendanceview.studentid.text=student.studentid;
        scantotakeattendanceview.classtime.text=[classroom isEqualToString:@"TBD"]?[datetime substringFromIndex:11]:[NSString stringWithFormat:@"%@ / %@",[datetime substringFromIndex:11],classroom];
        scantotakeattendanceview.outstanding.text=[duepayment isEqualToString:@"0"]?@"":[NSString stringWithFormat:@"%@ $%@",[MyClass returntitlewithtitle:@"Outstanding Payment"],duepayment];
        [scantotakeattendanceview.statusimage setImage:[UIImage imageNamed:@"warning_icon.png"]];
        scantotakeattendanceview.warning.text=[MyClass returntitlewithtitle:@"Coming class yet to be ready for taking attendance"];
        scantotakeattendanceview.warning.textColor=[UIColor redColor];
        
        [scanhistoryarray insertObject:[[ScanHistoryRecord alloc]initScanHistoryRecordwithStudentkey:studentkey StudentName:scantotakeattendanceview.studentname.text StudentID:student.studentid Image:student.image Gender:student.gender Status:[MyClass returntitlewithtitle:@"Class not ready"] Success:NO] atIndex:0];
        [MyClass playBeepSoundWithType:@"failed"];
        
    }else if ([returncode isEqualToString:@"105"]) {
        //unidentified student
        
        [scantotakeattendanceview.studentimage setImage:[UIImage imageNamed:@"boyimage.jpg"]];
        scantotakeattendanceview.studentname.text=[MyClass returntitlewithtitle:@"Unidentified Student"];
        scantotakeattendanceview.subject.text=@"";
        scantotakeattendanceview.studentid.text=@"";
        scantotakeattendanceview.classtime.text=@"";
        scantotakeattendanceview.outstanding.text=@"";
        [scantotakeattendanceview.statusimage setImage:[UIImage imageNamed:@"warning_icon.png"]];
        scantotakeattendanceview.warning.text=[MyClass returntitlewithtitle:@"Unidentified student code"];
        scantotakeattendanceview.warning.textColor=[UIColor redColor];
        
        [scanhistoryarray insertObject:[[ScanHistoryRecord alloc]initScanHistoryRecordwithStudentkey:studentkey StudentName:scantotakeattendanceview.studentname.text StudentID:@"" Image:@"No" Gender:@"Male" Status:scantotakeattendanceview.warning.text Success:NO] atIndex:0];
        [MyClass playBeepSoundWithType:@"failed"];
        
    }else if ([returncode isEqualToString:@"201"]) {
        //successfully checked
        Student *student=[self checkNewStudentKey:studentkey];
        NSString * subject=@"";
        NSString * datetime;
        NSString * classroom;
        NSString * status;
        
        [MyClass downloadImageWithImageview:scantotakeattendanceview.studentimage gender:student.gender type:@"student" typekey:student.studentkey image:student.image async:YES];
        scantotakeattendanceview.studentname.text=[MyClass returnStudentnameWithStudentkey:studentkey option:@"fullbutid"];
        
        for (int i=0; i<currentClassRecords.count; i++) {
            status=[[currentClassRecords objectAtIndex:i] objectForKey:@"status"];
            if([status isEqualToString:@"justcheckedin"]){
                subject=[[currentClassRecords objectAtIndex:i] objectForKey:@"subject"];
                datetime=[[currentClassRecords objectAtIndex:i] objectForKey:@"datetime"];
                classroom=[[currentClassRecords objectAtIndex:i] objectForKey:@"classroom"];
                scantotakeattendanceview.warning.text=[MyClass returntitlewithtitle:@"Just checked in"];
                break;
            }
        }
        
        //all checked in
        if([subject isEqualToString:@""]){
            subject=[[currentClassRecords firstObject] objectForKey:@"subject"];
            datetime=[[currentClassRecords firstObject] objectForKey:@"datetime"];
            classroom=[[currentClassRecords firstObject] objectForKey:@"classroom"];
            scantotakeattendanceview.warning.text=[MyClass returntitlewithtitle:@"Already checked in"];
        }
        
        scantotakeattendanceview.studentid.text=student.studentid;
        scantotakeattendanceview.subject.text=[MyClass returnsubjectnamewithsubject_shortname:subject centerkey:globalvariables.centerrecord.centerkey];
        scantotakeattendanceview.classtime.text=[classroom isEqualToString:@"TBD"]?[datetime substringFromIndex:11]:[NSString stringWithFormat:@"%@ / %@",[datetime substringFromIndex:11],classroom];
        scantotakeattendanceview.outstanding.text=[duepayment isEqualToString:@"0"]?@"":[NSString stringWithFormat:@"%@ $%@",[MyClass returntitlewithtitle:@"Outstanding Payment"],duepayment];
        [scantotakeattendanceview.statusimage setImage:[UIImage imageNamed:@"present_icon.png"]];
        
        [scanhistoryarray insertObject:[[ScanHistoryRecord alloc]initScanHistoryRecordwithStudentkey:studentkey StudentName:scantotakeattendanceview.studentname.text StudentID:scantotakeattendanceview.studentid.text Image:student.image Gender:student.gender Status:scantotakeattendanceview.warning.text Success:YES] atIndex:0];

        if([duepayment floatValue]>0){
            [MyClass playBeepSoundWithType:@"duepayment"];
        }else{
            [MyClass playBeepSoundWithType:@"passed"];
        }
    }
    
    if (showscanhistory) {
        [scanhistorytable reloadData];
        
        [scanhistorytable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        if (scanhistorytable.contentSize.height>=scanhistorytable.frame.size.height+40) {
            [scanhistorytable setContentOffset:CGPointMake(0, 40)];
        }
        
    }
    
    
    openforscan=TRUE;
    
}



-(void) scan_retrybuttonpressed:(UIButton *)sender
{
    
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [scantotakeattendanceview.studentkeytext becomeFirstResponder];
}

-(void) getstudentnamewithstudentkey:(NSString *)studentkey
{

    studentobject=[MyClass returnstudentwithstudentkey:studentkey];

    if (studentobject && [studentobject.centerkey isEqualToString:globalvariables.centerrecord.centerkey]) {
        NSString * sstudentid=studentobject.studentid;
        //NSString * sfirstname=studentobject.firstname;
        //NSString * slastname=studentobject.lastname;
        NSString * simage=studentobject.image;
        NSString * sgender=studentobject.gender;
        scantotakeattendanceview.outstanding.text=@"";
        
        scantotakeattendanceview.studentname.text=[MyClass returnStudentnameWithStudentkey:studentkey option:@"full"];// [MyClass returnfullnamewithfirstname:sfirstname lastname:slastname];
        scantotakeattendanceview.studentid.text=sstudentid;
        scantotakeattendanceview.warning.text=[MyClass returntitlewithtitle:@"No class for this student today"];
        
        [scanhistoryarray insertObject:[[ScanHistoryRecord alloc]initScanHistoryRecordwithStudentkey:studentkey StudentName:scantotakeattendanceview.studentname.text StudentID:ClassScheduleObject.studentid Image:simage Gender:sgender Status:[MyClass returntitlewithtitle:@"No class today"] Success:NO] atIndex:0];
        
    }else{
        scantotakeattendanceview.studentname.text=[MyClass returntitlewithtitle:@"Unidentified Student"];
        scantotakeattendanceview.studentid.text=@"";
        scantotakeattendanceview.warning.text=[MyClass returntitlewithtitle:@"Unidentified student code"];
        scantotakeattendanceview.outstanding.text=@"";
        
        [scanhistoryarray insertObject:[[ScanHistoryRecord alloc]initScanHistoryRecordwithStudentkey:studentkey StudentName:scantotakeattendanceview.studentname.text StudentID:@"" Image:@"No" Gender:@"Male" Status:scantotakeattendanceview.warning.text Success:NO] atIndex:0];
    }

}



-(void) refreshparentviewdocumentfoldercount
{
    [self refreshdocumentfoldercount];
}

- (void)donotrunviewdidappearinstudentinformation {
    
}


- (void)gotostudentprofile:(NSString *)studentkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys {
    
}


- (void) showscanhistory:(BOOL)value
{
    scantotakeattendanceviewcontroller.preferredContentSize=CGSizeMake(scanwindowwidth+(value?250:0), scanwindowheight);
    
    if (value) {
        [scanhistorytable reloadData];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [scantotakeattendanceviewcontroller.presentationController.containerView setNeedsLayout];
        [scantotakeattendanceviewcontroller.presentationController.containerView layoutIfNeeded];
    }];
}



-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width
{
    if (ailoadindicator.hidden && sidewindowview.frame.origin.x==mainWindow.bounds.size.width) {
        return;
    }
    
    if (mainWindow.bounds.size.width-width == sidewindowview.frame.origin.x) {
        return;
    }
    
    if (width>0 && sidewindowview.frame.origin.x== mainWindow.bounds.size.width) {
        [MyClass playsoundwithoption:@"open"];
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        sidewindowview.frame=CGRectMake(mainWindow.bounds.size.width-width, sidewindowview.frame.origin.y, width, sidewindowview.frame.size.height);
        if (width==0 && sidewindowview.frame.origin.x< mainWindow.bounds.size.width) {
            [MyClass playsoundwithoption:@"close"];
        }
    } completion:^(BOOL finished){
        if (width==0) {
            NSArray *viewcontrollers=self.childViewControllers;
            for (int i=0; i<viewcontrollers.count; i++) {
                UIViewController *viewcontroller=viewcontrollers[i];
                [viewcontroller willMoveToParentViewController:nil];
                [viewcontroller.view removeFromSuperview];
                [viewcontroller removeFromParentViewController];
            }
            for (id object in [sidewindowview subviews]) {
                if (![object isKindOfClass:[UIActivityIndicatorView class]]) {
                    [object removeFromSuperview];
                }
            }
        }
    }];
    sidewindowviewclosebutton.hidden=width==0;
    
}

- (void)donotrunviewdidappear {
    
}

-(void) closesidewindow
{
    [self adjustpresentingviewwidthwithwidth:0];
    [ClassScheduleTable deselectRowAtIndexPath:[ClassScheduleTable indexPathForSelectedRow] animated:YES];
    
    
}

-(void) startsidewindowanimationwithwidth:(float)width
{
    ailoadindicator.hidden=NO;
    ailoadindicator.center = CGPointMake(width/2-7.5,mainWindow.frame.size.height/2-7.5);
    [ailoadindicator startAnimating];
    [self adjustpresentingviewwidthwithwidth:width];
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    [self closecalendar];
    NSString *oldselecteddate=selecteddate;
    NSString *new_selected_date=[selecteddatearray firstObject];
    
    if (![new_selected_date isEqualToString:selecteddate]) {
        selecteddate=new_selected_date;
        [self showbarcodescanner];
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self retrieveClassScheduleWithclassdate:new_selected_date]){
                [datebartable selectRowAtIndexPath:[NSIndexPath indexPathForRow:[MyClass returnDateOffsetWithDate:[MyClass convertToNSDateWithDate:selecteddate DateFormat:@"dd-MMM-yyyy"]] inSection:0]  animated:YES scrollPosition:UITableViewScrollPositionMiddle];
                
            }else{
                selecteddate=oldselecteddate;
                [self showbarcodescanner];
            }
        });
    }
}

//- (void)returnCalendarYear:(NSString *)year {
//
//}


-(BOOL) moveLessonFailedWithClasskey:(ClassScheduleRecord *)object
{
    NSString *classkey;
    
    if([object.classtype isEqualToString:@"Assessment"] || [object.classtype isEqualToString:@"Trial"]){
        classkey=object.dtkey;
    }else{
        classkey=object.classkey;
    }
    
    ClassValidateRecord *obj=[validateclassarray objectForKey:classkey];
    if(obj){
        return YES;
    }
    return NO;
}

-(ClassValidateRecord *) returnClassValidateRecordWithClassScheduleObject:(ClassScheduleRecord *)object
{
    if([ClassScheduleObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleObject.classtype isEqualToString:@"Trial"]){
        return [validateclassarray objectForKey:object.dtkey];
    }else{
        return [validateclassarray objectForKey:object.classkey];
    }
}

-(void) dismissEditStudentView
{
    
}



@end
