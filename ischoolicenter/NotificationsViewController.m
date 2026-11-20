//
//  NotificationsViewController.m
//  EyeEnroll
//
//  Created by Jasmond Luk on 2/9/14.
//  Copyright (c) 2014 Dreamware Limited. All rights reserved.
//

#import "NotificationsViewController.h"
#import "UIViewController+AMSlideMenu.h"
#import "MainMenuViewController.h"
#import "MyClass.h"
#import "StudentInformationViewController.h"
#import "DTViewController.h"
#import "MessageViewController.h"
#import "TaskAssignmentViewController.h"
#import "MainViewController.h"
#import "MyTableViewCell.h"
//#import "AFNetworking.h"
#import "SceneDelegate.h"

@import Photos;

@import BSImagePicker;

@interface NotificationsViewController ()

@end

@interface NotificationsRoundedMaskView : UIView
@property (nonatomic) UIRectCorner roundedCorners;
@property (nonatomic) CGFloat cornerRadius;
@end

@implementation NotificationsRoundedMaskView
{
    CAShapeLayer *_maskLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        self.layer.mask = _maskLayer;
    }
    _maskLayer.frame = self.bounds;
    _maskLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self.roundedCorners cornerRadii:CGSizeMake(self.cornerRadius, self.cornerRadius)].CGPath;
}

@end

//#define tablewidth (self.view.frame.size.width-120)/2
//#define notificationcellheight 26
//#define taskcellheight 60

#define themecolor [UIColor colorWithRed:4.0/255.0 green:105.0/255.0 blue:120.0/255.0 alpha:1.0]
#define headerheight 35
//#define cellheight 35


@implementation NotificationsViewController
@synthesize imagepicker,mypopovercontroller;

- (void)viewDidLoad {

    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view layoutIfNeeded];
    
    slidewidth=slideScrollView.frame.size.width;
    slideheight=slidewidth*11.0/16.0;
    
    globalvariables=[GlobalVariables singleObj];
    mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    globalvariables.appbecomeactiveaction=@"";
    
    if ([globalvariables.firstredirectscreen isEqualToString:@"6"]) {
        AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
        NSIndexPath *menuindexPath = [NSIndexPath indexPathForRow:6 inSection:0];
        [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:menuindexPath];
//        globalvariables.firstredirectscreen=@"";
        return;
    }
    
    if ([MyClass isBlurAvailable]) {
        [MyClass downloadImageWithImageview:backgroundcenterimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_landscape image:@"Yes" async:YES];
        backgroundcenterimage.hidden=NO;
        filterview.hidden=NO;
        blurEffectView.hidden=NO;
        
    }else{
        filterview.hidden=YES;
        backgroundcenterimage.hidden=YES;
        blurEffectView.hidden=YES;
    }
    
    //slidescrollviewheightconstraint.constant=slidewidth*9.0/16.0;
    
    
    //[self checkprivilege];
    //[self retrieveNotificationPreference];
    
    
    df=[[NSDateFormatter alloc]init]; df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    //add reloadbutton
    reloadbutton=[[UIButton alloc]init];
    [reloadbutton setImage:[UIImage imageNamed:@"reload_white.png"] forState:UIControlStateNormal];
    [reloadbutton addTarget:self action:@selector(reloadpage:) forControlEvents:UIControlEventTouchUpInside];
    [masterview addSubview:reloadbutton];
    
    //add menu button
    UIButton *menubutton=[[UIButton alloc]init];
    [menubutton setImage:[UIImage imageNamed:@"menu-button.png"] forState:UIControlStateNormal];
    [menubutton addTarget:self action:@selector(slidebutton:) forControlEvents:UIControlEventTouchUpInside];
    [masterview addSubview:menubutton];
    
    
    headertitleview=[[UIView alloc]init];
    headertitlename=[[UILabel alloc]init];
    headertitlename.font=[UIFont boldSystemFontOfSize:17];
    headertitlename.textColor=[UIColor whiteColor];
    headertitlename.textAlignment=NSTextAlignmentCenter;
    [headertitleview addSubview:headertitlename];
    [masterview addSubview:headertitleview];
    
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
    
    switchcenterbutton=[[UIButton alloc]init];
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
    //switchcenterviewcontroller.preferredContentSize=CGSizeMake(610, 458);
    

    NotificationsTable.backgroundColor=[UIColor clearColor];
    NotificationsTable.rowHeight=UITableViewAutomaticDimension;
    NotificationsTable.estimatedRowHeight=80;
    
    StatusTable.rowHeight=UITableViewAutomaticDimension;
    StatusTable.estimatedRowHeight=80;
    StatusTable.backgroundColor=[UIColor clearColor];
    [self alignColumnBottoms];

    displaydate=[NSDate date];
    olddisplaydate=displaydate;

    
    
    //add side calendar
//    calendarview=[[CalendarView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width, 0, 320, self.view.bounds.size.height) Theme:2 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:YES showclassdot:YES schedulerecord:nil  UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
//    calendarview.delegate=self;
//    [masterview addSubview:calendarview];
    
    NSLog(@"calendar %f",self.view.bounds.size.width);

    messagerecordobject=[[MessageRecord alloc]init];
    
    
    //show menu for new login
    if ([globalvariables.newlogin isEqualToString:@"Yes"]) {
        globalvariables.newlogin=@"";
        [self.mainSlideMenu openLeftMenu];
    }
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor whiteColor];
    //tablerefresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [tablerefresh addTarget:self action:@selector(retrieveNotificationRecord) forControlEvents:UIControlEventValueChanged];
    [NotificationsTable addSubview:tablerefresh];
    
    tablerefresh = [[UIRefreshControl alloc] init];
    tablerefresh.tintColor = [UIColor whiteColor];
    //tablerefresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"];
    [tablerefresh addTarget:self action:@selector(retrieveStatusRecord) forControlEvents:UIControlEventValueChanged];
    [StatusTable addSubview:tablerefresh];
    
    
    masterviewbutton=[[UIButton alloc]init];
    [masterviewbutton addTarget:self action:@selector(closecalendar) forControlEvents:UIControlEventTouchUpInside];
    [masterview addSubview:masterviewbutton];
    masterviewbutton.hidden=YES;

    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    
    documentfolderbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [documentfolderbutton setImage:[UIImage imageNamed:@"documentfolder_icon.png"] forState:UIControlStateNormal];
    documentfolderbutton.showsTouchWhenHighlighted = YES;
    [documentfolderbutton setImageEdgeInsets:UIEdgeInsetsMake(6,1,1,6)];
    documentfolderbutton.layer.cornerRadius=5;
    documentfolderbutton.layer.masksToBounds=YES;
    [documentfolderbutton addTarget:self action:@selector(documentfolderbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
    [masterview addSubview:documentfolderbutton];
    
    documentfoldercountlabel = [[UILabel alloc] initWithFrame: CGRectMake(18,7,10,10)];
    documentfoldercountlabel.backgroundColor = [UIColor redColor];
    documentfoldercountlabel.layer.cornerRadius=5;
    documentfoldercountlabel.layer.masksToBounds=YES;
    [documentfolderbutton addSubview:documentfoldercountlabel];
    
    [self installSizeTrackingConstraintsWithMenuButton:menubutton];
    [self refreshlanguage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checktoreloadapp) name:UIApplicationWillEnterForegroundNotification object:nil];

    UISwipeGestureRecognizer *rightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeHandle:)];
    rightRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [rightRecognizer setNumberOfTouchesRequired:1];
    
    fullscreenphotoviewcontroller = (FullScreenPhotoViewController *)[self.storyboard instantiateViewControllerWithIdentifier: @"FullScreenPhotoViewController"];
    fullscreenphotoviewcontroller.modalPresentationStyle = UIModalPresentationFullScreen;
    fullscreenphotoviewcontroller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    fullscreenphotoviewcontroller.delegate=self;
    fullscreenphotoviewcontroller.mode=@"View";
    
    runviewdidappear=TRUE;
    

    
    currencyformatter = [[NSNumberFormatter alloc] init];
    [currencyformatter setMaximumFractionDigits:globalvariables.centerrecord.noofroundoffdigit];
    [currencyformatter setMinimumFractionDigits:0];
    currencyformatter.numberStyle = NSNumberFormatterCurrencyStyle;
    [currencyformatter setCurrencySymbol:@"$"];
    
    period=[MyClass getlocaldbwithparameter:@"chartperiod"];
    
//    mainWindow= [[[UIApplication sharedApplication] delegate] window];
    mainWindow = [self notificationsSceneWindow];
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
    sidewindowview.clipsToBounds=YES;
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
    ailoadindicator.center = CGPointMake(152.5,mainWindow.bounds.size.height/2-7.5);
    ailoadindicator.hidesWhenStopped = YES;
    [ailoadindicator addSubview:activityImageView];
    [sidewindowview addSubview:ailoadindicator];
    
    mainstackview.hidden=YES;
    
    [self refreshdocumentfoldercount];
    
    if([globalvariables.centerrecord.centerkey isEqualToString:@"604"]){
        [mainviewcontroller sendOutboxDocument];
    }

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.view.bounds.size.width < 1 || self.view.bounds.size.height < 1) {
        return;
    }
    
    [self installVisibleEdgeConstraints];
    [self applyVisibleTrailingInset];
    [self applyVisibleBottomInset];
    
    [self updateSlideLayoutForCurrentWidth];
    [self updateCalendarFrame];
    [self updateheadercentertitle];
    [self layoutSideWindowForCurrentSize];
    
    CGFloat tableWidth = NotificationsTable.bounds.size.width;
    if (tableWidth > 0 && lastNotificationsTableWidth == 0) {
        lastNotificationsTableWidth = tableWidth;
    } else if (tableWidth > 0 && fabs(tableWidth - lastNotificationsTableWidth) > 0.5) {
        lastNotificationsTableWidth = tableWidth;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->NotificationsTable reloadData];
        });
    }
}

