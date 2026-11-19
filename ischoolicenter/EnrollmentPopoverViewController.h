//
//  EnrollmentPopoverViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 4/22/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "ClassTimeTableViewController.h"
#import <MessageUI/MessageUI.h>
#import "GCPlaceholderTextView.h"
#import "InstructorImageGridViewController.h"
#import "StudentImageGridViewController.h"
#import "MessagePopoverViewController.h"
#import "CalendarView.h"
#import "MyTableViewCell.h"
#import "MainViewController.h"

@protocol myPopoverVCDelegate <NSObject>
-(EnrollmentRecord *) refreshstudentdetailsinformationandreturnenrollementrecord:(EnrollmentRecord *)enrollment;
-(void) dismissEnrollmentPopoverandResetFilter:(BOOL)resetfilter;
-(void) refreshdocumentfoldercountnumber;
-(void) enrollmentwindowloadviewcompleted;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;
-(BOOL) isDifferentLevelWithLaterEnrollmentWithStartDate:(NSString *)startdate enrollmentkey:(NSString *)enrollmentkey subject:(NSString *)subject levelmain:(NSString *)levelmain levelctm:(NSString *)levelctm studentkey:(NSString *)studentkey;

@end

@interface EnrollmentPopoverViewController : UIViewController<UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,myClassTimeTableViewControllerDelegate,UITextViewDelegate,UIDocumentInteractionControllerDelegate,MFMailComposeViewControllerDelegate,myInstructorImageGridViewControllerDelegate,myStudentImageGridViewControllerDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,UISearchDisplayDelegate,UIPrintInteractionControllerDelegate,myCalendarViewDelegate,UIPopoverPresentationControllerDelegate>{
    //sqlite3 *isdb;
    NSString *savetodraft;
    
    MainViewController *mainviewcontroller;
    UILabel *enrollmentLabel;
    UITextField *OneOffFixedDiscountText;
    UITextField *RecursiveDiscountText;
    UITextField *OneOffPercentageDiscountText;
    UILabel *OneOffFixedDiscountLabel;
    UILabel *OneOffPercentageDiscountLabel;
    UITextField *RefundAmountText;
    
    UILabel *VoidTotalPaidLabel;
    UILabel *VoidForfeitLabel;

    UILabel *detailspaymentLabel;
    UILabel *paymenttotalfeeLabel;
    UILabel *paymenttotalpaidLabel;
    UILabel *paymentoutstandingLabel;
    GCPlaceholderTextView *paymentremarksText;
    GCPlaceholderTextView *receiptremarksText;
    GCPlaceholderTextView *invoiceremarksText;
    
    UILabel *invoiceremarkslabel;
    
    UILabel *paymentremarkslabel;
    UILabel *receiptremarkslabel;
    UILabel *paidmethodLabel;
    UILabel *paiddateLabel;
    UITextField *detailspaymentText;
    NSString *selectedItem;
    NSString *selectedValue;
    
    NSInteger presetRow;
    NSInteger datePresetRow;
    NSInteger minutePresetRow;
    NSInteger hourPresetRow;
    NSInteger dayPresentRow;
    BOOL justDeletePayment;
    
//    BOOL showDatePicker;
    BOOL showTimePicker;
    BOOL showLevelPicker;
    BOOL showNoOfClassPicker;
    BOOL showEndMonthPicker;
    BOOL showEnrollmentFeePicker;
    BOOL showDropClass;
    BOOL showDropClassDate;
//    BOOL showDropClassDatePicker;
    BOOL showDeleteButton;
    BOOL showPaidMethodPicker;
    BOOL showPaymentDatePicker;
    //BOOL showClassroomPicker;
//    BOOL showEnrollmentDatePicker;
//    BOOL showBillDatePicker;
    BOOL showMakeupQuotaPicker;
    BOOL showStandardPeriodPicker;
    
    
    BOOL showDetailLesson;
    BOOL showAutoRenew;
    //BOOL showSchedulePicker;
    
    BOOL showDetailPayment;
    BOOL showVoidWindow;
    BOOL showRefundMethodPicker;
    
