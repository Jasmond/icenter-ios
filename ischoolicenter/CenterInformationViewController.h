//
//  CenterInformationViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 30/10/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
//#import "InstructorPopoverViewController.h"
#import "StaffPopoverViewController.h"
#import "SubjectPopoverViewController.h"
#import "ProductPopoverViewController.h"
#import "MarketingPopoverViewController.h"
#import "ClassroomPopoverViewController.h"
#import "MainViewController.h"
#import "SwitchCenterViewController.h"
#import "GCPlaceholderTextView.h"
#import "CalendarView.h"
#import "PickerViewController.h"
#import "GivenOutViewController.h"

@interface CenterInformationViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,myStaffPopoverViewControllerDelegate,UIPopoverPresentationControllerDelegate,mySubjectPopoverViewControllerDelegate,myProductPopoverViewControllerDelegate,myMarketingPopoverViewControllerDelegate,myClassroomPopoverViewControllerDelegate,mySwitchCenterViewControllerDelegate,UISearchBarDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,myCalendarViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource,myPickerViewControllerDelegate,myGivenOutViewControllerDelegate>{
    GlobalVariables *globalvariables;
    MainViewController *mainviewcontroller;
    BOOL runviewdidappear;
    
    UIView *calendarview;
    __weak IBOutlet UIView *policyview;
//    UIView *contactview;
    __weak IBOutlet UIView *contactview;
    UIScrollView *contactscrollview;
    __weak IBOutlet UIView *staffview;
    UIView *subscriptionview;
    __weak IBOutlet UIView *subjectview;
    __weak IBOutlet UIView *productview;
    __weak IBOutlet UIView *marketingview;
    __weak IBOutlet UIView *classroomview;

    
    NSArray *monthnameArray;
    NSArray *dayofweekArray;
    
    NSDateFormatter *df;
    
    long displayyear;
    UILabel *yeartitle;
    
    UIButton *daybutton;
    UIButton *previousyearbutton;
    UIButton *nextyearbutton;
    
    UISegmentedControl *scpolicy;
    
    __weak IBOutlet UITableView *policytable;
    
    
    PolicyRecord *policyrecordobject;
    
    NSMutableArray *JSONArray;
    
    NSMutableArray *policycategory;
    NSMutableArray *policyonecategory;
    NSMutableArray *policyallcategory;
    
    UIButton *selectionbutton;
    NSMutableArray *CenterArray;
    CenterRecord *centerobject;
    
    UILabel *centershortnamelabel;
    UILabel *centeraddresslabel;
    UILabel *centercontactlabel;
    UILabel *centeremaillabel;
    UILabel *centerwebsitelabel;
    UILabel *centerwhatsapplabel;
    UILabel *centerfaxlabel;
    UILabel *centerlatlonglabel;
    UIImageView *centercontacticonimage;
    UIImageView *centerfaxiconimage;
    UIImageView *centerwhatsappiconimage;
    UIImageView *centerlatlongiconimage;

    
    
    int presetrow;
    UILabel *centernamelabel;
    UILabel *schoolregnumberLabel;
    UILabel *schoolregnumberTitle;
    UIButton *centeremailbutton;
    UIButton *centerwebsitebutton;
    UIButton *centerothersbutton;
    
    
    UILabel *Subject_EnglishnameLabel;
    UILabel *Subject_ChinesenameLabel;
    UILabel *Subject_ShortnameLabel;
    UILabel *TuitionMethodLabel;
    UILabel *StudentCapacityLabel;
    UILabel *StandardNoOfClassOrMonthLabel;
    UILabel *ClassDurationLabel;
    UILabel *SubjectStatusLabel;
    UILabel *SubjectLevelLabel;
    UILabel *SubjectTuitionLabel;
    UILabel *SubjectRemarksLabel;
    UILabel *TuitionModeLabel;
    UILabel *SubjectScheduleLabel;
    UILabel *Subject_CategoryLabel;
    UILabel *SubjectValidityLabel;
    
    
    UILabel *staffgenerallabel;
    UILabel *subjectgenerallabel;
    UILabel *productgenerallabel;
    
    
    UILabel *ProductEnglishnameLabel;
    UILabel *ProductChinesenameLabel;
    UILabel *ProductCategoryLabel;
    UILabel *ProductCodeLabel;
    UILabel *ProductStatusLabel;
    UILabel *ProductPriceLabel;
    UILabel *ProductRemarksLabel;
    UILabel *ProductAutoRenewLabel;
    