-(void) alignColumnBottoms
{
    if (!NotificationsTable || !StatusTable || !slideScrollView || !mainstackview) {
        return;
    }
    mainstackview.alignment = UIStackViewAlignmentFill;
    mainstackview.clipsToBounds = YES;
    // Hot News is a scroll view in a stack, so its height follows the cards and the
    // last card ends below the other columns. Pin the visible bottoms together.
    [slideScrollView setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    [slideScrollView setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    UIView *hotNewsContainer = slideScrollView.superview;
    [hotNewsContainer setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisVertical];
    [hotNewsContainer setContentCompressionResistancePriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    hotNewsContainer.clipsToBounds = YES;
    
    NSLayoutConstraint *statusBottom = [StatusTable.bottomAnchor constraintEqualToAnchor:NotificationsTable.bottomAnchor];
    NSLayoutConstraint *hotNewsBottom = [slideScrollView.bottomAnchor constraintEqualToAnchor:NotificationsTable.bottomAnchor];
    statusBottom.priority = UILayoutPriorityRequired;
    hotNewsBottom.priority = UILayoutPriorityRequired;
    statusBottom.active = YES;
    hotNewsBottom.active = YES;
}

-(CGFloat) calendarPanelWidth
{
    CGFloat width = self.view.bounds.size.width;
    if (width < 1) {
        return 320.0;
    }
    return MIN(320.0, width);
}

-(void) installVisibleEdgeConstraints
{
    if (headerVisibleTrailing || !headerbar || !filterview || !mainstackview) {
        return;
    }
    // These storyboard insets are relative to masterview, which is 320pt wider than
    // the window. Pin the visible chrome to the window edge instead.
    calendarPanelHeaderConstraint.active = NO;
    calendarPanelBackgroundConstraint.active = NO;
    calendarPanelStackConstraint.active = NO;
    
    headerVisibleTrailing = [headerbar.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    backgroundVisibleTrailing = [filterview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
    stackVisibleTrailing = [mainstackview.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20];
    [NSLayoutConstraint activateConstraints:@[headerVisibleTrailing, backgroundVisibleTrailing, stackVisibleTrailing]];
}

-(CGFloat) visibleBottomInset
{
    UIWindow *window = self.view.window;
    if (!window) {
        return self.view.safeAreaInsets.bottom;
    }
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGRect safeFrame = window.safeAreaLayoutGuide.layoutFrame;
    if (CGRectIsEmpty(safeFrame) || safeFrame.size.height < 1) {
        return self.view.safeAreaInsets.bottom;
    }
    CGFloat overflow = CGRectGetMaxY(frameInWindow) - CGRectGetMaxY(safeFrame);
    return MAX(0, overflow);
}

-(void) applyVisibleBottomInset
{
    if (!stackBottomConstraint) {
        return;
    }
    CGFloat inset = [self visibleBottomInset];
    if (fabs(inset - appliedBottomInset) < 0.5) {
        return;
    }
    appliedBottomInset = inset;
    // masterview.bottom = stack.bottom + constant, so a positive constant lifts the columns.
    stackBottomConstraint.constant = inset;
}

-(CGFloat) visibleTrailingInset
{
    UIWindow *window = self.view.window;
    if (!window) {
        return self.view.safeAreaInsets.right;
    }
    CGRect frameInWindow = [self.view convertRect:self.view.bounds toView:nil];
    CGRect safeFrame = window.safeAreaLayoutGuide.layoutFrame;
    if (CGRectIsEmpty(safeFrame) || safeFrame.size.width < 1) {
        return self.view.safeAreaInsets.right;
    }
    CGFloat overflow = CGRectGetMaxX(frameInWindow) - CGRectGetMaxX(safeFrame);
    return MAX(0, overflow);
}

-(void) applyVisibleTrailingInset
{
    if (!headerVisibleTrailing || calendarOpen) {
        return;
    }
    CGFloat inset = [self visibleTrailingInset];
    if (fabs(inset - appliedTrailingInset) < 0.5) {
        return;
    }
    CGFloat delta = inset - appliedTrailingInset;
    appliedTrailingInset = inset;
    headerVisibleTrailing.constant -= delta;
    backgroundVisibleTrailing.constant -= delta;
    stackVisibleTrailing.constant -= delta;
}

-(void) updateCalendarPanelConstraints
{
    [self installVisibleEdgeConstraints];
    if (!headerVisibleTrailing) {
        return;
    }
    CGFloat panelWidth = [self calendarPanelWidth];
    CGFloat inset = [self visibleTrailingInset];
    appliedTrailingInset = inset;
    CGFloat shift = (calendarOpen ? panelWidth : 0) + inset;
    headerVisibleTrailing.constant = -shift;
    backgroundVisibleTrailing.constant = -shift;
    stackVisibleTrailing.constant = -20 - shift;
    if (masterviewButtonTrailing) {
        masterviewButtonTrailing.constant = -(panelWidth + inset);
    }
    if (calendarOpen) {
        masterviewleadingconstraint.constant = -panelWidth;
        masterviewtrailingconstrain.constant = 0;
    } else {
        masterviewleadingconstraint.constant = 0;
        masterviewtrailingconstrain.constant = -panelWidth;
    }
}

-(void) updateCalendarFrame
{
    CGFloat panelWidth = [self calendarPanelWidth];
    CGFloat height = self.view.bounds.size.height;
    if (panelWidth < 1 || height < 1) {
        return;
    }
    CGRect frame = CGRectMake(self.view.bounds.size.width - [self visibleTrailingInset], 0, panelWidth, height);
    BOOL sizeChanged = !calendarview
        || fabs(calendarview.bounds.size.width - panelWidth) > 0.5
        || fabs(calendarview.bounds.size.height - height) > 0.5;
    if (sizeChanged) {
        [calendarview removeFromSuperview];
        calendarview=[[CalendarView alloc]initWithFrame:frame Theme:2 CanPickHoliday:NO MultipleSelection:NO ShowTodayButton:YES showclassdot:YES schedulerecord:nil  UpdateScheduleMode:nil availablemakeuptimeslots:nil instructoravailability:nil dataType:@"" disablecalendar:FALSE];
        calendarview.delegate=self;
        [masterview addSubview:calendarview];
    } else {
        calendarview.frame=frame;
    }
}

-(void) updateSlideLayoutForCurrentWidth
{
    CGFloat newWidth = slideScrollView.bounds.size.width;
    if (newWidth <= 0 || fabs(newWidth - slidewidth) <= 0.5) {
        return;
    }
    NSInteger page = 0;
    if (slideheight > 0) {
        page = (NSInteger)llround(slideScrollView.contentOffset.y / slideheight);
    }
    slidewidth = newWidth;
    slideheight = slidewidth * 11.0 / 16.0;
    if (!SlideArray) {
        return;
    }
    [[slideScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    slideScrollView.contentSize=CGSizeMake(slidewidth, slideheight*SlideArray.count);
    if (page < 0) {
        page = 0;
    }
    [self moveSlideWindowWithPageIndex:page ScrollView:slideScrollView];
    if (page > 0) {
        CGFloat offsety = page * slideheight;
        if (slideScrollView.contentSize.height - offsety < slideScrollView.bounds.size.height) {
            offsety = slideScrollView.contentSize.height - slideScrollView.bounds.size.height;
        }
        if (offsety < 0) {
            offsety = 0;
        }
        slideScrollView.contentOffset=CGPointMake(0, offsety);
    }
}

-(void) installSizeTrackingConstraintsWithMenuButton:(UIButton *)menubutton
{
    reloadbutton.translatesAutoresizingMaskIntoConstraints=NO;
    menubutton.translatesAutoresizingMaskIntoConstraints=NO;
    documentfolderbutton.translatesAutoresizingMaskIntoConstraints=NO;
    headertitleview.translatesAutoresizingMaskIntoConstraints=NO;
    headertitlename.translatesAutoresizingMaskIntoConstraints=NO;
    switchcenterbutton.translatesAutoresizingMaskIntoConstraints=NO;
    headercentername.translatesAutoresizingMaskIntoConstraints=NO;
    headercenternamearrow.translatesAutoresizingMaskIntoConstraints=NO;
    masterviewbutton.translatesAutoresizingMaskIntoConstraints=NO;
    
    UILayoutGuide *safeArea = masterview.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [menubutton.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:15],
        [menubutton.centerYAnchor constraintEqualToAnchor:headerbar.centerYAnchor],
        [menubutton.widthAnchor constraintEqualToConstant:33],
        [menubutton.heightAnchor constraintEqualToConstant:22],
        
        [documentfolderbutton.leadingAnchor constraintEqualToAnchor:menubutton.trailingAnchor constant:12],
        [documentfolderbutton.centerYAnchor constraintEqualToAnchor:headerbar.centerYAnchor],
        [documentfolderbutton.widthAnchor constraintEqualToConstant:30],
        [documentfolderbutton.heightAnchor constraintEqualToConstant:30],
        
        [headertitleview.leadingAnchor constraintEqualToAnchor:documentfolderbutton.trailingAnchor constant:8],
        [headertitleview.trailingAnchor constraintEqualToAnchor:reloadbutton.leadingAnchor constant:-8],
        [headertitleview.topAnchor constraintEqualToAnchor:masterview.topAnchor],
        [headertitleview.heightAnchor constraintEqualToConstant:68],
        
        [headertitlename.leadingAnchor constraintEqualToAnchor:headertitleview.leadingAnchor],
        [headertitlename.trailingAnchor constraintEqualToAnchor:headertitleview.trailingAnchor],
        [headertitlename.topAnchor constraintEqualToAnchor:headertitleview.topAnchor constant:25],
        [headertitlename.heightAnchor constraintEqualToConstant:20],
        
        [switchcenterbutton.leadingAnchor constraintEqualToAnchor:headertitleview.leadingAnchor],
        [switchcenterbutton.trailingAnchor constraintEqualToAnchor:headertitleview.trailingAnchor],
        [switchcenterbutton.topAnchor constraintEqualToAnchor:headertitleview.topAnchor],
        [switchcenterbutton.bottomAnchor constraintEqualToAnchor:headertitleview.bottomAnchor],
        
        [reloadbutton.trailingAnchor constraintEqualToAnchor:datepreviousbutton.leadingAnchor constant:-8],
        [reloadbutton.centerYAnchor constraintEqualToAnchor:headerbar.centerYAnchor],
        [reloadbutton.widthAnchor constraintEqualToConstant:30],
        [reloadbutton.heightAnchor constraintEqualToConstant:30],
        
        [masterviewbutton.leadingAnchor constraintEqualToAnchor:masterview.leadingAnchor],
        [masterviewbutton.topAnchor constraintEqualToAnchor:masterview.topAnchor],
        [masterviewbutton.bottomAnchor constraintEqualToAnchor:masterview.bottomAnchor],
    ]];
    
    masterviewButtonTrailing = [masterviewbutton.trailingAnchor constraintEqualToAnchor:masterview.trailingAnchor constant:-[self calendarPanelWidth]];
    masterviewButtonTrailing.active = YES;
    
    headerCenterNameWidth = [headercentername.widthAnchor constraintEqualToConstant:0];
    headerCenterNameCenterX = [headercentername.centerXAnchor constraintEqualToAnchor:headertitleview.centerXAnchor];
    [NSLayoutConstraint activateConstraints:@[
        [headercentername.topAnchor constraintEqualToAnchor:headertitleview.topAnchor constant:43],
        [headercentername.heightAnchor constraintEqualToConstant:22],
        headerCenterNameWidth,
        headerCenterNameCenterX,
        [headercenternamearrow.leadingAnchor constraintEqualToAnchor:headercentername.trailingAnchor],
        [headercenternamearrow.centerYAnchor constraintEqualToAnchor:headercentername.centerYAnchor],
        [headercenternamearrow.widthAnchor constraintEqualToConstant:8],
        [headercenternamearrow.heightAnchor constraintEqualToConstant:8],
    ]];
    [self installVisibleEdgeConstraints];
}

-(UIWindow *) notificationsSceneWindow
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
    if (!sidewindowview || sideWindowAnimating) {
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
    CGFloat requestedWidth = sideWindowRequestedWidth > 0 ? sideWindowRequestedWidth : 320.0;
    CGFloat panelWidth = MIN(requestedWidth, windowWidth);
    if (sideWindowOpen) {
        sidewindowview.hidden = NO;
        sidewindowview.frame = CGRectMake(windowWidth - panelWidth, 0, panelWidth, windowHeight);
        [window bringSubviewToFront:sidewindowview];
    } else {
        sidewindowview.hidden = YES;
        sidewindowview.frame = CGRectMake(windowWidth, 0, 0, windowHeight);
        sidewindowviewclosebutton.hidden = YES;
    }
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
    if (width <= 0 || mainWindow.bounds.size.width <= 0) {
        return 0;
    }
    return MIN(width, mainWindow.bounds.size.width);
}

-(void) placeChildInSideWindow:(UIViewController *)viewcontroller
{
    viewcontroller.view.translatesAutoresizingMaskIntoConstraints = YES;
    viewcontroller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    viewcontroller.view.frame = sidewindowview.bounds;
    viewcontroller.view.clipsToBounds = YES;
    [sidewindowview addSubview:viewcontroller.view];
    [self addChildViewController:viewcontroller];
    [viewcontroller didMoveToParentViewController:self];
}

-(void) documentfolderbuttonpressed:(id)sender
{

    [self startsidewindowanimationwithwidth:750];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        documentfolderpopover = (DocumentFolderPopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"DocumentFolderPopoverViewController"];
        documentfolderpopover.delegate=self;
        documentfolderpopover.menubutton=2;
        
        documentfolderpopover.view.clipsToBounds=YES;
        [self placeChildInSideWindow:documentfolderpopover];
        [ailoadindicator stopAnimating];
        ailoadindicator.hidden=YES;
    });
    
    
    
    
}

-(void) updateStatusTableRowArray
{
    StatusTableRowArray=[[NSMutableArray alloc]init];
    [StatusTableRowArray addObject:@"button"];
    if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showenrollmentcountchart || ((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showpaymentreceivedchart) {
        [StatusTableRowArray addObject:@"periodsegment"];
    }
    
    if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showenrollmentcountchart) {
        [StatusTableRowArray addObject:@"enrollmentbarchart"];
    }
    
    if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showpaymentreceivedchart) {
        [StatusTableRowArray addObject:@"paymentbarchart"];
    }
    
}

-(void) retrieveNotificationRecord
{
    [self retrieveNotificationRecordWithOption:@"Notification"];
}

-(void) retrieveStatusRecord
{
    [self retrieveNotificationRecordWithOption:@"Chart"];
}

- (void)rightSwipeHandle:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if (masterview.frame.origin.x<0) {
        [self closecalendar];
    }
}


-(void) checktoreloadapp
{
    
    if ([globalvariables.appbecomeactiveaction isEqualToString:@"reload"]) {
        [self.mainSlideMenu closeLeftMenu];
        globalvariables.appbecomeactiveaction=@"";
        globalvariables.leftmenuindex=@"0";
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
        
        [MyClass reloadApp];
    }else if ([globalvariables.appbecomeactiveaction isEqualToString:@"refresh"]) {
        globalvariables.appbecomeactiveaction=@"";

        if (self.presentedViewController==switchcenterviewcontroller) {
            [switchcenterviewcontroller dismissViewControllerAnimated:NO completion:nil];
        }else{
            [self.mainSlideMenu closeLeftMenu];
        }
        
        [self reloadPageWithFirstLoad:NO];
    }
}

-(void) refreshlanguage
{
    title_hotnews.text=[MyClass returntitlewithtitle:@"Hot News"];
    title_status.text=[MyClass returntitlewithtitle:@"Status"];
    title_notification.text=[MyClass returntitlewithtitle:@"Notification"];
    headercentername.text=[MyClass returnWindowTitle];
    headertitlename.text=[MyClass returntitlewithtitle:@"Highlights"];
    [self updateheadercentertitle];
    
}

-(void) updateheadercentertitle
{
    if (!headerCenterNameWidth) {
        return;
    }
    CGFloat textWidth = ceil(headercentername.intrinsicContentSize.width);
    CGFloat maxWidth = headertitleview.bounds.size.width;
    if (maxWidth > 0 && textWidth > maxWidth) {
        headerCenterNameWidth.constant = maxWidth;
    } else {
        headerCenterNameWidth.constant = MAX(textWidth, 0);
    }
    headerCenterNameCenterX.constant = [MyClass isMultiCenterUser] ? -4 : 0;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    

    globalvariables.lastviewcontroller=(NSString *)self;
    
    if(runviewdidappear && [globalvariables.leftmenuindex isEqualToString:@"0"]){
        [self reloadPageWithFirstLoad:YES];
    }else{
        runviewdidappear=TRUE;
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) retrieveNotificationRecordWithOption:(NSString *)option
{
    NSString *strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=retrievenotifications3&classdate=%@&username=%@&option=%@&period=%@&arckey=%@&os=%@&build=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,[MyClass convertToNSStringWithNSDate:displaydate DateFormat:@"yyyy-MM-dd"],globalvariables.username,option,period,[MyClass returndefaultarckey],@"ios",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
    
    __block BOOL result=FALSE;
    [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
        if (succeeded) {
            result=TRUE;
            NSDictionary *jsonreturned=[NSJSONSerialization JSONObjectWithData:data options:(kNilOptions) error:nil];
            NSDictionary *jsondictionary = jsonreturned[@"content"];
            NSArray *jsonnotificationrecords=jsondictionary[@"notificationrecords"];
            //NSArray *jsontaskrecords=jsondictionary[@"taskrecords"];
            NSArray *jsonsliderecords=jsondictionary[@"sliderecords"];
            NSArray *jsonpaidrecords=jsondictionary[@"paidrecords"];
            NSArray *jsonenrollmentcountrecords=jsondictionary[@"enrollmentcountrecords"];
            myoutstandingtaskcount=[jsondictionary[@"myoutstandingtaskcount"] integerValue];
            outstandingtasktoothercount=[jsondictionary[@"outstandingtasktoothercount"] integerValue];
            pendingrequestcount=[jsondictionary[@"pendingrequestcount"] integerValue];
            autorenewfailurecount=[jsondictionary[@"autorenewfailurecount"] integerValue];
            latestwhatsnewbuild=[jsondictionary[@"latestwhatsnewbuild"] integerValue];
            

            if ([option isEqualToString:@"All"] || [option isEqualToString:@"Notification"]) {
                FirstClassArray=[[NSMutableArray alloc]init];
                LastClassArray=[[NSMutableArray alloc]init];
                OutstandingArray=[[NSMutableArray alloc]init];
                PendingRenewalArray=[[NSMutableArray alloc]init];
                MakeupClassArray=[[NSMutableArray alloc]init];
                AssessmentClassArray=[[NSMutableArray alloc]init];
                TrialClassArray=[[NSMutableArray alloc]init];
                AbsentClassArray=[[NSMutableArray alloc]init];
                totaloutstanding=0;
                
                //loop through our jsonArray
                for (int i=0; i<jsonnotificationrecords.count; i++) {
                    
                    NSString * crecordtype=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"recordtype"];
                    NSString * ctype=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"type"];
                    NSString * cenrollmentkey=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"enrollmentkey"];
                    NSString * csaleskey=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"saleskey"];
                    NSString * cclasskey=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"classkey"];
                    NSString * cstudentkey=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"studentkey"];
                    NSString * cstudentname=[MyClass returnStudentnameWithStudentkey:cstudentkey option:@"full"];
                    NSString * csubjectcode=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"subjectcode"];
                    NSString * cproductcode=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"productcode"];
                    NSString * csubjectname=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"subjectname"];
                    NSString * cproductname=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"productname"];
                    NSString * ccategory=[csubjectcode isEqualToString:@""]?@"sales":@"class";
                    
                    NSString * cclassdatetime;
                    if ([crecordtype isEqualToString:@"pendingrenewal"]) {
                        cclassdatetime=[MyClass convertDateFormatWithDate:[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"classdatetime"] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"dd MMM HH:mm" Translate:NO];
                    }else{
                        cclassdatetime=[MyClass convertDateFormatWithDate:[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"classdatetime"] FromDateFormat:@"yyyy-MM-dd HH:mm" ToDateFormat:@"HH:mm" Translate:NO];
                    }
                    
                    NSString * cvalue=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"value"];
                    NSString * cschedulekey=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"schedulekey"];
                    NSString * cimage=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"image"];
                    NSString * cgender=[[jsonnotificationrecords objectAtIndex:i] objectForKey:@"gender"];
                    
                    if ([crecordtype isEqualToString:@"firstclass"] && ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showfirstclass) {
                        [FirstClassArray addObject:[[NotificationRecord alloc]initNotificationRecordwithRecordtype:crecordtype Type:ctype Category:ccategory Enrollmentkey:cenrollmentkey Saleskey:csaleskey Classkey:cclasskey Studentkey:cstudentkey Studentname:cstudentname Subjectcode:csubjectcode Productcode:cproductcode Subjectname:csubjectname Productname:cproductname Classdatetime:cclassdatetime Value:cvalue ScheduleKey:cschedulekey Image:cimage Gender:cgender]];
                        
                        if ([crecordtype isEqualToString:@"lastclass"]){
                            [LastClassArray addObject:[[NotificationRecord alloc]initNotificationRecordwithRecordtype:crecordtype Type:ctype Category:ccategory Enrollmentkey:cenrollmentkey Saleskey:csaleskey Classkey:cclasskey Studentkey:cstudentkey Studentname:cstudentname Subjectcode:csubjectcode Productcode:cproductcode Subjectname:csubjectname Productname:cproductname Classdatetime:cclassdatetime Value:cvalue ScheduleKey:cschedulekey Image:cimage Gender:cgender]];
                        }
                    }else if ([crecordtype isEqualToString:@"lastclass"] && ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showlastclass){
                        [LastClassArray addObject:[[NotificationRecord alloc]initNotificationRecordwithRecordtype:crecordtype Type:ctype Category:ccategory Enrollmentkey:cenrollmentkey Saleskey:csaleskey Classkey:cclasskey Studentkey:cstudentkey Studentname:cstudentname Subjectcode:csubjectcode Productcode:cproductcode Subjectname:csubjectname Productname:cproductname Classdatetime:cclassdatetime Value:cvalue ScheduleKey:cschedulekey Image:cimage Gender:cgender]];
                    }else if ([crecordtype isEqualToString:@"outstanding"] && ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showoutstandingclass){
                        [OutstandingArray addObject:[[NotificationRecord alloc]initNotificationRecordwithRecordtype:crecordtype Type:ctype Category:ccategory Enrollmentkey:cenrollmentkey Saleskey:csaleskey Classkey:cclasskey Studentkey:cstudentkey Studentname:cstudentname Subjectcode:csubjectcode Productcode:cproductcode Subjectname:csubjectname Productname:cproductname Classdatetime:cclassdatetime Value:cvalue ScheduleKey:cschedulekey Image:cimage Gender:cgender]];
                        totaloutstanding+=[cvalue floatValue];
                    }else if ([crecordtype isEqualToString:@"pendingrenewal"] && ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showpendingrenewalclass){
                        [PendingRenewalArray addObject:[[NotificationRecord alloc]initNotificationRecordwithRecordtype:crecordtype Type:ctype Category:ccategory Enrollmentkey:cenrollmentkey Saleskey:csaleskey Classkey:cclasskey Studentkey:cstudentkey Studentname:cstudentname Subjectcode:csubjectcode Productcode:cproductcode Subjectname:csubjectname Productname:cproductname Classdatetime:cclassdatetime Value:cvalue ScheduleKey:cschedulekey Image:cimage Gender:cgender]];
                    }else if ([crecordtype isEqualToString:@"makeupclass"] && ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showmakeupclass){
                        [MakeupClassArray addObject:[[NotificationRecord alloc]initNotificationRecordwithRecordtype:crecordtype Type:ctype Category:ccategory Enrollmentkey:cenrollmentkey Saleskey:csaleskey Classkey:cclasskey Studentkey:cstudentkey Studentname:cstudentname Subjectcode:csubjectcode Productcode:cproductcode Subjectname:csubjectname Productname:cproductname Classdatetime:cclassdatetime Value:cvalue ScheduleKey:cschedulekey Image:cimage Gender:cgender]];
                    }else if ([crecordtype isEqualToString:@"absentclass"] && ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showabsentclass){
                        [AbsentClassArray addObject:[[NotificationRecord alloc]initNotificationRecordwithRecordtype:crecordtype Type:ctype Category:ccategory Enrollmentkey:cenrollmentkey Saleskey:csaleskey Classkey:cclasskey Studentkey:cstudentkey Studentname:cstudentname Subjectcode:csubjectcode Productcode:cproductcode Subjectname:csubjectname Productname:cproductname Classdatetime:cclassdatetime Value:cvalue ScheduleKey:cschedulekey Image:cimage Gender:cgender]];
                    }else if ([crecordtype isEqualToString:@"assessclass"] && ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showassessclass){
                        [AssessmentClassArray addObject:[[NotificationRecord alloc]initNotificationRecordwithRecordtype:crecordtype Type:ctype Category:ccategory Enrollmentkey:cenrollmentkey Saleskey:csaleskey Classkey:cclasskey Studentkey:cstudentkey Studentname:cstudentname Subjectcode:csubjectcode Productcode:cproductcode Subjectname:csubjectname Productname:cproductname Classdatetime:cclassdatetime Value:cvalue ScheduleKey:cschedulekey Image:cimage Gender:cgender]];
                    }else if ([crecordtype isEqualToString:@"trialclass"] && ((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showtrialclass){
                        [TrialClassArray addObject:[[NotificationRecord alloc]initNotificationRecordwithRecordtype:crecordtype Type:ctype Category:ccategory Enrollmentkey:cenrollmentkey Saleskey:csaleskey Classkey:cclasskey Studentkey:cstudentkey Studentname:cstudentname Subjectcode:csubjectcode Productcode:cproductcode Subjectname:csubjectname Productname:cproductname Classdatetime:cclassdatetime Value:cvalue ScheduleKey:cschedulekey Image:cimage Gender:cgender]];
                    }
                }
                
                shownonotificationrecord=FirstClassArray.count+LastClassArray.count+OutstandingArray.count+PendingRenewalArray.count+MakeupClassArray.count+AbsentClassArray.count+AssessmentClassArray.count+TrialClassArray.count==0;
                ImportantMessageArray=[[NSMutableArray alloc]init];
                PromotionalMessageArray=[[NSMutableArray alloc]init];
                GeneralMessageArray=[[NSMutableArray alloc]init];
                
                /*[NotificationsTable reloadData];
                reloadbutton.hidden=YES;
                
                for (id object in [NotificationsTable subviews]) {
                    if ([object isKindOfClass:[UIRefreshControl class]]) {
                        [(UIRefreshControl *)object endRefreshing];break;
                    }
                }*/
            }
            
            /*if ([option isEqualToString:@"All"] ||[option isEqualToString:@"Task"]) {
                MyTaskArray=[[NSMutableArray alloc]init];
                TaskToOthersArray=[[NSMutableArray alloc]init];
                AllOtherTaskArray=[[NSMutableArray alloc]init];
                
                //loop through our jsonArray
                for (int i=0; i<jsontaskrecords.count; i++) {
                    
                    
                    //Create our ClassRecord object
                    NSString * ctaskkey=[[jsontaskrecords objectAtIndex:i] objectForKey:@"taskkey"];
                    NSString *ccreatedatetime=[MyClass convertDateFormatWithDate:[[[jsontaskrecords objectAtIndex:i] objectForKey:@"createdatetime"] substringToIndex:19] FromDateFormat:@"yyyy-MM-dd HH:mm:ss" ToDateFormat:@"dd-MMM-yyyy" Translate:NO];
                    NSString * cassignedby=[[jsontaskrecords objectAtIndex:i] objectForKey:@"assignedby"];
                    NSString * cassignedto=[[jsontaskrecords objectAtIndex:i] objectForKey:@"assignedto"];
                    NSString * cassignedbyusername=[[jsontaskrecords objectAtIndex:i] objectForKey:@"assignedbyusername"];
                    NSString * cassignedtousername=[[jsontaskrecords objectAtIndex:i] objectForKey:@"assignedtousername"];
                    NSString *cfollowupdatetime=[MyClass convertDateFormatWithDate:[[[jsontaskrecords objectAtIndex:i] objectForKey:@"followupdatetime"] substringToIndex:19] FromDateFormat:@"yyyy-MM-dd HH:mm:ss" ToDateFormat:@"dd MMM HH:mm" Translate:NO];
                    NSString * ctaskname=[[jsontaskrecords objectAtIndex:i] objectForKey:@"taskname"];
                    NSString * cremarks=[[jsontaskrecords objectAtIndex:i] objectForKey:@"remarks"];
                    NSString * cstatus=[[jsontaskrecords objectAtIndex:i] objectForKey:@"status"];
                    
                    if ([[[jsontaskrecords objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"mytask"] && showmytask) {
                        [MyTaskArray addObject:[[TaskRecord alloc]initTaskRecordwithTaskkey:ctaskkey Createdatetime:ccreatedatetime Assignedby:cassignedby Assignedto:cassignedto AssignedbyUsername:cassignedbyusername AssignedtoUsername:cassignedtousername Followupdatetime:cfollowupdatetime Taskname:ctaskname Remarks:cremarks Status:cstatus Action:@""]];
                    }else if ([[[jsontaskrecords objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"tasktoother"] && showtasktoother){
                        [TaskToOthersArray addObject:[[TaskRecord alloc]initTaskRecordwithTaskkey:ctaskkey Createdatetime:ccreatedatetime Assignedby:cassignedby Assignedto:cassignedto AssignedbyUsername:cassignedbyusername AssignedtoUsername:cassignedtousername Followupdatetime:cfollowupdatetime Taskname:ctaskname Remarks:cremarks Status:cstatus Action:@""]];
                    }else if ([[[jsontaskrecords objectAtIndex:i] objectForKey:@"type"] isEqualToString:@"allothertask"] && showallothertask){
                        [AllOtherTaskArray addObject:[[TaskRecord alloc]initTaskRecordwithTaskkey:ctaskkey Createdatetime:ccreatedatetime Assignedby:cassignedby Assignedto:cassignedto AssignedbyUsername:cassignedbyusername AssignedtoUsername:cassignedtousername Followupdatetime:cfollowupdatetime Taskname:ctaskname Remarks:cremarks Status:cstatus Action:@""]];
                    }
                }
                
                shownotaskrecord=MyTaskArray.count+TaskToOthersArray.count+AllOtherTaskArray.count==0;
                

            }*/
        
        if ([option isEqualToString:@"All"] ||[option isEqualToString:@"Chart"]) {
            enrollmentcountrecordsdataset=[[NSMutableArray alloc]init];
            for (int i=0; i<jsonenrollmentcountrecords.count; i++){
                NSString * type=[[jsonenrollmentcountrecords objectAtIndex:i] objectForKey:@"type"];
                NSInteger count=[[[jsonenrollmentcountrecords objectAtIndex:i] objectForKey:@"count"] integerValue];
                
                NSMutableArray *yVal = [[NSMutableArray alloc] init];
                [yVal addObject:[[BarChartDataEntry alloc]initWithX:i y:count]];
                BarChartDataSet *dataset=[[BarChartDataSet alloc]initWithEntries:yVal label:type];
                [enrollmentcountrecordsdataset addObject:dataset];
            }
            
            paidrecordsdataset=[[NSMutableArray alloc]init];
            totalpaid=0;
            for (int i=0; i<jsonpaidrecords.count; i++){
                NSString * paidmethod=[[jsonpaidrecords objectAtIndex:i] objectForKey:@"paidmethod"];
                float paidamount=[[[jsonpaidrecords objectAtIndex:i] objectForKey:@"paidamount"] floatValue];
                totalpaid+=paidamount;
                
                NSMutableArray *yVal = [[NSMutableArray alloc] init];
                [yVal addObject:[[BarChartDataEntry alloc]initWithX:i y:paidamount]];
                BarChartDataSet *dataset=[[BarChartDataSet alloc]initWithEntries:yVal label:paidmethod];
                [paidrecordsdataset addObject:dataset];
            }
        }
            
            if([option isEqualToString:@"Slide"] || [option isEqualToString:@"All"]){
                SlideArray=[[NSMutableArray alloc]init];
                for (int i=0; i<jsonsliderecords.count; i++) {
                    
                    NSString * filename=[[jsonsliderecords objectAtIndex:i] objectForKey:@"filename"];
                    NSString * centerkey=[[jsonsliderecords objectAtIndex:i] objectForKey:@"centerkey"];
                    NSString * title=[[jsonsliderecords objectAtIndex:i] objectForKey:@"title"];
                    NSString * postdate=[[jsonsliderecords objectAtIndex:i] objectForKey:@"postdate"];
                    NSString * typekey=[[jsonsliderecords objectAtIndex:i] objectForKey:@"typekey"];
                    NSString * type=[[jsonsliderecords objectAtIndex:i] objectForKey:@"type"];
                    NSString * width=[[jsonsliderecords objectAtIndex:i] objectForKey:@"width"];
                    NSString * height=[[jsonsliderecords objectAtIndex:i] objectForKey:@"height"];
                    NSString * hn_expiry_date=[[jsonsliderecords objectAtIndex:i] objectForKey:@"hn_expiry_date"];
                    BOOL editable=[[[jsonsliderecords objectAtIndex:i] objectForKey:@"editable"] isEqualToString:@"Yes"];
                    NSString * filetype=[[jsonsliderecords objectAtIndex:i] objectForKey:@"filetype"];
                    NSString * thumbnailurl=[[jsonsliderecords objectAtIndex:i] objectForKey:@"thumbnailurl"];
                    NSString * fileurl=[[jsonsliderecords objectAtIndex:i] objectForKey:@"fileurl"];
//                    if ([filetype isEqualToString:@"pdf"]) {
//                        title=[MyClass getLocalFileNameWithFullFileName:filename];
//                    }
                    
                    [SlideArray addObject:[[SlidePhotoRecord alloc]initSlidePhotoRecordwithcenterkey:centerkey type:type typekey:typekey filename:filename title:title postdate:postdate width:width height:height hn_expiry_date:hn_expiry_date editable:editable filetype:filetype thumbnailurl:thumbnailurl fileurl:fileurl]];
                }
                [SlideArray addObject:[[SlidePhotoRecord alloc]init]];
            }
        }
    }];
    
    
    [MyClass loadingindicatorwithoption:@"stop" color:nil];
    for (id object in [NotificationsTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
    
    for (id object in [StatusTable subviews]) {
        if ([object isKindOfClass:[UIRefreshControl class]]) {
            [(UIRefreshControl *)object endRefreshing];break;
        }
    }
    
    if (result) {
        todaylabel.text=[MyClass convertToNSStringWithNSDate:displaydate ToDateFormat:@"EEEE, d MMMM yyyy" Translate:YES];
        if ([option isEqualToString:@"All"]) {
            reloadbutton.hidden=YES;
            [NotificationsTable reloadData];
            [StatusTable reloadData];
            //slideStack.hidden=SlideArray.count==0;
            //[self.view layoutIfNeeded];
            [[slideScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            slideScrollView.contentSize=CGSizeMake(slidewidth, slideheight*SlideArray.count);
            [slideScrollView setContentOffset:CGPointMake(0, 0)];
            [self moveSlideWindowWithPageIndex:0 ScrollView:slideScrollView];
        }else if ([option isEqualToString:@"Notification"]) {
            [NotificationsTable reloadData];
        }else if ([option isEqualToString:@"Chart"]) {
            [StatusTable reloadData];
        }else if ([option isEqualToString:@"Slide"]){
            //slideStack.hidden=SlideArray.count==0;
            [self.view layoutIfNeeded];
            [[slideScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            slideScrollView.contentSize=CGSizeMake(slidewidth, slideheight*SlideArray.count);
            [slideScrollView setContentOffset:CGPointMake(0, 0)];
            [self moveSlideWindowWithPageIndex:0 ScrollView:slideScrollView];
        }
        
        if (latestwhatsnewbuild > [[MyClass getlocaldbwithparameter:@"lastwhatsnewbuild"] integerValue]) {
            [MyClass updatelocaldbwithparameter:@"lastwhatsnewbuild" value:[@(latestwhatsnewbuild) stringValue]];
            WhatsNewViewController *viewcontroller = (WhatsNewViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"WhatsNewViewController"];
            viewcontroller.delegate=self;
            viewcontroller.modalPresentationStyle = UIModalPresentationFormSheet;
            [self presentViewController:viewcontroller animated:YES completion: nil];
        }
        
    }else{
        displaydate=olddisplaydate;
        reloadbutton.hidden=!todaylabel.text?NO:YES;
        //[MyClass showconnectionlostdialogbox];
    }
    
    mainstackview.hidden=NO;
    
    return result;
}

-(void) closewhatsnewwindowwithviewcontroller:(UIViewController *)view
{
    [view dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) closecalendar
{
    calendarOpen=NO;
    [self.mainSlideMenu enableSlidePanGestureForLeftMenu];
    [UIView animateWithDuration:0.3 animations:^{
        [self updateCalendarPanelConstraints];
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){masterviewbutton.hidden=YES;}];
}


-(void) opencalendar:(id)sender
{
    [self.mainSlideMenu disableSlidePanGestureForLeftMenu];

    [calendarview refreshviewwithoption:@"start"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [calendarview scrollToSelectedDateWithSelectedDateArray:[[NSMutableArray alloc]initWithObjects:[MyClass convertToNSStringWithNSDate:displaydate DateFormat:@"dd-MMM-yyyy"], nil] ScrollToDate:nil  instructorselected:@"All"];
        [calendarview refreshviewwithoption:@"stop"];
    });
    
    [UIView animateWithDuration:0.3 animations:^{
        calendarOpen=YES;
        [self updateCalendarPanelConstraints];
        [self.view layoutIfNeeded];
        masterviewbutton.hidden=NO;
    } completion:nil];
}

-(void) previousday:(id)sender
{
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    olddisplaydate=displaydate;
    displaydate=[displaydate dateByAddingTimeInterval:-60*60*24];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self retrieveNotificationRecordWithOption:@"All"]) {
            return ;
        }
    });
    
}


-(void) nextday:(id)sender
{
    //[ainotification startAnimating];
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    olddisplaydate=displaydate;
    displaydate=[displaydate dateByAddingTimeInterval:60*60*24];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self retrieveNotificationRecordWithOption:@"All"]) {
            return ;
        }
    });
}



