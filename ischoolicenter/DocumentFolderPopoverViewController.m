//
//  DocumentFolderPopoverViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 3/4/15.
//  Copyright (c) 2015 Dreamware Limited. All rights reserved.
//

#import "DocumentFolderPopoverViewController.h"
#import "StudentDetailsNavController.h"
#import "StudentDetailsViewController.h"
#import "MyTableViewCell.h"
#import "SceneDelegate.h"


@interface DocumentFolderPopoverViewController ()<myStudentViewController>
@end

#define documentfoldertablewidth 750
#define documentfoldertablemaxheight self.view.frame.size.height
#define buttonsectionheight 55
#define paidmethodtablewidth 300
#define paiddatetablewidth 300
#define promotioncodetablewidth 300
#define buttonwidth 120

@implementation DocumentFolderPopoverViewController
@synthesize menubutton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    globalvariables=[GlobalVariables singleObj];
    self.view.backgroundColor=[UIColor systemGroupedBackgroundColor];
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    formatter = [[NSNumberFormatter alloc]init];
    [formatter setMaximumFractionDigits:globalvariables.centerrecord.noofroundoffdigit];
    [formatter setMinimumFractionDigits:0];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatter setCurrencySymbol:@""];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    formatter2 = [[NSNumberFormatter alloc]init];
    [formatter2 setMaximumFractionDigits:globalvariables.centerrecord.noofroundoffdigit]; // Set this if you need 2 digits
    [formatter2 setMinimumFractionDigits:0];
    formatter2.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatter2 setCurrencySymbol:@"$"];
    [formatter2 setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    discountformatter = [[NSNumberFormatter alloc]init];
    [discountformatter setMaximumFractionDigits:globalvariables.centerrecord.noofroundoffdigit];
    [discountformatter setMinimumFractionDigits:0];
    discountformatter.numberStyle = NSNumberFormatterCurrencyStyle;
    [discountformatter setCurrencySymbol:@""];
    [discountformatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    
    invoiceupdated=NO;
    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    //add toolbar
    DocumentFolderToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, documentfoldertablewidth, 44)];
    DocumentFolderToolBar.barTintColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    DocumentFolderToolBar.clipsToBounds=YES;
//    barItems=[[NSMutableArray alloc]init];
    

