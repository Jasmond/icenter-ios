//
//  TaskAssignmentViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 3/9/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import "TaskAssignmentViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MainMenuViewController.h"
#import "MyClass.h"
#import "MainViewController.h"
#import "MyTableViewCell.h"
#import "SceneDelegate.h"


@interface TaskAssignmentViewController ()
{
    BOOL sideWindowAdjusting;
    NSMutableDictionary *taskTrailingConstants;
    NSMutableDictionary *taskBottomConstants;
}
@end

#define cellheight 38
#define maxPopupHeight self.view.frame.size.height
#define popoverwidth 320
#define ownertablewidth 320
#define assigneetablewidth 320

@implementation TaskAssignmentViewController
@synthesize myPopoverController;
@synthesize selectedtaskkey,selectedtaskview,selectedview;

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
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    //TaskTable.frame=CGRectMake(0, 48, self.view.frame.size.width, self.view.frame.size.height-157);
    //AllOtherTaskTable.frame=CGRectMake(0, 48, self.view.frame.size.width, self.view.frame.size.height-157);
    //assigntaskbutton.frame=CGRectMake(self.view.frame.size.width-41, 36, 23, 23);
    //scstatus.frame=CGRectMake(self.view.frame.size.width-290, 72, 279, 29);
    //title_Remarks.frame=CGRectMake(self.view.frame.size.width-356, 4, 237, 21);
    //title_Status.frame=CGRectMake(self.view.frame.size.width-129, 4, 101, 21);
    
    globalvariables.lastviewcontroller=(NSString *)self;
    //[self checkprivilege];
    
    
    headertitleview=[[UIView alloc]initWithFrame:CGRectMake(70, 0, self.view.bounds.size.width-140, 68)];
    headertitlename=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, headertitleview.frame.size.width, 20)];
    headertitlename.font=[UIFont boldSystemFontOfSize:17];
    headertitlename.textColor=[UIColor whiteColor];
    headertitlename.textAlignment=NSTextAlignmentCenter;
    [headertitleview addSubview:headertitlename];
    [self.view addSubview:headertitleview];
    
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
    //[switchcenterbutton setImage:[UIImage imageWithData:globalvariables.menuimagedata] forState:UIControlStateNormal];
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
    
    //TaskTable=[[UITableView alloc]init];
    //AllOtherTaskTable=[[UITableView alloc]init];
    
    TaskTable.rowHeight=UITableViewAutomaticDimension;
    TaskTable.estimatedRowHeight=80;
    
    statusarray=[[NSArray alloc]initWithObjects:@"All",@"Open",@"Closed", nil];
    

    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    //tablerefresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [tablerefresh addTarget:self action:@selector(refreshtasktable) forControlEvents:UIControlEventValueChanged];
    [TaskTable addSubview:tablerefresh];
    
    RequestTable.rowHeight=UITableViewAutomaticDimension;
    RequestTable.estimatedRowHeight=80;
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshrequesttable) forControlEvents:UIControlEventValueChanged];
    [RequestTable addSubview:tablerefresh];


    [sctaskview addTarget:self action:@selector(selecttaskview:) forControlEvents: UIControlEventValueChanged];
    
    df =[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    

    hourPickerViewMenu=[[NSMutableArray alloc]init];
    minutePickerViewMenu=[[NSMutableArray alloc]init];
    for (int i=0;i<24; i++) {
        [hourPickerViewMenu addObject:[NSString stringWithFormat:@"%02i",i]];
    }
    
    for (int i=0; i<60; i++) {
        [minutePickerViewMenu addObject:[NSString stringWithFormat:@"%02i",i]];
    }
    
    reloadbutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-45, 34, 28,28)];
    [reloadbutton setImage:[UIImage imageNamed:@"reload_white.png"] forState:UIControlStateNormal];
    [reloadbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reloadbutton addTarget: self action:@selector(viewDidAppear:) forControlEvents: UIControlEventTouchUpInside];
    reloadbutton.hidden=YES;
    [self.view addSubview:reloadbutton];
    
    search_text.backgroundColor=[UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:0.8];//[UIColor lightGrayColor];
    search_text.font=[UIFont systemFontOfSize:12];
    search_text.textColor=[UIColor whiteColor];
    search_text.layer.cornerRadius=3;
    search_text.layer.masksToBounds=YES;
    search_text.tag=-1;
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

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];

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
    sidewindowview.clipsToBounds=YES;
    sidewindowview.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
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
    
    laststatusindex=1;
    scstatus.selectedSegmentIndex=1;
    sctype.selectedSegmentIndex=1;
    
    
    taskview.hidden=YES;
    sctaskview.hidden=YES;
    scstatus.hidden=YES;
    assigntaskbutton.hidden=YES;
    
    requestview.hidden=NO;
    screquestor.hidden=NO;
    screqueststatus.hidden=NO;
    search_text.hidden=NO;
    
    sideWindowType=0;
    
    [self refreshlanguage];
}

-(void) createsidetables
{
    
    //owner table
    OwnerTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, ownertablewidth, self.view.frame.size.height)];
    [taskdetailsviewcontroller.view addSubview:OwnerTableMasterView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, OwnerTableMasterView.frame.size.width,84)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [OwnerTableMasterView addSubview:headerView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Assigned By"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    ownersearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, OwnerTableMasterView.frame.size.width, 42)];
    ownersearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    ownersearchbar.delegate=self;
    [headerView addSubview:ownersearchbar];
    
    OwnerTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84+20, ownertablewidth, self.view.frame.size.height-44-84-20) style:UITableViewStyleGrouped];
    OwnerTable.dataSource=self;
    OwnerTable.delegate=self;
    OwnerTable.sectionHeaderHeight=0;
    [OwnerTable reloadData];
    [OwnerTableMasterView addSubview:OwnerTable];
    
    OwnerTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, ownertablewidth, 44)];
    OwnerTableToolBar.clipsToBounds=YES;
    [OwnerTableMasterView addSubview:OwnerTableToolBar];
    
    
    [self createOwnerTableToolBar];
    
    
    //assignee table
    AssigneeTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, assigneetablewidth, self.view.frame.size.height)];
    [taskdetailsviewcontroller.view addSubview:AssigneeTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, AssigneeTableMasterView.frame.size.width,84+35)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [AssigneeTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Assigned To"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    UILabel *separator=[[UILabel alloc]initWithFrame:CGRectMake(0, 44, assigneetablewidth, 1)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [headerView addSubview:separator];
    
    
    scassigntype = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Individual"],[MyClass returntitlewithtitle:@"Group"],nil]];
    scassigntype.frame = CGRectMake(3, 44+4, assigneetablewidth-6, 29);
    scassigntype.selectedSegmentIndex = tmpassignclasstype;
    [scassigntype addTarget:self action:@selector(selectassigntotype:) forControlEvents: UIControlEventValueChanged];
    [headerView addSubview:scassigntype];
    
    
    assigneesearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44+35, AssigneeTableMasterView.frame.size.width, 42)];
    assigneesearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    assigneesearchbar.delegate=self;
    [headerView addSubview:assigneesearchbar];
    
    AssigneeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 64+44+35+44, assigneetablewidth, self.view.frame.size.height-44-44-20-35) style:UITableViewStyleGrouped];
    AssigneeTable.dataSource=self;
    AssigneeTable.delegate=self;
    AssigneeTable.sectionHeaderHeight=0;
    [AssigneeTable reloadData];
    [AssigneeTableMasterView addSubview:AssigneeTable];
    
    AssigneeTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, assigneetablewidth, 44)];
    AssigneeTableToolBar.clipsToBounds=YES;
    [AssigneeTableMasterView addSubview:AssigneeTableToolBar];
    
    
    [self createAssigneeTableToolBar];
    
    //add separator
    separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth, 20, 1, self.view.bounds.size.height-20)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [taskdetailsviewcontroller.view addSubview:separator];
    
}

-(void) createOwnerTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closetasktablesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [OwnerTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closetasktablesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [OwnerTableMasterView addSubview:button];
}

-(void) createAssigneeTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closetasktablesidewindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [AssigneeTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closetasktablesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [AssigneeTableMasterView addSubview:button];
}

-(void) closetasktablesidewindow
{
    
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [taskAddTable deselectRowAtIndexPath:[taskAddTable indexPathForSelectedRow] animated:YES];
    [self adjustTaskAddTableSize];
    //sideWindowType=0;
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    if ([windowname isEqualToString:@"OwnerTable"]) {
        showOwnTable=YES;
        showAssigneeTable=NO;
        [OwnerTable reloadData];
    }else if ([windowname isEqualToString:@"AssigneeTable"]) {
        showOwnTable=NO;
        showAssigneeTable=YES;
        [AssigneeTable reloadData];
    }else{
        showOwnTable=NO;
        showAssigneeTable=NO;
    }
}