    EnrollmentRecord *workingEnrollment;
    NSString *tmpLevel;
    NSString *tmpTotalDiscount;
    
    UILabel *DTTotalDiscountLabel;
    
    NSString *tmpPaidDate;
    NSString *tmppaidamount;
    NSString *tmppaidmethod;
    NSString *tmppaymentremarks;
    NSString *tmpreceiptremarks;
    NSString *tmpStartDateTime;
    
    NSMutableArray *tmpClassRecordArray;
    ClassRecord *tmpClassRecordObject;
    
    GlobalVariables *globalvariables;
    
    float keyboardheight;
    
    NSString *alertTitle;

    NSMutableArray *subjectArray;
    NSMutableArray *filteredSubjectArray;
    
    //NSMutableArray *maxlevelArray;
    
    NSString *lastbankindatetime;
    float totaloutstandingpayment;
    float lastoutstandingbankincash;
    float lastoutstandingbankincheque;
    float currentoutstandingbankin;
    float newreceivedpaymentcash;
    float newreceivedpaymentcheque;
    
    UIDocumentInteractionController * documentInteractionController;
    
    NSDateFormatter *df;

    UIPopoverPresentationController *mySharePopovercontroller;
    UITableView *sharetable;
    NSIndexPath *paymentindexpath;
    NSString *invoiceorreceipt;
    
    PaymentRecord *paymentrecordobject;
    
    UIActivityIndicatorView *aishareprint;
    UIActivityIndicatorView *aishareemail;
    UIActivityIndicatorView *aishareothers;
    UIActivityIndicatorView *aisendmessage;

    
    NSMutableArray *AvailableInstructorArray;
    NSMutableArray *filteredAvailableInstructorArray;
    
    long DetailsPaymentObjectIndex;
    
    NSArray *activesubjectarray;
    
    NSString *lastclassinstructor;
    NSString *lastclasstime;
    NSString *lastclassroom;
    NSString *lastclasssinstructor;
    NSString *lastclassdate;
    NSString *lastlesson;
    
    NSMutableArray *AvailableClassroomArray;
    NSMutableArray *FilteredClassroomArray;
    
    BOOL classalreadyreset;
    
    NSMutableArray *InitialFreeScheduleClassArray;
    NSMutableArray *TransferFreeScheduleClassArray;
    
    BOOL paymentoverride;
    
    
    __weak IBOutlet UITableView *EnrollmentPopoverTable;
    __weak IBOutlet NSLayoutConstraint *enrollmentTableBottomConstraint;
    
    __weak IBOutlet UITableView *DetailLessonTable;
    __weak IBOutlet UIToolbar *DetailLessonToolBar;
    __weak IBOutlet UIView *DetailLessonMasterView;
    __weak IBOutlet NSLayoutConstraint *detaillessonbottomconstraint;
    UIButton *changeStartingLessonButton;
    
    __weak IBOutlet UIView *LessonNumberTableMasterView;
    __weak IBOutlet UITableView *LessonNumberTable;
    __weak IBOutlet UIToolbar *LessonNumberTableToolBar;
    BOOL showDLLessonNumberTable;
    NSArray *lessonArray;
    
//    UIToolbar *DetailLessonToolBar;
    UIToolbar *VoidWindowToolBar;
    
    UIButton *DLSelectInstructorButton;
    //UIButton *DLCarryOverButton;
    
    long selectedlessonrow;
    long selecteddlbutton;
    NSString *DetailLessonMode;
    
    UIView *SubjectTableMasterView;
    UITableView *SubjectTable;
    UIToolbar *SubjectTableToolBar;
    BOOL showSubjectTable;
    UILabel *STSubjectname;
    UILabel *STSubjectcode;
    UIImageView *STSubjectselected;
    UISearchBar *subjectsearchbar;
    
