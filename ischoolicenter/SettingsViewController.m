//
//  SettingsViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 5/15/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "SettingsViewController.h"
#import "MainMenuViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MyClass.h"
#import "MyTableViewCell.h"

@interface SettingsViewController ()
{
    NSMutableDictionary *edgeConstants;
}
@end

#define menutablewidth 350
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]

@implementation SettingsViewController
@synthesize JSONArray, ClassfeeArray,ClassfeeObject;

/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

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
    
    //[self openDB];
    menuitem_section_0=[[NSArray alloc]initWithObjects:@"General",nil];
    menuitem_section_3=[[NSArray alloc]initWithObjects:@"Student Profile",@"Highlights",@"Daily Class Schedule",@"Center Time Table",@"Course Renewal",@"Message Center",@"Photo Corner",@"Lead Profile", nil];
    menuitem_section_4=[[NSArray alloc]initWithObjects:@"Attendance",@"Financial",@"Printing",@"Calendar",@"Enrollment",@"Course",@"Auto Notifications",@"Membership",@"Chatbot",@"Evaluation Form",@"Center QR Code",@"User Account",nil];
    menuitem_section_5=[[NSArray alloc]initWithObjects:@"iStaff", nil];
    menuitem_section_6=[[NSArray alloc]initWithObjects:@"iParent", nil];
    menuitem_section_1=[[NSArray alloc]initWithObjects:@"Account", nil];
    menuitem_section_2=[[NSArray alloc]initWithObjects:@"What's New", nil];
    
    
   // menutable=[[UITableView alloc]initWithFrame:CGRectMake(0, 68, menutablewidth, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    //menutable.dataSource=self;
    //menutable.delegate=self;
    //[self.view addSubview:menutable];
    
    [menutable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    notificationview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    notificationview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:notificationview];
    notification_section_class=[[NSArray alloc]initWithObjects:@"Last Class",@"First Class",@"Outstanding Class",@"Pending Renewal Class",@"Assessment Class",@"Trial Class",@"Makeup Class",@"Absent Class", nil];
    //notification_section_message=[[NSArray alloc]initWithObjects:@"Important Message",@"Promotional Message",@"General Message",nil];
    //notification_section_task=[[NSArray alloc]initWithObjects:@"My Task",@"Task to Others",@"All Other Task",nil];
    
    notification_class_parameters=[[NSArray alloc]initWithObjects:@"showlastclass",@"showfirstclass",@"showoutstandingclass",@"showpendingrenewalclass",@"showassessclass",@"showtrialclass",@"showmakeupclass",@"showabsentclass",nil];
    //notification_message_parameters=[[NSArray alloc]initWithObjects:@"showimportantmessage",@"showpromotionalmessage",@"showgeneralmessage", nil];
    //notification_task_parameters=[[NSArray alloc]initWithObjects:@"showmytask",@"showtasktoother",@"showallothertask", nil];
    
    notificationtable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    notificationtable.delegate=self;
    notificationtable.dataSource=self;
    notificationtable.scrollEnabled=FALSE;
    [notificationview addSubview:notificationtable];
    if ([notificationtable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        notificationtable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    

    
    
    dailyscheduleview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    dailyscheduleview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:dailyscheduleview];
    dailyschedule_parameters_0=[[NSArray alloc]initWithObjects:@"Maximum Line Per Page",@"Show Contact Number",@"Show Due Payment",nil];
    dailyschedule_parameters_1=[[NSArray alloc]initWithObjects:@"Show Subject Color",@"Show Instructor Color",nil];
    dailyscheduletable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    dailyscheduletable.delegate=self;
    dailyscheduletable.dataSource=self;
    dailyscheduletable.scrollEnabled=FALSE;
    [dailyscheduleview addSubview:dailyscheduletable];
    if ([dailyscheduletable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        dailyscheduletable.cellLayoutMarginsFollowReadableWidth=NO;
    }

    classtimetableview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    classtimetableview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:classtimetableview];
    classtimetable_parameters_0=[[NSArray alloc]initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",nil];
    classtimetable_parameters_1=[self returntimetabledisplayorderarray];
    classtimetable_parameters_2=[[NSArray alloc]initWithObjects:@"Outstanding Payment Mode",nil];
    classtimetable_parameters_3=[[NSArray alloc]initWithObjects:@"Show All Student Count",@"Show Attending Student Count",@"Show Outstanding Payment Student Count",@"Show Age",nil];
    classtimetable_parameters_4=[[NSArray alloc]initWithObjects:@"Full Day",@"Class Start Time",@"Class End Time",@"Class Time Interval",nil];
    classtimetable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    classtimetable.delegate=self;
    classtimetable.dataSource=self;
//    classtimetable.scrollEnabled=FALSE;
    [classtimetable setEditing:YES animated:YES];
    [classtimetableview addSubview:classtimetable];
    if ([classtimetable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        classtimetable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    
    courserenewalview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    courserenewalview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:courserenewalview];
    courserenewal_parameters_0=[[NSArray alloc]initWithObjects:@"Enable Auto Batch Renewal",@"No. of business days in advance to renew the non-monthly course", @"Day of month to renew the monthly course for following month",@"Automatically Send eInvoice",nil];
    courserenewal_parameters_1=[[NSArray alloc]initWithObjects:@"Renew even if there is TBD class",@"Use Reserved Day during Renewal",@"Mark Reserved Day to Makeup",@"Jump to Next Level during Renewal",@"Neglect Makeup Classes during Renewal (Enrollment finding)",@"Neglect Makeup Classes during Renewal (Scheduling)",nil];
    courserenewal_parameters_2=[[NSArray alloc]initWithObjects:@"Adjust Standard Period To Month End", nil];
    courserenewaltable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    courserenewaltable.delegate=self;
    courserenewaltable.dataSource=self;
    courserenewaltable.scrollEnabled=FALSE;
    [courserenewalview addSubview:courserenewaltable];
    if ([courserenewaltable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        courserenewaltable.cellLayoutMarginsFollowReadableWidth=NO;
    }

    
    attendanceview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    attendanceview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:attendanceview];
    attendance_parameters_0=[[NSArray alloc]initWithObjects:@"New Classes", @"Auto Attendance Taking after Class",nil];
    attendance_parameters_1=[[NSArray alloc]initWithObjects:@"Enable",@"Scanner Type",@"Start Before Class in Minute",@"End After Class in Minute",@"Scanner Power Off Code", nil];
    attendance_parameters_2=[[NSArray alloc]initWithObjects:@"Present Alert",@"Absent Alert",@"Makeup Alert", nil];
    attendance_parameters_3=[[NSArray alloc]initWithObjects:@"Extend Class", nil];
    attendancetable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    attendancetable.delegate=self;
    attendancetable.dataSource=self;
    [attendanceview addSubview:attendancetable];
    if ([attendancetable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        attendancetable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    //arcodearray=[MyClass retrieveArcodeListwithflushcachedata:YES];
    financialview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    financialview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:financialview];
    financial_parameters_0=[[NSArray alloc]initWithObjects:@"No. of Decimal Place", nil];
    financial_parameters_1=[[NSArray alloc]initWithObjects:@"No. of Week as Denominator for Incomplete Month", nil];
    financial_parameters_2=[[NSArray alloc]initWithObjects:@"Enrollment Fee",@"Auto Apply for First Enrollment",@"Waive for Resumed Student in no. of Month",nil];
    financial_parameters_3=[[NSArray alloc]initWithObjects:@"Late Fee",@"Fee",@"Grace Period", nil];
    financial_parameters_4=[[NSArray alloc]initWithObjects:@"Cheque Payable", nil];
    financial_parameters_5=[[NSArray alloc]initWithObjects:@"Direct Debit Authorization", nil];
    financial_parameters_6=[[NSArray alloc]initWithObjects:@"Course Enrollment", @"Product Sales",nil];
    financial_parameters_8=[[NSMutableArray alloc]initWithObjects:@"Enable Account Receivable Codes",nil];
    financial_parameters_7=[[NSArray alloc]initWithObjects:@"Remove Unpaid and Expired Promotion",nil];
    financialtable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    financialtable.delegate=self;
    financialtable.dataSource=self;
    [financialview addSubview:financialtable];
    if ([financialtable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        financialtable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    
    printingview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    printingview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:printingview];
    printing_parameters_1=[[NSArray alloc]initWithObjects:@"Print A5 Size on A4",@"General Font Size",@"T&C Font Size",@"Default Print Color",@"Show Class Dates",@"Show Level", @"Show Discount Details",@"Invoice Prefix",nil];
    printing_parameters_2=[[NSArray alloc]initWithObjects:@"Print A5 Size on A4",@"General Font Size",@"T&C Font Size",@"Default Print Color",@"Show Class Dates",@"Show Level", @"Show Discount Details", @"Show Staff Name",@"Show Last Payment Details Only",@"Automatically Send eReceipt",@"Receipt Prefix",nil];
    printing_parameters_3=[[NSArray alloc]initWithObjects:@"Class Date Mode",@"Show End Time",nil];
    
    printingtable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    printingtable.delegate=self;
    printingtable.dataSource=self;
    [printingview addSubview:printingtable];
    if ([printingtable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        printingtable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    calendarview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    calendarview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:calendarview];
    calendar_parameters_0=[[NSArray alloc]initWithObjects:@"Reserve Working Days", nil];
    calendartable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    calendartable.delegate=self;
    calendartable.dataSource=self;
    calendartable.scrollEnabled=FALSE;
    [calendarview addSubview:calendartable];
    if ([calendartable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        calendartable.cellLayoutMarginsFollowReadableWidth=NO;
    }

    enrollmentview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    enrollmentview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:enrollmentview];
    enrollment_parameters_0=[[NSArray alloc]initWithObjects:@"Validity Period",@"Show Validity Period in Invoice/Receipt", nil];
    enrollment_parameters_1=[[NSArray alloc]initWithObjects:@"Makeup Quota",@"Maximum Day Range for Makeup Class",@"No. of Day after Original Class",nil];
    enrollment_parameters_2=[[NSArray alloc]initWithObjects:@"Mark Expired Class to Absent Automatically",@"Update Class Upon Schedule Changes",@"Lock Class after No. of Day",@"Auto Drop Enrollment after No. of Day",nil];
    enrollment_parameters_3=[[NSArray alloc]initWithObjects:@"Lesson Number",nil];
    enrollment_parameters_4=[[NSArray alloc]initWithObjects:@"Save Location",nil];
    enrollment_parameters_5=[[NSArray alloc]initWithObjects:@"Secondary Instructor",@"Use Reserved Day during Enrollment",@"Mark Reserved Day to Makeup during Enrollment",@"Default Copy Discount Upon Enrollment Cloning",@"Remove Expired Coupon for Unpaid Enrollment",nil];
//    enrollment_parameters_5=[[NSArray alloc]initWithObjects:@"Update Class Upon Schedule Changes",nil];
//    enrollment_parameters_6=[[NSArray alloc]initWithObjects:@"Default Copy Discount Upon Enrollment Cloning",nil];
    enrollmenttable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    enrollmenttable.delegate=self;
    enrollmenttable.dataSource=self;
//    enrollmenttable.scrollEnabled=FALSE;
    [enrollmentview addSubview:enrollmenttable];
    if ([enrollmenttable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        enrollmenttable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    courseview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    courseview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:courseview];
    course_parameters_0=[[NSArray alloc]initWithObjects:@"Default Show In Timetable If No enrollment",@"Default Makeup Schedule",nil];
    coursetable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    coursetable.delegate=self;
    coursetable.dataSource=self;
    coursetable.scrollEnabled=FALSE;
    [courseview addSubview:coursetable];
    if ([coursetable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        coursetable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
//    membershipview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
//    membershipview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:membershipview];
    membership_parameters_0=[[NSArray alloc]initWithObjects:@"Enable Point",@"Default Point Expiry Days",@"Issue Point with Parent App Logged in only",@"Issue Point for Online Payment only",@"Issue Point for On Time Payment only",@"Transfer point for internal transfer payment",nil];
    membership_parameters_1=[[NSArray alloc]initWithObjects:@"Enrollment Spending to Point Ratio",@"Sales Spending to Point Ratio",@"Point Earned per Class Using QR Code Check-in",@"Point Earned per Self Makeup",nil];
//    membershiptable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
//    membershiptable.delegate=self;
//    membershiptable.dataSource=self;
//    membershiptable.scrollEnabled=FALSE;
//    [membershipview addSubview:membershiptable];
    if ([membershiptable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        membershiptable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    chatbotview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    chatbotview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:chatbotview];
    chatbot_parameters_0=[[NSArray alloc]initWithObjects:@"Enable Chatbot",@"Maximum Day Range for Trial Class",@"Earliest Time for Trial Arrangement in Hour(s)", nil];
    chatbottable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    chatbottable.delegate=self;
    chatbottable.dataSource=self;
    chatbottable.scrollEnabled=FALSE;
    [chatbotview addSubview:chatbottable];
    if ([chatbottable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        chatbottable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    evaluationformview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    evaluationform_parameters_0=[[NSArray alloc]initWithObjects:@"Enable Evaluation Form", nil];
    evaluationform_parameters_1=[[NSArray alloc]initWithObjects:@"Show Center Average Score", nil];
    evaluationform_parameters_2=[[NSMutableArray alloc]init];
    if ([evaluationformtable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        evaluationformtable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    centerqrcodeview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    centerqrcode_parameters_0=[[NSArray alloc]initWithObjects:@"e-Enrollment Form Code Refresh Frequency",@"Attendance Code Refresh Frequency", nil];
    if ([centerqrcodetable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        centerqrcodetable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    istaffview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    istaffview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:istaffview];
    istaff_parameters_0=[[NSArray alloc]initWithObjects:@"Attendance Taking", @"No. of Past Day to be Included in My Student Class Schedule", nil];
    istafftable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    istafftable.delegate=self;
    istafftable.dataSource=self;
    istafftable.scrollEnabled=FALSE;
    [istaffview addSubview:istafftable];
    if ([istafftable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        istafftable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    useraccountview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    useraccountview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:useraccountview];
    useraccount_parameters_0=[[NSArray alloc]initWithObjects:@"Staff Password Expiration Period in Day", nil];
    useraccounttable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    useraccounttable.delegate=self;
    useraccounttable.dataSource=self;
    useraccounttable.scrollEnabled=FALSE;
    [useraccountview addSubview:useraccounttable];
    if ([useraccounttable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        useraccounttable.cellLayoutMarginsFollowReadableWidth=NO;
    }

    iparentview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    iparentview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:iparentview];
    iparent_parameters_0=[[NSArray alloc]initWithObjects:@"Automatically Send Parent App Download Invite SMS", nil];
    iparent_parameters_1=[[NSArray alloc]initWithObjects:@"User can Update Personal Information", nil];
    iparent_parameters_2=[[NSArray alloc]initWithObjects:@"Show Enrollment Tuition Fee in Enrollment Records", @"Show Only Non Dropped Enrollments in Enrollment Records",@"Show Classroom in Class Schedule",@"Show End Time in Class Schedule",@"Show user defined schedule name when arranging makeup or class",@"Show renewal reminder items in Notifications",nil];
    iparent_parameters_3=[[NSArray alloc]initWithObjects:@"No. of Past Day to be Included in Class Schedule",@"Receive Next Day Class Reminder", nil];
    iparent_parameters_4=[[NSArray alloc]initWithObjects:@"Receive Expiring Class Reminder",@"First Reminder before Expiry",@"Recursive Reminder after First",nil];
    iparent_parameters_5=[[NSArray alloc]initWithObjects:@"First Reminder before Expiry",@"Recursive Reminder after First",nil];
    iparent_parameters_6=[[NSArray alloc]initWithObjects:@"First Reminder before Expiry",@"Recursive Reminder after First",nil];
    iparent_parameters_7=[[NSArray alloc]initWithObjects:@"Leave Application Mode", @"Leave Approval Mode",@"Minimum Number of Days to Apply Leave in Advance",@"Earliest Time for Class Arrangement in Hour(s)",nil];
    iparent_parameters_8=[[NSArray alloc]initWithObjects:@"Class Schedule", @"Messages",@"Photo Corner",@"Enrollment Records",@"Sales Records",nil];
    iparent_parameters_9=[[NSArray alloc]initWithObjects:@"Allow Parent to Send Message",@"Allow Parent to Send Voice Message",@"Allow Parent to Send Video Message",nil];
    iparent_parameters_10=[[NSArray alloc]initWithObjects:@"Color Scheme (branded app only)", nil];
    
    iparenttable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    iparenttable.delegate=self;
    iparenttable.dataSource=self;
    [iparentview addSubview:iparenttable];
    if ([iparenttable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        iparenttable.cellLayoutMarginsFollowReadableWidth=NO;
    }

    messagecenterview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    messagecenterview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:messagecenterview];
    messagecenter_parameters_0=[[NSArray alloc]initWithObjects:@"Student",@"Lead", nil];
    messagecenter_parameters_1=[[NSArray alloc]initWithObjects:@"Voice_Message", @"Video_Message", nil];
    messagecentertable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    messagecentertable.delegate=self;
    messagecentertable.dataSource=self;
    messagecentertable.scrollEnabled=FALSE;
    [messagecenterview addSubview:messagecentertable];
    if ([messagecentertable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        messagecentertable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    photocornerview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    photocornerview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:photocornerview];
    photocorner_parameters_0=[[NSArray alloc]initWithObjects:@"Send Notification to iParent", nil];
    photocornertable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    photocornertable.delegate=self;
    photocornertable.dataSource=self;
    photocornertable.scrollEnabled=FALSE;
    [photocornerview addSubview:photocornertable];
    if ([photocornertable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        photocornertable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    studentprofileview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    studentprofileview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:studentprofileview];
    studentprofile_section_0=[[NSArray alloc]initWithObjects:@"Auto Fill Student ID",@"Prefix", nil];
    studentprofile_section_1=[self returnstudentnamedisplayorderarray];
    studentprofile_section_2=[[NSArray alloc]initWithObjects:@"Enable New Student to Receive Promotional Message",@"Enable New Student to Send Message",@"Enable iParent for New Contact",@"Enable SMS for New Contact",nil];
    studentprofile_section_3=[[NSArray alloc]initWithObjects:@"Promote Student School Grade",@"Recalculate Tuition Fee for Coming Unpaid Enrollments", nil];
//    studentprofile_section_4=[[NSArray alloc]initWithObjects:@"Evaluation Form", nil];
    studentprofile_section_4=[[NSArray alloc]initWithObjects:@"ExtraField1", @"Minimun Student Phone Number Required",nil];
    studentprofiletable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    studentprofiletable.delegate=self;
    studentprofiletable.dataSource=self;
    //studentprofiletable.scrollEnabled=FALSE;
    [studentprofiletable setEditing:YES animated:YES];
    [studentprofileview addSubview:studentprofiletable];
    if ([studentprofiletable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        studentprofiletable.cellLayoutMarginsFollowReadableWidth=NO;
    }

    leadprofileview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    leadprofileview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:leadprofileview];
    leadprofile_section_0=[[NSArray alloc]initWithObjects:@"Auto Fill Lead ID", nil];
    leadprofile_section_1=[self returnleadnamedisplayorderarray];
    leadprofile_section_2=[[NSArray alloc]initWithObjects:@"Enable New Lead to Receive Promotional Message",nil];
    leadprofiletable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    leadprofiletable.delegate=self;
    leadprofiletable.dataSource=self;
    leadprofiletable.scrollEnabled=FALSE;
    [leadprofiletable setEditing:YES animated:YES];
    [leadprofileview addSubview:leadprofiletable];
    if ([leadprofiletable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        leadprofiletable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    accountview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    accountview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:accountview];
    account_parameters=[[NSArray alloc]initWithObjects:@"Enter Old Password",@"Enter New Password",@"Re-enter New Password", nil];
    accounttable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    accounttable.delegate=self;
    accounttable.dataSource=self;
    [accountview addSubview:accounttable];
    if ([accounttable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        accounttable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    generaleview=[[UIView alloc]initWithFrame:CGRectMake(menutablewidth, 68, self.view.bounds.size.width-menutablewidth, self.view.bounds.size.height-68)];
    generaleview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:generaleview];
    generaltable=[[UITableView alloc]initWithFrame:CGRectMake(30, 0, self.view.bounds.size.width-menutablewidth-60, self.view.bounds.size.height-68) style:UITableViewStyleGrouped];
    generaltable.delegate=self;
    generaltable.dataSource=self;
    generaltable.scrollEnabled=FALSE;
    [generaleview addSubview:generaltable];
    if ([generaltable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        generaltable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    
    //add separator
    UILabel *separator=[[UILabel alloc]initWithFrame:CGRectMake(menutablewidth-1, 68, 1, self.view.bounds.size.height-68)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
    
    
    [self refreshlanguage];
    
    tmpprintlogoimage=[[UIImageView alloc]init];
    
    runviewdidappear=TRUE;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checktoreloadapp) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    scAutoNotificationType.tintColor=themecolor;
    
    
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

-(void) checktoreloadapp
{
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {
        if (self.presentedViewController==switchcenterviewcontroller) {
            [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.mainSlideMenu closeLeftMenu];
        }
        globalvariables.appbecomeactiveaction=@"";
        globalvariables.leftmenuindex=@"0";
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [MyClass reloadApp];
    }else if ([globalvariables.appbecomeactiveaction isEqualToString:@"refresh"]){
        
        globalvariables.appbecomeactiveaction=@"";

                if (self.presentedViewController==switchcenterviewcontroller) {
                    [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
                }else{
                    [self.mainSlideMenu closeLeftMenu];
                }
                
                [self reloadPageWithFirstLoad:NO];
            //}
        //}];
    }
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.mainSlideMenu disableSlidePanGestureForRightMenu];
    globalvariables.lastviewcontroller=(NSString *)self;
    
    if (runviewdidappear) {
            [self.view endEditing:YES];
        
        [self reloadPageWithFirstLoad:YES];
    }else{
        runviewdidappear=TRUE;
    }


}

-(void) refreshlanguage
{
    
    headercentername.text=[MyClass returnWindowTitle];
    headertitlename.text=[MyClass returntitlewithtitle:@"Settings"];
    [self updateheadercentertitle];
    //[self loadtitle];
    
    [scAutoNotificationType setTitle:[MyClass returntitlewithtitle:@"Course Outstanding"] forSegmentAtIndex:0];
    [scAutoNotificationType setTitle:[MyClass returntitlewithtitle:@"Sales Outstanding"] forSegmentAtIndex:1];
    [scAutoNotificationType setTitle:[MyClass returntitlewithtitle:@"Renewal"] forSegmentAtIndex:2];
    [scAutoNotificationType setTitle:[MyClass returntitlewithtitle:@"1st Class"] forSegmentAtIndex:3];
    [scAutoNotificationType setTitle:[MyClass returntitlewithtitle:@"Assess./Trial"] forSegmentAtIndex:4];
    
    
    
    
}

- (CGFloat)visibleSettingsWidth
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

- (CGFloat)visibleSettingsHeight
{
    CGFloat height = self.view.bounds.size.height;
    UIWindow *window = self.view.window;
    if (!window || height < 1) return height;
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    return MAX(MIN(MIN(CGRectGetMaxY(frameInWindow), CGRectGetMaxY(window.bounds)) - CGRectGetMinY(frameInWindow), height), 0);
}

- (void)layoutSettingsForCurrentSize
{
    CGFloat width = [self visibleSettingsWidth];
    CGFloat height = [self visibleSettingsHeight];
    if (width < 1 || height < 1) return;
    if (!edgeConstants) {
        edgeConstants = [NSMutableDictionary dictionary];
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            BOOL horizontal = constraint.firstItem == self.view && (constraint.firstAttribute == NSLayoutAttributeTrailing || constraint.firstAttribute == NSLayoutAttributeTrailingMargin) && constraint.secondAttribute == NSLayoutAttributeTrailing;
            BOOL vertical = constraint.firstItem == self.view && (constraint.firstAttribute == NSLayoutAttributeBottom || constraint.firstAttribute == NSLayoutAttributeBottomMargin) && constraint.secondAttribute == NSLayoutAttributeBottom;
            if (horizontal || vertical) {
                edgeConstants[[NSValue valueWithNonretainedObject:constraint]] = @(constraint.constant);
            }
        }
    }
    CGFloat overflow = MAX(self.view.bounds.size.width - width, 0);
    CGFloat verticalOverflow = MAX(self.view.bounds.size.height - height, 0);
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        NSNumber *original = edgeConstants[[NSValue valueWithNonretainedObject:constraint]];
        if (!original) continue;
        BOOL vertical = constraint.firstAttribute == NSLayoutAttributeBottom || constraint.firstAttribute == NSLayoutAttributeBottomMargin;
        CGFloat target = original.doubleValue + (vertical ? verticalOverflow : overflow);
        if (fabs(constraint.constant - target) > 0.5) constraint.constant = target;
    }
    CGFloat contentWidth = MAX(width - menutablewidth, 0);
    CGFloat contentHeight = MAX(height - 68.0, 0);
    for (UIView *subview in self.view.subviews) {
        if (fabs(subview.frame.origin.x - menutablewidth) < 1.0 && subview.frame.origin.y >= 67.0) {
            subview.frame = CGRectMake(menutablewidth, 68, contentWidth, contentHeight);
            for (UIView *child in subview.subviews) {
                if ([child isKindOfClass:[UITableView class]]) {
                    child.frame = CGRectMake(30, 0, MAX(contentWidth - 60.0, 0), contentHeight);
                }
            }
        } else if (fabs(subview.frame.origin.x - (menutablewidth - 1)) < 1.0 && subview.frame.size.width < 3.0) {
            subview.frame = CGRectMake(menutablewidth - 1, 68, 1, contentHeight);
        }
    }
    CGFloat titleWidth = MAX(width - 140.0, 0);
    headertitleview.frame = CGRectMake(70, 0, titleWidth, 68);
    headertitlename.frame = CGRectMake(0, 25, titleWidth, 20);
    switchcenterbutton.frame = CGRectMake(0, 0, titleWidth, 68);
    [self updateheadercentertitle];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutSettingsForCurrentSize];
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





- (void)editdailyclassmaxrow:(UITextField *)sender {
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        [MyClass updatelocaldbwithparameter:@"dailyclassschedulemaxrow" value:sender.text];
    }else{
        [dailyscheduletable reloadData];
    }
}

- (void)editscannerpoweroffcode:(UITextField *)sender {
    //[MyClass updatelocaldbwithparameter:@"scannerpoweroffcode" value:sender.text];
    [MyClass updateCenterInformationWithField:@"scannerpoweroffcode" Value:sender.text];
    globalvariables.centerrecord.scannerpoweroffcode=sender.text;
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


/*
-(void) retrievedailyclassschedulemaxrow
{
    dailyclassschedulemaxrowtext.text=[MyClass getlocaldbwithparameter:@"dailyclassschedulemaxrow"];
    dailyclassschedulemaxrowstepper.value=[dailyclassschedulemaxrowtext.text doubleValue];
}*/

-(BOOL) hasExtendedClass
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=hasextendedclass",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey];
    
    __block BOOL result=YES;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSString *content = jsonreturned[@"content"];
            result=[content isEqualToString:@"Yes"];
        }
    }];

    return result;
}


- (void)changepasswordbuttonpressed:(id)sender {
    
    [self.view endEditing:YES];
    
    if ([oldpasswordtext.text isEqualToString:@""] || [newpasswordtext.text isEqualToString:@""] || [confirmpasswordtext.text isEqualToString:@""]) {

        UIAlertController *wrongpasswordalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Change Password"] message:[MyClass returntitlewithtitle:@"Password are not entered"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [wrongpasswordalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [wrongpasswordalert addAction:OKAction];
        [self presentViewController:wrongpasswordalert animated:YES completion:nil];
    }else{
        if (![globalvariables.password isEqualToString:oldpasswordtext.text]) {

            UIAlertController *wrongpasswordalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Change Password"] message:[MyClass returntitlewithtitle:@"Old Password is not correct"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [wrongpasswordalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [wrongpasswordalert addAction:OKAction];
            [self presentViewController:wrongpasswordalert animated:YES completion:nil];
            
        }else if (![confirmpasswordtext.text isEqualToString:newpasswordtext.text]) {

            UIAlertController *wrongpasswordalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Change Password"] message:[MyClass returntitlewithtitle:@"New passwords do not match"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [wrongpasswordalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [wrongpasswordalert addAction:OKAction];
            [self presentViewController:wrongpasswordalert animated:YES completion:nil];
        }else{

            UIAlertController *changepasswordalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Change Password"] message:[MyClass returntitlewithtitle:@"Are you sure to change password?"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                //update to mysql
//                NSString *strURL=[NSString stringWithFormat:@"%@?action=updatepassword&username=%@&newpassword=%@",globalvariables.generalphpfullpath,globalvariables.username,newpasswordtext.text];
//                
//                __block BOOL result=FALSE;
//                
//                [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
//                    if (succeeded) {
//                        result=TRUE;
//                    }
//                }];
                
                NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
                [dictionary setValue:@"updatepassword" forKey:@"postaction"];
//                [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
                [dictionary setValue:globalvariables.username forKey:@"username"];
                [dictionary setValue:newpasswordtext.text forKey:@"newpassword"];
                
                __block BOOL result=FALSE;
                [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
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
                    [MyClass updatelocaldbwithparameter:@"password" value:newpasswordtext.text];
                    globalvariables.password=newpasswordtext.text;
                    
                    
                    //clear input
                    oldpasswordtext.text=@"";
                    newpasswordtext.text=@"";
                    confirmpasswordtext.text=@"";

                    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Change Password"] message:[MyClass returntitlewithtitle:@"Password has been changed successfully"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [erroralert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [erroralert addAction:OKAction];
                    [self presentViewController:erroralert animated:YES completion:nil];
                    
                }else{
                    [MyClass showconnectionlostdialogbox];
                }
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [changepasswordalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [changepasswordalert addAction:OKAction];
            [changepasswordalert addAction:CancelAction];
            
            [self presentViewController:changepasswordalert animated:YES completion:nil];
            
        }
    }
}

- (void)logoutbuttonpressed:(id)sender {
    
    //close menu bar
    [self.mainSlideMenu closeLeftMenu];

    [self.view endEditing:YES];
    
    UIAlertController *logoutalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Logout"] message:[NSString stringWithFormat:[MyClass returntitlewithtitle:@"%@ %@?"],[MyClass returntitlewithtitle:@"Are you sure to logout"],[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"]] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        //remove token and device from user_token and user_device
        if ([MyClass removeUserTokenDeviceWithUserDeviceKey:globalvariables.userdevicekey]) {
            [MyClass logoutUser];
        }
            
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [logoutalert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [logoutalert addAction:OKAction];
    [logoutalert addAction:CancelAction];
    
    [self presentViewController:logoutalert animated:YES completion:nil];
    
}



-(void) enablenotification:(UISwitch *)sender
{
    if (sender.tag<10) {
        //[MyClass updatelocaldbwithparameter:[notification_class_parameters objectAtIndex:sender.tag] value:sender.on?@"Yes":@"No"];
        [MyClass updateUserAccountSettingsWithField:[notification_class_parameters objectAtIndex:sender.tag] Value:sender.on?@"Yes":@"No"];
        [((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]) setValue:[NSNumber numberWithBool:sender.on] forKey:[notification_class_parameters objectAtIndex:sender.tag]];
    }
}

-(void) enableclasstimetabledaystodisplay:(UISwitch *)sender
{
    NSString *dayselected;
    NSMutableArray *dayselectedarray=[[NSMutableArray alloc]initWithArray:[((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).classtimetabledaystodisplay componentsSeparatedByString:@","]];
    if (sender.tag==0) {
        dayselected=@"Sun";
    }else if (sender.tag==1) {
        dayselected=@"Mon";
    }else if (sender.tag==2) {
        dayselected=@"Tue";
    }else if (sender.tag==3) {
        dayselected=@"Wed";
    }else if (sender.tag==4) {
        dayselected=@"Thu";
    }else if (sender.tag==5) {
        dayselected=@"Fri";
    }else if (sender.tag==6) {
        dayselected=@"Sat";
    }
    
    if (sender.on) {
        [dayselectedarray addObject:dayselected];
        //sort
        NSArray * daysOfTheWeek = [NSArray arrayWithObjects:@"Sun", @"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", nil];
        dayselectedarray = [[NSMutableArray alloc]initWithArray:[daysOfTheWeek filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF in (%@)", dayselectedarray]]];
    }else{
        [dayselectedarray removeObject:dayselected];
    }
    [MyClass updateUserAccountSettingsWithField:@"classtimetabledaystodisplay" Value:[dayselectedarray componentsJoinedByString:@","]];
    
    ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).classtimetabledaystodisplay=[dayselectedarray componentsJoinedByString:@","];
    globalvariables.centerdayofweekarray=dayselectedarray;
}



- (IBAction)selectAutoNotificationType:(UISegmentedControl *)sender {
    selectedantype=sender.selectedSegmentIndex;
    [self updatesettingsRowDataArray];
    [settingstable reloadData];
}

- (IBAction)menubutton:(id)sender {
    [self.mainSlideMenu openLeftMenu];
}

- (void)selectshowcontactindailyscheduleprintout:(UISwitch *)sender {
    [self.view endEditing:YES];
    //[MyClass updatelocaldbwithparameter:@"showcontactindailyscheduleprintout" value:sender.on?@"Yes":@"No"];
    [MyClass updateCenterInformationWithField:@"showcontactindailyscheduleprintout" Value:sender.on?@"Yes":@"No"];
    globalvariables.centerrecord.showcontactindailyscheduleprintout=sender.on;
}

-(void) showlevelinreceipt:(UISwitch *)sender
{
    [MyClass updateCenterInformationWithField:@"showlevelinreceipt" Value:sender.on?@"Yes":@"No"];
    globalvariables.centerrecord.showlevelinreceipt=sender.on;
}

-(void) enableddaenabled:(UISwitch *)sender
{
    [MyClass updateCenterInformationWithField:@"ddaenabled" Value:sender.on?@"Yes":@"No"];
    globalvariables.centerrecord.ddaenabled=sender.on;
}

-(void) showlevelininvoice:(UISwitch *)sender
{
    [MyClass updateCenterInformationWithField:@"showlevelininvoice" Value:sender.on?@"Yes":@"No"];
    globalvariables.centerrecord.showlevelininvoice=sender.on;
    //[MyClass updatelocaldbwithparameter:@"showlevelininvoice" value:sender.on?@"Yes":@"No"];
}

-(void) showstaffnameinreceipt:(UISwitch *)sender
{
    [MyClass updateCenterInformationWithField:@"showstaffnameinreceipt" Value:sender.on?@"Yes":@"No"];
    globalvariables.centerrecord.showstaffnameinreceipt=sender.on;
    //[MyClass updatelocaldbwithparameter:@"showstaffnameinreceipt" value:sender.on?@"Yes":@"No"];
}

-(void) showlastpaymentonlyinreceipt:(UISwitch *)sender
{
    [MyClass updateCenterInformationWithField:@"showlastpaymentonlyinreceipt" Value:sender.on?@"Yes":@"No"];
    globalvariables.centerrecord.showlastpaymentonlyinreceipt=sender.on;
}

- (void)selectsound:(UISwitch *)sender {
    [self.view endEditing:YES];
    [MyClass updatelocaldbwithparameter:@"sound" value:sender.on?@"Yes":@"No"];
}

- (void)updatedefaultreceiptremarksasinvoiceremarksforcourseenrollment:(UISwitch *)sender {
    //[MyClass updatelocaldbwithparameter:@"defaultreceiptremarksasinvoiceremarksforcourseenrollment" value:sender.on?@"Yes":@"No"];
    [MyClass updateCenterInformationWithField:@"defaultreceiptremarksasinvoiceremarksforcourseenrollment" Value:sender.on?@"Yes":@"No"];
    globalvariables.centerrecord.defaultreceiptremarksasinvoiceremarksforcourseenrollment=sender.on;

}

- (void)updatedefaultreceiptremarksasinvoiceremarksforproductsales:(UISwitch *)sender {
    //[MyClass updatelocaldbwithparameter:@"defaultreceiptremarksasinvoiceremarksforproductsales" value:sender.on?@"Yes":@"No"];
    [MyClass updateCenterInformationWithField:@"defaultreceiptremarksasinvoiceremarksforproductsales" Value:sender.on?@"Yes":@"No"];
    globalvariables.centerrecord.defaultreceiptremarksasinvoiceremarksforproductsales=sender.on;
}

- (void)showduepaymentindailyscheduleprintout:(UISwitch *)sender {
    [self.view endEditing:YES];
    //[MyClass updatelocaldbwithparameter:@"showduepaymentindailyscheduleprintout" value:sender.on?@"Yes":@"No"];
    [MyClass updateCenterInformationWithField:@"showduepaymentindailyscheduleprintout" Value:sender.on?@"Yes":@"No"];
    globalvariables.centerrecord.showduepaymentindailyscheduleprintout=sender.on;
}

- (void)selectdailyscheduleshowsubjectcolor:(UISwitch *)sender {
    [self.view endEditing:YES];
    [MyClass updatelocaldbwithparameter:@"dailyscheduleshowsubjectcolor" value:sender.on?@"Yes":@"No"];
}

- (void)selectdailyscheduleshowinstructorcolor:(UISwitch *)sender {
    [self.view endEditing:YES];
    [MyClass updatelocaldbwithparameter:@"dailyscheduleshowinstructorcolor" value:sender.on?@"Yes":@"No"];
}

//- (void)selectdailyscheduleshowclassroomcolor:(UISwitch *)sender {
//    [self.view endEditing:YES];
//    [MyClass updatelocaldbwithparameter:@"dailyscheduleshowclassroomcolor" value:sender.on?@"Yes":@"No"];
//}

- (void) updateshowvalidityininvoicereceipt:(UISwitch *)sender {
    [self.view endEditing:YES];
    //[MyClass updatelocaldbwithparameter:@"showvalidityininvoicereceipt" value:sender.on?@"Yes":@"No"];
    [MyClass updateCenterInformationWithField:@"showvalidityininvoicereceipt" Value:sender.on?@"Yes":@"No"];
    globalvariables.centerrecord.showvalidityininvoicereceipt=sender.on;
    
}

//-(void) updateclasstimetableshowlevel:(UISwitch *)sender
//{
//    //[MyClass updatelocaldbwithparameter:@"classtimetableshowlevel" value:sender.on?@"Yes":@"No"];
//    [MyClass updateUserAccountSettingsWithField:@"showtimetablelevel" Value:sender.on?@"Yes":@"No"];
//    ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showtimetablelevel=sender.on;
//}
//
//-(void) updateclasstimetableshowinstructor:(UISwitch *)sender
//{
//    [MyClass updateUserAccountSettingsWithField:@"showtimetableinstructor" Value:sender.on?@"Yes":@"No"];
//    ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showtimetableinstructor=sender.on;
//}
//
//-(void) updateclasstimetableshowclassroom:(UISwitch *)sender
//{
//    [MyClass updateUserAccountSettingsWithField:@"showtimetableclassroom" Value:sender.on?@"Yes":@"No"];
//    ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showtimetableclassroom=sender.on;
//}

-(void) updaterecalculatetuitionfeeupongradepromotion:(UISwitch *)sender
{
    [MyClass updatelocaldbwithparameter:@"recalculatetuitionfeeupongradepromotion" value:sender.on?@"Yes":@"No"];
}

- (void)selectenableautobatchrenew:(UISwitch *)sender {
    [self.view endEditing:YES];

    [self updateCenterInformationWithField:@"enableautobatchrenew" Value:sender.on?@"Yes":@"No"];
    //[MyClass updatecenterinformationwithparameter:@"enableautobatchrenew" value:sender.on?@"Yes":@"No"];
    globalvariables.centerrecord.enableautobatchrenew=sender.on;
    
    /*if (!sender.on) {
        [self updateCenterInformationWithField:@"autobatchrenewdaystoinclude" Value:@"0"];
        //[MyClass updatecenterinformationwithparameter:@"autobatchrenewdaystoinclude" value:@"0"];
        globalvariables.centerrecord.autobatchrenewdaystoinclude=@"0";
    }*/
    [courserenewaltable reloadData];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)editmaxdayformakeup:(UITextField *)sender
{
    if ([MyClass isIntegerNumber:sender.text]) {
        if([sender.text integerValue]>365){
            UIAlertController *warningalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Maximum Day Range for Makeup Class"] message:[MyClass returntitlewithtitle:@"Input value cannot exceed 365"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [warningalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [warningalert addAction:OKAction];
            [self presentViewController:warningalert animated:YES completion:nil];
            
            sender.text=[@(globalvariables.centerrecord.maxdayformakeup) stringValue];
        }else{
            [self updateCenterInformationWithField:@"maxdayformakeup" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
            globalvariables.centerrecord.maxdayformakeup=[sender.text integerValue];
        }
    }else{
        sender.text=[@(globalvariables.centerrecord.maxdayformakeup) stringValue];
    }
}

- (void)editmaxdayformakeup_editingend:(UITextField *)sender
{
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"0";
    }
}

- (void)editmaxdayrangefortrialclass:(UITextField *)sender
{
    if ([MyClass isIntegerNumber:sender.text]) {
        if([sender.text integerValue]>365){
            UIAlertController *warningalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Maximum Day Range for Trial Class"] message:[MyClass returntitlewithtitle:@"Input value cannot exceed 365"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [warningalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [warningalert addAction:OKAction];
            [self presentViewController:warningalert animated:YES completion:nil];
            
            sender.text=[@(globalvariables.centerrecord.maxdayrangefortrialclass) stringValue];
        }else{
            [self updateCenterInformationWithField:@"maxdayrangefortrialclass" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
            globalvariables.centerrecord.maxdayrangefortrialclass=[sender.text integerValue];
        }
    }else{
        sender.text=[@(globalvariables.centerrecord.maxdayrangefortrialclass) stringValue];
    }
}

- (void)editmaxdayrangefortrialclass_editingend:(UITextField *)sender
{
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"0";
    }
}

- (void)editnoofdayafteroriginalclassformakeup:(UITextField *)sender
{
    if ([MyClass checkValidInput:sender.text Type:@"Integers"]) {
        [self updateCenterInformationWithField:@"noofdayafteroriginalclassformakeup" Value:sender.text];
        globalvariables.centerrecord.noofdayafteroriginalclassformakeup=sender.text;
    }else{
        sender.text=globalvariables.centerrecord.noofdayafteroriginalclassformakeup;
    }
}

- (void)editnoofdayafteroriginalclassformakeupdidend:(UITextField *)sender
{
    if ([sender.text isEqualToString:@"-"]) {
        sender.text=@"";
        [self updateCenterInformationWithField:@"noofdayafteroriginalclassformakeup" Value:sender.text];
        globalvariables.centerrecord.noofdayafteroriginalclassformakeup=sender.text;
    }
}

- (void)editstaffpasswordexpirationday:(UITextField *)sender
{
    if ([MyClass checkValidInput:sender.text Type:@"Integers"]) {
        [self updateCenterInformationWithField:@"staffpasswordexpirationday" Value:sender.text];
        globalvariables.centerrecord.staffpasswordexpirationday=sender.text;
    }else{
        sender.text=globalvariables.centerrecord.staffpasswordexpirationday;
    }
}

- (void)editstaffpasswordexpirationdaydidend:(UITextField *)sender
{
    if ([sender.text isEqualToString:@"-"]) {
        sender.text=@"";
        [self updateCenterInformationWithField:@"staffpasswordexpirationday" Value:sender.text];
        globalvariables.centerrecord.staffpasswordexpirationday=sender.text;
    }
}

- (void)editlockclassperiod:(UITextField *)sender
{
    if ([MyClass checkValidInput:sender.text Type:@"Integers"]) {
        [self updateCenterInformationWithField:@"lockclassperiod" Value:sender.text];
        globalvariables.centerrecord.lockclassperiod=sender.text;
    }else{
        sender.text=globalvariables.centerrecord.lockclassperiod;
    }
}

- (void)editlockclassperioddidend:(UITextField *)sender
{
    if ([sender.text isEqualToString:@"-"]) {
        sender.text=@"";
        [self updateCenterInformationWithField:@"lockclassperiod" Value:sender.text];
        globalvariables.centerrecord.lockclassperiod=sender.text;
    }
}

- (void)editautodropenrollmentday:(UITextField *)sender
{
    if ([MyClass checkValidInput:sender.text Type:@"Integers"]) {
        [self updateCenterInformationWithField:@"autodropenrollmentday" Value:sender.text];
        globalvariables.centerrecord.autodropenrollmentday=sender.text;
    }else{
        sender.text=globalvariables.centerrecord.autodropenrollmentday;
    }
}

- (void)editautodropenrollmentdaydidend:(UITextField *)sender
{
    if ([sender.text isEqualToString:@"-"]) {
        sender.text=@"";
        [self updateCenterInformationWithField:@"autodropenrollmentday" Value:sender.text];
        globalvariables.centerrecord.autodropenrollmentday=sender.text;
    }
}

- (void)editdefaultpointexpirydays:(UITextField *)sender
{
    if ([MyClass checkValidInput:sender.text Type:@"Integers"]) {
        [self updateCenterInformationWithField:@"defaultpointexpirydays" Value:sender.text];
        globalvariables.centerrecord.defaultpointexpirydays=sender.text;
    }else{
        sender.text=globalvariables.centerrecord.defaultpointexpirydays;
    }
}

- (void)editdefaultpointexpirydaysdidend:(UITextField *)sender
{
    if ([sender.text isEqualToString:@"-"]) {
        sender.text=@"";
        [self updateCenterInformationWithField:@"defaultpointexpirydays" Value:sender.text];
        globalvariables.centerrecord.defaultpointexpirydays=sender.text;
    }
}

- (void)editmindaytoapplyleave:(UITextField *)sender
{
    if ([MyClass isIntegerNumber:sender.text]) {
        [self updateCenterInformationWithField:@"mindaytoapplyleave" Value:[sender.text isEqualToString:@""]?@"-1":sender.text];
        globalvariables.centerrecord.mindaytoapplyleave=[sender.text isEqualToString:@""]?-1:[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)editmakeupdelayhour:(UITextField *)sender
{
    if ([MyClass isIntegerNumber:sender.text]) {
        [self updateCenterInformationWithField:@"makeupdelayhour" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
        globalvariables.centerrecord.makeupdelayhour=[sender.text isEqualToString:@""]?0:[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)edittrialdelayhour:(UITextField *)sender
{
    if ([MyClass isIntegerNumber:sender.text]) {
        [self updateCenterInformationWithField:@"trialdelayhour" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
        globalvariables.centerrecord.trialdelayhour=[sender.text isEqualToString:@""]?0:[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)editminstudentcontact:(UITextField *)sender
{
    if ([MyClass isIntegerNumber:sender.text]) {
        [self updateCenterInformationWithField:@"minstudentcontact" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
        globalvariables.centerrecord.minstudentcontact=[sender.text isEqualToString:@""]?0:[sender.text integerValue];
    }else{
        [studentprofiletable reloadData];
    }
}

- (void)editwaiveenrollmentfeeminmonth:(UITextField *)sender
{
    if ([MyClass isIntegerNumber:sender.text]) {
        [self updateCenterInformationWithField:@"waiveenrollmentfeeminmonth" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
        globalvariables.centerrecord.waiveenrollmentfeeminmonth=[sender.text isEqualToString:@""]?0:[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}


- (void)editautobatchrenewdaystoinclude:(UITextField *)sender
{
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        if([sender.text isEqualToString:@""]){
            sender.text=@"";
        }else{
            sender.text=[NSString stringWithFormat:@"%i",[sender.text intValue]];
        }

        [self updateCenterInformationWithField:@"autobatchrenewdaystoinclude" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
        globalvariables.centerrecord.autobatchrenewdaystoinclude=sender.text;
    }else{
        [courserenewaltable reloadData];
    }
}

- (void)editautobatchrenewdaystoinclude_editingend:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"0";
    }
    
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        [self updateCenterInformationWithField:@"autobatchrenewdaystoinclude" Value:sender.text];
        globalvariables.centerrecord.autobatchrenewdaystoinclude=sender.text;
    }else{
        [courserenewaltable reloadData];
    }
}



- (void)editnoofpastdayincludediniparentclassschedule:(UITextField *)sender
{
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        if([sender.text isEqualToString:@""]){
            sender.text=@"";
        }else{
            sender.text=[NSString stringWithFormat:@"%i",[sender.text intValue]];
        }
        
        [self updateCenterInformationWithField:@"noofpastdayincludediniparentclassschedule" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
        globalvariables.centerrecord.noofpastdayincludediniparentclassschedule=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)editnoofpastdayincludediniparentclassschedule_editingend:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"0";
    }
    
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        [self updateCenterInformationWithField:@"noofpastdayincludediniparentclassschedule" Value:sender.text];
        globalvariables.centerrecord.noofpastdayincludediniparentclassschedule=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)editnoofpastdayincludedinistaffmystudentclass:(UITextField *)sender
{
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        if([sender.text isEqualToString:@""]){
            sender.text=@"";
        }else{
            sender.text=[NSString stringWithFormat:@"%i",[sender.text intValue]];
        }
        
        [self updateCenterInformationWithField:@"noofpastdayincludedinistaffmystudentclass" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
        globalvariables.centerrecord.noofpastdayincludedinistaffmystudentclass=[sender.text integerValue];
    }else{
        [istafftable reloadData];
    }
}

- (void)editnoofpastdayincludedinistaffmystudentclass_editingend:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"0";
    }
    
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        [self updateCenterInformationWithField:@"noofpastdayincludedinistaffmystudentclass" Value:sender.text];
        globalvariables.centerrecord.noofpastdayincludedinistaffmystudentclass=[sender.text integerValue];
    }else{
        [istafftable reloadData];
    }
}

- (void)editfirstreminderbeforeexpiry:(UITextField *)sender
{
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        if([sender.text isEqualToString:@""]){
            sender.text=@"";
        }else{
            sender.text=[NSString stringWithFormat:@"%i",[sender.text intValue]];
        }
        
        [self updateCenterInformationWithField:@"firstreminderbeforeexpiry" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
        globalvariables.centerrecord.firstreminderbeforeexpiry=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)editfirstreminderbeforeexpiry_editingend:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"0";
    }
    
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        [self updateCenterInformationWithField:@"firstreminderbeforeexpiry" Value:sender.text];
        globalvariables.centerrecord.firstreminderbeforeexpiry=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)editexpiringclassreminderrecursiveday:(UITextField *)sender
{
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        if([sender.text isEqualToString:@""]){
            sender.text=@"";
        }else{
            sender.text=[NSString stringWithFormat:@"%i",[sender.text intValue]];
        }
        
        [self updateCenterInformationWithField:@"expiringclassreminderrecursiveday" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
        globalvariables.centerrecord.expiringclassreminderrecursiveday=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)editexpiringclassreminderrecursiveday_editingend:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"0";
    }
    
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        [self updateCenterInformationWithField:@"expiringclassreminderrecursiveday" Value:sender.text];
        globalvariables.centerrecord.expiringclassreminderrecursiveday=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)editcouponexpiryfirstreminder:(UITextField *)sender
{
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        if([sender.text isEqualToString:@""]){
            sender.text=@"";
        }else{
            sender.text=[NSString stringWithFormat:@"%i",[sender.text intValue]];
        }
        
        [self updateCenterInformationWithField:@"couponexpiryfirstreminder" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
        globalvariables.centerrecord.couponexpiryfirstreminder=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)editcouponexpiryfirstreminder_editingend:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"0";
    }
    
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        [self updateCenterInformationWithField:@"couponexpiryfirstreminder" Value:sender.text];
        globalvariables.centerrecord.couponexpiryfirstreminder=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)editcouponexpiryrecursivereminder:(UITextField *)sender
{
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        if([sender.text isEqualToString:@""]){
            sender.text=@"";
        }else{
            sender.text=[NSString stringWithFormat:@"%i",[sender.text intValue]];
        }
        
        [self updateCenterInformationWithField:@"couponexpiryrecursivereminder" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
        globalvariables.centerrecord.couponexpiryrecursivereminder=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)editcouponexpiryrecursivereminder_editingend:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"0";
    }
    
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        [self updateCenterInformationWithField:@"couponexpiryrecursivereminder" Value:sender.text];
        globalvariables.centerrecord.couponexpiryrecursivereminder=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}





- (void)editpointexpiryfirstreminder:(UITextField *)sender
{
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        if([sender.text isEqualToString:@""]){
            sender.text=@"";
        }else{
            sender.text=[NSString stringWithFormat:@"%i",[sender.text intValue]];
        }
        
        [self updateCenterInformationWithField:@"pointexpiryfirstreminder" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
        globalvariables.centerrecord.pointexpiryfirstreminder=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)editpointexpiryfirstreminder_editingend:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"0";
    }
    
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        [self updateCenterInformationWithField:@"pointexpiryfirstreminder" Value:sender.text];
        globalvariables.centerrecord.pointexpiryfirstreminder=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}

- (void)editpointexpiryrecursivereminder_editingend:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"0";
    }
    
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        [self updateCenterInformationWithField:@"pointexpiryrecursivereminder" Value:sender.text];
        globalvariables.centerrecord.pointexpiryrecursivereminder=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}





- (void)editpointexpiryrecursivereminder:(UITextField *)sender
{
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        if([sender.text isEqualToString:@""]){
            sender.text=@"";
        }else{
            sender.text=[NSString stringWithFormat:@"%i",[sender.text intValue]];
        }
        
        [self updateCenterInformationWithField:@"pointexpiryrecursivereminder" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
        globalvariables.centerrecord.pointexpiryrecursivereminder=[sender.text integerValue];
    }else{
        [iparenttable reloadData];
    }
}




- (void)editautorenewal_date_for_monthlycourse:(UITextField *)sender
{
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        //[MyClass updatecenterinformationwithparameter:@"autorenewal_date_for_monthlycourse" value:[sender.text isEqualToString:@""]?@"31":sender.text];
        if ([sender.text intValue]>31) {
            sender.text=@"31";
        }else if([sender.text intValue]<0){
            sender.text=@"1";
        }else if([sender.text isEqualToString:@""]){
            sender.text=@"";
        }else{
            sender.text=[NSString stringWithFormat:@"%i",[sender.text intValue]];
        }
        
        [self updateCenterInformationWithField:@"autorenewal_date_for_monthlycourse" Value:sender.text];
        globalvariables.centerrecord.autorenewal_date_for_monthlycourse=sender.text;
    }else{
        [courserenewaltable reloadData];
    }
}

- (void)editautorenewal_date_for_monthlycourse_editingend:(UITextField *)sender {
    
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"31";
    }
    
    NSCharacterSet *_NumericOnly = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *myStringSet = [NSCharacterSet characterSetWithCharactersInString:sender.text];
    if ([_NumericOnly isSupersetOfSet: myStringSet]) {
        [self updateCenterInformationWithField:@"autorenewal_date_for_monthlycourse" Value:sender.text];
        globalvariables.centerrecord.autorenewal_date_for_monthlycourse=sender.text;
    }else{
        [courserenewaltable reloadData];
    }
}


- (void)switcha4trayfora5printing:(UISegmentedControl *)sender {
    
    //[MyClass updatelocaldbwithparameter:@"a4trayfora5printing" value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    [MyClass updateUserAccountSettingsWithField:@"a4trayfora5printing_receipt" Value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).a4trayfora5printing_receipt=sender.selectedSegmentIndex;
}

- (void)switchprintclassdatemode:(UISegmentedControl *)sender {
    
    NSString *value;
    if(sender.selectedSegmentIndex==0){
        value = @"Original";
    }else if (sender.selectedSegmentIndex==1){
        value=@"Actual";
    }else{
        value=@"Both";
    }
    
    [MyClass updateCenterInformationWithField:@"printclassdatemode" Value:value];
    globalvariables.centerrecord.printclassdatemode=value;
}

- (void)switcha4trayfora5printing_invoice:(UISegmentedControl *)sender {
    
    //[MyClass updatelocaldbwithparameter:@"a4trayfora5printing_invoice" value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    [MyClass updateUserAccountSettingsWithField:@"a4trayfora5printing_invoice" Value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).a4trayfora5printing_invoice=sender.selectedSegmentIndex;
}

- (void)switchiparentleavemode:(UISegmentedControl *)sender {
    
    if(sender.selectedSegmentIndex==0){
        [self updateCenterInformationWithField:@"iparentleavemode" Value:@"Disable"];
        globalvariables.centerrecord.iparentleavemode=@"Disable";
    }else if(sender.selectedSegmentIndex==1){
        [self updateCenterInformationWithField:@"iparentleavemode" Value:@"Request"];
        globalvariables.centerrecord.iparentleavemode=@"Request";
    }else if(sender.selectedSegmentIndex==2){
        [self updateCenterInformationWithField:@"iparentleavemode" Value:@"Auto approve"];
        globalvariables.centerrecord.iparentleavemode=@"Auto approve";
    }
    [iparenttable reloadData];
}

- (void)switchleaveapprovalmode:(UISegmentedControl *)sender {
    
    if(sender.selectedSegmentIndex==0){
        [self updateCenterInformationWithField:@"leaveapprovalmode" Value:@"All"];
        globalvariables.centerrecord.leaveapprovalmode=@"All";
    }else if(sender.selectedSegmentIndex==1){
        [self updateCenterInformationWithField:@"leaveapprovalmode" Value:@"Center"];
        globalvariables.centerrecord.leaveapprovalmode=@"Center";
    }else if(sender.selectedSegmentIndex==2){
        [self updateCenterInformationWithField:@"leaveapprovalmode" Value:@"Instructor"];
        globalvariables.centerrecord.leaveapprovalmode=@"Instructor";
    }
    [iparenttable reloadData];
}


-(void) switchcenterbuttonpressed
{
    [MyClass loadingindicatorwithoption:@"start" color:@"gray"];
    
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


-(void) reloadPageWithFirstLoad:(BOOL)firstload
{
    [MyClass loadingindicatorwithoption:@"start" color:@"gray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [MyClass getLatestDataSetv2withParameters:@"languagetitle,centersettings,userroleandprivilege,staff,arcode,subject" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
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
                        
                        //[MyClass LoadSchoolCalendarArray];
                        [self refreshlanguage];
                        arcodearray=[MyClass retrieveArcodeListwithflushcachedata:YES];
                        
                        [self showmenuviewwithindexpath:[NSIndexPath indexPathForRow:0 inSection:0]];
                        [menutable reloadData];
                        [generaltable reloadData];
                        [menutable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
                        selectedantype=0;
                        scAutoNotificationType.selectedSegmentIndex=selectedantype;
                        
                        [MyClass loadingindicatorwithoption:@"stop" color:nil];
                    }
                });
                
            }];
    });
}


- (void)selecttncfontsize:(UISegmentedControl *)sender {
    
    //[MyClass updatelocaldbwithparameter:@"tncfontsize" value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    [MyClass updateCenterInformationWithField:@"tncfontsize_receipt" Value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    globalvariables.centerrecord.tncfontsize_receipt=sender.selectedSegmentIndex;
}

- (void)selectshowclassdatesinreceipt:(UISegmentedControl *)sender {
    
    [MyClass updateCenterInformationWithField:@"showclassdatesinreceipt" Value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    globalvariables.centerrecord.showclassdatesinreceipt=sender.selectedSegmentIndex;
}

- (void)selectshowclassdatesininvoice:(UISegmentedControl *)sender {
    
    [MyClass updateCenterInformationWithField:@"showclassdatesininvoice" Value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    globalvariables.centerrecord.showclassdatesininvoice=sender.selectedSegmentIndex;
}

- (void)selecttncfontsize_invoice:(UISegmentedControl *)sender {
    
    //[MyClass updatelocaldbwithparameter:@"tncfontsize_invoice" value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    [MyClass updateCenterInformationWithField:@"tncfontsize_invoice" Value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    globalvariables.centerrecord.tncfontsize_invoice=sender.selectedSegmentIndex;
}

- (void)selectdefaultstudentmessagechannel:(UISegmentedControl *)sender {
    
    //[MyClass updatelocaldbwithparameter:@"defaultstudentmessagechannel" value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    NSString *channelcode=[MyClass returnChannelCodeWithRecipientType:@"Student" Index:[@(sender.selectedSegmentIndex) stringValue]];
    [MyClass updateCenterInformationWithField:@"defaultstudentmessagechannel" Value:channelcode];
    globalvariables.centerrecord.defaultstudentmessagechannel=channelcode;
}

- (void)selectdefaultleadmessagechannel:(UISegmentedControl *)sender {
    
    //[MyClass updatelocaldbwithparameter:@"defaultleadmessagechannel" value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    NSString *channelcode=[MyClass returnChannelCodeWithRecipientType:@"Lead" Index:[@(sender.selectedSegmentIndex) stringValue]];
    [MyClass updateCenterInformationWithField:@"defaultleadmessagechannel" Value:channelcode];
    globalvariables.centerrecord.defaultleadmessagechannel=channelcode;
}

- (void)selectreceiptfontsize:(UISegmentedControl *)sender {
    
    //[MyClass updatelocaldbwithparameter:@"receiptfontsize" value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    [MyClass updateCenterInformationWithField:@"receiptfontsize" Value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    globalvariables.centerrecord.receiptfontsize=sender.selectedSegmentIndex;
}

- (void)selectinvoicefontsize:(UISegmentedControl *)sender {
    
    //[MyClass updatelocaldbwithparameter:@"invoicefontsize" value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    [MyClass updateCenterInformationWithField:@"invoicefontsize" Value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
    globalvariables.centerrecord.invoicefontsize=sender.selectedSegmentIndex;
}

- (void)selectdefaultprintcolor:(UISegmentedControl *)sender {
    
    [MyClass updatelocaldbwithparameter:@"defaultprintcolor" value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
}

- (void)selectdefaultprintcolor_invoice:(UISegmentedControl *)sender {
    
    [MyClass updatelocaldbwithparameter:@"defaultprintcolor_invoice" value:[NSString stringWithFormat:@"%ld",(long)sender.selectedSegmentIndex]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    UserPrivilege *userprivilegeobject=[MyClass returnuserprivilegewithcenterkey:globalvariables.centerrecord.centerkey];
    if (tableView==menutable) {
        return ((PrivilegeRecord *)[MyClass returnprivilegerecordwithprivilegekey:userprivilegeobject.privilegekey]).viewsettings?7:3;
    }if (tableView==studentprofiletable){
        return 6;
    }else if (tableView==notificationtable){
        return 1;
    }else if (tableView==generaltable){
        return 2;
    }else if (tableView==dailyscheduletable){
        return 2/*+(globalvariables.centerrecord.enablescantotakeattendance?1:0)*/;
    }else if (tableView==classtimetable){
        return 5;
    }else if (tableView==courserenewaltable){
        return 3;
    }else if (tableView==printingtable){
        return 4;
    }else if (tableView==accounttable){
        return 2;
    }else if (tableView==attendancetable){
        if ([globalvariables.centerrecord.defaultattendancestatus isEqualToString:@"Present"]) {
            return 3;
        }
        return 4;
    }else if (tableView==calendartable){
        return 1;
    }else if (tableView==enrollmenttable){
        return 6;
    }else if (tableView==istafftable){
        return 2;
    }else if (tableView==iparenttable){
        return 11;
    }else if (tableView==messagecentertable){
        return 2;
    }else if (tableView==photocornertable){
        return 1;
    }else if (tableView==financialtable){
        return arcodearray.count>0?9:8;
    }else if (tableView==leadprofiletable){
        return 3;
    }else if (tableView==settingstable){
        return 1;
    }else if (tableView==membershiptable){
        return 3;
    }else if (tableView==coursetable){
        return 1;
    }else if (tableView==chatbottable){
        return 1;
    }else if(tableView==evaluationformtable){
        return 3;
    }else if(tableView==useraccounttable){
        return 1;
    }else if(tableView==centerqrcodetable){
        return 1;
    }
    return 0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==menutable){
        if (section==0) {
            return menuitem_section_0.count;
        }else if (section==1){
            return menuitem_section_1.count;
        }else if (section==2){
            return menuitem_section_2.count;
        }else if (section==3){
            return menuitem_section_3.count;
        }else if (section==4){
            return menuitem_section_4.count;
        }else if (section==5){
            return menuitem_section_5.count;
        }else if (section==6){
            return menuitem_section_6.count;
        }
    }else if (tableView==notificationtable){
        if (section==0) {
            return notification_section_class.count;
        }
    }else if (tableView==generaltable){
        if (section==0) {
            return 2;
        }else{
            return 1;
        }
    }else if (tableView==dailyscheduletable){
        if (section==0) {
            return dailyschedule_parameters_0.count;
        }else if (section==1) {
            return dailyschedule_parameters_1.count;
        }
    }else if (tableView==classtimetable){
        if (section==0) {
            return classtimetable_parameters_0.count;
        }else if (section==1){
            return classtimetable_parameters_1.count;
        }else if (section==2){
            return classtimetable_parameters_2.count;
        }else if (section==3){
            return classtimetable_parameters_3.count;
        }else{
            return classtimetable_parameters_4.count;
        }
    }else if (tableView==courserenewaltable){
        if (section==0) {
            return globalvariables.centerrecord.enableautobatchrenew?courserenewal_parameters_0.count:courserenewal_parameters_0.count-3;
        }else if (section==1){
            return courserenewal_parameters_1.count;
        }else{
            return courserenewal_parameters_2.count;
        }
        
    }else if (tableView==printingtable){
        if (section==0) {
            return 1;
        }else if (section==1) {
            return printing_parameters_1.count;
        }else if (section==2){
            return printing_parameters_2.count;
        }else{
            return printing_parameters_3.count;
        }
    }else if (tableView==accounttable){
        if (section==0) {
            return 4;
        }else{
            return 1;
        }
    }else if (tableView==attendancetable){
        if (section==0) {
            return [globalvariables.centerrecord.defaultattendancestatus isEqualToString:@""]?attendance_parameters_0.count:1;
        }else if (section==2){
            return globalvariables.centerrecord.enablescantotakeattendance?attendance_parameters_1.count:1;
        }else  if (section==1){
            return attendance_parameters_2.count;
        }else if (section==3){
            return attendance_parameters_3.count;
        }
    }else if (tableView==calendartable){
        if (section==0) {
            return calendar_parameters_0.count;
        }
    }else if (tableView==enrollmenttable){
        if (section==0) {
            return globalvariables.centerrecord.enrollmentvalidity?enrollment_parameters_0.count:1;
        }else if (section==1){
            return enrollment_parameters_1.count;
        }else if (section==2){
            return enrollment_parameters_2.count;
        }else if (section==3){
            return enrollment_parameters_3.count;
        }else if (section==4){
            return enrollment_parameters_4.count;
        }else if (section==5){
            return enrollment_parameters_5.count;
        }
    }else if (tableView==coursetable){
        if (section==0) {
            return course_parameters_0.count;
        }
    }else if (tableView==membershiptable){
        if (section==0) {
            return membership_parameters_0.count;
        }else if (section==1){
            return membership_parameters_1.count;
        }else{
            return 2+membershiptierarray.count;
        }
    }else if (tableView==chatbottable){
        if (section==0) {
            return chatbot_parameters_0.count;
        }
    }else if (tableView==istafftable){
        if (section==0) {
            return istaff_parameters_0.count;
        }
    }else if (tableView==useraccounttable){
        if (section==0) {
            return useraccount_parameters_0.count;
        }
    }else if (tableView==iparenttable){
        if (section==0) {
            return iparent_parameters_0.count;
        }else if (section==1){
            return iparent_parameters_1.count;
        }else if (section==2){
            return iparent_parameters_2.count;
        }else if (section==3){
            return iparent_parameters_3.count;
        }else if (section==4){
            return iparent_parameters_4.count;
        }else if (section==5){
            return iparent_parameters_5.count;
        }else if (section==6){
            return iparent_parameters_6.count;
        }else if (section==7){
            return iparent_parameters_7.count;
        }else if (section==8){
            return iparent_parameters_8.count;
        }else if (section==9){
            return globalvariables.centerrecord.enableparentsendmessage?iparent_parameters_9.count:1;
        }else{
            return iparent_parameters_10.count;
        }
    }else if (tableView==financialtable){
        if (section==0) {
            return financial_parameters_0.count;
        }else if (section==1){
            return financial_parameters_1.count;
        }else if (section==2){
            return financial_parameters_2.count;
        }else if (section==3){
            return [globalvariables.centerrecord.latefee_enable isEqualToString:@"Yes"]?financial_parameters_3.count:1;
        }else if (section==4){
            return financial_parameters_4.count;
        }else if (section==5){
            return financial_parameters_5.count;
        }else if (section==6){
            return financial_parameters_6.count;
        }else if (section==7){
            return financial_parameters_7.count;
        }else if (section==8){
            return globalvariables.centerrecord.enableaccountreceivablecodes?financial_parameters_8.count+arcodearray.count:1;
        }
    }else if(tableView==studentprofiletable){
        if (section==0) {
            return studentprofile_section_0.count;
        }else if (section==1){
            return studentprofile_section_1.count;
        }else if (section==2){
            return studentprofile_section_2.count;
        }else if (section==3){
            return studentprofile_section_3.count;
        }else if (section==4){
            return studentprofile_section_4.count;
        }
    }else if(tableView==messagecentertable){
        if (section==0) {
            return messagecenter_parameters_0.count;
        }else{
            return messagecenter_parameters_1.count;
        }
    }else if(tableView==photocornertable){
        return photocorner_parameters_0.count;
    }else if(tableView==leadprofiletable){
        if (section==0) {
            return leadprofile_section_0.count;
        }else if (section==1){
            return leadprofile_section_1.count;
        }else if (section==2){
            return leadprofile_section_2.count;
        }
    }else if (tableView==settingstable){
        return settingsRowDataArray.count;
    }else if (tableView==evaluationformtable){
        if (section==0){
            return evaluationform_parameters_0.count;
        }else if (section==1){
            return evaluationform_parameters_1.count;
        }else{
            return evaluationform_parameters_2.count;
        }
    }else if (tableView==centerqrcodetable){
        if (section==0){
            return centerqrcode_parameters_0.count;
        }
    }
    return 0;
}

-(void) adjusttablesize
{
    float tableheight=self.view.bounds.size.height-keyboardheight;
    
    if (!generaleview.hidden) {
        [generaltable setFrame:CGRectMake(generaltable.frame.origin.x, 0, generaltable.frame.size.width, tableheight-64)];
    }else if (!studentprofileview.hidden) {
        [studentprofiletable setFrame:CGRectMake(studentprofiletable.frame.origin.x, 0, studentprofiletable.frame.size.width, tableheight-64)];
    }else if (!notificationview.hidden) {
        [notificationtable setFrame:CGRectMake(notificationtable.frame.origin.x, 0, notificationtable.frame.size.width, tableheight-64)];
    }else if (!dailyscheduleview.hidden) {
        [dailyscheduletable setFrame:CGRectMake(dailyscheduletable.frame.origin.x, 0, dailyscheduletable.frame.size.width, tableheight-64)];
    }else if (!classtimetableview.hidden) {
        [classtimetableview setFrame:CGRectMake(classtimetable.frame.origin.x, 0, classtimetable.frame.size.width, tableheight-64)];
    }else if (!courserenewalview.hidden) {
        [courserenewaltable setFrame:CGRectMake(courserenewaltable.frame.origin.x, 0, courserenewaltable.frame.size.width, tableheight-64)];
    }else if (!attendanceview.hidden) {
        [attendancetable setFrame:CGRectMake(attendancetable.frame.origin.x, 0, attendancetable.frame.size.width, tableheight-64)];
    }else if (!financialview.hidden) {
        [financialtable setFrame:CGRectMake(financialtable.frame.origin.x, 0, financialtable.frame.size.width, tableheight-64)];
    }else if (!printingview.hidden) {
        [printingtable setFrame:CGRectMake(printingtable.frame.origin.x, 0, printingtable.frame.size.width, tableheight-64)];
    }else if (!istaffview.hidden) {
        [istafftable setFrame:CGRectMake(istafftable.frame.origin.x, 0, istafftable.frame.size.width, tableheight-64)];
    }else if (!accountview.hidden) {
        [accounttable setFrame:CGRectMake(accounttable.frame.origin.x, 0, accounttable.frame.size.width, tableheight-64)];
    }else if (!photocornerview.hidden) {
        [photocornertable setFrame:CGRectMake(photocornertable.frame.origin.x, 0, photocornertable.frame.size.width, tableheight-64)];
    }else if (!messagecenterview.hidden) {
        [messagecentertable setFrame:CGRectMake(messagecentertable.frame.origin.x, 0, messagecentertable.frame.size.width, tableheight-64)];
    }else if (!membershipview.hidden) {
        membershiptablebottomconstraint.constant=keyboardheight;
    }else if (!useraccountview.hidden) {
        [useraccounttable setFrame:CGRectMake(useraccounttable.frame.origin.x, 0, useraccounttable.frame.size.width, tableheight-64)];
    }else{
        settingstablebottomconstraint.constant=keyboardheight;
    }

}

-(void) closewhatsnewwindowwithviewcontroller:(UIViewController *)view
{
    [view dismissViewControllerAnimated:YES completion:^{
        [menutable deselectRowAtIndexPath:[menutable indexPathForSelectedRow] animated:YES];
    }];
    
}

-(void) showmenuviewwithindexpath:(NSIndexPath *)indexpath
{
    [self.view endEditing:YES];
    
    if(indexpath.section==2){
        if (indexpath.row==0) {
            WhatsNewViewController *viewcontroller = (WhatsNewViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"WhatsNewViewController"];
            viewcontroller.delegate=self;
            viewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:viewcontroller animated:YES completion: nil];
        }
        return;
    }
    
    generaleview.hidden=YES;
    studentprofileview.hidden=YES;
    notificationview.hidden=YES;
    dailyscheduleview.hidden=YES;
    classtimetableview.hidden=YES;
    courserenewalview.hidden=YES;
    photocornerview.hidden=YES;
    messagecenterview.hidden=YES;
    leadprofileview.hidden=YES;
    attendanceview.hidden=YES;
    financialview.hidden=YES;
    printingview.hidden=YES;
    calendarview.hidden=YES;
    istaffview.hidden=YES;
    useraccountview.hidden=YES;
    iparentview.hidden=YES;
    accountview.hidden=YES;
    enrollmentview.hidden=YES;
    membershipview.hidden=YES;
    chatbotview.hidden=YES;
    evaluationformview.hidden=YES;
    centerqrcodeview.hidden=YES;
    courseview.hidden=YES;

    if (indexpath.section==0) {
        if (indexpath.row==0) {
            generaleview.hidden=NO;
            [generaltable reloadData];
        }
    }else if (indexpath.section==3){
        if (indexpath.row==0) {
            studentprofileview.hidden=NO;
            [studentprofiletable reloadData];
        }else if (indexpath.row==1){
            notificationview.hidden=NO;
            [notificationtable reloadData];
        }else if (indexpath.row==2){
            dailyscheduleview.hidden=NO;
            [dailyscheduletable reloadData];
        }else if (indexpath.row==3){
            classtimetableview.hidden=NO;
            [classtimetable reloadData];
        }else if (indexpath.row==4){
            courserenewalview.hidden=NO;
            [courserenewaltable reloadData];
        }else if (indexpath.row==5){
            messagecenterview.hidden=NO;
            [messagecentertable reloadData];
        }else if (indexpath.row==6){
            photocornerview.hidden=NO;
            [photocornertable reloadData];
        }else if (indexpath.row==7){
            leadprofileview.hidden=NO;
            [leadprofiletable reloadData];
        }
    }else if (indexpath.section==4){
        if (indexpath.row==0) {
            attendanceview.hidden=NO;
            [attendancetable reloadData];
        }else if (indexpath.row==1){
            financialview.hidden=NO;
            [financialtable reloadData];
        }else if (indexpath.row==2){
            printingview.hidden=NO;
            
            [MyClass downloadImageWithImageview:tmpprintlogoimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.printlogoimage image:@"Yes" async:NO];
            
            tmpprintlogoimagedata=[[NSData alloc]initWithData:UIImagePNGRepresentation(tmpprintlogoimage.image)];
            
            [printingtable reloadData];
        }else if (indexpath.row==3){
            calendarview.hidden=NO;
            [calendartable reloadData];
        }else if (indexpath.row==4){
            enrollmentview.hidden=NO;
            [enrollmenttable reloadData];
        }else if (indexpath.row==5){
            courseview.hidden=NO;
            [coursetable reloadData];
        }else if (indexpath.row==6){
            [self updatesettingsRowDataArray];
            [settingstable reloadData];
        }else if (indexpath.row==7){
            membershipview.hidden=NO;
            [self retrieveMembershipTierSettings];
            [membershiptable reloadData];
        }else if (indexpath.row==8){
            chatbotview.hidden=NO;
            [chatbottable reloadData];
        }else if (indexpath.row==9){
            [self getevaluationformlist];
            evaluationformview.hidden=NO;
            [evaluationformtable reloadData];
        }else if (indexpath.row==10){
            centerqrcodeview.hidden=NO;
            [centerqrcodetable reloadData];
        }else if (indexpath.row==11){
            useraccountview.hidden=NO;
            [useraccounttable reloadData];
        }
    }else if (indexpath.section==5) {
        if (indexpath.row==0) {
            istaffview.hidden=NO;
            [istafftable reloadData];
        }
    }else if (indexpath.section==6) {
        if (indexpath.row==0) {
            iparentview.hidden=NO;
            [iparenttable reloadData];
        }
    }else if (indexpath.section==1) {
        if (indexpath.row==0) {
            accountview.hidden=NO;
            [accounttable reloadData];
        }
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==printingtable) {
        if (indexPath.section==0) {
            return 140;
        }/*else if (indexPath.section==2 || indexPath.section==3) {
            return 500;
        }*/
    }else if (tableView==attendancetable){
        if (indexPath.section==1 && indexPath.row==0) {
            if ([globalvariables.centerrecord.defaultattendancestatus isEqualToString:@"Present"]) {
                return CGFLOAT_MIN;
            }
        }
    }else if (tableView==iparenttable){
        if(indexPath.section==4){
            if (indexPath.row==1) {
                if(!globalvariables.centerrecord.expiringclassreminder){
                    return CGFLOAT_MIN;
                }
            }else if (indexPath.row==2){
                if(!globalvariables.centerrecord.expiringclassreminder){
                    return CGFLOAT_MIN;
                }
            }
        }else if(indexPath.section==7){
            if (indexPath.row==1) {
                if(![globalvariables.centerrecord.iparentleavemode isEqualToString:@"Request"]){
                    return CGFLOAT_MIN;
                }
            }else if (indexPath.row==2){
                if([globalvariables.centerrecord.iparentleavemode isEqualToString:@"Disable"]){
                    return CGFLOAT_MIN;
                }
            }
        }else if(indexPath.section==9){
            if (indexPath.row==1) {
                if (!globalvariables.centerrecord.enablevoicemessage) {
                    return CGFLOAT_MIN;
                }
            }else if (indexPath.row==2) {
                if (!globalvariables.centerrecord.enablevideomessage) {
                    return CGFLOAT_MIN;
                }
            }
        }
    }else if (tableView==settingstable){
        return UITableViewAutomaticDimension;
    }else if (tableView==iparenttable){
        if (indexPath.row==1) {
            if (!globalvariables.centerrecord.enablevoicemessage) {
                return CGFLOAT_MIN;
            }
        }else if (indexPath.row==2) {
            if (!globalvariables.centerrecord.enablevideomessage) {
                return CGFLOAT_MIN;
            }
        }
    }else if (tableView==evaluationformtable){
        return UITableViewAutomaticDimension;
    }else if (tableView==menutable){
        if (indexPath.section==4){
            if (indexPath.row==5) {
                if(!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showautonotificationsettings){
                    return CGFLOAT_MIN;
                }
            }
        }
    }else if (tableView==membershiptable){
        return UITableViewAutomaticDimension;
    }else if (tableView==centerqrcodetable){
        return UITableViewAutomaticDimension;
    }else if (tableView==courserenewaltable){
        if(indexPath.section==1 && indexPath.row==3){
            return CGFLOAT_MIN;
        }
    }
    return 40;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView==menutable) {
        //if (section>0) {
            return 36;
        //}
    }else if (tableView==settingstable){
        return CGFLOAT_MIN;
    }
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView==menutable){
        if ([tableView numberOfSections]-1==section) {
            return 30;
        }
        return CGFLOAT_MIN;
    }else if (tableView==courserenewaltable) {
        if (section==0) {
            return [globalvariables.language isEqualToString:@"English"]?30:30;
        }else if (section==1) {
            return 30;
        }else if ([tableView numberOfSections]-1==section) {
            return 30;
        }
    }else if (tableView==financialtable) {
        if (section==1) {
            return 30;
        }else if ([tableView numberOfSections]-1==section) {
            return 30;
        }
    }else if (tableView==attendancetable) {
        if (section==0 || section==1 || section==2) {
            return 30;
        }else if ([tableView numberOfSections]-1==section) {
            return 30;
        }
    }else if (tableView==studentprofiletable) {
        if (section==2) {
            return 10;
        }
        return 30;
    }else if (tableView==leadprofiletable) {
        if (section==0 || section==1) {
            return 30;
        }else if ([tableView numberOfSections]-1==section) {
            return 30;
        }
    }else if (tableView==iparenttable) {
        return 30;
    }else if (tableView==enrollmenttable) {
        return 30;
    }else if (tableView==settingstable) {
        return CGFLOAT_MIN;
    }else if (tableView==evaluationformtable){
        if(section==0){
            return 30;
        }
    }else if (tableView==membershiptable) {
        if ([tableView numberOfSections]-1==section) {
            return 30;
        }else{
            return CGFLOAT_MIN;
        }
    }else if (tableView==useraccounttable){
        if(section==0){
            return 30;
        }
    }else{
        if ([tableView numberOfSections]-1==section) {
            return 30;
        }else if ([tableView numberOfSections]-1==section) {
            return 30;
        }
    }
    return 15;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==notificationtable) {
        if (section==0){
            return [MyClass returntitlewithtitle:@"Show Class Notifications"];
        }/*else if (section==1){
            return [MyClass returntitlewithtitle:@"Show Task Notifications"];
        }*/
    }else if (tableView==dailyscheduletable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Daily Class Schedule Printout"];
        }else if (section==1) {
            return [MyClass returntitlewithtitle:@"Color"];
        }
    }else if (tableView==courserenewaltable){
        if (section==0){
            return [MyClass returntitlewithtitle:@"System Auto Renew"];
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"Renewal"];
        }else{
            return [MyClass returntitlewithtitle:@"Monthly Course"];
        }
        
    }else if (tableView==accounttable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Change Password"];
        }else{
            return [MyClass returntitlewithtitle:@"Logout"];
        }
    }else if (tableView==attendancetable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Default Attendance"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"Attendance Taking by Scan Code"];
        }else{
            return [MyClass returntitlewithtitle:@"Parent Notifications"];
        }
    }else if (tableView==financialtable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Amount Round Off"];
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"Monthly Fixed Tuition Course"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"Enrollment Fee"];
        }else if (section==3){
            return [MyClass returntitlewithtitle:@"Late Fee"];
        }else if (section==6){
            return [MyClass returntitlewithtitle:@"Default Receipt Remarks as Invoice Remarks"];
        }
    }else if (tableView==printingtable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Print Logo"];
        }else if (section==1) {
            return [MyClass returntitlewithtitle:@"Invoice"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"Receipt"];
        }
    }else if (tableView==messagecentertable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Default Channel"];
        }
    }else if (tableView==photocornertable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"New Post"];
        }
    }else if (tableView==classtimetable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Days to Display"];
        }else if(section==1){
            return [MyClass returntitlewithtitle:@"Display Order"];
        }
    }else if (tableView==studentprofiletable){
        if (section==1) {
            return [MyClass returntitlewithtitle:@"Student's Name Display Order"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"Default Value"];
        }else if (section==3){
            return [MyClass returntitlewithtitle:@"Grade Promotion"];
        }/*else if (section==4){
            return [MyClass returntitlewithtitle:@"Assessment"];
        }*/else if (section==4){
            return [MyClass returntitlewithtitle:@"Others"];
        }
    }else if (tableView==leadprofiletable){
        if (section==1) {
            return [MyClass returntitlewithtitle:@"Lead's Name Display Order"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"Default Value"];
        }
    }else if (tableView==enrollmenttable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Enrollment Validity Period"];
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"Makeup"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"Class"];
        }else if (section==3){
            return [MyClass returntitlewithtitle:@"Lesson Plan"];
        }else if (section==4){
            return [MyClass returntitlewithtitle:@"e-Enrollment From"];
        }
    }else if(tableView==iparenttable){
        if(section==4){
            return [MyClass returntitlewithtitle:@"Expiring Class Reminder"];
        }else if(section==5){
            return [MyClass returntitlewithtitle:@"Expiring Coupon"];
        }else if(section==6){
            return [MyClass returntitlewithtitle:@"Expiring Point"];
        }if(section==7){
            return [MyClass returntitlewithtitle:@"Leave Application Mode"];
        }else if(section==8){
            return [MyClass returntitlewithtitle:@"Optional Menu Item"];
        }else if(section==9){
            return [MyClass returntitlewithtitle:@"Message"];
        }
    }else if (tableView==membershiptable){
        if(section==0){
            return [MyClass returntitlewithtitle:@"General"];
        }else if(section==1){
            return [MyClass returntitlewithtitle:@"Point Earned"];
        }else if(section==2){
            return [MyClass returntitlewithtitle:@"Membership Tier"];
        }
    }else if (tableView==coursetable){
        if(section==0){
            return [MyClass returntitlewithtitle:@"Course Schedule"];
        }
    }else if (tableView==evaluationformtable){
        if (section==2) {
            return [MyClass returntitlewithtitle:@"Evaluation Form"];
        }
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (tableView==courserenewaltable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Every morning the system will automatically check and renew any corresponding courses"];
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"If makeup classes are being considered to determine next start date"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"Apply to those enrollments for the first class starts in the middle of the month"];
        }
    }else if (tableView==generaltable){
        if (section==1) {
            return [MyClass returntitlewithtitle:@"Copyright message"];
        }
    }else if (tableView==attendancetable){
        /*if (section==0) {
            return [MyClass returntitlewithtitle:@"Class with Unknown attendance status will be automatically marked as Absent after class end"];
        }else */if (section==2) {
            return globalvariables.centerrecord.enablescantotakeattendance?[MyClass returntitlewithtitle:@"Please refer to your scanner manual for the power off code"]:nil;
        }else{
            return [MyClass returntitlewithtitle:@"Push notifications will be sent out via iParent app"];
        }
    }else if (tableView==financialtable){
        if (section==1) {
            return [MyClass returntitlewithtitle:@"Input 0 means to use actual no. of week"];
        }
    }else if (tableView==studentprofiletable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Base on the largest student ID found and incremented by 1"];
        }else if(section==1){
            return [self returnstudentnamedisplayorderstring];
        }else if(section==3){
            return [self getlaststudentgradepromotiontimestamp];
        }/*else if(section==4){
            return [MyClass returntitlewithtitle:@"Staff can submit assessment result for each student's class"];
        }*/
    }else if (tableView==leadprofiletable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Base on the largest lead ID found and incremented by 1"];
        }else if(section==1){
            return [self returnleadnamedisplayorderstring];
        }
    }else if (tableView==calendartable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Class can be manually assigned to the reserved working days"];
        }
    }else if (tableView==classtimetable){
        if (section==4){
            return [MyClass returntitlewithtitle:@"Minimum interval between classes start time"];
        }
    }else if (tableView==iparenttable){
        if (section==1) {
            return [MyClass returntitlewithtitle:@"Include Date of Birth, School Grade and School Name"];
        }else if (section==3) {
            return [MyClass returntitlewithtitle:@"Parent will be notified a day before via app message if there is class on the following day"];
        }
    }else if (tableView==chatbottable){
        if(section==0){
            return [MyClass returntitlewithtitle:@"Please contact your Dreamware account representative for the chatbot initial setup"];
        }
    }else if (tableView==evaluationformtable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Staff can submit assessment result for each student's class"];
        }
    }else if (tableView==useraccounttable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"User would need to reset password after expiration"];
        }
    }
    return nil;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    if (tableView==studentprofiletable){
        if (indexPath.section==1) {
            return YES;
        }
    }else if (tableView==leadprofiletable){
        if (indexPath.section==1) {
            return YES;
        }
    }else if (tableView==classtimetable){
        if (indexPath.section==1) {
            return YES;
        }
    }
    
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==menutable) {
        [self showmenuviewwithindexpath:indexPath];
        if (indexPath.section==6){
            [self getappcolorscheme];
        }
    }else if (tableView==financialtable){
        if (indexPath.section==8) {
            [MyClass savedefaultarckey:((ARCodeRecord *)[arcodearray objectAtIndex:indexPath.row-1]).arckey];
            //[MyClass updatelocaldbwithparameter:@"defaultarckey" value:((ARCodeRecord *)[arcodearray objectAtIndex:indexPath.row-1]).arckey];
            [financialtable reloadData];
            [self refreshlanguage];
        }
    }else if (tableView==iparenttable){
        if(indexPath.section==10){
            if(![globalvariables.centerrecord.standaloneparentappid isEqualToString:@""]|| [globalvariables.centerrecord.centerkey isEqualToString:@"604"]||[globalvariables.centerrecord.centerkey isEqualToString:@"722"]){
                CGRect rect=[iparenttable rectForRowAtIndexPath:indexPath];
                CGRect rect2=CGRectMake(rect.origin.x+rect.size.width/2, rect.origin.y, rect.size.width/2, rect.size.height);
                [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:[@(globalvariables.centerrecord.parentappcolorschemekey) stringValue], nil] DataType:@"colorscheme" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(80, appcolorschemearray.count*40) View:self FromRect:rect2 ItemsArray:appcolorschemearray Title:nil Tableview:iparenttable];
            }
        }
    }
}