-(void) checktoreloadapp
{
    
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {
        if ([myPopoverController presentingViewController].isBeingPresented) {
            [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
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
    headertitlename.text=[MyClass returntitlewithtitle:@"Task and Request"];
    [self updateheadercentertitle];
    
    [sctype setTitle:[MyClass returntitlewithtitle:@"Task"] forSegmentAtIndex:0];
    [sctype setTitle:[MyClass returntitlewithtitle:@"Request"] forSegmentAtIndex:1];
    
    [sctaskview setTitle:[MyClass returntitlewithtitle:@"My Task"] forSegmentAtIndex:0];
    [sctaskview setTitle:[MyClass returntitlewithtitle:@"Task to Others"] forSegmentAtIndex:1];
    [sctaskview setTitle:[MyClass returntitlewithtitle:@"All Other Task"] forSegmentAtIndex:2];

    [screquestor setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [screquestor setTitle:[MyClass returntitlewithtitle:@"User"] forSegmentAtIndex:1];
    [screquestor setTitle:[MyClass returntitlewithtitle:@"Staff"] forSegmentAtIndex:2];

    [screqueststatus setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [screqueststatus setTitle:[MyClass returntitlewithtitle:@"Approved"] forSegmentAtIndex:1];
    [screqueststatus setTitle:[MyClass returntitlewithtitle:@"Pending"] forSegmentAtIndex:2];
    [screqueststatus setTitle:[MyClass returntitlewithtitle:@"Cancelled"] forSegmentAtIndex:3];
    [screqueststatus setTitle:[MyClass returntitlewithtitle:@"Rejected"] forSegmentAtIndex:4];
    [screqueststatus setTitle:[MyClass returntitlewithtitle:@"Rescheduled"] forSegmentAtIndex:5];
    
    [scstatus setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [scstatus setTitle:[MyClass returntitlewithtitle:@"Open"] forSegmentAtIndex:1];
    [scstatus setTitle:[MyClass returntitlewithtitle:@"Closed"] forSegmentAtIndex:2];
    
    [self loadtitle];
}

- (CGFloat)visibleTaskWidth
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

- (CGFloat)visibleTaskHeight
{
    CGFloat height = self.view.bounds.size.height;
    UIWindow *window = self.view.window;
    if (!window || height < 1) {
        return height;
    }
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGFloat visibleMaxY = MIN(CGRectGetMaxY(frameInWindow), CGRectGetMaxY(window.bounds));
    return MAX(MIN(visibleMaxY - CGRectGetMinY(frameInWindow), height), 0);
}

- (CGRect)visibleWindowFrame
{
    UIWindow *window = self.view.window ? self.view.window : mainWindow;
    if (!window) {
        return CGRectZero;
    }
    if (!self.isViewLoaded || !self.view.window) {
        return window.bounds;
    }
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGRect visible = CGRectIntersection(frameInWindow, window.bounds);
    if (CGRectIsNull(visible) || visible.size.width < 1 || visible.size.height < 1) {
        return window.bounds;
    }
    return visible;
}

- (void)layoutTaskAssignmentForCurrentSize
{
    CGFloat width = [self visibleTaskWidth];
    CGFloat height = [self visibleTaskHeight];
    if (width < 1 || height < 1) {
        return;
    }
    if (!taskTrailingConstants) {
        taskTrailingConstants = [NSMutableDictionary dictionary];
        taskBottomConstants = [NSMutableDictionary dictionary];
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if (constraint.firstItem == self.view && constraint.firstAttribute == NSLayoutAttributeTrailing && constraint.secondAttribute == NSLayoutAttributeTrailing) {
                taskTrailingConstants[[NSValue valueWithNonretainedObject:constraint]] = @(constraint.constant);
            }
            if (constraint.firstItem == self.view && constraint.firstAttribute == NSLayoutAttributeBottom && constraint.secondAttribute == NSLayoutAttributeBottom) {
                taskBottomConstants[[NSValue valueWithNonretainedObject:constraint]] = @(constraint.constant);
            }
        }
    }
    CGFloat overflow = MAX(self.view.bounds.size.width - width, 0);
    CGFloat verticalOverflow = MAX(self.view.bounds.size.height - height, 0);
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        NSNumber *trailingOriginal = taskTrailingConstants[[NSValue valueWithNonretainedObject:constraint]];
        if (trailingOriginal && fabs(constraint.constant - (trailingOriginal.doubleValue + overflow)) > 0.5) {
            constraint.constant = trailingOriginal.doubleValue + overflow;
        }
        NSNumber *bottomOriginal = taskBottomConstants[[NSValue valueWithNonretainedObject:constraint]];
        if (bottomOriginal && fabs(constraint.constant - (bottomOriginal.doubleValue + verticalOverflow)) > 0.5) {
            constraint.constant = bottomOriginal.doubleValue + verticalOverflow;
        }
    }
    CGFloat titleWidth = MAX(width - 140.0, 0);
    headertitleview.frame = CGRectMake(70, 0, titleWidth, 68);
    headertitlename.frame = CGRectMake(0, 25, titleWidth, 20);
    switchcenterbutton.frame = CGRectMake(0, 0, titleWidth, 68);
    [self updateheadercentertitle];
    if (reloadbutton) {
        reloadbutton.frame = CGRectMake(width - 45, 34, 28, 28);
    }
}

- (void)pinOpenSideWindowToVisibleEdge
{
    if (sideWindowAdjusting || !sidewindowview || sidewindowview.hidden || sidewindowview.frame.size.width < 1.0) {
        return;
    }
    CGRect visible = [self visibleWindowFrame];
    if (visible.size.width < 1.0 || visible.size.height < 1.0) {
        return;
    }
    CGFloat panelWidth = MIN(sidewindowview.frame.size.width, visible.size.width);
    sidewindowview.frame = CGRectMake(CGRectGetMaxX(visible) - panelWidth, visible.origin.y, panelWidth, visible.size.height);
    if (sidewindowviewclosebutton && !sidewindowviewclosebutton.hidden) {
        sidewindowviewclosebutton.frame = visible;
    }
    for (UIView *child in sidewindowview.subviews) {
        if ([child isKindOfClass:[UIActivityIndicatorView class]]) {
            continue;
        }
        child.frame = sidewindowview.bounds;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutTaskAssignmentForCurrentSize];
    [self pinOpenSideWindowToVisibleEdge];
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


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.mainSlideMenu disableSlidePanGestureForRightMenu];
    globalvariables.lastviewcontroller=(NSString *)self;
    if (sidewindowview.frame.origin.x==mainWindow.bounds.size.width) {
        [self reloadPageWithFirstLoad:YES];
    }
}

-(void) refreshtasktable
{
    if (sctaskview.selectedSegmentIndex==0) {
        [self retrieveMyTaskRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
    }else if (sctaskview.selectedSegmentIndex==1){
        [self retrieveTaskToOthersRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
    }

    for (id object in [TaskTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}


-(void) refreshrequesttable
{

    [self retrieveStudentRequest];
    
    for (id object in [RequestTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

/*
-(void) refreshallothertasktable
{
    [self retrieveAllOtherTaskRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
    for (id object in [AllOtherTaskTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}*/

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

- (void)keyboardDidHide: (NSNotification *) notification
{
    // Do something here
    keyboardheight=0;
    [self adjustTaskAddTableSize];
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    [self adjustTaskAddTableSize];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    [self adjustTaskAddTableSize];
    
}

-(void) retrieveStudentRequest
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievestudentrequest",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey];

    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result = TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            studentRequestArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                NSInteger studentrequestkey=[[[JSONArray objectAtIndex:i] objectForKey:@"studentrequestkey"] integerValue];
                NSString * centerkey=[[JSONArray objectAtIndex:i] objectForKey:@"centerkey"];
                NSString * request_category=[[JSONArray objectAtIndex:i] objectForKey:@"request_category"];
                NSInteger requesting_categorykey=[[[JSONArray objectAtIndex:i] objectForKey:@"requesting_categorykey"] integerValue];
                NSString * request_for_type=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_type"];
                NSString * request_for_value=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_value"];
                NSString * request_for_instructor=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_instructor"];
                NSString * request_from_instructor=[[JSONArray objectAtIndex:i] objectForKey:@"request_from_instructor"];
                NSString * request_for_classroom=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_classroom"];
                NSString * request_from_classroom=[[JSONArray objectAtIndex:i] objectForKey:@"request_from_classroom"];
                NSString * request_for_leavenaturelistkey=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_leavenaturelistkey"];
                NSString * request_for_value_reason=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_value_reason"];
                
                NSDate * requestingdatetime=[MyClass convertToNSDateWithDate:[NSString stringWithFormat:@"%@ %@",[[JSONArray objectAtIndex:i] objectForKey:@"request_for_date"],[[JSONArray objectAtIndex:i] objectForKey:@"request_for_time"]] DateFormat:@"yyyy-MM-dd HH:mm"];
                
                NSString * request_status=[[JSONArray objectAtIndex:i] objectForKey:@"request_status"];
                NSString * requestor_username=[[JSONArray objectAtIndex:i] objectForKey:@"requestor_username"];
                NSDate * request_time=[MyClass convertToNSDateWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"request_time"] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString * actionby=[[JSONArray objectAtIndex:i] objectForKey:@"lastupdatedby"];
                NSDate * actiontime=[MyClass convertToNSDateWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"lastupdatetime"] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString * studentfullname=[MyClass returnStudentnameWithStudentkey:[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"] option:@"full"];
                NSString * subjectfullname=[MyClass returnsubjectnamewithsubject_shortname:[[JSONArray objectAtIndex:i] objectForKey:@"subject"] centerkey:centerkey];
                BOOL count_quota=[[[JSONArray objectAtIndex:i] objectForKey:@"count_quota"] isEqualToString:@"Y"];
                NSString * request_from_date=[[JSONArray objectAtIndex:i] objectForKey:@"request_from_date"];
                NSString * request_from_time=[[JSONArray objectAtIndex:i] objectForKey:@"request_from_time"];
                NSString * request_from_value=[[JSONArray objectAtIndex:i] objectForKey:@"request_from_value"];
                
                ClassRecord *classrecord=[[ClassRecord alloc]init];
                classrecord.classkey=[[JSONArray objectAtIndex:i] objectForKey:@"requesting_categorykey"];
                classrecord.studentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                classrecord.startdate=[[JSONArray objectAtIndex:i] objectForKey:@"startdate"];
                classrecord.classtime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                classrecord.attendance=[[JSONArray objectAtIndex:i] objectForKey:@"attendance"];
                classrecord.makeupdate=[[JSONArray objectAtIndex:i] objectForKey:@"makeupdate"];
                classrecord.makeuptime=[[JSONArray objectAtIndex:i] objectForKey:@"makeuptime"];
                classrecord.makeupattendance=[[JSONArray objectAtIndex:i] objectForKey:@"makeupattendance"];
                classrecord.studentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                classrecord.instructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
                classrecord.classroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
                classrecord.makeupinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"makeupinstructor"];
                classrecord.makeupclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"makeupclassroom"];
                classrecord.absentmakeupreason=[[JSONArray objectAtIndex:i] objectForKey:@"absentmakeupreason"];
                classrecord.subject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                classrecord.leavenaturelistkey=[[JSONArray objectAtIndex:i] objectForKey:@"leavenaturelistkey"];
                classrecord.enrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
                
                NSString * actionbyfullname=[self returnnamewithrequestname:[[JSONArray objectAtIndex:i] objectForKey:@"lastupdatedby"] studentkey:classrecord.studentkey];
                
                [studentRequestArray addObject:[[StudentRequestRecord alloc]initStudentRequestRecordWithStudentRequestKey:studentrequestkey CenterKey:centerkey requesting_category:request_category requesting_categorykey:requesting_categorykey request_for_type:request_for_type request_for_value:request_for_value request_for_leavenaturelistkey:request_for_leavenaturelistkey request_for_value_reason:request_for_value_reason requestingdatetime:requestingdatetime request_status:request_status requestor_username:requestor_username request_time:request_time actionby:actionby actiontime:actiontime studentfullname:studentfullname subjectfullname:subjectfullname actionbyfullname:actionbyfullname classrecord:classrecord request_for_instructor:request_for_instructor request_for_classroom:request_for_classroom count_quota:count_quota request_from_date:request_from_date request_from_time:request_from_time request_from_value:request_from_value request_from_instructor:request_from_instructor request_from_classroom:request_from_classroom]];
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
            JSONArray = jsonreturned[@"content"];
            studentRequestArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                NSInteger studentrequestkey=[[[JSONArray objectAtIndex:i] objectForKey:@"studentrequestkey"] integerValue];
                NSString * centerkey=[[JSONArray objectAtIndex:i] objectForKey:@"centerkey"];
                NSString * request_category=[[JSONArray objectAtIndex:i] objectForKey:@"request_category"];
                NSInteger requesting_categorykey=[[[JSONArray objectAtIndex:i] objectForKey:@"requesting_categorykey"] integerValue];
                NSString * request_for_type=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_type"];
                NSString * request_for_value=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_value"];
                NSString * request_for_instructor=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_instructor"];
                NSString * request_from_instructor=[[JSONArray objectAtIndex:i] objectForKey:@"request_from_instructor"];
                NSString * request_for_classroom=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_classroom"];
                NSString * request_for_leavenaturelistkey=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_leavenaturelistkey"];
                NSString * request_for_value_reason=[[JSONArray objectAtIndex:i] objectForKey:@"request_for_value_reason"];
                
                NSDate * requestingdatetime=[MyClass convertToNSDateWithDate:[NSString stringWithFormat:@"%@ %@",[[JSONArray objectAtIndex:i] objectForKey:@"request_for_date"],[[JSONArray objectAtIndex:i] objectForKey:@"request_for_time"]] DateFormat:@"yyyy-MM-dd HH:mm"];
                
                NSString * request_status=[[JSONArray objectAtIndex:i] objectForKey:@"request_status"];
                NSString * requestor_username=[[JSONArray objectAtIndex:i] objectForKey:@"requestor_username"];
                NSDate * request_time=[MyClass convertToNSDateWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"request_time"] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString * actionby=[[JSONArray objectAtIndex:i] objectForKey:@"lastupdatedby"];
                NSDate * actiontime=[MyClass convertToNSDateWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"lastupdatetime"] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString * studentfullname=[MyClass returnStudentnameWithStudentkey:[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"] option:@"full"];
                NSString * subjectfullname=[MyClass returnsubjectnamewithsubject_shortname:[[JSONArray objectAtIndex:i] objectForKey:@"subject"] centerkey:centerkey];
                BOOL count_quota=[[[JSONArray objectAtIndex:i] objectForKey:@"count_quota"] isEqualToString:@"Y"];
                NSString * request_from_date=[[JSONArray objectAtIndex:i] objectForKey:@"request_from_date"];
                NSString * request_from_time=[[JSONArray objectAtIndex:i] objectForKey:@"request_from_time"];
                NSString * request_from_value=[[JSONArray objectAtIndex:i] objectForKey:@"request_from_value"];
                
                ClassRecord *classrecord=[[ClassRecord alloc]init];
                classrecord.classkey=[[JSONArray objectAtIndex:i] objectForKey:@"requesting_categorykey"];
                classrecord.studentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                classrecord.startdate=[[JSONArray objectAtIndex:i] objectForKey:@"startdate"];
                classrecord.classtime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                classrecord.attendance=[[JSONArray objectAtIndex:i] objectForKey:@"attendance"];
                classrecord.makeupdate=[[JSONArray objectAtIndex:i] objectForKey:@"makeupdate"];
                classrecord.makeuptime=[[JSONArray objectAtIndex:i] objectForKey:@"makeuptime"];
                classrecord.makeupattendance=[[JSONArray objectAtIndex:i] objectForKey:@"makeupattendance"];
                classrecord.studentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                classrecord.instructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
                classrecord.classroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
                classrecord.makeupinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"makeupinstructor"];
                classrecord.makeupclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"makeupclassroom"];
                classrecord.absentmakeupreason=[[JSONArray objectAtIndex:i] objectForKey:@"absentmakeupreason"];
                classrecord.subject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                classrecord.leavenaturelistkey=[[JSONArray objectAtIndex:i] objectForKey:@"leavenaturelistkey"];
                classrecord.enrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
                
                NSString * actionbyfullname=[self returnnamewithrequestname:[[JSONArray objectAtIndex:i] objectForKey:@"lastupdatedby"] studentkey:classrecord.studentkey];
                
                [studentRequestArray addObject:[[StudentRequestRecord alloc]initStudentRequestRecordWithStudentRequestKey:studentrequestkey CenterKey:centerkey requesting_category:request_category requesting_categorykey:requesting_categorykey request_for_type:request_for_type request_for_value:request_for_value request_for_leavenaturelistkey:request_for_leavenaturelistkey request_for_value_reason:request_for_value_reason requestingdatetime:requestingdatetime request_status:request_status requestor_username:requestor_username request_time:request_time actionby:actionby actiontime:actiontime studentfullname:studentfullname subjectfullname:subjectfullname actionbyfullname:actionbyfullname classrecord:classrecord request_for_instructor:request_for_instructor request_for_classroom:request_for_classroom count_quota:count_quota request_from_date:request_from_date request_from_time:request_from_time request_from_value:request_from_value request_from_instructor:request_from_instructor]];
            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
            
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        [self returnfilterstudentrequestarray];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
}

-(ContactRecord *) returncontactrecordwithstudentrequestobject:(StudentRequestRecord *)request
{
    NSRange range=[request.requestor_username rangeOfString:@"@"];
    if (range.location==NSNotFound) {
        //parent
        return [MyClass returncontactrecordwithstudentkey:request.classrecord.studentkey contact:request.requestor_username];
    }
    
    return nil;
}

-(NSString *) returnnamewithrequestname:(NSString *)requestname studentkey:(NSString *)studentkey
{
    NSRange range=[requestname rangeOfString:@"@"];
    if (range.location==NSNotFound) {
        //parent
        return [NSString stringWithFormat:@"%@/%@",[MyClass returnContactRelationshipWithStudentkey:studentkey Contact:requestname],requestname];
    }else{
        //staff
        return [MyClass returnstaffnamewithusername:requestname firstorfullname:@"full"];
    }
}

-(BOOL) retrieveMyTaskRecordsWithStatus:(NSString *)taskstatus
{
    __block int selectedtaskkeyindex=0;
    
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievemytask&status=%@&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewtaskassignment"],taskstatus,globalvariables.username];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDate *date;
            result = TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            MyTaskArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                
                //Create our ClassRecord object
                NSString * ctaskkey=[[JSONArray objectAtIndex:i] objectForKey:@"taskkey"];
                if ([ctaskkey isEqualToString:selectedtaskkey]) {
                    selectedtaskkeyindex=i;
                }
                
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"createdatetime"]];
                [df setDateFormat:@"dd-MMM-yyyy"];
                NSString *ccreatedatetime=[df stringFromDate:date];
                
                //NSString * cassignedby=[[JSONArray objectAtIndex:i] objectForKey:@"assignedby"];
                //NSString * cassignedto=[[JSONArray objectAtIndex:i] objectForKey:@"assignedto"];
                NSString * cassignedbyusername=[[JSONArray objectAtIndex:i] objectForKey:@"assignedbyusername"];
                NSString * cassignedtousername=[[JSONArray objectAtIndex:i] objectForKey:@"assignedtousername"];
                NSString * cassignedby=[MyClass returnstaffnamewithusername:cassignedbyusername firstorfullname:@"full"];
                NSString * cassignedto=[MyClass returnstaffnamewithusername:cassignedtousername firstorfullname:@"full"];
                
                NSString * cfollowupdatetime=[[JSONArray objectAtIndex:i] objectForKey:@"followupdatetime"];
                NSString * ctaskname=[[JSONArray objectAtIndex:i] objectForKey:@"taskname"];
                NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                NSString * cstatus=[[JSONArray objectAtIndex:i] objectForKey:@"status"];
                
                [MyTaskArray addObject:[[TaskRecord alloc]initTaskRecordwithTaskkey:ctaskkey Createdatetime:ccreatedatetime Assignedby:cassignedby Assignedto:cassignedto AssignedbyUsername:cassignedbyusername AssignedtoUsername:cassignedtousername Followupdatetime:cfollowupdatetime Taskname:ctaskname Remarks:cremarks Status:cstatus Action:@""]];
            }
        }
    }];
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        NSDate *date;
        if (!error) {
            result = TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            MyTaskArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                
                //Create our ClassRecord object
                NSString * ctaskkey=[[JSONArray objectAtIndex:i] objectForKey:@"taskkey"];
                if ([ctaskkey isEqualToString:selectedtaskkey]) {
                    selectedtaskkeyindex=i;
                }
                
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"createdatetime"]];
                [df setDateFormat:@"dd-MMM-yyyy"];
                NSString *ccreatedatetime=[df stringFromDate:date];
                
                //NSString * cassignedby=[[JSONArray objectAtIndex:i] objectForKey:@"assignedby"];
                //NSString * cassignedto=[[JSONArray objectAtIndex:i] objectForKey:@"assignedto"];
                NSString * cassignedbyusername=[[JSONArray objectAtIndex:i] objectForKey:@"assignedbyusername"];
                NSString * cassignedtousername=[[JSONArray objectAtIndex:i] objectForKey:@"assignedtousername"];
                NSString * cassignedby=[MyClass returnstaffnamewithusername:cassignedbyusername firstorfullname:@"full"];
                NSString * cassignedto=[MyClass returnstaffnamewithusername:cassignedtousername firstorfullname:@"full"];
                
                NSString * cfollowupdatetime=[[JSONArray objectAtIndex:i] objectForKey:@"followupdatetime"];
                NSString * ctaskname=[[JSONArray objectAtIndex:i] objectForKey:@"taskname"];
                NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                NSString * cstatus=[[JSONArray objectAtIndex:i] objectForKey:@"status"];
                
                [MyTaskArray addObject:[[TaskRecord alloc]initTaskRecordwithTaskkey:ctaskkey Createdatetime:ccreatedatetime Assignedby:cassignedby Assignedto:cassignedto AssignedbyUsername:cassignedbyusername AssignedtoUsername:cassignedtousername Followupdatetime:cfollowupdatetime Taskname:ctaskname Remarks:cremarks Status:cstatus Action:@""]];
            }
            
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
            
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        [TaskTable reloadData];
        if (MyTaskArray.count>0) {
            [TaskTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedtaskkeyindex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    
    return result;

    
    
}


-(BOOL) retrieveAllOtherTaskRecordsWithStatus:(NSString *)taskstatus
{
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrieveallothertask&status=%@&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewtaskassignment"],taskstatus,globalvariables.username];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDate *date;
            result = TRUE;
            
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                JSONArray = jsonreturned[@"content"];
                
                AllOtherTasksArray=[[NSMutableArray alloc]init];
                
                //loop through our jsonArray
                for (int i=0; i<JSONArray.count; i++) {
                    
                    
                    //Create our ClassRecord object
                    NSString * ctaskkey=[[JSONArray objectAtIndex:i] objectForKey:@"taskkey"];
                    
                    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"createdatetime"]];
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    NSString *ccreatedatetime=[df stringFromDate:date];
                    
                    //NSString * cassignedby=[[JSONArray objectAtIndex:i] objectForKey:@"assignedby"];
                    //NSString * cassignedto=[[JSONArray objectAtIndex:i] objectForKey:@"assignedto"];
                    NSString * cassignedbyusername=[[JSONArray objectAtIndex:i] objectForKey:@"assignedbyusername"];
                    NSString * cassignedtousername=[[JSONArray objectAtIndex:i] objectForKey:@"assignedtousername"];
                    
                    NSString * cassignedby=[MyClass returnstaffnamewithusername:cassignedbyusername firstorfullname:@"full"];
                    NSString * cassignedto=[MyClass returnstaffnamewithusername:cassignedtousername firstorfullname:@"full"];
                    
                    NSString * cfollowupdatetime=[[JSONArray objectAtIndex:i] objectForKey:@"followupdatetime"];
                    NSString * ctaskname=[[JSONArray objectAtIndex:i] objectForKey:@"taskname"];
                    NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                    NSString * cstatus=[[JSONArray objectAtIndex:i] objectForKey:@"status"];
                    
                    [AllOtherTasksArray addObject:[[TaskRecord alloc]initTaskRecordwithTaskkey:ctaskkey Createdatetime:ccreatedatetime Assignedby:cassignedby Assignedto:cassignedto AssignedbyUsername:cassignedbyusername AssignedtoUsername:cassignedtousername Followupdatetime:cfollowupdatetime Taskname:ctaskname Remarks:cremarks Status:cstatus Action:@""]];
                }
        }
    }];
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        NSDate *date;
        if (!error) {
            result = TRUE;
        
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            AllOtherTasksArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                
                //Create our ClassRecord object
                NSString * ctaskkey=[[JSONArray objectAtIndex:i] objectForKey:@"taskkey"];
                
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"createdatetime"]];
                [df setDateFormat:@"dd-MMM-yyyy"];
                NSString *ccreatedatetime=[df stringFromDate:date];
                
                //NSString * cassignedby=[[JSONArray objectAtIndex:i] objectForKey:@"assignedby"];
                //NSString * cassignedto=[[JSONArray objectAtIndex:i] objectForKey:@"assignedto"];
                NSString * cassignedbyusername=[[JSONArray objectAtIndex:i] objectForKey:@"assignedbyusername"];
                NSString * cassignedtousername=[[JSONArray objectAtIndex:i] objectForKey:@"assignedtousername"];
                
                NSString * cassignedby=[MyClass returnstaffnamewithusername:cassignedbyusername firstorfullname:@"full"];
                NSString * cassignedto=[MyClass returnstaffnamewithusername:cassignedtousername firstorfullname:@"full"];
                
                NSString * cfollowupdatetime=[[JSONArray objectAtIndex:i] objectForKey:@"followupdatetime"];
                NSString * ctaskname=[[JSONArray objectAtIndex:i] objectForKey:@"taskname"];
                NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                NSString * cstatus=[[JSONArray objectAtIndex:i] objectForKey:@"status"];
                
                [AllOtherTasksArray addObject:[[TaskRecord alloc]initTaskRecordwithTaskkey:ctaskkey Createdatetime:ccreatedatetime Assignedby:cassignedby Assignedto:cassignedto AssignedbyUsername:cassignedbyusername AssignedtoUsername:cassignedtousername Followupdatetime:cfollowupdatetime Taskname:ctaskname Remarks:cremarks Status:cstatus Action:@""]];
            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
            
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        [TaskTable reloadData];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    
    return result;
}