-(void) returncalendarselecteddatearray:(NSMutableArray *)selecteddatearray makeuptimearray:(NSArray *)makeuptimearray
{
    [self closecalendar];
    
    if (![[MyClass convertToNSStringWithNSDate:displaydate DateFormat:@"dd-MMM-yyyy"] isEqualToString:[selecteddatearray firstObject]]) {
        [MyClass loadingindicatorwithoption:@"start" color:@"white"];
        olddisplaydate=displaydate;
        displaydate=[MyClass convertToNSDateWithDate:[selecteddatearray firstObject] DateFormat:@"dd-MMM-yyyy"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self closecalendar];
            if (![self retrieveNotificationRecordWithOption:@"All"]) {
                return ;
            }
        });
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (tableView==NotificationsTable) {
        return shownonotificationrecord?1:8;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView==NotificationsTable) {
        if(shownonotificationrecord){
            return 30;
        }else if (section==0) {
            if (LastClassArray.count==0 || !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showlastclass) {
                return CGFLOAT_MIN;
            }else{
                return 30;
            }
        }else if (section==1){
            if (FirstClassArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showfirstclass) {
                return CGFLOAT_MIN;
            }else{
                return 30;
            }
        }else if (section==2){
            if (OutstandingArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showoutstandingclass) {
                return CGFLOAT_MIN;
            }else{
                return 30;
            }
        }else if (section==3){
            if (PendingRenewalArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showpendingrenewalclass) {
                return CGFLOAT_MIN;
            }else{
                return 30;
            }
        }else if (section==4){
            if (AssessmentClassArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showassessclass) {
                return CGFLOAT_MIN;
            }else{
                return 30;
            }
        }else if (section==5){
            if (TrialClassArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showtrialclass) {
                return CGFLOAT_MIN;
            }else{
                return 30;
            }
        }else if (section==6){
            if (MakeupClassArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showmakeupclass) {
                return CGFLOAT_MIN;
            }else{
                return 30;
            }
        }else{//} if (section==7){
            if (AbsentClassArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showabsentclass) {
                return CGFLOAT_MIN;
            }else{
                return 30;
            }
        }
    }
    
    return CGFLOAT_MIN;;

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (tableView==NotificationsTable) {
        if(shownonotificationrecord){
            return 20;
        }else if (section==0) {
            if (LastClassArray.count==0 || !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showlastclass) {
                return CGFLOAT_MIN;
            }else{
                return 20;
            }
        }else if (section==1){
            if (FirstClassArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showfirstclass) {
                return CGFLOAT_MIN;
            }else{
                return 20;
            }
        }else if (section==2){
            if (OutstandingArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showoutstandingclass) {
                return CGFLOAT_MIN;
            }else{
                return 20;
            }
        }else if (section==3){
            if (PendingRenewalArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showpendingrenewalclass) {
                return CGFLOAT_MIN;
            }else{
                return 20;
            }
        }else if (section==4){
            if (AssessmentClassArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showassessclass) {
                return CGFLOAT_MIN;
            }else{
                return 20;
            }
        }else if (section==5){
            if (TrialClassArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showtrialclass) {
                return CGFLOAT_MIN;
            }else{
                return 20;
            }
        }else if (section==6){
            if (MakeupClassArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showmakeupclass) {
                return CGFLOAT_MIN;
            }else{
                return 20;
            }
        }else{// if (section==7){
            if (AbsentClassArray.count==0|| !((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showabsentclass) {
                return CGFLOAT_MIN;
            }else{
                return 20;
            }
        }
    }
    
    return CGFLOAT_MIN;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView==NotificationsTable) {
        if (shownonotificationrecord) {
            return 1;
        }else if (section==0) {
            if (((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showlastclass) {
                return LastClassArray.count;
            }else{
                return 0;
            }
        }else if (section==1){
            if (((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showfirstclass) {
                return FirstClassArray.count;
            }else{
                return 0;
            }
        }else if (section==2){
            if (((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showoutstandingclass) {
                return OutstandingArray.count;
            }else{
                return 0;
            }
        }else if (section==3){
            if (((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showpendingrenewalclass) {
                return PendingRenewalArray.count;
            }else{
                return 0;
            }
        }else if (section==4){
            if (((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showassessclass) {
                return AssessmentClassArray.count;
            }else{
                return 0;
            }
        }else if (section==5){
            if (((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showtrialclass) {
                return TrialClassArray.count;
            }else{
                return 0;
            }
        }else if (section==6){
            if (((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showmakeupclass) {
                return MakeupClassArray.count;
            }else{
                return 0;
            }
        }else{//} if (section==7){
            if (((Staff *)[MyClass returnstaffrecordwithusername:globalvariables.username]).showabsentclass) {
                return AbsentClassArray.count;
            }else{
                return 0;
            }
        }
    }else if (tableView==StatusTable){
          return StatusTableRowArray.count;
    }
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyTableViewCell *cell;
    
    NotificationRecord *notificationrecordobject;
    
    df.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    
    if (tableView==NotificationsTable) {

        
        if(shownonotificationrecord){
            static NSString *blankcell = @"blankcell";
            cell=[tableView dequeueReusableCellWithIdentifier:blankcell];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:blankcell];
            }
            
            cell.label1.text=[MyClass returntitlewithtitle:@"No Record"];
            
        }else{
            
            static NSString *type2cell = @"type2cell";
            cell=[tableView dequeueReusableCellWithIdentifier:type2cell];
            
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:type2cell];
            }
            
            
            if (indexPath.section==0) {
                notificationrecordobject=[LastClassArray objectAtIndex:indexPath.row];
                
                cell.label2.text=notificationrecordobject.subjectcode;
                cell.label3.text=notificationrecordobject.classdatetime;
                cell.label4.text=[self returnSubjectNameWithNotificationRecord:notificationrecordobject];
                cell.label5.hidden=YES;
                cell.button1.hidden=YES;
                cell.label3.hidden=NO;

                
            }else if (indexPath.section==1) {
                notificationrecordobject=[FirstClassArray objectAtIndex:indexPath.row];
                
                cell.label2.text=notificationrecordobject.subjectcode;
                cell.label3.text=notificationrecordobject.classdatetime;
                cell.label4.text=[self returnSubjectNameWithNotificationRecord:notificationrecordobject];
                cell.label5.hidden=YES;
                cell.button1.hidden=YES;
                cell.label3.hidden=NO;
                
            }else if (indexPath.section==2) {
                notificationrecordobject=[OutstandingArray objectAtIndex:indexPath.row];
                
                //cell.label3.text=[NSString stringWithFormat:@"$%@",notificationrecordobject.value];
                
                if ([notificationrecordobject.category isEqualToString:@"class"]) {
                    cell.label2.text=notificationrecordobject.subjectcode;
                    cell.label4.text=[self returnSubjectNameWithNotificationRecord:notificationrecordobject];
                }else{
                    cell.label2.text=notificationrecordobject.productcode;
                    cell.label4.text=[MyClass returnproductnamewithproductcode:notificationrecordobject.productcode centerkey:globalvariables.centerrecord.centerkey];
                }
                cell.label3.hidden=YES;
                cell.label5.hidden=YES;
                cell.button1.hidden=NO;
                
                [cell.button1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"red_background.png"]]];
                cell.button1.layer.cornerRadius=4;
                cell.button1.layer.masksToBounds=YES;
                [cell.button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                cell.button1.tag=indexPath.row;
                [cell.button1 setTitle:[NSString stringWithFormat:@"$%@",notificationrecordobject.value] forState:UIControlStateNormal];
                [cell.button1 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                [cell.button1 addTarget:self action:@selector(outstandingbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if (indexPath.section==3){
                notificationrecordobject=[PendingRenewalArray objectAtIndex:indexPath.row];
                
                cell.label3.hidden=NO;
                cell.label2.text=notificationrecordobject.subjectcode;
                cell.label3.text=[MyClass returndateformatwithdate:[MyClass convertDateFormatWithDate:notificationrecordobject.classdatetime FromDateFormat:@"dd MMM HH:mm" ToDateFormat:@"dd MMM"] dateformat:@"dd MMM"];
                cell.label4.text=[self returnSubjectNameWithNotificationRecord:notificationrecordobject];
                cell.label5.hidden=NO;
                cell.label5.text=[MyClass convertDateFormatWithDate:notificationrecordobject.classdatetime FromDateFormat:@"dd MMM HH:mm" ToDateFormat:@"HH:mm"];
                cell.button1.hidden=NO;
                [cell.button1 setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tiffany_background.png"]]];
                cell.button1.layer.cornerRadius=4;
                cell.button1.layer.masksToBounds=YES;
                [cell.button1 setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                cell.button1.tag=indexPath.row;
                [cell.button1 setTitle:[MyClass returntitlewithtitle:@"Drop"] forState:UIControlStateNormal];
                [cell.button1 removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
                [cell.button1 addTarget:self action:@selector(dropbuttonpressed:) forControlEvents:UIControlEventTouchUpInside];
                
            }else if (indexPath.section==4) {
                notificationrecordobject=[AssessmentClassArray objectAtIndex:indexPath.row];
                
                cell.label3.hidden=NO;
                cell.label2.text=notificationrecordobject.subjectcode;
                cell.label3.text=notificationrecordobject.classdatetime;
                cell.label4.text=[self returnSubjectNameWithNotificationRecord:notificationrecordobject];
                cell.label5.hidden=YES;
                cell.button1.hidden=YES;
                
            }else if (indexPath.section==5) {
                notificationrecordobject=[TrialClassArray objectAtIndex:indexPath.row];
                
                cell.label3.hidden=NO;
                cell.label2.text=notificationrecordobject.subjectcode;
                cell.label3.text=notificationrecordobject.classdatetime;
                cell.label4.text=[self returnSubjectNameWithNotificationRecord:notificationrecordobject];
                cell.label5.hidden=YES;
                cell.button1.hidden=YES;
                
            }else if (indexPath.section==6) {
                notificationrecordobject=[MakeupClassArray objectAtIndex:indexPath.row];
                
                cell.label3.hidden=NO;
                cell.label2.text=notificationrecordobject.subjectcode;
                cell.label3.text=notificationrecordobject.classdatetime;
                cell.label4.text=[self returnSubjectNameWithNotificationRecord:notificationrecordobject];
                cell.label5.hidden=YES;
                cell.button1.hidden=YES;
                
            }else if (indexPath.section==7){
                notificationrecordobject=[AbsentClassArray objectAtIndex:indexPath.row];
                
                cell.label3.hidden=NO;
                cell.label2.text=notificationrecordobject.subjectcode;
                cell.label3.text=notificationrecordobject.classdatetime;
                cell.label4.text=[self returnSubjectNameWithNotificationRecord:notificationrecordobject];
                cell.label5.hidden=YES;
                cell.button1.hidden=YES;
                
            }
            
            
            [self loadNotificationImageWithNotificationRecord:notificationrecordobject ImageView:cell.imageview1];
            if ([notificationrecordobject.type isEqualToString:@"student"]) {
                cell.label1.text=[MyClass returnStudentnameWithStudentkey:notificationrecordobject.studentkey option:@"full"];
            }else{
                cell.label1.text=[MyClass returnLeadnameWithLeadkey:notificationrecordobject.studentkey option:@"full"];
            }
        }
        
        cell.separator1.hidden=indexPath.row==[self tableView:tableView numberOfRowsInSection:indexPath.section]-1;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.7];

    }else if (tableView==StatusTable){
        if ([[StatusTableRowArray objectAtIndex:indexPath.row] isEqualToString:@"button"]) {
            
            static NSString *buttoncell = @"buttoncell";
            cell=[tableView dequeueReusableCellWithIdentifier:buttoncell];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:buttoncell];
            }

            [cell.button1 addTarget:self action:@selector(unreadmessagebuttonpressed) forControlEvents:UIControlEventTouchUpInside];
            [cell.button2 addTarget:self action:@selector(pendingrequestbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
            [cell.button3 addTarget:self action:@selector(myoutstandingtaskbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
            [cell.button4 addTarget:self action:@selector(outstandingtasktootherbuttonpressed) forControlEvents:UIControlEventTouchUpInside];
            [cell.button5 addTarget:self action:@selector(autorenewfailurebuttonpressed) forControlEvents:UIControlEventTouchUpInside];

            cell.label1.text=[MyClass returntitlewithtitle:@"New Message"];
            cell.label3.text=[MyClass returntitlewithtitle:@"Pending Request"];
            cell.label5.text=[MyClass returntitlewithtitle:@"My Outstanding Task"];
            cell.label7.text=[MyClass returntitlewithtitle:@"Outstanding Task to Other"];
            cell.label9.text=[MyClass returntitlewithtitle:@"Auto Renew Failure"];
            
            cell.label2.text=[NSString stringWithFormat:@"%ld",(long)globalvariables.unreadmessagecount];
            cell.label4.text=[NSString stringWithFormat:@"%ld",(long)pendingrequestcount];
            cell.label6.text=[NSString stringWithFormat:@"%ld",(long)myoutstandingtaskcount];
            cell.label8.text=[NSString stringWithFormat:@"%ld",(long)outstandingtasktoothercount];
            cell.label10.text=[NSString stringWithFormat:@"%ld",(long)autorenewfailurecount];
            
            cell.view1.hidden=![globalvariables.centerrecord.iparentleavemode isEqualToString:@"Request"];
            cell.view2.hidden=!globalvariables.centerrecord.enableautobatchrenew;
            if (!cell.view1.hidden && !cell.view2.hidden) {
                cell.layoutconstraint1.constant=200;
            }else{
                cell.layoutconstraint1.constant=135;
            }
            
        }else if ([[StatusTableRowArray objectAtIndex:indexPath.row] isEqualToString:@"periodsegment"]) {
            
            static NSString *periodsegmentcell = @"periodsegmentcell";
            cell=[tableView dequeueReusableCellWithIdentifier:periodsegmentcell];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:periodsegmentcell];
            }

            if ([period isEqualToString:@"Day"]) {
                cell.segmentedcontrol1.selectedSegmentIndex=0;
                cell.label1.text=[MyClass convertToNSStringWithNSDate:displaydate ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
            }else if ([period isEqualToString:@"Week"]) {
                cell.segmentedcontrol1.selectedSegmentIndex=1;
                NSString *firstday=[MyClass convertToNSStringWithNSDate:[MyClass returnfirstdayofweekwithdate:displaydate] ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                NSString *lastday=[MyClass convertToNSStringWithNSDate:[MyClass returnlastdayofweekwithdate:displaydate] ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                cell.label1.text=[NSString stringWithFormat:@"%@ - %@",firstday,lastday];
            }else if ([period isEqualToString:@"Month"]) {
                cell.segmentedcontrol1.selectedSegmentIndex=2;
                NSString *firstday=[MyClass convertToNSStringWithNSDate:[MyClass returnfirstdayofmonthwithdate:displaydate] ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                NSString *lastday=[MyClass convertToNSStringWithNSDate:[MyClass returnlastdayofmonthwithdate:displaydate] ToDateFormat:@"dd-MMM-yyyy" Translate:YES];
                cell.label1.text=[NSString stringWithFormat:@"%@ - %@",firstday,lastday];
            }
            
            cell.segmentedcontrol1.tintColor=[UIColor whiteColor];
            [cell.segmentedcontrol1 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateSelected];
            [cell.segmentedcontrol1 setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
            [cell.segmentedcontrol1 setTitle:[MyClass returntitlewithtitle:@"Day"] forSegmentAtIndex:0];
            [cell.segmentedcontrol1 setTitle:[MyClass returntitlewithtitle:@"Week"] forSegmentAtIndex:1];
            [cell.segmentedcontrol1 setTitle:[MyClass returntitlewithtitle:@"Month"] forSegmentAtIndex:2];
            [cell.segmentedcontrol1 addTarget:self action:@selector(periodselected:) forControlEvents:UIControlEventValueChanged];
            
        }else if ([[StatusTableRowArray objectAtIndex:indexPath.row] isEqualToString:@"enrollmentbarchart"]) {
            static NSString *barchartcell = @"barchartcell";
            cell=[tableView dequeueReusableCellWithIdentifier:barchartcell];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:barchartcell];
            }
            
            cell.label1.text=[MyClass returntitlewithtitle:@"Enrollment Count"];
            [MyClass setupBarLineChartView:cell.barchartview1 DataSets:enrollmentcountrecordsdataset ChartType:@"Enrollment Count"];
            

        }else if ([[StatusTableRowArray objectAtIndex:indexPath.row] isEqualToString:@"paymentbarchart"]) {
            static NSString *barchartcell = @"barchartcell";
            cell=[tableView dequeueReusableCellWithIdentifier:barchartcell];
            
            if (cell == nil) {
                cell = [[MyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:barchartcell];
            }

            cell.label1.text=[NSString stringWithFormat:@"%@ - %@",[MyClass returntitlewithtitle:@"Payment Received"],[currencyformatter stringFromNumber:[NSNumber numberWithFloat:totalpaid]]];
            [MyClass setupBarLineChartView:cell.barchartview1 DataSets:paidrecordsdataset ChartType:@"Payment Received"];
            //[MyClass setupPieChartView:cell.piechartview1 DataEntryValues:nil ChartTitle:@""];
        }
    }
    return cell;
}


-(void) loadNotificationImageWithNotificationRecord:(NotificationRecord *)object ImageView:(UIImageView *)imageview
{
    NSString *image;
    NSString *gender;
    Student *studentobject;
    Lead *leadobject;
    
    if ([object.type isEqualToString:@"student"]) {
        studentobject=[MyClass returnstudentwithstudentkey:object.studentkey];
        image=studentobject.image;
        gender=studentobject.gender;
    }else{
        leadobject=[MyClass returnleadwithleadkey:object.studentkey];
        image=leadobject.image;
        gender=leadobject.gender;
        
    }
    
    imageview.layer.cornerRadius=imageview.frame.size.width/2;
    imageview.layer.masksToBounds=YES;
    
    [MyClass downloadImageWithImageview:imageview gender:gender type:object.type typekey:object.studentkey image:image async:YES];
}

-(NSString *) returnSubjectNameWithNotificationRecord:(NotificationRecord *)object
{
    NSString *subject=[MyClass returnsubjectnamewithsubject_shortname:object.subjectcode centerkey:globalvariables.centerrecord.centerkey];
    if (![object.schedulekey isEqualToString:@""]) {
        NSString *schedulename=[MyClass returnschedulenamewithsubject_shortname:object.subjectcode schedulekey:object.schedulekey centerkey:globalvariables.centerrecord.centerkey];
        if (schedulename) {
            return [NSString stringWithFormat:@"%@ (%@)",subject,schedulename];
        }else{
            return subject;
        }
    }else{
        return subject;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==NotificationsTable) {
        NotificationRecord *notificationrecordobject=[[NotificationRecord alloc]init];
        
        if (indexPath.section==0){
            if(!shownonotificationrecord){
                notificationrecordobject=[LastClassArray objectAtIndex:indexPath.row];
                
                AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
                mainVC.leftMenu.prepareforsegue=TRUE;
                mainVC.leftMenu.sourceview=@"notification";
                mainVC.leftMenu.studentprofile_studentkey=notificationrecordobject.studentkey;
                mainVC.leftMenu.studentprofile_submenu=2;
                mainVC.leftMenu.studentprofile_classkeys=[[ClassKeys alloc]initClassKeysWithEnrollmentkey:notificationrecordobject.enrollmentkey Classkey:notificationrecordobject.classkey];
                //mainVC.leftMenu.studentprofile_enrollmentkey=notificationrecordobject.enrollmentkey;
                //mainVC.leftMenu.studentprofile_classkey=notificationrecordobject.classkey;
                globalvariables.leftmenuindex=@"1";
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
                
            }
            

        }else if (indexPath.section==1){
            notificationrecordobject=[FirstClassArray objectAtIndex:indexPath.row];

            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.sourceview=@"notification";
            mainVC.leftMenu.studentprofile_studentkey=notificationrecordobject.studentkey;
            mainVC.leftMenu.studentprofile_submenu=2;
            mainVC.leftMenu.studentprofile_classkeys=[[ClassKeys alloc]initClassKeysWithEnrollmentkey:notificationrecordobject.enrollmentkey Classkey:notificationrecordobject.classkey];
            //mainVC.leftMenu.studentprofile_enrollmentkey=notificationrecordobject.enrollmentkey;
            //mainVC.leftMenu.studentprofile_classkey=notificationrecordobject.classkey;
            globalvariables.leftmenuindex=@"1";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
        }else if (indexPath.section==2) {
            notificationrecordobject=[OutstandingArray objectAtIndex:indexPath.row];
            
            //StudentInformationViewController *studentinformationviewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformationViewController"];
            
            
            if ([notificationrecordobject.category isEqualToString:@"class"]) {
                //[studentinformationviewcontroller gotoStudentProfilewithStudentkey:notificationrecordobject.studentkey submenu:@"Enrollment" enrollmentkey:@"" classkey:@""];
                
                AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
                mainVC.leftMenu.prepareforsegue=TRUE;
                mainVC.leftMenu.sourceview=@"notification";
                mainVC.leftMenu.studentprofile_studentkey=notificationrecordobject.studentkey;
                mainVC.leftMenu.studentprofile_submenu=1;
                mainVC.leftMenu.studentprofile_classkeys=[[ClassKeys alloc]initClassKeysWithEnrollmentkey:@"" Classkey:@""];
                //mainVC.leftMenu.studentprofile_enrollmentkey=notificationrecordobject.enrollmentkey;
                //mainVC.leftMenu.studentprofile_classkey=notificationrecordobject.classkey;
                globalvariables.leftmenuindex=@"1";
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
                
                
            }else{
                //[studentinformationviewcontroller gotoStudentProfilewithStudentkey:notificationrecordobject.studentkey submenu:@"Sales" enrollmentkey:notificationrecordobject.enrollmentkey classkey:notificationrecordobject.classkey];
                
                AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
                mainVC.leftMenu.prepareforsegue=TRUE;
                mainVC.leftMenu.sourceview=@"notification";
                mainVC.leftMenu.studentprofile_studentkey=notificationrecordobject.studentkey;
                mainVC.leftMenu.studentprofile_submenu=3;
                mainVC.leftMenu.studentprofile_classkeys=[[ClassKeys alloc]initClassKeysWithEnrollmentkey:@"" Classkey:@""];
                globalvariables.leftmenuindex=@"1";
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
            }
            
            //globalvariables.lastviewcontroller=(NSString *)studentinformationviewcontroller;
            //[self presentViewController:studentinformationviewcontroller animated:YES completion:nil];
            
            //[self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
        }else if (indexPath.section==3){
            notificationrecordobject=[PendingRenewalArray objectAtIndex:indexPath.row];
            
            /*StudentInformationViewController *studentinformationviewcontroller=[self.storyboard instantiateViewControllerWithIdentifier:@"StudentInformationViewController"];
            [studentinformationviewcontroller gotoStudentProfilewithStudentkey:notificationrecordobject.studentkey submenu:@"Enrollment" enrollmentkey:notificationrecordobject.enrollmentkey classkey:@""];
            
            globalvariables.lastviewcontroller=(NSString *)studentinformationviewcontroller;
            [self presentViewController:studentinformationviewcontroller animated:YES completion:nil];
            
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];*/
            
            
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.sourceview=@"notification";
            mainVC.leftMenu.studentprofile_studentkey=notificationrecordobject.studentkey;
            mainVC.leftMenu.studentprofile_submenu=1;
            mainVC.leftMenu.studentprofile_classkeys=[[ClassKeys alloc]initClassKeysWithEnrollmentkey:notificationrecordobject.enrollmentkey Classkey:@""];
            globalvariables.leftmenuindex=@"1";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
            
            
        }else if (indexPath.section==4){
            notificationrecordobject=[AssessmentClassArray objectAtIndex:indexPath.row];

            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.assessment_selecteddtkey=notificationrecordobject.classkey;
            globalvariables.leftmenuindex=@"10";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
            
            
        }else if (indexPath.section==5){
            notificationrecordobject=[TrialClassArray objectAtIndex:indexPath.row];
            
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.assessment_selecteddtkey=notificationrecordobject.classkey;
            globalvariables.leftmenuindex=@"10";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:10 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
            
            
        }else if (indexPath.section==6){
            notificationrecordobject=[MakeupClassArray objectAtIndex:indexPath.row];
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.sourceview=@"notification";
            mainVC.leftMenu.studentprofile_studentkey=notificationrecordobject.studentkey;
            mainVC.leftMenu.studentprofile_submenu=2;
            mainVC.leftMenu.studentprofile_classkeys=[[ClassKeys alloc]initClassKeysWithEnrollmentkey:notificationrecordobject.enrollmentkey Classkey:notificationrecordobject.classkey];
            //mainVC.leftMenu.studentprofile_enrollmentkey=notificationrecordobject.enrollmentkey;
            //mainVC.leftMenu.studentprofile_classkey=notificationrecordobject.classkey;
            globalvariables.leftmenuindex=@"1";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
            
        }else if (indexPath.section==7){
            notificationrecordobject=[AbsentClassArray objectAtIndex:indexPath.row];

            
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            mainVC.leftMenu.sourceview=@"notification";
            mainVC.leftMenu.studentprofile_studentkey=notificationrecordobject.studentkey;
            mainVC.leftMenu.studentprofile_submenu=2;
            mainVC.leftMenu.studentprofile_classkeys=[[ClassKeys alloc]initClassKeysWithEnrollmentkey:notificationrecordobject.enrollmentkey Classkey:notificationrecordobject.classkey];
            //mainVC.leftMenu.studentprofile_enrollmentkey=notificationrecordobject.enrollmentkey;
            //mainVC.leftMenu.studentprofile_classkey=notificationrecordobject.classkey;
            globalvariables.leftmenuindex=@"1";
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
            
            
        }else if (indexPath.section>7){
            AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
            mainVC.leftMenu.prepareforsegue=TRUE;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
            [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
        }
        
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==NotificationsTable) {
        
        if ((int)[tableView rectForHeaderInSection:section].size.height==0) {
            return nil;
        }
        
        CGFloat headerWidth = tableView.frame.size.width;
        CGFloat headerHeight = [tableView rectForHeaderInSection:section].size.height;
        NotificationsRoundedMaskView *headerView = [[NotificationsRoundedMaskView alloc] initWithFrame:CGRectMake(0, 0, headerWidth, headerHeight)];
        headerView.roundedCorners = UIRectCornerTopLeft | UIRectCornerTopRight;
        headerView.cornerRadius = 10;
        headerView.backgroundColor=[UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.8];
        
        
        UIImageView *myImage=[[UIImageView alloc]init];
        CGFloat size=headerHeight-10;
        myImage.frame=CGRectMake(5, 5, size, size);
        myImage.layer.cornerRadius=3;
        myImage.layer.masksToBounds=YES;
        
        
        UILabel *myLabel = [[UILabel alloc] init];
        CGFloat countWidth = MIN(140.0, headerWidth * 0.35);
        if (countWidth < 0) {
            countWidth = 0;
        }
        CGFloat countX = MAX(headerWidth - countWidth - 8.0, 0);
        CGFloat titleWidth = MAX(countX - 8.0 - 30.0, 0);
        myLabel.frame = CGRectMake(30, 0, titleWidth, headerHeight);
        myLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        myLabel.font = [UIFont boldSystemFontOfSize:16];
        
        UILabel *myCount = [[UILabel alloc] initWithFrame:CGRectMake(countX, 0, countWidth, headerHeight)];
        myCount.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleHeight;
        myCount.textAlignment=NSTextAlignmentRight;
        myCount.font = [UIFont systemFontOfSize:12];
        
        if (shownonotificationrecord){
            myLabel.text = [MyClass returntitlewithtitle:@"Notification"];
            myCount.text=@"";
            [myImage setImage:[UIImage imageNamed:@"notifications_icon.png"]];
        }else if (section==0){
            myLabel.text = [MyClass returntitlewithtitle:@"Last Class"];
            myCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)LastClassArray.count];
            [myImage setImage:[UIImage imageNamed:@"lastclass_icon.png"]];
        }else if (section==1){
            myLabel.text = [MyClass returntitlewithtitle:@"First Class"];
            myCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)FirstClassArray.count];
            [myImage setImage:[UIImage imageNamed:@"firstclass_icon.png"]];
        }else if (section==2){
            myLabel.text = [MyClass returntitlewithtitle:@"Outstanding Payment"];
            //myCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)OutstandingArray.count];
            myCount.text=[NSString stringWithFormat:@"%@(%@)",[@(OutstandingArray.count) stringValue],[currencyformatter stringFromNumber:[NSNumber numberWithFloat:totaloutstanding]]];
            [myImage setImage:[UIImage imageNamed:@"paymentinformation_icon.png"]];
        }else if (section==3){
            myLabel.text = [MyClass returntitlewithtitle:@"Pending Renewal"];
            myCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)PendingRenewalArray.count];
            [myImage setImage:[UIImage imageNamed:@"classrenewal_icon.png"]];
        }else if (section==4){
            myLabel.text = [MyClass returntitlewithtitle:@"Assessment Class"];
            myCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)AssessmentClassArray.count];
            [myImage setImage:[UIImage imageNamed:@"assessmenttrialclass_icon.png"]];
        }else if (section==5){
            myLabel.text = [MyClass returntitlewithtitle:@"Trial Class"];
            myCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)TrialClassArray.count];
            [myImage setImage:[UIImage imageNamed:@"assessmenttrialclass_icon.png"]];
        }else if (section==6){
            myLabel.text = [MyClass returntitlewithtitle:@"Makeup Class"];
            myCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)MakeupClassArray.count];
            [myImage setImage:[UIImage imageNamed:@"makeup_icon.png"]];
        }else if (section==7){
            myLabel.text = [MyClass returntitlewithtitle:@"Absent Class"];
            myCount.text=[NSString stringWithFormat:@"%lu",(unsigned long)AbsentClassArray.count];
            [myImage setImage:[UIImage imageNamed:@"absent_icon.png"]];
        }else if (section==8){
            myLabel.text = [MyClass returntitlewithtitle:@"Messages"];
            myCount.text=@"";
            [myImage setImage:[UIImage imageNamed:@"messagecenter_icon.png"]];
        }
        
        //[myCount sizeToFit];
        //myCount.frame = CGRectMake([tableView rectForHeaderInSection:section].size.width-(myCount.frame.size.width+13)-10, 4, myCount.frame.size.width+13, [tableView rectForHeaderInSection:section].size.height-8);
        
        [headerView addSubview:myImage];
        myLabel.textColor=[UIColor blackColor];
        [headerView addSubview:myLabel];
        myCount.textColor=[UIColor darkGrayColor];
        [headerView addSubview:myCount];
        
        return headerView;
        
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (tableView==NotificationsTable){
        
    
    if ((int)[tableView rectForFooterInSection:section].size.height==0) {
        return nil;
    }else{
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [tableView rectForFooterInSection:section].size.height)];
        footerView.backgroundColor=[UIColor clearColor];
        
        NotificationsRoundedMaskView *footer = [[NotificationsRoundedMaskView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, [tableView rectForFooterInSection:section].size.height-10)];
        footer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        footer.roundedCorners = UIRectCornerBottomLeft | UIRectCornerBottomRight;
        footer.cornerRadius = 10;
        footer.backgroundColor=[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.7];
        
        
        [footerView addSubview:footer];
        return footerView;
    }
    }
    return nil;
}

/*
-(void)checkprivilege
{
    showallothertasks=((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).showallothertaskinnotificationview;
}*/




- (IBAction)slidebutton:(id)sender {
    [self.mainSlideMenu openLeftMenu];
}

- (IBAction)reloadpage:(id)sender {
    
    //[ainotification startAnimating];
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (![self retrieveNotificationRecordWithOption:@"All"]) {
            return ;
        }
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



-(void) switchcenterbuttonpressed
{
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    
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
        [self reloadPageWithFirstLoad:NO];
        
    }
}


-(void) reloadPageWithFirstLoad:(BOOL)firstload
{
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [MyClass getLatestDataSetv2withParameters:@"calendar,languagetitle,subject,product,staff,classroom,centersettings,userroleandprivilege,student,lead,arcode" Centerkeys:globalvariables.centerrecord.centerkey completionBlock:^(BOOL succeeded, BOOL viewingcentersdeleted, BOOL nocenteravailable, BOOL newupdateavailable){
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
                    [self updateStatusTableRowArray];
                    [MyClass showDuePaymentReminderWithViewController:self];
                    [MyClass showResetPasswordReminder:self];
                    [MyClass retrievemenuimagewithasync:NO];
                    [MyClass updatecenterkey];
                    

                    [MyClass downloadImageWithImageview:backgroundcenterimage gender:nil type:@"centerimage" typekey:globalvariables.centerrecord.launchimage_landscape image:@"Yes" async:YES];

                    [self refreshlanguage];

                    if (![self retrieveNotificationRecordWithOption:@"All"]) {
                        return;
                    }
                    
                    subjectarray=[[NSMutableArray alloc]initWithArray:[MyClass retrievesubjectinformationwithstatus:@"All" category:@"All" flushcachedata:NO]];
                    if (!subjectarray) {
                        return;
                    }
                    
                    productarray=[[NSMutableArray alloc]initWithArray:[MyClass retrieveproductinformationwithcategory:@"All" status:@"All" flushcachedata:NO]];
                    if (!productarray) {
                        return;
                    }
                }
            });
        }];
    });
}

-(void) dropbuttonpressed:(UIButton *)sender
{
    UIAlertController *dropclassalert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Drop Class"] message:[MyClass returntitlewithtitle:@"Are you sure to drop the class?"] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NotificationRecord *object=[PendingRenewalArray objectAtIndex:sender.tag];
        
        //drop all enrollments
        NSString *strURL;
        strURL=[NSString stringWithFormat:@"%@?centerdb=%@&centerkey=%@&action=dropclass&status=%@&studentkey=%@&subject=%@&schedulekey=%@&enrollmentkey=%@&updatedby=%@",globalvariables.generalphpfullpath,globalvariables.centerrecord.centerdb,globalvariables.centerrecord.centerkey,@"Drop",object.studentkey,[MyClass enurlstring:object.subjectcode],object.schedulekey,object.enrollmentkey,globalvariables.username];
        
        __block BOOL result=FALSE;
        [MyClass callGETwithURL:strURL completionBlock:^(BOOL succeeded, NSData *data) {
            if (succeeded) {
                result=TRUE;
            }
        }];
        
        /*
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:[NSURL URLWithString:[MyClass dcurlstring:[strURL stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]]] completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (!error) {
                result=TRUE;
                
            }else{
                [MyClass showconnectionlostdialogbox];
            }
            
            dispatch_semaphore_signal(semaphore);
        }] resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);*/
        
        if (result) {
            [self retrieveNotificationRecordWithOption:@"All"];
        }/*else{
            [MyClass showconnectionlostdialogbox];
        }*/
    }];
    
    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [dropclassalert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [dropclassalert addAction:OKAction];
    [dropclassalert addAction:CancelAction];
    
    [self presentViewController:dropclassalert animated:YES completion:nil];
}

-(void) moveSlideWindowWithPageIndex:(NSInteger)pageindex ScrollView:(UIScrollView *)scrollview
{
    NSInteger windowsize=10;
    
    NSInteger righttodelete=pageindex+windowsize+1;
    if (righttodelete<SlideArray.count) {
        slideView *slideview=[scrollview viewWithTag:righttodelete];
        if (slideview && [slideview isKindOfClass:[slideView class]]) {
            [[slideview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [slideview removeFromSuperview];
        }
    }
    
    NSInteger lefttodelete=pageindex-windowsize-1;
    if (lefttodelete>=0) {
        slideView *slideview=[scrollview viewWithTag:lefttodelete];
        if (slideview && [slideview isKindOfClass:[slideView class]]) {
            [[slideview subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [slideview removeFromSuperview];
        }
    }
    
    
    for (NSInteger i=pageindex-windowsize; i<=pageindex+windowsize; i++) {
        if (i>=0 && i<SlideArray.count) {
            slideView *slideview=[scrollview viewWithTag:i];
            
            if (!slideview || ![slideview isKindOfClass:[slideView class]]) {
                SlidePhotoRecord *slidephotoobject=[SlideArray objectAtIndex:i];
                slideView *slideview=[[slideView alloc]initWithFrame:CGRectMake(0, slideheight*i,  slidewidth,slideheight) SlidePhotoRecord:slidephotoobject SlideIndex:i];
                slideview.delegate=self;
                //slideview.tag=i;
                [scrollview addSubview:slideview];
                
            }
        }
    }
}

-(void) selectedSlideIndex:(NSInteger)slideindex
{
    fullscreenphotoviewcontroller.index=slideindex;
    NSMutableArray *fullscreenslidearray=[[NSMutableArray alloc]init];
    for (int i=0; i<SlideArray.count-1; i++) {
        [fullscreenslidearray addObject:SlideArray[i]];
    }
    
    fullscreenphotoviewcontroller.fileArray=fullscreenslidearray;
    [self presentViewController:fullscreenphotoviewcontroller animated:YES completion: nil];
}

-(void) closeFullScreenPhotoViewWithIndex:(NSInteger)index
{
    runviewdidappear=FALSE;
    float offsety=index*slideheight;
    if (slideScrollView.contentSize.height-offsety<slideScrollView.frame.size.height) {
        offsety=slideScrollView.contentSize.height-slideScrollView.frame.size.height;
    }
    if (offsety>0) {
        slideScrollView.contentOffset=CGPointMake(0, offsety);
    }
    
    runviewdidappear=FALSE;
    [[slideScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self moveSlideWindowWithPageIndex:index ScrollView:slideScrollView];
    [fullscreenphotoviewcontroller dismissViewControllerAnimated:YES completion:nil];
}


-(void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView==slideScrollView) {
        if (slideheight <= 0) {
            return;
        }
        NSInteger pageIndex=round(scrollView.contentOffset.y/slideheight);
        if (pageIndex!=lastscrollindex) {
            lastscrollindex=pageIndex;
            [self moveSlideWindowWithPageIndex:pageIndex ScrollView:scrollView];
            
        }
        
    }
}

-(void) deleteSlideWithIndex:(NSInteger)slideindex
{
    SlidePhotoRecord *sliderecord=[SlideArray objectAtIndex:slideindex];
    
    [MyClass loadingindicatorwithoption:@"start" color:@"white"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if ([sliderecord.type isEqualToString:@"message"]) {
            NSMutableDictionary *dictionary= [[NSMutableDictionary alloc]init];
            
            [dictionary setValue:@"updateoutboxmessage2" forKey:@"postaction"];
            [dictionary setValue:((CenterRecord *)[MyClass returncenterrecordwithcenterkey:sliderecord.centerkey]).centerdb forKey:@"centerdb"];
            [dictionary setValue:sliderecord.centerkey forKey:@"centerkey"];
            [dictionary setValue:@"No" forKey:@"hotnews"];
            [dictionary setValue:sliderecord.typekey forKey:@"outboxmessagekey"];
            [dictionary setValue:@"Edit" forKey:@"action"];
            
            __block BOOL result=FALSE;
            __block NSData *returndata;
            
            [MyClass callMultipartPOSTwithDict:dictionary photoArray:nil completionBlock:^(id responseObject, NSError *error) {
                if (!error) {
                    result=TRUE;
                    returndata=responseObject;
                }
            }];
            
            if (result) {
                //NSString *resString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                //NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                [self retrieveNotificationRecordWithOption:@"Slide"];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }else{
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                [MyClass showconnectionlostdialogbox];
            }

        }else{
            NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
            [dictionary setValue:@"updateclassphotoinformation2" forKey:@"postaction"];
            [dictionary setValue:globalvariables.username forKey:@"updatedby"];
            [dictionary setValue:((CenterRecord *)[MyClass returncenterrecordwithcenterkey:sliderecord.centerkey]).centerdb forKey:@"centerdb"];
            [dictionary setValue:sliderecord.centerkey forKey:@"centerkey"];
            [dictionary setValue:sliderecord.typekey forKey:@"classphotokey"];
            [dictionary setValue:@"No" forKey:@"hotnews"];
            
            
            __block BOOL result=FALSE;
            [MyClass callPOSTwithDict:dictionary completionBlock:^(BOOL succeeded, NSData *data) {
                if (succeeded) {
                    result=TRUE;
                }
            }];
            
            if (result) {
                [self retrieveNotificationRecordWithOption:@"Slide"];
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
            }else{
                [MyClass loadingindicatorwithoption:@"stop" color:nil];
                //[MyClass showconnectionlostdialogbox];
            }
        }
    });
}

-(void) addSlideWithButton:(UIButton *)button
{
    if (((PrivilegeRecord *)[MyClass returnprivilegerecordwithcenterkey:globalvariables.centerrecord.centerkey]).publishinphotocorner) {
        NSMutableArray *itemsarray=[[NSMutableArray alloc]initWithObjects:@"Message",@"Photo Corner", nil];
        [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"Hot News" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(180, 40*2) View:self Button:button ItemsArray:itemsarray Title:nil];
    }else{
        //Message only
        [self addMessageSlide];
    }
}

-(void) addMessageSlide
{
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MessagePopoverViewController *messagepopover = (MessagePopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"MessagePopoverViewController"];
        messagepopover.delegate=self;
        messagepopover.MessageTableMode=@"Add";
        messagepopover.CallingSource=@"NotificationView";
        
        
        NSMutableArray *allstudentarray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];
        NSMutableArray *allleadarray=[[NSMutableArray alloc]initWithArray:[globalvariables.leadlistarray allValues]];
        NSMutableArray *allstaffarrayincludingself=[[NSMutableArray alloc]initWithArray:[globalvariables.stafflistarray allValues]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@",globalvariables.centerrecord.centerkey];
        allstudentarray=[[NSMutableArray alloc]initWithArray:[allstudentarray filteredArrayUsingPredicate:predicate]];
        allleadarray=[[NSMutableArray alloc]initWithArray:[allleadarray filteredArrayUsingPredicate:predicate]];
        
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@ and self.status contains[c] %@ and self.username !=%@ and self.role!=%@",globalvariables.centerrecord.centerkey,@"Yes",globalvariables.username,@"System"];
        
        
        NSMutableArray *allstaffarray=[[NSMutableArray alloc]initWithArray:[allstaffarrayincludingself filteredArrayUsingPredicate:predicate2]];
        
        allstudentarray = [NSMutableArray arrayWithArray:[allstudentarray sortedArrayUsingDescriptors:[MyClass returnstudentnamesortdescriptorarray]]];
        allleadarray = [NSMutableArray arrayWithArray:[allleadarray sortedArrayUsingDescriptors:[MyClass returnleadnamesortdescriptorarray]]];
        
        NSSortDescriptor *sortbyfirstname = [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSSortDescriptor *sortbylastname = [NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = @[sortbyfirstname,sortbylastname];
        allstaffarray = [NSMutableArray arrayWithArray:[allstaffarray sortedArrayUsingDescriptors:sortDescriptors]];
        allstaffarrayincludingself = [NSMutableArray arrayWithArray:[allstaffarrayincludingself sortedArrayUsingDescriptors:sortDescriptors]];
        NSMutableArray *allstaffgrouparray=[MyClass returnStaffGroupArrayIncludeAll:YES];
        NSMutableArray *staffgrouparray=[self returnStaffGroupArrayExcludedAllWithAllStaffGroupArray:allstaffgrouparray];
        
        
        
        messagepopover.allleadarray=allleadarray;
        messagepopover.allstudentarray=allstudentarray;
        messagepopover.allstaffarray=allstaffarray;
        messagepopover.staffgrouparray=staffgrouparray;

        if (![messagepopover InitializeField]) {
            return;
        }
        
        [self placeChildInSideWindow:messagepopover];
        [ailoadindicator stopAnimating];
        ailoadindicator.hidden=YES;
    });
}

-(void) returnPickerValueWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex SelectedItems:(NSMutableArray *)selecteditems Button:(UIButton *)button
{
    if ([datatype isEqualToString:@"Hot News"]){
        
        NSString *result=[selecteditems firstObject];
        if ([result isEqualToString:@"Message"]) {
            button.tag=0;
            addclassphotobutton=button;
            [self popupaddphotodialoguebox];
//            [self addMessageSlide];
        }else if ([result isEqualToString:@"Photo Corner"]){
            button.tag=1;
            addclassphotobutton=button;
            [self popupaddphotodialoguebox];
        }
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
        NotificationRecord *obj=[OutstandingArray objectAtIndex:dataindex];
        UIAlertController *changealert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Payment"] message:[MyClass returntitlewithtitle:@"Are you sure to proceed with payment?"] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            
            
            [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self quickPayWithStudentKey:obj.studentkey paidMethod:[selecteditems firstObject] enrollmentkey:[obj.enrollmentkey isEqualToString:@""]?nil:obj.enrollmentkey saleskey:[obj.saleskey isEqualToString:@""]?nil:obj.saleskey];
            });
        }];
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"Cancel"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        }];
        
        [changealert addAction:OKAction];
        [changealert addAction:CancelAction];
        
        [self presentViewController:changealert animated:YES completion:nil];
    }
}

