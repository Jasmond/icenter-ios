//
//  MessageViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 8/10/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import "MessageViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MainMenuViewController.h"
#import "MyClass.h"
#import "MainViewController.h"
//#import "AFNetworking.h"
//#import <SDWebImage/UIImageView+WebCache.h>
#import "SDWebImage.h"
#import "SceneDelegate.h"

@import Photos;

@import BSImagePicker;


@interface MessageViewController ()
{
    NSMutableDictionary *messageTrailingConstants;
    NSMutableDictionary *messageBottomConstants;
    CGRect keyboardFrameInScreen;
    BOOL sideWindowAdjusting;
}
@end

#define photosize 175
#define maxphotoheight self.view.bounds.size.height*0.5

//#define messagecontentwidth 750

@implementation MessageViewController
@synthesize myPopoverController;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    
    [self loadtitle];
    
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
    
    switchcenterbutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, headertitleview.frame.size.width,68)];
    switchcenterbutton.layer.cornerRadius=5;
    switchcenterbutton.layer.masksToBounds=YES;
    if ([MyClass isMultiCenterUser]) {
        [switchcenterbutton addTarget:self action:@selector(switchcenterbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
    }
    [headertitleview addSubview:switchcenterbutton];
    
    switchcenterviewcontroller = (SwitchCenterViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"SwitchCenterViewController"];
    switchcenterviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    switchcenterviewcontroller.delegate=self;
    
    selectedreceipienttype=@"All";
    selectedmessagetype=@"All";
    selectedstatus=@"All";
    
    OutboxMessageTable.transform = CGAffineTransformMakeScale(1, -1);
    contentTable.transform = CGAffineTransformMakeScale(1, -1);
    
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
    sidewindowview.clipsToBounds=YES;
    sidewindowview.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
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
    
    categoryarray=[[NSArray alloc]initWithObjects:
                   [[NSArray alloc]initWithObjects: @"Recipient Type",
                    [[NSArray alloc]initWithObjects:@"All", @"Student",@"Lead",@"Staff",nil],
                    nil],
                   
                   [[NSArray alloc]initWithObjects: @"Message Type",
                    [[NSArray alloc]initWithObjects:@"All", @"Important",@"General",@"Promotional",@"Teacher Note",@"Attendance",nil],
                    nil],
                   
                   [[NSArray alloc]initWithObjects: @"Status",
                    [[NSArray alloc]initWithObjects:@"All", @"Sent",@"Scheduled",@"Draft",nil],
                    nil],
                   nil];
    
    workingMessage=[[OutboxMessageRecord alloc]init];
    workingMessage.messagetype=@"General";
    workingMessage.sender=globalvariables.username;
    workingMessage.channel=@"A";
    workingMessage.hotnews=NO;
    workingMessage.hn_expiry_date=@"";
    workingMessage.messageenglish=@"";
    workingMessage.messagechinese=@"";
    workingMessage .status=@"";
    workingMessage.photoarray=[[NSMutableArray alloc]init];
    
    textinputbox.hidden=YES;
    instantmessagetopbox.hidden=YES;
    OutboxMessageTable.hidden=YES;
    
    filteredOutboxMessageArray=[[NSMutableArray alloc]init];
    globalvariables.filteredMessageArray=[[NSMutableArray alloc]init];
    FilteredMessageContactArray=[[NSMutableArray alloc]init];
    //    readmessagearray=[[NSMutableArray alloc]init];
    replyToMessageView.hidden=YES;
    sendinstantmessagebutton.enabled=[self enableSendButton];
    
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
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshcatgorytable) forControlEvents:UIControlEventValueChanged];
    [contactlisttable addSubview:tablerefresh];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor lightGrayColor];
    [tablerefresh addTarget:self action:@selector(refreshoutboxmessagetable) forControlEvents:UIControlEventValueChanged];
    [OutboxMessageTable addSubview:tablerefresh];
    
    [self refreshlanguage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checktoreloadapp) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    runviewdidappear=TRUE;
    
    showsystemmessage=[[MyClass getlocaldbwithparameter:@"showsystemmessage"] isEqualToString:@"Y"];
    [showsystemmessagebutton setTitle:[MyClass returntitlewithtitle:showsystemmessage?@"System message: On":@"System message: Off"] forState:UIControlStateNormal];
    
    [self startAudioSession];
    
    
    UIPanGestureRecognizer *audioPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureDetected:)];
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
    
    allstaffgrouparray=[MyClass returnStaffGroupArrayIncludeAll:YES];
    
    [self refreshMessageContact];
    recordAudioButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendmessage;
}

- (void)panGestureDetected:(UIPanGestureRecognizer *)recognizer
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

- (void)keyboardWillHide: (NSNotification *) notif{
    
    keyboardshow=FALSE;
    keyboardFrameInScreen = CGRectZero;
    keyboardheight=0;
    [self adjusttablesize];
    [self paddingtableifneeded];
}

- (void)keyboardDidHide: (NSNotification *) notif{
    
    keyboardshow=FALSE;
    keyboardFrameInScreen = CGRectZero;
    keyboardheight=0;
    [self adjusttablesize];
}

- (void)keyboardDidChangeFrame:(NSNotification *)notif
{
    keyboardFrameInScreen = [[[notif userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self adjusttablesize];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    keyboardFrameInScreen = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self adjusttablesize];
    if (scmessageview.selectedSegmentIndex==0) {
        [self paddingtableifneeded];
    }
}

-(void) refreshcatgorytable
{
    for (id object in [contactlisttable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadmessageview];
    });
}

-(void) refreshoutboxmessagetable
{
    for (id object in [OutboxMessageTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadmessageview];
    });
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

- (CGFloat)visibleMessageHeight
{
    CGFloat height = self.view.bounds.size.height;
    UIWindow *window = self.view.window;
    if (!window || height < 1) {
        return height;
    }
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGFloat visibleMaxY = MIN(CGRectGetMaxY(frameInWindow), CGRectGetMaxY(window.bounds));
    return MAX(MIN(visibleMaxY - CGRectGetMinY(frameInWindow), height), 0);
}

- (CGFloat)composerBottomInset
{
    CGFloat overflow = MAX(self.view.bounds.size.height - [self visibleMessageHeight], 0);
    CGFloat overlap = 0;
    UIWindow *window = self.view.window;
    if (window && !CGRectIsEmpty(keyboardFrameInScreen)) {
        CGRect keyboardInWindow = [window convertRect:keyboardFrameInScreen fromWindow:nil];
        CGRect overlapRect = CGRectIntersection(keyboardInWindow, [self visibleWindowFrame]);
        if (!CGRectIsNull(overlapRect)) {
            overlap = overlapRect.size.height;
        }
    }
    return overlap + overflow;
}

-(void) adjusttablesize
{
    messageinputtextbottomconstraint.constant=[self composerBottomInset];
}


-(void) checktoreloadapp
{
    [self refreshMessageContact];
    [self returnfilteredMessageArray];
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {
        if ([myPopoverController presentingViewController].isBeingPresented) {
            [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==switchcenterviewcontroller) {
            [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.mainSlideMenu closeLeftMenu];
        }
        [self closesidewindow];
        globalvariables.appbecomeactiveaction=@"";
        globalvariables.leftmenuindex=@"0";
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [MyClass reloadApp];
    }else if ([globalvariables.appbecomeactiveaction isEqualToString:@"refresh"]){
        
        globalvariables.appbecomeactiveaction=@"";
        
        
        if ([myPopoverController presentingViewController].isBeingPresented) {
            [[myPopoverController presentingViewController] dismissViewControllerAnimated:NO completion:nil];
        }else if (self.presentedViewController==switchcenterviewcontroller) {
            [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.mainSlideMenu closeLeftMenu];
        }
        [self closesidewindow];
        [self reloadPageWithFirstLoad:NO];
        //}
        //}];
        
    }/*else{
      [self refreshMessageContact];
      [self returnfilteredMessageArray];
      }*/
}

-(void) refreshlanguage
{
    headercentername.text=[MyClass returnWindowTitle];
    headertitlename.text=[MyClass returntitlewithtitle:@"Message Center"];
    messagesearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    contactlistsearchbar.placeholder=[MyClass returntitlewithtitle:@"Search"];
    [scsender setTitle:[MyClass returntitlewithtitle:@"Center"] forSegmentAtIndex:0];
    [scsender setTitle:[MyClass returntitlewithtitle:@"Self"] forSegmentAtIndex:1];
    [scmessageview setTitle:[MyClass returntitlewithtitle:@"Individual"] forSegmentAtIndex:0];
    [scmessageview setTitle:[MyClass returntitlewithtitle:@"Broadcast"] forSegmentAtIndex:1];
    slideToCancelTitle.text=[MyClass returntitlewithtitle:@"Release here to cancel"];
    scsender.hidden=!((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendmessagecenterrole;
    [self updateheadercentertitle];
}

- (CGFloat)visibleMessageWidth
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

- (void)layoutMessageForCurrentSize
{
    CGFloat width = [self visibleMessageWidth];
    if (width < 1) {
        return;
    }
    if (!messageTrailingConstants) {
        messageTrailingConstants = [NSMutableDictionary dictionary];
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            if (constraint.firstItem == self.view && constraint.firstAttribute == NSLayoutAttributeTrailing && constraint.secondAttribute == NSLayoutAttributeTrailing) {
                messageTrailingConstants[[NSValue valueWithNonretainedObject:constraint]] = @(constraint.constant);
            }
        }
    }
    CGFloat overflow = MAX(self.view.bounds.size.width - width, 0);
    CGFloat bottomInset = [self composerBottomInset];
    if (!messageBottomConstants) {
        messageBottomConstants = [NSMutableDictionary dictionary];
        for (NSLayoutConstraint *constraint in self.view.constraints) {
            BOOL pinsToBottom = constraint.firstItem == self.view && constraint.secondAttribute == NSLayoutAttributeBottom && (constraint.firstAttribute == NSLayoutAttributeBottom || constraint.firstAttribute == NSLayoutAttributeBottomMargin);
            if (pinsToBottom && constraint != messageinputtextbottomconstraint) {
                messageBottomConstants[[NSValue valueWithNonretainedObject:constraint]] = @(constraint.constant);
            }
        }
    }
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if (constraint.firstItem == self.view && constraint.firstAttribute == NSLayoutAttributeTrailing && constraint.secondAttribute == NSLayoutAttributeTrailing) {
            NSNumber *original = messageTrailingConstants[[NSValue valueWithNonretainedObject:constraint]];
            CGFloat target = (original ? original.doubleValue : 0) + overflow;
            if (fabs(constraint.constant - target) > 0.5) {
                constraint.constant = target;
            }
        }
        NSNumber *bottomOriginal = messageBottomConstants[[NSValue valueWithNonretainedObject:constraint]];
        if (bottomOriginal) {
            CGFloat verticalOverflow = MAX(self.view.bounds.size.height - [self visibleMessageHeight], 0);
            CGFloat target = bottomOriginal.doubleValue + verticalOverflow;
            if (fabs(constraint.constant - target) > 0.5) {
                constraint.constant = target;
            }
        }
    }
    if (messageinputtextbottomconstraint && fabs(messageinputtextbottomconstraint.constant - bottomInset) > 0.5) {
        messageinputtextbottomconstraint.constant = bottomInset;
    }
    CGFloat titleWidth = MAX(width - 140.0, 0);
    if (headertitleview && fabs(headertitleview.frame.size.width - titleWidth) > 0.5) {
        headertitleview.frame = CGRectMake(70, 0, titleWidth, 68);
        headertitlename.frame = CGRectMake(0, 25, titleWidth, 20);
        switchcenterbutton.frame = CGRectMake(0, 0, titleWidth, 68);
        [self updateheadercentertitle];
    }
}

- (CGRect)visibleWindowFrame
{
    UIWindow *window = self.view.window ? self.view.window : mainWindow;
    if (!window) {
        return CGRectZero;
    }
    if (!self.isViewLoaded || !self.view.window) {
        return window.bounds;
    }
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGRect visible = CGRectIntersection(frameInWindow, window.bounds);
    if (CGRectIsNull(visible) || visible.size.width < 1 || visible.size.height < 1) {
        return window.bounds;
    }
    return visible;
}

- (void)pinOpenSideWindowToVisibleEdge
{
    if (sideWindowAdjusting || !sidewindowview || sidewindowview.hidden || sidewindowview.frame.size.width < 1.0) {
        return;
    }
    CGRect visible = [self visibleWindowFrame];
    if (visible.size.width < 1.0 || visible.size.height < 1.0) {
        return;
    }
    CGFloat panelWidth = MIN(sidewindowview.frame.size.width, visible.size.width);
    CGRect target = CGRectMake(CGRectGetMaxX(visible) - panelWidth, visible.origin.y, panelWidth, visible.size.height);
    sidewindowview.frame = target;
    if (sidewindowviewclosebutton && !sidewindowviewclosebutton.hidden) {
        sidewindowviewclosebutton.frame = visible;
    }
    for (UIView *child in sidewindowview.subviews) {
        if ([child isKindOfClass:[UIActivityIndicatorView class]]) {
            continue;
        }
        child.frame = sidewindowview.bounds;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self layoutMessageForCurrentSize];
    [self pinOpenSideWindowToVisibleEdge];
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
    if (runviewdidappear) {
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
}

-(void) stoploadingindicator
{
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

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


- (IBAction)menubutton:(id)sender {
    [self stopAudioPlaying];
    [self.mainSlideMenu openLeftMenu];
}



- (IBAction)addnewmessage:(UIButton *)sender {
    
    [self stopAudioPlaying];
    [self closefullscreen];
    
    if (scmessageview.selectedSegmentIndex==1) {
        [self startsidewindowanimationwithwidth:320];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MessagePopoverViewController *messagepopover = (MessagePopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MessagePopoverViewController"];
            messagepopover.delegate=self;
            messagepopover.MessageTableMode=@"Add";
            messagepopover.CallingSource=@"MessageView";
            messagepopover.allleadarray=allleadarray;
            messagepopover.allstudentarray=allstudentarray;
            messagepopover.allstaffarray=allstaffarray;
            messagepopover.staffgrouparray=staffgrouparray;
            
            if (![messagepopover InitializeField]) {
                return;
            }
            
            messagepopover.view.frame=self->sidewindowview.bounds;
            [self->sidewindowview addSubview:messagepopover.view];
            [self addChildViewController:messagepopover];
            [messagepopover didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            self->ailoadindicator.hidden=YES;
        });
    }else{
        
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrievenewmessagecontact];
            
            
            [self startsidewindowanimationwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                PickerViewController *pickerviewcontroller = (PickerViewController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil] instantiateViewControllerWithIdentifier: @"PickerViewController"];
                pickerviewcontroller.delegate=self;
                pickerviewcontroller.selecteditems=[[NSMutableArray alloc]init];
                pickerviewcontroller.datatype=@"MessageContact";
                pickerviewcontroller.showsearchbar=YES;
                pickerviewcontroller.bottommode=@"New Group";
                pickerviewcontroller.viewtitle=@"New Contact";
                pickerviewcontroller.preferredContentSize=CGSizeMake(320, 40*NewContactArray.count);
                pickerviewcontroller.itemsarray=NewContactArray;
                
                pickerviewcontroller.view.frame=self->sidewindowview.bounds;
                [self->sidewindowview addSubview:pickerviewcontroller.view];
                [self addChildViewController:pickerviewcontroller];
                [pickerviewcontroller didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                self->ailoadindicator.hidden=YES;
            });
            
            
        });
        
        
    }
    
    
    
    
}

- (IBAction)messageviewselected:(UISegmentedControl *)sender {
    
    [self stopAudioPlaying];
    if (audioPlayer.playing) {
        [audioPlayer stop];
        audioPlayer=nil;
        [sliderTimer invalidate];
        //[[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    }
    
    messagesearchbar.text=@"";
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    OutboxMessageTable.hidden=sender.selectedSegmentIndex==0;
    textinputbox.hidden=sender.selectedSegmentIndex==1 || !globalvariables.selectedmessagecontact;
    instantPhotoCollectionView.hidden=sender.selectedSegmentIndex==1 || workingMessage.photoarray.count==0;
    contactview.hidden=sender.selectedSegmentIndex==1 || !globalvariables.selectedmessagecontact;
    contactlabel.hidden=sender.selectedSegmentIndex==1 || !globalvariables.selectedmessagecontact;
    instantmessagetopbox.hidden=(sender.selectedSegmentIndex==0 && !globalvariables.selectedmessagecontact);
    //contactlistsearchbar.hidden=sender.selectedSegmentIndex==1;
    categorytable.hidden=sender.selectedSegmentIndex==0;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadmessageview];
    });
}

-(void) startsidewindowanimationwithwidth:(float)width
{
    ailoadindicator.hidden=NO;
    ailoadindicator.center = CGPointMake(width/2-7.5,mainWindow.frame.size.height/2-7.5);
    [ailoadindicator startAnimating];
    [self adjustpresentingviewwidthwithwidth:width];
}

-(void) closefullscreen
{
    //photofullscreenview.hidden=YES;
}