    Instructor *InstructorObject;
    Staff *StaffObject;
    NSMutableArray *StaffArray;
    NSMutableArray *filteredStaffArray;
    NSMutableArray *ProductArray;
    NSMutableArray *filteredProductArray;
    ProductRecord *productobject;
    NSMutableArray *ClassroomArray;
    NSMutableArray *filteredClassroomArray;
    
    
    __weak IBOutlet UITableView *stafftable;
    __weak IBOutlet UITableView *subjecttable;
    __weak IBOutlet UITableView *producttable;
    __weak IBOutlet UITableView *marketingtable;
    __weak IBOutlet UITableView *classroomtable;
    NSMutableArray *InstructorArray;
    NSMutableArray *InstructorNameArray;

    __weak IBOutlet UIButton *addStaffButton;
    __weak IBOutlet UIButton *addSubjectButton;
    __weak IBOutlet UIButton *addProductButton;
    __weak IBOutlet UIButton *addMarketingButton;
    __weak IBOutlet UIButton *addClassRoomButton;
    
    __weak IBOutlet UISegmentedControl *scstaffstatus;
    __weak IBOutlet UISegmentedControl *scstaffrole;
    
    __weak IBOutlet UISegmentedControl *scsubjectstatus;
    __weak IBOutlet UISegmentedControl *scproductstatus;

    __weak IBOutlet UISegmentedControl *scmarketingcategory;
    __weak IBOutlet UISegmentedControl *scmarketingstatus;
    __weak IBOutlet UISegmentedControl *scclassroomstatus;

    UIView *marketingmediatableheaderview;
    UIView *marketingsourcetableheaderview;
    UIView *marketingpromotiontableheaderview;
    
    NSMutableArray *RoleArray;
    NSMutableArray *GroupArray;
    
    NSMutableArray *subjectArray;
    NSMutableArray *filteredSubjectArray;
    SubjectRecord *subjectobject;
    NSMutableArray *levelArray;
    NSMutableArray *tmplevelArray;
    NSMutableArray *tuitionArray;
    NSMutableArray *tmptuitionArray;
    NSMutableArray *marketingmediaArray;
    NSMutableArray *marketingsourceArray;
    NSMutableArray *marketingpromotionArray;
    NSMutableArray *marketingcouponArray;
    NSMutableArray *filteredmarketingmediaArray;
    NSMutableArray *filteredmarketingsourceArray;
    NSMutableArray *filteredmarketingpromotionArray;
    NSMutableArray *filteredmarketingcouponArray;
    
    UILabel *centerhour_line1leftLabel;
    UILabel *centerhour_line1rightLabel;
    UILabel *centerhour_line2leftLabel;
    UILabel *centerhour_line2rightLabel;
    UILabel *centerhour_line3leftLabel;
    UILabel *centerhour_line3rightLabel;
    UILabel *centerhour_line4leftLabel;
    UILabel *centerhour_line4rightLabel;
    UILabel *centerhour_line5leftLabel;
    UILabel *centerhour_line5rightLabel;
    
    UIImageView *mainimage;
    UIImageView *shopfrontimage;
//    UIImageView *mapimage;
    UIImageView *launchimage_landscape;
    UIImageView *launchimage_portrait;
    

    __weak IBOutlet UIButton *ProductCategorySelectionButton;

    NSString *productcategoryselected;
    NSMutableArray *productcategoryarray;
    NSMutableArray *productcategoryallarray;
    NSMutableArray *productcodeallarray;
    UIPopoverPresentationController *myProductCategorySelectionPopoverController;