//    deselectalldocumentfolderbutton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Deselect all"] style:UIBarButtonItemStylePlain target:self action:@selector(deselectalldocumentfolderrecords)];
//    deselectalldocumentfolderbutton.tintColor=[UIColor whiteColor];
//    selectalldocumentfolderbutton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Select all"] style:UIBarButtonItemStylePlain target:self action:@selector(selectalldocumentfolderrecords)];
//    selectalldocumentfolderbutton.tintColor=[UIColor whiteColor];
//    flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    clearallbutton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Delete all"] style:UIBarButtonItemStylePlain target:self action:@selector(clearalldocumentfolderrecords)];
//    clearallbutton.tintColor=[UIColor whiteColor];
//    barItems = [[NSMutableArray alloc]initWithObjects:clearallbutton,flexSpace,selectalldocumentfolderbutton,deselectalldocumentfolderbutton, nil];
//    
    
    
//    [DocumentFolderToolBar setItems:barItems];
    [self.view addSubview:DocumentFolderToolBar];
    
    deselectalldocumentfolderbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    deselectalldocumentfolderbutton.frame = CGRectMake(20, 33, 100, 20);
    [deselectalldocumentfolderbutton setTitle:[MyClass returntitlewithtitle:@"Deselect all"] forState:UIControlStateNormal];
    [deselectalldocumentfolderbutton addTarget:self action:@selector(deselectalldocumentfolderrecords) forControlEvents:UIControlEventTouchUpInside];
    [deselectalldocumentfolderbutton sizeToFit];
    deselectalldocumentfolderbutton.frame = CGRectMake(documentfoldertablewidth-deselectalldocumentfolderbutton.frame.size.width-20, 33, deselectalldocumentfolderbutton.frame.size.width, 20);
    [self.view addSubview:deselectalldocumentfolderbutton];
    
    selectalldocumentfolderbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    selectalldocumentfolderbutton.frame = CGRectMake(20, 33, 100, 20);
    [selectalldocumentfolderbutton setTitle:[MyClass returntitlewithtitle:@"Select all"] forState:UIControlStateNormal];
    [selectalldocumentfolderbutton addTarget:self action:@selector(selectalldocumentfolderrecords) forControlEvents:UIControlEventTouchUpInside];
    [selectalldocumentfolderbutton sizeToFit];
    selectalldocumentfolderbutton.frame = CGRectMake(deselectalldocumentfolderbutton.frame.origin.x-selectalldocumentfolderbutton.frame.size.width-20, 33, selectalldocumentfolderbutton.frame.size.width, 20);
    [self.view addSubview:selectalldocumentfolderbutton];
    
    clearallbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    clearallbutton.frame = CGRectMake(20, 33, 100, 20);
    [clearallbutton setTitle:[MyClass returntitlewithtitle:@"Delete all"] forState:UIControlStateNormal];
    [clearallbutton addTarget:self action:@selector(clearalldocumentfolderrecords) forControlEvents:UIControlEventTouchUpInside];
    [clearallbutton sizeToFit];
    clearallbutton.frame = CGRectMake(20, 33, clearallbutton.frame.size.width, 20);
    [self.view addSubview:clearallbutton];
    
    
    //add buttons
    invoicebutton=[[UIButton alloc]initWithFrame:CGRectMake(0,44+20,documentfoldertablewidth/3,44)];
    invoicebutton.backgroundColor=[UIColor darkGrayColor];
    [invoicebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    invoicebutton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    invoicebutton.titleLabel.textAlignment=NSTextAlignmentCenter;
    invoicebutton.tag=0;
    //[invoicebutton setTitle:[MyClass returntitlewithtitle:@"Invoice"] forState:UIControlStateNormal];
    [invoicebutton addTarget:self action:@selector(menubuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:invoicebutton];
    
    UIImageView *colorimage=[[UIImageView alloc]initWithFrame:CGRectMake(35, 15, 14, 14)];
    [colorimage setImage:[UIImage imageNamed:@"green_icon.png"]];
    colorimage.layer.opacity=0.5;
    [invoicebutton addSubview:colorimage];
    
    receiptbutton=[[UIButton alloc]initWithFrame:CGRectMake(documentfoldertablewidth*2/3,44+20,documentfoldertablewidth/3,44)];
    //receiptbutton=[[UIButton alloc]initWithFrame:CGRectMake(documentfoldertablewidth/3,44,documentfoldertablewidth/3,44)];
    receiptbutton.backgroundColor=[UIColor darkGrayColor];
    [receiptbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    receiptbutton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    receiptbutton.titleLabel.textAlignment=NSTextAlignmentCenter;
    receiptbutton.tag=1;
    //[receiptbutton setTitle:[MyClass returntitlewithtitle:@"Receipt"] forState:UIControlStateNormal];
    [receiptbutton addTarget:self action:@selector(menubuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:receiptbutton];
    
    colorimage=[[UIImageView alloc]initWithFrame:CGRectMake(35, 15, 14, 14)];
    [colorimage setImage:[UIImage imageNamed:@"orange_icon.png"]];
    colorimage.layer.opacity=0.5;
    [receiptbutton addSubview:colorimage];
    
    paymentbutton=[[UIButton alloc]initWithFrame:CGRectMake(documentfoldertablewidth/3,44+20,documentfoldertablewidth/3,44)];
    //paymentbutton=[[UIButton alloc]initWithFrame:CGRectMake(documentfoldertablewidth*2/3,44,documentfoldertablewidth/3,44)];
    paymentbutton.backgroundColor=[UIColor darkGrayColor];
    [paymentbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    paymentbutton.titleLabel.font=[UIFont boldSystemFontOfSize:15];
    paymentbutton.titleLabel.textAlignment=NSTextAlignmentCenter;
    paymentbutton.tag=2;
    //[paymentbutton setTitle:[MyClass returntitlewithtitle:@"Payment"] forState:UIControlStateNormal];
    [paymentbutton addTarget:self action:@selector(menubuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:paymentbutton];
    
    colorimage=[[UIImageView alloc]initWithFrame:CGRectMake(35, 15, 14, 14)];
    [colorimage setImage:[UIImage imageNamed:@"red_icon.png"]];
    colorimage.layer.opacity=0.5;
    [paymentbutton addSubview:colorimage];

    
    //UIView *selectalllabelbackground = [[UIView alloc]initWithFrame:CGRectMake(documentfoldertablewidth-paiddatetablewidth, 88+20, paiddatetablewidth, 38)];
    //selectalllabelbackground.backgroundColor=[UIColor whiteColor];
    //[self.view addSubview:selectalllabelbackground];
    
    //selectallbutton=[[UIButton alloc]initWithFrame:CGRectMake(3,3,selectalllabelbackground.frame.size.width-6,selectalllabelbackground.frame.size.height-6)];
    [selectallbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectallbutton setTitle:[MyClass returntitlewithtitle:@"Set all items"] forState:UIControlStateNormal];
    selectallbutton.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    selectallbutton.layer.cornerRadius=5;
    selectallbutton.titleLabel.font=[UIFont systemFontOfSize:14];
    //selectallbutton.titleLabel.textAlignment=NSTextAlignmentCenter;
    [selectallbutton addTarget:self action:@selector(updateallitems:) forControlEvents:UIControlEventTouchUpInside];
    //[selectalllabelbackground addSubview:selectallbutton];
    
    
    paidmethodarray=[[NSArray alloc]initWithArray:[MyClass returnPaidMethodArray]];

    paidmethodtable.hidden=YES;

    paiddatetable.hidden=YES;

    [invoice_printbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [invoice_printbutton setTitle:[MyClass returntitlewithtitle:@"Print"] forState:UIControlStateNormal];
    invoice_printbutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    invoice_printbutton.backgroundColor=[UIColor whiteColor];
    invoice_printbutton.layer.borderWidth=1;
    invoice_printbutton.layer.cornerRadius=4;
    invoice_printbutton.layer.masksToBounds=YES;

    [invoice_printbutton addTarget: self action:@selector(printbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [invoice_printbutton addTarget: self action:@selector(highlightbuttoncolor:) forControlEvents: UIControlEventTouchDown];
    [invoice_printbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchCancel];
    [invoice_printbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchUpOutside];

    [invoice_emailbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [invoice_emailbutton setTitle:[MyClass returntitlewithtitle:@"Email"] forState:UIControlStateNormal];
    invoice_emailbutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    invoice_emailbutton.backgroundColor=[UIColor whiteColor];
    invoice_emailbutton.layer.borderWidth=1;
    invoice_emailbutton.layer.cornerRadius=4;
    invoice_emailbutton.layer.masksToBounds=YES;

    [invoice_emailbutton addTarget: self action:@selector(emailbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [invoice_emailbutton addTarget: self action:@selector(highlightbuttoncolor:) forControlEvents: UIControlEventTouchDown];
    [invoice_emailbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchCancel];
    [invoice_emailbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchUpOutside];

    

    [invoice_sharebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [invoice_sharebutton setTitle:[MyClass returntitlewithtitle:@"Share"] forState:UIControlStateNormal];
    invoice_sharebutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    invoice_sharebutton.backgroundColor=[UIColor whiteColor];
    invoice_sharebutton.layer.borderWidth=1;
    invoice_sharebutton.layer.cornerRadius=4;
    invoice_sharebutton.layer.masksToBounds=YES;

    [invoice_sharebutton addTarget: self action:@selector(sharebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [invoice_sharebutton addTarget: self action:@selector(highlightbuttoncolor:) forControlEvents: UIControlEventTouchDown];
    [invoice_sharebutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchCancel];
    [invoice_sharebutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchUpOutside];

    [invoice_messagebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [invoice_messagebutton setTitle:[MyClass returntitlewithtitle:@"eInvoice"] forState:UIControlStateNormal];
    invoice_messagebutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    invoice_messagebutton.backgroundColor=[UIColor whiteColor];
    invoice_messagebutton.layer.borderWidth=1;
    invoice_messagebutton.layer.cornerRadius=4;
    invoice_messagebutton.layer.masksToBounds=YES;
    [invoice_messagebutton addTarget: self action:@selector(messagebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [invoice_messagebutton addTarget: self action:@selector(highlightbuttoncolor:) forControlEvents: UIControlEventTouchDown];
    [invoice_messagebutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchCancel];
    [invoice_messagebutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchUpOutside];

    [invoice_combine_leftbutton addTarget:self action:@selector(invoice_combine_left_pressed) forControlEvents:UIControlEventTouchUpInside];
    [invoice_combine_rightbutton addTarget:self action:@selector(invoice_combine_right_pressed) forControlEvents:UIControlEventTouchUpInside];
    invoice_noitemlabel.text=[MyClass returntitlewithtitle:@"No item selected"];

    [receipt_printbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [receipt_printbutton setTitle:[MyClass returntitlewithtitle:@"Print"] forState:UIControlStateNormal];
    receipt_printbutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    receipt_printbutton.backgroundColor=[UIColor whiteColor];
    receipt_printbutton.layer.borderWidth=1;
    receipt_printbutton.layer.cornerRadius=4;
    receipt_printbutton.layer.masksToBounds=YES;
    [receipt_printbutton addTarget: self action:@selector(printbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [receipt_printbutton addTarget: self action:@selector(highlightbuttoncolor:) forControlEvents: UIControlEventTouchDown];
    [receipt_printbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchCancel];
    [receipt_printbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchUpOutside];
    [receipt_emailbutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [receipt_emailbutton setTitle:[MyClass returntitlewithtitle:@"Email"] forState:UIControlStateNormal];
    receipt_emailbutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    receipt_emailbutton.backgroundColor=[UIColor whiteColor];
    receipt_emailbutton.layer.borderWidth=1;
    receipt_emailbutton.layer.cornerRadius=4;
    receipt_emailbutton.layer.masksToBounds=YES;

    [receipt_emailbutton addTarget: self action:@selector(emailbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [receipt_emailbutton addTarget: self action:@selector(highlightbuttoncolor:) forControlEvents: UIControlEventTouchDown];
    [receipt_emailbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchCancel];
    [receipt_emailbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchUpOutside];
    //[receiptbuttonbackgroundview addSubview:receipt_emailbutton];
    
    //receipt_sharebutton =[[UIButton alloc]initWithFrame:CGRectMake(receiptview.frame.size.width-buttonwidth-15-buttonwidth-10-buttonwidth-10-buttonwidth-10,(buttonsectionheight-35)/2,buttonwidth,35)];
    [receipt_sharebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [receipt_sharebutton setTitle:[MyClass returntitlewithtitle:@"Share"] forState:UIControlStateNormal];
    receipt_sharebutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    receipt_sharebutton.backgroundColor=[UIColor whiteColor];
    receipt_sharebutton.layer.borderWidth=1;
    receipt_sharebutton.layer.cornerRadius=4;
    receipt_sharebutton.layer.masksToBounds=YES;
    //receipt_sharebutton.tag=1;
    //receipt_sharebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //receipt_sharebutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [receipt_sharebutton addTarget: self action:@selector(sharebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [receipt_sharebutton addTarget: self action:@selector(highlightbuttoncolor:) forControlEvents: UIControlEventTouchDown];
    [receipt_sharebutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchCancel];
    [receipt_sharebutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchUpOutside];
    //[receiptbuttonbackgroundview addSubview:receipt_sharebutton];

    //receipt_messagebutton =[[UIButton alloc]initWithFrame:CGRectMake(receiptview.frame.size.width-buttonwidth-15-buttonwidth-10,(buttonsectionheight-35)/2,buttonwidth,35)];
    [receipt_messagebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [receipt_messagebutton setTitle:[MyClass returntitlewithtitle:@"eReceipt"] forState:UIControlStateNormal];
    receipt_messagebutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    receipt_messagebutton.backgroundColor=[UIColor whiteColor];
    receipt_messagebutton.layer.borderWidth=1;
    receipt_messagebutton.layer.cornerRadius=4;
    receipt_messagebutton.layer.masksToBounds=YES;
    //receipt_messagebutton.tag=1;
    //receipt_messagebutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    //receipt_messagebutton.titleLabel.font=[UIFont systemFontOfSize:18];
    [receipt_messagebutton addTarget: self action:@selector(messagebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [receipt_messagebutton addTarget: self action:@selector(highlightbuttoncolor:) forControlEvents: UIControlEventTouchDown];
    [receipt_messagebutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchCancel];
    [receipt_messagebutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchUpOutside];
    [receipt_combine_leftbutton addTarget:self action:@selector(receipt_combine_left_pressed) forControlEvents:UIControlEventTouchUpInside];
    [receipt_combine_rightbutton addTarget:self action:@selector(receipt_combine_right_pressed) forControlEvents:UIControlEventTouchUpInside];
    receipt_noitemlabel.text=[MyClass returntitlewithtitle:@"No item selected"];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnTableView:)];
    [paymenttable addGestureRecognizer:tap];
    

    [payment_paybutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [payment_paybutton setTitle:[MyClass returntitlewithtitle:@"Pay"] forState:UIControlStateNormal];
    payment_paybutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    payment_paybutton.backgroundColor=[UIColor whiteColor];
    payment_paybutton.layer.borderWidth=1;
    payment_paybutton.layer.cornerRadius=4;
    payment_paybutton.layer.masksToBounds=YES;
    payment_paybutton.tag=2;

    [payment_paybutton addTarget: self action:@selector(paybuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [payment_paybutton addTarget: self action:@selector(highlightbuttoncolor:) forControlEvents: UIControlEventTouchDown];
    [payment_paybutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchCancel];
    [payment_paybutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchUpOutside];
    
    payment_adddiscountbutton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscount;
    [payment_adddiscountbutton setTitleColor:payment_adddiscountbutton.enabled?[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [payment_adddiscountbutton setTitle:[MyClass returntitlewithtitle:@"Add Discount"] forState:UIControlStateNormal];
    payment_adddiscountbutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    payment_adddiscountbutton.backgroundColor=[UIColor whiteColor];
    payment_adddiscountbutton.layer.borderWidth=1;
    payment_adddiscountbutton.layer.cornerRadius=4;
    payment_adddiscountbutton.layer.masksToBounds=YES;
    [payment_adddiscountbutton addTarget: self action:@selector(adddiscountbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
    [payment_adddiscountbutton addTarget: self action:@selector(highlightbuttoncolor:) forControlEvents: UIControlEventTouchDown];
    [payment_adddiscountbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchCancel];
    [payment_adddiscountbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchUpOutside];
    
    payment_savediscountbutton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscount;
    [payment_savediscountbutton setTitleColor:payment_savediscountbutton.enabled?[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [payment_savediscountbutton setTitle:[MyClass returntitlewithtitle:@"Save Discount"] forState:UIControlStateNormal];
    payment_savediscountbutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    payment_savediscountbutton.backgroundColor=[UIColor whiteColor];
    payment_savediscountbutton.layer.borderWidth=1;
    payment_savediscountbutton.layer.cornerRadius=4;
    payment_savediscountbutton.layer.masksToBounds=YES;
    [payment_savediscountbutton addTarget: self action:@selector(highlightbuttoncolor:) forControlEvents: UIControlEventTouchDown];
    [payment_savediscountbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchCancel];
    [payment_savediscountbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchUpOutside];
    

    payment_cleardiscountbutton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscount;
    [payment_cleardiscountbutton setTitleColor:payment_cleardiscountbutton.enabled?[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [payment_cleardiscountbutton setTitle:[MyClass returntitlewithtitle:@"Clear Discount"] forState:UIControlStateNormal];
    payment_cleardiscountbutton.layer.borderColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0].CGColor;
    payment_cleardiscountbutton.backgroundColor=[UIColor whiteColor];
    payment_cleardiscountbutton.layer.borderWidth=1;
    payment_cleardiscountbutton.layer.cornerRadius=4;
    payment_cleardiscountbutton.layer.masksToBounds=YES;
    [payment_cleardiscountbutton addTarget: self action:@selector(highlightbuttoncolor:) forControlEvents: UIControlEventTouchDown];
    [payment_cleardiscountbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchCancel];
    [payment_cleardiscountbutton addTarget: self action:@selector(resetbuttoncolor:) forControlEvents: UIControlEventTouchUpOutside];
    
    
    payment_noitemlabel.text=[MyClass returntitlewithtitle:@"No item selected"];
    UIView *separatorview=[[UIView alloc]initWithFrame:CGRectMake(documentfoldertablewidth, 0, 0.5, documentfoldertablemaxheight)];
    separatorview.backgroundColor=[UIColor grayColor];
    [paymentview addSubview:separatorview];
    
    [self loaddocumentfolderarray];
    
    [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];

    
    if (menubutton==2) {
        [self menubuttonpressed:paymentbutton];
    }else{
        [self menubuttonpressed:invoicebutton];
    }
    
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
    [sidewindowviewclosebutton addTarget:self action:@selector(closesidewindow) forControlEvents:UIControlEventTouchUpInside];
    [mainWindow addSubview:sidewindowviewclosebutton];
    
    sidewindowview=[[UIView alloc]initWithFrame:CGRectMake(mainWindow.bounds.size.width, 0, 320, mainWindow.bounds.size.height)];
    sidewindowview.backgroundColor=[UIColor systemGroupedBackgroundColor];
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
    
    promotioncodesearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    promotioncodetitle.text=[[MyClass returntitlewithtitle:@"Add Promotion"] uppercaseString];
    availablepromotionarray=[[MyClass retrieveMarketingRecordWithStatus:@"Valid" enrollmentdate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] flushcachedata:NO subjectkey:@"allonly" productkey:@"allonly"] objectAtIndex:2];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.manualapply == YES"];
    filteredavailablepromotionarray=[[NSMutableArray alloc]initWithArray:[availablepromotionarray filteredArrayUsingPredicate:predicate]];
//    filteredavailablepromotionarray=[[NSMutableArray alloc]initWithArray:availablepromotionarray];
    //batchpromotioncodekey=[[NSMutableArray alloc]init];
    
    DiscountTable.allowsMultipleSelectionDuringEditing=NO;
    [DiscountTable setEditing:YES animated:YES];
    selectedbuttoncoordinate=nil;
    
    couponsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    coupontitle.text=[[MyClass returntitlewithtitle:@"Add Coupon"] uppercaseString];
    
    releasedcouponarray=[[NSMutableArray alloc]init];
    newlyusedcouponarray=[[NSMutableArray alloc]init];
}


- (void)keyboardDidHide: (NSNotification *) notification
{
    // Do something here
    keyboardheight=0;
    //[self storeTmpField];
    [self adjusttablesize];
    
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    //[self storeTmpField];
    [self adjusttablesize];
    
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    //[self storeTmpField];
    [self adjusttablesize];
    
}

-(void) invoice_combine_left_pressed
{
    if (invoice_combine_leftbutton.tag==0) {
        [invoice_combine_leftbutton setImage:[UIImage imageNamed:@"combinedocument_left_select_icon.png"] forState:UIControlStateNormal];
        [invoice_combine_rightbutton setImage:[UIImage imageNamed:@"combinedocument_right_unselect_icon.png"] forState:UIControlStateNormal];
        invoice_combine_leftbutton.tag=1;
        invoice_combine_rightbutton.tag=0;
    }

}

-(void) invoice_combine_right_pressed
{
    if (invoice_combine_rightbutton.tag==0) {
        [invoice_combine_leftbutton setImage:[UIImage imageNamed:@"combinedocument_left_unselect_icon.png"] forState:UIControlStateNormal];
        [invoice_combine_rightbutton setImage:[UIImage imageNamed:@"combinedocument_right_select_icon.png"] forState:UIControlStateNormal];
        invoice_combine_leftbutton.tag=0;
        invoice_combine_rightbutton.tag=1;
    }

}

-(void) receipt_combine_left_pressed
{
    if (receipt_combine_leftbutton.tag==0) {
        [receipt_combine_leftbutton setImage:[UIImage imageNamed:@"combinedocument_left_select_icon.png"] forState:UIControlStateNormal];
        [receipt_combine_rightbutton setImage:[UIImage imageNamed:@"combinedocument_right_unselect_icon.png"] forState:UIControlStateNormal];
        receipt_combine_leftbutton.tag=1;
        receipt_combine_rightbutton.tag=0;
    }

}

-(void) receipt_combine_right_pressed
{
    if (receipt_combine_rightbutton.tag==0) {
        [receipt_combine_leftbutton setImage:[UIImage imageNamed:@"combinedocument_left_unselect_icon.png"] forState:UIControlStateNormal];
        [receipt_combine_rightbutton setImage:[UIImage imageNamed:@"combinedocument_right_select_icon.png"] forState:UIControlStateNormal];
        receipt_combine_leftbutton.tag=0;
        receipt_combine_rightbutton.tag=1;
    }

}

-(void) loaddocumentfolderarray
{
    NSMutableDictionary *documentfolderarray=[MyClass retrieveDocumentFolderRecordWithSendOutboxDocument:@"No"];
    
    documentfolderclassinvoicearray=[[NSMutableArray alloc]init];
    for (int i=0; i<((NSMutableArray *)documentfolderarray[@"classinvoicearray"]).count; i++) {
        classinvoicerecordobject=[((NSMutableArray *)documentfolderarray[@"classinvoicearray"]) objectAtIndex:i];
        if ([globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:classinvoicerecordobject.enrollmentkey]) {
            classinvoicerecordobject.checkstatus=@"checked";
        }
        [documentfolderclassinvoicearray addObject:classinvoicerecordobject];
        
        
    }
    
    documentfolderclassreceiptarray=[[NSMutableArray alloc]init];
    for (int i=0; i<((NSMutableArray *)documentfolderarray[@"classreceiptarray"]).count; i++) {
        ClassReceiptRecord *classreceiptrecordobject=[((NSMutableArray *)documentfolderarray[@"classreceiptarray"]) objectAtIndex:i];
        if ([globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:classreceiptrecordobject.enrollmentkey]) {
            classreceiptrecordobject.checkstatus=@"checked";
        }
        [documentfolderclassreceiptarray addObject:classreceiptrecordobject];
    }
    
    documentfoldersalesinvoicearray=[[NSMutableArray alloc]init];
    for (int i=0; i<((NSMutableArray *)documentfolderarray[@"salesinvoicearray"]).count; i++) {
        salesinvoicerecordobject=[((NSMutableArray *)documentfolderarray[@"salesinvoicearray"]) objectAtIndex:i];
        if ([globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:salesinvoicerecordobject.saleskey]) {
            salesinvoicerecordobject.checkstatus=@"checked";
        }
        [documentfoldersalesinvoicearray addObject:salesinvoicerecordobject];
    }
    
    documentfoldersalesreceiptarray=[[NSMutableArray alloc]init];
    for (int i=0; i<((NSMutableArray *)documentfolderarray[@"salesreceiptarray"]).count; i++) {
        SalesReceiptRecord *salesreceiptrecordobject=[((NSMutableArray *)documentfolderarray[@"salesreceiptarray"]) objectAtIndex:i];
        if ([globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:salesreceiptrecordobject.saleskey]) {
            salesreceiptrecordobject.checkstatus=@"checked";
        }
        [documentfoldersalesreceiptarray addObject:salesreceiptrecordobject];
    }
    
    
    documentfolderclasspaymentarray=[[NSMutableArray alloc]init];
    for (int i=0; i<((NSMutableArray *)documentfolderarray[@"classpaymentarray"]).count; i++) {
        classpaymentrecordobject=[((NSMutableArray *)documentfolderarray[@"classpaymentarray"]) objectAtIndex:i];
        if ([globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:classpaymentrecordobject.enrollmentkey]) {
            classpaymentrecordobject.checkstatus=@"checked";
        }
        [documentfolderclasspaymentarray addObject:classpaymentrecordobject];
    }
    
    documentfoldersalespaymentarray=[[NSMutableArray alloc]init];
    for (int i=0; i<((NSMutableArray *)documentfolderarray[@"salespaymentarray"]).count; i++) {
        salespaymentrecordobject=[((NSMutableArray *)documentfolderarray[@"salespaymentarray"]) objectAtIndex:i];
        if ([globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:salespaymentrecordobject.saleskey]) {
            salespaymentrecordobject.checkstatus=@"checked";
        }
        [documentfoldersalespaymentarray addObject:salespaymentrecordobject];
    }
    
    [invoicebutton setTitle:[NSString stringWithFormat:@"%@(%d)",[MyClass returntitlewithtitle:@"Invoice"],(int)documentfolderclassinvoicearray.count+(int)documentfoldersalesinvoicearray.count] forState:UIControlStateNormal];
    [receiptbutton setTitle:[NSString stringWithFormat:@"%@(%d)",[MyClass returntitlewithtitle:@"Receipt"],(int)documentfolderclassreceiptarray.count+(int)documentfoldersalesreceiptarray.count] forState:UIControlStateNormal];
    [paymentbutton setTitle:[NSString stringWithFormat:@"%@(%d)",[MyClass returntitlewithtitle:@"Payment"],(int)documentfolderclasspaymentarray.count+(int)documentfoldersalespaymentarray.count] forState:UIControlStateNormal];
}

-(void)highlightbuttoncolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)resetbuttoncolor:(UIButton *)sender
{
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
}


-(void) menubuttonpressed:(UIButton *)sender
{

    if (sender.tag==0) {
        invoicebutton.backgroundColor=[UIColor grayColor];
        [invoicebutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        receiptbutton.backgroundColor=[UIColor darkGrayColor];
        [receiptbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        paymentbutton.backgroundColor=[UIColor darkGrayColor];
        [paymentbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        invoiceview.hidden=NO;
        receiptview.hidden=YES;
        paymentview.hidden=YES;
        [invoicetable reloadData];
        [self refreshInvoiceSelectedPaymentCount];
        
//        barItems = [[NSMutableArray alloc]initWithObjects:clearallbutton,flexSpace,selectalldocumentfolderbutton,deselectalldocumentfolderbutton, nil];
//        [DocumentFolderToolBar setItems:barItems];

    }else if (sender.tag==1){
        invoicebutton.backgroundColor=[UIColor darkGrayColor];
        [invoicebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        receiptbutton.backgroundColor=[UIColor grayColor];
        [receiptbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        paymentbutton.backgroundColor=[UIColor darkGrayColor];
        [paymentbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        invoiceview.hidden=YES;
        receiptview.hidden=NO;
        paymentview.hidden=YES;
        [receipttable reloadData];
        [self refreshReceiptSelectedPaymentCount];
//        barItems = [[NSMutableArray alloc]initWithObjects:clearallbutton,flexSpace,selectalldocumentfolderbutton,deselectalldocumentfolderbutton, nil];
//        [DocumentFolderToolBar setItems:barItems];

    }else{
        invoicebutton.backgroundColor=[UIColor darkGrayColor];
        [invoicebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        receiptbutton.backgroundColor=[UIColor darkGrayColor];
        [receiptbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        paymentbutton.backgroundColor=[UIColor grayColor];
        [paymentbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        invoiceview.hidden=YES;
        receiptview.hidden=YES;
        paymentview.hidden=NO;
        [paymenttable reloadData];
        [self refreshPaymentSelectedPaymentCount];
        //barItems = [[NSMutableArray alloc]initWithObjects:clearallbutton,flexSpace, nil];
//        barItems = [[NSMutableArray alloc]initWithObjects:clearallbutton,flexSpace,selectalldocumentfolderbutton,deselectalldocumentfolderbutton, nil];
//        [DocumentFolderToolBar setItems:barItems];
    }
    [self openSideWindowWithTable:@"none"];
    [self adjusttablesize];

}


    
-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) adjusttablesize
{
    //[self openSideWindowWithTable:@"none"];
    
    if (!invoiceview.hidden) {
        if (keyboardheight==0) {
            invoiceviewbottomconstraint.constant=0;
        }else{
            invoiceviewbottomconstraint.constant=keyboardheight-55;
        }

        if (documentfolderclassinvoicearray.count+documentfoldersalesinvoicearray.count==0) {
            invoice_noitemlabel.hidden=NO;
        }else{
            invoice_noitemlabel.hidden=YES;
        }
    }else if (!receiptview.hidden){
        if (keyboardheight==0) {
            receiptviewbottomconstraint.constant=0;
        }else{
            receiptviewbottomconstraint.constant=keyboardheight-55;
        }
        
        if (documentfolderclassreceiptarray.count+documentfoldersalesreceiptarray.count==0) {
            receipt_noitemlabel.hidden=NO;
        }else{
            receipt_noitemlabel.hidden=YES;
        }
        
        
    }else if (!paymentview.hidden){
        if (keyboardheight==0) {
            paymentviewbottomconstraint.constant=0;
        }else{
            paymentviewbottomconstraint.constant=keyboardheight-55;
        }
        
        if (discounttableview.hidden) {
            [self openSideWindowWithTable:@"none"];
        }

        if (documentfolderclasspaymentarray.count+documentfoldersalespaymentarray.count==0) {
            payment_noitemlabel.hidden=NO;
        }else{
            payment_noitemlabel.hidden=YES;
        }
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==paidmethodtable || tableView==paiddatetable || tableView==PromotionCodeTable || tableView==CouponTable) {
        return 1;
    }else if (tableView==DiscountTable){
        return selectedbuttoncoordinate?(globalvariables.centerrecord.ecoupon?3:2):0;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==invoicetable) {
        if (section==0) {
            return documentfolderclassinvoicearray.count;
        }else if (section==1){
            return documentfoldersalesinvoicearray.count;
        }
    }else if (tableView==receipttable){
        if (section==0) {
            return documentfolderclassreceiptarray.count;
        }else if (section==1){
            return documentfoldersalesreceiptarray.count;
        }
    }else if (tableView==paymenttable){
        if (section==0) {
            return documentfolderclasspaymentarray.count;
        }else if (section==1){
            return documentfoldersalespaymentarray.count;
        }
    }else if (tableView==paidmethodtable){
        return paidmethodarray.count;
    }else if (tableView==paiddatetable){
        return 1;
    }else if (tableView==PromotionCodeTable){
        return filteredavailablepromotionarray.count;
    }else if (tableView==CouponTable){
        return filteredavailablecouponarray.count;
    }else if (tableView==DiscountTable){
        if (section==0) {
            NSMutableArray *promotionarray= [self returnPromotionArray];
            return promotionarray.count==0?1:promotionarray.count;
        }else if (section==1){
            return 2;
        }else if (section==2) {
            NSMutableArray *couponarray= [self returnCouponArray];
            return couponarray.count==0?1:couponarray.count;
        }else{
            return 1;
        }
    }
    return 0;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==promotioncodesearchbar){
        if ([searchText isEqualToString:@""]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.manualapply == YES"];
            filteredavailablepromotionarray=[[NSMutableArray alloc]initWithArray:[availablepromotionarray filteredArrayUsingPredicate:predicate]];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.manualapply == YES and (self.description contains[c] %@ or self.description_chinese contains[c] %@ or self.promotionfixeddiscount contains[c] %@ or self.promotionpercentagediscount contains[c] %@ or self.code contains[c] %@)",searchText,searchText,searchText,searchText,searchText];
            filteredavailablepromotionarray=[[NSMutableArray alloc]initWithArray:[availablepromotionarray filteredArrayUsingPredicate:predicate]];
        }
        [PromotionCodeTable reloadData];
        [PromotionCodeTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==couponsearchbar){
        if ([searchText isEqualToString:@""]) {
            filteredavailablepromotionarray=[[NSMutableArray alloc]initWithArray:availablepromotionarray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(CouponRecord *object, NSDictionary *bindings) {
                MarketingRecord *mktobj=[MyClass returnMarketingRecordWithMarketingKey:object.marketingkey index:3];
                return [mktobj.code rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound || [mktobj.description rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound || [mktobj.description_chinese rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound || [mktobj.promotionfixeddiscount rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound || [mktobj.promotionpercentagediscount rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.effectiveto rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.issuedate rangeOfString:searchText options:NSCaseInsensitiveSearch].location!=NSNotFound ;
            }];

            filteredavailablecouponarray=[[NSMutableArray alloc]initWithArray:[availablecouponarray filteredArrayUsingPredicate:predicate]];
        }
        [CouponTable reloadData];
        [CouponTable setContentOffset:CGPointZero animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==invoicetable) {
        UITableViewCell *cell;
        
        if (indexPath.section==0) {
            MyTableViewCell *cell;
            static NSString *CellIdentifier= @"classinvoicecell";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
                singleTap.numberOfTapsRequired = 1;
            [cell.imageview2 addGestureRecognizer:singleTap];
            cell.imageview2.userInteractionEnabled = YES;
            cell.label6.text=[MyClass returntitlewithtitle:@"Total Fee"];
            cell.label7.text=[MyClass returntitlewithtitle:@"invoice_Total"];
            cell.label12.text=[MyClass returntitlewithtitle:@"Total Discount"];
            cell.label14.text=[MyClass returntitlewithtitle:@"Outstanding"];
            cell.textfield3.placeholder=[MyClass returntitlewithtitle:@"Invoice Remarks"];
            [cell.textfield3 addTarget:self action:@selector(updateciinvoiceremarks:)forControlEvents:UIControlEventEditingDidEnd];
            [cell.textfield3 addTarget:self action:@selector(closedocumentsidewindow) forControlEvents:UIControlEventEditingDidBegin];
            cell.textfield3.tag=indexPath.row;
            
            ClassInvoiceRecord * classinvoicerecordobj=[documentfolderclassinvoicearray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returnStudentnameWithStudentkey:classinvoicerecordobj.studentkey option:@"full"];
            cell.label10.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[classinvoicerecordobj.totalfee floatValue]]];

            
            if ([classinvoicerecordobj.outstandingamount intValue]==0) {
                cell.label15.text=@"-";
                cell.label15.textColor=[UIColor darkGrayColor];
            }else{
                cell.label15.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[classinvoicerecordobj.outstandingamount floatValue]]];
                cell.label15.textColor=[UIColor redColor];
            }

            //cell.label15.text=[MyClass returndateformatwithdate:classreceiptrecordobject.paiddate];
            //cell.label17.text=[MyClass returntitlewithtitle:classreceiptrecordobj.paidmethod];
            
            cell.label13.text=[discountformatter stringFromNumber:[NSNumber numberWithFloat:[self returnEnrollmentDiscountWithClassInvoiceobject:classinvoicerecordobj]]];
            
            [MyClass downloadImageWithImageview:cell.imageview2 gender:nil type:@"student" typekey:classinvoicerecordobj.studentkey image:classinvoicerecordobj.image async:YES];
            
            cell.textfield3.text=classinvoicerecordobj.invoiceremarks;
            cell.label9.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[classinvoicerecordobj.tuitionfee floatValue]+[classinvoicerecordobj.enrollmentrecord.enrollmentfee floatValue]+[classinvoicerecordobj.enrollmentrecord.latefee floatValue]]];
                cell.label2.text=[MyClass returnsubjectnamewithsubject_shortname:classinvoicerecordobj.subject_shortname centerkey:globalvariables.centerrecord.centerkey];
                cell.label3.text=[NSString stringWithFormat:@"%@ %@ %@",[MyClass returndateformatwithdate:classinvoicerecordobj.startdate],[MyClass returntitlewithtitle:@"documentfolder_to"],[MyClass returndateformatwithdate:classinvoicerecordobj.enddate]];
                cell.label4.text=[NSString stringWithFormat:@"%@ %@",classinvoicerecordobj.noofclass,[classinvoicerecordobj.noofclass intValue]>1?[MyClass returntitlewithtitle:@"Classes"]:[MyClass returntitlewithtitle:@"documentfolder_Class"]];
                cell.label5.text=classinvoicerecordobj.classtime;
                
                if ([classinvoicerecordobj.checkstatus isEqualToString:@""]) {
                    cell.imageview1.layer.opacity=0.3;
                }else{
                    cell.imageview1.layer.opacity=1;
                }
            
            classinvoicerecordobj.enrollmentrecord.tuitionfee=classinvoicerecordobj.tuitionfee;
            NSMutableArray *discountarray=[MyClass returnDiscountArrayWithEnrollmentRecord2:classinvoicerecordobj.enrollmentrecord];
            if (discountarray.count==0) {
                cell.stackview1.hidden=YES;
            }else{
                cell.stackview1.hidden=NO;
                [[cell.stackview2 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [[cell.stackview3 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i=0; i<discountarray.count; i++) {
                    DiscountRecord *obj=[discountarray objectAtIndex:i];
                    UILabel *discountdesc=[[UILabel alloc]init];
                    [discountdesc setTextColor:[UIColor grayColor]];
                    discountdesc.textAlignment=NSTextAlignmentRight;
                    [discountdesc setFont:[UIFont systemFontOfSize:9]];
                    
                    if ([globalvariables.language isEqualToString:@"English"]) {
                        discountdesc.text=obj.description;
                    }else{
                        discountdesc.text=obj.description_chinese;
                    }
                    [cell.stackview2 addArrangedSubview:discountdesc];
                    
                    UILabel *discountvalue=[[UILabel alloc]init];
                    discountvalue.textAlignment=NSTextAlignmentRight;
                    [discountvalue setTextColor:[UIColor grayColor]];
                    [discountvalue setFont:[UIFont systemFontOfSize:10]];
                    discountvalue.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[obj.discount floatValue]==0?0:[obj.discount floatValue]*-1]];
                    [cell.stackview3 addArrangedSubview:discountvalue];
                }
            }
            
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            MyTableViewCell *cell;
            static NSString *CellIdentifier= @"salesinvoicecell";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
            singleTap.numberOfTapsRequired = 1;
            [cell.imageview2 addGestureRecognizer:singleTap];
            cell.imageview2.userInteractionEnabled = YES;
            cell.label7.text=[MyClass returntitlewithtitle:@"invoice_Total"];
            cell.label6.text=[MyClass returntitlewithtitle:@"Total Fee"];
            cell.label12.text=[MyClass returntitlewithtitle:@"Total Discount"];
            cell.label14.text=[MyClass returntitlewithtitle:@"Paid Date"];
            cell.textfield3.placeholder=[MyClass returntitlewithtitle:@"Invoice Remarks"];
            [cell.textfield3 addTarget:self action:@selector(updateciinvoiceremarks:)forControlEvents:UIControlEventEditingDidEnd];
            [cell.textfield3 addTarget:self action:@selector(closedocumentsidewindow) forControlEvents:UIControlEventEditingDidBegin];
            cell.textfield3.tag=indexPath.row;
            
            SalesInvoiceRecord *salesinvoicerecordobj=[documentfoldersalesinvoicearray objectAtIndex:indexPath.row];
            cell.label1.text=[MyClass returnStudentnameWithStudentkey:salesinvoicerecordobj.studentkey option:@"full"];
            cell.label10.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[salesinvoicerecordobj.totalfee floatValue]]];
            
            if ([salesinvoicerecordobj.outstandingamount intValue]==0) {
                cell.label15.text=@"-";
                cell.label15.textColor=[UIColor darkGrayColor];
            }else{
                cell.label15.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[salesinvoicerecordobj.outstandingamount floatValue]]];
                cell.label15.textColor=[UIColor redColor];
            }

            //cell.label11.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[salesreceiptrecordobj.paidamount floatValue]]];
            //cell.label11.textColor=[UIColor redColor];
            
            //cell.label15.text=[MyClass returndateformatwithdate:salesreceiptrecordobj.paiddate];
            //cell.label17.text=[MyClass returntitlewithtitle:salesreceiptrecordobj.paidmethod];
            
            cell.label13.text=[discountformatter stringFromNumber:[NSNumber numberWithFloat:[self returnSalesDiscountWithSalesInvoiceobject:salesinvoicerecordobj]]];
            
            [MyClass downloadImageWithImageview:cell.imageview2 gender:nil type:@"student" typekey:salesinvoicerecordobj.studentkey image:salesinvoicerecordobj.image async:YES];


            cell.textfield3.text=salesinvoicerecordobj.invoiceremarks;
            cell.label9.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[salesinvoicerecordobj.quantity floatValue]*[salesinvoicerecordobj.price floatValue]]];
            cell.label2.text=[MyClass returnproductnamewithproductcode:salesinvoicerecordobj.productcode centerkey:globalvariables.centerrecord.centerkey];
            /*if ([globalvariables.language isEqualToString:@"English"]) {
                cell.label2.text=((ProductRecord *)[MyClass returnProductInformationWithCode:salesinvoicerecordobj.productcode centerkey:globalvariables.centerrecord.centerkey]).englishname;
            }else{
                cell.label2.text=((ProductRecord *)[MyClass returnProductInformationWithCode:salesinvoicerecordobj.productcode centerkey:globalvariables.centerrecord.centerkey]).chinesename;
            }*/
            
            cell.label3.text=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"Quantity"],salesinvoicerecordobj.quantity];
         
            if ([salesinvoicerecordobj.checkstatus isEqualToString:@""]) {
                cell.imageview1.layer.opacity=0.3;
            }else{
                cell.imageview1.layer.opacity=1;
            }
            
            
            
            
            salesinvoicerecordobj.salesrecord.quantity=salesinvoicerecordobj.quantity;
            salesinvoicerecordobj.salesrecord.price=salesinvoicerecordobj.price;
            NSMutableArray *discountarray=[MyClass returnDiscountArrayWithSalesRecord2:salesinvoicerecordobj.salesrecord];
            if (discountarray.count==0) {
                cell.stackview1.hidden=YES;
            }else{
                cell.stackview1.hidden=NO;
                [[cell.stackview2 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [[cell.stackview3 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i=0; i<discountarray.count; i++) {
                    DiscountRecord *obj=[discountarray objectAtIndex:i];
                    UILabel *discountdesc=[[UILabel alloc]init];
                    [discountdesc setTextColor:[UIColor grayColor]];
                    discountdesc.textAlignment=NSTextAlignmentRight;
                    [discountdesc setFont:[UIFont systemFontOfSize:9]];
                    
                    if ([globalvariables.language isEqualToString:@"English"]) {
                        discountdesc.text=obj.description;
                    }else{
                        discountdesc.text=obj.description_chinese;
                    }
                    [cell.stackview2 addArrangedSubview:discountdesc];
                    
                    UILabel *discountvalue=[[UILabel alloc]init];
                    discountvalue.textAlignment=NSTextAlignmentRight;
                    [discountvalue setTextColor:[UIColor grayColor]];
                    [discountvalue setFont:[UIFont systemFontOfSize:10]];
                    discountvalue.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[obj.discount floatValue]==0?0:[obj.discount floatValue]*-1]];
                    [cell.stackview3 addArrangedSubview:discountvalue];
                }
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        
       
        return cell;
    }else if (tableView==receipttable) {
        UITableViewCell *cell;
        
        if (indexPath.section==0) {
            MyTableViewCell *cell;
            static NSString *CellIdentifier= @"classreceiptcell";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
                singleTap.numberOfTapsRequired = 1;
            [cell.imageview2 addGestureRecognizer:singleTap];
            cell.imageview2.userInteractionEnabled = YES;
            cell.label6.text=[MyClass returntitlewithtitle:@"Total Fee"];
            cell.label7.text=[MyClass returntitlewithtitle:@"receipt_Total"];
            cell.label8.text=[MyClass returntitlewithtitle:@"Paid Amount"];
            cell.label12.text=[MyClass returntitlewithtitle:@"Total Discount"];
            cell.label14.text=[MyClass returntitlewithtitle:@"Total Paid"];
            cell.label16.text=[MyClass returntitlewithtitle:@"Latest Payment"];
//            cell.label16.text=[MyClass returntitlewithtitle:@"Paid Method"];
            
            cell.textfield2.placeholder=[MyClass returntitlewithtitle:@"Internal payment remarks"];
            [cell.textfield2 addTarget:self action:@selector(updatecrpaymentremarks:)forControlEvents:UIControlEventEditingDidEnd];
            [cell.textfield2 addTarget:self action:@selector(closedocumentsidewindow) forControlEvents:UIControlEventEditingDidBegin];
            cell.textfield2.tag=indexPath.row;
            
            cell.textfield3.placeholder=[MyClass returntitlewithtitle:@"Remarks to be printed on receipt"];
            [cell.textfield3 addTarget:self action:@selector(updatecrreceiptremarks:)forControlEvents:UIControlEventEditingDidEnd];
            [cell.textfield3 addTarget:self action:@selector(closedocumentsidewindow) forControlEvents:UIControlEventEditingDidBegin];
            cell.textfield3.tag=indexPath.row;
            
            ClassReceiptRecord * classreceiptrecordobj=[documentfolderclassreceiptarray objectAtIndex:indexPath.row];
            PaymentRecord *lastrecord=[classreceiptrecordobj.enrollmentrecord.paymentrecords firstObject];
            
            cell.label1.text=[MyClass returnStudentnameWithStudentkey:classreceiptrecordobj.studentkey option:@"full"];
            cell.label10.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[classreceiptrecordobj.totalfee floatValue]]];
            cell.label15.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[classreceiptrecordobj.paid floatValue]]];
            cell.label17.text=[NSString stringWithFormat:@"%@ / %@ / %@",  [MyClass returndateformatwithdate:lastrecord.paiddate dateformat:@"dd-MMM-yyyy"],[MyClass returntitlewithtitle:lastrecord.paidmethod],[formatter2 stringFromNumber:[NSNumber numberWithFloat:[lastrecord.paidamount floatValue]]]];

//            cell.label15.text=[MyClass returndateformatwithdate:classreceiptrecordobj.paiddate];
//            cell.label17.text=[MyClass returntitlewithtitle:classreceiptrecordobj.paidmethod];
            
            cell.label13.text=[discountformatter stringFromNumber:[NSNumber numberWithFloat:[self returnEnrollmentDiscountWithClassReceiptobject:classreceiptrecordobj]]];
            
            [MyClass downloadImageWithImageview:cell.imageview2 gender:nil type:@"student" typekey:classreceiptrecordobj.studentkey image:classreceiptrecordobj.image async:YES];
            
            cell.textfield2.text=lastrecord.paymentremarks;
            cell.textfield3.text=lastrecord.receiptremarks;
            
            cell.label9.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[classreceiptrecordobj.tuitionfee floatValue]+[classreceiptrecordobj.enrollmentrecord.enrollmentfee floatValue]+[classreceiptrecordobj.enrollmentrecord.latefee floatValue]]];
                cell.label2.text=[MyClass returnsubjectnamewithsubject_shortname:classreceiptrecordobj.subject_shortname centerkey:globalvariables.centerrecord.centerkey];
                cell.label3.text=[NSString stringWithFormat:@"%@ %@ %@",[MyClass returndateformatwithdate:classreceiptrecordobj.startdate],[MyClass returntitlewithtitle:@"documentfolder_to"],[MyClass returndateformatwithdate:classreceiptrecordobj.enddate]];
                cell.label4.text=[NSString stringWithFormat:@"%@ %@",classreceiptrecordobj.noofclass,[classreceiptrecordobj.noofclass intValue]>1?[MyClass returntitlewithtitle:@"Classes"]:[MyClass returntitlewithtitle:@"documentfolder_Class"]];
                cell.label5.text=classreceiptrecordobj.classtime;
                
                if ([classreceiptrecordobj.checkstatus isEqualToString:@""]) {
                    cell.imageview1.layer.opacity=0.3;
                }else{
                    cell.imageview1.layer.opacity=1;
                }
            
            classreceiptrecordobj.enrollmentrecord.tuitionfee=classreceiptrecordobj.tuitionfee;
            NSMutableArray *discountarray=[MyClass returnDiscountArrayWithEnrollmentRecord2:classreceiptrecordobj.enrollmentrecord];
            if (discountarray.count==0) {
                cell.stackview1.hidden=YES;
            }else{
                cell.stackview1.hidden=NO;
                [[cell.stackview2 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [[cell.stackview3 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i=0; i<discountarray.count; i++) {
                    DiscountRecord *obj=[discountarray objectAtIndex:i];
                    UILabel *discountdesc=[[UILabel alloc]init];
                    [discountdesc setTextColor:[UIColor grayColor]];
                    discountdesc.textAlignment=NSTextAlignmentRight;
                    [discountdesc setFont:[UIFont systemFontOfSize:9]];
                    
                    if ([globalvariables.language isEqualToString:@"English"]) {
                        discountdesc.text=obj.description;
                    }else{
                        discountdesc.text=obj.description_chinese;
                    }
                    [cell.stackview2 addArrangedSubview:discountdesc];
                    
                    UILabel *discountvalue=[[UILabel alloc]init];
                    discountvalue.textAlignment=NSTextAlignmentRight;
                    [discountvalue setTextColor:[UIColor grayColor]];
                    [discountvalue setFont:[UIFont systemFontOfSize:10]];
                    discountvalue.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[obj.discount floatValue]==0?0:[obj.discount floatValue]*-1]];
                    [cell.stackview3 addArrangedSubview:discountvalue];
                }
            }
            
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            MyTableViewCell *cell;
            static NSString *CellIdentifier= @"salesreceiptcell";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
            singleTap.numberOfTapsRequired = 1;
            [cell.imageview2 addGestureRecognizer:singleTap];
            cell.imageview2.userInteractionEnabled = YES;
            cell.label7.text=[MyClass returntitlewithtitle:@"receipt_Total"];
            cell.label8.text=[MyClass returntitlewithtitle:@"Paid Amount"];
            cell.label6.text=[MyClass returntitlewithtitle:@"Total Fee"];
            cell.label12.text=[MyClass returntitlewithtitle:@"Total Discount"];
            cell.label14.text=[MyClass returntitlewithtitle:@"Total Paid"];
            cell.label16.text=[MyClass returntitlewithtitle:@"Latest Payment"];
            
            cell.textfield2.placeholder=[MyClass returntitlewithtitle:@"Internal payment remarks"];
            [cell.textfield2 addTarget:self action:@selector(updatesrpaymentremarks:)forControlEvents:UIControlEventEditingDidEnd];
            [cell.textfield2 addTarget:self action:@selector(closedocumentsidewindow) forControlEvents:UIControlEventEditingDidBegin];
            cell.textfield2.tag=indexPath.row;
            cell.textfield3.placeholder=[MyClass returntitlewithtitle:@"Remarks to be printed on receipt"];
            [cell.textfield3 addTarget:self action:@selector(updatesrreceiptremarks:)forControlEvents:UIControlEventEditingDidEnd];
            [cell.textfield3 addTarget:self action:@selector(closedocumentsidewindow) forControlEvents:UIControlEventEditingDidBegin];
            cell.textfield3.tag=indexPath.row;
            
            SalesReceiptRecord *salesreceiptrecordobj=[documentfoldersalesreceiptarray objectAtIndex:indexPath.row];
            PaymentRecord *lastrecord=[salesreceiptrecordobj.salesrecord.paymentrecords firstObject];
            
            cell.label1.text=[MyClass returnStudentnameWithStudentkey:salesreceiptrecordobj.studentkey option:@"full"];
            cell.label10.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[salesreceiptrecordobj.totalfee floatValue]]];

            cell.label15.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[salesreceiptrecordobj.paid floatValue]]];
            cell.label17.text=[NSString stringWithFormat:@"%@ / %@ / %@",  [MyClass returndateformatwithdate:lastrecord.paiddate dateformat:@"dd-MMM-yyyy"],[MyClass returntitlewithtitle:lastrecord.paidmethod],[formatter2 stringFromNumber:[NSNumber numberWithFloat:[lastrecord.paidamount floatValue]]]];
//            cell.label11.textColor=[UIColor redColor];
            
//            cell.label15.text=[MyClass returndateformatwithdate:salesreceiptrecordobj.paiddate];
//            cell.label17.text=[MyClass returntitlewithtitle:salesreceiptrecordobj.paidmethod];
            
            cell.label13.text=[discountformatter stringFromNumber:[NSNumber numberWithFloat:[self returnSalesDiscountWithSalesReceiptobject:salesreceiptrecordobj]]];
            
            [MyClass downloadImageWithImageview:cell.imageview2 gender:nil type:@"student" typekey:salesreceiptrecordobj.studentkey image:salesreceiptrecordobj.image async:YES];

            cell.textfield2.text=lastrecord.paymentremarks;
            cell.textfield3.text=lastrecord.receiptremarks;
            
            cell.label9.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[salesreceiptrecordobj.quantity floatValue]*[salesreceiptrecordobj.price floatValue]]];
            
            cell.label2.text=[MyClass returnproductnamewithproductcode:salesreceiptrecordobj.productcode centerkey:globalvariables.centerrecord.centerkey];
            
            cell.label3.text=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"Quantity"],salesreceiptrecordobj.quantity];
         
            if ([salesreceiptrecordobj.checkstatus isEqualToString:@""]) {
                cell.imageview1.layer.opacity=0.3;
            }else{
                cell.imageview1.layer.opacity=1;
            }
            
            
            
            
            salesreceiptrecordobj.salesrecord.quantity=salesreceiptrecordobj.quantity;
            salesreceiptrecordobj.salesrecord.price=salesreceiptrecordobj.price;
            NSMutableArray *discountarray=[MyClass returnDiscountArrayWithSalesRecord2:salesreceiptrecordobj.salesrecord];
            if (discountarray.count==0) {
                cell.stackview1.hidden=YES;
            }else{
                cell.stackview1.hidden=NO;
                [[cell.stackview2 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [[cell.stackview3 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i=0; i<discountarray.count; i++) {
                    DiscountRecord *obj=[discountarray objectAtIndex:i];
                    UILabel *discountdesc=[[UILabel alloc]init];
                    [discountdesc setTextColor:[UIColor grayColor]];
                    discountdesc.textAlignment=NSTextAlignmentRight;
                    [discountdesc setFont:[UIFont systemFontOfSize:9]];
                    
                    if ([globalvariables.language isEqualToString:@"English"]) {
                        discountdesc.text=obj.description;
                    }else{
                        discountdesc.text=obj.description_chinese;
                    }
                    [cell.stackview2 addArrangedSubview:discountdesc];
                    
                    UILabel *discountvalue=[[UILabel alloc]init];
                    discountvalue.textAlignment=NSTextAlignmentRight;
                    [discountvalue setTextColor:[UIColor grayColor]];
                    [discountvalue setFont:[UIFont systemFontOfSize:10]];
                    discountvalue.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[obj.discount floatValue]==0?0:[obj.discount floatValue]*-1]];
                    [cell.stackview3 addArrangedSubview:discountvalue];
                }
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        
        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        

    }else if (tableView==paymenttable) {
        UITableViewCell *cell;
        
        if (indexPath.section==0) {
            MyTableViewCell *cell;
            static NSString *CellIdentifier= @"classpaymentcell";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
                singleTap.numberOfTapsRequired = 1;
            [cell.imageview2 addGestureRecognizer:singleTap];
            cell.imageview2.userInteractionEnabled = YES;
            cell.label6.text=[MyClass returntitlewithtitle:@"Total Fee"];
            cell.label7.text=[MyClass returntitlewithtitle:@"invoice_Total"];
            cell.label8.text=[MyClass returntitlewithtitle:@"Outstanding"];
            cell.label12.text=[MyClass returntitlewithtitle:@"Total Discount"];
            [cell.textfield1 addTarget:self action:@selector(updatecppaidamount:)forControlEvents:UIControlEventEditingChanged];
            [cell.textfield1 addTarget:self action:@selector(closedocumentsidewindow) forControlEvents:UIControlEventEditingDidBegin];
            cell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Paid Amount"];
            cell.textfield2.placeholder=[MyClass returntitlewithtitle:@"Internal payment remarks"];
            [cell.textfield2 addTarget:self action:@selector(updatecppaymentremarks:)forControlEvents:UIControlEventEditingChanged];
            [cell.textfield2 addTarget:self action:@selector(closedocumentsidewindow) forControlEvents:UIControlEventEditingDidBegin];
            
            cell.textfield3.placeholder=[MyClass returntitlewithtitle:@"Remarks to be printed on receipt"];
            [cell.textfield3 addTarget:self action:@selector(updatecpreceiptremarks:)forControlEvents:UIControlEventEditingChanged];
            [cell.textfield3 addTarget:self action:@selector(closedocumentsidewindow) forControlEvents:UIControlEventEditingDidBegin];
            [cell.button2 addTarget: self action:@selector(selectpaidmethod:event:) forControlEvents: UIControlEventTouchUpInside];
            [cell.button1 addTarget: self action:@selector(selectpaiddate:event:) forControlEvents: UIControlEventTouchUpInside];
            [cell.button3 addTarget: self action:@selector(selectdiscount:event:) forControlEvents: UIControlEventTouchUpInside];
            
            
            [cell.button3 setTitle:[MyClass returntitlewithtitle:@"Discount"] forState:UIControlStateNormal];
            cell.button3.enabled=TRUE;
            [cell.button3 setTitleColor:cell.button3.isEnabled?[UIColor whiteColor]:[UIColor grayColor] forState:UIControlStateNormal];
            cell.button1.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editpaiddate;

            ClassPaymentRecord * classpaymentrecordobj=[documentfolderclasspaymentarray objectAtIndex:indexPath.row];
            
            cell.label1.text=[MyClass returnStudentnameWithStudentkey:classpaymentrecordobj.studentkey option:@"full"];
                cell.label10.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[classpaymentrecordobj.totalfee floatValue]]];
                
                if ([classpaymentrecordobj.outstandingamount intValue]==0) {
                    cell.label11.text=@"-";
                    cell.label11.textColor=[UIColor darkGrayColor];
                }else{
                    cell.label11.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[classpaymentrecordobj.outstandingamount floatValue]]];
                    cell.label11.textColor=[UIColor redColor];
                }
            
            cell.label13.text=[discountformatter stringFromNumber:[NSNumber numberWithFloat:[self returnEnrollmentDiscountWithClassPaymentobject:classpaymentrecordobj]]];
            
            [MyClass downloadImageWithImageview:cell.imageview2 gender:nil type:@"student" typekey:classpaymentrecordobj.studentkey image:classpaymentrecordobj.image async:YES];
            

            cell.textfield1.text=classpaymentrecordobj.paidamount;
            cell.textfield2.text=classpaymentrecordobj.paymentremarks;
            cell.textfield3.text=classpaymentrecordobj.receiptremarks;
                if ([classpaymentrecordobj.paidmethod isEqualToString:@""]) {
                    [cell.button2 setTitle:[MyClass returntitlewithtitle:@"Paid Method"] forState:UIControlStateNormal];
                }else{
                    [cell.button2 setTitle:[MyClass returntitlewithtitle:classpaymentrecordobj.paidmethod] forState:UIControlStateNormal];
                }
                [cell.button1 setTitle:[MyClass returndateformatwithdate:classpaymentrecordobj.paiddate] forState:UIControlStateNormal];
                
            cell.label9.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[classpaymentrecordobj.tuitionfee floatValue]+[classpaymentrecordobj.enrollmentrecord.enrollmentfee floatValue]+[classpaymentrecordobj.enrollmentrecord.latefee floatValue]]];
                cell.label2.text=[MyClass returnsubjectnamewithsubject_shortname:classpaymentrecordobj.subject_shortname centerkey:globalvariables.centerrecord.centerkey];
                cell.label3.text=[NSString stringWithFormat:@"%@ %@ %@",[MyClass returndateformatwithdate:classpaymentrecordobj.startdate],[MyClass returntitlewithtitle:@"documentfolder_to"],[MyClass returndateformatwithdate:classpaymentrecordobj.enddate]];
                cell.label4.text=[NSString stringWithFormat:@"%@ %@",classpaymentrecordobj.noofclass,[classpaymentrecordobj.noofclass intValue]>1?[MyClass returntitlewithtitle:@"Classes"]:[MyClass returntitlewithtitle:@"documentfolder_Class"]];
                cell.label5.text=classpaymentrecordobj.classtime;
                
                if ([classpaymentrecordobj.checkstatus isEqualToString:@""]) {
                    cell.imageview1.layer.opacity=0.3;
                }else{
                    cell.imageview1.layer.opacity=1;
                }
            
            MultiCoordinate *multiobj=[[MultiCoordinate alloc]initMultiCoordinatewithx:indexPath.section y:indexPath.row z:1];
                
                if ([self isMultiCoordinateSameWithMultiCoordinate1:multiobj MultiCoordinate2:selectedbuttoncoordinate]) {
                    cell.button2.backgroundColor=[UIColor whiteColor];
                    if ([classpaymentrecordobj.paidmethod isEqualToString:@""]) {
                        cell.button2.layer.borderColor=[UIColor redColor].CGColor;
                        [cell.button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    }else{
                        cell.button2.layer.borderColor=[UIColor blueColor].CGColor;
                        [cell.button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    }
                    
                    cell.button2.layer.borderWidth=0.8;
                    
                }else{
                    [cell.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    if ([classpaymentrecordobj.paidmethod isEqualToString:@""]) {
                        cell.button2.backgroundColor=[UIColor redColor];
                    }else{
                        cell.button2.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
                    }
                    
                    cell.button2.layer.borderColor=nil;
                    cell.button2.layer.borderWidth=0;
                }

            multiobj.z=0;
                if ([self isMultiCoordinateSameWithMultiCoordinate1:multiobj MultiCoordinate2:selectedbuttoncoordinate]) {
                    cell.button1.backgroundColor=[UIColor whiteColor];
                    cell.button1.layer.borderColor=[UIColor blueColor].CGColor;
                    cell.button1.layer.borderWidth=0.8;
                    [cell.button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }else{
                    [cell.button1 setTitleColor:cell.button1.enabled?[UIColor whiteColor]:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    cell.button1.backgroundColor=cell.button1.enabled?[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]:[UIColor systemGroupedBackgroundColor];
                    cell.button1.layer.borderColor=nil;
                    cell.button1.layer.borderWidth=0;
                }
            
            multiobj.z=2;
            
            
            NSMutableArray *array=[[NSMutableArray alloc]init];
//            [MyClass retrieveUnusedCouponWithStudentkey:classpaymentrecordobj.studentkey type:@"Class" availableCouponArray:array typekey:classpaymentrecordobj.enrollmentkey];
            
            if(array.count>0){
                if ([self isMultiCoordinateSameWithMultiCoordinate1:multiobj MultiCoordinate2:selectedbuttoncoordinate]) {
                    cell.button3.backgroundColor=[UIColor whiteColor];
                    cell.button3.layer.borderColor=[UIColor orangeColor].CGColor;
                    cell.button3.layer.borderWidth=0.8;
                    [cell.button3 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                }else{
                    [cell.button3 setTitleColor:cell.button3.enabled?[UIColor whiteColor]:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    cell.button3.backgroundColor=cell.button3.enabled?[UIColor orangeColor]:[UIColor systemGroupedBackgroundColor];
                    cell.button3.layer.borderColor=nil;
                    cell.button3.layer.borderWidth=0;
                }
            }else{
                if ([self isMultiCoordinateSameWithMultiCoordinate1:multiobj MultiCoordinate2:selectedbuttoncoordinate]) {
                    cell.button3.backgroundColor=[UIColor whiteColor];
                    cell.button3.layer.borderColor=[UIColor blueColor].CGColor;
                    cell.button3.layer.borderWidth=0.8;
                    [cell.button3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }else{
                    [cell.button3 setTitleColor:cell.button1.enabled?[UIColor whiteColor]:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    cell.button3.backgroundColor=cell.button1.enabled?[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]:[UIColor systemGroupedBackgroundColor];
                    cell.button3.layer.borderColor=nil;
                    cell.button3.layer.borderWidth=0;
                }
            }
            
            
            classpaymentrecordobj.enrollmentrecord.tuitionfee=classpaymentrecordobj.tuitionfee;
            NSMutableArray *discountarray=[MyClass returnDiscountArrayWithEnrollmentRecord2:classpaymentrecordobj.enrollmentrecord];
            if (discountarray.count==0) {
                cell.stackview1.hidden=YES;
            }else{
                cell.stackview1.hidden=NO;
                [[cell.stackview2 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [[cell.stackview3 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i=0; i<discountarray.count; i++) {
                    DiscountRecord *obj=[discountarray objectAtIndex:i];
                    UILabel *discountdesc=[[UILabel alloc]init];
                    [discountdesc setTextColor:[UIColor grayColor]];
                    discountdesc.textAlignment=NSTextAlignmentRight;
                    [discountdesc setFont:[UIFont systemFontOfSize:9]];
                    
                    if ([globalvariables.language isEqualToString:@"English"]) {
                        discountdesc.text=obj.description;
                    }else{
                        discountdesc.text=obj.description_chinese;
                    }
                    [cell.stackview2 addArrangedSubview:discountdesc];
                    
                    UILabel *discountvalue=[[UILabel alloc]init];
                    discountvalue.textAlignment=NSTextAlignmentLeft;
                    [discountvalue setTextColor:[UIColor grayColor]];
                    [discountvalue setFont:[UIFont systemFontOfSize:10]];
                    discountvalue.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[obj.discount floatValue]==0?0:[obj.discount floatValue]*-1]];
                    [cell.stackview3 addArrangedSubview:discountvalue];
                }
            }
            
            
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }else{
            MyTableViewCell *cell;
            static NSString *CellIdentifier= @"salespaymentcell";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
            singleTap.numberOfTapsRequired = 1;
            [cell.imageview2 addGestureRecognizer:singleTap];
            cell.imageview2.userInteractionEnabled = YES;
            cell.label7.text=[MyClass returntitlewithtitle:@"invoice_Total"];
            cell.label8.text=[MyClass returntitlewithtitle:@"Outstanding"];
            cell.label6.text=[MyClass returntitlewithtitle:@"Total Fee"];
            cell.label12.text=[MyClass returntitlewithtitle:@"Total Discount"];
            [cell.textfield1 addTarget:self action:@selector(updatesppaidamount:)forControlEvents:UIControlEventEditingChanged];
            [cell.textfield1 addTarget:self action:@selector(closedocumentsidewindow) forControlEvents:UIControlEventEditingDidBegin];
            cell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Paid Amount"];
            cell.textfield2.placeholder=[MyClass returntitlewithtitle:@"Internal payment remarks"];
            [cell.textfield2 addTarget:self action:@selector(updatesppaymentremarks:)forControlEvents:UIControlEventEditingChanged];
            [cell.textfield2 addTarget:self action:@selector(closedocumentsidewindow) forControlEvents:UIControlEventEditingDidBegin];
            cell.textfield3.placeholder=[MyClass returntitlewithtitle:@"Remarks to be printed on receipt"];
            [cell.textfield3 addTarget:self action:@selector(updatespreceiptremarks:)forControlEvents:UIControlEventEditingChanged];
            [cell.textfield3 addTarget:self action:@selector(closedocumentsidewindow) forControlEvents:UIControlEventEditingDidBegin];
            [cell.button2 addTarget: self action:@selector(selectpaidmethod:event:) forControlEvents: UIControlEventTouchUpInside];
            [cell.button1 addTarget: self action:@selector(selectpaiddate:event:) forControlEvents: UIControlEventTouchUpInside];
            [cell.button3 addTarget: self action:@selector(selectdiscount:event:) forControlEvents: UIControlEventTouchUpInside];
            
            [cell.button3 setTitle:[MyClass returntitlewithtitle:@"Discount"] forState:UIControlStateNormal];
            cell.button3.enabled=TRUE;
            [cell.button3 setTitleColor:cell.button3.isEnabled?[UIColor whiteColor]:[UIColor grayColor] forState:UIControlStateNormal];
            cell.button1.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editpaiddate;

            SalesPaymentRecord *salespaymentrecordobj=[documentfoldersalespaymentarray objectAtIndex:indexPath.row];
            
//            Student *student=[MyClass returnstudentwithstudentkey:salespaymentrecordobj.studentkey];
            
            
//            NSMutableArray *array=[[NSMutableArray alloc]init];
//            [MyClass retrieveUnusedCouponWithStudentkey:salespaymentrecordobj.studentkey type:@"Sales" availableCouponArray:array typekey:salespaymentrecordobj.saleskey];
//            [cell.button3 setBackgroundImage:array.count>0?[UIImage imageNamed:@"orange_background.png"]:nil forState:UIControlStateNormal];
//            cell.button3.backgroundColor=[student.validcouponcount integerValue]>0?[UIColor orangeColor]:[UIColor whiteColor];
            
            
            
            cell.label1.text=[MyClass returnStudentnameWithStudentkey:salespaymentrecordobj.studentkey option:@"full"];
            cell.label10.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[salespaymentrecordobj.totalfee floatValue]]];
            
            if ([salespaymentrecordobj.outstandingamount intValue]==0) {
                cell.label11.text=@"-";
                cell.label11.textColor=[UIColor darkGrayColor];
            }else{
                cell.label11.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[salespaymentrecordobj.outstandingamount floatValue]]];
                cell.label11.textColor=[UIColor redColor];
            }
            
            cell.label13.text=[discountformatter stringFromNumber:[NSNumber numberWithFloat:[self returnSalesDiscountWithSalesPaymentobject:salespaymentrecordobj]]];
            
            [MyClass downloadImageWithImageview:cell.imageview2 gender:nil type:@"student" typekey:salespaymentrecordobj.studentkey image:salespaymentrecordobj.image async:YES];

            cell.textfield1.text=salespaymentrecordobj.paidamount;
            cell.textfield2.text=salespaymentrecordobj.paymentremarks;
            cell.textfield3.text=salespaymentrecordobj.receiptremarks;
            if ([salespaymentrecordobj.paidmethod isEqualToString:@""]) {
                [cell.button2 setTitle:[MyClass returntitlewithtitle:@"Paid Method"] forState:UIControlStateNormal];
            }else{
                [cell.button2 setTitle:[MyClass returntitlewithtitle:salespaymentrecordobj.paidmethod] forState:UIControlStateNormal];
            }
            [cell.button1 setTitle:[MyClass returndateformatwithdate:salespaymentrecordobj.paiddate] forState:UIControlStateNormal];
            cell.label9.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[salespaymentrecordobj.quantity floatValue]*[salespaymentrecordobj.price floatValue]]];
            cell.label2.text=[MyClass returnproductnamewithproductcode:salespaymentrecordobj.productcode centerkey:globalvariables.centerrecord.centerkey];

            cell.label3.text=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"Quantity"],salespaymentrecordobj.quantity];
         
            if ([salespaymentrecordobj.checkstatus isEqualToString:@""]) {
                cell.imageview1.layer.opacity=0.3;
            }else{
                cell.imageview1.layer.opacity=1;
            }
            
            
            MultiCoordinate *multiobj=[[MultiCoordinate alloc]initMultiCoordinatewithx:indexPath.section y:indexPath.row z:1];
            
            if ([self isMultiCoordinateSameWithMultiCoordinate1:multiobj MultiCoordinate2:selectedbuttoncoordinate]) {
                cell.button2.backgroundColor=[UIColor whiteColor];
                if ([salespaymentrecordobj.paidmethod isEqualToString:@""]) {
                    cell.button2.layer.borderColor=[UIColor redColor].CGColor;
                    [cell.button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                }else{
                    cell.button2.layer.borderColor=[UIColor blueColor].CGColor;
                    [cell.button2 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }
                
                cell.button2.layer.borderWidth=0.8;
                
            }else{
                [cell.button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                if ([salespaymentrecordobj.paidmethod isEqualToString:@""]) {
                    cell.button2.backgroundColor=[UIColor redColor];
                }else{
                    cell.button2.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
                }
                
                cell.button2.layer.borderColor=nil;
                cell.button2.layer.borderWidth=0;
            }
            
            multiobj.z=0;
            if ([self isMultiCoordinateSameWithMultiCoordinate1:multiobj MultiCoordinate2:selectedbuttoncoordinate]) {
                cell.button1.backgroundColor=[UIColor whiteColor];
                cell.button1.layer.borderColor=[UIColor blueColor].CGColor;
                cell.button1.layer.borderWidth=0.8;
                [cell.button1 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            }else{
                [cell.button1 setTitleColor:cell.button1.enabled?[UIColor whiteColor]:[UIColor lightGrayColor] forState:UIControlStateNormal];
                cell.button1.backgroundColor=cell.button1.enabled?[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]:[UIColor systemGroupedBackgroundColor];
                cell.button1.layer.borderColor=nil;
                cell.button1.layer.borderWidth=0;
            }
            
            
            multiobj.z=2;
            
            NSMutableArray *array=[[NSMutableArray alloc]init];
//            [MyClass retrieveUnusedCouponWithStudentkey:salespaymentrecordobj.studentkey type:@"Sales" availableCouponArray:array typekey:salespaymentrecordobj.saleskey];
            
            if(array.count>0){
                if ([self isMultiCoordinateSameWithMultiCoordinate1:multiobj MultiCoordinate2:selectedbuttoncoordinate]) {
                    cell.button3.backgroundColor=[UIColor whiteColor];
                    cell.button3.layer.borderColor=[UIColor orangeColor].CGColor;
                    cell.button3.layer.borderWidth=0.8;
                    [cell.button3 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                }else{
                    [cell.button3 setTitleColor:cell.button3.enabled?[UIColor whiteColor]:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    cell.button3.backgroundColor=cell.button3.enabled?[UIColor orangeColor]:[UIColor systemGroupedBackgroundColor];
                    cell.button3.layer.borderColor=nil;
                    cell.button3.layer.borderWidth=0;
                }
            }else{
                if ([self isMultiCoordinateSameWithMultiCoordinate1:multiobj MultiCoordinate2:selectedbuttoncoordinate]) {
                    cell.button3.backgroundColor=[UIColor whiteColor];
                    cell.button3.layer.borderColor=[UIColor blueColor].CGColor;
                    cell.button3.layer.borderWidth=0.8;
                    [cell.button3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                }else{
                    [cell.button3 setTitleColor:cell.button1.enabled?[UIColor whiteColor]:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    cell.button3.backgroundColor=cell.button1.enabled?[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0]:[UIColor systemGroupedBackgroundColor];
                    cell.button3.layer.borderColor=nil;
                    cell.button3.layer.borderWidth=0;
                }
            }
            
            
            salespaymentrecordobj.salesrecord.quantity=salespaymentrecordobj.quantity;
            salespaymentrecordobj.salesrecord.price=salespaymentrecordobj.price;
            NSMutableArray *discountarray=[MyClass returnDiscountArrayWithSalesRecord2:salespaymentrecordobj.salesrecord];
            if (discountarray.count==0) {
                cell.stackview1.hidden=YES;
            }else{
                cell.stackview1.hidden=NO;
                [[cell.stackview2 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                [[cell.stackview3 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i=0; i<discountarray.count; i++) {
                    DiscountRecord *obj=[discountarray objectAtIndex:i];
                    UILabel *discountdesc=[[UILabel alloc]init];
                    [discountdesc setTextColor:[UIColor grayColor]];
                    discountdesc.textAlignment=NSTextAlignmentRight;
                    [discountdesc setFont:[UIFont systemFontOfSize:9]];
                    
                    if ([globalvariables.language isEqualToString:@"English"]) {
                        discountdesc.text=obj.description;
                    }else{
                        discountdesc.text=obj.description_chinese;
                    }
                    [cell.stackview2 addArrangedSubview:discountdesc];
                    
                    UILabel *discountvalue=[[UILabel alloc]init];
                    discountvalue.textAlignment=NSTextAlignmentLeft;
                    [discountvalue setTextColor:[UIColor grayColor]];
                    [discountvalue setFont:[UIFont systemFontOfSize:10]];
                    discountvalue.text=[formatter2 stringFromNumber:[NSNumber numberWithFloat:[obj.discount floatValue]==0?0:[obj.discount floatValue]*-1]];
                    [cell.stackview3 addArrangedSubview:discountvalue];
                }
            }
            
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        
        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView==paidmethodtable){
        
        UITableViewCell *cell;

            cell = [tableView dequeueReusableCellWithIdentifier:@"paidmethodcell"];
            UILabel *paymentmethodlabel;
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paidmethodcell"];
                
                paymentmethodlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, paidmethodtablewidth-30, 38)];
                paymentmethodlabel.font=[UIFont systemFontOfSize:14];
                paymentmethodlabel.textColor=[UIColor darkGrayColor];
                paymentmethodlabel.tag=701;
                [cell.contentView addSubview:paymentmethodlabel];
                
            }else{
                paymentmethodlabel=(UILabel *)[cell.contentView viewWithTag:701];
            }
            
            paymentmethodlabel.text=[MyClass returntitlewithtitle:[paidmethodarray objectAtIndex:indexPath.row]];

        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        return cell;
    }else if (tableView==PromotionCodeTable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"promotioncodecell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        MarketingRecord *marketingobject = [filteredavailablepromotionarray objectAtIndex:indexPath.row];
        cell.label1.text=[globalvariables.language isEqualToString:@"English"]?marketingobject.description:marketingobject.description_chinese;
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            cell.label3.text=[NSString stringWithFormat:@"$%@",marketingobject.promotionfixeddiscount];
        }else{
            cell.label3.text=[NSString stringWithFormat:@"%@%@",marketingobject.promotionpercentagediscount,@"%"];
        }
        cell.label2.text=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"To be expired on"],[MyClass returndateformatwithdate:marketingobject.enddate]];
        
        cell.label4.text=[NSString stringWithFormat:@"%@/%@",marketingobject.usedcount,[marketingobject.promotionquota isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:marketingobject.promotionquota];
        if (![marketingobject.code isEqualToString:@""]) {
            cell.label4.text=[NSString stringWithFormat:@"%@ (%@)",cell.label4.text,marketingobject.code];
        }
        
        cell.label5.text=[MyClass returnMarketingApplicationDescription:marketingobject];
//        cell.label5.hidden=YES;
        
        cell.view1.backgroundColor=[UIColor whiteColor];
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        return cell;
    
    }else if (tableView==CouponTable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"couponcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CouponRecord *coupon=[filteredavailablecouponarray objectAtIndex:indexPath.row];
        MarketingRecord *marketingobject = [MyClass returnMarketingRecordWithMarketingKey:coupon.marketingkey index:3];
        cell.label1.text=[globalvariables.language isEqualToString:@"English"]?marketingobject.description:marketingobject.description_chinese;
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            cell.label4.text=[NSString stringWithFormat:@"$%@",marketingobject.promotionfixeddiscount];
        }else{
            cell.label4.text=[NSString stringWithFormat:@"%@%@",marketingobject.promotionpercentagediscount,@"%"];
        }
        
        cell.label3.text=[marketingobject.effectiveto isEqualToString:@""]?[MyClass returntitlewithtitle:@"Never expire"]:[MyClass returnreplacedtitlewithtitle:@"Expires on %@1" replacementarray:@[[MyClass returndateformatwithdate:coupon.effectiveto]]];
        
        cell.label2.text=[MyClass returnreplacedtitlewithtitle:@"Valid from %@1" replacementarray:@[[MyClass returndateformatwithdate:coupon.effectivefrom]]];

        cell.label5.text=[NSString stringWithFormat:@"ID%@",coupon.couponkey];
        
        cell.label6.text=marketingobject.code;
        cell.label6.hidden=[marketingobject.code isEqualToString:@""];
        
        if(coupon.cannotuseconjunctionwithothercoupons){
            cell.label7.hidden=NO;
            cell.label7.text=[MyClass returntitlewithtitle:@"Cannot be used conjunction with other coupons"];
        }else{
            cell.label7.hidden=YES;
        }
        
        if(coupon.cannotuseconjunctionwithothercoupons){
            cell.label7.hidden=NO;
            cell.label7.text=[MyClass returntitlewithtitle:@"Cannot be used conjunction with other coupons"];
        }else{
            cell.label7.hidden=YES;
        }
        
        cell.label8.text=[MyClass returnMarketingApplicationDescription:marketingobject];
        
        cell.view1.hidden=[self couponcanbeselected:coupon];
        
//        cell.view1.backgroundColor=[UIColor whiteColor];
//        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        return cell;
    
    }else if (tableView==DiscountTable){
        MyTableViewCell *cell;
        
        if (indexPath.section==0) {
            NSMutableArray *promotionarray=[self returnPromotionArray];
            if (promotionarray.count==0) {
                static NSString *CellIdentifier= @"discountnonecell";
                cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                cell.label1.text=[MyClass returntitlewithtitle:@"None"];
            }else{
                static NSString *CellIdentifier= @"discountcell";
                cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }

                MarketingRecord *marketingobject=[promotionarray objectAtIndex:indexPath.row];
                
                cell.label1.text=[globalvariables.language isEqualToString:@"English"]?marketingobject.description:marketingobject.description_chinese;
                if ([marketingobject.recursive isEqualToString:@"Yes"]) {
                    cell.imageview1.layer.opacity=1;
                }else{
                    cell.imageview1.layer.opacity=0.3;
                }
                cell.button1.tag=indexPath.row;
                [cell.button1 setTitle:[MyClass returntitlewithtitle:@"Recursive"] forState:UIControlStateNormal];
                [cell.button1 addTarget:self action:@selector(recursivebuttonpressed:)forControlEvents:UIControlEventTouchUpInside];
                
                if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
                    cell.label3.text=[NSString stringWithFormat:@"$%@",marketingobject.promotionfixeddiscount];
                }else{
                    cell.label3.text=[NSString stringWithFormat:@"%@%@",marketingobject.promotionpercentagediscount,@"%"];
                }
            }
        }else if (indexPath.section==1){
            static NSString *CellIdentifier= @"oneoffdiscountcell";
            cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.textfield1.tag=indexPath.row;
            [cell.textfield1 addTarget:self action:@selector(updatetuitionfee:)forControlEvents:UIControlEventEditingChanged];
            [cell.textfield1 addTarget:self action:@selector(offsettextfield:)forControlEvents:UIControlEventEditingDidBegin];
            
            if (indexPath.row==0) {
                cell.label1.text=[MyClass returntitlewithtitle:@"One off Percentage"];
                cell.textfield1.placeholder=[MyClass returntitlewithtitle:@"%"];
                if (selectedbuttoncoordinate.x==0) {
                    ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y];
                    cell.textfield1.text=obj.enrollmentrecord.oneoffpercentagediscount;
                }else{
                    SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y];
                    cell.textfield1.text=obj.salesrecord.oneoffpercentagediscount;
                }
                
                cell.textfield1.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editonetimediscount;
            }else{
                cell.label1.text=[MyClass returntitlewithtitle:@"One off Fixed"];
                cell.textfield1.placeholder=[MyClass returntitlewithtitle:@"Fixed"];
                if (selectedbuttoncoordinate.x==0) {
                    ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y];
                    cell.textfield1.text=obj.enrollmentrecord.oneoffdiscount;
                }else{
                    SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y];
                    cell.textfield1.text=obj.salesrecord.oneoffdiscount;
                }
                cell.textfield1.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editonetimediscount;
            }
            
        }else if (indexPath.section==2) {
            NSMutableArray *couponarray=[self returnCouponArray];
            if (couponarray.count==0) {
                static NSString *CellIdentifier= @"discountnonecell";
                cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }
                cell.label1.text=[MyClass returntitlewithtitle:@"None"];
            }else{
                static NSString *CellIdentifier= @"couponcell";
                cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                
                if (cell == nil) {
                    cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                }

                CouponRecord *coupon=[couponarray objectAtIndex:indexPath.row];
                MarketingRecord *marketingobject=[MyClass returnMarketingRecordWithMarketingKey:coupon.marketingkey index:3];
                
                cell.label1.text=[globalvariables.language isEqualToString:@"English"]?marketingobject.description:marketingobject.description_chinese;
                
                if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
                    cell.label3.text=[NSString stringWithFormat:@"$%@",marketingobject.promotionfixeddiscount];
                }else{
                    cell.label3.text=[NSString stringWithFormat:@"%@%@",marketingobject.promotionpercentagediscount,@"%"];
                }
            }
        }

        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.view1.backgroundColor=[UIColor whiteColor];
        return cell;
    
    }else{// if (tableView==paiddatetable){
        
        UITableViewCell *cell= [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"paiddatecell"];
        
        CalendarView *calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, paiddatetablewidth, paiddatetable.frame.size.height) Theme:0 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"paiddate" disablecalendar:FALSE];
        calendarview.delegate=self;

        
        if (selectedbuttoncoordinate.x==0){
            
            if (selectedbuttoncoordinate && ![((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paiddate isEqualToString:@""]) {
                [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paiddate,nil] ScrollToDate:nil instructorselected:nil];
            }else{
                //calendarviewcontroller.scrolltodate=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"];
                [calendarview scrollToSelectedDateWithSelectedDateArray:nil ScrollToDate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] instructorselected:nil];
            }
        }else{
            if (selectedbuttoncoordinate && ![((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paiddate isEqualToString:@""]) {
                //calendarviewcontroller.selecteddatearray=[[NSMutableArray alloc]initWithObjects:((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedPaidDateButtonIndexPath.row]).paiddate,nil];
                [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paiddate,nil] ScrollToDate:nil instructorselected:nil];
            }else{
                //calendarviewcontroller.scrolltodate=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"];
                [calendarview scrollToSelectedDateWithSelectedDateArray:nil ScrollToDate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] instructorselected:nil];
            }
        }
        
        [cell.contentView addSubview:calendarview];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        
        cell.selectionStyle=UITableViewCellSelectionStyleDefault;
        return cell;
    }

    
}

-(NSString *) returnStatusWithStatus:(NSString *)status Update:(NSString *)update
{
    if (!status || [status isEqualToString:@""]) {
        return update;
    }else{
        if ([status isEqualToString:update]) {
            return status;
        }else{
            NSMutableArray *statusarray=[[NSMutableArray alloc]initWithArray:[status componentsSeparatedByString:@","]];
            if(![statusarray containsObject:update]){
                [statusarray addObject:update];
            }
            return [statusarray componentsJoinedByString:@","];
        }
    }
}

-(BOOL) checkStatusExistsWithStatus:(NSString *)status value:(NSString *)value
{
    if(!status || [status isEqualToString:@""]){
        return NO;
    }else{
        NSArray *statusarray=[status componentsSeparatedByString:@","];
        return [statusarray containsObject:value];
    }
}


- (void)updatetuitionfee:(UITextField *)sender {
    if (sender.tag==0) {
        if (![self checkvalidpercentagediscountinput:sender.text]) {
            sender.text=@"";
        }
        
        if (selectedbuttoncoordinate.x==0) {
            ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y];
            obj.enrollmentrecord.oneoffpercentagediscount=sender.text;
            obj.enrollmentrecord.status=[self returnStatusWithStatus:obj.enrollmentrecord.status Update:@"discount"];
        }else{
            SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y];
            obj.salesrecord.oneoffpercentagediscount=sender.text;
            obj.salesrecord.status=[self returnStatusWithStatus:obj.salesrecord.status Update:@"discount"];
        }
        
    }else{
        if (![self checkvalidfeeinput:sender.text]) {
            sender.text=@"";
        }
        if (selectedbuttoncoordinate.x==0) {
            ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y];
            obj.enrollmentrecord.oneoffdiscount=sender.text;
            obj.enrollmentrecord.status=[self returnStatusWithStatus:obj.enrollmentrecord.status Update:@"discount"];
        }else{
            SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y];
            obj.salesrecord.oneoffdiscount=sender.text;
            obj.salesrecord.status=[self returnStatusWithStatus:obj.salesrecord.status Update:@"discount"];
        }
        
    }
    [self updatePaymentRecordTotalFeeAndDiscountWithReloadDiscountTable:NO  Update:@"discount"];
}

-(BOOL) couponcanbeselected:(CouponRecord *)coupon
{
    BOOL alreadyhascannotbeusedconjunctionwithothers=FALSE;
    NSMutableArray *couponRecords=[self returnCouponArray];
    for(int i=0;i<couponRecords.count;i++){
        CouponRecord *obj=[couponRecords objectAtIndex:i];
        if(obj.cannotuseconjunctionwithothercoupons){
            alreadyhascannotbeusedconjunctionwithothers=TRUE;
            break;
        }
    }
    
    if(couponRecords.count>0){
        if(!coupon.cannotuseconjunctionwithothercoupons && !alreadyhascannotbeusedconjunctionwithothers){
            return YES;
        }
    }else{
        return YES;
    }
    
    return NO;
}

-(void)offsettextfield:(UITextField *)sender
{

    if (sender.tag==0) {
        if ([sender.text hasSuffix:@"%"]) {
            sender.text=[sender.text isEqualToString:@""]?@"":[sender.text substringToIndex:[sender.text length]-1];
        }
    }
    
    if (keyboardheight>0) {
        float y=DiscountTable.contentSize.height-DiscountTable.frame.size.height;
        if(y>0){
            [DiscountTable setContentOffset:CGPointMake(0, y) animated:YES];
        }
        
    }
    
}

-(BOOL) checkvalidpercentagediscountinput:(NSString *)input
{
    NSString *decimalRegex = @"^(?:|-)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", decimalRegex];
    
    if ([input isEqualToString:@""]) {
        return TRUE;
    }else{
        if ([input hasSuffix:@"%"]) {
            if ([regexPredicate evaluateWithObject: [input substringToIndex:[input length]-1]]){
                //Matches
                return TRUE;
            }else{
                return FALSE;
            }
        }else{
            if ([regexPredicate evaluateWithObject: input]){
                //Matches
                return TRUE;
            }else{
                return FALSE;
            }
        }
    }
}

-(void) recursivebuttonpressed:(UIButton *)sender
{
    NSMutableArray *promotionarray=[self returnPromotionArray];
    MarketingRecord *obj=[promotionarray objectAtIndex:sender.tag];
    if ([obj.recursive isEqualToString:@"Yes"]) {
        obj.recursive=@"No";
    }else{
        obj.recursive=@"Yes";
    }
    
    if (selectedbuttoncoordinate.x==0) {
        ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y];
        obj.enrollmentrecord.status=[self returnStatusWithStatus:obj.enrollmentrecord.status Update:@"promotion"];
    }else{
        SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y];
        obj.salesrecord.status=[self returnStatusWithStatus:obj.salesrecord.status Update:@"promotion"];
    }
    
    [DiscountTable reloadData];
    [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
}



-(void)tapImageDetected:(UITapGestureRecognizer *)gr{
    
    if(![MyClass showMenuItemwithObject:@"Student Profile"]){
        return;
    }
    
    UIImageView *theTappedImageView=(UIImageView *)gr.view;
    if (!invoiceview.hidden) {
        CGPoint point = [theTappedImageView.superview convertPoint:CGPointZero toView:invoicetable];
        NSIndexPath *indexPath =[invoicetable indexPathForRowAtPoint:point];
        
        //dirty fix for first row cannot obtain indexpath
        if (!indexPath) {
            if (documentfolderclassinvoicearray.count==0) {
                indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
            }else{
                indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            }
        }
        
        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
            
            NSString *studentkey;
            
            
            if (indexPath.section==0) {
                studentkey=((ClassInvoiceRecord *)[documentfolderclassinvoicearray objectAtIndex:indexPath.row]).studentkey;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=((ClassInvoiceRecord *)[documentfolderclassinvoicearray objectAtIndex:indexPath.row]).enrollmentkey;
            }else if (indexPath.section==1) {
                studentkey=((SalesInvoiceRecord *)[documentfoldersalesinvoicearray objectAtIndex:indexPath.row]).studentkey;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedSaleskey=((SalesInvoiceRecord *)[documentfoldersalesinvoicearray objectAtIndex:indexPath.row]).saleskey;
            }
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];
            
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(self.view.frame.size.width-240, self.view.frame.size.height);
            
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).TypeSelectionButton.hidden=NO;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).typeselectionarrow.hidden=NO;
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501, 2, 129, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
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
        
    }else if (!receiptview.hidden){
        CGPoint point = [theTappedImageView.superview convertPoint:CGPointZero toView:receipttable];
        NSIndexPath *indexPath =[receipttable indexPathForRowAtPoint:point];
        
        //dirty fix for first row cannot obtain indexpath
        if (!indexPath) {
            indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
            
            NSString *studentkey;
            
            
            if (indexPath.section==0) {
                studentkey=((ClassReceiptRecord *)[documentfolderclassreceiptarray objectAtIndex:indexPath.row]).studentkey;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=((ClassReceiptRecord *)[documentfolderclassreceiptarray objectAtIndex:indexPath.row]).enrollmentkey;
            }else if (indexPath.section==1) {
                studentkey=((SalesReceiptRecord *)[documentfoldersalesreceiptarray objectAtIndex:indexPath.row]).studentkey;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedSaleskey=((SalesReceiptRecord *)[documentfoldersalesreceiptarray objectAtIndex:indexPath.row]).saleskey;
            }
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(self.view.frame.size.width-240, self.view.frame.size.height);
            
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).TypeSelectionButton.hidden=NO;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).typeselectionarrow.hidden=NO;
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501, 2, 129, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
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
        
    }else{
        CGPoint point = [theTappedImageView.superview convertPoint:CGPointZero toView:paymenttable];
        NSIndexPath *indexPath =[paymenttable indexPathForRowAtPoint:point];
        
        //dirty fix for first row cannot obtain indexpath
        if (!indexPath) {
            indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
            
            NSString *studentkey;
            
            
            if (indexPath.section==0) {
                studentkey=((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexPath.row]).studentkey;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexPath.row]).enrollmentkey;
            }else if (indexPath.section==1) {
                studentkey=((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexPath.row]).studentkey;
                ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedSaleskey=((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexPath.row]).saleskey;
            }
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];
            
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(self.view.frame.size.width-240, self.view.frame.size.height);
            
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).TypeSelectionButton.hidden=NO;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).typeselectionarrow.hidden=NO;
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501, 2, 129, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
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
        
    }
    

}

-(BOOL) isIndexPathSameWithIndexPath1:(NSIndexPath *)indexpath1 IndexPath2:(NSIndexPath *)indexpath2
{
    if (indexpath1 && indexpath2 && indexpath1.section==indexpath2.section && indexpath1.row==indexpath2.row) {
        return TRUE;
    }else{
        return FALSE;
    }
}

-(BOOL) isMultiCoordinateSameWithMultiCoordinate1:(MultiCoordinate *)multicoordinate1 MultiCoordinate2:(MultiCoordinate *)multicoordinate2
{
    if (multicoordinate1 && multicoordinate2 && multicoordinate1.x==multicoordinate2.x && multicoordinate1.y==multicoordinate2.y && multicoordinate1.z==multicoordinate2.z) {
        return TRUE;
    }else{
        return FALSE;
    }
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView==DiscountTable) {
        if (indexPath.section==0) {
            if (selectedbuttoncoordinate.x==0) {
                ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y];
                
                BOOL isPaid=[obj.outstandingamount floatValue]!=[obj.totalfee floatValue];
                BOOL isLocked=obj.enrollmentrecord.locked;
                
                return obj.enrollmentrecord.promotiondiscountrecords.count>0 && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscount && !(!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscountifpaid && isPaid) && !isLocked;
            }else{
                SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y];
                BOOL isPaid=[obj.outstandingamount floatValue]!=[obj.totalfee floatValue];
                
                return obj.salesrecord.promotiondiscountrecords.count>0 && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscount && !(!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscountifpaid && isPaid);
            }
        }else if (indexPath.section==2) {
            if (selectedbuttoncoordinate.x==0) {
                ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y];
                return obj.enrollmentrecord.couponrecords.count>0;
            }else{
                SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y];
                return obj.salesrecord.couponrecords.count>0;
            }
        }else{
            return NO;
        }
    }/*else if (tableView==CouponTable){
        return NO;
    }else if (tableView==PromotionCodeTable){
        return NO;
    }*/
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==DiscountTable) {
        if (indexPath.section==0) {
            if (selectedbuttoncoordinate.x==0) {
                ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y];
                return obj.enrollmentrecord.promotiondiscountrecords.count>0;
            }else{
                SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y];
                return obj.salesrecord.promotiondiscountrecords.count>0;
            }
        }else if (indexPath.section==2) {
            if (selectedbuttoncoordinate.x==0) {
                ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y];
                return obj.enrollmentrecord.couponrecords.count>0;
            }else{
                SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y];
                return obj.salesrecord.couponrecords.count>0;
            }
        }
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        
        if (tableView==invoicetable) {
            if (indexPath.section==0) {
                classinvoicerecordobject=[documentfolderclassinvoicearray objectAtIndex:indexPath.row];
                [globalvariables.documentfolder.classinvoicearray removeObject:classinvoicerecordobject.enrollmentkey];
                [documentfolderclassinvoicearray removeObjectAtIndex:indexPath.row];
            }else if (indexPath.section==1) {
                salesinvoicerecordobject=[documentfoldersalesinvoicearray objectAtIndex:indexPath.row];
                [globalvariables.documentfolder.salesinvoicearray removeObject:salesinvoicerecordobject.saleskey];
                [documentfoldersalesinvoicearray removeObjectAtIndex:indexPath.row];
            }
            [invoicebutton setTitle:[NSString stringWithFormat:@"%@(%d)",[MyClass returntitlewithtitle:@"Invoice"],(int)documentfolderclassinvoicearray.count+(int)documentfoldersalesinvoicearray.count] forState:UIControlStateNormal];
            [invoicetable reloadData];
            [self refreshInvoiceSelectedPaymentCount];
        }else if (tableView==receipttable){
            if (indexPath.section==0){
                ClassReceiptRecord *classreceiptrecordobject=[documentfolderclassreceiptarray objectAtIndex:indexPath.row];
                [globalvariables.documentfolder.classreceiptarray removeObject:classreceiptrecordobject.paymentkey];
                [documentfolderclassreceiptarray removeObjectAtIndex:indexPath.row];
            }else{
                SalesReceiptRecord *salesreceiptrecordobject=[documentfoldersalesreceiptarray objectAtIndex:indexPath.row];
                [globalvariables.documentfolder.salesreceiptarray removeObject:salesreceiptrecordobject.paymentkey];
                [documentfoldersalesreceiptarray removeObjectAtIndex:indexPath.row];
            }
            [receiptbutton setTitle:[NSString stringWithFormat:@"%@(%d)",[MyClass returntitlewithtitle:@"Receipt"],(int)documentfolderclassreceiptarray.count+(int)documentfoldersalesreceiptarray.count] forState:UIControlStateNormal];
            [receipttable reloadData];
            [self refreshReceiptSelectedPaymentCount];
        }else if (tableView==paymenttable){
            if (indexPath.section==0){
                classpaymentrecordobject=[documentfolderclasspaymentarray objectAtIndex:indexPath.row];
                [globalvariables.documentfolder.classpaymentarray removeObject:classpaymentrecordobject.enrollmentkey];
                [documentfolderclasspaymentarray removeObjectAtIndex:indexPath.row];
            }else{
                salespaymentrecordobject=[documentfoldersalespaymentarray objectAtIndex:indexPath.row];
                [globalvariables.documentfolder.salespaymentarray removeObject:salespaymentrecordobject.saleskey];
                [documentfoldersalespaymentarray removeObjectAtIndex:indexPath.row];
            }
            [paymentbutton setTitle:[NSString stringWithFormat:@"%@(%d)",[MyClass returntitlewithtitle:@"Payment"],(int)documentfolderclasspaymentarray.count+(int)documentfoldersalespaymentarray.count] forState:UIControlStateNormal];
            [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
            [paymenttable reloadData];
            [self refreshPaymentSelectedPaymentCount];
        }else if (tableView==DiscountTable){
            if(indexPath.section==0){
                NSMutableArray *promotionarray=[self returnPromotionArray];
                [promotionarray removeObjectAtIndex:indexPath.row];
                [self updatePaymentRecordTotalFeeAndDiscountWithReloadDiscountTable:YES Update:@"promotion"];
                return;
            }else if(indexPath.section==2){
                NSMutableArray *couponarray=[self returnCouponArray];
                CouponRecord *coupon=[couponarray objectAtIndex:indexPath.row];
                
                BOOL foundInNewlyUsedCouponArray=FALSE;
                for(int i=0;i<newlyusedcouponarray.count;i++){
                    CouponRecord *object=[newlyusedcouponarray objectAtIndex:i];
                    if([object.couponkey isEqualToString:coupon.couponkey]){
                        [newlyusedcouponarray removeObjectAtIndex:i];
                        foundInNewlyUsedCouponArray=TRUE;
                        break;
                    }
                }
                
                if(!foundInNewlyUsedCouponArray){
                    if(![coupon.dateused isEqualToString:@""]){
                        [releasedcouponarray addObject:coupon];
                    }
                }
                
                [couponarray removeObjectAtIndex:indexPath.row];
                [self updatePaymentRecordTotalFeeAndDiscountWithReloadDiscountTable:YES Update:@"coupon"];
                
                if(!couponView.hidden){
                    [self showavailablecoupon];
                }
                return;
            }
            
        }
        [self.delegate refreshdocumentfoldercountnumber];
        
        [self adjusttablesize];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==paidmethodtable){
        return [MyClass returntitlewithtitle:@"Paid Method"];
    }else if (tableView==paiddatetable){
        return [MyClass returntitlewithtitle:@"Paid Date"];
    }else if (tableView==DiscountTable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Promotional Discount"];
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"Regular Discount"];
        }else if (section==2) {
            return [MyClass returntitlewithtitle:@"Coupon"];
        }
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==paidmethodtable){
        return 40;
    }else if (tableView==paiddatetable){
        return 40;
    }else if (tableView==DiscountTable){
        return 44;
    }else{
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    /*
    if (tableView==paidmethodtable || tableView==paiddatetable) {
        if ([tableView numberOfSections]-1==section) {
            return 30;
        }
    }*/
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==invoicetable) {
        return UITableViewAutomaticDimension;
    }else if (tableView==receipttable){
        return UITableViewAutomaticDimension;
    }else if (tableView==paymenttable){
        return UITableViewAutomaticDimension;
    }else if (tableView==paidmethodtable){
        return 38;
    }else if(tableView==paiddatetable){
        return paiddatetable.frame.size.height;
    }else if (tableView==PromotionCodeTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==CouponTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==DiscountTable){
        return UITableViewAutomaticDimension;
    }
    return CGFLOAT_MIN;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableview shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    //do whatever u want after row has been moved
    if (tableView==DiscountTable) {
        if (toIndexPath.section==0 && (fromIndexPath.row !=toIndexPath.row)) {
            NSMutableArray *promotionarray=[self returnPromotionArray];
            MarketingRecord *marketingobject=[promotionarray objectAtIndex:fromIndexPath.row];
            [promotionarray removeObjectAtIndex:fromIndexPath.row];
            [promotionarray insertObject:marketingobject atIndex:toIndexPath.row];
            
            [self updatePaymentRecordTotalFeeAndDiscountWithReloadDiscountTable:YES Update:@"promotion"];
        }else if (toIndexPath.section==2 && (fromIndexPath.row !=toIndexPath.row)) {
            NSMutableArray *couponarray=[self returnCouponArray];
            CouponRecord *coupon=[couponarray objectAtIndex:fromIndexPath.row];
            [couponarray removeObjectAtIndex:fromIndexPath.row];
            [couponarray insertObject:coupon atIndex:toIndexPath.row];
            
            [self updatePaymentRecordTotalFeeAndDiscountWithReloadDiscountTable:YES Update:@"coupon"];
        }
    }
}