-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width
{
    CGRect visible = [self visibleWindowFrame];
    CGFloat edge = CGRectGetMaxX(visible);
    CGFloat panelY = visible.origin.y;
    CGFloat panelHeight = visible.size.height;
    if (edge < 1) {
        edge = mainWindow.bounds.size.width;
        panelY = 0;
        panelHeight = mainWindow.bounds.size.height;
    }
    CGFloat panelWidth = width > 0 ? MIN(width, visible.size.width > 1 ? visible.size.width : edge) : 0;
    BOOL alreadyClosed = ailoadindicator.hidden && sidewindowview.frame.size.width < 1 && fabs(sidewindowview.frame.origin.x - edge) < 1;
    if (alreadyClosed) {
        return;
    }
    if (fabs(sidewindowview.frame.origin.x - (edge - panelWidth)) < 1 && fabs(sidewindowview.frame.size.width - panelWidth) < 1 && fabs(sidewindowview.frame.size.height - panelHeight) < 1) {
        return;
    }
    
    if (width>0 && sidewindowview.frame.size.width < 1) {
        [MyClass playsoundwithoption:@"open"];
    }
    if (visible.size.width > 1) {
        sidewindowviewclosebutton.frame = visible;
    }
    sideWindowAdjusting = YES;
    
    [UIView animateWithDuration:0.25f animations:^{
        sidewindowview.hidden = width<=0;
        sidewindowview.frame=CGRectMake(edge-panelWidth, panelY, panelWidth, panelHeight);
        for (UIView *panelChild in sidewindowview.subviews) {
            if ([panelChild isKindOfClass:[UIActivityIndicatorView class]]) {
                continue;
            }
            panelChild.frame = sidewindowview.bounds;
        }
        if (width==0 && sidewindowview.frame.origin.x< edge) {
            [MyClass playsoundwithoption:@"close"];
        }
    } completion:^(BOOL finished){
        sideWindowAdjusting = NO;
        if (width > 0) {
            [self pinOpenSideWindowToVisibleEdge];
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
    
    //[OutboxMessageTable deselectRowAtIndexPath:[OutboxMessageTable indexPathForSelectedRow] animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //if (tableView==messagerecordtable) {
    //    return 1;
    //}else{
    
    if (tableView==categorytable) {
        return categoryarray.count;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==categorytable) {
        return [((NSArray *)[((NSArray *)[categoryarray objectAtIndex:section]) objectAtIndex:1]) count];
    }else if (tableView==contactlisttable) {
        return FilteredMessageContactArray.count;
    }else if (tableView==OutboxMessageTable){
        return filteredOutboxMessageArray.count;
    }else if (tableView==contentTable){
        return globalvariables.filteredMessageArray.count;
    }
    
    return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==categorytable) {
        return 35;
    }
    return UITableViewAutomaticDimension;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView==categorytable) {
        
        //if (scmessageview.selectedSegmentIndex==1) {
        MyTableViewCell *cell;
        static NSString *CellIdentifier= @"categorycell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
        }
        
        
        NSString *title=[((NSArray *)[((NSArray *)[categoryarray objectAtIndex:indexPath.section]) objectAtIndex:1]) objectAtIndex:indexPath.row];
        cell.label1.text=[MyClass returntitlewithtitle:title];
        
        if (indexPath.section==0) {
            cell.imageview1.hidden=![title isEqualToString:selectedreceipienttype];
        }else if (indexPath.section==1) {
            cell.imageview1.hidden=![title isEqualToString:selectedmessagetype];
        }else if (indexPath.section==2) {
            cell.imageview1.hidden=![title isEqualToString:selectedstatus];
        }
        return cell;
        //}
    }else if (tableView==contactlisttable){
        MyTableViewCell *cell;
        static NSString *CellIdentifier = @"contactcell";
        cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        MessageContactRecord *messagecontactrecord=[FilteredMessageContactArray objectAtIndex:indexPath.row];
        if ([messagecontactrecord.readstatus isEqualToString:@"NA"]) {
            cell.imageview3.hidden=YES;
        }else if ([messagecontactrecord.channel isEqualToString:@"E"] || [messagecontactrecord.channel isEqualToString:@"S"]){
            cell.imageview3.hidden=NO;
            [cell.imageview3 setImage:[UIImage imageNamed:@"questionmark_gray.png"]];
        }else if ([messagecontactrecord.readstatus isEqualToString:@"SOME"]){
            cell.imageview3.hidden=NO;
            [cell.imageview3 setImage:[UIImage imageNamed:@"graybluecheck_icon.png"]];
        }else if ([messagecontactrecord.readstatus isEqualToString:@"ALL"]){
            cell.imageview3.hidden=NO;
            [cell.imageview3 setImage:[UIImage imageNamed:@"doublebluecheck_icon.png"]];
        }else if ([messagecontactrecord.readstatus isEqualToString:@"NONE"]){
            cell.imageview3.hidden=NO;
            [cell.imageview3 setImage:[UIImage imageNamed:@"doublegraycheck_icon.png"]];
        }
        
        NSString * messagecontactdisplayname;
        NSString * messagecontactid=@"";
        if ([messagecontactrecord.messagecontacttype isEqualToString:@"Center"]) {
            messagecontactdisplayname=[MyClass returncentershortnamewithcenterkey:messagecontactrecord.centerkey];
        }else if ([messagecontactrecord.messagecontacttype isEqualToString:@"Staff"]){
            messagecontactdisplayname=[MyClass returnstaffnamewithusername:messagecontactrecord.messagecontact firstorfullname:@"full"];
        }else if ([messagecontactrecord.messagecontacttype isEqualToString:@"Student"]){
            messagecontactdisplayname=[MyClass returnStudentnameWithStudentkey:messagecontactrecord.messagecontact option:@"full"];
            messagecontactid=((Student *)[MyClass returnstudentwithstudentkey:messagecontactrecord.messagecontact]).studentid;
        }else if ([messagecontactrecord.messagecontacttype isEqualToString:@"Lead"]){
            messagecontactdisplayname=[MyClass returnLeadnameWithLeadkey:messagecontactrecord.messagecontact option:@"full"];
            messagecontactid=((Lead *)[MyClass returnleadwithleadkey:messagecontactrecord.messagecontact]).leadid;
        }else if ([messagecontactrecord.messagecontacttype isEqualToString:@"Group"]){
            messagecontactdisplayname=((GroupRecord *)[MyClass returngrouprecordwithgrouparray:allstaffgrouparray groupkey:messagecontactrecord.messagecontact]).groupname;
        }
        
        cell.view2.hidden=![messagecontactrecord.messagecontact isEqualToString:globalvariables.selectedmessagecontact.messagecontact];
        cell.label1.text=messagecontactdisplayname;
        cell.label6.text=[MyClass returntitlewithtitle:messagecontactrecord.messagecontacttype];
        if ([messagecontactrecord.messagecontacttype isEqualToString:@"Center"]) {
            [MyClass downloadImageWithImageview:cell.imageview1 gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_landscape image:@"Yes" async:YES];
        }else if ([messagecontactrecord.messagecontacttype isEqualToString:@"Student"]){
            Student *student=[MyClass returnstudentwithstudentkey:messagecontactrecord.messagecontact];
            [MyClass downloadImageWithImageview:cell.imageview1 gender:student.gender type:@"student" typekey:student.studentkey image:student.image async:YES];
        }else if ([messagecontactrecord.messagecontacttype isEqualToString:@"Lead"]){
            Lead *lead=[MyClass returnleadwithleadkey:messagecontactrecord.messagecontact];
            [MyClass downloadImageWithImageview:cell.imageview1 gender:lead.gender type:@"lead" typekey:lead.leadkey image:lead.image async:YES];
        }else if ([messagecontactrecord.messagecontacttype isEqualToString:@"Group"]){
            [cell.imageview1 setImage:[UIImage imageNamed:@"group_icon.png"]];
        }else{
            [MyClass downloadImageWithImageview:cell.imageview1 gender:nil type:@"staff" typekey:messagecontactrecord.messagecontact image:@"Yes" async:YES];
        }
        
        //if (((UserPrivilege *)[MyClass returnuserprivilegewithcenterkey:messagecontactrecord.centerkey]).istaffviewcentermessage) {
        //cell.label7.hidden=NO;
        if ([messagecontactrecord.type isEqualToString:@"received"]) {
            if ([messagecontactrecord.sender isEqualToString:globalvariables.username]) {
                cell.label7.text=[MyClass returntitlewithtitle:@"You"];
            }else if ([messagecontactrecord.sender isEqualToString:@"center"]) {
                cell.label7.text=[MyClass returncentershortnamewithcenterkey:messagecontactrecord.centerkey];
            }else if ([messagecontactrecord.messagecontacttype isEqualToString:@"Group"]) {
                cell.label7.text=[MyClass returnstaffnamewithusername:messagecontactrecord.sender firstorfullname:@"full"];
            }else if ([messagecontactrecord.sender rangeOfString:@"@"].location !=NSNotFound){
                cell.label7.text=[MyClass returnstaffnamewithusername:messagecontactrecord.sender firstorfullname:@"full"];
            }else{
                cell.label7.text=[MyClass returnStudentnameWithStudentkey:messagecontactrecord.sender option:@"full"];
            }
            cell.label7.text=[NSString stringWithFormat:@"%@:",cell.label7.text];
            cell.label7.textColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
        }else{
            if ([messagecontactrecord.recipient isEqualToString:globalvariables.username]) {
                cell.label7.text=[MyClass returntitlewithtitle:@"You"];
                cell.label7.text=[NSString stringWithFormat:@"@%@",cell.label7.text];
                cell.label7.textColor=[UIColor orangeColor];
            }else if ([messagecontactrecord.recipient isEqualToString:@"center"]) {
                cell.label7.text=[MyClass returncentershortnamewithcenterkey:messagecontactrecord.centerkey];
                cell.label7.text=[NSString stringWithFormat:@"@%@",cell.label7.text];
                cell.label7.textColor=[UIColor orangeColor];
            }else if ([messagecontactrecord.messagecontacttype isEqualToString:@"Group"]) {
                cell.label7.text=[MyClass returnstaffnamewithusername:messagecontactrecord.sender firstorfullname:@"full"];
                cell.label7.text=[NSString stringWithFormat:@"%@:",cell.label7.text];
                cell.label7.textColor=[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
            }else if ([messagecontactrecord.recipient rangeOfString:@"@"].location !=NSNotFound){
                cell.label7.text=[MyClass returnstaffnamewithusername:messagecontactrecord.recipient firstorfullname:@"full"];
                cell.label7.text=[NSString stringWithFormat:@"@%@",cell.label7.text];
                cell.label7.textColor=[UIColor orangeColor];
            }else{
                cell.label7.text=[MyClass returnStudentnameWithStudentkey:messagecontactrecord.recipient option:@"full"];
                cell.label7.text=[NSString stringWithFormat:@"@%@",cell.label7.text];
                cell.label7.textColor=[UIColor orangeColor];
            }
            
            
            
        }
        
        NSString * message;
        if ([globalvariables.language isEqualToString:@"English"]) {
            message=messagecontactrecord.messageenglish;
        }else{
            message=messagecontactrecord.messagechinese;
        }
        
        if ([message isEqualToString:@""]) {
            if (messagecontactrecord.attachmenttypes.count==1) {
                if ([[messagecontactrecord.attachmenttypes firstObject] isEqualToString:@"I"]) {
                    cell.label2.text=[MyClass returntitlewithtitle:@"Image"];
                }else if ([[messagecontactrecord.attachmenttypes firstObject] isEqualToString:@"P"]) {
                    cell.label2.text=[MyClass returntitlewithtitle:@"PDF"];
                }else if ([[messagecontactrecord.attachmenttypes firstObject] isEqualToString:@"A"]) {
                    cell.label2.text=[MyClass returntitlewithtitle:@"Voice"];
                }else if ([[messagecontactrecord.attachmenttypes firstObject] isEqualToString:@"V"]) {
                    cell.label2.text=[MyClass returntitlewithtitle:@"Video"];
                }
            }else if (messagecontactrecord.attachmenttypes.count>1) {
                cell.label2.text=[MyClass returntitlewithtitle:@"Multiple attachments"];
            }else{
                cell.label2.text=@"";
            }
        }else{
            cell.label2.text=message;
        }
        
        /*if ([messagecontactrecord.message isEqualToString:@""]) {
         if ([messagecontactrecord.photo isEqualToString:@"Yes"]) {
         cell.label2.text=[MyClass returntitlewithtitle:@"Photo"];
         }else{
         cell.label2.text=@"";
         }
         }else{
         cell.label2.text=messagecontactrecord.message;
         }*/
        
        cell.label3.text=[MyClass returnMessageTimeWithMessageStartTime:messagecontactrecord.messagestarttime];
        if ([messagecontactrecord.unreadcount integerValue]>0) {
            cell.view1.hidden=NO;
            cell.label4.text=messagecontactrecord.unreadcount;
            cell.button2.hidden=NO;
        }else if ([messagecontactrecord.unreadcount integerValue]<0) {
            cell.view1.hidden=NO;
            cell.label4.text=@"";
            cell.button2.hidden=NO;
        }else{
            cell.view1.hidden=YES;
            if(![messagecontactrecord.messagecontacttype isEqualToString:@"Lead"]){
                cell.button2.hidden=NO;
            }else{
                cell.button2.hidden=YES;
            }
        }
        
        cell.stackview1.hidden=cell.button2.hidden && cell.view1.hidden;
        
        //cell.imageview2.hidden=![messagecontactrecord.photo isEqualToString:@"Yes"];
        cell.imageview2.hidden=![messagecontactrecord.attachmenttypes containsObject:@"I"];
        cell.imageview4.hidden=![messagecontactrecord.attachmenttypes containsObject:@"P"];
        cell.imageview5.hidden=![messagecontactrecord.attachmenttypes containsObject:@"A"];
        cell.imageview6.hidden=![messagecontactrecord.attachmenttypes containsObject:@"V"];
        
        
        [cell.button1 addTarget:self action:@selector(imagebuttontapped:) forControlEvents:UIControlEventTouchUpInside];
        cell.button1.tag=indexPath.row;
        [cell.button2 addTarget:self action:@selector(showcontactlistaction:) forControlEvents:UIControlEventTouchUpInside];
        cell.button2.tag=indexPath.row;
        
        //cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
        
        
    }else if (tableView==OutboxMessageTable){
        MyTableViewCell *cell;
        OutboxMessageRecord *messagerecordobject=[filteredOutboxMessageArray objectAtIndex:indexPath.row];
        
        static NSString *CellIdentifier;
        
        if (messagerecordobject.photoarray.count==0) {
            CellIdentifier = @"outboxmessageimagecell";
        }else{
            CellIdentifier = @"outboxmessageimagecell";
        }
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.stackview1.hidden=messagerecordobject.photoarray.count==0;
        cell.button3.tag=indexPath.row;
        [cell.button3 addTarget:self action:@selector(showgroupmessageactions:) forControlEvents:UIControlEventTouchUpInside];
        
        /*if ([messagerecordobject.sender isEqualToString:@"center"]) {
         cell.label1.text=[MyClass returncentershortnamewithcenterkey:globalvariables.centerrecord.centerkey];
         }else{
         cell.label1.text=messagerecordobject.sender;
         }*/
        
        cell.label1.text=[MyClass returnstaffnamewithusername:messagerecordobject.composer firstorfullname:@"full"];
        
        cell.label6.text=[MyClass returnMessageChannelNameWithChannelCode:messagerecordobject.channel];
        
        cell.textview1.textContainerInset = UIEdgeInsetsZero;
        cell.textview1.textContainer.lineFragmentPadding = 0;
        if ([globalvariables.language isEqualToString:@"English"]) {
            if (![messagerecordobject.messageenglish isEqualToString:@""]) {
                cell.textview1.text=messagerecordobject.messageenglish;
            }else{
                cell.textview1.text=messagerecordobject.messagechinese;
            }
        }else{
            if (![messagerecordobject.messagechinese isEqualToString:@""]) {
                cell.textview1.text=messagerecordobject.messagechinese;
            }else{
                cell.textview1.text=messagerecordobject.messageenglish;
            }
        }
        
        cell.textview1.hidden=[cell.textview1.text isEqualToString:@""];
        
        cell.label3.text=[MyClass returnMessageTimeWithMessageStartTime:messagerecordobject.messagestarttime];
        cell.label4.text=[MyClass returntitlewithtitle:messagerecordobject.messagetype];
        if ([messagerecordobject.messagetype isEqualToString:@"Important"]) {
            cell.label4.textColor=[UIColor redColor];
        }else{
            cell.label4.textColor=[UIColor lightGrayColor];
        }
        
        if (messagerecordobject.photoarray.count>0) {
            [[cell.stackview1 subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            for (int i=0; i<messagerecordobject.photoarray.count; i++) {
                MessagePhotoRecord *obj=[messagerecordobject.photoarray objectAtIndex:i];
                float aspectRatio;
                messageDocumentUIView *messagedocumentview=[[messageDocumentUIView alloc]initWithFrame:CGRectMake(0, 0, 380, 200) messagePhotoRecord:obj];
                UIImageView *image=messagedocumentview.imageview;
                [messagedocumentview setTranslatesAutoresizingMaskIntoConstraints:NO];
                
                [cell.stackview1 addArrangedSubview:messagedocumentview];
                
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
                
                /*
                 float height;
                 if ([obj.filetype isEqualToString:@"image"]) {
                 if (obj.height>obj.width) {
                 height=cell.stackview1.frame.size.width;
                 }else{
                 height=obj.height/obj.width*cell.stackview1.frame.size.width;
                 }
                 }else if ([obj.filetype isEqualToString:@"video"]) {
                 height=250;
                 }else{
                 height=250;
                 }
                 
                 messageDocumentUIView *messagedocumentview=[[messageDocumentUIView alloc]initWithFrame:CGRectMake(0, 0, 380, height) messagePhotoRecord:obj];
                 
                 UIImageView *image=messagedocumentview.imageview;
                 
                 [cell.stackview1 addArrangedSubview:messagedocumentview];
                 [messagedocumentview.heightAnchor constraintEqualToConstant:height].active = true;*/
                
                if (!obj.thumbnailurl || [obj.thumbnailurl isEqualToString:@""]){
                    image.image=obj.imageview.image;
                }else{
                    [MyClass downloadImageWithImageview:image gender:nil type:@"message" typekey:obj.thumbnailurl image:@"Yes" async:YES];
                }
                
                [messagedocumentview.viewbutton addTarget:self action:@selector(tapMessagePhotoDetected:) forControlEvents:UIControlEventTouchUpInside];
                messagedocumentview.viewbutton.tag=indexPath.row*888888+i;
                
            }
            cell.button1.hidden=messagerecordobject.photoarray.count>1 || selectMode;
            cell.button1.tag=indexPath.row;
            [cell.button1 addTarget:self action:@selector(sharephotobuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            cell.button1.hidden=YES;
        }
        
        [self returnRecipientViewWithView:cell.view1 MessageRecord:messagerecordobject HeightConstraint:cell.layoutconstraint1];
        
        //cell.button2.tag=indexPath.row;
        
        
        if ([messagerecordobject.status isEqualToString:@"D"]) {
            [cell.button2 setImage:[UIImage imageNamed:@"draftmessage_blue_icon.png"] forState:UIControlStateNormal];
            //[cell.button2 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        }else if ([MyClass isMessageSentWithMessageSentTime:messagerecordobject.messagestarttime]){
            if ([messagerecordobject.readstatus isEqualToString:@"SOME"]){
                [cell.button2 setImage:[UIImage imageNamed:@"graybluecheck_icon.png"] forState:UIControlStateNormal];
                //[cell.button2 addTarget:self action:@selector(showreadstatus:) forControlEvents:UIControlEventTouchUpInside];
            }else if ([messagerecordobject.readstatus isEqualToString:@"ALL"]){
                [cell.button2 setImage:[UIImage imageNamed:@"doublebluecheck_icon.png"] forState:UIControlStateNormal];
                //[cell.button2 addTarget:self action:@selector(showreadstatus:) forControlEvents:UIControlEventTouchUpInside];
            }else if ([messagerecordobject.readstatus isEqualToString:@"NONE"]){
                [cell.button2 setImage:[UIImage imageNamed:@"doublegraycheck_icon.png"] forState:UIControlStateNormal];
                //[cell.button2 addTarget:self action:@selector(showreadstatus:) forControlEvents:UIControlEventTouchUpInside];
            }else if ([messagerecordobject.readstatus isEqualToString:@"SENDING"]){
                [cell.button2 setImage:[UIImage imageNamed:@"messageloading_icon.png"] forState:UIControlStateNormal];
                //[cell.button2 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            }else if ([messagerecordobject.readstatus isEqualToString:@"NA"]){
                [cell.button2 setImage:[UIImage imageNamed:@"na_icon.png"] forState:UIControlStateNormal];
                //[cell.button2 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
            }
        }else{
            [cell.button2 setImage:[UIImage imageNamed:@"calendar_icon_blue.png"] forState:UIControlStateNormal];
            [cell.button2 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
        }
        
        
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        cell.contentView.transform=CGAffineTransformMakeScale(1, -1);
        //[self.view layoutIfNeeded];
        return cell;
        
    }else if (tableView==contentTable){
        InboxMessageRecord *messagerecordobject=[globalvariables.filteredMessageArray objectAtIndex:indexPath.row];
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
        
        
        if (selectMode) {
            myCell.view7.hidden=NO;
            myCell.imageview7.layer.opacity=[selectedinboxmessages containsObject:messagerecordobject.inboxmessagekey]?1.0:0.3;
        }else{
            myCell.view7.hidden=YES;
        }
        
        myCell.textview1.textContainerInset = UIEdgeInsetsZero;
        myCell.textview1.textContainer.lineFragmentPadding = 0;
        if ([globalvariables.language isEqualToString:@"English"]) {
            if (![messagerecordobject.messageenglish isEqualToString:@""]) {
                myCell.textview1.text=messagerecordobject.messageenglish;
            }else{
                myCell.textview1.text=messagerecordobject.messagechinese;
            }
        }else{
            if (![messagerecordobject.messagechinese isEqualToString:@""]) {
                myCell.textview1.text=messagerecordobject.messagechinese;
            }else{
                myCell.textview1.text=messagerecordobject.messageenglish;
            }
        }
        
        myCell.textview1.hidden=[myCell.textview1.text isEqualToString:@""];
        
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
        
        if (messagerecordobject.photoarray.count>0 ) {
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
            myCell.label1.hidden=NO;
            if ([messagerecordobject.recipient isEqualToString:globalvariables.username]) {
                myCell.label1.text=[MyClass returntitlewithtitle:@"You"];
                myCell.label1.text=[NSString stringWithFormat:@"@%@",myCell.label1.text];
            }else if ([messagerecordobject.recipient isEqualToString:@"center"]) {
                myCell.label1.text=[MyClass returncentershortnamewithcenterkey:globalvariables.centerrecord.centerkey];
                myCell.label1.text=[NSString stringWithFormat:@"@%@",myCell.label1.text];
            }else if ([messagerecordobject.recipienttype isEqualToString:@"Group"]) {
                myCell.label1.text=[MyClass returnstaffnamewithusername:messagerecordobject.sender firstorfullname:@"full"];
                myCell.label1.text=[NSString stringWithFormat:@"%@:",myCell.label1.text];
            }else if ([messagerecordobject.recipient rangeOfString:@"@"].location !=NSNotFound){
                myCell.label1.text=[MyClass returnstaffnamewithusername:messagerecordobject.recipient firstorfullname:@"full"];
                myCell.label1.text=[NSString stringWithFormat:@"@%@",myCell.label1.text];
            }else{
                myCell.label1.text=[MyClass returnStudentnameWithStudentkey:messagerecordobject.recipient option:@"full"];
                myCell.label1.text=[NSString stringWithFormat:@"@%@",myCell.label1.text];
            }
            myCell.button3.tag=indexPath.row;
            [myCell.button3 addTarget:self action:@selector(showinstantmessageactions:) forControlEvents:UIControlEventTouchUpInside];
            myCell.button3.hidden=selectMode;
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
        
    }
    
    return nil;
}

-(void) replytomessagebuttonpressed:(UIButton *)sender
{
    NSInteger index=0;
    InboxMessageRecord *obj=[globalvariables.filteredMessageArray objectAtIndex:sender.tag];
    CGPoint point = [sender.superview convertPoint:CGPointZero toView:contentTable];
    NSIndexPath *indexPath =[contentTable indexPathForRowAtPoint:point];
    for(NSInteger i=indexPath.row;i<globalvariables.filteredMessageArray.count;i++){
        InboxMessageRecord *record=[globalvariables.filteredMessageArray objectAtIndex:i];
        if([record.outboxmessagekey isEqualToString:obj.replytomessagekey]){
            index=i;
            break;
        }
    }
    [contentTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView==categorytable) {
        //if (scmessageview.selectedSegmentIndex==1) {
        return [MyClass returntitlewithtitle:[((NSArray *)[categoryarray objectAtIndex:section]) objectAtIndex:0]];
        //}
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==categorytable) {
        //if (scmessageview.selectedSegmentIndex==1) {
        NSString *title=[((NSArray *)[((NSArray *)[categoryarray objectAtIndex:indexPath.section]) objectAtIndex:1]) objectAtIndex:indexPath.row];
        if ((indexPath.section==0)) {
            selectedreceipienttype=title;
        }else if (indexPath.section==1){
            selectedmessagetype=title;
        }else if (indexPath.section==2){
            selectedstatus=title;
        }
        [categorytable reloadData];
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self retrieveMessageRecordwithMessageType:selectedmessagetype Status:selectedstatus ReceipientType:selectedreceipienttype]) {
            }else{
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
            }
        });
    }else if (tableView==contactlisttable){
        //}else{
        [self stopAudioPlaying];
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        globalvariables.selectedmessagecontact=[FilteredMessageContactArray objectAtIndex:indexPath.row];
        [contactlisttable reloadData];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            workingMessage.photoarray=[[NSMutableArray alloc]init];
            workingMessage.messagechinese=@"";
            workingMessage.messageenglish=@"";
            messageinputtext.text=@"";
            instantPhotoCollectionView.hidden=YES;
            camerabutton.hidden=NO;
            sendinstantmessagebutton.enabled=[self enableSendButton];
            
            [self retrievemessagelistwithmessagecontact:globalvariables.selectedmessagecontact];
            textinputbox.hidden=NO;
            instantmessagetopbox.hidden=NO;
            [self updateinstantmessagetopbox];
            globalvariables.selectedmessagecontact.unreadcount=@"";
            [contactlisttable reloadData];
        });
        
        //}
    }else if(tableView==contentTable){
        if (selectMode) {
            [self selectMessageWithIndex:indexPath.row];
        }
    }
}

-(void) imagebuttontapped:(UIButton *)sender
{
    [self stopAudioPlaying];
    MessageContactRecord *messagecontact=[FilteredMessageContactArray objectAtIndex:sender.tag];
    
    if ([messagecontact.messagecontacttype isEqualToString:@"Student"]) {
        //[MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        
        if(![MyClass showMenuItemwithObject:@"Student Profile"]){
            return;
        }
        
        [MyClass insertViewHistoryWithType:@"student" Typekey:messagecontact.messagecontact Name:@"" IDNumber:@"" Gender:@""];
        
        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            StudentDetailsNavController *studentdetailsnavcontroller = (StudentDetailsNavController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"StudentDetailsNavController"];
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).delegate=self;
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).studentAction=@"PopoverStudent";
            ((StudentDetailsViewController *)[studentdetailsnavcontroller topViewController]).DetailsViewStudent=[[Student alloc]initStudentWithstudentkey:messagecontact.messagecontact studentid:nil firstname:nil lastname:nil othername:nil gender:nil dateofbirth:nil age:nil grade:nil preferredlanguage:nil school:nil parentname:nil phonearray:nil parentemail:nil parentaddress:nil remarks:nil flag:nil status:nil promotion:nil image:nil leadkey:nil studentmedia:nil studentsource:nil siblingarray:nil photoalbumrecord:nil centerkey:nil due:nil avatar:nil sendmessage:YES displayfullname:nil fcmemberid:nil ddaenabled:NO ddaaccountno:nil ddaaccountname:nil ddadebtorreference:nil ddalimit:nil extrafield1:nil parentname2:nil validcouponcount:nil extrafield2:nil creditamount:0];
            
            
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
            [sidewindowview addSubview:studentdetailsnavcontroller.view];
            [self addChildViewController:studentdetailsnavcontroller];
            [studentdetailsnavcontroller didMoveToParentViewController:self];
            [ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
            
            
            
        });
    }else if ([messagecontact.messagecontacttype isEqualToString:@"Lead"]) {
        
        if(![MyClass showMenuItemwithObject:@"Lead Profile"]){
            return;
        }
        
        //[MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        [MyClass insertViewHistoryWithType:@"lead" Typekey:messagecontact.messagecontact Name:@"" IDNumber:@"" Gender:@""];
        [self startsidewindowanimationwithwidth:self.view.frame.size.width-240];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            LeadDetailsNavController *leaddetailsnavcontroller = (LeadDetailsNavController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"LeadDetailsNavController"];
            ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).leadAction=@"PopoverLead";
            ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).DetailsViewLead=[[Lead alloc]init];
            ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).DetailsViewLead.leadkey=messagecontact.messagecontact;
            
            //((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).selectedDTkey=ClassScheduleObject.dtkey;
            
            
            if (![(LeadDetailsViewController *)[leaddetailsnavcontroller topViewController] retrieveLead:messagecontact.messagecontact]) {
                return;
            }
            
            ((LeadDetailsViewController *)[leaddetailsnavcontroller topViewController]).preferredContentSize= CGSizeMake(self.view.frame.size.width-240, self.view.frame.size.height);
            
            leaddetailsnavcontroller.view.frame=CGRectMake(0, 0, self.view.frame.size.width-240, self.view.frame.size.height);
            [sidewindowview addSubview:leaddetailsnavcontroller.view];
            [self addChildViewController:leaddetailsnavcontroller];
            [leaddetailsnavcontroller didMoveToParentViewController:self];
            [ailoadindicator stopAnimating];
            ailoadindicator.hidden=YES;
        });
    }
}