-(BOOL) retrieveTaskToOthersRecordsWithStatus:(NSString *)taskstatus
{
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievetasktoothers&status=%@&username=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewtaskassignment"],taskstatus,globalvariables.username];

    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDate *date;
            result = TRUE;
            
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                JSONArray = jsonreturned[@"content"];
                
                TasksToOthersArray=[[NSMutableArray alloc]init];
                
                //loop through our jsonArray
                for (int i=0; i<JSONArray.count; i++) {
                    
                    
                    //Create our ClassRecord object
                    NSString * ctaskkey=[[JSONArray objectAtIndex:i] objectForKey:@"taskkey"];
                    
                    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"createdatetime"]];
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    NSString *ccreatedatetime=[df stringFromDate:date];
                    
                    
                    NSString * cassignedbyusername=[[JSONArray objectAtIndex:i] objectForKey:@"assignedbyusername"];
                    NSString * cassignedtousername=[[JSONArray objectAtIndex:i] objectForKey:@"assignedtousername"];
                    //NSString * cassignedby=[[JSONArray objectAtIndex:i] objectForKey:@"assignedby"];
                    //NSString * cassignedto=[[JSONArray objectAtIndex:i] objectForKey:@"assignedto"];
                    NSString * cassignedby=[MyClass returnstaffnamewithusername:cassignedbyusername firstorfullname:@"full"];
                    NSString * cassignedto=[MyClass returnstaffnamewithusername:cassignedtousername firstorfullname:@"full"];
                    
                    
                    NSString * cfollowupdatetime=[[JSONArray objectAtIndex:i] objectForKey:@"followupdatetime"];
                    NSString * ctaskname=[[JSONArray objectAtIndex:i] objectForKey:@"taskname"];
                    NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                    NSString * cstatus=[[JSONArray objectAtIndex:i] objectForKey:@"status"];
                    
                    [TasksToOthersArray addObject:[[TaskRecord alloc]initTaskRecordwithTaskkey:ctaskkey Createdatetime:ccreatedatetime Assignedby:cassignedby Assignedto:cassignedto AssignedbyUsername:cassignedbyusername AssignedtoUsername:cassignedtousername Followupdatetime:cfollowupdatetime Taskname:ctaskname Remarks:cremarks Status:cstatus Action:@""]];
                }
        }
    }];
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        NSDate *date;
        if (!error) {
            result = TRUE;
        
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            TasksToOthersArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                
                //Create our ClassRecord object
                NSString * ctaskkey=[[JSONArray objectAtIndex:i] objectForKey:@"taskkey"];
                
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"createdatetime"]];
                [df setDateFormat:@"dd-MMM-yyyy"];
                NSString *ccreatedatetime=[df stringFromDate:date];
                
                
                NSString * cassignedbyusername=[[JSONArray objectAtIndex:i] objectForKey:@"assignedbyusername"];
                NSString * cassignedtousername=[[JSONArray objectAtIndex:i] objectForKey:@"assignedtousername"];
                //NSString * cassignedby=[[JSONArray objectAtIndex:i] objectForKey:@"assignedby"];
                //NSString * cassignedto=[[JSONArray objectAtIndex:i] objectForKey:@"assignedto"];
                NSString * cassignedby=[MyClass returnstaffnamewithusername:cassignedbyusername firstorfullname:@"full"];
                NSString * cassignedto=[MyClass returnstaffnamewithusername:cassignedtousername firstorfullname:@"full"];
                
                
                NSString * cfollowupdatetime=[[JSONArray objectAtIndex:i] objectForKey:@"followupdatetime"];
                NSString * ctaskname=[[JSONArray objectAtIndex:i] objectForKey:@"taskname"];
                NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                NSString * cstatus=[[JSONArray objectAtIndex:i] objectForKey:@"status"];
                
                [TasksToOthersArray addObject:[[TaskRecord alloc]initTaskRecordwithTaskkey:ctaskkey Createdatetime:ccreatedatetime Assignedby:cassignedby Assignedto:cassignedto AssignedbyUsername:cassignedbyusername AssignedtoUsername:cassignedtousername Followupdatetime:cfollowupdatetime Taskname:ctaskname Remarks:cremarks Status:cstatus Action:@""]];
            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        [TaskTable reloadData];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    
    return result;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView== taskAddTable) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==TaskTable) {
        if (sctaskview.selectedSegmentIndex==0) {
            return MyTaskArray.count;
        }else if (sctaskview.selectedSegmentIndex==1){
            return TasksToOthersArray.count;
        }else{
            return AllOtherTasksArray.count;
        }
    }else if (tableView==RequestTable){
        return filteredStudentRequestArray.count;
    }else if (tableView==OwnerTable){
        return filteredStaffArray.count;
    }else if (tableView==AssigneeTable){
        if (tmpassignclasstype==0) {
            return filteredStaffArray.count;
        }else{
            return filteredGroupArray.count;
        }
    }else{
        if (section==0) {
            return 4;
        }else{
            return 1;
        }
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==TaskTable) {
        
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"taskcell";
        


        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (sctaskview.selectedSegmentIndex==0) {
            taskrecordobject=[MyTaskArray objectAtIndex:indexPath.row];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }else if (sctaskview.selectedSegmentIndex==1){
            taskrecordobject=[TasksToOthersArray objectAtIndex:indexPath.row];
            cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        }else if (sctaskview.selectedSegmentIndex==2){
            taskrecordobject=[AllOtherTasksArray objectAtIndex:indexPath.row];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
        }
        
        //configure cells
        cell.label1.text=[MyClass returndateformatwithdate:taskrecordobject.createdatetime];
        cell.label2.text=taskrecordobject.assignedby;
        cell.label6.text=taskrecordobject.assignedto;
        
        NSDate *date=[MyClass convertToNSDateWithDate:taskrecordobject.followupdatetime DateFormat:@"yyyy-MM-dd HH:mm:ss"];
        cell.label5.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:[MyClass convertToNSStringWithNSDate:date DateFormat:@"dd-MMM-yyyy HH:mm"]];
        cell.label3.text=taskrecordobject.taskname;
        cell.label4.text=taskrecordobject.remarks;
        
        
        if ([taskrecordobject.status isEqualToString:@"Open"]) {
            cell.button1.layer.opacity=0.3;
        }else{
            cell.button1.layer.opacity=1;
        }
        
        
        if(sctaskview.selectedSegmentIndex==2){
            if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).closeothertask) {
                [cell.button1 addTarget: self action:@selector(changetaskstatus:) forControlEvents: UIControlEventTouchUpInside];
                [cell.button1 setImage:[UIImage imageNamed:@"present_icon.png"] forState:UIControlStateNormal];
                cell.button1.userInteractionEnabled=TRUE;
                cell.button1.tag=indexPath.row;
            }else{
                [cell.button1 setImage:[UIImage imageNamed:@"done_gray_icon.png"] forState:UIControlStateNormal];
                cell.button1.userInteractionEnabled=FALSE;
            }
        }else{
            [cell.button1 addTarget: self action:@selector(changetaskstatus:) forControlEvents: UIControlEventTouchUpInside];
            [cell.button1 setImage:[UIImage imageNamed:@"present_icon.png"] forState:UIControlStateNormal];
            cell.button1.userInteractionEnabled=TRUE;
            cell.button1.tag=indexPath.row;
        }
        
        

        
        //alternative background color;
        if (indexPath.row % 2==0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        if([taskrecordobject.taskkey isEqualToString:selectedtaskkey]){
            cell.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:178.0/255.0 blue:103.0/255.0 alpha:1.0];
        }
        
        
        return cell;

    }else if (tableView==RequestTable) {
        
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"requestcell";;
        
        
        
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }


        studentrequestrecordobject=[filteredStudentRequestArray objectAtIndex:indexPath.row];
        
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        //configure cells
        Student *student=[MyClass returnstudentwithstudentkey:studentrequestrecordobject.classrecord.studentkey];
        [MyClass downloadImageWithImageview:cell.imageview3 gender:student.gender type:@"student" typekey:student.studentkey image:student.image async:YES];
        cell.imageview3.layer.cornerRadius=cell.imageview3.frame.size.width/2;
        cell.imageview3.layer.masksToBounds=YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
        singleTap.numberOfTapsRequired = 1;
        cell.imageview3.userInteractionEnabled = YES;
        [cell.imageview3 addGestureRecognizer:singleTap];
        cell.imageview3.tag=indexPath.row;
        
        cell.label1.text=[MyClass convertToNSStringWithNSDate:studentrequestrecordobject.request_time ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES];
        cell.label2.text=studentrequestrecordobject.studentfullname;
        
        if(studentrequestrecordobject.requestingdatetime){
            cell.label8.text = [MyClass convertToNSStringWithNSDate:studentrequestrecordobject.requestingdatetime ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES];
        }else{
            cell.label8.text = [MyClass returntitlewithtitle:@"TBD"];
        }
        cell.label13.text=[MyClass returnstaffnamewithusername:studentrequestrecordobject.request_for_instructor firstorfullname:@"full"];
        if (globalvariables.centerrecord.iparentshowclassroom) {
            cell.label13.text=[NSString stringWithFormat:@"%@ | %@",cell.label13.text,studentrequestrecordobject.request_for_classroom];
        }
        
        cell.label13.hidden=[studentrequestrecordobject.request_for_instructor isEqualToString:@""];
        
        if([studentrequestrecordobject.request_for_value isEqualToString:@"Makeup"]){
            [cell.imageview2 setImage:[UIImage imageNamed:@"makeup_icon.png"]];
        }else if ([studentrequestrecordobject.request_for_value isEqualToString:@"Absent"]){
            [cell.imageview2 setImage:[UIImage imageNamed:@"absent_icon.png"]];
            cell.label8.text=[MyClass convertDateFormatWithDate:[NSString stringWithFormat:@"%@ %@",studentrequestrecordobject.classrecord.startdate,studentrequestrecordobject.classrecord.classtime] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES];
        }else if ([studentrequestrecordobject.request_for_value isEqualToString:@"Present"]){
            [cell.imageview2 setImage:[UIImage imageNamed:@"present_icon.png"]];
        }else if ([studentrequestrecordobject.request_for_value isEqualToString:@""]){
            [cell.imageview2 setImage:[UIImage imageNamed:@"unknown_icon.png"]];
        }else if ([studentrequestrecordobject.request_for_value isEqualToString:@"Extend"]){
            [cell.imageview2 setImage:[UIImage imageNamed:@"extend_icon.png"]];
        }
        

        
        cell.label4.text =[MyClass returnLeaveNatureNameWithLeaveNatureListKey:studentrequestrecordobject.request_for_leavenaturelistkey];
        
        
        if([studentrequestrecordobject.request_status isEqualToString:@"Approved"]){
            cell.label5.textColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_background.png"]];
            
            cell.label10.text=[MyClass convertToNSStringWithNSDate:studentrequestrecordobject.actiontime ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES];
            cell.label10.hidden=NO;
            if([globalvariables.centerrecord.iparentleavemode isEqualToString:@"Auto approve"]){
                if(!studentrequestrecordobject.count_quota && [MyClass quotaCountedWithLeaveNatureListKey:studentrequestrecordobject.request_for_leavenaturelistkey attendance:studentrequestrecordobject.request_for_value] && ![studentrequestrecordobject.request_from_date isEqualToString:@""]){
                    cell.label5.text = [MyClass returntitlewithtitle:@"Exempted"];
                    cell.label9.text=studentrequestrecordobject.actionbyfullname;
                    cell.label9.hidden=NO;
                }else{
                    cell.label5.text = [MyClass returntitlewithtitle:@"Arranged"];
                    cell.label9.hidden=YES;
                }
                
            }else{
                if(!studentrequestrecordobject.count_quota && [MyClass quotaCountedWithLeaveNatureListKey:studentrequestrecordobject.request_for_leavenaturelistkey attendance:studentrequestrecordobject.request_for_value] && ![studentrequestrecordobject.request_from_date isEqualToString:@""]){
                    cell.label5.text = [MyClass returntitlewithtitle:@"Exempted"];
                }else{
                    cell.label5.text = [MyClass returntitlewithtitle:studentrequestrecordobject.request_status];
                }
                
                cell.label9.text=studentrequestrecordobject.actionbyfullname;
                cell.label9.hidden=NO;
            }
        }else if ([studentrequestrecordobject.request_status isEqualToString:@"Pending Center"]){
            cell.label5.text = [MyClass returntitlewithtitle:studentrequestrecordobject.request_status];
            cell.label5.textColor=[UIColor orangeColor];
            cell.label9.hidden=YES;
            cell.label10.hidden=YES;
        }else if ([studentrequestrecordobject.request_status isEqualToString:@"Pending Instructor"]){
            cell.label5.text = [MyClass returntitlewithtitle:studentrequestrecordobject.request_status];
            cell.label5.textColor=[UIColor purpleColor];
            cell.label9.hidden=YES;
            cell.label10.hidden=YES;
        }else if ([studentrequestrecordobject.request_status isEqualToString:@"Cancelled"]){
            cell.label5.text = [MyClass returntitlewithtitle:studentrequestrecordobject.request_status];
            cell.label5.textColor=[UIColor redColor];
            cell.label9.text=studentrequestrecordobject.actionbyfullname;
            cell.label9.hidden=NO;
            cell.label10.text=[MyClass convertToNSStringWithNSDate:studentrequestrecordobject.actiontime ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES];
            cell.label10.hidden=NO;
        }else if ([studentrequestrecordobject.request_status isEqualToString:@"Rejected"]){
            cell.label5.text = [MyClass returntitlewithtitle:studentrequestrecordobject.request_status];
            cell.label5.textColor=[UIColor redColor];
            cell.label9.text=studentrequestrecordobject.actionbyfullname;
            cell.label9.hidden=NO;
            cell.label10.text=[MyClass convertToNSStringWithNSDate:studentrequestrecordobject.actiontime ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES];
            cell.label10.hidden=NO;
        }else if ([studentrequestrecordobject.request_status isEqualToString:@"Overridden"]){
            cell.label5.text = [MyClass returntitlewithtitle:@"Rescheduled"];
            cell.label5.textColor=[UIColor orangeColor];
            cell.label9.text=studentrequestrecordobject.actionbyfullname;
            cell.label9.hidden=NO;
            cell.label10.text=[MyClass convertToNSStringWithNSDate:studentrequestrecordobject.actiontime ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES];
            cell.label10.hidden=NO;
        }
        
        
        
        
        cell.label6.text= [self returnrequestornamewithrequestname:studentrequestrecordobject.requestor_username studentkey:studentrequestrecordobject.classrecord.studentkey];
        cell.label6.hidden=[cell.label6.text isEqualToString:studentrequestrecordobject.requestor_username];
        
        ContactRecord *record=[self returncontactrecordwithstudentrequestobject:studentrequestrecordobject];
        if(!record){
            cell.stackview1.hidden=YES;
        }else{
            cell.label11.text=[MyClass returnLocalNumberWithContact:record.contact ISOCode:record.iso_code];
            [MyClass downloadImageWithImageview:cell.imageview4 gender:nil type:@"flag" typekey:record.iso_code image:@"Yes" async:YES];
            cell.stackview1.hidden=NO;
        }

        //cell.label11.hidden=[cell.label11.text isEqualToString:@""];
        cell.label7.text = studentrequestrecordobject.subjectfullname;
        
        cell.label12.hidden=[studentrequestrecordobject.request_from_instructor isEqualToString:@""];
        cell.label3.text = [MyClass returnyyyymmddhhmmdatetimewithdate:studentrequestrecordobject.request_from_date time:studentrequestrecordobject.request_from_time];
        cell.label12.text=[MyClass returnstaffnamewithusername:studentrequestrecordobject.request_from_instructor firstorfullname:@"full"];
        if (globalvariables.centerrecord.iparentshowclassroom) {
            cell.label12.text=[NSString stringWithFormat:@"%@ | %@",cell.label12.text,studentrequestrecordobject.request_from_classroom];
        }
        
        if([studentrequestrecordobject.request_from_value isEqualToString:@"Makeup"]){
            [cell.imageview1 setImage:[UIImage imageNamed:@"makeup_icon.png"]];
            if ([studentrequestrecordobject.request_from_date isEqualToString:@""]) {
                cell.label12.hidden=NO;
                cell.label12.text=[MyClass convertDateFormatWithDate:[NSString stringWithFormat:@"%@ %@",studentrequestrecordobject.classrecord.startdate,studentrequestrecordobject.classrecord.classtime] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES] ;
            }
        }else if ([studentrequestrecordobject.request_from_value isEqualToString:@"Absent"]){
            [cell.imageview1 setImage:[UIImage imageNamed:@"absent_icon.png"]];
        }else if ([studentrequestrecordobject.request_from_value isEqualToString:@"Present"]){
            [cell.imageview1 setImage:[UIImage imageNamed:@"present_icon.png"]];
        }else if ([studentrequestrecordobject.request_from_value isEqualToString:@""]){
            [cell.imageview1 setImage:[UIImage imageNamed:@"unknown_icon.png"]];
        }else if ([studentrequestrecordobject.request_from_value isEqualToString:@"Extend"]){
            [cell.imageview1 setImage:[UIImage imageNamed:@"extend_icon.png"]];
        }

        
        
        cell.button1.layer.cornerRadius=3;
        cell.button1.layer.masksToBounds=YES;
        cell.button1.tag=indexPath.row;
        cell.button2.layer.cornerRadius=3;
        cell.button2.layer.masksToBounds=YES;
        cell.button2.tag=indexPath.row;
        cell.button3.layer.cornerRadius=3;
        cell.button3.layer.masksToBounds=YES;
        cell.button3.tag=indexPath.row;
        cell.button4.layer.cornerRadius=3;
        cell.button4.layer.masksToBounds=YES;
        cell.button4.tag=indexPath.row;
        
        [cell.button1 addTarget:self action:@selector(approveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button2 addTarget:self action:@selector(rejectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button3 addTarget:self action:@selector(rescheduleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button4 addTarget:self action:@selector(exemptButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.button1 setTitle:[MyClass returntitlewithtitle:@"Approve"] forState:UIControlStateNormal];
        [cell.button2 setTitle:[MyClass returntitlewithtitle:@"Reject"] forState:UIControlStateNormal];
        [cell.button3 setTitle:[MyClass returntitlewithtitle:@"Reschedule"] forState:UIControlStateNormal];
        [cell.button4 setTitle:[MyClass returntitlewithtitle:@"Exempt"] forState:UIControlStateNormal];
        
        
        if(([studentrequestrecordobject.request_status isEqualToString:@"Pending Center"] ||[studentrequestrecordobject.request_status isEqualToString:@"Pending Instructor"]) && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).enablerequestaction){
            [cell.button1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"green_background.png"]]];
            [cell.button2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_background.png"]]];
            cell.button1.enabled=YES;
            cell.button2.enabled=YES;
            if([studentrequestrecordobject.request_for_value isEqualToString:@"Absent"]){
                cell.button3.enabled=NO;
                [cell.button3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"lightgray_background.png"]]];
            }else{
                cell.button3.enabled=YES;
                [cell.button3 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"orange_background.png"]]];
            }
            cell.button4.enabled=NO;
            [cell.button4 setBackgroundColor:[UIColor lightGrayColor]];
        }else{
            cell.button1.enabled=NO;
            cell.button2.enabled=NO;
            cell.button3.enabled=NO;
            
            [cell.button1 setBackgroundColor:[UIColor lightGrayColor]];
            [cell.button2 setBackgroundColor:[UIColor lightGrayColor]];
            [cell.button3 setBackgroundColor:[UIColor lightGrayColor]];
            
            if(studentrequestrecordobject.count_quota && [studentrequestrecordobject.request_status isEqualToString:@"Approved"] && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).enablerequestaction){
                cell.button4.enabled=YES;
                [cell.button4 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_background.png"]]];
            }else{
                cell.button4.enabled=NO;
                [cell.button4 setBackgroundColor:[UIColor lightGrayColor]];
            }
        }
        
        if([globalvariables.centerrecord.iparentleavemode isEqualToString:@"Request"]){
            cell.button1.hidden=NO;
            cell.button2.hidden=NO;
            cell.button3.hidden=NO;
        }else{
            cell.button1.hidden=YES;
            cell.button2.hidden=YES;
            cell.button3.hidden=YES;
        }
        
        
        
        //alternative background color;
        if (indexPath.row % 2==0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        
        return cell;
        
    }else if (tableView==OwnerTable) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(ownertablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        name.text=[MyClass returnstaffnamewithusername:((Staff *)[filteredStaffArray objectAtIndex:indexPath.row]).username firstorfullname:@"full"];
        selected.hidden=[tmpowner isEqualToString:((Staff *)[filteredStaffArray objectAtIndex:indexPath.row]).username]?NO:YES;
        
        return cell;
    }else if (tableView==AssigneeTable) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            //add textfield
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 200, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1200;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(assigneetablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1200];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        
        if (tmpassignclasstype==0) {
            name.text=[MyClass returnstaffnamewithusername:((Staff *)[filteredStaffArray objectAtIndex:indexPath.row]).username firstorfullname:@"full"];
            selected.hidden=![[self returnAssignedArray] containsObject:((Staff *)[filteredStaffArray objectAtIndex:indexPath.row]).username];
        }else{
            name.attributedText=[MyClass returngrouparraylabel:[[NSMutableArray alloc]initWithObjects:((GroupRecord *)[filteredGroupArray objectAtIndex:indexPath.row]).groupkey, nil] grouparray:allGroupArray option:@"groupkey"];
            selected.hidden=![[self returnAssignedArray] containsObject:((GroupRecord *)[filteredGroupArray objectAtIndex:indexPath.row]).groupkey];
        }
        
        return cell;

    }else{ // taskadd table
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
        [df setDateFormat:@"dd-MMM-yyyy"];
        
        //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                taskAddlabel= [[UILabel alloc]initWithFrame:CGRectMake(20, 9, 180, 21)];
                taskAddlabel.font=[UIFont systemFontOfSize:15];
                taskAddlabel.textColor=[UIColor blackColor];
                taskAddlabel.text=[MyClass returntitlewithtitle:@"Assigned By"];
                taskAddlabel.tag=301;
                [cell.contentView addSubview:taskAddlabel];
                
                taskAddAssignBylabel= [[UILabel alloc]initWithFrame:CGRectMake(110, 9, 180, 21)];
                taskAddAssignBylabel.font=[UIFont systemFontOfSize:15];
                taskAddAssignBylabel.textColor=[UIColor darkGrayColor];
                taskAddAssignBylabel.text=[MyClass returnstaffnamewithusername:tmpowner firstorfullname:@"full"];
                taskAddAssignBylabel.textAlignment=NSTextAlignmentRight;
                taskAddAssignBylabel.tag=301;
                [cell.contentView addSubview:taskAddAssignBylabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }else if (indexPath.row==1) {
                taskAddlabel= [[UILabel alloc]initWithFrame:CGRectMake(20, 9, 180, 21)];
                taskAddlabel.font=[UIFont systemFontOfSize:15];
                taskAddlabel.textColor=[UIColor blackColor];
                taskAddlabel.text=[MyClass returntitlewithtitle:@"Assigned To"];
                taskAddlabel.tag=301;
                [cell.contentView addSubview:taskAddlabel];
                
                taskAddAssignTolabel= [[UILabel alloc]initWithFrame:CGRectMake(110, 9, 180, 21)];
                taskAddAssignTolabel.font=[UIFont systemFontOfSize:15];
                taskAddAssignTolabel.textColor=[UIColor darkGrayColor];

                NSString *assigneetext;
                if ([tmpassignee isEqualToString:@""]) {
                    assigneetext=[MyClass returntitlewithtitle:@"Select"];
                }else{
                    assigneetext=[self returnAssigneeLabelWithUsernames:tmpassignee];
                }
                taskAddAssignTolabel.text=assigneetext;
                
                taskAddAssignTolabel.textAlignment=NSTextAlignmentRight;
                taskAddAssignTolabel.numberOfLines=0;
                [taskAddAssignTolabel sizeToFit];
                taskAddAssignTolabel.frame=CGRectMake(110, 9, 180, taskAddAssignTolabel.frame.size.height);
                
                
                taskAddAssignTolabel.tag=301;
                [cell.contentView addSubview:taskAddAssignTolabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            }else if (indexPath.row==2){
                taskAddlabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 9, 200, 21)];
                taskAddlabel.font=[UIFont systemFontOfSize:15];
                taskAddlabel.textColor=[UIColor blackColor];
                taskAddlabel.text=[MyClass returntitlewithtitle:@"Followup On"];
                taskAddlabel.tag=301;
                [cell.contentView addSubview:taskAddlabel];
                
                taskAddDateTimelabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 9, 200, 21)];
                taskAddDateTimelabel.font=[UIFont systemFontOfSize:15];
                taskAddDateTimelabel.textColor=[UIColor darkGrayColor];
                taskAddDateTimelabel.text=[tmptaskadddatetime isEqualToString:@""]?[MyClass returntitlewithtitle:@"Select"]:[MyClass returndateformatDDMMMYYYYHHMMwithdate:tmptaskadddatetime];
                taskAddDateTimelabel.textAlignment=NSTextAlignmentRight;
                taskAddDateTimelabel.tag=301;
                [cell.contentView addSubview:taskAddDateTimelabel];
                cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                
            }else if (indexPath.row==3) {
                if (showtaskdatetimepicker==YES) {

                    CalendarView *calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, 320, 200) Theme:0 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil  UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
                    [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[tmptaskadddatetime substringToIndex:11],nil] ScrollToDate:nil instructorselected:nil];
                    calendarview.delegate=self;

                    [cell.contentView addSubview:calendarview];
                    

                    hourPresetRow=(int)[hourPickerViewMenu indexOfObject:[[tmptaskadddatetime substringFromIndex:[tmptaskadddatetime length]-5] substringToIndex:2]];
                    minutePresetRow=(int)[minutePickerViewMenu indexOfObject:[tmptaskadddatetime substringFromIndex:[tmptaskadddatetime length]-2]];
                    
                    UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 200, 320, 162)];
                    myPicker.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.03];
                    [myPicker setDataSource:self];
                    [myPicker setDelegate:self];
                    myPicker.tag=801;
                    
                    [myPicker selectRow:hourPresetRow inComponent:0 animated:NO];
                    [myPicker selectRow:minutePresetRow inComponent:1 animated:NO];
                    
                    [myPicker setShowsSelectionIndicator:YES];
                    myPickerView=myPicker;
                    [cell.contentView addSubview:myPicker];
                    
                }
            }
        }else{
            taskAddTaskNametext = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, 260, 80)];
            taskAddTaskNametext.font=[UIFont systemFontOfSize:14];
            taskAddTaskNametext.textColor=[UIColor darkGrayColor];
            taskAddTaskNametext.delegate=self;
            taskAddTaskNametext.text=tmptaskaddtaskname;
            taskAddTaskNametext.tag=302;
            [cell.contentView addSubview:taskAddTaskNametext];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
}