-(void) updatePaymentRecordTotalFeeAndDiscountWithReloadDiscountTable:(BOOL)reload Update:(NSString *)update
{
    if (selectedbuttoncoordinate.x==0) {
        ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y];
        obj.enrollmentrecord.status=[self returnStatusWithStatus:obj.enrollmentrecord.status Update:update];
        [self updateEnrollmentTotalFeeWithClassPaymentobject:obj];
    }else{
        SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y];
        obj.salesrecord.status=[self returnStatusWithStatus:obj.salesrecord.status Update:update];
        [self updateSalesTotalFeeWithSalesPaymentobject:obj];
    }
    if (reload) {
        [DiscountTable reloadData];
    }
    
    [paymenttable reloadData];
    [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
}
                                
                            
-(NSMutableArray *) returnPromotionArray
{
    if (selectedbuttoncoordinate.x==0) {
        ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y];
        return obj.enrollmentrecord.promotiondiscountrecords;
    }else{
        SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y];
        return obj.salesrecord.promotiondiscountrecords;
    }
}

-(NSMutableArray *) returnCouponArray
{
    if (selectedbuttoncoordinate.x==0) {
        ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y];
        return obj.enrollmentrecord.couponrecords;
    }else{
        SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y];
        return obj.salesrecord.couponrecords;
    }
}

