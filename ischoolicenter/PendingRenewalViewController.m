//
//  PendingRenewalViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 5/7/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "PendingRenewalViewController.h"
#import "EnrollmentPopoverViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MainMenuViewController.h"
#import "MyClass.h"
#import "MainViewController.h"
#import "MyTableViewCell.h"
#import "SceneDelegate.h"

@interface PendingRenewalViewController ()
@property (nonatomic, strong) NSMutableDictionary *renewalEdgeConstants;
@property (nonatomic, assign) BOOL sideWindowAdjusting;
@end

@implementation PendingRenewalViewController
@synthesize myPopoverController;
@synthesize DetailsViewEnrollment,DetailsViewStudent;
@synthesize DetailsViewEnrollmentArray;
@synthesize myStudentPopoverController;
//@synthesize childRenewalRecordEnrollmentKey;

//#define RemainingClass 4
#define grouplogheaderheight 50
#define maxselectiontableheight 500
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]

/*
//file path to db
-(NSString *)filePath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:@"isdb.sql"];
}

//open the dbbar
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
    // Do any additional setup after loading the view.
    
    //supermasterview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width+315, self.view.bounds.size.height)];
    //[self.view addSubview:supermasterview];
    
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
    
    switchcenterviewcontroller = (SwitchCenterViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SwitchCenterViewController"];
    //switchcenterviewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
    switchcenterviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    switchcenterviewcontroller.delegate=self;


    //classdayarray=[[NSArray alloc]initWithObjects:@"All",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun",@"Multi", nil];

    //renewalmanualmenuview=[[UIView alloc]initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 32)];
    //[supermasterview addSubview:renewalmanualmenuview];

    //renewalbatchmenuview=[[UIView alloc]initWithFrame:CGRectMake(0, 150, self.view.bounds.size.width, 32)];
    //[supermasterview addSubview:renewalbatchmenuview];

    RenewalRecordObject = [[RenewalRecord alloc]init];
    RenewalLogObject=[[RenewalLog alloc]init];
    //RenewalGroupLogExpandRowArray=[[NSMutableArray alloc]init];
    
    [self loadrenewalpage];
    
    selecteddatemanual=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"];
    
    //month end date to batch date
    cutoffdatebutton.tag=[MyClass returnEndOfMonthwithCurrentDate:[NSDate date]];

    NSString *threshold=[MyClass getlocaldbwithparameter:@"renewalremainingclassthreshold"];
    [RemainingClassThresholdButton setTitle:[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"Remaining Class"],threshold] forState:UIControlStateNormal];
    RemainingClassThresholdButton.tag=[threshold integerValue];

    
    reloadbutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-45, 34, 28,28)];
    [reloadbutton setImage:[UIImage imageNamed:@"reload_white.png"] forState:UIControlStateNormal];
    [reloadbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reloadbutton addTarget: self action:@selector(viewDidAppear:) forControlEvents: UIControlEventTouchUpInside];
     reloadbutton.hidden=YES;
    [supermasterview addSubview:reloadbutton];

    lastdayofweekindex=0;
    renewallogtablelistview.hidden=YES;

    
    supermasterviewbutton=[[UIButton alloc]initWithFrame:self.view.bounds];
    [supermasterviewbutton addTarget:self action:@selector(closecalendar) forControlEvents:UIControlEventTouchUpInside];
    [supermasterview addSubview:supermasterviewbutton];
    supermasterviewbutton.hidden=YES;
    
    
    calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 0, 320, self.view.bounds.size.height) Theme:1 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:YES showclassdot:NO schedulerecord:nil  UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
    calendarview.delegate=self;
    
    [supermasterview addSubview:calendarview];
    
    UIButton *menubutton=[[UIButton alloc]initWithFrame:CGRectMake(15, 35, 33, 22)];
    [menubutton setImage:[UIImage imageNamed:@"menu-button.png"] forState:UIControlStateNormal];
    [menubutton setContentMode:UIViewContentModeScaleToFill];
    [menubutton addTarget:self action:@selector(menubuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [supermasterview addSubview:menubutton];
    
    [self refreshlanguage];
    
    
    firstloadcover=[[UIView alloc]initWithFrame:CGRectMake(0, 68, self.view.bounds.size.width, self.view.bounds.size.height-68)];
    firstloadcover.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [supermasterview addSubview:firstloadcover];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checktoreloadapp) name:UIApplicationWillEnterForegroundNotification object:nil];
    
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
    
    sidewindowview=[[UIView alloc]initWithFrame:CGRectMake(mainWindow.bounds.size.width, 0, 0, mainWindow.bounds.size.height)];
    sidewindowview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    sidewindowview.hidden=YES;
    sidewindowview.autoresizingMask=UIViewAutoresizingNone;
    sidewindowview.tag=-200;
    [mainWindow addSubview:sidewindowview];
    
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
    ailoadindicator.center = CGPointMake(152.5,mainWindow.frame.size.height/2-7.5);
    ailoadindicator.hidesWhenStopped = YES;
    [ailoadindicator addSubview:activityImageView];
    [self->sidewindowview addSubview:ailoadindicator];
    
    //gotoautorenewal=FALSE;
    
}

-(void) checktoreloadapp
{
    
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {
        if ([myPopoverController presentingViewController].isBeingPresented) {
            [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([myStudentPopoverController presentingViewController].isBeingPresented){
            [[myStudentPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
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
                }else if ([myStudentPopoverController presentingViewController].isBeingPresented){
                    [[myStudentPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if (self.presentedViewController==switchcenterviewcontroller) {
                    [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
                }else{
                    [self.mainSlideMenu closeLeftMenu];
                }
        [self closesidewindow];
        [MyClass removeallsidewindowsexceptsidewindow:sidewindowview sidewindowbutton:sidewindowviewclosebutton];
                [self reloadPageWithFirstLoad:NO];

        
        
    }
}

-(void) refreshlanguage
{
    
    headercentername.text=[MyClass returnWindowTitle];
    headertitlename.text=[MyClass returntitlewithtitle:@"Course Renewal"];
    [self updateheadercentertitle];
    
    viewtitle.text=[MyClass returntitlewithtitle:@"Course Renewal"];
    studenttitle.text=[MyClass returntitlewithtitle:@"Student"];
    classtitle.text=[MyClass returntitlewithtitle:@"Subject"];
    schedulenametitle.text=[MyClass returntitlewithtitle:@"Schedule"];
    schedulenametitle.frame=CGRectMake(classtitle.frame.origin.x, 23, 150, 21);
    daytitle.text=[MyClass returntitlewithtitle:@"Class Day"];
    timetitle.text=[MyClass returntitlewithtitle:@"Time"];
    scheduledlefttitle.text=[MyClass returntitlewithtitle:@"Scheduled Left"];
    TBDmakeuplefttitle.text=[MyClass returntitlewithtitle:@"TBD Makeup Left"];
    lastdatetitle.text=[MyClass returntitlewithtitle:@"Last Class"];
    renewalstarttitle.text=[MyClass returntitlewithtitle:@"Renewal Start"];
    TBDclasslefttitle.text=[MyClass returntitlewithtitle:@"TBD Class Left"];
    [RemainingClassThresholdButton setTitle:[NSString stringWithFormat:@"%@ %ld",[MyClass returntitlewithtitle:@"Remaining Class"],(long)RemainingClassThresholdButton.tag] forState:UIControlStateNormal];
    //renewaltimetitle.text=[MyClass returntitlewithtitle:@"Renewal Time"];
    //renewalcounttitle.text=[MyClass returntitlewithtitle:@"Successful/Fail"];
    //renewalusertitle.text=[MyClass returntitlewithtitle:@"Performing Staff"];
    //batchcutoffdatetitle.text=[MyClass returntitlewithtitle:@"Cutoff Date"];
    
    [ManualRenewalButton setTitle:[MyClass returntitlewithtitle:@"Manual Renewal"] forState:UIControlStateNormal];
    [BatchRenewalButton setTitle:[MyClass returntitlewithtitle:@"Renewal Log"] forState:UIControlStateNormal];
    [sccoursetype setTitle:[MyClass returntitlewithtitle:@"Non-monthly Course"] forSegmentAtIndex:0];
    [sccoursetype setTitle:[MyClass returntitlewithtitle:@"Monthly Course"] forSegmentAtIndex:1];
    
    search_text.placeholder=[MyClass returntitlewithtitle:@"Search"];
    auto_search_text.placeholder=[MyClass returntitlewithtitle:@"Search"];
    
    [cutoffdatebutton setTitle:[MyClass convertDateFormatWithDate:[@(cutoffdatebutton.tag) stringValue] FromDateFormat:@"yyyyMMdd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES] forState:UIControlStateNormal];
    
    studenttitle_log.text=[MyClass returntitlewithtitle:@"Student"];
    subjecttitle_log.text=[MyClass returntitlewithtitle:@"Subject"];
    scheduletitle_log.text=[MyClass returntitlewithtitle:@"Schedule"];
    renewalstatustitle_log.text=[MyClass returntitlewithtitle:@"Renewal Status"];
    previousendtitle_log.text=[MyClass returntitlewithtitle:@"Previous End"];
    renewalstarttitle_log.text=[MyClass returntitlewithtitle:@"Renewal Start"];
    renewallogtitle_log.text=[MyClass returntitlewithtitle:@"Renewal Log"];
    
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


-(void) loadrenewalpage
{

    menubottombar.frame=CGRectMake(0,0, self.view.bounds.size.width/2, 40);
    menubottombar.backgroundColor=[UIColor darkGrayColor];
    //[supermasterview addSubview:menubottombar];
    
    ManualRenewalButton.backgroundColor=[UIColor clearColor];
    [ManualRenewalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ManualRenewalButton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    ManualRenewalButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    ManualRenewalButton.enabled=NO;
    ManualRenewalButton.tag=0;
    [ManualRenewalButton addTarget:self action:@selector(changerenewalmode:) forControlEvents:UIControlEventTouchUpInside];

    BatchRenewalButton.backgroundColor=[UIColor clearColor];
    [BatchRenewalButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    BatchRenewalButton.titleLabel.font=[UIFont systemFontOfSize:15];
    BatchRenewalButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    BatchRenewalButton.enabled=YES;
    BatchRenewalButton.tag=1;
    [BatchRenewalButton addTarget:self action:@selector(changerenewalmode:) forControlEvents:UIControlEventTouchUpInside];
    //[supermasterview addSubview:BatchRenewalButton];
    
    /*
    //Batch menu bar
    BatchMenuButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/2, 32)];
    BatchMenuButton.backgroundColor=[UIColor grayColor];
    [BatchMenuButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    BatchMenuButton.titleLabel.font=[UIFont systemFontOfSize:13];
    BatchMenuButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [BatchMenuButton setTitle:[MyClass returntitlewithtitle:@"Batch Renewal List"] forState:UIControlStateNormal];
    BatchMenuButton.enabled=NO;
    BatchMenuButton.tag=2000;
    [BatchMenuButton addTarget:self action:@selector(selectbatchmenu:) forControlEvents:UIControlEventTouchUpInside];
    [renewalbatchmenuview addSubview:BatchMenuButton];
    
    BatchMenuButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width/2, 0, self.view.bounds.size.width/2, 32)];
    BatchMenuButton.backgroundColor=[UIColor grayColor];
    [BatchMenuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    BatchMenuButton.titleLabel.font=[UIFont systemFontOfSize:13];
    BatchMenuButton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [BatchMenuButton setTitle:[MyClass returntitlewithtitle:@"Batch Renewal Log"] forState:UIControlStateNormal];
    BatchMenuButton.enabled=YES;
    BatchMenuButton.tag=2001;
    [BatchMenuButton addTarget:self action:@selector(selectbatchmenu:) forControlEvents:UIControlEventTouchUpInside];
    [renewalbatchmenuview addSubview:BatchMenuButton];
    */
    
    //Manual menu bar
    //renewalrecordtablelistview=[[UIView alloc]initWithFrame:CGRectMake(0, 109, self.view.bounds.size.width, self.view.bounds.size.height-109)];
    renewalrecordtablelistview.backgroundColor=[UIColor whiteColor];
    //[supermasterview addSubview:renewalrecordtablelistview];
    
    /*long width=(self.view.frame.size.width-223)/classdayarray.count;
    renewalmanualmenudayview=[[UIView alloc]initWithFrame:CGRectMake(0, 41, width, 32)];
    //[renewalrecordtablelistview addSubview:renewalmanualmenudayview];
    for (int i=0; i<classdayarray.count; i++) {
        DayButton=[[UIButton alloc]initWithFrame:CGRectMake(i*width, 0, width, 32)];
        DayButton.backgroundColor=[UIColor grayColor];
        [DayButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        DayButton.titleLabel.font=[UIFont systemFontOfSize:13];
        DayButton.titleLabel.textAlignment=NSTextAlignmentCenter;
        [DayButton setTitle:[MyClass returntitlewithtitle:[classdayarray objectAtIndex:i]] forState:UIControlStateNormal];
        DayButton.enabled=NO;
        DayButton.tag=1000+i;
        [DayButton addTarget:self action:@selector(selectclassday:) forControlEvents:UIControlEventTouchUpInside];
        [renewalmanualmenudayview addSubview:DayButton];
    }
    [self highlightdaybuttonwithbuttontag:1000];*/
    



    //RemainingClassThresholdButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2+1, 1, 200, 29)];
    [RemainingClassThresholdButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    RemainingClassThresholdButton.backgroundColor=themecolor;
    RemainingClassThresholdButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    RemainingClassThresholdButton.titleLabel.font=[UIFont systemFontOfSize:12];
    RemainingClassThresholdButton.layer.cornerRadius=5;
    RemainingClassThresholdButton.layer.masksToBounds=YES;
    [RemainingClassThresholdButton addTarget:self action:@selector(remainingclassthresholdpressed:) forControlEvents:UIControlEventTouchUpInside];
    //[renewalrecordtablelistview addSubview:RemainingClassThresholdButton];
    
    //remainingclassthresholdtitle=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 29)];
    //remainingclassthresholdtitle.textColor=[UIColor whiteColor];
    //remainingclassthresholdtitle.backgroundColor=[UIColor systemGroupedBackgroundColor];
   // remainingclassthresholdtitle.textAlignment=NSTextAlignmentCenter;
    //remainingclassthresholdtitle.font=[UIFont systemFontOfSize:13];
    //remainingclassthresholdtitle.numberOfLines=0;
    //[RemainingClassThresholdButton addSubview:remainingclassthresholdtitle];
    

    
    //[self loadtableheader];
    
    //RenewalRecordTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 82, self.view.bounds.size.width, renewalrecordtablelistview.frame.size.height-82-2)];
    //RenewalRecordTable.delegate=self;
    //RenewalRecordTable.dataSource=self;
    
    clpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(renewalRecordTableLongPress:)];
    clpgr.delegate = self;
    [RenewalRecordTable addGestureRecognizer:clpgr];
    
    if ([RenewalRecordTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        RenewalRecordTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    //[renewalrecordtablelistview addSubview:RenewalRecordTable];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    //tablerefresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [tablerefresh addTarget:self action:@selector(refreshrenewalrecordtable) forControlEvents:UIControlEventValueChanged];
    [RenewalRecordTable addSubview:tablerefresh];
    

    //renewal batch log view
    //renewallogtablelistview=[[UIView alloc]initWithFrame:CGRectMake(0, 109, self.view.bounds.size.width, self.view.frame.size.height-109)];
//    renewallogtablelistview.backgroundColor=[UIColor colorWithRed:26.0/255.0 green:152.0/255.0 blue:221.0/255.0 alpha:0.7];
    //[supermasterview addSubview:renewallogtablelistview];
    
    //RenewalLogTable=[[UITableView alloc]initWithFrame:CGRectMake(0, grouplogheaderheight, self.view.bounds.size.width, renewallogtablelistview.frame.size.height-grouplogheaderheight)];
    //RenewalLogTable.delegate=self;
    //RenewalLogTable.dataSource=self;
    if ([LogTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        LogTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    //[renewallogtablelistview addSubview:RenewalLogTable];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    //tablerefresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [tablerefresh addTarget:self action:@selector(refreshrenewallogtable) forControlEvents:UIControlEventValueChanged];
    [LogTable addSubview:tablerefresh];
    
    if ([LogDetailsTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        LogDetailsTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    

    /*
    //renewaltimetitle=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, grouplogheaderheight)];
    renewaltimetitle.textColor=[UIColor darkGrayColor];
    renewaltimetitle.font=[UIFont boldSystemFontOfSize:13];
    [renewallogtablelistview addSubview:renewaltimetitle];
    
    //renewalcounttitle=[[UILabel alloc]initWithFrame:CGRectMake(500, 0, 150, grouplogheaderheight)];
    renewalcounttitle.textColor=[UIColor darkGrayColor];
    renewalcounttitle.font=[UIFont boldSystemFontOfSize:13];
    [renewallogtablelistview addSubview:renewalcounttitle];
    
    
    //renewalusertitle=[[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-236, 0, 150, grouplogheaderheight)];
    renewalusertitle.textColor=[UIColor darkGrayColor];
    renewalusertitle.font=[UIFont boldSystemFontOfSize:13];
    [renewallogtablelistview addSubview:renewalusertitle];

    //batchcutoffdatetitle=[[UILabel alloc]initWithFrame:CGRectMake(253, 0, 150, grouplogheaderheight)];
    batchcutoffdatetitle.textColor=[UIColor darkGrayColor];
    batchcutoffdatetitle.font=[UIFont boldSystemFontOfSize:13];
    [renewallogtablelistview addSubview:batchcutoffdatetitle];
    */
    /*
    BatchRenewalSubmitButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-100, 0, 100, 51)];
    [BatchRenewalSubmitButton setBackgroundColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0]];
    [BatchRenewalSubmitButton setTitle:[MyClass returntitlewithtitle:@"Submit"] forState:UIControlStateNormal];
    BatchRenewalSubmitButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [BatchRenewalSubmitButton addTarget:self action:@selector(submitbatchrenewalpressed) forControlEvents:UIControlEventTouchUpInside];
    [renewalrecordtablelistview addSubview:BatchRenewalSubmitButton];

    BatchRenewalSelectAllButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-125, 0, 25, 25)];
    [BatchRenewalSelectAllButton setImage:[UIImage imageNamed:@"selectall_icon.png"] forState:UIControlStateNormal];
    [BatchRenewalSelectAllButton addTarget:self action:@selector(batchselectallpressed) forControlEvents:UIControlEventTouchUpInside];
    [renewalrecordtablelistview addSubview:BatchRenewalSelectAllButton];
    
    BatchRenewalDeselectAllButton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width-125, 26, 25, 25)];
    [BatchRenewalDeselectAllButton setImage:[UIImage imageNamed:@"deselectall_icon.png"] forState:UIControlStateNormal];
    [BatchRenewalDeselectAllButton addTarget:self action:@selector(batchdeselectallpressed) forControlEvents:UIControlEventTouchUpInside];
    [renewalrecordtablelistview addSubview:BatchRenewalDeselectAllButton];
*/
    
    //sccoursetype = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Non-monthly Course",@"Monthly Course",nil]];
    //sccoursetype.frame=CGRectMake(1, 1, self.view.frame.size.width/2-3-200, 29);
    [sccoursetype addTarget:self action:@selector(selectcoursetype:) forControlEvents:UIControlEventValueChanged];
    sccoursetype.selectedSegmentIndex=0;
    sccoursetype.tintColor=themecolor;
    //[sccoursetype setTintColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0]];
    //[renewalrecordtablelistview addSubview:sccoursetype];
    
    
    //cutoffdatebutton=[[UIButton alloc]initWithFrame:CGRectMake(2+sccoursetype.frame.size.width, 1, 200, 29)];
    [cutoffdatebutton setTitle:[MyClass returntitlewithtitle:@"All Classes"] forState:UIControlStateNormal];
    [cutoffdatebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cutoffdatebutton.backgroundColor=themecolor;
    cutoffdatebutton.titleLabel.font=[UIFont systemFontOfSize:12];
    cutoffdatebutton.layer.cornerRadius=5;
    [cutoffdatebutton addTarget: self action:@selector(opencalendar) forControlEvents: UIControlEventTouchUpInside];
    //[renewalrecordtablelistview addSubview:cutoffdatebutton];
    cutoffdatebutton.tag=[[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyyMMdd"] integerValue];
    

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
    
    auto_search_text.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:0.8];//[UIColor lightGrayColor];
    auto_search_text.font=[UIFont systemFontOfSize:12];
    auto_search_text.textColor=[UIColor whiteColor];
    auto_search_text.layer.cornerRadius=3;
    auto_search_text.layer.masksToBounds=YES;
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:[MyClass returntitlewithtitle:@"Search"] attributes:@{ NSForegroundColorAttributeName : [UIColor systemGroupedBackgroundColor] }];
    auto_search_text.attributedPlaceholder = str;
    [auto_search_text setTintColor:[UIColor whiteColor]];
    [auto_search_text addTarget:self action:@selector(updateautosearchtext)forControlEvents:UIControlEventEditingChanged];
    auto_search_text.clearButtonMode = UITextFieldViewModeWhileEditing;
    auto_search_text.layer.sublayerTransform = CATransform3DMakeTranslation(0, 1, 0);
    [auto_search_text setLeftViewMode:UITextFieldViewModeAlways];
    
    selectbutton.layer.cornerRadius=5;
    [selectbutton addTarget: self action:@selector(selectbuttonpressed) forControlEvents: UIControlEventTouchUpInside];
    //[renewalrecordtablelistview addSubview:selectbutton];
    
    
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 27, search_text.frame.size.height)];
    UIImageView *searchimage=[[UIImageView alloc]initWithFrame:CGRectMake(5,(search_text.frame.size.height-15)/2,15,15)];
    [searchimage setImage:[UIImage imageNamed:@"searchbutton.png"]];
    [spacerView addSubview:searchimage];
    [search_text setLeftView:spacerView];
    
    UIView *autospacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 27, auto_search_text.frame.size.height)];
    UIImageView *autosearchimage=[[UIImageView alloc]initWithFrame:CGRectMake(5,(auto_search_text.frame.size.height-15)/2,15,15)];
    [autosearchimage setImage:[UIImage imageNamed:@"searchbutton.png"]];
    [autospacerView addSubview:autosearchimage];
    [auto_search_text setLeftView:autospacerView];
    
    
    //batchrenewalview=[[UIView alloc]initWithFrame:CGRectMake(0,renewalrecordtablelistview.frame.size.height, renewalrecordtablelistview.frame.size.width, 42)];
    //[renewalrecordtablelistview addSubview:batchrenewalview];
    //batchrenewalview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    batchrenewalviewopened=FALSE;
    BatchRenewalEnrollmentkeyArray=[[NSMutableArray alloc]init];
    
    submitbatchrenewalbutton=[[UIButton alloc]initWithFrame:CGRectMake(10,8,200,42-16)];
    [submitbatchrenewalbutton setTitle:[MyClass returntitlewithtitle:@"Submit Batch"] forState:UIControlStateNormal];
    [submitbatchrenewalbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [submitbatchrenewalbutton setTitleColor:themecolor forState:UIControlStateNormal];
    submitbatchrenewalbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [submitbatchrenewalbutton addTarget: self action:@selector(submitbatchrenewalpressed) forControlEvents: UIControlEventTouchUpInside];
    submitbatchrenewalbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    submitbatchrenewalbutton.enabled=NO;
    [batchrenewalview addSubview:submitbatchrenewalbutton];
    
    UIImageView *selectallicon=[[UIImageView alloc]initWithFrame:CGRectMake(270, (42-16)/2, 16, 16)];
    selectallicon.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    selectallicon.layer.cornerRadius=8;
    selectallicon.layer.borderColor=[UIColor whiteColor].CGColor;
    selectallicon.layer.borderWidth=1;
    selectallicon.layer.opacity=1;
    [batchrenewalview addSubview:selectallicon];
    
    UIButton *selectallclassbutton=[[UIButton alloc]initWithFrame:CGRectMake(300,0,120,42)];
    [selectallclassbutton setTitle:[MyClass returntitlewithtitle:@"Select all"] forState:UIControlStateNormal];
    [selectallclassbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    selectallclassbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [selectallclassbutton addTarget: self action:@selector(selectallclass) forControlEvents: UIControlEventTouchUpInside];
    selectallclassbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [batchrenewalview addSubview:selectallclassbutton];
    
    UIImageView *deselectallicon=[[UIImageView alloc]initWithFrame:CGRectMake(420, (42-16)/2, 16, 16)];
    deselectallicon.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    deselectallicon.layer.cornerRadius=8;
    deselectallicon.layer.borderColor=[UIColor whiteColor].CGColor;
    deselectallicon.layer.borderWidth=1;
    deselectallicon.layer.opacity=0.3;
    [batchrenewalview addSubview:deselectallicon];
    
    UIButton *deselectallclassbutton=[[UIButton alloc]initWithFrame:CGRectMake(450,0,120,42)];
    [deselectallclassbutton setTitle:[MyClass returntitlewithtitle:@"Deselect all"] forState:UIControlStateNormal];
    [deselectallclassbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    deselectallclassbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [deselectallclassbutton addTarget: self action:@selector(deselectallclass) forControlEvents: UIControlEventTouchUpInside];
    deselectallclassbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [batchrenewalview addSubview:deselectallclassbutton];
    
    
    UIButton *cancelsubmitbatchbutton=[[UIButton alloc]initWithFrame:CGRectMake(batchrenewalview.frame.size.width-140,0,120,42)];
    [cancelsubmitbatchbutton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    [cancelsubmitbatchbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    cancelsubmitbatchbutton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelsubmitbatchbutton addTarget: self action:@selector(cancelsubmitbatchbuttonpressed) forControlEvents: UIControlEventTouchUpInside];
    cancelsubmitbatchbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [batchrenewalview addSubview:cancelsubmitbatchbutton];
}



-(void) reloadtableheader
{
    LeftBlock.hidden=!batchrenewalviewopened;
}


-(void) refreshrenewalrecordtable
{
        [self retrieveRenewalRecordWithSelectedDate:cutoffdatebutton.tag remainingclass:RemainingClassThresholdButton.tag classday:@"All"];

    for (id object in [RenewalRecordTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshrenewallogtable
{
    //RenewalGroupLogExpandRowArray=[[NSMutableArray alloc]init];
    highlightedconectionid=@"";
    [self retrieveRenewalLogList];
    for (id object in [LogTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
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


-(BOOL) retrieveRenewalRecordWithSelectedDate:(NSInteger)dateselected remainingclass:(NSInteger)remainingclass classday:(NSString *)classday
{
    NSString *dateselectedstring=[MyClass convertDateFormatWithDate:[@(dateselected) stringValue] FromDateFormat:@"yyyyMMdd" ToDateFormat:@"yyyy-MM-dd"];
    classday=@"All";
    
    //[df setDateFormat:@"dd-MMM-yyyy"];
    //NSDate *date=[df dateFromString:dateselected];
    //[df setDateFormat:@"yyyy-MM-dd"];
    //create string contains url address for php file
    
    NSString *strURL;
    __block NSString *snewdate;
    //BOOL hasWeeklySchedule=FALSE;
    //BOOL hasFreeSchedule=FALSE;
    
    if ([((UserPrivilege *)[MyClass returnuserprivilegewithcenterkey:globalvariables.centerrecord.centerkey]).role isEqualToString:@"Instructor"]) {
        if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).viewallinstructorclass) {
            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectrenewal&date=%@&remainingclass=%ld&classday=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclassrenewal"],dateselectedstring,(long)remainingclass,classday];
        }else{
            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectrenewal&date=%@&remainingclass=%ld&classday=%@&instructor=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclassrenewal"],dateselectedstring,(long)remainingclass,classday,globalvariables.username];
        }
    }else{
        strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectrenewal&date=%@&remainingclass=%ld&classday=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclassrenewal"],dateselectedstring,(long)remainingclass,classday];
    }
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result = TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            RenewalRecordArrayAllResult=[[NSMutableArray alloc]init];
            RenewalRecordArrayFilterResult=[[NSMutableArray alloc]init];
            BatchRenewalEnrollmentkeyArray=[[NSMutableArray alloc]init];
            AllScheduleArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our Instructor object
                //NSString * scenterkey=[[JSONArray objectAtIndex:i] objectForKey:@"centerkey"];
                NSString * sstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                NSString * senrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
                NSString * sstudentfullname=[MyClass returnStudentnameWithStudentkey:sstudentkey option:@"full"];
                NSString * ssubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString * sclassday=[[JSONArray objectAtIndex:i] objectForKey:@"classday"];
                NSString * sclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                NSString * slevelmain=[[JSONArray objectAtIndex:i] objectForKey:@"levelmain"];
                NSString * slevelctm=[[JSONArray objectAtIndex:i] objectForKey:@"levelctm"];
                NSString * sremainingclass = [[JSONArray objectAtIndex:i] objectForKey:@"remainingclass"];
                NSString * sremainingclassTBDmakeup = [[JSONArray objectAtIndex:i] objectForKey:@"remainingclassTBDmakeup"];
                NSString * sremainingclassTBDclass = [[JSONArray objectAtIndex:i] objectForKey:@"remainingclassTBDclass"];
                NSString * sautorenew=[[JSONArray objectAtIndex:i] objectForKey:@"autorenew"];
                NSString * sschedulekey=[[JSONArray objectAtIndex:i] objectForKey:@"schedulekey"];
//                NSString * coursetype=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:ssubject centerkey:globalvariables.centerrecord.centerkey]).enrollmentmode;
                NSString * scoursetype = [[JSONArray objectAtIndex:i] objectForKey:@"enrollmentmode"];
                
                NSString * slastdate;
                NSString *srenewalstartdate;
                
                if ([sclassday isEqualToString:@"TBF"]) {
                    slastdate=[MyClass returntitlewithtitle:@"TBF"];
                    srenewalstartdate=@"";
                }else{
                    if ([[[[JSONArray objectAtIndex:i] objectForKey:@"enddate"] substringFromIndex:11] isEqualToString:@"TBD"]) {
                        slastdate=[NSString stringWithFormat:@"%@ %@",[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:[[[JSONArray objectAtIndex:i] objectForKey:@"enddate"] substringToIndex:10]],@"TBD"];
                        srenewalstartdate=@"";
                    }else{
                        slastdate=[MyClass convertYYYYMMDDHHMMtoDDMMMYYYYHHMMwithdatetime:[[JSONArray objectAtIndex:i] objectForKey:@"enddate"]];
                        if ([sschedulekey isEqualToString:@"-2"]) {
                            srenewalstartdate=@"";
                        }else if ([sschedulekey isEqualToString:@"-1"]){
                            //snewdate=[self findNextClassDayWithEndDate:[slastdate substringToIndex:11] Classday:[MyClass returndayofweek:[slastdate substringToIndex:11]]];
                            
                            NSMutableArray *result=[MyClass findnextlessonwithdatetime:[slastdate substringToIndex:11] dayofweek:[slastdate substringToIndex:11] schedulerecord:[MyClass returnscheduleinformationwithsubject_shortname:ssubject schedulekey:sschedulekey centerkey:globalvariables.centerrecord.centerkey] nooflesson:1 includebasedate:NO excludescheduleenddatecheck:NO manualselection:NO];
                            if (result.count>0) {
                                lesson2object=[result firstObject];
                                snewdate=lesson2object.datetime;
                                srenewalstartdate=[NSString stringWithFormat:@"%@ %@",snewdate,[slastdate substringFromIndex:12]];
                            }else{
                                srenewalstartdate=@"";
                            }
                        }else{
                            NSMutableArray *result=[MyClass findnextlessonwithdatetime:slastdate dayofweek:[MyClass returndayofweek:slastdate] schedulerecord:[MyClass returnscheduleinformationwithsubject_shortname:ssubject schedulekey:sschedulekey centerkey:globalvariables.centerrecord.centerkey] nooflesson:1 includebasedate:NO excludescheduleenddatecheck:NO manualselection:NO];
                            if (result.count>0) {
                                lesson2object=[result firstObject];
                                snewdate=lesson2object.datetime;
                                srenewalstartdate=snewdate;
                            }else{
                                srenewalstartdate=@"";
                            }
                        }
                    }
                }

                
                [RenewalRecordArrayAllResult addObject:[[RenewalRecord alloc]initRenewalRecordWithstudentkey:sstudentkey andenrollmentkey:senrollmentkey andstudentfullname:sstudentfullname andclassday:sclassday andsubject:ssubject andclasstime:sclasstime andlevelmain:slevelmain andlevelctm:slevelctm andremainingclass:sremainingclass andremainingclassTBDmakeup:sremainingclassTBDmakeup andlastdate:slastdate andrenewalstartdate:srenewalstartdate andschedulekey:sschedulekey andremainingclassTBDclass:sremainingclassTBDclass andautorenew:sautorenew coursetype:scoursetype]];
                
            }
        }
    }];
    
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        [self returnfilterrenewalrecordarray];;
    }else{
        [MyClass showconnectionlostdialogbox];
    }
    
    return result;
    
}


-(BOOL) retrieveRenewalLogList
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectrenewalloglist",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewclassrenewal"]];

    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result = TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *jsonArray = jsonreturned[@"content"];
            RenewalGroupLogArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<jsonArray.count; i++) {
                
                RenewalLogArray=[[NSMutableArray alloc]init];

                //Create our Instructor object
                NSString * stimeconnectionid=[[jsonArray objectAtIndex:i] objectForKey:@"timeconnectionid"];
                NSString * susername = [[jsonArray objectAtIndex:i] objectForKey:@"username"];
                NSString * ssuccessfulcount = [[jsonArray objectAtIndex:i] objectForKey:@"successfulcount"];
                NSString * sfailcount = [[jsonArray objectAtIndex:i] objectForKey:@"failcount"];
                NSString * sbatchcutoffdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:[[jsonArray objectAtIndex:i] objectForKey:@"batchcutoffdate"]];
                [RenewalGroupLogArray addObject:[[RenewalGroupLog alloc]initRenewalGroupLogwithtimeconnectionid:stimeconnectionid username:susername successfulcount:ssuccessfulcount failcount:sfailcount renewallogarray:RenewalLogArray batchcutoffdate:sbatchcutoffdate filtervalue:@"Both"]];

            }
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            result = TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *jsonArray = jsonreturned[@"content"];
            RenewalGroupLogArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<jsonArray.count; i++) {
                
                RenewalLogArray=[[NSMutableArray alloc]init];

                //Create our Instructor object
                NSString * stimeconnectionid=[[jsonArray objectAtIndex:i] objectForKey:@"timeconnectionid"];
                NSString * susername = [[jsonArray objectAtIndex:i] objectForKey:@"username"];
                NSString * ssuccessfulcount = [[jsonArray objectAtIndex:i] objectForKey:@"successfulcount"];
                NSString * sfailcount = [[jsonArray objectAtIndex:i] objectForKey:@"failcount"];
                NSString * sbatchcutoffdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:[[jsonArray objectAtIndex:i] objectForKey:@"batchcutoffdate"]];
                [RenewalGroupLogArray addObject:[[RenewalGroupLog alloc]initRenewalGroupLogwithtimeconnectionid:stimeconnectionid username:susername successfulcount:ssuccessfulcount failcount:sfailcount renewallogarray:RenewalLogArray batchcutoffdate:sbatchcutoffdate filtervalue:@"Both"]];

            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
            
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    
    if (result) {
        [LogTable reloadData];

        if (RenewalGroupLogArray.count>0) {
            if (RenewalGroupLogArray.count>=groupLogSelected) {
                [self retrieveRenewalLogDetailswithconnectionid:((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:groupLogSelected]).timeconnectionid];
//                ((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:groupLogSelected]).renewallogarray=[[NSMutableArray alloc]initWithArray:[self retrieveRenewalLogDetailswithconnectionid:((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:groupLogSelected]).timeconnectionid]];
                [LogDetailsTable reloadData];
            }
        }
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    return result;
}