-(void) updateinstantmessagetopbox
{
    contactlabel.text=globalvariables.selectedmessagecontact.messagecontactdisplayname;
    NSString *type;
    NSString *typekey;
    NSString *gender;
    NSString *image;
    if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Center"]) {
        type=@"centerimage";
        typekey=((CenterRecord *)[MyClass returncenterrecordwithcenterkey:globalvariables.selectedmessagecontact.centerkey]).launchimage_landscape;
        gender=nil;
        image=@"Yes";
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Student"]){
        Student *student=[MyClass returnstudentwithstudentkey:globalvariables.selectedmessagecontact.messagecontact];
        type=@"student";
        typekey=globalvariables.selectedmessagecontact.messagecontact;
        gender=student.gender;
        image=student.image;
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Lead"]){
        Lead *lead=[MyClass returnleadwithleadkey:globalvariables.selectedmessagecontact.messagecontact];
        type=@"lead";
        typekey=globalvariables.selectedmessagecontact.messagecontact;
        gender=lead.gender;
        image=lead.image;
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Group"]){
        [contactimage setImage:[UIImage imageNamed:@"group_icon.png"]];
        contactview.hidden=NO;
        contactlabel.hidden=NO;
        scsender.enabled=NO;
        return;
    }else{
        type=@"staff";
        typekey=globalvariables.selectedmessagecontact.messagecontact;
        gender=nil;
        image=@"Yes";
    }
    
    [MyClass downloadImageWithImageview:contactimage gender:gender type:type typekey:typekey image:image async:YES];
    contactview.hidden=![MyClass isImageInCacheWithType:type TypeKey:typekey];
    contactlabel.hidden=NO;
    scsender.enabled=![globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Center"];
}

- (IBAction)cancelSelectButtonPressed:(id)sender {
    [selectedinboxmessages removeAllObjects];
    selectMode=nil;
    [contentTable reloadData];
    selectStatusView.hidden=YES;
    forwardMessageButton.hidden=YES;
    deleteMessageButton.hidden=YES;
}


-(void) retrievemessagelistwithmessagecontact:(MessageContactRecord *)messagecontactrecord
{
    selectMode=nil;
    selectedinboxmessages=[[NSMutableArray alloc]init];
    selectedoutboxmessages=[[NSMutableArray alloc]init];
    selectStatusView.hidden=YES;
    forwardMessageButton.hidden=YES;
    deleteMessageButton.hidden=YES;
    
    InboxMessageRecord *messageobject;
    
    if(!messagecontactrecord){
        return;
    }
    
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievemessagelist2&username=%@&apptype=center&messagecontact=%@&messagecontacttype=%@&showsystemmessage=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,messagecontactrecord.centerkey,globalvariables.username,messagecontactrecord.messagecontact,messagecontactrecord.messagecontacttype,showsystemmessage?@"Y":@"N"];
    
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
    
    if (result) {
        globalvariables.messageArray=[[NSMutableArray alloc]init];
        replyToMessageDict=[[NSMutableDictionary alloc]init];
        
        //loop through our jsonArray
        //firstunreadrow=-1;
        //unreadcount=0;
        
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
            
            //cstatus=@"";
            /*if ([ctype isEqualToString:@"received"] && [creadtime isEqualToString:@""]) {
             unreadcount+=1;
             if (i>firstunreadrow) {
             firstunreadrow=i;
             }
             }*/
            
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
                
                if ([crecipienttype isEqualToString:@"Group"]) {
                    crelationship=[MyClass returnstaffnamewithusername:ccontact firstorfullname:@"full"];
                }
                
                [tmpreadstatusdetailsarray addObject:[[ReadStatusRecord alloc]initReadStatusRecordwithRecipientName:crecipientname RecipientID:nil Channel:cchannel ReadTime:creadtime Image:nil Gender:nil Centerkey:nil Recipientkey:ccontact Contactgroup:nil Relationship:crelationship iso_code:ciso_code]];
            }
            
            messageobject=[[InboxMessageRecord alloc]initInboxMessageRecordwithInboxMessagekey:cinboxmessagekey Messagetype:cmessagetype MessageEnglish:cmessageenglish MessageChinese:cmessagechinese MessageCreateTime:nil MessageStartTime:cmessagestarttime AutoMessageFlag:cautomessageflag Channel:cchannel ReciptientType:crecipienttype Status:cstatus Sender:csender AssociateID:cassociateid Readtime:creadtime photoarray:tmpphotoarray recipient:crecipient outboxmessagekey:coutboxmessagekey type:ctype readstatus:creadstatus readstatusdetailsarray:tmpreadstatusdetailsarray replytomessagekey:creplytomessagekey];
            
            [globalvariables.messageArray addObject:messageobject];
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
    
    
    
}



-(void) dismissMessagePopoverVC
{
    [self closesidewindow];
    [self reloadmessageview];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (tableView==categorytable) {
        //if (scmessageview.selectedSegmentIndex==1) {
        return 44;
        //}
    }else if (tableView==OutboxMessageTable){
        return 30;
    }else if (tableView==contentTable){
        return 30;
    }
    return CGFLOAT_MIN;
}


-(void) copyMessage{
    
    //not required
}


-(void) loadtitle
{
    viewtitle.text=[MyClass returntitlewithtitle:@"Message Center"];
}

