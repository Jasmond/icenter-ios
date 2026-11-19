//
//  SettingsViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 5/15/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
#import "MainViewController.h"
#import "SwitchCenterViewController.h"
#import "WhatsNewViewController.h"
#import "PickerViewController.h"

@interface SettingsViewController : UIViewController<mySwitchCenterViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,myWhatsNewViewControllerDelegate,myPickerViewControllerDelegate>
{

    
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;
    
    BOOL runviewdidappear;
    //sqlite3 *isdb;

    NSString *origproductionserveraddress;
    NSString *origdrserveraddress;
    
    UIView *headertitleview;
    UILabel *headertitlename;
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;

    
    SwitchCenterViewController *switchcenterviewcontroller;
    

    
    __weak IBOutlet UITableView *menutable;
    __weak IBOutlet UITableView *settingstable;
    //UITableView *menutable;
    NSArray *menuitem_section_0;
    NSArray *menuitem_section_1;
    NSArray *menuitem_section_2;
    NSArray *menuitem_section_3;
    NSArray *menuitem_section_4;
    NSArray *menuitem_section_5;
    NSArray *menuitem_section_6;

    UIView *studentprofileview;
    UITableView *studentprofiletable;
    NSArray *studentprofile_section_0;
    NSMutableArray *studentprofile_section_1;
    NSArray *studentprofile_section_2;
    NSArray *studentprofile_section_3;
    NSArray *studentprofile_section_4;
//    NSArray *studentprofile_section_5;
    SortingRecord *sortingobject;

    UIView *leadprofileview;
    UITableView *leadprofiletable;
    NSArray *leadprofile_section_0;
    NSMutableArray *leadprofile_section_1;
    NSArray *leadprofile_section_2;
    
    
    UIView *notificationview;
    UITableView *notificationtable;
    NSArray *notification_section_0;
    NSArray *notification_section_class;
    //NSArray *notification_section_message;
    //NSArray *notification_section_task;
    NSArray *notification_class_parameters;
    //NSArray *notification_message_parameters;
    //NSArray *notification_task_parameters;
    
    UIView *attendanceview;
    UITableView *attendancetable;
    NSArray *attendance_parameters_0;
    NSArray *attendance_parameters_1;
    NSArray *attendance_parameters_2;
    NSArray *attendance_parameters_3;

    UIView *financialview;
    UITableView *financialtable;
    NSArray *financial_parameters_0;
    NSArray *financial_parameters_1;
    NSArray *financial_parameters_2;
    NSArray *financial_parameters_3;
    NSArray *financial_parameters_4;
    NSArray *financial_parameters_5;
    NSArray *financial_parameters_6;
    NSArray *financial_parameters_7;
    NSMutableArray *financial_parameters_8;
    
    UIView *photocornerview;
    UITableView *photocornertable;
    NSArray *photocorner_parameters_0;

    UIView *messagecenterview;
    UITableView *messagecentertable;
    NSArray *messagecenter_parameters_0;
    NSArray *messagecenter_parameters_1;
    
    UIView *calendarview;
    UITableView *calendartable;
    NSArray *calendar_parameters_0;

    UIView *enrollmentview;
    UITableView *enrollmenttable;
    NSArray *enrollment_parameters_0;
    NSArray *enrollment_parameters_1;
    NSArray *enrollment_parameters_2;
    NSArray *enrollment_parameters_3;
    NSArray *enrollment_parameters_4;
    NSArray *enrollment_parameters_5;
//    NSArray *enrollment_parameters_5;
//    NSArray *enrollment_parameters_6;
    
    UIView *istaffview;
    UITableView *istafftable;
    NSArray *istaff_parameters_0;
    
    UIView *useraccountview;
    UITableView *useraccounttable;
    NSArray *useraccount_parameters_0;
    