-(void) retrieveRenewalLogDetailswithconnectionid:(NSString *)timeconnectionid
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectrenewallogdetail&timeconnectionid=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,timeconnectionid];
    
    __block BOOL result=FALSE;
    __block NSMutableArray *resultarray=[[NSMutableArray alloc]init];
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result = TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our Instructor object
                NSString * stimeconnectionid=[[JSONArray objectAtIndex:i] objectForKey:@"timeconnectionid"];
                NSString * ssubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString * sstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                NSString * sfirstname=[[JSONArray objectAtIndex:i] objectForKey:@"firstname"];
                NSString * slastname=[[JSONArray objectAtIndex:i] objectForKey:@"lastname"];
                NSString * slevelmain=[[JSONArray objectAtIndex:i] objectForKey:@"levelmain"];
                NSString * simage=[[JSONArray objectAtIndex:i] objectForKey:@"image"];
                NSString * srenewalresultenglish=[[JSONArray objectAtIndex:i] objectForKey:@"renewalresultenglish"];
                NSString * srenewalresultchinese=[[JSONArray objectAtIndex:i] objectForKey:@"renewalresultchinese"];
                NSString * sstandardnoofclassormonth=[[JSONArray objectAtIndex:i] objectForKey:@"standardnoofclassormonth"];
                NSString * senrollmentmode=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentmode"];
                NSString * soldenrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"lastenrollmentkey"];
                NSString * slastclass=[MyClass convertYYYYMMDDHHMMtoDDMMMYYYYHHMMwithdatetime:[[JSONArray objectAtIndex:i] objectForKey:@"lastclass"]];
                if ([[MyClass leadingtrailingspacestrimmed:slastclass] length]==10) {
                    slastclass=[MyClass convertDateFormatWithDate:slastclass FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                }
                NSString * sschedulekey = [[JSONArray objectAtIndex:i] objectForKey:@"schedulekey"];
                NSString * susername = [[JSONArray objectAtIndex:i] objectForKey:@"username"];
                NSString * sfirstclass=[MyClass convertYYYYMMDDHHMMtoDDMMMYYYYHHMMwithdatetime:[[JSONArray objectAtIndex:i] objectForKey:@"newstartdate"]];
                NSString * sbatchcutoffdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:[[JSONArray objectAtIndex:i] objectForKey:@"batchcutoffdate"]];
                NSString * snewenrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"newenrollmentkey"];
                NSString * sstatus;
                NSString * slateststartdate=[MyClass convertYYYYMMDDHHMMtoDDMMMYYYYHHMMwithdatetime:[[JSONArray objectAtIndex:i] objectForKey:@"lateststartdate"]];
                
                if (![snewenrollmentkey isEqualToString:@""]) {
                    sstatus=@"Successful";
                }else{
                    if ([slateststartdate isEqualToString:@"0"]) {
                        sfirstclass=@"";
                        sstatus=@"Failed";
                    }else if ([slateststartdate isEqualToString:@"-1"] || [slateststartdate isEqualToString:@"-2"] || [slateststartdate isEqualToString:@"-3"]){
                        sfirstclass=@"";
                        sstatus=@"Successful";
                    }else{
                        sfirstclass=slateststartdate;
                        sstatus=@"Successful";
                    }
                }

                
                [resultarray addObject:[[RenewalLog alloc]initRenewalLogwithtimeconnectionid:[self convertconnectionidtodatetime:stimeconnectionid] subject:ssubject studentkey:sstudentkey firstname:sfirstname lastname:slastname lastclass:slastclass renewalresultenglish:srenewalresultenglish renewalresultchinese:srenewalresultchinese newenrollmentkey:snewenrollmentkey oldenrollmentkey:soldenrollmentkey standardnoofclassormonth:sstandardnoofclassormonth enrollmentmode:senrollmentmode schedulekey:sschedulekey username:susername firstclass:sfirstclass image:simage levelmain:slevelmain batchcutoffdate:sbatchcutoffdate status:sstatus lateststartdate:slateststartdate]];

            }
        }
    }];
    
            
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        [LogTable reloadData];
    }
    
    renewallogarray=[[NSMutableArray alloc]initWithArray:resultarray];
    [self returnfilterrenewallogarray];

}