    __weak IBOutlet UITableView *subscriptiontable;
    UITableView *devicetable;
    NSMutableArray *licenseArray;
    NSMutableArray *deviceArray;
    UILabel *stafforstudentnamelabel;
    UILabel *devicenamelabel;
    UILabel *lastloginlabel;
    UILabel *stafforstudentnametitlelabel;
    UILabel *devicetabletitle;
    NSIndexPath *devicetableindexpath;
    NSIndexPath *licensetableindexpath;
    UIButton *devicelisteditbutton;
    UIImageView *appimage;
    UILabel *devicecountlabel;
    __weak IBOutlet UILabel *appnamelabel;
    __weak IBOutlet UILabel *licensedcountlabel;
    __weak IBOutlet UILabel *usedcountlabel;
    __weak IBOutlet UILabel *addlicenseview;

    UILabel *classroomlabel;
    UILabel *classroomstatuslabel;
    UILabel *classroomremarkslabel;
    
    UIButton *editcalendarbutton;
    
    UIButton *centerinfo_editbutton;
    UIButton *centerinfo_cancelbutton;
    UIButton *centerinfo_savebutton;
    
    UITextField *centernametext;
    UITextField *schoolregnumbertext;
    UITextField *centershortnametext;
    GCPlaceholderTextView *centeraddresstext;
    UITextField *centercontacttext;
    UITextField *centerfaxtext;
    UITextField *centerwhatsapptext;
    UITextField *centerlattext;
    UITextField *centerlongtext;
    UISegmentedControl *scCenterInformationLanguage;

    UITextField *centerhour_line1lefttext;
    UITextField *centerhour_line1righttext;
    UITextField *centerhour_line2lefttext;
    UITextField *centerhour_line2righttext;
    UITextField *centerhour_line3lefttext;
    UITextField *centerhour_line3righttext;
    UITextField *centerhour_line4lefttext;
    UITextField *centerhour_line4righttext;
    UITextField *centerhour_line5lefttext;
    UITextField *centerhour_line5righttext;
    
    UITextField *centeremailaddresstext;
    UITextField *centerwebsitetext;
    UITextField *centerotherstext;
    
    
    UIButton *reloadbutton;
    NSInteger lastviewindex;
    NSInteger lastsubjectfilterindex;
    NSInteger laststaffstatusindex;
    NSInteger laststaffroleindex;
    NSInteger lastproductstatusindex;
    NSInteger lastmarketingfilterindex;
    NSInteger lastclassroomfilterindex;
    
    UIButton *daybuttonselected;
    
    UIImageView *centerimage;
    UILabel *title_Center_hours_except_center_holiday;
    UILabel *title_Email;
    UILabel *title_Website;
    UILabel *title_Others;
    
    NSArray *subjectstatusarray;
    NSArray *classroomstatusarray;
    NSArray *productstatusarray;
    NSArray *marketingstatusarray;
    NSMutableArray *AllRoleArray;
    
    NSString *selectedcalendardate;

    NSMutableArray *menuArray;

    UIView *menubottombar;
    
    UIRefreshControl *tablerefresh;
    
    NSCache *imageCache;
    
    UIView *headertitleview;
    UILabel *headertitlename;
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;
    SwitchCenterViewController *switchcenterviewcontroller;
    
    UIView *loadingindicatorview;
    UIActivityIndicatorView *ailoadclass;
    
    
    __weak IBOutlet UISearchBar *subjectsearchbar;
    __weak IBOutlet UISearchBar *staffsearchbar;
    //UISearchBar *roomsearchbar;
    __weak IBOutlet UISearchBar *roomsearchbar;
    __weak IBOutlet UISearchBar *productsearchbar;
    __weak IBOutlet UISearchBar *marketingsearchbar;
//    UISearchBar *marketingsearchbar;
    
    MarketingRecord *marketingobject;
    
    float keyboardheight;
    
    __weak IBOutlet UIButton *SubjectCategorySelectionButton;
    
//    UITableView *subjectcategoryselectiontable;
    NSMutableArray *subjectcategoryarray;
    UIPopoverPresentationController *mySubjectCategorySelectionPopoverController;
    
