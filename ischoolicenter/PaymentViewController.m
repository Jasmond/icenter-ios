//
//  PaymentViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 5/10/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "PaymentViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MainMenuViewController.h"
#import "MyClass.h"
#import "DocumentFolderPopoverViewController.h"
#import "MainViewController.h"
#import "StudentDetailsNavController.h"
#import "MyTableViewCell.h"
#import "SceneDelegate.h"

@interface PaymentViewController ()
@property (nonatomic, assign) BOOL sideWindowAdjusting;
@end

@implementation PaymentViewController
@synthesize JSONArray,OutstandingPaymentObject,OutstandingBankinObject,OutstandingBankinArray, OutstandingClassPaymentTable,OutstandingSalesPaymentTable, OutstandingBankinTable,myPopoverController,DetailsViewEnrollment;
@synthesize scclassday,PaymentView,BankinView,DetailsPaymentTable,myDatePickerPopoverController;
@synthesize DetailsPaymentArray,DetailsPaymentObject,tablemode;
@synthesize selectedValue,myPickerView;
@synthesize paymentMasterView,paymentToolbar;
@synthesize BankinInputTable,bankinInputMasterView,bankinInputToolbar;



#define maxpaymentpopupheight self.view.frame.size.height
#define maxpopupheight self.view.frame.size.height
#define documentfoldertablewidth 470
#define documentfoldertablemaxheight 650
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]

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
}*/



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
    // Do any additional setup after loading the view.
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    

    
    

    
    
    
    
    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
//    headertitleview=[[UIView alloc]initWithFrame:CGRectMake(70, 0, self.view.bounds.size.width-140, 68)];
//    headertitlename=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, headertitleview.frame.size.width, 20)];
//    headertitlename.font=[UIFont boldSystemFontOfSize:17];
//    headertitlename.textColor=[UIColor whiteColor];
//    headertitlename.textAlignment=NSTextAlignmentCenter;
//    [headertitleview addSubview:headertitlename];
//    [self.view addSubview:headertitleview];
    
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
    
    
    classdayarray=[[NSArray alloc]initWithObjects:@"All",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun",@"TBD", nil];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self createmenubar];
    [self createview];
    

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    
    formatter = [[NSNumberFormatter alloc]init];
    [formatter setMaximumFractionDigits:1]; // Set this if you need 2 digits
    [formatter setMinimumFractionDigits:0];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatter setCurrencySymbol:@"$"];

    
    

    
    documentfolderbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [documentfolderbutton setImage:[UIImage imageNamed:@"documentfolder_icon.png"] forState:UIControlStateNormal];
    documentfolderbutton.showsTouchWhenHighlighted = YES;
    documentfolderbutton.frame = CGRectMake(60, 28, 30,30);
    [documentfolderbutton setImageEdgeInsets:UIEdgeInsetsMake(6,1,1,6)];
    documentfolderbutton.layer.cornerRadius=5;
    documentfolderbutton.layer.masksToBounds=YES;
    [documentfolderbutton.heightAnchor constraintEqualToConstant:30].active = true;
    [documentfolderbutton.widthAnchor constraintEqualToConstant:30].active = true;
    [documentfolderbutton addTarget:self action:@selector(documentfolderbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:documentfolderbutton];
    
    documentfoldercountlabel = [[UILabel alloc] initWithFrame: CGRectMake(18,7,10,10)];
    documentfoldercountlabel.backgroundColor = [UIColor redColor];
    documentfoldercountlabel.layer.cornerRadius=5;
    documentfoldercountlabel.layer.masksToBounds=YES;
    [documentfolderbutton addSubview:documentfoldercountlabel];
    

    
    [self refreshdocumentfoldercount];

    [self refreshlanguage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checktoreloadapp) name:UIApplicationWillEnterForegroundNotification object:nil];
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
    sidewindowview.autoresizingMask=UIViewAutoresizingNone;
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
    
    selectedinvoicelogkey=@"";
    selectedpaiddate=@"";
    
}

-(void) createmenubar
{
    menubottombar.frame=CGRectMake(0,68, self.view.bounds.size.width/4, 40);
    menubottombar.backgroundColor=[UIColor darkGrayColor];
    
    OutstandingViewButton.backgroundColor=[UIColor clearColor];
    [OutstandingViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    BankinViewButton.backgroundColor=[UIColor clearColor];
    [BankinViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    InvoiceViewButton.backgroundColor=[UIColor clearColor];
    [InvoiceViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    PaymentViewButton.backgroundColor=[UIColor clearColor];
    [PaymentViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    BankinViewButton.enabled=NO;
    PaymentViewButton.enabled=YES;
    OutstandingViewButton.enabled=YES;
    InvoiceViewButton.enabled=YES;
}

- (UIButton *)selectedPaymentMenuButton
{
    for (UIButton *button in @[BankinViewButton, PaymentViewButton, OutstandingViewButton, InvoiceViewButton]) {
        if (button && !button.enabled) {
            return button;
        }
    }
    return BankinViewButton;
}

- (void)layoutPaymentMenuHighlight
{
    UIButton *button = [self selectedPaymentMenuButton];
    if (!button || !menubottombar || !menubottombar.superview) {
        return;
    }
    CGRect frame = [button convertRect:button.bounds toView:menubottombar.superview];
    if (CGRectIsEmpty(frame)) {
        return;
    }
    menubottombar.frame = frame;
}

- (CGFloat)visiblePaymentWidth
{
    CGFloat width = self.view.bounds.size.width;
    UIWindow *window = self.view.window;
    if (!window || width < 1) {
        return width;
    }
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGFloat leftShift = MAX(CGRectGetMinX(frameInWindow) - CGRectGetMinX(window.bounds), 0);
    CGFloat rightOverflow = MAX(CGRectGetMaxX(frameInWindow) - CGRectGetMaxX(window.bounds), 0);
    CGFloat menuSlide = MIN(leftShift, rightOverflow);
    return MAX(width - (rightOverflow - menuSlide), 0);
}

- (void)layoutPaymentForCurrentSize
{
    CGFloat width = [self visiblePaymentWidth];
    if (width < 1) {
        return;
    }
    CGFloat overflow = MAX(self.view.bounds.size.width - width, 0);
    BOOL changed = NO;
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if (constraint.firstItem == self.view && constraint.firstAttribute == NSLayoutAttributeTrailing && constraint.secondAttribute == NSLayoutAttributeTrailing) {
            if (fabs(constraint.constant - overflow) > 0.5) {
                constraint.constant = overflow;
                changed = YES;
            }
        }
    }
    CGFloat titleWidth = MAX(width - 140.0, 0);
    headertitleview.frame = CGRectMake(70, 0, titleWidth, 68);
    headertitlename.frame = CGRectMake(0, 25, titleWidth, 20);
    switchcenterbutton.frame = CGRectMake(0, 0, titleWidth, 68);
    if (reloadbutton) {
        reloadbutton.frame = CGRectMake(width - 45, 34, 28, 28);
    }
    [self updateheadercentertitle];
    if (changed) {
        return;
    }
    [self layoutPaymentMenuHighlight];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutPaymentForCurrentSize];
    [self pinPaymentSideWindow];
}

- (void)pinPaymentSideWindow
{
    UIWindow *window = self.view.window ? self.view.window : mainWindow;
    if (self.sideWindowAdjusting || !window || !sidewindowview || sidewindowview.hidden || sidewindowview.frame.size.width < 1.0) {
        return;
    }
    mainWindow = window;
    if (sidewindowview.superview != window) {
        [window addSubview:sidewindowview];
    }
    CGFloat panelWidth = MIN(sidewindowview.frame.size.width, window.bounds.size.width);
    sidewindowview.frame = CGRectMake(window.bounds.size.width - panelWidth, 0, panelWidth, window.bounds.size.height);
    if (sidewindowviewclosebutton) {
        if (sidewindowviewclosebutton.superview != window) {
            [window addSubview:sidewindowviewclosebutton];
        }
        sidewindowviewclosebutton.frame = window.bounds;
    }
    for (UIView *child in sidewindowview.subviews) {
        if ([child isKindOfClass:[UIActivityIndicatorView class]]) {
            continue;
        }
        child.frame = sidewindowview.bounds;
    }
}

-(void) createview{

    
    //set table fields dimension
    NSArray *separatorweight_class=[[NSArray alloc]initWithObjects:@"3",@"3",@"1.5",@"1",@"1",@"1.2",@"0.8",@"0.8",@"1.2", nil];
    float fieldseparator=(self.view.frame.size.width-30)/[[separatorweight_class valueForKeyPath:@"@sum.self"] floatValue];
    title_Class_Student.frame=CGRectMake(8, 1, [[separatorweight_class objectAtIndex:0] intValue]*fieldseparator, 21);
    title_Subject.frame=CGRectMake(title_Class_Student.frame.origin.x+title_Class_Student.frame.size.width, 1, [[separatorweight_class objectAtIndex:1] floatValue]*fieldseparator, 21);
    title_Enrollment.frame=CGRectMake(title_Subject.frame.origin.x+title_Subject.frame.size.width, 1, [[separatorweight_class objectAtIndex:2] floatValue]*fieldseparator, 21);
    title_Day.frame=CGRectMake(title_Enrollment.frame.origin.x+title_Enrollment.frame.size.width, 1, [[separatorweight_class objectAtIndex:3] floatValue]*fieldseparator, 21);
    title_Time.frame=CGRectMake(title_Enrollment.frame.origin.x+title_Enrollment.frame.size.width, 19, [[separatorweight_class objectAtIndex:3] floatValue]*fieldseparator, 21);
    title_Start.frame=CGRectMake(title_Time.frame.origin.x+title_Time.frame.size.width, 1, [[separatorweight_class objectAtIndex:4] floatValue]*fieldseparator, 21);
    title_End.frame=CGRectMake(title_Time.frame.origin.x+title_Time.frame.size.width, 19, [[separatorweight_class objectAtIndex:4] floatValue]*fieldseparator, 21);
    title_No_of_Class.frame=CGRectMake(title_End.frame.origin.x+title_End.frame.size.width, 1, [[separatorweight_class objectAtIndex:5] floatValue]*fieldseparator, 21);
    title_Total_Fee.frame=CGRectMake(title_No_of_Class.frame.origin.x+title_No_of_Class.frame.size.width, 1, [[separatorweight_class objectAtIndex:6] floatValue]*fieldseparator, 21);
    title_Paid.frame=CGRectMake(title_Total_Fee.frame.origin.x+title_Total_Fee.frame.size.width, 1, [[separatorweight_class objectAtIndex:7] floatValue]*fieldseparator, 21);
    title_Outstanding.frame=CGRectMake(title_Paid.frame.origin.x+title_Paid.frame.size.width, 1, [[separatorweight_class objectAtIndex:8] floatValue]*fieldseparator, 21);
    
    
    NSArray *separatorweight_sales=[[NSArray alloc]initWithObjects:@"3",@"3",@"2",@"1",@"1",@"1",@"1", nil];
    fieldseparator=(self.view.frame.size.width-30)/[[separatorweight_sales valueForKeyPath:@"@sum.self"] floatValue];
    title_Sales_Student.frame=CGRectMake(8, 1, [[separatorweight_sales objectAtIndex:0] intValue]*fieldseparator, 21);
    title_Product.frame=CGRectMake(title_Sales_Student.frame.origin.x+title_Sales_Student.frame.size.width, 1, [[separatorweight_sales objectAtIndex:1] intValue]*fieldseparator, 21);
    title_Order_Date.frame=CGRectMake(title_Product.frame.origin.x+title_Product.frame.size.width, 1, [[separatorweight_sales objectAtIndex:2] intValue]*fieldseparator, 21);
    title_Quantity.frame=CGRectMake(title_Order_Date.frame.origin.x+title_Order_Date.frame.size.width, 1, [[separatorweight_sales objectAtIndex:3] intValue]*fieldseparator, 21);
    title_product_Total_Fee.frame=CGRectMake(title_Quantity.frame.origin.x+title_Quantity.frame.size.width, 1, [[separatorweight_sales objectAtIndex:4] intValue]*fieldseparator, 21);
    title_product_Paid.frame=CGRectMake(title_product_Total_Fee.frame.origin.x+title_product_Total_Fee.frame.size.width, 1, [[separatorweight_sales objectAtIndex:5] intValue]*fieldseparator, 21);
    title_product_Outstanding.frame=CGRectMake(title_product_Paid.frame.origin.x+title_product_Paid.frame.size.width, 1, [[separatorweight_sales objectAtIndex:6] intValue]*fieldseparator, 21);
    
    

    
    PaymentView.hidden=YES;
    BankinView.hidden=NO;
    InvoiceView.hidden=YES;
    PaymentReceivedView.hidden=YES;
    
    tablemode=@"View";
    
    DetailsPaymentTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    BankinInputTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    DetailsPaymentTable.allowsMultipleSelectionDuringEditing=YES;
    

    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshoutstandingclasspaymenttable) forControlEvents:UIControlEventValueChanged];
    [OutstandingClassPaymentTable addSubview:tablerefresh];
    if ([OutstandingClassPaymentTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        OutstandingClassPaymentTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    UILongPressGestureRecognizer *clpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(classTableLongPress:)];
    clpgr.delegate = self;
    [OutstandingClassPaymentTable addGestureRecognizer:clpgr];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshoutstandingsalespaymenttable) forControlEvents:UIControlEventValueChanged];
    [OutstandingSalesPaymentTable addSubview:tablerefresh];
    if ([OutstandingSalesPaymentTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        OutstandingSalesPaymentTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    
    UILongPressGestureRecognizer *slpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(salesTableLongPress:)];
    slpgr.delegate = self;
    [OutstandingSalesPaymentTable addGestureRecognizer:slpgr];
    

    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshoutstandingbankintable) forControlEvents:UIControlEventValueChanged];
    [OutstandingBankinTable addSubview:tablerefresh];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshinvoicelogtable) forControlEvents:UIControlEventValueChanged];
    [InvoiceLogRecordTable addSubview:tablerefresh];
    if ([InvoiceLogRecordTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        InvoiceLogRecordTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    UILongPressGestureRecognizer *ilpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(invoiceTableLongPress:)];
    ilpgr.delegate = self;
    [InvoiceLogItemTable addGestureRecognizer:ilpgr];
    
    
    paymentclassview.hidden=NO;
    paymentsalesview.hidden=YES;
    
    
    
    bankinchecked=FALSE;
    
    sharetable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 175, 152) style:UITableViewStylePlain];
    sharetable.delegate=self;
    sharetable.dataSource=self;
    sharetable.scrollEnabled=NO;
    
    
    reloadbutton=[[UIButton alloc]initWithFrame:CGRectMake(self.view.bounds.size.width-45, 34, 28,28)];
    [reloadbutton setImage:[UIImage imageNamed:@"reload_white.png"] forState:UIControlStateNormal];
    [reloadbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reloadbutton addTarget: self action:@selector(viewDidAppear:) forControlEvents: UIControlEventTouchUpInside];
    reloadbutton.hidden=YES;
    [self.view addSubview:reloadbutton];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshpaymentreceivedtable) forControlEvents:UIControlEventValueChanged];
    [PaymentReceivedTable addSubview:tablerefresh];
    
    
    

    
    
    
}

-(void) checktoreloadapp
{
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {
        if ([myPopoverController presentingViewController].isBeingPresented) {
            [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==switchcenterviewcontroller) {
            [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==documentfolderpopover) {
            [documentfolderpopover dismissViewControllerAnimated:NO completion:nil];
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
                }else if (self.presentedViewController==documentfolderpopover) {
                    [documentfolderpopover dismissViewControllerAnimated:NO completion:nil];
                }else if (self.presentedViewController==switchcenterviewcontroller) {
                    [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
                }else{
                    [self.mainSlideMenu closeLeftMenu];
                }
        [self closesidewindow];
        [MyClass removeallsidewindowsexceptsidewindow:sidewindowview sidewindowbutton:sidewindowviewclosebutton];
                [self reloadPageWithFirstLoad:NO];
            //}
        //}];
    }
}



-(void) refreshlanguage
{
    [self loadtitle];
    headercentername.text=[MyClass returnWindowTitle];
    headertitlename.text=[MyClass returntitlewithtitle:@"Financial Information"];
    [self updateheadercentertitle];
    [InvoiceViewButton setTitle:[MyClass returntitlewithtitle:@"Invoice Log"] forState:UIControlStateNormal];
    [PaymentViewButton setTitle:[MyClass returntitlewithtitle:@"Payment Received"] forState:UIControlStateNormal];
    noInvoiceRecordLabel.text=[MyClass returntitlewithtitle:@"No Record"];
    noPaymentReceivedRecordLabel.text=[MyClass returntitlewithtitle:@"No Record"];
    paymentreceivedSearchField.placeholder=[MyClass returntitlewithtitle:@"Search"];
    invoiceSearchField.placeholder=[MyClass returntitlewithtitle:@"Search"];
    outstandingclasssearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    outstandingsalessearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    
    tite_payment_last_30_days.text=[MyClass returntitlewithtitle:@"Last 30 days"];
    tite_payment_Student.text=[MyClass returntitlewithtitle:@"Student"];
    tite_payment_Type.text=[MyClass returntitlewithtitle:@"Type"];
    tite_payment_Item_Description.text=[MyClass returntitlewithtitle:@"Item Description"];
    tite_payment_Paid_Method.text=[MyClass returntitlewithtitle:@"Paid Method"];
    tite_payment_Paid.text=[MyClass returntitlewithtitle:@"Amount"];
    tite_payment_Staff.text=[MyClass returntitlewithtitle:@"Staff"];
    tite_payment_Payment_Remarks.text=[MyClass returntitlewithtitle:@"Payment Remarks"];
    tite_payment_Receipt_Remarks.text=[MyClass returntitlewithtitle:@"Receipt Remarks"];
    
    [selectalloutstandingbutton setTitle:[MyClass returntitlewithtitle:@"Select all"] forState:UIControlStateNormal];
    [deselectoutstandingbutton setTitle:[MyClass returntitlewithtitle:@"Deselect all"] forState:UIControlStateNormal];
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


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.mainSlideMenu disableSlidePanGestureForRightMenu];
    globalvariables.lastviewcontroller=(NSString *)self;
    
            if (sidewindowview.frame.origin.x==mainWindow.bounds.size.width) {
                [self reloadPageWithFirstLoad:YES];
            }
}

-(void) refreshoutstandingclasspaymenttable
{
    [self retrieveOutstandingClassPaymentRecordWithClassday:@"All" enrollmentkeystring:@""];
    for (id object in [OutstandingClassPaymentTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshData
{
    if(!PaymentReceivedView.hidden){
        [self retrievePaymentReceived];
        [PaymentReceivedDetailsTable reloadData];
    }else if (!PaymentView.hidden){
        if(scpaymenttype.selectedSegmentIndex==0){
            [self retrieveOutstandingClassPaymentRecordWithClassday:[classdayarray objectAtIndex:[scclassday selectedSegmentIndex]] enrollmentkeystring:@""];
        }else{
            [self retrieveOutstandingPaymentSales];
        }
        [self updateOutstandingValue];
    }else if (!InvoiceView.hidden){
        [self retrieveInvoiceLog];
    }
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}

-(void) loadscreen
{
    lastdayofweekindex=0;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        subjectArray=[MyClass retrievesubjectinformationwithstatus:@"All" category:@"All" flushcachedata:NO];
        if (!subjectArray){
            reloadbutton.hidden=NO;
            return;
        }else{
            reloadbutton.hidden=YES;
        }
        
        if(!BankinView.hidden){
            if (![self retrieveOutstandingBankinRecord]){
                reloadbutton.hidden=NO;
                return;
            }else{
                reloadbutton.hidden=YES;
            }
        }else if (!PaymentReceivedView.hidden){
            if(!PaymentReceivedView.hidden){
                [self retrievePaymentReceived];
            }
        }else if(!InvoiceView.hidden){
            if(!InvoiceView.hidden){
                [self retrieveInvoiceLog];
            }
        }else if(!paymentclassview.hidden){
            if (![self retrieveOutstandingClassPaymentRecordWithClassday:@"All" enrollmentkeystring:@""] ){
                reloadbutton.hidden=NO;
                return;
            }else{
                reloadbutton.hidden=YES;
            }
        }else if(!paymentsalesview.hidden){
            if (![self retrieveOutstandingPaymentSales]){
                reloadbutton.hidden=NO;
                return;
            }else{
                reloadbutton.hidden=YES;
            }
        }
        

        
        
        
        
//        if (![self retrieveOutstandingClassPaymentRecordWithClassday:@"All" enrollmentkeystring:@""] ){
//            reloadbutton.hidden=NO;
//            return;
//        }else{
//            reloadbutton.hidden=YES;
//        }
//        
//        if (![self retrieveOutstandingPaymentSales]){
//            reloadbutton.hidden=NO;
//            return;
//        }else{
//            reloadbutton.hidden=YES;
//        }
//        
//        
//        if (![self retrieveOutstandingBankinRecord]){
//            reloadbutton.hidden=NO;
//            return;
//        }else{
//            reloadbutton.hidden=YES;
//        }
//        
//        if(!InvoiceView.hidden){
//            [self retrieveInvoiceLog];
//        }
//        
//        if(!PaymentReceivedView.hidden){
//            [self retrievePaymentReceived];
//        }
        
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

-(void) refreshinvoicelogtable
{
    [self retrieveInvoiceLog];
    for (id object in [InvoiceLogRecordTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshpaymentreceivedtable
{
    [self retrievePaymentReceived];
    for (id object in [PaymentReceivedTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshoutstandingsalespaymenttable
{
    [self retrieveOutstandingPaymentSales];
    for (id object in [OutstandingSalesPaymentTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshoutstandingbankintable
{
    [self retrieveOutstandingBankinRecord];
    for (id object in [OutstandingBankinTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

/*
- (void) loadcalendar
{
    [MyClass getLatestDataSetv2withParameters:@"calendar" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    [MyClass LoadSchoolCalendarArray];
    //[MyClass LoadSchoolCalendarWithCheckingLastUpdate:YES];
    //fill in date picker menu
    datePickerViewMenu=[[NSMutableArray alloc] initWithArray:globalvariables.alldayarray];
    
}*/

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

-(BOOL) retrieveOutstandingClassPaymentRecordWithClassday:(NSString *)classday enrollmentkeystring:(NSString *)enrollmentkeystring
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectoutstandingpayment&classday=%@&enrollmentkeystring=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewpaymentinformation"],classday,enrollmentkeystring];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                JSONArray = jsonreturned[@"content"];
            //Set up our class array
            OutstandingClassPaymentArray=[[NSMutableArray alloc] init];
            
//            if ([classday isEqualToString:@"All"]) {
//                totaloutstandingclasspayment=0;
//            }
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our Instructor object
                NSString * slastpaymentkey=[[JSONArray objectAtIndex:i] objectForKey:@"lastpaymentkey"];
                
                NSString * sstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                NSString * senrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
                NSString * senrollmentdate=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentdate"];//[df stringFromDate:date];
                
                studentobject=[MyClass returnstudentwithstudentkey:sstudentkey];
                
                
                NSString * sstudentfullname=[MyClass returnStudentnameWithStudentkey:sstudentkey option:@"full"];//
                NSString * ssubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString * ssubjectfullname=[MyClass returnsubjectnamewithsubject_shortname:ssubject centerkey:globalvariables.centerrecord.centerkey];
                NSString * sclassday=[[JSONArray objectAtIndex:i] objectForKey:@"classday"];
                NSString * sclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                
                NSString * sstartdate=[[JSONArray objectAtIndex:i] objectForKey:@"startdate"];
                
                NSString *senddate=[[JSONArray objectAtIndex:i] objectForKey:@"enddate"];
                NSString * snoofclass=[[JSONArray objectAtIndex:i] objectForKey:@"noofclass"];
                NSString * stotalfee=[[JSONArray objectAtIndex:i] objectForKey:@"totalfee"];
                NSString * spaid=[NSString stringWithFormat:@"%g",[[[JSONArray objectAtIndex:i] objectForKey:@"paid"] floatValue]];
                NSString * soutstanding=[NSString stringWithFormat:@"%g",[stotalfee floatValue]-[spaid floatValue]];
                NSString * sparentcontact=[[JSONArray objectAtIndex:i] objectForKey:@"parentcontact"];
                NSString * sgender=[[JSONArray objectAtIndex:i] objectForKey:@"gender"];
                NSString * simage=[[JSONArray objectAtIndex:i] objectForKey:@"image"];
                NSString * sstudentid=[[JSONArray objectAtIndex:i] objectForKey:@"studentid"];
                
//                
//                if ([classday isEqualToString:@"All"]) {
//                    totaloutstandingclasspayment+=[soutstanding floatValue];
//                }
                
                //Add the instructor object to our instructor array
                [OutstandingClassPaymentArray addObject:[[OutstandingPaymentRecord alloc]initOutstandingPaymentRecordWithStudentkey:sstudentkey andenrollmentkey:senrollmentkey andstudentfullname:sstudentfullname andenrollmentdate:senrollmentdate andsubject:ssubject andclassday:sclassday andclasstime:sclasstime andstartdate:sstartdate andenddate:senddate andnoofclass:snoofclass andtotalfee:stotalfee andpaid:spaid andoutstanding:soutstanding andparentcontact:sparentcontact andgender:sgender andimage:simage andstudentid:sstudentid andsubjectfullname:ssubjectfullname lastpaymentkey:slastpaymentkey]];
            }

        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            result=TRUE;
        
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        //Set up our class array
        OutstandingClassPaymentArray=[[NSMutableArray alloc] init];
        
        if ([classday isEqualToString:@"All"]) {
            totaloutstandingclasspayment=0;
        }
        
        //loop through our jsonArray
        for (int i=0; i<JSONArray.count; i++) {
            
            //Create our Instructor object
            NSString * slastpaymentkey=[[JSONArray objectAtIndex:i] objectForKey:@"lastpaymentkey"];
            
            NSString * sstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
            NSString * senrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
            NSString * senrollmentdate=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentdate"];//[df stringFromDate:date];
            
            studentobject=[MyClass returnstudentwithstudentkey:sstudentkey];
            
            
            NSString * sstudentfullname=[MyClass returnStudentnameWithStudentkey:sstudentkey option:@"full"];//
            NSString * ssubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
            NSString * ssubjectfullname=[MyClass returnsubjectnamewithsubject_shortname:ssubject centerkey:globalvariables.centerrecord.centerkey];
            NSString * sclassday=[[JSONArray objectAtIndex:i] objectForKey:@"classday"];
            NSString * sclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
            
            NSString * sstartdate=[[JSONArray objectAtIndex:i] objectForKey:@"startdate"];
            
            NSString *senddate=[[JSONArray objectAtIndex:i] objectForKey:@"enddate"];
            NSString * snoofclass=[[JSONArray objectAtIndex:i] objectForKey:@"noofclass"];
            NSString * stotalfee=[[JSONArray objectAtIndex:i] objectForKey:@"totalfee"];
            NSString * spaid=[NSString stringWithFormat:@"%g",[[[JSONArray objectAtIndex:i] objectForKey:@"paid"] floatValue]];
            NSString * soutstanding=[NSString stringWithFormat:@"%g",[stotalfee floatValue]-[spaid floatValue]];
            NSString * sparentcontact=[[JSONArray objectAtIndex:i] objectForKey:@"parentcontact"];
            NSString * sgender=[[JSONArray objectAtIndex:i] objectForKey:@"gender"];
            NSString * simage=[[JSONArray objectAtIndex:i] objectForKey:@"image"];
            NSString * sstudentid=[[JSONArray objectAtIndex:i] objectForKey:@"studentid"];
            
            
            if ([classday isEqualToString:@"All"]) {
                totaloutstandingclasspayment+=[soutstanding floatValue];
            }
            
            //Add the instructor object to our instructor array
            [OutstandingClassPaymentArray addObject:[[OutstandingPaymentRecord alloc]initOutstandingPaymentRecordWithStudentkey:sstudentkey andenrollmentkey:senrollmentkey andstudentfullname:sstudentfullname andenrollmentdate:senrollmentdate andsubject:ssubject andclassday:sclassday andclasstime:sclasstime andstartdate:sstartdate andenddate:senddate andnoofclass:snoofclass andtotalfee:stotalfee andpaid:spaid andoutstanding:soutstanding andparentcontact:sparentcontact andgender:sgender andimage:simage andstudentid:sstudentid andsubjectfullname:ssubjectfullname lastpaymentkey:slastpaymentkey]];
        }

    }
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        //[self updateOutstandingValue];
        [self returnfilteroutstandingclassarray];
        [OutstandingClassPaymentTable reloadData];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    return result;
}

-(BOOL) retrieveOutstandingPaymentSales
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectoutstandingsalespayment",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewpaymentinformation"]];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            OutstandingSalesPaymentArray=[[NSMutableArray alloc] init];
            
//            totaloutstandingsalespayment=0;
            
            df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our Instructor object
                NSString * ssaleskey=[[JSONArray objectAtIndex:i] objectForKey:@"saleskey"];
                NSString * sstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];

                NSString * sorderdate=[[JSONArray objectAtIndex:i] objectForKey:@"orderdate"];
                NSString * sstudentfullname=[MyClass returnStudentnameWithStudentkey:sstudentkey option:@"full"];
                NSString * sproduct=[[JSONArray objectAtIndex:i] objectForKey:@"productcode"];
                NSString * sproductfullname=[MyClass returnproductnamewithproductcode:sproduct centerkey:globalvariables.centerrecord.centerkey];
                NSString * squantity=[[JSONArray objectAtIndex:i] objectForKey:@"quantity"];
                NSString * stotalfee=[[JSONArray objectAtIndex:i] objectForKey:@"total"];
                NSString * spaid=[NSString stringWithFormat:@"%g",[[[JSONArray objectAtIndex:i] objectForKey:@"paid"] floatValue]];
                NSString * soutstanding=[NSString stringWithFormat:@"%g",[stotalfee floatValue]-[spaid floatValue]];
                NSString * sparentcontact=[[JSONArray objectAtIndex:i] objectForKey:@"parentcontact"];
                NSString * sgender=[[JSONArray objectAtIndex:i] objectForKey:@"gender"];
                NSString * simage=[[JSONArray objectAtIndex:i] objectForKey:@"image"];
                NSString * sstudentid=[[JSONArray objectAtIndex:i] objectForKey:@"studentid"];
                NSString * slastpaymentkey=[[JSONArray objectAtIndex:i] objectForKey:@"lastpaymentkey"];
                
//                totaloutstandingsalespayment+=[soutstanding floatValue];

                [OutstandingSalesPaymentArray addObject:[[OutstandingSalesPaymentRecord alloc]initOutstandingSalesPaymentRecordWithSaleskey:ssaleskey studentkey:sstudentkey orderdate:sorderdate studentfullname:sstudentfullname product:sproduct quantity:squantity totalfee:stotalfee paid:spaid outstanding:soutstanding parentcontact:sparentcontact andgender:sgender andimage:simage andstudentid:sstudentid andproductfullname:sproductfullname lastpaymentkey:slastpaymentkey]];
            }
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            OutstandingSalesPaymentArray=[[NSMutableArray alloc] init];
            
            totaloutstandingsalespayment=0;
            
            df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our Instructor object
                NSString * ssaleskey=[[JSONArray objectAtIndex:i] objectForKey:@"saleskey"];
                NSString * sstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];

                NSString * sorderdate=[[JSONArray objectAtIndex:i] objectForKey:@"orderdate"];
                NSString * sstudentfullname=[MyClass returnStudentnameWithStudentkey:sstudentkey option:@"full"];
                NSString * sproduct=[[JSONArray objectAtIndex:i] objectForKey:@"productcode"];
                NSString * sproductfullname=[MyClass returnproductnamewithproductcode:sproduct centerkey:globalvariables.centerrecord.centerkey];
                NSString * squantity=[[JSONArray objectAtIndex:i] objectForKey:@"quantity"];
                NSString * stotalfee=[[JSONArray objectAtIndex:i] objectForKey:@"total"];
                NSString * spaid=[NSString stringWithFormat:@"%g",[[[JSONArray objectAtIndex:i] objectForKey:@"paid"] floatValue]];
                NSString * soutstanding=[NSString stringWithFormat:@"%g",[stotalfee floatValue]-[spaid floatValue]];
                NSString * sparentcontact=[[JSONArray objectAtIndex:i] objectForKey:@"parentcontact"];
                NSString * sgender=[[JSONArray objectAtIndex:i] objectForKey:@"gender"];
                NSString * simage=[[JSONArray objectAtIndex:i] objectForKey:@"image"];
                NSString * sstudentid=[[JSONArray objectAtIndex:i] objectForKey:@"studentid"];
                NSString * slastpaymentkey=[[JSONArray objectAtIndex:i] objectForKey:@"lastpaymentkey"];
                
                totaloutstandingsalespayment+=[soutstanding floatValue];

                [OutstandingSalesPaymentArray addObject:[[OutstandingSalesPaymentRecord alloc]initOutstandingSalesPaymentRecordWithSaleskey:ssaleskey studentkey:sstudentkey orderdate:sorderdate studentfullname:sstudentfullname product:sproduct quantity:squantity totalfee:stotalfee paid:spaid outstanding:soutstanding parentcontact:sparentcontact andgender:sgender andimage:simage andstudentid:sstudentid andproductfullname:sproductfullname lastpaymentkey:slastpaymentkey]];
            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
    if (result) {
        [self returnfilteroutstandingsalesarray];
        [OutstandingSalesPaymentTable reloadData];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    return result;
}



-(BOOL) retrieveOutstandingBankinRecord
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectoutstandingbankin&arckey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewpaymentinformation"],[MyClass returndefaultarckey]];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result = TRUE;
            NSDate *date;
            
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            lastoutstandingbankincash=0;
            lastoutstandingbankincheque=0;
            lastbankindatetime=nil;
            
            //Set up our class array
            OutstandingBankinArray=[[NSMutableArray alloc] init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our Instructor object
                
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"bankindatetime"]];
                [df setDateFormat:@"dd-MMM-yyyy"];
                
                NSString * sbankindatetime=[df stringFromDate:date];
                NSString * snewpaymentreceivedcash=[[JSONArray objectAtIndex:i] objectForKey:@"newpaymentreceivedcash"];
                NSString * sbankinamountcash=[[JSONArray objectAtIndex:i] objectForKey:@"bankinamountcash"];
                NSString * soutstandingbankincash=[[JSONArray objectAtIndex:i] objectForKey:@"outstandingbankincash"];
                NSString * snewpaymentreceivedcheque=[[JSONArray objectAtIndex:i] objectForKey:@"newpaymentreceivedcheque"];
                NSString * sbankinamountcheque=[[JSONArray objectAtIndex:i] objectForKey:@"bankinamountcheque"];
                NSString * soutstandingbankincheque=[[JSONArray objectAtIndex:i] objectForKey:@"outstandingbankincheque"];
                NSString * sbankinperson=[[JSONArray objectAtIndex:i] objectForKey:@"bankinperson"];
                NSString * sremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                
                snewpaymentreceivedcash=[snewpaymentreceivedcash isEqualToString:@""]?@"0":snewpaymentreceivedcash;
                sbankinamountcash=[sbankinamountcash isEqualToString:@""]?@"0":sbankinamountcash;
                soutstandingbankincash=[soutstandingbankincash isEqualToString:@""]?@"0":soutstandingbankincash;
                snewpaymentreceivedcheque=[snewpaymentreceivedcheque isEqualToString:@""]?@"0":snewpaymentreceivedcheque;
                sbankinamountcheque=[sbankinamountcheque isEqualToString:@""]?@"0":sbankinamountcheque;
                soutstandingbankincheque=[soutstandingbankincheque isEqualToString:@""]?@"0":soutstandingbankincheque;
                
                if (i==0) {
                    lastoutstandingbankincash=[soutstandingbankincash floatValue];
                    lastoutstandingbankincheque=[soutstandingbankincheque floatValue];
                    lastbankindatetime=[[JSONArray objectAtIndex:i] objectForKey:@"bankindatetime"];
                }
                
                //Add the instructor object to our instructor array
                [OutstandingBankinArray addObject:[[OutstandingBankinRecord alloc]initOutstandingBankinRecordWithbankindatetime:sbankindatetime newpaymentreceivedcash:snewpaymentreceivedcash newpaymentreceivedcheque:snewpaymentreceivedcheque bankinamountcash:sbankinamountcash bankinamountcheque:sbankinamountcheque outstandingbankincash:soutstandingbankincash outstandingbankincheque:soutstandingbankincheque bankinperson:sbankinperson remarks:sremarks]];
                
            }
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            result = TRUE;
        NSDate *date;
        
        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
        JSONArray = jsonreturned[@"content"];
        
        lastoutstandingbankincash=0;
        lastoutstandingbankincheque=0;
        lastbankindatetime=nil;
        
        //Set up our class array
        OutstandingBankinArray=[[NSMutableArray alloc] init];
        
        //loop through our jsonArray
        for (int i=0; i<JSONArray.count; i++) {
            
            //Create our Instructor object
            
            [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"bankindatetime"]];
            [df setDateFormat:@"dd-MMM-yyyy"];
            
            NSString * sbankindatetime=[df stringFromDate:date];
            NSString * snewpaymentreceivedcash=[[JSONArray objectAtIndex:i] objectForKey:@"newpaymentreceivedcash"];
            NSString * sbankinamountcash=[[JSONArray objectAtIndex:i] objectForKey:@"bankinamountcash"];
            NSString * soutstandingbankincash=[[JSONArray objectAtIndex:i] objectForKey:@"outstandingbankincash"];
            NSString * snewpaymentreceivedcheque=[[JSONArray objectAtIndex:i] objectForKey:@"newpaymentreceivedcheque"];
            NSString * sbankinamountcheque=[[JSONArray objectAtIndex:i] objectForKey:@"bankinamountcheque"];
            NSString * soutstandingbankincheque=[[JSONArray objectAtIndex:i] objectForKey:@"outstandingbankincheque"];
            NSString * sbankinperson=[[JSONArray objectAtIndex:i] objectForKey:@"bankinperson"];
            NSString * sremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
            
            snewpaymentreceivedcash=[snewpaymentreceivedcash isEqualToString:@""]?@"0":snewpaymentreceivedcash;
            sbankinamountcash=[sbankinamountcash isEqualToString:@""]?@"0":sbankinamountcash;
            soutstandingbankincash=[soutstandingbankincash isEqualToString:@""]?@"0":soutstandingbankincash;
            snewpaymentreceivedcheque=[snewpaymentreceivedcheque isEqualToString:@""]?@"0":snewpaymentreceivedcheque;
            sbankinamountcheque=[sbankinamountcheque isEqualToString:@""]?@"0":sbankinamountcheque;
            soutstandingbankincheque=[soutstandingbankincheque isEqualToString:@""]?@"0":soutstandingbankincheque;
            
            if (i==0) {
                lastoutstandingbankincash=[soutstandingbankincash floatValue];
                lastoutstandingbankincheque=[soutstandingbankincheque floatValue];
                lastbankindatetime=[[JSONArray objectAtIndex:i] objectForKey:@"bankindatetime"];
            }
            
            //Add the instructor object to our instructor array
            [OutstandingBankinArray addObject:[[OutstandingBankinRecord alloc]initOutstandingBankinRecordWithbankindatetime:sbankindatetime newpaymentreceivedcash:snewpaymentreceivedcash newpaymentreceivedcheque:snewpaymentreceivedcheque bankinamountcash:sbankinamountcash bankinamountcheque:sbankinamountcheque outstandingbankincash:soutstandingbankincash outstandingbankincheque:soutstandingbankincheque bankinperson:sbankinperson remarks:sremarks]];
            
        }
            
                }
                dispatch_semaphore_signal(semaphore);
            }] resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        [self updateOutstandingValue];
        [self.OutstandingBankinTable reloadData];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    return result;
}

-(void) doneBankin:(id)sender
{
    if ([self retrieveOutstandingBankinRecord]) {
        bankinchecked=TRUE;
        [self.view endEditing:YES];
        
        NSString *decimalRegex = @"^(?:|-)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
        
        NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", decimalRegex];
        
        if (![bankinamountcashinputText.text isEqualToString:@""] || ![bankinamountchequeinputText.text isEqualToString:@""]) {
            if (![regexPredicate evaluateWithObject: bankinamountcashinputText.text]){
                //UnMatches
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Invalid Cash amount input"] message:[MyClass returntitlewithtitle:@"Please input again"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
                bankinamountcashinputText.text=@"";
                
            }else if (![regexPredicate evaluateWithObject: bankinamountchequeinputText.text]){
                //UnMatches
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Invalid Cheque amount input"] message:[MyClass returntitlewithtitle:@"Please input again"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
                bankinamountchequeinputText.text=@"";
                
            }else if (![bankinamountcashinputText.text isEqualToString:@""] && [bankinamountcashinputText.text floatValue]>lastoutstandingbankincash+newreceivedpaymentcash){
                //bank in is greater than outstanding bank in
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Invalid Cash amount input"] message:[MyClass returntitlewithtitle:@"Amount entered is greater than the outstanding amount"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
                bankinamountcashinputText.text=@"";
                
            }else if (![bankinamountchequeinputText.text isEqualToString:@""] && [bankinamountchequeinputText.text floatValue]>lastoutstandingbankincheque+newreceivedpaymentcheque){
                //bank in is greater than outstanding bank in
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Invalid Cheque amount input"] message:[MyClass returntitlewithtitle:@"Amount entered is greater than the outstanding amount"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
                bankinamountchequeinputText.text=@"";
                
            }else{
                //bankinnewoutstandingLabel.text=[NSString stringWithFormat:@"%g",lastoutstandingbankincash+newreceivedpaymentcash-[bankinamountcashinputText.text floatValue]];
                
                
                
                NSNumberFormatter *NumberFormate = [[NSNumberFormatter alloc] init];
                [NumberFormate setRoundingIncrement:[NSNumber numberWithDouble:0.1]];
                [NumberFormate setMaximumFractionDigits:1];
                [NumberFormate setMinimumFractionDigits:0];

                
                NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=insertbankin&bankinamountcash=%@&bankinamountcheque=%@&bankinperson=%@&remarks=%@&arckey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,[NumberFormate stringFromNumber:[NSNumber numberWithFloat:[bankinamountcashinputText.text floatValue]]],[NumberFormate stringFromNumber:[NSNumber numberWithFloat:[bankinamountchequeinputText.text floatValue]]],globalvariables.username,bankinremarksText.text,[MyClass returndefaultarckey]];
                
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
                    }
                    dispatch_semaphore_signal(semaphore);
                }] resume];
                dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
                
                if (result) {
                    [self closesidewindow];
                    [self retrieveOutstandingBankinRecord];
                }/*else{
                    [MyClass showconnectionlostdialogbox];
                }*/
            }
        }
    }
}