-(void) addclassphotofromsource:(NSString *)source
{
//    ClassPhotoRecord *workingClassPhoto=[[ClassPhotoRecord alloc]init];
//    workingClassPhoto.filearray=[[NSMutableArray alloc]init];
    NSMutableArray *filearray=[[NSMutableArray alloc]init];
    
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
            mypopovercontroller.sourceView=addclassphotobutton;
            mypopovercontroller.sourceRect=addclassphotobutton.bounds;
            
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
                mypopovercontroller.sourceView=addclassphotobutton;
                mypopovercontroller.sourceRect=addclassphotobutton.bounds;
                
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
                                        if (addclassphotobutton.tag==1) {
                                            [filearray addObject:[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:globalvariables.centerrecord.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.height Height:image.size.height FileType:@"image" InternalURL:imageURL FileName:@"" ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"class" title:@""]];
                                        }else{
                                            [filearray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.width Height:image.size.height FileType:@"image" InternalURL:imageURL FileName:@"" ThumbnailURL:@""]];
                                        }
                                    }
                                }
                            }];
                        }
                        
                        
                        [MyClass loadingindicatorwithoption:@"stop" color:@""];
                        [bspicker dismissViewControllerAnimated:YES completion:^{
                            if (fileexceedsize) {
                                UIAlertController *erroralert = [UIAlertController alertControllerWithTitle:[MyClass returntitlewithtitle:@"Image"] message:[MyClass returnreplacedtitlewithtitle:@"File cannot exceed %@1MB limit" replacementarray:@[[@(globalvariables.centerrecord.maxuploadfilesize) stringValue]]] preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction *OKAction = [UIAlertAction actionWithTitle:[MyClass returntitlewithtitle:@"OK"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                    [erroralert dismissViewControllerAnimated:YES completion:nil];
                                }];
                                
                                [erroralert addAction:OKAction];
                                [self presentViewController:erroralert animated:YES completion:nil];
                            }else{
                                if (addclassphotobutton.tag==1) {
                                    ClassPhotoRecord *workingClassPhoto=[[ClassPhotoRecord alloc]init];
                                    workingClassPhoto.filearray=filearray;
                                    [self showclassphotopopoverviewwithclassphotorecord:workingClassPhoto mode:@"add"];
                                }else{
                                    OutboxMessageRecord *messageobject=[[OutboxMessageRecord alloc]init];
                                    messageobject.photoarray=filearray;
                                    [self showmessagepopoverviewwithmessagerecord:messageobject];
                                }
                            }
                        }];
                        
                    });
                } completion:^{
                    [MyClass loadingindicatorwithoption:@"stop" color:@""];
                } selectLimitReached:nil];
                
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
                mypopovercontroller.sourceView=addclassphotobutton;
                mypopovercontroller.sourceRect=addclassphotobutton.bounds;
                
                [self presentViewController:imagepicker animated:YES completion:nil];
            }
        }
    });
}
-(void) popupaddphotodialoguebox
{
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    NSMutableArray *ItemsArray=[[NSMutableArray alloc]init];
    if (hasCamera) {
        [ItemsArray addObject:@"Take Photo"];
        [ItemsArray addObject:@"Record Video"];
        [ItemsArray addObject:@"Photo Library"];
        [ItemsArray addObject:@"Video Library"];
        [ItemsArray addObject:@"Document"];
    }else{
        [ItemsArray addObject:@"Photo Library"];
        [ItemsArray addObject:@"Video Library"];
        [ItemsArray addObject:@"Document"];
    }
    
    [MyClass showPickerViewControllerWithSelectedItems:nil DataType:@"attachment" DataIndex:0 ShowSearchBar:NO BottomMode:nil PreferredContentSize:CGSizeMake(220, 80) View:self Button:addclassphotobutton ItemsArray:ItemsArray Title:nil];

}