-(void) updateallitems:(UIButton *)sender
{
    if (!paidmethodtable.hidden) {
        
        NSString *paidmethod;
        if (selectedbuttoncoordinate.x==0) {
            paidmethod=((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paidmethod;
        }else{
            paidmethod=((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paidmethod;
        }
        
        for (int i=0; i<documentfolderclasspaymentarray.count; i++) {
            ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:i]).paidmethod=paidmethod;
            /*if([((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:i]).paidamount floatValue]!=0){
                ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:i]).checkstatus=@"checked";
            }*/
        }
        
        for (int i=0; i<documentfoldersalespaymentarray.count; i++) {
            ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:i]).paidmethod=paidmethod;
            /*if([((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:i]).paidamount floatValue]!=0){
                ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:i]).checkstatus=@"checked";
            }*/
        }
    }else{
        
        NSString *paiddate;
        if (selectedbuttoncoordinate.x==0) {
            paiddate=((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paiddate;
        }else{
            paiddate=((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paiddate;
        }
        
        for (int i=0; i<documentfolderclasspaymentarray.count; i++) {
            ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:i]).paiddate=paiddate;
            /*if([((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:i]).paidamount floatValue]!=0){
                ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:i]).checkstatus=@"checked";
            }*/
        }
        
        for (int i=0; i<documentfoldersalespaymentarray.count; i++) {
            ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:i]).paiddate=paiddate;
            /*if([((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:i]).paidamount floatValue]!=0){
                ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:i]).checkstatus=@"checked";
            }*/
        }
    }
    
    [self openSideWindowWithTable:@"none"];
}

/*
-(void) updateallpaidmethod:(UIButton *)sender
{
    if (updateallpaidmethod) {
        updateallpaidmethod=FALSE;
        sender.layer.opacity=0.3;
    }else{
        updateallpaidmethod=TRUE;
        sender.layer.opacity=1;
    }
}

-(void) updateallpaiddate:(UIButton *)sender
{
    if (updateallpaiddate) {
        updateallpaiddate=FALSE;
        sender.layer.opacity=0.3;
    }else{
        updateallpaiddate=TRUE;
        sender.layer.opacity=1;
    }
}*/


-(void) selectalldocumentfolderrecords
{
    if (!receiptview.hidden) {
        for (int i=0; i<documentfolderclassreceiptarray.count; i++) {
            ((ClassReceiptRecord *)[documentfolderclassreceiptarray objectAtIndex:i]).checkstatus=@"checked";
        }
        for (int i=0; i<documentfoldersalesreceiptarray.count; i++) {
            ((SalesReceiptRecord *)[documentfoldersalesreceiptarray objectAtIndex:i]).checkstatus=@"checked";
        }
        [receipttable reloadData];
        [self refreshReceiptSelectedPaymentCount];
    }else if (!invoiceview.hidden){
        for (int i=0; i<documentfolderclassinvoicearray.count; i++) {
            ((ClassInvoiceRecord *)[documentfolderclassinvoicearray objectAtIndex:i]).checkstatus=@"checked";
        }
        for (int i=0; i<documentfoldersalesinvoicearray.count; i++) {
            ((SalesInvoiceRecord *)[documentfoldersalesinvoicearray objectAtIndex:i]).checkstatus=@"checked";
        }
        [invoicetable reloadData];
        [self refreshInvoiceSelectedPaymentCount];
    }else{
        for (int i=0; i<documentfolderclasspaymentarray.count; i++) {
            if ([((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:i]).paidamount floatValue]!=0) {
                ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:i]).checkstatus=@"checked";
            }
        }
        for (int i=0; i<documentfoldersalespaymentarray.count; i++) {
            if ([((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:i]).paidamount floatValue]!=0) {
                ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:i]).checkstatus=@"checked";
            }
        }
        [paymenttable reloadData];
        [self refreshPaymentSelectedPaymentCount];
        [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
        
    }
}

-(void) deselectalldocumentfolderrecords
{
    if (!receiptview.hidden) {
        for (int i=0; i<documentfolderclassreceiptarray.count; i++) {
            ((ClassReceiptRecord *)[documentfolderclassreceiptarray objectAtIndex:i]).checkstatus=@"";
        }
        for (int i=0; i<documentfoldersalesreceiptarray.count; i++) {
            ((SalesReceiptRecord *)[documentfoldersalesreceiptarray objectAtIndex:i]).checkstatus=@"";
        }
        [receipttable reloadData];
        [self refreshReceiptSelectedPaymentCount];
    }else if (!invoiceview.hidden){
        for (int i=0; i<documentfolderclassinvoicearray.count; i++) {
            ((ClassInvoiceRecord *)[documentfolderclassinvoicearray objectAtIndex:i]).checkstatus=@"";
        }
        for (int i=0; i<documentfoldersalesinvoicearray.count; i++) {
            ((SalesInvoiceRecord *)[documentfoldersalesinvoicearray objectAtIndex:i]).checkstatus=@"";
        }
        [invoicetable reloadData];
        [self refreshInvoiceSelectedPaymentCount];
    }else{
        for (int i=0; i<documentfolderclasspaymentarray.count; i++) {
            ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:i]).checkstatus=@"";
        }
        for (int i=0; i<documentfoldersalespaymentarray.count; i++) {
            ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:i]).checkstatus=@"";
        }
        [paymenttable reloadData];
        [self refreshPaymentSelectedPaymentCount];
        [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
    }
}



-(void) didTapOnTableView:(UIGestureRecognizer*) recognizer {
    CGPoint tapLocation = [recognizer locationInView:paymenttable];
    NSIndexPath *indexPath = [paymenttable indexPathForRowAtPoint:tapLocation];
    if (masterviewleadingconstraint.constant!=0) {
        [self closedocumentsidewindow];
    }else{
        [self tableView:paymenttable didSelectRowAtIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == paidmethodtable){

        if (selectedbuttoncoordinate.x==0) {
            ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paidmethod=[paidmethodarray objectAtIndex:indexPath.row];
            if([((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paidamount floatValue]!=0){
                ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).checkstatus=@"checked";
            }
        }else{
            ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paidmethod=[paidmethodarray objectAtIndex:indexPath.row];
            if([((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paidamount floatValue]!=0){
                ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).checkstatus=@"checked";
            }
        }

        [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
        [self refreshPaymentSelectedPaymentCount];
        [self openSideWindowWithTable:@"none"];
        [paymenttable reloadData];
    }else if (tableView==paymenttable){
        if (masterviewleadingconstraint.constant!=0 || supermasterviewleadingconstraint.constant!=0) {
            [self openSideWindowWithTable:@"none"];
            return;
        }
        
        if (indexPath.section==0) {
            if (((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexPath.row]).enrollmentrecord.locked) {
                UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Payments"] message:[MyClass returntitlewithtitle:@"Enrollment with locked class(es) cannot be processed"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [missinginput dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [missinginput addAction:OKAction];
                //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
            }else if ([((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexPath.row]).paidamount floatValue]==0 && [((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexPath.row]).totalfee floatValue]!=0) {
                UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Payments"] message:[MyClass returntitlewithtitle:@"Please input non zero paid amount first"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [missinginput dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [missinginput addAction:OKAction];
                //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
            }else{
                if ([((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexPath.row]).checkstatus isEqualToString:@""]) {
                    ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexPath.row]).checkstatus=@"checked";
                }else{
                    ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexPath.row]).checkstatus=@"";
                }
            }
            if (indexPath) {
                [paymenttable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
            }
            [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
            [self refreshPaymentSelectedPaymentCount];
        }else{
            if ([((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexPath.row]).paidamount floatValue]==0 && [((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexPath.row]).totalfee floatValue]!=0) {
                UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Payments"] message:[MyClass returntitlewithtitle:@"Please input non zero paid amount first"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [missinginput dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [missinginput addAction:OKAction];
                //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
            }else{
                if ([((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexPath.row]).checkstatus isEqualToString:@""]) {
                    ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexPath.row]).checkstatus=@"checked";
                }else{
                    ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexPath.row]).checkstatus=@"";
                }
            }
            if (indexPath) {
                [paymenttable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
            [self refreshPaymentSelectedPaymentCount];
        }


        
    }else if (tableView==invoicetable){
        if (masterviewleadingconstraint.constant!=0|| supermasterviewleadingconstraint.constant!=0) {
            [self openSideWindowWithTable:@"none"];
            return;
        }
        
        if (indexPath.section==0) {
            if ([((ClassInvoiceRecord *)[documentfolderclassinvoicearray objectAtIndex:indexPath.row]).checkstatus isEqualToString:@""]) {
                ((ClassInvoiceRecord *)[documentfolderclassinvoicearray objectAtIndex:indexPath.row]).checkstatus=@"checked";
            }else{
                ((ClassInvoiceRecord *)[documentfolderclassinvoicearray objectAtIndex:indexPath.row]).checkstatus=@"";
            }
            if (indexPath) {
                [invoicetable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            [self refreshInvoiceSelectedPaymentCount];
        }else if (indexPath.section==1) {
            if ([((SalesInvoiceRecord *)[documentfoldersalesinvoicearray objectAtIndex:indexPath.row]).checkstatus isEqualToString:@""]) {
                ((SalesInvoiceRecord *)[documentfoldersalesinvoicearray objectAtIndex:indexPath.row]).checkstatus=@"checked";
            }else{
                ((SalesInvoiceRecord *)[documentfoldersalesinvoicearray objectAtIndex:indexPath.row]).checkstatus=@"";
            }
            if (indexPath) {
                [invoicetable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            [self refreshInvoiceSelectedPaymentCount];
        }


    }else if (tableView==receipttable){
        if (masterviewleadingconstraint.constant!=0|| supermasterviewleadingconstraint.constant!=0) {
            [self openSideWindowWithTable:@"none"];
            return;
        }
        if (indexPath.section==0) {
            if ([((ClassReceiptRecord *)[documentfolderclassreceiptarray objectAtIndex:indexPath.row]).checkstatus isEqualToString:@""]) {
                ((ClassReceiptRecord *)[documentfolderclassreceiptarray objectAtIndex:indexPath.row]).checkstatus=@"checked";
            }else{
                ((ClassReceiptRecord *)[documentfolderclassreceiptarray objectAtIndex:indexPath.row]).checkstatus=@"";
            }
            if (indexPath) {
                [receipttable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            [self refreshReceiptSelectedPaymentCount];
        }else if (indexPath.section==1) {
            if ([((SalesReceiptRecord *)[documentfoldersalesreceiptarray objectAtIndex:indexPath.row]).checkstatus isEqualToString:@""]) {
                ((SalesReceiptRecord *)[documentfoldersalesreceiptarray objectAtIndex:indexPath.row]).checkstatus=@"checked";
            }else{
                ((SalesReceiptRecord *)[documentfoldersalesreceiptarray objectAtIndex:indexPath.row]).checkstatus=@"";
            }
            if (indexPath) {
                [receipttable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            
            [self refreshReceiptSelectedPaymentCount];
        }
        
    }else if (tableView==PromotionCodeTable){
        if (masterviewleadingconstraint.constant==0) {
            //batch discount
            MarketingRecord *sourceobject=[filteredavailablepromotionarray objectAtIndex:indexPath.row];
            [self updateAmountWithDiscountWithMarketingRecord:sourceobject];
        }else{
            MarketingRecord *sourceobject=[filteredavailablepromotionarray objectAtIndex:indexPath.row];
            MarketingRecord *destobject=[[MarketingRecord alloc]initMarketingRecordWithcenterkey:sourceobject.centerkey marketingkey:sourceobject.marketingkey category:sourceobject.category description:sourceobject.description description_chinese:sourceobject.description_chinese startdate:sourceobject.startdate enddate:sourceobject.enddate remarks:sourceobject.remarks promotionfixeddiscount:sourceobject.promotionfixeddiscount promotionpercentagediscount:sourceobject.promotionpercentagediscount usedcount:sourceobject.usedcount promotionquota:sourceobject.promotionquota code:sourceobject.code recursive:sourceobject.recursive effectivefrom:sourceobject.effectivefrom effectiveto:sourceobject.effectiveto subcategory:sourceobject.subcategory redeemable:NO redeempoint:nil perstudentquota:nil cannotuseconjunctionwithothercoupons:sourceobject.cannotuseconjunctionwithothercoupons subjectarray:nil productarray:nil couponallowcredit:nil perclassorquantity:sourceobject.perclassorquantity earlybirdlastdate:sourceobject.earlybirdlastdate buymorepayless:sourceobject.buymorepayless estartdate:sourceobject.estartdate eenddate:sourceobject.eenddate enablebuymorepayless:sourceobject.enablebuymorepayless minnoofclass:sourceobject.minnoofclass bmsmacrossothersubjects:sourceobject.bmsmacrossothersubjects bmsmminsubjectno:0 bmsmminnoofclasspersubject:0 bmsmsamebillmonth:NO manualapply:sourceobject.manualapply];
            NSMutableArray *promotionarray=[self returnPromotionArray];
            [promotionarray addObject:destobject];
            [PromotionCodeTable deselectRowAtIndexPath:[PromotionCodeTable indexPathForSelectedRow] animated:YES];
            [self updatePaymentRecordTotalFeeAndDiscountWithReloadDiscountTable:YES Update:@"promotion"];

        }
        [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    }else if (tableView==CouponTable){
        CouponRecord *sourceobject=[filteredavailablecouponarray objectAtIndex:indexPath.row];
        if([self couponcanbeselected:sourceobject]){
            BOOL foundInreleasedcouponarray=FALSE;
            for(int i=0;i<releasedcouponarray.count;i++){
                CouponRecord *object=[releasedcouponarray objectAtIndex:i];
                if([object.couponkey isEqualToString:sourceobject.couponkey]){
                    [releasedcouponarray removeObjectAtIndex:i];
                    foundInreleasedcouponarray=TRUE;
                    break;
                }
            }
            
            if(!foundInreleasedcouponarray){
                [newlyusedcouponarray addObject:sourceobject];
            }
            
            NSMutableArray *couponarray=[self returnCouponArray];
            [couponarray addObject:sourceobject];
            
            [CouponTable deselectRowAtIndexPath:[CouponTable indexPathForSelectedRow] animated:YES];
            [self updatePaymentRecordTotalFeeAndDiscountWithReloadDiscountTable:YES Update:@"coupon"];
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
            
            if(!couponView.hidden){
                [self showavailablecoupon];
            }
        }
    }
}

-(NSString *) returntotalpayamount
{
    float totalpayable=0;
    BOOL discountupdated=FALSE;
    for (int i=0; i<documentfolderclasspaymentarray.count; i++) {
        ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:i];
        if ([obj.checkstatus isEqualToString:@"checked"]) {
            totalpayable+=[obj.paidamount floatValue];
        }
        
        if (obj.enrollmentrecord.status) {
            discountupdated=YES;
        }
        
    }
    
    for (int i=0; i<documentfoldersalespaymentarray.count; i++) {
        SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:i];
        if ([obj.checkstatus isEqualToString:@"checked"]) {
            totalpayable+=[obj.paidamount floatValue];
        }
        
        if (obj.salesrecord.status) {
            discountupdated=YES;
        }
    }
    
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    
    if (discountupdated) {
        payment_savediscountbutton.hidden=NO;
        if (totalpayable==0) {
            return [MyClass returntitlewithtitle:@"Save & Pay"];
        }else{
            return [NSString stringWithFormat:@"  %@(%@)  ",[MyClass returntitlewithtitle:@"Save & Pay"],[formatter stringFromNumber:[NSNumber numberWithFloat:totalpayable]]];
        }
    }else{
        payment_savediscountbutton.hidden=YES;
        if (totalpayable==0) {
            return [MyClass returntitlewithtitle:@"Pay"];
        }else{
            return [NSString stringWithFormat:@"  %@(%@)  ",[MyClass returntitlewithtitle:@"Pay"],[formatter stringFromNumber:[NSNumber numberWithFloat:totalpayable]]];
        }
    }
    
    
    

    
}

/*
- (void)downloadImageWithURL:(NSURL *)url studentimage:(UIImageView *)simage indexpath:(NSIndexPath *)indexpath completionBlock:(void (^)(BOOL succeeded, NSData *data, UIImageView *simage, NSIndexPath *imageindexpath, NSURL *_url))completionBlock
{
    if (![imageCache objectForKey:url]){
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:15.0];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            if (!error) {
                completionBlock(YES, data, simage,indexpath,url);
            } else {
                completionBlock(NO, nil, simage,indexpath,url);
            }
        }];
    }else{
        completionBlock(YES,nil,nil,nil,nil);
    }
}*/

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

-(void) updatecppaidamount:(UITextField *)sender
{
    if (![self checkvalidfeeinput:sender.text]) {
        [paymenttable reloadData];
    }else{
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:paymenttable];
        NSIndexPath *indexpath =[paymenttable indexPathForRowAtPoint:point];
        if (!indexpath) {
            indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
        }
        
        ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexpath.row]).paidamount=sender.text;
        
        MyTableViewCell *cell=[paymenttable cellForRowAtIndexPath:indexpath];
        UIImageView *checkbutton=cell.imageview1;
        
        if ([sender.text floatValue]==0) {
            if ([((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexpath.row]).checkstatus isEqualToString:@"checked"]) {
                ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexpath.row]).checkstatus=@"";
                checkbutton.layer.opacity=0.3;
                [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
                [self refreshPaymentSelectedPaymentCount];
            }
        }else{
                ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexpath.row]).checkstatus=@"checked";
                checkbutton.layer.opacity=1;
                [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
                [self refreshPaymentSelectedPaymentCount];
        }
    }
}

-(void) updatecppaymentremarks:(UITextField *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:paymenttable];
    NSIndexPath *indexpath =[paymenttable indexPathForRowAtPoint:point];
    
    ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexpath.row]).paymentremarks=sender.text;
}

