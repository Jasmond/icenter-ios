//
//  SalesPopoverViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 7/12/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import "SalesPopoverViewController.h"
#import "MyClass.h"

@interface SalesPopoverViewController ()

@end

@implementation SalesPopoverViewController
@synthesize SalesObject,PopoverStudent,SalesTableMode;


#define maxpaymentpopupheight self.view.frame.size.height
#define maxPopupHeight self.view.frame.size.height
#define kbPopupHeight 380

#define popoverwidth 320
#define detailpaymentwidth 320
#define voidwindowwidth 300
#define categorytablewidth 320
#define producttablewidth 400
#define discounttablewidth 300
#define promotioncodetablewidth 300
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    globalvariables=[GlobalVariables singleObj];
    
    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    CategoryArray=[[NSMutableArray alloc]init];
    productobject=[[ProductRecord alloc]init];
    workingSales.paymentrecords=[[NSMutableArray alloc]init];
    workingSales.promotiondiscountrecords=[[NSMutableArray alloc]init];
    workingSales=[[SalesRecord alloc]init];
    availablecouponarray=[[NSMutableArray alloc]init];
    
    if (![self retrieveProductListWithFlush:NO] || ![self InitializeField]) {
        nointernet=YES;
    }else{
        nointernet=NO;
    }
    
    [self createtables];
    [SalesPopoverTable reloadData];
    [self adjusttablesize];
    
    noofroundoffdigit=((CenterRecord *)[MyClass returncenterrecordwithcenterkey:globalvariables.centerrecord.centerkey]).noofroundoffdigit;
    
    [self performSelector:@selector(loaddate) withObject:nil afterDelay:0];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    neworderwillbecreated=NO;
    
    toolbarLabel.text=[MyClass returntitlewithtitle:@"Voided"];
    [editButton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
     [copyButton setTitle:[MyClass returntitlewithtitle:@"Copy"] forState:UIControlStateNormal];
      [doneButton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
       [cancelButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
    
        [payment_invoiceButton setTitle:[MyClass returntitlewithtitle:@"Invoice"] forState:UIControlStateNormal];
         [payment_receiptButton setTitle:[MyClass returntitlewithtitle:@"Receipt"] forState:UIControlStateNormal];
          [payment_cancelremarksButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
           [payment_doneremarksButton setTitle:[MyClass returntitlewithtitle:@"Save"] forState:UIControlStateNormal];
            [payment_cancelButton setTitle:[MyClass returntitlewithtitle:@"Cancel"] forState:UIControlStateNormal];
             [payment_saveButton setTitle:[MyClass returntitlewithtitle:@"Save"] forState:UIControlStateNormal];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (nointernet) {
        [self.delegate dismissSalesPopoverduetoconnectionerror];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
}
*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) createtables
{
//    SalesPopoverTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//    SalesPopoverTable.dataSource=self;
//    SalesPopoverTable.delegate=self;
//    [self.view addSubview:SalesPopoverTable];
    SalesPopoverTable.sectionHeaderHeight=CGFLOAT_MIN;
    
    SalesToolBar.backgroundColor=[UIColor blackColor];
    SalesToolBar.clipsToBounds=YES;
    
    if ([SalesTableMode isEqualToString:@"View"]) {
        [self createViewBarButton];
    }else if([SalesTableMode isEqualToString:@"Add"]){
        [self createAddBarButton];
    }
    
//    DetailPaymentMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, detailpaymentwidth, self.view.frame.size.height)];
//    [self.view addSubview:DetailPaymentMasterView];
    
    //DetailsPaymentTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    DetailsPaymentTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, detailpaymentwidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    DetailsPaymentTable.allowsMultipleSelectionDuringEditing=NO;
    DetailsPaymentTable.dataSource=self;
    DetailsPaymentTable.delegate=self;
    [DetailsPaymentTable reloadData];
    
    [DetailPaymentMasterView addSubview:DetailsPaymentTable];
//    paymentToolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, detailpaymentwidth, 44)];
//    paymentToolbar.clipsToBounds=YES;
//    [DetailPaymentMasterView addSubview:paymentToolbar];
    [self createPaymentToolBarwithMode:@"View"];
    
    
    //void enrollment table
    VoidWindowMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, voidwindowwidth, self.view.frame.size.height)];
    //VoidWindowMasterView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:VoidWindowMasterView];
    
    VoidTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+20, voidwindowwidth, self.view.frame.size.height-44-20) style:UITableViewStyleGrouped];
    VoidTable.allowsMultipleSelectionDuringEditing=NO;
    VoidTable.dataSource=self;
    VoidTable.delegate=self;
    [VoidWindowMasterView addSubview:VoidTable];
    
    
    VoidWindowToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, voidwindowwidth, 44)];
    VoidWindowToolBar.clipsToBounds = YES;
    [VoidWindowMasterView addSubview:VoidWindowToolBar];
    [self createVoidWindowToolBar];

    
    

    
    //category table
    CategoryTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, categorytablewidth, self.view.frame.size.height)];
    [self.view addSubview:CategoryTableMasterView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, CategoryTableMasterView.frame.size.width,88+3)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [CategoryTableMasterView addSubview:headerView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Category"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    categorysearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, CategoryTableMasterView.frame.size.width, 42)];
    categorysearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    categorysearchbar.delegate=self;
    categorysearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:categorysearchbar];
    
    CategoryTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+88+20+3, categorytablewidth, self.view.frame.size.height-44-88-20-3) style:UITableViewStyleGrouped];
    CategoryTable.dataSource=self;
    CategoryTable.delegate=self;
    
    //[SubjectTable reloadData];
    [CategoryTableMasterView addSubview:CategoryTable];
    
    CategoryTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, categorytablewidth, 44)];
    CategoryTableToolBar.clipsToBounds = YES;
    [CategoryTableMasterView addSubview:CategoryTableToolBar];
    [self createCategoryTableToolBar];

    //product table
    ProductTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, producttablewidth, self.view.frame.size.height)];
    [self.view addSubview:ProductTableMasterView];
    
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44+20, ProductTableMasterView.frame.size.width,88+3)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [ProductTableMasterView addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Product"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    productsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, ProductTableMasterView.frame.size.width, 42)];
    productsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    productsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    productsearchbar.delegate=self;
    [headerView addSubview:productsearchbar];
    
    ProductTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+88+20+3, producttablewidth, self.view.frame.size.height-44-88-20-3) style:UITableViewStyleGrouped];
    ProductTable.dataSource=self;
    ProductTable.delegate=self;
    
    //[SubjectTable reloadData];
    [ProductTableMasterView addSubview:ProductTable];
    
    ProductTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, producttablewidth, 44)];
    ProductTableToolBar.clipsToBounds = YES;
    [ProductTableMasterView addSubview:ProductTableToolBar];
    [self createProductTableToolBar];
    

    
    
    //discount table
//    DiscountTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(popoverwidth, 0, discounttablewidth+promotioncodetablewidth, self.view.frame.size.height)];
//    [self.view addSubview:DiscountTableMasterView];
    DiscountTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, discounttablewidth, self.view.frame.size.height-44) style:UITableViewStyleGrouped];
    DiscountTable.allowsMultipleSelectionDuringEditing=NO;
    DiscountTable.dataSource=self;
    DiscountTable.delegate=self;
    [DiscountTable setEditing:YES animated:YES];
    //[DiscountTable reloadData];
    
    [DiscountTableMasterView addSubview:DiscountTable];
    
    DiscountTableToolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, discounttablewidth+promotioncodetablewidth, 44)];
    DiscountTableToolBar.clipsToBounds = YES;
    [DiscountTableMasterView addSubview:DiscountTableToolBar];
    [self createDiscountTableToolBar];
    
    
    //promotion table
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, promotioncodetablewidth,88+3)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [promotioncodeview addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Add Promotion"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    
    promotionsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, promotioncodetablewidth, 42)];
    promotionsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    promotionsearchbar.delegate=self;
    promotionsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:promotionsearchbar];
    
//    PromotionCodeTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 44+88, promotioncodetablewidth, self.view.frame.size.height-44-84) style:UITableViewStyleGrouped];
//    PromotionCodeTable.delegate=self;
//    PromotionCodeTable.dataSource=self;
//    [promotioncodeview addSubview:PromotionCodeTable];
    
    //coupon table
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, promotioncodetablewidth,88+3)];
    headerView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [couponview addSubview:headerView];
    
    label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
    label.text=[[MyClass returntitlewithtitle:@"Add Coupon"] uppercaseString];
    label.font=[UIFont systemFontOfSize:13];
    label.textColor=[UIColor grayColor];
    [headerView addSubview:label];
    
    
    couponsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 44, promotioncodetablewidth, 42)];
    couponsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    couponsearchbar.delegate=self;
    couponsearchbar.searchBarStyle=UISearchBarStyleMinimal;
    [headerView addSubview:couponsearchbar];
    
    //add separator for promotion code table
    UILabel *separator=[[UILabel alloc]initWithFrame:CGRectMake(discounttablewidth, 44, 1, self.view.bounds.size.height-44)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [DiscountTableMasterView addSubview:separator];
    
    separator=[[UILabel alloc]initWithFrame:CGRectMake(popoverwidth, 0, 1, self.view.frame.size.height)];
    separator.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:separator];
    
    sharetable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 175, 190) style:UITableViewStylePlain];
    sharetable.delegate=self;
    sharetable.dataSource=self;
    sharetable.scrollEnabled=NO;
    
    
}

-(void) createDiscountTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closediscounttable) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [DiscountTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 13, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesubwindow:) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [DiscountTableMasterView addSubview:button];
}

-(void) createVoidWindowToolBar
{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesubwindow:) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [VoidWindowMasterView addSubview:button];
    
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closevoidsaleswindow) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    UIBarButtonItem *refundButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Confirm"] style:UIBarButtonItemStylePlain target:self action:@selector(voidConfirmButtonPressed)];
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,refundButton, nil];
//    [VoidWindowToolBar setItems:barItems];
    
    button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, voidwindowwidth, 20);
    [button setTitle:[MyClass returntitlewithtitle:@"Confirm"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(voidConfirmButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [button sizeToFit];
    button.frame = CGRectMake(voidwindowwidth-button.frame.size.width-20, 33, button.frame.size.width, 20);
    [VoidWindowMasterView addSubview:button];
}

-(void) createCategoryTableToolBar
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesubwindow:) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [CategoryTableMasterView addSubview:button];
    
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closecategorytable) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [CategoryTableToolBar setItems:barItems];
}

-(void) createProductTableToolBar
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.bounds = CGRectMake(0, 0, 20, 20);
//    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(closeproducttable) forControlEvents:UIControlEventTouchUpInside];
//    [button.heightAnchor constraintEqualToConstant:20].active = true;
//    [button.widthAnchor constraintEqualToConstant:20].active = true;
//    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//    
//    
//    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
//    [ProductTableToolBar setItems:barItems];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(20, 33, 20, 20);
    [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closesubwindow:) forControlEvents:UIControlEventTouchUpInside];
    [button.heightAnchor constraintEqualToConstant:20].active = true;
    [button.widthAnchor constraintEqualToConstant:20].active = true;
    
    [ProductTableMasterView addSubview:button];
}



-(void) closesidewindow
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [SalesPopoverTable deselectRowAtIndexPath:[SalesPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(IBAction) closesubwindow:(id)sender
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [SalesPopoverTable deselectRowAtIndexPath:[SalesPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}


-(void) loaddate
{
    //[MyClass getLatestDataSetv2withParameters:@"calendar" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    hourPickerViewMenu=[[NSMutableArray alloc]init];
    minutePickerViewMenu=[[NSMutableArray alloc]init];
    
    for (int i=0; i<24; i++) {
        [hourPickerViewMenu addObject:[NSString stringWithFormat:@"%02i",i]];
    }
    
    for (int i=0; i<60; i++) {
        [minutePickerViewMenu addObject:[NSString stringWithFormat:@"%02i",i]];
    }
    
}

- (void)keyboardDidHide: (NSNotification *) notification
{
    // Do something here
    keyboardheight=0;
    [self adjusttablesize];
}

- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    [self adjusttablesize];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = MIN(keyboardSize.height,keyboardSize.width);
    [self adjusttablesize];
    
}


-(void) createViewBarButton
{
    editButton.hidden=YES;
    copyButton.hidden=YES;
    doneButton.hidden=YES;
    cancelButton.hidden=YES;
    toolbarLabel.hidden=YES;
    
    if ([SalesObject.productcode isEqualToString:@"FPAY"]) {
//        toolbarLabel.text=[MyClass returntitlewithtitle:@"Voided"];
        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 44)];
//        label.backgroundColor = [UIColor clearColor];
        toolbarLabel.hidden=NO;
        if ([SalesObject.status isEqualToString:@"Voided"]) {
            toolbarLabel.text = [MyClass returntitlewithtitle:@"Voided Forfeited Payment"];
        }else{
            toolbarLabel.text = [MyClass returntitlewithtitle:@"Forfeited Payment"];
        }
//        label.textColor=[UIColor redColor];
//        
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:label];
//        SalesToolBar.items = [NSArray arrayWithObject:item];
    }else if ([SalesObject.status isEqualToString:@"Voided"]) {
        editButton.hidden=NO;
        toolbarLabel.hidden=NO;
        toolbarLabel.text=[MyClass returntitlewithtitle:@"Voided"];
        
//        NSArray *buttons;
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//        label.backgroundColor = [UIColor clearColor];
//        label.text = [MyClass returntitlewithtitle:@"Voided"];
//        label.textColor=[UIColor redColor];
//        
//        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:label];
//        UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//        UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        
//        buttons = [NSArray arrayWithObjects:item,flexibleSpaceBarButton,editButton, nil];
//        [SalesToolBar setItems:buttons animated:NO];
    }else{
        editButton.hidden=NO;
        copyButton.hidden=NO;
        
//        NSArray *buttons;
//        
//        UIBarButtonItem *editButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editButtonPressed:)];
//        UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
////        UIBarButtonItem *invoiceButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Invoice"] style:UIBarButtonItemStylePlain target:self action:@selector(shareinvoicebutton:)];
//        UIBarButtonItem *copyButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Copy"] style:UIBarButtonItemStylePlain target:self action:@selector(copyButtonPressed:)];
//        
//        
//        buttons =[NSArray arrayWithObjects:/*invoiceButton,flexibleSpaceBarButton,*/copyButton,flexibleSpaceBarButton,editButton,nil];
//        [SalesToolBar setItems:buttons animated:NO];
    }
    

}

-(void) createEditBarButton
{
    editButton.hidden=YES;
    copyButton.hidden=YES;
    doneButton.hidden=NO;
    cancelButton.hidden=NO;
    toolbarLabel.hidden=YES;
    
//    NSArray *buttons=[[NSArray alloc]init];
//    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed:)];
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    buttons =[NSArray arrayWithObjects:cancelButton,flexibleSpaceBarButton,doneButton,nil];
//    [SalesToolBar setItems:buttons animated:NO];
}

-(void) createAddBarButton
{
    editButton.hidden=YES;
    copyButton.hidden=YES;
    doneButton.hidden=NO;
    cancelButton.hidden=YES;
    toolbarLabel.hidden=YES;
    
//    UIBarButtonItem *flexibleSpaceBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc] initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneButtonPressed:)];
//    NSArray *buttons =[NSArray arrayWithObjects:flexibleSpaceBarButton,doneButton,nil];
//    [SalesToolBar setItems:buttons animated:NO];
}

-(IBAction) editButtonPressed:(id)sender{
    
    SalesTableMode=@"Edit";
    
    [self InitializeField];
    [self createEditBarButton];
    
    [SalesPopoverTable reloadData];
    
    [self adjusttablesize];
    
    
}

-(IBAction) cancelButtonPressed:(id)sender{
    
    [self createViewBarButton];
    SalesTableMode=@"View";
    [self InitializeField];
    
    [SalesPopoverTable reloadData];
    [self adjusttablesize];
    //DetailsPaymentArray=[[NSMutableArray alloc]init];
}

-(NSMutableArray *) retrieveStudentData
{
    NSMutableArray *studentArray=[[NSMutableArray alloc] init];
    
        studentArray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@ and self.status != %@",globalvariables.centerrecord.centerkey,@"Inactive"];
    studentArray=[[NSMutableArray alloc]initWithArray:[studentArray filteredArrayUsingPredicate:predicate]];

    
    return [MyClass sortstudentlistwithstudentarray:studentArray sortingarray:nil];
}

-(IBAction) copyButtonPressed:(UIButton *)sender
{
    studentimagepopover = (StudentImageGridViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentImageGridViewController"];
    
    studentimagepopover.delegate=self;
    studentimagepopover.studentArray=[self retrieveStudentData];
    studentimagepopover.studentcategory=@"All Students";
    studentimagepopover.mode=@"multiple";
    studentimagepopover.source=@"sales";
    studentimagepopover.salesrecord=SalesObject;
    studentimagepopover.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [MyClass presentViewController:studentimagepopover View:self];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView==SalesPopoverTable) {
        if ([SalesTableMode isEqualToString:@"View"]) {
            return 6;
        }else if ([SalesTableMode isEqualToString:@"Add"]){
            return 5;
        }else{
            return 6;
        }
    }else if (tableView==DetailsPaymentTable) {
        if ([DetailsPaymentTableMode isEqualToString:@"View"]) {
            return 2;
        }else if ([DetailsPaymentTableMode isEqualToString:@"Add"]){
            if (workingSales.paymentrecords.count==0) {
                return 2;
            }else{
                return 3;
            }
        }else{
            return 1;
        }
        
    }else if (tableView==DiscountTable){
        return 4;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==SalesPopoverTable) {
        if ([SalesTableMode isEqualToString:@"View"]) {
            if (section==0) {
                return 4;
            }else if (section==2){
                return 6;
            }else if (section==3){
                return 1;
            }else{
                return 1;
            }
            
        }else{// if ([EnrollmentTableMode isEqualToString:@"Edit"] or add){
            if (section==0) {
                return 5;
            }else if (section==2){
                return 6;
            }else if (section==3){
                return 1;
            }else{
                return 1;
            }
        }
    }else if (tableView==DetailsPaymentTable) {
        if ([DetailsPaymentTableMode isEqualToString:@"View"]) {
            if (section==0) {
                return 3;
            }else if (section==1){
                return workingSales.paymentrecords.count;
            }else{
                return 1;
            }
        }else if ([DetailsPaymentTableMode isEqualToString:@"Add"]){
            if (workingSales.paymentrecords.count==0) {
                if (section==0) {
                    return 3;
                }else{
                    return 8;
                }
            }else{
                if (section==0) {
                    return 3;
                }else if (section==1){
                    return 8;
                }else{
                    return workingSales.paymentrecords.count;
                }
            }
        }else if ([DetailsPaymentTableMode isEqualToString:@"Edit"]){
            return 5;
        }else{
            return 1;
        }
    }else if (tableView==CategoryTable){
        return filteredCategoryArray.count;
    }else if (tableView==ProductTable){
        return filteredProductArray.count;
    }else if (tableView==VoidTable){
        return 7;
    }else if (tableView==DiscountTable){
        if (section==0) {
            return workingSales.promotiondiscountrecords.count;
        }else if (section==1){//
            return 2;
        }else if (section==2){//
            return globalvariables.centerrecord.ecoupon?workingSales.couponrecords.count:0;
        }else{
            return 1;
        }
    }else if (tableView==PromotionCodeTable){
        return filteredavailablepromotionarray.count;
    }else if (tableView==CouponTable){
        return showcoupontable?filteredavailablecouponarray.count:0;
    }else{ //sharetable
        return 5;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 38;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==SalesPopoverTable) {
        if ([SalesTableMode isEqualToString:@"View"]) {
            if (indexPath.section==0) {
                return 35;
            }else if (indexPath.section==1){
                ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
                if (obj && ![obj.autorenew isEqualToString:@""]) {
                    return 35;
                }else{
                    return CGFLOAT_MIN;
                }
            }else if (indexPath.section==2){
                if(indexPath.row==2){
                    ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
                    if ([obj.stockcount isEqualToString:@""] || [workingSales.productcode isEqualToString:@""]) {
                        return CGFLOAT_MIN;
                    }
                }
                return 35;
            }else if (indexPath.section==3){
                return 65;
            }else if (indexPath.section==4){
                return 65;
            }else{
                return 35;
            }
            
        }else{// if ([EnrollmentTableMode isEqualToString:@"Edit"]){
            if (indexPath.section==0) {
                if(indexPath.row==1){
                    return showOrderDatePicker?200:CGFLOAT_MIN;
                }
                return 35;
            }else if (indexPath.section==1){
                ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
                if (obj && ![obj.autorenew isEqualToString:@""]) {
                    return 35;
                }else{
                    return CGFLOAT_MIN;
                }
            }else if (indexPath.section==2){
                if(indexPath.row==2){
                    ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
                    if ([obj.stockcount isEqualToString:@""] || [workingSales.productcode isEqualToString:@""]) {
                        return CGFLOAT_MIN;
                    }
                }
                return 35;
            }else if (indexPath.section==3){
                return 65;
            }else if (indexPath.section==4){
                return 65;
            }else{
                if (indexPath.row==0) {
                    if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).voidsales) {
                        return 35;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }else{
                    if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).deletesales) {
                        return 35;
                    }else{
                        return CGFLOAT_MIN;
                    }
                }

            }
        }
    }else if (tableView==DetailsPaymentTable){ //details payment table
        if ([DetailsPaymentTableMode isEqualToString:@"View"]) {
            if (indexPath.section==0) {
                return 35;
            }else if (indexPath.section==1){
                
                float cellheight=35;
                PaymentRecord *DetailsPaymentObject=[workingSales.paymentrecords objectAtIndex:indexPath.row];
                if (![DetailsPaymentObject.paymentremarks isEqualToString:@""]) {
                    paymentremarkslabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 248, 100)];
                    paymentremarkslabel.text=DetailsPaymentObject.paymentremarks;
                    paymentremarkslabel.numberOfLines=0;
                    paymentremarkslabel.font=[UIFont systemFontOfSize:12];
                    [paymentremarkslabel sizeToFit];
                    cellheight+=20;
                    cellheight+=paymentremarkslabel.frame.size.height;
                    cellheight+=10;
                }
                
                if (![DetailsPaymentObject.receiptremarks isEqualToString:@""]) {
                    receiptremarkslabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 248, 100)];
                    receiptremarkslabel.text=DetailsPaymentObject.receiptremarks;
                    receiptremarkslabel.font=[UIFont systemFontOfSize:12];
                    receiptremarkslabel.numberOfLines=0;
                    [receiptremarkslabel sizeToFit];
                    cellheight+=20;
                    cellheight+=receiptremarkslabel.frame.size.height;
                    cellheight+=10;
                }
                
                //if (![DetailsPaymentObject.staffname isEqualToString:@""]) {
                    cellheight+=15;
                //}
                
                return cellheight;
            }else{
                return 100;
            }
            
        }else if ([DetailsPaymentTableMode isEqualToString:@"Add"]){
            if (indexPath.section==1 && indexPath.row==0){
                return globalvariables.centerrecord.enableaccountreceivablecodes?35:CGFLOAT_MIN;
            }else if (indexPath.section==1 && indexPath.row==2) {
                if (showPaidMethodPicker) {
                    return 150;
                }else{
                    return 0;
                }
            }else if (indexPath.section==1 && indexPath.row==4) {
                if (showPaymentDatePicker) {
                    return 200;
                }else{
                    return 0;
                }
            }else if (indexPath.section==1 && (indexPath.row==6 || indexPath.row==7)){
                return 100;
            }else if (indexPath.section==2){
                float cellheight=35;
                PaymentRecord *DetailsPaymentObject=[workingSales.paymentrecords objectAtIndex:indexPath.row];
                if (![DetailsPaymentObject.paymentremarks isEqualToString:@""]) {
                    paymentremarkslabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 248, 100)];
                    paymentremarkslabel.text=DetailsPaymentObject.paymentremarks;
                    paymentremarkslabel.numberOfLines=0;
                    paymentremarkslabel.font=[UIFont systemFontOfSize:12];
                    [paymentremarkslabel sizeToFit];
                    cellheight+=20;
                    cellheight+=paymentremarkslabel.frame.size.height;
                    cellheight+=10;
                }
                
                if (![DetailsPaymentObject.receiptremarks isEqualToString:@""]) {
                    receiptremarkslabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, 248, 100)];
                    receiptremarkslabel.text=DetailsPaymentObject.receiptremarks;
                    receiptremarkslabel.font=[UIFont systemFontOfSize:12];
                    receiptremarkslabel.numberOfLines=0;
                    [receiptremarkslabel sizeToFit];
                    cellheight+=20;
                    cellheight+=receiptremarkslabel.frame.size.height;
                    cellheight+=10;
                }
                
                //if (![DetailsPaymentObject.staffname isEqualToString:@""]) {
                    cellheight+=15;
                //}
                
                return cellheight;
                
            }else{
                return 35;
            }
        }else if ([DetailsPaymentTableMode isEqualToString:@"Edit"]){
            if (indexPath.row<=2) {
                return 35;
            }else{
                return 100;
            }
        }else{ //edit invoice remarks
            return 100;
        }
    }else if (tableView==VoidTable){
        if (indexPath.row==3) {
            if (showRefundMethodPicker) {
                return 150;
            }else{
                return 0;
            }
        }else if (indexPath.row==6){
            return 100;
        }else{
            return 35;
        }
    }else if (tableView==DiscountTable){
        if (indexPath.section==0) {
            UILabel *pcdescriptionlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, tableView.frame.size.width-75, 100)];
            pcdescriptionlabel.font=[UIFont systemFontOfSize:15];
            pcdescriptionlabel.numberOfLines=0;
            pcdescriptionlabel.text=[globalvariables.language isEqualToString:@"English"]?((MarketingRecord *)[workingSales.promotiondiscountrecords objectAtIndex:indexPath.row]).description:((MarketingRecord *)[workingSales.promotiondiscountrecords objectAtIndex:indexPath.row]).description_chinese;
            [pcdescriptionlabel sizeToFit];
            
            if ([DiscountTableMode isEqualToString:@"View"]) {
                
                UILabel *pcdescriptionlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, tableView.frame.size.width-75, 100)];
                pcdescriptionlabel.font=[UIFont systemFontOfSize:15];
                pcdescriptionlabel.numberOfLines=0;
                pcdescriptionlabel.text=[globalvariables.language isEqualToString:@"English"]?((MarketingRecord *)[workingSales.promotiondiscountrecords objectAtIndex:indexPath.row]).description:((MarketingRecord *)[workingSales.promotiondiscountrecords objectAtIndex:indexPath.row]).description_chinese;
                [pcdescriptionlabel sizeToFit];
                
                if ([marketingobject.recursive isEqualToString:@"Yes"]) {
                    return pcdescriptionlabel.frame.size.height+7+7+15;
                }else{
                    return pcdescriptionlabel.frame.size.height+7+7;
                }
                
