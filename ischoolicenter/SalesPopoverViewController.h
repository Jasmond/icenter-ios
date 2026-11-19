//
//  SalesPopoverViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 7/12/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "sqlite3.h"
#import <MessageUI/MessageUI.h>
#import "GCPlaceholderTextView.h"
#import "MessagePopoverViewController.h"
#import "StudentImageGridViewController.h"

@protocol mySalesPopoverViewControllerDelegate <NSObject>

-(SalesRecord *) updatesalesrecordandreturnsalesrecord:(NSString *)saleskey;
-(void) dismissSalesPopover;
-(void) dismissSalesPopoverduetoconnectionerror;
-(void) refreshdocumentfoldercount;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;

@end

@interface SalesPopoverViewController : UIViewController<UIPopoverPresentationControllerDelegate,UIAlertViewDelegate,UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITextViewDelegate,UIDocumentInteractionControllerDelegate,MFMailComposeViewControllerDelegate,UITextFieldDelegate,UISearchBarDelegate,UIPrintInteractionControllerDelegate,myCalendarViewDelegate,myStudentImageGridViewControllerDelegate>
{
    GlobalVariables *globalvariables;
    UIStoryboard *mainStoryboard;
    //sqlite3 *isdb;
    
    UILabel *salesgeneralLabel;
    
    UILabel *OrderDateLabel;
    UILabel *CategoryLabel;
    UILabel *ProductLabel;
    UILabel *CodeLabel;
    UILabel *UnitPriceLabel;
    UILabel *QuantityLabel;
    UILabel *DiscountLabel;
    UILabel *TotalPriceLabel;
    UILabel *TotalPaidLabel;
    UILabel *RemarksLabel;
    UISegmentedControl *scMessageChannel;
    
    //UIStepper *spQuantity;
    UITextField *QuantityText;
    UITextField *GivenOutText;
    UITextField *DiscountText;
    UISwitch *swEnableNotification;
    UITextView *RemarksText;
    UIButton *DeleteOrderButton;
    
    
    
    UILabel *detailspaymentLabel;
    UILabel *paymenttotalfeeLabel;
    UILabel *paymenttotalpaidLabel;
    UILabel *paymentoutstandingLabel;
    
    GCPlaceholderTextView *paymentremarksText;
    GCPlaceholderTextView *receiptremarksText;
    
    UITextView *invoiceremarksText;
    
    UILabel *invoiceremarkslabel;
    
    UILabel *paymentremarkslabel;
    UILabel *receiptremarkslabel;
    
    UILabel *paidmethodLabel;
    UILabel *paiddateLabel;
    UITextField *detailspaymentText;
    UILabel *paymentremarksLabel;
    UILabel *receptremarksLabel;

    
    NSString *selectedItem;
    
    long presetRow;
    long datePresetRow;
    long minutePresetRow;
    long hourPresetRow;

    BOOL showPaidMethodPicker;
    BOOL showPaymentDatePicker;
    
    BOOL showDetailPayment;
    BOOL showVoidWindow;
    BOOL showOrderDatePicker;
    
    SalesRecord *workingSales;
    
    NSString *tmpPaidDate;
    NSString *tmppaidamount;
    NSString *tmppaidmethod;
    NSString *tmppaymentremarks;
    NSString *tmpreceiptremarks;
    
    float keyboardheight;
    
    NSMutableArray *ProductArray;
    NSMutableArray *filteredProductArray;
    NSMutableArray *CategoryArray;
    NSMutableArray *filteredCategoryArray;
    
    UIDocumentInteractionController * documentInteractionController;
    
    NSDateFormatter *df;
    
//    UITableView *SalesPopoverTable;
    __weak IBOutlet UITableView *SalesPopoverTable;
    __weak IBOutlet NSLayoutConstraint *salesPopoverTableBottomConstraint;
    
    IBOutlet UIToolbar *SalesToolBar;
    
    //UIScrollView *paymentScrollView;
    //UIView *paymentMasterView;
    UIToolbar *paymentToolbar;
    
    UITableView *DetailsPaymentTable;
    NSString *DetailsPaymentTableMode;
    //PaymentRecord *DetailsPaymentObject;
    //NSMutableArray *DetailsPaymentArray;
    
    NSMutableArray *JSONArray;
    
    NSMutableArray *pickerViewmenu;
    //NSMutableArray *datePickerViewMenu;
    //NSMutableArray *paymentDatePickerViewMenu;
    NSMutableArray *hourPickerViewMenu;
    NSMutableArray *minutePickerViewMenu;
    
    
    UIPickerView *myPickerView;
    UIPopoverPresentationController *myPopoverController;
    //UIPopoverPresentationController *myPaymentPopoverController;
    
    ProductRecord *productobject;

    UIPopoverPresentationController *mySharePopovercontroller;
    UITableView *sharetable;
    NSIndexPath *paymentindexpath;
    NSString *invoiceorreceipt;
    