-(void) switchcenterbuttonpressed
{
    [self stopAudioPlaying];
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

-(void) reloadPageWithFirstLoad:(BOOL)firstload
{
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MyClass getLatestDataSetv2withParameters:@"student,lead,staff,arcode,centersettings,userroleandprivilege,subject,languagetitle"/*@"calendar,languagetitle,subject,staff,centersettings,userroleandprivilege,student,lead"*/ Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
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
                    //[MyClass LoadSchoolCalendarArray];
                    [self refreshlanguage];
                    
                    allstudentarray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];
                    allleadarray=[[NSMutableArray alloc]initWithArray:[globalvariables.leadlistarray allValues]];
                    allstaffarray=[[NSMutableArray alloc]initWithArray:[globalvariables.stafflistarray allValues]];
                    allstaffgrouparray=[MyClass returnStaffGroupArrayIncludeAll:YES];
                    staffgrouparray=[self returnStaffGroupArrayExcludedAll];
                    
                    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@",globalvariables.centerrecord.centerkey];
                    allstudentarray=[[NSMutableArray alloc]initWithArray:[allstudentarray filteredArrayUsingPredicate:predicate]];
                    allleadarray=[[NSMutableArray alloc]initWithArray:[allleadarray filteredArrayUsingPredicate:predicate]];
                    
                    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@ and self.status contains[c] %@ and self.username !=%@ and self.role!=%@",globalvariables.centerrecord.centerkey,@"Yes",globalvariables.username,@"System"];
                    allstaffarray=[[NSMutableArray alloc]initWithArray:[allstaffarray filteredArrayUsingPredicate:predicate2]];
                    
                    allstudentarray = [NSMutableArray arrayWithArray:[allstudentarray sortedArrayUsingDescriptors:[MyClass returnstudentnamesortdescriptorarray]]];
                    allleadarray = [NSMutableArray arrayWithArray:[allleadarray sortedArrayUsingDescriptors:[MyClass returnleadnamesortdescriptorarray]]];
                    
                    NSSortDescriptor *sortbyfirstname = [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES selector:@selector(localizedStandardCompare:)];
                    NSSortDescriptor *sortbylastname = [NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES selector:@selector(localizedStandardCompare:)];
                    NSArray *sortDescriptors = @[sortbyfirstname,sortbylastname];
                    allstaffarray = [NSMutableArray arrayWithArray:[allstaffarray sortedArrayUsingDescriptors:sortDescriptors]];
                    
                    instantmessagetopbox.hidden=YES;
                    globalvariables.selectedmessagecontact=nil;
                    globalvariables.filteredMessageArray=[[NSMutableArray alloc]init];
                    textinputbox.hidden=YES;
                    instantmessagetopbox.hidden=YES;
                    categorytable.hidden=YES;
                    
                    [self reloadmessageview];
                }
            });
        }];
    });
}

-(void) reloadMessageScreenWithCenterkey:(NSString *)centerkey
{
    //[self playBeepSoundWithType:@"success"];
    if (scmessageview.selectedSegmentIndex==0 || centerkey) {
        [self retrievemessagecontactlistwithcenterkey:centerkey];
        [self retrievemessagelistwithmessagecontact:globalvariables.selectedmessagecontact];
    }
}


-(void) reloadMessageContact
{
    [self retrievemessagecontactlistwithcenterkey:nil];
    [self retrievemessagelistwithmessagecontact:globalvariables.selectedmessagecontact];
}


-(void) reloadmessageview
{
    if (scmessageview.selectedSegmentIndex==0) {
        [self retrievemessagecontactlistwithcenterkey:nil];
        if(globalvariables.messagecontactrecord){
            for (int i=0; i<FilteredMessageContactArray.count; i++) {
                MessageContactRecord *obj=[FilteredMessageContactArray objectAtIndex:i];
                if ([obj.messagecontacttype isEqualToString:globalvariables.messagecontactrecord.messagecontacttype] && [obj.messagecontact isEqualToString:globalvariables.messagecontactrecord.messagecontact]) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [contactlisttable selectRowAtIndexPath:indexPath
                                                  animated:YES
                                            scrollPosition:UITableViewScrollPositionNone];
                    [self tableView:contactlisttable didSelectRowAtIndexPath:indexPath];
                    break;
                }
            }
            globalvariables.messagecontactrecord=nil;
            globalvariables.firstredirectscreen=@"";
        }else if (globalvariables.selectedmessagecontact) {
            [self retrievemessagelistwithmessagecontact:globalvariables.selectedmessagecontact];
            [contentTable reloadData];
        }else{
            instantmessagetopbox.hidden=YES;
            globalvariables.filteredMessageArray=[[NSMutableArray alloc]init];
            messageinputtext.text=@"";
            [contentTable reloadData];
        }
    }else{
        selectedreceipienttype=@"All";
        selectedmessagetype=@"All";
        selectedstatus=@"All";
        
        [categorytable reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([self retrieveMessageRecordwithMessageType:selectedmessagetype Status:selectedstatus ReceipientType:selectedreceipienttype]) {
            }
        });
    }
}

-(void) donotrunviewdidappear
{
    runviewdidappear=FALSE;
}

-(BOOL) retrieveMessageRecordwithMessageType:(NSString *)MessageType Status:(NSString *)status ReceipientType:(NSString *)receipienttype
{
    NSString *instructor;
    
    if ([((UserPrivilege *)[MyClass returnuserprivilegewithcenterkey:globalvariables.centerrecord.centerkey]).role isEqualToString:@"Instructor"]) {
        instructor=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).viewallinstructorclass?@"All":globalvariables.username;
    }else{
        instructor=@"All";
    }
    
    //create string contains url address for php file
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievegroupmessage2&messagetype=%@&recipienttype=%@&instructor=%@&showattendancemessage=%@&status=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,[MyClass returnprivilegedcenterkeywithcenterkey:globalvariables.centerrecord.centerkey type:@"viewmessagecenter"],MessageType,receipienttype,instructor,@"Yes",status];
    
    
    __block BOOL result=FALSE;
    __block NSArray *jsonoutboxmessagearray;
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            jsonoutboxmessagearray = jsonreturned[@"content"];
        }
    }];
    
    
    if (result) {
        NSString *rg_group;
        NSString *rg_recipient;
        
        
        outboxMessageArray=[[NSMutableArray alloc]init];
        filteredOutboxMessageArray=[[NSMutableArray alloc]init];
        
        //int last_rg_index=0;
        
        //loop through our jsonArray
        for (int i=0; i<jsonoutboxmessagearray.count; i++) {
            
            NSString * crecipienttype=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"recipienttype"];
            NSString * cmessagecreatetime=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"messagecreatetime"];
            NSString * cmessagestarttime=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"messagestarttime"];
            NSString * coutboxmessagekey=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"outboxmessagekey"];
            NSString * cmessagetype=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"messagetype"];
            NSString * cmessageenglish=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"messageenglish"];
            NSString * cmessagechinese=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"messagechinese"];
            NSString * cautomessageflag=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"automessageflag"];
            NSString * cchannel=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"channel"];
            NSString * cstatus=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"status"];
            NSString * creadstatus=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"readstatus"];
            NSMutableArray * crecipientgrouparray=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"recipientgroup"];
            NSString * csender=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"sender"];
            NSString * ccomposer=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"composer"];
            NSMutableArray * cphotoarray=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"photoarray"];
            BOOL chotnews=[[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"hotnews"] isEqualToString:@"Yes"];
            NSString * chn_expiry_date=[[jsonoutboxmessagearray objectAtIndex:i] objectForKey:@"hn_expiry_date"];
            
            RecipientGroupRecord *crecipientgroup=[[RecipientGroupRecord alloc]initRecipientGroupRecordwithIndividualArray:[[NSMutableArray alloc]init] SubjectArray:[[NSMutableArray alloc]init] InstructorArray:[[NSMutableArray alloc]init] ClassDateArray:[[NSMutableArray alloc]init] GradeArray:[[NSMutableArray alloc]init] StudentStatusArray:[[NSMutableArray alloc]init] LeadStatusArray:[[NSMutableArray alloc]init] StaffGroupArray:[[NSMutableArray alloc]init] DropArray:[[NSMutableArray alloc]init] ActiveArray:[[NSMutableArray alloc]init] paymentstatusarray:nil productarray:nil];
            
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
                    height=photosize;
                }
                
                //NSString *type=[MyClass returnMessagePhotoRecordTypeWithURL:imagename];
                //NSString *filename=[MyClass getLocalFileNameWithFullFileName:imagename];
                
                [tmpphotoarray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:fileurl ImageView:nil Width:width Height:height FileType:filetype InternalURL:nil FileName:filename ThumbnailURL:thumbnailurl]];
            }
            
            [outboxMessageArray addObject:[[OutboxMessageRecord alloc]initOutboxMessageRecordwithOutboxMessagekey:coutboxmessagekey Messagetype:cmessagetype MessageEnglish:cmessageenglish MessageChinese:cmessagechinese MessageCreateTime:cmessagecreatetime MessageStartTime:cmessagestarttime AutoMessageFlag:cautomessageflag Channel:cchannel ReciptientType:crecipienttype Status:cstatus RecipientGroup:crecipientgroup Sender:csender photoarray:tmpphotoarray hotnews:chotnews hn_expiry_date:chn_expiry_date readstatus:creadstatus composer:ccomposer]];
            
            
            for (int j=0; j<crecipientgrouparray.count; j++) {
                rg_group=[[crecipientgrouparray objectAtIndex:j] objectForKey:@"group"];
                rg_recipient=[[crecipientgrouparray objectAtIndex:j] objectForKey:@"recipient"];
                
                if ([rg_group isEqualToString:@"student"] || [rg_group isEqualToString:@"lead"] || [rg_group isEqualToString:@"staff"]) {
                    [crecipientgroup.individualarray addObject:rg_recipient];
                }else if ([rg_group isEqualToString:@"subject"]) {
                    [crecipientgroup.subjectarray addObject:rg_recipient];
                }else if ([rg_group isEqualToString:@"instructor"]) {
                    [crecipientgroup.instructorarray addObject:rg_recipient];
                }else if ([rg_group isEqualToString:@"classdate"]) {
                    [crecipientgroup.classdatearray addObject:[MyClass convertDateFormatWithDate:rg_recipient FromDateFormat:@"yyyy-MM-dd" ToDateFormat:@"dd-MMM-yyyy" Translate:NO]];
                }else if ([rg_group isEqualToString:@"grade"]) {
                    [crecipientgroup.gradearray addObject:rg_recipient];
                }else if ([rg_group isEqualToString:@"studentstatus"]) {
                    [crecipientgroup.studentstatusarray addObject:rg_recipient];
                }else if ([rg_group isEqualToString:@"leadstatus"]) {
                    [crecipientgroup.leadstatusarray addObject:rg_recipient];
                }else if ([rg_group isEqualToString:@"staffgroup"]) {
                    [crecipientgroup.staffgrouparray addObject:rg_recipient];
                }else if ([rg_group isEqualToString:@"drop"]) {
                    [crecipientgroup.droparray addObject:rg_recipient];
                }
            }
        }
        
        
        [self returnfilteredMessageArray];
        //[contentTable reloadData];
    }
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    //[self showLoadingIndicator:NO];
    return result;
    
}