-(NSString *) returnAssigneeLabelWithUsernames:(NSString *)usernames
{
    NSMutableArray *assigneedarray=[[NSMutableArray alloc]init];
    
    if (tmpassignclasstype==0) {
        NSArray *usernamearray=[[NSMutableArray alloc]init];
        usernamearray=[usernames componentsSeparatedByString:@","];
        for (int i=0; i<usernamearray.count; i++) {
            [assigneedarray addObject:[MyClass returnstaffnamewithusername:[usernamearray objectAtIndex:i] firstorfullname:@"full"]];
        }
        return [assigneedarray componentsJoinedByString:@" / "];
    }else{
        NSArray *groupkeyarray=[[NSMutableArray alloc]init];
        groupkeyarray=[usernames componentsSeparatedByString:@","];
        return [[MyClass returngrouparraylabel:[[NSMutableArray alloc]initWithArray:groupkeyarray] grouparray:allGroupArray option:@"groupkey"] string];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==taskAddTable) {
        if (indexPath.section==0) {
            if (indexPath.row==1){
                UILabel *taskAddAssignTolabel= [[UILabel alloc]initWithFrame:CGRectMake(110, 9, 180, 21)];
                taskAddAssignTolabel.font=[UIFont systemFontOfSize:15];
                NSString *assigneetext;
                if ([tmpassignee isEqualToString:@""]) {
                    assigneetext=[MyClass returntitlewithtitle:@"Select"];
                }else{
                    assigneetext=[self returnAssigneeLabelWithUsernames:tmpassignee];
                }
                taskAddAssignTolabel.text=assigneetext;
                taskAddAssignTolabel.numberOfLines=0;
                [taskAddAssignTolabel sizeToFit];
                return taskAddAssignTolabel.frame.size.height+18;
            }else if (indexPath.row==3){
                if (showtaskdatetimepicker) {
                    return 362;
                }else{
                    return 0;
                }
            }else{
                return cellheight;
            }
        }else{
            return 120;
        }
    }else if (tableView==OwnerTable){
        return 38;
    }else if (tableView==AssigneeTable){
        return 38;
    }else{
        return UITableViewAutomaticDimension;
    }
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return cellheight;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==taskAddTable) {
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Task and Request"];
        }else{
            return [MyClass returntitlewithtitle:@"Task Description"];
        }

    }else{
        return @"";
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

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==taskAddTable) {
        return 44;
    }
    return CGFLOAT_MIN;;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==taskAddTable) {
        if (indexPath.section==0 && indexPath.row==0) {
            //pickerview for assignto
            
            ownersearchbar.text=@"";
            filteredStaffArray=[[NSMutableArray alloc]initWithArray:allStaffArray];
            
            if (filteredStaffArray.count>0) {
                selectedItem=@"AssignBy";
                showtaskdatetimepicker=NO;
                [self showsidewindowwithwindow:@"OwnerTable"];
                
                if ([tmpowner isEqualToString:@""]) {
                    if ([MyClass returnStaffIndexWithStaffArray:allStaffArray username:globalvariables.username defaultzeroifnotfound:NO]>=0) {
                        tmpowner=globalvariables.username;
                    }else{
                        tmpowner=((Staff *)[filteredStaffArray objectAtIndex:0]).username;
                    }
                }
                
                //[self storeTaskAddTmpField];
                [taskAddTable reloadData];
                
                [self adjustTaskAddTableSize];
            }
            
        }else if (indexPath.section==0 && indexPath.row==1) {
            //pickerview for assignto
            
            assigneesearchbar.text=@"";
            if (tmpassignclasstype==0) {
                filteredStaffArray=[[NSMutableArray alloc]initWithArray:allStaffArray];
                
                if (filteredStaffArray.count>0) {
                    selectedItem=@"AssignTo";
                    showtaskdatetimepicker=NO;
                    [self showsidewindowwithwindow:@"AssigneeTable"];
                    
                    //[self storeTaskAddTmpField];
                    [taskAddTable reloadData];
                    
                    [self adjustTaskAddTableSize];
                }
            }else{

                filteredGroupArray=[[NSMutableArray alloc]initWithArray:allGroupArray];
                
                if (filteredGroupArray.count>0) {
                    selectedItem=@"AssignTo";
                    showtaskdatetimepicker=NO;
                    [self showsidewindowwithwindow:@"AssigneeTable"];
                    
                    
                    //[self storeTaskAddTmpField];
                    [taskAddTable reloadData];
                    
                    [self adjustTaskAddTableSize];
                }
            }
            
            
            
        }else if (indexPath.section==0 && indexPath.row==2) {
            //pickerview for date/time
            
            selectedItem=@"FollowupDateTime";
            if (showtaskdatetimepicker==YES) {
                showtaskdatetimepicker=NO;
            }else{
                showtaskdatetimepicker=YES;
            }
            [self showsidewindowwithwindow:@"none"];
            
            if ([tmptaskadddatetime isEqualToString:@""]) {
                tmptaskadddatetime=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy HH:mm"];
            }
            
            //[self storeTaskAddTmpField];
            [taskAddTable reloadData];
            [self adjustTaskAddTableSize];
        }
        
    }else if (tableView==TaskTable){
        if (sctaskview.selectedSegmentIndex==1) {
            TaskRecord *taskrecordObject=[[TaskRecord alloc]init];
            taskrecordObject=[TasksToOthersArray objectAtIndex:indexPath.row];
            
            df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date=[df dateFromString:taskrecordObject.followupdatetime];
            [df setDateFormat:@"dd-MMM-yyyy HH:mm"];
            
            tmptaskadddatetime=[df stringFromDate:date];
            tmptaskaddtaskname=taskrecordObject.taskname;
            tmptaskkey=taskrecordObject.taskkey;
            tmpassignee=taskrecordObject.assignedtousername;
            tmpowner=taskrecordObject.assignedbyusername;
            
            [self popuptaskdetailswindow:@"Edit"];
            //UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
            //CGRect rect=CGRectMake(cell.bounds.origin.x+500, cell.bounds.origin.y+3, 50, 30);
            //[myPopoverController presentPopoverFromRect:rect inView:cell.contentView permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
        }else{
            UIButton *button=[[UIButton alloc]init];
            button.tag=indexPath.row;
            [self changetaskstatus:button];
        }
    }else if (tableView==OwnerTable){
        if (![tmpowner isEqualToString:((Staff *)[filteredStaffArray objectAtIndex:indexPath.row]).username]) {
            tmpowner=((Staff *)[filteredStaffArray objectAtIndex:indexPath.row]).username;
            
            [OwnerTable reloadData];
            [taskAddTable reloadData];
        }
    }else if (tableView==AssigneeTable){
        if (tmpassignclasstype==0) {
            if (![[self returnAssignedArray] containsObject:((Staff *)[filteredStaffArray objectAtIndex:indexPath.row]).username]) {
                [self addAssignedArrayWithItem:((Staff *)[filteredStaffArray objectAtIndex:indexPath.row]).username];
            }else{
                [self removeAssignedArrayWithItem:((Staff *)[filteredStaffArray objectAtIndex:indexPath.row]).username];
            }
            [AssigneeTable reloadData];
            [taskAddTable reloadData];
        }else{
            if (![[self returnAssignedArray] containsObject:((GroupRecord *)[filteredGroupArray objectAtIndex:indexPath.row]).groupkey]) {
                [self addAssignedArrayWithItem:((GroupRecord *)[filteredGroupArray objectAtIndex:indexPath.row]).groupkey];
            }else{
                [self removeAssignedArrayWithItem:((GroupRecord *)[filteredGroupArray objectAtIndex:indexPath.row]).groupkey];
            }
            [AssigneeTable reloadData];
            [taskAddTable reloadData];
        }
    }
}