    NSString *subjectcategoryselected;
    
//    UIButton *marketingsortbutton;
    __weak IBOutlet UIButton *subjectsortbutton;
    __weak IBOutlet UIButton *classroomsortbutton;
    __weak IBOutlet UIButton *productsortbutton;
    __weak IBOutlet UIButton *staffsortbutton;
    __weak IBOutlet UIButton *marketingsortbutton;
    
    UITableView *sortingtable;
    NSMutableArray *sortingarray;
    UILabel *sortingnamelabel;
    UIButton *sortingorderbutton;
    SortingRecord *sortingobject;
    
    BOOL showSalaryrate;
    
    long selectedMainImage;
    
    
    NSString *tmpcentername;
    NSString *tmpschoolregnumber;
    NSString *tmpcentershortname_chinese;
    NSString *tmpcentershortname_english;
    NSString *tmpcentercontact;
    NSString *tmpcenterfax;
    NSString *tmpcenterwhatsapp;
    NSString *tmpcenteremail;
    NSString *tmpcenterwebsite;
    NSString *tmpcenterothers;
    NSString *tmpcenteraddress;
    NSString *tmpcenterhour_line1left;
    NSString *tmpcenterhour_line2left;
    NSString *tmpcenterhour_line3left;
    NSString *tmpcenterhour_line4left;
    NSString *tmpcenterhour_line5left;
    NSString *tmpcenterhour_line1right;
    NSString *tmpcenterhour_line2right;
    NSString *tmpcenterhour_line3right;
    NSString *tmpcenterhour_line4right;
    NSString *tmpcenterhour_line5right;
    NSString *tmpcenteraddress_chinese;
    NSString *tmpcenterhour_line1left_chinese;
    NSString *tmpcenterhour_line2left_chinese;
    NSString *tmpcenterhour_line3left_chinese;
    NSString *tmpcenterhour_line4left_chinese;
    NSString *tmpcenterhour_line5left_chinese;
    NSString *tmpcenterhour_line1right_chinese;
    NSString *tmpcenterhour_line2right_chinese;
    NSString *tmpcenterhour_line3right_chinese;
    NSString *tmpcenterhour_line4right_chinese;
    NSString *tmpcenterhour_line5right_chinese;
    NSData *tmpshopimagedata;
//    NSData *tmpmapimagedata;
    NSData *tmplandscapeimagedata;
    NSData *tmpportraitimagedata;
    NSData *tmpportraitimagedata_4;
    
    UILabel *mainimagelabel;
    
    BOOL shopimageEdited;
    //BOOL shopimageDeleted;
//    BOOL mapimageEdited;
    //BOOL mapimageDeleted;
    BOOL landscapeimageEdited;
    //BOOL landscapeimageDeleted;
    BOOL portraitimageEdited;
    //BOOL portraitimageDeleted;
    
    UIButton *centerinfo_addimagebutton;
    //UIButton *centerinfo_deleteimagebutton;
    UIImagePickerController *imagepicker;
    
    UIActivityIndicatorView *aicontactus;
    
    __weak IBOutlet UIButton *staff_userprivilegebutton;
    __weak IBOutlet UIButton *staff_usergroupbutton;
    __weak IBOutlet UIButton *staff_replaceinstructorbutton;
    
    UIViewController *userprivilegeviewcontroller;
    
    UITableView *staff_privilegenametable;
    UITableView *staff_privilegedetailstable;
    NSArray *privilegedetailsarray;
    
    NSMutableArray *localprivilegearray;
    
    //BOOL privilegenameupdated;
    
    UIButton *policy_editbutton;
    BOOL policy_editmode;
    UITextView *policycontenttext;
    long policy_selectedsegment;
    
    UIButton *policy_cancelbutton;
    UIButton *policy_savebutton;
    UIButton *policy_addbutton;
    
    NSString *policy_languageselected;
    UISegmentedControl *scPolicyLanguage;
    
    UILabel *devicenametitlelabel;
    UILabel *lastlogintitlelabel;
    
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIWindow *mainWindow;
    
    UIActivityIndicatorView *ailoadindicator;
    UIStoryboard *mainStoryboard;
    