-(void) paddingtableifneeded
{
    if (scmessageview.selectedSegmentIndex==0) {
        if (globalvariables.filteredMessageArray.count>0) {
            [self.view layoutIfNeeded];
            if (contentTable.contentSize.height<contentTable.frame.size.height) {
                contentTable.contentInset=UIEdgeInsetsMake(contentTable.frame.size.height-contentTable.contentSize.height, 0,0, 0);
                [contentTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }else{
                contentTable.contentInset=UIEdgeInsetsZero;
                
                if (firstunreadrow>=0) {
                    [contentTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:firstunreadrow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                }else{
                    [contentTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
        }
    }else{
        if (filteredOutboxMessageArray.count>0) {
            [self.view layoutIfNeeded];
            if (OutboxMessageTable.contentSize.height<OutboxMessageTable.frame.size.height) {
                OutboxMessageTable.contentInset=UIEdgeInsetsMake(OutboxMessageTable.frame.size.height-OutboxMessageTable.contentSize.height, 0,0, 0);
                [OutboxMessageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }else{
                OutboxMessageTable.contentInset=UIEdgeInsetsZero;
                [OutboxMessageTable scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            }
        }
    }
}

-(void) returnfilteredMessageArray
{
    if (scmessageview.selectedSegmentIndex==0) {
        if ([messagesearchbar.text isEqualToString:@""] || !messagesearchbar) {
            globalvariables.filteredMessageArray= [[NSMutableArray alloc]initWithArray:globalvariables.messageArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.messageenglish contains[c] %@ or self.messagechinese contains[c] %@ or self.sender contains[c] %@ or self.messagetype contains[c] %@",messagesearchbar.text,messagesearchbar.text,messagesearchbar.text,messagesearchbar.text];
            globalvariables.filteredMessageArray= [[NSMutableArray alloc]initWithArray:[globalvariables.messageArray filteredArrayUsingPredicate:predicate]];
        }
        
        
        //get unread row
        firstunreadrow=-1;
        unreadcount=0;
        for (int i=0; i<globalvariables.filteredMessageArray.count; i++) {
            InboxMessageRecord *record=[globalvariables.filteredMessageArray objectAtIndex:i];
            if ([record.type isEqualToString:@"received"] && [record.readtime isEqualToString:@""] && ([record.recipient isEqualToString:globalvariables.username] || [record.recipient isEqualToString:@"center"])) {
                unreadcount+=1;
                if (i>firstunreadrow) {
                    firstunreadrow=i;
                }
            }
        }
        
        
        [contentTable reloadData];
        
        if ([workingMessage.recipienttype isEqualToString:@"Group"] || [workingMessage.recipienttype isEqualToString:@"Staff"]) {
            workingMessage.channel=@"A";
            workingMessage.sender=globalvariables.username;
        }
        
        
        if (globalvariables.filteredMessageArray.count>0) {
            [self paddingtableifneeded];
            
            //default last student to message sender
            InboxMessageRecord *lastmessage=[globalvariables.filteredMessageArray firstObject];
            
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
        
        //        [self getunreadrows];
        //        [self changemessagetoreadandreloadcontactlist:YES];
        
    }else{
        if ([messagesearchbar.text isEqualToString:@""]) {
            filteredOutboxMessageArray= [[NSMutableArray alloc]initWithArray:outboxMessageArray];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.messageenglish contains[c] %@ or self.messagechinese contains[c] %@ or self.sender contains[c] %@ or self.messagetype contains[c] %@",messagesearchbar.text,messagesearchbar.text,messagesearchbar.text,messagesearchbar.text];
            filteredOutboxMessageArray= [[NSMutableArray alloc]initWithArray:[outboxMessageArray filteredArrayUsingPredicate:predicate]];
        }
        
        [OutboxMessageTable reloadData];
        
        
        [self paddingtableifneeded];
    }
}

//-(void) getunreadrows
//{
//    NSArray *row=[contentTable indexPathsForVisibleRows];
//    for (int i=0; i<row.count; i++) {
//        NSIndexPath *indexpath=row[i];
//        InboxMessageRecord *object=[globalvariables.filteredMessageArray objectAtIndex:indexpath.row];
//        if ([object.type isEqualToString:@"received"] && ([object.recipient isEqualToString:globalvariables.username] || [object.recipient isEqualToString:@"center"]) && [object.readtime isEqualToString:@""] && ![readmessagearray containsObject:object.inboxmessagekey]) {
//            [readmessagearray addObject:object.inboxmessagekey];
//            object.readtime=@"Read";
//        }
//
//    }
//}

-(void) returnRecipientViewWithView:(UIView *)recipientview MessageRecord:(OutboxMessageRecord *)messagerecord HeightConstraint:(NSLayoutConstraint *)heightconstraint;
{
    UILabel *recipientlabel;
    UIImageView *recipientimage;
    int x=0;
    int y=0;
    int viewwidth=400;
    
    [recipientview.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    
    
    
    recipientlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    recipientlabel.numberOfLines=1;
    recipientlabel.font=[UIFont systemFontOfSize:14];
    recipientlabel.textAlignment=NSTextAlignmentCenter;
    recipientlabel.text=[MyClass returntitlewithtitle:messagerecord.recipienttype];
    [recipientlabel sizeToFit];
    
    if (x+recipientlabel.frame.size.width+20>viewwidth) {
        x=0;
        y+=1;
    }
    recipientlabel.frame=CGRectMake(x, y*27, recipientlabel.frame.size.width+20, 25);
    recipientimage=[[UIImageView alloc]initWithFrame:recipientlabel.frame];
    [recipientimage setImage:[UIImage imageNamed:@"gray_background"]];
    recipientimage.layer.opacity=0.5;
    recipientimage.layer.cornerRadius=5;
    recipientimage.layer.masksToBounds=YES;
    [recipientview addSubview:recipientimage];
    [recipientview addSubview:recipientlabel];
    x=recipientlabel.frame.origin.x+recipientlabel.frame.size.width+2;
    
    
    for (int i=0; i<messagerecord.recipientgroup.subjectarray.count; i++) {
        recipientlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        recipientlabel.numberOfLines=1;
        recipientlabel.font=[UIFont systemFontOfSize:14];
        recipientlabel.textAlignment=NSTextAlignmentCenter;
        recipientlabel.text=[MyClass returnsubjectnamewithsubject_shortname:[messagerecord.recipientgroup.subjectarray objectAtIndex:i] centerkey:globalvariables.centerrecord.centerkey];
        [recipientlabel sizeToFit];
        
        if (x+recipientlabel.frame.size.width+20>viewwidth) {
            x=0;
            y+=1;
        }
        recipientlabel.frame=CGRectMake(x, y*27, recipientlabel.frame.size.width+20, 25);
        recipientimage=[[UIImageView alloc]initWithFrame:recipientlabel.frame];
        [recipientimage setImage:[UIImage imageNamed:@"tiffany_background"]];
        recipientimage.layer.opacity=0.7;
        recipientimage.layer.cornerRadius=5;
        recipientimage.layer.masksToBounds=YES;
        [recipientview addSubview:recipientimage];
        [recipientview addSubview:recipientlabel];
        x=recipientlabel.frame.origin.x+recipientlabel.frame.size.width+2;
    }
    
    for (int i=0; i<messagerecord.recipientgroup.instructorarray.count; i++) {
        recipientlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        recipientlabel.numberOfLines=1;
        recipientlabel.font=[UIFont systemFontOfSize:14];
        recipientlabel.textAlignment=NSTextAlignmentCenter;
        recipientlabel.text=[MyClass returninstructornamewithusername:[messagerecord.recipientgroup.instructorarray objectAtIndex:i] firstorfullname:@"full"];
        [recipientlabel sizeToFit];
        if (x+recipientlabel.frame.size.width+20>viewwidth) {
            x=0;
            y+=1;
        }
        recipientlabel.frame=CGRectMake(x, y*27, recipientlabel.frame.size.width+20, 25);
        recipientimage=[[UIImageView alloc]initWithFrame:recipientlabel.frame];
        [recipientimage setImage:[UIImage imageNamed:@"blue_background"]];
        recipientimage.layer.opacity=0.5;
        recipientimage.layer.cornerRadius=5;
        recipientimage.layer.masksToBounds=YES;
        [recipientview addSubview:recipientimage];
        [recipientview addSubview:recipientlabel];
        x=recipientlabel.frame.origin.x+recipientlabel.frame.size.width+2;
        
    }
    
    for (int i=0; i<messagerecord.recipientgroup.classdatearray.count; i++) {
        recipientlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        recipientlabel.numberOfLines=1;
        recipientlabel.font=[UIFont systemFontOfSize:14];
        recipientlabel.textAlignment=NSTextAlignmentCenter;
        recipientlabel.text=[MyClass returndateformatwithdate:[messagerecord.recipientgroup.classdatearray objectAtIndex:i]];
        [recipientlabel sizeToFit];
        if (x+recipientlabel.frame.size.width+20>viewwidth) {
            x=0;
            y+=1;
        }
        recipientlabel.frame=CGRectMake(x, y*27, recipientlabel.frame.size.width+20, 25);
        recipientimage=[[UIImageView alloc]initWithFrame:recipientlabel.frame];
        [recipientimage setImage:[UIImage imageNamed:@"gray_background"]];
        recipientimage.layer.opacity=0.8;
        recipientimage.layer.cornerRadius=5;
        recipientimage.layer.masksToBounds=YES;
        [recipientview addSubview:recipientimage];
        [recipientview addSubview:recipientlabel];
        x=recipientlabel.frame.origin.x+recipientlabel.frame.size.width+2;
    }
    
    Student *studentobject;
    Lead *leadobject;
    
    for (int i=0; i<messagerecord.recipientgroup.individualarray.count; i++) {
        recipientlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        recipientlabel.numberOfLines=1;
        recipientlabel.font=[UIFont systemFontOfSize:14];
        recipientlabel.textAlignment=NSTextAlignmentCenter;
        if ([messagerecord.recipienttype isEqualToString:@"Student"]) {
            studentobject=[MyClass returnstudentwithstudentkey:[messagerecord.recipientgroup.individualarray objectAtIndex:i]];
            recipientlabel.text=[MyClass returnStudentnameWithStudentkey:studentobject.studentkey option:@"full"];
        }else if ([messagerecord.recipienttype isEqualToString:@"Lead"]){
            leadobject=[MyClass returnleadwithleadkey:[messagerecord.recipientgroup.individualarray objectAtIndex:i]];
            recipientlabel.text=[MyClass returnLeadnameWithLeadkey:leadobject.leadkey option:@"full"];
        }else{
            recipientlabel.text=[MyClass returnstaffnamewithusername:[messagerecord.recipientgroup.individualarray objectAtIndex:i] firstorfullname:@"full"];
        }
        
        [recipientlabel sizeToFit];
        if (x+recipientlabel.frame.size.width+20>viewwidth) {
            x=0;
            y+=1;
        }
        recipientlabel.frame=CGRectMake(x, y*27, recipientlabel.frame.size.width+20, 25);
        recipientimage=[[UIImageView alloc]initWithFrame:recipientlabel.frame];
        [recipientimage setImage:[UIImage imageNamed:@"orange_background"]];
        recipientimage.layer.opacity=0.7;
        recipientimage.layer.cornerRadius=5;
        recipientimage.layer.masksToBounds=YES;
        [recipientview addSubview:recipientimage];
        [recipientview addSubview:recipientlabel];
        x=recipientlabel.frame.origin.x+recipientlabel.frame.size.width+2;
    }
    
    for (int i=0; i<messagerecord.recipientgroup.gradearray.count; i++) {
        recipientlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        recipientlabel.numberOfLines=1;
        recipientlabel.font=[UIFont systemFontOfSize:14];
        recipientlabel.textAlignment=NSTextAlignmentCenter;
        recipientlabel.text=[MyClass returntitlewithtitle:[messagerecord.recipientgroup.gradearray objectAtIndex:i]];
        [recipientlabel sizeToFit];
        if (x+recipientlabel.frame.size.width+20>viewwidth) {
            x=0;
            y+=1;
        }
        recipientlabel.frame=CGRectMake(x, y*27, recipientlabel.frame.size.width+20, 25);
        recipientimage=[[UIImageView alloc]initWithFrame:recipientlabel.frame];
        [recipientimage setImage:[UIImage imageNamed:@"yellow_background"]];
        recipientimage.layer.opacity=0.5;
        recipientimage.layer.cornerRadius=5;
        recipientimage.layer.masksToBounds=YES;
        [recipientview addSubview:recipientimage];
        [recipientview addSubview:recipientlabel];
        x=recipientlabel.frame.origin.x+recipientlabel.frame.size.width+2;
    }
    
    for (int i=0; i<messagerecord.recipientgroup.studentstatusarray.count; i++) {
        recipientlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        recipientlabel.numberOfLines=1;
        recipientlabel.font=[UIFont systemFontOfSize:14];
        recipientlabel.textAlignment=NSTextAlignmentCenter;
        recipientlabel.text=[MyClass returntitlewithtitle:[messagerecord.recipientgroup.studentstatusarray objectAtIndex:i]];
        [recipientlabel sizeToFit];
        if (x+recipientlabel.frame.size.width+20>viewwidth) {
            x=0;
            y+=1;
        }
        recipientlabel.frame=CGRectMake(x, y*27, recipientlabel.frame.size.width+20, 25);
        recipientimage=[[UIImageView alloc]initWithFrame:recipientlabel.frame];
        [recipientimage setImage:[UIImage imageNamed:@"red_background"]];
        recipientimage.layer.opacity=0.5;
        recipientimage.layer.cornerRadius=5;
        recipientimage.layer.masksToBounds=YES;
        [recipientview addSubview:recipientimage];
        [recipientview addSubview:recipientlabel];
        x=recipientlabel.frame.origin.x+recipientlabel.frame.size.width+2;
    }
    
    for (int i=0; i<messagerecord.recipientgroup.leadstatusarray.count; i++) {
        recipientlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        recipientlabel.numberOfLines=1;
        recipientlabel.font=[UIFont systemFontOfSize:14];
        recipientlabel.textAlignment=NSTextAlignmentCenter;
        recipientlabel.text=[MyClass returntitlewithtitle:[messagerecord.recipientgroup.leadstatusarray objectAtIndex:i]];
        [recipientlabel sizeToFit];
        if (x+recipientlabel.frame.size.width+20>viewwidth) {
            x=0;
            y+=1;
        }
        recipientlabel.frame=CGRectMake(x, y*27, recipientlabel.frame.size.width+20, 25);
        recipientimage=[[UIImageView alloc]initWithFrame:recipientlabel.frame];
        [recipientimage setImage:[UIImage imageNamed:@"red_background"]];
        recipientimage.layer.opacity=0.5;
        recipientimage.layer.cornerRadius=5;
        recipientimage.layer.masksToBounds=YES;
        [recipientview addSubview:recipientimage];
        [recipientview addSubview:recipientlabel];
        x=recipientlabel.frame.origin.x+recipientlabel.frame.size.width+2;
    }
    
    for (int i=0; i<messagerecord.recipientgroup.staffgrouparray.count; i++) {
        recipientlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        recipientlabel.numberOfLines=1;
        recipientlabel.font=[UIFont systemFontOfSize:14];
        recipientlabel.textAlignment=NSTextAlignmentCenter;
        recipientlabel.attributedText=[MyClass returngrouparraylabel:[[NSMutableArray alloc]initWithObjects:[messagerecord.recipientgroup.staffgrouparray objectAtIndex:i], nil] grouparray:staffgrouparray option:@"groupkey"];
        [recipientlabel sizeToFit];
        if (x+recipientlabel.frame.size.width+20>viewwidth) {
            x=0;
            y+=1;
        }
        recipientlabel.frame=CGRectMake(x, y*27, recipientlabel.frame.size.width+20, 25);
        recipientimage=[[UIImageView alloc]initWithFrame:recipientlabel.frame];
        [recipientimage setImage:[UIImage imageNamed:@"gray_background"]];
        recipientimage.layer.opacity=0.8;
        recipientimage.layer.cornerRadius=5;
        recipientimage.layer.masksToBounds=YES;
        [recipientview addSubview:recipientimage];
        [recipientview addSubview:recipientlabel];
        x=recipientlabel.frame.origin.x+recipientlabel.frame.size.width+2;
    }
    
    for (int i=0; i<messagerecord.recipientgroup.droparray.count; i++) {
        recipientlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
        recipientlabel.numberOfLines=1;
        recipientlabel.font=[UIFont systemFontOfSize:14];
        recipientlabel.textAlignment=NSTextAlignmentCenter;
        recipientlabel.text=[MyClass returntitlewithtitle:[messagerecord.recipientgroup.droparray objectAtIndex:i]];
        [recipientlabel sizeToFit];
        if (x+recipientlabel.frame.size.width+20>viewwidth) {
            x=0;
            y+=1;
        }
        recipientlabel.frame=CGRectMake(x, y*27, recipientlabel.frame.size.width+20, 25);
        recipientimage=[[UIImageView alloc]initWithFrame:recipientlabel.frame];
        [recipientimage setImage:[UIImage imageNamed:@"orange_background"]];
        recipientimage.layer.opacity=0.8;
        recipientimage.layer.cornerRadius=5;
        recipientimage.layer.masksToBounds=YES;
        [recipientview addSubview:recipientimage];
        [recipientview addSubview:recipientlabel];
        x=recipientlabel.frame.origin.x+recipientlabel.frame.size.width+2;
    }
    
    heightconstraint.constant=(y+1)*27;
    //recipientview.frame=CGRectMake(recipientview.frame.origin.x, recipientview.frame.origin.y, viewwidth, (y+1)*27);
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self stopAudioPlaying];
    if (searchBar==messagesearchbar) {
        [self returnfilteredMessageArray];
    }else if (searchBar==contactlistsearchbar){
        [self returnFilteredMessageContactArrayWithSearchText:searchText];
    }
}

-(void) showinstantmessageactions:(UIButton *)button
{
    [self stopAudioPlaying];
    
    if(selectMode){
        [self selectMessageWithIndex:button.tag];
        return;
    }
    
    InboxMessageRecord *obj=[globalvariables.filteredMessageArray objectAtIndex:button.tag];
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

-(void) showcontactlistaction:(UIButton *)button
{
    [self stopAudioPlaying];
    
    NSMutableArray *actionarray;
    
    MessageContactRecord *obj=[FilteredMessageContactArray objectAtIndex:button.tag];
    if([obj.unreadcount integerValue]!=0){
        actionarray=[[NSMutableArray alloc]initWithObjects:@"Mark as Read", nil];
    }else{
        actionarray=[[NSMutableArray alloc]initWithObjects:@"Mark as Unread", nil];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"ContactListAction" DataIndex:button.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(180, 40*actionarray.count) View:self Button:button ItemsArray:actionarray Title:nil];
}

-(void) showgroupmessageactions:(UIButton *)button
{
    [self stopAudioPlaying];
    OutboxMessageRecord *obj=[filteredOutboxMessageArray objectAtIndex:button.tag];
    NSMutableArray *actionarray;
    if ([MyClass isMessageSentWithMessageSentTime:obj.messagestarttime] && ![obj.status isEqualToString:@"D"]) {
        //actionarray=[[NSMutableArray alloc]initWithObjects:@"Message Info",@"Recipients",@"Delete", nil];
        if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).deletemessage) {
            actionarray=[[NSMutableArray alloc]initWithObjects:@"Message Info",@"Recipients",@"Copy",@"Delete", nil];
        }else{
            actionarray=[[NSMutableArray alloc]initWithObjects:@"Message Info",@"Recipients",@"Copy", nil];
        }
    }else{
        //actionarray=[[NSMutableArray alloc]initWithObjects:@"Message Info",@"Delete", nil];
        if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).deletemessage) {
            actionarray=[[NSMutableArray alloc]initWithObjects:@"Message Info",@"Delete", nil];
        }else{
            actionarray=[[NSMutableArray alloc]initWithObjects:@"Message Info", nil];
        }
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"GroupMessageAction" DataIndex:button.tag ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(180, 40*actionarray.count) View:self Button:button ItemsArray:actionarray Title:nil];
    
}

- (void)markMessageAsUnread:(NSInteger)row {
    
    MessageContactRecord *obj=[FilteredMessageContactArray objectAtIndex:row];
    
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
        [dictionary setValue:@"updateoutboxmessage2" forKey:@"postaction"];
        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
        [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dictionary setValue:@"markasunread" forKey:@"action"];
        [dictionary setValue:@"center" forKey:@"apptype"];
        [dictionary setValue:obj.messagecontacttype forKey:@"messagecontacttype"];
        [dictionary setValue:obj.messagecontact forKey:@"messagecontact"];
        
        __block BOOL result=FALSE;
        __block NSData *returndata;
        
        [MyClass callMultipartPOSTwithDict:dictionary photoArray:workingMessage.photoarray completionBlock:^(id responseObject, NSError *error) {
            if (!error) {
                result=TRUE;
                returndata=responseObject;
            }
        }];
        
        if (result) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if([obj.messagecontact isEqualToString:globalvariables.selectedmessagecontact.messagecontact]){
                    globalvariables.selectedmessagecontact=nil;
                }
                obj.unreadcount=@"-1";
                obj.unreadcountsort=@"1";
                
                char *err;
                NSString *sql=[NSString stringWithFormat:@"UPDATE messagecontact SET unreadcount='%@',unreadcountsort='%@' where messagecontact='%@'",@"-1",@"1",obj.messagecontact];
                sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,&err);
                [contactlisttable reloadData];
                [contactlisttable layoutIfNeeded];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                //                    [self reloadmessageview];
            });
        }else{
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            [MyClass showconnectionlostdialogbox];
        }
        
    });
    
    
    
    
}

- (void)markMessageAsRead:(NSInteger)row {
    
    MessageContactRecord *obj=[FilteredMessageContactArray objectAtIndex:row];
    
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
        [dictionary setValue:@"updateoutboxmessage2" forKey:@"postaction"];
        [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
        [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
        [dictionary setValue:@"markasread" forKey:@"action"];
        [dictionary setValue:@"center" forKey:@"apptype"];
        [dictionary setValue:obj.messagecontacttype forKey:@"messagecontacttype"];
        [dictionary setValue:obj.messagecontact forKey:@"messagecontact"];
        
        __block BOOL result=FALSE;
        __block NSData *returndata;
        
        [MyClass callMultipartPOSTwithDict:dictionary photoArray:workingMessage.photoarray completionBlock:^(id responseObject, NSError *error) {
            if (!error) {
                result=TRUE;
                returndata=responseObject;
            }
        }];
        
        if (result) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if([obj.messagecontact isEqualToString:globalvariables.selectedmessagecontact.messagecontact]){
                    globalvariables.selectedmessagecontact=nil;
                }
                obj.unreadcount=@"0";
                obj.unreadcountsort=@"0";
                
                char *err;
                NSString *sql=[NSString stringWithFormat:@"UPDATE messagecontact SET unreadcount='%@',unreadcountsort='%@' where messagecontact='%@'",@"0",@"0",obj.messagecontact];
                sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,&err);
                [contactlisttable reloadData];
                [contactlisttable layoutIfNeeded];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                //                    [self reloadmessageview];
            });
        }else{
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            [MyClass showconnectionlostdialogbox];
        }
        
    });
    
    
    
    
}