-(NSMutableArray *) returnAssignedArray
{
    if ([tmpassignee isEqualToString:@""]) {
        return [[NSMutableArray alloc]init];
    }else{
        return [[NSMutableArray alloc]initWithArray:[tmpassignee componentsSeparatedByString:@","]];
    }
}

-(void) removeAssignedArrayWithItem:(NSString *)item
{

    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:[tmpassignee componentsSeparatedByString:@","]];
    [array removeObject:item];
    tmpassignee=[array componentsJoinedByString:@","];
    
}

-(void) addAssignedArrayWithItem:(NSString *)item
{
    if ([tmpassignee isEqualToString:@""]) {
        tmpassignee=item;
    }else{
        NSMutableArray *array=[[NSMutableArray alloc]initWithArray:[tmpassignee componentsSeparatedByString:@","]];
        [array addObject:item];
        tmpassignee=[array componentsJoinedByString:@","];
    }
}


-(void)changetaskstatus:(UIButton *)sender
{
//    CGPoint point = [sender.superview convertPoint:CGPointZero toView:TaskTable];
//    NSIndexPath *indexPath =[TaskTable indexPathForRowAtPoint:point];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [TaskTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    if (sctaskview.selectedSegmentIndex==0) {
        taskrecordobject=[MyTaskArray objectAtIndex:indexPath.row];
    }else if (sctaskview.selectedSegmentIndex==1){
        taskrecordobject=[TasksToOthersArray objectAtIndex:indexPath.row];
    }else{
        taskrecordobject=[AllOtherTasksArray objectAtIndex:indexPath.row];
    }
    
    tmptaskkey=taskrecordobject.taskkey;
    
    if (sctaskview.selectedSegmentIndex==0) {
        /*if (sender.layer.opacity==1) {
            TaskRecord * tmptaskrecord=[[TaskRecord alloc]initTaskRecordwithTaskkey:tmptaskkey Createdatetime:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:taskrecordobject.createdatetime] Assignedby:nil Assignedto:nil AssignedbyUsername:taskrecordobject.assignedbyusername AssignedtoUsername:taskrecordobject.assignedtousername Followupdatetime:taskrecordobject.followupdatetime Taskname:taskrecordobject.taskname Remarks:taskrecordobject.remarks Status:@"Open" Action:@"Edit"];
            
            if (![self updateTaskWithTaskRecordArray:[[NSMutableArray alloc]initWithObjects:tmptaskrecord, nil]]) {
                [MyClass showconnectionlostdialogbox];
                //sender.layer.opacity=1;
                return;
            }else{
                [self retrieveMyTaskRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
            }
            
        }else{*/
            //pop up windows to enter remarks
            UIView *closemytaskview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
            closemytaskview.backgroundColor=[UIColor systemGroupedBackgroundColor];
            
            UIView *topbar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
            topbar.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
            [closemytaskview addSubview:topbar];
            
            //add toolbar
//            UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
//            toolbar.barStyle=UIBarStyleDefault;
//            toolbar.clipsToBounds=YES;
        

            
            
//            NSMutableArray *barItems=[[NSMutableArray alloc]init];
//            UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//            UIBarButtonItem *closeButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Close Task"] style:UIBarButtonItemStylePlain target:self action:@selector(doneclosemytask:)];
//        
//        UIBarButtonItem *reOpenButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Re-open Task"] style:UIBarButtonItemStylePlain target:self action:@selector(donereopentask:)];
//            
//            UIBarButtonItem *saveButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Save"] style:UIBarButtonItemStylePlain target:self action:@selector(doneupdatetask:)];
        
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, 33, 100, 20);
        [button setTitle:[MyClass returntitlewithtitle:@"Save"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(doneupdatetask:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.frame = CGRectMake(320-20-button.frame.size.width, 33, button.frame.size.width, 20);
        [closemytaskview addSubview:button];
        
        
        if ([taskrecordobject.status isEqualToString:@"Open"]) {
//            barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,saveButton, nil];
            UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(20, 33, 100, 20);
            [button setTitle:[MyClass returntitlewithtitle:@"Close Task"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(doneclosemytask:) forControlEvents:UIControlEventTouchUpInside];
            [button sizeToFit];
            button.frame = CGRectMake(20, 33, button.frame.size.width, 20);
            [closemytaskview addSubview:button];
            
        }else{
//            barItems = [[NSMutableArray alloc]initWithObjects:reOpenButton,flexSpace,saveButton, nil];
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(20, 33, 100, 20);
            [button setTitle:[MyClass returntitlewithtitle:@"Re-open Task"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(donereopentask:) forControlEvents:UIControlEventTouchUpInside];
            [button sizeToFit];
            button.frame = CGRectMake(20, 33, button.frame.size.width, 20);
            [closemytaskview addSubview:button];
        }
            
            
//            [toolbar setItems:barItems];
//            [closemytaskview addSubview:toolbar];
            
            //add remarksfield
            UILabel *mytaskremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 48+30, 300, 21)];
            mytaskremarkslabel.font=[UIFont systemFontOfSize:13];
            mytaskremarkslabel.textColor=[UIColor darkGrayColor];
            mytaskremarkslabel.text=[MyClass returntitlewithtitle:@"Please enter the update"];
            mytaskremarkslabel.tag=301;
            [closemytaskview addSubview:mytaskremarkslabel];
            
            UIView *backgroundview=[[UIView alloc]initWithFrame:CGRectMake(0, 20+44+44, 320, 200)];
            backgroundview.backgroundColor=[UIColor whiteColor];
            backgroundview.layer.borderColor=[UIColor lightGrayColor].CGColor;
            backgroundview.layer.borderWidth=0.3;
            [closemytaskview addSubview:backgroundview];
            
            closemytaskupdatetext = [[UITextView alloc]initWithFrame:CGRectMake(20, 20+44+44+1, 280, 200-3)];
            closemytaskupdatetext.font=[UIFont systemFontOfSize:14];
            closemytaskupdatetext.textColor=[UIColor darkGrayColor];
            closemytaskupdatetext.delegate=self;
            closemytaskupdatetext.text=taskrecordobject.remarks;
            closemytaskupdatetext.tag=302;
            [closemytaskview addSubview:closemytaskupdatetext];
            
            
            taskdetailsviewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
            taskdetailsviewcontroller.view=closemytaskview;
            taskdetailsviewcontroller.preferredContentSize=CGSizeMake(320, self.view.frame.size.height);
            
            
            [self startsidewindowanimationwithwidth:320];
            sideWindowType=11;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                taskdetailsviewcontroller.view.frame=self->sidewindowview.bounds;
                [self->sidewindowview addSubview:taskdetailsviewcontroller.view];
                [self addChildViewController:taskdetailsviewcontroller];
                [taskdetailsviewcontroller didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });
//        }

    }else if (sctaskview.selectedSegmentIndex==1){
        TaskRecord * tmptaskrecord=[[TaskRecord alloc]initTaskRecordwithTaskkey:tmptaskkey Createdatetime:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:taskrecordobject.createdatetime] Assignedby:nil Assignedto:nil AssignedbyUsername:taskrecordobject.assignedbyusername AssignedtoUsername:taskrecordobject.assignedtousername Followupdatetime:taskrecordobject.followupdatetime Taskname:taskrecordobject.taskname Remarks:taskrecordobject.remarks Status:sender.layer.opacity==1?@"Open":@"Closed" Action:@"Edit"];
        
        if (![self updateTaskWithTaskRecordArray:[[NSMutableArray alloc]initWithObjects:tmptaskrecord, nil]]) {
            [MyClass showconnectionlostdialogbox];
            return;
        }else{
            [self retrieveTaskToOthersRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
        }
    }else{
        if (![taskrecordobject.status isEqualToString:@"Closed"]) {
            //pop up windows to enter remarks
            UIView *closemytaskview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.bounds.size.height)];
            closemytaskview.backgroundColor=[UIColor systemGroupedBackgroundColor];
            
            UIView *topbar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
            topbar.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
            [closemytaskview addSubview:topbar];
            
            //add toolbar
            UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
            toolbar.barStyle=UIBarStyleDefault;
            toolbar.clipsToBounds=YES;
            
            
//            NSMutableArray *barItems=[[NSMutableArray alloc]init];
//            UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//            UIBarButtonItem *closeButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Close Task"] style:UIBarButtonItemStylePlain target:self action:@selector(doneclosemytask:)];
//            UIBarButtonItem *reOpenButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Re-open Task"] style:UIBarButtonItemStylePlain target:self action:@selector(donereopentask:)];
//                
//            UIBarButtonItem *saveButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Save"] style:UIBarButtonItemStylePlain target:self action:@selector(doneupdatetask:)];
            
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(20, 33, 100, 20);
            [button setTitle:[MyClass returntitlewithtitle:@"Save"] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(doneupdatetask:) forControlEvents:UIControlEventTouchUpInside];
            [button sizeToFit];
            button.frame = CGRectMake(320-20-button.frame.size.width, 33, button.frame.size.width, 20);
            [closemytaskview addSubview:button];
            
            
            
            if ([taskrecordobject.status isEqualToString:@"Open"]) {
//                barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,saveButton, nil];
                
                UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
                button.frame = CGRectMake(20, 33, 100, 20);
                [button setTitle:[MyClass returntitlewithtitle:@"Close Task"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(doneclosemytask:) forControlEvents:UIControlEventTouchUpInside];
                [button sizeToFit];
                button.frame = CGRectMake(20, 33, button.frame.size.width, 20);
                [closemytaskview addSubview:button];
            }else{
//                barItems = [[NSMutableArray alloc]initWithObjects:reOpenButton,flexSpace,saveButton, nil];
                
                
                UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
                button.frame = CGRectMake(20, 33, 100, 20);
                [button setTitle:[MyClass returntitlewithtitle:@"Re-open Task"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(donereopentask:) forControlEvents:UIControlEventTouchUpInside];
                [button sizeToFit];
                button.frame = CGRectMake(20, 33, button.frame.size.width, 20);
                [closemytaskview addSubview:button];
                
            }
            
//            [toolbar setItems:barItems];
//            [closemytaskview addSubview:toolbar];
            
            //add remarksfield
            UILabel *mytaskremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 48+30, 300, 21)];
            mytaskremarkslabel.font=[UIFont systemFontOfSize:13];
            mytaskremarkslabel.textColor=[UIColor darkGrayColor];
            mytaskremarkslabel.text=[MyClass returntitlewithtitle:@"Please enter the update"];
            mytaskremarkslabel.tag=301;
            [closemytaskview addSubview:mytaskremarkslabel];
            
            UIView *backgroundview=[[UIView alloc]initWithFrame:CGRectMake(0, 20+44+44, 320, 200)];
            backgroundview.backgroundColor=[UIColor whiteColor];
            backgroundview.layer.borderColor=[UIColor lightGrayColor].CGColor;
            backgroundview.layer.borderWidth=0.3;
            [closemytaskview addSubview:backgroundview];
            
            closemytaskupdatetext = [[UITextView alloc]initWithFrame:CGRectMake(20, 20+44+44+1, 280, 200-3)];
            closemytaskupdatetext.font=[UIFont systemFontOfSize:14];
            closemytaskupdatetext.textColor=[UIColor darkGrayColor];
            closemytaskupdatetext.delegate=self;
            closemytaskupdatetext.text=taskrecordobject.remarks;
            closemytaskupdatetext.tag=302;
            [closemytaskview addSubview:closemytaskupdatetext];
            
            
            taskdetailsviewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
            taskdetailsviewcontroller.view=closemytaskview;
            taskdetailsviewcontroller.preferredContentSize=CGSizeMake(320, self.view.frame.size.height);
            
            
            [self startsidewindowanimationwithwidth:320];
            sideWindowType=11;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                taskdetailsviewcontroller.view.frame=self->sidewindowview.bounds;
                [self->sidewindowview addSubview:taskdetailsviewcontroller.view];
                [self addChildViewController:taskdetailsviewcontroller];
                [taskdetailsviewcontroller didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });
        }
    }
}