-(BOOL) retrievenewpaymentreceived
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getnewpaymentreceived&lastbankindatetime=%@&arckey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewpaymentinformation"],lastbankindatetime,[MyClass returndefaultarckey]];
    
    //NSURL * url = [NSURL URLWithString:strURL];
    // NSData * data = [NSData dataWithContentsOfURL:url];
    
    newreceivedpaymentcash=0;
    newreceivedpaymentcheque=0;
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            if ([[JSONArray objectAtIndex:0] objectForKey:@"newpaymentreceivedcash"]) {
                newreceivedpaymentcash= [[[JSONArray objectAtIndex:0] objectForKey:@"newpaymentreceivedcash"] floatValue];
            }else{
                newreceivedpaymentcash= 0;
            }
            
            if ([[JSONArray objectAtIndex:0] objectForKey:@"newpaymentreceivedcheque"]) {
                newreceivedpaymentcheque= [[[JSONArray objectAtIndex:0] objectForKey:@"newpaymentreceivedcheque"] floatValue];
            }else{
                newreceivedpaymentcheque= 0;
            }
            
            if ([[JSONArray objectAtIndex:0] objectForKey:@"totaloutstanding"]) {
                totaloutstanding= [[[JSONArray objectAtIndex:0] objectForKey:@"totaloutstanding"] floatValue];
            }else{
                totaloutstanding= 0;
            }
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            if ([[JSONArray objectAtIndex:0] objectForKey:@"newpaymentreceivedcash"]) {
                newreceivedpaymentcash= [[[JSONArray objectAtIndex:0] objectForKey:@"newpaymentreceivedcash"] floatValue];
            }else{
                newreceivedpaymentcash= 0;
            }
            
            if ([[JSONArray objectAtIndex:0] objectForKey:@"newpaymentreceivedcheque"]) {
                newreceivedpaymentcheque= [[[JSONArray objectAtIndex:0] objectForKey:@"newpaymentreceivedcheque"] floatValue];
            }else{
                newreceivedpaymentcheque= 0;
            }
            result= YES;
        }else{
            [MyClass showconnectionlostdialogbox];
            //return NO;
        }
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    return result;
    
}


