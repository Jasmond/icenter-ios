//
//  LeadDetailsViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 17/5/15.
//  Copyright (c) 2015 DreamHigh Company Limited. All rights reserved.
//

#import "LeadDetailsViewController.h"
#import "MyObject.h"
#import "LeadEditViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MainMenuViewController.h"
#import "StudentInformationViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MyClass.h"
#import "StaffPopoverViewController.h"
#import "MessagePhotoCollectionViewCell.h"
//#import "UIImageView+AFNetworking.h"
#import "MyTableViewCell.h"
//#import "AFNetworking.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "messageDocumentUIView.h"
#import "SDImageCache.h"
#import "SceneDelegate.h"

@import  Photos;
@import  BSImagePicker;

@interface LeadDetailsViewController ()
@property (nonatomic, strong) UIView *viewHistoryCard;
@property (nonatomic, assign) BOOL historyButtonFollowsCorner;
@property (nonatomic, assign) CGFloat sideWindowRequestedWidth;
@property (nonatomic, assign) BOOL sideWindowOpen;
@property (nonatomic, assign) BOOL sideWindowAnimating;
@end

#define photosize 175
#define maxphotoheight self.view.bounds.size.height*0.5
#define maxselectiontableheight 600
#define photosize 175
#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]

@implementation LeadDetailsViewController
@synthesize leadnamelabel,genderlabel,dateofbirthlabel,schoollabel,gradelabel,preferredlanguagelabel,agelabel,parentname,parentcontact,parentaddress,parentemail,remarks,leadidlabel,medialabel,sourcelabel;
@synthesize DetailsViewLead;
@synthesize DetailsViewDTArray,JSONArray;
//@synthesize DetailsViewDTTable;
@synthesize DTRecordView;
@synthesize DetailsViewDTObject;
@synthesize myPopoverController;
@synthesize ViewLead;
@synthesize leadAction,selectedMenu,presetValue;
@synthesize systemMessageLabel;
@synthesize pickerViewmenu,myPickerView;
@synthesize tableViewMenu,tableMenu;
@synthesize TopMenuView;
@synthesize LeadViewMode;
@synthesize MessageView,InstructorArray,destleadeditviewcontroller,lastviewindex,CallLogView;
@synthesize CallLogCalledBySelectionButton,calllogcalledbyselected,selectedDTkey;
@synthesize myDTSelectionPopoverController,myCallLogSelectionPopoverController;
@synthesize ViewHistoryTableMasterView,systemMessageView;

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
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    selfViewWidth = self.view.bounds.size.width;
    messagecontentwidth=selfViewWidth-40;
    maxphotoperline=(self.view.bounds.size.width-40)/photosize;
    if (maxphotoperline < 1) {
        maxphotoperline = 1;
    }
    self.historyButtonFollowsCorner = YES;
    
    [self loadgeneral];
    //[self loadtitle];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0];
    //self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
    headertitleview=[[UIView alloc]initWithFrame:CGRectMake(150, 0, selfViewWidth-300, 68)];
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
    //headercentername.text=[MyClass returncentershortnamewithcenterkey:nil];
    [headertitleview addSubview:headercentername];
    
    headercenternamearrow=[[UIImageView alloc]init];
    [headercenternamearrow setImage:[UIImage imageNamed:@"openbutton_white.png"]];
    headercenternamearrow.hidden=([MyClass isMultiCenterUser] && ![leadAction isEqualToString:@"PopoverLead"])?NO:YES;
    [headertitleview addSubview:headercenternamearrow];
    //[self updateheadercentertitle];
    
    switchcenterbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, headertitleview.frame.size.width,35)];
    //[switchcenterbutton setImage:[UIImage imageWithData:globalvariables.menuimagedata] forState:UIControlStateNormal];
    switchcenterbutton.layer.cornerRadius=5;
    switchcenterbutton.layer.masksToBounds=YES;
    if (([MyClass isMultiCenterUser] && ![leadAction isEqualToString:@"PopoverLead"])) {
        [switchcenterbutton addTarget:self action:@selector(switchcenterbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    }
    [headertitleview addSubview:switchcenterbutton];
    
    switchcenterviewcontroller = (SwitchCenterViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SwitchCenterViewController"];
    //switchcenterviewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
    switchcenterviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    switchcenterviewcontroller.delegate=self;
    
//    self.navigationItem.titleView=headertitleview;
    [self refreshlanguage];
    
    DataChanged=FALSE;
    runviewdidappear=TRUE;
    
    messagecategoryarray=[[NSArray alloc]initWithObjects:@"All",@"User",@"System", nil];

    
    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    //InstructorArray=[MyClass retrieveInstructorListwithvalid:@"All" flushcachedata:YES];
    
    [self createdtviewtableheader];
    
    
    TopMenuView.hidden=YES;
    ViewLead.hidden=YES;
    DTRecordView.hidden=YES;
    MessageView.hidden=YES;
    CallLogView.hidden=YES;

    
    dtsubjectselected=@"All";
    dttypeselected=@"All";
    
    calllogobj=[[CallLogRecord alloc]init];

    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
    panGesture.maximumNumberOfTouches = 1;
    panGesture.minimumNumberOfTouches = 1;
    panGesture.delegate = self;
    [DetailsViewDTTable addGestureRecognizer:panGesture];

    
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
    sidewindowview.clipsToBounds=YES;
    sidewindowview.tag=-200;
    [mainWindow addSubview:sidewindowview];
    
    UIImageView *activityImageView=[[UIImageView alloc]init];
    activityImageView.animationImages=[MyClass returnLoadingIndicatorAnimatedImageWithBaseColor:@"lightgray"];
    activityImageView.alpha=1.0;
    activityImageView.animationDuration=1.5;
    activityImageView.frame=CGRectMake(0,0,45,45);
    [activityImageView startAnimating];
    
    ailoadindicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    ailoadindicator.alpha = 1.0;
    ailoadindicator.color=[UIColor clearColor];
    ailoadindicator.transform=CGAffineTransformMakeScale(1, 1);
    ailoadindicator.center = CGPointMake(152.5,mainWindow.frame.size.height/2-7.5);
    ailoadindicator.hidesWhenStopped = YES;
    [ailoadindicator addSubview:activityImageView];
    [self->sidewindowview addSubview:ailoadindicator];
    
    DetailsViewMessageTable.transform = CGAffineTransformMakeScale(1, -1);
    workingMessage=[[OutboxMessageRecord alloc]init];
    workingMessage.messagetype=@"General";
    workingMessage.sender=globalvariables.username;
    workingMessage.channel=@"S";
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
    [MyClass configurePlayAndRecordAudioSession:nil];
    [sliderTimer invalidate];
    recordAudioButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendmessage;
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
    headertitlename.text=[MyClass returntitlewithtitle:@"Lead Profile"];
    if (!leadAction || [leadAction isEqualToString:@"ViewLead"]) {
        systemMessageLabel.text=[MyClass returntitlewithtitle:@"Select lead or press + to add new"];
        //systemMessageLabel.frame=CGRectMake(0, 0, selfViewWidth-234, self.view.frame.size.height-64);
        //ViewHistoryTableMasterView.hidden=NO;
        systemMessageTrailingConstraint.constant=234;
        
        if (!leadAction) {
            [self showviewhistory:TRUE];
        }
        
        
    }else{
        systemMessageLabel.text=[NSString stringWithFormat:@"%@...",[MyClass returntitlewithtitle:@"Loading Information"]];
        //systemMessageLabel.frame=CGRectMake(0, 0, selfViewWidth, self.view.frame.size.height-64);
        //ViewHistoryTableMasterView.hidden=YES;
        systemMessageTrailingConstraint.constant=0;
    }
    viewhistorytableheader.text=[MyClass returntitlewithtitle:@"Recent Views"];
    [self updateheadercentertitle];
    
    copyrightmessagelabel.text=[MyClass returntitlewithtitle:@"Copyright message"];
    
    //self.navigationItem.title=[MyClass returntitlewithtitle:@"Lead Profile"];
    title_Gender.text=[MyClass returntitlewithtitle:@"Gender"];
    title_Date_of_Birth.text=[MyClass returntitlewithtitle:@"Date of Birth"];
    title_Age.text=[MyClass returntitlewithtitle:@"Age"];
    title_Preferred_Language.text=[MyClass returntitlewithtitle:@"Preferred Language"];
    title_Grade.text=[MyClass returntitlewithtitle:@"Grade"];
    title_School.text=[MyClass returntitlewithtitle:@"School"];
    title_Parent_Name.text=[MyClass returntitlewithtitle:@"Parent Name"];
    title_Phone.text=[MyClass returntitlewithtitle:@"Phone"];
    title_Email.text=[MyClass returntitlewithtitle:@"Email"];
    title_Address.text=[MyClass returntitlewithtitle:@"Address"];
    title_Lead_Media.text=[MyClass returntitlewithtitle:@"Lead Media"];
    title_Lead_Source.text=[MyClass returntitlewithtitle:@"Lead Source"];
    title_Remarks.text=[MyClass returntitlewithtitle:@"Remarks"];
    title_Flag.text=[MyClass returntitlewithtitle:@"Flag"];
    title_Lead_ID.text=[MyClass returntitlewithtitle:@"Lead ID"];
    
    title_Promotional_Message.text=[MyClass returntitlewithtitle:@"Promotional Message"];
    title_Promotional_Message.font=[UIFont systemFontOfSize:[globalvariables.language isEqualToString:@"English"]?13:15];
    slideToCancelTitle.text=[MyClass returntitlewithtitle:@"Release here to cancel"];
    scsender.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendmessagecenterrole;
    [lead_goToStudentButton setTitle:[MyClass returntitlewithtitle:@"Go to Student Profile"] forState:UIControlStateNormal];
}

-(void) updateheadercentertitle
{
    
    [headercentername sizeToFit];
    CGRect myframe=headercentername.frame;
    if (myframe.size.width>headertitleview.frame.size.width) {
        headercentername.frame=CGRectMake(([MyClass isMultiCenterUser] && ![leadAction isEqualToString:@"PopoverLead"])?-4:0, 43, headertitleview.frame.size.width, 22);
    }else{
        headercentername.frame=CGRectMake((headertitleview.frame.size.width-myframe.size.width)/2+(([MyClass isMultiCenterUser] && ![leadAction isEqualToString:@"PopoverLead"])?-4:0), 43, myframe.size.width, 22);
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
            
            [UIView animateWithDuration:0.4 animations:^{attendanceringview.alpha = 0.0;} completion:^(BOOL finished){ [attendanceringview removeFromSuperview]; }];
            attendanceringview=nil;

            [self.mainSlideMenu enableSlidePanGestureForLeftMenu];
            
            if (lastviewindex==3){
                DetailsViewDTTable.scrollEnabled=TRUE;
                [DetailsViewDTTable deselectRowAtIndexPath:[DetailsViewDTTable indexPathForSelectedRow] animated: YES];
            }
        }
    }
}


-(void) refreshcalllogtable
{
    [self retrieveCallLogRecord];
    for (id object in [CallLogTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshdetailsviewdttable
{
    [self retrieveDTWithSubject:dtsubjectselected leadkey:DetailsViewLead.leadkey classtype:dttypeselected];;
    for (id object in [DetailsViewDTTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) refreshdetailsviewmessagetable
{
    [self retrieveMessageRecord];
    for (id object in [DetailsViewMessageTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
}

-(void) attendanceringreleasedwithtouchpoint:(CGPoint)touchpoint
{
    //check if inside ring
    if(lastviewindex==3){
        if ([MyClass returntouchpointwithinattendanceringwithtouchpoint:touchpoint size:@"large"]) {
            NSIndexPath *selectedIndexPath = [DetailsViewDTTable indexPathForSelectedRow];
            [self updateattendancewithindexpath:selectedIndexPath value:((AttendanceButtonObject *)[attendancebuttonarray objectAtIndex:lasttouchedsector]).buttonname];
        }
    }
}

-(void)updateattendancewithindexpath:(NSIndexPath *)indexpath value:(NSString *)value
{
    
    if (lastviewindex==3){
        //update dt information
        DetailsViewDTObject=[[DTRecord alloc]init];
        DetailsViewDTObject=[filteredDetailsViewDTArray objectAtIndex:indexpath.row];
        
        if (![value isEqualToString:DetailsViewDTObject.attendance]) {
            NSString *strURL;
            
            strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatedt&dtkey=%@&attendance=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DetailsViewDTObject.DTkey,value];
            
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
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self retrieveDTWithSubject:dtsubjectselected leadkey:DetailsViewLead.leadkey classtype:dttypeselected];
                });
            }/*else{
                [MyClass showconnectionlostdialogbox];
            }*/
        }
    }
}

-(void) attendancebuttontouchupinside:(UIButton *)sender
{
    [UIView animateWithDuration:0.3 animations:^{attendanceringview.alpha = 0.0;} completion:^(BOOL finished){ [attendanceringview removeFromSuperview]; }];
    attendanceringview=nil;
   [self.mainSlideMenu enableSlidePanGestureForLeftMenu];
    
    if (lastviewindex==3){
        DetailsViewDTTable.scrollEnabled=TRUE;
        [DetailsViewDTTable deselectRowAtIndexPath:[DetailsViewDTTable indexPathForSelectedRow] animated: YES];
    }
}

-(void) attendancebuttontouchdown:(UIButton *)sender
{
    UIView *windowview = self.view;
    while (windowview.superview != Nil) {
        windowview = windowview.superview;
    }
    
    [self.mainSlideMenu disableSlidePanGestureForLeftMenu];
    
    if (lastviewindex==3){
        DetailsViewDTTable.scrollEnabled=FALSE;
        CGPoint point = [sender.superview convertPoint:CGPointZero toView:DetailsViewDTTable];
        NSIndexPath *indexpath =[DetailsViewDTTable indexPathForRowAtPoint:point];
        [DetailsViewDTTable selectRowAtIndexPath:indexpath animated:YES scrollPosition:UITableViewScrollPositionNone];
        DetailsViewDTObject=[filteredDetailsViewDTArray objectAtIndex:indexpath.row];
        attendancebuttonarray=[[NSMutableArray alloc]initWithArray:makeupdtattendancebuttonarray];
        attendanceringview=[MyClass drawattendanceringwithbutton:sender basebutton:DetailsViewDTObject.attendance highlightbutton:DetailsViewDTObject.attendance attendancebuttonarray:attendancebuttonarray inview:windowview size:@"large"];
    }
    
    UIWindow *win0 = self.view.window ?: [MyClass activeWindow];
    [win0 addSubview:attendanceringview];
    [win0 bringSubviewToFront:attendanceringview];
    lasttouchedsector=0;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
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
    [self stopAudioPlaying];
    if (audioPlayer.playing) {
        [audioPlayer stop];
        audioPlayer=nil;
        [sliderTimer invalidate];
        //[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
    //pass DataChanged information to daily class schedule
    if (DataChanged) {
        [self.delegate refreshleaddetailviewpresentingviewcontent];
    }
}


- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverController
{
    //Reload data
    if (popoverController == myDTSelectionPopoverController) {
        [self drawpointerwithoption:@"closed" imageview:dt_typearrow];
        [self drawpointerwithoption:@"closed" imageview:dt_coursearrow];
    }else if (popoverController == myCallLogSelectionPopoverController) {
        [self drawpointerwithoption:@"closed" imageview:calllog_callerarrow];
    }else{
        if (lastviewindex==1){
            [DetailsViewMessageTable deselectRowAtIndexPath:[DetailsViewMessageTable indexPathForSelectedRow] animated: YES];
        }else if (lastviewindex==3){
            if(![self retrieveLead:DetailsViewLead.leadkey]){
                return;
            }
            if(![self retrieveDTWithSubject:dtsubjectselected leadkey:DetailsViewLead.leadkey classtype:dttypeselected]){
                return;
            }
        }
    }
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
    if (tableView == DetailsViewDTTable) {
        return filteredDetailsViewDTArray.count;
    }else if (tableView==DetailsViewMessageTable){
        return filteredMessageArray.count;
    }else if (tableView == DTSubjectSelectionTable) {
        return DTSubjectArray.count;
    }else if (tableView == DTTypeSelectionTable) {
        return DTTypeArray.count;
    }else if (tableView==CallLogTable){
        return filteredCallLogRecordArray.count;
    }else if (tableView==CallLogCalledBySelectionTable){
        return CallLogCalledByArray.count;
    }else if (tableView==LeadStatusSelectionTable){
        return LeadStatusArray.count;
    }else if (tableView==ViewHistoryTable){
        return viewhistoryarray.count;
    }else if (tableView==sortingtable){
        return sortingarray.count;
    }else{
        return 2;
    }
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
        
        DTRecord * DTObject= [filteredDetailsViewDTArray objectAtIndex:indexPath.row];
        
        /*//add switch, label and button
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            //add textfield
            ClassLabel = [[UILabel alloc]initWithFrame:CGRectMake(dt_header_subject.frame.origin.x, 2, 70, 21)];
            ClassLabel.font=[UIFont systemFontOfSize:13];
            ClassLabel.textColor=[UIColor darkGrayColor];
            ClassLabel.tag=103;
            [cell.contentView addSubview:ClassLabel];
            
            DT_subjectfullname = [[UILabel alloc]initWithFrame:CGRectMake(dt_header_subject.frame.origin.x, 18, 300, 21)];
            DT_subjectfullname.font=[UIFont systemFontOfSize:10];
            DT_subjectfullname.textColor=[UIColor grayColor];
            DT_subjectfullname.tag=113;
            [cell.contentView addSubview:DT_subjectfullname];
            
            ClassTypeLabel = [[UILabel alloc]initWithFrame:CGRectMake(dt_header_type.frame.origin.x, 2, 70, 21)];
            ClassTypeLabel.font=[UIFont systemFontOfSize:13];
            ClassTypeLabel.textColor=[UIColor darkGrayColor];
            ClassTypeLabel.tag=102;
            [cell.contentView addSubview:ClassTypeLabel];
            
            LevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(dt_header_level.frame.origin.x, 2, dt_header_level.frame.size.width-10, 21)];
            LevelLabel.font=[UIFont systemFontOfSize:13];
            LevelLabel.textColor=[UIColor darkGrayColor];
            LevelLabel.textAlignment=NSTextAlignmentLeft;
            LevelLabel.minimumScaleFactor=0.7;
            LevelLabel.adjustsFontSizeToFitWidth=YES;
            LevelLabel.tag=104;
            [cell.contentView addSubview:LevelLabel];
            
            StartDateLabel = [[UILabel alloc]initWithFrame:CGRectMake(dt_header_start.frame.origin.x, 2, dt_header_start.frame.size.width-10, 21)];
            StartDateLabel.font=[UIFont systemFontOfSize:13];
            StartDateLabel.textColor=[UIColor darkGrayColor];
            StartDateLabel.tag=105;
            [cell.contentView addSubview:StartDateLabel];
            
            ClassTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(dt_header_time.frame.origin.x, 2, 42, 21)];
            ClassTimeLabel.font=[UIFont systemFontOfSize:13];
            ClassTimeLabel.textColor=[UIColor darkGrayColor];
            ClassTimeLabel.tag=107;
            [cell.contentView addSubview:ClassTimeLabel];
            
            InstructorButton=[[UIButton alloc]initWithFrame:CGRectMake(dt_header_instructor.frame.origin.x, 2, dt_header_instructor.frame.size.width+40, 21)];
            InstructorButton.titleLabel.font=[UIFont systemFontOfSize:13];
            [InstructorButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
            InstructorButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
            [InstructorButton addTarget:self action:@selector(dt_instructor_pressed:) forControlEvents:UIControlEventTouchUpInside];
            InstructorButton.tag=108;
            [cell.contentView addSubview:InstructorButton];
            
            ClassroomLabel = [[UILabel alloc]initWithFrame:CGRectMake(dt_header_instructor.frame.origin.x, 18, dt_header_classroom.frame.size.width+40, 21)];
            ClassroomLabel.font=[UIFont systemFontOfSize:10];
            ClassroomLabel.textColor=[UIColor darkGrayColor];
            ClassroomLabel.textAlignment=NSTextAlignmentLeft;
            ClassroomLabel.tag=111;
            [cell.contentView addSubview:ClassroomLabel];
            
            RemarksLabel = [[UILabel alloc]initWithFrame:CGRectMake(dt_header_remarks.frame.origin.x , 0, dt_header_remarks.frame.size.width-10, 35)];
            RemarksLabel.font=[UIFont systemFontOfSize:13];
            RemarksLabel.textColor=[UIColor darkGrayColor];
            RemarksLabel.tag=110;
            RemarksLabel.minimumScaleFactor=0.6;
            RemarksLabel.numberOfLines=0;
            RemarksLabel.lineBreakMode=NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail;
            RemarksLabel.adjustsFontSizeToFitWidth=YES;
            [cell.contentView addSubview:RemarksLabel];
            
            AttendanceButton=[[UIButton alloc]initWithFrame:CGRectMake(dt_header_attendance.frame.origin.x+dt_header_attendance.frame.size.width-32+4, 3, 32, 32)];
            [AttendanceButton addTarget: self action:@selector(attendancebuttontouchupinside:) forControlEvents: UIControlEventTouchUpInside];
            [AttendanceButton addTarget: self action:@selector(attendancebuttontouchdown:) forControlEvents: UIControlEventTouchDown];
            AttendanceButton.tag=112;
            [cell.contentView addSubview:AttendanceButton];
        }else{
            ClassTypeLabel=(UILabel *)[cell.contentView viewWithTag:102];
            ClassLabel=(UILabel *)[cell.contentView viewWithTag:103];
            LevelLabel=(UILabel *)[cell.contentView viewWithTag:104];
            StartDateLabel=(UILabel *)[cell.contentView viewWithTag:105];
            ClassDayLabel=(UILabel *)[cell.contentView viewWithTag:106];
            ClassTimeLabel=(UILabel *)[cell.contentView viewWithTag:107];
            InstructorButton=(UIButton *)[cell.contentView viewWithTag:108];
            RemarksLabel=(UILabel *)[cell.contentView viewWithTag:110];
            ClassroomLabel=(UILabel *)[cell.contentView viewWithTag:111];
            AttendanceButton=(UIButton *)[cell.contentView viewWithTag:112];
            DT_subjectfullname=(UILabel *)[cell.contentView viewWithTag:113];
        }*/
        
        // Configure the cell...
        /*
        if ([DTObject.attendance isEqualToString:@"Absent"]) {
            [AttendanceButton setImage:[UIImage imageNamed:@"absent_icon.png"] forState:UIControlStateNormal];
        }else if ([DTObject.attendance isEqualToString:@""]) {
            [AttendanceButton setImage:[UIImage imageNamed:@"unknown_icon.png"] forState:UIControlStateNormal];
        }else if ([DTObject.attendance isEqualToString:@"Present"]){
            [AttendanceButton setImage:[UIImage imageNamed:@"present_icon.png"] forState:UIControlStateNormal];
        }*/
        [cell.button2 setImage:[UIImage imageNamed:[MyClass returnattendanceimagewithclasstype:@"Class" attendance:DTObject.attendance makeupattendance:nil]] forState:UIControlStateNormal];
        [cell.button2 addTarget: self action:@selector(attendancebuttontouchupinside:) forControlEvents: UIControlEventTouchUpInside];
        [cell.button2 addTarget: self action:@selector(attendancebuttontouchdown:) forControlEvents: UIControlEventTouchDown];
        cell.button2.enabled=![MyClass classLocked:DTObject.locked];
        
        cell.label1.text=DTObject.subject;
        cell.label6.text=[MyClass returnsubjectnamewithsubject_shortname:DTObject.subject centerkey:globalvariables.centerrecord.centerkey];
        cell.label3.text=[MyClass returnLevelWithSubject:DTObject.subject Levelmain:DTObject.levelmain Levelctm:DTObject.levelctm];

        
        cell.label2.text=[MyClass returntitlewithtitle:[DTObject.classtype isEqualToString:@"Assessment"]?@"Assess":@"Trial"];

        cell.label4.text = [MyClass returndateformatwithdate:DTObject.DTdate];
        cell.label8.text = [DTObject.classroom isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:DTObject.classroom;
        
        /*[df setDateFormat:@"dd-MMM-yyyy"];
        NSDate *date=[df dateFromString:StartDateLabel.text];
        [df setDateFormat:@"EEE"];
        ClassDayLabel.text=[MyClass returndateformatEEEwithdate:[df stringFromDate:date]];*/
        
        cell.label5.text = DTObject.DTtime;
        //InstructorLabel.text = [DTObject.instructor isEqualToString:@"TBD"]?[MyClass returntitlewithtitle:@"TBD"]:[MyClass returninstructornamewithusername:DTObject.instructor firstorfullname:@"first"];
        
        
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
        
    }else if (tableView==DetailsViewMessageTable){
        InboxMessageRecord *messagerecordobject=[filteredMessageArray objectAtIndex:indexPath.row];
        MyTableViewCell *myCell;
           static NSString *CellIdentifier;
           if ([messagerecordobject.type isEqualToString:@"received"]) {
               if (messagerecordobject.photoarray.count==0) {
                   CellIdentifier = @"messagecelltextonly_received";
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
                   CellIdentifier = @"messagecelltextonly_sent";
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
            if ([messagerecordobject.recipient isEqualToString:@"center"]) {
                myCell.label1.text=[MyClass returncentershortnamewithcenterkey:globalvariables.centerrecord.centerkey];
            }else if ([messagerecordobject.recipient rangeOfString:@"@"].location !=NSNotFound){
                myCell.label1.text=[MyClass returnstaffnamewithusername:messagerecordobject.recipient firstorfullname:@"full"];
            }else{
                myCell.label1.text=[MyClass returnStudentnameWithStudentkey:messagerecordobject.recipient option:@"full"];
            }
            myCell.label1.text=[NSString stringWithFormat:@"@%@",myCell.label1.text];

        

            myCell.view1.hidden=YES;
            
            
            //if (scrolltoclosekeyboard) {
            if ([messagerecordobject.readtime isEqualToString:@""] && ![readmessagearray containsObject:messagerecordobject.inboxmessagekey]) {
                [readmessagearray addObject:messagerecordobject.inboxmessagekey];
                messagerecordobject.readtime=@"read";
            }
            //}

        }else{

            myCell.label1.hidden=NO;
            if ([messagerecordobject.sender isEqualToString:@"center"]) {
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
        
        myCell.selectionStyle=UITableViewCellSelectionStyleNone;
        myCell.contentView.transform=CGAffineTransformMakeScale(1, -1);
        return myCell;
        
        
    }else if (tableView == CallLogTable) {
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"calllogcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        CallLogRecord * calllogobject = [filteredCallLogRecordArray objectAtIndex:indexPath.row];
        
        
        
        // Configure the cell...
        cell.label1.text=[MyClass returndateformatwithdate:calllogobject.calledon];
        //CallLogCalledByLabel.text=[MyClass returnfullnamewithusername:calllogobject.calledby userlistarray:userListArray];
        cell.label2.text=[MyClass returnstaffnamewithusername:calllogobject.calledby firstorfullname:@"full"];
        cell.label3.text=calllogobject.details;
        

        
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
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
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 37, 200, 1)];
        GeneralLabel.backgroundColor=[UIColor lightGrayColor];
        GeneralLabel.alpha=0.3;
        [cell.contentView addSubview:GeneralLabel];
        
        return cell;
        
    }else if (tableView==DTSubjectSelectionTable){
        /*static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 200, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentCenter;
        GeneralLabel.text=[DTSubjectArray objectAtIndex:indexPath.row];
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 37, 200, 1)];
        GeneralLabel.backgroundColor=[UIColor lightGrayColor];
        GeneralLabel.alpha=0.3;
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;*/
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 7, 230, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentLeft;
        GeneralLabel.text=indexPath.row==0?[MyClass returntitlewithtitle:[DTSubjectArray objectAtIndex:0]]:[MyClass returnsubjectnamewithsubject_shortname:[DTSubjectArray objectAtIndex:indexPath.row] centerkey:globalvariables.centerrecord.centerkey];
        GeneralLabel.tag=301;
        GeneralLabel.minimumScaleFactor=0.7;
        GeneralLabel.adjustsFontSizeToFitWidth=YES;
        [cell.contentView addSubview:GeneralLabel];
        
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(250, 7, 40, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:14];
        GeneralLabel.minimumScaleFactor=0.7;
        GeneralLabel.adjustsFontSizeToFitWidth=YES;
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentRight;
        if (indexPath.row>0) {
            GeneralLabel.text=[DTSubjectArray objectAtIndex:indexPath.row];
        }else{
            GeneralLabel.text=@"";
        }
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 37, 300, 1)];
        GeneralLabel.backgroundColor=[UIColor lightGrayColor];
        GeneralLabel.alpha=0.3;
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;

        
    }else if (tableView==LeadStatusSelectionTable){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 154, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:14];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentCenter;
        GeneralLabel.text=[MyClass returntitlewithtitle:[MyClass returntitlewithtitle:[NSString stringWithFormat:@"lead_status_%@",[LeadStatusArray objectAtIndex:indexPath.row]]]];
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 37, 154, 1)];
        GeneralLabel.backgroundColor=[UIColor lightGrayColor];
        GeneralLabel.alpha=0.3;
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;
        
    }else if (tableView==ViewHistoryTable){
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //add switch, label and button
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
            viewhistoryidlabel.textColor=[UIColor grayColor];
            viewhistoryidlabel.tag=702;
            [cell.contentView addSubview:viewhistoryidlabel];
            
            
            
            viewhistoryimageview=[[UIImageView alloc]initWithFrame:CGRectMake(10, 3, 38, 38)];
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
        }
        
        viewhistoryobject=[viewhistoryarray objectAtIndex:indexPath.row];
        leadobject=[MyClass returnleadwithleadkey:viewhistoryobject.typekey];
        
        
        viewhistorynamelabel.text=[MyClass returnLeadnameWithLeadkey:viewhistoryobject.typekey option:@"fullbutid"];//viewhistoryobject.name;
        viewhistoryidlabel.text=leadobject.leadid;
        
        
        
        if ([leadobject.leadid isEqualToString:@""]) {
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
        
        
        
        [MyClass downloadImageWithImageview:viewhistoryimageview gender:leadobject.gender type:@"lead" typekey:leadobject.leadkey image:leadobject.image async:YES];
        
        /*
        //if ([siblingobject.image isEqualToString:@"Yes"]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@leadimages/%@/lead_%@_%@.jpg",globalvariables.serverpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, viewhistoryobject.typekey]];
        
        if ([imageCache objectForKey:url]) {
            [viewhistoryimageview setImage:[imageCache objectForKey:url]];
        }else{
            if ([leadobject.gender isEqualToString:@"Male"]) {
                [viewhistoryimageview setImage:boyimage];
            }else if ([leadobject.gender isEqualToString:@"Female"]){
                [viewhistoryimageview setImage:girlimage];
            }else{
                [viewhistoryimageview setImage:girlimage];
            }
        }
        
        
        
        [self checkifimagechangedwithURL:url studentimage:viewhistoryimageview indexpath:indexPath completionBlock:^(BOOL imagechanged, NSURL *URL, UIImageView *stimage, NSIndexPath *stimageindexpath){
            if (imagechanged || ![imageCache objectForKey:URL]) {
                [self downloadImageWithURL:URL studentimage:stimage indexpath:stimageindexpath completionBlock:^(BOOL succeeded, NSData *data, UIImageView *simage, NSIndexPath *imageindexpath, NSURL *_url) {
                    
                    CGPoint point = [simage.superview convertPoint:CGPointZero toView:ViewHistoryTable];
                    NSIndexPath *indexpath =[ViewHistoryTable indexPathForRowAtPoint:point];
                    if ([tableView.indexPathsForVisibleRows indexOfObject:imageindexpath] != NSNotFound && indexpath.row==imageindexpath.row)
                    {
                        if (succeeded) {
                            if (imageindexpath) {
                                if ([[UIImage alloc] initWithData:data]) {
                                    simage.image = [[UIImage alloc] initWithData:data];
                                    [imageCache setObject:simage.image forKey:_url];
                                }
                            }
                        }
                    }
                }];
            }
        }];*/
        
        /*
         }else{
         if ([siblingobject.gender isEqualToString:@"Male"]) {
         [viewhistoryimageview setImage:boyimage];
         }else if ([siblingobject.gender isEqualToString:@"Female"]){
         [viewhistoryimageview setImage:girlimage];
         }else{
         [viewhistoryimageview setImage:girlimage];
         }
         
         }*/
        cell.backgroundColor=[UIColor clearColor];
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:cell.frame];
        bgView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:87.0/255.0 blue:150.0/255.0 alpha:0.3];
        cell.selectedBackgroundView = bgView;
        
        return cell;
        
        
    }else if (tableView==sortingtable){
        
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier ];
        
        UILabel *sortingnamelabel;
        UIButton *sortingorderbutton;
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
        
        UILabel *GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, 200, 21)];
        GeneralLabel.font=[UIFont systemFontOfSize:15];
        GeneralLabel.textColor=[UIColor darkGrayColor];
        GeneralLabel.textAlignment=NSTextAlignmentCenter;
        GeneralLabel.text=[MyClass returntitlewithtitle:[DTTypeArray objectAtIndex:indexPath.row]];
        GeneralLabel.tag=301;
        [cell.contentView addSubview:GeneralLabel];
        
        GeneralLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 37, 200, 1)];
        GeneralLabel.backgroundColor=[UIColor lightGrayColor];
        GeneralLabel.alpha=0.3;
        [cell.contentView addSubview:GeneralLabel];
        
        
        return cell;
    }
    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self stopAudioPlaying];
    if (tableView == DetailsViewDTTable){
        //popup class view record
        
        [self startsidewindowanimationwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            DetailsViewDTObject=[filteredDetailsViewDTArray objectAtIndex:indexPath.row];
            //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            DTAddEditViewController *dtpopover = (DTAddEditViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"DTAddEditViewController"];
            dtpopover.DTAddEditViewDTkey=DetailsViewDTObject.DTkey;
            dtpopover.PopoverMode=@"PopoverDTFromDetailsView";
            dtpopover.DTTableMode=@"View";
            dtpopover.CallingSource=@"lead";
            dtpopover.CallingKey=DetailsViewLead.leadkey;
            dtpopover.delegate=self;
            
            dtpopover.subjectArray=[MyClass retrievesubjectinformationwithstatus:@"Active" category:@"All" flushcachedata:YES];
            if (!dtpopover.subjectArray) {
                return;
            }
            
            [self->sidewindowview addSubview:dtpopover.view];
            [self placeViewInSideWindow:dtpopover.view];
            [self addChildViewController:dtpopover];
            [dtpopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
        });
        

        
    }else if (tableView==DTSubjectSelectionTable){
        [self drawpointerwithoption:@"closed" imageview:dt_coursearrow];
        //[DTSubjectSelectionButton setTitle:[DTSubjectArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        if (indexPath.row==0) {
            dtsubjectselected=@"All";
            [DTSubjectSelectionButton setTitle:[MyClass returntitlewithtitle:[DTSubjectArray objectAtIndex:0]] forState:UIControlStateNormal];
        }else{
            dtsubjectselected=[DTSubjectArray objectAtIndex:indexPath.row];
            [DTSubjectSelectionButton setTitle:[MyClass returnsubjectnamewithsubject_shortname:[DTSubjectArray objectAtIndex:indexPath.row] centerkey:globalvariables.centerrecord.centerkey] forState:UIControlStateNormal];
        }
        
        [[myDTSelectionPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveDTWithSubject:dtsubjectselected leadkey:DetailsViewLead.leadkey classtype:dttypeselected];
        });
    }else if (tableView==DTTypeSelectionTable){
        [self drawpointerwithoption:@"closed" imageview:dt_typearrow];
        [DTTypeSelectionButton setTitle:[MyClass returntitlewithtitle:[DTTypeArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
        if (indexPath.row==0) {
            dttypeselected=@"All";
        }else{
            dttypeselected=[DTTypeArray objectAtIndex:indexPath.row];
        }
        
        [[myDTSelectionPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveDTWithSubject:dtsubjectselected leadkey:DetailsViewLead.leadkey classtype:dttypeselected];
        });
    }else if (tableView==CallLogTable){
        
        [self startsidewindowanimationwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CallLogPopoverViewController *calllogpopover = (CallLogPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"CallLogPopoverViewController"];
            calllogpopover.delegate=self;
            calllogpopover.studentkey=DetailsViewLead.leadkey;
            calllogpopover.CallLogTableMode=@"View";
            calllogpopover.CallingSource=@"lead";
            calllogpopover.CallLogRecordObject=[CallLogRecordArray objectAtIndex:indexPath.row];
            
            
            [calllogpopover InitializeField];
            /*
            if (![calllogpopover InitializeField]) {
                [MyClass showconnectionlostdialogbox];
            }else{*/

            //}
            
            [self->sidewindowview addSubview:calllogpopover.view];
            [self placeViewInSideWindow:calllogpopover.view];
            [self addChildViewController:calllogpopover];
            [calllogpopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
        });
        

    }else if (tableView==CallLogCalledBySelectionTable){
        [self drawpointerwithoption:@"closed" imageview:calllog_callerarrow];
        [CallLogCalledBySelectionButton setTitle:[MyClass returnstaffnamewithusername:[CallLogCalledByArray objectAtIndex:indexPath.row] firstorfullname:@"full"] forState:UIControlStateNormal];
        //[CallLogCalledBySelectionButton setTitle:[MyClass returnfullnamewithusername:[CallLogCalledByArray objectAtIndex:indexPath.row] userlistarray:userListArray] forState:UIControlStateNormal];
        if (indexPath.row==0) {
            calllogcalledbyselected=@"All";
        }else{
            calllogcalledbyselected=[CallLogCalledByArray objectAtIndex:indexPath.row];
        }
        
        [[myCallLogSelectionPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        [self performSelector:@selector(retrieveCallLogRecord) withObject:nil afterDelay:0];
    }else if (tableView==LeadStatusSelectionTable){
        
        [[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
        
        if (![[LeadStatusArray objectAtIndex:indexPath.row] isEqualToString:DetailsViewLead.status]) {
            
            if ([[LeadStatusArray objectAtIndex:indexPath.row] isEqualToString:@"Enroll"]) {
                if ([leadAction isEqualToString:@"PopoverLead"]) {
                    //[self dismissViewControllerAnimated:YES completion:^{
                    
                    [self.delegate closeleadprofile];
                    
                        AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
                        mainVC.leftMenu.prepareforsegue=TRUE;
                        mainVC.leftMenu.sourceview=@"leadprofile";
                        mainVC.leftMenu.studentinformationaction=@"EnrollLead";
                        mainVC.leftMenu.studentinformationleadobject=DetailsViewLead;
                        globalvariables.leftmenuindex=@"1";
                        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                        [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
                    //}];
                }else{
                    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
                    mainVC.leftMenu.prepareforsegue=TRUE;
                    mainVC.leftMenu.sourceview=@"leadprofile";
                    mainVC.leftMenu.studentinformationaction=@"EnrollLead";
                    mainVC.leftMenu.studentinformationleadobject=DetailsViewLead;
                    globalvariables.leftmenuindex=@"1";
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
                }
                

                
                
            }else{
                if ([self updateleadstatuswithstatus:[LeadStatusArray objectAtIndex:indexPath.row]]) {
                    [leadstatusbutton setTitle:[MyClass returntitlewithtitle:[LeadStatusArray objectAtIndex:indexPath.row]] forState:UIControlStateNormal];
                    
                    if ([[LeadStatusArray objectAtIndex:indexPath.row] isEqualToString:@"Black List"]) {
                        leadstatusbutton.backgroundColor=[UIColor redColor];
                    }else{
                        leadstatusbutton.backgroundColor=themecolor;
                    }
                    DetailsViewLead.status=[LeadStatusArray objectAtIndex:indexPath.row];
                    [self.delegate updateCategoryCount];
                }
            }
        }
    }else if (tableView==ViewHistoryTable){
        systemMessageLabel.text=[NSString stringWithFormat:@"%@...",[MyClass returntitlewithtitle:@"Loading Information"]];
        //systemMessageLabel.frame=CGRectMake(0, 0, selfViewWidth, self.view.frame.size.height-64);
        systemMessageTrailingConstraint.constant=0;
        ViewHistoryTableMasterView.hidden=YES;
        [self.delegate gotoLeadProfilewithLeadkey:((ViewHistoryRecord *)[viewhistoryarray objectAtIndex:indexPath.row]).typekey submenu:lastviewindex classkeys:nil];
    }else if(tableView==DetailsViewMessageTable){
        if (selectMode) {
            [self selectMessageWithIndex:indexPath.row];
        }
    }
}


#pragma mark
#pragma mark Methods

- (IBAction)cancelSelectButtonPressed:(id)sender {
    [selectedinboxmessages removeAllObjects];
    selectMode=nil;
    [DetailsViewMessageTable reloadData];
    selectStatusView.hidden=YES;
//    forwardMessageButton.hidden=YES;
    deleteMessageButton.hidden=YES;
}


-(BOOL) updateleadstatuswithstatus:(NSString *)leadstatus
{
    NSString *strURL=[NSString stringWithFormat:@"%@?entitykey=%@&centerdb=%@&centerkey=%@&action=updatelead&leadkey=%@&status=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.entitykey,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey, DetailsViewLead.leadkey,leadstatus];
    
    __block BOOL result=FALSE;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            
        }
    }];
    
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
//    NSURLSession *session = [NSURLSession sharedSession];
//    
//    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        // handle response
//        if (!error) {
//            result=TRUE;
//        }
//        dispatch_semaphore_signal(semaphore);
//    }] resume];
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    return result;
}


- (BOOL)retrieveLead:(NSString *)leadkey
{
    [self.view endEditing:YES];
    [self showviewhistory:FALSE];
    
    if (!globalvariables) {
        globalvariables=[GlobalVariables singleObj];
    }
    
    [MyClass getLatestDataSetv2withParameters:@"lead,student" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:nil];
    [self closefullscreen];
    //photofullscreenview.hidden=YES;
    //viewhistorybutton.hidden=[leadAction isEqualToString:@"PopoverLead"]?YES:NO;
    
    if (leadkey) {
        NSDate *date;

        DetailsViewLead=[MyClass returnleadwithleadkey:leadkey];
        
        leadnamelabel.text=[MyClass returnLeadnameWithLeadkey:DetailsViewLead.leadkey option:@"allbutid"];//[MyClass returnfullnamewithfirstname:DetailsViewLead.firstname lastname:DetailsViewLead.lastname];
        genderlabel.text=[MyClass returntitlewithtitle:DetailsViewLead.gender];
        
        [df setDateFormat:@"dd-MMM-yyyy"];
        dateofbirthlabel.text = [MyClass returndateformatwithdate:DetailsViewLead.dateofbirth];
        
        if (DetailsViewLead.dateofbirth && ![DetailsViewLead.dateofbirth isEqualToString:@""]){
            NSDate *now =[NSDate date];
            [df setDateFormat:@"dd-MMM-yyyy"];
            date=[df dateFromString:DetailsViewLead.dateofbirth];
            
            double time =[now timeIntervalSinceDate:date];
            int allDays = (((time/60)/60/24));
            int days=allDays%365;
            int years=(allDays-days)/365;
            agelabel.text= [@(years) stringValue];
        }else{
            agelabel.text=DetailsViewLead.age;
        }
        gradelabel.text=DetailsViewLead.grade;
        preferredlanguagelabel.text=[MyClass returntitlewithtitle:DetailsViewLead.preferredlanguage];
        schoollabel.text=DetailsViewLead.school;
        parentname.text=DetailsViewLead.parentname;
        
        if ([DetailsViewLead.parentcontact isEqualToString:@""]) {
            [ccimage setImage:nil];
            countrycode.text=@"";
            parentcontact.text=@"";
        }else{
            [MyClass downloadImageWithImageview:ccimage gender:nil type:@"flag" typekey:DetailsViewLead.iso_code image:@"Yes" async:YES];
            countrycode.text=[NSString stringWithFormat:@"+%@",[MyClass returnCountryCodeWithISOCode:DetailsViewLead.iso_code]];
            [countrycode sizeToFit];
            countrycode.frame=CGRectMake(203+2+19.5, 334, countrycode.frame.size.width, 21);
            parentcontact.text=[MyClass returnLocalNumberWithContact:DetailsViewLead.parentcontact ISOCode:DetailsViewLead.iso_code];
            parentcontact.frame=CGRectMake(countrycode.frame.size.width+countrycode.frame.origin.x+2, 334, 124, 21);
        }
        
        parentemail.text=DetailsViewLead.parentemail;
        
        
        CGRect myFrame=parentaddress.frame;
        parentaddress.text=DetailsViewLead.parentaddress;

        remarks.frame=CGRectMake(0, 0, selfViewWidth-251, 500);
        remarks.font=[UIFont systemFontOfSize:15];
        remarks.text=DetailsViewLead.remarks;
        [remarks sizeToFit];
        myFrame=remarks.frame;
        
        
        if (myFrame.size.height>remarksscrollview.frame.size.height) {
            remarks.frame=CGRectMake(0, 0, selfViewWidth-251, 500);
            remarks.font=[UIFont systemFontOfSize:13];
            [remarks sizeToFit];
            myFrame=remarks.frame;
        }
        
        remarks.frame=CGRectMake(0, 0, selfViewWidth-251, myFrame.size.height);
        
        remarksscrollview.contentSize=CGSizeMake(remarks.frame.size.width, remarks.frame.size.height);
        
        
        leadidlabel.text=DetailsViewLead.leadid;
        medialabel.text=DetailsViewLead.leadmedia;
        sourcelabel.text=DetailsViewLead.leadsource;
        
        [leadstatusbutton setTitle:[MyClass returntitlewithtitle:[DetailsViewLead.status isEqualToString:@""]?@"New":DetailsViewLead.status] forState:UIControlStateNormal];
        if ([DetailsViewLead.status isEqualToString:@"Black List"]) {
            leadstatusbutton.backgroundColor=[UIColor redColor];
        }else{
            leadstatusbutton.backgroundColor=themecolor;
        }
        
        if ([DetailsViewLead.flag isEqualToString:@"Yes"]) {
            swflag.on=YES;
        }else{
            swflag.on=NO;
            
        }
        
        if ([DetailsViewLead.promotion isEqualToString:@"Yes"]) {
            swpromotion.on=YES;
        }else{
            swpromotion.on=NO;
            
        }
        
        
        
        //retrieve lead image
        [MyClass downloadImageWithImageview:viewleadimage gender:DetailsViewLead.gender type:@"lead" typekey:DetailsViewLead.leadkey image:DetailsViewLead.image async:YES];

        viewleadimage.layer.cornerRadius=10;
        viewleadimage.layer.masksToBounds=YES;
        
        if (![leadAction isEqualToString:@"PopoverLead"]) {
            systemMessageView.hidden=YES;
        }
        

        //[MyClass insertViewHistoryWithType:@"lead" Typekey:leadkey Name:@"" IDNumber:@"" Gender:@""];
        //viewhistoryarray=[MyClass returnViewHistoryWithType:@"lead"];
        
        return YES;
    }else{
        return YES;
    }
}


-(void) retrieveDTrecords
{
    [self retrieveDTWithSubject:dtsubjectselected leadkey:DetailsViewLead.leadkey classtype:dttypeselected];
}

-(BOOL) retrieveDTWithSubject:(NSString *)subject leadkey:(NSString *)leadkey classtype:(NSString *)classtype
{
    
    __block long selecteddtkeyindex=0;
    //create string contains url address for php file
    NSString *strURL;
    //tNSString *allclasses;

    strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=selectdt&type=%@&typekey=%@&subject=%@&classtype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,@"lead",DetailsViewLead.leadkey,@"All",@"All"];
    
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
                if ([sdtkey isEqualToString:selectedDTkey]) {
                    selecteddtkeyindex=i;
                }
                
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
    
    if (result) {
        //Reload our student view
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

-(BOOL) localupdateCategoryCountwithflag:(NSString *)flag
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatelead&leadkey=%@&flag=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DetailsViewLead.leadkey,flag];
    
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
        DetailsViewLead.flag=flag;
        [self.delegate updateCategoryCount];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    return result;
}




- (void) selecttable:(UIButton *)sender {
    [self stopAudioPlaying];
    [self highlighttableoptionbuttonwithbuttontag:sender.tag];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (sender.tag==0) {
            if (![self retrieveLead:DetailsViewLead.leadkey]) {
                [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
                //sctableoption.selectedSegmentIndex=lastviewindex;
                return;
            }
            
            ViewLead.hidden=NO;
            DTRecordView.hidden=YES;
            //EnrollmentClassMenuView.hidden=YES;
            MessageView.hidden=YES;
            CallLogView.hidden=YES;
            [self createLeadViewNavigationButton];
            
            //self.navigationItem.title=[MyClass returntitlewithtitle:@"Lead Information"];
            lastviewindex=sender.tag;
            
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        }else if (sender.tag==3) {
            dtsubjectselected=@"All";
            dttypeselected=@"All";
            DTSubjectArray=[[NSMutableArray alloc]initWithObjects:[MyClass returntitlewithtitle:@"All Classes"], nil];
            [DTSubjectSelectionButton setTitle:[MyClass returntitlewithtitle:[DTSubjectArray objectAtIndex:0]] forState:UIControlStateNormal];
            if (![self retrieveDTWithSubject:dtsubjectselected leadkey:DetailsViewLead.leadkey classtype:dttypeselected]) {
                [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
                //sctableoption.selectedSegmentIndex=lastviewindex;
                return;
            }
            
            ViewLead.hidden=YES;
            DTRecordView.hidden=NO;
            //EnrollmentClassMenuView.hidden=NO;
            MessageView.hidden=YES;
            CallLogView.hidden=YES;
            
            [self createDTViewNavigationButton];
            
            //self.navigationItem.title=[MyClass returntitlewithtitle:@"Trial/Assessment"];
            lastviewindex=sender.tag;
            
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        }else if (sender.tag==1) {

            
            if (![self retrieveMessageRecord]) {
                [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
                //sctableoption.selectedSegmentIndex=lastviewindex;
                return;
            }
            
            ViewLead.hidden=YES;
            DTRecordView.hidden=YES;
            //EnrollmentClassMenuView.hidden=YES;
            MessageView.hidden=NO;
            CallLogView.hidden=YES;
            
            [self createMessageViewNavigationButton];
            
            //[self performSelector:@selector(retrieveMessageRecord) withObject:nil afterDelay:0];
            //self.navigationItem.title=[MyClass returntitlewithtitle:@"Messages"];
            
            lastviewindex=sender.tag;
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            
        }else if (sender.tag==2) {
            calllogcalledbyselected=@"All";
            [CallLogCalledBySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Callers"] forState:UIControlStateNormal];
            if (![self retrieveCallLogRecord]) {
                [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
                //sctableoption.selectedSegmentIndex=lastviewindex;
                return;
            }
            
            staffArray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveStaffListwithvalid:@"All" role:@"All" flushcachedata:YES]];
            if (!staffArray) {
                return;
            }
            
            ViewLead.hidden=YES;
            DTRecordView.hidden=YES;
            //EnrollmentClassMenuView.hidden=YES;
            MessageView.hidden=YES;
            CallLogView.hidden=NO;
            
            [self createCallLogViewNavigationButton];
            
            //self.navigationItem.title=[MyClass returntitlewithtitle:@"Call Log"];
            
            lastviewindex=sender.tag;
            
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            
        }

    });
}

-(void) cancelLead{
    runviewdidappear=FALSE;
    [self.delegate donotrunviewdidappearinleadinformation];
    if ([leadAction isEqualToString:@"AddNewLead"]) {
        leadAction=nil;
    }else if ([leadAction isEqualToString:@"EditLead"]) {
        leadAction=@"ViewLead";
    }
    
    systemMessageLabel.text=[MyClass returntitlewithtitle:@"Select lead or press + to add new"];
    //systemMessageLabel.frame=CGRectMake(0, 0, 570, 704);
    //ViewHistoryTableMasterView.hidden=NO;
    [self.delegate enableAddLeadButton];
    
}

-(BOOL) retrieveCallLogRecord
{
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievecalllog&type=%@&typekey=%@&calledby=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,@"lead",DetailsViewLead.leadkey,@"All"];
    
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


-(IBAction)editLead:(id)sender{
    [self showviewhistory:FALSE];
    photofullscreenview.hidden=YES;
    leadAction=@"EditLead";
    [self seguetoleadeditview];
}

-(void) showview:(NSString *)view
{
    if ([view isEqualToString:@"systemmessage"]) {
        systemMessageView.hidden=NO;
        ViewLead.hidden=YES;
        TopMenuView.hidden=YES;
        MessageView.hidden=YES;
        CallLogView.hidden=YES;
        DTRecordView.hidden=YES;
    }
}

-(void) seguetoleadeditview
{
    if ([self retrieveMediaSource]) {
        //StudentEditViewController *viewcontroller=[[StudentEditViewController alloc]init];
        if ([leadAction isEqualToString:@"EditLead"]) {
            destleadeditviewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"LeadEditViewController"];
            //StudentEditViewController *viewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentEditViewController"];
            destleadeditviewcontroller.delegate=self;
            destleadeditviewcontroller.EditViewLead=DetailsViewLead;
            destleadeditviewcontroller.EditViewLeadAction=leadAction;
            destleadeditviewcontroller.MediaArray=MediaArray;
            destleadeditviewcontroller.SourceArray=SourceArray;
            [self.navigationController pushViewController:destleadeditviewcontroller animated:YES];
            
        }else if ([leadAction isEqualToString:@"AddNewLead"]){
            destleadeditviewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"LeadEditViewController"];
            //StudentEditViewController *viewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentEditViewController"];
            destleadeditviewcontroller.delegate=self;
            destleadeditviewcontroller.EditViewLead=DetailsViewLead;
            destleadeditviewcontroller.MediaArray=MediaArray;
            destleadeditviewcontroller.SourceArray=SourceArray;
            destleadeditviewcontroller.EditViewLeadAction=leadAction;
            [self showview:@"systemmessage"];
            [self.navigationController pushViewController:destleadeditviewcontroller animated:YES];
        }
    }
    
    

}

-(void) dismissVCPopover
{
    [self retrieveDTWithSubject:dtsubjectselected leadkey:DetailsViewLead.leadkey classtype:dttypeselected];
    //[ClassSelectionButton setTitle:[SubjectArray objectAtIndex:0] forState:UIControlStateNormal];
    //dtsubjectselected=@"All";
    //[self updateLeadCategoryCount];
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self closesidewindow];
    
    DataChanged=TRUE;
}

-(void) refreshleaddetailsinformation
{
    [self retrieveDTWithSubject:@"All" leadkey:DetailsViewLead.leadkey classtype:@"All"];
    DataChanged=TRUE;
}


-(void) dismissDTPopoverVC
{
    [self retrieveDTWithSubject:dtsubjectselected leadkey:DetailsViewLead.leadkey classtype:dttypeselected];
    [self closesidewindow];
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
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
    
    lead_editButton.hidden=YES;
    addContactLogbutton.hidden=YES;
    addDTbutton.hidden=YES;
    lead_goToStudentButton.hidden=YES;
}


-(void) createLeadViewNavigationButton
{
    
//    UIBarButtonItem* editbutton= [[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Edit"] style:UIBarButtonItemStylePlain target:self action:@selector(editLead:)];
//    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editLead:)];
//    self.navigationItem.rightBarButtonItem=editbutton;
//    
//    UIBarButtonItem* studentprofilebutton= [[UIBarButtonItem alloc]initWithTitle:[MyClass returntitlewithtitle:@"Go to Student Profile"] style:UIBarButtonItemStylePlain target:self action:@selector(gotostudentprofile:)];
//    [studentprofilebutton setTintColor:[UIColor lightTextColor]];
//    [studentprofilebutton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem=[DetailsViewLead.status isEqualToString:@"Enrolled"]?studentprofilebutton:nil;
    
    lead_editButton.hidden=NO;
    lead_goToStudentButton.hidden=![DetailsViewLead.status isEqualToString:@"Enrolled"];
    addContactLogbutton.hidden=YES;
    addDTbutton.hidden=YES;
    
}

-(void) createDTViewNavigationButton
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addnewdt:)];
//    UIBarButtonItem* centertitle= [[UIBarButtonItem alloc]initWithTitle:globalvariables.centerrecord.centername style:UIBarButtonItemStylePlain target:self action:nil];
//    [centertitle setTintColor:[UIColor lightTextColor]];
//    [centertitle setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, [UIColor lightTextColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem=nil;//centertitle;
    
    lead_editButton.hidden=YES;
    addContactLogbutton.hidden=YES;
    addDTbutton.hidden=NO;
    lead_goToStudentButton.hidden=YES;
    
}