- (void)deleteGroupMessage:(NSInteger)row {
    
    OutboxMessageRecord *obj=[filteredOutboxMessageArray objectAtIndex:row];
    
    UIAlertController *disablealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Message Record"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the message record?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
            [dictionary setValue:@"updateoutboxmessage2" forKey:@"postaction"];
            [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
            [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
            [dictionary setValue:@"Delete" forKey:@"action"];
            [dictionary setValue:@"Yes" forKey:@"removeinboxmessage"];
            
            [dictionary setValue:obj.outboxmessagekey forKey:@"outboxmessagekey"];
            
            __block BOOL result=FALSE;
            __block NSData *returndata;
            
            [MyClass callMultipartPOSTwithDict:dictionary photoArray:workingMessage.photoarray completionBlock:^(id responseObject, NSError *error) {
                if (!error) {
                    result=TRUE;
                    returndata=responseObject;
                }
            }];
            
            if (result) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self reloadmessageview];
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

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if (([datatype isEqualToString:@"GroupMessageAction"])){
        NSString *result=[selecteditems firstObject];
        
        if ([result isEqualToString:@"Recipients"]) {
            [self showreadstatus:dataindex];
        }else if ([result isEqualToString:@"Delete"]){
            [self deleteGroupMessage:dataindex];
        }else if ([result isEqualToString:@"Message Info"]){
            [self startsidewindowanimationwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MessagePopoverViewController *messagepopover = (MessagePopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MessagePopoverViewController"];
                messagepopover.delegate=self;
                messagepopover.MessageTableMode=@"View";
                messagepopover.CallingSource=@"MessageView";
                messagepopover.OMessageRecordObject=[filteredOutboxMessageArray objectAtIndex:dataindex];
                messagepopover.allstudentarray=allstudentarray;
                messagepopover.allleadarray=allleadarray;
                messagepopover.allstaffarray=allstaffarray;
                messagepopover.staffgrouparray=staffgrouparray;
                
                messagepopover.view.frame=self->sidewindowview.bounds;
                [self->sidewindowview addSubview:messagepopover.view];
                [self addChildViewController:messagepopover];
                [messagepopover didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });
        }else if ([result isEqualToString:@"Copy"]){
            [self startsidewindowanimationwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                MessagePopoverViewController *messagepopover = (MessagePopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MessagePopoverViewController"];
                messagepopover.delegate=self;
                messagepopover.MessageTableMode=@"Copy";
                messagepopover.CallingSource=@"MessageView";
                messagepopover.OMessageRecordObject=[filteredOutboxMessageArray objectAtIndex:dataindex];
                messagepopover.allstudentarray=allstudentarray;
                messagepopover.allleadarray=allleadarray;
                messagepopover.allstaffarray=allstaffarray;
                messagepopover.staffgrouparray=staffgrouparray;
                
                messagepopover.view.frame=self->sidewindowview.bounds;
                [self->sidewindowview addSubview:messagepopover.view];
                [self addChildViewController:messagepopover];
                [messagepopover didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });
        }
    }else if ([datatype isEqualToString:@"InstantMessageAction"]){
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
            
            //            [self retrievenewmessagecontact];
            //            [self startsidewindowanimationwithwidth:320];
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //                PickerViewController *pickerviewcontroller = (PickerViewController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil] instantiateViewControllerWithIdentifier: @"PickerViewController"];
            //                pickerviewcontroller.delegate=self;
            //                pickerviewcontroller.selecteditems=[[NSMutableArray alloc]init];
            //                pickerviewcontroller.datatype=@"MessageContact";
            //                pickerviewcontroller.showsearchbar=YES;
            //                pickerviewcontroller.bottommode=@"Forward";
            //                pickerviewcontroller.viewtitle=@"New Contact";
            //                pickerviewcontroller.preferredContentSize=CGSizeMake(320, 40*NewContactArray.count);
            //                pickerviewcontroller.itemsarray=NewContactArray;
            //                pickerviewcontroller.multipleSelection=YES;
            //
            //                CGRect frame=mainWindow.bounds;
            //                frame.size.width=320;
            //                pickerviewcontroller.view.frame=frame;
            //                [self->sidewindowview addSubview:pickerviewcontroller.view];
            //                [self addChildViewController:pickerviewcontroller];
            //                [pickerviewcontroller didMoveToParentViewController:self];
            //                [self->ailoadindicator stopAnimating];
            //                self->ailoadindicator.hidden=YES;
            //            });
            //
            //            forwardmessagerecord =[globalvariables.filteredMessageArray objectAtIndex:dataindex];
        }else if ([result isEqualToString:@"Resend"]){
            InboxMessageRecord *resendrecord =[globalvariables.filteredMessageArray objectAtIndex:dataindex];
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
        }else if ([result isEqualToString:@"Reply"]){
            replyToMessageRecord=[globalvariables.filteredMessageArray objectAtIndex:dataindex];
            
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
    }else if ([datatype isEqualToString:@"ContactListAction"]){
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"Mark as Unread"]) {
            [self markMessageAsUnread:dataindex];
        }else if ([result isEqualToString:@"Mark as Read"]) {
            [self markMessageAsRead:dataindex];
        }
    }else if (([datatype isEqualToString:@"GroupMessageAction"])){
        NSString *result=[selecteditems firstObject];
        
        if ([result isEqualToString:@"Read Status"]) {
            [self showreadstatusdetails:dataindex];
        }else if ([result isEqualToString:@"Delete"]){
            selectMode=@"Delete";
            [self selectMessageWithIndex:dataindex];
            selectStatusView.hidden=NO;
            deleteMessageButton.hidden=NO;
//            [self deleteInstantMessage:dataindex];
        }else if ([result isEqualToString:@"Message Info"]){
            [self startsidewindowanimationwithwidth:320];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                OutboxMessageRecord *messagerecordobject=[filteredOutboxMessageArray objectAtIndex:dataindex];
                MessagePopoverViewController *messagepopover = (MessagePopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"MessagePopoverViewController"];
                messagepopover.delegate=self;
                messagepopover.MessageTableMode=@"View";
                messagepopover.CallingSource=@"MessageView";
                messagepopover.OMessageRecordObject=messagerecordobject;
                messagepopover.allstudentarray=allstudentarray;
                messagepopover.allleadarray=allleadarray;
                messagepopover.allstaffarray=allstaffarray;
                messagepopover.staffgrouparray=staffgrouparray;
                
                messagepopover.view.frame=self->sidewindowview.bounds;
                [self->sidewindowview addSubview:messagepopover.view];
                [self addChildViewController:messagepopover];
                [messagepopover didMoveToParentViewController:self];
                [self->ailoadindicator stopAnimating];
                ailoadindicator.hidden=YES;
            });
        }
    }else if ([datatype isEqualToString:@"MessageContact"]) {
        [self closesidewindow];
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        globalvariables.selectedmessagecontact=[selecteditems firstObject];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrievemessagelistwithmessagecontact:globalvariables.selectedmessagecontact];
            
            textinputbox.hidden=NO;
            instantmessagetopbox.hidden=NO;
            [self updateinstantmessagetopbox];
            [contentTable reloadData];
            [contactlisttable reloadData];
        });
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

-(void) pickerBottomButtonPressedWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex BottomMode:(NSString *)bottommode SelectedItems:(NSMutableArray *)selecteditems
{
    if ([datatype isEqualToString:@"MessageContact"]) {
        if ([bottommode isEqualToString:@"Forward"]) {
            [self closesidewindow];
            [self forwardMessage:selecteditems];
        }else if ([bottommode isEqualToString:@"New Group"]){
            [self closesidewindow];
            staffgroupviewcontroller = (StaffGroupViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"StaffGroupViewController"];
            staffgroupviewcontroller.delegate=self;
            staffgroupviewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:staffgroupviewcontroller animated:YES completion: nil];
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
                [contentTable reloadData];
                selectedinboxmessages=[[NSMutableArray alloc]init];
                selectedoutboxmessages=[[NSMutableArray alloc]init];
                [self retrievemessagecontactlistwithcenterkey:nil];
            });
        }else{
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            [MyClass showconnectionlostdialogbox];
        }
    });
}

-(void) retrievemessagecontactlistwithcenterkey:(NSString *)centerkey
{
    if(!globalvariables){
        globalvariables=[GlobalVariables singleObj];
    }
    NSArray *jsoncenterkeyarray=[[NSArray alloc]init];
    NSMutableArray *arrayOfDicts = [[NSMutableArray alloc] init];
    NSMutableDictionary *dict;
    
    NSArray *centerkeysarray=[centerkey?centerkey:globalvariables.centerrecord.centerkey componentsSeparatedByString:@","];
    NSArray *viewedcenterkeysarray=[globalvariables.centerrecord.centerkey componentsSeparatedByString:@","];
    for (int i=0; i<centerkeysarray.count; i++) {
        NSString *_centerkey=centerkeysarray[i];
        if([viewedcenterkeysarray containsObject:_centerkey]){
            dict= [[NSMutableDictionary alloc]init];
            [dict setValue:_centerkey forKey:@"centerkey"];
            [dict setValue:[MyClass retrievedevicelastupdaterecordwithparameter:@"messagecontact" centerkey:centerkeysarray[i]] forKey:@"lastupdatetime"];
            [arrayOfDicts addObject:dict];
        }
    }
    jsoncenterkeyarray=[NSArray arrayWithArray:arrayOfDicts];
    
    if(jsoncenterkeyarray.count==0){
        return;
    }
    
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setValue:@"retrievemessagecontactlist4" forKey:@"postaction"];
    [dictionary setValue:globalvariables.centerrecord.centerdb forKey:@"centerdb"];
    [dictionary setValue:globalvariables.centerrecord.centerkey forKey:@"centerkey"];
    [dictionary setValue:globalvariables.username forKey:@"username"];
    [dictionary setValue:@"center" forKey:@"apptype"];
    [dictionary setValue:showsystemmessage?@"Y":@"N" forKey:@"showsystemmessage"];
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
        
        NSString *sql;
        char *err;
        sqlite3_stmt *stmt;
        char *csql;
        
        MessageContactArray=[[NSMutableArray alloc]init];
        
        NSArray *jsonmessagelistarray = jsondictionary[@"messagelistrecords"];
        NSString *timestamptobestored = jsondictionary[@"timestamptobestored"];
        NSArray *jsonflushcenterarray = jsondictionary[@"flushcenterrecords"];
        
        NSLog(@"checknewmessagecontact");
        
        if(jsonflushcenterarray.count>0){
            NSLog(@"flush message");
            NSArray *centerKeys = [jsonflushcenterarray valueForKey:@"centerkey"];
            // Wrap each key in single quotes: '604', '8'
            NSMutableArray *quotedKeys = [NSMutableArray array];
            for (id key in centerKeys) {
                [quotedKeys addObject:[NSString stringWithFormat:@"'%@'", key]];
            }
            NSString *centerKeysString = [quotedKeys componentsJoinedByString:@", "];

            sql = [NSString stringWithFormat:@"DELETE FROM messagecontact WHERE centerkey IN (%@)", centerKeysString];
            sqlite3_exec(globalvariables.isdb, [sql UTF8String], NULL, NULL, &err);
            
            // Convert valid centerkeys to NSString for matching prefix strings
            NSMutableArray *validKeyStrings = [NSMutableArray arrayWithCapacity:centerKeys.count];
            for (id key in centerKeys) {
                [validKeyStrings addObject:[key description]];
            }
            
            // Collect all top-level keys matching the "centerkey#..." pattern
            NSSet *keysToRemove = [globalvariables.messagecontactlist keysOfEntriesPassingTest:^BOOL(NSString *key, id obj, BOOL *stop) {
                NSArray *keyComponents = [key componentsSeparatedByString:@"#"];
                if (keyComponents.count > 0) {
                    NSString *extractedCenterKey = keyComponents[0];
                    return [validKeyStrings containsObject:extractedCenterKey];
                }
                return NO;
            }];
            
            // Mutate messagecontactlist directly in place
            if (keysToRemove.count > 0) {
                [globalvariables.messagecontactlist removeObjectsForKeys:[keysToRemove allObjects]];
                NSLog(@"Removed %lu items from messagecontactlist", (unsigned long)keysToRemove.count);
            }
        }
        
        if(jsonmessagelistarray.count>0){
            NSLog(@"updatemessagecontact");
            sql = [NSString stringWithFormat:@"delete from tempmessagecontact"];
            sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,&err);
            
            csql="insert into tempmessagecontact ('centerkey','messagecontact') values (?,?)";
            if (sqlite3_prepare_v2(globalvariables.isdb, csql, -1, &stmt, NULL) == SQLITE_OK){
                sqlite3_exec(globalvariables.isdb, "BEGIN TRANSACTION", NULL, NULL, NULL);
                for (int i=0;i<jsonmessagelistarray.count;i++){
                    NSString * messagecontact=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"messagecontact"];
                    NSString * centerkey=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"centerkey"];
                    
                    sqlite3_bind_text(stmt, 1, [centerkey UTF8String], -1, NULL);
                    sqlite3_bind_text(stmt, 2, [messagecontact UTF8String], -1, NULL);
                    
                    sqlite3_step(stmt);
                    sqlite3_reset(stmt);
                }
                
                sqlite3_exec(globalvariables.isdb, "END TRANSACTION", NULL, NULL, NULL);
                sqlite3_finalize(stmt);
                
                //remove old data from db
                sql=[NSString stringWithFormat:@"delete from messagecontact where messagecontactkey in (select messagecontactkey from messagecontact mc join tempmessagecontact tmp on tmp.centerkey=mc.centerkey and mc.messagecontact=tmp.messagecontact)"];