    int leftmargin;
    int topmargin;
    int horizontalseparation;
    int verticalseparation;
    
    int cellheight;
    int cellwidth;
    
    __weak IBOutlet UILabel *title_subject_code;
    __weak IBOutlet UILabel *title_subject_englishname;
    __weak IBOutlet UILabel *title_subject_chinesename;
    __weak IBOutlet UILabel *title_subject_makeupquota;
    __weak IBOutlet UILabel *title_subject_status;
    __weak IBOutlet UILabel *title_subject_capacity;
    __weak IBOutlet UILabel *title_subject_duration;
    __weak IBOutlet UILabel *title_subject_schedule;
    __weak IBOutlet UILabel *title_subject_standardperiod;
    __weak IBOutlet UILabel *title_subject_tuitionby;
    __weak IBOutlet UILabel *title_subject_tuitionmode;
    __weak IBOutlet UILabel *title_subject_level;
    __weak IBOutlet UILabel *title_subject_tuitionfee;
    __weak IBOutlet UILabel *title_subject_validity;
    __weak IBOutlet UILabel *title_subject_remarks;
    
    __weak IBOutlet UILabel *title_room_classroom;
    __weak IBOutlet UILabel *title_room_status;
    __weak IBOutlet UILabel *title_room_remarks;
    __weak IBOutlet UILabel *title_room_capacity;
    __weak IBOutlet UILabel *title_room_roomcolor;
    
    __weak IBOutlet UILabel *title_staff_name;
    __weak IBOutlet UILabel *title_staff_username;
    __weak IBOutlet UILabel *title_staff_group;
    __weak IBOutlet UILabel *title_staff_status;
    __weak IBOutlet UILabel *title_staff_teaching;
    __weak IBOutlet UILabel *title_staff_phone;
    __weak IBOutlet UILabel *title_staff_privilege;
    __weak IBOutlet UILabel *title_staff_istaff;
    __weak IBOutlet UILabel *title_staff_icenter;
    __weak IBOutlet UILabel *title_staff_bi;
    __weak IBOutlet UILabel *title_staff_instructoravailability;
    __weak IBOutlet UILabel *title_staff_confirmmakeuprequest;
    __weak IBOutlet UILabel *title_staff_salaryrate;
    __weak IBOutlet UILabel *title_staff_mon;
    __weak IBOutlet UILabel *title_staff_tue;
    __weak IBOutlet UILabel *title_staff_wed;
    __weak IBOutlet UILabel *title_staff_thu;
    __weak IBOutlet UILabel *title_staff_fri;
    __weak IBOutlet UILabel *title_staff_sat;
    __weak IBOutlet UILabel *title_staff_sun;
    __weak IBOutlet UILabel *title_staff_remarks;
    
    __weak IBOutlet UILabel *title_product_code;
    __weak IBOutlet UILabel *title_product_status;
    __weak IBOutlet UILabel *title_product_category;
    __weak IBOutlet UILabel *title_product_englishname;
    __weak IBOutlet UILabel *title_product_chinesename;
    __weak IBOutlet UILabel *title_product_price;
    __weak IBOutlet UILabel *title_product_remarks;
    __weak IBOutlet UILabel *title_product_autorenew;
    __weak IBOutlet UILabel *title_product_stockcount;
    __weak IBOutlet UILabel *title_product_alertthreshold;
    __weak IBOutlet UILabel *title_product_yetgiven;
    
//    UILabel *title_media_code;
//    UILabel *title_media_mediadescription;
//    UILabel *title_media_validityfrom;
//    UILabel *title_media_validityto;
//    UILabel *title_media_remarks;
//
//    UILabel *title_source_code;
//    UILabel *title_source_sourcedescription;
//    UILabel *title_source_validityfrom;
//    UILabel *title_source_validityto;
//    UILabel *title_source_remarks;
    
//    UILabel *title_promotion_code;
//    UILabel *title_promotion_promotiondescription;
//    UILabel *title_promotion_discount;
//    UILabel *title_promotion_validityfrom;
//    UILabel *title_promotion_validityto;
//    UILabel *title_promotion_remarks;
//    UILabel *title_promotion_quota;
    