-(void) createMessageViewNavigationButton
{
//    self.navigationItem.rightBarButtonItem = nil;//[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addnewmessage:)];
//    UIBarButtonItem* centertitle= [[UIBarButtonItem alloc]initWithTitle:globalvariables.centerrecord.centername style:UIBarButtonItemStylePlain target:self action:nil];
//    [centertitle setTintColor:[UIColor lightTextColor]];
//    [centertitle setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, [UIColor lightTextColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem=nil;//centertitle;
    
    lead_editButton.hidden=YES;
    addContactLogbutton.hidden=YES;
    addDTbutton.hidden=YES;
    lead_goToStudentButton.hidden=YES;
    
}

-(void) createCallLogViewNavigationButton
{
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addnewcalllog:)];
//    UIBarButtonItem* centertitle= [[UIBarButtonItem alloc]initWithTitle:globalvariables.centerrecord.centername style:UIBarButtonItemStylePlain target:self action:nil];
//    [centertitle setTintColor:[UIColor lightTextColor]];
//    [centertitle setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:13], NSFontAttributeName, [UIColor lightTextColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    self.navigationItem.leftBarButtonItem=nil;//centertitle;
    
    lead_editButton.hidden=YES;
    addContactLogbutton.hidden=NO;
    addDTbutton.hidden=YES;
    lead_goToStudentButton.hidden=YES;
}

