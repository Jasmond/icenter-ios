//
//  ClassTimeTableViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 5/9/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "ClassTimeTableViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MainMenuViewController.h"
#import "StudentDetailsViewController.h"
#import "StudentInformationViewController.h"
#import "LeadDetailsViewController.h"
#import "MyClass.h"
#import "StudentDetailsNavController.h"
#import "LeadDetailsNavController.h"
#import "MainViewController.h"
#import "ClassTimeTableCollectionViewCell.h"
#import "detailsLessonPrintItem.h"
#import "EnrollmentPopoverViewController.h"
#import "SceneDelegate.h"



@interface ClassTimeTableViewController ()<myStudentViewController,myLeadDetailsViewController,myPopoverVCDelegate>

@end

@implementation ClassTimeTableViewController
@synthesize JSONArray,ClassTimeTableObject;//,ClassTimeTableRecordArray,ClassTimeTableAllArray,ClassSchedulePositionArray;
//@synthesize schoolDateArray;
@synthesize InstructorArray,InstructorObject,InstructorNameArray,AvailableInstructorNameArray;
@synthesize classTime,classDay,scviewtype,Subjectselected,scscheduletype;
@synthesize TimeTableMode;
@synthesize ClassDetailTable,ClassScheduleRecordArray,ClassScheduleRecordObject,myPopoverController;
@synthesize masterScrollView,globalselecteddate,tmpselecteddate;
@synthesize FreeScheduleClassObject,FreeScheduleClassArray,FreeScheduleTable,freeschedulemasterView,myFreeSchedulePopoverController,myPicker,subjectallclassremarks;
@synthesize draftenrollmentkey,draftclasskey,headerview,classtablebutton, timetableselectedclassdate;
@synthesize ClassScheduleTableShown,startupmonday,classtypeselected,preferredinstructor,myClassTypeSelectionPopoverController,myClassSelectionPopoverController;
@synthesize studentkey,preferredclassroom,AvailableClassroomArray;
@synthesize sourcemode,EnrollmentMode,selectedschedulekey;

#define defaultcellheight 24

#define tablex 0
#define tabley 113
//#define classtimewidth 48
//#define timetablewidth self.view.bounds.size.width-classtimewidth
#define superviewclearence 2
#define extraheight 0//85
#define tabheight 30

//#define subjectcolor lightGrayColor
#define selectedcolor blueColor
#define highlightcolor redColor
#define tablecolor [UIColor colorWithRed:80.0/255.0 green:82.0/255.0 blue:82.0/255.0 alpha:1.0]
#define subjectcolor [UIColor colorWithRed:50.0/255.0 green:170.0/255.0 blue:57.0/255.0 alpha:1.0]
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]
#define maxclassselectiontableheight 500
#define defaultsubjectinclasstimeweeklyview 3
#define freescheduletablewidth 390
#define maxfreescheduletableheight 600
//#define mincellwidthfordetailview 120
#define minitemwidthforcountview 22
#define minicellwidthforcountview 32
#define mincellheightforcountview 20
#define classselectiontablewidth 450
#define detailviewclasstimeheightforonehour 180


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
    //self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"launchimage2.png"]];
    
    //[self openDB];

    classtimewidth = 48;
    timetablewidth = self.view.bounds.size.width-classtimewidth;
    totalcellheight = self.view.bounds.size.height-tabley-66;
    legendviewwidth = self.view.bounds.size.width-608-20;
    
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    //supermasterview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width+315, self.view.bounds.size.height)];
    //[self.view addSubview:supermasterview];
    
    allClassDay=[[NSArray alloc]initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",nil];
    headertypearray=[[NSArray alloc]initWithObjects:@"All",@"Subject",@"Instructor",@"Classroom",nil];
    viewmodearray=[[NSArray alloc]initWithObjects:@"Daily",@"Weekly", nil];
    zoommodearray=[[NSArray alloc]initWithObjects:@"Fit",@"Standard",@"Large", nil];
    outstandingpaymentmodearray=[[NSArray alloc]initWithObjects:@"Per Student",@"Per Class", nil];
    
    
    if ([TimeTableMode isEqualToString:@"PopoverWeekly"] || [TimeTableMode isEqualToString:@"PopoverConsolidated"]) {
        popovermode=TRUE;
    }else{
        popovermode=FALSE;
    }
    
    
    
    
    headertitleview=[[UIView alloc]initWithFrame:CGRectMake(70, 0, self.view.bounds.size.width-140, 68)];
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
    //headercentername.text=[MyClass returncentershortnamewithcenterkey:nil];
    [headertitleview addSubview:headercentername];
    
    headercenternamearrow=[[UIImageView alloc]init];
    [headercenternamearrow setImage:[UIImage imageNamed:@"openbutton_white.png"]];
    headercenternamearrow.hidden=([MyClass isMultiCenterUser] && !popovermode)?NO:YES;
    [headertitleview addSubview:headercenternamearrow];
    //[self updateheadercentertitle];
    
    switchcenterbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, headertitleview.frame.size.width,68)];
    //[switchcenterbutton setImage:[UIImage imageWithData:globalvariables.menuimagedata] forState:UIControlStateNormal];
    switchcenterbutton.layer.cornerRadius=5;
    switchcenterbutton.layer.masksToBounds=YES;
    if ([MyClass isMultiCenterUser] && !popovermode) {
        [switchcenterbutton addTarget:self action:@selector(switchcenterbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    }
    [headertitleview addSubview:switchcenterbutton];

    switchcenterviewcontroller = (SwitchCenterViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SwitchCenterViewController"];
    //switchcenterviewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
    switchcenterviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    switchcenterviewcontroller.delegate=self;
    

    ClassTypeArray=[[NSMutableArray alloc]initWithObjects:@"All Class Types",@"Attending",@"Class",@"Makeup",@"Assessment",@"Trial", nil];

    classtypeselected=@"All";
    
    [scviewtype setTitle:[MyClass returntitlewithtitle:@"Enrollment View"] forSegmentAtIndex:0];
    [scviewtype setTitle:[MyClass returntitlewithtitle:@"Attendent View"] forSegmentAtIndex:1];
    [scviewtype addTarget:self action:@selector(selectview:) forControlEvents:UIControlEventValueChanged];
    scviewtype.selectedSegmentIndex=1;
    scviewtype.tintColor=themecolor;

    
    HeaderBar.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];
    
    FreeScheduleTable=[[UITableView alloc]init];
    FreeScheduleTable.dataSource=self;
    FreeScheduleTable.delegate=self;
    
    freeschedulemasterView=[[UIView alloc]init];
    FreeScheduleClassObject=[[FreeScheduleClass alloc]init];
    
    currentscscheduleindex=0;
    
    selectedtabbutton=[[UIButton alloc]init];
    

    reloadbutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-45, 34, 28,28)];
    [reloadbutton setImage:[UIImage imageNamed:@"reload_black.png"] forState:UIControlStateNormal];
    [reloadbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    reloadbutton.alpha=0.4;
    [reloadbutton addTarget: self action:@selector(reloadpage) forControlEvents: UIControlEventTouchUpInside];
    [supermasterview addSubview:reloadbutton];

    CancelButton=[[UIButton alloc]initWithFrame:CGRectMake(934, 36, 74,30)];
    [CancelButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    [CancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CancelButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [CancelButton addTarget: self action:@selector(cancelselection:) forControlEvents: UIControlEventTouchUpInside];
    [supermasterview addSubview:CancelButton];
    CancelButton.hidden=YES;
    
    ShareButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-45, 34, 30,30)];
    [ShareButton setImage:[UIImage imageNamed:@"sharebutton_white.png"] forState:UIControlStateNormal];
    [ShareButton addTarget: self action:@selector(printbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [supermasterview addSubview:ShareButton];
    
    
    menubutton=[[UIButton alloc]initWithFrame:CGRectMake(15, 35, 33, 22)];
    [menubutton setImage:[UIImage imageNamed:@"menu-button.png"] forState:UIControlStateNormal];
    [menubutton setContentMode:UIViewContentModeScaleToFill];
    [menubutton addTarget:self action:@selector(menubuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [supermasterview addSubview:menubutton];
    
    //df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];

    superview=[[UIView alloc]initWithFrame:CGRectMake(0, tabley-superviewclearence, self.view.bounds.size.width, self.view.bounds.size.height-tabley+superviewclearence)];
    superview.backgroundColor=tablecolor;
    [supermasterview addSubview:superview];
    

    
    tabpanelview=[[UIView alloc]initWithFrame:CGRectMake(0, tabley-superviewclearence-tabheight+2, superview.frame.size.width, 30)];
    tabpanelview.backgroundColor=tablecolor;//[UIColor blackColor];
//    [supermasterview addSubview:tabpanelview];

    

    
    //add master scrollview
    masterScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(tablex, superviewclearence+66, self.view.bounds.size.width, superview.frame.size.height-superviewclearence-66)];
    masterScrollView.delegate=self;
    masterScrollView.bounces=NO;
    masterScrollView.scrollEnabled=YES;
    [superview addSubview:masterScrollView];
    

    
    TimeTableView=[[UIView alloc]init];//WithFrame:CGRectMake(0, 0, totalSubjectColumn*cellwidth, NoOfTimeSlot*cellheight+extraheight)];
    TimeTableView.clipsToBounds=NO;
    [masterScrollView addSubview:TimeTableView];
    
    

    
    vfl=[[ClassTimeTableCollectionVFL alloc]init];
    vfl.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    timetablecollectionview=[[UICollectionView alloc]initWithFrame:CGRectMake(0, superviewclearence+66, self.view.bounds.size.width, superview.frame.size.height-superviewclearence-66) collectionViewLayout:vfl];
    //timetablecollectionview.clipsToBounds=NO;
    timetablecollectionview.bounces=NO;
    timetablecollectionview.delegate=self;
    timetablecollectionview.dataSource=self;
    timetablecollectionview.backgroundColor=[UIColor clearColor];
    //timetablecollectionview.contentSize=CGSizeMake(2000, 2000);
    [timetablecollectionview registerClass:[ClassTimeTableCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [superview addSubview:timetablecollectionview];
    
    contentViewBackgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    contentViewBackgroundButton.frame = timetablecollectionview.bounds;
    [contentViewBackgroundButton setTitle:@"" forState:UIControlStateNormal];
    contentViewBackgroundButton.backgroundColor = [UIColor clearColor];
    [contentViewBackgroundButton addTarget:self
                                    action:@selector(contentViewBackgroundButtonPressed:withEvent:)
                          forControlEvents:UIControlEventTouchUpInside];
    contentViewBackgroundButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    

    [ClassTypeSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Class Types"] forState:UIControlStateNormal];
    ClassTypeSelectionButton.backgroundColor=themecolor;
    filterbutton.backgroundColor=themecolor;
    viewoptionbutton.backgroundColor=themecolor;


    
    [supermasterview bringSubviewToFront:selectedtabbutton];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    
    systemmessagelabel=[[UILabel alloc]init];
    //systemmessagelabel.alpha=0.7;
    systemmessagelabel.textAlignment=NSTextAlignmentCenter;
    [systemmessagelabel setFont:[UIFont systemFontOfSize:18]];
    systemmessagelabel.layer.borderColor=[UIColor darkGrayColor].CGColor;
    systemmessagelabel.layer.borderWidth=0.5;
    //systemmessagelabel.text=nointernet?[MyClass returntitlewithtitle:@"Internet connection is lost. Please try again"]: [MyClass returntitlewithtitle:@"Loading data. Please wait"];
    systemmessagelabel.backgroundColor=[UIColor systemGroupedBackgroundColor];
    systemmessagelabel.textColor=[UIColor grayColor];
    systemmessagelabel.tag=889;
    [supermasterview addSubview:systemmessagelabel];
    
    

    
    [self refreshlanguage];

    
    datebartablebackground=[[UILabel alloc]initWithFrame:CGRectMake(0, superviewclearence+1, self.view.bounds.size.width, 65)];
    datebartablebackground.backgroundColor=[UIColor lightGrayColor];
    datebartablebackground.text=[MyClass returntitlewithtitle:@"Center Time Table"];
    datebartablebackground.textColor=[UIColor darkGrayColor];
    datebartablebackground.textAlignment=NSTextAlignmentCenter;
    datebartablebackground.hidden=YES;
    [superview addSubview:datebartablebackground];
    
    
    datebartable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    datebartable.delegate=self;
    datebartable.dataSource=self;
    datebartable.scrollEnabled=NO;
    datebartable.backgroundColor=[UIColor clearColor];
    datebartable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [datebartable setShowsVerticalScrollIndicator:NO];
    [superview addSubview:datebartable];
    
    
    //datebartable.frame=CGRectMake(69, 0, datebartable.bounds.size.height, datebartable.bounds.size.width);
    datebartable.transform=CGAffineTransformMakeRotation(-M_PI_2);
    
    UITapGestureRecognizer *doubleTap= [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureCaptured:)];
    doubleTap.delaysTouchesBegan=YES;
    doubleTap.numberOfTapsRequired=2;
    [datebartable addGestureRecognizer:doubleTap];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checktoreloadapp) name:UIApplicationWillEnterForegroundNotification object:nil];
    calendarbutton.backgroundColor=themecolor;
    
    supermasterviewbutton=[[UIButton alloc]initWithFrame:self.view.bounds];
    [supermasterviewbutton addTarget:self action:@selector(closecalendar) forControlEvents:UIControlEventTouchUpInside];
    [supermasterview addSubview:supermasterviewbutton];
    supermasterviewbutton.hidden=YES;
    
    
    calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 0, 320, self.view.bounds.size.height) Theme:1 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:YES showclassdot:YES schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
    calendarview.delegate=self;
    [supermasterview addSubview:calendarview];
    classTimeView=[[UIScrollView alloc]initWithFrame:CGRectMake(tablex, superviewclearence+66, 60, 1000)];
    [superview addSubview:classTimeView];
    
    
    TimeLabel=[[UILabel alloc]init];
    TimeLabel.textAlignment=NSTextAlignmentCenter;
    [TimeLabel setFont:[UIFont systemFontOfSize:14]];
    TimeLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
    TimeLabel.layer.borderWidth=0.3;
    TimeLabel.text=[MyClass returntitlewithtitle:@"Time"];
    TimeLabel.hidden=YES;
    TimeLabel.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [superview addSubview:TimeLabel];
    
    
    
//    mainWindow= self.view;//[[UIApplication sharedApplication] delegate] window];
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.anyObject.delegate;
    mainWindow = sceneDelegate.window;
    
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
    [self->sidewindowview addSubview:ailoadindicator];
    
    
    //for makeup window
    if ([TimeTableMode isEqualToString:@"PopoverWeekly"]){
//        detailViewMode=NO;
        ShareButton.hidden=!detailViewMode;
        headertype=@"Subject";
        contentmode=@"Instructor";
    }else{
//        detailViewMode=[[MyClass getlocaldbwithparameter:@"classtimetableviewmode"] isEqualToString:@"Standard"]?NO:YES;
        ShareButton.hidden=!detailViewMode;
        headertype=[MyClass getlocaldbwithparameter:@"classtimetableheadertype"];
        contentmode=[MyClass getlocaldbwithparameter:@"classtimetablecontentmode"];
        [self reloadcontentmodearraywithheadertype:headertype];
    }
    

    
//    filtermode=@"Off";
    [filterbutton setImage:[UIImage imageNamed:@"filteronbutton_white.png"] forState:UIControlStateNormal];
    
    cellduration=30;
    zoommode=((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).timetablezoommode;
    weeklyMode=[[MyClass getlocaldbwithparameter:@"classtimetableviewmode"] isEqualToString:@"Daily"]?NO:YES;
    
    detailViewMode=TRUE;
    combine3rddimension=NO;//[[MyClass getlocaldbwithparameter:@"classtimetablecombine3rddimension"] isEqualToString:@"Yes"];
    groupsubjectcategory=[[MyClass getlocaldbwithparameter:@"groupsubjectcategory"] isEqualToString:@"Yes"];
    filtermode=[[MyClass getlocaldbwithparameter:@"hideemptycolumns"] isEqualToString:@"Yes"]?@"On":@"Off";
    
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTextColor:[UIColor darkGrayColor]];
    
    reusableItems=[[NSMutableArray alloc]init];
    visibleItems=[[NSMutableDictionary alloc]init];
    visibleRect=CGRectMake(0, 0, masterScrollView.frame.size.width, masterScrollView.frame.size.height);
    
}

-(void) checktoreloadapp
{
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {

        if ([myPopoverController presentingViewController].isBeingPresented) {
            [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([myFreeSchedulePopoverController presentingViewController].isBeingPresented){
            [[myFreeSchedulePopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([myClassTypeSelectionPopoverController presentingViewController].isBeingPresented){
            [[myClassTypeSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([myClassSelectionPopoverController presentingViewController].isBeingPresented){
            [[myClassSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==switchcenterviewcontroller) {
            [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.mainSlideMenu closeLeftMenu];
        }
        [self closesidewindow];
        [MyClass removeallsidewindowsexceptsidewindow:sidewindowview sidewindowbutton:sidewindowviewclosebutton];
        globalvariables.appbecomeactiveaction=@"";
        globalvariables.leftmenuindex=@"0";
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [MyClass reloadApp];
    }else if ([globalvariables.appbecomeactiveaction isEqualToString:@"refresh"]){

        globalvariables.appbecomeactiveaction=@"";
        
        

                if ([myPopoverController presentingViewController].isBeingPresented) {
                    [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if ([myFreeSchedulePopoverController presentingViewController].isBeingPresented){
                    [[myFreeSchedulePopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if ([myClassTypeSelectionPopoverController presentingViewController].isBeingPresented){
                    [[myClassTypeSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if ([myClassSelectionPopoverController presentingViewController].isBeingPresented){
                    [[myClassSelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if (self.presentedViewController==switchcenterviewcontroller) {
                    [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
                }else{
                    [self.mainSlideMenu closeLeftMenu];
                }
        [self closesidewindow];
        [MyClass removeallsidewindowsexceptsidewindow:sidewindowview sidewindowbutton:sidewindowviewclosebutton];
                [self reloadPageWithFirstLoad:NO];
            //}
        //}];
    }
}



-(void) refreshlanguage
{
    
    headercentername.text=[MyClass returnWindowTitle];
    headertitlename.text=[MyClass returntitlewithtitle:@"Center Time Table"];
    [title_Cancel setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    [scviewtype setTitle:[MyClass returntitlewithtitle:@"Enrollment View"] forSegmentAtIndex:0];
    [scviewtype setTitle:[MyClass returntitlewithtitle:@"Attendent View"] forSegmentAtIndex:1];
    [ClassTypeSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Class Types"] forState:UIControlStateNormal];
    [scscheduletype setTitle:[MyClass returntitlewithtitle:@"Free Schedule"] forSegmentAtIndex:0];
    [self updateheadercentertitle];
    searchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    //[self updatePopupButton];
    //searchbar.searchTextField.textColor=[UIColor darkGrayColor];
    
}

-(void) updateheadercentertitle
{
    
    [headercentername sizeToFit];
    CGRect myframe=headercentername.frame;
    if (myframe.size.width>headertitleview.frame.size.width) {
        headercentername.frame=CGRectMake(([MyClass isMultiCenterUser] && !popovermode)?-4:0, 43, headertitleview.frame.size.width, 22);
    }else{
        headercentername.frame=CGRectMake((headertitleview.frame.size.width-myframe.size.width)/2+(([MyClass isMultiCenterUser] && !popovermode)?-4:0), 43, myframe.size.width, 22);
    }
    headercenternamearrow.frame=CGRectMake(headercentername.frame.size.width+headercentername.frame.origin.x, 50.5, 8, 8);
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    globalvariables.lastviewcontroller=(NSString *)self;
    
    if (sidewindowview.frame.origin.x==mainWindow.bounds.size.width) {
        [self reloadPageWithFirstLoad:YES];
        //[self updatecalendarview];
    }
}

-(void) reloadcontentmodearraywithheadertype:(NSString *)header_type
{
    if ([header_type isEqualToString:@"Subject"]) {
        contentmodearray=[[NSArray alloc]initWithObjects:@"Instructor",@"Classroom", nil];
    }else if ([header_type isEqualToString:@"Classroom"]){
        contentmodearray=[[NSArray alloc]initWithObjects:@"Subject",@"Instructor", nil];
    }else if ([header_type isEqualToString:@"Instructor"]){
        contentmodearray=[[NSArray alloc]initWithObjects:@"Subject", @"Classroom",nil];
    }else if ([header_type isEqualToString:@"All"]){
        contentmodearray=[[NSArray alloc]initWithObjects:@"Subject",@"Instructor",@"Classroom", nil];
    }
    
}

-(void) delayviewload
{
    if ([TimeTableMode isEqualToString:@"PopoverConsolidated"]) {
        [self generateTimeTablewithViewOption:@"PopoverConsolidated" pastMonday:@"" classtype:@"All" redrawscoller:YES];
    }else if ([TimeTableMode isEqualToString:@"PopoverWeekly"]){
        
        if (startupmonday && ![startupmonday isEqualToString:@""]) {
            [self generateTimeTablewithViewOption:@"PopoverWeekly" pastMonday:startupmonday classtype:@"All" redrawscoller:YES];
        }else{
            [self generateTimeTablewithViewOption:@"PopoverWeekly" pastMonday:@"" classtype:@"All" redrawscoller:YES];
        }
    }else{
        TimeTableMode=@"Weekly";
        [self generateTimeTablewithViewOption:TimeTableMode pastMonday:globalselecteddate classtype:classtypeselected redrawscoller:YES];


    }
    
    ClassScheduleTableShown=FALSE;
    
//    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    

}

-(void) reloadpage
{
    [MyClass getLatestDataSetv2withParameters:@"subject,staff,classroom,centersettings,userroleandprivilege" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
        dispatch_async(dispatch_get_main_queue(), ^{
        if (viewingcentersdeleted) {
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            if (globalvariables.CenterDict.count>0) {
                [self switchcenterbuttonpressed];
            }
        }else{
            if ([headertype isEqualToString:@"Subject"]) {
                headerArray=[MyClass retrievesubjectinformationwithstatus:@"All" category:@"All" flushcachedata:NO];
            }else if ([headertype isEqualToString:@"Classroom"]){
                headerArray=[MyClass retrieveClassroomListwithstatus:@"All" withTBD:NO flushcachedata:NO];
            }else{
                headerArray=[MyClass retrieveStaffListwithvalid:@"All" role:@"Instructor" flushcachedata:NO];
            }
            
            if (headerArray) {
                if (TabArray.count==0 || !TabArray) {
                    [self retrievetabviewpreferencewithselecteddatereset:YES];
                }
                InstructorArray=[MyClass retrieveInstructorListwithvalid:@"All" flushcachedata:NO];
                AvailableInstructorNameArray=[MyClass retrieveInstructorListwithvalid:@"Yes" flushcachedata:NO];
                
                [self performSelector:@selector(delayviewload) withObject:nil afterDelay:0];
                reloadbutton.hidden=YES;
            }
        }
        });
    }];

    

}


- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here
    if (myPopoverController){
        
        if ([[[NSString stringWithFormat:@"%d",(int)(selectedbutton.tag/1000)] substringFromIndex:4] floatValue]*cellheight-121>0) {
            [masterScrollView setContentOffset:CGPointMake(0, [[[NSString stringWithFormat:@"%d",(int)(selectedbutton.tag/1000)] substringFromIndex:4] floatValue]*cellheight-121)];
        }
        
    }else if ((int)([lastexpandcellposition integerValue]/totalSubjectColumn)>1) {
        CGPoint offset=CGPointMake(0, cellheight*(int)([lastexpandcellposition integerValue]/totalSubjectColumn));
        [masterScrollView setContentOffset:offset];
    }
}

- (void)keyboardDidHide: (NSNotification *) notif{
    if (((int)([lastexpandcellposition integerValue]/totalSubjectColumn)+1)*cellheight+40+20+ClassDetailTable.contentSize.height+20>(NoOfTimeSlot*cellheight) && ClassScheduleTableShown==TRUE) {
        [masterScrollView setContentOffset:CGPointMake(0, (((int)([lastexpandcellposition integerValue]/totalSubjectColumn)+1)*cellheight+40+20+ClassDetailTable.contentSize.height)-(NoOfTimeSlot*cellheight))];
    }else{
        [masterScrollView setContentOffset:CGPointMake(0, 0)];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

-(NSMutableArray *) returnselecteddatearray
{
    NSMutableArray *resultarray=[[NSMutableArray alloc]init];

        long offset=[MyClass returnDateOffsetWithDate:[MyClass convertToNSDateWithDate:[self findsundayintheweek: globalselecteddate] DateFormat:@"dd-MMM-yyyy"]];
        for (int i=0; i<7; i++) {
            [resultarray addObject:[MyClass returnDateFromBaseDateWithOffset:i+offset]];
        }
    
    return resultarray;
}

-(IBAction) opencalendar:(UIButton *)sender
{
    if(![TimeTableMode isEqualToString:@"Consolidated"]){
        [self.mainSlideMenu disableSlidePanGestureForLeftMenu];
        [calendarview refreshviewwithoption:@"start"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updatecalendarview];
        });

        [UIView animateWithDuration:0.3 animations:^{
            supermasterviewleadingconstraint.constant=-320;
            [self.view layoutIfNeeded];
            supermasterviewbutton.hidden=NO;
        } completion:nil];
    }else{
        [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:[classDay firstObject], nil] DataType:@"dayofweek" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(140, allClassDay.count*40) View:self Button:sender ItemsArray:[[NSMutableArray alloc]initWithArray:allClassDay] Title:nil];
    }
    
}

- (IBAction)openviewoption:(id)sender
{
    UIView *viewoptionview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
    viewoptionview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    
    UIView *topbar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    topbar.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    [viewoptionview addSubview:topbar];
    
    //add toolbar
    UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
    toolbar.barStyle=UIBarStyleDefault;
    toolbar.clipsToBounds=YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 100, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(doneviewoption) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(320-button.frame.size.width-20, 33, button.frame.size.width, 20);
    [viewoptionview addSubview:button];
    
    
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneviewoption)];
//    barItems = [[NSMutableArray alloc]initWithObjects:flexSpace,doneButton, nil];
    
//    [toolbar setItems:barItems];
//    [viewoptionview addSubview:toolbar];

    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 60, 290, 25)];
    label.text=[MyClass returntitlewithtitle:@"View Mode"];
    label.textColor=[UIColor darkGrayColor];
    label.font=[UIFont systemFontOfSize:14];
    [viewoptionview addSubview:label];


    scviewmode=[[UISegmentedControl alloc]initWithItems:viewmodearray];
    [scviewmode setTitle:[MyClass returntitlewithtitle:[viewmodearray objectAtIndex:0]] forSegmentAtIndex:0];
    [scviewmode setTitle:[MyClass returntitlewithtitle:[viewmodearray objectAtIndex:1]] forSegmentAtIndex:1];
    scviewmode.frame=CGRectMake(15, 90, 290, 30);
    scviewmode.selectedSegmentIndex=weeklyMode?1:0;
    scviewmode.tintColor=themecolor;
//    [scviewmode addTarget:self action:@selector(changeviewmode:) forControlEvents:UIControlEventValueChanged];
    [viewoptionview addSubview:scviewmode];
  
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 140, 290, 25)];
    label.text=[MyClass returntitlewithtitle:@"Zoom Mode"];
    label.textColor=[UIColor darkGrayColor];
    label.font=[UIFont systemFontOfSize:14];
    [viewoptionview addSubview:label];
    
    
    sczoommode=[[UISegmentedControl alloc]initWithItems:zoommodearray];
    [sczoommode setTitle:[MyClass returntitlewithtitle:[zoommodearray objectAtIndex:0]] forSegmentAtIndex:0];
    [sczoommode setTitle:[MyClass returntitlewithtitle:[zoommodearray objectAtIndex:1]] forSegmentAtIndex:1];
    [sczoommode setTitle:[MyClass returntitlewithtitle:[zoommodearray objectAtIndex:2]] forSegmentAtIndex:2];
    sczoommode.frame=CGRectMake(15, 170, 290, 30);
    sczoommode.selectedSegmentIndex=zoommode;
    sczoommode.tintColor=themecolor;
    [viewoptionview addSubview:sczoommode];
    
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 220, 290, 25)];
    label.text=[MyClass returntitlewithtitle:@"Column Information"];
    label.textColor=[UIColor darkGrayColor];
    label.font=[UIFont systemFontOfSize:14];
    [viewoptionview addSubview:label];


    scheadertype=[[UISegmentedControl alloc]initWithItems:headertypearray];
    for (int i=0; i<headertypearray.count; i++) {
        [scheadertype setTitle:[MyClass returntitlewithtitle:[headertypearray objectAtIndex:i]] forSegmentAtIndex:i];
    }
    scheadertype.frame=CGRectMake(15, 250, 290, 30);
    scheadertype.selectedSegmentIndex=[headertypearray indexOfObject:headertype];
    scheadertype.tintColor=themecolor;
    [scheadertype addTarget:self action:@selector(changeheadertype:) forControlEvents:UIControlEventValueChanged];
    [viewoptionview addSubview:scheadertype];
    
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 300, 290, 25)];
    label.text=[MyClass returntitlewithtitle:@"Colored Information"];
    label.textColor=[UIColor darkGrayColor];
    label.font=[UIFont systemFontOfSize:14];
    [viewoptionview addSubview:label];
    
    sccontentmode=[[UISegmentedControl alloc]initWithItems:contentmodearray];
    for (int i=0; i<contentmodearray.count; i++) {
        [sccontentmode setTitle:[MyClass returntitlewithtitle:[contentmodearray objectAtIndex:i]] forSegmentAtIndex:i];
    }
    sccontentmode.frame=CGRectMake(15, 330, 290, 30);
    sccontentmode.tintColor=themecolor;
    sccontentmode.selectedSegmentIndex=[contentmodearray indexOfObject:contentmode];
    [sccontentmode addTarget:self action:@selector(changecontentmode:) forControlEvents:UIControlEventValueChanged];
    [viewoptionview addSubview:sccontentmode];
    
    //outstanding mode
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 380, 290, 25)];
    label.text=[MyClass returntitlewithtitle:@"Outstanding Payment Mode"];
    label.textColor=[UIColor darkGrayColor];
    label.font=[UIFont systemFontOfSize:14];
    [viewoptionview addSubview:label];
    
    
    scoutstandingpaymentmode=[[UISegmentedControl alloc]initWithItems:outstandingpaymentmodearray];
    [scoutstandingpaymentmode setTitle:[MyClass returntitlewithtitle:[outstandingpaymentmodearray objectAtIndex:0]] forSegmentAtIndex:0];
    [scoutstandingpaymentmode setTitle:[MyClass returntitlewithtitle:[outstandingpaymentmodearray objectAtIndex:1]] forSegmentAtIndex:1];
    scoutstandingpaymentmode.frame=CGRectMake(15, 410, 290, 30);
    scoutstandingpaymentmode.selectedSegmentIndex=[[MyClass getlocaldbwithparameter:@"timetableoutstandingmode"] isEqualToString:@"perstudent"]?0:1;
    scoutstandingpaymentmode.tintColor=themecolor;
    [viewoptionview addSubview:scoutstandingpaymentmode];
    
    groupsubjectcategorylabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 460, 290, 31)];
    groupsubjectcategorylabel.textColor=[UIColor darkGrayColor];
    groupsubjectcategorylabel.font=[UIFont systemFontOfSize:14];
    groupsubjectcategorylabel.text=[MyClass returntitlewithtitle:@"Group subject category"];
    [viewoptionview addSubview:groupsubjectcategorylabel];
    
    swgroupsubjectcategory = [[UISwitch alloc] init];
    swgroupsubjectcategory.onTintColor=themecolor;
    swgroupsubjectcategory.frame=CGRectMake(viewoptionview.frame.size.width-51-20, 460, 51, 31);
    swgroupsubjectcategory.on=groupsubjectcategory;
    [viewoptionview addSubview:swgroupsubjectcategory];
    
    hideemptycolumnslabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 500, 290, 31)];
    hideemptycolumnslabel.textColor=[UIColor darkGrayColor];
    hideemptycolumnslabel.font=[UIFont systemFontOfSize:14];
    hideemptycolumnslabel.text=[MyClass returntitlewithtitle:@"Hide empty columns"];
    [viewoptionview addSubview:hideemptycolumnslabel];
    
    swhideemptycolumns = [[UISwitch alloc] init];
    swhideemptycolumns.onTintColor=themecolor;
    swhideemptycolumns.frame=CGRectMake(viewoptionview.frame.size.width-51-20, 500, 51, 31);
    swhideemptycolumns.on=[filtermode isEqualToString:@"On"];
    [viewoptionview addSubview:swhideemptycolumns];
    
    showallstudentcountlabel=[[UILabel alloc]initWithFrame:CGRectMake(15, swhideemptycolumns.frame.origin.y+40, 290, 31)];
    showallstudentcountlabel.textColor=[UIColor darkGrayColor];
    showallstudentcountlabel.font=[UIFont systemFontOfSize:14];
    showallstudentcountlabel.text=[MyClass returntitlewithtitle:@"Show All Student Count"];
    [viewoptionview addSubview:showallstudentcountlabel];
    
    swshowallstudentcount = [[UISwitch alloc] init];
    swshowallstudentcount.onTintColor=themecolor;
    swshowallstudentcount.frame=CGRectMake(viewoptionview.frame.size.width-51-20, swhideemptycolumns.frame.origin.y+40, 51, 31);
    swshowallstudentcount.on=[[MyClass getlocaldbwithparameter:@"timetableshowallstudentcount"] isEqualToString:@"Y"];
    [viewoptionview addSubview:swshowallstudentcount];
    
    showattendingcountlabel=[[UILabel alloc]initWithFrame:CGRectMake(15, swshowallstudentcount.frame.origin.y+40, 290, 31)];
    showattendingcountlabel.textColor=[UIColor darkGrayColor];
    showattendingcountlabel.font=[UIFont systemFontOfSize:14];
    showattendingcountlabel.text=[MyClass returntitlewithtitle:@"Show Attending Student Count"];
    [viewoptionview addSubview:showattendingcountlabel];
    
    swshowattendingcount = [[UISwitch alloc] init];
    swshowattendingcount.onTintColor=themecolor;
    swshowattendingcount.frame=CGRectMake(viewoptionview.frame.size.width-51-20, swshowallstudentcount.frame.origin.y+40, 51, 31);
    swshowattendingcount.on=[[MyClass getlocaldbwithparameter:@"timetableshowattendingcount"] isEqualToString:@"Y"];
    [viewoptionview addSubview:swshowattendingcount];
    
    swshowoutstandingpaymentstudentcount = [[UISwitch alloc] init];
    swshowoutstandingpaymentstudentcount.onTintColor=themecolor;
    swshowoutstandingpaymentstudentcount.frame=CGRectMake(viewoptionview.frame.size.width-51-20, swshowattendingcount.frame.origin.y+40, 51, 31);
    swshowoutstandingpaymentstudentcount.on=[[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"] isEqualToString:@"Y"];
    [viewoptionview addSubview:swshowoutstandingpaymentstudentcount];
    
    showoutstandingpaymentstudentcountlabel=[[UILabel alloc]initWithFrame:CGRectMake(15, swshowattendingcount.frame.origin.y+40, 200, 100)];
    showoutstandingpaymentstudentcountlabel.numberOfLines=0;
    showoutstandingpaymentstudentcountlabel.textColor=[UIColor darkGrayColor];
    showoutstandingpaymentstudentcountlabel.font=[UIFont systemFontOfSize:14];
    showoutstandingpaymentstudentcountlabel.text=[MyClass returntitlewithtitle:@"Show Outstanding Payment Student Count"];
    [showoutstandingpaymentstudentcountlabel sizeToFit];
    showoutstandingpaymentstudentcountlabel.frame=CGRectMake(15, swshowoutstandingpaymentstudentcount.frame.origin.y+31/2-showoutstandingpaymentstudentcountlabel.frame.size.height/2, 200, showoutstandingpaymentstudentcountlabel.frame.size.height);
    [viewoptionview addSubview:showoutstandingpaymentstudentcountlabel];
    
    swshowlessonnumber = [[UISwitch alloc] init];
    swshowlessonnumber.onTintColor=themecolor;
    swshowlessonnumber.frame=CGRectMake(viewoptionview.frame.size.width-51-20, swshowoutstandingpaymentstudentcount.frame.origin.y+40, 51, 31);
    swshowlessonnumber.on=[[MyClass getlocaldbwithparameter:@"timetableshowlessonnumber"] isEqualToString:@"Y"];
    [viewoptionview addSubview:swshowlessonnumber];
    
    showlessonnumberlabel=[[UILabel alloc]initWithFrame:CGRectMake(15, showoutstandingpaymentstudentcountlabel.frame.origin.y+40, 200, 100)];
    showlessonnumberlabel.numberOfLines=0;
    showlessonnumberlabel.textColor=[UIColor darkGrayColor];
    showlessonnumberlabel.font=[UIFont systemFontOfSize:14];
    showlessonnumberlabel.text=[MyClass returntitlewithtitle:@"Show Lesson Number"];
    [showlessonnumberlabel sizeToFit];
    showlessonnumberlabel.frame=CGRectMake(15, swshowlessonnumber.frame.origin.y+31/2-showlessonnumberlabel.frame.size.height/2, 200, showlessonnumberlabel.frame.size.height);
    [viewoptionview addSubview:showlessonnumberlabel];
    
    
    [self refreshswitch3rddimension];
    
    
    UIView *bottomview=[[UIView alloc]initWithFrame:CGRectMake(0, 660+20+44, 320, self.view.bounds.size.height-20-44-660)];
    bottomview.backgroundColor=[UIColor whiteColor];
    [viewoptionview addSubview:bottomview];
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=viewoptionview;
    viewcontroller.preferredContentSize=CGSizeMake(320, self.view.bounds.size.height);

    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        viewcontroller.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:viewcontroller.view];
        [self addChildViewController:viewcontroller];
        [viewcontroller didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
}


-(void) refreshswitch3rddimension
{
    /*if (scviewmode.selectedSegmentIndex==1) {
        combine3rddimensionlabel.hidden=YES;
        swcombine3rddimension.hidden=YES;
    }else{*/
//        combine3rddimensionlabel.hidden=scheadertype.selectedSegmentIndex==0;
//        swcombine3rddimension.hidden=scheadertype.selectedSegmentIndex==0;
//        if (sccontentmode.selectedSegmentIndex==0) {
//            combine3rddimensionlabel.text=[MyClass returntitlewithtitle:[NSString stringWithFormat:@"Combine different %@",[contentmodearray objectAtIndex:1]]];
//        }else{
//            combine3rddimensionlabel.text=[MyClass returntitlewithtitle:[NSString stringWithFormat:@"Combine different %@",[contentmodearray objectAtIndex:0]]];
//        }
    //}
//    sccontentmode.enabled=YES;/*scviewmode.selectedSegmentIndex==1 || (scviewmode.selectedSegmentIndex==0 && scheadertype.selectedSegmentIndex!=0)*/;
}

-(void) switchcombine3rddimension:(UISwitch *)sender
{
    //combine3rddimension=sender.on;
    //[MyClass updatelocaldbwithparameter:@"classtimetablecombine3rddimension" value:sender.on?@"Yes":@"No"];
}

-(void) changeviewmode:(UISegmentedControl *)sender
{
    //sccontentmode.enabled=sender.selectedSegmentIndex==0?YES:NO;
    [self refreshswitch3rddimension];
}

-(void) changecontentmode:(UISegmentedControl *)sender
{
    [self refreshswitch3rddimension];
}

-(void) changeheadertype:(UISegmentedControl *)sender
{
    [self reloadcontentmodearraywithheadertype:[headertypearray objectAtIndex:sender.selectedSegmentIndex]];
    
    if (contentmodearray.count !=sccontentmode.numberOfSegments) {
        if (contentmodearray.count>sccontentmode.numberOfSegments) {
            [sccontentmode insertSegmentWithTitle:@"" atIndex:sccontentmode.numberOfSegments animated:NO];
        }else{
            [sccontentmode removeSegmentAtIndex:sccontentmode.numberOfSegments-1 animated:NO];
        }
    }
    
    for (int i=0; i<contentmodearray.count; i++) {
        [sccontentmode setTitle:[MyClass returntitlewithtitle:[contentmodearray objectAtIndex:i]] forSegmentAtIndex:i];
    }
    sccontentmode.selectedSegmentIndex=0;
//    swgroupsubjectcategory.enabled=[[headertypearray objectAtIndex:sender.selectedSegmentIndex] isEqualToString:@"All"];
//    groupsubjectcategorylabel.enabled=swgroupsubjectcategory.enabled;
//    [self refreshswitch3rddimension];
}

-(void) doneviewoption
{
    [self adjustpresentingviewwidthwithwidth:0];
    if (![[headertypearray objectAtIndex:scheadertype.selectedSegmentIndex] isEqualToString:headertype] || ![[contentmodearray objectAtIndex:sccontentmode.selectedSegmentIndex] isEqualToString:contentmode] || groupsubjectcategory!=swgroupsubjectcategory.on || [filtermode isEqualToString:@"On"]!=swhideemptycolumns.on || ![[viewmodearray objectAtIndex:scviewmode.selectedSegmentIndex] isEqualToString:weeklyMode?@"Weekly":@"Daily"] || swshowallstudentcount.on!=[[MyClass getlocaldbwithparameter:@"timetableshowallstudentcount"] isEqualToString:@"Y"] || swshowattendingcount.on!=[[MyClass getlocaldbwithparameter:@"timetableshowattendingcount"] isEqualToString:@"Y"] || swshowoutstandingpaymentstudentcount.on!=[[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"] isEqualToString:@"Y"]  || (scoutstandingpaymentmode.selectedSegmentIndex!=[[MyClass getlocaldbwithparameter:@"timetableoutstandingmode"] isEqualToString:@"perstudent"]?0:1) || ![swshowlessonnumber.on?@"Y":@"N" isEqualToString:[MyClass getlocaldbwithparameter:@"timetableshowlessonnumber"]]) {
        
        ShareButton.hidden=/*!detailViewMode*/NO;
        headertype=[headertypearray objectAtIndex:scheadertype.selectedSegmentIndex];
        contentmode=[contentmodearray objectAtIndex:sccontentmode.selectedSegmentIndex];
        [MyClass updatelocaldbwithparameter:@"classtimetableheadertype" value:headertype];
        [MyClass updatelocaldbwithparameter:@"classtimetablecontentmode" value:contentmode];

        groupsubjectcategory=swgroupsubjectcategory.on;
        filtermode=swhideemptycolumns.on?@"On":@"Off";
        selectedHeaderArray=[self returnSelectedHeaderArray];
        [MyClass updatelocaldbwithparameter:@"groupsubjectcategory" value:groupsubjectcategory?@"Yes":@"No"];
        [MyClass updatelocaldbwithparameter:@"hideemptycolumns" value:[filtermode isEqualToString:@"On"]?@"Yes":@"No"];
        [MyClass updatelocaldbwithparameter:@"timetableshowallstudentcount" value:swshowallstudentcount.on?@"Y":@"N"];
        [MyClass updatelocaldbwithparameter:@"timetableshowattendingcount" value:swshowattendingcount.on?@"Y":@"N"];
        [MyClass updatelocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount" value:swshowoutstandingpaymentstudentcount.on?@"Y":@"N"];
        [MyClass updatelocaldbwithparameter:@"timetableshowlessonnumber" value:swshowlessonnumber.on?@"Y":@"N"];
        
        if(![[viewmodearray objectAtIndex:scviewmode.selectedSegmentIndex] isEqualToString:weeklyMode?@"Weekly":@"Daily"]){
            weeklyMode=scviewmode.selectedSegmentIndex==1;
            [MyClass updatelocaldbwithparameter:@"classtimetableviewmode" value:weeklyMode?@"Weekly":@"Daily"];
            if(weeklyMode){
                globalvariables.centerdayofweekarray=[[NSMutableArray alloc]initWithArray:[((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).classtimetabledaystodisplay componentsSeparatedByString:@","]];
            }else{
                NSString *dayofweek=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"EEE"];
                globalvariables.centerdayofweekarray=[[NSMutableArray alloc]initWithObjects:dayofweek, nil];
            }
        }
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ClassScheduleTableShown=FALSE;
            classTimeView.frame=CGRectMake(0, classTimeView.frame.origin.y, [self returnclasstimewidth], NoOfTimeSlot*cellheight);
            datebartable.contentOffset=CGPointMake(0, 0);
            masterScrollView.contentOffset=CGPointMake(0, 0);
            timetablecollectionview.contentOffset=CGPointMake(0, 0);
            
            if(zoommode!=sczoommode.selectedSegmentIndex){
                [MyClass updateUserAccountSettingsWithField:@"timetablezoommode" Value:[@(sczoommode.selectedSegmentIndex) stringValue]];
            }
            zoommode=sczoommode.selectedSegmentIndex;
            
            if ([headertype isEqualToString:@"Subject"]) {
                headerArray=[MyClass retrievesubjectinformationwithstatus:@"All" category:@"All" flushcachedata:NO];
            }else if ([headertype isEqualToString:@"Classroom"]){
                headerArray=[MyClass retrieveClassroomListwithstatus:@"All" withTBD:NO flushcachedata:NO];
            }else if ([headertype isEqualToString:@"Instructor"]){
                headerArray=[MyClass retrieveStaffListwithvalid:@"All" role:@"Instructor" flushcachedata:NO];
            }else{
                headerArray=[[NSMutableArray alloc]initWithObjects:@"All", nil];
            }

            
            [self retrievetabviewpreferencewithselecteddatereset:NO];
            legendscrollview.hidden=[headertype isEqualToString:@"All"] && !detailViewMode;
            TabAddButton.hidden=[headertype isEqualToString:@"All"];
            [self selectsubjectdelay];
            [datebartable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    }else if (zoommode!=sczoommode.selectedSegmentIndex ){
        zoommode=sczoommode.selectedSegmentIndex;
        [MyClass updateUserAccountSettingsWithField:@"timetablezoommode" Value:[@(sczoommode.selectedSegmentIndex) stringValue]];
        [self loadTimeTablewithviewoption:TimeTableMode];
    }
    
    if([TimeTableMode isEqualToString:@"Consolidated"]){
        calendarbutton.enabled=!weeklyMode;
    }else{
        calendarbutton.enabled=TRUE;
    }
}

-(void) returnTimeTableFilterSelectedItems:(NSMutableDictionary *)selecteditems
{
    [self closesidewindow];
    selectedSubjectArray=[selecteditems valueForKey:@"subject"]?[[NSMutableArray alloc]initWithArray:[selecteditems valueForKey:@"subject"]]:nil;
    selectedClassroomArray=[selecteditems valueForKey:@"classroom"]?[[NSMutableArray alloc]initWithArray:[selecteditems valueForKey:@"classroom"]]:nil;
    selectedInstructorArray=[selecteditems valueForKey:@"instructor"]?[[NSMutableArray alloc]initWithArray:[selecteditems valueForKey:@"instructor"]]:nil;
    NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
    if (selectedSubjectArray) {
        [dict setValue:selectedSubjectArray forKey:@"Subject"];
    }else{
        [dict setValue:@"All" forKey:@"Subject"];
    }
    
    if (selectedClassroomArray) {
        [dict setValue:selectedClassroomArray forKey:@"Classroom"];
    }else{
        [dict setValue:@"All" forKey:@"Classroom"];
    }
    
    if (selectedInstructorArray) {
        [dict setValue:selectedInstructorArray forKey:@"Instructor"];
    }else{
        [dict setValue:@"All" forKey:@"Instructor"];
    }

    NSMutableDictionary *localdict=[self getTimeTableFilterValues];
    [localdict setValue:dict forKey:globalvariables.centerrecord.centerkey];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:localdict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [MyClass updatelocaldbwithparameter:@"timetablefiltervalues" value:jsonString];
    
    selectedHeaderArray=[self returnSelectedHeaderArray];
    
    [self generateTimeTablewithViewOption:TimeTableMode pastMonday:globalselecteddate classtype:classtypeselected redrawscoller:NO];
//    [self loadTimeTablewithviewoption:TimeTableMode];
}

-(NSMutableDictionary *) getTimeTableFilterValues
{
    NSString *jsonString=[MyClass getlocaldbwithparameter:@"timetablefiltervalues"];
    if([jsonString isEqualToString:@""]){
        return [[NSMutableDictionary alloc]init];
    }else{
        NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableDictionary *jsonData= [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSMutableDictionary *returnData=[[NSMutableDictionary alloc]init];
        for (NSString* key in jsonData) {
            [returnData setValue:jsonData[key] forKey:key];
        }
        return returnData;
    }
}

-(void) closecalendar
{
    [self.mainSlideMenu enableSlidePanGestureForLeftMenu];
    [UIView animateWithDuration:0.3 animations:^{
        //supermasterview.frame=CGRectMake(0, 0, supermasterview.frame.size.width, supermasterview.frame.size.height);
        supermasterviewleadingconstraint.constant=0;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){supermasterviewbutton.hidden=YES;}];
}


-(BOOL) findinstructorcountpersubjectWithViewoption:(NSString *)viewoption Classdate:(NSString *)classdate Classtime:(NSString *)classtime Classtype:(NSString *)classtype
{
    //if ([dailyweeklyviewselected isEqualToString:@"Weekly"]) {
        classDay=[[NSMutableArray alloc]initWithArray:globalvariables.centerdayofweekarray copyItems:YES];
    /*}else{
        [df setDateFormat:@"yyyy-MM-dd"];
        NSDate *date=[df dateFromString:classdate];
        [df setDateFormat:@"EEE"];
        classDay=[[NSMutableArray alloc]initWithObjects:[df stringFromDate:date], nil];
    }*/
    
    if (TabArray.count>0 || selectedtabbutton.tag==99) {
        NSString *strURL;
        NSString *time=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"HH:mm"];
        //[df setDateFormat:@"HH:mm"];
        if ([viewoption isEqualToString:@"Consolidated"] || [viewoption isEqualToString:@"PopoverConsolidated"]) {
            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetable2&viewoption=consolidated&classdate=%@&classtype=%@&draftenrollmentkey=%@&headerlist=%@&classday=%@&classtime=%@&headertype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclasstimetable"],classdate,classtype,draftenrollmentkey,[MyClass enurlstring:[selectedHeaderArray componentsJoinedByString:@","]],[classDay componentsJoinedByString:@","],time,headertype];
        }else if ([viewoption isEqualToString:@"Weekly"] || [viewoption isEqualToString:@"PopoverWeekly"]){
            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetable2&viewoption=weekly&classdate=%@&classtype=%@&draftclasskey=%@&headerlist=%@&classday=%@&classtime=%@&headertype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclasstimetable"], classdate,classtype,draftclasskey,[MyClass enurlstring:[selectedHeaderArray componentsJoinedByString:@","]],[classDay componentsJoinedByString:@","],time,headertype];
        }
        
        
        __block BOOL result=FALSE;
        [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                NSDate *date;
                result=TRUE;
                    NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                JSONArray = jsonreturned[@"content"];
                    
                    //Set up our class time table array
                    
                    NSString *newstartdate;
                    NSString *newclassday;
                    NSString *newclasstime;
                    NSString *newsubject;
                    NSString *newinstructor;
                    NSString *newclassroom;
                    NSString *newclassduration;
                    NSString *newstudentkey;
                    NSString *newfirstname;
                    NSString *newlastname;
                    NSString *newinstructorfullname;
                    NSString *newsubjectfullname;
                NSString *subjecttype;

                    if ([filtermode isEqualToString:@"On"] && ![headertype isEqualToString:@"All"]) {
                        filteredHeaderArray=[[NSMutableArray alloc]init];
                        if (JSONArray.count==0) {
                            [filteredHeaderArray addObject:@"TBD"];
                        }
                    }else if([headertype isEqualToString:@"All"]){
                        filteredHeaderArray=[[NSMutableArray alloc]init];
                        [filteredHeaderArray addObject:@"All"];
                    }

                    ClassTimeTableRecordArray = [[NSMutableArray alloc]init];
                    ClassTimeTableRecordDictionary=[[NSMutableDictionary alloc]init];
                    InstructorNameArray=[[NSMutableArray alloc]init];
                    ClassroomNameArray=[[NSMutableArray alloc]init];
                    SubjectNameArray=[[NSMutableArray alloc]init];
                    
                    classtimetableobjectArray=[[NSMutableArray alloc]init];
                    
                    //add other timeslots
                    for (int i=0; i<JSONArray.count; i++) {
                        newstartdate=[[JSONArray objectAtIndex:i] objectForKey:@"startdate"];
                        newclassday=[[JSONArray objectAtIndex:i] objectForKey:@"classday"];
                        newclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                        newsubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                        newinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
                        newclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
                        newstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                        newfirstname=[[JSONArray objectAtIndex:i] objectForKey:@"firstname"];
                        newlastname=[[JSONArray objectAtIndex:i] objectForKey:@"lastname"];
                        newclassduration=[[JSONArray objectAtIndex:i] objectForKey:@"classduration"];
                        subjecttype=[[JSONArray objectAtIndex:i] objectForKey:@"subjecttype"];
                        if ([newclassroom isEqualToString:@""]) {
                            newclassroom=@"TBD";
                        }
                        //newcount=[[JSONArray objectAtIndex:i] objectForKey:@"count"];
                        
                        if (![newstartdate isEqualToString:@"TBD"] && ![newclasstime isEqualToString:@"TBD"]) {
                            if ([globalvariables.centerdayofweekarray containsObject:newclassday]) {
                                
                                //add to instructor name array
                                if (![InstructorNameArray containsObject:newinstructor]) {
                                    [InstructorNameArray addObject:newinstructor];
                                }
                                
                                //add to classroom name array
                                if (![ClassroomNameArray containsObject:newclassroom]) {
                                    [ClassroomNameArray addObject:newclassroom];
                                }
                                
                                //add to subject name array
                                if (![SubjectNameArray containsObject:newsubject]) {
                                    [SubjectNameArray addObject:newsubject];
                                }
                                
                            }
                        }
                        
                        newinstructorfullname=[MyClass returnstaffnamewithusername:newinstructor firstorfullname:@"Full"];
                        newsubjectfullname=[subjecttype isEqualToString:@"subject"]?[MyClass returnsubjectnamewithsubject_shortname:newsubject centerkey:globalvariables.centerrecord.centerkey]:[MyClass returnsubjectcategorynamewithscategorykey:newsubject];
                        
                        if ([filtermode isEqualToString:@"On"]&& ![headertype isEqualToString:@"All"]) {
                            if ([headertype isEqualToString:@"Subject"]) {
                                if (![filteredHeaderArray containsObject:newsubject]) {
                                    [filteredHeaderArray addObject:newsubject];
                                }
                            }else if ([headertype isEqualToString:@"Classroom"]){
                                if (![filteredHeaderArray containsObject:newclassroom]) {
                                    [filteredHeaderArray addObject:newclassroom];
                                }
                            }else if ([headertype isEqualToString:@"Instructor"]){
                                if (![filteredHeaderArray containsObject:newinstructor]) {
                                    [filteredHeaderArray addObject:newinstructor];
                                }
                            }
                        }
                        
                        
                        
                        //[df setDateFormat:@"HH:mm"];
                        date=[MyClass convertToNSDateWithDate:newclasstime DateFormat:@"HH:mm"];
                        
                        for (int j=0; j<[newclassduration intValue]/[globalvariables.centerrecord.classtimeinterval intValue]; j++) {
                            [classtimetableobjectArray addObject:[[ClassTimeTableRecord2 alloc]initClassTimeTableRecordWithstartdate:newstartdate classday:newclassday classtime:[MyClass convertToNSStringWithNSDate:[date dateByAddingTimeInterval:[globalvariables.centerrecord.classtimeinterval intValue]*60*j] DateFormat:@"HH:mm"] subject:newsubject instructor:newinstructor classroom:newclassroom studentkey:newstudentkey firstname:newfirstname lastname:newlastname instructorfullname:newinstructorfullname subjectfullname:newsubjectfullname]];
                        }
                    }
            }
        }];
        
        /*
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:[MyClass dcurlstring:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            // handle response
            
            NSDate *date;
            if (!error) {
                result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
        JSONArray = jsonreturned[@"content"];
            
            //Set up our class time table array
            
            NSString *newstartdate;
            NSString *newclassday;
            NSString *newclasstime;
            NSString *newsubject;
            NSString *newinstructor;
            NSString *newclassroom;
            NSString *newclassduration;
            NSString *newstudentkey;
            NSString *newfirstname;
            NSString *newlastname;
            NSString *newinstructorfullname;
            NSString *newsubjectfullname;

            if ([filtermode isEqualToString:@"On"] && JSONArray.count>0) {
                filteredHeaderArray=[[NSMutableArray alloc]init];
            }

            ClassTimeTableRecordArray = [[NSMutableArray alloc]init];
            ClassTimeTableRecordDictionary=[[NSMutableDictionary alloc]init];
            InstructorNameArray=[[NSMutableArray alloc]init];
            ClassroomNameArray=[[NSMutableArray alloc]init];
            SubjectNameArray=[[NSMutableArray alloc]init];
            
            classtimetableobjectArray=[[NSMutableArray alloc]init];
            
            //add other timeslots
            for (int i=0; i<JSONArray.count; i++) {
                newstartdate=[[JSONArray objectAtIndex:i] objectForKey:@"startdate"];
                newclassday=[[JSONArray objectAtIndex:i] objectForKey:@"classday"];
                newclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                newsubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                newinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
                newclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
                newstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                newfirstname=[[JSONArray objectAtIndex:i] objectForKey:@"firstname"];
                newlastname=[[JSONArray objectAtIndex:i] objectForKey:@"lastname"];
                newclassduration=[[JSONArray objectAtIndex:i] objectForKey:@"classduration"];
                if ([newclassroom isEqualToString:@""]) {
                    newclassroom=@"TBD";
                }
                //newcount=[[JSONArray objectAtIndex:i] objectForKey:@"count"];
                
                if (![newstartdate isEqualToString:@"TBD"] && ![newclasstime isEqualToString:@"TBD"]) {
                    if ([globalvariables.centerdayofweekarray containsObject:newclassday]) {
                        
                        //add to instructor name array
                        if (![InstructorNameArray containsObject:newinstructor]) {
                            [InstructorNameArray addObject:newinstructor];
                        }
                        
                        //add to classroom name array
                        if (![ClassroomNameArray containsObject:newclassroom]) {
                            [ClassroomNameArray addObject:newclassroom];
                        }
                        
                        //add to subject name array
                        if (![SubjectNameArray containsObject:newsubject]) {
                            [SubjectNameArray addObject:newsubject];
                        }
                        
                    }
                }
                
                newinstructorfullname=[MyClass returnstaffnamewithusername:newinstructor firstorfullname:@"Full"];
                newsubjectfullname=[MyClass returnsubjectnamewithsubject_shortname:newsubject centerkey:globalvariables.centerrecord.centerkey];
                
                if ([filtermode isEqualToString:@"On"]) {
                    if ([headertype isEqualToString:@"Subject"]) {
                        if (![filteredHeaderArray containsObject:newsubject]) {
                            [filteredHeaderArray addObject:newsubject];
                        }
                    }else if ([headertype isEqualToString:@"Classroom"]){
                        if (![filteredHeaderArray containsObject:newclassroom]) {
                            [filteredHeaderArray addObject:newclassroom];
                        }
                    }else{
                        if (![filteredHeaderArray containsObject:newinstructor]) {
                            [filteredHeaderArray addObject:newinstructor];
                        }
                    }
                }
                
                
                
                //[df setDateFormat:@"HH:mm"];
                date=[MyClass convertToNSDateWithDate:newclasstime DateFormat:@"HH:mm"];
                
                for (int j=0; j<[newclassduration intValue]/[globalvariables.centerrecord.classtimeinterval intValue]; j++) {
                    [classtimetableobjectArray addObject:[[ClassTimeTableRecord2 alloc]initClassTimeTableRecordWithstartdate:newstartdate classday:newclassday classtime:[MyClass convertToNSStringWithNSDate:[date dateByAddingTimeInterval:[globalvariables.centerrecord.classtimeinterval intValue]*60*j] DateFormat:@"HH:mm"] subject:newsubject instructor:newinstructor classroom:newclassroom studentkey:newstudentkey firstname:newfirstname lastname:newlastname instructorfullname:newinstructorfullname subjectfullname:newsubjectfullname]];
                }
            }

        }
            dispatch_semaphore_signal(semaphore);
        }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

        if (!result) {
            [MyClass showconnectionlostdialogbox];
        }*/
    }else{
        filteredHeaderArray=[[NSMutableArray alloc]initWithObjects:@"", nil];
        cellwidth=[self returncellwidth:timetablewidth/classDay.count];
        totalSubjectColumn=filteredHeaderArray.count*classDay.count;
        return YES;
    }
    return YES;
}

-(void) returnclasstimetablerecordposition:(ClassTimeTableRecord3 *)object header:(NSString *)header index:(int)index
{
    int position=0;
    NSMutableArray *lineArray;
    NSMutableArray *timeArray;
    NSMutableArray *timeValueArray=[[NSMutableArray alloc]initWithArray:object.timevaluearray];
//    NSString *timevalue;
    NSString *headervalue;
    if ([header isEqualToString:@"All"]) {
        headervalue=@"";
    }else{
        headervalue=[object valueForKey:[headertype lowercaseString]];
    }
    
    
    NSString *key=[NSString stringWithFormat:@"%@%@",object.classday,headervalue];
    lineArray=[CTR_positiondict objectForKey:key];
    if (lineArray) {
        BOOL recordadded=FALSE;
        for (int i=0; i<lineArray.count; i++) {
            timeArray=[lineArray objectAtIndex:i];
            NSMutableSet *set1 = [NSMutableSet setWithArray: timeValueArray];
            NSSet *set2 = [NSSet setWithArray: timeArray];
            [set1 intersectSet: set2];
            
            if ([set1 allObjects].count==0) {
                recordadded=TRUE;
                [timeArray addObjectsFromArray:timeValueArray];
                position=i;
                break;
            }
        }
        
        if (!recordadded) {
            [lineArray addObject:timeValueArray];
            position=(int)lineArray.count-1;
        }
    }else{
        [CTR_positiondict setValue:[[NSMutableArray alloc]initWithObjects:timeValueArray, nil] forKey:key];
    }
    
    NSMutableArray *columnArrays=[CTR_positiongroupdict objectForKey:key];
    if (columnArrays) {
        if(columnArrays.count<position+1){
            //add new column
            [columnArrays addObject:[[NSMutableArray alloc]initWithObjects:[@(index) stringValue], nil]];
        }else{
            //add to existing column
            NSMutableArray *columnArray=[columnArrays objectAtIndex:position];
            [columnArray addObject:[@(index) stringValue]];
        }
    }else{
        [CTR_positiongroupdict setValue:[[NSMutableArray alloc]initWithObjects:[[NSMutableArray alloc]initWithObjects:[@(index) stringValue], nil], nil] forKey:key];
    }
    
    if ([headertype isEqualToString:@"All"]) {
        if ([[headerWidthArray objectAtIndex:[classDay indexOfObject:object.classday]] intValue]<position+1) {
            [headerWidthArray replaceObjectAtIndex:[classDay indexOfObject:object.classday] withObject:[NSString stringWithFormat:@"%d",position+1]];
        }
    }else{
        if ([[headerWidthArray objectAtIndex:[classDay indexOfObject:object.classday]*[selectedHeaderArray count]+[selectedHeaderArray indexOfObject:headervalue]] intValue]<position+1) {
            [headerWidthArray replaceObjectAtIndex:[classDay indexOfObject:object.classday]*[selectedHeaderArray count]+[selectedHeaderArray indexOfObject:headervalue] withObject:[NSString stringWithFormat:@"%d",position+1]];
        }
    }
    
    object.position= position;
}

-(BOOL) findinstructorcountpersubjectV2WithViewoption:(NSString *)viewoption Classdate:(NSString *)classdate Classtime:(NSString *)classtime Instructor:(NSString *)instructor Classtype:(NSString *)classtype
{
    classDay=[[NSMutableArray alloc]initWithArray:globalvariables.centerdayofweekarray copyItems:YES];
    
//    if (TabArray.count>0 || selectedtabbutton.tag==99) {
        NSString *strURL;
        //[df setDateFormat:@"HH:mm"];
//        NSString *time=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"HH:mm"];
        
    if ([headertype isEqualToString:@"Subject"]) {
        if ([viewoption isEqualToString:@"Consolidated"] || [viewoption isEqualToString:@"PopoverConsolidated"]) {
            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetabledetailview&viewoption=consolidated&classdate=%@&classtype=%@&draftenrollmentkey=%@&subject=%@&classday=%@&classtime=%@&instructor=%@&classroom=%@&headertype=%@&contentmode=%@&groupsubjectcategory=%@&returnoutstanding=%@&timetableoutstandingmode=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclasstimetable"],classdate,classtype,draftenrollmentkey,selectedSubjectArray?[MyClass enurlstring:[selectedSubjectArray componentsJoinedByString:@","]]:@"All",[classDay componentsJoinedByString:@","],[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"HH:mm"],@"All",@"All",headertype,contentmode,groupsubjectcategory?@"Yes":@"No",[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"],[MyClass getlocaldbwithparameter:@"timetableoutstandingmode"]];
        }else if ([viewoption isEqualToString:@"Weekly"] || [viewoption isEqualToString:@"PopoverWeekly"]){
            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetabledetailview&viewoption=weekly&classdate=%@&classtype=%@&draftclasskey=%@&subject=%@&classday=%@&classtime=%@&instructor=%@&classroom=%@&headertype=%@&contentmode=%@&groupsubjectcategory=%@&returnoutstanding=%@&timetableoutstandingmode=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclasstimetable"], classdate,classtype,draftclasskey,selectedSubjectArray?[MyClass enurlstring:[selectedSubjectArray componentsJoinedByString:@","]]:@"All",[classDay componentsJoinedByString:@","],[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"HH:mm"],@"All",@"All",headertype,contentmode,groupsubjectcategory?@"Yes":@"No",[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"],[MyClass getlocaldbwithparameter:@"timetableoutstandingmode"]];
        }
    }else if ([headertype isEqualToString:@"Classroom"]){
        if ([viewoption isEqualToString:@"Consolidated"] || [viewoption isEqualToString:@"PopoverConsolidated"]) {
            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetabledetailview&viewoption=consolidated&classdate=%@&classtype=%@&draftenrollmentkey=%@&subject=%@&classday=%@&classtime=%@&instructor=%@&classroom=%@&headertype=%@&contentmode=%@&groupsubjectcategory=%@&returnoutstanding=%@&timetableoutstandingmode=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclasstimetable"],classdate,classtype,draftenrollmentkey,@"All",[classDay componentsJoinedByString:@","],[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"HH:mm"],@"All",selectedClassroomArray?[MyClass enurlstring:[selectedClassroomArray componentsJoinedByString:@","]]:@"All",headertype,contentmode,groupsubjectcategory?@"Yes":@"No",[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"],[MyClass getlocaldbwithparameter:@"timetableoutstandingmode"]];
        }else if ([viewoption isEqualToString:@"Weekly"] || [viewoption isEqualToString:@"PopoverWeekly"]){
            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetabledetailview&viewoption=weekly&classdate=%@&classtype=%@&draftclasskey=%@&subject=%@&classday=%@&classtime=%@&instructor=%@&classroom=%@&headertype=%@&contentmode=%@&groupsubjectcategory=%@&returnoutstanding=%@&timetableoutstandingmode=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclasstimetable"], classdate,classtype,draftclasskey,@"All",[classDay componentsJoinedByString:@","],[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"HH:mm"],@"All",selectedClassroomArray?[MyClass enurlstring:[selectedClassroomArray componentsJoinedByString:@","]]:@"All",headertype,contentmode,groupsubjectcategory?@"Yes":@"No",[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"],[MyClass getlocaldbwithparameter:@"timetableoutstandingmode"]];
        }
    }else if ([headertype isEqualToString:@"Instructor"]){
        if ([viewoption isEqualToString:@"Consolidated"] || [viewoption isEqualToString:@"PopoverConsolidated"]) {
            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetabledetailview&viewoption=consolidated&classdate=%@&classtype=%@&draftenrollmentkey=%@&subject=%@&classday=%@&classtime=%@&instructor=%@&classroom=%@&headertype=%@&contentmode=%@&groupsubjectcategory=%@&returnoutstanding=%@&timetableoutstandingmode=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclasstimetable"],classdate,classtype,draftenrollmentkey,@"All",[classDay componentsJoinedByString:@","],[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"HH:mm"],selectedInstructorArray?[MyClass enurlstring:[selectedInstructorArray componentsJoinedByString:@","]]:@"All",@"All",headertype,contentmode,groupsubjectcategory?@"Yes":@"No",[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"],[MyClass getlocaldbwithparameter:@"timetableoutstandingmode"]];
        }else if ([viewoption isEqualToString:@"Weekly"] || [viewoption isEqualToString:@"PopoverWeekly"]){
            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetabledetailview&viewoption=weekly&classdate=%@&classtype=%@&draftclasskey=%@&subject=%@&classday=%@&classtime=%@&instructor=%@&classroom=%@&headertype=%@&contentmode=%@&groupsubjectcategory=%@&returnoutstanding=%@&timetableoutstandingmode=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclasstimetable"], classdate,classtype,draftclasskey,@"All",[classDay componentsJoinedByString:@","],[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"HH:mm"],selectedInstructorArray?[MyClass enurlstring:[selectedInstructorArray componentsJoinedByString:@","]]:@"All",@"All",headertype,contentmode,groupsubjectcategory?@"Yes":@"No",[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"],[MyClass getlocaldbwithparameter:@"timetableoutstandingmode"]];
        }
    }else if ([headertype isEqualToString:@"All"]) {
        if ([viewoption isEqualToString:@"Consolidated"] || [viewoption isEqualToString:@"PopoverConsolidated"]) {
            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetabledetailview&viewoption=consolidated&classdate=%@&classtype=%@&draftenrollmentkey=%@&subject=%@&classday=%@&classtime=%@&instructor=%@&classroom=%@&headertype=%@&contentmode=%@&groupsubjectcategory=%@&returnoutstanding=%@&timetableoutstandingmode=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclasstimetable"],classdate,classtype,draftenrollmentkey,[MyClass enurlstring:[selectedHeaderArray componentsJoinedByString:@","]],[classDay componentsJoinedByString:@","],[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"HH:mm"],@"All",@"All",headertype,contentmode,groupsubjectcategory?@"Yes":@"No",[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"],[MyClass getlocaldbwithparameter:@"timetableoutstandingmode"]];
        }else if ([viewoption isEqualToString:@"Weekly"] || [viewoption isEqualToString:@"PopoverWeekly"]){
            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetabledetailview&viewoption=weekly&classdate=%@&classtype=%@&draftclasskey=%@&subject=%@&classday=%@&classtime=%@&instructor=%@&classroom=%@&headertype=%@&contentmode=%@&groupsubjectcategory=%@&returnoutstanding=%@&timetableoutstandingmode=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclasstimetable"], classdate,classtype,draftclasskey,@"All",[classDay componentsJoinedByString:@","],[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"HH:mm"],@"All",@"All",headertype,contentmode,groupsubjectcategory?@"Yes":@"No",[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"],[MyClass getlocaldbwithparameter:@"timetableoutstandingmode"]];
        }
    }

        __block BOOL result=FALSE;
        [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
                    NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                    JSONArray = jsonreturned[@"content"];
                //CTR_positiondict=[[NSMutableDictionary alloc]init];
                
                //Set up our class time table array
                
                NSString *newstartdate;
                NSString *newclassday;
                NSString *newclasstime;
                NSString *newsubject;
                NSString *newinstructor;
                NSString *newsinstructor;
                NSString *newclassroom;
                //NSString *newcount;
                int newclassduration;
                NSMutableArray *newstudentarray;
                NSString *newinstructorfullname;
                NSString *newsubjectfullname;
                NSString *subjecttype;
                NSString *schedulekey;
                NSMutableArray *receivedHeaderArray=[[NSMutableArray alloc]init];
                
                ClassTimeTableRecord3 *classtimetablerecord3;
                
//                if ([filtermode isEqualToString:@"On"] && JSONArray.count>0) {
//                    filteredHeaderArray=[[NSMutableArray alloc]init];
//                }
                
                if ([filtermode isEqualToString:@"On"] && ![headertype isEqualToString:@"All"]) {
                    filteredHeaderArray=[[NSMutableArray alloc]init];
                    if (JSONArray.count==0) {
                        [filteredHeaderArray addObject:@"TBD"];
                    }
                }/*else if([headertype isEqualToString:@"All"]){
                    filteredHeaderArray=[[NSMutableArray alloc]init];
                    [filteredHeaderArray addObject:@"All"];
                }*/
                
                classtimetableobjectArray=[[NSMutableArray alloc]init];
                
                minclassduration=0;
                for (int i=0; i<JSONArray.count; i++) {
                    newstartdate=[[JSONArray objectAtIndex:i] objectForKey:@"startdate"];
                    newclassday=[[JSONArray objectAtIndex:i] objectForKey:@"classday"];
                    newclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                    newsubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                    newinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
                    newsinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"sinstructor"];
                    newclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
                    newstudentarray=[[JSONArray objectAtIndex:i] objectForKey:@"studentlist"];
                    newclassduration=[[[JSONArray objectAtIndex:i] objectForKey:@"classduration"] intValue];
                    subjecttype=[[JSONArray objectAtIndex:i] objectForKey:@"subjecttype"];
                    schedulekey=[[JSONArray objectAtIndex:i] objectForKey:@"schedulekey"];
                    if ([newclassroom isEqualToString:@""]) {
                        newclassroom=@"TBD";
                    }
                    
                    newinstructorfullname=[MyClass returnstaffnamewithusername:newinstructor firstorfullname:@"Full"];
                    newsubjectfullname=[subjecttype isEqualToString:@"subject"]?[MyClass returnsubjectnamewithsubject_shortname:newsubject centerkey:globalvariables.centerrecord.centerkey]:[MyClass returnsubjectcategorynamewithscategorykey:newsubject];
                    
                    
                    if ([filtermode isEqualToString:@"On"]) {
                        if ([headertype isEqualToString:@"Subject"]) {
                            if (![filteredHeaderArray containsObject:newsubject]) {
                                [filteredHeaderArray addObject:newsubject];
                            }
                        }else if ([headertype isEqualToString:@"Classroom"]){
                            if (![filteredHeaderArray containsObject:newclassroom]) {
                                [filteredHeaderArray addObject:newclassroom];
                            }
                        }else if ([headertype isEqualToString:@"Instructor"]){
                            if (![filteredHeaderArray containsObject:newinstructor]) {
                                [filteredHeaderArray addObject:newinstructor];
                            }
                        }
                    }
                    
                    if ([headertype isEqualToString:@"Instructor"]) {
                        if (![receivedHeaderArray containsObject:newinstructor]) {
                            [receivedHeaderArray addObject:newinstructor];
                        }
                    }
                    
                    NSMutableArray *tmpstudentarray=[[NSMutableArray alloc]init];
                    for (int p=0; p<newstudentarray.count; p++) {
                        NSString *classtype=[[newstudentarray objectAtIndex:p] objectForKey:@"classtype"];
                        NSString *type=[[newstudentarray objectAtIndex:p] objectForKey:@"type"];
                        NSString *typekey=[[newstudentarray objectAtIndex:p] objectForKey:@"typekey"];
                        NSString *attendance=[[newstudentarray objectAtIndex:p] objectForKey:@"attendance"];
                        NSString *levelmain=[[newstudentarray objectAtIndex:p] objectForKey:@"levelmain"];
                        NSString *classkey=[[newstudentarray objectAtIndex:p] objectForKey:@"classkey"];
                        NSString *subject=[[newstudentarray objectAtIndex:p] objectForKey:@"subject"];
                        NSString *displayname;
                        if ([type isEqualToString:@"student"]) {
                            displayname=[MyClass returnStudentnameWithStudentkey:typekey option:@"full"];
                        }else if ([type isEqualToString:@"lead"]){
                            displayname=[MyClass returnLeadnameWithLeadkey:typekey option:@"full"];
                        }
                        NSString *outstanding=[[newstudentarray objectAtIndex:p] objectForKey:@"outstanding"];
                        NSString *lesson=[[newstudentarray objectAtIndex:p] objectForKey:@"lesson"];
                        
                        [tmpstudentarray addObject:[[ClassTimeTableSubRecord alloc]initClassTimeTableSubRecordWithclasstype:classtype type:type typekey:typekey attendance:attendance levelmain:levelmain displayname:displayname classkey:classkey subject:subject outstanding:outstanding lesson:lesson]];
                    }
                    
                    tmpstudentarray=[self sorttmpstudentarraywithstudentarray:tmpstudentarray];
                    NSMutableArray *timevaluearray=[[NSMutableArray alloc]init];
                    NSString *timevalue;
                    for (int j=0; j<newclassduration/5; j++) {
                        timevalue=[MyClass convertToNSStringWithNSDate:[[MyClass convertToNSDateWithDate:newclasstime DateFormat:@"HH:mm"] dateByAddingTimeInterval:5*60*j] DateFormat:@"HH:mm"];
                        [timevaluearray addObject:timevalue];
                    }
                    classtimetablerecord3=[[ClassTimeTableRecord3 alloc]initClassTimeTableRecord3Withclassday:newclassday classtime:newclasstime subject:newsubject instructor:newinstructor classroom:newclassroom classduration:newclassduration studentarray:tmpstudentarray position:0 instructorfullname:newinstructorfullname subjectfullname:newsubjectfullname timevaluearray:timevaluearray subjecttype:subjecttype sinstructor:newsinstructor schedulekey:schedulekey];
                    [classtimetableobjectArray addObject:classtimetablerecord3];
                    
                    
                    if (minclassduration==0) {
                        minclassduration=newclassduration;
                    }else{
                        if (minclassduration>newclassduration) {
                            minclassduration=newclassduration;
                        }
                    }
                }
                
                //new insert
                AvailableInstructorNameArray=[MyClass retrieveInstructorListwithvalid:@"Yes" addTBD:YES flushcachedata:NO];
                if ([headertype isEqualToString:@"Instructor"]) {
                    for (int i=0; i<receivedHeaderArray.count; i++) {
                        BOOL found=false;
                        NSString *instructor=[receivedHeaderArray objectAtIndex:i];
                        
                        for (int j=0; j<AvailableInstructorNameArray.count; j++) {
                            Instructor *object=[AvailableInstructorNameArray objectAtIndex:j];
                            if ([instructor isEqualToString:object.username]) {
                                found=true;
                                break;;
                            }
                        }
                        if(!found){
                            [AvailableInstructorNameArray addObject:(Instructor *)[MyClass returnstaffrecordwithusername:instructor]];
                        }
                    }
                }
                selectedHeaderArray=[self returnSelectedHeaderArray];
//                [self retrievetabviewpreferencewithselecteddatereset:YES];
                if (!selectedHeaderArray) {
                    selectedHeaderArray=[[NSMutableArray alloc]initWithObjects:@"", nil];
                }
                
                if (selectedHeaderArray.count==0) {
                    cellwidth=[self returncellwidth:timetablewidth/classDay.count];
                    totalSubjectColumn=classDay.count;
                }else{
                    cellwidth=[self returncellwidth:timetablewidth/classDay.count/selectedHeaderArray.count];
                    totalSubjectColumn=selectedHeaderArray.count*classDay.count;
                }
                //new insert end
                
            }
        }];
        
        return result;
//    }else{
//        filteredHeaderArray=[[NSMutableArray alloc]initWithObjects:@"", nil];
//        cellwidth=[self returncellwidth:timetablewidth/classDay.count];
//        totalSubjectColumn=filteredHeaderArray.count*classDay.count;
//        return YES;
//    }
}

-(void) constructStandardViewTimetable:(NSString *)viewoption
{
    ClassTimeTableRecordDictionary=[[NSMutableDictionary alloc]init];
    if ([filtermode isEqualToString:@"On"] && JSONArray.count>0) {
        
        if ([headertype isEqualToString:@"Instructor"]) {
            filteredHeaderArray=[MyClass returnsortedstaffusernamewithstaffusernamearray:filteredHeaderArray];
        }else{
            NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES selector:@selector(localizedStandardCompare:)];
            filteredHeaderArray=[NSMutableArray arrayWithArray:[filteredHeaderArray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
        }
    }else{
        filteredHeaderArray=[[NSMutableArray alloc]initWithArray:selectedHeaderArray copyItems:YES];
    }
    
    totalSubjectColumn=filteredHeaderArray.count*classDay.count;
    
    [self returnfilterclasstimetableobjectArray];
    [self groupclasstimetablerecordwithheadertype:headertype contentmode:contentmode];
    

    
    cellwidth=[self returncellwidth:timetablewidth/classDay.count/filteredHeaderArray.count];

    //sort instructor name array
    InstructorNameArray=[MyClass returnsortedstaffusernamewithstaffusernamearray:InstructorNameArray];
    
    //sort classroom name array
    NSMutableArray *tmpClassroomNameArray=[[NSMutableArray alloc]init];
    
    BOOL addTBD=FALSE;
    for (int i=0; i<ClassroomNameArray.count; i++) {
        if ([[ClassroomNameArray objectAtIndex:i] isEqualToString:@"TBD"]) {
            addTBD=TRUE;
        }else{
            [tmpClassroomNameArray addObject:[ClassroomNameArray objectAtIndex:i]];
        }
    }
    
    tmpClassroomNameArray=[[NSMutableArray alloc]initWithArray:[tmpClassroomNameArray sortedArrayUsingSelector:@selector(localizedStandardCompare:)]];
    
    //put TBD to the last
    if (addTBD) {
        [tmpClassroomNameArray addObject:@"TBD"];
    }
    
    ClassroomNameArray=[[NSMutableArray alloc]initWithArray:tmpClassroomNameArray];
    
    
    //sort subject name array
    SubjectNameArray=[[NSMutableArray alloc]initWithArray:[SubjectNameArray sortedArrayUsingSelector:@selector(localizedStandardCompare:)]];
}

-(void) constructDetailViewTimetable:(NSString *)viewoption
{
    CTR_positiondict=[[NSMutableDictionary alloc]init];
    NSString *newclassday;
    NSString *newclasstime;
    NSString *newsubject;
    NSString *newinstructor;
    NSString *newclassroom;
    
    NSString *lastclassday=@"";
    NSString *lastclasstime=@"";
    NSString *lastsubject=@"";
    NSString *lastclassroom=@"";
    NSString *lastinstructor=@"";
    
    ClassTimeTableRecordDictionary=[[NSMutableDictionary alloc]init];
    ClassTimeTableRecordArray = [[NSMutableArray alloc]init];
    ClassTimeTableRecord3 *classtimetableobject=[[ClassTimeTableRecord3 alloc]init];
    InstructorNameArray=[[NSMutableArray alloc]init];
    ClassroomNameArray=[[NSMutableArray alloc]init];
    SubjectNameArray=[[NSMutableArray alloc]init];
    
    [self initializeheaderwidtharray];
    [self returnfilterclasstimetableobjectArray];
    CTR_positiongroupdict=[[NSMutableDictionary alloc]init];
    NSMutableDictionary *subjectdict;

    
    for (int i=0; i<filteredclasstimetableobjectArray.count; i++) {
        ClassTimeTableRecord3 *obj=[filteredclasstimetableobjectArray objectAtIndex:i];
        [self returnclasstimetablerecordposition:obj header:headertype index:i];
    //}
    

        
    //if (filteredclasstimetableobjectArray.count>0) {
        //loop through our jsonArray
        //for (int i=0; i<=filteredclasstimetableobjectArray.count; i++) {
            
            if (i<filteredclasstimetableobjectArray.count) {
                classtimetableobject=[filteredclasstimetableobjectArray objectAtIndex:i];
                
                //newstartdate=classtimetableobject.startdate;
                newclassday=classtimetableobject.classday;
                newclasstime=classtimetableobject.classtime;
                newsubject=classtimetableobject.subject;
                newinstructor=classtimetableobject.instructor;
                newclassroom=classtimetableobject.classroom;
                //newcount=classtimetableobject.count;
                
                //add to instructor name array
                if (![newclasstime isEqualToString:@"TBD"]) {
                    if ([globalvariables.centerdayofweekarray containsObject:newclassday]) {
                        if (![InstructorNameArray containsObject:classtimetableobject.instructor]) {
                            [InstructorNameArray addObject:newinstructor];
                        }
                        
                        //add to classroom name array
                        if (![ClassroomNameArray containsObject:classtimetableobject.classroom]) {
                            [ClassroomNameArray addObject:newclassroom];
                        }
                        
                        //add to subject name array
                        subjectdict=[[NSMutableDictionary alloc]init];
                        [subjectdict setValue:classtimetableobject.subjecttype forKey:@"subjecttype"];
                        [subjectdict setValue:classtimetableobject.subject forKey:@"subject"];
                        
                        if (![self containsSubjectDictwithSubjectNameArray:SubjectNameArray subjectDict:subjectdict]) {
                            [SubjectNameArray addObject:subjectdict];
                        }
                        
//                        if (![SubjectNameArray containsObject:classtimetableobject.subject]) {
//                            [SubjectNameArray addObject:newsubject];
//                        }
                    }
                }
                
                
            }else if(i==filteredclasstimetableobjectArray.count){
                newsubject=@"";
                newclassday=@"";
                newinstructor=@"";
                newclassroom=@"";
            }
            
            //headertype=@"All";
            if (![newclassday isEqualToString:lastclassday] ||![newclasstime isEqualToString:lastclasstime] || ([headertype isEqualToString:@"Subject"] && ![newsubject isEqualToString:lastsubject]) || ([headertype isEqualToString:@"Classroom"] && ![newclassroom isEqualToString:lastclassroom]) || ([headertype isEqualToString:@"Instructor"] && ![newinstructor isEqualToString:lastinstructor])) {
                if (ClassTimeTableRecordArray.count>0) {
                    
                    [ClassTimeTableRecordDictionary setValue:ClassTimeTableRecordArray forKey:[self returnclasstimetableallarraypositionwithclassday:lastclassday classtime:lastclasstime subject:lastsubject classroom:lastclassroom instructor:lastinstructor]];
                    
                    //initialize new array
                    ClassTimeTableRecordArray=[[NSMutableArray alloc] init];
                }
            }
            [ClassTimeTableRecordArray addObject:classtimetableobject];
            
            lastclassday=newclassday;
            lastclasstime=newclasstime;
            lastsubject=newsubject;
            lastclassroom=newclassroom;
            lastinstructor=newinstructor;
        //}
    }
    
    [self initializeheaderpositionarray];
    
    //update min cell height for detail view
//    float sum = [[headerPositionArray lastObject] floatValue]+[[headerWidthArray lastObject] floatValue];
//    if (sum*mincellwidthfordetailview<timetablewidth) {
//        cellwidthfordetailview=timetablewidth/sum;
//    }else{
//        cellwidthfordetailview=mincellwidthfordetailview;
//    }
        
        
    if ([filtermode isEqualToString:@"On"] && ![headertype isEqualToString:@"All"]) {
        
        if ([headertype isEqualToString:@"Instructor"]) {
            filteredHeaderArray=[MyClass returnsortedstaffusernamewithstaffusernamearray:filteredHeaderArray];
        }else{
            filteredHeaderArray = [[NSMutableArray alloc]initWithArray:[filteredHeaderArray sortedArrayUsingSelector:@selector(localizedStandardCompare:)]];
        }
        
        
    }else{
        filteredHeaderArray=[self returnSelectedHeaderArray];
    }
    
//    if(groupsubjectcategory && [headertype isEqualToString:@"Subject"]){
//        filteredHeaderArray=[self returnCategoryHeaderArray:filteredHeaderArray];
//    }
    
    cellwidth=[self returncellwidth:timetablewidth/classDay.count/filteredHeaderArray.count];
    totalSubjectColumn=filteredHeaderArray.count*classDay.count;
    
    //sort instructor name array
    InstructorNameArray=[MyClass returnsortedstaffusernamewithstaffusernamearray:InstructorNameArray];
    
    
    //sort classroom name array
    NSMutableArray *tmpClassroomNameArray=[[NSMutableArray alloc]init];
    
    BOOL addTBD=FALSE;
    for (int i=0; i<ClassroomNameArray.count; i++) {
        if ([[ClassroomNameArray objectAtIndex:i] isEqualToString:@"TBD"]) {
            addTBD=TRUE;
        }else{
            [tmpClassroomNameArray addObject:[ClassroomNameArray objectAtIndex:i]];
        }
    }
    
    tmpClassroomNameArray=[[NSMutableArray alloc]initWithArray:[tmpClassroomNameArray sortedArrayUsingSelector:@selector(localizedStandardCompare:)]];
    
    //put TBD to the last
    if (addTBD) {
        [tmpClassroomNameArray addObject:@"TBD"];
    }
    
    ClassroomNameArray=[[NSMutableArray alloc]initWithArray:tmpClassroomNameArray];
    
    //sort subject name array
    SubjectNameArray=[MyClass returnsortedsubjectorcategorylistwithsubjectorcategoryarray:SubjectNameArray];
        
    

}

-(NSMutableArray *) returnSelectedHeaderArray
{
    NSMutableArray *result=[[NSMutableArray alloc]init];
    if([headertype isEqualToString:@"Subject"]){
        if(selectedSubjectArray){
            result=[[NSMutableArray alloc]initWithArray:selectedSubjectArray];
        }else{
            for (int i=0; i<AvailableSubjectNameArray.count; i++) {
                SubjectRecord *obj=[AvailableSubjectNameArray objectAtIndex:i];
                [result addObject:obj.subject_shortname];
            }
        }
        
        if(groupsubjectcategory){
            result=[self returnCategoryHeaderArray:result];
        }else{
            result=[MyClass returnsortedsubjectlistwithsubjectcodearray:result];
        }

        
        
    }else if ([headertype isEqualToString:@"Instructor"]){
        if(selectedInstructorArray){
            result=[[NSMutableArray alloc]initWithArray:selectedInstructorArray];
        }else{
            for (int i=0; i<AvailableInstructorNameArray.count; i++) {
                Instructor *obj=[AvailableInstructorNameArray objectAtIndex:i];
                [result addObject:obj.username];
            }
        }
        result=[MyClass returnsortedstaffusernamewithstaffusernamearray:result];
    }else if ([headertype isEqualToString:@"Classroom"]){
        if(selectedClassroomArray){
            result=[[NSMutableArray alloc]initWithArray:selectedClassroomArray];
        }else{
            for (int i=0; i<AvailableClassroomArray.count; i++) {
                ClassroomRecord *obj=[AvailableClassroomArray objectAtIndex:i];
                [result addObject:obj.classroom];
            }
        }
    }else{
        [result addObject:@"All"];
    }
    
    return result.count==0?[[NSMutableArray alloc]initWithObjects:@"", nil]:result;
}

-(NSMutableArray *) returnCategoryHeaderArray:(NSMutableArray *)headerarray
{
    if(headerarray.count==1 && [headerarray[0] isEqualToString:@"All"]){
        return headerarray;
    }
    
    NSMutableArray *resultarray=[[NSMutableArray alloc]init];
    for (int i=0; i<headerarray.count; i++) {
        NSString *subjectcode=[headerarray objectAtIndex:i];
        NSString *subjectcategory=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:subjectcode centerkey:globalvariables.centerrecord.centerkey]).subject_category;
        if([subjectcategory isEqualToString:@""]){
            subjectcategory=subjectcode;
        }
        if(![resultarray containsObject:subjectcategory]){
            [resultarray addObject:subjectcategory];
        }
    }
//    if (groupsubjectcategory) {
        resultarray=[MyClass returnsortedsubjectorcategorylistwithsubjectorcategorycodearray:resultarray];
//    }else{
//        resultarray=[MyClass returnsortedsubjectlistwithsubjectcodearray:resultarray];
//    }
    return resultarray;
}


-(BOOL) containsSubjectDictwithSubjectNameArray:(NSMutableArray *)subjectarray subjectDict:(NSMutableDictionary *)subjectdict
{
    NSMutableDictionary *tmpdict;
    for (int i=0; i<subjectarray.count; i++) {
        tmpdict=[subjectarray objectAtIndex:i];
        if ([[tmpdict valueForKey:@"subjecttype"] isEqualToString:[subjectdict valueForKey:@"subjecttype"]] && [[tmpdict valueForKey:@"subject"] isEqualToString:[subjectdict valueForKey:@"subject"]]) {
            return TRUE;
        }
    }
    return FALSE;
}

-(NSMutableArray *) sorttmpstudentarraywithstudentarray:(NSMutableArray *)studentarray;
{
    NSSortDescriptor *sortbydisplayname = [NSSortDescriptor sortDescriptorWithKey:@"displayname" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[sortbydisplayname];
    return [NSMutableArray arrayWithArray:[studentarray sortedArrayUsingDescriptors:sortDescriptors]];
}


-(void) initializeheaderwidtharray
{
    headerWidthArray =[[NSMutableArray alloc]init];
    for (int i=0; i<allClassDay.count; i++) {
        if ([globalvariables.centerdayofweekarray containsObject:[allClassDay objectAtIndex:i]]) {
            for (int j=0; j<selectedHeaderArray.count; j++) {
                [headerWidthArray addObject:@"1"];
            }
        }
    }
}

-(void) initializeheaderpositionarray
{
    int position=0;
    headerPositionArray=[[NSMutableArray alloc]init];
    if ([filtermode isEqualToString:@"On"]&& ![headertype isEqualToString:@"All"]) {
        //filter headerWidthArray
        int origindex=0;
        for (int i=0; i<headerWidthArray.count; i++,origindex++) {
            if ([filteredHeaderArray containsObject:[selectedHeaderArray objectAtIndex:origindex%selectedHeaderArray.count]]) {
                [headerPositionArray addObject:[NSString stringWithFormat:@"%d",position]];
                position+=[[headerWidthArray objectAtIndex:i] intValue];
            }else{
                [headerWidthArray removeObjectAtIndex:i];
                i--;
            }
        }
    }else{
        for (int i=0; i<headerWidthArray.count; i++) {
            [headerPositionArray addObject:[NSString stringWithFormat:@"%d",position]];
            position+=[[headerWidthArray objectAtIndex:i] intValue];
        }
    }
}


-(NSString *) returnclasstimetableallarraypositionwithclassday:(NSString *)classday classtime:(NSString *)classtime subject:(NSString *)subject classroom:(NSString *)classroom instructor:(NSString *)instructor
{
    if ([headertype isEqualToString:@"Subject"]) {
        if (![classDay containsObject:classday] || ![classTime containsObject:classtime] || ![filteredHeaderArray containsObject:subject]) {
            return @"NA";
        }else{
            return [NSString stringWithFormat:@"%lu",(int)[classTime indexOfObject:classtime]*totalSubjectColumn + (int)[classDay indexOfObject:classday]*filteredHeaderArray.count + (int)[filteredHeaderArray indexOfObject:subject]];
        }
    }else if ([headertype isEqualToString:@"Classroom"]){
        if (![classDay containsObject:classday] || ![classTime containsObject:classtime] || ![filteredHeaderArray containsObject:classroom]) {
            return @"NA";
        }else{
            return [NSString stringWithFormat:@"%lu",(int)[classTime indexOfObject:classtime]*totalSubjectColumn + (int)[classDay indexOfObject:classday]*filteredHeaderArray.count + (int)[filteredHeaderArray indexOfObject:classroom]];
        }
    }else if ([headertype isEqualToString:@"Instructor"]){
        if (![classDay containsObject:classday] || ![classTime containsObject:classtime] || ![filteredHeaderArray containsObject:instructor]) {
            return @"NA";
        }else{
            return [NSString stringWithFormat:@"%lu",(int)[classTime indexOfObject:classtime]*totalSubjectColumn + (int)[classDay indexOfObject:classday]*filteredHeaderArray.count + (int)[filteredHeaderArray indexOfObject:instructor]];
        }
    }else{
        if (![classDay containsObject:classday] || ![classTime containsObject:classtime]) {
            return @"NA";
        }else{
            return [NSString stringWithFormat:@"%lu",(int)[classTime indexOfObject:classtime]*totalSubjectColumn + (int)[classDay indexOfObject:classday]];
        }
    }

}


-(void) groupclasstimetablerecordwithheadertype:(NSString *)type contentmode:(NSString *)content
{
    NSMutableArray *tmpclasstimetableobjectarray=[[NSMutableArray alloc]initWithArray:filteredclasstimetableobjectArray];
    //classtimetableobjectArray=[[NSMutableArray alloc]init];
    ClassTimeTableRecordArray=[[NSMutableArray alloc] init];
    maxNoOfItemInACell=0;
    
    //sort array
    NSSortDescriptor *sortByClassDay = [NSSortDescriptor sortDescriptorWithKey:@"classday" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortByClassTime = [NSSortDescriptor sortDescriptorWithKey:@"classtime" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortBySubject = [NSSortDescriptor sortDescriptorWithKey:@"subject" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortByInstructor = [NSSortDescriptor sortDescriptorWithKey:@"instructor" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortByClassroom = [NSSortDescriptor sortDescriptorWithKey:@"classroom" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors;
    if ([type isEqualToString:@"Subject"]) {
        if ([content isEqualToString:@"Instructor"]) {
            sortDescriptors = @[sortByClassDay, sortByClassTime,sortBySubject,sortByInstructor,sortByClassroom];
        }else{
            sortDescriptors = @[sortByClassDay, sortByClassTime,sortBySubject,sortByClassroom,sortByInstructor];
        }
    }else if ([type isEqualToString:@"Classroom"]){
        if ([content isEqualToString:@"Instructor"]) {
            sortDescriptors = @[sortByClassDay, sortByClassTime,sortByClassroom,sortByInstructor,sortBySubject];
        }else{
            sortDescriptors = @[sortByClassDay, sortByClassTime,sortByClassroom,sortBySubject,sortByInstructor];
        }
    }else if ([type isEqualToString:@"Instructor"]){
        if ([content isEqualToString:@"Subject"]) {
            sortDescriptors = @[sortByClassDay, sortByClassTime,sortByInstructor,sortBySubject,sortByClassroom];
        }else{
            sortDescriptors = @[sortByClassDay, sortByClassTime,sortByInstructor,sortByClassroom,sortBySubject];
        }
    }else{
        sortDescriptors = @[sortByClassDay, sortByClassTime,sortByClassroom,sortBySubject,sortByInstructor];
    }

    tmpclasstimetableobjectarray = [NSMutableArray arrayWithArray:[tmpclasstimetableobjectarray sortedArrayUsingDescriptors:sortDescriptors]];
    
    
    NSString *newclassday;
    NSString *newclasstime;
    NSString *newsubject;
    NSString *newinstructor;
    NSString *newclassroom;
    NSString *newstudentkey;

    NSString *oldclassday;
    NSString *oldclasstime;
    NSString *oldsubject;
    NSString *oldinstructor;
    NSString *oldstartdate;
    NSString *oldclassroom;

    
    NSString *newstring;
    NSString *oldstring;
    
    NSMutableArray *tmpstudentarray=[[NSMutableArray alloc]init];
    
    ClassTimeTableRecord2 *ClassTimeTableObject2=[[ClassTimeTableRecord2 alloc]init];
    
    for (int i=0; i<tmpclasstimetableobjectarray.count; i++) {
        ClassTimeTableObject2=[tmpclasstimetableobjectarray objectAtIndex:i];
        newclassday=ClassTimeTableObject2.classday;
        newclasstime=ClassTimeTableObject2.classtime;
        newsubject=ClassTimeTableObject2.subject;
        newinstructor=ClassTimeTableObject2.instructor;
        newclassroom=ClassTimeTableObject2.classroom;
        newstudentkey=ClassTimeTableObject2.studentkey;

        if ([type isEqualToString:@"Subject"]) {
            if ([contentmode isEqualToString:@"Instructor"]) {
                newstring=[NSString stringWithFormat:@"%@%@%@%@%@",newclassday,newclasstime,newsubject,newinstructor,combine3rddimension?@"":newclassroom];
                oldstring=[NSString stringWithFormat:@"%@%@%@%@%@",oldclassday,oldclasstime,oldsubject,oldinstructor,combine3rddimension?@"":oldclassroom];
            }else{
                newstring=[NSString stringWithFormat:@"%@%@%@%@%@",newclassday,newclasstime,newsubject,newclassroom,combine3rddimension?@"":newinstructor];
                oldstring=[NSString stringWithFormat:@"%@%@%@%@%@",oldclassday,oldclasstime,oldsubject,oldclassroom,combine3rddimension?@"":oldinstructor];
            }
        }else if ([type isEqualToString:@"Classroom"]){
            if ([contentmode isEqualToString:@"Instructor"]) {
                newstring=[NSString stringWithFormat:@"%@%@%@%@%@",newclassday,newclasstime,newclassroom,newinstructor,combine3rddimension?@"":newsubject];
                oldstring=[NSString stringWithFormat:@"%@%@%@%@%@",oldclassday,oldclasstime,oldclassroom,oldinstructor,combine3rddimension?@"":oldsubject];
            }else{
                newstring=[NSString stringWithFormat:@"%@%@%@%@%@",newclassday,newclasstime,newclassroom,newsubject,combine3rddimension?@"":newinstructor];
                oldstring=[NSString stringWithFormat:@"%@%@%@%@%@",oldclassday,oldclasstime,oldclassroom,oldsubject,combine3rddimension?@"":oldinstructor];
            }
        }else if ([type isEqualToString:@"Instructor"]){
            if ([contentmode isEqualToString:@"Classroom"]) {
                newstring=[NSString stringWithFormat:@"%@%@%@%@%@",newclassday,newclasstime,newinstructor,newclassroom,combine3rddimension?@"":newsubject];
                oldstring=[NSString stringWithFormat:@"%@%@%@%@%@",oldclassday,oldclasstime,oldinstructor,oldclassroom,combine3rddimension?@"":oldsubject];
            }else{
                newstring=[NSString stringWithFormat:@"%@%@%@%@%@",newclassday,newclasstime,newinstructor,newsubject,combine3rddimension?@"":newclassroom];
                oldstring=[NSString stringWithFormat:@"%@%@%@%@%@",oldclassday,oldclasstime,oldinstructor,oldsubject,combine3rddimension?@"":oldclassroom];
            }
        }else if ([type isEqualToString:@"All"]){
                newstring=[NSString stringWithFormat:@"%@%@",newclassday,newclasstime];
                oldstring=[NSString stringWithFormat:@"%@%@",oldclassday,oldclasstime];
        }
            
        if ([newstring isEqualToString:oldstring] || tmpstudentarray.count==0) {
            [tmpstudentarray addObject:newstudentkey];
        }else{
            //add to dict
            [self addLessontoDictwithclasstimetableobject:[[ClassTimeTableRecord alloc]initClassTimeTableRecordWithstartdate:oldstartdate classday:oldclassday classtime:oldclasstime subject:oldsubject instructor:oldinstructor classroom:oldclassroom studentarray:tmpstudentarray] lastrecord:NO];
            //[classtimetableobjectArray addObject:[[ClassTimeTableRecord alloc]initClassTimeTableRecordWithstartdate:oldstartdate classday:oldclassday classtime:oldclasstime subject:oldsubject instructor:oldinstructor classroom:oldclassroom studentarray:tmpstudentarray]];
            tmpstudentarray=[[NSMutableArray alloc]initWithObjects:newstudentkey, nil];
        }
        
        oldclassday=newclassday;
        oldclasstime=newclasstime;
        oldsubject=newsubject;
        oldinstructor=newinstructor;
        oldclassroom=newclassroom;
        
        //add last to dict
        if (i==tmpclasstimetableobjectarray.count-1) {
            //[classtimetableobjectArray addObject:[[ClassTimeTableRecord alloc]initClassTimeTableRecordWithstartdate:oldstartdate classday:oldclassday classtime:oldclasstime subject:oldsubject instructor:oldinstructor classroom:oldclassroom studentarray:tmpstudentarray]];
            [self addLessontoDictwithclasstimetableobject:[[ClassTimeTableRecord alloc]initClassTimeTableRecordWithstartdate:oldstartdate classday:oldclassday classtime:oldclasstime subject:oldsubject instructor:oldinstructor classroom:oldclassroom studentarray:tmpstudentarray] lastrecord:YES];
            
        }
    }
    
}

-(void) addLessontoDictwithclasstimetableobject:(ClassTimeTableRecord *)classobject lastrecord:(BOOL)lastrecord
{
    ClassTimeTableRecord *classtimetableobject;
    if (ClassTimeTableRecordArray.count==0) {
        [ClassTimeTableRecordArray addObject:classobject];
    }else{
        classtimetableobject=[ClassTimeTableRecordArray lastObject];
        
        NSString * lastclassday=classtimetableobject.classday;
        NSString * lastclasstime=classtimetableobject.classtime;
        NSString * lastsubject=classtimetableobject.subject;
        NSString * lastinstructor=classtimetableobject.instructor;
        NSString * lastclassroom=classtimetableobject.classroom;
        
        NSString * newclassday=classobject.classday;
        NSString * newclasstime=classobject.classtime;
        NSString * newsubject=classobject.subject;
        NSString * newinstructor=classobject.instructor;
        NSString * newclassroom=classobject.classroom;
        
        if (![newclassday isEqualToString:lastclassday] ||![newclasstime isEqualToString:lastclasstime] || ([headertype isEqualToString:@"Subject"] && ![newsubject isEqualToString:lastsubject]) || ([headertype isEqualToString:@"Classroom"] && ![newclassroom isEqualToString:lastclassroom]) || ([headertype isEqualToString:@"Instructor"] && ![newinstructor isEqualToString:lastinstructor]) ) {

                //add last record array to the all array
                
                [ClassTimeTableRecordDictionary setValue:ClassTimeTableRecordArray forKey:[self returnclasstimetableallarraypositionwithclassday:lastclassday classtime:lastclasstime subject:lastsubject classroom:lastclassroom instructor:lastinstructor]];
                
                //store max item number
                if (ClassTimeTableRecordArray.count>maxNoOfItemInACell) {
                    maxNoOfItemInACell=ClassTimeTableRecordArray.count;
                }
                
                //initialize new array
                ClassTimeTableRecordArray=[[NSMutableArray alloc] init];
            
        }
        [ClassTimeTableRecordArray addObject:classobject];
    }
    
    if (lastrecord) {
        [ClassTimeTableRecordDictionary setValue:ClassTimeTableRecordArray forKey:[self returnclasstimetableallarraypositionwithclassday:classobject.classday classtime:classobject.classtime subject:classobject.subject classroom:classobject.classroom instructor:classobject.instructor]];
        
        //store max item number
        if (ClassTimeTableRecordArray.count>maxNoOfItemInACell) {
            maxNoOfItemInACell=ClassTimeTableRecordArray.count;
        }
    }
}

-(BOOL) generateTimeTablewithViewOption:(NSString *)viewoption pastMonday:(NSString *)pastMonday classtype:(NSString *)classtype redrawscoller:(BOOL)redrawscroller
{
    NSString *classdate;
    NSString *classtime;
    //NSDate *date;
    NSDate *pastMon;

    if ([viewoption isEqualToString:@"Weekly"] || [viewoption isEqualToString:@"PopoverConsolidated"]|| [viewoption isEqualToString:@"PopoverWeekly"]) {

        if (!pastMonday || [pastMonday isEqualToString:@""]) {
            //if ([dailyweeklyviewselected isEqualToString:@"Weekly"]) {
                //find first date
                NSDate *now = [NSDate date];
                NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:now];
                
                NSUInteger weekdayToday = [components weekday];
                NSInteger daysToMonday=weekdayToday-[MyClass returndayofweeknumber:[globalvariables.centerdayofweekarray objectAtIndex:0]];
                pastMon = [now dateByAddingTimeInterval:60*60*24*(-daysToMonday)];
            classdate=[MyClass convertToNSStringWithNSDate:pastMon DateFormat:@"yyyy-MM-dd"];
                classtime=@"00:00";
        }else{
            classdate=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:pastMonday];
            classtime=@"00:00";
        }
        globalselecteddate=[MyClass convertDateFormatWithDate:classdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy"];
        
    }else if ([viewoption isEqualToString:@"Consolidated"]){
        classdate=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
        classtime=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"HH:mm"];
        
    }
    
    //find instructor count records
    if (detailViewMode) {
        if (![self findinstructorcountpersubjectV2WithViewoption:viewoption Classdate:classdate Classtime:classtime Instructor:instructorselected Classtype:classtype]) {
            return NO;
        }
    }else{
        if (![self findinstructorcountpersubjectWithViewoption:viewoption Classdate:classdate Classtime:classtime Classtype:classtype]) {
            return NO;
        }
    }
    
//    cellheight=[self returncellheight];

    TimeLabel.frame=CGRectMake(tablex, superviewclearence, [self returnclasstimewidth], 66);
    timetableselectedclassdate=[MyClass convertDateFormatWithDate:classdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy"];
    [self loadTimeTablewithviewoption:viewoption];
            
    
//    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    return YES;

}

-(void) loadTimeTablewithviewoption:(NSString *)viewoption
{

    
//    if (TabArray.count>0 || selectedtabbutton.tag==99) {
        //timetableselectedclassdate=[MyClass convertDateFormatWithDate:classdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy"];
        if ([viewoption isEqualToString:@"Weekly"] || [viewoption isEqualToString:@"PopoverWeekly"]) {
            [self retrieveTimeTableDetailsWithOption:@"Weekly" type:@"Weekly" classdate:timetableselectedclassdate classday:@"All" classtime:@"All" subtypevalue:@"All"];
        }else{
            [self retrieveTimeTableDetailsWithOption:@"Weekly" type:@"Consolidated" classdate:timetableselectedclassdate classday:@"All" classtime:@"All" subtypevalue:@"All"];
        }

        masterScrollView.hidden=!detailViewMode;
        timetablecollectionview.hidden=detailViewMode;
//    if(classTimeView.hidden){
//        TimeLabel.hidden=NO;
//    }
    
//    classTimeView.hidden=NO;
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (detailViewMode) {
                [self constructDetailViewTimetable:viewoption];
                [self drawTimeTableWithTimeTableMode:viewoption SelectedLesson:nil];
            }else{
                [self constructStandardViewTimetable:viewoption];
                [self drawTimeCellWithViewOption:viewoption updatecellposition:@"All" expandcellposition:@"" classschedulerecordarray:nil];
            }
            [self generatedatescrollerwithpastmonday:globalselecteddate redraw:YES];
            
            if ([contentmode isEqualToString:@"Instructor"]) {
                [self drawInstructorLegend];
            }else if ([contentmode isEqualToString:@"Classroom"]){
                [self drawClassroomLegend];
            }else{
                [self drawSubjectLegend];
            }
            
            [self removeEmptyMessageLabel];
            
            TimeLabel.hidden=NO;
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
//    }else{
//    }
    
    systemmessagelabel.hidden=YES;
    datebartable.hidden=NO;
}

-(void) drawDetailClassMasterViewWithVerticalPosition:(CGFloat)verticalposition
{
    int masterViewHeight=60+(int)ClassScheduleRecordArray.count*25+41;
    masterView.frame=CGRectMake(detailViewMode?0:-[self returnclasstimewidth], verticalposition, self.view.bounds.size.width, masterViewHeight+1);
    ClassDetailTable.frame=CGRectMake(0, 60, self.view.bounds.size.width, ClassScheduleRecordArray.count*25+41);
    [ClassDetailTable reloadData];
    
    [classtablebutton removeFromSuperview];
    
    if ([TimeTableMode isEqualToString:@"PopoverWeekly"] || [TimeTableMode isEqualToString:@"PopoverConsolidated"]) {
        classtablebutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-190, 10, 150, 30)];
        [classtablebutton setTitle:[MyClass returntitlewithtitle:@"Select date"] forState:UIControlStateNormal];
        [classtablebutton addTarget:self action:@selector(selectdatebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        [classtablebutton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [classtablebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [masterView addSubview:classtablebutton];
        classtablebutton.tag=selectedbutton.tag;
        
    }else if ([TimeTableMode isEqualToString:@"Weekly" ]){
        classtablebutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-170, 10, 150, 30)];
        [classtablebutton setTitle:[MyClass returntitlewithtitle:@"To Class Schedule"] forState:UIControlStateNormal];
        [classtablebutton addTarget:self action:@selector(gotoclassschedule:) forControlEvents:UIControlEventTouchUpInside];
        classtablebutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [classtablebutton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [classtablebutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [masterView addSubview:classtablebutton];
        
    }
    
    
}

-(void) initializeDetailClassMasterView
{
    
    
    
    [masterView removeFromSuperview];
    
    masterView=[[UIView alloc]init];
    masterView.backgroundColor=tablecolor;
    
    UIView *decorbar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 3)];
    decorbar.backgroundColor=[UIColor colorWithRed:65/255.0 green:65/255.0 blue:65/255.0 alpha:1.0];
    [masterView addSubview:decorbar];
    
    
    //add header
    headerview=[[UIView alloc]initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 20)];
    headerview.backgroundColor=tablecolor;
    
    
    NSArray *separatorweight_class=[[NSArray alloc]initWithObjects:@"4",@"4",@"8",@"4",@"8",@"2",@"5",@"6",@"6",@"6",@"6",nil];
    float fieldseparator=(headerview.frame.size.width-30-20)/[[separatorweight_class valueForKeyPath:@"@sum.self"] floatValue];
    
    
    
    title_masterview_start=[[UILabel alloc]initWithFrame:CGRectMake(30, 0,[[separatorweight_class objectAtIndex:0] intValue]*fieldseparator, 20)];
    title_masterview_start.textColor=[UIColor blackColor];
    title_masterview_start.font=[UIFont boldSystemFontOfSize:12];
    title_masterview_start.text=[MyClass returntitlewithtitle:@"Start"];
    [headerview addSubview:title_masterview_start];
    
    title_masterview_duration=[[UILabel alloc]initWithFrame:CGRectMake(title_masterview_start.frame.origin.x+title_masterview_start.frame.size.width, 0, [[separatorweight_class objectAtIndex:1] intValue]*fieldseparator, 20)];
    title_masterview_duration.textColor=[UIColor blackColor];
    title_masterview_duration.font=[UIFont boldSystemFontOfSize:12];
    title_masterview_duration.text=[MyClass returntitlewithtitle:@"Duration"];
    //headerlabel.textAlignment=NSTextAlignmentCenter;
    [headerview addSubview:title_masterview_duration];
    
    
    title_masterview_subject=[[UILabel alloc]initWithFrame:CGRectMake(title_masterview_duration.frame.origin.x+title_masterview_duration.frame.size.width, 0, [[separatorweight_class objectAtIndex:2] intValue]*fieldseparator, 20)];
    title_masterview_subject.textColor=[UIColor blackColor];
    title_masterview_subject.font=[UIFont boldSystemFontOfSize:12];
    title_masterview_subject.text=[MyClass returntitlewithtitle:@"Subject"];
    [headerview addSubview:title_masterview_subject];
    
    
    title_masterview_type=[[UILabel alloc]initWithFrame:CGRectMake(title_masterview_subject.frame.origin.x+title_masterview_subject.frame.size.width, 0, [[separatorweight_class objectAtIndex:3] intValue]*fieldseparator, 20)];
    title_masterview_type.textColor=[UIColor blackColor];
    title_masterview_type.font=[UIFont boldSystemFontOfSize:12];
    title_masterview_type.text=[MyClass returntitlewithtitle:@"Type"];
    [headerview addSubview:title_masterview_type];
    
    title_masterview_student=[[UILabel alloc]initWithFrame:CGRectMake(title_masterview_type.frame.origin.x+title_masterview_type.frame.size.width, 0, [[separatorweight_class objectAtIndex:4] intValue]*fieldseparator, 20)];
    title_masterview_student.textColor=[UIColor blackColor];
    title_masterview_student.font=[UIFont boldSystemFontOfSize:12];
    title_masterview_student.text=[MyClass returntitlewithtitle:@"Student Name"];
    [headerview addSubview:title_masterview_student];
    
    title_masterview_age=[[UILabel alloc]initWithFrame:CGRectMake(title_masterview_student.frame.origin.x+title_masterview_student.frame.size.width, 0, [[separatorweight_class objectAtIndex:5] intValue]*fieldseparator, 20)];
    title_masterview_age.textColor=[UIColor blackColor];
    title_masterview_age.font=[UIFont boldSystemFontOfSize:12];
    title_masterview_age.text=[MyClass returntitlewithtitle:@"Age"];
    //headerlabel.textAlignment=NSTextAlignmentCenter;
    [headerview addSubview:title_masterview_age];
    
    
    title_masterview_level=[[UILabel alloc]initWithFrame:CGRectMake(title_masterview_age.frame.origin.x+title_masterview_age.frame.size.width, 0, [[separatorweight_class objectAtIndex:6] intValue]*fieldseparator, 20)];
    title_masterview_level.textColor=[UIColor blackColor];
    title_masterview_level.font=[UIFont boldSystemFontOfSize:12];
    title_masterview_level.text=[MyClass returntitlewithtitle:@"Level"];
    //headerlabel.textAlignment=NSTextAlignmentCenter;
    [headerview addSubview:title_masterview_level];
    
    
    title_masterview_instructor=[[UILabel alloc]initWithFrame:CGRectMake(title_masterview_level.frame.origin.x+title_masterview_level.frame.size.width, 0, [[separatorweight_class objectAtIndex:7] intValue]*fieldseparator, 20)];
    title_masterview_instructor.textColor=[UIColor blackColor];
    title_masterview_instructor.font=[UIFont boldSystemFontOfSize:12];
    title_masterview_instructor.text=[MyClass returntitlewithtitle:@"Instructor"];
    //headerlabel.textAlignment=NSTextAlignmentCenter;
    [headerview addSubview:title_masterview_instructor];

    
    
    title_masterview_classroom=[[UILabel alloc]initWithFrame:CGRectMake(title_masterview_instructor.frame.origin.x+title_masterview_instructor.frame.size.width, 0, [[separatorweight_class objectAtIndex:8] intValue]*fieldseparator, 20)];
    title_masterview_classroom.textColor=[UIColor blackColor];
    title_masterview_classroom.font=[UIFont boldSystemFontOfSize:12];
    title_masterview_classroom.text=[MyClass returntitlewithtitle:@"Room"];
    [headerview addSubview:title_masterview_classroom];
    

    
    title_masterview_outstandingclass=[[UILabel alloc]initWithFrame:CGRectMake(title_masterview_classroom.frame.origin.x+title_masterview_classroom.frame.size.width, 0, [[separatorweight_class objectAtIndex:9] intValue]*fieldseparator, 20)];
    title_masterview_outstandingclass.textColor=[UIColor blackColor];
    title_masterview_outstandingclass.font=[UIFont boldSystemFontOfSize:12];
    title_masterview_outstandingclass.text=[MyClass returntitlewithtitle:@"Class Left"];
    [headerview addSubview:title_masterview_outstandingclass];
    
    title_masterview_outstandingamount=[[UILabel alloc]initWithFrame:CGRectMake(title_masterview_outstandingclass.frame.origin.x+title_masterview_outstandingclass.frame.size.width, 0, [[separatorweight_class objectAtIndex:10] intValue]*fieldseparator, 20)];
    title_masterview_outstandingamount.textColor=[UIColor blackColor];
    title_masterview_outstandingamount.font=[UIFont boldSystemFontOfSize:12];
    title_masterview_outstandingamount.text=[MyClass returntitlewithtitle:@"Outstanding"];
    title_masterview_outstandingamount.textAlignment=NSTextAlignmentRight;
    [headerview addSubview:title_masterview_outstandingamount];
    
    [masterView addSubview:headerview];
    
    //add table
    ClassDetailTable=[[UITableView alloc]init];
    ClassDetailTable.dataSource=self;
    ClassDetailTable.delegate=self;
    [ClassDetailTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    EmptySlotPopupTable=[[UITableView alloc]init];
    EmptySlotPopupTable.dataSource=self;
    EmptySlotPopupTable.delegate=self;
    [EmptySlotPopupTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    EmptySlotPopupTable.backgroundColor=tablecolor;
    
    //[ClassDetailTable reloadData];
    
    ClassDetailTable.backgroundColor=tablecolor;
    [masterView addSubview:ClassDetailTable];
}

-(void) drawTimeTableWithTimeTableMode:(NSString *)mode SelectedLesson:(ClassTimeTableRecord3 *)lessonobject
{
    [self returncellheight];
//    ClassTimeTableSubRecord *subrecord;
//    UILabel *label;
//    UIImageView *imageview;
//    UIScrollView *lessonscrollview;
    cellwidthfordetailview=mincellwidthfordetailview;
    float pageheight=NoOfTimeSlot*cellheight;
    float pagewidth=([[headerWidthArray lastObject] floatValue]+[[headerPositionArray lastObject] floatValue])*cellwidthfordetailview;
    

    NSInteger classtimestart;
    NSInteger classtimeend;
    NSInteger classdaystart;
    NSInteger classdayend;
    int expandcelloffset;
    
    classtimestart=0;
    classtimeend=classTime.count;
    classdaystart=0;
    classdayend=classDay.count;
    
    //clear items
    [[TimeTableView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [[classTimeView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [masterView removeFromSuperview];
    [shapeLayer removeFromSuperlayer];
    [visibleItems removeAllObjects];
    [reusableItems removeAllObjects];
    
    //add close view button
    UIButton *closeview=[[UIButton alloc]init];
    [closeview addTarget:self action:@selector(tapTimeTableDetected) forControlEvents:UIControlEventTouchUpInside];
    [TimeTableView addSubview:closeview];
    
    //add master view table
    int masterViewHeight=0;
    if (ClassScheduleTableShown) {
        masterViewHeight=60+(int)ClassScheduleRecordArray.count*25+41;
        [self drawDetailClassMasterViewWithVerticalPosition:([classTime indexOfObject:lessonobject.classtime]+lessonobject.classduration/[globalvariables.centerrecord.classtimeinterval intValue])*cellheight];
        [TimeTableView addSubview:masterView];
        [masterScrollView setContentSize:CGSizeMake(pagewidth+[self returnclasstimewidth], pageheight+masterViewHeight)];
        
        
        //offset screen
        if (lastexpandcelltableheight==0 || masterView.frame.origin.y<=[lastexpandcellposition intValue]) {
            //masterview not previously shown or new selected cell is before previously selected cell or on same row
            if (masterView.frame.origin.y+masterViewHeight-masterScrollView.contentOffset.y>masterScrollView.frame.size.height) {
                //masterview is chopped
                if (masterViewHeight+cellheight>masterScrollView.frame.size.height) {
                    //masterview height + one cellheight >time table screen height
                    //scroll to selected row
                    [masterScrollView setContentOffset:CGPointMake(masterScrollView.contentOffset.x,masterView.frame.origin.y-cellheight)];
                }else{
                    //scroll to see all masterview
                    [masterScrollView setContentOffset:CGPointMake(masterScrollView.contentOffset.x,masterView.frame.origin.y+masterViewHeight-masterScrollView.frame.size.height)];
                }
            }
        }else{
            //masterview previously shown and new selected cell is after previously selected cell
            if (masterView.frame.origin.y<([classTime indexOfObject:lessonobject.classtime]+1)*cellheight+lastexpandcelltableheight-masterScrollView.contentOffset.y) {
                //new selected cell position cannot stay if the previous masterview is closed
                //scroll to top
                [masterScrollView setContentOffset:CGPointMake(masterScrollView.contentOffset.x,0)];
                
                if (masterView.frame.origin.y+masterViewHeight-masterScrollView.contentOffset.y>masterScrollView.frame.size.height) {
                    //masterview is chopped
                    if (masterViewHeight+cellheight>masterScrollView.frame.size.height) {
                        //masterview height + one cellheight >time table screen height
                        //scroll to selected row
                        [masterScrollView setContentOffset:CGPointMake(masterScrollView.contentOffset.x,masterView.frame.origin.y-cellheight)];
                    }else{
                        //scroll to see all masterview
                        [masterScrollView setContentOffset:CGPointMake(masterScrollView.contentOffset.x,masterView.frame.origin.y+masterViewHeight-masterScrollView.frame.size.height)];
                    }
                }
            }else{
                //scroll to new position
                [masterScrollView setContentOffset:CGPointMake(masterScrollView.contentOffset.x,masterScrollView.contentOffset.y-lastexpandcelltableheight)];
                
                if (masterView.frame.origin.y+masterViewHeight-masterScrollView.contentOffset.y>masterScrollView.frame.size.height) {
                    //masterview is chopped
                    if (masterViewHeight+cellheight>masterScrollView.frame.size.height) {
                        //masterview height + one cellheight >time table screen height
                        //scroll to selected row
                        [masterScrollView setContentOffset:CGPointMake(masterScrollView.contentOffset.x,masterView.frame.origin.y-cellheight)];
                    }else{
                        //scroll to see all masterview
                        [masterScrollView setContentOffset:CGPointMake(masterScrollView.contentOffset.x,masterView.frame.origin.y+masterViewHeight-masterScrollView.frame.size.height)];
                    }
                }
            }
        }
        
        lastexpandcelltableheight=masterViewHeight;
        lastexpandcellposition=[NSString stringWithFormat:@"%f",masterView.frame.origin.y];
        
        
        
    }else{
        lastexpandcelltableheight=0;
        lastexpandcellposition=@"";
//        NSLog(@"timewidth-%f",[self returnclasstimewidth]);
        [masterScrollView setContentSize:CGSizeMake(pagewidth+[self returnclasstimewidth], pageheight)];
    }
    
    masterView.frame=CGRectMake(masterScrollView.contentOffset.x-(detailViewMode?[self returnclasstimewidth]:0), masterView.frame.origin.y, masterView.frame.size.width, masterView.frame.size.height);
    
    TimeTableView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    TimeTableView.frame=CGRectMake([self returnclasstimewidth], 0, masterScrollView.contentSize.width-[self returnclasstimewidth], masterScrollView.contentSize.height);
    closeview.frame=TimeTableView.frame;
    //timetablecollectionview.frame=TimeTableView.bounds;
    expandcelloffset=0;
    
    contentViewBackgroundButton.frame = TimeTableView.bounds;
    [TimeTableView addSubview:contentViewBackgroundButton];
    
    for (NSInteger i=classtimestart; i<classtimeend; i++) {

        if (lessonobject) {
            if (i>=[classTime indexOfObject:lessonobject.classtime]+(lessonobject.classduration/[globalvariables.centerrecord.classtimeinterval intValue])) {
                expandcelloffset=masterViewHeight;
            }
        }else{
            expandcelloffset=0;
        }
        
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*cellheight+expandcelloffset, classtimewidth, cellheight)];
        timeLabel.textAlignment=NSTextAlignmentCenter;
        [timeLabel setFont:[UIFont systemFontOfSize:12]];
        timeLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
        timeLabel.layer.borderWidth=0.3;
        timeLabel.text=[classTime objectAtIndex:i];
        timeLabel.backgroundColor=(i/(60/(NSInteger)cellduration) %2)==0?[UIColor whiteColor]:[UIColor systemGroupedBackgroundColor];
        [classTimeView addSubview:timeLabel];
        
        UILabel *horizontalgridline=[[UILabel alloc]initWithFrame:CGRectMake(0, i*cellheight+expandcelloffset, TimeTableView.frame.size.width, 0.5)];
        horizontalgridline.backgroundColor=[UIColor lightGrayColor];
        horizontalgridline.alpha=0.3;
        
        //add alternate color
        UIView *alternateview=[[UIView alloc]initWithFrame:CGRectMake(0, i*cellheight+expandcelloffset, pagewidth, cellheight)];
        alternateview.backgroundColor=[UIColor whiteColor];
        alternateview.userInteractionEnabled=NO;
        
//        if ([globalvariables.centerrecord.classtimeinterval intValue]<=60) {
            if ((i/(60/(NSInteger)cellduration)) %2==0) {
                [TimeTableView addSubview:alternateview];
            }
//        }
        [TimeTableView addSubview:horizontalgridline];
    }
    
    float height=0;
    UILabel *verticalgridline;
    UILabel *holidaylabel;
    float previousheight=0;
    for (long j=classdaystart; j<classdayend; j++) {
        for (int i=0; i<filteredHeaderArray.count; i++) {
            height=[[headerWidthArray objectAtIndex:j*filteredHeaderArray.count+i] floatValue]+[[headerPositionArray objectAtIndex:j*filteredHeaderArray.count+i] floatValue];
            if (i==filteredHeaderArray.count-1) {
                verticalgridline=[[UILabel alloc]initWithFrame:CGRectMake(height*cellwidthfordetailview, 0, 1, TimeTableView.frame.size.height)];
                verticalgridline.backgroundColor=[UIColor blackColor];
            }else{
                verticalgridline=[[UILabel alloc]initWithFrame:CGRectMake(height*cellwidthfordetailview, 0, 0.3, TimeTableView.frame.size.height)];
                verticalgridline.backgroundColor=[UIColor lightGrayColor];
                verticalgridline.layer.opacity=0.6;
            }
            [TimeTableView addSubview:verticalgridline];
        }
        
        //highlight holiday
        NSDate *calendardate=[[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyy"] dateByAddingTimeInterval:60*60*24*([allClassDay indexOfObject:[classDay objectAtIndex:j]]/*-[allClassDay indexOfObject:[classDay objectAtIndex:0]]*/)];
        
        if (![MyClass isWorkingDate:calendardate includereserveddate:YES] && ![mode isEqualToString:@"Consolidated"]) {
            holidaylabel=[[UILabel alloc]initWithFrame:CGRectMake(previousheight*cellwidthfordetailview, 0, (height-previousheight)*cellwidthfordetailview, NoOfTimeSlot*cellheight+masterViewHeight)];
            holidaylabel.backgroundColor=[UIColor colorWithRed:176.0/255.0 green:36.0/255.0 blue:34.0/255.0 alpha:1.0];
            holidaylabel.text=[MyClass returntitlewithtitle:@"Center Holiday"];
            holidaylabel.textColor=[UIColor whiteColor];
            holidaylabel.font=[UIFont systemFontOfSize:13];
            holidaylabel.layer.borderWidth=0.3;
            holidaylabel.layer.borderColor=[UIColor darkGrayColor].CGColor;
            holidaylabel.textAlignment=NSTextAlignmentCenter;
            [TimeTableView addSubview:holidaylabel];

        }
        previousheight=height;
    }
    
    timetablestudentdict=[[NSMutableDictionary alloc]init];
    totalattendedcount=0;
    //totalstudentcount=0;
    
    [self layoutContentItems];
    
//    for (int i=0; i<filteredclasstimetableobjectArray.count; i++) {
//        //duplicate lesson records for splitted lesson
//        ClassTimeTableRecord3 *object=[filteredclasstimetableobjectArray objectAtIndex:i];
//        //totalstudentcount+=object.studentarray.count;
//        int duplicatecount=1;
////        if (ClassScheduleTableShown) {
////            long selectedend=[classTime indexOfObject:lessonobject.classtime]+lessonobject.classduration/[globalvariables.centerrecord.classtimeinterval intValue];
////            long objectstart=[classTime indexOfObject:object.classtime];
////            long objectend=objectstart+object.classduration/[globalvariables.centerrecord.classtimeinterval intValue];
////            
////            if (objectstart<selectedend && objectend>selectedend) {
////                duplicatecount=2;
////            }
////        }
//
//        //duplicatecount=2;
//        
//        
//        for (int j=1; j<duplicatecount+1; j++) {
//            CGRect rect=[self returnlessoncoordinatewithclasstimetableobject:object lessonselected:lessonobject part:duplicatecount==1?0:j];
//            
//            if(!CGRectEqualToRect(rect, CGRectZero)){
//                
//                detailsLessonItem *lessonItem=[[detailsLessonItem alloc]initWithFrame:rect LessonObject:object ContentMode:contentmode ZoomMode:zoommode Index:j CellWidth:mincellwidthfordetailview TimeTableMode:TimeTableMode];
//                lessonItem.delegate=self;
//                lessonItem.tag=i;
//                UITapGestureRecognizer *detailLessonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetailLessonDetected:)];
//                detailLessonTap.numberOfTapsRequired = 1;
//                [lessonItem addGestureRecognizer:detailLessonTap];
//                [TimeTableView addSubview:lessonItem];
//                for (int k=0; k<object.studentarray.count; k++) {
//                    subrecord=[object.studentarray objectAtIndex:k];
//                    [self addtimetablestudentdictwithclasstimetablesubrecord:subrecord];
//                }
//            }
//        }
//    }

    
//    if (ClassScheduleTableShown) {
//        [TimeTableView bringSubviewToFront:masterView];
//        CGRect rect = [self returnlessoncoordinatewithclasstimetableobject:selecteddetaillesson lessonselected:nil part:0];
//        [self drawtrianglepointerwithexpandcellposition:CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, 10)];
//    }
    
    [self updateHeaderLessonStudentCount];
}


-(NSString *) returnLessonKeyWithLessonObject:(ClassTimeTableRecord3 *)object
{
//    return [NSString stringWithFormat:@"%@%@%@%@%@%@%d",object.classday,object.classtime,object.subject,object.instructor,object.sinstructor,object.classroom,object.classduration];
//    if ([object.subject isEqualToString:@"IS306"]) {
    if ([object.subject hasPrefix:@"IS3"] && object.subject.length == 5 && [globalvariables.centerrecord.fcgroup isEqualToString:@"popularlearning"]) {
        if (object.studentarray.count>0) {
            timetablesubrecord=[object.studentarray firstObject];
            
            return [NSString stringWithFormat:@"%@%@%@%@%@%@%d%@",object.classday,object.classtime,object.subject,object.instructor,object.sinstructor,object.classroom,object.classduration,timetablesubrecord.levelmain];
        }else{
            return [NSString stringWithFormat:@"%@%@%@%@%@%@%d%@",object.classday,object.classtime,object.subject,object.instructor,object.sinstructor,object.classroom,object.classduration,object.schedulekey];
        }
    }else{
        return [NSString stringWithFormat:@"%@%@%@%@%@%@%d",object.classday,object.classtime,object.subject,object.instructor,object.sinstructor,object.classroom,object.classduration];
    }
}

-(BOOL) itemExistsWithLessonObject:(ClassTimeTableRecord3 *)object
{
    NSString *key=[self returnLessonKeyWithLessonObject:object];
    detailsLessonItem *item=[visibleItems objectForKey:key];
    if (item) {
        return TRUE;
    }else{
        return FALSE;
    }
}

-(void) layoutContentItems
{
    ClassTimeTableSubRecord *subrecord;
    for (int i=0; i<filteredclasstimetableobjectArray.count; i++) {
        //duplicate lesson records for splitted lesson
        ClassTimeTableRecord3 *object=[filteredclasstimetableobjectArray objectAtIndex:i];
        int duplicatecount=1;

        for (int j=1; j<duplicatecount+1; j++) {
            CGRect rect=[self returnlessoncoordinatewithclasstimetableobject:object lessonselected:nil part:duplicatecount==1?0:j];
            NSString *lessonkey=[self returnLessonKeyWithLessonObject:object];
            //check if within visible area
            if(rect.origin.x+rect.size.width>=visibleRect.origin.x && rect.origin.x<=visibleRect.origin.x+visibleRect.size.width && rect.origin.y+rect.size.height>=visibleRect.origin.y && rect.origin.y<=visibleRect.origin.y+visibleRect.size.height){
                if(![self itemExistsWithLessonObject:object]){
                    if(!CGRectEqualToRect(rect, CGRectZero)){
                        detailsLessonItem *lessonItem=[self dequeueReusableItemWithFrame:rect LessonObject:object ContentMode:contentmode ZoomMode:zoommode Index:i CellWidth:mincellwidthfordetailview TimeTableMode:TimeTableMode];
                        
                        
                        lessonItem.delegate=self;
                        lessonItem.tag=i;
                        UITapGestureRecognizer *detailLessonTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetailLessonDetected:)];
                        detailLessonTap.numberOfTapsRequired = 1;
                        [lessonItem addGestureRecognizer:detailLessonTap];
                        [TimeTableView addSubview:lessonItem];
                        [visibleItems setValue:lessonItem forKey:lessonkey];
                        
                        for (int k=0; k<object.studentarray.count; k++) {
                            subrecord=[object.studentarray objectAtIndex:k];
                            [self addtimetablestudentdictwithclasstimetablesubrecord:subrecord];
                        }
                    }
                }
            }else{
                //remove items that are no longer visible and add to reuseableItems
                detailsLessonItem *itemToBeRemoved=[visibleItems valueForKey:lessonkey];
                if(itemToBeRemoved){
                    [visibleItems removeObjectForKey:lessonkey];
                    [reusableItems addObject:itemToBeRemoved];
                    [itemToBeRemoved removeFromSuperview];
                }
            }
        }
    }
}

- (detailsLessonItem *)dequeueReusableItemWithFrame:(CGRect)frame LessonObject:(ClassTimeTableRecord3 *)object ContentMode:(NSString *)contentmode ZoomMode:(NSInteger)zoommode Index:(NSInteger)index CellWidth:(float)cellwidth TimeTableMode:(NSString *)timetablemode {
    detailsLessonItem *item = [reusableItems lastObject];
    if (item) {
        [reusableItems removeLastObject];
        [item configureDetailsLessonItemWithFrame:frame LessonObject:object ContentMode:contentmode ZoomMode:zoommode Index:index CellWidth:cellwidth TimeTableMode:timetablemode];
    } else {
        item = [[detailsLessonItem alloc]initWithFrame:frame LessonObject:object ContentMode:contentmode ZoomMode:zoommode Index:index CellWidth:cellwidth TimeTableMode:timetablemode];
    }
    return item;
}

-(UIView *) returnDetailsPrintView
{
//    ClassTimeTableSubRecord *subrecord;
    UILabel *label;
//    UIImageView *imageview;
//    UIScrollView *lessonscrollview;
    UIView *date_View;
    UIView *time_View;
    UIView *content_View;
    float pageheight=NoOfTimeSlot*cellheight;
    float pagewidth=([[headerWidthArray lastObject] floatValue]+[[headerPositionArray lastObject] floatValue])*cellwidthfordetailview;

    NSInteger classtimestart;
    NSInteger classtimeend;
    NSInteger classdaystart;
    NSInteger classdayend;
    //int expandcelloffset;
    
    classtimestart=0;
    classtimeend=classTime.count;
    classdaystart=0;
    classdayend=classDay.count;
    
    content_View=[[UIView alloc]initWithFrame:CGRectMake(0, 0,  pagewidth, pageheight)];
    date_View=[[UIView alloc]initWithFrame:CGRectMake(0, 0, pagewidth, 66)];
    time_View=[[UIView alloc]initWithFrame:CGRectMake(0, 0, classtimewidth, pageheight+66)];

    content_View.backgroundColor=[UIColor systemGroupedBackgroundColor];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, classtimewidth, 66)];
    label.textAlignment=NSTextAlignmentCenter;
    [label setFont:[UIFont boldSystemFontOfSize:14]];
    label.layer.borderColor=[UIColor darkGrayColor].CGColor;
    label.layer.borderWidth=0.5;
    label.text=[MyClass returntitlewithtitle:@"Time"];
    label.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [time_View addSubview:label];

    for (NSInteger i=classtimestart; i<classtimeend; i++) {

        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*cellheight+66, classtimewidth, cellheight)];
        timeLabel.textAlignment=NSTextAlignmentCenter;
        [timeLabel setFont:[UIFont systemFontOfSize:12]];
        timeLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
        timeLabel.layer.borderWidth=0.3;
        timeLabel.text=[classTime objectAtIndex:i];
        timeLabel.backgroundColor=(i/(60/(NSInteger)cellduration) %2)==0?[UIColor whiteColor]:[UIColor systemGroupedBackgroundColor];
        [time_View addSubview:timeLabel];
        
        UILabel *horizontalgridline=[[UILabel alloc]initWithFrame:CGRectMake(0, i*cellheight, TimeTableView.frame.size.width, 0.5)];
        horizontalgridline.backgroundColor=[UIColor darkGrayColor];
        horizontalgridline.alpha=0.3;
        
        //add alternate color
        UIView *alternateview=[[UIView alloc]initWithFrame:CGRectMake(0, i*cellheight, pagewidth, cellheight)];
        alternateview.backgroundColor=[UIColor whiteColor];
        alternateview.userInteractionEnabled=NO;
        
//        if ([globalvariables.centerrecord.classtimeinterval intValue]<=60) {
            if ((i/(60/(NSInteger)cellduration)) %2==0) {
                [content_View addSubview:alternateview];
            }
//        }
        [content_View addSubview:horizontalgridline];
    }
    
    float height=0;
    UILabel *verticalgridline;
    UILabel *holidaylabel;
    float previousheight=0;
    UILabel *dateLabel;
    UILabel *dayLabel;
    

    for (long j=classdaystart; j<classdayend; j++) {
        CGFloat datecellwidth;
        if (detailViewMode && headerWidthArray.count>0) {
            datecellwidth= ([[headerPositionArray objectAtIndex:((j+1)*filteredHeaderArray.count-1)] floatValue]+[[headerWidthArray objectAtIndex:((j+1)*filteredHeaderArray.count-1)] floatValue]-[[headerPositionArray objectAtIndex:j*filteredHeaderArray.count] floatValue])*cellwidthfordetailview;
        }else{
            datecellwidth= cellwidth*filteredHeaderArray.count;
        }
        
        dateLabel=[[UILabel alloc]initWithFrame:CGRectMake(dateLabel.frame.size.width+dateLabel.frame.origin.x, 20, datecellwidth, 20)];
        dateLabel.textAlignment=NSTextAlignmentCenter;
        [dateLabel setFont:[UIFont systemFontOfSize:12]];
        dateLabel.layer.borderColor=[UIColor darkGrayColor].CGColor;
        dateLabel.layer.borderWidth=0.5;
        NSString *datevalue=[MyClass returnDateFromBaseDateWithOffset:([allClassDay indexOfObject:[classDay objectAtIndex:j]]/*-[allClassDay indexOfObject:[classDay objectAtIndex:0]]*/+[MyClass returnDateOffsetWithDate:[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyy"]])];
        dateLabel.text=[MyClass returndateformatwithdate:datevalue dateformat:@"dd-MMM-yyyy"];
        if(datecellwidth<100){
            dateLabel.text=[MyClass convertDateFormatWithDate:datevalue FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"dd" Translate:YES];
        }
        dateLabel.backgroundColor=[UIColor lightGrayColor];
        [date_View addSubview:dateLabel];
        
        dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(dateLabel.frame.origin.x, 0, datecellwidth, 20)];
        dayLabel.textAlignment=NSTextAlignmentCenter;
        [dayLabel setFont:[UIFont systemFontOfSize:12]];
        dayLabel.layer.borderColor=[UIColor darkGrayColor].CGColor;
        dayLabel.layer.borderWidth=0.5;
        dayLabel.text=[MyClass convertDateFormatWithDate:datevalue FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE" Translate:YES];
        dayLabel.backgroundColor=[UIColor lightGrayColor];
        [date_View addSubview:dayLabel];
        
        float xpos=dateLabel.frame.origin.x;
        float width=0;
        UILabel *headerlabel;
        
        for (int i=0; i<filteredHeaderArray.count; i++) {
            height=[[headerWidthArray objectAtIndex:j*filteredHeaderArray.count+i] floatValue]+[[headerPositionArray objectAtIndex:j*filteredHeaderArray.count+i] floatValue];
            if (i==filteredHeaderArray.count-1) {
                verticalgridline=[[UILabel alloc]initWithFrame:CGRectMake(height*cellwidthfordetailview, 0, 1, TimeTableView.frame.size.height)];
                verticalgridline.backgroundColor=[UIColor blackColor];
            }else{
                verticalgridline=[[UILabel alloc]initWithFrame:CGRectMake(height*cellwidthfordetailview, 0, 0.3, TimeTableView.frame.size.height)];
                verticalgridline.backgroundColor=[UIColor lightGrayColor];
                verticalgridline.layer.opacity=0.6;
            }
            [content_View addSubview:verticalgridline];
            
            if (detailViewMode) {
                width=[[headerWidthArray objectAtIndex:(j*filteredHeaderArray.count+i)] floatValue]*cellwidthfordetailview;
                headerlabel=[[UILabel alloc]initWithFrame:CGRectMake(xpos, 40, width, 26)];
                xpos+=width;
            }else{
                headerlabel=[[UILabel alloc]initWithFrame:CGRectMake(cellwidth*i, 40, cellwidth, 26)];
            }
            
            headerlabel.textAlignment=NSTextAlignmentCenter;
            headerlabel.backgroundColor=[UIColor lightGrayColor];
            if ([headertype isEqualToString:@"Instructor"]) {
                headerlabel.text=[MyClass returnstaffnamewithusername:[filteredHeaderArray objectAtIndex:i] firstorfullname:@"first"];
            }else{
                headerlabel.text=[filteredHeaderArray objectAtIndex:i];
            }

            [headerlabel setFont:[UIFont systemFontOfSize:10]];
            headerlabel.layer.borderColor=[UIColor grayColor].CGColor;
            headerlabel.layer.borderWidth=0.5;
            [date_View addSubview:headerlabel];

        }
        
        
        

        
        
        //highlight holiday
        NSDate *calendardate=[[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyy"] dateByAddingTimeInterval:60*60*24*([allClassDay indexOfObject:[classDay objectAtIndex:j]]/*-[allClassDay indexOfObject:[classDay objectAtIndex:0]]*/)];
        
        if (![MyClass isWorkingDate:calendardate includereserveddate:YES] && ![TimeTableMode isEqualToString:@"Consolidated"]) {
            holidaylabel=[[UILabel alloc]initWithFrame:CGRectMake(previousheight*cellwidthfordetailview, 0, (height-previousheight)*cellwidthfordetailview, NoOfTimeSlot*cellheight)];
            holidaylabel.backgroundColor=[UIColor colorWithRed:176.0/255.0 green:36.0/255.0 blue:34.0/255.0 alpha:1.0];
            holidaylabel.text=[MyClass returntitlewithtitle:@"Center Holiday"];
            holidaylabel.textColor=[UIColor whiteColor];
            holidaylabel.font=[UIFont systemFontOfSize:13];
            holidaylabel.layer.borderWidth=0.3;
            holidaylabel.layer.borderColor=[UIColor darkGrayColor].CGColor;
            holidaylabel.textAlignment=NSTextAlignmentCenter;
            [content_View addSubview:holidaylabel];

        }
        previousheight=height;
    }
    
    for (int i=0; i<filteredclasstimetableobjectArray.count; i++) {
        //duplicate lesson records for splitted lesson
        ClassTimeTableRecord3 *object=[filteredclasstimetableobjectArray objectAtIndex:i];
        
        int duplicatecount=1;

        for (int j=1; j<duplicatecount+1; j++) {
            CGRect rect=[self returnlessoncoordinatewithclasstimetableobject:object lessonselected:nil part:duplicatecount==1?0:j];
            
            if(!CGRectEqualToRect(rect, CGRectZero)){
                UIView *container=[[UIView alloc]initWithFrame:rect];
                detailsLessonPrintItem *lessonItem=[[detailsLessonPrintItem alloc]initWithFrame:CGRectMake(0, 0, rect.size.width, 50) LessonObject:object ContentMode:contentmode ZoomMode:zoommode Index:j CellWidth:mincellwidthfordetailview TimeTableMode:TimeTableMode];
//                lessonItem.clipsToBounds=YES;
                container.layer.masksToBounds=YES;
                container.layer.cornerRadius=5;
                container.layer.borderColor=[UIColor lightGrayColor].CGColor;
                container.layer.borderWidth=0.5;
                container.clipsToBounds=YES;
                container.backgroundColor=[UIColor clearColor];
                [container addSubview:lessonItem];
                [content_View addSubview:container];
                

                        }
                    }
                }
    
    UIView *masterprintview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, classtimewidth+pagewidth, pageheight+66)];
    UIView *offsetdateview=[[UIView alloc]initWithFrame:CGRectMake(classtimewidth, 0, pagewidth, 66)];
    UIView *offsetcontentview=[[UIView alloc]initWithFrame:CGRectMake(classtimewidth, 66, pagewidth, pageheight)];
    UIView *offsettimeview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, classtimewidth, pageheight+66)];
    [offsetdateview addSubview:date_View];
    [offsetcontentview addSubview:content_View];
    [offsettimeview addSubview:time_View];
    [masterprintview addSubview:offsetdateview];
    [masterprintview addSubview:offsettimeview];
    [masterprintview addSubview:offsetcontentview];
    return masterprintview;
}

-(NSString *) returnlevelmainwithtimetablerecord:(ClassTimeTableRecord3 *)object
{
    ClassTimeTableSubRecord *subrecord;
    NSMutableArray *levelmainarray=[[NSMutableArray alloc]init];
    for (int i=0; i<object.studentarray.count; i++) {
        subrecord=[object.studentarray objectAtIndex:i];
        if (![levelmainarray containsObject:subrecord.levelmain]) {
            [levelmainarray addObject:subrecord.levelmain];
        }
    }
    return [levelmainarray componentsJoinedByString:@"#|#"];
}

-(void) tapDetailLessonDetected:(UITapGestureRecognizer *)gr
{
    detailsLessonItem *theTappedLesson=(detailsLessonItem *)gr.view;
    ClassTimeTableRecord3 *object=[filteredclasstimetableobjectArray objectAtIndex:theTappedLesson.tag];
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        int delta = [MyClass returndayofweeknumber:object.classday]-1;
        NSDate *dateselected = [[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyyy"] dateByAddingTimeInterval:60*60*24*delta];
        selectedstartdate=[MyClass convertToNSStringWithNSDate:dateselected DateFormat:@"dd-MMM-yyyy"];
        
        if ([self retrieveClassScheduleWithclassdate:selectedstartdate classday:object.classday classtime:object.classtime subject:object.subject instructor:object.instructor classroom:object.classroom classtype:classtypeselected subjecttype:object.subjecttype levelmain:[self returnlevelmainwithtimetablerecord:object] schedulekey:object.schedulekey]) {
            ClassTimeTableDetailsPopoverViewController *viewcontroller = (ClassTimeTableDetailsPopoverViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"ClassTimeTableDetailsPopoverViewController"];
            viewcontroller.delegate=self;
            viewcontroller.ClassScheduleRecordArray=ClassScheduleRecordArray;
            viewcontroller.lesson=object;
            viewcontroller.dateselected=dateselected;
            viewcontroller.timetablemode=TimeTableMode;
            [self startsidewindowanimationwithwidth:self.view.frame.size.width*0.68];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                viewcontroller.view.frame=CGRectMake(0, 0, mainWindow.bounds.size.width*0.68, mainWindow.bounds.size.height);//self->mainWindow.bounds;
                [self->sidewindowview addSubview:viewcontroller.view];
                [self addChildViewController:viewcontroller];
                [viewcontroller didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                self->ailoadindicator.hidden=YES;
            });
        }
    });
    
//    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [MyClass getLatestDataSetv2withParameters:@"" Centerkeys:@"" completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
//            if (!nocenteravailable && !newupdateavailable) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                [MyClass loadingindicatorwithoption:@"stop" color:nil];

//    ClassTimeTableDetailsPopoverViewController *viewcontroller = (ClassTimeTableDetailsPopoverViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"ClassTimeTableDetailsPopoverViewController"];
    //switchcenterviewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
//    viewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
//                    viewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
//                    viewcontroller.singleselection=@"Yes";
//                    viewcontroller.updatecenterkey=@"Yes";
//                [self presentViewController:viewcontroller animated:YES completion: nil];
//                });
//            }
//        }];
//    });
    

    
    
    /*if (ClassScheduleTableShown) {
        if ([object isEqual:selecteddetaillesson]) {
            ClassScheduleTableShown=NO;
            selecteddetaillesson=nil;
        }else{
            selecteddetaillesson=object;
        }
    }else{
        ClassScheduleTableShown=YES;
        selecteddetaillesson=object;
    }
    
    int delta = [MyClass returndayofweeknumber:object.classday]-[MyClass returndayofweeknumber:[classDay objectAtIndex:0]];
    NSDate *dateselected = [[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyyy"] dateByAddingTimeInterval:60*60*24*delta];
    selectedstartdate=[MyClass convertToNSStringWithNSDate:dateselected DateFormat:@"dd-MMM-yyyy"];
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self retrieveClassScheduleWithclassdate:selectedstartdate classday:object.classday classtime:object.classtime subject:object.subject instructor:object.instructor classroom:object.classroom classtype:classtypeselected]) {
            
            [self drawTimeTableWithTimeTableMode:TimeTableMode SelectedLesson:selecteddetaillesson];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        }
    });*/
}

-(void) tapTimeTableDetected
{
    if (ClassScheduleTableShown) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ClassScheduleTableShown=NO;
            selecteddetaillesson=nil;
            [self drawTimeTableWithTimeTableMode:TimeTableMode SelectedLesson:selecteddetaillesson];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }
}

-(CGRect) returnlessoncoordinatewithclasstimetableobject:(ClassTimeTableRecord3 *)drawobject lessonselected:(ClassTimeTableRecord3 *)selectedobject part:(int)part
{
    float margin=0;
//    long timepos=[classTime indexOfObject:drawobject.classtime];
    long minuteoffset=([[drawobject.classtime substringToIndex:2] integerValue]*60+[[drawobject.classtime substringFromIndex:3] integerValue])-([[globalvariables.centerrecord.fullday?@"0000":globalvariables.centerrecord.classstarttime substringToIndex:2] integerValue]*60+[[globalvariables.centerrecord.fullday?@"0000":globalvariables.centerrecord.classstarttime substringFromIndex:2] integerValue]);
    float ypos=(minuteoffset/(NSInteger)cellduration)*cellheight+(minuteoffset%(NSInteger) cellduration)/cellduration*cellheight;
    
    long headerpos;
    if ([headertype isEqualToString:@"All"]) {
        headerpos=0;
    }else{
        headerpos=[filteredHeaderArray indexOfObject:[drawobject valueForKey:[headertype lowercaseString]]];
    }
    long daypos=[classDay indexOfObject:drawobject.classday];

    float headerwidth=[[headerWidthArray objectAtIndex:daypos*[filteredHeaderArray count]+headerpos] floatValue]*cellwidthfordetailview;
    float nooflesson=[self returnnooflessonwithclasstimetableobject:drawobject];
    
    if(nooflesson==0){
        return CGRectZero;
    }
    
    float xpos=[[headerPositionArray objectAtIndex:daypos*[filteredHeaderArray count]+headerpos] floatValue]*cellwidthfordetailview;
    
    xpos+= headerwidth/nooflesson*drawobject.position;

    //offset when detail class is shown
    float timeoffset=0;
    if (selectedobject) {
        if([classTime indexOfObject:drawobject.classtime]>=[classTime indexOfObject:selectedobject.classtime]+(selectedobject.classduration/[globalvariables.centerrecord.classtimeinterval intValue])){
            timeoffset=masterView.frame.size.height;
        }
    }

    CGRect rect;
    //split
    if (part>0) {
        if (part==1) {
            rect= CGRectMake(xpos+margin, ypos+margin+timeoffset, headerwidth/nooflesson-margin*2, ([classTime indexOfObject:selectedobject.classtime]+(selectedobject.classduration/[globalvariables.centerrecord.classtimeinterval intValue])-[classTime indexOfObject:drawobject.classtime])*cellheight-margin*2);
        }else{
            rect= CGRectMake(xpos+margin, (ypos+[classTime indexOfObject:selectedobject.classtime]+selectedobject.classduration/[globalvariables.centerrecord.classtimeinterval intValue]-[classTime indexOfObject:drawobject.classtime])*cellheight+margin+timeoffset+masterView.frame.size.height, headerwidth/nooflesson-margin*2, ([classTime indexOfObject:drawobject.classtime]+drawobject.classduration/[globalvariables.centerrecord.classtimeinterval intValue]-([classTime indexOfObject:selectedobject.classtime]+selectedobject.classduration/[globalvariables.centerrecord.classtimeinterval intValue]))*cellheight-margin*2);
        }
    }else{
        rect= CGRectMake(xpos+margin, ypos+margin+timeoffset, headerwidth/nooflesson-margin*2, drawobject.classduration/cellduration*cellheight-margin*2);
    }
    return rect;
}

-(float) returnnooflessonwithclasstimetableobject:(ClassTimeTableRecord3 *)object
{
//
//    NSString *timevalue;
//    NSMutableArray *timeValueArray=[[NSMutableArray alloc]init];
//
//    //load times
//    for (int j=0; j<object.classduration/5/*[globalvariables.centerrecord.classtimeinterval intValue]*/; j++) {
//        timevalue=[MyClass convertToNSStringWithNSDate:[[MyClass convertToNSDateWithDate:object.classtime DateFormat:@"HH:mm"] dateByAddingTimeInterval:/*[globalvariables.centerrecord.classtimeinterval intValue]*/5*60*j] DateFormat:@"HH:mm"];
//        [timeValueArray addObject:timevalue];
//    }
//
//    NSString *key;
//    if ([headertype isEqualToString:@"All"]) {
//        key=[NSString stringWithFormat:@"%@%@",object.classday,@""];
//    }else{
//        key=[NSString stringWithFormat:@"%@%@",object.classday,[object valueForKey:[headertype lowercaseString]]];
//    }
//
//    NSMutableArray *timeArray;
//    NSMutableArray *lineArray=[CTR_positiondict objectForKey:key];
//    for (long i=lineArray.count-1; i>=0; i--) {
//        timeArray=[lineArray objectAtIndex:i];
//        NSMutableSet *set1 = [NSMutableSet setWithArray: timeValueArray];
//        NSSet *set2 = [NSSet setWithArray: timeArray];
//        [set1 intersectSet: set2];
//        if ([set1 allObjects].count>0) {
//            return i+1;
//            break;
//        }
//    }
//    return 0;
    
    NSString *key;
    if ([headertype isEqualToString:@"All"]) {
        key=[NSString stringWithFormat:@"%@%@",object.classday,@""];
    }else{
        key=[NSString stringWithFormat:@"%@%@",object.classday,[object valueForKey:[headertype lowercaseString]]];
    }
    
    NSMutableArray *columnArrays=[CTR_positiongroupdict objectForKey:key];
    //get passage set
    NSMutableSet *setp=[NSMutableSet setWithArray: object.timevaluearray];
    NSMutableSet *setj=[[NSMutableSet alloc]init];
    NSMutableArray *columnArray;
    ClassTimeTableRecord3 *obj3;
    BOOL recordFound=FALSE;
    for (int i=object.position+1; i<columnArrays.count; i++) {
        recordFound=FALSE;
        columnArray=columnArrays[i];
        for (int j=0; j<columnArray.count; j++) {
            NSInteger index=[columnArray[j] integerValue];
            obj3=[filteredclasstimetableobjectArray objectAtIndex:index];
            setj=[NSMutableSet setWithArray: obj3.timevaluearray];
            [setj intersectSet:setp];
            if ([setj allObjects].count>0) {
                [setp unionSet:[NSMutableSet setWithArray: obj3.timevaluearray]];
                recordFound=TRUE;
            }else if (recordFound==TRUE){
                break;
            }
        }
    }
    NSMutableSet *setl;
    NSMutableArray *lineArray=[CTR_positiondict objectForKey:key];
    for (long i=lineArray.count-1; i>=0; i--) {
        setl = [NSMutableSet setWithArray: [lineArray objectAtIndex:i]];
        [setl intersectSet:setp];
        if([setl allObjects].count>0){
            return i+1;
            break;
        }
    }
    return object.position+1;
}

-(void) drawTimeCellWithViewOption:(NSString *)viewoption updatecellposition:(NSString *)updatecellposition expandcellposition:(NSString *)expandcellposition classschedulerecordarray:(NSMutableArray *)classschedulerecordarray
{
    CGFloat timetableoffset=[self returnclasstimewidth];
    
    [shapeLayer removeFromSuperlayer];
    
    
    if (![updatecellposition isEqualToString:@"NA"]) {
        NSInteger classtimestart=0;
        NSInteger classtimeend=classTime.count;
        int expandcelloffset;

        
        //remove class time
        [[classTimeView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
        [[timetablecollectionview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [masterView removeFromSuperview];
        
        int masterViewHeight=0;
        if (ClassScheduleTableShown) {
            //add table
            
            masterViewHeight=60+(int)ClassScheduleRecordArray.count*25+41;
            [self drawDetailClassMasterViewWithVerticalPosition:(((int)[expandcellposition intValue]/totalSubjectColumn+1)*cellheight)-1];
            
            [timetablecollectionview addSubview:masterView];
            //timetablecollectionview.frame=CGRectMake(timetableoffset, superviewclearence+66, self.view.frame.size.width-timetableoffset,superview.frame.size.height-superviewclearence-66);

            [timetablecollectionview.collectionViewLayout invalidateLayout];
            vfl.masterViewheight=masterViewHeight;
            vfl.contentsize=CGSizeMake(totalSubjectColumn*cellwidth+[self returnclasstimewidth], NoOfTimeSlot*cellheight+masterViewHeight);
            vfl.expandedsection=[expandcellposition floatValue]/totalSubjectColumn;
            vfl.timewidth=[self returnclasstimewidth];
            [timetablecollectionview setCollectionViewLayout:vfl];
            [timetablecollectionview reloadData];
            
            
            //offset screen
            if (lastexpandcelltableheight==0 || [self isOnOrBeforeLastexpandcellRowWithLastexpandcellposition:lastexpandcellposition Expandcellposition:expandcellposition]) {
                //masterview not previously shown or new selected cell is before previously selected cell
                if (masterView.frame.origin.y+masterViewHeight-timetablecollectionview.contentOffset.y>timetablecollectionview.frame.size.height) {
                    //masterview is chopped
                    if (masterViewHeight+cellheight>timetablecollectionview.frame.size.height) {
                        //masterview height + one cellheight >time table screen height
                        //scroll to selected row
                        [timetablecollectionview setContentOffset:CGPointMake(timetablecollectionview.contentOffset.x,masterView.frame.origin.y-cellheight)];
                    }else{
                        //scroll to see all masterview
                        [timetablecollectionview setContentOffset:CGPointMake(timetablecollectionview.contentOffset.x,masterView.frame.origin.y+masterViewHeight-timetablecollectionview.frame.size.height)];
                    }
                }
            }else{
                //masterview previously shown and new selected cell is after previously selected cell
                if (masterView.frame.origin.y<([expandcellposition intValue]/totalSubjectColumn+1)*cellheight+lastexpandcelltableheight-timetablecollectionview.contentOffset.y) {
                    //new selected cell position cannot stay if the previous masterview is closed
                    //scroll to top
                    [timetablecollectionview setContentOffset:CGPointMake(timetablecollectionview.contentOffset.x,0)];
                    
                    if (masterView.frame.origin.y+masterViewHeight-timetablecollectionview.contentOffset.y>timetablecollectionview.frame.size.height) {
                        //masterview is chopped
                        if (masterViewHeight+cellheight>timetablecollectionview.frame.size.height) {
                            //masterview height + one cellheight >time table screen height
                            //scroll to selected row
                            [timetablecollectionview setContentOffset:CGPointMake(timetablecollectionview.contentOffset.x,masterView.frame.origin.y-cellheight)];
                        }else{
                            //scroll to see all masterview
                            [timetablecollectionview setContentOffset:CGPointMake(timetablecollectionview.contentOffset.x,masterView.frame.origin.y+masterViewHeight-timetablecollectionview.frame.size.height)];
                        }
                    }
                }else{
                    //scroll to new position
                    [timetablecollectionview setContentOffset:CGPointMake(timetablecollectionview.contentOffset.x,timetablecollectionview.contentOffset.y-lastexpandcelltableheight)];
                    
                    if (masterView.frame.origin.y+masterViewHeight-timetablecollectionview.contentOffset.y>timetablecollectionview.frame.size.height) {
                        //masterview is chopped
                        if (masterViewHeight+cellheight>timetablecollectionview.frame.size.height) {
                            //masterview height + one cellheight >time table screen height
                            //scroll to selected row
                            [timetablecollectionview setContentOffset:CGPointMake(timetablecollectionview.contentOffset.x,masterView.frame.origin.y-cellheight)];
                        }else{
                            //scroll to see all masterview
                            [timetablecollectionview setContentOffset:CGPointMake(timetablecollectionview.contentOffset.x,masterView.frame.origin.y+masterViewHeight-timetablecollectionview.frame.size.height)];
                        }
                    }
                }
            }

            lastexpandcelltableheight=masterViewHeight;
        }else{
            //[masterView removeFromSuperview];
            //timetablecollectionview.frame=CGRectMake(timetableoffset, superviewclearence+66, self.view.frame.size.width-timetableoffset,superview.frame.size.height-superviewclearence-66);
            timetablecollectionview.contentSize=CGSizeMake(totalSubjectColumn*cellwidth, NoOfTimeSlot*cellheight);
            //[masterScrollView setContentSize:CGSizeMake(TimeTableView.frame.size.width,TimeTableView.frame.size.height)];
            
            [timetablecollectionview.collectionViewLayout invalidateLayout];
            vfl.masterViewheight=0;
            vfl.timewidth=[self returnclasstimewidth];
            vfl.contentsize=CGSizeMake(totalSubjectColumn*cellwidth+[self returnclasstimewidth], NoOfTimeSlot*cellheight);
            [timetablecollectionview setCollectionViewLayout:vfl];
            [timetablecollectionview reloadData];
            lastexpandcelltableheight=0;
        }

        classTimeView.frame=CGRectMake(0, classTimeView.frame.origin.y, [self returnclasstimewidth], NoOfTimeSlot*cellheight+masterViewHeight);
        
        masterView.frame=CGRectMake(timetablecollectionview.contentOffset.x-(detailViewMode?[self returnclasstimewidth]:0), masterView.frame.origin.y, masterView.frame.size.width, masterView.frame.size.height);
        
        
        
        //long PositionIndex;
        expandcelloffset=0;
        for (NSInteger i=classtimestart; i<classtimeend; i++) {
            if (![expandcellposition isEqualToString:@""] && i>((int)([expandcellposition integerValue]/totalSubjectColumn)) && ClassScheduleTableShown) {
                expandcelloffset=ClassDetailTable.frame.size.height+40+20;
                
            }else{
                expandcelloffset=0;
            }
            
            UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*cellheight+expandcelloffset, timetableoffset, cellheight)];
            timeLabel.textAlignment=NSTextAlignmentCenter;
            [timeLabel setFont:[UIFont systemFontOfSize:12]];
            timeLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
            timeLabel.layer.borderWidth=0.3;
            timeLabel.text=[classTime objectAtIndex:i];
            timeLabel.backgroundColor=(i/(60/(NSInteger)cellduration) %2)==0?[UIColor whiteColor]:[UIColor systemGroupedBackgroundColor];
            //timeLabel.tag=888;
            [classTimeView addSubview:timeLabel];

        }
        
//        [TimeTableView addSubview:contentViewBackgroundButton];
        
        
        //add holiday label
        for (int i=0; i<classDay.count; i++) {
            NSDate *calendardate=[[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyy"] dateByAddingTimeInterval:60*60*24*([allClassDay indexOfObject:[classDay objectAtIndex:i]]/*-[allClassDay indexOfObject:[classDay objectAtIndex:0]]*/)];
            
            if (![MyClass isWorkingDate:calendardate includereserveddate:YES] && ![viewoption isEqualToString:@"Consolidated"]) {
                UILabel *holidaylabel=[[UILabel alloc]initWithFrame:CGRectMake(i*filteredHeaderArray.count*cellwidth+[self returnclasstimewidth], 0, filteredHeaderArray.count*cellwidth, timetablecollectionview.contentSize.height+masterViewHeight)];
                holidaylabel.text=[MyClass returntitlewithtitle:@"Center Holiday"];
                holidaylabel.backgroundColor=[UIColor colorWithRed:176.0/255.0 green:36.0/255.0 blue:34.0/255.0 alpha:1.0];
                holidaylabel.textColor=[UIColor whiteColor];
                holidaylabel.textAlignment=NSTextAlignmentCenter;
                holidaylabel.font=[UIFont systemFontOfSize:13];
                [timetablecollectionview addSubview:holidaylabel];
            }
        }
        
        
        //offset class time view
//        if (ClassScheduleTableShown) {
//            [classTimeView setContentOffset:CGPointMake(0, timetablecollectionview.contentOffset.y)];
//            [timetablecollectionview bringSubviewToFront:masterView];
//            [self drawtrianglepointerwithexpandcellposition:CGRectMake([expandcellposition integerValue]%totalSubjectColumn*cellwidth+selectedbutton.frame.origin.x+[self returnclasstimewidth], (((int)[expandcellposition integerValue]/totalSubjectColumn))*cellheight+cellheight, selectedbutton.frame.size.width, cellheight/3)];
//        }
    }
    [self updateHeaderLessonStudentCount];
}

-(BOOL) isOnOrBeforeLastexpandcellRowWithLastexpandcellposition:(NSString *)Lastexpandcellposition Expandcellposition:(NSString *)Expandcellposition
{
    if([Expandcellposition intValue]/totalSubjectColumn <= [Lastexpandcellposition intValue]/totalSubjectColumn){
        return TRUE;
    }else{
        return FALSE;
    }
}

-(NSMutableArray *) refreshClassScheduleWithLesson:(ClassTimeTableRecord3 *)object
{
    int delta = [MyClass returndayofweeknumber:object.classday]-1;
    NSDate *dateselected = [[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyyy"] dateByAddingTimeInterval:60*60*24*delta];
    selectedstartdate=[MyClass convertToNSStringWithNSDate:dateselected DateFormat:@"dd-MMM-yyyy"];
    
    return [self retrieveClassScheduleWithclassdate:selectedstartdate classday:object.classday classtime:object.classtime subject:object.subject instructor:object.instructor classroom:object.classroom classtype:classtypeselected subjecttype:object.subjecttype levelmain:[self returnlevelmainwithtimetablerecord:object] schedulekey:object.schedulekey];
}

-(NSMutableArray *) retrieveClassScheduleWithclassdate:(NSString *)classdate classday:(NSString *)classday classtime:(NSString *)classtime subject:(NSString *)subject instructor:(NSString *)instructor classroom:(NSString *)classroom classtype:(NSString *)classtype subjecttype:(NSString *)subjecttype levelmain:(NSString *)levelmain schedulekey:(NSString *)schedulekey
{

    NSString *strURL;
    
            if ([TimeTableMode isEqualToString:@"Weekly"] || [TimeTableMode isEqualToString:@"PopoverWeekly"]) {
                strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetableclassrecord2&option=%@&classdate=%@&classtime=%@&subject=%@&instructor=%@&classtype=%@&classroom=%@&username=%@&apptype=icenter&subjecttype=%@&levelmain=%@&schedulekey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, TimeTableMode,[MyClass convertDateFormatWithDate:classdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"],classtime,[MyClass enurlstring:subject],[MyClass enurlstring:instructor],classtype,[MyClass enurlstring:classroom],globalvariables.username,subjecttype,levelmain,schedulekey];
            }else if ([TimeTableMode isEqualToString:@"Consolidated"] ){
                strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetableclassrecord2&option=%@&classtime=%@&subject=%@&instructor=%@&classtype=%@&classday=%@&classroom=%@&username=%@&apptype=icenter&subjecttype=%@&levelmain=%@&schedulekey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,TimeTableMode,classtime,[MyClass enurlstring:subject],[MyClass enurlstring:instructor],classtype,classday,[MyClass enurlstring:classroom],globalvariables.username,subjecttype,levelmain,schedulekey];
            }

    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        }
    }];
    
    if(result){
            
            //Set up our class array
            ClassScheduleRecordArray=[[NSMutableArray alloc] init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our ClassRecord object
                NSString * ctype=[[JSONArray objectAtIndex:i] objectForKey:@"type"];
                NSString * cstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                NSString * cstudentid=[[JSONArray objectAtIndex:i] objectForKey:@"studentid"];
                NSString * cclasskey=[[JSONArray objectAtIndex:i] objectForKey:@"classkey"];
                NSString * cclasstype=[[JSONArray objectAtIndex:i] objectForKey:@"classtype"];
                NSString * cenrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
                NSString * cdtkey=[[JSONArray objectAtIndex:i] objectForKey:@"dtkey"];
                
                
                NSString * cfirstname;
                NSString * clastname;
                NSString * cothername;
                NSString * cgender;
                //NSString * cage;
                //NSString * cdateofbirth;
                NSString * cimage;
                NSString * cstudentdisplayname;
                
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
                }
                
                NSString * cparentcontact=[[JSONArray objectAtIndex:i] objectForKey:@"parentcontact"];
                //NSString * cimage=[[JSONArray objectAtIndex:i] objectForKey:@"image"];
                NSString * csubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString * clevelmain=[[JSONArray objectAtIndex:i] objectForKey:@"levelmain"];
                NSString * clevelctm=[[JSONArray objectAtIndex:i] objectForKey:@"levelctm"];
                NSString *cstartdate = [MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"startdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                NSString *cmakeupdate = [MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"makeupdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                
                NSString * cclassday=[[JSONArray objectAtIndex:i] objectForKey:@"classday"];
                NSString * cclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                NSString * cinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
                NSString * cattendance=[[JSONArray objectAtIndex:i] objectForKey:@"attendance"];
                NSString * cmakeupattendance=[[JSONArray objectAtIndex:i] objectForKey:@"makeupattendance"];
                NSString * cmakeuptime=[[JSONArray objectAtIndex:i] objectForKey:@"makeuptime"];
                NSString * cmakeupinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"makeupinstructor"];
                NSString * cmakeupclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"makeupclassroom"];
                NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                NSString * callclassremarks=[[JSONArray objectAtIndex:i] objectForKey:@"allclassremarks"];
                NSString * cabsentmakeupreason=[[JSONArray objectAtIndex:i] objectForKey:@"absentmakeupreason"];
                NSString * cparentnote=[[JSONArray objectAtIndex:i] objectForKey:@"parentnote"];
                NSString * cclassduration=[[JSONArray objectAtIndex:i] objectForKey:@"classduration"];
                
                NSString * cclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
                NSString * cautorenew=[[JSONArray objectAtIndex:i] objectForKey:@"autorenew"];
                NSString * cschedulekey=[[JSONArray objectAtIndex:i] objectForKey:@"schedulekey"];
                NSString * coutstandingextendtime=[[JSONArray objectAtIndex:i] objectForKey:@"outstandingextendtime"];
                NSString * cextendedminute=[[JSONArray objectAtIndex:i] objectForKey:@"extendedminute"];
                NSString * cextensiontime=[[JSONArray objectAtIndex:i] objectForKey:@"extensiontime"];
                NSString * csubjectfullname=[MyClass returnsubjectnamewithsubject_shortname:csubject centerkey:globalvariables.centerrecord.centerkey];
                int cassessmentformcount=[[[JSONArray objectAtIndex:i] objectForKey:@"assessmentformcount"] intValue];
                
                NSString *cfirstclass=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"firstclass"] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd-MMM HH:mm" Translate:NO];
                NSString *cnextclassalldaytime=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"nextclassalldaytime"] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd-MMM HH:mm" Translate:NO];
                NSString *clastscheduledclassalldaytime=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"lastscheduledclassalldaytime"] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd-MMM HH:mm" Translate:NO];
                NSString * cremainingclassscheduledall=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassscheduledall"];
                NSString * cremainingclassscheduled=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassscheduled"];
                NSString * cremainingclassTBDclass=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassTBDclass"];
                NSString * cremainingclassTBDmakeup=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassTBDmakeup"];
                NSString * coutstandingpayment=[NSString stringWithFormat:@"%g",[[[JSONArray objectAtIndex:i] objectForKey:@"outstandingpayment"] floatValue]];
                NSString * clesson=[[JSONArray objectAtIndex:i] objectForKey:@"lesson"];
                BOOL clocked=[[[JSONArray objectAtIndex:i] objectForKey:@"locked"] isEqualToString:@"Yes"];
                BOOL cenrollmentpaid=[[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentpaid"] isEqualToString:@"1"];
                
                BOOL deletedrecord=FALSE;
                for (int k=0; k<FreeScheduleClassArray.count; k++) {
                    FreeScheduleClassObject=[FreeScheduleClassArray objectAtIndex:k];
                    if ([FreeScheduleClassObject.classkey isEqualToString:cclasskey] && [FreeScheduleClassObject.action isEqualToString:@"Delete"]) {
                        deletedrecord=TRUE;
                        break;
                    }
                }
                
                NSString * cleavenaturelistkey=[[JSONArray objectAtIndex:i] objectForKey:@"leavenaturelistkey"];
                BOOL cmakeupquotaavailable=[[[JSONArray objectAtIndex:i] objectForKey:@"makeupquotaavailable"] isEqualToString:@"Yes"];
                NSString * csinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"sinstructor"];
                NSString * cmakeupsinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"makeupsinstructor"];
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
                
                if (deletedrecord==FALSE) {
                    //Add the class record object to our array
                    [ClassScheduleRecordArray addObject:[[ClassScheduleRecord alloc]initClassScheduleRecordWithstudentkey:cstudentkey andenrollmentkey:cenrollmentkey andclasskey:cclasskey anddtkey:cdtkey andclasstype:cclasstype andfirstname:cfirstname andlastname:clastname andothername:cothername andgender:cgender andparentcontact:cparentcontact andimage:cimage andsubject:csubject andlevelmain:clevelmain andlevelctm:clevelctm andstartdate:cstartdate andclassday:cclassday andclasstime:cclasstime andinstructor:cinstructor andclassroom:cclassroom andattendance:cattendance andmakeupattendance:cmakeupattendance andmakeupdate:cmakeupdate andmakeuptime:cmakeuptime andremarks:cremarks andallclassremarks:callclassremarks andmakeupinstructor:cmakeupinstructor andmakeupclassroom:cmakeupclassroom andabsentmakeupreason:cabsentmakeupreason andfirstclass:cfirstclass andnextclassalldaytime:cnextclassalldaytime andlastscheduledclassalldaytime:clastscheduledclassalldaytime andremainingclassscheduled:cremainingclassscheduled andremainingclassTBDclass:cremainingclassTBDclass andremainingclassTBDmakeup:cremainingclassTBDmakeup andremainingclassscheduledall:cremainingclassscheduledall andoutstandingpayment:coutstandingpayment andclassduration:cclassduration type:ctype instructorfullname:nil autorenew:cautorenew schedulekey:cschedulekey outstandingextendtime:coutstandingextendtime extendedminute:cextendedminute status:nil extensiontime:cextensiontime subjectfullname:csubjectfullname studentid:cstudentid parentnote:cparentnote studentdisplayname:cstudentdisplayname assessmentformcount:cassessmentformcount leavenaturelistkey:cleavenaturelistkey makeupquotaavailable:cmakeupquotaavailable realclassroom:realclassroom realclasstime:realclasstime lesson:clesson sinstructor:csinstructor makeupsinstructor:cmakeupsinstructor sinstructorfullname:csinstructorfullname locked:clocked enrollmentpaid:cenrollmentpaid]];
                }
            }
//        }
        return ClassScheduleRecordArray;
    }else{
        return nil;
    }
}

-(BOOL) retrieveTimeTableDetailsWithOption:(NSString *)option type:(NSString *)type classdate:(NSString *)classdate classday:(NSString *)classday classtime:(NSString *)classtime subtypevalue:(NSString *)subtypevalue
{
    return TRUE;
    /*NSString *strURL;
    //long timetableindex;
    
    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selecttimetabledetails&option=%@&type=%@&classdate=%@&classday=%@&classtime=%@&subtypevalue=%@&subtype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,option,type,[MyClass convertDateFormatWithDate:classdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"],classday,classtime,[MyClass enurlstring:subtypevalue],headertype];

    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            ClassTimeDetailsdictionary=[[NSMutableDictionary alloc]init];
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our ClassRecord object
                NSString * ctimetablekey=[[JSONArray objectAtIndex:i] objectForKey:@"timetablekey"];
                NSString * ctype=[[JSONArray objectAtIndex:i] objectForKey:@"type"];
                NSString * cclassdate=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"classdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy"];
                NSString * cclassday=[[JSONArray objectAtIndex:i] objectForKey:@"classday"];
                NSString * cclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                NSString * csubtypevalue=[[JSONArray objectAtIndex:i] objectForKey:@"subtypevalue"];
                NSString * cblock=[[JSONArray objectAtIndex:i] objectForKey:@"block"];
                NSString * ccaption=[[JSONArray objectAtIndex:i] objectForKey:@"caption"];
                NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                

                
                //add position to position array
                if ([option isEqualToString:@"Daily"]) {
                    [ClassTimeDetailsdictionary setValue:[[TimeTableDetails alloc]initTimeTableDetailsWithtimetablekey:ctimetablekey type:ctype classdate:cclassdate classday:cclassday classtime:cclasstime subtypevalue:csubtypevalue block:cblock caption:ccaption remarks:cremarks] forKey:[NSString stringWithFormat:@"%@%@%@%d",cclassday,cclasstime,csubtypevalue,i]];
                }else{
                    if ([type isEqualToString:@"Consolidated"]) {
                        [ClassTimeDetailsdictionary setValue:[[TimeTableDetails alloc]initTimeTableDetailsWithtimetablekey:ctimetablekey type:ctype classdate:cclassdate classday:cclassday classtime:cclasstime subtypevalue:csubtypevalue block:cblock caption:ccaption remarks:cremarks] forKey:[NSString stringWithFormat:@"%@%@%@",cclassday,cclasstime,csubtypevalue]];
                    }else{
                        if ([ctype isEqualToString:@"Weekly"]) {
                            if ([cblock isEqualToString:@"No"]) {
                                if ([ClassTimeDetailsdictionary objectForKey:[NSString stringWithFormat:@"%@%@%@",cclassday,cclasstime,csubtypevalue]]) {
                                    ((TimeTableDetails *)[ClassTimeDetailsdictionary objectForKey:[NSString stringWithFormat:@"%@%@%@",cclassday,cclasstime,csubtypevalue]]).block=@"No";
                                }
                            }

                            if ([ClassTimeDetailsdictionary objectForKey:[NSString stringWithFormat:@"%@%@%@",cclassday,cclasstime,csubtypevalue]]) {
                                [ClassTimeDetailsdictionary removeObjectForKey:[NSString stringWithFormat:@"%@%@%@",cclassday,cclasstime,csubtypevalue]];
                                [ClassTimeDetailsdictionary setValue:[[TimeTableDetails alloc]initTimeTableDetailsWithtimetablekey:ctimetablekey type:ctype classdate:cclassdate classday:cclassday classtime:cclasstime subtypevalue:csubtypevalue block:cblock caption:ccaption remarks:cremarks] forKey:[NSString stringWithFormat:@"%@%@%@",cclassday,cclasstime,csubtypevalue]];
                            }else{
                                [ClassTimeDetailsdictionary setValue:[[TimeTableDetails alloc]initTimeTableDetailsWithtimetablekey:ctimetablekey type:ctype classdate:cclassdate classday:cclassday classtime:cclasstime subtypevalue:csubtypevalue block:cblock caption:ccaption remarks:cremarks] forKey:[NSString stringWithFormat:@"%@%@%@",cclassday,cclasstime,csubtypevalue]];
                            }
                        }else{
                            [ClassTimeDetailsdictionary setValue:[[TimeTableDetails alloc]initTimeTableDetailsWithtimetablekey:ctimetablekey type:ctype classdate:cclassdate classday:cclassday classtime:cclasstime subtypevalue:csubtypevalue block:cblock caption:ccaption remarks:cremarks] forKey:[NSString stringWithFormat:@"%@%@%@",cclassday,cclasstime,csubtypevalue]];
                        }
                    }
                }
            }
        }
    }];
    
    return result;*/
}

-(void) cellButtonPressed:(UIButton *)sender
{
    [self.view endEditing:YES];
    UIButton *oldbutton=selectedbutton;
    selectedbutton=sender;
    NSString *key;
    int count;
    
    long cellposition=0;

    ClassTimeTableRecord *classtimetableobject=[[ClassTimeTableRecord alloc]init];
    NSDate *date=[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyy"];
    NSString *tagstring=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    if ([[tagstring substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]) {
        //class records
        cellposition=[[tagstring substringWithRange:NSMakeRange(1, 3)] intValue];
        key=[NSString stringWithFormat:@"%d",[[tagstring substringWithRange:NSMakeRange(4, 5)] intValue]];
        
        ClassTimeTableRecordArray=[ClassTimeTableRecordDictionary objectForKey:key];
        ClassTimeTableObject=[ClassTimeTableRecordArray objectAtIndex:cellposition];
        
        selectedclassday=ClassTimeTableObject.classday;
        selectedclasstime=ClassTimeTableObject.classtime;
        selectedsubject=ClassTimeTableObject.subject;
        selectedinstructor=ClassTimeTableObject.instructor;
        selectedclassroom=ClassTimeTableObject.classroom;
        
        //combine 3rd dimension
        if (combine3rddimension) {
            if ([[contentmodearray objectAtIndex:sccontentmode.selectedSegmentIndex==0?1:0] isEqualToString:@"Classroom"]) {
                selectedclassroom=@"All";
            }else if ([[contentmodearray objectAtIndex:sccontentmode.selectedSegmentIndex==0?1:0] isEqualToString:@"Subject"]) {
                selectedsubject=@"All";
            }else if ([[contentmodearray objectAtIndex:sccontentmode.selectedSegmentIndex==0?1:0] isEqualToString:@"Instructor"]) {
                selectedinstructor=@"All";
            }
        }
        
        if ([headertype isEqualToString:@"All"]) {
            selectedsubject=@"All";
            selectedinstructor=@"All";
            selectedclassroom=@"All";
        }
        
    }else{
        count=[[[NSString stringWithFormat:@"%ld", (long)sender.tag] substringWithRange:NSMakeRange(1, 3)] intValue] /filteredHeaderArray.count;
        
        selectedclassday=[classDay objectAtIndex:count];
        selectedclasstime=[classTime objectAtIndex:[[[NSString stringWithFormat:@"%ld", (long)sender.tag] substringWithRange:NSMakeRange(4, 3)] intValue]];
        selectedsubject=[headertype isEqualToString:@"Subject"]?[filteredHeaderArray objectAtIndex:[[[NSString stringWithFormat:@"%ld", (long)sender.tag] substringWithRange:NSMakeRange(1, 3)] intValue] % filteredHeaderArray.count]:@"";
        selectedinstructor=[headertype isEqualToString:@"Instructor"]?[filteredHeaderArray objectAtIndex:[[[NSString stringWithFormat:@"%ld", (long)sender.tag] substringWithRange:NSMakeRange(1, 3)] intValue] % filteredHeaderArray.count]:@"";
        selectedclassroom=[headertype isEqualToString:@"Classroom"]?[filteredHeaderArray objectAtIndex:[[[NSString stringWithFormat:@"%ld", (long)sender.tag] substringWithRange:NSMakeRange(1, 3)] intValue] % filteredHeaderArray.count]:@"";
        
        if ([headertype isEqualToString:@"All"]) {
            selectedsubject=@"All";
            selectedinstructor=@"All";
            selectedclassroom=@"All";
        }
    }
    

    long delta = [allClassDay indexOfObject:selectedclassday]-[allClassDay indexOfObject:[classDay firstObject]];
    NSDate *dateselected = [date dateByAddingTimeInterval:60*60*24*delta];
    //[df setDateFormat:@"dd-MMM-yyyy"];
    //selectedstartdate=[df stringFromDate:dateselected];
    selectedstartdate=[MyClass convertToNSStringWithNSDate:dateselected DateFormat:@"dd-MMM-yyyy"];

    
    if ([TimeTableMode isEqualToString:@"PopoverConsolidated"] || ([TimeTableMode isEqualToString:@"PopoverWeekly"] && [sourcemode isEqualToString:@"Enrollment"])) {
        
        if ([EnrollmentMode isEqualToString:@"Schedule"]) {
            //[df setDateFormat:@"dd-MMM-yyyy"];
            if (![MyClass schedulecontainscelldatetimewithdate:[MyClass convertToNSDateWithDate:selectedstartdate DateFormat:@"dd-MMM-yyyy"] time:selectedclasstime schedulerecord:[MyClass returnscheduleinformationwithsubject_shortname:Subjectselected schedulekey:selectedschedulekey centerkey:globalvariables.centerrecord.centerkey]]) {
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Select Class"] message:[MyClass returntitlewithtitle:@"Please select date and time within the selected schedule"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                                [erroralert addAction:OKAction];
                //[self presentViewController:erroralert animated:YES completion:nil];
                [MyClass presentViewController:erroralert View:self];
            }else{
                [self.delegate passTimeTableInformationwithstartdate:selectedstartdate classtime:selectedclasstime instructor:preferredinstructor classroom:preferredclassroom];
            }
        }else{
            FreeScheduleClass *freeclass=[self classAlreadySelectedWithClassDate:selectedstartdate ClassTime:selectedclasstime];
            if (freeclass) {
                //deselect class
                ClassScheduleTableShown=NO;
                [self removefreeclassschedulearraywithclassdate:selectedstartdate classtime:freeclass.classtime instructor:freeclass.instructor index:-1];
            }else{
                classtimetableobject=[self timeSlotContainsInstructorClassWithInstructor:preferredinstructor ClassDay:selectedclassday ClassTime:selectedclasstime Subject:selectedsubject Classroom:selectedclassroom];
                
                if (classtimetableobject) {
                    
                    //[df setDateFormat:@"HH:mm"];
                    NSDate *classenddate=[[MyClass convertToNSDateWithDate:selectedclasstime DateFormat:@"HH:mm"] dateByAddingTimeInterval:[((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:Subjectselected centerkey:globalvariables.centerrecord.centerkey]).classduration intValue]*60];
                    //[df setDateFormat:@"HHmm"];
                    NSDate *dayenddate=[MyClass convertToNSDateWithDate:globalvariables.centerrecord.classendtime DateFormat:@"HHmm"];
                    
                    if ([classenddate compare:dayenddate]==NSOrderedDescending) {
                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Select Class"] message:[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [erroralert addAction:OKAction];
                        [self presentViewController:erroralert animated:YES completion:nil];
                        
                        if (ClassScheduleTableShown) {
                            ClassScheduleTableShown=NO;
                            [self drawTimeCellWithViewOption:@"" updatecellposition:@"All" expandcellposition:@"" classschedulerecordarray:nil];
                        }
                        
                    }else{
                        //popup class details
                        long newbuttontag=sender.tag-[InstructorNameArray indexOfObject:selectedinstructor]+[InstructorNameArray indexOfObject:classtimetableobject.instructor];
                        
                        UIButton *newbutton=(UIButton *)[TimeTableView viewWithTag:newbuttontag];
                        selectedbutton=newbutton;
                        
                        [self popupDetailClassInformationWithStartDate:selectedstartdate Classday:selectedclassday ClassTime:selectedclasstime Subject:selectedsubject Instructor:classtimetableobject.instructor Classroom:classtimetableobject.classroom ClassType:classtypeselected Button:newbutton OldButton:oldbutton];
                    }
                    
                }else{
                    if (ClassScheduleTableShown) {
                        //close class details
                        ClassScheduleTableShown=NO;
                        [self drawTimeCellWithViewOption:@"" updatecellposition:@"All" expandcellposition:@"" classschedulerecordarray:nil];
                    }else{
                        //check right subject selected
                        if ([selectedsubject isEqualToString:Subjectselected]) {
                            //[df setDateFormat:@"HH:mm"];
                            NSDate *classenddate=[[MyClass convertToNSDateWithDate:selectedclasstime DateFormat:@"HH:mm"] dateByAddingTimeInterval:[((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:Subjectselected centerkey:globalvariables.centerrecord.centerkey]).classduration intValue]*60];
                            //[df setDateFormat:@"HHmm"];
                            NSDate *dayenddate=[MyClass convertToNSDateWithDate:globalvariables.centerrecord.classendtime DateFormat:@"HHmm"];
                            
                            //check if blocked timeslot
                            TimeTableDetailsObject=[ClassTimeDetailsdictionary objectForKey:[NSString stringWithFormat:@"%@%@%@",selectedclassday,selectedclasstime,selectedsubject]];
                            if (TimeTableDetailsObject) {
                                //long index=[TimeTableDetailsPositionArray indexOfObject:[NSString stringWithFormat:@"%@%@%@",selectedclassday,selectedclasstime,selectedsubject]];
                                if ([TimeTableDetailsObject.block isEqualToString:@"Yes"]){
                                    if ([classenddate compare:dayenddate]==NSOrderedDescending) {
                                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Select Class"] message:[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"] preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                                        }];
                                        
                                        [erroralert addAction:OKAction];
                                        [self presentViewController:erroralert animated:YES completion:nil];
                                    }else{
                                        //show block override window
                                        [self popupDetailClassInformationWithStartDate:selectedstartdate Classday:selectedclassday ClassTime:selectedclasstime Subject:selectedsubject Instructor:preferredinstructor Classroom:selectedclassroom ClassType:classtypeselected Button:sender OldButton:oldbutton];
                                    }
                                }else{
                                    //check if class end does not beyond day end
                                    if ([classenddate compare:dayenddate]==NSOrderedDescending) {
                                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Select Class"] message:[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"] preferredStyle:UIAlertControllerStyleAlert];
                                        
                                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                                        }];
                                        
                                        [erroralert addAction:OKAction];
                                        [self presentViewController:erroralert animated:YES completion:nil];
                                    }else{
                                        if (currentscscheduleindex==0) {
                                            [self.delegate passTimeTableInformationwithstartdate:selectedstartdate classtime:selectedclasstime instructor:preferredinstructor classroom:preferredclassroom];
                                        }else{
                                            //add class
                                            ClassScheduleTableShown=NO;
                                            [self addfreeclassschedulearraywithclassdate:selectedstartdate classtime:selectedclasstime instructor:preferredinstructor classroom:preferredclassroom classremarks:@"" allclassremarks:subjectallclassremarks preferredrow:-1];
                                        }
                                    }
                                }
                                
                                
                            }else{
                                //check if class end does not beyond day end
                                if ([classenddate compare:dayenddate]==NSOrderedDescending) {
                                    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Select Class"] message:[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"] preferredStyle:UIAlertControllerStyleAlert];
                                    
                                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                        [erroralert dismissViewControllerAnimated:YES completion:nil];
                                    }];
                                    
                                    [erroralert addAction:OKAction];
                                    [self presentViewController:erroralert animated:YES completion:nil];
                                }else{
                                    if (currentscscheduleindex==0) {
                                        [self.delegate passTimeTableInformationwithstartdate:selectedstartdate classtime:selectedclasstime instructor:preferredinstructor classroom:preferredclassroom];
                                    }else{
                                        //add class
                                        ClassScheduleTableShown=NO;
                                        [self addfreeclassschedulearraywithclassdate:selectedstartdate classtime:selectedclasstime instructor:preferredinstructor classroom:preferredclassroom classremarks:@"" allclassremarks:subjectallclassremarks preferredrow:-1];
                                    }
                                }
                            }
                        }else{
                            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Select Class"] message:[NSString stringWithFormat:[MyClass returntitlewithtitle:@"Please select %@ subject instead"],Subjectselected] preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                                [erroralert dismissViewControllerAnimated:YES completion:nil];
                            }];
                            
                            [erroralert addAction:OKAction];
                            [self presentViewController:erroralert animated:YES completion:nil];
                        }
                    }
                }
                
            }

        }
        
        
        
      }else if ([TimeTableMode isEqualToString:@"PopoverWeekly"]){
        if ([selectedsubject isEqualToString:Subjectselected]) {
            
            classtimetableobject=[self timeSlotContainsInstructorClassWithInstructor:preferredinstructor ClassDay:selectedclassday ClassTime:selectedclasstime Subject:selectedsubject Classroom:selectedclassroom];
            
            //check if instructor class exists
            if (classtimetableobject) {
                if (ClassScheduleTableShown) {
                    //close class schedule table
                    ClassScheduleTableShown=FALSE;
                    [self drawTimeCellWithViewOption:@"" updatecellposition:@"All" expandcellposition:@"" classschedulerecordarray:nil];
                }else{
                    //check if original date
                    FreeScheduleClass *freeclass=[self classAlreadySelectedWithClassDate:selectedstartdate ClassTime:selectedclasstime];
                    if (freeclass) {
                        //update FreeScheduleClass
                        [self updateFreeScheduleClass];
                        
                        //return class with new classtime
                        [self.delegate passTimeTableInformationwithstartdate:selectedstartdate classtime:selectedclasstime instructor:preferredinstructor classroom:preferredclassroom];
                    }else{
                        //pop up class details
                        //generate popover to show class details
                        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self popupDetailClassInformationWithStartDate:self->selectedstartdate Classday:self->selectedclassday ClassTime:self->selectedclasstime Subject:self->selectedsubject Instructor:self->selectedinstructor Classroom:selectedclassroom ClassType:self->classtypeselected Button:sender OldButton:oldbutton];
                        });
                    }
                }
            }else{
                if (ClassScheduleTableShown) {
                    //close class schedule table
                    ClassScheduleTableShown=FALSE;
                    [self drawTimeCellWithViewOption:@"" updatecellposition:@"All" expandcellposition:@"" classschedulerecordarray:nil];
                }else{
                    //[df setDateFormat:@"HH:mm"];
                    NSDate *classenddate=[[MyClass convertToNSDateWithDate:selectedclasstime DateFormat:@"HH:mm"] dateByAddingTimeInterval:[((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:Subjectselected centerkey:globalvariables.centerrecord.centerkey]).classduration intValue]*60];
                    //[df setDateFormat:@"HHmm"];
                    NSDate *dayenddate=[MyClass convertToNSDateWithDate:globalvariables.centerrecord.classendtime DateFormat:@"HHmm"];
                    
                    if ([classenddate compare:dayenddate]==NSOrderedDescending) {
                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Select Class"] message:[MyClass returntitlewithtitle:@"Class end time is beyond center's closing hour"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [erroralert addAction:OKAction];
                        [self presentViewController:erroralert animated:YES completion:nil];
                        
                        if (ClassScheduleTableShown) {
                            ClassScheduleTableShown=NO;
                            [self drawTimeCellWithViewOption:@"" updatecellposition:@"All" expandcellposition:@"" classschedulerecordarray:nil];
                        }
                        
                    }else{
                        //check if timeslot block
                        if ([ClassTimeDetailsdictionary objectForKey:[NSString stringWithFormat:@"%@%@%@",selectedclassday,selectedclasstime,selectedsubject]]) {
                            //pop up block override window
                            //generate popover to show class details
                            [self popupDetailClassInformationWithStartDate:selectedstartdate Classday:selectedclassday ClassTime:selectedclasstime Subject:selectedsubject Instructor:selectedinstructor Classroom:selectedclassroom ClassType:classtypeselected Button:sender OldButton:oldbutton];
                        }else{
                            //update FreeScheduleClass
                            [self updateFreeScheduleClass];
                            
                            //return class
                            [self.delegate passTimeTableInformationwithstartdate:selectedstartdate classtime:selectedclasstime instructor:preferredinstructor classroom:preferredclassroom];
                        }
                    }
                }
            }
        }else{
            if (ClassScheduleTableShown==TRUE) {
                //close class schedule table
                ClassScheduleTableShown=FALSE;
                [self drawTimeCellWithViewOption:@"" updatecellposition:@"All" expandcellposition:@"" classschedulerecordarray:nil];
            }else{
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Select Class"] message:[NSString stringWithFormat:@"%@ %@ %@",[MyClass returntitlewithtitle:@"Please select"],Subjectselected,[MyClass returntitlewithtitle:@"subject instead"]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
            }
        }
    }else{
        //generate popover to show class details
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self popupDetailClassInformationWithStartDate:selectedstartdate Classday:selectedclassday ClassTime:selectedclasstime Subject:selectedsubject Instructor:selectedinstructor Classroom:selectedclassroom ClassType:classtypeselected Button:sender OldButton:oldbutton];
        });
    }
}


-(void) updateFreeScheduleClass
{
    if (FreeScheduleClassArray.count==0) {
        //add new record
        [FreeScheduleClassArray addObject:[[FreeScheduleClass alloc]initFreeScheduleClassWithclasskey:@"" subject:Subjectselected classdate:selectedstartdate classtime:selectedclasstime instructor:preferredinstructor classroom:@"" attendance:globalvariables.centerrecord.defaultattendancestatus makeupdate:@"" makeuptime:@"" makeupinstructor:@"" makeupclassroom:@"" makeupattendance:@"" classremarks:@"" allclassremarks:@"" action:@"Add" classtype:@"Class" leavenaturelistkey:@"0" lesson:@"" sinstructor:@"" makeupsinstructor:@"" locked:NO]];
    }else{
        for (int i=0; i<FreeScheduleClassArray.count; i++) {
            FreeScheduleClassObject=[FreeScheduleClassArray objectAtIndex:i];
            if ([FreeScheduleClassObject.action isEqualToString:@"Add"] || [FreeScheduleClassObject.action isEqualToString:@"Edit"]) {
                FreeScheduleClassObject.instructor=preferredinstructor;
                break;
            }else if ([FreeScheduleClassObject.action isEqualToString:@""]){
                //delete existing record
                FreeScheduleClassObject.action=@"Edit";
                break;
            }
        }
    }
}

-(void) selectdatebuttonpressed:(UIButton *)sender
{
    if (myPopoverController) {
        [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    }
    
    NSString *startdate;
    NSString *classtime;
    NSString *classday;
    NSString *instructor;
    NSString *subject;
    NSString *classroom=@"";
    int count;
    
    
    for (int i=0; i<ClassScheduleRecordArray.count; i++) {
        if ([classroom isEqualToString:@""]) {
            classroom=((ClassScheduleRecord *)[ClassScheduleRecordArray objectAtIndex:i]).classroom;
        }else{
            if (![classroom isEqualToString:((ClassScheduleRecord *)[ClassScheduleRecordArray objectAtIndex:i]).classroom]) {
                classroom=@"TBD";
            }
        }
    }

    
    ClassScheduleTableShown=FALSE;
    
    sender=selectedbutton;
    
    NSString *tagstring=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    if ([[tagstring substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"1"]) {
        long cellposition=[[tagstring substringWithRange:NSMakeRange(1, 3)] intValue];
        NSString *key=[NSString stringWithFormat:@"%d",[[tagstring substringWithRange:NSMakeRange(4, 5)] intValue]];
        
        ClassTimeTableRecordArray=[ClassTimeTableRecordDictionary objectForKey:key];
        ClassTimeTableObject=[ClassTimeTableRecordArray objectAtIndex:cellposition];
        
        classday=ClassTimeTableObject.classday;
        classtime=ClassTimeTableObject.classtime;
        subject=ClassTimeTableObject.subject;
        instructor=ClassTimeTableObject.instructor;
    }else{
        count=[[[NSString stringWithFormat:@"%ld", (long)sender.tag] substringWithRange:NSMakeRange(1, 3)] intValue] /filteredHeaderArray.count;
        
        classday=[classDay objectAtIndex:count];
        classtime=[classTime objectAtIndex:[[[NSString stringWithFormat:@"%ld", (long)sender.tag] substringWithRange:NSMakeRange(4, 3)] intValue]];
        subject=[headertype isEqualToString:@"Subject"]?[filteredHeaderArray objectAtIndex:[[[NSString stringWithFormat:@"%ld", (long)sender.tag] substringWithRange:NSMakeRange(1, 3)] intValue] % filteredHeaderArray.count]:@"";
        instructor=[self autoassigninstructorwithsubject:subject];
    }
    
    NSDate *date=[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyy"];
    long delta = [allClassDay indexOfObject:classday]-[allClassDay indexOfObject:[classDay firstObject]];
    //int delta = [MyClass returndayofweeknumber:selectedclassday]-[MyClass returndayofweeknumber:[classDay objectAtIndex:0]];
    NSDate *dateselected = [date dateByAddingTimeInterval:60*60*24*delta];
    //[df setDateFormat:@"dd-MMM-yyyy"];
    startdate=[MyClass convertToNSStringWithNSDate:dateselected DateFormat:@"dd-MMM-yyyy"];
    
    preferredinstructor=([preferredinstructor isEqualToString:@""] || !preferredinstructor)?instructor:preferredinstructor;
    
    
    //check if already enrolled
    NSString *fullnamereturned=[self checkAlreadyEnrolledWhenPressingSelectDate];
    if (fullnamereturned) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Select Class"] message:[NSString stringWithFormat:@"%@ %@",fullnamereturned,[MyClass returntitlewithtitle:@"already has class in this time slot. Please select another one"]] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else{
        preferredinstructor=instructor;
        
        if ([TimeTableMode isEqualToString:@"PopoverWeekly"] && ![sourcemode isEqualToString:@"Enrollment"]) {
            
            //update freescheduleclassarray
            for (int i=0; i<FreeScheduleClassArray.count; i++) {
                FreeScheduleClassObject=[FreeScheduleClassArray objectAtIndex:i];
                FreeScheduleClassObject.instructor=instructor;
                if ([FreeScheduleClassObject.action isEqualToString:@""]){
                    //delete existing record
                    FreeScheduleClassObject.action=@"Edit";
                }
            }
            //return data
            [self.delegate passTimeTableInformationwithstartdate:startdate classtime:classtime instructor:instructor classroom:classroom];
        }else{
            if (currentscscheduleindex==0) {
                //return data
                [self.delegate passTimeTableInformationwithstartdate:startdate classtime:classtime instructor:instructor classroom:classroom];
            }else{
                //add to free schedule array
                [self addfreeclassschedulearraywithclassdate:startdate classtime:classtime instructor:instructor classroom:classroom classremarks:@"" allclassremarks:subjectallclassremarks preferredrow:-1];
            }
        }

    }
}

-(NSString *) checkAlreadyEnrolledWhenPressingSelectDate
{
    ClassScheduleRecord *classscheduleobject=[[ClassScheduleRecord alloc]init];
    for (int i=0; i<ClassScheduleRecordArray.count; i++) {
        classscheduleobject=[ClassScheduleRecordArray objectAtIndex:i];
        if ([classscheduleobject.studentkey isEqualToString:studentkey]) {
            return [MyClass returnStudentnameWithStudentkey:classscheduleobject.studentkey option:@"full"];
        }
    }
    return nil;
}


-(BOOL) popupDetailClassInformationWithStartDate:(NSString *)startdate Classday:(NSString *)classday ClassTime:(NSString *)classtime Subject:(NSString *)subject Instructor:(NSString *)instructor Classroom:(NSString *)classroom ClassType:(NSString *)classtype Button:(UIButton *)button OldButton:(UIButton *)oldbutton
{

    NSString *cellposition=[self returnclasstimetableallarraypositionwithclassday:classday classtime:classtime subject:subject classroom:classroom instructor:instructor];
    if ([ClassTimeTableRecordDictionary objectForKey:cellposition]) {
        
        if (button.tag==oldbutton.tag) {
                ClassScheduleTableShown=FALSE;
                lastexpandcellposition=@"";
            selectedbutton=nil;
                [self drawTimeCellWithViewOption:TimeTableMode updatecellposition:@"All" expandcellposition:@"" classschedulerecordarray:nil];
            
        }else{
            //get class into array
//            if (![self retrieveClassScheduleWithclassdate:startdate classday:classday classtime:classtime subject:subject instructor:instructor classroom:classroom classtype:classtype subjecttype:@"subject" levelmain:<#(NSString *)#> schedulekey:<#(NSString *)#>]) {
//                return NO;
//            }
            
            ClassScheduleTableShown=TRUE;

            
            [self drawTimeCellWithViewOption:TimeTableMode updatecellposition:@"All" expandcellposition:[self returnclasstimetableallarraypositionwithclassday:[self findclassdaywithstartdate:startdate] classtime:classtime subject:subject classroom:classroom instructor:instructor] classschedulerecordarray:ClassScheduleRecordArray];
            lastexpandcellposition=[self returnclasstimetableallarraypositionwithclassday:[self findclassdaywithstartdate:startdate] classtime:classtime subject:subject classroom:classroom instructor:instructor];
        }

    }else{
        if (ClassScheduleTableShown==TRUE) {
            ClassScheduleTableShown=FALSE;
            lastexpandcellposition=@"";
            selectedbutton=nil;
            //close class schedule table
            [self drawTimeCellWithViewOption:TimeTableMode updatecellposition:@"All" expandcellposition:@"" classschedulerecordarray:nil];
        }else{
            
            [ClassScheduleRecordArray removeAllObjects];
            NSString *subtypevalue;
            if ([headertype isEqualToString:@"Subject"]) {
                subtypevalue=subject;
            }else if ([headertype isEqualToString:@"Instructor"]){
                subtypevalue=instructor;
            }else{
                subtypevalue=classroom;
            }
            
            TimeTableDetailsObject=[ClassTimeDetailsdictionary objectForKey:[NSString stringWithFormat:@"%@%@%@",classday,classtime,subtypevalue]];
            if (!TimeTableDetailsObject) {
                TimeTableDetailsObject=[[TimeTableDetails alloc]init];
            }
            
            int height;
            height=44+35+35+90;
            
            UIView *timedetailView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, height)];
            
            //add toolbar
            UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            toolbar.barStyle=UIBarStyleDefault;
            NSMutableArray *barItems=[[NSMutableArray alloc]init];
            UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            
            if ([TimeTableMode isEqualToString:@"PopoverWeekly"] || [TimeTableMode isEqualToString:@"PopoverConsolidated"]) {
                UIBarButtonItem *overridebutton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Override Blocking"] style:UIBarButtonItemStylePlain target:self action:@selector(selectdatebuttonpressed:)];
                //classtablebutton.tag=button.tag;
                barItems = [[NSMutableArray alloc]initWithObjects:flexSpace,overridebutton, nil];
            }else{
                UIBarButtonItem *donebutton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(donebuttonpressed:)];
                barItems = [[NSMutableArray alloc]initWithObjects:flexSpace,donebutton, nil];
            }
            
            
            
            [toolbar setItems:barItems];
            [timedetailView addSubview:toolbar];
            
            //add table
            EmptySlotPopupTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, 320, height-44) style:UITableViewStylePlain];
            EmptySlotPopupTable.dataSource=self;
            EmptySlotPopupTable.delegate=self;
            [timedetailView addSubview:EmptySlotPopupTable];
            
            //add popover controller
            UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
            viewcontroller.view=timedetailView;
            viewcontroller.preferredContentSize=viewcontroller.view.frame.size;
            viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
            myPopoverController=viewcontroller.popoverPresentationController;
            myPopoverController.delegate=self;
            myPopoverController.permittedArrowDirections=UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight;
            CGRect rect=CGRectMake(button.bounds.origin.x+cellwidth/2, button.bounds.origin.y+cellheight/2, 0, 0);
            myPopoverController.sourceView=button;
            myPopoverController.sourceRect=rect;
            
            [self presentViewController:viewcontroller animated:YES completion:nil];

            [EmptySlotPopupTable reloadData];
            

        }

    }
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    return YES;
}


-(void) drawInstructorLegend
{
    [legendscrollview.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    instructorLabel=[[UILabel alloc]init];

    for (int i=0;i<InstructorNameArray.count; i++) {
        instructorLabel=[[UILabel alloc]initWithFrame:CGRectMake(instructorLabel.frame.size.width+instructorLabel.frame.origin.x, 0, 200, 29)];
        instructorLabel.textAlignment=NSTextAlignmentCenter;
        [instructorLabel setFont:[UIFont boldSystemFontOfSize:10]];
        instructorLabel.text=[[InstructorNameArray objectAtIndex:i] isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:[InstructorNameArray objectAtIndex:i] firstorfullname:@"full"];
        [instructorLabel sizeToFit];
        instructorLabel.frame=CGRectMake(instructorLabel.frame.origin.x, 0, instructorLabel.frame.size.width+10, 29);
        instructorLabel.backgroundColor=[self returninstructorcolor:[InstructorNameArray objectAtIndex:i]];
        [legendscrollview addSubview:instructorLabel];
        UIButton *button=[[UIButton alloc]initWithFrame:instructorLabel.frame];
        [button addTarget:self action:@selector(legendbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        [legendscrollview addSubview:button];
    }
    
    if (instructorLabel.frame.origin.x+instructorLabel.frame.size.width<legendscrollview.frame.size.width) {
        float ratio=legendscrollview.frame.size.width/(instructorLabel.frame.origin.x+instructorLabel.frame.size.width);
        [legendscrollview.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        instructorLabel=[[UILabel alloc]init];
        for (int i=0;i<InstructorNameArray.count; i++) {
            instructorLabel=[[UILabel alloc]initWithFrame:CGRectMake(instructorLabel.frame.size.width+instructorLabel.frame.origin.x, 0, 200, 29)];
            instructorLabel.textAlignment=NSTextAlignmentCenter;
            [instructorLabel setFont:[UIFont boldSystemFontOfSize:10]];
            instructorLabel.text=[[InstructorNameArray objectAtIndex:i] isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:[InstructorNameArray objectAtIndex:i] firstorfullname:@"full"];
            [instructorLabel sizeToFit];
            instructorLabel.frame=CGRectMake(instructorLabel.frame.origin.x, 0, (instructorLabel.frame.size.width+10)*ratio, 29);
            instructorLabel.backgroundColor=[self returninstructorcolor:[InstructorNameArray objectAtIndex:i]];
            [legendscrollview addSubview:instructorLabel];
            UIButton *button=[[UIButton alloc]initWithFrame:instructorLabel.frame];
            [button addTarget:self action:@selector(legendbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=i;
            [legendscrollview addSubview:button];
        }
    }
    
    legendscrollview.contentSize=CGSizeMake(instructorLabel.frame.origin.x+instructorLabel.frame.size.width, 29);
    
}

-(void) drawClassroomLegend
{
    [legendscrollview.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    classroomLabel=[[UILabel alloc]init];
    for (int i=0;i<ClassroomNameArray.count; i++) {
        classroomLabel=[[UILabel alloc]initWithFrame:CGRectMake(classroomLabel.frame.size.width+classroomLabel.frame.origin.x, 0, 200, 29)];
        classroomLabel.textAlignment=NSTextAlignmentCenter;
        [classroomLabel setFont:[UIFont boldSystemFontOfSize:10]];
        classroomLabel.minimumScaleFactor=0.7;
        classroomLabel.adjustsFontSizeToFitWidth=YES;
        classroomLabel.backgroundColor=[self returnclassroomcolor:[ClassroomNameArray objectAtIndex:i]];
        classroomLabel.text=[[ClassroomNameArray objectAtIndex:i] isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[ClassroomNameArray objectAtIndex:i];
        [classroomLabel sizeToFit];
        classroomLabel.frame=CGRectMake(classroomLabel.frame.origin.x, 0, classroomLabel.frame.size.width+10, 29);
        [legendscrollview addSubview:classroomLabel];
        UIButton *button=[[UIButton alloc]initWithFrame:classroomLabel.frame];
        [button addTarget:self action:@selector(legendbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        [legendscrollview addSubview:button];
    }
    
    if (classroomLabel.frame.origin.x+classroomLabel.frame.size.width<legendscrollview.frame.size.width) {
        float ratio=legendscrollview.frame.size.width/(classroomLabel.frame.origin.x+classroomLabel.frame.size.width);
        [legendscrollview.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        classroomLabel=[[UILabel alloc]init];
        for (int i=0;i<ClassroomNameArray.count; i++) {
            classroomLabel=[[UILabel alloc]initWithFrame:CGRectMake(classroomLabel.frame.size.width+classroomLabel.frame.origin.x, 0, 200, 29)];
            classroomLabel.textAlignment=NSTextAlignmentCenter;
            [classroomLabel setFont:[UIFont boldSystemFontOfSize:10]];
            classroomLabel.minimumScaleFactor=0.7;
            classroomLabel.adjustsFontSizeToFitWidth=YES;
            classroomLabel.backgroundColor=[self returnclassroomcolor:[ClassroomNameArray objectAtIndex:i]];
            classroomLabel.text=[[ClassroomNameArray objectAtIndex:i] isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[ClassroomNameArray objectAtIndex:i];
            [classroomLabel sizeToFit];
            classroomLabel.frame=CGRectMake(classroomLabel.frame.origin.x, 0, (classroomLabel.frame.size.width+10)*ratio, 29);
            [legendscrollview addSubview:classroomLabel];
            UIButton *button=[[UIButton alloc]initWithFrame:classroomLabel.frame];
            [button addTarget:self action:@selector(legendbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=i;
            [legendscrollview addSubview:button];
        }
    }
    
    
    legendscrollview.contentSize=CGSizeMake(classroomLabel.frame.origin.x+classroomLabel.frame.size.width, 29);
}

-(void) drawSubjectLegend
{
    [legendscrollview.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    classroomLabel=[[UILabel alloc]init];
    for (int i=0;i<SubjectNameArray.count; i++) {
        classroomLabel=[[UILabel alloc]initWithFrame:CGRectMake(classroomLabel.frame.size.width+classroomLabel.frame.origin.x, 0, 200, 29)];
        classroomLabel.textAlignment=NSTextAlignmentCenter;
        [classroomLabel setFont:[UIFont boldSystemFontOfSize:10]];
        classroomLabel.numberOfLines=0;
        classroomLabel.minimumScaleFactor=0.7;
        classroomLabel.adjustsFontSizeToFitWidth=YES;
        
        NSMutableDictionary *subjectdict=[SubjectNameArray objectAtIndex:i];
        if([[subjectdict valueForKey:@"subjecttype"] isEqualToString:@"subject"]){
            SubjectRecord *object=[MyClass returnsubjectinformationwithsubject_shortname:[subjectdict valueForKey:@"subject"] centerkey:globalvariables.centerrecord.centerkey];
//            [MyClass setButtonWithButton:classroomLabel title:[MyClass returnsubjectnamewithsubject_shortname:object.subject_shortname centerkey:globalvariables.centerrecord.centerkey] titleColor:[NSColor controlTextColor] backgroundColor:[globalvariables.colorcodearray objectAtIndex:object.colorcode]];
            classroomLabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:object.colorcode];
            classroomLabel.text=[MyClass returnsubjectnamewithsubject_shortname:object.subject_shortname centerkey:globalvariables.centerrecord.centerkey];
        }else{
            SubjectCategoryRecord *object=[MyClass returnsubjectcategorywithscategorykey:[subjectdict valueForKey:@"subject"]];
//            [MyClass setButtonWithButton:classroomLabel title:[MyClass returnsubjectcategorynamewithscategorykey:object.scategorykey] titleColor:[NSColor controlTextColor] backgroundColor:[globalvariables.colorcodearray objectAtIndex:object.colorcode]];
            classroomLabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:object.colorcode];
            classroomLabel.text=[MyClass returnsubjectcategorynamewithscategorykey:object.scategorykey];
        }
        
        

        [classroomLabel sizeToFit];
        classroomLabel.frame=CGRectMake(classroomLabel.frame.origin.x, 0, classroomLabel.frame.size.width+10, 29);
        [legendscrollview addSubview:classroomLabel];
        UIButton *button=[[UIButton alloc]initWithFrame:classroomLabel.frame];
        [button addTarget:self action:@selector(legendbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        [legendscrollview addSubview:button];
    }
    
    if (classroomLabel.frame.origin.x+classroomLabel.frame.size.width<legendscrollview.frame.size.width) {
        float ratio=legendscrollview.frame.size.width/(classroomLabel.frame.origin.x+classroomLabel.frame.size.width);
        [legendscrollview.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
        classroomLabel=[[UILabel alloc]init];
        for (int i=0;i<SubjectNameArray.count; i++) {
            classroomLabel=[[UILabel alloc]initWithFrame:CGRectMake(classroomLabel.frame.size.width+classroomLabel.frame.origin.x, 0, 200, 29)];
            classroomLabel.textAlignment=NSTextAlignmentCenter;
            [classroomLabel setFont:[UIFont boldSystemFontOfSize:10]];
            classroomLabel.numberOfLines=0;
            classroomLabel.minimumScaleFactor=0.7;
            classroomLabel.adjustsFontSizeToFitWidth=YES;
            
            NSMutableDictionary *subjectdict=[SubjectNameArray objectAtIndex:i];
            if([[subjectdict valueForKey:@"subjecttype"] isEqualToString:@"subject"]){
                SubjectRecord *object=[MyClass returnsubjectinformationwithsubject_shortname:[subjectdict valueForKey:@"subject"] centerkey:globalvariables.centerrecord.centerkey];
                classroomLabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:object.colorcode];
                classroomLabel.text=[MyClass returnsubjectnamewithsubject_shortname:object.subject_shortname centerkey:globalvariables.centerrecord.centerkey];
            }else{
                SubjectCategoryRecord *object=[MyClass returnsubjectcategorywithscategorykey:[subjectdict valueForKey:@"subject"]];
                classroomLabel.backgroundColor=[globalvariables.colorcodearray objectAtIndex:object.colorcode];
                classroomLabel.text=[MyClass returnsubjectcategorynamewithscategorykey:object.scategorykey];
            }

            
            [classroomLabel sizeToFit];
            classroomLabel.frame=CGRectMake(classroomLabel.frame.origin.x, 0, (classroomLabel.frame.size.width+10)*ratio, 29);
            [legendscrollview addSubview:classroomLabel];
            UIButton *button=[[UIButton alloc]initWithFrame:classroomLabel.frame];
            [button addTarget:self action:@selector(legendbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            button.tag=i;
            [legendscrollview addSubview:button];
        }
    }
    
    legendscrollview.contentSize=CGSizeMake(classroomLabel.frame.origin.x+classroomLabel.frame.size.width, 29);
}

-(void) legendbuttonpressed:(UIButton *)sender
{
    NSInteger colorcode;
    BOOL editable;
    if ([contentmode isEqualToString:@"Instructor"]) {
        colorcode=((Staff *)[MyClass returnstaffrecordwithusername:[InstructorNameArray objectAtIndex:sender.tag]]).colorcode;
        editable=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).edittimetableinstructorcolor;
    }else if ([contentmode isEqualToString:@"Classroom"]){
        colorcode=((ClassroomRecord *)[MyClass returnclassroominformationwithclassroom:[ClassroomNameArray objectAtIndex:sender.tag] centerkey:globalvariables.centerrecord.centerkey]).colorcode;
        editable=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).edittimetableclassroomcolor;
    }else{
        NSDictionary *dict=[SubjectNameArray objectAtIndex:sender.tag];
        if([[dict valueForKey:@"subjecttype"] isEqualToString:@"subject"]){
            colorcode=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:[dict valueForKey:@"subject"] centerkey:globalvariables.centerrecord.centerkey]).colorcode;
        }else{
            colorcode=((SubjectCategoryRecord *)[MyClass returnsubjectcategorywithscategorykey:[dict valueForKey:@"subject"]]).colorcode;
        }
        editable=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).edittimetablesubjectcolor;
    }
    
    if(editable){
        [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:[@(colorcode) stringValue], nil] DataType:@"colorcode" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(100, 600) View:self Button:sender ItemsArray:nil Title:nil];
    }
}



- (void)doubleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    if (TabArray.count>0) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        
        NSArray *lastClassDayarray;
        
        NSString *lastselecteddate=globalselecteddate;
        lastClassDayarray=[[NSArray alloc]initWithArray:classDay];
        NSDate *pastMonday;
        
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:now];
        
        NSUInteger weekdayToday = [components weekday];
        NSInteger daysToMonday=weekdayToday-[MyClass returndayofweeknumber:[globalvariables.centerdayofweekarray objectAtIndex:0]];
        pastMonday = [now dateByAddingTimeInterval:60*60*24*(-daysToMonday)];
        
        globalselecteddate=[MyClass convertToNSStringWithNSDate:pastMonday DateFormat:@"dd-MMM-yyyy"];
        tmpselecteddate=[MyClass convertToNSStringWithNSDate:pastMonday DateFormat:@"dd-MMM-yyyy"];
        
        ClassScheduleTableShown=FALSE;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self generateTimeTablewithViewOption:TimeTableMode pastMonday:tmpselecteddate classtype:classtypeselected redrawscoller:YES]) {
                [self updatetabviewpreferencewithoption:@"update" tabid:selectedtabbutton.tag-100000000 headerlist:[selectedHeaderArray componentsJoinedByString:@"/"] mode:@"Weekly" selecteddate:globalselecteddate];
                
            }else{
                globalselecteddate=lastselecteddate;
                classDay=[[NSArray alloc]initWithArray:lastClassDayarray];
            }
        });
    }
}

//- (void)scrollingFinish {
//    ClassScheduleTableShown=FALSE;
//
//    if (![lastselectdate isEqualToString:globalselecteddate]) {
//        tmpselecteddate=globalselecteddate;
//
//        if (![globalselecteddate isEqualToString:lastselectdate]) {
//            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
//
//            ClassScheduleTableShown=FALSE;
//
//
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                if ([self generateTimeTablewithViewOption:TimeTableMode pastMonday:tmpselecteddate classtype:classtypeselected redrawscoller:YES]) {
//
//                    [self updatetabviewpreferencewithoption:@"update" tabid:selectedtabbutton.tag-100000000 headerlist:[selectedHeaderArray componentsJoinedByString:@"/"] mode:@"Weekly" selecteddate:globalselecteddate];
//
//                }else{
//                    globalselecteddate=lastselectdate;
//                    [self generatedatescrollerwithpastmonday:globalselecteddate redraw:YES];
//                }
//                [MyClass loadingindicatorwithoption:@"stop" color:nil];
//            });
//        }
//    }
//}


- (void)cancelselection:(id)sender {
    [self.delegate cancelselection];
    
}



-(void) loaddatebar
{
    CGFloat xpos=[self returnclasstimewidth];
    datebartable.frame=CGRectMake(xpos, superviewclearence, self.view.bounds.size.width-xpos,66);
    [datebartable reloadData];
    
    
}

-(CGFloat) returnclasstimewidth
{
    if (detailViewMode) {
        float sum = [[headerWidthArray lastObject] floatValue]+[[headerPositionArray lastObject] floatValue];
        if (sum==0) {
            return classtimewidth;
        }else{
            if (sum*mincellwidthfordetailview>timetablewidth) {
                return classtimewidth;
            }else{
//                NSLog(@"timewidth-%f",self.view.bounds.size.width);
                return self.view.bounds.size.width-sum*(timetablewidth/sum);//  [(int)(timetablewidth/sum)*sum floatValue];
            }
        }
    }else{
        if (self.view.bounds.size.width>cellwidth*totalSubjectColumn+classtimewidth) {
            return self.view.bounds.size.width-cellwidth*totalSubjectColumn;
        }else{
            return classtimewidth;
        }
    }
}


-(void) generatedatescrollerwithpastmonday:(NSString *)pastmonday redraw:(BOOL)redraw
{
    if ([pastmonday isEqualToString:@""]) {
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:now];
        NSUInteger weekdayToday = [components weekday];
        NSInteger daysToMonday=weekdayToday-[MyClass returndayofweeknumber:[globalvariables.centerdayofweekarray objectAtIndex:0]];
        NSDate *pastMonday = [now dateByAddingTimeInterval:60*60*24*(-daysToMonday)];
        tmpselecteddate=[MyClass convertToNSStringWithNSDate:pastMonday DateFormat:@"dd-MMM-yyyy"];
    }else{
        tmpselecteddate=pastmonday;
    }
    
    if (redraw ==YES) {
        [self loaddatebar];
    }
}

- (void)selectview:(UISegmentedControl *)sender {
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    ClassScheduleTableShown=FALSE;
    
    if (sender.selectedSegmentIndex==0) {
        //dailyweeklyviewselected=@"Weekly";
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self generateTimeTablewithViewOption:@"Consolidated" pastMonday:@"" classtype:@"All" redrawscoller:YES]){
                TimeTableMode=@"Consolidated";
                [self generatedatescrollerwithpastmonday:globalselecteddate redraw:YES];
                //[supermasterview sendSubviewToBack:datebartable];
                classtypeselected=@"All";
                [ClassTypeSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Class Types"] forState:UIControlStateNormal];
                ClassTypeArray=[[NSMutableArray alloc]initWithObjects:@"All Class Types",@"Class",@"Makeup", nil];
                calendarbutton.enabled=!weeklyMode;
            }else{
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                sender.selectedSegmentIndex=1;
            }
        });
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            globalselecteddate=[self findfirstdayofweeklyview:globalselecteddate];
            if(!weeklyMode){
                if(!dailydateselected){
                    dailydateselected=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"];
                }
                NSString *dayofweek=[MyClass convertDateFormatWithDate:dailydateselected FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE" Translate:NO];
                globalvariables.centerdayofweekarray=[[NSMutableArray alloc]initWithObjects:dayofweek, nil];
            }
            if ([self generateTimeTablewithViewOption:@"Weekly" pastMonday:globalselecteddate classtype:classtypeselected redrawscoller:YES]) {
                TimeTableMode=@"Weekly";
                [self generatedatescrollerwithpastmonday:globalselecteddate redraw:YES];
                //[supermasterview bringSubviewToFront:datebartable];
                ClassTypeArray=[[NSMutableArray alloc]initWithObjects:@"All Class Types",@"Attending",@"Class",@"Makeup",@"Assessment",@"Trial", nil];
                calendarbutton.enabled=TRUE;
            }else{
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                sender.selectedSegmentIndex=0;
            }
        });
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==FreeScheduleTable) {
        return FreeScheduleClassArray.count*2;

    }else if (tableView==ClassSelectionTable){
        return headerArray.count;
    }else if (tableView==ClassTypeSelectionTable){
        return ClassTypeArray.count;
    }else if (tableView==datebartable){
        return classDay.count;
    }else if (tableView==EmptySlotPopupTable){
        return 3;
    }else if (tableView==ClassDetailTable){
        //if (ClassScheduleRecordArray.count>0) {
            return ClassScheduleRecordArray.count;
        /*}else{
            return 3;
        }*/
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
    
    
    if (tableView==FreeScheduleTable) {
        FreeScheduleClassObject=[FreeScheduleClassArray objectAtIndex:(int)(indexPath.row/2)];
        
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
            //add textfield
            
            FreeScheduleDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 120, 35)];
            FreeScheduleDateLabel.font=[UIFont systemFontOfSize:13];
            FreeScheduleDateLabel.textColor=[UIColor darkGrayColor];
            FreeScheduleDateLabel.tag=901;
            [cell.contentView addSubview:FreeScheduleDateLabel];
            
            FreeScheduleDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(115, 0, 60, 35)];
            FreeScheduleDayLabel.font=[UIFont systemFontOfSize:13];
            if (indexPath.row==selectedfreeclassrow) {
                FreeScheduleDayLabel.textColor=[UIColor blueColor];
            }else{
                FreeScheduleDayLabel.textColor=[UIColor darkGrayColor];
            }
            FreeScheduleDayLabel.tag=902;
            [cell.contentView addSubview:FreeScheduleDayLabel];
            
            FreeScheduleClassTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(170, 0, 100, 35)];
            FreeScheduleClassTimeLabel.font=[UIFont systemFontOfSize:13];
            FreeScheduleClassTimeLabel.textColor=[UIColor darkGrayColor];
            
            FreeScheduleClassTimeLabel.tag=903;
            [cell.contentView addSubview:FreeScheduleClassTimeLabel];
            
            FreeScheduleInstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 0, 190, 35)];
            FreeScheduleInstructorLabel.font=[UIFont systemFontOfSize:13];
            FreeScheduleInstructorLabel.textColor=[UIColor darkGrayColor];
            FreeScheduleInstructorLabel.minimumScaleFactor=0.7;
            FreeScheduleInstructorLabel.adjustsFontSizeToFitWidth=YES;
            FreeScheduleInstructorLabel.textAlignment=NSTextAlignmentRight;
            FreeScheduleInstructorLabel.tag=904;
            [cell.contentView addSubview:FreeScheduleInstructorLabel];
            
            myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, freescheduletablewidth, 150)];
            [myPicker setDataSource:self];
            [myPicker setDelegate:self];
            myPicker.tag=802;
            
            
            [myPicker setShowsSelectionIndicator:YES];
            
            [cell.contentView addSubview:myPicker];
            
            FreeScheduleInstructorImageButton=[[UIButton alloc]init];
            //FreeScheduleInstructorImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            FreeScheduleInstructorImageButton.frame=CGRectMake(5, 120, 30, 30);
            [FreeScheduleInstructorImageButton setImage:[UIImage imageNamed:@"instructoricon.png"] forState:UIControlStateNormal];
            [FreeScheduleInstructorImageButton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
            [FreeScheduleInstructorImageButton addTarget: self action:@selector(InstructorButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
            [cell.contentView addSubview:FreeScheduleInstructorImageButton];
            
            
        }else{
            FreeScheduleDateLabel=(UILabel *)[cell.contentView viewWithTag:901];
            FreeScheduleDayLabel=(UILabel *)[cell.contentView viewWithTag:902];
            FreeScheduleClassTimeLabel=(UILabel *)[cell.contentView viewWithTag:903];
            FreeScheduleInstructorLabel=(UILabel *)[cell.contentView viewWithTag:904];
            
            if (indexPath.row==selectedfreeclassrow) {
                FreeScheduleDateLabel.textColor=[UIColor blueColor];
                FreeScheduleDayLabel.textColor=[UIColor blueColor];
                FreeScheduleClassTimeLabel.textColor=[UIColor blueColor];
                FreeScheduleInstructorLabel.textColor=[UIColor blueColor];
            }else{
                FreeScheduleDateLabel.textColor=[UIColor darkGrayColor];
                FreeScheduleDayLabel.textColor=[UIColor darkGrayColor];
                FreeScheduleClassTimeLabel.textColor=[UIColor darkGrayColor];
                FreeScheduleInstructorLabel.textColor=[UIColor darkGrayColor];
            }
            
            myPicker=(UIPickerView *)[cell.contentView viewWithTag:802];

        }

        // Configure the cell...
        if (indexPath.row%2==0) {
            FreeScheduleDateLabel.text=[MyClass returndateformatwithdate:FreeScheduleClassObject.classdate];
            FreeScheduleClassTimeLabel.text=[MyClass returntitlewithtitle:FreeScheduleClassObject.classtime];
            FreeScheduleInstructorLabel.text=[FreeScheduleClassObject.instructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]: [MyClass returninstructornamewithusername:FreeScheduleClassObject.instructor firstorfullname:@"full"];
            
            if (![FreeScheduleClassObject.classdate isEqualToString:@"TBD"]) {
                FreeScheduleDayLabel.text=[MyClass returndateformatEEEwithdate:[MyClass convertDateFormatWithDate:FreeScheduleClassObject.classdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE"]];
            }else{
                FreeScheduleDayLabel.text=@"";
            }
            FreeScheduleDateLabel.hidden=NO;
            FreeScheduleDayLabel.hidden=NO;
            FreeScheduleClassTimeLabel.hidden=NO;
            FreeScheduleInstructorLabel.hidden=NO;
            FreeScheduleInstructorImageButton.hidden=YES;
            myPicker.hidden=YES;
            
            cell.selectionStyle=UITableViewCellSelectionStyleDefault;
            
        }else{
            if (indexPath.row-1==selectedfreeclassrow) {
                [myPicker selectRow:[MyClass returnInstructorIndexWithInstructorArray:AvailableInstructorNameArray username:FreeScheduleClassObject.instructor activeinstructor:NO defaultzeroifnotfound:YES] inComponent:0 animated:NO];
            }
            FreeScheduleDateLabel.hidden=YES;
            FreeScheduleDayLabel.hidden=YES;
            FreeScheduleClassTimeLabel.hidden=YES;
            FreeScheduleInstructorLabel.hidden=YES;
            FreeScheduleInstructorImageButton.hidden=NO;
            myPicker.hidden=NO;
            
            cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        }

        if ([FreeScheduleClassObject.action isEqualToString:@"Delete"]) {
            cell.hidden=YES;
        }else if(indexPath.row % 2==1){
            if (indexPath.row-1 !=selectedfreeclassrow) {
                cell.hidden=YES;
            }else{
                cell.hidden=NO;
            }
        }else{
            cell.hidden=NO;
        }
    }else if (tableView==ClassSelectionTable){

        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *namelabel;
        UILabel *codelabel;
        UIImageView *selectionimage;
        
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            
            namelabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 7, classselectiontablewidth-95-70, 21)];
            namelabel.font=[UIFont systemFontOfSize:15];
            namelabel.textColor=[UIColor darkGrayColor];
            namelabel.textAlignment=NSTextAlignmentLeft;
            namelabel.adjustsFontSizeToFitWidth=YES;
            namelabel.minimumScaleFactor=0.7;
            namelabel.tag=501;
            [cell.contentView addSubview:namelabel];
            
            codelabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 70, 21)];
            codelabel.font=[UIFont systemFontOfSize:15];
            codelabel.textColor=[UIColor darkGrayColor];
            codelabel.textAlignment=NSTextAlignmentLeft;
            codelabel.adjustsFontSizeToFitWidth=YES;
            codelabel.minimumScaleFactor=0.5;
            codelabel.tag=502;
            [cell.contentView addSubview:codelabel];
            
            
            selectionimage=[[UIImageView alloc]initWithFrame:CGRectMake(classselectiontablewidth-50, 5, 25, 25)];
            [selectionimage setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selectionimage.tag=503;
            [cell.contentView addSubview:selectionimage];
        }else{
            namelabel=(UILabel *)[cell.contentView viewWithTag:501];
            codelabel=(UILabel *)[cell.contentView viewWithTag:502];
            selectionimage=(UIImageView *)[cell.contentView viewWithTag:503];
        }
        
        if ([headertype isEqualToString:@"Subject"]) {
            namelabel.frame=CGRectMake(95, 7, classselectiontablewidth-95-70, 21);
            codelabel.hidden=NO;
            
            if ([globalvariables.language isEqualToString:@"English"]) {
                namelabel.text=((SubjectRecord *)[headerArray objectAtIndex:indexPath.row]).subject_englishname;
            }else{
                namelabel.text=((SubjectRecord *)[headerArray objectAtIndex:indexPath.row]).subject_chinesename;
            }
            
            codelabel.text=((SubjectRecord *)[headerArray objectAtIndex:indexPath.row]).subject_shortname;
            
            
            if (![selectedHeaderArray containsObject:((SubjectRecord *)[headerArray objectAtIndex:indexPath.row]).subject_shortname]) {
                selectionimage.layer.opacity=0.3;
            }else{
                selectionimage.layer.opacity=1;
            }
        }else if ([headertype isEqualToString:@"Classroom"]){
            namelabel.frame=CGRectMake(20, 7, classselectiontablewidth-20-70, 21);
            codelabel.hidden=YES;
            
            namelabel.text=((ClassroomRecord *)[headerArray objectAtIndex:indexPath.row]).classroom;
            
            if (![selectedHeaderArray containsObject:((ClassroomRecord *)[headerArray objectAtIndex:indexPath.row]).classroom]) {
                selectionimage.layer.opacity=0.3;
            }else{
                selectionimage.layer.opacity=1;
            }
        }else if ([headertype isEqualToString:@"Instructor"]){
            namelabel.frame=CGRectMake(20, 7, classselectiontablewidth-20-70, 21);
            codelabel.hidden=YES;
            
            namelabel.text=[MyClass returnstaffnamewithusername:((Staff *)[headerArray objectAtIndex:indexPath.row]).username firstorfullname:@"full"];
            
            if (![selectedHeaderArray containsObject:((Staff *)[headerArray objectAtIndex:indexPath.row]).username]) {
                selectionimage.layer.opacity=0.3;
            }else{
                selectionimage.layer.opacity=1;
            }
        }

        
        return cell;
    
    
    }else if(tableView==ClassTypeSelectionTable){
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
    }else if (tableView==datebartable){
        
        UIView *header_view;
        UILabel *consolidate_classdaylabel;
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            datebardatelabel = [[UILabel alloc]init];
            datebardatelabel.font=[UIFont boldSystemFontOfSize:13];
            datebardatelabel.textColor=[UIColor whiteColor];
            datebardatelabel.adjustsFontSizeToFitWidth=YES;
            datebardatelabel.backgroundColor=[UIColor grayColor];
            datebardatelabel.layer.borderColor=[UIColor darkGrayColor].CGColor;
            datebardatelabel.layer.borderWidth=0.5;
            datebardatelabel.tag=301;
            datebardatelabel.transform = CGAffineTransformMakeRotation(M_PI_2);
            datebardatelabel.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:datebardatelabel];
            
            
            datebardaylabel = [[UILabel alloc]init];
            datebardaylabel.font=[UIFont systemFontOfSize:12];
            datebardaylabel.textColor=[UIColor whiteColor];
            datebardaylabel.adjustsFontSizeToFitWidth=YES;
            datebardaylabel.backgroundColor=[UIColor grayColor];
            datebardaylabel.layer.borderColor=[UIColor darkGrayColor].CGColor;
            datebardaylabel.layer.borderWidth=0.5;
            datebardaylabel.tag=302;
            datebardaylabel.transform = CGAffineTransformMakeRotation(M_PI_2);
            datebardaylabel.textAlignment=NSTextAlignmentCenter;
            [cell.contentView addSubview:datebardaylabel];
            
            header_view=[[UIView alloc]init];
            header_view.tag=303;
            header_view.transform = CGAffineTransformMakeRotation(M_PI_2);
            [cell.contentView addSubview:header_view];

            consolidate_classdaylabel=[[UILabel alloc]init];
            consolidate_classdaylabel.transform = CGAffineTransformMakeRotation(M_PI_2);
            consolidate_classdaylabel.textAlignment=NSTextAlignmentCenter;
            [consolidate_classdaylabel setFont:[UIFont boldSystemFontOfSize:14]];
            consolidate_classdaylabel.layer.borderColor=[UIColor darkGrayColor].CGColor;
            consolidate_classdaylabel.layer.borderWidth=0.5;
            consolidate_classdaylabel.tag=304;
            consolidate_classdaylabel.backgroundColor=[UIColor grayColor];
            consolidate_classdaylabel.textColor=[UIColor whiteColor];
            [cell.contentView addSubview:consolidate_classdaylabel];
            

            
        }else{
            datebardatelabel=(UILabel *)[cell.contentView viewWithTag:301];
            datebardaylabel=(UILabel *)[cell.contentView viewWithTag:302];
            header_view=(UIView *)[cell.contentView viewWithTag:303];
            consolidate_classdaylabel=(UILabel *)[cell.contentView viewWithTag:304];
        }
        
        // Configure the cell...
        
        CGRect cellRect = [tableView rectForRowAtIndexPath:indexPath];
        
        if (cellRect.size.height>0 && (!detailViewMode || (detailViewMode && headerWidthArray.count>0))) {
            
            header_view.frame=CGRectMake(0, 0, 26,cellRect.size.height);
            [[header_view subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
            
            float xpos=0;
            float width=0;
            UILabel *label;
            for (int i=0; i<filteredHeaderArray.count; i++) {
                
                if (detailViewMode) {
                    width=[[headerWidthArray objectAtIndex:(indexPath.row*filteredHeaderArray.count+i)] floatValue]*cellwidthfordetailview;
                    label=[[UILabel alloc]initWithFrame:CGRectMake(xpos, 0, width, 26)];
                    xpos+=width;
                }else{
                    label=[[UILabel alloc]initWithFrame:CGRectMake(cellwidth*i, 0, cellwidth, 26)];
                }
                
                
                if ([headertype isEqualToString:@"Instructor"]) {
                    label.text=[MyClass returnstaffnamewithusername:[filteredHeaderArray objectAtIndex:i] firstorfullname:@"first"];
                }else if ([headertype isEqualToString:@"Subject"]) {
                    //if no subject record found, switch to show category
                    SubjectRecord *object=[MyClass returnsubjectinformationwithsubject_shortname:[filteredHeaderArray objectAtIndex:i] centerkey:globalvariables.centerrecord.centerkey];
                    if(object){
                        label.text=[MyClass returnsubjectnamewithsubject_shortname:[filteredHeaderArray objectAtIndex:i] centerkey:globalvariables.centerrecord.centerkey];
                    }else{
                        SubjectCategoryRecord *object=[MyClass returnsubjectcategorywithscategorykey:[filteredHeaderArray objectAtIndex:i]];
                        if(object){
                            label.text=[MyClass returnsubjectcategorynamewithscategorykey:[filteredHeaderArray objectAtIndex:i]];
                        }else{
                            label.text=[filteredHeaderArray objectAtIndex:i];
                        }
                    }
                }else{
                    label.text=[filteredHeaderArray objectAtIndex:i];
                }
                
                label.textAlignment=NSTextAlignmentCenter;
                [label setFont:[UIFont systemFontOfSize:10]];
                label.layer.borderColor=[UIColor darkGrayColor].CGColor;
                label.layer.borderWidth=0.5;
                label.adjustsFontSizeToFitWidth=YES;
                label.minimumScaleFactor=0.8;
                label.numberOfLines=2;
                label.backgroundColor=[UIColor lightGrayColor];
                [header_view addSubview:label];
            }
            
            if ([TimeTableMode isEqualToString:@"Consolidated"]) {
                datebardaylabel.hidden=YES;
                datebardatelabel.hidden=YES;
                consolidate_classdaylabel.hidden=NO;
                
                consolidate_classdaylabel.frame=CGRectMake(26, 0, 40,cellRect.size.height);
                consolidate_classdaylabel.text=[MyClass returndateformatEEEwithdate:[classDay objectAtIndex:indexPath.row]];
            }else{
                consolidate_classdaylabel.hidden=YES;
                datebardaylabel.hidden=NO;
                datebardatelabel.hidden=NO;
                
                
                datebardatelabel.frame=CGRectMake(26, 0, 20,cellRect.size.height);
                datebardaylabel.frame=CGRectMake(46, 0, 20,cellRect.size.height);

//                datebardatelabel.text=[MyClass returndateformatwithdate:[MyClass convertDDMMMYYYYtoDDMMMYYYY2withdate:]];
                datebardatelabel.text=[MyClass convertDateFormatWithDate:[MyClass returnDateFromBaseDateWithOffset:([allClassDay indexOfObject:[classDay objectAtIndex:indexPath.row]]/*-[allClassDay indexOfObject:[classDay objectAtIndex:0]]*/+[MyClass returnDateOffsetWithDate:[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyy"]])] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:cellRect.size.height<100?@"dd":@"dd-MMM-yyyy" Translate:YES];
                datebardaylabel.text=[MyClass returndateformatEEEwithDDMMMYYYYdate:[MyClass returnDateFromBaseDateWithOffset:([allClassDay indexOfObject:[classDay objectAtIndex:indexPath.row]]/*-[allClassDay indexOfObject:[classDay objectAtIndex:0]]*/+[MyClass returnDateOffsetWithDate:[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyy"]])]];

                datebartodaylabel.text=datebardatelabel.text;
                

                NSString *datestring=[MyClass returnDateFromBaseDateWithOffset:([allClassDay indexOfObject:[classDay objectAtIndex:indexPath.row]]/*-[allClassDay indexOfObject:[classDay objectAtIndex:0]]*/+[MyClass returnDateOffsetWithDate:[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyy"]])];
                NSString *centerday=[globalvariables.centerdaydictionary objectForKey:[NSString stringWithFormat:@"%@#%@",[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:datestring],globalvariables.centerrecord.centerkey]];
                
                if ([[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] isEqualToString:datestring]) {
                    datebardatelabel.textColor=[UIColor blueColor];
                    datebardaylabel.textColor=[UIColor blueColor];
                    datebardatelabel.highlightedTextColor=[UIColor blueColor];
                    datebardaylabel.highlightedTextColor=[UIColor blueColor];
                }else if ([centerday isEqualToString:@"H"]){
                    datebardatelabel.textColor=[UIColor colorWithRed:176.0/255.0 green:36.0/255.0 blue:34.0/255.0 alpha:1.0];
                    datebardaylabel.textColor=[UIColor colorWithRed:176.0/255.0 green:36.0/255.0 blue:34.0/255.0 alpha:1.0];
                    datebardatelabel.highlightedTextColor=[UIColor colorWithRed:255.0/255.0 green:140.0/255.0 blue:0.0/255.0 alpha:1.0];
                    datebardaylabel.highlightedTextColor=[UIColor colorWithRed:255.0/255.0 green:140.0/255.0 blue:0.0/255.0 alpha:1.0];
                }else if ([centerday isEqualToString:@"R"]){
                    datebardatelabel.textColor=[UIColor colorWithRed:255.0/255.0 green:140.0/255.0 blue:0.0/255.0 alpha:1.0];
                    datebardaylabel.textColor=[UIColor colorWithRed:255.0/255.0 green:140.0/255.0 blue:0.0/255.0 alpha:1.0];
                    datebardatelabel.highlightedTextColor=[UIColor colorWithRed:255.0/255.0 green:140.0/255.0 blue:0.0/255.0 alpha:1.0];
                    datebardaylabel.highlightedTextColor=[UIColor colorWithRed:255.0/255.0 green:140.0/255.0 blue:0.0/255.0 alpha:1.0];
                }else{
                    datebardatelabel.textColor=[UIColor whiteColor];
                    datebardaylabel.textColor=[UIColor whiteColor];
                    datebardatelabel.highlightedTextColor=[UIColor darkGrayColor];
                    datebardaylabel.highlightedTextColor=[UIColor darkGrayColor];
                }
            }
            
            
            cell.hidden=NO;
        }else{
            cell.hidden=YES;
        }
        

        
        cell.backgroundColor=[UIColor lightGrayColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }else if (tableView==ClassDetailTable) {
        ClassScheduleRecordObject=[[ClassScheduleRecord alloc]init];
        ClassScheduleRecordObject = [ClassScheduleRecordArray objectAtIndex:indexPath.row];
        UILabel *SubjectLabel;
        
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            //add textfield
            
            ClassAttendanceImage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5.5, 14, 14)];
            ClassAttendanceImage.tag=116;
            [cell.contentView addSubview:ClassAttendanceImage];
            
            StartTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 60, 25)];
            StartTimeLabel.font=[UIFont systemFontOfSize:12];
            StartTimeLabel.textColor=[UIColor systemGroupedBackgroundColor];
            StartTimeLabel.tag=101;
            [cell.contentView addSubview:StartTimeLabel];
            
            ClassDurationLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_masterview_duration.frame.origin.x, 0, 120,25)];
            ClassDurationLabel.font=[UIFont systemFontOfSize:12];
            ClassDurationLabel.textColor=[UIColor systemGroupedBackgroundColor];
            ClassDurationLabel.tag=113;
            [cell.contentView addSubview:ClassDurationLabel];
          
            
            SubjectLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_masterview_subject.frame.origin.x, 0, title_masterview_subject.frame.size.width-10, 25)];
            SubjectLabel.font=[UIFont systemFontOfSize:12];
            SubjectLabel.textColor=[UIColor systemGroupedBackgroundColor];
            SubjectLabel.tag=100;
            [cell.contentView addSubview:SubjectLabel];
            
            
            ClassTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_masterview_type.frame.origin.x, 0, title_masterview_type.frame.size.width-10, 25)];
            ClassTypeLabel.font=[UIFont systemFontOfSize:12];
            ClassTypeLabel.textColor=[UIColor systemGroupedBackgroundColor];
            ClassTypeLabel.tag=102;
            [cell.contentView addSubview:ClassTypeLabel];

            
            
            StudentNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_masterview_student.frame.origin.x, 0, title_masterview_student.frame.size.width-10, 25)];
            StudentNameLabel.font=[UIFont systemFontOfSize:12];
            StudentNameLabel.textColor=[UIColor systemGroupedBackgroundColor];
            StudentNameLabel.minimumScaleFactor=0.7;
            StudentNameLabel.adjustsFontSizeToFitWidth=YES;
            StudentNameLabel.tag=103;
            [cell.contentView addSubview:StudentNameLabel];
            
            AgeLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_masterview_age.frame.origin.x, 0, title_masterview_age.frame.size.width-10, 25)];
            AgeLabel.font=[UIFont systemFontOfSize:11];
            AgeLabel.textColor=[UIColor systemGroupedBackgroundColor];
            AgeLabel.tag=104;
            [cell.contentView addSubview:AgeLabel];
            
            LevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_masterview_level.frame.origin.x, 0, title_masterview_level.frame.size.width-10, 25)];
            LevelLabel.font=[UIFont systemFontOfSize:12];
            LevelLabel.textColor=[UIColor systemGroupedBackgroundColor];
            LevelLabel.minimumScaleFactor=0.5;
            LevelLabel.adjustsFontSizeToFitWidth=YES;
            LevelLabel.tag=106;
            [cell.contentView addSubview:LevelLabel];
            
            InstructorLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_masterview_instructor.frame.origin.x, 0, title_masterview_instructor.frame.size.width-10, 25)];
            InstructorLabel.font=[UIFont systemFontOfSize:12];
            InstructorLabel.textColor=[UIColor systemGroupedBackgroundColor];
            InstructorLabel.tag=105;
            InstructorLabel.minimumScaleFactor=0.7;
            InstructorLabel.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:InstructorLabel];

            
            ClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_masterview_classroom.frame.origin.x, 0, title_masterview_classroom.frame.size.width-10, 25)];
            ClassroomLabel.font=[UIFont systemFontOfSize:12];
            ClassroomLabel.textColor=[UIColor systemGroupedBackgroundColor];
            ClassroomLabel.tag=114;
            ClassroomLabel.minimumScaleFactor=0.7;
            ClassroomLabel.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:ClassroomLabel];
            
            
            RemainingScheduledClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_masterview_outstandingclass.frame.origin.x, 4.5, 16, 16)];
            RemainingScheduledClassLabel.font=[UIFont systemFontOfSize:12];
            RemainingScheduledClassLabel.textColor=[UIColor blackColor];
            RemainingScheduledClassLabel.textAlignment=NSTextAlignmentCenter;
            RemainingScheduledClassLabel.backgroundColor=[UIColor systemGroupedBackgroundColor];
            RemainingScheduledClassLabel.layer.cornerRadius=4;
            RemainingScheduledClassLabel.layer.masksToBounds=YES;
            RemainingScheduledClassLabel.tag=110;
            [cell.contentView addSubview:RemainingScheduledClassLabel];
            
            RemainingTBDClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_masterview_outstandingclass.frame.origin.x+20, 4.5, 16, 16)];
            RemainingTBDClassLabel.font=[UIFont systemFontOfSize:12];
            RemainingTBDClassLabel.textColor=[UIColor blackColor];
            RemainingTBDClassLabel.textAlignment=NSTextAlignmentCenter;
            RemainingTBDClassLabel.backgroundColor=[UIColor systemGroupedBackgroundColor];
            RemainingTBDClassLabel.layer.cornerRadius=4;
            RemainingTBDClassLabel.layer.masksToBounds=YES;
            RemainingTBDClassLabel.tag=111;
            [cell.contentView addSubview:RemainingTBDClassLabel];
            
            RemainingTBDMakeupLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_masterview_outstandingclass.frame.origin.x+40, 4.5, 16, 16)];
            RemainingTBDMakeupLabel.font=[UIFont systemFontOfSize:12];
            RemainingTBDMakeupLabel.textColor=[UIColor blackColor];
            RemainingTBDMakeupLabel.textAlignment=NSTextAlignmentCenter;
            RemainingTBDMakeupLabel.backgroundColor=[UIColor systemGroupedBackgroundColor];
            RemainingTBDMakeupLabel.layer.cornerRadius=4;
            RemainingTBDMakeupLabel.layer.masksToBounds=YES;
            RemainingTBDMakeupLabel.tag=115;
            [cell.contentView addSubview:RemainingTBDMakeupLabel];
            
            OutstandingPaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_masterview_outstandingamount.frame.origin.x, 0, title_masterview_outstandingamount.frame.size.width, 25)];
            OutstandingPaymentLabel.font=[UIFont systemFontOfSize:12];
            OutstandingPaymentLabel.textColor=[UIColor systemGroupedBackgroundColor];
            OutstandingPaymentLabel.textAlignment=NSTextAlignmentRight;
            OutstandingPaymentLabel.tag=112;
            [cell.contentView addSubview:OutstandingPaymentLabel];
            
            

            
            
        }else{
            SubjectLabel=(UILabel *)[cell.contentView viewWithTag:100];
            StartTimeLabel=(UILabel *)[cell.contentView viewWithTag:101];
            ClassTypeLabel=(UILabel *)[cell.contentView viewWithTag:102];
            StudentNameLabel=(UILabel *)[cell.contentView viewWithTag:103];
            AgeLabel=(UILabel *)[cell.contentView viewWithTag:104];
            InstructorLabel=(UILabel *)[cell.contentView viewWithTag:105];
            LevelLabel=(UILabel *)[cell.contentView viewWithTag:106];
            //NextClassAllDayTimeLabel=(UILabel *)[cell.contentView viewWithTag:107];
            ClassDurationLabel=(UILabel *)[cell.contentView viewWithTag:113];
            //LastScheduledClassThisDayTimeLabel=(UILabel *)[cell.contentView viewWithTag:108];
            LastScheduledClassAllDayTimeLabel=(UILabel *)[cell.contentView viewWithTag:109];
            RemainingScheduledClassLabel=(UILabel *)[cell.contentView viewWithTag:110];
            RemainingTBDClassLabel=(UILabel *)[cell.contentView viewWithTag:111];
            RemainingTBDMakeupLabel=(UILabel *)[cell.contentView viewWithTag:115];
            OutstandingPaymentLabel=(UILabel *)[cell.contentView viewWithTag:112];
            ClassroomLabel=(UILabel *)[cell.contentView viewWithTag:114];
            ClassAttendanceImage=(UIImageView *)[cell.contentView viewWithTag:116];
        }
        
        // Configure the cell...
        
        if ([TimeTableMode isEqualToString:@"Consolidated"]) {
            [ClassAttendanceImage setImage:nil];
        }else{
            [ClassAttendanceImage setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:ClassScheduleRecordObject.classtype attendance:ClassScheduleRecordObject.attendance makeupattendance:ClassScheduleRecordObject.makeupattendance]]];
        }
        
        if ([ClassScheduleRecordObject.classtype isEqualToString:@"Assessment"]) {
            ClassTypeLabel.text=[MyClass returntitlewithtitle:@"Assess"];
        }else{
            ClassTypeLabel.text=[MyClass returntitlewithtitle:ClassScheduleRecordObject.classtype];
        }
        
        StartTimeLabel.text=ClassScheduleRecordObject.classtime;
        SubjectLabel.text=[MyClass returnsubjectnamewithsubject_shortname:ClassScheduleRecordObject.subject centerkey:globalvariables.centerrecord.centerkey];
        
        if ([ClassScheduleRecordObject.type isEqualToString:@"student"]) {
            StudentNameLabel.text=[MyClass returnStudentnameWithStudentkey:ClassScheduleRecordObject.studentkey option:@"full"];
        }else{
            StudentNameLabel.text=[MyClass returnLeadnameWithLeadkey:ClassScheduleRecordObject.studentkey option:@"full"];
        }

        ClassroomLabel.text=[ClassScheduleRecordObject.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:ClassScheduleRecordObject.classroom;

        LevelLabel.text=[MyClass returnLevelWithSubject:ClassScheduleRecordObject.subject Levelmain:ClassScheduleRecordObject.levelmain Levelctm:ClassScheduleRecordObject.levelctm];
        /*if ([MyClass isfcbrandwithfcbrandsettings:((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand fcbrand:@"eyelevel"]) {
            if ([ClassScheduleRecordObject.levelctm isEqualToString:@""]) {
                LevelLabel.text=ClassScheduleRecordObject.levelmain;
            }else{
                LevelLabel.text=[NSString stringWithFormat:@"%@/%@",ClassScheduleRecordObject.levelmain,ClassScheduleRecordObject.levelctm];
            }
            
        }else{
            LevelLabel.text=ClassScheduleRecordObject.levelmain;
        }*/

        

        AgeLabel.text=[MyClass returnagewithtype:ClassScheduleRecordObject.type typekey:ClassScheduleRecordObject.studentkey];
        ClassDurationLabel.text=[NSString stringWithFormat:@"%@ %@",ClassScheduleRecordObject.classduration,[MyClass returntitlewithtitle:@"mins"]];
            InstructorLabel.text=[MyClass returninstructornamewithusername:ClassScheduleRecordObject.instructor firstorfullname:@"first"];

        if ([ClassScheduleRecordObject.classtype isEqualToString:@"Assessment"] || [ClassScheduleRecordObject.classtype isEqualToString:@"Trial"]) {
            //LastScheduledClassAllDayTimeLabel.text=@"-";
            //NextClassAllDayTimeLabel.text=@"-";
            RemainingScheduledClassLabel.text=@"-";
            RemainingScheduledClassLabel.textColor=[UIColor systemGroupedBackgroundColor];
            RemainingTBDClassLabel.text=@"";
            RemainingTBDMakeupLabel.text=@"";
            RemainingScheduledClassLabel.backgroundColor=[UIColor clearColor];
            RemainingTBDClassLabel.backgroundColor=[UIColor clearColor];
            RemainingTBDMakeupLabel.backgroundColor=[UIColor clearColor];
            OutstandingPaymentLabel.text=@"-";
        }else{
            //NextClassThisDayTimeLabel.text=ClassScheduleRecordObject.nextclassthisdaytime;
            //NextClassAllDayTimeLabel.text=[MyClass returndateformatDDMMMHHMMwithdate:ClassScheduleRecordObject.nextclassalldaytime];
            //LastScheduledClassThisDayTimeLabel.text=ClassScheduleRecordObject.lastscheduledclassthisdaytime;
            LastScheduledClassAllDayTimeLabel.text=[MyClass returndateformatDDMMMHHMMwithdate:ClassScheduleRecordObject.lastscheduledclassalldaytime];
            RemainingScheduledClassLabel.text=ClassScheduleRecordObject.remainingclassscheduled;
            RemainingTBDClassLabel.text=ClassScheduleRecordObject.remainingclassTBDclass;
            RemainingTBDMakeupLabel.text=ClassScheduleRecordObject.remainingclassTBDmakeup;
            
            RemainingScheduledClassLabel.textColor=[UIColor blackColor];
            RemainingScheduledClassLabel.backgroundColor=[UIColor systemGroupedBackgroundColor];
            RemainingTBDClassLabel.backgroundColor=[UIColor systemGroupedBackgroundColor];
            RemainingTBDMakeupLabel.backgroundColor=[UIColor systemGroupedBackgroundColor];
            RemainingTBDMakeupLabel.textColor=[UIColor blackColor];
            
            
            if ([ClassScheduleRecordObject.outstandingpayment intValue]==0) {
                OutstandingPaymentLabel.text=@"-";
            }else{
                OutstandingPaymentLabel.text=[NSString stringWithFormat:@"$%@",ClassScheduleRecordObject.outstandingpayment];
            }
        }
        cell.contentView.backgroundColor=tablecolor;
        StartTimeLabel.highlightedTextColor = [UIColor darkGrayColor];
        ClassTypeLabel.highlightedTextColor=[UIColor darkGrayColor];
        StudentNameLabel.highlightedTextColor=[UIColor darkGrayColor];
        AgeLabel.highlightedTextColor=[UIColor darkGrayColor];
        InstructorLabel.highlightedTextColor=[UIColor darkGrayColor];
        ClassroomLabel.highlightedTextColor=[UIColor darkGrayColor];
        LevelLabel.highlightedTextColor=[UIColor darkGrayColor];
        //NextClassAllDayTimeLabel.highlightedTextColor=[UIColor darkGrayColor];
        ClassDurationLabel.highlightedTextColor=[UIColor darkGrayColor];
        LastScheduledClassAllDayTimeLabel.highlightedTextColor=[UIColor darkGrayColor];
        //LastScheduledClassThisDayTimeLabel.highlightedTextColor=[UIColor darkGrayColor];
        RemainingScheduledClassLabel.highlightedTextColor=[UIColor darkGrayColor];
        RemainingTBDClassLabel.highlightedTextColor=[UIColor darkGrayColor];
        RemainingTBDMakeupLabel.highlightedTextColor=[UIColor darkGrayColor];
        OutstandingPaymentLabel.highlightedTextColor=[UIColor darkGrayColor];
        
        //cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
        
    }else{
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (indexPath.row==0) {
                UILabel *BlockLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 120, 21)];
                BlockLabel.font=[UIFont systemFontOfSize:14];
                //BlockLabel.textColor=[UIColor darkGrayColor];
                BlockLabel.tag=101;
                BlockLabel.text=[MyClass returntitlewithtitle:@"Block Timeslot"];
                [cell.contentView addSubview:BlockLabel];
                
                
                swBlock = [[UISwitch alloc] init];
                swBlock.onTintColor=themecolor;
                CGSize switchSize = [swBlock sizeThatFits:CGSizeZero];
                swBlock.frame = CGRectMake(255,1.5f,switchSize.width,switchSize.height);
                swBlock.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                swBlock.tag = 510;
                
                if (TimeTableDetailsObject) {
                    if ([TimeTableDetailsObject.block isEqualToString:@"Yes"]) {
                        swBlock.on=YES;
                    }else{
                        swBlock.on=NO;
                    }
                }
                if ([TimeTableMode isEqualToString:@"PopoverWeekly"] || [TimeTableMode isEqualToString:@"PopoverConsolidated"]){
                    swBlock.enabled=NO;
                }
                
                [cell.contentView addSubview:swBlock];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
            }else if (indexPath.row==1) {
                UILabel *BlockLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 120, 21)];
                BlockLabel.font=[UIFont systemFontOfSize:14];
                BlockLabel.text=[MyClass returntitlewithtitle:@"Block Caption"];
                BlockLabel.tag=101;
                [cell.contentView addSubview:BlockLabel];
                
                
                CaptionText = [[UITextField alloc]initWithFrame:CGRectMake(205, 7, 100, 21)];
                CaptionText.font=[UIFont systemFontOfSize:14];
                CaptionText.textColor=[UIColor darkGrayColor];
                CaptionText.textAlignment=NSTextAlignmentRight;
                CaptionText.placeholder=[MyClass returntitlewithtitle:@"Caption"];
                CaptionText.tag=301;
                [cell.contentView addSubview:CaptionText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (TimeTableDetailsObject) {
                    CaptionText.text=TimeTableDetailsObject.caption;
                }
                
                if ([TimeTableMode isEqualToString:@"PopoverWeekly"] || [TimeTableMode isEqualToString:@"PopoverConsolidated"]){
                    CaptionText.enabled=NO;
                }

                
            }else{
                UILabel *BlockLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 3, 120, 25)];
                BlockLabel.font=[UIFont systemFontOfSize:14];
                BlockLabel.tag=101;
                BlockLabel.text=[MyClass returntitlewithtitle:@"Remarks"];
                [cell.contentView addSubview:BlockLabel];
                
                RemarksText = [[UITextView alloc]initWithFrame:CGRectMake(20, 30, 280, 50)];
                RemarksText.font=[UIFont systemFontOfSize:14];
                RemarksText.textColor=[UIColor darkGrayColor];
                RemarksText.textAlignment=NSTextAlignmentLeft;

                RemarksText.tag=409;
                [cell.contentView addSubview:RemarksText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (TimeTableDetailsObject) {
                    RemarksText.text=TimeTableDetailsObject.remarks;
                }
                
                if ([TimeTableMode isEqualToString:@"PopoverWeekly"] || [TimeTableMode isEqualToString:@"PopoverConsolidated"]){
                    RemarksText.editable=NO;
                }


            }
        }
    }
    return cell;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==FreeScheduleTable) {
        FreeScheduleClassObject=[FreeScheduleClassArray objectAtIndex:(int)(indexPath.row/2)];
        if ([FreeScheduleClassObject.action isEqualToString:@"Delete"]) {
            return 0;
        }else if(indexPath.row%2==1){
            if (indexPath.row-1== selectedfreeclassrow) {
                return 150;
            }else{
                return 0;
            }
        }else{
            return 35;
        }
    }else if (tableView==ClassSelectionTable){
        return 35;
    }else if (tableView==ClassTypeSelectionTable){
        return 38;
    }else if (tableView==datebartable){
        if (detailViewMode && headerWidthArray.count>0) {
            int count=[[headerPositionArray objectAtIndex:((indexPath.row+1)*filteredHeaderArray.count-1)] floatValue]+[[headerWidthArray objectAtIndex:((indexPath.row+1)*filteredHeaderArray.count-1)] floatValue]-[[headerPositionArray objectAtIndex:indexPath.row*filteredHeaderArray.count] floatValue];
            return (float)count*mincellwidthfordetailview;
        }else{
            return cellwidth*filteredHeaderArray.count;
        }
    }else{
        if (ClassScheduleRecordArray.count>0) {
            return 25;
        }else{
            if (indexPath.row==2) {
                return 90;
            }else{
                return 35;
            }
        }
    }
}


-(void) donebuttonpressed:(UIButton *)sender
{
    NSString *strURL;
    
    //find block info for the selected timeslot for enrollment and weekly view
    NSString *selectedheadervalue;
    if ([headertype isEqualToString:@"Classroom"]) {
        selectedheadervalue=selectedclassroom;
    }else if ([headertype isEqualToString:@"Subject"]){
        selectedheadervalue=selectedsubject;
    }else{
        selectedheadervalue=selectedinstructor;
    }
    
    if ([ClassTimeDetailsdictionary objectForKey:[NSString stringWithFormat:@"%@%@%@",selectedclassday,selectedclasstime,selectedheadervalue]]) {
        
        if (![self retrieveTimeTableDetailsWithOption:@"Daily" type:scviewtype.selectedSegmentIndex==0?@"Consolidated":@"Weekly" classdate:selectedstartdate classday:selectedclassday classtime:selectedclasstime subtypevalue:selectedheadervalue]){
            return;
        }

        if (ClassTimeDetailsdictionary.count!=0) {
            TimeTableDetailsObject=[ClassTimeDetailsdictionary objectForKey:[NSString stringWithFormat:@"%@%@%@0",selectedclassday,selectedclasstime,selectedheadervalue]];
            //TimeTableDetailsObject=[TimeTableDetailsArray objectAtIndex:0];
        }else{
            TimeTableDetailsObject=[[TimeTableDetails alloc]init];
        }
    }else{
        ClassTimeDetailsdictionary=[[NSMutableDictionary alloc]init];
        TimeTableDetailsObject=[[TimeTableDetails alloc]init];
    }
    
    //if (ClassScheduleRecordArray.count==0) {
        if (swBlock.on==YES) {
            if (scviewtype.selectedSegmentIndex==0) {
                
                //enrollment view
                if (ClassTimeDetailsdictionary.count !=0) {
                    //TimeTableDetailsObject=[TimeTableDetailsArray objectAtIndex:0];
                    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatetimetable&timetablekey=%@&block=%@&caption=%@&remarks=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,TimeTableDetailsObject.timetablekey,@"Yes",CaptionText.text,RemarksText.text];
                }else{
                    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=inserttimetable&type=%@&classdate=%@&classday=%@&classtime=%@&subtypevalue=%@&block=%@&caption=%@&remarks=%@&subtype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, @"Consolidated",@"",selectedclassday,selectedclasstime,[MyClass enurlstring:[headertype isEqualToString:@"Subject"]?selectedsubject:[headertype isEqualToString:@"Classroom"]?selectedclassroom:selectedinstructor],@"Yes",CaptionText.text,RemarksText.text,headertype];
                }
                __block BOOL result=FALSE;
                [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
                    if (succeeded) {
                        result=TRUE;
                        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                        NSString *strResult = jsonreturned[@"status"];
                        
                        //NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"%@",strResult);
                    }
                }];
                
                /*
                dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                NSURLSession *session = [NSURLSession sharedSession];
                [[session dataTaskWithURL:[NSURL URLWithString:[MyClass dcurlstring:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    // handle response
                    
                    if (!error) {
                        result=TRUE;
                    NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                    NSString *strResult = jsonreturned[@"status"];
                    
                    //NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"%@",strResult);
                    }
                    dispatch_semaphore_signal(semaphore);
                }] resume];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
                    
                if(!result){
                    //[MyClass showconnectionlostdialogbox];
                    return;
                }
            }else{
                //attendance view
                if (ClassTimeDetailsdictionary.count !=0) {
                    if ([TimeTableDetailsObject.type isEqualToString:@"Weekly"]) {
                        if (ClassTimeDetailsdictionary.count==2) {
                            TimeTableDetailsObject=[ClassTimeDetailsdictionary objectForKey:[NSString stringWithFormat:@"%@%@%@1",selectedclassday,selectedclasstime,selectedsubject]];
                            if (![CaptionText.text isEqualToString:TimeTableDetailsObject.caption] || ![RemarksText.text isEqualToString:TimeTableDetailsObject.remarks]) {
                                TimeTableDetailsObject=[ClassTimeDetailsdictionary objectForKey:[NSString stringWithFormat:@"%@%@%@0",selectedclassday,selectedclasstime,selectedsubject]];
                                strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatetimetable&timetablekey=%@&block=%@&caption=%@&remarks=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,TimeTableDetailsObject.timetablekey,@"Yes",CaptionText.text,RemarksText.text];
                            }else{//same as enrollment record, delete weekly record
                                TimeTableDetailsObject=[ClassTimeDetailsdictionary objectForKey:[NSString stringWithFormat:@"%@%@%@0",selectedclassday,selectedclasstime,selectedsubject]];
                                strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletetimetable&timetablekey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,TimeTableDetailsObject.timetablekey];
                            }

                            __block BOOL result=FALSE;
                            [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
                                if (succeeded) {
                                    result=TRUE;
                                }
                            }];
                            
                            /*
                            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                            NSURLSession *session = [NSURLSession sharedSession];
                            [[session dataTaskWithURL:[NSURL URLWithString:[MyClass dcurlstring:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                // handle response
                                
                                if (!error) {
                                    result=TRUE;
                                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                                NSString *strResult = jsonreturned[@"status"];
                                
                                //NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                NSLog(@"%@",strResult);
                                }
                                dispatch_semaphore_signal(semaphore);
                            }] resume];
                            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
                                
                            if(!result){
                                //[MyClass showconnectionlostdialogbox];
                                return;
                            }
                        }else{
                            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatetimetable&timetablekey=%@&&block=%@&caption=%@&remarks=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,TimeTableDetailsObject.timetablekey,@"Yes",CaptionText.text,RemarksText.text];
                            
                            __block BOOL result=FALSE;
                            [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
                                if (succeeded) {
                                    result=TRUE;
                                }
                            }];
                            
                            /*
                            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                            NSURLSession *session = [NSURLSession sharedSession];
                            [[session dataTaskWithURL:[NSURL URLWithString:[MyClass dcurlstring:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                // handle response
                                
                                if (!error) {
                                    result=TRUE;
                                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                                NSString *strResult = jsonreturned[@"status"];
                                
                                //NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                NSLog(@"%@",strResult);
                                }
                                dispatch_semaphore_signal(semaphore);
                            }] resume];
                            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
                                
                            if(!result){
                                //[MyClass showconnectionlostdialogbox];
                                return;
                            }
                        }

                        
                    }else{ // set new weekly record
                        if (![CaptionText.text isEqualToString:TimeTableDetailsObject.caption] || ![RemarksText.text isEqualToString:TimeTableDetailsObject.remarks]) {
                            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=inserttimetable&type=%@&classdate=%@&classday=%@&classtime=%@&subtypevalue=%@&block=%@&caption=%@&remarks=%@&subtype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, @"Weekly",[MyClass convertDateFormatWithDate:selectedstartdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"],selectedclassday,selectedclasstime,[MyClass enurlstring:[headertype isEqualToString:@"Subject"]?selectedsubject:[headertype isEqualToString:@"Classroom"]?selectedclassroom:selectedinstructor],@"Yes",CaptionText.text,RemarksText.text,headertype];
                            
                            __block BOOL result=FALSE;
                            [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
                                if (succeeded) {
                                    result=TRUE;
                                }
                            }];
                            
                            /*dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                            NSURLSession *session = [NSURLSession sharedSession];
                            [[session dataTaskWithURL:[NSURL URLWithString:[MyClass dcurlstring:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                // handle response
                                
                                if (!error) {
                                    result=TRUE;
                                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                                NSString *strResult = jsonreturned[@"status"];
                                
                                //NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                NSLog(@"%@",strResult);
                                }
                                dispatch_semaphore_signal(semaphore);
                            }] resume];
                            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
                                
                            if(!result){
                                //[MyClass showconnectionlostdialogbox];
                                return;
                            }
                        }
                    }

                }else{
                    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=inserttimetable&type=%@&classdate=%@&classday=%@&classtime=%@&subtypevalue=%@&block=%@&caption=%@&remarks=%@&subtype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, @"Weekly",[MyClass convertDateFormatWithDate:selectedstartdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"],selectedclassday,selectedclasstime,[MyClass enurlstring:[headertype isEqualToString:@"Subject"]?selectedsubject:[headertype isEqualToString:@"Classroom"]?selectedclassroom:selectedinstructor],@"Yes",CaptionText.text,RemarksText.text,headertype];
                    
                    __block BOOL result=FALSE;
                    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
                        if (succeeded) {
                            result=TRUE;
                        }
                    }];
                    
                    /*dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                    NSURLSession *session = [NSURLSession sharedSession];
                    [[session dataTaskWithURL:[NSURL URLWithString:[MyClass dcurlstring:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        // handle response
                        
                        if (!error) {
                            result=TRUE;
                        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                        NSString *strResult = jsonreturned[@"status"];
                        
                        //NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"%@",strResult);
                        }
                        dispatch_semaphore_signal(semaphore);
                    }] resume];
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
                        
                    if(!result){
                        //[MyClass showconnectionlostdialogbox];
                        return;
                    }
                }
                

            }
        }else{
            if (scviewtype.selectedSegmentIndex==0) {
                //enrollment view
                
                if (ClassTimeDetailsdictionary.count !=0) {
                    //TimeTableDetailsObject=[TimeTableDetailsArray objectAtIndex:0];
                    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletetimetable&timetablekey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,TimeTableDetailsObject.timetablekey];
                    
                    __block BOOL result=FALSE;
                    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
                        if (succeeded) {
                            result=TRUE;
                        }
                    }];
                    
                    /*dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                    NSURLSession *session = [NSURLSession sharedSession];
                    [[session dataTaskWithURL:[NSURL URLWithString:[MyClass dcurlstring:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        // handle response
                        
                        if (!error) {
                            result=TRUE;
                        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                        NSString *strResult = jsonreturned[@"status"];
                        
                        //NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"%@",strResult);
                        }
                        dispatch_semaphore_signal(semaphore);
                    }] resume];
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
                        
                    if(!result){
                        //[MyClass showconnectionlostdialogbox];
                        return;
                    }
                }
            
            }else{
                //weekly view
                

                
                if (ClassTimeDetailsdictionary.count==1) {
                    //TimeTableDetailsObject=[TimeTableDetailsArray objectAtIndex:0];
                    if ([TimeTableDetailsObject.type isEqualToString:@"Weekly"]) {
                        strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletetimetable&timetablekey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,TimeTableDetailsObject.timetablekey];
                    }else{
                        //unblock timeslot against enrollment record
                        strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=inserttimetable&type=%@&classdate=%@&classday=%@&classtime=%@&subtypevalue=%@&block=%@&caption=%@&remarks=%@&subtype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, @"Weekly",[MyClass convertDateFormatWithDate:selectedstartdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"],selectedclassday,selectedclasstime,[MyClass enurlstring:[headertype isEqualToString:@"Subject"]?selectedsubject:[headertype isEqualToString:@"Classroom"]?selectedclassroom:selectedinstructor],@"No",CaptionText.text,RemarksText.text,headertype];
                    }

                    __block BOOL result=FALSE;
                    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
                        if (succeeded) {
                            result=TRUE;
                        }
                    }];
                    
                    /*dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                    NSURLSession *session = [NSURLSession sharedSession];
                    [[session dataTaskWithURL:[NSURL URLWithString:[MyClass dcurlstring:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        // handle response
                        
                        if (!error) {
                            result=TRUE;
                        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                        NSString *strResult = jsonreturned[@"status"];
                        
                        //NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"%@",strResult);
                        }
                        dispatch_semaphore_signal(semaphore);
                    }] resume];
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
                        
                    if(!result){
                        //[MyClass showconnectionlostdialogbox];
                        return;
                    }
                }else if (ClassTimeDetailsdictionary.count==2){
                    //unblock timeslot against enrollment record
                    //TimeTableDetailsObject=[TimeTableDetailsArray objectAtIndex:0];
                    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatetimetable&timetablekey=%@&block=%@&caption=%@&remarks=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,TimeTableDetailsObject.timetablekey,@"No",CaptionText.text,RemarksText.text];
                    
                    __block BOOL result=FALSE;
                    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
                        if (succeeded) {
                            result=TRUE;
                        }
                    }];
                    
                    /*dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
                    NSURLSession *session = [NSURLSession sharedSession];
                    [[session dataTaskWithURL:[NSURL URLWithString:[MyClass dcurlstring:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                        // handle response
                        
                        if (!error) {
                            result=TRUE;
                        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                        NSString *strResult = jsonreturned[@"status"];
                        
                        //NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        NSLog(@"%@",strResult);
                        }
                        dispatch_semaphore_signal(semaphore);
                    }] resume];
                    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
                        
                    if(!result){
                        //[MyClass showconnectionlostdialogbox];
                        return;
                    }
                }
            }
        }

        //refresh time table data
        [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        [self generateTimeTablewithViewOption:TimeTableMode pastMonday:globalselecteddate classtype:classtypeselected redrawscoller:YES];


}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*if (tableView==FreeScheduleTable) {
        if (indexPath.row%2==0) {
            if (indexPath.row==selectedfreeclassrow) {
                selectedfreeclassrow=-10;
            }else{
                selectedfreeclassrow=(int)indexPath.row;
            }
            
            [FreeScheduleTable reloadData];
            [FreeScheduleTable setFrame:CGRectMake(0, 44+22, freescheduletablewidth,  FreeScheduleTable.contentSize.height*35)];
            myFreeSchedulePopoverController.popoverContentSize=CGSizeMake(freescheduletablewidth, FreeScheduleTable.contentSize.height+44+22);
        }
    }else */if (tableView==ClassSelectionTable){
        NSString *selecteditem;
        if ([headertype isEqualToString:@"Subject"]) {
            selecteditem=((SubjectRecord *)[headerArray objectAtIndex:indexPath.row]).subject_shortname;
        }else if ([headertype isEqualToString:@"Classroom"]){
            selecteditem=((ClassroomRecord *)[headerArray objectAtIndex:indexPath.row]).classroom;
        }else{
            selecteditem=((Staff *)[headerArray objectAtIndex:indexPath.row]).username;
        }
        
        
        if ([selectedHeaderArray containsObject:selecteditem]) {
            if ([TimeTableMode isEqualToString:@"PopoverWeekly"] || [TimeTableMode isEqualToString:@"PopoverConsolidated"]){
                if ([((SubjectRecord *)[headerArray objectAtIndex:indexPath.row]).subject_shortname isEqualToString:selectedsubject]) {
                    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Time Selection"] message:[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"Cannot delete the enrolled subject"],selectedsubject] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [erroralert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [erroralert addAction:OKAction];
                    [self presentViewController:erroralert animated:YES completion:nil];
                }else{
                    [selectedHeaderArray removeObject:selecteditem];
                }
            }else{
                [selectedHeaderArray removeObject:selecteditem];
            }
            
            if (selectedHeaderArray.count==0) {
                deselectallsubjectbutton.enabled=NO;
            }
            
            if (selectedHeaderArray.count<headerArray.count) {
                selectallsubjectbutton.enabled=YES;
            }
        }else{
            /*if (selectedHeaderArray.count<maxsubjectinclasstimeweeklyview || [dailyweeklyviewselected isEqualToString:@"Daily"] || (selectedtabbutton.tag == 99 && scdailyweeklyview.selectedSegmentIndex==0)) {*/
                [selectedHeaderArray addObject:selecteditem];
            
            if ([headertype isEqualToString:@"Instructor"]) {
                selectedHeaderArray=[MyClass returnsortedstaffusernamewithstaffusernamearray:selectedHeaderArray];
            }else{
                NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES selector:@selector(localizedStandardCompare:)];
                selectedHeaderArray=[NSMutableArray arrayWithArray:[selectedHeaderArray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
            }
            

                deselectallsubjectbutton.enabled=YES;
                if (selectedHeaderArray.count==headerArray.count) {
                    selectallsubjectbutton.enabled=NO;
                }
        }
        
        if ([TimeTableMode isEqualToString:@"PopoverWeekly"] || [TimeTableMode isEqualToString:@"PopoverConsolidated"]){
            filteredHeaderArray=[[NSMutableArray alloc]initWithArray:selectedHeaderArray copyItems:YES];
        }
        
        [ClassSelectionTable reloadData];
        
    }else if (tableView==ClassTypeSelectionTable){
        [self drawclasstypepointerwithoption:@"closed"];
        NSString *newclasstypeselected=indexPath.row==0?@"All":[ClassTypeArray objectAtIndex:indexPath.row];
        
        [[myClassTypeSelectionPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        
        ClassScheduleTableShown=FALSE;
        
        tmpselecteddate=globalselecteddate;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([self generateTimeTablewithViewOption:TimeTableMode pastMonday:tmpselecteddate classtype:newclasstypeselected redrawscoller:YES]){
                [ClassTypeSelectionButton setTitle:[MyClass returntitlewithtitle:[ClassTypeArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
                classtypeselected=newclasstypeselected;
            }
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });

    }else if (ClassScheduleRecordArray.count>0) {
        
        ClassScheduleRecordObject=[ClassScheduleRecordArray objectAtIndex:indexPath.row];
        
        if ([ClassScheduleRecordObject.type isEqualToString:@"student"]) {
            
            if(![MyClass showMenuItemwithObject:@"Student Profile"]){
                return;
            }
            
            [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
                //studentpopover.delegate=self;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:ClassScheduleRecordObject.studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];
                

                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=ClassScheduleRecordObject.enrollmentkey;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedDTkey=ClassScheduleRecordObject.dtkey;
                
                
                if ([TimeTableMode isEqualToString:@"Consolidated"]) {
                    ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedClasskey=@"";
                }else{
                    ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedClasskey=ClassScheduleRecordObject.classkey;
                }
                
                
                studentdetailsnavcontroller.view.frame=CGRectMake(0, 0, self.view.frame.size.width-240, self.view.bounds.size.height);;
                [self->sidewindowview addSubview:studentdetailsnavcontroller.view];
                [self addChildViewController:studentdetailsnavcontroller];
                [studentdetailsnavcontroller didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });
            

        }else{
            if(![MyClass showMenuItemwithObject:@"Lead Profile"]){
                return;
            }
            
            [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                LeadDetailsNavController *leaddetailsnavcontroller = (LeadDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"LeadDetailsNavController"];
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).delegate=self;
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).leadAction=@"PopoverLead";
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).DetailsViewLead=[[Lead alloc]init];
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).DetailsViewLead.leadkey=ClassScheduleRecordObject.studentkey;
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).selectedDTkey=ClassScheduleRecordObject.dtkey;
                
                
                if (![(LeadDetailsViewController *)[leaddetailsnavcontroller topViewController] retrieveLead:ClassScheduleRecordObject.studentkey]) {
                    return;
                }
                
                ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(self.view.frame.size.width-240, self.view.bounds.size.height);
                

                leaddetailsnavcontroller.view.frame=CGRectMake(0, 0, self.view.frame.size.width-240, self.view.bounds.size.height);
                [self->sidewindowview addSubview:leaddetailsnavcontroller.view];
                [self addChildViewController:leaddetailsnavcontroller];
                [leaddetailsnavcontroller didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });

        }
        

    }
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverController
{

    if (popoverController==myClassSelectionPopoverController){
        
    }else if (popoverController==myClassTypeSelectionPopoverController){
        [self drawclasstypepointerwithoption:@"closed"];
    }
}

-(int) returntabarrayindexwithtabid:(NSString *)tabid
{
    for (int i=0; i<TabArray.count; i++) {
        if ([((TabRecord *)[TabArray objectAtIndex:i]).tabid isEqualToString:tabid]) {
            return i;
            break;
        }
    }
    return 0;
}

-(void) deletetabview:(UIButton *)sender
{
    
    //NSString *lastdailyweeklyviewselected=dailyweeklyviewselected;
    NSString *lastglobalselecteddate=globalselecteddate;
    
    //aiclasstimetable.center=CGPointMake(selectedtabbutton.frame.origin.x+13, selectedtabbutton.frame.origin.y+15);
    //[self.view bringSubviewToFront:aiclasstimetable];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *tabid=[NSString stringWithFormat:@"%ld",(long)sender.tag-300000000];
        long selectedviewindex=[self returntabarrayindexwithtabid:tabid];
        
        if (self->TabArray.count==1) {
            //last tab
            UIButton *tmptabviewbutton;
            tmptabviewbutton=(UIButton *)[self.view viewWithTag:sender.tag-200000000];
            [tmptabviewbutton removeFromSuperview];
            
            
            [self updatetabviewpreferencewithoption:@"delete" tabid:sender.tag-300000000 headerlist:@"" mode:@"" selecteddate:@""];
            
            [self resizealltabviewbuttonwithselectedtabid:self->selectedtabbutton.tag];
            [self showemptyheadermessage];
                        
        }else{
            self->classDay=[[NSMutableArray alloc]initWithArray:globalvariables.centerdayofweekarray copyItems:YES];

            if (selectedviewindex<self->TabArray.count-1) {
                self->selectedtabbutton=(UIButton *)[self.view viewWithTag:[((TabRecord *)[TabArray objectAtIndex:selectedviewindex+1]).tabid intValue]+100000000];
                self->selectedHeaderArray=[[NSMutableArray alloc]initWithArray:((TabRecord *)[TabArray objectAtIndex:selectedviewindex+1]).headerlistarray copyItems:YES];
                //dailyweeklyviewselected=((TabRecord *)[TabArray objectAtIndex:selectedviewindex+1]).mode;
                self->globalselecteddate=((TabRecord *)[TabArray objectAtIndex:selectedviewindex+1]).selecteddate;
            }else{
                self->selectedtabbutton=(UIButton *)[self.view viewWithTag:[((TabRecord *)[TabArray objectAtIndex:selectedviewindex-1]).tabid intValue]+100000000];
                self->selectedHeaderArray=[[NSMutableArray alloc]initWithArray:((TabRecord *)[TabArray objectAtIndex:selectedviewindex-1]).headerlistarray copyItems:YES];
                //dailyweeklyviewselected=((TabRecord *)[TabArray objectAtIndex:selectedviewindex-1]).mode;
                self->globalselecteddate=((TabRecord *)[TabArray objectAtIndex:selectedviewindex-1]).selecteddate;
                
            }
            self->tmpselecteddate=self->globalselecteddate;
            
            if([self selectsubjectdelay]){
                UIButton *tmptabviewbutton;
                tmptabviewbutton=(UIButton *)[self.view viewWithTag:sender.tag-200000000];
                [tmptabviewbutton removeFromSuperview];
                
                
                [self updatetabviewpreferencewithoption:@"delete" tabid:sender.tag-300000000 headerlist:@"" mode:@"" selecteddate:@""];
                
                [self resizealltabviewbuttonwithselectedtabid:self->selectedtabbutton.tag];
            }else{
                self->selectedHeaderArray=[[NSMutableArray alloc]initWithArray:self->lasttabsubjectarray copyItems:YES];
                self->selectedtabbutton=(UIButton *)[self.view viewWithTag:[((TabRecord *)[self->TabArray objectAtIndex:selectedviewindex]).tabid intValue]+100000000];
                self->globalselecteddate=lastglobalselecteddate;
                //dailyweeklyviewselected=lastdailyweeklyviewselected;
            }

        }

        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
    
}

-(void) selecttabview:(UIButton *)sender
{
    
    __block UIButton *tmptabviewbutton;
    __block UIButton *tmpdeletebutton;
    __block UILabel *tmptabtitle;
    NSMutableArray *lastselectedHeaderArray;
    UIButton *Lastselecttabbutton;
    //NSString *lastdailyweeklyviewselected;
    NSMutableArray *lastclassday;
    NSString *lastselecteddate;

    if ([headertype isEqualToString:@"All"]) {
        return;
    }
    
    if (sender.tag!=selectedtabbutton.tag) {

        //store old values for rollback
        Lastselecttabbutton=selectedtabbutton;
        lastselectedHeaderArray=[[NSMutableArray alloc]initWithArray:selectedHeaderArray copyItems:YES];
        //lastdailyweeklyviewselected=dailyweeklyviewselected;
        lastclassday=[[NSMutableArray alloc]initWithArray:classDay copyItems:YES];
        lastselecteddate=globalselecteddate;
        
        selectedtabbutton=sender;
        
        NSString *tabid=[NSString stringWithFormat:@"%ld",(long)sender.tag-100000000];

        selectedHeaderArray=[[NSMutableArray alloc]initWithArray:((TabRecord *)[TabArray objectAtIndex:[self returntabarrayindexwithtabid:tabid]]).headerlistarray copyItems:YES];
        globalselecteddate=((TabRecord *)[TabArray objectAtIndex:[self returntabarrayindexwithtabid:tabid]]).selecteddate;
        tmpselecteddate=globalselecteddate;

        classDay=[[NSMutableArray alloc]initWithArray:globalvariables.centerdayofweekarray copyItems:YES];
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self selectsubjectdelay]) {
                for (long i=0; i<self->TabArray.count; i++) {
                    
                    tmptabviewbutton=(UIButton *)[self->tabpanelview viewWithTag:[((TabRecord *)[self->TabArray objectAtIndex:i]).tabid intValue]+100000000];
                    tmpdeletebutton=(UIButton *)[self->tabpanelview viewWithTag:[((TabRecord *)[self->TabArray objectAtIndex:i]).tabid intValue]+300000000];
                    tmptabtitle=(UILabel *)[self->tabpanelview viewWithTag:[((TabRecord *)[self->TabArray objectAtIndex:i]).tabid intValue]+200000000];
                    
                    if (tmptabviewbutton.tag==sender.tag) {
                        tmptabviewbutton.backgroundColor=tablecolor;
                        //[tmptabviewbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        tmptabtitle.textColor=[UIColor whiteColor];
                        tmptabtitle.frame=CGRectMake(20, 2, tmptabviewbutton.frame.size.width-40, tabheight);
                        tmpdeletebutton.hidden=NO;
                        [self->tabpanelview bringSubviewToFront:tmptabviewbutton];
                    }else{
                        tmptabviewbutton.backgroundColor=[UIColor grayColor];
                        //[tmptabviewbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                        tmptabtitle.frame=CGRectMake(3, 2, tmptabviewbutton.frame.size.width-6, tabheight);
                        tmptabtitle.textColor=[UIColor lightGrayColor];
                        tmpdeletebutton.hidden=YES;
                    [self->tabpanelview sendSubviewToBack:tmptabviewbutton];
                    }
                    
                    
                }

            }else{
                //dailyweeklyviewselected=lastdailyweeklyviewselected;
                self->selectedtabbutton=Lastselecttabbutton;
                self->selectedHeaderArray=[[NSMutableArray alloc]initWithArray:lastselectedHeaderArray copyItems:YES];
                self->classDay=[[NSMutableArray alloc]initWithArray:lastclassday copyItems:YES];
                self->globalselecteddate=lastselecteddate;
            }
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            
        });
        
    }else{
        lasttabsubjectarray=[[NSMutableArray alloc]initWithArray:selectedHeaderArray copyItems:YES];
        [self popupsubjectselection:sender];
    }
    

}



-(void) resizeothertabviewbutton:(UIButton *)sender
{
    UIButton *tmptabviewbutton;
    UIButton *tmpdeletebutton;
    UIButton *tmpaddbutton;
    UILabel *tmptabtitle;
    
    for (long i=0; i<TabArray.count; i++) {
        tmptabviewbutton=(UIButton *)[tabpanelview viewWithTag:[((TabRecord *)[TabArray objectAtIndex:i]).tabid intValue]+100000000];
        tmpdeletebutton=(UIButton *)[tabpanelview viewWithTag:[((TabRecord *)[TabArray objectAtIndex:i]).tabid intValue]+300000000];
        tmptabtitle=(UILabel *)[tabpanelview viewWithTag:[((TabRecord *)[TabArray objectAtIndex:i]).tabid intValue]+200000000];
        
        if (tmptabviewbutton.tag!=sender.tag) {
            tmptabviewbutton.backgroundColor=[UIColor grayColor];
            //[tmptabviewbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [tmptabviewbutton setFrame:CGRectMake((int)((self.view.bounds.size.width-tabheight)/TabArray.count)*i, 0, (int)((self.view.bounds.size.width-tabheight)/TabArray.count), tabheight+2)];
            [tmptabtitle setFrame:CGRectMake(3, 2, tmptabviewbutton.frame.size.width-6, tabheight)];
            [tmpdeletebutton setFrame:CGRectMake(10, 0, 20, tabheight)];
            tmptabtitle.textColor=[UIColor lightGrayColor];
            [tabpanelview sendSubviewToBack:tmptabviewbutton];
            tmpdeletebutton.hidden=YES;
        }
    }
    tmpaddbutton=(UIButton *)[tabpanelview viewWithTag:99];
    [tmpaddbutton setFrame:CGRectMake(self.view.bounds.size.width-(self.view.bounds.size.width-TabArray.count*(int)((self.view.bounds.size.width-tabheight)/TabArray.count)), 0, self.view.bounds.size.width-TabArray.count*(int)((self.view.bounds.size.width-tabheight)/TabArray.count), tabheight+2)];
    [self drawtabviewaddicon];
}

-(void) resizealltabviewbuttonwithselectedtabid:(long)tabid
{
    UIButton *tmptabviewbutton;
    UIButton *tmpdeletebutton;
    UIButton *tmpaddbutton;
    UILabel *tmptabtitle;
    
    for (long i=0; i<TabArray.count; i++) {
        tmptabviewbutton=(UIButton *)[tabpanelview viewWithTag:[((TabRecord *)[TabArray objectAtIndex:i]).tabid intValue]+100000000];
        tmpdeletebutton=(UIButton *)[tabpanelview viewWithTag:[((TabRecord *)[TabArray objectAtIndex:i]).tabid intValue]+300000000];
        tmptabtitle=(UILabel *)[tabpanelview viewWithTag:[((TabRecord *)[TabArray objectAtIndex:i]).tabid intValue]+200000000];
        
        [tmptabviewbutton setFrame:CGRectMake((int)((self.view.bounds.size.width-tabheight)/TabArray.count)*i, 0, (int)((self.view.bounds.size.width-tabheight)/TabArray.count), tabheight+2)];
        [tmpdeletebutton setFrame:CGRectMake(10, 0, 20, tabheight)];
        
        if (tmptabviewbutton.tag==tabid) {
            tmptabviewbutton.backgroundColor=tablecolor;
            tmptabtitle.textColor=[UIColor whiteColor];
            [tmptabtitle setFrame:CGRectMake(20, 2, tmptabviewbutton.frame.size.width-40, tabheight)];
            tmpdeletebutton.hidden=NO;
            [tabpanelview bringSubviewToFront:tmptabviewbutton];
        }else{
            tmptabviewbutton.backgroundColor=[UIColor grayColor];
            [tmptabtitle setFrame:CGRectMake(3, 2, tmptabviewbutton.frame.size.width-6, tabheight)];
            tmptabtitle.textColor=[UIColor lightGrayColor];
            tmpdeletebutton.hidden=YES;
            [tabpanelview sendSubviewToBack:tmptabviewbutton];
            
        }
       
        
    }

    tmpaddbutton=(UIButton *)[tabpanelview viewWithTag:99];
    if (TabArray.count>0) {
        [tmpaddbutton setFrame:CGRectMake(self.view.bounds.size.width-(self.view.bounds.size.width-(int)(self.view.bounds.size.width-tabheight)), 0, self.view.bounds.size.width-(int)(self.view.bounds.size.width-tabheight), tabheight+2)];
    }else{
        [tmpaddbutton setFrame:CGRectMake(0, 0, self.view.bounds.size.width, tabheight+2)];
    }
    
    
    //[tmpaddbutton setFrame:CGRectMake(1024-(1024-TabArray.count*(int)((1024-tabheight)/TabArray.count)), tabley-superviewclearence-tabheight+2, 1024-TabArray.count*(int)((1024-tabheight)/TabArray.count), tabheight+2)];
    [self drawtabviewaddicon];
    
}

-(BOOL) selectsubjectdelay
{
    ClassScheduleTableShown=FALSE;
    tmpselecteddate=globalselecteddate;
    return [self generateTimeTablewithViewOption:TimeTableMode pastMonday:tmpselecteddate classtype:classtypeselected redrawscoller:YES];
}

- (void)enrollDTStudent:(DTRecord *)AddEditDTObject
{
    if ([myPopoverController presentingViewController].isBeingPresented){
        [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    }
    
    /*StudentInformationViewController *viewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformationViewController"];
    viewcontroller.StudentInformationAction=@"AddDTStudent";
    viewcontroller.StudentInformationDTObject=AddEditDTObject;
    [self presentViewController:viewcontroller animated:YES completion:nil];*/
    
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
    
}

-(void) dismissDTAddEditpopoverduetoconnectionerror
{
    [self closesidewindow];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}



- (IBAction)printbuttonpressed:(id)sender {
    
    //aiclasstimetable.center=CGPointMake(ShareButton.frame.origin.x+ShareButton.frame.size.width/2, 52);
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSData *pdfData = [self generatePDF];
        
        // Create a filePath for the pdf.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"ClassTimeTable.pdf"];
        [pdfData writeToFile:filePath atomically:YES];
        
        // Open the controller.
        documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
        documentInteractionController.delegate = self;
        documentInteractionController.UTI = @"com.adobe.pdf";
        [documentInteractionController setName:@"Class Time Table"];
        [documentInteractionController presentOptionsMenuFromRect:[ShareButton frame] inView:self.view animated:YES];
        
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

- (IBAction)menubuttonpressed:(id)sender {
    [self.mainSlideMenu openLeftMenu];
}

- (NSData*)generatePDF {
    
    UIView *printview=[self returnDetailsPrintView];
    NSMutableData * pdfData=[NSMutableData data];

    // by default, the UIKit will create a 612x792 page size (8.5 x 11 inches)
    // if you pass in CGRectZero for the size
    //UIGraphicsBeginPDFContextToData(pdfData, CGRectMake(0, 0, 792, 612),nil);
    UIGraphicsBeginPDFContextToData(pdfData, printview.bounds,nil);
    CGContextRef pdfContext=UIGraphicsGetCurrentContext();
    
    // repeat the code between the lines for each pdf page you want to output
    // ======================================================================
    UIGraphicsBeginPDFPage();
    
    // add code to update the UI elements in the first page here
    CGContextSaveGState(pdfContext);
    //CGContextConcatCTM(pdfContext,CGAffineTransformMakeScale(.6, .6));
    
    [printview.layer renderInContext:pdfContext];
    
    // end repeat code
    // ======================================================================
    
    // finally end the PDF context.
    UIGraphicsEndPDFContext();
    
    // and return the PDF data.
    return pdfData;
}


-(NSString *) autoassigninstructorwithsubject:(NSString *)subject
{
    
    if (![preferredinstructor isEqualToString:@""]) {
        return preferredinstructor;
    }else{
        return @"TBD";
        //return [AvailableInstructorNameArray objectAtIndex:0];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    if (tableView==FreeScheduleTable) {
        if (indexPath.row % 2 ==0) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

-(void) freescheduledonebuttonpressed:(id)sender
{


    [self.delegate passFreeSscheduleInformationwithArray:FreeScheduleClassArray];
    [[myFreeSchedulePopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    
}




-(BOOL) checkcorrectweek:(NSString *)classdate
{
    if (![classdate isEqualToString:@"TBD"]) {
        NSDate *today=[MyClass convertToNSDateWithDate:classdate DateFormat:@"dd-MMM-yyyy"];
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:today];
        
        NSUInteger weekdayToday = [components weekday];
        NSInteger daysToMonday=weekdayToday-[MyClass returndayofweeknumber:[globalvariables.centerdayofweekarray objectAtIndex:0]];
        NSDate *pastMon = [today dateByAddingTimeInterval:60*60*24*(-daysToMonday)];
        if ([[MyClass convertToNSStringWithNSDate:pastMon DateFormat:@"dd-MMM-yyyy"] isEqualToString:globalselecteddate]) {
            return TRUE;
            
        }else{
            return FALSE;
        }
    }else{
        return FALSE;
    }
}


-(void) addfreeclassschedulearraywithclassdate:(NSString *)classdate classtime:(NSString *)classtime instructor:(NSString *)instructor classroom:(NSString *)classroom classremarks:(NSString *)classremarks allclassremarks:(NSString *)allclassremarks preferredrow:(int)preferredrow
{

}


-(void) removefreeclassschedulearraywithclassdate:(NSString *)classdate classtime:(NSString *)classtime instructor:(NSString *)instructor index:(NSInteger)indexrow
{

}

/*
-(int) freeclassschedulearraycount
{
    int count=0;
    for (int j=0; j<FreeScheduleClassArray.count; j++) {
        FreeScheduleClassObject=[FreeScheduleClassArray objectAtIndex:j];
        if (![FreeScheduleClassObject.action isEqualToString:@"Delete"]) {
            count+=1;
        }
    }
    return count;
}*/


-(NSString *) findclassdaywithstartdate:(NSString *)startdate
{
    if ([startdate isEqualToString:@""]){
        return @"";
    }else if ([startdate isEqualToString:@"TBD"]) {
        return @"TBD";
    }else{
        return [MyClass convertDateFormatWithDate:startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE"];
    }
}

-(void) drawtrianglepointerwithexpandcellposition:(CGRect )expandcellposition
{
    CGFloat xposition;
    CGFloat yposition;

    //yposition=(((int)[expandcellposition integerValue]/totalSubjectColumn))*cellheight+cellheight;
    //xposition=[expandcellposition integerValue]%totalSubjectColumn*cellwidth+selectedbutton.frame.origin.x;
    
    yposition=expandcellposition.origin.y;
    xposition=expandcellposition.origin.x;
    
    CGFloat width=expandcellposition.size.width;
    CGFloat height=expandcellposition.size.height;

    shapeLayer = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,xposition,yposition+4);
    CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
    CGPathAddLineToPoint(path, NULL, xposition+width, yposition+4);
    CGPathAddLineToPoint(path, NULL, xposition, yposition+4);
    
    [shapeLayer setPath:path];
    [shapeLayer setFillColor:[tablecolor CGColor]];
    if (detailViewMode) {
        [[TimeTableView layer] addSublayer:shapeLayer];
    }else{
        [[timetablecollectionview layer] addSublayer:shapeLayer];
    }
    
    
    CGPathRelease(path);
}


-(void) gotoclassschedule:(id)sender
{
    globalvariables.classdate=selectedstartdate;
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
    
}

- (NSString *) returnstudentnamewithfirstname:(NSString *)firstname lastname:(NSString *)lastname
{
    int spacecount=0;
    long lastspaceindex=0;
    for (long i=firstname.length-1; i>=0; i--) {
        if ([[firstname substringWithRange:NSMakeRange(i, 1)] isEqualToString:@" "]) {
            lastspaceindex=i;
            spacecount+=1;
        }
    }
    
    if (spacecount==2) {
        if ([lastname isEqualToString:@""]) {
            return [firstname substringToIndex:lastspaceindex];
        }else{
            return [NSString stringWithFormat:@"%@ %@",[firstname substringToIndex:lastspaceindex],lastname];
        }
    }else{
        if ([lastname isEqualToString:@""]) {
            return firstname;
        }else{
            return [NSString stringWithFormat:@"%@ %@",firstname,lastname];
        }
    }
}

-(void) popupsubjectselection:(UIButton *)sender
{

    
    ClassScheduleRecordArray=[[NSMutableArray alloc]init];
    
    if (sender.tag==99) {
        //used to fallback in case the add tab is cancelled
        lasttabsubjectarray=[[NSMutableArray alloc]initWithArray:selectedHeaderArray copyItems:YES];
        lastselecttabbutton=selectedtabbutton;
        selectedHeaderArray=[[NSMutableArray alloc]init];
    }else{
        if (![TimeTableMode isEqualToString:@"PopoverWeekly"] && ![TimeTableMode isEqualToString:@"PopoverConsolidated"]){
            selectedHeaderArray=[[NSMutableArray alloc]initWithArray:((TabRecord *)[TabArray objectAtIndex:[self returntabarrayindexwithtabid:[NSString stringWithFormat:@"%ld",(long)sender.tag-100000000]]]).headerlistarray copyItems:YES];
        }
    }
    selectedtabbutton=sender;
    
    TimeTableTabViewController *tabviewcontroller = (TimeTableTabViewController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil] instantiateViewControllerWithIdentifier: @"TimeTableTabViewController"];
    tabviewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    tabviewcontroller.headertype=headertype;
    tabviewcontroller.headerArray=headerArray;
    tabviewcontroller.TimeTableMode=TimeTableMode;
    tabviewcontroller.selectedHeaderArray=selectedHeaderArray;
    tabviewcontroller.buttontag=sender.tag;
    tabviewcontroller.delegate=self;
    
    UIPopoverPresentationController *mypopovercontroller=tabviewcontroller.popoverPresentationController;
    mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
    mypopovercontroller.sourceView=sender;
    mypopovercontroller.sourceRect=sender.bounds;
    [self presentViewController:tabviewcontroller animated:YES completion:nil];
    
}


-(void) selectallsubjectbuttonpressed:(UIButton *)sender
{
    selectedHeaderArray=[[NSMutableArray alloc]init];
    NSString *item;
    for (int i=0; i<headerArray.count; i++) {
        if ([headertype isEqualToString:@"Subject"]) {
            item=((SubjectRecord *)[headerArray objectAtIndex:i]).subject_shortname;
        }else if ([headertype isEqualToString:@"Classroom"]){
            item=((ClassroomRecord *)[headerArray objectAtIndex:i]).classroom;
        }else{
            item=((Staff *)[headerArray objectAtIndex:i]).username;
        }
        
        
        [selectedHeaderArray addObject:item];
    }
    
    if ([headertype isEqualToString:@"Instructor"]) {
        selectedHeaderArray=[MyClass returnsortedstaffusernamewithstaffusernamearray:selectedHeaderArray];
    }else{
    
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"self" ascending: YES selector:@selector(localizedStandardCompare:)];
    selectedHeaderArray=[NSMutableArray arrayWithArray:[selectedHeaderArray sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]]];
    }
    deselectallsubjectbutton.enabled=YES;
    selectallsubjectbutton.enabled=NO;
    
    [ClassSelectionTable reloadData];
}

-(void) deselectallsubjectbuttonpressed:(UIButton *)sender
{
    selectedHeaderArray=[[NSMutableArray alloc]init];
    [ClassSelectionTable reloadData];
    deselectallsubjectbutton.enabled=NO;
    selectallsubjectbutton.enabled=YES;
}

-(void) selectsubject:(UIButton *)sender
{
    [self popupsubjectselection:sender];
}

-(void) retrievetabviewpreferencewithselecteddatereset:(BOOL)resetdate
{
    globalselecteddate=[self findfirstdayofweeklyview:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"]];
    selectedHeaderArray=[self returnSelectedHeaderArray];
}

-(NSString *) returntabtitlewithselectedheaderarray:(NSMutableArray *)selectedheaderarray
{
    NSMutableArray *result=[[NSMutableArray alloc]init];
    if ([headertype isEqualToString:@"Subject"]) {
        selectedheaderarray=[MyClass returnsortedsubjectlistwithsubjectcodearray:selectedheaderarray];
    }
    
    for (int i=0; i<selectedheaderarray.count; i++) {
        if ([headertype isEqualToString:@"Subject"] ) {
            if(groupsubjectcategory && [headertype isEqualToString:@"All"]){
                NSString *subjectcode=[selectedheaderarray objectAtIndex:i];
                SubjectRecord *object=[MyClass returnsubjectinformationwithsubject_shortname:subjectcode centerkey:globalvariables.centerrecord.centerkey];
                NSString *subjectcategory;
                if (![object.subject_category isEqualToString:@""]) {
                    subjectcategory=[MyClass returnsubjectcategorynamewithscategorykey:object.subject_category];
                }else{
                    subjectcategory=[MyClass returnsubjectnamewithsubject_shortname:[selectedheaderarray objectAtIndex:i] centerkey:globalvariables.centerrecord.centerkey];
                }
                if(![result containsObject:subjectcategory]){
                    [result addObject:subjectcategory];
                }
            }else{
                [result addObject:[MyClass returnsubjectnamewithsubject_shortname:[selectedheaderarray objectAtIndex:i] centerkey:globalvariables.centerrecord.centerkey]];
            }
        }else if ([headertype isEqualToString:@"Classroom"]){
            [result addObject:[selectedheaderarray objectAtIndex:i]];
        }else if ([headertype isEqualToString:@"Instructor"]){
            if([[selectedheaderarray objectAtIndex:i] isEqualToString:@""]){
                [result addObject:[MyClass returntitlewithtitle:@"TBD"]];
            }else{
                [result addObject:((Staff *)[MyClass returnstaffrecordwithusername:[selectedheaderarray objectAtIndex:i]]).firstname];
            }
        }else{
            [result addObject:[MyClass returntitlewithtitle:@"All"]];
        }
    }
    
    return [result componentsJoinedByString:@"/"];
}

-(void) addtabview:(UIButton *)sender
{
    if (headerArray.count==0) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Add Tab"] message:[MyClass returntitlewithtitle:[NSString stringWithFormat:@"No %@ is available",[headertype capitalizedString]]] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        //[self presentViewController:erroralert animated:YES completion:nil];
        [MyClass presentViewController:erroralert View:self];
    }else if (TabArray.count<15) {
        [self popupsubjectselection:sender];
    }else{
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Add Tab"] message:[MyClass returntitlewithtitle:@"Exceed maximum number of allowable tab"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }

}

-(void) updatetabviewpreferencewithoption:(NSString *)option tabid:(long)tabid headerlist:(NSString *)headerlist mode:(NSString *)mode selecteddate:(NSString *)selecteddate
{
    NSString *sql;
    sqlite3_stmt *statement;
    char *err;
    
    if ([option isEqualToString:@"update"]) {
        sql=[NSString stringWithFormat:@"UPDATE tabview SET headerlist='%@', mode='%@',selecteddate='%@' where tabid='%ld'",headerlist, mode,[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:selecteddate],tabid];
        sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,&err);
        
        [TabArray replaceObjectAtIndex:[self returntabarrayindexwithtabid:[NSString stringWithFormat:@"%ld",tabid]] withObject:[[TabRecord alloc]initTabRecordWithtabid:[NSString stringWithFormat:@"%ld",tabid] headerlistarray:[[NSMutableArray alloc]initWithArray:[headerlist componentsSeparatedByString:@"/"]] mode:mode selecteddate:selecteddate]];
        
    }else if ([option isEqualToString:@"insert"]){
        sql=[NSString stringWithFormat:@"INSERT into tabview ('headerlist','centerkey','username','mode','selecteddate','headertype') VALUES ('%@','%@','%@','%@','%@','%@')",headerlist,globalvariables.centerrecord.centerkey,globalvariables.username,mode,[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:selecteddate],headertype];
        sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,NULL);
        
        sql =[NSString stringWithFormat:@"SELECT last_insert_rowid()"];
        if(sqlite3_prepare_v2(globalvariables.isdb, [sql UTF8String], -1, &statement, nil)==SQLITE_OK){
            while (sqlite3_step(statement)==SQLITE_ROW) {
                [TabArray addObject:[[TabRecord alloc]initTabRecordWithtabid:[[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 0)] headerlistarray:[[NSMutableArray alloc]initWithArray:[headerlist componentsSeparatedByString:@"/"]] mode:mode  selecteddate:selecteddate]];
                //[TabIDArray addObject:[[NSString alloc]initWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
            }
        }
    }else if ([option isEqualToString:@"delete"]){
        sql=[NSString stringWithFormat:@"DELETE from tabview where tabid='%ld' and centerkey='%@'",tabid,globalvariables.centerrecord.centerkey];
        sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,NULL);
        
        [TabArray removeObjectAtIndex:[self returntabarrayindexwithtabid:[NSString stringWithFormat:@"%ld",tabid]]];
    }
}

-(void) drawtabviewaddicon
{
    
    if (addicon) {
        [addicon removeFromSuperlayer];
    }
    
    CGFloat xposition;
    CGFloat yposition;
    CGFloat width;

    width=16;
    
    xposition=(TabAddButton.frame.size.width-width)/2;
    yposition=tabheight/2;
    
    addicon = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,xposition,yposition);
    CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition);

    CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-width/2);
    CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition);
    CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
    CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition);
    CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+width/2);
    CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition);
    CGPathAddLineToPoint(path, NULL, xposition, yposition);
    
    [addicon setPath:path];
    addicon.strokeColor = [UIColor whiteColor].CGColor;
    addicon.lineWidth = 1.0f;
    [[TabAddButton layer] addSublayer:addicon];
    
    CGPathRelease(path);
    
}

-(void) drawdeleteviewaddicon
{
    
    if (deleteicon) {
        //[deleteicon removeFromSuperlayer];
    }
    
    CGFloat xposition;
    CGFloat yposition;
    CGFloat width;
    
    width=10;
    
    xposition=5;
    yposition=(tabheight-width)/2;
    
    deleteicon = [CAShapeLayer layer];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL,xposition,yposition);
    CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+width/2);
    
    CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
    CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+width/2);
    CGPathAddLineToPoint(path, NULL, xposition+width, yposition+width);
    CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+width/2);
    CGPathAddLineToPoint(path, NULL, xposition, yposition+width);
    CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+width/2);
    CGPathAddLineToPoint(path, NULL, xposition, yposition);
    
    [deleteicon setPath:path];
    deleteicon.strokeColor = [UIColor lightGrayColor].CGColor;
    deleteicon.lineWidth = 1.0f;
    [[TabDeleteButton layer] addSublayer:deleteicon];
    
    CGPathRelease(path);
    
}


-(IBAction) selectclasstype:(UIButton *)sender
{
    
    
    // add group selection tables
    ClassTypeSelectionTable=[[UITableView alloc]init];
    ClassTypeSelectionTable.separatorColor=[UIColor clearColor];
    ClassTypeSelectionTable.delegate=self;
    ClassTypeSelectionTable.dataSource=self;
    [ClassTypeSelectionTable reloadData];
    ClassTypeSelectionTable.frame=CGRectMake(0, 0, 200, ClassTypeSelectionTable.contentSize.height);
    ClassTypeSelectionTable.separatorColor=[UIColor clearColor];
    
    UIView *classTypeSelectionMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, ClassTypeSelectionTable.contentSize.height)];
    [classTypeSelectionMasterView addSubview:ClassTypeSelectionTable];
    
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=classTypeSelectionMasterView;
    viewcontroller.preferredContentSize=CGSizeMake(200, ClassTypeSelectionTable.contentSize.height);
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myClassTypeSelectionPopoverController=viewcontroller.popoverPresentationController;
    myClassTypeSelectionPopoverController.delegate=self;
    myClassTypeSelectionPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myClassTypeSelectionPopoverController.sourceView=sender;
    myClassTypeSelectionPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    [self drawclasstypepointerwithoption:@"open"];
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

-(IBAction) filterbuttonpressed:(UIButton *)sender
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSMutableDictionary *selecteditems=[[NSMutableDictionary alloc]init];
        [selecteditems setValue:selectedSubjectArray forKey:@"subject"];
        [selecteditems setValue:selectedClassroomArray forKey:@"classroom"];
        [selecteditems setValue:selectedInstructorArray forKey:@"instructor"];
        
        TimeTableFilterViewController *viewcontroller = (TimeTableFilterViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"TimeTableFilterViewController"];
        viewcontroller.delegate=self;
        viewcontroller.selectedItems=selecteditems;
        viewcontroller.headertype=headertype;
        [self startsidewindowanimationwithwidth:480];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            viewcontroller.view.frame=CGRectMake(0, 0, 480, mainWindow.bounds.size.height);//self->mainWindow.bounds;
            [self->sidewindowview addSubview:viewcontroller.view];
            [self addChildViewController:viewcontroller];
            [viewcontroller didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            self->ailoadindicator.hidden=YES;
        });
        
    });
}


-(void) viewoptionbuttonpressed:(UIButton *)sender
{
    sender.userInteractionEnabled=NO;

    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self instructorclassroomview];

    });
}

-(void) filterview
{
    ClassScheduleTableShown=FALSE;
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    NSString *lastfiltermode=filtermode;
    
    filtermode=[lastfiltermode isEqualToString:@"On"]?@"Off":@"On";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([self generateTimeTablewithViewOption:TimeTableMode pastMonday:globalselecteddate classtype:classtypeselected redrawscoller:YES]){
            
            float newtimelabelwidth=[self returnclasstimewidth];
            if (TimeLabel.frame.size.width!=newtimelabelwidth) {
                //redraw class time
                [[classTimeView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
                //[classTimeView setContentOffset:CGPointMake(0, 0)];
                
                for (int i=0; i<classTime.count; i++) {
                    UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*cellheight, newtimelabelwidth, cellheight)];
                    timeLabel.textAlignment=NSTextAlignmentCenter;
                    [timeLabel setFont:[UIFont systemFontOfSize:12]];
                    timeLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
                    timeLabel.layer.borderWidth=0.3;
                    timeLabel.text=[classTime objectAtIndex:i];
                    timeLabel.backgroundColor=(i/(60/(NSInteger)cellduration) %2)==0?[UIColor whiteColor]:[UIColor systemGroupedBackgroundColor];
                    //timeLabel.tag=888;
                    [classTimeView addSubview:timeLabel];
                }
            }
            
            if ([filtermode isEqualToString:@"On"]) {
                [filterbutton setImage:[UIImage imageNamed:@"filteronbutton_white.png"] forState:UIControlStateNormal];
            }else{
                [filterbutton setImage:[UIImage imageNamed:@"filteroffbutton_white.png"] forState:UIControlStateNormal];
            }
        }else{
            filtermode=lastfiltermode;
        }
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        filterbutton.userInteractionEnabled=YES;
    });
    
}

-(void) instructorclassroomview
{
    ClassScheduleTableShown=FALSE;
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    NSString *lastmode=contentmode;
    
    contentmode=[lastmode isEqualToString:@"instructor"]?@"classroom":@"instructor";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if([self generateTimeTablewithViewOption:TimeTableMode pastMonday:globalselecteddate classtype:classtypeselected redrawscoller:YES]){
            
        }else{
            contentmode=lastmode;
        }
//        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        viewoptionbutton.userInteractionEnabled=YES;
    });
    
}





-(ClassTimeTableRecord *) timeSlotContainsInstructorClassWithInstructor:(NSString *)instructor ClassDay:(NSString *)classday ClassTime:(NSString *)classtime Subject:(NSString *)subject Classroom:(NSString *)classroom
{

    NSDate *cellpressedtime;
    NSDate *freeclassstarttime;
    
    NSString *cellposition=[self returnclasstimetableallarraypositionwithclassday:classday classtime:classtime subject:subject classroom:classroom instructor:instructor];
    NSString *newcellposition;
    if (![cellposition isEqualToString:@"NA"]) {
        
        int count = [((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:Subjectselected centerkey:globalvariables.centerrecord.centerkey]).classduration intValue]/[globalvariables.centerrecord.classtimeinterval intValue];
        for (int k=0; k<count-count+1; k++) {
            newcellposition=[NSString stringWithFormat:@"%ld",[cellposition intValue]+totalSubjectColumn*k];
            
            NSMutableArray *classtimetablerecordarray=[ClassTimeTableRecordDictionary objectForKey:newcellposition];
            if (classtimetablerecordarray) {
                //NSMutableArray *classtimetablerecordarray = [ClassTimeTableAllArray objectAtIndex:[ClassSchedulePositionArray indexOfObject:newcellposition]];
                ClassTimeTableRecord *classtimetablerecord=[[ClassTimeTableRecord alloc]init];
                for (int i=0; i<classtimetablerecordarray.count; i++) {
                    classtimetablerecord=[classtimetablerecordarray objectAtIndex:i];
                    
                    cellpressedtime=[MyClass convertToNSDateWithDate:[NSString stringWithFormat:@"%@ %@",selectedstartdate,classtime] DateFormat:@"dd-MMM-yyyy HH:mm"];
                    freeclassstarttime=[MyClass convertToNSDateWithDate:[NSString stringWithFormat:@"%@ %@",selectedstartdate,classtimetablerecord.classtime] DateFormat:@"dd-MMM-yyyy HH:mm"];
                    
                    if ([classtimetablerecord.instructor isEqualToString:instructor] && [classtimetablerecord.classday isEqualToString:classday] && [classtimetablerecord.subject isEqualToString:subject]) {
                        if ([cellpressedtime compare:[freeclassstarttime dateByAddingTimeInterval:[((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:Subjectselected centerkey:globalvariables.centerrecord.centerkey]).classduration intValue]*60]]==NSOrderedAscending || [freeclassstarttime compare:[cellpressedtime dateByAddingTimeInterval:[((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:Subjectselected centerkey:globalvariables.centerrecord.centerkey]).classduration intValue]*60]]==NSOrderedAscending) {
                            return classtimetablerecord;
                        }

                    }
                }
            }
        }
        return nil;
    }else{
        return nil;
    }

}

-(FreeScheduleClass *) classAlreadySelectedWithClassDate:(NSString *)classdate ClassTime:(NSString *)classtime
{
    
    NSDate *cellpressedtime;
    NSDate *freeclassstarttime;
    
    cellpressedtime=[MyClass convertToNSDateWithDate:[NSString stringWithFormat:@"%@ %@",classdate,classtime] DateFormat:@"dd-MMM-yyyy HH:mm"];
    
    for (int i=0; i<FreeScheduleClassArray.count; i++) {
        FreeScheduleClassObject=[FreeScheduleClassArray objectAtIndex:i];
        if (![FreeScheduleClassObject.action isEqualToString:@"Delete"]) {

            freeclassstarttime=[MyClass convertToNSDateWithDate:[NSString stringWithFormat:@"%@ %@",FreeScheduleClassObject.classdate,FreeScheduleClassObject.classtime] DateFormat:@"dd-MMM-yyyy HH:mm"];
            if ([classdate isEqualToString:FreeScheduleClassObject.classdate]) {
                if (([cellpressedtime compare:[freeclassstarttime dateByAddingTimeInterval:[((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:Subjectselected centerkey:globalvariables.centerrecord.centerkey]).classduration intValue]*60]]==NSOrderedAscending && [cellpressedtime compare:freeclassstarttime]!=NSOrderedAscending)|| ([freeclassstarttime compare:[cellpressedtime dateByAddingTimeInterval:[((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:Subjectselected centerkey:globalvariables.centerrecord.centerkey]).classduration intValue]*60]]==NSOrderedAscending && [freeclassstarttime compare:cellpressedtime]!=NSOrderedAscending)) {
                    
                    return FreeScheduleClassObject;
                }
            }
        }
    }
    return nil;
}

-(NSString *) findfirstdayofweeklyview:(NSString *)dayintheweek
{
    NSDate *day=[MyClass convertToNSDateWithDate:dayintheweek DateFormat:@"dd-MMM-yyy"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:day];
    
    NSUInteger weekdayToday = [components weekday];
    NSInteger daysToFirstday=weekdayToday-1/*[MyClass returndayofweeknumber:[globalvariables.centerdayofweekarray objectAtIndex:0]]*/;
    NSDate *firstdayofweek = [day dateByAddingTimeInterval:60*60*24*(-daysToFirstday)];

    NSString *firstday=[MyClass convertToNSStringWithNSDate:firstdayofweek DateFormat:@"dd-MMM-yyyy"];
    return firstday;
}


-(NSString *) findsundayintheweek:(NSString *)dayintheweek
{
    NSDate *day=[MyClass convertToNSDateWithDate:dayintheweek DateFormat:@"dd-MMM-yyy"];
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:day];
    
    NSUInteger weekdayToday = [components weekday];
    NSInteger daysToFirstday=weekdayToday-[MyClass returndayofweeknumber:@"Sun"];
    NSDate *firstdayofweek = [day dateByAddingTimeInterval:60*60*24*(-daysToFirstday)];

    return [MyClass convertToNSStringWithNSDate:firstdayofweek DateFormat:@"dd-MMM-yyyy"];
}


-(NSString *) findclosestfirstdayofweeklyview:(NSString *)date
{
    NSDate *day=[MyClass convertToNSDateWithDate:date DateFormat:@"dd-MMM-yyy"];
    NSDate *firstdayofweek;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitDay fromDate:day];
    
    NSUInteger weekdayToday = [components weekday];
    NSInteger daysToPreviousFirstday=weekdayToday-[MyClass returndayofweeknumber:[globalvariables.centerdayofweekarray objectAtIndex:0]];
    NSInteger daysToNextFirstday=7-daysToPreviousFirstday;
    
    if (daysToPreviousFirstday<daysToNextFirstday) {
        firstdayofweek = [day dateByAddingTimeInterval:60*60*24*(-daysToPreviousFirstday)];
    }else{
        firstdayofweek = [day dateByAddingTimeInterval:60*60*24*daysToNextFirstday];
    }
    
    return [MyClass convertToNSStringWithNSDate:firstdayofweek DateFormat:@"dd-MMM-yyyy"];
}



-(NSString *) adjustselecteddate:(NSString *)selecteddate mode:(NSString *)mode tabid:(NSString *)tabid headerlist:(NSString *)headerlist
{
    NSString *resultdate;
    if ([mode isEqualToString:@"Weekly"]) {
        resultdate=[self findfirstdayofweeklyview:selecteddate];
    }else{
        NSDate *previousday = [[MyClass convertToNSDateWithDate:selecteddate DateFormat:@"dd-MMM-yyyy"] dateByAddingTimeInterval:-86400];
        NSString * todaystring=[MyClass findNextWorkDay2:previousday includereserveddate:YES];
        NSDate *today=[MyClass convertToNSDateWithDate:todaystring DateFormat:@"dd-MMM-yyyy"];
        resultdate=[MyClass convertToNSStringWithNSDate:today DateFormat:@"dd-MMM-yyyy"];
    }
    
    //update tabview sql db
    if (![resultdate isEqualToString:selecteddate]) {
        NSString *sql;
        sql=[NSString stringWithFormat:@"UPDATE tabview SET selecteddate='%@' where tabid='%@'",[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:resultdate],tabid];
        sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,NULL);
    }
    
    return resultdate;
}

-(void) showemptyheadermessage
{
    datebartable.hidden=YES;
    
//    emptytabmessagelabel=[[UILabel alloc]initWithFrame:CGRectMake([self returnclasstimewidth]+tablex, tabley+66, totalSubjectColumn*cellwidth , NoOfTimeSlot*cellheight)];
    emptytabmessagelabel=[[UILabel alloc]initWithFrame:superview.frame];
    emptytabmessagelabel.layer.borderColor=[UIColor blackColor].CGColor;
    emptytabmessagelabel.layer.borderWidth=0.3;
    emptytabmessagelabel.tag=777;
    emptytabmessagelabel.textAlignment=NSTextAlignmentCenter;
    [emptytabmessagelabel setFont:[UIFont systemFontOfSize:18]];
//    emptytabmessagelabel.text=[MyClass returntitlewithtitle:@"Please tap on \"+\" in above to add tab"];
    emptytabmessagelabel.text=[MyClass returntitlewithtitle:@"No data being Shown. Please adjust your filter settings"];
    emptytabmessagelabel.backgroundColor=[UIColor systemGroupedBackgroundColor];
    emptytabmessagelabel.textColor=[UIColor grayColor];
    [supermasterview addSubview:emptytabmessagelabel];
}

-(UIColor *) returninstructorcolor:(NSString *)instructor
{
    Staff *object=[MyClass returnstaffrecordwithusername:instructor];
    if (object) {
        return [globalvariables.colorcodearray objectAtIndex:object.colorcode];
    }else{
        return [globalvariables.colorcodearray objectAtIndex:globalvariables.centerrecord.timetabletbdinstructorcolorcode];
    }
}


-(UIColor *) returnclassroomcolor:(NSString *)classroom
{
    ClassroomRecord *object=[MyClass returnclassroominformationwithclassroom:classroom centerkey:globalvariables.centerrecord.centerkey];
    if (object) {
        return [globalvariables.colorcodearray objectAtIndex:object.colorcode];
    }else{
        return [globalvariables.colorcodearray objectAtIndex:globalvariables.centerrecord.timetabletbdclassroomcolorcode];
    }
}


-(UIColor *) returnsubjectcolor:(NSString *)subject
{
    SubjectRecord *object=[MyClass returnsubjectinformationwithsubject_shortname:subject centerkey:globalvariables.centerrecord.centerkey];
    if (object) {
        return [globalvariables.colorcodearray objectAtIndex:object.colorcode];
    }else{
        return [globalvariables.colorcodearray lastObject];
    }
}

-(void) InstructorButtonPressed:(UIButton *)sender
{
    //popup make up information
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    instructorimagepopover = (InstructorImageGridViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"InstructorImageGridViewController"];
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
    
    /*
    FreeScheduleClass *freescheduleclasspicker=[[FreeScheduleClass alloc]init];
    freescheduleclasspicker=[FreeScheduleClassArray objectAtIndex:selectedfreeclassrow/2];
    [self removefreeclassschedulearraywithclassdate:freescheduleclasspicker.classdate classtime:freescheduleclasspicker.classtime instructor:freescheduleclasspicker.instructor index:selectedfreeclassrow/2];
    
    [self addfreeclassschedulearraywithclassdate:freescheduleclasspicker.classdate classtime:freescheduleclasspicker.classtime instructor:username classroom:freescheduleclasspicker.classroom classremarks:freescheduleclasspicker.classremarks allclassremarks:freescheduleclasspicker.allclassremarks preferredrow:selectedfreeclassrow/2];
    
    
    
    if (![freescheduleclasspicker.instructor isEqualToString:@"TBD"]) {
        if (![InstructorNameArray containsObject:username]) {
            [InstructorNameArray addObject:username];
            [self drawInstructorLegend];
        }
    }
    
    preferredinstructor=username;
    
    selectedfreeclassrow=-1;
    [FreeScheduleTable reloadData];
    FreeScheduleTable.frame=CGRectMake(0, 44+22, freescheduletablewidth, FreeScheduleTable.contentSize.height);
    myFreeSchedulePopoverController.popoverContentSize=CGSizeMake(freescheduletablewidth, FreeScheduleTable.contentSize.height+44+22);*/
}



-(void) selectinstructorbuttonpressed:(UIButton *)sender
{
    //popup make up information
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    instructorimagepopover = (InstructorImageGridViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"InstructorImageGridViewController"];
    instructorimagepopover.delegate=self;
    instructorimagepopover.instructorArray=[MyClass filterInstructorArrayWithInstructorArray:InstructorArray Valid:@"Yes"];
    instructorimagepopover.mode=@"multiple";
    instructorimagepopover.selectedinstructorarray=[[NSMutableArray alloc]initWithArray:[instructorselected componentsSeparatedByString:@","]];
    instructorimagepopover.modalPresentationStyle = UIModalPresentationFormSheet;
    //[self presentViewController:instructorimagepopover animated:YES completion: nil];
    [MyClass presentViewController:instructorimagepopover View:self];
}

-(void) passinstructorlistfromgrid:(NSString *)instructorlist
{
    ClassScheduleTableShown=FALSE;
    [self dismissViewControllerAnimated:YES completion:nil];
    instructorselected=instructorlist;
    if ([instructorlist isEqualToString:@"All"]) {
        [selectinstructorbutton setImage:[UIImage imageNamed:@"instructoricon_white.png"] forState:UIControlStateNormal];
    }else{
        [selectinstructorbutton setImage:[UIImage imageNamed:@"instructoricon.png"] forState:UIControlStateNormal];
    }
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self generateTimeTablewithViewOption:TimeTableMode pastMonday:tmpselecteddate classtype:classtypeselected redrawscoller:YES];
    });

    
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

-(void) removeEmptyMessageLabel
{
    for (UIView *subview in supermasterview.subviews)
    {
        if (subview.tag==777) {
            [subview removeFromSuperview];
        }
    }
}

-(void) doneswitchcenterwithreload:(BOOL)reload centerkey:(NSString *)centerkey centerimage:(UIImage *)centerimage
{
    //[switchcenterviewcontroller dismissViewControllerAnimated:YES completion:nil];
    
    if (reload) {
        
        systemmessagelabel.frame=CGRectMake(tablex+[self returnclasstimewidth], tabley+66, datebartable.frame.size.width, NoOfTimeSlot*cellheight+extraheight);
        systemmessagelabel.hidden=NO;
        
        datebartable.hidden=YES;
        
        [self removeEmptyMessageLabel];
        
        if (ClassScheduleTableShown) {
            ClassScheduleTableShown=FALSE;
            vfl.masterViewheight=0;
            [timetablecollectionview reloadData];
            
            [[classTimeView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
            [classTimeView setContentOffset:CGPointMake(0, 0)];
            
            for (int i=0; i<classTime.count; i++) {
                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*cellheight, [self returnclasstimewidth], cellheight)];
                timeLabel.textAlignment=NSTextAlignmentCenter;
                [timeLabel setFont:[UIFont systemFontOfSize:12]];
                timeLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
                timeLabel.layer.borderWidth=0.3;
                timeLabel.text=[classTime objectAtIndex:i];
                timeLabel.backgroundColor=(i/(60/(NSInteger)cellduration) %2)==0?[UIColor whiteColor]:[UIColor systemGroupedBackgroundColor];
                //timeLabel.tag=888;
                [classTimeView addSubview:timeLabel];
            }
        }
        
        globalvariables.documentfolder.classreceiptarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salesreceiptarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.classinvoicearray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salesinvoicearray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.classpaymentarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salespaymentarray=[[NSMutableArray alloc]init];
        [MyClass retrievemenuimagewithasync:YES];
        
        if (!detailViewMode) {
            timetablecollectionview.contentOffset=CGPointMake(0, 0);
        }
        
        [self reloadPageWithFirstLoad:NO];
    }
}

/*
-(void) refreshpage
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyClass retrievemenuimagewithasync:YES];
        [MyClass retrievecenterimages];
        [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,product,staff,classroom,marketing,centersettings,userroleandprivilege" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
        [MyClass LoadSchoolCalendarArray];
        [self refreshlanguage];
        [MyClass updatecenterkey];
        [self viewDidAppear:YES];
        
        
    });
}*/

-(void) reloadPageWithFirstLoad:(BOOL)firstload
{
    ClassScheduleTableShown=NO;
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,staff,classroom,centersettings,userroleandprivilege,student,lead,arcode" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
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

                [MyClass updatecenterkey];
                [self refreshlanguage];
                
                if ([((UserPrivilege *)[MyClass returnuserprivilegewithcenterkey:globalvariables.centerrecord.centerkey]).role isEqualToString:@"Instructor"]) {
                    if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).viewallinstructorclass) {
                        instructorselected=@"All";
                        selectinstructorbutton.hidden=NO;
                    }else{
                        instructorselected=globalvariables.username;
                        selectinstructorbutton.hidden=YES;
                        scviewtype.frame=CGRectMake(382, 75, 325, 29);
                    }
                }else{
                    selectinstructorbutton.hidden=NO;
                    instructorselected=@"All";
                }
                

                
                if ([headertype isEqualToString:@"Subject"]) {
                    headerArray=[MyClass retrievesubjectinformationwithstatus:@"All" category:@"All" flushcachedata:NO];
                }else if ([headertype isEqualToString:@"Classroom"]){
                    headerArray=[MyClass retrieveClassroomListwithstatus:@"All" withTBD:NO flushcachedata:NO];
                }else if ([headertype isEqualToString:@"Instructor"]){
                    headerArray=[MyClass retrieveStaffListwithvalid:@"All" role:@"Instructor" flushcachedata:NO];
                }else{
                    headerArray=[[NSMutableArray alloc]initWithObjects:@"All", nil];
                }
                

                
                if (!headerArray) {
                    reloadbutton.hidden=NO;
                    nointernet=YES;
                    selectedHeaderArray=[[NSMutableArray alloc]initWithObjects:@"", nil];
                    
                }else{
                    nointernet=NO;
                    reloadbutton.hidden=YES;
                }
                
                //[self loadschoolcalendar];
                InstructorArray=[MyClass retrieveInstructorListwithvalid:@"All" addTBD:YES flushcachedata:NO];
                AvailableInstructorNameArray=[MyClass retrieveInstructorListwithvalid:@"Yes" addTBD:YES flushcachedata:NO];
                AvailableClassroomArray=[MyClass retrieveClassroomListwithstatus:@"All" withTBD:YES flushcachedata:NO];
                AvailableSubjectNameArray=[MyClass retrievesubjectinformationwithstatus:@"All" category:@"All" flushcachedata:NO];
                
                NSMutableDictionary *localdict=[self getTimeTableFilterValues];
                if(localdict.count==0 || ![localdict valueForKey:globalvariables.centerrecord.centerkey]){
                    selectedInstructorArray=nil;
                    selectedSubjectArray=nil;
                    selectedClassroomArray=nil;
                }else{
                    NSMutableDictionary *json = [localdict valueForKey:globalvariables.centerrecord.centerkey];
                    if ([[json valueForKey:@"Subject"] isKindOfClass:[NSString class]]) {
                        selectedSubjectArray=nil;
                    }else{
                        selectedSubjectArray=[[NSMutableArray alloc]initWithArray:[json valueForKey:@"Subject"]];
                    }
                    if ([[json valueForKey:@"Instructor"] isKindOfClass:[NSString class]]) {
                        selectedInstructorArray=nil;
                    }else{
                        selectedInstructorArray=[[NSMutableArray alloc]initWithArray:[json valueForKey:@"Instructor"]];
                    }
                    if ([[json valueForKey:@"Classroom"] isKindOfClass:[NSString class]]) {
                        selectedClassroomArray=nil;
                    }else{
                        selectedClassroomArray=[[NSMutableArray alloc]initWithArray:[json valueForKey:@"Classroom"]];
                    }
                }
                
                [self retrievetabviewpreferencewithselecteddatereset:YES];
                
                
                
                
                
                
                TabAddButton.hidden=[headertype isEqualToString:@"All"];
//                filterbutton.enabled=![headertype isEqualToString:@"All"];
                legendscrollview.hidden=[headertype isEqualToString:@"All"] && !detailViewMode;
                
                
                //create table
                long currenttimetableheight =NoOfTimeSlot*cellheight;
                classTime=[[NSMutableArray alloc]init];
                NoOfTimeSlot=[MyClass returnTimeTableNoOfTimeSlotWithCellDuration:cellduration];
                //NoOfTimeSlot=([[globalvariables.centerrecord.classendtime substringToIndex:2] intValue]*60 + [[globalvariables.centerrecord.classendtime substringFromIndex:2] intValue] - ([[globalvariables.centerrecord.classstarttime substringToIndex:2] intValue]*60 + [[globalvariables.centerrecord.classstarttime substringFromIndex:2] intValue]))/cellduration;
                //cellheight=[self returncellheight];
                
                NSDate *date=[MyClass convertToNSDateWithDate:globalvariables.centerrecord.fullday?@"0000":globalvariables.centerrecord.classstarttime DateFormat:@"HHmm"];
                for (int i=0; i<NoOfTimeSlot; i++) {
                    [classTime addObject:[MyClass convertToNSStringWithNSDate:[date dateByAddingTimeInterval:30*60*i] DateFormat:@"HH:mm"]];
                }
                
                if(!weeklyMode){
                    NSString *dayofweek=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"EEE"];
                    globalvariables.centerdayofweekarray=[[NSMutableArray alloc]initWithObjects:dayofweek, nil];
                    if(!dailydateselected){
                        dailydateselected=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"];
                    }
                }
                
                classDay=[[NSMutableArray alloc]initWithArray:globalvariables.centerdayofweekarray copyItems:YES];
//                if (!selectedHeaderArray) {
//                    selectedHeaderArray=[[NSMutableArray alloc]initWithObjects:@"", nil];
//                }
//                
//                if (selectedHeaderArray.count==0) {
//                    cellwidth=[self returncellwidth:timetablewidth/classDay.count];
//                    totalSubjectColumn=classDay.count;
//                    [self showemptyheadermessage];
//                }else{
//                    cellwidth=[self returncellwidth:timetablewidth/classDay.count/selectedHeaderArray.count];
//                    totalSubjectColumn=selectedHeaderArray.count*classDay.count;
//                }
                
                CGFloat timetableoffset=[self returnclasstimewidth];
                [reloadbutton setFrame:CGRectMake(725, totalSubjectColumn*cellwidth/2, 25,25)];
                [supermasterview bringSubviewToFront:reloadbutton];


                [self drawclasstypepointerwithoption:@"closed"];
                preferredinstructorset=FALSE;
                
                if ([TimeTableMode isEqualToString:@"PopoverConsolidated"]) {
                    scviewtype.hidden=YES;
                    selectinstructorbutton.hidden=YES;
                    ClassTypeSelectionButton.hidden=YES;
                    scscheduletype.hidden=[sourcemode isEqualToString:@"Enrollment"]?YES:NO;
                    currentscscheduleindex=0;
                    filterbutton.hidden=YES;
                    viewoptionbutton.hidden=YES;
                    menubutton.hidden=YES;
                }else if ([TimeTableMode isEqualToString:@"PopoverWeekly"]){
                    scviewtype.hidden=YES;
                    selectinstructorbutton.hidden=YES;
                    ClassTypeSelectionButton.hidden=YES;
                    if ([sourcemode isEqualToString:@"Enrollment"]) {
                        if ([EnrollmentMode isEqualToString:@"Free"]) {
                            scscheduletype.hidden=NO;
                        }else{
                            scscheduletype.hidden=YES;
                        }
                    }else{
                        scscheduletype.hidden=YES;
                    }
                    
                    currentscscheduleindex=1;
                    filterbutton.hidden=[sourcemode isEqualToString:@"Enrollment"]?YES:NO;
                    viewoptionbutton.hidden=YES;
                    menubutton.hidden=YES;
                }else{
                    ClassTypeSelectionButton.hidden=NO;
                    scviewtype.selectedSegmentIndex=1;
                    scscheduletype.hidden=YES;
                    filterbutton.hidden=NO;
                    viewoptionbutton.hidden=NO;
                    menubutton.hidden=NO;
                }
                
                if (!nointernet) {
                    if (popovermode) {
                        ShareButton.hidden=YES;
                        CancelButton.hidden=NO;
                    }else{
                        CancelButton.hidden=YES;
                        ShareButton.hidden=NO;
                        ShareButton.hidden=!detailViewMode;
                    }
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self initializeDetailClassMasterView];
//                        InstructorArray=[MyClass retrieveInstructorListwithvalid:@"All" addTBD:YES flushcachedata:NO];
                        /*AvailableInstructorNameArray=[MyClass retrieveInstructorListwithvalid:@"Yes" addTBD:YES flushcachedata:NO];
                        AvailableClassroomArray=[MyClass retrieveClassroomListwithstatus:@"All" withTBD:YES flushcachedata:NO];
                        AvailableSubjectNameArray=[MyClass retrievesubjectinformationwithstatus:@"All" category:@"All" flushcachedata:NO];
                        
                        NSMutableDictionary *localdict=[self getTimeTableFilterValues];
                        if(localdict.count==0 || ![localdict valueForKey:globalvariables.centerrecord.centerkey]){
                            selectedInstructorArray=nil;
                            selectedSubjectArray=nil;
                            selectedClassroomArray=nil;
                        }else{
                            NSMutableDictionary *json = [localdict valueForKey:globalvariables.centerrecord.centerkey];
                            if ([[json valueForKey:@"Subject"] isKindOfClass:[NSString class]]) {
                                selectedSubjectArray=nil;
                            }else{
                                selectedSubjectArray=[[NSMutableArray alloc]initWithArray:[json valueForKey:@"Subject"]];
                            }
                            if ([[json valueForKey:@"Instructor"] isKindOfClass:[NSString class]]) {
                                selectedInstructorArray=nil;
                            }else{
                                selectedInstructorArray=[[NSMutableArray alloc]initWithArray:[json valueForKey:@"Instructor"]];
                            }
                            if ([[json valueForKey:@"Classroom"] isKindOfClass:[NSString class]]) {
                                selectedClassroomArray=nil;
                            }else{
                                selectedClassroomArray=[[NSMutableArray alloc]initWithArray:[json valueForKey:@"Classroom"]];
                            }
                        }*/
                        
                        [self delayviewload];
                        
                        //cellheight=[self returncellheight];
                        //update screen if new is taller
                        if (currenttimetableheight<NoOfTimeSlot*cellheight) {
                            systemmessagelabel.frame=CGRectMake(tablex+timetableoffset, tabley+66, datebartable.frame.size.width, NoOfTimeSlot*cellheight+extraheight);
                            
                            //remove class time
                            [[classTimeView subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
                            for (int i=0; i<classTime.count; i++) {
                                UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*cellheight, timetableoffset, cellheight)];
                                timeLabel.textAlignment=NSTextAlignmentCenter;
                                [timeLabel setFont:[UIFont systemFontOfSize:12]];
                                timeLabel.layer.borderColor=[UIColor lightGrayColor].CGColor;
                                timeLabel.layer.borderWidth=0.3;
                                timeLabel.text=[classTime objectAtIndex:i];
                                timeLabel.backgroundColor=(i/(60/(NSInteger)cellduration) %2)==0?[UIColor lightGrayColor]:[UIColor whiteColor];
                                [classTimeView addSubview:timeLabel];
                            }

                            
                            classTimeView.frame=CGRectMake(0, superviewclearence+66, timetableoffset, NoOfTimeSlot*cellheight);
                            TimeLabel.frame=CGRectMake(tablex, superviewclearence, timetableoffset, 66);
                            datebartablebackground.hidden=NO;
                        }

                        if (systemmessagelabel.frame.size.width==0) {
                            systemmessagelabel.frame=CGRectMake(tablex+timetableoffset, tabley+66, self.view.bounds.size.width-timetableoffset, NoOfTimeSlot*cellheight);
                        }
                    });
                    
                }else{
                    [MyClass loadingindicatorwithoption:@"stop" color:nil];
                }
                
            }
        });
                
            
        }];
    });
}

-(void) returncellheight
{
//    float cell_height;
//    NSLog(@"%f %f",masterScrollView.frame.size.height,classTimeView.frame.size.height);
    if (detailViewMode) {
        float height;
        float width;
        if(zoommode==0){
            height=(self.view.frame.size.height-tabley-66)/(float)NoOfTimeSlot;
        }else if (zoommode==1){
            height = 40;
        }else{
            height = 100;
        }
        if(height*(float)NoOfTimeSlot<(self.view.frame.size.height-tabley-66)){
            height=(self.view.frame.size.height-tabley-66)/(float)NoOfTimeSlot;
        }
        cellheight= height;
        
        long totalcellwidthcount=[[headerWidthArray lastObject] integerValue]+[[headerPositionArray lastObject] integerValue];
        if(zoommode==0){
            width=(self.view.frame.size.width-[self returnclasstimewidth])/(float)totalcellwidthcount;
        }else if (zoommode==1){
            width = 50.0;
        }else{
            width = 150;
        }

        if(width<(self.view.frame.size.width-[self returnclasstimewidth])/(float)totalcellwidthcount){
            width=(self.view.frame.size.width-[self returnclasstimewidth])/(float)totalcellwidthcount;
        }
//        NSLog(@"%f %f %f",self.view.frame.size.width,([[headerWidthArray lastObject] floatValue]+[[headerPositionArray lastObject] floatValue]),964.0/28.0);
//        width=964.0/28.0;
        mincellwidthfordetailview=width;
        
//        if ([globalvariables.centerrecord.classtimeinterval intValue]>60) {
//            cell_height= ([globalvariables.centerrecord.classtimeinterval intValue]/60)*180;
//        }else{
//            if ([globalvariables.centerrecord.classtimeinterval intValue]==15) {
//                cell_height= 70;
//                if (minclassduration>30) {
//                    cell_height=cell_height/2;
//                }
//            }else if ([globalvariables.centerrecord.classtimeinterval intValue]==30) {
//                cell_height= 100;
//            }else if ([globalvariables.centerrecord.classtimeinterval intValue]==45) {
//                cell_height= 140;
//            }else{//} if ([globalvariables.centerrecord.classtimeinterval intValue]==60) {
//                cell_height= 180;
//            }
//        }
//
//
//        return cell_height;
        
    }else{
        if (totalcellheight/NoOfTimeSlot<mincellheightforcountview) {
            cellheight= mincellheightforcountview;
        }else{
            cellheight= totalcellheight/NoOfTimeSlot;
        }
    }
}

-(CGFloat) returncellwidth:(CGFloat)proposedwidth
{
    CGFloat width;
    if (proposedwidth/maxNoOfItemInACell<minitemwidthforcountview) {
        width=minitemwidthforcountview*maxNoOfItemInACell;
    }else{
        width=proposedwidth;
    }
    
    return width<minicellwidthforcountview?minicellwidthforcountview:width;
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
    sidewindowviewclosebutton.hidden=width==0?YES:NO;
    
}

-(void) closesidewindow
{
    [self adjustpresentingviewwidthwithwidth:0];
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
    globalselecteddate=[self findfirstdayofweeklyview:[selecteddatearray firstObject]];
    
//    [self scrollingFinish];
    
    
    ClassScheduleTableShown=FALSE;
    

        
    if (![globalselecteddate isEqualToString:lastselectdate] || (!weeklyMode && ![[selecteddatearray firstObject] isEqualToString:dailydateselected])) {
        tmpselecteddate=globalselecteddate;
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        
        ClassScheduleTableShown=FALSE;

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if(!weeklyMode){
                NSString *dayofweek=[MyClass convertDateFormatWithDate:[selecteddatearray firstObject] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE" Translate:NO];
                globalvariables.centerdayofweekarray=[[NSMutableArray alloc]initWithObjects:dayofweek, nil];
                dailydateselected=[selecteddatearray firstObject];
            }
            
            if ([self generateTimeTablewithViewOption:TimeTableMode pastMonday:tmpselecteddate classtype:classtypeselected redrawscoller:YES]) {
                
                [self updatetabviewpreferencewithoption:@"update" tabid:selectedtabbutton.tag-100000000 headerlist:[selectedHeaderArray componentsJoinedByString:@"/"] mode:@"Weekly" selecteddate:globalselecteddate];
                
            }else{
                globalselecteddate=lastselectdate;
                [self generatedatescrollerwithpastmonday:globalselecteddate redraw:YES];
            }
            [datebartable reloadData];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }
//    [datebartable reloadData];
    
    
}

- (void)returnCalendarYear:(NSString *)year {
}


-(void) updatecalendarview
{
    if(weeklyMode){
        [calendarview scrollToSelectedDateWithSelectedDateArray:[self returnselecteddatearray] ScrollToDate:globalselecteddate instructorselected:instructorselected];
    }else{
        [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:dailydateselected, nil] ScrollToDate:nil instructorselected:instructorselected];
    }
    
    [calendarview refreshviewwithoption:@"stop"];
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    previouscontentoffset=scrollView.contentOffset;
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView==masterScrollView) {
        [classTimeView setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
        [datebartable setContentOffset:CGPointMake(0, scrollView.contentOffset.x)];
        
        if (ClassScheduleTableShown) {
            masterView.frame=CGRectMake(-[self returnclasstimewidth]+scrollView.contentOffset.x, masterView.frame.origin.y, masterView.frame.size.width, masterView.frame.size.height);
        }
        visibleRect = scrollView.bounds;
        [self layoutContentItems];
        
    }else if (scrollView==timetablecollectionview){
        [classTimeView setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
        [datebartable setContentOffset:CGPointMake(0, scrollView.contentOffset.x)];
        
        if (ClassScheduleTableShown) {
            masterView.frame=CGRectMake(scrollView.contentOffset.x, masterView.frame.origin.y, masterView.frame.size.width, masterView.frame.size.height);
        }
    }
}

-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView==masterScrollView || scrollView==timetablecollectionview) {
        if(scrollView.contentOffset.y==previouscontentoffset.y){
            if (scrollView.contentOffset.x==0 && previouscontentoffset.x==0) {
                if (fabs(scrollView.contentOffset.y-previouscontentoffset.y)<80) {
                    [self.mainSlideMenu openLeftMenu];
                }
            }
        }
    }
}




// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    __weak ClassTimeTableCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    cell.cellview.frame=cell.bounds;
    cell.rightline.frame=CGRectMake(cellwidth-0.8, 0, 0.8, cellheight);
    [[cell.cellview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    if (indexPath.row%filteredHeaderArray.count==filteredHeaderArray.count-1) {
        cell.rightline.hidden=NO;
    }else{
        cell.rightline.hidden=YES;
    }
    
    
    //if ([MyClass isWorkingDate:calendardate includereserveddate:YES] || [TimeTableMode isEqualToString:@"Consolidated"]) {
    
    ClassTimeTableRecordArray=[ClassTimeTableRecordDictionary objectForKey:[NSString stringWithFormat:@"%ld",indexPath.section*totalSubjectColumn+indexPath.row]];
    if (ClassTimeTableRecordArray) {
        //has class records
        for (long z=0; z<ClassTimeTableRecordArray.count; z++) {
            ClassTimeTableObject=[ClassTimeTableRecordArray objectAtIndex:z];
            cellButton=[[UIButton alloc]initWithFrame:CGRectMake(z*cellwidth/ClassTimeTableRecordArray.count,0,cellwidth/ClassTimeTableRecordArray.count, cellheight)];
            [cellButton setTitle:[NSString stringWithFormat:@"%li",(unsigned long)ClassTimeTableObject.studentarray.count] forState:UIControlStateNormal];
            
            [cellButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
            [cellButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
            [cellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cellButton addTarget: self action:@selector(cellButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
            
            if ([headertype isEqualToString:@"Subject"]) {
                if ([contentmode isEqualToString:@"Instructor"]) {
                    cellButton.backgroundColor=[self returninstructorcolor:ClassTimeTableObject.instructor];
                }else{
                    cellButton.backgroundColor=[self returnclassroomcolor:ClassTimeTableObject.classroom];
                }
            }else if ([headertype isEqualToString:@"Classroom"]){
                if ([contentmode isEqualToString:@"Instructor"]) {
                    cellButton.backgroundColor=[self returninstructorcolor:ClassTimeTableObject.instructor];
                }else{
                    cellButton.backgroundColor=[self returnsubjectcolor:ClassTimeTableObject.subject];
                }
            }else  if ([headertype isEqualToString:@"Instructor"]){
                if ([contentmode isEqualToString:@"Classroom"]) {
                    cellButton.backgroundColor=[self returnclassroomcolor:ClassTimeTableObject.classroom];
                }else{
                    cellButton.backgroundColor=[self returnsubjectcolor:ClassTimeTableObject.subject];
                }
            }else{
                cellButton.backgroundColor=[globalvariables.colorcodearray firstObject];
            }
            
            cellButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
            cellButton.layer.borderWidth=0.31;
            
            cellButton.tag=[[NSString stringWithFormat:@"1%03ld%05ld",(long)z,indexPath.section*totalSubjectColumn+indexPath.row] intValue];
            
            [cell.cellview addSubview:cellButton];
        }
    }else{
        //no class records
        TimeTableDetailsObject=[ClassTimeDetailsdictionary objectForKey:[NSString stringWithFormat:@"%@%@%@",[classDay objectAtIndex:indexPath.row/filteredHeaderArray.count],[classTime objectAtIndex:indexPath.section],[filteredHeaderArray objectAtIndex:indexPath.row%filteredHeaderArray.count]]];
        if (TimeTableDetailsObject) {
            
            cellButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, cellwidth, cellheight)];
            
            
            if ([TimeTableDetailsObject.block isEqualToString:@"Yes"]) {
                cellButton.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];//[UIColor darkGrayColor];
                [cellButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [cellButton.titleLabel setFont:[UIFont systemFontOfSize:10]];
                cellButton.layer.borderColor=[UIColor darkGrayColor].CGColor;
                cellButton.titleLabel.adjustsFontSizeToFitWidth=YES;
                cellButton.titleLabel.minimumScaleFactor=0.5;
                [cellButton setTitle:TimeTableDetailsObject.caption forState:UIControlStateNormal];
                [cellButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                cellButton.layer.borderWidth=0.51;
                
            }else{
                
                if ((indexPath.section/(60/[globalvariables.centerrecord.classtimeinterval intValue])) %2==0) {
                    cellButton.backgroundColor=[UIColor systemGroupedBackgroundColor];//[UIColor systemGroupedBackgroundColor];
                }else{
                    cellButton.backgroundColor=[UIColor whiteColor];//[UIColor systemGroupedBackgroundColor];
                }
                [cellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            [cellButton addTarget: self action:@selector(cellButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
            
            cellButton.tag=[[NSString stringWithFormat:@"2%03ld%03ld999",(long)indexPath.row,(long)indexPath.section] intValue];
            
            [cell.cellview addSubview:cellButton];
        }else{
            cellButton = [[UIButton alloc]initWithFrame:CGRectMake(0,0, cellwidth, cellheight)];
            cellButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
            cellButton.layer.borderWidth=0.31;
            if ([globalvariables.centerrecord.classtimeinterval intValue]>60) {
                cellButton.backgroundColor=[UIColor whiteColor];//[UIColor systemGroupedBackgroundColor];
            }else{
                if ((indexPath.section/(60/[globalvariables.centerrecord.classtimeinterval intValue])) %2==0) {
                    cellButton.backgroundColor=[UIColor systemGroupedBackgroundColor];//[UIColor systemGroupedBackgroundColor];
                }else{
                    cellButton.backgroundColor=[UIColor whiteColor];//[UIColor systemGroupedBackgroundColor];
                }
            }
            
            [cellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cellButton.tag=[[NSString stringWithFormat:@"2%03ld%03ld999",(long)indexPath.row,(long)indexPath.section] intValue];
            
            
            [cellButton addTarget: self action:@selector(cellButtonPressed:) forControlEvents: UIControlEventTouchUpInside];
            [cell.cellview addSubview:cellButton];
        }
    }
    /*}else{
     cell.cellview.backgroundColor=[UIColor colorWithRed:176.0/255.0 green:36.0/255.0 blue:34.0/255.0 alpha:1.0];
     }*/
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return totalSubjectColumn;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return NoOfTimeSlot;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(cellwidth, cellheight);
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


-(void) updatestudentinformationlist:(NSString *)studentkey reloadlist:(BOOL)reload
{
    //delegate not used
}

-(void) updateCategoryCount
{
    //delegate not used
}

-(void) gobackStudentCategory
{
    //delegate not used
}

-(void) enableAddStudentButton
{
    //delegate not used
}

-(void) disableAddStudentButton
{
    //delegate not used
}

-(void) gotostudentprofile:(NSString *)studentkey
{
    //delegate not used
}

-(void) refreshparentviewdocumentfoldercount
{
    //delegate not used
}

-(void) refreshstudentdetailviewpresentingviewcontent
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ClassScheduleTableShown=FALSE;
        [self generateTimeTablewithViewOption:TimeTableMode pastMonday:globalselecteddate classtype:classtypeselected redrawscoller:YES];
    });
}

- (void)donotrunviewdidappearinstudentinformation {
    
}


- (void)gotostudentprofile:(NSString *)studentkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys {
    
}


-(void) gobackLeadCategory
{
    //delegate not used
}

-(void) enableAddLeadButton
{
    //delegate not used
}

-(void) updateleadinformationlist:(NSString *)leadkey
{
    //delegate not used
}

-(void) gotoleadprofile:(NSString *)leadkey
{
    //delegate not used
}

-(void) closeleadprofile
{
    //delegate not used
}

-(void) refreshleaddetailviewpresentingviewcontent
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ClassScheduleTableShown=FALSE;
        [self generateTimeTablewithViewOption:TimeTableMode pastMonday:globalselecteddate classtype:classtypeselected redrawscoller:YES];
    });
}

- (void)enrollATLeadStudent:(AssessmentTrialRecord *)ATRecord {
    //not used
}

- (void)donotrunviewdidappearinleadinformation {
    
}


- (void)gotoLeadProfilewithLeadkey:(NSString *)leadkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys {
    
}


-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"colorcode"]) {
        NSString *colorcode=[selecteditems firstObject];
        if ([contentmode isEqualToString:@"Instructor"]) {
            [self updateColorCodeWithType:@"instructor" TypeKey:[InstructorNameArray objectAtIndex:dataindex] ColorCode:colorcode];
        }else if ([contentmode isEqualToString:@"Classroom"]){
            [self updateColorCodeWithType:@"classroom" TypeKey:[ClassroomNameArray objectAtIndex:dataindex] ColorCode:colorcode];
        }else{
            NSMutableDictionary *subjectdict=[SubjectNameArray objectAtIndex:dataindex];
            if ([[subjectdict valueForKey:@"subjecttype"] isEqualToString:@"subject"]) {
                [self updateColorCodeWithType:@"subject" TypeKey:[subjectdict valueForKey:@"subject"] ColorCode:colorcode];
            }else{
                [self updateColorCodeWithType:@"subjectcategory" TypeKey:[subjectdict valueForKey:@"subject"] ColorCode:colorcode];
            }
        }
    }else if ([datatype isEqualToString:@"dayofweek"]){
        NSString *dayofweek=[selecteditems firstObject];
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            dailydateselected=[MyClass convertToNSStringWithNSDate:[[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyy"] dateByAddingTimeInterval:60*60*24*([allClassDay indexOfObject:dayofweek])] DateFormat:@"dd-MMM-yyyy"];
            
            globalvariables.centerdayofweekarray=[[NSMutableArray alloc]initWithObjects:dayofweek, nil];
            [self generateTimeTablewithViewOption:TimeTableMode pastMonday:tmpselecteddate classtype:classtypeselected redrawscoller:YES];
            [datebartable reloadData];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }else if ([datatype isEqualToString:@"Student"]){
        NSString *item=[selecteditems firstObject];
//        [self closesidewindow];
        
        ClassTimeTableRecord3 *lessonobject=[[ClassTimeTableRecord3 alloc]init];
        ClassScheduleRecord *classschedulrecord=[[ClassScheduleRecord alloc]init];
        
        lessonobject.studentarray=[[NSMutableArray alloc]init];
        lessonobject.classday=[MyClass convertDateFormatWithDate:[newcoursedict valueForKey:@"startdate"] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE" Translate:NO];
        lessonobject.subjecttype=@"subject";
        lessonobject.subject=[newcoursedict valueForKey:@"subject"];
        lessonobject.classtime=[newcoursedict valueForKey:@"classtime"];
        lessonobject.instructor=[newcoursedict valueForKey:@"instructor"];
        lessonobject.sinstructor=@"TBD";
        lessonobject.classroom=[newcoursedict valueForKey:@"classroom"];
        lessonobject.schedulekey=@"-1";
        
        classschedulrecord.startdate=[MyClass convertDateFormatWithDate:[newcoursedict valueForKey:@"startdate"] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        classschedulrecord.subject=[newcoursedict valueForKey:@"subject"];
        classschedulrecord.classtime=[newcoursedict valueForKey:@"classtime"];
        classschedulrecord.instructor=[newcoursedict valueForKey:@"instructor"];
        classschedulrecord.sinstructor=@"TBD";
        classschedulrecord.classroom=[newcoursedict valueForKey:@"classroom"];
        classschedulrecord.schedulekey=@"-1";
        classschedulrecord.classtype=@"class";
        classschedulrecord.levelmain=@"";
        classschedulrecord.levelctm=@"";
        classschedulrecord.lesson=@"";
        
        
        [self enrollStudentwithlessonobject:lessonobject studentkey:item classscheduleobject:classschedulrecord];

    }
}

-(void) pickerBottomButtonPressedWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex BottomMode:(NSString *)bottommode SelectedItems:(NSMutableArray *)selecteditems
{
    if ([datatype isEqualToString:@"Student"]){
        if([bottommode isEqualToString:@"New Student"]){
            [self closesidewindow];
            
            ClassTimeTableRecord3 *lessonobject=[[ClassTimeTableRecord3 alloc]init];
            ClassScheduleRecord *classschedulrecord=[[ClassScheduleRecord alloc]init];
            
            lessonobject.studentarray=[[NSMutableArray alloc]init];
            lessonobject.classday=[MyClass convertDateFormatWithDate:[newcoursedict valueForKey:@"startdate"] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"EEE" Translate:NO];
            lessonobject.subjecttype=@"subject";
            lessonobject.subject=[newcoursedict valueForKey:@"subject"];
            lessonobject.classtime=[newcoursedict valueForKey:@"classtime"];
            lessonobject.instructor=[newcoursedict valueForKey:@"instructor"];
            lessonobject.sinstructor=@"TBD";
            lessonobject.classroom=[newcoursedict valueForKey:@"classroom"];
            lessonobject.schedulekey=@"-1";
            
            classschedulrecord.startdate=[MyClass convertDateFormatWithDate:[newcoursedict valueForKey:@"startdate"] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
            classschedulrecord.subject=[newcoursedict valueForKey:@"subject"];
            classschedulrecord.classtime=[newcoursedict valueForKey:@"classtime"];
            classschedulrecord.instructor=[newcoursedict valueForKey:@"instructor"];
            classschedulrecord.sinstructor=@"TBD";
            classschedulrecord.classroom=[newcoursedict valueForKey:@"classroom"];
            classschedulrecord.schedulekey=@"-1";
            classschedulrecord.classtype=@"class";
            classschedulrecord.levelmain=@"";
            classschedulrecord.levelctm=@"";
            classschedulrecord.lesson=@"";
            
            
            [self enrollStudentwithlessonobject:lessonobject studentkey:nil classscheduleobject:classschedulrecord];
        }
    }
}

-(void) updateColorCodeWithType:(NSString *)type TypeKey:(NSString *)typekey ColorCode:(NSString *)colorcode
{
    __block BOOL result=FALSE;
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    
    if ([typekey isEqualToString:@"TBD"]) {
        [dictionary setValue:@"updatecenterinformation" forKey:@"postaction"];
        if ([type isEqualToString:@"instructor"]) {
            [dictionary setValue:colorcode forKey:@"timetabletbdinstructorcolorcode"];
        }else{
            [dictionary setValue:colorcode forKey:@"timetabletbdclassroomcolorcode"];
        }
    }else{
        [dictionary setValue:@"updatecolorcode" forKey:@"postaction"];
        [dictionary setValue:type forKey:@"type"];
        [dictionary setValue:typekey forKey:@"typekey"];
        [dictionary setValue:colorcode forKey:@"colorcode"];
    }
    
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];

    
    if(result){
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadpage];
        });
    }
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    ClassScheduleTableShown=NO;
//    [self loadTimeTablewithviewoption:TimeTableMode];
    
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    ClassScheduleTableShown=NO;
    [self loadTimeTablewithviewoption:TimeTableMode];
}

//-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    ClassScheduleTableShown=NO;
//    [self loadTimeTablewithviewoption:TimeTableMode];
//}

-(void) returnfilterclasstimetableobjectArray
{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (![searchbar.text isEqualToString:@""]) {
        if (detailViewMode) {
            newCondition = [NSPredicate predicateWithFormat:@"SELF.subject contains[c] %@ or self.instructor contains[c] %@ or self.classroom contains[c] %@ or any studentarray.displayname contains[c] %@  or any studentarray.typekey contains[c] %@ or SELF.subjectfullname contains[c] %@ or self.instructorfullname contains[c] %@ or any studentarray.attendance contains[c] %@ or any studentarray.levelmain contains[c] %@ or any studentarray.subject contains[c] %@",searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text];
        }else{
            newCondition = [NSPredicate predicateWithFormat:@"SELF.subject contains[c] %@ or self.instructor contains[c] %@ or self.classroom contains[c] %@ or SELF.subjectfullname contains[c] %@ or self.instructorfullname contains[c] %@",searchbar.text,searchbar.text,searchbar.text,searchbar.text,searchbar.text];
        }

        [nsPredicatearray addObject:newCondition];
        
    }
    
    if (selectedSubjectArray) {
        newCondition = [NSPredicate predicateWithFormat:@"any studentarray.subject in %@ or self.subject in %@",selectedSubjectArray,selectedSubjectArray];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (selectedClassroomArray) {
        newCondition = [NSPredicate predicateWithFormat:@"self.classroom in %@",selectedClassroomArray];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (selectedInstructorArray) {
        newCondition = [NSPredicate predicateWithFormat:@"self.instructor in %@",selectedInstructorArray];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredclasstimetableobjectArray= [[NSMutableArray alloc]initWithArray:[classtimetableobjectArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredclasstimetableobjectArray= [[NSMutableArray alloc]initWithArray:classtimetableobjectArray];
    }
}

-(void) updateHeaderLessonStudentCount
{
    if (!filteredclasstimetableobjectArray || filteredclasstimetableobjectArray.count==0 || !detailViewMode) {
        headertitlename.text=[MyClass returntitlewithtitle:@"Center Time Table"];
    }else{
        headertitlename.text=[NSString stringWithFormat:@"%@ (%lu/%lu/%ld)",[MyClass returntitlewithtitle:@"Center Time Table"],(unsigned long)filteredclasstimetableobjectArray.count,(unsigned long)timetablestudentdict.count,(long)totalattendedcount];
    }
}

-(void) addtimetablestudentdictwithclasstimetablesubrecord:(ClassTimeTableSubRecord *)record
{
    if ([TimeTableMode isEqualToString:@"Consolidated"]) {
        [timetablestudentdict setValue:@"888" forKey:[@(timetablestudentdict.count) stringValue]];
    }else{
        if (![timetablestudentdict valueForKey:record.classkey]) {
            [timetablestudentdict setValue:record.classkey forKey:record.classkey];
        }
        
        if ([record.attendance isEqualToString:@"Present"]) {
            totalattendedcount+=1;
        }
    }
}

-(void) updateClassTimeTableWithSelectedHeaderArray:(NSMutableArray *)t_selectedHeaderArray
{
    selectedHeaderArray=[[NSMutableArray alloc]initWithArray:t_selectedHeaderArray];
    if ([TimeTableMode isEqualToString:@"PopoverWeekly"] || [TimeTableMode isEqualToString:@"PopoverConsolidated"]){
        filteredHeaderArray=[[NSMutableArray alloc]initWithArray:t_selectedHeaderArray copyItems:YES];
    }
    
    if (selectedtabbutton.tag==99) {
        if (selectedHeaderArray.count>0) {
            globalselecteddate=[self findfirstdayofweeklyview:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"]];
            classDay=[[NSArray alloc]initWithArray:globalvariables.centerdayofweekarray copyItems:YES];
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                if ([self selectsubjectdelay]) {
                    NSString *tabviewtitle=[self returntabtitlewithselectedheaderarray:self->selectedHeaderArray];//  [selectedHeaderArray componentsJoinedByString:@"/"];//[self convertsubjectshortnamestring:selectedHeaderArray];
                    [self updatetabviewpreferencewithoption:@"insert" tabid:self->selectedtabbutton.tag headerlist:[self->selectedHeaderArray componentsJoinedByString:@"/"] mode:@"Weekly" selecteddate:globalselecteddate];
                    
                    //create new tabview button
                    self->TabViewButton=[[UIButton alloc]initWithFrame:CGRectMake((int)((self.view.bounds.size.width-tabheight)/self->TabArray.count)*(self->TabArray.count-1), 0, (int)((self.view.bounds.size.width-tabheight)/self->TabArray.count), tabheight+2)];
                    self->TabViewButton.backgroundColor=tablecolor;
                    self->TabViewButton.layer.cornerRadius=2;
                    self->TabViewButton.layer.borderColor=tablecolor.CGColor;
                    self->TabViewButton.layer.borderWidth=.4;
                    self->TabViewButton.tag=[((TabRecord *)[self->TabArray lastObject]).tabid intValue]+100000000;
                    [self->TabViewButton addTarget: self action:@selector(selecttabview:) forControlEvents: UIControlEventTouchUpInside];
                    [self->tabpanelview sendSubviewToBack:self->TabViewButton];
                    [self->tabpanelview addSubview:self->TabViewButton];
                    
                    //add title
                    self->TabTitle=[[UILabel alloc]initWithFrame:CGRectMake(20, 2, TabViewButton.frame.size.width-40, tabheight)];
                    self->TabTitle.font=[UIFont systemFontOfSize:11];
                    self->TabTitle.tag=[((TabRecord *)[TabArray lastObject]).tabid intValue]+200000000;
                    self->TabTitle.textAlignment=NSTextAlignmentCenter;
                    self->TabTitle.textColor=[UIColor whiteColor];
                    self->TabTitle.text=tabviewtitle;
                    [self->TabViewButton addSubview:TabTitle];
                    
                    //add tabview delete button
                    self->TabDeleteButton=[[UIButton alloc]initWithFrame:CGRectMake(10,0,20,tabheight)];
                    self->TabDeleteButton.tag=[((TabRecord *)[TabArray lastObject]).tabid intValue]+300000000;
                    [self->TabDeleteButton addTarget: self action:@selector(deletetabview:) forControlEvents: UIControlEventTouchUpInside];
                    [self->TabViewButton addSubview:TabDeleteButton];
                    [self drawdeleteviewaddicon];
                    
                    //send other tab to back
                    [self resizeothertabviewbutton:self->TabViewButton];
                    //aiclasstimetable.center=CGPointMake(TabViewButton.frame.origin.x+13, TabViewButton.frame.origin.y+15);
                    
                    self->selectedtabbutton=TabViewButton;

                }else{
                    self->selectedHeaderArray=[[NSMutableArray alloc]initWithArray:lasttabsubjectarray copyItems:YES];

                }
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }else{
            selectedHeaderArray=[[NSMutableArray alloc]initWithArray:lasttabsubjectarray copyItems:YES];
            selectedtabbutton=lastselecttabbutton;
        }
        
    }else{
        if (selectedHeaderArray.count==0) {
            //delete tab
            UIButton *tmpdeletebutton=(UIButton *)[tabpanelview viewWithTag:selectedtabbutton.tag+200000000];
            [self deletetabview:tmpdeletebutton];
        }else{
            NSString *tabviewtitle=[self returntabtitlewithselectedheaderarray:selectedHeaderArray];//[self convertsubjectshortnamestring:selectedHeaderArray];
            
            //update tab
            UILabel *tmptabtitle=(UILabel *)[tabpanelview viewWithTag:selectedtabbutton.tag+100000000];
            if (![tmptabtitle.text isEqualToString:tabviewtitle]) {

                //aiclasstimetable.center=CGPointMake(selectedtabbutton.frame.origin.x+13, selectedtabbutton.frame.origin.y+15);
                //[self.view bringSubviewToFront:aiclasstimetable];
                [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([self selectsubjectdelay]) {
                        if (![TimeTableMode isEqualToString:@"PopoverConsolidated"] && ![TimeTableMode isEqualToString:@"PopoverWeekly"]) {
                            [self updatetabviewpreferencewithoption:@"update" tabid:selectedtabbutton.tag-100000000 headerlist:[selectedHeaderArray componentsJoinedByString:@"/"] mode:@"Weekly" selecteddate:globalselecteddate];
                        }
                        tmptabtitle.text=tabviewtitle;
                    }else{
                        selectedHeaderArray=[[NSMutableArray alloc]initWithArray:lasttabsubjectarray copyItems:YES];
                    }
                    [MyClass loadingindicatorwithoption:@"stop" color:nil];
                });
            }
        }
    }
}

-(void) refreshstudentdetailsinformation
{
    [self closesidewindow];
    [self delayviewload];
}

-(EnrollmentRecord *) refreshstudentdetailsinformationandreturnenrollementrecord:(EnrollmentRecord *)enrollment
{
    [self closesidewindow];
    [self delayviewload];
    
    return nil;
}

-(void) reloadClassTimeTable:(BOOL)reload
{
    if(reload){
        [self delayviewload];
    }
}

-(NSString *) returnsubjectwithcategory:(NSString *)category schedulekey:(NSString *)schedulekey
{
    NSMutableArray *subjectArray=[MyClass retrievesubjectinformationwithstatus:@"All" category:category flushcachedata:NO];
    for(int i=0;i<subjectArray.count;i++){
        SubjectRecord *obj=subjectArray[i];
        if([MyClass returnscheduleinformationwithsubject_shortname:obj.subject_shortname schedulekey:schedulekey centerkey:obj.centerkey]){
            return obj.subject_shortname;
        }
    }
    return @"";
}

-(void) enrollStudentwithlessonobject:(ClassTimeTableRecord3 *)lessonobject studentkey:(NSString *)studentkey classscheduleobject:(ClassScheduleRecord *)classschedulerecord
{
//    [self closesidewindow];
    
    
    NSString * startdate;
    
    if([TimeTableMode isEqualToString:@"Consolidated"]){
        startdate = [MyClass findNextWorkDay:[NSDate date] dayofWeek:lessonobject.classday includereserveddate:NO];
    }else{
        startdate=classschedulerecord.startdate;
    }
    classschedulerecord.startdate=startdate;
    if(lessonobject.studentarray.count==0){
        int delta = [MyClass returndayofweeknumber:lessonobject.classday]-1;
        NSDate *dateselected = [[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyy"] dateByAddingTimeInterval:60*60*24*delta];
        NSString *selectedstartdate=[MyClass convertToNSStringWithNSDate:dateselected DateFormat:@"dd-MMM-yyyy"];
        
        classschedulerecord=[[ClassScheduleRecord alloc]init];
        if([lessonobject.subjecttype isEqualToString:@"subject"]){
            classschedulerecord.subject=lessonobject.subject;
        }else{
            classschedulerecord.subject=[self returnsubjectwithcategory:lessonobject.subject schedulekey:lessonobject.schedulekey];
        }
        
        classschedulerecord.levelmain=@"";
        classschedulerecord.levelctm=@"";
        classschedulerecord.lesson=@"";
        classschedulerecord.schedulekey=lessonobject.schedulekey;
        classschedulerecord.startdate=selectedstartdate;
    }
    classschedulerecord.classtime=lessonobject.classtime;
    classschedulerecord.instructor=lessonobject.instructor;
    classschedulerecord.sinstructor=lessonobject.sinstructor;
    classschedulerecord.classroom=lessonobject.classroom;
    
    if(studentkey){
        [self startsidewindowanimationwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            EnrollmentPopoverViewController *enrollmentpopover = (EnrollmentPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"EnrollmentPopoverViewController"];
            enrollmentpopover.delegate=self;
            enrollmentpopover.EnrollmentTableMode=@"Join";
            
            EnrollmentRecord *enrollment=[[EnrollmentRecord alloc]init];
            enrollment.studentkey=studentkey;
            enrollment.subject=classschedulerecord.subject;
            enrollment.startdate=classschedulerecord.startdate;
            enrollment.classtime=classschedulerecord.classtime;
            enrollment.instructor=classschedulerecord.instructor;
            enrollment.sinstructor=classschedulerecord.sinstructor;
            enrollment.classroom=classschedulerecord.classroom;
            enrollment.schedulekey=classschedulerecord.schedulekey;
            enrollment.levelmain=classschedulerecord.levelmain;
            enrollment.levelctm=classschedulerecord.levelctm;
            enrollment.remarks=classschedulerecord.lesson;
            
            enrollmentpopover.PopoverEnrollment=enrollment;
            enrollmentpopover.PopoverStudent=[MyClass returnstudentwithstudentkey:studentkey];
            enrollmentpopover.currentsubject=classschedulerecord.subject;

            [self->sidewindowview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            enrollmentpopover.view.frame=self->mainWindow.bounds;
            [self->sidewindowview addSubview:enrollmentpopover.view];
            [self addChildViewController:enrollmentpopover];
            [enrollmentpopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
        });
    }else{
        //go to student page
//        [self.delegate addStudentAndSubject:classschedulerecord];
        
        [self closesidewindow];
        
        AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
        mainVC.leftMenu.prepareforsegue=TRUE;
        mainVC.leftMenu.sourceview=@"timetable";
        mainVC.leftMenu.studentinformationaction=@"AddStudentAndSubject";
        mainVC.leftMenu.studentinformationclassscheduleobject=classschedulerecord;
        globalvariables.leftmenuindex=@"1";
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
    }
    
}

-(BOOL) isDifferentLevelWithLaterEnrollmentWithStartDate:(NSString *)startdate enrollmentkey:(NSString *)enrollmentkey subject:(NSString *)subject levelmain:(NSString *)levelmain levelctm:(NSString *)levelctm studentkey:(NSString *)studentkey
{
    return FALSE;
}

-(void) contentViewBackgroundButtonPressed:(UIButton *)sender withEvent:(UIEvent *)event
{
//    if (myPopover.isShown) {
//        return;
//    }
    
    newcoursedict=[[NSMutableDictionary alloc]init];
    
    // Get the first touch point from the event
    UITouch *touch = [[event allTouches] anyObject];
    
    // Convert the touch point to the button's local coordinate system
    CGPoint locationInButton = [touch locationInView:sender];
    
    CGFloat xposition = locationInButton.x;
    
    NSString *selectedclasstime=[classTime objectAtIndex:(long)(locationInButton.y/cellheight)];
    float minute= (locationInButton.y-(long)(locationInButton.y/cellheight)*cellheight)*30/cellheight+[[selectedclasstime substringFromIndex:3] floatValue];
    minute=(long)(minute/[globalvariables.centerrecord.classtimeinterval floatValue])*[globalvariables.centerrecord.classtimeinterval floatValue];
    selectedclasstime = [NSString stringWithFormat:@"%@:%02ld", [selectedclasstime substringToIndex:2], (long)minute];
    
    CGFloat datecellwidth;
    NSString *selecteddate;
    NSString *selectedcolumn;
    float xpos=0;
    float width=0;
    for (int i=0; i<classDay.count; i++) {
        datecellwidth= ([[headerPositionArray objectAtIndex:((i+1)*filteredHeaderArray.count-1)] floatValue]+[[headerWidthArray objectAtIndex:((i+1)*filteredHeaderArray.count-1)] floatValue]-[[headerPositionArray objectAtIndex:i*filteredHeaderArray.count] floatValue])*cellwidthfordetailview;
        xposition-=datecellwidth;
        if (xposition<0) {
            selecteddate=[MyClass returnDateFromBaseDateWithOffset:([allClassDay indexOfObject:[classDay objectAtIndex:i]]+[MyClass returnDateOffsetWithDate:[MyClass convertToNSDateWithDate:globalselecteddate DateFormat:@"dd-MMM-yyyy"]])];
            
            for (int j=0; j<filteredHeaderArray.count; j++) {
                width=[[headerWidthArray objectAtIndex:(i*filteredHeaderArray.count+j)] floatValue]*cellwidthfordetailview;
                xpos+=width;
                if (xpos>locationInButton.x) {
                    selectedcolumn=[filteredHeaderArray objectAtIndex:j];
                    break;
                }
            }
            break;
        }
        xpos+=datecellwidth;
    }
    
    NSString *defaultsubject;
    NSArray *activesubjectarray=[MyClass filterSubjectArrayWithSubjectArray:[MyClass retrievesubjectinformationwithstatus:@"Active" category:@"All" flushcachedata:NO] Status:@"Active"];
    if (activesubjectarray.count>0) {
        defaultsubject=((SubjectRecord *)[activesubjectarray objectAtIndex:0]).subject_shortname;
    }else{
        defaultsubject=@"";
    }
    
    [newcoursedict setValue:selecteddate forKey:@"startdate"];
    [newcoursedict setValue:selectedclasstime forKey:@"classtime"];
    if ([headertype isEqualToString:@"Instructor"]) {
        [newcoursedict setValue:selectedcolumn forKey:@"instructor"];
        [newcoursedict setValue:@"TBD" forKey:@"classroom"];
        [newcoursedict setValue:defaultsubject forKey:@"subject"];
    }else if ([headertype isEqualToString:@"Classroom"]){
        [newcoursedict setValue:selectedcolumn forKey:@"classroom"];
        [newcoursedict setValue:@"TBD" forKey:@"classroom"];
        [newcoursedict setValue:defaultsubject forKey:@"subject"];
    }else if ([headertype isEqualToString:@"Subject"]){
        [newcoursedict setValue:selectedcolumn forKey:@"subject"];
        [newcoursedict setValue:@"TBD" forKey:@"instructor"];
        [newcoursedict setValue:@"TBD" forKey:@"classroom"];
    }else if ([headertype isEqualToString:@"All"]){
        [newcoursedict setValue:defaultsubject forKey:@"subject"];
        [newcoursedict setValue:@"TBD" forKey:@"instructor"];
        [newcoursedict setValue:@"TBD" forKey:@"classroom"];
    }
    
    NSLog(@"Click position: %@ %@ %@", selecteddate, selectedclasstime,selectedcolumn);
    
//    myPopover=[[NSPopover alloc]init];
    NSMutableArray *allstudentarray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@",globalvariables.centerrecord.centerkey];
    allstudentarray=[[NSMutableArray alloc]initWithArray:[allstudentarray filteredArrayUsingPredicate:predicate]];
    allstudentarray = [NSMutableArray arrayWithArray:[allstudentarray sortedArrayUsingDescriptors:[MyClass returnstudentnamesortdescriptorarray]]];
    
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PickerViewController *pickerviewcontroller = (PickerViewController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil] instantiateViewControllerWithIdentifier: @"PickerViewController"];
        pickerviewcontroller.delegate=self;
        pickerviewcontroller.selecteditems=[[NSMutableArray alloc]init];
        pickerviewcontroller.datatype=@"Student";
        pickerviewcontroller.showsearchbar=YES;
        pickerviewcontroller.bottommode=@"New Student";
        pickerviewcontroller.viewtitle=@"Select Student";
        pickerviewcontroller.preferredContentSize=CGSizeMake(320, 40*allstudentarray.count);
        pickerviewcontroller.itemsarray=allstudentarray;
        
        CGRect frame=mainWindow.bounds;
        frame.size.width=320;
        pickerviewcontroller.view.frame=frame;
        [self->sidewindowview addSubview:pickerviewcontroller.view];
        [self addChildViewController:pickerviewcontroller];
        [pickerviewcontroller didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
    
    
//
//    NSRect anchorRect = NSMakeRect(locationInButton.x, locationInButton.y, 1, 1);
//    NSButton *button2 = [[NSButton alloc] initWithFrame:anchorRect];
//    [button addSubview:button2];
//    
//    [MyClass showPickerMenuWindowWithButton:button2 DataType:@"Student" DataIndex:0 itemArray:allstudentarray selectedItems:[[NSMutableArray alloc]init] windowWidth:300 showSearchView:YES showCarryOverButton:NO bottomButtonMode:@"New Student" multipleSelection:NO popover:myPopover view:self bottomButton2Mode:nil];
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [button2 removeFromSuperview];
//    });
    
}

@end