    __weak IBOutlet UILabel *title_marketing_code;
    __weak IBOutlet UILabel *title_marketing_description;
    __weak IBOutlet UILabel *title_marketing_discount;
    __weak IBOutlet UILabel *title_marketing_validityfrom;
    __weak IBOutlet UILabel *title_marketing_validityto;
    __weak IBOutlet UILabel *title_marketing_remarks;
    __weak IBOutlet UILabel *title_marketing_quota;
    
    UITableView *staff_groupnametable;
    UITableView *staff_groupdetailstable;
    UITableView *staff_membertable;
    UITableView *staff_membergrouptable;
    
    UIView *memberview;
    UIView *groupview;
    UIButton *groupbutton;
    UIButton *memberbutton;
    
    NSArray *groupalertarray;
    UIScrollView *staff_membergroupview;
    
    GCPlaceholderTextView *groupdescriptiontext;
    NSMutableDictionary *groupcountdictionary;
    NSMutableDictionary *privilegecountdictionary;
    
    NSMutableArray *allStaffArray;
    
    UITableView *ri_subjecttable;
    UITableView *ri_instructortable;
    UITableView *ri_calendartable;
    NSMutableArray *ri_filteredinstructorarray;
    NSMutableArray *ri_subjectarray;
    NSMutableArray *ri_selectedsubjectarray;
    UIButton *ri_blockview;
    UISearchBar *ri_instructorsearchbar;
    
    UIView *ri_instructorview;
    UIView *ri_periodview;
    
    NSString *ri_frominstructor;
    NSString *ri_toinstructor;
    NSString *ri_fromperiod;
    NSString *ri_toperiod;
    
    UIButton *frominstructorbutton;
    UIButton *toinstructorbutton;

    UIButton *fromperiodbutton;
    UIButton *toperiodbutton;
    UIButton *dayoptionbutton;
    
    UIButton *selectedinstructorbutton;
    UIButton *selectedperiodbutton;
    NSMutableArray *ri_allinstructorarray;
    
    UIPickerView *myPicker;
    //UIPickerView *myPickerView;;
    long hourPresetRow;
    long minutePresetRow;
    NSMutableArray *hourPickerViewMenu;
    NSMutableArray *minutePickerViewMenu;
    
    UIButton *clearfromperiodbutton;
    UIButton *cleartoperiodbutton;
    UILabel *ri_noclassfoundlabel;
    int ri_totalcount;
    
    NSInteger selectedGroupNameRow;
    NSInteger selectedPrivilegeNameRow;
    __weak IBOutlet NSLayoutConstraint *subjectTableBottomConstraint;
    
    NSMutableArray *selectedDayOptionArray;
    NSArray *dayOptionArray;
    
    __weak IBOutlet UISegmentedControl *scPolicyType;
    __weak IBOutlet UIView *generalPolicyView;
    __weak IBOutlet UIView *tncPolicyView;
    __weak IBOutlet UIView *leavePolicyView;
    __weak IBOutlet UITableView *tncTable;
    UITextView *receipttnctext;
    UITextView *invoicetnctext;
    
    NSInteger selectedLeaveNatureRow;
    __weak IBOutlet NSLayoutConstraint *policyViewBottomConstraint;
    __weak IBOutlet NSLayoutConstraint *productViewBottomConstraint;
    __weak IBOutlet NSLayoutConstraint *subjectViewBottomConstraint;
    __weak IBOutlet NSLayoutConstraint *staffViewBottomConstraint;
    __weak IBOutlet NSLayoutConstraint *classroomViewBottomConstraint;
    __weak IBOutlet NSLayoutConstraint *marketingViewBottomConstraint;
    
    
    __weak IBOutlet UILabel *title_Nature_Name;
    __weak IBOutlet UILabel *title_Nature_Name_1;
    __weak IBOutlet UILabel *title_Nature_Name_2;
    __weak IBOutlet UILabel *title_Available_For_Student_Request;
    __weak IBOutlet UILabel *title_Attendance_Settings;
    __weak IBOutlet UILabel *title_Absent;
    __weak IBOutlet UILabel *title_Makeup;
    __weak IBOutlet UILabel *title_Extend;
    __weak IBOutlet UILabel *title_Quota_Required;
    __weak IBOutlet UILabel *title_Auto_Approve;
    __weak IBOutlet UILabel *title_Default_Nature_For_Staff;
    __weak IBOutlet UILabel *title_Default_Nature_For_Student;
    __weak IBOutlet UILabel *title_Leave_Nature;
    __weak IBOutlet UILabel *title_Configuration;
    __weak IBOutlet UILabel *title_Remarks;
    