- (NSString *) convertconnectionidtodatetime:(NSString *)connectionid
{
    NSDate *date=[MyClass convertToNSDateWithDate:[connectionid substringToIndex:12] DateFormat:@"yyyyMMddHHmm"];
    return [MyClass convertToNSStringWithNSDate:date DateFormat:@"dd-MMM-yyyy HH:mm"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    /*if (tableView==RenewalRecordTable){
        return 1;
    }else{
        return RenewalGroupLogArray.count;
    }*/
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==RenewalRecordTable) {
        return RenewalRecordArrayFilterResult.count;
    }else if (tableView==LogDetailsTable){
        if (RenewalGroupLogArray.count>0) {
            return ((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:groupLogSelected]).renewallogarray.count;
        }else{
            return 0;
        }
        
    }else{
        return RenewalGroupLogArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==LogTable) {
        return 45;
    }else if (tableView==LogDetailsTable){
        return UITableViewAutomaticDimension;
    }else{
        return 45;
    }
}

-(NSString *) returnRenewalStatusWithnewenrollmentkey:(NSString *)newenrollmentkey lateststartdate:(NSString *)lateststartdate
{
    if (![newenrollmentkey isEqualToString:@""]) {
        return @"Successful";
    }else{
        if ([lateststartdate isEqualToString:@"0"]) {
            return @"Failed";
        }else if ([lateststartdate isEqualToString:@"-1"]){
            return @"Dropped";
        }else if ([lateststartdate isEqualToString:@"-2"]){
            return @"Auto renew turned off";
        }else if ([lateststartdate isEqualToString:@"-3"]){
            return @"Voided";
        }else if ([lateststartdate isEqualToString:@"-4"]){
            return @"Previous renewed enrollment manually deleted";
        }else{
            return @"Renewed";
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==LogTable) {
        return CGFLOAT_MIN;
    }else{
        return CGFLOAT_MIN;
    }
}

-(void) filterlog:(UIButton *)sender
{
    if ([((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:sender.tag]).filtervalue isEqualToString:@"Both"]) {
        ((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:sender.tag]).filtervalue=@"Failed";
    }else if ([((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:sender.tag]).filtervalue isEqualToString:@"Failed"]) {
        ((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:sender.tag]).filtervalue=@"Successful";
    }else if ([((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:sender.tag]).filtervalue isEqualToString:@"Successful"]) {
        ((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:sender.tag]).filtervalue=@"Both";
    }
    sender.enabled=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [LogDetailsTable reloadData];
        sender.enabled=YES;
    });
    


}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        lastcellcolor=@"nonwhite";
    }
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];

    if (tableView == RenewalRecordTable) {
        
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"renewalcell";
        
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        RenewalRecordObject = [RenewalRecordArrayFilterResult objectAtIndex:indexPath.row];
        Student *student=[MyClass returnstudentwithstudentkey:RenewalRecordObject.studentkey];
        
        cell.imageview1.layer.borderColor=[UIColor whiteColor].CGColor;
        cell.imageview1.layer.borderWidth=1;

        
        
        cell.label1.text=[MyClass returnStudentnameWithStudentkey:RenewalRecordObject.studentkey option:@"full"];//[self returnstudentnamewithfirstname:RenewalRecordObject.firstname lastname:RenewalRecordObject.lastname];

        
        cell.label3.text=[MyClass returnschedulenamewithsubject_shortname:RenewalRecordObject.subject schedulekey:RenewalRecordObject.schedulekey centerkey:globalvariables.centerrecord.centerkey];
        
        cell.label2.text=[MyClass returnsubjectnamewithsubject_shortname:RenewalRecordObject.subject centerkey:globalvariables.centerrecord.centerkey];
        cell.label5.text=[MyClass returntitlewithtitle:RenewalRecordObject.classday];
        cell.label4.text=[MyClass returntitlewithtitle:RenewalRecordObject.classtime];
        cell.label6.text=RenewalRecordObject.remainingclass;
        cell.label7.text=RenewalRecordObject.remainingclassTBDmakeup;
        cell.label8.text=RenewalRecordObject.remainingclassTBDclass;
        cell.label9.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:RenewalRecordObject.lastdate];
        
        if ([RenewalRecordObject.renewalstartdate isEqualToString:@"TBD"]) {
            cell.label10.text=[MyClass returntitlewithtitle:RenewalRecordObject.renewalstartdate];
        }else{
            cell.label10.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:RenewalRecordObject.renewalstartdate];
        }
        
        if ([RenewalRecordObject.autorenew isEqualToString:@"Yes"] && globalvariables.centerrecord.enableautobatchrenew) {
            cell.imageview3.hidden=NO;
        }else{
            cell.imageview3.hidden=YES;
        }
        
        if (batchrenewalviewopened) {
            cell.view1.hidden=NO;
            if ([self includerenewalrecordwithBatchRenewalEnrollmentArray:BatchRenewalEnrollmentkeyArray Enrollmentkey:RenewalRecordObject.enrollmentkey]>=0) {
                cell.imageview1.layer.opacity=1;
            }else{
                cell.imageview1.layer.opacity=0.3;
            }
            

            if (BatchRenewalEnrollmentkeyArray.count==0) {
                [submitbatchrenewalbutton setTitle:[MyClass returntitlewithtitle:@"Submit Batch"] forState:UIControlStateNormal];
                submitbatchrenewalbutton.enabled=FALSE;
            }else{
                [submitbatchrenewalbutton setTitle:[NSString stringWithFormat:@"%@ (%lu)",[MyClass returntitlewithtitle:@"Submit Batch"],(unsigned long)BatchRenewalEnrollmentkeyArray.count] forState:UIControlStateNormal];
                submitbatchrenewalbutton.enabled=TRUE;
            }

        }else{
            cell.view1.hidden=YES;
        }
        
        cell.separatorInset=UIEdgeInsetsMake(0, batchrenewalviewopened?40:0, 0, 0);
        
        //alternative background color;
        if (indexPath.row %2==0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        /*StudentNameLabel.textColor=[UIColor darkGrayColor];
        ClassLabel.textColor=[UIColor darkGrayColor];
        ClassDayLabel.textColor=[UIColor darkGrayColor];
        ClassTimeLabel.textColor=[UIColor darkGrayColor];
        RemainingClassLabel.textColor=[UIColor darkGrayColor];
        RemainingClassTBDMakeupLabel.textColor=[UIColor darkGrayColor];
        LastDateLabel.textColor=[UIColor darkGrayColor];
        RenewalStartDateLabel.textColor=[UIColor darkGrayColor];*/
        
        [MyClass downloadImageWithImageview:cell.imageview2 gender:student.gender type:@"student" typekey:RenewalRecordObject.studentkey image:student.image async:YES];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
        singleTap.numberOfTapsRequired = 1;

        cell.imageview2.tag=indexPath.row;
        cell.imageview2.userInteractionEnabled = YES;
        [cell.imageview2 addGestureRecognizer:singleTap];
        
        [cell.stackview1 layoutIfNeeded];
        return cell;

    }else if (tableView == LogTable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"logcell";
        
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        RenewalGroupObject = [RenewalGroupLogArray objectAtIndex:indexPath.row];
        cell.label1.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:[self convertconnectionidtodatetime:RenewalGroupObject.timeconnectionid]];
        cell.label2.text= [RenewalGroupObject.username isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returnstaffnamewithusername:RenewalGroupObject.username firstorfullname:@"full"];;
        cell.label3.text=RenewalGroupObject.successfulcount;
        cell.label4.text=RenewalGroupObject.failcount;
        
        if (groupLogSelected==indexPath.row) {
            cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.22];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        
        
        return cell;
    
    }else if (tableView == LogDetailsTable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"detailscell";
        
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        RenewalLogObject = [((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:groupLogSelected]).renewallogarray objectAtIndex:indexPath.row];
        
        [MyClass downloadImageWithImageview:cell.imageview1 gender:@"" type:@"student" typekey:RenewalLogObject.studentkey image:RenewalLogObject.image async:YES];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
        singleTap.numberOfTapsRequired = 1;

        cell.imageview1.tag=indexPath.row;
        cell.imageview1.userInteractionEnabled = YES;
        [cell.imageview1 addGestureRecognizer:singleTap];
        
        cell.label1.text=[MyClass returnStudentnameWithStudentkey:RenewalLogObject.studentkey option:@"full"];
        cell.label2.text=[MyClass returnsubjectnamewithsubject_shortname:RenewalLogObject.subject centerkey:globalvariables.centerrecord.centerkey];
        cell.label3.text=[MyClass returnschedulenamewithsubject_shortname:RenewalLogObject.subject schedulekey:RenewalLogObject.schedulekey centerkey:globalvariables.centerrecord.centerkey];
        
        cell.label3.text=[NSString stringWithFormat:@"%@ | %@",cell.label3.text,RenewalLogObject.levelmain];
        
        cell.label4.text=[globalvariables.language isEqualToString:@"English"]?RenewalLogObject.renewalresultenglish:RenewalLogObject.renewalresultchinese;
        NSString *renewalstatus=[self returnRenewalStatusWithnewenrollmentkey:RenewalLogObject.newenrollmentkey lateststartdate:RenewalLogObject.lateststartdate];
        if (![renewalstatus isEqualToString:@"Successful"] && ![renewalstatus isEqualToString:@"Failed"]) {
            cell.label4.text=[NSString stringWithFormat:@"(%@) %@",[MyClass returntitlewithtitle:renewalstatus],cell.label4.text];
        }
        
        if ([RenewalLogObject.firstclass isEqualToString:@"TBD"]) {
            cell.label6.text=[MyClass returntitlewithtitle:RenewalLogObject.firstclass];
        }else{
            cell.label6.text=[MyClass convertDateFormatWithDate:RenewalLogObject.firstclass FromDateFormat:@"dd-MMM-yyyy HH:mm" ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES];
        }
        
        if (![RenewalLogObject.newenrollmentkey isEqualToString:@""]) {
            if ([RenewalLogObject.enrollmentmode isEqualToString:@"Month"]) {
                if ([RenewalLogObject.standardnoofclassormonth intValue]>1) {
                    cell.label6.text=[NSString stringWithFormat:@"%@ (%@%@%@)",cell.label6.text,RenewalLogObject.standardnoofclassormonth,[globalvariables.language isEqualToString:@"English"]?@" ":@"",[MyClass returntitlewithtitle:@"Months"]];
                }else{
                    cell.label6.text=[NSString stringWithFormat:@"%@ (%@%@%@)",cell.label6.text,RenewalLogObject.standardnoofclassormonth,[globalvariables.language isEqualToString:@"English"]?@" ":@"",[MyClass returntitlewithtitle:@"Month"]];
                }
            }else if ([RenewalLogObject.enrollmentmode isEqualToString:@"Class"]){
                if ([RenewalLogObject.standardnoofclassormonth intValue]>1) {
                    cell.label6.text=[NSString stringWithFormat:@"%@ (%@%@%@)",cell.label6.text,RenewalLogObject.standardnoofclassormonth,[globalvariables.language isEqualToString:@"English"]?@" ":@"",[MyClass returntitlewithtitle:@"Classes"]];
                }else{
                    cell.label6.text=[NSString stringWithFormat:@"%@ (%@%@%@)",cell.label6.text,RenewalLogObject.standardnoofclassormonth,[globalvariables.language isEqualToString:@"English"]?@" ":@"",[MyClass returntitlewithtitle:@"Class"]];
                }
            }
        }
        if ([RenewalLogObject.lastclass isEqualToString:@"TBD"]){
            cell.label5.text=[MyClass returntitlewithtitle:RenewalLogObject.lastclass];
        }else if ([RenewalLogObject.lastclass length]==17) {
            cell.label5.text=[MyClass convertDateFormatWithDate:RenewalLogObject.lastclass FromDateFormat:@"dd-MMM-yyyy HH:mm" ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES];
        }else{
            cell.label5.text=[MyClass convertDateFormatWithDate:RenewalLogObject.lastclass FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
        }
        
        //NSString *renewalstatus=[self returnRenewalStatusWithnewenrollmentkey:RenewalLogObject.newenrollmentkey lateststartdate:RenewalLogObject.lateststartdate];
        if ([renewalstatus isEqualToString:@"Failed"]) {
            [cell.imageview2 setImage:[UIImage imageNamed:@"failed_icon.png"]];
        }else{
            [cell.imageview2 setImage:[UIImage imageNamed:@"passed_icon.png"]];
        }
        
        if (indexPath.row %2!=0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        return cell;
    
    }/*else if (tableView == RenewalLogTable) {
        RenewalLogObject = [((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:indexPath.section]).renewallogarray objectAtIndex:indexPath.row];
        
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            //add textfield
            StudentNameLabel_Log = [[UILabel alloc]initWithFrame:CGRectMake(98, 6, 140, 33)];
            StudentNameLabel_Log.font=[UIFont systemFontOfSize:13];
            StudentNameLabel_Log.textColor=[UIColor darkGrayColor];
            StudentNameLabel_Log.tag=201;
            StudentNameLabel_Log.adjustsFontSizeToFitWidth=YES;
            StudentNameLabel_Log.minimumScaleFactor=0.7;
            StudentNameLabel_Log.numberOfLines=0;
            [cell.contentView addSubview:StudentNameLabel_Log];
            
            SubjectLabel_Log = [[UILabel alloc]initWithFrame:CGRectMake(253, 3, 230, 21)];
            SubjectLabel_Log.font=[UIFont systemFontOfSize:13];
            SubjectLabel_Log.textColor=[UIColor darkGrayColor];
            SubjectLabel_Log.tag=202;
            [cell.contentView addSubview:SubjectLabel_Log];
            
            ScheduleNameLabel_Log = [[UILabel alloc]initWithFrame:CGRectMake(253, 21, 230, 21)];
            ScheduleNameLabel_Log.font=[UIFont systemFontOfSize:11];
            ScheduleNameLabel_Log.textColor=[UIColor darkGrayColor];
            ScheduleNameLabel_Log.tag=203;
            [cell.contentView addSubview:ScheduleNameLabel_Log];
            
            RenewalResultLabel_Log = [[UILabel alloc]initWithFrame:CGRectMake(500, 3, 280, 45)];
            RenewalResultLabel_Log.font=[UIFont systemFontOfSize:13];
            RenewalResultLabel_Log.textColor=[UIColor darkGrayColor];
            RenewalResultLabel_Log.tag=205;
            RenewalResultLabel_Log.numberOfLines=0;
            [cell.contentView addSubview:RenewalResultLabel_Log];
            
            LastDateLabel_Log = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-236, 3, 164, 21)];
            LastDateLabel_Log.font=[UIFont systemFontOfSize:13];
            LastDateLabel_Log.textColor=[UIColor darkGrayColor];
            LastDateLabel_Log.tag=208;
            [cell.contentView addSubview:LastDateLabel_Log];
            
            FirstDayLabel_Log = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width-236, 21, 200, 21)];
            FirstDayLabel_Log.font=[UIFont systemFontOfSize:13];
            FirstDayLabel_Log.textColor=[UIColor darkGrayColor];
            FirstDayLabel_Log.tag=209;
            [cell.contentView addSubview:FirstDayLabel_Log];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
            singleTap.numberOfTapsRequired = 1;
            
            StudentImage_Log=[[UIImageView alloc]initWithFrame:CGRectMake(55, 1, 43*154/180, 43)];
            StudentImage_Log.layer.cornerRadius=3;
            StudentImage_Log.tag=210;
            StudentImage_Log.layer.masksToBounds=YES;
            StudentImage_Log.userInteractionEnabled = YES;
            [StudentImage_Log addGestureRecognizer:singleTap];
            [cell.contentView addSubview:StudentImage_Log];

            RenewalStatusImage_Log=[[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-44, 10, 25, 25)];
            RenewalStatusImage_Log.tag=211;
            [cell.contentView addSubview:RenewalStatusImage_Log];
            
            LeftBlock=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 55, 45)];
            LeftBlock.backgroundColor=[UIColor systemGroupedBackgroundColor];
            LeftBlock.tag=212;
            [cell.contentView addSubview:LeftBlock];
        }else{
            StudentNameLabel_Log=(UILabel *)[cell.contentView viewWithTag:201];
            SubjectLabel_Log=(UILabel *)[cell.contentView viewWithTag:202];
            ScheduleNameLabel_Log=(UILabel *)[cell.contentView viewWithTag:203];
            //RenewalTimeLabel_Log=(UILabel *)[cell.contentView viewWithTag:204];
            RenewalResultLabel_Log=(UILabel *)[cell.contentView viewWithTag:205];
            //UsernameLabel_Log=(UILabel *)[cell.contentView viewWithTag:207];
            LastDateLabel_Log=(UILabel *)[cell.contentView viewWithTag:208];
            FirstDayLabel_Log=(UILabel *)[cell.contentView viewWithTag:209];
            StudentImage_Log=(UIImageView *)[cell.contentView viewWithTag:210];
            RenewalStatusImage_Log=(UIImageView *)[cell.contentView viewWithTag:211];
            LeftBlock=(UIView *)[cell.contentView viewWithTag:212];
        }
        
        // Configure the cell...
    
        if ([((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:indexPath.section]).timeconnectionid isEqualToString:highlightedconectionid]) {
            NSString *filtervalue=((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:indexPath.section]).filtervalue;
            if (![filtervalue isEqualToString:@"Both"] && ![filtervalue isEqualToString:RenewalLogObject.status]) {
                cell.hidden=YES;
            }else{
                cell.hidden=NO;
                LeftBlock.frame=CGRectMake(0, 0, 55, [RenewalLogTable rectForRowAtIndexPath:indexPath].size.height);
                LeftBlock.hidden=NO;
                cell.separatorInset=UIEdgeInsetsMake(0, 55, 0, 0);
                
                StudentNameLabel_Log.text=[MyClass returnStudentnameWithStudentkey:RenewalLogObject.studentkey option:@"full"];//[self returnstudentnamewithfirstname:RenewalLogObject.firstname lastname:RenewalLogObject.lastname];
                [StudentNameLabel_Log sizeToFit];
                CGRect myFrame=StudentNameLabel_Log.frame;
                if (myFrame.size.height>33) {
                    StudentNameLabel_Log.frame=CGRectMake(98, 6, 140, 33);
                }else{
                    StudentNameLabel_Log.frame=CGRectMake(98, 6, 140, myFrame.size.height);
                }
                
                ScheduleNameLabel_Log.text=[MyClass returnschedulenamewithsubject_shortname:RenewalLogObject.subject schedulekey:RenewalLogObject.schedulekey centerkey:globalvariables.centerrecord.centerkey];
                
                if ([globalvariables.language isEqualToString:@"English"]) {
                    SubjectLabel_Log.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:RenewalLogObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_englishname;
                    RenewalResultLabel_Log.text=RenewalLogObject.renewalresultenglish;
                }else{
                    SubjectLabel_Log.text=((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:RenewalLogObject.subject centerkey:globalvariables.centerrecord.centerkey]).subject_chinesename;
                    RenewalResultLabel_Log.text=RenewalLogObject.renewalresultchinese;
                }
                
                NSString *renewalstatus=[self returnRenewalStatusWithnewenrollmentkey:RenewalLogObject.newenrollmentkey lateststartdate:RenewalLogObject.lateststartdate];
                if (![renewalstatus isEqualToString:@"Successful"] && ![renewalstatus isEqualToString:@"Failed"]) {
                    RenewalResultLabel_Log.text=[NSString stringWithFormat:@"(%@) %@",[MyClass returntitlewithtitle:renewalstatus],RenewalResultLabel_Log.text];
                }
                
                [RenewalResultLabel_Log sizeToFit];
                //CGRect myframe=RenewalResultLabel_Log.frame;
                RenewalResultLabel_Log.frame=CGRectMake(500, 0, self.view.frame.size.width-744, [tableView rectForRowAtIndexPath:indexPath].size.height);
                
                //RenewalTimeLabel_Log.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:RenewalLogObject.timeconnectionid];
                //UsernameLabel_Log.text=[MyClass returnstaffnamewithusername:RenewalLogObject.username firstorfullname:@"full"];
                
                if ([RenewalLogObject.lastclass isEqualToString:@"TBF"] || [RenewalLogObject.lastclass isEqualToString:@"TBD"]) {
                    LastDateLabel_Log.text=[MyClass returntitlewithtitle:RenewalLogObject.lastclass];
                }else{
                    LastDateLabel_Log.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:RenewalLogObject.lastclass];
                }
                
                FirstDayLabel_Log.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:RenewalLogObject.firstclass];
                
                if (![RenewalLogObject.newenrollmentkey isEqualToString:@""]) {
                    if ([RenewalLogObject.enrollmentmode isEqualToString:@"Month"]) {
                        if ([RenewalLogObject.standardnoofclassormonth intValue]>1) {
                            FirstDayLabel_Log.text=[NSString stringWithFormat:@"%@ (%@%@%@)",FirstDayLabel_Log.text,RenewalLogObject.standardnoofclassormonth,[globalvariables.language isEqualToString:@"English"]?@" ":@"",[MyClass returntitlewithtitle:@"Months"]];
                        }else{
                            FirstDayLabel_Log.text=[NSString stringWithFormat:@"%@ (%@%@%@)",FirstDayLabel_Log.text,RenewalLogObject.standardnoofclassormonth,[globalvariables.language isEqualToString:@"English"]?@" ":@"",[MyClass returntitlewithtitle:@"Month"]];
                        }
                    }else if ([RenewalLogObject.enrollmentmode isEqualToString:@"Class"]){
                        if ([RenewalLogObject.standardnoofclassormonth intValue]>1) {
                            FirstDayLabel_Log.text=[NSString stringWithFormat:@"%@ (%@%@%@)",FirstDayLabel_Log.text,RenewalLogObject.standardnoofclassormonth,[globalvariables.language isEqualToString:@"English"]?@" ":@"",[MyClass returntitlewithtitle:@"Classes"]];
                        }else{
                            FirstDayLabel_Log.text=[NSString stringWithFormat:@"%@ (%@%@%@)",FirstDayLabel_Log.text,RenewalLogObject.standardnoofclassormonth,[globalvariables.language isEqualToString:@"English"]?@" ":@"",[MyClass returntitlewithtitle:@"Class"]];
                        }
                    }
                }
                
                //NSString *renewalstatus=[self returnRenewalStatusWithnewenrollmentkey:RenewalLogObject.newenrollmentkey latestenrollmentkey:RenewalLogObject.latestenrollmentkey];
                
                if ([renewalstatus isEqualToString:@"Failed"]) {
                    [RenewalStatusImage_Log setImage:[UIImage imageNamed:@"failed_icon.png"]];
                }else{//} if ([renewalstatus isEqualToString:@"Successful"]) {
                    [RenewalStatusImage_Log setImage:[UIImage imageNamed:@"passed_icon.png"]];
                }
                

                
                [MyClass downloadImageWithImageview:StudentImage_Log gender:RenewalLogObject.gender type:@"student" typekey:RenewalLogObject.studentkey image:RenewalLogObject.image async:YES];
                
            }
        }else{
            cell.hidden=YES;
            LeftBlock.hidden=YES;
            cell.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }*/
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView== RenewalRecordTable) {
        RenewalRecordObject=[RenewalRecordArrayFilterResult objectAtIndex:indexPath.row];
        
        if (batchrenewalviewopened) {

            long index=[self includerenewalrecordwithBatchRenewalEnrollmentArray:BatchRenewalEnrollmentkeyArray Enrollmentkey:RenewalRecordObject.enrollmentkey];
            
            if (index>=0) {
                [BatchRenewalEnrollmentkeyArray removeObjectAtIndex:index];
            }else{
                [BatchRenewalEnrollmentkeyArray addObject:RenewalRecordObject];
            }

            [RenewalRecordTable reloadData];
        }else{
            DetailsViewStudent=[MyClass retrieveStudent:RenewalRecordObject.studentkey];
            if (!DetailsViewStudent) {
                return;
            }
            if (![self retrieveEnrollmentWithStudentkey:RenewalRecordObject.studentkey Enrollmentkey:RenewalRecordObject.enrollmentkey]) {
                return;
            }
            
            
            [self startsidewindowanimationwithwidth:320];
            //[self adjustpresentingviewwidthwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                DetailsViewEnrollment=[DetailsViewEnrollmentArray objectAtIndex:0];
                
                EnrollmentPopoverViewController *enrollmentpopover = (EnrollmentPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"EnrollmentPopoverViewController"];
                enrollmentpopover.delegate=self;
                enrollmentpopover.PopoverEnrollment=DetailsViewEnrollment;
                enrollmentpopover.PopoverStudent=DetailsViewStudent;
                enrollmentpopover.EnrollmentTableMode=@"RenewalDrop";
                
                enrollmentpopover.view.frame=self->sidewindowview.bounds;
                [self->sidewindowview addSubview:enrollmentpopover.view];
                [self addChildViewController:enrollmentpopover];
                [enrollmentpopover didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });
            
        }
        
        
            


        
        

    }else if (tableView==LogDetailsTable) {
        

            RenewalLogObject = [((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:groupLogSelected]).renewallogarray objectAtIndex:indexPath.row];
            
            DetailsViewStudent=[MyClass retrieveStudent:RenewalLogObject.studentkey];
            if (!DetailsViewStudent) {
                return;
            }
            
            if ([RenewalLogObject.newenrollmentkey isEqualToString:@""]) {
                if (![self retrieveEnrollmentWithStudentkey:RenewalLogObject.studentkey Enrollmentkey:RenewalLogObject.oldenrollmentkey]) {
                    return;
                }
            }else{
                if (![self retrieveEnrollmentWithStudentkey:RenewalLogObject.studentkey Enrollmentkey:RenewalLogObject.newenrollmentkey]) {
                    return;
                }
            }
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            
        //});
            
            
            //popup enrollment view record
            if (DetailsViewEnrollmentArray.count==0) {
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Batch Renewal"] message:[MyClass returntitlewithtitle:@"The enrollment record no longer exists"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                                [erroralert addAction:OKAction];
                //[self presentViewController:erroralert animated:YES completion:nil];
                [MyClass presentViewController:erroralert View:self];
            }else{
                
                
                [self startsidewindowanimationwithwidth:320];
                //[self adjustpresentingviewwidthwithwidth:320];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    DetailsViewEnrollment=[DetailsViewEnrollmentArray objectAtIndex:0];

                    EnrollmentPopoverViewController *enrollmentpopover = (EnrollmentPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"EnrollmentPopoverViewController"];
                    enrollmentpopover.delegate=self;
                    enrollmentpopover.PopoverEnrollment=DetailsViewEnrollment;
                    enrollmentpopover.PopoverStudent=DetailsViewStudent;
                    enrollmentpopover.EnrollmentTableMode=@"RenewalDrop";
                    
                    enrollmentpopover.view.frame=self->sidewindowview.bounds;
                    [self->sidewindowview addSubview:enrollmentpopover.view];
                    [self addChildViewController:enrollmentpopover];
                    [enrollmentpopover didMoveToParentViewController:self];
                    [self->ailoadindicator stopAnimating];
                    ailoadindicator.hidden=YES;
                });
                

            }

    }else if (tableView==LogTable){
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        groupLogSelected=indexPath.row;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveRenewalLogDetailswithconnectionid:((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:indexPath.row]).timeconnectionid];
            [LogDetailsTable reloadData];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
        
    }
}


