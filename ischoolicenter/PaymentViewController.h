//
//  PaymentViewController.h
//  ELTestX
//
//  Created by Jasmond Luk on 5/10/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "MyObject.h"
#import "GCPlaceholderTextView.h"
#import <MessageUI/MessageUI.h>
#import "DocumentFolderPopoverViewController.h"
#import "SwitchCenterViewController.h"
#import "CalendarView.h"
#import "StudentDetailsViewController.h"


@interface PaymentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIPopoverPresentationControllerDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,MFMailComposeViewControllerDelegate,UIDocumentInteractionControllerDelegate,myDocumentFolderPopoverViewController,UITextFieldDelegate,mySwitchCenterViewControllerDelegate,UIGestureRecognizerDelegate,UISearchBarDelegate,myCalendarViewDelegate,UIPrintInteractionControllerDelegate,myStudentViewController>{
    
    MainViewController *mainviewcontroller;
    UILabel *StudentNameLabel;
    UILabel *StudentIDLabel;
    UILabel *EnrollmentDateLabel;
    UILabel *ClassLabel;
    UILabel *ClassDayLabel;
    UILabel *ClassTimeLabel;
    UILabel *StartDateLabel;
    UILabel *EndDateLabel;
    UILabel *NoOfClassLabel;
    UILabel *TotalFeeLabel;
    UILabel *PaidLabel;
    UILabel *OutstandingLabel;
    //UILabel *ParentcontactLabel;
    
    UILabel *sales_StudentIDLabel;
    UILabel *OrderDateLabel;
    UILabel *ProductLabel;
    UILabel *QuantityLabel;
    UIImageView *studentimage;
    UIImageView *sales_studentimage;
    UIImageView *sales_combinepaymentstatusimageview;
    UIImageView *class_combinepaymentstatusimageview;
    //NSCache *imageCache;
    //NSString *imagelastupdatetime;
    //UIImage *boyimage;
    //UIImage *girlimage;
    
    UILabel *BankinDateTimeLabel;
    UILabel *NewPaymentReceivedCashLabel;
    UILabel *BankinAmountCashLabel;
    UILabel *OutstandingBankinCashLabel;
    UILabel *NewPaymentReceivedChequeLabel;
    UILabel *BankinAmountChequeLabel;
    UILabel *OutstandingBankinChequeLabel;
    UILabel *BankinPersonLabel;
    UILabel *RemarksLabel;
    
    UILabel *bankininputLabel;
    UITextField *bankinamountcashinputText;
    UITextField *bankinamountchequeinputText;
    UITextField *bankinpersoninputText;
    UITextView *bankinremarksText;
    UILabel *bankinnewoutstandingLabel;
    
    UILabel *invoiceremarkslabel;
    
    UILabel *paymenttotalfeeLabel;
    UILabel *paymenttotalpaidLabel;
    UILabel *paymentoutstandingLabel;
    
    //IBOutlet UILabel *newpaymentreceivedcash;
    //IBOutlet UILabel *newpaymentreceivedcheque;
    //UILabel *outstandingbankincash;
    __weak IBOutlet UILabel *outstandingbankincash;
    __weak IBOutlet UILabel *outstandingbankincheque;
    //UILabel *outstandingbankincheque;
    
    UILabel *detailspaymentLabel;
    UILabel *paidmethodLabel;
    UILabel *paiddateLabel;
    UILabel *totalpaidLabel;
    UILabel *outstandingLabel;
    UITextField *detailspaymentText;
    UIButton *detailspaymentbutton;
    
    GCPlaceholderTextView *paymentremarksText;
    GCPlaceholderTextView *receiptremarksText;
    
    GCPlaceholderTextView *invoiceremarksText;
    
    UILabel *paymentremarkslabel;
    UILabel *receiptremarkslabel;
    
    NSString *tmpPaidDate;
    NSString *tmppaidamount;
    NSString *tmppaidmethod;
    NSString *tmppaymentremarks;
    NSString *tmpreceiptremarks;
    NSString *tmpinvoiceremarks;
    
    NSString *tmpbankincashamount;
    NSString *tmpbankinchequeamount;
    NSString *tmpbankinremarks;
    NSString *tmpbankinperson;
    