//                if (pcdescriptionlabel.frame.origin.y+pcdescriptionlabel.frame.size.height+7<38) {
//                    return 38;
//                }else{
//                    return pcdescriptionlabel.frame.origin.y+pcdescriptionlabel.frame.size.height+7;
//                }
            }else{
                UILabel *pcdescriptionlabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, tableView.frame.size.width-75-10, 100)];
                pcdescriptionlabel.font=[UIFont systemFontOfSize:13];
                pcdescriptionlabel.numberOfLines=0;
                pcdescriptionlabel.text=[globalvariables.language isEqualToString:@"English"]?((MarketingRecord *)[workingSales.promotiondiscountrecords objectAtIndex:indexPath.row]).description:((MarketingRecord *)[workingSales.promotiondiscountrecords objectAtIndex:indexPath.row]).description_chinese;
                [pcdescriptionlabel sizeToFit];
                
                return pcdescriptionlabel.frame.origin.y+pcdescriptionlabel.frame.size.height+22;
            }
            
        }else if (indexPath.section==2) {
            CouponRecord *coupon=[workingSales.couponrecords objectAtIndex:indexPath.row];
            MarketingRecord *mkt=[MyClass returnMarketingRecordWithMarketingKey:coupon.marketingkey index:3];
            UILabel *pcdescriptionlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, tableView.frame.size.width-75, 100)];
            pcdescriptionlabel.font=[UIFont systemFontOfSize:15];
            pcdescriptionlabel.numberOfLines=0;
            pcdescriptionlabel.text=[globalvariables.language isEqualToString:@"English"]?mkt.description:mkt.description_chinese;
            [pcdescriptionlabel sizeToFit];
            
            if ([DiscountTableMode isEqualToString:@"View"]) {
                
                UILabel *pcdescriptionlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, tableView.frame.size.width-75, 100)];
                pcdescriptionlabel.font=[UIFont systemFontOfSize:15];
                pcdescriptionlabel.numberOfLines=0;
                pcdescriptionlabel.text=[globalvariables.language isEqualToString:@"English"]?mkt.description:mkt.description_chinese;
                [pcdescriptionlabel sizeToFit];
                

                return pcdescriptionlabel.frame.size.height+7+7;
            }else{
                UILabel *pcdescriptionlabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, tableView.frame.size.width-75-10, 100)];
                pcdescriptionlabel.font=[UIFont systemFontOfSize:13];
                pcdescriptionlabel.numberOfLines=0;
                pcdescriptionlabel.text=[globalvariables.language isEqualToString:@"English"]?mkt.description:mkt.description_chinese;
                [pcdescriptionlabel sizeToFit];
                
                return pcdescriptionlabel.frame.origin.y+pcdescriptionlabel.frame.size.height+22;
            }
        }else{
            return 38;
        }
    }else if (tableView==PromotionCodeTable){
        return  UITableViewAutomaticDimension;
//        UILabel *pcdescriptionlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, tableView.frame.size.width-100, 100)];
//        pcdescriptionlabel.font=[UIFont systemFontOfSize:14];
//        pcdescriptionlabel.numberOfLines=0;
//        pcdescriptionlabel.text=[globalvariables.language isEqualToString:@"English"]?((MarketingRecord *)[filteredavailablepromotionarray objectAtIndex:indexPath.row]).description:((MarketingRecord *)[filteredavailablepromotionarray objectAtIndex:indexPath.row]).description_chinese;
//        [pcdescriptionlabel sizeToFit];
//        
//        return pcdescriptionlabel.frame.origin.y+pcdescriptionlabel.frame.size.height+5+14+7+4+14;
    }else if (tableView==CouponTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==ProductTable){
        return 50;
    }else{
        return 38;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==SalesPopoverTable) {
        if ([SalesTableMode isEqualToString:@"Edit"]) {
            if (section==1){
                ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
                if (obj && ![obj.autorenew isEqualToString:@""]) {
                    return 44;
                }else{
                    return CGFLOAT_MIN;
                }
            }else if (section==3){
                if (!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).voidsales && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).deletesales ) {
                    return CGFLOAT_MIN;
                }else{
                    return 44;
                }
            }else{
                return 44;
            }
        }else{
            if (section==1) {
                ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
                if (obj && ![obj.autorenew isEqualToString:@""]) {
                    return 44;
                }else{
                    return CGFLOAT_MIN;
                }
            }
            return 44;
        }
    }else if (tableView==sharetable){
        return CGFLOAT_MIN;
    }else if (tableView==ProductTable){
        return CGFLOAT_MIN;
    }else if (tableView==CategoryTable){
        return CGFLOAT_MIN;
    }else if (tableView==PromotionCodeTable){
        return CGFLOAT_MIN;
    }else if (tableView==CouponTable){
        return CGFLOAT_MIN;
    }else if (tableView==DiscountTable){
        if (section==0) {
            return availablepromotionarray.count==0?CGFLOAT_MIN:44;
        }else if (section==2){
            return globalvariables.centerrecord.ecoupon?44:CGFLOAT_MIN;
        }
        return 44;
    }else{
        return 44;
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==SalesPopoverTable) {
        if ([SalesTableMode isEqualToString:@"View"]) {
            if (section==0) {
                return [MyClass returntitlewithtitle:@"General"];
            }else if (section==1){
                ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
                if (obj && ![obj.autorenew isEqualToString:@""]) {
                    return [MyClass returntitlewithtitle:@"Product Auto Renew"];
                }
            }else if (section==2){
                return [MyClass returntitlewithtitle:@"Price"];
            }else if (section==3){
                return [MyClass returntitlewithtitle:@"Remarks"];
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Invoice Remarks"];
            }else{
                return nil;
            }
        }else{
            if (section==0) {
                return [MyClass returntitlewithtitle:@"General"];
            }else if (section==1){
                ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
                if (obj && ![obj.autorenew isEqualToString:@""]) {
                    return [MyClass returntitlewithtitle:@"Product Auto Renew"];
                }
            }else if (section==2){
                return [MyClass returntitlewithtitle:@"Price"];
            }else if (section==3){
                return [MyClass returntitlewithtitle:@"Remarks"];
            }else if (section==4){
                return [MyClass returntitlewithtitle:@"Invoice Remarks"];
            }else{
                return nil;// workingSales.paymentrecords.count>0?[MyClass returntitlewithtitle:@"Payment record(s) exist"]:nil;
            }
        }
        
        
    }else if (tableView==DetailsPaymentTable) {
        if ([DetailsPaymentTableMode isEqualToString:@"View"]) {
            if (section==0) {
                return [MyClass returntitlewithtitle:@"Summary"];
            }else if (section==1){
                if (workingSales.paymentrecords.count==0) {
                    return nil;
                }else{
                    return [MyClass returntitlewithtitle:@"Payment History"];
                }
            }else{
                return [MyClass returntitlewithtitle:@"Invoice Remarks"];
            }
        }else if ([DetailsPaymentTableMode isEqualToString:@"Add"]){
            if (workingSales.paymentrecords.count==0) {
                if (section==0) {
                    return [MyClass returntitlewithtitle:@"Summary"];
                }else{
                    return [MyClass returntitlewithtitle:@"Add Payment Record"];
                }
            }else{
                if (section==0) {
                    return [MyClass returntitlewithtitle:@"Summary"];
                }else if (section==1){
                    return [MyClass returntitlewithtitle:@"Add Payment Record"];
                }else{
                    return [MyClass returntitlewithtitle:@"Payment History"];
                }
            }
        }else if ([DetailsPaymentTableMode isEqualToString:@"Edit"]){
            return [MyClass returntitlewithtitle:@"Edit Payment Record"];
        }else{ //edit invoice remarks
            return [MyClass returntitlewithtitle:@"Edit Invoice Remarks"];
        }
    }else if (tableView==VoidTable){
        return [MyClass returntitlewithtitle:@"Void Sales"];
    }else if (tableView==DiscountTable){
        if (section==0) {
            return availablepromotionarray.count==0?nil:[MyClass returntitlewithtitle:@"Promotional Discount"];
        }else if (section==1){
            return [MyClass returntitlewithtitle:@"Regular Discount"];
        }else if (section==2){
            return [MyClass returntitlewithtitle:@"Coupon"];
        }else{
            return [MyClass returntitlewithtitle:@"Total Discount"];
        }
    }
    return nil;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (tableView==VoidTable) {
        return [MyClass returntitlewithtitle:@"*Please refer your centre's refund policy"];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView==DiscountTable) {
        if (section==0) {
            if (availablepromotionarray.count>0) {
                if (workingSales.promotiondiscountrecords.count==0) {
                    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 38)];
                    header.backgroundColor=[UIColor whiteColor];
                    
                    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-40, 38)];
                    label.text=[MyClass returntitlewithtitle:@"None"];
                    label.font=[UIFont systemFontOfSize:15];
                    label.numberOfLines=0;
                    label.textColor=[UIColor darkGrayColor];
                    [header addSubview:label];
                    
                    label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.4)];
                    label.backgroundColor=[UIColor lightGrayColor];
                    label.layer.opacity=0.3;
                    [header addSubview:label];
                    
                    label=[[UILabel alloc]initWithFrame:CGRectMake(0, header.frame.size.height, tableView.frame.size.width, 0.4)];
                    label.backgroundColor=[UIColor lightGrayColor];
                    label.layer.opacity=0.3;
                    [header addSubview:label];
                    
                    return header;
                }
            }
        }else if (section==2) {
            if (availablecouponarray.count>=0 && globalvariables.centerrecord.ecoupon) {
                if (workingSales.couponrecords.count==0) {
                    UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 38)];
                    header.backgroundColor=[UIColor whiteColor];
                    
                    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-40, 38)];
                    label.text=[MyClass returntitlewithtitle:@"None"];
                    label.font=[UIFont systemFontOfSize:15];
                    label.numberOfLines=0;
                    label.textColor=[UIColor darkGrayColor];
                    [header addSubview:label];
                    
                    label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.4)];
                    label.backgroundColor=[UIColor lightGrayColor];
                    label.layer.opacity=0.3;
                    [header addSubview:label];
                    
                    label=[[UILabel alloc]initWithFrame:CGRectMake(0, header.frame.size.height, tableView.frame.size.width, 0.4)];
                    label.backgroundColor=[UIColor lightGrayColor];
                    label.layer.opacity=0.3;
                    [header addSubview:label];
                    
                    return header;
                }
            }
        }
    }else if (tableView==PromotionCodeTable){
        if (filteredavailablepromotionarray.count==0) {
            UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 38)];
            header.backgroundColor=[UIColor whiteColor];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-40, 38)];
            label.text=[MyClass returntitlewithtitle:@"None"];
            label.font=[UIFont systemFontOfSize:15];
            label.numberOfLines=0;
            label.textColor=[UIColor darkGrayColor];
            [header addSubview:label];
            
            label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.4)];
            label.backgroundColor=[UIColor lightGrayColor];
            label.layer.opacity=0.3;
            [header addSubview:label];
            
            label=[[UILabel alloc]initWithFrame:CGRectMake(0, header.frame.size.height, tableView.frame.size.width, 0.4)];
            label.backgroundColor=[UIColor lightGrayColor];
            label.layer.opacity=0.3;
            [header addSubview:label];
            
            return header;
        }
    }else if (tableView==CouponTable){
        if (filteredavailablecouponarray.count==0) {
            UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 38)];
            header.backgroundColor=[UIColor whiteColor];
            
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(20, 0, tableView.frame.size.width-40, 38)];
            label.text=[MyClass returntitlewithtitle:@"None"];
            label.font=[UIFont systemFontOfSize:15];
            label.numberOfLines=0;
            label.textColor=[UIColor darkGrayColor];
            [header addSubview:label];
            
            label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0.4)];
            label.backgroundColor=[UIColor lightGrayColor];
            label.layer.opacity=0.3;
            [header addSubview:label];
            
            label=[[UILabel alloc]initWithFrame:CGRectMake(0, header.frame.size.height, tableView.frame.size.width, 0.4)];
            label.backgroundColor=[UIColor lightGrayColor];
            label.layer.opacity=0.3;
            [header addSubview:label];
            
            return header;
        }
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (tableView==SalesPopoverTable) {
        if ([SalesTableMode isEqualToString:@"View"]) {
            //if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (indexPath.section==0) {
                if (indexPath.row==0) {
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Order Date"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    OrderDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    OrderDateLabel.font=[UIFont systemFontOfSize:15];
                    OrderDateLabel.textColor=[UIColor darkGrayColor];
                    OrderDateLabel.textAlignment=NSTextAlignmentRight;
                    OrderDateLabel.text=[MyClass returndateformatwithdate:workingSales.orderdate];
                    OrderDateLabel.tag=301;
                    [cell.contentView addSubview:OrderDateLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 157, 32)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Category"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    CategoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 187, 32)];
                    CategoryLabel.font=[UIFont systemFontOfSize:15];
                    CategoryLabel.textColor=[UIColor darkGrayColor];
                    CategoryLabel.textAlignment=NSTextAlignmentRight;
                    CategoryLabel.adjustsFontSizeToFitWidth=YES;
                    CategoryLabel.minimumScaleFactor=0.7;
                    CategoryLabel.numberOfLines=0;
                    CategoryLabel.text=workingSales.productcategory;
                    CategoryLabel.tag=301;
                    [cell.contentView addSubview:CategoryLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==2){
                    
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 120, 32)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Product"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    ProductLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 197, 32)];
                    ProductLabel.font=[UIFont systemFontOfSize:15];
                    ProductLabel.textColor=[UIColor darkGrayColor];
                    ProductLabel.textAlignment=NSTextAlignmentRight;
                    ProductLabel.adjustsFontSizeToFitWidth=YES;
                    ProductLabel.minimumScaleFactor=0.7;
                    ProductLabel.numberOfLines=0;
                    ProductLabel.text=workingSales.productfullname;
                    ProductLabel.tag=301;
                    [cell.contentView addSubview:ProductLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==3){
                    
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 43, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Code"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    CodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(70, 7, 217, 21)];
                    CodeLabel.font=[UIFont systemFontOfSize:15];
                    CodeLabel.textColor=[UIColor darkGrayColor];
                    CodeLabel.textAlignment=NSTextAlignmentRight;
                    CodeLabel.adjustsFontSizeToFitWidth=YES;
                    CodeLabel.minimumScaleFactor=0.7;
                    CodeLabel.text=workingSales.productcode;
                    CodeLabel.tag=301;
                    [cell.contentView addSubview:CodeLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }else if (indexPath.section==1){
                if (indexPath.row==0){
                    ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
                    if (obj && ![obj.autorenew isEqualToString:@""]) {
                        salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 180, 21)];
                        salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                        salesgeneralLabel.textColor=[UIColor blackColor];
                        salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Auto Renew"];
                        salesgeneralLabel.tag=301;
                        [cell.contentView addSubview:salesgeneralLabel];
                        
                        salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                        salesgeneralLabel.font=[UIFont systemFontOfSize:15];
                        salesgeneralLabel.textColor=[UIColor darkGrayColor];
                        salesgeneralLabel.textAlignment=NSTextAlignmentRight;
                        salesgeneralLabel.text=[MyClass returntitlewithtitle:workingSales.autorenew];
                        salesgeneralLabel.tag=301;
                        [cell.contentView addSubview:salesgeneralLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }
            }else if (indexPath.section==2){
                if (indexPath.row==0) {
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Unit Price"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    UnitPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(212, 5, 75, 21)];
                    UnitPriceLabel.font=[UIFont systemFontOfSize:15];
                    UnitPriceLabel.textColor=[UIColor darkGrayColor];
                    UnitPriceLabel.textAlignment=NSTextAlignmentRight;
                    UnitPriceLabel.text=workingSales.price;
                    UnitPriceLabel.tag=310;
                    [cell.contentView addSubview:UnitPriceLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Quantity"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    QuantityLabel = [[UILabel alloc]initWithFrame:CGRectMake(208, 5, 79, 21)];
                    QuantityLabel.font=[UIFont systemFontOfSize:15];
                    QuantityLabel.textColor=[UIColor darkGrayColor];
                    QuantityLabel.textAlignment=NSTextAlignmentRight;
                    QuantityLabel.text=workingSales.quantity;
                    QuantityLabel.tag=311;
                    [cell.contentView addSubview:QuantityLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else if (indexPath.row==2){
                    ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
                    if (![obj.stockcount isEqualToString:@""] && ![workingSales.productcode isEqualToString:@""]) {
                        salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                        salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                        salesgeneralLabel.textColor=[UIColor blackColor];
                        salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Given Out"];
                        salesgeneralLabel.tag=301;
                        [cell.contentView addSubview:salesgeneralLabel];
                        
                        QuantityLabel = [[UILabel alloc]initWithFrame:CGRectMake(208, 5, 79, 21)];
                        QuantityLabel.font=[UIFont systemFontOfSize:15];
                        QuantityLabel.textColor=[UIColor darkGrayColor];
                        QuantityLabel.textAlignment=NSTextAlignmentRight;
                        QuantityLabel.text=workingSales.givenout;
                        QuantityLabel.tag=311;
                        [cell.contentView addSubview:QuantityLabel];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==3){
                    
                    
                    
                    
                    
                    
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Total Discount"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    DiscountLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 5, 97, 21)];
                    DiscountLabel.font=[UIFont systemFontOfSize:15];
                    DiscountLabel.textColor=[UIColor darkGrayColor];
                    DiscountLabel.textAlignment=NSTextAlignmentRight;
                    DiscountLabel.text=tmpTotalDiscount;// PopoverEnrollment.totalfee;
                    DiscountLabel.tag=312;
                    [cell.contentView addSubview:DiscountLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }else if (indexPath.row==4){
                    
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Total Price"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    TotalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 177, 21)];
                    TotalPriceLabel.font=[UIFont systemFontOfSize:15];
                    TotalPriceLabel.textColor=[UIColor darkGrayColor];
                    TotalPriceLabel.textAlignment=NSTextAlignmentRight;
                    TotalPriceLabel.text=workingSales.total;
                    TotalPriceLabel.tag=301;
                    [cell.contentView addSubview:TotalPriceLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==5){
                    
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Total Paid"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    TotalPaidLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 177, 21)];
                    TotalPaidLabel.font=[UIFont systemFontOfSize:15];
                    TotalPaidLabel.textColor=[UIColor darkGrayColor];
                    TotalPaidLabel.textAlignment=NSTextAlignmentRight;
                    TotalPaidLabel.text=workingSales.paid;
                    TotalPaidLabel.tag=312;
                    [cell.contentView addSubview:TotalPaidLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                    
                }
            }else if (indexPath.section==3){
                if (indexPath.row==0) {
                    RemarksLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 288, 150)];
                    RemarksLabel.font=[UIFont systemFontOfSize:17];
                    RemarksLabel.textColor=[UIColor blackColor];
                    RemarksLabel.text=workingSales.remarks;// PopoverEnrollment.remarks;
                    RemarksLabel.tag=301;
                    
                    RemarksLabel.numberOfLines=0;
                    RemarksLabel.adjustsFontSizeToFitWidth = YES;
                    RemarksLabel.lineBreakMode=NSLineBreakByWordWrapping| NSLineBreakByTruncatingTail;
                    RemarksLabel.minimumScaleFactor = 0.8;
                    
                    [cell.contentView addSubview:RemarksLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    [RemarksLabel sizeToFit];
                    CGRect myFrame=RemarksLabel.frame;
                    
                    if (myFrame.size.height>85) {
                        myFrame=CGRectMake(20, 5, 288, 150);
                    }else{
                        myFrame=CGRectMake(20, 5, 288, myFrame.size.height);
                    }
                    RemarksLabel.frame=myFrame;
                    
                }
            }else if (indexPath.section==4){
                if (indexPath.row==0) {
                    invoiceremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 288, 150)];
                    invoiceremarkslabel.font=[UIFont systemFontOfSize:17];
                    invoiceremarkslabel.textColor=[UIColor blackColor];
                    invoiceremarkslabel.text=workingSales.invoiceremarks;// PopoverEnrollment.remarks;
                    invoiceremarkslabel.tag=301;
                    
                    invoiceremarkslabel.numberOfLines=0;
                    invoiceremarkslabel.adjustsFontSizeToFitWidth = YES;
                    invoiceremarkslabel.lineBreakMode=NSLineBreakByWordWrapping| NSLineBreakByTruncatingTail;
                    invoiceremarkslabel.minimumScaleFactor = 0.8;
                    
                    [cell.contentView addSubview:invoiceremarkslabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    [invoiceremarkslabel sizeToFit];
                    CGRect myFrame=invoiceremarkslabel.frame;
                    
                    if (myFrame.size.height>85) {
                        myFrame=CGRectMake(20, 5, 288, 150);
                    }else{
                        myFrame=CGRectMake(20, 5, 288, myFrame.size.height);
                    }
                    invoiceremarkslabel.frame=myFrame;
                    
                }
            }else if (indexPath.section==5){
                salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 280, 35)];
                salesgeneralLabel.font=[UIFont systemFontOfSize:12];
                salesgeneralLabel.textColor=[UIColor darkGrayColor];
                salesgeneralLabel.text=[NSString stringWithFormat:@"SALES ID: %@",SalesObject.saleskey];
                salesgeneralLabel.textAlignment=NSTextAlignmentCenter;
                salesgeneralLabel.tag=301;
                cell.backgroundColor=[UIColor clearColor];
                [cell.contentView addSubview:salesgeneralLabel];
            }
        }else{// if([EnrollmentTableMode isEqualToString:@"Edit"] || [EnrollmentTableMode isEqualToString:@"Add"]){
            //if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            if (indexPath.section==0) {
                if (indexPath.row==0) {
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 150, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Order Date"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    OrderDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    OrderDateLabel.font=[UIFont systemFontOfSize:15];
                    OrderDateLabel.textColor=[UIColor darkGrayColor];
                    OrderDateLabel.textAlignment=NSTextAlignmentRight;
                    OrderDateLabel.text=[MyClass returndateformatwithdate:workingSales.orderdate];
                    
                    OrderDateLabel.tag=301;
                    [cell.contentView addSubview:OrderDateLabel];
                    if (![SalesObject.status isEqualToString:@"Voided"]) {
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }
                    
                }else if (indexPath.row==1){
                    if (showOrderDatePicker==YES) {
                        
                        CalendarView *calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, 320, 200) Theme:0 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil  UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
                        [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:workingSales.orderdate,nil] ScrollToDate:nil instructorselected:nil];
                        calendarview.delegate=self;
                        [cell.contentView addSubview:calendarview];
                        
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                    
                    
                }else if (indexPath.row==2){
                    
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 32)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Category"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    CategoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 0, 197, 32)];
                    CategoryLabel.font=[UIFont systemFontOfSize:15];
                    CategoryLabel.textColor=[UIColor darkGrayColor];
                    CategoryLabel.adjustsFontSizeToFitWidth=YES;
                    CategoryLabel.minimumScaleFactor=0.5;
                    CategoryLabel.numberOfLines=0;
                    CategoryLabel.textAlignment=NSTextAlignmentRight;
                    CategoryLabel.text=workingSales.productcategory;
                    
                    CategoryLabel.tag=301;
                    [cell.contentView addSubview:CategoryLabel];
                    if (![SalesObject.status isEqualToString:@"Voided"] && (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).changesalesproduct|| [SalesTableMode isEqualToString:@"Add"])) {
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }
                    
                }else if (indexPath.row==3){
                    
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 32)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Product"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    ProductLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 0, 187, 32)];
                    ProductLabel.font=[UIFont systemFontOfSize:15];
                    ProductLabel.textColor=[UIColor darkGrayColor];
                    ProductLabel.adjustsFontSizeToFitWidth=YES;
                    ProductLabel.minimumScaleFactor=0.5;
                    ProductLabel.numberOfLines=0;
                    ProductLabel.textAlignment=NSTextAlignmentRight;
                    ProductLabel.text=workingSales.productfullname;
                    
                    ProductLabel.tag=301;
                    [cell.contentView addSubview:ProductLabel];
                    if (![SalesObject.status isEqualToString:@"Voided"] && (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).changesalesproduct|| [SalesTableMode isEqualToString:@"Add"])) {
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }else{
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }
                    
                }else if (indexPath.row==4){
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 150, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Code"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    CodeLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 7, 127, 21)];
                    CodeLabel.font=[UIFont systemFontOfSize:15];
                    CodeLabel.textColor=[UIColor darkGrayColor];
                    CodeLabel.textAlignment=NSTextAlignmentRight;
                    CodeLabel.text=workingSales.productcode;
                    
                    ProductLabel.tag=301;
                    [cell.contentView addSubview:CodeLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
            }else if (indexPath.section==1){
                if (indexPath.row==0){
                    ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
                    if (obj && ![obj.autorenew isEqualToString:@""]) {
                        salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 170, 21)];
                        salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                        salesgeneralLabel.textColor=[UIColor blackColor];
                        salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Auto Renew"];
                        salesgeneralLabel.tag=301;
                        [cell.contentView addSubview:salesgeneralLabel];
                        
                        
                        UISwitch * swAutoRenew = [[UISwitch alloc] init];
                        swAutoRenew.onTintColor=themecolor;
                        CGSize switchSize = [swAutoRenew sizeThatFits:CGSizeZero];
                        swAutoRenew.frame = CGRectMake(242.0f,1.8f,switchSize.width,switchSize.height);
                        swAutoRenew.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
                        swAutoRenew.tag = 501;
                        [swAutoRenew addTarget:self action:@selector(switchautorenew:) forControlEvents:UIControlEventValueChanged];
                        
                        if ([workingSales.autorenew isEqualToString:@"Yes"]) {
                            swAutoRenew.on=YES;
                        }else{
                            swAutoRenew.on=NO;
                        }
                        
                        if ([workingSales.status isEqualToString:@"Voided"]) {
                            swAutoRenew.enabled=FALSE;
                        }
                        
                        [cell.contentView addSubview:swAutoRenew];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }
            }else if (indexPath.section==2){
                if (indexPath.row==0) {
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Unit Price"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    UnitPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(160, 5, 127, 21)];
                    UnitPriceLabel.font=[UIFont systemFontOfSize:15];
                    UnitPriceLabel.textColor=[UIColor darkGrayColor];
                    UnitPriceLabel.textAlignment=NSTextAlignmentRight;
                    UnitPriceLabel.text=workingSales.price;
                    UnitPriceLabel.tag=310;
                    [cell.contentView addSubview:UnitPriceLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==1){
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Quantity"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    if (![SalesObject.status isEqualToString:@"Voided"]) {
                        QuantityText = [[UITextField alloc]initWithFrame:CGRectMake(197, 4, 97, 27)];
                        QuantityText.font=[UIFont systemFontOfSize:15];
                        QuantityText.textColor=[UIColor darkGrayColor];
                        QuantityText.textAlignment=NSTextAlignmentRight;
                        QuantityText.keyboardType = UIKeyboardTypeNumberPad;
                        QuantityText.text=workingSales.quantity;
                        QuantityText.borderStyle = UITextBorderStyleRoundedRect;
                        QuantityText.placeholder=[MyClass returntitlewithtitle:@"Quantity"];
                        [QuantityText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                        [cell.contentView addSubview:QuantityText];
                    }else{
                        QuantityLabel = [[UILabel alloc]initWithFrame:CGRectMake(208, 5, 79, 21)];
                        QuantityLabel.font=[UIFont systemFontOfSize:15];
                        QuantityLabel.textColor=[UIColor darkGrayColor];
                        QuantityLabel.textAlignment=NSTextAlignmentRight;
                        QuantityLabel.text=workingSales.quantity;
                        QuantityLabel.tag=311;
                        [cell.contentView addSubview:QuantityLabel];
                    }
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==2){
                    ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
                    if (![obj.stockcount isEqualToString:@""] && ![workingSales.productcode isEqualToString:@""]) {
                        
                        salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 118, 21)];
                        salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                        salesgeneralLabel.textColor=[UIColor blackColor];
                        salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Given Out"];
                        salesgeneralLabel.tag=301;
                        [cell.contentView addSubview:salesgeneralLabel];
                        
                        if (![SalesObject.status isEqualToString:@"Voided"]) {
                            GivenOutText = [[UITextField alloc]initWithFrame:CGRectMake(197, 4, 97, 27)];
                            GivenOutText.font=[UIFont systemFontOfSize:15];
                            GivenOutText.textColor=[UIColor darkGrayColor];
                            GivenOutText.textAlignment=NSTextAlignmentRight;
                            GivenOutText.keyboardType = UIKeyboardTypeNumberPad;
                            GivenOutText.text=workingSales.givenout;
                            GivenOutText.borderStyle = UITextBorderStyleRoundedRect;
                            GivenOutText.placeholder=[MyClass returntitlewithtitle:@"Given Out"];
                            [GivenOutText addTarget:self action:@selector(updatetextfield:) forControlEvents:UIControlEventEditingChanged];
                            [cell.contentView addSubview:GivenOutText];
                        }else{
                            QuantityLabel = [[UILabel alloc]initWithFrame:CGRectMake(208, 5, 79, 21)];
                            QuantityLabel.font=[UIFont systemFontOfSize:15];
                            QuantityLabel.textColor=[UIColor darkGrayColor];
                            QuantityLabel.textAlignment=NSTextAlignmentRight;
                            QuantityLabel.text=workingSales.givenout;
                            QuantityLabel.tag=311;
                            [cell.contentView addSubview:QuantityLabel];
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.hidden=YES;
                    }
                }else if (indexPath.row==3){
//                    Student *student=[MyClass returnstudentwithstudentkey:workingSales.studentkey];
                    if(availablecouponarray.count>0){
                        UIImageView *dotimage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 2, 10, 10)];
                        [dotimage setBackgroundColor:[UIColor orangeColor]];
                        dotimage.layer.cornerRadius=5;
                        dotimage.layer.masksToBounds=YES;
                        [cell.contentView addSubview:dotimage];
                    }
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Total Discount"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    DiscountLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 5, 97, 21)];
                    DiscountLabel.font=[UIFont systemFontOfSize:15];
                    DiscountLabel.textColor=[UIColor darkGrayColor];
                    DiscountLabel.textAlignment=NSTextAlignmentRight;
                    DiscountLabel.text=tmpTotalDiscount;// PopoverEnrollment.totalfee;
                    DiscountLabel.tag=312;
                    [cell.contentView addSubview:DiscountLabel];
                    
                    
                    //if (![SalesObject.status isEqualToString:@"Voided"]) {
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    /*}else{
                        cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    }*/
                }else if (indexPath.row==4){
                    
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Total Price"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    TotalPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 177, 21)];
                    TotalPriceLabel.font=[UIFont systemFontOfSize:15];
                    TotalPriceLabel.textColor=[UIColor darkGrayColor];
                    TotalPriceLabel.textAlignment=NSTextAlignmentRight;
                    TotalPriceLabel.text=workingSales.total;
                    TotalPriceLabel.tag=310;
                    [cell.contentView addSubview:TotalPriceLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==5){
                    
                    salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 21)];
                    salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                    salesgeneralLabel.textColor=[UIColor blackColor];
                    salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Total Paid"];
                    salesgeneralLabel.tag=301;
                    [cell.contentView addSubview:salesgeneralLabel];
                    
                    TotalPaidLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 5, 177, 21)];
                    TotalPaidLabel.font=[UIFont systemFontOfSize:15];
                    TotalPaidLabel.textColor=[UIColor darkGrayColor];
                    TotalPaidLabel.textAlignment=NSTextAlignmentRight;
                    TotalPaidLabel.text=workingSales.paid;
                    TotalPaidLabel.tag=310;
                    [cell.contentView addSubview:TotalPaidLabel];
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    
                }
            }else if (indexPath.section==3){
                if (indexPath.row==0) {
                    RemarksText=[[UITextView alloc]initWithFrame:CGRectMake(20, 0, 288, 65)];
                    RemarksText.font=[UIFont systemFontOfSize:15];
                    RemarksText.textColor=[UIColor blackColor];
                    RemarksText.text=workingSales.remarks;
                    RemarksText.delegate=self;
                    RemarksText.tag=403;
                    [cell.contentView addSubview:RemarksText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
            }else if (indexPath.section==4){
                if (indexPath.row==0) {
                    invoiceremarksText=[[UITextView alloc]initWithFrame:CGRectMake(20, 0, 288, 65)];
                    invoiceremarksText.font=[UIFont systemFontOfSize:15];
                    invoiceremarksText.textColor=[UIColor blackColor];
                    invoiceremarksText.text=workingSales.invoiceremarks;
                    invoiceremarksText.delegate=self;
                    invoiceremarksText.tag=403;
                    [cell.contentView addSubview:invoiceremarksText];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
            }else{
                if (indexPath.row==0) {
                    
                    UIButton *VoidEnrollmentBtn=[[UIButton alloc]init];
                    VoidEnrollmentBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    VoidEnrollmentBtn.frame=CGRectMake(2, 2.5, 157, 30);
                    VoidEnrollmentBtn.layer.cornerRadius=4;
                    VoidEnrollmentBtn.layer.masksToBounds=YES;
                    VoidEnrollmentBtn.titleLabel.font=[UIFont systemFontOfSize:15];
                    
                    
                    VoidEnrollmentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    
                    VoidEnrollmentBtn.tag=701;
                    
                    if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).voidsales && ![SalesObject.productcode isEqualToString:@"FPAY"] && [SalesObject.status isEqualToString:@"Voided"]){
                        VoidEnrollmentBtn.enabled=YES;
                        [VoidEnrollmentBtn setBackgroundImage:[UIImage imageNamed:@"tiffany_background.png"] forState:UIControlStateNormal];
                        [VoidEnrollmentBtn setTitleColor:[UIColor systemGroupedBackgroundColor] forState:UIControlStateNormal];
                        [VoidEnrollmentBtn addTarget: self action:@selector(cancelVoidSalesPressed) forControlEvents: UIControlEventTouchUpInside];
                        [VoidEnrollmentBtn setTitle:[MyClass returntitlewithtitle:@"Cancel Void"] forState:UIControlStateNormal];
                    }else if (!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).voidsales || [SalesObject.productcode isEqualToString:@"FPAY"] || workingSales.paymentrecords.count==0 || [SalesObject.status isEqualToString:@"Voided"]){
                        VoidEnrollmentBtn.enabled=NO;
                        [VoidEnrollmentBtn setBackgroundImage:[UIImage imageNamed:@"gray_background.png"] forState:UIControlStateNormal];
                        [VoidEnrollmentBtn setTitleColor:[UIColor systemGroupedBackgroundColor] forState:UIControlStateNormal];
                        [VoidEnrollmentBtn setTitle:[MyClass returntitlewithtitle:@"Void"] forState:UIControlStateNormal];
                    }else{
                        VoidEnrollmentBtn.enabled=YES;
                        [VoidEnrollmentBtn setBackgroundImage:[UIImage imageNamed:@"tiffany_background.png"] forState:UIControlStateNormal];
                        [VoidEnrollmentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [VoidEnrollmentBtn addTarget: self action:@selector(showVoidEnrollmentWindow) forControlEvents: UIControlEventTouchUpInside];
                        [VoidEnrollmentBtn setTitle:[MyClass returntitlewithtitle:@"Void"] forState:UIControlStateNormal];
                    }
                    
                    
                    [cell.contentView addSubview:VoidEnrollmentBtn];
                    
                    
                    
                    DeleteOrderButton=[[UIButton alloc]init];
                    DeleteOrderButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                    DeleteOrderButton.frame=CGRectMake(2+157+2, 2.5, 157, 30);
                    DeleteOrderButton.layer.cornerRadius=4;
                    DeleteOrderButton.layer.masksToBounds=YES;
                    DeleteOrderButton.titleLabel.font=[UIFont systemFontOfSize:15];
                    [DeleteOrderButton setTitle:[MyClass returntitlewithtitle:@"Delete"] forState:UIControlStateNormal];
                    
                    DeleteOrderButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
                    [DeleteOrderButton addTarget: self action:@selector(deleteOrderRecord:) forControlEvents: UIControlEventTouchUpInside];
                    DeleteOrderButton.tag=701;
                    
                    if (!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).deletesales || [SalesObject.productcode isEqualToString:@"FPAY"] || workingSales.paymentrecords.count>0 || [SalesObject.status isEqualToString:@"Voided"]){
                        DeleteOrderButton.enabled=NO;
                        //[DeleteEnrollmentBtn setTitle:[MyClass returntitlewithtitle:@"Delete Enrollment Record (Disabled)"] forState:UIControlStateNormal];
                        [DeleteOrderButton setBackgroundImage:[UIImage imageNamed:@"gray_background.png"] forState:UIControlStateNormal];
                        [DeleteOrderButton setTitleColor:[UIColor systemGroupedBackgroundColor] forState:UIControlStateNormal];
                    }else{
                        DeleteOrderButton.enabled=YES;
                        //[DeleteEnrollmentBtn setTitle:[MyClass returntitlewithtitle:@"Delete Enrollment Record"] forState:UIControlStateNormal];
                        [DeleteOrderButton setBackgroundImage:[UIImage imageNamed:@"red_background.png"] forState:UIControlStateNormal];
                        [DeleteOrderButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    }
                    
                    [cell.contentView addSubview:DeleteOrderButton];


                }
            }
        }
        
    }else if (tableView==DetailsPaymentTable){
        [df setDateFormat:@"dd-MMM-yyyy"];
        
        //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (indexPath.section==0) {
            if ([DetailsPaymentTableMode isEqualToString:@"Edit"]) {
                PaymentRecord *DetailsPaymentObject=[workingSales.paymentrecords objectAtIndex:DetailsPaymentObjectIndex];
                if (indexPath.row==0) {
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                    detailspaymentLabel.textColor=[UIColor blackColor];
                    detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Paid Method"];
                    detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    paidmethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailpaymentwidth-150, 7, 118, 21)];
                    paidmethodLabel.font=[UIFont systemFontOfSize:14];
                    paidmethodLabel.textColor=[UIColor darkGrayColor];
                    paidmethodLabel.textAlignment=NSTextAlignmentRight;
                    paidmethodLabel.text=[MyClass returntitlewithtitle:DetailsPaymentObject.paidmethod];
                    paidmethodLabel.tag=805;
                    [cell.contentView addSubview:paidmethodLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                }else if (indexPath.row==1){
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                    detailspaymentLabel.textColor=[UIColor blackColor];
                    detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Paid Date"];
                    detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    paiddateLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailpaymentwidth-150, 7, 118, 21)];
                    paiddateLabel.font=[UIFont systemFontOfSize:14];
                    paiddateLabel.textColor=[UIColor darkGrayColor];
                    paiddateLabel.textAlignment=NSTextAlignmentRight;
                    paiddateLabel.text=[MyClass returndateformatwithdate:DetailsPaymentObject.paiddate];
                    paiddateLabel.tag=805;
                    [cell.contentView addSubview:paiddateLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==2){
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                    detailspaymentLabel.textColor=[UIColor blackColor];
                    detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Paid Amount"];
                    detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailpaymentwidth-150, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:14];
                    detailspaymentLabel.textColor=[UIColor darkGrayColor];
                    detailspaymentLabel.textAlignment=NSTextAlignmentRight;
                    detailspaymentLabel.tag=806;
                    detailspaymentLabel.text=DetailsPaymentObject.paidamount;
                    [cell.contentView addSubview:detailspaymentLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==3) {
                    paymentremarksText=[[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(16, 0, detailpaymentwidth-40, 95)];
                    paymentremarksText.font=[UIFont systemFontOfSize:15];
                    paymentremarksText.textColor=[UIColor darkGrayColor];
                    paymentremarksText.placeholder=[MyClass returntitlewithtitle:@"Payment Remarks (Internal)"];
                    paymentremarksText.text=tmppaymentremarks;
                    paymentremarksText.delegate=self;
                    paymentremarksText.tag=403;
                    [cell.contentView addSubview:paymentremarksText];
                    
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==4) {
                    
                    receiptremarksText=[[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(16, 0, 260, 95)];
                    receiptremarksText.font=[UIFont systemFontOfSize:15];
                    receiptremarksText.textColor=[UIColor darkGrayColor];
                    receiptremarksText.placeholder=[MyClass returntitlewithtitle:@"Receipt Remarks (Print on receipt)"];
                    receiptremarksText.text=tmpreceiptremarks;
                    receiptremarksText.delegate=self;
                    //receiptremarksText.tag=403;
                    [cell.contentView addSubview:receiptremarksText];
                    
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
            }else if ([DetailsPaymentTableMode isEqualToString:@"View"] || [DetailsPaymentTableMode isEqualToString:@"Add"]){
                double totalpaid=0;
                
                if (indexPath.row==0) {
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                    detailspaymentLabel.textColor=[UIColor blackColor];
                    detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Total Price"];
                    detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    paymenttotalfeeLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailpaymentwidth-150, 7, 118, 21)];
                    paymenttotalfeeLabel.font=[UIFont systemFontOfSize:14];
                    paymenttotalfeeLabel.textColor=[UIColor darkGrayColor];
                    paymenttotalfeeLabel.textAlignment=NSTextAlignmentRight;
                    paymenttotalfeeLabel.text=[TotalPriceLabel.text isEqualToString:@""]?@"0":TotalPriceLabel.text;
                    paymenttotalfeeLabel.tag=801;
                    [cell.contentView addSubview:paymenttotalfeeLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                }else if (indexPath.row==1){
                    for (int k=0; k<workingSales.paymentrecords.count; k++) {
                        PaymentRecord *DetailsPaymentObject=[workingSales.paymentrecords objectAtIndex:k];
                        totalpaid+=[DetailsPaymentObject.paidamount doubleValue];
                    }
                    
                    
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                    detailspaymentLabel.textColor=[UIColor blackColor];
                    detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Total Paid"];
                    detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    paymenttotalpaidLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailpaymentwidth-150, 7, 118, 21)];
                    paymenttotalpaidLabel.font=[UIFont systemFontOfSize:14];
                    paymenttotalpaidLabel.textColor=[UIColor darkGrayColor];
                    paymenttotalpaidLabel.textAlignment=NSTextAlignmentRight;
                    paymenttotalpaidLabel.text=[NSString stringWithFormat:@"%g",totalpaid];
                    paymenttotalpaidLabel.tag=802;
                    [cell.contentView addSubview:paymenttotalpaidLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==2){
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                    detailspaymentLabel.textColor=[UIColor blackColor];
                    detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Outstanding"];
                    detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    paymentoutstandingLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailpaymentwidth-150, 7, 118, 21)];
                    paymentoutstandingLabel.font=[UIFont systemFontOfSize:14];
                    paymentoutstandingLabel.textColor=[UIColor darkGrayColor];
                    paymentoutstandingLabel.textAlignment=NSTextAlignmentRight;
                    paymentoutstandingLabel.text=[NSString stringWithFormat:@"%g",[paymenttotalfeeLabel.text doubleValue]-[paymenttotalpaidLabel.text doubleValue]];
                    paymentoutstandingLabel.tag=803;
                    [cell.contentView addSubview:paymentoutstandingLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
            }/*else if ([DetailsPaymentTableMode isEqualToString:@"EditInvoiceRemarks"]){
                invoiceremarksText=[[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(16, 0, detailpaymentwidth-32, 95)];
                invoiceremarksText.font=[UIFont systemFontOfSize:12];
                invoiceremarksText.textColor=[UIColor darkGrayColor];
                invoiceremarksText.placeholder=[MyClass returntitlewithtitle:@"Invoice Remarks"];
                invoiceremarksText.text=workingSales.invoiceremarks;
                invoiceremarksText.delegate=self;
                //invoiceremarksText.tag=403;
                [cell.contentView addSubview:invoiceremarksText];
            }*/
            
        }else{
            if ([DetailsPaymentTableMode isEqualToString:@"View"]) {
                if (indexPath.section==1) {
                    
                    //cell.textLabel.font=[UIFont systemFontOfSize:10.0];
                    long offset=0;
                    PaymentRecord *DetailsPaymentObject=[workingSales.paymentrecords objectAtIndex:indexPath.row];
                    
                    if(![SalesTableMode isEqualToString:@"View"] && ![SalesObject.status isEqualToString:@"Voided"]){
                        if ([DetailsPaymentObject.action isEqualToString:@"add"]) {
                            //new payment
                            UIButton *deletebutton=[[UIButton alloc]initWithFrame:CGRectMake(12, ([tableView rectForRowAtIndexPath:indexPath].size.height-20)/2, 20, 20)];
                            [deletebutton setImage:[UIImage imageNamed:@"deletebutton2.png"] forState:UIControlStateNormal];
                            deletebutton.tag=indexPath.row;
                            [deletebutton addTarget:self action:@selector(deletepaymentbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                            [cell.contentView addSubview:deletebutton];
                            
                            
                        }/*else if ([DetailsPaymentObject.action isEqualToString:@"edit"]) {
                          UIView *indicator = [[UIView alloc]initWithFrame:CGRectMake(7, 14, 7, 7)];
                          indicator.backgroundColor=[UIColor orangeColor];
                          indicator.layer.cornerRadius=3.5;
                          //indicator.tag=801;
                          [cell.contentView addSubview:indicator];
                          }*/else{
                              //reverse payment
                              UIButton *reversebutton=[[UIButton alloc]initWithFrame:CGRectMake(12, ([tableView rectForRowAtIndexPath:indexPath].size.height-20)/2, 20, 20)];
                              [reversebutton setImage:[UIImage imageNamed:@"deletebutton3.png"] forState:UIControlStateNormal];
                              reversebutton.tag=indexPath.row;
                              [reversebutton addTarget:self action:@selector(reversepaymentbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                              [cell.contentView addSubview:reversebutton];
                          }
                        offset=20;
                    }
                    

                    
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+offset, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:14];
                    detailspaymentLabel.textColor=[UIColor darkGrayColor];
                    detailspaymentLabel.text=[MyClass returndateformatwithdate:DetailsPaymentObject.paiddate];
                    //detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(130+offset, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:12];
                    detailspaymentLabel.textColor=[UIColor grayColor];
                    detailspaymentLabel.textAlignment=NSTextAlignmentLeft;
                    detailspaymentLabel.text=[MyClass returntitlewithtitle:DetailsPaymentObject.paidmethod];
                    //detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailpaymentwidth-150, 7, ([SalesTableMode isEqualToString:@"View"] || [SalesObject.status isEqualToString:@"Voided"])? 100: 118,21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:14];
                    detailspaymentLabel.textColor=[UIColor darkGrayColor];
                    detailspaymentLabel.textAlignment=NSTextAlignmentRight;
                    detailspaymentLabel.text=DetailsPaymentObject.paidamount;
                    //detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    //if (![DetailsPaymentObject.staffname isEqualToString:@""]) {
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20+offset, 28, 200,15)];
                        detailspaymentLabel.font=[UIFont systemFontOfSize:10];
                        detailspaymentLabel.textColor=[UIColor darkGrayColor];
                        detailspaymentLabel.text=[DetailsPaymentObject.staffname isEqualToString:@""]?[NSString stringWithFormat:@"(Ref:%@)",[DetailsPaymentObject.action isEqualToString:@"add"]?@"NA":[NSString stringWithFormat:@"%@", [MyClass returnreceiptreference:DetailsPaymentObject.paymentkey receiptnumber:DetailsPaymentObject.receiptnumber]]]:[NSString stringWithFormat:@"%@ (Ref:%@)",DetailsPaymentObject.staffname,[DetailsPaymentObject.action isEqualToString:@"add"]?@"NA":[NSString stringWithFormat:@"%@", [MyClass returnreceiptreference:DetailsPaymentObject.paymentkey receiptnumber:DetailsPaymentObject.receiptnumber]]];
                        
                    //}
                    
                    
                    if (![DetailsPaymentObject.paymentremarks isEqualToString:@""]) {
                        /*UIView *remarksseparator = [[UIView alloc]initWithFrame:CGRectMake(20, 35, 248, 1)];
                         remarksseparator.backgroundColor=[UIColor lightGrayColor];
                         remarksseparator.alpha=0.2;
                         [cell.contentView addSubview:remarksseparator];*/
                        
                        
                        UILabel *paymentremarkstitlelabel = [[UILabel alloc]initWithFrame:CGRectMake(20+offset, 50, 118, 20)];
                        paymentremarkstitlelabel.font=[UIFont systemFontOfSize:11];
                        paymentremarkstitlelabel.textColor=[UIColor blueColor];
                        paymentremarkstitlelabel.textAlignment=NSTextAlignmentLeft;
                        paymentremarkstitlelabel.text=[MyClass returntitlewithtitle:@"Remarks (Internal)"];
                        //detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:paymentremarkstitlelabel];
                        
                        
                        paymentremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20+offset, 0, 248, 100)];
                        paymentremarkslabel.font=[UIFont systemFontOfSize:12];
                        paymentremarkslabel.textColor=[UIColor darkGrayColor];
                        paymentremarkslabel.text=DetailsPaymentObject.paymentremarks;
                        paymentremarkslabel.numberOfLines=0;
                        [paymentremarkslabel sizeToFit];
                        CGRect myFrame=paymentremarkslabel.frame;
                        myFrame=CGRectMake(myFrame.origin.x, 50+20, 248, myFrame.size.height);
                        paymentremarkslabel.frame=myFrame;
                        
                        [cell.contentView addSubview:paymentremarkslabel];
                    }else{
                        paymentremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20+offset, 40, detailpaymentwidth-52, 0)];
                    }
                    
                    if (![DetailsPaymentObject.receiptremarks isEqualToString:@""]) {
                        
                        UILabel *receiptremarkstitlelabel = [[UILabel alloc]initWithFrame:CGRectMake(20+offset, paymentremarkslabel.frame.origin.y+paymentremarkslabel.frame.size.height+10, 200, 20)];
                        receiptremarkstitlelabel.font=[UIFont systemFontOfSize:11];
                        receiptremarkstitlelabel.textColor=[UIColor blueColor];
                        receiptremarkstitlelabel.textAlignment=NSTextAlignmentLeft;
                        receiptremarkstitlelabel.text=[MyClass returntitlewithtitle:@"Receipt Remarks (Print on receipt)"];
                        //detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:receiptremarkstitlelabel];
                        
                        
                        receiptremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20+offset, 0, detailpaymentwidth-52, 100)];
                        receiptremarkslabel.font=[UIFont systemFontOfSize:12];
                        receiptremarkslabel.textColor=[UIColor darkGrayColor];
                        receiptremarkslabel.text=DetailsPaymentObject.receiptremarks;
                        receiptremarkslabel.numberOfLines=0;
                        
                        [receiptremarkslabel sizeToFit];
                        CGRect myFrame=receiptremarkslabel.frame;
                        myFrame=CGRectMake(myFrame.origin.x, paymentremarkslabel.frame.origin.y+paymentremarkslabel.frame.size.height+20+10, detailpaymentwidth-52, myFrame.size.height);
                        receiptremarkslabel.frame=myFrame;
                        
                        [cell.contentView addSubview:receiptremarkslabel];
                    }
                    if ([SalesTableMode isEqualToString:@"View"] || [SalesObject.status isEqualToString:@"Voided"]) {
                        //cell.accessoryType=UITableViewCellAccessoryDetailButton;
                        
//                        if(![SalesObject.productcode isEqualToString:@"FPAY"]){
//                            UIButton *sharebutton=[[UIButton alloc]initWithFrame:CGRectMake(detailpaymentwidth-40-15, [tableView rectForRowAtIndexPath:indexPath].size.height/2-17.5, 35, 35)];
//                            [sharebutton setImageEdgeInsets:UIEdgeInsetsMake(5, 10, 5, 0)];
//                            [sharebutton addTarget:self action:@selector(paymentsharebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
//                            [sharebutton setImage:[UIImage imageNamed:@"sharebutton_blue.png"] forState:UIControlStateNormal];
//                            //[sharebutton setTitle:@"Previous" forState:UIControlStateNormal];
//                            [cell.contentView addSubview:sharebutton];
//                        }
                    }else{
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    
                }else if (indexPath.section==2){
                    invoiceremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 248, 100)];
                    invoiceremarkslabel.font=[UIFont systemFontOfSize:12];
                    invoiceremarkslabel.textColor=[UIColor darkGrayColor];
                    invoiceremarkslabel.text=workingSales.invoiceremarks;
                    invoiceremarkslabel.numberOfLines=0;
                    [invoiceremarkslabel sizeToFit];
                    CGRect myFrame=invoiceremarkslabel.frame;
                    if (myFrame.size.height>90) {
                        myFrame=CGRectMake(20, 10, 248, 90);
                    }else{
                        myFrame=CGRectMake(20, 10, 248, myFrame.size.height);
                    }
                    invoiceremarkslabel.frame=myFrame;
                    
                    [cell.contentView addSubview:invoiceremarkslabel];
                    
                    if ([SalesTableMode isEqualToString:@"View"]) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                }
            }else{// if ([DetailsPaymentTableMode isEqualToString:@"Add"]) {
                if (indexPath.section==1) {
                    if (indexPath.row==0){
                        if(globalvariables.centerrecord.enableaccountreceivablecodes){
                            detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                            detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                            detailspaymentLabel.textColor=[UIColor blackColor];
                            detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Account Code"];
                            detailspaymentLabel.tag=801;
                            [cell.contentView addSubview:detailspaymentLabel];
                            
                            paymentoutstandingLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailpaymentwidth-150, 7, 118, 21)];
                            paymentoutstandingLabel.font=[UIFont systemFontOfSize:14];
                            paymentoutstandingLabel.textColor=[UIColor darkGrayColor];
                            paymentoutstandingLabel.textAlignment=NSTextAlignmentRight;
                            paymentoutstandingLabel.text=[MyClass returnARCode];
                            paymentoutstandingLabel.tag=803;
                            [cell.contentView addSubview:paymentoutstandingLabel];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }else{
                            cell.hidden=YES;
                        }
                    }else if (indexPath.row==1) {
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                        detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                        detailspaymentLabel.textColor=[UIColor blackColor];
                        detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Paid Method"];
                        detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:detailspaymentLabel];
                        
                        paidmethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailpaymentwidth-150, 7, 118, 21)];
                        paidmethodLabel.font=[UIFont systemFontOfSize:14];
                        paidmethodLabel.textColor=[UIColor darkGrayColor];
                        paidmethodLabel.textAlignment=NSTextAlignmentRight;
                        paidmethodLabel.text=[MyClass returntitlewithtitle:tmppaidmethod];
                        paidmethodLabel.tag=805;
                        [cell.contentView addSubview:paidmethodLabel];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        
                    }else if (indexPath.row==2){
                        if (showPaidMethodPicker==YES) {
                            pickerViewmenu =[[NSMutableArray alloc]initWithArray:[MyClass returnPaidMethodArray]];
                            
                            if ([pickerViewmenu containsObject:tmppaidmethod]) {
                                presetRow=(int)[pickerViewmenu indexOfObject:tmppaidmethod];
                            }else{
                                presetRow=0;
                            }
                            
                            UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                            UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                            [myPicker setDataSource:self];
                            [myPicker setDelegate:self];
                            myPicker.tag=802;
                            
                            [myPicker selectRow:presetRow inComponent:0 animated:NO];
                            [myPicker setShowsSelectionIndicator:YES];
                            myPickerView=myPicker;
                            [datepickerview addSubview:myPicker];
                            
                            
                            [cell.contentView addSubview:datepickerview];
                        }else{
                            cell.hidden=YES;
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else if (indexPath.row==3){
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                        detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                        detailspaymentLabel.textColor=[UIColor blackColor];
                        detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Paid Date"];
                        detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:detailspaymentLabel];
                        
                        paiddateLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailpaymentwidth-150, 7, 118, 21)];
                        paiddateLabel.font=[UIFont systemFontOfSize:14];
                        paiddateLabel.textColor=[UIColor darkGrayColor];
                        paiddateLabel.textAlignment=NSTextAlignmentRight;
                        paiddateLabel.text=[MyClass returndateformatwithdate:tmpPaidDate];
                        paiddateLabel.tag=805;
                        [cell.contentView addSubview:paiddateLabel];
                        cell.accessoryType = ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editpaiddate?UITableViewCellAccessoryDisclosureIndicator:UITableViewCellAccessoryNone;
                        
                    }else if (indexPath.row==4){
                        if (showPaymentDatePicker==YES) {
                            
                            CalendarView *calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, detailpaymentwidth, 200) Theme:0 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil  UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"paiddate" disablecalendar:FALSE];
                            [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:tmpPaidDate,nil] ScrollToDate:nil instructorselected:nil];
                            calendarview.delegate=self;
                            
                            [cell.contentView addSubview:calendarview];
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }else{
                            cell.hidden=YES;
                        }
                        
                        
                        
                    }else if (indexPath.row==5){
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                        detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                        detailspaymentLabel.textColor=[UIColor blackColor];
                        detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Paid Amount"];
                        detailspaymentLabel.tag=801;
                        [detailspaymentLabel sizeToFit];
                        CGRect myFrame=detailspaymentLabel.frame;
                        detailspaymentLabel.frame=CGRectMake(20, 0, myFrame.size.width, [tableView rectForRowAtIndexPath:indexPath].size.height);
                        [cell.contentView addSubview:detailspaymentLabel];
                        
                        //add override button
                        if ([globalvariables.centerrecord.defaulteditablepaymentamount isEqualToString:@"No"]) {
                            UIButton *overridebutton=[[UIButton alloc]initWithFrame:CGRectMake(detailspaymentLabel.frame.origin.x+detailspaymentLabel.frame.size.width+10, [tableView rectForRowAtIndexPath:indexPath].size.height/2-11, 22, 22)];
                            [overridebutton addTarget:self action:@selector(overridebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                            [overridebutton setImage:[UIImage imageNamed:@"paymentoverridebutton.png"] forState:UIControlStateNormal];
                            if (paymentoverride) {
                                overridebutton.enabled=NO;
                            }else{
                                overridebutton.enabled=YES;
                            }
                            [cell.contentView addSubview:overridebutton];
                        }
                        
                        detailspaymentText = [[UITextField alloc]initWithFrame:CGRectMake(detailpaymentwidth-150, 7, 118, 21)];
                        detailspaymentText.font=[UIFont systemFontOfSize:14];
                        detailspaymentText.textColor=[UIColor darkGrayColor];
                        detailspaymentText.textAlignment=NSTextAlignmentRight;
                        detailspaymentText.keyboardType = UIKeyboardTypeDecimalPad;
                        detailspaymentText.placeholder=[MyClass returntitlewithtitle:@"Paid Amount"];
                        detailspaymentText.clearButtonMode = UITextFieldViewModeWhileEditing;
                        detailspaymentText.tag=806;
                        detailspaymentText.delegate=self;
                        detailspaymentText.text=tmppaidamount;
                        [detailspaymentText addTarget:self action:@selector(checkdetailspaymentvalue:)forControlEvents:UIControlEventEditingChanged];
                        
                        
                        
                        [cell.contentView addSubview:detailspaymentText];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        if (paymentoverride) {
                            [detailspaymentText becomeFirstResponder];
                        }
                        
                    }else if (indexPath.row==6) {
                        paymentremarksText=[[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(16, 0, detailpaymentwidth-40, 95)];
                        paymentremarksText.font=[UIFont systemFontOfSize:15];
                        paymentremarksText.textColor=[UIColor darkGrayColor];
                        paymentremarksText.placeholder=[MyClass returntitlewithtitle:@"Payment Remarks (Internal)"];
                        paymentremarksText.text=tmppaymentremarks;
                        paymentremarksText.delegate=self;
                        paymentremarksText.tag=403;
                        [cell.contentView addSubview:paymentremarksText];
                        
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }else if (indexPath.row==7) {
                        
                        receiptremarksText=[[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(16, 0, detailpaymentwidth-40, 95)];
                        receiptremarksText.font=[UIFont systemFontOfSize:15];
                        receiptremarksText.textColor=[UIColor darkGrayColor];
                        receiptremarksText.placeholder=[MyClass returntitlewithtitle:@"Receipt Remarks (Print on receipt)"];
                        receiptremarksText.text=tmpreceiptremarks;
                        receiptremarksText.delegate=self;
                        //receiptremarksText.tag=403;
                        [cell.contentView addSubview:receiptremarksText];
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }
                    
                }
                
                if (workingSales.paymentrecords.count>0) {
                    if (indexPath.section==2) {
                        PaymentRecord *DetailsPaymentObject=[workingSales.paymentrecords objectAtIndex:indexPath.row];
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                        detailspaymentLabel.font=[UIFont systemFontOfSize:14];
                        detailspaymentLabel.textColor=[UIColor darkGrayColor];
                        detailspaymentLabel.text=[MyClass returndateformatwithdate:DetailsPaymentObject.paiddate];
                        detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:detailspaymentLabel];
                        
                        
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailpaymentwidth-150, 7, 118, 21)];
                        detailspaymentLabel.font=[UIFont systemFontOfSize:12];
                        detailspaymentLabel.textColor=[UIColor grayColor];
                        detailspaymentLabel.textAlignment=NSTextAlignmentLeft;
                        detailspaymentLabel.text=[MyClass returntitlewithtitle:DetailsPaymentObject.paidmethod];
                        detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:detailspaymentLabel];
                        
                        
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(detailpaymentwidth-150, 7, 118, 21)];
                        detailspaymentLabel.font=[UIFont systemFontOfSize:14];
                        detailspaymentLabel.textColor=[UIColor darkGrayColor];
                        detailspaymentLabel.textAlignment=NSTextAlignmentRight;
                        detailspaymentLabel.text=DetailsPaymentObject.paidamount;
                        detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:detailspaymentLabel];
                        
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 28, 200,15)];
                        detailspaymentLabel.font=[UIFont systemFontOfSize:10];
                        detailspaymentLabel.textColor=[UIColor darkGrayColor];
                        detailspaymentLabel.text=[DetailsPaymentObject.staffname isEqualToString:@""]?[NSString stringWithFormat:@"(Ref:%@)",[MyClass returnreceiptreference:DetailsPaymentObject.paymentkey receiptnumber:DetailsPaymentObject.receiptnumber]]:[NSString stringWithFormat:@"%@ (Ref:%@)",DetailsPaymentObject.staffname,[MyClass returnreceiptreference:DetailsPaymentObject.paymentkey receiptnumber:DetailsPaymentObject.receiptnumber]];
                        [cell.contentView addSubview:detailspaymentLabel];
                        
                        //DetailsPaymentObject=[DetailsPaymentArray objectAtIndex:indexPath.row];
                        //if ([DetailsPaymentObject.action isEqualToString:@"delete"]) {
                        //    cell.hidden=YES;
                        //}
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        if (![DetailsPaymentObject.paymentremarks isEqualToString:@""]) {
                            /*UIView *remarksseparator = [[UIView alloc]initWithFrame:CGRectMake(20, 35, 248, 1)];
                             remarksseparator.backgroundColor=[UIColor lightGrayColor];
                             remarksseparator.alpha=0.2;
                             [cell.contentView addSubview:remarksseparator];*/
                            
                            
                            UILabel *paymentremarkstitlelabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 118, 20)];
                            paymentremarkstitlelabel.font=[UIFont systemFontOfSize:11];
                            paymentremarkstitlelabel.textColor=[UIColor blueColor];
                            paymentremarkstitlelabel.textAlignment=NSTextAlignmentLeft;
                            paymentremarkstitlelabel.text=[MyClass returntitlewithtitle:@"Remarks (Internal)"];
                            //detailspaymentLabel.tag=801;
                            [cell.contentView addSubview:paymentremarkstitlelabel];
                            
                            
                            paymentremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, detailpaymentwidth-52, 100)];
                            paymentremarkslabel.font=[UIFont systemFontOfSize:12];
                            paymentremarkslabel.textColor=[UIColor darkGrayColor];
                            paymentremarkslabel.text=DetailsPaymentObject.paymentremarks;
                            paymentremarkslabel.numberOfLines=0;
                            [paymentremarkslabel sizeToFit];
                            CGRect myFrame=paymentremarkslabel.frame;
                            myFrame=CGRectMake(myFrame.origin.x, 50+20, 248, myFrame.size.height);
                            paymentremarkslabel.frame=myFrame;
                            
                            [cell.contentView addSubview:paymentremarkslabel];
                        }else{
                            paymentremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, detailpaymentwidth-52, 0)];
                        }
                        
                        if (![DetailsPaymentObject.receiptremarks isEqualToString:@""]) {
                            
                            /*UIView *remarksseparator = [[UIView alloc]initWithFrame:CGRectMake(20, paymentremarkslabel.frame.origin.y+paymentremarkslabel.frame.size.height+10, 248, 1)];
                             remarksseparator.backgroundColor=[UIColor lightGrayColor];
                             remarksseparator.alpha=0.2;
                             [cell.contentView addSubview:remarksseparator];*/
                            
                            UILabel *receiptremarkstitlelabel = [[UILabel alloc]initWithFrame:CGRectMake(20, paymentremarkslabel.frame.origin.y+paymentremarkslabel.frame.size.height+10, 200, 20)];
                            receiptremarkstitlelabel.font=[UIFont systemFontOfSize:11];
                            receiptremarkstitlelabel.textColor=[UIColor blueColor];
                            receiptremarkstitlelabel.textAlignment=NSTextAlignmentLeft;
                            receiptremarkstitlelabel.text=[MyClass returntitlewithtitle:@"Receipt Remarks (Print on receipt)"];
                            //detailspaymentLabel.tag=801;
                            [cell.contentView addSubview:receiptremarkstitlelabel];
                            
                            receiptremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, detailpaymentwidth-52, 100)];
                            receiptremarkslabel.font=[UIFont systemFontOfSize:12];
                            receiptremarkslabel.textColor=[UIColor darkGrayColor];
                            receiptremarkslabel.text=DetailsPaymentObject.receiptremarks;
                            receiptremarkslabel.numberOfLines=0;
                            
                            [receiptremarkslabel sizeToFit];
                            CGRect myFrame=receiptremarkslabel.frame;
                            myFrame=CGRectMake(myFrame.origin.x, paymentremarkslabel.frame.origin.y+paymentremarkslabel.frame.size.height+20+10, detailpaymentwidth-52, myFrame.size.height);
                            receiptremarkslabel.frame=myFrame;
                            
                            [cell.contentView addSubview:receiptremarkslabel];
                        }
                    }
                }
            }
        }
    }else if (tableView==CategoryTable){
        //UITableViewCell *cell;
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        UILabel *name;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            name = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, categorytablewidth-100-30, 38)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1201;
            name.minimumScaleFactor=0.7;
            name.numberOfLines=0;
            name.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:name];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(categorytablewidth-45, 7, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1201];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
        }
        name.text=[filteredCategoryArray objectAtIndex:indexPath.row];
        selected.hidden=[name.text isEqualToString:workingSales.productcategory]?NO:YES;
        
    }else if (tableView==ProductTable){
        //UITableViewCell *cell;
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        UILabel *name;
        UILabel *stockcount;
        UIImageView *productimage;
        UIImageView *selected;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            
            name = [[UILabel alloc]initWithFrame:CGRectMake(55, 0, producttablewidth-45-55, 32)];
            name.font=[UIFont systemFontOfSize:15];
            name.textColor=[UIColor darkGrayColor];
            name.tag=1201;
            name.minimumScaleFactor=0.7;
            name.numberOfLines=0;
            name.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:name];
            
            stockcount = [[UILabel alloc]initWithFrame:CGRectMake(55, 25, producttablewidth-45-55, 20)];
            stockcount.font=[UIFont systemFontOfSize:11];
            stockcount.textColor=[UIColor darkGrayColor];
            stockcount.tag=1204;
            stockcount.minimumScaleFactor=0.7;
            stockcount.numberOfLines=0;
            stockcount.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:stockcount];
            
            selected = [[UIImageView alloc]initWithFrame:CGRectMake(producttablewidth-45, 13, 24, 24)];
            [selected setImage:[UIImage imageNamed:@"checked_icon.png"]];
            selected.tag=1202;
            [cell.contentView addSubview:selected];
            
            productimage = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 40, 40)];
            [productimage setImage:[UIImage imageNamed:@"product_gray_small.png"]];
            productimage.layer.masksToBounds=YES;
            productimage.layer.cornerRadius=20;
            productimage.contentMode=UIViewContentModeScaleAspectFill;
            productimage.tag=1203;
            [cell.contentView addSubview:productimage];
        }else{
            name=(UILabel *)[cell.contentView viewWithTag:1201];
            selected=(UIImageView *)[cell.contentView viewWithTag:1202];
            productimage=(UIImageView *)[cell.contentView viewWithTag:1203];
            stockcount=(UILabel *)[cell.contentView viewWithTag:1204];
        }
        
        ProductRecord *obj=[filteredProductArray objectAtIndex:indexPath.row];
        
        [MyClass downloadImageWithImageview:productimage gender:nil type:@"product" typekey:obj.code image:@"Yes" async:YES];
        name.text=[MyClass returnproductnamewithproductcode:obj.code centerkey:globalvariables.centerrecord.centerkey];
        stockcount.text=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"Stock count"],obj.stockcount];
        if ([obj.stockcount integerValue]<0) {
            stockcount.textColor=[UIColor redColor];
        }else{
            stockcount.textColor=[UIColor darkGrayColor];
        }
        if([obj.stockcount isEqualToString:@""]){
            name.frame=CGRectMake(55, 0, producttablewidth-45-55, 50);
            stockcount.hidden=YES;
        }else{
            name.frame=CGRectMake(55, 0, producttablewidth-45-55, 32);
            stockcount.hidden=NO;
        }
        selected.hidden=[obj.code isEqualToString:workingSales.productcode]?NO:YES;
        
    }else if (tableView==VoidTable){
        //UITableViewCell *cell;
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        //cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        
        if (indexPath.row==0) {
            detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 118, 35)];
            detailspaymentLabel.font=[UIFont systemFontOfSize:15];
            detailspaymentLabel.textColor=[UIColor blackColor];
            detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Total Paid"];
            detailspaymentLabel.tag=801;
            [cell.contentView addSubview:detailspaymentLabel];
            
            VoidTotalPaidLabel = [[UILabel alloc]initWithFrame:CGRectMake(140, 0, 127, 35)];
            VoidTotalPaidLabel.font=[UIFont systemFontOfSize:16];
            VoidTotalPaidLabel.textAlignment=NSTextAlignmentRight;
            VoidTotalPaidLabel.textColor=[UIColor darkGrayColor];
            VoidTotalPaidLabel.text=[NSString stringWithFormat:@"%g", [workingSales.paid floatValue]];
            [cell.contentView addSubview:VoidTotalPaidLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }else if (indexPath.row==1) {
            detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 118, 35)];
            detailspaymentLabel.font=[UIFont systemFontOfSize:15];
            detailspaymentLabel.textColor=[UIColor blackColor];
            detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Refund Amount"];
            detailspaymentLabel.tag=801;
            [cell.contentView addSubview:detailspaymentLabel];
            
            RefundAmountText = [[UITextField alloc]initWithFrame:CGRectMake(160, 5, voidwindowwidth-160-15-10, 25)];
            RefundAmountText.font=[UIFont systemFontOfSize:15];
            RefundAmountText.textColor=[UIColor darkGrayColor];
            RefundAmountText.textAlignment=NSTextAlignmentRight;
            RefundAmountText.borderStyle = UITextBorderStyleRoundedRect;
            RefundAmountText.placeholder=[MyClass returntitlewithtitle:@"Amount"];
            RefundAmountText.adjustsFontSizeToFitWidth=YES;
            RefundAmountText.minimumFontSize=7;
            RefundAmountText.tag=401;
            RefundAmountText.text=tmprefundamount;
            RefundAmountText.keyboardType = UIKeyboardTypeDecimalPad;
            [RefundAmountText addTarget:self action:@selector(updaterefund:)forControlEvents:UIControlEventEditingChanged];
            [cell.contentView addSubview:RefundAmountText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
        }else if (indexPath.row==2) {
            detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 118, 35)];
            detailspaymentLabel.font=[UIFont systemFontOfSize:15];
            detailspaymentLabel.textColor=[UIColor blackColor];
            detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Refund Method"];
            detailspaymentLabel.tag=801;
            [cell.contentView addSubview:detailspaymentLabel];
            
            paidmethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, 118, 35)];
            paidmethodLabel.font=[UIFont systemFontOfSize:14];
            paidmethodLabel.textColor=[UIColor darkGrayColor];
            paidmethodLabel.textAlignment=NSTextAlignmentRight;
            paidmethodLabel.text=[MyClass returntitlewithtitle:tmprefundmethod];
            paidmethodLabel.tag=805;
            [cell.contentView addSubview:paidmethodLabel];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
        }else if (indexPath.row==3){
            if (showRefundMethodPicker==YES) {
                pickerViewmenu =[[NSMutableArray alloc]initWithArray:[MyClass returnPaidMethodArray]];
                
                if ([pickerViewmenu containsObject:tmprefundmethod]) {
                    presetRow=(int)[pickerViewmenu indexOfObject:tmprefundmethod];
                }else{
                    presetRow=0;
                }
                
                UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 302, 150)];
                UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 290, 150)];
                [myPicker setDataSource:self];
                [myPicker setDelegate:self];
                myPicker.tag=802;
                
                [myPicker selectRow:presetRow inComponent:0 animated:NO];
                [myPicker setShowsSelectionIndicator:YES];
                myPickerView=myPicker;
                [datepickerview addSubview:myPicker];
                
                
                [cell.contentView addSubview:datepickerview];
            }else{
                cell.hidden=YES;
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }else if (indexPath.row==4){
            detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 118, 35)];
            detailspaymentLabel.font=[UIFont systemFontOfSize:15];
            detailspaymentLabel.textColor=[UIColor blackColor];
            detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Forfeit Amount"];
            detailspaymentLabel.tag=801;
            [cell.contentView addSubview:detailspaymentLabel];
            
            VoidForfeitLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, 118, 35)];
            VoidForfeitLabel.font=[UIFont systemFontOfSize:14];
            VoidForfeitLabel.textColor=[UIColor darkGrayColor];
            VoidForfeitLabel.textAlignment=NSTextAlignmentRight;
            VoidForfeitLabel.text=[NSString stringWithFormat:@"%g", [tmpvoidforfeitedamount floatValue]];
            VoidForfeitLabel.tag=805;
            [cell.contentView addSubview:VoidForfeitLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else if (indexPath.row==5) {
            detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 121, 21)];
            detailspaymentLabel.font=[UIFont systemFontOfSize:17];
            detailspaymentLabel.textColor=[UIColor blackColor];
            detailspaymentLabel.text=[MyClass returntitlewithtitle:@"New Order Will be Created"];
            detailspaymentLabel.tag=301;
            [cell.contentView addSubview:detailspaymentLabel];
            
            UISwitch *swautorenew = [[UISwitch alloc] init];
            swautorenew.onTintColor=themecolor;
            CGSize switchSize = [swautorenew sizeThatFits:CGSizeZero];
            swautorenew.frame = CGRectMake(242.0f,1.8f,switchSize.width,switchSize.height);
            swautorenew.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            swautorenew.tag = 501;
            [swautorenew addTarget:self action:@selector(switchneworderwillbecreated:) forControlEvents:UIControlEventValueChanged];
            swautorenew.enabled=neworderwillbecreated;
            [cell.contentView addSubview:swautorenew];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else if (indexPath.row==6) {
            
            receiptremarksText=[[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(16, 0, detailpaymentwidth-40, 95)];
            receiptremarksText.font=[UIFont systemFontOfSize:15];
            receiptremarksText.textColor=[UIColor darkGrayColor];
            receiptremarksText.placeholder=[MyClass returntitlewithtitle:@"Receipt Remarks (Print on receipt)"];
            receiptremarksText.text=tmpreceiptremarks;
            receiptremarksText.delegate=self;
            //receiptremarksText.tag=403;
            [cell.contentView addSubview:receiptremarksText];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    }else if (tableView==DiscountTable){
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UITableViewCell *cell;
        if (indexPath.section==0) {
            marketingobject = [workingSales.promotiondiscountrecords objectAtIndex:indexPath.row];
            
            //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_0"];
            UIButton *recursivebutton;
            UIImageView *recursiveimage;
            //add switch, label and button
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_0"];
                
                //add textfield
                DTDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, tableView.frame.size.width-75, 100)];
                DTDescriptionLabel.font=[UIFont systemFontOfSize:15];
                DTDescriptionLabel.textColor=[UIColor darkGrayColor];
                DTDescriptionLabel.numberOfLines=0;
                DTDescriptionLabel.tag=811;
                [cell.contentView addSubview:DTDescriptionLabel];
                
                DTDiscountAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-55, 0, 40, 20)];
                DTDiscountAmountLabel.font=[UIFont systemFontOfSize:15];
                DTDiscountAmountLabel.adjustsFontSizeToFitWidth=YES;
                DTDiscountAmountLabel.textColor=[UIColor redColor];
                DTDiscountAmountLabel.textAlignment=NSTextAlignmentRight;
                DTDiscountAmountLabel.tag=812;
                [cell.contentView addSubview:DTDiscountAmountLabel];
                
                recursiveimage=[[UIImageView alloc]init];
                [recursiveimage setImage:[UIImage imageNamed:@"classrenewal_icon.png"]];
                recursiveimage.layer.cornerRadius=6;
                recursiveimage.layer.masksToBounds=YES;
                recursiveimage.tag=813;
                [cell.contentView addSubview:recursiveimage];
                
                recursivebutton=[[UIButton alloc]init];
                
                [recursivebutton setTitle:[MyClass returntitlewithtitle:@"Recursive"] forState:UIControlStateNormal];
                recursivebutton.tag=814;
                recursivebutton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
                
                [cell.contentView addSubview:recursivebutton];
            }else{
                DTDescriptionLabel=(UILabel *)[cell.contentView viewWithTag:811];
                DTDiscountAmountLabel=(UILabel *)[cell.contentView viewWithTag:812];
                recursiveimage=(UIImageView *)[cell.contentView viewWithTag:813];
                recursivebutton=(UIButton *)[cell.contentView viewWithTag:814];
            }

            
            if ([DiscountTableMode isEqualToString:@"View"] || [SalesObject.status isEqualToString:@"Voided"]|| !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscount|| (!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscountifpaid && [SalesObject.paid floatValue]!=0)) {
                DTDescriptionLabel.font=[UIFont systemFontOfSize:15];
                DTDescriptionLabel.frame=CGRectMake(15, 7, tableView.frame.size.width-75, 100);
                DTDescriptionLabel.text=[globalvariables.language isEqualToString:@"English"]?marketingobject.description:marketingobject.description_chinese;
                [DTDescriptionLabel sizeToFit];
                
                if ([marketingobject.recursive isEqualToString:@"Yes"]) {
                    recursivebutton.hidden=NO;
                    recursiveimage.hidden=NO;
                    recursiveimage.layer.opacity=1;
                    recursiveimage.frame=CGRectMake(15, DTDescriptionLabel.frame.origin.y+DTDescriptionLabel.frame.size.height+2, 12, 12);
                    recursivebutton.frame=CGRectMake(15+12+3, recursiveimage.frame.origin.y, 200, 12);
                    recursivebutton.titleLabel.font=[UIFont systemFontOfSize:12];
                    [recursivebutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                    [recursivebutton removeTarget:self action:@selector(recursivebuttonpressed:)forControlEvents:UIControlEventTouchUpInside];
                }else{
                    recursivebutton.hidden=YES;
                    recursiveimage.hidden=YES;
                }
                
                DTDiscountAmountLabel.frame=CGRectMake(tableView.frame.size.width-55, 0, 40, 20);
                DTDiscountAmountLabel.font=[UIFont systemFontOfSize:15];
                DTDiscountAmountLabel.textAlignment=NSTextAlignmentRight;
//                DTDiscountAmountLabel.frame=CGRectMake(tableView.frame.size.width-50, (DTDescriptionLabel.frame.origin.y+DTDescriptionLabel.frame.size.height+7-20)/2, 40, 20);
            }else{
                DTDescriptionLabel.font=[UIFont systemFontOfSize:13];
                DTDescriptionLabel.frame=CGRectMake(5, 5, tableView.frame.size.width-75, 100);
                DTDescriptionLabel.text=[globalvariables.language isEqualToString:@"English"]?marketingobject.description:marketingobject.description_chinese;
                [DTDescriptionLabel sizeToFit];
                
                DTDiscountAmountLabel.frame=CGRectMake(5, DTDescriptionLabel.frame.origin.y+DTDescriptionLabel.frame.size.height, 200, 20);
                DTDiscountAmountLabel.font=[UIFont systemFontOfSize:12];
                DTDiscountAmountLabel.textAlignment=NSTextAlignmentLeft;
                
                recursivebutton.hidden=NO;
                recursiveimage.hidden=NO;
                recursivebutton.frame=CGRectMake(30, 0, 195, 20);
                recursivebutton.titleLabel.font=[UIFont systemFontOfSize:13];
                [recursivebutton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                [recursivebutton sizeToFit];
                recursivebutton.frame=CGRectMake(tableView.frame.size.width-recursivebutton.frame.size.width-90, DTDiscountAmountLabel.frame.origin.y, recursivebutton.frame.size.width, 20);
                recursiveimage.frame=CGRectMake(recursivebutton.frame.origin.x-15, recursivebutton.frame.origin.y+4, 12, 12);
                
                ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
                if([workingSales.autorenew isEqualToString:@"Yes"] && ![obj.autorenew isEqualToString:@""]){
                    recursiveimage.hidden=NO;
                    recursivebutton.hidden=NO;
                    if ([marketingobject.recursive isEqualToString:@"Yes"]) {
                        recursiveimage.layer.opacity=1;
                    }else{
                        recursiveimage.layer.opacity=0.3;
                    }
                    [recursivebutton addTarget:self action:@selector(recursivebuttonpressed:)forControlEvents:UIControlEventTouchUpInside];
                }else{
                    recursiveimage.hidden=YES;
                    recursivebutton.hidden=YES;
                }
            }
            
            if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
                DTDiscountAmountLabel.text=[NSString stringWithFormat:@"$%@",marketingobject.promotionfixeddiscount];
            }else{
                DTDiscountAmountLabel.text=[NSString stringWithFormat:@"%@%@",marketingobject.promotionpercentagediscount,@"%"];
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else if (indexPath.section==1){
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_1"];
            //cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_1"];
            
            if (indexPath.row==0) {
                salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 160, 22)];
                salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                salesgeneralLabel.textColor=[UIColor blackColor];
                salesgeneralLabel.text=[MyClass returntitlewithtitle:@"One off Percentage"];
                salesgeneralLabel.tag=301;
                [cell.contentView addSubview:salesgeneralLabel];
                
                /*salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake([globalvariables.language isEqualToString:@"English"]?92:60, 8, 160, 22)];
                 salesgeneralLabel.font=[UIFont systemFontOfSize:10];
                 salesgeneralLabel.textColor=[UIColor blackColor];
                 salesgeneralLabel.text=[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"One Off"]];
                 salesgeneralLabel.tag=301;
                 [cell.contentView addSubview:salesgeneralLabel];*/
                
                
                
                OneOffPercentageDiscountText = [[UITextField alloc]initWithFrame:CGRectMake(219, 6, 70, 26)];
                OneOffPercentageDiscountText.font=[UIFont systemFontOfSize:15];
                OneOffPercentageDiscountText.textColor=[UIColor darkGrayColor];
                OneOffPercentageDiscountText.textAlignment=NSTextAlignmentRight;
                OneOffPercentageDiscountText.borderStyle = UITextBorderStyleRoundedRect;
                OneOffPercentageDiscountText.placeholder=[MyClass returntitlewithtitle:@"%"];
                OneOffPercentageDiscountText.text=workingSales.oneoffpercentagediscount;
                OneOffPercentageDiscountText.minimumFontSize=7;
                OneOffPercentageDiscountText.adjustsFontSizeToFitWidth=YES;
                OneOffPercentageDiscountText.tag=401;
                OneOffPercentageDiscountText.keyboardType = UIKeyboardTypeDecimalPad;
                [OneOffPercentageDiscountText addTarget:self action:@selector(updatetuitionfee:)forControlEvents:UIControlEventEditingChanged];
                //[OneOffPercentageDiscountText addTarget:self action:@selector(updatetuitionfeeeditingend:)forControlEvents:UIControlEventEditingDidEnd];
                [OneOffPercentageDiscountText addTarget:self action:@selector(offsettextfield:)forControlEvents:UIControlEventEditingDidBegin];
                [cell.contentView addSubview:OneOffPercentageDiscountText];
                
                OneOffPercentageDiscountLabel = [[UILabel alloc]initWithFrame:CGRectMake(177, 6, 110, 26)];
                OneOffPercentageDiscountLabel.font=[UIFont systemFontOfSize:15];
                OneOffPercentageDiscountLabel.textColor=[UIColor darkGrayColor];
                OneOffPercentageDiscountLabel.textAlignment=NSTextAlignmentRight;
                
                
                if ([workingSales.oneoffpercentagediscount isEqualToString:@""]) {
                    OneOffPercentageDiscountLabel.text=@"";
                }else{
                    OneOffPercentageDiscountLabel.text=[NSString stringWithFormat:@"%@%@",workingSales.oneoffpercentagediscount,@"%"];
                }
                
                
                OneOffPercentageDiscountLabel.minimumScaleFactor=0.5;
                OneOffPercentageDiscountLabel.adjustsFontSizeToFitWidth=YES;
                OneOffPercentageDiscountLabel.tag=301;
                [cell.contentView addSubview:OneOffPercentageDiscountLabel];
                
                if ([DiscountTableMode isEqualToString:@"View"] || [SalesObject.status isEqualToString:@"Voided"]|| !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editonetimediscount) {
                    OneOffPercentageDiscountText.hidden=YES;
                    OneOffPercentageDiscountLabel.hidden=NO;
                }else{
                    OneOffPercentageDiscountText.hidden=NO;
                    OneOffPercentageDiscountLabel.hidden=YES;
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1) {
                salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 8, 160, 22)];
                salesgeneralLabel.font=[UIFont systemFontOfSize:17];
                salesgeneralLabel.textColor=[UIColor blackColor];
                salesgeneralLabel.text=[MyClass returntitlewithtitle:@"One off Fixed"];
                salesgeneralLabel.tag=301;
                [cell.contentView addSubview:salesgeneralLabel];
                
                /*salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake([globalvariables.language isEqualToString:@"English"]?92:60, 8, 160, 22)];
                 salesgeneralLabel.font=[UIFont systemFontOfSize:10];
                 salesgeneralLabel.textColor=[UIColor blackColor];
                 salesgeneralLabel.text=[NSString stringWithFormat:@"(%@)",[MyClass returntitlewithtitle:@"One Off"]];
                 salesgeneralLabel.tag=301;
                 [cell.contentView addSubview:salesgeneralLabel];*/
                
                OneOffFixedDiscountText = [[UITextField alloc]initWithFrame:CGRectMake(219, 6, 70, 26)];
                OneOffFixedDiscountText.font=[UIFont systemFontOfSize:15];
                OneOffFixedDiscountText.textColor=[UIColor darkGrayColor];
                OneOffFixedDiscountText.textAlignment=NSTextAlignmentRight;
                OneOffFixedDiscountText.borderStyle = UITextBorderStyleRoundedRect;
                OneOffFixedDiscountText.placeholder=[MyClass returntitlewithtitle:@"Fixed"];
                OneOffFixedDiscountText.text=workingSales.oneoffdiscount;
                OneOffFixedDiscountText.adjustsFontSizeToFitWidth=YES;
                OneOffFixedDiscountText.minimumFontSize=7;
                OneOffFixedDiscountText.tag=401;
                OneOffFixedDiscountText.keyboardType = UIKeyboardTypeDecimalPad;
                [OneOffFixedDiscountText addTarget:self action:@selector(updatetuitionfee:)forControlEvents:UIControlEventEditingChanged];
                [OneOffFixedDiscountText addTarget:self action:@selector(offsettextfield:)forControlEvents:UIControlEventEditingDidBegin];
                [cell.contentView addSubview:OneOffFixedDiscountText];
                
                OneOffFixedDiscountLabel = [[UILabel alloc]initWithFrame:CGRectMake(177, 6, 110, 26)];
                OneOffFixedDiscountLabel.font=[UIFont systemFontOfSize:15];
                OneOffFixedDiscountLabel.textColor=[UIColor darkGrayColor];
                OneOffFixedDiscountLabel.textAlignment=NSTextAlignmentRight;
                
                if ([workingSales.oneoffdiscount isEqualToString:@""]) {
                    OneOffFixedDiscountLabel.text=@"";
                }else{
                    OneOffFixedDiscountLabel.text=[NSString stringWithFormat:@"$%@",workingSales.oneoffdiscount];
                }
                
                OneOffFixedDiscountLabel.minimumScaleFactor=0.5;
                OneOffFixedDiscountLabel.adjustsFontSizeToFitWidth=YES;
                OneOffFixedDiscountLabel.tag=301;
                [cell.contentView addSubview:OneOffFixedDiscountLabel];
                
                if ([DiscountTableMode isEqualToString:@"View"] || [SalesObject.status isEqualToString:@"Voided"]|| !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editonetimediscount) {
                    OneOffFixedDiscountText.hidden=YES;
                    OneOffFixedDiscountLabel.hidden=NO;
                }else{
                    OneOffFixedDiscountText.hidden=NO;
                    OneOffFixedDiscountLabel.hidden=YES;
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
        }else if (indexPath.section==2) {
            CouponRecord * coupon = [workingSales.couponrecords objectAtIndex:indexPath.row];
            marketingobject=[MyClass returnMarketingRecordWithMarketingKey:coupon.marketingkey index:3];
            
            //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_2"];
            
            
            //add switch, label and button
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_2"];
                
                //add textfield
                DTDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, tableView.frame.size.width-75, 100)];
                DTDescriptionLabel.font=[UIFont systemFontOfSize:15];
                DTDescriptionLabel.textColor=[UIColor darkGrayColor];
                DTDescriptionLabel.numberOfLines=0;
                DTDescriptionLabel.tag=811;
                [cell.contentView addSubview:DTDescriptionLabel];
                
                DTDiscountAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-55, 0, 40, 20)];
                DTDiscountAmountLabel.font=[UIFont systemFontOfSize:15];
                DTDiscountAmountLabel.adjustsFontSizeToFitWidth=YES;
                DTDiscountAmountLabel.textColor=[UIColor redColor];
                DTDiscountAmountLabel.textAlignment=NSTextAlignmentRight;
                DTDiscountAmountLabel.tag=812;
                [cell.contentView addSubview:DTDiscountAmountLabel];
                
                
            }else{
                DTDescriptionLabel=(UILabel *)[cell.contentView viewWithTag:811];
                DTDiscountAmountLabel=(UILabel *)[cell.contentView viewWithTag:812];
            }
            
            
            

            
            
            if ([DiscountTableMode isEqualToString:@"View"] || [SalesObject.status isEqualToString:@"Voided"]|| !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).applycoupon) {
                DTDescriptionLabel.font=[UIFont systemFontOfSize:15];
                DTDescriptionLabel.frame=CGRectMake(15, 7, tableView.frame.size.width-75, 100);
                DTDescriptionLabel.text=[globalvariables.language isEqualToString:@"English"]?marketingobject.description:marketingobject.description_chinese;
                [DTDescriptionLabel sizeToFit];
                
                
                DTDiscountAmountLabel.frame=CGRectMake(tableView.frame.size.width-55, 7, 40, 20);
                DTDiscountAmountLabel.font=[UIFont systemFontOfSize:15];
                DTDiscountAmountLabel.textAlignment=NSTextAlignmentRight;
                //DTDiscountAmountLabel.frame=CGRectMake(tableView.frame.size.width-50, ([tableView rectForRowAtIndexPath:indexPath].size.height-20)/2, 40, 20);
            }else{
                DTDescriptionLabel.font=[UIFont systemFontOfSize:13];
                DTDescriptionLabel.frame=CGRectMake(5, 5, tableView.frame.size.width-75-10, 100);
                DTDescriptionLabel.text=[globalvariables.language isEqualToString:@"English"]?marketingobject.description:marketingobject.description_chinese;
                [DTDescriptionLabel sizeToFit];
                
                DTDiscountAmountLabel.frame=CGRectMake(5, DTDescriptionLabel.frame.origin.y+DTDescriptionLabel.frame.size.height, 200, 20);
                DTDiscountAmountLabel.font=[UIFont systemFontOfSize:12];
                DTDiscountAmountLabel.textAlignment=NSTextAlignmentLeft;

            }
            
            

            

            if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
                DTDiscountAmountLabel.text=[NSString stringWithFormat:@"$%@",marketingobject.promotionfixeddiscount];
            }else{
                DTDiscountAmountLabel.text=[NSString stringWithFormat:@"%@%@",marketingobject.promotionpercentagediscount,@"%"];
            }
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }else if (indexPath.section==3){
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            //cell = [tableView dequeueReusableCellWithIdentifier:@"Cell_1"];
            
            salesgeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 160, 38)];
            salesgeneralLabel.font=[UIFont systemFontOfSize:17];
            salesgeneralLabel.textColor=[UIColor blackColor];
            salesgeneralLabel.text=[MyClass returntitlewithtitle:@"Total Discount"];
            salesgeneralLabel.tag=301;
            [cell.contentView addSubview:salesgeneralLabel];
            
            DTTotalDiscountLabel = [[UILabel alloc]initWithFrame:CGRectMake(177, 0, 110, 38)];
            DTTotalDiscountLabel.font=[UIFont systemFontOfSize:15];
            DTTotalDiscountLabel.textColor=[UIColor darkGrayColor];
            DTTotalDiscountLabel.textAlignment=NSTextAlignmentRight;
            DTTotalDiscountLabel.minimumScaleFactor=0.5;
            DTTotalDiscountLabel.adjustsFontSizeToFitWidth=YES;
            DTTotalDiscountLabel.text=[NSString stringWithFormat:@"$%@",tmpTotalDiscount];
            DTTotalDiscountLabel.tag=301;
            [cell.contentView addSubview:DTTotalDiscountLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        return cell;
    }else if (tableView == CouponTable) {
        MyTableViewCell *myCell;
        CouponRecord *coupon=[filteredavailablecouponarray objectAtIndex:indexPath.row];
        marketingobject = [MyClass returnMarketingRecordWithMarketingKey:coupon.marketingkey index:3];
        
        static NSString *CellIdentifier = @"couponcell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        

        myCell.label1.text=[globalvariables.language isEqualToString:@"English"]?marketingobject.description:marketingobject.description_chinese;
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            myCell.label4.text=[NSString stringWithFormat:@"$%@",marketingobject.promotionfixeddiscount];
        }else{
            myCell.label4.text=[NSString stringWithFormat:@"%@%@",marketingobject.promotionpercentagediscount,@"%"];
        }
        myCell.label2.text=[MyClass returnreplacedtitlewithtitle:@"Valid from %@1" replacementarray:@[[MyClass returndateformatwithdate:coupon.effectivefrom]]];
        if([coupon.effectiveto isEqualToString:@""]){
//            myCell.label3.hidden=YES;
            myCell.label3.text=[MyClass returntitlewithtitle:@"Never expire"];
        }else{
//            myCell.label3.hidden=NO;
            myCell.label3.text=[MyClass returnreplacedtitlewithtitle:@"Expires on %@1" replacementarray:@[[MyClass returndateformatwithdate:coupon.effectiveto]]];
        }

        myCell.label5.text=[NSString stringWithFormat:@"ID%@",coupon.couponkey];
        myCell.label6.text=marketingobject.code;
        myCell.label6.hidden=[marketingobject.code isEqualToString:@""];
        
        if(coupon.cannotuseconjunctionwithothercoupons){
            myCell.label7.hidden=NO;
            myCell.label7.text=[MyClass returntitlewithtitle:@"Cannot be used conjunction with other coupons"];
        }else{
            myCell.label7.hidden=YES;
        }
        
        myCell.label8.text=[MyClass returnMarketingApplicationDescription:marketingobject];
        
        myCell.view1.hidden=[self couponcanbeselected:coupon];
        
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return myCell;
    }else if (tableView == PromotionCodeTable) {
        
        MyTableViewCell *myCell;
//        CouponRecord *coupon=[filteredavailablecouponarray objectAtIndex:indexPath.row];
//        marketingobject = [MyClass returnMarketingRecordWithMarketingKey:coupon.marketingkey index:3];
//        
        static NSString *CellIdentifier = @"promotioncell";
        myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (myCell == nil) {
            myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
//        UITableViewCell *cell;
        marketingobject = [filteredavailablepromotionarray objectAtIndex:indexPath.row];
//        
//        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
//        
//        //add switch, label and button
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
//            
//            //add textfield
//            PCDescriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, tableView.frame.size.width-100, 100)];
//            PCDescriptionLabel.font=[UIFont systemFontOfSize:14];
//            PCDescriptionLabel.textColor=[UIColor darkGrayColor];
//            PCDescriptionLabel.numberOfLines=0;
//            PCDescriptionLabel.tag=801;
//            [cell.contentView addSubview:PCDescriptionLabel];
//            
//            PCDiscountAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(tableView.frame.size.width-100+15+10, 0, 40, 20)];
//            PCDiscountAmountLabel.font=[UIFont systemFontOfSize:15];
//            PCDiscountAmountLabel.adjustsFontSizeToFitWidth=YES;
//            PCDiscountAmountLabel.textColor=[UIColor redColor];
//            PCDiscountAmountLabel.textAlignment=NSTextAlignmentRight;
//            PCDiscountAmountLabel.tag=802;
//            [cell.contentView addSubview:PCDiscountAmountLabel];
//            
//            PCExpiryLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, tableView.frame.size.width-40, 14)];
//            PCExpiryLabel.font=[UIFont systemFontOfSize:11];
//            PCExpiryLabel.textColor=[UIColor grayColor];
//            PCExpiryLabel.tag=803;
//            [cell.contentView addSubview:PCExpiryLabel];
//            
//            PCQuotaLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30, tableView.frame.size.width-40, 14)];
//            PCQuotaLabel.font=[UIFont systemFontOfSize:11];
//            PCQuotaLabel.textColor=[UIColor grayColor];
//            PCQuotaLabel.tag=805;
//            [cell.contentView addSubview:PCQuotaLabel];
//            
//            PCAddButton=[[UIButton alloc]initWithFrame:CGRectMake(305,10, 30, 30)];
//            [PCAddButton setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
//            [PCAddButton setImage:[UIImage imageNamed:@"addphonebutton.png"] forState:UIControlStateNormal];
//            [PCAddButton addTarget:self action:@selector(addpromotioncode:) forControlEvents:UIControlEventTouchUpInside];
//            PCAddButton.tag=804;
//            [cell.contentView addSubview:PCAddButton];
//            
//        }else{
//            PCDescriptionLabel=(UILabel *)[cell.contentView viewWithTag:801];
//            PCDiscountAmountLabel=(UILabel *)[cell.contentView viewWithTag:802];
//            PCExpiryLabel=(UILabel *)[cell.contentView viewWithTag:803];
//            PCAddButton=(UIButton *)[cell.contentView viewWithTag:804];
//            PCQuotaLabel=(UILabel *)[cell.contentView viewWithTag:805];
//            //PCCodeLabel=(UILabel *)[cell.contentView viewWithTag:806];
//        }
//        
//        PCDescriptionLabel.frame=CGRectMake(15, 7, tableView.frame.size.width-100, 100);
//        PCDescriptionLabel.text=[globalvariables.language isEqualToString:@"English"]?marketingobject.description:marketingobject.description_chinese;
//        [PCDescriptionLabel sizeToFit];
//        
//        PCExpiryLabel.frame=CGRectMake(15, PCDescriptionLabel.frame.origin.y+PCDescriptionLabel.frame.size.height+5, tableView.frame.size.width-40, 14);
//        PCQuotaLabel.frame=CGRectMake(15, PCExpiryLabel.frame.origin.y+PCExpiryLabel.frame.size.height+4, tableView.frame.size.width-40, 14);
//        //PCCodeLabel.frame=CGRectMake(15, PCExpiryLabel.frame.origin.y+PCExpiryLabel.frame.size.height+4, tableView.frame.size.width-40, 14);
//        
//        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
//            PCDiscountAmountLabel.text=[NSString stringWithFormat:@"$%@",marketingobject.promotionfixeddiscount];
//        }else{
//            PCDiscountAmountLabel.text=[NSString stringWithFormat:@"%@%@",marketingobject.promotionpercentagediscount,@"%"];
//        }
//        PCExpiryLabel.text=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"To be expired on"],[MyClass returndateformatwithdate:marketingobject.enddate]];
//        PCQuotaLabel.text=[NSString stringWithFormat:@"%@/%@",marketingobject.usedcount,[marketingobject.promotionquota isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:marketingobject.promotionquota];
//        if (![marketingobject.code isEqualToString:@""]) {
//            PCQuotaLabel.text=[NSString stringWithFormat:@"%@ (%@)",PCQuotaLabel.text,marketingobject.code];
//        }
//        
//        PCDiscountAmountLabel.frame=CGRectMake(tableView.frame.size.width-80, (PCQuotaLabel.frame.origin.y+14+7-20)/2, 40, 20);
//        PCAddButton.frame=CGRectMake(tableView.frame.size.width-20-10-5, (PCQuotaLabel.frame.origin.y+14+7-20)/2-5, 30, 30);
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        return cell;
        
        myCell.label1.text=[globalvariables.language isEqualToString:@"English"]?marketingobject.description:marketingobject.description_chinese;
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            myCell.label5.text=[NSString stringWithFormat:@"$%@",marketingobject.promotionfixeddiscount];
        }else{
            myCell.label5.text=[NSString stringWithFormat:@"%@%@",marketingobject.promotionpercentagediscount,@"%"];
        }
        myCell.label2.text=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:@"To be expired on"],[MyClass returndateformatwithdate:marketingobject.enddate]];
        myCell.label3.text=[NSString stringWithFormat:@"%@/%@",marketingobject.usedcount,[marketingobject.promotionquota isEqualToString:@""]?[MyClass returntitlewithtitle:@"Unlimited"]:marketingobject.promotionquota];
        if (![marketingobject.code isEqualToString:@""]) {
            myCell.label3.text=[NSString stringWithFormat:@"%@ (%@)",myCell.label3.text,marketingobject.code];
        }
        myCell.label4.text=[MyClass returnMarketingApplicationDescription:marketingobject];
        
        [myCell.button1 addTarget:self action:@selector(addpromotioncode:) forControlEvents:UIControlEventTouchUpInside];
        myCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return myCell;
    }else{
        //static NSString *CellIdentifier = @"Cell";
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (indexPath.row==0) {
            UILabel *emaillabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 140, 38)];
            emaillabel.font=[UIFont systemFontOfSize:14];
            emaillabel.textColor=[UIColor darkGrayColor];
            //emaillabel.textAlignment=NSTextAlignmentCenter;
            
            emaillabel.text=[MyClass returntitlewithtitle:@"Print"];
            emaillabel.textColor=[UIColor darkGrayColor];
            [cell.contentView addSubview:emaillabel];
            
            UIImageView *shareimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 24, 24)];
            shareimage.layer.cornerRadius=4;
            shareimage.tag=103;
            shareimage.layer.masksToBounds=YES;
            [shareimage setImage:[UIImage imageNamed:@"print_icon.png"]];
            [cell.contentView addSubview:shareimage];
            
            aishareprint = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            aishareprint.alpha = 1.0;
            aishareprint.center = CGPointMake(160,19);
            aishareprint.hidesWhenStopped = YES;
            [cell.contentView addSubview:aishareprint];
            
        }else if (indexPath.row==1) {
            UILabel *messagelabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 140, 38)];
            messagelabel.font=[UIFont systemFontOfSize:14];
            messagelabel.textColor=[UIColor darkGrayColor];
            //emaillabel.textAlignment=NSTextAlignmentCenter;
            
            messagelabel.text=[invoiceorreceipt isEqualToString:@"invoice"]?[MyClass returntitlewithtitle:@"Send eInvoice"]:[MyClass returntitlewithtitle:@"Send eReceipt"];
            messagelabel.textColor=[UIColor darkGrayColor];
            [cell.contentView addSubview:messagelabel];
            
            UIImageView *shareimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 24, 24)];
            shareimage.layer.cornerRadius=4;
            shareimage.tag=103;
            shareimage.layer.masksToBounds=YES;
            [shareimage setImage:[UIImage imageNamed:@"messagegray_icon.png"]];
            [cell.contentView addSubview:shareimage];
            
            aisendmessage = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            aisendmessage.alpha = 1.0;
            aisendmessage.center = CGPointMake(160,19);
            aisendmessage.hidesWhenStopped = YES;
            [cell.contentView addSubview:aisendmessage];
        }else if (indexPath.row==2) {
            UILabel *emaillabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 140, 38)];
            emaillabel.font=[UIFont systemFontOfSize:14];
            emaillabel.textColor=[UIColor darkGrayColor];
            //emaillabel.textAlignment=NSTextAlignmentCenter;
            
            emaillabel.text=[MyClass returntitlewithtitle:@"Send Email"];
            emaillabel.textColor=[UIColor darkGrayColor];
            [cell.contentView addSubview:emaillabel];
            
            UIImageView *shareimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 24, 24)];
            shareimage.layer.cornerRadius=4;
            shareimage.tag=103;
            shareimage.layer.masksToBounds=YES;
            [shareimage setImage:[UIImage imageNamed:@"email2_icon.png"]];
            [cell.contentView addSubview:shareimage];
            
            aishareemail = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            aishareemail.alpha = 1.0;
            aishareemail.center = CGPointMake(160,19);
            aishareemail.hidesWhenStopped = YES;
            [cell.contentView addSubview:aishareemail];
            
        }else if (indexPath.row==4){
            UILabel *otherlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 140, 38)];
            otherlabel.font=[UIFont systemFontOfSize:14];
            otherlabel.textColor=[UIColor darkGrayColor];
            //otherlabel.textAlignment=NSTextAlignmentCenter;
            otherlabel.text=[MyClass returntitlewithtitle:@"More"];
            [cell.contentView addSubview:otherlabel];
            
            UIImageView *shareimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 24, 24)];
            shareimage.layer.cornerRadius=4;
            shareimage.tag=103;
            shareimage.layer.masksToBounds=YES;
            [shareimage setImage:[UIImage imageNamed:@"more_icon.png"]];
            [cell.contentView addSubview:shareimage];
            
            aishareothers = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            aishareothers.alpha = 1.0;
            aishareothers.center = CGPointMake(160,19);
            aishareothers.hidesWhenStopped = YES;
            [cell.contentView addSubview:aishareothers];
            
        }else{
            UILabel *otherlabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 140, 38)];
            otherlabel.font=[UIFont systemFontOfSize:14];
            otherlabel.textColor=[UIColor darkGrayColor];
            //otherlabel.textAlignment=NSTextAlignmentCenter;
            otherlabel.text=[MyClass returntitlewithtitle:@"Add to Folder"];
            [cell.contentView addSubview:otherlabel];
            
            UIImageView *shareimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 7, 24, 24)];
            shareimage.layer.cornerRadius=4;
            shareimage.tag=103;
            shareimage.layer.masksToBounds=YES;
            [shareimage setImage:[UIImage imageNamed:@"documentfolder2_icon.png"]];
            [cell.contentView addSubview:shareimage];
            
        }
    }
    return cell;
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==DiscountTable) {
        if (indexPath.section==0) {
            return ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscount && !(!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscountifpaid && [SalesObject.paid floatValue]!=0);
        }
    }else if (indexPath.section==2){
        return YES;
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
    if (toIndexPath.section==0 && (fromIndexPath.row !=toIndexPath.row)) {
        
        marketingobject=[workingSales.promotiondiscountrecords objectAtIndex:fromIndexPath.row];
        [workingSales.promotiondiscountrecords removeObjectAtIndex:fromIndexPath.row];
        [workingSales.promotiondiscountrecords insertObject:marketingobject atIndex:toIndexPath.row];
        
        [self calculateTotalFee];
    }
}