//                sql=[NSString stringWithFormat:@"DELETE mc FROM messagecontact mc JOIN tempmessagecontact tmp ON tmp.centerkey = mc.centerkey AND tmp.messagecontact = mc.messagecontact"];
                sqlite3_exec(globalvariables.isdb,[sql UTF8String],NULL,NULL,&err);
            }
            
            csql="INSERT INTO messagecontact ('outboxmessagekey','centerkey','readstatus','channel','unreadcount','messagetype','messagecontacttype','messagestarttime','type','messagecontact','attachmenttypes','recipient','messageenglish','messagechinese','sender','unreadcountsort') VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            if (sqlite3_prepare_v2(globalvariables.isdb, csql, -1, &stmt, NULL) == SQLITE_OK){
                sqlite3_exec(globalvariables.isdb, "BEGIN TRANSACTION", NULL, NULL, NULL);
                
                for (int i=0;i<jsonmessagelistarray.count;i++){
                    NSString * centerkey=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"centerkey"];
                    NSString * outboxmessagekey=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"outboxmessagekey"];
                    NSString * messageenglish=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"messageenglish"];
                    NSString * messagechinese=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"messagechinese"];
                    NSString * messagetype=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"messagetype"];
                    NSString * messagestarttime=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"messagestarttime"];
                    NSString * unreadcount=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"unreadcount"];
                    NSString * readstatus=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"readstatus"];
                    NSString * messagecontact=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"messagecontact"];
                    NSString * messagecontacttype=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"messagecontacttype"];
                    NSString * recipient=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"recipient"];
                    NSString * sender=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"sender"];
                    NSString * channel=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"channel"];
                    NSString * type=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"type"];
                    NSString * attachmenttypes=[[jsonmessagelistarray objectAtIndex:i] objectForKey:@"attachmenttypes"];
                    NSArray * attachmenttypesarray=[attachmenttypes componentsSeparatedByString:@","];
                    NSString *unreadcountsort;
                    if([unreadcount integerValue]>0){
                        unreadcountsort=@"2";
                    }else if ([unreadcount integerValue]==0){
                        unreadcountsort=@"0";
                    }else{
                        unreadcountsort=@"1";
                    }
                    
                    if([type isEqualToString:@"remove"]){
                        [globalvariables.messagecontactlist removeObjectForKey:[NSString stringWithFormat:@"%@#%@",centerkey,messagecontact]];
                    }else{
                        [globalvariables.messagecontactlist setValue:[[MessageContactRecord alloc]initMessageContactRecordwithcenterkey:centerkey messagecontact:messagecontact messagetype:messagetype messagestarttime:messagestarttime unreadcount:unreadcount attachmenttypes:attachmenttypesarray readstatus:readstatus  type:type messagecontacttype:messagecontacttype sender:sender recipient:recipient channel:channel  unreadcountsort:unreadcountsort messageenglish:messageenglish messagechinese:messagechinese outboxmessagekey:outboxmessagekey messagecontactdisplayname:nil] forKey:[NSString stringWithFormat:@"%@#%@",centerkey,messagecontact]];
                        
                        sqlite3_bind_text(stmt, 1, [outboxmessagekey UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 2, [centerkey UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 3, [readstatus UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 4, [channel UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 5, [unreadcount UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 6, [messagetype UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 7, [messagecontacttype UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 8, [messagestarttime UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 9, [type UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 10, [messagecontact UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 11, [attachmenttypes UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 12, [recipient UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 13, [messageenglish UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 14, [messagechinese UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 15, [sender UTF8String], -1, NULL);
                        sqlite3_bind_text(stmt, 16, [unreadcountsort UTF8String], -1, NULL);
                        
                        sqlite3_step(stmt);
                        sqlite3_reset(stmt);
                    }
                }
                
                sqlite3_exec(globalvariables.isdb, "END TRANSACTION", NULL, NULL, NULL);
                sqlite3_finalize(stmt);
            }
        }
        
        [MyClass updatedevicelastupdatetimewithparameter:@"messagecontact" centerkeyarray:[globalvariables.centerrecord.centerkey componentsSeparatedByString:@","] systemcurrenttime:timestamptobestored];
        
        
        [self refreshMessageContact];
    }
    
    //[tablerefresh endRefreshing];
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
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

-(void) refreshMessageContact
{
    MessageContactArray=[[NSMutableArray alloc]initWithArray:[globalvariables.messagecontactlist allValues]];
    
    NSPredicate * newCondition;
    NSPredicate *predicate;
    NSMutableArray *nsPredicatearray=[[NSMutableArray alloc]init];
    
    newCondition = [NSPredicate predicateWithFormat:@"self.centerkey in %@",[globalvariables.centerrecord.centerkey componentsSeparatedByString:@","]];
    [nsPredicatearray addObject:newCondition];
    
    
    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:[NSArray arrayWithArray:nsPredicatearray]];
    MessageContactArray= [[NSMutableArray alloc]initWithArray:[MessageContactArray filteredArrayUsingPredicate:predicate]];
    
    NSSortDescriptor *sortByunreadcountsort = [NSSortDescriptor sortDescriptorWithKey:@"unreadcountsort" ascending:NO selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortBymessagestarttime = [NSSortDescriptor sortDescriptorWithKey:@"messagestarttime" ascending:NO selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortByoutboxmessagekey = [NSSortDescriptor sortDescriptorWithKey:@"outboxmessagekey" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSSortDescriptor *sortByrecipient = [NSSortDescriptor sortDescriptorWithKey:@"recipient" ascending:YES selector:@selector(localizedStandardCompare:)];
    NSArray *sortDescriptors0 = @[sortByunreadcountsort,sortBymessagestarttime,sortByoutboxmessagekey,sortByrecipient];
    MessageContactArray = [NSMutableArray arrayWithArray:[MessageContactArray sortedArrayUsingDescriptors:sortDescriptors0]];
    
    
    [self returnFilteredMessageContactArrayWithSearchText:contactlistsearchbar.text];
}

-(void) returnFilteredMessageContactArrayWithSearchText:(NSString *)searchtext
{
    if ([searchtext isEqualToString:@""] || !searchtext) {
        FilteredMessageContactArray= [[NSMutableArray alloc]initWithArray:MessageContactArray];
    }else{
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(MessageContactRecord *messagecontactrecord, NSDictionary *bindings) {
            
            NSString * messagecontactdisplayname;
            NSString * messagecontactid=@"";
            NSString *messagestaffname=@"";
            NSString *messagestaffid=@"";
            
            if ([messagecontactrecord.messagecontacttype isEqualToString:@"Center"]) {
                messagecontactdisplayname=[MyClass returncentershortnamewithcenterkey:messagecontactrecord.centerkey];
            }else if ([messagecontactrecord.messagecontacttype isEqualToString:@"Staff"]){
                messagecontactdisplayname=[MyClass returnstaffnamewithusername:messagecontactrecord.messagecontact firstorfullname:@"full"];
            }else if ([messagecontactrecord.messagecontacttype isEqualToString:@"Student"]){
                messagecontactdisplayname=[MyClass returnStudentnameWithStudentkey:messagecontactrecord.messagecontact option:@"full"];
                messagecontactid=((Student *)[MyClass returnstudentwithstudentkey:messagecontactrecord.messagecontact]).studentid;
            }else if ([messagecontactrecord.messagecontacttype isEqualToString:@"Lead"]){
                messagecontactdisplayname=[MyClass returnLeadnameWithLeadkey:messagecontactrecord.messagecontact option:@"full"];
                messagecontactid=((Lead *)[MyClass returnleadwithleadkey:messagecontactrecord.messagecontact]).leadid;
            }else if ([messagecontactrecord.messagecontacttype isEqualToString:@"Group"]){
                messagecontactdisplayname=((GroupRecord *)[MyClass returngrouprecordwithgrouparray:allstaffgrouparray groupkey:messagecontactrecord.messagecontact]).groupname;
            }
            
            NSRange recipientrange=[messagecontactrecord.recipient rangeOfString:@"@"];
            NSRange senderrange=[messagecontactrecord.sender rangeOfString:@"@"];
            if(recipientrange.location!=NSNotFound){
                messagestaffname=[MyClass returnstaffnamewithusername:messagecontactrecord.recipient firstorfullname:@"full"];
                messagestaffid=messagecontactrecord.recipient;
            }else if (senderrange.location!=NSNotFound){
                messagestaffname=[MyClass returnstaffnamewithusername:messagecontactrecord.sender firstorfullname:@"full"];
                messagestaffid=messagecontactrecord.sender;
            }
            
            return [messagecontactdisplayname rangeOfString:searchtext options:NSCaseInsensitiveSearch].location!=NSNotFound || [messagecontactid rangeOfString:searchtext options:NSCaseInsensitiveSearch].location!=NSNotFound || [messagecontactrecord.messagechinese rangeOfString:searchtext options:NSCaseInsensitiveSearch].location!=NSNotFound || [messagecontactrecord.messageenglish rangeOfString:searchtext options:NSCaseInsensitiveSearch].location!=NSNotFound || [messagecontactrecord.messagecontact rangeOfString:searchtext options:NSCaseInsensitiveSearch].location!=NSNotFound || [messagestaffname rangeOfString:searchtext options:NSCaseInsensitiveSearch].location!=NSNotFound || [messagestaffname rangeOfString:searchtext options:NSCaseInsensitiveSearch].location!=NSNotFound || [messagestaffid rangeOfString:searchtext options:NSCaseInsensitiveSearch].location!=NSNotFound;
        }];
        FilteredMessageContactArray= [[NSMutableArray alloc]initWithArray:[MessageContactArray filteredArrayUsingPredicate:predicate]];
    }
    
    [contactlisttable reloadData];
    [contentTable reloadData];
}


-(void) showreadstatusdetails:(NSInteger)row
{
    if (scmessageview.selectedSegmentIndex==0) {
        InboxMessageRecord *obj=[globalvariables.filteredMessageArray objectAtIndex:row];
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
            pickerviewcontroller.view.frame=self->sidewindowview.bounds;
            [self->sidewindowview addSubview:pickerviewcontroller.view];
            [self addChildViewController:pickerviewcontroller];
            [pickerviewcontroller didMoveToParentViewController:self];
            [self->ailoadindicator stopAnimating];
            self->ailoadindicator.hidden=YES;
        });
    }
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

        pickerviewcontroller.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:pickerviewcontroller.view];
        [self addChildViewController:pickerviewcontroller];
        [pickerviewcontroller didMoveToParentViewController:self];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
}

- (IBAction)deleteMessageButtonPressed:(UIButton *)sender
{
//    InboxMessageRecord *obj=[globalvariables.filteredMessageArray objectAtIndex:row];
    UIAlertController *disablealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Delete Message Record"] message:[MyClass returntitlewithtitle:@"Are you sure to delete the message record?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        
        NSString *inboxmessagekeys=@"";
        if (selectedinboxmessages.count>0) {
            inboxmessagekeys=[selectedinboxmessages componentsJoinedByString:@","];
        }
        
        
        for (int i=0; i<globalvariables.messageArray.count; i++) {
            if ([selectedinboxmessages containsObject:((InboxMessageRecord *)[globalvariables.messageArray objectAtIndex:i]).inboxmessagekey]) {
                [globalvariables.messageArray removeObjectAtIndex:i];
                i--;
            }else if ([selectedoutboxmessages containsObject:((InboxMessageRecord *)[globalvariables.messageArray objectAtIndex:i]).outboxmessagekey]) {
                [globalvariables.messageArray removeObjectAtIndex:i];
                i--;
            }
        }

        for (int i=0; i<globalvariables.filteredMessageArray.count; i++) {
            if ([selectedinboxmessages containsObject:((InboxMessageRecord *)[globalvariables.filteredMessageArray objectAtIndex:i]).inboxmessagekey]) {
                [globalvariables.filteredMessageArray removeObjectAtIndex:i];
                i--;
            }else if ([selectedoutboxmessages containsObject:((InboxMessageRecord *)[globalvariables.filteredMessageArray objectAtIndex:i]).outboxmessagekey]) {
                [globalvariables.filteredMessageArray removeObjectAtIndex:i];
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
            
            //[dictionary setValue:obj.outboxmessagekey forKey:@"outboxmessagekey"];
            [dictionary setValue:inboxmessagekeys forKey:@"inboxmessagekey"];
            
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
                    [contentTable reloadData];
                    selectedinboxmessages=[[NSMutableArray alloc]init];
                    selectedoutboxmessages=[[NSMutableArray alloc]init];
                    [self retrievemessagecontactlistwithcenterkey:nil];
//                    [self retrievemessagelistwithmessagecontact:globalvariables.selectedmessagecontact];
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

-(void) showreadstatus:(NSInteger)row
{
    
    OutboxMessageRecord *OMessageRecordObject=[filteredOutboxMessageArray objectAtIndex:row];

    __block NSMutableArray *allreadstatusarray;
    
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&action=retrievereadmessagestatus2&outboxmessagekey=%@&recipienttype=%@&centerkey=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,OMessageRecordObject.outboxmessagekey,OMessageRecordObject.recipienttype,globalvariables.centerrecord.centerkey];
    
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSArray *JSONArray = jsonreturned[@"content"];
            
            allreadstatusarray=[[NSMutableArray alloc]init];
            
            //loop through our jsonArray
            
            NSString * creadtime;
            NSString * cchannel;
            NSString * crecipientid;
            NSString * crecipientkey;
            NSString * crecipientname;
            NSString * cgender;
            NSString * cimage;
            NSString * ccenterkey;
            
            NSString *ccontact;
            NSString *crelationship;
            NSString *ciso_code;
            
            for (int i=0; i<JSONArray.count; i++) {
                
                creadtime=[[JSONArray objectAtIndex:i] objectForKey:@"readtime"];
                cchannel=[[JSONArray objectAtIndex:i] objectForKey:@"channel"];
                NSMutableArray * ccontactgrouparray=[[JSONArray objectAtIndex:i] objectForKey:@"contactgroup"];
                
                if ([OMessageRecordObject.recipienttype isEqualToString:@"Student"]) {
                    
                    crecipientkey=[[JSONArray objectAtIndex:i] objectForKey:@"recipient"];
                    Student *studentobject=[MyClass returnstudentwithstudentkey:crecipientkey];
                    
                    crecipientid=studentobject.studentid;
                    
                    crecipientname=[MyClass returnStudentnameWithStudentkey:crecipientkey option:@"full"];
                    
                    cgender=studentobject.gender;
                    cimage=studentobject.image;
                    
                    ccenterkey=studentobject.centerkey;
                    
                    
                    [allreadstatusarray addObject:[[ReadStatusRecord alloc]initReadStatusRecordwithRecipientName:crecipientname RecipientID:crecipientid Channel:cchannel ReadTime:nil Image:cimage Gender:cgender Centerkey:ccenterkey Recipientkey:crecipientkey Contactgroup:[[NSMutableArray alloc]init] Relationship:nil iso_code:nil]];
                    
                    
                    for (int j=0; j<ccontactgrouparray.count; j++) {
                        ccontact=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"contact"];
                        crelationship=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"relationship"];
                        creadtime=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"readtime"];
                        cchannel=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"channel"];
                        ciso_code=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"iso_code"];
                        
                        [((ReadStatusRecord *)[allreadstatusarray objectAtIndex:i]).contactgroup addObject:[[ReadStatusRecord alloc]initReadStatusRecordwithRecipientName:nil RecipientID:nil Channel:cchannel ReadTime:creadtime Image:nil Gender:nil Centerkey:nil Recipientkey:ccontact Contactgroup:nil Relationship:crelationship iso_code:ciso_code]];
                    }
                    
                    
                }else if ([OMessageRecordObject.recipienttype isEqualToString:@"Lead"]) {
                    
                    crecipientkey=[[JSONArray objectAtIndex:i] objectForKey:@"recipient"];
                    Lead *leadobject=[MyClass returnleadwithleadkey:crecipientkey];
                    
                    crecipientid=leadobject.leadid;
                    
                    crecipientname=[MyClass returnLeadnameWithLeadkey:leadobject.leadkey option:@"full"];
                    
                    cgender=leadobject.gender;
                    cimage=leadobject.image;
                    
                    ccenterkey=leadobject.centerkey;
                    
                    
                    [allreadstatusarray addObject:[[ReadStatusRecord alloc]initReadStatusRecordwithRecipientName:crecipientname RecipientID:crecipientid Channel:cchannel ReadTime:nil Image:cimage Gender:cgender Centerkey:ccenterkey Recipientkey:crecipientkey Contactgroup:[[NSMutableArray alloc]init] Relationship:nil iso_code:nil]];
                    
                    for (int j=0; j<ccontactgrouparray.count; j++) {
                        ccontact=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"contact"];
                        crelationship=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"relationship"];
                        creadtime=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"readtime"];
                        cchannel=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"channel"];
                        ciso_code=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"iso_code"];
                        
                        [((ReadStatusRecord *)[allreadstatusarray objectAtIndex:i]).contactgroup addObject:[[ReadStatusRecord alloc]initReadStatusRecordwithRecipientName:nil RecipientID:nil Channel:cchannel ReadTime:creadtime Image:nil Gender:nil Centerkey:nil Recipientkey:ccontact Contactgroup:nil Relationship:crelationship iso_code:ciso_code]];
                    }
                    
                }else{
                    crecipientkey=[[JSONArray objectAtIndex:i] objectForKey:@"recipient"];
                    crecipientname=[MyClass returnstaffnamewithusername:crecipientkey firstorfullname:@"full"];
                    crecipientid=nil;
                    cgender=nil;
                    cimage=nil;
                    ccenterkey=nil;
                    
                    [allreadstatusarray addObject:[[ReadStatusRecord alloc]initReadStatusRecordwithRecipientName:crecipientname RecipientID:crecipientid Channel:cchannel ReadTime:creadtime Image:cimage Gender:cgender Centerkey:ccenterkey Recipientkey:crecipientkey Contactgroup:[[NSMutableArray alloc]init] Relationship:nil iso_code:nil]];
                    
                    for (int j=0; j<ccontactgrouparray.count; j++) {
                        ccontact=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"contact"];
                        crelationship=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"relationship"];
                        creadtime=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"readtime"];
                        cchannel=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"channel"];
                        ciso_code=[[ccontactgrouparray objectAtIndex:j] objectForKey:@"iso_code"];
                        
                        [((ReadStatusRecord *)[allreadstatusarray objectAtIndex:i]).contactgroup addObject:[[ReadStatusRecord alloc]initReadStatusRecordwithRecipientName:nil RecipientID:nil Channel:cchannel ReadTime:creadtime Image:nil Gender:nil Centerkey:nil Recipientkey:ccontact Contactgroup:nil Relationship:crelationship iso_code:ciso_code]];
                    }
                    
                }
                
            }
            
            //sort
            NSSortDescriptor *sortbyname = [NSSortDescriptor sortDescriptorWithKey:@"recipientname" ascending:YES selector:@selector(localizedStandardCompare:)];
            NSArray *sortDescriptors = @[sortbyname];
            allreadstatusarray = [NSMutableArray arrayWithArray:[allreadstatusarray sortedArrayUsingDescriptors:sortDescriptors]];
        }
    }];
    
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        PickerViewController *pickerviewcontroller = (PickerViewController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil] instantiateViewControllerWithIdentifier: @"PickerViewController"];
        pickerviewcontroller.delegate=self;
        pickerviewcontroller.selecteditems=[[NSMutableArray alloc]init];
        if ([OMessageRecordObject.recipienttype isEqualToString:@"Student"]) {
            pickerviewcontroller.datatype=@"ReadStatusStudent";
        }else if ([OMessageRecordObject.recipienttype isEqualToString:@"Staff"]) {
            pickerviewcontroller.datatype=@"ReadStatusStaff";
        }else if ([OMessageRecordObject.recipienttype isEqualToString:@"Lead"]) {
            pickerviewcontroller.datatype=@"ReadStatusLead";
        }
        
        pickerviewcontroller.showsearchbar=YES;
        pickerviewcontroller.bottommode=nil;
        pickerviewcontroller.viewtitle=@"Read Status";
        pickerviewcontroller.preferredContentSize=CGSizeMake(320, 40*allreadstatusarray.count);
        pickerviewcontroller.itemsarray=allreadstatusarray;
        
        //pickerviewcontroller.view.frame=self->mainWindow.bounds;
        pickerviewcontroller.view.frame=self->sidewindowview.bounds;
        [self->sidewindowview addSubview:pickerviewcontroller.view];
        [self addChildViewController:pickerviewcontroller];
        [pickerviewcontroller didMoveToParentViewController:self];
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
    runviewdidappear=FALSE;
        if (indexPath.row<workingMessage.photoarray.count) {
            fullscreenphotoviewcontroller.mode=@"Add";
            fullscreenphotoviewcontroller.index=indexPath.row;
            fullscreenphotoviewcontroller.fileArray=workingMessage.photoarray;
            [self presentViewController:fullscreenphotoviewcontroller animated:YES completion: nil];
        }

}



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


-(NSMutableArray *) returnImageArrayWithMessagePhotoArray:(NSMutableArray *)photoarray
{
     NSMutableArray *imagearray=[[NSMutableArray alloc]init];
    MessagePhotoRecord *object;
    for (int i=0; i<workingMessage.photoarray.count; i++) {
        object=[workingMessage.photoarray objectAtIndex:i];
        NSDictionary *dict = @{ @"image" : object.imageview.image, @"imagetype" : object.filetype,@"fileurl":object.internalurl?object.internalurl:@"", @"filename" : object.filename};
        [imagearray addObject:dict];
    }
    return imagearray;
}

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView==contentTable && scmessageview.selectedSegmentIndex==0){
//        [self getunreadrows];
//    }
//}

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView==contentTable && scmessageview.selectedSegmentIndex==0) {
//        [self changemessagetoreadandreloadcontactlist:YES];
//    }
//
//}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    if (scrollView==contentTable && scmessageview.selectedSegmentIndex==0) {
//        [self changemessagetoreadandreloadcontactlist:YES];
//    }
//}

//-(void) changemessagetoreadandreloadcontactlist:(BOOL)reload
//{
//    if (readmessagearray.count>0) {
//
//        NSString *messagekeys=[readmessagearray componentsJoinedByString:@","];
//        [readmessagearray removeAllObjects];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self updateinboxmessagewithmessagekey:messagekeys field:nil value:nil action:@"Read"];
//            if (reload) {
//                [self retrievemessagecontactlist];
//            }
//        });
//
//
//    }
//}

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
    if ([globalvariables.selectedmessagecontact.messagecontact isEqualToString:@"center"]) {
        channelarray=[[NSMutableArray alloc]initWithObjects:@"A", nil];
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Staff"]){
        channelarray=[[NSMutableArray alloc]initWithObjects:@"A", nil];
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Student"]){
        channelarray=[[NSMutableArray alloc]initWithObjects:@"AS",@"A",@"S",@"E", nil];
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Lead"]){
        channelarray=[[NSMutableArray alloc]initWithObjects:@"S",@"E", nil];
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Group"]){
        channelarray=[[NSMutableArray alloc]initWithObjects:@"A", nil];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]initWithObjects:workingMessage.channel, nil] DataType:@"MessageChannel" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(180, 40*channelarray.count) View:self Button:button ItemsArray:channelarray Title:nil];
}