    UIView *InstructorTableMasterView;
    UITableView *InstructorTable;
    UIToolbar *InstructorTableToolBar;
    BOOL showInstructorTable;
    //UILabel *ITInstructorname;
    //UIImageView *ITInstructorselected;
    UISearchBar *instructorsearchbar;

    
//    UIView *ScheduleTableMasterView;
    __weak IBOutlet UIView *ScheduleTableMasterView;
    UITableView *ScheduleTable;
    UIToolbar *ScheduleTableToolBar;
    BOOL showScheduleTable;
    UISearchBar *schedulesearchbar;
    NSMutableArray *filteredScheduleArray;
    NSMutableArray *ScheduleArray;
    
    
    __weak IBOutlet UIView *DiscountTableMasterView;
    UITableView *DiscountTable;
    UIToolbar *DiscountTableToolBar;
    BOOL showDiscountTable;
    BOOL showValidityPicker;

    UIView *ClassroomTableMasterView;
    UITableView *ClassroomTable;
    UIToolbar *ClassroomTableToolBar;
    BOOL showClassroomTable;
    UISearchBar *classroomsearchbar;
    
    UIView *attendanceringview;
    NSMutableArray *attendancebuttonarray;
    NSMutableArray *regularattendancebuttonarray;
    NSMutableArray *makeupattendancebuttonarray;
    long lasttouchedsector;
    long selectedattendancebuttontag;
    
    UILabel *DLSeparatorLine;
    
    UIButton *DLSetTBDButton;
    
    //NSMutableArray *scheduleLessonArray;
    UILabel *noclassrecordlabel;
    BOOL disableclassdelete;
    
    //NSMutableArray *lessonDatePickerViewMenu;
    
//    UIView *DetailLessonMasterView;
    __weak IBOutlet UIView *DetailPaymentMasterView;
//    UIView *DetailPaymentMasterView;
    UIView *VoidWindowMasterView;
    UITableView *VoidTable;
    NSString *SelectInstructorTo;
    
    NSString *tmprefundamount;
    NSString *tmpvoidforfeitedamount;
    NSString *tmprefundmethod;
    
    //BOOL hidecarryoverbutton;
    
    ClassValidateMessage *classvalidatemessage;
    ClassValidateStatus *classvalidatestatus;
    
    NSMutableArray *availablepromotionarray;
    NSMutableArray *filteredavailablepromotionarray;
    //NSMutableArray *usedpromotionarray;
    
    NSMutableArray *availablecouponarray;
    NSMutableArray *filteredavailablecouponarray;
    
    __weak IBOutlet UITableView *PromotionCodeTable;
    __weak IBOutlet UITableView *CouponTable;
    
//    UILabel *PCDescriptionLabel;
//    UILabel *PCDiscountAmountLabel;
//    UILabel *PCExpiryLabel;
//    UILabel *PCQuotaLabel;
    //UILabel *PCCodeLabel;
//    UIButton *PCAddButton;
    
    UILabel *DTDescriptionLabel;
    UILabel *DTDiscountAmountLabel;
    
    MarketingRecord *marketingobject;
    BOOL showpromotioncodetable;
    UISearchBar *promotionsearchbar;
    
    BOOL showcoupontable;
    UISearchBar *couponsearchbar;
    
    NSString *DiscountTableMode;
    
    UIButton *DLStartDateTimeCarryOverButton;
    UIButton *DLInstructorCarryOverButton;
    UIButton *DLClassroomCarryOverButton;
    
    UITableView *DLInstructorTable;
    UIView *DLInstructorTableMasterView;
    BOOL showDLInstructorTable;
    UISearchBar *dlinstructortablesearchbar;
    UIToolbar *DLInstructorTableToolBar;

    UITableView *DLClassroomTable;
    UIView *DLClassroomTableMasterView;
    BOOL showDLClassroomTable;
    UISearchBar *dlclassroomtablesearchbar;
    UIToolbar *DLClassroomTableToolBar;
    
    UITableView *DLClassDateTable;
    UIView *DLClassDateTableMasterView;
    BOOL showDLClassDateTable;
    UIToolbar *DLClassDateTableToolBar;
    
    
    UIView *leaveNatureTableMasterView;
    UITableView *leaveNatureTable;
    UIToolbar *leaveNatureTableToolBar;
    BOOL showleaveNatureTable;
    NSMutableArray *leaveNatureArray;
    