-(void) updatecpreceiptremarks:(UITextField *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:paymenttable];
    NSIndexPath *indexpath =[paymenttable indexPathForRowAtPoint:point];
    
    ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:indexpath.row]).receiptremarks=sender.text;
}


-(void) updatesppaidamount:(UITextField *)sender
{
    if (![self checkvalidfeeinput:sender.text]) {
        [paymenttable reloadData];
    }else{
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:paymenttable];
        NSIndexPath *indexpath =[paymenttable indexPathForRowAtPoint:point];
        
        if (!indexpath) {
            indexpath=[NSIndexPath indexPathForRow:0 inSection:1];
        }
        
        ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexpath.row]).paidamount=sender.text;
        
        MyTableViewCell *cell=[paymenttable cellForRowAtIndexPath:indexpath];
        UIImageView *checkbutton=cell.imageview1;
        //UIButton *checkbutton=(UIButton *)[sender.superview.superview.superview.superview viewWithTag:217];
        
        
        if ([sender.text floatValue]==0) {
            if ([((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexpath.row]).checkstatus isEqualToString:@"checked"]) {
                ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexpath.row]).checkstatus=@"";
                checkbutton.layer.opacity=0.3;
                [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
                [self refreshPaymentSelectedPaymentCount];
            }
        }else{
            //if ([((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexpath.row]).checkstatus isEqualToString:@"checked"]) {
                ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexpath.row]).checkstatus=@"checked";
                checkbutton.layer.opacity=1;
                [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
                [self refreshPaymentSelectedPaymentCount];
            //}
        }
    }
}

-(void) updatesppaymentremarks:(UITextField *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:paymenttable];
    NSIndexPath *indexpath =[paymenttable indexPathForRowAtPoint:point];
    
    ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexpath.row]).paymentremarks=sender.text;
}

-(void) updatespreceiptremarks:(UITextField *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:paymenttable];
    NSIndexPath *indexpath =[paymenttable indexPathForRowAtPoint:point];
    
    ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:indexpath.row]).receiptremarks=sender.text;
}

-(void) updateciinvoiceremarks:(UITextField *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:invoicetable];
    NSIndexPath *indexpath =[invoicetable indexPathForRowAtPoint:point];
    
    ((ClassInvoiceRecord *)[documentfolderclassinvoicearray objectAtIndex:indexpath.row]).invoiceremarks=sender.text;
    [self updateRemarksWithType:@"class" TypeKey:((ClassInvoiceRecord *)[documentfolderclassinvoicearray objectAtIndex:indexpath.row]).enrollmentkey Remarks:sender.text];
    
}

-(void) updatesiinvoiceremarks:(UITextField *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:invoicetable];
    NSIndexPath *indexpath =[invoicetable indexPathForRowAtPoint:point];
    
    ((SalesInvoiceRecord *)[documentfoldersalesinvoicearray objectAtIndex:indexpath.row]).invoiceremarks=sender.text;
    [self updateRemarksWithType:@"sales" TypeKey:((SalesInvoiceRecord *)[documentfoldersalesinvoicearray objectAtIndex:indexpath.row]).saleskey Remarks:sender.text];
    
}

-(void) updatecrreceiptremarks:(UITextField *)sender
{
    if(documentfolderclassreceiptarray.count>0){
        PaymentRecord *firstrecord=[((ClassReceiptRecord *)[documentfolderclassreceiptarray objectAtIndex:sender.tag]).enrollmentrecord.paymentrecords firstObject];
        firstrecord.receiptremarks=sender.text;
        [self updateReceiptRemarksWithPaymentkey:firstrecord.paymentkey Remarks:sender.text];
    }
}

-(void) updatesrreceiptremarks:(UITextField *)sender
{
    if(documentfoldersalesreceiptarray.count>0){
        PaymentRecord *firstrecord=[((SalesReceiptRecord *)[documentfoldersalesreceiptarray objectAtIndex:sender.tag]).salesrecord.paymentrecords firstObject];
        firstrecord.receiptremarks=sender.text;
        [self updateReceiptRemarksWithPaymentkey:firstrecord.paymentkey Remarks:sender.text];
    }
}

-(void) updatecrpaymentremarks:(UITextField *)sender
{
    if(documentfolderclassreceiptarray.count>0){
        PaymentRecord *firstrecord=[((ClassReceiptRecord *)[documentfolderclassreceiptarray objectAtIndex:sender.tag]).enrollmentrecord.paymentrecords firstObject];
        firstrecord.paymentremarks=sender.text;
        [self updatePaymentRemarksWithPaymentkey:firstrecord.paymentkey Remarks:sender.text];
    }
}

-(void) updatesrpaymentremarks:(UITextField *)sender
{
    if(documentfoldersalesreceiptarray.count>0){
        PaymentRecord *firstrecord=[((SalesReceiptRecord *)[documentfoldersalesreceiptarray objectAtIndex:sender.tag]).salesrecord.paymentrecords firstObject];
        firstrecord.paymentremarks=sender.text;
        [self updatePaymentRemarksWithPaymentkey:firstrecord.paymentkey Remarks:sender.text];
    }
}

-(void) selectdiscount:(UIButton *)sender event:(id)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPos = [touch locationInView:paymenttable];
    NSIndexPath *indexpath = [paymenttable indexPathForRowAtPoint:touchPos];
    
    MultiCoordinate *newcoordinate=[[MultiCoordinate alloc]initMultiCoordinatewithx:indexpath.section y:indexpath.row z:2];
    
    NSString *studentkey;
    NSString *typekey;
    NSString *type;
    NSString *subjectkey;
    NSString *productkey;
    
    if(newcoordinate.x==0){
        studentkey=((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:newcoordinate.y]).studentkey;
        typekey=[MyClass returnsubjectkeywithsubject_shortname:((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:newcoordinate.y]).subject_shortname];
        type=@"Class";
        subjectkey=[MyClass returnsubjectkeywithsubject_shortname:((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:newcoordinate.y]).subject_shortname];
    }else{
        studentkey=((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:newcoordinate.y]).studentkey;
        typekey=[MyClass returnproductkeywithproductcode:((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:newcoordinate.y]).productcode];
        type=@"Sales";
        productkey=[MyClass returnproductkeywithproductcode:((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:newcoordinate.y]).productcode];
    }
    
    availablecouponarray=[[NSMutableArray alloc]init];
    [MyClass retrieveUnusedCouponWithStudentkey:studentkey type:type availableCouponArray:availablecouponarray typekey:typekey];
    for (int i=0; i<releasedcouponarray.count; i++) {
        CouponRecord *obj=[releasedcouponarray objectAtIndex:i];
        MarketingRecord *mktobj=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
        if([obj.studentkey isEqualToString:studentkey] && ([mktobj.subcategory isEqualToString:@"All"] || [mktobj.subcategory isEqualToString:type])){
            [availablecouponarray addObject:obj];
        }
    }
    
    for(int i=0;i<newlyusedcouponarray.count;i++){
        CouponRecord *newlyusedcoupon=[newlyusedcouponarray objectAtIndex:i];
        for(int j=0;j<availablecouponarray.count;j++){
            CouponRecord *availablecoupon=[availablecouponarray objectAtIndex:j];
            if([availablecoupon.couponkey isEqualToString:newlyusedcoupon.couponkey]){
                [availablecouponarray removeObjectAtIndex:j];
                break;
            }
        }
    }
    filteredavailablecouponarray=[[NSMutableArray alloc]initWithArray:availablecouponarray];
    
    availablepromotionarray=[[MyClass retrieveMarketingRecordWithStatus:@"Valid" enrollmentdate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] flushcachedata:NO subjectkey:subjectkey productkey:productkey] objectAtIndex:2];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.manualapply == YES"];
    filteredavailablepromotionarray=[[NSMutableArray alloc]initWithArray:[availablepromotionarray filteredArrayUsingPredicate:predicate]];
//    filteredavailablepromotionarray=[[NSMutableArray alloc]initWithArray:availablepromotionarray];
    
    if (masterviewleadingconstraint.constant<0) {
        if ([self isMultiCoordinateSameWithMultiCoordinate1:newcoordinate MultiCoordinate2:selectedbuttoncoordinate]) {
            selectedbuttoncoordinate=nil;
            [self openSideWindowWithTable:@"none"];
        }else{
            selectedbuttoncoordinate =newcoordinate;
            [self openSideWindowWithTable:@"discount"];
        }
    }else{
        selectedbuttoncoordinate =newcoordinate;
        [self openSideWindowWithTable:@"discount"];
    }
    [paymenttable reloadData];
}

-(void) selectpaidmethod:(id)sender event:(id)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPos = [touch locationInView:paymenttable];
    NSIndexPath *indexpath = [paymenttable indexPathForRowAtPoint:touchPos];
    
    MultiCoordinate *newcoordinate=[[MultiCoordinate alloc]initMultiCoordinatewithx:indexpath.section y:indexpath.row z:1];

    if (masterviewleadingconstraint.constant<0) {
        if ([self isMultiCoordinateSameWithMultiCoordinate1:newcoordinate MultiCoordinate2:selectedbuttoncoordinate]) {
            selectedbuttoncoordinate=nil;
            [self openSideWindowWithTable:@"none"];
        }else{
            selectedbuttoncoordinate =newcoordinate;
            [self openSideWindowWithTable:@"paidmethod"];
        }
    }else{
        selectedbuttoncoordinate =newcoordinate;
        [self openSideWindowWithTable:@"paidmethod"];
    }
    [paymenttable reloadData];
}

-(void) selectpaiddate:(id)sender event:(id)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPos = [touch locationInView:paymenttable];
    NSIndexPath *indexpath = [paymenttable indexPathForRowAtPoint:touchPos];
    
    MultiCoordinate *newcoordinate=[[MultiCoordinate alloc]initMultiCoordinatewithx:indexpath.section y:indexpath.row z:0];

    if (masterviewleadingconstraint.constant<0) {
        if ([self isMultiCoordinateSameWithMultiCoordinate1:newcoordinate MultiCoordinate2:selectedbuttoncoordinate]) {
            selectedbuttoncoordinate=nil;
            [self openSideWindowWithTable:@"none"];
        }else{
            selectedbuttoncoordinate =newcoordinate;
            //if (paiddatetable.hidden) {
                [self openSideWindowWithTable:@"paiddate"];
            //}
        }
    }else{
        selectedbuttoncoordinate =newcoordinate;
        [self openSideWindowWithTable:@"paiddate"];
    }
    [paymenttable reloadData];
}

-(void) adddiscountbuttonpressed:(UIButton *)sender
{
    availablepromotionarray=[[MyClass retrieveMarketingRecordWithStatus:@"Valid" enrollmentdate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] flushcachedata:NO subjectkey:@"allonly" productkey:@"allonly"] objectAtIndex:2];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.manualapply == YES"];
    filteredavailablepromotionarray=[[NSMutableArray alloc]initWithArray:[availablepromotionarray filteredArrayUsingPredicate:predicate]];
    
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];

    selectedbuttoncoordinate=nil;
    if (supermasterviewleadingconstraint.constant==0) {
        //selectedPaidMethodButtonIndexPath =nil;
        //selectedPaidDateButtonIndexPath=nil;
        [paymenttable reloadData];
        [self openSideWindowWithTable:@"batchdiscount"];
    }else{
        [self openSideWindowWithTable:@"none"];
    }

}

-(void) showpromotioncode
{
    [self openSideWindowWithTable:@"promotioncode"];
}