-(BOOL) couponcanbeselected:(CouponRecord *)coupon
{
    BOOL alreadyhascannotbeusedconjunctionwithothers=FALSE;
    for(int i=0;i<workingSales.couponrecords.count;i++){
        CouponRecord *obj=[workingSales.couponrecords objectAtIndex:i];
        if(obj.cannotuseconjunctionwithothercoupons){
            alreadyhascannotbeusedconjunctionwithothers=TRUE;
            break;
        }
    }
    
    if(workingSales.couponrecords.count>0){
        if(!coupon.cannotuseconjunctionwithothercoupons && !alreadyhascannotbeusedconjunctionwithothers){
            return YES;
        }
    }else{
        return YES;
    }
    
    return NO;
}

-(void) recursivebuttonpressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:DiscountTable];
    NSIndexPath *indexPath =[DiscountTable indexPathForRowAtPoint:point];
    
    MarketingRecord *obj=[workingSales.promotiondiscountrecords objectAtIndex:indexPath.row];
    if ([obj.recursive isEqualToString:@"Yes"]) {
        obj.recursive=@"No";
    }else{
        obj.recursive=@"Yes";
    }
    [DiscountTable reloadData];
}



- (void)updatetuitionfee:(UITextField *)sender {
    
    
    if (sender==OneOffPercentageDiscountText) {
        if (![self checkvalidpercentagediscountinput:sender.text]) {
            sender.text=@"";
        }
    }else{
        if (![self checkvalidfeeinput:sender.text]) {
            sender.text=@"";
        }
    }
    
    workingSales.oneoffpercentagediscount=OneOffPercentageDiscountText.text;
    workingSales.oneoffdiscount=OneOffFixedDiscountText.text;

    [self calculateTotalFee];

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

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField==detailspaymentText) {
        if ([globalvariables.centerrecord.defaulteditablepaymentamount isEqualToString:@"No"]) {
            if (paymentoverride) {
                return YES;
            }else{
                return NO;
            }
        }else{
            return YES;
        }
    }else{
        return YES;
    }
}