-(void) deleteLead:(NSString *)leadkey
{
    
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=deletelead&leadkey=%@updatedby=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DetailsViewLead.leadkey,globalvariables.username];
    
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
        ViewLead.hidden=YES;
        TopMenuView.hidden=YES;
        systemMessageLabel.text=[MyClass returntitlewithtitle:@"Select lead or press + to add new"];
        [MyClass removeViewHistoryWithType:@"lead" Typekey:leadkey];
        [self showviewhistory:YES];
        systemMessageView.hidden=NO;
        leadAction=nil;
        
        [self.delegate gobackLeadCategory];
        [self createInitialViewNavigationButton];
    }/*else{
        [MyClass showconnectionlostdialogbox];
    }*/
    
}

-(void) updateLeadCategoryCount
{
    [self.delegate updateCategoryCount];
}

-(void) updateleadinformationlist:(NSString *)leadkey
{
    [self.delegate updateleadinformationlist:leadkey];
}

-(void) refreshLeadView:(NSString *)leadkey
{
    ViewLead.hidden=NO;
    TopMenuView.hidden=NO;
    systemMessageLabel.text=@"";
    systemMessageView.hidden=YES;
    [self retrieveLead:leadkey];
    dtsubjectselected=@"All";
    //DetailsViewLeadkey=leadkey;
    lastviewindex=0;
    [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
    //sctableoption.selectedSegmentIndex=lastviewindex;
    //self.navigationItem.title=[MyClass returntitlewithtitle:@"Lead Profile"];
    
    
    //self.navigationItem.title=@"Student Information";
    [self createLeadViewNavigationButton];
}

-(void) dismisspopover
{
    [self closesidewindow];
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self retrieveDTWithSubject:dtsubjectselected leadkey:DetailsViewLead.leadkey classtype:dttypeselected];
    DataChanged=TRUE;
}