    BOOL showPaymentDatePicker;
    BOOL showPaidMethodPicker;
    
    
    //sqlite3 *isdb;
    UIButton *SettleButton;
//    float totaloutstandingclasspayment;
//    float totaloutstandingsalespayment;
    float totaloutstanding;
    float lastoutstandingbankincash;
    float lastoutstandingbankincheque;
    float currentoutstandingbankin;
    long presetRow;
    
    NSString *lastcellcolor;
    NSString *selectedParentRow;
    NSString *currentenrollmentkeystring;
    NSString *lastbankindatetime;
    float newreceivedpaymentcash;
    float newreceivedpaymentcheque;
    
    GlobalVariables *globalvariables;
    //IBOutlet UILabel *viewtitle;
    
    BOOL bankinchecked;
    
    NSMutableArray *pickerViewmenu;
    
    NSString *selectedItem;
    IBOutlet UISegmentedControl *scpaymenttype;
    IBOutlet UIView *paymentclassview;
    IBOutlet UIView *paymentsalesview;
    
    //UIButton *combinepaymentbutton;
    //__weak IBOutlet UIButton *combinepaymentbutton;
    
    
    
    OutstandingSalesPaymentRecord *outstandingsalespaymentobject;
    
    UIPopoverPresentationController *mySharePopovercontroller;
    UITableView *sharetable;
    NSIndexPath *paymentindexpath;
    NSString *invoiceorreceipt;
    
    NSDateFormatter *df;
    PaymentRecord *paymentrecordobject;
    
    NSMutableArray *subjectArray;
    //NSMutableArray *subjectshortnameArray;
    
    UIDocumentInteractionController * documentInteractionController;
    
    EnrollmentRecord *PopoverEnrollment;
    Student *PopoverStudent;
    
    NSMutableArray *FreeScheduleClassArray;
    
    SalesRecord *SalesObject;
    
    UIActivityIndicatorView *aishareprint;
    UIActivityIndicatorView *aishareemail;
    UIActivityIndicatorView *aishareothers;
    
    UIButton *reloadbutton;
    NSInteger lastdayofweekindex;
    
    NSNumberFormatter * formatter;
    
    float keyboardheight;
    
    long DetailsPaymentObjectIndex;
    
    UIButton *documentfolderbutton;
    UILabel *documentfoldercountlabel;
    
    //NSMutableArray *documentfolderclassinvoicearray;
    //NSMutableArray *documentfolderclassreceiptarray;
    //NSMutableArray *documentfoldersalesinvoicearray;
    //NSMutableArray *documentfoldersalesreceiptarray;
    
    ClassInvoiceRecord *classinvoicerecordobject;
    ClassReceiptRecord *classreceiptrecordobject;
    
    SalesInvoiceRecord *salesinvoicerecordobject;
    SalesReceiptRecord *salesreceiptrecordobject;
    
    UITableView *DocumentFolderTable;
    
    IBOutlet UILabel *title_Class_Student;
    IBOutlet UILabel *title_Sales_Student;
    IBOutlet UILabel *title_Subject;
    IBOutlet UILabel *title_Enrollment;
    IBOutlet UILabel *title_Day;
    IBOutlet UILabel *title_Time;
    IBOutlet UILabel *title_Start;
    IBOutlet UILabel *title_End;
    IBOutlet UILabel *title_No_of_Class;
    IBOutlet UILabel *title_Total_Fee;
    IBOutlet UILabel *title_Paid;
    IBOutlet UILabel *title_Outstanding;
    IBOutlet UILabel *title_Order_Date;
    IBOutlet UILabel *title_Product;
    IBOutlet UILabel *title_Quantity;
    IBOutlet UILabel *title_product_Total_Fee;
    IBOutlet UILabel *title_product_Paid;
    IBOutlet UILabel *title_product_Outstanding;

    __weak IBOutlet UILabel *title_bankin_Current_Center_Balance;
    __weak IBOutlet UILabel *title_bankin_Bank_in;
    __weak IBOutlet UILabel *title_bankin_Bankin_Date;
    __weak IBOutlet UILabel *title_bankin_Bankin_Record;
    __weak IBOutlet UILabel *title_bankin_Outstanding_Record;
    __weak IBOutlet UILabel *title_bankin_Bankin_Person;
    __weak IBOutlet UILabel *title_bankin_Remarks;
    __weak IBOutlet UILabel *title_bankin_record;
    