-(BOOL) retrieveDetailsPaymentWithPaymentType:(NSString *)paymenttype paymenttypekey:(NSString *)paymenttypekey
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectpaymentdetails&paymenttypekey=%@&paymenttype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,paymenttypekey,paymenttype];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result = TRUE;
            NSDate *date;
            
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            DetailsPaymentArray=[[NSMutableArray alloc] init];
            
            //totaloutstandingbankin=0;
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our Instructor object
                NSString * spaymentkey=[[JSONArray objectAtIndex:i] objectForKey:@"paymentkey"];
                NSString * spaymenttype=[[JSONArray objectAtIndex:i] objectForKey:@"paymenttype"];
                NSString * spaymenttypekey=[[JSONArray objectAtIndex:i] objectForKey:@"paymenttypekey"];
                
                [df setDateFormat:@"yyyy-MM-dd"];
                date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"paiddate"]];
                [df setDateFormat:@"dd-MMM-yyyy"];
                
                NSString * spaiddate=[df stringFromDate:date];
                NSString * spaidmethod=[[JSONArray objectAtIndex:i] objectForKey:@"paidmethod"];
                NSString * spaidamount=[[JSONArray objectAtIndex:i] objectForKey:@"paidamount"];
                NSString * spaymentremarks=[[JSONArray objectAtIndex:i] objectForKey:@"paymentremarks"];
                NSString * sreceiptremarks=[[JSONArray objectAtIndex:i] objectForKey:@"receiptremarks"];
                NSString * sstaffname=[[JSONArray objectAtIndex:i] objectForKey:@"staffname"];
                NSString * sreceiptnumber=[[JSONArray objectAtIndex:i] objectForKey:@"receiptnumber"];
                NSString * sreceiptprefix=[[JSONArray objectAtIndex:i] objectForKey:@"receiptprefix"];
                
                //Add the instructor object to our instructor array
                [DetailsPaymentArray addObject:[[PaymentRecord alloc]initPaymentRecordwithPaymentkey:spaymentkey paymenttype:spaymenttype paymenttypekey:spaymenttypekey paiddate:spaiddate paidmethod:spaidmethod paidamount:spaidamount action:@"locked" paymentremarks:spaymentremarks receiptremarks:sreceiptremarks staffname:sstaffname receiptnumber:sreceiptnumber receiptprefix:sreceiptprefix]];
                
            }
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            result = TRUE;
            NSDate *date;
            
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            DetailsPaymentArray=[[NSMutableArray alloc] init];
            
            //totaloutstandingbankin=0;
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our Instructor object
                NSString * spaymentkey=[[JSONArray objectAtIndex:i] objectForKey:@"paymentkey"];
                NSString * spaymenttype=[[JSONArray objectAtIndex:i] objectForKey:@"paymenttype"];
                NSString * spaymenttypekey=[[JSONArray objectAtIndex:i] objectForKey:@"paymenttypekey"];
                
                [df setDateFormat:@"yyyy-MM-dd"];
                date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"paiddate"]];
                [df setDateFormat:@"dd-MMM-yyyy"];
                
                NSString * spaiddate=[df stringFromDate:date];
                NSString * spaidmethod=[[JSONArray objectAtIndex:i] objectForKey:@"paidmethod"];
                NSString * spaidamount=[[JSONArray objectAtIndex:i] objectForKey:@"paidamount"];
                NSString * spaymentremarks=[[JSONArray objectAtIndex:i] objectForKey:@"paymentremarks"];
                NSString * sreceiptremarks=[[JSONArray objectAtIndex:i] objectForKey:@"receiptremarks"];
                NSString * sstaffname=[[JSONArray objectAtIndex:i] objectForKey:@"staffname"];
                
                //Add the instructor object to our instructor array
                [DetailsPaymentArray addObject:[[PaymentRecord alloc]initPaymentRecordwithPaymentkey:spaymentkey paymenttype:spaymenttype paymenttypekey:spaymenttypekey paiddate:spaiddate paidmethod:spaidmethod paidamount:spaidamount action:@"locked" paymentremarks:spaymentremarks receiptremarks:sreceiptremarks staffname:sstaffname]];
                
            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        [self.DetailsPaymentTable reloadData];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    return result;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==InvoiceLogRecordTable){
        InvoiceLogRecord *object=[filteredInvoiceLogArray objectAtIndex:indexPath.row];
        [self deleteinvoicelog:object.invoicelogkey];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (tableView==InvoiceLogRecordTable) {
        return [MyClass returntitlewithtitle:@"Delete"];
    //}
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView==DetailsPaymentTable) {
        if ([tablemode isEqualToString:@"View"] || [tablemode isEqualToString:@"Edit"]) {
            return 3;
        }else if ([tablemode isEqualToString:@"Add"]){
            if (DetailsPaymentArray.count==0) {
                return 2;
            }else{
                return 3;
            }
        }else if ([tablemode isEqualToString:@"EditPaymentRemarks"]){
            return 1;
        }else{ //editinvoiceremarks
            return 1;
        }
        
    }else if(tableView==BankinInputTable){
        return 2;
    }else{ // outstanding payment, outstanding bankin and share table
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==OutstandingClassPaymentTable) {
        return filteredOutstandingClassPaymentArray.count;
    }else if(tableView==OutstandingSalesPaymentTable){
        return filteredOutstandingSalesPaymentArray.count;
    }else if(tableView==OutstandingBankinTable){
        return OutstandingBankinArray.count;
        
        
    }else if(tableView==BankinInputTable){
        if (section==0) {
            return 2;
        }else{
            return 1;
        }
        
    }else if (tableView==DetailsPaymentTable){
        if ([tablemode isEqualToString:@"View"] || [tablemode isEqualToString:@"Edit"]) {
            if (section==0) {
                return 3;
            }else if (section==1){
                return DetailsPaymentArray.count;
            }else{
                return 1;
            }
        }else if ([tablemode isEqualToString:@"Add"]){
            if (DetailsPaymentArray.count==0) {
                if (section==0) {
                    return 3;
                }else{
                    return 7;
                }
            }else{
                if (section==0) {
                    return 3;
                }else if (section==1){
                    return 7;
                }else{
                    return DetailsPaymentArray.count;
                }
            }
        }else if ([tablemode isEqualToString:@"EditPaymentRemarks"]){
            return 5;
        }else{ //edit invoice remarks
            return 1;
        }
    }else if (tableView==sortingtable){
        return sortingarray.count;
    }else if (tableView==sharetable){
        return 4;
    }else if (tableView==InvoiceLogRecordTable){
        return filteredInvoiceLogArray.count;
    }else if (tableView==InvoiceLogItemTable){
        if (selectedinvoicelogkey && filteredInvoiceLogArray.count>0) {
            return ((InvoiceLogRecord *)[filteredInvoiceLogArray objectAtIndex:selectedinvoicerow]).itemarray.count;
        }
    }else if (tableView==PaymentReceivedTable){
        return PaymentReceivedRecordsArray.count;
    }else if (tableView==PaymentReceivedDetailsTable){
        if (selectedpaiddate && PaymentReceivedRecordsArray.count>0) {
            return ((PaymentReceivedRecord *)[PaymentReceivedRecordsArray objectAtIndex:selectedpaiddaterow]).paymentrecords.count;
        }
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==DetailsPaymentTable) {
        if ([tablemode isEqualToString:@"View"] || [tablemode isEqualToString:@"Edit"]) {
            if (indexPath.section==0) {
                return 35;
            }else if (indexPath.section==1){
                
                float cellheight=35;
                DetailsPaymentObject=[DetailsPaymentArray objectAtIndex:indexPath.row];
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
                cellheight+=15;

                return cellheight;
            }else{
                return 100;
            }
            
        }else if ([tablemode isEqualToString:@"Add"]){
            if (indexPath.section==1 && indexPath.row==1) {
                if (showPaidMethodPicker) {
                    return 150;
                }else{
                    return 0;
                }
            }else if (indexPath.section==1 && indexPath.row==3) {
                if (showPaymentDatePicker) {
                    return 200;
                }else{
                    return 0;
                }
            }else if (indexPath.section==1 && (indexPath.row==5 || indexPath.row==6)){
                return 100;
            }else if (indexPath.section==2){
                float cellheight=35;
                DetailsPaymentObject=[DetailsPaymentArray objectAtIndex:indexPath.row];
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
        }else if ([tablemode isEqualToString:@"EditPaymentRemarks"]){
            if (indexPath.row<=2) {
                return 35;
            }else{
                return 100;
            }
        }else{ //edit invoice remarks
            return 100;
        }
        
    }else if(tableView==BankinInputTable){
        if (indexPath.section==1) {
            return 100;
        }else{
            return 38;
        }
    }else if (tableView==sharetable){
        return 38;
    }else if (tableView==sortingtable){
        return 38;
    }else if (tableView==OutstandingBankinTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==InvoiceLogRecordTable){
        return 50;
    }else if (tableView==InvoiceLogItemTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==PaymentReceivedTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==PaymentReceivedDetailsTable){
        return UITableViewAutomaticDimension;
    }else{
        return 48;
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==DetailsPaymentTable) {
        if ([tablemode isEqualToString:@"View"] || [tablemode isEqualToString:@"Edit"]) {
            if (section==0) {
                return [MyClass returntitlewithtitle:@"Summary"];
            }else if (section==1){
                if (DetailsPaymentArray.count==0) {
                    return nil;
                }else{
                    return [MyClass returntitlewithtitle:@"Payment History"];
                }
            }else{
                return [MyClass returntitlewithtitle:@"Invoice Remarks"];
            }
        }else if ([tablemode isEqualToString:@"Add"]){
            if (DetailsPaymentArray.count==0) {
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
        }else if ([tablemode isEqualToString:@"EditPaymentRemarks"]){
            return [MyClass returntitlewithtitle:@"Edit Payment Record"];
        }else{ //edit invoice remarks
            return [MyClass returntitlewithtitle:@"Edit Invoice Remarks"];
        }
    }else if(tableView==BankinInputTable){
        if (section==0) {
            return [MyClass returntitlewithtitle:@"Withdrawal"];
        }else{
            return [MyClass returntitlewithtitle:@"Remarks"];
        }
        
    }else if (tableView==sortingtable){
        return [MyClass returntitlewithtitle:@"Sorting Order"];
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView==DetailsPaymentTable || tableView==BankinInputTable) {
        if ([tableView numberOfSections]-1==section) {
            return 30;
        }else{
            return CGFLOAT_MIN;
        }
    }else{
        return CGFLOAT_MIN;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==DetailsPaymentTable){
        
        if (section==1) {
            if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
                return CGFLOAT_MIN;
            }
        }
        
        if (section==0) {
            return 44;
        }else if (section==1){
            return 44;
        }else{
            if (DetailsPaymentArray.count==0) {
                return CGFLOAT_MIN;
            }else{
                return 44;
            }
        }
    }else if (tableView==BankinInputTable){
        return 44;
    }else if (tableView==sortingtable){
        return 40;
    }else{
        return CGFLOAT_MIN;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == OutstandingClassPaymentTable) {
        
        long combinepaymentoffset=isSelectCombinePayment?35:0;
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        OutstandingPaymentObject=[[OutstandingPaymentRecord alloc]init];
        OutstandingPaymentObject = [filteredOutstandingClassPaymentArray objectAtIndex:indexPath.row];
        
        
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            //add textfield
            StudentNameLabel = [[UILabel alloc]init];
            StudentNameLabel.font=[UIFont systemFontOfSize:13];
            StudentNameLabel.textColor=[UIColor darkGrayColor];
            StudentNameLabel.tag=201;
            StudentNameLabel.adjustsFontSizeToFitWidth=YES;
            StudentNameLabel.numberOfLines=0;
            StudentNameLabel.minimumScaleFactor=0.7;
            [cell.contentView addSubview:StudentNameLabel];
            
            StudentIDLabel = [[UILabel alloc]init];
            StudentIDLabel.font=[UIFont systemFontOfSize:10];
            StudentIDLabel.textColor=[UIColor grayColor];
            StudentIDLabel.adjustsFontSizeToFitWidth=YES;
            StudentIDLabel.minimumScaleFactor=0.7;
            StudentIDLabel.tag=212;
            [cell.contentView addSubview:StudentIDLabel];

            
            EnrollmentDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Enrollment.frame.origin.x, 3, 155, 21)];
            EnrollmentDateLabel.font=[UIFont systemFontOfSize:13];
            EnrollmentDateLabel.textColor=[UIColor darkGrayColor];
            EnrollmentDateLabel.tag=202;
            EnrollmentDateLabel.minimumScaleFactor=0.7;
            EnrollmentDateLabel.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:EnrollmentDateLabel];
            
            ClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Subject.frame.origin.x, 3, 225, 21)];
            ClassLabel.font=[UIFont systemFontOfSize:13];
            ClassLabel.textColor=[UIColor darkGrayColor];
            ClassLabel.tag=203;
            [cell.contentView addSubview:ClassLabel];
            
            ClassDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Day.frame.origin.x, 3, 70, 21)];
            ClassDayLabel.font=[UIFont systemFontOfSize:13];
            ClassDayLabel.textColor=[UIColor darkGrayColor];
            ClassDayLabel.minimumScaleFactor=0.5;
            ClassDayLabel.numberOfLines=0;
            ClassDayLabel.adjustsFontSizeToFitWidth=YES;
            ClassDayLabel.tag=204;
            [cell.contentView addSubview:ClassDayLabel];
            
            
            ClassTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Time.frame.origin.x,22, 80, 21)];
            ClassTimeLabel.font=[UIFont systemFontOfSize:13];
            ClassTimeLabel.textColor=[UIColor darkGrayColor];
            ClassTimeLabel.minimumScaleFactor=0.5;
            ClassTimeLabel.numberOfLines=0;
            ClassTimeLabel.adjustsFontSizeToFitWidth=YES;
            ClassTimeLabel.tag=205;
            [cell.contentView addSubview:ClassTimeLabel];
            
            StartDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Start.frame.origin.x, 3, 76, 21)];
            StartDateLabel.font=[UIFont systemFontOfSize:13];
            StartDateLabel.textColor=[UIColor darkGrayColor];
            //StartDateLabel.textAlignment=NSTextAlignmentCenter;
            StartDateLabel.tag=206;
            [cell.contentView addSubview:StartDateLabel];
            
            EndDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_End.frame.origin.x, 22, 76, 21)];
            EndDateLabel.font=[UIFont systemFontOfSize:13];
            EndDateLabel.textColor=[UIColor darkGrayColor];
            //EndDateLabel.textAlignment=NSTextAlignmentCenter;
            EndDateLabel.tag=207;
            [cell.contentView addSubview:EndDateLabel];
            
            NoOfClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_No_of_Class.frame.origin.x, 3, 81, 21)];
            NoOfClassLabel.font=[UIFont systemFontOfSize:13];
            NoOfClassLabel.textColor=[UIColor darkGrayColor];
            //NoOfClassLabel.textAlignment=NSTextAlignmentCenter;
            NoOfClassLabel.tag=208;
            [cell.contentView addSubview:NoOfClassLabel];
            
            TotalFeeLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Total_Fee.frame.origin.x, 3, 73, 21)];
            TotalFeeLabel.font=[UIFont systemFontOfSize:13];
            TotalFeeLabel.textColor=[UIColor darkGrayColor];
            //TotalFeeLabel.textAlignment=NSTextAlignmentCenter;
            TotalFeeLabel.tag=209;
            [cell.contentView addSubview:TotalFeeLabel];
            
            
            PaidLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Paid.frame.origin.x, 3, 67, 21)];
            PaidLabel.font=[UIFont systemFontOfSize:13];
            PaidLabel.textColor=[UIColor darkGrayColor];
            //PaidLabel.textAlignment=NSTextAlignmentCenter;
            PaidLabel.tag=210;
            [cell.contentView addSubview:PaidLabel];
            
            
            OutstandingLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Outstanding.frame.origin.x, 3, 101, 21)];
            OutstandingLabel.font=[UIFont systemFontOfSize:13];
            OutstandingLabel.textColor=[UIColor redColor];
            //OutstandingLabel.textAlignment=NSTextAlignmentCenter;
            OutstandingLabel.tag=211;
            [cell.contentView addSubview:OutstandingLabel];
            /*
            ParentcontactLabel = [[UILabel alloc]initWithFrame:CGRectMake(925, 9, 101, 21)];
            ParentcontactLabel.font=[UIFont systemFontOfSize:13];
            ParentcontactLabel.textColor=[UIColor darkGrayColor];
            ParentcontactLabel.tag=212;
            [cell.contentView addSubview:ParentcontactLabel];*/
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
            singleTap.numberOfTapsRequired = 1;
            
            studentimage=[[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 38, 38)];
            studentimage.layer.cornerRadius=19;
            studentimage.tag=213;
            studentimage.contentMode=UIViewContentModeScaleAspectFill;
            studentimage.layer.masksToBounds=YES;
            studentimage.userInteractionEnabled = YES;
            [studentimage addGestureRecognizer:singleTap];
            [cell.contentView addSubview:studentimage];
            
            class_combinepaymentstatusimageview=[[UIImageView alloc]initWithFrame:CGRectMake(12, (48-14)/2, 14, 14)];
            class_combinepaymentstatusimageview.layer.cornerRadius=7;
            class_combinepaymentstatusimageview.layer.borderColor=[UIColor lightGrayColor].CGColor;
            class_combinepaymentstatusimageview.layer.borderWidth=0.5;
            class_combinepaymentstatusimageview.tag=214;
            [cell.contentView addSubview:class_combinepaymentstatusimageview];
            
            
        }else{
            StudentNameLabel=(UILabel *)[cell.contentView viewWithTag:201];
            EnrollmentDateLabel=(UILabel *)[cell.contentView viewWithTag:202];
            ClassLabel=(UILabel *)[cell.contentView viewWithTag:203];
            ClassDayLabel=(UILabel *)[cell.contentView viewWithTag:204];
            ClassTimeLabel=(UILabel *)[cell.contentView viewWithTag:205];
            StartDateLabel=(UILabel *)[cell.contentView viewWithTag:206];
            EndDateLabel=(UILabel *)[cell.contentView viewWithTag:207];
            NoOfClassLabel=(UILabel *)[cell.contentView viewWithTag:208];
            TotalFeeLabel=(UILabel *)[cell.contentView viewWithTag:209];
            PaidLabel=(UILabel *)[cell.contentView viewWithTag:210];
            OutstandingLabel=(UILabel *)[cell.contentView viewWithTag:211];
            StudentIDLabel=(UILabel *)[cell.contentView viewWithTag:212];
            studentimage=(UIImageView *)[cell.contentView viewWithTag:213];
            class_combinepaymentstatusimageview=(UIImageView *)[cell.contentView viewWithTag:214];
        }
        
        studentimage.frame=CGRectMake(4+combinepaymentoffset, 4, 38, 38);
        StudentNameLabel.frame=CGRectMake(45+combinepaymentoffset, 0, 140, 38);
        StudentIDLabel.frame=CGRectMake(45+combinepaymentoffset, 0, 140, 38);
        ClassLabel.frame=CGRectMake(title_Class_Student.frame.origin.x+title_Class_Student.frame.size.width+combinepaymentoffset, 3, 225-combinepaymentoffset, 21);
        

        
        
        // Configure the cell...
        StudentNameLabel.text=[MyClass returnStudentnameWithStudentkey:OutstandingPaymentObject.studentkey option:@"full"];//[MyClass returnfullnamewithfirstname:OutstandingPaymentObject.firstname lastname:OutstandingPaymentObject.lastname];
        StudentIDLabel.text=OutstandingPaymentObject.studentid;
        
        [StudentNameLabel sizeToFit];
        CGRect myFrame=StudentNameLabel.frame;
        
        if ([OutstandingPaymentObject.studentid isEqualToString:@""]) {

            if (myFrame.size.height>36) {
                StudentNameLabel.frame=CGRectMake(45+combinepaymentoffset, 6, 140, 36);
            }else{
                StudentNameLabel.frame=CGRectMake(45+combinepaymentoffset, 6, 140, myFrame.size.height);
            }
        }else{
            
            if (myFrame.size.height+12+3>48-12) {
                StudentNameLabel.frame=CGRectMake(45+combinepaymentoffset, 3, myFrame.size.width, 36-3-12+3);
            }else{
                StudentNameLabel.frame=CGRectMake(45+combinepaymentoffset, 6, 140, myFrame.size.height);
            }
            
            StudentIDLabel.frame=CGRectMake(45+combinepaymentoffset, StudentNameLabel.frame.origin.y+StudentNameLabel.frame.size.height+3, 140, 12);
        }
        

        
        EnrollmentDateLabel.text=[MyClass convertDateFormatWithDate:OutstandingPaymentObject.enrollmentdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
        ClassLabel.text = OutstandingPaymentObject.subjectfullname;// [MyClass returnsubjectnamewithsubject_shortname:OutstandingPaymentObject.subject centerkey:globalvariables.centerrecord.centerkey];
        ClassDayLabel.text=[self returnclassdaywithclassdaystring:OutstandingPaymentObject.classday];
        ClassTimeLabel.text=[self returnclasstimewithclasstimestring:OutstandingPaymentObject.classtime];
        StartDateLabel.text=[MyClass returnMMMdwithstandarddate:OutstandingPaymentObject.startdate];
        EndDateLabel.text=[MyClass returnMMMdwithstandarddate:OutstandingPaymentObject.enddate];
        NoOfClassLabel.text=OutstandingPaymentObject.noofclass;
        TotalFeeLabel.text=[formatter stringFromNumber:[NSNumber numberWithFloat:[OutstandingPaymentObject.totalfee floatValue]]];
        PaidLabel.text=[formatter stringFromNumber:[NSNumber numberWithFloat:[OutstandingPaymentObject.paid floatValue]]];
        OutstandingLabel.text=[formatter stringFromNumber:[NSNumber numberWithFloat:[OutstandingPaymentObject.outstanding floatValue]]];
        //ParentcontactLabel.text=OutstandingPaymentObject.parentcontact;
        
        [MyClass downloadImageWithImageview:studentimage gender:OutstandingPaymentObject.gender type:@"student" typekey:OutstandingPaymentObject.studentkey image:OutstandingPaymentObject.image async:YES];
        

            
            StudentNameLabel.hidden=NO;
            studentimage.hidden=NO;
            ClassLabel.hidden=NO;
            
            if ([OutstandingPaymentObject.enrollmentkey isEqualToString:selectedParentRow]) {
                cell.backgroundColor=[UIColor grayColor];
                StudentNameLabel.textColor=[UIColor yellowColor];
                StudentIDLabel.textColor=[UIColor yellowColor];
                EnrollmentDateLabel.textColor=[UIColor yellowColor];
                ClassLabel.textColor=[UIColor yellowColor];
                ClassDayLabel.textColor=[UIColor yellowColor];
                
                ClassTimeLabel.textColor=[UIColor yellowColor];
                StartDateLabel.textColor=[UIColor yellowColor];
                EndDateLabel.textColor=[UIColor yellowColor];
                NoOfClassLabel.textColor=[UIColor yellowColor];
                TotalFeeLabel.textColor=[UIColor yellowColor];
                PaidLabel.textColor=[UIColor yellowColor];
                OutstandingLabel.textColor=[UIColor yellowColor];
                //ParentcontactLabel.textColor=[UIColor yellowColor];
            }else{
                StudentNameLabel.textColor=[UIColor darkGrayColor];
                StudentIDLabel.textColor=[UIColor darkGrayColor];
                EnrollmentDateLabel.textColor=[UIColor darkGrayColor];
                ClassLabel.textColor=[UIColor darkGrayColor];
                ClassDayLabel.textColor=[UIColor darkGrayColor];
                ClassTimeLabel.textColor=[UIColor darkGrayColor];
                StartDateLabel.textColor=[UIColor darkGrayColor];
                EndDateLabel.textColor=[UIColor darkGrayColor];
                NoOfClassLabel.textColor=[UIColor darkGrayColor];
                TotalFeeLabel.textColor=[UIColor darkGrayColor];
                PaidLabel.textColor=[UIColor darkGrayColor];
                OutstandingLabel.textColor=[UIColor redColor];
                //ParentcontactLabel.textColor=[UIColor darkGrayColor];
                
            }
            
        //}
        
        if (isSelectCombinePayment) {
            class_combinepaymentstatusimageview.hidden=NO;
            if ([globalvariables.documentfolder.classpaymentarray containsObject:OutstandingPaymentObject.enrollmentkey]) {
                if ([globalvariables.documentfolder.classinvoicearray containsObject:OutstandingPaymentObject.enrollmentkey]) {
                    if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:OutstandingPaymentObject.lastpaymentkey]) {
                        [class_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"redgreenorange_icon.png"]];
                    }else{
                        [class_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"greenred_icon.png"]];
                    }
                }else{
                    if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:OutstandingPaymentObject.lastpaymentkey]) {
                        [class_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"orangered_icon.png"]];
                    }else{
                        [class_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"red_icon.png"]];
                    }
                }
            }else{
                if ([globalvariables.documentfolder.classinvoicearray containsObject:OutstandingPaymentObject.enrollmentkey]) {
                    if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:OutstandingPaymentObject.lastpaymentkey]) {
                        [class_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"greenorange_icon.png"]];
                    }else{
                        [class_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"green_icon.png"]];
                    }
                }else{
                    if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:OutstandingPaymentObject.lastpaymentkey]) {
                        [class_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"orange_icon.png"]];
                    }else{
                        [class_combinepaymentstatusimageview setImage:nil];
                    }
                }
            }
        }else{
            class_combinepaymentstatusimageview.hidden=YES;
        }
        
        //alternative background color;
        if (![OutstandingPaymentObject.enrollmentkey isEqualToString:selectedParentRow]) {
            if (indexPath.row %2==0) {
                cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
            }else{
                cell.backgroundColor=[UIColor whiteColor];
            }
        }
        
        
        
        //cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
        
        
        
    }else if (tableView == OutstandingSalesPaymentTable) {
        
        long combinepaymentoffset=isSelectCombinePayment?35:0;
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        outstandingsalespaymentobject=[[OutstandingSalesPaymentRecord alloc]init];
        outstandingsalespaymentobject = [filteredOutstandingSalesPaymentArray objectAtIndex:indexPath.row];
        
        
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            //add textfield
            OrderDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Order_Date.frame.origin.x, 3, 155, 21)];
            OrderDateLabel.font=[UIFont systemFontOfSize:13];
            OrderDateLabel.textColor=[UIColor darkGrayColor];
            OrderDateLabel.tag=471;
            [cell.contentView addSubview:OrderDateLabel];
            
            StudentNameLabel = [[UILabel alloc]init];
            StudentNameLabel.font=[UIFont systemFontOfSize:13];
            StudentNameLabel.textColor=[UIColor darkGrayColor];
            StudentNameLabel.tag=472;
            StudentNameLabel.adjustsFontSizeToFitWidth=YES;
            StudentNameLabel.minimumScaleFactor=0.7;
            [cell.contentView addSubview:StudentNameLabel];
            
            sales_StudentIDLabel = [[UILabel alloc]init];
            sales_StudentIDLabel.font=[UIFont systemFontOfSize:10];
            sales_StudentIDLabel.textColor=[UIColor grayColor];
            sales_StudentIDLabel.adjustsFontSizeToFitWidth=YES;
            sales_StudentIDLabel.minimumScaleFactor=0.7;
            sales_StudentIDLabel.tag=481;
            [cell.contentView addSubview:sales_StudentIDLabel];
            
            ProductLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Product.frame.origin.x, 3, 225, 21)];
            ProductLabel.font=[UIFont systemFontOfSize:13];
            ProductLabel.textColor=[UIColor darkGrayColor];
            ProductLabel.minimumScaleFactor=0.5;
            ProductLabel.adjustsFontSizeToFitWidth=YES;
            ProductLabel.tag=473;
            [cell.contentView addSubview:ProductLabel];
            
            
            QuantityLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_Quantity.frame.origin.x, 3, 81, 21)];
            QuantityLabel.font=[UIFont systemFontOfSize:13];
            QuantityLabel.textColor=[UIColor darkGrayColor];
            QuantityLabel.tag=475;
            [cell.contentView addSubview:QuantityLabel];
            
            
            TotalFeeLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_product_Total_Fee.frame.origin.x, 3, 73, 21)];
            TotalFeeLabel.font=[UIFont systemFontOfSize:13];
            TotalFeeLabel.textColor=[UIColor darkGrayColor];
            TotalFeeLabel.tag=476;
            [cell.contentView addSubview:TotalFeeLabel];
            
            
            PaidLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_product_Paid.frame.origin.x, 3, 67, 21)];
            PaidLabel.font=[UIFont systemFontOfSize:13];
            PaidLabel.textColor=[UIColor darkGrayColor];
            PaidLabel.tag=477;
            [cell.contentView addSubview:PaidLabel];
            
            
            OutstandingLabel = [[UILabel alloc]initWithFrame:CGRectMake(title_product_Outstanding.frame.origin.x, 3, 101, 21)];
            OutstandingLabel.font=[UIFont systemFontOfSize:13];
            OutstandingLabel.textColor=[UIColor redColor];
            OutstandingLabel.tag=478;
            [cell.contentView addSubview:OutstandingLabel];
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
            singleTap.numberOfTapsRequired = 1;
            
            sales_studentimage=[[UIImageView alloc]initWithFrame:CGRectMake(4, 4, 38, 38)];
            sales_studentimage.layer.cornerRadius=19;
            sales_studentimage.contentMode=UIViewContentModeScaleAspectFill;
            sales_studentimage.tag=479;
            sales_studentimage.layer.masksToBounds=YES;
            sales_studentimage.userInteractionEnabled = YES;
            [sales_studentimage addGestureRecognizer:singleTap];
            [cell.contentView addSubview:sales_studentimage];
            
            sales_combinepaymentstatusimageview=[[UIImageView alloc]initWithFrame:CGRectMake(12, (48-14)/2, 14, 14)];
            //sales_combinepaymentstatusimageview.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
            sales_combinepaymentstatusimageview.layer.cornerRadius=8;
            sales_combinepaymentstatusimageview.layer.borderColor=[UIColor lightGrayColor].CGColor;
            sales_combinepaymentstatusimageview.layer.borderWidth=0.5;
            //sales_combinepaymentstatusimageview.layer.opacity=0.3;
            sales_combinepaymentstatusimageview.tag=480;
            [cell.contentView addSubview:sales_combinepaymentstatusimageview];
            
            
        }else{
            OrderDateLabel=(UILabel *)[cell.contentView viewWithTag:471];
            StudentNameLabel=(UILabel *)[cell.contentView viewWithTag:472];
            ProductLabel=(UILabel *)[cell.contentView viewWithTag:473];
            QuantityLabel=(UILabel *)[cell.contentView viewWithTag:475];
            TotalFeeLabel=(UILabel *)[cell.contentView viewWithTag:476];
            PaidLabel=(UILabel *)[cell.contentView viewWithTag:477];
            OutstandingLabel=(UILabel *)[cell.contentView viewWithTag:478];
            sales_studentimage=(UIImageView *)[cell.contentView viewWithTag:479];
            sales_combinepaymentstatusimageview=(UIImageView *)[cell.contentView viewWithTag:480];
            sales_StudentIDLabel=(UILabel *)[cell.contentView viewWithTag:481];
            
        }
        
        sales_studentimage.frame=CGRectMake(4+combinepaymentoffset, 4, 38, 38);
        StudentNameLabel.frame=CGRectMake(45+combinepaymentoffset, 6, 140, 44);
        sales_StudentIDLabel.frame=CGRectMake(45+combinepaymentoffset, 6, 140, 44);
        ProductLabel.frame=CGRectMake(title_Sales_Student.frame.origin.x+title_Sales_Student.frame.size.width+combinepaymentoffset, 3, 225-combinepaymentoffset, 21);
        
        // Configure the cell...
        StudentNameLabel.text=[MyClass returnStudentnameWithStudentkey:outstandingsalespaymentobject.studentkey option:@"full"];//[MyClass returnfullnamewithfirstname:outstandingsalespaymentobject.firstname lastname:outstandingsalespaymentobject.lastname];
        sales_StudentIDLabel.text=outstandingsalespaymentobject.studentid;
        
        [StudentNameLabel sizeToFit];
        CGRect myFrame=StudentNameLabel.frame;
        
        if ([OutstandingPaymentObject.studentid isEqualToString:@""]) {
            
            if (myFrame.size.height>36) {
                StudentNameLabel.frame=CGRectMake(45+combinepaymentoffset, 6, 140, 36);
            }else{
                StudentNameLabel.frame=CGRectMake(45+combinepaymentoffset, 6, 140, myFrame.size.height);
            }
        }else{
            
            if (myFrame.size.height+12+3>48-12) {
                StudentNameLabel.frame=CGRectMake(45+combinepaymentoffset, 3, myFrame.size.width, 36-3-12+3);
            }else{
                StudentNameLabel.frame=CGRectMake(45+combinepaymentoffset, 6, 140, myFrame.size.height);
            }
            
            sales_StudentIDLabel.frame=CGRectMake(45+combinepaymentoffset, StudentNameLabel.frame.origin.y+StudentNameLabel.frame.size.height+3, 140, 12);
        }
        
        
        OrderDateLabel.text=[MyClass convertDateFormatWithDate:outstandingsalespaymentobject.orderdate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
        ProductLabel.text = outstandingsalespaymentobject.productfullname;// outstandingsalespaymentobject.product;
        QuantityLabel.text=outstandingsalespaymentobject.quantity;
        TotalFeeLabel.text=[formatter stringFromNumber:[NSNumber numberWithFloat:[outstandingsalespaymentobject.totalfee floatValue]]];
        PaidLabel.text=[formatter stringFromNumber:[NSNumber numberWithFloat:[outstandingsalespaymentobject.paid floatValue]]];
        OutstandingLabel.text=[formatter stringFromNumber:[NSNumber numberWithFloat:[outstandingsalespaymentobject.outstanding floatValue]]];
        
        [MyClass downloadImageWithImageview:sales_studentimage gender:outstandingsalespaymentobject.gender type:@"student" typekey:outstandingsalespaymentobject.studentkey image:outstandingsalespaymentobject.image async:YES];
        
        if (isSelectCombinePayment) {
            sales_combinepaymentstatusimageview.hidden=NO;
            if ([globalvariables.documentfolder.salespaymentarray containsObject:outstandingsalespaymentobject.saleskey]) {
                if ([globalvariables.documentfolder.salesinvoicearray containsObject:outstandingsalespaymentobject.saleskey]) {
                    if (![outstandingsalespaymentobject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:outstandingsalespaymentobject.lastpaymentkey]) {
                        [sales_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"redgreenorange_icon.png"]];
                    }else{
                        [sales_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"greenred_icon.png"]];
                    }
                }else{
                    if (![outstandingsalespaymentobject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:outstandingsalespaymentobject.lastpaymentkey]) {
                        [sales_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"orangered_icon.png"]];
                    }else{
                        [sales_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"red_icon.png"]];
                    }
                }
            }else{
                if ([globalvariables.documentfolder.salesinvoicearray containsObject:outstandingsalespaymentobject.saleskey]) {
                    if (![outstandingsalespaymentobject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:outstandingsalespaymentobject.lastpaymentkey]) {
                        [sales_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"greenorange_icon.png"]];
                    }else{
                        [sales_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"green_icon.png"]];
                    }
                }else{
                    if (![outstandingsalespaymentobject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:outstandingsalespaymentobject.lastpaymentkey]) {
                        [sales_combinepaymentstatusimageview setImage:[UIImage imageNamed:@"orange_icon.png"]];
                    }else{
                        [sales_combinepaymentstatusimageview setImage:nil];
                    }
                }
            }
                    
        }else{
            sales_combinepaymentstatusimageview.hidden=YES;
        }
        
        if (indexPath.row %2==0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        
        return cell;
        
        
    }else if (tableView == OutstandingBankinTable) {
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"bankincell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        OutstandingBankinObject=[[OutstandingBankinRecord alloc]init];
        OutstandingBankinObject = [OutstandingBankinArray objectAtIndex:indexPath.row];
        
        // Configure the cell...
        cell.label1.text=[MyClass returndateformatwithdate:OutstandingBankinObject.bankindatetime];
        cell.label2.text=[formatter stringFromNumber:[NSNumber numberWithFloat:[OutstandingBankinObject.bankinamountcash floatValue]]];
        cell.label3.text=[formatter stringFromNumber:[NSNumber numberWithFloat:[OutstandingBankinObject.outstandingbankincash floatValue]]];
        cell.label6.text=[formatter stringFromNumber:[NSNumber numberWithFloat:[OutstandingBankinObject.bankinamountcheque floatValue]]];
        cell.label7.text=[formatter stringFromNumber:[NSNumber numberWithFloat:[OutstandingBankinObject.outstandingbankincheque floatValue]]];

        cell.label4.text=[MyClass returnstaffnamewithusername:OutstandingBankinObject.bankinperson firstorfullname:@"full"];
        cell.label5.text=OutstandingBankinObject.remarks;
        
        if (indexPath.row % 2==0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
        
    }else if (tableView==sortingtable){
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if (cell==nil){
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            sortingnamelabel = [[UILabel alloc]initWithFrame:CGRectMake(-25, 0, 168, 38)];
            sortingnamelabel.font=[UIFont systemFontOfSize:13];
            sortingnamelabel.textColor=[UIColor darkGrayColor];
            sortingnamelabel.adjustsFontSizeToFitWidth=YES;
            sortingnamelabel.minimumScaleFactor=0.7;
            sortingnamelabel.tag=201;
            [cell.contentView addSubview:sortingnamelabel];
            
            sortingorderbutton=[[UIButton alloc]initWithFrame:CGRectMake(110, 6.5, 25, 25)];
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
    }else if (tableView==DetailsPaymentTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];[df setDateFormat:@"dd-MMM-yyyy"];
        
        //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        if (indexPath.section==0) {
            if ([tablemode isEqualToString:@"EditPaymentRemarks"]) {
                if (indexPath.row==0) {
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                    detailspaymentLabel.textColor=[UIColor blackColor];
                    detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Paid Method"];
                    detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    paidmethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 7, 118, 21)];
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
                    
                    paiddateLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 7, 118, 21)];
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
                    
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:14];
                    detailspaymentLabel.textColor=[UIColor darkGrayColor];
                    detailspaymentLabel.textAlignment=NSTextAlignmentRight;
                    detailspaymentLabel.tag=806;
                    detailspaymentLabel.text=DetailsPaymentObject.paidamount;
                    [cell.contentView addSubview:detailspaymentLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }else if (indexPath.row==3) {
                    paymentremarksText=[[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(16, 0, 260, 95)];
                    paymentremarksText.font=[UIFont systemFontOfSize:15];
                    paymentremarksText.textColor=[UIColor darkGrayColor];
                    paymentremarksText.placeholder=[MyClass returntitlewithtitle:@"Payment Remarks"];
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
            }else if ([tablemode isEqualToString:@"View"] || [tablemode isEqualToString:@"Add"] || [tablemode isEqualToString:@"Edit"]){
                double totalpaid=0;
                
                if (indexPath.row==0) {
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                    detailspaymentLabel.textColor=[UIColor blackColor];
                    detailspaymentLabel.text=scpaymenttype.selectedSegmentIndex==0 ? [MyClass returntitlewithtitle:@"Total Fee"] : [MyClass returntitlewithtitle:@"Total Price"];
                    detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    paymenttotalfeeLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 7, 118, 21)];
                    paymenttotalfeeLabel.font=[UIFont systemFontOfSize:14];
                    paymenttotalfeeLabel.textColor=[UIColor darkGrayColor];
                    paymenttotalfeeLabel.textAlignment=NSTextAlignmentRight;
                    paymenttotalfeeLabel.text=!PaymentView.hidden?(scpaymenttype.selectedSegmentIndex==0? OutstandingPaymentObject.totalfee:outstandingsalespaymentobject.totalfee):[NSString stringWithFormat:@"%g", invoicelogitemobject.amount];
                    paymenttotalfeeLabel.tag=801;
                    [cell.contentView addSubview:paymenttotalfeeLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                    
                }else if (indexPath.row==1){
                    for (int k=0; k<DetailsPaymentArray.count; k++) {
                        DetailsPaymentObject=[DetailsPaymentArray objectAtIndex:k];
                        totalpaid+=[DetailsPaymentObject.paidamount doubleValue];
                    }
                    
                    
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                    detailspaymentLabel.textColor=[UIColor blackColor];
                    detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Total Paid"];
                    detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    paymenttotalpaidLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 7, 118, 21)];
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
                    
                    paymentoutstandingLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 7, 118, 21)];
                    paymentoutstandingLabel.font=[UIFont systemFontOfSize:14];
                    paymentoutstandingLabel.textColor=[UIColor darkGrayColor];
                    paymentoutstandingLabel.textAlignment=NSTextAlignmentRight;
                    paymentoutstandingLabel.text=[NSString stringWithFormat:@"%g",[paymenttotalfeeLabel.text doubleValue]-[paymenttotalpaidLabel.text doubleValue]];
                    paymentoutstandingLabel.tag=803;
                    [cell.contentView addSubview:paymentoutstandingLabel];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
                
            }else if ([tablemode isEqualToString:@"EditInvoiceRemarks"]){
                invoiceremarksText=[[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(16, 0, 288, 95)];
                invoiceremarksText.font=[UIFont systemFontOfSize:12];
                invoiceremarksText.textColor=[UIColor darkGrayColor];
                invoiceremarksText.placeholder=[MyClass returntitlewithtitle:@"Invoice Remarks"];
                invoiceremarksText.text=tmpinvoiceremarks;
                invoiceremarksText.delegate=self;
                //invoiceremarksText.tag=403;
                [cell.contentView addSubview:invoiceremarksText];
            }
            
        }else{
            if ([tablemode isEqualToString:@"View"] || [tablemode isEqualToString:@"Edit"]) {
                if (indexPath.section==1) {
                    
                    //cell.textLabel.font=[UIFont systemFontOfSize:10.0];
                    
                    DetailsPaymentObject=[DetailsPaymentArray objectAtIndex:indexPath.row];
                    
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:14];
                    detailspaymentLabel.textColor=[UIColor darkGrayColor];
                    detailspaymentLabel.text=[MyClass returndateformatwithdate:DetailsPaymentObject.paiddate];
                    //detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(130, 7, 118, 21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:12];
                    detailspaymentLabel.textColor=[UIColor grayColor];
                    detailspaymentLabel.textAlignment=NSTextAlignmentLeft;
                    detailspaymentLabel.text=[MyClass returntitlewithtitle:DetailsPaymentObject.paidmethod];
                    //detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 7, 118,21)];
                    //detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 7, [tablemode isEqualToString:@"View"]? 100: 118,21)];
                    detailspaymentLabel.font=[UIFont systemFontOfSize:14];
                    detailspaymentLabel.textColor=[UIColor darkGrayColor];
                    detailspaymentLabel.textAlignment=NSTextAlignmentRight;
                    detailspaymentLabel.text=DetailsPaymentObject.paidamount;
                    //detailspaymentLabel.tag=801;
                    [cell.contentView addSubview:detailspaymentLabel];
                    
                    //if (![DetailsPaymentObject.staffname isEqualToString:@""]) {
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 28, 200,15)];
                        detailspaymentLabel.font=[UIFont systemFontOfSize:10];
                        detailspaymentLabel.textColor=[UIColor darkGrayColor];
                        detailspaymentLabel.text=[DetailsPaymentObject.staffname isEqualToString:@""]?[NSString stringWithFormat:@"(Ref:%@)",[MyClass returnreceiptreference:DetailsPaymentObject.paymentkey receiptnumber:DetailsPaymentObject.receiptnumber]]:[NSString stringWithFormat:@"%@ (Ref:%@)",DetailsPaymentObject.staffname,[MyClass returnreceiptreference:DetailsPaymentObject.paymentkey receiptnumber:DetailsPaymentObject.receiptnumber]];
                        //detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:detailspaymentLabel];
                        
                    //}
                    
                    if (![DetailsPaymentObject.paymentremarks isEqualToString:@""]) {
                        
                        UILabel *paymentremarkstitlelabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 118, 20)];
                        paymentremarkstitlelabel.font=[UIFont systemFontOfSize:11];
                        paymentremarkstitlelabel.textColor=[UIColor blueColor];
                        paymentremarkstitlelabel.textAlignment=NSTextAlignmentLeft;
                        paymentremarkstitlelabel.text=[MyClass returntitlewithtitle:@"Remarks (Internal)"];
                        //detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:paymentremarkstitlelabel];
                        
                        
                        paymentremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 248, 100)];
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
                        paymentremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 248, 0)];
                    }
                    
                    if (![DetailsPaymentObject.receiptremarks isEqualToString:@""]) {
                        
                        UILabel *receiptremarkstitlelabel = [[UILabel alloc]initWithFrame:CGRectMake(20, paymentremarkslabel.frame.origin.y+paymentremarkslabel.frame.size.height+10, 200, 20)];
                        receiptremarkstitlelabel.font=[UIFont systemFontOfSize:11];
                        receiptremarkstitlelabel.textColor=[UIColor blueColor];
                        receiptremarkstitlelabel.textAlignment=NSTextAlignmentLeft;
                        receiptremarkstitlelabel.text=[MyClass returntitlewithtitle:@"Receipt Remarks (Print on receipt)"];
                        //detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:receiptremarkstitlelabel];
                        
                        
                        receiptremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 248, 100)];
                        receiptremarkslabel.font=[UIFont systemFontOfSize:12];
                        receiptremarkslabel.textColor=[UIColor darkGrayColor];
                        receiptremarkslabel.text=DetailsPaymentObject.receiptremarks;
                        receiptremarkslabel.numberOfLines=0;
                        
                        [receiptremarkslabel sizeToFit];
                        CGRect myFrame=receiptremarkslabel.frame;
                        myFrame=CGRectMake(myFrame.origin.x, paymentremarkslabel.frame.origin.y+paymentremarkslabel.frame.size.height+20+10, 248, myFrame.size.height);
                        receiptremarkslabel.frame=myFrame;
                        
                        [cell.contentView addSubview:receiptremarkslabel];
                    }
                    
                    
                    if ([tablemode isEqualToString:@"View"]) {
                        //cell.accessoryType=UITableViewCellAccessoryDetailButton;
                        
                        UIButton *sharebutton=[[UIButton alloc]initWithFrame:CGRectMake(260, [tableView rectForRowAtIndexPath:indexPath].size.height/2-12.5, 25, 25)];
                        [sharebutton addTarget:self action:@selector(paymentsharebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                        [sharebutton setImage:[UIImage imageNamed:@"sharebutton_blue.png"] forState:UIControlStateNormal];
                        //[sharebutton setTitle:@"Previous" forState:UIControlStateNormal];
                        //[cell.contentView addSubview:sharebutton];
                        
                        
                    }else{
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                    cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    
                    
                }else if (indexPath.section==2){
                    invoiceremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 248, 100)];
                    invoiceremarkslabel.font=[UIFont systemFontOfSize:12];
                    invoiceremarkslabel.textColor=[UIColor darkGrayColor];
                    invoiceremarkslabel.text=tmpinvoiceremarks;
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
                    
                    if ([tablemode isEqualToString:@"View"]) {
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else{
                        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    }
                }
            }else{// if ([DetailsPaymentTableMode isEqualToString:@"Add"]) {
                if (indexPath.section==1) {
                    if (indexPath.row==0) {
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                        detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                        detailspaymentLabel.textColor=[UIColor blackColor];
                        detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Paid Method"];
                        detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:detailspaymentLabel];
                        
                        paidmethodLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 7, 118, 21)];
                        paidmethodLabel.font=[UIFont systemFontOfSize:14];
                        paidmethodLabel.textColor=[UIColor darkGrayColor];
                        paidmethodLabel.textAlignment=NSTextAlignmentRight;
                        paidmethodLabel.text=[MyClass returntitlewithtitle:tmppaidmethod];
                        paidmethodLabel.tag=805;
                        [cell.contentView addSubview:paidmethodLabel];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                        
                    }else if (indexPath.row==1){
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
                            self.myPickerView=myPicker;
                            [datepickerview addSubview:myPicker];
                            
                            
                            [cell.contentView addSubview:datepickerview];
                        }else{
                            cell.hidden=YES;
                        }
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    }else if (indexPath.row==2){
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                        detailspaymentLabel.font=[UIFont systemFontOfSize:15];
                        detailspaymentLabel.textColor=[UIColor blackColor];
                        detailspaymentLabel.text=[MyClass returntitlewithtitle:@"Paid Date"];
                        detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:detailspaymentLabel];
                        
                        paiddateLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 7, 118, 21)];
                        paiddateLabel.font=[UIFont systemFontOfSize:14];
                        paiddateLabel.textColor=[UIColor darkGrayColor];
                        paiddateLabel.textAlignment=NSTextAlignmentRight;
                        paiddateLabel.text=[MyClass returndateformatwithdate:tmpPaidDate];
                        paiddateLabel.tag=805;
                        [cell.contentView addSubview:paiddateLabel];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        
                    }else if (indexPath.row==3){
                        if (showPaymentDatePicker==YES) {
                            
                            //set to next working day
                            
                            CalendarView *calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(0, 0, 300, 210) Theme:0 CanPickHoliday:YES MultipleSelection:NO ShowTodayButton:NO showclassdot:NO schedulerecord:nil  UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
                            [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:tmpPaidDate,nil] ScrollToDate:nil instructorselected:nil];
                            calendarview.delegate=self;
                            
                            /*
                            UIView *calendarview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 210)];
                            CalendarViewController *calendarviewcontroller=[[CalendarViewController alloc]init];
                            calendarviewcontroller.delegate=self;
                            calendarviewcontroller.selecteddatearray=[[NSMutableArray alloc]initWithObjects:tmpPaidDate,nil];
                            calendarviewcontroller.calendarwidth=300;
                            calendarviewcontroller.canpickholiday=YES;
                            calendarviewcontroller.view.frame=calendarview.bounds;
                            [paymentviewcontroller addChildViewController:calendarviewcontroller];
                            [calendarview addSubview:calendarviewcontroller.view];
                            [calendarviewcontroller didMoveToParentViewController:self];*/
                            [cell.contentView addSubview:calendarview];

                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                            
                            /*
                            [df setDateFormat:@"dd-MMM-yyyy"];
                            
                            presetRow=[MyClass returnDateOffsetWithDate:[MyClass convertToNSDateWithDate:tmpPaidDate DateFormat:@"dd-MMM-yyyy"]];
                            //presetRow=(int)[datePickerViewMenu indexOfObject:tmpPaidDate];
                            //presetRow=(int)[datePickerViewMenu indexOfObject:[df stringFromDate:[NSDate date]]];
                            
                            UIView *datepickerview=[[UIView alloc]initWithFrame:CGRectMake(18, 0, 282, 150)];
                            UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 270, 150)];
                            [myPicker setDataSource:self];
                            [myPicker setDelegate:self];
                            myPicker.tag=805;
                            
                            [myPicker selectRow:presetRow inComponent:0 animated:NO];
                            [myPicker setShowsSelectionIndicator:YES];
                            self.myPickerView=myPicker;
                            [datepickerview addSubview:myPicker];
                            
                            
                            [cell.contentView addSubview:datepickerview];*/
                            cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        }else{
                            cell.hidden=YES;
                        }
                        
                        
                        
                    }else if (indexPath.row==4){
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
                        
                        detailspaymentText = [[UITextField alloc]initWithFrame:CGRectMake(150, 7, 118, 21)];
                        detailspaymentText.font=[UIFont systemFontOfSize:14];
                        detailspaymentText.textColor=[UIColor darkGrayColor];
                        detailspaymentText.textAlignment=NSTextAlignmentRight;
                        detailspaymentText.keyboardType = UIKeyboardTypeDecimalPad;
                        detailspaymentText.placeholder=[MyClass returntitlewithtitle:@"Paid Amount"];
                        detailspaymentText.clearButtonMode = UITextFieldViewModeWhileEditing;
                        detailspaymentText.tag=806;
                        detailspaymentText.delegate=self;
                        detailspaymentText.text=tmppaidamount;
                        [detailspaymentText addTarget:self action:@selector(checkdetailspaymentvalue:)forControlEvents:UIControlEventEditingDidEnd];
                        
                        
                        
                        [cell.contentView addSubview:detailspaymentText];
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                        if (paymentoverride) {
                            [detailspaymentText becomeFirstResponder];
                        }

                        
                    }else if (indexPath.row==5) {
                        paymentremarksText=[[GCPlaceholderTextView alloc]initWithFrame:CGRectMake(16, 0, 260, 95)];
                        paymentremarksText.font=[UIFont systemFontOfSize:15];
                        paymentremarksText.textColor=[UIColor darkGrayColor];
                        paymentremarksText.placeholder=[MyClass returntitlewithtitle:@"Payment Remarks"];
                        paymentremarksText.text=tmppaymentremarks;
                        paymentremarksText.delegate=self;
                        paymentremarksText.tag=403;
                        [cell.contentView addSubview:paymentremarksText];
                        
                        
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        
                    }else if (indexPath.row==6) {
                        
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
                    
                }
                
                if (DetailsPaymentArray.count>0) {
                    if (indexPath.section==2) {
                        DetailsPaymentObject=[DetailsPaymentArray objectAtIndex:indexPath.row];
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, 118, 21)];
                        detailspaymentLabel.font=[UIFont systemFontOfSize:14];
                        detailspaymentLabel.textColor=[UIColor darkGrayColor];
                        detailspaymentLabel.text=[MyClass returndateformatwithdate:DetailsPaymentObject.paiddate];
                        detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:detailspaymentLabel];
                        
                        
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 7, 118, 21)];
                        detailspaymentLabel.font=[UIFont systemFontOfSize:12];
                        detailspaymentLabel.textColor=[UIColor grayColor];
                        detailspaymentLabel.textAlignment=NSTextAlignmentLeft;
                        detailspaymentLabel.text=[MyClass returntitlewithtitle:DetailsPaymentObject.paidmethod];
                        detailspaymentLabel.tag=801;
                        [cell.contentView addSubview:detailspaymentLabel];
                        
                        
                        detailspaymentLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 7, 118, 21)];
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
                        
                        //detailspaymentLabel.tag=801;
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
                            
                            
                            paymentremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 248, 100)];
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
                            paymentremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 40, 248, 0)];
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
                            
                            receiptremarkslabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 248, 100)];
                            receiptremarkslabel.font=[UIFont systemFontOfSize:12];
                            receiptremarkslabel.textColor=[UIColor darkGrayColor];
                            receiptremarkslabel.text=DetailsPaymentObject.receiptremarks;
                            receiptremarkslabel.numberOfLines=0;
                            
                            [receiptremarkslabel sizeToFit];
                            CGRect myFrame=receiptremarkslabel.frame;
                            myFrame=CGRectMake(myFrame.origin.x, paymentremarkslabel.frame.origin.y+paymentremarkslabel.frame.size.height+20+10, 248, myFrame.size.height);
                            receiptremarkslabel.frame=myFrame;
                            
                            [cell.contentView addSubview:receiptremarkslabel];
                        }
                    }
                }
            }
        }
        
        return cell;
        
    }else if (tableView==BankinInputTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];[df setDateFormat:@"dd-MMM-yyyy"];
        
        //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //newreceivedpaymentcash=[self retrievenewpaymentreceived];
        
        if (indexPath.section==0) {
            
            if (indexPath.row==0){
                bankininputLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 9, 118, 21)];
                bankininputLabel.font=[UIFont systemFontOfSize:15];
                bankininputLabel.textColor=[UIColor blackColor];
                bankininputLabel.text=[MyClass returntitlewithtitle:@"Cash"];
                bankininputLabel.tag=301;
                [cell.contentView addSubview:bankininputLabel];
                
                bankinamountcashinputText = [[UITextField alloc]initWithFrame:CGRectMake(150, 9, 118, 21)];
                bankinamountcashinputText.font=[UIFont systemFontOfSize:14];
                bankinamountcashinputText.textColor=[UIColor darkGrayColor];
                bankinamountcashinputText.textAlignment=NSTextAlignmentRight;
                bankinamountcashinputText.placeholder=[MyClass returntitlewithtitle:@"Amount"];
                bankinamountcashinputText.tag=306;
                bankinamountcashinputText.text=tmpbankincashamount;
                bankinamountcashinputText.keyboardType = UIKeyboardTypeNumberPad;
                [bankinamountcashinputText addTarget:self action:@selector(checkandupdatebankin:)forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:bankinamountcashinputText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else if (indexPath.row==1){
                bankininputLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 9, 118, 21)];
                bankininputLabel.font=[UIFont systemFontOfSize:15];
                bankininputLabel.textColor=[UIColor blackColor];
                bankininputLabel.text=[MyClass returntitlewithtitle:@"Cheque"];
                bankininputLabel.tag=301;
                [cell.contentView addSubview:bankininputLabel];
                
                bankinamountchequeinputText = [[UITextField alloc]initWithFrame:CGRectMake(150, 9, 118, 21)];
                bankinamountchequeinputText.font=[UIFont systemFontOfSize:14];
                bankinamountchequeinputText.textColor=[UIColor darkGrayColor];
                bankinamountchequeinputText.textAlignment=NSTextAlignmentRight;
                bankinamountchequeinputText.placeholder=[MyClass returntitlewithtitle:@"Amount"];
                bankinamountchequeinputText.tag=306;
                bankinamountchequeinputText.text=tmpbankinchequeamount;
                bankinamountchequeinputText.keyboardType = UIKeyboardTypeNumberPad;
                [bankinamountchequeinputText addTarget:self action:@selector(checkandupdatebankin:)forControlEvents:UIControlEventEditingDidEnd];
                [cell.contentView addSubview:bankinamountchequeinputText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }else{// if (indexPath.row==2){
                bankininputLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 9, 118, 21)];
                bankininputLabel.font=[UIFont systemFontOfSize:15];
                bankininputLabel.textColor=[UIColor blackColor];
                bankininputLabel.text=[MyClass returntitlewithtitle:@"Staff"];
                bankininputLabel.tag=301;
                [cell.contentView addSubview:bankininputLabel];
                
                bankinpersoninputText = [[UITextField alloc]initWithFrame:CGRectMake(150, 9, 118, 21)];
                bankinpersoninputText.font=[UIFont systemFontOfSize:14];
                bankinpersoninputText.textColor=[UIColor darkGrayColor];
                bankinpersoninputText.textAlignment=NSTextAlignmentRight;
                bankinpersoninputText.placeholder=[MyClass returntitlewithtitle:@"Staff"];
                bankinpersoninputText.text=tmpbankinperson;
                bankinpersoninputText.tag=306;
                [cell.contentView addSubview:bankinpersoninputText];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
            }
            
        }else{
            
            bankinremarksText = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, 250, 60)];
            bankinremarksText.font=[UIFont systemFontOfSize:15];
            bankinremarksText.textColor=[UIColor darkGrayColor];
            bankinremarksText.textAlignment=NSTextAlignmentLeft;
            bankinremarksText.text=@"";
            bankinremarksText.tag=408;
            bankinremarksText.delegate=self;
            bankinremarksText.text=tmpbankinremarks;
            [cell.contentView addSubview:bankinremarksText];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        return cell;
        
    }else if (tableView==InvoiceLogRecordTable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"logcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        InvoiceLogRecord *object=[filteredInvoiceLogArray objectAtIndex:indexPath.row];
        cell.label1.text=object.invoicenumber;
        cell.label2.text=[MyClass convertDateFormatWithDate:[MyClass convertToNSStringWithNSDate:object.createtime DateFormat:@"dd-MMM-yyyy HH:mm"] FromDateFormat:@"dd-MMM-yyyy HH:mm" ToDateFormat:@"dd-MMM-yyyy HH:mm" Translate:YES];
        cell.label3.text=[MyClass returnstaffnamewithusername:object.staff firstorfullname:@"full"];
        cell.label4.text=[formatter stringFromNumber:[NSNumber numberWithFloat:object.totalamount]];
        cell.label5.text=[formatter stringFromNumber:[NSNumber numberWithFloat:object.totalpaid]];

        if ([selectedinvoicelogkey isEqualToString:object.invoicelogkey]) {
            cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.22];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        return cell;
    }else if (tableView==InvoiceLogItemTable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"itemcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        InvoiceLogItem *object = [((InvoiceLogRecord *)[filteredInvoiceLogArray objectAtIndex:selectedinvoicerow]).itemarray objectAtIndex:indexPath.row];
        cell.label1.text = object.studentfullname;
        cell.label2.text = [MyClass returntitlewithtitle:object.type];
        cell.label3.text = object.itemdescription;
        cell.label4.text = [formatter stringFromNumber:[NSNumber numberWithFloat:object.amount]];
        cell.label5.text = [formatter stringFromNumber:[NSNumber numberWithFloat:object.paid]];
        

        cell.imageview1.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.imageview1.layer.borderWidth=0.5;
        Student *student=[MyClass returnstudentwithstudentkey:object.studentkey];
        [MyClass downloadImageWithImageview:cell.imageview2 gender:student.gender type:@"student" typekey:student.studentkey image:student.image async:YES];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
        singleTap.numberOfTapsRequired = 1;
        
        cell.imageview2.tag=indexPath.row;
        cell.imageview2.userInteractionEnabled = YES;
        [cell.imageview2 addGestureRecognizer:singleTap];
        
        if (selectInvoiceButton.tag==1) {
            cell.view1.hidden=NO;
            if ([object.type isEqualToString:@"Class"]) {
                if ([globalvariables.documentfolder.classpaymentarray containsObject:object.typekey]) {
                    if ([globalvariables.documentfolder.classinvoicearray containsObject:object.typekey]) {
                        if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"redgreenorange_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:[UIImage imageNamed:@"greenred_icon.png"]];
                        }
                    }else{
                        if (![object.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"orangered_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:[UIImage imageNamed:@"red_icon.png"]];
                        }
                    }
                }else{
                    if ([globalvariables.documentfolder.classinvoicearray containsObject:object.typekey]) {
                        if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"greenorange_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:[UIImage imageNamed:@"green_icon.png"]];
                        }
                    }else{
                        if (![object.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"orange_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:nil];
                        }
                    }
                }
            }else{
                if ([globalvariables.documentfolder.salespaymentarray containsObject:object.typekey]) {
                    if ([globalvariables.documentfolder.salesinvoicearray containsObject:object.typekey]) {
                        if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"redgreenorange_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:[UIImage imageNamed:@"greenred_icon.png"]];
                        }
                    }else{
                        if (![object.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"orangered_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:[UIImage imageNamed:@"red_icon.png"]];
                        }
                    }
                }else{
                    if ([globalvariables.documentfolder.salesinvoicearray containsObject:object.typekey]) {
                        if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"greenorange_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:[UIImage imageNamed:@"green_icon.png"]];
                        }
                    }else{
                        if (![object.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"orange_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:nil];
                        }
                    }
                }
            }
            

        }else{
            cell.view1.hidden=YES;
        }
        
        //alternative background color;
        //if (![OutstandingPaymentObject.enrollmentkey isEqualToString:selectedParentRow]) {
            if (indexPath.row %2==0) {
                cell.backgroundColor=[UIColor whiteColor];
            }else{
                cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
            }
        //}
        
        return cell;
    }else if (tableView==PaymentReceivedTable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"paymentcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        PaymentReceivedRecord *object=[PaymentReceivedRecordsArray objectAtIndex:indexPath.row];
        
        cell.label1.text=[MyClass convertDateFormatWithDate:object.paiddate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
        
        [[cell.stackview1 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
        CGFloat totalreceived=0;
        
        NSArray *sortedKeys = [[object.paiddict allKeys] sortedArrayUsingSelector: @selector(compare:)];
        for ( NSString *key in sortedKeys) {
            
            UIStackView *horStackView=[[UIStackView alloc]init];
            horStackView.axis=UILayoutConstraintAxisHorizontal;
            //horStackView.alignment=NSLayoutAttributeCenterY;
            horStackView.distribution=UIStackViewDistributionFill;
            //horStackView.spacing=10.0f;
            [cell.stackview1 addArrangedSubview:horStackView];
            //NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:horStackView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:cell.stackview1 attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0.f];
            //[cell.stackview1 addConstraint:trailing];
            
            UILabel *methodtextfield=[[UILabel alloc]init];
            methodtextfield.font=[UIFont systemFontOfSize:10];
            methodtextfield.textColor=[UIColor grayColor];
            [methodtextfield setBackgroundColor:[UIColor clearColor]];
            methodtextfield.textAlignment=NSTextAlignmentLeft;
            methodtextfield.text=[MyClass returntitlewithtitle:key];
            [methodtextfield setContentCompressionResistancePriority:250 forAxis:UILayoutConstraintAxisHorizontal];
            [horStackView addArrangedSubview:methodtextfield];
            
            UILabel *amounttextfield=[[UILabel alloc]init];
            amounttextfield.font=[UIFont systemFontOfSize:11];
            [amounttextfield setBackgroundColor:[UIColor clearColor]];
            amounttextfield.textAlignment=NSTextAlignmentRight;
            NSString *total=[object.paiddict valueForKey:key];
            amounttextfield.text=[formatter stringFromNumber:[NSNumber numberWithFloat:[total floatValue]]];
            [amounttextfield setContentCompressionResistancePriority:750 forAxis:UILayoutConstraintAxisHorizontal];
            [horStackView addArrangedSubview:amounttextfield];
            totalreceived +=[total floatValue];
        }

        cell.label2.text=[formatter stringFromNumber:[NSNumber numberWithFloat:totalreceived]];

        if ([selectedpaiddate isEqualToString:object.paiddate]) {
            cell.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.22];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        return cell;
    }else if (tableView==PaymentReceivedDetailsTable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"itemcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        PaymentReceivedDetailsRecord *object = [((PaymentReceivedRecord *)[PaymentReceivedRecordsArray objectAtIndex:selectedpaiddaterow]).paymentrecords objectAtIndex:indexPath.row];
        Student *student=[MyClass returnstudentwithstudentkey:object.studentkey];
        [MyClass downloadImageWithImageview:cell.imageview1 gender:student.gender type:@"student" typekey:student.studentkey image:student.image async:YES];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
        singleTap.numberOfTapsRequired = 1;
        
        cell.imageview1.tag=indexPath.row;
        cell.imageview1.userInteractionEnabled = YES;
        [cell.imageview1 addGestureRecognizer:singleTap];
        cell.label1.text=object.studentfullname;
        cell.label2.text=[MyClass returntitlewithtitle:object.paymenttype];
        cell.label6.text=[MyClass returntitlewithtitle:object.paidmethod];
        cell.label4.text=object.itemdescription;
        cell.label5.text=object.staffname;
        cell.label3.text=[formatter stringFromNumber:[NSNumber numberWithFloat:[object.paidamount floatValue]]];
        cell.label7.text=object.paymentremarks;
        cell.label8.text=object.receiptremarks;
        
        
        
        /*
        InvoiceLogItem *object = [((InvoiceLogRecord *)[filteredInvoiceLogArray objectAtIndex:selectedinvoicerow]).itemarray objectAtIndex:indexPath.row];
        cell.label1.text = object.studentfullname;
        cell.label2.text = [MyClass returntitlewithtitle:object.type];
        cell.label3.text = object.itemdescription;
        cell.label4.text = [formatter stringFromNumber:[NSNumber numberWithFloat:object.amount]];
        cell.label5.text = [formatter stringFromNumber:[NSNumber numberWithFloat:object.paid]];
        

        cell.imageview1.layer.borderColor=[UIColor lightGrayColor].CGColor;
        cell.imageview1.layer.borderWidth=0.5;
        Student *student=[MyClass returnstudentwithstudentkey:object.studentkey];
        [MyClass downloadImageWithImageview:cell.imageview2 gender:student.gender type:@"student" typekey:student.studentkey image:student.image async:YES];
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageDetected:)];
        singleTap.numberOfTapsRequired = 1;
        
        cell.imageview2.tag=indexPath.row;
        cell.imageview2.userInteractionEnabled = YES;
        [cell.imageview2 addGestureRecognizer:singleTap];
        
        if (selectInvoiceButton.tag==1) {
            cell.view1.hidden=NO;
            if ([object.type isEqualToString:@"Class"]) {
                if ([globalvariables.documentfolder.classpaymentarray containsObject:object.typekey]) {
                    if ([globalvariables.documentfolder.classinvoicearray containsObject:object.typekey]) {
                        if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"redgreenorange_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:[UIImage imageNamed:@"greenred_icon.png"]];
                        }
                    }else{
                        if (![object.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"orangered_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:[UIImage imageNamed:@"red_icon.png"]];
                        }
                    }
                }else{
                    if ([globalvariables.documentfolder.classinvoicearray containsObject:object.typekey]) {
                        if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"greenorange_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:[UIImage imageNamed:@"green_icon.png"]];
                        }
                    }else{
                        if (![object.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"orange_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:nil];
                        }
                    }
                }
            }else{
                if ([globalvariables.documentfolder.salespaymentarray containsObject:object.typekey]) {
                    if ([globalvariables.documentfolder.salesinvoicearray containsObject:object.typekey]) {
                        if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"redgreenorange_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:[UIImage imageNamed:@"greenred_icon.png"]];
                        }
                    }else{
                        if (![object.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"orangered_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:[UIImage imageNamed:@"red_icon.png"]];
                        }
                    }
                }else{
                    if ([globalvariables.documentfolder.salesinvoicearray containsObject:object.typekey]) {
                        if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"greenorange_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:[UIImage imageNamed:@"green_icon.png"]];
                        }
                    }else{
                        if (![object.lastpaymentkey isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:object.lastpaymentkey]) {
                            [cell.imageview1 setImage:[UIImage imageNamed:@"orange_icon.png"]];
                        }else{
                            [cell.imageview1 setImage:nil];
                        }
                    }
                }
            }
            

        }else{
            cell.view1.hidden=YES;
        }
        */
        //alternative background color;

        if (indexPath.row %2==0) {
            cell.backgroundColor=[UIColor whiteColor];
        }else{
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }
        
        return cell;
    }else{ //share table
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        //if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
            
        }else if (indexPath.row==3){
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
        
        return cell;
    }
}



-(void)tapImageDetected:(UITapGestureRecognizer *)gr{
    
    UIImageView *theTappedImageView=(UIImageView *)gr.view;
    
    //UITableViewCell *cell;
    //CGRect rect;
    
    if(![MyClass showMenuItemwithObject:@"Student Profile"]){
        return;
    }
    
    if(!PaymentReceivedView.hidden){
        PaymentReceivedDetailsRecord *object=[((PaymentReceivedRecord *)[PaymentReceivedRecordsArray objectAtIndex:selectedpaiddaterow]).paymentrecords objectAtIndex:theTappedImageView.tag];
        
        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:object.studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedSaleskey=[object.paymenttype isEqualToString:@"Sales"]?object.paymenttypekey:nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=[object.paymenttype isEqualToString:@"Class"]?object.paymenttypekey:nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedClasskey=nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedDTkey=nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(self.view.frame.size.width-240, self.view.frame.size.height);
            
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).TypeSelectionButton.hidden=NO;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).typeselectionarrow.hidden=NO;
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DaySelectionButton.frame=CGRectMake(self.view.frame.size.width-501, 2, 129, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_enrollment.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
//            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).scactiveoption_class.frame=CGRectMake(self.view.frame.size.width-204, 2, 187, 29);
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
    }else if(!InvoiceView.hidden){

        InvoiceLogItem *object=[((InvoiceLogRecord *)[filteredInvoiceLogArray objectAtIndex:selectedinvoicerow]).itemarray objectAtIndex:theTappedImageView.tag];
        
        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:object.studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedSaleskey=[object.type isEqualToString:@"Sales"]?object.typekey:nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=[object.type isEqualToString:@"Class"]?object.typekey:nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedClasskey=nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedDTkey=nil;
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
        
    }else if (scpaymenttype.selectedSegmentIndex==0) {
        CGPoint point = [theTappedImageView.superview convertPoint:CGPointZero toView:OutstandingClassPaymentTable];
        NSIndexPath *indexpath =[OutstandingClassPaymentTable indexPathForRowAtPoint:point];
        if (!indexpath) {
            indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
        }
        OutstandingPaymentObject=[filteredOutstandingClassPaymentArray objectAtIndex:indexpath.row];

        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:OutstandingPaymentObject.studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil  leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedSaleskey=nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=OutstandingPaymentObject.enrollmentkey;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedClasskey=nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedDTkey=nil;
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
        CGPoint point = [theTappedImageView.superview convertPoint:CGPointZero toView:OutstandingSalesPaymentTable];
        NSIndexPath *indexpath =[OutstandingSalesPaymentTable indexPathForRowAtPoint:point];
        if (!indexpath) {
            indexpath=[NSIndexPath indexPathForRow:0 inSection:0];
        }
        outstandingsalespaymentobject=[filteredOutstandingSalesPaymentArray objectAtIndex:indexpath.row];
        //cell = [OutstandingSalesPaymentTable cellForRowAtIndexPath:indexpath];
        //rect=CGRectMake(cell.bounds.origin.x+140, cell.bounds.origin.y+5, 50, 30);
        
        
        
        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
            //studentpopover.delegate=self;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:outstandingsalespaymentobject.studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedSaleskey=outstandingsalespaymentobject.saleskey;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedClasskey=nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedDTkey=nil;

            
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

-(void) showAddToDocumentFolderAnimationWithTableview:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    NSArray * windows = [[UIApplication sharedApplication] windows];
    UIWindow* win0 = [windows objectAtIndex:0];
    
    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect button_CGRect = [tableView convertRect:rectInTableView toView:win0];
    CGRect dest_CGRect = [documentfoldercountlabel.superview convertRect:documentfoldercountlabel.frame toView:win0];
    
    UIImageView *flyingview=[[UIImageView alloc]initWithFrame:button_CGRect];
    [flyingview setImage:[UIImage imageNamed:@"gray_background.png"]];
    flyingview.layer.opacity=0.4;
    flyingview.layer.cornerRadius=5;
    flyingview.layer.masksToBounds=YES;
    
    [win0 addSubview:flyingview];
    
    [UIView animateWithDuration:0.8 animations:^{
        flyingview.frame=dest_CGRect;
    } completion:^(BOOL finished){ [flyingview removeFromSuperview]; }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==OutstandingClassPaymentTable) {
        
        OutstandingPaymentObject=[filteredOutstandingClassPaymentArray objectAtIndex:indexPath.row];
        
        if (isSelectCombinePayment) {
            
            BOOL addedtofolder=FALSE;
            
            if ([globalvariables.documentfolder.classpaymentarray containsObject:OutstandingPaymentObject.enrollmentkey] || [globalvariables.documentfolder.classinvoicearray containsObject:OutstandingPaymentObject.enrollmentkey] || [globalvariables.documentfolder.classreceiptarray containsObject:OutstandingPaymentObject.lastpaymentkey]) {
                //remove
                if ([globalvariables.documentfolder.classpaymentarray containsObject:OutstandingPaymentObject.enrollmentkey]) {
                    [globalvariables.documentfolder.classpaymentarray removeObject:OutstandingPaymentObject.enrollmentkey];
                }
                
                if ([globalvariables.documentfolder.classinvoicearray containsObject:OutstandingPaymentObject.enrollmentkey]) {
                    [globalvariables.documentfolder.classinvoicearray removeObject:OutstandingPaymentObject.enrollmentkey];
                }
                
                if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""]) {
                    if ([globalvariables.documentfolder.classreceiptarray containsObject:OutstandingPaymentObject.lastpaymentkey]) {
                        [globalvariables.documentfolder.classreceiptarray removeObject:OutstandingPaymentObject.lastpaymentkey];
                    }
                }
                
                if ([globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:OutstandingPaymentObject.enrollmentkey]) {
                    [globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys removeObject:OutstandingPaymentObject.enrollmentkey];
                }
                
                if ([globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:OutstandingPaymentObject.enrollmentkey]) {
                    [globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys removeObject:OutstandingPaymentObject.enrollmentkey];
                }
                
                if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""]) {
                    if ([globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:OutstandingPaymentObject.enrollmentkey]) {
                        [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys removeObject:OutstandingPaymentObject.enrollmentkey];
                    }
                }
                
                
            }else{
                //add
                addedtofolder=TRUE;
                if(![globalvariables.documentfolder.classpaymentarray containsObject:OutstandingPaymentObject.enrollmentkey]){
                    [globalvariables.documentfolder.classpaymentarray addObject:OutstandingPaymentObject.enrollmentkey];
                }
                
                if(![globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:OutstandingPaymentObject.enrollmentkey]){
                    [globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys addObject:OutstandingPaymentObject.enrollmentkey];
                }
                
                if (![globalvariables.documentfolder.classinvoicearray containsObject:OutstandingPaymentObject.enrollmentkey]) {
                    [globalvariables.documentfolder.classinvoicearray addObject:OutstandingPaymentObject.enrollmentkey];
                }
                
                if (![globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:OutstandingPaymentObject.enrollmentkey]) {
                    [globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys addObject:OutstandingPaymentObject.enrollmentkey];
                }
                
                if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""]) {
                    if (![globalvariables.documentfolder.classreceiptarray containsObject:OutstandingPaymentObject.enrollmentkey]) {
                        [globalvariables.documentfolder.classreceiptarray addObject:OutstandingPaymentObject.enrollmentkey];
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:OutstandingPaymentObject.enrollmentkey]) {
                        [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys addObject:OutstandingPaymentObject.enrollmentkey];
                    }
                }
            }
            
            if (addedtofolder) {
                [self showAddToDocumentFolderAnimationWithTableview:tableView IndexPath:indexPath];
            }
            [self refreshdocumentfoldercount];

            
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            tablemode=@"View";
            
            
            //if ([OutstandingPaymentObject.enrollmentkey rangeOfString:@","].location==NSNotFound) {
                PopoverStudent=[MyClass retrieveStudent:OutstandingPaymentObject.studentkey];
                if (!PopoverStudent) {
                    return;
                }
                
                if (![self retrieveEnrollmentWithEnrollmentKey:OutstandingPaymentObject.enrollmentkey]) {
                    return;
                }
                
                if (![self retrieveDetailsPaymentWithPaymentType:@"Class" paymenttypekey:OutstandingPaymentObject.enrollmentkey]) {
                    return;
                }
                
                [self popupdetailspaymenttablewithtablemode:@"View" tableview:tableView indexpath:indexPath];
                tmpinvoiceremarks=PopoverEnrollment.invoiceremarks;
        }

        
    }else if (tableView==OutstandingSalesPaymentTable) {
        
        outstandingsalespaymentobject=[filteredOutstandingSalesPaymentArray objectAtIndex:indexPath.row];
        
        if (isSelectCombinePayment) {
            BOOL addedtofolder=FALSE;
            
            
            if ([globalvariables.documentfolder.salespaymentarray containsObject:outstandingsalespaymentobject.saleskey] || [globalvariables.documentfolder.salesinvoicearray containsObject:outstandingsalespaymentobject.saleskey] || [globalvariables.documentfolder.salesreceiptarray containsObject:outstandingsalespaymentobject.lastpaymentkey]) {
                //remove
                if ([globalvariables.documentfolder.salespaymentarray containsObject:outstandingsalespaymentobject.saleskey]) {
                    [globalvariables.documentfolder.salespaymentarray removeObject:outstandingsalespaymentobject.saleskey];
                }
                
                if ([globalvariables.documentfolder.salesinvoicearray containsObject:outstandingsalespaymentobject.saleskey]) {
                    [globalvariables.documentfolder.salesinvoicearray removeObject:outstandingsalespaymentobject.saleskey];
                }
                
                if (![outstandingsalespaymentobject.lastpaymentkey isEqualToString:@""]) {
                    if ([globalvariables.documentfolder.salesreceiptarray containsObject:outstandingsalespaymentobject.lastpaymentkey]) {
                        [globalvariables.documentfolder.salesreceiptarray removeObject:outstandingsalespaymentobject.lastpaymentkey];
                    }
                }
                
                if ([globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:outstandingsalespaymentobject.saleskey]) {
                    [globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys removeObject:outstandingsalespaymentobject.saleskey];
                }
                
                if ([globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:outstandingsalespaymentobject.saleskey]) {
                    [globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys removeObject:outstandingsalespaymentobject.saleskey];
                }
                
                if (![outstandingsalespaymentobject.lastpaymentkey isEqualToString:@""]) {
                    if ([globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:outstandingsalespaymentobject.saleskey]) {
                        [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys removeObject:outstandingsalespaymentobject.saleskey];
                    }
                }
            }else{
                //add
                addedtofolder=TRUE;
                if (![globalvariables.documentfolder.salespaymentarray containsObject:outstandingsalespaymentobject.saleskey]) {
                    [globalvariables.documentfolder.salespaymentarray addObject:outstandingsalespaymentobject.saleskey];
                }
                
                if (![globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:outstandingsalespaymentobject.saleskey]) {
                    [globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys addObject:outstandingsalespaymentobject.saleskey];
                }
                
                if (![globalvariables.documentfolder.salesinvoicearray containsObject:outstandingsalespaymentobject.saleskey]) {
                    [globalvariables.documentfolder.salesinvoicearray addObject:outstandingsalespaymentobject.saleskey];
                }
                
                if (![globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:outstandingsalespaymentobject.saleskey]) {
                    [globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys addObject:outstandingsalespaymentobject.saleskey];
                }
                
                if (![outstandingsalespaymentobject.lastpaymentkey isEqualToString:@""]) {
                    if (![globalvariables.documentfolder.salesreceiptarray containsObject:outstandingsalespaymentobject.saleskey]) {
                        [globalvariables.documentfolder.salesreceiptarray addObject:outstandingsalespaymentobject.saleskey];
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:outstandingsalespaymentobject.saleskey]) {
                        [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys addObject:outstandingsalespaymentobject.saleskey];
                    }
                }
            }
            
            if (addedtofolder) {
                [self showAddToDocumentFolderAnimationWithTableview:tableView IndexPath:indexPath];
            }
            [self refreshdocumentfoldercount];
            
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            tablemode=@"View";
            
            
            PopoverStudent=[MyClass retrieveStudent:outstandingsalespaymentobject.studentkey];
            if (!PopoverStudent) {
                return;
            }
            
            if (![self retrieveSalesRecordwithSaleskey:outstandingsalespaymentobject.saleskey]) {
                return;
            }
            
            if (![self retrieveDetailsPaymentWithPaymentType:@"Sales" paymenttypekey:outstandingsalespaymentobject.saleskey]) {
                return;
            }
            
            [self popupdetailspaymenttablewithtablemode:@"View" tableview:tableView indexpath:indexPath];
            tmpinvoiceremarks=SalesObject.invoiceremarks;
        }

    }else if (tableView==InvoiceLogRecordTable){
        InvoiceLogRecord *object=[filteredInvoiceLogArray objectAtIndex:indexPath.row];
        selectedinvoicelogkey=object.invoicelogkey;
        selectedinvoicerow=indexPath.row;
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        [InvoiceLogRecordTable reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [InvoiceLogItemTable reloadData];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
        
    }else if (tableView==PaymentReceivedTable){
        PaymentReceivedRecord *object=[PaymentReceivedRecordsArray objectAtIndex:indexPath.row];
        selectedpaiddate=object.paiddate;
        selectedpaiddaterow=indexPath.row;
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        [PaymentReceivedTable reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [PaymentReceivedDetailsTable reloadData];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
        
    }else if (tableView==PaymentReceivedDetailsTable){
        PaymentReceivedDetailsRecord *object=[((PaymentReceivedRecord *)[PaymentReceivedRecordsArray objectAtIndex:selectedpaiddaterow]).paymentrecords objectAtIndex:indexPath.row];

        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:object.studentkey studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];
            
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedSaleskey=[object.paymenttype isEqualToString:@"Sales"]?object.paymenttypekey:nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedEnrollmentkey=[object.paymenttype isEqualToString:@"Class"]?object.paymenttypekey:nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedClasskey=nil;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).selectedDTkey=nil;
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
        
    }else if (tableView==InvoiceLogItemTable){
        InvoiceLogItem *object=[((InvoiceLogRecord *)[filteredInvoiceLogArray objectAtIndex:selectedinvoicerow]).itemarray objectAtIndex:indexPath.row];
        invoicelogitemobject=object;
        
        if (selectInvoiceButton.tag) {
            BOOL addedtofolder=FALSE;
            
            if([object.type isEqualToString:@"Class"]){
                if ([globalvariables.documentfolder.classpaymentarray containsObject:object.typekey] || [globalvariables.documentfolder.classinvoicearray containsObject:object.typekey] || [globalvariables.documentfolder.classreceiptarray containsObject:object.lastpaymentkey]) {
                    //remove
                    if ([globalvariables.documentfolder.classpaymentarray containsObject:object.typekey]) {
                        [globalvariables.documentfolder.classpaymentarray removeObject:object.typekey];
                    }
                    
                    if ([globalvariables.documentfolder.classinvoicearray containsObject:object.typekey]) {
                        [globalvariables.documentfolder.classinvoicearray removeObject:object.typekey];
                    }
                    
                    if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""]) {
                        if ([globalvariables.documentfolder.classreceiptarray containsObject:object.typekey]) {
                            [globalvariables.documentfolder.classreceiptarray removeObject:object.typekey];
                        }
                    }
                    
                    if ([globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:object.typekey]) {
                        [globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys removeObject:object.typekey];
                    }
                    
                    if ([globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:object.typekey]) {
                        [globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys removeObject:object.typekey];
                    }
                    
                    if (![object.lastpaymentkey isEqualToString:@""]) {
                        if ([globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:object.typekey]) {
                            [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys removeObject:object.typekey];
                        }
                    }
                    
                    
                }else{
                    //add
                    addedtofolder=TRUE;
                    if (![globalvariables.documentfolder.classpaymentarray containsObject:object.typekey]) {
                        [globalvariables.documentfolder.classpaymentarray addObject:object.typekey];
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:object.typekey]) {
                        [globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys addObject:object.typekey];
                    }
                    
                    if (![globalvariables.documentfolder.classinvoicearray containsObject:object.typekey]) {
                        [globalvariables.documentfolder.classinvoicearray addObject:object.typekey];
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:object.typekey]) {
                        [globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys addObject:object.typekey];
                    }
                    
                    if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""]) {
                        if (![globalvariables.documentfolder.classreceiptarray containsObject:object.typekey]) {
                            [globalvariables.documentfolder.classreceiptarray addObject:object.typekey];
                        }
                        if (![globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:object.typekey]) {
                            [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys addObject:object.typekey];
                        }
                    }
                }
            }else{
                if ([globalvariables.documentfolder.salespaymentarray containsObject:object.typekey] || [globalvariables.documentfolder.salesinvoicearray containsObject:object.typekey] || [globalvariables.documentfolder.salesreceiptarray containsObject:object.lastpaymentkey]) {
                    //remove
                    if ([globalvariables.documentfolder.salespaymentarray containsObject:object.typekey]) {
                        [globalvariables.documentfolder.salespaymentarray removeObject:object.typekey];
                    }
                    
                    if ([globalvariables.documentfolder.salesinvoicearray containsObject:object.typekey]) {
                        [globalvariables.documentfolder.salesinvoicearray removeObject:object.typekey];
                    }
                    
                    if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""]) {
                        if ([globalvariables.documentfolder.salesreceiptarray containsObject:object.typekey]) {
                            [globalvariables.documentfolder.salesreceiptarray removeObject:object.typekey];
                        }
                    }
                    
                    if ([globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:object.typekey]) {
                        [globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys removeObject:object.typekey];
                    }
                    
                    if ([globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:object.typekey]) {
                        [globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys removeObject:object.typekey];
                    }
                    
                    if (![object.lastpaymentkey isEqualToString:@""]) {
                        if ([globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:object.typekey]) {
                            [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys removeObject:object.typekey];
                        }
                    }
                    
                    
                }else{
                    //add
                    addedtofolder=TRUE;
                    if (![globalvariables.documentfolder.salespaymentarray containsObject:object.typekey]) {
                        [globalvariables.documentfolder.salespaymentarray addObject:object.typekey];
                    }
                    if (![globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:object.typekey]) {
                        [globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys addObject:object.typekey];
                    }
                    if (![globalvariables.documentfolder.salesinvoicearray containsObject:object.typekey]) {
                        [globalvariables.documentfolder.salesinvoicearray addObject:object.typekey];
                    }
                    if (![globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:object.typekey]) {
                        [globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys addObject:object.typekey];
                    }
                    
                    if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""]) {
                        if (![globalvariables.documentfolder.salesreceiptarray containsObject:object.typekey]) {
                            [globalvariables.documentfolder.salesreceiptarray addObject:object.typekey];
                        }
                        if (![globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:object.typekey]) {
                            [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys addObject:object.typekey];
                        }
                    }
                }
            }
            
            
            if (addedtofolder) {
                [self showAddToDocumentFolderAnimationWithTableview:tableView IndexPath:indexPath];
            }
            
            [self refreshdocumentfoldercount];
            
            
            
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            if([object.type isEqualToString:@"Class"]){
                tablemode=@"View";
                PopoverStudent=[MyClass retrieveStudent:object.studentkey];
                if (!PopoverStudent) {
                    return;
                }
                
                if (![self retrieveEnrollmentWithEnrollmentKey:object.typekey]) {
                    return;
                }
                
                if (![self retrieveDetailsPaymentWithPaymentType:@"Class" paymenttypekey:object.typekey]) {
                    return;
                }
                
                [self popupdetailspaymenttablewithtablemode:@"View" tableview:tableView indexpath:indexPath];
                tmpinvoiceremarks=PopoverEnrollment.invoiceremarks;
            }else{
                tablemode=@"View";
                PopoverStudent=[MyClass retrieveStudent:object.studentkey];
                if (!PopoverStudent) {
                    return;
                }
                
                if (![self retrieveSalesRecordwithSaleskey:object.typekey]) {
                    return;
                }
                
                if (![self retrieveDetailsPaymentWithPaymentType:@"Sales" paymenttypekey:object.typekey]) {
                    return;
                }
                
                [self popupdetailspaymenttablewithtablemode:@"View" tableview:tableView indexpath:indexPath];
                tmpinvoiceremarks=SalesObject.invoiceremarks;
            }
        }
    }else if (tableView==DetailsPaymentTable){
        if ([tablemode isEqualToString:@"Add"]) {
            if(indexPath.section==1 && indexPath.row==0){
                
                selectedItem=@"PaidMethod";
                
                //tmpPaidDate=paiddateLabel.text;
                if (showPaidMethodPicker==YES) {
                    showPaidMethodPicker=NO;
                }else{
                    showPaidMethodPicker=YES;
                    showPaymentDatePicker=NO;
                }
                
                [self storetmpfield];
                
                [DetailsPaymentTable reloadData];

                
            }else if(indexPath.section==1 && indexPath.row==2){
                
                selectedItem=@"DetailsPayment";
                
                //tmpPaidDate=paiddateLabel.text;
                if (showPaymentDatePicker==YES) {
                    showPaymentDatePicker=NO;
                }else{
                    showPaidMethodPicker=NO;
                    showPaymentDatePicker=YES;
                }
                
                [self storetmpfield];
                
                [DetailsPaymentTable reloadData];

            }
        }else{
            if (indexPath.section==1) {
                if (![tablemode isEqualToString:@"View"]) {

                    tablemode=@"EditPaymentRemarks";
                    DetailsPaymentObject=[DetailsPaymentArray objectAtIndex:indexPath.row];
                    DetailsPaymentObjectIndex=indexPath.row;
                    tmppaymentremarks=DetailsPaymentObject.paymentremarks;
                    tmpreceiptremarks=DetailsPaymentObject.receiptremarks;
                    [DetailsPaymentTable reloadData];
                    
                    [self createPaymentToolBarwithMode:@"EditPaymentRemarks"];

                }
            }else if (indexPath.section==2){
                if (![tablemode isEqualToString:@"View"]) {
                    tablemode=@"EditInvoiceRemarks";
                    tmpinvoiceremarks=invoiceremarkslabel.text;
                    
                    [DetailsPaymentTable reloadData];
                    
                    [self createPaymentToolBarwithMode:@"EditInvoiceRemarks"];

                }
            }
        }
    }else if (tableView==sharetable){
        if (scpaymenttype.selectedSegmentIndex==0) { //class
            if (indexPath.row==0){
                [aishareprint startAnimating];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                        NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Receipt"];
                        if (classday) {
                            ClassReceiptRecord *classreceiptrecord=[[ClassReceiptRecord alloc]initClassReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.oneoffdiscount floatValue]+[PopoverEnrollment.recursivediscount floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain paymentkey:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paiddate paid:PopoverEnrollment.paid paidmethod:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment paymentremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentremarks subjectname:nil];
                            
                            
                            NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] SalesReceiptArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                            if (pdfdata) {
                                [self printPDF:pdfdata];
                            }
                        }
                    }else{
                        NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Invoice"];
                        if (classday) {
                            ClassInvoiceRecord *classinvoicerecord=[[ClassInvoiceRecord alloc]initClassInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.oneoffdiscount floatValue]+[PopoverEnrollment.recursivediscount floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain outstandingamount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.totalfee floatValue]-[PopoverEnrollment.paid floatValue]] invoiceremarks:PopoverEnrollment.invoiceremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment subjectname:nil];
                            
                            NSData *pdfdata=[MyClass generateInvoiceWithClassInvoiceArray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] SalesInvoiceArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                            if (pdfdata) {
                                [self printPDF:pdfdata];
                            }
                        }
                    }
                    [aishareprint stopAnimating];
                });

            }else if (indexPath.row==1) {
                [aishareemail startAnimating];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                        NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Receipt"];
                        if (classday) {
                            ClassReceiptRecord *classreceiptrecord=[[ClassReceiptRecord alloc]initClassReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.oneoffdiscount floatValue]+[PopoverEnrollment.recursivediscount floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain paymentkey:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paiddate paid:PopoverEnrollment.paid paidmethod:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment paymentremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentremarks subjectname:nil];
                            
                            
                            NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] SalesReceiptArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                            if (pdfdata) {
                                [self emailPDF:pdfdata pdftype:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] salesreceiptarray:nil]];
                            }
                        }
                    }else{
                        NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Invoice"];
                        if (classday) {
                            ClassInvoiceRecord *classinvoicerecord=[[ClassInvoiceRecord alloc]initClassInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.oneoffdiscount floatValue]+[PopoverEnrollment.recursivediscount floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain outstandingamount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.totalfee floatValue]-[PopoverEnrollment.paid floatValue]] invoiceremarks:PopoverEnrollment.invoiceremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment subjectname:nil];
                            
                            NSData *pdfdata=[MyClass generateInvoiceWithClassInvoiceArray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] SalesInvoiceArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                            if (pdfdata) {
                                [self emailPDF:pdfdata pdftype:@"Invoice" filename:[MyClass returninvoicenumberwithclassinvoicearray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] salesinvoicearray:nil updateinvoicelog:NO]];
                            }
                        }
                    }
                    [aishareemail stopAnimating];
                });
            }else if (indexPath.row==3){
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
                    if (![globalvariables.documentfolder.classreceiptarray containsObject:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey]) {
                        [globalvariables.documentfolder.classreceiptarray addObject:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey];
                        [self refreshdocumentfoldercount];
                    }else{
                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"This receipt has already been added to the folder"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [erroralert addAction:OKAction];
                        [self presentViewController:erroralert animated:YES completion:nil];
                    }
                }else{
                    if (![globalvariables.documentfolder.classinvoicearray containsObject:PopoverEnrollment.enrollmentkey]) {
                        [globalvariables.documentfolder.classinvoicearray addObject:PopoverEnrollment.enrollmentkey];
                        [self refreshdocumentfoldercount];
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
        }else{ // sales
            if (indexPath.row==0) {
                [aishareemail startAnimating];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                        SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:nil totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
                        
                        NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:nil SalesReceiptArray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                        
                        if (pdfdata) {
                            [self emailPDF:pdfdata pdftype:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:nil salesreceiptarray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil]]];
                        }
                    }else{
                        SalesInvoiceRecord *salesinvoicerecord=[[SalesInvoiceRecord alloc]initSalesInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:nil totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity outstandingamount:[NSString stringWithFormat:@"%g",[SalesObject.total floatValue]-[SalesObject.paid floatValue]] invoiceremarks:SalesObject.invoiceremarks image:nil checkstatus:nil salesrecord:SalesObject productname:nil];
                        
                        NSData *pdfdata = [MyClass generateInvoiceWithClassInvoiceArray:nil SalesInvoiceArray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                        if (pdfdata) {
                            [self emailPDF:pdfdata pdftype:@"Invoice" filename:[MyClass returninvoicenumberwithclassinvoicearray:nil salesinvoicearray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] updateinvoicelog:NO]];
                        }
                    }
                    [aishareemail stopAnimating];
                });
            }else if (indexPath.row==1){
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
                    if (![globalvariables.documentfolder.salesreceiptarray containsObject:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey]) {
                        [globalvariables.documentfolder.salesreceiptarray addObject:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey];
                        [self refreshdocumentfoldercount];
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
                        [self refreshdocumentfoldercount];
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
}

-(void) paymentsharebuttonpressed:(UIButton *)sender
{
    invoiceorreceipt=@"receipt";
    receiptprintbutton=sender;
    
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"sharedocument" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 160) View:self Button:sender ItemsArray:[[NSMutableArray alloc]initWithObjects:/*@"Print",*/@"Send eReceipt",@"Send Email",@"Add to Folder",@"More", nil] Title:nil];
    
    /*
    
    [sharetable reloadData];
    UIView *shareview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 175, 152)];
    [shareview addSubview:sharetable];
    
    UIViewController *sharevc=[[UIViewController alloc]init];
    sharevc.preferredContentSize=CGSizeMake(175, 152);
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


-(void)storetmpfield
{
    if(detailspaymentText){tmppaidamount=detailspaymentText.text;}
    if(paymentremarksText){tmppaymentremarks=paymentremarksText.text;}
    if(receiptremarksText){tmpreceiptremarks=receiptremarksText.text;}
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    
    if (tableView==DetailsPaymentTable) {
        if ([tablemode isEqualToString:@"View"]) {
            if (DetailsPaymentArray.count>0) {
                if (indexPath.section==1) {
                    //DetailsPaymentObject=[DetailsPaymentArray objectAtIndex:indexPath.row];
                    //return [DetailsPaymentObject.action isEqualToString:@"locked"] ? NO : YES;
                    return NO;
                }else{
                    return NO;
                }
            }else{
                return NO;
            }
        }else{
            return NO;
        }
    }else if (tableView==sortingtable){
        return YES;
    }else if (tableView==InvoiceLogRecordTable){
        return YES;
    }else{
        return NO;
    }
}

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

}*/