-(void) showavailablecoupon
{
    NSString *studentkey;
    NSString *typekey;
    NSString *type;
    
    if(selectedbuttoncoordinate.x==0){
        studentkey=((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).studentkey;
        typekey=[MyClass returnsubjectkeywithsubject_shortname:((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).subject_shortname];
        type=@"Class";
    }else{
        studentkey=((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).studentkey;
        typekey=[MyClass returnproductkeywithproductcode:((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).productcode];
        type=@"Sales";
    }
    
    availablecouponarray=[[NSMutableArray alloc]init];
    [MyClass retrieveUnusedCouponWithStudentkey:studentkey type:type availableCouponArray:availablecouponarray typekey:typekey];
    
//    availablecouponarray=[[NSMutableArray alloc]initWithArray:[availablecouponarray arrayByAddingObjectsFromArray:releasedcouponarray]];
    
    
    for (int i=0; i<releasedcouponarray.count; i++) {
        CouponRecord *obj=[releasedcouponarray objectAtIndex:i];
        MarketingRecord *mktobj=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
        if([obj.studentkey isEqualToString:studentkey] && ([mktobj.subcategory isEqualToString:@"All"] || [mktobj.subcategory isEqualToString:type])){
            [availablecouponarray addObject:obj];
        }
    }
    
    for(int i=0;i<newlyusedcouponarray.count;i++){
        CouponRecord *newlyusedcoupon=[newlyusedcouponarray objectAtIndex:i];
        for(int j=0;j<availablecouponarray.count;j++){
            CouponRecord *availablecoupon=[availablecouponarray objectAtIndex:j];
            if([availablecoupon.couponkey isEqualToString:newlyusedcoupon.couponkey]){
                [availablecouponarray removeObjectAtIndex:j];
                break;
            }
        }
    }
    filteredavailablecouponarray=[[NSMutableArray alloc]initWithArray:availablecouponarray];
    
    [self openSideWindowWithTable:@"coupon"];
}





-(void) closedocumentsidewindow
{
    [self openSideWindowWithTable:@"none"];
}

-(void) openSideWindowWithTable:(NSString *)table
{
    if ([table isEqualToString:@"paidmethod"]) {
        [UIView animateWithDuration:0.3f animations:^{
            masterviewleadingconstraint.constant=-paidmethodtablewidth;
            supermasterviewleadingconstraint.constant=0;
            [self.view layoutIfNeeded];
            //paymentview.frame=CGRectMake(-paidmethodtablewidth, paymentview.frame.origin.y, documentfoldertablewidth, paymentview.frame.size.height);
        } completion:nil];

        paidmethodtable.hidden=NO;
        paiddatetable.hidden=YES;
        discounttableview.hidden=YES;
        [paidmethodtable reloadData];
        
        long index=-1;
        if (selectedbuttoncoordinate.x==0){
            if ([paidmethodarray containsObject:((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paidmethod]) {
                index=[paidmethodarray indexOfObject:((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paidmethod];
            }
        }else{
            if ([paidmethodarray containsObject:((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paidmethod]) {
                index=[paidmethodarray indexOfObject:((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paidmethod];
            }
        }
        if (index>=0){
            [paidmethodtable selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
            selectallbutton.enabled=YES;
            selectallbutton.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        }else{
            selectallbutton.enabled=NO;
            selectallbutton.backgroundColor=[UIColor lightGrayColor];
        }
        
    }else if ([table isEqualToString:@"paiddate"]){
        [UIView animateWithDuration:0.3f animations:^{
            masterviewleadingconstraint.constant=-paiddatetablewidth;
            supermasterviewleadingconstraint.constant=0;
            [self.view layoutIfNeeded];
            //paymentview.frame=CGRectMake(-paiddatetablewidth, paymentview.frame.origin.y, documentfoldertablewidth, paymentview.frame.size.height);
        } completion:nil];

        paidmethodtable.hidden=YES;
        paiddatetable.hidden=NO;
        discounttableview.hidden=YES;
        [paiddatetable reloadData];
    }else if ([table isEqualToString:@"discount"]){
        [UIView animateWithDuration:0.3f animations:^{
            masterviewleadingconstraint.constant=-promotioncodetablewidth;
            supermasterviewleadingconstraint.constant=0;
            [self.view layoutIfNeeded];
        } completion:nil];
        promotioncodeclosebutton.hidden=YES;
        paidmethodtable.hidden=YES;
        paiddatetable.hidden=YES;
        discounttableview.hidden=NO;
        [DiscountTable reloadData];
    }else if ([table isEqualToString:@"batchdiscount"]){
        [UIView animateWithDuration:0.3f animations:^{
            masterviewleadingconstraint.constant=0;
            supermasterviewleadingconstraint.constant=-promotioncodetablewidth;
            promotioncodeclosebutton.hidden=NO;
            [self.view layoutIfNeeded];
        } completion:nil];
        couponView.hidden=YES;
        promotioncodeView.hidden=NO;
        [PromotionCodeTable reloadData];
    }else if ([table isEqualToString:@"promotioncode"]){
        [UIView animateWithDuration:0.3f animations:^{
            supermasterviewleadingconstraint.constant=-promotioncodetablewidth;
            [self.view layoutIfNeeded];
        } completion:nil];
        promotioncodeclosebutton.hidden=YES;
        couponView.hidden=YES;
        promotioncodeView.hidden=NO;
        [PromotionCodeTable reloadData];
    }else if ([table isEqualToString:@"coupon"]){
        [UIView animateWithDuration:0.3f animations:^{
            supermasterviewleadingconstraint.constant=-promotioncodetablewidth;
            [self.view layoutIfNeeded];
        } completion:nil];
        couponclosebutton.hidden=YES;
        couponView.hidden=NO;
        promotioncodeView.hidden=YES;
        [CouponTable reloadData];
    }else{
        if (masterviewleadingconstraint.constant!=0 || supermasterviewleadingconstraint.constant!=0) {
            [UIView animateWithDuration:0.3f animations:^{
                masterviewleadingconstraint.constant=0;
                supermasterviewleadingconstraint.constant=0;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished){
                paidmethodtable.hidden=YES;
                paiddatetable.hidden=YES;
                discounttableview.hidden=YES;
                selectedbuttoncoordinate=nil;
                [paymenttable reloadData];
            
            }];
        }
    }
}


-(void) clearalldocumentfolderrecords
{
    //if (!invoiceview.hidden) {
        globalvariables.documentfolder.classinvoicearray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salesinvoicearray=[[NSMutableArray alloc]init];
        documentfolderclassinvoicearray=[[NSMutableArray alloc]init];
        documentfoldersalesinvoicearray=[[NSMutableArray alloc]init];
        [invoicebutton setTitle:[NSString stringWithFormat:@"%@(%d)",[MyClass returntitlewithtitle:@"Invoice"],(int)documentfolderclassinvoicearray.count+(int)documentfoldersalesinvoicearray.count] forState:UIControlStateNormal];
        [invoicetable reloadData];
        [self refreshInvoiceSelectedPaymentCount];
    //}else if (!receiptview.hidden){
        globalvariables.documentfolder.classreceiptarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salesreceiptarray=[[NSMutableArray alloc]init];
        documentfolderclassreceiptarray=[[NSMutableArray alloc]init];
        documentfoldersalesreceiptarray=[[NSMutableArray alloc]init];
        [receiptbutton setTitle:[NSString stringWithFormat:@"%@(%d)",[MyClass returntitlewithtitle:@"Receipt"],(int)documentfolderclassreceiptarray.count+(int)documentfoldersalesreceiptarray.count] forState:UIControlStateNormal];
        [receipttable reloadData];
        [self refreshReceiptSelectedPaymentCount];
    //}else{
        globalvariables.documentfolder.classpaymentarray=[[NSMutableArray alloc]init];
        globalvariables.documentfolder.salespaymentarray=[[NSMutableArray alloc]init];
        documentfolderclasspaymentarray=[[NSMutableArray alloc]init];
        documentfoldersalespaymentarray=[[NSMutableArray alloc]init];
    
    //[batchpromotioncodekey removeAllObjects];
    
        [paymentbutton setTitle:[NSString stringWithFormat:@"%@(%d)",[MyClass returntitlewithtitle:@"Payment"],(int)documentfolderclasspaymentarray.count+(int)documentfoldersalespaymentarray.count] forState:UIControlStateNormal];
        [paymenttable reloadData];
        [self refreshPaymentSelectedPaymentCount];
    //}
    [self adjusttablesize];
    
    [self.delegate refreshdocumentfoldercountnumber];
    [self.delegate dismissDocumentFolderPopover];
    
}
/*
-(void) documentfoldersharebuttonpressed:(UIButton *)sender
{
    if (sender.tag==20 || sender.tag==21) {
        [aidocumentfoldershareinvoice startAnimating];
    }else{
        [aidocumentfoldersharereceipt startAnimating];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (sender.tag==20 || sender.tag==21) {
            [self sharepaymentinvoicewithbutton:sender];
        }else{
            [self sharepaymentreceiptwithbutton:sender];
        }
        if (sender.tag==20 || sender.tag==21) {
            [aidocumentfoldershareinvoice stopAnimating];
        }else{
            [aidocumentfoldersharereceipt stopAnimating];
        }
    });
}*/


-(void) sharebuttonpressed:(UIButton *)sender
{
    [self.view endEditing:YES];
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    if (sender.tag==0) {
        
        if (![self isInvoiceSelected]){
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Invoices"] message:[MyClass returntitlewithtitle:@"Please select invoice"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
            sender.enabled=TRUE;
            
        }else{
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self sharepaymentinvoicewithbutton:sender];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                
            });
        }
        
        
        

    }else{
        
        if (![self isReceiptSelected]){
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Receipts"] message:[MyClass returntitlewithtitle:@"Please select receipt"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
            sender.enabled=TRUE;
            
        }else{
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            //aireceipt.center=sender.center;
            //[aireceipt startAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self sharepaymentreceiptwithbutton:sender];
                //[aireceipt stopAnimating];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }
        

    }
}

-(void) emailbuttonpressed:(UIButton *)sender
{
    [self.view endEditing:YES];
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    
    if (sender.tag==0) {
        
        if (![self isInvoiceSelected]){
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Invoices"] message:[MyClass returntitlewithtitle:@"Please select invoice"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
            sender.enabled=TRUE;
            
        }else{
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            //aiinvoice.center=sender.center;
            //[aiinvoice startAnimating];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self emailPDF:[MyClass generateInvoiceWithClassInvoiceArray:[self returnCheckedDocumentFolderClassInvoiceArray] SalesInvoiceArray:[self returnCheckedDocumentFolderSalesInvoiceArray] papersizeoverride:YES combinedocument:invoice_combine_leftbutton.tag==1?YES:NO centerkey:globalvariables.centerrecord.centerkey] pdftype:@"Invoice" filename:[MyClass returninvoicenumberwithclassinvoicearray:[self returnCheckedDocumentFolderClassInvoiceArray] salesinvoicearray:[self returnCheckedDocumentFolderSalesInvoiceArray] updateinvoicelog:NO] receiptient:[self returnmailreceiptientwithclassarray:documentfolderclassinvoicearray salesarray:documentfoldersalesinvoicearray type:@"Invoice"]];
                [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
                //[aiinvoice stopAnimating];
                
            });
        }
    }else{
        
        if (![self isReceiptSelected]){
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Receipts"] message:[MyClass returntitlewithtitle:@"Please select receipt"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
            sender.enabled=TRUE;
            
        }else{
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            //aireceipt.center=sender.center;
            //[aireceipt startAnimating];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self emailPDF:[MyClass generateReceiptWithClassReceiptArray:[self returnCheckedDocumentFolderClassReceiptArray] SalesReceiptArray:[self returnCheckedDocumentFolderSalesReceiptArray] papersizeoverride:YES combinedocument:receipt_combine_leftbutton.tag==1?YES:NO centerkey:globalvariables.centerrecord.centerkey] pdftype:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:[self returnCheckedDocumentFolderClassReceiptArray] salesreceiptarray:[self returnCheckedDocumentFolderSalesReceiptArray]] receiptient:[self returnmailreceiptientwithclassarray:documentfolderclassreceiptarray salesarray:documentfoldersalesreceiptarray type:@"Receipt"]];
                //[aireceipt stopAnimating];
                [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
                
            });
        }
    }
}


-(void) messagebuttonpressed:(UIButton *)sender
{
    [self.view endEditing:YES];
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    if (sender.tag==0) {
        
        if (![self isInvoiceSelected]){
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Invoices"] message:[MyClass returntitlewithtitle:@"Please select invoice"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
            sender.enabled=TRUE;
            
        }else{
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            //aiinvoice.center=sender.center;
            //[aiinvoice startAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self messagePDFWithDocumentType:@"Invoice"];
                [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
               
            });
        }
    }else{
        
        if (![self isReceiptSelected]){
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Receipts"] message:[MyClass returntitlewithtitle:@"Please select receipt"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
            sender.enabled=TRUE;
            
        }else{
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            //aireceipt.center=sender.center;
            //[aireceipt startAnimating];
            //[self startsidewindowanimationwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self messagePDFWithDocumentType:@"Receipt"];
                [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
            });
        }
    }
}


-(void) printbuttonpressed:(UIButton *)sender
{
    [self.view endEditing:YES];
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    if (sender.tag==0) {
        if (![self isInvoiceSelected]){
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Invoices"] message:[MyClass returntitlewithtitle:@"Please select invoice"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
            sender.enabled=TRUE;
            
        }else{
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            //aiinvoice.center=sender.center;
            //[aiinvoice startAnimating];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self printPDF:[MyClass generateInvoiceWithClassInvoiceArray:[self returnCheckedDocumentFolderClassInvoiceArray] SalesInvoiceArray:[self returnCheckedDocumentFolderSalesInvoiceArray] papersizeoverride:NO combinedocument:invoice_combine_leftbutton.tag==1 centerkey:globalvariables.centerrecord.centerkey] button:sender];
                //[aiinvoice stopAnimating];
                [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
                
            });
        }
        
        
        

        
    }else{
        if (![self isReceiptSelected]){
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Receipts"] message:[MyClass returntitlewithtitle:@"Please select receipt"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
            sender.enabled=TRUE;
            
        }else{
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            //aireceipt.center=sender.center;
            //[aireceipt startAnimating];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self printPDF:[MyClass generateReceiptWithClassReceiptArray:[self returnCheckedDocumentFolderClassReceiptArray] SalesReceiptArray:[self returnCheckedDocumentFolderSalesReceiptArray] papersizeoverride:NO combinedocument:receipt_combine_leftbutton.tag==1?YES:NO centerkey:globalvariables.centerrecord.centerkey] button:sender];
                //[aireceipt stopAnimating];
                [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
                
            });
        }
        
        
        

    }

}

-(NSMutableArray *) returnCheckedDocumentFolderClassInvoiceArray
{
    NSMutableArray *resultarray=[[NSMutableArray alloc]init];
    for (int i=0; i<documentfolderclassinvoicearray.count; i++) {
        if ([((ClassInvoiceRecord *)[documentfolderclassinvoicearray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
            [resultarray addObject:[documentfolderclassinvoicearray objectAtIndex:i]];
        }
    }
    return resultarray;
}

-(NSMutableArray *) returnCheckedDocumentFolderSalesInvoiceArray
{
    NSMutableArray *resultarray=[[NSMutableArray alloc]init];
    for (int i=0; i<documentfoldersalesinvoicearray.count; i++) {
        if ([((SalesInvoiceRecord *)[documentfoldersalesinvoicearray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
            [resultarray addObject:[documentfoldersalesinvoicearray objectAtIndex:i]];
        }
    }
    return resultarray;
}

-(NSMutableArray *) returnCheckedDocumentFolderClassReceiptArray
{
    NSMutableArray *resultarray=[[NSMutableArray alloc]init];
    for (int i=0; i<documentfolderclassreceiptarray.count; i++) {
        if ([((ClassReceiptRecord *)[documentfolderclassreceiptarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
            [resultarray addObject:[documentfolderclassreceiptarray objectAtIndex:i]];
        }
    }
    return resultarray;
}

-(NSMutableArray *) returnCheckedDocumentFolderSalesReceiptArray
{
    NSMutableArray *resultarray=[[NSMutableArray alloc]init];
    for (int i=0; i<documentfoldersalesreceiptarray.count; i++) {
        if ([((SalesReceiptRecord *)[documentfoldersalesreceiptarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
            [resultarray addObject:[documentfoldersalesreceiptarray objectAtIndex:i]];
        }
    }
    return resultarray;
}


-(NSArray *) returnmailreceiptientwithclassarray:(NSMutableArray *)classarray salesarray:(NSMutableArray *)salesarray type:(NSString *)type
{
    NSMutableArray *mailreceiptientarray=[[NSMutableArray alloc]init];
    if ([type isEqualToString:@"Invoice"]) {
        for (int i=0; i<classarray.count; i++) {
            if ([((ClassInvoiceRecord *)[classarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
                if (![((ClassInvoiceRecord *)[classarray objectAtIndex:i]).parentemail isEqualToString:@""]) {
                    if (![mailreceiptientarray containsObject:((ClassInvoiceRecord *)[classarray objectAtIndex:i]).parentemail]) {
                        [mailreceiptientarray addObject:((ClassInvoiceRecord *)[classarray objectAtIndex:i]).parentemail];
                    }
                    
                }
            }
        }
        
        for (int i=0; i<salesarray.count; i++) {
            if ([((SalesInvoiceRecord *)[salesarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
                if (![((SalesInvoiceRecord *)[salesarray objectAtIndex:i]).parentemail isEqualToString:@""]) {
                    if (![mailreceiptientarray containsObject:((SalesInvoiceRecord *)[salesarray objectAtIndex:i]).parentemail]) {
                        [mailreceiptientarray addObject:((SalesInvoiceRecord *)[salesarray objectAtIndex:i]).parentemail];
                    }
                    
                }
            }
        }
    }else{
        for (int i=0; i<classarray.count; i++) {
            if ([((ClassReceiptRecord *)[classarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
                if (![((ClassReceiptRecord *)[classarray objectAtIndex:i]).parentemail isEqualToString:@""]) {
                    if (![mailreceiptientarray containsObject:((ClassReceiptRecord *)[classarray objectAtIndex:i]).parentemail]) {
                        [mailreceiptientarray addObject:((ClassReceiptRecord *)[classarray objectAtIndex:i]).parentemail];
                    }
                    
                }
            }
        }
        
        for (int i=0; i<salesarray.count; i++) {
            if ([((SalesReceiptRecord *)[salesarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
                if (![((SalesReceiptRecord *)[salesarray objectAtIndex:i]).parentemail isEqualToString:@""]) {
                    if (![mailreceiptientarray containsObject:((SalesReceiptRecord *)[salesarray objectAtIndex:i]).parentemail]) {
                        [mailreceiptientarray addObject:((SalesReceiptRecord *)[salesarray objectAtIndex:i]).parentemail];
                    }
                    
                }
            }
        }
    }
    
    return mailreceiptientarray;
}

-(NSArray *) returnmessagereceiptientwithclassarray:(NSMutableArray *)classarray salesarray:(NSMutableArray *)salesarray type:(NSString *)type
{
    NSMutableArray *messagereceiptientarray=[[NSMutableArray alloc]init];
    if ([type isEqualToString:@"Invoice"]) {
        for (int i=0; i<classarray.count; i++) {
            if ([((ClassInvoiceRecord *)[classarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
                if (![messagereceiptientarray containsObject:((ClassInvoiceRecord *)[classarray objectAtIndex:i]).studentkey]) {
                    [messagereceiptientarray addObject:((ClassInvoiceRecord *)[classarray objectAtIndex:i]).studentkey];
                }
            }
        }
        
        for (int i=0; i<salesarray.count; i++) {
            if ([((SalesInvoiceRecord *)[salesarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
                if (![messagereceiptientarray containsObject:((SalesInvoiceRecord *)[salesarray objectAtIndex:i]).studentkey]) {
                    [messagereceiptientarray addObject:((SalesInvoiceRecord *)[salesarray objectAtIndex:i]).studentkey];
                }
            }
        }
    }else{
        for (int i=0; i<classarray.count; i++) {
            if ([((ClassReceiptRecord *)[classarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
                if (![messagereceiptientarray containsObject:((ClassReceiptRecord *)[classarray objectAtIndex:i]).studentkey]) {
                    [messagereceiptientarray addObject:((ClassReceiptRecord *)[classarray objectAtIndex:i]).studentkey];
                }
            }
        }
        
        for (int i=0; i<salesarray.count; i++) {
            if ([((SalesReceiptRecord *)[salesarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
                if (![messagereceiptientarray containsObject:((SalesReceiptRecord *)[salesarray objectAtIndex:i]).studentkey]) {
                    [messagereceiptientarray addObject:((SalesReceiptRecord *)[salesarray objectAtIndex:i]).studentkey];
                }
            }
        }
    }
    
    return messagereceiptientarray;
}



-(void) messagePDFWithDocumentType:(NSString *)documenttype
{
    
    if ([documenttype isEqualToString:@"Invoice"]) {
        if(invoice_combine_leftbutton.tag==1){
            

//            NSString *filename=[MyClass returninvoicenumberwithclassinvoicearray:[self returnCheckedDocumentFolderClassInvoiceArray] salesinvoicearray:[self returnCheckedDocumentFolderSalesInvoiceArray] updateinvoicelog:NO];
            NSMutableArray *classArray=[[NSMutableArray alloc]initWithArray:[self returnCheckedDocumentFolderClassInvoiceArray]];
            NSMutableArray *salesArray=[[NSMutableArray alloc]initWithArray:[self returnCheckedDocumentFolderSalesInvoiceArray]];
            
            NSArray *studentkeys=[self returnmessagereceiptientwithclassarray:documentfolderclassinvoicearray salesarray:documentfoldersalesinvoicearray type:@"Invoice"];
            
            
            NSString *alertmessage;
            if (studentkeys.count>1) {
                alertmessage=[MyClass returntitlewithtitle:@"Are you sure to send the COMBINDED document to all parents?"];
            }else{
                alertmessage=[MyClass returntitlewithtitle:@"Are you sure to send the document to parent app?"];
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Message"] message:alertmessage preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                    NSMutableArray *documentArray=[[NSMutableArray alloc]init];
                    NSMutableDictionary *dict;
                    
                    for (int i=0; i<classArray.count; i++) {
                        dict=[[NSMutableDictionary alloc]init];
                        ClassInvoiceRecord * obj=[classArray objectAtIndex:i];
                        [dict setValue:@"Class" forKey:@"paymenttype"];
                        [dict setValue:@"1" forKey:@"documentkey"];
                        [dict setValue:obj.enrollmentkey forKey:@"paymenttypekey"];
//                        [dict setValue:obj.paymentkey forKey:@"paymentkey"];
                        [documentArray addObject:dict];
                    }
                    
                    for (int i=0; i<salesArray.count; i++) {
                        dict=[[NSMutableDictionary alloc]init];
                        SalesInvoiceRecord *obj=[salesArray objectAtIndex:i];
                        [dict setValue:@"Sales" forKey:@"paymenttype"];
                        [dict setValue:@"1" forKey:@"documentkey"];
                        [dict setValue:obj.saleskey forKey:@"paymenttypekey"];
//                        [dict setValue:obj.paymentkey forKey:@"paymentkey"];
                        [documentArray addObject:dict];
                    }
                    
                    [MyClass submitDocumentSendingRequestWithType:@"Invoice" documentArray:documentArray];
                    
                    
                [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
                    
//                    NSData *pdfData=[MyClass generateInvoiceWithClassInvoiceArray:[self returnCheckedDocumentFolderClassInvoiceArray] SalesInvoiceArray:[self returnCheckedDocumentFolderSalesInvoiceArray] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
//
//                OutboxMessageRecord *object=[[OutboxMessageRecord alloc]init];
//                object.photoarray=[[NSMutableArray alloc]init];
//                object.messageenglish=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:documenttype language:@"English"],filename];
//                object.messagechinese=[NSString stringWithFormat:@"%@%@",[MyClass returntitlewithtitle:documenttype language:@"Chinese"],filename];
//                object.recipienttype=@"Student";
//                object.recipientgroup=[[RecipientGroupRecord alloc]init];
//                object.recipientgroup.individualarray=[[NSMutableArray alloc]initWithArray:studentkeys];
//                object.messagetype=[NSString stringWithFormat:@"e%@",documenttype];
//
//                NSURL *interalurl=[MyClass returnInternalURLforNSData:pdfData Filename:[NSString stringWithFormat:@"%@.pdf", object.messageenglish]];
//                [object.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:nil Width:0 Height:0 FileType:@"pdf" InternalURL:interalurl FileName:[NSString stringWithFormat:@"%@.pdf", object.messageenglish] ThumbnailURL:@""]];
//
//
//
//                MessagePopoverViewController *viewController = [[MessagePopoverViewController alloc]init];
//                //MessagePopoverViewController *viewController = (MessagePopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MessagePopoverViewController"];
//                //viewController.delegate=self;
//                [viewController sendMessageWithOutBoxMessage:object];
//                [MyClass loadingindicatorwithoption:@"stop" color:nil];

                
                UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:documenttype] message:[MyClass returntitlewithtitle:@"Message Sent"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                            /*dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.delegate refreshDocumentFolderPresentingViewScreen];
                            });*/
                }];
                
                [missinginput addAction:OKAction];
                    [self presentViewController:missinginput animated:YES completion:nil];
                    
                });
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
                //[aiinvoice stopAnimating];
            }];
            [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
            [alert addAction:OKAction];
            [alert addAction:CancelAction];
            //[self presentViewController:alert animated:YES completion:nil];
                    [MyClass presentViewController:alert View:self];

        }else{
            //uncombine, send separately
            NSMutableArray *classArray=[[NSMutableArray alloc]initWithArray:[self returnCheckedDocumentFolderClassInvoiceArray]];
            NSMutableArray *salesArray=[[NSMutableArray alloc]initWithArray:[self returnCheckedDocumentFolderSalesInvoiceArray]];
            
            
            NSString *alertmessage;
            if (classArray.count+salesArray.count>1) {
                alertmessage=[MyClass returntitlewithtitle:@"Are you sure to send the document to individual parent?"];
            }else{
                alertmessage=[MyClass returntitlewithtitle:@"Are you sure to send the document to parent app?"];
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Message"] message:alertmessage preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                    NSMutableArray *documentArray=[[NSMutableArray alloc]init];
                    NSMutableDictionary *dict;
                    
                    int tmpoutboxdocumentkey=1;
                    for (int i=0; i<classArray.count; i++) {
                        dict=[[NSMutableDictionary alloc]init];
                        ClassInvoiceRecord *obj=[classArray objectAtIndex:i];
                        [dict setValue:@"Class" forKey:@"paymenttype"];
                        [dict setValue:[@(tmpoutboxdocumentkey) stringValue] forKey:@"documentkey"];
                        [dict setValue:obj.enrollmentkey forKey:@"paymenttypekey"];
                        [documentArray addObject:dict];
                        tmpoutboxdocumentkey++;
                    }
                    
                    for (int i=0; i<salesArray.count; i++) {
                        dict=[[NSMutableDictionary alloc]init];
                        SalesInvoiceRecord *obj=[salesArray objectAtIndex:i];
                        [dict setValue:@"Sales" forKey:@"paymenttype"];
                        [dict setValue:[@(tmpoutboxdocumentkey) stringValue] forKey:@"documentkey"];
                        [dict setValue:obj.saleskey forKey:@"paymenttypekey"];
                        [documentArray addObject:dict];
                        tmpoutboxdocumentkey++;
                    }
                    
                    [MyClass submitDocumentSendingRequestWithType:@"Invoice" documentArray:documentArray];
                    
//                    for (int i=0; i<classArray.count; i++) {
//                    NSMutableArray *classdocumentarray=[[NSMutableArray alloc]initWithObjects:[classArray objectAtIndex:i], nil];
//                    NSMutableArray *salesdocumentarray=[[NSMutableArray alloc]init];
//
//                    NSData *pdfData=[MyClass generateInvoiceWithClassInvoiceArray:classdocumentarray SalesInvoiceArray:salesdocumentarray papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
//                    NSString *filename=[MyClass returninvoicenumberwithclassinvoicearray:classdocumentarray salesinvoicearray:salesdocumentarray updateinvoicelog:NO];
//                    NSArray *studentkeys=[[NSArray alloc]initWithObjects:((ClassInvoiceRecord *)[classdocumentarray firstObject]).studentkey, nil];
//
//                    OutboxMessageRecord *object=[[OutboxMessageRecord alloc]init];
//                    object.photoarray=[[NSMutableArray alloc]init];
//                    object.messageenglish=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:documenttype language:@"English"],filename];
//                    object.messagechinese=[NSString stringWithFormat:@"%@%@",[MyClass returntitlewithtitle:documenttype language:@"Chinese"],filename];
//                    object.recipienttype=@"Student";
//                    object.recipientgroup=[[RecipientGroupRecord alloc]init];
//                    object.recipientgroup.individualarray=[[NSMutableArray alloc]initWithArray:studentkeys];
//                    object.messagetype=[NSString stringWithFormat:@"e%@",documenttype];
//
//                    NSURL *interalurl=[MyClass returnInternalURLforNSData:pdfData Filename:[NSString stringWithFormat:@"%@.pdf", object.messageenglish]];
//                    [object.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:nil Width:0 Height:0 FileType:@"pdf" InternalURL:interalurl FileName:[NSString stringWithFormat:@"%@.pdf", object.messageenglish] ThumbnailURL:@""]];
//
//
//
//                    MessagePopoverViewController *viewController = [[MessagePopoverViewController alloc]init];
//                    [viewController sendMessageWithOutBoxMessage:object];
//
//                }
//
//
//                for (int i=0; i<salesArray.count; i++) {
//                    NSMutableArray *classdocumentarray=[[NSMutableArray alloc]init];
//                    NSMutableArray *salesdocumentarray=[[NSMutableArray alloc]initWithObjects:[salesArray objectAtIndex:i], nil];
//
//                    NSData *pdfData=[MyClass generateInvoiceWithClassInvoiceArray:classdocumentarray SalesInvoiceArray:salesdocumentarray papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
//                    NSString *filename=[MyClass returninvoicenumberwithclassinvoicearray:classdocumentarray salesinvoicearray:salesdocumentarray updateinvoicelog:NO];
//                    NSArray *studentkeys=[[NSArray alloc]initWithObjects:((SalesInvoiceRecord *)[salesdocumentarray firstObject]).studentkey, nil];
//
//                    OutboxMessageRecord *object=[[OutboxMessageRecord alloc]init];
//                    object.photoarray=[[NSMutableArray alloc]init];
//                    object.messageenglish=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:documenttype language:@"English"],filename];
//                    object.messagechinese=[NSString stringWithFormat:@"%@%@",[MyClass returntitlewithtitle:documenttype language:@"Chinese"],filename];
//                    object.recipienttype=@"Student";
//                    object.recipientgroup=[[RecipientGroupRecord alloc]init];
//                    object.recipientgroup.individualarray=[[NSMutableArray alloc]initWithArray:studentkeys];
//                    object.messagetype=[NSString stringWithFormat:@"e%@",documenttype];
//
//                    NSURL *interalurl=[MyClass returnInternalURLforNSData:pdfData Filename:[NSString stringWithFormat:@"%@.pdf", object.messageenglish]];
//                    [object.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:nil Width:0 Height:0 FileType:@"pdf" InternalURL:interalurl FileName:[NSString stringWithFormat:@"%@.pdf", object.messageenglish] ThumbnailURL:@""]];
//
//
//                    MessagePopoverViewController *viewController = [[MessagePopoverViewController alloc]init];
//
//                    [viewController sendMessageWithOutBoxMessage:object];
//                }

                [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
                
                UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:documenttype] message:[MyClass returntitlewithtitle:@"Message Sent"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                }];
                
                [missinginput addAction:OKAction];
                [MyClass presentViewController:missinginput View:self];
                });
                
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
                
            }];
            [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
            [alert addAction:OKAction];
            [alert addAction:CancelAction];
            //[self presentViewController:alert animated:YES completion:nil];
                    [MyClass presentViewController:alert View:self];
            
            


        }
    }else{
        /*receipt*/
        if(receipt_combine_leftbutton.tag==1){
            
            //NSData *pdfData=[MyClass generateReceiptWithClassReceiptArray:[self returnCheckedDocumentFolderClassReceiptArray] SalesReceiptArray:[self returnCheckedDocumentFolderSalesReceiptArray] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
            //NSString *filename=[MyClass returnreceiptnumberwithclassreceiptarray:[self returnCheckedDocumentFolderClassReceiptArray] salesreceiptarray:[self returnCheckedDocumentFolderSalesReceiptArray]];
            
            NSMutableArray *classArray=[[NSMutableArray alloc]initWithArray:[self returnCheckedDocumentFolderClassReceiptArray]];
            NSMutableArray *salesArray=[[NSMutableArray alloc]initWithArray:[self returnCheckedDocumentFolderSalesReceiptArray]];
            
            NSArray *studentkeys=[self returnmessagereceiptientwithclassarray:documentfolderclassreceiptarray salesarray:documentfoldersalesreceiptarray type:@"Receipt"];
            
            NSString *alertmessage;
            if (studentkeys.count>1) {
                alertmessage=[MyClass returntitlewithtitle:@"Are you sure to send the COMBINDED document to all parents?"];
            }else{
                alertmessage=[MyClass returntitlewithtitle:@"Are you sure to send the document to parent app?"];
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Message"] message:alertmessage preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    NSMutableArray *documentArray=[[NSMutableArray alloc]init];
                    NSMutableDictionary *dict;
                    
                    for (int i=0; i<classArray.count; i++) {
                        dict=[[NSMutableDictionary alloc]init];
                        ClassReceiptRecord * obj=[classArray objectAtIndex:i];
                        [dict setValue:@"Class" forKey:@"paymenttype"];
                        [dict setValue:@"1" forKey:@"documentkey"];
                        [dict setValue:obj.enrollmentkey forKey:@"paymenttypekey"];
//                        [dict setValue:obj.paymentkey forKey:@"paymentkey"];
                        [documentArray addObject:dict];
                    }
                    
                    for (int i=0; i<salesArray.count; i++) {
                        dict=[[NSMutableDictionary alloc]init];
                        SalesReceiptRecord *obj=[salesArray objectAtIndex:i];
                        [dict setValue:@"Sales" forKey:@"paymenttype"];
                        [dict setValue:@"1" forKey:@"documentkey"];
                        [dict setValue:obj.saleskey forKey:@"paymenttypekey"];
//                        [dict setValue:obj.paymentkey forKey:@"paymentkey"];
                        [documentArray addObject:dict];
                    }
                    
                    [MyClass submitDocumentSendingRequestWithType:@"Receipt" documentArray:documentArray];
                    
                    
                [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
                //[aireceipt stopAnimating];

                
                UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:documenttype] message:[MyClass returntitlewithtitle:@"Message Sent"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {

                }];
                
                [missinginput addAction:OKAction];
                [self presentViewController:missinginput animated:YES completion:nil];
                    //[MyClass presentViewController:missinginput View:self];
                });

            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
                //[aireceipt stopAnimating];
            }];
            
            [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
            [alert addAction:OKAction];
            [alert addAction:CancelAction];
            //[self presentViewController:alert animated:YES completion:nil];
                    [MyClass presentViewController:alert View:self];
            

            
        }else{
            //uncombine, send separately
            NSMutableArray *classArray=[[NSMutableArray alloc]initWithArray:[self returnCheckedDocumentFolderClassReceiptArray]];
            NSMutableArray *salesArray=[[NSMutableArray alloc]initWithArray:[self returnCheckedDocumentFolderSalesReceiptArray]];
            
            
            NSString *alertmessage;
            if (classArray.count+salesArray.count>1) {
                alertmessage=[MyClass returntitlewithtitle:@"Are you sure to send the document to individual parent?"];
            }else{
                alertmessage=[MyClass returntitlewithtitle:@"Are you sure to send the document to parent app?"];
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Message"] message:alertmessage preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    NSMutableArray *documentArray=[[NSMutableArray alloc]init];
                    NSMutableDictionary *dict;
                    
                    int tmpoutboxdocumentkey=1;
                    for (int i=0; i<classArray.count; i++) {
                        dict=[[NSMutableDictionary alloc]init];
                        ClassReceiptRecord *obj=[classArray objectAtIndex:i];
                        [dict setValue:@"Class" forKey:@"paymenttype"];
                        [dict setValue:[@(tmpoutboxdocumentkey) stringValue] forKey:@"documentkey"];
                        [dict setValue:obj.enrollmentkey forKey:@"paymenttypekey"];
//                        [dict setValue:obj.paymentkey forKey:@"paymentkey"];
                        [documentArray addObject:dict];
                        tmpoutboxdocumentkey++;
                    }
                    
                    for (int i=0; i<salesArray.count; i++) {
                        dict=[[NSMutableDictionary alloc]init];
                        SalesReceiptRecord *obj=[salesArray objectAtIndex:i];
                        [dict setValue:@"Sales" forKey:@"paymenttype"];
                        [dict setValue:[@(tmpoutboxdocumentkey) stringValue] forKey:@"documentkey"];
                        [dict setValue:obj.saleskey forKey:@"paymenttypekey"];
//                        [dict setValue:obj.paymentkey forKey:@"paymentkey"];
                        [documentArray addObject:dict];
                        tmpoutboxdocumentkey++;
                    }
                    
                    [MyClass submitDocumentSendingRequestWithType:@"Receipt" documentArray:documentArray];
                    
         
                [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];

                    UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:documenttype] message:[MyClass returntitlewithtitle:@"Message Sent"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    }];
                            
                    [missinginput addAction:OKAction];
                    [self presentViewController:missinginput animated:YES completion:nil];
                    });
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [alert dismissViewControllerAnimated:YES completion:nil];
                //[aireceipt stopAnimating];
            }];
            
            [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
            [alert addAction:OKAction];
            [alert addAction:CancelAction];
            //[self presentViewController:alert animated:YES completion:nil];
                    [MyClass presentViewController:alert View:self];
            
        }
    }
    
    
    

}

-(void) autoSendeReceipt
{
    //uncombine, send separately
    if(globalvariables.centerrecord.autosendereceipt){
        NSMutableArray *classArray=[[NSMutableArray alloc]initWithArray:[self returnCheckedDocumentFolderClassReceiptArray]];
        NSMutableArray *salesArray=[[NSMutableArray alloc]initWithArray:[self returnCheckedDocumentFolderSalesReceiptArray]];
        
        [MyClass autoSendeReceiptWithClassReceiptArray:classArray SalesReceiptArray:salesArray];
    }
}

- (void)emailPDF:(NSData*)pdfData pdftype:(NSString *)pdftype filename:(NSString *) filename receiptient:(NSArray *)receipientarray{
    
    if(receipientarray.count==0){
        UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Email"] message:@"No email address is found" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [successalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [successalert addAction:OKAction];
        //[self presentViewController:successalert animated:YES completion:nil];
        [MyClass presentViewController:successalert View:self];
    }else{
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        
        mail.mailComposeDelegate = self;
        [mail setSubject:[NSString stringWithFormat:@"%@ - %@-%@",globalvariables.centerrecord.centername,pdftype,filename]];
        [mail addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@-%@.pdf",pdftype,filename]];
        [mail setToRecipients:receipientarray];
        //[mail setToRecipients:@[PopoverStudent.parentemail]];
        [mail setMessageBody:[MyClass returntitlewithtitle:@"Please edit your email content"] isHTML:YES];
        
        //[self presentViewController:mail animated:YES completion:nil];
        if (mail) {
            [self presentViewController:mail animated:YES completion:nil];
        }else{
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Email"] message:[MyClass returntitlewithtitle:@"Mail account is not available"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            [self presentViewController:missinginput animated:YES completion:nil];
        }
    }


}



- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    NSString *emailresult;
    switch (result) {
        case MFMailComposeResultSent:
            emailresult=[MyClass returntitlewithtitle:@"Email sent"];
            break;
        case MFMailComposeResultSaved:
            emailresult=[MyClass returntitlewithtitle:@"You saved a draft of this email"];
            break;
        case MFMailComposeResultCancelled:
            emailresult=[MyClass returntitlewithtitle:@"You cancelled sending this email"];
            break;
        case MFMailComposeResultFailed:
            emailresult=[MyClass returntitlewithtitle:@"Mail failed:  An error occurred when trying to compose this email"];
            break;
        default:
            emailresult=[MyClass returntitlewithtitle:@"An error occurred when trying to compose this email"];
            break;
    }

    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Email"]  message:emailresult preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [erroralert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [erroralert addAction:OKAction];
    [self presentViewController:erroralert animated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)printPDF:(NSData*)pdfData button:(UIButton *)button{

    UIPrintInteractionController *printer=[UIPrintInteractionController sharedPrintController];
    UIPrintInfo *info = [UIPrintInfo printInfo];
    info.orientation = UIPrintInfoOrientationPortrait;
    info.outputType = [[MyClass getlocaldbwithparameter:@"defaultprintcolor"] integerValue]==1?UIPrintInfoOutputGrayscale:UIPrintInfoOutputGeneral;
    info.jobName=@"iSchool.pdf";
    info.duplex=UIPrintInfoDuplexLongEdge;
    printer.printInfo = info;
    printer.showsPageRange=YES;
    printer.printingItem=pdfData;
    printer.showsPaperSelectionForLoadedPapers=YES;
    printer.delegate=self;
    
    [printer presentFromRect:button.frame inView:button animated:YES completionHandler:nil];

}



-(void) sharepaymentinvoicewithbutton:(UIButton *)sender
{
    NSData *pdfData = [MyClass generateInvoiceWithClassInvoiceArray:[self returnCheckedDocumentFolderClassInvoiceArray] SalesInvoiceArray:[self returnCheckedDocumentFolderSalesInvoiceArray] papersizeoverride:YES combinedocument:invoice_combine_leftbutton.tag==1?YES:NO centerkey:globalvariables.centerrecord.centerkey];
    
    // Create a filePath for the pdf.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Invoice-%@.pdf",[MyClass returninvoicenumberwithclassinvoicearray:[self returnCheckedDocumentFolderClassInvoiceArray] salesinvoicearray:[self returnCheckedDocumentFolderSalesInvoiceArray] updateinvoicelog:NO]]];
    [pdfData writeToFile:filePath atomically:YES];
    
    // Open the controller.
    documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    documentInteractionController.delegate = self;
    documentInteractionController.UTI = @"com.adobe.pdf";
    [documentInteractionController setName:@"Invoice"];
    
    [documentInteractionController presentOptionsMenuFromRect:sender.bounds inView:sender animated:YES];

}

-(void) sharepaymentreceiptwithbutton:(UIButton *)sender
{
    NSData *pdfData = [MyClass generateReceiptWithClassReceiptArray:[self returnCheckedDocumentFolderClassReceiptArray] SalesReceiptArray:[self returnCheckedDocumentFolderSalesReceiptArray] papersizeoverride:YES combinedocument:receipt_combine_leftbutton.tag==1?YES:NO centerkey:globalvariables.centerrecord.centerkey];
    
    // Create a filePath for the pdf.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Receipt-%@.pdf",[MyClass returnreceiptnumberwithclassreceiptarray:[self returnCheckedDocumentFolderClassReceiptArray] salesreceiptarray:[self returnCheckedDocumentFolderSalesReceiptArray]]]];
    [pdfData writeToFile:filePath atomically:YES];
    
    // Open the controller.
    documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    documentInteractionController.delegate = self;
    documentInteractionController.UTI = @"com.adobe.pdf";
    [documentInteractionController setName:@"Receipt"];
    
    [documentInteractionController presentOptionsMenuFromRect:sender.bounds inView:sender animated:YES];
}
/*
-(void) closedocumentfolderrecords
{
    [self.delegate dismissDocumentFolderPopover];
}*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==paidmethodtable) {
        UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        header.backgroundColor=[UIColor systemGroupedBackgroundColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 32)];
        label.text=[[MyClass returntitlewithtitle:@"Paid Method"] uppercaseString];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor grayColor];
        [header addSubview:label];
        
        return header;
    }else if (tableView==paiddatetable) {
        UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
        header.backgroundColor=[UIColor systemGroupedBackgroundColor];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 32)];
        label.text=[[MyClass returntitlewithtitle:@"Paid Date"] uppercaseString];
        label.font=[UIFont systemFontOfSize:13];
        label.textColor=[UIColor grayColor];
        [header addSubview:label];
        
        return header;
    }else if (tableView==DiscountTable) {
        
        BOOL isLocked=FALSE;
        BOOL isPaid=FALSE;
        
        if (selectedbuttoncoordinate.x==0) {
            ClassPaymentRecord *obj=[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y];
            isPaid=[obj.outstandingamount floatValue]!=[obj.totalfee floatValue];
            isLocked=obj.enrollmentrecord.locked;
        }else{
            SalesPaymentRecord *obj=[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y];
            isPaid=[obj.outstandingamount floatValue]!=[obj.totalfee floatValue];
        }
        
        if (section==0) {
            if (availablepromotionarray.count>0) {
                UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
                header.backgroundColor=[UIColor systemGroupedBackgroundColor];
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
                label.text=[[MyClass returntitlewithtitle:@"Promotion Discount"] uppercaseString];
                label.font=[UIFont systemFontOfSize:13];
                label.textColor=[UIColor grayColor];
                [header addSubview:label];
                
                UIButton *showpromotioncodebutton=[[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width-28,22, 28, 20)];
                [showpromotioncodebutton setImageEdgeInsets:UIEdgeInsetsMake(2.5, 6.5, 2.5, 6.5)];
                [showpromotioncodebutton setImage:[UIImage imageNamed:@"addphonebutton.png"] forState:UIControlStateNormal];
                [showpromotioncodebutton addTarget:self action:@selector(showpromotioncode) forControlEvents:UIControlEventTouchUpInside];
                if (!(!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscount || (!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscountifpaid && isPaid) || isLocked)) {
                    [header addSubview:showpromotioncodebutton];
                }
                return header;
            }
        }else if (section==2) {
            if (availablecouponarray.count>0) {
                UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
                header.backgroundColor=[UIColor systemGroupedBackgroundColor];
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
                label.text=[[MyClass returntitlewithtitle:@"Coupon"] uppercaseString];
                label.font=[UIFont systemFontOfSize:13];
                label.textColor=[UIColor grayColor];
                [header addSubview:label];
                
                if(((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).applycoupon){
                    UIButton *showpromotioncodebutton=[[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width-28,22, 28, 20)];
                    [showpromotioncodebutton setImageEdgeInsets:UIEdgeInsetsMake(2.5, 6.5, 2.5, 6.5)];
                    [showpromotioncodebutton setImage:[UIImage imageNamed:@"addphonebutton.png"] forState:UIControlStateNormal];
                    [showpromotioncodebutton addTarget:self action:@selector(showavailablecoupon) forControlEvents:UIControlEventTouchUpInside];
                    [header addSubview:showpromotioncodebutton];
                }
                
                return header;
            }
        }
    }
    return nil;
}

-(void) paybuttonpressed:(UIButton *)sender
{

    sender.enabled=FALSE;
    [self.view endEditing:YES];
    [self openSideWindowWithTable:@"none"];
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    
    
    
    if (![self isPaymentSelected]){
        UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Payments"] message:[MyClass returntitlewithtitle:@"Please select payment"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missinginput dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missinginput addAction:OKAction];
        //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
        sender.enabled=TRUE;
        
    }else if (![self isPaidMethodSelected]) {
        UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Payments"] message:[MyClass returntitlewithtitle:@"Please choose the paid method for the selected payments"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missinginput dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missinginput addAction:OKAction];
        //[self presentViewController:missinginput animated:YES completion:nil];
                    [MyClass presentViewController:missinginput View:self];
        sender.enabled=TRUE;
    }else{
        UIAlertController *confirmalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Payments"] message:[MyClass returntitlewithtitle:@"Are you sure to pay the selected payments?"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            //aipayment.center=sender.center;
            //[aipayment startAnimating];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self payMultiplePayments];
                //[self autoSendeReceipt];
                [MyClass loadingindicatorwithoption:@"stop" color:@"lightgray"];
                sender.enabled=TRUE;
            });
        }];
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [confirmalert dismissViewControllerAnimated:YES completion:nil];
            sender.enabled=TRUE;
        }];
        
        [confirmalert addAction:OKAction];
        [confirmalert addAction:CancelAction];
        
        //[self presentViewController:confirmalert animated:YES completion:nil];
        [MyClass presentViewController:confirmalert View:self];
    }
    
    
    

}



-(BOOL) isPaymentSelected
{
    if ([payment_selectedcountlabel.text intValue]>0) {
        return TRUE;
    }else{
        return FALSE;
    }
}

-(BOOL) isInvoiceSelected
{
    if ([invoice_selectedcountlabel.text intValue]>0) {
        return TRUE;
    }else{
        return FALSE;
    }
}

-(BOOL) isReceiptSelected
{
    if ([receipt_selectedcountlabel.text intValue]>0) {
        return TRUE;
    }else{
        return FALSE;
    }
    
}


-(BOOL) isPaidMethodSelected
{
    for (int i=0; i<documentfolderclasspaymentarray.count; i++) {
        if ([((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
            if ([((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:i]).paidmethod isEqualToString:@""]) {
                return FALSE;
            }
        }
    }
    
    for (int i=0; i<documentfoldersalespaymentarray.count; i++) {
        if ([((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
            if ([((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:i]).paidmethod isEqualToString:@""]) {
                return FALSE;
            }
        }

    }
    
    return TRUE;
    
}


-(BOOL) payMultiplePayments
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSArray *jsonpaymentarray=[[NSArray alloc]init];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    //generate json payment array
    if (documentfolderclasspaymentarray.count>0 || documentfoldersalespaymentarray.count>0) {
        
        [dictionary setValue:@"paymultiplepayments5" forKey:@"postaction"];
        [dictionary setValue:globalvariables.username forKey:@"updatedby"];
        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
        [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        
        arrayOfDicts = [[NSMutableArray alloc] init];
        for (long i=0; i<documentfolderclasspaymentarray.count; i++) {
            NSMutableDictionary *paymentdictionary=[[NSMutableDictionary alloc]init];
            classpaymentrecordobject=[documentfolderclasspaymentarray objectAtIndex:i];
            if ([classpaymentrecordobject.paidamount floatValue]!=0) {
                if ([classpaymentrecordobject.checkstatus isEqualToString:@"checked"]) {
                    [paymentdictionary setValue:classpaymentrecordobject.enrollmentkey forKey:@"paymenttypekey"];
                    [paymentdictionary setValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:classpaymentrecordobject.paiddate] forKey:@"paiddate"];
                    [paymentdictionary setValue:classpaymentrecordobject.paidamount forKey:@"paidamount"];
                    [paymentdictionary setValue:classpaymentrecordobject.paidmethod forKey:@"paidmethod"];
                    [paymentdictionary setValue:@"Class" forKey:@"paymenttype"];
                    [paymentdictionary setValue:classpaymentrecordobject.paymentremarks forKey:@"paymentremarks"];
                    [paymentdictionary setValue:classpaymentrecordobject.receiptremarks forKey:@"receiptremarks"];
                    [paymentdictionary setValue:[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"] forKey:@"staffname"];
                    [paymentdictionary setValue:[MyClass returndefaultarckey] forKey:@"arckey"];
                    [paymentdictionary setValue:classpaymentrecordobject.studentkey forKey:@"studentkey"];
                    
                    if ([self checkStatusExistsWithStatus:classpaymentrecordobject.enrollmentrecord.status value:@"discount"]) {
                        [paymentdictionary setValue:classpaymentrecordobject.enrollmentrecord.oneoffdiscount forKey:@"oneoffdiscount"];
                        [paymentdictionary setValue:classpaymentrecordobject.enrollmentrecord.oneoffpercentagediscount forKey:@"oneoffpercentagediscount"];
                    }
                    
                    if ([self checkStatusExistsWithStatus:classpaymentrecordobject.enrollmentrecord.status value:@"promotion"]) {
                        NSMutableArray *arrayofMarketingdicts=[[NSMutableArray alloc]init];
                        for (int p=0; p<classpaymentrecordobject.enrollmentrecord.promotiondiscountrecords.count; p++) {
                            MarketingRecord *obj=[classpaymentrecordobject.enrollmentrecord.promotiondiscountrecords objectAtIndex:p];
                            NSMutableDictionary *marketingkeydict=[[NSMutableDictionary alloc]init];
                            [marketingkeydict setValue:obj.marketingkey forKey:@"marketingkey"];
                            [marketingkeydict setValue:obj.recursive forKey:@"recursive"];
                            [arrayofMarketingdicts addObject:marketingkeydict];
                        }
                        
                        NSArray *jsonmarketingarray=[NSArray arrayWithArray:arrayofMarketingdicts];
                        [paymentdictionary setValue:jsonmarketingarray forKey:@"marketingkeys"];
                    }
                    
                    if ([self checkStatusExistsWithStatus:classpaymentrecordobject.enrollmentrecord.status value:@"coupon"]) {
                        NSMutableArray *arrayofCoupondicts=[[NSMutableArray alloc]init];
                        for (int p=0; p<classpaymentrecordobject.enrollmentrecord.couponrecords.count; p++) {
                            CouponRecord *obj=[classpaymentrecordobject.enrollmentrecord.couponrecords objectAtIndex:p];
                            NSMutableDictionary *couponkeydict=[[NSMutableDictionary alloc]init];
                            [couponkeydict setValue:obj.couponkey forKey:@"couponkey"];
                            [arrayofCoupondicts addObject:couponkeydict];
                        }
                        
                        NSArray *jsonmarketingarray=[NSArray arrayWithArray:arrayofCoupondicts];
                        [paymentdictionary setValue:jsonmarketingarray forKey:@"couponkeys"];
                    }
                    
                    if (classpaymentrecordobject.enrollmentrecord.status) {
                        [paymentdictionary setValue:classpaymentrecordobject.totalfee forKey:@"totalfee"];
                    }
                    
                    [arrayOfDicts addObject:paymentdictionary];
                    if ([classpaymentrecordobject.outstandingamount floatValue]== [classpaymentrecordobject.paidamount floatValue]) {
                        [globalvariables.documentfolder.classpaymentarray removeObject:classpaymentrecordobject.enrollmentkey];
                    }
                }
            }
        }
        
        for (long i=0; i<documentfoldersalespaymentarray.count; i++) {
            NSMutableDictionary *paymentdictionary=[[NSMutableDictionary alloc]init];
            salespaymentrecordobject=[documentfoldersalespaymentarray objectAtIndex:i];
            if ([salespaymentrecordobject.paidamount floatValue]!=0) {
                if ([salespaymentrecordobject.checkstatus isEqualToString:@"checked"]) {
                    [paymentdictionary setValue:salespaymentrecordobject.saleskey forKey:@"paymenttypekey"];
                    [paymentdictionary setValue:[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:salespaymentrecordobject.paiddate] forKey:@"paiddate"];
                    [paymentdictionary setValue:salespaymentrecordobject.paidamount forKey:@"paidamount"];
                    [paymentdictionary setValue:salespaymentrecordobject.paidmethod forKey:@"paidmethod"];
                    [paymentdictionary setValue:@"Sales" forKey:@"paymenttype"];
                    [paymentdictionary setValue:salespaymentrecordobject.paymentremarks forKey:@"paymentremarks"];
                    [paymentdictionary setValue:salespaymentrecordobject.receiptremarks forKey:@"receiptremarks"];
                    [paymentdictionary setValue:[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"] forKey:@"staffname"];
                    [paymentdictionary setValue:[MyClass returndefaultarckey] forKey:@"arckey"];
                    [paymentdictionary setValue:salespaymentrecordobject.studentkey forKey:@"studentkey"];

                    if ([self checkStatusExistsWithStatus:salespaymentrecordobject.salesrecord.status value:@"discount"]) {
                        [paymentdictionary setValue:salespaymentrecordobject.salesrecord.oneoffdiscount forKey:@"oneoffdiscount"];
                        [paymentdictionary setValue:salespaymentrecordobject.salesrecord.oneoffpercentagediscount forKey:@"oneoffpercentagediscount"];
                    }
                    
                    if ([self checkStatusExistsWithStatus:salespaymentrecordobject.salesrecord.status value:@"promotion"]) {
                        NSMutableArray *arrayofMarketingdicts=[[NSMutableArray alloc]init];
                        for (int p=0; p<salespaymentrecordobject.salesrecord.promotiondiscountrecords.count; p++) {
                            MarketingRecord *obj=[salespaymentrecordobject.salesrecord.promotiondiscountrecords objectAtIndex:p];
                            NSMutableDictionary *marketingkeydict=[[NSMutableDictionary alloc]init];
                            [marketingkeydict setValue:obj.marketingkey forKey:@"marketingkey"];
                            [marketingkeydict setValue:obj.recursive forKey:@"recursive"];
                            [arrayofMarketingdicts addObject:marketingkeydict];
                        }
                        NSArray *jsonmarketingarray=[NSArray arrayWithArray:arrayofMarketingdicts];
                        [paymentdictionary setValue:jsonmarketingarray forKey:@"marketingkeys"];
                    }
                    
                    if ([self checkStatusExistsWithStatus:salespaymentrecordobject.salesrecord.status value:@"coupon"]) {
                        NSMutableArray *arrayofCoupondicts=[[NSMutableArray alloc]init];
                        for (int p=0; p<salespaymentrecordobject.salesrecord.couponrecords.count; p++) {
                            CouponRecord *obj=[salespaymentrecordobject.salesrecord.couponrecords objectAtIndex:p];
                            NSMutableDictionary *couponkeydict=[[NSMutableDictionary alloc]init];
                            [couponkeydict setValue:obj.couponkey forKey:@"couponkey"];
                            [arrayofCoupondicts addObject:couponkeydict];
                        }
                        
                        NSArray *jsonmarketingarray=[NSArray arrayWithArray:arrayofCoupondicts];
                        [paymentdictionary setValue:jsonmarketingarray forKey:@"couponkeys"];
                    }
                    
                    if(salespaymentrecordobject.salesrecord.status){
                        [paymentdictionary setValue:salespaymentrecordobject.totalfee forKey:@"totalfee"];
                    }
                    
                    [arrayOfDicts addObject:paymentdictionary];
                    if ([salespaymentrecordobject.outstandingamount floatValue]== [salespaymentrecordobject.paidamount floatValue]) {
                        [globalvariables.documentfolder.salespaymentarray removeObject:salespaymentrecordobject.saleskey];
                    }
                }
            }
        }
        jsonpaymentarray = [NSArray arrayWithArray:arrayOfDicts];
        [dictionary setValue:jsonpaymentarray forKey:@"paymentarray"];
    }

    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSDictionary *jsondictionary = jsonreturned[@"content"];
            NSArray *jsonenrollmentkeysarray = jsondictionary[@"receiptenrollmentkeys"];
            NSArray *jsonsaleskeysarray = jsondictionary[@"receiptsaleskeys"];

            if (jsonenrollmentkeysarray.count+jsonsaleskeysarray.count>0) {
                globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys=[[NSMutableArray alloc]init];
                globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys=[[NSMutableArray alloc]init];
                  
                  for (int i=0; i<jsonenrollmentkeysarray.count; i++) {
                      NSString *enrollmentkey=[NSString stringWithFormat:@"%@",[jsonenrollmentkeysarray objectAtIndex:i]];
                      if (![globalvariables.documentfolder.classreceiptarray containsObject:enrollmentkey]) {
                          [globalvariables.documentfolder.classreceiptarray addObject:enrollmentkey];
                      }
                      if (![globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:enrollmentkey]) {
                          [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys addObject:enrollmentkey];
                      }
                      
                      
                  }
                  
                  for (int i=0; i<jsonsaleskeysarray.count; i++) {
                      NSString *saleskey=[NSString stringWithFormat:@"%@",[jsonsaleskeysarray objectAtIndex:i]];
                      if (![globalvariables.documentfolder.salesreceiptarray containsObject:saleskey]) {
                          [globalvariables.documentfolder.salesreceiptarray addObject:saleskey];
                      }
                      if (![globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:saleskey]) {
                          [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys addObject:saleskey];
                      }
                  }
                result=YES;
            }else{
                result= NO;
            }
        }
    }];

    
    
    if (result) {
        [self loaddocumentfolderarray];
        
        if(globalvariables.centerrecord.autosendereceipt){
            [self.delegate dismissDocumentFolderPopover];
            //[self autoSendeReceipt];
            [self.delegate refreshDocumentFolderPresentingViewScreen];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        }else{
            [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
            [self menubuttonpressed:receiptbutton];

            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.delegate refreshDocumentFolderPresentingViewScreen];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }
    }else{
        [self menubuttonpressed:paymentbutton];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Multiple Payments"] message:[MyClass returntitlewithtitle:@"Payment is not processed"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:OKAction];
        [MyClass presentViewController:alert View:self];
    }
    
    return result;
}



-(BOOL) updateDocumentDiscount
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSArray *jsondiscountarray=[[NSArray alloc]init];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    //generate json payment array
    if (documentfolderclasspaymentarray.count>0 || documentfoldersalespaymentarray.count>0) {
        
        [dictionary setValue:@"updatedocumentdiscount" forKey:@"postaction"];
        [dictionary setValue:globalvariables.username forKey:@"updatedby"];
        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
        [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        
        arrayOfDicts = [[NSMutableArray alloc] init];
        for (long i=0; i<documentfolderclasspaymentarray.count; i++) {
            NSMutableDictionary *discountdictionary=[[NSMutableDictionary alloc]init];
            classpaymentrecordobject=[documentfolderclasspaymentarray objectAtIndex:i];
            if (classpaymentrecordobject.enrollmentrecord.status) {
                    [discountdictionary setValue:classpaymentrecordobject.enrollmentkey forKey:@"paymenttypekey"];
                    [discountdictionary setValue:@"Class" forKey:@"paymenttype"];
                    [discountdictionary setValue:[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"] forKey:@"staffname"];

                    if ([self checkStatusExistsWithStatus:classpaymentrecordobject.enrollmentrecord.status value:@"discount"]) {
                        [discountdictionary setValue:classpaymentrecordobject.enrollmentrecord.oneoffdiscount forKey:@"oneoffdiscount"];
                        [discountdictionary setValue:classpaymentrecordobject.enrollmentrecord.oneoffpercentagediscount forKey:@"oneoffpercentagediscount"];
                    }
                    
                    if ([self checkStatusExistsWithStatus:classpaymentrecordobject.enrollmentrecord.status value:@"promotion"]) {
                        NSMutableArray *arrayofMarketingdicts=[[NSMutableArray alloc]init];
                        for (int p=0; p<classpaymentrecordobject.enrollmentrecord.promotiondiscountrecords.count; p++) {
                            MarketingRecord *obj=[classpaymentrecordobject.enrollmentrecord.promotiondiscountrecords objectAtIndex:p];
                            NSMutableDictionary *marketingkeydict=[[NSMutableDictionary alloc]init];
                            [marketingkeydict setValue:obj.marketingkey forKey:@"marketingkey"];
                            [marketingkeydict setValue:obj.recursive forKey:@"recursive"];
                            [arrayofMarketingdicts addObject:marketingkeydict];
                        }
                        
                        NSArray *jsonmarketingarray=[NSArray arrayWithArray:arrayofMarketingdicts];
                        [discountdictionary setValue:jsonmarketingarray forKey:@"marketingkeys"];
                    }
                
                if ([self checkStatusExistsWithStatus:classpaymentrecordobject.enrollmentrecord.status value:@"coupon"]) {
                    NSMutableArray *arrayofCoupondicts=[[NSMutableArray alloc]init];
                    for (int p=0; p<classpaymentrecordobject.enrollmentrecord.couponrecords.count; p++) {
                        CouponRecord *obj=[classpaymentrecordobject.enrollmentrecord.couponrecords objectAtIndex:p];
                        NSMutableDictionary *coupondict=[[NSMutableDictionary alloc]init];
                        [coupondict setValue:obj.couponkey forKey:@"couponkey"];
                        [arrayofCoupondicts addObject:coupondict];
                    }
                    
                    NSArray *jsoncouponarray=[NSArray arrayWithArray:arrayofCoupondicts];
                    [discountdictionary setValue:jsoncouponarray forKey:@"couponkeys"];
                }
                
                        [discountdictionary setValue:classpaymentrecordobject.totalfee forKey:@"totalfee"];
                    
                    [arrayOfDicts addObject:discountdictionary];

            }
        }
        
        for (long i=0; i<documentfoldersalespaymentarray.count; i++) {
            NSMutableDictionary *discountdictionary=[[NSMutableDictionary alloc]init];
            salespaymentrecordobject=[documentfoldersalespaymentarray objectAtIndex:i];
            if (salespaymentrecordobject.salesrecord.status) {
                    [discountdictionary setValue:salespaymentrecordobject.saleskey forKey:@"paymenttypekey"];
                    [discountdictionary setValue:@"Sales" forKey:@"paymenttype"];
                    [discountdictionary setValue:[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"] forKey:@"staffname"];

                if ([self checkStatusExistsWithStatus:salespaymentrecordobject.salesrecord.status value:@"discount"]) {
                        [discountdictionary setValue:salespaymentrecordobject.salesrecord.oneoffdiscount forKey:@"oneoffdiscount"];
                        [discountdictionary setValue:salespaymentrecordobject.salesrecord.oneoffpercentagediscount forKey:@"oneoffpercentagediscount"];
                    }
                    
                if ([self checkStatusExistsWithStatus:salespaymentrecordobject.salesrecord.status value:@"promotion"]) {
                        NSMutableArray *arrayofMarketingdicts=[[NSMutableArray alloc]init];
                        for (int p=0; p<salespaymentrecordobject.salesrecord.promotiondiscountrecords.count; p++) {
                            MarketingRecord *obj=[salespaymentrecordobject.salesrecord.promotiondiscountrecords objectAtIndex:p];
                            NSMutableDictionary *marketingkeydict=[[NSMutableDictionary alloc]init];
                            [marketingkeydict setValue:obj.marketingkey forKey:@"marketingkey"];
                            [marketingkeydict setValue:obj.recursive forKey:@"recursive"];
                            [arrayofMarketingdicts addObject:marketingkeydict];
                        }
                        NSArray *jsonmarketingarray=[NSArray arrayWithArray:arrayofMarketingdicts];
                        [discountdictionary setValue:jsonmarketingarray forKey:@"marketingkeys"];
                    }
                
                if ([self checkStatusExistsWithStatus:salespaymentrecordobject.salesrecord.status value:@"coupon"]) {
                    NSMutableArray *arrayofCoupondicts=[[NSMutableArray alloc]init];
                    for (int p=0; p<salespaymentrecordobject.salesrecord.couponrecords.count; p++) {
                        CouponRecord *obj=[salespaymentrecordobject.salesrecord.couponrecords objectAtIndex:p];
                        NSMutableDictionary *coupondict=[[NSMutableDictionary alloc]init];
                        [coupondict setValue:obj.couponkey forKey:@"couponkey"];
                        [arrayofCoupondicts addObject:coupondict];
                    }
                    
                    NSArray *jsoncouponarray=[NSArray arrayWithArray:arrayofCoupondicts];
                    [discountdictionary setValue:jsoncouponarray forKey:@"couponkeys"];
                }
                    
                        [discountdictionary setValue:salespaymentrecordobject.totalfee forKey:@"totalfee"];
                    
                    [arrayOfDicts addObject:discountdictionary];
            }
        }
        jsondiscountarray = [NSArray arrayWithArray:arrayOfDicts];
        [dictionary setValue:jsondiscountarray forKey:@"discountarray"];
    }

    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=YES;
        }
    }];

    
    
    if (result) {
        [self loaddocumentfolderarray];
        [self openSideWindowWithTable:@"none"];
        [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
        [self.delegate refreshDocumentFolderPresentingViewScreen];
    }
    
    return result;
}

-(void) refreshInvoiceSelectedPaymentCount
{
    long count=0;
    for (int i=0; i<documentfolderclassinvoicearray.count; i++) {
        if ([((ClassInvoiceRecord *)[documentfolderclassinvoicearray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
            count+=1;
        }
    }

    for (int i=0; i<documentfoldersalesinvoicearray.count; i++) {
        if ([((SalesInvoiceRecord *)[documentfoldersalesinvoicearray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
            count+=1;
        }
    }
    //if (count==0) {
    //    invoice_selectedcountimage.hidden=YES;
    //}else{
        //invoice_selectedcountimage.hidden=NO;
        invoice_selectedcountlabel.text=[NSString stringWithFormat:@"%ld",count];
    //}
    
}

-(void) refreshReceiptSelectedPaymentCount
{
    long count=0;
    for (int i=0; i<documentfolderclassreceiptarray.count; i++) {
        if ([((ClassReceiptRecord *)[documentfolderclassreceiptarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
            count+=1;
        }
    }
    
    for (int i=0; i<documentfoldersalesreceiptarray.count; i++) {
        if ([((SalesReceiptRecord *)[documentfoldersalesreceiptarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
            count+=1;
        }
    }
    //if (count==0) {
    //    receipt_selectedcountimage.hidden=YES;
    //}else{
        //receipt_selectedcountimage.hidden=NO;
        receipt_selectedcountlabel.text=[NSString stringWithFormat:@"%ld",count];
    //}
    
}

-(void) refreshPaymentSelectedPaymentCount
{
    long count=0;
    for (int i=0; i<documentfolderclasspaymentarray.count; i++) {
        if ([((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
            count+=1;
        }
    }
    
    for (int i=0; i<documentfoldersalespaymentarray.count; i++) {
        if ([((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:i]).checkstatus isEqualToString:@"checked"]) {
            count+=1;
        }
    }
    //if (count==0) {
    //    payment_selectedcountimage.hidden=YES;
    //}else{
    //    payment_selectedcountimage.hidden=NO;
        payment_selectedcountlabel.text=[NSString stringWithFormat:@"%ld",count];
    //}
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyClass returntitlewithtitle:@"Delete"];
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    
    NSString *selecteddatestring=[selecteddatearray firstObject];
    
    if (selectedbuttoncoordinate.x==0) {
        ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paiddate=selecteddatestring;
        if([((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paidamount floatValue]!=0){
            ((ClassPaymentRecord *)[documentfolderclasspaymentarray objectAtIndex:selectedbuttoncoordinate.y]).checkstatus=@"checked";
        }
    }else{
        ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paiddate=selecteddatestring;
        if([((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).paidamount floatValue]!=0){
            ((SalesPaymentRecord *)[documentfoldersalespaymentarray objectAtIndex:selectedbuttoncoordinate.y]).checkstatus=@"checked";
        }
    }
    [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
    [self refreshPaymentSelectedPaymentCount];
    [self openSideWindowWithTable:@"none"];
    [paymenttable reloadData];
    

}

-(void) closesidewindow
{
    [self adjustpresentingviewwidthwithwidth:0];
    
    if (!invoiceview.hidden) {
        [invoicetable deselectRowAtIndexPath:[invoicetable indexPathForSelectedRow] animated:YES];
    }else if (!receiptview.hidden){
        [receipttable deselectRowAtIndexPath:[receipttable indexPathForSelectedRow] animated:YES];
    }else{
        [paymenttable deselectRowAtIndexPath:[paymenttable indexPathForSelectedRow] animated:YES];
    }
    
    
    
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
        sidewindowview.frame=CGRectMake(mainWindow.bounds.size.width-width, sidewindowview.frame.origin.y, width, sidewindowview.frame.size.height);
        if (width==0 && sidewindowview.frame.origin.x< mainWindow.bounds.size.width) {
            [MyClass playsoundwithoption:@"close"];
        }
    } completion:^(BOOL finished){
        if (width==0) {
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

- (void)dismissMessagePopoverVC {
    //not used
}




-(void) refreshparentviewdocumentfoldercount
{
    /*[self loaddocumentfolderarray];
     if (!invoiceview.hidden) {
     [invoicetable reloadData];
     }else if (!receiptview.hidden){
     [receipttable reloadData];
     }else{
     [paymenttable reloadData];
     [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
     }
     
     [self adjusttablesize];*/
    [self.delegate refreshdocumentfoldercount];
    
    
}

-(void) updateCategoryCount
{
    // not used
}

-(void) gobackStudentCategory
{
    //not used
}

-(void) enableAddStudentButton
{
    //not used
}

-(void) disableAddStudentButton
{
    //not used
}

-(void) refreshstudentdetailviewpresentingviewcontent
{
    //refresh information
    [self loaddocumentfolderarray];
    if (!invoiceview.hidden) {
        [invoicetable reloadData];
    }else if (!receiptview.hidden){
        [receipttable reloadData];
    }else{
        [paymenttable reloadData];
        [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
    [self.delegate refreshDocumentFolderPresentingViewScreen];
    });
}

-(void) updatestudentinformationlist:(NSString *)studentkey reloadlist:(BOOL)reload
{
    //not used
}

-(void) gotostudentprofile:(NSString *)studentkey
{
    //not used
}

-(void) updateRemarksWithType:(NSString *)type TypeKey:(NSString *)typekey Remarks:(NSString *)remarks
{
    __block BOOL result=FALSE;
    NSDictionary *dictionary = @{@"postaction" : @"updateinvoiceremarks",
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"type"  : type,
                                 @"typekey" : typekey,
                                 @"remarks" : remarks};
    
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if(result){
        [self.delegate refreshDocumentFolderPresentingViewScreen];
    }
}

-(void) updateReceiptRemarksWithPaymentkey:(NSString *)paymentkey Remarks:(NSString *)remarks
{
    __block BOOL result=FALSE;
    NSDictionary *dictionary = @{@"postaction" : @"updatereceiptremarks",
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"paymentkey"  : paymentkey,
                                 @"receiptremarks" : remarks};
    
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if(result){
        [self.delegate refreshDocumentFolderPresentingViewScreen];
    }
}

-(void) updatePaymentRemarksWithPaymentkey:(NSString *)paymentkey Remarks:(NSString *)remarks
{
    __block BOOL result=FALSE;
    NSDictionary *dictionary = @{@"postaction" : @"updatepaymentremarks",
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"paymentkey"  : paymentkey,
                                 @"paymentremarks" : remarks};
    
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if(result){
        [self.delegate refreshDocumentFolderPresentingViewScreen];
    }
}

-(void) updateAmountWithDiscountWithMarketingRecord:(MarketingRecord *)sourceobject
{

    for (int i=0; i<documentfolderclasspaymentarray.count; i++) {
        ClassPaymentRecord *classpaymentobject=[documentfolderclasspaymentarray objectAtIndex:i];
        if ([classpaymentobject.checkstatus isEqualToString:@"checked"]) {
            MarketingRecord *destobject=[[MarketingRecord alloc]initMarketingRecordWithcenterkey:sourceobject.centerkey marketingkey:sourceobject.marketingkey category:sourceobject.category description:sourceobject.description description_chinese:sourceobject.description_chinese startdate:sourceobject.startdate enddate:sourceobject.enddate remarks:sourceobject.remarks promotionfixeddiscount:sourceobject.promotionfixeddiscount promotionpercentagediscount:sourceobject.promotionpercentagediscount usedcount:sourceobject.usedcount promotionquota:sourceobject.promotionquota code:sourceobject.code recursive:sourceobject.recursive effectivefrom:sourceobject.effectivefrom effectiveto:sourceobject.effectiveto subcategory:sourceobject.subcategory redeemable:NO redeempoint:nil perstudentquota:nil cannotuseconjunctionwithothercoupons:sourceobject.cannotuseconjunctionwithothercoupons subjectarray:nil productarray:nil couponallowcredit:nil perclassorquantity:sourceobject.perclassorquantity earlybirdlastdate:sourceobject.earlybirdlastdate buymorepayless:sourceobject.buymorepayless estartdate:sourceobject.estartdate eenddate:sourceobject.eenddate enablebuymorepayless:sourceobject.enablebuymorepayless minnoofclass:sourceobject.minnoofclass bmsmacrossothersubjects:sourceobject.bmsmacrossothersubjects bmsmminsubjectno:0 bmsmminnoofclasspersubject:0 bmsmsamebillmonth:NO manualapply:sourceobject.manualapply];
            [classpaymentobject.enrollmentrecord.promotiondiscountrecords addObject:destobject];
            classpaymentobject.enrollmentrecord.status=[self returnStatusWithStatus:classpaymentobject.enrollmentrecord.status Update:@"promotion"];
            [self updateEnrollmentTotalFeeWithClassPaymentobject:classpaymentobject];
        }
    }

    for (int i=0; i<documentfoldersalespaymentarray.count; i++) {
        SalesPaymentRecord *salespaymentobject=[documentfoldersalespaymentarray objectAtIndex:i];
        if ([salespaymentobject.checkstatus isEqualToString:@"checked"]) {
            MarketingRecord *destobject=[[MarketingRecord alloc]initMarketingRecordWithcenterkey:sourceobject.centerkey marketingkey:sourceobject.marketingkey category:sourceobject.category description:sourceobject.description description_chinese:sourceobject.description_chinese startdate:sourceobject.startdate enddate:sourceobject.enddate remarks:sourceobject.remarks promotionfixeddiscount:sourceobject.promotionfixeddiscount promotionpercentagediscount:sourceobject.promotionpercentagediscount usedcount:sourceobject.usedcount promotionquota:sourceobject.promotionquota code:sourceobject.code recursive:sourceobject.recursive effectivefrom:sourceobject.effectivefrom effectiveto:sourceobject.effectiveto subcategory:sourceobject.subcategory redeemable:NO redeempoint:nil perstudentquota:nil cannotuseconjunctionwithothercoupons:sourceobject.cannotuseconjunctionwithothercoupons subjectarray:nil productarray:nil couponallowcredit:nil perclassorquantity:sourceobject.perclassorquantity earlybirdlastdate:sourceobject.earlybirdlastdate buymorepayless:sourceobject.buymorepayless estartdate:sourceobject.estartdate eenddate:sourceobject.eenddate enablebuymorepayless:sourceobject.enablebuymorepayless minnoofclass:sourceobject.minnoofclass bmsmacrossothersubjects:sourceobject.bmsmacrossothersubjects bmsmminsubjectno:0 bmsmminnoofclasspersubject:0 bmsmsamebillmonth:NO manualapply:sourceobject.manualapply];
            [salespaymentobject.salesrecord.promotiondiscountrecords addObject:destobject];
            salespaymentobject.salesrecord.status=[self returnStatusWithStatus:salespaymentobject.salesrecord.status Update:@"promotion"];
            [self updateSalesTotalFeeWithSalesPaymentobject:salespaymentobject];
        }
    }
    
    [paymenttable reloadData];
    [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
}

-(void) updateEnrollmentTotalFeeWithClassPaymentobject:(ClassPaymentRecord *)classpaymentobject
{
    NSString *totalfee;
    NSString *outstanding;
    
    float discountedfee=[classpaymentobject.tuitionfee floatValue];
    float totalpaid = [classpaymentobject.enrollmentrecord.paid floatValue];
//    float coupondiscount=0;
    
    for (int i=0; i<classpaymentobject.enrollmentrecord.promotiondiscountrecords.count; i++) {
        MarketingRecord *marketingobject=[classpaymentobject.enrollmentrecord.promotiondiscountrecords objectAtIndex:i];
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[classpaymentobject.noofclass integerValue]);
        }else{
            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
        }
    }
    
    discountedfee*=(1-[classpaymentobject.enrollmentrecord.oneoffpercentagediscount floatValue]/100);
    discountedfee-=[classpaymentobject.enrollmentrecord.oneoffdiscount floatValue];
    
    if(classpaymentobject.enrollmentrecord.couponrecords.count>0){
        discountedfee+=[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue];
        if(discountedfee>totalpaid){
            discountedfee-=totalpaid;
            for (int i=0; i<classpaymentobject.enrollmentrecord.couponrecords.count; i++) {
                CouponRecord *obj=[classpaymentobject.enrollmentrecord.couponrecords objectAtIndex:i];
                MarketingRecord *marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
//                if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
                    discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
//                    coupondiscount+=[marketingobject.promotionfixeddiscount floatValue];
                    if(discountedfee<0){
                        discountedfee=0;
                    }
//                }else{
//                    discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
//                }
            }
            discountedfee+=totalpaid;
        }
    }
    
//    if(totalpaid>0 && totalpaid<coupondiscount){
//        discountedfee+=totalpaid;
//    }
    
    formatter.numberStyle = NSNumberFormatterNoStyle;// kCFNumberFormatterNoStyle;
    totalfee=[formatter stringFromNumber:[NSNumber numberWithFloat:(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee)+[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue]]];
    outstanding=[formatter stringFromNumber:[NSNumber numberWithFloat:((globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee)+[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue]-[classpaymentobject.enrollmentrecord.paid floatValue])]];

    classpaymentobject.totalfee=totalfee;
    classpaymentobject.enrollmentrecord.totalfee=totalfee;
    classpaymentobject.outstandingamount=outstanding;
    classpaymentobject.paidamount=outstanding;
    
}

-(void) updateSalesTotalFeeWithSalesPaymentobject:(SalesPaymentRecord *)salespaymentobject
{
    NSString *totalfee;
    NSString *outstanding;
    
    float discountedfee=[salespaymentobject.quantity floatValue]*[salespaymentobject.price floatValue];
    float totalpaid = [salespaymentobject.salesrecord.paid floatValue];
//    float coupondiscount=0;
    
    
    for (int i=0; i<salespaymentobject.salesrecord.promotiondiscountrecords.count; i++) {
        MarketingRecord *marketingobject=[salespaymentobject.salesrecord.promotiondiscountrecords objectAtIndex:i];
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[salespaymentobject.quantity integerValue]);
        }else{
            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
        }
    }
    
    formatter.numberStyle = NSNumberFormatterNoStyle;
    discountedfee*=(1-[salespaymentobject.salesrecord.oneoffpercentagediscount floatValue]/100);
    discountedfee-=[salespaymentobject.salesrecord.oneoffdiscount floatValue];
    
    if(discountedfee>totalpaid && salespaymentobject.salesrecord.couponrecords.count>0){
        discountedfee-=totalpaid;
        for (int i=0; i<salespaymentobject.salesrecord.couponrecords.count; i++) {
            CouponRecord *obj=[salespaymentobject.salesrecord.couponrecords objectAtIndex:i];
            MarketingRecord *marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
//            if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
                discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
//                coupondiscount+=[marketingobject.promotionfixeddiscount floatValue];
                if(discountedfee<0){
                    discountedfee=0;
                }
//            }else{
//                discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
//            }
        }
        discountedfee+=totalpaid;
    }
    
//    if(totalpaid>0 && totalpaid<coupondiscount){
//        discountedfee+=totalpaid;
//    }
    
    totalfee=[formatter stringFromNumber:[NSNumber numberWithFloat:(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee)]];
    outstanding=[formatter stringFromNumber:[NSNumber numberWithFloat:((globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee)-[salespaymentobject.salesrecord.paid floatValue])]];

    salespaymentobject.totalfee=totalfee;
    salespaymentobject.salesrecord.total=totalfee;
    salespaymentobject.outstandingamount=outstanding;
    salespaymentobject.paidamount=outstanding;
    
}


//-(float) returnEnrollmentDiscountWithClassPaymentobject:(ClassPaymentRecord *)classpaymentobject
//{
//    float discountedfee=[classpaymentobject.tuitionfee floatValue];
//    float totalpaid = [classpaymentobject.enrollmentrecord.paid floatValue];
//    
//    for (int i=0; i<classpaymentobject.enrollmentrecord.promotiondiscountrecords.count; i++) {
//        MarketingRecord *marketingobject=[classpaymentobject.enrollmentrecord.promotiondiscountrecords objectAtIndex:i];
//        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
//            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[classpaymentobject.noofclass integerValue]);
//        }else{
//            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
//        }
//    }
//    
//    discountedfee*=(1-[classpaymentobject.enrollmentrecord.oneoffpercentagediscount floatValue]/100);
//    discountedfee-=[classpaymentobject.enrollmentrecord.oneoffdiscount floatValue];
//    discountedfee+=[classpaymentobject.enrollmentrecord.latefee floatValue]+[classpaymentobject.enrollmentrecord.enrollmentfee floatValue];
//    
//    if(classpaymentobject.enrollmentrecord.couponrecords.count>0){
//        discountedfee+=[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue];
//        if(discountedfee>totalpaid){
//            discountedfee-=totalpaid;
//            for (int i=0; i<classpaymentobject.enrollmentrecord.couponrecords.count; i++) {
//                CouponRecord *cobj=[classpaymentobject.enrollmentrecord.couponrecords objectAtIndex:i];
//                MarketingRecord *marketingobject=[MyClass returnMarketingRecordWithMarketingKey:cobj.marketingkey index:3];
////                if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
//                    discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
//                    if(discountedfee<0){
//                        discountedfee=0;
//                    }
////                }else{
////                    discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
////                }
//            }
//            discountedfee+=totalpaid;
//        }
//    }
//    
//    float discount =[classpaymentobject.tuitionfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue]+[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
//    return discount;
//}
//
//-(float) returnEnrollmentDiscountWithClassReceiptobject:(ClassReceiptRecord *)classpaymentobject
//{
//    float discountedfee=[classpaymentobject.tuitionfee floatValue];
//    float totalpaid = [classpaymentobject.enrollmentrecord.paid floatValue];
//
//    for (int i=0; i<classpaymentobject.enrollmentrecord.promotiondiscountrecords.count; i++) {
//        MarketingRecord *marketingobject=[classpaymentobject.enrollmentrecord.promotiondiscountrecords objectAtIndex:i];
//        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
//            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[classpaymentobject.noofclass integerValue]);
//        }else{
//            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
//        }
//    }
//    
//    discountedfee*=(1-[classpaymentobject.enrollmentrecord.oneoffpercentagediscount floatValue]/100);
//    discountedfee-=[classpaymentobject.enrollmentrecord.oneoffdiscount floatValue];
//    
//    discountedfee+=[classpaymentobject.enrollmentrecord.latefee floatValue]+[classpaymentobject.enrollmentrecord.enrollmentfee floatValue];
//    
//    if(classpaymentobject.enrollmentrecord.couponrecords.count>0){
//        discountedfee+=[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue];
//        if(discountedfee>totalpaid){
//            discountedfee-=totalpaid;
//            for (int i=0; i<classpaymentobject.enrollmentrecord.couponrecords.count; i++) {
//                CouponRecord *cobj=[classpaymentobject.enrollmentrecord.couponrecords objectAtIndex:i];
//                MarketingRecord *marketingobject=[MyClass returnMarketingRecordWithMarketingKey:cobj.marketingkey index:3];
////                if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
//                    discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
////                    coupondiscount+=[marketingobject.promotionfixeddiscount floatValue];
//                    if(discountedfee<0){
//                        discountedfee=0;
//                    }
////                }else{
////                    discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
////                }
//            }
//            discountedfee+=totalpaid;
//        }
//    }
//    
//    float discount =[classpaymentobject.tuitionfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue]+[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
//    //formatter.numberStyle = kCFNumberFormatterNoStyle;
//    return discount;
//}
//
//-(float) returnEnrollmentDiscountWithClassInvoiceobject:(ClassInvoiceRecord *)classpaymentobject
//{
//    float discountedfee=[classpaymentobject.tuitionfee floatValue];
//    float totalpaid = [classpaymentobject.enrollmentrecord.paid floatValue];
////    float coupondiscount=0;
//    
//    for (int i=0; i<classpaymentobject.enrollmentrecord.promotiondiscountrecords.count; i++) {
//        MarketingRecord *marketingobject=[classpaymentobject.enrollmentrecord.promotiondiscountrecords objectAtIndex:i];
//        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
//            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[classpaymentobject.noofclass integerValue]);
//        }else{
//            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
//        }
//    }
//    
//    discountedfee*=(1-[classpaymentobject.enrollmentrecord.oneoffpercentagediscount floatValue]/100);
//    discountedfee-=[classpaymentobject.enrollmentrecord.oneoffdiscount floatValue];
//    
//    discountedfee+=[classpaymentobject.latefee floatValue]+[classpaymentobject.enrollmentfee floatValue];
//    
//    if(classpaymentobject.enrollmentrecord.couponrecords.count>0){
//        discountedfee+=[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue];
//        if(discountedfee>totalpaid){
//            discountedfee-=totalpaid;
//            for (int i=0; i<classpaymentobject.enrollmentrecord.couponrecords.count; i++) {
//                CouponRecord *cobj=[classpaymentobject.enrollmentrecord.couponrecords objectAtIndex:i];
//                MarketingRecord *marketingobject=[MyClass returnMarketingRecordWithMarketingKey:cobj.marketingkey index:3];
////                if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
//                    discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
////                    coupondiscount+=[marketingobject.promotionfixeddiscount floatValue];
//                    if(discountedfee<0){
//                        discountedfee=0;
//                    }
////                }else{
////                    discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
////                }
//            }
//            discountedfee+=totalpaid;
//        }
//    }
//    
////    if(totalpaid>0 && totalpaid<coupondiscount){
////        discountedfee+=totalpaid;
////    }
//    
//    
//    float discount =[classpaymentobject.tuitionfee floatValue]+[classpaymentobject.latefee floatValue]+[classpaymentobject.enrollmentfee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
//    //formatter.numberStyle = kCFNumberFormatterNoStyle;
//    return discount;
//}
//
//-(float) returnSalesDiscountWithSalesPaymentobject:(SalesPaymentRecord *)salespaymentobject
//{
//    float discountedfee=[salespaymentobject.quantity floatValue]*[salespaymentobject.price floatValue];
//    float totalpaid = [salespaymentobject.salesrecord.paid floatValue];
////    float coupondiscount=0;
//    
//    for (int i=0; i<salespaymentobject.salesrecord.promotiondiscountrecords.count; i++) {
//        MarketingRecord *marketingobject=[salespaymentobject.salesrecord.promotiondiscountrecords objectAtIndex:i];
//        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
//            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[salespaymentobject.quantity integerValue]);
//        }else{
//            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
//        }
//    }
//    
//    formatter.numberStyle = NSNumberFormatterNoStyle;
//    discountedfee*=(1-[salespaymentobject.salesrecord.oneoffpercentagediscount floatValue]/100);
//    discountedfee-=[salespaymentobject.salesrecord.oneoffdiscount floatValue];
//    
//    if(discountedfee>totalpaid && salespaymentobject.salesrecord.couponrecords.count>0){
//        discountedfee-=totalpaid;
//        for (int i=0; i<salespaymentobject.salesrecord.couponrecords.count; i++) {
//            CouponRecord *cobj=[salespaymentobject.salesrecord.couponrecords objectAtIndex:i];
//            MarketingRecord *marketingobject=[MyClass returnMarketingRecordWithMarketingKey:cobj.marketingkey index:3];
////            if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
//                discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
////                coupondiscount+=[marketingobject.promotionfixeddiscount floatValue];
//                if(discountedfee<0){
//                    discountedfee=0;
//                }
////            }else{
////                discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
////            }
//        }
//        discountedfee+=totalpaid;
//    }
//    
////    if(totalpaid>0 && totalpaid<coupondiscount){
////        discountedfee+=totalpaid;
////    }
//    
//    float discount =[salespaymentobject.quantity floatValue]*[salespaymentobject.price floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
//    return discount;
//}
//
//-(float) returnSalesDiscountWithSalesReceiptobject:(SalesReceiptRecord *)salespaymentobject
//{
//    float discountedfee=[salespaymentobject.quantity floatValue]*[salespaymentobject.price floatValue];
//    float totalpaid = [salespaymentobject.salesrecord.paid floatValue];
////    float coupondiscount=0;
//    
//    for (int i=0; i<salespaymentobject.salesrecord.promotiondiscountrecords.count; i++) {
//        MarketingRecord *marketingobject=[salespaymentobject.salesrecord.promotiondiscountrecords objectAtIndex:i];
//        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
//            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[salespaymentobject.quantity integerValue]);
//        }else{
//            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
//        }
//    }
//    
//    formatter.numberStyle = NSNumberFormatterNoStyle;
//    discountedfee*=(1-[salespaymentobject.salesrecord.oneoffpercentagediscount floatValue]/100);
//    discountedfee-=[salespaymentobject.salesrecord.oneoffdiscount floatValue];
//    
//    if(discountedfee>totalpaid && salespaymentobject.salesrecord.couponrecords.count>0){
//        discountedfee-=totalpaid;
//        for (int i=0; i<salespaymentobject.salesrecord.couponrecords.count; i++) {
//            CouponRecord *cobj=[salespaymentobject.salesrecord.couponrecords objectAtIndex:i];
//            MarketingRecord *marketingobject=[MyClass returnMarketingRecordWithMarketingKey:cobj.marketingkey index:3];
////            if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
//                discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
////                coupondiscount+=[marketingobject.promotionfixeddiscount floatValue];
//                if(discountedfee<0){
//                    discountedfee=0;
//                }
////            }else{
////                discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
////            }
//        }
//        discountedfee+=totalpaid;
//    }
//    
////    if(totalpaid>0 && totalpaid<coupondiscount){
////        discountedfee+=totalpaid;
////    }
//    
//    float discount =[salespaymentobject.quantity floatValue]*[salespaymentobject.price floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
//    //formatter.numberStyle = kCFNumberFormatterNoStyle;
//    return discount;
//}
//
//-(float) returnSalesDiscountWithSalesInvoiceobject:(SalesInvoiceRecord *)salespaymentobject
//{
//    float discountedfee=[salespaymentobject.quantity floatValue]*[salespaymentobject.price floatValue];
//    float totalpaid = [salespaymentobject.salesrecord.paid floatValue];
////    float coupondiscount=0;
//    
//    for (int i=0; i<salespaymentobject.salesrecord.promotiondiscountrecords.count; i++) {
//        MarketingRecord *marketingobject=[salespaymentobject.salesrecord.promotiondiscountrecords objectAtIndex:i];
//        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
//            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[salespaymentobject.quantity integerValue]);
//        }else{
//            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
//        }
//    }
//    
//    formatter.numberStyle = NSNumberFormatterNoStyle;
//    discountedfee*=(1-[salespaymentobject.salesrecord.oneoffpercentagediscount floatValue]/100);
//    discountedfee-=[salespaymentobject.salesrecord.oneoffdiscount floatValue];
//    
//    if(discountedfee>totalpaid && salespaymentobject.salesrecord.couponrecords.count>0){
//        discountedfee-=totalpaid;
//        for (int i=0; i<salespaymentobject.salesrecord.couponrecords.count; i++) {
//            CouponRecord *cobj=[salespaymentobject.salesrecord.couponrecords objectAtIndex:i];
//            MarketingRecord *marketingobject=[MyClass returnMarketingRecordWithMarketingKey:cobj.marketingkey index:3];
////            if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
//                discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
////                coupondiscount+=[marketingobject.promotionfixeddiscount floatValue];
//                if(discountedfee<0){
//                    discountedfee=0;
//                }
////            }else{
////                discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
////            }
//        }
//        discountedfee+=totalpaid;
//    }
//    
////    if(totalpaid>0 && totalpaid<coupondiscount){
////        discountedfee+=totalpaid;
////    }
//    
//    float discount =[salespaymentobject.quantity floatValue]*[salespaymentobject.price floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
//    //formatter.numberStyle = kCFNumberFormatterNoStyle;
//    return discount;
//}


-(float) returnEnrollmentDiscountWithClassPaymentobject:(ClassPaymentRecord *)classpaymentobject
{
    MarketingRecord *marketingobject;
    float discount;
    
    float discountedfee=[classpaymentobject.tuitionfee floatValue];
    float totalpaid = [classpaymentobject.enrollmentrecord.paid floatValue];
    
    for (int i=0; i<classpaymentobject.enrollmentrecord.promotiondiscountrecords.count; i++) {
        MarketingRecord *marketingobject=[classpaymentobject.enrollmentrecord.promotiondiscountrecords objectAtIndex:i];
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[classpaymentobject.noofclass integerValue]);
        }else{
            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
        }
    }
    
    discountedfee*=(1-[classpaymentobject.enrollmentrecord.oneoffpercentagediscount floatValue]/100);
    discountedfee-=[classpaymentobject.enrollmentrecord.oneoffdiscount floatValue];
//    discountedfee+=[classpaymentobject.enrollmentrecord.latefee floatValue]+[classpaymentobject.enrollmentrecord.enrollmentfee floatValue];
    
    if(classpaymentobject.enrollmentrecord.couponrecords.count>0){
        discountedfee+=[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue];
        if(discountedfee-totalpaid>0){
            discountedfee-=totalpaid;
            for (int i=0; i<classpaymentobject.enrollmentrecord.couponrecords.count; i++) {
                CouponRecord *cobj=[classpaymentobject.enrollmentrecord.couponrecords objectAtIndex:i];
                marketingobject=[MyClass returnMarketingRecordWithMarketingKey:cobj.marketingkey index:3];

                if(!cobj.creditable){
                    discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
                    if(discountedfee<0){
                        discountedfee=0;
                    }
                }
            }
            discountedfee+=totalpaid;
        }
        
        for (int i=0; i<classpaymentobject.enrollmentrecord.couponrecords.count; i++) {
            CouponRecord *obj=[classpaymentobject.enrollmentrecord.couponrecords objectAtIndex:i];
            marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
            if(obj.creditable){
                discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
            }
        }
        discount =[classpaymentobject.tuitionfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue]+[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
        
        
    }else{
        discount =[classpaymentobject.tuitionfee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
    }
    
//    float discount =[classpaymentobject.tuitionfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue]+[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
    //formatter.numberStyle = kCFNumberFormatterNoStyle;
    return discount;
}

-(float) returnEnrollmentDiscountWithClassReceiptobject:(ClassReceiptRecord *)classpaymentobject
{
    MarketingRecord *marketingobject;
    float discount;
    float discountedfee=[classpaymentobject.tuitionfee floatValue];
    float totalpaid = [classpaymentobject.enrollmentrecord.paid floatValue];

    for (int i=0; i<classpaymentobject.enrollmentrecord.promotiondiscountrecords.count; i++) {
        MarketingRecord *marketingobject=[classpaymentobject.enrollmentrecord.promotiondiscountrecords objectAtIndex:i];
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[classpaymentobject.noofclass integerValue]);
        }else{
            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
        }
    }
    
    discountedfee*=(1-[classpaymentobject.enrollmentrecord.oneoffpercentagediscount floatValue]/100);
    discountedfee-=[classpaymentobject.enrollmentrecord.oneoffdiscount floatValue];
    
//    discountedfee+=[classpaymentobject.enrollmentrecord.latefee floatValue]+[classpaymentobject.enrollmentrecord.enrollmentfee floatValue];
    
    if(classpaymentobject.enrollmentrecord.couponrecords.count>0){
        discountedfee+=[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue];
        if(discountedfee-totalpaid>0){
            discountedfee-=totalpaid;
            for (int i=0; i<classpaymentobject.enrollmentrecord.couponrecords.count; i++) {
                CouponRecord *cobj=[classpaymentobject.enrollmentrecord.couponrecords objectAtIndex:i];
                marketingobject=[MyClass returnMarketingRecordWithMarketingKey:cobj.marketingkey index:3];

                if(!cobj.creditable){
                    discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
                    if(discountedfee<0){
                        discountedfee=0;
                    }
                }
            }
            discountedfee+=totalpaid;
        }
        
        for (int i=0; i<classpaymentobject.enrollmentrecord.couponrecords.count; i++) {
            CouponRecord *obj=[classpaymentobject.enrollmentrecord.couponrecords objectAtIndex:i];
            marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
            if(obj.creditable){
                discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
            }
        }
        discount =[classpaymentobject.tuitionfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue]+[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
        
    }else{
        discount =[classpaymentobject.tuitionfee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
    }
    
//    float discount =[classpaymentobject.tuitionfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue]+[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
    //formatter.numberStyle = kCFNumberFormatterNoStyle;
    return discount;
}

-(float) returnEnrollmentDiscountWithClassInvoiceobject:(ClassInvoiceRecord *)classpaymentobject
{
    MarketingRecord *marketingobject;
    float discount;
    float discountedfee=[classpaymentobject.tuitionfee floatValue];
    float totalpaid = [classpaymentobject.enrollmentrecord.paid floatValue];
//    float coupondiscount=0;
    
    for (int i=0; i<classpaymentobject.enrollmentrecord.promotiondiscountrecords.count; i++) {
        MarketingRecord *marketingobject=[classpaymentobject.enrollmentrecord.promotiondiscountrecords objectAtIndex:i];
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[classpaymentobject.noofclass integerValue]);
        }else{
            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
        }
    }
    
    discountedfee*=(1-[classpaymentobject.enrollmentrecord.oneoffpercentagediscount floatValue]/100);
    discountedfee-=[classpaymentobject.enrollmentrecord.oneoffdiscount floatValue];
    
//    discountedfee+=[classpaymentobject.latefee floatValue]+[classpaymentobject.enrollmentfee floatValue];
    
    if(classpaymentobject.enrollmentrecord.couponrecords.count>0){
        discountedfee+=[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue];
        if(discountedfee-totalpaid>0){
            discountedfee-=totalpaid;
            for (int i=0; i<classpaymentobject.enrollmentrecord.couponrecords.count; i++) {
                CouponRecord *cobj=[classpaymentobject.enrollmentrecord.couponrecords objectAtIndex:i];
                marketingobject=[MyClass returnMarketingRecordWithMarketingKey:cobj.marketingkey index:3];

                if(!cobj.creditable){
                    discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
                    if(discountedfee<0){
                        discountedfee=0;
                    }
                }
            }
            discountedfee+=totalpaid;
        }
        
        for (int i=0; i<classpaymentobject.enrollmentrecord.couponrecords.count; i++) {
            CouponRecord *obj=[classpaymentobject.enrollmentrecord.couponrecords objectAtIndex:i];
            marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
            if(obj.creditable){
                discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
            }
        }
        discount =[classpaymentobject.tuitionfee floatValue]+[classpaymentobject.enrollmentrecord.latefee floatValue]+[classpaymentobject.enrollmentrecord.enrollmentfee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
        
    }else{
        discount =[classpaymentobject.tuitionfee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
    }
    
//    if(totalpaid>0 && totalpaid<coupondiscount){
//        discountedfee+=totalpaid;
//    }
    
    
//    float discount =[classpaymentobject.tuitionfee floatValue]+[classpaymentobject.latefee floatValue]+[classpaymentobject.enrollmentfee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
    //formatter.numberStyle = kCFNumberFormatterNoStyle;
    return discount;
}

-(float) returnSalesDiscountWithSalesPaymentobject:(SalesPaymentRecord *)salespaymentobject
{
    MarketingRecord *marketingobject;
    float discountedfee=[salespaymentobject.quantity floatValue]*[salespaymentobject.price floatValue];
    float totalpaid = [salespaymentobject.salesrecord.paid floatValue];
//    float coupondiscount=0;
    
    for (int i=0; i<salespaymentobject.salesrecord.promotiondiscountrecords.count; i++) {
        MarketingRecord *marketingobject=[salespaymentobject.salesrecord.promotiondiscountrecords objectAtIndex:i];
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[salespaymentobject.quantity integerValue]);
        }else{
            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
        }
    }
    
    formatter.numberStyle = NSNumberFormatterNoStyle;
    discountedfee*=(1-[salespaymentobject.salesrecord.oneoffpercentagediscount floatValue]/100);
    discountedfee-=[salespaymentobject.salesrecord.oneoffdiscount floatValue];
    
    if(salespaymentobject.salesrecord.couponrecords.count>0){

        
        if(discountedfee-totalpaid>0){
            discountedfee-=totalpaid;
            
            for (int i=0; i<salespaymentobject.salesrecord.couponrecords.count; i++) {
                CouponRecord *obj=[salespaymentobject.salesrecord.couponrecords objectAtIndex:i];
                marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
                if(!obj.creditable){
                    discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
                    if(discountedfee<0){
                        discountedfee=0;
                    }
                }
            }
            discountedfee+=totalpaid;
        }
        
        for (int i=0; i<salespaymentobject.salesrecord.couponrecords.count; i++) {
            CouponRecord *obj=[salespaymentobject.salesrecord.couponrecords objectAtIndex:i];
            marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
            if(obj.creditable){
                discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
            }
        }
    }
    
    float discount =[salespaymentobject.quantity floatValue]*[salespaymentobject.price floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
    return discount;
}

-(float) returnSalesDiscountWithSalesReceiptobject:(SalesReceiptRecord *)salespaymentobject
{
    MarketingRecord *marketingobject;
    float discountedfee=[salespaymentobject.quantity floatValue]*[salespaymentobject.price floatValue];
    float totalpaid = [salespaymentobject.salesrecord.paid floatValue];
//    float coupondiscount=0;
    
    for (int i=0; i<salespaymentobject.salesrecord.promotiondiscountrecords.count; i++) {
        MarketingRecord *marketingobject=[salespaymentobject.salesrecord.promotiondiscountrecords objectAtIndex:i];
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[salespaymentobject.quantity integerValue]);
        }else{
            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
        }
    }
    
    formatter.numberStyle = NSNumberFormatterNoStyle;
    discountedfee*=(1-[salespaymentobject.salesrecord.oneoffpercentagediscount floatValue]/100);
    discountedfee-=[salespaymentobject.salesrecord.oneoffdiscount floatValue];
    
    if(salespaymentobject.salesrecord.couponrecords.count>0){

        
        if(discountedfee-totalpaid>0){
            discountedfee-=totalpaid;
            
            for (int i=0; i<salespaymentobject.salesrecord.couponrecords.count; i++) {
                CouponRecord *obj=[salespaymentobject.salesrecord.couponrecords objectAtIndex:i];
                marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
                if(!obj.creditable){
                    discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
                    if(discountedfee<0){
                        discountedfee=0;
                    }
                }
            }
            discountedfee+=totalpaid;
        }
        
        for (int i=0; i<salespaymentobject.salesrecord.couponrecords.count; i++) {
            CouponRecord *obj=[salespaymentobject.salesrecord.couponrecords objectAtIndex:i];
            marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
            if(obj.creditable){
                discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
            }
        }
    }
    
//    if(totalpaid>0 && totalpaid<coupondiscount){
//        discountedfee+=totalpaid;
//    }
    
    float discount =[salespaymentobject.quantity floatValue]*[salespaymentobject.price floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
    //formatter.numberStyle = kCFNumberFormatterNoStyle;
    return discount;
}

-(float) returnSalesDiscountWithSalesInvoiceobject:(SalesInvoiceRecord *)salespaymentobject
{
    MarketingRecord *marketingobject;
    float discountedfee=[salespaymentobject.quantity floatValue]*[salespaymentobject.price floatValue];
    float totalpaid = [salespaymentobject.salesrecord.paid floatValue];
//    float coupondiscount=0;
    
    for (int i=0; i<salespaymentobject.salesrecord.promotiondiscountrecords.count; i++) {
        MarketingRecord *marketingobject=[salespaymentobject.salesrecord.promotiondiscountrecords objectAtIndex:i];
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[salespaymentobject.quantity integerValue]);
        }else{
            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
        }
    }
    
    formatter.numberStyle = NSNumberFormatterNoStyle;
    discountedfee*=(1-[salespaymentobject.salesrecord.oneoffpercentagediscount floatValue]/100);
    discountedfee-=[salespaymentobject.salesrecord.oneoffdiscount floatValue];
    
    if(salespaymentobject.salesrecord.couponrecords.count>0){

        
        if(discountedfee-totalpaid>0){
            discountedfee-=totalpaid;
            
            for (int i=0; i<salespaymentobject.salesrecord.couponrecords.count; i++) {
                CouponRecord *obj=[salespaymentobject.salesrecord.couponrecords objectAtIndex:i];
                marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
                if(!obj.creditable){
                    discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
                    if(discountedfee<0){
                        discountedfee=0;
                    }
                }
            }
            discountedfee+=totalpaid;
        }
        
        for (int i=0; i<salespaymentobject.salesrecord.couponrecords.count; i++) {
            CouponRecord *obj=[salespaymentobject.salesrecord.couponrecords objectAtIndex:i];
            marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
            if(obj.creditable){
                discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
            }
        }
    }
    
//    if(totalpaid>0 && totalpaid<coupondiscount){
//        discountedfee+=totalpaid;
//    }
    
    float discount =[salespaymentobject.quantity floatValue]*[salespaymentobject.price floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee): discountedfee);
    //formatter.numberStyle = kCFNumberFormatterNoStyle;
    return discount;
}


- (IBAction)cleardiscountbuttonpressed:(UIButton *)sender {
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    for (int i=0; i<documentfolderclasspaymentarray.count; i++) {
        ClassPaymentRecord *classpaymentobject=[documentfolderclasspaymentarray objectAtIndex:i];
        if ([classpaymentobject.checkstatus isEqualToString:@"checked"]) {
            [classpaymentobject.enrollmentrecord.promotiondiscountrecords removeAllObjects];
            classpaymentobject.enrollmentrecord.oneoffdiscount=@"";
            classpaymentobject.enrollmentrecord.oneoffpercentagediscount=@"";
            classpaymentobject.enrollmentrecord.status=@"both";
            [self updateEnrollmentTotalFeeWithClassPaymentobject:classpaymentobject];
        }
    }

    for (int i=0; i<documentfoldersalespaymentarray.count; i++) {
        SalesPaymentRecord *salespaymentobject=[documentfoldersalespaymentarray objectAtIndex:i];
        if ([salespaymentobject.checkstatus isEqualToString:@"checked"]) {
            [salespaymentobject.salesrecord.promotiondiscountrecords removeAllObjects];
            salespaymentobject.salesrecord.oneoffdiscount=@"";
            salespaymentobject.salesrecord.oneoffpercentagediscount=@"";
            salespaymentobject.salesrecord.status=@"both";
            [self updateSalesTotalFeeWithSalesPaymentobject:salespaymentobject];
        }
        
    }
    
    [paymenttable reloadData];
    [payment_paybutton setTitle:[self returntotalpayamount] forState:UIControlStateNormal];
}

- (IBAction)savediscountbuttonpressed:(UIButton *)sender {
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateDocumentDiscount];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        
    });
    
}

- (IBAction)closesidewindow:(id)sender {
    [self openSideWindowWithTable:@"none"];
}
@end