-(void)doneclosemytask:(id)sender
{
    [self.view endEditing:YES];
    if (![closemytaskupdatetext.text isEqualToString:@""]) {
        //TaskRecord *taskrecordobject=[MyTaskArray objectAtIndex:tmptaskkey];
        
        
        TaskRecord * tmptaskrecord=[[TaskRecord alloc]initTaskRecordwithTaskkey:tmptaskkey Createdatetime:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:taskrecordobject.createdatetime] Assignedby:nil Assignedto:nil AssignedbyUsername:taskrecordobject.assignedbyusername AssignedtoUsername:taskrecordobject.assignedtousername Followupdatetime:taskrecordobject.followupdatetime Taskname:taskrecordobject.taskname Remarks:closemytaskupdatetext.text Status:@"Closed" Action:@"Edit"];
        
        if (![self updateTaskWithTaskRecordArray:[[NSMutableArray alloc]initWithObjects:tmptaskrecord, nil]]) {
            [MyClass showconnectionlostdialogbox];
        }else{
            //[myCloseTaskPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            if (sctaskview.selectedSegmentIndex==0) {
                [self retrieveMyTaskRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
            }else{
                [self retrieveAllOtherTaskRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
            }
            [self closesidewindow];
        }
        
        
    }else{
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Close Task"] message:[MyClass returntitlewithtitle:@"Please provide update to close the task"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        //[self presentViewController:erroralert animated:YES completion:nil];
        [MyClass presentViewController:erroralert View:self];
    }
}

-(void)doneupdatetask:(id)sender
{
    [self.view endEditing:YES];
    
    TaskRecord * tmptaskrecord=[[TaskRecord alloc]initTaskRecordwithTaskkey:tmptaskkey Createdatetime:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:taskrecordobject.createdatetime] Assignedby:nil Assignedto:nil AssignedbyUsername:taskrecordobject.assignedbyusername AssignedtoUsername:taskrecordobject.assignedtousername Followupdatetime:taskrecordobject.followupdatetime Taskname:taskrecordobject.taskname Remarks:closemytaskupdatetext.text Status:taskrecordobject.status Action:@"Edit"];
    
    if (![self updateTaskWithTaskRecordArray:[[NSMutableArray alloc]initWithObjects:tmptaskrecord, nil]]) {
        [MyClass showconnectionlostdialogbox];
    }else{
        //[myCloseTaskPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        if (sctaskview.selectedSegmentIndex==0) {
            [self retrieveMyTaskRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
        }else{
            [self retrieveAllOtherTaskRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
        }
        [self closesidewindow];
    }
}

-(void)donereopentask:(id)sender
{
    [self.view endEditing:YES];
    
    TaskRecord * tmptaskrecord=[[TaskRecord alloc]initTaskRecordwithTaskkey:tmptaskkey Createdatetime:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:taskrecordobject.createdatetime] Assignedby:nil Assignedto:nil AssignedbyUsername:taskrecordobject.assignedbyusername AssignedtoUsername:taskrecordobject.assignedtousername Followupdatetime:taskrecordobject.followupdatetime Taskname:taskrecordobject.taskname Remarks:closemytaskupdatetext.text Status:@"Open" Action:@"Edit"];
    
    if (![self updateTaskWithTaskRecordArray:[[NSMutableArray alloc]initWithObjects:tmptaskrecord, nil]]) {
        [MyClass showconnectionlostdialogbox];
    }else{
        //[myCloseTaskPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        if (sctaskview.selectedSegmentIndex==0) {
            [self retrieveMyTaskRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
        }else{
            [self retrieveAllOtherTaskRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
        }
        [self closesidewindow];
    }
}


- (void)selecttaskview:(UISegmentedControl *)sender {
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    //TaskTable=[[UITableView alloc]init];
    if (sctaskview.selectedSegmentIndex==0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self retrieveMyTaskRecordsWithStatus:@"Open"]) {
                //TaskTable.hidden=NO;
                //AllOtherTaskTable.hidden=YES;
                self->lasttaskindex=0;
                self->scstatus.selectedSegmentIndex=1;
                self->laststatusindex=1;
            }else{
                sender.selectedSegmentIndex=self->lasttaskindex;
            }
        });

    }else if(sctaskview.selectedSegmentIndex==1) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self retrieveTaskToOthersRecordsWithStatus:@"Open"]) {
                //TaskTable.hidden=NO;
                //AllOtherTaskTable.hidden=YES;
                self->lasttaskindex=1;
                self->scstatus.selectedSegmentIndex=1;
                self->laststatusindex=1;
            }else{
                sender.selectedSegmentIndex=self->lasttaskindex;
            }
        });

    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self retrieveAllOtherTaskRecordsWithStatus:@"Open"]) {
                //TaskTable.hidden=YES;
                //AllOtherTaskTable.hidden=NO;
                self->lasttaskindex=2;
                self->scstatus.selectedSegmentIndex=1;
                self->laststatusindex=1;
            }else{
                sender.selectedSegmentIndex=self->lasttaskindex;
            }
        });
    }
}

- (IBAction)selectstatus:(UISegmentedControl *)sender {
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    if (sctaskview.selectedSegmentIndex==0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self retrieveMyTaskRecordsWithStatus:[self->statusarray objectAtIndex:[scstatus selectedSegmentIndex]]]) {
                self->laststatusindex=sender.selectedSegmentIndex;
            }else{
                sender.selectedSegmentIndex=self->laststatusindex;
            }
        });
    }else if (sctaskview.selectedSegmentIndex==1){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self retrieveTaskToOthersRecordsWithStatus:[self->statusarray objectAtIndex:[scstatus selectedSegmentIndex]]]) {
                self->laststatusindex=sender.selectedSegmentIndex;
            }else{
                sender.selectedSegmentIndex=self->laststatusindex;
            }
        });
        
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ( [self retrieveAllOtherTaskRecordsWithStatus:[self->statusarray objectAtIndex:[scstatus selectedSegmentIndex]]]) {
                self->laststatusindex=sender.selectedSegmentIndex;
            }else{
                sender.selectedSegmentIndex=self->laststatusindex;
            }
        });
    }
}

- (IBAction)assignedtaskbuttonpressed:(id)sender {
    
    [self popuptaskdetailswindow:@"Add"];
}

- (IBAction)menubutton:(id)sender {
    
    [self.mainSlideMenu openLeftMenu];
}

- (IBAction)selecttype:(UISegmentedControl *)sender {
    [search_text resignFirstResponder];
    search_text.text=@"";
    if (sender.selectedSegmentIndex==0) {
        taskview.hidden=NO;
        sctaskview.hidden=NO;
        scstatus.hidden=NO;
        assigntaskbutton.hidden=NO;
        
        requestview.hidden=YES;
        screquestor.hidden=YES;
        screqueststatus.hidden=YES;
        search_text.hidden=YES;
        
    }else{
        taskview.hidden=YES;
        sctaskview.hidden=YES;
        scstatus.hidden=YES;
        assigntaskbutton.hidden=YES;
        
        requestview.hidden=NO;
        screquestor.hidden=NO;
        screqueststatus.hidden=NO;
        search_text.hidden=NO;
    }
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(sender.selectedSegmentIndex==0){
            [self retrieveTaskRecord];
        }else{
            [self retrieveStudentRequest];
        }
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

- (IBAction)selectrequestor:(id)sender {
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self returnfilterstudentrequestarray];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

- (IBAction)selectrequeststatus:(id)sender {
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self returnfilterstudentrequestarray];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

-(void) popuptaskdetailswindow:(NSString *)TaskMode
{
    allStaffArray=[[NSMutableArray alloc]initWithArray:[globalvariables.stafflistarray allValues]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@ and self.status = %@ and self.role !=%@",globalvariables.centerrecord.centerkey,@"Yes",@"System"];
    allStaffArray=[[NSMutableArray alloc]initWithArray:[allStaffArray filteredArrayUsingPredicate:predicate]];
    filteredStaffArray=[[NSMutableArray alloc]initWithArray:allStaffArray];
    allGroupArray=[MyClass returnStaffGroupArrayIncludeAll:YES];
    filteredGroupArray=[[NSMutableArray alloc]initWithArray:allGroupArray];
    
    
    if ([TaskMode isEqualToString:@"Add"]) {
        //initialize fields
        if ([MyClass returnStaffIndexWithStaffArray:allStaffArray username:globalvariables.username defaultzeroifnotfound:NO]>=0) {
            tmpowner=globalvariables.username;
        }else{
            tmpowner=((Staff *)[filteredStaffArray objectAtIndex:0]).username;
        }
        //tmpassignbyusername=globalvariables.username;
        tmpassignee=@"";
        tmptaskadddatetime=@"";
        tmptaskaddtaskname=@"";
    }
    tmpassignclasstype=0;
    

    
    //Add table
    showtaskdatetimepicker=FALSE;
    taskAddTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    taskAddTable.dataSource=self;
    taskAddTable.delegate=self;
    [taskAddTable reloadData];
    [taskAddTable setFrame:CGRectMake(0, 44+20, 320, self.view.bounds.size.height-44-20)];
    
    UIView *taskaddview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1000, self.view.bounds.size.height)];
    
    [taskaddview addSubview:taskAddTable];
    
    UIView *topbar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 1000, 20)];
    topbar.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    [taskaddview addSubview:topbar];
    
    //add toolbar
    UIToolbar *taskAddToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
    taskAddToolbar.clipsToBounds=YES;
    taskAddToolbar.barStyle=UIBarStyleDefault;
    