-(void) pickerBottomButtonPressedWithDataType:(NSString *)datatype DataIndex:(NSInteger)dataindex BottomMode:(NSString *)bottommode SelectedItems:(NSMutableArray *)selecteditems
{
    if ([datatype isEqualToString:@"quickpay"]) {
        if ([bottommode isEqualToString:@"Add to Folder"]) {
            NSIndexPath *indexPath =[NSIndexPath indexPathForRow:dataindex inSection:0];

            NotificationRecord *obj=[OutstandingArray objectAtIndex:indexPath.row];
            if ([obj.category isEqualToString:@"class"]) {
                NSArray *enrollmentkeys=[obj.enrollmentkey componentsSeparatedByString:@","];
                for (int i=0; i<enrollmentkeys.count; i++) {
                    NSString *enrollmentkey=[enrollmentkeys objectAtIndex:i];
                    if (![globalvariables.documentfolder.classpaymentarray containsObject:enrollmentkey]) {
                        [globalvariables.documentfolder.classpaymentarray addObject:enrollmentkey];
                    }
                    
                    if (![globalvariables.documentfolder.classinvoicearray containsObject:enrollmentkey]) {
                        [globalvariables.documentfolder.classinvoicearray addObject:enrollmentkey];
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys containsObject:enrollmentkey]) {
                        [globalvariables.documentfolder.defaultcheckedclasspaymentenrollmentkeys addObject:enrollmentkey];
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys containsObject:enrollmentkey]) {
                        [globalvariables.documentfolder.defaultcheckedclassinvoiceenrollmentkeys addObject:enrollmentkey];
                    }
                }
            }else{
                NSArray *saleskeys=[obj.saleskey componentsSeparatedByString:@","];
                for (int i=0; i<saleskeys.count; i++) {
                    NSString *salekey=[saleskeys objectAtIndex:i];
                    if (![globalvariables.documentfolder.salespaymentarray containsObject:salekey]) {
                        [globalvariables.documentfolder.salespaymentarray addObject:salekey];
                    }
                    
                    if (![globalvariables.documentfolder.salesinvoicearray containsObject:salekey]) {
                        [globalvariables.documentfolder.salesinvoicearray addObject:salekey];
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys containsObject:salekey]) {
                        [globalvariables.documentfolder.defaultcheckedsalespaymentsaleskeys addObject:salekey];
                    }
                    
                    if (![globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys containsObject:salekey]) {
                        [globalvariables.documentfolder.defaultcheckedsalesinvoicesaleskeys addObject:salekey];
                    }
                }
            }

            [self showAddToDocumentFolderAnimationWithTableview:NotificationsTable IndexPath:indexPath];
            [self refreshdocumentfoldercount];
                
        }
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
        [self retrieveNotificationRecordWithOption:@"All"];
        [self refreshdocumentfoldercount];
        /*if(globalvariables.centerrecord.autosendereceipt){
            NSDictionary *dict=[MyClass loaddocumentfolderarraywithpaymethod:paymethod returndata:returndata];
            [MyClass autoSendeReceiptWithClassReceiptArray:dict[@"documentfolderclassreceiptarray"] SalesReceiptArray:dict[@"documentfoldersalesreceiptarray"]];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        }else{*/
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        //}
    }else{
        [MyClass showconnectionlostdialogbox];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    }
}


