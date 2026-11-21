//
//  MarketingPopoverViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 7/6/15.
//  Copyright (c) 2015 DreamHigh Company Limited. All rights reserved.
//

#import "MarketingPopoverViewController.h"
#import "MyClass.h"
#import "StudentDetailsNavController.h"
#import "StudentDetailsViewController.h"
#import "SceneDelegate.h"

@interface MarketingPopoverViewController ()<myStudentViewController>
@end

@implementation MarketingPopoverViewController 
@synthesize MarketingTableMode,MarketingRecordObject,MarketingTableCategory;

#define maxPopupHeight self.view.frame.size.height
#define kbPopupHeight 380
#define popoverwidth 320
#define studentlisttablewidth 260
#define datewidth 375
#define daywidth 250
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
    
    //globalvariables=[GlobalVariables singleObj];
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    //initialize field
    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];

    
    studentListTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, studentlisttablewidth, self.view.frame.size.height)];
    [self.view addSubview:studentListTableMasterView];
    
    //student list table
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, studentlisttablewidth,84)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [studentListTableMasterView addSubview:headerView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Student List"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    
    studentlistsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, studentlisttablewidth, 42)];
    studentlistsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    studentlistsearchbar.delegate=self;
    [headerView addSubview:studentlistsearchbar];
    
    studentListTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+84, studentlisttablewidth, self.view.frame.size.height-44-84) style:UITableViewStyleGrouped];
    studentListTable.delegate=self;
    studentListTable.dataSource=self;
    studentListTable.sectionHeaderHeight=0;
    [studentListTableMasterView addSubview:studentListTable];
    
    studentListTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, studentlisttablewidth, 44)];
    [studentListTableMasterView addSubview:studentListTableToolBar];

    NSMutableArray *barItems=[[NSMutableArray alloc]init];
    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    
    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
    [studentListTableToolBar setItems:barItems];
    
    quotaarray=[[NSMutableArray alloc]init];
    [quotaarray addObject:@""];
    for (int i=0; i<=1000; i++) {
        [quotaarray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    couponallowcreditarray=[[NSMutableArray alloc]initWithObjects:@"No",@"All",@"redeemedcoupon", nil];
    
    [self InitializeField];
    
    keyboardshow=FALSE;
    
//    MarketingPopoverTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    MarketingPopoverTable.dataSource=self;
//    MarketingPopoverTable.delegate=self;
    MarketingToolbar.clipsToBounds=YES;
//    [self.view addSubview:MarketingPopoverTable];
    
    [MarketingPopoverTable reloadData];
    
    [self adjusttablesize];
    
    //add separator
    UILabel *separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth, 20, 1, self.view.frame.size.height-20)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
    

    

    

    
    
    //AssigneeListArray=[[NSMutableArray alloc]init];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
//    mainWindow= [[[UIApplication sharedApplication] delegate] window];
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.anyObject.delegate;
    mainWindow = sceneDelegate.window;
    mainviewcontroller = (MainViewController*) [mainWindow rootViewController];
    sidewindowviewclosebutton=[[UIButton alloc]initWithFrame:mainWindow.bounds];
    sidewindowviewclosebutton.backgroundColor=[UIColor blackColor];
    sidewindowviewclosebutton.layer.opacity=0.3;
    sidewindowviewclosebutton.tag=-200;
    sidewindowviewclosebutton.hidden=YES;
    [sidewindowviewclosebutton addTarget:self action:@selector(closesidewindowview) forControlEvents:UIControlEventTouchUpInside];
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
    
    datecalendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 44, DateMasterView.frame.size.width, DateMasterView.frame.size.height+100) Theme:3 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
    datecalendarview.delegate=self;
    [DateMasterView addSubview:datecalendarview];
    [self createDateTableToolBar];
    [self createDayTableToolBar];
    [self createNumberTableToolBar];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, datewidth,88)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [SubjectMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Subject"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    
    subjectsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, datewidth, 42)];
    subjectsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    subjectsearchbar.delegate=self;
    subjectsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:subjectsearchbar];
    subjecttable.sectionHeaderHeight=0;
    
    
    subjectArray=[MyClass retrievesubjectinformationwithstatus:@"Active" category:@"All" flushcachedata:NO];
    filteredSubjectArray=[[NSMutableArray alloc]initWithArray:subjectArray];
    [self sortFilteredSubjectArray];
    
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, datewidth,88)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [ProductMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Product"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    
    productsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, datewidth, 42)];
    productsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    productsearchbar.delegate=self;
    productsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:productsearchbar];
    producttable.sectionHeaderHeight=0;
    
    ProductArray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveproductinformationwithcategory:@"All" status:@"Active" flushcachedata:NO]];
    filteredProductArray=[[NSMutableArray alloc]initWithArray:ProductArray];
    [self sortFilteredProductArray];
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

-(void) sortFilteredProductArray
{
    NSSortDescriptor *sortBySubjectName;
    if ([globalvariables.language isEqualToString:@"English"]) {
        sortBySubjectName = [NSSortDescriptor sortDescriptorWithKey:@"englishname" ascending:YES selector:@selector(localizedStandardCompare:)];
    }else{
        sortBySubjectName = [NSSortDescriptor sortDescriptorWithKey:@"chinesename" ascending:YES selector:@selector(localizedStandardCompare:)];
    }
    
    NSArray *sortDescriptors = @[sortBySubjectName];
    filteredProductArray = [NSMutableArray arrayWithArray:[filteredProductArray sortedArrayUsingDescriptors:sortDescriptors]];
}

-(void) returnCalendarYear:(NSString *)year
{
    [backButton setTitle:year forState:UIControlStateNormal];
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

-(void) createDayTableToolBar
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
//    [daytoolbar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 13, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [DayMasterView addSubview:button];
}

-(void) createNumberTableToolBar
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
    
    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [numbertoolbar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 13, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [NumberMasterView addSubview:button];
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    //[MessagePopoverTable reloadData];
}

-(void) loadcalendar
{
    [MyClass getLatestDataSetv2withParameters:@"calendar" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    //[MyClass LoadSchoolCalendarArray];
    //[MyClass LoadSchoolCalendarWithCheckingLastUpdate:YES];
    //datePickerViewMenu=[[NSMutableArray alloc] initWithArray:globalvariables.alldayarray];
    

}

- (void)didReceiveMemoryWarning {
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
    keyboardheight = [MyClass keyboardOverlapInView:self.view notification:notification];
    [self adjusttablesize];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    keyboardheight = [MyClass keyboardOverlapInView:self.view notification:notification];
    [self adjusttablesize];
    
}

-(void) createViewBarButton{
    
//    UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//    UIBarButtonItem *cloneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Clone"] style:UIBarButtonItemStylePlain target:self action:@selector(cloneButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    NSArray *buttons =[NSArray arrayWithObjects:cloneButton,flexibleSpaceBarButton,editButton,nil];
//    [MarketingToolbar setItems:buttons animated:NO];
    
    doneButton.hidden=YES;
    cloneButton.hidden=NO;
    deleteButton.hidden=YES;
    editButton.hidden=NO;
    
    
//    if([MarketingTableCategory isEqualToString:@"coupon"]){
//        editButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editmarketing && [workingMarketing.usedcount integerValue]==0;
//    }else{
        editButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editmarketing;
//    }
    
}

-(void) createEditBarButton{
//    UIBarButtonItem *deleteButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Delete"] style:UIBarButtonItemStylePlain target:self action:@selector(deleteButtonPressed:)];
//    //[deleteButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor redColor],  NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:deleteButton,flexibleSpaceBarButton,doneButton,nil];
//    [MarketingToolbar setItems:buttons animated:NO];
    
    doneButton.hidden=NO;
    cloneButton.hidden=YES;
    deleteButton.hidden=NO;
    editButton.hidden=YES;
    
    deleteButton.enabled=marketingPromotionCanBeChanged?YES:NO;
    
    
}

-(void) createAddBarButton{
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,doneButton,nil];
//    [MarketingToolbar setItems:buttons animated:NO];
    
    doneButton.hidden=NO;
    cloneButton.hidden=YES;
    deleteButton.hidden=YES;
    editButton.hidden=YES;
    
}

-(IBAction) cloneButtonPressed:(id)sender{
    
    MarketingTableMode=@"Clone";
    [self createAddBarButton];
    [self InitializeField];
    [MarketingPopoverTable reloadData];
    [self adjusttablesize];
}

-(void) adjusttablesize
{
    float tableheight;
    float tablewidth;
    
    tableheight=maxPopupHeight-keyboardheight;
    marketingTableBottomConstraint.constant=0;
    [MyClass applyKeyboardContentInset:keyboardheight toView:MarketingPopoverTable];
    
    if(!SubjectMasterView.hidden){
        subjecttablebottomconstraint.constant=0;
        [MyClass applyKeyboardContentInset:keyboardheight toView:subjecttable];
    }
    if(!ProductMasterView.hidden){
        producttablebottomconstraint.constant=0;
        [MyClass applyKeyboardContentInset:keyboardheight toView:producttable];
    }
    
    if (showStudentListTable) {
        tablewidth=popoverwidth+studentlisttablewidth;
    }else if (showDateTable){
        tablewidth=popoverwidth+datewidth;
    }else if (showDayTable){
        tablewidth=popoverwidth+daywidth;
    }else if (showSubjectTable){
        tablewidth=popoverwidth+datewidth;
    }else if (showProductTable){
        tablewidth=popoverwidth+datewidth;
    }else if (showNumberTable){
        tablewidth=popoverwidth+daywidth;
    }else{
        tablewidth=popoverwidth;
    }

//        [MarketingPopoverTable setFrame:CGRectMake(0, 44+20, popoverwidth, tableheight-44-20)];
    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    
    self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
    
    if (showStudentListTable) {
        [studentListTable setFrame:CGRectMake(0, 44+84+20, studentlisttablewidth, tableheight-44-84-20)];
        studentListTableMasterView.hidden=NO;
        DateMasterView.hidden=YES;
        DayMasterView.hidden=YES;
        SubjectMasterView.hidden=YES;
        ProductMasterView.hidden=YES;
        NumberMasterView.hidden=YES;
        studentListTableMasterView.frame=CGRectMake(popoverwidth, 0, studentlisttablewidth, tableheight);
        [studentListTable reloadData];
    }else if (showDateTable){
        studentListTableMasterView.hidden=YES;
        DateMasterView.hidden=NO;
        DayMasterView.hidden=YES;
        SubjectMasterView.hidden=YES;
        ProductMasterView.hidden=YES;
        NumberMasterView.hidden=YES;
    }else if (showDayTable){
        studentListTableMasterView.hidden=YES;
        DateMasterView.hidden=YES;
        DayMasterView.hidden=NO;
        SubjectMasterView.hidden=YES;
        ProductMasterView.hidden=YES;
        NumberMasterView.hidden=YES;
    }else if (showSubjectTable){
        studentListTableMasterView.hidden=YES;
        DateMasterView.hidden=YES;
        DayMasterView.hidden=YES;
        SubjectMasterView.hidden=NO;
        ProductMasterView.hidden=YES;
        NumberMasterView.hidden=YES;
        [subjecttable reloadData];
    }else if (showProductTable){
        studentListTableMasterView.hidden=YES;
        DateMasterView.hidden=YES;
        DayMasterView.hidden=YES;
        SubjectMasterView.hidden=YES;
        ProductMasterView.hidden=NO;
        NumberMasterView.hidden=YES;
        [producttable reloadData];
    }else if (showNumberTable){
        studentListTableMasterView.hidden=YES;
        DateMasterView.hidden=YES;
        DayMasterView.hidden=YES;
        SubjectMasterView.hidden=YES;
        ProductMasterView.hidden=YES;
        NumberMasterView.hidden=NO;
    }
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    if ([windowname isEqualToString:@"showStudentList"]) {
        showStudentListTable=YES;
        showDateTable=NO;
        showDayTable=NO;
        showSubjectTable=NO;
        showProductTable=NO;
        showNumberTable=NO;
    }else if ([windowname isEqualToString:@"showDateTable"]) {
        showStudentListTable=NO;
        showDateTable=YES;
        showDayTable=NO;
        showSubjectTable=NO;
        showProductTable=NO;
        showNumberTable=NO;
    }else if ([windowname isEqualToString:@"showDayTable"]) {
        showStudentListTable=NO;
        showDateTable=NO;
        showDayTable=YES;
        showSubjectTable=NO;
        showProductTable=NO;
        showNumberTable=NO;
    }else if ([windowname isEqualToString:@"showSubjectTable"]) {
        showStudentListTable=NO;
        showDateTable=NO;
        showDayTable=NO;
        showSubjectTable=YES;
        showProductTable=NO;
        showNumberTable=NO;
    }else if ([windowname isEqualToString:@"showProductTable"]) {
        showStudentListTable=NO;
        showDateTable=NO;
        showDayTable=NO;
        showSubjectTable=NO;
        showProductTable=YES;
        showNumberTable=NO;
    }else if ([windowname isEqualToString:@"showNumberTable"]) {
        showStudentListTable=NO;
        showDateTable=NO;
        showDayTable=NO;
        showSubjectTable=NO;
        showProductTable=NO;
        showNumberTable=YES;
    }else{
        showStudentListTable=NO;
        showDateTable=NO;
        showDayTable=NO;
        showSubjectTable=NO;
        showProductTable=NO;
        showNumberTable=NO;
    }
}