-(BOOL)shouldAutorotate {
    return NO;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView== DetailsViewMessageTable) {
        return UITableViewAutomaticDimension;
    }else if (tableView==CallLogTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==DetailsViewDTTable){
        return UITableViewAutomaticDimension;
    }else if (tableView==ViewHistoryTable){
        return 44;
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
//    forwardMessageButton.hidden=YES;
    deleteMessageButton.hidden=YES;
    
    [self stopAudioPlaying];
    [self updateinstantmessagetopbox];
    InboxMessageRecord *messageobject;
    
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievemessagelist2&username=%@&apptype=center&messagecontact=%@&messagecontacttype=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,globalvariables.username,DetailsViewLead.leadkey,@"Lead"];
    
    __block BOOL result=FALSE;
    __block NSArray *JSONArray;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            JSONArray = jsonreturned[@"content"];
        }
    }];
    
    /*dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
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
        

        
        for (int i=0; i<JSONArray.count; i++) {
            
            NSString * csender=[[JSONArray objectAtIndex:i] objectForKey:@"sender"];
            NSString * cassociateid=[[JSONArray objectAtIndex:i] objectForKey:@"associateid"];
            NSString * cmessagestarttime=[[JSONArray objectAtIndex:i] objectForKey:@"messagestarttime"];
            NSString * cinboxmessagekey=[[JSONArray objectAtIndex:i] objectForKey:@"inboxmessagekey"];
            NSString * coutboxmessagekey=[[JSONArray objectAtIndex:i] objectForKey:@"outboxmessagekey"];
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
            
            messageobject=[[InboxMessageRecord alloc]initInboxMessageRecordwithInboxMessagekey:cinboxmessagekey Messagetype:cmessagetype MessageEnglish:cmessageenglish MessageChinese:cmessagechinese MessageCreateTime:nil MessageStartTime:cmessagestarttime AutoMessageFlag:cautomessageflag Channel:cchannel ReciptientType:crecipienttype Status:cstatus Sender:csender AssociateID:cassociateid Readtime:creadtime photoarray:tmpphotoarray recipient:crecipient outboxmessagekey:coutboxmessagekey type:ctype readstatus:creadstatus readstatusdetailsarray:tmpreadstatusdetailsarray replytomessagekey:@"0"];
            
            
            [messageArray addObject:messageobject];
            
        }
        [self returnfilteredMessageArray];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }else{
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }
    return YES;
}
-(void) returnfilteredMessageArray
{
    if ([messagesearchbar.text isEqualToString:@""]) {
        filteredMessageArray= [[NSMutableArray alloc]initWithArray:messageArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.messageenglish contains[c] %@ or self.messagechinese contains[c] %@ or self.sender contains[c] %@ or self.messagetype contains[c] %@",messagesearchbar.text,messagesearchbar.text,messagesearchbar.text,messagesearchbar.text];
        filteredMessageArray= [[NSMutableArray alloc]initWithArray:[messageArray filteredArrayUsingPredicate:predicate]];
    }
    
    
    
    [DetailsViewMessageTable reloadData];
    
    
    
    if (filteredMessageArray.count>0) {
            if (DetailsViewMessageTable.contentSize.height<DetailsViewMessageTable.frame.size.height) {
                DetailsViewMessageTable.contentInset=UIEdgeInsetsMake(DetailsViewMessageTable.frame.size.height-DetailsViewMessageTable.contentSize.height, 0,0, 0);
                [DetailsViewMessageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }else{
                DetailsViewMessageTable.contentInset=UIEdgeInsetsZero;

                    [DetailsViewMessageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
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
        newCondition = [NSPredicate predicateWithFormat:@"SELF.calledon contains[c] %@ or SELF.calledbyfullname contains[c] %@ or SELF.details contains[c] %@",calllogsearchbar.text,calllogsearchbar.text,calllogsearchbar.text];
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
        newCondition = [NSPredicate predicateWithFormat:@"SELF.DTdate contains[c] %@ or SELF.DTtime contains[c] %@ or SELF.subject contains[c] %@ or self.levelmain contains[c] %@ or self.instructor contains[c] %@ or self.remarks contains[c] %@ or self.classtype contains[c] %@ or self.classroom contains[c] %@ or self.instructorfullname contains[c] %@ or self.subjectfullname contains[c] %@",dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text,dtsearchbar.text];
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

-(void) sortingbuttonpressed:(UIButton *)sender
{
    
    if (lastviewindex==1){
        [self returnsortingarraywithtype:@"messagelistsortingorder"];
    }else if (lastviewindex==2){
        [self returnsortingarraywithtype:@"callloglistsortingorder"];
    }else if (lastviewindex==3){
        [self returnsortingarraywithtype:@"dtlistsortingorder"];
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

-(void) changesortingorder:(UIButton *)sender
{
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:sortingtable];
    NSIndexPath *indexpath =[sortingtable indexPathForRowAtPoint:point];
    
    if (!indexpath) {
        indexpath = [NSIndexPath indexPathForRow:0 inSection:0];
    }

    if ([((SortingRecord *)[sortingarray objectAtIndex:indexpath.row]).order isEqualToString:@"a"]){
        ((SortingRecord *)[sortingarray objectAtIndex:indexpath.row]).order=@"d";
    }else{
        ((SortingRecord *)[sortingarray objectAtIndex:indexpath.row]).order=@"a";
    }
    [self updatesortingstring];
    
    if (lastviewindex==2){
        [self sortcallloglist];
    }else if (lastviewindex==3){
        [self sortdtlist];
    }
    
    [sortingtable reloadData];
    
    
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
    
    if (lastviewindex==1){
        [MyClass updatelocaldbwithparameter:@"messagelistsortingorder" value:sortingstring];
    }else if (lastviewindex==2){
        [MyClass updatelocaldbwithparameter:@"callloglistsortingorder" value:sortingstring];
    }else if (lastviewindex==3){
        [MyClass updatelocaldbwithparameter:@"dtlistsortingorder" value:sortingstring];
    }
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
    }
    return item;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==sortingtable){
        return 40;
    }else{
        return CGFLOAT_MIN;
    }
}



- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self stopAudioPlaying];
    if (searchBar==messagesearchbar) {
        [self returnfilteredMessageArray];
    }else if (searchBar==calllogsearchbar) {
        [self returnfiltercalllogarray];
        //[stafftable reloadData];
        [CallLogTable setContentOffset:CGPointZero animated:YES];
    }else if (searchBar==dtsearchbar) {
        [self returnfilterdtarray];
        //[stafftable reloadData];
        [DetailsViewDTTable setContentOffset:CGPointZero animated:YES];
    }
}


/*
-(void) drawpointerwithoption:(NSString *)option button:(UIButton *)button
{
    for (CALayer *layer in button.layer.sublayers) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
    
    CGFloat xposition;
    CGFloat yposition;
    
    CGFloat width;
    CGFloat height;
    
    CGFloat offset;
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation==UIDeviceOrientationPortrait) {
        offset=23;
        width=12;
        height=4.8;
    }else{
        offset=30;
        width=15;
        height=6;
    }
    
    CAShapeLayer *cashapelayer = [CAShapeLayer layer];
    
    if ([option isEqualToString:@"closed"]) {
        
        yposition=12;
        xposition=button.frame.size.width-offset;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,NULL,xposition,yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
        CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition+height);
        CGPathAddLineToPoint(path, NULL, xposition, yposition);
        
        [cashapelayer setPath:path];
        cashapelayer.strokeColor = [UIColor whiteColor].CGColor;
        cashapelayer.lineWidth = 1.0f;
        [[button layer] addSublayer:cashapelayer];
        
        CGPathRelease(path);
    }else{
        yposition=12+height;
        xposition=button.frame.size.width-offset;
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,NULL,xposition,yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
        CGPathAddLineToPoint(path, NULL, xposition+width, yposition);
        CGPathAddLineToPoint(path, NULL, xposition+width/2, yposition-height);
        CGPathAddLineToPoint(path, NULL, xposition, yposition);
        
        [cashapelayer setPath:path];
        cashapelayer.strokeColor = [UIColor whiteColor].CGColor;
        cashapelayer.lineWidth = 1.0f;
        [[button layer] addSublayer:cashapelayer];
        
        CGPathRelease(path);
    }
    
    
}*/