- (void) refreshdocumentfoldercount
{
    if ((int)globalvariables.documentfolder.classinvoicearray.count+(int)globalvariables.documentfolder.classreceiptarray.count+(int)globalvariables.documentfolder.salesinvoicearray.count+(int)globalvariables.documentfolder.salesreceiptarray.count+(int)globalvariables.documentfolder.salespaymentarray.count+(int)globalvariables.documentfolder.classpaymentarray.count>0) {
        documentfoldercountlabel.hidden=NO;
    }else{
        documentfoldercountlabel.hidden=YES;
    }
    documentfolderbutton.hidden=NO;
    
}

-(void) refreshdocumentfoldercountnumber
{
    [self refreshdocumentfoldercount];
}

-(void) refreshDocumentFolderPresentingViewScreen
{
    [self retrieveNotificationRecordWithOption:@"All"];
}

-(void) dismissDocumentFolderPopover
{
    [self closesidewindow];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    runviewdidappear=FALSE;
    //[imagepicker dismissViewControllerAnimated:YES completion:nil];
    
//    ClassPhotoRecord *workingClassPhoto=[[ClassPhotoRecord alloc]init];
    NSMutableArray *filearray=[[NSMutableArray alloc]init];
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
                [picker dismissViewControllerAnimated:YES completion:nil];
                
                if(addclassphotobutton.tag==1){
                    [filearray addObject:[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:globalvariables.centerrecord.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.height Height:image.size.height FileType:@"video" InternalURL:videoURL FileName:@"" ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"class" title:@""]];
                    ClassPhotoRecord *workingClassPhoto=[[ClassPhotoRecord alloc]init];
                    workingClassPhoto.filearray=filearray;
                    [self showclassphotopopoverviewwithclassphotorecord:workingClassPhoto mode:@"add"];
                }else{
                    [filearray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.width Height:image.size.height FileType:@"video" InternalURL:videoURL FileName:@"" ThumbnailURL:@""]];
                    OutboxMessageRecord *messageobject=[[OutboxMessageRecord alloc]init];
                    messageobject.photoarray=filearray;
                    [self showmessagepopoverviewwithmessagerecord:messageobject];
                }
                
            
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
                NSURL *imageURL=[MyClass returnInternalURLforNSData:imageData Filename:@"image"];
                [picker dismissViewControllerAnimated:YES completion:nil];
                [MyClass loadingindicatorwithoption:@"stop" color:@""];
                if (addclassphotobutton.tag==1) {
                    [filearray addObject:[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:globalvariables.centerrecord.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.height Height:image.size.height FileType:@"image" InternalURL:imageURL FileName:@"" ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"class" title:@""]];
                    ClassPhotoRecord *workingClassPhoto=[[ClassPhotoRecord alloc]init];
                    workingClassPhoto.filearray=filearray;
                    [self showclassphotopopoverviewwithclassphotorecord:workingClassPhoto mode:@"add"];
                }else{
                    [filearray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:[[UIImageView alloc]initWithImage:image] Width:image.size.width Height:image.size.height FileType:@"image" InternalURL:imageURL FileName:@"" ThumbnailURL:@""]];
                    OutboxMessageRecord *messageobject=[[OutboxMessageRecord alloc]init];
                    messageobject.photoarray=filearray;
                    [self showmessagepopoverviewwithmessagerecord:messageobject];
                }
            });
        }
    }
}