-(void) showsubject:(UIButton *)button
{
    AssessmentFormListObject *obj=[evaluationformlistarray objectAtIndex:button.tag];
    [MyClass showPickerViewControllerWithSelectedItems:obj.subjectarray DataType:@"EvaluationSubject" DataIndex:button.tag ShowSearchBar:YES BottomMode:@"All" PreferredContentSize:CGSizeMake(300, subjectArray.count*40) View:self Button:button ItemsArray:nil Title:nil MultipleSelection:YES];
}

-(void) showGrade:(UIButton *)button
{
    AssessmentFormListObject *obj=[evaluationformlistarray objectAtIndex:button.tag];
    [MyClass showPickerViewControllerWithSelectedItems:obj.gradearray DataType:@"EvaluationGrade" DataIndex:button.tag ShowSearchBar:YES BottomMode:@"All" PreferredContentSize:CGSizeMake(300, subjectArray.count*40) View:self Button:button ItemsArray:nil Title:nil MultipleSelection:YES];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (tableView==menutable){
        
        UILabel *menulabel;
        UIImageView *menuimage;
        UILabel *datelabel;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            menuimage=[[UIImageView alloc]initWithFrame:CGRectMake(9, 7, 26, 26)];
            menuimage.layer.cornerRadius=5;
            menuimage.tag=103;
            menuimage.layer.masksToBounds=YES;
            [menuimage setImage:[UIImage imageNamed:@"settings_icon.png"]];
            [cell.contentView addSubview:menuimage];
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 300, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[menuitem_section_0 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
        }else if (indexPath.section==3) {
            menuimage=[[UIImageView alloc]initWithFrame:CGRectMake(9, 7, 26, 26)];
            menuimage.layer.cornerRadius=5;
            menuimage.tag=103;
            menuimage.layer.masksToBounds=YES;
            [cell.contentView addSubview:menuimage];
            
            menuimage=[[UIImageView alloc]initWithFrame:CGRectMake(9, 7, 26, 26)];
            menuimage.layer.cornerRadius=5;
            menuimage.tag=103;
            menuimage.layer.masksToBounds=YES;
            //[menuimage setImage:[UIImage imageNamed:@"settings_icon.png"]];
            [cell.contentView addSubview:menuimage];
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 300, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[menuitem_section_3 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            if (indexPath.row==0) {
                [menuimage setImage:[UIImage imageNamed:@"studentprofile_icon.png"]];
            }else if (indexPath.row==1) {
                [menuimage setImage:[UIImage imageNamed:@"notifications_icon.png"]];
            }else if (indexPath.row==2){
                [menuimage setImage:[UIImage imageNamed:@"dailyclassschedule_icon.png"]];
                menuimage.layer.borderColor=[UIColor grayColor].CGColor;
                menuimage.layer.borderWidth=.6;
                
                datelabel=[[UILabel alloc]initWithFrame:CGRectMake(9, 10, 26, 26)];
                [datelabel setFont:[UIFont systemFontOfSize:16]];
                datelabel.textColor=[UIColor blackColor];
                datelabel.highlightedTextColor = [UIColor blackColor];
                datelabel.textAlignment=NSTextAlignmentCenter;
                datelabel.tag=104;
                NSDateFormatter *df=[[NSDateFormatter alloc]init];
                df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
                [df setDateFormat:@"d"];
                datelabel.text=[df stringFromDate:[NSDate date]];
                [cell.contentView addSubview:datelabel];
                
                
            }else if (indexPath.row==3) {
                [menuimage setImage:[UIImage imageNamed:@"classtimetable_icon.png"]];
            }else if (indexPath.row==4) {
                [menuimage setImage:[UIImage imageNamed:@"classrenewal_icon.png"]];
            }else if (indexPath.row==5) {
                [menuimage setImage:[UIImage imageNamed:@"messagecenter_icon.png"]];
            }else if (indexPath.row==6) {
                [menuimage setImage:[UIImage imageNamed:@"classphoto_icon.png"]];
            }else if (indexPath.row==7) {
                [menuimage setImage:[UIImage imageNamed:@"leadprofile_icon.png"]];
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
        }else if (indexPath.section==4) {
            
            menuimage=[[UIImageView alloc]initWithFrame:CGRectMake(9, 7, 26, 26)];
            menuimage.layer.cornerRadius=5;
            menuimage.tag=103;
            menuimage.layer.masksToBounds=YES;

            [cell.contentView addSubview:menuimage];
            
            cell.hidden=NO;
            if (indexPath.row==0) {
                [menuimage setImage:[MyClass drawattendanceringiconwithbuttonarray:[[NSMutableArray alloc]initWithArray:[MyClass returnregularattendancebuttonarray]]]];
            }else if (indexPath.row==1){
                [menuimage setImage:[UIImage imageNamed:@"paymentinformation_icon.png"]];
            }else if (indexPath.row==2) {
                [menuimage setImage:[UIImage imageNamed:@"print_icon.png"]];
                menuimage.layer.borderColor=[UIColor grayColor].CGColor;
                menuimage.layer.borderWidth=.6;
            }else if (indexPath.row==3){
                [menuimage setImage:[UIImage imageNamed:@"classtimetable_icon.png"]];
                menuimage.layer.borderColor=[UIColor grayColor].CGColor;
                menuimage.layer.borderWidth=.6;
            }else if (indexPath.row==4){
                [menuimage setImage:[UIImage imageNamed:@"enrollment_icon.png"]];
                menuimage.layer.borderColor=[UIColor grayColor].CGColor;
                menuimage.layer.borderWidth=.6;
            }else if (indexPath.row==5){
                [menuimage setImage:[UIImage imageNamed:@"icon_course.png"]];
                menuimage.layer.borderColor=[UIColor grayColor].CGColor;
                menuimage.layer.borderWidth=.6;
            }else if (indexPath.row==6){
                [menuimage setImage:[UIImage imageNamed:@"alert_icon.png"]];
                menuimage.layer.borderColor=[UIColor grayColor].CGColor;
                menuimage.layer.borderWidth=.6;
                
                if (!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showautonotificationsettings) {
                    cell.hidden=YES;
                }
                
                
            }else if (indexPath.row==7){
                [menuimage setImage:[UIImage imageNamed:@"membership_icon.png"]];
                menuimage.layer.borderColor=[UIColor clearColor].CGColor;
                menuimage.layer.borderWidth=.6;
            }else if (indexPath.row==8){
                [menuimage setImage:[UIImage imageNamed:@"chatbot_icon.png"]];
                menuimage.layer.borderColor=[UIColor clearColor].CGColor;
                menuimage.layer.borderWidth=.6;
            }else if (indexPath.row==9){
                [menuimage setImage:[UIImage imageNamed:@"assessmentform_icon.png"]];
                menuimage.layer.borderColor=[UIColor clearColor].CGColor;
                menuimage.layer.borderWidth=.6;
            }else if (indexPath.row==10){
                [menuimage setImage:[UIImage imageNamed:@"centerqrcode_icon.png"]];
                menuimage.layer.borderColor=[UIColor clearColor].CGColor;
                menuimage.layer.borderWidth=.6;
            }else if (indexPath.row==11){
                [menuimage setImage:[UIImage imageNamed:@"useraccount_icon.png"]];
                menuimage.layer.borderColor=[UIColor clearColor].CGColor;
                menuimage.layer.borderWidth=.6;
            }
            
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 300, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[menuitem_section_4 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
        }else if (indexPath.section==5) {
            
            menuimage=[[UIImageView alloc]initWithFrame:CGRectMake(9, 7, 26, 26)];
            menuimage.layer.cornerRadius=5;
            menuimage.tag=103;
            menuimage.layer.masksToBounds=YES;
//            [menuimage setImage:[UIImage imageNamed:@"iStaff-76@2x.png"]];
            
            [MyClass downloadImageWithImageview:menuimage gender:nil type:@"staffappimage" typekey:globalvariables.centerrecord.standalonestaffappid image:@"Yes" async:YES];
            
            menuimage.layer.borderColor=[UIColor grayColor].CGColor;
            menuimage.layer.borderWidth=.6;
            [cell.contentView addSubview:menuimage];
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 300, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[globalvariables.centerrecord.standalonestaffappid isEqualToString:@""]?[menuitem_section_5 objectAtIndex:indexPath.row]:@"Staff App"];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            

            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
        }else if (indexPath.section==6) {
            
            menuimage=[[UIImageView alloc]initWithFrame:CGRectMake(9, 7, 26, 26)];
            menuimage.layer.cornerRadius=5;
            menuimage.tag=103;
            menuimage.layer.masksToBounds=YES;
            //[menuimage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",globalvariables.centerrecord.standaloneparentappid]]];
            
            [MyClass downloadImageWithImageview:menuimage gender:nil type:@"studentappimage" typekey:globalvariables.centerrecord.standaloneparentappid image:@"Yes" async:YES];
            
            menuimage.layer.borderColor=[UIColor grayColor].CGColor;
            menuimage.layer.borderWidth=.6;
            [cell.contentView addSubview:menuimage];
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 300, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[globalvariables.centerrecord.standaloneparentappid isEqualToString:@""]?[menuitem_section_6 objectAtIndex:indexPath.row]:@"Parent App"];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
        }else if (indexPath.section==1) {
            
            menuimage=[[UIImageView alloc]initWithFrame:CGRectMake(9, 7, 26, 26)];
            menuimage.layer.cornerRadius=5;
            menuimage.tag=103;
            menuimage.layer.masksToBounds=YES;
            [menuimage setImage:[UIImage imageNamed:@"boyimage.jpg"]];
            menuimage.layer.borderColor=[UIColor lightGrayColor].CGColor;
            menuimage.layer.borderWidth=.6;
            [cell.contentView addSubview:menuimage];
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 300, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[menuitem_section_1 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
        }else if (indexPath.section==2) {
            
            menuimage=[[UIImageView alloc]initWithFrame:CGRectMake(9, 7, 26, 26)];
            menuimage.layer.cornerRadius=5;
            menuimage.tag=103;
            menuimage.layer.masksToBounds=YES;
            [menuimage setImage:[UIImage imageNamed:@"new_icon.png"]];
            //menuimage.layer.borderColor=[UIColor grayColor].CGColor;
            //menuimage.layer.borderWidth=.6;
            [cell.contentView addSubview:menuimage];
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 300, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[menuitem_section_2 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            
        }
        
        //cell.backgroundColor=[UIColor whiteColor];
        
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
        bgView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
        cell.selectedBackgroundView = bgView;
        
    }else if (tableView==notificationtable){
        
        UILabel *menulabel;
        UISwitch *menuswitch;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[notification_section_class objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            
            menuswitch = [[UISwitch alloc] init];
            CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
            menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
            menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            menuswitch.tag = 501;
            menuswitch.onTintColor=themecolor;
            [menuswitch addTarget:self action:@selector(enablenotification:) forControlEvents:UIControlEventValueChanged];
            menuswitch.tag=indexPath.section*10+indexPath.row;
            //menuswitch.on=[[MyClass getlocaldbwithparameter:[notification_class_parameters objectAtIndex:indexPath.row]] isEqualToString:@"Yes"]?TRUE:FALSE;
            //NSLog(@"%@",[((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]) valueForKey:[notification_class_parameters objectAtIndex:indexPath.row]]);
            menuswitch.on=[[((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]) valueForKey:[notification_class_parameters objectAtIndex:indexPath.row]] boolValue];
            [cell.contentView addSubview:menuswitch];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }/*else if (indexPath.section==1) {
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[notification_section_task objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            menuswitch = [[UISwitch alloc] init];
            CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
            menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
            menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            menuswitch.tag = 501;
            menuswitch.onTintColor=themecolor;
            [menuswitch addTarget:self action:@selector(enablenotification:) forControlEvents:UIControlEventValueChanged];
            menuswitch.tag=indexPath.section*10+indexPath.row;
            menuswitch.on=[[MyClass getlocaldbwithparameter:[notification_task_parameters objectAtIndex:indexPath.row]] isEqualToString:@"Yes"]?TRUE:FALSE;
            [cell.contentView addSubview:menuswitch];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }*/
        
    }else if (tableView==generaltable){
        
        UILabel *menulabel;
        UISegmentedControl *menusegmentcontrol;
        UISwitch *menuswitch;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Language"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"English",@"中文(繁)",@"中文(简)",nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                [menusegmentcontrol addTarget:self action:@selector(selectlanguage:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=[globalvariables.language isEqualToString:@"English"]?0:([globalvariables.language isEqualToString:@"Chinese"]?1:2);
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Mandatory for New Version Update"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateicenterversioncheck:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.icenterversioncheck;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==1) {
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:@"Version"];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor grayColor];
            menulabel.textAlignment=NSTextAlignmentRight;
            menulabel.text=[NSString stringWithFormat:@"iSchool iCenter %@ (%@) %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle] infoDictionary]objectForKey:(NSString*)kCFBundleVersionKey],[NSString stringWithFormat:@"%@",[globalvariables.serverpath isEqualToString:globalvariables.primaryserverpath] ? @"P":@"S"]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            
        }
        
    }else if (tableView==dailyscheduletable){
        
        UILabel *menulabel;
        UISwitch *menuswitch;
        UITextField *menutext;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[dailyschedule_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-200-20, 5, 200, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[MyClass getlocaldbwithparameter:@"dailyclassschedulemaxrow"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editdailyclassmaxrow:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[dailyschedule_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(selectshowcontactindailyscheduleprintout:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.showcontactindailyscheduleprintout;// [[MyClass getlocaldbwithparameter:@"showcontactindailyscheduleprintout"] isEqualToString:@"Yes"]?TRUE:FALSE;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==2) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[dailyschedule_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(showduepaymentindailyscheduleprintout:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.showduepaymentindailyscheduleprintout;//[[MyClass getlocaldbwithparameter:@"showduepaymentindailyscheduleprintout"] isEqualToString:@"Yes"]?TRUE:FALSE;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
        }else if (indexPath.section==1) {
            if (indexPath.row==0) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[dailyschedule_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(selectdailyscheduleshowsubjectcolor:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=[[MyClass getlocaldbwithparameter:@"dailyscheduleshowsubjectcolor"] isEqualToString:@"Yes"];
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[dailyschedule_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(selectdailyscheduleshowinstructorcolor:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=[[MyClass getlocaldbwithparameter:@"dailyscheduleshowinstructorcolor"] isEqualToString:@"Yes"];
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }/*else if (indexPath.row==2) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[dailyschedule_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(selectdailyscheduleshowclassroomcolor:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=[[MyClass getlocaldbwithparameter:@"dailyscheduleshowclassroomcolor"] isEqualToString:@"Yes"];
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }*/
        }
        

        
    }else if (tableView==classtimetable){
        
        UILabel *menulabel;
        UISwitch *menuswitch;
        UIButton *menubutton;
        UISegmentedControl *menusegmentcontrol;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returnEEEEwithEEEdate:[classtimetable_parameters_0 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            
            menuswitch = [[UISwitch alloc] init];
            CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
            menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
            menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            menuswitch.tag = 501;
            menuswitch.onTintColor=themecolor;
            [menuswitch addTarget:self action:@selector(enableclasstimetabledaystodisplay:) forControlEvents:UIControlEventValueChanged];
            menuswitch.tag=indexPath.section*10+indexPath.row;
            menuswitch.on=[[((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).classtimetabledaystodisplay componentsSeparatedByString:@","] containsObject:[classtimetable_parameters_0 objectAtIndex:indexPath.row]]?TRUE:FALSE;
            [cell.contentView addSubview:menuswitch];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else if (indexPath.section==1) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"section_1_cell"];
            
            UILabel *menulabel;
            UISwitch *menuswitch;
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section_1_cell"];
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.tag=1301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 1302;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatetimetabledisplayorder:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:menuswitch];
                
            }else{
                menulabel=(UILabel *)[cell.contentView viewWithTag:1301];
                menuswitch=(UISwitch *)[cell.contentView viewWithTag:1302];
            }
            
            menulabel.text=[MyClass returntitlewithtitle:[self returnsortinglabelwithitem:((SortingRecord *)[classtimetable_parameters_1 objectAtIndex:indexPath.row]).item]];
            menuswitch.on=[((SortingRecord *)[classtimetable_parameters_1 objectAtIndex:indexPath.row]).order isEqualToString:@"e"]?YES:NO;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.section==2){
            if (indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[classtimetable_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Per Student"],[MyClass returntitlewithtitle:@"Per Class"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-230-20, 5, 230, 30);
                [menusegmentcontrol addTarget:self action:@selector(updatetimetableoutstandingmode:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=[[MyClass getlocaldbwithparameter:@"timetableoutstandingmode"] isEqualToString:@"perstudent"]?0:1;
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==3){
            
            if (indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[classtimetable_parameters_3 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatetimetableshowallstudentcount:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=[[MyClass getlocaldbwithparameter:@"timetableshowallstudentcount"] isEqualToString:@"Y"];
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==1){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[classtimetable_parameters_3 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatetimetableshowattendingcount:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=[[MyClass getlocaldbwithparameter:@"timetableshowattendingcount"] isEqualToString:@"Y"];
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==2){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[classtimetable_parameters_3 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatetimetableshowoutstandingpaymentstudentcount:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=[[MyClass getlocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount"] isEqualToString:@"Y"];
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[classtimetable_parameters_3 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateshowageintimetable:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=[[MyClass getlocaldbwithparameter:@"showageintimetable"] isEqualToString:@"Y"];
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
        }else{
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[classtimetable_parameters_4 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            if (indexPath.row==0){
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatefullday:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.fullday;
                [cell.contentView addSubview:menuswitch];
            }else{
                menubutton=[[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 4, 100, 32)];
                [menubutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                menubutton.titleLabel.font=[UIFont systemFontOfSize:15];
                menubutton.layer.cornerRadius=5;
                
                if (indexPath.row==1) {
                    [menubutton setBackgroundColor:globalvariables.centerrecord.fullday?[UIColor lightGrayColor]:themecolor];
                    [menubutton addTarget:self action:@selector(changeclassstarttimebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                    [menubutton setTitle:[NSString stringWithFormat:@"%@:%@",[globalvariables.centerrecord.classstarttime substringToIndex:2],[globalvariables.centerrecord.classstarttime substringFromIndex:2]] forState:UIControlStateNormal];
                    menubutton.enabled=!globalvariables.centerrecord.fullday;
                }else if (indexPath.row==2){
                    [menubutton setBackgroundColor:globalvariables.centerrecord.fullday?[UIColor lightGrayColor]:themecolor];
                    [menubutton addTarget:self action:@selector(changeclassendtimebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                    [menubutton setTitle:[NSString stringWithFormat:@"%@:%@",[globalvariables.centerrecord.classendtime substringToIndex:2],[globalvariables.centerrecord.classendtime substringFromIndex:2]] forState:UIControlStateNormal];
                    menubutton.enabled=!globalvariables.centerrecord.fullday;
                }else{
                    [menubutton setBackgroundColor:themecolor];
                    [menubutton addTarget:self action:@selector(changeclasstimeintervalbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                    [menubutton setTitle:globalvariables.centerrecord.classtimeinterval forState:UIControlStateNormal];
                }
                [cell.contentView addSubview:menubutton];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    }else if (tableView==courserenewaltable){
        
        UILabel *menulabel;
        UISwitch *menuswitch;
        UITextField *menutext;
        UISegmentedControl *menusegmentcontrol;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[courserenewal_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(selectenableautobatchrenew:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.enableautobatchrenew;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[courserenewal_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-60-20, 5, 60, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.autobatchrenewdaystoinclude;
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editautobatchrenewdaystoinclude:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editautobatchrenewdaystoinclude_editingend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==2) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[courserenewal_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-60-20, 5, 60, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.autorenewal_date_for_monthlycourse;
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editautorenewal_date_for_monthlycourse:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editautorenewal_date_for_monthlycourse_editingend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }/*else if (indexPath.row==3) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[courserenewal_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateskipmakeupforrenewal:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).skipmakeupforrenewal;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }*/else if (indexPath.row==3) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[courserenewal_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateautosendeinvoice:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.autosendeinvoice;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
        }else if (indexPath.section==1){
            if (indexPath.row==0) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[courserenewal_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updaterenewevenifthereistbdclass:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.renewevenifthereistbdclass;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[courserenewal_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateusereserveddayduringrenewal:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.usereserveddayduringrenewal;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==2) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[courserenewal_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatemarkrenewalreserveddaytomakeup:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.markrenewalreserveddaytomakeup;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==3) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[courserenewal_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatejumptonextlevelduringrenewal:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.jumptonextlevelduringrenewal;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.hidden=YES;
                
            }else if (indexPath.row==4) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[courserenewal_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateskipmakeupforrenewal_prepare:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.skipmakeupforrenewal_prepare;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==5) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[courserenewal_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateskipmakeupforrenewal:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).skipmakeupforrenewal;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
        }else{
            if (indexPath.row==0) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[courserenewal_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Extend"],[MyClass returntitlewithtitle:@"Reduce"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-230-20, 5, 230, 30);
                [menusegmentcontrol addTarget:self action:@selector(updaterenewmonthlyroundup:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=globalvariables.centerrecord.renewmonthlyroundup?0:1;
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
        }
        

        
    }else if (tableView==printingtable){
        
        UILabel *menulabel;
        UISegmentedControl *menusegmentcontrol;
        UIImageView *printlogoimage;
        UISwitch *menuswitch;
        UITextField *menutext;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0){

            printlogoimage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 10, 180, 120)];
            printlogoimage.contentMode=UIViewContentModeScaleAspectFit;
            printlogoimage.backgroundColor=[UIColor whiteColor];
            printlogoimage.userInteractionEnabled = YES;
            printlogoimage.clipsToBounds=YES;
            
            [printlogoimage setImage:[UIImage imageWithData:tmpprintlogoimagedata]];
            [cell.contentView addSubview:printlogoimage];

            editprintlogobutton=[[UIButton alloc]initWithFrame:CGRectMake(printlogoimage.frame.size.width-30-5, printlogoimage.frame.size.height-30-5, 30, 30)];
            [editprintlogobutton setImage:[UIImage imageNamed:@"camera_icon.png"] forState:UIControlStateNormal];
            [editprintlogobutton addTarget:self action:@selector(editprintlogobuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            [printlogoimage addSubview:editprintlogobutton];

            cell.backgroundColor=[UIColor clearColor];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.section==1) {
            if (indexPath.row==0) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[printing_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Off"],[MyClass returntitlewithtitle:@"1 Copy"],[MyClass returntitlewithtitle:@"2 Copies"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                menusegmentcontrol.tintColor=themecolor;
                [menusegmentcontrol addTarget:self action:@selector(switcha4trayfora5printing_invoice:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).a4trayfora5printing_invoice;
                [cell.contentView addSubview:menusegmentcontrol];
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[printing_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Medium"],[MyClass returntitlewithtitle:@"Large"],[MyClass returntitlewithtitle:@"Extra Large"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                [menusegmentcontrol addTarget:self action:@selector(selectinvoicefontsize:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=globalvariables.centerrecord.invoicefontsize;// [[MyClass getlocaldbwithparameter:@"invoicefontsize"] intValue];
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==2) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[printing_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Small"],[MyClass returntitlewithtitle:@"Medium"],[MyClass returntitlewithtitle:@"Large"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                [menusegmentcontrol addTarget:self action:@selector(selecttncfontsize_invoice:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=globalvariables.centerrecord.tncfontsize_invoice;//[[MyClass getlocaldbwithparameter:@"tncfontsize_invoice"] intValue];
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==3) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[printing_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Auto"],[MyClass returntitlewithtitle:@"Black & White"],[MyClass returntitlewithtitle:@"Color"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                [menusegmentcontrol addTarget:self action:@selector(selectdefaultprintcolor_invoice:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=[[MyClass getlocaldbwithparameter:@"defaultprintcolor_invoice"] intValue];
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==4) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[printing_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Off"],[MyClass returntitlewithtitle:@"1st Class Only"],[MyClass returntitlewithtitle:@"All"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                [menusegmentcontrol addTarget:self action:@selector(selectshowclassdatesininvoice:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=globalvariables.centerrecord.showclassdatesininvoice;
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==5){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Show Level"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(showlevelininvoice:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.showlevelininvoice;//[[MyClass getlocaldbwithparameter:@"showlevelininvoice"] isEqualToString:@"Yes"];
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==6){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Show Discount Details"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(showdiscountdetailsininvoice:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.showdiscountdetailsininvoice;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==7){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Invoice Prefix"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-120-20, 5, 120, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.invoiceprefix;
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(updateinvoiceprefix:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==2) {
            if (indexPath.row==0) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[printing_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                

                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Off"],[MyClass returntitlewithtitle:@"1 Copy"],[MyClass returntitlewithtitle:@"2 Copies"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                menusegmentcontrol.tintColor=themecolor;
                [menusegmentcontrol addTarget:self action:@selector(switcha4trayfora5printing:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).a4trayfora5printing_receipt;
                [cell.contentView addSubview:menusegmentcontrol];
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[printing_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Medium"],[MyClass returntitlewithtitle:@"Large"],[MyClass returntitlewithtitle:@"Extra Large"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                [menusegmentcontrol addTarget:self action:@selector(selectreceiptfontsize:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=globalvariables.centerrecord.receiptfontsize;//[[MyClass getlocaldbwithparameter:@"receiptfontsize"] intValue];
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==2) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[printing_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Small"],[MyClass returntitlewithtitle:@"Medium"],[MyClass returntitlewithtitle:@"Large"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                [menusegmentcontrol addTarget:self action:@selector(selecttncfontsize:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=globalvariables.centerrecord.tncfontsize_receipt;// [[MyClass getlocaldbwithparameter:@"tncfontsize"] intValue];
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==3) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[printing_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Auto"],[MyClass returntitlewithtitle:@"Black & White"],[MyClass returntitlewithtitle:@"Color"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                [menusegmentcontrol addTarget:self action:@selector(selectdefaultprintcolor:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=[[MyClass getlocaldbwithparameter:@"defaultprintcolor"] intValue];
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==4) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[printing_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Off"],[MyClass returntitlewithtitle:@"1st Class Only"],[MyClass returntitlewithtitle:@"All"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                [menusegmentcontrol addTarget:self action:@selector(selectshowclassdatesinreceipt:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=globalvariables.centerrecord.showclassdatesinreceipt;
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==5){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Show Level"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(showlevelinreceipt:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.showlevelinreceipt;// [[MyClass getlocaldbwithparameter:@"showlevelinreceipt"] isEqualToString:@"Yes"];
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==6){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Show Discount Details"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(showdiscountdetailsinreceipt:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.showdiscountdetailsinreceipt;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==7){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Show Staff Name"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(showstaffnameinreceipt:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.showstaffnameinreceipt;// [[MyClass getlocaldbwithparameter:@"showstaffnameinreceipt"] isEqualToString:@"Yes"];
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==8){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Show Last Payment Details Only"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(showlastpaymentonlyinreceipt:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.showlastpaymentonlyinreceipt;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==9){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Automatically Send eReceipt"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateautosendereceipt:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.autosendereceipt;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==10){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Receipt Prefix"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-120-20, 5, 120, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.receiptprefix;
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(updatereceiptprefix:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==3) {
            if (indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Class Date Mode"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Original"],[MyClass returntitlewithtitle:@"Actual"],[MyClass returntitlewithtitle:@"Both"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                menusegmentcontrol.tintColor=themecolor;
                [menusegmentcontrol addTarget:self action:@selector(switchprintclassdatemode:) forControlEvents: UIControlEventValueChanged];
                
                if([globalvariables.centerrecord.printclassdatemode isEqualToString:@"Original"]){
                    menusegmentcontrol.selectedSegmentIndex=0;
                }else if([globalvariables.centerrecord.printclassdatemode isEqualToString:@"Actual"]){
                    menusegmentcontrol.selectedSegmentIndex=1;
                }else{
                    menusegmentcontrol.selectedSegmentIndex=2;
                }

                [cell.contentView addSubview:menusegmentcontrol];
                
//                menuswitch = [[UISwitch alloc] init];
//                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
//                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
//                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
//                menuswitch.tag = 501;
//                menuswitch.onTintColor=themecolor;
//                [menuswitch addTarget:self action:@selector(updateprintclassdatemode:) forControlEvents:UIControlEventValueChanged];
//                menuswitch.on=globalvariables.centerrecord.printclassdatemode;
//                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Show End Time"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateprintclassdateendtime:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.printclassdateendtime;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        
    }else if (tableView==messagecentertable){
        
        UILabel *menulabel;
        UISegmentedControl *menusegmentcontrol;
        UISwitch *menuswitch;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[messagecenter_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"App/SMS",@"App",@"SMS",@"Email",nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                [menusegmentcontrol addTarget:self action:@selector(selectdefaultstudentmessagechannel:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=[MyClass returnChannelIndexWithRecipientType:@"Student" Channel:globalvariables.centerrecord.defaultstudentmessagechannel];
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[messagecenter_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"SMS",@"Email",nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                [menusegmentcontrol addTarget:self action:@selector(selectdefaultleadmessagechannel:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=[MyClass returnChannelIndexWithRecipientType:@"Lead" Channel:globalvariables.centerrecord.defaultleadmessagechannel];
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==1){
            if (indexPath.row==0) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[messagecenter_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateenablevoicemessage:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.enablevoicemessage;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[messagecenter_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateenablevideomessage:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.enablevideomessage;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
        
    }else if (tableView==accounttable){
        
        UILabel *menulabel;
        UIButton *menubutton;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[account_parameters objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                oldpasswordtext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-320-20, 5, 320, 30)];
                oldpasswordtext.font=[UIFont systemFontOfSize:15];
                oldpasswordtext.textColor=[UIColor darkGrayColor];
                oldpasswordtext.textAlignment=NSTextAlignmentRight;
                oldpasswordtext.secureTextEntry = YES;
                oldpasswordtext.text=@"";
                oldpasswordtext.placeholder=[MyClass returntitlewithtitle:@"Old Password"];
                oldpasswordtext.borderStyle = UITextBorderStyleRoundedRect;
                [cell.contentView addSubview:oldpasswordtext];

                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[account_parameters objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                newpasswordtext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-320-20, 5, 320, 30)];
                newpasswordtext.font=[UIFont systemFontOfSize:15];
                newpasswordtext.textColor=[UIColor darkGrayColor];
                newpasswordtext.textAlignment=NSTextAlignmentRight;
                newpasswordtext.secureTextEntry = YES;
                newpasswordtext.text=@"";
                newpasswordtext.placeholder=[MyClass returntitlewithtitle:@"New Password"];
                newpasswordtext.borderStyle = UITextBorderStyleRoundedRect;
                [cell.contentView addSubview:newpasswordtext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==2) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[account_parameters objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                confirmpasswordtext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-320-20, 5, 320, 30)];
                confirmpasswordtext.font=[UIFont systemFontOfSize:15];
                confirmpasswordtext.textColor=[UIColor darkGrayColor];
                confirmpasswordtext.textAlignment=NSTextAlignmentRight;
                confirmpasswordtext.secureTextEntry = YES;
                confirmpasswordtext.text=@"";
                confirmpasswordtext.placeholder=[MyClass returntitlewithtitle:@"New Password"];
                confirmpasswordtext.borderStyle = UITextBorderStyleRoundedRect;
                [cell.contentView addSubview:confirmpasswordtext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==3){
                menubutton=[[UIButton alloc]init];
                menubutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                menubutton.frame=CGRectMake(tableView.frame.size.width-301-20, 5, 301, 30);
                menubutton.titleLabel.font=[UIFont systemFontOfSize:15];
                
                menubutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                [menubutton addTarget: self action:@selector(changepasswordbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
                
                [menubutton setTitle:[MyClass returntitlewithtitle:@"Change Password"] forState:UIControlStateNormal];
                [menubutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                
                [cell.contentView addSubview:menubutton];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==1){
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=globalvariables.username;
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            menubutton=[[UIButton alloc]init];
            menubutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            menubutton.frame=CGRectMake(tableView.frame.size.width-301-20, 5, 301, 30);
            menubutton.titleLabel.font=[UIFont systemFontOfSize:15];
            
            menubutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [menubutton addTarget: self action:@selector(logoutbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
            
            menubutton.enabled=YES;
            [menubutton setTitle:[MyClass returntitlewithtitle:@"Logout"] forState:UIControlStateNormal];
            [menubutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            
            [cell.contentView addSubview:menubutton];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

        }
    }else if (tableView==attendancetable){
        
        UILabel *menulabel;
        UISwitch *menuswitch;
        UISegmentedControl *menusegmentcontrol;
        UITextField *menutext;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if(indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[attendance_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"attendance_Present"],[MyClass returntitlewithtitle:@"attendance_Unknown"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-230-20, 5, 230, 30);
                [menusegmentcontrol addTarget:self action:@selector(updatedefaultattendancestatus:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=[globalvariables.centerrecord.defaultattendancestatus isEqualToString:@"Present"]?0:1;
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[attendance_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"attendance_Absent"],[MyClass returntitlewithtitle:@"attendance_Makeup"],[MyClass returntitlewithtitle:@"attendance_Present"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-230-20, 5, 230, 30);
                [menusegmentcontrol addTarget:self action:@selector(updatemark_noattendancetaking_to:) forControlEvents: UIControlEventValueChanged];
                if ([globalvariables.centerrecord.mark_noattendancetaking_to isEqualToString:@"Absent"]) {
                    menusegmentcontrol.selectedSegmentIndex=0;
                }else if ([globalvariables.centerrecord.mark_noattendancetaking_to isEqualToString:@"Makeup"]) {
                    menusegmentcontrol.selectedSegmentIndex=1;
                }else{
                    menusegmentcontrol.selectedSegmentIndex=2;
                }
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==2){
            if (indexPath.row==0) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[attendance_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateenablescantotakeattendance:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.enablescantotakeattendance;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[attendance_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Barcode"],[MyClass returntitlewithtitle:@"QRcode"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-230-20, 5, 230, 30);
                [menusegmentcontrol addTarget:self action:@selector(updatescantype:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=[globalvariables.centerrecord.scantype isEqualToString:@"barcode"]?0:1;
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
            }else if (indexPath.row==2) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[attendance_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-230-20, 5, 230, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[NSString stringWithFormat:@"%i",globalvariables.centerrecord.scantotakeattendancebeforethreshold];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(updatescantotakeattendancebeforethreshold:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
            }else if (indexPath.row==3) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[attendance_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-230-20, 5, 230, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[NSString stringWithFormat:@"%i",globalvariables.centerrecord.scantotakeattendanceafterthreshold];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(updatescantotakeattendanceafterthreshold:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[attendance_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-230-20, 5, 230, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.scannerpoweroffcode;//[MyClass getlocaldbwithparameter:@"scannerpoweroffcode"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editscannerpoweroffcode:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
            }
        }else if (indexPath.section==1){
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[attendance_parameters_2 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            
            menuswitch = [[UISwitch alloc] init];
            CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
            menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
            menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            menuswitch.tag = 501;
            menuswitch.onTintColor=themecolor;
            [menuswitch addTarget:self action:@selector(enableattendancenotification:) forControlEvents:UIControlEventValueChanged];
            menuswitch.tag=indexPath.row;
            //menuswitch.on=[[MyClass getlocaldbwithparameter:[notification_class_parameters objectAtIndex:indexPath.row]] isEqualToString:@"Yes"]?TRUE:FALSE;
            [cell.contentView addSubview:menuswitch];
            
            if (indexPath.row==0) {
                menuswitch.on=((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).presentalert;
            }else if (indexPath.row==1){
                menuswitch.on=((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).absentalert;
            }else{
                menuswitch.on=((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).makeupalert;
            }
            
            if (indexPath.row==0) {
                if ([globalvariables.centerrecord.defaultattendancestatus isEqualToString:@"Present"]) {
                    cell.hidden=YES;
                }else{
                    cell.hidden=NO;
                }
            }else{
                cell.hidden=NO;
            }

            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else{
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[attendance_parameters_3 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            menuswitch = [[UISwitch alloc] init];
            CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
            menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
            menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            menuswitch.tag = 501;
            menuswitch.onTintColor=themecolor;
            menuswitch.enabled=![self hasExtendedClass];
            [menuswitch addTarget:self action:@selector(updateenableattendanceextend:) forControlEvents:UIControlEventValueChanged];
            menuswitch.on=globalvariables.centerrecord.enableattendanceextend;
            [cell.contentView addSubview:menuswitch];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if (tableView==calendartable){
        
        UILabel *menulabel;
        UISwitch *menuswitch;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[calendar_parameters_0 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            menuswitch = [[UISwitch alloc] init];
            CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
            menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
            menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            menuswitch.tag = 501;
            menuswitch.onTintColor=themecolor;
            [menuswitch addTarget:self action:@selector(updatereservedcalendardate:) forControlEvents:UIControlEventValueChanged];
            menuswitch.on=globalvariables.centerrecord.reservedcalendardate;
            [cell.contentView addSubview:menuswitch];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if (tableView==enrollmenttable){
        
        UILabel *menulabel;
        UISwitch *menuswitch;
        UITextField *menutext;
        UISegmentedControl *menusegmentcontrol;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateenrollmentvalidity:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.enrollmentvalidity;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateshowvalidityininvoicereceipt:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.showvalidityininvoicereceipt;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
        }/*else if (indexPath.section==1) {
            //if(indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                [menuswitch addTarget:self action:@selector(updateenrollmultiplesubjectsatsametimeslot:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.enrollmultiplesubjectsatsametimeslot;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }*/else if (indexPath.section==1){
            if(indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateenablemakeupquota:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.enablemakeupquota;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==1){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.maxdayformakeup==-1?@"":[@(globalvariables.centerrecord.maxdayformakeup) stringValue];
                menutext.placeholder=[MyClass returntitlewithtitle:@"<365"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editmaxdayformakeup:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editmaxdayformakeup_editingend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==2){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.noofdayafteroriginalclassformakeup;
                menutext.placeholder=[MyClass returntitlewithtitle:@"Unlimited"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editnoofdayafteroriginalclassformakeup:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editnoofdayafteroriginalclassformakeupdidend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==2){
            if(indexPath.row==0){
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatemarkexpiredclassabsent:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.markexpiredclassabsent;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==1){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateupdateclassafterschedulechange:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.updateclassafterschedulechange;
    //            menuswitch.enabled=NO;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==2){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.lockclassperiod;
                menutext.placeholder=[MyClass returntitlewithtitle:@"Never"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editlockclassperiod:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editlockclassperioddidend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==3){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.autodropenrollmentday;
                menutext.placeholder=[MyClass returntitlewithtitle:@"Never"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editautodropenrollmentday:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editautodropenrollmentdaydidend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
        }else if (indexPath.section==3){

            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_3 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            menuswitch = [[UISwitch alloc] init];
            CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
            menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
            menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            menuswitch.tag = 501;
            menuswitch.onTintColor=themecolor;
            [menuswitch addTarget:self action:@selector(updateenablelessonnumber:) forControlEvents:UIControlEventValueChanged];
            menuswitch.on=globalvariables.centerrecord.enablelessonnumber;
            [cell.contentView addSubview:menuswitch];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else if (indexPath.section==4){
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_4 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Student Profile"],[MyClass returntitlewithtitle:@"Lead Profile"],nil]];
            menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-230-20, 5, 230, 30);
            [menusegmentcontrol addTarget:self action:@selector(updateeenrollmentformdest:) forControlEvents: UIControlEventValueChanged];
            menusegmentcontrol.selectedSegmentIndex=[globalvariables.centerrecord.eenrollmentformdest isEqualToString:@"student"]?0:1;
            menusegmentcontrol.tintColor=themecolor;
            [cell.contentView addSubview:menusegmentcontrol];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else if (indexPath.section==5){
            
            if(indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_5 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatesecondaryinstructor:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.secondaryinstructor;
                //            menuswitch.enabled=NO;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==1){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_5 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateusereserveddayduringenrollment:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.usereserveddayduringenrollment;
                //            menuswitch.enabled=NO;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==2){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_5 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatemarkenrollmentreserveddaytomakeup:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.markenrollmentreserveddaytomakeup;
                //            menuswitch.enabled=NO;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==3){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_5 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatecloneenrollmentcopydiscountdefault:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.cloneenrollmentcopydiscountdefault;
    //            menuswitch.enabled=NO;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==4){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[enrollment_parameters_5 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateremovecouponifnotpaidbeforeexpiry:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.removecouponifnotpaidbeforeexpiry;
    //            menuswitch.enabled=NO;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
        }
        
    }else if (tableView==membershiptable){
        MyTableViewCell *cellView;
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                static NSString *CellIdentifier = @"labelswitchcell";
                cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cellView == nil) {
                    cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cellView.label1.text=[MyClass returntitlewithtitle:[membership_parameters_0 objectAtIndex:indexPath.row]];
                cellView.switch1.onTintColor=themecolor;
                cellView.switch1.on=globalvariables.centerrecord.enablemembershippoint;
                [cellView.switch1 addTarget:self action:@selector(updateenablemembershippoint:) forControlEvents:UIControlEventValueChanged];
                

            }else if(indexPath.row==1){
                static NSString *CellIdentifier = @"labeltextcell";
                cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cellView == nil) {
                    cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cellView.label1.text=[MyClass returntitlewithtitle:[membership_parameters_0 objectAtIndex:indexPath.row]];
                cellView.textfield1.text=globalvariables.centerrecord.defaultpointexpirydays;
                cellView.textfield1.placeholder=[MyClass returntitlewithtitle:@"Never"];
                cellView.textfield1.borderStyle = UITextBorderStyleRoundedRect;
                [cellView.textfield1 addTarget:self action:@selector(editdefaultpointexpirydays:) forControlEvents:UIControlEventEditingChanged];
                [cellView.textfield1 addTarget:self action:@selector(editdefaultpointexpirydaysdidend:) forControlEvents:UIControlEventEditingDidEnd];
                

            }else if(indexPath.row==2){
                static NSString *CellIdentifier = @"labelswitchcell";
                cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cellView == nil) {
                    cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cellView.label1.text=[MyClass returntitlewithtitle:[membership_parameters_0 objectAtIndex:indexPath.row]];
                cellView.switch1.onTintColor=themecolor;
                cellView.switch1.on=globalvariables.centerrecord.addpointwithactiveparentapp;
                [cellView.switch1 addTarget:self action:@selector(updateaddpointwithactiveparentapp:) forControlEvents:UIControlEventValueChanged];
                

            }else if (indexPath.row==3){
                static NSString *CellIdentifier = @"labelswitchcell";
                cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cellView == nil) {
                    cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cellView.label1.text=[MyClass returntitlewithtitle:[membership_parameters_0 objectAtIndex:indexPath.row]];
                cellView.switch1.onTintColor=themecolor;
                cellView.switch1.on=globalvariables.centerrecord.addpointforonlinepaymentonly;
                [cellView.switch1 addTarget:self action:@selector(updateaddpointforonlinepaymentonly:) forControlEvents:UIControlEventValueChanged];
                

            }else if (indexPath.row==4){
                static NSString *CellIdentifier = @"labelswitchcell";
                cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cellView == nil) {
                    cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cellView.label1.text=[MyClass returntitlewithtitle:[membership_parameters_0 objectAtIndex:indexPath.row]];
                cellView.switch1.onTintColor=themecolor;
                cellView.switch1.on=globalvariables.centerrecord.addpointforontimepaymentonly;
                [cellView.switch1 addTarget:self action:@selector(updateaddpointforontimepaymentonly:) forControlEvents:UIControlEventValueChanged];
                
            }else{
                static NSString *CellIdentifier = @"labelswitchcell";
                cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cellView == nil) {
                    cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cellView.label1.text=[MyClass returntitlewithtitle:[membership_parameters_0 objectAtIndex:indexPath.row]];
                cellView.switch1.onTintColor=themecolor;
                cellView.switch1.on=globalvariables.centerrecord.transferpointforinternaltransferpayment;
                [cellView.switch1 addTarget:self action:@selector(updatetransferpointforinternaltransferpayment:) forControlEvents:UIControlEventValueChanged];
                
            }
            
        }else if (indexPath.section==1){
            if(indexPath.row==0){
                static NSString *CellIdentifier = @"labeltextcell";
                cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cellView == nil) {
                    cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cellView.label1.text=[MyClass returntitlewithtitle:[membership_parameters_1 objectAtIndex:indexPath.row]];
                cellView.textfield1.text=globalvariables.centerrecord.spendingtopointratio;
                cellView.textfield1.placeholder=[MyClass returntitlewithtitle:@""];
                cellView.textfield1.borderStyle = UITextBorderStyleRoundedRect;
                [cellView.textfield1 addTarget:self action:@selector(editspendingtopointratio:) forControlEvents:UIControlEventEditingChanged];
                [cellView.textfield1 addTarget:self action:@selector(editspendingtopointratio_editingend:) forControlEvents:UIControlEventEditingDidEnd];
                
            }else if(indexPath.row==1){
                static NSString *CellIdentifier = @"labeltextcell";
                cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cellView == nil) {
                    cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cellView.label1.text=[MyClass returntitlewithtitle:[membership_parameters_1 objectAtIndex:indexPath.row]];
                cellView.textfield1.text=globalvariables.centerrecord.spendingtopointratio_sales;
                cellView.textfield1.placeholder=[MyClass returntitlewithtitle:@""];
                cellView.textfield1.borderStyle = UITextBorderStyleRoundedRect;
                [cellView.textfield1 addTarget:self action:@selector(editspendingtopointratio_sales:) forControlEvents:UIControlEventEditingChanged];
                [cellView.textfield1 addTarget:self action:@selector(editspendingtopointratio_sales_editingend:) forControlEvents:UIControlEventEditingDidEnd];
            }else if (indexPath.row==2){
                static NSString *CellIdentifier = @"labeltextcell";
                cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cellView == nil) {
                    cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cellView.label1.text=[MyClass returntitlewithtitle:[membership_parameters_1 objectAtIndex:indexPath.row]];
                cellView.textfield1.text=globalvariables.centerrecord.pointearn_qrcodecheckin;
                cellView.textfield1.placeholder=[MyClass returntitlewithtitle:@""];
                cellView.textfield1.borderStyle = UITextBorderStyleRoundedRect;
                [cellView.textfield1 addTarget:self action:@selector(editpointearn_qrcodecheckin:) forControlEvents:UIControlEventEditingChanged];
                [cellView.textfield1 addTarget:self action:@selector(editpointearn_qrcodecheckin_editingend:) forControlEvents:UIControlEventEditingDidEnd];
            }else{
                static NSString *CellIdentifier = @"labeltextcell";
                cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cellView == nil) {
                    cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cellView.label1.text=[MyClass returntitlewithtitle:[membership_parameters_1 objectAtIndex:indexPath.row]];
                cellView.textfield1.text=globalvariables.centerrecord.pointearn_selfmakeup;
                cellView.textfield1.placeholder=[MyClass returntitlewithtitle:@""];
                cellView.textfield1.borderStyle = UITextBorderStyleRoundedRect;
                [cellView.textfield1 addTarget:self action:@selector(editpointearn_selfmakeup:) forControlEvents:UIControlEventEditingChanged];
                [cellView.textfield1 addTarget:self action:@selector(editpointearn_selfmakeup_editingend:) forControlEvents:UIControlEventEditingDidEnd];
            }
        }else{
            if (indexPath.row==0) {
                static NSString *CellIdentifier = @"labelswitchcell";
                cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cellView == nil) {
                    cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cellView.label1.text=[MyClass returntitlewithtitle:@"Enable Membership Tier"];
                cellView.switch1.onTintColor=themecolor;
                cellView.switch1.on=globalvariables.centerrecord.enablemembershiptier;
                [cellView.switch1 addTarget:self action:@selector(updateenablemembershiptier:) forControlEvents:UIControlEventValueChanged];
            }else if (indexPath.row==1){
                static NSString *CellIdentifier = @"labeltextcell";
                cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cellView == nil) {
                    cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                cellView.label1.text=[MyClass returntitlewithtitle:@"Past Number of Day for the Cumulative Spending"];
                cellView.textfield1.text=[@(globalvariables.centerrecord.tierspendinginterval) stringValue];
                cellView.textfield1.placeholder=[MyClass returntitlewithtitle:@""];
                cellView.textfield1.borderStyle = UITextBorderStyleRoundedRect;
                [cellView.textfield1 addTarget:self action:@selector(edittierspendinginterval:) forControlEvents:UIControlEventEditingChanged];
                [cellView.textfield1 addTarget:self action:@selector(edittierspendinginterval_editingend:) forControlEvents:UIControlEventEditingDidEnd];
            }else{
                static NSString *CellIdentifier = @"tiercell";
                cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cellView == nil) {
                    cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                
                NSInteger membershiprecordindex=indexPath.row-2;
                MembershipTierRecord *record=[membershiptierarray objectAtIndex:membershiprecordindex];
                
                cellView.label1.text=[MyClass returnreplacedtitlewithtitle:@"Tier#%@1" replacementarray:@[[@(membershiprecordindex+1) stringValue]]];
                cellView.label2.text=[MyClass returntitlewithtitle:@"Title in English"];
                cellView.label3.text=[MyClass returntitlewithtitle:@"Title in Chinese"];
                cellView.label4.text=[MyClass returntitlewithtitle:@"Spending Required"];
                cellView.label5.text=[MyClass returntitlewithtitle:@"Point Multiplier"];
                cellView.label6.text=[MyClass returntitlewithtitle:@"Birthday Gift Point"];
                
                cellView.textfield1.text=record.title;
                cellView.textfield2.text=record.title_chinese;
                cellView.textfield3.text=record.requirement;
                cellView.textfield4.text=record.pointmultiplier;
                cellView.textfield5.text=record.birthdaypoint;
                [MyClass downloadImageWithImageview:cellView.imageview1 gender:@"" type:@"tierimage" typekey:record.image image:@"Yes" async:YES];
                
                cellView.button1.tag=membershiprecordindex;
                cellView.button5.tag=membershiprecordindex;
                cellView.button6.tag=membershiprecordindex;
                
                cellView.textfield1.tag=100*0+membershiprecordindex;
                cellView.textfield2.tag=100*1+membershiprecordindex;
                cellView.textfield3.tag=100*2+membershiprecordindex;
                cellView.textfield4.tag=100*3+membershiprecordindex;
                cellView.textfield5.tag=100*4+membershiprecordindex;
                
                [cellView.textfield1 addTarget:self action:@selector(edittierinformation:) forControlEvents:UIControlEventEditingChanged];
                [cellView.textfield1 addTarget:self action:@selector(edittierinformation_editingend:)forControlEvents:UIControlEventEditingDidEnd];
                [cellView.textfield2 addTarget:self action:@selector(edittierinformation:) forControlEvents:UIControlEventEditingChanged];
                [cellView.textfield2 addTarget:self action:@selector(edittierinformation_editingend:)forControlEvents:UIControlEventEditingDidEnd];
                [cellView.textfield3 addTarget:self action:@selector(edittierinformation:) forControlEvents:UIControlEventEditingChanged];
                [cellView.textfield3 addTarget:self action:@selector(edittierinformation_editingend:)forControlEvents:UIControlEventEditingDidEnd];
                [cellView.textfield4 addTarget:self action:@selector(edittierinformation:) forControlEvents:UIControlEventEditingChanged];
                [cellView.textfield4 addTarget:self action:@selector(edittierinformation_editingend:)forControlEvents:UIControlEventEditingDidEnd];
                [cellView.textfield5 addTarget:self action:@selector(edittierinformation:) forControlEvents:UIControlEventEditingChanged];
                [cellView.textfield5 addTarget:self action:@selector(edittierinformation_editingend:)forControlEvents:UIControlEventEditingDidEnd];
                
                [cellView.button1 addTarget:self action:@selector(updateTierImage:) forControlEvents:UIControlEventTouchUpInside];
                [cellView.button5 addTarget:self action:@selector(deleteMembershipTier:) forControlEvents:UIControlEventTouchUpInside];
                [cellView.button6 addTarget:self action:@selector(addMembershipTier:) forControlEvents:UIControlEventTouchUpInside];

                [cellView.button5 setTitle:[MyClass returntitlewithtitle:@"Delete"] forState:UIControlStateNormal];
                [cellView.button6 setTitle:[MyClass returntitlewithtitle:@"New"] forState:UIControlStateNormal];

                cellView.button5.hidden=membershiptierarray.count==1;
                
                
            }
        }
        return cellView;
    }else if (tableView==coursetable){
        
        UILabel *menulabel;
        UISwitch *menuswitch;
//        UITextField *menutext;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[course_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatedefaultcsshowintimetableifnoenrollment:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.defaultcsshowintimetableifnoenrollment;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==1){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[course_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatedefaultcsmakeupschedule:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.defaultcsmakeupschedule;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
        }
    }else if (tableView==chatbottable){
        
        UILabel *menulabel;
        UISwitch *menuswitch;
        UITextField *menutext;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[chatbot_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateenablechatbot:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.enablechatbot;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==1){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[chatbot_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.maxdayrangefortrialclass==-1?@"":[@(globalvariables.centerrecord.maxdayrangefortrialclass) stringValue];
                menutext.placeholder=[MyClass returntitlewithtitle:@"<365"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editmaxdayrangefortrialclass:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editmaxdayrangefortrialclass_editingend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==2){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[chatbot_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[@(globalvariables.centerrecord.trialdelayhour) stringValue];
                menutext.placeholder=[MyClass returntitlewithtitle:@""];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(edittrialdelayhour:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }else if (tableView==istafftable){
        
        UILabel *menulabel;
        UISwitch *menuswitch;
        UITextField *menutext;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[istaff_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateenableistafftakingattendance:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.enableistafftakingattendance;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[istaff_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[@(globalvariables.centerrecord.noofpastdayincludedinistaffmystudentclass) stringValue];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editnoofpastdayincludedinistaffmystudentclass:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editnoofpastdayincludedinistaffmystudentclass_editingend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

        }
    }else if (tableView==useraccounttable){
        
        UILabel *menulabel;
        UITextField *menutext;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {

                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[useraccount_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.staffpasswordexpirationday;
                menutext.placeholder=[MyClass returntitlewithtitle:@"Unlimited"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editstaffpasswordexpirationday:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editstaffpasswordexpirationdaydidend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

        }
    }else if (tableView==iparenttable){
        
        UILabel *menulabel;
        UISwitch *menuswitch;
        UISegmentedControl *menusegmentcontrol;
        UITextField *menutext;
        UIImageView *imageview;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_0 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            menuswitch = [[UISwitch alloc] init];
            CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
            menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
            menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            menuswitch.tag = 501;
            menuswitch.onTintColor=themecolor;
            [menuswitch addTarget:self action:@selector(updatesendparentappinvitesms:) forControlEvents:UIControlEventValueChanged];
            menuswitch.on=globalvariables.centerrecord.sendparentappinvitesms;
            [cell.contentView addSubview:menuswitch];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.section==1) {
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_1 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            menuswitch = [[UISwitch alloc] init];
            CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
            menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
            menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            menuswitch.tag = 501;
            menuswitch.onTintColor=themecolor;
            [menuswitch addTarget:self action:@selector(updateiparentusercanupdatepersonalinformation:) forControlEvents:UIControlEventValueChanged];
            menuswitch.on=globalvariables.centerrecord.iparentusercanupdatepersonalinformation;
            [cell.contentView addSubview:menuswitch];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.section==2){
            if(indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateiparentshowenrollmenttuitionfee:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.iparentshowenrollmenttuitionfee;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==1){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateiparentshowonlynondroppedenrollment:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.iparentshowonlynondroppedenrollment;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==2){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateiparentshowclassroom:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.iparentshowclassroom;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==3){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateiparentshowclassendtime:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.iparentshowclassendtime;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==4){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateiparentshowuserdefinedschedulename:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.iparentshowuserdefinedschedulename;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateiparentreturnrenewalremindernotifications:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.iparentreturnrenewalremindernotifications;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==3){
            if(indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_3 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[@(globalvariables.centerrecord.noofpastdayincludediniparentclassschedule) stringValue];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editnoofpastdayincludediniparentclassschedule:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editnoofpastdayincludediniparentclassschedule_editingend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_3 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateiparentclassalert:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.iparentclassalert;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

        }else if (indexPath.section==4){
            if (indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_4 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateexpiringclassreminder:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.expiringclassreminder;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==1){
                if(globalvariables.centerrecord.expiringclassreminder){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_4 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[@(globalvariables.centerrecord.firstreminderbeforeexpiry) stringValue];
                menutext.placeholder=[MyClass returntitlewithtitle:@"No. of day"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editfirstreminderbeforeexpiry:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editfirstreminderbeforeexpiry_editingend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
            }else{
                if(globalvariables.centerrecord.expiringclassreminder){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_4 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[@(globalvariables.centerrecord.expiringclassreminderrecursiveday) stringValue];
                menutext.placeholder=[MyClass returntitlewithtitle:@"No. of day"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editexpiringclassreminderrecursiveday:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editexpiringclassreminderrecursiveday_editingend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
            }

        }else if (indexPath.section==5){
            if(indexPath.row==0){

                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_5 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[@(globalvariables.centerrecord.couponexpiryfirstreminder) stringValue];
                menutext.placeholder=[MyClass returntitlewithtitle:@"No. of day"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editcouponexpiryfirstreminder:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editcouponexpiryfirstreminder_editingend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_5 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[@(globalvariables.centerrecord.couponexpiryrecursivereminder) stringValue];
                menutext.placeholder=[MyClass returntitlewithtitle:@"No. of day"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editcouponexpiryrecursivereminder:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editcouponexpiryrecursivereminder_editingend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

        }else if (indexPath.section==6){
            if(indexPath.row==0){

                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_6 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[@(globalvariables.centerrecord.pointexpiryfirstreminder) stringValue];
                menutext.placeholder=[MyClass returntitlewithtitle:@"No. of day"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editpointexpiryfirstreminder:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editpointexpiryfirstreminder_editingend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_6 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[@(globalvariables.centerrecord.pointexpiryrecursivereminder) stringValue];
                menutext.placeholder=[MyClass returntitlewithtitle:@"No. of day"];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editpointexpiryrecursivereminder:) forControlEvents:UIControlEventEditingChanged];
                [menutext addTarget:self action:@selector(editpointexpiryrecursivereminder_editingend:) forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }

        }else if (indexPath.section==7){
            if(indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_7 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"Disable"],[MyClass returntitlewithtitle:@"Request"],[MyClass returntitlewithtitle:@"Auto approve"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                [menusegmentcontrol addTarget:self action:@selector(switchiparentleavemode:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=[globalvariables.centerrecord.iparentleavemode isEqualToString:@"Disable"]?0:[globalvariables.centerrecord.iparentleavemode isEqualToString:@"Request"]?1:2;
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==1){
                if([globalvariables.centerrecord.iparentleavemode isEqualToString:@"Request"]){
                    menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                    menulabel.font=[UIFont systemFontOfSize:17];
                    menulabel.textColor=[UIColor blackColor];
                    menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_7 objectAtIndex:indexPath.row]];
                    menulabel.tag=301;
                    [cell.contentView addSubview:menulabel];
                    
                    menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"All"],[MyClass returntitlewithtitle:@"Center"],[MyClass returntitlewithtitle:@"Instructor"],nil]];
                    menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-300-20, 5, 300, 30);
                    [menusegmentcontrol addTarget:self action:@selector(switchleaveapprovalmode:) forControlEvents: UIControlEventValueChanged];
                    menusegmentcontrol.selectedSegmentIndex=[globalvariables.centerrecord.leaveapprovalmode isEqualToString:@"All"]?0:[globalvariables.centerrecord.leaveapprovalmode isEqualToString:@"Center"]?1:2;
                    menusegmentcontrol.tintColor=themecolor;
                    [cell.contentView addSubview:menusegmentcontrol];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                    cell.hidden=YES;
                }
                
            }else if(indexPath.row==2){
                if(![globalvariables.centerrecord.iparentleavemode isEqualToString:@"Disable"]){
                    menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                    menulabel.font=[UIFont systemFontOfSize:17];
                    menulabel.textColor=[UIColor blackColor];
                    menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_7 objectAtIndex:indexPath.row]];
                    menulabel.tag=301;
                    [cell.contentView addSubview:menulabel];
                    
                    menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                    menutext.font=[UIFont systemFontOfSize:15];
                    menutext.textColor=[UIColor darkGrayColor];
                    menutext.textAlignment=NSTextAlignmentRight;
                    menutext.text=globalvariables.centerrecord.mindaytoapplyleave==-1?@"":[@(globalvariables.centerrecord.mindaytoapplyleave) stringValue];
                    menutext.placeholder=[MyClass returntitlewithtitle:@"Unlimited"];
                    menutext.borderStyle = UITextBorderStyleRoundedRect;
                    [menutext addTarget:self action:@selector(editmindaytoapplyleave:) forControlEvents:UIControlEventEditingChanged];
                    [cell.contentView addSubview:menutext];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                    cell.hidden=YES;
                }

            }else if(indexPath.row==3){
                if(![globalvariables.centerrecord.iparentleavemode isEqualToString:@"Disable"]){
                    menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                    menulabel.font=[UIFont systemFontOfSize:17];
                    menulabel.textColor=[UIColor blackColor];
                    menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_7 objectAtIndex:indexPath.row]];
                    menulabel.tag=301;
                    [cell.contentView addSubview:menulabel];
                    
                    menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                    menutext.font=[UIFont systemFontOfSize:15];
                    menutext.textColor=[UIColor darkGrayColor];
                    menutext.textAlignment=NSTextAlignmentRight;
                    menutext.text=[@(globalvariables.centerrecord.makeupdelayhour) stringValue];
                    menutext.placeholder=[MyClass returntitlewithtitle:@""];
                    menutext.borderStyle = UITextBorderStyleRoundedRect;
                    [menutext addTarget:self action:@selector(editmakeupdelayhour:) forControlEvents:UIControlEventEditingChanged];
                    [cell.contentView addSubview:menutext];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                    cell.hidden=YES;
                }

            }

        }else if (indexPath.section==8){
            if(indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_8 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateiparentshowclassschedule:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.iparentshowclassschedule;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==1){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_8 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateiparentshowmessages:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.iparentshowmessages;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==2){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_8 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateiparentshowphotocorner:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.iparentshowphotocorner;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==3){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_8 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateiparentshowenrollmentrecords:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.iparentshowenrollmentrecords;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==4){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_8 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateiparentshowsalesrecords:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.iparentshowsalesrecords;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==9){
            if(indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_9 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateenableparentsendmessage:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.enableparentsendmessage;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if(indexPath.row==1){
                if (globalvariables.centerrecord.enablevoicemessage) {
                    menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                    menulabel.font=[UIFont systemFontOfSize:17];
                    menulabel.textColor=[UIColor blackColor];
                    menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_9 objectAtIndex:indexPath.row]];
                    menulabel.tag=301;
                    [cell.contentView addSubview:menulabel];
                    
                    menuswitch = [[UISwitch alloc] init];
                    CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                    menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                    menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    menuswitch.tag = 501;
                    menuswitch.onTintColor=themecolor;
                    [menuswitch addTarget:self action:@selector(updateenableparentsendvoicemessage:) forControlEvents:UIControlEventValueChanged];
                    menuswitch.on=globalvariables.centerrecord.enableparentsendvoicemessage;
                    [cell.contentView addSubview:menuswitch];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.hidden=NO;
                }else{
                    cell.hidden=YES;
                }
                
            }else if(indexPath.row==2){
                if (globalvariables.centerrecord.enablevideomessage) {
                    menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                    menulabel.font=[UIFont systemFontOfSize:17];
                    menulabel.textColor=[UIColor blackColor];
                    menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_9 objectAtIndex:indexPath.row]];
                    menulabel.tag=301;
                    [cell.contentView addSubview:menulabel];
                    
                    menuswitch = [[UISwitch alloc] init];
                    CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                    menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                    menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    menuswitch.tag = 501;
                    menuswitch.onTintColor=themecolor;
                    [menuswitch addTarget:self action:@selector(updateenableparentsendvideomessage:) forControlEvents:UIControlEventValueChanged];
                    menuswitch.on=globalvariables.centerrecord.enableparentsendvideomessage;
                    [cell.contentView addSubview:menuswitch];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.hidden=NO;
                }else{
                    cell.hidden=YES;
                }
            }
        }else if (indexPath.section==10){
            if(indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[iparent_parameters_10 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                imageview = [[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width-40-20, (40-24)/2, 40, 24)];
                imageview.backgroundColor=[self returnappcolorschememaincolor];
                imageview.layer.masksToBounds=YES;
                imageview.layer.cornerRadius=5;
                [cell.contentView addSubview:imageview];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }else if (tableView==photocornertable){
        
        UILabel *menulabel;
        UISwitch *menuswitch;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[photocorner_parameters_0 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            menuswitch = [[UISwitch alloc] init];
            CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
            menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
            menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            menuswitch.tag = 501;
            menuswitch.onTintColor=themecolor;
            [menuswitch addTarget:self action:@selector(enablephotoalert:) forControlEvents:UIControlEventValueChanged];
            menuswitch.on=((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).photoalert;
            [cell.contentView addSubview:menuswitch];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if (tableView==financialtable){
        
        UILabel *menulabel;
        UITextField *menutext;
        UISwitch *menuswitch;
        UIImageView *menuimage;
        UISegmentedControl *menusegmentcontrol;
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        if (indexPath.section==0) {
            if (indexPath.row==0) {
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menusegmentcontrol = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:[MyClass returntitlewithtitle:@"0"],[MyClass returntitlewithtitle:@"1"],nil]];
                menusegmentcontrol.frame = CGRectMake(tableView.frame.size.width-230-20, 5, 230, 30);
                [menusegmentcontrol addTarget:self action:@selector(updatenoofroundoffdigit:) forControlEvents: UIControlEventValueChanged];
                menusegmentcontrol.selectedSegmentIndex=globalvariables.centerrecord.noofroundoffdigit;
                menusegmentcontrol.tintColor=themecolor;
                [cell.contentView addSubview:menusegmentcontrol];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==1){
            if (indexPath.row==0) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_1 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-120-20, 5, 120, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[NSString stringWithFormat:@"%i",globalvariables.centerrecord.monthlymodeweeklyscheduletuitiondenominator];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(updatemonthlymodeweeklyscheduletuitiondenominator:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
        }else if (indexPath.section==2){
            if (indexPath.row==0) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-120-20, 5, 120, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.enrollmentfee;
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(updateenrollmentfee:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateautoenrollmentfeeforfirstenrollment:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.autoenrollmentfeeforfirstenrollment;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==2){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_2 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-120-20, 5, 120, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[@(globalvariables.centerrecord.waiveenrollmentfeeminmonth) stringValue];
                menutext.placeholder=[MyClass returntitlewithtitle:@""];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editwaiveenrollmentfeeminmonth:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==3){
            if (indexPath.row==0) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_3 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatelatefee_enable:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=[globalvariables.centerrecord.latefee_enable isEqualToString:@"Yes"]?YES:NO;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_3 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-120-20, 5, 120, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.latefee;
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(updatelatefee:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else if (indexPath.row==2){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_3 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-120-20, 5, 120, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.latefeegraceperiod;
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(updatelatefeegraceperiod:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==4){
            if (indexPath.row==0) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_4 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-440-20, 5, 440, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.chequepayable;
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(updatechequepayable:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
        }else if (indexPath.section==5){
            if(indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_5 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(enableddaenabled:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.ddaenabled;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else if (indexPath.section==6){
            if (indexPath.row==0) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_6 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatedefaultreceiptremarksasinvoiceremarksforcourseenrollment:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.defaultreceiptremarksasinvoiceremarksforcourseenrollment;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_6 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatedefaultreceiptremarksasinvoiceremarksforproductsales:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.defaultreceiptremarksasinvoiceremarksforproductsales;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
        }else if (indexPath.section==8){
            if (indexPath.row==0) {
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_8 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(enableaccountreceivablecodes:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.enableaccountreceivablecodes;
//                menuswitch.enabled=arcodearray.count>0;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=((ARCodeRecord *)[arcodearray objectAtIndex:indexPath.row-1]).arcode;
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuimage=[[UIImageView alloc]initWithFrame:CGRectMake(tableView.frame.size.width-26-20, 7, 26, 26)];
                //menuimage.layer.cornerRadius=5;
                //menuimage.layer.masksToBounds=YES;
                [menuimage setImage:[UIImage imageNamed:@"checked_icon.png"]];
                //menuimage.layer.borderColor=[UIColor grayColor].CGColor;
                //menuimage.layer.borderWidth=.6;

                if([((ARCodeRecord *)[arcodearray objectAtIndex:indexPath.row-1]).arckey isEqualToString:[MyClass returndefaultarckey]]){
                    menuimage.layer.opacity=1;
                }else{
                    menuimage.layer.opacity=0.3;
                }
                
                
                [cell.contentView addSubview:menuimage];
            }
        }else if (indexPath.section==7){
            if (indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[financial_parameters_7 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateremoveunpaidandexpiredpromotion:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.removeunpaidandexpiredpromotion;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }else if (tableView==studentprofiletable){
        
        if (indexPath.section==0) {
            UILabel *menulabel;
            UISwitch *menuswitch;
            UITextField *menutext;
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            if (indexPath.row==0){
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[studentprofile_section_0 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 501;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateautofillstudentid:) forControlEvents:UIControlEventValueChanged];
                menuswitch.on=globalvariables.centerrecord.autofillstudentid;
                [cell.contentView addSubview:menuswitch];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }else{
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:@"Prefix"];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-120-20, 5, 120, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=globalvariables.centerrecord.sidprefix;
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(updatesidprefix:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
            }
        }else if (indexPath.section==1) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"section_1_cell"];
            
            UILabel *menulabel;
            UISwitch *menuswitch;
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section_1_cell"];
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.tag=1301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 1302;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updatestudentnamedisplayorder:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:menuswitch];
                
            }else{
                menulabel=(UILabel *)[cell.contentView viewWithTag:1301];
                menuswitch=(UISwitch *)[cell.contentView viewWithTag:1302];
            }
            
            menulabel.text=[MyClass returntitlewithtitle:[self returnsortinglabelwithitem:((SortingRecord *)[studentprofile_section_1 objectAtIndex:indexPath.row]).item]];
            menuswitch.on=[((SortingRecord *)[studentprofile_section_1 objectAtIndex:indexPath.row]).order isEqualToString:@"e"]?YES:NO;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.section==2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"section_2_cell"];
            
            UILabel *menulabel;
            UISwitch *menuswitch;
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section_2_cell"];
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.tag=1301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 1302;
                menuswitch.onTintColor=themecolor;
                [cell.contentView addSubview:menuswitch];
                
            }else{
                menulabel=(UILabel *)[cell.contentView viewWithTag:1301];
                menuswitch=(UISwitch *)[cell.contentView viewWithTag:1302];
            }
            
            menulabel.text=[MyClass returntitlewithtitle:[studentprofile_section_2 objectAtIndex:indexPath.row]];

            [menuswitch removeTarget:self action:NULL forControlEvents:UIControlEventAllEvents];
            if (indexPath.row==0){
                menuswitch.on=globalvariables.centerrecord.studentpromotiondefault;
                [menuswitch addTarget:self action:@selector(updatestudentpromotiondefault:) forControlEvents:UIControlEventValueChanged];
            }else if (indexPath.row==1) {
                menuswitch.on=globalvariables.centerrecord.studentsendmessagedefault;
                [menuswitch addTarget:self action:@selector(updatestudentsendmessagedefault:) forControlEvents:UIControlEventValueChanged];
            }else if (indexPath.row==2) {
                menuswitch.on=globalvariables.centerrecord.parentappdefault;
                [menuswitch addTarget:self action:@selector(updateparentappdefault:) forControlEvents:UIControlEventValueChanged];
            }else if (indexPath.row==3) {
                menuswitch.on=globalvariables.centerrecord.smsdefault;
                [menuswitch addTarget:self action:@selector(updatesmsdefault:) forControlEvents:UIControlEventValueChanged];
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.section==3){
            cell = [tableView dequeueReusableCellWithIdentifier:@"section_4_cell"];
            
            UILabel *menulabel;
            UIButton *menubutton;
            UISwitch *menuswitch;
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section_4_cell"];
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[studentprofile_section_3 objectAtIndex:indexPath.row]];
                menulabel.tag=1301;
                [cell.contentView addSubview:menulabel];
                
                menubutton=[[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 4, 100, 32)];
                [menubutton addTarget:self action:@selector(promotestudentschoolgradebuttonpressed) forControlEvents:UIControlEventTouchUpInside];
                
                [menubutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                menubutton.titleLabel.font=[UIFont systemFontOfSize:15];
                menubutton.layer.cornerRadius=5;
                [menubutton setBackgroundColor:themecolor];
                menubutton.tag = 1302;
                
                
                
                [cell.contentView addSubview:menubutton];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                [menuswitch addTarget:self action:@selector(updaterecalculatetuitionfeeupongradepromotion:) forControlEvents:UIControlEventValueChanged];
                menuswitch.tag = 1303;
                menuswitch.onTintColor=themecolor;
                
                [cell.contentView addSubview:menuswitch];
                
            }else{
                menulabel=(UILabel *)[cell.contentView viewWithTag:1301];
                menubutton=(UIButton *)[cell.contentView viewWithTag:1302];
                menuswitch=(UISwitch *)[cell.contentView viewWithTag:1303];
            }
            
            [menubutton setTitle:[MyClass returntitlewithtitle:@"Promote"] forState:UIControlStateNormal];
            menulabel.text=[MyClass returntitlewithtitle:[studentprofile_section_3 objectAtIndex:indexPath.row]];
            menuswitch.on=[[MyClass getlocaldbwithparameter:@"recalculatetuitionfeeupongradepromotion"] isEqualToString:@"Yes"];
            
            if (indexPath.row==0) {
                menubutton.hidden=NO;
                menuswitch.hidden=YES;
                if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).promotestudentgrade) {
                    menubutton.enabled=YES;
                    menubutton.backgroundColor=themecolor;
                }else{
                    menubutton.enabled=NO;
                    menubutton.backgroundColor=[UIColor lightGrayColor];
                }
            }else{
                menubutton.hidden=YES;
                menuswitch.hidden=NO;
            }
            
            
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }/*else if (indexPath.section==4){
            cell = [tableView dequeueReusableCellWithIdentifier:@"section_3_cell"];
            
            UILabel *menulabel;
            UISwitch *menuswitch;
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section_3_cell"];
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.tag=1301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 1302;
                menuswitch.onTintColor=themecolor;
                [cell.contentView addSubview:menuswitch];
                
            }else{
                menulabel=(UILabel *)[cell.contentView viewWithTag:1301];
                menuswitch=(UISwitch *)[cell.contentView viewWithTag:1302];
            }
            
            menulabel.text=[MyClass returntitlewithtitle:[studentprofile_section_4 objectAtIndex:indexPath.row]];
            
            if (indexPath.row==0){
                menuswitch.on=globalvariables.centerrecord.studentassessmentform;
                [menuswitch addTarget:self action:@selector(updatestudentassessmentform:) forControlEvents:UIControlEventValueChanged];
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }*/else if (indexPath.section==4){
            if(indexPath.row==0){
                cell = [tableView dequeueReusableCellWithIdentifier:@"section_3_cell"];
                
                UILabel *menulabel;
                UISwitch *menuswitch;
                
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section_3_cell"];
                    
                    menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                    menulabel.font=[UIFont systemFontOfSize:17];
                    menulabel.textColor=[UIColor blackColor];
                    menulabel.tag=1301;
                    [cell.contentView addSubview:menulabel];
                    
                    menuswitch = [[UISwitch alloc] init];
                    CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                    menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                    menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                    menuswitch.tag = 1302;
                    menuswitch.onTintColor=themecolor;
                    [cell.contentView addSubview:menuswitch];
                    
                }else{
                    menulabel=(UILabel *)[cell.contentView viewWithTag:1301];
                    menuswitch=(UISwitch *)[cell.contentView viewWithTag:1302];
                }
                
                menulabel.text=[MyClass returntitlewithtitle:[studentprofile_section_4 objectAtIndex:indexPath.row]];
                
                if (indexPath.row==0){
                    menuswitch.on=globalvariables.centerrecord.studentextrafield1;
                    [menuswitch addTarget:self action:@selector(updatestudentextrafield1:) forControlEvents:UIControlEventValueChanged];
                }
            }else if (indexPath.row==1){
                UILabel *menulabel;
                UITextField *menutext;
                
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.text=[MyClass returntitlewithtitle:[studentprofile_section_4 objectAtIndex:indexPath.row]];
                menulabel.tag=301;
                [cell.contentView addSubview:menulabel];
                
                menutext = [[UITextField alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100-20, 5, 100, 30)];
                menutext.font=[UIFont systemFontOfSize:15];
                menutext.textColor=[UIColor darkGrayColor];
                menutext.textAlignment=NSTextAlignmentRight;
                menutext.text=[@(globalvariables.centerrecord.minstudentcontact) stringValue];
                menutext.placeholder=[MyClass returntitlewithtitle:@""];
                menutext.borderStyle = UITextBorderStyleRoundedRect;
                [menutext addTarget:self action:@selector(editminstudentcontact:) forControlEvents:UIControlEventEditingChanged];
                [cell.contentView addSubview:menutext];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if (tableView==leadprofiletable){

        if (indexPath.section==0) {
            
            UILabel *menulabel;
            UISwitch *menuswitch;
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section_0_cell"];
            
            menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
            menulabel.font=[UIFont systemFontOfSize:17];
            menulabel.textColor=[UIColor blackColor];
            menulabel.text=[MyClass returntitlewithtitle:[leadprofile_section_0 objectAtIndex:indexPath.row]];
            menulabel.tag=301;
            [cell.contentView addSubview:menulabel];
            
            menuswitch = [[UISwitch alloc] init];
            CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
            menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
            menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            menuswitch.tag = 501;
            menuswitch.onTintColor=themecolor;
            [menuswitch addTarget:self action:@selector(updateautofillleadid:) forControlEvents:UIControlEventValueChanged];
            menuswitch.on=globalvariables.centerrecord.autofillleadid;
            [cell.contentView addSubview:menuswitch];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.section==1) {
            
            cell = [tableView dequeueReusableCellWithIdentifier:@"section_1_cell"];
            
            UILabel *menulabel;
            UISwitch *menuswitch;
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section_1_cell"];
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.tag=1301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 1302;
                menuswitch.onTintColor=themecolor;
                [menuswitch addTarget:self action:@selector(updateleadnamedisplayorder:) forControlEvents:UIControlEventValueChanged];
                [cell.contentView addSubview:menuswitch];
                
            }else{
                menulabel=(UILabel *)[cell.contentView viewWithTag:1301];
                menuswitch=(UISwitch *)[cell.contentView viewWithTag:1302];
            }
            
            menulabel.text=[MyClass returntitlewithtitle:[self returnsortinglabelwithitem:((SortingRecord *)[leadprofile_section_1 objectAtIndex:indexPath.row]).item]];
            menuswitch.on=[((SortingRecord *)[leadprofile_section_1 objectAtIndex:indexPath.row]).order isEqualToString:@"e"]?YES:NO;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.section==2){
            cell = [tableView dequeueReusableCellWithIdentifier:@"section_2_cell"];
            
            UILabel *menulabel;
            UISwitch *menuswitch;
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"section_2_cell"];
                
                menulabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, tableView.frame.size.width-40, 40)];
                menulabel.font=[UIFont systemFontOfSize:17];
                menulabel.textColor=[UIColor blackColor];
                menulabel.tag=1301;
                [cell.contentView addSubview:menulabel];
                
                menuswitch = [[UISwitch alloc] init];
                CGSize switchSize = [menuswitch sizeThatFits:CGSizeZero];
                menuswitch.frame = CGRectMake(253.0f,4.0f,switchSize.width,switchSize.height);
                menuswitch.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                menuswitch.tag = 1302;
                menuswitch.onTintColor=themecolor;
                [cell.contentView addSubview:menuswitch];
                
            }else{
                menulabel=(UILabel *)[cell.contentView viewWithTag:1301];
                menuswitch=(UISwitch *)[cell.contentView viewWithTag:1302];
            }
            
            menulabel.text=[MyClass returntitlewithtitle:[leadprofile_section_2 objectAtIndex:indexPath.row]];
            
            if (indexPath.row==0) {
                menuswitch.on=globalvariables.centerrecord.leadpromotiondefault;
                [menuswitch addTarget:self action:@selector(updateleadpromotiondefault:) forControlEvents:UIControlEventValueChanged];
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    }else if (tableView==settingstable){
        MyTableViewCell *cellView;
        
        if ([[settingsRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"sxn_Empty"]) {
            static NSString *CellIdentifier = @"blankCell";
            cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cellView == nil) {
                cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
        }else if ([[settingsRowDataArray objectAtIndex:indexPath.row] isEqualToString:@"Auto Notification Settings"]){
            static NSString *CellIdentifier = @"autoNotificationSettingsCell";
            cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cellView == nil) {
                cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            
            AutoNotificationSettingsRecord *record=[selectedansettingsarray objectAtIndex:indexPath.row];
            if (record) {
                
                cellView.switch1.onTintColor=themecolor;
                cellView.segmentedcontrol1.tintColor=themecolor;
                cellView.segmentedcontrol2.tintColor=themecolor;
                
                cellView.switch1.tag=indexPath.row;
                cellView.button2.tag=indexPath.row;
                cellView.button3.tag=indexPath.row;
                cellView.button4.tag=indexPath.row;
                cellView.button5.tag=indexPath.row;
                cellView.button6.tag=indexPath.row;
                cellView.textview1.tag=selectedantype*10000+100*0+indexPath.row;
                cellView.textview2.tag=selectedantype*10000+100*1+indexPath.row;
                
                [cellView.switch1 addTarget:self action:@selector(updateAutoNotificationEnable:) forControlEvents:UIControlEventValueChanged];
                [cellView.button2 addTarget:self action:@selector(updateAutoNotificationDayBeforeEvent:) forControlEvents:UIControlEventTouchUpInside];
                [cellView.button3 addTarget:self action:@selector(updateAutoNotificationRepeatDay:) forControlEvents:UIControlEventTouchUpInside];
                [cellView.button4 addTarget:self action:@selector(updateAutoNotificationScheduleTime:) forControlEvents:UIControlEventTouchUpInside];
                [cellView.button5 addTarget:self action:@selector(deleteAutoNotification:) forControlEvents:UIControlEventTouchUpInside];
                [cellView.button6 addTarget:self action:@selector(addAutoNotification:) forControlEvents:UIControlEventTouchUpInside];
                
                [cellView.button5 setTitle:[MyClass returntitlewithtitle:@"Delete"] forState:UIControlStateNormal];
                [cellView.button6 setTitle:[MyClass returntitlewithtitle:@"New"] forState:UIControlStateNormal];
                cellView.label10.text=[MyClass returntitlewithtitle:@"Enable"];
                
                if ((selectedantype==0 && !record.paymentreminder) || selectedantype==1) {
                    cellView.stackview1.hidden=NO;
                }else{
                    cellView.stackview1.hidden=YES;
                }
                cellView.button5.hidden=selectedansettingsarray.count==1;
                cellView.segmentedcontrol2.hidden=selectedantype!=0;
                
                cellView.switch1.on=record.enable;
                
                
                
                cellView.textview1.text=record.message_en;
                cellView.textview2.text=record.message_zh;
                
                [cellView.button2 setTitle:[self returndaytitlewithday:record.day_before_event] forState:UIControlStateNormal];
                [cellView.button3 setTitle:[self returndaytitlewithday:record.repeat_day] forState:UIControlStateNormal];
                [cellView.button4 setTitle:[NSString stringWithFormat:@"%@:00", record.schedule_time] forState:UIControlStateNormal];

                
                cellView.segmentedcontrol1.tag=indexPath.row;
                [cellView.segmentedcontrol1 setTitle:@"App/SMS" forSegmentAtIndex:0];
                [cellView.segmentedcontrol1 setTitle:@"App" forSegmentAtIndex:1];
                [cellView.segmentedcontrol1 setTitle:@"SMS" forSegmentAtIndex:2];
                [cellView.segmentedcontrol1 addTarget:self action:@selector(selectAutoNotificationChannel:) forControlEvents:UIControlEventValueChanged];
                cellView.segmentedcontrol1.selectedSegmentIndex=[MyClass returnChannelIndexWithRecipientType:@"Student" Channel:record.channel];
                
                cellView.segmentedcontrol2.tag=indexPath.row;
                [cellView.segmentedcontrol2 setTitle:[MyClass returntitlewithtitle:@"Reminder"] forSegmentAtIndex:0];
                [cellView.segmentedcontrol2 setTitle:[MyClass returntitlewithtitle:@"Overdue"] forSegmentAtIndex:1];
                [cellView.segmentedcontrol2 addTarget:self action:@selector(selectAutoNotificationPaymentType:) forControlEvents:UIControlEventValueChanged];
                cellView.segmentedcontrol2.selectedSegmentIndex=record.paymentreminder?0:1;
                
                
                cellView.label6.text=[MyClass returnreplacedtitlewithtitle:@"Notification#%@1" replacementarray:@[[NSString stringWithFormat:@"%ld",indexPath.row+1]]];
                
                cellView.label11.text=[MyClass returntitlewithtitle:@"!!firstname!! - Student firstname"];
                cellView.label12.text=[MyClass returntitlewithtitle:@"!!lastname!! - Student lastname"];
                cellView.label13.text=[MyClass returntitlewithtitle:@"!!subjectname!! - Subject name"];
                cellView.label14.text=[MyClass returntitlewithtitle:@"!!product_englishname!! - Product english name"];
                cellView.label15.text=[MyClass returntitlewithtitle:@"!!product_chinesename!! - Product chinese name"];
                cellView.label16.text=[MyClass returntitlewithtitle:@"!!os_fee!! - Outstanding fee"];
                cellView.label17.text=[MyClass returntitlewithtitle:@"!!finalclass!! - Last class date"];
                cellView.label18.text=[MyClass returntitlewithtitle:@"!!classtime!! - Class time"];
                cellView.label19.text=[MyClass returntitlewithtitle:@"!!dttime!! - Assessment/Trial time"];
                cellView.label20.text=[MyClass returntitlewithtitle:@"!!contactno!! - Contact number"];
                cellView.label21.text=[MyClass returntitlewithtitle:@"!!tuitionfee!! - Tuition fee"];
                
                if (selectedantype==0) {
                    cellView.label11.hidden=NO;
                    cellView.label12.hidden=YES;
                    cellView.label13.hidden=NO;
                    cellView.label14.hidden=YES;
                    cellView.label15.hidden=YES;
                    cellView.label16.hidden=NO;
                    cellView.label17.hidden=YES;
                    cellView.label18.hidden=YES;
                    cellView.label19.hidden=YES;
                    cellView.label20.hidden=NO;
                    cellView.label21.hidden=YES;
                }else if (selectedantype==1){
                    cellView.label11.hidden=NO;
                    cellView.label12.hidden=YES;
                    cellView.label13.hidden=YES;
                    cellView.label14.hidden=NO;
                    cellView.label15.hidden=YES;
                    cellView.label16.hidden=NO;
                    cellView.label17.hidden=YES;
                    cellView.label18.hidden=YES;
                    cellView.label19.hidden=YES;
                    cellView.label20.hidden=NO;
                    cellView.label21.hidden=YES;
                }else if (selectedantype==2){
                    cellView.label11.hidden=NO;
                    cellView.label12.hidden=YES;
                    cellView.label13.hidden=NO;
                    cellView.label14.hidden=YES;
                    cellView.label15.hidden=YES;
                    cellView.label16.hidden=YES;
                    cellView.label17.hidden=NO;
                    cellView.label18.hidden=YES;
                    cellView.label19.hidden=YES;
                    cellView.label20.hidden=NO;
                    cellView.label21.hidden=NO;
                }else if (selectedantype==3){
                    cellView.label11.hidden=NO;
                    cellView.label12.hidden=YES;
                    cellView.label13.hidden=NO;
                    cellView.label14.hidden=YES;
                    cellView.label15.hidden=YES;
                    cellView.label16.hidden=YES;
                    cellView.label17.hidden=YES;
                    cellView.label18.hidden=NO;
                    cellView.label19.hidden=YES;
                    cellView.label20.hidden=NO;
                    cellView.label21.hidden=YES;
                }else if (selectedantype==4){
                    cellView.label11.hidden=NO;
                    cellView.label12.hidden=YES;
                    cellView.label13.hidden=NO;
                    cellView.label14.hidden=YES;
                    cellView.label15.hidden=YES;
                    cellView.label16.hidden=YES;
                    cellView.label17.hidden=YES;
                    cellView.label18.hidden=YES;
                    cellView.label19.hidden=NO;
                    cellView.label20.hidden=NO;
                    cellView.label21.hidden=YES;
                }
                
                cellView.label8.text=[MyClass returntitlewithtitle:@"English"];
                cellView.label9.text=[MyClass returntitlewithtitle:@"Chinese"];
                
                if (selectedantype==0){
                    cellView.label1.text=record.paymentreminder?[MyClass returntitlewithtitle:@"Send prior to 1st class"]:[MyClass returntitlewithtitle:@"Send after 1st class"];
                }else if (selectedantype==1) {
                    cellView.label1.text=[MyClass returntitlewithtitle:@"Send after order"];
                }else if (selectedantype==2) {
                    cellView.label1.text=[MyClass returntitlewithtitle:@"Send prior to last class"];
                }else if (selectedantype==3) {
                    cellView.label1.text=[MyClass returntitlewithtitle:@"Send prior to 1st class"];
                }else if (selectedantype==4) {
                    cellView.label1.text=[MyClass returntitlewithtitle:@"Send prior to class"];
                }
                
                cellView.label2.text=[MyClass returntitlewithtitle:@"Resend frequency"];
                cellView.label3.text=[MyClass returntitlewithtitle:@"Send out time"];
                [cellView.button1 setTitle:[MyClass returntitlewithtitle:@"Enable"] forState:UIControlStateNormal];
            }

            
        }
        
        cellView.backgroundColor=[UIColor clearColor];
        cellView.selectionStyle=UITableViewCellSelectionStyleNone;
        return cellView;
        
        
        
    }else if (tableView==evaluationformtable){
        MyTableViewCell *cellView;
        if(indexPath.section==0){
            static NSString *CellIdentifier = @"labelswitchcell";
            cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cellView == nil) {
                cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cellView.label1.text=[MyClass returntitlewithtitle:[evaluationform_parameters_0 objectAtIndex:indexPath.row]];
            
            cellView.switch1.onTintColor=themecolor;
            cellView.switch1.on=globalvariables.centerrecord.studentassessmentform;
            [cellView.switch1 addTarget:self action:@selector(updatestudentassessmentform:) forControlEvents:UIControlEventValueChanged];
            
        }else if(indexPath.section==1){
            static NSString *CellIdentifier = @"labelswitchcell";
            cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cellView == nil) {
                cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cellView.label1.text=[MyClass returntitlewithtitle:[evaluationform_parameters_1 objectAtIndex:indexPath.row]];
            
            cellView.switch1.onTintColor=themecolor;
            cellView.switch1.on=globalvariables.centerrecord.showcenteraveragescore;
            [cellView.switch1 addTarget:self action:@selector(updateshowcenteraveragescore:) forControlEvents:UIControlEventValueChanged];
            
        }else{
            static NSString *CellIdentifier = @"labellabelcell";
            cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cellView == nil) {
                cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            AssessmentFormListObject *obj=[evaluationformlistarray objectAtIndex:indexPath.row];
            cellView.label1.text=obj.formname;
            
            cellView.switch1.onTintColor=themecolor;
            cellView.switch1.on=obj.active;
            cellView.switch1.tag=indexPath.row;
            [cellView.switch1 addTarget:self action:@selector(updateevaluationformactive:) forControlEvents:UIControlEventValueChanged];
            
            if(!obj.subjectarray){
                cellView.label2.text=[MyClass returntitlewithtitle:@"None"];
            }else if(obj.subjectarray.count==0){
                cellView.label2.text=[MyClass returntitlewithtitle:@"All Subjects"];
            }else{
                cellView.label2.text=[MyClass returnsubjectnamewithsubjectkeys:obj.subjectarray];
            }
            
            cellView.button1.tag=indexPath.row;
            [cellView.button1 addTarget:self action:@selector(showsubject:) forControlEvents:UIControlEventTouchUpInside];
            
            if(!obj.gradearray){
                cellView.label3.text=[MyClass returntitlewithtitle:@"None"];
            }else if(obj.gradearray.count==0){
                cellView.label3.text=[MyClass returntitlewithtitle:@"All Grades"];
            }else{
                cellView.label3.text=[obj.gradearray componentsJoinedByString:@" | "];
            }
            
            cellView.button2.tag=indexPath.row;
            [cellView.button2 addTarget:self action:@selector(showGrade:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        return cellView;
    }else if (tableView==centerqrcodetable){
        MyTableViewCell *cellView;
        if(indexPath.section==0){
            static NSString *CellIdentifier = @"labelbuttoncell";
            cellView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cellView == nil) {
                cellView = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            cellView.label1.text=[MyClass returntitlewithtitle:[centerqrcode_parameters_0 objectAtIndex:indexPath.row]];
            [cellView.button6 setBackgroundColor:themecolor];
            
            if(indexPath.row==0){
                [cellView.button6 addTarget:self action:@selector(changecenter_qrcode_refresh_minute:) forControlEvents:UIControlEventTouchUpInside];
                [cellView.button6 setTitle:[self returnqrcoderefreshfrequencytitle:globalvariables.centerrecord.center_qrcode_refresh_minute] forState:UIControlStateNormal];
            }else{
                [cellView.button6 addTarget:self action:@selector(changeattendance_qrcode_refresh_minute:) forControlEvents:UIControlEventTouchUpInside];
                [cellView.button6 setTitle:[self returnqrcoderefreshfrequencytitle:globalvariables.centerrecord.attendance_qrcode_refresh_minute] forState:UIControlStateNormal];
            }
            
        }
        
        return cellView;
    }
    return cell;

}

-(NSString *) returnqrcoderefreshfrequencytitle:(NSString *)value
{
    if ([value isEqualToString:@""]) {
        return [MyClass returntitlewithtitle:@"Never"];
    }else if ([value isEqualToString:@"PD"]) {
        return [MyClass returntitlewithtitle:@"Daily"];
    }else if ([value isEqualToString:@"PM"]) {
        return [MyClass returntitlewithtitle:@"Monthly"];
    }else{
        return [MyClass returnreplacedtitlewithtitle:@"%@1 mins" replacementarray:@[value]];
    }
}

-(void) updateevaluationformactive:(UISwitch *)sender
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        AssessmentFormListObject *obj=[evaluationformlistarray objectAtIndex:sender.tag];
        obj.active=!obj.active;
        
        [self updateEvaluationForm:obj];
    });
}

-(void) promotestudentschoolgradebuttonpressed
{
    UIAlertController *promotealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Grade Promotion"] message:[MyClass returntitlewithtitle:@"This action cannot be undone. Are you sure to promote all students school grade?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

        [MyClass loadingindicatorwithoption:@"start" color:@"gray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self promotestudentgrade];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            
        });
        
        
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [promotealert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [promotealert addAction:OKAction];
    [promotealert addAction:CancelAction];
    
    [self presentViewController:promotealert animated:YES completion:nil];
}

-(void) updateTierImage:(UIButton *)button
{
    imageuploadtype=@"tierimage";
    selectedtierrecord=[membershiptierarray objectAtIndex:button.tag];
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (hasCamera) {
        [self popupaddphotodialogueboxwithoption:@"add" button:button];
    }else{
        [self addphotofromsource:@"library" button:button];
    }
}

-(void) updatetimetabledisplayorder:(UISwitch *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:classtimetable];
    NSIndexPath *indexpath =[classtimetable indexPathForRowAtPoint:point];
    
    if (!indexpath) {
        indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    
    ((SortingRecord *)[classtimetable_parameters_1 objectAtIndex:indexpath.row]).order=sender.on?@"e":@"d";
    [self updatesortingstringwithtype:@"timetable"];
    [classtimetable reloadData];
//    [MyClass updatedevicelastupdatetimewithparameter:@"student" centerkeyarray:nil systemcurrenttime:@""];
}

-(void) updatestudentnamedisplayorder:(UISwitch *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:studentprofiletable];
    NSIndexPath *indexpath =[studentprofiletable indexPathForRowAtPoint:point];
    
    if (!indexpath) {
        indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    
    ((SortingRecord *)[studentprofile_section_1 objectAtIndex:indexpath.row]).order=sender.on?@"e":@"d";
    [self updatesortingstringwithtype:@"student"];
    [studentprofiletable reloadData];
    [MyClass updatedevicelastupdatetimewithparameter:@"student" centerkeyarray:nil systemcurrenttime:@""];
}

-(void) updateleadnamedisplayorder:(UISwitch *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:leadprofiletable];
    NSIndexPath *indexpath =[leadprofiletable indexPathForRowAtPoint:point];
    
    if (!indexpath) {
        indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    
    ((SortingRecord *)[leadprofile_section_1 objectAtIndex:indexpath.row]).order=sender.on?@"e":@"d";
    [self updatesortingstringwithtype:@"lead"];
    [leadprofiletable reloadData];
}

-(void) updateautosendereceipt:(UISwitch *)sender
{
    globalvariables.centerrecord.autosendereceipt=sender.on;
    [self updateCenterInformationWithField:@"autosendereceipt" Value:sender.on?@"Yes":@"No"];
}

-(void) updateprintclassdateendtime:(UISwitch *)sender
{
    globalvariables.centerrecord.printclassdateendtime=sender.on;
    [self updateCenterInformationWithField:@"printclassdateendtime" Value:sender.on?@"Yes":@"No"];
}

-(void) updateautosendeinvoice:(UISwitch *)sender
{
    globalvariables.centerrecord.autosendeinvoice=sender.on;
    [self updateCenterInformationWithField:@"autosendeinvoice" Value:sender.on?@"Yes":@"No"];
}

//-(void) updateprintclassdatemode:(UISwitch *)sender
//{
//    globalvariables.centerrecord.printclassdatemode=sender.on;
//    [self updateCenterInformationWithField:@"printclassdatemode" Value:sender.on?@"Yes":@"No"];
//}

-(void) showdiscountdetailsininvoice:(UISwitch *)sender
{
    globalvariables.centerrecord.showdiscountdetailsininvoice=sender.on;
    [self updateCenterInformationWithField:@"showdiscountdetailsininvoice" Value:sender.on?@"Yes":@"No"];
}

-(void) showdiscountdetailsinreceipt:(UISwitch *)sender
{
    globalvariables.centerrecord.showdiscountdetailsinreceipt=sender.on;
    [self updateCenterInformationWithField:@"showdiscountdetailsinreceipt" Value:sender.on?@"Yes":@"No"];
}

-(void) updateparentappdefault:(UISwitch *)sender
{
    globalvariables.centerrecord.parentappdefault=sender.on;
    [self updateCenterInformationWithField:@"parentappdefault" Value:sender.on?@"Yes":@"No"];
}

-(void) updatesmsdefault:(UISwitch *)sender
{
    globalvariables.centerrecord.smsdefault=sender.on;
    [self updateCenterInformationWithField:@"smsdefault" Value:sender.on?@"Yes":@"No"];
}

-(void) updatestudentassessmentform:(UISwitch *)sender
{
    globalvariables.centerrecord.studentassessmentform=sender.on;
    [self updateCenterInformationWithField:@"studentassessmentform" Value:sender.on?@"Yes":@"No"];
}

-(void) updateshowcenteraveragescore:(UISwitch *)sender
{
    globalvariables.centerrecord.showcenteraveragescore=sender.on;
    [self updateCenterInformationWithField:@"showcenteraveragescore" Value:sender.on?@"Yes":@"No"];
}

-(void) updateicenterversioncheck:(UISwitch *)sender
{
    globalvariables.centerrecord.icenterversioncheck=sender.on;
    [self updateCenterInformationWithField:@"icenterversioncheck" Value:sender.on?@"Yes":@"No"];
}

-(void) updatestudentextrafield1:(UISwitch *)sender
{
    globalvariables.centerrecord.studentextrafield1=sender.on;
    [self updateCenterInformationWithField:@"studentextrafield1" Value:sender.on?@"Yes":@"No"];
}

-(void) updatestudentpromotiondefault:(UISwitch *)sender
{
    globalvariables.centerrecord.studentpromotiondefault=sender.on;
    [self updateCenterInformationWithField:@"studentpromotiondefault" Value:sender.on?@"Yes":@"No"];
}

-(void) updatestudentsendmessagedefault:(UISwitch *)sender
{
    globalvariables.centerrecord.studentsendmessagedefault=sender.on;
    [self updateCenterInformationWithField:@"studentsendmessagedefault" Value:sender.on?@"Yes":@"No"];
}

-(void) updatedefaultcsshowintimetableifnoenrollment:(UISwitch *)sender
{
    globalvariables.centerrecord.defaultcsshowintimetableifnoenrollment=sender.on;
    [self updateCenterInformationWithField:@"defaultcsshowintimetableifnoenrollment" Value:sender.on?@"Yes":@"No"];
}

-(void) updatedefaultcsmakeupschedule:(UISwitch *)sender
{
    globalvariables.centerrecord.defaultcsmakeupschedule=sender.on;
    [self updateCenterInformationWithField:@"defaultcsmakeupschedule" Value:sender.on?@"Yes":@"No"];
}

-(void) updateleadpromotiondefault:(UISwitch *)sender
{
    globalvariables.centerrecord.leadpromotiondefault=sender.on;
    [self updateCenterInformationWithField:@"leadpromotiondefault" Value:sender.on?@"Yes":@"No"];
}

-(void) updateautofillstudentid:(UISwitch *)sender
{
    globalvariables.centerrecord.autofillstudentid=sender.on;
    [self updateCenterInformationWithField:@"autofillstudentid" Value:sender.on?@"Yes":@"No"];
}

-(void) updatefullday:(UISwitch *)sender
{
    globalvariables.centerrecord.fullday=sender.on;
    [self updateCenterInformationWithField:@"fullday" Value:sender.on?@"Yes":@"No"];
    [classtimetable reloadData];
}

-(void) updateenrollmultiplesubjectsatsametimeslot:(UISwitch *)sender
{
    globalvariables.centerrecord.enrollmultiplesubjectsatsametimeslot=sender.on;
    [self updateCenterInformationWithField:@"enrollmultiplesubjectsatsametimeslot" Value:sender.on?@"Yes":@"No"];
}

-(void) updateenablemakeupquota:(UISwitch *)sender
{
    globalvariables.centerrecord.enablemakeupquota=sender.on;
    [self updateCenterInformationWithField:@"enablemakeupquota" Value:sender.on?@"Yes":@"No"];
}

-(void) updateenablelessonnumber:(UISwitch *)sender
{
    globalvariables.centerrecord.enablelessonnumber=sender.on;
    [self updateCenterInformationWithField:@"enablelessonnumber" Value:sender.on?@"Yes":@"No"];
}

-(void) updatemarkexpiredclassabsent:(UISwitch *)sender
{
    globalvariables.centerrecord.markexpiredclassabsent=sender.on;
    [self updateCenterInformationWithField:@"markexpiredclassabsent" Value:sender.on?@"Yes":@"No"];
}

-(void) updatesecondaryinstructor:(UISwitch *)sender
{
    globalvariables.centerrecord.secondaryinstructor=sender.on;
    [self updateCenterInformationWithField:@"secondaryinstructor" Value:sender.on?@"Yes":@"No"];
}

-(void) updateupdateclassafterschedulechange:(UISwitch *)sender
{
    globalvariables.centerrecord.updateclassafterschedulechange=sender.on;
    [self updateCenterInformationWithField:@"updateclassafterschedulechange" Value:sender.on?@"Yes":@"No"];
}

-(void) updatecloneenrollmentcopydiscountdefault:(UISwitch *)sender
{
    globalvariables.centerrecord.cloneenrollmentcopydiscountdefault=sender.on;
    [self updateCenterInformationWithField:@"cloneenrollmentcopydiscountdefault" Value:sender.on?@"Yes":@"No"];
}

-(void) updateremovecouponifnotpaidbeforeexpiry:(UISwitch *)sender
{
    globalvariables.centerrecord.removecouponifnotpaidbeforeexpiry=sender.on;
    [self updateCenterInformationWithField:@"removecouponifnotpaidbeforeexpiry" Value:sender.on?@"Yes":@"No"];
}

-(void) updateautofillleadid:(UISwitch *)sender
{
    globalvariables.centerrecord.autofillleadid=sender.on;
    [self updateCenterInformationWithField:@"autofillleadid" Value:sender.on?@"Yes":@"No"];
}

-(void) updaterenewmonthlyroundup:(UISegmentedControl *)sender
{
    globalvariables.centerrecord.renewmonthlyroundup=sender.selectedSegmentIndex==0?YES:NO;
    [self updateCenterInformationWithField:@"renewmonthlyroundup" Value:sender.selectedSegmentIndex==0?@"Yes":@"No"];
}

-(void) updateskipmakeupforrenewal_prepare:(UISwitch *)sender
{
    globalvariables.centerrecord.skipmakeupforrenewal_prepare=sender.on;
    [self updateCenterInformationWithField:@"skipmakeupforrenewal_prepare" Value:sender.on?@"Yes":@"No"];
}

-(void) updateenablescantotakeattendance:(UISwitch *)sender
{
    globalvariables.centerrecord.enablescantotakeattendance=sender.on;
    [self updateCenterInformationWithField:@"enablescantotakeattendance" Value:sender.on?@"Yes":@"No"];
    
    NSRange range = NSMakeRange(2, 1);
    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    [attendancetable reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
}

-(void) updateenableattendanceextend:(UISwitch *)sender
{
    globalvariables.centerrecord.enableattendanceextend=sender.on;
    [self updateCenterInformationWithField:@"enableattendanceextend" Value:sender.on?@"Yes":@"No"];
}

-(void) editspendingtopointratio:(UITextField *)sender
{
    if ([MyClass checkValidInput:sender.text Type:@"Float"]) {
        
        [MyClass updateCenterInformationWithField:@"spendingtopointratio" Value:sender.text];
        globalvariables.centerrecord.spendingtopointratio=sender.text;
        
    }else{
        sender.text=globalvariables.centerrecord.spendingtopointratio;
    }

}

- (void)editspendingtopointratio_editingend:(UITextField *)sender
{
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"";
        [self updateCenterInformationWithField:@"spendingtopointratio" Value:sender.text];
        globalvariables.centerrecord.spendingtopointratio=sender.text;
    }
}

-(void) editspendingtopointratio_sales:(UITextField *)sender
{
    if ([MyClass checkValidInput:sender.text Type:@"Float"]) {
        
        [MyClass updateCenterInformationWithField:@"spendingtopointratio_sales" Value:sender.text];
        globalvariables.centerrecord.spendingtopointratio_sales=sender.text;
        
    }else{
        sender.text=globalvariables.centerrecord.spendingtopointratio_sales;
    }

}

-(void) edittierinformation:(UITextField *)sender
{
    NSInteger row=sender.tag%100;
    NSInteger field=sender.tag/100;
    MembershipTierRecord *record=[membershiptierarray objectAtIndex:row];
    if (field==2) {
        if (![MyClass checkValidInput:sender.text Type:@"Float"]) {
            sender.text=record.requirement;
        }
    }else if (field==3) {
        if (![MyClass checkValidInput:sender.text Type:@"Float"]) {
            sender.text=record.pointmultiplier;
        }
    }else if (field==4) {
        if (![MyClass checkValidInput:sender.text Type:@"Float"]) {
            sender.text=record.birthdaypoint;
        }
    }
}

-(void) edittierinformation_editingend:(UITextField *)sender
{
    NSInteger row=sender.tag%100;
    NSInteger field=sender.tag/100;
    MembershipTierRecord *record=[membershiptierarray objectAtIndex:row];
    
    if (field==0) {
        [self updateMembershipTierSettingsWithTierkey:record.tierkey Key:@"title" Value:sender.text];
    }else if (field==1) {
        [self updateMembershipTierSettingsWithTierkey:record.tierkey Key:@"title_chinese" Value:sender.text];
    }else if (field==2) {
        if ([sender.text isEqualToString:@""]) {
            sender.text=@"0";
        }
        [self updateMembershipTierSettingsWithTierkey:record.tierkey Key:@"requirement" Value:sender.text];
    }else if (field==3) {
        if ([sender.text isEqualToString:@""]) {
            sender.text=@"0";
        }
        [self updateMembershipTierSettingsWithTierkey:record.tierkey Key:@"pointmultiplier" Value:sender.text];
    }else if (field==4) {
        if ([sender.text isEqualToString:@""]) {
            sender.text=@"0";
        }
        [self updateMembershipTierSettingsWithTierkey:record.tierkey Key:@"birthdaypoint" Value:sender.text];
    }
}

- (void)edittierspendinginterval:(UITextField *)sender
{
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"0";
        [self updateCenterInformationWithField:@"tierspendinginterval" Value:sender.text];
        globalvariables.centerrecord.tierspendinginterval=[sender.text integerValue];
    }
}

- (void)edittierspendinginterval_editingend:(UITextField *)sender
{
    
    
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"0";
        [self updateCenterInformationWithField:@"tierspendinginterval" Value:sender.text];
        globalvariables.centerrecord.tierspendinginterval=[sender.text integerValue];
    }
}

-(void) editpointearn_qrcodecheckin:(UITextField *)sender
{
    if ([MyClass checkValidInput:sender.text Type:@"Float"]) {
        
        [MyClass updateCenterInformationWithField:@"pointearn_qrcodecheckin" Value:sender.text];
        globalvariables.centerrecord.pointearn_qrcodecheckin=sender.text;
        
    }else{
        sender.text=globalvariables.centerrecord.pointearn_qrcodecheckin;
    }

}



- (void)editpointearn_qrcodecheckin_editingend:(UITextField *)sender
{
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"";
        [self updateCenterInformationWithField:@"pointearn_qrcodecheckin" Value:sender.text];
        globalvariables.centerrecord.pointearn_qrcodecheckin=sender.text;
    }
}

-(void) editpointearn_selfmakeup:(UITextField *)sender
{
    if ([MyClass checkValidInput:sender.text Type:@"Float"]) {
        
        [MyClass updateCenterInformationWithField:@"pointearn_selfmakeup" Value:sender.text];
        globalvariables.centerrecord.pointearn_selfmakeup=sender.text;
        
    }else{
        sender.text=globalvariables.centerrecord.pointearn_selfmakeup;
    }

}



- (void)editpointearn_selfmakeup_editingend:(UITextField *)sender
{
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"";
        [self updateCenterInformationWithField:@"pointearn_selfmakeup" Value:sender.text];
        globalvariables.centerrecord.pointearn_selfmakeup=sender.text;
    }
}

- (void)editspendingtopointratio_sales_editingend:(UITextField *)sender
{
    if ([sender.text isEqualToString:@""]) {
        sender.text=@"";
        [self updateCenterInformationWithField:@"spendingtopointratio_sales" Value:sender.text];
        globalvariables.centerrecord.spendingtopointratio_sales=sender.text;
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

-(void) updaterenewevenifthereistbdclass:(UISwitch *)sender
{
    globalvariables.centerrecord.renewevenifthereistbdclass=sender.on;
    [self updateCenterInformationWithField:@"renewevenifthereistbdclass" Value:sender.on?@"Yes":@"No"];
}

-(void) updatejumptonextlevelduringrenewal:(UISwitch *)sender
{
    globalvariables.centerrecord.jumptonextlevelduringrenewal=sender.on;
    [self updateCenterInformationWithField:@"jumptonextlevelduringrenewal" Value:sender.on?@"Yes":@"No"];
}

-(void) updateusereserveddayduringrenewal:(UISwitch *)sender
{
    globalvariables.centerrecord.usereserveddayduringrenewal=sender.on;
    [self updateCenterInformationWithField:@"usereserveddayduringrenewal" Value:sender.on?@"Yes":@"No"];
}

-(void) updatemarkrenewalreserveddaytomakeup:(UISwitch *)sender
{
    globalvariables.centerrecord.markrenewalreserveddaytomakeup=sender.on;
    [self updateCenterInformationWithField:@"markrenewalreserveddaytomakeup" Value:sender.on?@"Yes":@"No"];
}

-(void) updateusereserveddayduringenrollment:(UISwitch *)sender
{
    globalvariables.centerrecord.usereserveddayduringenrollment=sender.on;
    [self updateCenterInformationWithField:@"usereserveddayduringenrollment" Value:sender.on?@"Yes":@"No"];
}

-(void) updatemarkenrollmentreserveddaytomakeup:(UISwitch *)sender
{
    globalvariables.centerrecord.markenrollmentreserveddaytomakeup=sender.on;
    [self updateCenterInformationWithField:@"markenrollmentreserveddaytomakeup" Value:sender.on?@"Yes":@"No"];
}

-(void) updatescantype:(UISegmentedControl *)sender
{
    globalvariables.centerrecord.scantype=sender.selectedSegmentIndex==0?@"barcode":@"qrcode";
    [self updateCenterInformationWithField:@"scantype" Value:sender.selectedSegmentIndex==0?@"barcode":@"qrcode"];
}

-(void) updatescantotakeattendancebeforethreshold:(UITextField *)sender
{
    if ([MyClass isIntegerNumber:sender.text]) {
        globalvariables.centerrecord.scantotakeattendancebeforethreshold=[sender.text intValue];
        [self updateCenterInformationWithField:@"scantotakeattendancebeforethreshold" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
    }else{
        sender.text=[NSString stringWithFormat:@"%i",globalvariables.centerrecord.scantotakeattendancebeforethreshold];
    }
}

-(void) updatescantotakeattendanceafterthreshold:(UITextField *)sender
{
    if ([MyClass isIntegerNumber:sender.text]) {
        globalvariables.centerrecord.scantotakeattendanceafterthreshold=[sender.text intValue];
        [self updateCenterInformationWithField:@"scantotakeattendanceafterthreshold" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
    }else{
        sender.text=[NSString stringWithFormat:@"%i",globalvariables.centerrecord.scantotakeattendanceafterthreshold];
    }
}

-(void) updatenoofroundoffdigit:(UISegmentedControl *)sender
{
    globalvariables.centerrecord.noofroundoffdigit=(int)sender.selectedSegmentIndex;
    [self updateCenterInformationWithField:@"noofroundoffdigit" Value:sender.selectedSegmentIndex==0?@"0":@"1"];
}




-(void) updatemonthlymodeweeklyscheduletuitiondenominator:(UITextField *)sender
{
    if ([MyClass isIntegerNumber:sender.text]) {
        globalvariables.centerrecord.monthlymodeweeklyscheduletuitiondenominator=[sender.text intValue];
        [self updateCenterInformationWithField:@"monthlymodeweeklyscheduletuitiondenominator" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
    }else{
        sender.text=[NSString stringWithFormat:@"%i",globalvariables.centerrecord.monthlymodeweeklyscheduletuitiondenominator];
    }

}

-(void) updatechequepayable:(UITextField *)sender
{
    globalvariables.centerrecord.chequepayable=sender.text;
    [self updateCenterInformationWithField:@"chequepayable" Value:sender.text];
}

-(void) updateinvoiceprefix:(UITextField *)sender
{
    globalvariables.centerrecord.invoiceprefix=[MyClass leadingtrailingspacestrimmed:sender.text];
    [self updateCenterInformationWithField:@"invoiceprefix" Value:[MyClass leadingtrailingspacestrimmed:sender.text]];
}

-(void) updatereceiptprefix:(UITextField *)sender
{
    globalvariables.centerrecord.receiptprefix=[MyClass leadingtrailingspacestrimmed:sender.text];
    [self updateCenterInformationWithField:@"receiptprefix" Value:[MyClass leadingtrailingspacestrimmed:sender.text]];
}

-(void) updatesidprefix:(UITextField *)sender
{
    globalvariables.centerrecord.sidprefix=[MyClass leadingtrailingspacestrimmed:sender.text];
    [self updateCenterInformationWithField:@"sidprefix" Value:[MyClass leadingtrailingspacestrimmed:sender.text]];
}

-(void) updateenrollmentfee:(UITextField *)sender
{
    if ([MyClass checkvalidfeeinput:sender.text]) {
        globalvariables.centerrecord.enrollmentfee=sender.text;
        [self updateCenterInformationWithField:@"enrollmentfee" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
    }else{
        sender.text=globalvariables.centerrecord.enrollmentfee;
    }
}

-(void) updatetimetableoutstandingmode:(UISegmentedControl *)sender
{
    [MyClass updatelocaldbwithparameter:@"timetableoutstandingmode" value:sender.selectedSegmentIndex==0?@"perstudent":@"perclass"];
}

-(void) updatetimetableshowallstudentcount:(UISwitch *)sender
{
    [MyClass updatelocaldbwithparameter:@"timetableshowallstudentcount" value:sender.on?@"Y":@"N"];
}

-(void) updatetimetableshowattendingcount:(UISwitch *)sender
{
    [MyClass updatelocaldbwithparameter:@"timetableshowattendingcount" value:sender.on?@"Y":@"N"];
}

-(void) updatetimetableshowoutstandingpaymentstudentcount:(UISwitch *)sender
{
    [MyClass updatelocaldbwithparameter:@"timetableshowoutstandingpaymentstudentcount" value:sender.on?@"Y":@"N"];
}

-(void) updateshowageintimetable:(UISwitch *)sender
{
    [MyClass updatelocaldbwithparameter:@"showageintimetable" value:sender.on?@"Y":@"N"];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSInteger messagetype=textView.tag/10000;
    NSInteger row=textView.tag%100;
    NSInteger versiontype=(textView.tag%10000)/100;
    AutoNotificationSettingsRecord *record=[self returnAutoNotificationSettingsRecordWithType:messagetype Row:row];
    if (![[record valueForKey:versiontype==0?@"message_en":@"message_zh"] isEqualToString:textView.text]) {
        if ([self updateAutoNotificationSettingsWithAnSettingKey:record.ansettingkey Key:versiontype==0?@"message_en":@"message_zh" Value:textView.text]) {
            [record setValue:textView.text forKey:versiontype==0?@"message_en":@"message_zh"];
        }
    }
}




-(void) updatelatefee_enable:(UISwitch *)sender
{
    globalvariables.centerrecord.latefee_enable=sender.on?@"Yes":@"No";
    [self updateCenterInformationWithField:@"latefee_enable" Value:sender.on?@"Yes":@"No"];
    
    NSRange range = NSMakeRange(3, 1);
    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    [financialtable reloadSections:section withRowAnimation:UITableViewRowAnimationNone];
}

-(void) updatelatefee:(UITextField *)sender
{
    if ([MyClass checkvalidfeeinput:sender.text]) {
        globalvariables.centerrecord.latefee=sender.text;
        [self updateCenterInformationWithField:@"latefee" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
    }else{
        sender.text=globalvariables.centerrecord.latefee;
    }
}

-(void) updatelatefeegraceperiod:(UITextField *)sender
{
    if ([MyClass isIntegerNumber:sender.text]) {
        globalvariables.centerrecord.latefeegraceperiod=sender.text;
        [self updateCenterInformationWithField:@"latefeegraceperiod" Value:[sender.text isEqualToString:@""]?@"0":sender.text];
    }else{
        sender.text=globalvariables.centerrecord.latefeegraceperiod;
    }
}

-(void) updateenableistafftakingattendance:(UISwitch *)sender
{
    globalvariables.centerrecord.enableistafftakingattendance=sender.on;
    [self updateCenterInformationWithField:@"enableistafftakingattendance" Value:sender.on?@"Yes":@"No"];
}

-(void) updateautoenrollmentfeeforfirstenrollment:(UISwitch *)sender
{
    globalvariables.centerrecord.autoenrollmentfeeforfirstenrollment=sender.on;
    [self updateCenterInformationWithField:@"autoenrollmentfeeforfirstenrollment" Value:sender.on?@"Yes":@"No"];
}

-(void) updateremoveunpaidandexpiredpromotion:(UISwitch *)sender
{
    globalvariables.centerrecord.removeunpaidandexpiredpromotion=sender.on;
    [self updateCenterInformationWithField:@"removeunpaidandexpiredpromotion" Value:sender.on?@"Yes":@"No"];
}

-(void) updatereservedcalendardate:(UISwitch *)sender
{
    globalvariables.centerrecord.reservedcalendardate=sender.on;
    [self updateCenterInformationWithField:@"reservedcalendardate" Value:sender.on?@"Yes":@"No"];
}

-(void) updateenablevoicemessage:(UISwitch *)sender
{
    globalvariables.centerrecord.enablevoicemessage=sender.on;
    [self updateCenterInformationWithField:@"enablevoicemessage" Value:sender.on?@"Yes":@"No"];
}

-(void) updateenablevideomessage:(UISwitch *)sender
{
    globalvariables.centerrecord.enablevideomessage=sender.on;
    [self updateCenterInformationWithField:@"enablevideomessage" Value:sender.on?@"Yes":@"No"];
}

-(void) updateenrollmentvalidity:(UISwitch *)sender
{
    globalvariables.centerrecord.enrollmentvalidity=sender.on;
    [self updateCenterInformationWithField:@"enrollmentvalidity" Value:sender.on?@"Yes":@"No"];
    [enrollmenttable reloadData];
}

-(void) updateenablemembershippoint:(UISwitch *)sender
{
    globalvariables.centerrecord.enablemembershippoint=sender.on;
    [self updateCenterInformationWithField:@"enablemembershippoint" Value:sender.on?@"Yes":@"No"];
    [membershiptable reloadData];
}

-(void) updateenablemembershiptier:(UISwitch *)sender
{
    globalvariables.centerrecord.enablemembershiptier=sender.on;
    [self updateCenterInformationWithField:@"enablemembershiptier" Value:sender.on?@"Yes":@"No"];
    [membershiptable reloadData];
}

-(void) updateenablechatbot:(UISwitch *)sender
{
    globalvariables.centerrecord.enablechatbot=sender.on;
    [self updateCenterInformationWithField:@"enablechatbot" Value:sender.on?@"Yes":@"No"];
    [chatbottable reloadData];
}

-(void) updateaddpointwithactiveparentapp:(UISwitch *)sender
{
    globalvariables.centerrecord.addpointwithactiveparentapp=sender.on;
    [self updateCenterInformationWithField:@"addpointwithactiveparentapp" Value:sender.on?@"Yes":@"No"];
    if(!sender.on && globalvariables.centerrecord.addpointforonlinepaymentonly){
        globalvariables.centerrecord.addpointforonlinepaymentonly=NO;
        [self updateCenterInformationWithField:@"addpointforonlinepaymentonly" Value:@"No"];
    }
    [membershiptable reloadData];
}

-(void) updateaddpointforonlinepaymentonly:(UISwitch *)sender
{
    globalvariables.centerrecord.addpointforonlinepaymentonly=sender.on;
    [self updateCenterInformationWithField:@"addpointforonlinepaymentonly" Value:sender.on?@"Yes":@"No"];
    if(sender.on && !globalvariables.centerrecord.addpointwithactiveparentapp){
        globalvariables.centerrecord.addpointwithactiveparentapp=YES;
        [self updateCenterInformationWithField:@"addpointwithactiveparentapp" Value:@"Yes"];
    }
    [membershiptable reloadData];
}

-(void) updateaddpointforontimepaymentonly:(UISwitch *)sender
{
    globalvariables.centerrecord.addpointforontimepaymentonly=sender.on;
    [self updateCenterInformationWithField:@"addpointforontimepaymentonly" Value:sender.on?@"Yes":@"No"];

    [membershiptable reloadData];
}

-(void) updatetransferpointforinternaltransferpayment:(UISwitch *)sender
{
    globalvariables.centerrecord.transferpointforinternaltransferpayment=sender.on;
    [self updateCenterInformationWithField:@"transferpointforinternaltransferpayment" Value:sender.on?@"Yes":@"No"];

    [membershiptable reloadData];
}

-(void) updatemaxdayrangefortrialclass:(UISwitch *)sender
{
    globalvariables.centerrecord.maxdayrangefortrialclass=sender.on;
    [self updateCenterInformationWithField:@"maxdayrangefortrialclass" Value:sender.on?@"Yes":@"No"];
    [membershiptable reloadData];
}

-(void) updateiparentusercanupdatepersonalinformation:(UISwitch *)sender
{
    globalvariables.centerrecord.iparentusercanupdatepersonalinformation=sender.on;
    [self updateCenterInformationWithField:@"iparentusercanupdatepersonalinformation" Value:sender.on?@"Yes":@"No"];
}

-(void) updatesendparentappinvitesms:(UISwitch *)sender
{
    globalvariables.centerrecord.sendparentappinvitesms=sender.on;
    [self updateCenterInformationWithField:@"sendparentappinvitesms" Value:sender.on?@"Yes":@"No"];
}

-(void) updateiparentshowenrollmenttuitionfee:(UISwitch *)sender
{
    globalvariables.centerrecord.iparentshowenrollmenttuitionfee=sender.on;
    [self updateCenterInformationWithField:@"iparentshowenrollmenttuitionfee" Value:sender.on?@"Yes":@"No"];
}

-(void) updateiparentshowonlynondroppedenrollment:(UISwitch *)sender
{
    globalvariables.centerrecord.iparentshowonlynondroppedenrollment=sender.on;
    [self updateCenterInformationWithField:@"iparentshowonlynondroppedenrollment" Value:sender.on?@"Yes":@"No"];
}

-(void) updateiparentshowclassschedule:(UISwitch *)sender
{
    globalvariables.centerrecord.iparentshowclassschedule=sender.on;
    [self updateCenterInformationWithField:@"iparentshowclassschedule" Value:sender.on?@"Yes":@"No"];
}

-(void) updateiparentshowmessages:(UISwitch *)sender
{
    globalvariables.centerrecord.iparentshowmessages=sender.on;
    [self updateCenterInformationWithField:@"iparentshowmessages" Value:sender.on?@"Yes":@"No"];
}

-(void) updateiparentshowphotocorner:(UISwitch *)sender
{
    globalvariables.centerrecord.iparentshowphotocorner=sender.on;
    [self updateCenterInformationWithField:@"iparentshowphotocorner" Value:sender.on?@"Yes":@"No"];
}

-(void) updateiparentshowenrollmentrecords:(UISwitch *)sender
{
    globalvariables.centerrecord.iparentshowenrollmentrecords=sender.on;
    [self updateCenterInformationWithField:@"iparentshowenrollmentrecords" Value:sender.on?@"Yes":@"No"];
}

-(void) updateiparentshowsalesrecords:(UISwitch *)sender
{
    globalvariables.centerrecord.iparentshowsalesrecords=sender.on;
    [self updateCenterInformationWithField:@"iparentshowsalesrecords" Value:sender.on?@"Yes":@"No"];
}

-(void) updateenableparentsendmessage:(UISwitch *)sender
{
    globalvariables.centerrecord.enableparentsendmessage=sender.on;
    [self updateCenterInformationWithField:@"enableparentsendmessage" Value:sender.on?@"Yes":@"No"];
    
    /*NSRange range = NSMakeRange(6, 1);
    NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
    [iparenttable reloadSections:section withRowAnimation:UITableViewRowAnimationNone];*/
    [iparenttable reloadData];
}

-(void) updateenableparentsendvideomessage:(UISwitch *)sender
{
    globalvariables.centerrecord.enableparentsendvideomessage=sender.on;
    [self updateCenterInformationWithField:@"enableparentsendvideomessage" Value:sender.on?@"Yes":@"No"];
}

-(void) updateenableparentsendvoicemessage:(UISwitch *)sender
{
    globalvariables.centerrecord.enableparentsendvoicemessage=sender.on;
    [self updateCenterInformationWithField:@"enableparentsendvoicemessage" Value:sender.on?@"Yes":@"No"];
}

-(void) updateiparentshowclassroom:(UISwitch *)sender
{
    globalvariables.centerrecord.iparentshowclassroom=sender.on;
    [self updateCenterInformationWithField:@"iparentshowclassroom" Value:sender.on?@"Yes":@"No"];
}

-(void) updateiparentshowclassendtime:(UISwitch *)sender
{
    globalvariables.centerrecord.iparentshowclassendtime=sender.on;
    [self updateCenterInformationWithField:@"iparentshowclassendtime" Value:sender.on?@"Yes":@"No"];
}

-(void) updateiparentshowuserdefinedschedulename:(UISwitch *)sender
{
    globalvariables.centerrecord.iparentshowuserdefinedschedulename=sender.on;
    [self updateCenterInformationWithField:@"iparentshowuserdefinedschedulename" Value:sender.on?@"Yes":@"No"];
}

-(void) updateiparentreturnrenewalremindernotifications:(UISwitch *)sender
{
    globalvariables.centerrecord.iparentreturnrenewalremindernotifications=sender.on;
    [self updateCenterInformationWithField:@"iparentreturnrenewalremindernotifications" Value:sender.on?@"Yes":@"No"];
}

-(void) updateiparentclassalert:(UISwitch *)sender
{
    globalvariables.centerrecord.iparentclassalert=sender.on;
    [self updateCenterInformationWithField:@"iparentclassalert" Value:sender.on?@"Yes":@"No"];
}

-(void) updateexpiringclassreminder:(UISwitch *)sender
{
    globalvariables.centerrecord.expiringclassreminder=sender.on;
    [self updateCenterInformationWithField:@"expiringclassreminder" Value:sender.on?@"Yes":@"No"];
    [iparenttable reloadData];
}

-(void) updatedefaultattendancestatus:(UISegmentedControl *)sender
{
    [MyClass loadingindicatorwithoption:@"start" color:@"gray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        globalvariables.centerrecord.defaultattendancestatus=sender.selectedSegmentIndex==0?@"Present":@"";
        [self updateCenterInformationWithField:@"defaultattendancestatus" Value:sender.selectedSegmentIndex==0?@"Present":@""];
        if (sender.selectedSegmentIndex==0) {
            globalvariables.centerrecord.enablescantotakeattendance=FALSE;
        }
        [attendancetable reloadData];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        
    });
}

-(void) updatemark_noattendancetaking_to:(UISegmentedControl *)sender
{
    [MyClass loadingindicatorwithoption:@"start" color:@"gray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (sender.selectedSegmentIndex==0) {
            globalvariables.centerrecord.mark_noattendancetaking_to=@"Absent";
        }else if (sender.selectedSegmentIndex==1){
            globalvariables.centerrecord.mark_noattendancetaking_to=@"Makeup";
        }else{
            globalvariables.centerrecord.mark_noattendancetaking_to=@"Present";
        }
        [MyClass updateCenterInformationWithField:@"mark_noattendancetaking_to" Value:globalvariables.centerrecord.mark_noattendancetaking_to];
        [attendancetable reloadData];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        
    });
}

-(void) updateeenrollmentformdest:(UISegmentedControl *)sender
{
    [MyClass loadingindicatorwithoption:@"start" color:@"gray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (sender.selectedSegmentIndex==0) {
            globalvariables.centerrecord.eenrollmentformdest=@"student";
        }else if (sender.selectedSegmentIndex==1){
            globalvariables.centerrecord.eenrollmentformdest=@"lead";
        }
        [MyClass updateCenterInformationWithField:@"eenrollmentformdest" Value:globalvariables.centerrecord.eenrollmentformdest];
        [enrollmenttable reloadData];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        
    });
}


- (void)selectlanguage:(UISegmentedControl *)sender {

    if(sender.selectedSegmentIndex==0){
        globalvariables.language=@"English";
    }else if (sender.selectedSegmentIndex==1){
        globalvariables.language=@"Chinese";
    }else{
        globalvariables.language=@"SChinese";
    }
    
    [self refreshlanguage];
    //[self loadtitle];
    globalvariables.reloadleftmenu=YES;
    
    [MyClass updatelocaldbwithparameter:@"language" value:globalvariables.language];
    [menutable reloadData];
    [generaltable reloadData];
    [menutable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [self.mainSlideMenu closeLeftMenu];
    
    
}

-(BOOL) updateCenterInformationWithField:(NSString *)field Value:(NSString *)value
{

    //combine arrays
    NSDictionary *dictionary = @{field : value,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"postaction" : @"updatecenterinformation",
                                 @"updatedby" : globalvariables.username
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
    
    return result;

}

-(BOOL) updateCenterSettingsWithField:(NSString *)field Value:(NSString *)value
{
    //combine arrays
    NSDictionary *dictionary = @{@"field" : field,
                                 @"value" : value,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"postaction" : @"updatecentersettings"
                                 };
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    return result;
}



-(void) enableattendancenotification:(UISwitch *)sender
{
    if (sender.tag==0) {
        [self updateCenterSettingsWithField:@"presentalert" Value:sender.on?@"Yes":@"No"];
    }else if (sender.tag==1){
        [self updateCenterSettingsWithField:@"absentalert" Value:sender.on?@"Yes":@"No"];
    }else{
        [self updateCenterSettingsWithField:@"makeupalert" Value:sender.on?@"Yes":@"No"];
    }
}

-(void) updateskipmakeupforrenewal:(UISwitch *)sender
{
    [self updateCenterSettingsWithField:@"skipmakeupforrenewal" Value:sender.on?@"Yes":@"No"];
}

-(void) enablephotoalert:(UISwitch *)sender
{
    [self updateCenterSettingsWithField:@"photoalert" Value:sender.on?@"Yes":@"No"];
}


-(void) enableaccountreceivablecodes:(UISwitch *)sender
{
    [self updateCenterInformationWithField:@"enableaccountreceivablecodes" Value:sender.on?@"Yes":@"No"];
    globalvariables.centerrecord.enableaccountreceivablecodes=sender.on;
    if(sender.on){
        if([[MyClass returndefaultarckey] isEqualToString:@""]){
            [MyClass savedefaultarckey:((ARCodeRecord *)[arcodearray firstObject]).arckey];
        }
    }else{
        [MyClass savedefaultarckey:@""];
    }
    [self refreshlanguage];
    
    [financialtable reloadData];
}



-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==studentprofiletable) {
        if (indexPath.section==1) {
            return YES;
        }
    }if (tableView==leadprofiletable) {
        if (indexPath.section==1) {
            return YES;
        }
    }if (tableView==classtimetable) {
        if (indexPath.section==1) {
            return YES;
        }
    }
    return NO;
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

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    //do whatever u want after row has been moved
    if (tableView==studentprofiletable) {
        if (toIndexPath.section==1 && (fromIndexPath.row !=toIndexPath.row)) {
            
            sortingobject=[studentprofile_section_1 objectAtIndex:fromIndexPath.row];
            [studentprofile_section_1 removeObjectAtIndex:fromIndexPath.row];
            [studentprofile_section_1 insertObject:sortingobject atIndex:toIndexPath.row];
            
            [self updatesortingstringwithtype:@"student"];
            [studentprofiletable reloadData];
            [MyClass updatedevicelastupdatetimewithparameter:@"student" centerkeyarray:nil systemcurrenttime:@""];
        }
    }else if (tableView==leadprofiletable){
        if (toIndexPath.section==1 && (fromIndexPath.row !=toIndexPath.row)) {
            
            sortingobject=[leadprofile_section_1 objectAtIndex:fromIndexPath.row];
            [leadprofile_section_1 removeObjectAtIndex:fromIndexPath.row];
            [leadprofile_section_1 insertObject:sortingobject atIndex:toIndexPath.row];
            
            [self updatesortingstringwithtype:@"lead"];
            [leadprofiletable reloadData];
        }
    }else if (tableView==classtimetable){
        if (toIndexPath.section==1 && (fromIndexPath.row !=toIndexPath.row)) {
            
            sortingobject=[classtimetable_parameters_1 objectAtIndex:fromIndexPath.row];
            [classtimetable_parameters_1 removeObjectAtIndex:fromIndexPath.row];
            [classtimetable_parameters_1 insertObject:sortingobject atIndex:toIndexPath.row];
            
            [self updatesortingstringwithtype:@"timetable"];
            [classtimetable reloadData];
        }
    }
    

}

-(void) updatesortingstringwithtype:(NSString *)type
{
    NSString *sortingstring=@"";
    
    if ([type isEqualToString:@"student"]) {
        for (int i=0; i<studentprofile_section_1.count; i++) {
            if (i==0) {
                sortingstring=[NSString stringWithFormat:@"%@#%@",((SortingRecord *)[studentprofile_section_1 objectAtIndex:i]).order,((SortingRecord *)[studentprofile_section_1 objectAtIndex:i]).item];
            }else{
                sortingstring=[NSString stringWithFormat:@"%@,%@#%@",sortingstring,((SortingRecord *)[studentprofile_section_1 objectAtIndex:i]).order,((SortingRecord *)[studentprofile_section_1 objectAtIndex:i]).item];
            }
        }
        
        globalvariables.centerrecord.studentnamedisplayorder=[[NSMutableArray alloc]initWithArray:[sortingstring componentsSeparatedByString:@","]];
        [MyClass updateCenterInformationWithField:@"studentnamedisplayorder" Value:sortingstring];
        //globalvariables.centerrecord.studentnamedisplayorder=sortingstring;
        //[MyClass updatelocaldbwithparameter:@"studentnamedisplayorder" value:sortingstring];
    }else if ([type isEqualToString:@"lead"]){
        for (int i=0; i<leadprofile_section_1.count; i++) {
            if (i==0) {
                sortingstring=[NSString stringWithFormat:@"%@#%@",((SortingRecord *)[leadprofile_section_1 objectAtIndex:i]).order,((SortingRecord *)[leadprofile_section_1 objectAtIndex:i]).item];
            }else{
                sortingstring=[NSString stringWithFormat:@"%@,%@#%@",sortingstring,((SortingRecord *)[leadprofile_section_1 objectAtIndex:i]).order,((SortingRecord *)[leadprofile_section_1 objectAtIndex:i]).item];
            }
        }
        
        globalvariables.centerrecord.leadnamedisplayorder=[[NSMutableArray alloc]initWithArray:[sortingstring componentsSeparatedByString:@","]];
        //[MyClass updatelocaldbwithparameter:@"leadnamedisplayorder" value:sortingstring];
        [MyClass updateCenterInformationWithField:@"leadnamedisplayorder" Value:sortingstring];
        //globalvariables.centerrecord.leadnamedisplayorder=sortingstring;
    }else if ([type isEqualToString:@"timetable"]){
        for (int i=0; i<classtimetable_parameters_1.count; i++) {
            if (i==0) {
                sortingstring=[NSString stringWithFormat:@"%@#%@",((SortingRecord *)[classtimetable_parameters_1 objectAtIndex:i]).order,((SortingRecord *)[classtimetable_parameters_1 objectAtIndex:i]).item];
            }else{
                sortingstring=[NSString stringWithFormat:@"%@,%@#%@",sortingstring,((SortingRecord *)[classtimetable_parameters_1 objectAtIndex:i]).order,((SortingRecord *)[classtimetable_parameters_1 objectAtIndex:i]).item];
            }
        }
        
        globalvariables.centerrecord.timetablefielddisplayorder=[[NSMutableArray alloc]initWithArray:[sortingstring componentsSeparatedByString:@","]];
        //[MyClass updatelocaldbwithparameter:@"leadnamedisplayorder" value:sortingstring];
        [MyClass updateCenterInformationWithField:@"timetablefielddisplayorder" Value:sortingstring];
        //globalvariables.centerrecord.leadnamedisplayorder=sortingstring;
    }
    

}

-(NSString *) returnstudentnamedisplayorderstring
{
    NSMutableArray *resultarray=[[NSMutableArray alloc]init];
    for (int i=0; i<studentprofile_section_1.count; i++) {
        if ([((SortingRecord *)[studentprofile_section_1 objectAtIndex:i]).order isEqualToString:@"e"]) {
            [resultarray addObject:[MyClass returntitlewithtitle:[self returnsortinglabelwithitem:((SortingRecord *)[studentprofile_section_1 objectAtIndex:i]).item]]];
        }
    }
    return [resultarray componentsJoinedByString:@" "];
}

-(NSString *) returnleadnamedisplayorderstring
{
    NSMutableArray *resultarray=[[NSMutableArray alloc]init];
    for (int i=0; i<leadprofile_section_1.count; i++) {
        if ([((SortingRecord *)[leadprofile_section_1 objectAtIndex:i]).order isEqualToString:@"e"]) {
            [resultarray addObject:[MyClass returntitlewithtitle:[self returnsortinglabelwithitem:((SortingRecord *)[leadprofile_section_1 objectAtIndex:i]).item]]];
        }
    }
    return [resultarray componentsJoinedByString:@" "];
}

-(NSMutableArray *) returntimetabledisplayorderarray
{
    //NSString *sortingstring=globalvariables.centerrecord.studentnamedisplayorder;
    NSMutableArray *tmpsortingstringarray=[[NSMutableArray alloc]initWithArray:globalvariables.centerrecord.timetablefielddisplayorder];
    NSMutableArray *tmpsortingarray=[[NSMutableArray alloc]init];
    NSString *item;
    NSString *order;
    
    for (int i=0; i<tmpsortingstringarray.count; i++) {
        order=[[tmpsortingstringarray objectAtIndex:i] substringToIndex:1];
        item=[[tmpsortingstringarray objectAtIndex:i] substringFromIndex:2];
        [tmpsortingarray addObject:[[SortingRecord alloc]initSortingRecordwithItem:item Order:order]];
    }
    
    return tmpsortingarray;
}

-(NSMutableArray *) returnstudentnamedisplayorderarray
{
    //NSString *sortingstring=globalvariables.centerrecord.studentnamedisplayorder;
    NSMutableArray *tmpsortingstringarray=[[NSMutableArray alloc]initWithArray:globalvariables.centerrecord.studentnamedisplayorder];
    NSMutableArray *tmpsortingarray=[[NSMutableArray alloc]init];
    NSString *item;
    NSString *order;
    
    for (int i=0; i<tmpsortingstringarray.count; i++) {
        order=[[tmpsortingstringarray objectAtIndex:i] substringToIndex:1];
        item=[[tmpsortingstringarray objectAtIndex:i] substringFromIndex:2];
        [tmpsortingarray addObject:[[SortingRecord alloc]initSortingRecordwithItem:item Order:order]];
    }
    
    return tmpsortingarray;
}

-(NSMutableArray *) returnleadnamedisplayorderarray
{
    //NSString *sortingstring=globalvariables.centerrecord.leadnamedisplayorder;
    NSMutableArray *tmpsortingstringarray=[[NSMutableArray alloc]initWithArray:globalvariables.centerrecord.leadnamedisplayorder];
    NSMutableArray *tmpsortingarray=[[NSMutableArray alloc]init];
    NSString *item;
    NSString *order;
    
    for (int i=0; i<tmpsortingstringarray.count; i++) {
        order=[[tmpsortingstringarray objectAtIndex:i] substringToIndex:1];
        item=[[tmpsortingstringarray objectAtIndex:i] substringFromIndex:2];
        [tmpsortingarray addObject:[[SortingRecord alloc]initSortingRecordwithItem:item Order:order]];
    }
    
    return tmpsortingarray;
}

-(NSString *) returnsortinglabelwithitem:(NSString *)item
{
    if ([item isEqualToString:@"firstname"]) {
        return @"First name";
    }else if ([item isEqualToString:@"lastname"]) {
        return @"Last name";
    }else if ([item isEqualToString:@"othername"]) {
        return @"Other name";
    }else if ([item isEqualToString:@"leadid"]) {
        return @"Lead ID";
    }else if ([item isEqualToString:@"studentid"]) {
        return @"Student ID";
    }else if ([item isEqualToString:@"student"]) {
        return @"Student";
    }else if ([item isEqualToString:@"classroom"]) {
        return @"Classroom";
    }else if ([item isEqualToString:@"instructor"]) {
        return @"Instructor";
    }else if ([item isEqualToString:@"level"]) {
        return @"Level";
    }else if ([item isEqualToString:@"subject"]) {
        return @"Subject";
    }
    return item;
}

- (void)editprintlogobuttonpressed:(UIButton *)button{
    
    imageuploadtype=@"printlogo";
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (hasCamera) {
        [self popupaddphotodialogueboxwithoption:@"add" button:button];
    }else{
        [self addphotofromsource:@"library" button:button];
    }
}

-(void) popupaddphotodialogueboxwithoption:(NSString *)option button:(UIButton *)button
{
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"PhotoSource" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 80) View:self Button:button ItemsArray:[[NSMutableArray alloc]initWithObjects:@"Take Photo",@"Photo Library", nil] Title:nil];
}

-(void) addphotofromsource:(NSString *)source button:(UIButton *)button
{
    imagepicker = [[UIImagePickerController alloc] init];
    imagepicker.delegate = self;
    imagepicker.allowsEditing=NO;
    
    
    
    if ([source isEqualToString:@"camera"]) {
        [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagepicker.view.frame = CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height);
        [self.view addSubview:imagepicker.view];
        
        self.navigationItem.leftBarButtonItem.enabled=NO;
        self.navigationItem.rightBarButtonItem.enabled=NO;
        self.navigationItem.title=[MyClass returntitlewithtitle:@"Take Photo"];
        
        
    }else{
        [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagepicker.modalPresentationStyle=UIModalPresentationPopover;
        myPopoverController=imagepicker.popoverPresentationController;
        //myPopoverController.delegate=self;
        myPopoverController.permittedArrowDirections=UIPopoverArrowDirectionAny;
        myPopoverController.sourceView=button;
        myPopoverController.sourceRect=button.bounds;
        
        [self presentViewController:imagepicker animated:YES completion:nil];
    }
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"PhotoSource"]) {
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"Take Photo"]) {
            [self takephotobuttonpressedwithbutton:button];
        }else if ([result isEqualToString:@"Photo Library"]){
            [self photolibrarybuttonpressedwithbutton:button];
        }
    }else if ([datatype isEqualToString:@"an_daybeforeevent"]){
        NSString *item=[selecteditems firstObject];
        AutoNotificationSettingsRecord *record=[selectedansettingsarray objectAtIndex:dataindex];
        NSString *daybeforeevent=record.paymentreminder?item:[@([item integerValue]*-1) stringValue];
        if ([self updateAutoNotificationSettingsWithAnSettingKey:record.ansettingkey Key:@"day_before_event" Value:daybeforeevent]) {
            record.day_before_event=daybeforeevent;
            [settingstable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    }else if ([datatype isEqualToString:@"an_repeatday"]){
        NSString *item=[selecteditems firstObject];
        AutoNotificationSettingsRecord *record=[selectedansettingsarray objectAtIndex:dataindex];
        if ([self updateAutoNotificationSettingsWithAnSettingKey:record.ansettingkey Key:@"repeat_day" Value:item]) {
            record.repeat_day=item;
            [settingstable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    }else if ([datatype isEqualToString:@"an_scheduletime"]){
        NSString *item=[selecteditems firstObject];
        NSString *scheduletime=[item substringToIndex:2];
        AutoNotificationSettingsRecord *record=[selectedansettingsarray objectAtIndex:dataindex];
        if ([self updateAutoNotificationSettingsWithAnSettingKey:record.ansettingkey Key:@"schedule_time" Value:scheduletime]) {
            record.schedule_time=scheduletime;
            [settingstable reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }
    }else if ([datatype isEqualToString:@"classstarttime"]){
        NSString *item=[selecteditems firstObject];
        if ([item integerValue] >[globalvariables.centerrecord.classendtime integerValue]) {
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Start Time"] message:[MyClass returntitlewithtitle:@"Cannot be later than class end time"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
            
        }else{
            globalvariables.centerrecord.classstarttime=item;
            [MyClass updateCenterInformationWithField:@"classstarttime" Value:item];
            [classtimetable reloadData];
        }
    }else if ([datatype isEqualToString:@"classendtime"]){
        NSString *item=[selecteditems firstObject];
        if ([item integerValue]<[globalvariables.centerrecord.classstarttime integerValue]) {
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class End Time"] message:[MyClass returntitlewithtitle:@"Cannot be earlier than class start time"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
        }else{
            globalvariables.centerrecord.classendtime=item;
            [MyClass updateCenterInformationWithField:@"classendtime" Value:item];
            [classtimetable reloadData];
        }
    }else if ([datatype isEqualToString:@"classtimeinterval"]){
        NSString *item=[selecteditems firstObject];
        globalvariables.centerrecord.classtimeinterval=item;
        [MyClass updateCenterInformationWithField:@"classtimeinterval" Value:item];
        [classtimetable reloadData];
    }else if ([datatype isEqualToString:@"EvaluationSubject"]){
        AssessmentFormListObject *obj=[evaluationformlistarray objectAtIndex:dataindex];
        obj.subjectarray=selecteditems;
        MyTableViewCell *cellView=[evaluationformtable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:dataindex inSection:2]];
        
        if(!obj.subjectarray){
            cellView.label2.text=[MyClass returntitlewithtitle:@"None"];
        }else if(obj.subjectarray.count==0){
            cellView.label2.text=[MyClass returntitlewithtitle:@"All Subjects"];
        }else{
            cellView.label2.text=[MyClass returnsubjectnamewithsubjectkeys:obj.subjectarray];
        }
        [self updateEvaluationForm:obj];
        [evaluationformtable beginUpdates];
        [evaluationformtable endUpdates];
    }else if ([datatype isEqualToString:@"EvaluationGrade"]){
        AssessmentFormListObject *obj=[evaluationformlistarray objectAtIndex:dataindex];
        obj.gradearray=selecteditems;
        MyTableViewCell *cellView=[evaluationformtable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:dataindex inSection:2]];
        
        if(!obj.gradearray){
            cellView.label3.text=[MyClass returntitlewithtitle:@"None"];
        }else if(obj.gradearray.count==0){
            cellView.label3.text=[MyClass returntitlewithtitle:@"All Grades"];
        }else{
            cellView.label3.text=[obj.gradearray componentsJoinedByString:@" | "];
        }
        [self updateEvaluationForm:obj];
        [evaluationformtable beginUpdates];
        [evaluationformtable endUpdates];
    }else if ([datatype isEqualToString:@"colorscheme"]){
        NSString *item=[selecteditems firstObject];
        globalvariables.centerrecord.parentappcolorschemekey=[item integerValue];
        [MyClass updateCenterInformationWithField:@"parentappcolorschemekey" Value:item];
        [iparenttable reloadData];
    }else if ([datatype isEqualToString:@"qrcoderefreshfrequency"]){
        NSString *item=[selecteditems firstObject];
        if (dataindex==0) {
            globalvariables.centerrecord.center_qrcode_refresh_minute=item;
            [MyClass updateCenterInformationWithField:@"center_qrcode_refresh_minute" Value:item];
            [centerqrcodetable reloadData];
        }else{
            globalvariables.centerrecord.attendance_qrcode_refresh_minute=item;
            [MyClass updateCenterInformationWithField:@"attendance_qrcode_refresh_minute" Value:item];
            [centerqrcodetable reloadData];
        }
    }
}

-(void) photolibrarybuttonpressedwithbutton:(UIButton *)button
{
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addphotofromsource:@"library" button:button];
}

-(void) takephotobuttonpressedwithbutton:(UIButton *)button
{
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addphotofromsource:@"camera" button:button];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    runviewdidappear=FALSE;
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    [imagepicker dismissViewControllerAnimated:YES completion:nil];
    [imagepicker.view removeFromSuperview];
    [MyClass loadingindicatorwithoption:@"start" color:@"gray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([imageuploadtype isEqualToString:@"tierimage"]){
            UIImage *resizedImage=[MyClass resizeImageWithImage:chosenImage ForSize:CGSizeMake(400, 400)];
            NSData *imagedata = UIImagePNGRepresentation(resizedImage);
            [self uploadtierimagewithtierkey:selectedtierrecord.tierkey imagedata:imagedata];
            [self retrieveMembershipTierSettings];
            [membershiptable reloadData];
        }else{
            NSData *imagedata=[[NSData alloc]initWithData:UIImagePNGRepresentation(chosenImage)];
            tmpprintlogoimagedata=imagedata;
            [self uploadcenterimagewithtype:@"printlogo" imagedata:imagedata];
            [MyClass getLatestDataSetv2withParameters:@"" Centerkeys:@"" completionBlock:nil];
            NSRange range = NSMakeRange(0, 1);
            NSIndexSet *section = [NSIndexSet indexSetWithIndexesInRange:range];
            [printingtable reloadSections:section withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [MyClass loadingindicatorwithoption:@"stop" color:@""];
    });
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    runviewdidappear=FALSE;
    //if ([myPopoverController presentingViewController].isBeingPresented) {
        [imagepicker dismissViewControllerAnimated:YES completion:nil];
    [imagepicker.view removeFromSuperview];
    
    
//    [self.view addSubview:imagepicker.view];
    
    /*}else{
        [imagepicker.view removeFromSuperview];
    }*/
}

-(void) uploadtierimagewithtierkey:(NSString *)tierkey imagedata:(NSData *)imagedata
{
    
    //NSData *imageData = imagedata;     //change Image to NSData
    
    if (imagedata != nil){
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSMutableData *body = [NSMutableData data];
        
        // add parameters
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"filenames\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //add image data
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@##tierimage_%@_%@.png\"\r\n",globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,tierkey] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imagedata]];
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
//                [MyClass removeImageFromCacheWithType:@"tierimage" TypeKey:tierkey];
            }
        }];
    }
}
     
-(void) uploadcenterimagewithtype:(NSString *)type imagedata:(NSData *)imagedata
{

        NSData *imageData = imagedata;     //change Image to NSData
        
        if (imageData != nil){
            //NSString *urlString =[NSString stringWithFormat:@"%@",globalvariables.generalphpfullpath];
            
            //NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
            //[request setURL:[NSURL URLWithString:urlString]];
            //[request setHTTPMethod:@"POST"];
            
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
            
            /*
            // close form
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
            [request setHTTPBody:body];
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                NSString *returnString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSLog(@"File uploaded: %@",returnString);
                dispatch_semaphore_signal(semaphore);
            }] resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
            
        }
    
}

-(NSString *) getlaststudentgradepromotiontimestamp
{
    
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getlaststudentgradepromotiontimestamp",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey];
    __block NSString *resultstring;

    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            NSString * timestamp=[[JSONArray objectAtIndex:0] objectForKey:@"timestamp"];
            if ([timestamp isEqualToString:@""]) {
                resultstring= [MyClass returntitlewithtitle:@"Never run"];
            }else{
                resultstring= [NSString stringWithFormat:@"%@%@",[MyClass returntitlewithtitle:@"Last run on"],[MyClass returndateformatDDMMMYYYYHHMMSSwithdate:[MyClass convertYYYYMMDDHHMMSStoDDMMMYYYYHHMMSSwithdatetime:timestamp]]];
            }
        }else{
            resultstring = [MyClass returntitlewithtitle:@"Error"];
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            NSString * timestamp=[[JSONArray objectAtIndex:0] objectForKey:@"timestamp"];
            if ([timestamp isEqualToString:@""]) {
                resultstring= [MyClass returntitlewithtitle:@"Never run"];
            }else{
                resultstring= [NSString stringWithFormat:@"%@%@",[MyClass returntitlewithtitle:@"Last run on"],[MyClass returndateformatDDMMMYYYYHHMMSSwithdate:[MyClass convertYYYYMMDDHHMMSStoDDMMMYYYYHHMMSSwithdatetime:timestamp]]];
            }
        }else{
            resultstring = [MyClass returntitlewithtitle:@"Error"];
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
    return resultstring;
}

-(void) promotestudentgrade
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=promotestudentgrade&updatedby=%@&recalculatetuitionfee=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,globalvariables.username,[MyClass getlocaldbwithparameter:@"recalculatetuitionfeeupongradepromotion"]];
    
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
        }else{
            [MyClass showconnectionlostdialogbox];
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {

        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Promote Student School Grade"] message:[MyClass returntitlewithtitle:@"Grade promoted successfully"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [erroralert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [erroralert addAction:OKAction];
        [self presentViewController:erroralert animated:YES completion:nil];
        [studentprofiletable reloadData];
    }
}

-(NSMutableDictionary *) retrieveAutoNotificationSettings
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getautonotificationsettings",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey];
    
    __block BOOL result=FALSE;
    __block NSMutableDictionary *tmpansettingsdictionary=[[NSMutableDictionary alloc]init];
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *JSONArray = jsonreturned[@"content"];
            
            for (int i=0; i<JSONArray.count; i++) {
                NSString * cansettingkey=[[JSONArray objectAtIndex:i] objectForKey:@"ansettingkey"];
                NSString * cmessage_type=[[JSONArray objectAtIndex:i] objectForKey:@"message_type"];
                NSString * cschedule_time=[[JSONArray objectAtIndex:i] objectForKey:@"schedule_time"];
                NSString * cday_before_event=[[JSONArray objectAtIndex:i] objectForKey:@"day_before_event"];
                NSString * crepeat_day=[[JSONArray objectAtIndex:i] objectForKey:@"repeat_day"];
                NSString * cchannel=[[JSONArray objectAtIndex:i] objectForKey:@"channel"];
                NSString * cmessage_en=[[JSONArray objectAtIndex:i] objectForKey:@"message_en"];
                NSString * cmessage_zh=[[JSONArray objectAtIndex:i] objectForKey:@"message_zh"];
                BOOL cenable=[[[JSONArray objectAtIndex:i] objectForKey:@"enable"] isEqualToString:@"Y"];
                BOOL cpaymentreminder=[cday_before_event integerValue]>0;
                
                NSMutableArray *typearray=[tmpansettingsdictionary valueForKey:cmessage_type];
                if (typearray) {
                    [typearray addObject:[[AutoNotificationSettingsRecord alloc]initAutoNotificationSettingsRecordwithansettingkey:cansettingkey message_type:cmessage_type schedule_time:cschedule_time day_before_event:cday_before_event repeat_day:crepeat_day channel:cchannel message_en:cmessage_en message_zh:cmessage_zh enable:cenable paymentreminder:cpaymentreminder]];
                }else{
                    [tmpansettingsdictionary setValue:[[NSMutableArray alloc]initWithObjects:[[AutoNotificationSettingsRecord alloc]initAutoNotificationSettingsRecordwithansettingkey:cansettingkey message_type:cmessage_type schedule_time:cschedule_time day_before_event:cday_before_event repeat_day:crepeat_day channel:cchannel message_en:cmessage_en message_zh:cmessage_zh enable:cenable paymentreminder:cpaymentreminder], nil] forKey:cmessage_type];
                }
            }
        }
    }];
    
    return tmpansettingsdictionary;
}

-(void) retrieveMembershipTierSettings
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getmembershiptiersettings",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey];
    
    __block BOOL result=FALSE;
    membershiptierarray=[[NSMutableArray alloc]init];
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *JSONArray = jsonreturned[@"content"];
            
            for (int i=0; i<JSONArray.count; i++) {
                NSString * ctierkey=[[JSONArray objectAtIndex:i] objectForKey:@"tierkey"];
                NSString * ctitle=[[JSONArray objectAtIndex:i] objectForKey:@"title"];
                NSString * ctitle_chinese=[[JSONArray objectAtIndex:i] objectForKey:@"title_chinese"];
                NSString * crequirement=[[JSONArray objectAtIndex:i] objectForKey:@"requirement"];
                NSString * cpointmultiplier=[[JSONArray objectAtIndex:i] objectForKey:@"pointmultiplier"];
                NSString * cbirthdaypoint=[[JSONArray objectAtIndex:i] objectForKey:@"birthdaypoint"];
                NSString * cimage=[[JSONArray objectAtIndex:i] objectForKey:@"image"];
                
                [membershiptierarray addObject:[[MembershipTierRecord alloc]initMembershipTierRecordRecordwithtierkey:ctierkey title:ctitle title_chinese:ctitle_chinese requirement:crequirement pointmultiplier:cpointmultiplier birthdaypoint:cbirthdaypoint image:cimage totalspending:@""]];
            }
        }
    }];
}

-(void) updatesettingsRowDataArray
{
    settingsRowDataArray=[[NSMutableArray alloc]init];
//    if (membershipview.hidden) {
        ansettingsdictionary=[self retrieveAutoNotificationSettings];
        selectedansettingsarray=[ansettingsdictionary valueForKey:[self returnAutoNotificationMessageTypeWithType:selectedantype]];
        for (int i=0; i<selectedansettingsarray.count; i++) {
            [settingsRowDataArray addObject:@"Auto Notification Settings"];
        }

}

-(AutoNotificationSettingsRecord *) returnAutoNotificationSettingsRecordWithType:(NSInteger)type Row:(NSInteger)row
{
    NSMutableArray *anarray=[ansettingsdictionary valueForKey:[self returnAutoNotificationMessageTypeWithType:type]];
    return [anarray objectAtIndex:row];
}

-(NSString *) returnAutoNotificationMessageTypeWithType:(NSInteger)type
{
    NSString *message_type;
    if (type==3) {
        message_type=@"firstclass";
    }else if (type==4){
        message_type=@"dt";
    }else if (type==2){
        message_type=@"renewal";
    }else if (type==0){
        message_type=@"payment";
    }else if (type==1){
        message_type=@"salespayment";
    }
    return message_type;
}

-(NSString *) returndaytitlewithday:(NSString *)day
{
    //NSLog(@"%d %d",[day intValue],abs([day intValue]));
    if (abs([day intValue])>1) {
        return [MyClass returnreplacedtitlewithtitle:@"%@1 days" replacementarray:@[[@(abs([day intValue])) stringValue]]];
    }else{
        return [MyClass returnreplacedtitlewithtitle:@"%@1 day" replacementarray:@[[@(abs([day intValue])) stringValue]]];
    }
}

-(void) updateAutoNotificationEnable:(UISwitch *)sender
{
    AutoNotificationSettingsRecord *record=[selectedansettingsarray objectAtIndex:sender.tag];
    if ([self updateAutoNotificationSettingsWithAnSettingKey:record.ansettingkey Key:@"enable" Value:sender.on?@"Y":@"N"]) {
        record.enable=sender.on;
    }
}

-(void) updateAutoNotificationDayBeforeEvent:(UIButton *)sender
{
    AutoNotificationSettingsRecord *record=[selectedansettingsarray objectAtIndex:sender.tag];
    NSMutableArray *itemarray=[[NSMutableArray alloc]init];
    for (int i=record.paymentreminder?1:0; i<=60; i++) {
        [itemarray addObject:[@(i) stringValue]];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:[@(labs([record.day_before_event integerValue])) stringValue],nil] DataType:@"an_daybeforeevent" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(100, 600) View:self Button:sender ItemsArray:itemarray Title:nil];
}

-(void) updateAutoNotificationRepeatDay:(UIButton *)sender
{
    NSMutableArray *itemarray=[[NSMutableArray alloc]init];
    for (int i=0; i<=30; i++) {
        [itemarray addObject:[@(i) stringValue]];
    }
    
    AutoNotificationSettingsRecord *record=[selectedansettingsarray objectAtIndex:sender.tag];
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:[@(labs([record.repeat_day integerValue])) stringValue],nil] DataType:@"an_repeatday" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(100, 600) View:self Button:sender ItemsArray:itemarray Title:nil];
    
    /*
    myPopover=[[NSPopover alloc]init];
    AutoNotificationSettingsRecord *record=[selectedansettingsarray objectAtIndex:sender.tag];
    [MyClass showPickerMenuWindowWithButton:sender DataType:@"an_repeatday" DataIndex:sender.tag itemArray:itemarray selectedItems:[[NSMutableArray alloc]initWithObjects:record.repeat_day,nil] windowWidth:100 showSearchView:NO showCarryOverButton:NO bottomButtonMode:nil multipleSelection:NO popover:myPopover view:self];*/
}

-(void) updateAutoNotificationScheduleTime:(UIButton *)sender
{
    NSMutableArray *itemarray=[[NSMutableArray alloc]init];
    for (int i=0; i<=23; i++) {
        [itemarray addObject:[NSString stringWithFormat:@"%02d:00",i]];
    }
    
    AutoNotificationSettingsRecord *record=[selectedansettingsarray objectAtIndex:sender.tag];
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:[NSString stringWithFormat:@"%@:00",record.schedule_time],nil] DataType:@"an_scheduletime" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(100, 600) View:self Button:sender ItemsArray:itemarray Title:nil];
}

-(void) selectAutoNotificationPaymentType:(UISegmentedControl *)sender
{
    AutoNotificationSettingsRecord *record=[selectedansettingsarray objectAtIndex:sender.tag];
    NSString *daybeforeevent=[@([record.day_before_event integerValue]*-1) stringValue];
    if ([daybeforeevent isEqualToString:@"0"] && sender.selectedSegmentIndex==0) {
        daybeforeevent=@"1";
    }
    if ([self updateAutoNotificationSettingsWithAnSettingKey:record.ansettingkey Key:@"day_before_event" Value:daybeforeevent]) {
        record.day_before_event=daybeforeevent;
        record.paymentreminder=!record.paymentreminder;
        [settingstable reloadData];
    }
}

-(void) selectAutoNotificationChannel:(UISegmentedControl *)sender
{
    AutoNotificationSettingsRecord *record=[selectedansettingsarray objectAtIndex:sender.tag];
    NSString *channel=[MyClass returnChannelCodeWithRecipientType:@"Student" Index:[@(sender.selectedSegmentIndex) stringValue]];
    if ([self updateAutoNotificationSettingsWithAnSettingKey:record.ansettingkey Key:@"channel" Value:channel]) {
        record.channel=channel;
    }
}

-(void) deleteAutoNotification:(UIButton *)sender
{
    AutoNotificationSettingsRecord *record=[selectedansettingsarray objectAtIndex:sender.tag];
    if ([self deleteAutoNotificationSettingsWithAnSettingKey:record.ansettingkey]) {
        [selectedansettingsarray removeObjectAtIndex:sender.tag];
        [self updatesettingsRowDataArray];
        [settingstable reloadData];
    }
}

-(void) addAutoNotification:(UIButton *)sender
{
    AutoNotificationSettingsRecord *record=[selectedansettingsarray objectAtIndex:sender.tag];
    NSString *ansettingkey=[self AddNewAutoNotificationSettingsWithAutoNotificationSettingsRecord:record];
    if (ansettingkey) {
        [selectedansettingsarray addObject:[[AutoNotificationSettingsRecord alloc]initAutoNotificationSettingsRecordwithansettingkey:ansettingkey message_type:record.message_type schedule_time:record.schedule_time day_before_event:record.day_before_event repeat_day:record.repeat_day channel:record.channel message_en:record.message_en message_zh:record.message_zh enable:record.enable paymentreminder:record.paymentreminder]];
        [self updatesettingsRowDataArray];
        [settingstable reloadData];
        
        NSInteger numberofrow=[settingstable numberOfRowsInSection:0];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberofrow-1 inSection:0];
        [settingstable scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

-(void) deleteMembershipTier:(UIButton *)sender
{
    MembershipTierRecord *record=[membershiptierarray objectAtIndex:sender.tag];
    if ([self deleteMembershipTierSettingsWithTierkey:record.tierkey]) {
        [membershiptierarray removeObjectAtIndex:sender.tag];
        [self retrieveMembershipTierSettings];
        [settingstable reloadData];
    }
}


-(BOOL) deleteMembershipTierSettingsWithTierkey:(NSString *)tierkey
{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:@"updatemembershiptiersettings" forKey:@"postaction"];
    [dictionary setValue:@"Delete" forKey:@"action"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:tierkey forKey:@"tierkey"];
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    return result;

}

-(void) addMembershipTier:(UIButton *)sender
{
    MembershipTierRecord *record=[membershiptierarray objectAtIndex:sender.tag];
    NSString *tierkey=[self AddNewMembershipTierSettingsWithMembershipTierSettingsRecord:record];
    if (tierkey) {
        [membershiptierarray addObject:[[MembershipTierRecord alloc]initMembershipTierRecordRecordwithtierkey:tierkey title:record.title title_chinese:record.title_chinese requirement:record.requirement pointmultiplier:record.pointmultiplier birthdaypoint:record.birthdaypoint image:record.image totalspending:@""]];
        [self retrieveMembershipTierSettings];
        [settingstable reloadData];
        
        NSInteger numberofrow=[settingstable numberOfRowsInSection:0];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:numberofrow-1 inSection:0];
        [settingstable scrollToRowAtIndexPath:indexPath
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

-(NSString *) AddNewMembershipTierSettingsWithMembershipTierSettingsRecord:(MembershipTierRecord *)record
{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:@"updatemembershiptiersettings" forKey:@"postaction"];
    [dictionary setValue:@"Add" forKey:@"action"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:record.title forKey:@"title"];
    [dictionary setValue:record.title_chinese forKey:@"title_chinese"];
    [dictionary setValue:record.requirement forKey:@"requirement"];
    [dictionary setValue:record.pointmultiplier forKey:@"pointmultiplier"];
    [dictionary setValue:record.birthdaypoint forKey:@"birthdaypoint"];
    
    __block BOOL result=FALSE;
    __block NSString *tierkey=nil;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            tierkey = jsonreturned[@"content"];
        }
    }];
    
    return tierkey;
}

-(void) changeclassstarttimebuttonpressed:(UIButton *)sender
{
    NSMutableArray *itemarray=[[NSMutableArray alloc]init];
    for (int i=0; i<=23; i++) {
        [itemarray addObject:[NSString stringWithFormat:@"%02d00",i]];
        [itemarray addObject:[NSString stringWithFormat:@"%02d30",i]];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:globalvariables.centerrecord.classstarttime,nil] DataType:@"classstarttime" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(100, 600) View:self Button:sender ItemsArray:itemarray Title:nil];
}

-(void) changeclassendtimebuttonpressed:(UIButton *)sender
{
    NSMutableArray *itemarray=[[NSMutableArray alloc]init];
    for (int i=0; i<=23; i++) {
        [itemarray addObject:[NSString stringWithFormat:@"%02d00",i]];
        [itemarray addObject:[NSString stringWithFormat:@"%02d30",i]];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:globalvariables.centerrecord.classendtime,nil] DataType:@"classendtime" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(100, 600) View:self Button:sender ItemsArray:itemarray Title:nil];
}

-(void) changeclasstimeintervalbuttonpressed:(UIButton *)sender
{
    NSMutableArray *itemarray=[[NSMutableArray alloc]init];
    [itemarray addObject:@"5"];
    [itemarray addObject:@"10"];
    [itemarray addObject:@"15"];
    [itemarray addObject:@"20"];
    [itemarray addObject:@"30"];
    [itemarray addObject:@"60"];

    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:globalvariables.centerrecord.classtimeinterval,nil] DataType:@"classtimeinterval" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(100, 600) View:self Button:sender ItemsArray:itemarray Title:nil];
}


-(void) changecenter_qrcode_refresh_minute:(UIButton *)sender
{
    NSMutableArray *itemarray=[[NSMutableArray alloc]init];
    [itemarray addObject:@"30"];
    [itemarray addObject:@"60"];
    [itemarray addObject:@"120"];
    [itemarray addObject:@"PD"];
    [itemarray addObject:@"PM"];
    [itemarray addObject:@""];
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:globalvariables.centerrecord.center_qrcode_refresh_minute,nil] DataType:@"qrcoderefreshfrequency" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(120, 255) View:self Button:sender ItemsArray:itemarray Title:nil];
}

-(void) changeattendance_qrcode_refresh_minute:(UIButton *)sender
{
    NSMutableArray *itemarray=[[NSMutableArray alloc]init];
    [itemarray addObject:@"30"];
    [itemarray addObject:@"60"];
    [itemarray addObject:@"120"];
    [itemarray addObject:@"PD"];
    [itemarray addObject:@"PM"];
    [itemarray addObject:@""];
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:globalvariables.centerrecord.attendance_qrcode_refresh_minute,nil] DataType:@"qrcoderefreshfrequency" DataIndex:1 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(120, 255) View:self Button:sender ItemsArray:itemarray Title:nil];
}

-(BOOL) updateMembershipTierSettingsWithTierkey:(NSString *)tierkey Key:(NSString *)key Value:(NSString *)value
{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:@"updatemembershiptiersettings" forKey:@"postaction"];
    [dictionary setValue:@"Edit" forKey:@"action"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:tierkey forKey:@"tierkey"];
    [dictionary setValue:value forKey:key];
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    return result;

}

-(BOOL) updateAutoNotificationSettingsWithAnSettingKey:(NSString *)ansettingkey Key:(NSString *)key Value:(NSString *)value
{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:@"updateautonotificationsettings" forKey:@"postaction"];
    [dictionary setValue:@"Edit" forKey:@"action"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:ansettingkey forKey:@"ansettingkey"];
    [dictionary setValue:value forKey:key];
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    return result;

}

-(BOOL) deleteAutoNotificationSettingsWithAnSettingKey:(NSString *)ansettingkey
{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:@"updateautonotificationsettings" forKey:@"postaction"];
    [dictionary setValue:@"Delete" forKey:@"action"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:ansettingkey forKey:@"ansettingkey"];
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    return result;

}

-(NSString *) AddNewAutoNotificationSettingsWithAutoNotificationSettingsRecord:(AutoNotificationSettingsRecord *)ansrecord
{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:@"updateautonotificationsettings" forKey:@"postaction"];
    [dictionary setValue:@"Add" forKey:@"action"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:ansrecord.message_type forKey:@"message_type"];
    [dictionary setValue:ansrecord.enable?@"Y":@"N" forKey:@"enable"];
    [dictionary setValue:ansrecord.schedule_time forKey:@"schedule_time"];
    [dictionary setValue:ansrecord.day_before_event forKey:@"day_before_event"];
    [dictionary setValue:ansrecord.repeat_day forKey:@"repeat_day"];
    [dictionary setValue:ansrecord.channel forKey:@"channel"];
    [dictionary setValue:ansrecord.message_en forKey:@"message_en"];
    [dictionary setValue:ansrecord.message_zh forKey:@"message_zh"];
    
    __block BOOL result=FALSE;
    __block NSString *ansettingkey=nil;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            ansettingkey = jsonreturned[@"content"];
        }
    }];
    
    return ansettingkey;
}

-(void) getevaluationformlist
{
    GlobalVariables *globalvariables;
    globalvariables=[GlobalVariables singleObj];
    
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getassessmentformlist&status=All",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey];
    
    __block BOOL result=FALSE;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *jsonArray = jsonreturned[@"content"];
            evaluationformlistarray=[[NSMutableArray alloc]init];

            for (int i=0; i<jsonArray.count; i++) {
                NSString *cformkey=[[jsonArray objectAtIndex:i] objectForKey:@"formkey"];
                NSString *cformname=[[jsonArray objectAtIndex:i] objectForKey:@"formname"];
                NSString *cformtype=[[jsonArray objectAtIndex:i] objectForKey:@"formtype"];
                NSString *csubjectkeys=[[jsonArray objectAtIndex:i] objectForKey:@"subjectkeys"];
                BOOL cactive=[[[jsonArray objectAtIndex:i] objectForKey:@"active"] isEqualToString:@"Yes"];
                NSString *cgrades=[[jsonArray objectAtIndex:i] objectForKey:@"grades"];
                NSString *cremarks=[[jsonArray objectAtIndex:i] objectForKey:@"remarks"];
                
                [evaluationformlistarray addObject:[[AssessmentFormListObject alloc]initAssessmentFormListObjectwithFormKey:cformkey FormName:cformname LastSubmittedTime:nil Submitter:nil formType:cformtype subjectarray:[csubjectkeys isEqualToString:@""]?[[NSMutableArray alloc]init]:[csubjectkeys isEqualToString:@"!!None!!"]?nil:[[NSMutableArray alloc]initWithArray:[csubjectkeys componentsSeparatedByString:@"|"]] active:cactive gradearray:[cgrades isEqualToString:@""]?[[NSMutableArray alloc]init]:[cgrades isEqualToString:@"!!None!!"]?nil:[[NSMutableArray alloc]initWithArray:[cgrades componentsSeparatedByString:@"|"]] remarks:cremarks]];
            }
        }
    }];
    
    evaluationform_parameters_2=[[NSMutableArray alloc]init];
    for (int i=0; i<evaluationformlistarray.count; i++) {
        [evaluationform_parameters_2 addObject:@"evaluationform"];
    }
}

-(void) updateEvaluationForm:(AssessmentFormListObject *)object
{
    NSDictionary *dictionary = @{@"formkey" : object.formkey,
                                 @"subjectkeys" : object.subjectarray?object.subjectarray.count==0?@"":[object.subjectarray componentsJoinedByString:@"|"]:@"!!None!!",
                                 @"grades" : object.gradearray?object.gradearray.count==0?@"":[object.gradearray componentsJoinedByString:@"|"]:@"!!None!!",
                                 @"active" : object.active?@"Yes":@"No",
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"postaction" : @"updateevaluationform"
                                 };
//    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray * JSONArray = jsonreturned[@"content"];
            
//            if ([[[JSONArray objectAtIndex:0] objectForKey:@"result"] isEqualToString:@"success"]) {
//                result= TRUE;
//            }
        }
    }];

}

-(UIColor *) returnappcolorschememaincolor
{
    ColorScheme *colorscheme;
    for (int i=0; i<appcolorschemearray.count; i++) {
        colorscheme=[appcolorschemearray objectAtIndex:i];
        if ([colorscheme.colorschemekey isEqualToString:[@(globalvariables.centerrecord.parentappcolorschemekey) stringValue]]) {
            return colorscheme.main_color;
        }
    }
    return [UIColor orangeColor];
}

-(void) getappcolorscheme
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getappcolorscheme",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey];
    
    __block BOOL result=FALSE;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *jsonArray = jsonreturned[@"content"];
            appcolorschemearray=[[NSMutableArray alloc]init];

            for (int i=0; i<jsonArray.count; i++) {
                NSString *colorschemekey=[[jsonArray objectAtIndex:i] objectForKey:@"colorschemekey"];
                CGFloat red=[[[jsonArray objectAtIndex:i] objectForKey:@"red"] floatValue]/255.0;
                CGFloat green=[[[jsonArray objectAtIndex:i] objectForKey:@"green"] floatValue]/255.0;
                CGFloat blue=[[[jsonArray objectAtIndex:i] objectForKey:@"blue"] floatValue]/255.0;
                CGFloat alpha=[[[jsonArray objectAtIndex:i] objectForKey:@"alpha"] floatValue];
                
                [appcolorschemearray addObject:[[ColorScheme alloc]initColorSchemeWithColorSchemeKey:colorschemekey colorScheme:[UIColor colorWithRed:red green:green blue:blue alpha:alpha]]];
            }
        }
    }];
}


@end