-(BOOL) refreshtabledelay
{
    if (gotoautorenewal) {
        [self changerenewalmode:BatchRenewalButton];
        gotoautorenewal=FALSE;
    }else{
        if (!renewalrecordtablelistview.hidden) {
            return [self retrieveRenewalRecordWithSelectedDate:cutoffdatebutton.tag remainingclass:RemainingClassThresholdButton.tag classday:@"All"];
        }else{
            return [self retrieveRenewalLogList];
        }
    }
    return YES;

}




-(BOOL) retrieveEnrollmentWithStudentkey:(NSString *)studentkey Enrollmentkey:(NSString *)enrollmentkey
{
    
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectenrollment&studentkey=%@&enrollmentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,studentkey,enrollmentkey];

    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result = TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our enrollment array
            DetailsViewEnrollmentArray=[[NSMutableArray alloc] init];
            
            if (JSONArray.count>0) {
                if ([[JSONArray objectAtIndex:0] objectForKey:@"studentkey"] != [NSNull null]) {
                    //loop through our jsonArray
                    for (int i=0; i<JSONArray.count; i++) {
                        
                        //Create our ClassRecord object
                        NSString *cstartdate;
                        NSString *cenddate;
                        NSString * cstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                        NSString * cenrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
                        NSString * cinvoicenumber=[[JSONArray objectAtIndex:i] objectForKey:@"invoicenumber"];
                        NSString * cinvoiceprefix=[[JSONArray objectAtIndex:i] objectForKey:@"invoiceprefix"];
                        NSString * cschedulekey=[[JSONArray objectAtIndex:i] objectForKey:@"schedulekey"];
                        NSString * cautorenew=[[JSONArray objectAtIndex:i] objectForKey:@"autorenew"];
                        NSString * csubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                        NSString * clevelmain=[[JSONArray objectAtIndex:i] objectForKey:@"levelmain"];
                        NSString * clevelctm=[[JSONArray objectAtIndex:i] objectForKey:@"levelctm"];
                        NSString * cgrade=[[JSONArray objectAtIndex:i] objectForKey:@"grade"];
                        

                        NSString *cenrollmentdate = [MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                        
                        if (![[[JSONArray objectAtIndex:i] objectForKey:@"startdate"] isEqualToString:@""]) {
                            if ([[[JSONArray objectAtIndex:i] objectForKey:@"startdate"] isEqualToString:@"TBD"]) {
                                cstartdate=[[JSONArray objectAtIndex:i] objectForKey:@"startdate"];
                            }else{
                                cstartdate = [MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"startdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                            }
                        }else{
                            cstartdate=@"";
                        }
                        
                        if (![[[JSONArray objectAtIndex:i] objectForKey:@"enddate"] isEqualToString:@""]) {
                            if ([[[JSONArray objectAtIndex:i] objectForKey:@"enddate"] isEqualToString:@"TBD"] || [[[JSONArray objectAtIndex:i] objectForKey:@"enddate"] isEqualToString:@"TBF"]) {
                                cenddate=[[JSONArray objectAtIndex:i] objectForKey:@"enddate"];
                            }else{
                                cenddate = [MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"enddate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                            }
                        }else{
                            cenddate=@"";
                        }
                        
                        NSString * cnoofclass=[[JSONArray objectAtIndex:i] objectForKey:@"noofclass"];
                        NSString * cclassday=[[JSONArray objectAtIndex:i] objectForKey:@"classday"];
                        NSString * cclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                        NSString * cinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
                        NSString * csinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"sinstructor"];
                        NSString * cenrollmentfee=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentfee"];
                        NSString * ctuitionfee=[[JSONArray objectAtIndex:i] objectForKey:@"tuitionfee"];
                        NSString * coneoffdiscount=[[JSONArray objectAtIndex:i] objectForKey:@"oneoffdiscount"];
                        NSString * crecursivediscount=[[JSONArray objectAtIndex:i] objectForKey:@"recursivediscount"];
                        NSString * coneoffpercentagediscount=[[JSONArray objectAtIndex:i] objectForKey:@"oneoffpercentagediscount"];
                        NSString * clatefee=[[JSONArray objectAtIndex:i] objectForKey:@"latefee"];
                        NSString * ctotalfee=[[JSONArray objectAtIndex:i] objectForKey:@"totalfee"];
                        NSString * cpaid=[[JSONArray objectAtIndex:i] objectForKey:@"paid"];
                        NSString * cdropclassstatus=[[JSONArray objectAtIndex:i] objectForKey:@"dropclassstatus"];
                        //NSString * clastpaymentkey=[[JSONArray objectAtIndex:i] objectForKey:@"lastpaymentkey"];
                        NSString * cdropclassdate;
                        
                        if (![[[JSONArray objectAtIndex:i] objectForKey:@"dropclassdate"] isEqualToString:@""]) {
                            if ([[[JSONArray objectAtIndex:i] objectForKey:@"dropclassdate"] isEqualToString:@"TBD"] || [[[JSONArray objectAtIndex:i] objectForKey:@"dropclassdate"] isEqualToString:@"TBF"]) {
                                cdropclassdate=[[JSONArray objectAtIndex:i] objectForKey:@"dropclassdate"];
                            }else{
                                cdropclassdate = [MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"dropclassdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                            }
                        }else{
                            cdropclassdate=@"";
                        }
                        NSString * cvalidity=[[JSONArray objectAtIndex:i] objectForKey:@"validity"];
                        
                        NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                        NSString * cdraft=[[JSONArray objectAtIndex:i] objectForKey:@"draft"];
                        NSString * cinvoiceremarks=[[JSONArray objectAtIndex:i] objectForKey:@"invoiceremarks"];
                        NSString * cclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
                        NSString * cstatus=[[JSONArray objectAtIndex:i] objectForKey:@"status"];
                        NSString * creverseadjustment=[[JSONArray objectAtIndex:i] objectForKey:@"reverseadjustment"];
                        NSString * cinstructorfullname=[MyClass returninstructornamewithusername:cinstructor firstorfullname:@"full"];
                        NSString * csubjectfullname=[MyClass returnsubjectnamewithsubject_shortname:csubject centerkey:globalvariables.centerrecord.centerkey];
                        NSString * cmakeup_quota=[[JSONArray objectAtIndex:i] objectForKey:@"makeup_quota"];
                        NSString * cmakeup_quota_used=[[JSONArray objectAtIndex:i] objectForKey:@"makeup_quota_used"];
                        
                        NSString * cenrollmentmode=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentmode"];
                        NSString * cstandardnoofclassormonth=[[JSONArray objectAtIndex:i] objectForKey:@"standardnoofclassormonth"];
                        BOOL clocked=[[[JSONArray objectAtIndex:i] objectForKey:@"locked"] isEqualToString:@"Yes"];
                        NSString *cbilldate=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"billdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                        NSString *cresumeclassdate=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"resumeclassdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                        NSString * coutstandingmakeupclasses=[[JSONArray objectAtIndex:i] objectForKey:@"outstandingmakeupclasses"];
                        
                        //NSArray *cpaymentkeys=[[NSArray alloc]initWithArray:[[[JSONArray objectAtIndex:i] objectForKey:@"paymentkeys"] componentsSeparatedByString:@","]];
                        NSMutableArray *cpaymentrecords=[[NSMutableArray alloc]init];
                        NSArray *paymentrecords=[[JSONArray objectAtIndex:i] objectForKey:@"paymentrecords"];
                        for (int i=0; i<paymentrecords.count; i++) {
                            NSString * spaymentkey=[[paymentrecords objectAtIndex:i] objectForKey:@"paymentkey"];
                            NSString * spaymentype=[[paymentrecords objectAtIndex:i] objectForKey:@"paymenttype"];
                            NSString * spaymenttypekey=[[paymentrecords objectAtIndex:i] objectForKey:@"paymenttypekey"];
                            NSString * spaiddate=[MyClass convertDateFormatWithDate:[[paymentrecords objectAtIndex:i] objectForKey:@"paiddate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                            NSString * spaidmethod=[[paymentrecords objectAtIndex:i] objectForKey:@"paidmethod"];
                            NSString * spaidamount=[[paymentrecords objectAtIndex:i] objectForKey:@"paidamount"];
                            NSString * spaymentremarks=[[paymentrecords objectAtIndex:i] objectForKey:@"paymentremarks"];
                            NSString * sreceiptremarks=[[paymentrecords objectAtIndex:i] objectForKey:@"receiptremarks"];
                            NSString * sstaffname=[[paymentrecords objectAtIndex:i] objectForKey:@"staffname"];
                            NSString * sreceiptnumber=[[paymentrecords objectAtIndex:i] objectForKey:@"receiptnumber"];
                            NSString * sreceiptprefix=[[paymentrecords objectAtIndex:i] objectForKey:@"receiptprefix"];
                            
                            [cpaymentrecords addObject:[[PaymentRecord alloc]initPaymentRecordwithPaymentkey:spaymentkey paymenttype:spaymentype paymenttypekey:spaymenttypekey paiddate:spaiddate paidmethod:spaidmethod paidamount:spaidamount action:@"locked" paymentremarks:spaymentremarks receiptremarks:sreceiptremarks staffname:sstaffname receiptnumber:sreceiptnumber receiptprefix:sreceiptprefix]];
                        }
                        
                        NSMutableArray *cpromotiondiscountrecords=[[NSMutableArray alloc]init];
                        NSArray *promotiondiscountrecords=[[JSONArray objectAtIndex:i] objectForKey:@"promotiondiscountrecords"];
                        for (int i=0; i<promotiondiscountrecords.count; i++) {
                            NSString * scenterkey=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"centerkey"];
                            NSString * smarketingkey=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"marketingkey"];
                            NSString * sdescription=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"description"];
                            NSString * sdescription_chinese=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"description_chinese"];
                            NSString * sstartdate=[MyClass convertDateFormatWithDate:[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"startdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                            NSString * senddate=[MyClass convertDateFormatWithDate:[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"enddate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                            NSString * sremarks=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"remarks"];
                            NSString * spromotionfixeddiscount=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"promotionfixeddiscount"];
                            NSString * spromotionpercentagediscount=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"promotionpercentagediscount"];
                            NSString * susedcount=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"usedcount"];
                            NSString * spromotionquota=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"promotionquota"];
                            NSString * scode=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"code"];
                            NSString * srecursive=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"recursive"];
                            BOOL sperclassorquantity=[[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"perclassorquantity"] isEqualToString:@"Yes"];
                            BOOL smanualapply=[[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"manualapply"] isEqualToString:@"Yes"];
                            
                            [cpromotiondiscountrecords addObject:[[MarketingRecord alloc]initMarketingRecordWithcenterkey:scenterkey marketingkey:smarketingkey category:@"promotion" description:sdescription description_chinese:sdescription_chinese startdate:sstartdate enddate:senddate remarks:sremarks promotionfixeddiscount:spromotionfixeddiscount promotionpercentagediscount:spromotionpercentagediscount usedcount:susedcount promotionquota:spromotionquota code:scode recursive:srecursive effectivefrom:nil effectiveto:nil subcategory:nil redeemable:NO redeempoint:nil perstudentquota:nil cannotuseconjunctionwithothercoupons:NO subjectarray:nil productarray:nil couponallowcredit:nil perclassorquantity:sperclassorquantity earlybirdlastdate:nil buymorepayless:NO estartdate:nil eenddate:nil enablebuymorepayless:NO minnoofclass:0 bmsmacrossothersubjects:NO bmsmminsubjectno:0 bmsmminnoofclasspersubject:0 bmsmsamebillmonth:NO manualapply:smanualapply]];
                        }
                        
                        //Add the student object to our student array
                        [DetailsViewEnrollmentArray addObject:[[EnrollmentRecord alloc]initEnrollmentWithstudentkey:cstudentkey andenrollmentkey:cenrollmentkey andenrollmentdate:cenrollmentdate andschedulekey:cschedulekey andsubject:csubject andlevelmain:clevelmain andlevelctm:clevelctm andgrade:cgrade andstartdate:cstartdate andnoofclass:cnoofclass andenddate:cenddate andclassday:cclassday andclasstime:cclasstime andinstructor:cinstructor andenrollmentfee:cenrollmentfee andtuitionfee:ctuitionfee andoneoffdiscount:coneoffdiscount andrecursivediscount:crecursivediscount andoneoffpercentagediscount:coneoffpercentagediscount andlatefee:clatefee andtotalfee:ctotalfee andpaid:cpaid anddropclassstatus:cdropclassstatus  anddropclassdate:cdropclassdate andremarks:cremarks anddraft:cdraft andinvoiceremarks:cinvoiceremarks andclassroom:cclassroom andautorenew:cautorenew andstatus:cstatus andreverseadjustment:creverseadjustment instructorfullname:cinstructorfullname subjectfullname:csubjectfullname validity:cvalidity makeup_quota:cmakeup_quota makeup_quota_used:cmakeup_quota_used paymentrecords:cpaymentrecords promotiondiscountrecords:cpromotiondiscountrecords classrecords:nil sinstructor:csinstructor transferredfromenrollmentkey:@"" enrollmentmode:cenrollmentmode standardnoofclassormonth:cstandardnoofclassormonth couponrecords:nil invoicenumber:cinvoicenumber invoiceprefix:cinvoiceprefix locked:clocked billdate:cbilldate resumeclassdate:cresumeclassdate outstandingmakeupclasses:coutstandingmakeupclasses]];
                    }
                }
            }
        }
    }];

    return result;
}