    NSArray *classdayarray;
    
    BOOL paymentoverride;
    
    UIRefreshControl *tablerefresh;
    
    UIView *headertitleview;
    UILabel *headertitlename;
    UILabel *headercentername;
    UIImageView *headercenternamearrow;
    UIButton *switchcenterbutton;
    
    SwitchCenterViewController *switchcenterviewcontroller;
    

    
    BOOL isSelectCombinePayment;
    
    DocumentFolderPopoverViewController *documentfolderpopover;
    
    __weak IBOutlet UISearchBar *outstandingclasssearchbar;
    __weak IBOutlet UISearchBar *outstandingsalessearchbar;
    UIButton *outstandingsalessortbutton;
    
    NSMutableArray *OutstandingClassPaymentArray;
    NSMutableArray *OutstandingSalesPaymentArray;
    
    NSMutableArray *filteredOutstandingClassPaymentArray;
    NSMutableArray *filteredOutstandingSalesPaymentArray;
    
    UITableView *sortingtable;
    NSMutableArray *sortingarray;
    UILabel *sortingnamelabel;
    UIButton *sortingorderbutton;
    SortingRecord *sortingobject;
    
    //NSMutableArray * defaultcheckedsalespaymentsaleskeys;
    //NSMutableArray * defaultcheckedclasspaymentenrollmentkeys;
    //NSMutableArray * defaultcheckedclassinvoiceenrollmentkeys;
    //NSMutableArray * defaultcheckedsalesinvoicesaleskeys;
    //NSMutableArray * defaultcheckedclassreceiptpaymentkeys;
    //NSMutableArray * defaultcheckedsalesreceiptpaymentkeys;
    
    UIBarButtonItem *invoiceButton;
    UIButton *receiptprintbutton;
    
    Student *studentobject;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIWindow *mainWindow;
    
    UIActivityIndicatorView *ailoadindicator;
    UIStoryboard *mainStoryboard;
    UIViewController *paymentviewcontroller;
    
    __weak IBOutlet UIButton *bankinbutton;
    
    __weak IBOutlet UIView *menubottombar;
    __weak IBOutlet UIButton *OutstandingViewButton;
    __weak IBOutlet UIButton *BankinViewButton;
    __weak IBOutlet UIButton *InvoiceViewButton;
    __weak IBOutlet UIButton *PaymentViewButton;
    
    NSMutableArray *InvoiceLogArray;
    NSMutableArray *filteredInvoiceLogArray;
    NSString *selectedinvoicelogkey;
    NSInteger selectedinvoicerow;
    
    __weak IBOutlet UITableView *InvoiceLogRecordTable;
    __weak IBOutlet UITableView *InvoiceLogItemTable;
    __weak IBOutlet UISegmentedControl *InvoiceTypeSC;
    __weak IBOutlet UISearchBar *invoiceSearchField;
    __weak IBOutlet UILabel *noInvoiceRecordLabel;
    
    __weak IBOutlet UIButton *selectInvoiceButton;
    
    
    __weak IBOutlet UIView *InvoiceView;
    __weak IBOutlet UILabel *title_Invoice_Log;
    __weak IBOutlet UILabel *title_Invoice_Item_Student;
    __weak IBOutlet UILabel *title_Invoice_Item_Type;
    __weak IBOutlet UILabel *title_Invoice_Item_Description;
    __weak IBOutlet UILabel *title_Invoice_Item_Amount;
    __weak IBOutlet UILabel *title_Invoice_Item_Paid;
    __weak IBOutlet UIView *title_view1;
    
    InvoiceLogItem *invoicelogitemobject;
    