-(void) addpaymentrecord:(id)sender
{
    paymentoverride=FALSE;
    
    tablemode=@"Add";
    
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];[df setDateFormat:@"dd-MMM-yyyy"];
    
    tmpPaidDate=[df stringFromDate:[NSDate date]];
    tmppaidmethod=@"Cash";
    
    //if ([globalvariables.centerrecord.defaulteditablepaymentamount isEqualToString:@"No"]) {
        tmppaidamount=paymentoutstandingLabel.text;
    /*}else{
        tmppaidamount=@"";
    }*/
    
    //tmpparentbankin=@"No";
    
    tmppaymentremarks=@"";
    
    if (scpaymenttype.selectedSegmentIndex==0) {
        tmpreceiptremarks=globalvariables.centerrecord.defaultreceiptremarksasinvoiceremarksforcourseenrollment?tmpinvoiceremarks:@"";
    }else{
        tmpreceiptremarks=globalvariables.centerrecord.defaultreceiptremarksasinvoiceremarksforproductsales?tmpinvoiceremarks:@"";
    }
    
    
    
    [DetailsPaymentTable reloadData];
    
    
    [self createPaymentToolBarwithMode:@"Add"];
    

    
}

-(void) donepaymentrecord:(id)sender{
    //update sql
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self checkvalidfeeinput:detailspaymentText.text] && [detailspaymentText.text floatValue]!=0) {
            
            df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];[df setDateFormat:@"dd-MMM-yyyy"];
            NSDate *date=[df dateFromString:tmpPaidDate];
            [df setDateFormat:@"yyyy-MM-dd"];
            
            //update payment record
            NSString *strURL;
            __block NSString *paymentkey;
            double totalpaid=[paymenttotalpaidLabel.text doubleValue]+[detailspaymentText.text doubleValue];
            
            if (!InvoiceView.hidden) {
                
                strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=insertpaymentdetails&paymenttypekey=%@&paiddate=%@&paidamount=%@&paidmethod=%@&paymenttype=%@&paymentremarks=%@&receiptremarks=%@&totalpaid=%g&staffname=%@&updatedby=%@&arckey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,invoicelogitemobject.typekey,[df stringFromDate:date],detailspaymentText.text,tmppaidmethod,invoicelogitemobject.type,paymentremarksText.text,receiptremarksText.text,totalpaid,[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"],globalvariables.username,[MyClass returndefaultarckey]];
            }else if (scpaymenttype.selectedSegmentIndex==0) {
                
                strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=insertpaymentdetails&paymenttypekey=%@&paiddate=%@&paidamount=%@&paidmethod=%@&paymenttype=%@&paymentremarks=%@&receiptremarks=%@&totalpaid=%g&staffname=%@&updatedby=%@&arckey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,OutstandingPaymentObject.enrollmentkey,[df stringFromDate:date],detailspaymentText.text,tmppaidmethod,@"Class",paymentremarksText.text,receiptremarksText.text,totalpaid,[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"],globalvariables.username,[MyClass returndefaultarckey]];
            }else{
                strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=insertpaymentdetails&paymenttypekey=%@&paiddate=%@&paidamount=%@&paidmethod=%@&paymenttype=%@&paymentremarks=%@&receiptremarks=%@&totalpaid=%g&staffname=%@&updatedby=%@&arckey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,outstandingsalespaymentobject.saleskey,[df stringFromDate:date],detailspaymentText.text,tmppaidmethod,@"Sales",paymentremarksText.text,receiptremarksText.text,totalpaid,[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"],globalvariables.username,[MyClass returndefaultarckey]];
            }
            
            __block BOOL result=FALSE;
            [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
                if (succeeded) {
                    result = TRUE;
                    NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                    //NSString *strResult = jsonreturned[@"content"];
                    
                    
                    paymentkey = [NSString stringWithFormat:@"%d",[jsonreturned[@"content"] intValue]];
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    [DetailsPaymentArray insertObject:[[PaymentRecord alloc]initPaymentRecordwithPaymentkey:paymentkey paymenttype:scpaymenttype.selectedSegmentIndex==0?@"Class":@"Sales" paymenttypekey:OutstandingPaymentObject.enrollmentkey paiddate:[df stringFromDate:date] paidmethod:paidmethodLabel.text paidamount:detailspaymentText.text action:@"locked" paymentremarks:paymentremarksText.text receiptremarks:receiptremarksText.text staffname:[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"] receiptnumber:nil receiptprefix:nil] atIndex:0];
                }
            }];
            
            /*
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            NSURLSession *session = [NSURLSession sharedSession];
            [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                // handle response
                
                if (!error) {
                    result = TRUE;
                    NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                    //NSString *strResult = jsonreturned[@"content"];
                    
                    
                    paymentkey = [NSString stringWithFormat:@"%d",[jsonreturned[@"content"] intValue]];
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    [DetailsPaymentArray insertObject:[[PaymentRecord alloc]initPaymentRecordwithPaymentkey:paymentkey paymenttype:scpaymenttype.selectedSegmentIndex==0?@"Class":@"Sales" paymenttypekey:OutstandingPaymentObject.enrollmentkey paiddate:[df stringFromDate:date] paidmethod:paidmethodLabel.text paidamount:detailspaymentText.text action:@"locked" paymentremarks:paymentremarksText.text receiptremarks:receiptremarksText.text staffname:[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"]] atIndex:0];
                }
                dispatch_semaphore_signal(semaphore);
            }] resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
            
            if (result) {
                if (!InvoiceView.hidden) {
                    [self retrieveInvoiceLog];
                }else if (scpaymenttype.selectedSegmentIndex==0) {
                    PopoverEnrollment.paid=[NSString stringWithFormat:@"%g",totalpaid];
                    if(globalvariables.centerrecord.autosendereceipt){
                        [self autosendereceiptwithtype:@"Class"];
                    }
                }else{
                    SalesObject.paid=[NSString stringWithFormat:@"%g",totalpaid];
                    if(globalvariables.centerrecord.autosendereceipt){
                        [self autosendereceiptwithtype:@"Sales"];
                    }
                }
                
                tablemode=@"View";
                [DetailsPaymentTable reloadData];
                
                [self createPaymentToolBarwithMode:@"View"];
            }/*else{
                [MyClass showconnectionlostdialogbox];
            }*/
        }
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverController {
    if (menubottombar.frame.origin.x==0) {
        //outstanding payment
        if (scpaymenttype.selectedSegmentIndex==0) {
            //class
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                NSString *lastselectedParentRow=selectedParentRow;
                selectedParentRow=@"";
                if ([self retrieveOutstandingClassPaymentRecordWithClassday:[classdayarray objectAtIndex:[scclassday selectedSegmentIndex]] enrollmentkeystring:selectedParentRow]) {
                    [self updateOutstandingValue];
                }else{
                    selectedParentRow=lastselectedParentRow;
                }
            });
        }else{
            //sales
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([self retrieveOutstandingPaymentSales]) {
                    [self updateOutstandingValue];
                }
            });
        }
    }
}

