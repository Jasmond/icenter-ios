//
//  DocumentFolderPopoverViewController.h
//  EyeEnroll
//
//  Created by Jasmond Luk on 3/4/15.
//  Copyright (c) 2015 Dreamware Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyObject.h"
#import "MyClass.h"
#import <MessageUI/MessageUI.h>
#import "CalendarView.h"
//#import "StudentDetailsNavController.h"
//#import "StudentDetailsViewController.h"
#import "MessagePopoverViewController.h"
#import "MainViewController.h"

@protocol myDocumentFolderPopoverViewController <NSObject>
-(void) refreshdocumentfoldercountnumber;
-(void) dismissDocumentFolderPopover;
-(void) refreshDocumentFolderPresentingViewScreen;
-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width;
-(void) refreshdocumentfoldercount;

@end

@interface DocumentFolderPopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIDocumentInteractionControllerDelegate,MFMailComposeViewControllerDelegate,UIPrintInteractionControllerDelegate,myCalendarViewDelegate,myMessagePopoverViewControllerDelegate>
{
    GlobalVariables *globalvariables;
    NSDateFormatter *df;
    NSNumberFormatter *formatter;
    NSNumberFormatter *formatter2;
    NSNumberFormatter *discountformatter;
    
    MainViewController *mainviewcontroller;
    
    //UIImage *boyimage;
    //UIImage *girlimage;
    __weak IBOutlet UIView *masterview;
    __weak IBOutlet UIView *supermasterview;
    
    UIButton *invoicebutton;
    UIButton *receiptbutton;
    UIButton *paymentbutton;
    
    __weak IBOutlet UIButton *invoice_printbutton;
    __weak IBOutlet UIButton *invoice_emailbutton;
    __weak IBOutlet UIButton *invoice_sharebutton;
    __weak IBOutlet UIButton *receipt_printbutton;
    __weak IBOutlet UIButton *receipt_emailbutton;
    __weak IBOutlet UIButton *receipt_sharebutton;
    __weak IBOutlet UIButton *payment_paybutton;
    __weak IBOutlet UIButton *selectallbutton;
    __weak IBOutlet UIButton *receipt_messagebutton;
    __weak IBOutlet UIButton *invoice_messagebutton;
    __weak IBOutlet UIButton *payment_adddiscountbutton;
    __weak IBOutlet UIButton *payment_savediscountbutton;
    __weak IBOutlet UIButton *payment_cleardiscountbutton;
    
    __weak IBOutlet UIButton *receipt_combine_leftbutton;
    __weak IBOutlet UIButton *receipt_combine_rightbutton;
    __weak IBOutlet UIButton *invoice_combine_leftbutton;
    __weak IBOutlet UIButton *invoice_combine_rightbutton;
    
    __weak IBOutlet UIImageView *invoice_selectedcountimage;
    __weak IBOutlet UIImageView *receipt_selectedcountimage;
    __weak IBOutlet UIImageView *payment_selectedcountimage;
    __weak IBOutlet UILabel *invoice_selectedcountlabel;
    __weak IBOutlet UILabel *receipt_selectedcountlabel;
    __weak IBOutlet UILabel *payment_selectedcountlabel;
    
    __weak IBOutlet UIView *invoiceview;
    __weak IBOutlet UIView *receiptview;
    __weak IBOutlet UIView *paymentview;
    __weak IBOutlet UIView *discounttableview;
    __weak IBOutlet UISearchBar *promotioncodesearchbar;
    __weak IBOutlet UILabel *promotioncodetitle;
    
    UIButton *deselectalldocumentfolderbutton;
    UIButton *selectalldocumentfolderbutton;
//    UIBarButtonItem *flexSpace;
    UIButton *clearallbutton;
    NSMutableArray *barItems;
    
    __weak IBOutlet UITableView *invoicetable;
    __weak IBOutlet UITableView *receipttable;
    __weak IBOutlet UITableView *paymenttable;
    __weak IBOutlet UITableView *paidmethodtable;
    __weak IBOutlet UITableView *paiddatetable;
    __weak IBOutlet UITableView *PromotionCodeTable;
    __weak IBOutlet UITableView *CouponTable;
    __weak IBOutlet UITableView *DiscountTable;
    NSArray *paidmethodarray;
    