-(void) createdtviewtableheader
{
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

-(IBAction) addnewcalllog:(UIButton *)sender
{
    [self showviewhistory:FALSE];
    
    
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        CallLogPopoverViewController *calllogpopover = (CallLogPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"CallLogPopoverViewController"];
        calllogpopover.delegate=self;
        calllogpopover.studentkey=DetailsViewLead.leadkey;
        calllogpopover.CallLogTableMode=@"Add";
        calllogpopover.CallingSource=@"lead";
        
        [calllogpopover InitializeField];
        
        [self->sidewindowview addSubview:calllogpopover.view];
        [self placeViewInSideWindow:calllogpopover.view];
        [self addChildViewController:calllogpopover];
        [calllogpopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
}


-(void) selectcalllogcalledby:(UIButton *)sender
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
    myCallLogSelectionPopoverController=viewcontroller.popoverPresentationController;
    myCallLogSelectionPopoverController.delegate=self;
    myCallLogSelectionPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
    myCallLogSelectionPopoverController.sourceView=sender;
    myCallLogSelectionPopoverController.sourceRect=sender.bounds;
    
    [self presentViewController:viewcontroller animated:YES completion:nil];
    
    [self drawpointerwithoption:@"open" imageview:calllog_callerarrow];
}


-(void) selectleadstatus:(UIButton *)sender
{
    if (![DetailsViewLead.status isEqualToString:@"Enrolled"]) {
        LeadStatusSelectionTable=[[UITableView alloc]init];
        LeadStatusSelectionTable.separatorColor=[UIColor clearColor];
        LeadStatusSelectionTable.delegate=self;
        LeadStatusSelectionTable.dataSource=self;
        [LeadStatusSelectionTable reloadData];
        LeadStatusSelectionTable.frame=CGRectMake(0, 0, 154, LeadStatusSelectionTable.contentSize.height);
        LeadStatusSelectionTable.separatorColor=[UIColor clearColor];
        
        UIView *calllogcallerSelectionMasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 154, LeadStatusSelectionTable.contentSize.height+44)];
        [calllogcallerSelectionMasterView addSubview:LeadStatusSelectionTable];
        
        
        UIViewController *viewcontroller=[[UIViewController alloc]initWithNibName:nil bundle:nil];
        viewcontroller.view=calllogcallerSelectionMasterView;
        viewcontroller.preferredContentSize=CGSizeMake(154, LeadStatusSelectionTable.contentSize.height);
        viewcontroller.modalPresentationStyle=UIModalPresentationPopover;
        myPopoverController=viewcontroller.popoverPresentationController;
        myPopoverController.delegate=self;
        myPopoverController.permittedArrowDirections=UIPopoverArrowDirectionUp;
        myPopoverController.sourceView=sender;
        myPopoverController.sourceRect=sender.bounds;
        
        [self presentViewController:viewcontroller animated:YES completion:nil];

    }
}


-(void) selectdtclass:(UIButton *)sender
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

-(void) selectdttype:(UIButton *)sender
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
    //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil]
}

- (void)flagLead:(UISwitch *)sender {

    //[sender setOn:sender.on?NO:YES animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self localupdateCategoryCountwithflag:sender.on?@"Yes":@"No"]) {
            [sender setOn:!sender.on animated:YES];
        }
    });
}

- (IBAction)addnewdt:(id)sender {
    [self showviewhistory:FALSE];
    
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        DTAddEditViewController *DTPopover = (DTAddEditViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"DTAddEditViewController"];
        DTPopover.delegate=self;
        //DTPopover.PopoverEnrollment=DetailsViewEnrollment;
        DTPopover.DTTableMode=@"Add";
        DTPopover.CallingSource=@"lead";
        DTPopover.PopoverMode=@"PopoverDTFromLeadView";
        DTPopover.CallingKey=DetailsViewLead.leadkey;
        
        [self->sidewindowview addSubview:DTPopover.view];
        [self placeViewInSideWindow:DTPopover.view];
        [self addChildViewController:DTPopover];
        [DTPopover didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
    
    /*
    //popup enrollment view record
    //UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    DTAddEditViewController *DTPopover = (DTAddEditViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"DTAddEditViewController"];
    DTPopover.delegate=self;
    //DTPopover.PopoverEnrollment=DetailsViewEnrollment;
    DTPopover.DTTableMode=@"Add";
    DTPopover.CallingSource=@"lead";
    DTPopover.PopoverMode=@"PopoverDTFromLeadView";
    DTPopover.CallingKey=DetailsViewLead.leadkey;
    myPopoverController =[[UIPopoverController alloc]initWithContentViewController:DTPopover];
    [myPopoverController setDelegate:self];
    [myPopoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];*/
}

-(void) dismissDTAddEditpopoverwithrefresh:(BOOL)refresh
{
    [self closesidewindow];
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    if (refresh) {
        [self retrieveDTWithSubject:dtsubjectselected leadkey:DetailsViewLead.leadkey classtype:dttypeselected];
        DataChanged=YES;
        [self.delegate refreshleaddetailviewpresentingviewcontent];
    }
}

-(void) dismissDTAddEditpopoverduetoconnectionerror
{
    [self closesidewindow];
    //[[myPopoverController presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void) enrollLead:(id)sender
{
    /*StudentInformationViewController *viewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformationViewController"];
    viewcontroller.StudentInformationAction=@"EnrollLead";
    viewcontroller.StudentInformationLeadObject=DetailsViewLead;//DTObject;
    [self presentViewController:viewcontroller animated:YES completion:nil];*/
    
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    mainVC.leftMenu.prepareforsegue=TRUE;
    mainVC.leftMenu.sourceview=@"leadprofile";
    mainVC.leftMenu.studentinformationaction=@"EnrollLead";
    mainVC.leftMenu.studentinformationleadobject=DetailsViewLead;
    globalvariables.leftmenuindex=@"1";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
}

-(void) enrollATLeadStudent:(AssessmentTrialRecord *)ATRecord
{

    [self closesidewindow];
    
    if ([leadAction isEqualToString:@"PopoverLead"]) {
        [self.delegate enrollATLeadStudent:ATRecord];
    }else{
        AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
        mainVC.leftMenu.prepareforsegue=TRUE;
        mainVC.leftMenu.sourceview=@"leadprofile";
        mainVC.leftMenu.studentinformationaction=@"EnrollATLeadStudent";
        mainVC.leftMenu.studentinformationatobject=ATRecord;
        globalvariables.leftmenuindex=@"1";
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
    }
}


-(BOOL) retrieveMediaSource
{
    NSMutableArray *mediasourcearray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveMarketingRecordWithStatus:@"Valid" enrollmentdate:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"dd-MMM-yyyy"] flushcachedata:YES subjectkey:nil productkey:nil]];
    if (mediasourcearray.count>0) {
        MediaArray=[[NSMutableArray alloc] initWithArray:[mediasourcearray objectAtIndex:0]];
        SourceArray=[[NSMutableArray alloc] initWithArray:[mediasourcearray objectAtIndex:1]];
        return YES;
    }else{
        return NO;
    }
}

-(IBAction) gotostudentprofile:(id)sender
{
    [self showviewhistory:FALSE];
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    mainVC.leftMenu.prepareforsegue=TRUE;
    mainVC.leftMenu.sourceview=@"leadprofile";
    mainVC.leftMenu.studentprofile_studentkey=DetailsViewLead.studentkey;
    mainVC.leftMenu.studentprofile_submenu=0;
    mainVC.leftMenu.studentinformationaction=@"Redirect";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
    
}

- (void)promotionLead:(UISwitch *)sender {
    
    //[sender setOn:sender.on?NO:YES animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self updatepromotionalmessagewithpromotion:sender.on?@"Yes":@"No"]) {
            [sender setOn:!sender.on animated:YES];
        }
    });
}