-(void) popupdetailspaymenttablewithtablemode:(NSString *)mode tableview:(UITableView *)tableview indexpath:(NSIndexPath *)indexpath
{
    
    DetailsPaymentTable.dataSource=self;
    DetailsPaymentTable.delegate=self;
    [DetailsPaymentTable reloadData];
    //if (DetailsPaymentTable.contentSize.height+44>maxpaymentpopupheight) {
        [DetailsPaymentTable setFrame:CGRectMake(0, 44+20, 300, maxpaymentpopupheight-44-20)];
    /*}else{
        [DetailsPaymentTable setFrame:CGRectMake(0, 44+20, 300, DetailsPaymentTable.contentSize.height)];
    }*/
    DetailsPaymentTable.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);
    paymentMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, self.view.frame.size.height)];
    [paymentMasterView addSubview:DetailsPaymentTable];
    
    UIView *topbar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 20)];
    topbar.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    [paymentMasterView addSubview:topbar];
    
    //add toolbar
    paymentToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, 300, 44)];
    paymentToolbar.barStyle=UIBarStyleDefault;
    paymentToolbar.clipsToBounds=YES;
    [self createPaymentToolBarwithMode:mode];
    
    
    paymentviewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    paymentviewcontroller.view=paymentMasterView;
    paymentviewcontroller.preferredContentSize=CGSizeMake(300, self.view.frame.size.height);
    
    
    [self startsidewindowanimationwithwidth:300];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        paymentviewcontroller.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:paymentviewcontroller.view];
        [self addChildViewController:paymentviewcontroller];
        [paymentviewcontroller didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });

    
}

-(void) popupbankininputtable
{
    tmpbankincashamount=@"";
    tmpbankinchequeamount=@"";
    tmpbankinperson=[MyClass returnstaffnamewithusername:globalvariables.username firstorfullname:@"full"];
    tmpbankinremarks=@"";
    
    BankinInputTable.dataSource=self;
    BankinInputTable.delegate=self;
    [BankinInputTable reloadData];
    [BankinInputTable setFrame:CGRectMake(0, 44+20, 300, self.view.bounds.size.height-44-20)];
    
    bankinInputMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, self.view.bounds.size.height)];
    

    [bankinInputMasterView addSubview:BankinInputTable];
    
    
    UIView *topbar=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 20)];
    topbar.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
    [bankinInputMasterView addSubview:topbar];
    
    
    //add toolbar
    bankinInputToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, 300, 44)];
    bankinInputToolbar.barStyle=UIBarStyleDefault;
    bankinInputToolbar.backgroundColor=[UIColor darkGrayColor];
    bankinInputToolbar.clipsToBounds=YES;
    
    
//    NSMutableArray *barItems=[[NSMutableArray alloc]init];
//    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIBarButtonItem *doneBankin=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneBankin:)];
    
    UIButton *doneBankin = [UIButton buttonWithType:UIButtonTypeSystem];
    doneBankin.frame = CGRectMake(20, 33, 100, 20);
    [doneBankin setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
    [doneBankin addTarget:self action:@selector(doneBankin:) forControlEvents:UIControlEventTouchUpInside];
    [doneBankin sizeToFit];
    doneBankin.frame = CGRectMake(300-doneBankin.frame.size.width-20, 33, doneBankin.frame.size.width, 20);
    [bankinInputMasterView addSubview:doneBankin];
    
    if ((lastoutstandingbankincash+newreceivedpaymentcash)==0 && (lastoutstandingbankincheque+newreceivedpaymentcheque)==0) {
        doneBankin.enabled=NO;
    }else{
        doneBankin.enabled=YES;
    }
    
//    barItems = [[NSMutableArray alloc]initWithObjects:flexSpace,doneBankin, nil];
    
//    [bankinInputToolbar setItems:barItems];
//    [bankinInputMasterView addSubview:bankinInputToolbar];
    
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=bankinInputMasterView;
    
    
    [self startsidewindowanimationwithwidth:300];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        viewcontroller.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:viewcontroller.view];
        [self addChildViewController:viewcontroller];
        [viewcontroller didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
    

    
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


-(void) donedismissbuttonpressed:(id)sender
{
    [[self.myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)selectclassday:(UISegmentedControl *)sender {
    NSString *lastselectedParentRow=selectedParentRow;
    selectedParentRow=@"";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self retrieveOutstandingClassPaymentRecordWithClassday:[classdayarray objectAtIndex:[scclassday selectedSegmentIndex]] enrollmentkeystring:@""]) {
            selectedParentRow=lastselectedParentRow;
            sender.selectedSegmentIndex=lastdayofweekindex;
        }else{
            lastdayofweekindex=sender.selectedSegmentIndex;
        }
    });
    
    
    
    //[self retrieveOutstandingBankinRecord];
    
}

- (IBAction)menubutton:(id)sender {
    [self.mainSlideMenu openLeftMenu];
}

- (IBAction)selectpaymenttype:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex==0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self retrieveOutstandingClassPaymentRecordWithClassday:[classdayarray objectAtIndex:[scclassday selectedSegmentIndex]] enrollmentkeystring:@""]) {
                paymentclassview.hidden=NO;
                paymentsalesview.hidden=YES;
                scclassday.enabled=YES;
                [self updateOutstandingValue];
            }else{
                sender.selectedSegmentIndex=1;
            }
        });
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self retrieveOutstandingPaymentSales]) {
                paymentclassview.hidden=YES;
                paymentsalesview.hidden=NO;
                scclassday.enabled=NO;
                [self updateOutstandingValue];
            }else{
                sender.selectedSegmentIndex=0;
            }
        });
    }
}


-(BOOL) updateOutstandingValue
{
    if ([self retrievenewpaymentreceived]) {
        [OutstandingViewButton setTitle:[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Outstanding"],[formatter stringFromNumber:[NSNumber numberWithFloat:totaloutstanding]]]  forState:UIControlStateNormal];
        
        //[sctable setTitle:[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Outstanding Payment"],[formatter stringFromNumber:[NSNumber numberWithFloat:(totaloutstandingclasspayment+totaloutstandingsalespayment)]]] forSegmentAtIndex:0];
        
        [BankinViewButton setTitle:[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Cash and Cheque"],[formatter stringFromNumber:[NSNumber numberWithFloat:(lastoutstandingbankincash +lastoutstandingbankincheque +newreceivedpaymentcash+newreceivedpaymentcheque)]]] forState:UIControlStateNormal];
        
        //[sctable setTitle:[NSString stringWithFormat:@"%@ (%@)",[MyClass returntitlewithtitle:@"Cash and Cheque"],[formatter stringFromNumber:[NSNumber numberWithFloat:(lastoutstandingbankincash +lastoutstandingbankincheque +newreceivedpaymentcash+newreceivedpaymentcheque)]]] forSegmentAtIndex:1];

        //newpaymentreceivedcash.text=[formatter stringFromNumber:[NSNumber numberWithFloat:newreceivedpaymentcash]];
        //newpaymentreceivedcheque.text=[formatter stringFromNumber:[NSNumber numberWithFloat:newreceivedpaymentcheque]];
        
        outstandingbankincash.text=[formatter stringFromNumber:[NSNumber numberWithFloat:(lastoutstandingbankincash+newreceivedpaymentcash)]];
        outstandingbankincheque.text=[formatter stringFromNumber:[NSNumber numberWithFloat:(lastoutstandingbankincheque+newreceivedpaymentcheque)]];
        
        
        return YES;
    }else{
        return NO;
    }
}

-(void) createpickerframewithtitle: (NSString *)title tableview:(UITableView *)tableview indexpath:(NSIndexPath *)indexpath{
    
    UIView *masterview =[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 260)];
    UIToolbar *pickerToolBar =[self createPickerToolbarWithTitle:title];
    [pickerToolBar setBarStyle:UIBarStyleDefault];
    [masterview addSubview:pickerToolBar];
    CGRect pickerFrame=CGRectMake(0, 40, 300, 216);
    UIPickerView *myPicker=[[UIPickerView alloc] initWithFrame:pickerFrame];
    [myPicker setDataSource:self];
    [myPicker setDelegate:self];
    myPicker.tag=1;
    
    
    [myPicker selectRow:presetRow inComponent:0 animated:NO];
    
    [myPicker setShowsSelectionIndicator:YES];
    self.myPickerView=myPicker;
    [masterview addSubview:myPicker];
    UIViewController *viewcontroller =[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=masterview;
    viewcontroller.preferredContentSize=viewcontroller.view.frame.size;
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myDatePickerPopoverController=viewcontroller.popoverPresentationController;
    myDatePickerPopoverController.delegate=self;
    myDatePickerPopoverController.permittedArrowDirections=UIPopoverArrowDirectionRight;
    UITableViewCell *cell=[tableview cellForRowAtIndexPath:indexpath];
    myDatePickerPopoverController.sourceView=cell.contentView;
    myDatePickerPopoverController.sourceRect=cell.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
}


- (UIToolbar *)createPickerToolbarWithTitle:(NSString *)title  {
    
    CGRect frame = CGRectMake(0, 0, 300, 44);
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:frame];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [self createButtonWithType:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneButton = [self createButtonWithType:UIBarButtonSystemItemDone target:self action:@selector(actionPickerDone:)];
    [barItems addObject:doneButton];
    [pickerToolbar setItems:barItems animated:YES];
    return pickerToolbar;
    
}


- (UIBarButtonItem *)createButtonWithType:(UIBarButtonSystemItem)type target:(id)target action:(SEL)buttonAction {
    
    return [[UIBarButtonItem alloc] initWithBarButtonSystemItem:type target:target action:buttonAction];
}


- (IBAction)actionPickerDone:(id)sender {
    
    paiddateLabel.text=selectedValue;
    
    
    if ([myDatePickerPopoverController presentingViewController].isBeingPresented)
        [[myDatePickerPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    
    if([selectedItem isEqualToString:@"DetailsPayment"]){
        return 100000;
    }else{
        return [pickerViewmenu count];
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    if([selectedItem isEqualToString:@"DetailsPayment"]){
        [df setDateFormat:@"dd-MMM-yyyy"];
        NSDate *date=[df dateFromString:[MyClass returnDateFromBaseDateWithOffset:row]];
        
        if ([globalvariables.language isEqualToString:@"English"]) {
            df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];[df setDateFormat:@"EEE dd MMM"];
        }else{
            df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];[df setDateFormat:@"M月d日 EEEE"];
        }
        
        return [df stringFromDate:date];
    }else if ([selectedItem isEqualToString:@"PaidMethod"]){
        return [MyClass returntitlewithtitle:[pickerViewmenu objectAtIndex:row]];
    }else{
        return [pickerViewmenu objectAtIndex:row];
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
        //[tView setTextAlignment:UITextAlignmentLeft];
        tView.numberOfLines=3;
    }
    // Fill the label text here
    
    
    if([selectedItem isEqualToString:@"DetailsPayment"]){
        tView.text=[MyClass returndateformatEEEDDMMMYYYYwithdateDDMMMYYYY:[MyClass returnDateFromBaseDateWithOffset:row]];
    }else if ([selectedItem isEqualToString:@"PaidMethod"]){
        tView.text=[MyClass returntitlewithtitle:[pickerViewmenu objectAtIndex:row]];
    }else{
        tView.text= [pickerViewmenu objectAtIndex:row];
    }
    //tView.text=[wishvalues objectAtIndex:row];
    return tView;
}



- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return 280;
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component

{
    
    if ([selectedItem isEqualToString:@"DetailsPayment"]){
        paiddateLabel.text=[MyClass returndateformatwithdate:[MyClass returnDateFromBaseDateWithOffset:row]];
        showPaymentDatePicker=NO;
        
        tmpPaidDate=[MyClass returnDateFromBaseDateWithOffset:row];
        
        [DetailsPaymentTable reloadData];
        
        if (DetailsPaymentTable.contentSize.height+44>maxpaymentpopupheight) {
            [DetailsPaymentTable setFrame:CGRectMake(0, 44, 300,  maxpaymentpopupheight)];
        }else{
            [DetailsPaymentTable setFrame:CGRectMake(0, 44, 300,  DetailsPaymentTable.contentSize.height)];
        }
        [paymentMasterView setFrame:CGRectMake(0, 0, 300, DetailsPaymentTable.contentSize.height+44)];
        //myPopoverController.popoverContentSize=CGSizeMake(300, DetailsPaymentTable.contentSize.height+44);

    }else if ([selectedItem isEqualToString:@"PaidMethod"]){
        paidmethodLabel.text=[MyClass returntitlewithtitle:[pickerViewmenu objectAtIndex:row]];
        //showPaidMethodPicker=NO;
        
        tmppaidmethod=[pickerViewmenu objectAtIndex:row];
        
        [DetailsPaymentTable reloadData];
    }
    
}

-(void) createPaymentToolBarwithMode:(NSString *)mode
{
    
    NSMutableArray *barItems=[[NSMutableArray alloc]init];
    UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if ([mode isEqualToString:@"View"]){
        
        invoiceButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Invoice"] style:UIBarButtonItemStylePlain target:self action:@selector(shareinvoicebutton:)];
        UIBarButtonItem *editButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editbutton:)];
        barItems = [[NSMutableArray alloc]initWithObjects:invoiceButton,flexSpace,editButton, nil];
    }else if ([mode isEqualToString:@"Edit"]){
        UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(canceladdbutton:)];
        UIBarButtonItem *addButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Add Payment"] style:UIBarButtonItemStylePlain target:self action:@selector(addpaymentrecord:)];
        barItems = [[NSMutableArray alloc]initWithObjects:cancelButton,flexSpace,addButton, nil];
    }else if([mode isEqualToString:@"Add"]){
        
        UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(editbutton:)];
        //UIBarButtonItem *settleButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Settle All"] style:UIBarButtonItemStylePlain target:self action:@selector(settleAllButtonPressed:)];
        UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(donepaymentrecord:)];
        
        //if ([globalvariables.centerrecord.defaulteditablepaymentamount isEqualToString:@"No"]) {
            barItems = [[NSMutableArray alloc]initWithObjects:cancelButton,flexSpace,doneButton, nil];
        /*}else{
            barItems = [[NSMutableArray alloc]initWithObjects:cancelButton,flexSpace,doneButton, nil];
        }*/
        
        
    }else if ([mode isEqualToString:@"EditPaymentRemarks"]){
        UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelpaymentremarks:)];
        UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(donepaymentremarks:)];
        barItems = [[NSMutableArray alloc]initWithObjects:cancelButton,flexSpace,doneButton, nil];
    }else if ([mode isEqualToString:@"EditInvoiceRemarks"]){
        UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIBarButtonItemStylePlain target:self action:@selector(cancelpaymentremarks:)];
        UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneinvoiceremarks:)];
        barItems = [[NSMutableArray alloc]initWithObjects:cancelButton,flexSpace,doneButton, nil];
    }
    
    [paymentToolbar setItems:barItems];
    [paymentMasterView addSubview:paymentToolbar];
    
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
    }else{
        tmppaidamount=sender.text;
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



- (IBAction)bankinbuttonpressed:(id)sender {
    
    if ([self retrieveOutstandingBankinRecord]) {
        [self popupbankininputtable];
    }
}


- (IBAction)selectInvoiceType:(id)sender {
    selectedinvoicelogkey=@"";
    [self returnfilterinvoicelogarraywithsort:YES];
}

- (IBAction)deselectoutstandingbuttonpressed:(id)sender {
    if(scpaymenttype.selectedSegmentIndex==0){
        OutstandingPaymentRecord *outstandingPaymentObject;
        for (int i=0; i<filteredOutstandingClassPaymentArray.count; i++) {
            outstandingPaymentObject=[filteredOutstandingClassPaymentArray objectAtIndex:i];
            
            if ([globalvariables.documentfolder.classpaymentarray containsObject:outstandingPaymentObject.enrollmentkey]) {
                [globalvariables.documentfolder.classpaymentarray removeObject:outstandingPaymentObject.enrollmentkey];
            }
            
            if ([globalvariables.documentfolder.classinvoicearray containsObject:outstandingPaymentObject.enrollmentkey]) {
                [globalvariables.documentfolder.classinvoicearray removeObject:outstandingPaymentObject.enrollmentkey];
            }
            
            if (![outstandingPaymentObject.lastpaymentkey isEqualToString:@""]) {
                if ([globalvariables.documentfolder.classreceiptarray containsObject:outstandingPaymentObject.enrollmentkey]) {
                    [globalvariables.documentfolder.classreceiptarray removeObject:outstandingPaymentObject.enrollmentkey];
                }
            }
            
            
            if ([globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:outstandingPaymentObject.enrollmentkey]) {
                [globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys removeObject:outstandingPaymentObject.enrollmentkey];
            }
            
            if ([globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:outstandingPaymentObject.enrollmentkey]) {
                [globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys removeObject:outstandingPaymentObject.enrollmentkey];
            }
            
            if (![outstandingPaymentObject.lastpaymentkey isEqualToString:@""]) {
                if ([globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:outstandingPaymentObject.enrollmentkey]) {
                    [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys removeObject:outstandingPaymentObject.enrollmentkey];
                }
            }
        }
//        OutstandingClassPaymentTable.tableColumns[0].headerCell.stringValue=@"0";
        [OutstandingClassPaymentTable reloadData];
    }else{
        OutstandingSalesPaymentRecord *outstandingsalespaymentobj;
        for (int i=0; i<filteredOutstandingSalesPaymentArray.count; i++) {
            outstandingsalespaymentobj=[filteredOutstandingSalesPaymentArray objectAtIndex:i];
            
            if ([globalvariables.documentfolder.salespaymentarray containsObject:outstandingsalespaymentobj.saleskey]) {
                [globalvariables.documentfolder.salespaymentarray removeObject:outstandingsalespaymentobj.saleskey];
            }
            
            if ([globalvariables.documentfolder.salesinvoicearray containsObject:outstandingsalespaymentobj.saleskey]) {
                [globalvariables.documentfolder.salesinvoicearray removeObject:outstandingsalespaymentobj.saleskey];
            }
            
            if (![outstandingsalespaymentobj.lastpaymentkey isEqualToString:@""]) {
                if ([globalvariables.documentfolder.salesreceiptarray containsObject:outstandingsalespaymentobj.lastpaymentkey]) {
                    [globalvariables.documentfolder.salesreceiptarray removeObject:outstandingsalespaymentobj.lastpaymentkey];
                }
            }
            
            if ([globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:outstandingsalespaymentobj.saleskey]) {
                [globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys removeObject:outstandingsalespaymentobj.saleskey];
            }
            
            if ([globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:outstandingsalespaymentobj.saleskey]) {
                [globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys removeObject:outstandingsalespaymentobj.saleskey];
            }
            
            if (![outstandingsalespaymentobj.lastpaymentkey isEqualToString:@""]) {
                if ([globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:outstandingsalespaymentobj.saleskey]) {
                    [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys removeObject:outstandingsalespaymentobj.saleskey];
                }
            }
        }
//        OutstandingSalesPaymentTable.tableColumns[0].headerCell.stringValue=@"";
        [OutstandingSalesPaymentTable reloadData];
    }
    
    [self refreshdocumentfoldercount];
}

- (IBAction)selectalloutstandingbuttonpressed:(id)sender {
    if(scpaymenttype.selectedSegmentIndex==0){
        OutstandingPaymentRecord *outstandingPaymentObject;
        for (int i=0; i<filteredOutstandingClassPaymentArray.count; i++) {
            outstandingPaymentObject=[filteredOutstandingClassPaymentArray objectAtIndex:i];
            
            if(![globalvariables.documentfolder.classpaymentarray containsObject:outstandingPaymentObject.enrollmentkey]){
                [globalvariables.documentfolder.classpaymentarray addObject:outstandingPaymentObject.enrollmentkey];
            }
            
            if(![globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:outstandingPaymentObject.enrollmentkey]){
                [globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys addObject:outstandingPaymentObject.enrollmentkey];
            }
            
            if (![globalvariables.documentfolder.classinvoicearray containsObject:outstandingPaymentObject.enrollmentkey]) {
                [globalvariables.documentfolder.classinvoicearray addObject:outstandingPaymentObject.enrollmentkey];
            }
            
            if (![globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:outstandingPaymentObject.enrollmentkey]) {
                [globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys addObject:outstandingPaymentObject.enrollmentkey];
            }
            
            if (![outstandingPaymentObject.lastpaymentkey isEqualToString:@""]) {
                if (![globalvariables.documentfolder.classreceiptarray containsObject:outstandingPaymentObject.enrollmentkey]) {
                    [globalvariables.documentfolder.classreceiptarray addObject:outstandingPaymentObject.enrollmentkey];
                }
                
                if (![globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:outstandingPaymentObject.enrollmentkey]) {
                    [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys addObject:outstandingPaymentObject.enrollmentkey];
                }
            }
        }
        [self showAddToDocumentFolderAnimationWithTableview:OutstandingClassPaymentTable IndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [OutstandingClassPaymentTable reloadData];
    }else{
        OutstandingSalesPaymentRecord *outstandingsalespaymentobj;
        for (int i=0; i<filteredOutstandingSalesPaymentArray.count; i++) {
            outstandingsalespaymentobj=[filteredOutstandingSalesPaymentArray objectAtIndex:i];
            
            if (![globalvariables.documentfolder.salespaymentarray containsObject:outstandingsalespaymentobj.saleskey]) {
                [globalvariables.documentfolder.salespaymentarray addObject:outstandingsalespaymentobj.saleskey];
            }
            
            if (![globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:outstandingsalespaymentobj.saleskey]) {
                [globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys addObject:outstandingsalespaymentobj.saleskey];
            }
            
            if (![globalvariables.documentfolder.salesinvoicearray containsObject:outstandingsalespaymentobj.saleskey]) {
                [globalvariables.documentfolder.salesinvoicearray addObject:outstandingsalespaymentobj.saleskey];
            }
            
            if (![globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:outstandingsalespaymentobj.saleskey]) {
                [globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys addObject:outstandingsalespaymentobj.saleskey];
            }
            
            if (![outstandingsalespaymentobj.lastpaymentkey isEqualToString:@""]) {
                if (![globalvariables.documentfolder.salesreceiptarray containsObject:outstandingsalespaymentobj.saleskey]) {
                    [globalvariables.documentfolder.salesreceiptarray addObject:outstandingsalespaymentobj.saleskey];
                }
                
                if (![globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:outstandingsalespaymentobj.saleskey]) {
                    [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys addObject:outstandingsalespaymentobj.saleskey];
                }
            }
        }
//        OutstandingSalesPaymentTable.tableColumns[0].headerCell.stringValue=[NSString stringWithFormat:@"%lu",filteredOutstandingSalesPaymentArray.count];
        [OutstandingSalesPaymentTable reloadData];
        [self showAddToDocumentFolderAnimationWithTableview:OutstandingSalesPaymentTable IndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
    
    
    
    [self refreshdocumentfoldercount];
}

- (IBAction)selectInvoiceButtonPressed:(UIButton *)sender {
    sender.tag=!sender.tag;
    [InvoiceLogItemTable reloadData];
    
    title_view1.hidden=sender.tag==0;
}

-(void) checkandupdatebankin:(id)sender
{
    if (!bankinchecked) {
        NSString *decimalRegex = @"^(?:|-)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
        
        NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", decimalRegex];
        
        if (![regexPredicate evaluateWithObject: bankinamountcashinputText.text]){
            //UnMatches
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Invalid Bankin Cash Input"] message:[MyClass returntitlewithtitle:@"Please input again"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
            bankinamountcashinputText.text=@"";
            
        }else if (![regexPredicate evaluateWithObject: bankinamountchequeinputText.text]){
            //UnMatches
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Invalid Bankin Cheque Input"] message:[MyClass returntitlewithtitle:@"Please input again"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
            bankinamountchequeinputText.text=@"";
            
        }else if ([bankinamountcashinputText.text floatValue]>(lastoutstandingbankincash+newreceivedpaymentcash) && ![bankinamountcashinputText.text isEqualToString:@""]){
            //bank in is greater than outstanding bank in
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Invalid Cash Bankin Input"] message:[MyClass returntitlewithtitle:@"Amount entered is greater than the outstanding amount"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
            bankinamountcashinputText.text=@"";
            
        }else if ([bankinamountchequeinputText.text floatValue]>(lastoutstandingbankincheque+newreceivedpaymentcheque) && ![bankinamountchequeinputText.text isEqualToString:@""]){
            //bank in is greater than outstanding bank in
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Invalid Cheque Bankin Input"] message:[MyClass returntitlewithtitle:@"Amount entered is greater than the outstanding amount"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
            bankinamountchequeinputText.text=@"";
            
        }else{
            tmpbankincashamount=bankinamountcashinputText.text;
            tmpbankinchequeamount=bankinamountchequeinputText.text;
        }
    }else{
        bankinchecked=FALSE;
    }
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    
    
    
    if (keyboardheight>0) {
        
        float tableheight;
        CGFloat screenHeight = self.view.window ? self.view.window.bounds.size.height : self.view.bounds.size.height;
        
        
        if (keyboardheight==0) {
            tableheight=documentfoldertablemaxheight;
        }else{
            if (screenHeight-keyboardheight>documentfoldertablemaxheight) {
                tableheight=documentfoldertablemaxheight;
            }else{
                tableheight=screenHeight-keyboardheight-40;
            }
        }
        
        
        
        if (textView==bankinremarksText) {
            CGPoint point = [textView.superview convertPoint:CGPointZero toView:BankinInputTable];
            NSIndexPath *indexpath =[BankinInputTable indexPathForRowAtPoint:point];
            
            CGRect rectInTableView = [BankinInputTable rectForRowAtIndexPath:indexpath];
            if (rectInTableView.origin.y>tableheight-rectInTableView.size.height) {
                [BankinInputTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-BankinInputTable.frame.size.height) animated:YES];
            }
            
        }else{
            CGPoint point = [textView.superview convertPoint:CGPointZero toView:DetailsPaymentTable];
            NSIndexPath *indexpath =[DetailsPaymentTable indexPathForRowAtPoint:point];
            
            CGRect rectInTableView = [DetailsPaymentTable rectForRowAtIndexPath:indexpath];
            
            if (rectInTableView.origin.y>tableheight-rectInTableView.size.height) {
                [DetailsPaymentTable setContentOffset:CGPointMake(0, rectInTableView.origin.y+rectInTableView.size.height-DetailsPaymentTable.frame.size.height) animated:YES];
            }
            
            
            
        }

    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView==paymentremarksText) {
        tmppaymentremarks=textView.text;
    }else if (textView==receiptremarksText){
        tmpreceiptremarks=textView.text;
    }else if (textView==bankinremarksText){
        tmpbankinremarks=textView.text;
    }
}
/*
- (NSString *) returnstudentnamewithfirstname:(NSString *)firstname lastname:(NSString *)lastname
{
    int spacecount=0;
    long lastspaceindex=0;
    for (long i=firstname.length-1; i>=0; i--) {
        if ([[firstname substringWithRange:NSMakeRange(i, 1)] isEqualToString:@" "]) {
            lastspaceindex=i;
            spacecount+=1;
        }
    }
    
    if (spacecount==2) {
        if ([lastname isEqualToString:@""]) {
            return [firstname substringToIndex:lastspaceindex];
        }else{
            return [NSString stringWithFormat:@"%@ %@",[firstname substringToIndex:lastspaceindex],lastname];
        }
    }else{
        if ([lastname isEqualToString:@""]) {
            return firstname;
        }else{
            return [NSString stringWithFormat:@"%@ %@",firstname,lastname];
        }
    }
}*/

-(void) cancelpaymentremarks:(id)sender
{
    tablemode=@"Edit";
    [DetailsPaymentTable reloadData];
    
    [self createPaymentToolBarwithMode:@"Edit"];
    
    /*
    if (DetailsPaymentTable.contentSize.height+44>maxpaymentpopupheight) {
        [DetailsPaymentTable setFrame:CGRectMake(0, 44, 300,  maxpaymentpopupheight)];
    }else{
        [DetailsPaymentTable setFrame:CGRectMake(0, 44, 300,  DetailsPaymentTable.contentSize.height)];
    }
    
    [paymentMasterView setFrame:CGRectMake(0, 0, 300, DetailsPaymentTable.frame.size.height+44)];
    myPopoverController.popoverContentSize=CGSizeMake(300, DetailsPaymentTable.frame.size.height+44);
    //[paymentScrollView setFrame:CGRectMake(0, 44, 300, DetailsPaymentTable.frame.size.height)];
    //[paymentScrollView setContentSize:CGSizeMake(300, DetailsPaymentTable.frame.size.height)];*/
}

-(void) canceladdbutton:(id)sender
{
    tablemode=@"View";
    [DetailsPaymentTable reloadData];
    
    [self createPaymentToolBarwithMode:@"View"];
    
    /*
    if (DetailsPaymentTable.contentSize.height+44>maxpaymentpopupheight) {
        [DetailsPaymentTable setFrame:CGRectMake(0, 44, 300,  maxpaymentpopupheight)];
    }else{
        [DetailsPaymentTable setFrame:CGRectMake(0, 44, 300,  DetailsPaymentTable.contentSize.height)];
    }
    
    [paymentMasterView setFrame:CGRectMake(0, 0, 300, DetailsPaymentTable.frame.size.height+44)];
    myPopoverController.popoverContentSize=CGSizeMake(300, DetailsPaymentTable.frame.size.height+44);*/
}


-(void) editbutton:(id)sender
{
    tablemode=@"Edit";
    [DetailsPaymentTable reloadData];
    
    [self createPaymentToolBarwithMode:@"Edit"];
    
    /*
    if (DetailsPaymentTable.contentSize.height+44>maxpaymentpopupheight) {
        [DetailsPaymentTable setFrame:CGRectMake(0, 44, 300,  maxpaymentpopupheight)];
    }else{
        [DetailsPaymentTable setFrame:CGRectMake(0, 44, 300,  DetailsPaymentTable.contentSize.height)];
    }
    
    [paymentMasterView setFrame:CGRectMake(0, 0, 300, DetailsPaymentTable.frame.size.height+44)];
    myPopoverController.popoverContentSize=CGSizeMake(300, DetailsPaymentTable.frame.size.height+44);*/
}


-(void) donepaymentremarks:(id)sender
{
    //for (int i=0; i<DetailsPaymentArray.count; i++) {
        //if ([((PaymentRecord *)[DetailsPaymentArray objectAtIndex:i]).paymentkey isEqualToString:DetailsPaymentObject.paymentkey]) {
            [DetailsPaymentArray replaceObjectAtIndex:DetailsPaymentObjectIndex withObject:[[PaymentRecord alloc]initPaymentRecordwithPaymentkey:DetailsPaymentObject.paymentkey paymenttype:DetailsPaymentObject.paymenttype paymenttypekey:DetailsPaymentObject.paymenttypekey paiddate:DetailsPaymentObject.paiddate paidmethod:DetailsPaymentObject.paidmethod paidamount:DetailsPaymentObject.paidamount action:DetailsPaymentObject.action paymentremarks:paymentremarksText.text receiptremarks:receiptremarksText.text staffname:DetailsPaymentObject.staffname receiptnumber:DetailsPaymentObject.receiptnumber receiptprefix:DetailsPaymentObject.receiptprefix]];
            
            NSString * strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatepaymentdetails&paymentkey=%@&paymentremarks=%@&receiptremarks=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DetailsPaymentObject.paymentkey,paymentremarksText.text,receiptremarksText.text];
            
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
            
            tablemode=@"View";
            [DetailsPaymentTable reloadData];
            
    
    [self createPaymentToolBarwithMode:@"View"];

}

-(void) doneinvoiceremarks:(id)sender
{
    tmpinvoiceremarks=invoiceremarksText.text;
    
    NSString *strURL;
    if (scpaymenttype.selectedSegmentIndex==0) {
        strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updateenrollment&enrollmentkey=%@&invoiceremarks=%@&updatedby=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,OutstandingPaymentObject.enrollmentkey,tmpinvoiceremarks,globalvariables.username];
    }else{
        strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatesalesrecord&saleskey=%@&invoiceremarks=%@&updatedby=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,outstandingsalespaymentobject.saleskey,tmpinvoiceremarks,globalvariables.username];
    }
    
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

        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    tablemode=@"View";
    [DetailsPaymentTable reloadData];
    
    [self createPaymentToolBarwithMode:@"View"];
    
}