-(BOOL) InitializeField
{
    if (!globalvariables) {
        globalvariables=[GlobalVariables singleObj];
    }
    
    workingMarketing=[[MarketingRecord alloc]init];
//    showStartDatePicker=NO;
//    showEndDatePicker=NO;
    workingMarketing.category=MarketingTableCategory;
    //initialize field
    
    if ([MarketingTableMode isEqualToString:@"Add"]) {
        [self performSelector:@selector(loadcalendar) withObject:nil afterDelay:0];
        
        workingMarketing.code=@"";
        workingMarketing.description=@"";
        workingMarketing.description_chinese=@"";
        [df setDateFormat:@"dd-MMM-yyyy"];
        workingMarketing.startdate=[df stringFromDate:[NSDate date]];
        workingMarketing.enddate=@"";//@"31-Dec-2030";
        workingMarketing.remarks=@"";
        workingMarketing.promotionquota=@"";
        workingMarketing.perclassorquantity=NO;
        workingMarketing.earlybirdlastdate=@"";
        
        if ([MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]) {
            workingMarketing.promotionfixeddiscount=@"0";
            workingMarketing.promotionpercentagediscount=@"";
            tmpDiscountType=@"Fixed";
//            tmpDiscountAmount=@"0";
        }else{
            workingMarketing.promotionfixeddiscount=@"";
            workingMarketing.promotionpercentagediscount=@"";
            tmpDiscountType=@"";
//            tmpDiscountAmount=@"";
        }
        workingMarketing.effectivefrom=@"0";
        workingMarketing.effectiveto=@"";
        workingMarketing.subcategory=@"All";
        workingMarketing.redeemable=NO;
        workingMarketing.redeempoint=@"0";
        workingMarketing.perstudentquota=@"";
        workingMarketing.cannotuseconjunctionwithothercoupons=NO;
        workingMarketing.subjectarray=[[NSMutableArray alloc]init];
        workingMarketing.productarray=[[NSMutableArray alloc]init];
        workingMarketing.couponallowcredit=@"No";
        workingMarketing.earlybirdlastdate=@"";
        workingMarketing.buymorepayless=NO;
        workingMarketing.enablebuymorepayless=NO;
        workingMarketing.estartdate=@"";
        workingMarketing.eenddate=@"";
        workingMarketing.minnoofclass=10;
        workingMarketing.bmsmacrossothersubjects=YES;
        workingMarketing.bmsmminsubjectno=1;
        workingMarketing.bmsmminnoofclasspersubject=1;
        workingMarketing.bmsmsamebillmonth=NO;
        workingMarketing.manualapply=YES;
        [self createAddBarButton];
    }else if ([MarketingTableMode isEqualToString:@"View"]){
        [self retrieveMarketingPromotionWithMarketingKey:MarketingRecordObject.marketingkey];
        workingMarketing.code=MarketingRecordObject.code;
        workingMarketing.description=MarketingRecordObject.description;
        workingMarketing.description_chinese=MarketingRecordObject.description_chinese;
        workingMarketing.startdate=MarketingRecordObject.startdate;
        workingMarketing.enddate=MarketingRecordObject.enddate;
        workingMarketing.remarks=MarketingRecordObject.remarks;
        tmpDiscountType=![MarketingRecordObject.promotionfixeddiscount isEqualToString:@""]?@"Fixed":@"Percentage";
        workingMarketing.promotionfixeddiscount=MarketingRecordObject.promotionfixeddiscount;
        workingMarketing.promotionpercentagediscount=MarketingRecordObject.promotionpercentagediscount;
        workingMarketing.promotionquota=MarketingRecordObject.promotionquota;
        workingMarketing.usedcount=MarketingRecordObject.usedcount;
        workingMarketing.effectivefrom=MarketingRecordObject.effectivefrom;
        workingMarketing.effectiveto=MarketingRecordObject.effectiveto;
        workingMarketing.subcategory=MarketingRecordObject.subcategory;
        workingMarketing.redeemable=MarketingRecordObject.redeemable;
        workingMarketing.redeempoint=MarketingRecordObject.redeempoint;
        workingMarketing.perstudentquota=MarketingRecordObject.perstudentquota;
        workingMarketing.cannotuseconjunctionwithothercoupons=MarketingRecordObject.cannotuseconjunctionwithothercoupons;
        workingMarketing.subjectarray=[self copyKeyWithArray:MarketingRecordObject.subjectarray];
        workingMarketing.productarray=[self copyKeyWithArray:MarketingRecordObject.productarray];
        workingMarketing.couponallowcredit=MarketingRecordObject.couponallowcredit;
        workingMarketing.perclassorquantity=MarketingRecordObject.perclassorquantity;
        workingMarketing.earlybirdlastdate=MarketingRecordObject.earlybirdlastdate;
        workingMarketing.buymorepayless=MarketingRecordObject.buymorepayless;
        workingMarketing.enablebuymorepayless=MarketingRecordObject.enablebuymorepayless;
        workingMarketing.estartdate=MarketingRecordObject.estartdate;
        workingMarketing.eenddate=MarketingRecordObject.eenddate;
        workingMarketing.minnoofclass=MarketingRecordObject.minnoofclass;
        workingMarketing.bmsmacrossothersubjects=MarketingRecordObject.bmsmacrossothersubjects;
        workingMarketing.bmsmminsubjectno=MarketingRecordObject.bmsmminsubjectno;
        workingMarketing.bmsmminnoofclasspersubject=MarketingRecordObject.bmsmminnoofclasspersubject;
        workingMarketing.bmsmsamebillmonth=MarketingRecordObject.bmsmsamebillmonth;
        workingMarketing.manualapply=MarketingRecordObject.manualapply;
        [self createViewBarButton];
    }else if ([MarketingTableMode isEqualToString:@"Edit"]){
        [self performSelector:@selector(loadcalendar) withObject:nil afterDelay:0];
        
        workingMarketing.code=MarketingRecordObject.code;
        workingMarketing.description=MarketingRecordObject.description;
        workingMarketing.description_chinese=MarketingRecordObject.description_chinese;
        workingMarketing.startdate=MarketingRecordObject.startdate;
        workingMarketing.enddate=MarketingRecordObject.enddate;
        workingMarketing.remarks=MarketingRecordObject.remarks;
        tmpDiscountType=![MarketingRecordObject.promotionfixeddiscount isEqualToString:@""]?@"Fixed":@"Percentage";
        workingMarketing.promotionfixeddiscount=MarketingRecordObject.promotionfixeddiscount;
        workingMarketing.promotionpercentagediscount=MarketingRecordObject.promotionpercentagediscount;
        workingMarketing.promotionquota=MarketingRecordObject.promotionquota;
        workingMarketing.effectivefrom=MarketingRecordObject.effectivefrom;
        workingMarketing.effectiveto=MarketingRecordObject.effectiveto;
        workingMarketing.subcategory=MarketingRecordObject.subcategory;
        workingMarketing.redeemable=MarketingRecordObject.redeemable;
        workingMarketing.redeempoint=MarketingRecordObject.redeempoint;
        workingMarketing.perstudentquota=MarketingRecordObject.perstudentquota;
        workingMarketing.cannotuseconjunctionwithothercoupons=MarketingRecordObject.cannotuseconjunctionwithothercoupons;
        workingMarketing.subjectarray=[self copyKeyWithArray:MarketingRecordObject.subjectarray];
        workingMarketing.productarray=[self copyKeyWithArray:MarketingRecordObject.productarray];
        workingMarketing.couponallowcredit=MarketingRecordObject.couponallowcredit;
        workingMarketing.perclassorquantity=MarketingRecordObject.perclassorquantity;
        workingMarketing.earlybirdlastdate=MarketingRecordObject.earlybirdlastdate;
        workingMarketing.buymorepayless=MarketingRecordObject.buymorepayless;
        workingMarketing.enablebuymorepayless=MarketingRecordObject.enablebuymorepayless;
        workingMarketing.estartdate=MarketingRecordObject.estartdate;
        workingMarketing.eenddate=MarketingRecordObject.eenddate;
        workingMarketing.minnoofclass=MarketingRecordObject.minnoofclass;
        workingMarketing.bmsmacrossothersubjects=MarketingRecordObject.bmsmacrossothersubjects;
        workingMarketing.bmsmminsubjectno=MarketingRecordObject.bmsmminsubjectno;
        workingMarketing.bmsmminnoofclasspersubject=MarketingRecordObject.bmsmminnoofclasspersubject;
        workingMarketing.bmsmsamebillmonth=MarketingRecordObject.bmsmsamebillmonth;
        workingMarketing.manualapply=MarketingRecordObject.manualapply;
        [self createEditBarButton];
    }else if ([MarketingTableMode isEqualToString:@"Clone"]){
        MarketingTableMode=@"Add";
        marketingPromotionCanBeChanged=YES;
        
//        [self retrieveMarketingPromotionWithMarketingKey:MarketingRecordObject.marketingkey];
        workingMarketing.code=MarketingRecordObject.code;
        workingMarketing.description=MarketingRecordObject.description;
        workingMarketing.description_chinese=MarketingRecordObject.description_chinese;
        workingMarketing.startdate=MarketingRecordObject.startdate;
        workingMarketing.enddate=MarketingRecordObject.enddate;
        workingMarketing.remarks=MarketingRecordObject.remarks;
        tmpDiscountType=![MarketingRecordObject.promotionfixeddiscount isEqualToString:@""]?@"Fixed":@"Percentage";
        workingMarketing.promotionfixeddiscount=MarketingRecordObject.promotionfixeddiscount;
        workingMarketing.promotionpercentagediscount=MarketingRecordObject.promotionpercentagediscount;
        workingMarketing.promotionquota=MarketingRecordObject.promotionquota;
        workingMarketing.usedcount=MarketingRecordObject.usedcount;
        workingMarketing.effectivefrom=MarketingRecordObject.effectivefrom;
        workingMarketing.effectiveto=MarketingRecordObject.effectiveto;
        workingMarketing.subcategory=MarketingRecordObject.subcategory;
        workingMarketing.redeemable=MarketingRecordObject.redeemable;
        workingMarketing.redeempoint=MarketingRecordObject.redeempoint;
        workingMarketing.perstudentquota=MarketingRecordObject.perstudentquota;
        workingMarketing.cannotuseconjunctionwithothercoupons=MarketingRecordObject.cannotuseconjunctionwithothercoupons;
        workingMarketing.subjectarray=[self copyKeyWithArray:MarketingRecordObject.subjectarray];
        workingMarketing.productarray=[self copyKeyWithArray:MarketingRecordObject.productarray];
        workingMarketing.couponallowcredit=MarketingRecordObject.couponallowcredit;
        workingMarketing.perclassorquantity=MarketingRecordObject.perclassorquantity;
        workingMarketing.earlybirdlastdate=MarketingRecordObject.earlybirdlastdate;
        workingMarketing.buymorepayless=MarketingRecordObject.buymorepayless;
        workingMarketing.enablebuymorepayless=MarketingRecordObject.enablebuymorepayless;
        workingMarketing.estartdate=MarketingRecordObject.estartdate;
        workingMarketing.eenddate=MarketingRecordObject.eenddate;
        workingMarketing.minnoofclass=MarketingRecordObject.minnoofclass;
        workingMarketing.bmsmacrossothersubjects=MarketingRecordObject.bmsmacrossothersubjects;
        workingMarketing.bmsmminsubjectno=MarketingRecordObject.bmsmminsubjectno;
        workingMarketing.bmsmminnoofclasspersubject=MarketingRecordObject.bmsmminnoofclasspersubject;
        workingMarketing.bmsmsamebillmonth=MarketingRecordObject.bmsmsamebillmonth;
        workingMarketing.manualapply=MarketingRecordObject.manualapply;
        [self createAddBarButton];
    }
    return YES;
}