-(void) closesalespicker
{
    //showProductDateTimePicker=NO;
    //showNotificationDateTimePicker=NO;
}

-(void) showsidewindowwithwindow:(NSString *)windowname
{
    if ([windowname isEqualToString:@"showCategoryTable"]) {
        showCategoryTable=YES;
        showProductTable=NO;
        showDetailPayment=NO;
        showVoidWindow=NO;
        showDiscountTable=NO;
        showpromotioncodetable=NO;
        [CategoryTable reloadData];
    }else if ([windowname isEqualToString:@"showProductTable"]) {
        showCategoryTable=NO;
        showProductTable=YES;
        showDetailPayment=NO;
        showVoidWindow=NO;
        showDiscountTable=NO;
        showpromotioncodetable=NO;
        [ProductTable reloadData];
    }else if ([windowname isEqualToString:@"showDetailPayment"]) {
        showCategoryTable=NO;
        showProductTable=NO;
        showDetailPayment=YES;
        showVoidWindow=NO;
        showDiscountTable=NO;
        showpromotioncodetable=NO;
    }else if ([windowname isEqualToString:@"showVoidWindow"]) {
        showCategoryTable=NO;
        showProductTable=NO;
        showDetailPayment=NO;
        showVoidWindow=YES;
        showDiscountTable=NO;
        showpromotioncodetable=NO;
        [VoidTable reloadData];
    }else if ([windowname isEqualToString:@"showDiscountTable"]) {
        showCategoryTable=NO;
        showProductTable=NO;
        showDetailPayment=NO;
        showVoidWindow=NO;
        showDiscountTable=YES;
        showpromotioncodetable=NO;
    }else{
        showCategoryTable=NO;
        showProductTable=NO;
        showDetailPayment=NO;
        showVoidWindow=NO;
        showDiscountTable=NO;
        showpromotioncodetable=NO;
    }
}