-(BOOL) updatepromotionalmessagewithpromotion:(NSString *)promotion
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=updatelead&leadkey=%@&promotion=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,DetailsViewLead.leadkey,promotion];
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            DetailsViewLead.promotion=promotion;
            result = TRUE;
        }
    }];
    
    /*
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // handle response
        
        if (!error) {
            DetailsViewLead.promotion=promotion;
            result = TRUE;
        }else{
            [MyClass showconnectionlostdialogbox];
        }
        dispatch_semaphore_signal(semaphore);
    }] resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
    
    return result;
}

-(CGFloat) visibleEdgeOverflowForMax:(CGFloat)viewMax safeMax:(CGFloat)safeMax fallback:(CGFloat)fallback
{
    UIWindow *window = self.view.window;
    if (!window) {
        return fallback;
    }
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGRect safeFrame = window.safeAreaLayoutGuide.layoutFrame;
    if (CGRectIsEmpty(safeFrame) || safeFrame.size.width < 1 || safeFrame.size.height < 1) {
        return fallback;
    }
    CGFloat viewEdge = (viewMax == 0) ? CGRectGetMaxX(frameInWindow) : CGRectGetMaxY(frameInWindow);
    CGFloat safeEdge = (viewMax == 0) ? CGRectGetMaxX(safeFrame) : CGRectGetMaxY(safeFrame);
    return MAX(0, viewEdge - safeEdge);
}

-(void) layoutLeadDetailsForCurrentSize
{
    CGFloat width = self.view.bounds.size.width;
    CGFloat height = self.view.bounds.size.height;
    if (width < 1 || height < 1) {
        return;
    }
    selfViewWidth = width;
    messagecontentwidth = MAX(width - 40, 0);
    maxphotoperline = (width - 40) / photosize;
    if (maxphotoperline < 1) {
        maxphotoperline = 1;
    }
    
    CGFloat trailing = [self visibleEdgeOverflowForMax:0 safeMax:0 fallback:self.view.safeAreaInsets.right];
    CGFloat bottomInset = 0;
    if (self.view.window) {
        CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
        bottomInset = MAX(0, CGRectGetMaxY(frameInWindow) - CGRectGetMaxY(self.view.window.bounds));
    }
    if (masterViewTrailingConstraint && fabs(masterViewTrailingConstraint.constant - trailing) > 0.5) {
        masterViewTrailingConstraint.constant = trailing;
    }
    if (masterViewBottomConstraint && fabs(masterViewBottomConstraint.constant - bottomInset) > 0.5) {
        masterViewBottomConstraint.constant = bottomInset;
    }
    CGFloat top = MAX(self.view.safeAreaInsets.top, 0);
    
    if (headertitleview) {
        CGFloat titleWidth = MAX(width - trailing - 300, 0);
        headertitleview.frame = CGRectMake(150, 0, titleWidth, 68);
        headertitlename.frame = CGRectMake(0, 25, titleWidth, 20);
        switchcenterbutton.frame = CGRectMake(0, 0, titleWidth, 68);
        [self updateheadercentertitle];
    }
    
    if (ViewLead) {
        ViewLead.frame = CGRectMake(7, 103, MAX(width - trailing - 16, 0), MAX(height - bottomInset - 103, 0));
    }
    
    if (ViewHistoryTableMasterView) {
        CGFloat masterTop = MAX(top, 64);
        ViewHistoryTableMasterView.frame = CGRectMake(0, masterTop, width, MAX(height - masterTop, 0));
        for (UIView *subview in ViewHistoryTableMasterView.subviews) {
            if (subview != self.viewHistoryCard && [subview isKindOfClass:[UIButton class]]) {
                subview.frame = ViewHistoryTableMasterView.bounds;
            }
        }
        if (self.viewHistoryCard) {
            CGFloat cardWidth = MIN(220, MAX(width - trailing - 28, 0));
            CGFloat cardX = width - trailing - cardWidth - 14;
            if (cardX < 8) {
                cardX = 8;
            }
            CGFloat cardHeight = ViewHistoryTableMasterView.bounds.size.height - 20 - bottomInset - 8;
            if (cardHeight < 80) {
                cardHeight = 80;
            }
            self.viewHistoryCard.frame = CGRectMake(cardX, 20, cardWidth, cardHeight);
            for (UIView *subview in self.viewHistoryCard.subviews) {
                if ([subview isKindOfClass:[UIButton class]]) {
                    subview.frame = CGRectMake(cardWidth - 40, 0, 35, 35);
                }
            }
            ViewHistoryTable.frame = CGRectMake(0, 35, cardWidth, MAX(cardHeight - 35, 0));
        }
    }
    
    if (viewhistorybutton) {
        CGFloat buttonSize = 45;
        if (self.historyButtonFollowsCorner) {
            viewhistorybutton.frame = CGRectMake(width - trailing - buttonSize - 20, height - bottomInset - buttonSize - 20, buttonSize, buttonSize);
        } else {
            CGRect frame = viewhistorybutton.frame;
            frame.origin.x = MIN(MAX(frame.origin.x, 8), MAX(width - trailing - buttonSize, 8));
            frame.origin.y = MIN(MAX(frame.origin.y, top + 8), MAX(height - bottomInset - buttonSize, top + 8));
            viewhistorybutton.frame = frame;
        }
    }
    
    [self layoutSideWindowForCurrentSize];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutLeadDetailsForCurrentSize];
}

-(UIWindow *) detailsSceneWindow
{
    if (self.view.window) {
        return self.view.window;
    }
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) {
            continue;
        }
        UIWindowScene *windowScene = (UIWindowScene *)scene;
        if (windowScene.activationState != UISceneActivationStateForegroundActive && windowScene.activationState != UISceneActivationStateForegroundInactive) {
            continue;
        }
        for (UIWindow *window in windowScene.windows) {
            if (window.isKeyWindow) {
                return window;
            }
        }
        if (windowScene.windows.firstObject) {
            return windowScene.windows.firstObject;
        }
    }
    SceneDelegate *sceneDelegate = (SceneDelegate *)[UIApplication sharedApplication].connectedScenes.anyObject.delegate;
    return sceneDelegate.window;
}

-(void) layoutSideWindowForCurrentSize
{
    if (!sidewindowview || self.sideWindowAnimating) {
        return;
    }
    UIWindow *window = self.view.window ? self.view.window : mainWindow;
    if (!window) {
        return;
    }
    if (mainWindow != window) {
        mainWindow = window;
        mainviewcontroller = (MainViewController *)[window rootViewController];
    }
    if (sidewindowviewclosebutton.superview != window) {
        [window addSubview:sidewindowviewclosebutton];
    }
    if (sidewindowview.superview != window) {
        [window addSubview:sidewindowview];
    }
    sidewindowviewclosebutton.frame = window.bounds;
    
    CGFloat windowWidth = window.bounds.size.width;
    CGFloat windowHeight = window.bounds.size.height;
    if (!self.sideWindowOpen) {
        sidewindowview.hidden = YES;
        sidewindowview.frame = CGRectMake(windowWidth, 0, 0, windowHeight);
        sidewindowviewclosebutton.hidden = YES;
        return;
    }
    sidewindowview.hidden = NO;
    NSUInteger panelIndex = [window.subviews indexOfObject:sidewindowview];
    NSUInteger dimmerIndex = [window.subviews indexOfObject:sidewindowviewclosebutton];
    if (panelIndex != NSNotFound && dimmerIndex != NSNotFound && panelIndex < dimmerIndex) {
        [window insertSubview:sidewindowview aboveSubview:sidewindowviewclosebutton];
    }
    CGFloat requestedWidth = self.sideWindowRequestedWidth > 0 ? self.sideWindowRequestedWidth : 320.0;
    CGFloat panelWidth = MIN(requestedWidth, windowWidth);
    sidewindowview.frame = CGRectMake(windowWidth - panelWidth, 0, panelWidth, windowHeight);
    for (UIView *subview in sidewindowview.subviews) {
        if (subview == ailoadindicator) {
            continue;
        }
        subview.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        subview.frame = sidewindowview.bounds;
    }
    ailoadindicator.center = CGPointMake(sidewindowview.bounds.size.width / 2.0 - 7.5, sidewindowview.bounds.size.height / 2.0 - 7.5);
}

-(CGFloat) clampedSideWindowWidth:(CGFloat)width
{
    if (!mainWindow) {
        mainWindow = [self detailsSceneWindow];
    }
    if (width <= 0 || !mainWindow || mainWindow.bounds.size.width <= 0) {
        return 0;
    }
    return MIN(width, mainWindow.bounds.size.width);
}

-(void) placeViewInSideWindow:(UIView *)view
{
    view.translatesAutoresizingMaskIntoConstraints = YES;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.frame = sidewindowview.bounds;
    view.clipsToBounds = YES;
}

-(void) loadgeneral
{
    //MasterView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, selfViewWidth, self.view.frame.size.height)];
    //[self.view addSubview:MasterView];
    
    
    
    //systemMessageView=[[UIView alloc]initWithFrame:CGRectMake(0, 44, selfViewWidth, self.view.frame.size.height-64)];
    //[MasterView addSubview:systemMessageView];
    
    //systemMessageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, selfViewWidth, self.view.frame.size.height-64)];
    //systemMessageLabel.font=[UIFont systemFontOfSize:22];
    //systemMessageLabel.textAlignment=NSTextAlignmentCenter;
    //systemMessageLabel.textColor=[UIColor lightGrayColor];
    //[systemMessageView addSubview:systemMessageLabel];
    
    viewhistorybutton=[[UIButton alloc]initWithFrame:CGRectMake(selfViewWidth-45-20, self.view.bounds.size.height-100, 45, 45)];
    viewhistorybutton.backgroundColor=[UIColor lightGrayColor];
    [viewhistorybutton setImage:[UIImage imageNamed:@"history_icon.png"] forState:UIControlStateNormal];
    [viewhistorybutton applyImageInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
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
    self.viewHistoryCard=tableview;
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
    [closeviewhistorybutton applyImageInsets:UIEdgeInsetsMake(8, 8, 8, 8)];
    [tableview addSubview:closeviewhistorybutton];
    
    ViewHistoryTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 35, 220, 616) style:UITableViewStylePlain];
    ViewHistoryTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    ViewHistoryTable.backgroundColor=[UIColor clearColor];
    ViewHistoryTable.scrollEnabled=YES;
    ViewHistoryTable.delegate=self;
    ViewHistoryTable.dataSource=self;
    [tableview addSubview:ViewHistoryTable];
    
    //TopMenuView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, selfViewWidth, 44)];
    //[MasterView addSubview:TopMenuView];
    
    tableoptionarray=[[NSMutableArray alloc]initWithObjects:@"Lead",@"Messages",@"Call Log",@"Trial/Assessment", nil];
    tableoptionviewarray=[[NSMutableArray alloc]initWithObjects:@"1",@"1",@"1",@"1", nil];
    
    menuview_lead.hidden=![[tableoptionviewarray objectAtIndex:menuview_lead.tag] isEqualToString:@"1"];
    menuview_messages.hidden=![[tableoptionviewarray objectAtIndex:menuview_messages.tag] isEqualToString:@"1"];
    menuview_calllog.hidden=![[tableoptionviewarray objectAtIndex:menuview_calllog.tag] isEqualToString:@"1"];
    menuview_trial.hidden=![[tableoptionviewarray objectAtIndex:menuview_trial.tag] isEqualToString:@"1"];
    
    menulabel_lead.text=[MyClass returntitlewithtitle:[tableoptionarray objectAtIndex:menulabel_lead.tag]];
    menulabel_messages.text=[MyClass returntitlewithtitle:[tableoptionarray objectAtIndex:menulabel_messages.tag]];
    menulabel_calllog.text=[MyClass returntitlewithtitle:[tableoptionarray objectAtIndex:menulabel_calllog.tag]];
    menulabel_trial.text=[MyClass returntitlewithtitle:[tableoptionarray objectAtIndex:menulabel_trial.tag]];
    
    /*for (int i=0; i<tableoptionarray.count; i++) {
        if (i==tableoptionarray.count-1) {
            tableoptionbutton=[[UIButton alloc]initWithFrame:CGRectMake(i*TopMenuView.frame.size.width/tableoptionarray.count, 0, TopMenuView.frame.size.width-(TopMenuView.frame.size.width/tableoptionarray.count)*(tableoptionarray.count-1), TopMenuView.frame.size.height)];
        }else{
            tableoptionbutton=[[UIButton alloc]initWithFrame:CGRectMake(i*TopMenuView.frame.size.width/tableoptionarray.count, 0, TopMenuView.frame.size.width/tableoptionarray.count, TopMenuView.frame.size.height)];
        }
        tableoptionbutton.backgroundColor=[UIColor darkGrayColor];
        [tableoptionbutton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        tableoptionbutton.titleLabel.font=[UIFont boldSystemFontOfSize:13];
        tableoptionbutton.titleLabel.textAlignment=NSTextAlignmentCenter;
        [tableoptionbutton setTitle:[MyClass returntitlewithtitle:[tableoptionarray objectAtIndex:i]] forState:UIControlStateNormal];
        tableoptionbutton.enabled=NO;
        tableoptionbutton.tag=i;
        [tableoptionbutton addTarget:self action:@selector(selecttable:) forControlEvents:UIControlEventTouchUpInside];
        [TopMenuView addSubview:tableoptionbutton];
    }
    
    tableoptionbottombar=[[UIView alloc]initWithFrame:CGRectMake(0,TopMenuView.frame.size.height-2, TopMenuView.frame.size.width/tableoptionarray.count, 2)];
    tableoptionbottombar.backgroundColor=[UIColor yellowColor];
    [TopMenuView addSubview:tableoptionbottombar];*/
    
    
    ViewLead=[[UIView alloc]initWithFrame:CGRectMake(7, 103, selfViewWidth-16, MasterView.frame.size.height-103)];
    [MasterView addSubview:ViewLead];
    
    //Title
    title_Gender=[[UILabel alloc]initWithFrame:CGRectMake(203, 69, 57, 21)];
    title_Gender.font=[UIFont systemFontOfSize:11];
    title_Gender.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_Gender];

    title_Date_of_Birth=[[UILabel alloc]initWithFrame:CGRectMake(203, 113, 97, 21)];
    title_Date_of_Birth.font=[UIFont systemFontOfSize:11];
    title_Date_of_Birth.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_Date_of_Birth];
    
    title_Age=[[UILabel alloc]initWithFrame:CGRectMake(328, 113, 31, 21)];
    title_Age.font=[UIFont systemFontOfSize:11];
    title_Age.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_Age];
    
    title_Preferred_Language=[[UILabel alloc]initWithFrame:CGRectMake(421, 113, 237, 21)];
    title_Preferred_Language.font=[UIFont systemFontOfSize:11];
    title_Preferred_Language.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_Preferred_Language];
    
    title_Grade=[[UILabel alloc]initWithFrame:CGRectMake(203, 156, 48, 21)];
    title_Grade.font=[UIFont systemFontOfSize:11];
    title_Grade.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_Grade];
    
    title_School=[[UILabel alloc]initWithFrame:CGRectMake(203, 202, 54, 21)];
    title_School.font=[UIFont systemFontOfSize:11];
    title_School.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_School];
    
    title_Parent_Name=[[UILabel alloc]initWithFrame:CGRectMake(203, 274, 208, 21)];
    title_Parent_Name.font=[UIFont systemFontOfSize:11];
    title_Parent_Name.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_Parent_Name];
    
    title_Phone=[[UILabel alloc]initWithFrame:CGRectMake(203, 318, 104, 21)];
    title_Phone.font=[UIFont systemFontOfSize:11];
    title_Phone.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_Phone];
    
    title_Email=[[UILabel alloc]initWithFrame:CGRectMake(203, 361, 300, 21)];
    title_Email.font=[UIFont systemFontOfSize:11];
    title_Email.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_Email];
    
    title_Address=[[UILabel alloc]initWithFrame:CGRectMake(203, 404, 68, 21)];
    title_Address.font=[UIFont systemFontOfSize:11];
    title_Address.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_Address];
    
    title_Lead_Media=[[UILabel alloc]initWithFrame:CGRectMake(203, 468, 100, 21)];
    title_Lead_Media.font=[UIFont systemFontOfSize:11];
    title_Lead_Media.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_Lead_Media];
    
    title_Lead_Source=[[UILabel alloc]initWithFrame:CGRectMake(328, 468, 100, 21)];
    title_Lead_Source.font=[UIFont systemFontOfSize:11];
    title_Lead_Source.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_Lead_Source];
    
    title_Remarks=[[UILabel alloc]initWithFrame:CGRectMake(203, 513, 68, 21)];
    title_Remarks.font=[UIFont systemFontOfSize:11];
    title_Remarks.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_Remarks];
    
    title_Flag=[[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-172, 30, 50, 21)];
    title_Flag.font=[UIFont systemFontOfSize:13];
    title_Flag.textColor=[UIColor darkGrayColor];
    [ViewLead addSubview:title_Flag];
    
    title_Lead_ID=[[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-304, 30, 140, 21)];
    title_Lead_ID.font=[UIFont systemFontOfSize:11];
    title_Lead_ID.textColor=[UIColor blueColor];
    [ViewLead addSubview:title_Lead_ID];

    title_Promotional_Message=[[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-172, 160, 80, 40)];
    title_Promotional_Message.numberOfLines=0;
    title_Promotional_Message.font=[UIFont systemFontOfSize:13];
    title_Promotional_Message.textColor=[UIColor darkGrayColor];
    [ViewLead addSubview:title_Promotional_Message];
    
    //Text
    leadidlabel = [[UILabel alloc]initWithFrame:CGRectMake(selfViewWidth-304, 47, 124, 21)];
    leadidlabel.font=[UIFont systemFontOfSize:15];
    leadidlabel.textColor=[UIColor blackColor];
    [ViewLead addSubview:leadidlabel];
    
    leadnamelabel = [[UILabel alloc]initWithFrame:CGRectMake(199, 21, 296, 39)];
    leadnamelabel.font=[UIFont systemFontOfSize:22];
    leadnamelabel.textColor=[UIColor blackColor];
    leadnamelabel.numberOfLines=0;
    leadnamelabel.minimumScaleFactor=0.7;
    leadnamelabel.adjustsFontSizeToFitWidth=YES;
    [ViewLead addSubview:leadnamelabel];
    
    genderlabel = [[UILabel alloc]initWithFrame:CGRectMake(203, 86, 124, 21)];
    genderlabel.font=[UIFont systemFontOfSize:15];
    genderlabel.textColor=[UIColor blackColor];
    [ViewLead addSubview:genderlabel];
    
    dateofbirthlabel = [[UILabel alloc]initWithFrame:CGRectMake(203, 130, 124, 21)];
    dateofbirthlabel.font=[UIFont systemFontOfSize:15];
    dateofbirthlabel.textColor=[UIColor blackColor];
    [ViewLead addSubview:dateofbirthlabel];
    
    schoollabel = [[UILabel alloc]initWithFrame:CGRectMake(203, 223, 535, 21)];
    schoollabel.font=[UIFont systemFontOfSize:15];
    schoollabel.textColor=[UIColor blackColor];
    [ViewLead addSubview:schoollabel];
    if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
        schoollabel.hidden=YES;
    }
    
    gradelabel = [[UILabel alloc]initWithFrame:CGRectMake(203, 173, 124, 21)];
    gradelabel.font=[UIFont systemFontOfSize:15];
    gradelabel.textColor=[UIColor blackColor];
    [ViewLead addSubview:gradelabel];
    
    preferredlanguagelabel = [[UILabel alloc]initWithFrame:CGRectMake(421, 130, 158, 21)];
    preferredlanguagelabel.font=[UIFont systemFontOfSize:15];
    preferredlanguagelabel.textColor=[UIColor blackColor];
    [ViewLead addSubview:preferredlanguagelabel];
    
    agelabel = [[UILabel alloc]initWithFrame:CGRectMake(328, 130, 50, 21)];
    agelabel.font=[UIFont systemFontOfSize:15];
    agelabel.textColor=[UIColor blackColor];
    [ViewLead addSubview:agelabel];
    
    parentname = [[UILabel alloc]initWithFrame:CGRectMake(203, 292, 362, 21)];
    parentname.font=[UIFont systemFontOfSize:15];
    parentname.textColor=[UIColor blackColor];
    [ViewLead addSubview:parentname];
    
    ccimage=[[UIImageView alloc]initWithFrame:CGRectMake(203, 338, 19.5, 13)];
    ccimage.contentMode=UIViewContentModeScaleAspectFill;
    ccimage.layer.masksToBounds=YES;
    ccimage.layer.cornerRadius=3;
    [ViewLead addSubview:ccimage];
    
    countrycode = [[UILabel alloc]initWithFrame:CGRectMake(203+2+19.5, 334, 124, 21)];
    countrycode.font=[UIFont systemFontOfSize:15];
    countrycode.textColor=[UIColor darkGrayColor];
    [ViewLead addSubview:countrycode];
    
    parentcontact = [[UILabel alloc]initWithFrame:CGRectMake(203+2+19.5, 334, 124, 21)];
    parentcontact.font=[UIFont systemFontOfSize:15];
    parentcontact.textColor=[UIColor blackColor];
    [ViewLead addSubview:parentcontact];
    
    parentemail = [[UILabel alloc]initWithFrame:CGRectMake(203, 375, 550, 28)];
    parentemail.font=[UIFont systemFontOfSize:15];
    parentemail.numberOfLines=0;
    parentemail.minimumScaleFactor=0.7;
    parentemail.adjustsFontSizeToFitWidth=YES;
    parentemail.textColor=[UIColor blackColor];
    [ViewLead addSubview:parentemail];
    
    parentaddress = [[UILabel alloc]initWithFrame:CGRectMake(203, 423, 550, 40)];
    parentaddress.font=[UIFont systemFontOfSize:15];
    parentaddress.textColor=[UIColor blackColor];
    parentaddress.numberOfLines=0;
    parentaddress.minimumScaleFactor=0.7;
    parentaddress.adjustsFontSizeToFitWidth=YES;
    [ViewLead addSubview:parentaddress];
    
    remarksscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(203, 532, selfViewWidth-251, ViewLead.frame.size.height-532-70-5)];
    [ViewLead addSubview:remarksscrollview];
    
    remarks = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, selfViewWidth-251, 100)];
    remarks.font=[UIFont systemFontOfSize:15];
    remarks.textColor=[UIColor blackColor];
    remarks.minimumScaleFactor=0.7;
    remarks.adjustsFontSizeToFitWidth=YES;
    remarks.numberOfLines=0;
    [remarksscrollview addSubview:remarks];
    
    medialabel = [[UILabel alloc]initWithFrame:CGRectMake(203, 484, 110, 21)];
    medialabel.font=[UIFont systemFontOfSize:15];
    medialabel.textColor=[UIColor blackColor];
    medialabel.minimumScaleFactor=0.75;
    medialabel.adjustsFontSizeToFitWidth=YES;
    [ViewLead addSubview:medialabel];
    if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
        medialabel.hidden=YES;
    }
    
    sourcelabel = [[UILabel alloc]initWithFrame:CGRectMake(328, 484, 330, 21)];
    sourcelabel.font=[UIFont systemFontOfSize:15];
    sourcelabel.textColor=[UIColor blackColor];
    [ViewLead addSubview:sourcelabel];
    if ([((CenterSettings *)[MyClass returnCenterSettingswithCenterkey:globalvariables.centerrecord.centerkey]).fcbrand isEqualToString:@"school"]) {
        sourcelabel.hidden=YES;
    }
    
    //Image
    viewleadimage=[[UIImageView alloc]initWithFrame:CGRectMake(15, 30, 154, 180)];
    viewleadimage.backgroundColor=[UIColor whiteColor];
    viewleadimage.contentMode=UIViewContentModeScaleToFill;
    viewleadimage.layer.cornerRadius=10;
    viewleadimage.layer.masksToBounds=YES;
    viewleadimage.userInteractionEnabled=YES;
    [ViewLead addSubview:viewleadimage];

    
    //Line Separator
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(203, 258, selfViewWidth-244, 1)];
    separator.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [ViewLead addSubview:separator];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(203, 457, selfViewWidth-244, 1)];
    separator.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [ViewLead addSubview:separator];
    
    separator=[[UIView alloc]initWithFrame:CGRectMake(203, ViewLead.frame.size.height-70, selfViewWidth-244, 1)];
    separator.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [ViewLead addSubview:separator];
    
    
    swflag = [[UISwitch alloc] init];
    swflag.onTintColor=themecolor;
    swflag.frame=CGRectMake(selfViewWidth-85, 26, 51, 31);
    swflag.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [swflag addTarget:self action:@selector(flagLead:) forControlEvents:UIControlEventValueChanged];
    [ViewLead addSubview:swflag];
    
    swpromotion = [[UISwitch alloc] init];
    swpromotion.onTintColor=themecolor;
    swpromotion.frame=CGRectMake(selfViewWidth-85, 166, 51, 31);
    swpromotion.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
    [swpromotion addTarget:self action:@selector(promotionLead:) forControlEvents:UIControlEventValueChanged];
    [ViewLead addSubview:swpromotion];
    
    leadstatusbutton=[[UIButton alloc]initWithFrame:CGRectMake(15, 220, 154, 29)];
    [leadstatusbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leadstatusbutton.backgroundColor=themecolor;
    leadstatusbutton.titleLabel.font=[UIFont systemFontOfSize:14];
    leadstatusbutton.layer.cornerRadius=7;
    [leadstatusbutton addTarget: self action:@selector(selectleadstatus:) forControlEvents: UIControlEventTouchUpInside];
    [ViewLead addSubview:leadstatusbutton];
    
    LeadStatusArray=[[NSArray alloc]initWithObjects:@"New",@"Pending Assessment",@"Considering",@"Waiting",@"Give Up",@"Black List",@"Enroll",nil];

    [scsender setTitle:[MyClass returntitlewithtitle:@"Center"] forSegmentAtIndex:0];
    [scsender setTitle:[MyClass returntitlewithtitle:@"Self"] forSegmentAtIndex:1];

    
    if ([DetailsViewMessageTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        DetailsViewMessageTable.cellLayoutMarginsFollowReadableWidth=NO;
    }
    [DetailsViewMessageTable setSeparatorColor:[UIColor clearColor]];

    messagesearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];

    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];

    [tablerefresh addTarget:self action:@selector(refreshdetailsviewmessagetable) forControlEvents:UIControlEventValueChanged];
    [DetailsViewMessageTable addSubview:tablerefresh];

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
    

    [CallLogCalledBySelectionButton setTitle:[MyClass returntitlewithtitle:@"All Callers"] forState:UIControlStateNormal];

    [CallLogView addSubview:CallLogCalledBySelectionButton];
    [self drawpointerwithoption:@"closed" imageview:calllog_callerarrow];

    DTRecordView.backgroundColor=[UIColor systemGroupedBackgroundColor];

    DetailsViewDTTable.sectionHeaderHeight=0;
    if ([DetailsViewDTTable respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
        DetailsViewDTTable.cellLayoutMarginsFollowReadableWidth=NO;
    }

    dtsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    
    

    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    //tablerefresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [tablerefresh addTarget:self action:@selector(refreshdetailsviewdttable) forControlEvents:UIControlEventValueChanged];
    [DetailsViewDTTable addSubview:tablerefresh];
    [DTSubjectSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Classes"] forState:UIControlStateNormal];
    [self drawpointerwithoption:@"closed" imageview:dt_coursearrow];
    
    [DTTypeSelectionButton setTitle:[MyClass returntitlewithtitle:@"All Types"] forState:UIControlStateNormal];
    [self drawpointerwithoption:@"closed" imageview:dt_typearrow];
    
    DTTypeArray=[[NSMutableArray alloc]initWithObjects:@"All Types",@"Assessment",@"Trial", nil];
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPhotoDetected:)];
    [tapped setNumberOfTapsRequired:1];
    [viewleadimage addGestureRecognizer:tapped];

    [self loadImageFullScreenView];

}