-(NSMutableArray *)copyKeyWithArray:(NSMutableArray *)array
{
    if(!array){
        return nil;
    }
    
    NSMutableArray *result=[[NSMutableArray alloc]init];
    for (int i=0; i<array.count; i++) {
        [result addObject:array[i]];
    }
    return result;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==MarketingPopoverTable) {
        return 10;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==studentListTable) {
        return filteredStudentListArray.count;
    }else if (tableView==daytable) {
        return dayListArray.count;
    }else if (tableView==numbertable) {
        return numberListArray.count;
    }else if (tableView==subjecttable){
        return filteredSubjectArray.count;
    }else if (tableView==producttable){
        return filteredProductArray.count;
    }else{
        if ([MarketingTableMode isEqualToString:@"View"]) {
            if(section==0){
                return [MarketingTableCategory isEqualToString:@"coupon"]?6:3;
            }else if(section==1){
                if ([MarketingTableCategory isEqualToString:@"promotion"]){
                    return 3;
                }else if ([MarketingTableCategory isEqualToString:@"coupon"]) {
                    return 2;
                }else{
                    return 0;
                }
            }else if(section==2){
                return 2;
            }else if(section==3){
                return 1;
            }else if(section==4){
                if ([MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]) {
                    return 2;
                }else{
                    return 0;
                }
            }else if(section==5){
                return [MarketingTableCategory isEqualToString:@"coupon"]?2:0;
            }else if(section==6){
                return [MarketingTableCategory isEqualToString:@"promotion"]?((workingMarketing.buymorepayless?(6+(workingMarketing.bmsmacrossothersubjects?3:0)):1)):0;
            }else if(section==7){
                if ([MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]) {
                    return 2;
                }else{
                    return 0;
                }
            }else if (section==8){
                if ([MarketingTableCategory isEqualToString:@"coupon"] && globalvariables.centerrecord.enablemembershippoint) {
                    return 3;
                }else{
                    return 0;
                }
            }else{
                return 1;
            }
            
        }else{ //ClassTableMode isEqualToString:@"Edit"
            if(section==0){
                return [MarketingTableCategory isEqualToString:@"coupon"]?7:3;
            }else if(section==1){
                if ([MarketingTableCategory isEqualToString:@"promotion"]){
                    return 3;
                }else if([MarketingTableCategory isEqualToString:@"coupon"]) {
                    return 2;
                }else{
                    return 0;
                }
            }else if(section==2){
                return 2;
            }else if(section==3){
                return 1;
            }else if(section==4){
                if ([MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]) {
                    return 2;
                }else{
                    return 0;
                }
            }else if(section==5){
                return [MarketingTableCategory isEqualToString:@"coupon"]?2:0;
            }else if(section==6){
                return [MarketingTableCategory isEqualToString:@"promotion"]?(workingMarketing.buymorepayless?(6+(workingMarketing.bmsmacrossothersubjects?3:0)):1):0;
            }else if(section==7){
                if ([MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]) {
                    return 2;
                }else{
                    return 0;
                }
            }else if (section==8){
                if ([MarketingTableCategory isEqualToString:@"coupon"] && globalvariables.centerrecord.enablemembershippoint) {
                    return 3;
                }else{
                    return 0;
                }
            }else{
                return 1;
            }
        }
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==MarketingPopoverTable) {
        if(section==0){
            return [MyClass returntitlewithtitle:[NSString stringWithFormat:@"%@ Description",[MarketingTableCategory capitalizedString]]];
        }else if(section==1){
            if ([MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]) {
                return [MyClass returntitlewithtitle:@"Discount"];
            }else{
                return nil;
            }
        }else if(section==2){
            return [MarketingTableCategory isEqualToString:@"coupon"]?[MyClass returntitlewithtitle:@"coupon_Availability"]:[MyClass returntitlewithtitle:@"marketing_Availability"];
        }else if(section==3){
            return [MarketingTableCategory isEqualToString:@"promotion"]?[MyClass returntitlewithtitle:@"Auto Apply Early Bird Discount"]:nil;
        }else if(section==4){
            return [MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]?[MyClass returntitlewithtitle:@"Application"]:nil;
        }else if(section==5){
            return [MarketingTableCategory isEqualToString:@"coupon"]?[MyClass returntitlewithtitle:@"Validity"]:nil;
        }else if(section==6){
            return [MarketingTableCategory isEqualToString:@"promotion"]?[MyClass returntitlewithtitle:@"Buy More Pay Less"]:nil;
        }else if(section==7){
            if ([MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]) {
                return [MyClass returntitlewithtitle:@"Quota"];
            }else{
                return nil;
            }
        }else if(section==8){
            if ([MarketingTableCategory isEqualToString:@"coupon"] && globalvariables.centerrecord.enablemembershippoint) {
                return [MyClass returntitlewithtitle:@"Redemption"];
            }else{
                return nil;
            }
        }else{
            return [MyClass returntitlewithtitle:@"Remarks"];
        }
    }else if(tableView==numbertable){
        return [selectedItem isEqualToString:@"MinNumberOfClass"]?[MyClass returntitlewithtitle:@"Minimum No. of Class"]:[MyClass returntitlewithtitle:@"Quota"];
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
    if (tableView==studentListTable) {
        return 44;
    }else if (tableView==MarketingPopoverTable){
        if ([MarketingTableMode isEqualToString:@"View"]) {
            if(indexPath.section==1){
                if(indexPath.row==0){
                    if([MarketingTableCategory isEqualToString:@"coupon"]){
                        return CGFLOAT_MIN;
                    }
                }
            }else if(indexPath.section==3){
                if (![MarketingTableCategory isEqualToString:@"promotion"]) {
                    return CGFLOAT_MIN;
                }
            }else if(indexPath.section==4){
                if(indexPath.row==0){
                    if ([workingMarketing.subcategory isEqualToString:@"Sales"]) {
                        return CGFLOAT_MIN;
                    }
                }else if(indexPath.row==1){
                    if ([workingMarketing.subcategory isEqualToString:@"Class"]) {
                        return CGFLOAT_MIN;
                    }
                }
            }else if(indexPath.section==7){
                return [MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]?38:CGFLOAT_MIN;
            }
        }else{
            if(indexPath.section==0){
                if(indexPath.row==6){
                    return showCreditable?150:CGFLOAT_MIN;
                }
            }if(indexPath.section==1){
                if(indexPath.row==0){
                    if([MarketingTableCategory isEqualToString:@"coupon"]){
                        return CGFLOAT_MIN;
                    }
                }
            }else if(indexPath.section==3){
                if (![MarketingTableCategory isEqualToString:@"promotion"]) {
                    return CGFLOAT_MIN;
                }
            }else if(indexPath.section==4){
                if(indexPath.row==0){
                    if ([workingMarketing.subcategory isEqualToString:@"Sales"]) {
                        return CGFLOAT_MIN;
                    }
                }else if(indexPath.row==1){
                    if ([workingMarketing.subcategory isEqualToString:@"Class"]) {
                        return CGFLOAT_MIN;
                    }
                }
            }else if(indexPath.section==7){
                if ([MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]) {
                    if (indexPath.row==1) {
                        return showQuotaInput?150:CGFLOAT_MIN;
                    }
                }else{
                    return CGFLOAT_MIN;
                }
            }
        }
    }
    return UITableViewAutomaticDimension;
}