-(void) dismissEnrollmentPopoverandResetFilter:(BOOL)resetfilter
{
    [self closesidewindow];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!renewalrecordtablelistview.hidden) {
            [self retrieveRenewalRecordWithSelectedDate:cutoffdatebutton.tag remainingclass:RemainingClassThresholdButton.tag classday:@"All"];
        }else{
            [self retrieveRenewalLogList];
        }
    });
    

    
    
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

-(NSString *) findclassdaywithstartdate:(NSString *)startdate
{
    if ([startdate isEqualToString:@""]){
        return @"";
    }else if ([startdate isEqualToString:@"TBD"]) {
        return @"TBD";
    }else{
        NSDate *date=[MyClass convertToNSDateWithDate:startdate DateFormat:@"dd-MMM-yyyy"];
        return [MyClass convertToNSStringWithNSDate:date DateFormat:@"EEE"];
    }
}
    

- (IBAction)menubuttonpressed:(id)sender {
    [self.mainSlideMenu openLeftMenu];
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

-(EnrollmentRecord *) refreshstudentdetailsinformationandreturnenrollementrecord:(EnrollmentRecord *)enrollment
{
    if (!renewalrecordtablelistview.hidden) {
        [self retrieveRenewalRecordWithSelectedDate:cutoffdatebutton.tag remainingclass:RemainingClassThresholdButton.tag classday:@"All"];
    }else{
        [self retrieveRenewalLogList];
    }
    
    [self retrieveEnrollmentWithStudentkey:enrollment.studentkey Enrollmentkey:enrollment.enrollmentkey];
    
    EnrollmentRecord *obj=[DetailsViewEnrollmentArray firstObject];
    
    return obj?obj:enrollment;
}

-(void) refreshdocumentfoldercountnumber
{
    //delegate method not used
}

-(void) gotoautorenewal
{
    gotoautorenewal=YES;
}

- (void)changerenewalmode:(UIButton *)sender {
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    if (sender.tag==1) {
        if (batchrenewalviewopened) {
            batchrenewalviewopened=FALSE;
            [self openbatchrenewalview:batchrenewalviewopened];
        }
        
        ManualRenewalButton.enabled=YES;
        BatchRenewalButton.enabled=NO;
        
        [ManualRenewalButton setTitle:[MyClass returntitlewithtitle:@"Manual Renewal"] forState:UIControlStateNormal];
        [ManualRenewalButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [BatchRenewalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        [UIView animateWithDuration:0.3f animations:^{
            [menubottombar setFrame:CGRectMake(ManualRenewalButton.frame.size.width, 0, ManualRenewalButton.frame.size.width, ManualRenewalButton.frame.size.height)];
        } completion:nil];
        
        
        renewalrecordtablelistview.hidden=YES;
        renewallogtablelistview.hidden=NO;
        //RenewalGroupLogExpandRowArray=[[NSMutableArray alloc]init];
        highlightedconectionid=@"";
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveRenewalLogList];
        });
    }else{
        ManualRenewalButton.enabled=NO;
        BatchRenewalButton.enabled=YES;
        renewalrecordtablelistview.hidden=NO;
        renewallogtablelistview.hidden=YES;

        [BatchRenewalButton setTitle:[MyClass returntitlewithtitle:@"Renewal Log"] forState:UIControlStateNormal];
        [ManualRenewalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [BatchRenewalButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        [UIView animateWithDuration:0.3f animations:^{
            [menubottombar setFrame:CGRectMake(0, 0, ManualRenewalButton.frame.size.width, ManualRenewalButton.frame.size.height)];
        } completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveRenewalRecordWithSelectedDate:cutoffdatebutton.tag remainingclass:RemainingClassThresholdButton.tag classday:@"All"];
        });
    }
}