//    NSMutableArray *barItems;
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 100, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"Save"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(donetask:) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(320-20-button.frame.size.width, 33, button.frame.size.width, 20);
    [taskaddview addSubview:button];
    
    
    
    if ([TaskMode isEqualToString:@"Add"]) {
        donebuttonmode=@"Add";
//        barItems=[[NSMutableArray alloc]init];
//        UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Save"] style:UIBarButtonItemStylePlain target:self action:@selector(donetask:)];
//        barItems = [[NSMutableArray alloc]initWithObjects:flexSpace,doneButton, nil];
//        
//        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, 33, 100, 20);
        [button setTitle:[MyClass returntitlewithtitle:@"Save"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(donetask:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.frame = CGRectMake(320-20-button.frame.size.width, 33, button.frame.size.width, 20);
        [taskaddview addSubview:button];
        
        
    }else{
        donebuttonmode=@"Edit";
//        barItems=[[NSMutableArray alloc]init];
//        UIBarButtonItem *deleteButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deletetask:)];
//        UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Save"] style:UIBarButtonItemStylePlain target:self action:@selector(donetask:)];
//        barItems = [[NSMutableArray alloc]initWithObjects:deleteButton,flexSpace,doneButton, nil];
        
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(20, 33, 100, 20);
        [button setTitle:[MyClass returntitlewithtitle:@"Delete"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(deletetask:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.frame = CGRectMake(20, 33, button.frame.size.width, 20);
        [taskaddview addSubview:button];
        
        
    }
    
//    [taskAddToolbar setItems:barItems];
//    [taskaddview addSubview:taskAddToolbar];
    


    
    taskdetailsviewcontroller=[[UIViewController alloc]init];
    taskdetailsviewcontroller.view=taskaddview;
    taskdetailsviewcontroller.preferredContentSize=CGSizeMake(320, self.view.bounds.size.height);
    
    [self createsidetables];
    
    [self startsidewindowanimationwithwidth:320];
    sideWindowType=11;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        taskdetailsviewcontroller.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:taskdetailsviewcontroller.view];
        [self addChildViewController:taskdetailsviewcontroller];
        [taskdetailsviewcontroller didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
    
    
}


-(void) adjustTaskAddTableSize
{
    float tableheight;
    float tablewidth;
    
    if(sideWindowType==11){
        tableheight=maxPopupHeight-keyboardheight;
        
        
        if (showOwnTable) {
            tablewidth=popoverwidth+ownertablewidth;
        }else if (showAssigneeTable){
            tablewidth=popoverwidth+assigneetablewidth;
        }else{
            tablewidth=popoverwidth;
        }
        
        [taskAddTable setFrame:CGRectMake(0, 44+20, popoverwidth, tableheight-44-20)];
        if (taskdetailsviewcontroller.preferredContentSize.width!=tablewidth) {
            [self adjustpresentingviewwidthwithwidth:tablewidth];
        }
        
        taskdetailsviewcontroller.preferredContentSize=CGSizeMake(tablewidth, tableheight);
        
        
        if (showOwnTable){
            [OwnerTable setFrame:CGRectMake(0, 44+20+84, ownertablewidth, self.view.frame.size.height-44-20-84)];
            OwnerTableMasterView.hidden=NO;
            AssigneeTableMasterView.hidden=YES;
        }else if (showAssigneeTable){
            [AssigneeTable setFrame:CGRectMake(0, 64+44+35+42, assigneetablewidth, self.view.frame.size.height-64-44-35-42)];
            OwnerTableMasterView.hidden=YES;
            AssigneeTableMasterView.hidden=NO;
        }else{
            OwnerTableMasterView.hidden=YES;
            AssigneeTableMasterView.hidden=YES;
        }
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    if([selectedItem isEqualToString:@"FollowupDateTime"]){
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if([selectedItem isEqualToString:@"FollowupDateTime"]){
        if (component==0){
            return [hourPickerViewMenu count];
        }else{
            return [minutePickerViewMenu count];
        }
    }
    return 0;
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
    
    
    if([selectedItem isEqualToString:@"FollowupDateTime"]){
        if (component==0){
            tView.text= [hourPickerViewMenu objectAtIndex:row];
        }else{
            tView.text= [minutePickerViewMenu objectAtIndex:row];
        }
    }
    return tView;
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if([selectedItem isEqualToString:@"FollowupDateTime"]){
        return 40;
    }else{
        return 300;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([selectedItem isEqualToString:@"FollowupDateTime"]){
        if (![tmptaskadddatetime isEqualToString:[NSString stringWithFormat:@"%@ %@:%@",[tmptaskadddatetime substringToIndex:11],[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]]]) {
            
            tmptaskadddatetime=[NSString stringWithFormat:@"%@ %@:%@",[tmptaskadddatetime substringToIndex:11],[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];

            //[self storeTaskAddTmpField];
            [taskAddTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self adjustTaskAddTableSize];
            
        }
    }
}



-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if(textView.tag!=-1){
        if (keyboardheight>0) {
            if (textView==taskAddTaskNametext) {
                [self adjustTaskAddTableSize];
                
                CGPoint point = [textView.superview convertPoint:CGPointZero toView:taskAddTable];
                NSIndexPath *indexpath =[taskAddTable indexPathForRowAtPoint:point];
                
                CGRect rectInTableView = [taskAddTable rectForRowAtIndexPath:indexpath];
                CGFloat yoffset=rectInTableView.origin.y+rectInTableView.size.height-taskAddTable.frame.size.height;
                if(yoffset>0){
                    [taskAddTable setContentOffset:CGPointMake(0, yoffset) animated:YES];
                }
            }
        }
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==taskAddTaskNametext) {
        tmptaskaddtaskname=textView.text;
    }
}

-(void) donetask:(id)sender
{
    [self.view endEditing:YES];
    
    TaskRecord *tmptaskrecord;
    NSMutableArray *tmptaskrecordarray=[[NSMutableArray alloc]init];
    
    [self.view endEditing:YES];
    
    if ([tmptaskaddtaskname isEqualToString:@""] || [tmpassignee isEqualToString:@""] || [tmptaskadddatetime isEqualToString:@""]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Task Assignment"] message:[MyClass returntitlewithtitle:@"Missing Input"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else{
        //update to mysql
        df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
        [df setDateFormat:@"dd-MMM-yyyy HH:mm"];
        NSDate *date=[df dateFromString:tmptaskadddatetime];
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        //NSString *strURL;
        if (tmpassignclasstype==0) {
            if ([donebuttonmode isEqualToString:@"Add"]) {
                
                //tmptaskrecord=[[TaskRecord alloc]initTaskRecordwithTaskkey:@"" Createdatetime:[df stringFromDate:[NSDate date]] Assignedby:nil Assignedto:nil AssignedbyUsername:tmpowner AssignedtoUsername:tmpassignee Followupdatetime:[df stringFromDate:date] Taskname:taskAddTaskNametext.text Remarks:@"" Status:@"Open" Action:@"Add"];
                
                groupMemberArray=[[NSMutableArray alloc]initWithArray:[tmpassignee componentsSeparatedByString:@","]];
                for (long i=0; i<groupMemberArray.count; i++) {
                    tmptaskrecord=[[TaskRecord alloc]initTaskRecordwithTaskkey:@"" Createdatetime:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm"] Assignedby:nil Assignedto:nil AssignedbyUsername:tmpowner AssignedtoUsername:[groupMemberArray objectAtIndex:i] Followupdatetime:[df stringFromDate:date] Taskname:taskAddTaskNametext.text Remarks:@"" Status:@"Open" Action:@"Add"];
                    [tmptaskrecordarray addObject:tmptaskrecord];
                }
                
                if (![self updateTaskWithTaskRecordArray:tmptaskrecordarray]) {
                    [MyClass showconnectionlostdialogbox];
                    return;
                }

                
            }else{
                
                groupMemberArray=[[NSMutableArray alloc]initWithArray:[tmpassignee componentsSeparatedByString:@","]];
                for (long i=0; i<groupMemberArray.count; i++) {
                    tmptaskrecord=[[TaskRecord alloc]initTaskRecordwithTaskkey:@"" Createdatetime:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm"] Assignedby:nil Assignedto:nil AssignedbyUsername:tmpowner AssignedtoUsername:[groupMemberArray objectAtIndex:i] Followupdatetime:[df stringFromDate:date] Taskname:taskAddTaskNametext.text Remarks:@"" Status:@"Open" Action:@"Add"];
                    [tmptaskrecordarray addObject:tmptaskrecord];
                }
                
                if (tmptaskkey) {
                    //delete previous one
                    tmptaskrecord=[[TaskRecord alloc]initTaskRecordwithTaskkey:tmptaskkey Createdatetime:@"" Assignedby:nil Assignedto:nil AssignedbyUsername:@"" AssignedtoUsername:@"" Followupdatetime:@"" Taskname:@"" Remarks:@"" Status:@"Open" Action:@"Delete"];
                    [tmptaskrecordarray addObject:tmptaskrecord];
                }
                
                if (![self updateTaskWithTaskRecordArray:tmptaskrecordarray]) {
                    [MyClass showconnectionlostdialogbox];
                    return;
                }
                
            }

        }else{
            /*
            if (![self retrievegroupmember:tmpassignee]) {
                return;
            }*/
            
            //add new task
            //for (long i=0; i<groupMemberArray.count; i++) {
                //if (![[groupMemberArray objectAtIndex:i] isEqualToString:tmpowner]) {
                    tmptaskrecord=[[TaskRecord alloc]initTaskRecordwithTaskkey:@"" Createdatetime:[df stringFromDate:[NSDate date]] Assignedby:nil Assignedto:nil AssignedbyUsername:tmpowner AssignedtoUsername:tmpassignee Followupdatetime:[df stringFromDate:date] Taskname:taskAddTaskNametext.text Remarks:@"" Status:@"Open" Action:@"Add"];
                    [tmptaskrecordarray addObject:tmptaskrecord];
                //}
            //}
            
            if ([donebuttonmode isEqualToString:@"Edit"] && tmptaskkey) {
                //delete previous one
                tmptaskrecord=[[TaskRecord alloc]initTaskRecordwithTaskkey:tmptaskkey Createdatetime:@"" Assignedby:nil Assignedto:nil AssignedbyUsername:@"" AssignedtoUsername:@"" Followupdatetime:@"" Taskname:@"" Remarks:@"" Status:@"Open" Action:@"Delete"];
                [tmptaskrecordarray addObject:tmptaskrecord];
            }
            
            if (![self updateTaskWithTaskRecordArray:tmptaskrecordarray]) {
                [MyClass showconnectionlostdialogbox];
                return;
            }
        }
        [self closesidewindow];
        //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];

        UIAlertController *completealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Task Assignment"] message:[donebuttonmode isEqualToString:@"Add"]?[MyClass returntitlewithtitle:@"Task Created"]:[MyClass returntitlewithtitle:@"Task Updated"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [completealert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [completealert addAction:OKAction];
        //[self presentViewController:completealert animated:YES completion:nil];
        [MyClass presentViewController:completealert View:self];
        
        if (sctaskview.selectedSegmentIndex==0) {
            [self retrieveMyTaskRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
        }else{
            [self retrieveTaskToOthersRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
        }
    }
}

-(void) deletetask:(id)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Task"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the task?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        TaskRecord *tmptaskrecord=[[TaskRecord alloc]initTaskRecordwithTaskkey:tmptaskkey Createdatetime:@"" Assignedby:nil Assignedto:nil AssignedbyUsername:@"" AssignedtoUsername:@"" Followupdatetime:@"" Taskname:@"" Remarks:@"" Status:@"Open" Action:@"Delete"];
        
        NSMutableArray *tmptaskrecordarray=[[NSMutableArray alloc]initWithObjects:tmptaskrecord, nil];
        
        if (![self updateTaskWithTaskRecordArray:tmptaskrecordarray]) {
            [MyClass showconnectionlostdialogbox];
        }else{
            //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
            [self closesidewindow];
            if (sctaskview.selectedSegmentIndex==0) {
                [self retrieveMyTaskRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
            }else{
                [self retrieveTaskToOthersRecordsWithStatus:[statusarray objectAtIndex:[scstatus selectedSegmentIndex]]];
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

-(void)selectassigntotype:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex==0) {
        tmpassignclasstype=0;
        ownersearchbar.text=@"";
        filteredStaffArray=[[NSMutableArray alloc]initWithArray:allStaffArray];
        //tmpassignee=((Staff *)[filteredStaffArray firstObject]).username;
    }else{
        tmpassignclasstype=1;
        assigneesearchbar.text=@"";
        filteredGroupArray=[[NSMutableArray alloc]initWithArray:allGroupArray];
        //tmpassignee=((GroupRecord *)[allGroupArray objectAtIndex:0]).groupname;
    }
    tmpassignee=@"";
    [AssigneeTable reloadData];
    [taskAddTable reloadData];
}


-(BOOL) retrievegroupmember:(NSString *)groupkeys
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievegroupmember2&groupkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,groupkeys];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *JSONArray = jsonreturned[@"content"];
            
            groupMemberArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                //Create our ClassRecord object
                NSString * username=[[JSONArray objectAtIndex:i] objectForKey:@"username"];
                [groupMemberArray addObject:username];
            }
            result=TRUE;
        }
    }];
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *JSONArray = jsonreturned[@"content"];
            
            groupMemberArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                //Create our ClassRecord object
                NSString * username=[[JSONArray objectAtIndex:i] objectForKey:@"username"];
                [groupMemberArray addObject:username];
            }
            result=TRUE;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    return result;
}

-(void)checkprivilege
{
    showallothertasks=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showallothertaskintaskassignmentview;
}

-(BOOL) updateTaskWithTaskRecordArray:(NSMutableArray *)taskrecordarray
{
    
    //generate json enrollment array
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsontaskarray=[[NSArray alloc]init];
    
    TaskRecord *taskobject=[[TaskRecord alloc]init];

    
    //generate json task array
    if (taskrecordarray.count>0) {
        
        arrayOfDicts = [[NSMutableArray alloc] init];
        keys=[NSArray arrayWithObjects:@"centerdb",@"centerkey",@"taskkey",@"createdatetime",@"assignedby",@"assignedto",@"followupdatetime",@"taskname", @"remarks",@"status",@"action",nil];
        
        for (int i = 0; i<taskrecordarray.count; i++) {
            taskobject=[taskrecordarray objectAtIndex:i];
            
            values=[NSArray arrayWithObjects:globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,taskobject.taskkey,taskobject.createdatetime,taskobject.assignedbyusername,taskobject.assignedtousername,taskobject.followupdatetime,taskobject.taskname,taskobject.remarks,taskobject.status,taskobject.action, nil];
            
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
        jsontaskarray = [NSArray arrayWithArray:arrayOfDicts];
    }
    
    //combine arrays
    NSDictionary *dictionary = @{@"taskarray" : jsontaskarray,
                                 @"postaction" : @"updatetask"};
    
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
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *JSONArray = jsonreturned[@"content"];
            if ([[[JSONArray objectAtIndex:0] objectForKey:@"result"] isEqualToString:@"success"]) {
                result= YES;
            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    return result;
}

-(void) loadtitle
{
    viewtitle.text=[MyClass returntitlewithtitle:@"Task and Request"];
    title_Date_Created.text=[MyClass returntitlewithtitle:@"Date Created"];
    title_Assigned_To.text=[MyClass returntitlewithtitle:@"Assigned To"];
    title_Assigned_By.text=[MyClass returntitlewithtitle:@"Assigned By"];
    title_Followup_On.text=[MyClass returntitlewithtitle:@"Followup On"];
    title_Task_Description.text=[MyClass returntitlewithtitle:@"Task Description"];
    title_Remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    title_Status.text=[MyClass returntitlewithtitle:@"Status"];

    title_task_Student.text=[MyClass returntitlewithtitle:@"Student"];
    title_task_Subject.text=[MyClass returntitlewithtitle:@"Subject"];
    title_task_Request_Date.text=[MyClass returntitlewithtitle:@"Request Date"];
    title_task_Requestor.text=[MyClass returntitlewithtitle:@"Requestor"];
    title_task_Requesting_From.text=[MyClass returntitlewithtitle:@"Requesting From"];
    title_task_Requesting_To.text=[MyClass returntitlewithtitle:@"Requesting To"];
    title_task_Reason.text=[MyClass returntitlewithtitle:@"Reason"];
    title_task_Status.text=[MyClass returntitlewithtitle:@"Status"];
    title_task_Action.text=[MyClass returntitlewithtitle:@"Action"];
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
        [MyClass retrievemenuimagewithasync:YES];
        [MyClass retrievecenterimages];
        
        [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,product,staff,classroom,marketing,centersettings,userroleandprivilege" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
        [MyClass LoadSchoolCalendarArray];
        
        [self checkprivilege];
        
        if (!showallothertasks) {
            if (sctaskview.numberOfSegments==3) {
                [sctaskview removeSegmentAtIndex:2 animated:YES];
            }
        }else{
            if (sctaskview.numberOfSegments==2) {
                [sctaskview insertSegmentWithTitle:[MyClass returntitlewithtitle:@"All Other Task"] atIndex:2 animated:YES];
            }
        }
        
        [self refreshlanguage];
        //[MyClass updatedevicetoken];
        [MyClass updatecenterkey];
        [self viewDidAppear:YES];
        
        
    });
}*/

-(void) reloadPageWithFirstLoad:(BOOL)firstload
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,staff,centersettings,userroleandprivilege,student,leavenature,arcode" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
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
                    
                    if([globalvariables.centerrecord.iparentleavemode isEqualToString:@"Disable"]){ 
                        if(sctype.selectedSegmentIndex==1){
                            sctype.selectedSegmentIndex=0;
                            [self selecttype:sctype];
                        }
                        [sctype setEnabled:NO forSegmentAtIndex:1];
                    }else{
                        [sctype setEnabled:YES forSegmentAtIndex:1];
                        actionTitleStack.hidden=![globalvariables.centerrecord.iparentleavemode isEqualToString:@"Request"];
                    }
                    

                    
                    [self checkprivilege];

                    [sctaskview setEnabled:showallothertasks forSegmentAtIndex:2];

                    [self refreshlanguage];
                    
                    if (selectedview && [selectedview intValue]==1) {
                        sctype.selectedSegmentIndex=1;
                        [self selecttype:sctype];
                    }else{
                        if(selectedtaskview){
                            sctype.selectedSegmentIndex=0;
                            lasttaskindex=[selectedtaskview intValue];
                            sctaskview.selectedSegmentIndex=[selectedtaskview intValue];
                            scstatus.selectedSegmentIndex=0;
                            [self selecttype:sctype];
                        }else{
                            if(sctype.selectedSegmentIndex==0){
                                [self retrieveTaskRecord];
                            }else{
                                [self retrieveStudentRequest];
                            }
                        }
                    }
                }
                    });
                
            }];
        
    });
}

-(void) retrieveTaskRecord
{
    if (sctaskview.selectedSegmentIndex==0) {
        [self retrieveMyTaskRecordsWithStatus:[statusarray objectAtIndex:scstatus.selectedSegmentIndex]];
    }else if(sctaskview.selectedSegmentIndex==1) {
        [self retrieveTaskToOthersRecordsWithStatus:[statusarray objectAtIndex:scstatus.selectedSegmentIndex]];
    }else{
        [self retrieveAllOtherTaskRecordsWithStatus:[statusarray objectAtIndex:scstatus.selectedSegmentIndex]];
    }
}