    UIView *iparentview;
    UITableView *iparenttable;
    NSArray *iparent_parameters_0;
    NSArray *iparent_parameters_1;
    NSArray *iparent_parameters_2;
    NSArray *iparent_parameters_3;
    NSArray *iparent_parameters_4;
    NSArray *iparent_parameters_5;
    NSArray *iparent_parameters_6;
    NSArray *iparent_parameters_7;
    NSArray *iparent_parameters_8;
    NSArray *iparent_parameters_9;
    NSArray *iparent_parameters_10;
    
    UIView *generaleview;
    UITableView *generaltable;

    UIView *dailyscheduleview;
    UITableView *dailyscheduletable;
    NSArray *dailyschedule_parameters_0;
    NSArray *dailyschedule_parameters_1;

    UIView *classtimetableview;
    UITableView *classtimetable;
    NSArray *classtimetable_parameters_0;
    NSMutableArray *classtimetable_parameters_1;
    NSArray *classtimetable_parameters_2;
    NSArray *classtimetable_parameters_3;
    NSArray *classtimetable_parameters_4;
    
    UIView *courserenewalview;
    UITableView *courserenewaltable;
    NSArray *courserenewal_parameters_0;
    NSArray *courserenewal_parameters_1;
    NSArray *courserenewal_parameters_2;
    
    UIView *printingview;
    UITableView *printingtable;
    NSArray *printing_parameters_1;
    NSArray *printing_parameters_2;
    NSArray *printing_parameters_3;
    NSData *tmpprintlogoimagedata;
    UIImageView *tmpprintlogoimage;
    
    
    UIView *accountview;
    UITableView *accounttable;
    NSArray *account_parameters;
    
    __weak IBOutlet UIView *membershipview;
    __weak IBOutlet UITableView *membershiptable;
    NSArray *membership_parameters_0;
    NSArray *membership_parameters_1;
    
    UIView *courseview;
    UITableView *coursetable;
    NSArray *course_parameters_0;
    
    UIView *chatbotview;
    UITableView *chatbottable;
    NSArray *chatbot_parameters_0;
    
    __weak IBOutlet UIView *evaluationformview;
    __weak IBOutlet UITableView *evaluationformtable;
    NSArray *evaluationform_parameters_0;
    NSArray *evaluationform_parameters_1;
    NSMutableArray *evaluationform_parameters_2;
    NSMutableArray *evaluationformlistarray;
    NSMutableArray *subjectArray;

    __weak IBOutlet UIView *centerqrcodeview;
    __weak IBOutlet UITableView *centerqrcodetable;
    NSArray *centerqrcode_parameters_0;
    
    UITextField *oldpasswordtext;
    UITextField *newpasswordtext;
    UITextField *confirmpasswordtext;
    
    float keyboardheight;
    
    //UITextView *receipttnctext;
    //UITextView *invoicetnctext;
    
    UIPopoverPresentationController *myPopoverController;
    UIButton *editprintlogobutton;
    UIImagePickerController *imagepicker;
    
    NSMutableArray *arcodearray;
    
    NSMutableArray *settingsRowDataArray;
    NSMutableDictionary *ansettingsdictionary;
    NSMutableArray *selectedansettingsarray;
    NSInteger selectedantype;
    __weak IBOutlet UISegmentedControl *scAutoNotificationType;
    __weak IBOutlet NSLayoutConstraint *settingstablebottomconstraint;
    __weak IBOutlet NSLayoutConstraint *membershiptablebottomconstraint;
    
    NSMutableArray *appcolorschemearray;
    
    NSMutableArray *membershiptierarray;
    NSString *imageuploadtype;
    MembershipTierRecord *selectedtierrecord;
    
}

@property (nonatomic,strong) NSMutableArray *JSONArray;
@property (nonatomic,strong) NSMutableArray *ClassfeeArray;
@property (nonatomic,strong) ClassfeeRecord *ClassfeeObject;

- (IBAction)menubutton:(id)sender;
- (IBAction)selectAutoNotificationType:(id)sender;

@end
