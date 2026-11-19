//
//  StudentDetailsViewController.m
//  ELTestX
//
//  Created by Jasmond Luk on 3/6/14.
//  Copyright (c) 2014 Jasmond Luk. All rights reserved.
//

#import "StudentDetailsViewController.h"
#import "MyObject.h"
#import "EnrollmentPopoverViewController.h"
#import "ClassPopoverViewController.h"
#import "StudentEditViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MainMenuViewController.h"
#import "MyClass.h"
#import "DTAddEditViewController.h"
#import "LeadInformationViewController.h"
#import "MessagePhotoCollectionViewCell.h"
//#import "UIImageView+AFNetworking.h"
#import "MyTableViewCell.h"
//#import "AFNetworking.h"
#import "SDImageCache.h"
#import "messageDocumentUIView.h"
#import "SceneDelegate.h"

@import  Photos;
@import  BSImagePicker;

@interface StudentDetailsViewController ()<myDTAddEditViewControllerDelegate>

@end

#define photosize 175
#define maxphotoheight self.view.bounds.size.height*0.5
#define confirmationwidth 110
#define confirmationheight 76
#define documentfoldertablewidth 470
#define maxselectiontableheight 600
#define photosize 175
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]
#define parentcontactseparation 20

@implementation StudentDetailsViewController
@synthesize DetailsViewStudent;
@synthesize DetailsViewClassArray,DetailsViewEnrollmentArray,JSONArray;
@synthesize DetailsViewClassTable,DetailsViewEnrollmentTable;
@synthesize subjectselected,ClassSelectionButton,scactiveoption_class,scactiveoption_enrollment,myTypeSelectionPopoverController,typeselected,TypeSelectionButton;
@synthesize EnrollmentRecordView,ClassRecordView;
@synthesize DetailsViewClass,DetailsViewEnrollment;
@synthesize myPopoverController;
@synthesize ViewStudent,ViewHistoryTableMasterView;
@synthesize studentAction,selectedMenu,presetValue,classviewmode;
@synthesize systemMessageLabel,systemMessageView;
@synthesize pickerViewmenu,myPickerView;
@synthesize tableViewMenu,tableMenu;
@synthesize TopMenuView,EnrollmentClassMenuView;
@synthesize DetailsViewLeadObject;
@synthesize StudentViewMode;
@synthesize selectedClasskey,selectedEnrollmentkey,selectedSaleskey,typeselectionarrow,dayselectionarrow;
@synthesize MessageView,SalesView,deststudenteditviewcontroller,lastviewindex,lastdayofweekindex,lastactivedraftindex_class,lastactivedraftindex_enrollment,lasttypeindex,CallLogView;
@synthesize productcategoryselected,ProductCategorySelectionButton,mySharePopoverController,CallLogCalledBySelectionButton,calllogcalledbyselected;
@synthesize myClassSelectionPopoverController;
@synthesize DTRecordView,DetailsViewDTArray,selectedDTkey,myDTSelectionPopoverController,DetailsViewDTObject,DetailsViewATObject;
@synthesize dayarray,typearray,activedraftarray,messagecategoryarray,DaySelectionButton,myDaySelectionPopoverController,dayselected;
@synthesize panGesture,documentfolderpopover,DetailsViewClassScheduleObject,CouponView,headertitlename;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) dismissDTAddEditpopoverwithdttype:(NSString *)type
{
    //not used
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    globalvariables=[GlobalVariables singleObj];
    
    currencyformatter = [[NSNumberFormatter alloc] init];
    [currencyformatter setMaximumFractionDigits:globalvariables.centerrecord.noofroundoffdigit];
    [currencyformatter setMinimumFractionDigits:0];
    currencyformatter.numberStyle = NSNumberFormatterCurrencyStyle;
    [currencyformatter setCurrencySymbol:@"$"];
    
    DetailsViewClass=[[ClassRecord alloc]init];
    DetailsViewDTObject=[[DTRecord alloc]init];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
//    selfViewWidth = screenSize.width-240;
    selfViewWidth = self.view.bounds.size.width-240;
    messagecontentwidth=selfViewWidth-40;
    maxphotoperline=(self.view.frame.size.width-250-40)/photosize;

//    [self.navigationController.navigationBar setFrame:CGRectMake(0, 0, selfViewWidth,80.0)];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];

//    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];
    //self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    tableoptionarray=[[NSMutableArray alloc]initWithObjects:@"Student",@"Enrollment",@"Class",@"Sales",@"Messages",@"Call Log",@"Trial/Assessment",@"Coupon", nil];
    dayarray=[[NSArray alloc]initWithObjects:@"All Days",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun",@"Multi",nil];
    
    activedraftarray_enrollment=[[NSArray alloc]initWithObjects:@"All",@"Active",@"Due",@"Non Voided",@"Voided",nil];
    activedraftarray_class=[[NSArray alloc]initWithObjects:@"All",@"Active",@"Evaluation",nil];
    messagecategoryarray=[[NSArray alloc]initWithObjects:@"All",@"User",@"System", nil];
    tableoptionviewarray=[[NSMutableArray alloc]initWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",globalvariables.centerrecord.ecoupon?@"1":@"0", nil];
    

    //imageCache=[[NSCache alloc]init];
    
    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];

    [self loadgeneral];
    [self loadstudentview];
    [self loadclassview];
    [self loadenrollmentview];


    
    runviewdidappear=YES;


//    ClassSelectionButton=[[UIButton alloc]initWithFrame:CGRectMake(1, 2, selfViewWidth-504, 29)];
    //[ClassSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Classes"] forState:UIControlStateNormal];
    [ClassSelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ClassSelectionButton.backgroundColor=themecolor;
//    ClassSelectionButton.titleLabel.font=[UIFont systemFontOfSize:14];
    ClassSelectionButton.layer.cornerRadius=5;
    [ClassSelectionButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 30)];
    [ClassSelectionButton addTarget: self action:@selector(selectclass:) forControlEvents: UIControlEventTouchUpInside];
//    [EnrollmentClassMenuView addSubview:ClassSelectionButton];

    headertitleview=[[UIView alloc]initWithFrame:CGRectMake(150, 0, selfViewWidth-300, 68)];
    //headertitleview.backgroundColor=[UIColor whiteColor];
    headertitlename=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, headertitleview.frame.size.width, 20)];
    headertitlename.font=[UIFont boldSystemFontOfSize:17];
    headertitlename.textColor=[UIColor whiteColor];
    headertitlename.textAlignment=NSTextAlignmentCenter;
    [headertitleview addSubview:headertitlename];
    [MasterView addSubview:headertitleview];
    
    headercentername=[[UILabel alloc]init];
    headercentername.font=[UIFont systemFontOfSize:12];
    headercentername.textAlignment=NSTextAlignmentCenter;
    headercentername.minimumScaleFactor=0.8;
    headercentername.adjustsFontSizeToFitWidth=YES;
    headercentername.textColor=[UIColor whiteColor];
    [headertitleview addSubview:headercentername];
    
    headercenternamearrow=[[UIImageView alloc]init];
    [headercenternamearrow setImage:[UIImage imageNamed:@"openbutton_white.png"]];
    headercenternamearrow.hidden=([MyClass isMultiCenterUser] && ![studentAction isEqualToString:@"PopoverStudent"])?NO:YES;
    [headertitleview addSubview:headercenternamearrow];
    //[self updateheadercentertitle];
    
    switchcenterbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, headertitleview.frame.size.width,68)];
    //[switchcenterbutton setImage:[UIImage imageWithData:globalvariables.menuimagedata] forState:UIControlStateNormal];
    switchcenterbutton.layer.cornerRadius=5;
    switchcenterbutton.layer.masksToBounds=YES;
    if ([MyClass isMultiCenterUser] && ![studentAction isEqualToString:@"PopoverStudent"]) {
        [switchcenterbutton addTarget:self action:@selector(switchcenterbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    }
    [headertitleview addSubview:switchcenterbutton];

    switchcenterviewcontroller = (SwitchCenterViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SwitchCenterViewController"];
    //switchcenterviewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
    switchcenterviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    switchcenterviewcontroller.delegate=self;
    
    
    //[self.navigationController.navigationBar addSubview:headertitleview];
    
//    self.navigationItem.titleView=headertitleview;
    //[self refreshlanguage];
    
    
    DataChanged=FALSE;

    boyimage=[UIImage imageNamed:@"boyimage.jpg"];
    girlimage=[UIImage imageNamed:@"girlimage.png"];
    
    //MessageView=[[UIView alloc]initWithFrame:CGRectMake(5, 115, selfViewWidth-14, self.view.frame.size.height-151)];
    //MessageView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    //[MasterView addSubview:MessageView];
    
    [scsender setTitle:[MyClass returntitlewithtitle:@"Center"] forSegmentAtIndex:0];
    [scsender setTitle:[MyClass returntitlewithtitle:@"Self"] forSegmentAtIndex:1];

    if ([DetailsViewMessageTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        DetailsViewMessageTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    [DetailsViewMessageTable setSeparatorColor:[UIColor clearColor]];

    messagesearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshmessagetable) forControlEvents:UIControlEventValueChanged];
    [DetailsViewMessageTable addSubview:tablerefresh];
    
    SalesTable.sectionHeaderHeight=0;
    if ([SalesTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        SalesTable.cellLayoutMarginsFollowReadableWidth=NO;
    }

    
    UILongPressGestureRecognizer *slpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(salesTableLongPress:)];
    slpgr.delegate = self;
    [SalesTable addGestureRecognizer:slpgr];

    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    //tablerefresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [tablerefresh addTarget:self action:@selector(refreshsalestable) forControlEvents:UIControlEventValueChanged];
    [SalesTable addSubview:tablerefresh];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshcoupontable) forControlEvents:UIControlEventValueChanged];
    [couponTable addSubview:tablerefresh];
    
    SiblingTable.sectionHeaderHeight=0;

    [self drawpointerwithoption:@"closed" imageview:productcategorybuttonarrow];
    [self createsalesviewtableheader];

    CallLogTable.sectionHeaderHeight=0;
    if ([CallLogTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        CallLogTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    [CallLogTable setSeparatorColor:[UIColor clearColor]];
    calllogsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];

    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshcalllogtable) forControlEvents:UIControlEventValueChanged];
    [CallLogTable addSubview:tablerefresh];
    
    [self drawpointerwithoption:@"closed" imageview:calllog_callerarrow];
    

    DetailsViewDTTable.sectionHeaderHeight=0;
    if ([DetailsViewDTTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        DetailsViewDTTable.cellLayoutMarginsFollowReadableWidth=NO;
    }

    dtsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshdttable) forControlEvents:UIControlEventValueChanged];
    [DetailsViewDTTable addSubview:tablerefresh];
    
    [self drawpointerwithoption:@"closed" imageview:dt_coursearrow];
    [self drawpointerwithoption:@"closed" imageview:dt_typearrow];
    
    DTTypeArray=[[NSMutableArray alloc]initWithObjects:@"All Types",@"Assessment",@"Trial", nil];
    
    
    [self createdtviewtableheader];
    [self loadImageFullScreenView];
    
    TopMenuView.hidden=YES;
    ViewStudent.hidden=YES;
    EnrollmentClassMenuView.hidden=YES;
    EnrollmentRecordView.hidden=YES;
    ClassRecordView.hidden=YES;
    MessageView.hidden=YES;
    SalesView.hidden=YES;
    CallLogView.hidden=YES;
    DTRecordView.hidden=YES;
    CouponView.hidden=YES;
    
    
    //[self drawsubjectpointerwithoption:@"closed"];
    [self drawpointerwithoption:@"closed" imageview:classselection_arrow];
    
    subjectselected=@"All";
    dttypeselected=@"All";
    dayselected=@"All";
    
//    documentfolderbutton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [documentfolderbutton setImage:[UIImage imageNamed:@"documentfolder_icon.png"] forState:UIControlStateNormal];
//    documentfolderbutton.showsTouchWhenHighlighted = YES;
//    documentfolderbutton.frame = CGRectMake(0, 0, 30,30);
//    [documentfolderbutton setImageEdgeInsets:UIEdgeInsetsMake(5,0,0,5)];
//    documentfolderbutton.layer.cornerRadius=5;
//    documentfolderbutton.layer.masksToBounds=YES;
//    [documentfolderbutton.heightAnchor constraintEqualToConstant:30].active = true;
//    [documentfolderbutton.widthAnchor constraintEqualToConstant:30].active = true;
//    [documentfolderbutton addTarget:self action:@selector(documentfolderbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    
    documentfoldercountlabel = [[UILabel alloc] initWithFrame: CGRectMake(20,5,10,10)];
    documentfoldercountlabel.backgroundColor = [UIColor redColor];
    documentfoldercountlabel.layer.cornerRadius=5;
    documentfoldercountlabel.layer.masksToBounds=YES;
    [documentfolderbutton addSubview:documentfoldercountlabel];
    
    
    calllogobj=[[CallLogRecord alloc]init];
    

    
    isSelectCombinePayment=FALSE;

    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.delegate = self;
    


    [self refreshlanguage];
    
    DetailsViewMessageTable.transform = CGAffineTransformMakeScale(1, -1);
    workingMessage=[[OutboxMessageRecord alloc]init];
    workingMessage.messagetype=@"General";
    workingMessage.sender=globalvariables.username;
    workingMessage.channel=@"A";
    workingMessage.hotnews=NO;
    workingMessage.hn_expiry_date=@"";
    workingMessage.messageenglish=@"";
    workingMessage.messagechinese=@"";
    workingMessage .status=@"";
    workingMessage.sender=@"center";
    workingMessage.photoarray=[[NSMutableArray alloc]init];
    
    sendinstantmessagebutton.enabled=[self enableSendButton];
    filteredMessageArray=[[NSMutableArray alloc]init];
    readmessagearray=[[NSMutableArray alloc]init];
    
    UICollectionViewFlowLayout *vfl=[[UICollectionViewFlowLayout alloc]init];
    vfl.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    instantPhotoCollectionView.collectionViewLayout=vfl;
    UILongPressGestureRecognizer *longPressGesture=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(handleLongGesture:)];
    [instantPhotoCollectionView addGestureRecognizer:longPressGesture];
    instantPhotoCollectionView.backgroundColor=[UIColor clearColor];
    [instantPhotoCollectionView registerClass:[MessagePhotoCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [instantPhotoCollectionView reloadData];
    
    fullscreenphotoviewcontroller = (FullScreenPhotoViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"FullScreenPhotoViewController"];
    fullscreenphotoviewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
    fullscreenphotoviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    fullscreenphotoviewcontroller.delegate=self;
    
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    

    
    runviewdidappear=TRUE;
    
    [self startAudioSession];
    
    
    UIPanGestureRecognizer *audioPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(audioPanGestureDetected:)];
    audioPanGesture.maximumNumberOfTouches = 1;
    audioPanGesture.minimumNumberOfTouches = 1;
    audioPanGesture.delegate = self;
    [textinputbox addGestureRecognizer:audioPanGesture];
    
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateMonitor:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    
    // Choose between heavy, medium, and light for style
    impactFeedbackGenerator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
        
    // Primes feedback generator for upcoming events and reduces latency
    [impactFeedbackGenerator prepare];
    
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeDefault options:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetoothHFP | AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];
    [sliderTimer invalidate];
    
    pointBox.layer.borderColor=[UIColor purpleColor].CGColor;
    pointBox.layer.borderWidth=1;
    recordAudioButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendmessage;
    
    selectededitattendanceclasskeyarray=[[NSMutableArray alloc]init];
//    [self.view bringSubviewToFront:MenuView];
    
    
}

- (void)audioPanGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    if (audioRecorder.recording) {
        CGPoint touchpoint= [recognizer locationInView:textinputbox];
        CGRect cancellationframe = [textinputbox convertRect:slideToCancelTitle.frame fromView:slideToCancelTitle.superview];
        //NSLog(@"Touchpoint: %f:%f Frame:%f:%f:%f:%f",touchpoint.x,touchpoint.y,cancellationframe.origin.x,cancellationframe.origin.y,cancellationframe.size.width,cancellationframe.size.height);
        if (recognizer.state!=UIGestureRecognizerStateEnded) {
            if (touchpoint.x<(cancellationframe.size.width+cancellationframe.origin.x) && touchpoint.x>cancellationframe.origin.x && touchpoint.y>cancellationframe.origin.y && touchpoint.y<(cancellationframe.origin.y+cancellationframe.size.height)) {
                //[self cancelAudioRecording];
                [audioRecordingImage setImage:[UIImage imageNamed:@"trashbin_red.png"]];
                slideToCancelTitle.font=[UIFont systemFontOfSize:16];
                slideToCancelTitle.textColor=[UIColor lightGrayColor];
            }else{
                [audioRecordingImage setImage:[UIImage imageNamed:@"audio_recording.png"]];
                slideToCancelTitle.font=[UIFont systemFontOfSize:17];
                slideToCancelTitle.textColor=[UIColor grayColor];
            }
        }else{
            if (touchpoint.x<(cancellationframe.size.width+cancellationframe.origin.x)) {
                [self cancelAudioRecording];
            }else{
                [self stopAudioRecording];
            }
        }
    }
}

- (void)keyboardDidShow: (NSNotification *) notif{
    
    // Do something here
    keyboardshow=TRUE;
}

- (void)keyboardDidHide: (NSNotification *) notif{
    
    keyboardshow=FALSE;
    keyboardheight=0;
    [self adjusttablesize];
}

- (void)keyboardDidChangeFrame:(NSNotification *)notif
{
    CGSize keyboardSize = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = keyboardSize.height;
    [self adjusttablesize];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    keyboardheight = keyboardSize.height;
    [self adjusttablesize];
}

-(void) adjusttablesize
{
    messageinputtextbottomconstraint.constant=keyboardheight;
}

-(void) refreshlanguage
{
    headercentername.text=[MyClass returnWindowTitle];
    headertitlename.text=[MyClass returntitlewithtitle:@"Student Profile"];
    if (!studentAction || [studentAction isEqualToString:@"ViewStudent"]) {
        systemMessageLabel.text=[MyClass returntitlewithtitle:@"Select student or press + to add new"];
        //systemMessageLabel.frame=CGRectMake(0, 0, selfViewWidth-234, self.view.bounds.size.height-64);
        systemMessageTrailingConstraint.constant=234;
        
        if (!studentAction) {
            [self showviewhistory:TRUE];
        }
    }else{
        systemMessageLabel.text=[NSString stringWithFormat:@"%@...",[MyClass returntitlewithtitle:@"Loading Information"]];
        //systemMessageLabel.frame=CGRectMake(0, 0, selfViewWidth, self.view.bounds.size.height-64);
        systemMessageTrailingConstraint.constant=0;
    }
    viewhistorytableheader.text=[MyClass returntitlewithtitle:@"Recent Views"];
    [self updateheadercentertitle];
    
    ProductCategoryArray= [[NSMutableArray alloc]initWithObjects:[MyClass returntitlewithtitle:@"All Categories"], nil];
    [ClassSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Classes"] forState:UIControlStateNormal];
    salessearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    [ProductCategorySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Categories"] forState:UIControlStateNormal];
    calllogsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    [CallLogCalledBySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Callers"] forState:UIControlStateNormal];
    dtsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    [DTSubjectSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Classes"] forState:UIControlStateNormal];
    [DTTypeSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Types"] forState:UIControlStateNormal];
    
    [DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Days"] forState:UIControlStateNormal];
    [TypeSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Types"] forState:UIControlStateNormal];
    
    //copyrightmessagelabel.text=[MyClass returntitlewithtitle:@"Copyright message"];
    studentview_gender_label.text=[MyClass returntitlewithtitle:@"Gender"];
    studentview_studentid_label.text=[MyClass returntitlewithtitle:@"Student ID"];
    studentview_fcmemberid_label.text=[MyClass returntitlewithtitle:@"FC Member ID"];
    studentview_dateofbirth_label.text=[MyClass returntitlewithtitle:@"Date of Birth"];
    studentview_age_label.text=[MyClass returntitlewithtitle:@"Age"];
    studentview_preferredlanguage_label.text=[MyClass returntitlewithtitle:@"Preferred Language"];
    studentview_grade_label.text=[MyClass returntitlewithtitle:@"Grade"];
    studentview_school_label.text=[MyClass returntitlewithtitle:@"School"];
    studentview_parentname_label.text=[MyClass returntitlewithtitle:@"Parent Name"];
    studentview_parentname2_label.text=[MyClass returntitlewithtitle:@"Parent Name 2"];
    studentview_extrafield1_label.text=[MyClass returntitlewithtitle:@"ExtraField1"];
    studentview_extrafield2_label.text=[MyClass returntitlewithtitle:@"ExtraField2"];
    studentview_email_label.text=[MyClass returntitlewithtitle:@"Email (separate multiple emails by comma)"];
    studentview_address_label.text=[MyClass returntitlewithtitle:@"Address"];
    studentview_media_label.text=[MyClass returntitlewithtitle:@"Student Media"];
    studentview_source_label.text=[MyClass returntitlewithtitle:@"Student Source"];
    studentview_remarks_label.text=[MyClass returntitlewithtitle:@"Remarks"];
    studentview_flag_label.text=[MyClass returntitlewithtitle:@"Flag"];
    studentview_inactive_label.text=[MyClass returntitlewithtitle:@"Suspend"];
    studentview_promotionmessage_label.text=[MyClass returntitlewithtitle:@"Promotional Message"];
    studentview_sendmessage_label.text=[MyClass returntitlewithtitle:@"Send Message"];
    studentview_promotionmessage_label.font=[UIFont systemFontOfSize:[globalvariables.language isEqualToString:@"English"]?13:15];
    studentview_sendmessage_label.font=[UIFont systemFontOfSize:[globalvariables.language isEqualToString:@"English"]?13:15];
    studentview_nophoto_label.text=[MyClass returntitlewithtitle:@"No Photo"];
    slideToCancelTitle.text=[MyClass returntitlewithtitle:@"Release here to cancel"];
    studentview_nophoto_label.text=[MyClass returntitlewithtitle:@"No Photo"];
    studentview_ddaaccountno_label.text=[MyClass returntitlewithtitle:@"Account Number"];
    studentview_ddaaccountname_label.text=[MyClass returntitlewithtitle:@"Account Name"];
    studentview_ddadebtorreference_label.text=[MyClass returntitlewithtitle:@"Debtor Reference"];
    studentview_ddalimit_label.text=[MyClass returntitlewithtitle:@"DDA_Limit"];
    siblingtableheader.text=[MyClass returntitlewithtitle:@"Siblings and Friends"];
    studentview_directdebitauthorization_label.text=[MyClass returntitlewithtitle:@"Direct Debit Authorization"];
    siblingnonelabel.text=[MyClass returntitlewithtitle:@"None"];
    scsender.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendmessagecenterrole;
    
    [self refreshenrollmenttableheader];
    [self refreshclasstableheader];
    [self refreshsalestableheader];
    [self refreshcoupontableheader];
    
    [subcategorySC setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [subcategorySC setTitle:[MyClass returntitlewithtitle:@"Class"] forSegmentAtIndex:1];
    [subcategorySC setTitle:[MyClass returntitlewithtitle:@"Sales"] forSegmentAtIndex:2];
    
    [couponStatusSC setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
    [couponStatusSC setTitle:[MyClass returntitlewithtitle:@"Valid now"] forSegmentAtIndex:1];
    [couponStatusSC setTitle:[MyClass returntitlewithtitle:@"Valid later"] forSegmentAtIndex:2];
    [couponStatusSC setTitle:[MyClass returntitlewithtitle:@"Used"] forSegmentAtIndex:3];
    [couponStatusSC setTitle:[MyClass returntitlewithtitle:@"Expired"] forSegmentAtIndex:4];
    
    pointTitleLabel.text=[MyClass returntitlewithtitle:@"Point"];
    
//    [student_editButton setTitle:[MyClass returntitlewithtitle:@"Edit"] forState:UIControlStateNormal];
    [student_goToLeadButton setTitle:[MyClass returntitlewithtitle:@"Go to Lead Profile"] forState:UIControlStateNormal];
    [remainingclassbutton setTitle:[MyClass returntitlewithtitle:@"Class Summary"] forState:UIControlStateNormal];
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

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
{
    if (attendanceringview) {
        UIView *windowview = self.view;
        while (windowview.superview != Nil) {
            windowview = windowview.superview;
        }
        
        if (recognizer.state!=UIGestureRecognizerStateEnded) {
            CGPoint point= [recognizer locationInView:windowview];
            point.x=point.x-attendanceringview.frame.origin.x;
            point.y=point.y-attendanceringview.frame.origin.y;
            lasttouchedsector= [MyClass updateattendanceringwithtouchpoint:point attendanceringview:attendanceringview attendancebuttonarray:attendancebuttonarray lasttouchedsector:lasttouchedsector size:@"large"];
        }else{
            CGPoint point= [recognizer locationInView:windowview];
            point.x=point.x-attendanceringview.frame.origin.x;
            point.y=point.y-attendanceringview.frame.origin.y;
            
            [self attendanceringreleasedwithtouchpoint:point];
            //if (![studentAction isEqualToString:@"PopoverStudent"]) {
                [self.mainSlideMenu enableSlidePanGestureForLeftMenu];
            //}

            if (lastviewindex==2) {
                DetailsViewClassTable.scrollEnabled=TRUE;
                [DetailsViewClassTable deselectRowAtIndexPath:[DetailsViewClassTable indexPathForSelectedRow] animated: YES];
            }else if (lastviewindex==6){
                DetailsViewDTTable.scrollEnabled=TRUE;
                [DetailsViewDTTable deselectRowAtIndexPath:[DetailsViewDTTable indexPathForSelectedRow] animated: YES];
            }
        }
    }
}

-(void) attendanceringreleasedwithtouchpoint:(CGPoint)touchpoint
{
    //check if inside ring
    if (lastviewindex==2) {
        if ([MyClass returntouchpointwithinattendanceringwithtouchpoint:touchpoint size:@"large"]) {
            NSIndexPath *selectedIndexPath = [DetailsViewClassTable indexPathForSelectedRow];
            [self updateattendancewithindexpath:selectedIndexPath value:((AttendanceButtonObject *)[attendancebuttonarray objectAtIndex:lasttouchedsector]).buttonname];
        }
    }else if(lastviewindex==6){
        if ([MyClass returntouchpointwithinattendanceringwithtouchpoint:touchpoint size:@"large"]) {
            NSIndexPath *selectedIndexPath = [DetailsViewDTTable indexPathForSelectedRow];
            [self updateattendancewithindexpath:selectedIndexPath value:((AttendanceButtonObject *)[attendancebuttonarray objectAtIndex:lasttouchedsector]).buttonname];
        }
    }
    
    //if (attendanceringview) {
        [UIView animateWithDuration:0.4 animations:^{attendanceringview.alpha = 0.0;} completion:^(BOOL finished){
            [attendanceringview removeFromSuperview];
            attendanceringview=nil;
        }];
    
    //}
}

-(NSMutableArray *) returnfreescheduleclassarray
{
    FreeScheduleClass *freescheduleclass_object=[[FreeScheduleClass alloc]init];
    
    freescheduleclass_object.classkey=DetailsViewClass.classkey;
    freescheduleclass_object.subject=DetailsViewClass.subject;
    freescheduleclass_object.attendance=selectedAttendanceStatus;
    
    freescheduleclass_object.classdate=DetailsViewClass.startdate;
    freescheduleclass_object.classtime=DetailsViewClass.classtime;
    freescheduleclass_object.instructor=DetailsViewClass.instructor;
    freescheduleclass_object.classroom=DetailsViewClass.classroom;
    
    freescheduleclass_object.makeupdate=DetailsViewClass.makeupdate;
    freescheduleclass_object.makeuptime=DetailsViewClass.makeuptime;
    freescheduleclass_object.makeupinstructor=DetailsViewClass.makeupinstructor;
    freescheduleclass_object.makeupclassroom=DetailsViewClass.makeupclassroom;
    freescheduleclass_object.makeupattendance=DetailsViewClass.makeupattendance;
    freescheduleclass_object.classremarks=DetailsViewClass.absentmakeupreason;
    freescheduleclass_object.classtype=@"Class";
    freescheduleclass_object.leavenaturelistkey=[MyClass returnDefaultLeaveNatureListKeyWithAttendance:selectedAttendanceStatus];
    
    
    
    
    freescheduleclass_object.action=@"Edit";
    
    
    return [[NSMutableArray alloc]initWithObjects:freescheduleclass_object, nil];
}

-(void)updateattendancewithindexpath:(NSIndexPath *)indexpath value:(NSString *)value
{
    selectedAttendanceStatus=value;
    if (lastviewindex==2) {
        //update class information
        
        DetailsViewClass=[filteredDetailsViewClassArray objectAtIndex:indexpath.row];
        
        if (![value isEqualToString:DetailsViewClass.attendance]) {
            classvalidatemessage=[MyClass validateClassWithFreeScheduleArray:[self returnfreescheduleclassarray] studentkey:DetailsViewClass.studentkey enrollmentkey:nil];
            classvalidatestatus=[[ClassValidateStatus alloc]initClassValidateStatuswithoverenrollmentstatus:@"" sameinstructormulticlassstatus:@"" alreadyenrolledstatus:@"" sameclassroommulticlassstatus:@"" hasextendedchildclassstatus:@"" classroomexceedcapacitystatus:@"" makeupquotaexceedstatus:@""];
            [self checkvalidatemessage];

        }
    }else if (lastviewindex==6){
        //update dt information
        
        DetailsViewDTObject=[filteredDetailsViewDTArray objectAtIndex:indexpath.row];
        
        if (![value isEqualToString:DetailsViewDTObject.attendance]) {
            
            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
            
            [dictionary setValue:globalvariables.username forKey:@"updatedby"];
            [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
            [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
            [dictionary setValue:@"updatedt" forKey:@"postaction"];
            [dictionary setValue:DetailsViewDTObject.DTkey forKey:@"dtkey"];
            [dictionary setValue:value forKey:@"attendance"];
            
            __block BOOL result=FALSE;
            [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
                if (succeeded) {
                    result=TRUE;
                }
            }];
            
            /*
            NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
            
            NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
            [postRequest setHTTPMethod:@"POST"];
            [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
            [postRequest setHTTPBody:finalData];
            
            __block BOOL result=FALSE;
            
            dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
            [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                
                if (!error) {
                    result=TRUE;
                }
                dispatch_semaphore_signal(semaphore);
            }] resume];
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
            
            if (result) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self retrieveDTWithSubject:dtsubjectselected studentkey:DetailsViewStudent.studentkey classtype:dttypeselected];
                });
                DataChanged=YES;
            }/*else{
                [MyClass showconnectionlostdialogbox];
            }*/
            

        }
    }
}

-(void) checkvalidatemessage
{
    [MyClass checkValidateMessageWithClassValidateMessage:classvalidatemessage ClassValidateStatus:classvalidatestatus View:self];
    
}

-(void) validationPassed:(BOOL)pass
{
    if(pass){
        [self updateAttendanceWithValue:selectedAttendanceStatus];
    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }
}

-(void) updateAttendanceWithValue:(NSString *)value
{
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:@"updateclassv2" forKey:@"postaction"];
    [dictionary setValue:DetailsViewClass.classkey forKey:@"classkey"];
    [dictionary setValue:value forKey:@"attendance"];
    [dictionary setValue:@"" forKey:@"absentmakeupreason"];
    [dictionary setValue:((SubjectRecord *)[MyClass returnsubjectinformationwithsubject_shortname:DetailsViewClass.subject centerkey:globalvariables.centerrecord.centerkey]).classduration forKey:@"extensiontime"];
    [dictionary setValue:@"studentprofileclassattendancering" forKey:@"trigger"];
    
    if ([value isEqualToString:@"Makeup"] && [DetailsViewClass.makeupdate isEqualToString:@""]) {
        [dictionary setValue:globalvariables.centerrecord.defaultattendancestatus forKey:@"makeupattendance"];
    }
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
        }
    }];
    
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    
    __block BOOL result=FALSE;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error) {
            result=TRUE;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            if([value isEqualToString:@"Makeup"]){
                
                ClassRecord *obj=[filteredDetailsViewClassArray objectAtIndex:[self returnClassRecordIndexWithClassKey:DetailsViewClass.classkey]];
                
                [self startsidewindowanimationwithwidth:320];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    MakeupPopoverViewController *makeuppopover = (MakeupPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MakeupPopoverViewController"];
                    makeuppopover.delegate=self;
                    makeuppopover.PopoverDetailsClassRecord=obj;
                    makeuppopover.PopoverOption=@"FromClassDetails";
                    //classpopover.PopoverStudent=DetailsViewStudent;
                    
                    makeuppopover.view.frame=self->mainWindow.bounds;
                    [self->sidewindowview addSubview:makeuppopover.view];
                    [self addChildViewController:makeuppopover];
                    [makeuppopover didMoveToParentViewController:self];
                    [self->ailoadindicator stopAnimating];
                    self->ailoadindicator.hidden=YES;
                });
            }

            [self refreshtableaftermakeupabsent];
            
        });
        DataChanged=YES;
    }else{
        [MyClass showconnectionlostdialogbox];
    }
}

-(NSInteger) returnClassRecordIndexWithClassKey:(NSString *)classkey
{
    ClassRecord *obj;
    for(int i=0;i<filteredDetailsViewClassArray.count;i++){
        obj=[filteredDetailsViewClassArray objectAtIndex:i];
        if([obj.classkey isEqualToString:classkey]){
            return i;
        }
    }
    return -1;
}

-(void) attendancebuttontouchupinside:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.3 animations:^{attendanceringview.alpha = 0.0;} completion:^(BOOL finished){ [attendanceringview removeFromSuperview]; }];
    attendanceringview=nil;
    
    if (![studentAction isEqualToString:@"PopoverStudent"]) {
        [self.mainSlideMenu enableSlidePanGestureForLeftMenu];
    }
    
    if (lastviewindex==2) {
        DetailsViewClassTable.scrollEnabled=TRUE;
        [DetailsViewClassTable deselectRowAtIndexPath:[DetailsViewClassTable indexPathForSelectedRow] animated: YES];
    }else if (lastviewindex==6){
        DetailsViewDTTable.scrollEnabled=TRUE;
        [DetailsViewDTTable deselectRowAtIndexPath:[DetailsViewDTTable indexPathForSelectedRow] animated: YES];
    }
}

-(void) attendancebuttontouchdown:(UIButton *)sender
{
    //[self.mainSlideMenu disableSlidePanGestureForLeftMenu];
    
    //in case if there is any freeze ring remain previously
    if (attendanceringview) {
        [attendanceringview removeFromSuperview];
        attendanceringview=nil;
    }else{
        UIView *windowview = self.view;
        while (windowview.superview != Nil) {
            windowview = windowview.superview;
        }
        
        //if (![studentAction isEqualToString:@"PopoverStudent"]) {
        [self.mainSlideMenu disableSlidePanGestureForLeftMenu];
        //}
        
        if (lastviewindex==2) {
            selectedClasskey=@"";
            CGPoint point = [sender.superview convertPoint:CGPointZero toView:DetailsViewClassTable];
            NSIndexPath *indexpath =[DetailsViewClassTable indexPathForRowAtPoint:point];
            [DetailsViewClassTable selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
            DetailsViewClass=[filteredDetailsViewClassArray objectAtIndex:indexpath.row];
            
            
            if ([DetailsViewClass.startdate isEqualToString:@"TBD"] || [DetailsViewClass.classtime isEqualToString:@"TBD"] || [DetailsViewClass.draft isEqualToString:@"Yes"]) {
                /*UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Cannot change attendance for class with TBD date or time"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                //[self presentViewController:erroralert animated:YES completion:nil];
                [MyClass presentViewController:erroralert View:self];
                return;*/
                
                DetailsViewClassTable.scrollEnabled=FALSE;
                attendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnabsentattendancebuttonarray]];
                attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:DetailsViewClass.attendance highlightbutton:DetailsViewClass.attendance attendancebuttonarray:attendancebuttonarray inview:windowview size:@"large"];
                
                
                
            }else{
                DetailsViewClassTable.scrollEnabled=FALSE;
                attendancebuttonarray=[[NSMutableArray alloc]initWithArray:regularattendancebuttonarray];
                attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:DetailsViewClass.attendance highlightbutton:DetailsViewClass.attendance attendancebuttonarray:attendancebuttonarray inview:windowview size:@"large"];
            }
        }else if (lastviewindex==6){
            DetailsViewDTTable.scrollEnabled=FALSE;
            CGPoint point = [sender.superview convertPoint:CGPointZero toView:DetailsViewDTTable];
            NSIndexPath *indexpath =[DetailsViewDTTable indexPathForRowAtPoint:point];
            [DetailsViewDTTable selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
            DetailsViewDTObject=[filteredDetailsViewDTArray objectAtIndex:indexpath.row];
            attendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnmakeupattendancebuttonarray]];
            attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:DetailsViewDTObject.attendance highlightbutton:DetailsViewDTObject.attendance attendancebuttonarray:attendancebuttonarray inview:windowview size:@"large"];
        }
        
        NSArray * windows = [[UIApplication sharedApplication] windows];
        UIWindow* win0 = [windows objectAtIndex:0];
        [win0 addSubview:attendanceringview];
        [win0 bringSubviewToFront:attendanceringview];
        lasttouchedsector=0;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void) refreshdocumentfoldercount
{
    if ((int)globalvariables.documentfolder.classinvoicearray.count+(int)globalvariables.documentfolder.classreceiptarray.count+(int)globalvariables.documentfolder.salesinvoicearray.count+(int)globalvariables.documentfolder.salesreceiptarray.count+(int)globalvariables.documentfolder.salespaymentarray.count+(int)globalvariables.documentfolder.classpaymentarray.count>0) {
        documentfoldercountlabel.hidden=NO;
    }else{
        documentfoldercountlabel.hidden=YES;
    }
    documentfolderbutton.hidden=NO;
    
    if ([studentAction isEqualToString:@"PopoverStudent"]) {
        [self.delegate refreshparentviewdocumentfoldercount];
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    globalvariables.lastviewcontroller=(NSString *)self;

    if (runviewdidappear && sidewindowview.frame.origin.x==mainWindow.bounds.size.width) {
        [self reloadPageWithFirstLoad:YES];
    }else{
        runviewdidappear=TRUE;
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    //pass DataChanged information to daily class schedule
    [self stopAudioPlaying];
    if (audioPlayer.playing) {
        [audioPlayer stop];
        audioPlayer=nil;
        [sliderTimer invalidate];
        //[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
    
    if (DataChanged) {
        [self.delegate refreshstudentdetailviewpresentingviewcontent];
    }
    
    
}

//-(void) donotrunviewdidappear
//{
//    runviewdidappear=FALSE;
//}

-(void) createdtviewtableheader
{
    /*NSArray *separatorweight_class=[[NSArray alloc]initWithObjects:@"4",@"4",@"6",@"8",@"4",@"6",@"6",@"16",nil];
    float fieldseparator=(DTRecordView.frame.size.width-50-8-10)/[[separatorweight_class valueForKeyPath:@"@sum.self"] floatValue];
    
    
    dt_header_subject=[[UILabel alloc]initWithFrame:CGRectMake(8, 37,  [[separatorweight_class objectAtIndex:0] intValue]*fieldseparator, 21)];
    dt_header_type=[[UILabel alloc]initWithFrame:CGRectMake(dt_header_subject.frame.origin.x+dt_header_subject.frame.size.width, 37,  [[separatorweight_class objectAtIndex:1] intValue]*fieldseparator, 21)];
    dt_header_level=[[UILabel alloc]initWithFrame:CGRectMake(dt_header_type.frame.origin.x+dt_header_type.frame.size.width, 37,  [[separatorweight_class objectAtIndex:2] intValue]*fieldseparator, 21)];
    dt_header_start=[[UILabel alloc]initWithFrame:CGRectMake(dt_header_level.frame.origin.x+dt_header_level.frame.size.width, 37,  [[separatorweight_class objectAtIndex:3] intValue]*fieldseparator, 21)];
    dt_header_time=[[UILabel alloc]initWithFrame:CGRectMake(dt_header_start.frame.origin.x+dt_header_start.frame.size.width, 37,  [[separatorweight_class objectAtIndex:4] intValue]*fieldseparator, 21)];
    dt_header_instructor=[[UILabel alloc]initWithFrame:CGRectMake(dt_header_time.frame.origin.x+dt_header_time.frame.size.width, 37,  [[separatorweight_class objectAtIndex:5] intValue]*fieldseparator, 21)];
    dt_header_classroom=[[UILabel alloc]initWithFrame:CGRectMake(dt_header_time.frame.origin.x+dt_header_time.frame.size.width, 53,  [[separatorweight_class objectAtIndex:5] intValue]*fieldseparator, 21)];
    dt_header_attendance=[[UILabel alloc]initWithFrame:CGRectMake(dt_header_instructor.frame.origin.x+dt_header_instructor.frame.size.width, 37,  [[separatorweight_class objectAtIndex:6] intValue]*fieldseparator, 21)];
    dt_header_remarks=[[UILabel alloc]initWithFrame:CGRectMake(dt_header_attendance.frame.origin.x+dt_header_attendance.frame.size.width+10, 37,  [[separatorweight_class objectAtIndex:7] intValue]*fieldseparator, 21)];*/
    
    
    dt_header_subject.text=[MyClass returntitlewithtitle:@"Subject"];

    
    dt_header_start.text=[MyClass returntitlewithtitle:@"Date"];

    
    dt_header_level.text=[MyClass returntitlewithtitle:@"Level"];

    
    dt_header_time.text=[MyClass returntitlewithtitle:@"Time"];

    
    dt_header_instructor.text=[MyClass returntitlewithtitle:@"Instructor"];

    
    dt_header_classroom.text=[MyClass returntitlewithtitle:@"Classroom"];

    
    dt_header_attendance.text=[MyClass returntitlewithtitle:@"Attendance"];

    
    dt_header_remarks.text=[MyClass returntitlewithtitle:@"Remarks"];

    
    dt_header_type.text=[MyClass returntitlewithtitle:@"Type"];

    
}

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverController
{
    //Reload data
    if (popoverController == myClassSelectionPopoverController) {
        [self drawpointerwithoption:@"closed" imageview:classselection_arrow];
        [self drawpointerwithoption:@"closed" imageview:dayselectionarrow];
        [self drawpointerwithoption:@"closed" imageview:typeselectionarrow];
    }else if (popoverController == myProductCategorySelectionPopoverController) {
        [self drawpointerwithoption:@"closed" imageview:productcategorybuttonarrow];
    }else if (popoverController == myDTSelectionPopoverController) {
        [self drawpointerwithoption:@"closed" imageview:dt_coursearrow];
        [self drawpointerwithoption:@"closed" imageview:dt_typearrow];
    }else if (popoverController == myCallLogCalledBySelectionPopoverController) {
        [self drawpointerwithoption:@"closed" imageview:calllog_callerarrow];
    }else if (popoverController == myDaySelectionPopoverController) {
        [self drawpointerwithoption:@"closed" imageview:dayselectionarrow];
        [self drawpointerwithoption:@"closed" imageview:classselection_arrow];
        [self drawpointerwithoption:@"closed" imageview:typeselectionarrow];
    }else if (popoverController == myTypeSelectionPopoverController) {
        [self drawpointerwithoption:@"closed" imageview:dayselectionarrow];
        [self drawpointerwithoption:@"closed" imageview:classselection_arrow];
        [self drawpointerwithoption:@"closed" imageview:typeselectionarrow];
    }else{
        if (lastviewindex==2) {
            if ([classviewmode isEqualToString:@"selectedEnrollment"]) {
                if(![self retrieveClassWithEnrollmentkey:DetailsViewEnrollment.enrollmentkey]){
                    return;
                }
            }else{
            }
        }else if (lastviewindex==4){
            [DetailsViewMessageTable deselectRowAtIndexPath:[DetailsViewMessageTable indexPathForSelectedRow] animated: YES];
        }else if (lastviewindex==1){
            if(![self retrieveStudent:DetailsViewStudent.studentkey]){
                return;
            }
            
            if(![self retrieveEnrollmentWithStudentkey:DetailsViewStudent.studentkey]){
                return;
            }else{
                [self returnfilterenrollmentarray];
            }
        }else if (lastviewindex==3){
            if(![self retrieveSalesRecord]){
                return;
            }
        }
    }

}

-(void) dismisssextendpopover{
    [self closesidewindow];
    if ([classviewmode isEqualToString:@"selectedEnrollment"]) {
        if(![self retrieveClassWithEnrollmentkey:DetailsViewEnrollment.enrollmentkey]){
            return;
        }
    }else{
        if(![self retrieveClassWithEnrollmentkey:nil]){
            return;
        }
    }
    DataChanged=YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == DetailsViewClassTable) {
        return filteredDetailsViewClassArray.count;
    }else if (tableView==RemainingClassSummaryTable){
        return ClassSummaryRecordArray.count;
    }else if (tableView==DetailsViewEnrollmentTable){
        return filteredDetailsViewEnrollmentArray.count;
    }else if (tableView==DetailsViewMessageTable){
        return filteredMessageArray.count;
    }else if (tableView==ClassSelectionTable){
        return SubjectArray.count;
    }else if (tableView==SalesTable){
        return filteredSalesRecordArray.count;
    }else if (tableView==CallLogTable){
        return filteredCallLogRecordArray.count;
    }else if (tableView==ProductCategorySelectionTable){
        return ProductCategoryArray.count;
    }else if (tableView==CallLogCalledBySelectionTable){
        return CallLogCalledByArray.count;
    }else if (tableView == DetailsViewDTTable) {
        return filteredDetailsViewDTArray.count;
    }else if (tableView == DTSubjectSelectionTable) {
        return DTSubjectArray.count;
    }else if (tableView == DaySelectionTable) {
        if (lastviewindex==1) {
            return dayarray.count;
        }else{
            return dayarray.count-1;
        }
    }else if (tableView == DaySelectionTable) {
        return typearray.count;
    }else if (tableView == TypeSelectionTable) {
        return typearray.count;
    }else if (tableView == DTTypeSelectionTable) {
        return DTTypeArray.count;
    }else if (tableView==SiblingTable){
        return DetailsViewStudent.siblingarray.count;
    }else if (tableView==sortingtable){
        return sortingarray.count;
    }else if (tableView==ViewHistoryTable){
        return viewhistoryarray.count;
    }else if (tableView==couponTable){
        return filteredDetailsViewCouponArray.count;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == DetailsViewDTTable) {
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"dtcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        DTRecord * DTObject;
        DTObject = [filteredDetailsViewDTArray objectAtIndex:indexPath.row];
        
        
        // Configure the cell...
        
        [cell.button2 setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:nil attendance:DTObject.attendance makeupattendance:nil]] forState:UIControlStateNormal];
        [cell.button2 addTarget: self action:@selector(attendancebuttontouchupinside:) forControlEvents: UIControlEventTouchUpInside];
        [cell.button2 addTarget: self action:@selector(attendancebuttontouchdown:) forControlEvents: UIControlEventTouchDown];
        cell.button2.enabled=![MyClass classLocked:DTObject.locked];
        
        cell.label1.text=DTObject.subject;
        cell.label6.text=DTObject.subjectfullname;
        cell.label6.text=[MyClass returnLevelWithSubject:DTObject.subject Levelmain:DTObject.levelmain Levelctm:DTObject.levelctm];
        cell.label2.text=[MyClass returntitlewithtitle:[DTObject.classtype isEqualToString:@"Assessment"]?@"Assess":@"Trial"];
        
        cell.label4.text = [MyClass returndateformatwithdate:DTObject.DTdate];
        cell.label8.text=[DTObject.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:DTObject.classroom;;
        
        cell.label3.text=[MyClass returnLevelWithSubject:DTObject.subject Levelmain:DTObject.levelmain Levelctm:DTObject.levelctm];

        
        cell.label5.text = DTObject.DTtime;

        [cell.button1 setTitle:[MyClass returninstructornamewithusername:DTObject.instructor firstorfullname:@"first"] forState:UIControlStateNormal];
        
        [cell.button1 addTarget:self action:@selector(dt_instructor_pressed:) forControlEvents:UIControlEventTouchUpInside];
        if ([DTObject.instructor isEqualToString:@"TBD"]) {
            [cell.button1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            cell.button1.userInteractionEnabled=NO;
        }else{
            [cell.button1 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            cell.button1.userInteractionEnabled=YES;
        }
        
        cell.label6.text=DTObject.remarks;
        cell.label7.text=DTObject.subjectfullname;
        
        //Accessory
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //alternative background color;
        if (indexPath.row % 2!=0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        if([DTObject.DTkey isEqualToString:selectedDTkey]){
            cell.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:178.0/255.0 blue:103.0/255.0 alpha:1.0];
        }
        
        
        return cell;
        
        
    }else if (tableView == DetailsViewClassTable) {
        
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"classcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        ClassRecord * ClassObject;
        ClassObject = [filteredDetailsViewClassArray objectAtIndex:indexPath.row];
        

        
        // Configure the cell...
        [cell.button2 setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:@"Class" attendance:ClassObject.attendance makeupattendance:nil]] forState:UIControlStateNormal];
        [cell.button2 addTarget: self action:@selector(attendancebuttontouchupinside:) forControlEvents: UIControlEventTouchUpInside];
        [cell.button2 addTarget: self action:@selector(attendancebuttontouchdown:) forControlEvents: UIControlEventTouchDown];
        cell.button2.enabled=![MyClass classLocked:ClassObject.locked];
        
        cell.label1.text=ClassObject.subjectfullname;//ClassObject.subject;
        
        cell.label7.text=[NSString stringWithFormat:@"%@ (%@)",ClassObject.subject,[MyClass returnschedulenamewithsubject_shortname:ClassObject.subject schedulekey:ClassObject.schedulekey centerkey:globalvariables.centerrecord.centerkey]];

//        cell.label2.text=[MyClass returnLevelWithSubject:ClassObject.subject Levelmain:ClassObject.levelmain Levelctm:ClassObject.levelctm];
//        if(globalvariables.centerrecord.enablelessonnumber && ![ClassObject.lesson isEqualToString:@""]){
//            cell.label2.text=[NSString stringWithFormat:@"%@/%@",cell.label2.text,ClassObject.lesson];
//        }
        
        cell.label2.text=[MyClass returnLevelLessonWithClassRecord:ClassObject];
        
        
        if ([ClassObject.status isEqualToString:@"Voided"]) {
            [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tiffany_background.png"]]];
            cell.label9.text=@"V";
            cell.view1.hidden=NO;
        }else if ([ClassObject.draft isEqualToString:@"Yes"]) {
            [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gray_background.png"]]];
            cell.label9.text=@"D";
            cell.view1.hidden=NO;
        }else{
            cell.view1.hidden=YES;
        }
        
        cell.label3.text=[MyClass returndateformatwiththisyearfromDDMMMYYYY:ClassObject.startdate];
        cell.label4.text=[MyClass returndateformatEEEwithdate:ClassObject.classday];
        cell.label5.text = [ClassObject.classtime isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:ClassObject.classtime;
        
        
        [cell.button1 addTarget:self action:@selector(class_instructor_pressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.button1 setTitle:[ClassObject.instructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:ClassObject.instructor firstorfullname:@"first"] forState:UIControlStateNormal];
        
        if ([ClassObject.instructor isEqualToString:@"TBD"]) {
            [cell.button1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            cell.button1.userInteractionEnabled=NO;
        }else{
            [cell.button1 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            cell.button1.userInteractionEnabled=YES;
        }
        
        if(globalvariables.centerrecord.secondaryinstructor){
            [cell.button5 addTarget:self action:@selector(class_sinstructor_pressed:) forControlEvents:UIControlEventTouchUpInside];
            [cell.button5 setTitle:[ClassObject.sinstructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:ClassObject.sinstructor firstorfullname:@"first"] forState:UIControlStateNormal];
            if ([ClassObject.sinstructor isEqualToString:@"TBD"]) {
                [cell.button5 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                cell.button5.userInteractionEnabled=NO;
            }else{
                [cell.button5 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                cell.button5.userInteractionEnabled=YES;
            }
            cell.button5.hidden=[ClassObject.sinstructor isEqualToString:@"TBD"]||[ClassObject.sinstructor isEqualToString:@""];
        }else{
            cell.button5.hidden=YES;
        }
        
        
        cell.label8.text=[ClassObject.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:ClassObject.classroom;
        
        
        if ([ClassObject.attendance isEqualToString:@"Extend"]) {
            cell.view2.hidden=NO;
            cell.label11.text=ClassObject.extensiontime;
        }else{
            cell.view2.hidden=YES;
        }
        
        
        [cell.button3 addTarget: self action:@selector(makeupdatetimebuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
        if ([ClassObject.attendance isEqualToString:@"Makeup"]) {
            cell.button3.hidden=NO;
            cell.button3.enabled=![MyClass classLocked:ClassObject.locked];
            if (![ClassObject.makeupdate isEqualToString:@""]) {
                cell.label9.hidden=NO;
                [cell.button3 setTitle:[NSString stringWithFormat:@"%@ (%@)",[MyClass returndateformatDDMMMHHMMwithdate:[NSString stringWithFormat:@"%@ %@",[ClassObject.makeupdate substringToIndex:6],ClassObject.makeuptime]],[MyClass returndateformatEEEwithDDMMMYYYYdate:ClassObject.makeupdate]] forState:UIControlStateNormal];
                if ([ClassObject.makeupdate isEqualToString:@""] || [ClassObject.makeuptime isEqualToString:@""] || [ClassObject.makeupinstructor isEqualToString:@""] || [ClassObject.makeupinstructor isEqualToString:@"TBD"]) {
                    [cell.button3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    [cell.button3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
                }else{
                    [cell.button3 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                    [cell.button3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
                }
                
                if ([ClassObject.makeupinstructor isEqualToString:@"TBD"]) {
                    cell.label9.text=[MyClass returntitlewithtitle:@"TBD"];
                }else{
                    cell.label9.text=[MyClass returninstructornamewithusername:ClassObject.makeupinstructor firstorfullname:@"first"];
                }
                cell.imageview1.hidden=NO;
                [cell.imageview1 setImage:[UIImage imageNamed:[MyClass returnmakeupattendanceimagewithmakeupattendance:ClassObject.makeupattendance]]];
            }else{
                [cell.button3 setTitle:[MyClass returntitlewithtitle:@"Select time"] forState:UIControlStateNormal];
                [cell.button3 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [cell.button3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
                cell.label9.hidden=YES;
                cell.imageview1.hidden=YES;
            }
        }else{
            cell.button3.hidden=YES;
            cell.label9.hidden=YES;
            cell.imageview1.hidden=YES;
        }
        
        
        if ([ClassObject.extendedminute intValue] !=0) {
            cell.label10.hidden=NO;
            if ([ClassObject.attendance isEqualToString:@"Makeup"] && ![ClassObject.makeupdate isEqualToString:@""]) {
                cell.stackview1.hidden=NO;
            }else{
                cell.stackview1.hidden=YES;
            }
            
            cell.label10.text=[NSString stringWithFormat:@"+%@ %@",ClassObject.extendedminute,[MyClass returntitlewithtitle:@"mins"]];
        }else{
            cell.label10.hidden=YES;
            cell.stackview1.hidden=NO;
        }
        
        NSMutableArray *remarksarray=[[NSMutableArray alloc]init];

        
        if (![ClassObject.parentnote isEqualToString:@""]) {
            [remarksarray addObject:[NSString stringWithFormat:@"<%@>",[MyClass returntitlewithtitle:ClassObject.parentnote]]];
        }
        
        if (![ClassObject.remarks isEqualToString:@""]) {
            [remarksarray addObject:ClassObject.remarks];
        }
        
        if (![ClassObject.allclassremarks isEqualToString:@""]) {
            [remarksarray addObject:ClassObject.allclassremarks];
        }

        if (![ClassObject.absentmakeupreason isEqualToString:@""]) {
            [remarksarray addObject:ClassObject.absentmakeupreason];
        }
        
        if (remarksarray.count>0) {
            cell.label6.text=[remarksarray componentsJoinedByString:@","];
        }else{
            cell.label6.text=@"";
        }

        cell.button4.tag=indexPath.row;
        [cell.button4 addTarget: self action:@selector(classinformationbuttonpressed:) forControlEvents: UIControlEventTouchUpInside];
        
        //Accessory
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        //alternative background color;
        if (indexPath.row % 2!=0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        if([ClassObject.classkey isEqualToString:selectedClasskey]){
            cell.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:178.0/255.0 blue:103.0/255.0 alpha:1.0];
        }
        
        
        if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
            cell.button3.hidden=YES;
        }
        
        if (!globalvariables.centerrecord.studentassessmentform || ClassObject.assessmentformcount==0) {
            cell.label12.hidden=YES;
            cell.imageview2.hidden=YES;
        }else{
            cell.label12.text=[NSString stringWithFormat:@"%i",ClassObject.assessmentformcount];
            cell.label12.hidden=NO;
            cell.imageview2.hidden=NO;
        }
        
        return cell;
        
    }else if(tableView==DetailsViewEnrollmentTable){
        
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"enrollmentcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        
        // Configure the cell...
        EnrollmentRecord * EnrollmentObject;
        EnrollmentObject = [filteredDetailsViewEnrollmentArray objectAtIndex:indexPath.row];
        cell.label1.text = EnrollmentObject.subjectfullname;
        cell.label9.text=[NSString stringWithFormat:@"%@ (%@)",EnrollmentObject.subject,[MyClass returnschedulenamewithsubject_shortname:EnrollmentObject.subject schedulekey:EnrollmentObject.schedulekey centerkey:globalvariables.centerrecord.centerkey]];

        cell.label2.text=[MyClass returnLevelWithSubject:EnrollmentObject.subject Levelmain:EnrollmentObject.levelmain Levelctm:EnrollmentObject.levelctm];
        cell.button2.hidden=YES;
        if ([EnrollmentObject.status isEqualToString:@"Voided"]) {
            [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tiffany_background.png"]]];
            cell.label11.text=@"V";
            cell.label11.hidden=NO;
            cell.view1.hidden=NO;
        }else if ([EnrollmentObject.draft isEqualToString:@"Yes"]) {
            [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"gray_background.png"]]];
            cell.label11.text=@"D";
            cell.label11.hidden=NO;
            cell.view1.hidden=NO;
        }else if ([EnrollmentObject.dropclassstatus isEqualToString:@"Yes"]) {
            if ([EnrollmentObject.paid floatValue]<=0 && [EnrollmentObject.totalfee floatValue]>0) {
                [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_background.png"]]];
            }else if ([EnrollmentObject.paid floatValue]<[EnrollmentObject.totalfee floatValue]){
                [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"orange_background.png"]]];
            }else if ([EnrollmentObject.paid floatValue]>[EnrollmentObject.totalfee floatValue]){
                [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_background.png"]]];
            }else{
                [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tiffany_background.png"]]];
            }
            
            cell.label11.text=@"Q";
            cell.label11.hidden=NO;
            cell.view1.hidden=NO;
        }else if ([EnrollmentObject.totalfee floatValue] !=[EnrollmentObject.paid floatValue]) {
            if ([EnrollmentObject.paid floatValue]<=0 && [EnrollmentObject.totalfee floatValue]>0 ) {
                [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_background.png"]]];
                cell.label11.text=@"$";
            }else if ([EnrollmentObject.paid floatValue]<[EnrollmentObject.totalfee floatValue]){
                [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"orange_background.png"]]];
                cell.label11.text=@"$";
            }else{
                [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_background.png"]]];
                cell.label11.text=@"$";
            }
            cell.label11.hidden=NO;
            cell.view1.hidden=NO;
        }else{
            [cell.view1 setBackgroundColor:[UIColor clearColor]];
            cell.label11.hidden=YES;
            cell.view1.hidden=YES;
        }
        
        //show outstanding button
        if ([EnrollmentObject.totalfee floatValue] !=[EnrollmentObject.paid floatValue]) {
            if ([EnrollmentObject.paid floatValue]<=0 && [EnrollmentObject.totalfee floatValue]>0 ) {
                [cell.button2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_background.png"]]];
            }else if ([EnrollmentObject.paid floatValue]<[EnrollmentObject.totalfee floatValue]){
                [cell.button2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"orange_background.png"]]];
            }else{
                [cell.button2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_background.png"]]];
            }

            [cell.button2 setTitle:[currencyformatter stringFromNumber:[NSNumber numberWithFloat:[EnrollmentObject.totalfee floatValue]-[EnrollmentObject.paid floatValue]]] forState:UIControlStateNormal];
            cell.button2.hidden=NO;
            cell.button2.tag=indexPath.row;
            [cell.button2 addTarget:self action:@selector(enrollmentoutstandingbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            cell.button2.enabled=![self isEnrollmentLockedWithEnrollment:EnrollmentObject];
        }
        
        

        cell.label3.text=[MyClass returndateformatwiththisyearfromDDMMMYYYY:EnrollmentObject.startdate];
        cell.label4.text=[MyClass returndateformatwiththisyearfromDDMMMYYYY:EnrollmentObject.enddate];
        

        cell.label5.text=[MyClass returndateformatEEEwithdate:EnrollmentObject.classday];
        cell.label6.text =([EnrollmentObject.classtime isEqualToString:@"TBD"] ||[EnrollmentObject.classtime isEqualToString:@"TBF"]||[EnrollmentObject.classtime isEqualToString:@"Multi"])?[MyClass returntitlewithtitle:EnrollmentObject.classtime]:EnrollmentObject.classtime;

        [cell.button1 setTitle:([EnrollmentObject.instructor isEqualToString:@"TBD"] ||[EnrollmentObject.instructor isEqualToString:@"TBF"]||[EnrollmentObject.instructor isEqualToString:@"Multi"])?[MyClass returntitlewithtitle:EnrollmentObject.instructor]: [MyClass returninstructornamewithusername:EnrollmentObject.instructor firstorfullname:@"full"] forState:UIControlStateNormal];
        
        [cell.button1 addTarget:self action:@selector(enrollment_instructor_pressed:) forControlEvents:UIControlEventTouchUpInside];
        if ([EnrollmentObject.instructor isEqualToString:@"TBD"] || [EnrollmentObject.instructor isEqualToString:@"TBF"] || [EnrollmentObject.instructor isEqualToString:@"Multi"]) {
            [cell.button1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            cell.button1.userInteractionEnabled=NO;
        }else{
            [cell.button1 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            cell.button1.userInteractionEnabled=YES;
        }
        
        if(globalvariables.centerrecord.secondaryinstructor){
            [cell.button3 setTitle:([EnrollmentObject.sinstructor isEqualToString:@"TBD"] ||[EnrollmentObject.sinstructor isEqualToString:@"TBF"]||[EnrollmentObject.sinstructor isEqualToString:@"Multi"])?[MyClass returntitlewithtitle:EnrollmentObject.sinstructor]: [MyClass returntitlewithtitle:[MyClass returninstructornamewithusername:EnrollmentObject.sinstructor firstorfullname:@"full"]] forState:UIControlStateNormal];
            
            [cell.button3 addTarget:self action:@selector(enrollment_sinstructor_pressed:) forControlEvents:UIControlEventTouchUpInside];
            if ([EnrollmentObject.sinstructor isEqualToString:@"TBD"] || [EnrollmentObject.sinstructor isEqualToString:@"TBF"] || [EnrollmentObject.sinstructor isEqualToString:@"Multi"]) {
                [cell.button3 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                cell.button3.userInteractionEnabled=NO;
            }else{
                [cell.button3 setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
                cell.button3.userInteractionEnabled=YES;
            }
            cell.button3.hidden=[EnrollmentObject.sinstructor isEqualToString:@"TBD"] || [EnrollmentObject.sinstructor isEqualToString:@""];
        }else{
            cell.button3.hidden=YES;
        }

        
        
        cell.label7.text=[EnrollmentObject.noofclass isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]: EnrollmentObject.noofclass;
        cell.label10.text =([EnrollmentObject.classroom isEqualToString:@"TBD"] ||[EnrollmentObject.classroom isEqualToString:@"TBF"]||[EnrollmentObject.classroom isEqualToString:@"Multi"])?[MyClass returntitlewithtitle:EnrollmentObject.classroom]:EnrollmentObject.classroom;
        
        if (![EnrollmentObject.remarks isEqual:[NSNull null]]){
            cell.label8.text=EnrollmentObject.remarks;
        }else{
            cell.label8.text=@"";
        }

        
        if ([EnrollmentObject.autorenew isEqualToString:@"Yes"] && globalvariables.centerrecord.enableautobatchrenew) {
            cell.imageview1.hidden=NO;
            //[enrollment_Schedule setFrame:CGRectMake(28+combinepaymentoffset, 18, 290, 21)];
        }else{
            cell.imageview1.hidden=YES;
            //[enrollment_Schedule setFrame:CGRectMake(15+combinepaymentoffset, 18, 290, 21)];
        }
        
        
        if (isSelectCombinePayment) {
            cell.imageview2.layer.borderColor=[UIColor lightGrayColor].CGColor;
            cell.imageview2.layer.borderWidth=0.5;
            cell.view2.hidden=NO;
            
            

            if ([globalvariables.documentfolder.classpaymentarray containsObject:EnrollmentObject.enrollmentkey]) {
                if ([globalvariables.documentfolder.classinvoicearray containsObject:EnrollmentObject.enrollmentkey]) {
                    if (![[MyClass returnLastPaymentKeyWithPaymentRecords:EnrollmentObject.paymentrecords] isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:EnrollmentObject.enrollmentkey]) {
                        [cell.imageview2 setImage:[UIImage imageNamed:@"redgreenorange_icon.png"]];
                    }else{
                        [cell.imageview2 setImage:[UIImage imageNamed:@"greenred_icon.png"]];
                    }
                }else{
                    if (![[MyClass returnLastPaymentKeyWithPaymentRecords:EnrollmentObject.paymentrecords] isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:EnrollmentObject.enrollmentkey]) {
                        [cell.imageview2 setImage:[UIImage imageNamed:@"orangered_icon.png"]];
                    }else{
                        [cell.imageview2 setImage:[UIImage imageNamed:@"red_icon.png"]];
                    }
                }
            }else{
                if ([globalvariables.documentfolder.classinvoicearray containsObject:EnrollmentObject.enrollmentkey]) {
                    if (![[MyClass returnLastPaymentKeyWithPaymentRecords:EnrollmentObject.paymentrecords] isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:EnrollmentObject.enrollmentkey]) {
                        [cell.imageview2 setImage:[UIImage imageNamed:@"greenorange_icon.png"]];
                    }else{
                        [cell.imageview2 setImage:[UIImage imageNamed:@"green_icon.png"]];
                    }
                }else{
                    if (![[MyClass returnLastPaymentKeyWithPaymentRecords:EnrollmentObject.paymentrecords] isEqualToString:@""] && [globalvariables.documentfolder.classreceiptarray containsObject:EnrollmentObject.enrollmentkey]) {
                        [cell.imageview2 setImage:[UIImage imageNamed:@"orange_icon.png"]];
                    }else{
                        [cell.imageview2 setImage:nil];
                    }
                }
            }
        }else{
            cell.view2.hidden=YES;
        }
        
        //Accessory
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //alternative background color;
        if (indexPath.row % 2!=0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        if([EnrollmentObject.enrollmentkey isEqualToString:selectedEnrollmentkey]){
            cell.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:178.0/255.0 blue:103.0/255.0 alpha:1.0];
        }else if([[MyClass convertToNSDateWithDate:EnrollmentObject.billdate DateFormat:@"dd-MMM-yyyy"] compare:[NSDate date]]==NSOrderedDescending){
            cell.backgroundColor=[UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:0.8];
        }
        
        cell.button4.tag=indexPath.row;
        [cell.button4 addTarget:self action:@selector(enrollmentinvoicebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.button5.tag=indexPath.row;
        [cell.button5 addTarget:self action:@selector(enrollmentreceiptbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.button5.layer.opacity=EnrollmentObject.paymentrecords.count==0?0.3:1.0;
        cell.button5.userInteractionEnabled=EnrollmentObject.paymentrecords.count>0;
        
        return cell;
        
    }else if (tableView==RemainingClassSummaryTable){
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];// forIndexPath:indexPath];
        
        ClassSummaryRecord *classsummaryobject =[[ClassSummaryRecord alloc]init];
        classsummaryobject = [ClassSummaryRecordArray objectAtIndex:indexPath.row];
        
        
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            //add textfield
            classsummarysubjectlabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 120, 38)];
            classsummarysubjectlabel.font=[UIFont systemFontOfSize:14];
            classsummarysubjectlabel.textColor=[UIColor darkGrayColor];
            //InstructorLabel.textAlignment=NSTextAlignmentCenter;
            classsummarysubjectlabel.tag=180;
            [cell.contentView addSubview:classsummarysubjectlabel];
            
            classsummarynextclasslabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 0, 110, 38)];
            classsummarynextclasslabel.font=[UIFont systemFontOfSize:14];
            classsummarynextclasslabel.textColor=[UIColor darkGrayColor];
            //LevelLabel.textAlignment=NSTextAlignmentCenter;
            classsummarynextclasslabel.tag=181;
            [cell.contentView addSubview:classsummarynextclasslabel];
            
            classsummarylastclasslabel = [[UILabel alloc]initWithFrame:CGRectMake(205, 0, 110,38)];
            classsummarylastclasslabel.font=[UIFont systemFontOfSize:14];
            classsummarylastclasslabel.textColor=[UIColor darkGrayColor];
            //NextClassLabel.textAlignment=NSTextAlignmentCenter;
            classsummarylastclasslabel.tag=182;
            [cell.contentView addSubview:classsummarylastclasslabel];
            
            classsummaryremainingclasslabel_scheduledclass = [[UILabel alloc]initWithFrame:CGRectMake(335, 10, 18, 18)];
            classsummaryremainingclasslabel_scheduledclass.font=[UIFont systemFontOfSize:12];
            classsummaryremainingclasslabel_scheduledclass.textColor=[UIColor whiteColor];
            classsummaryremainingclasslabel_scheduledclass.textAlignment=NSTextAlignmentCenter;
            classsummaryremainingclasslabel_scheduledclass.layer.cornerRadius=4;
            classsummaryremainingclasslabel_scheduledclass.layer.masksToBounds=YES;
            classsummaryremainingclasslabel_scheduledclass.backgroundColor=[UIColor grayColor];
            classsummaryremainingclasslabel_scheduledclass.tag=183;
            [cell.contentView addSubview:classsummaryremainingclasslabel_scheduledclass];

            classsummaryremainingclasslabel_tbdclass = [[UILabel alloc]initWithFrame:CGRectMake(360, 10, 18, 18)];
            classsummaryremainingclasslabel_tbdclass.font=[UIFont systemFontOfSize:12];
            classsummaryremainingclasslabel_tbdclass.textColor=[UIColor whiteColor];
            classsummaryremainingclasslabel_tbdclass.textAlignment=NSTextAlignmentCenter;
            classsummaryremainingclasslabel_tbdclass.layer.cornerRadius=4;
            classsummaryremainingclasslabel_tbdclass.layer.masksToBounds=YES;
            classsummaryremainingclasslabel_tbdclass.backgroundColor=[UIColor grayColor];
            classsummaryremainingclasslabel_tbdclass.tag=185;
            [cell.contentView addSubview:classsummaryremainingclasslabel_tbdclass];
            
            classsummaryremainingclasslabel_tbdmakeup = [[UILabel alloc]initWithFrame:CGRectMake(385, 10, 18, 18)];
            classsummaryremainingclasslabel_tbdmakeup.font=[UIFont systemFontOfSize:12];
            classsummaryremainingclasslabel_tbdmakeup.textColor=[UIColor whiteColor];
            classsummaryremainingclasslabel_tbdmakeup.textAlignment=NSTextAlignmentCenter;
            classsummaryremainingclasslabel_tbdmakeup.layer.cornerRadius=4;
            classsummaryremainingclasslabel_tbdmakeup.layer.masksToBounds=YES;
            classsummaryremainingclasslabel_tbdmakeup.backgroundColor=[UIColor grayColor];
            classsummaryremainingclasslabel_tbdmakeup.tag=186;
            [cell.contentView addSubview:classsummaryremainingclasslabel_tbdmakeup];
            
            classsummaryoutstandinglabel = [[UILabel alloc]initWithFrame:CGRectMake(470, 0, 100, 38)];
            classsummaryoutstandinglabel.font=[UIFont systemFontOfSize:14];
            classsummaryoutstandinglabel.textColor=[UIColor darkGrayColor];
            classsummaryoutstandinglabel.textAlignment=NSTextAlignmentRight;
            classsummaryoutstandinglabel.tag=184;
            [cell.contentView addSubview:classsummaryoutstandinglabel];
            
            classsummarysubjectschedulelabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 500, 38)];
            classsummarysubjectschedulelabel.font=[UIFont systemFontOfSize:12];
            classsummarysubjectschedulelabel.textColor=[UIColor grayColor];
            //InstructorLabel.textAlignment=NSTextAlignmentCenter;
            classsummarysubjectschedulelabel.tag=187;
            [cell.contentView addSubview:classsummarysubjectschedulelabel];
            
            classsummaryoutstandingextendtimelabel = [[UILabel alloc]initWithFrame:CGRectMake(410, 10, 30, 18)];
            classsummaryoutstandingextendtimelabel.font=[UIFont systemFontOfSize:12];
            classsummaryoutstandingextendtimelabel.textColor=[UIColor whiteColor];
            classsummaryoutstandingextendtimelabel.textAlignment=NSTextAlignmentCenter;
            classsummaryoutstandingextendtimelabel.layer.cornerRadius=4;
            classsummaryoutstandingextendtimelabel.layer.masksToBounds=YES;
            classsummaryoutstandingextendtimelabel.backgroundColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0];
            classsummaryoutstandingextendtimelabel.tag=189;
            [cell.contentView addSubview:classsummaryoutstandingextendtimelabel];
            
            classsummaryautorenewimage=[[UIImageView alloc]initWithFrame:CGRectMake(310, 10, 18, 18)];
            classsummaryautorenewimage.layer.cornerRadius=4;
            classsummaryautorenewimage.tag=188;
            classsummaryautorenewimage.layer.masksToBounds=YES;
            [classsummaryautorenewimage setImage:[UIImage imageNamed:@"classrenewal_icon.png"]];
            [cell.contentView addSubview:classsummaryautorenewimage];
            
        }else{
            
            classsummarysubjectlabel=(UILabel *)[cell.contentView viewWithTag:180];
            classsummarynextclasslabel=(UILabel *)[cell.contentView viewWithTag:181];
            classsummarylastclasslabel=(UILabel *)[cell.contentView viewWithTag:182];
            classsummaryremainingclasslabel_scheduledclass=(UILabel *)[cell.contentView viewWithTag:183];
            classsummaryoutstandinglabel=(UILabel *)[cell.contentView viewWithTag:184];
            classsummaryremainingclasslabel_tbdclass=(UILabel *)[cell.contentView viewWithTag:185];
            classsummaryremainingclasslabel_tbdmakeup=(UILabel *)[cell.contentView viewWithTag:186];
            classsummarysubjectschedulelabel=(UILabel *)[cell.contentView viewWithTag:187];
            classsummaryautorenewimage=(UIImageView *)[cell.contentView viewWithTag:188];
            classsummaryoutstandingextendtimelabel=(UILabel *)[cell.contentView viewWithTag:189];
        }
        
        // Configure the cell...
        classsummarysubjectlabel.text=classsummaryobject.subject;
        classsummarynextclasslabel.text=[MyClass returndateformatDDMMMHHMMwithdate:classsummaryobject.nextclass];
        classsummarylastclasslabel.text=[MyClass returndateformatDDMMMHHMMwithdate:classsummaryobject.lastscheduledclass];
        classsummaryremainingclasslabel_scheduledclass.text=classsummaryobject.remainingclassscheduled;
        classsummaryremainingclasslabel_tbdclass.text=classsummaryobject.remainingclassTBDclass;
        classsummaryremainingclasslabel_tbdmakeup.text=classsummaryobject.remainingclassTBDmakeup;
        classsummaryoutstandingextendtimelabel.hidden=globalvariables.centerrecord.enableattendanceextend?NO:YES;
        if ([classsummaryobject.outstandingextendtime intValue]==0) {
            classsummaryoutstandingextendtimelabel.hidden=YES;
            classsummaryoutstandingextendtimelabel.text=@"";
        }else{
            classsummaryoutstandingextendtimelabel.hidden=NO;
            classsummaryoutstandingextendtimelabel.text=classsummaryobject.outstandingextendtime;
        }
        
        if ([classsummaryobject.outstandingpayment intValue]==0) {
            classsummaryoutstandinglabel.text=@"-";
        }else{
            classsummaryoutstandinglabel.text=[NSString stringWithFormat:@"$%@",classsummaryobject.outstandingpayment];
        }
        
        classsummarysubjectschedulelabel.text=[MyClass returnsubjectnamewithsubject_shortname:classsummaryobject.subject centerkey:globalvariables.centerrecord.centerkey];
        
        NSString *schedulename=[MyClass returnschedulenamewithsubject_shortname:classsummaryobject.subject schedulekey:classsummaryobject.schedulekey centerkey:globalvariables.centerrecord.centerkey];
        
        
        if (schedulename) {
            classsummarysubjectschedulelabel.text=[NSString stringWithFormat:@"%@ (%@)",classsummarysubjectschedulelabel.text,schedulename];
        }
        
        if ([classsummaryobject.autorenew isEqualToString:@"Yes"]) {
            classsummaryautorenewimage.hidden=NO;
        }else{
            classsummaryautorenewimage.hidden=YES;
        }
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }else if (tableView==DetailsViewMessageTable){
        
        InboxMessageRecord *messagerecordobject=[filteredMessageArray objectAtIndex:indexPath.row];
        MyTableViewCell *myCell;
           static NSString *CellIdentifier;
           if ([messagerecordobject.type isEqualToString:@"received"]) {
               if (messagerecordobject.photoarray.count==0) {
                   if([self showReplyCellViewWithMessageRecord:messagerecordobject]){
                       CellIdentifier = @"messagecelltextonly_reply_received";
                   }else{
                       CellIdentifier = @"messagecelltextonly_received";
                   }
                   myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
               }else{
                   if (messagerecordobject.photoarray.count==1 && [((MessagePhotoRecord *)[messagerecordobject.photoarray firstObject]).filetype isEqualToString:@"audio"]) {
                       CellIdentifier = @"messagecellaudio_received";
                   }else{
                       CellIdentifier = @"messagecellimage_received";
                   }
                   myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
               }
               if (myCell == nil) {
                   myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
               }
           }else{
               if (messagerecordobject.photoarray.count==0) {
                   if([self showReplyCellViewWithMessageRecord:messagerecordobject]){
                       CellIdentifier = @"messagecelltextonly_reply_sent";
                   }else{
                       CellIdentifier = @"messagecelltextonly_sent";
                   }
                   myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
               }else{
                   if (messagerecordobject.photoarray.count==1 && [((MessagePhotoRecord *)[messagerecordobject.photoarray firstObject]).filetype isEqualToString:@"audio"]) {
                       CellIdentifier = @"messagecellaudio_sent";
                   }else{
                       CellIdentifier = @"messagecellimage_sent";
                   }
                   myCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
               }
               if (myCell == nil) {
                   myCell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
               }
               

               
           }

        //myCell.label1.hidden=YES;

        if (selectMode) {
            myCell.view7.hidden=NO;
            myCell.imageview7.layer.opacity=[selectedinboxmessages containsObject:messagerecordobject.inboxmessagekey]?1.0:0.3;
        }else{
            myCell.view7.hidden=YES;
        }

           if ([globalvariables.language isEqualToString:@"English"]) {
               if (![messagerecordobject.messageenglish isEqualToString:@""]) {
                   myCell.label2.text=messagerecordobject.messageenglish;
               }else{
                   myCell.label2.text=messagerecordobject.messagechinese;
               }
           }else{
               if (![messagerecordobject.messagechinese isEqualToString:@""]) {
                   myCell.label2.text=messagerecordobject.messagechinese;
               }else{
                   myCell.label2.text=messagerecordobject.messageenglish;
               }
           }
         
        myCell.label2.hidden=[myCell.label2.text isEqualToString:@""];
           
        myCell.label3.text=[MyClass returnMessageTimeWithMessageStartTime:messagerecordobject.messagestarttime];
        if (messagerecordobject.photoarray.count==1 && [((MessagePhotoRecord *)[messagerecordobject.photoarray firstObject]).filetype isEqualToString:@"audio"]) {
            myCell.label3.text=[NSString stringWithFormat:@"%@ / %@",myCell.label3.text,[MyClass returnDurationWithSecond:((MessagePhotoRecord *)[messagerecordobject.photoarray firstObject]).height]];
        }
        
        myCell.label4.text=[MyClass returntitlewithtitle:messagerecordobject.messagetype];
        if ([messagerecordobject.messagetype isEqualToString:@"Important"]) {
            myCell.label4.textColor=[UIColor redColor];
        }else{
            myCell.label4.textColor=[UIColor lightGrayColor];
        }
               
        if (messagerecordobject.photoarray.count>0) {
            if (messagerecordobject.photoarray.count==1 && [((MessagePhotoRecord *)[messagerecordobject.photoarray firstObject]).filetype isEqualToString:@"audio"]) {
                UIImage *image=[self imageWithImage:[UIImage imageNamed:@"slider_thumb.png"] scaledToSize:CGSizeMake(12, 12)];
                [myCell.slider1 setThumbImage:image forState:UIControlStateNormal];
                myCell.slider1.tag=indexPath.row;
                [myCell.slider1 addTarget:self action:@selector(audioSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
                myCell.slider1.value=0;
                myCell.button4.tag=indexPath.row;
                [myCell.button4 addTarget:self action:@selector(playAudioButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [myCell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
                
                myCell.button1.hidden=NO;
                myCell.button1.tag=indexPath.row;
                [myCell.button1 addTarget:self action:@selector(sharephotobuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                myCell.button1.hidden=selectMode;
            }else{
                [[myCell.stackview1 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (int i=0; i<messagerecordobject.photoarray.count; i++) {
                    MessagePhotoRecord *obj=[messagerecordobject.photoarray objectAtIndex:i];
                    
                    float aspectRatio;
                    messageDocumentUIView *messagedocumentview=[[messageDocumentUIView alloc]initWithFrame:CGRectMake(0, 0, 380, 200) messagePhotoRecord:obj];
                    UIImageView *image=messagedocumentview.imageview;
                    [messagedocumentview setTranslatesAutoresizingMaskIntoConstraints:NO];
                    
                    [myCell.stackview1 addArrangedSubview:messagedocumentview];
                    
                    if ([obj.filetype isEqualToString:@"image"]) {
                        aspectRatio=[MyClass returnMinimumValueWithAValue:obj.height/obj.width BValue:1.0];
                    }else if ([obj.filetype isEqualToString:@"video"]) {
                        aspectRatio=5.0/8.0;
                    }else{
                        aspectRatio=3.0/4.0;
                    }
                    
                    [messagedocumentview addConstraint:[NSLayoutConstraint
                                                      constraintWithItem:messagedocumentview
                                                      attribute:NSLayoutAttributeHeight
                                                      relatedBy:NSLayoutRelationEqual
                                                      toItem:messagedocumentview
                                                      attribute:NSLayoutAttributeWidth
                                                      multiplier:aspectRatio
                                                      constant:0]];
                    
                    if (!obj.thumbnailurl || [obj.thumbnailurl isEqualToString:@""]) {
                        image.image=obj.imageview.image;
                    }else{
                        [MyClass downloadImageWithImageview:image gender:nil type:@"message" typekey:obj.thumbnailurl image:@"Yes" async:YES];
                    }
                    
                    [messagedocumentview.viewbutton addTarget:self action:@selector(tapMessagePhotoDetected:) forControlEvents:UIControlEventTouchUpInside];
                    messagedocumentview.viewbutton.tag=indexPath.row*888888+i;
                    
                }
                myCell.button1.hidden=messagerecordobject.photoarray.count>1 || selectMode;
                myCell.button1.tag=indexPath.row;
                [myCell.button1 addTarget:self action:@selector(sharephotobuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            
            
        }

        if ([messagerecordobject.type isEqualToString:@"received"]) {
            //if (((UserPrivilege *)[MyClass returnuserprivilegewithcenterkey:messagecontactrecord.centerkey]).istaffviewcentermessage) {
                myCell.label1.hidden=NO;
            myCell.button3.tag=indexPath.row;
            [myCell.button3 addTarget:self action:@selector(showinstantmessageactions:) forControlEvents:UIControlEventTouchUpInside];
            myCell.button3.hidden=selectMode;
                if ([messagerecordobject.recipient isEqualToString:globalvariables.username]) {
                    myCell.label1.text=[MyClass returntitlewithtitle:@"You"];
                }else if ([messagerecordobject.recipient isEqualToString:@"center"]) {
                    myCell.label1.text=[MyClass returncentershortnamewithcenterkey:globalvariables.centerrecord.centerkey];
                }else if ([messagerecordobject.recipient rangeOfString:@"@"].location !=NSNotFound){
                    myCell.label1.text=[MyClass returnstaffnamewithusername:messagerecordobject.recipient firstorfullname:@"full"];
                }else{
                    myCell.label1.text=[MyClass returnStudentnameWithStudentkey:messagerecordobject.recipient option:@"full"];
                }
                myCell.label1.text=[NSString stringWithFormat:@"@%@",myCell.label1.text];

            
            if (firstunreadrow==indexPath.row) {
                myCell.view1.hidden=NO;
                if(unreadcount==1){
                    myCell.label5.text=[MyClass returnreplacedtitlewithtitle:@"%@1 UNREAD MESSAGE" replacementarray:@[[@(unreadcount) stringValue]]];
                }else if (unreadcount>1){
                    myCell.label5.text=[MyClass returnreplacedtitlewithtitle:@"%@1 UNREAD MESSAGES" replacementarray:@[[@(unreadcount) stringValue]]];
                }
            }else{
                myCell.view1.hidden=YES;
            }
            
            //if (scrolltoclosekeyboard) {
                if ([messagerecordobject.readtime isEqualToString:@""] && ![readmessagearray containsObject:messagerecordobject.inboxmessagekey]) {
                    [readmessagearray addObject:messagerecordobject.inboxmessagekey];
                    messagerecordobject.readtime=@"read";
                }
            //}

        }else{

                myCell.label1.hidden=NO;
            if ([messagerecordobject.sender isEqualToString:globalvariables.username]){
                myCell.label1.text=[MyClass returntitlewithtitle:@"You"];
            }else if ([messagerecordobject.sender isEqualToString:@"center"]) {
                    myCell.label1.text=[MyClass returncentershortnamewithcenterkey:globalvariables.centerrecord.centerkey];
                }else if ([messagerecordobject.sender rangeOfString:@"@"].location !=NSNotFound){
                    myCell.label1.text=[MyClass returnstaffnamewithusername:messagerecordobject.sender firstorfullname:@"full"];
                }else{
                    myCell.label1.text=[MyClass returnStudentnameWithStudentkey:messagerecordobject.sender option:@"full"];
                }
                myCell.label5.textAlignment=NSTextAlignmentRight;

            myCell.label5.text=[MyClass returnMessageChannelNameWithChannelCode: messagerecordobject.channel];
            myCell.button3.tag=indexPath.row;
            [myCell.button3 addTarget:self action:@selector(showinstantmessageactions:) forControlEvents:UIControlEventTouchUpInside];
            myCell.button3.hidden=selectMode;
            //myCell.button2.tag=indexPath.row;
            myCell.view1.hidden=YES;
            if ([messagerecordobject.channel isEqualToString:@"E"] || [messagerecordobject.channel isEqualToString:@"S"]) {
                [myCell.button2 setImage:[UIImage imageNamed:@"questionmark_gray.png"] forState:UIControlStateNormal];
            }else{
                if ([messagerecordobject.readstatus isEqualToString:@"SOME"]){
                    [myCell.button2 setImage:[UIImage imageNamed:@"graybluecheck_icon.png"] forState:UIControlStateNormal];
                }else if ([messagerecordobject.readstatus isEqualToString:@"ALL"]){
                    [myCell.button2 setImage:[UIImage imageNamed:@"doublebluecheck_icon.png"] forState:UIControlStateNormal];
                }else if ([messagerecordobject.readstatus isEqualToString:@"NONE"]){
                    [myCell.button2 setImage:[UIImage imageNamed:@"doublegraycheck_icon.png"] forState:UIControlStateNormal];
                }else if ([messagerecordobject.readstatus isEqualToString:@"SENDING"]){
                    [myCell.button2 setImage:[UIImage imageNamed:@"messageloading_icon.png"] forState:UIControlStateNormal];
                }
            }
        }
        
        //for reply to message view
        myCell.view4.hidden=[messagerecordobject.replytomessagekey integerValue]==0;
        if([messagerecordobject.replytomessagekey integerValue]>0){
            InboxMessageRecord *obj;
            if([messagerecordobject.replytomessagekey isEqualToString:@"999"]){
                obj=replyToMessageRecord;
            }else{
                obj=[replyToMessageDict valueForKey:messagerecordobject.replytomessagekey];
            }
            
            if(obj && [obj isKindOfClass:[InboxMessageRecord class]]){
                if(obj.photoarray.count==0){
                    myCell.imageview3.hidden=YES;
                }else if (obj.photoarray.count==1 && [((MessagePhotoRecord *)[obj.photoarray firstObject]).filetype isEqualToString:@"audio"]){
                    myCell.imageview3.hidden=YES;
                }else{
                    myCell.imageview3.hidden=NO;
                    MessagePhotoRecord *photorecord = [obj.photoarray firstObject];
                    [MyClass downloadImageWithImageview:myCell.imageview3 gender:nil type:@"message" typekey:photorecord.thumbnailurl image:@"Yes" async:YES];
                }

                if([obj.sender isEqualToString:globalvariables.username]){
                    myCell.label6.text=[MyClass returntitlewithtitle:@"You"];
                }else if ([obj.sender isEqualToString:@"center"]) {
                    myCell.label6.text=[MyClass returncentershortnamewithcenterkey:globalvariables.centerrecord.centerkey];
                }else if ([obj.sender rangeOfString:@"@"].location !=NSNotFound){
                    myCell.label6.text=[MyClass returnstaffnamewithusername:obj.sender firstorfullname:@"full"];
                }else{
                    myCell.label6.text=[MyClass returnStudentnameWithStudentkey:obj.sender option:@"full"];
                }

                myCell.label7.text=[self returnReplyToMessageTitleWithMessageRecord:obj];
                
                
                [myCell.button5 addTarget:self action:@selector(replytomessagebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                myCell.button5.tag=indexPath.row;
                
                myCell.view5.backgroundColor=[obj.type isEqualToString:@"sent"]?[UIColor colorWithRed:158.0/255.0 green:192.0/255.0 blue:232.0/255.0 alpha:0.6]:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
                myCell.view6.backgroundColor=[obj.type isEqualToString:@"sent"]?[UIColor colorWithRed:38.0/255.0 green:154.0/255.0 blue:251.0/255.0 alpha:1.0]:[UIColor lightGrayColor];
                myCell.label6.textColor=[obj.type isEqualToString:@"sent"]?[UIColor colorWithRed:0 green:122.0/255.0 blue:255.0/255.0 alpha:1.0]:[UIColor orangeColor];
                
            }else{
                myCell.view4.hidden=YES;
            }
        }
           
        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
        myCell.contentView.transform=CGAffineTransformMakeScale(1, -1);
        return myCell;
        
    }else if (tableView == SalesTable) {
        
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"salescell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        SalesRecord * salesobject=[[SalesRecord alloc]init];
        salesobject = [filteredSalesRecordArray objectAtIndex:indexPath.row];
        
        
        // Configure the cell...
        cell.button2.hidden=YES;
        if ([salesobject.status isEqualToString:@"Voided"]) {
            [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tiffany_background.png"]]];
            cell.label11.text=@"V";
        }else if ([salesobject.total floatValue] !=[salesobject.paid floatValue]) {
            cell.label11.text=@"$";
            if ([salesobject.paid floatValue]<=0) {
                [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_background.png"]]];
                [cell.button2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_background.png"]]];
            }else if ([salesobject.paid floatValue]<[salesobject.total floatValue]){
                [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"orange_background.png"]]];
                [cell.button2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"orange_background.png"]]];
            }else{
                [cell.view1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_background.png"]]];
                [cell.button2 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"blue_background.png"]]];
            }
            
            [cell.button2 setTitle:[currencyformatter stringFromNumber:[NSNumber numberWithFloat:[salesobject.total floatValue]-[salesobject.paid floatValue]]] forState:UIControlStateNormal];
            cell.button2.hidden=NO;
            cell.button2.tag=indexPath.row;
            [cell.button2 addTarget:self action:@selector(salesoutstandingbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [cell.view1 setBackgroundColor:nil];
            cell.label11.text=@"";
        }
        
        [MyClass downloadImageWithImageview:cell.imageview3 gender:nil type:@"product" typekey:salesobject.productcode image:@"Yes" async:YES];
        [cell.button1 addTarget:self action:@selector(productimagebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.button1.tag=indexPath.row;
        cell.label1.text=[MyClass returndateformatwithdate:salesobject.orderdate];
        

        cell.label2.text=[MyClass returnproductnamewithproductcode:salesobject.productcode centerkey:globalvariables.centerrecord.centerkey];

        
        cell.label3.text=[NSString stringWithFormat:@"$%g",[salesobject.total floatValue]];
        cell.label6.text=salesobject.remarks;
        cell.label4.text=salesobject.invoiceremarks;
        cell.label5.text=salesobject.quantity;
        cell.label7.text=salesobject.givenout;
        cell.label7.hidden=!showGivenOut;
        if([salesobject.givenout intValue]<[salesobject.quantity intValue]){
            cell.label7.textColor=[UIColor redColor];
        }else{
            cell.label7.textColor=[UIColor darkGrayColor];
        }
        
        if (isSelectCombinePayment) {
            cell.imageview2.layer.borderColor=[UIColor lightGrayColor].CGColor;
            cell.imageview2.layer.borderWidth=0.5;
            cell.view2.hidden=NO;
            if ([globalvariables.documentfolder.salespaymentarray containsObject:salesobject.saleskey]) {
                if ([globalvariables.documentfolder.salesinvoicearray containsObject:salesobject.saleskey]) {
                    if (![[MyClass returnLastPaymentKeyWithPaymentRecords:salesobject.paymentrecords] isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:salesobject.saleskey]) {
                        [cell.imageview2 setImage:[UIImage imageNamed:@"redgreenorange_icon.png"]];
                    }else{
                        [cell.imageview2 setImage:[UIImage imageNamed:@"greenred_icon.png"]];
                    }
                }else{
                    if (![[MyClass returnLastPaymentKeyWithPaymentRecords:salesobject.paymentrecords] isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:salesobject.saleskey]) {
                        [cell.imageview2 setImage:[UIImage imageNamed:@"orangered_icon.png"]];
                    }else{
                        [cell.imageview2 setImage:[UIImage imageNamed:@"red_icon.png"]];
                    }
                }
            }else{
                if ([globalvariables.documentfolder.salesinvoicearray containsObject:salesobject.saleskey]) {
                    if (![[MyClass returnLastPaymentKeyWithPaymentRecords:salesobject.paymentrecords] isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:salesobject.saleskey]) {
                        [cell.imageview2 setImage:[UIImage imageNamed:@"greenorange_icon.png"]];
                    }else{
                        [cell.imageview2 setImage:[UIImage imageNamed:@"green_icon.png"]];
                    }
                }else{
                    if (![[MyClass returnLastPaymentKeyWithPaymentRecords:salesobject.paymentrecords] isEqualToString:@""] && [globalvariables.documentfolder.salesreceiptarray containsObject:salesobject.saleskey]) {
                        [cell.imageview2 setImage:[UIImage imageNamed:@"orange_icon.png"]];
                    }else{
                        [cell.imageview2 setImage:nil];
                    }
                }
            }
        }else{
            cell.view2.hidden=YES;
        }

        cell.imageview1.hidden=![salesobject.autorenew isEqualToString:@"Yes"] || [((ProductRecord *)[MyClass returnProductInformationWithCode:salesobject.productcode centerkey:globalvariables.centerrecord.centerkey]).autorenew isEqualToString:@""];
        
        
        if (indexPath.row % 2!=0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }
        
        if([salesobject.saleskey isEqualToString:selectedSaleskey]){
            cell.backgroundColor=[UIColor colorWithRed:241.0/255.0 green:178.0/255.0 blue:103.0/255.0 alpha:1.0];
        }
        
        cell.button4.tag=indexPath.row;
        [cell.button4 addTarget:self action:@selector(salesinvoicebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.button5.tag=indexPath.row;
        [cell.button5 addTarget:self action:@selector(salesreceiptbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        cell.button5.layer.opacity=salesobject.paymentrecords.count==0?0.3:1.0;
        cell.button5.userInteractionEnabled=salesobject.paymentrecords.count>0;
        
        return cell;
        
        
    }else if (tableView == couponTable) {
        
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"salescell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CouponRecord * obj=[filteredDetailsViewCouponArray objectAtIndex:indexPath.row];
        MarketingRecord *mkt=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
        
        // Configure the cell...
        cell.label1.text=[globalvariables.language isEqualToString:@"English"]?mkt.description:mkt.description_chinese;
        

        cell.label2.text=[MyClass returntitlewithtitle:mkt.subcategory];
        cell.label3.text=[MyClass convertDateFormatWithDate:obj.issuedate FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
        
        cell.label4.text=[MyClass convertDateFormatWithDate:obj.effectivefrom FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
        cell.label5.text=[obj.effectiveto isEqualToString:@""]?[MyClass returntitlewithtitle:@"Never expire"]:[MyClass convertDateFormatWithDate:obj.effectiveto FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
        cell.label6.text=[MyClass convertDateFormatWithDate:obj.dateused FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
        cell.label7.text=obj.remarks;
        cell.label8.text=obj.couponkey;
        

        
        
        
        if (indexPath.row % 2!=0) {
            cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        }else{
            cell.backgroundColor=[UIColor whiteColor];
        }

        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
        
        
    }else if (tableView == CallLogTable) {
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"calllogcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CallLogRecord * calllogobject=[[CallLogRecord alloc]init];
        calllogobject = [filteredCallLogRecordArray objectAtIndex:indexPath.row];
        
        /*
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            CallLogCellView=[[UIView alloc]init];
            CallLogCellView.backgroundColor=[UIColor systemGroupedBackgroundColor];
            CallLogCellView.layer.cornerRadius=10;
            CallLogCellView.layer.masksToBounds=YES;
            CallLogCellView.tag=673;
            [cell.contentView addSubview:CallLogCellView];
            
            //add textfield
            CallLogCallDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, 290, 38)];
            CallLogCallDateLabel.font=[UIFont systemFontOfSize:12];
            CallLogCallDateLabel.textColor=[UIColor darkGrayColor];
            CallLogCallDateLabel.tag=670;
            [cell.contentView addSubview:CallLogCallDateLabel];
            
            CallLogCalledByLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, selfViewWidth-84, 38)];
            CallLogCalledByLabel.font=[UIFont systemFontOfSize:12];
            CallLogCalledByLabel.textColor=[UIColor darkGrayColor];
            CallLogCalledByLabel.textAlignment=NSTextAlignmentRight;
            CallLogCalledByLabel.tag=671;
            [cell.contentView addSubview:CallLogCalledByLabel];
            
            CallLogDetailsLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 35, selfViewWidth-84, 38)];
            CallLogDetailsLabel.font=[UIFont systemFontOfSize:13];
            CallLogDetailsLabel.textColor=[UIColor blackColor];
            CallLogDetailsLabel.textAlignment=NSTextAlignmentLeft;
            CallLogDetailsLabel.numberOfLines=0;
            CallLogDetailsLabel.tag=672;
            [cell.contentView addSubview:CallLogDetailsLabel];
        }else{
            CallLogCallDateLabel=(UILabel *)[cell.contentView viewWithTag:670];
            CallLogCalledByLabel=(UILabel *)[cell.contentView viewWithTag:671];
            CallLogDetailsLabel=(UILabel *)[cell.contentView viewWithTag:672];
            CallLogCellView=(UIView *)[cell.contentView viewWithTag:673];
        }*/
        
        // Configure the cell...
        cell.label1.text=[MyClass returndateformatwithdate:calllogobject.calledon];
        cell.label2.text=calllogobject.calledbyfullname;//[MyClass returnstaffnamewithusername:calllogobject.calledby firstorfullname:@"full"];
        cell.label3.text=calllogobject.details;
        

        
        return cell;
        
        
    }else if (tableView==ProductCategorySelectionTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 200, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentCenter;
        GeneralLabel.text=[ProductCategoryArray objectAtIndex:indexPath.row];
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 37, 160, 1)];
        GeneralLabel.backgroundColor=[UIColor colorWithRed:24.0/255.0 green:24.0/255.0  blue:24.0/255.0  alpha:0.1];
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;

    }else if (tableView==DTSubjectSelectionTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        
            DT_subjectname = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 230, 21)];
            DT_subjectname.font=[UIFont systemFontOfSize:15];
            DT_subjectname.textColor=[UIColor darkGrayColor];
            DT_subjectname.textAlignment=NSTextAlignmentLeft;
            DT_subjectname.tag=701;
            DT_subjectname.minimumScaleFactor=0.7;
            DT_subjectname.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:DT_subjectname];
            
            
            DT_subjectcode = [[UILabel alloc]initWithFrame:CGRectMake(250, 7, 40, 21)];
            DT_subjectcode.font=[UIFont systemFontOfSize:14];
            DT_subjectcode.minimumScaleFactor=0.7;
            DT_subjectcode.adjustsFontSizeToFitWidth=YES;
            DT_subjectcode.textColor=[UIColor darkGrayColor];
            DT_subjectcode.textAlignment=NSTextAlignmentRight;
            DT_subjectcode.tag=702;
            [cell.contentView addSubview:DT_subjectcode];
            
            DT_separator = [[UILabel alloc]initWithFrame:CGRectMake(20, 37, 260, 1)];
            DT_separator.backgroundColor=[UIColor colorWithRed:24.0/255.0 green:24.0/255.0  blue:24.0/255.0  alpha:0.1];
            DT_separator.tag=703;
            [cell.contentView addSubview:DT_separator];
            
        }else{
            DT_subjectname=(UILabel *)[cell.contentView viewWithTag:701];
            DT_subjectcode=(UILabel *)[cell.contentView viewWithTag:702];
            DT_separator=(UILabel *)[cell.contentView viewWithTag:703];
        }
        
        if (indexPath.row>0) {
            DT_subjectcode.text=[DTSubjectArray objectAtIndex:indexPath.row];
        }else{
            DT_subjectcode.text=@"";
        }
        
        DT_subjectname.text=indexPath.row==0?[MyClass returntitlewithtitle:[DTSubjectArray objectAtIndex:0]]:[MyClass returnsubjectnamewithsubject_shortname:[DTSubjectArray objectAtIndex:indexPath.row] centerkey:globalvariables.centerrecord.centerkey];
        
        return cell;
        
    }else if (tableView==CallLogCalledBySelectionTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 200, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentCenter;
        //GeneralLabel.text=[MyClass returnfullnamewithusername:[CallLogCalledByArray objectAtIndex:indexPath.row] userlistarray:userListArray];
        GeneralLabel.text=[MyClass returnstaffnamewithusername:[CallLogCalledByArray objectAtIndex:indexPath.row] firstorfullname:@"full"];
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 37, 160, 1)];
        GeneralLabel.backgroundColor=[UIColor colorWithRed:24.0/255.0 green:24.0/255.0  blue:24.0/255.0  alpha:0.1];
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;
        
    }else if (tableView==DTTypeSelectionTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 200, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentCenter;
        GeneralLabel.text=[MyClass returntitlewithtitle:[DTTypeArray objectAtIndex:indexPath.row]];
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 37, 200-40, 1)];
        GeneralLabel.backgroundColor=[UIColor colorWithRed:24.0/255.0 green:24.0/255.0  blue:24.0/255.0  alpha:0.1];
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;
        
    }else if (tableView==DaySelectionTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, DaySelectionTable.frame.size.width, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentCenter;
        GeneralLabel.text=[MyClass returntitlewithtitle:[dayarray objectAtIndex:indexPath.row]];
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        

        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 37, DaySelectionTable.frame.size.width-40, 1)];
        GeneralLabel.backgroundColor=[UIColor colorWithRed:24.0/255.0 green:24.0/255.0  blue:24.0/255.0  alpha:0.1];
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;
        
    }else if (tableView==TypeSelectionTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, TypeSelectionTable.frame.size.width, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentCenter;
        GeneralLabel.text=[MyClass returntitlewithtitle:[typearray objectAtIndex:indexPath.row]];
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
//        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 37, TypeSelectionTable.frame.size.width, 1)];
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 37, TypeSelectionTable.frame.size.width-40, 1)];
        GeneralLabel.backgroundColor=[UIColor colorWithRed:24.0/255.0 green:24.0/255.0  blue:24.0/255.0  alpha:0.1];
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;
        
    }else if (tableView==SiblingTable){

        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
            siblingnamelabel = [[UILabel alloc]initWithFrame:CGRectMake(42, 2, 112, 21)];
            siblingnamelabel.font=[UIFont systemFontOfSize:12];
            siblingnamelabel.textColor=[UIColor blackColor];
            siblingnamelabel.tag=701;
            siblingnamelabel.numberOfLines=0;
            siblingnamelabel.minimumScaleFactor=0.7;
            siblingnamelabel.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:siblingnamelabel];
            
            
            siblingrelationshiplabel = [[UILabel alloc]initWithFrame:CGRectMake(42, 10, 112, 12)];
            siblingrelationshiplabel.font=[UIFont systemFontOfSize:10];
            siblingrelationshiplabel.adjustsFontSizeToFitWidth=YES;
            siblingrelationshiplabel.textColor=[UIColor grayColor];
            siblingrelationshiplabel.tag=702;
            [cell.contentView addSubview:siblingrelationshiplabel];
            
            siblingimageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 38, 38)];
            siblingimageview.layer.cornerRadius=19;
            siblingimageview.backgroundColor=[UIColor lightGrayColor];
            siblingimageview.tag=703;
            siblingimageview.contentMode=UIViewContentModeScaleAspectFill;
            siblingimageview.layer.masksToBounds=YES;
            [cell.contentView addSubview:siblingimageview];
            
        }else{
            siblingnamelabel=(UILabel *)[cell.contentView viewWithTag:701];
            siblingrelationshiplabel=(UILabel *)[cell.contentView viewWithTag:702];
            siblingimageview=(UIImageView *)[cell.contentView viewWithTag:703];
        }
        
        siblingobject=[DetailsViewStudent.siblingarray objectAtIndex:indexPath.row];
        
        siblingnamelabel.text=[MyClass returnStudentnameWithStudentkey:siblingobject.studentkey option:@"fullbutid"];//siblingobject.studentname;
        siblingrelationshiplabel.text=[MyClass returntitlewithtitle:siblingobject.relationship];
        
        

        siblingnamelabel.frame=CGRectMake(42, 3, 112, 40);
        [siblingnamelabel sizeToFit];
        
        if (siblingnamelabel.frame.size.height>38-12-2) {
            siblingnamelabel.frame=CGRectMake(42, 3, siblingnamelabel.frame.size.width, 38-12-2);
        }else{
            siblingnamelabel.frame=CGRectMake(42, (42-siblingnamelabel.frame.size.height-2-12)/2, siblingnamelabel.frame.size.width, siblingnamelabel.frame.size.height);
        }
        
        siblingrelationshiplabel.frame=CGRectMake(42, siblingnamelabel.frame.origin.y+siblingnamelabel.frame.size.height+2, 112, 12);
        
        
        studentobject=[MyClass returnstudentwithstudentkey:siblingobject.studentkey];
        
        [MyClass downloadImageWithImageview:siblingimageview gender:studentobject.gender type:@"student" typekey:siblingobject.studentkey image:studentobject.image async:YES];


        return cell;

    
    }else if (tableView==ViewHistoryTable){
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //add switch, label and button
        
        UIImageView *dueimage;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            
            viewhistorynamelabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 2, 150, 21)];
            viewhistorynamelabel.font=[UIFont systemFontOfSize:12];
            viewhistorynamelabel.textColor=[UIColor blackColor];
            viewhistorynamelabel.tag=701;
            viewhistorynamelabel.numberOfLines=0;
            viewhistorynamelabel.minimumScaleFactor=0.7;
            viewhistorynamelabel.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:viewhistorynamelabel];
            
            
            viewhistoryidlabel = [[UILabel alloc]initWithFrame:CGRectMake(52, 10, 150, 12)];
            viewhistoryidlabel.font=[UIFont systemFontOfSize:10];
            viewhistoryidlabel.adjustsFontSizeToFitWidth=YES;
            viewhistoryidlabel.textColor=[UIColor darkGrayColor];
            viewhistoryidlabel.tag=702;
            [cell.contentView addSubview:viewhistoryidlabel];

            dueimage=[[UIImageView alloc]initWithFrame:CGRectMake(10, 3, 38, 38)];
            dueimage.layer.cornerRadius=20.5;
            dueimage.tag=704;
            dueimage.contentMode=UIViewContentModeScaleAspectFill;
            dueimage.layer.masksToBounds=YES;
            [cell.contentView addSubview:dueimage];
            
            viewhistoryimageview=[[UIImageView alloc]initWithFrame:CGRectMake(11.5, 4.5, 35, 35)];
            viewhistoryimageview.layer.cornerRadius=19;
            viewhistoryimageview.backgroundColor=[UIColor lightGrayColor];
            viewhistoryimageview.tag=703;
            viewhistoryimageview.contentMode=UIViewContentModeScaleAspectFill;
            viewhistoryimageview.layer.masksToBounds=YES;
            [cell.contentView addSubview:viewhistoryimageview];
            
        }else{
            viewhistorynamelabel=(UILabel *)[cell.contentView viewWithTag:701];
            viewhistoryidlabel=(UILabel *)[cell.contentView viewWithTag:702];
            viewhistoryimageview=(UIImageView *)[cell.contentView viewWithTag:703];
            dueimage=(UIImageView *)[cell.contentView viewWithTag:704];
        }
        
        viewhistoryobject=[viewhistoryarray objectAtIndex:indexPath.row];
        studentobject=[MyClass returnstudentwithstudentkey:viewhistoryobject.typekey];
        
        viewhistorynamelabel.text=[MyClass returnStudentnameWithStudentkey:viewhistoryobject.typekey option:@"fullbutid"];//viewhistoryobject.name;
        viewhistoryidlabel.text=studentobject.studentid;
        
        if ([studentobject.studentid isEqualToString:@""]) {
            viewhistorynamelabel.frame=CGRectMake(52,0,150,44);
        }else{
            viewhistorynamelabel.frame=CGRectMake(52, 3, 150, 40);
            [viewhistorynamelabel sizeToFit];
            
            if (viewhistorynamelabel.frame.size.height>38-12-2) {
                viewhistorynamelabel.frame=CGRectMake(52, 3, viewhistorynamelabel.frame.size.width, 38-12-2);
            }else{
                viewhistorynamelabel.frame=CGRectMake(52, (42-viewhistorynamelabel.frame.size.height-2-12)/2, viewhistorynamelabel.frame.size.width, viewhistorynamelabel.frame.size.height);
            }
            
            viewhistoryidlabel.frame=CGRectMake(52, viewhistorynamelabel.frame.origin.y+viewhistorynamelabel.frame.size.height+2, 150, 12);
        }
        
        [MyClass downloadImageWithImageview:viewhistoryimageview gender:studentobject.gender type:@"student" typekey:viewhistoryobject.typekey image:studentobject.image async:YES];
        
        if([studentobject.due isEqualToString:@"B"]){
            [dueimage setImage:[UIImage imageNamed:@"redpurple.png"]];
        }else if([studentobject.due isEqualToString:@"C"]){
            [dueimage setImage:[UIImage imageNamed:@"red_background.png"]];
        }else if([studentobject.due isEqualToString:@"S"]){
            [dueimage setImage:[UIImage imageNamed:@"purple_background.png"]];
        }else{
            [dueimage setImage:nil];
        }
        
        cell.backgroundColor=[UIColor clearColor];
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
        bgView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
        cell.selectedBackgroundView = bgView;
        

        
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
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 7, ClassSelectionTable.frame.size.width-20-50-20, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentLeft;
        GeneralLabel.text=indexPath.row==0?[MyClass returntitlewithtitle:[SubjectArray objectAtIndex:0]]:[MyClass returnsubjectnamewithsubject_shortname:[SubjectArray objectAtIndex:indexPath.row] centerkey:globalvariables.centerrecord.centerkey];
        GeneralLabel.tag=301;
        GeneralLabel.minimumScaleFactor=0.7;
        GeneralLabel.adjustsFontSizeToFitWidth=YES;
        [cell.contentView addSubview:GeneralLabel];

        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(ClassSelectionTable.frame.size.width-60, 7, 40, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:14];
        GeneralLabel.minimumScaleFactor=0.7;
        GeneralLabel.adjustsFontSizeToFitWidth=YES;
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentRight;
        if (indexPath.row>0) {
            GeneralLabel.text=[SubjectArray objectAtIndex:indexPath.row];
        }else{
            GeneralLabel.text=@"";
        }
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 37, ClassSelectionTable.frame.size.width-40, 1)];
        GeneralLabel.backgroundColor=[UIColor colorWithRed:24.0/255.0 green:24.0/255.0 blue:24.0/255.0 alpha:0.1];
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;
    }
    
}

-(void) replytomessagebuttonpressed:(UIButton *)sender
{
    NSInteger index=0;
    InboxMessageRecord *obj=[filteredMessageArray objectAtIndex:sender.tag];
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:DetailsViewMessageTable];
    NSIndexPath *indexPath =[DetailsViewMessageTable indexPathForRowAtPoint:point];
    for(NSInteger i=indexPath.row;i<filteredMessageArray.count;i++){
        InboxMessageRecord *record=[filteredMessageArray objectAtIndex:i];
        if([record.outboxmessagekey isEqualToString:obj.replytomessagekey]){
            index=i;
            break;
        }
    }
    [DetailsViewMessageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

-(BOOL) showReplyCellViewWithMessageRecord:(InboxMessageRecord *)messagerecord
{
    BOOL result=FALSE;
    if([messagerecord.replytomessagekey integerValue]>0){
        InboxMessageRecord *obj;
        if([messagerecord.replytomessagekey isEqualToString:@"999"]){
            obj=replyToMessageRecord;
        }else{
            obj=[replyToMessageDict valueForKey:messagerecord.replytomessagekey];
        }
        
        if(obj && [obj isKindOfClass:[InboxMessageRecord class]]){
            result=TRUE;
        }
    }
    return result;
}

-(NSString *) returnReplyToMessageTitleWithMessageRecord:(InboxMessageRecord *)record
{
    NSString *title=[globalvariables.language isEqualToString:@"English"]?record.messageenglish:record.messagechinese;
    if(record.photoarray.count>0){
        NSMutableArray *filetypes=[[NSMutableArray alloc]init];
        NSMutableArray *icons=[[NSMutableArray alloc]init];
        for (int i=0; i<record.photoarray.count; i++) {
            MessagePhotoRecord *obj=record.photoarray[i];
            if(![filetypes containsObject:[obj.filetype capitalizedString]]){
                [filetypes addObject:[obj.filetype capitalizedString]];
                if([[obj.filetype capitalizedString] isEqualToString:@"Image"]){
                    [icons addObject:@"📷"];
                }else if([[obj.filetype capitalizedString] isEqualToString:@"Video"]){
                    [icons addObject:@"📹"];
                }else if([[obj.filetype capitalizedString] isEqualToString:@"Audio"]){
                    [icons addObject:@"🎤"];
                }else if([[obj.filetype capitalizedString] isEqualToString:@"Pdf"]){
                    [icons addObject:@"📄"];
                }
            }
        }
        
        if([title isEqualToString:@""]){
            if(filetypes.count>1){
                title=[NSString stringWithFormat:@"%@ %@",[icons componentsJoinedByString:@""], [MyClass returntitlewithtitle:@"Multiple documents"]];
            }else{
                if([[filetypes firstObject] isEqualToString:@"Image"]){
                    title=[NSString stringWithFormat:@"%@ %@",[icons componentsJoinedByString:@""], [MyClass returntitlewithtitle:@"Photo"]];
                }else if([[filetypes firstObject] isEqualToString:@"Audio"]){
                    title=[NSString stringWithFormat:@"%@ %@",[icons componentsJoinedByString:@""], [MyClass returntitlewithtitle:@"Voice"]];
                }else if([[filetypes firstObject] isEqualToString:@"Pdf"]){
                    title=[NSString stringWithFormat:@"%@ %@",[icons componentsJoinedByString:@""], [MyClass returntitlewithtitle:@"PDF"]];
                }else if([[filetypes firstObject] isEqualToString:@"Video"]){
                    title=[NSString stringWithFormat:@"%@ %@",[icons componentsJoinedByString:@""], [MyClass returntitlewithtitle:@"Video"]];
                }
            }
        }else{
            title=[NSString stringWithFormat:@"%@ %@",[icons componentsJoinedByString:@""], title];
        }
    }

    return title;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==sortingtable){
        return 40;
    }else{
        return CGFLOAT_MIN;
    }
}

-(void) classinformationbuttonpressed:(UIButton *)sender
{
    ClassRecord *object=[filteredDetailsViewClassArray objectAtIndex:sender.tag];
    NSMutableArray *actionarray=[[NSMutableArray alloc]initWithObjects:@"Postpone",@"Delete",@"More", nil];
    
    
    if([object.startdate isEqualToString:@"TBD"] || [object.classtime isEqualToString:@"TBD"] || [object.status isEqualToString:@"Voided"] || object.hasextendedclass || (object.locked && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editlockedclass)){
        [actionarray removeObject:@"Postpone"];
    }
    
    if([object.status isEqualToString:@"Voided"] || object.hasextendedclass || (object.locked && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editlockedclass) || (object.enrollmentpaid && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editclassforpaidenrollment) || (object.expiredpromotion && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editclassforexpiredpromotion)){
        [actionarray removeObject:@"Delete"];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"classactions" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(180, 60*actionarray.count) View:self Button:sender ItemsArray:actionarray Title:nil MultipleSelection:NO];
    
}


-(void) class_morebuttonpressed:(NSInteger)index
{
    selectedClasskey=@"";
//    CGPoint point = [sender.superview convertPoint:CGPointZero toView:DetailsViewClassTable];
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:index inSection:0];
    DetailsViewClass=[filteredDetailsViewClassArray objectAtIndex:indexPath.row];
    [DetailsViewClassTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    
    [self startsidewindowanimationwithwidth:480];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ClassRemarksPopoverViewController *remarksuppopover = (ClassRemarksPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"ClassRemarksPopoverViewController"];
        remarksuppopover.delegate=self;
        remarksuppopover.presentingview=@"studentprofile";
        
        remarksuppopover.classScheduleObject=[[ClassScheduleRecord alloc]initClassScheduleRecordWithstudentkey:DetailsViewClass.studentkey andenrollmentkey:DetailsViewClass.enrollmentkey andclasskey:DetailsViewClass.classkey anddtkey:nil andclasstype:@"Class" andfirstname:nil andlastname:nil andothername:nil andgender:nil andparentcontact:nil andimage:nil andsubject:DetailsViewClass.subject andlevelmain:nil andlevelctm:nil andstartdate:DetailsViewClass.startdate andclassday:nil andclasstime:DetailsViewClass.classtime andinstructor:nil andclassroom:nil andattendance:DetailsViewClass.attendance andmakeupattendance:DetailsViewClass.makeupattendance andmakeupdate:DetailsViewClass.makeupdate andmakeuptime:DetailsViewClass.makeupdate andremarks:DetailsViewClass.remarks andallclassremarks:DetailsViewClass.allclassremarks andmakeupinstructor:nil andmakeupclassroom:nil andabsentmakeupreason:DetailsViewClass.absentmakeupreason andfirstclass:nil andnextclassalldaytime:nil andlastscheduledclassalldaytime:nil andremainingclassscheduled:nil andremainingclassTBDclass:nil andremainingclassTBDmakeup:nil andremainingclassscheduledall:nil andoutstandingpayment:nil andclassduration:nil type:nil instructorfullname:nil autorenew:nil schedulekey:nil outstandingextendtime:nil extendedminute:nil status:DetailsViewClass.status extensiontime:DetailsViewClass.extensiontime subjectfullname:nil studentid:nil parentnote:DetailsViewClass.parentnote studentdisplayname:nil assessmentformcount:0 leavenaturelistkey:0 makeupquotaavailable:NO realclassroom:nil realclasstime:nil lesson:nil sinstructor:nil makeupsinstructor:nil sinstructorfullname:nil locked:DetailsViewClass.locked enrollmentpaid:NO];
        
        //remarksuppopover.preferredContentSize=CGSizeMake(400, 380);
        
        if (![remarksuppopover retrievenextclassremarks]) {
            [MyClass showconnectionlostdialogbox];
            return;
        }
        
        remarksuppopover.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:remarksuppopover.view];
        [self addChildViewController:remarksuppopover];
        [remarksuppopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
    
    
}


-(BOOL) checkifclassdate:(NSString *)value
{
    
    [df setDateFormat:@"dd-MMM-yyyy"];
    NSDate *date=[df dateFromString:value];
    if (date) {
        return TRUE;
    }else{
        return FALSE;
    }
}

-(void) loadscactiveoption
{
    for (int i=0; i<activedraftarray_enrollment.count; i++) {
        [scactiveoption_enrollment setTitle:[MyClass returntitlewithtitle:[MyClass returntitlewithtitle:[activedraftarray_enrollment objectAtIndex:i]]] forSegmentAtIndex:i];
    }

    for (int i=0; i<activedraftarray_class.count; i++) {
        [scactiveoption_class setTitle:[MyClass returntitlewithtitle:[MyClass returntitlewithtitle:[activedraftarray_class objectAtIndex:i]]] forSegmentAtIndex:i];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==DetailsViewEnrollmentTable){
        
        [DetailsViewClassTable addGestureRecognizer:panGesture];
        [DetailsViewDTTable removeGestureRecognizer:panGesture];
        
        [self highlighttableoptionbuttonwithbuttontag:2];
        DetailsViewEnrollment=[filteredDetailsViewEnrollmentArray objectAtIndex:indexPath.row];
        
        ViewStudent.hidden=YES;
        EnrollmentRecordView.hidden=YES;
        ClassRecordView.hidden=NO;
        EnrollmentClassMenuView.hidden=NO;
        [self createClassViewNavigationButton];
        headertitlename.text=[NSString stringWithFormat:@"%@ (%@ %@ %@)",[MyClass returntitlewithtitle:@"Class Information - Enrollment record"],[MyClass returndateformatwithdate:DetailsViewEnrollment.startdate ],[MyClass returntitlewithtitle:@"studentdetails_to"],[MyClass returndateformatwithdate:DetailsViewEnrollment.enddate]];
        
        
        TypeSelectionButton.hidden=NO;
        typeselectionarrow.hidden=NO;
        //scmakeupabsent.enabled=YES;
        //scdayoption.frame=CGRectMake(203, 2, 279, 29);
//        DaySelectionButton.frame=CGRectMake(selfViewWidth-501, 2, 129, 29);
//        scactiveoption_enrollment.frame=CGRectMake(selfViewWidth-204, 2, 187, 29);
//        scactiveoption_class.frame=scactiveoption_enrollment.frame;
        scactiveoption_class.hidden=NO;
        scactiveoption_enrollment.hidden=YES;
        [self drawpointerwithoption:@"closed" imageview:dayselectionarrow];
        
        /*
        if (scdayoption.numberOfSegments==9) {
            [scdayoption removeSegmentAtIndex:8 animated:NO];
        }*/
        
        
        
        classviewmode=@"selectedEnrollment";
        
        //scdayoption.selectedSegmentIndex=0;
        dayselected=@"All";
        
        [self retrieveClassWithEnrollmentkey:DetailsViewEnrollment.enrollmentkey];
        lastviewindex=2;
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
    
    [self stopAudioPlaying];
    if (tableView == DetailsViewDTTable){
        if (!attendanceringview) {
            //popup class view record
            
            
            [self startsidewindowanimationwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                DetailsViewDTObject=[filteredDetailsViewDTArray objectAtIndex:indexPath.row];
                //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                DTAddEditViewController *dtpopover = (DTAddEditViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"DTAddEditViewController"];
                dtpopover.DTAddEditViewDTkey=DetailsViewDTObject.DTkey;
                dtpopover.PopoverMode=@"PopoverDTFromDetailsView";
                dtpopover.DTTableMode=@"View";
                dtpopover.CallingSource=@"student";
                dtpopover.CallingKey=DetailsViewStudent.studentkey;
                dtpopover.delegate=self;
                
                dtpopover.subjectArray=[MyClass retrievesubjectinformationwithstatus:@"Active" category:@"All" flushcachedata:YES];
                if (!dtpopover.subjectArray) {
                    return;
                }
                
                dtpopover.view.frame=self->mainWindow.bounds;
                [self->sidewindowview addSubview:dtpopover.view];
                [self addChildViewController:dtpopover];
                [dtpopover didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });
            

        }
        

        
    }else if (tableView == DetailsViewClassTable){
        if (!attendanceringview) {
            //popup class view record
            
            

            [self startsidewindowanimationwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                selectedClasskey=@"";
                DetailsViewClass=[filteredDetailsViewClassArray objectAtIndex:indexPath.row];
                //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                ClassPopoverViewController *classpopover = (ClassPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"ClassPopoverViewController"];
                classpopover.delegate=self;
                classpopover.PopoverClass=DetailsViewClass;
                classpopover.ClassTableMode=@"View";
                
                ////classpopover.ClassRecordArray=[self retrieveClassWithEnrollmentkey:DetailsViewClass.enrollmentkey];
                
                if (classpopover.ClassRecordArray) {

                }
                
                classpopover.view.frame=self->mainWindow.bounds;
                [self->sidewindowview addSubview:classpopover.view];
                [self addChildViewController:classpopover];
                [classpopover didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });

        }
        
        

    }else if (tableView==DetailsViewEnrollmentTable){
        DetailsViewEnrollment=[filteredDetailsViewEnrollmentArray objectAtIndex:indexPath.row];
        
        if (isSelectCombinePayment) {
            
            addedtofolder=FALSE;
            
            
            if ([globalvariables.documentfolder.classpaymentarray containsObject:DetailsViewEnrollment.enrollmentkey] || [globalvariables.documentfolder.classinvoicearray containsObject:DetailsViewEnrollment.enrollmentkey] || [globalvariables.documentfolder.classreceiptarray containsObject:DetailsViewEnrollment.enrollmentkey]) {
                //remove
                if ([globalvariables.documentfolder.classpaymentarray containsObject:DetailsViewEnrollment.enrollmentkey]) {
                    [globalvariables.documentfolder.classpaymentarray removeObject:DetailsViewEnrollment.enrollmentkey];
                }
                
                if ([globalvariables.documentfolder.classinvoicearray containsObject:DetailsViewEnrollment.enrollmentkey]) {
                    [globalvariables.documentfolder.classinvoicearray removeObject:DetailsViewEnrollment.enrollmentkey];
                }
                
                if ([globalvariables.documentfolder.classreceiptarray containsObject:DetailsViewEnrollment.enrollmentkey]) {
                    [globalvariables.documentfolder.classreceiptarray removeObject:DetailsViewEnrollment.enrollmentkey];
                }
                
                
                if ([globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:DetailsViewEnrollment.enrollmentkey]) {
                    [globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys removeObject:DetailsViewEnrollment.enrollmentkey];
                }
                
                if ([globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:DetailsViewEnrollment.enrollmentkey]) {
                    [globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys removeObject:DetailsViewEnrollment.enrollmentkey];
                }
                
                if ([globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:DetailsViewEnrollment.enrollmentkey]) {
                    [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys removeObject:DetailsViewEnrollment.enrollmentkey];
                }
                

            }else{
                //add
                
                if ([DetailsViewEnrollment.status isEqualToString:@"Voided"]){
                    UIAlertController *enrollalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"Voided item cannot be added"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

                    }];
                    
                    [enrollalert addAction:OKAction];
                    [self presentViewController:enrollalert animated:YES completion:nil];

                    return;
                }else{
                    addedtofolder=TRUE;
                    if(![globalvariables.documentfolder.classinvoicearray containsObject:DetailsViewEnrollment.enrollmentkey]){
                        [globalvariables.documentfolder.classinvoicearray addObject:DetailsViewEnrollment.enrollmentkey];
                    }
                    
                    if(![globalvariables.documentfolder.classpaymentarray containsObject:DetailsViewEnrollment.enrollmentkey]){
                        [globalvariables.documentfolder.classpaymentarray addObject:DetailsViewEnrollment.enrollmentkey];
                    }
                
                    if(![globalvariables.documentfolder.classreceiptarray containsObject:DetailsViewEnrollment.enrollmentkey] && DetailsViewEnrollment.paymentrecords.count>0){
                        [globalvariables.documentfolder.classreceiptarray addObject:DetailsViewEnrollment.enrollmentkey];
                    }
                    
                    if(![globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:DetailsViewEnrollment.enrollmentkey]){
                        [globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys addObject:DetailsViewEnrollment.enrollmentkey];
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:DetailsViewEnrollment.enrollmentkey] && [DetailsViewEnrollment.paid floatValue]!=[DetailsViewEnrollment.totalfee floatValue] && !DetailsViewEnrollment.locked) {
                        [globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys addObject:DetailsViewEnrollment.enrollmentkey];
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:DetailsViewEnrollment.enrollmentkey] && DetailsViewEnrollment.paymentrecords.count>0) {
                        [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys addObject:DetailsViewEnrollment.enrollmentkey];
                    }
                }
            }
//            NSLog(@"%@",globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys);
            
            
            if (addedtofolder) {
                [self showAddToDocumentFolderAnimationWithTableview:tableView IndexPath:indexPath];
            }
            
            [self refreshdocumentfoldercount];
            DataChanged=YES;
            
            
            [DetailsViewEnrollmentTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            


        }else{
            //popup enrollment view record

            [self startsidewindowanimationwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                EnrollmentPopoverViewController *enrollmentpopover = (EnrollmentPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"EnrollmentPopoverViewController"];
                enrollmentpopover.delegate=self;
                enrollmentpopover.PopoverEnrollment=DetailsViewEnrollment;
                enrollmentpopover.PopoverStudent=DetailsViewStudent;
                enrollmentpopover.EnrollmentTableMode=@"View";
                enrollmentpopover.leveldictionary=LevelDictionary;
                
                if (![self returnallclassremarkswithstudentkey:DetailsViewEnrollment.studentkey]) {
                    return;
                }
                
                enrollmentpopover.AllClassRemarksArray=allclassremarksArray;
                //[enrollmentwindowview addSubview:enrollmentpopover.view];
                
                
                enrollmentpopover.view.frame=self->mainWindow.bounds;
                [self->sidewindowview addSubview:enrollmentpopover.view];
                [self addChildViewController:enrollmentpopover];
                [enrollmentpopover didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });
            

        }
        


    
    }else if (tableView==SalesTable){
        //popup enrollment view record
        SalesRecord *salesobject=[filteredSalesRecordArray objectAtIndex:indexPath.row];
        
        if (isSelectCombinePayment) {
            BOOL addedtofolder=FALSE;

            
            if ([globalvariables.documentfolder.salespaymentarray containsObject:salesobject.saleskey] || [globalvariables.documentfolder.salesinvoicearray containsObject:salesobject.saleskey] || [globalvariables.documentfolder.salesreceiptarray containsObject:[MyClass returnLastPaymentKeyWithPaymentRecords:salesobject.paymentrecords]]) {
                //remove
                if ([globalvariables.documentfolder.salespaymentarray containsObject:salesobject.saleskey]) {
                    [globalvariables.documentfolder.salespaymentarray removeObject:salesobject.saleskey];
                }
                
                if ([globalvariables.documentfolder.salesinvoicearray containsObject:salesobject.saleskey]) {
                    [globalvariables.documentfolder.salesinvoicearray removeObject:salesobject.saleskey];
                }
                
                if ([globalvariables.documentfolder.salesreceiptarray containsObject:salesobject.saleskey]) {
                    [globalvariables.documentfolder.salesreceiptarray removeObject:salesobject.saleskey];
                }
                

                if ([globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:salesobject.saleskey]) {
                    [globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys removeObject:salesobject.saleskey];
                }
                
                if ([globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:salesobject.saleskey]) {
                    [globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys removeObject:salesobject.saleskey];
                }
                
                if ([globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:salesobject.saleskey]) {
                    [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys removeObject:salesobject.saleskey];
                }
                
//                if (![[MyClass returnLastPaymentKeyWithPaymentRecords:salesobject.paymentrecords] isEqualToString:@""]) {
//                    if ([globalvariables.documentfolder.defaultcheckedsalesreceiptpaymentkeys containsObject:[MyClass returnLastPaymentKeyWithPaymentRecords:salesobject.paymentrecords]]) {
//                        [globalvariables.documentfolder.defaultcheckedsalesreceiptpaymentkeys removeObject:[MyClass returnLastPaymentKeyWithPaymentRecords:salesobject.paymentrecords]];
//                    }
//                }
            
            }else{
                //add
                if ([salesobject.productcode isEqualToString:@"FPAY"]){
                    UIAlertController *enrollalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"Forfeited payment cannot be added"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

                    }];
                    
                    [enrollalert addAction:OKAction];
                    [self presentViewController:enrollalert animated:YES completion:nil];

                    return;
                }else if ([salesobject.status isEqualToString:@"Voided"]){
                    UIAlertController *enrollalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"Voided item cannot be added"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

                    }];
                    
                    [enrollalert addAction:OKAction];
                    [self presentViewController:enrollalert animated:YES completion:nil];

                    return;
                }else{
                    addedtofolder=TRUE;
                    if(![globalvariables.documentfolder.salesinvoicearray containsObject:salesobject.saleskey]){
                        [globalvariables.documentfolder.salesinvoicearray addObject:salesobject.saleskey];
                    }
                    
                    if (![globalvariables.documentfolder.salespaymentarray containsObject:salesobject.saleskey]) {
                        [globalvariables.documentfolder.salespaymentarray addObject:salesobject.saleskey];
                    }
                    
                    if (![globalvariables.documentfolder.salesreceiptarray containsObject:salesobject.saleskey] && salesobject.paymentrecords.count>0) {
                        [globalvariables.documentfolder.salesreceiptarray addObject:salesobject.saleskey];
                    }
                    


                    if(![globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:salesobject.saleskey]){
                        [globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys addObject:salesobject.saleskey];
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:salesobject.saleskey] && [salesobject.paid floatValue]!=[salesobject.total floatValue]) {
                        [globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys addObject:salesobject.saleskey];
                    }
                    
                    
                    if (![globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:salesobject.saleskey] && salesobject.paymentrecords.count>0) {
                        [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys addObject:salesobject.saleskey];
                    }
                    
//
//                    if (![[MyClass returnLastPaymentKeyWithPaymentRecords:salesobject.paymentrecords] isEqualToString:@""]) {
//                        [globalvariables.documentfolder.defaultcheckedsalesreceiptpaymentkeys addObject:[MyClass returnLastPaymentKeyWithPaymentRecords:salesobject.paymentrecords]];
//                    }
                }
            }
            
            if (addedtofolder) {
                [self showAddToDocumentFolderAnimationWithTableview:tableView IndexPath:indexPath];
            }
            
            [self refreshdocumentfoldercount];
            DataChanged=YES;

            [SalesTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

        }else{

            [self startsidewindowanimationwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
                SalesPopoverViewController *salespopover = (SalesPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"SalesPopoverViewController"];
                salespopover.delegate=self;
                salespopover.SalesObject=salesobject;
                salespopover.PopoverStudent=DetailsViewStudent;
                salespopover.SalesTableMode=@"View";
                
                salespopover.view.frame=self->mainWindow.bounds;
                [self->sidewindowview addSubview:salespopover.view];
                [self addChildViewController:salespopover];
                [salespopover didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });
            
            
            

        }
        
    }else if (tableView==ClassSelectionTable){
        [self drawpointerwithoption:@"closed" imageview:classselection_arrow];

        [[myClassSelectionPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        
        if (lastviewindex==1) {
            if (indexPath.row==0) {
                subjectselected=@"All";
                [ClassSelectionButton setTitle:[MyClass returntitlewithtitle:[SubjectArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
            }else{
                subjectselected=[SubjectArray objectAtIndex:indexPath.row];
                
                [ClassSelectionButton setTitle:[MyClass returntitlewithtitle:[MyClass returnsubjectnamewithsubject_shortname:subjectselected centerkey:globalvariables.centerrecord.centerkey]] forState:UIControlStateNormal];
            }
            
            [self returnfilterenrollmentarray];
            

        }else if (lastviewindex==2){
            if ([classviewmode isEqualToString:@"selectedEnrollment"]) {
 
                    if (indexPath.row==0) {
                        subjectselected=@"All";
                        [ClassSelectionButton setTitle:[MyClass returntitlewithtitle:[SubjectArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
                    }else{
                        subjectselected=[SubjectArray objectAtIndex:indexPath.row];
                        [ClassSelectionButton setTitle:[MyClass returntitlewithtitle:[MyClass returnsubjectnamewithsubject_shortname:subjectselected centerkey:globalvariables.centerrecord.centerkey]] forState:UIControlStateNormal];
                    }
                [self returnfilterclassarray];
                //}
            }else{

                    if (indexPath.row==0) {
                        subjectselected=@"All";
                        [ClassSelectionButton setTitle:[MyClass returntitlewithtitle:[SubjectArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
                    }else{
                        subjectselected=[SubjectArray objectAtIndex:indexPath.row];
                        [ClassSelectionButton setTitle:[MyClass returntitlewithtitle:[MyClass returnsubjectnamewithsubject_shortname:subjectselected centerkey:globalvariables.centerrecord.centerkey]] forState:UIControlStateNormal];
                    }
                [self returnfilterclassarray];
                //}
            }
        }
    }else if (tableView==ProductCategorySelectionTable){
        [self drawpointerwithoption:@"closed" imageview:productcategorybuttonarrow];
        [ProductCategorySelectionButton setTitle:[ProductCategoryArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        if (indexPath.row==0) {
            productcategoryselected=@"All";
        }else{
            productcategoryselected=[ProductCategoryArray objectAtIndex:indexPath.row];
        }
        
        [[myProductCategorySelectionPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        
        [self returnfiltersalesarray];
    }else if (tableView==CallLogTable){
        

        [self startsidewindowanimationwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            CallLogPopoverViewController *calllogpopover = (CallLogPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"CallLogPopoverViewController"];
            calllogpopover.delegate=self;
            calllogpopover.studentkey=DetailsViewStudent.studentkey;
            calllogpopover.CallLogTableMode=@"View";
            calllogpopover.CallingSource=@"student";
            calllogpopover.CallLogRecordObject=[filteredCallLogRecordArray objectAtIndex:indexPath.row];
            
            if (![calllogpopover InitializeField]) {
                [MyClass showconnectionlostdialogbox];
            }
            
            calllogpopover.view.frame=self->mainWindow.bounds;
            [self->sidewindowview addSubview:calllogpopover.view];
            [self addChildViewController:calllogpopover];
            [calllogpopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
        });
        

    }else if (tableView==CallLogCalledBySelectionTable){
        [self drawpointerwithoption:@"closed" button:CallLogCalledBySelectionButton];

        [CallLogCalledBySelectionButton setTitle:[MyClass returnstaffnamewithusername:[CallLogCalledByArray objectAtIndex:indexPath.row] firstorfullname:@"full"] forState:UIControlStateNormal];
        if (indexPath.row==0) {
            calllogcalledbyselected=@"All";
        }else{
            calllogcalledbyselected=[CallLogCalledByArray objectAtIndex:indexPath.row];
        }
        
        [[myCallLogCalledBySelectionPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        [self returnfiltercalllogarray];
        //[self performSelector:@selector(retrieveCallLogRecord) withObject:nil afterDelay:0];
    }else if (tableView==DTSubjectSelectionTable){
        [self drawpointerwithoption:@"closed" imageview:dt_coursearrow];
        [DTSubjectSelectionButton setTitle:[DTSubjectArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        if (indexPath.row==0) {
            dtsubjectselected=@"All";
        }else{
            dtsubjectselected=[DTSubjectArray objectAtIndex:indexPath.row];
        }
        
        [[myDTSelectionPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        [self returnfilterdtarray];
    }else if (tableView==DTTypeSelectionTable){
        [self drawpointerwithoption:@"closed" imageview:dt_typearrow];
        [DTTypeSelectionButton setTitle:[MyClass returntitlewithtitle:[DTTypeArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
        if (indexPath.row==0) {
            dttypeselected=@"All";
        }else{
            dttypeselected=[DTTypeArray objectAtIndex:indexPath.row];
        }
        
        [[myDTSelectionPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        [self returnfilterdtarray];
    }else if (tableView==TypeSelectionTable){
        [self drawpointerwithoption:@"closed" imageview:typeselectionarrow];
        [TypeSelectionButton setTitle:[MyClass returntitlewithtitle:[typearray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
        if (indexPath.row==0) {
            typeselected=@"All";
        }else{
            typeselected=[typearray objectAtIndex:indexPath.row];
        }
        
        [[myTypeSelectionPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];

        lasttypeindex=indexPath.row;

        [self returnfilterclassarray];

    }else if (tableView==DaySelectionTable){
        [self drawpointerwithoption:@"closed" imageview:dayselectionarrow];
        [DaySelectionButton setTitle:[MyClass returntitlewithtitle:[dayarray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
        if (indexPath.row==0) {
            dayselected=@"All";
        }else{
            dayselected=[dayarray objectAtIndex:indexPath.row];
        }
        
        [[myDaySelectionPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        if (lastviewindex==1) {
            [self returnfilterenrollmentarray];
        }else if (lastviewindex==2){
            [self returnfilterclassarray];
        }
    }else if (tableView==SiblingTable){
        if ([studentAction isEqualToString:@"PopoverStudent"]) {
            [self retrieveStudent:((SiblingRecord *)[DetailsViewStudent.siblingarray objectAtIndex:indexPath.row]).studentkey];
        }else{
            [self.delegate gotostudentprofile:((SiblingRecord *)[DetailsViewStudent.siblingarray objectAtIndex:indexPath.row]).studentkey submenu:0 classkeys:nil saleskey:nil];
        }
        
    }else if (tableView==ViewHistoryTable){
        systemMessageLabel.text=[NSString stringWithFormat:@"%@...",[MyClass returntitlewithtitle:@"Loading Information"]];
        //systemMessageLabel.frame=CGRectMake(0, 0, selfViewWidth, self.view.bounds.size.height-64);
        systemMessageTrailingConstraint.constant=0;
        ViewHistoryTableMasterView.hidden=YES;
        [self.delegate gotostudentprofile:((ViewHistoryRecord *)[viewhistoryarray objectAtIndex:indexPath.row]).typekey submenu:lastviewindex classkeys:nil saleskey:nil];
    }else if (tableView==couponTable){
        
        
        [self startsidewindowanimationwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CouponPopoverViewController *couponpopover = (CouponPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"CouponPopoverViewController"];
            couponpopover.delegate=self;
            couponpopover.studentkeys=[[NSMutableArray alloc]initWithObjects:DetailsViewStudent.studentkey, nil];
            couponpopover.CouponTableMode=0;
            couponpopover.CouponRecordObject=[filteredDetailsViewCouponArray objectAtIndex:indexPath.row];
            
            couponpopover.view.frame=self->mainWindow.bounds;
            [self->sidewindowview addSubview:couponpopover.view];
            [self addChildViewController:couponpopover];
            [couponpopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
        });
        

    }else if(tableView==DetailsViewMessageTable){
        if (selectMode) {
            [self selectMessageWithIndex:indexPath.row];
        }
    }
}


#pragma mark
#pragma mark Methods


-(void) refreshtableaftermakeupabsent
{
    if ([classviewmode isEqualToString:@"selectedEnrollment"]) {
        [self retrieveClassWithEnrollmentkey:DetailsViewEnrollment.enrollmentkey];
    }else{
        [self retrieveClassWithEnrollmentkey:nil];
    }
}

-(void) makeupdatetimebuttonpressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:DetailsViewClassTable];
    NSIndexPath *indexPath =[DetailsViewClassTable indexPathForRowAtPoint:point];
    DetailsViewClass =[filteredDetailsViewClassArray objectAtIndex:indexPath.row];
    [DetailsViewClassTable selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    

    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MakeupPopoverViewController *makeuppopover = (MakeupPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MakeupPopoverViewController"];
        makeuppopover.delegate=self;
        makeuppopover.PopoverDetailsClassRecord=DetailsViewClass;
        makeuppopover.PopoverOption=@"FromClassDetails";
        //classpopover.PopoverStudent=DetailsViewStudent;
        
        makeuppopover.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:makeuppopover.view];
        [self addChildViewController:makeuppopover];
        [makeuppopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
}


-(void) popToRootViewController
{
    UIViewController *vc = [[self.navigationController viewControllers] lastObject];
    if(![vc isKindOfClass:[StudentDetailsViewController class]])
    {
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
}

-(void)updateStudentPoint:(NSString *)studentkey
{
    [self.view endEditing:YES];

    DetailsViewStudent=[MyClass retrieveStudent:studentkey];
    [self getParentLastLogin:DetailsViewStudent];
    
    pointBalance.text=pointbalance;
    
    NSString *expirydate=expirypointdict[@"expirydate"];
    NSString *expirypoint=expirypointdict[@"expirypoint"];
    
    if([expirydate isEqualToString:@""]){
        pointExpiryStack.hidden=YES;
    }else{
        pointExpiryStack.hidden=NO;
        pointExpiryTitle.text= [MyClass returnreplacedtitlewithtitle:@"%@1 points expiring on %@2" replacementarray:@[expirypoint,expirydate]];
    }
        

}

- (BOOL)retrieveStudent:(NSString *)studentkey
{


    [self popToRootViewController];
    [self.view endEditing:YES];
    //[self showviewhistory:FALSE];
    enrollmentsearchbar.text=@"";
    classsearchbar.text=@"";
    
    [MyClass getLatestDataSetv2withParameters:@"student,lead" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    
    NSDate *date;
    DetailsViewStudent=[MyClass retrieveStudent:studentkey];
    [self getParentLastLogin:DetailsViewStudent];
    
    //sort sibling
    for (int i=0; i<DetailsViewStudent.siblingarray.count; i++) {
        ((SiblingRecord *)[DetailsViewStudent.siblingarray objectAtIndex:i]).studentname=[MyClass returnStudentnameWithStudentkey:((SiblingRecord *)[DetailsViewStudent.siblingarray objectAtIndex:i]).studentkey option:@"fullbutid"];
    }
    
    NSSortDescriptor *sortByname = [NSSortDescriptor sortDescriptorWithKey:@"studentname" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors = @[sortByname];
    DetailsViewStudent.siblingarray = [NSMutableArray arrayWithArray:[DetailsViewStudent.siblingarray sortedArrayUsingDescriptors:sortDescriptors]];
    
    [self closefullscreen];

    
    if (DetailsViewStudent) {
        studentnamelabel.text=[MyClass returnStudentnameWithStudentkey:DetailsViewStudent.studentkey option:@"allbutid"];// [MyClass returnfullnamewithfirstname:DetailsViewStudent.firstname lastname:DetailsViewStudent.lastname];
        
        
        if (DetailsViewStudent.studentid != (id)[NSNull null]){
            studentidlabel.text=DetailsViewStudent.studentid;
        }else{
            studentidlabel.text=@"";
        }
        
        if (DetailsViewStudent.fcmemberid != (id)[NSNull null]){
            fcmemberidlabel.text=DetailsViewStudent.fcmemberid;
        }else{
            fcmemberidlabel.text=@"";
        }
        
        genderlabel.text=[MyClass returntitlewithtitle:DetailsViewStudent.gender];
        
        [df setDateFormat:@"dd-MMM-yyyy"];
        dateofbirthlabel.text = [MyClass returndateformatwithdate:DetailsViewStudent.dateofbirth];
        
        if (DetailsViewStudent.dateofbirth && ![DetailsViewStudent.dateofbirth isEqualToString:@""]){
            NSDate *now =[NSDate date];
            [df setDateFormat:@"dd-MMM-yyyy"];
            date=[df dateFromString:DetailsViewStudent.dateofbirth];
            
            double time =[now timeIntervalSinceDate:date];
            int allDays = (((time/60)/60/24));
            int days=allDays%365;
            int years=(allDays-days)/365;
            agelabel.text= [@(years) stringValue];
        }else{
            agelabel.text=DetailsViewStudent.age;
        }
        gradelabel.text=DetailsViewStudent.grade;
        preferredlanguagelabel.text=[MyClass returntitlewithtitle:DetailsViewStudent.preferredlanguage];
        schoollabel.text=DetailsViewStudent.school;
        parentname.text=DetailsViewStudent.parentname;
        parentname2.text=DetailsViewStudent.parentname2;
        extrafield1label.text=DetailsViewStudent.extrafield1;
        extrafield2label.text=[MyClass returntitlewithtitle:DetailsViewStudent.extrafield2];
        
        
        [parentcontactscrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        long phonecount;
        if (DetailsViewStudent.phonearray.count==0) {
            phonecount=1;
        }else{
            phonecount=DetailsViewStudent.phonearray.count;
        }
        
        CGFloat x=-parentcontactseparation;
        for (int i=0; i<phonecount; i++) {
            UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(x+parentcontactseparation, 0, 104, 21)];
            label.text=[MyClass returntitlewithtitle:DetailsViewStudent.phonearray.count==0?[MyClass returntitlewithtitle:@"Contact"]:((ContactRecord *)[DetailsViewStudent.phonearray objectAtIndex:i]).relationship];
            label.font=[UIFont systemFontOfSize:11];
            label.textColor=[UIColor systemBlueColor];
            [parentcontactscrollview addSubview:label];
            
            BOOL firstitem=YES;
            if (DetailsViewStudent.phonearray.count>0) {
                UIImageView *imageview=[[UIImageView alloc]init];//WithFrame:CGRectMake(i*parentcontactwidth-2, 0, 0, 0)];
                if (((ContactRecord *)[DetailsViewStudent.phonearray objectAtIndex:i]).primarycontact) {
                    imageview=[[UIImageView alloc]initWithFrame:CGRectMake(firstitem?(x+parentcontactseparation):(x+2), 20, 13, 13)];
                    [imageview setImage:[UIImage imageNamed:@"primarycontact_icon.png"]];
                    imageview.layer.cornerRadius=3;
                    imageview.layer.masksToBounds=YES;
                    [parentcontactscrollview addSubview:imageview];
                    x=imageview.frame.origin.x+imageview.frame.size.width;
                    firstitem=NO;
                }
                
                
                if (((ContactRecord *)[DetailsViewStudent.phonearray objectAtIndex:i]).enableparentapp) {
                    imageview=[[UIImageView alloc]initWithFrame:CGRectMake(firstitem?(x+parentcontactseparation):(x+2), 20, 13, 13)];
                    [MyClass downloadImageWithImageview:imageview gender:nil type:@"studentappimage" typekey:globalvariables.centerrecord.standaloneparentappid image:@"Yes" async:YES];
                    imageview.layer.cornerRadius=3;
                    imageview.layer.masksToBounds=YES;
                    [parentcontactscrollview addSubview:imageview];
                    x=imageview.frame.origin.x+imageview.frame.size.width;
                    firstitem=NO;
                    
                    //add last login
                    label=[[UILabel alloc]initWithFrame:CGRectMake(label.frame.origin.x, 29, 124, 21)];
                    if ([((ContactRecord *)[DetailsViewStudent.phonearray objectAtIndex:i]).parentapplastlogin isEqualToString:@""]) {
                        label.text=[MyClass returntitlewithtitle:@"Never"];
                    }else{
                        label.text=[MyClass returndateformatDDMMMYYYYHHMMwithdate:[MyClass convertYYYYMMDDHHMMtoDDMMMYYYYHHMMwithdatetime:[((ContactRecord *)[DetailsViewStudent.phonearray objectAtIndex:i]).parentapplastlogin substringToIndex:16]]];
                    }
                    label.font=[UIFont systemFontOfSize:10];
                    label.textColor=[UIColor grayColor];
                    [parentcontactscrollview addSubview:label];
                }
                
                if (((ContactRecord *)[DetailsViewStudent.phonearray objectAtIndex:i]).enablesms) {
                    imageview=[[UIImageView alloc]initWithFrame:CGRectMake(firstitem?(x+parentcontactseparation):(x+2), 20, 13, 13)];
                    [imageview setImage:[UIImage imageNamed:@"messagecenter_icon.png"]];
                    imageview.layer.cornerRadius=3;
                    imageview.layer.masksToBounds=YES;
                    [parentcontactscrollview addSubview:imageview];
                    x=imageview.frame.origin.x+imageview.frame.size.width;
                    firstitem=NO;
                }
                
                if (((ContactRecord *)[DetailsViewStudent.phonearray objectAtIndex:i]).enablewechat) {
                    imageview=[[UIImageView alloc]initWithFrame:CGRectMake(firstitem?(x+parentcontactseparation):(x+2), 20, 13, 13)];
                    [imageview setImage:[UIImage imageNamed:@"wechat_icon.png"]];
                    imageview.layer.cornerRadius=3;
                    imageview.layer.masksToBounds=YES;
                    [parentcontactscrollview addSubview:imageview];
                    x=imageview.frame.origin.x+imageview.frame.size.width;
                    firstitem=NO;
                }
                
                //add country image
                imageview=[[UIImageView alloc]initWithFrame:CGRectMake(firstitem?(x+parentcontactseparation):(x+2), 20, 19.5, 13)];
                [MyClass downloadImageWithImageview:imageview gender:nil type:@"flag" typekey:((ContactRecord *)[DetailsViewStudent.phonearray objectAtIndex:i]).iso_code image:@"Yes" async:YES];
                imageview.contentMode=UIViewContentModeScaleAspectFill;
                imageview.layer.cornerRadius=3;
                imageview.layer.masksToBounds=YES;
                [parentcontactscrollview addSubview:imageview];
                x=imageview.frame.origin.x+imageview.frame.size.width;
                
                //add country code
                label=[[UILabel alloc]initWithFrame:CGRectMake(x+2, 0, 100, 21)];
                label.font=[UIFont systemFontOfSize:15];
                label.textColor=[UIColor darkGrayColor];
                label.text=[NSString stringWithFormat:@"+%@",[MyClass returnCountryCodeWithISOCode:((ContactRecord *)[DetailsViewStudent.phonearray objectAtIndex:i]).iso_code]];
                [label sizeToFit];
                label.frame=CGRectMake(x+2, 16, label.frame.size.width, 21);
                [parentcontactscrollview addSubview:label];
                x=label.frame.origin.x+label.frame.size.width;
                
                //add contact
                label=[[UILabel alloc]initWithFrame:CGRectMake(x+2, 16, 200, 21)];
                label.text=[MyClass returnLocalNumberWithContact:((ContactRecord *)[DetailsViewStudent.phonearray objectAtIndex:i]).contact ISOCode:((ContactRecord *)[DetailsViewStudent.phonearray objectAtIndex:i]).iso_code];
                label.font=[UIFont systemFontOfSize:15];
                label.textColor=[UIColor blackColor];
                [label sizeToFit];
                label.frame=CGRectMake(x+2, 16, label.frame.size.width, 21);
                [parentcontactscrollview addSubview:label];
                x=label.frame.origin.x+label.frame.size.width;
                
                
            }else{

            }
        }
        
        parentcontactmoreview.hidden=x>parentcontactscrollview.frame.size.width?NO:YES;
        parentcontactscrollview.contentSize=CGSizeMake(x, 37);
        parentemail.text=DetailsViewStudent.parentemail;
        parentaddress.text=DetailsViewStudent.parentaddress;
        remarks.text=DetailsViewStudent.remarks;
        studentmedialabel.text=DetailsViewStudent.studentmedia;
        studentsourcelabel.text=DetailsViewStudent.studentsource;
        ddaaccountnolabel.text=DetailsViewStudent.ddaaccountno;
        ddaaccountnamelabel.text=DetailsViewStudent.ddaaccountname;
        ddadebtorreferencelabel.text=DetailsViewStudent.ddadebtorreference;
        ddalimitlabel.text=DetailsViewStudent.ddalimit;
        [studentview_dda_imageview setImage:[UIImage imageNamed:DetailsViewStudent.ddaenabled?@"checked_icon2.png":@"absent_icon2.png"]];
        swflag.on=[DetailsViewStudent.flag isEqualToString:@"Yes"];
        swinactive.on=[DetailsViewStudent.status isEqualToString:@"Inactive"];
        swpromotionalmessage.on=[DetailsViewStudent.promotion isEqualToString:@"Yes"];
        swsendmessage.on=DetailsViewStudent.sendmessage;
        swsendmessage.hidden=!globalvariables.centerrecord.enableparentsendmessage;
        studentview_sendmessage_label.hidden=!globalvariables.centerrecord.enableparentsendmessage;
        
        //retrieve student image
        [MyClass downloadImageWithImageview:viewstudentimage gender:DetailsViewStudent.gender type:@"student" typekey:DetailsViewStudent.studentkey image:DetailsViewStudent.image async:YES];

        studentview_nophoto_label.hidden=![DetailsViewStudent.avatar isEqualToString:@""];
        [SiblingTable reloadData];
        siblingnonelabel.hidden=DetailsViewStudent.siblingarray.count>0;
        
        if (![studentAction isEqualToString:@"PopoverStudent"]) {
            systemMessageView.hidden=YES;
        }
        
        pointBox.hidden=!globalvariables.centerrecord.enablemembershippoint;
        if(globalvariables.centerrecord.enablemembershippoint){
            pointBalance.text=pointbalance;
            
            NSString *expirydate=expirypointdict[@"expirydate"];
            NSString *expirypoint=expirypointdict[@"expirypoint"];
            
            if([expirydate isEqualToString:@""]){
                pointExpiryStack.hidden=YES;
            }else{
                pointExpiryStack.hidden=NO;
                pointExpiryTitle.text= [MyClass returnreplacedtitlewithtitle:@"%@1 points expiring on %@2" replacementarray:@[expirypoint,expirydate]];
            }
        }

        return YES;
        
    }else{
        //[MyClass loadingindicatorwithoption:@"stop" color:nil];
        
        return NO;
    }

}

-(void) dismissclassremarkspopover
{
    [self closesidewindow];
    //[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
    UIAlertController *updatedalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Information"] message:[MyClass returntitlewithtitle:@"Information is updated"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    [updatedalert addAction:OKAction];
    //[self presentViewController:updatedalert animated:YES completion:nil];
    [MyClass presentViewController:updatedalert View:self];
    
    if ([classviewmode isEqualToString:@"selectedEnrollment"]) {
        [self retrieveClassWithEnrollmentkey:DetailsViewEnrollment.enrollmentkey];
    }else{
        [self retrieveClassWithEnrollmentkey:nil];
    }
    
    DataChanged=YES;
}


-(BOOL) retrieveClassWithEnrollmentkey:(NSString *)enrollmentkey
{

    long selectedclasskeyindex=-1;
    //create string contains url address for php file
    NSString *strURL;
    if (enrollmentkey) {
        strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectclass&studentkey=%@&subject=%@&classday=%@&status=%@&makeupabsent=%@&enrollmentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DetailsViewStudent.studentkey,@"All",@"All",@"All",@"All",enrollmentkey];
    }else{
        strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectclass&studentkey=%@&subject=%@&classday=%@&status=%@&makeupabsent=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DetailsViewStudent.studentkey,@"All",@"All",@"All",@"All"];
    }
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDate *date;
            result = TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            DetailsViewClassArray=[[NSMutableArray alloc] init];
            SubjectArray=[[NSMutableArray alloc]init];
            
            NSString *maxclasslevelmain=@"";
            NSString *maxclasslevelctm=@"";
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our ClassRecord object
                NSString * cstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
                NSString * cclasskey=[[JSONArray objectAtIndex:i] objectForKey:@"classkey"];
                NSString * cenrollmentkey=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentkey"];
                NSString * csubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString * clevelmain=[[JSONArray objectAtIndex:i] objectForKey:@"levelmain"];
                NSString * clevelctm=[[JSONArray objectAtIndex:i] objectForKey:@"levelctm"];
                
                //find last class level
                if (i==JSONArray.count-1) {
                    maxclasslevelmain=clevelmain;
                    maxclasslevelctm=clevelctm;
                }
                
                NSString * cmakeupdate;
                NSString *cstartdate;
                
                [df setDateFormat:@"yyyy-MM-dd"];
                
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

                NSString * cclasstime=[[JSONArray objectAtIndex:i] objectForKey:@"classtime"];
                
                NSString * cclassday=[MyClass returndayofweek:cstartdate];

                
                
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
                NSString * cleavenaturelistkey=[[JSONArray objectAtIndex:i] objectForKey:@"leavenaturelistkey"];
                BOOL makeupquotaavailable=[[[JSONArray objectAtIndex:i] objectForKey:@"makeupquotaavailable"] isEqualToString:@"Yes"];
                
                OutboxMessageRecord *voiceparentnotemessage=[[OutboxMessageRecord alloc]init];
                MessagePhotoRecord *voiceparentnotephotoobject=[[MessagePhotoRecord alloc]init];
                NSDictionary *voiceparentnoterecord=[[JSONArray objectAtIndex:i] objectForKey:@"voiceparentnoterecord"];
                NSString * clesson=[[JSONArray objectAtIndex:i] objectForKey:@"lesson"];
                NSString * csinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"sinstructor"];
                NSString * cmakeupsinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"makeupsinstructor"];
                BOOL clocked=[[[JSONArray objectAtIndex:i] objectForKey:@"locked"] isEqualToString:@"Yes"];
                BOOL cenrollmentpaid=[[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentpaid"] isEqualToString:@"1"];
                BOOL cexpiredpromotion=[[[JSONArray objectAtIndex:i] objectForKey:@"expiredpromotion"] isEqualToString:@"1"];
                BOOL chasextendedclass=[[[JSONArray objectAtIndex:i] objectForKey:@"hasextendedclass"] isEqualToString:@"Yes"];
                
                if (voiceparentnoterecord.count>0) {
//                    voiceparentnotemessage.messagestarttime=[voiceparentnoterecord objectForKey:@"messagestarttime"];
//                    voiceparentnotephotoobject.filename=[voiceparentnoterecord objectForKey:@"imagename"];
//                    voiceparentnotephotoobject.width=[[voiceparentnoterecord objectForKey:@"width"] floatValue];
//                    voiceparentnotephotoobject.height=[[voiceparentnoterecord objectForKey:@"height"] floatValue];
//                    voiceparentnotemessage.photoarray=[[NSMutableArray alloc]initWithObjects:voiceparentnotephotoobject, nil];
                    voiceparentnotemessage.messagestarttime=[voiceparentnoterecord objectForKey:@"messagestarttime"];
                    voiceparentnotephotoobject.filename=[voiceparentnoterecord objectForKey:@"filename"];
                    voiceparentnotephotoobject.width=[[voiceparentnoterecord objectForKey:@"width"] floatValue];
                    voiceparentnotephotoobject.height=[[voiceparentnoterecord objectForKey:@"height"] floatValue];
                    voiceparentnotephotoobject.messagephotourl=[voiceparentnoterecord objectForKey:@"fileurl"];
                    voiceparentnotemessage.photoarray=[[NSMutableArray alloc]initWithObjects:voiceparentnotephotoobject, nil];
                }
                
                if (![SubjectArray containsObject:csubject]) {
                    [SubjectArray addObject:csubject];
                }
                
                
                //Add the student object to our student array
                [DetailsViewClassArray addObject:[[ClassRecord alloc]initClassWithstudentkey:cstudentkey andenrollmentkey:cenrollmentkey andclasskey:cclasskey andsubject:csubject andlevelmain:clevelmain andlevelctm:clevelctm andstartdate:cstartdate andclassday:cclassday andclasstime:cclasstime andinstructor:cinstructor andattendance:cattendance andmakeupattendance:cmakeupattendance andmakeupdate:cmakeupdate andmakeuptime:cmakeuptime andremarks:cremarks andallclassremarks:callclassremarks andmakeupinstructor:cmakeupinstructor andmakeupclassroom:cmakeupclassroom andabsentmakeupreason:cabsentmakeupreason anddraft:cdraft andclassroom:cclassroom andschedulekey:cschedulekey andstatus:cstatus andextendedminute:cextendedminute andextensiontime:cextensiontime orderdatetime:corderdatetime instructorfullname:cinstructorfullname makeupinstructorfullname:cmakeupinstructorfullname subjectfullname:csubjectfullname parentnote:cparentnote assessmentformcount:cassessmentformcount leavenaturelistkey:cleavenaturelistkey makeupquotaavailable:makeupquotaavailable voiceparentnotemessage:voiceparentnotemessage lesson:clesson sinstructor:csinstructor makeupsinstructor:cmakeupsinstructor locked:clocked enrollmentpaid:cenrollmentpaid expiredpromotion:cexpiredpromotion hasextendedclass:chasextendedclass]];
            }
        }
    }];
    
            
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        if (selectedClasskey && ![selectedClasskey isEqualToString:@""]) {
            lastactivedraftindex_class=0;
            scactiveoption_class.selectedSegmentIndex=0;
        }
        
        //Reload our student view
        [self returnfilterclassarray];
        [self.DetailsViewClassTable reloadData];
        selectedclasskeyindex=[self returnselectedclasskeyindexwithselectedclasskey:selectedClasskey];
        if (filteredDetailsViewClassArray.count>0 && selectedclasskeyindex>=0) {
            [self.DetailsViewClassTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedclasskeyindex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
        
        SubjectArray=[MyClass returnsortedsubjectlistwithsubjectcodearray:SubjectArray];
        [SubjectArray insertObject:@"All Classes" atIndex:0];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    
    return result;
}

-(void) getParentLastLogin:(Student *)student
{
    BOOL parentappenabled=FALSE;
    
    for (int i=0; i<student.phonearray.count; i++) {
        if (((ContactRecord *)[student.phonearray objectAtIndex:i]).enableparentapp) {
            parentappenabled=TRUE;
            break;
        }
    }
    
    if (parentappenabled || globalvariables.centerrecord.enablemembershippoint) {
        //generate json student array
        
        NSString *strURL;
        
        strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=getstudentadditioninformation&studentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,student.studentkey];
        __block BOOL result=FALSE;
        __block NSData *returndata;
        [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
                returndata=data;
                
            }
        }];
        
        if(result){
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:returndata options:(kNilOptions) error:nil];
            NSMutableArray * parentapplastloginrecords = jsonreturned[@"content"][@"parentapplastloginrecords"];
            pointbalance=jsonreturned[@"content"][@"pointbalance"];
            expirypointdict=jsonreturned[@"content"][@"expirypoint"];
            for (int i=0; i<parentapplastloginrecords.count; i++) {
                
                NSString * parentapplastlogin=[[parentapplastloginrecords objectAtIndex:i] objectForKey:@"parentapplastlogin"];
                NSString * contact=[[parentapplastloginrecords objectAtIndex:i] objectForKey:@"contact"];
                
                for (int i=0; i<student.phonearray.count; i++) {
                    if ([((ContactRecord *)[student.phonearray objectAtIndex:i]).contact isEqualToString:contact] && ((ContactRecord *)[student.phonearray objectAtIndex:i]).enableparentapp) {
                        ((ContactRecord *)[student.phonearray objectAtIndex:i]).parentapplastlogin=parentapplastlogin;
                        break;
                    }
                }
            }
        }

//        NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
//        [dictionary setValue:@"getparentapplastlogin" forKey:@"postaction"];
//        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
//        [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
//        [dictionary setValue:student.studentkey forKey:@"studentkey"];
//
//        //__block BOOL result=FALSE;
//        [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
//            if (succeeded) {
//                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
//                JSONArray = jsonreturned[@"content"];
//                for (int i=0; i<JSONArray.count; i++) {
//
//                    //Create our ClassRecord object
//                    NSString * parentapplastlogin=[[JSONArray objectAtIndex:i] objectForKey:@"parentapplastlogin"];
//                    NSString * contact=[[JSONArray objectAtIndex:i] objectForKey:@"contact"];
//
//                    for (int i=0; i<student.phonearray.count; i++) {
//                        if ([((ContactRecord *)[student.phonearray objectAtIndex:i]).contact isEqualToString:contact]) {
//                            ((ContactRecord *)[student.phonearray objectAtIndex:i]).parentapplastlogin=parentapplastlogin;
//                            break;
//                        }
//                    }
//                }
//            }
//        }];
        
    }
}

-(long) returnselectedclasskeyindexwithselectedclasskey:(NSString *)classkey
{
    if (classkey) {
        for (int i=0; i<filteredDetailsViewClassArray.count; i++) {
            if ([((ClassRecord *)[filteredDetailsViewClassArray objectAtIndex:i]).classkey isEqualToString:classkey]) {
                return i;
            }
        }
    }
    return -1;
}

-(long) returnselectedenrollmentkeyindexwithselectedenrollmentkey:(NSString *)enrollmentkey
{
    if (enrollmentkey) {
        for (int i=0; i<filteredDetailsViewEnrollmentArray.count; i++) {
            if ([((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).enrollmentkey isEqualToString:enrollmentkey]) {
                return i;
            }
        }
    }
    return -1;
}


-(long) returnselecteddtkeyindexwithselecteddtkey:(NSString *)dtkey
{
    if (dtkey) {
        for (int i=0; i<filteredDetailsViewDTArray.count; i++) {
            if ([((DTRecord *)[filteredDetailsViewDTArray objectAtIndex:i]).DTkey isEqualToString:dtkey]) {
                return i;
            }
        }
    }
    return -1;
}

-(long) returnselectedsaleskeyindexwithselectedsaleskey:(NSString *)saleskey
{
    if (saleskey) {
        for (int i=0; i<filteredSalesRecordArray.count; i++) {
            if ([((SalesRecord *)[filteredSalesRecordArray objectAtIndex:i]).saleskey isEqualToString:saleskey]) {
                return i;
            }
        }
    }
    return -1;
}


-(BOOL) retrieveEnrollmentWithStudentkey:(NSString *)studentkey
{
    long selectedEnrollmentkeyindex=-1;

    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectenrollment&studentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,studentkey];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our enrollment array
            DetailsViewEnrollmentArray=[[NSMutableArray alloc] init];
            LevelDictionary=[[NSMutableDictionary alloc]init];
            SubjectArray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our ClassRecord object
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
                NSString *cenrollmentdate = [[JSONArray objectAtIndex:i] objectForKey:@"enrollmentdate"];//[df stringFromDate:date];
                NSString *cbilldate = [[JSONArray objectAtIndex:i] objectForKey:@"billdate"];
                
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
                
                NSString * cresumeclassdate=[MyClass convertDateFormatWithDate:[[JSONArray objectAtIndex:i] objectForKey:@"resumeclassdate"] FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                
                
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
                //NSArray *cpaymentkeys=[[NSArray alloc]initWithArray:[[[JSONArray objectAtIndex:i] objectForKey:@"paymentkeys"] componentsSeparatedByString:@","]];
                
                NSString * cenrollmentmode=[[JSONArray objectAtIndex:i] objectForKey:@"enrollmentmode"];
                NSString * cstandardnoofclassormonth=[[JSONArray objectAtIndex:i] objectForKey:@"standardnoofclassormonth"];
                NSString * coutstandingmakeupclasses=[[JSONArray objectAtIndex:i] objectForKey:@"outstandingmakeupclasses"];
                
                if (![SubjectArray containsObject:csubject]) {
                    [SubjectArray addObject:csubject];
                }
                BOOL clocked=[[[JSONArray objectAtIndex:i] objectForKey:@"locked"] isEqualToString:@"Yes"];
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
                    BOOL sbuymorepayless=[[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"buymorepayless"] isEqualToString:@"Yes"];
                    BOOL smanualapply=[[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"manualapply"] isEqualToString:@"Yes"];
                    
                    [cpromotiondiscountrecords addObject:[[MarketingRecord alloc]initMarketingRecordWithcenterkey:scenterkey marketingkey:smarketingkey category:@"promotion" description:sdescription description_chinese:sdescription_chinese startdate:sstartdate enddate:senddate remarks:sremarks promotionfixeddiscount:spromotionfixeddiscount promotionpercentagediscount:spromotionpercentagediscount usedcount:susedcount promotionquota:spromotionquota code:scode recursive:srecursive effectivefrom:nil effectiveto:nil subcategory:nil redeemable:NO redeempoint:nil perstudentquota:nil cannotuseconjunctionwithothercoupons:NO subjectarray:nil productarray:nil couponallowcredit:nil perclassorquantity:sperclassorquantity earlybirdlastdate:nil buymorepayless:sbuymorepayless estartdate:nil eenddate:nil enablebuymorepayless:NO minnoofclass:0 bmsmacrossothersubjects:NO bmsmminsubjectno:0 bmsmminnoofclasspersubject:0 bmsmsamebillmonth:NO manualapply:smanualapply]];
                }
                
                NSMutableArray *ccouponrecords=[[NSMutableArray alloc]init];
                NSArray *couponrecords=[[JSONArray objectAtIndex:i] objectForKey:@"couponrecords"];
                for (int i=0; i<couponrecords.count; i++) {
                    NSString * scenterkey=[[couponrecords objectAtIndex:i] objectForKey:@"centerkey"];
                    NSString * scouponkey=[[couponrecords objectAtIndex:i] objectForKey:@"couponkey"];
                    NSString * smarketingkey=[[couponrecords objectAtIndex:i] objectForKey:@"marketingkey"];
                    NSString * seffectiveto=[[couponrecords objectAtIndex:i] objectForKey:@"effectiveto"];
                    NSString * sissuedate=[[couponrecords objectAtIndex:i] objectForKey:@"issuedate"];
                    NSString * sdateused=[[couponrecords objectAtIndex:i] objectForKey:@"dateused"];
                    NSString * seffectivefrom=[[couponrecords objectAtIndex:i] objectForKey:@"effectivefrom"];
                    NSString * sremarks=[[couponrecords objectAtIndex:i] objectForKey:@"remarks"];
                    NSString * sstudentkey=[[couponrecords objectAtIndex:i] objectForKey:@"studentkey"];
                    BOOL scannotuseconjunctionwithothercoupons=[[[couponrecords objectAtIndex:i] objectForKey:@"cannotuseconjunctionwithothercoupons"] isEqualToString:@"Yes"];
                    BOOL screditable=[[[couponrecords objectAtIndex:i] objectForKey:@"creditable"] isEqualToString:@"Yes"];
                    
                    [ccouponrecords addObject:[[CouponRecord alloc]initCouponRecordWithcenterkey:scenterkey marketingkey:smarketingkey couponkey:scouponkey issuedate:sissuedate effectiveto:seffectiveto dateused:sdateused effectivefrom:seffectivefrom remarks:sremarks marketing:nil usedsequence:nil studentkey:sstudentkey cannotuseconjunctionwithothercoupons:scannotuseconjunctionwithothercoupons creditable:screditable]];
                }
                
                //Add the student object to our student array
                [DetailsViewEnrollmentArray addObject:[[EnrollmentRecord alloc]initEnrollmentWithstudentkey:cstudentkey andenrollmentkey:cenrollmentkey andenrollmentdate:cenrollmentdate andschedulekey:cschedulekey andsubject:csubject andlevelmain:clevelmain andlevelctm:clevelctm andgrade:cgrade andstartdate:cstartdate andnoofclass:cnoofclass andenddate:cenddate andclassday:cclassday andclasstime:cclasstime andinstructor:cinstructor andenrollmentfee:cenrollmentfee andtuitionfee:ctuitionfee andoneoffdiscount:coneoffdiscount andrecursivediscount:crecursivediscount andoneoffpercentagediscount:coneoffpercentagediscount andlatefee:clatefee andtotalfee:ctotalfee andpaid:cpaid anddropclassstatus:cdropclassstatus anddropclassdate:cdropclassdate andremarks:cremarks anddraft:cdraft andinvoiceremarks:cinvoiceremarks andclassroom:cclassroom andautorenew:cautorenew andstatus:cstatus andreverseadjustment:creverseadjustment instructorfullname:cinstructorfullname subjectfullname:csubjectfullname validity:cvalidity makeup_quota:cmakeup_quota makeup_quota_used:cmakeup_quota_used paymentrecords:cpaymentrecords promotiondiscountrecords:cpromotiondiscountrecords classrecords:nil sinstructor:csinstructor transferredfromenrollmentkey:@"" enrollmentmode:cenrollmentmode standardnoofclassormonth:cstandardnoofclassormonth couponrecords:ccouponrecords invoicenumber:cinvoicenumber invoiceprefix:cinvoiceprefix locked:clocked billdate:cbilldate resumeclassdate:cresumeclassdate outstandingmakeupclasses:coutstandingmakeupclasses]];
                
                
                if ([LevelDictionary objectForKey:csubject]) {
                    lastlevelobject=[LevelDictionary objectForKey:csubject];
                    if (![cenddate isEqualToString:@"TBD"] && ![cenddate isEqualToString:@"TBF"] && ![cenddate isEqualToString:@""]) {
                        if ([lastlevelobject.date compare:[MyClass convertToNSDateWithDate:cenddate DateFormat:@"dd-MMM-yyyy"]]!=NSOrderedDescending) {
                            
                            [LevelDictionary removeObjectForKey:csubject];
                            [LevelDictionary setValue:[[LastLevelRecord alloc]initLastLevelRecordwithDate:[MyClass convertToNSDateWithDate:cenddate DateFormat:@"dd-MMM-yyyy"] LevelMain:clevelmain LevelCTM:clevelctm] forKey:csubject];
                        }
                    }
                }else{
                    if (![cenddate isEqualToString:@"TBD"] && ![cenddate isEqualToString:@"TBF"] && ![cenddate isEqualToString:@""]) {
                        [LevelDictionary setValue:[[LastLevelRecord alloc]initLastLevelRecordwithDate:[MyClass convertToNSDateWithDate:cenddate DateFormat:@"dd-MMM-yyyy"] LevelMain:clevelmain LevelCTM:clevelctm] forKey:csubject];
                    }
                }
            }
        }
    }];
    
    
    if (result) {
        [self returnfilterenrollmentarray];
        
        [self.DetailsViewEnrollmentTable reloadData];
        
        selectedEnrollmentkeyindex=[self returnselectedenrollmentkeyindexwithselectedenrollmentkey:selectedEnrollmentkey];
        if (filteredDetailsViewEnrollmentArray.count>0 && selectedEnrollmentkeyindex>=0) {
            [self.DetailsViewEnrollmentTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedEnrollmentkeyindex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }

        SubjectArray=[MyClass returnsortedsubjectlistwithsubjectcodearray:SubjectArray];
        [SubjectArray insertObject:@"All Classes" atIndex:0];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    
    return result;

}


- (void)selectclass:(UIButton *)sender {
    //Load data

    // add group selection tables
    ClassSelectionTable=[[UITableView alloc]init];
    ClassSelectionTable.separatorColor=[UIColor clearColor];
    ClassSelectionTable.delegate=self;
    ClassSelectionTable.dataSource=self;
    [ClassSelectionTable reloadData];
    ClassSelectionTable.frame=CGRectMake(0, 0, selfViewWidth-504, ClassSelectionTable.contentSize.height>maxselectiontableheight?maxselectiontableheight:ClassSelectionTable.contentSize.height);
    ClassSelectionTable.separatorColor=[UIColor clearColor];
    
    UIView *classSelectionMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ClassSelectionTable.frame.size.width, ClassSelectionTable.frame.size.height)];
    [classSelectionMasterView addSubview:ClassSelectionTable];
    
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=classSelectionMasterView;
    viewcontroller.preferredContentSize=CGSizeMake(ClassSelectionTable.frame.size.width, ClassSelectionTable.frame.size.height);
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myClassSelectionPopoverController=viewcontroller.popoverPresentationController;
    myClassSelectionPopoverController.delegate=self;
    myClassSelectionPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myClassSelectionPopoverController.sourceView=sender;
    CGRect rect=CGRectMake(sender.frame.origin.x+0, sender.frame.origin.y, sender.frame.size.width, sender.frame.size.height);
    myClassSelectionPopoverController.sourceRect=rect;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];

    [self drawpointerwithoption:@"open" imageview:classselection_arrow];
    
     
}

- (void)selectday:(UIButton *)sender {
    
    long tablewidth=(lastviewindex==1)?250:129;
    
    DaySelectionTable=[[UITableView alloc]init];
    DaySelectionTable.separatorColor=[UIColor clearColor];
    DaySelectionTable.delegate=self;
    DaySelectionTable.dataSource=self;
    [DaySelectionTable reloadData];
    DaySelectionTable.frame=CGRectMake(0, 0, tablewidth, DaySelectionTable.contentSize.height);
    DaySelectionTable.separatorColor=[UIColor clearColor];
    
    UIView *daySelectionMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, tablewidth, DaySelectionTable.contentSize.height+44)];
    [daySelectionMasterView addSubview:DaySelectionTable];
    
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=daySelectionMasterView;
    viewcontroller.preferredContentSize=CGSizeMake(tablewidth, DaySelectionTable.contentSize.height);
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myDaySelectionPopoverController=viewcontroller.popoverPresentationController;
    myDaySelectionPopoverController.delegate=self;
    myDaySelectionPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myDaySelectionPopoverController.sourceView=sender;
    myDaySelectionPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    
    [self drawpointerwithoption:@"open" imageview:dayselectionarrow];
}

- (void)selecttype:(UIButton *)sender {
    
    TypeSelectionTable=[[UITableView alloc]init];
    TypeSelectionTable.separatorColor=[UIColor clearColor];
    TypeSelectionTable.delegate=self;
    TypeSelectionTable.dataSource=self;
    [TypeSelectionTable reloadData];
    TypeSelectionTable.frame=CGRectMake(0, 0, sender.bounds.size.width, TypeSelectionTable.contentSize.height);
    TypeSelectionTable.separatorColor=[UIColor clearColor];
    
    UIView *typeSelectionMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, sender.bounds.size.width, TypeSelectionTable.contentSize.height+44)];
    [typeSelectionMasterView addSubview:TypeSelectionTable];
    
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=typeSelectionMasterView;
    viewcontroller.preferredContentSize=CGSizeMake(sender.bounds.size.width, TypeSelectionTable.contentSize.height);
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myTypeSelectionPopoverController=viewcontroller.popoverPresentationController;
    myTypeSelectionPopoverController.delegate=self;
    myTypeSelectionPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myTypeSelectionPopoverController.sourceView=sender;
    myTypeSelectionPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    [self drawpointerwithoption:@"open" imageview:typeselectionarrow];
}


- (IBAction)selectactive:(id)sender {
    
    //BOOL result=FALSE;
    
    if (lastviewindex==1) {
        [self returnfilterenrollmentarray];
    }else if (lastviewindex==2){
        [self returnfilterclassarray];
    }
}

- (void)flagStudent:(UISwitch *)sender {

    //[sender setOn:sender.on?NO:YES animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self localupdateCategoryCountwithflag:sender.on?@"Yes":@"No" status:swinactive.on?@"Inactive":@""]) {
            [sender setOn:!sender.on animated:YES];
        }else{
            DetailsViewStudent.flag=sender.on?@"Yes":@"No";
        }
    });
}

- (void)promotionStudent:(UISwitch *)sender {
    
    //[sender setOn:sender.on?NO:YES animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self updatepromotionalmessagewithpromotion:sender.on?@"Yes":@"No"]) {
            [sender setOn:!sender.on animated:YES];
        }else{
            DetailsViewStudent.promotion=sender.on?@"Yes":@"No";
        }
    });
}

- (void)sendMessageStudent:(UISwitch *)sender {
    
    //[sender setOn:sender.on?NO:YES animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self updatesendmessagewithsendmessage:sender.on?@"Yes":@"No"]) {
            [sender setOn:!sender.on animated:YES];
        }else{
            DetailsViewStudent.sendmessage=sender.on;
        }
    });
}

- (void)deactiveStudent:(UISwitch *)sender {

    //[sender setOn:sender.on?NO:YES animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self localupdateCategoryCountwithflag:swflag.on?@"Yes":@"No" status:sender.on?@"Inactive":@""]) {
            [sender setOn:!sender.on animated:YES];
        }else{
            DetailsViewStudent.status=sender.on?@"Inactive":@"";
        }
    });
}



-(BOOL) localupdateCategoryCountwithflag:(NSString *)flag status:(NSString *)status
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatestudent&studentkey=%@&flag=%@&status=%@&updatedby=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DetailsViewStudent.studentkey,flag,status,globalvariables.username];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            DetailsViewStudent.flag=flag;
            DetailsViewStudent.status=status;
            
            result = TRUE;
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            DetailsViewStudent.flag=flag;
            DetailsViewStudent.status=status;
            
            result = TRUE;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        [self.delegate updateCategoryCount];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    
    return result;

}

-(BOOL) updatepromotionalmessagewithpromotion:(NSString *)promotion
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatestudent&studentkey=%@&promotion=%@&updatedby=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DetailsViewStudent.studentkey,promotion,globalvariables.username];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            DetailsViewStudent.promotion=promotion;
            result = TRUE;
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            DetailsViewStudent.promotion=promotion;
            result = TRUE;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        [self.delegate updateCategoryCount];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    
    return result;
}

-(BOOL) updatesendmessagewithsendmessage:(NSString *)sendmessage
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatestudent&studentkey=%@&sendmessage=%@&updatedby=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DetailsViewStudent.studentkey,sendmessage,globalvariables.username];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            DetailsViewStudent.sendmessage=[sendmessage isEqualToString:@"Yes"];
            result = TRUE;
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            DetailsViewStudent.sendmessage=[sendmessage isEqualToString:@"Yes"];
            result = TRUE;
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (!result) {
        [MyClass showconnectionlostdialogbox];
    }*/
    
    return result;
}




- (IBAction)selecttable:(UIButton *)sender {
    //sctableoption.frame=CGRectMake(7, 24, 774, 35);
    [self stopAudioPlaying];
    [self.view endEditing:YES];
    //[self showviewhistory:FALSE];
    
    if(sender.tag==0 && !showstudentpage){
        return;
    }
    
    isSelectCombinePayment=FALSE;
    
    
    [self highlighttableoptionbuttonwithbuttontag:sender.tag];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    long oldlastviewindex=lastviewindex;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (sender.tag==0) {
            lastviewindex=sender.tag;
            if (![self retrieveStudent:DetailsViewStudent.studentkey]) {
                //sctableoption.selectedSegmentIndex=lastviewindex;
                lastviewindex=oldlastviewindex;
                [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
                return;
            }
            
            ViewStudent.hidden=NO;
            EnrollmentRecordView.hidden=YES;
            ClassRecordView.hidden=YES;
            EnrollmentClassMenuView.hidden=YES;
            SalesView.hidden=YES;
            CouponView.hidden=YES;
            MessageView.hidden=YES;
            CallLogView.hidden=YES;
            DTRecordView.hidden=YES;
//            [scactiveoption setEnabled:YES forSegmentAtIndex:2];
            [self createStudentViewNavigationButton];
            
            headertitlename.text=[MyClass returntitlewithtitle:@"Student Information"];
            classviewmode=@"AllEnrollment";
            

            
            //[self.delegate updatestudentinformationlist:DetailsViewStudent.studentkey];
            [self highlightduebuttonwithreloadstudentlist:NO];
            
        }else if (sender.tag==1) {
            //isSelectCombinePayment=FALSE;
            [self refreshenrollmenttableheader];
            lastviewindex=sender.tag;

            
            if (![self retrieveEnrollmentWithStudentkey:DetailsViewStudent.studentkey]) {
                lastviewindex=oldlastviewindex;
                [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
                return;
            }
            
            ViewStudent.hidden=YES;
            EnrollmentRecordView.hidden=NO;
            ClassRecordView.hidden=YES;
            EnrollmentClassMenuView.hidden=NO;
            SalesView.hidden=YES;
            CouponView.hidden=YES;
            MessageView.hidden=YES;
            CallLogView.hidden=YES;
            DTRecordView.hidden=YES;
            scactiveoption_enrollment.hidden=NO;
            scactiveoption_class.hidden=YES;
//            [scactiveoption setEnabled:YES forSegmentAtIndex:2];
            [self createEnrollmentViewNavigationButton];
            
            headertitlename.text=[MyClass returntitlewithtitle:@"Enrollment Information"];
            TypeSelectionButton.hidden=YES;
            typeselectionarrow.hidden=YES;
            //scdayoption.frame=CGRectMake(303, 2, 200.5, 29);
//            DaySelectionButton.frame=CGRectMake(selfViewWidth-501, 2, 200.5, 29);
//            scactiveoption_enrollment.frame=CGRectMake(selfViewWidth-299, 2, 282, 29);
//            scactiveoption_class.frame=scactiveoption_enrollment.frame;
            
            scactiveoption_class.hidden=YES;
            scactiveoption_enrollment.hidden=NO;
            [self drawpointerwithoption:@"closed" imageview:dayselectionarrow];
            
            classviewmode=@"AllEnrollment";
            
//            if (scactiveoption.numberOfSegments==3) {
//                [scactiveoption insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Due"] atIndex:3 animated:NO];
//                [scactiveoption insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Voided"] atIndex:4 animated:NO];
//            }
            
//            [self loadscactiveoption];
            

            
            //lastviewindex=sender.tag;
            ///[self.delegate updatestudentinformationlist:DetailsViewStudent.studentkey];
            [self highlightduebuttonwithreloadstudentlist:YES];
            ///[MyClass loadingindicatorwithoption:@"stop" color:nil];
            
            
        }else if (sender.tag==2) {
            lastviewindex=sender.tag;
            [DetailsViewClassTable addGestureRecognizer:panGesture];
            [DetailsViewDTTable removeGestureRecognizer:panGesture];
            
//            [self loadscactiveoption];
//            if (scactiveoption.numberOfSegments>3) {
//                [scactiveoption removeSegmentAtIndex:3 animated:NO];
//                [scactiveoption removeSegmentAtIndex:3 animated:NO];
                
//                if (lastactivedraftindex>1) {
//                    lastactivedraftindex=1;
//                    scactiveoption.selectedSegmentIndex=1;
//                }
//            }
//            lastactivedraftindex=1;
//            scactiveoption.selectedSegmentIndex=1;
            
            
            if (![self retrieveClassWithEnrollmentkey:nil]) {
                lastviewindex=oldlastviewindex;
                [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
                return;
            }
            
            ViewStudent.hidden=YES;
            EnrollmentRecordView.hidden=YES;
            ClassRecordView.hidden=NO;
            EnrollmentClassMenuView.hidden=NO;
            SalesView.hidden=YES;
            CouponView.hidden=YES;
            MessageView.hidden=YES;
            CallLogView.hidden=YES;
            DTRecordView.hidden=YES;
            scactiveoption_enrollment.hidden=YES;
            scactiveoption_class.hidden=NO;
            [self createClassViewNavigationButton];
            
            headertitlename.text=[MyClass returntitlewithtitle:@"Class Information"];
            TypeSelectionButton.hidden=NO;
            typeselectionarrow.hidden=NO;
            //scmakeupabsent.enabled=YES;
            //scdayoption.frame=CGRectMake(203, 2, 279, 29);
//            DaySelectionButton.frame=CGRectMake(selfViewWidth-501, 2, 129, 29);
//            scactiveoption_enrollment.frame=CGRectMake(selfViewWidth-204, 2, 187, 29);
//            scactiveoption_class.frame=scactiveoption_enrollment.frame;
            scactiveoption_class.hidden=NO;
            scactiveoption_enrollment.hidden=YES;
            [self drawpointerwithoption:@"closed" imageview:dayselectionarrow];
            
            classviewmode=@"AllEnrollment";
            
            

            //scdayoption.selectedSegmentIndex=0;
            ///[self.delegate updatestudentinformationlist:DetailsViewStudent.studentkey];
            [self highlightduebuttonwithreloadstudentlist:YES];
            ///[MyClass loadingindicatorwithoption:@"stop" color:nil];
            

            
            //lastviewindex=sender.tag;
        }else if (sender.tag==3) {
            lastviewindex=sender.tag;
            productcategoryselected=@"All";
            //sceventselection.selectedSegmentIndex=0;
            [self refreshsalestableheader];
            
            if (![self retrieveSalesRecord]) {
                lastviewindex=oldlastviewindex;
                [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
                return;
            }
            
            ViewStudent.hidden=YES;
            EnrollmentRecordView.hidden=YES;
            ClassRecordView.hidden=YES;
            EnrollmentClassMenuView.hidden=YES;
            SalesView.hidden=NO;
            CouponView.hidden=YES;
            MessageView.hidden=YES;
            CallLogView.hidden=YES;
            DTRecordView.hidden=YES;
            
            [self createSalesViewNavigationButton];
            
            headertitlename.text=[MyClass returntitlewithtitle:@"Sales Records"];
            
            //lastviewindex=sender.tag;
            ///[self.delegate updatestudentinformationlist:DetailsViewStudent.studentkey];
            

            [self highlightduebuttonwithreloadstudentlist:YES];
            ///[MyClass loadingindicatorwithoption:@"stop" color:nil];
            
        }else if (sender.tag==4) {
            //[self updateinstantmessagetopbox];
            lastviewindex=sender.tag;


            ViewStudent.hidden=YES;
            EnrollmentRecordView.hidden=YES;
            ClassRecordView.hidden=YES;
            EnrollmentClassMenuView.hidden=YES;
            SalesView.hidden=YES;
            CouponView.hidden=YES;
            MessageView.hidden=NO;
            CallLogView.hidden=YES;
            DTRecordView.hidden=YES;
            replyToMessageView.hidden=YES;
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                allstaffgrouparray=[MyClass returnStaffGroupArrayIncludeAll:YES];
                if (![self retrieveMessageRecord]) {
                    lastviewindex=oldlastviewindex;
                    [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
                    return;
                }
                
                [self createMessageViewNavigationButton];
                
                //[self performSelector:@selector(retrieveMessageRecord) withObject:nil afterDelay:0];
                headertitlename.text=[MyClass returntitlewithtitle:@"Messages"];
                
                //lastviewindex=sender.tag;
                ///[self.delegate updatestudentinformationlist:DetailsViewStudent.studentkey];
                

                [self highlightduebuttonwithreloadstudentlist:YES];
                ///[MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
            
            
            
        }else if (sender.tag==5) {
            lastviewindex=sender.tag;
            calllogcalledbyselected=@"All";
            [CallLogCalledBySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Callers"] forState:UIControlStateNormal];
            if (![self retrieveCallLogRecord]) {
                lastviewindex=oldlastviewindex;
                [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
                return;
            }
            
            staffArray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveStaffListwithvalid:@"All" role:@"All" flushcachedata:NO]];
            if (!staffArray) {
                return;
            }
            
            ViewStudent.hidden=YES;
            EnrollmentRecordView.hidden=YES;
            ClassRecordView.hidden=YES;
            EnrollmentClassMenuView.hidden=YES;
            SalesView.hidden=YES;
            CouponView.hidden=YES;
            MessageView.hidden=YES;
            CallLogView.hidden=NO;
            DTRecordView.hidden=YES;
            
            [self createCallLogViewNavigationButton];
            
            headertitlename.text=[MyClass returntitlewithtitle:@"Call Log"];
            
            //lastviewindex=sender.tag;
            ///[self.delegate updatestudentinformationlist:DetailsViewStudent.studentkey];
            

            [self highlightduebuttonwithreloadstudentlist:YES];
            ///[MyClass loadingindicatorwithoption:@"stop" color:nil];
            
        }else if (sender.tag==6) {
            lastviewindex=sender.tag;
            [DetailsViewClassTable removeGestureRecognizer:panGesture];
            [DetailsViewDTTable addGestureRecognizer:panGesture];
            
            DTSubjectArray=[[NSMutableArray alloc]initWithObjects:@"All Classes", nil];
            dtsubjectselected=@"All";
            dttypeselected=@"All";
            if (![self retrieveDTWithSubject:dtsubjectselected studentkey:DetailsViewStudent.studentkey classtype:dttypeselected]) {
                lastviewindex=oldlastviewindex;
                [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
                return;
            }
            
            ViewStudent.hidden=YES;
            EnrollmentRecordView.hidden=YES;
            ClassRecordView.hidden=YES;
            EnrollmentClassMenuView.hidden=YES;
            SalesView.hidden=YES;
            CouponView.hidden=YES;
            MessageView.hidden=YES;
            CallLogView.hidden=YES;
            DTRecordView.hidden=NO;
            
            [self createDTViewNavigationButton];
            
            headertitlename.text=[MyClass returntitlewithtitle:@"Trial/Assessment"];
            //lastviewindex=sender.tag;
            ///[self.delegate updatestudentinformationlist:DetailsViewStudent.studentkey];
            

            [self highlightduebuttonwithreloadstudentlist:YES];
            ///[MyClass loadingindicatorwithoption:@"stop" color:nil];
            
        }else if (sender.tag==7) {
            lastviewindex=sender.tag;
//            productcategoryselected=@"All";
            [self refreshsalestableheader];
            couponStatusSC.selectedSegmentIndex=1;
            if (![self retrieveCouponRecord]) {
                lastviewindex=oldlastviewindex;
                [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
                return;
            }
            
            ViewStudent.hidden=YES;
            EnrollmentRecordView.hidden=YES;
            ClassRecordView.hidden=YES;
            EnrollmentClassMenuView.hidden=YES;
            SalesView.hidden=YES;
            CouponView.hidden=NO;
            MessageView.hidden=YES;
            CallLogView.hidden=YES;
            DTRecordView.hidden=YES;
            
            [self createCouponViewNavigationButton];
            
            headertitlename.text=[MyClass returntitlewithtitle:@"Coupon"];
            
            //lastviewindex=sender.tag;
            ///[self.delegate updatestudentinformationlist:DetailsViewStudent.studentkey];
            

            [self highlightduebuttonwithreloadstudentlist:YES];
            ///[MyClass loadingindicatorwithoption:@"stop" color:nil];
            
        }
        

        
    });
}

- (IBAction)combinepaymentbuttonpressed:(id)sender {
    isSelectCombinePayment=!isSelectCombinePayment;
    if (lastviewindex==1) {
        [self refreshenrollmenttableheader];
        [DetailsViewEnrollmentTable reloadData];
        
    }else if (lastviewindex==3){
        [self refreshsalestableheader];
        [SalesTable reloadData];
        
    }
}



-(BOOL) retrieveCallLogRecord
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievecalllog&type=%@&typekey=%@&calledby=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,@"student",DetailsViewStudent.studentkey,@"All"];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            CallLogRecordArray=[[NSMutableArray alloc]init];
            if ([calllogcalledbyselected isEqualToString:@"All"]) {
                CallLogCalledByArray= [[NSMutableArray alloc]initWithObjects:[MyClass returntitlewithtitle:@"All Callers"], nil];
            }
            
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                NSString * ccalllogkey=[[JSONArray objectAtIndex:i] objectForKey:@"calllogkey"];
                NSString * ccalledon=[[JSONArray objectAtIndex:i] objectForKey:@"calledon"];
                NSString * ccalledby=[[JSONArray objectAtIndex:i] objectForKey:@"calledby"];
                NSString * cdetails=[[JSONArray objectAtIndex:i] objectForKey:@"details"];
                NSString * ccalledbyfullname=[MyClass returnstaffnamewithusername:ccalledby firstorfullname:@"full"];
                ccalledon=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:ccalledon];
                
                if (![CallLogCalledByArray containsObject:ccalledby]) {
                    [CallLogCalledByArray addObject:ccalledby];
                }
                
                [CallLogRecordArray addObject:[[CallLogRecord alloc]initCallLogRecordWithcalllogkey:ccalllogkey calledon:ccalledon calledby:ccalledby details:cdetails calledbyfullname:ccalledbyfullname]];
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
        
        CallLogRecordArray=[[NSMutableArray alloc]init];
        if ([calllogcalledbyselected isEqualToString:@"All"]) {
            CallLogCalledByArray= [[NSMutableArray alloc]initWithObjects:[MyClass returntitlewithtitle:@"All Callers"], nil];
        }
        
        
        //loop through our jsonArray
        for (int i=0; i<JSONArray.count; i++) {
            
            NSString * ccalllogkey=[[JSONArray objectAtIndex:i] objectForKey:@"calllogkey"];
            NSString * ccalledon=[[JSONArray objectAtIndex:i] objectForKey:@"calledon"];
            NSString * ccalledby=[[JSONArray objectAtIndex:i] objectForKey:@"calledby"];
            NSString * cdetails=[[JSONArray objectAtIndex:i] objectForKey:@"details"];
            NSString * ccalledbyfullname=[MyClass returnstaffnamewithusername:ccalledby firstorfullname:@"full"];
            ccalledon=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:ccalledon];
            
            if (![CallLogCalledByArray containsObject:ccalledby]) {
                [CallLogCalledByArray addObject:ccalledby];
            }
            
            [CallLogRecordArray addObject:[[CallLogRecord alloc]initCallLogRecordWithcalllogkey:ccalllogkey calledon:ccalledon calledby:ccalledby details:cdetails calledbyfullname:ccalledbyfullname]];
        }
        
            }
            dispatch_semaphore_signal(semaphore);
        }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
    if (result) {
        [self returnfiltercalllogarray];
        [CallLogTable reloadData];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    
    return result;
}

- (void)addEnrollment:(UIBarButtonItem *)sender
{
    
    [self showviewhistory:FALSE];
    
    //UIView *barButtonView = [sender valueForKey:@"view"];
    //CGPoint point=[barButtonView.superview convertPoint:barButtonView.frame.origin toView:nil];
    
    //aiaddenrollment.center=CGPointMake(point.x+20, point.y+15);

    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        EnrollmentPopoverViewController *enrollmentpopover = (EnrollmentPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"EnrollmentPopoverViewController"];
        enrollmentpopover.delegate=self;
        enrollmentpopover.EnrollmentTableMode=@"Add";
        //enrollmentpopover.PopoverEnrollment=[[EnrollmentRecord alloc]init];
        //enrollmentpopover.PopoverEnrollment.studentkey=DetailsViewStudent.studentkey;
        enrollmentpopover.PopoverStudent=DetailsViewStudent;
        
        enrollmentpopover.currentsubject=subjectselected;
        enrollmentpopover.leveldictionary=LevelDictionary;
        
        if (![self returnallclassremarkswithstudentkey:DetailsViewStudent.studentkey]) {
            return;
        }
        
        enrollmentpopover.AllClassRemarksArray=allclassremarksArray;
        
        enrollmentpopover.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:enrollmentpopover.view];
        [self addChildViewController:enrollmentpopover];
        [enrollmentpopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
        
    });


}

- (IBAction)addnewsales:(id)sender {
    
    [self showviewhistory:FALSE];
    photofullscreenview.hidden=YES;

    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SalesPopoverViewController *salespopover = (SalesPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"SalesPopoverViewController"];
        salespopover.delegate=self;
        salespopover.SalesTableMode=@"Add";
        //salespopover.SalesObject=[[SalesRecord alloc]init];
        //salespopover.SalesObject.studentkey=DetailsViewStudent.studentkey;
        salespopover.PopoverStudent=DetailsViewStudent;
        
        salespopover.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:salespopover.view];
        [self addChildViewController:salespopover];
        [salespopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
        
    });
}

- (IBAction)addnewcoupon:(id)sender {
    
    [self showviewhistory:FALSE];
    photofullscreenview.hidden=YES;

    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CouponPopoverViewController *couponpopover = (CouponPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"CouponPopoverViewController"];
        couponpopover.delegate=self;
        couponpopover.CouponTableMode=1;
        couponpopover.studentkeys=[[NSMutableArray alloc]initWithObjects:DetailsViewStudent.studentkey,nil];
        
        couponpopover.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:couponpopover.view];
        [self addChildViewController:couponpopover];
        [couponpopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
        
    });
}

-(void) issueCouponToStudents:(NSMutableArray *)studentkeys
{
    [self showviewhistory:FALSE];
    photofullscreenview.hidden=YES;

    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CouponPopoverViewController *couponpopover = (CouponPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"CouponPopoverViewController"];
        couponpopover.delegate=self;
        couponpopover.CouponTableMode=1;
        couponpopover.multiplestudents=YES;
        couponpopover.studentkeys=studentkeys;
//        bulkcouponstudentkeys=studentkeys;
        
        couponpopover.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:couponpopover.view];
        [self addChildViewController:couponpopover];
        [couponpopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
        
    });
}

-(void) issuePointToStudents:(NSMutableArray *)studentkeys multipleStudents:(BOOL)multiplestudents
{
    [self showviewhistory:FALSE];
    photofullscreenview.hidden=YES;

    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PointPopoverViewController *pointpopover = (PointPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"PointPopoverViewController"];
        pointpopover.delegate=self;
        pointpopover.PointTableMode=1;
        pointpopover.multiplestudents=multiplestudents;
        pointpopover.studentkeys=studentkeys;
//        bulkcouponstudentkeys=studentkeys;
        
        pointpopover.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:pointpopover.view];
        [self addChildViewController:pointpopover];
        [pointpopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
        
    });
}

-(void) editStudentPoint:(PointRecord *)pointrecord
{
    [self showviewhistory:FALSE];
    photofullscreenview.hidden=YES;

    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PointPopoverViewController *pointpopover = (PointPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"PointPopoverViewController"];
        pointpopover.delegate=self;
        pointpopover.PointTableMode=0;
        pointpopover.multiplestudents=NO;
        pointpopover.PointRecordObject=pointrecord;
//        bulkcouponstudentkeys=studentkeys;
        
        pointpopover.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:pointpopover.view];
        [self addChildViewController:pointpopover];
        [pointpopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
        
    });
}


-(IBAction)editStudent:(id)sender{
    [self showviewhistory:FALSE];
    photofullscreenview.hidden=YES;
    studentAction=@"EditStudent";
    [self seguetostudenteditview];
}


-(void) showview:(NSString *)view
{
    if ([view isEqualToString:@"systemmessage"]) {
        systemMessageView.hidden=NO;
        ViewStudent.hidden=YES;
        TopMenuView.hidden=YES;
        EnrollmentRecordView.hidden=YES;
        ClassRecordView.hidden=YES;
        SalesView.hidden=YES;
        CouponView.hidden=YES;
        MessageView.hidden=YES;
        CallLogView.hidden=YES;
        DTRecordView.hidden=YES;
    }
}

-(void) seguetostudenteditview
{
    if ([self retrieveMediaSource]) {
        //StudentEditViewController *viewcontroller=[[StudentEditViewController alloc]init];
        if ([studentAction isEqualToString:@"EditStudent"]) {
            deststudenteditviewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentEditViewController"];
            //StudentEditViewController *viewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentEditViewController"];
            deststudenteditviewcontroller.delegate=self;
            deststudenteditviewcontroller.EditViewStudent=DetailsViewStudent;
            deststudenteditviewcontroller.EditViewStudentAction=studentAction;
            deststudenteditviewcontroller.MediaArray=MediaArray;
            deststudenteditviewcontroller.SourceArray=SourceArray;
            [self.navigationController pushViewController:deststudenteditviewcontroller animated:YES];
            
        }else if ([studentAction isEqualToString:@"AddNewStudent"]){
            deststudenteditviewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentEditViewController"];
            deststudenteditviewcontroller.delegate=self;
            deststudenteditviewcontroller.EditViewStudent=DetailsViewStudent;
            deststudenteditviewcontroller.EditViewStudentAction=studentAction;
            deststudenteditviewcontroller.MediaArray=MediaArray;
            deststudenteditviewcontroller.SourceArray=SourceArray;
            [self showview:@"systemmessage"];
            [self.navigationController pushViewController:deststudenteditviewcontroller animated:YES];
        }else if ([studentAction isEqualToString:@"AddStudentAndSubject"]){
            deststudenteditviewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentEditViewController"];
            deststudenteditviewcontroller.delegate=self;
            deststudenteditviewcontroller.EditViewStudent=DetailsViewStudent;
            deststudenteditviewcontroller.EditViewStudentAction=studentAction;
            deststudenteditviewcontroller.MediaArray=MediaArray;
            deststudenteditviewcontroller.SourceArray=SourceArray;
            [self showview:@"systemmessage"];
            [self.navigationController pushViewController:deststudenteditviewcontroller animated:YES];
        }else if ([studentAction isEqualToString:@"EnrollLead"]){
            deststudenteditviewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentEditViewController"];
            //StudentEditViewController *viewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentEditViewController"];
            deststudenteditviewcontroller.delegate=self;
            
            
            ContactRecord *contactrecord=[[ContactRecord alloc]initContactRecordwithtype:@"Phone" relationship:[globalvariables.contactrelationshiparray firstObject] contact:DetailsViewLeadObject.parentcontact enableparentapp:globalvariables.centerrecord.parentappdefault primarycontact:YES parentapplastlogin:@"" enablesms:globalvariables.centerrecord.smsdefault iso_code:DetailsViewLeadObject.iso_code enablewechat:NO];
            
            if ([DetailsViewLeadObject.parentcontact isEqualToString:@""]) {
                CountryCodeRecord *local=[MyClass returnCountryCodeRecordWithLocalCountry];
                contactrecord.iso_code=local.iso_code;
                contactrecord.contact=local.country_code;
            }
            
            
            DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:@"" studentid:@"" firstname:DetailsViewLeadObject.firstname lastname:DetailsViewLeadObject.lastname othername:DetailsViewLeadObject.othername gender:DetailsViewLeadObject.gender dateofbirth:DetailsViewLeadObject.dateofbirth age:DetailsViewLeadObject.age grade:DetailsViewLeadObject.grade preferredlanguage:DetailsViewLeadObject.preferredlanguage school:DetailsViewLeadObject.school parentname:DetailsViewLeadObject.parentname phonearray:[[NSMutableArray alloc]initWithObjects:contactrecord, nil] parentemail:DetailsViewLeadObject.parentemail parentaddress:DetailsViewLeadObject.parentaddress remarks:@"" flag:@"No" status:@"" promotion:@"Yes"image:DetailsViewLeadObject.image leadkey:DetailsViewLeadObject.leadkey studentmedia:DetailsViewLeadObject.leadmedia studentsource:DetailsViewLeadObject.leadsource siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:DetailsViewLeadObject.avatar sendmessage:YES displayfullname:nil fcmemberid:@"" ddaenabled:NO ddaaccountno:@"" ddaaccountname:@"" ddadebtorreference:@"" ddalimit:@"" extrafield1:@"" parentname2:@"" validcouponcount:nil extrafield2:@"" creditamount:0];
            
            deststudenteditviewcontroller.EditViewStudent=DetailsViewStudent;
            deststudenteditviewcontroller.EditViewStudentAction=studentAction;
            deststudenteditviewcontroller.MediaArray=MediaArray;
            deststudenteditviewcontroller.SourceArray=SourceArray;
            [self.navigationController pushViewController:deststudenteditviewcontroller animated:YES];
        }else if ([studentAction isEqualToString:@"EnrollATLeadStudent"]){
            deststudenteditviewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentEditViewController"];
            //StudentEditViewController *viewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentEditViewController"];
            deststudenteditviewcontroller.delegate=self;
            
            ContactRecord *contactrecord=[[ContactRecord alloc]initContactRecordwithtype:@"Phone" relationship:[globalvariables.contactrelationshiparray firstObject] contact:DetailsViewATObject.parentcontact enableparentapp:globalvariables.centerrecord.parentappdefault primarycontact:YES parentapplastlogin:@"" enablesms:globalvariables.centerrecord.smsdefault iso_code:DetailsViewATObject.iso_code enablewechat:NO];
            
            if ([DetailsViewATObject.parentcontact isEqualToString:@""]) {
                CountryCodeRecord *local=[MyClass returnCountryCodeRecordWithLocalCountry];
                contactrecord.iso_code=local.iso_code;
                contactrecord.contact=local.country_code;
            }
            
            if ([DetailsViewATObject.type isEqualToString:@"lead"]) {
                DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:@"" studentid:@"" firstname:DetailsViewATObject.firstname lastname:DetailsViewATObject.lastname othername:DetailsViewATObject.othername gender:DetailsViewATObject.gender dateofbirth:DetailsViewATObject.dateofbirth age:DetailsViewATObject.age grade:DetailsViewATObject.grade preferredlanguage:DetailsViewATObject.preferredlanguage school:DetailsViewATObject.school parentname:DetailsViewATObject.parentname phonearray:[[NSMutableArray alloc]initWithObjects:contactrecord, nil] parentemail:DetailsViewATObject.parentemail parentaddress:DetailsViewATObject.parentaddress remarks:DetailsViewATObject.profileremarks flag:@"No" status:@"" promotion:@"Yes" image:DetailsViewATObject.image leadkey:DetailsViewATObject.leadkey studentmedia:DetailsViewATObject.media studentsource:DetailsViewATObject.source siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:@"" ddaenabled:NO ddaaccountno:@"" ddaaccountname:@"" ddadebtorreference:@"" ddalimit:@"" extrafield1:@"" parentname2:@"" validcouponcount:nil extrafield2:@"" creditamount:0];
                
                deststudenteditviewcontroller.EditViewStudent=DetailsViewStudent;
                deststudenteditviewcontroller.EditViewStudentAction=studentAction;
                deststudenteditviewcontroller.MediaArray=MediaArray;
                deststudenteditviewcontroller.SourceArray=SourceArray;
                [self.navigationController pushViewController:deststudenteditviewcontroller animated:YES];
            }
        }
    }
}



-(void) dismissEnrollmentPopoverandResetFilter:(BOOL)resetfilter
{
    if (resetfilter) {
        subjectselected=@"All";
        dayselected=@"All";
        [self retrieveEnrollmentWithStudentkey:DetailsViewStudent.studentkey];
        [ClassSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Classes"] forState:UIControlStateNormal];
        [DaySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Days"] forState:UIControlStateNormal];
        lastdayofweekindex=0;

    }else{
        [self retrieveEnrollmentWithStudentkey:DetailsViewStudent.studentkey];
    }
    
    [self.delegate updateCategoryCount];
    [self highlightduebuttonwithreloadstudentlist:YES];
    [self closesidewindow];
    
    DataChanged=TRUE;
}

-(EnrollmentRecord *) refreshstudentdetailsinformationandreturnenrollementrecord:(EnrollmentRecord *)enrollment
{
    [self retrieveEnrollmentWithStudentkey:DetailsViewStudent.studentkey];
    lastdayofweekindex=0;

    [self.delegate updateCategoryCount];
    [self highlightduebuttonwithreloadstudentlist:YES];
    DataChanged=TRUE;
    
    if(enrollment.enrollmentkey){
        EnrollmentRecord *enrollmentobj;
        for (int i=0; i<DetailsViewEnrollmentArray.count; i++) {
            enrollmentobj=[DetailsViewEnrollmentArray objectAtIndex:i];
            if([enrollmentobj.enrollmentkey isEqualToString:enrollment.enrollmentkey]){
                return enrollmentobj;
            }
        }
    }
    return nil;
}


-(void) dismissClassPopoverVC
{
    if ([classviewmode isEqualToString:@"selectedEnrollment"]) {
        [self retrieveClassWithEnrollmentkey:DetailsViewEnrollment.enrollmentkey];
    }else{
        [self retrieveClassWithEnrollmentkey:nil];
    }
    [self closesidewindow];
    
    DataChanged=TRUE;
}

-(void) createInitialViewNavigationButton
{
    /*
    UIBarButtonItem* centertitle= [[UIBarButtonItem alloc]initWithTitle:globalvariables.centerrecord.centername style:UIBarButtonItemStylePlain target:self action:nil];
    [centertitle setTintColor:[UIColor lightTextColor]];
    [centertitle setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, [UIColor lightTextColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];*/
//    self.navigationItem.leftBarButtonItem=nil;
//    self.navigationItem.rightBarButtonItem=nil;
    student_editButton.hidden=YES;
    student_goToLeadButton.hidden=YES;
    documentfolderbutton.hidden=YES;
    addEnrollmentbutton.hidden=YES;
    remainingclassbutton.hidden=YES;
    addSalesbutton.hidden=YES;
    addContactLogbutton.hidden=YES;
    addDTbutton.hidden=YES;
    addCouponbutton.hidden=YES;
}

-(void) createEnrollmentViewNavigationButton
{
//    addEnrollmentbutton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEnrollment:)];
//    self.navigationItem.rightBarButtonItem = addEnrollmentbutton;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:documentfolderbutton];
//    
//    if ([studentAction isEqualToString:@"PopoverStudent"]) {
//        self.navigationItem.leftBarButtonItem.enabled=FALSE;
//    }
    
    student_editButton.hidden=YES;
    student_goToLeadButton.hidden=YES;
    documentfolderbutton.hidden=NO;
    addEnrollmentbutton.hidden=NO;
    remainingclassbutton.hidden=YES;
    addSalesbutton.hidden=YES;
    addContactLogbutton.hidden=YES;
    addDTbutton.hidden=YES;
    addCouponbutton.hidden=YES;
    
    
    [self refreshdocumentfoldercount];
    //[self.navigationController.navigationBar bringSubviewToFront:documentfoldercountlabel];
    
}

-(void) createStudentViewNavigationButton
{
//    UIButton *ebutton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [ebutton setTitle:@"Edit" forState:UIControlStateNormal];
//    [ebutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    ebutton.frame = CGRectMake(0, 0, 80, 30); // Adjust size
//  
//    UIBarButtonItem *editbutton = [[UIBarButtonItem alloc] initWithCustomView:ebutton];
//    
////    UIBarButtonItem* editbutton= [[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editStudent:)];
//    self.navigationItem.rightBarButtonItem=editbutton;
    
    student_editButton.hidden=NO;
    student_goToLeadButton.hidden=[DetailsViewStudent.leadkey isEqualToString:@""];
    documentfolderbutton.hidden=YES;
    addEnrollmentbutton.hidden=YES;
    remainingclassbutton.hidden=YES;
    addSalesbutton.hidden=YES;
    addContactLogbutton.hidden=YES;
    addDTbutton.hidden=YES;
    addCouponbutton.hidden=YES;
    
//    UIBarButtonItem* leadprofilebutton= [[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Go to Lead Profile"] style:UIBarButtonItemStylePlain target:self action:@selector(gotoleadprofile:)];
//    [leadprofilebutton setTintColor:[UIColor lightTextColor]];
//    [leadprofilebutton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem=![DetailsViewStudent.leadkey isEqualToString:@""]?leadprofilebutton:nil;
    //documentfoldercountlabel.hidden=YES;
    
}


-(void) createClassViewNavigationButton
{
//    remainingclassbutton= [[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Class Summary"] style:UIBarButtonItemStylePlain target:self action:@selector(remainingclasssummary:)];
////    self.navigationItem.rightBarButtonItem=remainingclassbutton;
////    self.navigationItem.leftBarButtonItem = nil;

    student_editButton.hidden=YES;
    student_goToLeadButton.hidden=YES;
    documentfolderbutton.hidden=YES;
    addEnrollmentbutton.hidden=YES;
    remainingclassbutton.hidden=NO;
    addSalesbutton.hidden=YES;
    addContactLogbutton.hidden=YES;
    addDTbutton.hidden=YES;
    addCouponbutton.hidden=YES;
    
}

-(void) createMessageViewNavigationButton
{
//    self.navigationItem.rightBarButtonItem = nil;
//    UIBarButtonItem* centertitle= [[UIBarButtonItem alloc]initWithTitle:globalvariables.centerrecord.centername style:UIBarButtonItemStylePlain target:self action:nil];
//    [centertitle setTintColor:[UIColor lightTextColor]];
//    [centertitle setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, [UIColor lightTextColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem=nil;//centertitle;
//    //documentfoldercountlabel.hidden=YES;
    
    student_editButton.hidden=YES;
    student_goToLeadButton.hidden=YES;
    documentfolderbutton.hidden=YES;
    addEnrollmentbutton.hidden=YES;
    remainingclassbutton.hidden=YES;
    addSalesbutton.hidden=YES;
    addContactLogbutton.hidden=YES;
    addDTbutton.hidden=YES;
    addCouponbutton.hidden=YES;
    
}

-(void) createSalesViewNavigationButton
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addnewsales:)];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:documentfolderbutton];
    [self refreshdocumentfoldercount];
//    //[self.navigationController.navigationBar bringSubviewToFront:documentfoldercountlabel];
//    
//    if ([studentAction isEqualToString:@"PopoverStudent"]) {
//        self.navigationItem.leftBarButtonItem.enabled=FALSE;
//    }
    student_editButton.hidden=YES;
    student_goToLeadButton.hidden=YES;
    documentfolderbutton.hidden=NO;
    addEnrollmentbutton.hidden=YES;
    remainingclassbutton.hidden=YES;
    addSalesbutton.hidden=NO;
    addContactLogbutton.hidden=YES;
    addDTbutton.hidden=YES;
    addCouponbutton.hidden=YES;
}

-(void) createCouponViewNavigationButton
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addnewcoupon:)];
//    self.navigationItem.rightBarButtonItem.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).issuecoupon;
//    self.navigationItem.leftBarButtonItem = nil;
    student_editButton.hidden=YES;
    student_goToLeadButton.hidden=YES;
    documentfolderbutton.hidden=YES;
    addEnrollmentbutton.hidden=YES;
    remainingclassbutton.hidden=YES;
    addSalesbutton.hidden=YES;
    addContactLogbutton.hidden=YES;
    addDTbutton.hidden=YES;
    addCouponbutton.hidden=NO;
}

-(void) createCallLogViewNavigationButton
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addnewcalllog:)];
//    UIBarButtonItem* centertitle= [[UIBarButtonItem alloc]initWithTitle:globalvariables.centerrecord.centername style:UIBarButtonItemStylePlain target:self action:nil];
//    [centertitle setTintColor:[UIColor lightTextColor]];
//    [centertitle setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, [UIColor lightTextColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem=nil;//centertitle;
//    //documentfoldercountlabel.hidden=YES;
    student_editButton.hidden=YES;
    student_goToLeadButton.hidden=YES;
    documentfolderbutton.hidden=YES;
    addEnrollmentbutton.hidden=YES;
    remainingclassbutton.hidden=YES;
    addSalesbutton.hidden=YES;
    addContactLogbutton.hidden=NO;
    addDTbutton.hidden=YES;
    addCouponbutton.hidden=YES;
}

-(void) createDTViewNavigationButton
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addnewdt:)];
//    UIBarButtonItem* centertitle= [[UIBarButtonItem alloc]initWithTitle:globalvariables.centerrecord.centername style:UIBarButtonItemStylePlain target:self action:nil];
//    [centertitle setTintColor:[UIColor lightTextColor]];
//    [centertitle setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, [UIColor lightTextColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem=nil;//centertitle;
    student_editButton.hidden=YES;
    student_goToLeadButton.hidden=YES;
    documentfolderbutton.hidden=YES;
    addEnrollmentbutton.hidden=YES;
    remainingclassbutton.hidden=YES;
    addSalesbutton.hidden=YES;
    addContactLogbutton.hidden=YES;
    addDTbutton.hidden=NO;
    addCouponbutton.hidden=YES;
}

-(BOOL) retrieveClassSummary
{
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrieveclasssummaryrecord&studentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, DetailsViewStudent.studentkey];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDate *date;
            result = TRUE;
            
                NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
                JSONArray = jsonreturned[@"content"];
                
                //Set up our class array
                ClassSummaryRecordArray=[[NSMutableArray alloc] init];
                
                //loop through our jsonArray
                for (int i=0; i<JSONArray.count; i++) {
                    
                    //Create our ClassRecord object
                    NSString * csubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                    NSString *cnextclass;
                    NSString *clastscheduledclass;
                    
                    if (![[[JSONArray objectAtIndex:i] objectForKey:@"nextclass"] isEqualToString:@"NA"]) {
                        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
                        date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"nextclass"]];
                        [df setDateFormat:@"dd-MMM HH:mm"];
                        cnextclass = [df stringFromDate:date];
                    }else{
                        cnextclass=@"-";
                    }
                    
                    if (![[[JSONArray objectAtIndex:i] objectForKey:@"lastclass"] isEqualToString:@""] && ![[[JSONArray objectAtIndex:i] objectForKey:@"lastclass"] isEqualToString:@"NA"]) {
                        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
                        date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"lastclass"]];
                        [df setDateFormat:@"dd-MMM HH:mm"];
                        clastscheduledclass = [df stringFromDate:date];
                    }else{
                        clastscheduledclass=@"-";
                    }
                    
                    NSString * cremainingclassscheduled=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassscheduled"];
                    NSString * cremainingclassTBDclass=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassTBDclass"];
                    NSString * cremainingclassTBDmakeup=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassTBDmakeup"];
                    NSString * coutstandingpayment=[NSString stringWithFormat:@"%g",[[[JSONArray objectAtIndex:i] objectForKey:@"outstandingpayment"] floatValue]];
                    NSString * cschedulekey=[[JSONArray objectAtIndex:i] objectForKey:@"schedulekey"];
                    NSString * cautorenew=[[JSONArray objectAtIndex:i] objectForKey:@"autorenew"];
                    NSString * coutstandingextendtime=[[JSONArray objectAtIndex:i] objectForKey:@"outstandingextendtime"];
                    
                    //Add the class record object to our array
                    [ClassSummaryRecordArray addObject:[[ClassSummaryRecord alloc]initClassSummaryRecordWithSubject:csubject NextClass:cnextclass lastscheduledclass:clastscheduledclass remainingclassscheduled:cremainingclassscheduled remainingclassTBDclass:cremainingclassTBDclass remainingclassTBDmakeup:cremainingclassTBDmakeup outstandingpayment:coutstandingpayment schedulekey:cschedulekey autorenew:cautorenew outstandingextendtime:coutstandingextendtime]];
                }
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        NSDate *date;
        if (!error) {
            result = TRUE;
        
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            ClassSummaryRecordArray=[[NSMutableArray alloc] init];
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our ClassRecord object
                NSString * csubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString *cnextclass;
                NSString *clastscheduledclass;
                
                if (![[[JSONArray objectAtIndex:i] objectForKey:@"nextclass"] isEqualToString:@"NA"]) {
                    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
                    date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"nextclass"]];
                    [df setDateFormat:@"dd-MMM HH:mm"];
                    cnextclass = [df stringFromDate:date];
                }else{
                    cnextclass=@"-";
                }
                
                if (![[[JSONArray objectAtIndex:i] objectForKey:@"lastclass"] isEqualToString:@""] && ![[[JSONArray objectAtIndex:i] objectForKey:@"lastclass"] isEqualToString:@"NA"]) {
                    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
                    date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"lastclass"]];
                    [df setDateFormat:@"dd-MMM HH:mm"];
                    clastscheduledclass = [df stringFromDate:date];
                }else{
                    clastscheduledclass=@"-";
                }
                
                NSString * cremainingclassscheduled=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassscheduled"];
                NSString * cremainingclassTBDclass=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassTBDclass"];
                NSString * cremainingclassTBDmakeup=[[JSONArray objectAtIndex:i] objectForKey:@"remainingclassTBDmakeup"];
                NSString * coutstandingpayment=[NSString stringWithFormat:@"%g",[[[JSONArray objectAtIndex:i] objectForKey:@"outstandingpayment"] floatValue]];
                NSString * cschedulekey=[[JSONArray objectAtIndex:i] objectForKey:@"schedulekey"];
                NSString * cautorenew=[[JSONArray objectAtIndex:i] objectForKey:@"autorenew"];
                NSString * coutstandingextendtime=[[JSONArray objectAtIndex:i] objectForKey:@"outstandingextendtime"];
                
                //Add the class record object to our array
                [ClassSummaryRecordArray addObject:[[ClassSummaryRecord alloc]initClassSummaryRecordWithSubject:csubject NextClass:cnextclass lastscheduledclass:clastscheduledclass remainingclassscheduled:cremainingclassscheduled remainingclassTBDclass:cremainingclassTBDclass remainingclassTBDmakeup:cremainingclassTBDmakeup outstandingpayment:coutstandingpayment schedulekey:cschedulekey autorenew:cautorenew outstandingextendtime:coutstandingextendtime]];
            }
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    if (!result) {
        [MyClass showconnectionlostdialogbox];
    }*/
    return result;
}


-(IBAction) remainingclasssummary:(id)sender
{
    [self showviewhistory:FALSE];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(![self retrieveClassSummary]){
            return;
        }
        
        int tablewidth=600;
        
        RemainingClassSummaryTable=[[UITableView alloc]init];
        RemainingClassSummaryTable.delegate=self;
        RemainingClassSummaryTable.dataSource=self;
        [RemainingClassSummaryTable reloadData];
        
        
        //add toolbar
//        UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, tablewidth, 44)];
//        toolbar.barStyle=UIBarStyleDefault;
//        NSMutableArray *barItems=[[NSMutableArray alloc]init];
//        
//        UIBarButtonItem *flexSpace=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        UIBarButtonItem *donebutton=[[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Done"] style:UIBarButtonItemStylePlain target:self action:@selector(doneclasssummary:)];
//        barItems = [[NSMutableArray alloc]initWithObjects:flexSpace,donebutton, nil];
//        
//        [toolbar setItems:barItems];
        
        UIButton *donebutton;
        donebutton = [UIButton buttonWithType:UIButtonTypeSystem];
        donebutton.frame = CGRectMake(20, 15, 100, 20);
        [donebutton setTitle:[MyClass returntitlewithtitle:@"Done"] forState:UIControlStateNormal];
        [donebutton addTarget:self action:@selector(doneclasssummary:) forControlEvents:UIControlEventTouchUpInside];
        [donebutton sizeToFit];
        donebutton.frame = CGRectMake(16, 15, donebutton.frame.size.width, 20);
        
        
        //add header
        UIView *classsummaryheader=[[UIView alloc]initWithFrame:CGRectMake(0, 44, tablewidth, globalvariables.centerrecord.enableattendanceextend?44:22)];
        classsummaryheader.backgroundColor=[UIColor grayColor];
        
        UILabel *headerlabel=[[UILabel alloc]initWithFrame:CGRectMake(15, 0, 120, 22)];
        headerlabel.textColor=[UIColor whiteColor];
        headerlabel.font=[UIFont boldSystemFontOfSize:13];
        headerlabel.text=[MyClass returntitlewithtitle:@"Subject"];
        [classsummaryheader addSubview:headerlabel];
        
        headerlabel=[[UILabel alloc]initWithFrame:CGRectMake(95, 0, 100, 22)];
        headerlabel.textColor=[UIColor whiteColor];
        headerlabel.font=[UIFont boldSystemFontOfSize:13];
        headerlabel.text=[MyClass returntitlewithtitle:@"Next Class"];
        [classsummaryheader addSubview:headerlabel];
        
        headerlabel=[[UILabel alloc]initWithFrame:CGRectMake(205, 0, 100, 22)];
        headerlabel.textColor=[UIColor whiteColor];
        headerlabel.font=[UIFont boldSystemFontOfSize:13];
        headerlabel.text=[MyClass returntitlewithtitle:@"Last Class"];
        [classsummaryheader addSubview:headerlabel];
        
        headerlabel=[[UILabel alloc]initWithFrame:CGRectMake(310, 0, 180, 22)];
        headerlabel.textColor=[UIColor whiteColor];
        headerlabel.font=[UIFont boldSystemFontOfSize:13];
        headerlabel.text=[MyClass returntitlewithtitle:@"Sch./TBD.Cl/TBD.MU Left"];
        [classsummaryheader addSubview:headerlabel];

        if (globalvariables.centerrecord.enableattendanceextend) {
            headerlabel=[[UILabel alloc]initWithFrame:CGRectMake(310, 22, 180, 22)];
            headerlabel.textColor=[UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:1.0];
            headerlabel.font=[UIFont boldSystemFontOfSize:13];
            headerlabel.text=[MyClass returntitlewithtitle:@"Outstanding Extension Time"];
            [classsummaryheader addSubview:headerlabel];
        }

        
        headerlabel=[[UILabel alloc]initWithFrame:CGRectMake(470, 0, 100, 22)];
        headerlabel.textColor=[UIColor whiteColor];
        headerlabel.font=[UIFont boldSystemFontOfSize:13];
        headerlabel.text=[MyClass returntitlewithtitle:@"Outstanding"];
        headerlabel.textAlignment=NSTextAlignmentRight;
        [classsummaryheader addSubview:headerlabel];
        
        RemainingClassSummaryTable.frame=CGRectMake(0, 44+classsummaryheader.frame.size.height, tablewidth, RemainingClassSummaryTable.contentSize.height);
        
        
        //[self.view addSubview:RemainingClassSummaryTable];
        
        //add popover controller
        UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
//        [viewcontroller.view addSubview:toolbar];
        [viewcontroller.view addSubview:classsummaryheader];
        [viewcontroller.view addSubview:RemainingClassSummaryTable];
        [viewcontroller.view addSubview:donebutton];
        
        viewcontroller.preferredContentSize=CGSizeMake(tablewidth, RemainingClassSummaryTable.contentSize.height+44+classsummaryheader.frame.size.height);
        viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
        myClassSummaryPopoverController=viewcontroller.popoverPresentationController;
        myClassSummaryPopoverController.delegate=self;
        myClassSummaryPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
        myClassSummaryPopoverController.barButtonItem=[[UIBarButtonItem alloc]initWithCustomView:remainingclassbutton] ;
        
        [self presentViewController:viewcontroller animated:YES completion:nil];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });

}

-(void) doneclasssummary:(id)sender
{
    [[myClassSummaryPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) deleteStudent:(NSString *)studentkey
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletestudent&studentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DetailsViewStudent.studentkey];
    
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
        ViewStudent.hidden=YES;
        TopMenuView.hidden=YES;
        systemMessageLabel.text=[MyClass returntitlewithtitle:@"Select student or press + to add new"];
        [MyClass removeViewHistoryWithType:@"student" Typekey:studentkey];
        [self showviewhistory:YES];
        systemMessageView.hidden=NO;
        studentAction=nil;
        
        [self.delegate gobackStudentCategory];
        [self createInitialViewNavigationButton];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    
}

-(void) addNewSiblingStudent
{
    //[self.delegate gobackStudentCategory];
    [self.delegate disableAddStudentButton];
}

/*
-(void) gotostudentprofile
{
    [self.delegate gotostudentprofile:DetailsViewStudent.studentkey];
}*/


-(void) updateStudentCategoryCount
{
    [self.delegate updateCategoryCount];
}

-(void) updatestudentinformationlist:(NSString *)studentkey reloadlist:(BOOL)reload
{
    [self.delegate updatestudentinformationlist:studentkey reloadlist:reload];
}

-(void) refreshStudentView:(NSString *)studentkey
{
    ViewStudent.hidden=NO;
    TopMenuView.hidden=NO;
    EnrollmentClassMenuView.hidden=YES;
    EnrollmentRecordView.hidden=YES;
    ClassRecordView.hidden=YES;
    SalesView.hidden=YES;
    MessageView.hidden=YES;
    CallLogView.hidden=YES;
    DTRecordView.hidden=YES;
    CouponView.hidden=YES;
    
    systemMessageLabel.text=@"";
    systemMessageView.hidden=YES;
    [self retrieveStudent:studentkey];
    subjectselected=@"All";
    //DetailsViewStudentkey=studentkey;
    lastviewindex=0;
    [self highlighttableoptionbuttonwithbuttontag:0];
    headertitlename.text=[MyClass returntitlewithtitle:@"Student Profile"];

    
//    self.navigationItem.title=nil;
    [self createStudentViewNavigationButton];
}

-(void) dismisspopover
{
    [self closesidewindow];
    //[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    if ([classviewmode isEqualToString:@"selectedEnrollment"]) {
        [self retrieveClassWithEnrollmentkey:DetailsViewEnrollment.enrollmentkey];
    }else{
        [self retrieveClassWithEnrollmentkey:nil];
    }
    
    DataChanged=TRUE;
    
    
}

-(void)dismissmakeuppopoverduetoconnectionerror
{
    [self closesidewindow];
    //[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


-(BOOL)shouldAutorotate {
    return NO;
}



-(BOOL) returnallclassremarkswithstudentkey:(NSString *)studentkey
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=returnallclassremarks&studentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,studentkey];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            allclassremarksArray=[[NSMutableArray alloc]init];
            
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our ClassRecord object
                NSString * csubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString * callclassremarks=[[JSONArray objectAtIndex:i] objectForKey:@"allclassremarks"];
                
                //Add the class record object to our array
                [allclassremarksArray addObject:[[AllClassRemarksRecord alloc]initMaxLevelRecordwithSubject:csubject AllClassRemarks:callclassremarks]];
            }
        }
    }];
    
    /*
    NSURL * url = [NSURL URLWithString:strURL];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    if (data) {
        
        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
        JSONArray = jsonreturned[@"content"];
        
        allclassremarksArray=[[NSMutableArray alloc]init];
        
        for (int i=0; i<JSONArray.count; i++) {
            
            //Create our ClassRecord object
            NSString * csubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
            NSString * callclassremarks=[[JSONArray objectAtIndex:i] objectForKey:@"allclassremarks"];
            
            //Add the class record object to our array
            [allclassremarksArray addObject:[[AllClassRemarksRecord alloc]initMaxLevelRecordwithSubject:csubject AllClassRemarks:callclassremarks]];
        }
        return YES;
    }else{
        
        [MyClass showconnectionlostdialogbox];
        return NO;
        
    }*/
    
    return result;
    
}

-(void) popoverenrollmentwindow
{
    

    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        EnrollmentPopoverViewController *enrollmentpopover = (EnrollmentPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"EnrollmentPopoverViewController"];
        enrollmentpopover.delegate=self;
        enrollmentpopover.EnrollmentTableMode=@"Add";
        enrollmentpopover.PopoverEnrollment.studentkey=DetailsViewStudent.studentkey;
        enrollmentpopover.PopoverStudent=DetailsViewStudent;
        enrollmentpopover.currentsubject=DetailsViewATObject.subject;
        enrollmentpopover.dtkey=DetailsViewATObject.DTkey;
        enrollmentpopover.leveldictionary=LevelDictionary;
        
        if ([self returnallclassremarkswithstudentkey:DetailsViewStudent.studentkey]) {
            enrollmentpopover.AllClassRemarksArray=allclassremarksArray;
            
            enrollmentpopover.view.frame=self->mainWindow.bounds;
            [self->sidewindowview addSubview:enrollmentpopover.view];
            [self addChildViewController:enrollmentpopover];
            [enrollmentpopover didMoveToParentViewController:self];
        }
        

        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
    

}

-(void) popoverenrollmentwindowforjoinstudent
{
    

    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        EnrollmentPopoverViewController *enrollmentpopover = (EnrollmentPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"EnrollmentPopoverViewController"];
        enrollmentpopover.delegate=self;
        enrollmentpopover.EnrollmentTableMode=@"Join";
        
        EnrollmentRecord *enrollment=[[EnrollmentRecord alloc]init];
        enrollment.studentkey=DetailsViewStudent.studentkey;
        enrollment.subject=DetailsViewClassScheduleObject.subject;
        enrollment.startdate=DetailsViewClassScheduleObject.startdate;
        enrollment.classtime=DetailsViewClassScheduleObject.classtime;
        enrollment.instructor=DetailsViewClassScheduleObject.instructor;
        enrollment.sinstructor=DetailsViewClassScheduleObject.sinstructor;
        enrollment.classroom=DetailsViewClassScheduleObject.classroom;
        enrollment.schedulekey=DetailsViewClassScheduleObject.schedulekey;
        enrollment.levelmain=DetailsViewClassScheduleObject.levelmain;
        enrollment.levelctm=DetailsViewClassScheduleObject.levelctm;
        enrollment.remarks=DetailsViewClassScheduleObject.lesson;
        
        enrollmentpopover.PopoverEnrollment=enrollment;
        enrollmentpopover.PopoverStudent=[MyClass returnstudentwithstudentkey:DetailsViewStudent.studentkey];
        enrollmentpopover.currentsubject=DetailsViewClassScheduleObject.subject;
        
//        if ([self returnallclassremarkswithstudentkey:DetailsViewStudent.studentkey]) {
//            enrollmentpopover.AllClassRemarksArray=allclassremarksArray;
            
            enrollmentpopover.view.frame=self->mainWindow.bounds;
            [self->sidewindowview addSubview:enrollmentpopover.view];
            [self addChildViewController:enrollmentpopover];
            [enrollmentpopover didMoveToParentViewController:self];
//        }
        

        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
    

}



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
}


/*
- (void)addnewmessage:(UIBarButtonItem *)sender {
    
    [self showviewhistory:FALSE];
    //popup class view record
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    MessagePopoverViewController *messagepopover = (MessagePopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MessagePopoverViewController"];
    messagepopover.delegate=self;
    messagepopover.MessageTableMode=@"Add";
    messagepopover.CallingSource=@"StudentView";
    
    
    if (![messagepopover InitializeField]) {
        return;
    }
    
    messagepopover.CallingKey=DetailsViewStudent.studentkey;
    //messagepopover.CallingName=[self returnstudentnamewithfirstname:DetailsViewStudent.firstname lastname:DetailsViewStudent.lastname];
    myPopoverController =[[UIPopoverController alloc]initWithContentViewController:messagepopover];
    [myPopoverController setDelegate:self];
    [myPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    
}


-(void) copyMessage
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    //popup class view record
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    MessagePopoverViewController *messagepopover = (MessagePopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MessagePopoverViewController"];
    //messagepopover.delegate=self;
    messagepopover.MessageTableMode=@"Copy";
    messagepopover.CallingSource=@"StudentView";
    
    messagepopover.MessageRecordObject=messagerecordobject;
    myPopoverController =[[UIPopoverController alloc]initWithContentViewController:messagepopover];
    [myPopoverController setDelegate:self];
    
    [myPopoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:NO];
}


-(void) dismissMessagePopoverVC
{
    [myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self performSelector:@selector(retrieveMessageRecord) withObject:nil afterDelay:0];
}*/

- (IBAction)cancelSelectButtonPressed:(id)sender {
    [selectedinboxmessages removeAllObjects];
    selectMode=nil;
    [DetailsViewMessageTable reloadData];
    selectStatusView.hidden=YES;
    forwardMessageButton.hidden=YES;
    deleteMessageButton.hidden=YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView== DetailsViewMessageTable) {
        return UITableViewAutomaticDimension;

    }else if (tableView==CallLogTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==RemainingClassSummaryTable){
        return 55;
    }else if (tableView==SiblingTable){
        return 44;
    }else if (tableView==ViewHistoryTable){
        return 44;
    }else if (tableView==DetailsViewEnrollmentTable){
        return  UITableViewAutomaticDimension;
    }else if (tableView==DetailsViewClassTable){
        return  UITableViewAutomaticDimension;
    }else if (tableView==SalesTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==couponTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==DetailsViewDTTable){
        return UITableViewAutomaticDimension;
    }else{
        return 38;
    }
}


-(BOOL) retrieveMessageRecord
{
    selectMode=nil;
    selectedinboxmessages=[[NSMutableArray alloc]init];
    selectedoutboxmessages=[[NSMutableArray alloc]init];
    selectStatusView.hidden=YES;
    forwardMessageButton.hidden=YES;
    deleteMessageButton.hidden=YES;
    
    [self stopAudioPlaying];
    [self updateinstantmessagetopbox];
    InboxMessageRecord *messageobject;
    
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievemessagelist2&username=%@&apptype=center&messagecontact=%@&messagecontacttype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,globalvariables.username,DetailsViewStudent.studentkey,@"Student"];
    
    __block BOOL result=FALSE;
    __block NSArray *JSONArray;
    
    [self replyToMessageCancelButtonPressed:nil];

    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
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
            
        }else{
            [MyClass showconnectionlostdialogbox];
        }
        
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    if (result) {
        messageArray=[[NSMutableArray alloc]init];
        replyToMessageDict=[[NSMutableDictionary alloc]init];
        //loop through our jsonArray
        firstunreadrow=-1;
        unreadcount=0;
        
        for (int i=0; i<JSONArray.count; i++) {
            
            NSString * csender=[[JSONArray objectAtIndex:i] objectForKey:@"sender"];
            NSString * cassociateid=[[JSONArray objectAtIndex:i] objectForKey:@"associateid"];
            NSString * cmessagestarttime=[[JSONArray objectAtIndex:i] objectForKey:@"messagestarttime"];
            NSString * cinboxmessagekey=[[JSONArray objectAtIndex:i] objectForKey:@"inboxmessagekey"];
            NSString * coutboxmessagekey=[[JSONArray objectAtIndex:i] objectForKey:@"outboxmessagekey"];
            NSString * creplytomessagekey=[[JSONArray objectAtIndex:i] objectForKey:@"replytomessagekey"];
            NSString * cmessagetype=[[JSONArray objectAtIndex:i] objectForKey:@"messagetype"];
            NSString * cmessageenglish=[[JSONArray objectAtIndex:i] objectForKey:@"messageenglish"];
            NSString * cmessagechinese=[[JSONArray objectAtIndex:i] objectForKey:@"messagechinese"];
            NSString * cstatus=[[JSONArray objectAtIndex:i] objectForKey:@"status"];
            NSString * creadtime=[[JSONArray objectAtIndex:i] objectForKey:@"readtime"];
            NSString * cchannel=[[JSONArray objectAtIndex:i] objectForKey:@"channel"];
            //NSString * crecipientname=[MyClass returnStudentnameWithStudentkey:cassociateid option:@"full"];
            NSArray * cphotoarray=[[JSONArray objectAtIndex:i] objectForKey:@"photoarray"];
            NSArray * creadstatusdetailsarray=[[JSONArray objectAtIndex:i] objectForKey:@"readstatusdetailsarray"];
            NSString * cautomessageflag=[[JSONArray objectAtIndex:i] objectForKey:@"automessageflag"];
            NSString * crecipient=[[JSONArray objectAtIndex:i] objectForKey:@"recipient"];
            NSString * crecipienttype=[[JSONArray objectAtIndex:i] objectForKey:@"recipienttype"];
            NSString * ctype=[[JSONArray objectAtIndex:i] objectForKey:@"type"];
            NSString * creadstatus=[[JSONArray objectAtIndex:i] objectForKey:@"readstatus"];
            
            
            NSMutableArray *tmpphotoarray=[[NSMutableArray alloc]init];
            for (int p=0; p<cphotoarray.count; p++) {
                NSString *filename=[[cphotoarray objectAtIndex:p] objectForKey:@"filename"];
                int width=[[[cphotoarray objectAtIndex:p] objectForKey:@"width"] floatValue];
                int height=[[[cphotoarray objectAtIndex:p] objectForKey:@"height"] floatValue];
                NSString *filetype=[[cphotoarray objectAtIndex:p] objectForKey:@"filetype"];
                NSString *thumbnailurl=[[cphotoarray objectAtIndex:p] objectForKey:@"thumbnailurl"];
                NSString *fileurl=[[cphotoarray objectAtIndex:p] objectForKey:@"fileurl"];
                
                if (width==0 || height ==0) {
                    width=self.view.frame.size.width;
                    height=maxphotoheight;
                }
                
                //NSString *type=[MyClass returnMessagePhotoRecordTypeWithURL:imagename];
                //NSString *filename=[MyClass getLocalFileNameWithFullFileName:imagename];
                
                [tmpphotoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:fileurl ImageView:nil Width:width Height:height FileType:filetype InternalURL:nil FileName:filename ThumbnailURL:thumbnailurl]];
            }
            
            NSMutableArray *tmpreadstatusdetailsarray=[[NSMutableArray alloc]init];
            for (int p=0; p<creadstatusdetailsarray.count; p++) {
                
                NSString *ccontact=[[creadstatusdetailsarray objectAtIndex:p] objectForKey:@"contact"];
                NSString *crelationship=[[creadstatusdetailsarray objectAtIndex:p] objectForKey:@"relationship"];
                NSString *creadtime=[[creadstatusdetailsarray objectAtIndex:p] objectForKey:@"readtime"];
                NSString *cchannel=[[creadstatusdetailsarray objectAtIndex:p] objectForKey:@"channel"];
                NSString *ciso_code=[[creadstatusdetailsarray objectAtIndex:p] objectForKey:@"iso_code"];
                NSString *crecipientname=@"";
                if ([crecipienttype isEqualToString:@"Staff"]) {
                    crecipientname=[MyClass returnstaffnamewithusername:ccontact firstorfullname:@"full"];
                }else if([crecipienttype isEqualToString:@"Lead"]){
                    crecipientname=crelationship;
                }
                
                [tmpreadstatusdetailsarray addObject:[[ReadStatusRecord alloc]initReadStatusRecordwithRecipientName:crecipientname RecipientID:nil Channel:cchannel ReadTime:creadtime Image:nil Gender:nil Centerkey:nil Recipientkey:ccontact Contactgroup:nil Relationship:crelationship iso_code:ciso_code]];
            }
            
            messageobject=[[InboxMessageRecord alloc]initInboxMessageRecordwithInboxMessagekey:cinboxmessagekey Messagetype:cmessagetype MessageEnglish:cmessageenglish MessageChinese:cmessagechinese MessageCreateTime:nil MessageStartTime:cmessagestarttime AutoMessageFlag:cautomessageflag Channel:cchannel ReciptientType:crecipienttype Status:cstatus Sender:csender AssociateID:cassociateid Readtime:creadtime photoarray:tmpphotoarray recipient:crecipient outboxmessagekey:coutboxmessagekey type:ctype readstatus:creadstatus readstatusdetailsarray:tmpreadstatusdetailsarray replytomessagekey:creplytomessagekey];
            
            
            [messageArray addObject:messageobject];
            if([creplytomessagekey integerValue]!=0){
                [replyToMessageDict setValue:@"" forKey:creplytomessagekey];
            }
            
            if([replyToMessageDict valueForKey:coutboxmessagekey]){
                [replyToMessageDict setValue:messageobject forKey:coutboxmessagekey];
            }
            
        }
        [self returnfilteredMessageArray];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }
    return YES;
}


-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 50;
}




-(void) drawpointerwithoption:(NSString *)option imageview:(UIImageView *)imageview
{
    if ([option isEqualToString:@"open"]) {
        [imageview setImage:[UIImage imageNamed:@"uparrow_white.png"]];
    }else{
        [imageview setImage:[UIImage imageNamed:@"downarrow_white.png"]];
    }
}

//-(void) drawpointerwithoption:(NSString *)option button:(UIButton *)button
//{
//
//    for (CALayer *layer in button.layer.sublayers) {
//        if ([layer isKindOfClass:[CAShapeLayer class]]) {
//            [layer removeFromSuperlayer];
//        }
//    }
//    
//    CGFloat xposition;
//    CGFloat yposition;
//    
//    CGFloat width;
//    CGFloat height;
//    
//    CGFloat offset;
//    
//    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//    if (orientation==UIDeviceOrientationPortrait) {
//        offset=23;
//        width=12;
//        height=4.8;
//    }else{
//        offset=30;
//        width=15;
//        height=6;
//    }
//    
//    CAShapeLayer *cashapelayer = [CAShapeLayer layer];
//    
//    if ([option isEqualToString:@"closed"]) {
//        
//        [button layoutIfNeeded];
//        
//        yposition=12;
//        xposition=button.frame.size.width-offset;
//        
//        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathMoveToPoint(path,NULL,xposition,yposition);
//        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
//        CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
//        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
//        CGPathAddLineToPoint(path, NULL, xposition, yposition);
//        
//        [cashapelayer setPath:path];
//        cashapelayer.strokeColor = [UIColor whiteColor].CGColor;
//        cashapelayer.lineWidth = 1.0f;
//        [[button layer] addSublayer:cashapelayer];
//        
//        CGPathRelease(path);
//    }else{
//        yposition=12+height;
//        xposition=button.frame.size.width-offset;
//        
//        CGMutablePathRef path = CGPathCreateMutable();
//        CGPathMoveToPoint(path,NULL,xposition,yposition);
//        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
//        CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
//        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
//        CGPathAddLineToPoint(path, NULL, xposition, yposition);
//        
//        [cashapelayer setPath:path];
//        cashapelayer.strokeColor = [UIColor whiteColor].CGColor;
//        cashapelayer.lineWidth = 1.0f;
//        [[button layer] addSublayer:cashapelayer];
//        
//        CGPathRelease(path);
//    }
//    
//    
//}

-(void) createsalesviewtableheader
{
    //salessearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(2, 76, SalesView.frame.size.width-38, 38)];
    
    
    /*UIView *background=[[UIView alloc]initWithFrame:CGRectMake(2, 35, SalesView.frame.size.width, 38)];
    background.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [SalesView addSubview:background];*/
    
    /*combinepaymentbutton=[[UIButton alloc]initWithFrame:CGRectMake(background.frame.size.width-38, 0,38 , 38)];
    [combinepaymentbutton setImageEdgeInsets:UIEdgeInsetsMake(4, 4, 4, 4)];
    combinepaymentbutton.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    [combinepaymentbutton setImage:[UIImage imageNamed:@"addtofolder_icon.png"] forState:UIControlStateNormal];
    [combinepaymentbutton addTarget: self action:@selector(combinepaymentbuttonpressed) forControlEvents: UIControlEventTouchUpInside];
    [background addSubview:combinepaymentbutton];*/
    
    /*sales_header_orderdate = [[UILabel alloc]init];
    //sales_header_orderdate.text=[MyClass returntitlewithtitle:@"Order Date"];
    sales_header_orderdate.font=[UIFont boldSystemFontOfSize:13];
    sales_header_orderdate.textColor=[UIColor blackColor];
    [SalesView addSubview:sales_header_orderdate];
    
    sales_header_product = [[UILabel alloc]init];
    //sales_header_product.text=[MyClass returntitlewithtitle:@"Product"];
    sales_header_product.font=[UIFont boldSystemFontOfSize:13];
    sales_header_product.textColor=[UIColor blackColor];
    [SalesView addSubview:sales_header_product];
    
    sales_header_totalprice = [[UILabel alloc]init];
    //sales_header_totalprice.text=[MyClass returntitlewithtitle:@"Total Price"];
    sales_header_totalprice.font=[UIFont boldSystemFontOfSize:13];
    sales_header_totalprice.textAlignment=NSTextAlignmentLeft;
    sales_header_totalprice.textColor=[UIColor blackColor];
    [SalesView addSubview:sales_header_totalprice];
    

    
    sales_header_remarks = [[UILabel alloc]init];
    //sales_header_remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    sales_header_remarks.font=[UIFont boldSystemFontOfSize:13];
    sales_header_remarks.textColor=[UIColor blackColor];
    [SalesView addSubview:sales_header_remarks];*/
    
    
    

}


-(void) refreshsalestableheader
{
    sales_header_leadingconstraint.constant=isSelectCombinePayment?43:13;
    sales_header_orderdate.text=[MyClass returntitlewithtitle:@"Order Date"];
    sales_header_product.text=[MyClass returntitlewithtitle:@"Product"];
    sales_header_totalprice.text=[MyClass returntitlewithtitle:@"Total Price"];
    sales_header_remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    sales_header_quantity.text=[MyClass returntitlewithtitle:@"Quantity"];
    sales_header_givenout.text=[MyClass returntitlewithtitle:@"Given Out"];
    sales_header_invoiceremarks.text=[MyClass returntitlewithtitle:@"Invoice Remarks"];
    
}

-(void) refreshcoupontableheader
{
    coupon_header_couponid.text=[MyClass returntitlewithtitle:@"ID"];
    coupon_header_coupon.text=[MyClass returntitlewithtitle:@"Coupon"];
    coupon_header_type.text=[MyClass returntitlewithtitle:@"Type"];
    coupon_header_issuedate.text=[MyClass returntitlewithtitle:@"Issue Date"];
    coupon_header_effectivefrom.text=[MyClass returntitlewithtitle:@"Valid From"];
    coupon_header_effectiveto.text=[MyClass returntitlewithtitle:@"Valid To"];
    coupon_header_useddate.text=[MyClass returntitlewithtitle:@"Date Used"];
    coupon_header_remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    
}

-(BOOL) retrieveCouponRecord
{
    NSString *strURL;
    
    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectcouponrecords&studentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DetailsViewStudent.studentkey];
    __block BOOL result=FALSE;
    __block NSData *returndata;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            returndata=data;
            
        }
    }];
    
    if(result){
        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:returndata options:(kNilOptions) error:nil];
        JSONArray = jsonreturned[@"content"];
        //Set up our class array
        DetailsViewCouponArray=[[NSMutableArray alloc] init];
        
        
        
        //loop through our jsonArray
        for (int i=0; i<JSONArray.count; i++) {
            
            //Create our Instructor object
            NSString * scenterkey=[[JSONArray objectAtIndex:i] objectForKey:@"centerkey"];
            NSString * scouponkey=[[JSONArray objectAtIndex:i] objectForKey:@"couponkey"];
            NSString * smarketingkey=[[JSONArray objectAtIndex:i] objectForKey:@"marketingkey"];
            NSString * seffectiveto=[[JSONArray objectAtIndex:i] objectForKey:@"effectiveto"];
            NSString * sissuedate=[[JSONArray objectAtIndex:i] objectForKey:@"issuedate"];
            NSString * sdateused=[[JSONArray objectAtIndex:i] objectForKey:@"dateused"];
            NSString * seffectivefrom=[[JSONArray objectAtIndex:i] objectForKey:@"effectivefrom"];
            NSString * sremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
            NSString * sstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
            BOOL scannotuseconjunctionwithothercoupons=[[[JSONArray objectAtIndex:i] objectForKey:@"cannotuseconjunctionwithothercoupons"] isEqualToString:@"Yes"];
            BOOL screditable=[[[JSONArray objectAtIndex:i] objectForKey:@"creditable"] isEqualToString:@"Yes"];
            
            //Add the instructor object to our instructor array
            [DetailsViewCouponArray addObject:[[CouponRecord alloc]initCouponRecordWithcenterkey:scenterkey marketingkey:smarketingkey couponkey:scouponkey issuedate:sissuedate effectiveto:seffectiveto dateused:sdateused effectivefrom:seffectivefrom remarks:sremarks marketing:nil usedsequence:nil studentkey:sstudentkey cannotuseconjunctionwithothercoupons:scannotuseconjunctionwithothercoupons creditable:screditable]];
        }
    }
    
    [self returnfiltercouponarray];
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    
    return YES;
}

-(BOOL) retrieveSalesRecord
{
    long selectedSaleskeyindex=-1;
    productlistarray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveproductinformationwithcategory:@"All" status:@"All" flushcachedata:NO]];
    
    if (!productlistarray) {
        return NO;
    }
    
    //create string contains url address for php file
    NSString *strURL;
    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectsalesrecord&studentkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DetailsViewStudent.studentkey];
    showGivenOut=FALSE;
    __block BOOL result=FALSE;
    __block NSData *returndata;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result = TRUE;
            returndata=data;
            
        }
    }];

            
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        NSDate *date;
        NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:returndata options:(kNilOptions) error:nil];
        JSONArray = jsonreturned[@"content"];
        
        //Set up our class array
        SalesRecordArray=[[NSMutableArray alloc] init];
        
        //loop through our jsonArray
        for (int i=0; i<JSONArray.count; i++) {
            
            //Create our ClassRecord object
            NSString * cstudentkey=[[JSONArray objectAtIndex:i] objectForKey:@"studentkey"];
            NSString * csaleskey=[[JSONArray objectAtIndex:i] objectForKey:@"saleskey"];
            NSString * cinvoicenumber=[[JSONArray objectAtIndex:i] objectForKey:@"invoicenumber"];
            NSString * cinvoiceprefix=[[JSONArray objectAtIndex:i] objectForKey:@"invoiceprefix"];
            [df setDateFormat:@"yyyy-MM-dd"];
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
            //NSString * clastpaymentkey=[[JSONArray objectAtIndex:i] objectForKey:@"lastpaymentkey"];
            //NSArray *cpaymentkeys=[[NSArray alloc]initWithArray:[[[JSONArray objectAtIndex:i] objectForKey:@"paymentkeys"] componentsSeparatedByString:@","]];
            NSString * cautorenew=[[JSONArray objectAtIndex:i] objectForKey:@"autorenew"];
            NSString * cgivenout=[[JSONArray objectAtIndex:i] objectForKey:@"givenout"];
            
            if (![ProductCategoryArray containsObject:cproductcategory]) {
                [ProductCategoryArray addObject:cproductcategory];
            }
            
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
                BOOL sbuymorepayless=[[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"buymorepayless"] isEqualToString:@"Yes"];
                BOOL smanualapply=[[[promotiondiscountrecords objectAtIndex:i] objectForKey:@"manualapply"] isEqualToString:@"Yes"];
                
                [cpromotiondiscountrecords addObject:[[MarketingRecord alloc]initMarketingRecordWithcenterkey:scenterkey marketingkey:smarketingkey category:@"promotion" description:sdescription description_chinese:sdescription_chinese startdate:sstartdate enddate:senddate remarks:sremarks promotionfixeddiscount:spromotionfixeddiscount promotionpercentagediscount:spromotionpercentagediscount usedcount:susedcount promotionquota:spromotionquota code:scode recursive:srecursive effectivefrom:nil effectiveto:nil subcategory:nil redeemable:NO redeempoint:nil perstudentquota:nil cannotuseconjunctionwithothercoupons:NO subjectarray:nil productarray:nil couponallowcredit:nil perclassorquantity:sperclassorquantity earlybirdlastdate:nil buymorepayless:sbuymorepayless estartdate:nil eenddate:nil enablebuymorepayless:NO minnoofclass:0 bmsmacrossothersubjects:NO bmsmminsubjectno:0 bmsmminnoofclasspersubject:0 bmsmsamebillmonth:NO manualapply:smanualapply]];
            }
            
            NSMutableArray *ccouponrecords=[[NSMutableArray alloc]init];
            NSArray *couponrecords=[[JSONArray objectAtIndex:i] objectForKey:@"couponrecords"];
            for (int i=0; i<couponrecords.count; i++) {
                NSString * scenterkey=[[couponrecords objectAtIndex:i] objectForKey:@"centerkey"];
                NSString * scouponkey=[[couponrecords objectAtIndex:i] objectForKey:@"couponkey"];
                NSString * smarketingkey=[[couponrecords objectAtIndex:i] objectForKey:@"marketingkey"];
                NSString * seffectiveto=[[couponrecords objectAtIndex:i] objectForKey:@"effectiveto"];
                NSString * sissuedate=[[couponrecords objectAtIndex:i] objectForKey:@"issuedate"];
                NSString * sdateused=[[couponrecords objectAtIndex:i] objectForKey:@"dateused"];
                NSString * seffectivefrom=[[couponrecords objectAtIndex:i] objectForKey:@"effectivefrom"];
                NSString * sremarks=[[couponrecords objectAtIndex:i] objectForKey:@"remarks"];
                NSString * sstudentkey=[[couponrecords objectAtIndex:i] objectForKey:@"studentkey"];
                BOOL scannotuseconjunctionwithothercoupons=[[[couponrecords objectAtIndex:i] objectForKey:@"cannotuseconjunctionwithothercoupons"] isEqualToString:@"Yes"];
                BOOL screditable=[[[couponrecords objectAtIndex:i] objectForKey:@"creditable"] isEqualToString:@"Yes"];
                
                [ccouponrecords addObject:[[CouponRecord alloc]initCouponRecordWithcenterkey:scenterkey marketingkey:smarketingkey couponkey:scouponkey issuedate:sissuedate effectiveto:seffectiveto dateused:sdateused effectivefrom:seffectivefrom remarks:sremarks marketing:nil usedsequence:nil studentkey:sstudentkey cannotuseconjunctionwithothercoupons:scannotuseconjunctionwithothercoupons creditable:screditable]];
            }
            
            [SalesRecordArray addObject:[[SalesRecord alloc]initSalesRecordWithstudentkey:cstudentkey saleskey:csaleskey orderdate:corderdate productfullname:cproductfullname productcode:cproductcode productcategory:cproductcategory price:cprice quantity:cquantity oneoffdiscount:coneoffdiscount oneoffpercentagediscount:coneoffpercentagediscount paid:cpaid total:ctotal remarks:cremarks invoiceremarks:cinvoiceremarks status:cstatus reverseadjustment:creverseadjustment autorenew:cautorenew paymentrecords:cpaymentrecords promotiondiscountrecords:cpromotiondiscountrecords givenout:cgivenout couponrecords:ccouponrecords invoicenumber:cinvoicenumber invoiceprefix:cinvoiceprefix]];
            
            ProductRecord *obj=[MyClass returnProductInformationWithCode:cproductcode centerkey:globalvariables.centerrecord.centerkey];
            if(![obj.stockcount isEqualToString:@""]){
                showGivenOut=TRUE;
            }
        }
        
    }
    
    sales_header_givenout.hidden=!showGivenOut;
    
    [self returnfiltersalesarray];
    [SalesTable reloadData];
    
    selectedSaleskeyindex=[self returnselectedsaleskeyindexwithselectedsaleskey:selectedSaleskey];
    if (filteredSalesRecordArray.count>0 && selectedSaleskeyindex>=0) {
        [SalesTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selectedSaleskeyindex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
    
    return result;
}

-(void) dismissSalesPopover
{
    [self retrieveSalesRecord];
    [self closesidewindow];
    [self highlightduebuttonwithreloadstudentlist:YES];
    //[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) dismissCouponPopoverWithReloadStudentList:(BOOL)reloadstudentlist
{
    [self retrieveCouponRecord];
    [self closesidewindow];
    [self highlightduebuttonwithreloadstudentlist:YES];
    if(reloadstudentlist){
        [self.delegate dismissEditStudentView];
    }
}



-(void) dismissPointPopoverWithReloadStudent:(BOOL)reloadstudent
{
    [self closesidewindow];
    if(reloadstudent){
        [self updateStudentPoint:DetailsViewStudent.studentkey];
        [pointviewcontroller getStudentPointHistory];
//        if([self.delegate edit]){
            [self.delegate dismissEditStudentView];
//        }
    }
}



-(void) dismissSalesPopoverduetoconnectionerror
{
    [self closesidewindow];
    //[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [MyClass showconnectionlostdialogbox];
}


-(SalesRecord *) updatesalesrecordandreturnsalesrecord:(NSString *)saleskey
{
    if([self retrieveSalesRecord]){
        [self highlightduebuttonwithreloadstudentlist:YES];
        DataChanged=TRUE;
        if(saleskey){
            SalesRecord *salesobj;
            for (int i=0; i<SalesRecordArray.count; i++) {
                salesobj=[SalesRecordArray objectAtIndex:i];
                if ([salesobj.saleskey isEqualToString:saleskey]) {
                    return salesobj;
                }
            }
        }
    }
    return nil;
}

-(void) updatecouponrecord
{
    if([self retrieveCouponRecord]){
        [self highlightduebuttonwithreloadstudentlist:YES];
        DataChanged=TRUE;
    }
}

-(void) updatepointrecord
{
    
}

-(IBAction) selectproductcategory:(UIButton *)sender
{
    // add group selection tables
    ProductCategorySelectionTable=[[UITableView alloc]init];
    ProductCategorySelectionTable.separatorColor=[UIColor clearColor];
    ProductCategorySelectionTable.delegate=self;
    ProductCategorySelectionTable.dataSource=self;
    [ProductCategorySelectionTable reloadData];
    ProductCategorySelectionTable.frame=CGRectMake(0, 0, 200, ProductCategorySelectionTable.contentSize.height>maxselectiontableheight?maxselectiontableheight:ProductCategorySelectionTable.contentSize.height);
    ProductCategorySelectionTable.separatorColor=[UIColor clearColor];
    
    UIView *productCategorySelectionMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, ProductCategorySelectionTable.frame.size.height)];
    [productCategorySelectionMasterView addSubview:ProductCategorySelectionTable];
    
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=productCategorySelectionMasterView;
    viewcontroller.preferredContentSize=CGSizeMake(200, ProductCategorySelectionTable.frame.size.height);
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myProductCategorySelectionPopoverController=viewcontroller.popoverPresentationController;
    myProductCategorySelectionPopoverController.delegate=self;
    myProductCategorySelectionPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myProductCategorySelectionPopoverController.sourceView=sender;
    myProductCategorySelectionPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    [self drawpointerwithoption:@"open" imageview:productcategorybuttonarrow];
}


/*
-(void) selectevent:(UISegmentedControl *)sender
{
    ProductCategoryArray=[[NSMutableArray alloc]initWithObjects:[MyClass returntitlewithtitle:@"All Categories"], nil];
    [ProductCategorySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Categories"] forState:UIControlStateNormal];
    [self retrieveSalesRecord];
}*/

-(IBAction) documentfolderbuttonpressed:(id)sender
{
    [self showviewhistory:FALSE];

    [self startsidewindowanimationwithwidth:750];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        documentfolderpopover = (DocumentFolderPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"DocumentFolderPopoverViewController"];
        documentfolderpopover.delegate=self;
        /*globalvariables.documentfolder.globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys=globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys;
        globalvariables.documentfolder.globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys=globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys;
        globalvariables.documentfolder.globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys=globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys;
        globalvariables.documentfolder.globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys=globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys;
        globalvariables.documentfolder.globalvariables.documentfolder.defaultcheckedclassreceiptpaymentkeys=globalvariables.documentfolder.defaultcheckedclassreceiptpaymentkeys;
        globalvariables.documentfolder.globalvariables.documentfolder.defaultcheckedsalesreceiptpaymentkeys=globalvariables.documentfolder.defaultcheckedsalesreceiptpaymentkeys;*/
        documentfolderpopover.menubutton=2;
        
        documentfolderpopover.view.frame=self->mainWindow.bounds;
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
    [self closesidewindow];
    //[documentfolderpopover dismissViewControllerAnimated:YES completion:nil];
    /*isSelectCombinePayment=FALSE;*/
    if (lastviewindex==1) {
        [DetailsViewEnrollmentTable reloadData];
    }else if (lastviewindex==3){
        [SalesTable reloadData];
    }
    [self refreshdocumentfoldercount];
}

-(void) refreshDocumentFolderPresentingViewScreen
{
    isSelectCombinePayment=FALSE;
    if (lastviewindex==1) {
        [self refreshenrollmenttableheader];
        [self refreshenrollmenttable];
    }else if (lastviewindex==3){
        [self refreshsalestableheader];
        [self refreshsalestable];
    }
    //[self highlightduebuttonwithreloadstudentlist:YES];
}

/*
-(void) refreshdocumentfoldercountnumber
{
    [self refreshdocumentfoldercount];
}*/

-(IBAction) addnewcalllog:(id)sender
{
    [self showviewhistory:FALSE];

    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        CallLogPopoverViewController *calllogpopover = (CallLogPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"CallLogPopoverViewController"];
        calllogpopover.delegate=self;
        calllogpopover.studentkey=DetailsViewStudent.studentkey;
        calllogpopover.CallLogTableMode=@"Add";
        calllogpopover.CallingSource=@"student";
        
        if (![calllogpopover InitializeField]) {
            [MyClass showconnectionlostdialogbox];
        }
        
        calllogpopover.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:calllogpopover.view];
        [self addChildViewController:calllogpopover];
        [calllogpopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
        
    });
}

-(IBAction) selectcalllogcalledby:(UIButton *)sender
{
    // add group selection tables
    CallLogCalledBySelectionTable=[[UITableView alloc]init];
    CallLogCalledBySelectionTable.separatorColor=[UIColor clearColor];
    CallLogCalledBySelectionTable.delegate=self;
    CallLogCalledBySelectionTable.dataSource=self;
    [CallLogCalledBySelectionTable reloadData];
    CallLogCalledBySelectionTable.frame=CGRectMake(0, 0, 200, CallLogCalledBySelectionTable.contentSize.height>maxselectiontableheight?maxselectiontableheight:CallLogCalledBySelectionTable.contentSize.height);
    CallLogCalledBySelectionTable.separatorColor=[UIColor clearColor];
    
    UIView *calllogcallerSelectionMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, CallLogCalledBySelectionTable.frame.size.height)];
    [calllogcallerSelectionMasterView addSubview:CallLogCalledBySelectionTable];
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=calllogcallerSelectionMasterView;
    viewcontroller.preferredContentSize=CGSizeMake(200, CallLogCalledBySelectionTable.frame.size.height);
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myCallLogCalledBySelectionPopoverController=viewcontroller.popoverPresentationController;
    myCallLogCalledBySelectionPopoverController.delegate=self;
    myCallLogCalledBySelectionPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myCallLogCalledBySelectionPopoverController.sourceView=sender;
    myCallLogCalledBySelectionPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    [self drawpointerwithoption:@"open" imageview:calllog_callerarrow];
}





-(IBAction) selectdtclass:(UIButton *)sender
{
    // add group selection tables
    DTSubjectSelectionTable=[[UITableView alloc]init];
    DTSubjectSelectionTable.separatorColor=[UIColor clearColor];
    DTSubjectSelectionTable.delegate=self;
    DTSubjectSelectionTable.dataSource=self;
    [DTSubjectSelectionTable reloadData];
    DTSubjectSelectionTable.frame=CGRectMake(0, 0, 300, DTSubjectSelectionTable.contentSize.height>maxselectiontableheight?maxselectiontableheight:DTSubjectSelectionTable.contentSize.height);
    DTSubjectSelectionTable.separatorColor=[UIColor clearColor];
    
    UIView *calllogcallerSelectionMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, DTSubjectSelectionTable.frame.size.height)];
    [calllogcallerSelectionMasterView addSubview:DTSubjectSelectionTable];
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=calllogcallerSelectionMasterView;
    viewcontroller.preferredContentSize=CGSizeMake(300, DTSubjectSelectionTable.frame.size.height);
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myDTSelectionPopoverController=viewcontroller.popoverPresentationController;
    myDTSelectionPopoverController.delegate=self;
    myDTSelectionPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myDTSelectionPopoverController.sourceView=sender;
    myDTSelectionPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    [self drawpointerwithoption:@"open" imageview:dt_coursearrow];
}

-(IBAction) selectdttype:(UIButton *)sender
{
    // add group selection tables
    DTTypeSelectionTable=[[UITableView alloc]init];
    DTTypeSelectionTable.separatorColor=[UIColor clearColor];
    DTTypeSelectionTable.delegate=self;
    DTTypeSelectionTable.dataSource=self;
    [DTTypeSelectionTable reloadData];
    DTTypeSelectionTable.frame=CGRectMake(0, 0, 200, DTTypeSelectionTable.contentSize.height);
    DTTypeSelectionTable.separatorColor=[UIColor clearColor];
    
    UIView *calllogcallerSelectionMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, DTTypeSelectionTable.contentSize.height+44)];
    [calllogcallerSelectionMasterView addSubview:DTTypeSelectionTable];
    
    
    UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
    viewcontroller.view=calllogcallerSelectionMasterView;
    viewcontroller.preferredContentSize=CGSizeMake(200, DTTypeSelectionTable.contentSize.height);
    viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
    myDTSelectionPopoverController=viewcontroller.popoverPresentationController;
    myDTSelectionPopoverController.delegate=self;
    myDTSelectionPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myDTSelectionPopoverController.sourceView=sender;
    myDTSelectionPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    [self drawpointerwithoption:@"open" imageview:dt_typearrow];
}


-(void) popupcalllogdetailswindow:(NSString *)CallLogMode button:(UIBarButtonItem *)button
{
    staffArray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveStaffListwithvalid:@"All" role:@"All" flushcachedata:YES]];
    if (!staffArray) {
        return;
    }
}

-(void) dismissCallLogPopoverVC
{
    [self retrieveCallLogRecord];
    [self closesidewindow];
    //[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}


-(void) retrieveDTrecords
{
    [self retrieveDTWithSubject:dtsubjectselected studentkey:DetailsViewStudent.studentkey classtype:dttypeselected];
}

-(BOOL) retrieveDTWithSubject:(NSString *)subject studentkey:(NSString *)studentkey classtype:(NSString *)classtype
{
    
    long selecteddtkeyindex=0;
    //create string contains url address for php file
    NSString *strURL;
    
    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectdt&type=%@&typekey=%@&subject=%@&classtype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,@"student",DetailsViewStudent.studentkey,@"All",@"All"];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result = TRUE;
            NSDate *date;
            
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
            
            //Set up our class array
            DetailsViewDTArray=[[NSMutableArray alloc] init];
            
            
            
            //loop through our jsonArray
            for (int i=0; i<JSONArray.count; i++) {
                
                //Create our Instructor object
                NSString * sdtkey=[[JSONArray objectAtIndex:i] objectForKey:@"dtkey"];
                /*if ([sdtkey isEqualToString:selectedDTkey]) {
                    selecteddtkeyindex=i;
                }*/
                
                NSString * sdtstatus=[[JSONArray objectAtIndex:i] objectForKey:@"dtstatus"];
                
                NSString *sdtdate;
                if (![[[JSONArray objectAtIndex:i] objectForKey:@"dtdate"] isEqualToString:@""]) {
                    [df setDateFormat:@"yyyy-MM-dd"];
                    date=[df dateFromString:[[JSONArray objectAtIndex:i] objectForKey:@"dtdate"]];
                    [df setDateFormat:@"dd-MMM-yyyy"];
                    sdtdate=[df stringFromDate:date];
                }else{
                    sdtdate=@"";
                }
                
                NSString * sdttime=[[JSONArray objectAtIndex:i] objectForKey:@"dttime"];
                NSString * ssubject=[[JSONArray objectAtIndex:i] objectForKey:@"subject"];
                NSString * slevelmain=[[JSONArray objectAtIndex:i] objectForKey:@"levelmain"];
                NSString * slevelctm=[[JSONArray objectAtIndex:i] objectForKey:@"levelctm"];
                NSString * sinstructor=[[JSONArray objectAtIndex:i] objectForKey:@"instructor"];
                NSString * sremarks=[[JSONArray objectAtIndex:i] objectForKey:@"remarks"];
                NSString * sclasstype=[[JSONArray objectAtIndex:i] objectForKey:@"classtype"];
                NSString * sclassduration=[[JSONArray objectAtIndex:i] objectForKey:@"classduration"];
                NSString * sclassroom=[[JSONArray objectAtIndex:i] objectForKey:@"classroom"];
                NSString * sattendance=[[JSONArray objectAtIndex:i] objectForKey:@"attendance"];
                NSString * sinstructorfullname=[MyClass returninstructornamewithusername:sinstructor firstorfullname:@"full"];
                NSString * ssubjectfullname=[MyClass returnsubjectnamewithsubject_shortname:ssubject centerkey:globalvariables.centerrecord.centerkey];
                BOOL clocked=[[[JSONArray objectAtIndex:i] objectForKey:@"locked"] isEqualToString:@"Yes"];
                
                if (![DTSubjectArray containsObject:ssubject]) {
                    [DTSubjectArray addObject:ssubject];
                }

                //Add the instructor object to our instructor array
                [DetailsViewDTArray addObject:[[DTRecord alloc]initDTRecordWithDTkey:sdtkey DTStatus:sdtstatus andDTdate:sdtdate andDTtime:sdttime andsubject:ssubject andlevelmain:slevelmain andlevelctm:slevelctm andclassduration:sclassduration andinstructor:sinstructor andremarks:sremarks andclasstype:sclasstype andclassroom:sclassroom andattendance:sattendance andinstructorfullname:sinstructorfullname andsubjectfullname:ssubjectfullname andlocked:clocked]];
            }
            
            //sort dt subject by subject full name
            BOOL addAllClasses=FALSE;
            if ([[DTSubjectArray firstObject] isEqualToString:@"All Classes"]) {
                [DTSubjectArray removeObjectAtIndex:0];
                addAllClasses=TRUE;
            }
            
            NSMutableArray *tmpsubjectarray=[[NSMutableArray alloc]init];
            for (int i=0; i<DTSubjectArray.count; i++) {
                [tmpsubjectarray addObject:[[SubjectRecord alloc]initSubjectRecordwithCenterkey:nil Subjectkey:nil Subject_Englishname:[MyClass returnsubjectnamewithsubject_shortname:[DTSubjectArray objectAtIndex:i] centerkey:globalvariables.centerrecord.centerkey] Subject_Chinesename:nil Subject_shortname:[DTSubjectArray objectAtIndex:i] Enrollmentmode:nil Tuition_method:nil Tuition_mode:nil Studentcapacity:nil StandardNoOfClassOrMonth:nil ClassDuration:nil ClassDurationAssessment:nil ClassDurationTrial:nil Status:nil LevelArray:nil TuitionArray:nil Remarks:nil ScheduleArray:nil Subject_Category:nil WeeklyAutoRenewDefault:NO validity:nil makeup_quota_unit:@"" makeup_quota_value:@"-1" leaveday_by_makeupschedule:NO leaveday_by_classdate:NO leaveday_follow_teacher:NO leaveday_by_enrolledschedule:NO leaveday_by_staffschedule:NO leaveday_follow_level:NO leaveday_follow_lesson:NO colorcode:0 fcsubject:nil lessonnumberDict:nil leaveday_follow_category:NO allowsameschedule:NO subject_fulldescription:nil subject_image:nil publishinchatbot:NO chatbot_category:nil chatbot_tag1:nil trial_by_existinglesson:NO trial_by_definedschedule:NO trialcapacity:nil chatbot_enabletrial:NO showmakeupbuttonifnotimeslot:NO btspromotioncode831:nil btspromotioncode1031:nil showabsentbuttononarrangeleave:NO pregenperiodcount:0 autolevelupgrade:nil]];
            }
            
            
            NSSortDescriptor *sortBySubjectname = [NSSortDescriptor sortDescriptorWithKey:@"subject_englishname" ascending:YES selector:@selector(caseInsensitiveCompare:)];
            NSArray *sortDescriptors = @[sortBySubjectname];
            tmpsubjectarray = [NSMutableArray arrayWithArray:[tmpsubjectarray sortedArrayUsingDescriptors:sortDescriptors]];
            
            DTSubjectArray=[[NSMutableArray alloc]init];
            for (int i=0; i<tmpsubjectarray.count; i++) {
                [DTSubjectArray addObject:((SubjectRecord *)[tmpsubjectarray objectAtIndex:i]).subject_shortname];
            }
            
            if (addAllClasses) {
                [DTSubjectArray insertObject:@"All Classes" atIndex:0];
            }
        }
    }];
    
            
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    if (result) {
        [self returnfilterdtarray];
        selecteddtkeyindex=[self returnselecteddtkeyindexwithselecteddtkey:selectedDTkey];
        [DetailsViewDTTable reloadData];
        if (filteredDetailsViewDTArray.count>0 && selecteddtkeyindex>=0) {
            [DetailsViewDTTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:selecteddtkeyindex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    
    return result;
    
}

- (IBAction)addnewdt:(id)sender {
    
    [self showviewhistory:FALSE];
    

    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
        DTAddEditViewController *DTPopover = (DTAddEditViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"DTAddEditViewController"];
        DTPopover.delegate=self;
        //DTPopover.PopoverEnrollment=DetailsViewEnrollment;
        DTPopover.DTTableMode=@"Add";
        DTPopover.CallingSource=@"student";
        DTPopover.PopoverMode=@"PopoverDTFromStudentView";
        DTPopover.CallingKey=DetailsViewStudent.studentkey;
        
        DTPopover.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:DTPopover.view];
        [self addChildViewController:DTPopover];
        [DTPopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
        
    });
}

-(void) dismissDTAddEditpopoverwithrefresh:(BOOL)refresh
{
    //[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self closesidewindow];
    if (refresh) {
        [self retrieveDTWithSubject:dtsubjectselected studentkey:DetailsViewStudent.studentkey classtype:dttypeselected];
        DataChanged=YES;
        [self.delegate refreshstudentdetailviewpresentingviewcontent];
    }
}

-(void) dismissDTAddEditpopoverduetoconnectionerror
{
    [self closesidewindow];
    //[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) enrollATSubject
{
    studentAction=@"EnrollATSubject";

}

-(void) addStudentSubject
{
    studentAction=@"AddStudentSubject";
}

-(void) enrollATLeadStudent:(AssessmentTrialRecord *)ATRecord
{
    [self closesidewindow];
    

        studentAction=@"EnrollStudentSubject";
        DetailsViewATObject=ATRecord;
        TopMenuView.hidden=NO;
        
        if ([self retrieveStudent:DetailsViewATObject.studentkey ]) {
            //[self highlighttableoptionbuttonwithbuttontag:1001];
            [self selecttable:[self returnmenubuttonwithtagnumber:1]];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self popoverenrollmentwindow];
            });
        }
    
    

}

-(BOOL) retrieveMediaSource
{
    NSMutableArray *mediasourcearray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveMarketingRecordWithStatus:@"Valid" enrollmentdate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] flushcachedata:YES subjectkey:nil productkey:nil]];
    if (mediasourcearray) {
        MediaArray=[[NSMutableArray alloc] initWithArray:[mediasourcearray objectAtIndex:0]];
        SourceArray=[[NSMutableArray alloc] initWithArray:[mediasourcearray objectAtIndex:1]];
        return YES;
    }else{
        return NO;
    }
}


-(IBAction) gotoleadprofile:(id)sender
{
    [self showviewhistory:FALSE];

    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    mainVC.leftMenu.prepareforsegue=TRUE;
    mainVC.leftMenu.leadprofile_leadkey=DetailsViewStudent.leadkey;
    mainVC.leftMenu.leadprofile_submenu=0;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:9 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
    
}




-(int) tableoptionviewmenucount
{
    int result=0;
    for (int i=0; i<tableoptionviewarray.count; i++) {
        if ([[tableoptionviewarray objectAtIndex:i] isEqualToString:@"1"]) {
            result+=1;
        }
    }
    return result;
}

-(long) lasttableoptionviewmenu
{
    for (long i=tableoptionviewarray.count-1; i>=0; i--) {
        if ([[tableoptionviewarray objectAtIndex:i] isEqualToString:@"1"]) {
            return i;
        }
    }
    return 0;
}

-(void) viewhistorybuttonpressed
{
    [self showviewhistory:ViewHistoryTableMasterView.hidden];
}

- (void)wasDragged:(UIPanGestureRecognizer *)recognizer {
    UIButton *button = (UIButton *)recognizer.view;
    CGPoint translation = [recognizer translationInView:button];
    
    float x;
    float y;
    
    if ((button.center.x + translation.x)<button.frame.size.width/2) {
        x=button.frame.size.width/2;
    }else if ((button.center.x + translation.x)>selfViewWidth-button.frame.size.width/2){
        x=selfViewWidth-button.frame.size.width/2;
    }else{
        x=button.center.x + translation.x;
    }

    if ((button.center.y + translation.y)<button.frame.size.width/2+64) {
        y=button.frame.size.width/2+64;
    }else if ((button.center.y + translation.y)>self.view.bounds.size.height-button.frame.size.width/2){
        y=self.view.bounds.size.height-button.frame.size.width/2;
    }else{
        y=button.center.y + translation.y;
    }
    
    button.center = CGPointMake(x,y);
    
    [recognizer setTranslation:CGPointZero inView:button];
}

-(void) closeviewhistorybuttonpressed
{
    [self showviewhistory:NO];
}

-(void) showviewhistory:(BOOL)show
{
    ViewHistoryTableMasterView.hidden=!show;
    if (show) {
        //systemMessageLabel.frame=CGRectMake(0, 0, selfViewWidth-234, self.view.bounds.size.height-64);
        systemMessageTrailingConstraint.constant=234;
        viewhistoryarray=[MyClass returnViewHistoryWithType:@"student"];
        [ViewHistoryTable reloadData];
    }else{
        systemMessageTrailingConstraint.constant=0;
        //systemMessageLabel.frame=CGRectMake(0, 0, selfViewWidth, self.view.bounds.size.height-64);
    }
}

-(void) loadgeneral
{

    
    viewhistorybutton=[[UIButton alloc]initWithFrame:CGRectMake(selfViewWidth-45-20, self.view.bounds.size.height-100, 45, 45)];
    viewhistorybutton.backgroundColor=[UIColor lightGrayColor];
    [viewhistorybutton setImage:[UIImage imageNamed:@"history_icon.png"] forState:UIControlStateNormal];
    [viewhistorybutton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    viewhistorybutton.layer.cornerRadius=viewhistorybutton.frame.size.width/2;
    viewhistorybutton.layer.masksToBounds=YES;
    viewhistorybutton.layer.borderColor=[UIColor darkGrayColor].CGColor;
    viewhistorybutton.layer.borderWidth=1;
    [viewhistorybutton addTarget:self action:@selector(viewhistorybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:viewhistorybutton];
    
    UIPanGestureRecognizer *panRecognizer;
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(wasDragged:)];
    panRecognizer.cancelsTouchesInView = YES;
    [viewhistorybutton addGestureRecognizer:panRecognizer];
    
    //ViewHistoryTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(570, 85, 220, 660)];
    ViewHistoryTableMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, selfViewWidth, self.view.bounds.size.height-64)];
    //ViewHistoryTableMasterView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [self.view addSubview:ViewHistoryTableMasterView];
    ViewHistoryTableMasterView.hidden=YES;
    
    UIButton *closebutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, ViewHistoryTableMasterView.frame.size.width, ViewHistoryTableMasterView.frame.size.height)];
    [closebutton addTarget:self action:@selector(closeviewhistorybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [ViewHistoryTableMasterView addSubview:closebutton];
    
    UIView *tableview=[[UIView alloc]initWithFrame:CGRectMake(selfViewWidth-234, 20, 220, self.view.bounds.size.height-108)];
    tableview.backgroundColor=[UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:0.95];
    tableview.layer.cornerRadius=5;
    tableview.layer.masksToBounds=YES;
    [ViewHistoryTableMasterView addSubview:tableview];

    
    viewhistorytableheader=[[UILabel alloc]initWithFrame:CGRectMake(10, 0, 200, 35)];
    viewhistorytableheader.font=[UIFont systemFontOfSize:13];
    viewhistorytableheader.textColor=[UIColor blackColor];
    [tableview addSubview:viewhistorytableheader];
    
    UIButton *closeviewhistorybutton=[[UIButton alloc]initWithFrame:CGRectMake(tableview.frame.size.width-40, 0, 35, 35)];
    [closeviewhistorybutton setImage:[UIImage imageNamed:@"closescreengray_icon.png"] forState:UIControlStateNormal];
    [closeviewhistorybutton addTarget:self action:@selector(closeviewhistorybuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    [closeviewhistorybutton setImageEdgeInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [tableview addSubview:closeviewhistorybutton];
    
    ViewHistoryTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 35, 220, self.view.frame.size.height-152) style:UITableViewStylePlain];
    ViewHistoryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    ViewHistoryTable.backgroundColor=[UIColor clearColor];
    ViewHistoryTable.scrollEnabled=FALSE;
    ViewHistoryTable.delegate=self;
    ViewHistoryTable.dataSource=self;
    [tableview addSubview:ViewHistoryTable];

    
    menuview_student.hidden=![[tableoptionviewarray objectAtIndex:menuview_student.tag] isEqualToString:@"1"];
    menuview_enrollment.hidden=![[tableoptionviewarray objectAtIndex:menuview_enrollment.tag] isEqualToString:@"1"];
    menuview_class.hidden=![[tableoptionviewarray objectAtIndex:menuview_class.tag] isEqualToString:@"1"];
    menuview_sales.hidden=![[tableoptionviewarray objectAtIndex:menuview_sales.tag] isEqualToString:@"1"];
    menuview_messages.hidden=![[tableoptionviewarray objectAtIndex:menuview_messages.tag] isEqualToString:@"1"];
    menuview_calllog.hidden=![[tableoptionviewarray objectAtIndex:menuview_calllog.tag] isEqualToString:@"1"];
    menuview_trial.hidden=![[tableoptionviewarray objectAtIndex:menuview_trial.tag] isEqualToString:@"1"];
    menuview_coupon.hidden=![[tableoptionviewarray objectAtIndex:menuview_coupon.tag] isEqualToString:@"1"];
    
    menulabel_student.text=[MyClass returntitlewithtitle:[tableoptionarray objectAtIndex:menulabel_student.tag]];
    menulabel_enrollment.text=[MyClass returntitlewithtitle:[tableoptionarray objectAtIndex:menulabel_enrollment.tag]];
    menulabel_class.text=[MyClass returntitlewithtitle:[tableoptionarray objectAtIndex:menulabel_class.tag]];
    menulabel_sales.text=[MyClass returntitlewithtitle:[tableoptionarray objectAtIndex:menulabel_sales.tag]];
    menulabel_messages.text=[MyClass returntitlewithtitle:[tableoptionarray objectAtIndex:menulabel_messages.tag]];
    menulabel_calllog.text=[MyClass returntitlewithtitle:[tableoptionarray objectAtIndex:menulabel_calllog.tag]];
    menulabel_trial.text=[MyClass returntitlewithtitle:[tableoptionarray objectAtIndex:menulabel_trial.tag]];
    menulabel_coupon.text=[MyClass returntitlewithtitle:[tableoptionarray objectAtIndex:menulabel_coupon.tag]];
    

    [scactiveoption_enrollment removeAllSegments];
    [scactiveoption_class removeAllSegments];
    
    for (int i=0; i<activedraftarray_enrollment.count; i++) {
        [scactiveoption_enrollment insertSegmentWithTitle:[MyClass returntitlewithtitle:[activedraftarray_enrollment objectAtIndex:i]] atIndex:i animated:NO];
    }
    
    for (int i=0; i<activedraftarray_class.count; i++) {
        [scactiveoption_class insertSegmentWithTitle:[MyClass returntitlewithtitle:[activedraftarray_class objectAtIndex:i]] atIndex:i animated:NO];
    }
//    scactiveoption_enrollment=[[UISegmentedControl alloc]initWithItems:activedraftarray_enrollment];
//    [scactiveoption_enrollment setFrame:CGRectMake(selfViewWidth-299, 2, 282, 29)];
    scactiveoption_enrollment.selectedSegmentIndex=0;
    scactiveoption_enrollment.tintColor=themecolor;
    [scactiveoption_enrollment addTarget:self action:@selector(selectactive:) forControlEvents: UIControlEventValueChanged];
//    [EnrollmentClassMenuView addSubview:scactiveoption_enrollment];
    
//    scactiveoption_class=[[UISegmentedControl alloc]initWithItems:activedraftarray_class];
//    [scactiveoption_class setFrame:CGRectMake(selfViewWidth-204, 2, 187, 29)];
    scactiveoption_class.selectedSegmentIndex=0;
    scactiveoption_class.tintColor=themecolor;
    [scactiveoption_class addTarget:self action:@selector(selectactive:) forControlEvents: UIControlEventValueChanged];
//    [EnrollmentClassMenuView addSubview:scactiveoption_class];
    
//    DaySelectionButton=[[UIButton alloc]init];
    [DaySelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    DaySelectionButton.backgroundColor=themecolor;
//    DaySelectionButton.titleLabel.font=[UIFont systemFontOfSize:14];
    DaySelectionButton.layer.cornerRadius=5;
    [DaySelectionButton addTarget: self action:@selector(selectday:) forControlEvents: UIControlEventTouchUpInside];
//    [EnrollmentClassMenuView addSubview:DaySelectionButton];
    [self drawpointerwithoption:@"closed" imageview:dayselectionarrow];

//    TypeSelectionButton=[[UIButton alloc]initWithFrame:CGRectMake(selfViewWidth-371, 2, 165, 29)];
    [TypeSelectionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    TypeSelectionButton.backgroundColor=themecolor;
//    TypeSelectionButton.titleLabel.font=[UIFont systemFontOfSize:14];
    TypeSelectionButton.layer.cornerRadius=5;
    [TypeSelectionButton addTarget: self action:@selector(selecttype:) forControlEvents: UIControlEventTouchUpInside];
//    [EnrollmentClassMenuView addSubview:TypeSelectionButton];
    [self drawpointerwithoption:@"closed" imageview:typeselectionarrow];

    
}

-(void) loadstudentview
{
    

    //Switch
    swflag.onTintColor=themecolor;
    [swflag addTarget:self action:@selector(flagStudent:) forControlEvents:UIControlEventValueChanged];
    swinactive.onTintColor=themecolor;
    [swinactive addTarget:self action:@selector(deactiveStudent:) forControlEvents:UIControlEventValueChanged];
    swpromotionalmessage.onTintColor=themecolor;
    [swpromotionalmessage addTarget:self action:@selector(promotionStudent:) forControlEvents:UIControlEventValueChanged];
    swsendmessage.onTintColor=themecolor;
    [swsendmessage addTarget:self action:@selector(sendMessageStudent:) forControlEvents:UIControlEventValueChanged];
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhotoDetected:)];
    [tapped setNumberOfTapsRequired:1];
    [viewstudentimage addGestureRecognizer:tapped];
}

-(void) loadImageFullScreenView
{
//    photofullscreenview=[[UIView alloc]initWithFrame:CGRectMake(0, 64, selfViewWidth, self.view.bounds.size.height-64)];
    photofullscreenview.backgroundColor=[UIColor systemGroupedBackgroundColor];
//    [MasterView addSubview:photofullscreenview];
    
    fullscreen_closebutton=[[UIButton alloc]initWithFrame:CGRectMake(20, 20, 25, 25)];
    [fullscreen_closebutton setImage:[UIImage imageNamed:@"closescreengray_icon.png"] forState:UIControlStateNormal];
    [fullscreen_closebutton addTarget:self action:@selector(closefullscreen) forControlEvents:UIControlEventTouchUpInside];
    [photofullscreenview addSubview:fullscreen_closebutton];
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(10, photofullscreenview.frame.size.height-40-([studentAction isEqualToString:@"PopoverStudent"]?15*0:0), photofullscreenview.frame.size.width-20, 0.5)];
    separator.backgroundColor=[UIColor grayColor];
    [photofullscreenview addSubview:separator];
    
    shareimageview=[[UIImageView alloc]initWithFrame:CGRectMake(20, separator.frame.origin.y+10, 20, 20)];
    [shareimageview setImage:[UIImage imageNamed:@"photosharebutton.png"]];
    [photofullscreenview addSubview:shareimageview];
    
    shareimagebutton=[[UIButton alloc]init];
    [shareimagebutton setTitle:[MyClass returntitlewithtitle:@"Share"] forState:UIControlStateNormal];
    shareimagebutton.titleLabel.font=[UIFont systemFontOfSize:14];
    [shareimagebutton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [shareimagebutton addTarget:self action:@selector(sharebuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [photofullscreenview addSubview:shareimagebutton];
    
    [shareimagebutton setFrame:CGRectMake(0, separator.frame.origin.y, self.view.bounds.size.width/3, 40)];
    [shareimagebutton sizeToFit];
    //shareview.frame=CGRectMake((self.view.bounds.size.width/3-sharebutton.frame.size.width-30)/2, separator.frame.origin.y+7.5, 20, 20);
    [shareimagebutton setFrame:CGRectMake(45, separator.frame.origin.y, shareimagebutton.frame.size.width, 40)];
    //sharebutton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    
    
    fullscreen_studentname=[[UILabel alloc]initWithFrame:CGRectMake(10, photofullscreenview.frame.size.height-40-([studentAction isEqualToString:@"PopoverStudent"]?15*0:0), photofullscreenview.frame.size.width-20, 30)];
    fullscreen_studentname.numberOfLines=0;
    fullscreen_studentname.minimumScaleFactor=0.7;
    fullscreen_studentname.adjustsFontSizeToFitWidth=YES;
    fullscreen_studentname.textColor=[UIColor grayColor];
    fullscreen_studentname.font=[UIFont systemFontOfSize:13];
    [photofullscreenview addSubview:fullscreen_studentname];
    photofullscreenview.hidden=YES;
}

-(void) loadclassview
{
    /*ClassRecordView=[[UIView alloc]initWithFrame:CGRectMake(13, 150, selfViewWidth-13, self.view.bounds.size.height-170)];
    ClassRecordView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [MasterView addSubview:ClassRecordView];*/
    
    //Title
    /*class_header_subject = [[UILabel alloc]init];
    class_header_subject.font=[UIFont boldSystemFontOfSize:13];
    class_header_subject.textColor=[UIColor blackColor];
    [ClassRecordView addSubview:class_header_subject];

    class_header_level = [[UILabel alloc]init];
    class_header_level.font=[UIFont boldSystemFontOfSize:13];
    class_header_level.textColor=[UIColor blackColor];
    [ClassRecordView addSubview:class_header_level];
    
    class_header_start = [[UILabel alloc]init];
    class_header_start.font=[UIFont boldSystemFontOfSize:13];
    class_header_start.textColor=[UIColor blackColor];
    [ClassRecordView addSubview:class_header_start];
    
    class_header_day = [[UILabel alloc]init];
    class_header_day.font=[UIFont boldSystemFontOfSize:13];
    class_header_day.textColor=[UIColor blackColor];
    [ClassRecordView addSubview:class_header_day];
    
    class_header_time = [[UILabel alloc]init];
    class_header_time.font=[UIFont boldSystemFontOfSize:13];
    class_header_time.textColor=[UIColor blackColor];
    [ClassRecordView addSubview:class_header_time];
    
    class_header_instructor = [[UILabel alloc]init];
    class_header_instructor.font=[UIFont boldSystemFontOfSize:13];
    class_header_instructor.textColor=[UIColor blackColor];
    [ClassRecordView addSubview:class_header_instructor];
    
    class_header_classroom = [[UILabel alloc]init];
    class_header_classroom.font=[UIFont boldSystemFontOfSize:13];
    class_header_classroom.textColor=[UIColor blackColor];
    [ClassRecordView addSubview:class_header_classroom];
    
    class_header_attendance = [[UILabel alloc]init];
    class_header_attendance.font=[UIFont boldSystemFontOfSize:13];
    class_header_attendance.textColor=[UIColor blackColor];
    class_header_attendance.textAlignment=NSTextAlignmentRight;
    [ClassRecordView addSubview:class_header_attendance];
    
    class_header_makeupdetails = [[UILabel alloc]init];
    class_header_makeupdetails.font=[UIFont boldSystemFontOfSize:13];
    class_header_makeupdetails.textColor=[UIColor blackColor];
    [ClassRecordView addSubview:class_header_makeupdetails];
    
    class_header_extendedtime = [[UILabel alloc]init];
    class_header_extendedtime.font=[UIFont boldSystemFontOfSize:13];
    class_header_extendedtime.textColor=[UIColor blackColor];
    [ClassRecordView addSubview:class_header_extendedtime];*/
    
    if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
        class_header_extendedtime.hidden=YES;
    }
    
/*
    class_header_remarks = [[UILabel alloc]init];
    class_header_remarks.font=[UIFont boldSystemFontOfSize:13];
    class_header_remarks.textColor=[UIColor blackColor];
    [ClassRecordView addSubview:class_header_remarks];*/
    
    
    
    
    

    
    //Table
    /*DetailsViewClassTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 38+38, selfViewWidth-13, ClassRecordView.frame.size.height-38-38) style:UITableViewStylePlain];
    DetailsViewClassTable.delegate=self;
    DetailsViewClassTable.dataSource=self;*/
    DetailsViewClassTable.sectionHeaderHeight=0;
    if ([DetailsViewClassTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        DetailsViewClassTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    
    /*classsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 38, selfViewWidth-13-38, 38)];*/
    classsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    //classsearchbar.delegate=self;
    //[ClassRecordView addSubview:classsearchbar];
    
    /*classsortbutton=[[UIButton alloc]initWithFrame:CGRectMake(classsearchbar.frame.origin.x+classsearchbar.frame.size.width, classsearchbar.frame.origin.y, 38, 38)];
    classsortbutton.backgroundColor=[UIColor lightGrayColor];
    [classsortbutton setImage:[UIImage imageNamed:@"sortingbutton.png"] forState:UIControlStateNormal];
    [classsortbutton addTarget:self action:@selector(sortingbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [classsortbutton setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [ClassRecordView addSubview:classsortbutton];*/
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    //tablerefresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [tablerefresh addTarget:self action:@selector(refreshclasstable) forControlEvents:UIControlEventValueChanged];
    [DetailsViewClassTable addSubview:tablerefresh];
    
}

-(void) refreshclasstableheader
{
    class_header_subject.text=[MyClass returntitlewithtitle:@"Subject"];
    class_header_start.text=[MyClass returntitlewithtitle:@"Date"];
    class_header_level.text=globalvariables.centerrecord.enablelessonnumber?[MyClass returntitlewithtitle:@"Level/Lesson"]:[MyClass returntitlewithtitle:@"Level"];
    class_header_time.text=[MyClass returntitlewithtitle:@"Time"];
    class_header_instructor.text=[MyClass returntitlewithtitle:@"Instructor"];
    class_header_classroom.text=[MyClass returntitlewithtitle:@"Classroom"];
    class_header_day.text=[MyClass returntitlewithtitle:@"Day"];
    class_header_attendance.text=[MyClass returntitlewithtitle:@"Attendance"];
    class_header_remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    class_header_makeupdetails.text=[MyClass returntitlewithtitle:@"Makeup Details"];
    class_header_extendedtime.text=[MyClass returntitlewithtitle:@"Extended Time"];
}




-(void) refreshclasstable
{
    [self retrieveClassWithEnrollmentkey:DetailsViewEnrollment.enrollmentkey];
    [self highlightduebuttonwithreloadstudentlist:YES];
    for (id object in [DetailsViewClassTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) loadenrollmentview
{
    //EnrollmentRecordView=[[UIView alloc]initWithFrame:CGRectMake(13, 150, selfViewWidth-13, self.view.bounds.size.height-170)];
    //EnrollmentRecordView.backgroundColor=[UIColor systemGroupedBackgroundColor];
    //[MasterView addSubview:EnrollmentRecordView];
    
    //combinepaymentbutton=[[UIButton alloc]initWithFrame:CGRectMake(EnrollmentRecordView.frame.size.width-38, 0,38 , 38)];
    //[combinepaymentbutton setImageEdgeInsets:UIEdgeInsetsMake(4,4, 4, 4)];
    //combinepaymentbutton.backgroundColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:0.2];
    //[combinepaymentbutton setImage:[UIImage imageNamed:@"addtofolder_icon.png"] forState:UIControlStateNormal];
    //[combinepaymentbutton addTarget: self action:@selector(combinepaymentbuttonpressed) forControlEvents: UIControlEventTouchUpInside];
    //[EnrollmentRecordView addSubview:combinepaymentbutton];
    
    //Title
    /*enrollment_header_subject = [[UILabel alloc]init];
    enrollment_header_subject.font=[UIFont boldSystemFontOfSize:13];
    enrollment_header_subject.textColor=[UIColor blackColor];
    [EnrollmentRecordView addSubview:enrollment_header_subject];
    
    enrollment_header_start = [[UILabel alloc]init];
    enrollment_header_start.font=[UIFont boldSystemFontOfSize:13];
    enrollment_header_start.textColor=[UIColor blackColor];
    [EnrollmentRecordView addSubview:enrollment_header_start];
    
    enrollment_header_level = [[UILabel alloc]init];
    enrollment_header_level.font=[UIFont boldSystemFontOfSize:13];
    enrollment_header_level.textColor=[UIColor blackColor];
    enrollment_header_level.minimumScaleFactor=0.5;
    enrollment_header_level.adjustsFontSizeToFitWidth=YES;
    [EnrollmentRecordView addSubview:enrollment_header_level];
    
    enrollment_header_time = [[UILabel alloc]init];
    enrollment_header_time.font=[UIFont boldSystemFontOfSize:13];
    enrollment_header_time.textColor=[UIColor blackColor];
    [EnrollmentRecordView addSubview:enrollment_header_time];
    
    enrollment_header_instructor = [[UILabel alloc]init];
    enrollment_header_instructor.font=[UIFont boldSystemFontOfSize:13];
    enrollment_header_instructor.textColor=[UIColor blackColor];
    [EnrollmentRecordView addSubview:enrollment_header_instructor];

    enrollment_header_classroom = [[UILabel alloc]init];
    enrollment_header_classroom.font=[UIFont boldSystemFontOfSize:11];
    enrollment_header_classroom.textColor=[UIColor blackColor];
    [EnrollmentRecordView addSubview:enrollment_header_classroom];
    
    enrollment_header_day = [[UILabel alloc]init];
    enrollment_header_day.font=[UIFont boldSystemFontOfSize:13];
    enrollment_header_day.textColor=[UIColor blackColor];
    [EnrollmentRecordView addSubview:enrollment_header_day];
    
    enrollment_header_noofclass = [[UILabel alloc]init];
    enrollment_header_noofclass.font=[UIFont boldSystemFontOfSize:12];
    enrollment_header_noofclass.numberOfLines=0;
    enrollment_header_noofclass.textColor=[UIColor blackColor];
    [EnrollmentRecordView addSubview:enrollment_header_noofclass];
    
    
    enrollment_header_end = [[UILabel alloc]init];
    enrollment_header_end.font=[UIFont boldSystemFontOfSize:13];
    enrollment_header_end.textColor=[UIColor blackColor];
    [EnrollmentRecordView addSubview:enrollment_header_end];
    
    enrollment_header_remarks = [[UILabel alloc]init];
    enrollment_header_remarks.font=[UIFont boldSystemFontOfSize:13];
    enrollment_header_remarks.textColor=[UIColor blackColor];
    [EnrollmentRecordView addSubview:enrollment_header_remarks];*/
    
    //Table
    //DetailsViewEnrollmentTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 38+38, selfViewWidth-13, EnrollmentRecordView.frame.size.height-38-38) style:UITableViewStylePlain];
    //DetailsViewEnrollmentTable.delegate=self;
    //DetailsViewEnrollmentTable.dataSource=self;
    //DetailsViewEnrollmentTable.sectionHeaderHeight=0;
    if ([DetailsViewEnrollmentTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        DetailsViewEnrollmentTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    //[EnrollmentRecordView addSubview:DetailsViewEnrollmentTable];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(enrollmentTableLongPress:)];
    //lpgr.minimumPressDuration = 2.0; //seconds
    lpgr.delegate = self;
    [DetailsViewEnrollmentTable addGestureRecognizer:lpgr];
    
    
    //enrollmentsearchbar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 38, selfViewWidth-13-38, 38)];
    enrollmentsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    //enrollmentsearchbar.delegate=self;
    //[EnrollmentRecordView addSubview:enrollmentsearchbar];
    
    //enrollmentsortbutton=[[UIButton alloc]initWithFrame:CGRectMake(enrollmentsearchbar.frame.origin.x+enrollmentsearchbar.frame.size.width, enrollmentsearchbar.frame.origin.y, 38, 38)];
    //enrollmentsortbutton.backgroundColor=[UIColor lightGrayColor];
    //[enrollmentsortbutton setImage:[UIImage imageNamed:@"sortingbutton.png"] forState:UIControlStateNormal];
    //[enrollmentsortbutton addTarget:self action:@selector(sortingbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    //[enrollmentsortbutton setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    //[EnrollmentRecordView addSubview:enrollmentsortbutton];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshenrollmenttable) forControlEvents:UIControlEventValueChanged];
    [DetailsViewEnrollmentTable addSubview:tablerefresh];
    
}

-(void) refreshenrollmenttableheader
{
    //long combinepaymentoffset=isSelectCombinePayment?30:0;
    
    enrollment_header_leadingconstraint.constant=isSelectCombinePayment?43:13;

    
    enrollment_header_subject.text=[MyClass returntitlewithtitle:@"Subject"];
    enrollment_header_start.text=[MyClass returntitlewithtitle:@"Start"];
    enrollment_header_level.text=[MyClass returntitlewithtitle:@"Level"];
    enrollment_header_time.text=[MyClass returntitlewithtitle:@"Time"];
    enrollment_header_instructor.text=[MyClass returntitlewithtitle:@"Instructor"];
    enrollment_header_classroom.text=[MyClass returntitlewithtitle:@"Classroom"];
    enrollment_header_day.text=[MyClass returntitlewithtitle:@"Day"];
    enrollment_header_noofclass.text=[MyClass returntitlewithtitle:@"No. of Class"];
    [enrollment_header_noofclass sizeToFit];

    
    enrollment_header_end.text=[MyClass returntitlewithtitle:@"End"];
    enrollment_header_remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
}

-(void) refreshenrollmenttable
{
    [self retrieveEnrollmentWithStudentkey:DetailsViewStudent.studentkey];
    [self highlightduebuttonwithreloadstudentlist:YES];
    for (id object in [DetailsViewEnrollmentTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshcoupontable
{
    [self retrieveCouponRecord];
    [self highlightduebuttonwithreloadstudentlist:YES];
    for (id object in [couponTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshsalestable
{
    [self retrieveSalesRecord];
    [self highlightduebuttonwithreloadstudentlist:YES];
    for (id object in [SalesTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshmessagetable
{
    [self retrieveMessageRecord];
    [self highlightduebuttonwithreloadstudentlist:YES];
    for (id object in [DetailsViewMessageTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshcalllogtable
{
    [self retrieveCallLogRecord];
    [self highlightduebuttonwithreloadstudentlist:YES];
    for (id object in [CallLogTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshdttable
{
    [self retrieveDTWithSubject:dtsubjectselected studentkey:DetailsViewStudent.studentkey classtype:dttypeselected];
    [self highlightduebuttonwithreloadstudentlist:YES];
    for (id object in [DetailsViewDTTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) passfreeclassscheduleforclassmove:(FreeScheduleClass *)freescheduleclass remarks:(NSString *)remarks
{
    //delegate not being used
}

-(long) returnbuttonpositionwithtag:(long)buttontag
{
    long position=buttontag;
    for (long i=buttontag-1; i>=0; i--) {
        if ([[tableoptionviewarray objectAtIndex:i] isEqualToString:@"0"]) {
            position-=1;
        }
    }
    return position;
}

-(UIButton *) returnmenubuttonwithtagnumber:(long)buttontag
{
    UIButton *button=[[UIButton alloc]init];
    button.tag=buttontag;
    return button;
    /*for (id object in [TopMenuView subviews]) {
        if ([object isKindOfClass:[UIButton class]]) {
            if (((UIButton *)object).tag==buttontag) {
                return object;
            }
        }
    }
    return nil;*/
}

-(void) highlighttableoptionbuttonwithbuttontag:(long)buttontag
{
    menulabel_student.textColor=(buttontag==menulabel_student.tag)?[UIColor yellowColor]:(showstudentpage?[UIColor whiteColor]:[UIColor lightGrayColor]);
    menulabel_enrollment.textColor=(buttontag==menulabel_enrollment.tag)?[UIColor yellowColor]:[UIColor whiteColor];
    menulabel_class.textColor=(buttontag==menulabel_class.tag)?[UIColor yellowColor]:[UIColor whiteColor];
    menulabel_sales.textColor=(buttontag==menulabel_sales.tag)?[UIColor yellowColor]:[UIColor whiteColor];
    menulabel_messages.textColor=(buttontag==menulabel_messages.tag)?[UIColor yellowColor]:[UIColor whiteColor];
    menulabel_calllog.textColor=(buttontag==menulabel_calllog.tag)?[UIColor yellowColor]:[UIColor whiteColor];
    menulabel_trial.textColor=(buttontag==menulabel_trial.tag)?[UIColor yellowColor]:[UIColor whiteColor];
    menulabel_coupon.textColor=(buttontag==menulabel_coupon.tag)?[UIColor yellowColor]:[UIColor whiteColor];
}

-(void) highlightduebuttonwithreloadstudentlist:(BOOL)reload
{
    [self.delegate updatestudentinformationlist:DetailsViewStudent.studentkey reloadlist:reload];
    
    DetailsViewStudent=[MyClass retrieveStudent:DetailsViewStudent.studentkey];
    menuimage_enrollment.hidden=![DetailsViewStudent.due isEqualToString:@"B"] && ![DetailsViewStudent.due isEqualToString:@"C"];
    menuimage_sales.hidden=![DetailsViewStudent.due isEqualToString:@"B"] && ![DetailsViewStudent.due isEqualToString:@"S"];
    menuimage_coupon.hidden=[DetailsViewStudent.validcouponcount integerValue]==0;
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}

-(void) dismissPointViewWithReload:(BOOL)reload
{
    runviewdidappear=FALSE;
    if(reload){
        [self retrieveStudent:DetailsViewStudent.studentkey];
    }
}


-(void) cancelStudent{
    runviewdidappear=FALSE;
    [self.delegate donotrunviewdidappearinstudentinformation];
    if ([studentAction isEqualToString:@"AddDTStudent"] || [studentAction isEqualToString:@"EnrollLead"] || [studentAction isEqualToString:@"EnrollATLeadStudent"] || [studentAction isEqualToString:@"AddNewStudent"] || [studentAction isEqualToString:@"AddStudentAndSubject"]) {
        studentAction=nil;
        ViewStudent.hidden=YES;
        TopMenuView.hidden=YES;
        systemMessageView.hidden=NO;
//        self.navigationItem.leftBarButtonItem=nil;
//        self.navigationItem.rightBarButtonItem=nil;

    }else if ([studentAction isEqualToString:@"EditStudent"]) {
        studentAction=@"ViewStudent";
    }
    
    systemMessageLabel.text=[MyClass returntitlewithtitle:@"Select student or press + to add new"];
    [self.delegate enableAddStudentButton];
    
}

-(void) switchcenterbuttonpressed
{
    [self stopAudioPlaying];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    [self showviewhistory:FALSE];
    
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

    
    
    if (!firstload) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        studentAction=nil;
        photofullscreenview.hidden=YES;

    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,product,staff,classroom,marketing,centersettings,userroleandprivilege,student,lead,arcode" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
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

                    [self refreshlanguage];
                    [MyClass updatecenterkey];
                    
                    //self.navigationItem.leftBarButtonItem=nil;
                    //self.navigationItem.rightBarButtonItem=nil;
                    
                    isSelectCombinePayment=FALSE;

                    
                    globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys=[[NSMutableArray alloc]init];
                    globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys=[[NSMutableArray alloc]init];
                    globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys=[[NSMutableArray alloc]init];
                    globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys=[[NSMutableArray alloc]init];
                    globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys=[[NSMutableArray alloc]init];
                    globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys=[[NSMutableArray alloc]init];
                    
                    [self refreshdocumentfoldercount];
                    
                    if (((CenterRecord *)[MyClass returncenterrecordwithcenterkey:globalvariables.centerrecord.centerkey]).enableattendanceextend) {
                        typearray=[[NSArray alloc]initWithObjects:@"All Types",@"Makeup",@"Extended",@"Absent",nil];
                    }else{
                        typearray=[[NSArray alloc]initWithObjects:@"All Types",@"Makeup",@"Absent",nil];
                    }
                    
                    fcmemberidstack.hidden=[((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@""];
                    ddastackview.hidden=!globalvariables.centerrecord.ddaenabled;
                    extrafield1stack.hidden=!globalvariables.centerrecord.studentextrafield1;
                    extrafield2stack.hidden=[globalvariables.centerrecord.studentextrafield2 isEqualToString:@""];
                    extrafieldstack.hidden=extrafield1stack.hidden && extrafield2stack.hidden;
                    
//                    if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
//                        //makeupabsentarray=[[NSArray alloc]initWithObjects:@"All",@"Absent",nil];
//                        tableoptionviewarray=[[NSMutableArray alloc]initWithObjects:@"1",@"1",@"1",@"0",@"1",@"1",@"0",globalvariables.centerrecord.ecoupon?@"1":@"0", nil];
//                        activedraftarray=[[NSArray alloc]initWithObjects:@"All",@"Active",@"Draft", nil];
//                        
//                        [scactiveoption setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
//                        [scactiveoption setTitle:[MyClass returntitlewithtitle:@"studentprofile_Active"] forSegmentAtIndex:1];
//                        [scactiveoption setTitle:[MyClass returntitlewithtitle:@"Draft"] forSegmentAtIndex:2];
//                        
//                        studentview_school_label.hidden=YES;
//                        schoollabel.hidden=YES;
//                        studentview_media_label.hidden=YES;
//                        studentview_source_label.hidden=YES;
//                        studentmedialabel.hidden=YES;
//                        studentsourcelabel.hidden=YES;
//                        
//                    }else{
                        
                    [self loadscactiveoption];
//                        if (scactiveoption.numberOfSegments>3) {
//                            [scactiveoption setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
//                            [scactiveoption setTitle:[MyClass returntitlewithtitle:@"studentprofile_Active"] forSegmentAtIndex:1];
//                            [scactiveoption setTitle:[MyClass returntitlewithtitle:@"Due"] forSegmentAtIndex:2];
//                            [scactiveoption setTitle:[MyClass returntitlewithtitle:@"Voided"] forSegmentAtIndex:3];
//                        }else{
//                            [scactiveoption setTitle:[MyClass returntitlewithtitle:@"All"] forSegmentAtIndex:0];
//                            [scactiveoption setTitle:[MyClass returntitlewithtitle:@"studentprofile_Active"] forSegmentAtIndex:1];
//                            [scactiveoption setTitle:[MyClass returntitlewithtitle:@"Assessment"] forSegmentAtIndex:2];
//                        }
                        
                        studentview_school_label.hidden=NO;
                        schoollabel.hidden=NO;
                        studentview_media_label.hidden=NO;
                        studentview_source_label.hidden=NO;
                        studentmedialabel.hidden=NO;
                        studentsourcelabel.hidden=NO;
                        
//                    }
                    
//
//                    eyelevelhqview.hidden=YES;
//
//


                    regularattendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnregularattendancebuttonarray]];
                    
                    if (!studentAction) {
                        ViewStudent.hidden=YES;
                        TopMenuView.hidden=YES;
                        EnrollmentClassMenuView.hidden=YES;
                        EnrollmentRecordView.hidden=YES;
                        ClassRecordView.hidden=YES;
                        MessageView.hidden=YES;
                        SalesView.hidden=YES;
                        CouponView.hidden=YES;
                        CallLogView.hidden=YES;
                        DTRecordView.hidden=YES;
                        systemMessageView.hidden=NO;
                        [self showviewhistory:YES];
                        //viewhistoryarray=[MyClass returnViewHistoryWithType:@"student"];
                        //[ViewHistoryTable reloadData];
                        //viewhistoryimageview.hidden=NO;
                        documentfolderbutton.hidden=YES;
                        //documentfoldercountlabel.hidden=YES;
                        dayselected=@"All";
//                        self.navigationItem.leftBarButtonItem=nil;
//                        self.navigationItem.rightBarButtonItem=nil;
                        
                    }else if ([studentAction isEqualToString:@"Redirect"]) {
                        /*ViewStudent.hidden=NO;
                        TopMenuView.hidden=NO;
                        EnrollmentClassMenuView.hidden=YES;
                        EnrollmentRecordView.hidden=YES;
                        ClassRecordView.hidden=YES;
                        MessageView.hidden=YES;
                        SalesView.hidden=YES;
                        CallLogView.hidden=YES;
                        DTRecordView.hidden=YES;*/
                        systemMessageView.hidden=YES;
                        documentfolderbutton.hidden=YES;
                        //documentfoldercountlabel.hidden=YES;
                        dayselected=@"All";
                    }else if ([studentAction isEqualToString:@"ViewStudent"]) {
                        ViewStudent.hidden=NO;
                        TopMenuView.hidden=NO;
                        EnrollmentClassMenuView.hidden=YES;
                        EnrollmentRecordView.hidden=YES;
                        ClassRecordView.hidden=YES;
                        MessageView.hidden=YES;
                        SalesView.hidden=YES;
                        CouponView.hidden=YES;
                        CallLogView.hidden=YES;
                        DTRecordView.hidden=YES;
                        systemMessageView.hidden=YES;
                        documentfolderbutton.hidden=YES;
                        //documentfoldercountlabel.hidden=YES;
                        dayselected=@"All";
                    }else if ([studentAction isEqualToString:@"PopoverStudent"]) {
                        
                        //if(DetailsViewStudent.studentkey){
                            [MyClass insertViewHistoryWithType:@"student" Typekey:DetailsViewStudent.studentkey Name:@"" IDNumber:@"" Gender:@""];
                        //}
                        
                        viewhistorybutton.hidden=YES;
                        
                        if (selectedDTkey && ![selectedDTkey isEqualToString:@""]) {
                            ViewStudent.hidden=YES;
                            TopMenuView.hidden=NO;
                            EnrollmentClassMenuView.hidden=YES;
                            EnrollmentRecordView.hidden=YES;
                            ClassRecordView.hidden=YES;
                            MessageView.hidden=YES;
                            SalesView.hidden=YES;
                            CouponView.hidden=YES;
                            CallLogView.hidden=YES;
                            DTRecordView.hidden=NO;
                            systemMessageLabel.text=@"";
                            systemMessageView.hidden=YES;
                            [self highlighttableoptionbuttonwithbuttontag:6];
                            lastviewindex=6;
                            dtsubjectselected=@"All";
                            [self retrieveDTWithSubject:dtsubjectselected studentkey:DetailsViewStudent.studentkey classtype:@"All"];
                            
                            [DetailsViewClassTable removeGestureRecognizer:panGesture];
                            [DetailsViewDTTable addGestureRecognizer:panGesture];
                            
                            
                        }else if (selectedClasskey){
                            ViewStudent.hidden=YES;
                            TopMenuView.hidden=NO;
                            EnrollmentClassMenuView.hidden=NO;
                            EnrollmentRecordView.hidden=YES;
                            ClassRecordView.hidden=NO;
                            MessageView.hidden=YES;
                            SalesView.hidden=YES;
                            CouponView.hidden=YES;
                            CallLogView.hidden=YES;
                            DTRecordView.hidden=YES;
                            //systemMessageLabel.text=@"";
                            //systemMessageView.hidden=YES;
                            [self highlighttableoptionbuttonwithbuttontag:2];
                            lastviewindex=2;

                            lastactivedraftindex_class=0;
                            [self createClassViewNavigationButton];
                            
                            
                            TypeSelectionButton.hidden=NO;
                            typeselectionarrow.hidden=NO;
//                            DaySelectionButton.frame=CGRectMake(selfViewWidth-501, 2, 129, 29);
                            scactiveoption_class.hidden=NO;
                            scactiveoption_enrollment.hidden=YES;
//                            scactiveoption_class.frame=CGRectMake(selfViewWidth-204, 2, 187, 29);
//                            scactiveoption_enrollment.frame=scactiveoption_class.frame;
                            
//                            [self loadscactiveoption];
//                            if (scactiveoption.numberOfSegments>3) {
//                                [scactiveoption removeSegmentAtIndex:3 animated:NO];
//                                [scactiveoption removeSegmentAtIndex:3 animated:NO];
//                            }
                            
                            
                            [self drawpointerwithoption:@"closed" imageview:dayselectionarrow];
                            
                            dayselected=@"All";
                            
                            subjectselected=@"All";
                            [self retrieveClassWithEnrollmentkey:nil];
                            
                            [DetailsViewDTTable removeGestureRecognizer:panGesture];
                            [DetailsViewClassTable addGestureRecognizer:panGesture];
                            systemMessageLabel.text=@"";
                            systemMessageView.hidden=YES;
                        }else if (selectedEnrollmentkey){
                            ViewStudent.hidden=YES;
                            TopMenuView.hidden=NO;
                            EnrollmentClassMenuView.hidden=NO;
                            EnrollmentRecordView.hidden=NO;
                            ClassRecordView.hidden=YES;
                            MessageView.hidden=YES;
                            SalesView.hidden=YES;
                            CouponView.hidden=YES;
                            CallLogView.hidden=YES;
                            DTRecordView.hidden=YES;
                            [self highlighttableoptionbuttonwithbuttontag:1];
                            lastviewindex=1;
                            scactiveoption_enrollment.selectedSegmentIndex=0;
                            lastactivedraftindex_enrollment=0;
                            [self createEnrollmentViewNavigationButton];
                            
                            
                            TypeSelectionButton.hidden=YES;
                            typeselectionarrow.hidden=YES;
//                            DaySelectionButton.frame=CGRectMake(selfViewWidth-501, 2, 200.5, 29);
//                            scactiveoption_enrollment.frame=CGRectMake(selfViewWidth-299, 2, 282, 29);
//                            scactiveoption_class.frame=scactiveoption_class.frame;
                            scactiveoption_class.hidden=YES;
                            scactiveoption_enrollment.hidden=NO;
                            
                            [self loadscactiveoption];
//                            if (scactiveoption.numberOfSegments==3) {
//                                [scactiveoption insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Due"] atIndex:3 animated:NO];
//                                [scactiveoption insertSegmentWithTitle:[MyClass returntitlewithtitle:@"Voided"] atIndex:4 animated:NO];
//                            }
                            
                            [self drawpointerwithoption:@"closed" imageview:dayselectionarrow];
                            
                            dayselected=@"All";
                            
                            subjectselected=@"All";
                            //[self retrieveClassWithSubject:@"All" day:@"All" activedraft:@"All" makeupabsent:@"All" Enrollmentkey:nil];
                            
                            [self retrieveEnrollmentWithStudentkey:DetailsViewStudent.studentkey];
       
                            
                        
                            [DetailsViewDTTable removeGestureRecognizer:panGesture];
                            [DetailsViewClassTable removeGestureRecognizer:panGesture];
                            systemMessageLabel.text=@"";
                            systemMessageView.hidden=YES;
                        }else if (selectedSaleskey){
                            ViewStudent.hidden=YES;
                            TopMenuView.hidden=NO;
                            EnrollmentClassMenuView.hidden=YES;
                            EnrollmentRecordView.hidden=YES;
                            ClassRecordView.hidden=YES;
                            MessageView.hidden=YES;
                            SalesView.hidden=NO;
                            CouponView.hidden=YES;
                            CallLogView.hidden=YES;
                            DTRecordView.hidden=YES;
                            [self highlighttableoptionbuttonwithbuttontag:3];
                            lastviewindex=3;
                            [self createSalesViewNavigationButton];
                            
                            productcategoryselected=@"All";
                            //sceventselection.selectedSegmentIndex=0;
                            
                            [self retrieveSalesRecord];

                            systemMessageLabel.text=@"";
                            systemMessageView.hidden=YES;
                        }else{
                            ViewStudent.hidden=YES;
                            TopMenuView.hidden=NO;
                            EnrollmentClassMenuView.hidden=NO;
                            EnrollmentRecordView.hidden=NO;
                            ClassRecordView.hidden=YES;
                            MessageView.hidden=YES;
                            SalesView.hidden=YES;
                            CouponView.hidden=YES;
                            CallLogView.hidden=YES;
                            DTRecordView.hidden=YES;
                            systemMessageLabel.text=@"";
                            systemMessageView.hidden=YES;
                            [self highlighttableoptionbuttonwithbuttontag:1];
                            //sctableoption.selectedSegmentIndex=1;
                            lastviewindex=1;
                            scactiveoption_enrollment.selectedSegmentIndex=0;
                            lastactivedraftindex_enrollment=0;
                            
                            
                            TypeSelectionButton.hidden=NO;
                            typeselectionarrow.hidden=NO;
                            //scdayoption.frame=CGRectMake(203, 2, 279, 29);
//                            DaySelectionButton.frame=CGRectMake(selfViewWidth-501, 2, 129, 29);
//                            scactiveoption_enrollment.frame=CGRectMake(selfViewWidth-204, 2, 187, 29);
//                            scactiveoption_class.frame=scactiveoption_class.frame;
                            scactiveoption_class.hidden=NO;
                            scactiveoption_enrollment.hidden=YES;
                            [self drawpointerwithoption:@"closed" imageview:dayselectionarrow];
                            
                            
                            dayselected=@"All";
                            subjectselected=@"All";
                            [self retrieveEnrollmentWithStudentkey:DetailsViewStudent.studentkey];
                            
                            [DetailsViewEnrollmentTable removeGestureRecognizer:panGesture];
                            [DetailsViewClassTable addGestureRecognizer:panGesture];
                        }
                        [self highlightduebuttonwithreloadstudentlist:YES];
                    }else if ([studentAction isEqualToString:@"AddDTStudent"] || [studentAction isEqualToString:@"EnrollLead"] || [studentAction isEqualToString:@"EnrollATLeadStudent"] /*|| [studentAction isEqualToString:@"AddStudentAndSubject"]*/){
                        if (![DetailsViewStudent.studentkey isEqualToString:@""]) {
                            ViewStudent.hidden=NO;
                            TopMenuView.hidden=NO;
                            EnrollmentClassMenuView.hidden=YES;
                            EnrollmentRecordView.hidden=YES;
                            ClassRecordView.hidden=YES;
                            MessageView.hidden=YES;
                            SalesView.hidden=YES;
                            CouponView.hidden=YES;
                            CallLogView.hidden=YES;
                            DTRecordView.hidden=YES;
                            systemMessageLabel.text=@"";
                            systemMessageView.hidden=YES;
                            [self retrieveStudent:DetailsViewStudent.studentkey];
                        }else{
                            TopMenuView.hidden=YES;
                            ViewStudent.hidden=YES;
                            EnrollmentClassMenuView.hidden=YES;
                            EnrollmentRecordView.hidden=YES;
                            ClassRecordView.hidden=YES;
                            MessageView.hidden=YES;
                            SalesView.hidden=YES;
                            CouponView.hidden=YES;
                            CallLogView.hidden=YES;
                            DTRecordView.hidden=YES;
                            systemMessageView.hidden=NO;
                            systemMessageLabel.text=[NSString stringWithFormat:@"%@...",[MyClass returntitlewithtitle:@"Loading Information"]];
                            //systemMessageLabel.frame=CGRectMake(0, 0, selfViewWidth, self.view.bounds.size.height-64);
                            systemMessageTrailingConstraint.constant=0;
                            //ViewHistoryTableMasterView.hidden=YES;
                        }
                    }else if ([studentAction isEqualToString:@"EditStudent"]){
                        ViewStudent.hidden=NO;
                        TopMenuView.hidden=NO;
                        EnrollmentClassMenuView.hidden=YES;
                        EnrollmentRecordView.hidden=YES;
                        ClassRecordView.hidden=YES;
                        MessageView.hidden=YES;
                        SalesView.hidden=YES;
                        CouponView.hidden=YES;
                        CallLogView.hidden=YES;
                        DTRecordView.hidden=YES;
                        systemMessageView.hidden=YES;
//                        [self highlighttableoptionbuttonwithbuttontag:0];
                    }else if([studentAction isEqualToString:@"AddNewStudent"]){
                        [self.delegate enableAddStudentButton];
                    }else if ([studentAction isEqualToString:@"EnrollATSubject"]){
                        [MyClass loadingindicatorwithoption:@"stop" color:nil];
                        
                        UIAlertController *enrollalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Enroll Subject"] message:[MyClass returntitlewithtitle:@"Student Profile is created. You can now continue to enroll subject"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [enrollalert dismissViewControllerAnimated:YES completion:nil];
                            lastviewindex=1;
                            [self selecttable:[self returnmenubuttonwithtagnumber:1]];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self popoverenrollmentwindow];
                            });
                        }];
                        
                        [enrollalert addAction:OKAction];
                        [self presentViewController:enrollalert animated:YES completion:nil];
                        //[MyClass presentViewController:enrollalert View:self];
                        
                        
                    }else if ([studentAction isEqualToString:@"AddStudentSubject"]){
                        [MyClass loadingindicatorwithoption:@"stop" color:nil];
                        
                        UIAlertController *enrollalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Enroll Subject"] message:[MyClass returntitlewithtitle:@"Student Profile is created. You can now continue to enroll subject"] preferredStyle:UIAlertControllerStyleAlert];
                        
                        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                            [enrollalert dismissViewControllerAnimated:YES completion:nil];
                            lastviewindex=1;
                            [self selecttable:[self returnmenubuttonwithtagnumber:1]];
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self popoverenrollmentwindowforjoinstudent];
                            });
                        }];
                        
                        [enrollalert addAction:OKAction];
                        [self presentViewController:enrollalert animated:YES completion:nil];
                        //[MyClass presentViewController:enrollalert View:self];
                        
                        
                    }else if ([studentAction isEqualToString:@"EnrollStudentSubject"]){
                        TopMenuView.hidden=NO;
                        
                        if ([self retrieveStudent:DetailsViewStudent.studentkey]) {
                            lastviewindex=1;
                            [self selecttable:[self returnmenubuttonwithtagnumber:1]];
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [self popoverenrollmentwindow];
                            });
                        }
                    }
                    
                    if (![studentAction isEqualToString:@"EditStudent"]) {
                        if(!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showstudentpage){
                            menulabel_student.textColor=[UIColor lightGrayColor];
                            showstudentpage=NO;
    //                        if(selectedMenuPageIndex==0){
    //                            selectedMenuPageIndex=1;
    //                        }
                        }else{
                            showstudentpage=YES;
                            menulabel_student.textColor=[UIColor whiteColor];
                        }
                    }
                    
                    
                    if (!firstload) {
                        [self.delegate gobackStudentCategory];
                        [self createInitialViewNavigationButton];
                        [MyClass loadingindicatorwithoption:@"stop" color:nil];
                    }
                }
            });
            
        }];
    });
}


-(void) enrollmentwindowloadviewcompleted
{
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}

-(void) tapPhotoDetected:(UITapGestureRecognizer *)gesture
{
    
    [self showFullScreenPhotoWithImage:viewstudentimage.image mode:@"student"];

}

-(void) closefullscreen
{
    photofullscreenview.hidden=YES;
    viewhistorybutton.hidden=[studentAction isEqualToString:@"PopoverStudent"]?YES:NO;
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return fullscreen_imageview;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    if (fullscreen_imageview.frame.size.width<photofullscreenview.frame.size.width) {
        fullscreen_imageview.frame=CGRectMake((photofullscreenview.frame.size.width-fullscreen_imageview.frame.size.width)/2, fullscreen_imageview.frame.origin.y, fullscreen_imageview.frame.size.width, fullscreen_imageview.frame.size.height);
    }else{
        fullscreen_imageview.frame=CGRectMake(0, fullscreen_imageview.frame.origin.y, fullscreen_imageview.frame.size.width, fullscreen_imageview.frame.size.height);
    }
    
    if (fullscreen_imageview.frame.size.height<photofullscreenview.frame.size.height) {
        fullscreen_imageview.frame=CGRectMake(fullscreen_imageview.frame.origin.x, (photofullscreenview.frame.size.height-fullscreen_imageview.frame.size.height)/2, fullscreen_imageview.frame.size.width, fullscreen_imageview.frame.size.height);
    }else{
        fullscreen_imageview.frame=CGRectMake(fullscreen_imageview.frame.origin.x, 0, fullscreen_imageview.frame.size.width, fullscreen_imageview.frame.size.height);
    }
}

/*
-(void) showstudentlist:(NSString *)studentkey
{
    [self.delegate gotostudentprofile:studentkey];
}*/

-(IBAction) sortingbuttonpressed:(UIButton *)sender
{
    
    if (lastviewindex==1) {
        [self returnsortingarraywithtype:@"enrollmentlistsortingorder"];
    }else if (lastviewindex==2){
        [self returnsortingarraywithtype:@"classlistsortingorder"];
    }else if (lastviewindex==3){
        [self returnsortingarraywithtype:@"saleslistsortingorder"];
    }else if (lastviewindex==4){
        [self returnsortingarraywithtype:@"messagelistsortingorder"];
    }else if (lastviewindex==5){
        [self returnsortingarraywithtype:@"callloglistsortingorder"];
    }else if (lastviewindex==6){
        [self returnsortingarraywithtype:@"dtlistsortingorder"];
    }else if (lastviewindex==7){
        [self returnsortingarraywithtype:@"couponlistsortingorder"];
    }
    
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


-(void) returnsortingarraywithtype:(NSString *)type
{
    sortingarray=[MyClass returnsortingarraywithtype:type];
}

-(NSString *) returnsortinglabelwithitem:(NSString *)item
{
    if ([item isEqualToString:@"startdate"]) {
        return @"Start";
    }else if ([item isEqualToString:@"enrollmentdate"]) {
        return @"Enrollment Date";
    }else if ([item isEqualToString:@"enddate"]) {
        return @"End";
    }else if ([item isEqualToString:@"classtime"]) {
        return @"Time";
    }else if ([item isEqualToString:@"subjectfullname"]) {
        return @"Subject";
    }else if ([item isEqualToString:@"instructorfullname"]) {
        return @"Instructor";
    }else if ([item isEqualToString:@"classroom"]) {
        return @"Classroom";
    }else if ([item isEqualToString:@"classday"]) {
        return @"Class Day";
    }else if ([item isEqualToString:@"attendance"]) {
        return @"Attendance";
    }else if ([item isEqualToString:@"orderdatetime"]) {
        return @"Date/Time";
    }else if ([item isEqualToString:@"orderdate"]) {
        return @"Order Date";
    }else if ([item isEqualToString:@"productfullname"]) {
        return @"Product";
    }else if ([item isEqualToString:@"productcode"]) {
        return @"Code";
    }else if ([item isEqualToString:@"productcategory"]) {
        return @"Category";
    }else if ([item isEqualToString:@"productdatetime"]) {
        return @"Event Time";
    }else if ([item isEqualToString:@"notificationdatetime"]) {
        return @"Alert Time";
    }else if ([item isEqualToString:@"messagestarttime"]) {
        return @"Start Time";
    }else if ([item isEqualToString:@"messagecreatetime"]) {
        return @"Create Time";
    }else if ([item isEqualToString:@"messageendtime"]) {
        return @"End Time";
    }else if ([item isEqualToString:@"messagereceipient"]) {
        return @"Recipient";
    }else if ([item isEqualToString:@"message"]) {
        return @"Messages";
    }else if ([item isEqualToString:@"type"]) {
        return @"Target";
    }else if ([item isEqualToString:@"messagetype"]) {
        return @"Message Type";
    }else if ([item isEqualToString:@"calledon"]) {
        return @"Called On";
    }else if ([item isEqualToString:@"calledbyfullname"]) {
        return @"Called By";
    }else if ([item isEqualToString:@"details"]) {
        return @"Log Details";
    }else if ([item isEqualToString:@"DTdate"]) {
        return @"Date";
    }else if ([item isEqualToString:@"DTtime"]) {
        return @"Time";
    }else if ([item isEqualToString:@"classtype"]) {
        return @"Type";
    }else if ([item isEqualToString:@"sender"]) {
        return @"Sender";
    }else if ([item isEqualToString:@"coupon_type"]){
        return @"Type";
    }else if ([item isEqualToString:@"effectivefrom"]){
        return @"Valid From";
    }else if ([item isEqualToString:@"effectiveto"]){
        return @"Valid To";
    }else if ([item isEqualToString:@"issuedate"]){
        return @"Issue Date";
    }else if ([item isEqualToString:@"dateused"]){
        return @"Date Used";
    }else if ([item isEqualToString:@"couponkey"]){
        return @"ID";
    }else if ([item isEqualToString:@"coupon"]){
        return @"Coupon";
    }
    return item;
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
    
    if (lastviewindex==1) {
        [MyClass updatelocaldbwithparameter:@"enrollmentlistsortingorder" value:sortingstring];
    }else if (lastviewindex==2){
        [MyClass updatelocaldbwithparameter:@"classlistsortingorder" value:sortingstring];
    }else if (lastviewindex==3){
        [MyClass updatelocaldbwithparameter:@"saleslistsortingorder" value:sortingstring];
    }else if (lastviewindex==4){
        [MyClass updatelocaldbwithparameter:@"messagelistsortingorder" value:sortingstring];
    }else if (lastviewindex==5){
        [MyClass updatelocaldbwithparameter:@"callloglistsortingorder" value:sortingstring];
    }else if (lastviewindex==6){
        [MyClass updatelocaldbwithparameter:@"dtlistsortingorder" value:sortingstring];
    }else if (lastviewindex==7){
        [MyClass updatelocaldbwithparameter:@"couponlistsortingorder" value:sortingstring];
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
    
    if (lastviewindex==1) {
        [self sortenrollmentlist];
    }else if (lastviewindex==2){
        [self sortclasslist];
    }else if (lastviewindex==3){
        [self sortsaleslist];
    }else if (lastviewindex==4){
        [self sortmessagelist];
    }else if (lastviewindex==5){
        [self sortcallloglist];
    }else if (lastviewindex==6){
        [self sortdtlist];
    }else if (lastviewindex==7){
        [self sortcouponlist];
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
        if (lastviewindex==1) {
            [self sortenrollmentlist];
        }else if (lastviewindex==2){
            [self sortclasslist];
        }else if (lastviewindex==3){
            [self sortsaleslist];
        }else if (lastviewindex==4){
            [self sortmessagelist];
        }else if (lastviewindex==5){
            [self sortcallloglist];
        }else if (lastviewindex==6){
            [self sortdtlist];
        }else if (lastviewindex==7){
            [self sortcouponlist];
        }
    }
}

-(void) sortenrollmentlist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarraywithtype:@"enrollmentlistsortingorder"];
    
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    for (int i=0; i<filteredDetailsViewEnrollmentArray.count; i++) {
        ((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).enrollmentdate=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).enrollmentdate];
        ((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).startdate=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).startdate];
        ((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).enddate=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).enddate];
        ((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).billdate=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).billdate];
    }
    
    
    filteredDetailsViewEnrollmentArray=[NSMutableArray arrayWithArray:[filteredDetailsViewEnrollmentArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    
    for (int i=0; i<filteredDetailsViewEnrollmentArray.count; i++) {
        ((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).enrollmentdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).enrollmentdate];
        ((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).startdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).startdate];
        ((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).enddate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).enddate];
        ((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).billdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).billdate];
    }
    
    [DetailsViewEnrollmentTable reloadData];
    
}

-(void) sortclasslist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarraywithtype:@"classlistsortingorder"];
    

    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:@"enrollmentkey" ascending:[((SortingRecord *)[sortingarray firstObject]).order isEqualToString:@"a"]?YES:NO];
    [sortDescriptorsArray addObject:sortdescriptor];
    
    filteredDetailsViewClassArray=[NSMutableArray arrayWithArray:[filteredDetailsViewClassArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    [DetailsViewClassTable reloadData];
    
}

-(void) sortcouponlist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarraywithtype:@"couponlistsortingorder"];
    
    for (int i=0; i<filteredDetailsViewCouponArray.count; i++) {
        CouponRecord *obj=[filteredDetailsViewCouponArray objectAtIndex:i];
        obj.marketing=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
    }
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        if([sortingobject.item isEqualToString:@"coupon"]){
            if ([globalvariables.language isEqualToString:@"English"]) {
                sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:[NSString stringWithFormat:@"marketing.description"] ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO selector:@selector(localizedStandardCompare:)];
            }else{
                sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:[NSString stringWithFormat:@"marketing.description_chinese"] ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO selector:@selector(localizedStandardCompare:)];
            }
        }else if([sortingobject.item isEqualToString:@"coupon_type"]){
            sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:[NSString stringWithFormat:@"marketing.subcategory"] ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO selector:@selector(localizedStandardCompare:)];
        }else{
            sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO selector:@selector(localizedStandardCompare:)];
        }
        
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    
    filteredDetailsViewCouponArray=[NSMutableArray arrayWithArray:[filteredDetailsViewCouponArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    
    [couponTable reloadData];
}

-(void) sortsaleslist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarraywithtype:@"saleslistsortingorder"];
    
    
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    
    for (int i=0; i<filteredSalesRecordArray.count; i++) {
        ((SalesRecord *)[filteredSalesRecordArray objectAtIndex:i]).orderdate=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:((SalesRecord *)[filteredSalesRecordArray objectAtIndex:i]).orderdate];
    }
    
    
    filteredSalesRecordArray=[NSMutableArray arrayWithArray:[filteredSalesRecordArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    
    for (int i=0; i<filteredSalesRecordArray.count; i++) {
        ((SalesRecord *)[filteredSalesRecordArray objectAtIndex:i]).orderdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:((SalesRecord *)[filteredSalesRecordArray objectAtIndex:i]).orderdate];
    }
    [SalesTable reloadData];
    
}

-(void) sortmessagelist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarraywithtype:@"messagelistsortingorder"];
    
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        if ([sortingobject.item isEqualToString:@"message"]) {
            if ([globalvariables.language isEqualToString:@"English"]) {
                sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:@"messageenglish" ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
            }else{
                sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:@"messagechinese" ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
            }
        }else{
            sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        }
        
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    
    filteredMessageArray=[NSMutableArray arrayWithArray:[filteredMessageArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    
    
    [DetailsViewMessageTable reloadData];
    
}

-(void) sortcallloglist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarraywithtype:@"callloglistsortingorder"];
    
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    for (int i=0; i<filteredCallLogRecordArray.count; i++) {
        ((CallLogRecord *)[filteredCallLogRecordArray objectAtIndex:i]).calledon=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:((CallLogRecord *)[filteredCallLogRecordArray objectAtIndex:i]).calledon];
    }
    
    filteredCallLogRecordArray=[NSMutableArray arrayWithArray:[filteredCallLogRecordArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    
    for (int i=0; i<filteredCallLogRecordArray.count; i++) {
        ((CallLogRecord *)[filteredCallLogRecordArray objectAtIndex:i]).calledon=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:((CallLogRecord *)[filteredCallLogRecordArray objectAtIndex:i]).calledon];
    }
    
    [CallLogTable reloadData];
    
}

-(void) sortdtlist
{
    NSSortDescriptor *sortdescriptor;
    NSMutableArray *sortDescriptorsArray=[[NSMutableArray alloc]init];
    
    [self returnsortingarraywithtype:@"dtlistsortingorder"];
    
    
    for (int i=0; i<sortingarray.count; i++) {
        sortingobject=[sortingarray objectAtIndex:i];
        sortdescriptor= [NSSortDescriptor sortDescriptorWithKey:sortingobject.item ascending:[sortingobject.order isEqualToString:@"a"]?YES:NO];
        [sortDescriptorsArray addObject:sortdescriptor];
    }
    
    for (int i=0; i<filteredDetailsViewDTArray.count; i++) {
        ((DTRecord *)[filteredDetailsViewDTArray objectAtIndex:i]).DTdate=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:((DTRecord *)[filteredDetailsViewDTArray objectAtIndex:i]).DTdate];
    }
    
    filteredDetailsViewDTArray=[NSMutableArray arrayWithArray:[filteredDetailsViewDTArray sortedArrayUsingDescriptors:sortDescriptorsArray]];
    
    for (int i=0; i<filteredDetailsViewDTArray.count; i++) {
        ((DTRecord *)[filteredDetailsViewDTArray objectAtIndex:i]).DTdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:((DTRecord *)[filteredDetailsViewDTArray objectAtIndex:i]).DTdate];
    }
    
    [DetailsViewDTTable reloadData];
    
}


-(void) returnfilterenrollmentarray
{
    //NSMutableArray *result;
    
    
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (![subjectselected isEqualToString:@"All"]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.subject = %@", subjectselected];
        [nsPredicatearray addObject:newCondition];
    }

    if (![dayselected isEqualToString:@"All"]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.classday = %@", dayselected];
        [nsPredicatearray addObject:newCondition];
    }
    

    if ([scactiveoption_enrollment selectedSegmentIndex]!=0) {
        if ([scactiveoption_enrollment selectedSegmentIndex]==1) {
            newCondition = [NSPredicate predicateWithFormat:@"self.draft !=%@ and self.status!=%@ and (self.enddate >= %@ or self.enddate=%@ or self.enddate=%@)", @"Yes",@"Voided",[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd"],@"TBD",@"TBF"];
            [nsPredicatearray addObject:newCondition];
            
            for (int i=0; i<DetailsViewEnrollmentArray.count; i++) {
                ((EnrollmentRecord *)[DetailsViewEnrollmentArray objectAtIndex:i]).enddate=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:((EnrollmentRecord *)[DetailsViewEnrollmentArray objectAtIndex:i]).enddate];
            }
            
        }/*else if ([scactiveoption selectedSegmentIndex]==2) {
            newCondition = [NSPredicate predicateWithFormat:@"self.draft = %@", @"Yes"];
            [nsPredicatearray addObject:newCondition];
        }*/else if ([scactiveoption_enrollment selectedSegmentIndex]==2) {
            newCondition = [NSPredicate predicateWithFormat:@"self.paid != self.totalfee"];;
            [nsPredicatearray addObject:newCondition];
        }else if ([scactiveoption_enrollment selectedSegmentIndex]==3) {
            newCondition = [NSPredicate predicateWithFormat:@"self.status != %@", @"Voided"];
            [nsPredicatearray addObject:newCondition];
        }else if ([scactiveoption_enrollment selectedSegmentIndex]==4) {
            newCondition = [NSPredicate predicateWithFormat:@"self.status = %@", @"Voided"];
            [nsPredicatearray addObject:newCondition];
        }
    }

    if (![enrollmentsearchbar.text isEqualToString:@""]) {
        
        newCondition = [NSPredicate predicateWithBlock:^BOOL(EnrollmentRecord *object, NSDictionary *bindings) {
            NSString *invoicenumber = [NSString stringWithFormat:@"%@%@",object.invoiceprefix,object.invoicenumber];
            
            NSString *paymentkeys=@"";
            NSString *receiptnumbers=@"";
            for (int i=0; i<object.paymentrecords.count; i++) {
                PaymentRecord *obj=[object.paymentrecords objectAtIndex:i];
                paymentkeys=[NSString stringWithFormat:@"%@%@",paymentkeys,obj.paymentkey];
                receiptnumbers=[NSString stringWithFormat:@"%@%@%@",receiptnumbers,obj.receiptprefix,obj.receiptnumber];
            }

            return [object.subject rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.levelmain rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.startdate rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.enddate rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.noofclass rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.classday rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.classtime rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.instructor rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.remarks rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.invoiceremarks rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.classroom rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.instructorfullname rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.subjectfullname rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.enrollmentkey rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [invoicenumber rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [paymentkeys rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [receiptnumbers rangeOfString:enrollmentsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound
            ;
        }];
        
//        newCondition = [NSPredicate predicateWithFormat:@"SELF.subject contains[c] %@ or self.levelmain contains[c] %@ or self.startdate contains[c] %@ or self.enddate contains[c] %@ or self.noofclass contains[c] %@ or self.classday contains[c] %@ or self.classtime contains[c] %@ or self.instructor contains[c] %@ or self.remarks contains[c] %@ or self.invoiceremarks contains[c] %@ or self.classroom contains[c] %@ or self.instructorfullname contains[c] %@ or self.subjectfullname contains[c] %@ or self.enrollmentkey contains[c] %@ or any paymentrecords.paymentkey contains[c] %@ or self.invoicenumber contains[c] %@",enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text,enrollmentsearchbar.text];
        [nsPredicatearray addObject:newCondition];
        
    }
    
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredDetailsViewEnrollmentArray= [[NSMutableArray alloc]initWithArray:[DetailsViewEnrollmentArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredDetailsViewEnrollmentArray= [[NSMutableArray alloc]initWithArray:DetailsViewEnrollmentArray];
    }
    
    if ([scactiveoption_enrollment selectedSegmentIndex]==1) {
        for (int i=0; i<DetailsViewEnrollmentArray.count; i++) {
            ((EnrollmentRecord *)[DetailsViewEnrollmentArray objectAtIndex:i]).enddate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:((EnrollmentRecord *)[DetailsViewEnrollmentArray objectAtIndex:i]).enddate];
        }
        
        for (int i=0; i<filteredDetailsViewEnrollmentArray.count; i++) {
            ((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).enddate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:((EnrollmentRecord *)[filteredDetailsViewEnrollmentArray objectAtIndex:i]).enddate];
        }
    }

    [self sortenrollmentlist];
}

-(void) returnfilterclassarray
{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (![subjectselected isEqualToString:@"All"]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.subject = %@", subjectselected];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (![dayselected isEqualToString:@"All"]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.classday = %@", dayselected];
        [nsPredicatearray addObject:newCondition];
    }

    if (![typeselected isEqualToString:@"All"]) {
        if ([typeselected isEqualToString:@"Makeup"]) {
            newCondition = [NSPredicate predicateWithFormat:@"self.attendance = %@", @"Makeup"];
            [nsPredicatearray addObject:newCondition];
        }else if ([typeselected isEqualToString:@"Absent"]){
            newCondition = [NSPredicate predicateWithFormat:@"self.attendance = %@ or self.attendance = %@", @"Absent",@"Extend"];
            [nsPredicatearray addObject:newCondition];
        }else if ([typeselected isEqualToString:@"Extended"]){
            newCondition = [NSPredicate predicateWithFormat:@"self.extendedminute >%@",@"0"];
            [nsPredicatearray addObject:newCondition];
        }
    }
    
    if ([scactiveoption_class selectedSegmentIndex]!=0) {
        if ([scactiveoption_class selectedSegmentIndex]==1) {
            NSString *nowdate=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
            NSString *nowtime=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"HH:mm"];

            newCondition = [NSPredicate predicateWithFormat:@"self.draft !=%@ and self.status !=%@ and (((self.startdate>=%@ or (self.startdate=%@ and self.classtime>=%@)) and self.attendance != %@ and self.attendance != %@ and self.attendance !=%@) or (self.attendance !=%@ and (self.startdate=%@ or self.classtime=%@)) or ((self.makeupdate>=%@ or (self.makeupdate=%@ and self.makeuptime>=%@)) and self.attendance = %@) or (self.attendance = %@ and (self.makeupdate=%@ or self.makeupdate=%@ or self.makeuptime=%@ or self.makeuptime=%@)))",@"Yes",@"Voided",nowdate,nowdate,nowtime,@"Makeup",@"Absent",@"Extend",@"Makeup",@"TBD",@"TBD",nowdate,nowdate,nowtime,@"Makeup",@"Makeup",@"",@"TBD",@"",@"TBD"];
            //newCondition = [NSPredicate predicateWithFormat:@"self.draft !=%@ and self.status !=%@ and ((self.startdate>=%@ and self.attendance != %@ and self.attendance != %@ and self.attendance !=%@) or (self.attendance !=%@ and (self.startdate=%@ or self.classtime=%@)) or (self.makeupdate>=%@ and self.attendance = %@) or (self.attendance = %@ and (self.makeupdate=%@ or self.makeupdate=%@ or self.makeuptime=%@ or self.makeuptime=%@)))",@"Yes",@"Voided",nowdate,nowdate,nowtime,@"Makeup",@"Absent",@"Extend",@"Makeup",@"TBD",@"TBD",nowdate,nowdate,nowtime,@"Makeup",@"Makeup",@"",@"TBD",@"",@"TBD"];
            [nsPredicatearray addObject:newCondition];
            
            for (int i=0; i<DetailsViewClassArray.count; i++) {
                ((ClassRecord *)[DetailsViewClassArray objectAtIndex:i]).startdate=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:((ClassRecord *)[DetailsViewClassArray objectAtIndex:i]).startdate];
                
                ((ClassRecord *)[DetailsViewClassArray objectAtIndex:i]).makeupdate=[MyClass convertDDMMMYYYYtoYYYYMMDDwithdate:((ClassRecord *)[DetailsViewClassArray objectAtIndex:i]).makeupdate];
            }
            
        }else if ([scactiveoption_class selectedSegmentIndex]==2) {
            newCondition = [NSPredicate predicateWithFormat:@"self.assessmentformcount>%d", 0];
            [nsPredicatearray addObject:newCondition];
        }
    }
    
    if (![classsearchbar.text isEqualToString:@""]) {
        
        newCondition = [NSPredicate predicateWithFormat:@"SELF.subject contains[c] %@ or SELF.levelmain contains[c] %@ or SELF.startdate contains[c] %@ or self.makeupdate contains[c] %@ or self.classtime contains[c] %@ or self.instructor contains[c] %@ or self.attendance contains[c] %@ or self.makeuptime contains[c] %@ or self.makeupinstructor contains[c] %@ or self.makeupclassroom contains[c] %@ or self.remarks contains[c] %@ or self.allclassremarks contains[c] %@ or self.absentmakeupreason contains[c] %@ or self.classroom contains[c] %@ or self.extendedminute contains[c] %@ or self.instructorfullname contains[c] %@ or self.makeupinstructorfullname contains[c] %@ or self.subjectfullname contains[c] %@ or self.classkey contains[c] %@ or self.enrollmentkey contains[c] %@",classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text,classsearchbar.text];
        [nsPredicatearray addObject:newCondition];
        
    }
    
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredDetailsViewClassArray= [[NSMutableArray alloc]initWithArray:[DetailsViewClassArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredDetailsViewClassArray= [[NSMutableArray alloc]initWithArray:DetailsViewClassArray];
    }
    
    if ([scactiveoption_class selectedSegmentIndex]==1) {
        for (int i=0; i<DetailsViewClassArray.count; i++) {
            ((ClassRecord *)[DetailsViewClassArray objectAtIndex:i]).startdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:((ClassRecord *)[DetailsViewClassArray objectAtIndex:i]).startdate];
            
            ((ClassRecord *)[DetailsViewClassArray objectAtIndex:i]).makeupdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:((ClassRecord *)[DetailsViewClassArray objectAtIndex:i]).makeupdate];
        }
        
        for (int i=0; i<filteredDetailsViewClassArray.count; i++) {
            ((ClassRecord *)[filteredDetailsViewClassArray objectAtIndex:i]).startdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:((ClassRecord *)[filteredDetailsViewClassArray objectAtIndex:i]).startdate];
            
            ((ClassRecord *)[filteredDetailsViewClassArray objectAtIndex:i]).makeupdate=[MyClass convertYYYYMMDDtoDDMMMYYYYwithdate:((ClassRecord *)[filteredDetailsViewClassArray objectAtIndex:i]).makeupdate];
        }
    }
    
    [self sortclasslist];
}

-(void) returnfiltercouponarray
{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    NSString *nowdate=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd"];
    if (couponStatusSC.selectedSegmentIndex==1) {
        newCondition = [NSPredicate predicateWithFormat:@"self.effectivefrom<=%@ and self.dateused=%@ and (self.effectiveto=%@ or self.effectiveto >=%@)",nowdate,@"",@"",nowdate];
        [nsPredicatearray addObject:newCondition];
    }else if (couponStatusSC.selectedSegmentIndex==2) {
        newCondition = [NSPredicate predicateWithFormat:@"self.effectivefrom>%@ and self.dateused=%@",nowdate,@""];
        [nsPredicatearray addObject:newCondition];
    }else if (couponStatusSC.selectedSegmentIndex==3){
        newCondition = [NSPredicate predicateWithFormat:@"self.dateused != %@",@""];
        [nsPredicatearray addObject:newCondition];
    }else if (couponStatusSC.selectedSegmentIndex==4){
        newCondition = [NSPredicate predicateWithFormat:@"self.effectiveto < %@  and self.dateused=%@ and self.effectiveto!=%@",nowdate,@"",@""];
        [nsPredicatearray addObject:newCondition];
    }
    
    if ([subcategorySC selectedSegmentIndex]==1) {
        newCondition = [NSPredicate predicateWithBlock:^BOOL(CouponRecord *object, NSDictionary *bindings) {
            MarketingRecord *mktobj=[MyClass returnMarketingRecordWithMarketingKey:object.marketingkey index:3];
            return [mktobj.subcategory isEqualToString:@"All"] || [mktobj.subcategory isEqualToString:@"Class"];
        }];
        [nsPredicatearray addObject:newCondition];
    }else if ([subcategorySC selectedSegmentIndex]==2){
        newCondition = [NSPredicate predicateWithBlock:^BOOL(CouponRecord *object, NSDictionary *bindings) {
            MarketingRecord *mktobj=[MyClass returnMarketingRecordWithMarketingKey:object.marketingkey index:3];
            return [mktobj.subcategory isEqualToString:@"All"] || [mktobj.subcategory isEqualToString:@"Sales"];
        }];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (![couponsearchbar.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithBlock:^BOOL(CouponRecord *object, NSDictionary *bindings) {
            MarketingRecord *mktobj=[MyClass returnMarketingRecordWithMarketingKey:object.marketingkey index:3];
            return [mktobj.code rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [mktobj.description rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [mktobj.description_chinese rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [mktobj.promotionfixeddiscount rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [mktobj.promotionpercentagediscount rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.effectiveto rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.issuedate rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.effectivefrom rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.dateused rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.remarks rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.couponkey rangeOfString:couponsearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound;
        }];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredDetailsViewCouponArray= [[NSMutableArray alloc]initWithArray:[DetailsViewCouponArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredDetailsViewCouponArray= [[NSMutableArray alloc]initWithArray:DetailsViewCouponArray];
    }
    
    [self sortcouponlist];
}

-(void) returnfiltersalesarray
{
    //NSMutableArray *result;
    
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (![productcategoryselected isEqualToString:@"All"]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.productcategory = %@", productcategoryselected];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (![salessearchbar.text isEqualToString:@""]) {
        
        newCondition = [NSPredicate predicateWithBlock:^BOOL(SalesRecord *object, NSDictionary *bindings) {
            NSString *invoicenumber = [NSString stringWithFormat:@"%@%@",object.invoiceprefix,object.invoicenumber];
            
            NSString *paymentkeys=@"";
            NSString *receiptnumbers=@"";
            for (int i=0; i<object.paymentrecords.count; i++) {
                PaymentRecord *obj=[object.paymentrecords objectAtIndex:i];
                paymentkeys=[NSString stringWithFormat:@"%@%@",paymentkeys,obj.paymentkey];
                receiptnumbers=[NSString stringWithFormat:@"%@%@%@",receiptnumbers,obj.receiptprefix,obj.receiptnumber];
            }

            return [object.orderdate rangeOfString:salessearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.productfullname rangeOfString:salessearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.productcode rangeOfString:salessearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.productcategory rangeOfString:salessearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.remarks rangeOfString:salessearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.status rangeOfString:salessearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [object.saleskey rangeOfString:salessearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [invoicenumber rangeOfString:salessearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [paymentkeys rangeOfString:salessearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound || [receiptnumbers rangeOfString:salessearchbar.text options:NSCaseInsensitiveSearch].location!=NSNotFound
            ;
        }];
        
//        
//        
//        newCondition = [NSPredicate predicateWithFormat:@"SELF.orderdate contains[c] %@ or SELF.productfullname contains[c] %@ or SELF.productcode contains[c] %@ or self.productcategory contains[c] %@ or self.remarks contains[c] %@ or self.status contains[c] %@ or self.saleskey contains[c] %@ or any paymentrecords.paymentkey contains[c] %@ or self.invoicenumber contains[c] %@",salessearchbar.text,salessearchbar.text,salessearchbar.text,salessearchbar.text,salessearchbar.text,salessearchbar.text,salessearchbar.text,salessearchbar.text,salessearchbar.text,salessearchbar.text];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredSalesRecordArray= [[NSMutableArray alloc]initWithArray:[SalesRecordArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredSalesRecordArray= [[NSMutableArray alloc]initWithArray:SalesRecordArray];
    }
    
    [self sortsaleslist];
}

-(void) returnfiltercalllogarray
{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (![calllogcalledbyselected isEqualToString:@"All"]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.calledby = %@", calllogcalledbyselected];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (![calllogsearchbar.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithFormat:@"SELF.calledon contains[c] %@ or SELF.calledbyfullname contains[c] %@ or SELF.details contains[c] %@ or self.calllogkey contains[c] %@",calllogsearchbar.text,calllogsearchbar.text,calllogsearchbar.text,calllogsearchbar.text];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredCallLogRecordArray= [[NSMutableArray alloc]initWithArray:[CallLogRecordArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredCallLogRecordArray= [[NSMutableArray alloc]initWithArray:CallLogRecordArray];
    }
    
    [self sortcallloglist];
}

-(void) returnfilterdtarray
{
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    if (![dttypeselected isEqualToString:@"All"]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.classtype = %@", dttypeselected];
        [nsPredicatearray addObject:newCondition];
    }

    if (![dtsubjectselected isEqualToString:@"All"]) {
        newCondition = [NSPredicate predicateWithFormat:@"self.subject = %@", dtsubjectselected];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (![dtsearchbar.text isEqualToString:@""]) {
        newCondition = [NSPredicate predicateWithFormat:@"SELF.DTdate contains[c] %@ or SELF.DTtime contains[c] %@ or SELF.subject contains[c] %@ or self.levelmain contains[c] %@ or self.instructor contains[c] %@ or self.remarks contains[c] %@ or self.classtype contains[c] %@ or self.classroom contains[c] %@ or self.instructorfullname contains[c] %@ or self.subjectfullname contains[c] %@ or self.dtkey contains[c] %@",dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text];
        [nsPredicatearray addObject:newCondition];
    }
    
    if (nsPredicatearray.count>0) {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
        filteredDetailsViewDTArray= [[NSMutableArray alloc]initWithArray:[DetailsViewDTArray filteredArrayUsingPredicate:predicate]];
    }else{
        filteredDetailsViewDTArray= [[NSMutableArray alloc]initWithArray:DetailsViewDTArray];
    }
    
    [self sortdtlist];
}

-(void) returnfilteredMessageArray
{
    if ([messagesearchbar.text isEqualToString:@""]) {
        filteredMessageArray= [[NSMutableArray alloc]initWithArray:messageArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.messageenglish contains[c] %@ or self.messagechinese contains[c] %@ or self.sender contains[c] %@ or self.messagetype contains[c] %@",messagesearchbar.text,messagesearchbar.text,messagesearchbar.text,messagesearchbar.text];
        filteredMessageArray= [[NSMutableArray alloc]initWithArray:[messageArray filteredArrayUsingPredicate:predicate]];
    }
    
    
    //get unread row
    firstunreadrow=-1;
    unreadcount=0;
    for (int i=0; i<filteredMessageArray.count; i++) {
        InboxMessageRecord *record=[filteredMessageArray objectAtIndex:i];
        if ([record.type isEqualToString:@"received"] && [record.readtime isEqualToString:@""] && ([record.recipient isEqualToString:globalvariables.username] || [record.recipient isEqualToString:@"center"])) {
            unreadcount+=1;
            if (i>firstunreadrow) {
                firstunreadrow=i;
            }
        }
    }
    
    
    [DetailsViewMessageTable reloadData];
    
    
    
    if (filteredMessageArray.count>0) {
            if (DetailsViewMessageTable.contentSize.height<DetailsViewMessageTable.frame.size.height) {
                DetailsViewMessageTable.contentInset=UIEdgeInsetsMake(DetailsViewMessageTable.frame.size.height-DetailsViewMessageTable.contentSize.height, 0,0, 0);
                [DetailsViewMessageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }else{
                DetailsViewMessageTable.contentInset=UIEdgeInsetsZero;
                
                if (firstunreadrow>=0) {
                    [DetailsViewMessageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:firstunreadrow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    [DetailsViewMessageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
        
        //default last student to message sender
        InboxMessageRecord *lastmessage=[filteredMessageArray firstObject];
        if ([lastmessage.type isEqualToString:@"sent"]) {
            if ([lastmessage.sender isEqualToString:globalvariables.username]) {
                workingMessage.sender=globalvariables.username;
            }else{
                workingMessage.sender=@"center";
            }
            workingMessage.channel=lastmessage.channel;
        }else{
            if ([lastmessage.recipient isEqualToString:globalvariables.username]) {
                workingMessage.sender=globalvariables.username;
            }else{
                workingMessage.sender=@"center";
            }
            workingMessage.channel=@"A";
        }
        
    }
    if(scsender.hidden){
        workingMessage.sender=globalvariables.username;
    }
    scsender.selectedSegmentIndex=[workingMessage.sender isEqualToString:@"center"]?0:1;
    [channelbutton setTitle:[MyClass returnMessageChannelNameWithChannelCode:workingMessage.channel] forState:UIControlStateNormal];
    [self changemessagetoreadandreloadcontactlist:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self stopAudioPlaying];
    if (searchBar==enrollmentsearchbar) {
        [self returnfilterenrollmentarray];
        //[subjecttable reloadData];
        [DetailsViewEnrollmentTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==classsearchbar) {
        [self returnfilterclassarray];
        //[stafftable reloadData];
        [DetailsViewClassTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==salessearchbar) {
        [self returnfiltersalesarray];
        //[stafftable reloadData];
        [SalesTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==messagesearchbar) {
        [self returnfilteredMessageArray];
        //[stafftable reloadData];
        [DetailsViewMessageTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==calllogsearchbar) {
        [self returnfiltercalllogarray];
        //[stafftable reloadData];
        [CallLogTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==dtsearchbar) {
        [self returnfilterdtarray];
        //[stafftable reloadData];
        [DetailsViewDTTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==couponsearchbar) {
        [self returnfiltercouponarray];
        //[stafftable reloadData];
        [couponTable setContentOffset:CGPointZero animated:YES];
    }
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==sortingtable){
        return [MyClass returntitlewithtitle:@"Sorting Order"];
    }else{
        return nil;
    }
}


-(void) enrollmentTableLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:DetailsViewEnrollmentTable];
        NSIndexPath *indexPath = [DetailsViewEnrollmentTable indexPathForRowAtPoint:point];
        
        if (indexPath) {
            EnrollmentRecord * EnrollmentObject= [filteredDetailsViewEnrollmentArray objectAtIndex:indexPath.row];
            
            if (![globalvariables.documentfolder.classpaymentarray containsObject:EnrollmentObject.enrollmentkey]) {
                [globalvariables.documentfolder.classpaymentarray addObject:EnrollmentObject.enrollmentkey];
            }
            
            if (![globalvariables.documentfolder.classinvoicearray containsObject:EnrollmentObject.enrollmentkey]) {
                [globalvariables.documentfolder.classinvoicearray addObject:EnrollmentObject.enrollmentkey];
            }
            
            if (![globalvariables.documentfolder.classreceiptarray containsObject:EnrollmentObject.enrollmentkey] && EnrollmentObject.paymentrecords.count>0) {
                [globalvariables.documentfolder.classreceiptarray addObject:EnrollmentObject.enrollmentkey];
            }
//            
//            if (![[MyClass returnLastPaymentKeyWithPaymentRecords:EnrollmentObject.paymentrecords] isEqualToString:@""]) {
//                if (![globalvariables.documentfolder.classreceiptarray containsObject:[MyClass returnLastPaymentKeyWithPaymentRecords:EnrollmentObject.paymentrecords]]) {
//                    [globalvariables.documentfolder.classreceiptarray addObject:[MyClass returnLastPaymentKeyWithPaymentRecords:EnrollmentObject.paymentrecords]];
//                }
//            }

            
            if (![globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:EnrollmentObject.enrollmentkey]) {
                if (![EnrollmentObject.paid isEqualToString:EnrollmentObject.totalfee]) {
                    [globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys addObject:EnrollmentObject.enrollmentkey];
                }
            }
            
            if (![globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:EnrollmentObject.enrollmentkey]) {
                [globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys addObject:EnrollmentObject.enrollmentkey];
            }
            
            if (![globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:EnrollmentObject.enrollmentkey] && EnrollmentObject.paymentrecords.count>0) {
                [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys addObject:EnrollmentObject.enrollmentkey];
            }
            
//            NSLog(@"%@",globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys);
            
            DataChanged=TRUE;
            
            
            [self showAddToDocumentFolderAnimationWithTableview:DetailsViewEnrollmentTable IndexPath:indexPath];
            
            [self refreshdocumentfoldercount];
            
            isSelectCombinePayment=TRUE;
            [self refreshenrollmenttableheader];
            [DetailsViewEnrollmentTable reloadData];
        }
    }
}

-(void) salesTableLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint point = [gestureRecognizer locationInView:SalesTable];
        NSIndexPath *indexPath = [SalesTable indexPathForRowAtPoint:point];
        
        if (indexPath) {
            
            SalesRecord *salesobject = [filteredSalesRecordArray objectAtIndex:indexPath.row];
            
            if (![globalvariables.documentfolder.salespaymentarray containsObject:salesobject.saleskey]) {
                [globalvariables.documentfolder.salespaymentarray addObject:salesobject.saleskey];
            }
            
            if (![globalvariables.documentfolder.salesinvoicearray containsObject:salesobject.saleskey]) {
                [globalvariables.documentfolder.salesinvoicearray addObject:salesobject.saleskey];
            }
            
            if (![globalvariables.documentfolder.salesreceiptarray containsObject:salesobject.saleskey] && salesobject.paymentrecords.count>0) {
                [globalvariables.documentfolder.salesreceiptarray addObject:salesobject.saleskey];
            }
            

            
            if (![globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:salesobject.saleskey]) {
                if (![salesobject.paid isEqualToString:salesobject.total]) {
                    [globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys addObject:salesobject.saleskey];
                }
                
            }
            
            if (![globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:salesobject.saleskey]) {
                [globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys addObject:salesobject.saleskey];
            }
            
            if (![globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:salesobject.saleskey] && salesobject.paymentrecords.count>0) {
                [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys addObject:salesobject.saleskey];
            }
            

            
            DataChanged=TRUE;
            
            [self showAddToDocumentFolderAnimationWithTableview:SalesTable IndexPath:indexPath];
            
            [self refreshdocumentfoldercount];
            
            
            isSelectCombinePayment=TRUE;
            [self refreshsalestableheader];
            [SalesTable reloadData];
        }
    }
}

-(void) refreshdocumentfoldercountnumber
{
    [self refreshdocumentfoldercount];
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
//        if (width==0 && sidewindowview.frame.origin.x< mainWindow.bounds.size.width) {
//            [MyClass playsoundwithoption:@"close"];
//        }
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

-(void) closesidewindow
{
    
    [self adjustpresentingviewwidthwithwidth:0];
    
    if (lastviewindex==2) {
        [DetailsViewClassTable deselectRowAtIndexPath:[DetailsViewClassTable indexPathForSelectedRow] animated:YES];
    }else if (lastviewindex==4){
        [DetailsViewMessageTable deselectRowAtIndexPath:[DetailsViewMessageTable indexPathForSelectedRow] animated: YES];
    }else if (lastviewindex==1){
        [DetailsViewEnrollmentTable deselectRowAtIndexPath:[DetailsViewEnrollmentTable indexPathForSelectedRow] animated:YES];
    }else if (lastviewindex==3){
        [SalesTable deselectRowAtIndexPath:[SalesTable indexPathForSelectedRow] animated:YES];
    }else if (lastviewindex==5){
        [CallLogTable deselectRowAtIndexPath:[CallLogTable indexPathForSelectedRow] animated:YES];
    }else if (lastviewindex==7){
        [couponTable deselectRowAtIndexPath:[couponTable indexPathForSelectedRow] animated:YES];
    }else if (lastviewindex==6){
        [DetailsViewDTTable deselectRowAtIndexPath:[DetailsViewDTTable indexPathForSelectedRow] animated:YES];
    }else{
        [pointviewcontroller reloadPointHistoryTable];
    }
    

}

-(void) startsidewindowanimationwithwidth:(float)width
{

    
    ailoadindicator.hidden=NO;
    ailoadindicator.center = CGPointMake(width/2-7.5,mainWindow.frame.size.height/2-7.5);
    [ailoadindicator startAnimating];
    [self adjustpresentingviewwidthwithwidth:width];
}

-(BOOL) isDifferentLevelWithLaterEnrollmentWithStartDate:(NSString *)startdate enrollmentkey:(NSString *)enrollmentkey subject:(NSString *)subject levelmain:(NSString *)levelmain levelctm:(NSString *)levelctm studentkey:(NSString *)studentkey
{
    EnrollmentRecord *enrollmentobject;
    
    if (![startdate isEqualToString:@"TBD"] && ![startdate isEqualToString:@""]) {
        NSDate *currentdate=[MyClass convertToNSDateWithDate:startdate DateFormat:@"dd-MMM-yyyy"];
        for (int i=0; i<DetailsViewEnrollmentArray.count; i++) {
            enrollmentobject=[DetailsViewEnrollmentArray objectAtIndex:i];
            if (![enrollmentobject.enrollmentkey isEqualToString:enrollmentkey] && [enrollmentobject.subject isEqualToString:subject]) {
                if ([enrollmentobject.enddate isEqualToString:@"TBD"] || [enrollmentobject.enddate isEqualToString:@"TBF"] ||  [[MyClass convertToNSDateWithDate:enrollmentobject.enddate DateFormat:@"dd-MMM-yyyy"] compare:currentdate]!=NSOrderedAscending) {
                    if (![enrollmentobject.levelmain isEqualToString:levelmain] || ![enrollmentobject.levelctm isEqualToString:levelctm]) {
                        return TRUE;
                    }
                }
            }
        }
    }
    return FALSE;
}

-(BOOL) isDifferentLevelWithLaterEnrollmentWithStartDate:(NSString *)startdatetime classkey:(NSString *)classkey subject:(NSString *)subject levelmain:(NSString *)levelmain levelctm:(NSString *)levelctm
{
    ClassRecord *classobject;
    
    if (![startdatetime isEqualToString:@"TBD"] && ![startdatetime isEqualToString:@""]) {
        NSDate *currentdate=[MyClass convertToNSDateWithDate:startdatetime DateFormat:@"dd-MMM-yyyy HH:mm"];
        for (int i=0; i<DetailsViewClassArray.count; i++) {
            classobject=[DetailsViewClassArray objectAtIndex:i];
            if (![classobject.classkey isEqualToString:classkey] && [classobject.subject isEqualToString:subject]) {
                if ([classobject.startdate isEqualToString:@"TBD"] || [classobject.classtime isEqualToString:@"TBD"] || [[MyClass convertToNSDateWithDate:[NSString stringWithFormat:@"%@ %@",classobject.startdate,classobject.classtime] DateFormat:@"dd-MMM-yyyy HH:mm"] compare:currentdate]!=NSOrderedAscending) {
                    if (![classobject.levelmain isEqualToString:levelmain] || ![classobject.levelctm isEqualToString:levelctm]) {
                        return TRUE;
                    }
                }
            }
        }
    }
    return FALSE;
}

-(void) disableAddStudentButton
{
    //not used here
}

-(void) class_instructor_pressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:DetailsViewClassTable];
    NSIndexPath *indexpath =[DetailsViewClassTable indexPathForRowAtPoint:point];
    
    DetailsViewClass=[filteredDetailsViewClassArray objectAtIndex:indexpath.row];
    [self popupstaffwindowwithstaffobject:[MyClass returnstaffrecordwithusername:DetailsViewClass.instructor]];
}

-(void) class_sinstructor_pressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:DetailsViewClassTable];
    NSIndexPath *indexpath =[DetailsViewClassTable indexPathForRowAtPoint:point];
    
    DetailsViewClass=[filteredDetailsViewClassArray objectAtIndex:indexpath.row];
    [self popupstaffwindowwithstaffobject:[MyClass returnstaffrecordwithusername:DetailsViewClass.sinstructor]];
}


-(void) enrollment_instructor_pressed:(UIButton *)sender
{
    if (!isSelectCombinePayment) {
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:DetailsViewEnrollmentTable];
        NSIndexPath *indexpath =[DetailsViewEnrollmentTable indexPathForRowAtPoint:point];
        
        EnrollmentRecord *EnrollmentObject = [filteredDetailsViewEnrollmentArray objectAtIndex:indexpath.row];
        [self popupstaffwindowwithstaffobject:[MyClass returnstaffrecordwithusername:EnrollmentObject.instructor]];
    }

}

-(void) enrollment_sinstructor_pressed:(UIButton *)sender
{
    if (!isSelectCombinePayment) {
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:DetailsViewEnrollmentTable];
        NSIndexPath *indexpath =[DetailsViewEnrollmentTable indexPathForRowAtPoint:point];
        
        EnrollmentRecord *EnrollmentObject = [filteredDetailsViewEnrollmentArray objectAtIndex:indexpath.row];
        [self popupstaffwindowwithstaffobject:[MyClass returnstaffrecordwithusername:EnrollmentObject.sinstructor]];
    }
}

-(void) dt_instructor_pressed:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:DetailsViewDTTable];
    NSIndexPath *indexpath =[DetailsViewDTTable indexPathForRowAtPoint:point];
    
    DetailsViewDTObject=[filteredDetailsViewDTArray objectAtIndex:indexpath.row];
    [self popupstaffwindowwithstaffobject:[MyClass returnstaffrecordwithusername:DetailsViewDTObject.instructor]];
}

-(void) popupstaffwindowwithstaffobject:(Staff *)object
{
    [self startsidewindowanimationwithwidth:380];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        StaffPopoverViewController *staffpopover = (StaffPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StaffPopoverViewController"];
        staffpopover.StaffObject=object;
        staffpopover.readonly=YES;
        staffpopover.StaffTableMode=@"View";
        staffpopover.delegate=self;
        
        staffpopover.view.frame=self->mainWindow.bounds;
        [self->sidewindowview addSubview:staffpopover.view];
        [self addChildViewController:staffpopover];
        [staffpopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [workingMessage.photoarray count]+1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        __weak MessagePhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.backgroundColor=[UIColor systemGroupedBackgroundColor];
        cell.layer.borderColor=[UIColor lightTextColor].CGColor;
        cell.layer.borderWidth=1;
        
    if (indexPath.item==workingMessage.photoarray.count) {
        [cell.photoimageView setImage:nil];
        cell.addimagebutton.hidden=NO;
        cell.deleteimagebutton.hidden=YES;
        cell.videoplayicon.hidden=YES;
        [cell.addimagebutton addTarget:self action:@selector(addphotobuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        MessagePhotoRecord *obj=[workingMessage.photoarray objectAtIndex:indexPath.item];
        [cell.photoimageView setImage:obj.imageview.image];
        cell.addimagebutton.hidden=YES;
        cell.deleteimagebutton.hidden=NO;
        cell.deleteimagebutton.tag=indexPath.item;
        cell.videoplayicon.hidden=![obj.filetype isEqualToString:@"video"];
        [cell.deleteimagebutton addTarget:self action:@selector(deleteMessagePhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
        
        return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
        if (indexPath.row==workingMessage.photoarray.count || workingMessage.photoarray.count<2) {
            return NO;
        }
        return YES;

}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
        return CGSizeMake(80, 80);

}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

        if (indexPath.row<workingMessage.photoarray.count) {
            runviewdidappear=FALSE;
            [self.delegate donotrunviewdidappearinstudentinformation];
            fullscreenphotoviewcontroller.mode=@"Add";
            fullscreenphotoviewcontroller.index=indexPath.row;
            fullscreenphotoviewcontroller.fileArray=workingMessage.photoarray;
            [self presentViewController:fullscreenphotoviewcontroller animated:YES completion: nil];
        }

}

//-(NSMutableArray *) returnImageArrayWithMessagePhotoArray:(NSMutableArray *)photoarray
//{
//    NSMutableArray *imagearray=[[NSMutableArray alloc]init];
//    MessagePhotoRecord *object;
//    for (int i=0; i<photoarray.count; i++) {
//        object=[photoarray objectAtIndex:i];
//        NSDictionary *dict = @{ @"image" : object.imageview.image, @"imagetype" : object.filetype,@"fileurl":object.internalurl?object.internalurl:@"", @"filename" : object.filename};
//        [imagearray addObject:dict];
//    }
//    return imagearray;
//}



- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath{
    
        long count=workingMessage.photoarray.count;
        NSData *sourceImage = [workingMessage.photoarray objectAtIndex:sourceIndexPath.item];
        [workingMessage.photoarray removeObjectAtIndex:sourceIndexPath.item];
        
        if (destinationIndexPath.item==count) {
            [workingMessage.photoarray insertObject:sourceImage atIndex:count-1];
            [collectionView reloadData];
        }else{
            [workingMessage.photoarray insertObject:sourceImage atIndex:destinationIndexPath.row];
        }
        //photoimagechanged=TRUE;
}

- (void)handleLongGesture:(UILongPressGestureRecognizer *)gr
{
    UICollectionView *photocollectionview = (UICollectionView *) [gr view];
    
    switch(gr.state){
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *selectedIndexPath = [photocollectionview indexPathForItemAtPoint:[gr locationInView:photocollectionview]];
            if(selectedIndexPath == nil) break;
            [photocollectionview beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [photocollectionview updateInteractiveMovementTargetPosition:[gr locationInView:gr.view]];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [photocollectionview endInteractiveMovement];
            break;
        }
        default:
        {
            [photocollectionview cancelInteractiveMovement];
            break;
        }
    }
}

-(void) productimagebuttonpressed:(UIButton *)button
{
    SalesRecord *obj = [filteredSalesRecordArray objectAtIndex:button.tag];
    NSURL *url =[MyClass returndownloadImageURLwithType:@"product" typekey:obj.productcode];
    
    NSData *data=[[NSData alloc]initWithContentsOfURL:url];
    if(data){
        UIImageView *imageview=[[UIImageView alloc]init];
        imageview.image=[[UIImage alloc] initWithData:data];
        
        [self showFullScreenPhotoWithImage:imageview.image mode:@"product"];
    }
}

-(void) showFullScreenPhotoWithImage:(UIImage *)image mode:(NSString *)mode
{
    photofullscreenview.hidden=NO;
    viewhistorybutton.hidden=YES;
    
    if (fullscreen_scrollview) {
        [fullscreen_scrollview removeFromSuperview];
    }
    
    fullscreen_scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, photofullscreenview.bounds.size.width, photofullscreenview.bounds.size.height)];
    [photofullscreenview addSubview:fullscreen_scrollview];
    
    fullscreen_imageview=[[UIImageView alloc]init];
    fullscreen_imageview.contentMode=UIViewContentModeScaleAspectFit;
    [fullscreen_scrollview addSubview:fullscreen_imageview];
    
    if ([mode isEqualToString:@"student"]) {
        fullscreen_studentname.hidden=NO;
        shareimageview.hidden=YES;
        shareimagebutton.hidden=YES;
        fullscreen_studentname.text=[MyClass returnStudentnameWithStudentkey:DetailsViewStudent.studentkey option:@"full"];
    }else{
        shareimageview.hidden=NO;
        shareimagebutton.hidden=NO;
        fullscreen_studentname.hidden=YES;
    }
    
    //[fullscreen_imageview setImage:viewstudentimage.image];
    [fullscreen_imageview setImage:image];
    
    if (fullscreen_imageview.image.size.height/fullscreen_imageview.image.size.width*photofullscreenview.frame.size.width>photofullscreenview.frame.size.height) {
        fullscreen_imageview.frame=CGRectMake((photofullscreenview.frame.size.width-fullscreen_imageview.image.size.width/fullscreen_imageview.image.size.height*photofullscreenview.frame.size.height)/2, 0, fullscreen_imageview.image.size.width/fullscreen_imageview.image.size.height*photofullscreenview.frame.size.height, photofullscreenview.frame.size.height);
    }else{
        fullscreen_imageview.frame=CGRectMake(0, (photofullscreenview.frame.size.height-fullscreen_imageview.image.size.height/fullscreen_imageview.image.size.width*photofullscreenview.frame.size.width)/2, photofullscreenview.frame.size.width, fullscreen_imageview.image.size.height/fullscreen_imageview.image.size.width*photofullscreenview.frame.size.width);
    }
    
    fullscreen_scrollview.contentSize=CGSizeMake(fullscreen_imageview.frame.size.width, fullscreen_imageview.frame.size.height);
    fullscreen_scrollview.zoomScale = 1;
    fullscreen_scrollview.maximumZoomScale=7.0;
    fullscreen_scrollview.minimumZoomScale=1;
    fullscreen_scrollview.delegate=self;
    [photofullscreenview sendSubviewToBack:fullscreen_scrollview];
}

-(void) sharebuttonpressed:(UIButton *)sender
{
    UIImage *imagetoshare = fullscreen_messageimageview.image;
    NSArray *activityItems = @[imagetoshare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.modalPresentationStyle=UIModalPresentationPopover;
    mypopovercontroller=activityVC.popoverPresentationController;
    mypopovercontroller.delegate=self;
    mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
    mypopovercontroller.sourceView=sender;
    mypopovercontroller.sourceRect=sender.bounds;
    [self presentViewController:activityVC animated:TRUE completion:nil];


}

-(void) gotostudentprofile:(NSString *)studentkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys saleskey:(NSString *)saleskey
{
//    [self.navigationController popToRootViewControllerAnimated:NO];
    [self retrieveStudent:studentkey];
    [self.delegate gotostudentprofile:studentkey submenu:submenu classkeys:classkeys saleskey:saleskey];
}

-(NSString *) returnrecipientnamewithmessagerecord:(InboxMessageRecord *)messageobject
{
    if ([messageobject.channel isEqualToString:@"E"]) {
        return messageobject.recipient;
    }else if ([messageobject.channel isEqualToString:@"A"] || [messageobject.channel isEqualToString:@"S"]){
        return [NSString stringWithFormat:@"%@ (%@)",[MyClass returnContactRelationshipWithStudentkey:messageobject.associateid Contact:messageobject.recipient],[MyClass returnlocalcontactwithstudentkey:messageobject.associateid contact:messageobject.recipient]]; 
    }
    return @"";
}

-(void) tapMessagePhotoDetected:(UIButton *)sender
{
    runviewdidappear=FALSE;
    [self.delegate donotrunviewdidappearinstudentinformation];
    NSInteger messagerow=sender.tag/888888;
    NSInteger photorow=sender.tag%888888;
    
    if(selectMode){
        [self selectMessageWithIndex:messagerow];
        return;
    }
        
    InboxMessageRecord *messageobject=[filteredMessageArray objectAtIndex:messagerow];
    NSMutableArray *messagephotoarray=messageobject.photoarray;
    fullscreenphotoviewcontroller.mode=@"View";
    fullscreenphotoviewcontroller.index=photorow;
    fullscreenphotoviewcontroller.fileArray=messagephotoarray;
    [self presentViewController:fullscreenphotoviewcontroller animated:YES completion: nil];
}

-(void) sharephotobuttonpressed:(UIButton *)sender
{
    [self stopAudioPlaying];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    MessagePhotoRecord *obj=[((InboxMessageRecord *)[filteredMessageArray objectAtIndex:sender.tag]).photoarray firstObject];
    NSString *strURL=[NSString stringWithFormat:@"%@messageimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,obj.messagephotourl];
        
    NSURL *url =[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    if ([obj.filetype isEqualToString:@"image"]) {
        UIImage *imagetoshare = [[SDImageCache sharedImageCache] imageFromCacheForKey:[url absoluteString]];
        NSArray *activityItems = @[imagetoshare];
        UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        activityVC.modalPresentationStyle=UIModalPresentationPopover;
        mypopovercontroller=activityVC.popoverPresentationController;
        mypopovercontroller.delegate=self;
        mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
        mypopovercontroller.sourceView=sender;
        mypopovercontroller.sourceRect=sender.bounds;
        
        [self presentViewController:activityVC animated:YES completion:nil];
    }else{
        NSData *pdfdata=[[NSData alloc]initWithContentsOfURL:url];
        
        /*NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString* filePath = [documentsPath stringByAppendingPathComponent:obj.filename];
        [pdfdata writeToFile:filePath atomically:YES];
        NSURL *fileUrl = [NSURL fileURLWithPath:filePath];*/
        
        NSURL *fileUrl=[MyClass returnInternalURLforNSData:pdfdata Filename:obj.filename];

        UIActivityViewController* activityVC = [[UIActivityViewController alloc] initWithActivityItems:@[fileUrl] applicationActivities:nil];
        activityVC.modalPresentationStyle=UIModalPresentationPopover;
        mypopovercontroller=activityVC.popoverPresentationController;
        mypopovercontroller.delegate=self;
        mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
        mypopovercontroller.sourceView=sender;
        mypopovercontroller.sourceRect=sender.bounds;
        
        [self presentViewController:activityVC animated:YES completion:nil];
    }
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
});


}

-(void) showinstantmessageactions:(UIButton *)button
{
    [self stopAudioPlaying];
    if(selectMode){
        [self selectMessageWithIndex:button.tag];
        return;
    }
    
    InboxMessageRecord *obj=[filteredMessageArray objectAtIndex:button.tag];
    NSMutableArray *actionarray;
    if([obj.type isEqualToString:@"received"]){
        if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).deletemessage) {
            actionarray=[[NSMutableArray alloc]initWithObjects:@"Reply",@"Forward",@"Delete", nil];
        }else{
            actionarray=[[NSMutableArray alloc]initWithObjects:@"Reply",@"Forward", nil];
        }
    }else{
        if ([obj.channel isEqualToString:@"AS"]) {
            if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).deletemessage) {
                actionarray=[[NSMutableArray alloc]initWithObjects:@"Reply",@"Resend",@"Forward",@"Read Status",@"Delete", nil];
            }else{
                actionarray=[[NSMutableArray alloc]initWithObjects:@"Reply",@"Resend",@"Forward",@"Read Status", nil];
            }
        }else if ([obj.channel isEqualToString:@"A"]) {
            if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).deletemessage) {
                actionarray=[[NSMutableArray alloc]initWithObjects:@"Reply",@"Resend",@"Forward",@"Read Status",@"Delete", nil];
            }else{
                actionarray=[[NSMutableArray alloc]initWithObjects:@"Reply",@"Resend",@"Forward",@"Read Status", nil];
            }
        }else if ([obj.channel isEqualToString:@"S"]) {
            if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).deletemessage) {
                actionarray=[[NSMutableArray alloc]initWithObjects:@"Resend",@"Forward",@"Read Status",@"Delete", nil];
            }else{
                actionarray=[[NSMutableArray alloc]initWithObjects:@"Resend",@"Forward",@"Read Status", nil];
            }
        }else if ([obj.channel isEqualToString:@"E"]) {
            if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).deletemessage) {
                actionarray=[[NSMutableArray alloc]initWithObjects:@"Resend",@"Forward",@"Read Status",@"Delete", nil];
            }else{
                actionarray=[[NSMutableArray alloc]initWithObjects:@"Resend",@"Forward",@"Read Status", nil];
            }
        }
    }
    
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"InstantMessageAction" DataIndex:button.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(180, 40*actionarray.count) View:self Button:button ItemsArray:actionarray Title:nil];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView==DetailsViewMessageTable) {
        [self changemessagetoreadandreloadcontactlist:YES];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView==DetailsViewMessageTable) {
        [self changemessagetoreadandreloadcontactlist:YES];
    }
}

-(void) changemessagetoreadandreloadcontactlist:(BOOL)reload
{
    if (readmessagearray.count>0) {

        NSString *messagekeys=[readmessagearray componentsJoinedByString:@","];
        [readmessagearray removeAllObjects];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self updateinboxmessagewithmessagekey:messagekeys field:nil value:nil action:@"Read"];
            if (reload) {
                //[self retrievemessagecontactlist];
            }
        });
        

    }
}

-(void) updateinboxmessagewithmessagekey:(NSString *)messagekey field:(NSString *)field value:(NSString *)value action:(NSString *)action
{
    
    NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
    [dictionary setValue:@"updateinboxmessage" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:action forKey:@"action"];
    [dictionary setValue:@"center" forKey:@"apptype"];
     [dictionary setValue:messagekey forKey:@"inboxmessagekey"];
    if ([action isEqualToString:@"Edit"]) {
       [dictionary setValue:value forKey:field];
    }

    //__block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *JSONArray = jsonreturned[@"content"];
            NSString * result=[[JSONArray objectAtIndex:0] objectForKey:@"result"];
            NSLog(@"%@",result);
        }
    }];
    
    /*
    NSData   *finalData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:globalvariables.generalphpfullpath] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60];
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [postRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [postRequest setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[finalData length]] forHTTPHeaderField:@"Content-Length"];
    [postRequest setHTTPBody:finalData];
    

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[NSURLSession sharedSession] dataTaskWithRequest:postRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        //NSString *strResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (!error) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSMutableArray *JSONArray = jsonreturned[@"content"];
            NSString * result=[[JSONArray objectAtIndex:0] objectForKey:@"result"];
            NSLog(@"%@",result);
            
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/

}

- (IBAction)camerabuttonpressed:(UIButton *)sender {
    [self stopAudioPlaying];
    [self.view endEditing:YES];
    [self addphotobuttonpressed:sender];
}

- (IBAction)channelbuttonpressed:(UIButton *)button {
    [self stopAudioPlaying];
    NSMutableArray *channelarray;

    channelarray=[[NSMutableArray alloc]initWithObjects:@"AS",@"A",@"S",@"E", nil];

    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:workingMessage.channel, nil] DataType:@"MessageChannel" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(180, 40*channelarray.count) View:self Button:button ItemsArray:channelarray Title:nil];
}

- (IBAction)sendinstantmessagebuttonpressed:(id)sender {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addtmpinstantmessage];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self sendinstantmessage];
            messageinputtext.text=@"";
            workingMessage.messageenglish=@"";
            workingMessage.messagechinese=@"";
            [self enableSendButton];
        });
    });
}

-(void) addtmpinstantmessage
{
    InboxMessageRecord *messageobject=[[InboxMessageRecord alloc]initInboxMessageRecordwithInboxMessagekey:nil Messagetype:workingMessage.messagetype MessageEnglish:workingMessage.messageenglish MessageChinese:workingMessage.messagechinese MessageCreateTime:nil MessageStartTime:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"] AutoMessageFlag:nil Channel:workingMessage.channel ReciptientType:workingMessage.recipienttype Status:workingMessage.status Sender:workingMessage.sender AssociateID:nil Readtime:@"" photoarray:workingMessage.photoarray recipient:DetailsViewStudent.studentkey outboxmessagekey:nil type:@"sent" readstatus:@"SENDING" readstatusdetailsarray:nil replytomessagekey:replyToMessageView.hidden?@"0":@"999"];
    [messageArray insertObject:messageobject atIndex:0];
    [self returnfilteredMessageArray];
    instantPhotoCollectionView.hidden=YES;
    replyToMessageView.hidden=YES;
    camerabutton.hidden=NO;
    
}

-(void) sendinstantmessage
{
    
    NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSDictionary *dict;
    NSArray *keys;
    NSArray *values;
    NSArray *recipientgrouparray=[[NSArray alloc]init];
    
    keys=[NSArray arrayWithObjects:@"group",@"recipient",nil];
    

        workingMessage.recipienttype=@"Student";
        values=[NSArray arrayWithObjects:@"student",DetailsViewStudent.studentkey, nil];
    dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    [arrayOfDicts addObject:dict];
    
    
    recipientgrouparray = [NSArray arrayWithArray:arrayOfDicts];
    
    [dictionary setValue:@"updateoutboxmessage2" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:globalvariables.username forKey:@"composer"];
    [dictionary setValue:workingMessage.sender forKey:@"sender"];
    [dictionary setValue:workingMessage.recipienttype forKey:@"recipienttype"];
    [dictionary setValue:workingMessage.messagetype forKey:@"messagetype"];
    [dictionary setValue:workingMessage.messageenglish forKey:@"messageenglish"];
    [dictionary setValue:workingMessage.messagechinese forKey:@"messagechinese"];
    //[dictionary setValue:workingMessage.messagestarttime forKey:@"messagestarttime"];
    if ([[MyClass convertToNSDateWithDate:workingMessage.messagestarttime DateFormat:@"yyyy-MM-dd HH:mm:ss"] compare:[NSDate date]]==NSOrderedAscending) {
        workingMessage.messagestarttime=[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    [dictionary setValue:workingMessage.messagestarttime forKey:@"messagestarttime"];
    [dictionary setValue:@"" forKey:@"notificationqueuedflag"];
    [dictionary setValue:@"N" forKey:@"automessageflag"];
    [dictionary setValue:workingMessage.channel forKey:@"channel"];
    [dictionary setValue:@"" forKey:@"status"];
    [dictionary setValue:recipientgrouparray.count>0?recipientgrouparray:@"" forKey:@"recipientgroup"];
    [dictionary setValue:@"N" forKey:@"automessageflag"];
    [dictionary setValue:@"N" forKey:@"broadcastmessageflag"];
    if(replyToMessageRecord){
        [dictionary setValue:replyToMessageRecord.outboxmessagekey forKey:@"replytomessagekey"];
    }
    [dictionary setValue:@"Add" forKey:@"action"];
    
    __block BOOL result=FALSE;
    __block NSData *returndata;
    
    NSMutableArray *tmpphotoarray=[[NSMutableArray alloc]init];
    for (int i=0; i<workingMessage.photoarray.count; i++) {
        [tmpphotoarray addObject:[workingMessage.photoarray objectAtIndex:i]];
    }
    
    workingMessage.photoarray=[[NSMutableArray alloc]init];
    
    [MyClass callMultipartPOSTwithDict:dictionary photoArray:tmpphotoarray completionBlock:^(id responseObject, NSError *error) {
        if (!error) {
            result=TRUE;
            returndata=responseObject;
//            replyToMessageRecord=nil;
        }
    }];
    
    if (result) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:returndata options:kNilOptions error:nil];
        NSDictionary *jsoncontent=json[@"content"];
        NSArray *photofilenamearray=jsoncontent[@"photofilenamearray"];
        for (int i=0; i<photofilenamearray.count; i++) {
            NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@messageimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,[photofilenamearray objectAtIndex:i]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [[SDImageCache sharedImageCache] storeImage:((MessagePhotoRecord *)tmpphotoarray[i]).imageview.image forKey:[url absoluteString] toDisk:YES completion:nil];
            
        }
        [MyClass clearTmpDirectoryContent];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        workingMessage.photoarray=[[NSMutableArray alloc]init];
        recordAudioButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendmessage;
        replyToMessageView.hidden=YES;
        sendinstantmessagebutton.enabled=[self enableSendButton];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveMessageRecord];
            //workingMessage.photoarray=[[NSMutableArray alloc]init];
            //sendinstantmessagebutton.enabled=[self enableSendButton];
            [MyClass playBeepSoundWithType:@"success"];
        });
    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        [MyClass showconnectionlostdialogbox];
        
    }
    
    /*
dictionary=[MyClass addchecksumparameterwithdictionary:dictionary];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:globalvariables.generalphpfullpath parameters:dictionary headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //add img data one by one
        for(int i=0; i<[workingMessage.photoarray count];i++)
        {
            MessagePhotoRecord *object=[workingMessage.photoarray objectAtIndex:i];
            if ([object.filetype isEqualToString:@"image"]) {
                //UIImage *uploadimage=object.imageview.image;
                //NSDictionary *imagedict=[MyClass returnCompressedImageDictWithImage:uploadimage];
                //NSData *imageData=[[NSData alloc]initWithContentsOfURL:object.internalurl];
                NSData *imageData=[MyClass returnWXCompressDataWithURL:object.internalurl];
                [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"image%d",i] fileName:[NSString stringWithFormat:@"abc%d.png",i] mimeType:@"image/png"];
            }else if ([object.filetype isEqualToString:@"pdf"]){
                NSData *pdfData=[[NSData alloc]initWithContentsOfURL:object.internalurl];
                [formData appendPartWithFileData:pdfData name:[NSString stringWithFormat:@"pdf%d",i] fileName:object.filename mimeType:@"application/pdf"];
            }else if ([object.filetype isEqualToString:@"video"]){
                NSData *videoData = [[NSData alloc]initWithContentsOfURL:object.internalurl];
                NSString *fileextension= [[object.internalurl lastPathComponent] substringFromIndex: [[object.internalurl lastPathComponent] length] - 3];
                [formData appendPartWithFileData:videoData name:[NSString stringWithFormat:@"video%d",i] fileName:[NSString stringWithFormat:@"video%d.%@",i,fileextension] mimeType:@"video/quicktime"];
            }else if ([object.filetype isEqualToString:@"audio"]){
                NSData *audioData = [[NSData alloc]initWithContentsOfURL:object.internalurl];
                NSString *fileextension= [[object.internalurl lastPathComponent] substringFromIndex: [[object.internalurl lastPathComponent] length] - 3];
                [formData appendPartWithFileData:audioData name:[NSString stringWithFormat:@"audio%d",i] fileName:[NSString stringWithFormat:@"audio%d.%@",i,fileextension] mimeType:@"audio/mpeg"];
            }
        }
    } progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSDictionary *jsoncontent=json[@"content"];
        NSArray *photofilenamearray=jsoncontent[@"photofilenamearray"];
        for (int i=0; i<photofilenamearray.count; i++) {
            NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@messageimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,[photofilenamearray objectAtIndex:i]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
            [[SDImageCache sharedImageCache] storeImage:((MessagePhotoRecord *)workingMessage.photoarray[i]).imageview.image forKey:[url path] toDisk:YES completion:nil];
            
        }
        [MyClass clearTmpDirectoryContent];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        workingMessage.photoarray=[[NSMutableArray alloc]init];
        recordAudioButton.enabled=YES;
        sendinstantmessagebutton.enabled=[self enableSendButton];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveMessageRecord];
            //workingMessage.photoarray=[[NSMutableArray alloc]init];
            //sendinstantmessagebutton.enabled=[self enableSendButton];
            [MyClass playBeepSoundWithType:@"success"];
        });
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        [MyClass showconnectionlostdialogbox];
    }];*/
}

- (IBAction)selectsender:(UISegmentedControl *)sender {
    [self stopAudioPlaying];
    if (sender.selectedSegmentIndex==0) {
        workingMessage.sender=@"center";
    }else{
        workingMessage.sender=globalvariables.username;
    }
}

-(void) addphotobuttonpressed:(UIButton *)sender
{
    addphotobutton=sender;
    [self popupaddphotodialoguebox];
}

-(void) popupaddphotodialoguebox
{
    [self stopAudioPlaying];
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    NSMutableArray *ItemsArray=[[NSMutableArray alloc]init];
    if (hasCamera) {
        if (globalvariables.centerrecord.enablevideomessage && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendvideomessage) {
            [ItemsArray addObject:@"Take Photo"];
            [ItemsArray addObject:@"Record Video"];
            [ItemsArray addObject:@"Photo Library"];
            [ItemsArray addObject:@"Video Library"];
            [ItemsArray addObject:@"Document"];
        }else{
            [ItemsArray addObject:@"Take Photo"];
            [ItemsArray addObject:@"Photo Library"];
            [ItemsArray addObject:@"Document"];
        }
    }else{
        if (globalvariables.centerrecord.enablevideomessage && ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendvideomessage) {
            [ItemsArray addObject:@"Photo Library"];
            [ItemsArray addObject:@"Video Library"];
            [ItemsArray addObject:@"Document"];
        }else{
            [ItemsArray addObject:@"Photo Library"];
            [ItemsArray addObject:@"Document"];
        }
    }
    
    
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"attachment" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 80) View:self Button:addphotobutton ItemsArray:ItemsArray Title:nil];

}

/*
-(void) takephotobuttonpressed
{
    [[mypopovercontroller  presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addclassphotofromsource:@"camera"];
}

-(void) photolibrarybuttonpressed
{
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addclassphotofromsource:@"library"];
}*/

-(void) addclassphotofromsource:(NSString *)source
{
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([source isEqualToString:@"document"]) {
            //        UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[@"com.adobe.pdf"] inMode:UIDocumentPickerModeImport];
            UIDocumentPickerViewController *documentPicker = [[UIDocumentPickerViewController alloc] initForOpeningContentTypes:@[UTTypePDF] asCopy:YES];
            documentPicker.delegate = self;
            documentPicker.modalPresentationStyle = UIModalPresentationPopover;
            mypopovercontroller=documentPicker.popoverPresentationController;
            mypopovercontroller.delegate=self;
            mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
            mypopovercontroller.sourceView=addphotobutton;
            mypopovercontroller.sourceRect=addphotobutton.bounds;
            
            [self presentViewController:documentPicker animated:YES completion:^{
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }];
            
            
        }else{
            imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate = self;
            imagepicker.allowsEditing=NO;
            
            if ([source isEqualToString:@"photocamera"]) {
                imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagepicker.modalPresentationStyle = UIModalPresentationFullScreen;
                imagepicker.view.tag=0;
                [MyClass presentViewController:imagepicker View:self];
            }else if ([source isEqualToString:@"photolibrary"]){
                if ([mypopovercontroller presentingViewController].isBeingPresented) {
                    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
                }
                
                BSImagePickerViewController *bspicker=[[BSImagePickerViewController alloc]init];
                bspicker.modalPresentationStyle=UIModalPresentationPopover;
                mypopovercontroller=bspicker.popoverPresentationController;
                mypopovercontroller.delegate=self;
                mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
                mypopovercontroller.sourceView=addphotobutton;
                mypopovercontroller.sourceRect=addphotobutton.bounds;
                
                [self bs_presentImagePickerController:bspicker animated:YES select:nil deselect:nil cancel:^(NSArray<PHAsset *> * array) {
                    [bspicker dismissViewControllerAnimated:YES completion:nil];
                } finish:^(NSArray<PHAsset *> * array) {
                    
                    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        __block BOOL fileexceedsize=FALSE;
                        for (int i=0;i<array.count;i++) {
                            PHAsset *asset=[array objectAtIndex:i];
                            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                            options.synchronous = YES;
                            options.networkAccessAllowed=YES;
                            [[PHImageManager defaultManager] requestImageDataAndOrientationForAsset:asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, CGImagePropertyOrientation orientation, NSDictionary * _Nullable info) {
                                if (imageData) {
                                    if (![MyClass isPDFSizeNotExceedLimitWithData:imageData]) {
                                        fileexceedsize=TRUE;
                                    }else{
                                        UIImage *image=[[UIImage alloc]initWithData:imageData];
                                        imageData = UIImageJPEGRepresentation(image, 1.0);
                                        NSURL *imageURL=[MyClass returnInternalURLforNSData:imageData Filename:@"image"];
                                        //UIImage *image=[[UIImage alloc]initWithData:imageData];
                                        [workingMessage.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.width Height:image.size.height FileType:@"image" InternalURL:imageURL FileName:@"" ThumbnailURL:@""]];
                                    }
                                }
                            }];
                        }
                        
                        
                        instantPhotoCollectionView.hidden=workingMessage.photoarray.count==0;
                        camerabutton.hidden=!instantPhotoCollectionView.hidden;
                        sendinstantmessagebutton.enabled=[self enableSendButton];
                        if(!instantPhotoCollectionView.hidden){
                            [instantPhotoCollectionView reloadData];
                        }
                        //[self paddingtableifneeded];
                        [MyClass loadingindicatorwithoption:@"stop" color:@""];
                        [bspicker dismissViewControllerAnimated:YES completion:^{
                            if (fileexceedsize) {
                                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Image"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                                }];
                                
                                [erroralert addAction:OKAction];
                                [self presentViewController:erroralert animated:YES completion:nil];
                            }
                            
                        }];
                        
                    });
                    
                } completion:^{
                    [MyClass loadingindicatorwithoption:@"stop" color:@""];
                } selectLimitReached:nil];
                /*
                 imagepicker.modalPresentationStyle=UIModalPresentationPopover;
                 imagepicker.view.tag=0;
                 mypopovercontroller=imagepicker.popoverPresentationController;
                 mypopovercontroller.delegate=self;
                 mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
                 mypopovercontroller.sourceView=addphotobutton;
                 mypopovercontroller.sourceRect=addphotobutton.bounds;
                 
                 [self presentViewController:imagepicker animated:YES completion:nil];*/
            }else if ([source isEqualToString:@"videocamera"]) {
                imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagepicker.modalPresentationStyle = UIModalPresentationFullScreen;
                //            imagepicker.mediaTypes = @[(NSString *)kUTTypeMovie];
                imagepicker.mediaTypes = @[
                    @"public.movie"
                ];
                imagepicker.view.tag=1;
                [MyClass presentViewController:imagepicker View:self];
            }else if ([source isEqualToString:@"videolibrary"]){
                //            imagepicker.mediaTypes = @[(NSString*)kUTTypeMovie, (NSString*)kUTTypeAVIMovie, (NSString*)kUTTypeVideo, (NSString*)kUTTypeMPEG4];
                imagepicker.mediaTypes = @[
                    @"public.movie",
                    @"public.video",
                    @"com.apple.quicktime-movie" // or @"public.mpeg" depending on your exact needs
                ];
                imagepicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
                
                if ([mypopovercontroller presentingViewController].isBeingPresented) {
                    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
                }
                
                imagepicker.modalPresentationStyle=UIModalPresentationPopover;
                imagepicker.view.tag=1;
                mypopovercontroller=imagepicker.popoverPresentationController;
                mypopovercontroller.delegate=self;
                mypopovercontroller.permittedArrowDirections=UIPopoverArrowDirectionAny;
                mypopovercontroller.sourceView=addphotobutton;
                mypopovercontroller.sourceRect=addphotobutton.bounds;
                
                [self presentViewController:imagepicker animated:YES completion:nil];
            }
        }
    });
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    runviewdidappear=FALSE;
    [self.delegate donotrunviewdidappearinstudentinformation];
    //[imagepicker dismissViewControllerAnimated:YES completion:nil];
    
    if (picker.view.tag==1) {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
//        NSData *videoData = [[NSData alloc]initWithContentsOfURL:videoURL];
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSData *videoData=[MyClass compressVideoSynchronouslyWithURL:videoURL error:nil];
        if (![MyClass isPDFSizeNotExceedLimitWithData:videoData]) {
            [picker dismissViewControllerAnimated:NO completion:^{
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Video"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
            }];
        }else{
            
                UIImage *image=[MyClass getThumbnailImageFromVideo:videoURL];
                [workingMessage.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.width Height:image.size.height FileType:@"video" InternalURL:videoURL FileName:@"" ThumbnailURL:@""]];

                
                [picker dismissViewControllerAnimated:YES completion:nil];
                instantPhotoCollectionView.hidden=workingMessage.photoarray.count==0;
                camerabutton.hidden=!instantPhotoCollectionView.hidden;
                sendinstantmessagebutton.enabled=[self enableSendButton];
                [instantPhotoCollectionView reloadData];
                
        }
            [MyClass loadingindicatorwithoption:@"stop" color:@""];
        });
    }else{
        UIImage *image=info[UIImagePickerControllerOriginalImage];
        NSData *imageData;
        if ([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
            imageData = UIImageJPEGRepresentation(image, 1.0);
        } else {
            if (@available(iOS 11.0, *)) {
                imageData = [NSData dataWithContentsOfURL:info[UIImagePickerControllerImageURL]];
            } else {
                imageData = UIImageJPEGRepresentation(image, 1.0);
            }
        }
        
        if (![MyClass isPDFSizeNotExceedLimitWithData:imageData]) {
            [picker dismissViewControllerAnimated:NO completion:^{
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Image"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
            }];
        }else{
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //UIImage *image=info[UIImagePickerControllerOriginalImage];
                //image=[MyClass resizeImageWithImage:image ForSize:image.size];
                NSURL *imageURL=[MyClass returnInternalURLforNSData:imageData Filename:@"image"];
                [workingMessage.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.width Height:image.size.height FileType:@"image" InternalURL:imageURL FileName:@"" ThumbnailURL:@""]];
                
                [picker dismissViewControllerAnimated:YES completion:nil];
                instantPhotoCollectionView.hidden=workingMessage.photoarray.count==0;
                camerabutton.hidden=!instantPhotoCollectionView.hidden;
                sendinstantmessagebutton.enabled=[self enableSendButton];
                [instantPhotoCollectionView reloadData];
                [MyClass loadingindicatorwithoption:@"stop" color:@""];
            });
        }
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    runviewdidappear=FALSE;
    [self.delegate donotrunviewdidappearinstudentinformation];
     [imagepicker dismissViewControllerAnimated:YES completion:nil];
    //imagepicker.view.hidden=YES;
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        
        if (controller.documentPickerMode == UIDocumentPickerModeImport) {
            NSData *chosendata=[[NSData alloc]initWithContentsOfURL:url];
            
            if (![MyClass isValidPDFWithData:chosendata]) {
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document"] message:[MyClass returntitlewithtitle:@"Invalid PDF file"] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }else if (![MyClass isPDFSizeNotExceedLimitWithData:chosendata]) {
                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [erroralert addAction:OKAction];
                [self presentViewController:erroralert animated:YES completion:nil];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }else{
                UIImage *chosenImage=[MyClass returnPDFFirstPageImageWithPDFData:chosendata];
                [workingMessage.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:[[UIImageView alloc]initWithImage:chosenImage] Width:chosenImage.size.height Height:chosenImage.size.height FileType:@"pdf" InternalURL:url FileName:[url lastPathComponent] ThumbnailURL:@""]];
                
                instantPhotoCollectionView.hidden=workingMessage.photoarray.count==0;
                camerabutton.hidden=!instantPhotoCollectionView.hidden;
                sendinstantmessagebutton.enabled=[self enableSendButton];
                [instantPhotoCollectionView reloadData];
                
            }
        }
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

-(void) deleteMessagePhoto:(UIButton *)button
{
    [workingMessage.photoarray removeObjectAtIndex:button.tag];
    instantPhotoCollectionView.hidden=workingMessage.photoarray.count==0;
    camerabutton.hidden=!instantPhotoCollectionView.hidden;
    sendinstantmessagebutton.enabled=[self enableSendButton];
    [instantPhotoCollectionView reloadData];
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self stopAudioPlaying];
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    if (size.height>100) {
        messageinputtextheightconstraint.constant=100;
        textView.scrollEnabled=YES;
    }else{
        //frame.size.height=size.height;
        messageinputtextheightconstraint.constant=size.height;
        textView.scrollEnabled=NO;
    }

    
    workingMessage.messageenglish=textView.text;
    workingMessage.messagechinese=textView.text;
    sendinstantmessagebutton.enabled=[self enableSendButton];
}

-(void) closeFullScreenPhotoViewWithIndex:(NSInteger)index
{
    runviewdidappear=FALSE;
    [self.delegate donotrunviewdidappearinstudentinformation];
    [fullscreenphotoviewcontroller dismissViewControllerAnimated:YES completion:nil];
}

-(void) deleteImageWithIndex:(NSInteger)index
{
    runviewdidappear=FALSE;
    [self.delegate donotrunviewdidappearinstudentinformation];
    [fullscreenphotoviewcontroller dismissViewControllerAnimated:YES completion:nil];
    
    [workingMessage.photoarray removeObjectAtIndex:index];
    if (workingMessage.photoarray.count==0) {
        instantPhotoCollectionView.hidden=YES;
        camerabutton.hidden=NO;
    }else{
        instantPhotoCollectionView.hidden=NO;
        camerabutton.hidden=YES;
    }
    sendinstantmessagebutton.enabled=[self enableSendButton];
    [instantPhotoCollectionView reloadData];
    
}

-(void) returnRotatedImage:(UIImage *)image Index:(NSInteger)index
{
    MessagePhotoRecord *obj=[workingMessage.photoarray objectAtIndex:index];
    obj.imageview=[[UIImageView alloc]initWithImage:image];
    obj.internalurl=[MyClass returnInternalURLforNSData:UIImageJPEGRepresentation(obj.imageview.image, 1.0) Filename:@"image"];
    [instantPhotoCollectionView reloadData];
}

-(BOOL) enableSendButton
{
    if ((recordAudioButton.enabled || !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendmessage) && (workingMessage.photoarray.count>0 || ![[MyClass leadingtrailingspacestrimmed:workingMessage.messageenglish] isEqualToString:@""])) {
        sendinstantmessagebutton.hidden=NO;
        recordAudioButton.hidden=YES;
        return ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendmessage;
    }
    recordAudioButton.hidden=!globalvariables.centerrecord.enablevoicemessage;
    sendinstantmessagebutton.hidden=YES;
    return ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendmessage;
}

-(void) updateinstantmessagetopbox
{
    contactlabel.text=[MyClass returnStudentnameWithStudentkey:DetailsViewStudent.studentkey option:@"full"];

    Student *student=[MyClass returnstudentwithstudentkey:DetailsViewStudent.studentkey];
    [MyClass downloadImageWithImageview:contactimage gender:student.gender type:@"student" typekey:DetailsViewStudent.studentkey image:student.image async:YES];

    contactimage.hidden=NO;
    contactlabel.hidden=NO;
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"InstantMessageAction"]){
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"Read Status"]) {
            [self showreadstatusdetails:dataindex];
        }else if ([result isEqualToString:@"Delete"]){
//            [self deleteInstantMessage:dataindex];
            selectMode=@"Delete";
            [self selectMessageWithIndex:dataindex];
            selectStatusView.hidden=NO;
            deleteMessageButton.hidden=NO;
        }else if ([result isEqualToString:@"Forward"]){
            selectMode=@"Forward";
            forwardmessagerecord =[globalvariables.filteredMessageArray objectAtIndex:dataindex];
            
            [self selectMessageWithIndex:dataindex];
            selectStatusView.hidden=NO;
            forwardMessageButton.hidden=NO;

        }else if ([result isEqualToString:@"Resend"]){
            [self reSendInstantMessage:dataindex];
        }else if ([result isEqualToString:@"Reply"]){
            replyToMessageRecord=[filteredMessageArray objectAtIndex:dataindex];
            
            if([replyToMessageRecord.sender isEqualToString:globalvariables.username]){
                replyToSender.text=[MyClass returntitlewithtitle:@"You"];
            }else if ([replyToMessageRecord.sender isEqualToString:@"center"]) {
                replyToSender.text=[MyClass returncentershortnamewithcenterkey:globalvariables.centerrecord.centerkey];
            }else if ([replyToMessageRecord.sender rangeOfString:@"@"].location !=NSNotFound){
                replyToSender.text=[MyClass returnstaffnamewithusername:replyToMessageRecord.sender firstorfullname:@"full"];
            }else{
                replyToSender.text=[MyClass returnStudentnameWithStudentkey:replyToMessageRecord.sender option:@"full"];
            }

            replyToMessageTitle.text=[self returnReplyToMessageTitleWithMessageRecord:replyToMessageRecord];
            replyToMessageView.hidden=NO;
            if(replyToMessageRecord.photoarray.count==0){
                replyToImageView.hidden=YES;
            }else if (replyToMessageRecord.photoarray.count==1 && [((MessagePhotoRecord *)[replyToMessageRecord.photoarray firstObject]).filetype isEqualToString:@"audio"]){
                replyToImageView.hidden=YES;
            }else{
                replyToImageView.hidden=NO;
                MessagePhotoRecord *photorecord = [replyToMessageRecord.photoarray firstObject];
                [MyClass downloadImageWithImageview:replyToImageView gender:nil type:@"message" typekey:photorecord.thumbnailurl image:@"Yes" async:YES];
            }
            replyToMessageBar.backgroundColor=[replyToMessageRecord.type isEqualToString:@"sent"]?[UIColor colorWithRed:38.0/255.0 green:154.0/255.0 blue:251.0/255.0 alpha:1.0]:[UIColor lightGrayColor];
            
            [self.view layoutIfNeeded];
        }
    }else if ([datatype isEqualToString:@"MessageChannel"]){
        workingMessage.channel=[selecteditems firstObject];
        [channelbutton setTitle:[MyClass returnMessageChannelNameWithChannelCode:workingMessage.channel] forState:UIControlStateNormal];
    }else if ([datatype isEqualToString:@"attachment"]){
        NSString *result=[selecteditems firstObject];

        if ([result isEqualToString:@"Take Photo"]) {
            [self addclassphotofromsource:@"photocamera"];
        }else if ([result isEqualToString:@"Photo Library"]){
            [self addclassphotofromsource:@"photolibrary"];
        }else if ([result isEqualToString:@"Document"]){
            [self addclassphotofromsource:@"document"];
        }else if ([result isEqualToString:@"Record Video"]) {
            [self addclassphotofromsource:@"videocamera"];
        }else if ([result isEqualToString:@"Video Library"]){
            [self addclassphotofromsource:@"videolibrary"];
        }
        
    }else if ([datatype isEqualToString:@"quickpay"]) {
        if (!EnrollmentRecordView.hidden) {
            EnrollmentRecord *obj=[filteredDetailsViewEnrollmentArray objectAtIndex:dataindex];
            UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Payment"] message:[MyClass returntitlewithtitle:@"Are you sure to proceed with payment?"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                
                [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self quickPayWithStudentKey:obj.studentkey paidMethod:[selecteditems firstObject] enrollmentkey:obj.enrollmentkey saleskey:nil];
                });
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            
            [changealert addAction:OKAction];
            [changealert addAction:CancelAction];
            
            [self presentViewController:changealert animated:YES completion:nil];
        }else{
            SalesRecord *obj=[filteredSalesRecordArray objectAtIndex:dataindex];
            UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Payment"] message:[MyClass returntitlewithtitle:@"Are you sure to proceed with payment?"] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
                
                [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self quickPayWithStudentKey:obj.studentkey paidMethod:[selecteditems firstObject] enrollmentkey:nil saleskey:obj.saleskey];
                });
            }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            }];
            
            [changealert addAction:OKAction];
            [changealert addAction:CancelAction];
            
            [self presentViewController:changealert animated:YES completion:nil];
        }
    }else if ([datatype isEqualToString:@"shareenrollmentdocument"]) {
        NSString *result=[selecteditems firstObject];
        
        DetailsViewEnrollment=[filteredDetailsViewEnrollmentArray objectAtIndex:dataindex];
        Student *PopoverStudent=DetailsViewStudent;
        EnrollmentRecord *PopoverEnrollment=DetailsViewEnrollment;
        EnrollmentRecord *workingEnrollment=PopoverEnrollment;
        NSIndexPath *paymentindexpath=[NSIndexPath indexPathForRow:0 inSection:0];
        NSString *tmpTotalDiscount=[self calculateenrollmenttotaldiscount];
        
        if ([result isEqualToString:@"Print"]) {
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                    
                    NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Receipt"];
                    if (classday) {
                        ClassReceiptRecord *classreceiptrecord=[[ClassReceiptRecord alloc]initClassReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:tmpTotalDiscount totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain paymentkey:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).paiddate paid:PopoverEnrollment.paid paidmethod:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath enrollment:PopoverEnrollment] staffname:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment paymentremarks:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).paymentremarks subjectname:nil];
                        
                        
                        NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] SalesReceiptArray:nil papersizeoverride:NO combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                        if (pdfdata) {
                            [self printPDF:pdfdata];
                        }
                    }
                }else{
                    NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Invoice"];
                    if (classday) {
                        ClassInvoiceRecord *classinvoicerecord=[[ClassInvoiceRecord alloc]initClassInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:tmpTotalDiscount totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain outstandingamount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.totalfee floatValue]-[PopoverEnrollment.paid floatValue]] invoiceremarks:PopoverEnrollment.invoiceremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment subjectname:nil];
                        
                        NSData *pdfdata=[MyClass generateInvoiceWithClassInvoiceArray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] SalesInvoiceArray:nil papersizeoverride:NO combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                        if (pdfdata) {
                            [self printPDF:pdfdata];
                        }
                    }
                }
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }else if ([result isEqualToString:@"Send eInvoice"] || [result isEqualToString:@"Send eReceipt"]){
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                    NSMutableArray *documentArray=[[NSMutableArray alloc]init];
                    NSMutableDictionary *dict;
                    dict=[[NSMutableDictionary alloc]init];
                    [dict setValue:@"Class" forKey:@"paymenttype"];
                    [dict setValue:@"1" forKey:@"documentkey"];
                    [dict setValue:workingEnrollment.enrollmentkey forKey:@"paymenttypekey"];
                    [documentArray addObject:dict];
                    [MyClass submitDocumentSendingRequestWithType:@"Receipt" documentArray:documentArray];
                    
                    

                }else{
                    NSMutableArray *documentArray=[[NSMutableArray alloc]init];
                    NSMutableDictionary *dict;
                    dict=[[NSMutableDictionary alloc]init];
                    [dict setValue:@"Class" forKey:@"paymenttype"];
                    [dict setValue:@"1" forKey:@"documentkey"];
                    [dict setValue:workingEnrollment.enrollmentkey forKey:@"paymenttypekey"];
                    [documentArray addObject:dict];
                    [MyClass submitDocumentSendingRequestWithType:@"Invoice" documentArray:documentArray];
                    
                }
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }else if ([result isEqualToString:@"Send Email"]){
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                    NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Receipt"];
                    if (classday) {
                        ClassReceiptRecord *classreceiptrecord=[[ClassReceiptRecord alloc]initClassReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:tmpTotalDiscount totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain paymentkey:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).paiddate paid:PopoverEnrollment.paid paidmethod:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath enrollment:PopoverEnrollment] staffname:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment paymentremarks:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).paymentremarks subjectname:nil];
                        
                        
                        NSData *pdfdata=[MyClass generateReceiptWithClassReceiptArray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] SalesReceiptArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                        if (pdfdata) {
                            [self emailPDF:pdfdata pdftype:@"Receipt" filename:[MyClass returnreceiptnumberwithclassreceiptarray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] salesreceiptarray:nil] receiptient:[self returnmailreceiptientwithclassarray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] salesarray:nil type:@"Receipt"]];
                        }
                    }
                }else{
                    NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Invoice"];
                    if (classday) {
                        ClassInvoiceRecord *classinvoicerecord=[[ClassInvoiceRecord alloc]initClassInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:tmpTotalDiscount totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain outstandingamount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.totalfee floatValue]-[PopoverEnrollment.paid floatValue]] invoiceremarks:PopoverEnrollment.invoiceremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment subjectname:nil];
                        
                        NSData *pdfdata=[MyClass generateInvoiceWithClassInvoiceArray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] SalesInvoiceArray:nil papersizeoverride:YES combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
                        if (pdfdata) {
                            [self emailPDF:pdfdata pdftype:@"Invoice" filename:[MyClass returninvoicenumberwithclassinvoicearray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] salesinvoicearray:nil updateinvoicelog:NO] receiptient:[self returnmailreceiptientwithclassarray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] salesarray:nil type:@"Invoice"]];
                        }
                    }
                }
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }else if ([result isEqualToString:@"Add to Folder"]){
            if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                if (![globalvariables.documentfolder.classreceiptarray containsObject:workingEnrollment.enrollmentkey]) {
                    [globalvariables.documentfolder.classreceiptarray addObject:workingEnrollment.enrollmentkey];
                    if (![globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:workingEnrollment.enrollmentkey]) {
                        [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys addObject:workingEnrollment.enrollmentkey];
                    }
                    [self refreshdocumentfoldercountnumber];
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
                    [self refreshdocumentfoldercountnumber];
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
                    [self shareenrollmentpaymentreceiptwithtableview:nil indexpath:nil];
                }else{
                    [self shareenrollmentpaymentinvoicewithtableview:nil indexpath:nil];
                }
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }
    }else if ([datatype isEqualToString:@"sharesalesdocument"]) {
        DetailsViewSales=[filteredSalesRecordArray objectAtIndex:dataindex];
        Student *PopoverStudent=DetailsViewStudent;
        SalesRecord *SalesObject=DetailsViewSales;
        SalesRecord *workingSales=DetailsViewSales;
        NSIndexPath *paymentindexpath=[NSIndexPath indexPathForRow:0 inSection:0];
        NSString *tmpTotalDiscount=[self calculatesalestotaldiscount];
        
        
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"Print"]) {
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                
                
                SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath sales:SalesObject] staffname:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
                
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
                
                SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath sales:SalesObject] staffname:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
                
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
        }else if ([result isEqualToString:@"More"]){
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ([invoiceorreceipt isEqualToString:@"receipt"]) {
                    [self sharesalespaymentreceiptwithtableview:nil indexpath:nil];
                }else{
                    [self sharesalespaymentinvoicewithtableview:nil indexpath:nil];
                }
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            });
        }
    }else if ([datatype isEqualToString:@"classactions"]) {
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"Delete"]) {
            ClassRecord *obj=[filteredDetailsViewClassArray objectAtIndex:dataindex];
            [selectededitattendanceclasskeyarray removeAllObjects];
            [selectededitattendanceclasskeyarray addObject:obj];
            [self confirmDeleteClasses];
        }else if ([result isEqualToString:@"Postpone"]) {
            ClassRecord *obj=[filteredDetailsViewClassArray objectAtIndex:dataindex];
            [selectededitattendanceclasskeyarray removeAllObjects];
            [selectededitattendanceclasskeyarray addObject:obj];
            [self confirmPostponeClasses];
        }else if ([result isEqualToString:@"More"]){
            [self class_morebuttonpressed:dataindex];
        }
    }
}

-(void) confirmDeleteClasses
{
    UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the class?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self proceedDeleteClasses];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [changealert addAction:OKAction];
    [changealert addAction:CancelAction];
    
    [self presentViewController:changealert animated:YES completion:nil];

}

-(void) confirmPostponeClasses
{
    UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Class Update"] message:[MyClass returntitlewithtitle:@"Are you sure to postpone the class?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self proceedPostponeClasses];
        });
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
    }];
    
    [changealert addAction:OKAction];
    [changealert addAction:CancelAction];
    
    [self presentViewController:changealert animated:YES completion:nil];

}

-(void) proceedDeleteClasses
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict;
    
    ClassScheduleRecord *classobject;
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        classobject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        dict= [[NSMutableDictionary alloc]init];
        [dict setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dict setValue:classobject.classkey forKey:@"classkey"];
        
        [arrayOfDicts addObject:dict];
    }
    
    NSDictionary *dictionary = @{@"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"classkeys" : arrayOfDicts,
                                 @"updatedby" : globalvariables.username,
                                 @"postaction" : @"deletemultipleclasses"};
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        }
        
        if(result){
            [selectededitattendanceclasskeyarray removeAllObjects];
            [self retrieveClassWithEnrollmentkey:nil];
            
            DataChanged=TRUE;
        }
    }];
    
    
}

-(void) proceedPostponeClasses
{
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict;
    
    ClassScheduleRecord *classobject;
    for (int i=0; i<selectededitattendanceclasskeyarray.count; i++) {
        classobject=[selectededitattendanceclasskeyarray objectAtIndex:i];
        dict= [[NSMutableDictionary alloc]init];
        [dict setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dict setValue:classobject.classkey forKey:@"classkey"];
        
        [arrayOfDicts addObject:dict];
    }
    
    NSDictionary *dictionary = @{@"centerkey" : globalvariables.centerrecord.centerkey,
                                 @"centerdb" : globalvariables.centerrecord.centerdb,
                                 @"classkeys" : arrayOfDicts,
                                 @"updatedby" : globalvariables.username,
                                 @"postaction" : @"postponemultipleclasses"};
    
    __block BOOL result=FALSE;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        }
        
        if(result){
            [selectededitattendanceclasskeyarray removeAllObjects];
            [self retrieveClassWithEnrollmentkey:nil];
            
            DataChanged=TRUE;
        }
    }];
    

}


-(NSString *) calculatesalestotaldiscount
{
    NSString *tmpTotalDiscount;
    SalesRecord *workingSales=DetailsViewSales;
    MarketingRecord *marketingobject;
    
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
    
    if(workingSales.couponrecords.count>0){
        
        
        if(discountedfee-totalpaid>0){
            discountedfee-=totalpaid;
            for (int i=0; i<workingSales.couponrecords.count; i++) {
                CouponRecord *obj=[workingSales.couponrecords objectAtIndex:i];
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
        
        for (int i=0; i<workingSales.couponrecords.count; i++) {
            CouponRecord *obj=[workingSales.couponrecords objectAtIndex:i];
            marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
            if(obj.creditable){
                discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
            }
        }
    }
    
    tmpTotalDiscount=[NSString stringWithFormat:@"%g",[workingSales.quantity floatValue]*[workingSales.price floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee):discountedfee)];
    
    if (((CenterRecord *)[MyClass returncenterrecordwithcenterkey:globalvariables.centerrecord.centerkey]).noofroundoffdigit==1) {
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
    
    
    
    return tmpTotalDiscount;
    
    
}


-(NSString *) calculateenrollmenttotaldiscount
{
    NSString *tmpTotalDiscount;
    EnrollmentRecord *workingEnrollment=DetailsViewEnrollment;
    MarketingRecord *marketingobject;
    
    float discountedfee=[workingEnrollment.tuitionfee floatValue];
    float totalpaid = [workingEnrollment.paid floatValue];
    
    for (int i=0; i<workingEnrollment.promotiondiscountrecords.count; i++) {
        marketingobject=[workingEnrollment.promotiondiscountrecords objectAtIndex:i];
        if (![marketingobject.promotionfixeddiscount isEqualToString:@""]) {
            discountedfee-=[marketingobject.promotionfixeddiscount floatValue]*(!marketingobject.perclassorquantity?1:[workingEnrollment.noofclass integerValue]);
        }else{
            discountedfee*=(1-[marketingobject.promotionpercentagediscount floatValue]/100);
        }
    }
    
    discountedfee*=(1-[workingEnrollment.oneoffpercentagediscount floatValue]/100);
    discountedfee-=[workingEnrollment.oneoffdiscount floatValue];
    //discountedfee-=[tmpManualRecursiveFixedDiscount floatValue];
    
    
    if(workingEnrollment.couponrecords.count>0){
        discountedfee+=[workingEnrollment.enrollmentfee floatValue]+[workingEnrollment.latefee floatValue];
        

        
        
        if(discountedfee-totalpaid>0){
            discountedfee-=totalpaid;
            for (int i=0; i<workingEnrollment.couponrecords.count; i++) {
                CouponRecord *obj=[workingEnrollment.couponrecords objectAtIndex:i];
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
        
        for (int i=0; i<workingEnrollment.couponrecords.count; i++) {
            CouponRecord *obj=[workingEnrollment.couponrecords objectAtIndex:i];
            marketingobject=[MyClass returnMarketingRecordWithMarketingKey:obj.marketingkey index:3];
            if(obj.creditable){
                discountedfee-=[marketingobject.promotionfixeddiscount floatValue];
            }
        }
        
        
        
        tmpTotalDiscount=[NSString stringWithFormat:@"%g",[workingEnrollment.tuitionfee floatValue]+[workingEnrollment.enrollmentfee floatValue]+[workingEnrollment.latefee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee):discountedfee)];
    }else{
        tmpTotalDiscount=[NSString stringWithFormat:@"%g",[workingEnrollment.tuitionfee floatValue]-(globalvariables.centerrecord.noofroundoffdigit==0?lroundf(discountedfee):discountedfee)];
    }

    
    if (((CenterRecord *)[MyClass returncenterrecordwithcenterkey:globalvariables.centerrecord.centerkey]).noofroundoffdigit==1) {
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
    

    return tmpTotalDiscount;

    
}

-(void) sharesalespaymentinvoicewithtableview:(UITableView *)tableview indexpath:(NSIndexPath *)indexpath
{
    SalesRecord *SalesObject=DetailsViewSales;
//    SalesRecord *workingEnrollment=DetailsViewEnrollment;
    Student *PopoverStudent=DetailsViewStudent;
//    NSIndexPath *paymentindexpath=[NSIndexPath indexPathForRow:0 inSection:0];
    NSString *tmpTotalDiscount=[self calculatesalestotaldiscount];
    
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
    [[mySharePopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [documentInteractionController presentOptionsMenuFromRect:invoiceprintbutton.bounds inView:invoiceprintbutton animated:YES];
}

-(void) sharesalespaymentreceiptwithtableview:(UITableView *)tableview indexpath:(NSIndexPath *)indexpath
{
    SalesRecord *SalesObject=DetailsViewSales;
    SalesRecord *workingSales=DetailsViewSales;
    Student *PopoverStudent=DetailsViewStudent;
    NSIndexPath *paymentindexpath=[NSIndexPath indexPathForRow:0 inSection:0];
    NSString *tmpTotalDiscount=[self calculatesalestotaldiscount];
    
    SalesReceiptRecord *salesreceiptrecord=[[SalesReceiptRecord alloc]initSalesReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage saleskey:SalesObject.saleskey orderdate:SalesObject.orderdate price:SalesObject.price discount:tmpTotalDiscount totalfee:SalesObject.total productcode:SalesObject.productcode quantity:SalesObject.quantity paymentkey:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paiddate paid:SalesObject.paid paidmethod:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath sales:SalesObject] staffname:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil salesrecord:SalesObject paymentremarks:((PaymentRecord *)[workingSales.paymentrecords objectAtIndex:paymentindexpath.row]).paymentremarks productname:nil];
    
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
    
    
    [[mySharePopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [documentInteractionController presentOptionsMenuFromRect:receiptprintbutton.bounds inView:receiptprintbutton animated:YES];
}

-(void) shareenrollmentpaymentreceiptwithtableview:(UITableView *)tableview indexpath:(NSIndexPath *)indexpath
{
    EnrollmentRecord *PopoverEnrollment=DetailsViewEnrollment;
    EnrollmentRecord *workingEnrollment=DetailsViewEnrollment;
    Student *PopoverStudent=DetailsViewStudent;
    NSIndexPath *paymentindexpath=[NSIndexPath indexPathForRow:0 inSection:0];
    NSString *tmpTotalDiscount=[self calculateenrollmenttotaldiscount];
    
    NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Receipt"];
    
    if (classday) {
        ClassReceiptRecord *classreceiptrecord=[[ClassReceiptRecord alloc]initClassReceiptRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:tmpTotalDiscount totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain paymentkey:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).paymentkey paiddate:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).paiddate paid:PopoverEnrollment.paid paidmethod:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).paidmethod totalpaid:[self returntotalpaidwithindexpath:paymentindexpath enrollment:PopoverEnrollment] staffname:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).staffname receiptremarks:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).receiptremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment paymentremarks:((PaymentRecord *)[workingEnrollment.paymentrecords objectAtIndex:paymentindexpath.row]).paymentremarks subjectname:nil];
        
        
        NSData *pdfData=[MyClass generateReceiptWithClassReceiptArray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] SalesReceiptArray:nil papersizeoverride:NO combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
        
        // Create a filePath for the pdf.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Receipt-%@.pdf",[MyClass returnreceiptnumberwithclassreceiptarray:[[NSMutableArray alloc]initWithObjects:classreceiptrecord,nil] salesreceiptarray:nil]]];
        [pdfData writeToFile:filePath atomically:YES];
        
        // Open the controller.
        documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
        documentInteractionController.delegate = self;
        documentInteractionController.UTI = @"com.adobe.pdf";
        [documentInteractionController setName:@"Receipt"];
        

        [[mySharePopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        
        //CGRect rect=CGRectMake(0, 3, 50, 30);

        [documentInteractionController presentOptionsMenuFromRect:receiptprintbutton.bounds inView:receiptprintbutton animated:YES];
    }
}

-(void) shareenrollmentpaymentinvoicewithtableview:(UITableView *)tableview indexpath:(NSIndexPath *)indexpath
{
    EnrollmentRecord *PopoverEnrollment=DetailsViewEnrollment;
//    EnrollmentRecord *workingEnrollment=DetailsViewEnrollment;
    Student *PopoverStudent=DetailsViewStudent;
    NSString *classday=[self retrieveClassDaywithEnrollmentkeyForDocument:PopoverEnrollment.enrollmentkey type:@"Invoice"];
    if (classday) {
        ClassInvoiceRecord *classinvoicerecord=[[ClassInvoiceRecord alloc]initClassInvoiceRecordWithstudentkey:PopoverStudent.studentkey studentname:nil studentid:PopoverStudent.studentid parentemail:PopoverStudent.parentemail preferredlanguage:PopoverStudent.preferredlanguage enrollmentkey:PopoverEnrollment.enrollmentkey enrollmentdate:PopoverEnrollment.enrollmentdate tuitionfee:PopoverEnrollment.tuitionfee enrollmentfee:PopoverEnrollment.enrollmentfee latefee:PopoverEnrollment.latefee discount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.tuitionfee floatValue]+[PopoverEnrollment.enrollmentfee floatValue]+[PopoverEnrollment.latefee floatValue]-[PopoverEnrollment.totalfee floatValue]] totalfee:PopoverEnrollment.totalfee subject_shortname:PopoverEnrollment.subject startdate:PopoverEnrollment.startdate noofclass:PopoverEnrollment.noofclass enddate:PopoverEnrollment.enddate classtime:PopoverEnrollment.classtime classday:classday levelmain:PopoverEnrollment.levelmain outstandingamount:[NSString stringWithFormat:@"%g",[PopoverEnrollment.totalfee floatValue]-[PopoverEnrollment.paid floatValue]] invoiceremarks:PopoverEnrollment.invoiceremarks image:nil checkstatus:nil validity:PopoverEnrollment.validity enrollmentrecord:PopoverEnrollment subjectname:nil];
    
    
        NSData *pdfData = [MyClass generateInvoiceWithClassInvoiceArray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] SalesInvoiceArray:nil papersizeoverride:NO combinedocument:YES centerkey:globalvariables.centerrecord.centerkey];
        
        // Create a filePath for the pdf.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"Invoice-%@.pdf",[MyClass returninvoicenumberwithclassinvoicearray:[[NSMutableArray alloc]initWithObjects:classinvoicerecord,nil] salesinvoicearray:nil updateinvoicelog:NO]]];
        [pdfData writeToFile:filePath atomically:YES];
        
        // Open the controller.
        documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:filePath]];
        documentInteractionController.delegate = self;
        documentInteractionController.UTI = @"com.adobe.pdf";
        [documentInteractionController setName:@"Invoice"];
        
        [[mySharePopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        
        
        [documentInteractionController presentOptionsMenuFromRect:invoiceprintbutton.bounds inView:invoiceprintbutton animated:YES];
        
    }
}

- (void)emailPDF:(NSData*)pdfData pdftype:(NSString *) pdftype filename:(NSString *)filename receiptient:(NSArray *)receipientarray{
    
    if(receipientarray.count==0){
        [[mySharePopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
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
        
        [[mySharePopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
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


- (void)printPDF:(NSData*)pdfData{
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
    
    [[mySharePopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
    //[printer presentAnimated:YES completionHandler:completionHandler];

    if ([invoiceorreceipt isEqualToString:@"receipt"]) {
        [printer presentFromRect:receiptprintbutton.frame inView:receiptprintbutton animated:YES completionHandler:nil];
    }else{
        [printer presentFromRect:invoiceprintbutton.frame inView:invoiceprintbutton animated:YES completionHandler:nil];
    }
    
}

-(NSString *) returntotalpaidwithindexpath:(NSIndexPath *)indexpath enrollment:(EnrollmentRecord *)enrollment
{
    float totalpaid=0;
    for (long i=indexpath.row; i<enrollment.paymentrecords.count; i++) {
        totalpaid+=[((PaymentRecord *)[enrollment.paymentrecords objectAtIndex:i]).paidamount floatValue];
    }
    
    return [NSString stringWithFormat:@"%g",totalpaid];
}

-(NSString *) returntotalpaidwithindexpath:(NSIndexPath *)indexpath sales:(SalesRecord *)sales
{
    float totalpaid=0;
    for (long i=indexpath.row; i<sales.paymentrecords.count; i++) {
        totalpaid+=[((PaymentRecord *)[sales.paymentrecords objectAtIndex:i]).paidamount floatValue];
    }
    
    return [NSString stringWithFormat:@"%g",totalpaid];
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
        return [MyClass returnformattedclassdaystringwithclassdaystring:classdaystring language:DetailsViewStudent.preferredlanguage];
    }
    
    return @"";
    
//    NSInteger count=classArray.count;
//    if ([invoiceorreceipt isEqualToString:@"invoice"]) {
//        if(globalvariables.centerrecord.showclassdatesininvoice==1){
//            //show first class only
//            count=1;
//        }
//    }else if ([invoiceorreceipt isEqualToString:@"receipt"]) {
//        if(globalvariables.centerrecord.showclassdatesinreceipt==1){
//            //show first class only
//            count=1;
//        }
//    }
//
//    NSString *classdatestring=@"";
//    for (int i=0; i<count; i++) {
//        FreeScheduleClass *obj=[classArray objectAtIndex:i];
//        if(globalvariables.centerrecord.printclassdatemode && [obj.attendance isEqualToString:@"Makeup"]){
//            date=[MyClass convertToNSDateWithDate:obj.makeupdate DateFormat:@"dd-MMM-yyyy"];
//            time=[obj.makeuptime isEqualToString:@""]?@"TBD":obj.makeuptime;
//        }else{
//            date=[MyClass convertToNSDateWithDate:obj.classdate DateFormat:@"dd-MMM-yyyy"];
//            time=obj.classtime;
//        }
//
//        if (![PopoverStudent.preferredlanguage isEqualToString:@"English"]) {
//            language=@"Chinese";
//        }else{
//            language=@"English";
//        }
//
//        if (i==0) {
//            if (date && ![time isEqualToString:@"TBD"]) {
//                classdatestring=[NSString stringWithFormat:@"%@(%@/%@)",[MyClass convertToNSStringWithNSDate:date DateFormat:@"yyyy-MM-dd"],[MyClass convertToNSStringWithNSDate:date ToDateFormat:@"EEE" Language:language],time];
//            }else{
//                classdatestring=[MyClass returntitlewithtitle:@"TBD" language:language];
//            }
//        }else{
//            if (i%noofdayperline ==0) {
//                if (date && ![time isEqualToString:@"TBD"]) {
//                    classdatestring=[NSString stringWithFormat:@"%@\r\n%@(%@/%@)",classdatestring,[MyClass convertToNSStringWithNSDate:date DateFormat:@"yyyy-MM-dd"],[MyClass convertToNSStringWithNSDate:date ToDateFormat:@"EEE" Language:language],time];
//                }else{
//                    classdatestring=[NSString stringWithFormat:@"%@\r\n%@",classdatestring,[MyClass returntitlewithtitle:@"TBD" language:language]];
//                }
//
//            }else{
//                if (date && ![time isEqualToString:@"TBD"]) {
//                    classdatestring=[NSString stringWithFormat:@"%@, %@(%@/%@)",classdatestring,[MyClass convertToNSStringWithNSDate:date DateFormat:@"yyyy-MM-dd"],[MyClass convertToNSStringWithNSDate:date ToDateFormat:@"EEE" Language:language],time];
//                }else{
//                    classdatestring=[NSString stringWithFormat:@"%@, %@",classdatestring,[MyClass returntitlewithtitle:@"TBD" language:language]];
//                }
//            }
//        }
//    }
//
//    if (classArray.count!=count) {
//        return [NSString stringWithFormat:@"%@: %@",[MyClass returntitlewithtitle:@"Class starts on:"],classdatestring];
//    }
//    return classdatestring;
}


-(void) pickerBottomButtonPressedWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex BottomMode:(NSString *)bottommode SelectedItems:(NSMutableArray *)selecteditems
{
    if ([datatype isEqualToString:@"quickpay"]) {
        if ([bottommode isEqualToString:@"Add to Folder"]) {
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:dataindex inSection:0];

            if (!EnrollmentRecordView.hidden) {
                EnrollmentRecord *obj=[filteredDetailsViewEnrollmentArray objectAtIndex:indexPath.row];
                if ([obj.status isEqualToString:@"Voided"]){
                    UIAlertController *enrollalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"Voided item cannot be added"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

                    }];
                    
                    [enrollalert addAction:OKAction];
                    [self presentViewController:enrollalert animated:YES completion:nil];

                    return;
                }else{
                    if (![globalvariables.documentfolder.classpaymentarray containsObject:obj.enrollmentkey]) {
                        [globalvariables.documentfolder.classpaymentarray addObject:obj.enrollmentkey];
                    }
                    
                    if (![globalvariables.documentfolder.classinvoicearray containsObject:obj.enrollmentkey]) {
                        [globalvariables.documentfolder.classinvoicearray addObject:obj.enrollmentkey];
                    }

                    
                    if (![globalvariables.documentfolder.classreceiptarray containsObject:obj.enrollmentkey] && obj.paymentrecords.count>0) {
                        [globalvariables.documentfolder.classreceiptarray addObject:obj.enrollmentkey];
                    }
                    
                    if (![obj.paid isEqualToString:obj.totalfee]) {
                        if (![globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:obj.enrollmentkey]) {
                            [globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys addObject:obj.enrollmentkey];
                        }
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:obj.enrollmentkey]) {
                        [globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys addObject:obj.enrollmentkey];
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:obj.enrollmentkey] && obj.paymentrecords.count>0) {
                        [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys addObject:obj.enrollmentkey];
                    }
                    
                    
//                    if (![lastpaymentkey isEqualToString:@""]) {
//                        if (![globalvariables.documentfolder.defaultcheckedclassreceiptpaymentkeys containsObject:lastpaymentkey]) {
//                            [globalvariables.documentfolder.defaultcheckedclassreceiptpaymentkeys addObject:lastpaymentkey];
//                        }
//                    }

                    [self showAddToDocumentFolderAnimationWithTableview:DetailsViewEnrollmentTable IndexPath:indexPath];
                    [self refreshdocumentfoldercount];
                    [DetailsViewEnrollmentTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }else{
                SalesRecord *obj=[filteredSalesRecordArray objectAtIndex:indexPath.row];
                if ([obj.productcode isEqualToString:@"FPAY"]){
                    UIAlertController *enrollalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"Forfeited payment cannot be added"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

                    }];
                    
                    [enrollalert addAction:OKAction];
                    [self presentViewController:enrollalert animated:YES completion:nil];

                    return;
                }else if ([obj.status isEqualToString:@"Voided"]){
                    UIAlertController *enrollalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Document Folder"] message:[MyClass returntitlewithtitle:@"Voided item cannot be added"] preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {

                    }];
                    
                    [enrollalert addAction:OKAction];
                    [self presentViewController:enrollalert animated:YES completion:nil];

                    return;
                }else{
                    if (![globalvariables.documentfolder.salespaymentarray containsObject:obj.saleskey]) {
                        [globalvariables.documentfolder.salespaymentarray addObject:obj.saleskey];
                    }
                    
                    if (![globalvariables.documentfolder.salesinvoicearray containsObject:obj.saleskey]) {
                        [globalvariables.documentfolder.salesinvoicearray addObject:obj.saleskey];
                    }
                    
                    if (![globalvariables.documentfolder.salesreceiptarray containsObject:obj.saleskey] && obj.paymentrecords.count>0) {
                        [globalvariables.documentfolder.salesreceiptarray addObject:obj.saleskey];
                    }
                    
                    if (![obj.paid isEqualToString:obj.total]) {
                        if (![globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:obj.saleskey]) {
                            [globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys addObject:obj.saleskey];
                        }
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:obj.saleskey]) {
                        [globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys addObject:obj.saleskey];
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys containsObject:obj.saleskey] && obj.paymentrecords.count>0) {
                        [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys addObject:obj.saleskey];
                    }
                    
//
//                    if (![lastpaymentkey isEqualToString:@""]) {
//                        if (![globalvariables.documentfolder.defaultcheckedsalesreceiptpaymentkeys containsObject:lastpaymentkey]) {
//                            [globalvariables.documentfolder.defaultcheckedsalesreceiptpaymentkeys addObject:lastpaymentkey];
//                        }
//                    }

                    [self showAddToDocumentFolderAnimationWithTableview:SalesTable IndexPath:indexPath];
                    [self refreshdocumentfoldercount];
                    [SalesTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }
            }
        }
    }else if ([datatype isEqualToString:@"MessageContact"]) {
        if ([bottommode isEqualToString:@"Forward"]) {
            [self closesidewindow];
            [self forwardMessage:selecteditems];
        }
    }
}

-(NSString *) returnForwardMessageChannel:(MessageContactRecord *)obj
{
    NSString *channel=forwardmessagerecord.channel;
    if ([channel isEqualToString:@"A"]) {
        if([obj.messagecontacttype isEqualToString:@"Lead"]){
            channel=globalvariables.centerrecord.defaultleadmessagechannel;
        }
    }else if ([channel isEqualToString:@"AS"]){
        if([obj.messagecontacttype isEqualToString:@"Lead"]){
            channel=globalvariables.centerrecord.defaultleadmessagechannel;
        }else if ([obj.messagecontacttype isEqualToString:@"Staff"] || [obj.messagecontacttype isEqualToString:@"Group"]){
            channel=@"A";
        }
    }else if ([channel isEqualToString:@"E"]){
        if ([obj.messagecontacttype isEqualToString:@"Staff"] || [obj.messagecontacttype isEqualToString:@"Group"]){
            channel=@"A";
        }
    }else if ([channel isEqualToString:@"S"]){
        if ([obj.messagecontacttype isEqualToString:@"Staff"] || [obj.messagecontacttype isEqualToString:@"Group"]){
            channel=@"A";
        }
    }
    return channel;
}

- (IBAction)forwardMessageButtonPressed:(UIButton *)sender {
    [self retrievenewmessagecontact];
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PickerViewController *pickerviewcontroller = (PickerViewController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil] instantiateViewControllerWithIdentifier: @"PickerViewController"];
        pickerviewcontroller.delegate=self;
        pickerviewcontroller.selecteditems=[[NSMutableArray alloc]init];
        pickerviewcontroller.datatype=@"MessageContact";
        pickerviewcontroller.showsearchbar=YES;
        pickerviewcontroller.bottommode=@"Forward";
        pickerviewcontroller.viewtitle=@"New Contact";
        pickerviewcontroller.preferredContentSize=CGSizeMake(320, 40*NewContactArray.count);
        pickerviewcontroller.itemsarray=NewContactArray;
        pickerviewcontroller.multipleSelection=YES;

        CGRect frame=mainWindow.bounds;
        frame.size.width=320;
        pickerviewcontroller.view.frame=frame;
        [self->sidewindowview addSubview:pickerviewcontroller.view];
        [self addChildViewController:pickerviewcontroller];
        [pickerviewcontroller didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
}

-(void) selectMessageWithIndex:(NSInteger)index
{
    InboxMessageRecord *obj=[filteredMessageArray objectAtIndex:index];
    if ([selectedinboxmessages containsObject:obj.inboxmessagekey]) {
        [selectedinboxmessages removeObject:obj.inboxmessagekey];
    }else{
        [selectedinboxmessages addObject:obj.inboxmessagekey];
    }
    
    if (selectStatusView.hidden) {
        [DetailsViewMessageTable reloadData];
    }else{
        [DetailsViewMessageTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [DetailsViewMessageTable deselectRowAtIndexPath:[DetailsViewMessageTable indexPathForSelectedRow] animated:NO];
    }
    
    deleteMessageButton.enabled=selectedinboxmessages.count>0;
    forwardMessageButton.enabled=selectedinboxmessages.count>0;
    selectedTitle.text=[MyClass returnreplacedtitlewithtitle:@"%@1 Selected" replacementarray:@[[@(selectedinboxmessages.count) stringValue]]];
}

- (void) forwardMessage:(NSMutableArray *)selecteditems
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
        [dictionary setValue:@"forwardmessage2" forKey:@"postaction"];
        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
        [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dictionary setValue:[selectedinboxmessages componentsJoinedByString:@","] forKey:@"inboxmessagekeys"];
        [dictionary setValue:[forwardmessagerecord.sender isEqualToString:globalvariables.username]?globalvariables.username:@"center" forKey:@"sender"];
        [dictionary setValue:globalvariables.username forKey:@"composer"];
        
        NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
        NSArray *keys=[NSArray arrayWithObjects:@"recipienttype",@"recipient",nil];
        NSArray *values;
        NSDictionary *dict;
        NSArray *jsonrecipientarray=[[NSArray alloc]init];
        
        for (int i=0; i<selecteditems.count; i++) {
            MessageContactRecord *obj=[selecteditems objectAtIndex:i];
            values=[NSArray arrayWithObjects:obj.messagecontacttype,obj.messagecontact,nil];
            dict = [NSDictionary dictionaryWithObjects:values forKeys:keys];
            [arrayOfDicts addObject:dict];
        }
        
        jsonrecipientarray = [NSArray arrayWithArray:arrayOfDicts];
        
        [dictionary setValue:jsonrecipientarray forKey:@"recipients"];
        
        __block BOOL result=FALSE;
        [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
            }
        }];
        
        if (result) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                selectStatusView.hidden=YES;
                forwardMessageButton.hidden=YES;
                selectMode=nil;
                [DetailsViewMessageTable reloadData];
                selectedinboxmessages=[[NSMutableArray alloc]init];
                selectedoutboxmessages=[[NSMutableArray alloc]init];
                [self retrieveMessageRecord];
            });
        }else{
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            [MyClass showconnectionlostdialogbox];
        }
    });
}


-(void) showreadstatusdetails:(NSInteger)row
{
        InboxMessageRecord *obj=[filteredMessageArray objectAtIndex:row];
        NSMutableArray *readstatusdetailsarray=obj.readstatusdetailsarray;
        
        [self startsidewindowanimationwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PickerViewController *pickerviewcontroller = (PickerViewController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil] instantiateViewControllerWithIdentifier: @"PickerViewController"];
            pickerviewcontroller.delegate=self;
            pickerviewcontroller.selecteditems=[[NSMutableArray alloc]init];
            pickerviewcontroller.datatype=@"ReadStatusDetails";
            pickerviewcontroller.showsearchbar=NO;
            pickerviewcontroller.bottommode=nil;
            pickerviewcontroller.viewtitle=@"Read Status Details";
            pickerviewcontroller.preferredContentSize=CGSizeMake(320, 40*readstatusdetailsarray.count);
            pickerviewcontroller.itemsarray=readstatusdetailsarray;
            
            //pickerviewcontroller.view.frame=self->mainWindow.bounds;
            CGRect frame=mainWindow.bounds;
            frame.size.width=320;
            pickerviewcontroller.view.frame=frame;
            [self->sidewindowview addSubview:pickerviewcontroller.view];
            [self addChildViewController:pickerviewcontroller];
            [pickerviewcontroller didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            self->ailoadindicator.hidden=YES;
        });
    
}

- (IBAction)deleteMessageButtonPressed:(UIButton *)sender
{
//    InboxMessageRecord *obj=[filteredMessageArray objectAtIndex:row];
    UIAlertController *disablealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Message Record"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the message record?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        
        NSString *inboxmessagekeys=@"";
        if (selectedinboxmessages.count>0) {
            inboxmessagekeys=[selectedinboxmessages componentsJoinedByString:@","];
        }
        
        for (int i=0; i<messageArray.count; i++) {
            if ([selectedinboxmessages containsObject:((InboxMessageRecord *)[messageArray objectAtIndex:i]).inboxmessagekey]) {
                [messageArray removeObjectAtIndex:i];
                i--;
            }else if ([selectedoutboxmessages containsObject:((InboxMessageRecord *)[messageArray objectAtIndex:i]).outboxmessagekey]) {
                [messageArray removeObjectAtIndex:i];
                i--;
            }
        }

        for (int i=0; i<filteredMessageArray.count; i++) {
            if ([selectedinboxmessages containsObject:((InboxMessageRecord *)[filteredMessageArray objectAtIndex:i]).inboxmessagekey]) {
                [filteredMessageArray removeObjectAtIndex:i];
                i--;
            }else if ([selectedoutboxmessages containsObject:((InboxMessageRecord *)[filteredMessageArray objectAtIndex:i]).outboxmessagekey]) {
                [filteredMessageArray removeObjectAtIndex:i];
                i--;
            }
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
            [dictionary setValue:@"updateinboxmessage" forKey:@"postaction"];
            [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
            [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
            [dictionary setValue:@"Delete" forKey:@"action"];
            [dictionary setValue:@"center" forKey:@"apptype"];
            //[dictionary setValue:globalvariables.username forKey:@"username"];
            
//            [dictionary setValue:obj.inboxmessagekey forKey:@"inboxmessagekey"];
            [dictionary setValue:inboxmessagekeys forKey:@"inboxmessagekey"];
            dictionary=[MyClass addchecksumparameterwithdictionary:dictionary];
            
            
            __block BOOL result=FALSE;
            [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
                if (succeeded) {
                    result=TRUE;
                }
            }];
            
            if (result) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    selectStatusView.hidden=YES;
                    deleteMessageButton.hidden=YES;
                    selectMode=nil;
                    [DetailsViewMessageTable reloadData];
                    selectedinboxmessages=[[NSMutableArray alloc]init];
                    selectedoutboxmessages=[[NSMutableArray alloc]init];
                    [self retrieveMessageRecord];
                });
            }else{
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                [MyClass showconnectionlostdialogbox];
            }
        });
        
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [disablealert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [disablealert addAction:OKAction];
    [disablealert addAction:CancelAction];
    
    [self presentViewController:disablealert animated:YES completion:nil];
}

- (void)reSendInstantMessage:(NSInteger)row {

    InboxMessageRecord *resendrecord=[filteredMessageArray objectAtIndex:row];
    workingMessage=[[OutboxMessageRecord alloc]init];
    workingMessage.messagetype=resendrecord.messagetype;
    workingMessage.sender=resendrecord.sender;
    workingMessage.channel=resendrecord.channel;
    workingMessage.hotnews=NO;
    workingMessage.hn_expiry_date=@"";
    workingMessage.messageenglish=resendrecord.messageenglish;
    workingMessage.messagechinese=resendrecord.messagechinese;
    workingMessage.status=@"";
    workingMessage.photoarray=[MyClass copyPhotoArrayWithPhotoArray:resendrecord.photoarray LoadInternalURL:YES];
    [self sendinstantmessagebuttonpressed:nil];
}

-(void) audioSliderValueChanged:(UISlider *)sender
{
    MyTableViewCell *cell=[DetailsViewMessageTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    if (audioPlayer) {
        [audioPlayer stop];
        CGFloat secondToPlay=sender.value;
        audioPlayer.currentTime=secondToPlay;
        [audioPlayer play];
        [cell.button4 setImage:[UIImage imageNamed:@"pauseicon.png"] forState:UIControlStateNormal];
    }else{
        [self playAudioButtonPressed:cell.button4];
    }
}

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [sliderTimer invalidate];
        MyTableViewCell *cell=[DetailsViewMessageTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedUIslide.tag inSection:0]];
        [cell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
        cell.slider1.value=cell.slider1.minimumValue;
        audioPlayer=nil;
        selectedUIslide=nil;
        //[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
}

-(void) playAudioButtonPressed:(UIButton *)sender
{
    if (selectMode) {
        [self selectMessageWithIndex:sender.tag];
        return;
    }
    
    MyTableViewCell *newcell=[DetailsViewMessageTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    MyTableViewCell *previouscell=[DetailsViewMessageTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedUIslide.tag inSection:0]];
    
    if ([newcell.slider1 isEqual:selectedUIslide]) {
        if (audioPlayer.playing) {
            [audioPlayer stop];
            //[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
            [sliderTimer invalidate];
            [newcell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
        }else{
            [newcell.button4 setImage:[UIImage imageNamed:@"pauseicon.png"] forState:UIControlStateNormal];
            [audioPlayer play];
            //[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
            sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
        }
    }else{
        if (previouscell) {
            [audioPlayer stop];
            [previouscell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
        }
        
        //[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        MessagePhotoRecord *obj=[((InboxMessageRecord *)[filteredMessageArray objectAtIndex:sender.tag]).photoarray firstObject];

        NSString *strURL=[NSString stringWithFormat:@"%@messageimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,obj.messagephotourl];
        NSURL *audioURL = [NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
        NSData *data = [NSData dataWithContentsOfURL:audioURL];
        
        audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
        audioPlayer.delegate=self;
        audioPlayer.currentTime=newcell.slider1.value;

        //newcell.slider1.maximumValue = audioPlayer.duration;
        selectedUIslide=newcell.slider1;
        
        [newcell.button4 setImage:[UIImage imageNamed:@"pauseicon.png"] forState:UIControlStateNormal];
        //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error: nil];
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord mode:AVAudioSessionModeDefault options:AVAudioSessionCategoryOptionDefaultToSpeaker | AVAudioSessionCategoryOptionAllowBluetoothHFP | AVAudioSessionCategoryOptionAllowBluetoothA2DP error:nil];
        [audioPlayer play];
        newcell.slider1.maximumValue = audioPlayer.duration;
        //[[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
        sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
    }
}

- (void)updateSlider {
    // Update the slider about the music time
    selectedUIslide.value = audioPlayer.currentTime;
    NSLog(@"sliderTimer Running");
}

- (IBAction)pointbuttonpressed:(id)sender {
    pointviewcontroller=(PointViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"PointViewController"];
    pointviewcontroller.delegate=self;
    pointviewcontroller.studentkey=DetailsViewStudent.studentkey;
    [self.navigationController pushViewController:pointviewcontroller animated:YES];
}

- (IBAction)updateCouponFilter:(id)sender {
    [self returnfiltercouponarray];
}

- (IBAction)replyToMessageCancelButtonPressed:(id)sender {
    replyToMessageView.hidden=YES;
    replyToMessageRecord=nil;
    [self.view layoutIfNeeded];
}

- (IBAction)stopAudioRecording:(id)sender {
    //if (audioRecorder.isRecording) {
        if (audioRecorder.currentTime<1 || !audioRecorder.isRecording) {
            [self cancelAudioRecording];
        }else{
            [self stopAudioRecording];
        }
    //}
}

- (IBAction)startAudioRecording:(id)sender {
    [MyClass playBeepSoundWithType:@"audiostart"];
    [impactFeedbackGenerator impactOccurred];
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopAudioPlaying];
        [self startAudioRecording];
    //});
}

-(void) stopAudioPlaying
{
    if (audioPlayer) {
        if (audioPlayer.playing) {
            [audioPlayer stop];
            [sliderTimer invalidate];
            MyTableViewCell *previouscell=[DetailsViewMessageTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedUIslide.tag inSection:0]];
            [previouscell.button4 setImage:[UIImage imageNamed:@"playicon2.png"] forState:UIControlStateNormal];
        }
        audioPlayer=nil;
        selectedUIslide=nil;
    }
}


-(void) updateMeters
{
    NSTimeInterval duration=audioRecorder.currentTime;
    NSInteger second=(NSInteger)duration%60;
    NSInteger minute=duration/60;
    
    recordingDuration.text=[NSString stringWithFormat:@"%ld:%02li",(long)minute,second];
}

- (BOOL) startAudioSession
{
    // Prepare the audio session
    NSError *error;
    AVAudioSession *session = [AVAudioSession sharedInstance];

    if (![session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
    {
        NSLog(@"Error setting session category: %@", error.localizedFailureReason);
        return NO;
    }


    if (![session setActive:YES error:&error])
    {
        NSLog(@"Error activating audio session: %@", error.localizedFailureReason);
        return NO;
    }

    return session.isInputAvailable;
}

- (BOOL) startAudioRecording
{
    if (audioRecorder.isRecording) {
        return YES;
    }
    
    NSError *error;

    // Recording settings
    NSMutableDictionary *settings = [NSMutableDictionary dictionary];

    [settings setValue: [NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
    [settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
    [settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
    [settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    [settings setValue:  [NSNumber numberWithInt: AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSArray *searchPaths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex: 0];
    NSString* filePath = [documentPath stringByAppendingPathComponent:@"tmpischool"];
    filePath = [filePath stringByAppendingPathComponent:[MyClass returnAudioRecordingFileName]];
    NSURL *audioURL = [NSURL fileURLWithPath:filePath];

    // Create recorder
    audioRecorder = [[AVAudioRecorder alloc] initWithURL:audioURL settings:settings error:&error];
    if (!audioRecorder)
    {
        NSLog(@"Error establishing recorder: %@", error.localizedFailureReason);
        return NO;
    }

    // Initialize degate, metering, etc.
    audioRecorder.delegate = self;
    audioRecorder.meteringEnabled = YES;
    //self.title = @"0:00";

    if (![audioRecorder prepareToRecord])
    {
        NSLog(@"Error: Prepare to record failed");
        return NO;
    }

    /*if (![audioRecorder record])
    {
        NSLog(@"Error: Record failed");
        return NO;
    }*/

    // Set a timer to monitor levels, current time
    audioRecorderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];

    
    [workingMessage.photoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:nil Width:0 Height:0 FileType:@"audio" InternalURL:audioURL FileName:@"" ThumbnailURL:@""]];
    recordingStatusView.hidden=NO;
    [audioRecordingImage setImage:[UIImage imageNamed:@"audio_recording.png"]];
    slideToCancelTitle.font=[UIFont systemFontOfSize:17];
    slideToCancelTitle.textColor=[UIColor grayColor];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.45 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![audioRecorder record])
        {
            NSLog(@"Error: Record failed");
            //return NO;
        }

        NSLog(@"Audio recording started");
        //return YES;
    });
    return YES;
}

- (void) stopAudioRecording
{
    if (audioRecorder.isRecording) {
        NSLog(@"Audio recording stopped");
        [impactFeedbackGenerator impactOccurred];
        recordingStatusView.hidden=YES;
        ((MessagePhotoRecord *)[workingMessage.photoarray firstObject]).height=audioRecorder.currentTime;
        [audioRecorder stop];
        audioRecorder=nil;
        [audioRecorderTimer invalidate];
        recordAudioButton.enabled=NO;
        [MyClass playBeepSoundWithType:@"audiostop"];
        [self sendinstantmessagebuttonpressed:nil];
    }else{
        [self cancelAudioRecording];
    }
}

- (void) cancelAudioRecording
{
    NSLog(@"Audio recording cancelled");
    [impactFeedbackGenerator impactOccurred];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [impactFeedbackGenerator impactOccurred];
    });
    [MyClass playBeepSoundWithType:@"audiocancel"];
    recordingStatusView.hidden=YES;
    [audioRecorder stop];
    audioRecorder=nil;
    [audioRecorderTimer invalidate];
    [workingMessage.photoarray removeAllObjects];
    sendinstantmessagebutton.enabled=[self enableSendButton];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void) enrollmentoutstandingbuttonpressed:(UIButton *)sender
{
    NSMutableArray *itemArray=[[NSMutableArray alloc]initWithArray:[MyClass returnPaidMethodArray]];
    float creditbalance=0;
    EnrollmentRecord *enrollmentObject=[filteredDetailsViewEnrollmentArray objectAtIndex:sender.tag];
    if ([enrollmentObject.paid floatValue]-[enrollmentObject.totalfee floatValue]<0) {
        creditbalance=((Student *)[MyClass returnstudentwithstudentkey:enrollmentObject.studentkey]).creditamount;
    }
    
    if (creditbalance>0) {
        [itemArray insertObject:@"Credit Balance" atIndex:0];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"quickpay" DataIndex:sender.tag ShowSearchBar:NO BottomMode:@"Add to Folder" PreferredContentSize:CGSizeMake(220, 448) View:self Button:sender ItemsArray:itemArray Title:nil];
}

-(void) enrollmentinvoicebuttonpressed:(UIButton *)sender
{
    invoiceorreceipt=@"invoice";
    invoiceprintbutton=sender;
    DetailsViewEnrollment=[filteredDetailsViewEnrollmentArray objectAtIndex:sender.tag];
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"shareenrollmentdocument" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 160) View:self Button:sender ItemsArray:[[NSMutableArray alloc]initWithObjects:/*@"Print",*/@"Send eInvoice",@"Send Email",@"Add to Folder",@"More", nil] Title:nil];
}

-(void) enrollmentreceiptbuttonpressed:(UIButton *)sender
{
    invoiceorreceipt=@"receipt";
    receiptprintbutton=sender;
    
    DetailsViewEnrollment=[filteredSalesRecordArray objectAtIndex:sender.tag];
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"shareenrollmentdocument" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 160) View:self Button:sender ItemsArray:[[NSMutableArray alloc]initWithObjects:@"Send eReceipt",@"Send Email",@"Add to Folder",@"More", nil] Title:nil];
}

-(void) salesinvoicebuttonpressed:(UIButton *)sender
{
    invoiceorreceipt=@"invoice";
    invoiceprintbutton=sender;
    DetailsViewSales=[filteredSalesRecordArray objectAtIndex:sender.tag];
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"sharesalesdocument" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 160) View:self Button:sender ItemsArray:[[NSMutableArray alloc]initWithObjects:/*@"Print",*/@"Send eInvoice",@"Send Email",@"Add to Folder",@"More", nil] Title:nil];
}

-(void) salesreceiptbuttonpressed:(UIButton *)sender
{
    invoiceorreceipt=@"receipt";
    receiptprintbutton=sender;
    
    DetailsViewSales=[filteredSalesRecordArray objectAtIndex:sender.tag];
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"sharesalesdocument" DataIndex:sender.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 160) View:self Button:sender ItemsArray:[[NSMutableArray alloc]initWithObjects:@"Send eReceipt",@"Send Email",@"Add to Folder",@"More", nil] Title:nil];
}

-(void) salesoutstandingbuttonpressed:(UIButton *)sender
{
    NSMutableArray *itemArray=[[NSMutableArray alloc]initWithArray:[MyClass returnPaidMethodArray]];
    float creditbalance=0;
    SalesRecord *salesObject=[filteredSalesRecordArray objectAtIndex:sender.tag];
    if ([salesObject.paid floatValue]-[salesObject.total floatValue]<0) {
        creditbalance=((Student *)[MyClass returnstudentwithstudentkey:salesObject.studentkey]).creditamount;
    }
    
    if (creditbalance>0) {
        [itemArray insertObject:@"Credit Balance" atIndex:0];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"quickpay" DataIndex:sender.tag ShowSearchBar:NO BottomMode:@"Add to Folder" PreferredContentSize:CGSizeMake(220, 448) View:self Button:sender ItemsArray:itemArray Title:nil];
}

-(void) quickPayWithStudentKey:(NSString *)studentkey paidMethod:(NSString *)paymethod enrollmentkey:(NSString *)enrollmentkey saleskey:(NSString *)saleskey
{
    //quick pay upload
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    
    [dictionary setValue:@"quickpay4" forKey:@"postaction"];
    [dictionary setValue:globalvariables.username forKey:@"updatedby"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:studentkey forKey:@"studentkey"];
    if (enrollmentkey) {
        [dictionary setValue:enrollmentkey forKey:@"enrollmentkey"];
    }
    
    if (saleskey) {
        [dictionary setValue:saleskey forKey:@"saleskey"];
    }
    
    [dictionary setValue:paymethod forKey:@"paidmethod"];
    [dictionary setValue:[MyClass returndefaultarckey] forKey:@"arckey"];
    
    __block BOOL result=FALSE;
    __block NSData *returndata;
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            returndata=data;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSDictionary *jsondictionary = jsonreturned[@"content"];
            NSArray *jsonenrollmentkeysarray = jsondictionary[@"receiptenrollmentkeys"];
            NSArray *jsonsaleskeysarray = jsondictionary[@"receiptsaleskeys"];

            if (jsonenrollmentkeysarray.count+jsonsaleskeysarray.count>0) {
                globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys=[[NSMutableArray alloc]init];
                globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys=[[NSMutableArray alloc]init];
                globalvariables.documentfolder.classreceiptarray=[[NSMutableArray alloc]init];
                globalvariables.documentfolder.salesreceiptarray=[[NSMutableArray alloc]init];
                
                for (int i=0; i<jsonenrollmentkeysarray.count; i++) {
                    NSString *enrollmentkey=[NSString stringWithFormat:@"%@",[jsonenrollmentkeysarray objectAtIndex:i]];
                    if (![globalvariables.documentfolder.classreceiptarray containsObject:enrollmentkey]) {
                        [globalvariables.documentfolder.classreceiptarray addObject:enrollmentkey];
                    }
                    
                    if(![globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys containsObject:enrollmentkey]){
                        [globalvariables.documentfolder.defaultcheckedclassreceiptenrollmentkeys addObject:enrollmentkey];
                    }
                }
                
                for (int i=0; i<jsonsaleskeysarray.count; i++) {
                    NSString *saleskey=[NSString stringWithFormat:@"%@",[jsonsaleskeysarray objectAtIndex:i]];
                    [globalvariables.documentfolder.salesreceiptarray addObject:saleskey];
                    [globalvariables.documentfolder.defaultcheckedsalesreceiptsaleskeys addObject:saleskey];
                }
                result=YES;
            }else{
                result= NO;
            }
        }
    }];

    if (result) {
        if (!EnrollmentRecordView.hidden) {
            [self refreshstudentdetailsinformationandreturnenrollementrecord:nil];
        }else{
            [self updatesalesrecordandreturnsalesrecord:nil];
        }
        
        [self refreshdocumentfoldercount];
        /*if(globalvariables.centerrecord.autosendereceipt){
            NSDictionary *dict=[MyClass loaddocumentfolderarraywithpaymethod:paymethod returndata:returndata];
            [MyClass autoSendeReceiptWithClassReceiptArray:dict[@"documentfolderclassreceiptarray"] SalesReceiptArray:dict[@"documentfoldersalesreceiptarray"]];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        }*/
    }else{
        [MyClass showconnectionlostdialogbox];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }
    
}

-(void) dataChanged
{
    DataChanged=TRUE;
}

-(void) showAdvancedSearchWindow
{
    [self stopAudioPlaying];
    [self startsidewindowanimationwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            AdvancedSearchPopoverViewController2 *messagepopover = (AdvancedSearchPopoverViewController2 *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"AdvancedSearchPopoverViewController2"];
            messagepopover.delegate=self;

    
            messagepopover.view.frame=self->mainWindow.bounds;
            [self->sidewindowview addSubview:messagepopover.view];
            [self addChildViewController:messagepopover];
            [messagepopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            self->ailoadindicator.hidden=YES;
        });
}

-(void) dismissAdvancedSearchWithLoading:(BOOL)loading
{
    [self closesidewindow];
//    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    [self.delegate dismissAdvancedSearchWithLoading:loading];
}

-(void) returnSearchResult:(NSMutableArray *)student_Array
{
    [self.delegate returnSearchResult:student_Array];
}

-(void) retrievenewmessagecontact
{
    NSArray *jsoncenterkeyarray=[[NSArray alloc]init];
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict;
    
    NSArray *centerkeysarray=[globalvariables.centerrecord.centerkey componentsSeparatedByString:@","];
    for (int i=0; i<centerkeysarray.count; i++) {
        dict= [[NSMutableDictionary alloc]init];
        [dict setValue:centerkeysarray[i] forKey:@"centerkey"];
        [arrayOfDicts addObject:dict];
    }
    jsoncenterkeyarray=[NSArray arrayWithArray:arrayOfDicts];
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:@"retrievenewmessagecontact" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.username forKey:@"username"];
    [dictionary setValue:@"center" forKey:@"apptype"];
    [dictionary setValue:jsoncenterkeyarray forKey:@"centerkeys"];
    
    __block BOOL result=FALSE;
    __block NSDictionary *jsondictionary;

//    NSLog(@"1 %@",[NSDate date]);
    [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSLog(@"%@",[NSDate date]);
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            jsondictionary = jsonreturned[@"content"];
        }
    }];
    
    if (result) {
        NewContactArray=[[NSMutableArray alloc]init];
        NSArray *jsonmessagecontactarray = jsondictionary[@"messagecontactrecords"];

            
        for (int i=0; i<jsonmessagecontactarray.count; i++) {
            NSString * centerkey=[[jsonmessagecontactarray objectAtIndex:i] objectForKey:@"centerkey"];
            NSString * messagecontacttype=[[jsonmessagecontactarray objectAtIndex:i] objectForKey:@"messagecontacttype"];
            NSString * messagecontact=[[jsonmessagecontactarray objectAtIndex:i] objectForKey:@"messagecontact"];
            NSString * messagecontactdisplayname;
            NSString * messagecontactid;
            if ([messagecontacttype isEqualToString:@"Staff"]){
                messagecontactdisplayname=[MyClass returnstaffnamewithusername:messagecontact firstorfullname:@"full"];
            }else if ([messagecontacttype isEqualToString:@"Student"]){
                messagecontactdisplayname=[MyClass returnStudentnameWithStudentkey:messagecontact option:@"full"];
                messagecontactid=((Student *)[MyClass returnstudentwithstudentkey:messagecontact]).studentid;
            }else if ([messagecontacttype isEqualToString:@"Group"]){
                messagecontactdisplayname=((GroupRecord *)[MyClass returngrouprecordwithgrouparray:allstaffgrouparray groupkey:messagecontact]).groupname;
            }
            
            [NewContactArray addObject:[[MessageContactRecord alloc]initMessageContactRecordwithcenterkey:centerkey messagecontact:messagecontact messagetype:@"" messagestarttime:@"" unreadcount:@"" attachmenttypes:nil readstatus:@"" type:nil messagecontacttype:messagecontacttype sender:nil recipient:nil channel:nil unreadcountsort:@"" messageenglish:nil messagechinese:nil outboxmessagekey:nil messagecontactdisplayname:messagecontactdisplayname]];
        }
            
        NSSortDescriptor *sortByname = [NSSortDescriptor sortDescriptorWithKey:@"messagecontactdisplayname" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = @[sortByname];
        NewContactArray = [NSMutableArray arrayWithArray:[NewContactArray sortedArrayUsingDescriptors:sortDescriptors]];
    }
    
    //[tablerefresh endRefreshing];
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}

-(BOOL) isEnrollmentLockedWithEnrollment:(EnrollmentRecord *)enrollment
{
    GlobalVariables *globalvariables=[GlobalVariables singleObj];
    return enrollment.locked && !((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).editlockedclass;
}


@end