-(void) closesidewindow
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [MarketingPopoverTable deselectRowAtIndexPath:[MarketingPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==subjecttable){
        MyTableViewCell *myCell;
        static NSString *CellIdentifier = @"subjectcell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        myCell.label1.text=[MyClass returnsubjectnamewithsubject_shortname:((SubjectRecord *)[filteredSubjectArray objectAtIndex:indexPath.row]).subject_shortname centerkey:globalvariables.centerrecord.centerkey];
        myCell.label2.text=((SubjectRecord *)[filteredSubjectArray objectAtIndex:indexPath.row]).subject_shortname;
        myCell.imageview2.hidden=!([workingMarketing.subjectarray containsObject:((SubjectRecord *)[filteredSubjectArray objectAtIndex:indexPath.row]).subjectkey] || (workingMarketing.subjectarray && workingMarketing.subjectarray.count==0));
        
        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return myCell;
        
    }else if (tableView==producttable){
        MyTableViewCell *myCell;
        static NSString *CellIdentifier = @"productcell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        ProductRecord *obj=[filteredProductArray objectAtIndex:indexPath.row];
        
        [MyClass downloadImageWithImageview:myCell.imageview1 gender:nil type:@"product" typekey:obj.code image:@"Yes" async:YES];
        myCell.label1.text=[MyClass returnproductnamewithproductcode:obj.code centerkey:globalvariables.centerrecord.centerkey];
        myCell.label2.text=obj.code;
        
        myCell.imageview2.hidden=!([workingMarketing.productarray containsObject:((ProductRecord *)[filteredProductArray objectAtIndex:indexPath.row]).productkey] || (workingMarketing.productarray && workingMarketing.productarray.count==0));
        
        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return myCell;
        
    }else if (tableView==daytable){
        MyTableViewCell *myCell;
        static NSString *CellIdentifier = @"labelcell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if([selectedItem isEqualToString:@"EffectiveFrom"]){
            if(indexPath.row==0){
                myCell.label1.text=[MyClass returntitlewithtitle:@"Immediate"];
            }else{
                myCell.label1.text=[MyClass returntitlewithtitle:[dayListArray objectAtIndex:indexPath.row]];
            }
            myCell.imageview2.hidden=![[dayListArray objectAtIndex:indexPath.row] isEqualToString:workingMarketing.effectivefrom];
        }else{
            if(indexPath.row==0){
                myCell.label1.text=[MyClass returntitlewithtitle:@"Never"];
            }else{
                myCell.label1.text=[MyClass returntitlewithtitle:[dayListArray objectAtIndex:indexPath.row]];
            }
            myCell.imageview2.hidden=![[dayListArray objectAtIndex:indexPath.row] isEqualToString:workingMarketing.effectiveto];
        }
        
        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return myCell;
    }else if (tableView==numbertable){
        MyTableViewCell *myCell;
        static NSString *CellIdentifier = @"labelcell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if([selectedItem isEqualToString:@"MinNumberOfClass"]){
            myCell.label1.text=[MyClass returntitlewithtitle:[numberListArray objectAtIndex:indexPath.row]];
            myCell.imageview2.hidden=![[numberListArray objectAtIndex:indexPath.row] isEqualToString:[@(workingMarketing.minnoofclass) stringValue]];
        }else if([selectedItem isEqualToString:@"MinNumberOfSubject"]){
            myCell.label1.text=[MyClass returntitlewithtitle:[numberListArray objectAtIndex:indexPath.row]];
            myCell.imageview2.hidden=![[numberListArray objectAtIndex:indexPath.row] isEqualToString:[@(workingMarketing.bmsmminsubjectno) stringValue]];
        }else if([selectedItem isEqualToString:@"MinNumberOfClassPerSubject"]){
            myCell.label1.text=[MyClass returntitlewithtitle:[numberListArray objectAtIndex:indexPath.row]];
            myCell.imageview2.hidden=![[numberListArray objectAtIndex:indexPath.row] isEqualToString:[@(workingMarketing.bmsmminnoofclasspersubject) stringValue]];
        }else{
            if(indexPath.row==0){
                myCell.label1.text=[MyClass returntitlewithtitle:@"Unlimited"];
            }else{
                myCell.label1.text=[MyClass returntitlewithtitle:[numberListArray objectAtIndex:indexPath.row]];
            }
            myCell.imageview2.hidden=![[numberListArray objectAtIndex:indexPath.row] isEqualToString:workingMarketing.promotionquota];
        }
        
        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return myCell;
    }else if (tableView==MarketingPopoverTable) {
        MyTableViewCell *myCell;
        if ([MarketingTableMode isEqualToString:@"View"]) {
            if (indexPath.section==0){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"labelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=workingMarketing.description;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    static NSString *CellIdentifier = @"labelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=workingMarketing.description_chinese;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==2){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Code"];
                    myCell.label2.text=workingMarketing.code;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==3){
                    if ([MarketingTableCategory isEqualToString:@"coupon"]) {
                        static NSString *CellIdentifier = @"rolabellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Type"];
                        myCell.label2.text=[MyClass returntitlewithtitle:workingMarketing.subcategory];
                        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }else{
                        myCell.hidden=YES;
                    }
                }else if (indexPath.row==4){
                    static NSString *CellIdentifier = @"labelimagecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Cannot be used conjunction with others"];
                    [myCell.imageview1 setImage:[UIImage imageNamed:workingMarketing.cannotuseconjunctionwithothercoupons?@"checked_icon2.png":@"absent_icon2.png"]];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Creditable"];
                    myCell.label2.text=[MyClass returntitlewithtitle:workingMarketing.couponallowcredit];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==1) {
                if ([MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]) {
                    if (indexPath.row==0) {
                        
                        static NSString *CellIdentifier = @"rolabellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Type"];
                        myCell.label2.text=[MyClass returntitlewithtitle:tmpDiscountType];
                        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                        
                        if([MarketingTableCategory isEqualToString:@"coupon"]){
                            myCell.hidden=YES;
                        }
                    }else if (indexPath.row==1){
                        static NSString *CellIdentifier = @"rolabellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Amount"];
                        if (![workingMarketing.promotionpercentagediscount isEqualToString:@""]) {
                            myCell.label2.text=[NSString stringWithFormat:@"%@%@",workingMarketing.promotionpercentagediscount,@"%"];
                        }else{
                            myCell.label2.text=[NSString stringWithFormat:@"%@%@",@"$",workingMarketing.promotionfixeddiscount];
                        }
                        
                        
                        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }else if (indexPath.row==2){
                        static NSString *CellIdentifier = @"rolabellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Per Class/Quantity"];
                        myCell.label2.text=[MyClass returntitlewithtitle:workingMarketing.perclassorquantity?@"Yes":@"No"
                        ];
                        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }
                }else{
                    myCell.hidden=YES;
                }
            }else if (indexPath.section==2) {
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"From"];
                    myCell.label2.text=[MyClass returndateformatwithdate:workingMarketing.startdate];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"To2"];
                    myCell.label2.text=[MyClass returndateformatwithdate:workingMarketing.enddate];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==3) {
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Last Date"];
                    myCell.label2.text=[workingMarketing.earlybirdlastdate isEqualToString:@""]?[MyClass returntitlewithtitle:@"None"]:[MyClass convertDateFormatWithDate:workingMarketing.earlybirdlastdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                }
            }else if (indexPath.section==4) {
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Subject"];
                    if(workingMarketing.subjectarray){
                        myCell.label2.text=[MyClass returnsubjectnamewithsubjectkeys:workingMarketing.subjectarray];
                    }else{
                        myCell.label2.text=[MyClass returntitlewithtitle:@"None"];
                    }
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    myCell.hidden=[workingMarketing.subcategory isEqualToString:@"Sales"];
                }else if (indexPath.row==1){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Product"];
                    if(workingMarketing.productarray){
                        myCell.label2.text=[MyClass returnproductnamewithproductkeys:workingMarketing.productarray];
                    }else{
                        myCell.label2.text=[MyClass returntitlewithtitle:@"None"];
                    }
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    myCell.hidden=[workingMarketing.subcategory isEqualToString:@"Class"];
                }
            }else if (indexPath.section==5) {
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"From"];
                    myCell.label2.text=[MyClass returnCouponeffectivefromSetting:workingMarketing.effectivefrom];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"To2"];
                    myCell.label2.text=[MyClass returnCouponeffectivetoSetting:workingMarketing.effectiveto];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==6) {
                if (indexPath.row==0){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Buy More Pay Less"];
                    myCell.label2.text=[MyClass returntitlewithtitle:workingMarketing.buymorepayless?@"Yes":@"No"
                    ];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==1){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Auto Apply"];
                    myCell.label2.text=[MyClass returntitlewithtitle:workingMarketing.enablebuymorepayless?@"Yes":@"No"
                    ];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==2) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Enrollment From"];
                    myCell.label2.text=[MyClass convertDateFormatWithDate:workingMarketing.estartdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==3){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Enrollment End"];
                    myCell.label2.text=[MyClass convertDateFormatWithDate:workingMarketing.eenddate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==4) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Minimum No. of Class"];
                    myCell.label2.text=[@(workingMarketing.minnoofclass) stringValue];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==5){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Across Other Subjects"];
                    myCell.label2.text=[MyClass returntitlewithtitle:workingMarketing.bmsmacrossothersubjects?@"Yes":@"No"
                    ];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==6) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Minimum No. of Subject"];
                    myCell.label2.text=[@(workingMarketing.bmsmminsubjectno) stringValue];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==7) {
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Minimum No. of Class per Subject"];
                    myCell.label2.text=[@(workingMarketing.bmsmminnoofclasspersubject) stringValue];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==8){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Same Bill Month"];
                    myCell.label2.text=[MyClass returntitlewithtitle:workingMarketing.bmsmsamebillmonth?@"Yes":@"No"
                    ];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==7){
                if ([MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]) {
                    myCell.hidden=NO;
                    if (indexPath.row==0) {
                        static NSString *CellIdentifier = @"rolabellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Quota"];
                        myCell.label2.text=[workingMarketing.promotionquota isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:workingMarketing.promotionquota;
                        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }else{
                        static NSString *CellIdentifier = @"rolabellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Used"];
                        myCell.label2.text=workingMarketing.usedcount;
                        if ([MarketingRecordObject.usedcount intValue]>0) {
                            myCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        }else{
                            myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }
                    }
                    
                    
                }else{
                    myCell.hidden=YES;;
                }
            }else if (indexPath.section==8){
                if(indexPath.row==0){
                    static NSString *CellIdentifier = @"labelimagecell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Redeemable"];
                    [myCell.imageview1 setImage:[UIImage imageNamed:workingMarketing.redeemable?@"checked_icon2.png":@"absent_icon2.png"]];
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==1){
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Redeem Point"];
                    myCell.label2.text=workingMarketing.redeempoint;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                    static NSString *CellIdentifier = @"rolabellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Per Student Quota"];
                    myCell.label2.text=[workingMarketing.perstudentquota isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:workingMarketing.perstudentquota;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }else{
                static NSString *CellIdentifier = @"labelcell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                myCell.label1.text=workingMarketing.remarks;
                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                
                
            }
        }else{
            if (indexPath.section==0){
                if (indexPath.row==0) {
                    static NSString *CellIdentifier = @"gcremarkscell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.gctextview1.tag=0;
                    myCell.gctextview1.placeholder=[MyClass returntitlewithtitle:@"Description in English"];
                    myCell.gctextview1.text=workingMarketing.description;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==1){
                    static NSString *CellIdentifier = @"gcremarkscell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.gctextview1.tag=1;
                    myCell.gctextview1.placeholder=[MyClass returntitlewithtitle:@"Description in Chinese"];
                    myCell.gctextview1.text=workingMarketing.description_chinese;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==2){
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Code"];
                    myCell.textfield1.text=workingMarketing.code;
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Optional"];
                    [myCell.textfield1 addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.tag=10;
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==3){
                    static NSString *CellIdentifier = @"segmentcell2";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Type"];
                    [myCell.segmentedcontrol1 removeAllSegments];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:[MyClass returntitlewithtitle:@"All"] atIndex:0 animated:NO];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Class"] atIndex:1 animated:NO];
                    [myCell.segmentedcontrol1 insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Sales"] atIndex:2 animated:NO];
                    
                    if ([workingMarketing.subcategory isEqualToString:@"All"]) {
                        myCell.segmentedcontrol1.selectedSegmentIndex=0;
                    }else if ([workingMarketing.subcategory isEqualToString:@"Class"]){
                        myCell.segmentedcontrol1.selectedSegmentIndex=1;
                    }else if ([workingMarketing.subcategory isEqualToString:@"Sales"]){
                        myCell.segmentedcontrol1.selectedSegmentIndex=2;
                    }
                    [myCell.segmentedcontrol1 addTarget:self action:@selector(selectcoupontype:) forControlEvents: UIControlEventValueChanged];
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==4){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Cannot be used conjunction with others"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(updatecannotuseconjunctionwithothercoupons:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.on=workingMarketing.cannotuseconjunctionwithothercoupons;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==5){
                    static NSString *CellIdentifier = @"labellabelbuttoncell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Creditable"];
                    myCell.label2.text=[MyClass returntitlewithtitle:workingMarketing.couponallowcredit];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else{
                    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                    
                    if (showCreditable) {
                        NSInteger presetrow;
                        if ([couponallowcreditarray containsObject:workingMarketing.couponallowcredit]) {
                            presetrow=(int)[couponallowcreditarray indexOfObject:workingMarketing.couponallowcredit];
                        }else{
                            presetrow=0;
                        }
                        
                        UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                        UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                        [myPicker setDataSource:self];
                        [myPicker setDelegate:self];
                        myPicker.tag=802;
                        
                        [myPicker selectRow:presetrow inComponent:0 animated:NO];
                        myPickerView=myPicker;
                        [datepickerview addSubview:myPicker];
                        
                        
                        [cell.contentView addSubview:datepickerview];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                    return cell;
                }
                
                myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.section==1) {
                if ([MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]) {
                    if (indexPath.row==0) {
                        
                            if(marketingPromotionCanBeChanged || [MarketingTableMode isEqualToString:@"Add"]){
                                static NSString *CellIdentifier = @"segmentcell";
                                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                                
                                if (myCell == nil) {
                                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                                }
                                [myCell.segmentedcontrol1 removeAllSegments];
                                [myCell.segmentedcontrol1 insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Fixed"] atIndex:0 animated:NO];
                                [myCell.segmentedcontrol1 insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Percentage"] atIndex:1 animated:NO];
                                
                                if (![workingMarketing.promotionfixeddiscount isEqualToString:@""]) {
                                    myCell.segmentedcontrol1.selectedSegmentIndex=0;
                                }else{
                                    myCell.segmentedcontrol1.selectedSegmentIndex=1;
                                }
                                [myCell.segmentedcontrol1 addTarget:self action:@selector(selectdiscounttype:) forControlEvents: UIControlEventValueChanged];
                                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                                
                                if([MarketingTableCategory isEqualToString:@"coupon"]){
                                    myCell.hidden=YES;
                                }
                                
                                
                            }else{
                                static NSString *CellIdentifier = @"rolabellabelcell";
                                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                                
                                if (myCell == nil) {
                                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                                }
                                myCell.label1.text=[MyClass returntitlewithtitle:@"Type"];
                                myCell.label2.text=[MyClass returntitlewithtitle:tmpDiscountType];
                                myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                                
                                if([MarketingTableCategory isEqualToString:@"coupon"]){
                                    myCell.hidden=YES;
                                }
                            }

                    }else if (indexPath.row==1){
                        if (marketingPromotionCanBeChanged || [MarketingTableMode isEqualToString:@"Add"]) {
                            static NSString *CellIdentifier = @"labeltextcell";
                            myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                            
                            if (myCell == nil) {
                                myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                            }
                            
                            myCell.label1.text=[MyClass returntitlewithtitle:@"Amount"];
                            myCell.textfield1.text=![workingMarketing.promotionfixeddiscount isEqualToString:@""]?workingMarketing.promotionfixeddiscount:workingMarketing.promotionpercentagediscount;
                            myCell.textfield1.keyboardType = UIKeyboardTypeDecimalPad;
                            [myCell.textfield1 addTarget:self action:@selector(validateinput:)forControlEvents:UIControlEventEditingChanged];
                            myCell.textfield1.tag=0;
                            myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }else{
                            static NSString *CellIdentifier = @"rolabellabelcell";
                            myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                            
                            if (myCell == nil) {
                                myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                            }
                            myCell.label1.text=[MyClass returntitlewithtitle:@"Amount"];
                            if (![workingMarketing.promotionpercentagediscount isEqualToString:@""]) {
                                myCell.label2.text=[NSString stringWithFormat:@"%@%@",workingMarketing.promotionpercentagediscount,@"%"];
                            }else{
                                myCell.label2.text=[NSString stringWithFormat:@"%@%@",@"$",workingMarketing.promotionfixeddiscount];
                            }
                            
                            
                            myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                        }
                    }else{
                        if(marketingPromotionCanBeChanged || [MarketingTableMode isEqualToString:@"Add"]){
                            static NSString *CellIdentifier = @"labelswitchcell";
                            myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                            
                            if (myCell == nil) {
                                myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                            }

                            myCell.label1.text=[MyClass returntitlewithtitle:@"Per Class/Quantity"];
                            [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                            [myCell.switch1 addTarget:self action:@selector(updateperclassorquantity:) forControlEvents:UIControlEventValueChanged];
                            myCell.switch1.on=workingMarketing.perclassorquantity;
                            myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                        }else{
                            static NSString *CellIdentifier = @"rolabellabelcell";
                            myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                            
                            if (myCell == nil) {
                                myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                            }
                            myCell.label1.text=[MyClass returntitlewithtitle:@"Per Class/Quantity"];
                            myCell.label2.text=[MyClass returntitlewithtitle:workingMarketing.perclassorquantity?@"Yes":@"No"];
                            myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                        }                        
                    }
                }else{
                    myCell.hidden=YES;
                }
            }else if (indexPath.section==2) {
                if (indexPath.row==0){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"From"];
                    myCell.label2.text=[MyClass returndateformatwithdate:workingMarketing.startdate];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if  (indexPath.row==1){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"To2"];
                    myCell.label2.text=[MyClass returndateformatwithdate:workingMarketing.enddate];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }
            }else if (indexPath.section==3) {
                if (indexPath.row==0){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Last Date"];
                    myCell.label2.text=[workingMarketing.earlybirdlastdate isEqualToString:@""]?[MyClass returntitlewithtitle:@"None"]:[MyClass convertDateFormatWithDate:workingMarketing.earlybirdlastdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }
            }else if (indexPath.section==4) {
                if (marketingPromotionCanBeChanged || [MarketingTableMode isEqualToString:@"Add"]) {
                    if (indexPath.row==0){
                        static NSString *CellIdentifier = @"labellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Subject"];
                        if(workingMarketing.subjectarray){
                            myCell.label2.text=[MyClass returnsubjectnamewithsubjectkeys:workingMarketing.subjectarray];
                        }else{
                            myCell.label2.text=[MyClass returntitlewithtitle:@"None"];
                        }
                        myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        myCell.hidden=[workingMarketing.subcategory isEqualToString:@"Sales"];
                    }else if  (indexPath.row==1){
                        static NSString *CellIdentifier = @"labellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Product"];
                        if(workingMarketing.productarray){
                            myCell.label2.text=[MyClass returnproductnamewithproductkeys:workingMarketing.productarray];
                        }else{
                            myCell.label2.text=[MyClass returntitlewithtitle:@"None"];
                        }
                        myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                        myCell.hidden=[workingMarketing.subcategory isEqualToString:@"Class"];
                    }
                }else{
                    if (indexPath.row==0) {
                        static NSString *CellIdentifier = @"rolabellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Subject"];
                        if(workingMarketing.subjectarray){
                            myCell.label2.text=[MyClass returnsubjectnamewithsubjectkeys:workingMarketing.subjectarray];
                        }else{
                            myCell.label2.text=[MyClass returntitlewithtitle:@"None"];
                        }
                        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                        
                    }else if (indexPath.row==1){
                        static NSString *CellIdentifier = @"rolabellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Product"];
                        if(workingMarketing.productarray){
                            myCell.label2.text=[MyClass returnproductnamewithproductkeys:workingMarketing.productarray];
                        }else{
                            myCell.label2.text=[MyClass returntitlewithtitle:@"None"];
                        }
                        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }
                }
            }else if (indexPath.section==5) {
                if (indexPath.row==0){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"From"];
                    myCell.label2.text=[MyClass returnCouponeffectivefromSetting:workingMarketing.effectivefrom];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if  (indexPath.row==1){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"To2"];
                    myCell.label2.text=[MyClass returnCouponeffectivetoSetting:workingMarketing.effectiveto];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }
            }else if (indexPath.section==6) {
                if (indexPath.row==0){
                    if(marketingPromotionCanBeChanged || [MarketingTableMode isEqualToString:@"Add"]){
                        static NSString *CellIdentifier = @"labelswitchcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }

                        myCell.label1.text=[MyClass returntitlewithtitle:@"Buy More Pay Less"];
                        [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                        [myCell.switch1 addTarget:self action:@selector(updatebuymorepayless:) forControlEvents:UIControlEventValueChanged];
                        myCell.switch1.on=workingMarketing.buymorepayless;
                        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }else{
                        static NSString *CellIdentifier = @"rolabellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Buy More Pay Less"];
                        myCell.label2.text=[MyClass returntitlewithtitle:workingMarketing.buymorepayless?@"Yes":@"No"];
                        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }
                }else if (indexPath.row==1){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Auto Apply"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(updateenablebuymorepayless:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.on=workingMarketing.enablebuymorepayless;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==2){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Enrollment From"];
                    myCell.label2.text=[MyClass convertDateFormatWithDate:workingMarketing.estartdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if  (indexPath.row==3){
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Enrollment End"];
                    myCell.label2.text=[MyClass convertDateFormatWithDate:workingMarketing.eenddate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy"];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if (indexPath.row==4) {
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Minimum No. of Class"];
                    myCell.label2.text=[@(workingMarketing.minnoofclass) stringValue];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if (indexPath.row==5){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Across Other Subjects"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(updatebmsmacrossothersubjects:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.on=workingMarketing.bmsmacrossothersubjects;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==6) {
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Minimum No. of Subject"];
                    myCell.label2.text=[@(workingMarketing.bmsmminsubjectno) stringValue];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if (indexPath.row==7) {
                    static NSString *CellIdentifier = @"labellabelcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Minimum No. of Class per Subject"];
                    myCell.label2.text=[@(workingMarketing.bmsmminnoofclasspersubject) stringValue];
                    myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                }else if (indexPath.row==8){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Same Bill Month"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(updatebmsmsamebillmonth:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.on=workingMarketing.bmsmsamebillmonth;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==7){
                if ([MarketingTableCategory isEqualToString:@"promotion"] || [MarketingTableCategory isEqualToString:@"coupon"]) {
                    
                    if (indexPath.row==0) {
                        static NSString *CellIdentifier = @"labellabelcell";
                        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                        
                        if (myCell == nil) {
                            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                        }
                        myCell.label1.text=[MyClass returntitlewithtitle:@"Quota"];
                        myCell.label2.text=[workingMarketing.promotionquota isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:workingMarketing.promotionquota;
                        myCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                        
                        if (showQuotaInput) {
                            NSInteger presetrow;
                            if ([quotaarray containsObject:workingMarketing.promotionquota]) {
                                presetrow=(int)[quotaarray indexOfObject:workingMarketing.promotionquota];
                            }else{
                                presetrow=0;
                            }
                            
                            UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                            UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                            [myPicker setDataSource:self];
                            [myPicker setDelegate:self];
                            myPicker.tag=802;
                            
                            [myPicker selectRow:presetrow inComponent:0 animated:NO];
                            myPickerView=myPicker;
                            [datepickerview addSubview:myPicker];
                            
                            
                            [cell.contentView addSubview:datepickerview];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }else{
                            cell.hidden=YES;
                        }
                        return cell;
                    }
                    

                    
                }else{
                    myCell.hidden=YES;;
                }
            }else if (indexPath.section==8){
                if(indexPath.row==0){
                    static NSString *CellIdentifier = @"labelswitchcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }

                    myCell.label1.text=[MyClass returntitlewithtitle:@"Redeemable"];
                    [myCell.switch1 removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
                    [myCell.switch1 addTarget:self action:@selector(updateredeemable:) forControlEvents:UIControlEventValueChanged];
                    myCell.switch1.on=workingMarketing.redeemable;
                    myCell.selectionStyle=UITableViewCellSelectionStyleNone;
                }else if(indexPath.row==1){
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Redeem Point"];
                    myCell.textfield1.text=workingMarketing.redeempoint;
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Redeem Point"];
                    [myCell.textfield1 addTarget:self action:@selector(validateinput:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.keyboardType = UIKeyboardTypeDecimalPad;
                    myCell.textfield1.tag=1;
                    
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                    static NSString *CellIdentifier = @"labeltextcell";
                    myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                    
                    if (myCell == nil) {
                        myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    }
                    myCell.label1.text=[MyClass returntitlewithtitle:@"Per Student Quota"];
                    myCell.textfield1.text=workingMarketing.perstudentquota;
                    myCell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Unlimited"];
                    [myCell.textfield1 addTarget:self action:@selector(validateinput:) forControlEvents:UIControlEventEditingChanged];
                    myCell.textfield1.keyboardType = UIKeyboardTypeDecimalPad;
                    myCell.textfield1.tag=2;
                    
                    myCell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }else{// if (indexPath.section==3){
                static NSString *CellIdentifier = @"remarkscell";
                myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (myCell == nil) {
                    myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                myCell.textview1.tag=2;
                myCell.textview1.text=workingMarketing.remarks;
                myCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        return myCell;

    }else if (tableView==studentListTable){
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        
        UILabel *studentnamelabel;
        UILabel *studentidlabel;
        UIImageView *studentimageview;
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //add switch, label and button
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
            
            
            
            studentimageview=[[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 34, 34)];
            studentimageview.layer.cornerRadius=17;
            studentimageview.backgroundColor=[UIColor lightGrayColor];
            studentimageview.tag=703;
            studentimageview.contentMode=UIViewContentModeScaleAspectFill;
            studentimageview.layer.masksToBounds=YES;
            [cell.contentView addSubview:studentimageview];
            
        }else{
            studentnamelabel=(UILabel *)[cell.contentView viewWithTag:701];
            studentidlabel=(UILabel *)[cell.contentView viewWithTag:702];
            studentimageview=(UIImageView *)[cell.contentView viewWithTag:703];
        }
        
        studentobject=[filteredStudentListArray objectAtIndex:indexPath.row];
        
        studentnamelabel.text=[MyClass returnStudentnameWithStudentkey:studentobject.studentkey option:@"fullbutid"];
        studentidlabel.text=studentobject.studentid;
        
        if ([studentobject.studentid isEqualToString:@""]) {
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
        
        [MyClass downloadImageWithImageview:studentimageview gender:studentobject.gender type:@"student" typekey:studentobject.studentkey image:studentobject.image async:YES];
        
        return cell;
        
        
    }
    return nil;
    
}


-(void) unlimitedquotabuttonpressed
{
    workingMarketing.promotionquota=@"";
    showQuotaInput=NO;
    [self adjusttablesize];
    [MarketingPopoverTable reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==subjecttable){

        NSString *selecteditem=((SubjectRecord *)[filteredSubjectArray objectAtIndex:indexPath.row]).subjectkey;
        if (workingMarketing.subjectarray && workingMarketing.subjectarray.count==0) {
            for (int i=0; i<subjectArray.count; i++) {
                if (![selecteditem isEqualToString:((SubjectRecord *)[subjectArray objectAtIndex:i]).subjectkey]) {
                    [workingMarketing.subjectarray addObject:((SubjectRecord *)[subjectArray objectAtIndex:i]).subjectkey];
                }
            }
        }else{
            if(!workingMarketing.subjectarray){
                workingMarketing.subjectarray=[[NSMutableArray alloc]init];
            }
            if ([workingMarketing.subjectarray containsObject:selecteditem]) {
                [workingMarketing.subjectarray removeObject:selecteditem];
                if(workingMarketing.subjectarray.count==0){
                    workingMarketing.subjectarray=nil;
                }
            }else{
                [workingMarketing.subjectarray addObject:selecteditem];
                if(workingMarketing.subjectarray.count==subjectArray.count){
                    workingMarketing.subjectarray=[[NSMutableArray alloc]init];
                }
            }
        }
        
        [subjecttable reloadData];
        [MarketingPopoverTable reloadData];
    }else if (tableView==producttable){
        NSString *selecteditem=((ProductRecord *)[filteredProductArray objectAtIndex:indexPath.row]).productkey;
        if (workingMarketing.productarray && workingMarketing.productarray.count==0) {
            for (int i=0; i<ProductArray.count; i++) {
                if (![selecteditem isEqualToString:((ProductRecord *)[ProductArray objectAtIndex:i]).productkey]) {
                    [workingMarketing.productarray addObject:((ProductRecord *)[ProductArray objectAtIndex:i]).productkey];
                }
            }
        }else{
            if(!workingMarketing.productarray){
                workingMarketing.productarray=[[NSMutableArray alloc]init];
            }
            if ([workingMarketing.productarray containsObject:selecteditem]) {
                [workingMarketing.productarray removeObject:selecteditem];
                if(workingMarketing.productarray.count==0){
                    workingMarketing.productarray=nil;
                }
            }else{
                [workingMarketing.productarray addObject:selecteditem];
                if(workingMarketing.productarray.count==ProductArray.count){
                    workingMarketing.productarray=[[NSMutableArray alloc]init];
                }
            }
        }
        [producttable reloadData];
        [MarketingPopoverTable reloadData];
    }else if (tableView==MarketingPopoverTable) {
        if (indexPath.section==0 && indexPath.row==5  && ![MarketingTableMode isEqualToString:@"View"]){
            selectedItem=@"Creditable";
            if (showCreditable==YES) {
                showCreditable=NO;
            }else{
                showCreditable=YES;
                showQuotaInput=NO;
            }
            
            [MarketingPopoverTable reloadData];
            
            [self adjusttablesize];
        }else if (indexPath.section==2 && indexPath.row==0 && ![MarketingTableMode isEqualToString:@"View"]) {
            
            selectedItem=@"StartDate";

            
            if ([workingMarketing.startdate isEqualToString:@""]) {
                [df setDateFormat:@"dd-MMM-yyyy"];
                workingMarketing.startdate=[df stringFromDate:[NSDate date]];
            }
            
            datetitle.text=[MyClass returntitlewithtitle:@"Availablity From"];
            [noneButton setTitle:@"" forState:UIControlStateNormal];
            [self showsidewindowwithwindow:@"showDateTable"];
            [datecalendarview scrollToSelectedDateWithSelectedDateArray:[workingMarketing.startdate isEqualToString:@""]?[[NSMutableArray alloc]init]:[[NSMutableArray alloc]initWithObjects:workingMarketing.startdate, nil] ScrollToDate:workingMarketing.startdate  instructorselected:@"All"];

            [MarketingPopoverTable reloadData];
            
            [self adjusttablesize];
            
        }else if (indexPath.section==2 && indexPath.row==1 && ![MarketingTableMode isEqualToString:@"View"]) {
            //pickerview for assignto
            
            selectedItem=@"EndDate";

            if ([workingMarketing.enddate isEqualToString:@""]) {
                [df setDateFormat:@"dd-MMM-yyyy"];
                workingMarketing.enddate=[df stringFromDate:[NSDate date]];
            }
            
            datetitle.text=[MyClass returntitlewithtitle:@"Availablity To"];
            [noneButton setTitle:@"" forState:UIControlStateNormal];
            [self showsidewindowwithwindow:@"showDateTable"];
            [datecalendarview scrollToSelectedDateWithSelectedDateArray:[workingMarketing.enddate isEqualToString:@""]?[[NSMutableArray alloc]init]:[[NSMutableArray alloc]initWithObjects:workingMarketing.enddate, nil] ScrollToDate:workingMarketing.enddate  instructorselected:@"All"];
            [MarketingPopoverTable reloadData];
            
            [self adjusttablesize];
            
        }else if (indexPath.section==3 && ![MarketingTableMode isEqualToString:@"View"]) {
            //pickerview for assignto
            
            selectedItem=@"EarlyBirdLastDate";

            datetitle.text=[MyClass returntitlewithtitle:@"Last Date"];
            [noneButton setTitle:@"None" forState:UIControlStateNormal];
            [self showsidewindowwithwindow:@"showDateTable"];
            [datecalendarview scrollToSelectedDateWithSelectedDateArray:[workingMarketing.earlybirdlastdate isEqualToString:@""]?[[NSMutableArray alloc]init]:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:workingMarketing.earlybirdlastdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO], nil] ScrollToDate:[workingMarketing.earlybirdlastdate isEqualToString:@""]?[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"]:nil  instructorselected:@"All"];
            [MarketingPopoverTable reloadData];
            
            [self adjusttablesize];
            
        }else if (indexPath.section==4 && indexPath.row==0 && ![MarketingTableMode isEqualToString:@"View"]) {
            
            selectedItem=@"Subject";
            
//            subjecttitle.text=[MyClass returntitlewithtitle:@"Subject"];
            [subjectNoneButton setTitle:[MyClass returntitlewithtitle:@"None"] forState:UIControlStateNormal];
            [subjectAllButton setTitle:[MyClass returntitlewithtitle:@"All"] forState:UIControlStateNormal];
            [self showsidewindowwithwindow:@"showSubjectTable"];

            [MarketingPopoverTable reloadData];
            
            [self adjusttablesize];
            
        }else if (indexPath.section==4 && indexPath.row==1 && ![MarketingTableMode isEqualToString:@"View"]) {
            //pickerview for assignto
            
            selectedItem=@"Product";
            
//            producttitle.text=[MyClass returntitlewithtitle:@"Product"];
            [productNoneButton setTitle:[MyClass returntitlewithtitle:@"None"] forState:UIControlStateNormal];
            [productAllButton setTitle:[MyClass returntitlewithtitle:@"All"] forState:UIControlStateNormal];
            [self showsidewindowwithwindow:@"showProductTable"];
            [MarketingPopoverTable reloadData];
            
            [self adjusttablesize];
            
        }else if (indexPath.section==5 && ![MarketingTableMode isEqualToString:@"View"]){
            if(indexPath.row==0){
                selectedItem=@"EffectiveFrom";
                if([workingMarketing.effectivefrom rangeOfString:@"-"].location!=NSNotFound){
                    datetitle.text=[MyClass returntitlewithtitle:@"Valid From"];
                    [noneButton setTitle:[MyClass returntitlewithtitle:@"Day after issue"] forState:UIControlStateNormal];
                    [self showsidewindowwithwindow:@"showDateTable"];
                    [datecalendarview scrollToSelectedDateWithSelectedDateArray:[workingMarketing.effectivefrom isEqualToString:@""]?[[NSMutableArray alloc]init]:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:workingMarketing.effectivefrom FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO], nil] ScrollToDate:[workingMarketing.effectivefrom isEqualToString:@""]?[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"]:nil  instructorselected:@"All"];
                }else{
                    daytitle.text=[MyClass returntitlewithtitle:@"Valid From"];
                    [daynoneButton setTitle:[MyClass returntitlewithtitle:@"Calendar"] forState:UIControlStateNormal];
                    
                    [self showsidewindowwithwindow:@"showDayTable"];
                    [self returnDayListArray];
                    [daytable reloadData];
                }
                
            }else if(indexPath.row==1){
                selectedItem=@"EffectiveTo";
                if([workingMarketing.effectiveto rangeOfString:@"-"].location!=NSNotFound){
                    datetitle.text=[MyClass returntitlewithtitle:@"Valid To"];
                    [noneButton setTitle:[MyClass returntitlewithtitle:@"Day after from"] forState:UIControlStateNormal];
                    [self showsidewindowwithwindow:@"showDateTable"];
                    [datecalendarview scrollToSelectedDateWithSelectedDateArray:[workingMarketing.effectiveto isEqualToString:@""]?[[NSMutableArray alloc]init]:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:workingMarketing.effectiveto FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO], nil] ScrollToDate:[workingMarketing.effectiveto isEqualToString:@""]?[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"]:nil  instructorselected:@"All"];
                }else{
                    daytitle.text=[MyClass returntitlewithtitle:@"Valid To"];
                    [daynoneButton setTitle:[MyClass returntitlewithtitle:@"Calendar"] forState:UIControlStateNormal];
                    [self showsidewindowwithwindow:@"showDayTable"];
                    [self returnDayListArray];
                    [daytable reloadData];
                }
            }
            noneButton.tag=indexPath.row;
            daynoneButton.tag=indexPath.row;
            
            [MarketingPopoverTable reloadData];
            [self adjusttablesize];
            
        }else if (indexPath.section==6 && ![MarketingTableMode isEqualToString:@"View"]){
            if(indexPath.row==2){
                selectedItem=@"EnrollmentFrom";
//                if([workingMarketing.effectivefrom rangeOfString:@"-"].location!=NSNotFound){
                    datetitle.text=[MyClass returntitlewithtitle:@"Enrollment From"];
                    [noneButton setTitle:[MyClass returntitlewithtitle:@"Day after issue"] forState:UIControlStateNormal];
                noneButton.hidden=YES;
                    [self showsidewindowwithwindow:@"showDateTable"];
                [datecalendarview scrollToSelectedDateWithSelectedDateArray:[workingMarketing.estartdate isEqualToString:@""]?[[NSMutableArray alloc]init]:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:workingMarketing.estartdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO], nil] ScrollToDate:[workingMarketing.estartdate isEqualToString:@""]?[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"]:nil  instructorselected:@"All"];
//                }else{
//                    daytitle.text=[MyClass returntitlewithtitle:@"Enrollment From"];
//                    [daynoneButton setTitle:[MyClass returntitlewithtitle:@"Calendar"] forState:UIControlStateNormal];
//                    
//                    [self showsidewindowwithwindow:@"showDayTable"];
//                    [self returnDayListArray];
//                    [daytable reloadData];
//                }
                
            }else if(indexPath.row==3){
                selectedItem=@"EnrollmentEnd";
//                if([workingMarketing.effectiveto rangeOfString:@"-"].location!=NSNotFound){
                    datetitle.text=[MyClass returntitlewithtitle:@"Enrollment End"];
//                    [noneButton setTitle:[MyClass returntitlewithtitle:@"Day after from"] forState:UIControlStateNormal];
                noneButton.hidden=YES;
                    [self showsidewindowwithwindow:@"showDateTable"];
                [datecalendarview scrollToSelectedDateWithSelectedDateArray:[workingMarketing.eenddate isEqualToString:@""]?[[NSMutableArray alloc]init]:[[NSMutableArray alloc]initWithObjects:[MyClass convertDateFormatWithDate:workingMarketing.eenddate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO], nil] ScrollToDate:[workingMarketing.eenddate isEqualToString:@""]?[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"]:nil  instructorselected:@"All"];
//                }else{
//                    daytitle.text=[MyClass returntitlewithtitle:@"Valid To"];
//                    [daynoneButton setTitle:[MyClass returntitlewithtitle:@"Calendar"] forState:UIControlStateNormal];
//                    [self showsidewindowwithwindow:@"showDayTable"];
//                    [self returnDayListArray];
//                    [daytable reloadData];
//                }
            }else if(indexPath.row==4){
                selectedItem=@"MinNumberOfClass";
                numbertitle.text=[MyClass returntitlewithtitle:@"Minimum No. of Class"];
                
                [self showsidewindowwithwindow:@"showNumberTable"];
                [self returnNumberListArray];
                [numbertable reloadData];
            }else if(indexPath.row==6){
                selectedItem=@"MinNumberOfSubject";
                numbertitle.text=[MyClass returntitlewithtitle:@"Minimum No. of Subject"];
                
                [self showsidewindowwithwindow:@"showNumberTable"];
                [self returnNumberListArray];
                [numbertable reloadData];
            }else if(indexPath.row==7){
                selectedItem=@"MinNumberOfClassPerSubject";
                numbertitle.text=[MyClass returntitlewithtitle:@"Minimum No. of Class per Subject"];
                
                [self showsidewindowwithwindow:@"showNumberTable"];
                [self returnNumberListArray];
                [numbertable reloadData];
            }

            
            [MarketingPopoverTable reloadData];
            [self adjusttablesize];
            
        }else if (indexPath.section==7 && indexPath.row==0 && ![MarketingTableMode isEqualToString:@"View"]) {
            //pickerview for assignto
            selectedItem=@"Quota";
//            if (showQuotaInput==YES) {
//                showQuotaInput=NO;
//            }else{
//                showQuotaInput=YES;
//                showCreditable=NO;
//            }
            
            [self showsidewindowwithwindow:@"showNumberTable"];
            [self returnNumberListArray];
            [numbertable reloadData];
            
            [MarketingPopoverTable reloadData];
            
            [self adjusttablesize];
            
        }else if (indexPath.section==7 && indexPath.row==1 && [MarketingTableMode isEqualToString:@"View"] && [MarketingRecordObject.usedcount intValue]>0){
            studentlistsearchbar.text=@"";
            [self showsidewindowwithwindow:@"showStudentList"];
            
            [self adjusttablesize];
        }

    }else if (tableView==studentListTable){
        if(![MyClass showMenuItemwithObject:@"Student Profile"]){
            return;
        }
        
        [self startsidewindowanimationwithwidth:804];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
            

            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=((Student *)[filteredStudentListArray objectAtIndex:indexPath.row]).remarks;
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:((Student *)[filteredStudentListArray objectAtIndex:indexPath.row]).studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];

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
        
        
    }else if (tableView==daytable){
        if([selectedItem isEqualToString:@"EffectiveFrom"]){
            workingMarketing.effectivefrom=[dayListArray objectAtIndex:indexPath.row];
        }else{
            workingMarketing.effectiveto=[dayListArray objectAtIndex:indexPath.row];
        }
        [daytable reloadData];
        [MarketingPopoverTable reloadData];
    }else if (tableView==numbertable){
        if([selectedItem isEqualToString:@"MinNumberOfClass"]){
            workingMarketing.minnoofclass=[[numberListArray objectAtIndex:indexPath.row] integerValue];
        }else if([selectedItem isEqualToString:@"MinNumberOfSubject"]){
            workingMarketing.bmsmminsubjectno=[[numberListArray objectAtIndex:indexPath.row] integerValue];
        }else if([selectedItem isEqualToString:@"MinNumberOfClassPerSubject"]){
            workingMarketing.bmsmminnoofclasspersubject=[[numberListArray objectAtIndex:indexPath.row] integerValue];
        }else{
            workingMarketing.promotionquota=[numberListArray objectAtIndex:indexPath.row];
        }
        [numbertable reloadData];
        [MarketingPopoverTable reloadData];
    }
    
}

-(void) updateperclassorquantity:(UISwitch *)sender
{
    workingMarketing.perclassorquantity=sender.on;
}

-(void) updatebuymorepayless:(UISwitch *)sender
{
    workingMarketing.buymorepayless=sender.on;
    [MarketingPopoverTable reloadData];
}

-(void) updateenablebuymorepayless:(UISwitch *)sender
{
    workingMarketing.enablebuymorepayless=sender.on;
}

-(void) updatebmsmacrossothersubjects:(UISwitch *)sender
{
    workingMarketing.bmsmacrossothersubjects=sender.on;
    [MarketingPopoverTable reloadData];
}

-(void) updatebmsmsamebillmonth:(UISwitch *)sender
{
    workingMarketing.bmsmsamebillmonth=sender.on;
    [MarketingPopoverTable reloadData];
}

-(void) closesidetable
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [MarketingPopoverTable deselectRowAtIndexPath:[MarketingPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==studentlistsearchbar) {
        [self returnfilterstudentlistarray];
        [studentListTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==productsearchbar) {
        if ([searchText isEqualToString:@""]) {
            filteredProductArray=[[NSMutableArray alloc]initWithArray:ProductArray];
            [self sortFilteredProductArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.englishname contains[c] %@ or self.chinesename contains[c] %@",searchText,searchText];
            filteredProductArray=[[NSMutableArray alloc]initWithArray:[ProductArray filteredArrayUsingPredicate:predicate]];
            [self sortFilteredProductArray];
        }
        [producttable reloadData];
        [producttable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==subjectsearchbar) {
        if ([searchText isEqualToString:@""]) {
            filteredSubjectArray=[[NSMutableArray alloc]initWithArray:subjectArray];
            [self sortFilteredSubjectArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.subject_shortname contains[c] %@ or self.subject_englishname contains[c] %@ or self.subject_chinesename contains[c] %@",searchText,searchText,searchText];
            filteredSubjectArray=[[NSMutableArray alloc]initWithArray:[subjectArray filteredArrayUsingPredicate:predicate]];
            [self sortFilteredSubjectArray];
        }
        [subjecttable reloadData];
        [subjecttable setContentOffset:CGPointZero animated:YES];
    }
}

-(void) returnfilterstudentlistarray
{
    if ([studentlistsearchbar.text isEqualToString:@""]) {
        filteredStudentListArray= [[NSMutableArray alloc]initWithArray:studentListArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or self.studentid contains[c] %@",studentlistsearchbar.text,studentlistsearchbar.text,studentlistsearchbar.text];
        filteredStudentListArray= [[NSMutableArray alloc]initWithArray:[studentListArray filteredArrayUsingPredicate:predicate]];
    }

    [self sortstudentlist];
}

-(void) sortstudentlist
{
    /*NSSortDescriptor *sortdescriptor1= [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortdescriptor2= [NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortdescriptor3= [NSSortDescriptor sortDescriptorWithKey:@"studentid" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]initWithObjects:sortdescriptor1,sortdescriptor2,sortdescriptor3, nil];*/
    
    NSMutableArray *sortDescriptorsArray=[MyClass returnstudentnamesortdescriptorarray];
    
    filteredStudentListArray=[NSMutableArray arrayWithArray:[filteredStudentListArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    [studentListTable reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==studentListTable) {
        return CGFLOAT_MIN;
    }else if (tableView==daytable) {
        return CGFLOAT_MIN;
    }else if (tableView==subjecttable) {
        return CGFLOAT_MIN;
    }else if (tableView==producttable) {
        return CGFLOAT_MIN;
    }else{
        /*if (section==1) {
            if (![MarketingTableCategory isEqualToString:@"coupon"]) {
                return CGFLOAT_MIN;
            }
        }else */if (section==1) {
            if (![MarketingTableCategory isEqualToString:@"promotion"]&& ![MarketingTableCategory isEqualToString:@"coupon"]) {
                return CGFLOAT_MIN;
            }
        }else if (section==3){
            if (![MarketingTableCategory isEqualToString:@"promotion"]) {
                return CGFLOAT_MIN;
            }
        }else if (section==4){
            if (![MarketingTableCategory isEqualToString:@"promotion"]&& ![MarketingTableCategory isEqualToString:@"coupon"]) {
                return CGFLOAT_MIN;
            }
        }else if (section==5) {
            if (![MarketingTableCategory isEqualToString:@"coupon"]) {
                return CGFLOAT_MIN;
            }
        }else if (section==6) {
            if (![MarketingTableCategory isEqualToString:@"promotion"]) {
                return CGFLOAT_MIN;
            }
        }else if (section==7){
            if (![MarketingTableCategory isEqualToString:@"promotion"]&& ![MarketingTableCategory isEqualToString:@"coupon"]) {
                return CGFLOAT_MIN;
            }
        }else if (section==8) {
            if (![MarketingTableCategory isEqualToString:@"coupon"] || !globalvariables.centerrecord.enablemembershippoint) {
                return CGFLOAT_MIN;
            }
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if ([tableView numberOfSections]-1==section) {
        return 30;
    }
    return CGFLOAT_MIN;
}

-(void) returnDayListArray
{
    dayListArray=[[NSMutableArray alloc]init];
    if([selectedItem isEqualToString:@"EffectiveFrom"]){
        for(int i=0;i<100;i++){
            [dayListArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }else{
        [dayListArray addObject:@""];
        for(int i=1;i<=365;i++){
            [dayListArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
}

-(void) returnNumberListArray
{
    numberListArray=[[NSMutableArray alloc]init];
    if([selectedItem isEqualToString:@"MinNumberOfClass"] || [selectedItem isEqualToString:@"MinNumberOfSubject"] || [selectedItem isEqualToString:@"MinNumberOfClassPerSubject"]){
        for(int i=0;i<=1000;i++){
            [numberListArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }else{
        [numberListArray addObject:@""];
        for(int i=0;i<=1000;i++){
            [numberListArray addObject:[NSString stringWithFormat:@"%d",i]];
        }
    }
}


-(void) selectdiscounttype:(UISegmentedControl *)sender
{
    tmpDiscountType=sender.selectedSegmentIndex==0?@"Fixed":@"Percentage";
    if ([tmpDiscountType isEqualToString:@"Fixed"]) {
        workingMarketing.promotionfixeddiscount=workingMarketing.promotionpercentagediscount;
        workingMarketing.promotionpercentagediscount=@"";
    }else{
        workingMarketing.promotionpercentagediscount=workingMarketing.promotionfixeddiscount;
        workingMarketing.promotionfixeddiscount=@"";
        if ([workingMarketing.promotionpercentagediscount intValue]>100) {
            workingMarketing.promotionpercentagediscount=@"100";
            [MarketingPopoverTable reloadData];
        }
    }
}

-(void) selectcoupontype:(UISegmentedControl *)sender
{
    if(sender.selectedSegmentIndex==0){
        workingMarketing.subcategory=@"All";
    }else if(sender.selectedSegmentIndex==1){
        workingMarketing.subcategory=@"Class";
    }else{
        workingMarketing.subcategory=@"Sales";
    }
    [MarketingPopoverTable reloadData];
}
    
-(void) updatetextfield:(UITextField *)textfield
{
    if (textfield.tag==10) {
        workingMarketing.code=textfield.text;
    }
}

- (void) validateinput:(UITextField *)sender {
    
    if (sender.tag==0) {
        if (![MyClass checkvalidfeeinput:sender.text]) {
            sender.text=[tmpDiscountType isEqualToString:@"Fixed"]?workingMarketing.promotionfixeddiscount: workingMarketing.promotionpercentagediscount;
        }else if ([tmpDiscountType isEqualToString:@"Percentage"] && [sender.text intValue]>100){
            sender.text=workingMarketing.promotionpercentagediscount;
        }else{
            if([tmpDiscountType isEqualToString:@"Fixed"]){
                workingMarketing.promotionfixeddiscount=sender.text;
            }else{
                workingMarketing.promotionpercentagediscount=sender.text;
            }
        }
    }else if(sender.tag==1){
        if(![MyClass checkValidInput:sender.text Type:@"ZeroInteger"]){
            sender.text=workingMarketing.redeempoint;
        }else{
            workingMarketing.redeempoint=sender.text;
        }
    }else if(sender.tag==2){
        if(![MyClass checkValidInput:sender.text Type:@"EmptyInteger"]){
            sender.text=workingMarketing.perstudentquota;
        }else{
            workingMarketing.perstudentquota=sender.text;
        }
    }
}

-(void) deletemarketing
{
    NSString *strURL;
    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletemarketingrecord&marketingkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,MarketingRecordObject.marketingkey];
    
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
        [self.delegate dismissMarketingPopover];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
}


-(IBAction) deleteButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    UIAlertController *deletemarketingalert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@ %@",[MyClass returntitlewithtitle:@"Delete"],[MyClass returntitlewithtitle:[MarketingTableCategory capitalizedString]],[MyClass returntitlewithtitle:@"Record"]] message:[MyClass returntitlewithtitle:@"Are you sure to delete the record?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        NSString *result=[self checkifmarketingused:MarketingRecordObject.marketingkey];
        if (result) {
            if ([result isEqualToString:@"No"]) {
                [self deletemarketing];
            }else{
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Marketing cannot be deleted"] message:[MyClass returntitlewithtitle:@"The marketing has been used"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
            }
        }
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [deletemarketingalert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [deletemarketingalert addAction:OKAction];
    [deletemarketingalert addAction:CancelAction];
    
    [self presentViewController:deletemarketingalert animated:YES completion:nil];
    //[self presentViewController:deletemarketingalert View:self];
    

}

-(NSString *) checkifmarketingused:(NSString *)marketingkey
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievemarketingcount&marketingkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,marketingkey];
    
    __block BOOL result=FALSE;
    __block NSString *marketingused;

    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSString *strResult = jsonreturned[@"content"];
            if ([strResult intValue] > 0) {
                marketingused= @"Yes";
            }else{
                marketingused= @"No";
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
                marketingused= @"Yes";
            }else{
                marketingused= @"No";
            }
        }
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (!result) {
        [MyClass showconnectionlostdialogbox];
    }*/
    
    return marketingused;
}

-(IBAction) editButtonPressed:(id)sender{
    
    //[self retrieveMarketingPromotionWithMarketingKey:MarketingRecordObject.marketingkey];
    
    marketingPromotionCanBeChanged=[MarketingRecordObject.usedcount intValue]>0?NO:YES;
    
    MarketingTableMode=@"Edit";
    if (![self InitializeField]) {
        MarketingTableMode=@"View";
        return;
    }
    [self showsidewindowwithwindow:@"none"];
    
    [MarketingPopoverTable reloadData];
    [self adjusttablesize];
    
}


-(IBAction) doneButtonPressed:(id)sender
{
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }
    
    workingMarketing.description=[MyClass leadingtrailingspacestrimmed:workingMarketing.description];
    workingMarketing.description_chinese=[MyClass leadingtrailingspacestrimmed:workingMarketing.description_chinese];
    
    [MarketingPopoverTable reloadData];

    
    if ([workingMarketing.description isEqualToString:@""] && [workingMarketing.description_chinese isEqualToString:@""]) {
        UIAlertController *errorinputalert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",[MarketingTableCategory capitalizedString],[MyClass returntitlewithtitle:@"Record"]] message:[MyClass returntitlewithtitle:@"Please input the description"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [errorinputalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [errorinputalert addAction:OKAction];
        //[self presentViewController:errorinputalert animated:YES completion:nil];
        [MyClass presentViewController:errorinputalert View:self];
        
        
    }else if ([workingMarketing.startdate isEqualToString:@""]) {
        UIAlertController *errorinputalert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",[MarketingTableCategory capitalizedString],[MyClass returntitlewithtitle:@"Record"]] message:[MyClass returntitlewithtitle:@"Please select the validity start date"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [errorinputalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [errorinputalert addAction:OKAction];
       //[self presentViewController:errorinputalert animated:YES completion:nil];
        [MyClass presentViewController:errorinputalert View:self];
        
        
    }else if ([workingMarketing.enddate isEqualToString:@""]) {
        UIAlertController *errorinputalert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",[MarketingTableCategory capitalizedString],[MyClass returntitlewithtitle:@"Record"]] message:[MyClass returntitlewithtitle:@"Please select the validity end date"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [errorinputalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [errorinputalert addAction:OKAction];
        //[self presentViewController:errorinputalert animated:YES completion:nil];
        [MyClass presentViewController:errorinputalert View:self];
    }else if ([workingMarketing.estartdate isEqualToString:@""] && workingMarketing.buymorepayless && [MarketingTableCategory isEqualToString:@"promotion"]) {
        UIAlertController *errorinputalert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",[MarketingTableCategory capitalizedString],[MyClass returntitlewithtitle:@"Record"]] message:[MyClass returntitlewithtitle:@"Please select the enrollment from date"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [errorinputalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [errorinputalert addAction:OKAction];
       //[self presentViewController:errorinputalert animated:YES completion:nil];
        [MyClass presentViewController:errorinputalert View:self];
        
        
    }else if ([workingMarketing.eenddate isEqualToString:@""] && workingMarketing.buymorepayless && [MarketingTableCategory isEqualToString:@"promotion"]) {
        UIAlertController *errorinputalert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",[MarketingTableCategory capitalizedString],[MyClass returntitlewithtitle:@"Record"]] message:[MyClass returntitlewithtitle:@"Please select the enrollmnet end date"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [errorinputalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [errorinputalert addAction:OKAction];
        //[self presentViewController:errorinputalert animated:YES completion:nil];
        [MyClass presentViewController:errorinputalert View:self];
    }else if (([MarketingTableCategory isEqualToString:@"promotion"]|| [MarketingTableCategory isEqualToString:@"coupon"]) && [workingMarketing.promotionpercentagediscount isEqualToString:@""] && [workingMarketing.promotionfixeddiscount isEqualToString:@""]){
        UIAlertController *errorinputalert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@ %@",[MarketingTableCategory capitalizedString],[MyClass returntitlewithtitle:@"Record"]] message:[MyClass returntitlewithtitle:@"Please input discount amount"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [errorinputalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [errorinputalert addAction:OKAction];
        //[self presentViewController:errorinputalert animated:YES completion:nil];
        [MyClass presentViewController:errorinputalert View:self];
    }else{
        [self updatemarketing];
    }
}

-(void) updateredeemable:(UISwitch *)sender
{
    workingMarketing.redeemable=sender.on;
}

-(void) updatecannotuseconjunctionwithothercoupons:(UISwitch *)sender
{
    workingMarketing.cannotuseconjunctionwithothercoupons=sender.on;
}


-(void) updatemarketing
{
    //update to sql
    
    NSString *descriptionenglish;
    NSString *descriptionchinese;
    
//    NSString *promotionfixeddiscount=@"";
//    NSString *promotionpercentagediscount=@"";

    if ([workingMarketing.description_chinese isEqualToString:@""]) {
        descriptionenglish=workingMarketing.description;
        descriptionchinese=descriptionenglish;
    }else if ([workingMarketing.description isEqualToString:@""]){
        descriptionchinese=workingMarketing.description_chinese;
        descriptionenglish=descriptionchinese;
    }else{
        descriptionenglish=workingMarketing.description;
        descriptionchinese=workingMarketing.description_chinese;
    }

    //combine arrays
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsonsubjectarray=[[NSArray alloc]init];
    NSArray *jsonproductarray=[[NSArray alloc]init];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    
    [dictionary setValue:descriptionenglish forKey:@"description"];
    [dictionary setValue:descriptionchinese forKey:@"description_chinese"];
    [dictionary setValue:workingMarketing.code forKey:@"code"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:workingMarketing.startdate] forKey:@"startdate"];
    [dictionary setValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:workingMarketing.enddate] forKey:@"enddate"];
    [dictionary setValue:workingMarketing.remarks forKey:@"remarks"];
    [dictionary setValue:workingMarketing.promotionfixeddiscount forKey:@"promotionfixeddiscount"];
    [dictionary setValue:workingMarketing.promotionpercentagediscount forKey:@"promotionpercentagediscount"];
    [dictionary setValue:workingMarketing.promotionquota forKey:@"promotionquota"];
    [dictionary setValue:workingMarketing.effectivefrom forKey:@"effectivefrom"];
    [dictionary setValue:workingMarketing.effectiveto forKey:@"effectiveto"];
    [dictionary setValue:workingMarketing.subcategory forKey:@"subcategory"];
    [dictionary setValue:workingMarketing.couponallowcredit forKey:@"couponallowcredit"];
    [dictionary setValue:workingMarketing.perclassorquantity?@"Yes":@"No" forKey:@"perclassorquantity"];

    [dictionary setValue:workingMarketing.redeemable?@"Yes":@"No" forKey:@"redeemable"];
    [dictionary setValue:workingMarketing.redeempoint forKey:@"redeempoint"];
    [dictionary setValue:workingMarketing.perstudentquota forKey:@"perstudentquota"];
    [dictionary setValue:workingMarketing.cannotuseconjunctionwithothercoupons?@"Yes":@"No" forKey:@"cannotuseconjunctionwithothercoupons"];
    [dictionary setValue:workingMarketing.earlybirdlastdate forKey:@"earlybirdlastdate"];
    
    [dictionary setValue:workingMarketing.buymorepayless?@"Yes":@"No" forKey:@"buymorepayless"];
    [dictionary setValue:workingMarketing.enablebuymorepayless?@"Yes":@"No" forKey:@"enablebuymorepayless"];
    [dictionary setValue:workingMarketing.estartdate forKey:@"estartdate"];
    [dictionary setValue:workingMarketing.eenddate forKey:@"eenddate"];
    [dictionary setValue:[@(workingMarketing.minnoofclass) stringValue] forKey:@"minnoofclass"];
    [dictionary setValue:workingMarketing.bmsmacrossothersubjects?@"Yes":@"No" forKey:@"bmsmacrossothersubjects"];
    [dictionary setValue:[@(workingMarketing.bmsmminsubjectno) stringValue] forKey:@"bmsmminsubjectno"];
    [dictionary setValue:[@(workingMarketing.bmsmminnoofclasspersubject) stringValue] forKey:@"bmsmminnoofclasspersubject"];
    [dictionary setValue:workingMarketing.bmsmsamebillmonth?@"Yes":@"No" forKey:@"bmsmsamebillmonth"];
    [dictionary setValue:workingMarketing.manualapply?@"Yes":@"No" forKey:@"manualapply"];
    
    arrayOfDicts = [[NSMutableArray alloc] init];
    keys=[NSArray arrayWithObjects:@"subjectkey",nil];
    if(workingMarketing.subjectarray){
        for (int i=0; i<workingMarketing.subjectarray.count; i++) {
            SubjectRecord *obj=[MyClass returnsubjectinformationwithsubjectkey:workingMarketing.subjectarray[i]];
            values=[NSArray arrayWithObjects:obj.subjectkey, nil];
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
    }else{
        values=[NSArray arrayWithObjects:@"None", nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    jsonsubjectarray = [NSArray arrayWithArray:arrayOfDicts];
    
    arrayOfDicts = [[NSMutableArray alloc] init];
    keys=[NSArray arrayWithObjects:@"productkey",nil];
    if(workingMarketing.productarray){
        for (int i=0; i<workingMarketing.productarray.count; i++) {
            ProductRecord *obj=[MyClass returnProductInformationWithProductKey:workingMarketing.productarray[i]];
            values=[NSArray arrayWithObjects:obj.productkey, nil];
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
    }else{
        values=[NSArray arrayWithObjects:@"None", nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
    }
    jsonproductarray = [NSArray arrayWithArray:arrayOfDicts];

    [dictionary setValue:jsonsubjectarray forKey:@"subjectarray"];
    [dictionary setValue:jsonproductarray forKey:@"productarray"];
    
    if ([MarketingTableMode isEqualToString:@"Add"]){
        [dictionary setValue:@"insertmarketingrecord" forKey:@"postaction"];
        [dictionary setValue:workingMarketing.category forKey:@"category"];
    }else{
        [dictionary setValue:@"updatemarketingrecord" forKey:@"postaction"];
        [dictionary setValue:MarketingRecordObject.marketingkey forKey:@"marketingkey"];
    }
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    
    if (result) {
        [self.delegate dismissMarketingPopover];
    }
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (keyboardheight>0) {
        CGPoint point = [textView.superview convertPoint:CGPointZero toView:MarketingPopoverTable];
        NSIndexPath *indexpath =[MarketingPopoverTable indexPathForRowAtPoint:point];
        
        CGRect rectInTableView = [MarketingPopoverTable rectForRowAtIndexPath:indexpath];
        
        if (rectInTableView.origin.y+rectInTableView.size.height>[MyClass keyboardVisibleHeightForTableView:MarketingPopoverTable]) {
            [MarketingPopoverTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-[MyClass keyboardVisibleHeightForTableView:MarketingPopoverTable]) animated:YES];
        }
    }
}


-(void) textViewDidChange:(UITextView *)textView
//-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.tag==0) {
        workingMarketing.description=textView.text;
    }else if (textView.tag==1) {
        workingMarketing.description_chinese=textView.text;
    }else if (textView.tag==2) {
        workingMarketing.remarks=textView.text;
    }
    
    CGPoint rootViewPoint = [textView.superview convertPoint:CGPointZero toView:MarketingPopoverTable];
    NSIndexPath *indexPath = [MarketingPopoverTable indexPathForRowAtPoint:rootViewPoint];
    
    MyTableViewCell *newcell=[MarketingPopoverTable cellForRowAtIndexPath:indexPath];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    if (size.height>100) {
        newcell.layoutconstraint1.constant=100;
        textView.scrollEnabled=YES;
    }else{
        newcell.layoutconstraint1.constant=size.height;
        textView.scrollEnabled=NO;
    }

    [MarketingPopoverTable beginUpdates];
    [MarketingPopoverTable endUpdates];
}

- (BOOL) retrieveMarketingPromotionWithMarketingKey:(NSString *)marketingkey
{

    //create string contains url address for php file
    NSString *strURL;
    if([MarketingTableCategory isEqualToString:@"promotion"]){
        strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievemarketingpromotionstudentlist&marketingkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,marketingkey];
    }else{
        strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievemarketingcouponstudentlist&marketingkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,marketingkey];
    }
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
                studentListArray=[[NSMutableArray alloc] init];
            
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *jsonArray = jsonreturned[@"content"];

            //Set up our student array
            
            
            //loop through our jsonArray
            for (int i=0; i<jsonArray.count; i++) {
                
                //Create our student object
                NSString * sstudentkey=[[jsonArray objectAtIndex:i] objectForKey:@"studentkey"];
                NSString * senrollmentkey=[[jsonArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
                studentobject=[MyClass returnstudentwithstudentkey:sstudentkey];
                studentobject.remarks=senrollmentkey;
                [studentListArray addObject:studentobject];
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
            studentListArray=[[NSMutableArray alloc] init];
        
        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
        NSMutableArray *jsonArray = jsonreturned[@"content"];

        //Set up our student array
        
        
        //loop through our jsonArray
        for (int i=0; i<jsonArray.count; i++) {
            
            //Create our student object
            NSString * sstudentkey=[[jsonArray objectAtIndex:i] objectForKey:@"studentkey"];
            NSString * senrollmentkey=[[jsonArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
            studentobject=[MyClass returnstudentwithstudentkey:sstudentkey];
            studentobject.remarks=senrollmentkey;
            [studentListArray addObject:studentobject];
        }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        studentlistsearchbar.text=@"";
        [self returnfilterstudentlistarray];
    }
    return result;
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    NSString *selecteddatestring=[selecteddatearray firstObject];
    
    if([selectedItem isEqualToString:@"EffectiveFrom"]){
        workingMarketing.effectivefrom=[MyClass convertDateFormatWithDate:selecteddatestring FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        [MarketingPopoverTable reloadData];
        
        [self adjusttablesize];
        
    }else if([selectedItem isEqualToString:@"EffectiveTo"]){
        workingMarketing.effectiveto=[MyClass convertDateFormatWithDate:selecteddatestring FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        [MarketingPopoverTable reloadData];
        
        [self adjusttablesize];
        
    }else if([selectedItem isEqualToString:@"EnrollmentFrom"]){
        workingMarketing.estartdate=[MyClass convertDateFormatWithDate:selecteddatestring FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        [MarketingPopoverTable reloadData];
        
        [self adjusttablesize];
        
    }else if([selectedItem isEqualToString:@"EnrollmentEnd"]){
        workingMarketing.eenddate=[MyClass convertDateFormatWithDate:selecteddatestring FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        [MarketingPopoverTable reloadData];
        
        [self adjusttablesize];
        
    }else if([selectedItem isEqualToString:@"EarlyBirdLastDate"]){
        workingMarketing.earlybirdlastdate=[MyClass convertDateFormatWithDate:selecteddatestring FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        [MarketingPopoverTable reloadData];
        
        [self adjusttablesize];
        
    }else if([selectedItem isEqualToString:@"StartDate"]){
        if (![workingMarketing.startdate isEqualToString:selecteddatestring]){
            
            workingMarketing.startdate=selecteddatestring;
//            showStartDatePicker=NO;
            
            //[self storeTmpField];
            [MarketingPopoverTable reloadData];
            
            [self adjusttablesize];
            
        }
    }else if ([selectedItem isEqualToString:@"EndDate"]){
        if (![workingMarketing.enddate isEqualToString:selecteddatestring]){
            
            [df setDateFormat:@"dd-MMM-yyyy"];
            if ([[df dateFromString:selecteddatestring] compare:[df dateFromString:workingMarketing.startdate]]==NSOrderedAscending) {
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Validity"] message:[MyClass returntitlewithtitle:@"Expiry date cannot be earlier than the start date"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
                
                workingMarketing.enddate=workingMarketing.startdate;
                
                //[self storeTmpField];
                [MarketingPopoverTable reloadData];
                
                [self adjusttablesize];
            }else{
                workingMarketing.enddate=selecteddatestring;
//                showEndDatePicker=NO;
                
                //[self storeTmpField];
                [MarketingPopoverTable reloadData];
                
                [self adjusttablesize];
            }
        }
    }

}

-(void) closesidewindowview
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

-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width
{
    if (self.view.window) {
        mainWindow = self.view.window;
    }
    if (!mainWindow) {
        return;
    }
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
        sidewindowview.hidden = width<=0;
        sidewindowview.frame=CGRectMake(mainWindow.bounds.size.width-width, 0, width, mainWindow.bounds.size.height);
        for (UIView *panelChild in sidewindowview.subviews) {
            if ([panelChild isKindOfClass:[UIActivityIndicatorView class]]) {
                continue;
            }
            panelChild.frame = sidewindowview.bounds;
        }
        if (width==0 && sidewindowview.frame.origin.x< mainWindow.bounds.size.width) {
            [MyClass playsoundwithoption:@"close"];
        }
    } completion:^(BOOL finished){
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

-(void) updateCategoryCount
{
    //delegate not used
}

-(void) refreshparentviewdocumentfoldercount
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

-(void) refreshstudentdetailviewpresentingviewcontent
{
    //delegate not used
}

-(void) updatestudentinformationlist:(NSString *)studentkey reloadlist:(BOOL)reload
{
    //delegate not used
}

-(void) gotostudentprofile:(NSString *)studentkey
{
    //delegate not used
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if ([selectedItem isEqualToString:@"Quota"]) {
//        if (component==0){
            return [quotaarray count];
//        }
    }else if ([selectedItem isEqualToString:@"Creditable"]){
        return [couponallowcreditarray count];
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


//    if (component==0){
    if ([selectedItem isEqualToString:@"Quota"]) {
        if(row==0){
            tView.text=[MyClass returntitlewithtitle:@"Unlimited"];
        }else{
            tView.text= [quotaarray objectAtIndex:row];
        }
    }else if ([selectedItem isEqualToString:@"Creditable"]){
        tView.text=[MyClass returntitlewithtitle:[couponallowcreditarray objectAtIndex:row]];
    }
        
        
//    }

    return tView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 260;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([selectedItem isEqualToString:@"Quota"]) {
        workingMarketing.promotionquota=[quotaarray objectAtIndex:[pickerView selectedRowInComponent:0]];
        showQuotaInput=NO;
    }else if ([selectedItem isEqualToString:@"Creditable"]){
        workingMarketing.couponallowcredit=[couponallowcreditarray objectAtIndex:[pickerView selectedRowInComponent:0]];
        showCreditable=NO;
    }
    [MarketingPopoverTable reloadData];
    [self adjusttablesize];

}



- (IBAction)productnonebuttonpressed:(id)sender {
    workingMarketing.productarray=nil;
    [self backbuttonpressed:nil];
    [MarketingPopoverTable reloadData];
}

- (IBAction)productallbuttonpressed:(id)sender {
    workingMarketing.productarray=[[NSMutableArray alloc]init];
    [self backbuttonpressed:nil];
    [MarketingPopoverTable reloadData];
}

- (IBAction)subjectnonebuttonpressed:(id)sender {
    workingMarketing.subjectarray=nil;
    [self backbuttonpressed:nil];
    [MarketingPopoverTable reloadData];
}

- (IBAction)subjectallbuttonpressed:(id)sender {
    workingMarketing.subjectarray=[[NSMutableArray alloc]init];
    [self backbuttonpressed:nil];
    [MarketingPopoverTable reloadData];
}

- (IBAction)datenonebuttonpressed:(UIButton *)sender {
    if ([selectedItem isEqualToString:@"EarlyBirdLastDate"]) {
        workingMarketing.earlybirdlastdate=@"";
    }else{
        if(sender.tag==0){
            workingMarketing.effectivefrom=@"0";
        }else{
            workingMarketing.effectiveto=@"0";
        }
    }
    
    [MarketingPopoverTable reloadData];
    [self showsidewindowwithwindow:@""];
    [self adjusttablesize];
}

- (IBAction)backbuttonpressed:(id)sender {
    [self showsidewindowwithwindow:@""];
    [self adjusttablesize];
}

- (IBAction)daynonebuttonpressed:(UIButton *)sender {
    if(sender.tag==0){
        workingMarketing.effectivefrom=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
    }else{
        workingMarketing.effectiveto=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
    }
    
    [MarketingPopoverTable reloadData];
    [self showsidewindowwithwindow:@""];
    [self adjusttablesize];
}

@end