-(void) sortFilteredCategoryArray
{
    NSSortDescriptor *sortBySubjectName = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[sortBySubjectName];
    filteredCategoryArray = [NSMutableArray arrayWithArray:[filteredCategoryArray sortedArrayUsingDescriptors:sortDescriptors]];
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

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==categorysearchbar) {
        if ([searchText isEqualToString:@""]) {
            filteredCategoryArray=[[NSMutableArray alloc]initWithArray:CategoryArray];
            [self sortFilteredCategoryArray];
        }else{
            NSPredicate *newCondition1 = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
            
            NSPredicate *newCondition2 = [NSPredicate predicateWithBlock:^BOOL(NSString *object, NSDictionary *bindings) {
                NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.category = %@ and self.remarks contains[c] %@",object,searchText];
                NSMutableArray *productArray=[[NSMutableArray alloc]initWithArray:[ProductArray filteredArrayUsingPredicate:predicate2]];
                return productArray.count>0;
            }];
            
            NSPredicate *predicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[newCondition1, newCondition2]];
            
//            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
            filteredCategoryArray=[[NSMutableArray alloc]initWithArray:[CategoryArray filteredArrayUsingPredicate:predicate]];
            [self sortFilteredCategoryArray];
        }
        [CategoryTable reloadData];
        [CategoryTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==productsearchbar) {
        if ([searchText isEqualToString:@""]) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@",workingSales.productcategory];
            filteredProductArray=[[NSMutableArray alloc]initWithArray:[ProductArray filteredArrayUsingPredicate:predicate]];
            [self sortFilteredProductArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@ and (SELF.englishname contains[c] %@ or self.chinesename contains[c] %@)",workingSales.productcategory,searchText,searchText];
            filteredProductArray=[[NSMutableArray alloc]initWithArray:[ProductArray filteredArrayUsingPredicate:predicate]];
            [self sortFilteredProductArray];
        }
        [ProductTable reloadData];
        [ProductTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==promotionsearchbar){
        if ([searchText isEqualToString:@""]) {
            filteredavailablepromotionarray=[[NSMutableArray alloc]initWithArray:availablepromotionarray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.manualapply == YES and (self.description contains[c] %@ or self.description_chinese contains[c] %@ or self.promotionfixeddiscount contains[c] %@ or self.promotionpercentagediscount contains[c] %@ or self.code contains[c] %@)",searchText,searchText,searchText,searchText,searchText];
            filteredavailablepromotionarray=[[NSMutableArray alloc]initWithArray:[availablepromotionarray filteredArrayUsingPredicate:predicate]];
        }
        [PromotionCodeTable reloadData];
        [PromotionCodeTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==couponsearchbar){
        [self returnFilteredCouponArray];
        [CouponTable reloadData];
        [CouponTable setContentOffset:CGPointZero animated:YES];
    }
}

-(void) showpromotioncode:(UIButton *)sender
{
    availablepromotionarray=[[MyClass retrieveMarketingRecordWithStatus:@"Valid" enrollmentdate:workingSales.orderdate flushcachedata:NO subjectkey:nil productkey:[MyClass returnproductkeywithproductcode:workingSales.productcode]] objectAtIndex:2];
//    filteredavailablepromotionarray=[[NSMutableArray alloc]initWithArray:availablepromotionarray];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.manualapply == YES"];
    filteredavailablepromotionarray=[[NSMutableArray alloc]initWithArray:[availablepromotionarray filteredArrayUsingPredicate:predicate]];
    
    showpromotioncodetable=YES;
    showcoupontable=NO;
    
    [PromotionCodeTable reloadData];
    [self adjusttablesize];
}

-(void) addpromotioncode:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:PromotionCodeTable];
    NSIndexPath *indexPath =[PromotionCodeTable indexPathForRowAtPoint:point];
    
    [workingSales.promotiondiscountrecords addObject:[filteredavailablepromotionarray objectAtIndex:indexPath.row]];
    [self calculateTotalFee];
    //TotalFeeLabel.text=tmpTotalFee;
    
    [DiscountTable reloadData];
}

- (void) calculateTotalFee{
    
    [self calculatetotaldiscount];
    
    float thetotalfee=0;
    NSString *result;
    
    thetotalfee=[workingSales.quantity floatValue]*[workingSales.price floatValue]-[tmpTotalDiscount floatValue];
    
    if (noofroundoffdigit==1) {
        if (thetotalfee==(int)thetotalfee) {
            result=[NSString stringWithFormat:@"%g",thetotalfee];
        }else{
            if ([[NSString stringWithFormat:@"%.1f",thetotalfee] hasSuffix:@".0"]) {
                result= [[NSString stringWithFormat:@"%.1f",thetotalfee] substringToIndex:[[NSString stringWithFormat:@"%.1f",thetotalfee] length]-2];
            }else{
                result= [NSString stringWithFormat:@"%.1f",thetotalfee];
            }
        }
    }else{
        result=[NSString stringWithFormat:@"%ld",lroundf(thetotalfee)];
    }
    
    
    
    if (showDetailPayment) {
        paymenttotalfeeLabel.text=result;
        paymentoutstandingLabel.text=[NSString stringWithFormat:@"%g",[paymenttotalfeeLabel.text doubleValue]-[paymenttotalpaidLabel.text doubleValue]];
    }
    
    workingSales.total=result;
    
    TotalPriceLabel.text=workingSales.total;
    
    //return result;
}

-(void) calculatetotaldiscount
{
    
    float discountedfee=[workingSales.quantity floatValue]*[workingSales.price floatValue];
    float totalpaid = [workingSales.paid floatValue];
    
    for (int i=0; i<workingSales.promotiondiscountrecords.count; i++) {
        marketingobject=[workingSales.promotiondiscountrecords objectAtIndex:i];
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[workingSales.quantity integerValue]);
        }else{
            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
        }
    }
    
    discountedfee*=(1-[workingSales.oneoffpercentagediscount floatValue]/100);
    discountedfee-=[workingSales.oneoffdiscount floatValue];
    
    if(discountedfee>totalpaid && workingSales.couponrecords.count>0){
        for (int i=0; i<workingSales.couponrecords.count; i++) {
            CouponRecord *obj=[workingSales.couponrecords objectAtIndex:i];
            marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
            if(obj.creditable){
                discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
            }
        }
        
        if(discountedfee-totalpaid>0){
            discountedfee-=totalpaid;
            
            for (int i=0; i<workingSales.couponrecords.count; i++) {
                CouponRecord *obj=[workingSales.couponrecords objectAtIndex:i];
                marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
                if (!obj.creditable) {
                    discountedfee-=[marketingobject.promotionfixeddiscount floatValue];

                    if(discountedfee<0){
                        discountedfee=0;
                    }
                }
            }
            discountedfee+=totalpaid;
        }
//        discountedfee-=totalpaid;
//        for (int i=0; i<workingSales.couponrecords.count; i++) {
//            CouponRecord *obj=[workingSales.couponrecords objectAtIndex:i];
//            marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
//            discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
//            
//            if(discountedfee<0){
//                discountedfee=0;
//            }
//        }
//        discountedfee+=totalpaid;
    }
    
    tmpTotalDiscount=[NSString stringWithFormat:@"%g",[workingSales.quantity floatValue]*[workingSales.price floatValue]-(noofroundoffdigit==0?lroundf(discountedfee):discountedfee)];
    
    if (noofroundoffdigit==1) {
        if ([tmpTotalDiscount floatValue]==(int)[tmpTotalDiscount floatValue]) {
            tmpTotalDiscount=[NSString stringWithFormat:@"%g",[tmpTotalDiscount floatValue]];
        }else{
            if ([[NSString stringWithFormat:@"%.1f",[tmpTotalDiscount floatValue]] hasSuffix:@".0"]) {
                tmpTotalDiscount= [[NSString stringWithFormat:@"%.1f",[tmpTotalDiscount floatValue]] substringToIndex:[[NSString stringWithFormat:@"%.1f",[tmpTotalDiscount floatValue]] length]-2];
            }else{
                tmpTotalDiscount= [NSString stringWithFormat:@"%.1f",[tmpTotalDiscount floatValue]];
            }
        }
    }else{
        tmpTotalDiscount=[NSString stringWithFormat:@"%ld",lroundf([tmpTotalDiscount floatValue])];

    }
    
    
    
    DiscountLabel.text=tmpTotalDiscount;
    
    DTTotalDiscountLabel.text=[NSString stringWithFormat:@"$%@",tmpTotalDiscount];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==SalesPopoverTable) {
        if (![SalesTableMode isEqualToString:@"View"]) {
            if (indexPath.section==0 && indexPath.row==0 && ![SalesObject.status isEqualToString:@"Voided"]) {
                //pickerview for date/time
                
                selectedItem=@"OrderDate";
                
                if (showOrderDatePicker==YES) {
                    showOrderDatePicker=NO;
                }else{
                    showOrderDatePicker=YES;
                    
                }
                
                //
                [self showsidewindowwithwindow:@"none"];
                [SalesPopoverTable reloadData];
                [self adjusttablesize];
        
            }else if (indexPath.section==0 && indexPath.row==2 && ![SalesObject.status isEqualToString:@"Voided"]&& (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).changesalesproduct || [SalesTableMode isEqualToString:@"Add"])) {
                //pickerview for level
                
                selectedItem=@"Category";
                categorysearchbar.text=@"";
                filteredCategoryArray=[[NSMutableArray alloc]initWithArray:CategoryArray];
                [self sortFilteredCategoryArray];
                
                [self showsidewindowwithwindow:@"showCategoryTable"];
                
                
                [self closesalespicker];
                
                if ([workingSales.productcategory isEqualToString:@""] && CategoryArray.count>0) {
                    workingSales.productcategory=[CategoryArray objectAtIndex:0];
                    [self getproductlistarraywithcategory:workingSales.productcategory];
                    
                }
                
                
                
                
                [SalesPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==0 && indexPath.row==3 && ![SalesObject.status isEqualToString:@"Voided"]&& (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).changesalesproduct|| [SalesTableMode isEqualToString:@"Add"])) {
                //pickerview for level
                //if (![workingSales.productcategory isEqualToString:@""]) {
                    selectedItem=@"Product";
                    productsearchbar.text=@"";
                    [self getproductlistarraywithcategory:workingSales.productcategory];
                    //[self sortFilteredProductArray];
                    
                    [self showsidewindowwithwindow:@"showProductTable"];
                    
                    
                    [self closesalespicker];
                    
//                    if ([workingSales.productfullname isEqualToString:@""] && filteredProductArray.count>0) {
//                        workingSales.productfullname=[MyClass returnproductnamewithproductcode:((ProductRecord *)[filteredProductArray objectAtIndex:0]).code centerkey:globalvariables.centerrecord.centerkey];
//                        workingSales.productcode=((ProductRecord *)[filteredProductArray objectAtIndex:0]).code;
//
//                        ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
//                        if (obj && ![obj.autorenew isEqualToString:@""]) {
//                            workingSales.autorenew=@"Yes";
//                        }else{
//                            workingSales.autorenew=@"No";
//                        }
//
//                        [self updatepriceinformation];
//
//                    }
                    
                    
                    [SalesPopoverTable reloadData];
                    [self adjusttablesize];
//                }else{
//                    [self tableView:SalesPopoverTable didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//                }
//

                
            }else if (indexPath.section==2 && indexPath.row==3) {
                //paid
                [self.view endEditing:YES];
                keyboardheight=0;
                [self closesalespicker];
                [self showsidewindowwithwindow:@"showDiscountTable"];
                
                [DiscountTable reloadData];
                [SalesPopoverTable reloadData];
                [self adjusttablesize];
                
            }else if (indexPath.section==2 && indexPath.row==5) {
                //paid
                [self.view endEditing:YES];
                keyboardheight=0;
                [self adjusttablesize];
                
                DetailsPaymentTableMode=@"View";
                
                /*if (workingSales.paymentrecords.count==0) {
                    if([SalesTableMode isEqualToString:@"View"] || [SalesTableMode isEqualToString:@"Edit"] ){
                        [self retrieveDetailsPaymentWithSaleskey:SalesObject.saleskey];
                    }
                }*/
                
                //Popup details payment view
                [self createPaymentToolBarwithMode:DetailsPaymentTableMode];
                [self showsidewindowwithwindow:@"showDetailPayment"];
                //showDetailPayment=YES;
                [DetailsPaymentTable reloadData];
                [self adjusttablesize];
                
            }
        }else{
            if (indexPath.section==2 && indexPath.row==3){
                [self.view endEditing:YES];
                keyboardheight=0;
                [self showsidewindowwithwindow:@"showDiscountTable"];
                
                [DiscountTable reloadData];
                [self adjusttablesize];
            }else if (indexPath.section==2 && indexPath.row==5) {
                //paid
                //[self.view endEditing:YES];
                
                DetailsPaymentTableMode=@"View";
                showPaymentDatePicker=NO;
                
                /*if (workingSales.paymentrecords.count==0 && ![SalesTableMode isEqualToString:@"Add"]) {
                    [self retrieveDetailsPaymentWithSaleskey:SalesObject.saleskey];
                }*/
                //Popup details payment view
                [self createPaymentToolBarwithMode:DetailsPaymentTableMode];
                [self showsidewindowwithwindow:@"showDetailPayment"];
                //showDetailPayment=YES;
                [DetailsPaymentTable reloadData];
                [self adjusttablesize];
            }
            
        }
    }else if (tableView==DetailsPaymentTable){
        if ([DetailsPaymentTableMode isEqualToString:@"Add"]) {
            if(indexPath.section==1 && indexPath.row==1){
                
                selectedItem=@"PaidMethod";
                
                if (showPaidMethodPicker==YES) {
                    showPaidMethodPicker=NO;
                }else{
                    showPaidMethodPicker=YES;
                    showPaymentDatePicker=NO;
                }
                
                
                
                [DetailsPaymentTable reloadData];
                
            }else if(indexPath.section==1 && indexPath.row==3){
                
                selectedItem=@"DetailsPayment";
                
                if (showPaymentDatePicker==YES) {
                    showPaymentDatePicker=NO;
                }else{
                    showPaidMethodPicker=NO;
                    showPaymentDatePicker=YES;
                }
                
                
                
                [DetailsPaymentTable reloadData];
                
            }
        }else{
            if (indexPath.section==1) {
                if (![SalesTableMode isEqualToString:@"View"]) {

                    DetailsPaymentTableMode=@"Edit";
                    PaymentRecord *DetailsPaymentObject=[workingSales.paymentrecords objectAtIndex:indexPath.row];
                    DetailsPaymentObjectIndex=indexPath.row;
                    tmppaymentremarks=DetailsPaymentObject.paymentremarks;
                    tmpreceiptremarks=DetailsPaymentObject.receiptremarks;
                    [DetailsPaymentTable reloadData];
                    
                    [self createPaymentToolBarwithMode:@"Edit"];
                }
            }/*else if (indexPath.section==2){
                if (![SalesTableMode isEqualToString:@"View"]) {
                    DetailsPaymentTableMode=@"EditInvoiceRemarks";
                    workingSales.invoiceremarks=invoiceremarkslabel.text;
                    [DetailsPaymentTable reloadData];
                    
                    [self createPaymentToolBarwithMode:@"EditInvoiceRemarks"];
                }
            }*/
        }
    }else if (tableView==CategoryTable){
        if (![workingSales.productcategory isEqualToString:[filteredCategoryArray objectAtIndex:indexPath.row]]) {
            workingSales.productcategory=[filteredCategoryArray objectAtIndex:indexPath.row];
            workingSales.productfullname=@"";
            workingSales.productcode=@"";
            
            workingSales.price=@"";
            workingSales.quantity=@"1";
            workingSales.total=@"";
            
            [MyClass retrieveUnusedCouponWithStudentkey:PopoverStudent.studentkey type:@"Sales" availableCouponArray:availablecouponarray typekey:[MyClass returnproductkeywithproductcode:workingSales.productcode]];
            
            [self getproductlistarraywithcategory:workingSales.productcategory];
            
            
            [SalesPopoverTable reloadData];
            [CategoryTable reloadData];
            
            //[self adjusttablesize];
            
            
        }
    }else if (tableView==ProductTable){
        if (![workingSales.productcode isEqualToString:((ProductRecord *)[filteredProductArray objectAtIndex:indexPath.row]).code]) {
            workingSales.productcode=((ProductRecord *)[filteredProductArray objectAtIndex:indexPath.row]).code;
            workingSales.productfullname=[MyClass returnproductnamewithproductcode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
            
            [MyClass retrieveUnusedCouponWithStudentkey:PopoverStudent.studentkey type:@"Sales" availableCouponArray:availablecouponarray typekey:[MyClass returnproductkeywithproductcode:workingSales.productcode]];
            
            
            if (![((ProductRecord *)[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey]).autorenew isEqualToString:@""]) {
                workingSales.autorenew=@"Yes";
            }else{
                workingSales.autorenew=@"No";
            }
            
            [self applyEarlyBirdDiscount];
            [self updatepriceinformation];
            
            workingSales.productcategory=((ProductRecord *)[filteredProductArray objectAtIndex:indexPath.row]).category;
            
            
            [SalesPopoverTable reloadData];
            [ProductTable reloadData];
            
            //[self adjusttablesize];
            
        }
    }else if (tableView==VoidTable){
        if(indexPath.row==2){
            
            selectedItem=@"RefundMethod";
            
            if (showRefundMethodPicker==YES) {
                showRefundMethodPicker=NO;
            }else{
                showRefundMethodPicker=YES;
            }
            
            
            [VoidTable reloadData];
        }
        
    }else if (tableView==PromotionCodeTable){
        
        [workingSales.promotiondiscountrecords addObject:[filteredavailablepromotionarray objectAtIndex:indexPath.row]];
        [self calculateTotalFee];
        
        [DiscountTable reloadData];
    }else if (tableView==CouponTable){
        CouponRecord *sourceobject=[filteredavailablecouponarray objectAtIndex:indexPath.row];
        if([self couponcanbeselected:sourceobject]){
            [availablecouponarray removeObject:sourceobject];
            [self returnFilteredCouponArray];
            [workingSales.couponrecords addObject:sourceobject];
            
            [self calculateTotalFee];
            [DiscountTable reloadData];
            [CouponTable reloadData];
        }
    }else if (tableView==sharetable){//sharetable
        if (indexPath.row==0){
            [aishareprint startAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                    
                    SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
                    
                    NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:nil SalesReceiptArray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] papersizeoverride:NO combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                    
                    if (pdfdata) {
                        [self printPDF:pdfdata];
                    }
                }else{
                    SalesInvoiceRecord *salesinvoicerecord=[[SalesInvoiceRecord alloc]initSalesInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity outstandingamount:[NSString stringWithFormat:@"%g",[SalesObject.total floatValue]-[SalesObject.paid floatValue]] invoiceremarks:SalesObject.invoiceremarks image:nil checkstatus:nil salesrecord:SalesObject productname:nil];
                    
                    NSData *pdfdata = [MyClass generateInvoiceWithClassInvoiceArray:nil SalesInvoiceArray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] papersizeoverride:NO combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                    if (pdfdata) {
                        [self printPDF:pdfdata];
                    }
                }
                [aishareprint stopAnimating];
            });
        }else if (indexPath.row==1) {
            [aisendmessage startAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                    
                    SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
                    
                    NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:nil SalesReceiptArray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                    
                    if (pdfdata) {
                        [self messagePDF:pdfdata studentkeys:[[NSMutableArray alloc]initWithObjects:SalesObject.studentkey, nil] pdfType:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:nil salesreceiptarray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil]] acknowledge:YES];
                    }
                }else{
                    SalesInvoiceRecord *salesinvoicerecord=[[SalesInvoiceRecord alloc]initSalesInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity outstandingamount:[NSString stringWithFormat:@"%g",[SalesObject.total floatValue]-[SalesObject.paid floatValue]] invoiceremarks:SalesObject.invoiceremarks image:nil checkstatus:nil salesrecord:SalesObject productname:nil];
                    
                    NSData *pdfdata = [MyClass generateInvoiceWithClassInvoiceArray:nil SalesInvoiceArray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                    if (pdfdata) {
                        [self messagePDF:pdfdata studentkeys:[[NSMutableArray alloc]initWithObjects:SalesObject.studentkey, nil] pdfType:@"Invoice" filename:[MyClass returninvoicenumberwithclassinvoicearray:nil salesinvoicearray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord,nil] updateinvoicelog:NO] acknowledge:YES];
                    }
                }
                [aishareemail stopAnimating];
            });
        }else if (indexPath.row==2) {
            [aishareemail startAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                    
                    SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
                    
                    NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:nil SalesReceiptArray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];

                    if (pdfdata) {
                        [self emailPDF:pdfdata pdftype:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:nil salesreceiptarray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil]]receiptient:[self returnmailreceiptientwithclassarray:nil salesarray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] type:@"Receipt"]];
                    }
                }else{
                    SalesInvoiceRecord *salesinvoicerecord=[[SalesInvoiceRecord alloc]initSalesInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity outstandingamount:[NSString stringWithFormat:@"%g",[SalesObject.total floatValue]-[SalesObject.paid floatValue]] invoiceremarks:SalesObject.invoiceremarks image:nil checkstatus:nil salesrecord:SalesObject productname:nil];
                    
                    NSData *pdfdata = [MyClass generateInvoiceWithClassInvoiceArray:nil SalesInvoiceArray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                    if (pdfdata) {
                        [self emailPDF:pdfdata pdftype:@"Invoice" filename:[MyClass returninvoicenumberwithclassinvoicearray:nil salesinvoicearray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] updateinvoicelog:NO] receiptient:[self returnmailreceiptientwithclassarray:nil salesarray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] type:@"Invoice"]];
                    }
                }
                [aishareemail stopAnimating];
            });
        }else if (indexPath.row==4){
            [aishareothers startAnimating];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                    [self sharepaymentreceiptwithtableview:sharetable indexpath:indexPath];
                }else{
                    [self sharepaymentinvoicewithtableview:sharetable indexpath:indexPath];
                }
                [aishareothers stopAnimating];
            });
        }else{
            if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                if (![globalvariables.documentfolder.salesreceiptarray containsObject:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey]) {
                    [globalvariables.documentfolder.salesreceiptarray addObject:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey];
                    [self.delegate refreshdocumentfoldercount];
                }else{
                    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"This receipt has already been added to the folder"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [erroralert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [erroralert addAction:OKAction];
                    [self presentViewController:erroralert animated:YES completion:nil];
                }
            }else{
                if (![globalvariables.documentfolder.salesinvoicearray containsObject:SalesObject.saleskey]) {
                    [globalvariables.documentfolder.salesinvoicearray addObject:SalesObject.saleskey];
                    [self.delegate refreshdocumentfoldercount];
                }else{
                    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"This invoice has already been added to the folder"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [erroralert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [erroralert addAction:OKAction];
                    [self presentViewController:erroralert animated:YES completion:nil];
                }
            }
            
            [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

-(void) paymentsharebuttonpressed:(UIButton *)sender
{
    invoiceorreceipt=@"receipt";
    receiptprintbutton=sender;
    
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"sharedocument" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 160) View:self Button:sender ItemsArray:[[NSMutableArray alloc]initWithObjects:/*@"Print",*/@"Send eReceipt",@"Send Email",@"Add to Folder",@"More", nil] Title:nil];
    
    /*
    
    [sharetable reloadData];
    UIView *shareview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 175, 190)];
    [shareview addSubview:sharetable];
    
    UIViewController *sharevc=[[UIViewController alloc]init];
    sharevc.preferredContentSize=CGSizeMake(175, 190);
    sharevc.view=shareview;
    sharevc.modalPresentationStyle=UIModalPresentationPopover;
    mySharePopovercontroller=sharevc.popoverPresentationController;
    mySharePopovercontroller.delegate=self;
    mySharePopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionRight;
    mySharePopovercontroller.sourceView=sender;
    mySharePopovercontroller.sourceRect=sender.bounds;
    
    [self presentViewController:sharevc animated:YES completion:nil];
    */
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:DetailsPaymentTable];
    NSIndexPath *indexPath =[DetailsPaymentTable indexPathForRowAtPoint:point];
    
    paymentindexpath=indexPath;
}