-(void)tapImageDetected:(UITapGestureRecognizer *)gr
{
    UIImageView *theTappedImageView=(UIImageView *)gr.view;
    
    if(![MyClass showMenuItemwithObject:@"Student Profile"]){
        return;
    }
    
    if (!renewallogtablelistview.hidden) {
        /*CGPoint point = [theTappedImageView.superview convertPoint:CGPointZero toView:LogDetailsTable];
        NSIndexPath *indexpath =[LogDetailsTable indexPathForRowAtPoint:point];*/
        RenewalLogObject=[((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:groupLogSelected]).renewallogarray objectAtIndex:theTappedImageView.tag];
        [LogDetailsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:theTappedImageView.tag inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        
        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:RenewalLogObject.studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];
            
            if ([RenewalLogObject.newenrollmentkey isEqualToString:@""]) {
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=RenewalLogObject.oldenrollmentkey;
            }else{
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=RenewalLogObject.newenrollmentkey;
            }
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedClasskey=nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedDTkey=nil;
            
            /*
            if (![(StudentDetailsViewController *)[studentdetailsnavcontroller topViewController] retrieveStudent:RenewalLogObject.studentkey]) {
                return;
            }*/
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(self.view.frame.size.width-240, self.view.frame.size.height);
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).TypeSelectionButton.hidden=NO;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).typeselectionarrow.hidden=NO;
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501, 2, 129, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.hidden=NO;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.hidden=YES;
            [((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]) drawpointerwithoption:@"closed" imageview:((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).dayselectionarrow];

            
            studentdetailsnavcontroller.view.frame=CGRectMake(0, 0, self.view.frame.size.width-240, self.view.frame.size.height);
            [self->sidewindowview addSubview:studentdetailsnavcontroller.view];
            [self addChildViewController:studentdetailsnavcontroller];
            [studentdetailsnavcontroller didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
        });
        

    }else{
        CGPoint point = [theTappedImageView.superview convertPoint:CGPointZero toView:RenewalRecordTable];
        NSIndexPath *indexpath =[RenewalRecordTable indexPathForRowAtPoint:point];
        
        
        RenewalRecordObject=[RenewalRecordArrayFilterResult objectAtIndex:indexpath.row];
        [RenewalRecordTable selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
            //studentpopover.delegate=self;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:RenewalRecordObject.studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil  leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];

            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=RenewalRecordObject.enrollmentkey;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedClasskey=nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedDTkey=nil;
            
            /*
            if (![(StudentDetailsViewController *)[studentdetailsnavcontroller topViewController] retrieveStudent:RenewalRecordObject.studentkey]) {
                return;
            }*/
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(self.view.frame.size.width-240, self.view.frame.size.height);
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).TypeSelectionButton.hidden=NO;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).typeselectionarrow.hidden=NO;
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501, 2, 129, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.hidden=NO;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.hidden=YES;
            [((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]) drawpointerwithoption:@"closed" imageview:((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).dayselectionarrow];
            
            
            studentdetailsnavcontroller.view.frame=CGRectMake(0, 0, self.view.frame.size.width-240, self.view.frame.size.height);
            [self->sidewindowview addSubview:studentdetailsnavcontroller.view];
            [self addChildViewController:studentdetailsnavcontroller];
            [studentdetailsnavcontroller didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
        });
        

    }
    


}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverController {
    if (popoverController==myPopoverController) {
        [LogDetailsTable deselectRowAtIndexPath:[LogDetailsTable indexPathForSelectedRow] animated: YES];
        //[RenewalLogTable deselectRowAtIndexPath:[RenewalLogTable indexPathForSelectedRow] animated:YES];
    }
}

-(void) submitbatchrenewalpressed
{
    
    UIAlertController *completedalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Batch Renewal"] message:[MyClass returntitlewithtitle:@"Are you sure to proceed with the batch renewal?"] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self submitbatchrenewal];
        });
        
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [completedalert addAction:OKAction];
    [completedalert addAction:CancelAction];
    
    [self presentViewController:completedalert animated:YES completion:nil];
    
}



-(BOOL) submitbatchrenewal
{
    //generate json subject array
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
//    NSArray *jsonbatchrenewalinfoarray=[[NSArray alloc]init];
    NSArray *jsonbatchrenewalrecordarray=[[NSArray alloc]init];

//    keys=[NSArray arrayWithObjects:@"entitykey",@"centerdb",@"centerkey",@"cutoffdate",@"username",nil];
    
//    values=[NSArray arrayWithObjects:globalvariables.centerrecord.entitykey,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,[MyClass convertDateFormatWithDate:[@(cutoffdatebutton.tag) stringValue] FromDateFormat:@"yyyyMMdd" ToDateFormat:@"yyyy-MM-dd"],globalvariables.username, nil];
    
//    dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
//    [arrayOfDicts addObject:dict];
//    jsonbatchrenewalinfoarray = [NSArray arrayWithArray:arrayOfDicts];
    
    //generate json tuition array
    if (BatchRenewalEnrollmentkeyArray.count>0) {
        arrayOfDicts = [[NSMutableArray alloc] init];
        keys=[NSArray arrayWithObjects:@"enrollmentkey",@"subject",@"studentkey",nil];
        
        for (int i = 0; i<BatchRenewalEnrollmentkeyArray.count; i++) {
            
            values=[NSArray arrayWithObjects:((RenewalRecord *)[BatchRenewalEnrollmentkeyArray objectAtIndex:i]).enrollmentkey,((RenewalRecord *)[BatchRenewalEnrollmentkeyArray objectAtIndex:i]).subject,((RenewalRecord *)[BatchRenewalEnrollmentkeyArray objectAtIndex:i]).studentkey,nil];
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
        jsonbatchrenewalrecordarray = [NSArray arrayWithArray:arrayOfDicts];
    }
    
    
    //combine arrays
    NSDictionary *dictionary = @{@"batchrenewalrecordarray" : jsonbatchrenewalrecordarray,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"postaction" : @"submitbatchrenewal2",
                                 @"coursetype" : sccoursetype.selectedSegmentIndex==0?@"Class":@"Month"
                                 };
    
    __block BOOL result=FALSE;
    __block NSString *timeconnectionid;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray=jsonreturned[@"content"];
            timeconnectionid=[[JSONArray objectAtIndex:0] objectForKey:@"timeconnectionid"];
        }
    }];
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:180.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    __block BOOL result=FALSE;
    __block NSString *timeconnectionid;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!error) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray=jsonreturned[@"content"];
            timeconnectionid=[[JSONArray objectAtIndex:0] objectForKey:@"timeconnectionid"];
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    
    if (result) {
        UIAlertController *completedalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Batch Renewal"] message:[MyClass returntitlewithtitle:@"Batch renewal process has been completed"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *YesAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            highlightedconectionid=timeconnectionid;
            [self changerenewalmode:BatchRenewalButton];
        }];

        [completedalert addAction:YesAction];
        
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        [self presentViewController:completedalert animated:YES completion:nil];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    
    return result;
}