-(void) shareinvoicebutton:(UIBarButtonItem *)sender
{
    invoiceorreceipt=@"invoice";
    invoiceButton=sender;
    
        [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"sharedocument" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 160) View:self BarButtonItem:sender ItemsArray:[[NSMutableArray alloc]initWithObjects:/*@"Print",*/@"Send eInvoice",@"Send Email",@"Add to Folder",@"More", nil] Title:nil];
}

-(void) sharepaymentinvoicewithtableview:(UITableView *)tableview indexpath:(NSIndexPath *)indexpath
{
    NSData *pdfData;
    
    // Create a filePath for the pdf.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath;
    
    if (scpaymenttype.selectedSegmentIndex==0) {
        NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Invoice"];
        if (classday) {
            ClassInvoiceRecord *classinvoicerecord=[[ClassInvoiceRecord alloc]initClassInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.tuitionfee floatValue]+[PopoverEnrollment.enrollmentfee floatValue]+[PopoverEnrollment.latefee floatValue]-[PopoverEnrollment.totalfee floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain outstandingamount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.totalfee floatValue]-[PopoverEnrollment.paid floatValue]] invoiceremarks:PopoverEnrollment.invoiceremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment subjectname:nil];
            
            pdfData = [MyClass generateInvoiceWithClassInvoiceArray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] SalesInvoiceArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
            filePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Invoice-%@.pdf",[MyClass returninvoicenumberwithclassinvoicearray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] salesinvoicearray:nil updateinvoicelog:NO]]];
        }else{
            return;
        }
    }else{
        SalesInvoiceRecord *salesinvoicerecord=[[SalesInvoiceRecord alloc]initSalesInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:nil totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity outstandingamount:[NSString stringWithFormat:@"%g",[SalesObject.total floatValue]-[SalesObject.paid floatValue]] invoiceremarks:SalesObject.invoiceremarks image:nil checkstatus:nil salesrecord:SalesObject productname:nil];
        
        pdfData = [MyClass generateInvoiceWithClassInvoiceArray:nil SalesInvoiceArray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
        filePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Invoice-%@.pdf",[MyClass returninvoicenumberwithclassinvoicearray:nil salesinvoicearray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] updateinvoicelog:NO]]];

    }
    
    [pdfData writeToFile:filePath atomically:YES];
    
    // Open the controller.
    documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    documentInteractionController.delegate = self;
    documentInteractionController.UTI = @"com.adobe.pdf";
    [documentInteractionController setName:@"Invoice"];
    [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    [documentInteractionController presentOptionsMenuFromBarButtonItem:invoiceButton  animated:YES];
}

-(void) sharepaymentreceiptwithtableview:(UITableView *)tableview indexpath:(NSIndexPath *)indexpath
{
    NSData *pdfData;
    
    // Create a filePath for the pdf.
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath;
    
    if (scpaymenttype.selectedSegmentIndex==0) {
        NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Receipt"];
        if (classday) {
            ClassReceiptRecord *classreceiptrecord=[[ClassReceiptRecord alloc]initClassReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.tuitionfee floatValue]+[PopoverEnrollment.enrollmentfee floatValue]+[PopoverEnrollment.latefee floatValue]-[PopoverEnrollment.totalfee floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain paymentkey:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paiddate paid:PopoverEnrollment.paid paidmethod:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment paymentremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentremarks subjectname:nil];
            
            
            pdfData=[MyClass generateReceiptWithClassReceiptArray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] SalesReceiptArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
            filePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Receipt-%@.pdf",[MyClass returnreceiptnumberwithclassreceiptarray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] salesreceiptarray:nil]]];
        }else{
            return;
        }
    }else{
        SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:nil totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
        
        pdfData=[MyClass generateReceiptWithClassReceiptArray:nil SalesReceiptArray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
        filePath=[documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Receipt-%@.pdf",[MyClass returnreceiptnumberwithclassreceiptarray:nil salesreceiptarray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil]]]];
    }
    

    [pdfData writeToFile:filePath atomically:YES];
    
    // Open the controller.
    documentInteractionController=[UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
    documentInteractionController.delegate = self;
    documentInteractionController.UTI = @"com.adobe.pdf";
    [documentInteractionController setName:@"Receipt"];
    
    [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [documentInteractionController presentOptionsMenuFromRect:receiptprintbutton.frame inView:receiptprintbutton animated:YES];
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

- (void)emailPDF:(NSData*)pdfData pdftype:(NSString *) pdftype filename:(NSString *)filename{
    
    
    
    if([PopoverStudent.parentemail isEqualToString:@""]){
        [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        UIAlertController *successalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Email"] message:@"No email address is found" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [successalert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [successalert addAction:OKAction];
        [self presentViewController:successalert animated:YES completion:nil];
    }else{
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:[NSString stringWithFormat:@"%@ - %@-%@",globalvariables.centerrecord.centername,pdftype,filename]];
        [mail addAttachmentData:pdfData mimeType:@"application/pdf" fileName:[NSString stringWithFormat:@"%@-%@.pdf",pdftype,filename]];
        [mail setToRecipients:@[PopoverStudent.parentemail]];
        [mail setMessageBody:[MyClass returntitlewithtitle:@"Please edit your email content"] isHTML:YES];
        
        [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        //[[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        
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
    info.outputType = UIPrintInfoOutputGeneral;
    info.jobName=@"CadabraCorp.pdf";
    info.duplex=UIPrintInfoDuplexLongEdge;
    info.outputType=UIPrintInfoOutputGrayscale;
    printer.printInfo = info;
    printer.showsPageRange=YES;
    printer.printingItem=pdfData;
    printer.showsPaperSelectionForLoadedPapers=YES;
    printer.delegate=self;
   
    
    [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    
    if ([invoiceorreceipt isEqualToString:@"receipt"]) {
        [printer presentFromRect:receiptprintbutton.bounds inView:receiptprintbutton animated:YES completionHandler:nil];
    }else{
        [printer presentFromBarButtonItem:invoiceButton animated:YES completionHandler:nil];
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
    
    UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Payment Receipt"]  message:emailresult preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [erroralert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [erroralert addAction:OKAction];
    [self presentViewController:erroralert animated:YES completion:nil];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}



-(NSMutableArray *) retrievefreescheduleclassarraywithenrollmentkey:(NSString *)enrollmentkey
{
    NSMutableArray *classrecordarray=[[NSMutableArray alloc]init];
    ClassRecord *classrecordobject=[[ClassRecord alloc]init];
    classrecordarray=[self retrieveClassWithEnrollmentkey:enrollmentkey];
    if (!classrecordarray) {
        return nil;
    }
    
    NSMutableArray *freescheduleclassarray=[[NSMutableArray alloc]init];
    for (int i=0; i<classrecordarray.count; i++) {
        classrecordobject=[classrecordarray objectAtIndex:i];
        [freescheduleclassarray addObject:[[FreeScheduleClass alloc]initFreeScheduleClassWithclasskey:classrecordobject.classkey subject:classrecordobject.subject classdate:classrecordobject.startdate classtime:classrecordobject.classtime instructor:classrecordobject.instructor classroom:classrecordobject.classroom attendance:classrecordobject.attendance makeupdate:classrecordobject.makeupdate makeuptime:classrecordobject.makeuptime makeupinstructor:classrecordobject.makeupinstructor makeupclassroom:classrecordobject.makeupclassroom makeupattendance:classrecordobject.makeupattendance classremarks:classrecordobject.remarks allclassremarks:classrecordobject.allclassremarks action:@"" classtype:@"Class" leavenaturelistkey:classrecordobject.leavenaturelistkey lesson:classrecordobject.lesson sinstructor:classrecordobject.sinstructor makeupsinstructor:classrecordobject.makeupsinstructor locked:classrecordobject.locked]];
    }
    
    return freescheduleclassarray;
}




-(NSMutableArray *) retrieveClassWithEnrollmentkey:(NSString *)enrollmentkey
{
    
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectclass&studentkey=%@&enrollmentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,PopoverEnrollment.studentkey,enrollmentkey];
    
    __block NSMutableArray *ClassRecordArray=[[NSMutableArray alloc] init];

    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            //Set up our class array
            NSDate *date;
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our ClassRecord object
                NSString * cstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                NSString * cclasskey=[[JSONArray objectAtIndex:i] objectForKey:@"classkey"];
                NSString * cenrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
                NSString * csubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString * clevelmain=[[JSONArray objectAtIndex:i] objectForKey:@"levelmain"];
                NSString * clevelctm=[[JSONArray objectAtIndex:i] objectForKey:@"levelctm"];
                
                NSString * cmakeupdate;
                
                NSString *cstartdate;
                
                df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];[df setDateFormat:@"yyyy-MM-dd"];
                
                if ([[[JSONArray objectAtIndex:i] objectForKey:@"startdate"] isEqualToString:@"TBD"]) {
                    cstartdate=[[JSONArray objectAtIndex:i] objectForKey:@"startdate"];
                }else{
                    date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"startdate"]];
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    cstartdate = [df stringFromDate:date];
                }
                
                if (![[[JSONArray objectAtIndex:i] objectForKey:@"makeupdate"] isEqualToString:@""]) {
                    [df setDateFormat:@"yyyy-MM-dd"];
                    date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"makeupdate"]];
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    cmakeupdate = [df stringFromDate:date];
                }else{
                    cmakeupdate=@"";
                }
                
                NSString * cclassday=[[JSONArray objectAtIndex:i] objectForKey:@"classday"];
                NSString * cclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                NSString * cinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
                NSString * cattendance=[[JSONArray objectAtIndex:i] objectForKey:@"attendance"];
                NSString * cmakeupattendance=[[JSONArray objectAtIndex:i] objectForKey:@"makeupattendance"];
                NSString * cmakeuptime=[[JSONArray objectAtIndex:i] objectForKey:@"makeuptime"];
                NSString * cmakeupinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"makeupinstructor"];
                NSString * cmakeupclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"makeupclassroom"];
                NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                NSString * callclassremarks=[[JSONArray objectAtIndex:i] objectForKey:@"allclassremarks"];
                NSString * cabsentmakeupreason=[[JSONArray objectAtIndex:i] objectForKey:@"absentmakeupreason"];
                NSString * cparentnote=[[JSONArray objectAtIndex:i] objectForKey:@"parentnote"];
                NSString * cdraft=[[JSONArray objectAtIndex:i] objectForKey:@"draft"];
                NSString * cclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
                NSString * cschedulekey=[[JSONArray objectAtIndex:i] objectForKey:@"schedulekey"];
                NSString * cstatus=[[JSONArray objectAtIndex:i] objectForKey:@"status"];
                NSString * cextendedminute=[[JSONArray objectAtIndex:i] objectForKey:@"extendedminute"];
                NSString * cextensiontime=[[JSONArray objectAtIndex:i] objectForKey:@"extensiontime"];
                NSString * corderdatetime=[[JSONArray objectAtIndex:i] objectForKey:@"orderdatetime"];
                int cassessmentformcount=[[[JSONArray objectAtIndex:i] objectForKey:@"assessmentformcount"] intValue];
                NSString * cinstructorfullname=[MyClass returninstructornamewithusername:cinstructor firstorfullname:@"full"];
                NSString * cmakeupinstructorfullname=[MyClass returninstructornamewithusername:cmakeupinstructor firstorfullname:@"full"];
                NSString * csubjectfullname=[MyClass returnsubjectnamewithsubject_shortname:csubject centerkey:globalvariables.centerrecord.centerkey];
                NSString * leavenaturelistkey=[[JSONArray objectAtIndex:i] objectForKey:@"leavenaturelistkey"];
                BOOL makeupquotaavailable=[[[JSONArray objectAtIndex:i] objectForKey:@"makeupquotaavailable"] isEqualToString:@"Yes"];
                NSString * lesson=[[JSONArray objectAtIndex:i] objectForKey:@"lesson"];
                NSString * csinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"sinstructor"];
                NSString * cmakeupsinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"makeupsinstructor"];
                BOOL clocked=[[[JSONArray objectAtIndex:i] objectForKey:@"locked"] isEqualToString:@"Yes"];
                BOOL cenrollmentpaid=[[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentpaid"] isEqualToString:@"1"];
                BOOL cexpiredpromotion=[[[JSONArray objectAtIndex:i] objectForKey:@"expiredpromotion"] isEqualToString:@"1"];
                BOOL chasextendedclass=[[[JSONArray objectAtIndex:i] objectForKey:@"hasextendedclass"] isEqualToString:@"Yes"];
                
                //Add the student object to our student array
                [ClassRecordArray addObject:[[ClassRecord alloc]initClassWithstudentkey:cstudentkey andenrollmentkey:cenrollmentkey andclasskey:cclasskey andsubject:csubject andlevelmain:clevelmain andlevelctm:clevelctm andstartdate:cstartdate andclassday:cclassday andclasstime:cclasstime andinstructor:cinstructor andattendance:cattendance andmakeupattendance:cmakeupattendance andmakeupdate:cmakeupdate andmakeuptime:cmakeuptime andremarks:cremarks andallclassremarks:callclassremarks andmakeupinstructor:cmakeupinstructor andmakeupclassroom:cmakeupclassroom andabsentmakeupreason:cabsentmakeupreason anddraft:cdraft andclassroom:cclassroom andschedulekey:cschedulekey andstatus:cstatus andextendedminute:cextendedminute andextensiontime:cextensiontime orderdatetime:corderdatetime instructorfullname:cinstructorfullname makeupinstructorfullname:cmakeupinstructorfullname subjectfullname:csubjectfullname parentnote:cparentnote assessmentformcount:cassessmentformcount leavenaturelistkey:leavenaturelistkey makeupquotaavailable:makeupquotaavailable voiceparentnotemessage:nil lesson:lesson  sinstructor:csinstructor makeupsinstructor:cmakeupsinstructor locked:clocked enrollmentpaid:cenrollmentpaid expiredpromotion:cexpiredpromotion hasextendedclass:chasextendedclass]];
            }
        }
    }];

    return ClassRecordArray;
    
}

-(BOOL) retrieveEnrollmentWithEnrollmentKey:(NSString *)enrollmentkey
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectenrollment&studentkey=%@&enrollmentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,PopoverStudent.studentkey,enrollmentkey];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            int i=0;
            NSString *cstartdate;
            NSString *cenddate;
            NSString * cstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
            NSString * cenrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
            NSString * cinvoicenumber=[[JSONArray objectAtIndex:i] objectForKey:@"invoicenumber"];
            NSString * cinvoiceprefix=[[JSONArray objectAtIndex:i] objectForKey:@"invoiceprefix"];
            NSString * cschedulekey=[[JSONArray objectAtIndex:i] objectForKey:@"schedulekey"];
            NSString * cautorenew=[[JSONArray objectAtIndex:i] objectForKey:@"autorenew"];
            NSString * csubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
            NSString * clevelmain=[[JSONArray objectAtIndex:i] objectForKey:@"levelmain"];
            NSString * clevelctm=[[JSONArray objectAtIndex:i] objectForKey:@"levelctm"];
            NSString * cgrade=[[JSONArray objectAtIndex:i] objectForKey:@"grade"];
            
            NSDate *date;
            
            df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];[df setDateFormat:@"yyyy-MM-dd"];
            date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentdate"]];
            [df setDateFormat:@"dd-MMM-yyyy"];
            NSString *cenrollmentdate = [df stringFromDate:date];
            
            if (![[[JSONArray objectAtIndex:i] objectForKey:@"startdate"] isEqualToString:@""]) {
                if ([[[JSONArray objectAtIndex:i] objectForKey:@"startdate"] isEqualToString:@"TBD"]) {
                    cstartdate=[[JSONArray objectAtIndex:i] objectForKey:@"startdate"];
                }else{
                    [df setDateFormat:@"yyyy-MM-dd"];
                    date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"startdate"]];
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    cstartdate = [df stringFromDate:date];
                }
            }else{
                cstartdate=@"";
            }
            
            if (![[[JSONArray objectAtIndex:i] objectForKey:@"enddate"] isEqualToString:@""]) {
                if ([[[JSONArray objectAtIndex:i] objectForKey:@"enddate"] isEqualToString:@"TBD"] || [[[JSONArray objectAtIndex:i] objectForKey:@"enddate"] isEqualToString:@"TBF"]) {
                    cenddate=[[JSONArray objectAtIndex:i] objectForKey:@"enddate"];
                }else{
                    [df setDateFormat:@"yyyy-MM-dd"];
                    date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"enddate"]];
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    cenddate = [df stringFromDate:date];
                }
            }else{
                cenddate=@"";
            }
            
            NSString * cnoofclass=[[JSONArray objectAtIndex:i] objectForKey:@"noofclass"];
            NSString * cclassday=[[JSONArray objectAtIndex:i] objectForKey:@"classday"];
            NSString * cclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
            NSString * cinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
            NSString * csinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"sinstructor"];
            NSString * cenrollmentfee=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentfee"];
            NSString * ctuitionfee=[[JSONArray objectAtIndex:i] objectForKey:@"tuitionfee"];
            NSString * coneoffdiscount=[[JSONArray objectAtIndex:i] objectForKey:@"oneoffdiscount"];
            NSString * crecursivediscount=[[JSONArray objectAtIndex:i] objectForKey:@"recursivediscount"];
            NSString * coneoffpercentagediscount=[[JSONArray objectAtIndex:i] objectForKey:@"oneoffpercentagediscount"];
            NSString * clatefee=[[JSONArray objectAtIndex:i] objectForKey:@"latefee"];
            NSString * ctotalfee=[[JSONArray objectAtIndex:i] objectForKey:@"totalfee"];
            NSString * cpaid=[[JSONArray objectAtIndex:i] objectForKey:@"paid"];
            NSString * cdropclassstatus=[[JSONArray objectAtIndex:i] objectForKey:@"dropclassstatus"];
            NSString * cresumeclassdate=[[JSONArray objectAtIndex:i] objectForKey:@"resumeclassdate"];
            NSString * cdropclassdate;
            
            if (![[[JSONArray objectAtIndex:i] objectForKey:@"dropclassdate"] isEqualToString:@""]) {
                if ([[[JSONArray objectAtIndex:i] objectForKey:@"dropclassdate"] isEqualToString:@"TBD"] || [[[JSONArray objectAtIndex:i] objectForKey:@"dropclassdate"] isEqualToString:@"TBF"]) {
                    cdropclassdate=[[JSONArray objectAtIndex:i] objectForKey:@"dropclassdate"];
                }else{
                    [df setDateFormat:@"yyyy-MM-dd"];
                    date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"dropclassdate"]];
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    cdropclassdate = [df stringFromDate:date];
                }
            }else{
                cdropclassdate=@"";
            }
            
            NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
            NSString * cdraft=[[JSONArray objectAtIndex:i] objectForKey:@"draft"];
            NSString * cinvoiceremarks=[[JSONArray objectAtIndex:i] objectForKey:@"invoiceremarks"];
            NSString * cclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
            NSString * cstatus=[[JSONArray objectAtIndex:i] objectForKey:@"status"];
            NSString * creverseadjustment=[[JSONArray objectAtIndex:i] objectForKey:@"reverseadjustment"];
            NSString * cinstructorfullname=[MyClass returninstructornamewithusername:cinstructor firstorfullname:@"full"];
            NSString * csubjectfullname=[MyClass returnsubjectnamewithsubject_shortname:csubject centerkey:globalvariables.centerrecord.centerkey];
            //NSString * clastpaymentkey=[[JSONArray objectAtIndex:i] objectForKey:@"lastpaymentkey"];

            NSString * cvalidity=[[JSONArray objectAtIndex:i] objectForKey:@"validity"];
            NSString * cmakeup_quota=[[JSONArray objectAtIndex:i] objectForKey:@"makeup_quota"];
            NSString * cmakeup_quota_used=[[JSONArray objectAtIndex:i] objectForKey:@"makeup_quota_used"];
            NSString * cenrollmentmode=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentmode"];
            NSString * cstandardnoofclassormonth=[[JSONArray objectAtIndex:i] objectForKey:@"standardnoofclassormonth"];
            BOOL clocked=[[[JSONArray objectAtIndex:i] objectForKey:@"locked"] isEqualToString:@"Yes"];
            NSString *cbilldate=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"billdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
            NSString * coutstandingmakeupclasses=[[JSONArray objectAtIndex:i] objectForKey:@"outstandingmakeupclasses"];
            
            NSMutableArray *cpaymentrecords=[[NSMutableArray alloc]init];
            NSArray *paymentrecords=[[JSONArray objectAtIndex:i] objectForKey:@"paymentrecords"];
            for (int i=0; i<paymentrecords.count; i++) {
                NSString * spaymentkey=[[paymentrecords objectAtIndex:i] objectForKey:@"paymentkey"];
                NSString * spaymentype=[[paymentrecords objectAtIndex:i] objectForKey:@"paymenttype"];
                NSString * spaymenttypekey=[[paymentrecords objectAtIndex:i] objectForKey:@"paymenttypekey"];
                NSString * spaiddate=[MyClass convertDateFormatWithDate:[[paymentrecords objectAtIndex:i] objectForKey:@"paiddate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                NSString * spaidmethod=[[paymentrecords objectAtIndex:i] objectForKey:@"paidmethod"];
                NSString * spaidamount=[[paymentrecords objectAtIndex:i] objectForKey:@"paidamount"];
                NSString * spaymentremarks=[[paymentrecords objectAtIndex:i] objectForKey:@"paymentremarks"];
                NSString * sreceiptremarks=[[paymentrecords objectAtIndex:i] objectForKey:@"receiptremarks"];
                NSString * sstaffname=[[paymentrecords objectAtIndex:i] objectForKey:@"staffname"];
                NSString * sreceiptnumber=[[paymentrecords objectAtIndex:i] objectForKey:@"receiptnumber"];
                NSString * sreceiptprefix=[[paymentrecords objectAtIndex:i] objectForKey:@"receiptprefix"];
                
                [cpaymentrecords addObject:[[PaymentRecord alloc]initPaymentRecordwithPaymentkey:spaymentkey paymenttype:spaymentype paymenttypekey:spaymenttypekey paiddate:spaiddate paidmethod:spaidmethod paidamount:spaidamount action:@"locked" paymentremarks:spaymentremarks receiptremarks:sreceiptremarks staffname:sstaffname receiptnumber:sreceiptnumber receiptprefix:sreceiptprefix]];
            }
            
            NSMutableArray *cpromotiondiscountrecords=[[NSMutableArray alloc]init];
            NSArray *promotiondiscountrecords=[[JSONArray objectAtIndex:i] objectForKey:@"promotiondiscountrecords"];
            for (int i=0; i<promotiondiscountrecords.count; i++) {
                NSString * scenterkey=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"centerkey"];
                NSString * smarketingkey=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"marketingkey"];
                NSString * sdescription=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"description"];
                NSString * sdescription_chinese=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"description_chinese"];
                NSString * sstartdate=[MyClass convertDateFormatWithDate:[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"startdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                NSString * senddate=[MyClass convertDateFormatWithDate:[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"enddate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                NSString * sremarks=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"remarks"];
                NSString * spromotionfixeddiscount=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"promotionfixeddiscount"];
                NSString * spromotionpercentagediscount=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"promotionpercentagediscount"];
                NSString * susedcount=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"usedcount"];
                NSString * spromotionquota=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"promotionquota"];
                NSString * scode=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"code"];
                NSString * srecursive=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"recursive"];
                BOOL sperclassorquantity=[[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"perclassorquantity"] isEqualToString:@"Yes"];
                BOOL smanualapply=[[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"manualapply"] isEqualToString:@"Yes"];
                
                [cpromotiondiscountrecords addObject:[[MarketingRecord alloc]initMarketingRecordWithcenterkey:scenterkey marketingkey:smarketingkey category:@"promotion" description:sdescription description_chinese:sdescription_chinese startdate:sstartdate enddate:senddate remarks:sremarks promotionfixeddiscount:spromotionfixeddiscount promotionpercentagediscount:spromotionpercentagediscount usedcount:susedcount promotionquota:spromotionquota code:scode recursive:srecursive effectivefrom:nil effectiveto:nil subcategory:nil redeemable:NO redeempoint:nil perstudentquota:nil cannotuseconjunctionwithothercoupons:NO subjectarray:nil productarray:nil couponallowcredit:nil perclassorquantity:sperclassorquantity earlybirdlastdate:nil buymorepayless:NO estartdate:nil eenddate:nil enablebuymorepayless:NO minnoofclass:0 bmsmacrossothersubjects:NO bmsmminsubjectno:0 bmsmminnoofclasspersubject:0 bmsmsamebillmonth:NO manualapply:smanualapply]];
            }
            
            PopoverEnrollment=[[EnrollmentRecord alloc]initEnrollmentWithstudentkey:cstudentkey andenrollmentkey:cenrollmentkey andenrollmentdate:cenrollmentdate andschedulekey:cschedulekey andsubject:csubject andlevelmain:clevelmain andlevelctm:clevelctm andgrade:cgrade andstartdate:cstartdate andnoofclass:cnoofclass andenddate:cenddate andclassday:cclassday andclasstime:cclasstime andinstructor:cinstructor andenrollmentfee:cenrollmentfee andtuitionfee:ctuitionfee andoneoffdiscount:coneoffdiscount andrecursivediscount:crecursivediscount andoneoffpercentagediscount:coneoffpercentagediscount andlatefee:clatefee andtotalfee:ctotalfee andpaid:cpaid anddropclassstatus:cdropclassstatus anddropclassdate:cdropclassdate andremarks:cremarks anddraft:cdraft andinvoiceremarks:cinvoiceremarks andclassroom:cclassroom andautorenew:cautorenew andstatus:cstatus andreverseadjustment:creverseadjustment instructorfullname:cinstructorfullname subjectfullname:csubjectfullname validity:cvalidity makeup_quota:cmakeup_quota makeup_quota_used:cmakeup_quota_used paymentrecords:cpaymentrecords promotiondiscountrecords:cpromotiondiscountrecords classrecords:nil sinstructor:csinstructor transferredfromenrollmentkey:@"" enrollmentmode:cenrollmentmode standardnoofclassormonth:cstandardnoofclassormonth couponrecords:nil invoicenumber:cinvoicenumber invoiceprefix:cinvoiceprefix locked:clocked billdate:cbilldate resumeclassdate:cresumeclassdate outstandingmakeupclasses:coutstandingmakeupclasses];
        }
    }];

    return result;
}


-(BOOL) retrieveSalesRecordwithSaleskey:(NSString *)saleskey
{
    //create string contains url address for php file
    NSString *strURL;
    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectsalesrecord&saleskey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,saleskey];

    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDate *date;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            int i=0;
            
            NSString * cstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
            NSString * csaleskey=[[JSONArray objectAtIndex:i] objectForKey:@"saleskey"];
            NSString * cinvoicenumber=[[JSONArray objectAtIndex:i] objectForKey:@"invoicenumber"];
            NSString * cinvoiceprefix=[[JSONArray objectAtIndex:i] objectForKey:@"invoiceprefix"];
            df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];[df setDateFormat:@"yyyy-MM-dd"];
            date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"orderdate"]];
            [df setDateFormat:@"dd-MMM-yyyy"];
            NSString * corderdate=[df stringFromDate:date];
            NSString * cproductcode=[[JSONArray objectAtIndex:i] objectForKey:@"productcode"];
            NSString * cproductfullname=[MyClass returnproductnamewithproductcode:cproductcode centerkey:globalvariables.centerrecord.centerkey];
            
            NSString * cproductcategory=[[JSONArray objectAtIndex:i] objectForKey:@"category"];

            NSString * cprice=[[JSONArray objectAtIndex:i] objectForKey:@"price"];
            NSString * cquantity=[[JSONArray objectAtIndex:i] objectForKey:@"quantity"];
            NSString * coneoffdiscount=[[JSONArray objectAtIndex:i] objectForKey:@"oneoffdiscount"];
            NSString * coneoffpercentagediscount=[[JSONArray objectAtIndex:i] objectForKey:@"oneoffpercentagediscount"];
            NSString * cpaid=[[JSONArray objectAtIndex:i] objectForKey:@"paid"];
            NSString * ctotal=[[JSONArray objectAtIndex:i] objectForKey:@"total"];
            NSString * cremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
            NSString * cinvoiceremarks=[[JSONArray objectAtIndex:i] objectForKey:@"invoiceremarks"];
            NSString * cstatus=[[JSONArray objectAtIndex:i] objectForKey:@"status"];
            NSString * creverseadjustment=[[JSONArray objectAtIndex:i] objectForKey:@"reverseadjustment"];
            NSString * cautorenew=[[JSONArray objectAtIndex:i] objectForKey:@"autorenew"];
            
            NSMutableArray *cpaymentrecords=[[NSMutableArray alloc]init];
            NSArray *paymentrecords=[[JSONArray objectAtIndex:i] objectForKey:@"paymentrecords"];
            for (int i=0; i<paymentrecords.count; i++) {
                NSString * spaymentkey=[[paymentrecords objectAtIndex:i] objectForKey:@"paymentkey"];
                NSString * spaymentype=[[paymentrecords objectAtIndex:i] objectForKey:@"paymenttype"];
                NSString * spaymenttypekey=[[paymentrecords objectAtIndex:i] objectForKey:@"paymenttypekey"];
                NSString * spaiddate=[MyClass convertDateFormatWithDate:[[paymentrecords objectAtIndex:i] objectForKey:@"paiddate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                NSString * spaidmethod=[[paymentrecords objectAtIndex:i] objectForKey:@"paidmethod"];
                NSString * spaidamount=[[paymentrecords objectAtIndex:i] objectForKey:@"paidamount"];
                NSString * spaymentremarks=[[paymentrecords objectAtIndex:i] objectForKey:@"paymentremarks"];
                NSString * sreceiptremarks=[[paymentrecords objectAtIndex:i] objectForKey:@"receiptremarks"];
                NSString * sstaffname=[[paymentrecords objectAtIndex:i] objectForKey:@"staffname"];
                NSString * sreceiptnumber=[[paymentrecords objectAtIndex:i] objectForKey:@"receiptnumber"];
                NSString * sreceiptprefix=[[paymentrecords objectAtIndex:i] objectForKey:@"receiptprefix"];
                
                [cpaymentrecords addObject:[[PaymentRecord alloc]initPaymentRecordwithPaymentkey:spaymentkey paymenttype:spaymentype paymenttypekey:spaymenttypekey paiddate:spaiddate paidmethod:spaidmethod paidamount:spaidamount action:@"locked" paymentremarks:spaymentremarks receiptremarks:sreceiptremarks staffname:sstaffname receiptnumber:sreceiptnumber receiptprefix:sreceiptprefix]];
            }
            
            NSMutableArray *cpromotiondiscountrecords=[[NSMutableArray alloc]init];
            NSArray *promotiondiscountrecords=[[JSONArray objectAtIndex:i] objectForKey:@"promotiondiscountrecords"];
            for (int i=0; i<promotiondiscountrecords.count; i++) {
                NSString * scenterkey=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"centerkey"];
                NSString * smarketingkey=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"marketingkey"];
                NSString * sdescription=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"description"];
                NSString * sdescription_chinese=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"description_chinese"];
                NSString * sstartdate=[MyClass convertDateFormatWithDate:[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"startdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                NSString * senddate=[MyClass convertDateFormatWithDate:[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"enddate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                NSString * sremarks=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"remarks"];
                NSString * spromotionfixeddiscount=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"promotionfixeddiscount"];
                NSString * spromotionpercentagediscount=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"promotionpercentagediscount"];
                NSString * susedcount=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"usedcount"];
                NSString * spromotionquota=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"promotionquota"];
                NSString * scode=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"code"];
                NSString * srecursive=[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"recursive"];
                BOOL sperclassorquantity=[[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"perclassorquantity"] isEqualToString:@"Yes"];
                BOOL smanualapply=[[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"manualapply"] isEqualToString:@"Yes"];
                
                [cpromotiondiscountrecords addObject:[[MarketingRecord alloc]initMarketingRecordWithcenterkey:scenterkey marketingkey:smarketingkey category:@"promotion" description:sdescription description_chinese:sdescription_chinese startdate:sstartdate enddate:senddate remarks:sremarks promotionfixeddiscount:spromotionfixeddiscount promotionpercentagediscount:spromotionpercentagediscount usedcount:susedcount promotionquota:spromotionquota code:scode recursive:srecursive effectivefrom:nil effectiveto:nil subcategory:nil redeemable:NO redeempoint:nil perstudentquota:nil cannotuseconjunctionwithothercoupons:NO subjectarray:nil productarray:nil couponallowcredit:nil perclassorquantity:sperclassorquantity earlybirdlastdate:nil buymorepayless:NO estartdate:nil eenddate:nil enablebuymorepayless:NO minnoofclass:0 bmsmacrossothersubjects:NO bmsmminsubjectno:0 bmsmminnoofclasspersubject:0 bmsmsamebillmonth:NO manualapply:smanualapply]];
            }
            
            SalesObject=[[SalesRecord alloc]initSalesRecordWithstudentkey:cstudentkey saleskey:csaleskey orderdate:corderdate productfullname:cproductfullname productcode:cproductcode productcategory:cproductcategory price:cprice quantity:cquantity oneoffdiscount:coneoffdiscount oneoffpercentagediscount:coneoffpercentagediscount paid:cpaid total:ctotal remarks:cremarks invoiceremarks:cinvoiceremarks status:cstatus reverseadjustment:creverseadjustment autorenew:cautorenew paymentrecords:cpaymentrecords promotiondiscountrecords:cpromotiondiscountrecords givenout:nil couponrecords:nil invoicenumber:cinvoicenumber invoiceprefix:cinvoiceprefix];
        }
    }];

    return result;
}

-(void) adjusttablesize
{
    float tableheight;
    CGFloat screenHeight = self.view.window ? self.view.window.bounds.size.height : self.view.bounds.size.height;
    
    
    if (keyboardheight==0) {
        tableheight=documentfoldertablemaxheight;
    }else{
        if (screenHeight-keyboardheight>documentfoldertablemaxheight) {
            tableheight=documentfoldertablemaxheight;
        }else{
            tableheight=screenHeight-keyboardheight-40;
        }
    }
    
    if (menubottombar.frame.origin.x==0) {
        tableheight=maxpaymentpopupheight-keyboardheight;
        
        //if (DetailsPaymentTable.contentSize.height+44>tableheight) {
            [DetailsPaymentTable setFrame:CGRectMake(0, 44+20, 300, tableheight-44-20)];
        /*}else{
            [DetailsPaymentTable setFrame:CGRectMake(0, 44, 300, DetailsPaymentTable.contentSize.height)];
        }*/
        
        //[paymentMasterView setFrame:CGRectMake(0, 0, 300, DetailsPaymentTable.frame.size.height+44)];
        //myPopoverController.popoverContentSize=CGSizeMake(300, DetailsPaymentTable.frame.size.height+44);
        //[paymentScrollView setFrame:CGRectMake(0, 44, 300, DetailsPaymentTable.frame.size.height)];
        //[paymentScrollView setContentSize:CGSizeMake(300, DetailsPaymentTable.frame.size.height)];
        
    }else{
        tableheight=maxpopupheight-keyboardheight;
        /*if (BankinInputTable.contentSize.height+44<tableheight) {
            [BankinInputTable setFrame:CGRectMake(0, 44, 300, BankinInputTable.contentSize.height)];
            myPopoverController.popoverContentSize=CGSizeMake(300, BankinInputTable.contentSize.height);
        }else{*/
            [BankinInputTable setFrame:CGRectMake(0, 44+20, 300, tableheight-44-20)];
            //myPopoverController.popoverContentSize=CGSizeMake(300, tableheight);
        //}
    }
    
}