-(void) drawpointerwithoption:(NSString *)option imageview:(UIImageView *)imageview
{
    if ([option isEqualToString:@"open"]) {
        [imageview setImage:[UIImage imageNamed:@"uparrow_white.png"]];
    }else{
        [imageview setImage:[UIImage imageNamed:@"downarrow_white.png"]];
    }
}

-(void) loadImageFullScreenView
{
    photofullscreenview=[[UIView alloc]initWithFrame:CGRectMake(0, 64, selfViewWidth, self.view.bounds.size.height-64)];
    photofullscreenview.backgroundColor=[UIColor systemGroupedBackgroundColor];
    [MasterView addSubview:photofullscreenview];
    
    fullscreen_closebutton=[[UIButton alloc]initWithFrame:CGRectMake(20, 20, 25, 25)];
    [fullscreen_closebutton setImage:[UIImage imageNamed:@"closescreengray_icon.png"] forState:UIControlStateNormal];
    [fullscreen_closebutton addTarget:self action:@selector(closefullscreen) forControlEvents:UIControlEventTouchUpInside];
    [photofullscreenview addSubview:fullscreen_closebutton];
    
    UIView *separator=[[UIView alloc]initWithFrame:CGRectMake(10, photofullscreenview.frame.size.height-40-([leadAction isEqualToString:@"PopoverLead"]?15*0:0), photofullscreenview.frame.size.width-20, 0.5)];
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
    
    
    fullscreen_studentname=[[UILabel alloc]initWithFrame:CGRectMake(10, photofullscreenview.frame.size.height-40-([leadAction isEqualToString:@"PopoverLead"]?15*0:0), photofullscreenview.frame.size.width-20, 30)];
    fullscreen_studentname.numberOfLines=0;
    fullscreen_studentname.minimumScaleFactor=0.7;
    fullscreen_studentname.adjustsFontSizeToFitWidth=YES;
    fullscreen_studentname.textColor=[UIColor grayColor];
    fullscreen_studentname.font=[UIFont systemFontOfSize:13];
    [photofullscreenview addSubview:fullscreen_studentname];
    photofullscreenview.hidden=YES;
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
    self.historyButtonFollowsCorner = NO;
    
    [recognizer setTranslation:CGPointZero inView:button];
}

-(void) closeviewhistorybuttonpressed
{
    //systemMessageLabel.frame=CGRectMake(0, 0, selfViewWidth, self.view.frame.size.height-64);
    [self showviewhistory:NO];
}

-(void) showviewhistory:(BOOL)show
{
    ViewHistoryTableMasterView.hidden=!show;
    if (show) {
        //systemMessageLabel.frame=CGRectMake(0, 0, selfViewWidth-234, self.view.frame.size.height-64);
        systemMessageTrailingConstraint.constant=234;
        viewhistoryarray=[MyClass returnViewHistoryWithType:@"lead"];
        [ViewHistoryTable reloadData];
    }else{
        systemMessageTrailingConstraint.constant=0;
        //systemMessageLabel.frame=CGRectMake(0, 0, selfViewWidth, self.view.frame.size.height-64);
    }
}