    UIActivityIndicatorView *aishareprint;
    UIActivityIndicatorView *aishareemail;
    UIActivityIndicatorView *aishareothers;
    UIActivityIndicatorView *aisendmessage;
    
    BOOL nointernet;
    
    long DetailsPaymentObjectIndex;
    
    BOOL paymentoverride;
    
//    UIView *DetailPaymentMasterView;
    __weak IBOutlet UIView *DetailPaymentMasterView;
    UIView *DLSeparatorLine;
    
    UIToolbar *VoidWindowToolBar;
    UIView *VoidWindowMasterView;
    UITableView *VoidTable;
    BOOL showRefundMethodPicker;
    
    UILabel *VoidTotalPaidLabel;
    UILabel *VoidForfeitLabel;
    UITextField *RefundAmountText;
    NSString *tmprefundamount;
    NSString *tmpvoidforfeitedamount;
    NSString *tmprefundmethod;
    
    
    int noofroundoffdigit;
    
    UIButton *invoiceprintbutton;
    UIButton *receiptprintbutton;
    
    UIView *CategoryTableMasterView;
    UITableView *CategoryTable;
    UIToolbar *CategoryTableToolBar;
    BOOL showCategoryTable;
    UISearchBar *categorysearchbar;

    UIView *ProductTableMasterView;
    UITableView *ProductTable;
    UIToolbar *ProductTableToolBar;
    BOOL showProductTable;
    UISearchBar *productsearchbar;
    
    __weak IBOutlet UIView *DiscountTableMasterView;
    UITableView *DiscountTable;
    UIToolbar *DiscountTableToolBar;
    BOOL showDiscountTable;
    NSMutableArray *availablepromotionarray;
    NSMutableArray *filteredavailablepromotionarray;
    //NSMutableArray *usedpromotionarray;
    
    __weak IBOutlet UITableView *PromotionCodeTable;
    
    UILabel *PCDescriptionLabel;
    UILabel *PCDiscountAmountLabel;
    UILabel *PCExpiryLabel;
    UILabel *PCQuotaLabel;
    UIButton *PCAddButton;
    
    UILabel *DTDescriptionLabel;
    UILabel *DTDiscountAmountLabel;
    
    MarketingRecord *marketingobject;
    BOOL showpromotioncodetable;
    UISearchBar *promotionsearchbar;
    
    NSString *DiscountTableMode;
    NSString *tmpTotalDiscount;
    //NSString *tmpManualOneOffFixedDiscount;
    //NSString *tmpManualOneOffPercentageDiscount;
    UITextField *OneOffFixedDiscountText;
    UITextField *OneOffPercentageDiscountText;
    UILabel *OneOffPercentageDiscountLabel;
    UILabel *OneOffFixedDiscountLabel;
    UILabel *DTTotalDiscountLabel;
    
    BOOL newReceiptToBeMessaged;
    
    StudentImageGridViewController *studentimagepopover;
    
    NSMutableArray *availablecouponarray;
    NSMutableArray *filteredavailablecouponarray;
    
    BOOL showcoupontable;
    UISearchBar *couponsearchbar;
    __weak IBOutlet UITableView *CouponTable;
    __weak IBOutlet UIView *couponview;
    __weak IBOutlet UIView *promotioncodeview;
    
    BOOL neworderwillbecreated;
    
    __weak IBOutlet UIButton *copyButton;
    __weak IBOutlet UIButton *editButton;
    __weak IBOutlet UIButton *doneButton;
    __weak IBOutlet UIButton *cancelButton;
    __weak IBOutlet UILabel *toolbarLabel;
    
    
    __weak IBOutlet UIButton *payment_receiptButton;
    __weak IBOutlet UIButton *payment_invoiceButton;
    __weak IBOutlet UIButton *payment_addButton;
    __weak IBOutlet UIButton *payment_cancelButton;
    __weak IBOutlet UIButton *payment_saveButton;
    __weak IBOutlet UIButton *payment_cancelremarksButton;
    __weak IBOutlet UIButton *payment_doneremarksButton;

}

@property (nonatomic, strong) SalesRecord * SalesObject;
@property (nonatomic,strong) Student *PopoverStudent;
@property (nonatomic, strong) NSString *SalesTableMode;
@property (nonatomic,weak) id<mySalesPopoverViewControllerDelegate>delegate;

-(BOOL) retrieveProductList;
-(BOOL) InitializeField;

- (IBAction)editButtonPressed:(id)sender;
- (IBAction)copyButtonPressed:(id)sender;
- (IBAction)doneButtonPressed:(id)sender;
- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)closesubwindow:(id)sender;

- (IBAction)addpaymentrecord:(id)sender;
- (IBAction)shareinvoicebutton:(id)sender;
- (IBAction)sharereceiptbutton:(id)sender;
- (IBAction)canceladdpayment:(id)sender;
- (IBAction)donepaymentrecord:(id)sender;
- (IBAction)cancelpaymentremarks:(id)sender;
- (IBAction)donepaymentremarks:(id)sender;


@end