-(void) applyEarlyBirdDiscount
{
    MarketingRecord *sourceobject;
    MarketingRecord *destobject;
    MarketingRecord *promotionobject;
    
    //remove all early bird promotion
    for (int p=0; p<workingSales.promotiondiscountrecords.count; p++) {
        promotionobject=workingSales.promotiondiscountrecords[p];
        if ([promotionobject.earlybirdlastdate isEqualToString:@"newearlybirddiscount"]) {
            [workingSales.promotiondiscountrecords removeObjectAtIndex:p];
            p--;
        }
    }
    
    NSMutableArray *earlybirdpromotions=[MyClass returnEarlyBirdPromotionWithOrderDate:workingSales.orderdate Product:workingSales.productcode];
    for (int i=0; i<earlybirdpromotions.count; i++) {
        sourceobject=earlybirdpromotions[i];
        destobject=[[MarketingRecord alloc]initMarketingRecordWithcenterkey:sourceobject.centerkey marketingkey:sourceobject.marketingkey category:sourceobject.category description:sourceobject.description description_chinese:sourceobject.description_chinese startdate:sourceobject.startdate enddate:sourceobject.enddate remarks:sourceobject.remarks promotionfixeddiscount:sourceobject.promotionfixeddiscount promotionpercentagediscount:sourceobject.promotionpercentagediscount usedcount:sourceobject.usedcount promotionquota:sourceobject.promotionquota code:sourceobject.code recursive:sourceobject.recursive effectivefrom:nil effectiveto:nil subcategory:nil redeemable:NO redeempoint:nil perstudentquota:nil cannotuseconjunctionwithothercoupons:NO subjectarray:nil productarray:nil couponallowcredit:nil perclassorquantity:sourceobject.perclassorquantity earlybirdlastdate:@"newearlybirddiscount" buymorepayless:sourceobject.buymorepayless estartdate:nil eenddate:nil enablebuymorepayless:NO minnoofclass:0 bmsmacrossothersubjects:NO bmsmminsubjectno:0 bmsmminnoofclasspersubject:0 bmsmsamebillmonth:NO manualapply:sourceobject.manualapply];
        [workingSales.promotiondiscountrecords addObject:destobject];
    }
}

-(void) settleAllButtonPressed:(id)sender
{
    detailspaymentText.text=paymentoutstandingLabel.text;
    tmppaidamount=detailspaymentText.text;
}

-(void) overridebuttonpressed:(UIButton *)sender
{
    UIAlertController *overridepaymentalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Paid Amount"] message:[MyClass returntitlewithtitle:@"Are you sure to change the payment amount?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [paymentremarksText resignFirstResponder];
        [receiptremarksText resignFirstResponder];
        
        sender.enabled=NO;
        paymentoverride=YES;
        paymentremarksText.text=[NSString stringWithFormat:@"(%@) %@",[MyClass returntitlewithtitle:@"Paid amount was entered by staff"],paymentremarksText.text];
        tmppaymentremarks=paymentremarksText.text;
        [detailspaymentText becomeFirstResponder];
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [overridepaymentalert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [overridepaymentalert addAction:OKAction];
    [overridepaymentalert addAction:CancelAction];
    [[MyClass topMostController] presentViewController:overridepaymentalert animated:YES completion:nil];
}


-(IBAction) addpaymentrecord:(id)sender
{
    
    paymentoverride=FALSE;
    
    DetailsPaymentTableMode=@"Add";
    
    showPaymentDatePicker=NO;
    showPaidMethodPicker=NO;
    
    [df setDateFormat:@"dd-MMM-yyyy"];
    
    tmpPaidDate=[df stringFromDate:[NSDate date]];
//    tmppaidmethod=@"Cash";
    tmppaidmethod=globalvariables.centerrecord.paymentmethods.firstObject;
    
    //if ([globalvariables.centerrecord.defaulteditablepaymentamount isEqualToString:@"No"]) {
        tmppaidamount=paymentoutstandingLabel.text;
    /*}else{
        tmppaidamount=@"";
    } */   //tmpparentbankin=@"No";
    
    tmppaymentremarks=@"";
    tmpreceiptremarks=globalvariables.centerrecord.defaultreceiptremarksasinvoiceremarksforproductsales?workingSales.invoiceremarks:@"";
    
    [DetailsPaymentTable reloadData];
    
    
    [self createPaymentToolBarwithMode:@"Add"];
    
    /*if (DetailsPaymentTable.contentSize.height>maxpaymentpopupheight) {
        [DetailsPaymentTable setFrame:CGRectMake(0, 0, 300,  maxpaymentpopupheight)];// CGRectMake(0, 0, 320, viewTableHeight)];
    }else{
        [DetailsPaymentTable setFrame:CGRectMake(0, 0, 300,  DetailsPaymentTable.contentSize.height)];// CGRectMake(0, 0, 320, viewTableHeight)];
    }
    
    [paymentMasterView setFrame:CGRectMake(0, 0, 300, DetailsPaymentTable.frame.size.height+44)];
    myPaymentPopoverController.popoverContentSize=CGSizeMake(300, DetailsPaymentTable.frame.size.height+44);
    //[DetailsPaymentTable setFrame:CGRectMake(0, 0, 300,  myPaymentPopoverController.popoverContentSize.height-44)];
    [paymentScrollView setFrame:CGRectMake(0, 44, 300, DetailsPaymentTable.frame.size.height)];
    [paymentScrollView setContentSize:CGSizeMake(300, DetailsPaymentTable.frame.size.height)];*/
    
    
}


-(IBAction) donepaymentrecord:(id)sender{
    
    if ([SalesTableMode isEqualToString:@"Edit"] || [SalesTableMode isEqualToString:@"Add"]) {
        

            if ([self checkvalidfeeinput:detailspaymentText.text] && ([detailspaymentText.text floatValue]!=0 || [workingSales.total floatValue]==0)) {
                
                [workingSales.paymentrecords insertObject:[[PaymentRecord alloc]initPaymentRecordwithPaymentkey:@"" paymenttype:@"Sales" paymenttypekey:SalesObject.saleskey?SalesObject.saleskey:@"" paiddate:tmpPaidDate paidmethod:tmppaidmethod paidamount:detailspaymentText.text action:@"add" paymentremarks:paymentremarksText.text receiptremarks:receiptremarksText.text staffname:[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"] receiptnumber:nil receiptprefix:nil] atIndex:0];
                
                //update enrollment popover data
                double totalpaid=0;
                
                for (int p=0; p<workingSales.paymentrecords.count; p++) {
                    PaymentRecord *DetailsPaymentObject=[workingSales.paymentrecords objectAtIndex:p];
                    totalpaid+=[DetailsPaymentObject.paidamount doubleValue];
                }
                
                TotalPaidLabel.text=[NSString stringWithFormat:@"%g",totalpaid];
                workingSales.paid=TotalPaidLabel.text;
                [self calculateTotalFee];
                
                DetailsPaymentTableMode=@"View";
                showPaymentDatePicker=NO;
                [DetailsPaymentTable reloadData];
                
                [self createPaymentToolBarwithMode:@"View"];
                

                
            }else{
                tmppaidamount=@"";
                detailspaymentText.text=@"";
            }
            
        //}
        
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView==DetailsPaymentTable) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            //add code here for when you hit delete
            
            [workingSales.paymentrecords removeObjectAtIndex:indexPath.row];
            
            [DetailsPaymentTable reloadData];
            [self createPaymentToolBarwithMode:@"View"];

            //update enrollment data
            int tmptotalpaid=0;
            for (int p=0; p<workingSales.paymentrecords.count; p++) {
                PaymentRecord *DetailsPaymentObject=[workingSales.paymentrecords objectAtIndex:p];
                //if (![DetailsPaymentObject.action isEqualToString:@"delete"]) {
                tmptotalpaid+=[DetailsPaymentObject.paidamount intValue];
                //}
                
            }
            TotalPaidLabel.text=[NSString stringWithFormat:@"%d",tmptotalpaid];
            workingSales.paid=TotalPaidLabel.text;
            [self calculateTotalFee];
        }
    }else if (tableView==DiscountTable){
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            if(indexPath.section==0){
                [workingSales.promotiondiscountrecords removeObjectAtIndex:indexPath.row];
                
                [self calculateTotalFee];
                [DiscountTable reloadData];
                
            }else if(indexPath.section==2){
                CouponRecord *obj=[workingSales.couponrecords objectAtIndex:indexPath.row];
                [workingSales.couponrecords removeObjectAtIndex:indexPath.row];
                [availablecouponarray addObject:obj];
                [self returnFilteredCouponArray];
                
                
                [self calculateTotalFee];
                [DiscountTable reloadData];
                if(showcoupontable){
                    [CouponTable reloadData];
                }
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    if (tableView==DiscountTable){
        if (indexPath.section==0) {
            return ([DiscountTableMode isEqualToString:@"View"] || [SalesObject.status isEqualToString:@"Voided"]  || !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscount || (!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscountifpaid && [SalesObject.paid floatValue]!=0))?NO:YES;
        }else if (indexPath.section==2) {
            return [DiscountTableMode isEqualToString:@"View"]|| [SalesObject.status isEqualToString:@"Voided"]?NO:YES;
        }
    }
    return NO;
}



-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [MyClass returntitlewithtitle:@"Delete"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==DiscountTable) {
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
                [showpromotioncodebutton addTarget:self action:@selector(showpromotioncode:) forControlEvents:UIControlEventTouchUpInside];
                [header addSubview:showpromotioncodebutton];
                showpromotioncodebutton.hidden=[DiscountTableMode isEqualToString:@"View"]  || [SalesObject.status isEqualToString:@"Voided"]|| !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscount|| (!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editdiscountifpaid && [SalesObject.paid floatValue]!=0);
                return header;
            }
        }else if (section==2) {
            if (availablecouponarray.count>0 && globalvariables.centerrecord.ecoupon) {
                UIView *header=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
                header.backgroundColor=[UIColor systemGroupedBackgroundColor];
                
                UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(15, 14, 200, 32)];
                label.text=[[MyClass returntitlewithtitle:@"Coupon"] uppercaseString];
                label.font=[UIFont systemFontOfSize:13];
                label.textColor=[UIColor grayColor];
                [header addSubview:label];
                
                UIButton *showpromotioncodebutton=[[UIButton alloc]initWithFrame:CGRectMake(tableView.frame.size.width-28,22, 28, 20)];
                [showpromotioncodebutton setImageEdgeInsets:UIEdgeInsetsMake(2.5, 6.5, 2.5, 6.5)];
                [showpromotioncodebutton setImage:[UIImage imageNamed:@"addphonebutton.png"] forState:UIControlStateNormal];
                [showpromotioncodebutton addTarget:self action:@selector(showavailablecoupon:) forControlEvents:UIControlEventTouchUpInside];
                [header addSubview:showpromotioncodebutton];
                showpromotioncodebutton.hidden=[DiscountTableMode isEqualToString:@"View"]|| !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).applycoupon;
                return header;
            }
        }
    }
    return nil;
}

-(void) showavailablecoupon:(UIButton *)sender
{
    filteredavailablecouponarray=[[NSMutableArray alloc]initWithArray:availablecouponarray];
    showcoupontable=YES;
    showpromotioncodetable=NO;

    [CouponTable reloadData];
    [self adjusttablesize];
}

-(void) addcoupon:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:CouponTable];
    NSIndexPath *indexPath =[CouponTable indexPathForRowAtPoint:point];
    CouponRecord *sourceobject=[filteredavailablecouponarray objectAtIndex:indexPath.row];
    [availablecouponarray removeObject:sourceobject];
    [self returnFilteredCouponArray];
    [workingSales.couponrecords addObject:sourceobject];

    [self calculateTotalFee];
    [DiscountTable reloadData];
    [CouponTable reloadData];
}