-(void) selectallclass
{
    BatchRenewalEnrollmentkeyArray=[[NSMutableArray alloc]initWithArray:RenewalRecordArrayFilterResult];
    [RenewalRecordTable reloadData];
    [submitbatchrenewalbutton setTitle:[NSString stringWithFormat:@"%@ (%lu)",[MyClass returntitlewithtitle:@"Submit Batch"],(unsigned long)BatchRenewalEnrollmentkeyArray.count] forState:UIControlStateNormal];
    if (BatchRenewalEnrollmentkeyArray.count==0) {
        submitbatchrenewalbutton.enabled=NO;
    }else{
        submitbatchrenewalbutton.enabled=YES;
    }
}

-(void) deselectallclass
{
    BatchRenewalEnrollmentkeyArray=[[NSMutableArray alloc]init];
    [RenewalRecordTable reloadData];
    
    [submitbatchrenewalbutton setTitle:[NSString stringWithFormat:@"%@ (%lu)",[MyClass returntitlewithtitle:@"Submit Batch"],(unsigned long)BatchRenewalEnrollmentkeyArray.count] forState:UIControlStateNormal];
    submitbatchrenewalbutton.enabled=NO;
}

-(long) includerenewalrecordwithBatchRenewalEnrollmentArray:(NSMutableArray *)batchrenewalenrollmentarray Enrollmentkey:(NSString *)enrollmentkey
{
    for (int i=0; i<batchrenewalenrollmentarray.count; i++) {
        if ([((RenewalRecord *)[batchrenewalenrollmentarray objectAtIndex:i]).enrollmentkey isEqualToString:enrollmentkey]) {
            return i;
        }
    }
    return -1;
}



-(void) remainingclassthresholdpressed:(UIButton *)sender
{

    remainingclassthresholdMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 440)];
    remainingclassthresholdMasterView.backgroundColor=[UIColor grayColor];
    remainingclassthresholdMasterView.tag=-1;
    
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.text=[MyClass returntitlewithtitle:@"Select One"];
    title.textColor=[UIColor whiteColor];
    title.font=[UIFont systemFontOfSize:12];
    title.textAlignment=NSTextAlignmentCenter;
    title.tag=-1;
    [remainingclassthresholdMasterView addSubview:title];
    
    
    for (int i=0; i<50; i++) {
        UIButton *numberbutton=[[UIButton alloc]initWithFrame:CGRectMake((i%5)*40, (i/5)*40+40, 40, 40)];
        numberbutton.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
        numberbutton.titleLabel.font=[UIFont systemFontOfSize:12];
        numberbutton.layer.borderWidth=0.5;
        numberbutton.tag=i;
        [numberbutton setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        numberbutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
        if (i==RemainingClassThresholdButton.tag) {
            numberbutton.backgroundColor=[UIColor lightGrayColor];
            [numberbutton setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
            numberbutton.titleLabel.font=[UIFont systemFontOfSize:16];
        }else{
            numberbutton.backgroundColor=[UIColor systemGroupedBackgroundColor];
            [numberbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            numberbutton.titleLabel.font=[UIFont systemFontOfSize:12];
        }
        [numberbutton addTarget:self action:@selector(remainingclassnumberbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        [remainingclassthresholdMasterView addSubview:numberbutton];
    }
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=remainingclassthresholdMasterView;
    viewcontroller.preferredContentSize=CGSizeMake(200, 440);
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myPopoverController=viewcontroller.popoverPresentationController;
    myPopoverController.delegate=self;
    myPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myPopoverController.sourceView=sender;
    myPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
}

-(void) remainingclassnumberbuttonpressed:(UIButton *)sender
{
    sender.backgroundColor=[UIColor lightGrayColor];
    [sender setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    sender.titleLabel.font=[UIFont systemFontOfSize:16];
    

    
    [[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    //[ailoadclass startAnimating];
    NSString *lastvalue=RemainingClassThresholdButton.titleLabel.text;
    
    //[RemainingClassThresholdButton setTitle:[NSString stringWithFormat:@"%ld",(long)sender.tag] forState:UIControlStateNormal];
    //remainingclassthresholdtitle.text=[NSString stringWithFormat:@"%@ %ld",[MyClass returntitlewithtitle:@"Remaining Class"],(long)sender.tag];
    [RemainingClassThresholdButton setTitle:[NSString stringWithFormat:@"%@ %ld",[MyClass returntitlewithtitle:@"Remaining Class"],(long)sender.tag] forState:UIControlStateNormal];
    RemainingClassThresholdButton.tag=sender.tag;
    
    /*
    if ([RemainingClassThresholdButton.titleLabel.text intValue]==0) {
        DecButton.enabled=NO;
    }*/
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self retrieveRenewalRecordWithSelectedDate:cutoffdatebutton.tag remainingclass:RemainingClassThresholdButton.tag classday:@"All"]) {
            
            //update to sqlite db
            NSString *sql=[NSString stringWithFormat:@"UPDATE settings SET parametervalue='%@' where parametername='%@'",RemainingClassThresholdButton.titleLabel.text,@"renewalremainingclassthreshold"];
            sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,NULL);
            
        }else{
            //[RemainingClassThresholdButton setTitle:lastvalue forState:UIControlStateNormal];
            //remainingclassthresholdtitle.text=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"Remaining Class"],lastvalue];
            [RemainingClassThresholdButton setTitle:[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"Remaining Class"],lastvalue] forState:UIControlStateNormal];
            RemainingClassThresholdButton.tag=[lastvalue integerValue];
            //DecButton.enabled=YES;
        }
    });
}

-(long) scheduleincludedinschedulearray:(NSMutableArray *)schedulearray schedulekey:(NSString *)schedulekey
{
    for (int i=0; i<schedulearray.count; i++) {
        if ([((ScheduleRecord *)[schedulearray objectAtIndex:i]).schedulekey isEqualToString:schedulekey]) {
            return i;
        }
    }
    return -1;
}

-(void) filterrenewalrecordtablewithfilteredschedulearray:(NSMutableArray *)filteredschedulearray previousfilteredschedulearray:(NSMutableArray *)previousfilteredschedulearray
{
    NSMutableArray *newschedulekeyarray=[[NSMutableArray alloc]init];
    NSMutableArray *previousschedulekeyarray=[[NSMutableArray alloc]init];
    //NSMutableArray *enrollmentkeyarray=[[NSMutableArray alloc]init];
    for (int i=0; i<filteredschedulearray.count; i++) {
        [newschedulekeyarray addObject:((ScheduleRecord *)[filteredschedulearray objectAtIndex:i]).schedulekey];
    }

    for (int i=0; i<previousfilteredschedulearray.count; i++) {
        [previousschedulekeyarray addObject:((ScheduleRecord *)[previousfilteredschedulearray objectAtIndex:i]).schedulekey];
    }
    
    RenewalRecordArrayFilterResult=[[NSMutableArray alloc]init];
    for (int i=0; i<RenewalRecordArrayAllResult.count; i++) {
        if ([newschedulekeyarray containsObject:((RenewalRecord *)[RenewalRecordArrayAllResult objectAtIndex:i]).schedulekey]) {
            [RenewalRecordArrayFilterResult addObject:[RenewalRecordArrayAllResult objectAtIndex:i]];
            //[enrollmentkeyarray addObject:((RenewalRecord *)[RenewalRecordArrayAllResult objectAtIndex:i]).enrollmentkey];
            
            //add new filtered schedulekey enrollment records
            if (![previousschedulekeyarray containsObject:((RenewalRecord *)[RenewalRecordArrayAllResult objectAtIndex:i]).schedulekey]) {
                [BatchRenewalEnrollmentkeyArray addObject:[RenewalRecordArrayAllResult objectAtIndex:i]];
            }
        }
    }
    
    //delete filtered out schedulekey enrollment records
    for (int i=0; i<previousschedulekeyarray.count; i++) {
        if (![newschedulekeyarray containsObject:[previousschedulekeyarray objectAtIndex:i]]) {
            for (int j=0; j<BatchRenewalEnrollmentkeyArray.count; j++) {
                if ([((RenewalRecord *)[BatchRenewalEnrollmentkeyArray objectAtIndex:j]).schedulekey isEqualToString:[previousschedulekeyarray objectAtIndex:i]]) {
                    [BatchRenewalEnrollmentkeyArray removeObjectAtIndex:j];
                    j-=1;
                }
            }
        }
    }
    [RenewalRecordTable reloadData];

}

-(void) enrollmentwindowloadviewcompleted
{
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
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
    if (reload) {
        globalvariables.documentfolder.classreceiptarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salesreceiptarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.classinvoicearray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salesinvoicearray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.classpaymentarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salespaymentarray=[[NSMutableArray alloc]init];
        //[RenewalGroupLogExpandRowArray removeAllObjects];
        highlightedconectionid=@"";
        [MyClass retrievemenuimagewithasync:YES];
        [self reloadPageWithFirstLoad:NO];
    }
}

-(void) reloadPageWithFirstLoad:(BOOL)firstload
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,staff,centersettings,userroleandprivilege,student,arcode" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
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
                        //[MyClass retrievemenuimagewithasync:YES];
                        //[MyClass retrievecenterimages];
                        [MyClass updatecenterkey];
                        if (sccoursetype.selectedSegmentIndex==1) {
                            sccoursetype.selectedSegmentIndex=0;
                            [self selectcoursetype:sccoursetype];
                        }
                        
                        cutoffdatebutton.tag=[[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyyMMdd"] integerValue];
                        [cutoffdatebutton setTitle:[MyClass returndateformatwithdate:[MyClass convertDateFormatWithDate:[@(cutoffdatebutton.tag) stringValue] FromDateFormat:@"yyyyMMdd" ToDateFormat:@"dd-MMM-yyyy"] dateformat:@"dd-MMM-yyyy"] forState:UIControlStateNormal];

                        LeftBlock.hidden=YES;
                        firstloadcover.hidden=YES;
                        //batchrenewalview.hidden=YES;
                        batchrenewalviewheightconstraint.constant=0;
                        [self refreshlanguage];
                        if (![self refreshtabledelay]){
                            reloadbutton.hidden=NO;
                            return;
                        }else{
                            reloadbutton.hidden=YES;
                        }
                    }
                });
            }];
    });
}

-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width
{
    UIWindow *window = self.view.window ? self.view.window : mainWindow;
    if (!window) {
        return;
    }
    mainWindow = window;
    if (ailoadindicator.hidden && sidewindowview.frame.origin.x==window.bounds.size.width) {
        return;
    }
    
    if (window.bounds.size.width-width == sidewindowview.frame.origin.x && fabs(sidewindowview.frame.size.height - window.bounds.size.height) < 0.5) {
        return;
    }
    
    if (width>0 && sidewindowview.frame.origin.x== window.bounds.size.width) {
        [MyClass playsoundwithoption:@"open"];
    }
    
    self.sideWindowAdjusting = YES;
    [UIView animateWithDuration:0.25f animations:^{
        sidewindowview.hidden = width<=0;
        sidewindowview.frame=CGRectMake(window.bounds.size.width-width, 0, width, window.bounds.size.height);
        for (UIView *panelChild in sidewindowview.subviews) {
            if ([panelChild isKindOfClass:[UIActivityIndicatorView class]]) {
                continue;
            }
            panelChild.frame = sidewindowview.bounds;
        }
        if (width==0 && sidewindowview.frame.origin.x< window.bounds.size.width) {
            [MyClass playsoundwithoption:@"close"];
        }
    } completion:^(BOOL finished){
        self.sideWindowAdjusting = NO;
        if (width > 0) {
            [self pinRenewalSideWindow];
        }
        if (width==0) {
            sidewindowview.hidden=YES;
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

    [RenewalRecordTable deselectRowAtIndexPath:[RenewalRecordTable indexPathForSelectedRow] animated: YES];
    [LogDetailsTable deselectRowAtIndexPath:[LogDetailsTable indexPathForSelectedRow] animated:YES];
    
}



-(void) startsidewindowanimationwithwidth:(float)width
{
    ailoadindicator.hidden=NO;
    ailoadindicator.center = CGPointMake(width/2-7.5,mainWindow.frame.size.height/2-7.5);
    [ailoadindicator startAnimating];
    [self adjustpresentingviewwidthwithwidth:width];
}

-(BOOL) isDifferentLevelWithLaterEnrollmentWithStartDate:(NSString *)startdate enrollmentkey:(NSString *)enrollmentkey subject:(NSString *)subject levelmain:(NSString *)levelmain levelctm:(NSString *)levelctm studentkey:(NSString *)studentkey
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updateenrollmentforrenwewal&studentkey=%@&startdate=%@&enrollmentkey=%@&subject=%@&levelmain=%@&levelctm=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,studentkey,[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:startdate],enrollmentkey,subject,levelmain,levelctm];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            NSString * resulta=[[JSONArray objectAtIndex:0] objectForKey:@"result"];
            if ([resulta isEqualToString:@"Y"]) {
                result=TRUE;
            }
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[MyClass dcurlstring:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            NSString * resulta=[[JSONArray objectAtIndex:0] objectForKey:@"result"];
            if ([resulta isEqualToString:@"Y"]) {
                result=TRUE;
            }
        }
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    return result;
}

-(void) renewalRecordTableLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:RenewalRecordTable];
        NSIndexPath *indexPath = [RenewalRecordTable indexPathForRowAtPoint:point];
        
        for(int i=0;i<[RenewalRecordTable numberOfSections];i++) {
            CGRect headerViewRect = [RenewalRecordTable rectForHeaderInSection:i];
            BOOL isInside = CGRectContainsPoint (headerViewRect, point);
            if(isInside) {
                return;
            }
            
        }
        
        if (indexPath) {
            
            RenewalRecordObject=[RenewalRecordArrayFilterResult objectAtIndex:indexPath.row];

            long index=[self includerenewalrecordwithBatchRenewalEnrollmentArray:BatchRenewalEnrollmentkeyArray Enrollmentkey:RenewalRecordObject.enrollmentkey];
            
            if (index>=0) {
                [BatchRenewalEnrollmentkeyArray removeObjectAtIndex:index];
            }else{
                [BatchRenewalEnrollmentkeyArray addObject:RenewalRecordObject];
            }
            
        }

        
        batchrenewalviewopened=TRUE;
        [self openbatchrenewalview:batchrenewalviewopened];
    }
}