    UIButton *invoiceprintbutton;
    UIButton *receiptprintbutton;
    
    __weak IBOutlet UIView *promotioncodeview;
    __weak IBOutlet UIView *couponview;
    
    NSDictionary *ExtendedClasskeyDictionary;
    int noofroundoffdigit;
    
    StudentImageGridViewController *studentimagepopover;
    InstructorImageGridViewController *instructorimagepopover;
    
    UILabel *ValidityLabel;
    NSIndexPath *lastenrollmenttableselectedindexpath;
    
    NSString *ScheduleTableMode;
    UITextField *ScheduleNameText;
    ScheduleRecord *workingSchedule;
    
    UIButton *selecteddaytimebutton;
    
    FreeScheduleClass *currentselectedfreescheduleclass;
    FreeScheduleClass *previousselectedfreescheduleclass;
    
    EnrollmentRecord *ChangeSubject_firstEnrollment;
    NSMutableArray *ChangeSubject_FreeClassScheduleArray;
    NSMutableArray *ChangeSubject_DetailsPaymentArray;
    NSMutableArray *ChangeSubject_UsedPromotionArray;
    NSMutableArray *ChangeSubject_UsedCouponArray;
    
    UIButton *TransferEnrollmentBtn;
    NSString *TransferEnrollmentAction;
    
    UIView *csInstructorTableMasterView;
    UITableView *csInstructorTable;
    UIToolbar *csInstructorTableToolBar;
    BOOL showcsInstructorTable;
    UISearchBar *csinstructortablesearchbar;
    UIButton *csSelectInstructorButton;
    NSMutableArray *filteredcsInstructorArray;
    
    UIView *csClassroomTableMasterView;
    UITableView *csClassroomTable;
    UIToolbar *csClassroomTableToolBar;
    BOOL showcsClassroomTable;
    UISearchBar *csclassroomtablesearchbar;
    NSMutableArray *filteredcsClassroomArray;
    
    UIView *csClassDateTableMasterView;
    UITableView *csClassDateTable;
    UIToolbar *csClassDateTableToolBar;
    BOOL showcsClassDateTable;
    NSMutableArray *tmptestcstimearray;
    
    UIView *csDayDateTimeTableMasterView;
    UITableView *csDayDateTimeTable;
    UIToolbar *csDayDateTimeTableToolBar;
    BOOL showcsDayDateTimeTable;
    UILabel *csDayDateTimeHeaderLabel;
    
    BOOL showResumeClassDateTable;
    BOOL showDropClassDateTable;
    BOOL showEnrollmentDateTable;
    BOOL showBillDateTable;
    

    
    BOOL manualselectnoofclass;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIActivityIndicatorView *ailoadindicator;
    UIWindow *mainWindow;
    UIStoryboard *mainStoryboard;
    
    LessonRecord2 *lesson2object;
    
    ScheduleDetailsRecord *workingScheduleDetails;
    
    NSMutableArray *dayPickerViewMenu;
    NSMutableArray *minutePickerViewMenu;
    NSMutableArray *hourPickerViewMenu;
    
    BOOL newReceiptToBeMessaged;
    
    NSString *allclassremarks;
    
    NSArray *enrollmentmodearray;
    NSMutableArray *standardnoofclassormontharray;
    
    NSInteger enrollmentmodepresetrow;
    NSInteger standardnoofclassormonthpresetrow;
    
    CalendarView *datecalendarview;
    __weak IBOutlet UIView *DateMasterView;
    __weak IBOutlet UIToolbar *datetoolbar;
    __weak IBOutlet UIButton *backButton;
    __weak IBOutlet UIButton *noneButton;
    __weak IBOutlet UILabel *datetitle;
    __weak IBOutlet UILabel *yeartitle;
    BOOL showStartDateTable;
//    BOOL firstEnrollment;
    BOOL waiveEnrollmentFee;
    BOOL neworderwillbecreated;
    __weak IBOutlet UIButton *renewalButton;
    __weak IBOutlet UIButton *copyButton;
    __weak IBOutlet UIButton *editButton;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet UIButton *dropButton;
    __weak IBOutlet UILabel *toolbarLabel;
    