-(void) returnFilteredCouponArray
{
    
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (![couponsearchbar.text isEqualToString:@""]) {
        
        newCondition = [NSPredicate predicateWithBlock:^BOOL(CouponRecord *object, NSDictionary *bindings) {
            MarketingRecord *mktobj=[MyClass returnMarketingRecordWithMarketingKey:object.marketingkey index:3];
            return [mktobj.code rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [mktobj.description rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [mktobj.description_chinese rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [mktobj.promotionfixeddiscount rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [mktobj.promotionpercentagediscount rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.effectiveto rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.issuedate rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound ;
        }];
        
        [nsPredicatearray addObject:newCondition];
        
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredavailablecouponarray= [[NSMutableArray alloc]initWithArray:[availablecouponarray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredavailablecouponarray= [[NSMutableArray alloc]initWithArray:availablecouponarray];
    }
    
    NSSortDescriptor *sortby = [NSSortDescriptor sortDescriptorWithKey:@"effectivefrom" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[sortby];
    filteredavailablecouponarray = [NSMutableArray arrayWithArray:[filteredavailablecouponarray sortedArrayUsingDescriptors:sortDescriptors]];
    
}

-(void) viewDidDisappear:(BOOL)animated
{
    workingSales.paymentrecords=[[NSMutableArray alloc]init];
}




- (void)deleteOrderRecord:(id)sender {
    
    
    
        
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Order Record"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the record?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Yes"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self deleteOrder];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"No"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:OKAction];
    [alert addAction:CancelAction];
    [self presentViewController:alert animated:YES completion:nil];
        

}

-(void) deleteOrder
{
    //delete sql class and enrollment records
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletesalesrecord&saleskey=%@&updatedby=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,SalesObject.saleskey,globalvariables.username];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    if(result){
        [self.delegate dismissSalesPopover];
        [self.delegate updatesalesrecordandreturnsalesrecord:nil];
    }
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    if([selectedItem isEqualToString:@"ProductDateTime"] || [selectedItem isEqualToString:@"NotificationDateTime"]){
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    if([selectedItem isEqualToString:@"ProductDateTime"] || [selectedItem isEqualToString:@"NotificationDateTime"]){
        if (component==0){
            return [hourPickerViewMenu count];
        }else{
            return [minutePickerViewMenu count];
        }
    }else if([selectedItem isEqualToString:@"DetailsPayment"]){
        return 100000;
    }else{
        return pickerViewmenu.count;
    }
    
}

/*
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if([selectedItem isEqualToString:@"ProductDateTime"] || [selectedItem isEqualToString:@"NotificationDateTime"]){
        if (component==0){
            //[df setDateFormat:@"dd-MMM-yyyy"];
            //NSDate *date=[df dateFromString:[datePickerViewMenu objectAtIndex:row]];
            //[df setDateFormat:@"EEE dd MMM"];
            return [MyClass returndateformatEEEddMMMdatewithddMMMyyyydate:[MyClass returnDateFromBaseDateWithOffset:row]];
        }else if (component==1){
            return [hourPickerViewMenu objectAtIndex:row];
        }else{
            return [minutePickerViewMenu objectAtIndex:row];
            
            
        }
    }else if([selectedItem isEqualToString:@"DetailsPayment"]){
        return [MyClass returnDateFromBaseDateWithOffset:row];
    }else{
        return [pickerViewmenu objectAtIndex:row];
    }
    
}*/

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
    // Fill the label text here
    
    if([selectedItem isEqualToString:@"DetailsPayment"]){
        tView.text= [MyClass returndateformatEEEDDMMMYYYYwithdateDDMMMYYYY:[MyClass returnDateFromBaseDateWithOffset:row]];
    }else if([selectedItem isEqualToString:@"PaidMethod"]){
        tView.text= [MyClass returntitlewithtitle:[pickerViewmenu objectAtIndex:row]];
    }else if([selectedItem isEqualToString:@"RefundMethod"]){
        tView.text= [MyClass returntitlewithtitle:[pickerViewmenu objectAtIndex:row]];
    }else{
        tView.text= [pickerViewmenu objectAtIndex:row];
    }
    
    //tView.text=[wishvalues objectAtIndex:row];
    return tView;
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if([selectedItem isEqualToString:@"DetailsPayment"]){
        return 260;
    }else{
        return 260;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    
    if ([selectedItem isEqualToString:@"RefundMethod"]){
        tmprefundmethod=[pickerViewmenu objectAtIndex:row];
        //showRefundMethodPicker=NO;
        
        [VoidTable reloadData];
        
    }/*else if([selectedItem isEqualToString:@"Category"]){
        if (![CategoryLabel.text isEqualToString:[pickerViewmenu objectAtIndex:row]]) {
            CategoryLabel.text=[pickerViewmenu objectAtIndex:row];
            ProductLabel.text=@"";
            CodeLabel.text=@"";
            swEnableNotification.on=NO;
            ProductDateTimeLabel.text=@"";
            NotificationDateTimeLabel.text=@"";
            
            showCategoryPicker=NO;
            [self getproductlistarraywithcategory:CategoryLabel.text];
            
      
            [SalesPopoverTable reloadData];
            
            [self adjusttablesize];
            
            
        }
        
        
    }else if([selectedItem isEqualToString:@"Product"]){
        if (![workingSales.productcategory isEqualToString:[pickerViewmenu objectAtIndex:row]]) {
            ProductLabel.text=[pickerViewmenu objectAtIndex:row];
            CodeLabel.text=[ProductCodeArray objectAtIndex:row];
            swEnableNotification.on=NO;
            ProductDateTimeLabel.text=@"";
            NotificationDateTimeLabel.text=@"";
            
            [self updatepriceinformation];
            
            showProductPicker=NO;
            
      
            [SalesPopoverTable reloadData];
            
            [self adjusttablesize];
            
            
        }
        
        
    }else if ([selectedItem isEqualToString:@"DetailsPayment"]){
        tmpPaidDate=[MyClass returnDateFromBaseDateWithOffset:row];
        showPaymentDatePicker=NO;

        
        [DetailsPaymentTable reloadData];
        

    }*/else if ([selectedItem isEqualToString:@"PaidMethod"]){
        tmppaidmethod=[pickerViewmenu objectAtIndex:row];
        //showPaidMethodPicker=NO;
        
        [DetailsPaymentTable reloadData];

    }
}

-(BOOL) InitializeField
{
    BOOL result=YES;
    workingSales=[[SalesRecord alloc]init];
    workingSales.studentkey=PopoverStudent.studentkey;
    
    availablepromotionarray=[[MyClass retrieveMarketingRecordWithStatus:@"Valid" enrollmentdate:workingSales.orderdate flushcachedata:NO subjectkey:nil productkey:[MyClass returnproductkeywithproductcode:workingSales.productcode]] objectAtIndex:2];
    
    if ([SalesTableMode isEqualToString:@"Edit"] || [SalesTableMode isEqualToString:@"View"]) {
        
        workingSales.paymentrecords=[MyClass copyPaymentRecordsWithPaymentRecords:SalesObject.paymentrecords];
        workingSales.promotiondiscountrecords=[MyClass copyPromotionDiscountRecordsWithPromotionDiscountRecords:SalesObject.promotiondiscountrecords];
        workingSales.couponrecords=[MyClass copyCouponRecordsWithCouponRecords:SalesObject.couponrecords];

        if ([SalesTableMode isEqualToString:@"View"]) {
            
            DiscountTableMode=@"View";
            DetailsPaymentTableMode=@"View";
            if (showDetailPayment){
                [self createPaymentToolBarwithMode:DetailsPaymentTableMode];
                [DetailsPaymentTable reloadData];
            }else if (showDiscountTable){
                showpromotioncodetable=NO;
                [DiscountTable reloadData];
                [self adjusttablesize];
            }
        }else{
            //workingSales.promotiondiscountrecords=[[NSMutableArray alloc]init];
            //workingSales.paymentrecords=[[NSMutableArray alloc]init];
            DetailsPaymentTableMode=@"View";
            DiscountTableMode=@"Edit";

            if (showDetailPayment){
                [self createPaymentToolBarwithMode:DetailsPaymentTableMode];
                [DetailsPaymentTable reloadData];
            }
        }
        
        
        [self showsidewindowwithwindow:@"none"];
        //showProductDateTimePicker=NO;
        //showNotificationDateTimePicker=NO;
        
        workingSales.saleskey=SalesObject.saleskey;
        workingSales.orderdate=SalesObject.orderdate;
        workingSales.productcategory=SalesObject.productcategory;
        workingSales.productfullname=[MyClass returnproductnamewithproductcode:SalesObject.productcode centerkey:globalvariables.centerrecord.centerkey];

        workingSales.productcode=SalesObject.productcode;
        workingSales.price=SalesObject.price;
        workingSales.quantity=SalesObject.quantity;
        workingSales.givenout=SalesObject.givenout;
        
        workingSales.oneoffdiscount=SalesObject.oneoffdiscount;
        workingSales.oneoffpercentagediscount=SalesObject.oneoffpercentagediscount;
        
        workingSales.total=SalesObject.total;
        workingSales.paid=SalesObject.paid;
        workingSales.status=SalesObject.status;
        [self calculatetotaldiscount];
        
        
        workingSales.remarks=SalesObject.remarks;
        workingSales.invoiceremarks=SalesObject.invoiceremarks;
        workingSales.autorenew=SalesObject.autorenew;

        
        [self getproductlistarraywithcategory:workingSales.productcategory];
        [MyClass retrieveUnusedCouponWithStudentkey:PopoverStudent.studentkey type:@"Sales" availableCouponArray:availablecouponarray typekey:[MyClass returnproductkeywithproductcode:workingSales.productcode]];
        
    }else if ([SalesTableMode isEqualToString:@"Add"]){
        
        [self showsidewindowwithwindow:@"none"];
        //showProductDateTimePicker=NO;
        //showNotificationDateTimePicker=NO;
        
        [df setDateFormat:@"dd-MMM-yyyy"];
        workingSales.orderdate=[df stringFromDate:[NSDate date]];
        workingSales.productcategory=@"";
        workingSales.productfullname=@"";
        workingSales.productcode=@"";
        workingSales.price=@"";
        workingSales.quantity=@"1";
        workingSales.givenout=@"";
        workingSales.oneoffdiscount=@"";
        workingSales.oneoffpercentagediscount=@"";
        [self calculatetotaldiscount];
        workingSales.total=@"";
        workingSales.paid=@"";
        workingSales.autorenew=@"No";

        workingSales.paymentrecords=[[NSMutableArray alloc]init];
        workingSales.promotiondiscountrecords=[[NSMutableArray alloc]init];
        workingSales.promotiondiscountrecords=[[NSMutableArray alloc]init];
        workingSales.paymentrecords=[[NSMutableArray alloc]init];
        
        [self applyEarlyBirdDiscount];
        [MyClass retrieveUnusedCouponWithStudentkey:PopoverStudent.studentkey type:@"Sales" availableCouponArray:availablecouponarray typekey:[MyClass returnproductkeywithproductcode:workingSales.productcode]];
        
        DiscountTableMode=@"Edit";
        
        workingSales.remarks=@"";
        workingSales.invoiceremarks=@"";
    }
    return result;
}

-(void) createPaymentToolBarwithMode:(NSString *)mode
{
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
    payment_receiptButton.hidden=YES;
    payment_invoiceButton.hidden=YES;
    payment_addButton.hidden=YES;
    payment_cancelButton.hidden=YES;
    payment_saveButton.hidden=YES;
    payment_cancelremarksButton.hidden=YES;
    payment_doneremarksButton.hidden=YES;
    
    if ([mode isEqualToString:@"View"]){
        if (([SalesTableMode isEqualToString:@"Add"] || [SalesTableMode isEqualToString:@"Edit"]) &&  ![SalesObject.status isEqualToString:@"Voided"]) {
            payment_addButton.hidden=NO;
//            UIBarButtonItem *addButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Add Payment"] style:UIBarButtonItemStylePlain target:self action:@selector(addpaymentrecord:)];
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.bounds = CGRectMake(0, 0, 20, 20);
//            [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(closedetailpayment) forControlEvents:UIControlEventTouchUpInside];
//            [button.heightAnchor constraintEqualToConstant:20].active = true;
//            [button.widthAnchor constraintEqualToConstant:20].active = true;
//            UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//            barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,addButton, nil];
            

            
        }else{
            
            
//            UIBarButtonItem *invoiceButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Invoice"] style:UIBarButtonItemStylePlain target:self action:@selector(shareinvoicebutton:)];
//            UIBarButtonItem *receiptButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Receipt"] style:UIBarButtonItemStylePlain target:self action:@selector(sharereceiptbutton:)];
//            
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            button.bounds = CGRectMake(0, 0, 20, 20);
//            [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//            [button addTarget:self action:@selector(closedetailpayment) forControlEvents:UIControlEventTouchUpInside];
//            [button.heightAnchor constraintEqualToConstant:20].active = true;
//            [button.widthAnchor constraintEqualToConstant:20].active = true;
//            UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
            
            if ([SalesObject.productcode isEqualToString:@"FPAY"]) {
//                barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace, nil];
            }else{
                if(workingSales.paymentrecords.count>0){
//                    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,receiptButton, flexSpace,invoiceButton, nil];
                    payment_receiptButton.hidden=NO;
                    payment_invoiceButton.hidden=NO;
                }else{
//                    barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,invoiceButton, nil];
                    payment_invoiceButton.hidden=NO;
                }
                
            }
            
        }
        
    }else if([mode isEqualToString:@"Add"]){
        payment_cancelButton.hidden=NO;
        payment_saveButton.hidden=NO;
        
        
//        UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(canceladdpayment:)];
//        //UIBarButtonItem *settleButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Settle All"] style:UIBarButtonItemStylePlain target:self action:@selector(settleAllButtonPressed:)];
//        UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Save"] style:UIBarButtonItemStylePlain target:self action:@selector(donepaymentrecord:)];
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.bounds = CGRectMake(0, 0, 20, 20);
//        [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(closedetailpayment) forControlEvents:UIControlEventTouchUpInside];
//        [button.heightAnchor constraintEqualToConstant:20].active = true;
//        [button.widthAnchor constraintEqualToConstant:20].active = true;
//        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//        if ([globalvariables.centerrecord.defaulteditablepaymentamount isEqualToString:@"No"]) {
//            barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,cancelButton,flexSpace,doneButton, nil];
//        }else{
//            barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,cancelButton,flexSpace,flexSpace,doneButton, nil];
//        }
    }else if ([mode isEqualToString:@"Edit"]){
        payment_cancelremarksButton.hidden=NO;
        payment_doneremarksButton.hidden=NO;
        
//        UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelpaymentremarks:)];
//        UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Save"] style:UIBarButtonItemStylePlain target:self action:@selector(donepaymentremarks:)];
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.bounds = CGRectMake(0, 0, 20, 20);
//        [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(closedetailpayment) forControlEvents:UIControlEventTouchUpInside];
//        [button.heightAnchor constraintEqualToConstant:20].active = true;
//        [button.widthAnchor constraintEqualToConstant:20].active = true;
//        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
//        barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,cancelButton,flexSpace,doneButton, nil];
    }/*else if ([mode isEqualToString:@"EditInvoiceRemarks"]){
        UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelpaymentremarks:)];
        UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Save"] style:UIBarButtonItemStylePlain target:self action:@selector(doneinvoiceremarks:)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, 20, 20);
        [button setImage:[UIImage imageNamed:@"closebutton_blue.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(closedetailpayment) forControlEvents:UIControlEventTouchUpInside];
        [button.heightAnchor constraintEqualToConstant:20].active = true;
        [button.widthAnchor constraintEqualToConstant:20].active = true;
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        barItems = [[NSMutableArray alloc]initWithObjects:closeButton,flexSpace,cancelButton,flexSpace,doneButton, nil];
    }*/
    
//    [paymentToolbar setItems:barItems];
    //[paymentMasterView addSubview:paymentToolbar];
    
    
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

-(void) checkdetailspaymentvalue:(UITextField *)sender
{
    if (![self checkvalidfeeinput:sender.text]){
        sender.text=@"";
    }
    tmppaidamount=sender.text;
}


-(void) adjusttablesize
{
    //
    float tableheight;
    float tablewidth;
    
    tableheight=maxPopupHeight-keyboardheight;
    
    if (showDetailPayment){
        tablewidth=popoverwidth+detailpaymentwidth;
    }else if (showVoidWindow){
        tablewidth=popoverwidth+voidwindowwidth;
    }else if (showCategoryTable){
        tablewidth=popoverwidth+categorytablewidth;
    }else if (showProductTable){
        tablewidth=popoverwidth+producttablewidth;
    }else if (showDiscountTable){
        if (showpromotioncodetable) {
            tablewidth=popoverwidth+discounttablewidth+promotioncodetablewidth;
        }else if (showcoupontable) {
            tablewidth=popoverwidth+discounttablewidth+promotioncodetablewidth;
        }else{
            tablewidth=popoverwidth+discounttablewidth;
        }
    }else{
        tablewidth=popoverwidth;
    }

    salesPopoverTableBottomConstraint.constant=keyboardheight;
//    [SalesPopoverTable setFrame:CGRectMake(0, 44+20, popoverwidth, tableheight-44-20)];
    if (self.preferredContentSize.width!=tablewidth) {
        [self.delegate adjustpresentingviewwidthwithwidth:tablewidth];
    }
    self.preferredContentSize=CGSizeMake(tablewidth, tableheight);
    
    if (showDetailPayment){
        [DetailsPaymentTable setFrame:CGRectMake(0, 44+20, detailpaymentwidth, tableheight-44-20)];
        DetailPaymentMasterView.hidden=NO;
        VoidWindowMasterView.hidden=YES;
        CategoryTableMasterView.hidden=YES;
        ProductTableMasterView.hidden=YES;
        DiscountTableMasterView.hidden=YES;
    }else if (showVoidWindow){
        DetailPaymentMasterView.hidden=YES;
        VoidWindowMasterView.hidden=NO;
        VoidTotalPaidLabel.text=[NSString stringWithFormat:@"%g", [workingSales.paid floatValue]];
        CategoryTableMasterView.hidden=YES;
        ProductTableMasterView.hidden=YES;
        DiscountTableMasterView.hidden=YES;
    }else if (showCategoryTable){
        [CategoryTable setFrame:CGRectMake(0, 44+88+20+3, categorytablewidth, tableheight-44-88-20-3)];
        DetailPaymentMasterView.hidden=YES;
        VoidWindowMasterView.hidden=YES;
        CategoryTableMasterView.hidden=NO;
        ProductTableMasterView.hidden=YES;
        DiscountTableMasterView.hidden=YES;
        
        if(filteredCategoryArray.count>0){
            presetRow=[filteredCategoryArray indexOfObject:workingSales.productcategory];
            [CategoryTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }else if (showProductTable){
        [ProductTable setFrame:CGRectMake(0, 44+88+20+3, producttablewidth, tableheight-44-88-20-3)];
        DetailPaymentMasterView.hidden=YES;
        VoidWindowMasterView.hidden=YES;
        CategoryTableMasterView.hidden=YES;
        ProductTableMasterView.hidden=NO;
        DiscountTableMasterView.hidden=YES;
        

        if(filteredProductArray.count>0){
            presetRow=[MyClass returnProductIndexWithProductArray:filteredProductArray code:workingSales.productcode];
            [ProductTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:presetRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }

    }else if (showDiscountTable){
        [DiscountTable setFrame:CGRectMake(0, 44, discounttablewidth, tableheight-44)];
//        [PromotionCodeTable setFrame:CGRectMake(0, 44+88, promotioncodetablewidth, self.view.frame.size.height-44-88)];
        
        couponview.hidden=!showcoupontable;
        promotioncodeview.hidden=!showpromotioncodetable;
        
        DetailPaymentMasterView.hidden=YES;
        VoidWindowMasterView.hidden=YES;
        CategoryTableMasterView.hidden=YES;
        ProductTableMasterView.hidden=YES;
        DiscountTableMasterView.hidden=NO;
    }else{
        DetailPaymentMasterView.hidden=YES;
        VoidWindowMasterView.hidden=YES;
        CategoryTableMasterView.hidden=YES;
        ProductTableMasterView.hidden=YES;
        DiscountTableMasterView.hidden=YES;
    }

}

-(IBAction) shareinvoicebutton:(UIButton *)sender
{
    invoiceorreceipt=@"invoice";
    invoiceprintbutton=sender;
    
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"sharedocument" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 160) View:self Button:sender ItemsArray:[[NSMutableArray alloc]initWithObjects:/*@"Print",*/@"Send eInvoice",@"Send Email",@"Add to Folder",@"More", nil] Title:nil];
    
}

-(IBAction) sharereceiptbutton:(UIButton *)sender
{
    invoiceorreceipt=@"receipt";
    receiptprintbutton=sender;
    
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"sharedocument" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 160) View:self Button:sender ItemsArray:[[NSMutableArray alloc]initWithObjects:/*@"Print",*/@"Send eReceipt",@"Send Email",@"Add to Folder",@"More", nil] Title:nil];
    
}

-(void) sharepaymentinvoicewithtableview:(UITableView *)tableview indexpath:(NSIndexPath *)indexpath
{
    
    SalesInvoiceRecord *salesinvoicerecord=[[SalesInvoiceRecord alloc]initSalesInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity outstandingamount:[NSString stringWithFormat:@"%g",[SalesObject.total floatValue]-[SalesObject.paid floatValue]] invoiceremarks:SalesObject.invoiceremarks image:nil checkstatus:nil salesrecord:SalesObject productname:nil];
    
    NSData *pdfData = [MyClass generateInvoiceWithClassInvoiceArray:nil SalesInvoiceArray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] papersizeoverride:NO combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
    
    
    // Create a filePath for the pdf.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Invoice-%@.pdf",[MyClass returninvoicenumberwithclassinvoicearray:nil salesinvoicearray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] updateinvoicelog:NO]]];
    [pdfData writeToFile:filePath atomically:YES];
    
    // Open the controller.
    documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    documentInteractionController.delegate = self;
    documentInteractionController.UTI = @"com.adobe.pdf";
    [documentInteractionController setName:@"Invoice"];
    
    
    //UITableViewCell *Cell = [tableview cellForRowAtIndexPath:indexpath];
    
    //CGRect rect=CGRectMake(Cell.bounds.origin.x, Cell.bounds.origin.y+3, 50, 30);
    
    
    //[documentInteractionController presentOptionsMenuFromRect:rect inView:Cell animated:YES];
    [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [documentInteractionController presentOptionsMenuFromRect:invoiceprintbutton.frame inView:invoiceprintbutton animated:YES];
//    [documentInteractionController presentOptionsMenuFromBarButtonItem:invoiceprintbutton animated:YES];
}

-(NSString *) returntotalpaidwithindexpath:(NSIndexPath *)indexpath
{
    float totalpaid=0;
    for (long i=indexpath.row; i<workingSales.paymentrecords.count; i++) {
        totalpaid+=[((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:i]).paidamount floatValue];
    }
    
    return [NSString stringWithFormat:@"%g",totalpaid];
}

-(void) sharepaymentreceiptwithtableview:(UITableView *)tableview indexpath:(NSIndexPath *)indexpath
{
    SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
    
    NSData *pdfData=[MyClass generateReceiptWithClassReceiptArray:nil SalesReceiptArray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] papersizeoverride:NO combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
    
    // Create a filePath for the pdf.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Receipt-%@.pdf",[MyClass returnreceiptnumberwithclassreceiptarray:nil salesreceiptarray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil]]]];
    [pdfData writeToFile:filePath atomically:YES];
    
    // Open the controller.
    documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    documentInteractionController.delegate = self;
    documentInteractionController.UTI = @"com.adobe.pdf";
    [documentInteractionController setName:@"Receipt"];
    
    
    //UITableViewCell *Cell = [tableview cellForRowAtIndexPath:indexpath];
    
    //CGRect rect=CGRectMake(Cell.bounds.origin.x, Cell.bounds.origin.y+3, 50, 30);
    
    
    //[documentInteractionController presentOptionsMenuFromRect:rect inView:Cell animated:YES];
    [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [documentInteractionController presentOptionsMenuFromRect:receiptprintbutton.frame inView:receiptprintbutton animated:YES];
//    [documentInteractionController presentOptionsMenuFromBarButtonItem:receiptprintbutton animated:YES];
}

- (UIImage *) convertToGreyscale:(UIImage *)i {
    
    int kRed = 1;
    int kGreen = 2;
    int kBlue = 4;
    
    int colors = kGreen | kBlue | kRed;
    int m_width = i.size.width;
    int m_height = i.size.height;
    
    uint32_t *rgbImage = (uint32_t *) malloc(m_width * m_height * sizeof(uint32_t));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImage, m_width, m_height, 8, m_width * 4, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    CGContextDrawImage(context, CGRectMake(0, 0, m_width, m_height), [i CGImage]);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // now convert to grayscale
    uint8_t *m_imageData = (uint8_t *) malloc(m_width * m_height);
    for(int y = 0; y < m_height; y++) {
        for(int x = 0; x < m_width; x++) {
            uint32_t rgbPixel=rgbImage[y*m_width+x];
            uint32_t sum=0,count=0;
            if (colors & kRed) {sum += (rgbPixel>>24)&255; count++;}
            if (colors & kGreen) {sum += (rgbPixel>>16)&255; count++;}
            if (colors & kBlue) {sum += (rgbPixel>>8)&255; count++;}
            m_imageData[y*m_width+x]=sum/count;
        }
    }
    free(rgbImage);
    
    // convert from a gray scale image back into a UIImage
    uint8_t *result = (uint8_t *) calloc(m_width * m_height *sizeof(uint32_t), 1);
    
    // process the image back to rgb
    for(int i = 0; i < m_height * m_width; i++) {
        result[i*4]=0;
        int val=m_imageData[i];
        result[i*4+1]=val;
        result[i*4+2]=val;
        result[i*4+3]=val;
    }
    
    // create a UIImage
    colorSpace = CGColorSpaceCreateDeviceRGB();
    context = CGBitmapContextCreate(result, m_width, m_height, 8, m_width * sizeof(uint32_t), colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *resultUIImage = [UIImage imageWithCGImage:image];
    CGImageRelease(image);
    
    free(m_imageData);
    
    // make sure the data will be released by giving it to an autoreleased NSData
    [NSData dataWithBytesNoCopy:result length:m_width * m_height];
    
    return resultUIImage;
}


-(BOOL) retrieveProductListWithFlush:(BOOL)flush
{
    
    ProductArray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveproductinformationwithcategory:@"All" status:@"Active" flushcachedata:flush]];
    filteredProductArray=[[NSMutableArray alloc]initWithArray:ProductArray];
    
    if (ProductArray) {
        for (int i=0; i<ProductArray.count; i++) {
            ProductRecord *obj=[ProductArray objectAtIndex:i];
            if (![CategoryArray containsObject:obj.category]) {
                [CategoryArray addObject:obj.category];
            }
        }
        filteredCategoryArray=[[NSMutableArray alloc]initWithArray:CategoryArray];
        return YES;
    }else{
        return NO;
    }

}

-(void) getproductlistarraywithcategory:(NSString *)category
{
    if ([category isEqualToString:@""]){
        filteredProductArray=[[NSMutableArray alloc]initWithArray:ProductArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.category = %@",category];
        filteredProductArray=[[NSMutableArray alloc]initWithArray:[ProductArray filteredArrayUsingPredicate:predicate]];
    }

    [self sortFilteredProductArray];
    [ProductTable reloadData];

}



-(void) updatepriceinformation
{
    if (![workingSales.productcode isEqualToString:@""]) {
        for (int i=0; i<ProductArray.count; i++) {
            productobject=[ProductArray objectAtIndex:i];
            if ([productobject.code isEqualToString:workingSales.productcode]) {
                workingSales.price=[NSString stringWithFormat:@"%g",[productobject.price floatValue]];
                [self calculateTotalFee];
                //workingSales.total=[NSString stringWithFormat:@"%g",([productobject.price floatValue] * [workingSales.quantity floatValue])-[tmpDiscount floatValue]];
                //TotalPriceLabel.text=workingSales.total;
                //[SalesPopoverTable reloadData];
                
                if (showDetailPayment) {
                    paymenttotalfeeLabel.text=workingSales.total;
                    paymentoutstandingLabel.text=[NSString stringWithFormat:@"%g",[paymenttotalfeeLabel.text doubleValue]-[paymenttotalpaidLabel.text doubleValue]];
                }
                break;
            }
        }
        
        //update givenout
        if([productobject.stockcount isEqualToString:@""]){
            workingSales.givenout=workingSales.quantity;
        }else if([productobject.stockcount intValue]>=[workingSales.quantity intValue]-[SalesObject.givenout intValue]){
            workingSales.givenout=workingSales.quantity;
        }else if ([productobject.stockcount intValue]>0){
            workingSales.givenout=[@([productobject.stockcount intValue]+[SalesObject.givenout intValue]) stringValue];
        }else{
            workingSales.givenout=[@([SalesObject.givenout intValue]) stringValue];
        }
    }
}
/*
-(void) setquantity:(UIStepper *)sender
{
    workingSales.quantity=[NSString stringWithFormat:@"%d",[[NSNumber numberWithDouble:[(UIStepper *)sender value]] intValue]];
    [self showsidewindowwithwindow:@"none"];
    //showProductDateTimePicker=NO;
    //showNotificationDateTimePicker=NO;
    [self updatepriceinformation];
    
    
    [SalesPopoverTable reloadData];
    [self adjusttablesize];
    
}*/

-(void) updatetextfield:(UITextField *)sender
{
    if (sender==QuantityText) {
        if ([MyClass checkValidInput:sender.text Type:@"EmptyInteger"]) {
            workingSales.quantity=sender.text;
            [self updatepriceinformation];
            GivenOutText.text=workingSales.givenout;
        }else{
            sender.text=workingSales.quantity;
        }
    }else if (sender==GivenOutText) {
        if ([MyClass checkValidInput:sender.text Type:@"ZeroInteger"]) {
            if([productobject.stockcount isEqualToString:@""]){
                workingSales.givenout=sender.text;
            }else if([productobject.stockcount intValue]>=[sender.text intValue]-[SalesObject.givenout intValue]){
                workingSales.givenout=sender.text;
            }else if ([productobject.stockcount intValue]>0){
                workingSales.givenout=[@([productobject.stockcount intValue]+[SalesObject.givenout intValue]) stringValue];
                sender.text=workingSales.givenout;
            }else{
                workingSales.givenout=[@([SalesObject.givenout intValue]) stringValue];
                sender.text=workingSales.givenout;
            }
            GivenOutText.text=workingSales.givenout;
        }else{
            sender.text=workingSales.quantity;
        }
    }
    
    [self showsidewindowwithwindow:@"none"];
    //[SalesPopoverTable reloadData];
    [self adjusttablesize];
}

/*
-(void) updatetotalprice:(UITextField *)sender
{
    if (![self checkvalidfeeinput:sender.text]) {
        sender.text=@"";
        tmpDiscount=sender.text;
    }else{
        tmpDiscount=sender.text;
        [self updatepriceinformation];
    }
    TotalPriceLabel.text=workingSales.total;
    
}*/

-(IBAction) doneButtonPressed:(id)sender{
    if (keyboardheight>0) {
        [self.view endEditing:YES];
    }
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSString *alertTitle;
        
        if ([SalesTableMode isEqualToString:@"Edit"]) {
            alertTitle=[MyClass returntitlewithtitle:@"Edit Sales Record"];
        }else if ([SalesTableMode isEqualToString:@"Add"]) {
            alertTitle=[MyClass returntitlewithtitle:@"New Sales Record"];
        }
        
        
        
        if ([workingSales.productcategory isEqualToString:@""]) {
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:alertTitle message:[MyClass returntitlewithtitle:@"Please select product category"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
        }else if ([workingSales.productfullname isEqualToString:@""]) {
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:alertTitle message:[MyClass returntitlewithtitle:@"Please select product"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
        }else{
            [self updateSales];
        }
    });
}

-(void) updateSales
{
    
    NSDate *date;
    NSString *sqlorderdate;
    SalesRecord *tmpsalesobject;
    BOOL result=FALSE;
    
    [df setDateFormat:@"dd-MMM-yyyy"];
    date=[df dateFromString:workingSales.orderdate];
    [df setDateFormat:@"yyyy-MM-dd"];
    sqlorderdate=[df stringFromDate:date];
    
    
    
    if ([SalesTableMode isEqualToString:@"Edit"]) {
        //update sales order
        
        tmpsalesobject=[[SalesRecord alloc]initSalesRecordWithstudentkey:SalesObject.studentkey saleskey:SalesObject.saleskey orderdate:workingSales.orderdate productfullname:workingSales.productfullname productcode:workingSales.productcode productcategory:workingSales.productcategory price:workingSales.price quantity:workingSales.quantity oneoffdiscount:workingSales.oneoffdiscount oneoffpercentagediscount:workingSales.oneoffpercentagediscount paid:workingSales.paid total:workingSales.total remarks:workingSales.remarks invoiceremarks:workingSales.invoiceremarks status:SalesObject.status reverseadjustment:SalesObject.reverseadjustment autorenew:workingSales.autorenew paymentrecords:workingSales.paymentrecords promotiondiscountrecords:workingSales.promotiondiscountrecords givenout:workingSales.givenout couponrecords:workingSales.couponrecords invoicenumber:nil invoiceprefix:nil];
        
        

        result=[self updateSalesPaymentWithSalesObject:tmpsalesobject DetailsPaymentArray:workingSales.paymentrecords Action:@"Edit" PromotionArray:workingSales.promotiondiscountrecords];
        
        
        
        if (result) {

        }else{
            [MyClass showconnectionlostdialogbox];
        }
    }else if ([SalesTableMode isEqualToString:@"Add"]){
        tmpsalesobject=[[SalesRecord alloc]initSalesRecordWithstudentkey:PopoverStudent.studentkey saleskey:@"" orderdate:workingSales.orderdate productfullname:workingSales.productfullname productcode:workingSales.productcode productcategory:workingSales.productcategory price:workingSales.price quantity:workingSales.quantity oneoffdiscount:workingSales.oneoffdiscount oneoffpercentagediscount:workingSales.oneoffpercentagediscount paid:workingSales.paid total:workingSales.total remarks:workingSales.remarks invoiceremarks:workingSales.invoiceremarks status:@"" reverseadjustment:@"" autorenew:workingSales.autorenew paymentrecords:workingSales.paymentrecords promotiondiscountrecords:workingSales.promotiondiscountrecords givenout:workingSales.givenout couponrecords:workingSales.couponrecords invoicenumber:nil invoiceprefix:nil];
        

        result=[self updateSalesPaymentWithSalesObject:tmpsalesobject DetailsPaymentArray:workingSales.paymentrecords Action:@"Add" PromotionArray:workingSales.promotiondiscountrecords];
        
        
        if (result) {


        }else{
            [MyClass showconnectionlostdialogbox];
        }
    }
    
    if (result) {
        SalesTableMode=@"View";
        SalesObject=[self.delegate updatesalesrecordandreturnsalesrecord:workingSales.saleskey];
        [self InitializeField];
        [self createViewBarButton];
        
        [SalesPopoverTable reloadData];
        
        [self adjusttablesize];
        
        
        [self retrieveProductListWithFlush:YES];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        ProductRecord *obj=[MyClass returnProductInformationWithCode:workingSales.productcode centerkey:globalvariables.centerrecord.centerkey];
        if([obj.stockcount integerValue]<0){
            UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Inventory"] message:[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Insufficient stock available!"],obj.stockcount] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [missinginput dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [missinginput addAction:OKAction];
            //[self presentViewController:missinginput animated:YES completion:nil];
            [MyClass presentViewController:missinginput View:self];
        }
        
//        if(newReceiptToBeMessaged && globalvariables.centerrecord.autosendereceipt){
//            [self autosendereceipt];
//        }
        
        
    }
}


-(void) messagePDF:(NSData *)pdfData studentkeys:(NSMutableArray *)studentkeys pdfType:(NSString *)pdftype filename:(NSString *)filename acknowledge:(BOOL)acknowledge
{
    OutboxMessageRecord *object=[[OutboxMessageRecord alloc]init];
    object.photoarray=[[NSMutableArray alloc]init];
    object.messageenglish=[NSString stringWithFormat:@"%@ %@",[MyClass returntitlewithtitle:pdftype language:@"English"],filename];
    object.messagechinese=[NSString stringWithFormat:@"%@%@",[MyClass returntitlewithtitle:pdftype language:@"Chinese"],filename];
    object.recipienttype=@"Student";
    object.recipientgroup=[[RecipientGroupRecord alloc]init];
    object.recipientgroup.individualarray=[[NSMutableArray alloc]initWithArray:studentkeys];
    object.messagetype=[NSString stringWithFormat:@"e%@",pdftype];
    
    NSURL *interalurl=[MyClass returnInternalURLforNSData:pdfData Filename:[NSString stringWithFormat:@"%@.pdf", object.messageenglish]];
    [object.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:nil Width:0 Height:0 FileType:@"pdf" InternalURL:interalurl FileName:[NSString stringWithFormat:@"%@.pdf", object.messageenglish] ThumbnailURL:@""]];

    MessagePopoverViewController *viewController = (MessagePopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MessagePopoverViewController"];
    //viewController.delegate=self;
    [viewController sendMessageWithOutBoxMessage:object];
    [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    
    if(acknowledge){
        UIAlertController *missinginput = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:pdftype] message:[MyClass returntitlewithtitle:@"Message Sent"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [missinginput dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [missinginput addAction:OKAction];
        //[self presentViewController:missinginput animated:YES completion:nil];
        [MyClass presentViewController:missinginput View:self];
    }

}

- (void)emailPDF:(NSData*)pdfData pdftype:(NSString *) pdftype filename:(NSString *)filename receiptient:(NSArray *)receipientarray{
    
    if(receipientarray.count==0){
        [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
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
        [mail setToRecipients:@[PopoverStudent.parentemail]];
        [mail setMessageBody:[MyClass returntitlewithtitle:@"Please edit your email content"] isHTML:YES];
        
        [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
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

- (void)printPDF:(NSData*)pdfData {
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
    
    /*UIPrintInteractionCompletionHandler completionHandler =
    ^(UIPrintInteractionController *pic, BOOL completed, NSError *error) {
        if (!completed && error)
        NSLog(@"FAILED! error = %@",[error localizedDescription]);
    };*/
    [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    //[printer presentAnimated:YES completionHandler:completionHandler];
    
    
    if ([invoiceorreceipt isEqualToString:@"receipt"]) {
//        [printer presentFromRect:receiptprintbutton.bounds inView:receiptprintbutton animated:YES completionHandler:nil];
        [printer presentFromBarButtonItem:receiptprintbutton animated:YES completionHandler:nil];
    }else{
        [printer presentFromBarButtonItem:invoiceprintbutton animated:YES completionHandler:nil];
    }
    
}

-(NSArray *) returnmailreceiptientwithclassarray:(NSMutableArray *)classarray salesarray:(NSMutableArray *)salesarray type:(NSString *)type
{
    NSMutableArray *mailreceiptientarray=[[NSMutableArray alloc]init];
    if ([type isEqualToString:@"Invoice"]) {
        for (int i=0; i<classarray.count; i++) {
            if (![((ClassInvoiceRecord *)[classarray objectAtIndex:i]).parentemail isEqualToString:@""]) {
                [mailreceiptientarray addObject:((ClassInvoiceRecord *)[classarray objectAtIndex:i]).parentemail];
            }
        }
        
        for (int i=0; i<salesarray.count; i++) {
            if (![((SalesInvoiceRecord *)[salesarray objectAtIndex:i]).parentemail isEqualToString:@""]) {
                [mailreceiptientarray addObject:((SalesInvoiceRecord *)[salesarray objectAtIndex:i]).parentemail];
            }
        }
    }else{
        for (int i=0; i<classarray.count; i++) {
            if (![((ClassReceiptRecord *)[classarray objectAtIndex:i]).parentemail isEqualToString:@""]) {
                [mailreceiptientarray addObject:((ClassReceiptRecord *)[classarray objectAtIndex:i]).parentemail];
            }
        }
        
        for (int i=0; i<salesarray.count; i++) {
            if (![((SalesReceiptRecord *)[salesarray objectAtIndex:i]).parentemail isEqualToString:@""]) {
                [mailreceiptientarray addObject:((SalesReceiptRecord *)[salesarray objectAtIndex:i]).parentemail];
            }
        }
    }
    
    return mailreceiptientarray;
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

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if (keyboardheight>0) {
        if (/*textView==invoiceremarksText || */textView==receiptremarksText || textView==paymentremarksText) {
            CGPoint point = [textView.superview convertPoint:CGPointZero toView:DetailsPaymentTable];
            NSIndexPath *indexpath =[DetailsPaymentTable indexPathForRowAtPoint:point];
            
            CGRect rectInTableView = [DetailsPaymentTable rectForRowAtIndexPath:indexpath];
            
            if (rectInTableView.origin.y+rectInTableView.size.height-DetailsPaymentTable.frame.size.height>0) {
                [DetailsPaymentTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-DetailsPaymentTable.frame.size.height) animated:YES];
            }else{
                [DetailsPaymentTable setContentOffset:CGPointMake(0, 0) animated:YES];
            }
        }else{
            CGPoint point = [textView.superview convertPoint:CGPointZero toView:SalesPopoverTable];
            NSIndexPath *indexpath =[SalesPopoverTable indexPathForRowAtPoint:point];
            
            CGRect rectInTableView = [SalesPopoverTable rectForRowAtIndexPath:indexpath];
            
            [SalesPopoverTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-SalesPopoverTable.frame.size.height) animated:YES];
        }
    }

}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView==RemarksText) {
        workingSales.remarks=textView.text;
    }else if (textView==paymentremarksText){
        tmppaymentremarks=textView.text;
    }else if (textView==receiptremarksText){
        tmpreceiptremarks=textView.text;
    }else if (textView==invoiceremarksText){
        workingSales.invoiceremarks=textView.text;
    }
}

-(IBAction) cancelpaymentremarks:(id)sender
{
    DetailsPaymentTableMode=@"View";
    [DetailsPaymentTable reloadData];
    
    [self createPaymentToolBarwithMode:@"View"];
    
    /*if (DetailsPaymentTable.contentSize.height>maxpaymentpopupheight) {
        [DetailsPaymentTable setFrame:CGRectMake(0, 0, 300,  maxpaymentpopupheight)];
    }else{
        [DetailsPaymentTable setFrame:CGRectMake(0, 0, 300,  DetailsPaymentTable.contentSize.height)];
    }
    
    [paymentMasterView setFrame:CGRectMake(0, 0, 300, DetailsPaymentTable.frame.size.height+44)];
    myPaymentPopoverController.popoverContentSize=CGSizeMake(300, DetailsPaymentTable.frame.size.height+44);
    [paymentScrollView setFrame:CGRectMake(0, 44, 300, DetailsPaymentTable.frame.size.height)];
    [paymentScrollView setContentSize:CGSizeMake(300, DetailsPaymentTable.frame.size.height)];*/
}

-(IBAction) canceladdpayment:(id)sender
{
    DetailsPaymentTableMode=@"View";
    [DetailsPaymentTable reloadData];
    
    [self createPaymentToolBarwithMode:@"View"];
    
    /*if (DetailsPaymentTable.contentSize.height>maxpaymentpopupheight) {
        [DetailsPaymentTable setFrame:CGRectMake(0, 0, 300,  maxpaymentpopupheight)];
    }else{
        [DetailsPaymentTable setFrame:CGRectMake(0, 0, 300,  DetailsPaymentTable.contentSize.height)];
    }
    
    [paymentMasterView setFrame:CGRectMake(0, 0, 300, DetailsPaymentTable.frame.size.height+44)];
    myPaymentPopoverController.popoverContentSize=CGSizeMake(300, DetailsPaymentTable.frame.size.height+44);
    [paymentScrollView setFrame:CGRectMake(0, 44, 300, DetailsPaymentTable.frame.size.height)];
    [paymentScrollView setContentSize:CGSizeMake(300, DetailsPaymentTable.frame.size.height)];*/
}

-(IBAction) donepaymentremarks:(id)sender
{
    PaymentRecord *DetailsPaymentObject=[workingSales.paymentrecords objectAtIndex:DetailsPaymentObjectIndex];
    [workingSales.paymentrecords replaceObjectAtIndex:DetailsPaymentObjectIndex withObject:[[PaymentRecord alloc]initPaymentRecordwithPaymentkey:DetailsPaymentObject.paymentkey paymenttype:DetailsPaymentObject.paymenttype paymenttypekey:DetailsPaymentObject.paymenttypekey paiddate:DetailsPaymentObject.paiddate paidmethod:DetailsPaymentObject.paidmethod paidamount:DetailsPaymentObject.paidamount action:[DetailsPaymentObject.action isEqualToString:@"add"]?@"add":@"edit" paymentremarks:paymentremarksText.text receiptremarks:receiptremarksText.text staffname:DetailsPaymentObject.staffname receiptnumber:DetailsPaymentObject.receiptnumber receiptprefix:DetailsPaymentObject.receiptprefix]];
    
    DetailsPaymentTableMode=@"View";
    [DetailsPaymentTable reloadData];
    
    [self createPaymentToolBarwithMode:@"View"];
    


}

/*
-(void) doneinvoiceremarks:(id)sender
{
    workingSales.invoiceremarks=invoiceremarksText.text;
    
    DetailsPaymentTableMode=@"View";
    [DetailsPaymentTable reloadData];
    
    [self createPaymentToolBarwithMode:@"View"];
    

    
}*/

-(void)offsettextfield:(UITextField *)sender
{
    //
    //[EnrollmentPopoverTable setContentOffset:CGPointMake(0, 300)];
    if (keyboardheight>0) {
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:SalesPopoverTable];
        NSIndexPath *indexpath =[SalesPopoverTable indexPathForRowAtPoint:point];
        
        CGRect rectInTableView = [SalesPopoverTable rectForRowAtIndexPath:indexpath];
        
        if (rectInTableView.origin.y+rectInTableView.size.height-SalesPopoverTable.frame.size.height+32>0) {
            [SalesPopoverTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-SalesPopoverTable.frame.size.height+32) animated:YES];
        }
    }
}



-(BOOL) updateSalesPaymentWithSalesObject:(SalesRecord *)salesobject DetailsPaymentArray:(NSMutableArray *)detailspaymentarray Action:(NSString *)action PromotionArray:(NSMutableArray *)promotionarray
{

    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsonpaymentarray=[[NSArray alloc]init];
    NSArray *jsonpromotionarray=[[NSArray alloc]init];
    NSArray *jsoncouponarray=[[NSArray alloc]init];
    
    newReceiptToBeMessaged=FALSE;
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:@"updatesales" forKey:@"postaction"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:action forKey:@"action"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:@"ios" forKey:@"os"];
    [dictionary setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] forKey:@"build"];
    [dictionary setValue:PopoverStudent.studentkey forKey:@"studentkey"];
    [dictionary setValue:salesobject.saleskey forKey:@"saleskey"];
    
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"orderdate" NewValue:[MyClass convertDateFormatWithDate:salesobject.orderdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"]  OldValue:[MyClass convertDateFormatWithDate:SalesObject.orderdate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"] Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"productcode" NewValue:salesobject.productcode OldValue:SalesObject.productcode Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"price" NewValue:salesobject.price OldValue:SalesObject.price Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"quantity" NewValue:salesobject.quantity OldValue:SalesObject.quantity Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"givenout" NewValue:salesobject.givenout OldValue:SalesObject.givenout Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"oneoffdiscount" NewValue:salesobject.oneoffdiscount OldValue:SalesObject.oneoffdiscount Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"oneoffpercentagediscount" NewValue:salesobject.oneoffpercentagediscount OldValue:SalesObject.oneoffpercentagediscount Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"paid" NewValue:salesobject.paid OldValue:SalesObject.paid Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"total" NewValue:salesobject.total OldValue:SalesObject.total Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"remarks" NewValue:salesobject.remarks OldValue:SalesObject.remarks Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"invoiceremarks" NewValue:salesobject.invoiceremarks OldValue:SalesObject.invoiceremarks Action:action];
    dictionary=[MyClass returnDictionaryWithDictionary:dictionary Key:@"autorenew" NewValue:salesobject.autorenew OldValue:SalesObject.autorenew Action:action];
    
    //generate json payment array
    if (detailspaymentarray.count>0) {
        
        arrayOfDicts = [[NSMutableArray alloc] init];
        keys=[NSArray arrayWithObjects:@"paymentkey",@"paymenttypekey",@"paiddate",@"paidamount",@"paidmethod",@"paymenttype",@"paymentremarks",@"receiptremarks", @"staffname",@"action",@"arckey",nil];
        
        for (long i=detailspaymentarray.count-1;i>=0;i--){
            //for (int i = 0; i<detailspaymentarray.count; i++) {
            PaymentRecord *DetailsPaymentObject=[detailspaymentarray objectAtIndex:i];
            
            values=[NSArray arrayWithObjects:DetailsPaymentObject.paymentkey,DetailsPaymentObject.paymenttypekey,[MyClass convertDateFormatWithDate:DetailsPaymentObject.paiddate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd"],DetailsPaymentObject.paidamount,DetailsPaymentObject.paidmethod,DetailsPaymentObject.paymenttype,DetailsPaymentObject.paymentremarks,DetailsPaymentObject.receiptremarks,DetailsPaymentObject.staffname,DetailsPaymentObject.action, [MyClass returndefaultarckey], nil];
            
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
        jsonpaymentarray = [NSArray arrayWithArray:arrayOfDicts];
    }
    
    //generate json promotion array
    if (promotionarray.count>0) {
        
        arrayOfDicts = [[NSMutableArray alloc] init];
        keys=[NSArray arrayWithObjects:@"marketingkey",@"recursive",nil];
        
        for (long i =0; i< promotionarray.count; i++) {
            //for (int i = 0; i<detailspaymentarray.count; i++) {
            marketingobject=[promotionarray objectAtIndex:i];
            
            values=[NSArray arrayWithObjects:marketingobject.marketingkey, marketingobject.recursive,nil];
            
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
        jsonpromotionarray = [NSArray arrayWithArray:arrayOfDicts];
    }
    
    //generate json coupon array
    if (workingSales.couponrecords.count>0) {
        
        arrayOfDicts = [[NSMutableArray alloc] init];
        keys=[NSArray arrayWithObjects:@"couponkey",nil];
        
        for (long i =0; i< workingSales.couponrecords.count; i++) {
            //for (int i = 0; i<detailspaymentarray.count; i++) {
            CouponRecord *obj=[workingSales.couponrecords objectAtIndex:i];
            
            values=[NSArray arrayWithObjects:obj.couponkey,nil];
            
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
        jsoncouponarray = [NSArray arrayWithArray:arrayOfDicts];
    }
    
    
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:jsonpaymentarray forKey:@"paymentarray"];
    [dictionary setValue:jsonpromotionarray forKey:@"promotionarray"];
    [dictionary setValue:jsoncouponarray forKey:@"couponarray"];
    

    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        
        //NSString *resString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray=jsonreturned[@"content"];
            workingSales.saleskey=[[JSONArray objectAtIndex:0] objectForKey:@"saleskey"];
//            SalesObject=workingSales;
//            NSArray *paymentkeyarray=[[[JSONArray objectAtIndex:0] objectForKey:@"paymentkey"] componentsSeparatedByString:@","];
            
//            int newpaymentkeycount=0;
//            for (int p=0; p<detailspaymentarray.count; p++) {
//                PaymentRecord *DetailsPaymentObject=[detailspaymentarray objectAtIndex:p];
//                if ([DetailsPaymentObject.action isEqualToString:@"add"]) {
//                    DetailsPaymentObject.paymentkey=[paymentkeyarray objectAtIndex:newpaymentkeycount];
//                    DetailsPaymentObject.action=@"locked";
//                    if([DetailsPaymentObject.paidamount floatValue]>0){
//                        newReceiptToBeMessaged=TRUE;
//                    }
//                    newpaymentkeycount +=1;
//                }
//            }
            result=TRUE;
            
            /*if ([[[JSONArray objectAtIndex:0] objectForKey:@"result"] isEqualToString:@"success"]) {
                result= YES;
            }*/
        }
    }];
    
    
        
    //auto message receipt
    /*if(result && newReceiptToBeMessaged && globalvariables.centerrecord.autosendereceipt){
        [self autosendereceipt];
    }*/
        
    return result;
}




- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView==SalesPopoverTable) {
        if ([tableView numberOfSections]-1==section) {
            return 30;
        }else{
            return CGFLOAT_MIN;
        }
    }else if (tableView==CategoryTable){
        return 30;
    }else if (tableView==ProductTable){
        return 50;
    }else if (tableView==VoidTable){
        return 30;
    }else if (tableView==DiscountTable){
        if (section==0) {
            if (availablepromotionarray.count>0) {
                return 38;
            }
        }else if(section==2){
            return workingSales.couponrecords.count>0?CGFLOAT_MIN:(globalvariables.centerrecord.ecoupon?38:0);
        }else if (section==3){
            return 30;
        }
    }else if (tableView==PromotionCodeTable){
        if (filteredavailablepromotionarray.count==0) {
            return 38;
        }else{
            return 30;
        }
    }else if (tableView==CouponTable){
        if (filteredavailablecouponarray.count==0) {
            return 38;
        }else{
            return 30;
        }
    }
    return CGFLOAT_MIN;
    
}

-(void) closedetailpayment
{
    [self showsidewindowwithwindow:@"none"];
    //showDetailPayment=NO;
    [SalesPopoverTable deselectRowAtIndexPath:[SalesPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) closevoidsaleswindow
{
    [self showsidewindowwithwindow:@"none"];
    //showVoidWindow=NO;
    [SalesPopoverTable deselectRowAtIndexPath:[SalesPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) closecategorytable
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [SalesPopoverTable deselectRowAtIndexPath:[SalesPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) closeproducttable
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [SalesPopoverTable deselectRowAtIndexPath:[SalesPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) closediscounttable
{
    [self.view endEditing:YES];
    [self showsidewindowwithwindow:@"none"];
    [SalesPopoverTable deselectRowAtIndexPath:[SalesPopoverTable indexPathForSelectedRow] animated:YES];
    [self adjusttablesize];
}

-(void) cancelVoidSalesPressed
{
    UIAlertController *deleteenrollmentalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Cancel Void"] message:[MyClass returntitlewithtitle:@"Are you sure to cancel the void?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self cancelVoidSales];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [deleteenrollmentalert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [deleteenrollmentalert addAction:OKAction];
    [deleteenrollmentalert addAction:CancelAction];
    
    [MyClass presentViewController:deleteenrollmentalert View:self];
}

-(void) cancelVoidSales
{
    [self.view endEditing:YES];
    __block BOOL result=FALSE;
    NSDictionary *dictionary = @{@"postaction" : @"cancelvoidsales",
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"saleskey" : SalesObject.saleskey,
                                 @"updatedby" : globalvariables.username,
                                 @"arckey" : [MyClass returndefaultarckey]};
    
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];

    if (result) {
        [self.delegate dismissSalesPopover];
    }
}


-(void) showVoidEnrollmentWindow
{
    if (!showVoidWindow) {
        [self InitializeField];
        //showDetailPayment=FALSE;
        //showVoidWindow=TRUE;
        [self showsidewindowwithwindow:@"showVoidWindow"];
        
        
        [SalesPopoverTable reloadData];
        
        showRefundMethodPicker=NO;
//        tmprefundmethod=@"Cash";
        tmprefundmethod=globalvariables.centerrecord.paymentmethods.firstObject;
        tmprefundamount=workingSales.paid;
        tmpvoidforfeitedamount=@"";
        tmpreceiptremarks=globalvariables.centerrecord.defaultreceiptremarksasinvoiceremarksforproductsales?workingSales.invoiceremarks:@"";
        
        [VoidTable reloadData];
        [self adjusttablesize];
    }
}

- (void)updaterefund:(UITextField *)sender {
    
    if (![self checkvalidfeeinput:sender.text]) {
        sender.text=@"";
    }else if ([sender.text floatValue]<0){
        
        UIAlertController *negativerefund = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Refund Enrollment"] message:[MyClass returntitlewithtitle:@"Refund amount should be in positive value"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //[self deleteEnrollment];
        }];
        
        [negativerefund addAction:OKAction];
        
        //[self presentViewController:negativerefund animated:YES completion:nil];
        [MyClass presentViewController:negativerefund View:self];
        
        sender.text=@"0";
    }else if ([sender.text floatValue]>[workingSales.paid floatValue]){
        
        UIAlertController *overrefund = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Refund Enrollment"] message:[MyClass returntitlewithtitle:@"Refund amount cannot be greater than total paid amount"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //[self deleteEnrollment];
        }];
        
        [overrefund addAction:OKAction];
        
        //[self presentViewController:overrefund animated:YES completion:nil];
        [MyClass presentViewController:overrefund View:self];
        
        sender.text=TotalPaidLabel.text;
    }
    
    tmprefundamount=sender.text;
    tmpvoidforfeitedamount=[NSString stringWithFormat:@"%g",[workingSales.paid floatValue]-[sender.text floatValue]];
    VoidForfeitLabel.text=[NSString stringWithFormat:@"%g", [tmpvoidforfeitedamount floatValue]];
}

-(void) voidConfirmButtonPressed
{
    [self.view endEditing:YES];
    
    if ([[MyClass leadingtrailingspacestrimmed:workingSales.remarks] isEqualToString:@""] && [MyClass isInputFieldRequired:@"voidremarks"]) {
        UIAlertController *voidenrollmentalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Void Enrollment"] message:[MyClass returntitlewithtitle:@"Please input remarks for void reason"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [voidenrollmentalert dismissViewControllerAnimated:YES completion:nil];
        }];
        [voidenrollmentalert addAction:OKAction];
        
        [MyClass presentViewController:voidenrollmentalert View:self];
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIAlertController *voidenrollmentalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Void Product Sale"] message:[MyClass returntitlewithtitle:@"Are you sure to void the product sale? (Forfeited amount will be re-allocated to product revenue)"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self voidproductsale];
                });
                
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [voidenrollmentalert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [voidenrollmentalert addAction:OKAction];
            [voidenrollmentalert addAction:CancelAction];
            
            //[self presentViewController:voidenrollmentalert animated:YES completion:nil];
            [MyClass presentViewController:voidenrollmentalert View:self];
        });
    }
    
    
}