-(void) highlighttableoptionbuttonwithbuttontag:(long)buttontag
{
    menulabel_lead.textColor=(buttontag==menulabel_lead.tag)?[UIColor yellowColor]:[UIColor whiteColor];
    menulabel_messages.textColor=(buttontag==menulabel_messages.tag)?[UIColor yellowColor]:[UIColor whiteColor];
    menulabel_calllog.textColor=(buttontag==menulabel_calllog.tag)?[UIColor yellowColor]:[UIColor whiteColor];
    menulabel_trial.textColor=(buttontag==menulabel_trial.tag)?[UIColor yellowColor]:[UIColor whiteColor];
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
        leadAction=nil;
        photofullscreenview.hidden=YES;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,product,staff,classroom,marketing,centersettings,userroleandprivilege,lead,student,arcode" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
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
                
                
                InstructorArray=[MyClass retrieveInstructorListwithvalid:@"All" flushcachedata:NO];
                //viewhistoryarray=[MyClass returnViewHistoryWithType:@"lead"];
                //[ViewHistoryTable reloadData];
                
                makeupdtattendancebuttonarray=[[NSMutableArray alloc]initWithArray:[MyClass returnmakeupattendancebuttonarray]];
                
                if (!leadAction) {
                    ViewLead.hidden=YES;
                    TopMenuView.hidden=YES;
                    DTRecordView.hidden=YES;
                    CallLogView.hidden=YES;
                    MessageView.hidden=YES;
                    systemMessageView.hidden=NO;
                    [self showviewhistory:YES];
                    //viewhistoryarray=[MyClass returnViewHistoryWithType:@"lead"];
                    //[ViewHistoryTable reloadData];
                    
                }else if ([leadAction isEqualToString:@"ViewLead"]) {
                    ViewLead.hidden=NO;
                    TopMenuView.hidden=NO;
                    DTRecordView.hidden=YES;
                    CallLogView.hidden=YES;
                    MessageView.hidden=YES;
                    systemMessageView.hidden=YES;
                    
                }else if ([leadAction isEqualToString:@"Redirect"]) {
                    /*ViewLead.hidden=NO;
                    TopMenuView.hidden=NO;
                    DTRecordView.hidden=YES;
                    CallLogView.hidden=YES;
                    MessageView.hidden=YES;*/
                    systemMessageView.hidden=YES;
                    
                }else if ([leadAction isEqualToString:@"PopoverLead"]) {
                    if(selectedDTkey && ![selectedDTkey isEqualToString:@""]){
                        [MyClass insertViewHistoryWithType:@"lead" Typekey:DetailsViewLead.leadkey Name:@"" IDNumber:@"" Gender:@""];
                        viewhistorybutton.hidden=YES;
                        ViewLead.hidden=YES;
                        TopMenuView.hidden=NO;
                        DTRecordView.hidden=NO;
                        CallLogView.hidden=YES;
                        MessageView.hidden=YES;
                        systemMessageLabel.text=@"";
                        systemMessageView.hidden=YES;
                        lastviewindex=1;
                        [self highlighttableoptionbuttonwithbuttontag:3];
                        
                        dtsubjectselected=@"All";
                        
                        dtsubjectselected=@"All";
                        [self retrieveDTWithSubject:@"All" leadkey:DetailsViewLead.leadkey classtype:@"All"];
                        
                        
                    }else{
                        [MyClass insertViewHistoryWithType:@"lead" Typekey:DetailsViewLead.leadkey Name:@"" IDNumber:@"" Gender:@""];
                        viewhistorybutton.hidden=YES;
                        ViewLead.hidden=YES;
                        TopMenuView.hidden=NO;
                        DTRecordView.hidden=NO;
                        CallLogView.hidden=YES;
                        MessageView.hidden=YES;
                        systemMessageLabel.text=@"";
                        systemMessageView.hidden=YES;
                        lastviewindex=1;
                        [self highlighttableoptionbuttonwithbuttontag:lastviewindex];
                        
                        dtsubjectselected=@"All";
                        
                        dtsubjectselected=@"All";
                        [self retrieveDTWithSubject:@"All" leadkey:DetailsViewLead.leadkey classtype:@"All"];
                    }
                }else if ([leadAction isEqualToString:@"EditLead"]){
                    ViewLead.hidden=NO;
                    TopMenuView.hidden=NO;
                    //EnrollmentClassMenuView.hidden=YES;
                    DTRecordView.hidden=YES;
                    CallLogView.hidden=YES;
                    MessageView.hidden=YES;
                    systemMessageView.hidden=YES;
                }else if([leadAction isEqualToString:@"AddNewLead"]){
                    [self.delegate enableAddLeadButton];
                }
                

                if (!firstload) {
                    [self.delegate gobackLeadCategory];
                    [MyClass loadingindicatorwithoption:@"stop" color:nil];
                }
            }
                });
            
        }];
        
        
        
        
    });
    

}

-(void) tapPhotoDetected:(UITapGestureRecognizer *)gesture
{
    [self showFullScreenPhotoWithImage:viewleadimage.image mode:@"lead"];
    /*
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
    
    
    fullscreen_studentname.text=[MyClass returnLeadnameWithLeadkey:DetailsViewLead.leadkey option:@"full"];
    [fullscreen_imageview setImage:viewleadimage.image];
    
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
    */
}

-(void) closefullscreen
{
    photofullscreenview.hidden=YES;
    viewhistorybutton.hidden=[leadAction isEqualToString:@"PopoverLead"]?YES:NO;
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
-(void) showleadlist:(NSString *)leadkey
{
    [self.delegate gotoleadprofile:leadkey];
}*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==sortingtable){
        return [MyClass returntitlewithtitle:@"Sorting Order"];
    }else{
        return nil;
    }
}



-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width
{
    if (self.view.window) {
        mainWindow = self.view.window;
    }
    if (!mainWindow) {
        mainWindow = [self detailsSceneWindow];
    }
    if (!mainWindow) {
        return;
    }
    if (ailoadindicator.hidden && sidewindowview.frame.origin.x==mainWindow.bounds.size.width) {
        return;
    }

    if (mainWindow.bounds.size.width-width == sidewindowview.frame.origin.x && fabs(sidewindowview.frame.size.height - mainWindow.bounds.size.height) < 0.5) {
        return;
    }

    if (width>0 && sidewindowview.frame.origin.x== mainWindow.bounds.size.width) {
        [MyClass playsoundwithoption:@"open"];
    }

    if (width > 0) {
        self.sideWindowRequestedWidth = width;
    }
    self.sideWindowOpen = width > 0;
    self.sideWindowAnimating = YES;
    [UIView animateWithDuration:0.25f animations:^{
        sidewindowview.frame=CGRectMake(mainWindow.bounds.size.width-width, 0, width, mainWindow.bounds.size.height);
        for (UIView *subview in sidewindowview.subviews) {
            if (subview == ailoadindicator) {
                continue;
            }
            subview.frame = sidewindowview.bounds;
        }
        if (width==0 && sidewindowview.frame.origin.x< mainWindow.bounds.size.width) {
            [MyClass playsoundwithoption:@"close"];
        }
    } completion:^(BOOL finished){
        self.sideWindowAnimating = NO;
        if (width==0) {
            self.sideWindowOpen = NO;
            sidewindowview.hidden = YES;
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
        [self layoutSideWindowForCurrentSize];
    }];
    sidewindowviewclosebutton.hidden=width==0?YES:NO;
    
}

-(void) closesidewindow
{
    self.sideWindowOpen = NO;
    self.sideWindowRequestedWidth = 0;
    [self adjustpresentingviewwidthwithwidth:0];
    if (lastviewindex==3) {
        [DetailsViewDTTable deselectRowAtIndexPath:[DetailsViewDTTable indexPathForSelectedRow] animated:YES];
    }else if (lastviewindex==2){
        [CallLogTable deselectRowAtIndexPath:[CallLogTable indexPathForSelectedRow] animated: YES];
    }else if (lastviewindex==1){
        [DetailsViewMessageTable deselectRowAtIndexPath:[DetailsViewMessageTable indexPathForSelectedRow] animated: YES];
    }
    
    /*
    if (lastviewindex==2){
        [DetailsViewMessageTable deselectRowAtIndexPath:[DetailsViewMessageTable indexPathForSelectedRow] animated: YES];
    }else if (lastviewindex==1){
        if(![self retrieveLead:DetailsViewLead.leadkey]){
            return;
        }
        if(![self retrieveDTWithSubject:dtsubjectselected leadkey:DetailsViewLead.leadkey classtype:dttypeselected]){
            return;
        }
    }*/
    
}

-(void) startsidewindowanimationwithwidth:(float)width
{
    if (!mainWindow) {
        mainWindow = [self detailsSceneWindow];
    }
    self.sideWindowRequestedWidth = width;
    self.sideWindowOpen = width > 0;
    sidewindowview.hidden = width <= 0;
    CGFloat panelWidth = [self clampedSideWindowWidth:width];
    ailoadindicator.hidden=NO;
    ailoadindicator.center = CGPointMake(panelWidth/2-7.5,mainWindow.bounds.size.height/2-7.5);
    [ailoadindicator startAnimating];
    [self adjustpresentingviewwidthwithwidth:panelWidth];
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
    [self adjustpresentingviewwidthwithwidth:380];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        StaffPopoverViewController *staffpopover = (StaffPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"StaffPopoverViewController"];
        staffpopover.StaffObject=object;
        staffpopover.readonly=YES;
        staffpopover.StaffTableMode=@"View";
        
        [self->sidewindowview addSubview:staffpopover.view];
        [self placeViewInSideWindow:staffpopover.view];
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
            [self.delegate donotrunviewdidappearinleadinformation];
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
    
    if ([mode isEqualToString:@"lead"]) {
        fullscreen_studentname.hidden=NO;
        shareimageview.hidden=YES;
        shareimagebutton.hidden=YES;
        fullscreen_studentname.text=[MyClass returnLeadnameWithLeadkey:DetailsViewLead.leadkey option:@"full"];
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
    
    [self presentViewController:activityVC animated:YES completion:nil];
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
        if (lastviewindex==2){
            [self sortcallloglist];
        }else if (lastviewindex==3){
            [self sortdtlist];
        }
    }
}


-(void) gotoLeadProfilewithLeadkey:(NSString *)leadkey submenu:(NSInteger)submenu classkeys:(ClassKeys *)classkeys
{
    [self retrieveLead:leadkey];
    [self.delegate gotoLeadProfilewithLeadkey:leadkey submenu:submenu classkeys:classkeys];
}

-(NSString *) returnrecipientnamewithmessagerecord:(InboxMessageRecord *)messageobject
{
    return messageobject.recipient;
}

-(void) tapMessagePhotoDetected:(UIButton *)sender
{
    runviewdidappear=FALSE;
    [self.delegate donotrunviewdidappearinleadinformation];
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
            [MyClass loadingindicatorwithoption:@"start" color:@"white"];
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
    if ([obj.channel isEqualToString:@"AS"]) {
        actionarray=[[NSMutableArray alloc]initWithObjects:@"Resend",@"Read Status",@"Delete", nil];
    }else if ([obj.channel isEqualToString:@"A"]) {
        actionarray=[[NSMutableArray alloc]initWithObjects:@"Resend",@"Read Status",@"Delete", nil];
    }else if ([obj.channel isEqualToString:@"S"]) {
        actionarray=[[NSMutableArray alloc]initWithObjects:@"Resend",@"Read Status",@"Delete", nil];
    }else if ([obj.channel isEqualToString:@"E"]) {
        actionarray=[[NSMutableArray alloc]initWithObjects:@"Resend",@"Read Status",@"Delete", nil];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"InstantMessageAction" DataIndex:button.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(180, 40*actionarray.count) View:self Button:button ItemsArray:actionarray Title:nil];
    
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

    channelarray=[[NSMutableArray alloc]initWithObjects:@"S",@"E", nil];

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
    InboxMessageRecord *messageobject=[[InboxMessageRecord alloc]initInboxMessageRecordwithInboxMessagekey:nil Messagetype:workingMessage.messagetype MessageEnglish:workingMessage.messageenglish MessageChinese:workingMessage.messagechinese MessageCreateTime:nil MessageStartTime:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"] AutoMessageFlag:nil Channel:workingMessage.channel ReciptientType:workingMessage.recipienttype Status:workingMessage.status Sender:workingMessage.sender AssociateID:nil Readtime:@"" photoarray:workingMessage.photoarray recipient:DetailsViewLead.leadkey outboxmessagekey:nil type:@"sent" readstatus:@"SENDING" readstatusdetailsarray:nil replytomessagekey:@"0"];
    [messageArray insertObject:messageobject atIndex:0];
    [self returnfilteredMessageArray];
    instantPhotoCollectionView.hidden=YES;
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
    

        workingMessage.recipienttype=@"Lead";
        values=[NSArray arrayWithObjects:@"lead",DetailsViewLead.leadkey, nil];
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
                //NSData *imageData=[[NSData alloc]initWithContentsOfURL:object.internalurl];
                NSData *imageData=[MyClass returnWXCompressDataWithURL:object.internalurl];
                //UIImage *uploadimage=object.imageview.image;
                //NSDictionary *imagedict=[MyClass returnCompressedImageDictWithImage:uploadimage];
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

-(void) takephotobuttonpressed
{
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addclassphotofromsource:@"camera"];
}

-(void) photolibrarybuttonpressed
{
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    [self addclassphotofromsource:@"library"];
}

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
                //imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
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
    [self.delegate donotrunviewdidappearinleadinformation];
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
    //imagepicker.view.hidden=YES;
    runviewdidappear=FALSE;
    [self.delegate donotrunviewdidappearinleadinformation];
    [[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
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
    [self.delegate donotrunviewdidappearinleadinformation];
    [fullscreenphotoviewcontroller dismissViewControllerAnimated:YES completion:nil];
}

-(void) deleteImageWithIndex:(NSInteger)index
{
    runviewdidappear=FALSE;
    [self.delegate donotrunviewdidappearinleadinformation];
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
    contactlabel.text=[MyClass returnLeadnameWithLeadkey:DetailsViewLead.leadkey option:@"full"];

    Lead *lead=[MyClass returnleadwithleadkey:DetailsViewLead.leadkey];
    [MyClass downloadImageWithImageview:contactimage gender:lead.gender type:@"lead" typekey:DetailsViewLead.leadkey image:lead.image async:YES];

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
        }else if ([result isEqualToString:@"Resend"]){
            [self reSendInstantMessage:dataindex];
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
        
    }
}

- (void)pickerBottomButtonPressedWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex BottomMode:(NSString *)bottommode SelectedItems:(NSMutableArray *)selecteditems{
    
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
        
        [self->sidewindowview addSubview:pickerviewcontroller.view];
        [self placeViewInSideWindow:pickerviewcontroller.view];
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
//    forwardMessageButton.enabled=selectedinboxmessages.count>0;
    selectedTitle.text=[MyClass returnreplacedtitlewithtitle:@"%@1 Selected" replacementarray:@[[@(selectedinboxmessages.count) stringValue]]];
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
            
            /*
            dictionary=[MyClass addchecksumparameterwithdictionary:dictionary];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            
            [manager POST:globalvariables.generalphpfullpath parameters:dictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
            } progress:nil success:^(NSURLSessionTask *task, id responseObject) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self retrieveMessageRecord];
                    //[self retrievemessagelistwithmessagecontact:selectedmessagecontact];
                });
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                [MyClass showconnectionlostdialogbox];
            }];*/
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
    //return YES;
    
    //NSLog(@"Audio recording started");
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

-(void) dataChanged
{
    DataChanged=TRUE;
}

@end