    __weak IBOutlet UILabel *invoice_noitemlabel;
    __weak IBOutlet UILabel *receipt_noitemlabel;
    __weak IBOutlet UILabel *payment_noitemlabel;
    __weak IBOutlet NSLayoutConstraint *masterviewleadingconstraint;
    __weak IBOutlet NSLayoutConstraint *supermasterviewleadingconstraint;
    __weak IBOutlet NSLayoutConstraint *paymentviewbottomconstraint;
    __weak IBOutlet NSLayoutConstraint *invoiceviewbottomconstraint;
    __weak IBOutlet NSLayoutConstraint *receiptviewbottomconstraint;
    
    //NSCache *imageCache;
    //NSString *imagelastupdatetime;
    //NSIndexPath *selectedPaidMethodButtonIndexPath;
    //NSIndexPath *selectedPaidDateButtonIndexPath;
    MultiCoordinate *selectedbuttoncoordinate;
    
    NSMutableArray *documentfolderclassinvoicearray;
    NSMutableArray *documentfolderclassreceiptarray;
    NSMutableArray *documentfoldersalesinvoicearray;
    NSMutableArray *documentfoldersalesreceiptarray;
    NSMutableArray *documentfolderclasspaymentarray;
    NSMutableArray *documentfoldersalespaymentarray;
    
    ClassInvoiceRecord *classinvoicerecordobject;
    //ClassReceiptRecord *classreceiptrecordobject;
    
    SalesInvoiceRecord *salesinvoicerecordobject;
    //SalesReceiptRecord *salesreceiptrecordobject;
    
    ClassPaymentRecord *classpaymentrecordobject;
    SalesPaymentRecord *salespaymentrecordobject;
    
    UIToolbar *DocumentFolderToolBar;
    
    UIDocumentInteractionController * documentInteractionController;
    
    UIButton *printbutton;
    UIButton *sharebutton;
    UIButton *emailbutton;

    
    float keyboardheight;
    
    UIView *sidewindowview;
    UIButton *sidewindowviewclosebutton;
    UIWindow *mainWindow;
    
    UIActivityIndicatorView *ailoadindicator;
    UIStoryboard *mainStoryboard;
    
    BOOL invoiceupdated;
    
    NSMutableArray *filteredavailablepromotionarray;
    NSMutableArray *availablepromotionarray;
    __weak IBOutlet UIButton *promotioncodeclosebutton;
    
    
    NSMutableArray *newlyusedcouponarray;
    NSMutableArray *availablecouponarray;
    NSMutableArray *filteredavailablecouponarray;
    NSMutableArray *releasedcouponarray;
    
    __weak IBOutlet UISearchBar *couponsearchbar;
    __weak IBOutlet UILabel *coupontitle;
    __weak IBOutlet UIButton *couponclosebutton;
    __weak IBOutlet UIView *couponView;
    __weak IBOutlet UIView *promotioncodeView;
    
}



@property (nonatomic,weak) id<myDocumentFolderPopoverViewController>delegate;
@property (nonatomic) long menubutton;
//@property (nonatomic,strong) NSMutableArray *defaultcheckedclasspaymentenrollmentkeys;
//@property (nonatomic,strong) NSMutableArray *defaultcheckedsalespaymentsaleskeys;
//@property (nonatomic,strong) NSMutableArray *defaultcheckedclassinvoiceenrollmentkeys;
//@property (nonatomic,strong) NSMutableArray *defaultcheckedsalesinvoicesaleskeys;
//@property (nonatomic,strong) NSMutableArray *defaultcheckedclassreceiptpaymentkeys;
//@property (nonatomic,strong) NSMutableArray *defaultcheckedsalesreceiptpaymentkeys;
- (IBAction)closesidewindow:(id)sender;
- (IBAction)savediscountbuttonpressed:(id)sender;
- (IBAction)cleardiscountbuttonpressed:(id)sender;
@end