-(void) showclassphotopopoverviewwithclassphotorecord:(ClassPhotoRecord *)photoobject mode:(NSString *)mode
{
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        ClassPhotoPopoverViewController *classphotopopover = (ClassPhotoPopoverViewController *)[self->mainStoryboard instantiateViewControllerWithIdentifier: @"ClassPhotoPopoverViewController"];
        classphotopopover.delegate=self;
        classphotopopover.classphotoobject=photoobject;
        classphotopopover.mode=mode;
        [self placeChildInSideWindow:classphotopopover];
        [self->ailoadindicator stopAnimating];
        self->ailoadindicator.hidden=YES;
    });
    
}

-(void) showmessagepopoverviewwithmessagerecord:(OutboxMessageRecord *)messageobject
{
    [self startsidewindowanimationwithwidth:320];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        MessagePopoverViewController *messagepopover = (MessagePopoverViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"MessagePopoverViewController"];
        messagepopover.delegate=self;
        messagepopover.MessageTableMode=@"Add";
        messagepopover.CallingSource=@"NotificationView";
        messagepopover.OMessageRecordObject=messageobject;
        
        NSMutableArray *allstudentarray=[[NSMutableArray alloc]initWithArray:[globalvariables.studentlistarray allValues]];
        NSMutableArray *allleadarray=[[NSMutableArray alloc]initWithArray:[globalvariables.leadlistarray allValues]];
        NSMutableArray *allstaffarrayincludingself=[[NSMutableArray alloc]initWithArray:[globalvariables.stafflistarray allValues]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@",globalvariables.centerrecord.centerkey];
        allstudentarray=[[NSMutableArray alloc]initWithArray:[allstudentarray filteredArrayUsingPredicate:predicate]];
        allleadarray=[[NSMutableArray alloc]initWithArray:[allleadarray filteredArrayUsingPredicate:predicate]];
        
        NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"SELF.centerkey = %@ and self.status contains[c] %@ and self.username !=%@ and self.role!=%@",globalvariables.centerrecord.centerkey,@"Yes",globalvariables.username,@"System"];
        
        
        NSMutableArray *allstaffarray=[[NSMutableArray alloc]initWithArray:[allstaffarrayincludingself filteredArrayUsingPredicate:predicate2]];
        
        allstudentarray = [NSMutableArray arrayWithArray:[allstudentarray sortedArrayUsingDescriptors:[MyClass returnstudentnamesortdescriptorarray]]];
        allleadarray = [NSMutableArray arrayWithArray:[allleadarray sortedArrayUsingDescriptors:[MyClass returnleadnamesortdescriptorarray]]];
        
        NSSortDescriptor *sortbyfirstname = [NSSortDescriptor sortDescriptorWithKey:@"firstname" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSSortDescriptor *sortbylastname = [NSSortDescriptor sortDescriptorWithKey:@"lastname" ascending:YES selector:@selector(localizedStandardCompare:)];
        NSArray *sortDescriptors = @[sortbyfirstname,sortbylastname];
        allstaffarray = [NSMutableArray arrayWithArray:[allstaffarray sortedArrayUsingDescriptors:sortDescriptors]];
        allstaffarrayincludingself = [NSMutableArray arrayWithArray:[allstaffarrayincludingself sortedArrayUsingDescriptors:sortDescriptors]];
        NSMutableArray *allstaffgrouparray=[MyClass returnStaffGroupArrayIncludeAll:YES];
        NSMutableArray *staffgrouparray=[self returnStaffGroupArrayExcludedAllWithAllStaffGroupArray:allstaffgrouparray];
        
        
        
        messagepopover.allleadarray=allleadarray;
        messagepopover.allstudentarray=allstudentarray;
        messagepopover.allstaffarray=allstaffarray;
        messagepopover.staffgrouparray=staffgrouparray;

        if (![messagepopover InitializeField]) {
            return;
        }
        
        [self placeChildInSideWindow:messagepopover];
        [ailoadindicator stopAnimating];
        ailoadindicator.hidden=YES;
    });
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    runviewdidappear=FALSE;
    [[imagepicker presentingViewController] dismissViewControllerAnimated:YES completion:nil];
    //[[mypopovercontroller presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url {
    
    runviewdidappear=false;
    NSMutableArray *filearray=[[NSMutableArray alloc]init];
    
    //    ClassPhotoRecord *workingClassPhoto=[[ClassPhotoRecord alloc]init];
