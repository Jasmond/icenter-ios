//
//  CenterInformationViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 30/10/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import "CenterInformationViewController.h"
#import "MainMenuViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "ClassScheduleViewController.h"
#import "MyClass.h"
#import "MyTableViewCell.h"
#import "SceneDelegate.h"

@interface CenterInformationViewController ()
{
    BOOL sideWindowAdjusting;
    NSMutableDictionary *edgeConstants;
    CGFloat laidOutCalendarWidth;
    CGFloat laidOutCalendarHeight;
    UIView *centerInfoBackgroundView;
    UIView *centerInfoLowerBackgroundView;
    CGFloat laidOutPolicyWidth;
    UIView *subscriptionEditBackground;
    UIView *subscriptionSeparator;
    UIView *deviceTableHeaderView;
    UIView *loadingIndicatorCenterView;
}
@end

//#define leftmargin 7
//#define topmargin 50
//#define horizontalseparation 7.5
//#define verticalseparation 7.5

#define headerheight 27
#define groupactivecolor [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1]
#define groupinactivecolor [UIColor colorWithRed:140.0/255.0 green:140.0/255.0 blue:140.0/255.0 alpha:1]
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]

#define confirmationwidth 110

#define TABLE_VIEW_CELL_DEFAULT_ID @"cellIdentifier"


@implementation CenterInformationViewController
@synthesize myPopoverController,myMarketingPopoverController,tableViewCellIdentifier,tableViewCellIdentifierCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    hourPickerViewMenu=[NSMutableArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",nil];
    minutePickerViewMenu=[NSMutableArray arrayWithObjects:@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];

    calendarview.frame=CGRectMake(4, 108, self.view.frame.size.width-8, self.view.frame.size.height-108-4);
    subscriptionview.frame=CGRectMake(4, 108, self.view.frame.size.width-8, self.view.frame.size.height-108-4);
    [self.view layoutIfNeeded];
    tableViewCellIdentifierCount=0;
    
    horizontalseparation=7.5;
    verticalseparation=7.5;
    topmargin=50;
    cellwidth=(self.view.frame.size.width-3*horizontalseparation-8)/28;
    leftmargin=(self.view.frame.size.width-cellwidth*28-3*horizontalseparation-8)/2;
    cellheight=(calendarview.frame.size.height-topmargin-2*verticalseparation-3*headerheight-4)/21;
    
    
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
    
    groupalertarray=[[NSArray alloc]initWithObjects:@"Makeup arrangement", @"Auto renewal failure", @"Online enrollment",@"online_payment", nil];
    AllRoleArray=[[NSMutableArray alloc]initWithObjects:@"All",@"Teaching",@"Non-Teaching", nil];
    
    menuArray=[[NSMutableArray alloc]initWithObjects:@"Our Center",@"Calendar",@"Subject",@"Classroom",@"Staff",@"Product",@"Marketing",@"Policy",@"Subscription", nil];
    
    [self highlightmenubuttonwithbuttontag:0];
    
    calendarview.layer.cornerRadius=7;
    subjectview.layer.cornerRadius=7;
    staffview.layer.cornerRadius=7;
    policyview.layer.cornerRadius=7;
    contactview.layer.cornerRadius=7;
    subscriptionview.layer.cornerRadius=7;
    productview.layer.cornerRadius=7;
    classroomview.layer.cornerRadius=7;
    
    contactview.layer.cornerRadius=7;

    contactscrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, contactview.frame.size.width, contactview.frame.size.height)];
    contactscrollview.contentSize=CGSizeMake(contactview.frame.size.width, contactview.frame.size.height);
    [contactscrollview setBackgroundColor:[UIColor lightGrayColor]];
    contactscrollview.layer.cornerRadius=7;
    [contactview addSubview:contactscrollview];
    
    marketingstatusarray=[[NSArray alloc]initWithObjects:@"All",@"Valid",@"Expired", nil];
    marketingview.layer.cornerRadius=7;
    
    classroomstatusarray=[[NSArray alloc]initWithObjects:@"All",@"In Service",@"Not In Service", nil];
    classroomview.layer.cornerRadius=7;
    
    monthnameArray=[[NSArray alloc]initWithObjects:@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December",nil];
    dayofweekArray=[[NSArray alloc]initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",nil];
    
    calendarview.hidden=YES;
    subjectview.hidden=YES;
    staffview.hidden=YES;
    policyview.hidden=YES;
    contactview.hidden=NO;
    //othercenterview.hidden=YES;
    subscriptionview.hidden=YES;
    productview.hidden=YES;
    marketingview.hidden=YES;
    classroomview.hidden=YES;
    
    
    scpolicy=[[UISegmentedControl alloc]init];
    scpolicy.frame=CGRectMake(10, 11, generalPolicyView.frame.size.width-50, 29);
    scpolicy.tintColor=[UIColor darkGrayColor];
    [scpolicy addTarget:self action:@selector(selectpolicy:) forControlEvents:UIControlEventValueChanged];
    [generalPolicyView addSubview:scpolicy];
    
    policytable.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [policytable setSeparatorColor:[UIColor systemGroupedBackgroundColor]];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshpolicytable) forControlEvents:UIControlEventValueChanged];
    [policytable addSubview:tablerefresh];
    
    policy_editbutton= [[UIButton alloc]initWithFrame:CGRectMake(generalPolicyView.frame.size.width-37, 10, 31,31)];
    [policy_editbutton setImage:[UIImage imageNamed:@"editlesson2_icon.png"] forState:UIControlStateNormal];
    policy_editbutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    policy_editbutton.layer.cornerRadius=5;
    policy_editbutton.layer.masksToBounds=YES;
    [policy_editbutton addTarget:self action:@selector(policy_editbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [generalPolicyView addSubview:policy_editbutton];
    
    policy_savebutton =[[UIButton alloc]initWithFrame:CGRectMake(generalPolicyView.frame.size.width-100-38,generalPolicyView.frame.size.height-35-15,100,35)];
    [policy_savebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [policy_savebutton setTitle:[MyClass returntitlewithtitle:@"Save"] forState:UIControlStateNormal];
    policy_savebutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    policy_savebutton.backgroundColor=[UIColor whiteColor];
    policy_savebutton.layer.borderWidth=1;
    policy_savebutton.layer.cornerRadius=4;
    policy_savebutton.layer.masksToBounds=YES;
    policy_savebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    policy_savebutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [policy_savebutton addTarget: self action:@selector(policy_savebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [policy_savebutton addTarget: self action:@selector(policy_buttonhighlightcolor:) forControlEvents: UIControlEventTouchDown];
    [policy_savebutton addTarget: self action:@selector(policy_buttonresetcolor:) forControlEvents: UIControlEventTouchCancel];
    [policy_savebutton addTarget: self action:@selector(policy_buttonresetcolor:) forControlEvents: UIControlEventTouchUpOutside];
    [generalPolicyView addSubview:policy_savebutton];
    
    policy_cancelbutton =[[UIButton alloc]initWithFrame:CGRectMake(generalPolicyView.frame.size.width-100-38-100-10,generalPolicyView.frame.size.height-35-15,100,35)];
    [policy_cancelbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [policy_cancelbutton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    policy_cancelbutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    policy_cancelbutton.backgroundColor=[UIColor whiteColor];
    policy_cancelbutton.layer.borderWidth=1;
    policy_cancelbutton.layer.cornerRadius=4;
    policy_cancelbutton.layer.masksToBounds=YES;
    policy_cancelbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    policy_cancelbutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [policy_cancelbutton addTarget: self action:@selector(policy_cancelbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [policy_cancelbutton addTarget: self action:@selector(policy_buttonhighlightcolor:) forControlEvents: UIControlEventTouchDown];
    [policy_cancelbutton addTarget: self action:@selector(policy_buttonresetcolor:) forControlEvents: UIControlEventTouchCancel];
    [policy_cancelbutton addTarget: self action:@selector(policy_buttonresetcolor:) forControlEvents: UIControlEventTouchUpOutside];
    [generalPolicyView addSubview:policy_cancelbutton];
    
    policy_addbutton =[[UIButton alloc]initWithFrame:CGRectMake((generalPolicyView.frame.size.width-100)/2,(generalPolicyView.frame.size.height-35)/2,100,35)];
    [policy_addbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [policy_addbutton setTitle:[MyClass returntitlewithtitle:@"Add Policy"] forState:UIControlStateNormal];
    policy_addbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    policy_addbutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [policy_addbutton addTarget: self action:@selector(policy_addbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [generalPolicyView addSubview:policy_addbutton];
    policy_addbutton.hidden=YES;
    
    scPolicyLanguage = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"English",@"中文",nil]];
    scPolicyLanguage.frame=CGRectMake(30, generalPolicyView.frame.size.height-35-15, 150, 35);
    
    [scPolicyLanguage addTarget:self action:@selector(changeeditpolicylanguage) forControlEvents:UIControlEventValueChanged];
    [scPolicyLanguage setTintColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0]];
    [generalPolicyView addSubview:scPolicyLanguage];


    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    subjectstatusarray=[[NSArray alloc]initWithObjects:@"All",@"Active",@"Inactive", nil];
    lastsubjectfilterindex=0;
    scsubjectstatus.tintColor=themecolor;
    [scsubjectstatus addTarget:self action:@selector(changesubjectfilter:) forControlEvents: UIControlEventValueChanged];
    scsubjectstatus.selectedSegmentIndex=0;

    [SubjectCategorySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Categories"] forState:UIControlStateNormal];
    [SubjectCategorySelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    SubjectCategorySelectionButton.backgroundColor=themecolor;
    SubjectCategorySelectionButton.titleLabel.font=[UIFont systemFontOfSize:12];
    SubjectCategorySelectionButton.layer.cornerRadius=5;
    [SubjectCategorySelectionButton addTarget: self action:@selector(selectsubjectcategory:) forControlEvents: UIControlEventTouchUpInside];
    [self drawpointerwithoption:@"closed" button:SubjectCategorySelectionButton];
    
    
    if (globalvariables.centerrecord.enableattendanceextend) {
        SubjectCategorySelectionButton.hidden=NO;
    }else{
        SubjectCategorySelectionButton.hidden=YES;
    }
    
    
    productstatusarray=[[NSArray alloc]initWithObjects:@"All",@"Active",@"Inactive", nil];
    [ProductCategorySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Categories"] forState:UIControlStateNormal];
    [ProductCategorySelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ProductCategorySelectionButton.backgroundColor=themecolor;
    ProductCategorySelectionButton.titleLabel.font=[UIFont systemFontOfSize:12];
    ProductCategorySelectionButton.layer.cornerRadius=5;
    [ProductCategorySelectionButton addTarget: self action:@selector(selectproductcategory:) forControlEvents: UIControlEventTouchUpInside];
    [self drawpointerwithoption:@"closed" button:ProductCategorySelectionButton];

    scproductstatus.selectedSegmentIndex = 0;
    lastproductstatusindex=0;
    scproductstatus.tintColor=themecolor;
    [scproductstatus addTarget:self action:@selector(changeproductfilter:) forControlEvents: UIControlEventValueChanged];
    scproductstatus.selectedSegmentIndex=0;

    
    [self createtableheader];
    
    productcategoryarray=[[NSMutableArray alloc]initWithObjects:@"All Categories", nil];
    productcategoryallarray=[[NSMutableArray alloc]init];
    productcodeallarray=[[NSMutableArray alloc]init];
    
    
    //staff view
    if ([stafftable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        stafftable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshstafftable) forControlEvents:UIControlEventValueChanged];
    [stafftable addSubview:tablerefresh];
    staffsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    [staffsortbutton addTarget:self action:@selector(sortingbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    laststaffstatusindex=1;
    scstaffstatus.tintColor=themecolor;
    [scstaffstatus addTarget:self action:@selector(changestafffilter:) forControlEvents: UIControlEventValueChanged];
    scstaffstatus.selectedSegmentIndex=1;

    scstaffrole.selectedSegmentIndex = 0;
    laststaffroleindex=0;
    scstaffrole.tintColor=themecolor;
    [scstaffrole addTarget:self action:@selector(changestafffilter:) forControlEvents: UIControlEventValueChanged];
    [staff_replaceinstructorbutton addTarget:self action:@selector(staff_replaceinstructorbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [staff_usergroupbutton setImage:[UIImage imageNamed:@"group_icon.png"] forState:UIControlStateNormal];
    [staff_usergroupbutton addTarget:self action:@selector(staff_usergroupbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [staff_userprivilegebutton addTarget:self action:@selector(staff_userprivilegebuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    if ([subjecttable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        subjecttable.cellLayoutMarginsFollowReadableWidth=NO;
    }

    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshsubjecttable) forControlEvents:UIControlEventValueChanged];
    [subjecttable addSubview:tablerefresh];
    subjecttable.rowHeight=UITableViewAutomaticDimension;
    subjecttable.estimatedRowHeight=80;
    
    subjectobject=[[SubjectRecord alloc]init];
    
    subjectsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    subjectsearchbar.delegate=self;
    [subjectsortbutton addTarget:self action:@selector(sortingbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //product
    if ([producttable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        producttable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshproducttable) forControlEvents:UIControlEventValueChanged];
    [producttable addSubview:tablerefresh];
    
    productsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    [productsortbutton addTarget:self action:@selector(sortingbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    
    licensetableindexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if ([subscriptiontable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        subscriptiontable.cellLayoutMarginsFollowReadableWidth=NO;
    }


    devicetable=[[UITableView alloc]initWithFrame:CGRectMake(subscriptiontable.frame.origin.x+subscriptiontable.frame.size.width, subscriptiontable.frame.origin.y, subscriptionview.frame.size.width-40-subscriptiontable.frame.size.width, subscriptiontable.frame.size.height-40) style:UITableViewStyleGrouped];
    devicetable.delegate=self;
    devicetable.dataSource=self;
    if ([devicetable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        devicetable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    [subscriptionview addSubview:devicetable];
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshdevicetable) forControlEvents:UIControlEventValueChanged];
    [devicetable addSubview:tablerefresh];
    
    UIView *editbackground=[[UIView alloc]initWithFrame:CGRectMake(subscriptiontable.frame.origin.x+subscriptiontable.frame.size.width, devicetable.frame.size.height+devicetable.frame.origin.y, devicetable.frame.size.width, 40)];
    editbackground.backgroundColor=[UIColor grayColor];
    subscriptionEditBackground=editbackground;
    [subscriptionview addSubview:editbackground];
    
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(subscriptiontable.frame.origin.x+subscriptiontable.frame.size.width, subscriptiontable.frame.origin.y, 0.8, subscriptiontable.frame.size.height)];
    separator.backgroundColor=[UIColor grayColor];
    separator.alpha=0.4;
    subscriptionSeparator=separator;
    [subscriptionview addSubview: separator];
    
    [self drawsubscriptiontableheader];
    
    lastmarketingfilterindex=0;
    scmarketingstatus.tintColor=themecolor;
    [scmarketingstatus addTarget:self action:@selector(changemarketingfilter:) forControlEvents: UIControlEventValueChanged];
    scmarketingstatus.selectedSegmentIndex=0;
    scmarketingcategory.tintColor=themecolor;
    [scmarketingcategory addTarget:self action:@selector(changemarketingcategory:) forControlEvents: UIControlEventValueChanged];
    scmarketingcategory.selectedSegmentIndex=0;
    title_marketing_discount.hidden=YES;
    title_marketing_quota.hidden=YES;
    
    if ([marketingtable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        marketingtable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshmarketingtable) forControlEvents:UIControlEventValueChanged];
    [marketingtable addSubview:tablerefresh];
    
    marketingsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    marketingsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    marketingsearchbar.barStyle=UIBarStyleBlack;
    [marketingsortbutton addTarget:self action:@selector(sortingbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];

    classroomtable.backgroundColor=[UIColor systemGroupedBackgroundColor];
    if ([classroomtable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        classroomtable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshclassroomtable) forControlEvents:UIControlEventValueChanged];
    [classroomtable addSubview:tablerefresh];
    
    roomsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    [classroomsortbutton addTarget:self action:@selector(sortingbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [scclassroomstatus setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [scclassroomstatus setTitle:[MyClass returntitlewithtitle:@"In Service"] forSegmentAtIndex:1];
    [scclassroomstatus setTitle:[MyClass returntitlewithtitle:@"Not In Service"] forSegmentAtIndex:2];
    scclassroomstatus.selectedSegmentIndex = 0;
    lastclassroomfilterindex=0;
    scclassroomstatus.tintColor=themecolor;
    [scclassroomstatus addTarget:self action:@selector(changeclassroomfilter:) forControlEvents: UIControlEventValueChanged];

    
    [df setDateFormat:@"yyyy"];
    displayyear=[[df stringFromDate:[NSDate date]] intValue];
        yeartitle.text=[globalvariables.language isEqualToString:@"English"]?[NSString stringWithFormat:@"Year %ld",displayyear]:[NSString stringWithFormat:@"%ld年",displayyear];
    
    if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editcentercalendar) {

        editcalendarbutton = [[UIButton alloc]initWithFrame:CGRectMake(calendarview.frame.size.width-150-leftmargin-10, 15, 150, 30)];
        editcalendarbutton.titleLabel.font=[UIFont systemFontOfSize:15];
        editcalendarbutton.tag=888;
        editcalendarbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [editcalendarbutton setTitleColor:[UIColor colorWithRed:0 green:0.478431 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
        [editcalendarbutton setTitle:[MyClass returntitlewithtitle:@"Edit Calendar"] forState:UIControlStateNormal];
        [editcalendarbutton addTarget:self action:@selector(editcalendarbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        [calendarview addSubview:editcalendarbutton];
    }
    
    [self initializeContactView];
    
    

    
    loadingindicatorview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    loadingindicatorview.backgroundColor=[UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:0.1];
    [self.view addSubview:loadingindicatorview];
    
    
    UIView *centerview=[[UIView alloc]initWithFrame:CGRectMake((self.view.bounds.size.width-180)/2, (self.view.bounds.size.height-140)/2, 180, 140)];
    centerview.layer.cornerRadius=10;
    centerview.layer.masksToBounds=YES;
    loadingIndicatorCenterView=centerview;
    [loadingindicatorview addSubview:centerview];
    
    UIImageView *activityImageView=[[UIImageView alloc]init];
    activityImageView.animationImages=[MyClass returnLoadingIndicatorAnimatedImageWithBaseColor:@"lightgray"];
    activityImageView.alpha=1.0;
    activityImageView.animationDuration=2;
    activityImageView.frame=CGRectMake(-10,-10,60,60);
    [activityImageView startAnimating];
    
    ailoadclass = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    ailoadclass.alpha = 1.0;
    ailoadclass.color=[UIColor clearColor];
    ailoadclass.transform=CGAffineTransformMakeScale(1, 1);
    ailoadclass.center = CGPointMake(centerview.frame.size.width/2,centerview.frame.size.height/2);
    ailoadclass.hidesWhenStopped = YES;
    [ailoadclass addSubview:activityImageView];
    [centerview addSubview:ailoadclass];

    UIImageView *activityImageViewContactus=[[UIImageView alloc]init];
    activityImageViewContactus.animationImages=[MyClass returnLoadingIndicatorAnimatedImageWithBaseColor:@"lightgray"];
    activityImageViewContactus.alpha=1.0;
    activityImageViewContactus.animationDuration=2;
    activityImageViewContactus.frame=CGRectMake(-10,-10,60,60);
    [activityImageViewContactus startAnimating];
    
    aicontactus = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    aicontactus.alpha = 1.0;
    aicontactus.color=[UIColor clearColor];
    aicontactus.transform=CGAffineTransformMakeScale(1, 1);
    aicontactus.center = CGPointMake(mainimage.frame.size.width/2,200);
    aicontactus.hidesWhenStopped = YES;
    [aicontactus addSubview:activityImageViewContactus];
    [mainimage addSubview:aicontactus];
    [aicontactus startAnimating];
    
    
    
    
    [self loadingindicatorwithoption:@"start"];
    selectedMainImage=0;
    leaveNatureListTable.editing=YES;
    [self refreshlanguage];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checktoreloadapp) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    [sidewindowviewclosebutton addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [mainWindow addSubview:sidewindowviewclosebutton];
    
    sidewindowview=[[UIView alloc]initWithFrame:CGRectMake(mainWindow.bounds.size.width, 0, 0, mainWindow.bounds.size.height)];
    sidewindowview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    sidewindowview.hidden=YES;
    sidewindowview.clipsToBounds=YES;
    sidewindowview.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
    sidewindowview.tag=-200;
    [mainWindow addSubview:sidewindowview];
    
    activityImageView=[[UIImageView alloc]init];
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
    
    
    scsubjectstatus.selectedSegmentIndex=1;
    scclassroomstatus.selectedSegmentIndex=1;
    scstaffstatus.selectedSegmentIndex=1;
    scproductstatus.selectedSegmentIndex=1;
    scmarketingstatus.selectedSegmentIndex=1;
    runviewdidappear=TRUE;
    
    title_marketing_validityto.hidden=YES;
}

-(void) initializeContactView
{
    //center information
    centernamelabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 20, contactview.frame.size.width-350, 33)];
    centernamelabel.font=[UIFont boldSystemFontOfSize:25];
    centernamelabel.minimumScaleFactor=0.5;
    centernamelabel.adjustsFontSizeToFitWidth=YES;
    centernamelabel.textColor=[UIColor blackColor];
    [contactscrollview addSubview:centernamelabel];
    
    schoolregnumberLabel=[[UILabel alloc]initWithFrame:CGRectMake(contactview.frame.size.width-130, 20, 100, 33)];
    schoolregnumberLabel.font=[UIFont systemFontOfSize:17];
    schoolregnumberLabel.textAlignment=NSTextAlignmentRight;
    schoolregnumberLabel.textColor=[UIColor darkGrayColor];
    [contactscrollview addSubview:schoolregnumberLabel];
    
    schoolregnumberTitle=[[UILabel alloc]initWithFrame:CGRectMake(contactview.frame.size.width-300, 20, 180, 33)];
    schoolregnumberTitle.font=[UIFont systemFontOfSize:17];
    schoolregnumberTitle.textColor=[UIColor darkGrayColor];
    [contactscrollview addSubview:schoolregnumberTitle];

    centershortnamelabel=[[UILabel alloc]initWithFrame:CGRectMake(32, 55, contactview.frame.size.width-100, 20)];
    centershortnamelabel.font=[UIFont systemFontOfSize:14];
    centershortnamelabel.textColor=[UIColor darkGrayColor];
    [contactscrollview addSubview:centershortnamelabel];
    
    
    UIView *backgroundview=[[UIView alloc]initWithFrame:CGRectMake(30, 80, contactview.frame.size.width-60, 458)];
    backgroundview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    centerInfoBackgroundView=backgroundview;
    [contactscrollview addSubview:backgroundview];
    
    float mainimage_width=backgroundview.frame.size.height*155/(155*3/4+48);
    float shopfront_height=backgroundview.frame.size.height*48/(155*3/4+48);
    float shopfront_width=shopfront_height*4/3;
    
    centeraddresslabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 20, 477, 1000)];
    centeraddresslabel.numberOfLines=0;
    centeraddresslabel.minimumScaleFactor=0.7;
    centeraddresslabel.adjustsFontSizeToFitWidth=YES;
    centeraddresslabel.font=[UIFont systemFontOfSize:17];
    [backgroundview addSubview:centeraddresslabel];
    
    centercontactlabel=[[UILabel alloc]init];
    centercontactlabel.font=[UIFont systemFontOfSize:16];
    centercontactlabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centercontactlabel];

    centerfaxlabel=[[UILabel alloc]init];
    centerfaxlabel.font=[UIFont systemFontOfSize:16];
    centerfaxlabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centerfaxlabel];
    
    centerwhatsapplabel=[[UILabel alloc]init];
    centerwhatsapplabel.font=[UIFont systemFontOfSize:16];
    centerwhatsapplabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centerwhatsapplabel];
    
    centerlatlonglabel=[[UILabel alloc]init];
    centerlatlonglabel.font=[UIFont systemFontOfSize:16];
    centerlatlonglabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centerlatlonglabel];
    
    centercontacticonimage=[[UIImageView alloc]init];
    [centercontacticonimage setImage:[UIImage imageNamed:@"phone_icon.png"]];
    [backgroundview addSubview:centercontacticonimage];

    centerfaxiconimage=[[UIImageView alloc]init];
    [centerfaxiconimage setImage:[UIImage imageNamed:@"fax_icon.png"]];
    [backgroundview addSubview:centerfaxiconimage];
    
    centerwhatsappiconimage=[[UIImageView alloc]init];
    [centerwhatsappiconimage setImage:[UIImage imageNamed:@"whatsapp_icon.png"]];
    [backgroundview addSubview:centerwhatsappiconimage];
    
    centerlatlongiconimage=[[UIImageView alloc]init];
    [centerlatlongiconimage setImage:[UIImage imageNamed:@"map_pin_icon.png"]];
    [backgroundview addSubview:centerlatlongiconimage];
    
    
    
    title_Center_hours_except_center_holiday=[[UILabel alloc]initWithFrame:CGRectMake(30, 248, 344, 33)];
    title_Center_hours_except_center_holiday.font=[UIFont systemFontOfSize:17];
    title_Center_hours_except_center_holiday.minimumScaleFactor=0.7;
    title_Center_hours_except_center_holiday.adjustsFontSizeToFitWidth=YES;
    title_Center_hours_except_center_holiday.textColor=[UIColor blackColor];
    [backgroundview addSubview:title_Center_hours_except_center_holiday];
    
    centerhour_line1leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 280, 120, 33)];
    centerhour_line1leftLabel.font=[UIFont systemFontOfSize:16];
    centerhour_line1leftLabel.minimumScaleFactor=0.7;
    centerhour_line1leftLabel.adjustsFontSizeToFitWidth=YES;
    centerhour_line1leftLabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centerhour_line1leftLabel];

    centerhour_line2leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 310, 120, 33)];
    centerhour_line2leftLabel.font=[UIFont systemFontOfSize:16];
    centerhour_line2leftLabel.minimumScaleFactor=0.7;
    centerhour_line2leftLabel.adjustsFontSizeToFitWidth=YES;
    centerhour_line2leftLabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centerhour_line2leftLabel];
    
    centerhour_line3leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 340, 120, 33)];
    centerhour_line3leftLabel.font=[UIFont systemFontOfSize:16];
    centerhour_line3leftLabel.minimumScaleFactor=0.7;
    centerhour_line3leftLabel.adjustsFontSizeToFitWidth=YES;
    centerhour_line3leftLabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centerhour_line3leftLabel];
    
    centerhour_line4leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 370, 120, 33)];
    centerhour_line4leftLabel.font=[UIFont systemFontOfSize:16];
    centerhour_line4leftLabel.minimumScaleFactor=0.7;
    centerhour_line4leftLabel.adjustsFontSizeToFitWidth=YES;
    centerhour_line4leftLabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centerhour_line4leftLabel];

    centerhour_line5leftLabel=[[UILabel alloc]initWithFrame:CGRectMake(30, 400, 120, 33)];
    centerhour_line5leftLabel.font=[UIFont systemFontOfSize:16];
    centerhour_line5leftLabel.minimumScaleFactor=0.7;
    centerhour_line5leftLabel.adjustsFontSizeToFitWidth=YES;
    centerhour_line5leftLabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centerhour_line5leftLabel];
    
    centerhour_line1rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, 280, 387, 33)];
    centerhour_line1rightLabel.font=[UIFont systemFontOfSize:16];
    centerhour_line1rightLabel.minimumScaleFactor=0.7;
    centerhour_line1rightLabel.adjustsFontSizeToFitWidth=YES;
    centerhour_line1rightLabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centerhour_line1rightLabel];
    
    centerhour_line2rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, 310, 387, 33)];
    centerhour_line2rightLabel.font=[UIFont systemFontOfSize:16];
    centerhour_line2rightLabel.minimumScaleFactor=0.7;
    centerhour_line2rightLabel.adjustsFontSizeToFitWidth=YES;
    centerhour_line2rightLabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centerhour_line2rightLabel];
    
    centerhour_line3rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, 340, 387, 33)];
    centerhour_line3rightLabel.font=[UIFont systemFontOfSize:16];
    centerhour_line3rightLabel.minimumScaleFactor=0.7;
    centerhour_line3rightLabel.adjustsFontSizeToFitWidth=YES;
    centerhour_line3rightLabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centerhour_line3rightLabel];
    
    centerhour_line4rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, 370, 387, 33)];
    centerhour_line4rightLabel.font=[UIFont systemFontOfSize:16];
    centerhour_line4rightLabel.minimumScaleFactor=0.7;
    centerhour_line4rightLabel.adjustsFontSizeToFitWidth=YES;
    centerhour_line4rightLabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centerhour_line4rightLabel];
    
    centerhour_line5rightLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, 400, 387, 33)];
    centerhour_line5rightLabel.font=[UIFont systemFontOfSize:16];
    centerhour_line5rightLabel.minimumScaleFactor=0.7;
    centerhour_line5rightLabel.adjustsFontSizeToFitWidth=YES;
    centerhour_line5rightLabel.textColor=[UIColor darkGrayColor];
    [backgroundview addSubview:centerhour_line5rightLabel];
    
    
    UIView *lowerbackgroundview=[[UIView alloc]initWithFrame:CGRectMake(30, backgroundview.frame.origin.y+backgroundview.frame.size.height, contactview.frame.size.width-60, contactview.frame.size.height-backgroundview.frame.origin.y-backgroundview.frame.size.height-20)];
    lowerbackgroundview.backgroundColor=[UIColor grayColor];
    lowerbackgroundview.layer.opacity=0.5;
    centerInfoLowerBackgroundView=lowerbackgroundview;
    [contactscrollview addSubview:lowerbackgroundview];

    
    title_Email=[[UILabel alloc]initWithFrame:CGRectMake(60, 560, 81, 30)];
    title_Email.font=[UIFont systemFontOfSize:17];
    title_Email.minimumScaleFactor=0.7;
    title_Email.adjustsFontSizeToFitWidth=YES;
    title_Email.textColor=[UIColor blackColor];
    [contactscrollview addSubview:title_Email];

    
    title_Website=[[UILabel alloc]initWithFrame:CGRectMake(60, 600, 81, 30)];
    title_Website.font=[UIFont systemFontOfSize:17];
    title_Website.minimumScaleFactor=0.7;
    title_Website.adjustsFontSizeToFitWidth=YES;
    title_Website.textColor=[UIColor blackColor];
    [contactscrollview addSubview:title_Website];
    
    title_Others=[[UILabel alloc]initWithFrame:CGRectMake(60, 640, 81, 30)];
    title_Others.font=[UIFont systemFontOfSize:17];
    title_Others.minimumScaleFactor=0.7;
    title_Others.adjustsFontSizeToFitWidth=YES;
    title_Others.textColor=[UIColor blackColor];
    [contactscrollview addSubview:title_Others];
    
    
    mainimage=[[UIImageView alloc]initWithFrame:CGRectMake(backgroundview.frame.size.width-mainimage_width, 0, mainimage_width, backgroundview.frame.size.height-shopfront_height)];
    mainimage.contentMode=UIViewContentModeScaleAspectFill;
    mainimage.backgroundColor=[UIColor whiteColor];
    mainimage.userInteractionEnabled = YES;
    mainimage.clipsToBounds=YES;
    [backgroundview addSubview:mainimage];
    
    
    mainimagelabel=[[UILabel alloc]init];
    mainimagelabel.font=[UIFont systemFontOfSize:13];
    mainimagelabel.textColor=[UIColor whiteColor];
    mainimagelabel.textAlignment=NSTextAlignmentCenter;
    mainimagelabel.backgroundColor=[UIColor grayColor];
    mainimagelabel.layer.cornerRadius=4;
    mainimagelabel.layer.masksToBounds=YES;
    [mainimage addSubview:mainimagelabel];
    
    centerinfo_addimagebutton=[[UIButton alloc]initWithFrame:CGRectMake(mainimage.frame.size.width-30-30, mainimage.frame.size.height-30-30, 50, 50)];
    [centerinfo_addimagebutton setImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
    [centerinfo_addimagebutton addTarget:self action:@selector(centerinfo_addimagebuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    centerinfo_addimagebutton.hidden=YES;
    [mainimage addSubview:centerinfo_addimagebutton];

    
    shopfrontimage=[[UIImageView alloc]initWithFrame:CGRectMake(backgroundview.frame.size.width-mainimage_width, backgroundview.frame.size.height-shopfront_height, shopfront_width, shopfront_height)];
    shopfrontimage.contentMode=UIViewContentModeScaleAspectFill;
    shopfrontimage.userInteractionEnabled = YES;
    shopfrontimage.clipsToBounds=YES;
    shopfrontimage.backgroundColor=[UIColor whiteColor];
    shopfrontimage.tag=0;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCenterImageDetected:)];
    singleTap.numberOfTapsRequired = 1;
    [shopfrontimage addGestureRecognizer:singleTap];
    [backgroundview addSubview:shopfrontimage];

    
//    mapimage=[[UIImageView alloc]initWithFrame:CGRectMake(backgroundview.frame.size.width-432+120, 308, 120, 90)];
//    mapimage.contentMode=UIViewContentModeScaleAspectFill;
//    mapimage.clipsToBounds=YES;
//    mapimage.userInteractionEnabled = YES;
//    mapimage.backgroundColor=[UIColor whiteColor];
//    mapimage.tag=1;
//    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCenterImageDetected:)];
//    singleTap.numberOfTapsRequired = 1;
//    [mapimage addGestureRecognizer:singleTap];
//    [backgroundview addSubview:mapimage];
    
    launchimage_landscape=[[UIImageView alloc]initWithFrame:CGRectMake(backgroundview.frame.size.width-mainimage_width+shopfront_width, backgroundview.frame.size.height-shopfront_height, shopfront_width, shopfront_height)];
    launchimage_landscape.contentMode=UIViewContentModeScaleAspectFill;
    launchimage_landscape.clipsToBounds=YES;
    launchimage_landscape.userInteractionEnabled = YES;
    launchimage_landscape.backgroundColor=[UIColor whiteColor];
    launchimage_landscape.tag=2;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCenterImageDetected:)];
    singleTap.numberOfTapsRequired = 1;
    [launchimage_landscape addGestureRecognizer:singleTap];
    [backgroundview addSubview:launchimage_landscape];
    
    launchimage_portrait=[[UIImageView alloc]initWithFrame:CGRectMake(backgroundview.frame.size.width-mainimage_width+shopfront_width+shopfront_width, backgroundview.frame.size.height-shopfront_height, shopfront_height*9/16, shopfront_height)];
    launchimage_portrait.contentMode=UIViewContentModeScaleAspectFit;
    launchimage_portrait.userInteractionEnabled = YES;
    launchimage_portrait.backgroundColor=[UIColor whiteColor];
    launchimage_portrait.tag=3;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCenterImageDetected:)];
    singleTap.numberOfTapsRequired = 1;
    [launchimage_portrait addGestureRecognizer:singleTap];
    [backgroundview addSubview:launchimage_portrait];

    
    centeremailbutton=[[UIButton alloc]initWithFrame:CGRectMake(177, 560, contactview.frame.size.width-177-67, 30)];
    centeremailbutton.titleLabel.font=[UIFont systemFontOfSize:17];
    centeremailbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [centeremailbutton addTarget:self action:@selector(clicktoemail:) forControlEvents:UIControlEventTouchUpInside];
    [centeremailbutton setTitleColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [contactscrollview addSubview:centeremailbutton];
    
    
    centerwebsitebutton=[[UIButton alloc]initWithFrame:CGRectMake(177, 600, contactview.frame.size.width-177-67, 30)];
    centerwebsitebutton.titleLabel.font=[UIFont systemFontOfSize:17];
    centerwebsitebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [centerwebsitebutton addTarget:self action:@selector(clicktoweb:) forControlEvents:UIControlEventTouchUpInside];
    [centerwebsitebutton setTitleColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [contactscrollview addSubview:centerwebsitebutton];
    
    centerothersbutton=[[UIButton alloc]initWithFrame:CGRectMake(177, 640, contactview.frame.size.width-177-67, 30)];
    centerothersbutton.titleLabel.font=[UIFont systemFontOfSize:17];
    centerothersbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [centerothersbutton addTarget:self action:@selector(clicktoother:) forControlEvents:UIControlEventTouchUpInside];
    [centerothersbutton setTitleColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    [contactscrollview addSubview:centerothersbutton];
    
    scCenterInformationLanguage = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"English",@"中文",nil]];
    scCenterInformationLanguage.frame=CGRectMake(contactview.frame.size.width-30-150, 15, 150, 30);
    scCenterInformationLanguage.selectedSegmentIndex=[globalvariables.language isEqualToString:@"English"]?0:1;
    scCenterInformationLanguage.hidden=YES;
    [scCenterInformationLanguage addTarget:self action:@selector(changeeditcenterinformationlanguage) forControlEvents:UIControlEventValueChanged];
    [scCenterInformationLanguage setTintColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0]];
    [contactscrollview addSubview:scCenterInformationLanguage];
    
    centerinfo_editbutton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80-30, 31, 80, 30)];
    centerinfo_editbutton.titleLabel.textColor=[UIColor whiteColor];
    centerinfo_editbutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [centerinfo_editbutton addTarget:self action:@selector(centerinfo_editbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:centerinfo_editbutton];
   
    
    
    
    
    centerinfo_savebutton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-80-30, 31, 80, 30)];
    centerinfo_savebutton.titleLabel.textColor=[UIColor whiteColor];
    centerinfo_savebutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
    [centerinfo_savebutton addTarget:self action:@selector(centerinfo_savebuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    centerinfo_savebutton.hidden=YES;
    [self.view addSubview:centerinfo_savebutton];

    
    centerinfo_cancelbutton = [[UIButton alloc]initWithFrame:CGRectMake(60, 31, 80, 30)];
    centerinfo_cancelbutton.titleLabel.textColor=[UIColor whiteColor];
    centerinfo_cancelbutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [centerinfo_cancelbutton addTarget:self action:@selector(centerinfo_cancelbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    centerinfo_cancelbutton.hidden=YES;
    [self.view addSubview:centerinfo_cancelbutton];
    
    
    centernametext=[[UITextField alloc]initWithFrame:CGRectMake(30, 15, contactview.frame.size.width-100-165-210, 30)];
    centernametext.borderStyle = UITextBorderStyleRoundedRect;
    centernametext.font=[UIFont systemFontOfSize:16];
    centernametext.textColor=[UIColor darkGrayColor];
    centernametext.placeholder=[MyClass returntitlewithtitle:@"Center Name"];
    [centernametext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centernametext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centernametext.hidden=YES;
    [contactscrollview addSubview:centernametext];
    
    schoolregnumbertext=[[UITextField alloc]initWithFrame:CGRectMake(centernametext.frame.origin.x+centernametext.frame.size.width+5, 15, 205, 30)];
    schoolregnumbertext.borderStyle = UITextBorderStyleRoundedRect;
    schoolregnumbertext.font=[UIFont systemFontOfSize:16];
    schoolregnumbertext.textColor=[UIColor darkGrayColor];
    schoolregnumbertext.placeholder=[MyClass returntitlewithtitle:@"School Registration No."];
    [schoolregnumbertext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    schoolregnumbertext.clearButtonMode = UITextFieldViewModeWhileEditing;
    schoolregnumbertext.hidden=YES;
    [contactscrollview addSubview:schoolregnumbertext];
    

    centershortnametext=[[UITextField alloc]initWithFrame:CGRectMake(30, 50, contactview.frame.size.width-100-165-210, 25)];
    centershortnametext.borderStyle = UITextBorderStyleRoundedRect;
    centershortnametext.font=[UIFont systemFontOfSize:14];
    centershortnametext.textColor=[UIColor darkGrayColor];
    centershortnametext.placeholder=[MyClass returntitlewithtitle:@"Center Short Name"];
    [centershortnametext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centershortnametext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centershortnametext.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    centershortnametext.hidden=YES;
    [contactscrollview addSubview:centershortnametext];
    
    
    
    centeraddresstext=[[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(30, 15, 477, 64)];
    //centeraddresstext.borderStyle = UITextBorderStyleRoundedRect;
    centeraddresstext.font=[UIFont systemFontOfSize:16];
    centeraddresstext.textColor=[UIColor darkGrayColor];
    centeraddresstext.placeholder=[MyClass returntitlewithtitle:@"Address"];
    centeraddresstext.layer.borderColor=[UIColor lightGrayColor].CGColor;
    centeraddresstext.layer.borderWidth=0.5;
    centeraddresstext.layer.cornerRadius=6;
    centeraddresstext.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    //[centeraddresstext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventValueChanged];
    centeraddresstext.hidden=YES;
    centeraddresstext.delegate=self;
    [backgroundview addSubview:centeraddresstext];
    
    centercontacttext=[[UITextField alloc]initWithFrame:CGRectMake(65, 85, 442, 30)];
    centercontacttext.borderStyle = UITextBorderStyleRoundedRect;
    centercontacttext.font=[UIFont systemFontOfSize:16];
    centercontacttext.textColor=[UIColor darkGrayColor];
    centercontacttext.placeholder=[MyClass returntitlewithtitle:@"Contact"];
    [centercontacttext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centercontacttext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centercontacttext.hidden=YES;
    [backgroundview addSubview:centercontacttext];
    
    
    centerfaxtext=[[UITextField alloc]initWithFrame:CGRectMake(65, 120, 442, 30)];
    centerfaxtext.borderStyle = UITextBorderStyleRoundedRect;
    centerfaxtext.font=[UIFont systemFontOfSize:16];
    centerfaxtext.textColor=[UIColor darkGrayColor];
    centerfaxtext.placeholder=[MyClass returntitlewithtitle:@"Fax"];
    [centerfaxtext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerfaxtext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerfaxtext.hidden=YES;
    [backgroundview addSubview:centerfaxtext];
    
    centerwhatsapptext=[[UITextField alloc]initWithFrame:CGRectMake(65, 155, 442, 30)];
    centerwhatsapptext.borderStyle = UITextBorderStyleRoundedRect;
    centerwhatsapptext.font=[UIFont systemFontOfSize:16];
    centerwhatsapptext.textColor=[UIColor darkGrayColor];
    centerwhatsapptext.placeholder=[MyClass returntitlewithtitle:@"Whatsapp"];
    [centerwhatsapptext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerwhatsapptext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerwhatsapptext.hidden=YES;
    [backgroundview addSubview:centerwhatsapptext];
    
    centerlattext=[[UITextField alloc]initWithFrame:CGRectMake(65, 190, 219, 30)];
    centerlattext.borderStyle = UITextBorderStyleRoundedRect;
    centerlattext.font=[UIFont systemFontOfSize:16];
    centerlattext.textColor=[UIColor darkGrayColor];
    centerlattext.placeholder=[MyClass returntitlewithtitle:@"Location Latitude"];
    [centerlattext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerlattext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerlattext.hidden=YES;
    [backgroundview addSubview:centerlattext];
    
    centerlongtext=[[UITextField alloc]initWithFrame:CGRectMake(288, 190, 219, 30)];
    centerlongtext.borderStyle = UITextBorderStyleRoundedRect;
    centerlongtext.font=[UIFont systemFontOfSize:16];
    centerlongtext.textColor=[UIColor darkGrayColor];
    centerlongtext.placeholder=[MyClass returntitlewithtitle:@"Location Longitude"];
    [centerlongtext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerlongtext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerlongtext.hidden=YES;
    [backgroundview addSubview:centerlongtext];
    
    centerhour_line1lefttext=[[UITextField alloc]initWithFrame:CGRectMake(30, 265, 120, 30)];
    centerhour_line1lefttext.borderStyle = UITextBorderStyleRoundedRect;
    centerhour_line1lefttext.font=[UIFont systemFontOfSize:16];
    centerhour_line1lefttext.textColor=[UIColor darkGrayColor];
    centerhour_line1lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 1)"];
    [centerhour_line1lefttext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerhour_line1lefttext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerhour_line1lefttext.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    centerhour_line1lefttext.hidden=YES;
    [backgroundview addSubview:centerhour_line1lefttext];
    
    centerhour_line2lefttext=[[UITextField alloc]initWithFrame:CGRectMake(30, centerhour_line1lefttext.frame.origin.y+centerhour_line1lefttext.frame.size.height+5, 120, 30)];
    centerhour_line2lefttext.borderStyle = UITextBorderStyleRoundedRect;
    centerhour_line2lefttext.font=[UIFont systemFontOfSize:16];
    centerhour_line2lefttext.textColor=[UIColor darkGrayColor];
    centerhour_line2lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 2)"];
    [centerhour_line2lefttext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerhour_line2lefttext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerhour_line2lefttext.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    centerhour_line2lefttext.hidden=YES;
    [backgroundview addSubview:centerhour_line2lefttext];
    
    centerhour_line3lefttext=[[UITextField alloc]initWithFrame:CGRectMake(30, centerhour_line2lefttext.frame.origin.y+centerhour_line2lefttext.frame.size.height+5, 120, 30)];
    centerhour_line3lefttext.borderStyle = UITextBorderStyleRoundedRect;
    centerhour_line3lefttext.font=[UIFont systemFontOfSize:16];
    centerhour_line3lefttext.textColor=[UIColor darkGrayColor];
    centerhour_line3lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 3)"];
    [centerhour_line3lefttext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerhour_line3lefttext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerhour_line3lefttext.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    centerhour_line3lefttext.hidden=YES;
    [backgroundview addSubview:centerhour_line3lefttext];
    
    centerhour_line4lefttext=[[UITextField alloc]initWithFrame:CGRectMake(30, centerhour_line3lefttext.frame.origin.y+centerhour_line3lefttext.frame.size.height+5, 120, 30)];
    centerhour_line4lefttext.borderStyle = UITextBorderStyleRoundedRect;
    centerhour_line4lefttext.font=[UIFont systemFontOfSize:16];
    centerhour_line4lefttext.textColor=[UIColor darkGrayColor];
    centerhour_line4lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 4)"];
    [centerhour_line4lefttext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerhour_line4lefttext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerhour_line4lefttext.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    centerhour_line4lefttext.hidden=YES;
    [backgroundview addSubview:centerhour_line4lefttext];
    
    centerhour_line5lefttext=[[UITextField alloc]initWithFrame:CGRectMake(30, centerhour_line4lefttext.frame.origin.y+centerhour_line4lefttext.frame.size.height+5, 120, 30)];
    centerhour_line5lefttext.borderStyle = UITextBorderStyleRoundedRect;
    centerhour_line5lefttext.font=[UIFont systemFontOfSize:16];
    centerhour_line5lefttext.textColor=[UIColor darkGrayColor];
    centerhour_line5lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 5)"];
    [centerhour_line5lefttext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerhour_line5lefttext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerhour_line5lefttext.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    centerhour_line5lefttext.hidden=YES;
    [backgroundview addSubview:centerhour_line5lefttext];
    
    centerhour_line1righttext=[[UITextField alloc]initWithFrame:CGRectMake(170, centerhour_line1lefttext.frame.origin.y, 337, 30)];
    centerhour_line1righttext.borderStyle = UITextBorderStyleRoundedRect;
    centerhour_line1righttext.font=[UIFont systemFontOfSize:16];
    centerhour_line1righttext.textColor=[UIColor darkGrayColor];
    centerhour_line1righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 1)"];
    [centerhour_line1righttext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerhour_line1righttext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerhour_line1righttext.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    centerhour_line1righttext.hidden=YES;
    [backgroundview addSubview:centerhour_line1righttext];
    
    centerhour_line2righttext=[[UITextField alloc]initWithFrame:CGRectMake(170, centerhour_line1righttext.frame.origin.y+centerhour_line1righttext.frame.size.height+5, 337, 30)];
    centerhour_line2righttext.borderStyle = UITextBorderStyleRoundedRect;
    centerhour_line2righttext.font=[UIFont systemFontOfSize:16];
    centerhour_line2righttext.textColor=[UIColor darkGrayColor];
    centerhour_line2righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 2)"];
    [centerhour_line2righttext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerhour_line2righttext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerhour_line2righttext.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    centerhour_line2righttext.hidden=YES;
    [backgroundview addSubview:centerhour_line2righttext];
    
    centerhour_line3righttext=[[UITextField alloc]initWithFrame:CGRectMake(170, centerhour_line2righttext.frame.origin.y+centerhour_line2righttext.frame.size.height+5, 337, 30)];
    centerhour_line3righttext.borderStyle = UITextBorderStyleRoundedRect;
    centerhour_line3righttext.font=[UIFont systemFontOfSize:16];
    centerhour_line3righttext.textColor=[UIColor darkGrayColor];
    centerhour_line3righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 3)"];
    [centerhour_line3righttext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerhour_line3righttext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerhour_line3righttext.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    centerhour_line3righttext.hidden=YES;
    [backgroundview addSubview:centerhour_line3righttext];
    
    centerhour_line4righttext=[[UITextField alloc]initWithFrame:CGRectMake(170, centerhour_line3righttext.frame.origin.y+centerhour_line3righttext.frame.size.height+5, 337, 30)];
    centerhour_line4righttext.borderStyle = UITextBorderStyleRoundedRect;
    centerhour_line4righttext.font=[UIFont systemFontOfSize:16];
    centerhour_line4righttext.textColor=[UIColor darkGrayColor];
    centerhour_line4righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 4)"];
    [centerhour_line4righttext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerhour_line4righttext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerhour_line4righttext.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    centerhour_line4righttext.hidden=YES;
    [backgroundview addSubview:centerhour_line4righttext];
    
    centerhour_line5righttext=[[UITextField alloc]initWithFrame:CGRectMake(170, centerhour_line4righttext.frame.origin.y+centerhour_line4righttext.frame.size.height+5, 337, 30)];
    centerhour_line5righttext.borderStyle = UITextBorderStyleRoundedRect;
    centerhour_line5righttext.font=[UIFont systemFontOfSize:16];
    centerhour_line5righttext.textColor=[UIColor darkGrayColor];
    centerhour_line5righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 5)"];
    [centerhour_line5righttext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerhour_line5righttext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerhour_line5righttext.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    centerhour_line5righttext.hidden=YES;
    [backgroundview addSubview:centerhour_line5righttext];
    
    centeremailaddresstext=[[UITextField alloc]initWithFrame:CGRectMake(177, 560, contactview.frame.size.width-177-67, 30)];
    centeremailaddresstext.borderStyle = UITextBorderStyleRoundedRect;
    centeremailaddresstext.font=[UIFont systemFontOfSize:17];
    centeremailaddresstext.textColor=[UIColor darkGrayColor];
    centeremailaddresstext.placeholder=[MyClass returntitlewithtitle:@"Email"];
    [centeremailaddresstext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centeremailaddresstext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centeremailaddresstext.hidden=YES;
    [contactscrollview addSubview:centeremailaddresstext];
    
    centerwebsitetext=[[UITextField alloc]initWithFrame:CGRectMake(177, 600, contactview.frame.size.width-177-67, 30)];
    centerwebsitetext.borderStyle = UITextBorderStyleRoundedRect;
    centerwebsitetext.font=[UIFont systemFontOfSize:17];
    centerwebsitetext.textColor=[UIColor darkGrayColor];
    centerwebsitetext.placeholder=[MyClass returntitlewithtitle:@"Website"];
    [centerwebsitetext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerwebsitetext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerwebsitetext.hidden=YES;
    [contactscrollview addSubview:centerwebsitetext];
    
    centerotherstext=[[UITextField alloc]initWithFrame:CGRectMake(177, 640, contactview.frame.size.width-177-67, 30)];
    centerotherstext.borderStyle = UITextBorderStyleRoundedRect;
    centerotherstext.font=[UIFont systemFontOfSize:17];
    centerotherstext.textColor=[UIColor darkGrayColor];
    centerotherstext.placeholder=[MyClass returntitlewithtitle:@"Others"];
    [centerotherstext addTarget:self action:@selector(updatecenterinformationtext:) forControlEvents:UIControlEventEditingChanged];
    centerotherstext.clearButtonMode = UITextFieldViewModeWhileEditing;
    centerotherstext.hidden=YES;
    [contactscrollview addSubview:centerotherstext];
    
    

}

- (void)keyboardWillHide: (NSNotification *) notification
{
    // Do something here
    keyboardheight=0;
    [self adjusttablesize];
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    [self adjusttablesize];
    
}

-(void) adjusttablesize
{
    float tableheight=0;
    CGFloat screenHeight = self.view.window ? self.view.window.bounds.size.height : self.view.bounds.size.height;
    
    if (lastviewindex==0) {
        if (keyboardheight==0) {
            contactscrollview.frame=CGRectMake(0, 0, contactview.frame.size.width, contactview.frame.size.height);
        }else{
            tableheight=screenHeight-keyboardheight-contactview.frame.origin.y;
            contactscrollview.frame=CGRectMake(0, 0, contactview.frame.size.width, tableheight);
        }
    }else if (lastviewindex==2) {
        subjectViewBottomConstraint.constant=keyboardheight;
    }else if (lastviewindex==3) {
        classroomViewBottomConstraint.constant=keyboardheight;
    }else if (lastviewindex==4) {
        staffViewBottomConstraint.constant=keyboardheight;
    }else if (lastviewindex==5) {
        productViewBottomConstraint.constant=keyboardheight;
    }else if (lastviewindex==6) {
        marketingViewBottomConstraint.constant=keyboardheight;
    }else if (lastviewindex==7) {
        policyViewBottomConstraint.constant=keyboardheight;
    }

}

-(void) checktoreloadapp
{
    
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {
        if ([myPopoverController presentingViewController].isBeingPresented) {
            [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([myMarketingPopoverController presentingViewController].isBeingPresented){
            [[myMarketingPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([myProductCategorySelectionPopoverController presentingViewController].isBeingPresented){
            [[myProductCategorySelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if ([mySubjectCategorySelectionPopoverController presentingViewController].isBeingPresented){
            [[mySubjectCategorySelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
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
                }else if ([myMarketingPopoverController presentingViewController].isBeingPresented){
                    [[myMarketingPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if ([myProductCategorySelectionPopoverController presentingViewController].isBeingPresented){
                    [[myProductCategorySelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if ([mySubjectCategorySelectionPopoverController presentingViewController].isBeingPresented){
                    [[mySubjectCategorySelectionPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
                }else if (self.presentedViewController==switchcenterviewcontroller) {
                    [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
                }else{
                    [self.mainSlideMenu closeLeftMenu];
                }
        [self closesidewindow];
        [MyClass removeallsidewindowsexceptsidewindow:sidewindowview sidewindowbutton:sidewindowviewclosebutton];
                [self reloadPage];
            //}
        //}];
    }
}

-(void) loadingindicatorwithoption:(NSString *)option
{
    if (lastviewindex==0) {
        loadingindicatorview.hidden=YES;
        if ([option isEqualToString:@"start"]) {
            aicontactus.hidden=NO;
            [aicontactus startAnimating];
        }else{
            aicontactus.hidden=YES;
            [aicontactus stopAnimating];
        }
    }else{
        if ([option isEqualToString:@"start"]) {
            loadingindicatorview.hidden=NO;
            [ailoadclass startAnimating];
        }else{
            loadingindicatorview.hidden=YES;
            [ailoadclass stopAnimating];
        }
    }
}

-(void) refreshlanguage
{
    
    headercentername.text=[MyClass returnWindowTitle];
    headertitlename.text=[MyClass returntitlewithtitle:@"Center Information"];
    [centerinfo_editbutton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];

    [staff_userprivilegebutton setTitle:[MyClass returntitlewithtitle:@"Privilege"] forState:UIControlStateNormal];
    [centerinfo_cancelbutton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    [centerinfo_savebutton setTitle:[MyClass returntitlewithtitle:@"Save"] forState:UIControlStateNormal];
    title_Center_hours_except_center_holiday.text=[MyClass returntitlewithtitle:@"Center hours (except center holiday)"];
    title_Email.text=[MyClass returntitlewithtitle:@"Email"];
    title_Website.text=[MyClass returntitlewithtitle:@"Website"];
    title_Others.text=[MyClass returntitlewithtitle:@"Others"];
    if (selectedMainImage==0) {
        mainimagelabel.text=[MyClass returntitlewithtitle:@"Shop Front"];
    }/*else if (selectedMainImage==1) {
        mainimagelabel.text=[MyClass returntitlewithtitle:@"Map"];
    }*/else if (selectedMainImage==2) {
        mainimagelabel.text=[MyClass returntitlewithtitle:@"iPad Launch Image"];
    }else if (selectedMainImage==3) {
        mainimagelabel.text=[MyClass returntitlewithtitle:@"Mobile Launch Image"];
    }
    
    [scsubjectstatus setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [scsubjectstatus setTitle:[MyClass returntitlewithtitle:@"Active"] forSegmentAtIndex:1];
    [scsubjectstatus setTitle:[MyClass returntitlewithtitle:@"Inactive"] forSegmentAtIndex:2];
    
    
    [scstaffstatus setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [scstaffstatus setTitle:[MyClass returntitlewithtitle:@"Active"] forSegmentAtIndex:1];
    [scstaffstatus setTitle:[MyClass returntitlewithtitle:@"Inactive"] forSegmentAtIndex:2];
    
    [scstaffrole setTitle:[MyClass returntitlewithtitle:[AllRoleArray objectAtIndex:0]] forSegmentAtIndex:0];
    [scstaffrole setTitle:[MyClass returntitlewithtitle:[AllRoleArray objectAtIndex:1]] forSegmentAtIndex:1];
    [scstaffrole setTitle:[MyClass returntitlewithtitle:[AllRoleArray objectAtIndex:2]] forSegmentAtIndex:2];

    [scPolicyType setTitle:[MyClass returntitlewithtitle:@"General"] forSegmentAtIndex:0];
    [scPolicyType setTitle:[MyClass returntitlewithtitle:@"T&C For Invoice And Receipt"] forSegmentAtIndex:1];
    [scPolicyType setTitle:[MyClass returntitlewithtitle:@"Leave"] forSegmentAtIndex:2];
    
    [scproductstatus setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [scproductstatus setTitle:[MyClass returntitlewithtitle:@"Active"] forSegmentAtIndex:1];
    [scproductstatus setTitle:[MyClass returntitlewithtitle:@"Inactive"] forSegmentAtIndex:2];
    
    [scmarketingcategory setTitle:[MyClass returntitlewithtitle:@"Media"] forSegmentAtIndex:0];
    [scmarketingcategory setTitle:[MyClass returntitlewithtitle:@"Source"] forSegmentAtIndex:1];
    [scmarketingcategory setTitle:[MyClass returntitlewithtitle:@"Promotion"] forSegmentAtIndex:2];
    if(globalvariables.centerrecord.ecoupon && scmarketingcategory.numberOfSegments==4){
        [scmarketingcategory setTitle:[MyClass returntitlewithtitle:@"Coupon"] forSegmentAtIndex:3];
    }
    
    [scmarketingstatus setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [scmarketingstatus setTitle:[MyClass returntitlewithtitle:@"Valid"] forSegmentAtIndex:1];
    [scmarketingstatus setTitle:[MyClass returntitlewithtitle:@"Expired"] forSegmentAtIndex:2];
    
    [scproductstatus setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [scproductstatus setTitle:[MyClass returntitlewithtitle:@"Active"] forSegmentAtIndex:1];
    [scproductstatus setTitle:[MyClass returntitlewithtitle:@"Inactive"] forSegmentAtIndex:2];
    
    title_Nature_Name.text=[MyClass returntitlewithtitle:@"Nature Name"];
    if([globalvariables.language isEqualToString:@"English"]){
        title_Nature_Name_1.text=[MyClass returntitlewithtitle:@"English"];
        title_Nature_Name_2.text=[MyClass returntitlewithtitle:@"Chinese"];
    }else{
        title_Nature_Name_1.text=[MyClass returntitlewithtitle:@"Chinese"];
        title_Nature_Name_2.text=[MyClass returntitlewithtitle:@"English"];
    }
    title_Available_For_Student_Request.text=[MyClass returntitlewithtitle:@"Available For Student Request"];
    title_Attendance_Settings.text=[MyClass returntitlewithtitle:@"Attendance Settings"];
    title_Absent.text=[MyClass returntitlewithtitle:@"attendance_Absent"];
    title_Makeup.text=[MyClass returntitlewithtitle:@"attendance_Makeup"];
    title_Extend.text=[MyClass returntitlewithtitle:@"attendance_Extend"];
    title_Quota_Required.text=[MyClass returntitlewithtitle:@"Quota Required"];
    title_Auto_Approve.text=[MyClass returntitlewithtitle:@"Auto_Approve"];
    title_Default_Nature_For_Staff.text=[MyClass returntitlewithtitle:@"Default Nature For Staff"];
    title_Default_Nature_For_Student.text=[MyClass returntitlewithtitle:@"Default Nature For Student"];
    title_Leave_Nature.text=[[MyClass returntitlewithtitle:@"Leave Nature"] uppercaseString];
    title_Configuration.text=[[MyClass returntitlewithtitle:@"Settings"] uppercaseString];
    title_Remarks.text=[[MyClass returntitlewithtitle:@"Remarks"] uppercaseString];
    
    
    [self updateheadercentertitle];
    [self refreshmenutitle];
    [self formatmainimagelabel];
    [self refreshtableheader];
    
}

-(void) formatmainimagelabel
{
    mainimagelabel.frame=CGRectMake(500, 0, 500, 30);
    [mainimagelabel sizeToFit];
    mainimagelabel.frame=CGRectMake(mainimage.frame.size.width-(mainimagelabel.frame.size.width+20)-10, 15, mainimagelabel.frame.size.width+20, 25);
}

- (CGFloat)visibleCenterWidth
{
    CGFloat width = self.view.bounds.size.width;
    UIWindow *window = self.view.window;
    if (!window || width < 1) return width;
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGFloat leftShift = MAX(CGRectGetMinX(frameInWindow) - CGRectGetMinX(window.bounds), 0);
    CGFloat rightOverflow = MAX(CGRectGetMaxX(frameInWindow) - CGRectGetMaxX(window.bounds), 0);
    CGFloat menuSlide = MIN(leftShift, rightOverflow);
    return MAX(width - (rightOverflow - menuSlide), 0);
}

- (CGFloat)visibleCenterHeight
{
    CGFloat height = self.view.bounds.size.height;
    UIWindow *window = self.view.window;
    if (!window || height < 1) return height;
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    return MAX(MIN(MIN(CGRectGetMaxY(frameInWindow), CGRectGetMaxY(window.bounds)) - CGRectGetMinY(frameInWindow), height), 0);
}

- (CGRect)visibleWindowFrame
{
    UIWindow *window = self.view.window ? self.view.window : mainWindow;
    if (!window) return CGRectZero;
    if (!self.isViewLoaded || !self.view.window) return window.bounds;
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGRect visible = CGRectIntersection(frameInWindow, window.bounds);
    if (CGRectIsNull(visible) || visible.size.width < 1 || visible.size.height < 1) return window.bounds;
    return visible;
}

- (void)layoutContactCard
{
    if (!contactview || !contactscrollview || !centerInfoBackgroundView) return;
    CGFloat width = contactview.bounds.size.width;
    CGFloat height = contactview.bounds.size.height;
    CGFloat visibleBelowTop = [self visibleCenterHeight] - CGRectGetMinY(contactview.frame);
    if (visibleBelowTop > height) height = visibleBelowTop;
    if (width < 1 || height < 1) return;
    contactview.clipsToBounds = NO;
    if (keyboardheight == 0) {
        contactscrollview.frame = CGRectMake(0, 0, width, height);
    } else {
        CGRect scrollFrame = contactscrollview.frame;
        scrollFrame.size.width = width;
        contactscrollview.frame = scrollFrame;
    }
    CGFloat cardWidth = MAX(width - 60.0, 0);
    CGFloat upperHeight = 458.0;
    CGFloat lowerHeight = height - 80.0 - upperHeight - 20.0;
    CGFloat contentHeight = height;
    if (lowerHeight < 140.0) {
        lowerHeight = 140.0;
        contentHeight = 80.0 + upperHeight + lowerHeight + 20.0;
    }
    contactscrollview.contentSize = CGSizeMake(width, MAX(contentHeight, height));
    centerInfoBackgroundView.frame = CGRectMake(30, 80, cardWidth, upperHeight);
    if (centerInfoLowerBackgroundView) {
        centerInfoLowerBackgroundView.frame = CGRectMake(30, 80.0 + upperHeight, cardWidth, lowerHeight);
    }
    if (centernamelabel) centernamelabel.frame = CGRectMake(30, 20, MAX(width - 350.0, 0), 33);
    if (schoolregnumberLabel) schoolregnumberLabel.frame = CGRectMake(width - 130.0, 20, 100, 33);
    if (schoolregnumberTitle) schoolregnumberTitle.frame = CGRectMake(width - 300.0, 20, 180, 33);
    if (centershortnamelabel) centershortnamelabel.frame = CGRectMake(32, 55, MAX(width - 100.0, 0), 20);
    CGFloat mainimageWidth = upperHeight * 155.0 / (155.0 * 3.0 / 4.0 + 48.0);
    CGFloat shopfrontHeight = upperHeight * 48.0 / (155.0 * 3.0 / 4.0 + 48.0);
    CGFloat shopfrontWidth = shopfrontHeight * 4.0 / 3.0;
    if (mainimage) {
        mainimage.frame = CGRectMake(cardWidth - mainimageWidth, 0, mainimageWidth, upperHeight - shopfrontHeight);
        if (centerinfo_addimagebutton) centerinfo_addimagebutton.frame = CGRectMake(mainimage.frame.size.width - 60.0, mainimage.frame.size.height - 60.0, 50, 50);
    }
    if (shopfrontimage) shopfrontimage.frame = CGRectMake(cardWidth - mainimageWidth, upperHeight - shopfrontHeight, shopfrontWidth, shopfrontHeight);
    if (launchimage_landscape) launchimage_landscape.frame = CGRectMake(cardWidth - mainimageWidth + shopfrontWidth, upperHeight - shopfrontHeight, shopfrontWidth, shopfrontHeight);
    if (launchimage_portrait) launchimage_portrait.frame = CGRectMake(cardWidth - mainimageWidth + shopfrontWidth * 2.0, upperHeight - shopfrontHeight, shopfrontHeight * 9.0 / 16.0, shopfrontHeight);
    CGFloat linkWidth = MAX(width - 177.0 - 67.0, 0);
    if (centeremailbutton) centeremailbutton.frame = CGRectMake(177, 560, linkWidth, 30);
    if (centerwebsitebutton) centerwebsitebutton.frame = CGRectMake(177, 600, linkWidth, 30);
    if (centerothersbutton) centerothersbutton.frame = CGRectMake(177, 640, linkWidth, 30);
    if (centeremailaddresstext) centeremailaddresstext.frame = CGRectMake(177, 560, linkWidth, 30);
    if (centerwebsitetext) centerwebsitetext.frame = CGRectMake(177, 600, linkWidth, 30);
    if (centerotherstext) centerotherstext.frame = CGRectMake(177, 640, linkWidth, 30);
    if (scCenterInformationLanguage) scCenterInformationLanguage.frame = CGRectMake(width - 180.0, 15, 150, 30);
    CGFloat nameWidth = MAX(width - 475.0, 0);
    if (centernametext) centernametext.frame = CGRectMake(30, 15, nameWidth, 30);
    if (schoolregnumbertext) schoolregnumbertext.frame = CGRectMake(35.0 + nameWidth, 15, 205, 30);
    if (centershortnametext) centershortnametext.frame = CGRectMake(30, 50, nameWidth, 25);
}

- (void)layoutCenterInformationForCurrentSize
{
    CGFloat width = [self visibleCenterWidth];
    CGFloat height = [self visibleCenterHeight];
    if (width < 1 || height < 1) return;
    if (!edgeConstants) {
        edgeConstants = [NSMutableDictionary dictionary];
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            BOOL horizontal = constraint.firstItem == self.view && (constraint.firstAttribute == NSLayoutAttributeTrailing || constraint.firstAttribute == NSLayoutAttributeTrailingMargin) && constraint.secondAttribute == NSLayoutAttributeTrailing;
            BOOL vertical = constraint.firstItem == self.view && constraint.firstAttribute == NSLayoutAttributeBottom && constraint.secondAttribute == NSLayoutAttributeBottom;
            if (horizontal || vertical) {
                edgeConstants[[NSValue valueWithNonretainedObject:constraint]] = @(constraint.constant);
            }
        }
    }
    CGFloat overflow = MAX(self.view.bounds.size.width - width, 0);
    CGFloat visibleBottom = self.view.bounds.size.height;
    if (self.view.window) {
        CGPoint bottom = [self.view convertPoint:CGPointMake(0, CGRectGetMaxY(self.view.window.bounds)) fromView:nil];
        visibleBottom = MIN(MAX(bottom.y, 0), self.view.bounds.size.height);
    }
    CGFloat verticalOverflow = MAX(self.view.bounds.size.height - visibleBottom, 0);
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        NSNumber *original = edgeConstants[[NSValue valueWithNonretainedObject:constraint]];
        if (!original) continue;
        BOOL vertical = constraint.firstAttribute == NSLayoutAttributeBottom;
        CGFloat target = original.doubleValue + (vertical ? verticalOverflow : overflow);
        if (fabs(constraint.constant - target) > 0.5) constraint.constant = target;
    }
    for (UIView *subview in self.view.subviews) {
        if (subview == headertitleview || subview == centerinfo_editbutton || subview == centerinfo_savebutton) continue;
        if (subview.frame.origin.y < 1 && subview.frame.origin.x < 1 && subview.frame.size.height >= 60 && subview.frame.size.height <= 76) {
            CGRect frame = subview.frame;
            frame.size.width = width;
            subview.frame = frame;
        }
    }
    CGFloat titleWidth = MAX(width - 140.0, 0);
    headertitleview.frame = CGRectMake(70, 0, titleWidth, 68);
    headertitlename.frame = CGRectMake(0, 25, titleWidth, 20);
    switchcenterbutton.frame = CGRectMake(0, 0, titleWidth, 68);
    [self updateheadercentertitle];
    if (centerinfo_editbutton) centerinfo_editbutton.frame = CGRectMake(width - 110, 31, 80, 30);
    if (centerinfo_savebutton) centerinfo_savebutton.frame = CGRectMake(width - 110, 31, 80, 30);
    CGFloat calendarWidth = MAX(width - 8.0, 0);
    CGFloat calendarHeight = MAX(height - 108.0 - 4.0, 0);
    if (horizontalseparation > 0 && (fabs(calendarWidth - laidOutCalendarWidth) > 0.5 || fabs(calendarHeight - laidOutCalendarHeight) > 0.5)) {
        cellwidth = MAX((width - 3 * horizontalseparation - 8.0) / 28.0, 1);
        leftmargin = (width - cellwidth * 28.0 - 3 * horizontalseparation - 8.0) / 2.0;
        cellheight = (calendarHeight - topmargin - 2 * verticalseparation - 3 * headerheight - 4) / 21.0;
        if (monthnameArray.count > 0) {
            laidOutCalendarWidth = calendarWidth;
            laidOutCalendarHeight = calendarHeight;
            [self drawCalendar];
        }
    }
    [self layoutContactCard];
    [self layoutPolicyForCurrentSize];
    [self layoutSubscriptionForCurrentSize];
    [self layoutLoadingIndicator];
}

- (void)layoutLoadingIndicator
{
    if (!loadingindicatorview) return;
    CGRect bounds = self.view.bounds;
    CGRect visible = bounds;
    UIWindow *window = self.view.window;
    if (window) {
        CGRect frameInWindow = [self.view convertRect:bounds toView:nil];
        CGFloat leftShift = MAX(CGRectGetMinX(frameInWindow) - CGRectGetMinX(window.bounds), 0);
        CGFloat rightOverflow = MAX(CGRectGetMaxX(frameInWindow) - CGRectGetMaxX(window.bounds), 0);
        CGFloat menuSlide = MIN(leftShift, rightOverflow);
        CGPoint bottom = [self.view convertPoint:CGPointMake(0, CGRectGetMaxY(window.bounds)) fromView:nil];
        visible = CGRectMake(0, 0, MAX(bounds.size.width - (rightOverflow - menuSlide), 0), MIN(MAX(bottom.y, 0), bounds.size.height));
    }
    loadingindicatorview.frame = visible;
    if (loadingIndicatorCenterView) {
        loadingIndicatorCenterView.frame = CGRectMake((visible.size.width - 180.0) / 2.0, (visible.size.height - 140.0) / 2.0, 180, 140);
    }
}

- (void)layoutSubscriptionForCurrentSize
{
    if (!subscriptionview || !subscriptiontable || !devicetable) return;
    CGFloat width = subscriptionview.bounds.size.width;
    CGFloat height = subscriptionview.bounds.size.height;
    if (width < 1 || height < 1) return;
    CGFloat tableX = CGRectGetMaxX(subscriptiontable.frame);
    CGFloat tableY = subscriptiontable.frame.origin.y;
    CGFloat tableWidth = MAX(width - tableX - 20.0, 0);
    CGFloat tableHeight = MAX(height - tableY - 60.0, 0);
    devicetable.frame = CGRectMake(tableX, tableY, tableWidth, tableHeight);
    if (subscriptionEditBackground) subscriptionEditBackground.frame = CGRectMake(tableX, tableY + tableHeight, tableWidth, 40);
    if (subscriptionSeparator) subscriptionSeparator.frame = CGRectMake(tableX, tableY, 0.8, tableHeight + 40.0);
    if (deviceTableHeaderView) deviceTableHeaderView.frame = CGRectMake(tableX, 25, tableWidth, 40);
    if (devicelisteditbutton) devicelisteditbutton.frame = CGRectMake(width - 140.0, tableY + tableHeight, 100, 40);
    if (devicecountlabel) devicecountlabel.frame = CGRectMake(tableX + 15.0, tableY + tableHeight, MAX(tableWidth - 130.0, 0), 40);
}

- (CGFloat)policyTextWidth
{
    CGFloat width = policytable.bounds.size.width;
    if (width < 1) width = policytable.frame.size.width;
    return MAX(width - 56.0, 0);
}

- (void)layoutPolicyForCurrentSize
{
    if (!generalPolicyView) return;
    CGFloat width = generalPolicyView.bounds.size.width;
    CGFloat height = generalPolicyView.bounds.size.height;
    if (width < 1 || height < 1) return;
    if (scpolicy) scpolicy.frame = CGRectMake(10, 11, MAX(width - 50.0, 0), 29);
    if (policy_editbutton) policy_editbutton.frame = CGRectMake(width - 37.0, 10, 31, 31);
    if (policy_savebutton) policy_savebutton.frame = CGRectMake(width - 138.0, height - 50.0, 100, 35);
    if (policy_cancelbutton) policy_cancelbutton.frame = CGRectMake(width - 248.0, height - 50.0, 100, 35);
    if (policy_addbutton) policy_addbutton.frame = CGRectMake((width - 100.0) / 2.0, (height - 35.0) / 2.0, 100, 35);
    if (scPolicyLanguage) scPolicyLanguage.frame = CGRectMake(30, height - 50.0, 150, 35);
    if (policytable && fabs(width - laidOutPolicyWidth) > 0.5) {
        laidOutPolicyWidth = width;
        dispatch_async(dispatch_get_main_queue(), ^{
            [policytable reloadData];
        });
    }
}

- (void)pinOpenSideWindowToVisibleEdge
{
    if (sideWindowAdjusting || !sidewindowview || sidewindowview.hidden || sidewindowview.frame.size.width < 1.0) return;
    CGRect visible = [self visibleWindowFrame];
    if (visible.size.width < 1.0 || visible.size.height < 1.0) return;
    CGFloat panelWidth = MIN(sidewindowview.frame.size.width, visible.size.width);
    sidewindowview.frame = CGRectMake(CGRectGetMaxX(visible) - panelWidth, visible.origin.y, panelWidth, visible.size.height);
    if (sidewindowviewclosebutton && !sidewindowviewclosebutton.hidden) sidewindowviewclosebutton.frame = visible;
    for (UIView *child in sidewindowview.subviews) {
        if ([child isKindOfClass:[UIActivityIndicatorView class]]) continue;
        child.frame = sidewindowview.bounds;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutCenterInformationForCurrentSize];
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


//-(int) returnvisiblemenucount
//{
//    int result=0;
//    for (int i=0; i<menuVisibleArray.count; i++) {
//        if ([[menuVisibleArray objectAtIndex:i] isEqualToString:@"1"]) {
//            result+=1;
//        }
//    }
//    return result;
//}

//-(long) returnvisiblelastmenuview
//{
//    for (long i=menuVisibleArray.count-1; i>=0; i--) {
//        if ([[menuVisibleArray objectAtIndex:i] isEqualToString:@"1"]) {
//            return i;
//        }
//    }
//    return 0;
//}

-(void) highlightmenubuttonwithbuttontag:(long)buttontag
{
    for (id object in [menuStackView subviews]) {
        if ([object isKindOfClass:[UIButton class]]) {
            if (((UIButton *)object).tag==buttontag) {
                ((UIButton *)object).enabled=NO;
                [((UIButton *)object) setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }else{
                ((UIButton *)object).enabled=YES;
                [((UIButton *)object) setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
    }
    
//    [UIView animateWithDuration:0.3f animations:^{
//        if (buttontag==[self returnvisiblelastmenuview]) {
//            [menubottombar setFrame:CGRectMake([self returnbuttonpositionwithtag:buttontag]*menuView.frame.size.width/[self returnvisiblemenucount], menuView.frame.size.height-2, menuView.frame.size.width-(menuView.frame.size.width/[self returnvisiblemenucount])*([self returnvisiblemenucount]-1), 2)];
//        }else{
//            [menubottombar setFrame:CGRectMake([self returnbuttonpositionwithtag:buttontag]*menuView.frame.size.width/[self returnvisiblemenucount], menuView.frame.size.height-2, menuView.frame.size.width/[self returnvisiblemenucount], 2)];
//        }
//
//    } completion:nil];
}


-(void) refreshmenutitle
{
    for (id object in [menuStackView subviews]) {
        if ([object isKindOfClass:[UIButton class]]) {
            [(UIButton *)object setTitle:[MyClass returntitlewithtitle:[menuArray objectAtIndex:((UIButton *)object).tag]] forState:UIControlStateNormal];
        }
    }
    
    menu_subscription_button.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).viewsetupsubscription;
    
    menu_staff_button.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showcenterstaffpage;
    
    menu_course_button.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showcentercoursepage;
    
    menu_product_button.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showcenterproductpage;
    
    menu_classroom_button.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showcenterclassroompage;
    
    menu_marketing_button.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showcentermarketingpage;
    
    menu_policy_button.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showcenterpolicypage;
        
}


//-(long) returnbuttonpositionwithtag:(long)buttontag
//{
//    long position=buttontag;
//    for (long i=buttontag-1; i>=0; i--) {
//        if ([[menuVisibleArray objectAtIndex:i] isEqualToString:@"0"]) {
//            position-=1;
//        }
//    }
//    return position;
//}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.mainSlideMenu disableSlidePanGestureForRightMenu];
    globalvariables.lastviewcontroller=(NSString *)self;
    
    if (runviewdidappear) {
            if (sidewindowview.hidden || sidewindowview.frame.size.width < 1) {
            lastviewindex=0;
            
            productcategoryselected=@"All";
            subjectcategoryselected=@"All";
            
            
            
            [self reloadPage];
        }
    }else{
        runviewdidappear=TRUE;
    }
}

-(void) donotrunviewdidappear
{
    runviewdidappear=FALSE;
}

-(void) refreshsubjecttable
{
    subjectArray=[MyClass retrievecentersubjectinformationwithstatus:[subjectstatusarray objectAtIndex:scsubjectstatus.selectedSegmentIndex] category:subjectcategoryselected flushcachedata:YES];
    [self returnfiltersubjectarray];
    //[subjecttable reloadData];
    for (id object in [subjecttable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshclassroomtable
{
    [self retrieveClassroomwithflushcachedata:YES];
    for (id object in [classroomtable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshstafftable
{
    [self retrieveStaffListwithflushcachedata:YES];
    for (id object in [stafftable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshproducttable
{
    [self retrieveProductListwithresetcategoryfilter:NO flushcachedata:YES];
    for (id object in [producttable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshmarketingtable
{
    [self retrieveMarketingRecordwithflushcachedata:YES];
    for (id object in [marketingtable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

//-(void) refreshmarketingsourcetable
//{
//    [self retrieveMarketingRecordwithflushcachedata:YES];
//    for (id object in [marketingsourcetable subviews]) {
//        if ([object isKindOfClass:[UIRefreshControl class]]) {
//            [(UIRefreshControl *)object endRefreshing];break;
//        }
//    }
//}
//
//-(void) refreshmarketingpromotiontable
//{
//    [self retrieveMarketingRecordwithflushcachedata:YES];
//    for (id object in [marketingpromotiontable subviews]) {
//        if ([object isKindOfClass:[UIRefreshControl class]]) {
//            [(UIRefreshControl *)object endRefreshing];break;
//        }
//    }
//}
//
//-(void) refreshmarketingmediatable
//{
//    [self retrieveMarketingRecordwithflushcachedata:YES];
//    for (id object in [marketingmediatable subviews]) {
//        if ([object isKindOfClass:[UIRefreshControl class]]) {
//            [(UIRefreshControl *)object endRefreshing];break;
//        }
//    }
//}

-(void) refreshpolicytable
{
    if (!policy_editmode) {
        [self retrievepolicy];
    }
    
    for (id object in [policytable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
    
}

-(void) refreshdevicetable
{
    [self retrievedevicelistwithappname:((LicenseRecord *)[licenseArray objectAtIndex:licensetableindexpath.row]).appname];
    for (id object in [devicetable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

/*
-(void) refreshselectiontable
{
    [self retrieveothercenters];
    for (id object in [selectiontable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}*/

-(void) loadcenterinformation
{
    
    
    long waterlevel;
    
    centernamelabel.text=globalvariables.centerrecord.centername;
    schoolregnumberLabel.text=[globalvariables.centerrecord.schoolregnumber isEqualToString:@""]?[MyClass returntitlewithtitle:@"None"]:globalvariables.centerrecord.schoolregnumber;
    schoolregnumberTitle.text=[MyClass returntitlewithtitle:@"School Registration No."];
    [centeremailbutton setTitle:globalvariables.centerrecord.centeremail forState:UIControlStateNormal];
    [centerwebsitebutton setTitle:globalvariables.centerrecord.centerwebsite forState:UIControlStateNormal];
    [centerothersbutton setTitle:globalvariables.centerrecord.centerothers forState:UIControlStateNormal];
    centershortnamelabel.text=[globalvariables.language isEqualToString:@"English"]?globalvariables.centerrecord.centershortname_english:globalvariables.centerrecord.centershortname_chinese;
    centeraddresslabel.text=[globalvariables.language isEqualToString:@"English"]?globalvariables.centerrecord.centeraddress:globalvariables.centerrecord.centeraddress_chinese;
    centeraddresslabel.frame=CGRectMake(30, 20, 477, 1000);
    [centeraddresslabel sizeToFit];
    CGRect myFrame=centeraddresslabel.frame;
    if (myFrame.size.height>70) {
        myFrame=CGRectMake(30, 20, 477, 70);
    }else{
        myFrame=CGRectMake(30, 20, 477, myFrame.size.height);
    }
    
    centeraddresslabel.frame=myFrame;
    
    waterlevel=centeraddresslabel.frame.origin.y+centeraddresslabel.frame.size.height+10;
    
    centercontactlabel.text=globalvariables.centerrecord.centercontact;
    if (![globalvariables.centerrecord.centercontact isEqualToString:@""]) {
        centercontactlabel.frame=CGRectMake(65, waterlevel, 442, 25);
        centercontacticonimage.frame=CGRectMake(30, waterlevel, 25, 25);
        waterlevel+=centercontactlabel.frame.size.height+5;
        centercontacticonimage.hidden=NO;
        centercontactlabel.hidden=NO;
    }else{
        centercontacticonimage.hidden=YES;
        centercontactlabel.hidden=YES;
    }
    
    centerfaxlabel.text=globalvariables.centerrecord.centerfax;
    if (![globalvariables.centerrecord.centerfax isEqualToString:@""]) {
        centerfaxlabel.frame=CGRectMake(65, waterlevel, 442, 25);
        centerfaxiconimage.frame=CGRectMake(30, waterlevel, 25, 25);
        waterlevel+=centerfaxlabel.frame.size.height+5;
        centerfaxiconimage.hidden=NO;
        centerfaxlabel.hidden=NO;
    }else{
        centerfaxiconimage.hidden=YES;
        centerfaxlabel.hidden=YES;
    }
    
    centerwhatsapplabel.text=globalvariables.centerrecord.centerwhatsapp;
    if (![globalvariables.centerrecord.centerwhatsapp isEqualToString:@""]) {
        centerwhatsapplabel.frame=CGRectMake(65, waterlevel, 442, 25);
        centerwhatsappiconimage.frame=CGRectMake(30, waterlevel, 25, 25);
        waterlevel+=centerwhatsapplabel.frame.size.height+5;
        centerwhatsappiconimage.hidden=NO;
        centerwhatsapplabel.hidden=NO;
    }else{
        centerwhatsappiconimage.hidden=YES;
        centerwhatsapplabel.hidden=YES;
    }
    
    if (![globalvariables.centerrecord.maplat isEqualToString:@""] && ![globalvariables.centerrecord.maplong isEqualToString:@""]) {
        centerlatlonglabel.frame=CGRectMake(65, waterlevel, 442, 25);
        centerlatlongiconimage.frame=CGRectMake(30, waterlevel, 25, 25);
        waterlevel+=centerlatlonglabel.frame.size.height+5;
        centerlatlongiconimage.hidden=NO;
        centerlatlonglabel.hidden=NO;
        centerlatlonglabel.text=[NSString stringWithFormat:@"%@,%@",globalvariables.centerrecord.maplat,globalvariables.centerrecord.maplong];
    }else{
        centerlatlongiconimage.hidden=YES;
        centerlatlonglabel.hidden=YES;
    }
    
    if ([globalvariables.language isEqualToString:@"English"]) {
        centerhour_line1leftLabel.text=globalvariables.centerrecord.centerhour_line1left;
        centerhour_line1rightLabel.text=globalvariables.centerrecord.centerhour_line1right;
        centerhour_line2leftLabel.text=globalvariables.centerrecord.centerhour_line2left;
        centerhour_line2rightLabel.text=globalvariables.centerrecord.centerhour_line2right;
        centerhour_line3leftLabel.text=globalvariables.centerrecord.centerhour_line3left;
        centerhour_line3rightLabel.text=globalvariables.centerrecord.centerhour_line3right;
        centerhour_line4leftLabel.text=globalvariables.centerrecord.centerhour_line4left;
        centerhour_line4rightLabel.text=globalvariables.centerrecord.centerhour_line4right;
        centerhour_line5leftLabel.text=globalvariables.centerrecord.centerhour_line5left;
        centerhour_line5rightLabel.text=globalvariables.centerrecord.centerhour_line5right;
    }else{
        centerhour_line1leftLabel.text=globalvariables.centerrecord.centerhour_line1left_chinese;
        centerhour_line1rightLabel.text=globalvariables.centerrecord.centerhour_line1right_chinese;
        centerhour_line2leftLabel.text=globalvariables.centerrecord.centerhour_line2left_chinese;
        centerhour_line2rightLabel.text=globalvariables.centerrecord.centerhour_line2right_chinese;
        centerhour_line3leftLabel.text=globalvariables.centerrecord.centerhour_line3left_chinese;
        centerhour_line3rightLabel.text=globalvariables.centerrecord.centerhour_line3right_chinese;
        centerhour_line4leftLabel.text=globalvariables.centerrecord.centerhour_line4left_chinese;
        centerhour_line4rightLabel.text=globalvariables.centerrecord.centerhour_line4right_chinese;
        centerhour_line5leftLabel.text=globalvariables.centerrecord.centerhour_line5left_chinese;
        centerhour_line5rightLabel.text=globalvariables.centerrecord.centerhour_line5right_chinese;
    }
    
    title_Center_hours_except_center_holiday.frame=CGRectMake(30, waterlevel+15, 344, 30);
    centerhour_line1leftLabel.frame=CGRectMake(30, title_Center_hours_except_center_holiday.frame.origin.y+title_Center_hours_except_center_holiday.frame.size.height, 120, 30);
    centerhour_line2leftLabel.frame=CGRectMake(30, centerhour_line1leftLabel.frame.origin.y+centerhour_line1leftLabel.frame.size.height, 120, 30);
    centerhour_line3leftLabel.frame=CGRectMake(30, centerhour_line2leftLabel.frame.origin.y+centerhour_line2leftLabel.frame.size.height, 120, 30);
    centerhour_line4leftLabel.frame=CGRectMake(30, centerhour_line3leftLabel.frame.origin.y+centerhour_line3leftLabel.frame.size.height, 120, 30);
    centerhour_line5leftLabel.frame=CGRectMake(30, centerhour_line4leftLabel.frame.origin.y+centerhour_line4leftLabel.frame.size.height, 120, 30);
    centerhour_line1rightLabel.frame=CGRectMake(170, title_Center_hours_except_center_holiday.frame.origin.y+title_Center_hours_except_center_holiday.frame.size.height, 337, 33);
    centerhour_line2rightLabel.frame=CGRectMake(170, centerhour_line1rightLabel.frame.origin.y+centerhour_line1rightLabel.frame.size.height, 337, 30);
    centerhour_line3rightLabel.frame=CGRectMake(170, centerhour_line2rightLabel.frame.origin.y+centerhour_line2rightLabel.frame.size.height, 337, 30);
    centerhour_line4rightLabel.frame=CGRectMake(170, centerhour_line3rightLabel.frame.origin.y+centerhour_line3rightLabel.frame.size.height, 337, 30);
    centerhour_line5rightLabel.frame=CGRectMake(170, centerhour_line4rightLabel.frame.origin.y+centerhour_line4rightLabel.frame.size.height, 337, 30);
}


/*
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

- (IBAction)menubutton:(id)sender {
    [self.mainSlideMenu openLeftMenu];
}

- (IBAction)nextcalendaryear:(id)sender {
    displayyear+=1;
    yeartitle.text=[globalvariables.language isEqualToString:@"English"]?[NSString stringWithFormat:@"Year %ld",displayyear]:[NSString stringWithFormat:@"%ld年",displayyear];
    [self refreshcalendarwithflushcachedata:YES];
    //[self drawCalendar];
    
}

- (IBAction)previouscalendaryear:(id)sender {
    displayyear-=1;
    yeartitle.text=[globalvariables.language isEqualToString:@"English"]?[NSString stringWithFormat:@"Year %ld",displayyear]:[NSString stringWithFormat:@"%ld年",displayyear];
    [self refreshcalendarwithflushcachedata:YES];
    //[self drawCalendar];
    
}

-(void) gotoSubmenu:(NSInteger)submenu submenukey:(NSString *)submenukey
{
    UIButton *button=[[UIButton alloc]init];
    button.tag=submenu;
    [self selectinformation:button];
    selectedsubmenukey=submenukey;
    selectedsubmenu=submenu;
}

-(void) gotoSubmenuKey
{
    long gotorow=-1;
    if(selectedsubmenu ==2){
        //subject
        for (int i=0; i<filteredSubjectArray.count; i++) {
            if([((SubjectRecord *)[filteredSubjectArray objectAtIndex:i]).subject_shortname isEqualToString:selectedsubmenukey]){
                gotorow=i;
            }
        }
        
        if(gotorow>=0){
            [subjecttable selectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:subjecttable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0]];
        }
    }else if(selectedsubmenu==3){
        //classroom
        for (int i=0; i<filteredClassroomArray.count; i++) {
            if([((ClassroomRecord *)[filteredClassroomArray objectAtIndex:i]).classroom isEqualToString:selectedsubmenukey]){
                gotorow=i;
            }
        }
        
        if(gotorow>=0){
            [classroomtable selectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:classroomtable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0]];
        }
    }else if(selectedsubmenu==4){
        //staff
        for (int i=0; i<filteredStaffArray.count; i++) {
            if([((Staff *)[filteredStaffArray objectAtIndex:i]).username isEqualToString:selectedsubmenukey]){
                gotorow=i;
            }
        }
        
        if(gotorow>=0){
            [stafftable selectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:stafftable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0]];
        }
    }else if(selectedsubmenu==5){
        //product
        for (int i=0; i<filteredProductArray.count; i++) {
            if([((ProductRecord *)[filteredProductArray objectAtIndex:i]).code isEqualToString:selectedsubmenukey]){
                gotorow=i;
            }
        }
        
        if(gotorow>=0){
            [producttable selectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            [self tableView:producttable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:gotorow inSection:0]];
        }
    }
    selectedsubmenu=-1;
}

- (IBAction)selectinformation:(UIButton *)sender {
    
    long oldlastviewindex=lastviewindex;
    lastviewindex=sender.tag;
    [self loadingindicatorwithoption:@"start"];
    [self.view endEditing:YES];
    [self highlightmenubuttonwithbuttontag:sender.tag];
    if (sender.tag==1) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            calendarview.hidden=NO;
            subjectview.hidden=YES;
            staffview.hidden=YES;
            policyview.hidden=YES;
            contactview.hidden=YES;
            centerinfo_editbutton.hidden=YES;
            centerinfo_savebutton.hidden=YES;
            centerinfo_cancelbutton.hidden=YES;
            
            subscriptionview.hidden=YES;
            //othercenterview.hidden=YES;
            productview.hidden=YES;
            marketingview.hidden=YES;
            classroomview.hidden=YES;
            [self refreshcalendarwithflushcachedata:YES];
            lastviewindex=sender.tag;
            [self loadingindicatorwithoption:@"stop"];
        });

    }else if (sender.tag==2) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            subjectArray=[MyClass retrievecentersubjectinformationwithstatus:[subjectstatusarray objectAtIndex:scsubjectstatus.selectedSegmentIndex] category:subjectcategoryselected flushcachedata:YES];
            subjectcategoryarray=[MyClass retrievesubjectcategorywithflushcachedata:NO];
            [subjectcategoryarray insertObject:[[SubjectCategoryRecord alloc]initSubjectCategoryRecordwithCenterkey:nil SCategoryKey:@"All" Englishname:@"All Categories" Chinesename:@"All Categories" colorcode:0 bundleforapppayment:NO] atIndex:0];
            lastviewindex=sender.tag;
            [self returnfiltersubjectarray];
            if (subjectArray) {
                //[subjecttable reloadData];
                //lastviewindex=sender.tag;
                calendarview.hidden=YES;
                subjectview.hidden=NO;
                staffview.hidden=YES;
                policyview.hidden=YES;
                contactview.hidden=YES;
                centerinfo_editbutton.hidden=YES;
                centerinfo_savebutton.hidden=YES;
                centerinfo_cancelbutton.hidden=YES;
                subscriptionview.hidden=YES;
                //othercenterview.hidden=YES;
                productview.hidden=YES;
                marketingview.hidden=YES;
                classroomview.hidden=YES;
                [editcalendarbutton setTitle:[MyClass returntitlewithtitle:@"Edit Calendar"] forState:UIControlStateNormal];
            }else{
                lastviewindex=oldlastviewindex;
                [self highlightmenubuttonwithbuttontag:lastviewindex];
                //scinformation.selectedSegmentIndex=lastviewindex;
                return;
            }
            [self gotoSubmenuKey];
            [self loadingindicatorwithoption:@"stop"];
        });

    }else if (sender.tag==4) {
        lastviewindex=sender.tag;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            if (![self retrieveGroup] || ![self retrievePrivilege]) {
                lastviewindex=oldlastviewindex;
                [self highlightmenubuttonwithbuttontag:lastviewindex];
                //scinformation.selectedSegmentIndex=lastviewindex;
                
                return;
            }
            
            if([self retrieveStaffListwithflushcachedata:YES]){
                calendarview.hidden=YES;
                subjectview.hidden=YES;
                staffview.hidden=NO;
                policyview.hidden=YES;
                contactview.hidden=YES;
                centerinfo_editbutton.hidden=YES;
                centerinfo_savebutton.hidden=YES;
                centerinfo_cancelbutton.hidden=YES;
                subscriptionview.hidden=YES;
                //othercenterview.hidden=YES;
                productview.hidden=YES;
                marketingview.hidden=YES;
                classroomview.hidden=YES;
                //lastviewindex=sender.tag;
                [editcalendarbutton setTitle:[MyClass returntitlewithtitle:@"Edit Calendar"] forState:UIControlStateNormal];
            }else{
                lastviewindex=oldlastviewindex;
                [self highlightmenubuttonwithbuttontag:lastviewindex];
                //scinformation.selectedSegmentIndex=lastviewindex;
            }
            [self gotoSubmenuKey];
            [self loadingindicatorwithoption:@"stop"];
        });
        
    }else if (sender.tag==5) {
        lastviewindex=sender.tag;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([self retrieveProductListwithresetcategoryfilter:YES flushcachedata:YES]){
                calendarview.hidden=YES;
                subjectview.hidden=YES;
                staffview.hidden=YES;
                policyview.hidden=YES;
                contactview.hidden=YES;
                centerinfo_editbutton.hidden=YES;
                centerinfo_savebutton.hidden=YES;
                centerinfo_cancelbutton.hidden=YES;
                subscriptionview.hidden=YES;
                //othercenterview.hidden=YES;
                productview.hidden=NO;
                marketingview.hidden=YES;
                classroomview.hidden=YES;
                //lastviewindex=sender.tag;
                [editcalendarbutton setTitle:[MyClass returntitlewithtitle:@"Edit Calendar"] forState:UIControlStateNormal];
                [self getyetgivenproduct];
            }else{
                lastviewindex=oldlastviewindex;
                [self highlightmenubuttonwithbuttontag:lastviewindex];
                //scinformation.selectedSegmentIndex=lastviewindex;
            }
            [self gotoSubmenuKey];
            [self loadingindicatorwithoption:@"stop"];
        });
        
    }else if (sender.tag==6) {
        lastviewindex=sender.tag;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([self retrieveMarketingRecordwithflushcachedata:YES]){
                calendarview.hidden=YES;
                subjectview.hidden=YES;
                staffview.hidden=YES;
                policyview.hidden=YES;
                contactview.hidden=YES;
                centerinfo_editbutton.hidden=YES;
                centerinfo_savebutton.hidden=YES;
                centerinfo_cancelbutton.hidden=YES;
                subscriptionview.hidden=YES;
                //othercenterview.hidden=YES;
                productview.hidden=YES;
                marketingview.hidden=NO;
                classroomview.hidden=YES;
                //lastviewindex=sender.tag;
                [editcalendarbutton setTitle:[MyClass returntitlewithtitle:@"Edit Calendar"] forState:UIControlStateNormal];
            }else{
                lastviewindex=oldlastviewindex;
                [self highlightmenubuttonwithbuttontag:lastviewindex];
                //scinformation.selectedSegmentIndex=lastviewindex;
            }
            [self loadingindicatorwithoption:@"stop"];
        });
        
    }else if (sender.tag==3) {
        lastviewindex=sender.tag;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if([self retrieveClassroomwithflushcachedata:YES]){
                calendarview.hidden=YES;
                subjectview.hidden=YES;
                staffview.hidden=YES;
                policyview.hidden=YES;
                contactview.hidden=YES;
                centerinfo_editbutton.hidden=YES;
                centerinfo_savebutton.hidden=YES;
                centerinfo_cancelbutton.hidden=YES;
                subscriptionview.hidden=YES;
                //othercenterview.hidden=YES;
                productview.hidden=YES;
                marketingview.hidden=YES;
                classroomview.hidden=NO;
                //lastviewindex=sender.tag;
                [editcalendarbutton setTitle:[MyClass returntitlewithtitle:@"Edit Calendar"] forState:UIControlStateNormal];
            }else{
                lastviewindex=oldlastviewindex;
                [self highlightmenubuttonwithbuttontag:lastviewindex];
                //scinformation.selectedSegmentIndex=lastviewindex;
            }
            [self gotoSubmenuKey];
            [self loadingindicatorwithoption:@"stop"];
        });
        
    }else if (sender.tag==7){
        lastviewindex=sender.tag;
        policy_editmode=FALSE;
        policy_languageselected=[globalvariables.language isEqualToString:@"English"]?@"english":@"chinese";
        [self drawpolicycategorybutton];
        if ([self retrievepolicy]) {
            calendarview.hidden=YES;
            subjectview.hidden=YES;
            staffview.hidden=YES;
            policyview.hidden=NO;
            contactview.hidden=YES;
            centerinfo_editbutton.hidden=YES;
            centerinfo_savebutton.hidden=YES;
            centerinfo_cancelbutton.hidden=YES;
            subscriptionview.hidden=YES;
            //othercenterview.hidden=YES;
            productview.hidden=YES;
            marketingview.hidden=YES;
            classroomview.hidden=YES;
            //lastviewindex=sender.tag;
            [editcalendarbutton setTitle:[MyClass returntitlewithtitle:@"Edit Calendar"] forState:UIControlStateNormal];
        }else{
            lastviewindex=oldlastviewindex;
            [self highlightmenubuttonwithbuttontag:lastviewindex];
            //scinformation.selectedSegmentIndex=lastviewindex;
        }
        [self loadingindicatorwithoption:@"stop"];
        
    }else if (sender.tag==0){
        [self retrievecenterimages];
        [self centerinfo_cancelbuttonpressed];
        //[self loadcenterinformation];
        
        calendarview.hidden=YES;
        subjectview.hidden=YES;
        staffview.hidden=YES;
        policyview.hidden=YES;
        contactview.hidden=NO;
        //centerinfo_editbutton.hidden=NO;
        centerinfo_savebutton.hidden=YES;
        centerinfo_cancelbutton.hidden=YES;
        subscriptionview.hidden=YES;
        //othercenterview.hidden=YES;
        productview.hidden=YES;
        marketingview.hidden=YES;
        classroomview.hidden=YES;
        lastviewindex=sender.tag;
        [editcalendarbutton setTitle:[MyClass returntitlewithtitle:@"Edit Calendar"] forState:UIControlStateNormal];
        [self loadingindicatorwithoption:@"stop"];
    }else if (sender.tag==8){
        lastviewindex=sender.tag;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(![self retrievesubscriptionplan]){
                lastviewindex=oldlastviewindex;
                [self highlightmenubuttonwithbuttontag:lastviewindex];
                //scinformation.selectedSegmentIndex=lastviewindex;
                
                return;
            }
            
            if ([self retrievedevicelistwithappname:((LicenseRecord *)[licenseArray objectAtIndex:licensetableindexpath.row]).appname]){
                calendarview.hidden=YES;
                subjectview.hidden=YES;
                staffview.hidden=YES;
                policyview.hidden=YES;
                contactview.hidden=YES;
                centerinfo_editbutton.hidden=YES;
                centerinfo_savebutton.hidden=YES;
                centerinfo_cancelbutton.hidden=YES;
                subscriptionview.hidden=NO;
                //othercenterview.hidden=YES;
                productview.hidden=YES;
                marketingview.hidden=YES;
                classroomview.hidden=YES;
                //lastviewindex=sender.tag;
                [editcalendarbutton setTitle:[MyClass returntitlewithtitle:@"Edit Calendar"] forState:UIControlStateNormal];
            }else{
                lastviewindex=oldlastviewindex;
                [self highlightmenubuttonwithbuttontag:lastviewindex];
                //scinformation.selectedSegmentIndex=lastviewindex;
            }
            [self loadingindicatorwithoption:@"stop"];
        });
        
    }
    

}

- (IBAction)clicktoweb:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sender.titleLabel.text]options:@{} completionHandler:nil];
}

- (IBAction)clicktoother:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:sender.titleLabel.text]options:@{} completionHandler:nil];
}

-(void) disableuserappwithstudentkey:(NSString *)studentkey username:(NSString *)username appname:(NSString *)appname
{
    if ([MyClass disableuserappwithstudentkey:studentkey username:username appname:appname]) {
        [self retrievesubscriptionplan];
        [self retrievedevicelistwithappname:((LicenseRecord *)[licenseArray objectAtIndex:licensetableindexpath.row]).appname];
        //devicetable.editing=FALSE;
    }
}


/*
-(BOOL) logoutdevicewithindexpath:(NSIndexPath *)indexpath
{
    return [MyClass removeUserTokenDeviceWithUserDeviceKey:((DeviceRecord *)[deviceArray objectAtIndex:indexpath.row]).userdevicekey];
}*/

- (IBAction)clicktoemail:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@",sender.titleLabel.text]]options:@{} completionHandler:nil];
}




-(void) retrieveCalendar
{

    
    //enable or disable previous and next button
    if (displayyear>2006) {
        previousyearbutton.enabled=YES;
        [previousyearbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else{
        previousyearbutton.enabled=NO;
        [previousyearbutton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    }

    
    [self drawCalendar];
}

-(void) drawCalendar
{
    
    for (id object in [calendarview subviews]) {
        if ([object isKindOfClass:[UIButton class]]) {
            UIButton *button=object;
            if (button.tag !=888) {
                [object removeFromSuperview];
            }
        }
        
        if ([object isKindOfClass:[UILabel class]]) {
            UILabel *label=object;
            if (label.tag ==8888) {
                [object removeFromSuperview];
            }
        }
    }
    
    for (long y=0; y<3; y++) {
        for (long x=0; x<4; x++) {
            
            
            NSString *monthyear=[NSString stringWithFormat:@"%@ %ld",[monthnameArray objectAtIndex:x+y*4],displayyear];
            [df setDateFormat:@"MMMM yyyy"];
            NSDate *date = [df dateFromString:monthyear];
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            
            //NSRange weekRange = [calendar rangeOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitMonth forDate:date];
            //NSInteger weeksCount = weekRange.length;
            
            NSRange dayRange = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
            NSInteger daysCount = dayRange.length;
            
            //find starting day
            
            NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekday fromDate:date];
            long weekdayToday = [components weekday]-2;
            
            NSMutableArray *currentmonthday=[[NSMutableArray alloc]init];
            
            for (int i=0; i<42; i++) {
                if (i>weekdayToday && i<=daysCount+weekdayToday) {
                    [currentmonthday addObject:[NSString stringWithFormat:@"%ld",i-weekdayToday]];
                }else{
                    [currentmonthday addObject:@""];
                }
            }
            
            
            for (long i=0; i<8; i++) {
                if (i==0) {
                    UILabel *monthlabel=[[UILabel alloc]initWithFrame:CGRectMake(leftmargin+x*(horizontalseparation+cellwidth*7), topmargin+y*(verticalseparation+cellheight*7+headerheight), cellwidth*7, headerheight)];
                    monthlabel.backgroundColor=[UIColor darkGrayColor];
                    monthlabel.layer.borderColor=[UIColor darkGrayColor].CGColor;
                    monthlabel.layer.borderWidth=.5;
                    monthlabel.textColor=[UIColor whiteColor];
                    monthlabel.textAlignment=NSTextAlignmentCenter;
                    monthlabel.font=[UIFont boldSystemFontOfSize:14];
                    monthlabel.text=[MyClass returndateformatMMMMwithdate:[monthnameArray objectAtIndex:x+y*4]];
                    monthlabel.tag=8888;
                    [calendarview addSubview:monthlabel];
                }else if (i==1){
                    for (long j=0; j<7; j++) {
                        UILabel *dayofweeklabel=[[UILabel alloc]initWithFrame:CGRectMake(leftmargin+j*cellwidth+x*(horizontalseparation+cellwidth*7), topmargin+headerheight+y*(verticalseparation+cellheight*7+headerheight), cellwidth, cellheight)];
                        dayofweeklabel.backgroundColor=[UIColor lightTextColor];
                        dayofweeklabel.layer.borderColor=[UIColor darkGrayColor].CGColor;
                        dayofweeklabel.layer.borderWidth=.5;
                        dayofweeklabel.textAlignment=NSTextAlignmentCenter;
                        dayofweeklabel.font=[UIFont systemFontOfSize:12];
                        dayofweeklabel.text=[MyClass returndateformatEEEwithdate:[dayofweekArray objectAtIndex:j]];
                        dayofweeklabel.tag=8888;
                        [calendarview addSubview:dayofweeklabel];
                    }
                }else{
                    for (long j=0; j<7; j++) {
                        
                        NSString *day;
                        [df setDateFormat:@"MM"];
                        day=[currentmonthday objectAtIndex:(i-2)*7+j];
                        
                        
                        daybutton=[[UIButton alloc]initWithFrame:CGRectMake(leftmargin+j*cellwidth+x*(horizontalseparation+cellwidth*7), topmargin+(i-1)*cellheight+headerheight+y*(verticalseparation+cellheight*7+headerheight), cellwidth, cellheight)];
                        
                        
                        [df setDateFormat:@"yyyyMMdd"];
                        NSString *datestring =[NSString stringWithFormat:@"%02ld%02ld%02d",displayyear,(x+y*4+1),[day intValue]];
                        NSDate *date = [df dateFromString:datestring];
                        [df setDateFormat:@"dd-MMM-yyyy"];
                        
                        if (date && [[df stringFromDate:date] isEqualToString:[df stringFromDate:[NSDate date]]]) {
                            daybutton.backgroundColor=[UIColor grayColor];
                        }else if (j==0) {
                            daybutton.backgroundColor=[UIColor lightTextColor];
                        }else{
                            daybutton.backgroundColor=[UIColor systemGroupedBackgroundColor];
                        }
                        
                        
                        daybutton.layer.borderColor=[UIColor darkGrayColor].CGColor;
                        daybutton.layer.borderWidth=.5;
                        [daybutton setTitle:day forState:UIControlStateNormal];
                        [daybutton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
                        [daybutton.titleLabel setFont:[UIFont systemFontOfSize:12]];
                        
                        NSString *centerday=[globalvariables.centerdaydictionary objectForKey:[NSString stringWithFormat:@"%ld-%02li-%02i#%@",displayyear,(x+y*4+1),[day intValue],globalvariables.centerrecord.centerkey]];
                        
                        
                        if (centerday) {
                            if ([centerday isEqualToString:@"H"]) {
                                [daybutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                                [daybutton addTarget:self action:@selector(daybuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                                daybutton.tag=displayyear*10000+(x+y*4+1)*100+[day intValue];
                            }else{
                                [daybutton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                                [daybutton addTarget:self action:@selector(daybuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                                daybutton.tag=displayyear*10000+(x+y*4+1)*100+[day intValue];
                            }
                        }else{
                            [daybutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                            if (![day isEqualToString:@""]) {
                                [daybutton addTarget:self action:@selector(daybuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                            }
                            daybutton.tag=displayyear*10000+(x+y*4+1)*100+[day intValue];
                        }

                        [calendarview addSubview:daybutton];
                    }
                }
            }
        }
    }
}

-(void) daybuttonpressed:(UIButton *)sender
{
    daybuttonselected=sender;
    [df setDateFormat:@"yyyyMMdd"];
    NSDate *date= [df dateFromString:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
    [df setDateFormat:@"dd-MMM-yyyy"];
    
    selectedcalendardate=[df stringFromDate:date];
    
    if ([editcalendarbutton.titleLabel.text isEqualToString:[MyClass returntitlewithtitle:@"Edit Calendar"]]) {
        if ([MyClass isWorkingDate:[MyClass convertToNSDateWithDate:selectedcalendardate DateFormat:@"dd-MMM-yyyy"] includereserveddate:YES]) {
            
            globalvariables.classdate=selectedcalendardate;
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
        }
    }else{
        NSString *centerday=[globalvariables.centerdaydictionary objectForKey:[NSString stringWithFormat:@"%@#%@",[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:selectedcalendardate],globalvariables.centerrecord.centerkey]];
        NSMutableArray *itemsarray=[[NSMutableArray alloc]init];
        
        if(globalvariables.centerrecord.reservedcalendardate){
            if([centerday isEqualToString:@"R"]){
                [itemsarray addObject:@"Working Day"];
                [itemsarray addObject:@"Holiday"];
            }else if([centerday isEqualToString:@"H"]){
                [itemsarray addObject:@"Working Day"];
                [itemsarray addObject:@"Reserve"];
            }else{
                [itemsarray addObject:@"Holiday"];
                [itemsarray addObject:@"Reserve"];
            }
        }else{
            if([centerday isEqualToString:@"H"]){
                [itemsarray addObject:@"Working Day"];
            }else{
                [itemsarray addObject:@"Holiday"];
            }
        }
        
        
        [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"CalendarDay" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(140, itemsarray.count*40) View:self Button:sender ItemsArray:itemsarray Title:nil];
        //[df setDateFormat:@"EEE"];

//        [changeworkingdatetable reloadData];
//        UIView *confirmationview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, confirmationwidth, changeworkingdatetable.frame.size.height)];
//        [confirmationview addSubview:changeworkingdatetable];
//
//        UIViewController *confirmationvc=[[UIViewController alloc]init];
//        confirmationvc.preferredContentSize=CGSizeMake(confirmationwidth, changeworkingdatetable.frame.size.height);
//        confirmationvc.view=confirmationview;
//        confirmationvc.modalPresentationStyle=UIModalPresentationPopover;
//        myPopoverController=confirmationvc.popoverPresentationController;
//        myPopoverController.delegate=self;
//        myPopoverController.sourceView=sender;
//
//        if (sender.frame.origin.x<calendarview.frame.size.width-(confirmationwidth+30)) {
//            CGRect rect=CGRectMake(sender.frame.size.width*3/4, sender.frame.size.height/2, 0, 0);
//            myPopoverController.permittedArrowDirections=UIPopoverArrowDirectionLeft;
//            myPopoverController.sourceRect=rect;
//        }else{
//            CGRect rect=CGRectMake(sender.frame.size.width*1/4, sender.frame.size.height/2, 0, 0);
//            myPopoverController.permittedArrowDirections=UIPopoverArrowDirectionRight;
//            myPopoverController.sourceRect=rect;
//        }
//        [self presentViewController:confirmationvc animated:YES completion:nil];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==policytable){
        if (policyallcategory.count>0) {
            policyonecategory=[policyallcategory objectAtIndex:policy_selectedsegment];
            return policyonecategory.count;
        }else{
            return 0;
        }
    }else if (tableView==staff_privilegedetailstable){
        return privilegedetailsarray.count+1;
    }else if (tableView==staff_groupdetailstable){
        return 3;
    }else if (tableView==tncTable){
        return 2;
    }else{
        return 1;
    }

    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    if (tableView==policytable){
        policyonecategory=[policyallcategory objectAtIndex:policy_selectedsegment];
        policyrecordobject=[policyonecategory objectAtIndex:section];
        return [policyrecordobject valueForKey:[NSString stringWithFormat:@"heading%@",policy_languageselected]];
    }else if (tableView==sortingtable){
        return [MyClass returntitlewithtitle:@"Sorting Order"];
    }else if (tableView==staff_privilegedetailstable){
        if (section==0) {
            return nil;
        }else{
            return [MyClass returntitlewithtitle:[((NSArray *)[privilegedetailsarray objectAtIndex:section-1]) objectAtIndex:0]];
        }
    }else if (tableView==staff_privilegenametable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Privilege"];
        }
    }else if (tableView==staff_groupnametable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Staff Group"];
        }
    }else if (tableView==staff_groupdetailstable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Group Name"];
        }else if (section==1) {
            return [MyClass returntitlewithtitle:@"Description"];
        }else if (section==2) {
            return [MyClass returntitlewithtitle:@"Group Notification Event"];
        }
    }else if (tableView==ri_subjecttable){
        return [NSString stringWithFormat:@"%@: %d",[MyClass returntitlewithtitle:@"Corresponding Subject"],ri_totalcount];
    }else if (tableView==tncTable){
        if (section==0){
            return [MyClass returntitlewithtitle:@"Receipt T&C"];
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"Invoice T&C"];
        }
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    /*if (tableView==staff_privilegedetailstable) {
        if (section==privilegedetailsarray.count-1) {
            return [MyClass returntitlewithtitle:@"Notification will be sent to alert instructor for upcoming class"];
        }
    }*/
    return nil;
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==stafftable) {
        return CGFLOAT_MIN;
    }else if (tableView==subjecttable){
        return CGFLOAT_MIN;
    }else if (tableView==producttable){
        return CGFLOAT_MIN;
    }else if (tableView==subscriptiontable){
        return CGFLOAT_MIN;
    }else if (tableView==devicetable){
        return CGFLOAT_MIN;
    }/*else if (tableView==changeworkingdatetable){
        return CGFLOAT_MIN;
    }*/else if (tableView==classroomtable){
        return CGFLOAT_MIN;
    }else if (tableView==marketingtable){
        return CGFLOAT_MIN;
    }else if (tableView==staff_groupnametable){
        return CGFLOAT_MIN;
    }else if (tableView==ri_instructortable){
        return CGFLOAT_MIN;
    }else if (tableView==ri_calendartable){
        return CGFLOAT_MIN;
    }else if (tableView==leaveNatureListTable){
        return CGFLOAT_MIN;
    }else if (tableView==sortingtable){
        return 50;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (tableView==staff_membertable || tableView==staff_membergrouptable) {
        return 0.3f;
    }
    return CGFLOAT_MIN;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView==staff_membertable || tableView==staff_membergrouptable) {
        UIView* view = [UIView new];
        [view setBackgroundColor:[UIColor lightGrayColor]];
        return view;
    }
    return nil;

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==policytable){
        return 1;
    }else if (tableView==subjecttable){
        return filteredSubjectArray.count;
    }else if (tableView==stafftable){
        return filteredStaffArray.count;
    }else if (tableView==producttable){
        return filteredProductArray.count;
    }else if (tableView==subscriptiontable){
        return licenseArray.count;
    }else if (tableView==devicetable){
        return deviceArray.count;
    }else if (tableView==marketingtable){
        if(scmarketingcategory.selectedSegmentIndex==0){
            return filteredmarketingmediaArray.count;
        }else if(scmarketingcategory.selectedSegmentIndex==1){
            return filteredmarketingsourceArray.count;
        }else if(scmarketingcategory.selectedSegmentIndex==2){
            return filteredmarketingpromotionArray.count;
        }else{
            return filteredmarketingcouponArray.count;
        }
    }else if (tableView==classroomtable){
        return filteredClassroomArray.count;
    }else if (tableView==sortingtable){
        return sortingarray.count;
    }else if (tableView==staff_privilegenametable){
        return localprivilegearray.count;
    }else if (tableView==staff_groupnametable){
        return GroupArray.count;
    }else if (tableView==staff_groupdetailstable){
        if (section==0 || section==1) {
            return 1;
        }else{
            return groupalertarray.count;
        }
    }else if (tableView==staff_privilegedetailstable){
        if (section==0) {
            return 1;
        }else{
            return ((NSArray *)[((NSArray *)[privilegedetailsarray objectAtIndex:section-1]) objectAtIndex:1]).count;
        }
    }else if (tableView==staff_membertable){
        return filteredStaffArray.count;//allStaffArray.count;
    }else if (tableView==staff_membergrouptable){
        return filteredStaffArray.count;//allStaffArray.count;
    }else if (tableView==ri_subjecttable){
        return ri_subjectarray.count;
    }else if (tableView==ri_instructortable){
        return ri_filteredinstructorarray.count;
    }else if (tableView==ri_calendartable){
        if(selectedperiodbutton==dayoptionbutton){
            return dayOptionArray.count;
        }else{
            return 1;
        }
    }else if (tableView==tncTable){
        return 1;
    }else if (tableView==leaveNatureListTable){
        return leaveNatureArray.count;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==policytable) {
        if (!policy_editmode) {
            policyonecategory=[policyallcategory objectAtIndex:policy_selectedsegment];
            policyrecordobject=[policyonecategory objectAtIndex:indexPath.section];
            
            CGFloat textWidth = [self policyTextWidth];
            UILabel *content=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, textWidth, 20)];
            content.font=[UIFont systemFontOfSize:16];
            content.textColor=[UIColor whiteColor];
            content.adjustsFontSizeToFitWidth=NO;
            content.lineBreakMode=NSLineBreakByWordWrapping;
            content.preferredMaxLayoutWidth=textWidth;
            content.text=[policyrecordobject valueForKey:[NSString stringWithFormat:@"content%@",policy_languageselected]];
            content.numberOfLines=0;
            
            [content sizeToFit];
            CGRect myFrame=content.frame;
            return myFrame.size.height+20;
        }else{
            return 220;
        }

    }else if (tableView == stafftable){
        return UITableViewAutomaticDimension;
    }else if (tableView==subjecttable){
        return UITableViewAutomaticDimension;
    }else if (tableView==producttable){
        return UITableViewAutomaticDimension;
    }else if (tableView==classroomtable){
        return UITableViewAutomaticDimension;
    }else if (tableView==marketingtable){
        return UITableViewAutomaticDimension;
    }else if (tableView==ri_calendartable){
        if(selectedperiodbutton==dayoptionbutton){
            return 38;
        }else{
            return 620;
        }
    }else if (tableView==staff_groupdetailstable){
        if (indexPath.section==1) {
            return 70;
        }
    }else if (tableView==tncTable){
        return 500;
    }
    return 38;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==policytable) {
        policyonecategory=[policyallcategory objectAtIndex:policy_selectedsegment];
        policyrecordobject=[policyonecategory objectAtIndex:indexPath.section];
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (!policy_editmode) {
            CGFloat textWidth = [self policyTextWidth];
            UILabel *policycontent=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, textWidth, 20)];
            policycontent.font=[UIFont systemFontOfSize:16];
            policycontent.textColor=[UIColor darkTextColor];
            policycontent.adjustsFontSizeToFitWidth=NO;
            policycontent.lineBreakMode=NSLineBreakByWordWrapping;
            policycontent.preferredMaxLayoutWidth=textWidth;
            policycontent.numberOfLines=0;
            cell.backgroundColor=[UIColor clearColor];
            [cell.contentView addSubview:policycontent];
            
            //configure the cell
            policycontent.text=[policyrecordobject valueForKey:[NSString stringWithFormat:@"content%@",policy_languageselected]];
            [policycontent sizeToFit];
            CGRect myFrame=policycontent.frame;
            myFrame.size.width=textWidth;
            policycontent.frame=myFrame;
        }else{
            policycontenttext = [[UITextView alloc]initWithFrame:CGRectMake(15, 10, [self policyTextWidth], 200)];
            policycontenttext.font=[UIFont systemFontOfSize:16];
            policycontenttext.textColor=[UIColor darkGrayColor];
            policycontenttext.layer.cornerRadius=3;
            policycontenttext.layer.masksToBounds=YES;
            policycontenttext.text=[policyrecordobject valueForKey:[NSString stringWithFormat:@"content%@",policy_languageselected]];
            policycontenttext.delegate=self;
            policycontenttext.tag=indexPath.section;
            [cell.contentView addSubview:policycontenttext];
        }
        

        cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }else if(tableView==stafftable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"staffcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        StaffObject = [filteredStaffArray objectAtIndex:indexPath.row];
        
        
        // Configure the cell...
        cell.label1.text=[NSString stringWithFormat:@"%@ %@",StaffObject.firstname,StaffObject.lastname];

        cell.label7.text=[MyClass returntitlewithtitle:[StaffObject.role isEqualToString:@"Instructor"]?[MyClass returntitlewithtitle:@"Teaching"]:[MyClass returntitlewithtitle:@"Non-Teaching"]];
        cell.label6.text=[StaffObject.status isEqualToString:@"Yes"] ? [MyClass returntitlewithtitle:@"Active"] : [MyClass returntitlewithtitle:@"Inactive"];
        cell.label3.text=StaffObject.username;
        cell.label5.attributedText=[MyClass returngrouparraylabel:StaffObject.grouparray grouparray:GroupArray option:@"groupmember"];
        cell.label8.text=((PrivilegeRecord *)[MyClass returnprivilegerecordwithprivilegekey:StaffObject.privilege]).usertype;
        [cell.imageview2 setImage:[UIImage imageNamed:StaffObject.centerapp?@"passed_icon":@"failed_icon"]];
        [cell.imageview1 setImage:[UIImage imageNamed:StaffObject.staffapp?@"passed_icon":@"failed_icon"]];
        [cell.imageview3 setImage:[UIImage imageNamed:StaffObject.biapp?@"passed_icon":@"failed_icon"]];
        
        [cell.imageview4 setImage:[UIImage imageNamed:[StaffObject.role isEqualToString:@"Instructor"] ? StaffObject.staffschedule? @"passed_icon":@"failed_icon" : @"failed_icon"]];
        [cell.imageview5 setImage:[UIImage imageNamed:[globalvariables.centerrecord.iparentleavemode isEqualToString:@"Request"]?(StaffObject.confirmmakeuprequest?@"passed_icon":@"failed_icon"):nil]];
        
        //cell.label4.text=StaffObject.phone;
        
        if ([[MyClass returnLocalNumberWithContact:StaffObject.phone ISOCode:StaffObject.iso_code] isEqualToString:@""]) {
            cell.label4.text=@"";
            [cell.imageview6 setImage:nil];
        }else{
            cell.label4.text=[MyClass returnLocalNumberWithContact:StaffObject.phone ISOCode:StaffObject.iso_code];
            [MyClass downloadImageWithImageview:cell.imageview6 gender:nil type:@"flag" typekey:StaffObject.iso_code image:@"Yes" async:YES];
        }
        
        
        [MyClass downloadImageWithImageview:cell.imageview7 gender:nil type:@"staff" typekey:StaffObject.username image:@"Yes" async:YES];
        
        if (showSalaryrate && [StaffObject.role isEqualToString:@"Instructor"]) {
            cell.label14.hidden=NO;
            if ([StaffObject.salaryrate isEqualToString:@""]) {
                cell.label14.text=[NSString stringWithFormat:@"%@ %@%@",[MyClass returntitlewithtitle:@"Salary Rate"],@"0",@"%"];
            }else{
                cell.label14.text=[NSString stringWithFormat:@"%@ %@%@",[MyClass returntitlewithtitle:@"Salary Rate"],StaffObject.salaryrate,@"%"];
            }
        }else{
            cell.label14.hidden=YES;
        }
        
        cell.label15.text=StaffObject.remarks;
        if([StaffObject.role isEqualToString:@"Instructor"]){
//            cell.view1.hidden=NO;
            cell.view1.backgroundColor=[globalvariables.colorcodearray objectAtIndex:StaffObject.colorcode];
        }else{
//            cell.view1.hidden=YES;
            cell.view1.backgroundColor=[UIColor clearColor];
        }

        //Accessory
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //alternative background color;
        if (indexPath.row % 2==0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        return cell;

    }else if (tableView==subjecttable){
        
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"subjectcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        subjectobject = [filteredSubjectArray objectAtIndex:indexPath.row];
        

        //1st line
        cell.label1.text=subjectobject.subject_shortname;
        cell.label6.text=[subjectobject.studentcapacity isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:[NSString stringWithFormat:@"%@ %@",subjectobject.studentcapacity,[MyClass returntitlewithtitle:@"Students"]];
        if ([subjectobject.enrollmentmode isEqualToString:@"Class"]) {
            if ([subjectobject.standardnoofclassormonth intValue]>1) {
                cell.label8.text=[NSString stringWithFormat:@"%@ %@",subjectobject.standardnoofclassormonth,[MyClass returntitlewithtitle:@"Classes"]];
            }else{
                cell.label8.text=[NSString stringWithFormat:@"%@ %@",subjectobject.standardnoofclassormonth,[MyClass returntitlewithtitle:@"#Class"]];
            }
        }else{
            if ([subjectobject.standardnoofclassormonth intValue]>1) {
                cell.label8.text=[NSString stringWithFormat:@"%@ %@",subjectobject.standardnoofclassormonth,[MyClass returntitlewithtitle:@"Months"]];
            }else{
                cell.label8.text=[NSString stringWithFormat:@"%@ %@",subjectobject.standardnoofclassormonth,[MyClass returntitlewithtitle:@"Month"]];
            }
        }

        cell.label3.text=[globalvariables.language isEqualToString:@"English"]?subjectobject.subject_englishname:subjectobject.subject_chinesename;


        cell.label12.text=[self returnlevelstring:subjectobject.levelArray];
        cell.label15.text=subjectobject.remarks;
        
        cell.label2.text=[MyClass returntitlewithtitle:subjectobject.status];
        cell.label4.text=[globalvariables.language isEqualToString:@"English"]?subjectobject.subject_chinesename:subjectobject.subject_englishname;
        
        cell.label7.text=[NSString stringWithFormat:@"%@/%@/%@ %@",subjectobject.classduration,subjectobject.classduration_assessment,subjectobject.classduration_trial,[MyClass returntitlewithtitle:@"mins"]];
        cell.label9.text=[MyClass returntitlewithtitle:subjectobject.tuition_method];
        cell.label13.text=[self returntuitionstring:subjectobject.tuitionArray];
        
        cell.label10.text=[MyClass returntitlewithtitle:subjectobject.tuition_mode];
        
        if (globalvariables.centerrecord.enablemakeupquota) {
            cell.label11.text=[MyClass returnQuotaSringWithUnit:subjectobject.makeup_quota_unit Value:subjectobject.makeup_quota_value];
            cell.label14.text=globalvariables.centerrecord.enrollmentvalidity?[MyClass returnvaliditylabelwithvaliditystring:subjectobject.validity]:@"";
        }else{
            cell.label14.text=@"";
            if(globalvariables.centerrecord.enrollmentvalidity){
                cell.label11.text=[MyClass returnvaliditylabelwithvaliditystring:subjectobject.validity];
            }else{
                cell.label11.text=@"";
            }
        }
        
        if ([MyClass returnsubjectschedulearraycount:subjectobject]>1) {
            cell.label5.text=[NSString stringWithFormat:@"%lu %@",[MyClass returnsubjectschedulearraycount:subjectobject],[MyClass returntitlewithtitle:@"Schedules"]];
        }else{
            cell.label5.text=[NSString stringWithFormat:@"%lu %@",[MyClass returnsubjectschedulearraycount:subjectobject],[MyClass returntitlewithtitle:@"Schedule"]];
        }
   
        //cell.label5.text=(globalvariables.centerrecord.enableattendanceextend)?[MyClass returnsubjectcategorynamewithscategorykey:subjectobject.subject_category]:@"";
        
        cell.view1.backgroundColor=[globalvariables.colorcodearray objectAtIndex:subjectobject.colorcode];
        
        
        
        
        //Accessory
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //alternative background color;
        if (indexPath.row % 2==0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        return cell;
        
    }else if (tableView==producttable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"productcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        productobject = [filteredProductArray objectAtIndex:indexPath.row];
        

        
        // Configure the cell...
        [MyClass downloadImageWithImageview:cell.imageview1 gender:nil type:@"product" typekey:productobject.code image:@"Yes" async:YES];
        cell.label3.text=productobject.englishname;
        cell.label4.text=productobject.chinesename;
        cell.label5.text=productobject.category;
        cell.label1.text=productobject.code;
        cell.label2.text=[MyClass returntitlewithtitle:productobject.status];
        cell.label6.text=[NSString stringWithFormat:@"$%@",productobject.price];
        cell.label10.text=productobject.remarks;
        cell.label9.text=[MyClass returnautorenewlabelwithautorenewstring:productobject.autorenew];
        cell.label7.text=[self returnAllStockCounts:productobject.allstockcounts];
        cell.label8.text=productobject.alertthreshold;
        
        NSMutableDictionary *yetgivendict=[yetGivenProductDict valueForKey:productobject.code];
        if (yetgivendict && ![productobject.stockcount isEqualToString:@""]) {
            [cell.button1 setTitle:[yetgivendict valueForKey:@"yetgivencount"] forState:UIControlStateNormal];
            cell.button1.tag=indexPath.row;
            [cell.button1 addTarget:self action:@selector(yetgivenbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.button1.hidden=NO;
        }else{
            cell.button1.hidden=YES;
        }
        
        if([productobject.stockcount integerValue]<[productobject.alertthreshold integerValue]){
            cell.label7.textColor=[UIColor redColor];
        }else{
            cell.label7.textColor=[UIColor darkGrayColor];
        }
        //Accessory
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //alternative background color;
        if (indexPath.row % 2==0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        return cell;
        
    }else if (tableView==subscriptiontable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier = @"appcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.label1.text=((LicenseRecord *)[licenseArray objectAtIndex:indexPath.row]).appname;
        cell.label2.text=((LicenseRecord *)[licenseArray objectAtIndex:indexPath.row]).licensedcount;
        cell.label3.text=((LicenseRecord *)[licenseArray objectAtIndex:indexPath.row]).usedcount;
        

        
        if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).addlicense && [globalvariables.centerrecord.licensetype isEqualToString:@"Annual"]){
            cell.stackview1.hidden=NO;
            
            cell.button1.tag=indexPath.row;
            [cell.button1 addTarget:self action:@selector(addAppLicense:) forControlEvents:UIControlEventTouchUpInside];
            cell.button1.enabled=![((LicenseRecord *)[licenseArray objectAtIndex:indexPath.row]).licensedcount isEqualToString:@"Unlimited"];
            
            cell.button2.tag=indexPath.row;
            [cell.button2 addTarget:self action:@selector(removeAppLicense:) forControlEvents:UIControlEventTouchUpInside];
            cell.button2.enabled=[((LicenseRecord *)[licenseArray objectAtIndex:indexPath.row]).licensedcount integerValue]>0 && [((LicenseRecord *)[licenseArray objectAtIndex:indexPath.row]).licensedcount integerValue]>[((LicenseRecord *)[licenseArray objectAtIndex:indexPath.row]).usedcount integerValue];
            
            
        }else{
            cell.stackview1.hidden=YES;
        }
        
        if([((LicenseRecord *)[licenseArray objectAtIndex:indexPath.row]).appname isEqualToString:@"iParent"]){
            [MyClass downloadImageWithImageview:cell.imageview1 gender:nil type:@"studentappimage" typekey:globalvariables.centerrecord.standaloneparentappid image:@"Yes" async:YES];
        }else{
            [cell.imageview1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-76@2x.png",cell.label1.text]]];
        }
        
        
//        if(indexPath.row==0){
//            cell.label2.text=@"4";
//            cell.label3.text=@"4";
//        }else if (indexPath.row==1){
//            cell.label2.text=@"6";
//            cell.label3.text=@"6";
//        }else if (indexPath.row==2){
//            cell.label2.text=@"350";
//            cell.label3.text=@"290";
//        }else if(indexPath.row==3){
//            cell.label2.text=@"2";
//            cell.label3.text=@"2";
//        }
//        cell.stackview1.hidden=YES;
        
        
        
        
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;

        
    }else if (tableView==devicetable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UILabel *deviceosversionlabel;
        UILabel *contactlabel;
        DeviceRecord *deviceobject;
        UIImageView *imageview;
        Student *studentobject;
        //NSURL *url;
        
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            stafforstudentnamelabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 195, 25)];
            stafforstudentnamelabel.font=[UIFont systemFontOfSize:14];
            stafforstudentnamelabel.textColor=[UIColor darkGrayColor];
            stafforstudentnamelabel.minimumScaleFactor=0.7;
            stafforstudentnamelabel.adjustsFontSizeToFitWidth=YES;
            stafforstudentnamelabel.tag=701;
            [cell.contentView addSubview:stafforstudentnamelabel];
            
            contactlabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 20, 195, 15)];
            contactlabel.font=[UIFont systemFontOfSize:10];
            contactlabel.textColor=[UIColor grayColor];
            contactlabel.tag=704;
            contactlabel.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:contactlabel];
            
            devicenamelabel = [[UILabel alloc]initWithFrame:CGRectMake(255, 0, 200, 25)];
            devicenamelabel.font=[UIFont systemFontOfSize:14];
            devicenamelabel.textColor=[UIColor darkGrayColor];
            devicenamelabel.adjustsFontSizeToFitWidth=YES;
            devicenamelabel.minimumScaleFactor=0.7;
            devicenamelabel.tag=702;
            [cell.contentView addSubview:devicenamelabel];
            
            //add textfield
            deviceosversionlabel = [[UILabel alloc]initWithFrame:CGRectMake(255, 20, 205, 15)];
            deviceosversionlabel.font=[UIFont systemFontOfSize:10];
            deviceosversionlabel.textColor=[UIColor lightGrayColor];
            deviceosversionlabel.tag=703;
            deviceosversionlabel.textAlignment=NSTextAlignmentLeft;
            [cell.contentView addSubview:deviceosversionlabel];

            lastloginlabel = [[UILabel alloc]initWithFrame:CGRectMake(470, 0, 150, 25)];
            lastloginlabel.font=[UIFont systemFontOfSize:14];
            lastloginlabel.textColor=[UIColor darkGrayColor];
            lastloginlabel.tag=705;
            [cell.contentView addSubview:lastloginlabel];
            
            imageview=[[UIImageView alloc]initWithFrame:CGRectMake(15, 4, 30, 30)];
            imageview.layer.cornerRadius=17;
            imageview.backgroundColor=[UIColor lightGrayColor];
            imageview.tag=706;
            imageview.contentMode=UIViewContentModeScaleAspectFill;
            imageview.layer.masksToBounds=YES;
            [cell.contentView addSubview:imageview];
            
            
        }else{
            stafforstudentnamelabel=(UILabel *)[cell.contentView viewWithTag:701];
            devicenamelabel=(UILabel *)[cell.contentView viewWithTag:702];
            deviceosversionlabel=(UILabel *)[cell.contentView viewWithTag:703];
            contactlabel=(UILabel *)[cell.contentView viewWithTag:704];
            lastloginlabel=(UILabel *)[cell.contentView viewWithTag:705];
            imageview=(UIImageView *)[cell.contentView viewWithTag:706];
            
        }
        
        // Configure the cell...
        
        
        deviceobject=[deviceArray objectAtIndex:indexPath.row];
        
        if ([deviceobject.appname isEqualToString:@"iParent"]) {
            studentobject=[MyClass returnstudentwithstudentkey:deviceobject.stafforstudentkey];
            contactlabel.text=[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:deviceobject.relationship],deviceobject.contact];
            
            [MyClass downloadImageWithImageview:imageview gender:studentobject.gender type:@"student" typekey:deviceobject.stafforstudentkey image:studentobject.image  async:YES];
            

            
            
        }else{
            contactlabel.text=deviceobject.stafforstudentkey;
            [imageview setImage:globalvariables.boyimage];
        }
        
        stafforstudentnamelabel.text=deviceobject.stafforstudentname;
        
        NSString *deviceidentifier = [[[UIDevice currentDevice] identifierForVendor].UUIDString stringByReplacingOccurrencesOfString:@"-"withString:@""];
        
        if ([deviceobject.deviceidentifier isEqualToString:deviceidentifier]) {
            devicenamelabel.text=[NSString stringWithFormat:@"%@ (%@)",deviceobject.devicename,[MyClass returntitlewithtitle:@"This Device"]];
        }else{
            devicenamelabel.text=((DeviceRecord *)[deviceArray objectAtIndex:indexPath.row]).devicename;
        }
        
        deviceosversionlabel.text=[NSString stringWithFormat:@"%@ %@",deviceobject.deviceos,deviceobject.deviceversion];
        
        NSString *date=[MyClass convertYYYYMMDDHHMMSStoDDMMMYYYYHHMMSSwithdatetime:deviceobject.lastlogin];
        if ([date length]>17) {
            lastloginlabel.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:[date substringToIndex:17]];
        }else{
            lastloginlabel.text=@"";
        }
        

        devicenamelabel.hidden=[deviceobject.appname isEqualToString:@"BI"]?YES:NO;
        deviceosversionlabel.hidden=[deviceobject.appname isEqualToString:@"BI"]?YES:NO;
        lastloginlabel.hidden=[deviceobject.appname isEqualToString:@"BI"]?YES:NO;
        
        //cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (tableView==marketingtable){
        MyTableViewCell *cell;
        if (scmarketingcategory.selectedSegmentIndex==0) {
            static NSString *CellIdentifier = @"marketingcouponcell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            marketingobject=[filteredmarketingmediaArray objectAtIndex:indexPath.row];
            
            cell.label1.text=[marketingobject.code isEqualToString:@""]?@"-":marketingobject.code;
            cell.label2.text=marketingobject.description;
            cell.label3.text=marketingobject.description_chinese;
            cell.label4.text=[MyClass returndateformatwithdate:marketingobject.startdate];
            cell.label5.hidden=YES;
            cell.label6.text=marketingobject.remarks;
            cell.label7.hidden=YES;
            cell.label8.hidden=YES;
            
            cell.label11.text=@"";
            cell.label12.text=[MyClass returndateformatwithdate:marketingobject.enddate];
            cell.label13.hidden=YES;
            cell.label14.text=@"";
        }else if (scmarketingcategory.selectedSegmentIndex==1) {
            static NSString *CellIdentifier = @"marketingcouponcell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            marketingobject=[filteredmarketingsourceArray objectAtIndex:indexPath.row];
            
            cell.label1.text=[marketingobject.code isEqualToString:@""]?@"-":marketingobject.code;
            cell.label2.text=marketingobject.description;
            cell.label3.text=marketingobject.description_chinese;
            cell.label4.text=[MyClass returndateformatwithdate:marketingobject.startdate];
            cell.label5.hidden=YES;
            cell.label6.text=marketingobject.remarks;
            cell.label7.hidden=YES;
            cell.label8.hidden=YES;
            
            cell.label11.text=@"";
            cell.label12.text=[MyClass returndateformatwithdate:marketingobject.enddate];
            cell.label13.hidden=YES;
            cell.label14.text=@"";
        }else if (scmarketingcategory.selectedSegmentIndex==2){
            static NSString *CellIdentifier = @"marketingcouponcell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            marketingobject=[filteredmarketingpromotionArray objectAtIndex:indexPath.row];
            
            cell.label1.text=[marketingobject.code isEqualToString:@""]?@"-":marketingobject.code;
            cell.label2.text=marketingobject.description;
            cell.label3.text=marketingobject.description_chinese;
            cell.label4.text=[MyClass returndateformatwithdate:marketingobject.startdate];
            cell.label5.hidden=YES;
            cell.label6.text=marketingobject.remarks;
            
            if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
                cell.label7.text=[NSString stringWithFormat:@"$%@",marketingobject.promotionfixeddiscount];
                cell.label14.text=marketingobject.perclassorquantity?[MyClass returntitlewithtitle:@"Per Class/Quota"]:@"-";
            }else{
                cell.label7.text=[NSString stringWithFormat:@"%@%@",marketingobject.promotionpercentagediscount,@"%"];
                cell.label14.text=@"-";
            }
            
            
            cell.label8.text=[NSString stringWithFormat:@"%@(%@)",marketingobject.usedcount,[marketingobject.promotionquota isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:marketingobject.promotionquota];
            cell.label7.hidden=NO;
            cell.label8.hidden=NO;
            
            cell.label11.text=@"";
            cell.label12.text=[MyClass returndateformatwithdate:marketingobject.enddate];
            cell.label13.hidden=YES;
        }else if (scmarketingcategory.selectedSegmentIndex==3){
            static NSString *CellIdentifier = @"marketingcouponcell";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            marketingobject=[filteredmarketingcouponArray objectAtIndex:indexPath.row];
            
            cell.label1.text=[marketingobject.code isEqualToString:@""]?@"-":marketingobject.code;
            cell.label2.text=marketingobject.description;
            cell.label3.text=marketingobject.description_chinese;
            cell.label4.text=[MyClass returndateformatwithdate:marketingobject.startdate];
            cell.label12.text=[MyClass returndateformatwithdate:marketingobject.enddate];
            cell.label6.text=marketingobject.remarks;
            cell.label14.text=@"";
            
            if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
                cell.label7.text=[NSString stringWithFormat:@"$%@",marketingobject.promotionfixeddiscount];
            }else{
                cell.label7.text=[NSString stringWithFormat:@"%@%@",marketingobject.promotionpercentagediscount,@"%"];
            }
            
            cell.label8.text=[NSString stringWithFormat:@"%@(%@)",marketingobject.usedcount,[marketingobject.promotionquota isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:marketingobject.promotionquota];
            cell.label7.hidden=NO;
            cell.label8.hidden=NO;
            
            cell.label11.text=[MyClass returntitlewithtitle:marketingobject.subcategory];
            cell.label5.hidden=NO;
            cell.label13.hidden=NO;
            cell.label5.text=[MyClass returnCouponeffectivefromSetting:marketingobject.effectivefrom];
            cell.label13.text=[MyClass returnCouponeffectivetoSetting:marketingobject.effectiveto];
        }
        
        
        

        //alternative background color;
        if (indexPath.row % 2==0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
 
        return cell;
        
    }else if (tableView==classroomtable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier = @"classroomcell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        ClassroomRecord *classroomobject=[filteredClassroomArray objectAtIndex:indexPath.row];
        
        cell.label3.text=classroomobject.classroom;
        cell.label6.text=[MyClass returntitlewithtitle:classroomobject.status];
        cell.label9.text=[classroomobject.capacity isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:classroomobject.capacity;
        cell.label15.text=classroomobject.remarks;
        cell.view1.backgroundColor=[globalvariables.colorcodearray objectAtIndex:classroomobject.colorcode];
        

        //alternative background color;
        if (indexPath.row % 2==0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
 
        return cell;
        
    }/*else if (tableView==subjectcategoryselectiontable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 200, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentCenter;
        
        if (indexPath.row==0) {
            GeneralLabel.text=[MyClass returntitlewithtitle:@"All Categories"];
        }else{
            GeneralLabel.text=[MyClass returnsubjectcategorynamewithscategorykey:((SubjectCategoryRecord *)[subjectcategoryarray objectAtIndex:indexPath.row]).scategorykey];
        }
        
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 37, 200, 1)];
        GeneralLabel.backgroundColor=[UIColor lightGrayColor];
        GeneralLabel.alpha=0.3;
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;
    }*/else if (tableView==sortingtable){
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            sortingnamelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 168, 38)];
            sortingnamelabel.font=[UIFont systemFontOfSize:13];
            sortingnamelabel.textColor=[UIColor darkGrayColor];
            sortingnamelabel.adjustsFontSizeToFitWidth=YES;
            sortingnamelabel.minimumScaleFactor=0.7;
            sortingnamelabel.tag=201;
            [cell.contentView addSubview:sortingnamelabel];
            
            sortingorderbutton=[[UIButton alloc]initWithFrame:CGRectMake(150, 6.5, 25, 25)];
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
    }else if (tableView==staff_privilegenametable){

        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        UILabel *GeneralLabel;
        UILabel *CountLabel;
        NSString *count;

        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-20-45, 38)];
            GeneralLabel.font=[UIFont systemFontOfSize:15];
            GeneralLabel.textColor=[UIColor darkGrayColor];
            GeneralLabel.tag=301;
            [cell.contentView addSubview:GeneralLabel];
            
            
            CountLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-10, 0, 100, 38)];
            CountLabel.font=[UIFont systemFontOfSize:13];
            CountLabel.textColor=[UIColor grayColor];
            CountLabel.textAlignment=NSTextAlignmentRight;
            CountLabel.tag=302;
            [cell.contentView addSubview:CountLabel];
            
        }else{
            GeneralLabel=(UILabel *)[cell.contentView viewWithTag:301];
            CountLabel=(UILabel *)[cell.contentView viewWithTag:302];
        }
        
        GeneralLabel.text=((PrivilegeRecord *)[localprivilegearray objectAtIndex:indexPath.row]).usertype;
        count=[privilegecountdictionary valueForKey:((PrivilegeRecord *)[localprivilegearray objectAtIndex:indexPath.row]).privilegekey];
        CountLabel.text=count?count:@"";
        
        
        return cell;

        
        
        
    }else if (tableView==staff_privilegedetailstable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        UISwitch *privilegeswitch;
        UITextField *menutext;
        UISegmentedControl *scprivilege;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (indexPath.section==0) {
            UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 350, 38)];
            GeneralLabel.font=[UIFont systemFontOfSize:15];
            GeneralLabel.textColor=[UIColor blackColor];
            GeneralLabel.text=[MyClass returntitlewithtitle:@"Privilege Name"];
            GeneralLabel.tag=301;
            [cell.contentView addSubview:GeneralLabel];
            
            menutext = [[UITextField alloc]initWithFrame:CGRectMake(204, 4, 280, 30)];
            menutext.font=[UIFont systemFontOfSize:15];
            menutext.textColor=[UIColor darkGrayColor];
            menutext.textAlignment=NSTextAlignmentRight;
            menutext.text=((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).usertype;
            
            if ([menutext.text isEqualToString:@"Super"]) {
                menutext.borderStyle = UITextBorderStyleNone;
                menutext.userInteractionEnabled=NO;
            }else{
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                menutext.userInteractionEnabled=YES;
            }
            menutext.tag=selectedPrivilegeNameRow;
            [menutext addTarget:self action:@selector(editprivilegenameeditingchanged:) forControlEvents:UIControlEventEditingChanged];
            [menutext addTarget:self action:@selector(editprivilegenameeditingdidend:) forControlEvents:UIControlEventEditingDidEnd];

            
            [cell.contentView addSubview:menutext];
            
            
        }else if (indexPath.section==privilegedetailsarray.count-1 && indexPath.row==[((NSArray *)[((NSArray *)[privilegedetailsarray objectAtIndex:indexPath.section-1]) objectAtIndex:1]) count]-1){

            UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 350, 38)];
            GeneralLabel.font=[UIFont systemFontOfSize:15];
            GeneralLabel.textColor=[UIColor blackColor];
            GeneralLabel.text=[MyClass returntitlewithtitle:[((NSArray *)[((NSArray *)[((NSArray *)[privilegedetailsarray objectAtIndex:indexPath.section-1]) objectAtIndex:1]) objectAtIndex:indexPath.row]) objectAtIndex:0]];
            GeneralLabel.tag=301;
            [cell.contentView addSubview:GeneralLabel];
            
            scprivilege=[[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Disable"],[MyClass returntitlewithtitle:@"Self arrange"],[MyClass returntitlewithtitle:@"Send request"], nil]];
            scprivilege.frame=CGRectMake(204, 4, 280, 30);
            [scprivilege addTarget:self action:@selector(updateistaffmakeupmode:) forControlEvents: UIControlEventValueChanged];
            NSString *value=[((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]) valueForKey:[((NSArray *)[((NSArray *)[((NSArray *)[privilegedetailsarray objectAtIndex:indexPath.section-1]) objectAtIndex:1]) objectAtIndex:indexPath.row]) objectAtIndex:1]];
            
            if ([value isEqualToString:@"Self arrange"]) {
                scprivilege.selectedSegmentIndex=1;
            }else if ([value isEqualToString:@"Send request"]){
                scprivilege.selectedSegmentIndex=2;
            }else{
                scprivilege.selectedSegmentIndex=0;
            }
            [cell.contentView addSubview:scprivilege];
        }else{
            UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 350, 38)];
            GeneralLabel.font=[UIFont systemFontOfSize:15];
            GeneralLabel.textColor=[UIColor blackColor];
            GeneralLabel.text=[MyClass returntitlewithtitle:[((NSArray *)[((NSArray *)[((NSArray *)[privilegedetailsarray objectAtIndex:indexPath.section-1]) objectAtIndex:1]) objectAtIndex:indexPath.row]) objectAtIndex:0]];
            GeneralLabel.tag=301;
            [cell.contentView addSubview:GeneralLabel];
            
            privilegeswitch = [[UISwitch alloc] init];
            CGSize switchSize = [privilegeswitch sizeThatFits:CGSizeZero];
            privilegeswitch.frame = CGRectMake(253.0f,3.0f,switchSize.width,switchSize.height);
            privilegeswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [privilegeswitch addTarget:self action:@selector(updateprivilege:) forControlEvents:UIControlEventValueChanged];
            privilegeswitch.tag=(indexPath.section-1)*100+indexPath.row;
            privilegeswitch.onTintColor=themecolor;
            
            BOOL value=[[((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]) valueForKey:[((NSArray *)[((NSArray *)[((NSArray *)[privilegedetailsarray objectAtIndex:indexPath.section-1]) objectAtIndex:1]) objectAtIndex:indexPath.row]) objectAtIndex:1]] boolValue];
            
            privilegeswitch.on=value;
            
            
            if([[((NSArray *)[((NSArray *)[((NSArray *)[privilegedetailsarray objectAtIndex:indexPath.section-1]) objectAtIndex:1]) objectAtIndex:indexPath.row]) objectAtIndex:1] isEqualToString:@"istaffreceiveallstudentnotifications"]){
                privilegeswitch.enabled=[[((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]) valueForKey:[((NSArray *)[((NSArray *)[((NSArray *)[privilegedetailsarray objectAtIndex:indexPath.section-1]) objectAtIndex:1]) objectAtIndex:indexPath.row-1]) objectAtIndex:1]] boolValue];
            }else{
                privilegeswitch.enabled=YES;
            }
            
            
            
            
            
            
            [cell.contentView addSubview:privilegeswitch];
        }
        
        

        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
        
    }else if (tableView==staff_groupnametable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        UILabel *GeneralLabel;
        UILabel *CountLabel;
        NSString *count;
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-20-45, 38)];
            GeneralLabel.font=[UIFont systemFontOfSize:15];
            GeneralLabel.textColor=[UIColor darkGrayColor];
            GeneralLabel.tag=301;
            [cell.contentView addSubview:GeneralLabel];
            
            
            CountLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-10, 0, 100, 38)];
            CountLabel.font=[UIFont systemFontOfSize:13];
            CountLabel.textColor=[UIColor grayColor];
            CountLabel.textAlignment=NSTextAlignmentRight;
            CountLabel.tag=302;
            [cell.contentView addSubview:CountLabel];
            
        }else{
            GeneralLabel=(UILabel *)[cell.contentView viewWithTag:301];
            CountLabel=(UILabel *)[cell.contentView viewWithTag:302];
        }
        
        GeneralLabel.text=((GroupRecord *)[GroupArray objectAtIndex:indexPath.row]).groupname;
        count=[groupcountdictionary valueForKey:((GroupRecord *)[GroupArray objectAtIndex:indexPath.row]).groupkey];
        CountLabel.text=count?count:@"";
        
        
        return cell;
        
    }else if (tableView==staff_groupdetailstable){
        
        if (indexPath.section==0) {
            static NSString *CellIdentifier = @"section_0_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
            
            UITextField *menutext;

            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            menutext = [[UITextField alloc]initWithFrame:CGRectMake(15, 4, tableView.frame.size.width-30, 30)];
            menutext.font=[UIFont systemFontOfSize:15];
            menutext.textColor=[UIColor darkGrayColor];
            //menutext.textAlignment=NSTextAlignmentRight;
            menutext.borderStyle = UITextBorderStyleRoundedRect;
            menutext.text=((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupname;
            [menutext addTarget:self action:@selector(editgroupnameeditingchanged:) forControlEvents:UIControlEventEditingChanged];
            [menutext addTarget:self action:@selector(editgroupnameeditingdidend:) forControlEvents:UIControlEventEditingDidEnd];
            [cell.contentView addSubview:menutext];
            menutext.tag=selectedGroupNameRow;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.section==1) {
            static NSString *CellIdentifier = @"section_1_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
            
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
            groupdescriptiontext = [[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(15, 4, tableView.frame.size.width-30, 60)];
            groupdescriptiontext.font=[UIFont systemFontOfSize:15];
            groupdescriptiontext.textColor=[UIColor darkGrayColor];
            groupdescriptiontext.text=((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).description;
            groupdescriptiontext.delegate=self;
            groupdescriptiontext.placeholder=[MyClass returntitlewithtitle:@"Description"];
            //[menutext addTarget:self action:@selector(editgroupname:) forControlEvents:UIControlEventEditingChanged];
            [cell.contentView addSubview:groupdescriptiontext];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            static NSString *CellIdentifier = @"section_2_cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
            UILabel *GeneralLabel;
            UISwitch *menuswitch;
            //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            if (cell==nil){
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 38)];
                GeneralLabel.font=[UIFont systemFontOfSize:15];
                GeneralLabel.textColor=[UIColor darkGrayColor];
                GeneralLabel.tag=301;
                [cell.contentView addSubview:GeneralLabel];
                
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 302;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updategroup:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:menuswitch];
                
            }else{
                GeneralLabel=(UILabel *)[cell.contentView viewWithTag:301];
                menuswitch=(UISwitch *)[cell.contentView viewWithTag:302];
            }
            
            GeneralLabel.text=[MyClass returntitlewithtitle:[groupalertarray objectAtIndex:indexPath.row]];
            NSIndexPath *indexp=[staff_groupnametable indexPathForSelectedRow];
            if (indexPath.row==0) {
                menuswitch.on=((GroupRecord *)[GroupArray objectAtIndex:indexp.row]).makeuparrangementnotification;
            }else if(indexPath.row==1){
                menuswitch.on=((GroupRecord *)[GroupArray objectAtIndex:indexp.row]).autorenewalfailurenotification;
            }else if(indexPath.row==2){
                menuswitch.on=((GroupRecord *)[GroupArray objectAtIndex:indexp.row]).onlineenrollmentnotification;
            }else{
                menuswitch.on=((GroupRecord *)[GroupArray objectAtIndex:indexp.row]).onlinepaymentnotification;
            }
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if (tableView==staff_membertable){

        static NSString *CellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        UILabel *GeneralLabel;
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-30, 38)];
            GeneralLabel.font=[UIFont systemFontOfSize:15];
            GeneralLabel.textColor=[UIColor darkGrayColor];
            GeneralLabel.tag=301;
            GeneralLabel.numberOfLines=0;
            [cell.contentView addSubview:GeneralLabel];
            
        }else{
            GeneralLabel=(UILabel *)[cell.contentView viewWithTag:301];
        }
        
        GeneralLabel.text=[MyClass returnstaffnamewithusername:((Staff *)[filteredStaffArray objectAtIndex:indexPath.row]).username firstorfullname:@"full"];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }else if (tableView==ri_instructortable){
        
        static NSString *CellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        UILabel *GeneralLabel;
            UIImageView *instructorselectedimage;
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-30, 38)];
            GeneralLabel.font=[UIFont systemFontOfSize:15];
            GeneralLabel.textColor=[UIColor darkGrayColor];
            GeneralLabel.tag=301;
            GeneralLabel.numberOfLines=0;
            [cell.contentView addSubview:GeneralLabel];
            
            instructorselectedimage=[[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width-36, 6, 26, 26)];
            [instructorselectedimage setImage:[UIImage imageNamed:@"checked_icon.png"]];
            instructorselectedimage.tag=303;
            [cell.contentView addSubview:instructorselectedimage];
            
        }else{
            GeneralLabel=(UILabel *)[cell.contentView viewWithTag:301];
            instructorselectedimage=(UIImageView *)[cell.contentView viewWithTag:303];
        }
        
        GeneralLabel.text=[MyClass returnstaffnamewithusername:((Instructor *)[ri_filteredinstructorarray objectAtIndex:indexPath.row]).username firstorfullname:@"full"];
        if ([GeneralLabel.text isEqualToString:@"TBD"]) {
            GeneralLabel.text=[MyClass returntitlewithtitle:@"TBD"];
        }
        
        if ([((Instructor *)[ri_filteredinstructorarray objectAtIndex:indexPath.row]).username isEqualToString:(selectedinstructorbutton==frominstructorbutton)?ri_frominstructor:ri_toinstructor]) {
            instructorselectedimage.hidden=NO;
        }else{
            instructorselectedimage.hidden=YES;
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }else if (tableView==ri_subjecttable){
        
        static NSString *CellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        UILabel *Subjectcodelabel;
        UILabel *Subjectnamelabel;
        UILabel *Subjectcountlabel;
        UIImageView *Subjectselectedimage;
        
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            Subjectcodelabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 60, 38)];
            Subjectcodelabel.font=[UIFont systemFontOfSize:15];
            Subjectcodelabel.textColor=[UIColor darkGrayColor];
            Subjectcodelabel.tag=301;
            Subjectcodelabel.numberOfLines=0;
            [cell.contentView addSubview:Subjectcodelabel];

            Subjectnamelabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, tableView.frame.size.width-80-10-36, 38)];
            Subjectnamelabel.font=[UIFont systemFontOfSize:15];
            Subjectnamelabel.textColor=[UIColor darkGrayColor];
            Subjectnamelabel.tag=302;
            Subjectnamelabel.numberOfLines=0;
            [cell.contentView addSubview:Subjectnamelabel];
            
            
            Subjectcountlabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-150, 0, 100, 38)];
            Subjectcountlabel.font=[UIFont systemFontOfSize:13];
            Subjectcountlabel.textColor=[UIColor lightGrayColor];
            Subjectcountlabel.textAlignment=NSTextAlignmentRight;
            Subjectcountlabel.tag=304;
            Subjectcountlabel.numberOfLines=0;
            [cell.contentView addSubview:Subjectcountlabel];
            
            Subjectselectedimage=[[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width-36, 6, 26, 26)];
            [Subjectselectedimage setImage:[UIImage imageNamed:@"checked_icon.png"]];
            Subjectselectedimage.tag=303;
            [cell.contentView addSubview:Subjectselectedimage];
            
        }else{
            Subjectcodelabel=(UILabel *)[cell.contentView viewWithTag:301];
            Subjectnamelabel=(UILabel *)[cell.contentView viewWithTag:302];
            Subjectselectedimage=(UIImageView *)[cell.contentView viewWithTag:303];
            Subjectcountlabel=(UILabel *)[cell.contentView viewWithTag:304];
        }
        
        
        Subjectcodelabel.text=((SubjectRecord *)[ri_subjectarray objectAtIndex:indexPath.row]).subject_shortname;
        Subjectnamelabel.text=((SubjectRecord *)[ri_subjectarray objectAtIndex:indexPath.row]).subject_englishname;
        Subjectcountlabel.text=((SubjectRecord *)[ri_subjectarray objectAtIndex:indexPath.row]).studentcapacity;
        if ([ri_selectedsubjectarray containsObject:((SubjectRecord *)[ri_subjectarray objectAtIndex:indexPath.row]).subject_shortname]) {
            Subjectselectedimage.layer.opacity=1;
        }else{
            Subjectselectedimage.layer.opacity=0.3;
        }
        

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }else if (tableView==staff_membergrouptable){
        
        //NSString *CellIdentifier = @"cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.tableViewCellIdentifier ];
        UIButton *membergroupbutton;
        
        float width=(staff_membergroupview.frame.size.width/GroupArray.count>100)?staff_membergroupview.frame.size.width/GroupArray.count:100;
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:self.tableViewCellIdentifier];

            for (int i=0;i<GroupArray.count;i++) {
                membergroupbutton=[[UIButton alloc]initWithFrame:CGRectMake(i*width+(width-30)/2, 4, 30, 30)];
                [membergroupbutton setImage:[UIImage imageNamed:@"checked_icon.png"] forState:UIControlStateNormal];
                [membergroupbutton addTarget: self action:@selector(enablegroupmember:) forControlEvents: UIControlEventTouchUpInside];
                membergroupbutton.tag=1000+i;
                [cell.contentView addSubview:membergroupbutton];
            }
        }/*else{
            GeneralLabel=(UILabel *)[cell.contentView viewWithTag:301];
        }*/
        
        
        for (int i=0; i<GroupArray.count; i++) {
            membergroupbutton=(UIButton *)[cell.contentView viewWithTag:1000+i];
            
            if ([self containsGroupKeyWithMemberArray:((Staff *)[filteredStaffArray objectAtIndex:indexPath.row]).grouparray groupKey:((GroupRecord *)[GroupArray objectAtIndex:i]).groupkey]) {
                membergroupbutton.layer.opacity=1;
            }else{
                membergroupbutton.layer.opacity=0.2;
            }
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;

        return cell;
        
        
    }else if (tableView==ri_calendartable){
        if(selectedperiodbutton==dayoptionbutton){
            static NSString *CellIdentifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
            UILabel *daylabel;
            UIImageView *dayimage;
            
            if (cell==nil){
                cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                daylabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 38)];
                daylabel.font=[UIFont systemFontOfSize:15];
                daylabel.textColor=[UIColor darkGrayColor];
                daylabel.tag=301;
                daylabel.numberOfLines=0;
                [cell.contentView addSubview:daylabel];
                
                
                dayimage=[[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width-36, 6, 26, 26)];
                [dayimage setImage:[UIImage imageNamed:@"checked_icon.png"]];
                dayimage.tag=303;
                [cell.contentView addSubview:dayimage];
                
            }else{
                daylabel=(UILabel *)[cell.contentView viewWithTag:301];
                dayimage=(UIImageView *)[cell.contentView viewWithTag:303];
            }
            
            
            daylabel.text=[MyClass returntitlewithtitle:[dayOptionArray objectAtIndex:indexPath.row]];
            if ([selectedDayOptionArray containsObject:[dayOptionArray objectAtIndex:indexPath.row]]) {
                dayimage.layer.opacity=1;
            }else{
                dayimage.layer.opacity=0.3;
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            UITableViewCell *cell;
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            CalendarView *calendar_view=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 190) Theme:0 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
            
            calendar_view.delegate=self;
            
            if (selectedperiodbutton==fromperiodbutton) {
                if ([ri_fromperiod isEqualToString:@""]) {
                    [calendar_view scrollToSelectedDateWithSelectedDateArray:nil ScrollToDate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] instructorselected:nil];
                }else{
                    [calendar_view scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[ri_fromperiod substringToIndex:11], nil] ScrollToDate:nil instructorselected:nil];
                }
            }else{
                if ([ri_toperiod isEqualToString:@""]) {
                    [calendar_view scrollToSelectedDateWithSelectedDateArray:nil ScrollToDate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] instructorselected:nil];
                }else{
                    [calendar_view scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[ri_toperiod substringToIndex:11], nil] ScrollToDate:nil instructorselected:nil];
                }
            }
            
            [cell.contentView addSubview:calendar_view];
            
            NSString *tmptime;
            if (selectedperiodbutton==fromperiodbutton) {
                tmptime=ri_fromperiod;
            }else{
                tmptime=ri_toperiod;
            }
            
            if ([tmptime isEqualToString:@""]) {
                hourPresetRow=0;
                minutePresetRow=0;
            }else{
                hourPresetRow=[hourPickerViewMenu indexOfObject:[[tmptime substringFromIndex:[tmptime length]-5] substringToIndex:2]];
                minutePresetRow=[minutePickerViewMenu indexOfObject:[[tmptime substringFromIndex:[tmptime length]-2] substringToIndex:2]];
            }
            
            
            myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, calendar_view.frame.size.height, tableView.frame.size.width, 152)];
            myPicker.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.03];
            [myPicker setDataSource:self];
            [myPicker setDelegate:self];
            myPicker.tag=801;
            
            [myPicker selectRow:hourPresetRow inComponent:0 animated:NO];
            [myPicker selectRow:minutePresetRow inComponent:1 animated:NO];
            
            [myPicker setShowsSelectionIndicator:YES];
            //myPickerView=myPicker;
            [cell.contentView addSubview:myPicker];
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
        
        
        
        
    }else if (tableView==tncTable){

        UITableViewCell *cell;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0){
            receipttnctext = [[UITextView alloc]initWithFrame:CGRectMake(15, 5, tableView.frame.size.width-30, 480)];
            receipttnctext.font=[UIFont systemFontOfSize:12];
            receipttnctext.textColor=[UIColor darkGrayColor];
            receipttnctext.text=globalvariables.centerrecord.receipttnc;
            receipttnctext.delegate=self;
            [cell.contentView addSubview:receipttnctext];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.section==1){
            invoicetnctext = [[UITextView alloc]initWithFrame:CGRectMake(15, 5, tableView.frame.size.width-30, 480)];
            invoicetnctext.font=[UIFont systemFontOfSize:12];
            invoicetnctext.textColor=[UIColor darkGrayColor];
            invoicetnctext.text=globalvariables.centerrecord.invoicetnc;
            invoicetnctext.delegate=self;
            [cell.contentView addSubview:invoicetnctext];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        return cell;
    
    }else if (tableView==leaveNatureListTable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"naturelistcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        
        LeaveNatureRecord *record=[globalvariables.leavenaturearray objectForKey:((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:indexPath.row]).leavenaturelistkey];
        cell.label1.text=[MyClass returnLeaveNatureNameWithLeaveNatureListKey:record.leavenaturelistkey];
        if(record){
            if([globalvariables.language isEqualToString:@"English"]){
                cell.label2.text=record.nature_desc_chinese;
            }else{
                cell.label2.text=record.nature_desc_english;
            }
        }else{
            cell.label2.text= @"";
        }

        
        if (indexPath.row==selectedLeaveNatureRow) {
            cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.22];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        return cell;
        
        
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 200, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentCenter;
        GeneralLabel.text=[productcategoryarray objectAtIndex:indexPath.row];
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 37, 200, 1)];
        GeneralLabel.backgroundColor=[UIColor lightGrayColor];
        GeneralLabel.alpha=0.3;
        [cell.contentView addSubview:GeneralLabel];
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }

}

-(void) yetgivenbuttonpressed:(UIButton *)button
{
    [ailoadindicator startAnimating];
    ailoadindicator.hidden=NO;
    [self adjustpresentingviewwidthwithwidth:400];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ProductRecord *prodObject=[filteredProductArray objectAtIndex:button.tag];

        GivenOutViewController *viewController = (GivenOutViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier:@"GivenOutViewController"];
        viewController.delegate=self;
        viewController.salesrecords=[[yetGivenProductDict valueForKey:prodObject.code] valueForKey:@"salesrecords"];

        viewController.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:viewController.view];
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
}

-(void) getyetgivenproduct
{
    
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getyetgivenproduct",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey];
    
    __block BOOL result=FALSE;
    __block NSDictionary *jsonreturned;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
        }
    }];
    
    if (result) {
        NSMutableArray *JSONArray=jsonreturned[@"content"];
        yetGivenProductDict=[[NSMutableDictionary alloc]init];
        for (int i=0; i<JSONArray.count; i++) {
            NSString *productcode=[[JSONArray objectAtIndex:i] objectForKey:@"productcode"];
            NSString *yetgivencount=[[JSONArray objectAtIndex:i] objectForKey:@"yetgivencount"];
            NSArray *tmpsalesrecords=[[JSONArray objectAtIndex:i] objectForKey:@"salesrecords"];
            NSMutableArray *salesrecords=[[NSMutableArray alloc]init];
            for (int j=0; j<tmpsalesrecords.count; j++) {
                NSString *productcode=[[tmpsalesrecords objectAtIndex:j] objectForKey:@"productcode"];
                NSString *saleskey=[[tmpsalesrecords objectAtIndex:j] objectForKey:@"saleskey"];
                NSString *orderdate=[[tmpsalesrecords objectAtIndex:j] objectForKey:@"orderdate"];
                NSString *studentkey=[[tmpsalesrecords objectAtIndex:j] objectForKey:@"studentkey"];
                NSString *quantity=[[tmpsalesrecords objectAtIndex:j] objectForKey:@"quantity"];
                NSString *givenout=[[tmpsalesrecords objectAtIndex:j] objectForKey:@"givenout"];
                
                [salesrecords addObject:[[SalesRecord alloc]initSalesRecordWithstudentkey:studentkey saleskey:saleskey orderdate:orderdate productfullname:nil productcode:productcode productcategory:nil price:nil quantity:quantity oneoffdiscount:nil oneoffpercentagediscount:nil paid:nil total:nil remarks:[MyClass returnStudentnameWithStudentkey:studentkey option:@"full"] invoiceremarks:nil status:nil reverseadjustment:nil autorenew:nil paymentrecords:nil promotiondiscountrecords:nil givenout:givenout couponrecords:nil invoicenumber:nil invoiceprefix:nil]];
            }
            
            NSMutableDictionary *dict=[[NSMutableDictionary alloc]init];
            [dict setValue:productcode forKey:@"productcode"];
            [dict setValue:yetgivencount forKey:@"yetgivencount"];
            [dict setValue:salesrecords forKey:@"salesrecords"];
            [yetGivenProductDict setValue:dict forKey:productcode];
        }
    }
}

-(NSString *) returnAllStockCounts:(NSString *)allstockcounts
{
    if ([allstockcounts isEqualToString:@""]) {
        return @"";
    }

    NSArray *stockcounts=[allstockcounts componentsSeparatedByString:@","];
    NSMutableArray *resultarray=[[NSMutableArray alloc]init];
    for (int i=0; i<stockcounts.count; i++) {
        NSRange range=[stockcounts[i] rangeOfString:@"#"];
        if (globalvariables.centerrecord.enableaccountreceivablecodes && !globalvariables.centerrecord.consolidatestockcountformultipleaccountcodes) {
            if (range.location != NSNotFound) {
                NSString *arckey=[stockcounts[i] substringToIndex:range.location];
                ARCodeRecord *obj =[globalvariables.arcodelistarray objectForKey:arckey];
                NSString *arcode=obj.arcode;
                NSString *stockcount=[stockcounts[i] substringFromIndex:range.location+1];
                if(![stockcount isEqualToString:@""]){
                    [resultarray addObject:[NSString stringWithFormat:@"%@ %@",arcode,stockcount]];
                }
            }
        }else{
            if (range.location == NSNotFound) {
                return stockcounts[i];
            }
        }
    }
    
    if (resultarray.count==0) {
        return @"";
    }else{
        return [resultarray componentsJoinedByString:@"; "];
    }
}

-(BOOL) containsGroupKeyWithMemberArray:(NSMutableArray *)memberarray groupKey:(NSString *)groupkey
{
    for (int i=0; i<memberarray.count; i++) {
        GroupMemberRecord *member=[memberarray objectAtIndex:i];
        if ([member.groupkey isEqualToString:groupkey]) {
            return TRUE;
        }
    }
    return FALSE;
}

-(void) updategroup:(UISwitch *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:staff_groupdetailstable];
    NSIndexPath *indexpath =[staff_groupdetailstable indexPathForRowAtPoint:point];
    
    NSString *parameter;
    if (indexpath.row==0) {
        parameter=@"makeuparrangementnotification";
    }else if (indexpath.row==1){
        parameter=@"autorenewalfailurenotification";
    }else if (indexpath.row==2){
        parameter=@"onlineenrollmentnotification";
    }else{
        parameter=@"onlinepaymentnotification";
    }
    
    [self updateGroupWithField:parameter Value:sender.on?@"Yes":@"No" groupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey];
}


-(void) updateprivilege:(UISwitch *)sender
{
    if (sender.tag/100==0 && [((UserPrivilege *)[MyClass returnuserprivilegewithcenterkey:globalvariables.centerrecord.centerkey]).privilegekey isEqualToString:((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).privilegekey]) {
        globalvariables.reloadleftmenu=YES;
    }
    
    NSString *parameter=[((NSArray *)[((NSArray *)[((NSArray *)[privilegedetailsarray objectAtIndex:sender.tag/100]) objectAtIndex:1]) objectAtIndex:sender.tag%100]) objectAtIndex:1];
    [((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]) setValue:[NSNumber numberWithBool:sender.on] forKey:parameter];
    
    [self updatePrivilegeWithField:parameter Value:sender.on?@"Yes":@"No" privilegekey:((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).privilegekey];
    
    if([parameter isEqualToString:@"istaffviewcentermessage"]){
        [staff_privilegedetailstable reloadData];
    }else if (([parameter isEqualToString:@"vieweditsalaryrate"])){
        showSalaryrate=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).vieweditsalaryrate&& globalvariables.centerrecord.enablestaffsalaryrate;
        [stafftable reloadData];
    }
    
    
    
    [self refreshmenutitle];
}

-(void) updateistaffmakeupmode:(UISegmentedControl *)sender
{
    NSString *value;
    if (sender.selectedSegmentIndex==0) {
        value=@"Disable";
    }else if(sender.selectedSegmentIndex==1){
        value=@"Self arrange";
    }else if (sender.selectedSegmentIndex==2){
        value=@"Send request";
    }
    
    [((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]) setValue:value forKey:@"istaffmakeupmode"];
    
    [self updatePrivilegeWithField:@"istaffmakeupmode" Value:value privilegekey:((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).privilegekey];
}

-(void) editprivilegenameeditingchanged:(UITextField *)sender
{

    ((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).usertype=sender.text;
    
    //[self updatePrivilegeWithField:@"usertype" Value:sender.text privilegekey:((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).privilegekey];
    
    //NSIndexPath *current=[staff_privilegenametable indexPathForSelectedRow];
    
    [staff_privilegenametable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedPrivilegeNameRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [staff_privilegenametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedPrivilegeNameRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

-(void) editprivilegenameeditingdidend:(UITextField *)sender
{
    //trim leading and trailing space
    sender.text=[MyClass leadingtrailingspacestrimmed:sender.text];
    ((PrivilegeRecord *)[localprivilegearray objectAtIndex:sender.tag]).usertype=sender.text;
    
    if (![self isprivilegeusertypealreadyexistwithusertype:((PrivilegeRecord *)[localprivilegearray objectAtIndex:sender.tag]).usertype privilegekey:((PrivilegeRecord *)[localprivilegearray objectAtIndex:sender.tag]).privilegekey]) {
        
        ((PrivilegeRecord *)[localprivilegearray objectAtIndex:sender.tag]).usertype=sender.text;
        
        [self updatePrivilegeWithField:@"usertype" Value:sender.text privilegekey:((PrivilegeRecord *)[localprivilegearray objectAtIndex:sender.tag]).privilegekey];
        [self retrieveStaffListwithflushcachedata:NO];
        
        //NSIndexPath *current=[staff_privilegenametable indexPathForSelectedRow];
        
        [staff_privilegenametable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [staff_privilegenametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedPrivilegeNameRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

-(void) editgroupnameeditingchanged:(UITextField *)sender
{
    //privilegenameupdated=TRUE;
    ((GroupRecord *)[GroupArray objectAtIndex:sender.tag]).groupname=sender.text;
    
    //[self updateGroupWithField:@"groupname" Value:sender.text groupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey];
    
    //NSIndexPath *current=[staff_groupnametable indexPathForSelectedRow];
    
    [staff_groupnametable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedGroupNameRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [staff_groupnametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedGroupNameRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}


-(void) editgroupnameeditingdidend:(UITextField *)sender
{
    //trim leading and trailing space
    sender.text=[MyClass leadingtrailingspacestrimmed:sender.text];
    ((GroupRecord *)[GroupArray objectAtIndex:sender.tag]).groupname=sender.text;
    
    if (![self isgroupnamealreadyexistwithgroupname:sender.text groupkey:((GroupRecord *)[GroupArray objectAtIndex:sender.tag]).groupkey]) {
        ((GroupRecord *)[GroupArray objectAtIndex:sender.tag]).groupname=sender.text;
        
        [self updateGroupWithField:@"groupname" Value:sender.text groupkey:((GroupRecord *)[GroupArray objectAtIndex:sender.tag]).groupkey];
        [self retrieveStaffListwithflushcachedata:NO];
        
        //NSIndexPath *current=[staff_groupnametable indexPathForSelectedRow];
        
        
        [staff_groupnametable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:sender.tag inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [staff_groupnametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedGroupNameRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView==policytable) {
        
        if (!policy_editmode) {
            UILabel *myLabel = [[UILabel alloc] init];
            myLabel.frame = CGRectMake(5, 10, policytable.contentSize.width, 30);
            myLabel.font = [UIFont boldSystemFontOfSize:16];
            myLabel.text = [self tableView:tableView titleForHeaderInSection:section];
            myLabel.textColor=[UIColor darkTextColor];
            
            UILabel *myLabelShade = [[UILabel alloc] init];
            myLabelShade.frame = CGRectMake(0, 0, policytable.contentSize.width, 40);
            myLabelShade.font = [UIFont boldSystemFontOfSize:13];
            myLabelShade.backgroundColor=[UIColor systemGroupedBackgroundColor];
            
            UILabel *myline = [[UILabel alloc] init];
            myline.frame = CGRectMake(5, 38, policytable.contentSize.width-20, 1);
            myline.backgroundColor=[UIColor darkGrayColor];
            
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, policytable.contentSize.width, 40)];
            [headerView addSubview:myLabelShade];
            [headerView addSubview:myLabel];
            [headerView addSubview:myline];
            
            return headerView;
        }else{
            UITextField *myText = [[UITextField alloc] init];
            myText.frame = CGRectMake(5, 8, policytable.contentSize.width-120, 30);
            myText.font = [UIFont boldSystemFontOfSize:16];
            myText.text = [self tableView:tableView titleForHeaderInSection:section];
            myText.borderStyle=UITextBorderStyleRoundedRect;
            myText.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.05];
            myText.textColor=[UIColor darkTextColor];
            myText.tag=section;
            [myText addTarget:self action:@selector(policy_titlechange:) forControlEvents:UIControlEventEditingChanged];
            
            
            UIButton *deletebutton=[[UIButton alloc]initWithFrame:CGRectMake(policytable.frame.size.width-90, 10, 30, 30)];
            [deletebutton setImage:[UIImage imageNamed:@"deletebutton.png"] forState:UIControlStateNormal];
            [deletebutton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            deletebutton.tag=section;
            [deletebutton addTarget:self action:@selector(policy_deletesectionbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *addbutton=[[UIButton alloc]initWithFrame:CGRectMake(deletebutton.frame.origin.x+30+10, 10, 30, 30)];
            [addbutton setImage:[UIImage imageNamed:@"addphonebutton.png"] forState:UIControlStateNormal];
            [addbutton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
            addbutton.tag=section;
            [addbutton addTarget:self action:@selector(policy_addsectionbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
            UILabel *myLabelShade = [[UILabel alloc] init];
            myLabelShade.frame = CGRectMake(0, 0, policytable.contentSize.width, 40);
            myLabelShade.font = [UIFont boldSystemFontOfSize:13];
            myLabelShade.backgroundColor=[UIColor systemGroupedBackgroundColor];
            
            UILabel *myline = [[UILabel alloc] init];
            myline.frame = CGRectMake(5, 42, policytable.contentSize.width-30, 1);
            myline.backgroundColor=[UIColor darkGrayColor];
            
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, policytable.contentSize.width, 40)];
            [headerView addSubview:myLabelShade];
            [headerView addSubview:myText];
            [headerView addSubview:myline];
            [headerView addSubview:deletebutton];
            [headerView addSubview:addbutton];
            
            return headerView;
        }
        
    }else if (tableView==staff_membergrouptable){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        [headerView setBackgroundColor:[UIColor systemGroupedBackgroundColor]];
        float width=tableView.frame.size.width/GroupArray.count;
        for (int i=0; i<GroupArray.count; i++) {
            UILabel *myLabel = [[UILabel alloc] init];
            myLabel.frame = CGRectMake(width*i+5, 0, width-10, 40);
            myLabel.font = [UIFont boldSystemFontOfSize:13];
            myLabel.textAlignment=NSTextAlignmentCenter;
            myLabel.minimumScaleFactor=0.7;
            myLabel.adjustsFontSizeToFitWidth=YES;
            myLabel.numberOfLines=0;
            myLabel.text = ((GroupRecord *)[GroupArray objectAtIndex:i]).groupname;
            myLabel.textColor=[UIColor grayColor];
            [headerView addSubview:myLabel];
        }
        
        return headerView;
    }else if (tableView==staff_membertable){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        [headerView setBackgroundColor:[UIColor systemGroupedBackgroundColor]];
        return headerView;
    }else{
        return nil;
    }
}




-(BOOL) updatePrivilegeWithField:(NSString *)field Value:(NSString *)value privilegekey:(NSString *)privilegekey
{

    //combine arrays
    NSDictionary *dictionary = @{@"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"field" : field,
                                 @"value" : value,
                                 @"privilegekey" : privilegekey,
                                 @"postaction" : @"updateprivilege2",
                                 @"updatedby" : globalvariables.username
                                 };
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    return result;
}

-(BOOL) updateGroupWithField:(NSString *)field Value:(NSString *)value groupkey:(NSString *)groupkey
{
    
    //combine arrays
    NSDictionary *dictionary = @{@"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"field" : field,
                                 @"value" : value,
                                 @"groupkey" : groupkey,
                                 @"postaction" : @"updategroup"
                                 };
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if(result){
        [self retrieveGroup];
    }
    return result;
}


-(BOOL) deletePrivilegeWithPrivilegekey:(NSString *)privilegekey
{

    //combine arrays
    NSDictionary *dictionary = @{@"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"privilegekey" : privilegekey,
                                 @"postaction" : @"deleteprivilege",
                                 @"updatedby" : globalvariables.username
                                 };
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if(result){
        [self retrievePrivilege];
        
        if (selectedPrivilegeNameRow>localprivilegearray.count-1) {
            selectedPrivilegeNameRow=localprivilegearray.count-1;
        }
        
            [staff_privilegenametable reloadData];
            [staff_privilegenametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedPrivilegeNameRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
            [staff_privilegedetailstable reloadData];
            [staff_privilegedetailstable setContentOffset:CGPointMake(0, 0)];
    }
    return result;
    
}


-(BOOL) addPrivilegeWithUsertype:(NSString *)usertype
{
    //combine arrays
    NSDictionary *dictionary = @{@"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"usertype" : usertype,
                                 @"postaction" : @"addprivilege",
                                 @"updatedby" : globalvariables.username
                                 };
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if(result){
        [self retrievePrivilege];
        
        [staff_privilegenametable reloadData];
        [staff_privilegenametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:localprivilegearray.count-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
        selectedPrivilegeNameRow=localprivilegearray.count-1;
        [staff_privilegedetailstable reloadData];
        [staff_privilegedetailstable setContentOffset:CGPointMake(0, 0)];
    }
    return result;
}

-(BOOL) addGroupWithName:(NSString *)groupname
{

    //combine arrays
    NSDictionary *dictionary = @{@"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"groupname" : groupname,
                                 @"postaction" : @"addgroup"
                                 };
    
    __block BOOL result=FALSE;
        __block NSString *newgroupkey;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray=jsonreturned[@"content"];
            newgroupkey=[[JSONArray objectAtIndex:0] objectForKey:@"groupkey"];
        }
    }];

    
    if(result){
        [self retrieveGroup];
        selectedGroupNameRow=[self findgroupindexrowwithgroupkey:newgroupkey];
        
        [staff_groupnametable reloadData];
        [staff_groupnametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedGroupNameRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
    return result;
}

-(int) findgroupindexrowwithgroupkey:(NSString *)groupkey
{
    for (int i=0; i<GroupArray.count; i++) {
        if ([((GroupRecord *)[GroupArray objectAtIndex:i]).groupkey isEqualToString:groupkey]) {
            return i;
        }
    }
    return 0;
}


-(BOOL) deleteGroupWithGroupkey:(NSString *)groupkey
{
    //combine arrays
    NSDictionary *dictionary = @{@"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"groupkey" : groupkey,
                                 @"postaction" : @"deletegroup"
                                 };
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];

    if(result){
        [self retrieveGroup];
        
        if (GroupArray.count>0) {
            if (selectedGroupNameRow>GroupArray.count-1) {
                selectedGroupNameRow=GroupArray.count-1;
            }
            [staff_groupnametable reloadData];
            [staff_groupnametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedGroupNameRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
            [staff_groupdetailstable reloadData];
        }
    }
    return result;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView==devicetable) {
        return YES;
    }else if (tableView==sortingtable){
        return YES;
    }else if (tableView==leaveNatureListTable){
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==devicetable){

        devicetableindexpath=indexPath;
        DeviceRecord *deviceobject=[deviceArray objectAtIndex:indexPath.row];
        
        if ([deviceobject.appname isEqualToString:@"iParent"]) {

            
            UIAlertController *disablealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Disable iParent"] message:[NSString stringWithFormat:@"%@%@ %@ app?",[MyClass returntitlewithtitle:@"Are you sure to disable "],deviceobject.contact,deviceobject.appname] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [self disableuserappwithstudentkey:deviceobject.stafforstudentkey username:deviceobject.contact appname:deviceobject.appname];
                
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [disablealert dismissViewControllerAnimated:YES completion:nil];
                [devicetable reloadData];
            }];
            
            [disablealert addAction:OKAction];
            [disablealert addAction:CancelAction];
            
            [self presentViewController:disablealert animated:YES completion:nil];
            
            
            
        }else if ([deviceobject.appname isEqualToString:@"iStaff"]) {
            UIAlertController *disablealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Disable iStaff"] message:[NSString stringWithFormat:@"%@%@ %@ app?",[MyClass returntitlewithtitle:@"Are you sure to disable "],deviceobject.stafforstudentname,deviceobject.appname] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [self disableuserappwithstudentkey:nil username:deviceobject.stafforstudentkey appname:deviceobject.appname];

            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [disablealert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [disablealert addAction:OKAction];
            [disablealert addAction:CancelAction];
            
            [self presentViewController:disablealert animated:YES completion:nil];
        }else if ([deviceobject.appname isEqualToString:@"iCenter"]) {
            UIAlertController *disablealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Disable iCenter"] message:[NSString stringWithFormat:@"%@%@ %@ app?",[MyClass returntitlewithtitle:@"Are you sure to disable "],deviceobject.stafforstudentname,deviceobject.appname] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [self disableuserappwithstudentkey:nil username:deviceobject.stafforstudentkey appname:deviceobject.appname];
                
                //logout if disable self access
                if ([deviceobject.stafforstudentkey isEqualToString:globalvariables.username]) {
                    if ([MyClass removeUserTokenDeviceWithUserDeviceKey:globalvariables.userdevicekey]) {
                        
                        [MyClass logoutUser];

                    }
                }
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [disablealert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [disablealert addAction:OKAction];
            [disablealert addAction:CancelAction];
            
            [self presentViewController:disablealert animated:YES completion:nil];
        }else if ([deviceobject.appname isEqualToString:@"BI"]) {
            UIAlertController *disablealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Disable BI"] message:[NSString stringWithFormat:@"%@%@ %@ app?",[MyClass returntitlewithtitle:@"Are you sure to disable "],deviceobject.stafforstudentname,deviceobject.appname] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [self disableuserappwithstudentkey:nil username:deviceobject.stafforstudentkey appname:deviceobject.appname];
                
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [disablealert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [disablealert addAction:OKAction];
            [disablealert addAction:CancelAction];
            
            [self presentViewController:disablealert animated:YES completion:nil];
        }
    }
}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==staff_groupnametable) {
        if (![self isgroupnamealreadyexistwithgroupname:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupname groupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey]) {
            
            return indexPath;
        }else{
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Group"] message:[MyClass returntitlewithtitle:@"Please use a different group name as it already exists"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [userprivilegeviewcontroller presentViewController:erroralert animated:YES completion:nil];
            return nil;
        }
    }else if (tableView==staff_privilegenametable){
        if (![self isprivilegeusertypealreadyexistwithusertype:((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).usertype privilegekey:((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).privilegekey]) {
            
            return indexPath;
        }else{
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Privilege"] message:[MyClass returntitlewithtitle:@"Please use a different privilege name as it already exists"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [userprivilegeviewcontroller presentViewController:erroralert animated:YES completion:nil];
            return nil;
        }
    }else{
        return indexPath;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (tableView == stafftable){
        //popup instructor record
        
        
        [ailoadindicator startAnimating];
        ailoadindicator.hidden=NO;
        [self adjustpresentingviewwidthwithwidth:380];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            StaffObject=[filteredStaffArray objectAtIndex:indexPath.row];
            
            StaffPopoverViewController *staffpopover = (StaffPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StaffPopoverViewController"];
            staffpopover.delegate=self;
            staffpopover.StaffObject=StaffObject;
            staffpopover.RoleArray=RoleArray;
            staffpopover.PrivilegeArray=localprivilegearray;
            staffpopover.GroupArray=GroupArray;
            staffpopover.StaffTableMode=@"View";
            
            staffpopover.view.frame=self->sidewindowview.bounds;
            [self->sidewindowview addSubview:staffpopover.view];
            [self addChildViewController:staffpopover];
            [staffpopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            self->ailoadindicator.hidden=YES;
        });
        
        
    }else  if (tableView == subjecttable){
        //popup instructor record
        subjectobject=[filteredSubjectArray objectAtIndex:indexPath.row];
        
        [ailoadindicator startAnimating];
        ailoadindicator.hidden=NO;
        [self adjustpresentingviewwidthwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            SubjectPopoverViewController *subjectpopover = (SubjectPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"SubjectPopoverViewController"];
            subjectpopover.delegate=self;
            subjectpopover.subjectobject=subjectobject;
            subjectpopover.SubjectTableMode=@"View";
            subjectpopover.SubjectRecordArray=[MyClass retrievecentersubjectinformationwithstatus:@"All" category:@"All" flushcachedata:NO];
            
            subjectpopover.view.frame=self->sidewindowview.bounds;
            [self->sidewindowview addSubview:subjectpopover.view];
            [self addChildViewController:subjectpopover];
            [subjectpopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            self->ailoadindicator.hidden=YES;
        });

        
    }else if (tableView==producttable){
        productobject=[filteredProductArray objectAtIndex:indexPath.row];

        [ailoadindicator startAnimating];
        ailoadindicator.hidden=NO;
        [self adjustpresentingviewwidthwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ProductPopoverViewController *productpopover = (ProductPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"ProductPopoverViewController"];
            productpopover.delegate=self;
            productpopover.ProductObject=productobject;
            productpopover.ProductTableMode=@"View";
            productpopover.ProductCategoryArray=productcategoryallarray;
            productpopover.ProductCodeArray=/*productcodeallarray*/[self returnallproductcode];

            productpopover.view.frame=self->sidewindowview.bounds;
            [self->sidewindowview addSubview:productpopover.view];
            [self addChildViewController:productpopover];
            [productpopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            self->ailoadindicator.hidden=YES;
        });


    }else if (tableView==subscriptiontable){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            licensetableindexpath=indexPath;
            NSString *appname=((LicenseRecord *)[licenseArray objectAtIndex:indexPath.row]).appname;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self retrievedevicelistwithappname:appname]) {
                    stafforstudentnametitlelabel.text=[appname isEqualToString:@"iParent"]?[MyClass returntitlewithtitle:@"Student Name"]: [MyClass returntitlewithtitle:@"Staff Name"];
                    devicetabletitle.text=[appname isEqualToString:@"iParent"]?[MyClass returntitlewithtitle:@"Student List for iParent Enabled"]:[appname isEqualToString:@"iCenter"]?[MyClass returntitlewithtitle:@"Device List for iCenter"]:[MyClass returntitlewithtitle:@"Device List for iStaff"];
                    devicetable.editing=NO;
                    if (indexPath.row==3) {
                        devicelisteditbutton.hidden=YES;
                        devicenametitlelabel.hidden=YES;
                        lastlogintitlelabel.hidden=YES;
                    }else{
                        devicelisteditbutton.hidden=NO;
                        devicenametitlelabel.hidden=NO;
                        lastlogintitlelabel.hidden=NO;
                    }
                    [devicelisteditbutton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
                }
            });
        });
    
    }else if (tableView==marketingtable){
        if(scmarketingcategory.selectedSegmentIndex==0){
            [ailoadindicator startAnimating];
            ailoadindicator.hidden=NO;
            [self adjustpresentingviewwidthwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MarketingPopoverViewController *mediapopover = (MarketingPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MarketingPopoverViewController"];
                mediapopover.delegate=self;
                mediapopover.MarketingRecordObject=[filteredmarketingmediaArray objectAtIndex:indexPath.row];
                mediapopover.MarketingTableMode=@"View";
                mediapopover.MarketingTableCategory=@"media";
                
                mediapopover.view.frame=self->sidewindowview.bounds;
                [self->sidewindowview addSubview:mediapopover.view];
                [self addChildViewController:mediapopover];
                [mediapopover didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                self->ailoadindicator.hidden=YES;
            });
        }else if (scmarketingcategory.selectedSegmentIndex==1){
            [ailoadindicator startAnimating];
            ailoadindicator.hidden=NO;
            [self adjustpresentingviewwidthwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MarketingPopoverViewController *sourcepopover = (MarketingPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MarketingPopoverViewController"];
                sourcepopover.delegate=self;
                sourcepopover.MarketingRecordObject=[filteredmarketingsourceArray objectAtIndex:indexPath.row];
                sourcepopover.MarketingTableMode=@"View";
                sourcepopover.MarketingTableCategory=@"source";
                
                sourcepopover.view.frame=self->sidewindowview.bounds;
                [self->sidewindowview addSubview:sourcepopover.view];
                [self addChildViewController:sourcepopover];
                [sourcepopover didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                self->ailoadindicator.hidden=YES;
            });
        }else if (scmarketingcategory.selectedSegmentIndex==2){
            [ailoadindicator startAnimating];
            ailoadindicator.hidden=NO;
            [self adjustpresentingviewwidthwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MarketingPopoverViewController *sourcepopover = (MarketingPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MarketingPopoverViewController"];
                sourcepopover.delegate=self;
                sourcepopover.MarketingRecordObject=[filteredmarketingpromotionArray objectAtIndex:indexPath.row];
                sourcepopover.MarketingTableMode=@"View";
                sourcepopover.MarketingTableCategory=@"promotion";
                
                sourcepopover.view.frame=self->sidewindowview.bounds;
                [self->sidewindowview addSubview:sourcepopover.view];
                [self addChildViewController:sourcepopover];
                [sourcepopover didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                self->ailoadindicator.hidden=YES;
            });
        }else if (scmarketingcategory.selectedSegmentIndex==3){
            [ailoadindicator startAnimating];
            ailoadindicator.hidden=NO;
            [self adjustpresentingviewwidthwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MarketingPopoverViewController *sourcepopover = (MarketingPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MarketingPopoverViewController"];
                sourcepopover.delegate=self;
                sourcepopover.MarketingRecordObject=[filteredmarketingcouponArray objectAtIndex:indexPath.row];
                sourcepopover.MarketingTableMode=@"View";
                sourcepopover.MarketingTableCategory=@"coupon";
                
                sourcepopover.view.frame=self->sidewindowview.bounds;
                [self->sidewindowview addSubview:sourcepopover.view];
                [self addChildViewController:sourcepopover];
                [sourcepopover didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                self->ailoadindicator.hidden=YES;
            });
        }
    }else if (tableView == classroomtable){
        //popup instructor record

        [ailoadindicator startAnimating];
        ailoadindicator.hidden=NO;
        [self adjustpresentingviewwidthwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ClassroomPopoverViewController *classroompopover = (ClassroomPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"ClassroomPopoverViewController"];
            classroompopover.delegate=self;
            classroompopover.ClassroomRecordObject=[filteredClassroomArray objectAtIndex:indexPath.row];
            classroompopover.ClassroomTableMode=@"View";
            
            classroompopover.view.frame=self->sidewindowview.bounds;
            [self->sidewindowview addSubview:classroompopover.view];
            [self addChildViewController:classroompopover];
            [classroompopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            self->ailoadindicator.hidden=YES;
        });

        
    }else if (tableView==staff_privilegenametable){
        selectedPrivilegeNameRow=indexPath.row;
        [staff_privilegedetailstable reloadData];
        [staff_privilegedetailstable setContentOffset:CGPointMake(0, 0)];
    }else if (tableView==staff_groupnametable){
        selectedGroupNameRow=indexPath.row;
        [staff_groupdetailstable reloadData];
    }else if (tableView==ri_subjecttable){
        if ([ri_selectedsubjectarray containsObject:((SubjectRecord *)[ri_subjectarray objectAtIndex:indexPath.row]).subject_shortname]) {
            [ri_selectedsubjectarray removeObject:((SubjectRecord *)[ri_subjectarray objectAtIndex:indexPath.row]).subject_shortname];
            ri_totalcount-=[((SubjectRecord *)[ri_subjectarray objectAtIndex:indexPath.row]).studentcapacity intValue];
        }else{
            [ri_selectedsubjectarray addObject:((SubjectRecord *)[ri_subjectarray objectAtIndex:indexPath.row]).subject_shortname];
            ri_totalcount+=[((SubjectRecord *)[ri_subjectarray objectAtIndex:indexPath.row]).studentcapacity intValue];
        }
        [ri_subjecttable reloadData];
    }else if (tableView==ri_calendartable){
        if(selectedperiodbutton==dayoptionbutton){
            if ([selectedDayOptionArray containsObject:[dayOptionArray objectAtIndex:indexPath.row]]) {
                [selectedDayOptionArray removeObject:[dayOptionArray objectAtIndex:indexPath.row]];
            }else{
                [selectedDayOptionArray addObject:[dayOptionArray objectAtIndex:indexPath.row]];
            }
            [self updateDayOptionButtonTitle];
            [ri_calendartable reloadData];
            [self retrievereplaceinstructorsubjectarray];
        }

    }else if (tableView==ri_instructortable){
        if (selectedinstructorbutton==frominstructorbutton) {
            ri_frominstructor=((Instructor *)[ri_filteredinstructorarray objectAtIndex:indexPath.row]).username;
            [frominstructorbutton setTitle:[MyClass returninstructornamewithusername:ri_frominstructor firstorfullname:@"full"] forState:UIControlStateNormal];
            frominstructorbutton.backgroundColor=[UIColor whiteColor];
            [self retrievereplaceinstructorsubjectarray];
        }else{
            ri_toinstructor=((Instructor *)[ri_filteredinstructorarray objectAtIndex:indexPath.row]).username;
            [toinstructorbutton setTitle:[MyClass returninstructornamewithusername:ri_toinstructor firstorfullname:@"full"] forState:UIControlStateNormal];
            toinstructorbutton.backgroundColor=[UIColor whiteColor];
        }
        
        [self closeblockview];
    }else if (tableView==leaveNatureListTable){
        selectedLeaveNatureRow=indexPath.row;
        workingleavenatureobject=[leaveNatureArray objectAtIndex:selectedLeaveNatureRow];
        [leaveNatureListTable reloadData];
        [self loadLeaveNatureConfigView];
    }
}

- (void)selectpolicy:(UISegmentedControl *)sender {
    policy_selectedsegment=sender.selectedSegmentIndex;
    [policytable reloadData];

}


-(BOOL) retrievepolicy
{
    if(scPolicyType.selectedSegmentIndex==0){
        return [self retrieveCenterPolicy];
    }else if (scPolicyType.selectedSegmentIndex==1){
        [tncTable reloadData];
    }else if (scPolicyType.selectedSegmentIndex==2){
        return [self retrieveLeaveNature];
    }
    return YES;
}


-(BOOL) retrieveLeaveNature
{
    leaveNatureArray=[MyClass retrieveLeaveNatureArrayWithFlushCacheData:YES];
    if (selectedLeaveNatureRow>leaveNatureArray.count-1) {
        selectedLeaveNatureRow=0;
    }
    workingleavenatureobject=[leaveNatureArray objectAtIndex:selectedLeaveNatureRow];
    [leaveNatureListTable reloadData];
    [self loadLeaveNatureConfigView];
    [self tableView:leaveNatureListTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedLeaveNatureRow inSection:0]];
    return YES;
}


-(BOOL) retrieveCenterPolicy
{
    
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievepolicy&language=Both",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey];

    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            policycategory=[[NSMutableArray alloc]init];
            policyonecategory=[[NSMutableArray alloc]init];
            policyallcategory=[[NSMutableArray alloc]init];
            NSString *previsoucategorykey=@"";
            
            LanguageTitleRecord *languageobject;
            
            
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                
                //Create our ClassRecord object
                NSString * ccategorykey=[[JSONArray objectAtIndex:i] objectForKey:@"categorykey"];
                NSString * ccategoryenglish=[[JSONArray objectAtIndex:i] objectForKey:@"categoryenglish"];
                NSString * ccategorychinese=[[JSONArray objectAtIndex:i] objectForKey:@"categorychinese"];
                NSString * cheadingenglish=[[JSONArray objectAtIndex:i] objectForKey:@"headingenglish"];
                NSString * cheadingchinese=[[JSONArray objectAtIndex:i] objectForKey:@"headingchinese"];
                NSString * ccontentenglish=[[[JSONArray objectAtIndex:i] objectForKey:@"contentenglish"] stringByReplacingOccurrencesOfString:@"\\n\\n" withString:@"\r\r"];
                NSString * ccontentchinese=[[[JSONArray objectAtIndex:i] objectForKey:@"contentchinese"] stringByReplacingOccurrencesOfString:@"\\n\\n" withString:@"\r\r"];
                
                if (![ccategorykey isEqualToString:previsoucategorykey]) {
                    //[policycategory addObject:ccategory];
                    
                    languageobject=[[LanguageTitleRecord alloc]initLanguageTitleRecordwithCenterkey:nil Title:nil Chinese:ccategorychinese English:ccategoryenglish SChinese:nil];
                    
                    [policycategory addObject:languageobject];
                    
                    
                    //[scpolicy insertSegmentWithTitle:[languageobject valueForKey:policy_languageselected] atIndex:scpolicy.numberOfSegments animated:NO];
                }
                
                if ([ccategorykey isEqualToString:previsoucategorykey] || i==0) {
                    [policyonecategory addObject:[[PolicyRecord alloc]initPolicyRecordwithHeadingEnglish:cheadingenglish HeadingChinese:cheadingchinese ContentEnglish:ccontentenglish ContentChinese:ccontentchinese]];
                    previsoucategorykey=ccategorykey;
                }else{
                    [policyallcategory addObject:policyonecategory];
                    policyonecategory=[[NSMutableArray alloc]init];
                    [policyonecategory addObject:[[PolicyRecord alloc]initPolicyRecordwithHeadingEnglish:cheadingenglish HeadingChinese:cheadingchinese ContentEnglish:ccontentenglish ContentChinese:ccontentchinese]];
                    previsoucategorykey=ccategorykey;
                }
                
                if (i==JSONArray.count-1) {
                    [policyallcategory addObject:policyonecategory];
                }
            }
        }
    }];
    
    
                
    if (result) {

        [scpolicy removeAllSegments];
        for (int i=0; i<policycategory.count; i++) {
            [scpolicy insertSegmentWithTitle:[[policycategory objectAtIndex:i] valueForKey:policy_languageselected] atIndex:scpolicy.numberOfSegments animated:NO];
        }
        
        scpolicy.selectedSegmentIndex=0;
        policy_selectedsegment=0;
        
        if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editcenterpolicy) {
            policy_editbutton.enabled=YES;
        }else{
            policy_editbutton.enabled=NO;
        }
        
        
        [policytable reloadData];
        
        [self loadingindicatorwithoption:@"stop"];
        
        
        return YES;
    }else{
        [self loadingindicatorwithoption:@"stop"];
        //[MyClass showconnectionlostdialogbox];
        return NO;
    }
    
    
}

-(void) loadLeaveNatureConfigView
{
    if([globalvariables.language isEqualToString:@"English"]){
        leaveConfigName1.text=workingleavenatureobject.nature_desc_english;
        leaveConfigName2.text=workingleavenatureobject.nature_desc_chinese;
    }else{
        leaveConfigName1.text=workingleavenatureobject.nature_desc_chinese;
        leaveConfigName2.text=workingleavenatureobject.nature_desc_english;
    }
    
    cbLeaveNatureStudentRequest.on=workingleavenatureobject.is_student_request;
    cbLeaveNature1.on=[self returnLeaveConfigWithButton:cbLeaveNature1];
    cbLeaveNature2.on=[self returnLeaveConfigWithButton:cbLeaveNature2];
    cbLeaveNature3.on=[self returnLeaveConfigWithButton:cbLeaveNature3];
    cbLeaveNature11.on=[self returnLeaveConfigWithButton:cbLeaveNature11];
    cbLeaveNature12.on=[self returnLeaveConfigWithButton:cbLeaveNature12];
    cbLeaveNature13.on=[self returnLeaveConfigWithButton:cbLeaveNature13];
    cbLeaveNature21.on=[self returnLeaveConfigWithButton:cbLeaveNature21];
    cbLeaveNature22.on=[self returnLeaveConfigWithButton:cbLeaveNature22];
    cbLeaveNature23.on=[self returnLeaveConfigWithButton:cbLeaveNature23];
    cbLeaveNature31.on=[self returnLeaveConfigWithButton:cbLeaveNature31];
    cbLeaveNature32.on=[self returnLeaveConfigWithButton:cbLeaveNature32];
    cbLeaveNature33.on=[self returnLeaveConfigWithButton:cbLeaveNature33];
    
    cbLeaveNature21.enabled=!cbLeaveNature21.on;
    cbLeaveNature22.enabled=!cbLeaveNature22.on;
    cbLeaveNature23.enabled=!cbLeaveNature23.on;
    cbLeaveNature31.enabled=!cbLeaveNature31.on;
    cbLeaveNature32.enabled=!cbLeaveNature32.on;
    cbLeaveNature33.enabled=!cbLeaveNature33.on;
    LeaveConfigStudentDefaultStackView.hidden=!workingleavenatureobject.is_student_request;
    leaveConfigRemarks.text=workingleavenatureobject.remarks;
    
    old_nature_name1=leaveConfigName1.text;
    old_nature_name2=leaveConfigName2.text;
    
    
}

-(BOOL) returnLeaveConfigWithButton:(UISwitch *)sender
{
    NSString *attendance;
    if (sender.tag%10==1) {
        attendance=@"Absent";
    }else if (sender.tag%10==2){
        attendance=@"Makeup";
    }else if (sender.tag%10==3){
        attendance=@"Extend";
    }
    
    if (sender.tag/10==0) {
        return ((LeaveNatureConfig *)[workingleavenatureobject.configdict valueForKey:attendance]).count_quota;
    }else if (sender.tag/10==1) {
        return !((LeaveNatureConfig *)[workingleavenatureobject.configdict valueForKey:attendance]).require_approval;
    }else if (sender.tag/10==2) {
        return ((LeaveNatureConfig *)[workingleavenatureobject.configdict valueForKey:attendance]).default_nature_for_staff;
    }else if (sender.tag/10==3) {
        return ((LeaveNatureConfig *)[workingleavenatureobject.configdict valueForKey:attendance]).default_nature_for_student;
    }
    return NO;
}

- (IBAction)checkLeaveNatureStudentRequest:(UISwitch *)sender {
    [self.view endEditing:YES];
    
    if(!sender.on && [MyClass lastLeaveNatureStudentRequest]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Student Request"] message:[MyClass returntitlewithtitle:@"Student request cannot be disabled. At least 1 nature with student request enabled is required"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
        sender.on=TRUE;
    }else{
        workingleavenatureobject.is_student_request=sender.on;
        
        
        [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"is_student_request" Value:sender.on?@"Y":@"N" leavenatureconfigkey:nil reloadArray:YES];
    }
    

}

- (IBAction)textFieldEditingChanged:(UITextField *)sender {
    if(sender==leaveConfigName1){
        if([globalvariables.language isEqualToString:@"English"]){
            workingleavenatureobject.nature_desc_english=sender.text;
            [leaveNatureListTable reloadData];
            [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"nature_desc_english" Value:sender.text leavenatureconfigkey:nil reloadArray:NO];
        }else{
            workingleavenatureobject.nature_desc_chinese=sender.text;
            [leaveNatureListTable reloadData];
            [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"nature_desc_chinese" Value:sender.text leavenatureconfigkey:nil reloadArray:NO];
        }
    }else if (sender==leaveConfigName2){
        if([globalvariables.language isEqualToString:@"English"]){
            workingleavenatureobject.nature_desc_chinese=sender.text;
            [leaveNatureListTable reloadData];
            [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"nature_desc_chinese" Value:sender.text leavenatureconfigkey:nil reloadArray:NO];
        }else{
            workingleavenatureobject.nature_desc_english=sender.text;
            [leaveNatureListTable reloadData];
            [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"nature_desc_english" Value:sender.text leavenatureconfigkey:nil reloadArray:NO];
        }
    }
}

- (IBAction)textFieldEditingDidEnd:(UITextField *)sender {
    if(sender==leaveConfigName1){
        if([sender.text isEqualToString:@""]){
            sender.text=old_nature_name1;
            if([globalvariables.language isEqualToString:@"English"]){
                workingleavenatureobject.nature_desc_english=sender.text;
                [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"nature_desc_english" Value:sender.text leavenatureconfigkey:nil reloadArray:NO];
            }else{
                workingleavenatureobject.nature_desc_chinese=sender.text;
                [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"nature_desc_chinese" Value:sender.text leavenatureconfigkey:nil reloadArray:NO];
            }
        }
    }else if (sender==leaveConfigName2){
        if([sender.text isEqualToString:@""]){
            sender.text=old_nature_name2;
            if([globalvariables.language isEqualToString:@"English"]){
                workingleavenatureobject.nature_desc_chinese=sender.text;
                [leaveNatureListTable reloadData];
                [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"nature_desc_chinese" Value:sender.text leavenatureconfigkey:nil reloadArray:NO];
            }else{
                workingleavenatureobject.nature_desc_english=sender.text;
                [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"nature_desc_english" Value:sender.text leavenatureconfigkey:nil reloadArray:NO];
            }
        }
    }
}


- (IBAction)checkLeaveNatureConfig:(UISwitch *)sender {
    [self.view endEditing:YES];
    
    NSString *attendance;
    if (sender.tag%10==1) {
        attendance=@"Absent";
    }else if (sender.tag%10==2){
        attendance=@"Makeup";
    }else if (sender.tag%10==3){
        attendance=@"Extend";
    }
    
    if (sender.tag/10==0) {
        ((LeaveNatureConfig *)[workingleavenatureobject.configdict valueForKey:attendance]).count_quota=sender.on;
        [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"count_quota" Value:sender.on?@"Y":@"N" leavenatureconfigkey:((LeaveNatureConfig *)[workingleavenatureobject.configdict valueForKey:attendance]).leavenatureconfigkey reloadArray:NO];
    }else if (sender.tag/10==1) {
        ((LeaveNatureConfig *)[workingleavenatureobject.configdict valueForKey:attendance]).require_approval=!sender.on;
        [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"require_approval" Value:!sender.on?@"Y":@"N" leavenatureconfigkey:((LeaveNatureConfig *)[workingleavenatureobject.configdict valueForKey:attendance]).leavenatureconfigkey reloadArray:NO];
    }else if (sender.tag/10==2) {
        ((LeaveNatureConfig *)[workingleavenatureobject.configdict valueForKey:attendance]).default_nature_for_staff=sender.on;
        sender.enabled=NO;
        [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"default_nature_for_staff" Value:sender.on?@"Y":@"N" leavenatureconfigkey:((LeaveNatureConfig *)[workingleavenatureobject.configdict valueForKey:attendance]).leavenatureconfigkey reloadArray:YES];
    }else if (sender.tag/10==3) {
        ((LeaveNatureConfig *)[workingleavenatureobject.configdict valueForKey:attendance]).default_nature_for_student=sender.on;
        sender.enabled=NO;
        [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"default_nature_for_student" Value:sender.on?@"Y":@"N" leavenatureconfigkey:((LeaveNatureConfig *)[workingleavenatureobject.configdict valueForKey:attendance]).leavenatureconfigkey reloadArray:YES];
    }
    
    
    
}


-(void) updateLeaveNatureWithLeaveNatureListKey:(NSString *)leavenaturelistkey Key:(NSString *)key Value:(NSString *)value leavenatureconfigkey:(NSString *)leavenatureconfigkey reloadArray:(BOOL)reloadArray
{
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:@"updateleavenature" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:key forKey:@"key"];
    [dictionary setValue:value forKey:@"value"];
    
    if(leavenatureconfigkey){
        [dictionary setValue:leavenatureconfigkey forKey:@"leavenatureconfigkey"];
    }else{
        [dictionary setValue:leavenaturelistkey forKey:@"leavenaturelistkey"];
    }
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];

    
    if (result) {
        if(reloadArray){
            leaveNatureArray= [MyClass retrieveLeaveNatureArrayWithFlushCacheData:YES];
            workingleavenatureobject=[leaveNatureArray objectAtIndex:selectedLeaveNatureRow];
            [self loadLeaveNatureConfigView];
            //[leaveNatureListTable selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedLeaveNatureRow] byExtendingSelection:NO];
        }
    }
    //});
}


-(BOOL) retrieveStaffListwithflushcachedata:(BOOL)flushcachedata
{
    allStaffArray=[[NSMutableArray alloc] initWithArray:[MyClass retrieveStaffListwithvalid:@"All" role:@"All" flushcachedata:flushcachedata]];
    StaffArray=[[NSMutableArray alloc] initWithArray:[MyClass retrieveStaffListwithvalid:scstaffstatus.selectedSegmentIndex==0 ? @"All": scstaffstatus.selectedSegmentIndex==1 ? @"Yes":@"No" role:[AllRoleArray objectAtIndex:[scstaffrole selectedSegmentIndex]] flushcachedata:NO]];

    [self returnfilterstaffarray];
    
    if (StaffArray) {
        //[stafftable reloadData];
        return YES;
    }else{
        return NO;
    }
    

    
}

-(void) refreshtableheader
{


    
    title_subject_code.text=[MyClass returntitlewithtitle:@"Code"];
    title_subject_englishname.text=[globalvariables.language isEqualToString:@"English"]?[MyClass returntitlewithtitle:@"Subject Name (English)"]:[MyClass returntitlewithtitle:@"Subject Name (Chinese)"];
    title_subject_chinesename.text=[globalvariables.language isEqualToString:@"English"]?[MyClass returntitlewithtitle:@"Subject Name (Chinese)"]:[MyClass returntitlewithtitle:@"Subject Name (English)"];
    
    if(globalvariables.centerrecord.enablemakeupquota){
        title_subject_makeupquota.text=[MyClass returntitlewithtitle:@"Makeup Quota"];
        title_subject_validity.text=globalvariables.centerrecord.enrollmentvalidity?[MyClass returntitlewithtitle:@"Validity"]:@"";
    }else{
        title_subject_validity.text=@"";
        if(globalvariables.centerrecord.enrollmentvalidity){
            title_subject_makeupquota.text=[MyClass returntitlewithtitle:@"Validity"];
        }else{
            title_subject_makeupquota.text=@"";
        }
    }

    
    title_subject_status.text=[MyClass returntitlewithtitle:@"Status"];
    title_subject_capacity.text=[MyClass returntitlewithtitle:@"Max. Class Size"];
    title_subject_tuitionby.text=[MyClass returntitlewithtitle:@"Tuition By"];
    title_subject_tuitionmode.text=[MyClass returntitlewithtitle:@"Tuition Mode"];
    title_subject_standardperiod.text=[MyClass returntitlewithtitle:@"Standard Period"];
    title_subject_duration.text=[MyClass returntitlewithtitle:@"Duration(S/A/T)"];
    title_subject_schedule.text=[MyClass returntitlewithtitle:@"Course Schedule"];
    title_subject_level.text=[MyClass returntitlewithtitle:@"Level"];
    title_subject_tuitionfee.text=[MyClass returntitlewithtitle:@"Tuition Fee (Per class/month)"];
    
    title_subject_remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    
    title_staff_name.text=[MyClass returntitlewithtitle:@"Name"];
    title_staff_teaching.text=[MyClass returntitlewithtitle:@"Teaching"];
    title_staff_status.text=[MyClass returntitlewithtitle:@"Status"];
    title_staff_username.text=[MyClass returntitlewithtitle:@"Username/Email"];
    title_staff_group.text=[MyClass returntitlewithtitle:@"Group"];
    title_staff_privilege.text=[MyClass returntitlewithtitle:@"Privilege"];
    title_staff_phone.text=[MyClass returntitlewithtitle:@"Phone"];
    title_staff_istaff.text=[MyClass returntitlewithtitle:@"iStaff"];
    title_staff_icenter.text=[MyClass returntitlewithtitle:@"iCenter"];
    title_staff_bi.text=[MyClass returntitlewithtitle:@"BI Report"];
    title_staff_mon.text=[MyClass returntitlewithtitle:@"Mon"];
    title_staff_tue.text=[MyClass returntitlewithtitle:@"Tue"];
    title_staff_wed.text=[MyClass returntitlewithtitle:@"Wed"];
    title_staff_thu.text=[MyClass returntitlewithtitle:@"Thu"];
    title_staff_fri.text=[MyClass returntitlewithtitle:@"Fri"];
    title_staff_sat.text=[MyClass returntitlewithtitle:@"Sat"];
    title_staff_sun.text=[MyClass returntitlewithtitle:@"Sun"];
    title_staff_instructoravailability.text=[MyClass returntitlewithtitle:@"Staff Schedule"];
    title_staff_confirmmakeuprequest.text=[globalvariables.centerrecord.iparentleavemode isEqualToString:@"Request"]?[MyClass returntitlewithtitle:@"Confirm Makeup"]:@"";
    title_staff_salaryrate.text=showSalaryrate?[MyClass returntitlewithtitle:@"Salary Rate"]:@"";
    title_staff_remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    
    title_room_classroom.text=[MyClass returntitlewithtitle:@"Classroom"];
    title_room_status.text=[MyClass returntitlewithtitle:@"Status"];
    title_room_remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    title_room_capacity.text=[MyClass returntitlewithtitle:@"Capacity"];
    title_room_roomcolor.text=[MyClass returntitlewithtitle:@"Room Color"];
    

    title_product_category.text=[MyClass returntitlewithtitle:@"Category"];
    title_product_englishname.text=[MyClass returntitlewithtitle:@"Product Name (English)"];
    title_product_chinesename.text=[MyClass returntitlewithtitle:@"Product Name (Chinese)"];
    title_product_code.text=[MyClass returntitlewithtitle:@"Code"];
    title_product_status.text=[MyClass returntitlewithtitle:@"Status"];
    title_product_price.text=[MyClass returntitlewithtitle:@"Price"];
    title_product_remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    title_product_autorenew.text=[MyClass returntitlewithtitle:@"Product Auto Renew"];
    title_product_stockcount.text=[MyClass returntitlewithtitle:@"Stock Count"];
    title_product_alertthreshold.text=[MyClass returntitlewithtitle:@"Alert Threshold"];
    title_product_yetgiven.text=[MyClass returntitlewithtitle:@"Yet Given"];

    
    title_marketing_code.text=[MyClass returntitlewithtitle:@"Code"];
    if(scmarketingcategory.selectedSegmentIndex==0){
        title_marketing_description.text=[MyClass returntitlewithtitle:@"Media Description"];
    }else if (scmarketingcategory.selectedSegmentIndex==1){
        title_marketing_description.text=[MyClass returntitlewithtitle:@"Source Description"];
    }else if (scmarketingcategory.selectedSegmentIndex==2){
        title_marketing_description.text=[MyClass returntitlewithtitle:@"Promotion Description"];
    }else{
        title_marketing_description.text=[MyClass returntitlewithtitle:@"Coupon Description"];
    }
    
    title_marketing_discount.text=[MyClass returntitlewithtitle:@"Discount"];
    title_marketing_validityfrom.text=scmarketingcategory.selectedSegmentIndex<=2?[MyClass returntitlewithtitle:@"marketing_Available From/To"]:[MyClass returntitlewithtitle:@"coupon_Available From/To"];
    title_marketing_validityto.text=[MyClass returntitlewithtitle:@"Valid From/To"];
    title_marketing_remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    title_marketing_quota.text=[NSString stringWithFormat:@"%@(%@)",[MyClass returntitlewithtitle:@"Used Count"],[MyClass returntitlewithtitle:@"Quota"]];
}

-(void) createtableheader
{
    addStaffButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).addstaff;
 
    [addSubjectButton addTarget:self action:@selector(addSubject:) forControlEvents:UIControlEventTouchUpInside];
    addSubjectButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).addsubject;
    

    [addClassRoomButton addTarget:self action:@selector(addclassroom:) forControlEvents:UIControlEventTouchUpInside];
    addClassRoomButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).addclassroom;

    [addProductButton setTintColor:[UIColor whiteColor]];
    [addProductButton addTarget:self action:@selector(addProduct:) forControlEvents:UIControlEventTouchUpInside];
    addProductButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).addproduct;

    [addMarketingButton addTarget:self action:@selector(addmarketing:) forControlEvents:UIControlEventTouchUpInside];
    addMarketingButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).addmarketing;

    
}

- (void)addStaff:(UIButton *)sender {
    
    [ailoadindicator startAnimating];
    ailoadindicator.hidden=NO;
    [self adjustpresentingviewwidthwithwidth:380];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        StaffPopoverViewController *staffpopover = (StaffPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StaffPopoverViewController"];
        staffpopover.delegate=self;
        staffpopover.StaffTableMode=@"Add";
        staffpopover.RoleArray=RoleArray;
        staffpopover.PrivilegeArray=localprivilegearray;
        staffpopover.GroupArray=GroupArray;
        
        staffpopover.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:staffpopover.view];
        [self addChildViewController:staffpopover];
        [staffpopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });

}

- (void)addSubject:(UIButton *)sender {
    
    [ailoadindicator startAnimating];
    ailoadindicator.hidden=NO;
    [self adjustpresentingviewwidthwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SubjectPopoverViewController *subjectpopover = (SubjectPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"SubjectPopoverViewController"];
        subjectpopover.delegate=self;
        subjectpopover.SubjectTableMode=@"Add";
        subjectpopover.SubjectRecordArray=[MyClass retrievecentersubjectinformationwithstatus:@"All" category:@"All" flushcachedata:NO];
        
        subjectpopover.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:subjectpopover.view];
        [self addChildViewController:subjectpopover];
        [subjectpopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });

}

-(void) addProduct:(UIButton *)sender
{
    
    [ailoadindicator startAnimating];
    ailoadindicator.hidden=NO;
    [self adjustpresentingviewwidthwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ProductPopoverViewController *productpopover = (ProductPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"ProductPopoverViewController"];
        productpopover.delegate=self;
        productpopover.ProductTableMode=@"Add";
        productpopover.ProductCategoryArray=productcategoryallarray;
        productpopover.ProductCodeArray=/*productcodeallarray*/[self returnallproductcode];
        
        productpopover.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:productpopover.view];
        [self addChildViewController:productpopover];
        [productpopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });

}

-(void) dismissStaffPopoverWithLogoutOption:(BOOL)option
{
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self closesidewindow];
    if (option) {
        //go to login screen
        //remove token and device from user_token and user_device

        if ([MyClass removeUserTokenDeviceWithUserDeviceKey:globalvariables.userdevicekey]) {
            
            [MyClass logoutUser];

        }
    }else{
        [self retrieveStaffListwithflushcachedata:YES];
        [self retrieveGroup];
        [self retrievePrivilege];
    }
}

-(void) returnSelectedSaleskeysForYetGivenOutOrder:(NSMutableArray *)saleskeys
{
    [self closesidewindow];
    if(saleskeys.count>0){
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateyetgivenoutorderwithsaleskeys:saleskeys];
            [self retrieveProductListwithresetcategoryfilter:YES flushcachedata:YES];
            [producttable reloadData];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }
}

-(void) updateyetgivenoutorderwithsaleskeys:(NSMutableArray *)saleskeys
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updateyetgivenoutsalesorders&saleskeys=%@&updatedby=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,[saleskeys componentsJoinedByString:@","],globalvariables.username];
    
    __block BOOL result=FALSE;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if(result){
        [self getyetgivenproduct];
    }
}

-(void) dismissSubjectPopover
{
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self closesidewindow];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        subjectcategoryarray=[MyClass retrievesubjectcategorywithflushcachedata:YES];
        [subjectcategoryarray insertObject:[[SubjectCategoryRecord alloc]initSubjectCategoryRecordwithCenterkey:nil SCategoryKey:@"All" Englishname:@"All Categories" Chinesename:@"All Categories" colorcode:0 bundleforapppayment:NO] atIndex:0];
        
        subjectArray=[MyClass retrievecentersubjectinformationwithstatus:[subjectstatusarray objectAtIndex:scsubjectstatus.selectedSegmentIndex] category:subjectcategoryselected flushcachedata:NO];
        [self returnfiltersubjectarray];
        /*if (subjectArray) {
            [subjecttable reloadData];
        }*/
    });
}


-(void) dismissProductPopover
{
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self closesidewindow];
    [self retrieveProductListwithresetcategoryfilter:NO flushcachedata:YES];
}


-(void) drawsubscriptiontableheader
{
    //license table
    appnamelabel.text=[MyClass returntitlewithtitle:@"App Name"];
    licensedcountlabel.text=[MyClass returntitlewithtitle:@"Licensed"];
    usedcountlabel.text=[MyClass returntitlewithtitle:@"Used"];


    
    
    //device list
    UIView *devicetableheaderview=[[UIView alloc]initWithFrame:CGRectMake(subscriptiontable.frame.origin.x+subscriptiontable.frame.size.width, 25, devicetable.frame.size.width, 40)];
    devicetableheaderview.backgroundColor=[UIColor grayColor];
    deviceTableHeaderView=devicetableheaderview;
    [subscriptionview addSubview:devicetableheaderview];
    
    
    stafforstudentnametitlelabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 150, 40)];
    stafforstudentnametitlelabel.textColor=[UIColor whiteColor];
    stafforstudentnametitlelabel.font=[UIFont systemFontOfSize:15];
    stafforstudentnametitlelabel.textAlignment=NSTextAlignmentLeft;
    stafforstudentnametitlelabel.text=[MyClass returntitlewithtitle:@"Staff Name"];
    [devicetableheaderview addSubview:stafforstudentnametitlelabel];
    
    devicenametitlelabel=[[UILabel alloc]initWithFrame:CGRectMake(255, 0, 150, 40)];
    devicenametitlelabel.textColor=[UIColor whiteColor];
    devicenametitlelabel.font=[UIFont systemFontOfSize:15];
    devicenametitlelabel.text=[MyClass returntitlewithtitle:@"Device Name"];
    [devicetableheaderview addSubview:devicenametitlelabel];
    

    lastlogintitlelabel=[[UILabel alloc]initWithFrame:CGRectMake(470, 0, 150, 40)];
    lastlogintitlelabel.textColor=[UIColor whiteColor];
    lastlogintitlelabel.font=[UIFont systemFontOfSize:15];
    lastlogintitlelabel.text=[MyClass returntitlewithtitle:@"Last Log on"];
    [devicetableheaderview addSubview:lastlogintitlelabel];
    
    
    devicelisteditbutton=[[UIButton alloc]initWithFrame:CGRectMake(subscriptionview.frame.size.width-100-40, devicetable.frame.origin.y+devicetable.frame.size.height, 100, 40)];
    [devicelisteditbutton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
    devicelisteditbutton.titleLabel.font=[UIFont systemFontOfSize:16];
    devicelisteditbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [devicelisteditbutton addTarget:self action:@selector(editbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [devicelisteditbutton setTitleColor:[UIColor systemGroupedBackgroundColor] forState:UIControlStateNormal];
    [subscriptionview addSubview:devicelisteditbutton];
    
    devicecountlabel=[[UILabel alloc]initWithFrame:CGRectMake(subscriptiontable.frame.size.width+subscriptiontable.frame.origin.x+15, devicetable.frame.origin.y+devicetable.frame.size.height, 300, 40)];
    devicecountlabel.textColor=[UIColor whiteColor];
    devicecountlabel.font=[UIFont systemFontOfSize:15];
    [subscriptionview addSubview:devicecountlabel];
    
    
}


-(void)editbuttonpressed:(UIButton *)sender
{
    devicetable.editing=[sender.titleLabel.text isEqualToString:[MyClass returntitlewithtitle:@"Edit"]]? YES:NO;
    [devicelisteditbutton setTitle:[sender.titleLabel.text isEqualToString:[MyClass returntitlewithtitle:@"Edit"]]? [MyClass returntitlewithtitle:@"Done"]:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
}

-(BOOL) retrievesubscriptionplan
{

    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievesubscriptiondetails&entitykey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,globalvariables.centerrecord.entitykey];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            licenseArray=[[NSMutableArray alloc]init];
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            for (long i=0; i<JSONArray.count; i++) {
                
                NSString *appname=[[JSONArray objectAtIndex:i] objectForKey:@"appname"];
                NSString *licensecount=[[JSONArray objectAtIndex:i] objectForKey:@"LicensedCount"];
                NSString *usedcount=[[JSONArray objectAtIndex:i] objectForKey:@"UsedCount"];
                NSString *remainingcount=[licensecount isEqualToString:@"Unlimited"]?[MyClass returntitlewithtitle:@"Unlimited"]:[NSString stringWithFormat:@"%d",[licensecount intValue]-[usedcount intValue]];
                [licenseArray addObject:[[LicenseRecord alloc]initLicenseRecordWithappname:appname licensecount:licensecount usedcount:usedcount remainingcont:remainingcount]];
                
            }
        }
    }];
            
    if (result) {
        [subscriptiontable reloadData];
        [subscriptiontable selectRowAtIndexPath:licensetableindexpath animated:NO scrollPosition:UITableViewScrollPositionNone];
        return YES;
    }else{
        //[MyClass showconnectionlostdialogbox];
        return NO;
    }
}

-(BOOL) retrievedevicelistwithappname:(NSString *)appname
{
    
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievedevicelist&appname=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,appname];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            deviceArray=[[NSMutableArray alloc]init];
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            for (long i=0; i<JSONArray.count; i++) {
                
                NSString *userdevicekey=[[JSONArray objectAtIndex:i] objectForKey:@"userdevicekey"];
                NSString *contact=[[JSONArray objectAtIndex:i] objectForKey:@"contact"];
                NSString *relationship=[[JSONArray objectAtIndex:i] objectForKey:@"relationship"];
                NSString *deviceidentifier=[[JSONArray objectAtIndex:i] objectForKey:@"deviceidentifier"];
                NSString *devicename=[[JSONArray objectAtIndex:i] objectForKey:@"devicename"];
                NSString *deviceos=[[JSONArray objectAtIndex:i] objectForKey:@"deviceos"];
                NSString *deviceversion=[[JSONArray objectAtIndex:i] objectForKey:@"deviceversion"];
                NSString *lastlogin=[[JSONArray objectAtIndex:i] objectForKey:@"lastlogin"];
                NSString *stafforstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"stafforstudentkey"];
                NSString *usertokenkey=[[JSONArray objectAtIndex:i] objectForKey:@"usertokenkey"];
                
                NSString *staffofstudentname;
                if ([appname isEqualToString:@"iParent"]) {
                    staffofstudentname=[MyClass returnStudentnameWithStudentkey:stafforstudentkey option:@"full"];
                }else{
                    staffofstudentname=[MyClass returnstaffnamewithusername:stafforstudentkey firstorfullname:@"full"];
                }
                
                
                [deviceArray addObject:[[DeviceRecord alloc]initDeviceRecordWithuserdevicekey:userdevicekey stafforstudentname:staffofstudentname deviceidentifier:deviceidentifier devicename:devicename deviceos:deviceos deviceversion:deviceversion lastlogin:lastlogin stafforstudentkey:stafforstudentkey appname:appname usertokenkey:usertokenkey contact:contact relationship:relationship]];
            }
            
            //sort
            NSSortDescriptor *sortbyname = [NSSortDescriptor sortDescriptorWithKey:@"stafforstudentname" ascending:YES selector:@selector(localizedStandardCompare:)];
            NSSortDescriptor *sortbydevicename = [NSSortDescriptor sortDescriptorWithKey:@"devicename" ascending:YES selector:@selector(localizedStandardCompare:)];
            NSArray *sortDescriptors = @[sortbyname,sortbydevicename];
            deviceArray = [NSMutableArray arrayWithArray:[deviceArray sortedArrayUsingDescriptors:sortDescriptors]];
        }
    }];

    if (result) {
        [devicetable reloadData];
        devicecountlabel.text=[NSString stringWithFormat:@"%@: %lu",[MyClass returntitlewithtitle:@"Used in this center"],(unsigned long)deviceArray.count];
        return YES;
    }else{
        //[MyClass showconnectionlostdialogbox];
        return NO;
    }

}

-(void) addAppLicense:(UIButton *)button
{
    NSString *appname;
    NSString *appdetails;
    if(button.tag==0){
        appname=@"iCenter";
        appdetails=@"1 iCenter";
    }else if (button.tag==1){
        appname=@"iStaff";
        appdetails=@"1 iStaff";
    }else if (button.tag==2){
        appname=@"iParent";
        appdetails=@"10 iParent";
    }else{
        appname=@"BI";
        appdetails=@"1 BI";
    }
    
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getlicensecharge&appname=%@&option=Add",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,appname];
    
    __block BOOL result=FALSE;
    __block NSString *charge;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            charge = jsonreturned[@"content"];
        }
    }];
    
    if (result) {
        NSString *message=[MyClass returnreplacedtitlewithtitle:[appname isEqualToString:@"iParent"]?@"Are you sure to add %@1 licenses?":@"Are you sure to add %@1 license?" replacementarray:@[appdetails]];
        if(![charge isEqualToString:@""]){
            message=[NSString stringWithFormat:@"%@ %@",message,[MyClass returnreplacedtitlewithtitle:@"The additional monthly charge is $%@1" replacementarray:@[charge]]];
        }
        
        UIAlertController *licensealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"License"] message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=addlicense&appname=%@&username=%@&option=Add",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,appname,globalvariables.username];
                
                __block BOOL result=FALSE;

                [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
                    if (succeeded) {
                        result=TRUE;
                    }
                }];
                
                if (result) {
                    [self retrievesubscriptionplan];
                }
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }];
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [licensealert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [licensealert addAction:OKAction];
        [licensealert addAction:CancelAction];
        
        [self presentViewController:licensealert animated:YES completion:nil];

    }
}

-(void) removeAppLicense:(UIButton *)button
{
    NSString *appname;
    NSString *appdetails;
    if(button.tag==0){
        appname=@"iCenter";
        appdetails=@"1 iCenter";
    }else if (button.tag==1){
        appname=@"iStaff";
        appdetails=@"1 iStaff";
    }else if (button.tag==2){
        appname=@"iParent";
        appdetails=@"10 iParent";
    }else{
        appname=@"BI";
        appdetails=@"1 BI";
    }
    
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getlicensecharge&appname=%@&option=Reduce",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,appname];
    
    __block BOOL result=FALSE;
    __block NSString *charge;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            charge = jsonreturned[@"content"];
        }
    }];
    
    if (result) {
        if(![MyClass checkValidInput:charge Type:@"EmptyInteger"]){
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            
            UIAlertController *licensealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"License"] message:[MyClass returntitlewithtitle:charge] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [licensealert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [licensealert addAction:OKAction];
            
            [self presentViewController:licensealert animated:YES completion:nil];
        }else{
            NSString *message=[MyClass returnreplacedtitlewithtitle:[appname isEqualToString:@"iParent"]?@"Are you sure to remove %@1 licenses?":@"Are you sure to remove %@1 license?" replacementarray:@[appdetails]];
            if(![charge isEqualToString:@""]){
                message=[NSString stringWithFormat:@"%@ %@",message,[MyClass returnreplacedtitlewithtitle:@"The monthly charge will be reduced by $%@1" replacementarray:@[charge]]];
            }
            
            UIAlertController *licensealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"License"] message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=addlicense&appname=%@&username=%@&option=Reduce",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,appname,globalvariables.username];
                    
                    __block BOOL result=FALSE;

                    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
                        if (succeeded) {
                            result=TRUE;
                        }
                    }];
                    
                    if (result) {
                        [self retrievesubscriptionplan];
                    }
                    [MyClass loadingindicatorwithoption:@"stop" color:nil];
                });
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [licensealert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [licensealert addAction:OKAction];
            [licensealert addAction:CancelAction];
            
            [self presentViewController:licensealert animated:YES completion:nil];
        }
    }
}

-(BOOL) retrieveGroup
{
    GroupArray=[MyClass returnStaffGroupArrayIncludeAll:YES];
    [self showprivilagegroupbutton];
    
    return GroupArray?YES:NO;
}


-(BOOL) retrievePrivilege
{
    localprivilegearray=[MyClass retrieveprivilegewithflushcachedata:YES];
    //scstaffrole.selectedSegmentIndex = 0;
    //laststaffroleindex=0;
    [self showprivilagegroupbutton];
    
    return localprivilegearray?YES:NO;
}

-(void) changestafffilter:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self retrieveStaffListwithflushcachedata:YES]) {
            laststaffstatusindex=scstaffstatus.selectedSegmentIndex;
            laststaffroleindex=scstaffstatus.selectedSegmentIndex;
        }else{
            scstaffstatus.selectedSegmentIndex=laststaffstatusindex;
            scstaffrole.selectedSegmentIndex=laststaffroleindex;
        }
    });
}

-(void) changeproductfilter:(id)sender
{
    //productcategoryarray=[[NSMutableArray alloc]initWithObjects:@"All Categories", nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self retrieveProductListwithresetcategoryfilter:YES flushcachedata:YES]) {
            lastproductstatusindex=scproductstatus.selectedSegmentIndex;
            [ProductCategorySelectionButton setTitle:[productcategoryarray objectAtIndex:0] forState:UIControlStateNormal];
        }else{
            scproductstatus.selectedSegmentIndex=lastproductstatusindex;
        }
    });
}

-(void) changesubjectfilter:(id)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        subjectArray=[MyClass retrievecentersubjectinformationwithstatus:[subjectstatusarray objectAtIndex:scsubjectstatus.selectedSegmentIndex] category:subjectcategoryselected flushcachedata:YES];
        subjectcategoryarray=[MyClass retrievesubjectcategorywithflushcachedata:NO];
        [subjectcategoryarray insertObject:[[SubjectCategoryRecord alloc]initSubjectCategoryRecordwithCenterkey:nil SCategoryKey:@"All" Englishname:@"All Categories" Chinesename:@"All Categories" colorcode:0 bundleforapppayment:NO] atIndex:0];
        [self returnfiltersubjectarray];
        if (subjectArray) {
            //[subjecttable reloadData];
            lastsubjectfilterindex=scsubjectstatus.selectedSegmentIndex;
        }else{
            scsubjectstatus.selectedSegmentIndex=lastsubjectfilterindex;
        }
    });
}


-(NSString *)returnlevelstring:(NSMutableArray *)levelarray
{
    if (levelarray) {
        NSString *levelstring=@"";
        
        for (int l=0; l<levelarray.count; l++) {
            if (l==0) {
                levelstring=((LevelRecord *)[levelarray objectAtIndex:l]).level;
            }else{
                levelstring=[self returnnewlevelgradewithvalueminus1:((LevelRecord *)[levelarray objectAtIndex:l-1]).level valueminus0:((LevelRecord *)[levelarray objectAtIndex:l]).level fullstring:levelstring mode:@"Level"];
            }
        }
        return levelstring;
    }else{
        return [MyClass returntitlewithtitle:@"None"];
    }
}


-(NSString *)returntuitionstring:(NSMutableArray *)tuitionarray
{
    NSString *tuitionfeestring=@"";
    BOOL differenttuitionfee=FALSE;
    if (tuitionarray) {
        //sort array
        NSSortDescriptor *sortByTuitionFee = [NSSortDescriptor sortDescriptorWithKey:@"tuitionfee" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSSortDescriptor *sortByScale = [NSSortDescriptor sortDescriptorWithKey:@"scale" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = @[sortByTuitionFee, sortByScale];
        tuitionarray = [NSMutableArray arrayWithArray:[tuitionarray sortedArrayUsingDescriptors:sortDescriptors]];
        
        
        
        
        
        TuitionRecord *tuitionobject=[[TuitionRecord alloc]init];
        TuitionRecord *tuitionobjectminus1=[[TuitionRecord alloc]init];
        
        for (int t=0; t<tuitionarray.count; t++) {
            tuitionobject=[tuitionarray objectAtIndex:t];
            if (t>0) {
                
                tuitionobjectminus1=[tuitionarray objectAtIndex:t-1];
            }
            
            if (t==0) {
                if (tuitionarray.count==1) {
                    tuitionfeestring=[NSString stringWithFormat:@"$%@",tuitionobject.tuitionfee];
                }else{
                    tuitionfeestring=[NSString stringWithFormat:@"$%@ (%@",tuitionobject.tuitionfee, tuitionobject.scale];
                }
            }else{
                if ([tuitionobject.tuitionfee isEqualToString:tuitionobjectminus1.tuitionfee]) {
                    tuitionfeestring=[self returnnewlevelgradewithvalueminus1:tuitionobjectminus1.scale valueminus0:tuitionobject.scale fullstring:tuitionfeestring mode:@"Tuition"];
                }else{
                    differenttuitionfee=TRUE;
                    tuitionfeestring=[NSString stringWithFormat:@"%@) / $%@ (%@",tuitionfeestring, tuitionobject.tuitionfee, tuitionobject.scale];
                }
                
                if (t==tuitionarray.count-1) {
                    tuitionfeestring=[NSString stringWithFormat:@"%@)",tuitionfeestring];
                }
            }
        }
        if (!differenttuitionfee) {
            tuitionfeestring=[NSString stringWithFormat:@"$%@",tuitionobject.tuitionfee];
        }
    }
    return tuitionfeestring;
}

-(NSString *) returnnewlevelgradewithvalueminus1:(NSString *)valueminus1 valueminus0:(NSString *)valueminus0 fullstring:(NSString *)fullstring mode:(NSString *)mode
{
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet;
    
    NSString *valueminus1front;
    NSString *valueminus1back;
    
    NSString *valueminus0front;
    NSString *valueminus0back;
    
    NSRange range;
    
    long i;

    
    for (i=[valueminus1 length]-1; i>=0; i--) {
        myStringSet = [NSCharacterSet characterSetWithCharactersInString:[valueminus1 substringWithRange:NSMakeRange(i, 1)]];
        if (![_NumericOnly isSupersetOfSet: myStringSet]) {
            if (i==-1) {
                valueminus1front=@"";
                valueminus1back=valueminus1;
            }else if (i==[valueminus1 length]-1){
                valueminus1front=valueminus1;
                valueminus1back=@"";
            }else{
                valueminus1front=[valueminus1 substringToIndex:i+1];
                valueminus1back=[valueminus1 substringFromIndex:i+1];
            }
            break;
        }
    }
    
    if (i==-1) {
        valueminus1front=@"";
        valueminus1back=valueminus1;
    }
    

    for (i=[valueminus0 length]-1; i>=0; i--) {
        myStringSet = [NSCharacterSet characterSetWithCharactersInString:[valueminus0 substringWithRange:NSMakeRange(i, 1)]];
        if (![_NumericOnly isSupersetOfSet: myStringSet]) {
            if (i==-1) {
                valueminus0front=@"";
                valueminus0back=valueminus0;
            }else if (i==[valueminus0 length]-1){
                valueminus0front=valueminus0;
                valueminus0back=@"";
            }else{
                valueminus0front=[valueminus0 substringToIndex:i+1];
                valueminus0back=[valueminus0 substringFromIndex:i+1];
            }
            break;
        }
    }
    
    if (i==-1) {
        valueminus0front=@"";
        valueminus0back=valueminus0;
    }
    
    if ([valueminus0front isEqualToString:valueminus1front]) {
        if ([valueminus1back intValue]+1 == [valueminus0back intValue]) {
            
            if ([mode isEqualToString:@"Level"]) {
                NSRange searchrange=[fullstring rangeOfString:@"," options:NSBackwardsSearch];
                if (searchrange.location == NSNotFound) {
                    range=[fullstring rangeOfString:[NSString stringWithFormat:@"-%@",valueminus1back] options:NSBackwardsSearch];
                    
                    if (range.location!=NSNotFound) {
                        return [NSString stringWithFormat:@"%@-%@",[fullstring substringToIndex:range.location],valueminus0back];
                    }else{
                        return [NSString stringWithFormat:@"%@-%@",fullstring,valueminus0back];
                    }
                }else{
                    range=[fullstring rangeOfString:[NSString stringWithFormat:@"-%@",valueminus1back] options:NSBackwardsSearch range:NSMakeRange(searchrange.location,[fullstring length]-searchrange.location)];
                    
                    if (range.location!=NSNotFound) {
                        return [NSString stringWithFormat:@"%@-%@",[fullstring substringToIndex:range.location],valueminus0back];
                    }else{
                        return [NSString stringWithFormat:@"%@-%@",fullstring,valueminus0back];
                    }
                }
            }else{
                NSRange searchrange=[fullstring rangeOfString:@"(" options:NSBackwardsSearch];

                    range=[fullstring rangeOfString:[NSString stringWithFormat:@"-%@",valueminus1back] options:NSBackwardsSearch range:NSMakeRange(searchrange.location,[fullstring length]-searchrange.location)];
                    
                    if (range.location!=NSNotFound) {
                        return [NSString stringWithFormat:@"%@-%@",[fullstring substringToIndex:range.location],valueminus0back];
                    }else{
                        return [NSString stringWithFormat:@"%@-%@",fullstring,valueminus0back];
                    }
                
            }

        }else{
            return [NSString stringWithFormat:@"%@,%@",fullstring,valueminus0];
        }
    }else{
        return [NSString stringWithFormat:@"%@,%@",fullstring,valueminus0];
    }
}

-(void) retrievecenterimages
{
    if (lastviewindex==0) {
        if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editcenterinformation) {
            centerinfo_editbutton.hidden=NO;
        }else{
            centerinfo_editbutton.hidden=YES;
        }
    }else{
        centerinfo_editbutton.hidden=YES;
    }
    
    if (selectedMainImage==0) {
         [MyClass downloadImageWithImageview:mainimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.shopfrontimage image:@"Yes" async:YES];
    }/*else if (selectedMainImage==1){
         [MyClass downloadImageWithImageview:mainimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.mapimage image:@"Yes" async:YES];
    }*/else if (selectedMainImage==2){
        [MyClass downloadImageWithImageview:mainimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_landscape image:@"Yes" async:YES];
    }else if (selectedMainImage==3){
        [MyClass downloadImageWithImageview:mainimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_portrait image:@"Yes" async:YES];
    }
    
    [MyClass downloadImageWithImageview:shopfrontimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.shopfrontimage image:@"Yes" async:YES];
//    [MyClass downloadImageWithImageview:mapimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.mapimage image:@"Yes" async:YES];
    [MyClass downloadImageWithImageview:launchimage_landscape gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_landscape image:@"Yes" async:YES];
    [MyClass downloadImageWithImageview:launchimage_portrait gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_portrait image:@"Yes" async:YES];
    
    [self highlightmainimage];
    
    mainimage.backgroundColor=[UIColor colorWithRed:211.0/255.0 green:211.0/255.0 blue:211.0/255.0 alpha:1];
    [self loadingindicatorwithoption:@"stop"];


    
}

/*
- (void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, NSData *data))completionBlock
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (!error) {
            completionBlock(YES, data);
        } else {
            completionBlock(NO, nil);
        }
    }];
}*/

-(NSMutableArray *) returnallproductcode
{
    NSString *scode;
    [productcodeallarray removeAllObjects];
    NSMutableArray *allproducts=[MyClass retrieveproductinformationwithcategory:@"All" status:@"All" flushcachedata:NO];
    for (int i=0;i<allproducts.count;i++){
        scode=((ProductRecord *)[allproducts objectAtIndex:i]).code;
        if (![productcodeallarray containsObject:scode]) {
            [productcodeallarray addObject:scode];
        }
    }
    return productcodeallarray;
}

-(BOOL) retrieveProductListwithresetcategoryfilter:(BOOL)reset flushcachedata:(BOOL)flushcachedata
{
    NSString *scategory;
    NSString *scode;
    
    if (reset) {
        ProductArray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveproductinformationwithcategory:@"All" status:[productstatusarray objectAtIndex:scproductstatus.selectedSegmentIndex] flushcachedata:flushcachedata]];
        [self returnfilterproductarray];
        productcategoryarray=[[NSMutableArray alloc]initWithObjects:[MyClass returntitlewithtitle:@"All Categories"], nil];
        productcategoryselected=@"All";
        //[productcategoryarray removeAllObjects];
        [productcategoryallarray removeAllObjects];
//        [productcodeallarray removeAllObjects];
    }else{
        ProductArray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveproductinformationwithcategory:productcategoryselected status:[productstatusarray objectAtIndex:scproductstatus.selectedSegmentIndex] flushcachedata:YES]];
        [self returnfilterproductarray];
    }
    
    if (ProductArray){
        
        for (int i=0; i<ProductArray.count; i++) {
            scategory=((ProductRecord *)[ProductArray objectAtIndex:i]).category;
            scode=((ProductRecord *)[ProductArray objectAtIndex:i]).code;
            
            if (![productcategoryarray containsObject:scategory]) {
                [productcategoryarray addObject:scategory];
            }
            
//            if (![productcodeallarray containsObject:scode]) {
//                [productcodeallarray addObject:scode];
//            }
            
            if (![productcategoryallarray containsObject:scategory]) {
                [productcategoryallarray addObject:scategory];
            }
        }
        //[producttable reloadData];
        
        
        return YES;
        
    }else{
        [MyClass showconnectionlostdialogbox];
        return NO;
    }

    
}

-(void) drawpointerwithoption:(NSString *)option button:(UIButton *)button
{
    for (CALayer *layer in button.layer.sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
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
    
    CAShapeLayer *cashapelayer = [CAShapeLayer layer];
    
    if ([option isEqualToString:@"closed"]) {
        
        yposition=12;
        xposition=button.frame.size.width-offset;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,NULL,xposition,yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
        CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
        CGPathAddLineToPoint(path, NULL, xposition, yposition);
        
        [cashapelayer setPath:path];
        cashapelayer.strokeColor = [UIColor whiteColor].CGColor;
        cashapelayer.lineWidth = 1.0f;
        [[button layer] addSublayer:cashapelayer];
        
        CGPathRelease(path);
    }else{
        yposition=12+height;
        xposition=button.frame.size.width-offset;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,NULL,xposition,yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
        CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
        CGPathAddLineToPoint(path, NULL, xposition, yposition);
        
        [cashapelayer setPath:path];
        cashapelayer.strokeColor = [UIColor whiteColor].CGColor;
        cashapelayer.lineWidth = 1.0f;
        [[button layer] addSublayer:cashapelayer];
        
        CGPathRelease(path);
    }
    
    
}

-(void) selectproductcategory:(UIButton *)sender
{
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects: [productcategoryselected isEqualToString:@"All"]?@"All Categories":productcategoryselected, nil] DataType:@"productCategory" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(250, 40*productcategoryarray.count>600?600:40*productcategoryarray.count) View:self delegateView:self Button:sender ItemsArray:productcategoryarray Title:nil];
    
    [self drawpointerwithoption:@"open" button:ProductCategorySelectionButton];

}

-(void) selectsubjectcategory:(UIButton *)sender
{
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects: subjectcategoryselected, nil] DataType:@"subjectCategory" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(250, 40*subjectcategoryarray.count>600?600:40*subjectcategoryarray.count) View:self delegateView:self Button:sender ItemsArray:subjectcategoryarray Title:nil];
    
    [self drawpointerwithoption:@"open" button:SubjectCategorySelectionButton];
    
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverController {
    
    if (popoverController==myProductCategorySelectionPopoverController){
        [self drawpointerwithoption:@"closed" button:ProductCategorySelectionButton];
    }else if (popoverController==mySubjectCategorySelectionPopoverController){
        [self drawpointerwithoption:@"closed" button:SubjectCategorySelectionButton];
    }else if (popoverController == myMarketingPopoverController){
        [marketingtable deselectRowAtIndexPath:[marketingtable indexPathForSelectedRow] animated:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;

}

-(void) editcalendarbuttonpressed:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:[MyClass returntitlewithtitle:@"Edit Calendar"]]) {
        [sender setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    }else{
        [sender setTitle:[MyClass returntitlewithtitle:@"Edit Calendar"] forState:UIControlStateNormal];
    }
}

-(NSString *) classExistsWithClassDate:(NSString *)classdate
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=checkclassexists&classdate=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:classdate]];
    
    __block NSString * strResult=@"";
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            strResult = jsonreturned[@"content"];
        }
    }];
    
    return strResult;

}



-(BOOL) setCalendarWorkingDate:(NSString *)calendardate Option:(NSString *)option
{
    //update calendar in server database
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatecalendar&calendardate=%@&centerday=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:calendardate],option];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if (result) {
        NSString *sql;

        
        sql=[NSString stringWithFormat:@"delete from schoolcalendar where date='%@' and centerkey='%@'",[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:calendardate],globalvariables.centerrecord.centerkey];
        sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,NULL);
        NSString *key=[NSString stringWithFormat:@"%@#%@",[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:calendardate],globalvariables.centerrecord.centerkey];
        [globalvariables.centerdaydictionary removeObjectForKey:key];
        

        
        if ([option isEqualToString:@"W"]) {
            [daybuttonselected setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }else if ([option isEqualToString:@"H"]){
            [daybuttonselected setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            
            sql=[NSString stringWithFormat:@"insert into schoolcalendar ('centerkey','date','centerday') values ('%@','%@','%@')",globalvariables.centerrecord.centerkey,[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:calendardate],option];
            sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,NULL);
            [globalvariables.centerdaydictionary setValue:option forKey:key];
            
        }else{
            [daybuttonselected setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            
            sql=[NSString stringWithFormat:@"insert into schoolcalendar ('centerkey','date','centerday') values ('%@','%@','%@')",globalvariables.centerrecord.centerkey,[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:calendardate],option];
            sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,NULL);
            [globalvariables.centerdaydictionary setValue:option forKey:key];
            
        }
        
    }
        
    return result;
}

-(BOOL) retrieveMarketingRecordwithflushcachedata:(BOOL)flushcachedata
{
    NSMutableArray *marketingarray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveMarketingRecordWithStatus:[marketingstatusarray objectAtIndex:[scmarketingstatus selectedSegmentIndex]] enrollmentdate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] flushcachedata:flushcachedata subjectkey:nil productkey:nil]];
    if (marketingarray) {
        marketingmediaArray=[[NSMutableArray alloc]initWithArray:[marketingarray objectAtIndex:0]];
        marketingsourceArray=[[NSMutableArray alloc]initWithArray:[marketingarray objectAtIndex:1]];
        marketingpromotionArray=[[NSMutableArray alloc]initWithArray:[marketingarray objectAtIndex:2]];
        marketingcouponArray=[[NSMutableArray alloc]initWithArray:[marketingarray objectAtIndex:3]];
        
        if (scmarketingcategory.selectedSegmentIndex==0) {
            [self returnmarketingarraywithtype:scmarketingcategory.selectedSegmentIndex];
        }else if (scmarketingcategory.selectedSegmentIndex==1){
            [self returnmarketingarraywithtype:scmarketingcategory.selectedSegmentIndex];
        }else if (scmarketingcategory.selectedSegmentIndex==2){
            [self returnmarketingarraywithtype:scmarketingcategory.selectedSegmentIndex];
        }else if (scmarketingcategory.selectedSegmentIndex==3){
            [self returnmarketingarraywithtype:scmarketingcategory.selectedSegmentIndex];
        }
        
        return YES;
    }else{
        return NO;
    }
}

-(BOOL) retrieveClassroomwithflushcachedata:(BOOL)flushcachedata
{
    ClassroomArray=[[NSMutableArray alloc] initWithArray:[MyClass retrieveClassroomListwithstatus:[classroomstatusarray objectAtIndex:scclassroomstatus.selectedSegmentIndex]  withTBD:NO flushcachedata:flushcachedata]];
    [self returnfilterclassroomarray];
    
    if (ClassroomArray) {
        //[classroomtable reloadData];
        
        return YES;
    }else{
        //[MyClass showconnectionlostdialogbox];
        return NO;
    }
}

-(void) addmarketing:(UIButton *)sender
{
    if(scmarketingcategory.selectedSegmentIndex==0){
        [ailoadindicator startAnimating];
        ailoadindicator.hidden=NO;
        [self adjustpresentingviewwidthwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MarketingPopoverViewController *marketingpopover = (MarketingPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MarketingPopoverViewController"];
            marketingpopover.delegate=self;
            marketingpopover.MarketingTableCategory=@"media";
            marketingpopover.MarketingRecordObject=nil;
            marketingpopover.MarketingTableMode=@"Add";
            
            marketingpopover.view.frame=self->sidewindowview.bounds;
            [self->sidewindowview addSubview:marketingpopover.view];
            [self addChildViewController:marketingpopover];
            [marketingpopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            self->ailoadindicator.hidden=YES;
        });
    }else if(scmarketingcategory.selectedSegmentIndex==1){
        [ailoadindicator startAnimating];
        ailoadindicator.hidden=NO;
        [self adjustpresentingviewwidthwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MarketingPopoverViewController *marketingpopover = (MarketingPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MarketingPopoverViewController"];
            marketingpopover.delegate=self;
            marketingpopover.MarketingTableCategory=@"source";
            marketingpopover.MarketingRecordObject=nil;
            marketingpopover.MarketingTableMode=@"Add";
            
            marketingpopover.view.frame=self->sidewindowview.bounds;
            [self->sidewindowview addSubview:marketingpopover.view];
            [self addChildViewController:marketingpopover];
            [marketingpopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            self->ailoadindicator.hidden=YES;
        });
    }else if(scmarketingcategory.selectedSegmentIndex==2){
        [ailoadindicator startAnimating];
        ailoadindicator.hidden=NO;
        [self adjustpresentingviewwidthwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MarketingPopoverViewController *marketingpopover = (MarketingPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MarketingPopoverViewController"];
            marketingpopover.delegate=self;
            marketingpopover.MarketingTableCategory=@"promotion";
            marketingpopover.MarketingRecordObject=nil;
            marketingpopover.MarketingTableMode=@"Add";
            
            marketingpopover.view.frame=self->sidewindowview.bounds;
            [self->sidewindowview addSubview:marketingpopover.view];
            [self addChildViewController:marketingpopover];
            [marketingpopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            self->ailoadindicator.hidden=YES;
        });
    }else if(scmarketingcategory.selectedSegmentIndex==3){
        [ailoadindicator startAnimating];
        ailoadindicator.hidden=NO;
        [self adjustpresentingviewwidthwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MarketingPopoverViewController *marketingpopover = (MarketingPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MarketingPopoverViewController"];
            marketingpopover.delegate=self;
            marketingpopover.MarketingTableCategory=@"coupon";
            marketingpopover.MarketingRecordObject=nil;
            marketingpopover.MarketingTableMode=@"Add";
            
            marketingpopover.view.frame=self->sidewindowview.bounds;
            [self->sidewindowview addSubview:marketingpopover.view];
            [self addChildViewController:marketingpopover];
            [marketingpopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            self->ailoadindicator.hidden=YES;
        });
    }
    
}



-(void) addclassroom:(UIButton *)sender
{
    [ailoadindicator startAnimating];
    ailoadindicator.hidden=NO;
    [self adjustpresentingviewwidthwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ClassroomPopoverViewController *classroompopover = (ClassroomPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"ClassroomPopoverViewController"];
        classroompopover.delegate=self;
        classroompopover.ClassroomRecordObject=nil;
        classroompopover.ClassroomTableMode=@"Add";
        
        classroompopover.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:classroompopover.view];
        [self addChildViewController:classroompopover];
        [classroompopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
}



-(void) dismissMarketingPopover
{
    //[myMarketingPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self closesidewindow];
    [self retrieveMarketingRecordwithflushcachedata:YES];
}

-(void) dismissClassroomPopover
{
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self closesidewindow];
    [self retrieveClassroomwithflushcachedata:YES];
}

-(void) changemarketingfilter:(UISegmentedControl *)sender
{
    if ([self retrieveMarketingRecordwithflushcachedata:YES]) {
        lastmarketingfilterindex=sender.selectedSegmentIndex;
    }else{
        sender.selectedSegmentIndex=lastmarketingfilterindex;
    }

}

-(void) changemarketingcategory:(UISegmentedControl *)sender
{
    marketingsearchbar.text=@"";
    [self.view endEditing:YES];
    
    if (sender.selectedSegmentIndex==0) {
        title_marketing_discount.hidden=YES;
        title_marketing_quota.hidden=YES;
        title_marketing_description.text=[MyClass returntitlewithtitle:@"Media Description"];
        [self returnmarketingarraywithtype:sender.selectedSegmentIndex];
        title_marketing_validityto.hidden=YES;
    }else if (sender.selectedSegmentIndex==1) {
        title_marketing_discount.hidden=YES;
        title_marketing_quota.hidden=YES;
        title_marketing_description.text=[MyClass returntitlewithtitle:@"Source Description"];
        [self returnmarketingarraywithtype:sender.selectedSegmentIndex];
        title_marketing_validityto.hidden=YES;
    }else if (sender.selectedSegmentIndex==2){
        title_marketing_discount.hidden=NO;
        title_marketing_quota.hidden=NO;
        title_marketing_description.text=[MyClass returntitlewithtitle:@"Promotion Description"];
        [self returnmarketingarraywithtype:sender.selectedSegmentIndex];
        title_marketing_validityto.hidden=YES;
    }else if (sender.selectedSegmentIndex==3){
        title_marketing_discount.hidden=NO;
        title_marketing_quota.hidden=NO;
        title_marketing_description.text=[MyClass returntitlewithtitle:@"Coupon Description"];
        [self returnmarketingarraywithtype:sender.selectedSegmentIndex];
        title_marketing_validityto.hidden=NO;
    }
    [self refreshtableheader];
    [marketingtable reloadData];
    
}


-(void) changeclassroomfilter:(UISegmentedControl *)sender
{
    if ([self retrieveClassroomwithflushcachedata:YES]) {
        lastclassroomfilterindex=sender.selectedSegmentIndex;
    }else{
        sender.selectedSegmentIndex=lastclassroomfilterindex;
    }
}

-(void) loadtitle
{
    //viewtitle.text=[MyClass returntitlewithtitle:@"Center Information"];
    title_Center_hours_except_center_holiday.text=[MyClass returntitlewithtitle:@"Center hours (except center holiday)"];
    title_Email.text=[MyClass returntitlewithtitle:@"Email"];
    title_Website.text=[MyClass returntitlewithtitle:@"Website"];
    title_Others.text=[MyClass returntitlewithtitle:@"Others"];
}

-(void) refreshcalendarwithflushcachedata:(BOOL)flushcachedata
{
    if (flushcachedata) {
        [MyClass getLatestDataSetv2withParameters:@"calendar" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
            dispatch_async(dispatch_get_main_queue(), ^{
            if (newupdateavailable) {
                [self loadingindicatorwithoption:@"stop"];
                return;
            }else if (nocenteravailable){
                [self loadingindicatorwithoption:@"stop"];
                return;
            }else if (viewingcentersdeleted) {
                [self loadingindicatorwithoption:@"stop"];
                [self switchcenterbuttonpressed];
                return;
            }
            });
        }];
    }
    //[MyClass LoadSchoolCalendarArray];
    [self retrieveCalendar];
}

-(void) switchcenterbuttonpressed
{
    [self loadingindicatorwithoption:@"start"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyClass getLatestDataSetv2withParameters:@"" Centerkeys:@"" completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
            if (!nocenteravailable && !newupdateavailable) {
                dispatch_async(dispatch_get_main_queue(), ^{
                [self loadingindicatorwithoption:@"stop"];
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
        selectedMainImage=0;
        if (policy_editmode) {
            policy_editmode=NO;
            [self drawpolicycategorybutton];
        }
        [MyClass retrievemenuimagewithasync:YES];
        [self reloadPage];

    }
}

-(void) highlightmainimage
{
    shopfrontimage.layer.borderColor=[UIColor clearColor].CGColor;
    shopfrontimage.layer.borderWidth=0;
//    mapimage.layer.borderColor=[UIColor clearColor].CGColor;
//    mapimage.layer.borderWidth=0;
    launchimage_landscape.layer.borderColor=[UIColor clearColor].CGColor;
    launchimage_landscape.layer.borderWidth=0;
    launchimage_portrait.layer.borderColor=[UIColor clearColor].CGColor;
    launchimage_portrait.layer.borderWidth=0;
    
    if (selectedMainImage==0) {
        shopfrontimage.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
        shopfrontimage.layer.borderWidth=2;
        mainimage.contentMode=UIViewContentModeScaleAspectFill;
    }/*else if (selectedMainImage==1) {
        mapimage.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
        mapimage.layer.borderWidth=2;
        mainimage.contentMode=UIViewContentModeScaleAspectFill;
    }*/else if (selectedMainImage==2) {
        launchimage_landscape.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
        launchimage_landscape.layer.borderWidth=2;
        mainimage.contentMode=UIViewContentModeScaleAspectFill;
    }else if (selectedMainImage==3) {
        launchimage_portrait.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
        launchimage_portrait.layer.borderWidth=2;
        mainimage.contentMode=UIViewContentModeScaleAspectFit;
    }
    
}

-(void) showprivilagegroupbutton
{
    //scstaffrole.frame = CGRectMake(306, 5, staffview.frame.size.width-306-5-4-29-29, 29);
    if([((PrivilegeRecord *)[MyClass returnprivilegerecordwithprivilegekey:((UserPrivilege *)[MyClass returnuserprivilegewithcenterkey:globalvariables.centerrecord.centerkey]).privilegekey]).usertype isEqualToString:@"Super"] || [((UserPrivilege *)[MyClass returnuserprivilegewithcenterkey:globalvariables.centerrecord.centerkey]).role isEqualToString:@"System"]){
        staff_userprivilegebutton.enabled=YES;
        //staff_usergroupbutton.enabled=YES;
        //scstaffrole.frame = CGRectMake(306, 5, staffview.frame.size.width-306-5-4-29-29, 29);
        
    }else{
        staff_userprivilegebutton.enabled=NO;
        //staff_usergroupbutton.enabled=NO;
        //scstaffrole.frame = CGRectMake(306, 5, staffview.frame.size.width-306-5, 29);
    }
}

-(void) reloadPage
{
    [self loadingindicatorwithoption:@"start"];
    [self centerinfo_cancelbuttonpressed];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,product,staff,classroom,marketing,centersettings,userroleandprivilege,student,lead,leavenature,arcode" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
                dispatch_async(dispatch_get_main_queue(), ^{
                if (newupdateavailable) {
                    [self loadingindicatorwithoption:@"stop"];
                    return;
                }else if (nocenteravailable){
                    [self loadingindicatorwithoption:@"stop"];
                    return;
                }else if (viewingcentersdeleted) {
                    [self loadingindicatorwithoption:@"stop"];
                    [self switchcenterbuttonpressed];
                }else{
                    
                    [MyClass updatecenterkey];
                    [self retrievePrivilege];
                    [self retrieveGroup];

                    showSalaryrate=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).vieweditsalaryrate&& globalvariables.centerrecord.enablestaffsalaryrate;
                    [self refreshlanguage];
                    
                    if (lastviewindex==0){
                        [self retrievecenterimages];
                        [self loadcenterinformation];
                        [self loadtitle];
                        //[self highlightmainimage];
                    }else if (lastviewindex==1) {
                        [self refreshcalendarwithflushcachedata:NO];
                        [self loadingindicatorwithoption:@"stop"];
                    }else if (lastviewindex==2) {
                        subjectcategoryselected=@"All";
                        subjectsearchbar.text=@"";
                        [SubjectCategorySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Categories"] forState:UIControlStateNormal];
                        scsubjectstatus.selectedSegmentIndex=0;
                        subjectArray=[MyClass retrievecentersubjectinformationwithstatus:[subjectstatusarray objectAtIndex:scsubjectstatus.selectedSegmentIndex] category:subjectcategoryselected flushcachedata:NO];
                        subjectcategoryarray=[MyClass retrievesubjectcategorywithflushcachedata:NO];
                        [subjectcategoryarray insertObject:[[SubjectCategoryRecord alloc]initSubjectCategoryRecordwithCenterkey:nil SCategoryKey:@"All" Englishname:@"All Categories" Chinesename:@"All Categories" colorcode:0 bundleforapppayment:NO] atIndex:0];
                        [self returnfiltersubjectarray];
                        //[subjecttable reloadData];
                        [self loadingindicatorwithoption:@"stop"];
                    }else if (lastviewindex==3) {
                        roomsearchbar.text=@"";
                        [self retrieveClassroomwithflushcachedata:NO];
                        [self loadingindicatorwithoption:@"stop"];
                    }else if (lastviewindex==4) {
                        staffsearchbar.text=@"";
                        [self retrieveStaffListwithflushcachedata:NO];
                        [self loadingindicatorwithoption:@"stop"];
                        
                        localprivilegearray=[MyClass retrieveprivilegewithflushcachedata:NO];
                        GroupArray=[MyClass returnStaffGroupArrayIncludeAll:NO];
                        
                        [self showprivilagegroupbutton];
                        
                        
                    }else if (lastviewindex==5) {
                        productsearchbar.text=@"";
                        [self retrieveProductListwithresetcategoryfilter:YES flushcachedata:NO];
                        [self loadingindicatorwithoption:@"stop"];
                    }else if (lastviewindex==6) {
                        marketingsearchbar.text=@"";
                        [self retrieveMarketingRecordwithflushcachedata:NO];
                        [self loadingindicatorwithoption:@"stop"];
                    }else if (lastviewindex==7) {
                        [self retrievepolicy];
                        [self loadingindicatorwithoption:@"stop"];
                    }else if (lastviewindex==8) {
                        [self retrievesubscriptionplan];
                        [self retrievedevicelistwithappname:((LicenseRecord *)[licenseArray objectAtIndex:licensetableindexpath.row]).appname];
                        [self loadingindicatorwithoption:@"stop"];
                    }
                    
                    if(globalvariables.centerrecord.enableattendanceextend){
                        cbLeaveNature3.hidden=NO;
                        cbLeaveNature13.hidden=NO;
                        cbLeaveNature23.hidden=NO;
                        cbLeaveNature33.hidden=NO;
                        title_Extend.hidden=NO;
                    }else{
                        cbLeaveNature3.hidden=YES;
                        cbLeaveNature13.hidden=YES;
                        cbLeaveNature23.hidden=YES;
                        cbLeaveNature33.hidden=YES;
                        title_Extend.hidden=YES;
                    }
                    
                    if(globalvariables.centerrecord.ecoupon){
                        if(scmarketingcategory.numberOfSegments==3){
                            [scmarketingcategory insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Coupon"] atIndex:3 animated:NO];
                        }
                    }else{
                        if(scmarketingcategory.numberOfSegments==4){
                            [scmarketingcategory removeSegmentAtIndex:3 animated:NO];
                        }
                    }
                    
                    if([globalvariables.centerrecord.iparentleavemode isEqualToString:@"Request"]){
                        LeaveConfigAutoApproveStackView.hidden=NO;
                    }else{
                        LeaveConfigAutoApproveStackView.hidden=YES;
                    }
                    
                    
                    if (globalvariables.centerrecord.enableattendanceextend) {
                        SubjectCategorySelectionButton.hidden=NO;
                    }else{
                        SubjectCategorySelectionButton.hidden=YES;
                    }
                    
                    addlicenseview.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).addlicense || ![globalvariables.centerrecord.licensetype isEqualToString:@"Annual"];
                }
            });
        }];
    });
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==subjectsearchbar) {
        [self returnfiltersubjectarray];
        //[subjecttable reloadData];
        [subjecttable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==staffsearchbar) {
        [self returnfilterstaffarray];
        //[stafftable reloadData];
        [stafftable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==roomsearchbar) {
        [self returnfilterclassroomarray];
        //[classroomtable reloadData];
        [classroomtable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==productsearchbar) {
        [self returnfilterproductarray];
        //[producttable reloadData];
        [producttable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==marketingsearchbar) {
        if (scmarketingcategory.selectedSegmentIndex==0) {
            [self returnmarketingarraywithtype:scmarketingcategory.selectedSegmentIndex];
            [marketingtable setContentOffset:CGPointZero animated:YES];
        }else if (scmarketingcategory.selectedSegmentIndex==1){
            [self returnmarketingarraywithtype:scmarketingcategory.selectedSegmentIndex];
            [marketingtable setContentOffset:CGPointZero animated:YES];
        }else{
            [self returnmarketingarraywithtype:scmarketingcategory.selectedSegmentIndex];
            [marketingtable setContentOffset:CGPointZero animated:YES];
        }
    }else if (searchBar==ri_instructorsearchbar){
        [self returnfilterriinstructorarray];
        [ri_instructortable setContentOffset:CGPointZero animated:YES];
    }
}

-(void) returnfiltersubjectarray
{
    //NSMutableArray *result;
    
    if ([subjectsearchbar.text isEqualToString:@""]) {
        filteredSubjectArray= [[NSMutableArray alloc]initWithArray:subjectArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.subject_shortname contains[c] %@ or self.subject_englishname contains[c] %@ or self.subject_chinesename contains[c] %@ or self.remarks contains[c] %@ or self.subject_category contains[c] %@",subjectsearchbar.text,subjectsearchbar.text,subjectsearchbar.text,subjectsearchbar.text,subjectsearchbar.text];
        filteredSubjectArray= [[NSMutableArray alloc]initWithArray:[subjectArray filteredArrayUsingPredicate:predicate]];
    }
    
    [self sortsubjectlist];
}

-(void) returnfilterstaffarray
{
    if ([staffsearchbar.text isEqualToString:@""]) {
        filteredStaffArray= [[NSMutableArray alloc]initWithArray:StaffArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or self.username contains[c] %@ or self.phone contains[c] %@ or self.role contains[c] %@",staffsearchbar.text,staffsearchbar.text,staffsearchbar.text,staffsearchbar.text,staffsearchbar.text,staffsearchbar.text];
        filteredStaffArray= [[NSMutableArray alloc]initWithArray:[StaffArray filteredArrayUsingPredicate:predicate]];
    }
    [self sortstafflist];
}

-(void) returnfilterriinstructorarray
{
    if ([ri_instructorsearchbar.text isEqualToString:@""]) {
        ri_filteredinstructorarray= [[NSMutableArray alloc]initWithArray:ri_allinstructorarray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.firstname contains[c] %@ or self.lastname contains[c] %@ or self.username contains[c] %@ or self.phone contains[c] %@",ri_instructorsearchbar.text,ri_instructorsearchbar.text,ri_instructorsearchbar.text,ri_instructorsearchbar.text,ri_instructorsearchbar.text];
        ri_filteredinstructorarray= [[NSMutableArray alloc]initWithArray:[ri_filteredinstructorarray filteredArrayUsingPredicate:predicate]];
    }
    [ri_instructortable reloadData];
}

-(void) returnfilterclassroomarray
{
    if ([roomsearchbar.text isEqualToString:@""]) {
        filteredClassroomArray= [[NSMutableArray alloc]initWithArray:ClassroomArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.classroom contains[c] %@ or self.remarks contains[c] %@",roomsearchbar.text,roomsearchbar.text];
        filteredClassroomArray= [[NSMutableArray alloc]initWithArray:[ClassroomArray filteredArrayUsingPredicate:predicate]];
    }
    
    [self sortclassroomlist];
}

-(void) returnfilterproductarray
{
    if ([productsearchbar.text isEqualToString:@""]) {
        filteredProductArray= [[NSMutableArray alloc]initWithArray:ProductArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.englishname contains[c] %@ or self.chinesename contains[c] %@ or self.code contains[c] %@ or self.remarks contains[c] %@ or self.category contains[c] %@ and self.code !=%@",productsearchbar.text,productsearchbar.text,productsearchbar.text,productsearchbar.text,productsearchbar.text,@"FPAY"];
        filteredProductArray= [[NSMutableArray alloc]initWithArray:[ProductArray filteredArrayUsingPredicate:predicate]];
    }
    
    [self sortproductlist];
}


-(void) returnmarketingarraywithtype:(long)type
{
    if ([marketingsearchbar.text isEqualToString:@""]) {
        if (type==0) {
            filteredmarketingmediaArray= [[NSMutableArray alloc]initWithArray:marketingmediaArray];
        }else if (type==1){
            filteredmarketingsourceArray= [[NSMutableArray alloc]initWithArray:marketingsourceArray];
        }else if (type==2){
            filteredmarketingpromotionArray= [[NSMutableArray alloc]initWithArray:marketingpromotionArray];
        }else if (type==3){
            filteredmarketingcouponArray= [[NSMutableArray alloc]initWithArray:marketingcouponArray];
        }
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.description contains[c] %@ or self.description_chinese contains[c] %@ or self.remarks contains[c] %@ or self.promotionfixeddiscount contains[c] %@ or self.promotionpercentagediscount contains[c] %@ or self.code contains[c] %@",marketingsearchbar.text,marketingsearchbar.text,marketingsearchbar.text,marketingsearchbar.text,marketingsearchbar.text,marketingsearchbar.text];
        if (type==0) {
            filteredmarketingmediaArray= [[NSMutableArray alloc]initWithArray:[marketingmediaArray filteredArrayUsingPredicate:predicate]];
        }else if (type==1){
            filteredmarketingsourceArray= [[NSMutableArray alloc]initWithArray:[marketingsourceArray filteredArrayUsingPredicate:predicate]];
        }else if (type==2){
            filteredmarketingpromotionArray= [[NSMutableArray alloc]initWithArray:[marketingpromotionArray filteredArrayUsingPredicate:predicate]];
        }else if (type==3){
            filteredmarketingcouponArray= [[NSMutableArray alloc]initWithArray:[marketingcouponArray filteredArrayUsingPredicate:predicate]];
        }
        
    }
    
    [self sortmarketinglist];
}

-(void) returnsortingarray
{
    if (lastviewindex==2) {
        sortingarray=[MyClass returnsortingarraywithtype:@"subjectlistsortingorder"];
    }else if (lastviewindex==3){
        sortingarray=[MyClass returnsortingarraywithtype:@"classroomlistsortingorder"];
    }else if (lastviewindex==4){
        sortingarray=[MyClass returnsortingarraywithtype:@"stafflistsortingorder"];
    }else if (lastviewindex==5){
        sortingarray=[MyClass returnsortingarraywithtype:@"productlistsortingorder"];
    }else if (lastviewindex==6){
        if (scmarketingcategory.selectedSegmentIndex==0) {
            sortingarray=[MyClass returnsortingarraywithtype:@"marketingmedialistsortingorder"];
        }else if (scmarketingcategory.selectedSegmentIndex==1){
            sortingarray=[MyClass returnsortingarraywithtype:@"marketingsourcelistsortingorder"];
        }else if (scmarketingcategory.selectedSegmentIndex==2){
            sortingarray=[MyClass returnsortingarraywithtype:@"marketingpromotionlistsortingorder"];
        }else if (scmarketingcategory.selectedSegmentIndex==3){
            sortingarray=[MyClass returnsortingarraywithtype:@"marketingcouponlistsortingorder"];
        }
    }
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
    [sortingtable layoutIfNeeded];
    
    CGFloat totalHeight = 10;

    for (NSInteger section = 0; section < [sortingtable numberOfSections]; section++) {
        // Add header height
        totalHeight += [sortingtable rectForHeaderInSection:section].size.height;
        
        // Add row heights
        for (NSInteger row = 0; row < [sortingtable numberOfRowsInSection:section]; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            totalHeight += [sortingtable rectForRowAtIndexPath:indexPath].size.height;
        }
        
        // Add footer height
        totalHeight += [sortingtable rectForFooterInSection:section].size.height;
    }
    
    sortingtable.backgroundColor = [UIColor systemGroupedBackgroundColor];
    
    sortingtable.frame=CGRectMake(0, 0, 220, totalHeight);
    UIView *sortingview=[[UIView alloc]initWithFrame:sortingtable.frame];
    [sortingview addSubview:sortingtable];
    
    UIViewController *sortingvc=[[UIViewController alloc]init];
    sortingvc.preferredContentSize=CGSizeMake(sortingview.frame.size.width, sortingview.frame.size.height);
    sortingvc.view=sortingview;
    sortingvc.modalPresentationStyle=UIModalPresentationPopover;
    myPopoverController=sortingvc.popoverPresentationController;
    myPopoverController.delegate=self;
    myPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myPopoverController.sourceView=sender;
    myPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:sortingvc animated:YES completion:nil];

}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==sortingtable) {
        return YES;
    }else if (tableView==leaveNatureListTable){
        return YES;
    }
    return NO;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==devicetable) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==devicetable) {
        return [MyClass returntitlewithtitle:@"Disable"];
    }else{
        return [MyClass returntitlewithtitle:@"Delete"];
    }
    
    
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
    
    if (lastviewindex==2) {
        [MyClass updatelocaldbwithparameter:@"subjectlistsortingorder" value:sortingstring];
    }else if (lastviewindex==3){
        [MyClass updatelocaldbwithparameter:@"classroomlistsortingorder" value:sortingstring];
    }else if (lastviewindex==4){
        [MyClass updatelocaldbwithparameter:@"stafflistsortingorder" value:sortingstring];
    }else if (lastviewindex==5){
        [MyClass updatelocaldbwithparameter:@"productlistsortingorder" value:sortingstring];
    }else if (lastviewindex==6){
        if (scmarketingcategory.selectedSegmentIndex==0) {
            [MyClass updatelocaldbwithparameter:@"marketingmedialistsortingorder" value:sortingstring];
        }else if (scmarketingcategory.selectedSegmentIndex==1){
            [MyClass updatelocaldbwithparameter:@"marketingsourcelistsortingorder" value:sortingstring];
        }else if (scmarketingcategory.selectedSegmentIndex==2){
            [MyClass updatelocaldbwithparameter:@"marketingpromotionlistsortingorder" value:sortingstring];
        }else if (scmarketingcategory.selectedSegmentIndex==3){
            [MyClass updatelocaldbwithparameter:@"marketingcouponlistsortingorder" value:sortingstring];
        }
    }
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
    
    if (lastviewindex==2) {
        [self sortsubjectlist];
    }else if (lastviewindex==3){
        [self sortclassroomlist];
    }else if (lastviewindex==4){
        [self sortstafflist];
    }else if (lastviewindex==5){
        [self sortproductlist];
    }else if (lastviewindex==6){
        [self sortmarketinglist];
    }
    
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
    if(tableView==sortingtable){
        if (toIndexPath.section==0 && (fromIndexPath.row !=toIndexPath.row)) {
            sortingobject=[sortingarray objectAtIndex:fromIndexPath.row];
            [sortingarray removeObjectAtIndex:fromIndexPath.row];
            [sortingarray insertObject:sortingobject atIndex:toIndexPath.row];
            
            [self updatesortingstring];
            if (lastviewindex==2) {
                [self sortsubjectlist];
            }else if (lastviewindex==3){
                [self sortclassroomlist];
            }else if (lastviewindex==4){
                [self sortstafflist];
            }else if (lastviewindex==5){
                [self sortproductlist];
            }else if (lastviewindex==6){
                [self sortmarketinglist];
            }
        }
    }else if (tableView==leaveNatureListTable){
        if (toIndexPath.section==0 && (fromIndexPath.row !=toIndexPath.row)) {
            NSMutableArray *leavenaturelistkeyarray=[[NSMutableArray alloc]init];
            NSMutableArray *listorderarray=[[NSMutableArray alloc]init];
            if(fromIndexPath.row>toIndexPath.row){
                //move up
                for(long i=toIndexPath.row;i<=fromIndexPath.row;i++){
                    if(i==fromIndexPath.row){
                        ((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:i]).listorder=[@(toIndexPath.row) stringValue];
                    }else{
                        ((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:i]).listorder=[@(i+1) stringValue];
                    }
                    [leavenaturelistkeyarray addObject:((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:i]).leavenaturelistkey];
                    [listorderarray addObject:((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:i]).listorder];
                }
            }else{
                //move down
                for(long i=fromIndexPath.row;i<=toIndexPath.row;i++){
                    if(i==fromIndexPath.row){
                        ((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:i]).listorder=[@(toIndexPath.row) stringValue];
                    }else{
                        ((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:i]).listorder=[@(i-1) stringValue];
                    }
                    [leavenaturelistkeyarray addObject:((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:i]).leavenaturelistkey];
                    [listorderarray addObject:((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:i]).listorder];
                }
            }
            selectedLeaveNatureRow=[((LeaveNatureRecord *)[leaveNatureArray objectAtIndex:selectedLeaveNatureRow]).listorder integerValue];
            [self updateLeaveNatureWithLeaveNatureListKey:[leavenaturelistkeyarray componentsJoinedByString:@","] Key:@"multilistorder" Value:[listorderarray componentsJoinedByString:@","] leavenatureconfigkey:nil reloadArray:YES];
            //leaveNatureArray=[MyClass retrieveLeaveNatureArrayWithFlushCacheData:NO];
        }
    }
    

}

-(void) sortmarketinglist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarray];
    

    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        if ([sortingobject.item isEqualToString:@"description"]) {
            sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:[globalvariables.language isEqualToString:@"English"]?@"description":@"description_chinese" ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        }else{
            sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO  selector:@selector(localizedStandardCompare:)];
        }
        
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    MarketingRecord *mktobj;
    if (scmarketingcategory.selectedSegmentIndex==0) {
        
        for (int i=0; i<filteredmarketingmediaArray.count; i++) {
            mktobj=[filteredmarketingmediaArray objectAtIndex:i];
            mktobj.startdate=[MyClass convertDateFormatWithDate:mktobj.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
            mktobj.enddate=[MyClass convertDateFormatWithDate:mktobj.enddate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        }
        
        filteredmarketingmediaArray=[NSMutableArray arrayWithArray:[filteredmarketingmediaArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
        for (int i=0; i<filteredmarketingmediaArray.count; i++) {
            mktobj=[filteredmarketingmediaArray objectAtIndex:i];
            mktobj.startdate=[MyClass convertDateFormatWithDate:mktobj.startdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
            mktobj.enddate=[MyClass convertDateFormatWithDate:mktobj.enddate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
        }
        
        [marketingtable reloadData];
    }else if (scmarketingcategory.selectedSegmentIndex==1){
        for (int i=0; i<filteredmarketingsourceArray.count; i++) {
            mktobj=[filteredmarketingsourceArray objectAtIndex:i];
            mktobj.startdate=[MyClass convertDateFormatWithDate:mktobj.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
            mktobj.enddate=[MyClass convertDateFormatWithDate:mktobj.enddate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        }
        filteredmarketingsourceArray=[NSMutableArray arrayWithArray:[filteredmarketingsourceArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
        for (int i=0; i<filteredmarketingsourceArray.count; i++) {
            mktobj=[filteredmarketingsourceArray objectAtIndex:i];
            mktobj.startdate=[MyClass convertDateFormatWithDate:mktobj.startdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
            mktobj.enddate=[MyClass convertDateFormatWithDate:mktobj.enddate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
        }
        [marketingtable reloadData];
    }else if (scmarketingcategory.selectedSegmentIndex==2){
        for (int i=0; i<filteredmarketingpromotionArray.count; i++) {
            mktobj=[filteredmarketingpromotionArray objectAtIndex:i];
            mktobj.startdate=[MyClass convertDateFormatWithDate:mktobj.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
            mktobj.enddate=[MyClass convertDateFormatWithDate:mktobj.enddate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        }
        filteredmarketingpromotionArray=[NSMutableArray arrayWithArray:[filteredmarketingpromotionArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
        for (int i=0; i<filteredmarketingpromotionArray.count; i++) {
            mktobj=[filteredmarketingpromotionArray objectAtIndex:i];
            mktobj.startdate=[MyClass convertDateFormatWithDate:mktobj.startdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
            mktobj.enddate=[MyClass convertDateFormatWithDate:mktobj.enddate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
        }
        [marketingtable reloadData];
    }else if (scmarketingcategory.selectedSegmentIndex==3){
        for (int i=0; i<filteredmarketingcouponArray.count; i++) {
            mktobj=[filteredmarketingcouponArray objectAtIndex:i];
            mktobj.startdate=[MyClass convertDateFormatWithDate:mktobj.startdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
            mktobj.enddate=[MyClass convertDateFormatWithDate:mktobj.enddate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO];
        }
        filteredmarketingcouponArray=[NSMutableArray arrayWithArray:[filteredmarketingcouponArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
        for (int i=0; i<filteredmarketingcouponArray.count; i++) {
            mktobj=[filteredmarketingcouponArray objectAtIndex:i];
            mktobj.startdate=[MyClass convertDateFormatWithDate:mktobj.startdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
            mktobj.enddate=[MyClass convertDateFormatWithDate:mktobj.enddate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
        }
        [marketingtable reloadData];
    }
}

-(void) sortsubjectlist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarray];
    
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        if ([sortingobject.item isEqualToString:@"subject_name"]) {
            sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:[globalvariables.language isEqualToString:@"English"]?@"subject_englishname":@"subject_chinesename" ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        }else{
            sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        }
        
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    filteredSubjectArray=[NSMutableArray arrayWithArray:[filteredSubjectArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    [subjecttable reloadData];

}

-(void) sortproductlist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarray];
    
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        if ([sortingobject.item isEqualToString:@"product_name"]) {
            sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:[globalvariables.language isEqualToString:@"English"]?@"englishname":@"chinesename" ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        }else{
            sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO selector:@selector(localizedStandardCompare:)];
        }
        
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    filteredProductArray=[NSMutableArray arrayWithArray:[filteredProductArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    [producttable reloadData];
    
}

-(void) sortclassroomlist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarray];
    
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO selector:@selector(localizedStandardCompare:)];
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    filteredClassroomArray=[NSMutableArray arrayWithArray:[filteredClassroomArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    [classroomtable reloadData];
    
}

-(void) sortstafflist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarray];
    
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO selector:@selector(localizedStandardCompare:)];
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    filteredStaffArray=[NSMutableArray arrayWithArray:[filteredStaffArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    [stafftable reloadData];
    
}



-(NSString *) returnsortinglabelwithitem:(NSString *)item
{
    if ([item isEqualToString:@"startdate"]) {
        return @"Available From";
    }else if ([item isEqualToString:@"description"]) {
        return @"Description";
    }else if ([item isEqualToString:@"enddate"]) {
        return @"Available To";
    }else if ([item isEqualToString:@"code"]) {
        return @"Code";
    }else if ([item isEqualToString:@"promotionfixeddiscount"]) {
        return @"Discount (%)";
    }else if ([item isEqualToString:@"promotionpercentagediscount"]) {
        return @"Discount ($)";
    }else if ([item isEqualToString:@"promotionquota"]) {
        return @"Quota";
    }else if ([item isEqualToString:@"usedcount"]) {
        return @"Used";
    }else if ([item isEqualToString:@"subject_shortname"]) {
        return @"Code";
    }else if ([item isEqualToString:@"subject_name"]) {
        return @"Subject Name";
    }else if ([item isEqualToString:@"subject_category"]) {
        return @"Course Category";
    }else if ([item isEqualToString:@"enrollmentmode"]) {
        return @"Standard Period";
    }else if ([item isEqualToString:@"tuition_method"]) {
        return @"Tuition By";
    }else if ([item isEqualToString:@"tuition_mode"]) {
        return @"Tuition Mode";
    }else if ([item isEqualToString:@"studentcapacity"]) {
        return @"Max. Class Size";
    }else if ([item isEqualToString:@"status"]) {
        return @"Status";
    }else if ([item isEqualToString:@"classroom"]) {
        return @"Classroom";
    }else if ([item isEqualToString:@"firstname"]) {
        return @"First name";
    }else if ([item isEqualToString:@"lastname"]) {
        return @"Last name";
    }else if ([item isEqualToString:@"role"]) {
        return @"Teaching";
    }else if ([item isEqualToString:@"username"]) {
        return @"Username/Email";
    }else if ([item isEqualToString:@"privilege"]) {
        return @"Privilege";
    }else if ([item isEqualToString:@"phone"]) {
        return @"Phone";
    }else if ([item isEqualToString:@"valid"]) {
        return @"Status";
    }else if ([item isEqualToString:@"category"]) {
        return @"Category";
    }else if ([item isEqualToString:@"price"]) {
        return @"Price";
    }else if ([item isEqualToString:@"product_name"]) {
        return @"Product Name";
    }
    return item;
}

-(void) tapCenterImageDetected:(UITapGestureRecognizer *)gr
{
    UIImageView *theTappedImageView=(UIImageView *)gr.view;
    selectedMainImage=theTappedImageView.tag;
    
    [self highlightmainimage];
    
    if (centerinfo_savebutton.hidden) {
        if (selectedMainImage==0) {
            //mainimage.contentMode=UIViewContentModeScaleAspectFill;
            [MyClass downloadImageWithImageview:mainimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.shopfrontimage image:@"Yes" async:YES];
            mainimagelabel.text=[MyClass returntitlewithtitle:@"Shop Front"];
        }/*else if (selectedMainImage==1){
            //mainimage.contentMode=UIViewContentModeScaleAspectFill;
            [MyClass downloadImageWithImageview:mainimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.mapimage image:@"Yes" async:YES];
            mainimagelabel.text=[MyClass returntitlewithtitle:@"Map"];
        }*/else if (selectedMainImage==2){
            //mainimage.contentMode=UIViewContentModeScaleAspectFill;
            [MyClass downloadImageWithImageview:mainimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_landscape image:@"Yes" async:YES];
            mainimagelabel.text=[MyClass returntitlewithtitle:@"iPad Launch Image"];
        }else if (selectedMainImage==3){
            //mainimage.contentMode=UIViewContentModeScaleAspectFit;
            [MyClass downloadImageWithImageview:mainimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_portrait image:@"Yes" async:YES];
            mainimagelabel.text=[MyClass returntitlewithtitle:@"Mobile Launch Image"];
        }
    }else{
        if (selectedMainImage==0) {
            //mainimage.contentMode=UIViewContentModeScaleAspectFill;
            if (tmpshopimagedata) {
                mainimage.image=[MyClass resizeImageWithImage:[[UIImage alloc] initWithData:tmpshopimagedata] ForSize:CGSizeMake(mainimage.frame.size.width,mainimage.frame.size.height)];;
                //centerinfo_deleteimagebutton.hidden=NO;
            }else{
                mainimage.image=[UIImage imageNamed:@"missingcenterimageicon.png"];
                //centerinfo_deleteimagebutton.hidden=YES;
            }
            mainimagelabel.text=[MyClass returntitlewithtitle:@"Shop Front"];
        }/*else if (selectedMainImage==1){
            //mainimage.contentMode=UIViewContentModeScaleAspectFill;
            if (tmpmapimagedata) {
                mainimage.image=[MyClass resizeImageWithImage:[[UIImage alloc] initWithData:tmpmapimagedata] ForSize:CGSizeMake(mainimage.frame.size.width,mainimage.frame.size.height)];;
                //centerinfo_deleteimagebutton.hidden=NO;
            }else{
                mainimage.image=[UIImage imageNamed:@"missingcenterimageicon.png"];
                //centerinfo_deleteimagebutton.hidden=YES;
            }
            mainimagelabel.text=[MyClass returntitlewithtitle:@"Map"];
        }*/else if (selectedMainImage==2){
            //mainimage.contentMode=UIViewContentModeScaleAspectFill;
            if (tmplandscapeimagedata) {
                mainimage.image=[MyClass resizeImageWithImage:[[UIImage alloc] initWithData:tmplandscapeimagedata] ForSize:CGSizeMake(mainimage.frame.size.width,mainimage.frame.size.height)];;
                //centerinfo_deleteimagebutton.hidden=NO;
            }else{
                mainimage.image=[UIImage imageNamed:@"missingcenterimageicon.png"];
                //centerinfo_deleteimagebutton.hidden=YES;
            }
            mainimagelabel.text=[MyClass returntitlewithtitle:@"iPad Launch Image"];
        }else if (selectedMainImage==3){
            //mainimage.contentMode=UIViewContentModeScaleAspectFit;
            if (tmpportraitimagedata) {
                mainimage.image=[MyClass resizeImageWithImage:[[UIImage alloc] initWithData:tmpportraitimagedata] ForSize:CGSizeMake(mainimage.frame.size.height*640/1136,mainimage.frame.size.height)];;
                //centerinfo_deleteimagebutton.hidden=NO;
            }else{
                mainimage.image=[UIImage imageNamed:@"missingcenterimageicon.png"];
                //centerinfo_deleteimagebutton.hidden=YES;
            }
            mainimagelabel.text=[MyClass returntitlewithtitle:@"Mobile Launch Image"];
        }
    }
    
    [self formatmainimagelabel];
}

-(void) centerinfo_editbuttonpressed
{
    //isMainImageShopFront=TRUE;
    workingCenter=[[CenterRecord alloc]init];
    
    //hide label
    centernamelabel.hidden=YES;
    schoolregnumberLabel.hidden=YES;
    schoolregnumberTitle.hidden=YES;
    centershortnamelabel.hidden=YES;
    centeraddresslabel.hidden=YES;
    centercontactlabel.hidden=YES;
    centerfaxlabel.hidden=YES;
    centerwhatsapplabel.hidden=YES;
    centerlatlonglabel.hidden=YES;
    centerhour_line1leftLabel.hidden=YES;
    centerhour_line2leftLabel.hidden=YES;
    centerhour_line3leftLabel.hidden=YES;
    centerhour_line4leftLabel.hidden=YES;
    centerhour_line5leftLabel.hidden=YES;
    centerhour_line1rightLabel.hidden=YES;
    centerhour_line2rightLabel.hidden=YES;
    centerhour_line3rightLabel.hidden=YES;
    centerhour_line4rightLabel.hidden=YES;
    centerhour_line5rightLabel.hidden=YES;
    centeremailbutton.hidden=YES;
    centerwebsitebutton.hidden=YES;
    centerothersbutton.hidden=YES;
    
    
    //show text field
    centernametext.hidden=NO;
    schoolregnumbertext.hidden=NO;
    centershortnametext.hidden=NO;
    centeraddresstext.hidden=NO;
    centercontacttext.hidden=NO;
    centerfaxtext.hidden=NO;
    centerwhatsapptext.hidden=NO;
    centerlattext.hidden=NO;
    centerlongtext.hidden=NO;
    centerhour_line1lefttext.hidden=NO;
    centerhour_line2lefttext.hidden=NO;
    centerhour_line3lefttext.hidden=NO;
    centerhour_line4lefttext.hidden=NO;
    centerhour_line5lefttext.hidden=NO;
    centerhour_line1righttext.hidden=NO;
    centerhour_line2righttext.hidden=NO;
    centerhour_line3righttext.hidden=NO;
    centerhour_line4righttext.hidden=NO;
    centerhour_line5righttext.hidden=NO;
    centeremailaddresstext.hidden=NO;
    centerwebsitetext.hidden=NO;
    centerotherstext.hidden=NO;
    scCenterInformationLanguage.hidden=NO;
    centerinfo_addimagebutton.hidden=NO;
    //centerinfo_deleteimagebutton.hidden=NO;
    
    centercontacticonimage.hidden=NO;
    centerfaxiconimage.hidden=NO;
    centerwhatsappiconimage.hidden=NO;
    centerlatlongiconimage.hidden=NO;
    centercontacticonimage.frame=CGRectMake(30, 87.5, 25, 25);
    centerfaxiconimage.frame=CGRectMake(30, 122.5, 25, 25);
    centerwhatsappiconimage.frame=CGRectMake(30, 157.5, 25, 25);
    centerlatlongiconimage.frame=CGRectMake(30, 192.5, 25, 25);
    
    
    title_Center_hours_except_center_holiday.frame=CGRectMake(30, 230, 344, 33);
    
    
    tmpcentername=globalvariables.centerrecord.centername;
    tmpschoolregnumber=globalvariables.centerrecord.schoolregnumber;
    tmpcentercontact=globalvariables.centerrecord.centercontact;
    tmpcenterfax=globalvariables.centerrecord.centerfax;
    tmpcenterwhatsapp=globalvariables.centerrecord.centerwhatsapp;
    workingCenter.maplat=globalvariables.centerrecord.maplat;
    workingCenter.maplong=globalvariables.centerrecord.maplong;
    tmpcenteremail=globalvariables.centerrecord.centeremail;
    tmpcenterwebsite=globalvariables.centerrecord.centerwebsite;
    tmpcenterothers=globalvariables.centerrecord.centerothers;
    tmpcenteraddress=globalvariables.centerrecord.centeraddress;
    tmpcenterhour_line1left=globalvariables.centerrecord.centerhour_line1left;
    tmpcenterhour_line2left=globalvariables.centerrecord.centerhour_line2left;
    tmpcenterhour_line3left=globalvariables.centerrecord.centerhour_line3left;
    tmpcenterhour_line4left=globalvariables.centerrecord.centerhour_line4left;
    tmpcenterhour_line5left=globalvariables.centerrecord.centerhour_line5left;
    tmpcenterhour_line1right=globalvariables.centerrecord.centerhour_line1right;
    tmpcenterhour_line2right=globalvariables.centerrecord.centerhour_line2right;
    tmpcenterhour_line3right=globalvariables.centerrecord.centerhour_line3right;
    tmpcenterhour_line4right=globalvariables.centerrecord.centerhour_line4right;
    tmpcenterhour_line5right=globalvariables.centerrecord.centerhour_line5right;
    tmpcenteraddress_chinese=globalvariables.centerrecord.centeraddress_chinese;
    tmpcenterhour_line1left_chinese=globalvariables.centerrecord.centerhour_line1left_chinese;
    tmpcenterhour_line2left_chinese=globalvariables.centerrecord.centerhour_line2left_chinese;
    tmpcenterhour_line3left_chinese=globalvariables.centerrecord.centerhour_line3left_chinese;
    tmpcenterhour_line4left_chinese=globalvariables.centerrecord.centerhour_line4left_chinese;
    tmpcenterhour_line5left_chinese=globalvariables.centerrecord.centerhour_line5left_chinese;
    tmpcenterhour_line1right_chinese=globalvariables.centerrecord.centerhour_line1right_chinese;
    tmpcenterhour_line2right_chinese=globalvariables.centerrecord.centerhour_line2right_chinese;
    tmpcenterhour_line3right_chinese=globalvariables.centerrecord.centerhour_line3right_chinese;
    tmpcenterhour_line4right_chinese=globalvariables.centerrecord.centerhour_line4right_chinese;
    tmpcenterhour_line5right_chinese=globalvariables.centerrecord.centerhour_line5right_chinese;
    tmpcentershortname_english=globalvariables.centerrecord.centershortname_english;
    tmpcentershortname_chinese=globalvariables.centerrecord.centershortname_chinese;

    
    
    tmpshopimagedata=[[NSData alloc]initWithData:UIImagePNGRepresentation(shopfrontimage.image)];
//    tmpmapimagedata=[[NSData alloc]initWithData:UIImagePNGRepresentation(mapimage.image)];
    tmplandscapeimagedata=[[NSData alloc]initWithData:UIImagePNGRepresentation(launchimage_landscape.image)];
    tmpportraitimagedata=[[NSData alloc]initWithData:UIImagePNGRepresentation(launchimage_portrait.image)];
    
    [self loadcenterinformationtext];
    centerinfo_editbutton.hidden=YES;
    centerinfo_cancelbutton.hidden=NO;
    centerinfo_savebutton.hidden=NO;
    
    //shopimageDeleted=FALSE;
    shopimageEdited=FALSE;
    //mapimageDeleted=FALSE;
//    mapimageEdited=FALSE;
    //landscapeimageDeleted=FALSE;
    landscapeimageEdited=FALSE;
    //portraitimageDeleted=FALSE;
    portraitimageEdited=FALSE;
    


}

-(void) centerinfo_cancelbuttonpressed
{
    //if (!centerinfo_editbutton.hidden) {
    [self loadcenterinformation];
    [self refreshlanguage];
        
    centernamelabel.hidden=NO;
    schoolregnumberTitle.hidden=NO;
    schoolregnumberLabel.hidden=NO;
    centershortnamelabel.hidden=NO;
    centeraddresslabel.hidden=NO;
    centercontactlabel.hidden=NO;
    centerfaxlabel.hidden=NO;
    centerwhatsapplabel.hidden=NO;
    centerlatlonglabel.hidden=NO;
    centerhour_line1leftLabel.hidden=NO;
    centerhour_line2leftLabel.hidden=NO;
    centerhour_line3leftLabel.hidden=NO;
    centerhour_line4leftLabel.hidden=NO;
    centerhour_line5leftLabel.hidden=NO;
    centerhour_line1rightLabel.hidden=NO;
    centerhour_line2rightLabel.hidden=NO;
    centerhour_line3rightLabel.hidden=NO;
    centerhour_line4rightLabel.hidden=NO;
    centerhour_line5rightLabel.hidden=NO;
    centeremailbutton.hidden=NO;
    centerwebsitebutton.hidden=NO;
    centerothersbutton.hidden=NO;
    
    
    //show text field
    centernametext.hidden=YES;
    schoolregnumbertext.hidden=YES;
    centershortnametext.hidden=YES;
    centeraddresstext.hidden=YES;
    centercontacttext.hidden=YES;
    centerfaxtext.hidden=YES;
    centerwhatsapptext.hidden=YES;
    centerlattext.hidden=YES;
    centerlongtext.hidden=YES;
    centerhour_line1lefttext.hidden=YES;
    centerhour_line2lefttext.hidden=YES;
    centerhour_line3lefttext.hidden=YES;
    centerhour_line4lefttext.hidden=YES;
    centerhour_line5lefttext.hidden=YES;
    centerhour_line1righttext.hidden=YES;
    centerhour_line2righttext.hidden=YES;
    centerhour_line3righttext.hidden=YES;
    centerhour_line4righttext.hidden=YES;
    centerhour_line5righttext.hidden=YES;
    centeremailaddresstext.hidden=YES;
    centerwebsitetext.hidden=YES;
    centerotherstext.hidden=YES;
    scCenterInformationLanguage.hidden=YES;
    centerinfo_addimagebutton.hidden=YES;
    //centerinfo_deleteimagebutton.hidden=YES;
    
    if (lastviewindex==0) {
        centerinfo_editbutton.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editcenterinformation;
    }else{
        centerinfo_editbutton.hidden=YES;
    }
    
    
        
        centerinfo_cancelbutton.hidden=YES;
        centerinfo_savebutton.hidden=YES;
    //}
    

    
}

-(void) loadcenterinformationtext
{

    
    centernametext.text=tmpcentername;
    schoolregnumbertext.text=tmpschoolregnumber;
    centercontacttext.text=tmpcentercontact;
    centerfaxtext.text=tmpcenterfax;
    centerwhatsapptext.text=tmpcenterwhatsapp;
    centeremailaddresstext.text=tmpcenteremail;
    centerwebsitetext.text=tmpcenterwebsite;
    centerotherstext.text=tmpcenterothers;
    centerlattext.text=workingCenter.maplat;
    centerlongtext.text=workingCenter.maplong;
    
    if (selectedMainImage==0) {
        [MyClass downloadImageWithImageview:mainimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.shopfrontimage image:@"Yes" async:YES];
    }/*else if (selectedMainImage==1){
        [MyClass downloadImageWithImageview:mainimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.mapimage image:@"Yes" async:YES];
    }*/else if (selectedMainImage==2){
        [MyClass downloadImageWithImageview:mainimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_landscape image:@"Yes" async:YES];
    }else if (selectedMainImage==3){
        [MyClass downloadImageWithImageview:mainimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_portrait image:@"Yes" async:YES];
    }
    
    [MyClass downloadImageWithImageview:shopfrontimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.shopfrontimage image:@"Yes" async:YES];
//    [MyClass downloadImageWithImageview:mapimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.mapimage image:@"Yes" async:YES];
    [MyClass downloadImageWithImageview:launchimage_landscape gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_landscape image:@"Yes" async:YES];
    [MyClass downloadImageWithImageview:launchimage_portrait gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_portrait image:@"Yes" async:YES];
    
    
    
    
    

    
    
    if (scCenterInformationLanguage.selectedSegmentIndex==1) {
        title_Center_hours_except_center_holiday.text=[MyClass returntitlewithtitle:@"Center hours (except center holiday)" language:@"Chinese"];
        title_Email.text=[MyClass returntitlewithtitle:@"Email" language:@"Chinese"];
        title_Website.text=[MyClass returntitlewithtitle:@"Website" language:@"Chinese"];
        title_Others.text=[MyClass returntitlewithtitle:@"Others" language:@"Chinese"];
        centeraddresstext.text=tmpcenteraddress_chinese;
        centerhour_line1lefttext.text=tmpcenterhour_line1left_chinese;
        centerhour_line2lefttext.text=tmpcenterhour_line2left_chinese;
        centerhour_line3lefttext.text=tmpcenterhour_line3left_chinese;
        centerhour_line1righttext.text=tmpcenterhour_line1right_chinese;
        centerhour_line2righttext.text=tmpcenterhour_line2right_chinese;
        centerhour_line3righttext.text=tmpcenterhour_line3right_chinese;
        centerhour_line4righttext.text=tmpcenterhour_line4right_chinese;
        centerhour_line5righttext.text=tmpcenterhour_line5right_chinese;
        centershortnametext.text=tmpcentershortname_chinese;
        
        centershortnametext.placeholder=[MyClass returntitlewithtitle:@"Center Short Name" language:@"Chinese"];
        centeraddresstext.placeholder=[MyClass returntitlewithtitle:@"Address" language:@"Chinese"];
        centercontacttext.placeholder=[MyClass returntitlewithtitle:@"Contact" language:@"Chinese"];
        centerfaxtext.placeholder=[MyClass returntitlewithtitle:@"Fax" language:@"Chinese"];
        centerwhatsapptext.placeholder=[MyClass returntitlewithtitle:@"Whatsapp" language:@"Chinese"];
        centerhour_line1lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 1)" language:@"Chinese"];
        centerhour_line2lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 2)" language:@"Chinese"];
        centerhour_line3lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 3)" language:@"Chinese"];
        centerhour_line4lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 4)" language:@"Chinese"];
        centerhour_line5lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 5)" language:@"Chinese"];
        centerhour_line1righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 1)" language:@"Chinese"];
        centerhour_line2righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 2)" language:@"Chinese"];
        centerhour_line3righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 3)" language:@"Chinese"];
        centerhour_line4righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 4)" language:@"Chinese"];
        centerhour_line5righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 5)" language:@"Chinese"];
        centeremailaddresstext.placeholder=[MyClass returntitlewithtitle:@"Email" language:@"Chinese"];
        centerwebsitetext.placeholder=[MyClass returntitlewithtitle:@"Website" language:@"Chinese"];
        centerotherstext.placeholder=[MyClass returntitlewithtitle:@"Others" language:@"Chinese"];
        centerlattext.placeholder=[MyClass returntitlewithtitle:@"Location Latitude" language:@"Chinese"];
        centerlongtext.placeholder=[MyClass returntitlewithtitle:@"Location Longitude" language:@"Chinese"];
        
    }else{
        title_Center_hours_except_center_holiday.text=[MyClass returntitlewithtitle:@"Center hours (except center holiday)" language:@"English"];
        title_Email.text=[MyClass returntitlewithtitle:@"Email" language:@"English"];
        title_Website.text=[MyClass returntitlewithtitle:@"Website" language:@"English"];
        title_Others.text=[MyClass returntitlewithtitle:@"Others" language:@"English"];
        centeraddresstext.text=tmpcenteraddress;
        centerhour_line1lefttext.text=tmpcenterhour_line1left;
        centerhour_line2lefttext.text=tmpcenterhour_line2left;
        centerhour_line3lefttext.text=tmpcenterhour_line3left;
        centerhour_line4lefttext.text=tmpcenterhour_line4left;
        centerhour_line5lefttext.text=tmpcenterhour_line5left;
        centerhour_line1righttext.text=tmpcenterhour_line1right;
        centerhour_line2righttext.text=tmpcenterhour_line2right;
        centerhour_line3righttext.text=tmpcenterhour_line3right;
        centerhour_line4righttext.text=tmpcenterhour_line4right;
        centerhour_line5righttext.text=tmpcenterhour_line5right;
        centershortnametext.text=tmpcentershortname_english;
        
        centershortnametext.placeholder=[MyClass returntitlewithtitle:@"Center Short Name" language:@"English"];
        centeraddresstext.placeholder=[MyClass returntitlewithtitle:@"Address" language:@"English"];
        centercontacttext.placeholder=[MyClass returntitlewithtitle:@"Contact" language:@"English"];
        centerfaxtext.placeholder=[MyClass returntitlewithtitle:@"Fax" language:@"English"];
        centerwhatsapptext.placeholder=[MyClass returntitlewithtitle:@"Whatsapp" language:@"English"];
        centerhour_line1lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 1)" language:@"English"];
        centerhour_line2lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 2)" language:@"English"];
        centerhour_line3lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 3)" language:@"English"];
        centerhour_line4lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 4)" language:@"English"];
        centerhour_line5lefttext.placeholder=[MyClass returntitlewithtitle:@"Days (line 5)" language:@"English"];
        centerhour_line1righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 1)" language:@"English"];
        centerhour_line2righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 2)" language:@"English"];
        centerhour_line3righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 3)" language:@"English"];
        centerhour_line4righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 4)" language:@"English"];
        centerhour_line5righttext.placeholder=[MyClass returntitlewithtitle:@"Hours (line 5)" language:@"English"];
        centeremailaddresstext.placeholder=[MyClass returntitlewithtitle:@"Email" language:@"English"];
        centerwebsitetext.placeholder=[MyClass returntitlewithtitle:@"Website" language:@"English"];
        centerotherstext.placeholder=[MyClass returntitlewithtitle:@"Others" language:@"English"];
        centerlattext.placeholder=[MyClass returntitlewithtitle:@"Location Latitude" language:@"English"];
        centerlongtext.placeholder=[MyClass returntitlewithtitle:@"Location Longitude" language:@"English"];
    }
    

}

-(void) changeeditcenterinformationlanguage
{
    [self loadcenterinformationtext];
}

-(void) changeeditpolicylanguage
{
    if ([policy_languageselected isEqualToString:@"english"]) {
        policy_languageselected=@"chinese";
    }else{
        policy_languageselected=@"english";
    }
    [self drawpolicycategorybutton];
    [policytable reloadData];
}

-(void) updatecenterinformationtext:(UITextField *)sender
{
    if (sender==centernametext) {
        tmpcentername=sender.text;
    }else if (sender==schoolregnumbertext){
        tmpschoolregnumber=sender.text;
    }else if (sender==centercontacttext){
        tmpcentercontact=sender.text;
    }else if (sender==centerfaxtext){
        tmpcenterfax=sender.text;
    }else if (sender==centerwhatsapptext){
        tmpcenterwhatsapp=sender.text;
    }else if (sender==centershortnametext){
        if (scCenterInformationLanguage.selectedSegmentIndex==0) {
            tmpcentershortname_english=sender.text;
        }else{
            tmpcentershortname_chinese=sender.text;
        }
    }else if (sender==centerhour_line1lefttext){
        if (scCenterInformationLanguage.selectedSegmentIndex==0) {
            tmpcenterhour_line1left=sender.text;
        }else{
            tmpcenterhour_line1left_chinese=sender.text;
        }
    }else if (sender==centerhour_line2lefttext){
        if (scCenterInformationLanguage.selectedSegmentIndex==0) {
            tmpcenterhour_line2left=sender.text;
        }else{
            tmpcenterhour_line2left_chinese=sender.text;
        }
    }else if (sender==centerhour_line3lefttext){
        if (scCenterInformationLanguage.selectedSegmentIndex==0) {
            tmpcenterhour_line3left=sender.text;
        }else{
            tmpcenterhour_line3left_chinese=sender.text;
        }
    }else if (sender==centerhour_line4lefttext){
        if (scCenterInformationLanguage.selectedSegmentIndex==0) {
            tmpcenterhour_line4left=sender.text;
        }else{
            tmpcenterhour_line4left_chinese=sender.text;
        }
    }else if (sender==centerhour_line5lefttext){
        if (scCenterInformationLanguage.selectedSegmentIndex==0) {
            tmpcenterhour_line5left=sender.text;
        }else{
            tmpcenterhour_line5left_chinese=sender.text;
        }
    }else if (sender==centerhour_line1righttext){
        if (scCenterInformationLanguage.selectedSegmentIndex==0) {
            tmpcenterhour_line1right=sender.text;
        }else{
            tmpcenterhour_line1right_chinese=sender.text;
        }
    }else if (sender==centerhour_line2righttext){
        if (scCenterInformationLanguage.selectedSegmentIndex==0) {
            tmpcenterhour_line2right=sender.text;
        }else{
            tmpcenterhour_line2right_chinese=sender.text;
        }
    }else if (sender==centerhour_line3righttext){
        if (scCenterInformationLanguage.selectedSegmentIndex==0) {
            tmpcenterhour_line3right=sender.text;
        }else{
            tmpcenterhour_line3right_chinese=sender.text;
        }
    }else if (sender==centerhour_line4righttext){
        if (scCenterInformationLanguage.selectedSegmentIndex==0) {
            tmpcenterhour_line4right=sender.text;
        }else{
            tmpcenterhour_line4right_chinese=sender.text;
        }
    }else if (sender==centerhour_line5righttext){
        if (scCenterInformationLanguage.selectedSegmentIndex==0) {
            tmpcenterhour_line5right=sender.text;
        }else{
            tmpcenterhour_line5right_chinese=sender.text;
        }
    }else if (sender==centeremailaddresstext){
        tmpcenteremail=sender.text;
    }else if (sender==centerwebsitetext){
        tmpcenterwebsite=sender.text;
    }else if (sender==centerotherstext){
        tmpcenterothers=sender.text;
    }else if (sender==centerlattext){
        if ([MyClass checkValidInput:sender.text Type:@"Float"]) {
            workingCenter.maplat=sender.text;
        }else{
            sender.text=workingCenter.maplat;
        }
    }else if(sender==centerlongtext){
        if ([MyClass checkValidInput:sender.text Type:@"Float"]) {
            workingCenter.maplong=sender.text;
        }else{
            sender.text=workingCenter.maplong;
        }
    }
}

/*
-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverPresentationController *)popoverController
{
    return NO;
}*/

-(void) textViewDidEndEditing:(UITextView *)textView
{
    if (textView==groupdescriptiontext){
        ((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).description=textView.text;
        
        [self updateGroupWithField:@"description" Value:textView.text groupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey];
        
        //NSIndexPath *current=[staff_groupnametable indexPathForSelectedRow];
        
        [staff_groupnametable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:selectedGroupNameRow inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [staff_groupnametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedGroupNameRow inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView==centeraddresstext) {
        if (scCenterInformationLanguage.selectedSegmentIndex==0) {
            tmpcenteraddress=textView.text;
        }else{
            tmpcenteraddress_chinese=textView.text;
        }
    }else{
        if (lastviewindex==7) {
            if (textView==receipttnctext) {
                globalvariables.centerrecord.receipttnc=textView.text;
                [MyClass updateCenterInformationWithField:@"centerreceipttnc" Value:textView.text];
            }else if (textView==invoicetnctext){
                globalvariables.centerrecord.invoicetnc=textView.text;
                [MyClass updateCenterInformationWithField:@"centerinvoicetnc" Value:textView.text];
            }else if (textView==leaveConfigRemarks){
                workingleavenatureobject.remarks=textView.text;
                [self updateLeaveNatureWithLeaveNatureListKey:workingleavenatureobject.leavenaturelistkey Key:@"remarks" Value:textView.text leavenatureconfigkey:nil reloadArray:NO];
            }else{
                [((PolicyRecord *)[((NSMutableArray *)[policyallcategory objectAtIndex:policy_selectedsegment]) objectAtIndex:textView.tag]) setValue:textView.text forKey:[NSString stringWithFormat:@"content%@",policy_languageselected]];
            }
        }
    }
}

-(void) centerinfo_savebuttonpressed
{

    [self.view endEditing:YES];
    if ([tmpcentername isEqualToString:@""]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Center Information"] message:[MyClass returntitlewithtitle:@"Please choose a center name"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if ([tmpcenteraddress isEqualToString:@""] && [tmpcenteraddress_chinese isEqualToString:@""]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Center Information"] message:[MyClass returntitlewithtitle:@"Please input the center address"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else{
        
        [self loadingindicatorwithoption:@"start"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reordercenteroperationhourline];

            //combine arrays
            NSDictionary *dictionary = @{@"centername" : tmpcentername,
                                         @"schoolregnumber": tmpschoolregnumber,
                                         @"centershortname_english" : tmpcentershortname_english,
                                         @"centershortname_chinese" : tmpcentershortname_chinese,
                                         @"centeraddress" : tmpcenteraddress,
                                         @"centeraddress_chinese" : tmpcenteraddress_chinese,
                                         @"centercontact" : tmpcentercontact,
                                         @"centerfax" : tmpcenterfax,
                                         @"centerwhatsapp" : tmpcenterwhatsapp,
                                         @"centeremail" : tmpcenteremail,
                                         @"centerwebsite" : tmpcenterwebsite,
                                         @"centerothers" : tmpcenterothers,
                                         @"maplat" : workingCenter.maplat,
                                         @"maplong" : workingCenter.maplong,
                                         @"centerhour_line1left" : tmpcenterhour_line1left,
                                         @"centerhour_line2left" : tmpcenterhour_line2left,
                                         @"centerhour_line3left" : tmpcenterhour_line3left,
                                         @"centerhour_line4left" : tmpcenterhour_line4left,
                                         @"centerhour_line5left" : tmpcenterhour_line5left,
                                         @"centerhour_line1right" : tmpcenterhour_line1right,
                                         @"centerhour_line2right" : tmpcenterhour_line2right,
                                         @"centerhour_line3right" : tmpcenterhour_line3right,
                                         @"centerhour_line4right" : tmpcenterhour_line4right,
                                         @"centerhour_line5right" : tmpcenterhour_line5right,
                                         @"centerhour_line1left_chinese" : tmpcenterhour_line1left_chinese,
                                         @"centerhour_line2left_chinese" : tmpcenterhour_line2left_chinese,
                                         @"centerhour_line3left_chinese" : tmpcenterhour_line3left_chinese,
                                         @"centerhour_line4left_chinese" : tmpcenterhour_line4left_chinese,
                                         @"centerhour_line5left_chinese" : tmpcenterhour_line5left_chinese,
                                         @"centerhour_line1right_chinese" : tmpcenterhour_line1right_chinese,
                                         @"centerhour_line2right_chinese" : tmpcenterhour_line2right_chinese,
                                         @"centerhour_line3right_chinese" : tmpcenterhour_line3right_chinese,
                                         @"centerhour_line4right_chinese" : tmpcenterhour_line4right_chinese,
                                         @"centerhour_line5right_chinese" : tmpcenterhour_line5right_chinese,
                                         //@"deletemainimage" : shopimageDeleted?globalvariables.centerrecord.shopfrontimage:@"",
                                         //@"deletemapimage" : mapimageDeleted?globalvariables.centerrecord.mapimage:@"",
                                         @"centerdb" : globalvariables.centerrecord.centerdb,
                                         @"centerkey" : globalvariables.centerrecord.centerkey,
                                         @"postaction" : @"updatecenterinformation"
                                         };
            
            __block BOOL result=FALSE;
            [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
                if (succeeded) {
                    result=TRUE;
                }
            }];

            
            if (result) {
                [self uploadcenterimagewithtype:@"shopfront" imagedata:tmpshopimagedata edited:shopimageEdited];
//                [self uploadcenterimagewithtype:@"map" imagedata:tmpmapimagedata edited:mapimageEdited];
                [self uploadcenterimagewithtype:@"landscape" imagedata:tmplandscapeimagedata edited:landscapeimageEdited];
                [self uploadcenterimagewithtype:@"portrait5" imagedata:tmpportraitimagedata edited:portraitimageEdited];
                [self uploadcenterimagewithtype:@"portrait4" imagedata:tmpportraitimagedata_4 edited:portraitimageEdited];
                
                shopimageEdited=FALSE;
//                mapimageEdited=FALSE;
                landscapeimageEdited=FALSE;
                portraitimageEdited=FALSE;
                
                [self centerinfo_cancelbuttonpressed];
                [self reloadPage];
            }else{
                [self loadingindicatorwithoption:@"stop"];
            }
            
        });
        
        
    }
}

- (void)centerinfo_addimagebuttonpressed {
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (hasCamera) {
        [self popupaddphotodialogueboxwithoption:@"add"];
    }else{
        [self addphotofromsource:@"library"];
    }
}

-(void) popupaddphotodialogueboxwithoption:(NSString *)option
{
    
        [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"PhotoSource" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 80) View:self Button:centerinfo_addimagebutton ItemsArray:[[NSMutableArray alloc]initWithObjects:@"Take Photo",@"Photo Library", nil] Title:nil];
    
    /*
    UIView *dialogueview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 100)];
    UIButton *TakePhotobutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, dialogueview.frame.size.width, dialogueview.frame.size.height/2)];
    [TakePhotobutton setTitleColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    TakePhotobutton.titleLabel.font=[UIFont systemFontOfSize:17];
    TakePhotobutton.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [TakePhotobutton setTitle:[MyClass returntitlewithtitle:@"Take Photo"] forState:UIControlStateNormal];
    [TakePhotobutton addTarget:self action:@selector(takephotobuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [dialogueview addSubview:TakePhotobutton];
    
    UIButton *PhotoLibrarybutton=[[UIButton alloc]initWithFrame:CGRectMake(0, dialogueview.frame.size.height/2, dialogueview.frame.size.width, dialogueview.frame.size.height/2)];
    [PhotoLibrarybutton setTitleColor:[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0] forState:UIControlStateNormal];
    PhotoLibrarybutton.titleLabel.font=[UIFont systemFontOfSize:17];
    PhotoLibrarybutton.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [PhotoLibrarybutton setTitle:[MyClass returntitlewithtitle:@"Photo Library"] forState:UIControlStateNormal];
    [PhotoLibrarybutton addTarget:self action:@selector(photolibrarybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [dialogueview addSubview:PhotoLibrarybutton];
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(0, dialogueview.frame.size.height/2, dialogueview.frame.size.width, 0.5)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [dialogueview addSubview:separator];
    
    UIViewController *dialoguevc=[[UIViewController alloc]init];
    dialoguevc.preferredContentSize=CGSizeMake(dialogueview.frame.size.width, dialogueview.frame.size.height);
    dialoguevc.view=dialogueview;
    dialoguevc.modalPresentationStyle=UIModalPresentationPopover;
    myPopoverController=dialoguevc.popoverPresentationController;
    //mypopovercontroller.delegate=self;
    myPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myPopoverController.sourceView=centerinfo_addimagebutton;
    myPopoverController.sourceRect=centerinfo_addimagebutton.bounds;

    [self presentViewController:dialoguevc animated:YES completion:nil];*/
}

-(void) addphotofromsource:(NSString *)source
{
    imagepicker = [[UIImagePickerController alloc] init];
    imagepicker.delegate = self;
    imagepicker.allowsEditing=NO;
    
    
    
    if ([source isEqualToString:@"camera"]) {
        [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.modalPresentationStyle = UIModalPresentationFullScreen;
        [MyClass presentViewController:imagepicker View:self];
        
        /*
        imagepicker.view.frame = CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
        [self.view addSubview:imagepicker.view];
        
        self.navigationItem.leftBarButtonItem.enabled=NO;
        self.navigationItem.rightBarButtonItem.enabled=NO;
        self.navigationItem.title=[MyClass returntitlewithtitle:@"Take Photo"];
        */
        
    }else{
        [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagepicker.modalPresentationStyle=UIModalPresentationPopover;
        myPopoverController=imagepicker.popoverPresentationController;
        myPopoverController.delegate=self;
        myPopoverController.permittedArrowDirections=UIPopoverArrowDirectionAny;
        myPopoverController.sourceView=centerinfo_addimagebutton;
        myPopoverController.sourceRect=centerinfo_addimagebutton.bounds;
        
        [self presentViewController:imagepicker animated:YES completion:nil];
    }
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"PhotoSource"]) {
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"Take Photo"]) {
            [self takephotobuttonpressed];
        }else if ([result isEqualToString:@"Photo Library"]){
            [self photolibrarybuttonpressed];
        }
    }else if ([datatype isEqualToString:@"CalendarDay"]){
        NSString *result=[selecteditems firstObject];

        if ([result isEqualToString:@"Holiday"]) {
            NSString *classcount=[self classExistsWithClassDate:selectedcalendardate];
            if (classcount) {
                if ([classcount intValue]>0) {
                    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Cannot be changed to Holiday"] message:[MyClass returntitlewithtitle:@"There are class(es) on this date"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [erroralert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [erroralert addAction:OKAction];
                    [self presentViewController:erroralert animated:YES completion:nil];
                    
                }else{
                    [self setCalendarWorkingDate:selectedcalendardate Option:@"H"];
                }
            }
        }else if ([result isEqualToString:@"Reserve"]){
            [self setCalendarWorkingDate:selectedcalendardate Option:@"R"];
        }else if ([result isEqualToString:@"Working Day"]){
            [self setCalendarWorkingDate:selectedcalendardate Option:@"W"];
        }
    }else if ([datatype isEqualToString:@"productCategory"]){
        [self drawpointerwithoption:@"closed" button:ProductCategorySelectionButton];
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"All Categories"]){
            productcategoryselected = @"All";
        }else{
            productcategoryselected=result;
        }
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self retrieveProductListwithresetcategoryfilter:NO flushcachedata:YES]) {
                [ProductCategorySelectionButton setTitle:[productcategoryselected isEqualToString:@"All"]?[MyClass returntitlewithtitle:@"All Categories"]:productcategoryselected forState:UIControlStateNormal];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }
        });
    }else if ([datatype isEqualToString:@"subjectCategory"]){
        [self drawpointerwithoption:@"closed" button:SubjectCategorySelectionButton];
        NSString *result=[selecteditems firstObject];
        subjectcategoryselected=result;
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            subjectArray=[MyClass retrievecentersubjectinformationwithstatus:[subjectstatusarray objectAtIndex:scsubjectstatus.selectedSegmentIndex] category:subjectcategoryselected flushcachedata:NO];
            [self returnfiltersubjectarray];
            if ([subjectcategoryselected isEqualToString:@"All"]) {
                [SubjectCategorySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Categories"] forState:UIControlStateNormal];
            }else{
                [SubjectCategorySelectionButton setTitle:[MyClass returnsubjectcategorynamewithscategorykey:subjectcategoryselected] forState:UIControlStateNormal];
            }
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            
        });
    }
}

-(void) photolibrarybuttonpressed
{
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addphotofromsource:@"library"];
}

-(void) takephotobuttonpressed
{
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addphotofromsource:@"camera"];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];//info[UIImagePickerControllerEditedImage];


    if (selectedMainImage==0) {
        tmpshopimagedata=[MyClass returnCompressedImageDataWithImage:[MyClass resizeImageWithImage:chosenImage ForSize:CGSizeMake(512, 384)]];
        //tmpshopimagedata=UIImageJPEGRepresentation([MyClass resizeImageWithImage:chosenImage ForSize:CGSizeMake(512, 384)], 1.0);
        
        
        [mainimage setImage:[MyClass resizeImageWithImage:[[UIImage alloc] initWithData:tmpshopimagedata] ForSize:CGSizeMake(mainimage.frame.size.width,mainimage.frame.size.height)]];
        [shopfrontimage setImage:mainimage.image];
        shopimageEdited=TRUE;
    }/*else if (selectedMainImage==1){
        tmpmapimagedata=[MyClass returnCompressedImageDataWithImage:[MyClass resizeImageWithImage:chosenImage ForSize:CGSizeMake(512, 384)]];
        
        //tmpmapimagedata=UIImageJPEGRepresentation([MyClass resizeImageWithImage:chosenImage ForSize:CGSizeMake(512, 384)], 1.0);
        [mainimage setImage:[MyClass resizeImageWithImage:[[UIImage alloc] initWithData:tmpmapimagedata] ForSize:CGSizeMake(mainimage.frame.size.width,mainimage.frame.size.height)]];
        [mapimage setImage:mainimage.image];
        mapimageEdited=TRUE;
    }*/else if (selectedMainImage==2){
        tmplandscapeimagedata=[MyClass returnCompressedImageDataWithImage:[MyClass resizeImageWithImage:chosenImage ForSize:CGSizeMake(1024, 768)]];
        
        //tmplandscapeimagedata=UIImageJPEGRepresentation([MyClass resizeImageWithImage:chosenImage ForSize:CGSizeMake(1024, 768)], 1.0);
        [mainimage setImage:[MyClass resizeImageWithImage:[[UIImage alloc] initWithData:tmplandscapeimagedata] ForSize:CGSizeMake(mainimage.frame.size.width,mainimage.frame.size.height)]];
        [launchimage_landscape setImage:mainimage.image];
        landscapeimageEdited=TRUE;
    }else if (selectedMainImage==3){
        tmpportraitimagedata=[MyClass returnCompressedImageDataWithImage:[MyClass resizeImageWithImage:chosenImage ForSize:CGSizeMake(640, 1136)]];
        tmpportraitimagedata_4=[MyClass returnCompressedImageDataWithImage:[MyClass resizeImageWithImage:chosenImage ForSize:CGSizeMake(640, 960)]];
        
        //tmpportraitimagedata=UIImageJPEGRepresentation([MyClass resizeImageWithImage:chosenImage ForSize:CGSizeMake(640, 1136)], 0.6);
        //tmpportraitimagedata_4=UIImageJPEGRepresentation([MyClass resizeImageWithImage:chosenImage ForSize:CGSizeMake(640, 960)], 0.6);
        [mainimage setImage:[MyClass resizeImageWithImage:[[UIImage alloc] initWithData:tmpportraitimagedata] ForSize:CGSizeMake(mainimage.frame.size.height*640/1136,mainimage.frame.size.height)]];
        [launchimage_portrait setImage:mainimage.image];
        portraitimageEdited=TRUE;
    }

    runviewdidappear=FALSE;
[imagepicker dismissViewControllerAnimated:YES completion:nil];

    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    runviewdidappear=FALSE;
    [imagepicker dismissViewControllerAnimated:YES completion:nil];

}



-(void) uploadcenterimagewithtype:(NSString *)type imagedata:(NSData *)imagedata edited:(BOOL)edited
{
    if (edited){
        NSData *imageData = imagedata;     //change Image to NSData
        
        if (imageData != nil){

            NSString *boundary = @"---------------------------14737809831466499882746641449";
            //NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
            //[request addValue:contentType forHTTPHeaderField: @"Content-Type"];
            
            NSMutableData *body = [NSMutableData data];
            
            // add parameters
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            
            //add image data
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@##%@_%@.jpg\"\r\n",globalvariables.centerrecord.centerdb,type,globalvariables.centerrecord.centerkey] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[NSData dataWithData:imageData]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            //  parameter action
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"postaction\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"imageupload" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            
            [MyClass callPOSTwithData:body Boundary:boundary completionBlock:^(BOOL succeeded, NSData *data) {
                if (succeeded) {
                    NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    NSLog(@"File uploaded: %@",returnString);
                }
            }];

        }
    }
}

-(void) reordercenteroperationhourline
{
    NSMutableArray *leftarray=[[NSMutableArray alloc]init];
    NSMutableArray *rightarray=[[NSMutableArray alloc]init];
    NSMutableArray *leftarray_chinese=[[NSMutableArray alloc]init];
    NSMutableArray *rightarray_chinese=[[NSMutableArray alloc]init];
    
    if (![tmpcenterhour_line1left isEqualToString:@""] || ![tmpcenterhour_line1right isEqualToString:@""]) {
        [leftarray addObject:tmpcenterhour_line1left];
        [rightarray addObject:tmpcenterhour_line1right];
    }

    if (![tmpcenterhour_line2left isEqualToString:@""] || ![tmpcenterhour_line2right isEqualToString:@""]) {
        [leftarray addObject:tmpcenterhour_line2left];
        [rightarray addObject:tmpcenterhour_line2right];
    }
    
    if (![tmpcenterhour_line3left isEqualToString:@""] || ![tmpcenterhour_line3right isEqualToString:@""]) {
        [leftarray addObject:tmpcenterhour_line3left];
        [rightarray addObject:tmpcenterhour_line3right];
    }
    
    if (![tmpcenterhour_line4left isEqualToString:@""] || ![tmpcenterhour_line4right isEqualToString:@""]) {
        [leftarray addObject:tmpcenterhour_line4left];
        [rightarray addObject:tmpcenterhour_line4right];
    }
    
    if (![tmpcenterhour_line5left isEqualToString:@""] || ![tmpcenterhour_line5right isEqualToString:@""]) {
        [leftarray addObject:tmpcenterhour_line5left];
        [rightarray addObject:tmpcenterhour_line5right];
    }
    
    if (leftarray.count>0) {
        tmpcenterhour_line1left=[leftarray objectAtIndex:0];
        tmpcenterhour_line1right=[rightarray objectAtIndex:0];
    }else{
        tmpcenterhour_line1left=@"";
        tmpcenterhour_line1right=@"";
    }

    if (leftarray.count>1) {
        tmpcenterhour_line2left=[leftarray objectAtIndex:1];
        tmpcenterhour_line2right=[rightarray objectAtIndex:1];
    }else{
        tmpcenterhour_line2left=@"";
        tmpcenterhour_line2right=@"";
    }
    
    if (leftarray.count>2) {
        tmpcenterhour_line3left=[leftarray objectAtIndex:2];
        tmpcenterhour_line3right=[rightarray objectAtIndex:2];
    }else{
        tmpcenterhour_line3left=@"";
        tmpcenterhour_line3right=@"";
    }
    
    if (leftarray.count>3) {
        tmpcenterhour_line4left=[leftarray objectAtIndex:3];
        tmpcenterhour_line4right=[rightarray objectAtIndex:3];
    }else{
        tmpcenterhour_line4left=@"";
        tmpcenterhour_line4right=@"";
    }
    
    if (leftarray.count>4) {
        tmpcenterhour_line5left=[leftarray objectAtIndex:4];
        tmpcenterhour_line5right=[rightarray objectAtIndex:4];
    }else{
        tmpcenterhour_line5left=@"";
        tmpcenterhour_line5right=@"";
    }


    
    if (![tmpcenterhour_line1left_chinese isEqualToString:@""] || ![tmpcenterhour_line1right_chinese isEqualToString:@""]) {
        [leftarray_chinese addObject:tmpcenterhour_line1left_chinese];
        [rightarray_chinese addObject:tmpcenterhour_line1right_chinese];
    }
    
    if (![tmpcenterhour_line2left_chinese isEqualToString:@""] || ![tmpcenterhour_line2right_chinese isEqualToString:@""]) {
        [leftarray_chinese addObject:tmpcenterhour_line2left_chinese];
        [rightarray_chinese addObject:tmpcenterhour_line2right_chinese];
    }
    
    if (![tmpcenterhour_line3left_chinese isEqualToString:@""] || ![tmpcenterhour_line3right_chinese isEqualToString:@""]) {
        [leftarray_chinese addObject:tmpcenterhour_line3left_chinese];
        [rightarray_chinese addObject:tmpcenterhour_line3right_chinese];
    }
    
    if (![tmpcenterhour_line4left_chinese isEqualToString:@""] || ![tmpcenterhour_line4right_chinese isEqualToString:@""]) {
        [leftarray_chinese addObject:tmpcenterhour_line4left_chinese];
        [rightarray_chinese addObject:tmpcenterhour_line4right_chinese];
    }
    
    if (![tmpcenterhour_line5left_chinese isEqualToString:@""] || ![tmpcenterhour_line5right_chinese isEqualToString:@""]) {
        [leftarray_chinese addObject:tmpcenterhour_line5left_chinese];
        [rightarray_chinese addObject:tmpcenterhour_line5right_chinese];
    }
    
    if (leftarray_chinese.count>0) {
        tmpcenterhour_line1left_chinese=[leftarray_chinese objectAtIndex:0];
        tmpcenterhour_line1right_chinese=[rightarray_chinese objectAtIndex:0];
    }else{
        tmpcenterhour_line1left_chinese=@"";
        tmpcenterhour_line1right_chinese=@"";
    }
    
    if (leftarray_chinese.count>1) {
        tmpcenterhour_line2left_chinese=[leftarray_chinese objectAtIndex:1];
        tmpcenterhour_line2right_chinese=[rightarray_chinese objectAtIndex:1];
    }else{
        tmpcenterhour_line2left_chinese=@"";
        tmpcenterhour_line2right_chinese=@"";
    }
    
    if (leftarray_chinese.count>2) {
        tmpcenterhour_line3left_chinese=[leftarray_chinese objectAtIndex:2];
        tmpcenterhour_line3right_chinese=[rightarray_chinese objectAtIndex:2];
    }else{
        tmpcenterhour_line3left_chinese=@"";
        tmpcenterhour_line3right_chinese=@"";
    }
    
    if (leftarray_chinese.count>3) {
        tmpcenterhour_line4left_chinese=[leftarray_chinese objectAtIndex:3];
        tmpcenterhour_line4right_chinese=[rightarray_chinese objectAtIndex:3];
    }else{
        tmpcenterhour_line4left_chinese=@"";
        tmpcenterhour_line4right_chinese=@"";
    }
    
    if (leftarray_chinese.count>4) {
        tmpcenterhour_line5left_chinese=[leftarray_chinese objectAtIndex:4];
        tmpcenterhour_line5right_chinese=[rightarray_chinese objectAtIndex:4];
    }else{
        tmpcenterhour_line5left_chinese=@"";
        tmpcenterhour_line5right_chinese=@"";
    }


}

-(void) gotostudentprofile:(NSString *)studentkey enrollmentkey:(NSString *)enrollmentkey
{
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    mainVC.leftMenu.prepareforsegue=TRUE;
    mainVC.leftMenu.sourceview=@"marketingpromotion";
    mainVC.leftMenu.studentprofile_studentkey=studentkey;
    mainVC.leftMenu.studentprofile_classkeys=[[ClassKeys alloc]initClassKeysWithEnrollmentkey:enrollmentkey Classkey:@""];
    mainVC.leftMenu.studentprofile_submenu=1;
    //mainVC.leftMenu.studentprofile_key=enrollmentkey;
    //mainVC.leftMenu.studentinformationaction=@"Redirect";
    globalvariables.leftmenuindex=@"1";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
}

-(void) staff_usergroupbuttonpressed
{
    selectedGroupNameRow=0;
    [self determinegroupcount];
    UIView *masterview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 860, 600)];
    masterview.backgroundColor=[UIColor colorWithRed:165.0/255.0 green:188.0/255.0 blue:213.0/255.0 alpha:1.0];

    memberview=[[UIView alloc]initWithFrame:CGRectMake(0, 65, masterview.frame.size.width, masterview.frame.size.height-65-55)];
    memberview.backgroundColor=groupactivecolor;
    [masterview addSubview:memberview];
    
    groupview=[[UIView alloc]initWithFrame:CGRectMake(0, 65, masterview.frame.size.width, masterview.frame.size.height-65-55)];
    groupview.backgroundColor=groupactivecolor;
    [masterview addSubview:groupview];

    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 30, 30)];
    [image setImage:[UIImage imageNamed:@"group_icon.png"]];
    [masterview addSubview:image];
    image.layer.cornerRadius=5;
    image.layer.masksToBounds=YES;
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, groupview.frame.size.width-40, 60)];
    label.font=[UIFont boldSystemFontOfSize:18];
    label.textColor=[UIColor whiteColor];
    label.text=[MyClass returntitlewithtitle:@"Staff Group Setup"];
    [masterview addSubview:label];
    
    UIView *buttonview=[[UIView alloc]initWithFrame:CGRectMake(groupview.frame.origin.x+groupview.frame.size.width-160*2, groupview.frame.origin.y-40, 160*2+5, 45)];
    buttonview.layer.cornerRadius=7;
    buttonview.layer.masksToBounds=YES;
    [masterview addSubview:buttonview];
    
    groupbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 160, 40)];
    [groupbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [groupbutton setTitle:[MyClass returntitlewithtitle:@"Group"] forState:UIControlStateNormal];
    [groupbutton setBackgroundColor:groupactivecolor];
    [groupbutton addTarget:self action:@selector(groupbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [buttonview addSubview:groupbutton];
    
    memberbutton=[[UIButton alloc]initWithFrame:CGRectMake(groupbutton.frame.origin.x+groupbutton.frame.size.width, groupbutton.frame.origin.y, groupbutton.frame.size.width, groupbutton.frame.size.height)];
    [memberbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [memberbutton setTitle:[MyClass returntitlewithtitle:@"Member"] forState:UIControlStateNormal];
    [memberbutton addTarget:self action:@selector(memberbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [memberbutton setBackgroundColor:groupinactivecolor];
    [buttonview addSubview:memberbutton];
    
    
    staff_groupnametable=[[UITableView alloc]initWithFrame:CGRectMake(1, 8, 320, groupview.frame.size.height-38-8) style:UITableViewStyleGrouped];
    staff_groupnametable.backgroundColor=[UIColor whiteColor];
    staff_groupnametable.delegate=self;
    staff_groupnametable.dataSource=self;
    [groupview addSubview:staff_groupnametable];
    
    
    staff_groupdetailstable=[[UITableView alloc]initWithFrame:CGRectMake(staff_groupnametable.frame.origin.x+staff_groupnametable.frame.size.width, staff_groupnametable.frame.origin.y, groupview.frame.size.width-staff_groupnametable.frame.size.width-2*staff_groupnametable.frame.origin.x, groupview.frame.size.height-8) style:UITableViewStyleGrouped];
    staff_groupdetailstable.delegate=self;
    staff_groupdetailstable.dataSource=self;
    [groupview addSubview:staff_groupdetailstable];
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(staff_groupnametable.frame.origin.x, staff_groupnametable.frame.origin.y+staff_groupnametable.frame.size.height, staff_groupnametable.frame.size.width, 38)];
    separator.backgroundColor=[UIColor colorWithRed:185.0/255.0 green:185.0/255.0 blue:185.0/255.0 alpha:1];
    [groupview addSubview: separator];
    
    UIButton *addbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
    //addbutton.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0];
    addbutton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [addbutton setImage:[UIImage imageNamed:@"addbuttonwhite_icon.png"] forState:UIControlStateNormal];
    addbutton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [addbutton addTarget:self action:@selector(addgroup:) forControlEvents:UIControlEventTouchUpInside];
    [separator addSubview:addbutton];
    
    UIButton *deletebutton=[[UIButton alloc]initWithFrame:CGRectMake(staff_groupnametable.frame.size.width-38, 0, 38, 38)];
    //deletebutton.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0];
    deletebutton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [deletebutton setImage:[UIImage imageNamed:@"minusbuttonwhite_icon.png"] forState:UIControlStateNormal];
    deletebutton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [deletebutton addTarget:self action:@selector(deletegroup:) forControlEvents:UIControlEventTouchUpInside];
    [separator addSubview:deletebutton];
    
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_groupnametable.frame.origin.x, staff_groupnametable.frame.origin.y, staff_groupnametable.frame.size.width+staff_groupdetailstable.frame.size.width, 0.5)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [groupview addSubview: separator];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_groupnametable.frame.origin.x, staff_groupnametable.frame.origin.y+staff_groupdetailstable.frame.size.height, staff_groupnametable.frame.size.width+staff_groupdetailstable.frame.size.width, 0.5)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [groupview addSubview: separator];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_groupnametable.frame.origin.x, staff_groupnametable.frame.origin.y, 0.5, staff_groupdetailstable.frame.size.height)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [groupview addSubview: separator];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_groupnametable.frame.origin.x+staff_groupnametable.frame.size.width, staff_groupnametable.frame.origin.y, 0.5, staff_groupdetailstable.frame.size.height)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [groupview addSubview: separator];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_groupnametable.frame.origin.x+staff_groupnametable.frame.size.width+staff_groupdetailstable.frame.size.width, staff_groupnametable.frame.origin.y, 0.5, staff_groupdetailstable.frame.size.height)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [groupview addSubview: separator];
    
    [staff_groupnametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    
    
    staff_membertable=[[UITableView alloc]initWithFrame:CGRectMake(1, 8, 220, memberview.frame.size.height-8) style:UITableViewStylePlain];
    //staff_membertable.backgroundColor=[UIColor whiteColor];
    staff_membertable.delegate=self;
    staff_membertable.dataSource=self;
    [memberview addSubview:staff_membertable];
    
    staff_membergroupview=[[UIScrollView alloc]initWithFrame:CGRectMake(staff_membertable.frame.origin.x+staff_membertable.frame.size.width, staff_membertable.frame.origin.y, memberview.frame.size.width-staff_membertable.frame.size.width-staff_membertable.frame.origin.x*2, staff_membertable.frame.size.height)];
    [memberview addSubview:staff_membergroupview];
    
    float width=(staff_membergroupview.frame.size.width/GroupArray.count>100)?staff_membergroupview.frame.size.width/GroupArray.count:100;
    staff_membergrouptable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, GroupArray.count*width, staff_membergroupview.frame.size.height) style:UITableViewStylePlain];
    //staff_membertable.backgroundColor=[UIColor whiteColor];
    staff_membergrouptable.delegate=self;
    staff_membergrouptable.dataSource=self;
    [staff_membergroupview addSubview:staff_membergrouptable];
    if ([staff_membergrouptable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        staff_membergrouptable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    staff_membergroupview.contentSize=CGSizeMake(staff_membergrouptable.frame.size.width, staff_membergroupview.frame.size.height);
    
    
    
    
    
    UIButton *closebutton =[[UIButton alloc]initWithFrame:CGRectMake(masterview.frame.size.width-100-20,masterview.frame.size.height-35-10,100,35)];
    [closebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [closebutton setTitle:[MyClass returntitlewithtitle:@"Close"] forState:UIControlStateNormal];
    closebutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    closebutton.backgroundColor=[UIColor whiteColor];
    closebutton.layer.borderWidth=1;
    closebutton.layer.cornerRadius=4;
    closebutton.layer.masksToBounds=YES;
    closebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    closebutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [closebutton addTarget: self action:@selector(group_closebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [closebutton addTarget: self action:@selector(privilege_buttonhighlightcolor:) forControlEvents: UIControlEventTouchDown];
    [closebutton addTarget: self action:@selector(privilege_buttonresetcolor:) forControlEvents: UIControlEventTouchCancel];
    [closebutton addTarget: self action:@selector(privilege_buttonresetcolor:) forControlEvents: UIControlEventTouchUpOutside];
    
    //UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
    
    
    //spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(0, closebutton.frame.origin.y-10, masterview.frame.size.width, 55)];
    separator.backgroundColor=groupactivecolor;
    [masterview addSubview:separator];
    
    
    [masterview addSubview:closebutton];
    
    
    
    userprivilegeviewcontroller=[[UIViewController alloc]init];
    userprivilegeviewcontroller.preferredContentSize=CGSizeMake(masterview.frame.size.width, masterview.frame.size.height);
    userprivilegeviewcontroller.view=masterview;
    
    if (@available(iOS 13.0, *)) {
        userprivilegeviewcontroller.modalInPresentation=TRUE;
    }
    
    userprivilegeviewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
    userprivilegeviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:userprivilegeviewcontroller animated:YES completion: nil];

    
}

-(void) groupbuttonpressed
{
    [self determinegroupcount];
    [staff_groupnametable reloadData];
    groupview.hidden=NO;
    memberview.hidden=YES;
    [groupbutton setBackgroundColor:groupactivecolor];
    [memberbutton setBackgroundColor:groupinactivecolor];
    [groupbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [memberbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void) memberbuttonpressed
{
    float width=(staff_membergroupview.frame.size.width/GroupArray.count>100)?staff_membergroupview.frame.size.width/GroupArray.count:100;
    staff_membergrouptable.frame=CGRectMake(staff_membergrouptable.frame.origin.x, staff_membergrouptable.frame.origin.y, width*GroupArray.count, staff_membergrouptable.frame.size.height);
    staff_membergroupview.contentSize=CGSizeMake(staff_membergrouptable.frame.size.width, staff_membergroupview.frame.size.height);
    [staff_membergrouptable reloadData];
    groupview.hidden=YES;
    memberview.hidden=NO;
    [groupbutton setBackgroundColor:groupinactivecolor];
    [memberbutton setBackgroundColor:groupactivecolor];
    [groupbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [memberbutton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}


-(void) staff_userprivilegebuttonpressed
{
    selectedPrivilegeNameRow=0;
    [self determineprivilegecount];
    //privilegenameupdated=FALSE;
    localprivilegearray=[MyClass retrieveprivilegewithflushcachedata:YES];
    
    UIView *userprivilegeview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 860, 600)];
    userprivilegeview.backgroundColor=[UIColor whiteColor];
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 30, 30)];
    [image setImage:[UIImage imageNamed:@"privilege_icon.png"]];
    [userprivilegeview addSubview:image];
    image.layer.cornerRadius=5;
    image.layer.masksToBounds=YES;
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, userprivilegeview.frame.size.width-40, 60)];
    label.font=[UIFont boldSystemFontOfSize:18];
    label.textColor=[UIColor blackColor];
    label.text=[MyClass returntitlewithtitle:@"User Privilege Setup"];
    [userprivilegeview addSubview:label];
    
    
    
    
    staff_privilegenametable=[[UITableView alloc]initWithFrame:CGRectMake(20, 65, 320, userprivilegeview.frame.size.height-135-38) style:UITableViewStyleGrouped];
    staff_privilegenametable.delegate=self;
    staff_privilegenametable.dataSource=self;
    
    staff_privilegedetailstable=[[UITableView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x+staff_privilegenametable.frame.size.width, 65, userprivilegeview.frame.size.width-40-staff_privilegenametable.frame.size.width, userprivilegeview.frame.size.height-135) style:UITableViewStyleGrouped];
    staff_privilegedetailstable.delegate=self;
    staff_privilegedetailstable.dataSource=self;
    [userprivilegeview addSubview:staff_privilegenametable];
    [userprivilegeview addSubview:staff_privilegedetailstable];
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x, staff_privilegenametable.frame.origin.y+staff_privilegenametable.frame.size.height, staff_privilegenametable.frame.size.width, 38)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [userprivilegeview addSubview: separator];
    
    UIButton *addbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
    //addbutton.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0];
    addbutton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [addbutton setImage:[UIImage imageNamed:@"addbuttonwhite_icon.png"] forState:UIControlStateNormal];
    addbutton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [addbutton addTarget:self action:@selector(addprivilege:) forControlEvents:UIControlEventTouchUpInside];
    [separator addSubview:addbutton];
    
    UIButton *deletebutton=[[UIButton alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.size.width-38, 0, 38, 38)];
    //deletebutton.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0];
    deletebutton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [deletebutton setImage:[UIImage imageNamed:@"minusbuttonwhite_icon.png"] forState:UIControlStateNormal];
    deletebutton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [deletebutton addTarget:self action:@selector(deleteprivilege:) forControlEvents:UIControlEventTouchUpInside];
    [separator addSubview:deletebutton];
    
    
    
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x, staff_privilegenametable.frame.origin.y, staff_privilegenametable.frame.size.width+staff_privilegedetailstable.frame.size.width, 0.5)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [userprivilegeview addSubview: separator];

    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x, staff_privilegenametable.frame.origin.y+staff_privilegedetailstable.frame.size.height, staff_privilegenametable.frame.size.width+staff_privilegedetailstable.frame.size.width, 0.5)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [userprivilegeview addSubview: separator];

    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x, staff_privilegenametable.frame.origin.y, 0.5, staff_privilegedetailstable.frame.size.height)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [userprivilegeview addSubview: separator];

    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x+staff_privilegenametable.frame.size.width, staff_privilegenametable.frame.origin.y, 0.5, staff_privilegedetailstable.frame.size.height)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [userprivilegeview addSubview: separator];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x+staff_privilegenametable.frame.size.width+staff_privilegedetailstable.frame.size.width, staff_privilegenametable.frame.origin.y, 0.5, staff_privilegedetailstable.frame.size.height)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [userprivilegeview addSubview: separator];
    
    [staff_privilegenametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    
    privilegedetailsarray=[[NSArray alloc]initWithObjects:
                           
                           
                           [[NSArray alloc]initWithObjects: @"Main Menu Item",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Student Profile",@"viewstudentprofile", nil],
                            [[NSArray alloc]initWithObjects:@"Daily Class Schedule",@"viewdailyclassschedule", nil],
                            [[NSArray alloc]initWithObjects:@"Center Time Table",@"viewclasstimetable", nil],
                            [[NSArray alloc]initWithObjects:@"Course Renewal",@"viewclassrenewal", nil],
                            [[NSArray alloc]initWithObjects:@"Financial Information",@"viewpaymentinformation", nil],
                            [[NSArray alloc]initWithObjects:@"Message Center",@"viewmessagecenter", nil],
                            [[NSArray alloc]initWithObjects:@"Photo Corner",@"viewclassphoto", nil],
                            [[NSArray alloc]initWithObjects:@"Task and Request",@"viewtaskassignment", nil],
                            [[NSArray alloc]initWithObjects:@"Lead Profile",@"viewleadprofile", nil],
                            [[NSArray alloc]initWithObjects:@"Assessment and Trial",@"viewassessment", nil],
                            [[NSArray alloc]initWithObjects:@"Center Information",@"viewcenterinformation", nil],
                            [[NSArray alloc]initWithObjects:@"Settings",@"viewsettings", nil],
                             [[NSArray alloc]initWithObjects:@"Change Log",@"viewchangelog", nil],
                            nil],
                            nil],
                           
                           [[NSArray alloc]initWithObjects:@"Enrollment",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Void Enrollment",@"voidenrollment", nil],
                             [[NSArray alloc]initWithObjects:@"Delete Enrollment",@"deleteenrollment", nil],
                             [[NSArray alloc]initWithObjects:@"Transfer Enrollment",@"transferenrollment", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Makeup Quota",@"editmakeupquota", nil],
                             [[NSArray alloc]initWithObjects:@"Enable Request Action",@"enablerequestaction", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Enrollment Fee",@"editenrollmentfee", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Enrollment Date",@"editenrollmentdate", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Bill Date",@"editbilldate", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Class for Expired Promotion",@"editclassforexpiredpromotion", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Class for Paid Enrollment",@"editclassforpaidenrollment", nil],
                             nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"Sales",
                             [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Void Sales",@"voidsales", nil],
                             [[NSArray alloc]initWithObjects:@"Delete Sales",@"deletesales", nil],
                              [[NSArray alloc]initWithObjects:@"Change Sales Product",@"changesalesproduct", nil],
                             nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"Subject",
                             [[NSArray alloc]initWithObjects:
                              [[NSArray alloc]initWithObjects:@"Show Course Page",@"showcentercoursepage", nil],
                             [[NSArray alloc]initWithObjects:@"Add Subject",@"addsubject", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Course",@"editsubject", nil],
                              [[NSArray alloc]initWithObjects:@"Edit User Schedule",@"edituserschedule", nil],
                              [[NSArray alloc]initWithObjects:@"Edit Makeup Settings",@"editmakeupsettings", nil],
                             nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"Classroom",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Show Classroom Page",@"showcenterclassroompage", nil],
                             [[NSArray alloc]initWithObjects:@"Add Classroom",@"addclassroom", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Classroom",@"editclassroom", nil],
                             nil],nil],
                           
                           ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editstaff?
                           [[NSArray alloc]initWithObjects:@"Staff",
                             [[NSArray alloc]initWithObjects:
                              [[NSArray alloc]initWithObjects:@"Show Staff Page",@"showcenterstaffpage", nil],
                             [[NSArray alloc]initWithObjects:@"Add Staff",@"addstaff", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Staff",@"editstaff", nil],
                              [[NSArray alloc]initWithObjects:@"Edit Privilege",@"editstaffprivilege", nil],
                              nil],nil]:[[NSArray alloc]initWithObjects:@"Staff",
                                         [[NSArray alloc]initWithObjects:
                                          [[NSArray alloc]initWithObjects:@"Show Staff Page",@"showcenterstaffpage", nil],
                                         [[NSArray alloc]initWithObjects:@"Add Staff",@"addstaff", nil],
                                         [[NSArray alloc]initWithObjects:@"Edit Staff",@"editstaff", nil],
                                         nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"Product",
                             [[NSArray alloc]initWithObjects:
                              [[NSArray alloc]initWithObjects:@"Show Product Page",@"showcenterproductpage", nil],
                             [[NSArray alloc]initWithObjects:@"Add Product",@"addproduct", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Product",@"editproduct", nil],
                             nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"Marketing",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Show Marketing Page",@"showcentermarketingpage", nil],
                             [[NSArray alloc]initWithObjects:@"Add Marketing",@"addmarketing", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Marketing",@"editmarketing", nil],
                             nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"Policy",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Show Policy Page",@"showcenterpolicypage", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Center Policy",@"editcenterpolicy", nil],
                             nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"Subscription",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Show Subscription Page",@"viewsetupsubscription", nil],
                             [[NSArray alloc]initWithObjects:@"Add App License",@"addlicense", nil],
                             nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"Task",
                             [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Show All Other Task in Notification Screen",@"showallothertaskinnotificationview", nil],
                             [[NSArray alloc]initWithObjects:@"Show All Other Task in Task Assignment Screen",@"showallothertaskintaskassignmentview", nil],
                              [[NSArray alloc]initWithObjects:@"Close Other Task",@"closeothertask", nil],
                              nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"Highlights",
                            [[NSArray alloc]initWithObjects:
                            [[NSArray alloc]initWithObjects:@"Show Enrollment Count Chart",@"showenrollmentcountchart", nil],
                            [[NSArray alloc]initWithObjects:@"Show Payment Received Chart",@"showpaymentreceivedchart", nil],
                             nil],nil],

                           [[NSArray alloc]initWithObjects:@"Student Profile",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Show Category Count",@"showstudentcategorycount", nil],
                             [[NSArray alloc]initWithObjects:@"Override Evaluation Form Response",@"overrideassessmentresponse", nil],
                             [[NSArray alloc]initWithObjects:@"Add New Student",@"addnewstudent", nil],
                             [[NSArray alloc]initWithObjects:@"Show Student Page",@"showstudentpage", nil],
                             [[NSArray alloc]initWithObjects:@"Promote Student School Grade",@"promotestudentgrade", nil],
                             nil],nil],

                           [[NSArray alloc]initWithObjects:@"Class",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Change Default Extension Time",@"overrideextensiontime", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Lock Class Period",@"editlockclassperiod", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Locked Class",@"editlockedclass", nil],
                             nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"Timetable",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Change Subject Color",@"edittimetablesubjectcolor", nil],
                             [[NSArray alloc]initWithObjects:@"Change Instructor Color",@"edittimetableinstructorcolor", nil],
                             [[NSArray alloc]initWithObjects:@"Change Classroom Color",@"edittimetableclassroomcolor", nil],
                             nil],nil],
                           
                           
                           [[NSArray alloc]initWithObjects:@"Photo Corner",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Publish Post",@"publishinphotocorner", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Other's Post",@"editothersphotocornerpost", nil],
                             nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"Coupon",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Issue Coupon",@"issuecoupon", nil],
                             nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"Membership",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Issue Point",@"issuepoint", nil],
                             [[NSArray alloc]initWithObjects:@"Apply Coupon",@"applycoupon", nil],
                             nil],nil],
                           
                           globalvariables.centerrecord.enablevideomessage?
                           [[NSArray alloc]initWithObjects:@"Message Center",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Send Message",@"sendmessage", nil],
                             [[NSArray alloc]initWithObjects:@"Send Video Message",@"sendvideomessage", nil],
                             [[NSArray alloc]initWithObjects:@"Send Voice Message",@"sendvoicemessage", nil],
                             [[NSArray alloc]initWithObjects:@"Send Broadcast Message",@"sendbroadcastmessage", nil],
                             [[NSArray alloc]initWithObjects:@"Delete Message",@"deletemessage", nil],
                             [[NSArray alloc]initWithObjects:@"Receive Parent Message",@"receiveparentmessage", nil],
                             [[NSArray alloc]initWithObjects:@"Center Role Option",@"sendmessagecenterrole", nil],
                             [[NSArray alloc]initWithObjects:@"Receive All Student Notifications",@"receiveallstudentnotifications", nil],
                             nil],nil]:[[NSArray alloc]initWithObjects:@"Message Center",
                             [[NSArray alloc]initWithObjects:
                              [[NSArray alloc]initWithObjects:@"Send Message",@"sendmessage", nil],
                              [[NSArray alloc]initWithObjects:@"Delete Message",@"deletemessage", nil],
                              [[NSArray alloc]initWithObjects:@"Receive Parent Message",@"receiveparentmessage", nil],
                              [[NSArray alloc]initWithObjects:@"Center Role Option",@"sendmessagecenterrole", nil],
                              [[NSArray alloc]initWithObjects:@"Receive All Student Notifications",@"receiveallstudentnotifications", nil],
                              nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"Center Information",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Edit Center Information",@"editcenterinformation", nil],
                             [[NSArray alloc]initWithObjects:@"Show Auto Notification Settings",@"showautonotificationsettings", nil],
                             nil],nil],
                           
                           /*
                           [[NSArray alloc]initWithObjects:@"Instructor",
                           [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Show All Instructor Classes",@"viewallinstructorclass", nil],
                             nil],nil],
*/
                           [[NSArray alloc]initWithObjects:@"Daily Class Schedule",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Show Contact In Daily Class Schedule",@"viewcontactindailyschedule", nil],
                              [[NSArray alloc]initWithObjects:@"Show Total Count",@"showdailyscheduletotalcount", nil],
                            [[NSArray alloc]initWithObjects:@"Upcoming Class Alert",@"istaffclassalert", nil],
                             [[NSArray alloc]initWithObjects:@"Class Change Alert",@"classchangealert", nil],
                             nil],nil],
                           
                           
                           [[NSArray alloc]initWithObjects:@"Financial",
                           [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Show Staff Salary Rate",@"vieweditsalaryrate", nil],
                            [[NSArray alloc]initWithObjects:@"Withdraw Cash",@"withdrawcash", nil],
                            [[NSArray alloc]initWithObjects:@"Show Payment Received Chart",@"showpaymentreceivedchart", nil],
                            [[NSArray alloc]initWithObjects:@"Edit Promotion Discount",@"editdiscount", nil],
                            [[NSArray alloc]initWithObjects:@"Edit Regular Discount",@"editonetimediscount", nil],
                            [[NSArray alloc]initWithObjects:@"Edit Discount if Paid",@"editdiscountifpaid", nil],
                            [[NSArray alloc]initWithObjects:@"Edit Paid Date",@"editpaiddate", nil],
                            [[NSArray alloc]initWithObjects:@"Date Back Paid Date",@"allowdatebackpaiddate", nil],
                             nil],nil],
                           
                           [[NSArray alloc]initWithObjects:@"What's New",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Show What's New",@"showwhatsnew", nil],
                             nil],nil],
                           
                           globalvariables.centerrecord.enablevideomessage?
                           [[NSArray alloc]initWithObjects:@"iStaff",
                           [[NSArray alloc]initWithObjects:
                            [[NSArray alloc]initWithObjects:@"Show All Instructor Classes",@"viewallinstructorclass", nil],
                            [[NSArray alloc]initWithObjects:@"Take Attendance",@"istafftakingattendance", nil],
                            [[NSArray alloc]initWithObjects:@"Edit Level",@"editstudentsubjectlevel", nil],
                            [[NSArray alloc]initWithObjects:@"Send Student Message",@"istaffsendstudentmessage", nil],
                            [[NSArray alloc]initWithObjects:@"Send Lead Message",@"istaffsendleadmessage", nil],
                            [[NSArray alloc]initWithObjects:@"Send Staff Message",@"istaffsendstaffmessage", nil],
                            [[NSArray alloc]initWithObjects:@"Send Teacher Note",@"istaffsendparentnote", nil],
                            [[NSArray alloc]initWithObjects:@"Send Voice Message",@"istaffsendvoicemessage", nil],
                            [[NSArray alloc]initWithObjects:@"Send Video Message",@"istaffsendvideomessage", nil],
                            [[NSArray alloc]initWithObjects:@"Send Video Message",@"istaffsendbroadcastmessage", nil],
                            [[NSArray alloc]initWithObjects:@"Show Student's Contact",@"istaffshowstudentcontact", nil],
                            [[NSArray alloc]initWithObjects:@"Show Student's Address",@"istaffshowadditionalstudentinfo", nil],
                            [[NSArray alloc]initWithObjects:@"Show My Student Page",@"istaffshowmystudentpage", nil],
                            [[NSArray alloc]initWithObjects:@"Show Due Payment",@"istaffshowoutstanding", nil],
                            [[NSArray alloc]initWithObjects:@"Show Class Level",@"istaffshowclasslevel", nil],
                            [[NSArray alloc]initWithObjects:@"Extend Class",@"istaffextendclass", nil],
                            [[NSArray alloc]initWithObjects:@"View All Outbox Messages",@"istaffviewalloutboxmessage", nil],
                            [[NSArray alloc]initWithObjects:@"Edit Hot News",@"istaffedithotnews", nil],
                            [[NSArray alloc]initWithObjects:@"Show All Students",@"istaffviewallstudents", nil],
                            [[NSArray alloc]initWithObjects:@"View Center Message",@"istaffviewcentermessage", nil],
                            [[NSArray alloc]initWithObjects:@"Receive All Student Notifications",@"istaffreceiveallstudentnotifications", nil],
                            [[NSArray alloc]initWithObjects:@"Arrange Makeup Class",@"istaffmakeupmode", nil],
                            nil], nil]:[[NSArray alloc]initWithObjects:@"iStaff",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Show All Instructor Classes",@"viewallinstructorclass", nil],
                             [[NSArray alloc]initWithObjects:@"Take Attendance",@"istafftakingattendance", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Level",@"editstudentsubjectlevel", nil],
                             [[NSArray alloc]initWithObjects:@"Send Student Message",@"istaffsendstudentmessage", nil],
                             [[NSArray alloc]initWithObjects:@"Send Lead Message",@"istaffsendleadmessage", nil],
                             [[NSArray alloc]initWithObjects:@"Send Staff Message",@"istaffsendstaffmessage", nil],
                             [[NSArray alloc]initWithObjects:@"Send Teacher Note",@"istaffsendparentnote", nil],
                             [[NSArray alloc]initWithObjects:@"Send Voice Message",@"istaffsendvoicemessage", nil],
                             [[NSArray alloc]initWithObjects:@"Send Video Message",@"istaffsendbroadcastmessage", nil],
                             [[NSArray alloc]initWithObjects:@"Show Student's Contact",@"istaffshowstudentcontact", nil],
                             [[NSArray alloc]initWithObjects:@"Show Student's Address",@"istaffshowadditionalstudentinfo", nil],
                             [[NSArray alloc]initWithObjects:@"Show My Student Page",@"istaffshowmystudentpage", nil],
                             [[NSArray alloc]initWithObjects:@"Show Due Payment",@"istaffshowoutstanding", nil],
                             [[NSArray alloc]initWithObjects:@"Show Class Level",@"istaffshowclasslevel", nil],
                             [[NSArray alloc]initWithObjects:@"Extend Class",@"istaffextendclass", nil],
                             [[NSArray alloc]initWithObjects:@"View All Outbox Messages",@"istaffviewalloutboxmessage", nil],
                             [[NSArray alloc]initWithObjects:@"Edit Hot News",@"istaffedithotnews", nil],
                             [[NSArray alloc]initWithObjects:@"Show All Students",@"istaffviewallstudents", nil],
                             [[NSArray alloc]initWithObjects:@"View Center Message",@"istaffviewcentermessage", nil],
                             [[NSArray alloc]initWithObjects:@"Receive All Student Notifications",@"istaffreceiveallstudentnotifications", nil],
                             [[NSArray alloc]initWithObjects:@"Arrange Makeup Class",@"istaffmakeupmode", nil],
                             nil], nil],

                           [[NSArray alloc]initWithObjects:@"BI Report",
                            [[NSArray alloc]initWithObjects:
                             [[NSArray alloc]initWithObjects:@"Category S Reports",@"bistandardsreports", nil],
                             [[NSArray alloc]initWithObjects:@"Category E Reports",@"bistandardereports", nil],
                             [[NSArray alloc]initWithObjects:@"Category I Reports",@"bistandardireports", nil],
                             [[NSArray alloc]initWithObjects:@"Category L Reports",@"bistandardlreports", nil],
                             [[NSArray alloc]initWithObjects:@"Category D Reports",@"bistandarddreports", nil],
                             [[NSArray alloc]initWithObjects:@"Center QR Code",@"bistandardqreports", nil],
//                             [[NSArray alloc]initWithObjects:@"Management Reports",@"biviewmanagerfolder", nil],
                             [[NSArray alloc]initWithObjects:@"Category MS Reports",@"bimgtmsreports", nil],
                             [[NSArray alloc]initWithObjects:@"Category MD Reports",@"bimgtmdreports", nil],
                             [[NSArray alloc]initWithObjects:@"Category MP Reports",@"bimgtmpreports", nil],
                             [[NSArray alloc]initWithObjects:@"Category MA Reports",@"bimgtmareports", nil],
                             [[NSArray alloc]initWithObjects:@"Category MI Reports",@"bimgtmireports", nil],
                             [[NSArray alloc]initWithObjects:@"Category MT Reports",@"bimgtmtreports", nil],
                             nil], nil],
                           nil];
    

    UIButton *closebutton =[[UIButton alloc]initWithFrame:CGRectMake(userprivilegeview.frame.size.width-100-20,userprivilegeview.frame.size.height-35-10,100,35)];
    [closebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [closebutton setTitle:[MyClass returntitlewithtitle:@"Close"] forState:UIControlStateNormal];
    closebutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    closebutton.backgroundColor=[UIColor whiteColor];
    closebutton.layer.borderWidth=1;
    closebutton.layer.cornerRadius=4;
    closebutton.layer.masksToBounds=YES;
    closebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    closebutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [closebutton addTarget: self action:@selector(privilege_closebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [closebutton addTarget: self action:@selector(privilege_buttonhighlightcolor:) forControlEvents: UIControlEventTouchDown];
    [closebutton addTarget: self action:@selector(privilege_buttonresetcolor:) forControlEvents: UIControlEventTouchCancel];
    [closebutton addTarget: self action:@selector(privilege_buttonresetcolor:) forControlEvents: UIControlEventTouchUpOutside];
    
    //UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];

    
    //spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(0, closebutton.frame.origin.y-10, userprivilegeview.frame.size.width, 55)];
    separator.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [userprivilegeview addSubview:separator];
    

    [userprivilegeview addSubview:closebutton];
    
    
    userprivilegeviewcontroller=[[UIViewController alloc]init];
    userprivilegeviewcontroller.preferredContentSize=CGSizeMake(userprivilegeview.frame.size.width, userprivilegeview.frame.size.height);
    userprivilegeviewcontroller.view=userprivilegeview;
    
    if (@available(iOS 13.0, *)) {
        userprivilegeviewcontroller.modalInPresentation=TRUE;
    }
    
    userprivilegeviewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
    userprivilegeviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:userprivilegeviewcontroller animated:YES completion: nil];
}

-(void) staff_replaceinstructorbuttonpressed
{
    //[self retrievereplaceinstructorsubjectarray];
    ri_subjectarray=[[NSMutableArray alloc]init];
    ri_allinstructorarray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveInstructorListwithvalid:@"All" flushcachedata:NO]];
    ri_frominstructor=@"TBD";
    ri_toinstructor=@"TBD";
    ri_fromperiod=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy HH:mm"];
    ri_toperiod=@"";
    
    dayOptionArray=[[NSArray alloc]initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat", nil];
    selectedDayOptionArray=[[NSMutableArray alloc]initWithArray:dayOptionArray];
    
    [self retrievereplaceinstructorsubjectarray];
    
    UIView *separator;
    UIView *ri_masterview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 860, 600)];
    ri_masterview.backgroundColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
    //[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.4];
    
    //block view
    ri_blockview=[[UIButton alloc]initWithFrame:ri_masterview.frame];
    ri_blockview.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [ri_blockview addTarget:self action:@selector(closeblockview) forControlEvents:UIControlEventTouchUpInside];
    ri_blockview.hidden=YES;
    
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(20, 25, 30, 30)];
    [image setImage:[UIImage imageNamed:@"replaceinstructor_icon.png"]];
    [ri_masterview addSubview:image];
    image.layer.cornerRadius=5;
    image.layer.masksToBounds=YES;
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, ri_masterview.frame.size.width-40, 60)];
    label.font=[UIFont boldSystemFontOfSize:18];
    label.textColor=[UIColor blackColor];
    label.text=[MyClass returntitlewithtitle:@"Class Instructor Replacement"];
    [ri_masterview addSubview:label];

    
    //instructor view
    ri_instructorview=[[UIView alloc]initWithFrame:CGRectMake(20, 70, (ri_masterview.frame.size.width-45)/2, 140)];
    ri_instructorview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    ri_instructorview.layer.cornerRadius=8;
    ri_instructorview.layer.masksToBounds=YES;
    //[ri_masterview addSubview:instructorview];
    
    UILabel *instructorviewtitle=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, 300, 40)];
    instructorviewtitle.font=[UIFont systemFontOfSize:17];
    instructorviewtitle.textColor=[UIColor grayColor];
    instructorviewtitle.text=[MyClass returntitlewithtitle:@"Instructor"];
    [ri_instructorview addSubview:instructorviewtitle];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(15, 40, ri_instructorview.frame.size.width-15, 2)];
    separator.backgroundColor=[UIColor lightGrayColor];
    separator.layer.cornerRadius=2;
    separator.layer.masksToBounds=YES;
    [ri_instructorview addSubview:separator];
    
    
    frominstructorbutton=[[UIButton alloc]initWithFrame:CGRectMake(50, 50, ri_instructorview.frame.size.width-50-15, 35)];
    [frominstructorbutton setTitle:[MyClass returntitlewithtitle:@"TBD"] forState:UIControlStateNormal];
    frominstructorbutton.backgroundColor=[UIColor whiteColor];
    frominstructorbutton.layer.cornerRadius=5;
    frominstructorbutton.layer.masksToBounds=YES;
    frominstructorbutton.tag=0;
    [frominstructorbutton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    frominstructorbutton.titleLabel.font=[UIFont systemFontOfSize:20];
    frominstructorbutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [frominstructorbutton addTarget:self action:@selector(ri_instructorbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [frominstructorbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [ri_instructorview addSubview:frominstructorbutton];

    toinstructorbutton=[[UIButton alloc]initWithFrame:CGRectMake(frominstructorbutton.frame.origin.x, frominstructorbutton.frame.origin.y+45, frominstructorbutton.frame.size.width, frominstructorbutton.frame.size.height)];
    [toinstructorbutton setTitle:[MyClass returntitlewithtitle:@"TBD"] forState:UIControlStateNormal];
    toinstructorbutton.backgroundColor=[UIColor whiteColor];
    toinstructorbutton.layer.cornerRadius=5;
    toinstructorbutton.layer.masksToBounds=YES;
    toinstructorbutton.tag=1;
    [toinstructorbutton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    toinstructorbutton.titleLabel.font=[UIFont systemFontOfSize:20];
    toinstructorbutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [toinstructorbutton addTarget:self action:@selector(ri_instructorbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [toinstructorbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [ri_instructorview addSubview:toinstructorbutton];
    
    image=[[UIImageView alloc]initWithFrame:CGRectMake(15, frominstructorbutton.frame.origin.y+5, 25, 25)];
    [image setImage:[UIImage imageNamed:@"instructoricon.png"]];
    image.layer.cornerRadius=5;
    image.layer.masksToBounds=YES;
    [ri_instructorview addSubview:image];
    
    image=[[UIImageView alloc]initWithFrame:CGRectMake(15, toinstructorbutton.frame.origin.y+5, 25, 25)];
    [image setImage:[UIImage imageNamed:@"to_icon.png"]];
    image.layer.cornerRadius=5;
    image.layer.masksToBounds=YES;
    [ri_instructorview addSubview:image];
    
    
    //instructor search bar
    ri_instructorsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(separator.frame.origin.x, toinstructorbutton.frame.origin.y+toinstructorbutton.frame.size.height+10, ri_instructorview.frame.size.width-instructorviewtitle.frame.origin.x*2, 42)];
    ri_instructorsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    ri_instructorsearchbar.delegate=self;
    [ri_instructorview addSubview:ri_instructorsearchbar];
    
    //instructor table
    ri_instructortable=[[UITableView alloc]initWithFrame:CGRectMake(separator.frame.origin.x, toinstructorbutton.frame.origin.y+toinstructorbutton.frame.size.height+10+42, ri_instructorview.frame.size.width-instructorviewtitle.frame.origin.x*2, ri_instructorview.frame.size.height+10+ri_masterview.frame.size.height-ri_instructorview.frame.origin.y-ri_instructorview.frame.size.height-10-55-5-(toinstructorbutton.frame.origin.y+toinstructorbutton.frame.size.height+10)-10-42) style:UITableViewStyleGrouped];
    ri_instructortable.delegate=self;
    ri_instructortable.dataSource=self;
    [ri_instructorview addSubview:ri_instructortable];
    
    
    //Period view
    ri_periodview=[[UIView alloc]initWithFrame:CGRectMake(ri_instructorview.frame.origin.x+ri_instructorview.frame.size.width+5, ri_instructorview.frame.origin.y, ri_instructorview.frame.size.width, ri_instructorview.frame.size.height)];
    ri_periodview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    ri_periodview.layer.cornerRadius=8;
    ri_periodview.layer.masksToBounds=YES;
    [ri_masterview addSubview:ri_periodview];
    
    UILabel *periodviewtitle=[[UILabel alloc]initWithFrame:CGRectMake(15, 5, 100, 40)];
    periodviewtitle.font=[UIFont systemFontOfSize:17];
    periodviewtitle.textColor=[UIColor grayColor];
    periodviewtitle.text=[MyClass returntitlewithtitle:@"Period"];
    [ri_periodview addSubview:periodviewtitle];
    
    dayoptionbutton=[[UIButton alloc]initWithFrame:CGRectMake(120, 5, ri_instructorview.frame.size.width-15-120, 30)];
    [self updateDayOptionButtonTitle];
    dayoptionbutton.titleLabel.font=[UIFont systemFontOfSize:15];
    dayoptionbutton.layer.cornerRadius=5;
    dayoptionbutton.layer.masksToBounds=YES;
    [dayoptionbutton setTitleEdgeInsets:UIEdgeInsetsMake(2, 5, 2, 5)];
    dayoptionbutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [dayoptionbutton addTarget:self action:@selector(ri_periodbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [dayoptionbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [ri_periodview addSubview:dayoptionbutton];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(15, 40, ri_periodview.frame.size.width-15, 2)];
    separator.backgroundColor=[UIColor lightGrayColor];
    separator.layer.cornerRadius=2;
    separator.layer.masksToBounds=YES;
    [ri_periodview addSubview:separator];
    
    fromperiodbutton=[[UIButton alloc]initWithFrame:CGRectMake(50, 50, ri_instructorview.frame.size.width-50-15, 35)];
    fromperiodbutton.tag=0;
    [fromperiodbutton setTitle:[self returnriperiodbuttontitlewithbutton:fromperiodbutton titlevalue:ri_fromperiod] forState:UIControlStateNormal];
    fromperiodbutton.backgroundColor=[UIColor whiteColor];
    fromperiodbutton.layer.cornerRadius=5;
    fromperiodbutton.layer.masksToBounds=YES;
    [fromperiodbutton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    fromperiodbutton.titleLabel.font=[UIFont systemFontOfSize:20];
    fromperiodbutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [fromperiodbutton addTarget:self action:@selector(ri_periodbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [fromperiodbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [ri_periodview addSubview:fromperiodbutton];
    
    toperiodbutton=[[UIButton alloc]initWithFrame:CGRectMake(fromperiodbutton.frame.origin.x, fromperiodbutton.frame.origin.y+45, fromperiodbutton.frame.size.width, fromperiodbutton.frame.size.height)];
    toperiodbutton.tag=1;
    [toperiodbutton setTitle:[self returnriperiodbuttontitlewithbutton:toperiodbutton titlevalue:ri_toperiod] forState:UIControlStateNormal];
    toperiodbutton.backgroundColor=[UIColor whiteColor];
    toperiodbutton.layer.cornerRadius=5;
    toperiodbutton.layer.masksToBounds=YES;
    [toperiodbutton setTitleEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 10)];
    toperiodbutton.titleLabel.font=[UIFont systemFontOfSize:20];
    toperiodbutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [toperiodbutton addTarget:self action:@selector(ri_periodbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [toperiodbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [ri_periodview addSubview:toperiodbutton];
    
    
    image=[[UIImageView alloc]initWithFrame:CGRectMake(15, fromperiodbutton.frame.origin.y+5, 25, 25)];
    [image setImage:[UIImage imageNamed:@"classtimeicon.png"]];
    image.layer.cornerRadius=5;
    image.layer.masksToBounds=YES;
    [ri_periodview addSubview:image];
    
    image=[[UIImageView alloc]initWithFrame:CGRectMake(15, toperiodbutton.frame.origin.y+5, 25, 25)];
    [image setImage:[UIImage imageNamed:@"to_icon.png"]];
    image.layer.cornerRadius=5;
    image.layer.masksToBounds=YES;
    [ri_periodview addSubview:image];
    
    clearfromperiodbutton=[[UIButton alloc]initWithFrame:CGRectMake(fromperiodbutton.frame.size.width-35, 0, 35, 35)];
    [clearfromperiodbutton setImage:[UIImage imageNamed:@"closescreen_blue.png"] forState:UIControlStateNormal];
    [clearfromperiodbutton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    clearfromperiodbutton.tag=0;
    [clearfromperiodbutton addTarget:self action:@selector(clearriperiod:) forControlEvents:UIControlEventTouchUpInside];
    [fromperiodbutton addSubview:clearfromperiodbutton];

    cleartoperiodbutton=[[UIButton alloc]initWithFrame:CGRectMake(toperiodbutton.frame.size.width-35, 0, 35, 35)];
    [cleartoperiodbutton setImage:[UIImage imageNamed:@"closescreen_blue.png"] forState:UIControlStateNormal];
    [cleartoperiodbutton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    cleartoperiodbutton.tag=1;
    cleartoperiodbutton.hidden=YES;
    [cleartoperiodbutton addTarget:self action:@selector(clearriperiod:) forControlEvents:UIControlEventTouchUpInside];
    [toperiodbutton addSubview:cleartoperiodbutton];
    
    
    //calendar table
    ri_calendartable=[[UITableView alloc]initWithFrame:CGRectMake(separator.frame.origin.x, toperiodbutton.frame.origin.y+toperiodbutton.frame.size.height+10, ri_periodview.frame.size.width-periodviewtitle.frame.origin.x*2, ri_periodview.frame.size.height+10+ri_masterview.frame.size.height-ri_periodview.frame.origin.y-ri_periodview.frame.size.height-10-55-5-(toperiodbutton.frame.origin.y+toperiodbutton.frame.size.height+10)-10) style:UITableViewStyleGrouped];
    ri_calendartable.delegate=self;
    ri_calendartable.dataSource=self;
    ri_calendartable.scrollEnabled=NO;
    [ri_periodview addSubview:ri_calendartable];
    
    
    //subject table
    ri_subjecttable=[[UITableView alloc]initWithFrame:CGRectMake(ri_instructorview.frame.origin.x, ri_instructorview.frame.origin.y+ri_instructorview.frame.size.height+5, ri_masterview.frame.size.width-ri_instructorview.frame.origin.x*2, ri_masterview.frame.size.height-ri_instructorview.frame.origin.y-ri_instructorview.frame.size.height-10-55-5) style:UITableViewStyleGrouped];
    ri_subjecttable.delegate=self;
    ri_subjecttable.dataSource=self;
    ri_subjecttable.layer.cornerRadius=8;
    ri_subjecttable.layer.masksToBounds=YES;
    [ri_masterview addSubview:ri_subjecttable];
    
    ri_noclassfoundlabel=[[UILabel alloc]initWithFrame:ri_subjecttable.frame];
    ri_noclassfoundlabel.text=[MyClass returntitlewithtitle:@"No class found"];
    ri_noclassfoundlabel.textAlignment=NSTextAlignmentCenter;
    ri_noclassfoundlabel.font=[UIFont systemFontOfSize:15];
    ri_noclassfoundlabel.textColor=[UIColor grayColor];
    [ri_masterview addSubview:ri_noclassfoundlabel];
    
    if ([ri_subjecttable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        ri_subjecttable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    
    /*
    staff_privilegedetailstable=[[UITableView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x+staff_privilegenametable.frame.size.width, 65, userprivilegeview.frame.size.width-40-staff_privilegenametable.frame.size.width, userprivilegeview.frame.size.height-135) style:UITableViewStyleGrouped];
    staff_privilegedetailstable.delegate=self;
    staff_privilegedetailstable.dataSource=self;
    [userprivilegeview addSubview:staff_privilegenametable];
    [userprivilegeview addSubview:staff_privilegedetailstable];
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x, staff_privilegenametable.frame.origin.y+staff_privilegenametable.frame.size.height, staff_privilegenametable.frame.size.width, 38)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [userprivilegeview addSubview: separator];
    
    UIButton *addbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 38, 38)];
    //addbutton.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0];
    addbutton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [addbutton setImage:[UIImage imageNamed:@"addbuttonwhite_icon.png"] forState:UIControlStateNormal];
    addbutton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [addbutton addTarget:self action:@selector(addprivilege:) forControlEvents:UIControlEventTouchUpInside];
    [separator addSubview:addbutton];
    
    UIButton *deletebutton=[[UIButton alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.size.width-38, 0, 38, 38)];
    //deletebutton.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0];
    deletebutton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [deletebutton setImage:[UIImage imageNamed:@"minusbuttonwhite_icon.png"] forState:UIControlStateNormal];
    deletebutton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    [deletebutton addTarget:self action:@selector(deleteprivilege:) forControlEvents:UIControlEventTouchUpInside];
    [separator addSubview:deletebutton];
    
    
    
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x, staff_privilegenametable.frame.origin.y, staff_privilegenametable.frame.size.width+staff_privilegedetailstable.frame.size.width, 0.5)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [userprivilegeview addSubview: separator];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x, staff_privilegenametable.frame.origin.y+staff_privilegedetailstable.frame.size.height, staff_privilegenametable.frame.size.width+staff_privilegedetailstable.frame.size.width, 0.5)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [userprivilegeview addSubview: separator];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x, staff_privilegenametable.frame.origin.y, 0.5, staff_privilegedetailstable.frame.size.height)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [userprivilegeview addSubview: separator];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x+staff_privilegenametable.frame.size.width, staff_privilegenametable.frame.origin.y, 0.5, staff_privilegedetailstable.frame.size.height)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [userprivilegeview addSubview: separator];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(staff_privilegenametable.frame.origin.x+staff_privilegenametable.frame.size.width+staff_privilegedetailstable.frame.size.width, staff_privilegenametable.frame.origin.y, 0.5, staff_privilegedetailstable.frame.size.height)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [userprivilegeview addSubview: separator];
    
    [staff_privilegenametable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    
       */
    
    UIButton *closebutton =[[UIButton alloc]initWithFrame:CGRectMake(ri_masterview.frame.size.width-100-20,ri_masterview.frame.size.height-35-10,100,35)];
    [closebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [closebutton setTitle:[MyClass returntitlewithtitle:@"Close"] forState:UIControlStateNormal];
    closebutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    closebutton.backgroundColor=[UIColor whiteColor];
    closebutton.layer.borderWidth=1;
    closebutton.layer.cornerRadius=4;
    closebutton.layer.masksToBounds=YES;
    closebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    closebutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [closebutton addTarget: self action:@selector(replaceinstructor_closebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [closebutton addTarget: self action:@selector(privilege_buttonhighlightcolor:) forControlEvents: UIControlEventTouchDown];
    [closebutton addTarget: self action:@selector(privilege_buttonresetcolor:) forControlEvents: UIControlEventTouchCancel];
    [closebutton addTarget: self action:@selector(privilege_buttonresetcolor:) forControlEvents: UIControlEventTouchUpOutside];

    
    UIButton *replacebutton =[[UIButton alloc]initWithFrame:CGRectMake(ri_masterview.frame.size.width-100-20-100-10,ri_masterview.frame.size.height-35-10,100,35)];
    [replacebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [replacebutton setTitle:[MyClass returntitlewithtitle:@"Replace"] forState:UIControlStateNormal];
    replacebutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    replacebutton.backgroundColor=[UIColor whiteColor];
    replacebutton.layer.borderWidth=1;
    replacebutton.layer.cornerRadius=4;
    replacebutton.layer.masksToBounds=YES;
    replacebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    replacebutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [replacebutton addTarget: self action:@selector(replaceinstructorbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [replacebutton addTarget: self action:@selector(privilege_buttonhighlightcolor:) forControlEvents: UIControlEventTouchDown];
    [replacebutton addTarget: self action:@selector(privilege_buttonresetcolor:) forControlEvents: UIControlEventTouchCancel];
    [replacebutton addTarget: self action:@selector(privilege_buttonresetcolor:) forControlEvents: UIControlEventTouchUpOutside];
    
    
    
    
    
   // UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
    
    
    //spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 35)];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(0, closebutton.frame.origin.y-10, ri_masterview.frame.size.width, 55)];
    separator.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [ri_masterview addSubview:separator];
    
    [ri_masterview addSubview:replacebutton];
    [ri_masterview addSubview:closebutton];
    [ri_masterview addSubview:ri_blockview];
    [ri_masterview addSubview:ri_instructorview];
    
    userprivilegeviewcontroller=[[UIViewController alloc]init];
    userprivilegeviewcontroller.preferredContentSize=CGSizeMake(ri_masterview.frame.size.width, ri_masterview.frame.size.height);
    userprivilegeviewcontroller.view=ri_masterview;
    
    if (@available(iOS 13.0, *)) {
        userprivilegeviewcontroller.modalInPresentation=TRUE;
    }
    
    userprivilegeviewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
    userprivilegeviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:userprivilegeviewcontroller animated:YES completion: nil];
}


-(void) privilege_closebuttonpressed:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    
    if (![self isprivilegeusertypealreadyexistwithusertype:((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).usertype privilegekey:((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).privilegekey]) {
        [userprivilegeviewcontroller dismissViewControllerAnimated:YES completion:nil];

    }else{
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Privilege"] message:[MyClass returntitlewithtitle:@"Please use a different privilege name as it already exists"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [userprivilegeviewcontroller presentViewController:erroralert animated:YES completion:nil];
    }
}

-(void) replaceinstructor_closebuttonpressed:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [userprivilegeviewcontroller dismissViewControllerAnimated:YES completion:nil];
}


-(void) replaceinstructorbuttonpressed:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    if (ri_selectedsubjectarray.count==0) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Instructor Replacement"] message:[MyClass returntitlewithtitle:@"No class found"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
        }];
        
        [erroralert addAction:OKAction];
        [userprivilegeviewcontroller presentViewController:erroralert animated:YES completion:nil];
    }else if ([ri_frominstructor isEqualToString:ri_toinstructor]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Instructor Replacement"] message:[MyClass returntitlewithtitle:@"Instructors cannot be the same"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        }];
        
        [erroralert addAction:OKAction];
        [userprivilegeviewcontroller presentViewController:erroralert animated:YES completion:nil];
    }else if (![ri_fromperiod isEqualToString:@""] && ![ri_toperiod isEqualToString:@""] && [[MyClass convertToNSDateWithDate:ri_fromperiod DateFormat:@"dd-MMM-yyyy HH:mm"] compare:[MyClass convertToNSDateWithDate:ri_toperiod DateFormat:@"dd-MMM-yyyy HH:mm"]]!=NSOrderedAscending){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Instructor Replacement"] message:[MyClass returntitlewithtitle:@"Period end date cannot be earlier than start date"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        }];
        
        [erroralert addAction:OKAction];
        [userprivilegeviewcontroller presentViewController:erroralert animated:YES completion:nil];
        
    }else{
        UIAlertController *replacealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Instructor Replacement"] message:[MyClass returntitlewithtitle:@"Are you sure to replace the instructor for the selected classes?"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self replaceinstructorwithoption:@"change" resetselectedarray:NO];
            });
        }];
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [replacealert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [replacealert addAction:OKAction];
        [replacealert addAction:CancelAction];
        
        [userprivilegeviewcontroller presentViewController:replacealert animated:YES completion:nil];
    }
}


-(void) replaceinstructorwithoption:(NSString *)option resetselectedarray:(BOOL)resetselectedarray
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsonsubjectarray=[[NSArray alloc]init];
    NSArray *jsondayarray=[[NSArray alloc]init];
    
    //NSURLResponse *response = nil;
    //NSError *requestError = nil;
    
    keys=[NSArray arrayWithObjects:@"subject",nil];
    
    for (int i=0; i<ri_selectedsubjectarray.count; i++) {
        values=[NSArray arrayWithObjects: [ri_selectedsubjectarray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
        
    }
    
    jsonsubjectarray = [NSArray arrayWithArray:arrayOfDicts];
    
    [arrayOfDicts removeAllObjects];
    keys=[NSArray arrayWithObjects:@"day",nil];
    for (int i=0; i<selectedDayOptionArray.count; i++) {
        values=[NSArray arrayWithObjects: [selectedDayOptionArray objectAtIndex:i], nil];
        dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
        [arrayOfDicts addObject:dict];
        
    }
    jsondayarray = [NSArray arrayWithArray:arrayOfDicts];
    
    //combine arrays
    NSDictionary *dictionary = @{@"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"frominstructor" : ri_frominstructor,
                                 @"toinstructor" : ri_toinstructor,
                                 @"option" : option,
                                 @"fromperiod" : [MyClass convertDDMMMYYYYHHMMtoYYYYMMDDHHMMwithdatetime:ri_fromperiod],
                                 @"toperiod" : [MyClass convertDDMMMYYYYHHMMtoYYYYMMDDHHMMwithdatetime:ri_toperiod],
                                 @"subjectarray" : jsonsubjectarray,
                                 @"dayarray" : jsondayarray,
                                 @"updatedby"   : globalvariables.username,
                                 @"postaction" : @"replaceinstructor"};


    
    
    //NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    
    __block BOOL result=FALSE;
    __block NSMutableArray *JSONArray;
    
    if(jsondayarray.count!=0){
        [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                JSONArray = jsonreturned[@"content"];
            }
        }];
    }else{
        result=TRUE;
    }
    
    if(result){
        if ([option isEqualToString:@"change"]) {
            [self loadingindicatorwithoption:@"stop"];
            UIAlertController *successfulalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Instructor Replacement"] message:[MyClass returntitlewithtitle:@"Replacement is completed"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [self replaceinstructorwithoption:@"retrieve" resetselectedarray:resetselectedarray];
            }];
            
            [successfulalert addAction:OKAction];
            [userprivilegeviewcontroller presentViewController:successfulalert animated:YES completion:nil];
        }else{
            ri_subjectarray=[[NSMutableArray alloc]init];
            ri_selectedsubjectarray=[[NSMutableArray alloc]init];
            ri_totalcount=0;
            for (int i=0; i<JSONArray.count; i++) {
                NSString * subject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString * count=[[JSONArray objectAtIndex:i] objectForKey:@"count"];
                [ri_subjectarray addObject:[[SubjectRecord alloc]initSubjectRecordwithCenterkey:nil Subjectkey:nil Subject_Englishname:[MyClass returnsubjectnamewithsubject_shortname:subject centerkey:globalvariables.centerrecord.centerkey] Subject_Chinesename:nil Subject_shortname:subject Enrollmentmode:nil Tuition_method:nil Tuition_mode:nil Studentcapacity:count StandardNoOfClassOrMonth:nil ClassDuration:nil ClassDurationAssessment:nil ClassDurationTrial:nil Status:nil LevelArray:nil TuitionArray:nil Remarks:nil ScheduleArray:nil Subject_Category:nil WeeklyAutoRenewDefault:NO validity:nil makeup_quota_unit:@"" makeup_quota_value:@"-1" leaveday_by_makeupschedule:NO leaveday_by_classdate:NO leaveday_follow_teacher:NO leaveday_by_enrolledschedule:NO leaveday_by_staffschedule:NO leaveday_follow_level:NO leaveday_follow_lesson:NO colorcode:0 fcsubject:nil lessonnumberDict:nil leaveday_follow_category:NO allowsameschedule:NO subject_fulldescription:nil subject_image:nil publishinchatbot:NO chatbot_category:nil chatbot_tag1:nil trial_by_existinglesson:NO trial_by_definedschedule:NO trialcapacity:nil chatbot_enabletrial:NO showmakeupbuttonifnotimeslot:NO btspromotioncode831:nil btspromotioncode1031:nil showabsentbuttononarrangeleave:NO pregenperiodcount:0 autolevelupgrade:nil]];
                if (resetselectedarray) {
                    [ri_selectedsubjectarray addObject:subject];
                    ri_totalcount+=[count intValue];
                }
                
                
            }
            
            //sort
            NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"subject_englishname" ascending:YES selector:@selector(localizedStandardCompare:)];
            NSArray *sortDescriptors = @[sortByName];
            ri_subjectarray = [NSMutableArray arrayWithArray:[ri_subjectarray sortedArrayUsingDescriptors:sortDescriptors]];
            [ri_subjecttable reloadData];
            ri_noclassfoundlabel.hidden=ri_subjectarray.count!=0;
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        }
    }
}


-(void) group_closebuttonpressed:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    if (![self isgroupnamealreadyexistwithgroupname:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupname groupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey]) {
        [userprivilegeviewcontroller dismissViewControllerAnimated:YES completion:nil];
    }else{
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Group"] message:[MyClass returntitlewithtitle:@"Please use a different group name as it already exists"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [userprivilegeviewcontroller presentViewController:erroralert animated:YES completion:nil];
    }
}


-(void)privilege_buttonhighlightcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)privilege_buttonresetcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
}

-(void) addprivilege:(id)sender
{
    if (![self isprivilegeusertypealreadyexistwithusertype:((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).usertype privilegekey:((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).privilegekey]) {
        [self addPrivilegeWithUsertype:[self returnnewprivilegename]];
    }else{
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"User Privilege"] message:[MyClass returntitlewithtitle:@"Please use a different privilege name as it already exists"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [userprivilegeviewcontroller presentViewController:erroralert animated:YES completion:nil];
    }
    
    
    
}

-(void) deleteprivilege:(id)sender
{
    if ([privilegecountdictionary valueForKey:((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).privilegekey]) {
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Privilege cannot be deleted"] message:[MyClass returntitlewithtitle:@"The privilege is being assigned to some staff"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [userprivilegeviewcontroller presentViewController:erroralert animated:YES completion:nil];
    }else{
        [self deletePrivilegeWithPrivilegekey:((PrivilegeRecord *)[localprivilegearray objectAtIndex:selectedPrivilegeNameRow]).privilegekey];
        //[self retrieveStaffListwithflushcachedata:YES];
    }
}

-(void) addgroup:(id)sender
{
    if (![self isgroupnamealreadyexistwithgroupname:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupname groupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey]) {
        [self addGroupWithName:[self returnnewgroupname]];
        tableViewCellIdentifierCount++;
        tableViewCellIdentifier = [NSString stringWithFormat:@"%@%lu", TABLE_VIEW_CELL_DEFAULT_ID, (unsigned long)self.tableViewCellIdentifierCount];
        [staff_groupdetailstable reloadData];
    }else{
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Group"] message:[MyClass returntitlewithtitle:@"Please use a different group name as it already exists"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [userprivilegeviewcontroller presentViewController:erroralert animated:YES completion:nil];
    }
}

-(void) deletegroup:(id)sender
{
    if ([groupcountdictionary valueForKey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey]) {
        UIAlertController *deletealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Staff Group"] message:[MyClass returntitlewithtitle:@"This group has some staff in it. Are you sure to delete?"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self deleteGroupWithGroupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey];
        }];
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [deletealert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [deletealert addAction:OKAction];
        [deletealert addAction:CancelAction];
        [userprivilegeviewcontroller presentViewController:deletealert animated:YES completion:nil];
    }else{
        [self deleteGroupWithGroupkey:((GroupRecord *)[GroupArray objectAtIndex:selectedGroupNameRow]).groupkey];
    }
    
    

}

-(void) policy_editbuttonpressed
{
    policy_editmode=!policy_editmode;
    [self drawpolicycategorybutton];
    [policytable reloadData];
}

-(void) policy_addsectionbuttonpressed:(UIButton *)sender
{
    [((NSMutableArray *)[policyallcategory objectAtIndex:policy_selectedsegment]) insertObject:[[PolicyRecord alloc]initPolicyRecordwithHeadingEnglish:[MyClass returntitlewithtitle:@"Please enter your title" language:@"English"] HeadingChinese:[MyClass returntitlewithtitle:@"Please enter your title" language:@"Chinese"] ContentEnglish:[MyClass returntitlewithtitle:@"Please enter your policy" language:@"English"] ContentChinese:[MyClass returntitlewithtitle:@"Please enter your policy" language:@"Chinese"]] atIndex:sender.tag+1];
    [policytable reloadData];
}

-(void) policy_deletesectionbuttonpressed:(UIButton *)sender
{
    [((NSMutableArray *)[policyallcategory objectAtIndex:policy_selectedsegment]) removeObjectAtIndex:sender.tag];
    
    if (((NSMutableArray *)[policyallcategory objectAtIndex:policy_selectedsegment]).count==0) {
        //remove category
        [policycategory removeObjectAtIndex:policy_selectedsegment];
        [policyallcategory removeObjectAtIndex:policy_selectedsegment];

        if (policy_selectedsegment>0) {
            policy_selectedsegment-=1;
        }
        [self drawpolicycategorybutton];
    }
    
    [policytable reloadData];
}

-(void) policy_titlechange:(UITextField *)sender
{
    [((PolicyRecord *)[((NSMutableArray *)[policyallcategory objectAtIndex:policy_selectedsegment]) objectAtIndex:sender.tag]) setValue:sender.text forKey:[NSString stringWithFormat:@"heading%@",policy_languageselected]];
}

-(void) drawpolicycategorybutton
{
    UITextField *categorytext;
    UIButton *deletebutton;
    UIButton *addbutton;
    
    //remove previous created objects
    for (id object in [generalPolicyView subviews]) {
        if ([object isKindOfClass:[UIButton class]]) {
            UIButton *button=object;
            if (button.tag >=8000) {
                [object removeFromSuperview];
            }
        }else if ([object isKindOfClass:[UITextField class]]) {
            UITextField *label=object;
            if (label.tag >=7000) {
                [object removeFromSuperview];
            }
        }
    }

    if (policy_editmode) {
        for (int i=0; i<policycategory.count; i++) {
            categorytext=[[UITextField alloc]initWithFrame:CGRectMake(15+i*(175+25), 15, 175, 29)];
            categorytext.text=[((LanguageTitleRecord *)[policycategory objectAtIndex:i]) valueForKey:policy_languageselected];
            categorytext.font=[UIFont systemFontOfSize:13];
            categorytext.borderStyle=UITextBorderStyleRoundedRect;
            categorytext.textAlignment=NSTextAlignmentCenter;
            categorytext.tag=7000+i;
            [categorytext addTarget:self action:@selector(policy_updatecategory:) forControlEvents:UIControlEventEditingChanged];
            [categorytext addTarget:self action:@selector(policy_categoryselected:) forControlEvents:UIControlEventEditingDidBegin];
            [generalPolicyView addSubview:categorytext];
            
            if (i==policy_selectedsegment) {
                categorytext.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
            }
            
            deletebutton=[[UIButton alloc]initWithFrame:CGRectMake(categorytext.frame.origin.x-10, categorytext.frame.origin.y-10, 20, 20)];
            [deletebutton setImage:[UIImage imageNamed:@"deletebutton2.png"] forState:UIControlStateNormal];
            [deletebutton setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
            deletebutton.tag=8000+i;
            [deletebutton addTarget:self action:@selector(policy_deletecategorybuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            [generalPolicyView addSubview:deletebutton];
            
            if (policycategory.count<5) {
                addbutton=[[UIButton alloc]initWithFrame:CGRectMake(categorytext.frame.origin.x+categorytext.frame.size.width-10, categorytext.center.y-10, 20, 20)];
                [addbutton setImage:[UIImage imageNamed:@"addphonebutton2.png"] forState:UIControlStateNormal];
                [addbutton setImageEdgeInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
                addbutton.tag=9000+i;
                [addbutton addTarget:self action:@selector(policy_addcategorybuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                [generalPolicyView addSubview:addbutton];
            }
        }
        policy_editbutton.hidden=YES;
        policy_cancelbutton.hidden=NO;
        policy_savebutton.hidden=NO;
        scpolicy.hidden=YES;
        scPolicyLanguage.hidden=NO;
        scPolicyLanguage.selectedSegmentIndex=[policy_languageselected isEqualToString:@"english"]?0:1;
        //policytable.frame=CGRectMake(15, 50, policyview.bounds.size.width-15*2, policyview.bounds.size.height-120);
        generalPolicyTableBottomConstraint.constant=70;
        
        if (policycategory.count==0) {
            policy_addbutton.hidden=NO;
        }else{
            policy_addbutton.hidden=YES;
        }
    }else{
        policy_languageselected=[globalvariables.language isEqualToString:@"English"]?@"english":@"chinese";
        scPolicyLanguage.selectedSegmentIndex=[globalvariables.language isEqualToString:@"English"]?0:1;
        policy_editbutton.hidden=NO;
        policy_cancelbutton.hidden=YES;
        policy_savebutton.hidden=YES;
        scpolicy.hidden=NO;
        policy_addbutton.hidden=YES;
        scPolicyLanguage.hidden=YES;
        //policytable.frame=CGRectMake(15, 50, policyview.bounds.size.width-15*2, policyview.bounds.size.height-60);
        generalPolicyTableBottomConstraint.constant=10;
    }
}

-(void) policy_deletecategorybuttonpressed:(UIButton *)sender
{
    [policycategory removeObjectAtIndex:sender.tag-8000];
    [policyallcategory removeObjectAtIndex:sender.tag-8000];
    if (policy_selectedsegment==sender.tag-8000) {
        if (policy_selectedsegment>0) {
            policy_selectedsegment-=1;
        }
    }else{
        if (policy_selectedsegment==policycategory.count) {
            policy_selectedsegment=policycategory.count-1;
        }
    }
    [self drawpolicycategorybutton];
    [policytable reloadData];
}

-(void)policy_updatecategory:(UITextField *)sender
{
    [((LanguageTitleRecord *)[policycategory objectAtIndex:sender.tag-7000]) setValue:sender.text forKey:policy_languageselected];
}

-(void) policy_addcategorybuttonpressed:(UIButton *)sender
{
    policy_selectedsegment=sender.tag-9000+1;
    [policycategory insertObject:[[LanguageTitleRecord alloc]initLanguageTitleRecordwithCenterkey:nil Title:nil Chinese:[MyClass returntitlewithtitle:@"New Category" language:@"Chinese"] English:[MyClass returntitlewithtitle:@"New Category" language:@"English"] SChinese:nil] atIndex:sender.tag-9000+1];
    [policyallcategory insertObject:[[NSMutableArray alloc]initWithObjects:[[PolicyRecord alloc]initPolicyRecordwithHeadingEnglish:[MyClass returntitlewithtitle:@"Please enter your title" language:@"English"] HeadingChinese:[MyClass returntitlewithtitle:@"Please enter your title" language:@"Chinese"] ContentEnglish:[MyClass returntitlewithtitle:@"Please enter your policy" language:@"English"] ContentChinese:[MyClass returntitlewithtitle:@"Please enter your policy" language:@"Chinese"]], nil] atIndex:sender.tag-9000+1];
    [self drawpolicycategorybutton];
    [policytable reloadData];
}

-(void) policy_addbuttonpressed:(UIButton *)sender
{
    policy_selectedsegment=0;
    [policycategory insertObject:[[LanguageTitleRecord alloc]initLanguageTitleRecordwithCenterkey:nil Title:nil Chinese:[MyClass returntitlewithtitle:@"New Category" language:@"Chinese"] English:[MyClass returntitlewithtitle:@"New Category" language:@"English"] SChinese:nil] atIndex:0];
    [policyallcategory insertObject:[[NSMutableArray alloc]initWithObjects:[[PolicyRecord alloc]initPolicyRecordwithHeadingEnglish:[MyClass returntitlewithtitle:@"Please enter your title" language:@"English"] HeadingChinese:[MyClass returntitlewithtitle:@"Please enter your title" language:@"Chinese"] ContentEnglish:[MyClass returntitlewithtitle:@"Please enter your policy" language:@"English"] ContentChinese:[MyClass returntitlewithtitle:@"Please enter your policy" language:@"Chinese"]], nil] atIndex:0];
    [self drawpolicycategorybutton];
    [policytable reloadData];
}

-(void) policy_categoryselected:(UITextField *)sender
{
    policy_selectedsegment=sender.tag-7000;
    UITextField *textfield;
    for (int i=0; i<policycategory.count; i++) {
        textfield=((UITextField *)[generalPolicyView viewWithTag:7000+i]);
        if (textfield.tag-7000== policy_selectedsegment) {
            textfield.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
        }else{
            textfield.backgroundColor=nil;
        }
    }
    [policytable reloadData];
}

-(void) policy_buttonresetcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
}

-(void) policy_buttonhighlightcolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void) policy_cancelbuttonpressed:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    policy_editmode=FALSE;
    [self drawpolicycategorybutton];
    [self retrievepolicy];
    
    
}

-(void) policy_savebuttonpressed:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    policy_editmode=FALSE;
    [self loadingindicatorwithoption:@"start"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updatecenterpolicy];
        //policy_languageselected=@"english";
        [self retrievepolicy];
        [self drawpolicycategorybutton];
        [policytable reloadData];
    });
    
}


-(void) updatecenterpolicy
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsonpolicyarray=[[NSArray alloc]init];
    PolicyRecord *policyobject;
    LanguageTitleRecord *languageobject;

    
    keys=[NSArray arrayWithObjects:@"categorykey",@"policyorder",@"categoryenglish",@"categorychinese",@"headingenglish",@"headingchinese",@"contentenglish",@"contentchinese",nil];
    
    for (int i=0; i<policycategory.count; i++) {
        languageobject=[policycategory objectAtIndex:i];
        for (int j=0; j<((NSMutableArray *)[policyallcategory objectAtIndex:i]).count; j++) {
            policyobject= [((NSMutableArray *)[policyallcategory objectAtIndex:i]) objectAtIndex:j];
            values=[NSArray arrayWithObjects: [NSString stringWithFormat:@"%d",i],[NSString stringWithFormat:@"%d",j],languageobject.english,languageobject.chinese,policyobject.headingenglish,policyobject.headingchinese,policyobject.contentenglish,policyobject.contentchinese, nil];

            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
    }
    
    jsonpolicyarray = [NSArray arrayWithArray:arrayOfDicts];
    
    //combine arrays
    NSDictionary *dictionary = @{@"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"policyarray" : jsonpolicyarray,
                                 @"postaction" : @"updatecenterpolicy"};
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    [self loadingindicatorwithoption:@"stop"];
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
    
    if (lastviewindex==2){
        [subjecttable deselectRowAtIndexPath:[subjecttable indexPathForSelectedRow] animated:YES];
    }else if (lastviewindex==3){
        [classroomtable deselectRowAtIndexPath:[classroomtable indexPathForSelectedRow] animated:YES];
    }else if (lastviewindex==4){
        [stafftable deselectRowAtIndexPath:[stafftable indexPathForSelectedRow] animated:YES];
    }else if (lastviewindex==5){
        [producttable deselectRowAtIndexPath:[producttable indexPathForSelectedRow] animated:YES];
    }else if (lastviewindex==6){
        [marketingtable deselectRowAtIndexPath:[marketingtable indexPathForSelectedRow] animated:YES];
//        [marketingsourcetable deselectRowAtIndexPath:[marketingsourcetable indexPathForSelectedRow] animated:YES];
//        [marketingpromotiontable deselectRowAtIndexPath:[marketingpromotiontable indexPathForSelectedRow] animated:YES];
    }
    
    
}

-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    if (scrollView==staff_membergrouptable) {
        [staff_membertable setContentOffset:CGPointMake(0, scrollView.contentOffset.y)];
    }else if (scrollView==staff_membertable){
        [staff_membergrouptable setContentOffset:CGPointMake(staff_membergrouptable.contentOffset.x, scrollView.contentOffset.y)];
    }
    
    
}

-(void) enablegroupmember:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:staff_membergrouptable];
    NSIndexPath *indexpath =[staff_membergrouptable indexPathForRowAtPoint:point];
    
    if([self containsGroupKeyWithMemberArray:((Staff *)[filteredStaffArray objectAtIndex:indexpath.row]).grouparray groupKey:((GroupRecord *)[GroupArray objectAtIndex:sender.tag-1000]).groupkey]){
        //[((Staff *)[StaffArray objectAtIndex:indexpath.row]).grouparray removeObject:((GroupRecord *)[GroupArray objectAtIndex:sender.tag-1000]).groupkey];
        sender.layer.opacity=0.2;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updatestaffgroupwithoption:@"remove" groupkey:((GroupRecord *)[GroupArray objectAtIndex:sender.tag-1000]).groupkey staffkey:((Staff *)[filteredStaffArray objectAtIndex:indexpath.row]).staffkey];
            [self retrieveStaffListwithflushcachedata:YES];
        });

    }else{
        //[((Staff *)[StaffArray objectAtIndex:indexpath.row]).grouparray addObject:((GroupRecord *)[GroupArray objectAtIndex:sender.tag-1000]).groupkey];
        sender.layer.opacity=1;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updatestaffgroupwithoption:@"add" groupkey:((GroupRecord *)[GroupArray objectAtIndex:sender.tag-1000]).groupkey staffkey:((Staff *)[filteredStaffArray objectAtIndex:indexpath.row]).staffkey];
            [self retrieveStaffListwithflushcachedata:YES];
        });
    }
}


-(BOOL) updatestaffgroupwithoption:(NSString *)option groupkey:(NSString *)groupkey staffkey:(NSString *)staffkey
{

    //combine arrays
    NSDictionary *dictionary = @{@"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"groupkey" : groupkey,
                                 @"staffkey" : staffkey,
                                 @"option" : option,
                                 @"postaction" : @"updatestaffgroup"
                                 };
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    return result;
}

-(void) determinegroupcount
{
    Staff *staffobject;
    groupcountdictionary=[[NSMutableDictionary alloc]init];
    for (int i=0; i<allStaffArray.count; i++) {
        staffobject=[allStaffArray objectAtIndex:i];
        for (int j=0; j<staffobject.grouparray.count;j++) {
            GroupMemberRecord *member=[staffobject.grouparray objectAtIndex:j];
            NSString *count=[groupcountdictionary valueForKey:member.groupkey];
            if (!count) {
                [groupcountdictionary setValue:@"1" forKey:member.groupkey];
            }else{
                count=[NSString stringWithFormat:@"%i",[count intValue]+1];
                [groupcountdictionary removeObjectForKey:member.groupkey];
                [groupcountdictionary setValue:count forKey:member.groupkey];
            }
        }
    }
}

-(void) determineprivilegecount
{
    Staff *staffobject;
    privilegecountdictionary=[[NSMutableDictionary alloc]init];
    for (int i=0; i<allStaffArray.count; i++) {
        staffobject=[allStaffArray objectAtIndex:i];
        NSString *count=[privilegecountdictionary valueForKey:staffobject.privilege];
        if (!count) {
            [privilegecountdictionary setValue:@"1" forKey:staffobject.privilege];
        }else{
            count=[NSString stringWithFormat:@"%i",[count intValue]+1];
            [privilegecountdictionary removeObjectForKey:staffobject.privilege];
            [privilegecountdictionary setValue:count forKey:staffobject.privilege];
        }
    }
}


-(BOOL) isgroupnamealreadyexistwithgroupname:(NSString *)groupname groupkey:(NSString *)groupkey
{
    for (int i=0; i<GroupArray.count; i++) {
        if ([((GroupRecord *)[GroupArray objectAtIndex:i]).groupname caseInsensitiveCompare:groupname]==NSOrderedSame && ![((GroupRecord *)[GroupArray objectAtIndex:i]).groupkey isEqualToString:groupkey]) {
            return TRUE;
        }
    }
    return FALSE;
}

-(BOOL) isprivilegeusertypealreadyexistwithusertype:(NSString *)usertype privilegekey:(NSString *)privilegekey
{
    for (int i=0; i<localprivilegearray.count; i++) {
        if ([((PrivilegeRecord *)[localprivilegearray objectAtIndex:i]).usertype isEqualToString:usertype] && ![((PrivilegeRecord *)[localprivilegearray objectAtIndex:i]).privilegekey isEqualToString:privilegekey]) {
            return TRUE;
        }
    }
    return FALSE;
}


-(NSString *) returnnewgroupname
{
    NSMutableArray *newgrouparray=[[NSMutableArray alloc]init];
    for (int i=0; i<GroupArray.count; i++) {
        GroupRecord *groupobject=[GroupArray objectAtIndex:i];
        if ([groupobject.groupname length]>=9) {
            if ([groupobject.groupname length]>=9 && [[groupobject.groupname substringToIndex:9] isEqualToString:@"New Group"]) {
                [newgrouparray addObject:groupobject.groupname];
            }
        }
    }
    

        for (int i=1; i<1000; i++) {
            if (![newgrouparray containsObject:[NSString stringWithFormat:@"New Group %d",i]]) {
                return [NSString stringWithFormat:@"New Group %d",i];
            }
        }
    
    return @"New Group";
}

-(NSString *) returnnewprivilegename
{
    NSMutableArray *newprivilegearray=[[NSMutableArray alloc]init];
    for (int i=0; i<localprivilegearray.count; i++) {
        PrivilegeRecord *privilegeobject=[localprivilegearray objectAtIndex:i];
        if ([privilegeobject.usertype length]>=9) {
            if ([privilegeobject.usertype length]>=13 && [[privilegeobject.usertype substringToIndex:13] isEqualToString:@"New Privilege"]) {
                [newprivilegearray addObject:privilegeobject.usertype];
            }
        }
    }
    

        for (int i=1; i<1000; i++) {
            if (![newprivilegearray containsObject:[NSString stringWithFormat:@"New Privilege %d",i]]) {
                return [NSString stringWithFormat:@"New Privilege %d",i];
            }
        }
    
    return @"New Privilege";
}

-(void) retrievereplaceinstructorsubjectarray
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self replaceinstructorwithoption:@"retrieve" resetselectedarray:YES];
    });
}

-(void) ri_instructorbuttonpressed:(UIButton *)sender
{
    if (selectedinstructorbutton==frominstructorbutton) {
        frominstructorbutton.backgroundColor=[UIColor whiteColor];
        if (sender==frominstructorbutton) {
            selectedinstructorbutton=nil;
            [self closeblockview];
            return;
        }
    }else if(selectedinstructorbutton==toinstructorbutton){
        toinstructorbutton.backgroundColor=[UIColor whiteColor];
        if (sender==toinstructorbutton) {
            selectedinstructorbutton=nil;
            [self closeblockview];
            return;
        }
    }
    
    selectedinstructorbutton=sender;
    sender.backgroundColor=[UIColor colorWithRed:160.0/255.0 green:191.0/255.0 blue:222.0/255.0 alpha:1];
    
    ri_instructorsearchbar.text=@"";
    ri_filteredinstructorarray=[[NSMutableArray alloc]initWithArray:ri_allinstructorarray];
    [ri_instructortable reloadData];
    
    if(ri_filteredinstructorarray.count>0){
        long presetRow=[MyClass returnInstructorIndexWithInstructorArray:ri_filteredinstructorarray username:selectedinstructorbutton==frominstructorbutton?ri_frominstructor:ri_toinstructor activeinstructor:NO defaultzeroifnotfound:YES];
        [ri_instructortable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        ri_blockview.hidden=NO;
        [userprivilegeviewcontroller.view bringSubviewToFront:ri_blockview];
        [userprivilegeviewcontroller.view bringSubviewToFront:ri_instructorview];
        ri_instructorview.frame=CGRectMake(ri_instructorview.frame.origin.x, ri_instructorview.frame.origin.y, ri_instructorview.frame.size.width, ri_periodview.frame.size.height+10+ri_subjecttable.frame.size.height);
    } completion:nil];
}

-(void) ri_periodbuttonpressed:(UIButton *)sender
{
    if (selectedperiodbutton==fromperiodbutton) {
        fromperiodbutton.backgroundColor=[UIColor whiteColor];
        if (sender==fromperiodbutton) {
            selectedperiodbutton=nil;
            [self closeblockview];
            return;
        }
    }else if(selectedperiodbutton==toperiodbutton){
        toperiodbutton.backgroundColor=[UIColor whiteColor];
        if (sender==toperiodbutton) {
            selectedperiodbutton=nil;
            [self closeblockview];
            return;
        }
    }else if (selectedperiodbutton==dayoptionbutton){
        dayoptionbutton.backgroundColor=[UIColor clearColor];
        if (sender==dayoptionbutton) {
            selectedperiodbutton=nil;
            [self closeblockview];
            return;
        }
    }
    
    selectedperiodbutton=sender;
    sender.backgroundColor=[UIColor colorWithRed:160.0/255.0 green:191.0/255.0 blue:222.0/255.0 alpha:1];
    
    [ri_calendartable reloadData];
    
    [UIView animateWithDuration:0.3 animations:^{
        ri_blockview.hidden=NO;
        [userprivilegeviewcontroller.view bringSubviewToFront:ri_blockview];
        [userprivilegeviewcontroller.view bringSubviewToFront:ri_periodview];
        ri_periodview.frame=CGRectMake(ri_periodview.frame.origin.x, ri_periodview.frame.origin.y, ri_periodview.frame.size.width, ri_instructorview.frame.size.height+10+ri_subjecttable.frame.size.height);
    } completion:nil];
    
}


-(void) closeblockview
{

    if (ri_instructorview.frame.size.height>ri_periodview.frame.size.height) {
        if (selectedinstructorbutton==frominstructorbutton) {
            frominstructorbutton.backgroundColor=[UIColor whiteColor];
        }else{
            toinstructorbutton.backgroundColor=[UIColor whiteColor];
        }

        [UIView animateWithDuration:0.3 animations:^{
            ri_instructorview.frame=CGRectMake(ri_instructorview.frame.origin.x, ri_instructorview.frame.origin.y, ri_instructorview.frame.size.width, ri_periodview.frame.size.height);
        } completion:^(BOOL finished){ ri_blockview.hidden=YES; }];
    }else if (ri_instructorview.frame.size.height<ri_periodview.frame.size.height){
        if (selectedperiodbutton==fromperiodbutton) {
            fromperiodbutton.backgroundColor=[UIColor whiteColor];
        }else if (selectedperiodbutton==toperiodbutton){
            toperiodbutton.backgroundColor=[UIColor whiteColor];
        }else{
            dayoptionbutton.backgroundColor=[UIColor clearColor];
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            ri_periodview.frame=CGRectMake(ri_periodview.frame.origin.x, ri_periodview.frame.origin.y, ri_periodview.frame.size.width, ri_instructorview.frame.size.height);
        } completion:^(BOOL finished){ ri_blockview.hidden=YES; }];
    }
    selectedinstructorbutton=nil;
    selectedperiodbutton=nil;

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if (component==0){
        return [hourPickerViewMenu count];
    }else{
        return [minutePickerViewMenu count];
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
        tView.numberOfLines=3;
    }

    if (component==0){
        tView.text= [hourPickerViewMenu objectAtIndex:row];
    }else{
        tView.text= [minutePickerViewMenu objectAtIndex:row];
    }
    return tView;
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component==0){
        return 40;
    }else{
        return 40;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (selectedperiodbutton==fromperiodbutton) {
        if ([ri_fromperiod isEqualToString:@""]) {
            ri_fromperiod=[NSString stringWithFormat:@"%@ %@:%@",[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"],[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
            [fromperiodbutton setTitle:[self returnriperiodbuttontitlewithbutton:fromperiodbutton titlevalue:ri_fromperiod] forState:UIControlStateNormal];
            [ri_calendartable reloadData];
            [self retrievereplaceinstructorsubjectarray];
        }else{
            if (![ri_fromperiod isEqualToString:[NSString stringWithFormat:@"%@ %@:%@",[ri_fromperiod substringToIndex:11],[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]]]) {
                ri_fromperiod=[NSString stringWithFormat:@"%@ %@:%@",[ri_fromperiod substringToIndex:11],[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
                [fromperiodbutton setTitle:[self returnriperiodbuttontitlewithbutton:fromperiodbutton titlevalue:ri_fromperiod] forState:UIControlStateNormal];
                [ri_calendartable reloadData];
                [self retrievereplaceinstructorsubjectarray];
            }
        }
        clearfromperiodbutton.hidden=NO;
    }else{
        if ([ri_toperiod isEqualToString:@""]) {
            ri_toperiod=[NSString stringWithFormat:@"%@ %@:%@",[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"],[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
            [toperiodbutton setTitle:[self returnriperiodbuttontitlewithbutton:toperiodbutton titlevalue:ri_toperiod] forState:UIControlStateNormal];
            [ri_calendartable reloadData];
            [self retrievereplaceinstructorsubjectarray];
        }else{
            if (![ri_toperiod isEqualToString:[NSString stringWithFormat:@"%@ %@:%@",[ri_toperiod substringToIndex:11],[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]]]) {
                ri_toperiod=[NSString stringWithFormat:@"%@ %@:%@",[ri_toperiod substringToIndex:11],[hourPickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:0]],[minutePickerViewMenu objectAtIndex:[pickerView selectedRowInComponent:1]]];
                [toperiodbutton setTitle:[self returnriperiodbuttontitlewithbutton:toperiodbutton titlevalue:ri_toperiod] forState:UIControlStateNormal];
                [ri_calendartable reloadData];
                [self retrievereplaceinstructorsubjectarray];
            }
        }
        cleartoperiodbutton.hidden=NO;
    }
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    NSString *selecteddatestring=[selecteddatearray firstObject];
    if (selectedperiodbutton==fromperiodbutton) {
        if ([ri_fromperiod isEqualToString:@""]) {
            ri_fromperiod=[NSString stringWithFormat:@"%@ %@",selecteddatestring,@"00:00"];
            [fromperiodbutton setTitle:[self returnriperiodbuttontitlewithbutton:fromperiodbutton titlevalue:ri_fromperiod] forState:UIControlStateNormal];
            [ri_calendartable reloadData];
            [self retrievereplaceinstructorsubjectarray];
        }else{
            if (![ri_fromperiod isEqualToString:[NSString stringWithFormat:@"%@ %@",selecteddatestring,[ri_fromperiod substringFromIndex:12]]]) {
                ri_fromperiod=[NSString stringWithFormat:@"%@ %@",selecteddatestring,[ri_fromperiod substringFromIndex:12]];
                [fromperiodbutton setTitle:[self returnriperiodbuttontitlewithbutton:fromperiodbutton titlevalue:ri_fromperiod] forState:UIControlStateNormal];
                [ri_calendartable reloadData];
                [self retrievereplaceinstructorsubjectarray];
            }
        }
        clearfromperiodbutton.hidden=NO;
    }else{
        if ([ri_toperiod isEqualToString:@""]) {
            ri_toperiod=[NSString stringWithFormat:@"%@ %@",selecteddatestring,@"23:59"];
            [toperiodbutton setTitle:[self returnriperiodbuttontitlewithbutton:toperiodbutton titlevalue:ri_toperiod] forState:UIControlStateNormal];
            [ri_calendartable reloadData];
            [self retrievereplaceinstructorsubjectarray];
        }else{
            if (![ri_toperiod isEqualToString:[NSString stringWithFormat:@"%@ %@",selecteddatestring,[ri_toperiod substringFromIndex:12]]]) {
                ri_toperiod=[NSString stringWithFormat:@"%@ %@",selecteddatestring,[ri_toperiod substringFromIndex:12]];
                [toperiodbutton setTitle:[self returnriperiodbuttontitlewithbutton:toperiodbutton titlevalue:ri_toperiod] forState:UIControlStateNormal];
                [ri_calendartable reloadData];
                [self retrievereplaceinstructorsubjectarray];
            }
        }
        cleartoperiodbutton.hidden=NO;
    }
    
}

-(void) clearriperiod:(UIButton *)sender
{
    if (sender.tag==0) {
        ri_fromperiod=@"";
        [fromperiodbutton setTitle:[self returnriperiodbuttontitlewithbutton:fromperiodbutton titlevalue:ri_fromperiod] forState:UIControlStateNormal];
    }else{
        ri_toperiod=@"";
        [toperiodbutton setTitle:[self returnriperiodbuttontitlewithbutton:toperiodbutton titlevalue:ri_toperiod] forState:UIControlStateNormal];
    }
    sender.hidden=YES;
    
    fromperiodbutton.backgroundColor=[UIColor whiteColor];
    toperiodbutton.backgroundColor=[UIColor whiteColor];
    [self retrievereplaceinstructorsubjectarray];
    [self closeblockview];
}

-(NSString *) returnriperiodbuttontitlewithbutton:(UIButton *)button titlevalue:(NSString *)titlevalue
{
    if (button.tag==0) {
        if ([titlevalue isEqualToString:@""]) {
            return [MyClass returntitlewithtitle:@"No start date"];
        }else{
            return [MyClass returndateformatDDMMMYYYYHHMMwithdate:titlevalue];
        }
    }else{
        if ([titlevalue isEqualToString:@""]) {
            return [MyClass returntitlewithtitle:@"No end date"];
        }else{
            return [MyClass returndateformatDDMMMYYYYHHMMwithdate:titlevalue];
        }
    }
}

-(void) updateDayOptionButtonTitle
{
    NSString *resultstring;
    if (selectedDayOptionArray.count==7) {
        resultstring= [MyClass returntitlewithtitle:@"All Days"];
    }else if (selectedDayOptionArray.count==0){
        resultstring= [MyClass returntitlewithtitle:@"None Days"];
    }else{
        NSMutableArray *result=[[NSMutableArray alloc]init];
        for (int i=0; i<dayOptionArray.count; i++) {
            if ([selectedDayOptionArray containsObject:[dayOptionArray objectAtIndex:i]]) {
                [result addObject:[MyClass returntitlewithtitle:[dayOptionArray objectAtIndex:i]]];
            }
        }
        resultstring= [result componentsJoinedByString:@","];
    }
    
    [dayoptionbutton setTitle:resultstring forState:UIControlStateNormal];
    [dayoptionbutton sizeToFit];
    dayoptionbutton.frame=CGRectMake(ri_instructorview.frame.size.width-15-dayoptionbutton.frame.size.width-10, 12, dayoptionbutton.frame.size.width+10, 26);
}

- (IBAction)selectPolicyType:(UISegmentedControl *)sender {
    generalPolicyView.hidden=sender.selectedSegmentIndex!=0;
    tncPolicyView.hidden=sender.selectedSegmentIndex!=1;
    leavePolicyView.hidden=sender.selectedSegmentIndex!=2;
    if (sender.selectedSegmentIndex==2) {
        selectedLeaveNatureRow=0;
    }
    [self retrievepolicy];
}

-(NSString *) returnnewnatureenglishname
{
    NSMutableArray *newnaturearray=[[NSMutableArray alloc]init];
    for (int i=0; i<leaveNatureArray.count; i++) {
        LeaveNatureRecord *natureobject=[leaveNatureArray objectAtIndex:i];
        if ([natureobject.nature_desc_english length]>=10) {
            if ([[natureobject.nature_desc_english substringToIndex:10] isEqualToString:@"New Nature"]) {
                [newnaturearray addObject:natureobject.nature_desc_english];
            }
        }
        
        if ([natureobject.nature_desc_chinese length]>=[[MyClass returntitlewithtitle:@"New Nature"] length]) {
            if ([[natureobject.nature_desc_english substringToIndex:[[MyClass returntitlewithtitle:@"New Nature"] length]] isEqualToString:[MyClass returntitlewithtitle:@"New Nature"]]) {
                [newnaturearray addObject:natureobject.nature_desc_chinese];
            }
        }
    }
    
    
    for (int i=1; i<1000; i++) {
        if (![newnaturearray containsObject:[NSString stringWithFormat:@"New Nature %d",i]] && ![newnaturearray containsObject:[NSString stringWithFormat:@"%@%d",[MyClass returntitlewithtitle:@"New Nature"],i]]) {
            return [NSString stringWithFormat:@"New Nature %d",i];
        }
    }
    
    return @"New Nature";
}

-(NSString *) returnnewnaturechinesenamewithenglishnaturename:(NSString *)name
{
    return [NSString stringWithFormat:@"%@%@",[MyClass returntitlewithtitle:@"New Nature"],[name substringFromIndex:11]];
}

- (IBAction)addLeaveNature:(id)sender {
    [self.view endEditing:YES];
    NSString *newnaturename=[self returnnewnatureenglishname];
    
    //combine arrays
    NSDictionary *dictionary = @{@"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"nature_desc_english" : newnaturename,
                                 @"nature_desc_chinese" : [self returnnewnaturechinesenamewithenglishnaturename:newnaturename],
                                 @"listorder" : [@(leaveNatureArray.count) stringValue],
                                 @"postaction" : @"addleavenature"
                                 };
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if (result) {
        leaveNatureArray= [MyClass retrieveLeaveNatureArrayWithFlushCacheData:YES];
        selectedLeaveNatureRow=leaveNatureArray.count-1;
        [leaveNatureListTable reloadData];
        [self tableView:leaveNatureListTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedLeaveNatureRow inSection:0]];
    }
}

- (IBAction)deleteLeaveNature:(id)sender {
    [self.view endEditing:YES];
    
    if(workingleavenatureobject.is_student_request && [MyClass lastLeaveNatureStudentRequest]){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Leave nature cannot be deleted"] message:[MyClass returntitlewithtitle:@"At least one nature with available for student request enabled is required"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else if(leaveNatureArray.count==1){
        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Leave nature cannot be deleted"] message:[MyClass returntitlewithtitle:@"At least one nature is required"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
    }else{
        //combine arrays
        NSDictionary *dictionary = @{@"centerdb" : globalvariables.centerrecord.centerdb,
                                     @"centerkey" : globalvariables.centerrecord.centerkey,
                                     @"leavenaturelistkey" : workingleavenatureobject.leavenaturelistkey,
                                     @"postaction" : @"deleteleavenature"
                                     };
        
        __block BOOL result=FALSE;
        __block BOOL deleted=FALSE;
        [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                JSONArray = jsonreturned[@"content"];
                    deleted=[[[JSONArray objectAtIndex:0] objectForKey:@"result"] isEqualToString:@"success"];
            }
        }];
        
        if (result) {
            if(deleted){
                leaveNatureArray= [MyClass retrieveLeaveNatureArrayWithFlushCacheData:YES];
                if(leaveNatureArray.count-1<selectedLeaveNatureRow){
                    selectedLeaveNatureRow-=1;
                }
                [leaveNatureListTable reloadData];
                if(selectedLeaveNatureRow>=0){
                    [self tableView:leaveNatureListTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedLeaveNatureRow inSection:0]];
                }
            }else{
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Leave nature cannot be deleted"] message:[MyClass returntitlewithtitle:@"Leave nature has been used"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                                [erroralert addAction:OKAction];
                //[self presentViewController:erroralert animated:YES completion:nil];
                [MyClass presentViewController:erroralert View:self];
            }
        }
    }
}

-(void) returnCalendarYear:(NSString *)year{}


@end