    __weak IBOutlet UITextField *leaveConfigName1;
    __weak IBOutlet UITextField *leaveConfigName2;
    __weak IBOutlet UITextView *leaveConfigRemarks;
    
    __weak IBOutlet UISwitch *cbLeaveNatureStudentRequest;
    __weak IBOutlet UISwitch *cbLeaveNature1;
    __weak IBOutlet UISwitch *cbLeaveNature2;
    __weak IBOutlet UISwitch *cbLeaveNature3;
    __weak IBOutlet UISwitch *cbLeaveNature11;
    __weak IBOutlet UISwitch *cbLeaveNature12;
    __weak IBOutlet UISwitch *cbLeaveNature13;
    __weak IBOutlet UISwitch *cbLeaveNature21;
    __weak IBOutlet UISwitch *cbLeaveNature22;
    __weak IBOutlet UISwitch *cbLeaveNature23;
    __weak IBOutlet UISwitch *cbLeaveNature31;
    __weak IBOutlet UISwitch *cbLeaveNature32;
    __weak IBOutlet UISwitch *cbLeaveNature33;
    __weak IBOutlet UITableView *leaveNatureListTable;
    NSMutableArray *leaveNatureArray;
    LeaveNatureRecord *workingleavenatureobject;

    __weak IBOutlet UIStackView *LeaveConfigStudentDefaultStackView;
    __weak IBOutlet UIStackView *LeaveConfigAutoApproveStackView;
    
    NSString *old_nature_name1;
    NSString *old_nature_name2;
    __weak IBOutlet NSLayoutConstraint *generalPolicyTableBottomConstraint;
    
    NSMutableDictionary *yetGivenProductDict;
    
    NSString *selectedsubmenukey;
    NSInteger selectedsubmenu;
    
    CenterRecord *workingCenter;
    
    __weak IBOutlet UIStackView *menuStackView;
    __weak IBOutlet UIButton *menu_center_button;
    __weak IBOutlet UIButton *menu_calendar_button;
    __weak IBOutlet UIButton *menu_course_button;
    __weak IBOutlet UIButton *menu_classroom_button;
    __weak IBOutlet UIButton *menu_staff_button;
    __weak IBOutlet UIButton *menu_product_button;
    __weak IBOutlet UIButton *menu_marketing_button;
    __weak IBOutlet UIButton *menu_policy_button;
    __weak IBOutlet UIButton *menu_subscription_button;
    
}

@property (strong,nonatomic) UIPopoverPresentationController *myPopoverController;
@property (strong,nonatomic) UIPopoverPresentationController *myMarketingPopoverController;
@property (nonatomic, strong) NSString *tableViewCellIdentifier;
@property (nonatomic) NSUInteger tableViewCellIdentifierCount;

- (IBAction)selectPolicyType:(UISegmentedControl *)sender;
- (IBAction)addLeaveNature:(id)sender;
- (IBAction)deleteLeaveNature:(id)sender;
- (IBAction)checkLeaveNatureConfig:(UISwitch *)sender;
- (IBAction)checkLeaveNatureStudentRequest:(UISwitch *)sender;
- (IBAction)textFieldEditingChanged:(UITextField *)sender;
- (IBAction)textFieldEditingDidEnd:(UITextField *)sender;
- (IBAction)addStaff:(UIButton *)sender;
- (IBAction)selectinformation:(UIButton *)sender;
- (void) gotoSubmenu:(NSInteger)submenu submenukey:(NSString *)submenukey;

@end