-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width
{
    CGRect visible = [self visibleWindowFrame];
    CGFloat edge = CGRectGetMaxX(visible);
    CGFloat panelY = visible.origin.y;
    CGFloat panelHeight = visible.size.height;
    if (edge < 1) {
        edge = mainWindow.bounds.size.width;
        panelY = 0;
        panelHeight = mainWindow.bounds.size.height;
    }
    CGFloat panelWidth = width > 0 ? MIN(width, visible.size.width > 1 ? visible.size.width : edge) : 0;
    BOOL alreadyClosed = ailoadindicator.hidden && sidewindowview.frame.size.width < 1 && fabs(sidewindowview.frame.origin.x - edge) < 1;
    if (alreadyClosed) {
        return;
    }
    if (fabs(sidewindowview.frame.origin.x - (edge - panelWidth)) < 1 && fabs(sidewindowview.frame.size.width - panelWidth) < 1 && fabs(sidewindowview.frame.size.height - panelHeight) < 1) {
        return;
    }
    if (width>0 && sidewindowview.frame.size.width < 1) {
        [MyClass playsoundwithoption:@"open"];
    }
    if (visible.size.width > 1) {
        sidewindowviewclosebutton.frame = visible;
    }
    sideWindowAdjusting = YES;
    [UIView animateWithDuration:0.25f animations:^{
        sidewindowview.hidden = width<=0;
        sidewindowview.frame=CGRectMake(edge-panelWidth, panelY, panelWidth, panelHeight);
        for (UIView *panelChild in sidewindowview.subviews) {
            if ([panelChild isKindOfClass:[UIActivityIndicatorView class]]) {
                continue;
            }
            panelChild.frame = sidewindowview.bounds;
        }
        if (width==0 && sidewindowview.frame.origin.x< edge) {
            [MyClass playsoundwithoption:@"close"];
        }
    } completion:^(BOOL finished){
        sideWindowAdjusting = NO;
        if (width > 0) {
            [self pinOpenSideWindowToVisibleEdge];
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
    [TaskTable deselectRowAtIndexPath:[TaskTable indexPathForSelectedRow] animated:YES];
    
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
    
    
    if([selectedItem isEqualToString:@"FollowupDateTime"]){
        NSString *selecteddatestring=[selecteddatearray firstObject];
        if (![tmptaskadddatetime isEqualToString:[NSString stringWithFormat:@"%@ %@",selecteddatestring,[tmptaskadddatetime substringFromIndex:12]]]) {
            tmptaskadddatetime=[NSString stringWithFormat:@"%@ %@",selecteddatestring,[tmptaskadddatetime substringFromIndex:12]];
            
            [taskAddTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self adjustTaskAddTableSize];
            
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==ownersearchbar){
        if ([searchText isEqualToString:@""]) {
            filteredStaffArray=[[NSMutableArray alloc]initWithArray:allStaffArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.firstname contains[c] %@ or self.lastname contains[c] %@ or self.username contains[c] %@",searchText,searchText,searchText];
            filteredStaffArray=[[NSMutableArray alloc]initWithArray:[allStaffArray filteredArrayUsingPredicate:predicate]];
            
        }
        [OwnerTable reloadData];
        [OwnerTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==assigneesearchbar){
        if (tmpassignclasstype==0) {
            if ([searchText isEqualToString:@""]) {
                filteredStaffArray=[[NSMutableArray alloc]initWithArray:allStaffArray];
            }else{
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.firstname contains[c] %@ or self.lastname contains[c] %@ or self.username contains[c] %@",searchText,searchText,searchText];
                filteredStaffArray=[[NSMutableArray alloc]initWithArray:[allStaffArray filteredArrayUsingPredicate:predicate]];
                
            }
            [AssigneeTable reloadData];
            [AssigneeTable setContentOffset:CGPointZero animated:YES];
        }else{
            if ([searchText isEqualToString:@""]) {
                filteredGroupArray=[[NSMutableArray alloc]initWithArray:allGroupArray];
            }else{
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.groupname contains[c] %@",searchText];
                filteredGroupArray=[[NSMutableArray alloc]initWithArray:[allGroupArray filteredArrayUsingPredicate:predicate]];
                
            }
            [AssigneeTable reloadData];
            [AssigneeTable setContentOffset:CGPointZero animated:YES];
        }
    }
}

-(NSString *) returnrequestornamewithrequestname:(NSString *)requestname studentkey:(NSString *)studentkey
{
    NSRange range=[requestname rangeOfString:@"@"];
    if (range.location==NSNotFound) {
        //parent
        return [MyClass returnContactRelationshipWithStudentkey:studentkey Contact:requestname];
    }else{
        //staff
        return [MyClass returnstaffnamewithusername:requestname firstorfullname:@"full"];
    }
}
/*
-(NSString *) returncontactnumberwithrequestname:(NSString *)requestname
{
    NSRange range=[requestname rangeOfString:@"@"];
    if (range.location==NSNotFound) {
        //parent
        return requestname;
    }else{
        //staff
        return @"";
    }
}*/



-(void) updatesearchtext
{
    [self returnfilterstudentrequestarray];
    [RequestTable setContentOffset:CGPointZero animated:YES];
}

-(void) returnfilterstudentrequestarray
{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    
    if (screquestor.selectedSegmentIndex!=0) {
        if (screquestor.selectedSegmentIndex==1) {
            newCondition = [NSPredicate predicateWithFormat:@"not (self.requestor_username contains[c] %@)",@"@"];
            [nsPredicatearray addObject:newCondition];
        }else{
            newCondition = [NSPredicate predicateWithFormat:@"self.requestor_username contains[c] %@",@"@"];
            [nsPredicatearray addObject:newCondition];
        }
    }
    
    
    if (screqueststatus.selectedSegmentIndex!=0) {
        if (screqueststatus.selectedSegmentIndex==1) {
            newCondition = [NSPredicate predicateWithFormat:@"self.request_status =%@",@"Approved"];
            [nsPredicatearray addObject:newCondition];
        }else if (screqueststatus.selectedSegmentIndex==2){
            newCondition = [NSPredicate predicateWithFormat:@"self.request_status contains[c] %@",@"Pending"];
            [nsPredicatearray addObject:newCondition];
        }else if (screqueststatus.selectedSegmentIndex==3){
            newCondition = [NSPredicate predicateWithFormat:@"self.request_status =%@",@"Cancelled"];
            [nsPredicatearray addObject:newCondition];
        }else if (screqueststatus.selectedSegmentIndex==4){
            newCondition = [NSPredicate predicateWithFormat:@"self.request_status =%@",@"Rejected"];
            [nsPredicatearray addObject:newCondition];
        }else if (screqueststatus.selectedSegmentIndex==5){
            newCondition = [NSPredicate predicateWithFormat:@"self.request_status =%@",@"Overridden"];
            [nsPredicatearray addObject:newCondition];
        }
    }
    
    if (![search_text.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithFormat:@"SELF.studentfullname contains[c] %@ or self.subjectfullname contains[c] %@ or self.actionbyfullname contains[c] %@",search_text.text,search_text.text,search_text.text];
        [nsPredicatearray addObject:newCondition];
        
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredStudentRequestArray= [[NSMutableArray alloc]initWithArray:[studentRequestArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredStudentRequestArray= [[NSMutableArray alloc]initWithArray:studentRequestArray];
    }
    
    
    
    
    [RequestTable reloadData];
    
}

-(void) approveButtonPressed:(UIButton *)sender
{
    selectedstudentrequestrecord=[filteredStudentRequestArray objectAtIndex:sender.tag];
    classvalidatemessage=[MyClass validateClassWithFreeScheduleArray:[self returnfreescheduleclassarray] studentkey:selectedstudentrequestrecord.classrecord.studentkey enrollmentkey:nil];
    classvalidatestatus=[[ClassValidateStatus alloc]initClassValidateStatuswithoverenrollmentstatus:@"" sameinstructormulticlassstatus:@"" alreadyenrolledstatus:@"" sameclassroommulticlassstatus:@"" hasextendedchildclassstatus:@"" classroomexceedcapacitystatus:@"" makeupquotaexceedstatus:@""];
    [self checkvalidatemessage];
}

-(NSMutableArray *) returnfreescheduleclassarray
{
    
    FreeScheduleClass *freescheduleclass_object=[[FreeScheduleClass alloc]init];
    
    freescheduleclass_object.classkey=selectedstudentrequestrecord.classrecord.classkey;
    freescheduleclass_object.subject=selectedstudentrequestrecord.classrecord.subject;
    freescheduleclass_object.attendance=@"Makeup";
    
    freescheduleclass_object.makeupdate=[MyClass convertToNSStringWithNSDate:selectedstudentrequestrecord.requestingdatetime DateFormat:@"dd-MMM-yyyy"];
    freescheduleclass_object.makeuptime=[MyClass convertToNSStringWithNSDate:selectedstudentrequestrecord.requestingdatetime DateFormat:@"HH:mm"];;
    freescheduleclass_object.makeupinstructor=selectedstudentrequestrecord.request_for_instructor;
    freescheduleclass_object.makeupclassroom=selectedstudentrequestrecord.request_for_classroom;
    freescheduleclass_object.makeupattendance=globalvariables.centerrecord.defaultattendancestatus;
    freescheduleclass_object.classremarks=selectedstudentrequestrecord.classrecord.absentmakeupreason;
    freescheduleclass_object.classtype=@"Class";
    freescheduleclass_object.action=@"Edit";
    freescheduleclass_object.leavenaturelistkey=selectedstudentrequestrecord.request_for_leavenaturelistkey;
    
    return [[NSMutableArray alloc]initWithObjects:freescheduleclass_object, nil];
}

-(void) checkvalidatemessage
{
    [MyClass checkValidateMessageWithClassValidateMessage:classvalidatemessage ClassValidateStatus:classvalidatestatus View:self];
}

-(void) validationPassed:(BOOL)pass
{
    if(pass){
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Approve Request"] message:[MyClass returntitlewithtitle:@"Are you sure to proceed?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self approveRequestWithStudentRequestKey:selectedstudentrequestrecord.studentrequestkey Approve:YES];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:OKAction];
    [alert addAction:CancelAction];
    //[self presentViewController:alert animated:YES completion:nil];
    [MyClass presentViewController:alert View:self];
    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }
}

-(void) approveRequestWithStudentRequestKey:(NSInteger)studentrequestkey Approve:(BOOL)approve
{
    __block BOOL result=FALSE;
    
    
    NSDictionary *dictionary = @{@"postaction" : @"approveattendancechange",
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"studentrequestkey" : [@(studentrequestkey) stringValue],
                                 @"updatedby" : globalvariables.username,
                                 @"request_approved"  : approve?@"Y":@"N"};
    
  
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!error) {
            result=TRUE;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    
    if (result) {
        [self retrieveStudentRequest];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
}

-(void) exemptRequestWithStudentRequestKey:(NSInteger)studentrequestkey
{
    __block BOOL result=FALSE;
    
    
    NSDictionary *dictionary = @{@"postaction" : @"exemptattendancechange",
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"studentrequestkey" : [@(studentrequestkey) stringValue],
                                 @"updatedby" : globalvariables.username};
    

    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!error) {
            result=TRUE;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    
    if (result) {
        [self retrieveStudentRequest];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
}

-(void) exemptButtonPressed:(UIButton *)sender
{
    selectedstudentrequestrecord=[filteredStudentRequestArray objectAtIndex:sender.tag];
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Exempt Request"] message:[MyClass returntitlewithtitle:@"Are you sure to exempt the request and reimburse the quota?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self exemptRequestWithStudentRequestKey:selectedstudentrequestrecord.studentrequestkey];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:OKAction];
    [alert addAction:CancelAction];
    //[self presentViewController:alert animated:YES completion:nil];
    [MyClass presentViewController:alert View:self];

}

-(void) rejectButtonPressed:(UIButton *)sender
{
    selectedstudentrequestrecord=[filteredStudentRequestArray objectAtIndex:sender.tag];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Reject Request"] message:[MyClass returntitlewithtitle:@"Are you sure to proceed?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self approveRequestWithStudentRequestKey:selectedstudentrequestrecord.studentrequestkey Approve:NO];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:OKAction];
    [alert addAction:CancelAction];
    //[self presentViewController:alert animated:YES completion:nil];
    [MyClass presentViewController:alert View:self];

}

-(void) rescheduleButtonPressed:(UIButton *)sender
{
    selectedstudentrequestrecord=[filteredStudentRequestArray objectAtIndex:sender.tag];
    ClassScheduleRecord *ClassScheduleObject=[[ClassScheduleRecord alloc]init];
    ClassScheduleObject.studentkey=selectedstudentrequestrecord.classrecord.studentkey;
    ClassScheduleObject.classkey=selectedstudentrequestrecord.classrecord.classkey;
    ClassScheduleObject.attendance=selectedstudentrequestrecord.classrecord.attendance;
    ClassScheduleObject.startdate=selectedstudentrequestrecord.classrecord.startdate;
    ClassScheduleObject.classtime=selectedstudentrequestrecord.classrecord.classtime;
    ClassScheduleObject.instructor=selectedstudentrequestrecord.classrecord.instructor;
    ClassScheduleObject.classroom=selectedstudentrequestrecord.classrecord.classroom;
    ClassScheduleObject.makeupattendance=globalvariables.centerrecord.defaultattendancestatus;
    ClassScheduleObject.makeupdate=[MyClass convertToNSStringWithNSDate:selectedstudentrequestrecord.requestingdatetime DateFormat:@"dd-MMM-yyyy"];
    ClassScheduleObject.makeuptime=[MyClass convertToNSStringWithNSDate:selectedstudentrequestrecord.requestingdatetime DateFormat:@"HH:mm"];
    ClassScheduleObject.makeupinstructor=selectedstudentrequestrecord.request_for_instructor;
    ClassScheduleObject.makeupclassroom=selectedstudentrequestrecord.request_for_classroom;
    ClassScheduleObject.absentmakeupreason=selectedstudentrequestrecord.classrecord.absentmakeupreason;
    ClassScheduleObject.subject=selectedstudentrequestrecord.classrecord.subject;
    ClassScheduleObject.leavenaturelistkey=selectedstudentrequestrecord.request_for_leavenaturelistkey;
    
    
    
    [self startsidewindowanimationwithwidth:320];
    sideWindowType=20;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MakeupPopoverViewController *makeuppopover = (MakeupPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MakeupPopoverViewController"];
        makeuppopover.delegate=self;
        makeuppopover.PopoverClassRecord=ClassScheduleObject;
        makeuppopover.PopoverOption=@"FromTaskView";
        //classpopover.PopoverStudent=DetailsViewStudent;
        makeuppopover.preferredContentSize=CGSizeMake(320, self.view.frame.size.height);
        
        makeuppopover.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:makeuppopover.view];
        [self addChildViewController:makeuppopover];
        [makeuppopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
}

-(void) dismisspopover
{
    [self closesidewindow];
    //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil]
    [self retrieveStudentRequest];
    
}

-(void)tapImageDetected:(UITapGestureRecognizer *)gr{
    UIImageView *theTappedImageView=(UIImageView *)gr.view;
    //NSIndexPath *indexpath =[NSIndexPath indexPathForRow:theTappedImageView.tag inSection:0];
    
    
    if(![MyClass showMenuItemwithObject:@"Student Profile"]){
        return;
    }
    
    
    studentrequestrecordobject=[filteredStudentRequestArray objectAtIndex:theTappedImageView.tag];
    
    [MyClass insertViewHistoryWithType:@"student" Typekey:studentrequestrecordobject.classrecord.studentkey Name:@"" IDNumber:@"" Gender:@""];
    
    [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
    sideWindowType=10;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
        ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
        ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
        ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:studentrequestrecordobject.classrecord.studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];
        
        ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=studentrequestrecordobject.classrecord.enrollmentkey;
        ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedClasskey=studentrequestrecordobject.classrecord.classkey;
        //((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedDTkey=ClassScheduleObject.dtkey;
        
        /*if (![(StudentDetailsViewController *)[studentdetailsnavcontroller topViewController] retrieveStudent:ClassScheduleObject.studentkey]) {
         return;
         }*/
        
        ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(self.view.frame.size.width-240, self.view.frame.size.height);
        
        
        ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).TypeSelectionButton.hidden=NO;
        ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).typeselectionarrow.hidden=NO;
//        ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501, 2, 129, 29);
//        ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
//        ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
        
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.hidden=YES;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.hidden=NO;
        
        [((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]) drawpointerwithoption:@"closed" imageview:((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).dayselectionarrow];
        
        studentdetailsnavcontroller.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:studentdetailsnavcontroller.view];
        [self addChildViewController:studentdetailsnavcontroller];
        [studentdetailsnavcontroller didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
        
        
        
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

-(void) refreshstudentdetailviewpresentingviewcontent
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self retrieveStudentRequest];
    });
}

-(void) updatestudentinformationlist:(NSString *)studentkey reloadlist:(BOOL)reload
{
    [RequestTable reloadData];
}

-(void) gotostudentprofile:(NSString *)studentkey
{
    //not used
}

-(void) refreshparentviewdocumentfoldercount
{
    //not used
}

-(void) dismissEditStudentView{
    
}
@end