-(void) voidproductsale
{
    [self.view endEditing:YES];
    
    
    __block BOOL result=FALSE;
    NSString *remarks=workingSales.remarks;
    if (neworderwillbecreated) {
        remarks=[NSString stringWithFormat:@"%@; New order will be created",remarks];
    }
    
//    NSDictionary *dictionary = @{@"postaction" : @"voidproductsale",
//                                 @"centerdb" : globalvariables.centerrecord.centerdb,
//                                 @"centerkey" : globalvariables.centerrecord.centerkey,
//                                 @"saleskey" : SalesObject.saleskey,
//                                 @"reverseadjustment"  : workingSales.total,
//                                 @"refund" : [RefundAmountText.text isEqualToString:@""]?@"0":tmprefundamount,
//                                 @"staffname" : [MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"],
//                                 @"forfeit" : tmpvoidforfeitedamount,
//                                 @"studentkey" : SalesObject.studentkey,
//                                 @"refundmethod" : tmprefundmethod,
//                                 @"updatedby" : globalvariables.username,
//                                 @"receiptremarks" : tmpreceiptremarks,
//                                 @"remarks":remarks,
//                                 @"arckey" : [MyClass returndefaultarckey]};
    
    
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *jsonpaymentarray=[[NSArray alloc]init];
    PaymentRecord *DetailsPaymentObject;
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    [dictionary setValue:@"voidproductsale" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:SalesObject.saleskey forKey:@"saleskey"];
    [dictionary setValue:workingSales.total forKey:@"reverseadjustment"];
    [dictionary setValue:[RefundAmountText.text isEqualToString:@""]?@"0":tmprefundamount forKey:@"refund"];
    [dictionary setValue:[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"] forKey:@"staffname"];
    [dictionary setValue:tmpvoidforfeitedamount forKey:@"forfeit"];
    [dictionary setValue:SalesObject.studentkey forKey:@"studentkey"];
    [dictionary setValue:tmprefundmethod forKey:@"refundmethod"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:tmpreceiptremarks forKey:@"receiptremarks"];
    [dictionary setValue:remarks forKey:@"remarks"];
    [dictionary setValue:[MyClass returndefaultarckey] forKey:@"arckey"];
    
    if(workingSales.paymentrecords.count>0){
        arrayOfDicts = [[NSMutableArray alloc] init];
        keys=[NSArray arrayWithObjects:@"paymentkey",@"paymenttypekey",@"paiddate",@"paidamount",@"paidmethod",@"paymenttype",@"paymentremarks",@"receiptremarks", @"staffname", @"action",@"arckey",nil];
        
        for (long i = workingSales.paymentrecords.count-1; i>=0; i--) {
            //for (int i = 0; i<detailspaymentarray.count; i++) {
            
            DetailsPaymentObject=[workingSales.paymentrecords objectAtIndex:i];
            if ([DetailsPaymentObject.action isEqualToString:@"add"] || [DetailsPaymentObject.action isEqualToString:@"edit"]) {
                values=[NSArray arrayWithObjects:DetailsPaymentObject.paymentkey,DetailsPaymentObject.paymenttypekey,[MyClass convertDateFormatWithDate:DetailsPaymentObject.paiddate FromDateFormat:@"dd-MMM-yyyy" ToDateFormat:@"yyyy-MM-dd" Translate:NO],DetailsPaymentObject.paidamount,DetailsPaymentObject.paidmethod,DetailsPaymentObject.paymenttype,DetailsPaymentObject.paymentremarks,DetailsPaymentObject.receiptremarks,DetailsPaymentObject.staffname, DetailsPaymentObject.action,[MyClass returndefaultarckey], nil];
                
                dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
                [arrayOfDicts addObject:dict];
            }
        }
        jsonpaymentarray = [NSArray arrayWithArray:arrayOfDicts];
        
    }
    
    [dictionary setValue:jsonpaymentarray forKey:@"paymentarray"];
    
    
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];

    
    if (result) {
 
        [self.delegate dismissSalesPopover];
    }

}

-(void) deletepaymentbuttonpressed:(UIButton *)sender
{
    [workingSales.paymentrecords removeObjectAtIndex:sender.tag];
    
    
    [DetailsPaymentTable reloadData];
    [self createPaymentToolBarwithMode:@"View"];

    //update enrollment data
    
    int tmptotalpaid=0;
    for (int p=0; p<workingSales.paymentrecords.count; p++) {
        PaymentRecord *DetailsPaymentObject=[workingSales.paymentrecords objectAtIndex:p];
        //if (![DetailsPaymentObject.action isEqualToString:@"delete"]) {
        tmptotalpaid+=[DetailsPaymentObject.paidamount intValue];
        //}
        
    }
    TotalPaidLabel.text=[NSString stringWithFormat:@"%d",tmptotalpaid];
    workingSales.paid=TotalPaidLabel.text;
    [self calculateTotalFee];
}

-(void) reversepaymentbuttonpressed:(UIButton *)sender
{
    PaymentRecord *obj=[workingSales.paymentrecords objectAtIndex:sender.tag];
    
    tmpPaidDate=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"];
    tmppaidmethod=obj.paidmethod;
    tmppaidamount=[NSString stringWithFormat:@"%g",-[obj.paidamount doubleValue]];
    tmppaymentremarks=@"Reverse payment";
    tmpreceiptremarks=@"";
    
    [workingSales.paymentrecords insertObject:[[PaymentRecord alloc]initPaymentRecordwithPaymentkey:@"" paymenttype:@"Sales" paymenttypekey:SalesObject.saleskey?SalesObject.saleskey:@"" paiddate:tmpPaidDate paidmethod:tmppaidmethod paidamount:tmppaidamount action:@"add" paymentremarks:tmppaymentremarks receiptremarks:tmpreceiptremarks staffname:[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"] receiptnumber:nil receiptprefix:nil] atIndex:0];
    
    //update enrollment popover data
    double totalpaid=0;
    
    for (int p=0; p<workingSales.paymentrecords.count; p++) {
        PaymentRecord *DetailsPaymentObject=[workingSales.paymentrecords objectAtIndex:p];
        totalpaid+=[DetailsPaymentObject.paidamount doubleValue];
    }
    
    TotalPaidLabel.text=[NSString stringWithFormat:@"%g",totalpaid];
    workingSales.paid=TotalPaidLabel.text;
    [self calculateTotalFee];
    
    DetailsPaymentTableMode=@"View";
    showPaymentDatePicker=NO;
    [DetailsPaymentTable reloadData];
    
    [self createPaymentToolBarwithMode:@"View"];
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    
    NSString *selecteddatestring=[selecteddatearray firstObject];
    
    if ([selectedItem isEqualToString:@"DetailsPayment"]){
        tmpPaidDate=selecteddatestring;
        [DetailsPaymentTable reloadData];//[DetailsPaymentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self adjusttablesize];
        
    }else if ([selectedItem isEqualToString:@"OrderDate"]){
        if (![workingSales.orderdate isEqualToString:selecteddatestring]) {
            //
            workingSales.orderdate=selecteddatestring;
            [SalesPopoverTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self validateDiscountUponOrderDateChange];
            [self adjusttablesize];
        }
    }
}

-(void) validateDiscountUponOrderDateChange
{
    BOOL updatetuition=FALSE;
    for (int i=0; i<workingSales.promotiondiscountrecords.count; i++) {
        marketingobject=[workingSales.promotiondiscountrecords objectAtIndex:i];
        if ([[MyClass convertToNSDateWithDate:workingSales.orderdate DateFormat:@"dd-MMM-yyyy"] compare:[MyClass convertToNSDateWithDate:[NSString stringWithFormat:@"%@ 23:59:59",marketingobject.enddate] DateFormat:@"dd-MMM-yyyy HH:mm:ss"]]==NSOrderedDescending){
            [workingSales.promotiondiscountrecords removeObjectAtIndex:i];
            i-=1;
            updatetuition=TRUE;
        }
    }
    
    if (updatetuition) {
        [self calculateTotalFee];
        //[self calculateTotalFeeWithEnrollmentFee:workingEnrollment.enrollmentfee TuitionFee:workingEnrollment.tuitionfee LateFee:workingEnrollment.latefee];
        [DiscountTable reloadData];
    }
}

-(void) autosendereceipt
{
    //SalesObject=workingSales;
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        paymentindexpath=[NSIndexPath indexPathForRow:0 inSection:0];
        
        
    SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
        
        NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:nil SalesReceiptArray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
        
        if (pdfdata) {
            [self messagePDF:pdfdata studentkeys:[[NSMutableArray alloc]initWithObjects:SalesObject.studentkey, nil] pdfType:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:nil salesreceiptarray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil]] acknowledge:NO];
        }
    //});
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"sharedocument"]) {
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"Print"]) {
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                
                
                SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
                
                NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:nil SalesReceiptArray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                
                if (pdfdata) {
                    [self printPDF:pdfdata];
                }

                

            }else{
                SalesInvoiceRecord *salesinvoicerecord=[[SalesInvoiceRecord alloc]initSalesInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity outstandingamount:[NSString stringWithFormat:@"%g",[SalesObject.total floatValue]-[SalesObject.paid floatValue]] invoiceremarks:SalesObject.invoiceremarks image:nil checkstatus:nil salesrecord:SalesObject productname:nil];
                
                NSData *pdfdata = [MyClass generateInvoiceWithClassInvoiceArray:nil SalesInvoiceArray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] papersizeoverride:NO combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                if (pdfdata) {
                    [self printPDF:pdfdata];
                }
            }
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }else if ([result isEqualToString:@"Send eInvoice"] || [result isEqualToString:@"Send eReceipt"]){
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([invoiceorreceipt isEqualToString:@"receipt"]) {

                    NSMutableArray *documentArray=[[NSMutableArray alloc]init];
                    NSMutableDictionary *dict;
                    dict=[[NSMutableDictionary alloc]init];
                    [dict setValue:@"Sales" forKey:@"paymenttype"];
                    [dict setValue:@"1" forKey:@"documentkey"];
                    [dict setValue:workingSales.saleskey forKey:@"paymenttypekey"];
                    [documentArray addObject:dict];
                    [MyClass submitDocumentSendingRequestWithType:@"Receipt" documentArray:documentArray];

                }else{
                    
                    NSMutableArray *documentArray=[[NSMutableArray alloc]init];
                    NSMutableDictionary *dict;
                    dict=[[NSMutableDictionary alloc]init];
                    [dict setValue:@"Sales" forKey:@"paymenttype"];
                    [dict setValue:@"1" forKey:@"documentkey"];
                    [dict setValue:workingSales.saleskey forKey:@"paymenttypekey"];
                    [documentArray addObject:dict];
                    [MyClass submitDocumentSendingRequestWithType:@"Invoice" documentArray:documentArray];

//                SalesInvoiceRecord *salesinvoicerecord=[[SalesInvoiceRecord alloc]initSalesInvoiceRecordWithstudentkey:PopoverStudent.studentkey firstname:PopoverStudent.firstname lastname:PopoverStudent.lastname gender:PopoverStudent.gender studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity outstandingamount:[NSString stringWithFormat:@"%g",[SalesObject.total floatValue]-[SalesObject.paid floatValue]] invoiceremarks:SalesObject.invoiceremarks image:nil checkstatus:nil salesrecord:SalesObject];
//
//                NSData *pdfdata = [MyClass generateInvoiceWithClassInvoiceArray:nil SalesInvoiceArray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
//                if (pdfdata) {
//                    [self messagePDF:pdfdata studentkeys:[[NSMutableArray alloc]initWithObjects:SalesObject.studentkey, nil] pdfType:@"Invoice" filename:[MyClass returninvoicenumberwithclassinvoicearray:nil salesinvoicearray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord,nil] updateinvoicelog:NO] acknowledge:YES];
//                }
                }
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }else if ([result isEqualToString:@"Send Email"]){
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                
                SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
                
                NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:nil SalesReceiptArray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];

                if (pdfdata) {
                    [self emailPDF:pdfdata pdftype:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:nil salesreceiptarray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil]]receiptient:[self returnmailreceiptientwithclassarray:nil salesarray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] type:@"Receipt"]];
                }
            }else{
                SalesInvoiceRecord *salesinvoicerecord=[[SalesInvoiceRecord alloc]initSalesInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity outstandingamount:[NSString stringWithFormat:@"%g",[SalesObject.total floatValue]-[SalesObject.paid floatValue]] invoiceremarks:SalesObject.invoiceremarks image:nil checkstatus:nil salesrecord:SalesObject productname:nil];
                
                NSData *pdfdata = [MyClass generateInvoiceWithClassInvoiceArray:nil SalesInvoiceArray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                if (pdfdata) {
                    [self emailPDF:pdfdata pdftype:@"Invoice" filename:[MyClass returninvoicenumberwithclassinvoicearray:nil salesinvoicearray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] updateinvoicelog:NO] receiptient:[self returnmailreceiptientwithclassarray:nil salesarray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] type:@"Invoice"]];
                }
            }
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }else if ([result isEqualToString:@"Add to Folder"]){
            if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                if (![globalvariables.documentfolder.salesreceiptarray containsObject:workingSales.saleskey]) {
                    [globalvariables.documentfolder.salesreceiptarray addObject:workingSales.saleskey];
                    if (![globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:workingSales.saleskey]) {
                        [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys addObject:workingSales.saleskey];
                    }
                    [self.delegate refreshdocumentfoldercount];
                }else{
                    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"This receipt has already been added to the folder"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [erroralert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [erroralert addAction:OKAction];
                    [self presentViewController:erroralert animated:YES completion:nil];
                }
            }else{
                if (![globalvariables.documentfolder.salesinvoicearray containsObject:SalesObject.saleskey]) {
                    [globalvariables.documentfolder.salesinvoicearray addObject:SalesObject.saleskey];
                    [self.delegate refreshdocumentfoldercount];
                }else{
                    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"This invoice has already been added to the folder"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        [erroralert dismissViewControllerAnimated:YES completion:nil];
                    }];
                    
                    [erroralert addAction:OKAction];
                    [self presentViewController:erroralert animated:YES completion:nil];
                }
            }
        }else if ([result isEqualToString:@"More"]){
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                    [self sharepaymentreceiptwithtableview:sharetable indexpath:nil];
                }else{
                    [self sharepaymentinvoicewithtableview:sharetable indexpath:nil];
                }
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }
    }
}

-(void) switchautorenew:(UISwitch *)sender
{
    workingSales.autorenew=sender.on ? @"Yes":@"No";
    [DiscountTable reloadData];
}

-(void) switchneworderwillbecreated:(UISwitch *)sender
{
    neworderwillbecreated=sender.on;
}

-(void) dismissstudentgridviewwithreload:(BOOL)reload
{
    [studentimagepopover dismissViewControllerAnimated:YES completion:nil];
    if (reload) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.delegate dismissSalesPopover];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }
}


@end