/*
- (void) refreshdocumentfoldercount
{
    if (sctable.selectedSegmentIndex==0) {
        documentfoldercountlabel.text = [NSString stringWithFormat:@"%d",(int)globalvariables.documentfolder.classinvoicearray.count+(int)globalvariables.documentfolder.classreceiptarray.count+(int)globalvariables.documentfolder.salesinvoicearray.count+(int)globalvariables.documentfolder.salesreceiptarray.count];
        if ([documentfoldercountlabel.text intValue]==0) {
            documentfolderbutton.hidden=YES;
            documentfoldercountlabel.hidden=YES;
        }else{
            documentfolderbutton.hidden=NO;
            documentfoldercountlabel.hidden=NO;
        }
    }else{
        documentfolderbutton.hidden=YES;
        documentfoldercountlabel.hidden=YES;
    }
}*/

- (void) refreshdocumentfoldercount
{
    if ((int)globalvariables.documentfolder.classinvoicearray.count+(int)globalvariables.documentfolder.classreceiptarray.count+(int)globalvariables.documentfolder.salesinvoicearray.count+(int)globalvariables.documentfolder.salesreceiptarray.count+(int)globalvariables.documentfolder.salespaymentarray.count+(int)globalvariables.documentfolder.classpaymentarray.count>0) {
        documentfoldercountlabel.hidden=NO;
    }else{
        documentfoldercountlabel.hidden=YES;
    }
    documentfolderbutton.hidden=NO;
}


-(void) documentfolderbuttonpressed:(id)sender
{
    /*//UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    documentfolderpopover = (DocumentFolderPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"DocumentFolderPopoverViewController"];
    documentfolderpopover.delegate=self;
    documentfolderpopover.menubutton=2;
    documentfolderpopover.defaultcheckedclasspaymentenrollmentkeys=defaultcheckedclasspaymentenrollmentkeys;
    documentfolderpopover.defaultcheckedsalespaymentsaleskeys=defaultcheckedsalespaymentsaleskeys;
    documentfolderpopover.defaultcheckedclassinvoiceenrollmentkeys=defaultcheckedclassinvoiceenrollmentkeys;
    documentfolderpopover.defaultcheckedsalesinvoicesaleskeys=defaultcheckedsalesinvoicesaleskeys;
    documentfolderpopover.defaultcheckedclassreceiptpaymentkeys=defaultcheckedclassreceiptpaymentkeys;
    documentfolderpopover.defaultcheckedsalesreceiptpaymentkeys=defaultcheckedsalesreceiptpaymentkeys;
    documentfolderpopover.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:documentfolderpopover animated:YES completion: nil];
    */
    
    [self startsidewindowanimationwithwidth:750];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        documentfolderpopover = (DocumentFolderPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"DocumentFolderPopoverViewController"];
        documentfolderpopover.delegate=self;
        //globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys=defaultcheckedclasspaymentenrollmentkeys;
        //globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys=defaultcheckedsalespaymentsaleskeys;
        //globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys=defaultcheckedclassinvoiceenrollmentkeys;
        //globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys=defaultcheckedsalesinvoicesaleskeys;
        //globalvariables.documentfolder.defaultcheckedclassreceiptpaymentkeys=defaultcheckedclassreceiptpaymentkeys;
        //globalvariables.documentfolder.defaultcheckedsalesreceiptpaymentkeys=defaultcheckedsalesreceiptpaymentkeys;
        documentfolderpopover.menubutton=2;
        
        documentfolderpopover.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:documentfolderpopover.view];
        [self addChildViewController:documentfolderpopover];
        documentfolderpopover.view.clipsToBounds=YES;
        [documentfolderpopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
    

}

-(void) dismissDocumentFolderPopover
{
    [self closesidewindow];//[documentfolderpopover dismissViewControllerAnimated:YES completion:nil];
    if (!InvoiceView.hidden) {
        [InvoiceLogRecordTable reloadData];
        [InvoiceLogItemTable reloadData];
    }else if (scpaymenttype.selectedSegmentIndex==0) {
        [OutstandingClassPaymentTable reloadData];
    }else{
        [OutstandingSalesPaymentTable reloadData];
    }
    [self refreshdocumentfoldercount];
    


}

-(void) refreshDocumentFolderPresentingViewScreen
{
    if (!InvoiceView.hidden) {
        [self refreshinvoicelogtable];
    }else if (scpaymenttype.selectedSegmentIndex==0) {
        [self refreshoutstandingclasspaymenttable];
    }else{
        [self refreshoutstandingsalespaymenttable];
    }
}

-(void) refreshdocumentfoldercountnumber
{
    [self refreshdocumentfoldercount];
}

-(NSString *) returntotalpaidwithindexpath:(NSIndexPath *)indexpath
{
    float totalpaid=0;
    for (long i=indexpath.row; i<DetailsPaymentArray.count; i++) {
        totalpaid+=[((PaymentRecord *)[DetailsPaymentArray objectAtIndex:i]).paidamount floatValue];
    }
    
    return [NSString stringWithFormat:@"%g",totalpaid];
}


/*
-(NSString *) retrieveClassDaywithEnrollmentkey:(NSString *)enrollmentkey
{
    NSDate *date;
    FreeScheduleClassArray=[self retrievefreescheduleclassarraywithenrollmentkey:PopoverEnrollment.enrollmentkey];
    if (!FreeScheduleClassArray) {
        return nil;
    }
    
    NSString *classdatestring=@"";
    for (int i=0; i<FreeScheduleClassArray.count; i++) {
        [df setDateFormat:@"dd-MMM-yyyy"];
        date=[df dateFromString:((FreeScheduleClass *)[FreeScheduleClassArray objectAtIndex:i]).classdate];
        [df setDateFormat:@"yyyy-MM-dd"];
        if (i==0) {
            classdatestring=[df stringFromDate:date]?[df stringFromDate:date]:@"TBD";
        }else{
            classdatestring=[NSString stringWithFormat:@"%@, %@",classdatestring,[df stringFromDate:date]?[df stringFromDate:date]:@"TBD"];
        }
        [df setDateFormat:@"EEE"];
        classdatestring=[NSString stringWithFormat:@"%@ (%@%@)",classdatestring,[df stringFromDate:date]?[NSString stringWithFormat:@"%@/",[df stringFromDate:date]]:@"",((FreeScheduleClass *)[FreeScheduleClassArray objectAtIndex:i]).classtime];
    }
    return classdatestring;
}*/

-(NSString *) retrieveClassDaywithEnrollmentkeyForDocument:(NSString *)enrollmentkey type:(NSString *)type
{
    
    __block NSString * classdaystring;
    __block BOOL result=FALSE;

    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getprintclassdays2&enrollmentkey=%@&type=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,enrollmentkey,type];
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result = TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            classdaystring = jsonreturned[@"content"];
        }
    }];

    if (result && classdaystring) {
        return [MyClass returnformattedclassdaystringwithclassdaystring:classdaystring language:PopoverStudent.preferredlanguage];
    }
    
    return @"";
    
//    int noofdayperline=3;
//
//    NSDate *date;
//    FreeScheduleClassArray=[self retrievefreescheduleclassarraywithenrollmentkey:PopoverEnrollment.enrollmentkey];
//    if (!FreeScheduleClassArray) {
//        return nil;
//    }
//
//    NSString *classdatestring=@"";
//    for (int i=0; i<FreeScheduleClassArray.count; i++) {
//        [df setDateFormat:@"dd-MMM-yyyy"];
//        date=[df dateFromString:((FreeScheduleClass *)[FreeScheduleClassArray objectAtIndex:i]).classdate];
//        [df setDateFormat:@"yyyy-MM-dd"];
//
//        if ([PopoverStudent.preferredlanguage isEqualToString:@"Cantonese"]||[PopoverStudent.preferredlanguage isEqualToString:@"Mandarin"]) {
//            if (i==0) {
//                classdatestring=[df stringFromDate:date]?[df stringFromDate:date]:@"待確定";
//            }else{
//                if (i%noofdayperline ==0) {
//                    classdatestring=[NSString stringWithFormat:@"%@\r\n%@",classdatestring,[df stringFromDate:date]?[df stringFromDate:date]:@"待確定"];
//                }else{
//                    classdatestring=[NSString stringWithFormat:@"%@, %@",classdatestring,[df stringFromDate:date]?[df stringFromDate:date]:@"待確定"];
//                }
//            }
//            df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"]; [df setDateFormat:@"EEE"];
//            classdatestring=[NSString stringWithFormat:@"%@ (%@%@)",classdatestring,[df stringFromDate:date]?[NSString stringWithFormat:@"%@/",[df stringFromDate:date]]:@"",[((FreeScheduleClass *)[FreeScheduleClassArray objectAtIndex:i]).classtime isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD" language:@"Chinese"]:((FreeScheduleClass *)[FreeScheduleClassArray objectAtIndex:i]).classtime];
//            df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
//        }else{
//            if (i==0) {
//                classdatestring=[df stringFromDate:date]?[df stringFromDate:date]:@"TBD";
//            }else{
//                if (i%noofdayperline ==0) {
//                    classdatestring=[NSString stringWithFormat:@"%@\r\n%@",classdatestring,[df stringFromDate:date]?[df stringFromDate:date]:@"TBD"];
//                }else{
//                    classdatestring=[NSString stringWithFormat:@"%@, %@",classdatestring,[df stringFromDate:date]?[df stringFromDate:date]:@"TBD"];
//                }
//            }
//            [df setDateFormat:@"EEE"];
//            classdatestring=[NSString stringWithFormat:@"%@ (%@%@)",classdatestring,[df stringFromDate:date]?[NSString stringWithFormat:@"%@/",[df stringFromDate:date]]:@"",[((FreeScheduleClass *)[FreeScheduleClassArray objectAtIndex:i]).classtime isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD" language:@"Chinese"]:((FreeScheduleClass *)[FreeScheduleClassArray objectAtIndex:i]).classtime];
//        }
//    }
//    return classdatestring;
}

-(NSString *) returnclassdaywithclassdaystring:(NSString *)classdaystring
{
    NSMutableArray *classdaystringarray=[[NSMutableArray alloc]initWithArray:[classdaystring componentsSeparatedByString:@","]];
    for (int i=0; i<classdaystringarray.count; i++) {
        [classdaystringarray replaceObjectAtIndex:i withObject:[MyClass returntitlewithtitle:[classdaystringarray objectAtIndex:i]]];
    }
    return [classdaystringarray componentsJoinedByString:@","];
}

-(NSString *) returnclasstimewithclasstimestring:(NSString *)classtimestring
{
    NSMutableArray *classtimestringarray=[[NSMutableArray alloc]initWithArray:[classtimestring componentsSeparatedByString:@","]];
    for (int i=0; i<classtimestringarray.count; i++) {
        if ([[classtimestringarray objectAtIndex:i] isEqualToString:@"TBD"] || [[classtimestringarray objectAtIndex:i] isEqualToString:@"TBF"]  || [[classtimestringarray objectAtIndex:i] isEqualToString:@"Multi"]  ) {
                [classtimestringarray replaceObjectAtIndex:i withObject:[MyClass returntitlewithtitle:[classtimestringarray objectAtIndex:i]]];
        }
    }
    return [classtimestringarray componentsJoinedByString:@","];
}

-(void) loadtitle
{
    //viewtitle.text=[MyClass returntitlewithtitle:@"Financial Information"];
    title_Class_Student.text=[MyClass returntitlewithtitle:@"Student"];
    title_Sales_Student.text=[MyClass returntitlewithtitle:@"Student"];
    title_Subject.text=[MyClass returntitlewithtitle:@"Subject"];
    title_Enrollment.text=[MyClass returntitlewithtitle:@"Enrollment"];
    title_Day.text=[MyClass returntitlewithtitle:@"Class Day"];
    title_Time.text=[MyClass returntitlewithtitle:@"Time"];
    title_Start.text=[MyClass returntitlewithtitle:@"Start"];
    title_End.text=[MyClass returntitlewithtitle:@"End"];
    title_No_of_Class.text=[MyClass returntitlewithtitle:@"No. of Class"];
    title_Total_Fee.text=[MyClass returntitlewithtitle:@"Total Fee"];
    title_Paid.text=[MyClass returntitlewithtitle:@"Paid"];
    title_Outstanding.text=[MyClass returntitlewithtitle:@"Due"];
    //title_Contact.text=[MyClass returntitlewithtitle:@"Contact"];
    title_Order_Date.text=[MyClass returntitlewithtitle:@"Order Date"];
    title_Product.text=[MyClass returntitlewithtitle:@"Product"];
    title_Quantity.text=[MyClass returntitlewithtitle:@"Quantity"];
    for (int i=0; i<classdayarray.count; i++) {
        [scclassday setTitle:[MyClass returntitlewithtitle:[classdayarray objectAtIndex:i]] forSegmentAtIndex:i];
    }
    [scpaymenttype setTitle:[MyClass returntitlewithtitle:@"Class Enrollment"] forSegmentAtIndex:0];
    [scpaymenttype setTitle:[MyClass returntitlewithtitle:@"Sales Order"] forSegmentAtIndex:1];
    [OutstandingViewButton setTitle:[MyClass returntitlewithtitle:@"Outstanding"] forState:UIControlStateNormal];
    [BankinViewButton setTitle:[MyClass returntitlewithtitle:@"Cash and Cheque"] forState:UIControlStateNormal];

    title_product_Total_Fee.text=[MyClass returntitlewithtitle:@"Total Fee"];
    title_product_Paid.text=[MyClass returntitlewithtitle:@"Paid"];
    title_product_Outstanding.text=[MyClass returntitlewithtitle:@"Due"];
    //title_product_Contact.text=[MyClass returntitlewithtitle:@"Contact"];
    
    //title_bankin_New_Payment_Received.text=[MyClass returntitlewithtitle:@"New Payment Received"];
    title_bankin_Current_Center_Balance.text=[MyClass returntitlewithtitle:@"Current Center Balance"];
    title_bankin_Bank_in.text=[MyClass returntitlewithtitle:@"Withdrawal"];
    //title_bankin_newpayment_Cash.text=[MyClass returntitlewithtitle:@"Cash"];
    //title_bankin_balance_Cash.text=[MyClass returntitlewithtitle:@"Cash"];
    //title_bankin_newpayment_Cheque.text=[MyClass returntitlewithtitle:@"Cheque"];
    //title_bankin_balance_Cheque.text=[MyClass returntitlewithtitle:@"Cheque"];
    title_bankin_Bankin_Date.text=[MyClass returntitlewithtitle:@"Date"];
    //title_bankin_New_Received_Cash.text=[MyClass returntitlewithtitle:@"New Received Cash"];
    //title_bankin_New_Received_Cheque.text=[MyClass returntitlewithtitle:@"New Received Cheque"];
    title_bankin_Bankin_Record.text=[MyClass returntitlewithtitle:@"Amount"];
    //title_bankin_Bankin_Cheque.text=[MyClass returntitlewithtitle:@"Bankin Cheque"];
    title_bankin_Outstanding_Record.text=[MyClass returntitlewithtitle:@"Balance"];
    //title_bankin_Outstanding_Cheque.text=[MyClass returntitlewithtitle:@"Outstanding Cheque"];
    title_bankin_Bankin_Person.text=[MyClass returntitlewithtitle:@"Staff"];
    title_bankin_Remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    title_bankin_record.text=[MyClass returntitlewithtitle:@"Withdrawal Records"];
    
    [InvoiceTypeSC setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [InvoiceTypeSC setTitle:[MyClass returntitlewithtitle:@"Due"] forSegmentAtIndex:1];
    title_Invoice_Log.text=[MyClass returntitlewithtitle:@"Invoice Log"];
    title_Invoice_Item_Student.text=[MyClass returntitlewithtitle:@"Student"];
    title_Invoice_Item_Type.text=[MyClass returntitlewithtitle:@"Type"];
    title_Invoice_Item_Description.text=[MyClass returntitlewithtitle:@"Item Description"];
    title_Invoice_Item_Amount.text=[MyClass returntitlewithtitle:@"Amount"];
    title_Invoice_Item_Paid.text=[MyClass returntitlewithtitle:@"Paid"];
    
}

-(void) switchcenterbuttonpressed
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
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
/*
-(void) refreshpage
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyClass retrievemenuimagewithasync:YES];
        [MyClass retrievecenterimages];
        
        [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,product,staff,classroom,marketing,centersettings,userroleandprivilege" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
        [MyClass LoadSchoolCalendarArray];
        [self refreshlanguage];
        //[MyClass updatedevicetoken];
        [MyClass updatecenterkey];
        [self viewDidAppear:YES];
        
    });
}*/

-(void) reloadPageWithFirstLoad:(BOOL)firstload
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

            [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,student,subject,product,staff,classroom,centersettings,userroleandprivilege,marketing,arcode" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
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
                    //[MyClass retrievemenuimagewithasync:YES];
                    //[MyClass retrievecenterimages];
                    [MyClass updatecenterkey];
                    
//                    isSelectCombinePayment=FALSE;
                    if(isSelectCombinePayment){
                        [self combinepaymentbuttonpressed:nil];
                    }
                    globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys=[[NSMutableArray alloc]init];
                    globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys=[[NSMutableArray alloc]init];
                    globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys=[[NSMutableArray alloc]init];
                    globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys=[[NSMutableArray alloc]init];
                    globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys=[[NSMutableArray alloc]init];
                    globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys=[[NSMutableArray alloc]init];
                    
                    bankinbutton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).withdrawcash;
                    
                    [self refreshdocumentfoldercount];
                    
                    //[MyClass LoadSchoolCalendarArray];
                    //datePickerViewMenu=[[NSMutableArray alloc] initWithArray:globalvariables.alldayarray];
                    selectedinvoicelogkey=@"";
                    selectInvoiceButton.tag=0;
                    selectedpaiddate=@"";
                    title_view1.hidden=YES;
                    [self refreshlanguage];
                    [self loadscreen];
                    }
                    });
                
            }];
    });
}

-(void) classTableLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:OutstandingClassPaymentTable];
        NSIndexPath *indexPath = [OutstandingClassPaymentTable indexPathForRowAtPoint:point];
        
        if (indexPath) {
            OutstandingPaymentObject= [filteredOutstandingClassPaymentArray objectAtIndex:indexPath.row];
            
            if (![globalvariables.documentfolder.classpaymentarray containsObject:OutstandingPaymentObject.enrollmentkey]) {
                [globalvariables.documentfolder.classpaymentarray addObject:OutstandingPaymentObject.enrollmentkey];
            }
            
            if (![globalvariables.documentfolder.classinvoicearray containsObject:OutstandingPaymentObject.enrollmentkey]) {
                [globalvariables.documentfolder.classinvoicearray addObject:OutstandingPaymentObject.enrollmentkey];
            }
            
            
            if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""]) {
                if (![globalvariables.documentfolder.classreceiptarray containsObject:OutstandingPaymentObject.lastpaymentkey]) {
                    [globalvariables.documentfolder.classreceiptarray addObject:OutstandingPaymentObject.lastpaymentkey];
                }
            }
            
            
            
            if (![globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:OutstandingPaymentObject.enrollmentkey]) {
                if (![OutstandingPaymentObject.paid isEqualToString:OutstandingPaymentObject.totalfee]) {
                    [globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys addObject:OutstandingPaymentObject.enrollmentkey];
                }
            }
            
            if (![globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:OutstandingPaymentObject.enrollmentkey]) {
                [globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys addObject:OutstandingPaymentObject.enrollmentkey];
            }
            
            if (![OutstandingPaymentObject.lastpaymentkey isEqualToString:@""]) {
                if (![globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:OutstandingPaymentObject.enrollmentkey]) {
                    [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys addObject:OutstandingPaymentObject.enrollmentkey];
                }
            }
            
            [self showAddToDocumentFolderAnimationWithTableview:OutstandingClassPaymentTable IndexPath:indexPath];
            
            [self refreshdocumentfoldercount];
            
            
            
            
            
            isSelectCombinePayment=TRUE;
            [self refreshclasstableheader];
            [OutstandingClassPaymentTable reloadData];
        }
    }
}

-(void) salesTableLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:OutstandingSalesPaymentTable];
        NSIndexPath *indexPath = [OutstandingSalesPaymentTable indexPathForRowAtPoint:point];
        
        if (indexPath) {
            
            outstandingsalespaymentobject = [filteredOutstandingSalesPaymentArray objectAtIndex:indexPath.row];
            
            if (![globalvariables.documentfolder.salespaymentarray containsObject:outstandingsalespaymentobject.saleskey]) {
                [globalvariables.documentfolder.salespaymentarray addObject:outstandingsalespaymentobject.saleskey];
            }
            
            if (![globalvariables.documentfolder.salesinvoicearray containsObject:outstandingsalespaymentobject.saleskey]) {
                [globalvariables.documentfolder.salesinvoicearray addObject:outstandingsalespaymentobject.saleskey];
            }
            
            if (![outstandingsalespaymentobject.lastpaymentkey isEqualToString:@""]) {
                if (![globalvariables.documentfolder.salesreceiptarray containsObject:outstandingsalespaymentobject.lastpaymentkey]) {
                    [globalvariables.documentfolder.salesreceiptarray addObject:outstandingsalespaymentobject.lastpaymentkey];
                }
            }
            
            
            if (![globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:outstandingsalespaymentobject.saleskey]) {
                if (![outstandingsalespaymentobject.paid isEqualToString:outstandingsalespaymentobject.totalfee]) {
                    [globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys addObject:outstandingsalespaymentobject.saleskey];
                }
                
            }
            
            if (![globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:outstandingsalespaymentobject.saleskey]) {
                [globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys addObject:outstandingsalespaymentobject.saleskey];
            }
            
            if (![outstandingsalespaymentobject.lastpaymentkey isEqualToString:@""]) {
                if (![globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:outstandingsalespaymentobject.saleskey]) {
                    [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys addObject:outstandingsalespaymentobject.saleskey];
                }
            }
            
            
            [self showAddToDocumentFolderAnimationWithTableview:OutstandingSalesPaymentTable IndexPath:indexPath];
            
            [self refreshdocumentfoldercount];
            
            
            isSelectCombinePayment=TRUE;
            [self refreshsalestableheader];
            [OutstandingSalesPaymentTable reloadData];
        }
    }
}

-(void) invoiceTableLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:InvoiceLogItemTable];
        NSIndexPath *indexPath = [InvoiceLogItemTable indexPathForRowAtPoint:point];
        
        if (indexPath) {
            
            InvoiceLogItem *object=[((InvoiceLogRecord *)[filteredInvoiceLogArray objectAtIndex:selectedinvoicerow]).itemarray objectAtIndex:indexPath.row];
            if ([object.type isEqualToString:@"Sales"]) {
                if (![globalvariables.documentfolder.salespaymentarray containsObject:object.typekey]) {
                    [globalvariables.documentfolder.salespaymentarray addObject:object.typekey];
                }
                
                if (![globalvariables.documentfolder.salesinvoicearray containsObject:object.typekey]) {
                    [globalvariables.documentfolder.salesinvoicearray addObject:object.typekey];
                }
                
                if (![outstandingsalespaymentobject.lastpaymentkey isEqualToString:@""]) {
                    if (![globalvariables.documentfolder.salesreceiptarray containsObject:object.lastpaymentkey]) {
                        [globalvariables.documentfolder.salesreceiptarray addObject:object.lastpaymentkey];
                    }
                }
                
                
                if (![globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:object.typekey]) {
                    if (object.paid !=object.amount) {
                        [globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys addObject:object.typekey];
                    }
                    
                }
                
                if (![globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:object.typekey]) {
                    [globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys addObject:object.typekey];
                }
                
                if (![object.lastpaymentkey isEqualToString:@""]) {
                    if (![globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:object.typekey]) {
                        [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys addObject:object.typekey];
                    }
                }
            }else{
                if (![globalvariables.documentfolder.classpaymentarray containsObject:object.typekey]) {
                    [globalvariables.documentfolder.classpaymentarray addObject:object.typekey];
                }
                
                if (![globalvariables.documentfolder.classinvoicearray containsObject:object.typekey]) {
                    [globalvariables.documentfolder.classinvoicearray addObject:object.typekey];
                }
                
                
                if (![object.lastpaymentkey isEqualToString:@""]) {
                    if (![globalvariables.documentfolder.classreceiptarray containsObject:object.lastpaymentkey]) {
                        [globalvariables.documentfolder.classreceiptarray addObject:object.lastpaymentkey];
                    }
                }
                
                
                
                if (![globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:object.typekey]) {
                    if (object.paid!=object.amount) {
                        [globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys addObject:object.typekey];
                    }
                }
                
                if (![globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:object.typekey]) {
                    [globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys addObject:object.typekey];
                }
                
                if (![object.lastpaymentkey isEqualToString:@""]) {
                    if (![globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:object.typekey]) {
                        [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys addObject:object.typekey];
                    }
                }
            }
            
            [self showAddToDocumentFolderAnimationWithTableview:InvoiceLogItemTable IndexPath:indexPath];
            
            [self refreshdocumentfoldercount];
            
            
            selectInvoiceButton.tag=1;
            title_view1.hidden=NO;;
            [InvoiceLogItemTable reloadData];
        }
    }
}


- (IBAction)combinepaymentbuttonpressed:(id)sender {
    
    isSelectCombinePayment=!isSelectCombinePayment;
    if (scpaymenttype.selectedSegmentIndex==0) {
        [OutstandingClassPaymentTable reloadData];
        [self refreshclasstableheader];
    }else{
        [OutstandingSalesPaymentTable reloadData];
        [self refreshsalestableheader];
    }
    
    selectoutstandingview.hidden=!isSelectCombinePayment;
}

-(void) refreshclasstableheader
{
    long combinepaymentoffset=isSelectCombinePayment?35:0;
    title_Class_Student.frame=CGRectMake(9+combinepaymentoffset,1,title_Class_Student.frame.size.width,21);
    title_Subject.frame=CGRectMake(title_Class_Student.frame.origin.x+title_Class_Student.frame.size.width+combinepaymentoffset,1,66,21);

}

-(void) refreshsalestableheader
{
    long combinepaymentoffset=isSelectCombinePayment?35:0;
    title_Sales_Student.frame=CGRectMake(9+combinepaymentoffset,1,title_Sales_Student.frame.size.width,21);
    title_Product.frame=CGRectMake(title_Sales_Student.frame.origin.x+title_Sales_Student.frame.size.width+combinepaymentoffset,5,280,21);
    
}

-(void) returnfilteroutstandingclassarray
{
    if ([outstandingclasssearchbar.text isEqualToString:@""]) {
        filteredOutstandingClassPaymentArray= [[NSMutableArray alloc]initWithArray:OutstandingClassPaymentArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.studentfullname contains[c] %@ or self.subject contains[c] %@ or self.subjectfullname contains[c] %@ or self.classday contains[c] %@ or self.totalfee contains[c] %@ or self.parentcontact contains[c] %@ or self.studentid contains[c] %@",outstandingclasssearchbar.text,outstandingclasssearchbar.text,outstandingclasssearchbar.text,outstandingclasssearchbar.text,outstandingclasssearchbar.text,outstandingclasssearchbar.text,outstandingclasssearchbar.text];
        filteredOutstandingClassPaymentArray= [[NSMutableArray alloc]initWithArray:[OutstandingClassPaymentArray filteredArrayUsingPredicate:predicate]];
    }
    
    [self sortoutstandingclasslist];
}

-(void) returnfilteroutstandingsalesarray
{
    if ([outstandingsalessearchbar.text isEqualToString:@""]) {
        filteredOutstandingSalesPaymentArray= [[NSMutableArray alloc]initWithArray:OutstandingSalesPaymentArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.studentfullname contains[c] %@ or self.product contains[c] %@ or self.productfullname contains[c] %@ or self.totalfee contains[c] %@ or self.parentcontact contains[c] %@ or self.studentid contains[c] %@",outstandingsalessearchbar.text,outstandingsalessearchbar.text,outstandingsalessearchbar.text,outstandingsalessearchbar.text,outstandingsalessearchbar.text,outstandingsalessearchbar.text];
        filteredOutstandingSalesPaymentArray= [[NSMutableArray alloc]initWithArray:[OutstandingSalesPaymentArray filteredArrayUsingPredicate:predicate]];
    }
    
    [self sortoutstandingsaleslist];
}

-(void) sortoutstandingclasslist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarraywithpaymenttype:0];
    
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        if ([sortingobject.item isEqualToString:@"subject_name"]) {
            sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:[globalvariables.language isEqualToString:@"English"]?@"subject_englishname":@"subject_chinesename" ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        }else{
            sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        }
        
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:@"type" ascending:NO];
    [sortDescriptorsArray addObject:sortdescriptor];
    
    filteredOutstandingClassPaymentArray=[NSMutableArray arrayWithArray:[filteredOutstandingClassPaymentArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    [OutstandingClassPaymentTable reloadData];
    
}

-(void) sortoutstandingsaleslist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarraywithpaymenttype:1];
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        if ([sortingobject.item isEqualToString:@"subject_name"]) {
            sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:[globalvariables.language isEqualToString:@"English"]?@"subject_englishname":@"subject_chinesename" ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        }else{
            sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        }
        
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    filteredOutstandingSalesPaymentArray=[NSMutableArray arrayWithArray:[filteredOutstandingSalesPaymentArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    [OutstandingSalesPaymentTable reloadData];
    
}


-(void) returnsortingarraywithpaymenttype:(long)paymenttypeindex
{
    if (paymenttypeindex==0) {
        sortingarray=[MyClass returnsortingarraywithtype:@"financialclasslistsortingorder"];
    }else{
        sortingarray=[MyClass returnsortingarraywithtype:@"financialsaleslistsortingorder"];
    }
}

- (IBAction)sortingbuttonpressed:(UIButton *)sender
{
    [self returnsortingarraywithpaymenttype:scpaymenttype.selectedSegmentIndex];
    
    sortingtable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    sortingtable.delegate=self;
    sortingtable.dataSource=self;
    sortingtable.scrollEnabled=NO;
    sortingtable.editing=YES;
    [sortingtable reloadData];
    
    sortingtable.frame=CGRectMake(0, 0, 220, sortingtable.contentSize.height);
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
    }
    return NO;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==InvoiceLogRecordTable) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
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
    
    if (scpaymenttype.selectedSegmentIndex==0) {
        [MyClass updatelocaldbwithparameter:@"financialclasslistsortingorder" value:sortingstring];
    }else{
        [MyClass updatelocaldbwithparameter:@"financialsaleslistsortingorder" value:sortingstring];
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
    
    if (scpaymenttype.selectedSegmentIndex==0) {
        [self sortoutstandingclasslist];
    }else{
        [self sortoutstandingsaleslist];
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
    if (toIndexPath.section==0 && (fromIndexPath.row !=toIndexPath.row)) {
        sortingobject=[sortingarray objectAtIndex:fromIndexPath.row];
        [sortingarray removeObjectAtIndex:fromIndexPath.row];
        [sortingarray insertObject:sortingobject atIndex:toIndexPath.row];
        
        [self updatesortingstring];
        if (scpaymenttype.selectedSegmentIndex==0) {
            [self sortoutstandingclasslist];
        }else{
            [self sortoutstandingsaleslist];
        }
        //filteredStudentArray=[MyClass sortstudentlistwithstudentarray:filteredStudentArray sortingarray:sortingarray];
        
    }
}


-(NSString *) returnsortinglabelwithitem:(NSString *)item
{
    
    if ([item isEqualToString:@"studentfullname"]) {
        return @"Student Name";
    }else if ([item isEqualToString:@"subjectfullname"]) {
        return @"Subject";
    }else if ([item isEqualToString:@"enrollmentdate"]) {
        return @"Enrollment Date";
    }else if ([item isEqualToString:@"productfullname"]) {
        return @"Product";
    }else if ([item isEqualToString:@"orderdate"]) {
        return @"Order Date";
    }else if ([item isEqualToString:@"startdate"]) {
        return @"Start Date";
    }else if ([item isEqualToString:@"enddate"]) {
        return @"End Date";
    }else if ([item isEqualToString:@"totalfee"]) {
        return @"Total Fee";
    }
    
    return item;
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar==outstandingclasssearchbar) {
        [self returnfilteroutstandingclassarray];
        //[subjecttable reloadData];
        [OutstandingClassPaymentTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==outstandingsalessearchbar) {
        [self returnfilteroutstandingsalesarray];
        //[stafftable reloadData];
        [OutstandingSalesPaymentTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==invoiceSearchField){
        selectedinvoicelogkey=@"";
        [self returnfilterinvoicelogarraywithsort:YES];
        [InvoiceLogRecordTable reloadData];
    }else if (searchBar==paymentreceivedSearchField){
        selectedpaiddate=@"";
        [self returnfilterpaymentreceivedarray];
    }
}


-(void) refreshparentviewdocumentfoldercount
{
    [self refreshdocumentfoldercount];
}

-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width
{
    UIWindow *window = self.view.window ? self.view.window : mainWindow;
    if (!window) {
        return;
    }
    mainWindow = window;
    if (ailoadindicator.hidden && sidewindowview.frame.origin.x==window.bounds.size.width) {
        return;
    }
    
    if (window.bounds.size.width-width == sidewindowview.frame.origin.x && fabs(sidewindowview.frame.size.height - window.bounds.size.height) < 0.5) {
        return;
    }
    
    if (width>0 && sidewindowview.frame.origin.x== window.bounds.size.width) {
        [MyClass playsoundwithoption:@"open"];
    }
    
    self.sideWindowAdjusting = YES;
    [UIView animateWithDuration:0.25f animations:^{
        sidewindowview.hidden = width<=0;
        sidewindowview.frame=CGRectMake(window.bounds.size.width-width, 0, width, window.bounds.size.height);
        for (UIView *panelChild in sidewindowview.subviews) {
            if ([panelChild isKindOfClass:[UIActivityIndicatorView class]]) {
                continue;
            }
            panelChild.frame = sidewindowview.bounds;
        }
        if (width==0 && sidewindowview.frame.origin.x< window.bounds.size.width) {
            [MyClass playsoundwithoption:@"close"];
        }
    } completion:^(BOOL finished){
        self.sideWindowAdjusting = NO;
        if (width > 0) {
            [self pinPaymentSideWindow];
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
    if (scpaymenttype.selectedSegmentIndex==0) {
        //class
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSString *lastselectedParentRow=selectedParentRow;
            selectedParentRow=@"";
            if ([self retrieveOutstandingClassPaymentRecordWithClassday:[classdayarray objectAtIndex:[scclassday selectedSegmentIndex]] enrollmentkeystring:selectedParentRow]) {
                [self updateOutstandingValue];
            }else{
                selectedParentRow=lastselectedParentRow;
            }
        });
    }else{
        //sales
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self retrieveOutstandingPaymentSales]) {
                [self updateOutstandingValue];
            }
        });
    }
    
    
}

-(void) startsidewindowanimationwithwidth:(float)width
{
    ailoadindicator.hidden=NO;
    ailoadindicator.center = CGPointMake(width/2-7.5,mainWindow.frame.size.height/2-7.5);
    [ailoadindicator startAnimating];
    [self adjustpresentingviewwidthwithwidth:width];
}

-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    NSString *selecteddatestring=[selecteddatearray firstObject];
    
    if ([selectedItem isEqualToString:@"DetailsPayment"]){
        tmpPaidDate=selecteddatestring;
        //showPaymentDatePicker=NO;
        
        tmpPaidDate=selecteddatestring;
        
        [DetailsPaymentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:1]] withRowAnimation:UITableViewRowAnimationAutomatic];

    }
}