    __weak IBOutlet UIView *PaymentReceivedView;
    __weak IBOutlet UILabel *noPaymentReceivedRecordLabel;
    __weak IBOutlet UITableView *PaymentReceivedTable;
    __weak IBOutlet UITableView *PaymentReceivedDetailsTable;
    __weak IBOutlet UISearchBar *paymentreceivedSearchField;
    NSMutableArray *PaymentReceivedDetailsRecordsArray;
    NSMutableArray *filteredPaymentReceivedDetailsRecordsArray;
    NSMutableArray *PaymentReceivedRecordsArray;
    NSString *selectedpaiddate;
    NSInteger selectedpaiddaterow;
    __weak IBOutlet UILabel *tite_payment_last_30_days;
    __weak IBOutlet UILabel *tite_payment_Student;
    __weak IBOutlet UILabel *tite_payment_Type;
    __weak IBOutlet UILabel *tite_payment_Item_Description;
    __weak IBOutlet UILabel *tite_payment_Paid_Method;
    __weak IBOutlet UILabel *tite_payment_Paid;
    __weak IBOutlet UILabel *tite_payment_Staff;
    __weak IBOutlet UILabel *tite_payment_Payment_Remarks;
    __weak IBOutlet UILabel *tite_payment_Receipt_Remarks;
    
    __weak IBOutlet UIButton *selectalloutstandingbutton;
    __weak IBOutlet UIButton *deselectoutstandingbutton;
    __weak IBOutlet UIView *selectoutstandingview;
    
}

@property (nonatomic, strong) NSMutableArray * JSONArray;
@property (nonatomic, strong) OutstandingPaymentRecord *OutstandingPaymentObject;
//@property (nonatomic, strong) NSMutableArray * OutstandingPaymentArray;
@property (nonatomic, strong) OutstandingBankinRecord *OutstandingBankinObject;
@property (nonatomic, strong) NSMutableArray * OutstandingBankinArray;
@property (nonatomic, strong) PaymentRecord * DetailsPaymentObject;
@property (nonatomic, strong) NSMutableArray * DetailsPaymentArray;
@property (nonatomic, strong) NSString * tablemode;
@property (nonatomic, strong) NSString *selectedValue;
@property (nonatomic, strong) UIPickerView *myPickerView;

@property (strong,nonatomic) UIToolbar *paymentToolbar;
@property (strong,nonatomic) UIView *paymentMasterView;
@property (strong,nonatomic) UIView *bankinInputMasterView;
@property (strong,nonatomic) UIToolbar *bankinInputToolbar;

@property (strong,nonatomic) UIPopoverPresentationController *myPopoverController;
@property (strong,nonatomic) UIPopoverPresentationController *myDatePickerPopoverController;
@property (weak, nonatomic) IBOutlet UITableView *OutstandingClassPaymentTable;
@property (weak, nonatomic) IBOutlet UITableView *OutstandingSalesPaymentTable;
@property (weak, nonatomic) IBOutlet UITableView *OutstandingBankinTable;
@property (strong, nonatomic) UITableView *DetailsPaymentTable;
@property (strong, nonatomic) UITableView *BankinInputTable;
@property (weak, nonatomic) IBOutlet UIView *PaymentView;
@property (weak, nonatomic) IBOutlet UIView *BankinView;
//@property (weak, nonatomic) IBOutlet UISegmentedControl *sctable;
@property (weak, nonatomic) IBOutlet UISegmentedControl *scclassday;


//@property (weak, nonatomic) IBOutlet UILabel *bankinbuttonlabel;
//@property (weak, nonatomic) IBOutlet UIButton *bankinbutton;
//- (IBAction)bankinbuttonpressed:(id)sender;


@property (strong,nonatomic) EnrollmentRecord *DetailsViewEnrollment;
//- (IBAction)selecttable:(id)sender;
- (IBAction)selectclassday:(id)sender;
- (IBAction)menubutton:(id)sender;
- (IBAction)selectpaymenttype:(id)sender;
- (IBAction)combinepaymentbuttonpressed:(id)sender;
- (IBAction)sortingbuttonpressed:(id)sender;
- (IBAction)bankinbuttonpressed:(id)sender;
- (IBAction)changeview:(id)sender;
- (IBAction)selectInvoiceType:(id)sender;
- (IBAction)selectInvoiceButtonPressed:(id)sender;
- (IBAction)selectalloutstandingbuttonpressed:(id)sender;
- (IBAction)deselectoutstandingbuttonpressed:(id)sender;





@end