- (IBAction)sendinstantmessagebuttonpressed:(id)sender
{
    if (audioRecorder.isRecording) {
        [self stopAudioRecording];
    }else{
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
}

-(void) addtmpinstantmessage
{
    InboxMessageRecord *messageobject=[[InboxMessageRecord alloc]initInboxMessageRecordwithInboxMessagekey:nil Messagetype:workingMessage.messagetype MessageEnglish:workingMessage.messageenglish MessageChinese:workingMessage.messagechinese MessageCreateTime:nil MessageStartTime:[MyClass convertToNSStringWithNSDate:[NSDate date] DateFormat:@"yyyy-MM-dd HH:mm:ss"] AutoMessageFlag:nil Channel:workingMessage.channel ReciptientType:workingMessage.recipienttype Status:workingMessage.status Sender:workingMessage.sender AssociateID:nil Readtime:@"" photoarray:workingMessage.photoarray recipient:globalvariables.selectedmessagecontact.messagecontact outboxmessagekey:nil type:@"sent" readstatus:@"SENDING" readstatusdetailsarray:nil replytomessagekey:replyToMessageView.hidden?@"0":@"999"];
    [globalvariables.messageArray insertObject:messageobject atIndex:0];
    instantPhotoCollectionView.hidden=YES;
    replyToMessageView.hidden=YES;
    camerabutton.hidden=NO;
    [self returnfilteredMessageArray];
    
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
    
    if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Center"]) {
        values=[NSArray arrayWithObjects:@"staff",globalvariables.selectedmessagecontact.messagecontact, nil];
        workingMessage.recipienttype=@"Staff";
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Staff"]){
        workingMessage.recipienttype=@"Staff";
        values=[NSArray arrayWithObjects:@"staff",globalvariables.selectedmessagecontact.messagecontact, nil];
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Student"]){
        workingMessage.recipienttype=@"Student";
        values=[NSArray arrayWithObjects:@"student",globalvariables.selectedmessagecontact.messagecontact, nil];
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Lead"]){
        workingMessage.recipienttype=@"Lead";
        values=[NSArray arrayWithObjects:@"lead",globalvariables.selectedmessagecontact.messagecontact, nil];
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Group"]){
        workingMessage.recipienttype=@"Group";
        values=[NSArray arrayWithObjects:@"staffgroup",globalvariables.selectedmessagecontact.messagecontact, nil];
    }
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
        }
    }];
    
    if (result) {
//        NSString *resString = [[NSString alloc] initWithData:returndata encoding:NSUTF8StringEncoding];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:returndata options:kNilOptions error:nil];
        NSString *status=json[@"status"];
        NSDictionary *jsoncontent=json[@"content"];
        if ([status isEqualToString:@"success"]) {
            
            NSArray *photofilenamearray=jsoncontent[@"photofilenamearray"];
            for (int i=0; i<photofilenamearray.count; i++) {
                NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@messageimages/%@/%@",globalvariables.serverpath,globalvariables.centerrecord.centerdb,[photofilenamearray objectAtIndex:i]] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
                [[SDImageCache sharedImageCache] storeImage:((MessagePhotoRecord *)tmpphotoarray[i]).imageview.image forKey:[url absoluteString] toDisk:YES completion:nil];
                
            }
            [MyClass clearTmpDirectoryContent];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            workingMessage.photoarray=[[NSMutableArray alloc]init];
            messageinputtext.text=@"";
            workingMessage.messageenglish=@"";
            workingMessage.messagechinese=@"";
            recordAudioButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendmessage;
            replyToMessageView.hidden=YES;
            sendinstantmessagebutton.enabled=[self enableSendButton];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self retrievemessagecontactlistwithcenterkey:nil];
                [self retrievemessagelistwithmessagecontact:globalvariables.selectedmessagecontact];
                //workingMessage.photoarray=[[NSMutableArray alloc]init];
                //sendinstantmessagebutton.enabled=[self enableSendButton];
                [MyClass playBeepSoundWithType:@"success"];
            });
        }else{
            
            [MyClass clearTmpDirectoryContent];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
            [globalvariables.messageArray removeObjectAtIndex:0];
            workingMessage.photoarray=[[NSMutableArray alloc]init];
            recordAudioButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendmessage;
            sendinstantmessagebutton.enabled=[self enableSendButton];
            [self returnfilteredMessageArray];
            
            NSString *reason=jsoncontent[@"reason"];
            UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Message"] message:[MyClass returntitlewithtitle:reason] preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [erroralert dismissViewControllerAnimated:YES completion:nil];
            }];
            
            [erroralert addAction:OKAction];
            [self presentViewController:erroralert animated:YES completion:nil];
        }
    }else{
        [MyClass clearTmpDirectoryContent];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
        [globalvariables.messageArray removeObjectAtIndex:0];
        workingMessage.photoarray=[[NSMutableArray alloc]init];
        recordAudioButton.enabled=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).sendmessage;
        sendinstantmessagebutton.enabled=[self enableSendButton];
        [self returnfilteredMessageArray];
        
        [MyClass showconnectionlostdialogbox];
    }
}

- (IBAction)selectsender:(UISegmentedControl *)sender {
    [self stopAudioPlaying];
    if (sender.selectedSegmentIndex==0) {
        workingMessage.sender=@"center";
    }else{
        workingMessage.sender=globalvariables.username;
    }
}

- (IBAction)showsystemmessagebuttonpressed:(UIButton *)sender {
    [self stopAudioPlaying];
    showsystemmessage=!showsystemmessage;
    [MyClass updatelocaldbwithparameter:@"showsystemmessage" value:showsystemmessage?@"Y":@"N"];
    [MyClass resetdevicelastupdatetimewithparameters:@"messagecontact"];
    
    NSString *sql=[NSString stringWithFormat:@"delete from messagecontact"];
    sqlite3_exec(globalvariables.isdb, [sql UTF8String],NULL,NULL,NULL);
    [globalvariables.messagecontactlist removeAllObjects];
    
    [sender setTitle:[MyClass returntitlewithtitle:showsystemmessage?@"System message: On":@"System message: Off"] forState:UIControlStateNormal];
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        globalvariables.selectedmessagecontact=nil;
        globalvariables.filteredMessageArray=[[NSMutableArray alloc]init];
        textinputbox.hidden=YES;
        instantmessagetopbox.hidden=YES;
        categorytable.hidden=YES;
        [self reloadmessageview];
    });
}

- (IBAction)contactbuttonpressed:(id)sender {
    
    NSMutableArray *slidearray=[[NSMutableArray alloc]init];

    if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Student"]) {
        [slidearray addObject:[[SlidePhotoRecord alloc]initSlidePhotoRecordwithcenterkey:globalvariables.selectedmessagecontact.centerkey type:@"student" typekey:globalvariables.selectedmessagecontact.messagecontact filename:globalvariables.selectedmessagecontact.messagecontact title:globalvariables.selectedmessagecontact.messagecontactdisplayname postdate:@"" width:@"" height:@"" hn_expiry_date:@"" editable:NO filetype:@"image" thumbnailurl:@"" fileurl:globalvariables.selectedmessagecontact.messagecontact]];
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Lead"]) {
        [slidearray addObject:[[SlidePhotoRecord alloc]initSlidePhotoRecordwithcenterkey:globalvariables.selectedmessagecontact.centerkey type:@"lead" typekey:globalvariables.selectedmessagecontact.messagecontact filename:globalvariables.selectedmessagecontact.messagecontact title:globalvariables.selectedmessagecontact.messagecontactdisplayname postdate:@"" width:@"" height:@"" hn_expiry_date:@"" editable:NO filetype:@"image" thumbnailurl:@"" fileurl:globalvariables.selectedmessagecontact.messagecontact]];
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Staff"]) {
        [slidearray addObject:[[SlidePhotoRecord alloc]initSlidePhotoRecordwithcenterkey:globalvariables.selectedmessagecontact.centerkey type:@"staff" typekey:globalvariables.selectedmessagecontact.messagecontact filename:globalvariables.selectedmessagecontact.messagecontact title:globalvariables.selectedmessagecontact.messagecontactdisplayname postdate:@"" width:@"" height:@"" hn_expiry_date:@"" editable:NO filetype:@"image" thumbnailurl:@"" fileurl:globalvariables.selectedmessagecontact.messagecontact]];
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Center"]) {
        CenterRecord *center=[MyClass returncenterrecordwithcenterkey:globalvariables.selectedmessagecontact.centerkey];
        [slidearray addObject:[[SlidePhotoRecord alloc]initSlidePhotoRecordwithcenterkey:globalvariables.selectedmessagecontact.centerkey type:@"centerimage" typekey:center.launchimage_landscape filename:center.launchimage_landscape title:globalvariables.selectedmessagecontact.messagecontactdisplayname postdate:@"" width:@"" height:@"" hn_expiry_date:@"" editable:NO filetype:@"image" thumbnailurl:@"" fileurl:center.launchimage_landscape]];
    }else if ([globalvariables.selectedmessagecontact.messagecontacttype isEqualToString:@"Group"]) {
        return;
        //[slidearray addObject:[[SlidePhotoRecord alloc]initSlidePhotoRecordwithcenterkey:globalvariables.selectedmessagecontact.centerkey type:@"staff" typekey:globalvariables.selectedmessagecontact.messagecontact filename:globalvariables.selectedmessagecontact.messagecontact title:globalvariables.selectedmessagecontact.messagecontactdisplayname postdate:@"" width:@"" height:@"" hn_expiry_date:@"" editable:NO]];
    }
    
    runviewdidappear=FALSE;
    fullscreenphotoviewcontroller.index=0;
    fullscreenphotoviewcontroller.mode=@"View";
    fullscreenphotoviewcontroller.fileArray=slidearray;
    [self presentViewController:fullscreenphotoviewcontroller animated:YES completion: nil];
}

-(void) addphotobuttonpressed:(UIButton *)sender
{
    addphotobutton=sender;
    [self popupaddphotodialoguebox];

}

-(void) popupaddphotodialoguebox
{
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
                        [self paddingtableifneeded];
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
                
                
                
                //[self presentViewController:imagepicker animated:YES completion:nil];
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
    [imagepicker dismissViewControllerAnimated:YES completion:nil];
    
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
                if(!instantPhotoCollectionView.hidden){
                    [instantPhotoCollectionView reloadData];
                }
                [self paddingtableifneeded];
                
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
                if(!instantPhotoCollectionView.hidden){
                    [instantPhotoCollectionView reloadData];
                }
                [self paddingtableifneeded];
                [MyClass loadingindicatorwithoption:@"stop" color:@""];
            });
        }

    }
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
                [self paddingtableifneeded];
                
            }
        }
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    runviewdidappear=FALSE;
    [imagepicker dismissViewControllerAnimated:YES completion:nil];
    //imagepicker.view.hidden=YES;
}

-(void) deleteMessagePhoto:(UIButton *)button
{
    [workingMessage.photoarray removeObjectAtIndex:button.tag];
    instantPhotoCollectionView.hidden=workingMessage.photoarray.count==0;
    camerabutton.hidden=!instantPhotoCollectionView.hidden;
    sendinstantmessagebutton.enabled=[self enableSendButton];
    if(!instantPhotoCollectionView.hidden){
        [instantPhotoCollectionView reloadData];
    }
    [self paddingtableifneeded];
}

-(void)textViewDidChange:(UITextView *)textView
{
    [self stopAudioPlaying];
    CGSize size = [textView sizeThatFits:CGSizeMake(CGRectGetWidth(textView.frame), MAXFLOAT)];
    if (size.height>100) {
        messageinputtextheightconstraint.constant=100;
        textView.scrollEnabled=YES;
    }else{
        messageinputtextheightconstraint.constant=size.height;
        textView.scrollEnabled=NO;
    }
    
    workingMessage.messageenglish=textView.text;
    workingMessage.messagechinese=textView.text;
    sendinstantmessagebutton.enabled=[self enableSendButton];
}

-(void) selectMessageWithIndex:(NSInteger)index
{
    InboxMessageRecord *obj=[globalvariables.filteredMessageArray objectAtIndex:index];
    if ([selectedinboxmessages containsObject:obj.inboxmessagekey]) {
        [selectedinboxmessages removeObject:obj.inboxmessagekey];
    }else{
        [selectedinboxmessages addObject:obj.inboxmessagekey];
    }
    
    if (selectStatusView.hidden) {
        [contentTable reloadData];
    }else{
        [contentTable reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [contentTable deselectRowAtIndexPath:[contentTable indexPathForSelectedRow] animated:NO];
    }
    
    deleteMessageButton.enabled=selectedinboxmessages.count>0;
    forwardMessageButton.enabled=selectedinboxmessages.count>0;
    selectedTitle.text=[MyClass returnreplacedtitlewithtitle:@"%@1 Selected" replacementarray:@[[@(selectedinboxmessages.count) stringValue]]];
}

-(void) tapMessagePhotoDetected:(UIButton *)sender
{
    runviewdidappear=FALSE;
    NSInteger messagerow=sender.tag/888888;
    NSInteger photorow=sender.tag%888888;
    
    if(selectMode){
        [self selectMessageWithIndex:messagerow];
        return;
    }
    
    if (scmessageview.selectedSegmentIndex==0) {
        InboxMessageRecord *messageobject=[globalvariables.filteredMessageArray objectAtIndex:messagerow];
        NSMutableArray *messagephotoarray=messageobject.photoarray;
        fullscreenphotoviewcontroller.index=photorow;
        fullscreenphotoviewcontroller.mode=@"View";
        if ([messageobject.readstatus isEqualToString:@"SENDING"]) {
            fullscreenphotoviewcontroller.fileArray=messagephotoarray;
        }else{
            fullscreenphotoviewcontroller.fileArray=messagephotoarray;
        }
        [self presentViewController:fullscreenphotoviewcontroller animated:YES completion: nil];
    }else{
        OutboxMessageRecord *messageobject=[filteredOutboxMessageArray objectAtIndex:messagerow];
        NSMutableArray *messagephotoarray=messageobject.photoarray;
        fullscreenphotoviewcontroller.mode=@"View";
        fullscreenphotoviewcontroller.index=photorow;
        fullscreenphotoviewcontroller.fileArray=messagephotoarray;
        [self presentViewController:fullscreenphotoviewcontroller animated:YES completion: nil];
    }
}


-(void) closeFullScreenPhotoViewWithIndex:(NSInteger)index
{
    runviewdidappear=FALSE;
    [fullscreenphotoviewcontroller dismissViewControllerAnimated:YES completion:nil];
}

-(void) deleteImageWithIndex:(NSInteger)index
{
    runviewdidappear=FALSE;
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
    if(!instantPhotoCollectionView.hidden){
        [instantPhotoCollectionView reloadData];
    }
    [self paddingtableifneeded];
    
}

-(void) returnRotatedImage:(UIImage *)image Index:(NSInteger)index
{
    MessagePhotoRecord *obj=[workingMessage.photoarray objectAtIndex:index];
    obj.imageview=[[UIImageView alloc]initWithImage:image];
    obj.internalurl=[MyClass returnInternalURLforNSData:UIImageJPEGRepresentation(obj.imageview.image, 1.0) Filename:@"image"];
    [instantPhotoCollectionView reloadData];
}

-(void) sharephotobuttonpressed:(UIButton *)sender
{
    [self stopAudioPlaying];
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    if (scmessageview.selectedSegmentIndex==0) {
            MessagePhotoRecord *obj=[((InboxMessageRecord *)[globalvariables.filteredMessageArray objectAtIndex:sender.tag]).photoarray firstObject];
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
    }else{
        MessagePhotoRecord *obj=[((OutboxMessageRecord *)[filteredOutboxMessageArray objectAtIndex:sender.tag]).photoarray firstObject];
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
        
    }
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });

}



-(NSMutableArray *)returnStaffGroupArrayExcludedAll
{
    NSMutableArray *resultarray=[[NSMutableArray alloc]init];
    for (int i=0; i<allstaffgrouparray.count; i++) {
        GroupRecord *object=[allstaffgrouparray objectAtIndex:i];
        if (![object.groupname isEqualToString:@"All"]) {
            [resultarray addObject:object];
        }
    }
    return resultarray;
}

-(void) closestaffgroupviewcontrollerwithreload:(BOOL)reload
{
    [staffgroupviewcontroller dismissViewControllerAnimated:YES completion:nil];
    
    if (reload) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self reloadmessageview];
        });
        //[self retrievemessagecontactlist];
    }
}

-(void) refreshparentviewdocumentfoldercount
{
    
}

-(void) updatestudentinformationlist:(NSString *)studentkey reloadlist:(BOOL)reload
{
    
}

-(void) updateleadinformationlist:(NSString *)leadkey
{
    
}

-(void) updateCategoryCount
{
    
}

-(void) audioSliderValueChanged:(UISlider *)sender
{
    MyTableViewCell *cell=[contentTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
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
        MyTableViewCell *cell=[contentTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedUIslide.tag inSection:0]];
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
    
    MyTableViewCell *newcell=[contentTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:sender.tag inSection:0]];
    MyTableViewCell *previouscell=[contentTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedUIslide.tag inSection:0]];
    
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
        MessagePhotoRecord *obj=[((InboxMessageRecord *)[globalvariables.filteredMessageArray objectAtIndex:sender.tag]).photoarray firstObject];

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
            MyTableViewCell *previouscell=[contentTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedUIslide.tag inSection:0]];
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

-(void) refreshstudentdetailviewpresentingviewcontent
{
    [self reloadmessageview];
}

-(void) refreshleaddetailviewpresentingviewcontent
{
    [self reloadmessageview];
}

-(void) dismissEditStudentView{
    
}

@end