- (IBAction)changeview:(UIButton *)sender {
    [self refreshdocumentfoldercount];
    
    if (sender==OutstandingViewButton && PaymentView.hidden) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        OutstandingViewButton.enabled=NO;
        BankinViewButton.enabled=YES;
        InvoiceViewButton.enabled=YES;
        PaymentViewButton.enabled=YES;
        
        
        //[OutstandingViewButton setTitle:[MyClass returntitlewithtitle:@"Manual Renewal"] forState:UIControlStateNormal];
        [BankinViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [OutstandingViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [InvoiceViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [PaymentViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        [UIView animateWithDuration:0.3f animations:^{
            [self layoutPaymentMenuHighlight];
        } completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveOutstandingClassPaymentRecordWithClassday:[classdayarray objectAtIndex:[scclassday selectedSegmentIndex]] enrollmentkeystring:@""];
            //scclassday.hidden=NO;
            PaymentView.hidden=NO;
            BankinView.hidden=YES;
            InvoiceView.hidden=YES;
            PaymentReceivedView.hidden=YES;
            //bankinbutton.hidden=YES;
            //title_bankin_Bank_in.hidden=YES;
            //documentfolderbutton.hidden=NO;
            [self updateOutstandingValue];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }else if (sender==BankinViewButton && BankinView.hidden){
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        OutstandingViewButton.enabled=YES;
        BankinViewButton.enabled=NO;
        InvoiceViewButton.enabled=YES;
        PaymentViewButton.enabled=YES;
        
        [BankinViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [OutstandingViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [InvoiceViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [PaymentViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];

        [UIView animateWithDuration:0.3f animations:^{
            [self layoutPaymentMenuHighlight];
        } completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveOutstandingBankinRecord];
            //scclassday.hidden=YES;
            PaymentView.hidden=YES;
            BankinView.hidden=NO;
            InvoiceView.hidden=YES;
            PaymentReceivedView.hidden=YES;
            //bankinbutton.hidden=NO;
            //title_bankin_Bank_in.hidden=NO;
            //documentfolderbutton.hidden=YES;
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }else if (sender==InvoiceViewButton && InvoiceView.hidden){
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        OutstandingViewButton.enabled=YES;
        BankinViewButton.enabled=YES;
        InvoiceViewButton.enabled=NO;
        PaymentViewButton.enabled=YES;

        [BankinViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [OutstandingViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [InvoiceViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [PaymentViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3f animations:^{
            [self layoutPaymentMenuHighlight];
        } completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveInvoiceLog];
            //scclassday.hidden=YES;
            PaymentView.hidden=YES;
            BankinView.hidden=YES;
            InvoiceView.hidden=NO;
            PaymentReceivedView.hidden=YES;
            //bankinbutton.hidden=NO;
            //title_bankin_Bank_in.hidden=NO;
            //documentfolderbutton.hidden=YES;
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }else if (sender==PaymentViewButton && PaymentReceivedView.hidden){
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        OutstandingViewButton.enabled=YES;
        BankinViewButton.enabled=YES;
        InvoiceViewButton.enabled=YES;
        PaymentViewButton.enabled=NO;

        [BankinViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [OutstandingViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [InvoiceViewButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [PaymentViewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView animateWithDuration:0.3f animations:^{
            [self layoutPaymentMenuHighlight];
        } completion:nil];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrievePaymentReceived];
            //scclassday.hidden=YES;
            PaymentView.hidden=YES;
            BankinView.hidden=YES;
            InvoiceView.hidden=YES;
            PaymentReceivedView.hidden=NO;
            //bankinbutton.hidden=NO;
            //title_bankin_Bank_in.hidden=NO;
            //documentfolderbutton.hidden=YES;
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }
}

-(void) autosendereceiptwithtype:(NSString *)type
{
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        paymentindexpath=[NSIndexPath indexPathForRow:0 inSection:0];
        
        if([type isEqualToString:@"Class"]){
            NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Receipt"];
            if (classday) {
                ClassReceiptRecord *classreceiptrecord=[[ClassReceiptRecord alloc]initClassReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.oneoffdiscount floatValue]+[PopoverEnrollment.recursivediscount floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain paymentkey:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paiddate paid:PopoverEnrollment.paid paidmethod:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment paymentremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentremarks subjectname:nil];
                
                
                NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] SalesReceiptArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                if (pdfdata) {
                    [self messagePDF:pdfdata studentkeys:[[NSMutableArray alloc]initWithObjects:PopoverEnrollment.studentkey, nil] pdfType:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] salesreceiptarray:nil]];
                }
            }
        }else{
            SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:nil totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
            
            NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:nil SalesReceiptArray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
            
            if (pdfdata) {
                [self messagePDF:pdfdata studentkeys:[[NSMutableArray alloc]initWithObjects:PopoverEnrollment.studentkey, nil] pdfType:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:nil salesreceiptarray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil]]];
            }
        }

    //});
    
}

-(void) messagePDF:(NSData *)pdfData studentkeys:(NSMutableArray *)studentkeys pdfType:(NSString *)pdftype filename:(NSString *)filename
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
    
    //[object.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:nil Width:0 Height:0 Type:@"pdf" Data:pdfData FileName:[NSString stringWithFormat:@"%@.pdf", object.messageenglish]]];
    

    
    MessagePopoverViewController *viewController = (MessagePopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MessagePopoverViewController"];
    //viewController.delegate=self;
    [viewController sendMessageWithOutBoxMessage:object];
    [[mySharePopovercontroller presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    

    
}

-(void) retrieveInvoiceLog
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getinvoicelog",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewpaymentinformation"]];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
                
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
                
                //Set up our class array
                InvoiceLogArray=[[NSMutableArray alloc] init];
                
                //loop through our jsonArray
                for (int i=0; i<JSONArray.count; i++) {
                    
                    //Create our Instructor object
                    NSDate * createtime=[MyClass convertToNSDateWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"createtime"]  DateFormat:@"yyyy-MM-dd HH:mm:ss"];
                    NSString * invoicelogkey=[[JSONArray objectAtIndex:i] objectForKey:@"invoicelogkey"];
                    NSString * invoicenumber=[[JSONArray objectAtIndex:i] objectForKey:@"invoicenumber"];
                    NSString * staff=[[JSONArray objectAtIndex:i] objectForKey:@"staff"];
                    
                    NSArray * itemrecordsarray=[[JSONArray objectAtIndex:i] objectForKey:@"itemrecords"];
                    NSMutableArray *itemarray=[[NSMutableArray alloc]init];
                    float totalpaid=0;
                    float totalamount=0;
                    for (int j=0; j<itemrecordsarray.count; j++) {
                        NSString * studentkey=[[itemrecordsarray objectAtIndex:j] objectForKey:@"studentkey"];
                        NSString * type=[[itemrecordsarray objectAtIndex:j] objectForKey:@"type"];
                        NSString * typekey=[[itemrecordsarray objectAtIndex:j] objectForKey:@"typekey"];
                        NSString * itemcode=[[itemrecordsarray objectAtIndex:j] objectForKey:@"itemcode"];
                        float amount=[[[itemrecordsarray objectAtIndex:j] objectForKey:@"amount"] floatValue];
                        float paid=[[[itemrecordsarray objectAtIndex:j] objectForKey:@"paid"] floatValue];
                        NSString * lastpaymentkey=[[itemrecordsarray objectAtIndex:j] objectForKey:@"lastpaymentkey"];
                        
                        NSString * itemdescription;
                        if ([type isEqualToString:@"Class"]) {
                            itemdescription=[MyClass returnsubjectnamewithsubject_shortname:itemcode centerkey:globalvariables.centerrecord.centerkey];
                        }else{
                            itemdescription=[MyClass returnproductnamewithproductcode:itemcode centerkey:globalvariables.centerrecord.centerkey];
                        }
                        
                        NSString *studentfullname=[MyClass returnStudentnameWithStudentkey:studentkey option:@"full"];
                        [itemarray addObject:[[InvoiceLogItem alloc]initInvoiceLogItemWithStudentKey:studentkey Type:type TypeKey:typekey ItemCode:itemcode Amount:amount Paid:paid studentfullname:studentfullname itemdescription:itemdescription lastpaymentkey:lastpaymentkey]];
                        
                        totalamount+=amount;
                        totalpaid+=paid;
                    }
                    
                    [InvoiceLogArray addObject:[[InvoiceLogRecord alloc]initInvoiceLogRecordWithInvoiceLogKey:invoicelogkey InvoiceNumber:invoicenumber CreateTime:createtime Staff:staff TotalAmount:totalamount TotalPaid:totalpaid ItemArray:itemarray]];
                }
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            result=TRUE;
            
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
        JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            InvoiceLogArray=[[NSMutableArray alloc] init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our Instructor object
                NSDate * createtime=[MyClass convertToNSDateWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"createtime"]  DateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSString * invoicelogkey=[[JSONArray objectAtIndex:i] objectForKey:@"invoicelogkey"];
                NSString * invoicenumber=[[JSONArray objectAtIndex:i] objectForKey:@"invoicenumber"];
                NSString * staff=[[JSONArray objectAtIndex:i] objectForKey:@"staff"];
                
                NSArray * itemrecordsarray=[[JSONArray objectAtIndex:i] objectForKey:@"itemrecords"];
                NSMutableArray *itemarray=[[NSMutableArray alloc]init];
                float totalpaid=0;
                float totalamount=0;
                for (int j=0; j<itemrecordsarray.count; j++) {
                    NSString * studentkey=[[itemrecordsarray objectAtIndex:j] objectForKey:@"studentkey"];
                    NSString * type=[[itemrecordsarray objectAtIndex:j] objectForKey:@"type"];
                    NSString * typekey=[[itemrecordsarray objectAtIndex:j] objectForKey:@"typekey"];
                    NSString * itemcode=[[itemrecordsarray objectAtIndex:j] objectForKey:@"itemcode"];
                    float amount=[[[itemrecordsarray objectAtIndex:j] objectForKey:@"amount"] floatValue];
                    float paid=[[[itemrecordsarray objectAtIndex:j] objectForKey:@"paid"] floatValue];
                    NSString * lastpaymentkey=[[itemrecordsarray objectAtIndex:j] objectForKey:@"lastpaymentkey"];
                    
                    NSString * itemdescription;
                    if ([type isEqualToString:@"Class"]) {
                        itemdescription=[MyClass returnsubjectnamewithsubject_shortname:itemcode centerkey:globalvariables.centerrecord.centerkey];
                    }else{
                        itemdescription=[MyClass returnproductnamewithproductcode:itemcode centerkey:globalvariables.centerrecord.centerkey];
                    }
                    
                    NSString *studentfullname=[MyClass returnStudentnameWithStudentkey:studentkey option:@"full"];
                    [itemarray addObject:[[InvoiceLogItem alloc]initInvoiceLogItemWithStudentKey:studentkey Type:type TypeKey:typekey ItemCode:itemcode Amount:amount Paid:paid studentfullname:studentfullname itemdescription:itemdescription lastpaymentkey:lastpaymentkey]];
                    
                    totalamount+=amount;
                    totalpaid+=paid;
                }
                
                [InvoiceLogArray addObject:[[InvoiceLogRecord alloc]initInvoiceLogRecordWithInvoiceLogKey:invoicelogkey InvoiceNumber:invoicenumber CreateTime:createtime Staff:staff TotalAmount:totalamount TotalPaid:totalpaid ItemArray:itemarray]];
            }
            
            
        }else{
            [MyClass showconnectionlostdialogbox];
        }
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        [self returnfilterinvoicelogarraywithsort:YES];
    }
}

-(void) returnfilterinvoicelogarraywithsort:(BOOL)sort
{
    
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (InvoiceTypeSC.selectedSegmentIndex==1) {
        newCondition = [NSPredicate predicateWithFormat:@"self.totalamount != self.totalpaid"];
        [nsPredicatearray addObject:newCondition];
    }
    
    
    if (![invoiceSearchField.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.invoicenumber contains[c] %@ or any itemarray.studentkey contains[c] %@ or any itemarray.itemcode contains[c] %@ or any itemarray.itemdescription contains[c] %@ or any itemarray.studentfullname contains[c] %@",invoiceSearchField.text,invoiceSearchField.text,invoiceSearchField.text,invoiceSearchField.text,invoiceSearchField.text];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredInvoiceLogArray= [[NSMutableArray alloc]initWithArray:[InvoiceLogArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredInvoiceLogArray= [[NSMutableArray alloc]initWithArray:InvoiceLogArray];
    }
    
    if ([selectedinvoicelogkey isEqualToString:@""]) {
        if (filteredInvoiceLogArray.count>0) {
            selectedinvoicelogkey=((InvoiceLogRecord *)[filteredInvoiceLogArray firstObject]).invoicelogkey;
            selectedinvoicerow=0;
        }
    }/*else{
      selectedinvoicelogkey=@"";
      selectedinvoicelogitems=nil;
      }*/
    
    if(filteredInvoiceLogArray.count==0){
        selectedinvoicelogkey=@"";
        noInvoiceRecordLabel.hidden=NO;
    }else{
        noInvoiceRecordLabel.hidden=YES;
    }
    
    
    [InvoiceLogRecordTable reloadData];
    [InvoiceLogItemTable reloadData];
    
}

-(void) deleteinvoicelog:(NSString *)invoicelogkey
{
    UIAlertController *deleteassessmentresponse = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Invoice Log"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the invoice log?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [MyClass loadingindicatorwithoption:@"start" color:@"white"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //update remarks to mysql
            //NSString *invoicelogkey=((InvoiceLogRecord *)[filteredInvoiceLogArray objectAtIndex:sender.tag]).invoicelogkey;
            NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deleteinvoicelog&invoicelogkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,invoicelogkey];
            
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
                }
                dispatch_semaphore_signal(semaphore);
            }] resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
            
            if(result){
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                
                //if ([selectedinvoicelogkey isEqualToString:invoicelogkey]) {
                selectedinvoicelogkey=nil;
                //selectedinvoicelogitems=nil;
                //}
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self retrieveInvoiceLog];
                    [MyClass loadingindicatorwithoption:@"stop" color:nil];
                });
                
            }
        });
        
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [deleteassessmentresponse dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [deleteassessmentresponse addAction:OKAction];
    [deleteassessmentresponse addAction:CancelAction];
    
    [self presentViewController:deleteassessmentresponse animated:YES completion:nil];

}

-(void) retrievePaymentReceived
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getpaymentreceived&arckey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewpaymentinformation"],[MyClass returndefaultarckey]];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            //Set up our class array
            PaymentReceivedDetailsRecordsArray=[[NSMutableArray alloc] init];
            PaymentReceivedRecordsArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our Instructor object
                NSString * paymentkey=[[JSONArray objectAtIndex:i] objectForKey:@"paymentkey"];
                NSString * paymenttypekey=[[JSONArray objectAtIndex:i] objectForKey:@"paymenttypekey"];
                NSString * paiddate=[[JSONArray objectAtIndex:i] objectForKey:@"paiddate"];
                NSString * studentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                NSString * paymenttype=[[JSONArray objectAtIndex:i] objectForKey:@"paymenttype"];
                NSString * subject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString * noofclass=[[JSONArray objectAtIndex:i] objectForKey:@"noofclass"];
                NSString * product=[[JSONArray objectAtIndex:i] objectForKey:@"product"];
                NSString * quantity=[[JSONArray objectAtIndex:i] objectForKey:@"quantity"];
                NSString * paymentremarks=[[JSONArray objectAtIndex:i] objectForKey:@"paymentremarks"];
                NSString * receiptremarks=[[JSONArray objectAtIndex:i] objectForKey:@"receiptremarks"];
                NSString * remarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                NSString * staffname=[[JSONArray objectAtIndex:i] objectForKey:@"staffname"];
                NSString * paidmethod=[[JSONArray objectAtIndex:i] objectForKey:@"paidmethod"];
                NSString * paidamount=[[JSONArray objectAtIndex:i] objectForKey:@"paidamount"];
                NSString * studentfullname=[MyClass returnStudentnameWithStudentkey:studentkey option:@"full"];
                
                NSString * itemdescription;
                
                if ([paymenttype isEqualToString:@"Class"]) {
                    itemdescription=[NSString stringWithFormat:@"%@/%@",[MyClass returnsubjectnamewithsubject_shortname:subject centerkey:globalvariables.centerrecord.centerkey],subject];
                }else{
                    itemdescription=[NSString stringWithFormat:@"%@/%@",[MyClass returnproductnamewithproductcode:product centerkey:globalvariables.centerrecord.centerkey],product];
                }

                [PaymentReceivedDetailsRecordsArray addObject:[[PaymentReceivedDetailsRecord alloc]initPaymentReceivedDetailsRecordwithpaymentkey:paymentkey paiddate:paiddate studentkey:studentkey paymenttype:paymenttype subject:subject noofclass:noofclass product:product quantity:quantity paymentremarks:paymentremarks receiptremarks:receiptremarks remarks:remarks staffname:staffname paidmethod:paidmethod paidamount:paidamount studentfullname:studentfullname itemdescription:itemdescription paymenttypekey:paymenttypekey]];
            }
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            //Set up our class array
            PaymentReceivedDetailsRecordsArray=[[NSMutableArray alloc] init];
            PaymentReceivedRecordsArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our Instructor object
                NSString * paymentkey=[[JSONArray objectAtIndex:i] objectForKey:@"paymentkey"];
                NSString * paymenttypekey=[[JSONArray objectAtIndex:i] objectForKey:@"paymenttypekey"];
                NSString * paiddate=[[JSONArray objectAtIndex:i] objectForKey:@"paiddate"];
                NSString * studentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                NSString * paymenttype=[[JSONArray objectAtIndex:i] objectForKey:@"paymenttype"];
                NSString * subject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString * noofclass=[[JSONArray objectAtIndex:i] objectForKey:@"noofclass"];
                NSString * product=[[JSONArray objectAtIndex:i] objectForKey:@"product"];
                NSString * quantity=[[JSONArray objectAtIndex:i] objectForKey:@"quantity"];
                NSString * paymentremarks=[[JSONArray objectAtIndex:i] objectForKey:@"paymentremarks"];
                NSString * receiptremarks=[[JSONArray objectAtIndex:i] objectForKey:@"receiptremarks"];
                NSString * remarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                NSString * staffname=[[JSONArray objectAtIndex:i] objectForKey:@"staffname"];
                NSString * paidmethod=[[JSONArray objectAtIndex:i] objectForKey:@"paidmethod"];
                NSString * paidamount=[[JSONArray objectAtIndex:i] objectForKey:@"paidamount"];
                NSString * studentfullname=[MyClass returnStudentnameWithStudentkey:studentkey option:@"full"];
                
                NSString * itemdescription;
                
                if ([paymenttype isEqualToString:@"Class"]) {
                    itemdescription=[NSString stringWithFormat:@"%@/%@",[MyClass returnsubjectnamewithsubject_shortname:subject centerkey:globalvariables.centerrecord.centerkey],subject];
                }else{
                    itemdescription=[NSString stringWithFormat:@"%@/%@",[MyClass returnproductnamewithproductcode:product centerkey:globalvariables.centerrecord.centerkey],product];
                }

                [PaymentReceivedDetailsRecordsArray addObject:[[PaymentReceivedDetailsRecord alloc]initPaymentReceivedDetailsRecordwithpaymentkey:paymentkey paiddate:paiddate studentkey:studentkey paymenttype:paymenttype subject:subject noofclass:noofclass product:product quantity:quantity paymentremarks:paymentremarks receiptremarks:receiptremarks remarks:remarks staffname:staffname paidmethod:paidmethod paidamount:paidamount studentfullname:studentfullname itemdescription:itemdescription paymenttypekey:paymenttypekey]];
            }
            

        }else{
            [MyClass showconnectionlostdialogbox];
        }
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        [self returnfilterpaymentreceivedarray];
    }
}

-(void) returnfilterpaymentreceivedarray
{
    
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (![paymentreceivedSearchField.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.paymentkey contains[c] %@ or self.studentkey contains[c] %@ or self.studentfullname contains[c] %@ or self.itemdescription contains[c] %@ or self.subject contains[c] %@ or self.product contains[c] %@ or self.remarks contains[c] %@ or self.paymentremarks contains[c] %@ or self.receiptremarks contains[c] %@ ",paymentreceivedSearchField.text,paymentreceivedSearchField.text,paymentreceivedSearchField.text,paymentreceivedSearchField.text,paymentreceivedSearchField.text,paymentreceivedSearchField.text,paymentreceivedSearchField.text,paymentreceivedSearchField.text,paymentreceivedSearchField.text];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredPaymentReceivedDetailsRecordsArray= [[NSMutableArray alloc]initWithArray:[PaymentReceivedDetailsRecordsArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredPaymentReceivedDetailsRecordsArray= [[NSMutableArray alloc]initWithArray:PaymentReceivedDetailsRecordsArray];
    }
    
    [self groupPaymentReceivedRecords];
    
    if ([selectedpaiddate isEqualToString:@""]) {
        if (PaymentReceivedRecordsArray.count>0) {
            selectedpaiddate=((PaymentReceivedRecord *)[PaymentReceivedRecordsArray firstObject]).paiddate;
            selectedpaiddaterow=0;
        }
    }
    
    if(PaymentReceivedRecordsArray.count==0){
        selectedpaiddate=@"";
        noPaymentReceivedRecordLabel.hidden=NO;
    }else{
        noPaymentReceivedRecordLabel.hidden=YES;
    }

    
    [PaymentReceivedTable reloadData];
    [PaymentReceivedDetailsTable reloadData];

}

-(void) groupPaymentReceivedRecords
{
    //sort by paiddate and student full name
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:@"paiddate" ascending:NO];
    [sortDescriptorsArray addObject:sortdescriptor];
    sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:@"studentfullname" ascending:YES selector:@selector(localizedStandardCompare:)];
    [sortDescriptorsArray addObject:sortdescriptor];
    
    filteredPaymentReceivedDetailsRecordsArray=[NSMutableArray arrayWithArray:[filteredPaymentReceivedDetailsRecordsArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    
    //group records by paiddate
    PaymentReceivedDetailsRecord *object;
    PaymentReceivedRecordsArray=[[NSMutableArray alloc]init];
    NSMutableArray *paymentrecords=[[NSMutableArray alloc]init];
    NSMutableDictionary *paiddict=[[NSMutableDictionary alloc]init];
    
    NSString *lastpaiddate=@"";
    for (int i=0; i<filteredPaymentReceivedDetailsRecordsArray.count; i++) {
        object=[filteredPaymentReceivedDetailsRecordsArray objectAtIndex:i];
        if (![object.paiddate isEqualToString:lastpaiddate]) {
            if (paymentrecords.count>0) {
                [PaymentReceivedRecordsArray addObject:[[PaymentReceivedRecord alloc]initPaymentReceivedRecordwithpaiddate:lastpaiddate paymentrecords:paymentrecords paiddict:paiddict]];
            }
            lastpaiddate=object.paiddate;
            paymentrecords=[[NSMutableArray alloc]init];
            paiddict=[[NSMutableDictionary alloc]init];
        }
        [paymentrecords addObject:object];
        NSString *totalamount=[paiddict valueForKey:object.paidmethod];
        if (totalamount) {
            totalamount=[NSString stringWithFormat:@"%f",[totalamount floatValue]+[object.paidamount floatValue]];
            [paiddict removeObjectForKey:object.paidmethod];
            [paiddict setValue:totalamount forKey:object.paidmethod];
        }else{
            [paiddict setValue:object.paidamount forKey:object.paidmethod];
        }
        
        if (i==filteredPaymentReceivedDetailsRecordsArray.count-1) {
            [PaymentReceivedRecordsArray addObject:[[PaymentReceivedRecord alloc]initPaymentReceivedRecordwithpaiddate:lastpaiddate paymentrecords:paymentrecords paiddict:paiddict]];
        }
    }
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"sharedocument"]) {
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"Print"]) {
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                 if (scpaymenttype.selectedSegmentIndex==0) {
                     if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                         NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Receipt"];
                         if (classday) {
                             ClassReceiptRecord *classreceiptrecord=[[ClassReceiptRecord alloc]initClassReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.oneoffdiscount floatValue]+[PopoverEnrollment.recursivediscount floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain paymentkey:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paiddate paid:PopoverEnrollment.paid paidmethod:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment paymentremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentremarks subjectname:nil];
                             
                             
                             NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] SalesReceiptArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                             if (pdfdata) {
                                 [self printPDF:pdfdata];
                             }
                         }
                     }else{
                         NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Invoice"];
                         if (classday) {
                             ClassInvoiceRecord *classinvoicerecord=[[ClassInvoiceRecord alloc]initClassInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.oneoffdiscount floatValue]+[PopoverEnrollment.recursivediscount floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain outstandingamount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.totalfee floatValue]-[PopoverEnrollment.paid floatValue]] invoiceremarks:PopoverEnrollment.invoiceremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment subjectname:nil];
                             
                             NSData *pdfdata=[MyClass generateInvoiceWithClassInvoiceArray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] SalesInvoiceArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                             if (pdfdata) {
                                 [self printPDF:pdfdata];
                             }
                         }
                     }
                 }else{
                     if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                         SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:nil totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
                         
                         NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:nil SalesReceiptArray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                         
                         if (pdfdata) {
                             [self emailPDF:pdfdata pdftype:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:nil salesreceiptarray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil]]];
                         }
                     }else{
                         SalesInvoiceRecord *salesinvoicerecord=[[SalesInvoiceRecord alloc]initSalesInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:nil totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity outstandingamount:[NSString stringWithFormat:@"%g",[SalesObject.total floatValue]-[SalesObject.paid floatValue]] invoiceremarks:SalesObject.invoiceremarks image:nil checkstatus:nil salesrecord:SalesObject productname:nil];
                         
                         NSData *pdfdata = [MyClass generateInvoiceWithClassInvoiceArray:nil SalesInvoiceArray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                         if (pdfdata) {
                             [self printPDF:pdfdata];
                         }
                     }
                 }
                
                
            
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }else if ([result isEqualToString:@"Send eInvoice"] || [result isEqualToString:@"Send eReceipt"]){
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (scpaymenttype.selectedSegmentIndex==0){
                    if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                        NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Receipt"];
                        if (classday) {
                            ClassReceiptRecord *classreceiptrecord=[[ClassReceiptRecord alloc]initClassReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.oneoffdiscount floatValue]+[PopoverEnrollment.recursivediscount floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain paymentkey:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paiddate paid:PopoverEnrollment.paid paidmethod:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment paymentremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentremarks subjectname:nil];
                            
                            
                            NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] SalesReceiptArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                            if (pdfdata) {
                                [self messagePDF:pdfdata studentkeys:[[NSMutableArray alloc]initWithObjects:PopoverEnrollment.studentkey, nil] pdfType:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] salesreceiptarray:nil] acknowledge:YES];
                            }
                        }
                    }else{
                        NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Invoice"];
                        if (classday) {
                            ClassInvoiceRecord *classinvoicerecord=[[ClassInvoiceRecord alloc]initClassInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.oneoffdiscount floatValue]+[PopoverEnrollment.recursivediscount floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain outstandingamount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.totalfee floatValue]-[PopoverEnrollment.paid floatValue]] invoiceremarks:PopoverEnrollment.invoiceremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment subjectname:nil];
                            
                            NSData *pdfdata=[MyClass generateInvoiceWithClassInvoiceArray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] SalesInvoiceArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                            if (pdfdata) {
                                [self messagePDF:pdfdata studentkeys:[[NSMutableArray alloc]initWithObjects:PopoverEnrollment.studentkey, nil] pdfType:@"Invoice" filename:[MyClass returninvoicenumberwithclassinvoicearray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] salesinvoicearray:nil updateinvoicelog:NO] acknowledge:YES];
                            }
                        }
                    }
                }else{
                    if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                        SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:nil totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
                        
                        NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:nil SalesReceiptArray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                        
                        if (pdfdata) {
                            [self messagePDF:pdfdata studentkeys:[[NSMutableArray alloc]initWithObjects:SalesObject.studentkey, nil] pdfType:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:nil salesreceiptarray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil]] acknowledge:YES];
                        }
                    }else{
                        SalesInvoiceRecord *salesinvoicerecord=[[SalesInvoiceRecord alloc]initSalesInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:nil totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity outstandingamount:[NSString stringWithFormat:@"%g",[SalesObject.total floatValue]-[SalesObject.paid floatValue]] invoiceremarks:SalesObject.invoiceremarks image:nil checkstatus:nil salesrecord:SalesObject productname:nil];
                        
                        NSData *pdfdata = [MyClass generateInvoiceWithClassInvoiceArray:nil SalesInvoiceArray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                        if (pdfdata) {
                            [self messagePDF:pdfdata studentkeys:[[NSMutableArray alloc]initWithObjects:SalesObject.studentkey, nil] pdfType:@"Invoice" filename:[MyClass returninvoicenumberwithclassinvoicearray:nil salesinvoicearray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord,nil] updateinvoicelog:NO] acknowledge:YES];
                        }
                    }
                }

            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }else if ([result isEqualToString:@"Send Email"]){
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (scpaymenttype.selectedSegmentIndex==0){
                    if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                        NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Receipt"];
                        if (classday) {
                            ClassReceiptRecord *classreceiptrecord=[[ClassReceiptRecord alloc]initClassReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.oneoffdiscount floatValue]+[PopoverEnrollment.recursivediscount floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain paymentkey:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paiddate paid:PopoverEnrollment.paid paidmethod:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment paymentremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentremarks subjectname:nil];
                            
                            
                            NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] SalesReceiptArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                            if (pdfdata) {
                                [self emailPDF:pdfdata pdftype:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] salesreceiptarray:nil]];
                            }
                        }
                    }else{
                        NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Invoice"];
                        if (classday) {
                            ClassInvoiceRecord *classinvoicerecord=[[ClassInvoiceRecord alloc]initClassInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.oneoffdiscount floatValue]+[PopoverEnrollment.recursivediscount floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain outstandingamount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.totalfee floatValue]-[PopoverEnrollment.paid floatValue]] invoiceremarks:PopoverEnrollment.invoiceremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment subjectname:nil];
                            
                            NSData *pdfdata=[MyClass generateInvoiceWithClassInvoiceArray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] SalesInvoiceArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                            if (pdfdata) {
                                [self emailPDF:pdfdata pdftype:@"Invoice" filename:[MyClass returninvoicenumberwithclassinvoicearray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] salesinvoicearray:nil updateinvoicelog:NO]];
                            }
                        }
                    }
                }else{
                    if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                        SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:nil totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath] staffname:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
                        
                        NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:nil SalesReceiptArray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                        
                        if (pdfdata) {
                            [self emailPDF:pdfdata pdftype:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:nil salesreceiptarray:[[NSMutableArray alloc]initWithObjects:salesreceiptrecord,nil]]];
                        }
                    }else{
                        SalesInvoiceRecord *salesinvoicerecord=[[SalesInvoiceRecord alloc]initSalesInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:nil totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity outstandingamount:[NSString stringWithFormat:@"%g",[SalesObject.total floatValue]-[SalesObject.paid floatValue]] invoiceremarks:SalesObject.invoiceremarks image:nil checkstatus:nil salesrecord:SalesObject productname:nil];
                        
                        NSData *pdfdata = [MyClass generateInvoiceWithClassInvoiceArray:nil SalesInvoiceArray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                        if (pdfdata) {
                            [self emailPDF:pdfdata pdftype:@"Invoice" filename:[MyClass returninvoicenumberwithclassinvoicearray:nil salesinvoicearray:[[NSMutableArray alloc]initWithObjects:salesinvoicerecord, nil] updateinvoicelog:NO]];
                        }
                    }
                }

            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }else if ([result isEqualToString:@"Add to Folder"]){
            
            if (scpaymenttype.selectedSegmentIndex==0){
                                if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                    if (![globalvariables.documentfolder.classreceiptarray containsObject:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey]) {
                        [globalvariables.documentfolder.classreceiptarray addObject:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey];
                        [self refreshdocumentfoldercount];
                    }else{
                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"This receipt has already been added to the folder"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [erroralert addAction:OKAction];
                        [self presentViewController:erroralert animated:YES completion:nil];
                    }
                }else{
                    if (![globalvariables.documentfolder.classinvoicearray containsObject:PopoverEnrollment.enrollmentkey]) {
                        [globalvariables.documentfolder.classinvoicearray addObject:PopoverEnrollment.enrollmentkey];
                        [self refreshdocumentfoldercount];
                    }else{
                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"This invoice has already been added to the folder"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [erroralert addAction:OKAction];
                        [self presentViewController:erroralert animated:YES completion:nil];
                    }
                }
            }else{
                if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                    if (![globalvariables.documentfolder.salesreceiptarray containsObject:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey]) {
                        [globalvariables.documentfolder.salesreceiptarray addObject:((PaymentRecord *)[DetailsPaymentArray objectAtIndex:paymentindexpath.row]).paymentkey];
                        [self refreshdocumentfoldercount];
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
                        [self refreshdocumentfoldercount];
                    }else{
                        UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"This invoice has already been added to the folder"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [erroralert dismissViewControllerAnimated:YES completion:nil];
                        }];
                        
                        [erroralert addAction:OKAction];
                        [self presentViewController:erroralert animated:YES completion:nil];
                    }
                }
            }
            
            

        }else if ([result isEqualToString:@"More"]){
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (scpaymenttype.selectedSegmentIndex==0){
                    if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                        [self sharepaymentreceiptwithtableview:sharetable indexpath:nil];
                    }else{
                        [self sharepaymentinvoicewithtableview:sharetable indexpath:nil];
                    }

                }else{
                    if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                        [self sharepaymentreceiptwithtableview:sharetable indexpath:nil];
                    }else{
                        [self sharepaymentinvoicewithtableview:sharetable indexpath:nil];
                    }
                }
                    [MyClass loadingindicatorwithoption:@"stop" color:nil];
                });

        }
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
    
    //[object.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:nil Width:0 Height:0 Type:@"pdf" Data:pdfData FileName:[NSString stringWithFormat:@"%@.pdf", object.messageenglish]]];
    /*
    CFDataRef myPDFData = (__bridge CFDataRef)pdfData;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData(myPDFData);
    CGPDFDocumentRef SourcePDFDocument = CGPDFDocumentCreateWithProvider(provider);
    size_t numberOfPages = CGPDFDocumentGetNumberOfPages(SourcePDFDocument);

    float scaleFactor=3.5;
    for(int currentPage = 1; currentPage <= numberOfPages; currentPage ++ )
    {
        CGPDFPageRef SourcePDFPage = CGPDFDocumentGetPage(SourcePDFDocument, currentPage);
        CGPDFPageRetain(SourcePDFPage);
        CGRect sourceRect = CGPDFPageGetBoxRect(SourcePDFPage, kCGPDFMediaBox);
        UIGraphicsBeginImageContext(CGSizeMake(sourceRect.size.width*scaleFactor,sourceRect.size.height*scaleFactor));
        CGContextRef currentContext = UIGraphicsGetCurrentContext();
        CGContextSetInterpolationQuality(currentContext, kCGInterpolationHigh);
        CGContextTranslateCTM(currentContext, 0.0, sourceRect.size.height*scaleFactor); //596,842 //640×960,
        CGContextScaleCTM(currentContext, scaleFactor, -scaleFactor);
        
        CGContextDrawPDFPage (currentContext, SourcePDFPage); // draws the page in the graphics context

        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [object.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:0 Height:0 Type:@"image" Data:nil FileName:@""]];
    }*/
    
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

-(void) updateCategoryCount
{
    //not required
}

- (void) gobackStudentCategory
{
    //not required
}

-(void) enableAddStudentButton
{
    //not required
}

-(void) disableAddStudentButton
{
    //not used
}

-(void) gotostudentprofile:(NSString *)studentkey
{
    //not used
}

-(void) refreshstudentdetailviewpresentingviewcontent
{
    //[ailoadclass startAnimating];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self refreshData];
    });
    
}

-(void) updatestudentinformationlist:(NSString *)studentkey reloadlist:(BOOL)reload
{
    //not used
}

-(void) dismissEditStudentView{
    
}
@end