//    workingClassPhoto.filearray=[[NSMutableArray alloc]init];
    
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
                if (addclassphotobutton.tag==1) {
                    [filearray addObject:[[PhotoCornerFileRecord alloc]initPhotoCornerFileRecordWithCenterKey:globalvariables.centerrecord.centerkey PhotoCornerFileKey:nil FileURL:nil ImageView:[[UIImageView alloc]initWithImage:chosenImage] Width:chosenImage.size.width Height:chosenImage.size.height FileType:@"pdf" InternalURL:url FileName:[url lastPathComponent] ThumbnailURL:@"" Action:@"Add" DownloadFileType:@"class" title:@""]];
                    ClassPhotoRecord *workingClassPhoto=[[ClassPhotoRecord alloc]init];
                    workingClassPhoto.filearray=filearray;
                    [self showclassphotopopoverviewwithclassphotorecord:workingClassPhoto mode:@"add"];
                }else{
                    [filearray addObject:[[MessagePhotoRecord alloc]initMessagePhotoRecordwithMessagePhotoKey:nil MessagePhotoURL:nil ImageView:[[UIImageView alloc]initWithImage:chosenImage] Width:chosenImage.size.height Height:chosenImage.size.height FileType:@"pdf" InternalURL:url FileName:[url lastPathComponent] ThumbnailURL:@""]];
                    OutboxMessageRecord *messageobject=[[OutboxMessageRecord alloc]init];
                    messageobject.photoarray=filearray;
                    [self showmessagepopoverviewwithmessagerecord:messageobject];
                }
                
                
                
            }
        }
        
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}


-(void) dismissClassPhotoPopoverVCWithReload:(BOOL)reload ScrollToTop:(BOOL)scrolltotop
{
    [self closesidewindow];
    if (reload) {
        [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self retrieveNotificationRecordWithOption:@"Slide"];
            [MyClass loadingindicatorwithoption:@"stop" color:nil];
        });
    }
}

-(NSMutableArray *)returnStaffGroupArrayExcludedAllWithAllStaffGroupArray:(NSMutableArray *)allstaffgrouparray;
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

-(void) startsidewindowanimationwithwidth:(float)width
{
    if (!mainWindow) {
        mainWindow = [self notificationsSceneWindow];
    }
    sideWindowRequestedWidth = width;
    sideWindowOpen = width > 0;
    sidewindowview.hidden = width <= 0;
    CGFloat panelWidth = [self clampedSideWindowWidth:width];
    ailoadindicator.hidden=NO;
    ailoadindicator.center = CGPointMake(panelWidth/2-7.5,mainWindow.bounds.size.height/2-7.5);
    [ailoadindicator startAnimating];
    [self adjustpresentingviewwidthwithwidth:panelWidth];
}

-(void) adjustpresentingviewwidthwithwidth:(CGFloat)width
{
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
    
    sideWindowAnimating = YES;
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
        sideWindowAnimating = NO;
        if (width==0) {
            sideWindowOpen = NO;
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
    sidewindowviewclosebutton.frame=mainWindow.bounds;
    
}

-(void) closesidewindow
{
    sideWindowOpen=NO;
    [self adjustpresentingviewwidthwithwidth:0];
}

-(void) dismissMessagePopoverVC
{
    [self closesidewindow];
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self retrieveNotificationRecordWithOption:@"Slide"];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

-(void) unreadmessagebuttonpressed
{
    if(![MyClass showMenuItemwithObject:@"Message Center"]){
        return;
    }
    
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    mainVC.leftMenu.prepareforsegue=TRUE;
    globalvariables.leftmenuindex=@"6";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
}

-(void) pendingrequestbuttonpressed
{
    if(![MyClass showMenuItemwithObject:@"Task and Request"]){
        return;
    }
    
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    mainVC.leftMenu.prepareforsegue=TRUE;
    mainVC.leftMenu.taskassignment_selectedview=@"1";
    globalvariables.leftmenuindex=@"8";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
}

-(void) myoutstandingtaskbuttonpressed
{
    if(![MyClass showMenuItemwithObject:@"Task and Request"]){
        return;
    }
    
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    mainVC.leftMenu.prepareforsegue=TRUE;
    mainVC.leftMenu.taskassignment_selectedtaskview=@"0";
    mainVC.leftMenu.taskassignment_selectedtaskkey=@"";
    
    globalvariables.leftmenuindex=@"8";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
}

-(void) outstandingtasktootherbuttonpressed
{
    if(![MyClass showMenuItemwithObject:@"Task and Request"]){
        return;
    }
    
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    mainVC.leftMenu.prepareforsegue=TRUE;
    mainVC.leftMenu.taskassignment_selectedtaskview=@"1";
    mainVC.leftMenu.taskassignment_selectedtaskkey=@"";
    
    globalvariables.leftmenuindex=@"8";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:8 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
}

-(void) autorenewfailurebuttonpressed
{
    if(![MyClass showMenuItemwithObject:@"Course Renewal"]){
        return;
    }
    
    AMSlideMenuMainViewController *mainVC = [self mainSlideMenu];
    mainVC.leftMenu.prepareforsegue=TRUE;
    mainVC.leftMenu.renewal_selectedview=@"1";
    globalvariables.leftmenuindex=@"4";
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    [mainVC openContentViewControllerForMenu:AMSlideMenuLeft atIndexPath:indexPath];
}

-(void) periodselected:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex==0) {
        period=@"Day";
    }else if (sender.selectedSegmentIndex==1) {
        period=@"Week";
    }else if (sender.selectedSegmentIndex==2) {
        period=@"Month";
    }
    [MyClass updatelocaldbwithparameter:@"chartperiod" value:period];
    
    [MyClass loadingindicatorwithoption:@"start" color:@"lightgray"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self retrieveNotificationRecordWithOption:@"Chart"];
        [MyClass loadingindicatorwithoption:@"stop" color:nil];
    });
}

-(void) donotrunviewdidappear
{
    runviewdidappear=FALSE;
}

-(void) outstandingbuttonpressed:(UIButton *)sender
{
    [MyClass showPickerViewControllerWithSelectedItems:[[NSMutableArray alloc]init] DataType:@"quickpay" DataIndex:sender.tag ShowSearchBar:NO BottomMode:@"Add to Folder" PreferredContentSize:CGSizeMake(220, 448) View:self Button:sender ItemsArray:nil Title:nil];
}

@end