    __weak IBOutlet UIButton *DL_addButton;
    __weak IBOutlet UIButton *DL_closeButton;
    
    __weak IBOutlet UIButton *payment_receiptButton;
    __weak IBOutlet UIButton *payment_invoiceButton;
    __weak IBOutlet UIButton *payment_addButton;
    __weak IBOutlet UIButton *payment_cancelButton;
    __weak IBOutlet UIButton *payment_saveButton;
    __weak IBOutlet UIButton *payment_cancelremarksButton;
    __weak IBOutlet UIButton *payment_doneremarksButton;
    __weak IBOutlet UIToolbar *paymentToolbar;
    __weak IBOutlet UIButton *schedule_addButton;
    __weak IBOutlet UIButton *schedule_cancelButton;
    
    NSMutableArray *duplicatedclassarray;
}

@property (strong, nonatomic) NSString *popovertable;
@property (nonatomic, strong) EnrollmentRecord * PopoverEnrollment;
@property (nonatomic,strong) Student *PopoverStudent;
@property (weak, nonatomic) IBOutlet UIToolbar *EnrollmentToolBar;
//@property (strong,nonatomic) UIToolbar *paymentToolbar;

@property (nonatomic, strong) NSString *EnrollmentTableMode;
@property (strong, nonatomic) UITableView *DetailsPaymentTable;
@property (strong, nonatomic) NSMutableArray *ClassfeeArray;
@property (strong, nonatomic) ClassfeeRecord *ClassfeeObject;

@property (nonatomic, strong) NSString *DetailsPaymentTableMode;
@property (nonatomic, strong) PaymentRecord *DetailsPaymentObject;
//@property (nonatomic, strong) NSMutableArray *DetailsPaymentArray;

@property (strong, nonatomic) NSMutableArray *JSONArray;
@property (strong, nonatomic) NSMutableArray *InstructorArray;
@property (nonatomic,retain) NSMutableArray *pickerViewmenu;
@property (nonatomic,strong) NSMutableArray *levelmainPickerViewMenu;
@property (nonatomic,strong) NSMutableArray *levelctmPickerViewMenu;

@property (nonatomic,strong) UIPickerView *myPickerView;
//@property (nonatomic, strong) UIPopoverPresentationController *myPopoverController;
@property (nonatomic,strong) NSMutableArray *AllClassRemarksArray;

@property (nonatomic,strong) FreeScheduleClass *FreeScheduleClassObject;
@property (nonatomic,strong) NSMutableArray *FreeScheduleClassArray;
@property (nonatomic,strong) NSMutableArray *BackupFreeScheduleClassArray;
@property (nonatomic,weak) id<myPopoverVCDelegate>delegate;
@property (nonatomic,strong) NSString *currentsubject;
@property (nonatomic,strong) NSString *dtkey;
@property (nonatomic,strong) NSMutableDictionary *leveldictionary;
- (IBAction)backbuttonpressed:(id)sender;
- (IBAction)nonebuttonpressed:(id)sender;

-(void) validationPassed:(BOOL)pass;

- (IBAction)editButtonPressed:(id)sender;
- (IBAction)renewalButtonPressed:(id)sender;
- (IBAction)copyButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)dropButtonPressed:(id)sender;
- (IBAction)closedetaillesson:(id)sender;
- (IBAction)adddetaillesson:(id)sender;
- (IBAction)closesubwindow:(id)sender;

- (IBAction)addpaymentrecord:(id)sender;
- (IBAction)shareinvoicebutton:(id)sender;
- (IBAction)sharereceiptbutton:(id)sender;
- (IBAction)canceladdpayment:(id)sender;
- (IBAction)donepaymentrecord:(id)sender;
- (IBAction)cancelpaymentremarks:(id)sender;
- (IBAction)donepaymentremarks:(id)sender;

- (IBAction)addschedulebuttonpressed:(id)sender;
- (IBAction)cancelschedulebuttonpressed:(id)sender;



@end