-(void) openbatchrenewalview:(BOOL)open
{
    [UIView animateWithDuration:0.3 animations:^{
        if (open) {
            batchrenewalviewheightconstraint.constant=42;
            [self.view layoutIfNeeded];
            //batchrenewalview.hidden=NO;
        }else{
            batchrenewalviewheightconstraint.constant=0;
            [BatchRenewalEnrollmentkeyArray removeAllObjects];
            [self.view layoutIfNeeded];
            //batchrenewalview.hidden=YES;
        }
    } completion:^(BOOL finished){
        [self reloadtableheader];
        [RenewalRecordTable reloadData];
        //[self.view layoutIfNeeded];
        [supermasterview layoutIfNeeded];
    }];
}

-(void) cancelsubmitbatchbuttonpressed
{
    batchrenewalviewopened=FALSE;
    [self openbatchrenewalview:batchrenewalviewopened];
}

- (void)selectcoursetype:(UISegmentedControl *)sender {
    
    search_text.text=@"";
    [self.view endEditing:YES];
    
    if (batchrenewalviewopened) {
        [BatchRenewalEnrollmentkeyArray removeAllObjects];
        batchrenewalviewopened=FALSE;
        [self openbatchrenewalview:batchrenewalviewopened];
    }
    
    if(sccoursetype.selectedSegmentIndex==1){
        NSInteger monthenddate=[MyClass returnEndOfMonthwithCurrentDate:[NSDate date]];
        if (RemainingClassThresholdButton.tag != 0 || cutoffdatebutton.tag!=monthenddate) {
            RemainingClassThresholdButton.tag=0;
            cutoffdatebutton.tag=monthenddate;
            //[RemainingClassThresholdButton setTitle:[NSString stringWithFormat:@"%ld",(long)RemainingClassThresholdButton.tag] forState:UIControlStateNormal];
            
            [RemainingClassThresholdButton setTitle:[NSString stringWithFormat:@"%@ %ld",[MyClass returntitlewithtitle:@"Remaining Class"],(long)RemainingClassThresholdButton.tag] forState:UIControlStateNormal];
            //remainingclassthresholdtitle.text=[NSString stringWithFormat:@"%@ %ld",[MyClass returntitlewithtitle:@"Remaining Class"],(long)RemainingClassThresholdButton.tag];
            [cutoffdatebutton setTitle:[MyClass convertDateFormatWithDate:[@(cutoffdatebutton.tag) stringValue] FromDateFormat:@"yyyyMMdd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES] forState:UIControlStateNormal];
            
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self refreshtabledelay];
            });
        }else{
            [self returnfilterrenewalrecordarray];
        }
    }else{
        [self returnfilterrenewalrecordarray];
    }
}

-(void) returnfilterrenewallogarray
{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (![auto_search_text.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithBlock:^BOOL(RenewalLog *object, NSDictionary *bindings) {
            NSString *studentfullname=[MyClass returnStudentnameWithStudentkey:object.studentkey option:@"full"];
            SubjectRecord *subjectrecord=[MyClass returnsubjectinformationwithsubject_shortname:object.subject centerkey:globalvariables.centerrecord.centerkey];
            NSString *studentid=((Student *)[MyClass returnstudentwithstudentkey:object.studentkey]).studentid;
            return [object.studentkey rangeOfString:auto_search_text.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.subject rangeOfString:auto_search_text.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.renewalresultenglish rangeOfString:auto_search_text.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.renewalresultchinese rangeOfString:auto_search_text.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [subjectrecord.subject_chinesename rangeOfString:auto_search_text.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [subjectrecord.subject_englishname rangeOfString:auto_search_text.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [studentfullname rangeOfString:auto_search_text.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [studentid rangeOfString:auto_search_text.text options:NSCaseInsensitiveSearch].location!=NSNotFound;
        }];
        [nsPredicatearray addObject:newCondition];

        
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredrenewallogarray= [[NSMutableArray alloc]initWithArray:[renewallogarray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredrenewallogarray= [[NSMutableArray alloc]initWithArray:renewallogarray];
    }
    
    ((RenewalGroupLog *)[RenewalGroupLogArray objectAtIndex:groupLogSelected]).renewallogarray=filteredrenewallogarray;
}

-(void) returnfilterrenewalrecordarray
{
    //NSMutableArray *result;
    
    
    //dispatch_async(dispatch_get_main_queue(), ^{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    
    if (sccoursetype.selectedSegmentIndex==0){
        newCondition = [NSPredicate predicateWithFormat:@"self.coursetype = %@", @"Class"];
        [nsPredicatearray addObject:newCondition];
    }else if (sccoursetype.selectedSegmentIndex==1) {
        newCondition = [NSPredicate predicateWithFormat:@"self.coursetype = %@", @"Month"];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (![search_text.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithFormat:@"SELF.studentfullname contains[c] %@ or self.subject contains[c] %@ or self.levelmain contains[c] %@ or self.classtime contains[c] %@",search_text.text,search_text.text,search_text.text,search_text.text];
        [nsPredicatearray addObject:newCondition];
        
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        RenewalRecordArrayFilterResult= [[NSMutableArray alloc]initWithArray:[RenewalRecordArrayAllResult filteredArrayUsingPredicate:predicate]];
    }else{
        RenewalRecordArrayFilterResult= [[NSMutableArray alloc]initWithArray:RenewalRecordArrayAllResult];
    }
    
    //Sort
    NSSortDescriptor *sortbyname = [NSSortDescriptor sortDescriptorWithKey:@"studentfullname" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[sortbyname];
    RenewalRecordArrayFilterResult = [NSMutableArray arrayWithArray:[RenewalRecordArrayFilterResult sortedArrayUsingDescriptors:sortDescriptors]];
    
    [RenewalRecordTable reloadData];
    
    if(sccoursetype.selectedSegmentIndex==0){
        RemainingClassThresholdButton.enabled=YES;
        RemainingClassThresholdButton.backgroundColor=themecolor;
        cutoffdatebutton.enabled=YES;
        cutoffdatebutton.backgroundColor=themecolor;
    }else{
        RemainingClassThresholdButton.enabled=NO;
        RemainingClassThresholdButton.backgroundColor=[UIColor lightGrayColor];
        cutoffdatebutton.enabled=NO;
        cutoffdatebutton.backgroundColor=[UIColor lightGrayColor];
    }
    
    if ([search_text.text isEqualToString:@""]) {
        [ManualRenewalButton setTitle:[NSString stringWithFormat:@"%@ (%lu)",[MyClass returntitlewithtitle:@"Manual Renewal"],(unsigned long)RenewalRecordArrayFilterResult.count] forState:UIControlStateNormal];
    }
}

-(void) updatesearchtext
{
    [self returnfilterrenewalrecordarray];
}

-(void) updateautosearchtext
{
    [self returnfilterrenewallogarray];
    [LogDetailsTable reloadData];
}

- (CGFloat)visibleRenewalWidth
{
    CGFloat width = self.view.bounds.size.width;
    UIWindow *window = self.view.window;
    if (!window || width < 1) {
        return width;
    }
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGFloat leftShift = MAX(CGRectGetMinX(frameInWindow) - CGRectGetMinX(window.bounds), 0);
    CGFloat rightOverflow = MAX(CGRectGetMaxX(frameInWindow) - CGRectGetMaxX(window.bounds), 0);
    CGFloat menuSlide = MIN(leftShift, rightOverflow);
    return MAX(width - (rightOverflow - menuSlide), 0);
}

- (CGFloat)visibleRenewalHeight
{
    CGFloat height = self.view.bounds.size.height;
    UIWindow *window = self.view.window;
    if (!window || height < 1) {
        return height;
    }
    CGPoint bottom = [self.view convertPoint:CGPointMake(0, CGRectGetMaxY(window.bounds)) fromView:nil];
    return MIN(MAX(bottom.y, 0), height);
}

- (void)pinRenewalSideWindow
{
    UIWindow *window = self.view.window ? self.view.window : mainWindow;
    if (self.sideWindowAdjusting || !window || !sidewindowview || sidewindowview.hidden || sidewindowview.frame.size.width < 1.0) {
        return;
    }
    mainWindow = window;
    if (sidewindowview.superview != window) {
        [window addSubview:sidewindowview];
    }
    CGFloat panelWidth = MIN(sidewindowview.frame.size.width, window.bounds.size.width);
    sidewindowview.frame = CGRectMake(window.bounds.size.width - panelWidth, 0, panelWidth, window.bounds.size.height);
    if (sidewindowviewclosebutton) {
        if (sidewindowviewclosebutton.superview != window) {
            [window addSubview:sidewindowviewclosebutton];
        }
        sidewindowviewclosebutton.frame = window.bounds;
    }
    for (UIView *child in sidewindowview.subviews) {
        if ([child isKindOfClass:[UIActivityIndicatorView class]]) {
            continue;
        }
        child.frame = sidewindowview.bounds;
    }
}

- (void)layoutPendingRenewalForCurrentSize
{
    CGFloat width = [self visibleRenewalWidth];
    CGFloat height = [self visibleRenewalHeight];
    if (width < 1 || height < 1 || !supermasterview) {
        return;
    }
    if (!self.renewalEdgeConstants) {
        self.renewalEdgeConstants = [NSMutableDictionary dictionary];
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if (constraint.firstItem == self.view && constraint.firstAttribute == NSLayoutAttributeBottom && constraint.secondAttribute == NSLayoutAttributeBottom) {
                self.renewalEdgeConstants[[NSValue valueWithNonretainedObject:constraint]] = @(constraint.constant);
            }
        }
    }
    CGFloat overflow = MAX(self.view.bounds.size.width - width, 0);
    CGFloat verticalOverflow = MAX(self.view.bounds.size.height - height, 0);
    BOOL calendarOpen = supermasterviewleadingconstraint.constant < -1;
    CGFloat trailing = (calendarOpen ? 0 : -320) + overflow;
    if (supermasterviewtrailingconstraint && fabs(supermasterviewtrailingconstraint.constant - trailing) > 0.5) {
        supermasterviewtrailingconstraint.constant = trailing;
    }
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        NSNumber *original = self.renewalEdgeConstants[[NSValue valueWithNonretainedObject:constraint]];
        if (!original) {
            continue;
        }
        CGFloat constant = original.doubleValue + verticalOverflow;
        if (fabs(constraint.constant - constant) > 0.5) {
            constraint.constant = constant;
        }
    }
    CGFloat titleWidth = MAX(width - 140.0, 0);
    headertitleview.frame = CGRectMake(70, 0, titleWidth, 68);
    headertitlename.frame = CGRectMake(0, 25, titleWidth, 20);
    switchcenterbutton.frame = CGRectMake(0, 0, titleWidth, 68);
    [self updateheadercentertitle];
    reloadbutton.frame = CGRectMake(width - 45, 34, 28, 28);
    if (firstloadcover && !firstloadcover.hidden) {
        firstloadcover.frame = CGRectMake(0, 68, width, MAX(height - 68, 0));
    }
    if (supermasterviewbutton) {
        supermasterviewbutton.frame = CGRectMake(0, 0, width, height);
    }
    CGFloat calendarX = supermasterview.bounds.size.width - 320;
    if (calendarX < width) {
        calendarX = width;
    }
    calendarview.frame = CGRectMake(calendarX, 0, 320, height);
    [self pinRenewalSideWindow];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutPendingRenewalForCurrentSize];
}

-(void) closecalendar
{
    [self.mainSlideMenu enableSlidePanGestureForLeftMenu];
    [UIView animateWithDuration:0.3 animations:^{
        //supermasterview.frame=CGRectMake(0, 0, supermasterview.frame.size.width, supermasterview.frame.size.height);
        supermasterviewleadingconstraint.constant=0;
        supermasterviewtrailingconstraint.constant=-320;
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){supermasterviewbutton.hidden=YES;}];
}




-(void) opencalendar
{
    
    [self.mainSlideMenu disableSlidePanGestureForLeftMenu];
    [calendarview refreshviewwithoption:@"start"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:[@(cutoffdatebutton.tag) stringValue] FromDateFormat:@"yyyyMMdd" ToDateFormat:@"dd-MMM-yyyy"], nil] ScrollToDate:nil instructorselected:nil];
        [calendarview refreshviewwithoption:@"stop"];
        
        
        /*calendarviewcontroller.selecteddatearray=[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:[@(cutoffdatebutton.tag) stringValue] FromDateFormat:@"yyyyMMdd" ToDateFormat:@"dd-MMM-yyyy"], nil];
        calendarviewcontroller.scrolltodate=nil;
        //calendarviewcontroller.instructorselected=instructorselected;
        [calendarviewcontroller getclassddayrecord];
        [calendarviewcontroller.CalendarTable reloadData];
        [calendarviewcontroller scrollToSelectedDate];
        [calendarviewcontroller refreshviewwithoption:@"stop"];*/
    });
    
    
    
    [UIView animateWithDuration:0.3 animations:^{
        //supermasterview.frame=CGRectMake(-315, 0, supermasterview.frame.size.width, supermasterview.frame.size.height);
        supermasterviewleadingconstraint.constant=-320;
        supermasterviewtrailingconstraint.constant=0;
        [self.view layoutIfNeeded];
        supermasterviewbutton.hidden=NO;
    } completion:nil];
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    [self closecalendar];
    //NSInteger oldselecteddate=cutoffdatebutton.tag;
    NSInteger new_selected_date=[[MyClass convertDateFormatWithDate:[selecteddatearray firstObject] FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyyMMdd"] integerValue];
    
    if (new_selected_date!=cutoffdatebutton.tag) {
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if ([self retrieveRenewalRecordWithSelectedDate:new_selected_date remainingclass:RemainingClassThresholdButton.tag classday:@"All"]) {
                cutoffdatebutton.tag=new_selected_date;
                [cutoffdatebutton setTitle:[MyClass convertDateFormatWithDate:[@(cutoffdatebutton.tag) stringValue] FromDateFormat:@"yyyyMMdd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES] forState:UIControlStateNormal];
            }
        });
    }
}

-(void) selectbuttonpressed
{
    batchrenewalviewopened=!batchrenewalviewopened;
    [self openbatchrenewalview:batchrenewalviewopened];
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

-(void) gotostudentprofile:(NSString *)studentkey
{
    //not used
}


-(void) refreshstudentdetailviewpresentingviewcontent
{
    //[ailoadclass startAnimating];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshtabledelay];
    });
    
}

-(void) refreshparentviewdocumentfoldercount
{
    //not used
}

-(void) updatestudentinformationlist:(NSString *)studentkey reloadlist:(BOOL)reload
{
    //not used
}

-(void) dismissEditStudentView{
    
}

@end
